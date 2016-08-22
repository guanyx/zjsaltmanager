<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmScmDriverAttr.aspx.cs" Inherits="SCM_frmScmDriverAttr" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html>
<head>
<title>��ʻԱά��</title><meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<link rel="stylesheet" type="text/css" href="../ext3/resources/css/ext-all.css" />
<script type="text/javascript" src="../ext3/adapter/ext/ext-base.js"></script>
<script type="text/javascript" src="../ext3/ext-all.js"></script>
<script type="text/javascript" src="../js/operateResp.js"></script>
</head>
<body>
<div id='toolbar'></div>
<div id='searchForm'></div>
<div id='dateGrid'></div>
</body>

<%= getComboBoxStore() %>

<script type="text/javascript">
Ext.onReady(function(){
Ext.BLANK_IMAGE_URL = "../ext3/resources/images/default/s.gif";
var saveType="";
/*------ʵ��toolbar�ĺ��� start---------------*/
var Toolbar = new Ext.Toolbar({
	renderTo:"toolbar",
	items:[{
		text:"����",
		icon:"../Theme/1/images/extjs/customer/add16.gif",
		handler:function(){
		    saveType= 'add';
		    openAddAttrWin();
		}
		},'-',{
		text:"�༭",
		icon:"../Theme/1/images/extjs/customer/edit16.gif",
		handler:function(){
		    saveType= 'save';
		    modifyAttrWin();
		}
		},'-',{
		text:"ɾ��",
		icon:"../Theme/1/images/extjs/customer/delete16.gif",
		handler:function(){
		    deleteAttr();
		}
		},'-',{
		text:"��������",
		icon:"../Theme/1/images/extjs/customer/edit16.gif",
		handler:function(){
		    addVehicle();
		}
	}]
});

/*------����toolbar�ĺ��� end---------------*/


/*------��ʼToolBar�¼����� start---------------*//*-----����Attrʵ���ര�庯��----*/
function openAddAttrWin() {
	driverFrom.getForm().reset();
	uploadAttrWindow.show();

    var firstValue = dsNation.getRange()[0].data.DicsCode;//���ַ������Ի�õ�һ���ֵ  
    //firstValue  = dsNation.getAt(0).data.DicsCode;//���ַ���Ҳ���Ի�õ�һ���ֵ  
    Ext.getCmp('Nation').setValue(dsNation.getAt(0).data.DicsCode);//ѡ�� 

}
/*-----�༭Attrʵ���ര�庯��----*/
function modifyAttrWin() {
	var sm = gridData.getSelectionModel();
	//��ȡѡ���������Ϣ
	var selectData =  sm.getSelected();
	if(selectData == null){
		Ext.Msg.alert("��ʾ","��ѡ����Ҫ�༭����Ϣ��");
		return;
	}
	uploadAttrWindow.show();
	setFormValue(selectData);
}
/*-----ɾ��Attrʵ�庯��----*/
/*ɾ����Ϣ*/
function deleteAttr()
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
				url:'frmScmDriverAttr.aspx?method=deleteAttr',
				method:'POST',
				params:{
					DriverId:selectData.data.DriverId
				},
				success: function(resp,opts){
					Ext.Msg.alert("��ʾ","����ɾ���ɹ�");
					gridData.getStore().reload();
				},
				failure: function(resp,opts){
					Ext.Msg.alert("��ʾ","����ɾ��ʧ��");
				}
			});
		}
	});
}
//�����복���Ķ�Ӧ��ϵ
function addVehicle()
{
    var sm = gridData.getSelectionModel();
	//��ȡѡ���������Ϣ
	var selectData =  sm.getSelected();
	//���û��ѡ�񣬾���ʾ��Ҫѡ��������Ϣ
	if(selectData == null){
		Ext.Msg.alert("��ʾ","��ѡ����Ҫ���õļ�ʻԱ��Ϣ��");
		return;
	}
	//
	uploadVehicleWindow.show();
	setGridValue(selectData);
}
/*------ʵ��searchForm�ĺ��� start---------------*/
var namePanel = new Ext.form.TextField({
    style: 'margin-left:0px',
    cls: 'key',
    xtype: 'textfield',
    fieldLabel: '��ʻԱ����',
    name: 'name',
    anchor: '90%'
});
var searchForm = new Ext.form.FormPanel({
    renderTo: 'searchForm',
    labelAlign: 'left',
    layout:'fit',
    buttonAlign: 'right',
    bodyStyle: 'padding:5px',
    frame: true,
    labelWidth: 80,
    items: [{
        layout: 'column',   //�����Ԫ��Ϊ����Ϊ�в��ַ�ʽ
        border: false,
        items: [{
            columnWidth: .33,
            layout: 'form',
            border: false,
            items: [
                namePanel
                ]
        },{
            columnWidth: .10,
            layout: 'form',
            border: false,
            items: [{ cls: 'key',
                xtype: 'button',
                text: '��ѯ',
                anchor: '50%',
                handler :function(){                
                    var name=namePanel.getValue();
                    //alert(name +":"+type);
                    gridDataData.baseParams.DriverName = name;
                    gridDataData.load({
                                params : {
                                start : 0,
                                limit : 10
                                } 
                              }); 
                    }
                }]
        },{
            columnWidth: .56,  //����ռ�õĿ�ȣ���ʶΪ20��
            layout: 'form',
            border: false
        }]
    }]

});

