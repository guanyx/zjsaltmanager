<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmFmProjCfg.aspx.cs" Inherits="FM_FmIntf_frmFmProjCfg" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html>
<head>
<title>�������ݽ�����������</title><meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<link rel="stylesheet" type="text/css" href="../../ext3/resources/css/ext-all.css" />
<script type="text/javascript" src="../../ext3/adapter/ext/ext-base.js"></script>
<script type="text/javascript" src="../../ext3/ext-all.js"></script>
</head>
<body>
<div id='toolbar'></div>
<div id='searchForm'></div>
<div id='dataGrid'></div>

</body>
<%= getComboBoxStore() %>
<script type="text/javascript">
Ext.BLANK_IMAGE_URL = "../../ext3/resources/images/default/s.gif"; 
Ext.onReady(function(){
var saveType;
/*------ʵ��toolbar�ĺ��� start---------------*/
var Toolbar = new Ext.Toolbar({
	renderTo:"toolbar",
	items:[{
		text:"����",
		icon:"../../Theme/1/images/extjs/customer/add16.gif",
		handler:function(){
		    saveType = 'add';
		    openAddCfgWin();
		}
		},'-',{
		text:"�༭",
		icon:"../../Theme/1/images/extjs/customer/edit16.gif",
		handler:function(){
		    saveType = 'save';
		    modifyCfgWin();
		}
		},'-',{
		text:"ɾ��",
		icon:"../../Theme/1/images/extjs/customer/delete16.gif",
		handler:function(){
		    deleteCfg();
		}
		},'-',{
		text:"�ֶ�����",
		icon:"../../Theme/1/images/extjs/customer/view16.gif",
		handler:function(){
		    viewCfg();
		}
	}]
});

/*------����toolbar�ĺ��� end---------------*/


/*------��ʼToolBar�¼����� start---------------*//*-----����Cfgʵ���ര�庯��----*/
function openAddCfgWin() {
	uploadCfgWindow.show();
}
/*-----�༭Cfgʵ���ര�庯��----*/
function modifyCfgWin() {
	var sm = gridData.getSelectionModel();
	//��ȡѡ���������Ϣ
	var selectData =  sm.getSelected();
	if(selectData == null){
		Ext.Msg.alert("��ʾ","��ѡ����Ҫ�༭����Ϣ��");
		return;
	}
	uploadCfgWindow.show();
	setFormValue(selectData);
}
/*-----ɾ��Cfgʵ�庯��----*/
/*ɾ����Ϣ*/
function deleteCfg()
{
	var sm = gridData.getSelectionModel();
	//��ȡѡ���������Ϣ
	var selectData =  sm.getSelected();
	//���û��ѡ�񣬾���ʾ��Ҫѡ��������Ϣ
	if(selectData == null){
		Ext.Msg.alert("��ʾ","��ѡ����Ҫɾ������Ϣ��");
		return;
	}
	//ɾ��ǰ�ٴ������Ƿ����Ҫɾ��
	Ext.Msg.confirm("��ʾ��Ϣ","�Ƿ����Ҫɾ��ѡ�����Ϣ��",function callBack(id){
		//�ж��Ƿ�ɾ������
		if(id=="yes")
		{
			//ҳ���ύ
			Ext.Ajax.request({
				url:'frmFmProjCfg.aspx?method=deleteCfg',
				method:'POST',
				params:{
					ProjectNo:selectData.data.ProjectNo
				},
				success: function(resp,opts){
					Ext.Msg.alert("��ʾ","����ɾ���ɹ�");
					gridData.getStore().remove(selectData);
				},
				failure: function(resp,opts){
					Ext.Msg.alert("��ʾ","����ɾ��ʧ��");
				}
			});
		}
	});
}
/*-----�ֶ��������Cfgʵ�庯��----*/
/*�ֶ��������������Ϣ*/
function viewCfg() {	
	var sm = gridData.getSelectionModel();
	//��ȡѡ���������Ϣ
	var selectData =  sm.getSelected();
	//���û��ѡ�񣬾���ʾ��Ҫѡ��������Ϣ
	if(selectData == null){
		Ext.Msg.alert("��ʾ","��ѡ����Ҫ���õ���Ϣ��");
		return;
	}
	uploadGridCfgWindow.show();
	gridField.getStore().baseParams.ProjectNo=selectData.data.ProjectNo;
	gridField.getStore().load({
	    params:{
	        limit:15,
	        start:0
	    }
	});
}

/*------ʵ��FormPanle�ĺ��� start---------------*/
var dsOrgList ;
if (dsOrgList == null) { //��ֹ�ظ�����
    dsOrgList = new Ext.data.JsonStore({
        totalProperty: "result",
        root: "root",
        url: 'frmFmProjCfg.aspx?method=getOrgList',
        fields: ['OrgId', 'OrgName']
    });
    dsOrgList.load({
        params:{
            limit:100,
            start:0
        },
     callback:function(v,p){
        var gs =Ext.getCmp('prjOrg');
        gs.setValue(<% =ZJSIG.UIProcess.ADM.UIAdmUser.OrgID(this)%>);
        gs.setDisabled(true);
     }
    });
}    

var projectCfg = new Ext.form.FormPanel({
	url:'',
	//renderTo:'divForm',
	frame:true,
	title:'',
	labelWidth:80,
	items:[
		{
			xtype:'hidden',
			fieldLabel:'�������',
			name:'ProjectNo',
			id:'ProjectNo',
			hidden:true,
			hideLabel:true
		}
,       {
			xtype:'textfield',
			fieldLabel:'��������',
			columnWidth:1,
			anchor:'95%',
			name:'ProjectName',
			id:'ProjectName'
		}
,       {
			xtype:'combo',
			fieldLabel:'��������',
			columnWidth:1,
			anchor:'95%',
			name:'BillType',
			id:'BillType',
			store:dsBillType,
			displayField:'DicsName',
			valueField:'DicsCode',
			mode:'local',
		    triggerAction:'all',
		    disabled:true,
		    value:dsBillType.getAt(0).data.DicsCode
		}
,       {
			xtype:'combo',
			fieldLabel:'�ֶηָ���',
			columnWidth:1,
			anchor:'95%',
			name:'FieldSeparator',
			id:'FieldSeparator',
			store:dsFieldSparator,
			displayField:'DicsName',
			valueField:'DicsCode',
			mode:'local',
		    triggerAction:'all',
		    editable:false
		}
,       {
			xtype:'combo',
			fieldLabel:'���ݷָ���',
			columnWidth:1,
			anchor:'95%',
			name:'BillSeparator',
			id:'BillSeparator',
			store:dsBillSparator,
			displayField:'DicsName',
			valueField:'DicsCode',
			mode:'local',
		    triggerAction:'all',
		    editable:false
		}
,		{
			xtype:'combo',
			fieldLabel:'����������֯',
			columnWidth:1,
			anchor:'95%',
			name:'ProjectOrg',
			id:'ProjectOrg',
			store:dsOrgList,
			displayField:'OrgName',
			valueField:'OrgId',
			mode:'local',
		    triggerAction:'all',
		    editable:false,
		    value:<% =ZJSIG.UIProcess.ADM.UIAdmUser.OrgID(this)%>,
		    disabled:true
		}
,       {
		    layout:'column',
		    items:[
    		{
    		    layout:'form',
    		    columnWidth:.5,
    		    items:[{
			        xtype:'combo',
			        fieldLabel:'���䷽��',			    
			        anchor:'90%',
			        name:'TransType',
			        id:'TransType',
			        store:[[0,'���ݵ���'],[1,'���ݵ���']],
			        mode:'local',
			        triggerAction:'all',
			        editable:false
			    }]
		    }
    ,		{
                layout:'form',
    		    columnWidth:.5,
    		    items:[{
			        xtype:'combo',
			        fieldLabel:'����״̬',
			        anchor:'90%',
			        name:'PStatus',
			        id:'PStatus',
			        store:[[0,'����'],[1,'����']],
			        mode:'local',
			        triggerAction:'all',
			        editable:false
			    }]
		    }
		    ]
		}
,		{
			xtype:'textarea',
			fieldLabel:'��ע',
			columnWidth:1,
			anchor:'95%',
			name:'Notes',
			id:'Notes'
		}
]
});
/*------FormPanle�ĺ������� End---------------*/

/*------��ʼ�������ݵĴ��� Start---------------*/
if(typeof(uploadCfgWindow)=="undefined"){//�������2��windows����
	uploadCfgWindow = new Ext.Window({
		id:'formwindow',
		title:'���÷���ά��'
		, iconCls: 'upload-win'
		, width: 400
		, height: 350
		, layout: 'fit'
		, plain: true
		, modal: true
		, constrain:true
		, resizable: false
		, closeAction: 'hide'
		,autoDestroy :true
		,items:projectCfg
		,buttons: [{
			text: "����"
			, handler: function() {
				saveUserData();
			}
			, scope: this
		},
		{
			text: "ȡ��"
			, handler: function() { 
				uploadCfgWindow.hide();
			}
			, scope: this
		}]});
	}
	uploadCfgWindow.addListener("hide",function(){
	    projectCfg.getForm().reset();
});

/*------��ʼ��ȡ�������ݵĺ��� start---------------*/
function saveUserData()
{
    if(saveType == 'add')
        saveType = 'addCfg';
    else if(saveType =='save')
        saveType = 'saveCfg';
	Ext.Ajax.request({
		url:'frmFmProjCfg.aspx?method='+saveType,
		method:'POST',
		params:{
			ProjectNo:Ext.getCmp('ProjectNo').getValue(),
			ProjectName:Ext.getCmp('ProjectName').getValue(),
			BillType:Ext.getCmp('BillType').getValue(),
			FieldSeparator:Ext.getCmp('FieldSeparator').getValue(),
			BillSeparator:Ext.getCmp('BillSeparator').getValue(),
			ProjectOrg:Ext.getCmp('ProjectOrg').getValue(),
			TransType:Ext.getCmp('TransType').getValue(),
			Status:Ext.getCmp('PStatus').getValue(),
			Notes:Ext.getCmp('Notes').getValue()
					},
		success: function(resp,opts){
			Ext.Msg.alert("��ʾ","����ɹ�");
			gridData.getStore().reload();
			uploadCfgWindow.hide();
		},
		failure: function(resp,opts){
			Ext.Msg.alert("��ʾ","����ʧ��");
		}
		});
		}
/*------������ȡ�������ݵĺ��� End---------------*/


/*------��ʼ��ѯ�������ݵĺ��� start---------------*/
var prjNamePanel = new Ext.form.TextField({
    
});
                    
var orgIdPanel = new Ext.form.ComboBox({  
    
});

var serchPrjform = new Ext.FormPanel({
    renderTo: 'searchForm',
    labelAlign: 'left',
    layout:'fit',
    buttonAlign: 'right',
    bodyStyle: 'padding:5px',
    frame: true,
    labelWidth: 55,
    items: [{
        layout: 'column',   //�����Ԫ��Ϊ����Ϊ�в��ַ�ʽ
        border: false,
        items: [{
            columnWidth: .32,  //����ռ�õĿ�ȣ���ʶΪ20��
            layout: 'form',
            border: false,
            items: [{
                xtype: 'combo',
                id:'prjOrg',
                name:'prjOrg',
                fieldLabel: '��֯',
                store: dsOrgList,  
                typeAhead: false,
                loadingText: 'Searching...',  
                displayField:'OrgName',
                valueField:'OrgId',
                mode:'local',
                triggerAction:'all',
                editable:false
            }]
        }, {
            columnWidth: .33,
            layout: 'form',
            border: false,
            items: [{
                style: 'margin-left:0px',
                cls: 'key',
                xtype: 'textfield',
                fieldLabel: '��������',
                name: 'prjName',
                id:'prjName',
                anchor: '90%'
                }]
        }, {
            columnWidth: .10,
            layout: 'form',
            border: false,
            items: [{ cls: 'key',
                xtype: 'button',
                text: '��ѯ',
                anchor: '50%',
                handler :function(){
                
                var prjOrg=Ext.getCmp('prjOrg').getValue();
                var prjName=Ext.getCmp('prjName').getValue();
                
                dsProjCfg.baseParams.OrgId=prjOrg;
                dsProjCfg.baseParams.ProjectName=prjName;                
                dsProjCfg.baseParams.BillType=dsBillType.getAt(0).data.DicsCode;
                dsProjCfg.load({
                            params : {
                            start : 0,
                            limit : 10
                            } });
                }
            }]
        }]
    }]
});

/*------������ѯ�������ݵĺ��� end---------------*/

/*------��ʼ�������ݵĺ��� Start---------------*/
function setFormValue(selectData)
{
	Ext.Ajax.request({
		url:'frmFmProjCfg.aspx?method=getCfg',
		params:{
			ProjectNo:selectData.data.ProjectNo
		},
	success: function(resp,opts){
		var data=Ext.util.JSON.decode(resp.responseText);
		Ext.getCmp("ProjectNo").setValue(data.ProjectNo);
		Ext.getCmp("ProjectName").setValue(data.ProjectName);
		Ext.getCmp("BillType").setValue(data.BillType);
		Ext.getCmp("FieldSeparator").setValue(data.FieldSeparator);
		Ext.getCmp("BillSeparator").setValue(data.BillSeparator);
        Ext.getCmp('ProjectOrg').setValue(data.ProjectOrg);
		Ext.getCmp("TransType").setValue(data.TransType);
		Ext.getCmp("PStatus").setValue(data.Status);
		Ext.getCmp("Notes").setValue(data.Notes);
	},
	failure: function(resp,opts){
		Ext.Msg.alert("��ʾ","��ȡ��Ϣʧ��");
	}
	});
}
/*------�������ý������ݵĺ��� End---------------*/

/*------��ʼ��ȡ���ݵĺ��� start---------------*/
var dsProjCfg = new Ext.data.Store
({
url: 'frmFmProjCfg.aspx?method=getCfgList',
reader:new Ext.data.JsonReader({
	totalProperty:'totalProperty',
	root:'root'
},[
	{		name:'ProjectNo'	},
	{		name:'ProjectName'	},
	{		name:'BillType'	},
	{		name:'FieldSeparator'	},
	{		name:'BillSeparator'	},
	{		name:'ProjectOrg'	},
	{		name:'TransType'	},
	{		name:'Status'	},
	{		name:'Notes'	},
	{		name:'OperId'	},
	{		name:'OrgId'	},
	{		name:'OwerId'	}	
	])
	,
	listeners:
	{
		scope:this,
		load:function(){
		}
	}
});

/*------��ȡ���ݵĺ��� ���� End---------------*/

/*------��ʼDataGrid�ĺ��� start---------------*/

var sm= new Ext.grid.CheckboxSelectionModel({
	singleSelect:true
});
var gridData = new Ext.grid.GridPanel({
	el: 'dataGrid',
	width:'100%',
	height:'100%',
	autoWidth:true,
	autoHeight:true,
	autoScroll:true,
	layout: 'fit',
	id: 'gridData',
	store: dsProjCfg ,
	loadMask: {msg:'���ڼ������ݣ����Ժ��'},
	sm:sm,
	cm: new Ext.grid.ColumnModel([
		sm,
		new Ext.grid.RowNumberer(),//�Զ��к�
		{
			header:'�������',
			dataIndex:'ProjectNo',
			id:'ProjectNo',
			hidden:true,
			hideable:false
		},
		{
			header:'��������',
			dataIndex:'ProjectName',
			id:'ProjectName'
		},
		{
			header:'��������',
			dataIndex:'BillType',
			id:'BillType',
			renderer: function(val, params, record) {
		        if (dsBillType.getCount() == 0) {
		            dsBillType.load();
		        }
		        dsBillType.each(function(r) {
		            if (val == r.data['DicsCode']) {
		                val = r.data['DicsName'];
		                return;
		            }
		        });
		        return val;
		    }
		},
		{
			header:'�ֶηָ���',
			dataIndex:'FieldSeparator',
			id:'FieldSeparator',
			renderer: function(val, params, record) {
		        if (dsFieldSparator.getCount() == 0) {
		            dsFieldSparator.load();
		        }
		        dsFieldSparator.each(function(r) {
		            if (val == r.data['DicsCode']) {
		                val = r.data['DicsName'];
		                return;
		            }
		        });
		        return val;
		    }
		},
		{
			header:'���ݷָ���',
			dataIndex:'BillSeparator',
			id:'BillSeparator',
			renderer: function(val, params, record) {
		        if (dsBillSparator.getCount() == 0) {
		            dsBillSparator.load();
		        }
		        dsBillSparator.each(function(r) {
		            if (val == r.data['DicsCode']) {
		                val = r.data['DicsName'];
		                return;
		            }
		        });
		        return val;
		    }
		},
		{
			header:'����������֯',
			dataIndex:'ProjectOrg',
			id:'ProjectOrg',
			renderer: function(val, params, record) {
		        if (dsOrgList.getCount() == 0) {
		            dsOrgList.load();
		        }
		        dsOrgList.each(function(r) {
		            if (val == r.data['OrgId']) {
		                val = r.data['OrgName'];
		                return;
		            }
		        });
		        return val;
		    }
		},
		{
			header:'���䷽��',
			dataIndex:'TransType',
			id:'TransType',
			renderer:{
			    fn:function(v){
			        if(v==1)return '����';
			        return '����';
			    }
			}
		},
		{
			header:'����״̬',
			dataIndex:'Status',
			id:'Status',
			renderer:{
			    fn:function(v){
			        if(v==1)return '����';
			        return '����';
			    }
			}
		}		]),
		bbar: new Ext.PagingToolbar({
			pageSize: 10,
			store: dsProjCfg,
			displayMsg: '��ʾ��{0}����{1}����¼,��{2}��',
			emptyMsy: 'û�м�¼',
			displayInfo: true
		}),
		viewConfig: {
			columnsText: '��ʾ����',
			scrollOffset: 20,
			sortAscText: '����',
			sortDescText: '����',
			forceFit: true
		},
		height: 280,
		closeAction: 'hide',
		stripeRows: true,
		loadMask: true,
		autoExpandColumn: 2
	});
gridData.render();
/*------DataGrid�ĺ������� End---------------*/

/*------------------�ֶ�����ҳ��-------------------*/
var saveFieldType;
var dsFieldStore = new Ext.data.Store
({
url: 'frmFmProjCfg.aspx?method=getFieldList',
reader:new Ext.data.JsonReader({
	totalProperty:'totalProperty',
	root:'root'
},[
	{		name:'FieldId'	},
	{		name:'ProjectNo'	},
	{		name:'ProjectName'	},
	{		name:'ErpFeild'	},
	{		name:'ErpFeildname'	},
	{		name:'ErpFtype'	},
	{		name:'ErpForder'	},
	{		name:'ErpFlength'	},
	{		name:'ErpFprecision'	},
	{		name:'ErpFdformat'	},
	{		name:'FinanceFeild'	},
	{		name:'FinanceFname'	},
	{		name:'FinanceForder'	},
	{		name:'FinanceFtype'	},
	{		name:'FinanceFlength'	},
	{		name:'FinanceFprecision'	},
	{		name:'FinanceFdformat'	},
	{		name:'Status'	},
	{		name:'Notes'	}
	])
	,
	listeners:
	{
		scope:this,
		load:function(){
		}
	}
});

/*------��ȡ���ݵĺ��� ���� End---------------*/

/*------��ʼDataGrid�ĺ��� start---------------*/

var smField= new Ext.grid.CheckboxSelectionModel({
	singleSelect:true
});
var gridField = new Ext.grid.GridPanel({
	width:'100%',
	height:'100%',
	autoWidth:true,
	autoHeight:true,
	autoScroll:true,
	layout: 'fit',
	id: 'gridField',
	store: dsFieldStore,
	loadMask: {msg:'���ڼ������ݣ����Ժ��'},
	sm:smField,
	cm: new Ext.grid.ColumnModel([
		smField,
		new Ext.grid.RowNumberer(),//�Զ��к�
		{
			header:'�������',
			dataIndex:'FieldId',
			id:'FieldId',
			hidden:true,
			hideable:false
		},
		{
			header:'�������',
			dataIndex:'ProjectNo',
			id:'ProjectNo',
			hidden:true,
			hideable:false
		},
		{
			header:'ҵ���ֶ�',
			dataIndex:'ErpFeild',
			id:'ErpFeild'
		},
		{
			header:'ҵ���ֶ�����',
			dataIndex:'ErpFeildname',
			id:'ErpFeildname',
			hidden:true,
			hideable:false
		},
		{
			header:'ҵ���ֶ�����',
			dataIndex:'ErpFtype',
			id:'ErpFtype',
			renderer: function(val, params, record) {
		        if (dsFieldType.getCount() == 0) {
		            dsFieldType.load();
		        }
		        dsFieldType.each(function(r) {
		            if (val == r.data['DicsCode']) {
		                val = r.data['DicsName'];
		                return;
		            }
		        });
		        return val;
		    }
		},
		{
			header:'ҵ���ֶ�˳��',
			dataIndex:'ErpForder',
			id:'ErpForder',
			hidden:true,
			hideable:false
		},
		{
			header:'ҵ���ֶγ���',
			dataIndex:'ErpFlength',
			id:'ErpFlength',
			hidden:true,
			hideable:false
		},
		{
			header:'ҵ���ֶξ���',
			dataIndex:'ErpFprecision',
			id:'ErpFprecision',
			hidden:true,
			hideable:false
		},
		{
			header:'ҵ���ֶ����ڸ�ʽ',
			dataIndex:'ErpFdformat',
			id:'ErpFdformat',
			hidden:true,
			hideable:false
		},
		{
			header:'�����ֶ�',
			dataIndex:'FinanceFeild',
			id:'FinanceFeild'
		},
		{
			header:'�����ֶ�����',
			dataIndex:'FinanceFtype',
			id:'FinanceFtype',
			renderer: function(val, params, record) {
		        if (dsFieldType.getCount() == 0) {
		            dsFieldType.load();
		        }
		        dsFieldType.each(function(r) {
		            if (val == r.data['DicsCode']) {
		                val = r.data['DicsName'];
		                return;
		            }
		        });
		        return val;
		    }
		},
		{
			header:'�����ֶ�����',
			dataIndex:'FinanceFname',
			id:'FinanceFname',
			hidden:true,
			hideable:false
		},
		{
			header:'�����ֶ�˳��',
			dataIndex:'FinanceForder',
			id:'FinanceForder'
		},
		{
			header:'�����ֶγ���',
			dataIndex:'FinanceFlength',
			id:'FinanceFlength',
			hidden:true,
			hideable:false
		},
		{
			header:'�����ֶ��ֶξ���',
			dataIndex:'FinanceFprecision',
			id:'FinanceFprecision',
			hidden:true,
			hideable:false
		},
		{
			header:'�����ֶ����ڸ�ʽ',
			dataIndex:'FinanceFdformat',
			id:'FinanceFdformat',
			hidden:true,
			hideable:false
		},
		{
			header:'����״̬',
			dataIndex:'Status',
			id:'Status',
			renderer:{
			    fn:function(v){
			        if(v==1)return '����';
			        return '����';
			    }
			}
		}
		
		]),
		tbar: new Ext.Toolbar({
	        items:[{
		        text:"����",
		        icon:"../../Theme/1/images/extjs/customer/add16.gif",
		        handler:function(){
		            saveFieldType='add';
                    openFieldAddCfgWin();
		        }
		        },'-',{
		        text:"�޸�",
		        icon:"../../Theme/1/images/extjs/customer/edit16.gif",
		        handler:function(){
		            saveFieldType='save';
		            modifyFieldCfgWin();
		        }
		        },'-',{
		        text:"ɾ��",
		        icon:"../../Theme/1/images/extjs/customer/delete16.gif",
		        handler:function(){
		            deleteFieldCfg();
		        }
	        }]
        }),
		bbar: new Ext.PagingToolbar({
			pageSize: 10,
			store: dsFieldStore,
			displayMsg: '��ʾ��{0}����{1}����¼,��{2}��',
			emptyMsy: 'û�м�¼',
			displayInfo: true
		}),
		viewConfig: {
			columnsText: '��ʾ����',
			scrollOffset: 20,
			sortAscText: '����',
			sortDescText: '����',
			forceFit: true
		},
		height: 280,
		closeAction: 'hide',
		stripeRows: true,
		loadMask: true,
		autoExpandColumn: 2
	});
/*------DataGrid�ĺ������� End---------------*/

/*------��ʼgrid���ݵĴ��� Start---------------*/
if(typeof(uploadGridCfgWindow)=="undefined"){//�������2��windows����
	uploadGridCfgWindow = new Ext.Window({
		id:'Cfgformwindow',
		title:'�����ֶ�ά��'
		, iconCls: 'upload-win'
		, width: 650
		, height: 450
		, layout: 'fit'
		, plain: true
		, modal: true
		, constrain:true
		, resizable: false
		, closeAction: 'hide'
		,autoDestroy :true
		,items:gridField
		});
	}
	uploadGridCfgWindow.addListener("hide",function(){
	    gridField.getStore().removeAll();
});
/*------����grid���ݵĴ��� End---------------*/
/*------��ʼToolBar�¼����� start---------------*//*-----����Cfgʵ���ര�庯��----*/
function openFieldAddCfgWin() {
    var sm = gridData.getSelectionModel();
	//��ȡѡ���������Ϣ
	var selectData =  sm.getSelected();
	if(selectData == null){
		Ext.Msg.alert("��ʾ","��ѡ����Ҫ���ӵķ�����Ϣ��");
		return;
	}
	uploadFieldCfgWindow.show();
	Ext.getCmp('FProjectNo').setValue(selectData.data.ProjectNo);
	Ext.getCmp('FProjectName').setValue(selectData.data.ProjectName);
}
/*-----�༭Cfgʵ���ര�庯��----*/
function modifyFieldCfgWin() {
	var sm = gridField.getSelectionModel();
	//��ȡѡ���������Ϣ
	var selectData =  sm.getSelected();
	if(selectData == null){
		Ext.Msg.alert("��ʾ","��ѡ����Ҫ�༭�ķ�����Ϣ��");
		return;
	}
	uploadFieldCfgWindow.show();
	setFieldFormValue(selectData);
}
/*-----ɾ��Cfgʵ�庯��----*/
/*ɾ����Ϣ*/
function deleteFieldCfg()
{
	var sm = gridField.getSelectionModel();
	//��ȡѡ���������Ϣ
	var selectData =  sm.getSelected();
	//���û��ѡ�񣬾���ʾ��Ҫѡ��������Ϣ
	if(selectData == null){
		Ext.Msg.alert("��ʾ","��ѡ����Ҫɾ������Ϣ��");
		return;
	}
	//ɾ��ǰ�ٴ������Ƿ����Ҫɾ��
	Ext.Msg.confirm("��ʾ��Ϣ","�Ƿ����Ҫɾ��ѡ�����Ϣ��",function callBack(id){
		//�ж��Ƿ�ɾ������
		if(id=="yes")
		{
			//ҳ���ύ
			Ext.Ajax.request({
				url:'frmFmProjCfg.aspx?method=deleteFeildCfg',
				method:'POST',
				params:{
					FieldId:selectData.data.FieldId
				},
				success: function(resp,opts){
					Ext.Msg.alert("��ʾ","����ɾ���ɹ�");
				},
				failure: function(resp,opts){
					Ext.Msg.alert("��ʾ","����ɾ��ʧ��");
				}
			});
		}
	});
}

/*------ʵ��FormPanle�ĺ��� start---------------*/
var feildForm=new Ext.form.FormPanel({
	url:'',
	//renderTo:'divForm',
	frame:true,
	title:'',
	items:[{
	    layout:'column',
	    items:[
	    {
	        layout:'form',
	        columnWidth:.65,
	        items:[{
			    xtype:'hidden',
			    fieldLabel:'�������',
			    name:'FieldId',
			    id:'FieldId',
			    hidden:true,
			    hideLabel:true
		    },
		    {
			    xtype:'hidden',
			    fieldLabel:'�������',
			    name:'FProjectNo',
			    id:'FProjectNo',
			    hidden:true,
			    hideLabel:true
		    },
		    {
			    xtype:'textfield',
			    fieldLabel:'��������',
			    anchor:'90%',
			    name:'FProjectName',
			    id:'FProjectName',
			    readOnly:true
		    }]
		}
        ,{
            layout:'form',
            labelWidth:55,
            columnWidth:.33,
	        items:[{
			    xtype:'combo',
			    fieldLabel:'����״̬',
			    anchor:'90%',
			    name:'FStatus',
			    id:'FStatus',
			    store:[[0,'����'],[1,'����']],
			    mode:'local',
			    editable:false,
			    triggerAction:'all'
			}]
		}]  
	}
,	{
        layout:'column',
	    items:[
	    {
	        layout:'form',
	        columnWidth:.5,
	        items:[{
			    xtype:'textfield',
			    fieldLabel:'ҵ���ֶ�',
			    anchor:'90%',
			    name:'ErpFeild',
			    id:'ErpFeild'
			}]
		}
        ,{
            layout:'form',
            columnWidth:.5,
	        items:[{
			    xtype:'textfield',
			    fieldLabel:'�����ֶ�',
			    anchor:'90%',
			    name:'FinanceFeild',
			    id:'FinanceFeild'
			}]
		}]
    }		
,	{
        layout:'column',
	    items:[
	    {
	        layout:'form',
	        columnWidth:.5,
	        items:[{
			    xtype:'textfield',
			    fieldLabel:'ҵ���ֶ�����',
			    anchor:'90%',
			    name:'ErpFeildname',
			    id:'ErpFeildname'
			}]
		},
		{
		    layout:'form',
		    columnWidth:.5,
	        items:[{
			    xtype:'textfield',
			    fieldLabel:'�����ֶ�����',
			    anchor:'90%',
			    name:'FinanceFname',
			    id:'FinanceFname'
			}]
		}]
	}	
,	{
        layout:'column',
	    items:[
	    {
	        layout:'form',
	        columnWidth:.5,
	        items:[{
			    xtype:'combo',
			    fieldLabel:'ҵ���ֶ�����',
			    anchor:'90%',
			    name:'ErpFtype',
			    id:'ErpFtype',
			    store:dsFieldType,
			    displayField:'DicsName',
			    valueField:'DicsCode',
			    mode:'local',
			    triggerAction:'all',
			    editable:false
			}]
		}
        ,{
            layout:'form',
            columnWidth:.5,
	        items:[{
			    xtype:'combo',
			    fieldLabel:'�����ֶ�����',
			    anchor:'90%',
			    name:'FinanceFtype',
			    id:'FinanceFtype',
			    store:dsFieldType,
			    displayField:'DicsName',
			    valueField:'DicsCode',
			    mode:'local',
			    triggerAction:'all',
			    editable:false
			}]
		}]
	}	
,	{
        layout:'column',
	    items:[
	    {
	        layout:'form',
	        columnWidth:.5,
	        items:[{
			    xtype:'numberfield',
			    fieldLabel:'ҵ���ֶ�˳��',
			    anchor:'90%',
			    name:'ErpForder',
			    id:'ErpForder'
			}]
		}
        ,{
            layout:'form',
            columnWidth:.5,
	        items:[{
			    xtype:'numberfield',
			    fieldLabel:'�����ֶ�˳��',
			    anchor:'90%',
			    name:'FinanceForder',
			    id:'FinanceForder'
			}]
		}]
	}
,	{
        layout:'column',
	    items:[
	    {
	        layout:'form',
	        columnWidth:.5,
	        items:[{
			    xtype:'numberfield',
			    fieldLabel:'ҵ���ֶγ���',
			    anchor:'90%',
			    name:'ErpFlength',
			    id:'ErpFlength'
			}]
		}
        ,{
            layout:'form',
            columnWidth:.5,
	        items:[{
			    xtype:'numberfield',
			    fieldLabel:'�����ֶγ���',
			    anchor:'90%',
			    name:'FinanceFlength',
			    id:'FinanceFlength'
			}]
		}]
	}
    ,{
        layout:'column',
	    items:[
	    {
	        layout:'form',
	        columnWidth:.5,
	        items:[{
			    xtype:'numberfield',
			    fieldLabel:'ҵ���ֶξ���',
			    anchor:'90%',
			    name:'ErpFprecision',
			    id:'ErpFprecision'
			}]
		}
        ,{
            layout:'form',
            columnWidth:.5,
	        items:[{
			    xtype:'numberfield',
			    fieldLabel:'�����ֶ��ֶξ���',
			    anchor:'90%',
			    name:'FinanceFprecision',
			    id:'FinanceFprecision'
			}]
		}]
    }
,	{
        layout:'column',
	    items:[
	    {
	        layout:'form',
	        columnWidth:.5,
	        items:[{
			    xtype:'textfield',
			    fieldLabel:'ҵ���ֶ����ڸ�ʽ',
			    anchor:'90%',
			    name:'ErpFdformat',
			    id:'ErpFdformat'
			}]
		}
        ,{
            layout:'form',
            columnWidth:.5,
	        items:[{
			    xtype:'textfield',
			    fieldLabel:'�����ֶ����ڸ�ʽ',
			    anchor:'90%',
			    name:'FinanceFdformat',
			    id:'FinanceFdformat'
			}]
		}]
	}
    ,{
        layout:'column',
	    items:[
	    {
	        layout:'form',
	        columnWidth:1,
	        items:[{
			    xtype:'textarea',
			    fieldLabel:'��ע',
			    anchor:'90%',
			    height:50,
			    name:'FNotes',
			    id:'FNotes'
			}]
		}]
    }
]
});
/*------FormPanle�ĺ������� End---------------*/

/*------��ʼ�������ݵĴ��� Start---------------*/
if(typeof(uploadFieldCfgWindow)=="undefined"){//�������2��windows����
	uploadFieldCfgWindow = new Ext.Window({
		id:'Cfgfeildformwindow',
		title:'ҵ���ֶ�����'
		, iconCls: 'upload-win'
		, width: 600
		, height: 350
		, layout: 'fit'
		, plain: true
		, modal: true
		, constrain:true
		, resizable: false
		, closeAction: 'hide'
		,autoDestroy :true
		,items:feildForm
		,buttons: [{
			text: "����"
			, handler: function() {
				saveFieldData();
			}
			, scope: this
		},
		{
			text: "ȡ��"
			, handler: function() { 
				uploadFieldCfgWindow.hide();
			}
			, scope: this
		}]});
	}
	uploadFieldCfgWindow.addListener("hide",function(){
	    feildForm.getForm().reset();
});

/*------��ʼ��ȡ�������ݵĺ��� start---------------*/
function saveFieldData()
{
    if(saveFieldType=='add')
       saveFieldType = 'addFieldCfg';
    else if(saveFieldType == 'save')
        saveFieldType = 'saveFieldCfg';
	Ext.Ajax.request({
		url:'frmFmProjCfg.aspx?method='+saveFieldType,
		method:'POST',
		params:{
		    FieldId:Ext.getCmp('FieldId').getValue(),
			ProjectNo:Ext.getCmp('FProjectNo').getValue(),
			ErpFeild:Ext.getCmp('ErpFeild').getValue(),
			ErpFeildname:Ext.getCmp('ErpFeildname').getValue(),
			ErpFtype:Ext.getCmp('ErpFtype').getValue(),
			ErpForder:Ext.getCmp('ErpForder').getValue(),
			ErpFlength:Ext.getCmp('ErpFlength').getValue(),
			ErpFprecision:Ext.getCmp('ErpFprecision').getValue(),
			ErpFdformat:Ext.getCmp('ErpFdformat').getValue(),
			FinanceFeild:Ext.getCmp('FinanceFeild').getValue(),
			FinanceFname:Ext.getCmp('FinanceFname').getValue(),
			FinanceForder:Ext.getCmp('FinanceForder').getValue(),
			FinanceFtype:Ext.getCmp('FinanceFtype').getValue(),
			FinanceFlength:Ext.getCmp('FinanceFlength').getValue(),
			FinanceFprecision:Ext.getCmp('FinanceFprecision').getValue(),
			FinanceFdformat:Ext.getCmp('FinanceFdformat').getValue(),
		    Status:Ext.getCmp("FStatus").getValue(),
		    Notes:Ext.getCmp("FNotes").getValue()
			
			},
		success: function(resp,opts){
			Ext.Msg.alert("��ʾ","����ɹ�");
			gridField.getStore().reload();
			uploadFieldCfgWindow.hide();
		},
		failure: function(resp,opts){
			Ext.Msg.alert("��ʾ","����ʧ��");
		}
		});
		}
/*------������ȡ�������ݵĺ��� End---------------*/

/*------��ʼ�������ݵĺ��� Start---------------*/
function setFieldFormValue(selectData)
{
	Ext.Ajax.request({
		url:'frmFmProjCfg.aspx?method=getFieldCfg',
		params:{
			FieldId:selectData.data.FieldId
		},
	success: function(resp,opts){
		var data=Ext.util.JSON.decode(resp.responseText);
		Ext.getCmp("FieldId").setValue(data.FieldId);
		Ext.getCmp("ProjectNo").setValue(data.ProjectNo);
		Ext.getCmp("FProjectName").setValue(data.ProjectName);
		Ext.getCmp("ErpFeild").setValue(data.ErpFeild);
		Ext.getCmp("ErpFeildname").setValue(data.ErpFeildname);
		Ext.getCmp("ErpFtype").setValue(data.ErpFtype);
		Ext.getCmp("ErpForder").setValue(data.ErpForder);
		Ext.getCmp("ErpFlength").setValue(data.ErpFlength);
		Ext.getCmp("ErpFprecision").setValue(data.ErpFprecision);
		Ext.getCmp("ErpFdformat").setValue(data.ErpFdformat);
		Ext.getCmp("FinanceFeild").setValue(data.FinanceFeild);
		Ext.getCmp("FinanceFname").setValue(data.FinanceFname);
		Ext.getCmp("FinanceForder").setValue(data.FinanceForder);
		Ext.getCmp("FinanceFtype").setValue(data.FinanceFtype);
		Ext.getCmp("FinanceFlength").setValue(data.FinanceFlength);
		Ext.getCmp("FinanceFprecision").setValue(data.FinanceFprecision);
		Ext.getCmp("FinanceFdformat").setValue(data.FinanceFdformat);
		Ext.getCmp("FStatus").setValue(data.Status);
		Ext.getCmp("FNotes").setValue(data.Notes);
	},
	failure: function(resp,opts){
		Ext.Msg.alert("��ʾ","��ȡ��Ϣʧ��");
	}
	});
}
/*------�������ý������ݵĺ��� End---------------*/



/*------------------�ֶ�����ҳ��-------------------*/


})
</script>

</html>
