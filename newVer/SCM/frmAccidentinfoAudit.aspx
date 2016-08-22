<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmAccidentinfoAudit.aspx.cs" Inherits="SCM_frmAccidentinfoAudit" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html>
<head>
<title>�����¹����</title><meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<link rel="stylesheet" type="text/css" href="../ext3/resources/css/ext-all.css" />
<script type="text/javascript" src="../ext3/adapter/ext/ext-base.js"></script>
<script type="text/javascript" src="../ext3/ext-all.js"></script>
</head>
<body>
<div id='toolbar'></div>
<div id='searchForm'></div>
<div id='dataGrid'></div>

</body>
<%=getComboBoxStore() %>
<script type="text/javascript">
Ext.BLANK_IMAGE_URL = "../ext3/resources/images/default/s.gif"; 
Ext.onReady(function(){
/*------ʵ��toolbar�ĺ��� start---------------*/
var Toolbar = new Ext.Toolbar({
	renderTo:"toolbar",
	items:[{
		text:"�鿴�����",
		icon:"../Theme/1/images/extjs/customer/add16.gif",
		handler:function(){
		    ViewInfoWin();
		}
		/*
		},'-',{
		text:"�������",
		icon:"../Theme/1/images/extjs/customer/delete16.gif",
		handler:function(){
		    AuditInfo();
		}*/
	}]
});

/*------����toolbar�ĺ��� end---------------*/


/*------��ʼToolBar�¼����� start---------------*//*-----����Infoʵ���ര�庯��----*/
/*-----�༭Infoʵ���ര�庯��----*/
function ViewInfoWin() {
	var sm = AuditGrid.getSelectionModel();
	//��ȡѡ���������Ϣ
	var selectData =  sm.getSelected();
	if(selectData == null){
		Ext.Msg.alert("��ʾ","��ѡ����Ҫ�༭����Ϣ��");
		return;
	}
	uploadAuditInfoWindow.show();
	Ext.getCmp('AccidentType').setDisabled(true);
	setFormValue(selectData);
}
/*-----���Infoʵ�庯��----*/
/*�����Ϣ*/
function AuditInfo()
{
	var sm = AuditGrid.getSelectionModel();
	//��ȡѡ���������Ϣ
	var selectData =  sm.getSelected();
	//���û��ѡ�񣬾���ʾ��Ҫѡ��������Ϣ
	if(selectData == null){
		Ext.Msg.alert("��ʾ","��ѡ����Ҫ��˵���Ϣ��");
		return;
	}

	//ҳ���ύ
	Ext.Ajax.request({
		url:'frmAccidentinfoAudit.aspx?method=AuditMoreInfo',
		method:'POST',
		params:{
			AccidentId:selectData.data.AccidentId
		},
		success: function(resp,opts){
			Ext.Msg.alert("��ʾ","������˳ɹ�");
		},
		failure: function(resp,opts){
			Ext.Msg.alert("��ʾ","�������ʧ��");
		}
	});
}

/*------ʵ��FormPanle�ĺ��� start---------------*/
var auditAccForm=new Ext.form.FormPanel({
url:'',
	frame:true,
	title:'',
	items:[
		{
		    layout:'form',
            columnWidth:.5,
            labelWidth:55,
            items:[{
			    xtype:'hidden',
			    fieldLabel:'�ȼ����',
			    name:'AccidentId',
			    id:'AccidentId',
			    hidden:true,
			    hideLabel:true
			}]
		}
,		{
            layout:'form',
            columnWidth:.5,
            labelWidth:55,
            items:[{
			    xtype:'textfield',
			    fieldLabel:'����',
			    columnWidth:1,
			    anchor:'90%',
			    name:'AccidentName',
			    id:'AccidentName',
			    readOnly:true
		    }]
		}
,		{
            layout:'column',
            items:[{
                layout:'form',
                columnWidth:.45,
                labelWidth:55,
                items:[{
			        xtype:'combo',
			        fieldLabel:'����',
			        anchor:'90%',
			        name:'AccidentType',
			        id:'AccidentType',
			        hiddenName:'value',
			        store:dsAccidentType,
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
			        xtype:'textfield',
			        fieldLabel:'�������ݺ�',
			        columnWidth:1,
			        anchor:'90%',
			        name:'BillNo',
			        id:'BillNo',
			        readOnly:true
		        }]
		    }]
		}
,		{
            layout:'column',
            labelWidth:55,
            items:[{
                layout:'form',
                columnWidth:.8,
                labelWidth:55,
                items:[{
                    xtype: 'textfield',
	                fieldLabel: '����',
	                anchor: '98%',
	                name: 'Accessories',
	                id: 'Accessories',
			        readOnly:true
			     }]
	        },
	        {
	            layout:'form',
                columnWidth:.2,
                labelWidth:55,
                items:[{
                    xtype: 'button',
	                text: '�鿴����',
	                handler:function(){
	                    var annme = Ext.getCmp('Accessories').getValue();
	                    if(annme == "")
	                        return;	                        
	                    //else download file
	                    window.open("frmAccidentinfoAudit.aspx?method=getAccessories&fileName="+annme,"");
	                    
	                }	
	            }]            
	        }]
		}
,		{
            layout:'form',
            columnWidth:.5,
            labelWidth:55,
            items:[{
			    xtype:'textarea',
			    fieldLabel:'��ע',
			    columnWidth:1,
			    anchor:'90%',
			    name:'Remark',
			    id:'Remark',
			    readOnly:true
			}]
		}
,		{
            layout:'form',
            columnWidth:.5,
            labelWidth:55,
            items:[{
			    xtype:'textarea',
			    fieldLabel:'������',
			    columnWidth:1,
			    anchor:'90%',
			    name:'Result',
			    id:'Result'
			}]
		}
]
});

/*------FormPanle�ĺ������� End---------------*/

/*------��ʼ�������ݵĴ��� Start---------------*/
if(typeof(uploadAuditInfoWindow)=="undefined"){//�������2��windows����
	uploadAuditInfoWindow = new Ext.Window({
		id:'Infoformwindow',
		title:'�����¼����'
		, iconCls: 'upload-win'
		, width: 500
		, height: 300
		, layout: 'fit'
		, plain: true
		, modal: true
		, constrain:true
		, resizable: false
		, closeAction: 'hide'
		,autoDestroy :true
		,items:auditAccForm
		,buttons: [{
			text: "ȷ��"
			, handler: function() {
				saveAuditData();
			}
			, scope: this
		},
		{
			text: "ȡ��"
			, handler: function() { 
				uploadAuditInfoWindow.hide();
			}
			, scope: this
		}]});
	}
	uploadAuditInfoWindow.addListener("hide",function(){
	    auditAccForm.getForm().reset();
});

/*------��ʼ��ȡ�������ݵĺ��� start---------------*/
function saveAuditData()
{
	Ext.Ajax.request({
		url:'frmAccidentinfoAudit.aspx?method=AuditInfo',
		method:'POST',
		params:{
			AccidentId:Ext.getCmp('AccidentId').getValue(),
			Result:Ext.getCmp('Result').getValue()
			},
		success: function(resp,opts){
			Ext.Msg.alert("��ʾ","��˳ɹ�");
		},
		failure: function(resp,opts){
			Ext.Msg.alert("��ʾ","���ʧ��");
		}
		});
		}
/*------������ȡ�������ݵĺ��� End---------------*/

/*------��ʼ�������ݵĺ��� Start---------------*/
function setFormValue(selectData)
{
	Ext.Ajax.request({
		url:'frmAccidentinfoAudit.aspx?method=getInfo',
		params:{
			AccidentId:selectData.data.AccidentId
		},
	success: function(resp,opts){
		var data=Ext.util.JSON.decode(resp.responseText);
		Ext.getCmp("AccidentId").setValue(data.AccidentId);
		Ext.getCmp("AccidentName").setValue(data.AccidentName);
		Ext.getCmp("AccidentType").setValue(data.AccidentType);
		Ext.getCmp("Accessories").setValue(data.Accessories);
		Ext.getCmp("Remark").setValue(data.Remark);
		Ext.getCmp("Result").setValue(data.Result);
		Ext.getCmp("BillNo").setValue(data.BillNo);
	},
	failure: function(resp,opts){
		Ext.Msg.alert("��ʾ","��ȡ�û���Ϣʧ��");
	}
	});
}
/*------�������ý������ݵĺ��� End---------------*/
/*------����ͻ����������� start--------*/
var AccidentTypeAuditcombo = new Ext.form.ComboBox({
    fieldLabel: '����',
    name: 'folderaMoveTo',
    store: dsAccidentType,
    displayField: 'DicsName',
    valueField: 'DicsCode',
    mode: 'local',
    editable:false,
    //loadText:'loading ...',
    typeAhead: true, //�Զ�����һ����������ѡ�ȫ����
    triggerAction: 'all',
    selectOnFocus: true,
    forceSelection: true
});

var nameAccidentAuditPanel = new Ext.form.TextField({
    style: 'margin-left:0px',
    cls: 'key',
    xtype: 'textfield',
    fieldLabel: '����',
    name: 'name',
    anchor: '90%'
});
var serchAccAduitform = new Ext.FormPanel({
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
            columnWidth: .33,
            layout: 'form',
            border: false,
            items: [
                nameAccidentAuditPanel
                ]
        },{
            columnWidth: .33,
            layout: 'form',
            border: false,
            items: [
                AccidentTypeAuditcombo
                ]
        }, {
            columnWidth: .10,
            layout: 'form',
            border: false,
            items: [{ cls: 'key',
                xtype: 'button',
                text: '��ѯ',
                anchor: '50%',
                handler :function(){                
                    var name=nameAccidentAuditPanel.getValue();
                    var type = AccidentTypeAuditcombo.getValue();
                    //alert(name +":"+type);
                    AuditGridData.baseParams.AccidentName = name;
                    AuditGridData.baseParams.AccidentType = type;
                    AuditGridData.load({
                        params : {
                        start : 0,
                        limit : 10
                        } 
                      }); 
                    }
                }]
        },{
            columnWidth: .23,  //����ռ�õĿ�ȣ���ʶΪ20��
            layout: 'form',
            border: false
        }]
    }]
});
/*------�����ѯform end ----------------*/
/*------��ʼ��ȡ���ݵĺ��� start---------------*/
var AuditGridData = new Ext.data.Store
({
url: 'frmAccidentinfoAudit.aspx?method=getInfoList',
reader:new Ext.data.JsonReader({
	totalProperty:'totalProperty',
	root:'root'
},[
	{		name:'AccidentId'	},
	{		name:'AccidentName'	},
	{		name:'AccidentType'	},
	{		name:'Accessories'	},
	{		name:'Remark'	},
	{		name:'OperId'	},
	{		name:'CreateDate'	},	
	{		name:'UpdateDate'	},
	{		name:'Auditor'	},
	{		name:'Result'	},
	{		name:'AuditDate'	},
	{		name:'OrgId'	},
	{		name:'OwnerId'	},
	{		name:'BillNo'	},
	{		name:'BusiStatus'	},
	{       name:'AccidentTypeText'},
	{       name:'BusiStatusText'}
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
var AuditGrid = new Ext.grid.GridPanel({
	el: 'dataGrid',
	width:'100%',
	height:'100%',
	autoWidth:true,
	autoHeight:true,
	autoScroll:true,
	layout: 'fit',
	id: '',
	store: AuditGridData,
	loadMask: {msg:'���ڼ������ݣ����Ժ��'},
	sm:sm,
	cm: new Ext.grid.ColumnModel([
		sm,
		new Ext.grid.RowNumberer(),//�Զ��к�
		{
			header:'�Ǽ����',
			dataIndex:'AccidentId',
			id:'AccidentId',
			hidden:true,
			hideable:false
		},
		{
			header:'����',
			dataIndex:'AccidentName',
			id:'AccidentName'
		},
		{
			header:'����',
			dataIndex:'AccidentTypeText',
			id:'AccidentTypeText'
		},
		{
		    header:'�����ݺ�',
			dataIndex:'BillNo',
			id:'BillNo'
		},
		{
		    header:'����',
			dataIndex:'Accessories',
			id:'Accessories'
		},
		{
		    header:'������',
			dataIndex:'Result',
			id:'Result'
		},
		{
			header:'ҵ��״̬:',
			dataIndex:'BusiStatusText',
			id:'BusiStatusText'
		}		]),
		bbar: new Ext.PagingToolbar({
			pageSize: 10,
			store: AuditGridData,
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
AuditGrid.render();
/*------DataGrid�ĺ������� End---------------*/



})
</script>

</html>