/*------ʵ��searchForm�ĺ��� start---------------*/

/*------ʵ��FormPanle�ĺ��� start---------------*/
var driverFrom=new Ext.form.FormPanel({
	url:'',
	//renderTo:'divForm',
	frame: true,
    title: '',
    labelAlign: 'left',
    buttonAlign: 'right',
    bodyStyle: 'padding:5px',
    labelWith: 55,
	items:[
	{
	    layout:'column',
	    border: false,
	    items:[
	    {
	        layout:'form',
	        columnWidth:.5,
	        border: false,
	        items:[
	        {
	            xtype:'hidden',
			    fieldLabel:'��ʻԱ��ʶ',
			    name:'DriverId',
			    id:'DriverId',
			    hidden:true,
			    hideLabel:true
	        },
	        {
	            xtype:'textfield',
			    fieldLabel:'����*',
			    anchor:'90%',
			    name:'DriverName',
			    id:'DriverName'
	        }
	        ]
	    },
	    {
	        layout:'form',
	        columnWidth:.5,
	        border: false,
	        items:[
	        {
	            xtype:'hidden',
	            fieldLabel:'�Ա�',
			    name:'Gender',
			    id:'Gender',
			    hidden:true,
			    hideLabel:true
	        },
	        {
	            xtype:'radiogroup',
			    fieldLabel:'�Ա�',
			    anchor:'90%',
			    id:'distinction',
			    name:'distinction',
			    items: [
                    {boxLabel: '��', id:'male', name: 'Gender', checked: true},
                    {boxLabel: 'Ů', id:'female', name: 'Gender'}
                ],
                listeners:{
                change: function(el, checked) { 
                        if(Ext.getCmp('male').getValue())
                            Ext.getCmp('Gender').setValue(1);
                        if(Ext.getCmp('female').getValue())
                            Ext.getCmp('Gender').setValue(0); 
                        //alert(Ext.getCmp('Gender').getValue());                  
                   }
                }
	        }
	        ]
	    }
	    ]
	},
	{
	    layout:'column',
	    border: false,
	    items:[
	    {
	        layout:'form',
	        columnWidth:.5,
	        border: false,
	        items:[
	        {
	            xtype:'textfield',
			    fieldLabel:'��ϵ�绰*',
			    anchor:'90%',
			    name:'Tel',
			    id:'Tel'
	        }
	        ]
	    },
	    {
	        layout:'form',
	        columnWidth:.5,
	        border: false,
	        items:[
	        {
	            xtype:'textfield',
			    fieldLabel:'���֤��',
			    anchor:'90%',
			    name:'IdentityCard',
			    id:'IdentityCard'
	        }
	        ]
	    }
	    ]
	},
	{
	    layout:'column',
	    border: false,
	    items:[
	    {
	        layout:'form',
	        columnWidth:.5,
	        border: false,
	        items:[
	        {
	            xtype:'textfield',
			    fieldLabel:'סַ',
			    anchor:'90%',
			    name:'IdAddress',
			    id:'IdAddress'
	        }
	        ]
	    },
	    {
	        layout:'form',
	        columnWidth:.5,
	        border: false,
	        items:[
	        {
	            xtype:'combo',
			    fieldLabel:'����',
			    anchor:'90%',
			    name:'Nation',
			    id:'Nation',
			    store: dsNation,
			    displayField:'DicsName',
			    valueField:'DicsCode',
			    mode:'local',
			    editable:false,
			    triggerAction:'all'
	        }
	        ]
	    }
	    ]
	},
	{
	    layout:'column',
	    border: false,
	    items:[
	    {
	        layout:'form',
	        columnWidth:.5,
	        border: false,
	        items:[
	        {
	            xtype:'textfield',
			    fieldLabel:'����',
			    anchor:'90%',
			    name:'NationPlace',
			    id:'NationPlace'
	        }
	        ]
	    },
	    {
	        layout:'form',
	        columnWidth:.5,
	        border: false,
	        items:[
	        {
	            xtype:'textfield',
			    fieldLabel:'��ʻ֤��*',
			    anchor:'90%',
			    name:'DriveCard',
			    id:'DriveCard'
	        }
	        ]
	    }
	    ]
	},
	{
	    layout:'column',
	    border: false,
	    items:[
	    {
	        layout:'form',
	        columnWidth:1,
	        border: false,
	        items:[
	        {
	            xtype: 'combo',
                fieldLabel: 'װж��λ',
                anchor: '80%',
                id: 'LoadCompId', 
                displayField: 'Name',
                valueField: 'Id',
                editable: false,
                store: dsLoadCompanyList,
                mode: 'local',
                triggerAction: 'all'
	        }
	        ]
	    }
	    ]
	},
	{
	    layout:'column',
	    border: false,
	    items:[
	    {
	        layout:'form',
	        columnWidth:1,
	        border: false,
	        items:[
	        {
	            xtype:'textarea',
			    fieldLabel:'��ע',
			    anchor:'90%',
			    name:'Remark',
			    id:'Remark'
	        }
	        ]
	    }
	    ]
	}
	]
});
/*------FormPanle�ĺ������� End---------------*/

/*------��ʼ�������ݵĴ��� Start---------------*/
if(typeof(uploadAttrWindow)=="undefined"){//�������2��windows����
	uploadAttrWindow = new Ext.Window({
		id:'Attrformwindow',
		title:'��ʻԱ��Ϣά��'
		, iconCls: 'upload-win'
		, width: 600
		, height: 300
		, layout: 'fit'
		, plain: true
		, modal: true
		, constrain:true
		, resizable: false
		, closeAction: 'hide'
		,autoDestroy :true
		,items:driverFrom
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
				uploadAttrWindow.hide();
			}
			, scope: this
		}]});
	}
	uploadAttrWindow.addListener("hide",function(){
	    driverFrom.getForm().reset();
});


/*------��ʼ��ȡ�������ݵĺ��� start---------------*/
function saveUserData()
{
    if(saveType == 'add')
        saveType = 'addAttr';
    if(saveType == 'save')
        saveType = 'saveAttr';
    var gender = 0; 
    if (Ext.getCmp('male').getValue())
        gender = 1;
 
	Ext.Ajax.request({
		url:'frmScmDriverAttr.aspx?method='+saveType,
		method:'POST',
		params:{
			DriverId:Ext.getCmp('DriverId').getValue(),
			DriverName:Ext.getCmp('DriverName').getValue(),
			Gender:gender,
			Tel:Ext.getCmp('Tel').getValue(),
			IdentityCard:Ext.getCmp('IdentityCard').getValue(),
			IdAddress:Ext.getCmp('IdAddress').getValue(),
			Nation:Ext.getCmp('Nation').getValue(),
			NationPlace:Ext.getCmp('NationPlace').getValue(),
			DriveCard:Ext.getCmp('DriveCard').getValue(),
			LoadCompId:Ext.getCmp('LoadCompId').getValue(),
			Remark:Ext.getCmp('Remark').getValue(),
			IsActive:1
			},		
		    success: function(resp,opts){ 
                            if( checkExtMessage(resp) ) 
                                    uploadAttrWindow.hide();
                                    gridData.getStore().reload();
                                   //uploadAttrWindow.hide();
                           },
            failure: function(resp,opts){  Ext.Msg.alert("��ʾ","����ʧ��");     }
		    });
		}
/*------������ȡ�������ݵĺ��� End---------------*/

/*------��ʼ�������ݵĺ��� Start---------------*/
function setFormValue(selectData)
{
	Ext.Ajax.request({
		url:'frmScmDriverAttr.aspx?method=getattr',
		params:{
			DriverId:selectData.data.DriverId
		},
	success: function(resp,opts){
		var data=Ext.util.JSON.decode(resp.responseText);
		Ext.getCmp("DriverId").setValue(data.DriverId);
		Ext.getCmp("DriverName").setValue(data.DriverName);
		if(data.Gender=="1")
		    Ext.getCmp("male").setValue(true);
		else
		    Ext.getCmp("female").setValue(true);
		Ext.getCmp("Tel").setValue(data.Tel);
		Ext.getCmp("IdentityCard").setValue(data.IdentityCard);
		Ext.getCmp("IdAddress").setValue(data.IdAddress);
		Ext.getCmp("Nation").setValue(data.Nation);
		Ext.getCmp("NationPlace").setValue(data.NationPlace);
		Ext.getCmp("DriveCard").setValue(data.DriveCard);
		Ext.getCmp("Remark").setValue(data.Remark);
		Ext.getCmp("LoadCompId").setValue(data.LoadCompId);
	},
	failure: function(resp,opts){
		Ext.Msg.alert("��ʾ","��ȡ�û���Ϣʧ��");
	}
	});
}
/*------�������ý������ݵĺ��� End---------------*/

/*------��ʼ��ȡ���ݵĺ��� start---------------*/
var gridDataData = new Ext.data.Store
({
url: 'frmScmDriverAttr.aspx?method=getAttrlist',
reader:new Ext.data.JsonReader({
	totalProperty:'totalProperty',
	root:'root'
},[
	{
		name:'DriverId'
	},
	{
		name:'DriverName'
	},
	{
		name:'LoadCompId'
	},
	{
		name:'Gender'
	},
	{
		name:'Tel'
	},
	{
		name:'IdentityCard'
	},
	{
		name:'IdAddress'
	},
	{
		name:'Nation'
	},
	{
		name:'NationPlace'
	},
	{
		name:'DriveCard'
	},
	{
		name:'Remark'
	}
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
	el: 'dateGrid',
	width:'100%',
	height:'100%',
	autoWidth:true,
	autoHeight:true,
	autoScroll:true,
	layout: 'fit',
	id: '',
	store: gridDataData,
	loadMask: {msg:'���ڼ������ݣ����Ժ��'},
	sm:sm,
	cm: new Ext.grid.ColumnModel([
		sm,
		new Ext.grid.RowNumberer(),//�Զ��к�
		{
			header:'��ʻԱ��ʶ',
			dataIndex:'DriverId',
			id:'DriverId',
			hidden:true,
			hideable:false
		},
		{
			header:'װж��˾',
			dataIndex:'LoadCompId',
			width:150,
			id:'LoadCompId',
			renderer:{
			    fn:function(val, params, record) {
			if (val ==0) return val;
		        if (dsLoadCompanyList.getCount() == 0) {
		            dsLoadCompanyList.load();
		        }
		        dsLoadCompanyList.each(function(r) {
		            if (val == r.data['Id']) {
		                val = r.data['Name'];
		                return;
		            }
		        });
		        return val;
		    }
			}
		},
		{
			header:'����',
			dataIndex:'DriverName',
			width:80,
			id:'DriverName'
		},
		{
			header:'�Ա�',
			dataIndex:'Gender',
			id:'Gender',
			width:50,
			renderer:{
			    fn:function(v){
			        if(v=='0') return 'Ů';
			        if(v=='1') return '��';
			    }
			}
		},
		{
			header:'��ϵ�绰',
			width:80,
			dataIndex:'Tel',
			id:'Tel'
		},
		{
			header:'���֤��',
			width:80,
			dataIndex:'IdentityCard',
			id:'IdentityCard'
		},
		{
			header:'סַ',
			width:150,
			dataIndex:'IdAddress',
			id:'IdAddress'
		},
		{
			header:'����',
			width:50,
			dataIndex:'Nation',
			id:'Nation',
			renderer:{
			    fn:function(val, params, record) {
		        if (dsNation.getCount() == 0) {
		            dsNation.load();
		        }
		        dsNation.each(function(r) {
		            if (val == r.data['DicsCode']) {
		                val = r.data['DicsName'];
		                return;
		            }
		        });
		        return val;
		    }
			}
		},
		{
			header:'����',
			width:50,
			dataIndex:'NationPlace',
			id:'NationPlace'
		},
		{
			header:'��ʻ֤��',
			hidden:true,
			dataIndex:'DriveCard',
			id:'DriveCard'
		}		]),
		bbar: new Ext.PagingToolbar({
			pageSize: 10,
			store: gridDataData,
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
var gridVehicleDataData = new Ext.data.Store
({
url: 'frmScmDriverAttr.aspx?method=getVehiclelist',
reader:new Ext.data.JsonReader({
	totalProperty:'totalProperty',
	root:'root'
},[
	{		name:'DriverId'	},
	{		name:'VehicleId'	},
	{		name:'VehicleName'	},
	{		name:'VehicleNo'	},
	{		name:'VehicleType'	},
	{		name:'VehicleTon'	},
	{		name:'MinQty'	},
	{		name:'MaxQty'	},
	{		name:'OperId'	},
	{		name:'CreateDate'	},
	{		name:'Remark'	}
	])
	,
	listeners:
	{
		scope:this,
		load:function(){
		}
	}
});
var vsm= new Ext.grid.CheckboxSelectionModel({
	singleSelect:true
});
var vehicleGrid = new Ext.grid.GridPanel({
	width:'100%',
	height:'100%',
	autoWidth:true,
	autoHeight:true,
	autoScroll:true,
	layout: 'fit',
	store: gridVehicleDataData,
	loadMask: {msg:'���ڼ������ݣ����Ժ��'},
	sm:vsm,
	cm: new Ext.grid.ColumnModel([
		vsm,
		new Ext.grid.RowNumberer(),//�Զ��к�
		{
			header:'��ʶ',
			dataIndex:'RelId',
			id:'RelId',
			hidden:true,
			hideable:false
		},
		{
			header:'��������',
			dataIndex:'VehicleName',
			width:150,
			id:'VehicleName'
		},
		{
			header:'���ƺ�',
			dataIndex:'VehicleNo',
			width:80,
			id:'VehicleNo'
		},
		{
			header:'����',
			dataIndex:'VehicleType',
			id:'VehicleType',
			width:50
		},
		{
			header:'������(��)',
			width:80,
			dataIndex:'VehicleTon',
			id:'VehicleTon'
		},
		{
			header:'��ע',
			width:150,
			dataIndex:'Remark',
			id:'Remark'
		}		]),
		tbar: new Ext.Toolbar({
	        items:[{
		        text:"����",
		        icon:"../Theme/1/images/extjs/customer/add16.gif",
		        handler:function(){
                    openScmVehicleWindowShow();
		        }
		        },'-',{
		        text:"ɾ��",
		        icon:"../Theme/1/images/extjs/customer/delete16.gif",
		        handler:function(){
		            deleteRelInfo();
		        }
	        }]
        }),
		bbar: new Ext.PagingToolbar({
			pageSize: 10,
			store: gridVehicleDataData,
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

if(typeof(uploadVehicleWindow)=="undefined"){//�������2��windows����
	uploadVehicleWindow = new Ext.Window({
		id:'vecleformwindow',
		title:'������Ϣά��'
		, iconCls: 'upload-win'
		, width: 600
		, height: 300
		, layout: 'fit'
		, plain: true
		, modal: true
		, constrain:true
		, resizable: false
		, closeAction: 'hide'
		,autoDestroy :true
		,items:vehicleGrid
		,buttons: [{
			text: "ȡ��"
			, handler: function() { 
				uploadVehicleWindow.hide();
			}
			, scope: this
		}]});
	}
	uploadVehicleWindow.addListener("hide",function(){
	    vehicleGrid.getStore().removeAll();
});

function setGridValue( record)
{
    gridVehicleDataData.load({params:{start:0,limit:10,DriverId:record.data.DriverId}});
}
function deleteRelInfo()
{
	var sm = vehicleGrid.getSelectionModel();
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
				url:'frmScmDriverAttr.aspx?method=deleteRelInfo',
				method:'POST',
				params:{
					DriverId:selectData.data.RelId
				},
				success: function(resp,opts){
					Ext.Msg.alert("��ʾ","����ɾ���ɹ�");
					vehicleGrid.getStore().reload();
				},
				failure: function(resp,opts){
					Ext.Msg.alert("��ʾ","����ɾ��ʧ��");
				}
			});
		}
	});
}

/************************************************/
var gridScmVehicleData = new Ext.data.Store
        ({
        url: 'frmVehicleAttr.aspx?method=getattrlist',
        reader:new Ext.data.JsonReader({
	        totalProperty:'totalProperty',
	        root:'root'
        },[
	        {		        name:'VehicleId'	        },
	        {		        name:'VehicleName'	        },
	        {		        name:'OrgId'	        },
	        {		        name:'VehicleNo'	        },
	        {		        name:'VehicleType'	        },
	        {		        name:'VehicleTon'	        },
	        {		        name:'MinQty'	        },
	        {		        name:'MaxQty'	        },
	        {		        name:'DefDlvId'	        },
	        {		        name:'DefDriver'	        },
	        {		        name:'OperId'	        },
	        {		        name:'CreateDate'	        },
	        {		        name:'UpdateDate'	        },
	        {		        name:'OwnerId'	        },
	        {		        name:'Remark'	        },
	        {		        name:'IsActive'	        }	])
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

        var scmsm= new Ext.grid.CheckboxSelectionModel({
	        singleSelect:true
        });
        var scmVehicleGrid = new Ext.grid.GridPanel({
	        width:'100%',
	        height:'100%',
	        autoWidth:true,
	        autoHeight:true,
	        autoScroll:true,
	        layout: 'fit',
	        store: gridScmVehicleData,
	        loadMask: {msg:'���ڼ������ݣ����Ժ��'},
	        sm:scmsm,
	        cm: new Ext.grid.ColumnModel([
		        scmsm,
		        new Ext.grid.RowNumberer(),//�Զ��к�
		        {
			        header:'������ʶ',
			        dataIndex:'VehicleId',
			        id:'VehicleId'
		        },
		        {
			        header:'����',
			        dataIndex:'VehicleName',
			        id:'VehicleName'
		        },
		        {
			        header:'���ƺ�',
			        dataIndex:'VehicleNo',
			        id:'VehicleNo'
		        },
		        {
			        header:'����',
			        dataIndex:'VehicleType',
			        id:'VehicleType'
		        },
		        {
			        header:'������(��)',
			        dataIndex:'VehicleTon',
			        id:'VehicleTon'
		        },
		        {
			        header:'��������(��)',
			        dataIndex:'MinQty',
			        id:'MinQty'
		        },
		        {
			        header:'��������(��)',
			        dataIndex:'MaxQty',
			        id:'MaxQty'
		        },
		        {
			        header:'����ʱ��',
			        dataIndex:'CreateDate',
			        id:'CreateDate',
			       renderer: Ext.util.Format.dateRenderer('Y��m��d��')
		        }		
		        ]),
		        bbar: new Ext.PagingToolbar({
			        pageSize: 10,
			        store: gridScmVehicleData,
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
if(typeof(uploadScmVehicleWindow)=="undefined"){//�������2��windows����
	uploadScmVehicleWindow = new Ext.Window({
		id:'scmvecleformwindow',
		title:'������Ϣά��'
		, iconCls: 'upload-win'
		, width: 600
		, height: 400
		, layout: 'fit'
		, plain: true
		, modal: true
		, constrain:true
		, resizable: false
		, closeAction: 'hide'
		,autoDestroy :true
		,items:scmVehicleGrid
		,buttons: [{
			text: "����"
			, handler: function() { 
				saveScmVehicleData();
				}
			},{
			text: "ȡ��"
			, handler: function() { 
				uploadScmVehicleWindow.hide();
			}
			, scope: this
		}]});
	}
	uploadScmVehicleWindow.addListener("hide",function(){
	    scmVehicleGrid.getStore().removeAll();
		gridVehicleDataData.reload();
});
function openScmVehicleWindowShow()
{
    uploadScmVehicleWindow.show();
    gridScmVehicleData.load({params:{start:0,limit:10}});
}
function saveScmVehicleData()
{
    var sm = gridData.getSelectionModel();
	//��ȡѡ���������Ϣ
	var selectData =  sm.getSelected();
	
	var vscsm = scmVehicleGrid.getSelectionModel();
	//��ȡѡ���������Ϣ
	var selectVehicle =  vscsm.getSelected();;
    Ext.Ajax.request({
		url:'frmScmDriverAttr.aspx?method=saveDriverVehicleRel',
		method:'POST',
		params:{
			DriverId:selectData.data.DriverId,
			VehicleId:selectVehicle.data.VehicleId
		},		
	    success: function(resp,opts){ 
            if( checkExtMessage(resp) ) 
                uploadVehicleWindow.hide();               
           },
        failure: function(resp,opts){  Ext.Msg.alert("��ʾ","����ʧ��");     }
	    });
}


})
</script>



</html>
