<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmPmsWorkshopList.aspx.cs" Inherits="PMS_frmPmsWorkshop" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html>
<head>
<title>��������Ǽ�</title><meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<link rel="stylesheet" type="text/css" href="../ext3/resources/css/ext-all.css" />
<script type="text/javascript" src="../ext3/adapter/ext/ext-base.js"></script>
<script type="text/javascript" src="../ext3/ext-all.js"></script>
<script type="text/javascript" src="../ext3/example/CheckBoxPlug.js"></script>
<script type="text/javascript" src="../js/operateResp.js"></script>
</head>
<body>
<div id='toolbar'></div>
<div id='divForm'></div>
<div id='dataGrid'></div>

</body>
<script type="text/javascript">
Ext.onReady(function(){
var saveType;
/*------ʵ��toolbar�ĺ��� start---------------*/
var Toolbar = new Ext.Toolbar({
	renderTo:"toolbar",
	items:[{
		text:"����",
		icon:"../Theme/1/images/extjs/customer/add16.gif",
		handler:function(){
		    saveType ='addWorkshop';
		    openAddWorkshopWin();
		}
		},'-',{
		text:"�༭",
		icon:"../Theme/1/images/extjs/customer/edit16.gif",
		handler:function(){
		    saveType ='saveWorkshop';
		    modifyWorkshopWin();
		}
		},'-',{
		text:"ɾ��",
		icon:"../Theme/1/images/extjs/customer/delete16.gif",
		handler:function(){
		    deleteWorkshop();
		}
	}]
});

/*------����toolbar�ĺ��� end---------------*/


/*------��ʼToolBar�¼����� start---------------*//*-----����Workshopʵ���ര�庯��----*/
function openAddWorkshopWin() {
	uploadWorkshopWindow.show();
	dsEmpInfo.load();
}
/*-----�༭Workshopʵ���ര�庯��----*/
function modifyWorkshopWin() {
	var sm = pmsworkshopGrid.getSelectionModel();
	//��ȡѡ���������Ϣ
	var selectData =  sm.getSelected();
	if(selectData == null){
		Ext.Msg.alert("��ʾ","��ѡ����Ҫ�༭����Ϣ��");
		return;
	}
	uploadWorkshopWindow.show();
	setFormValue(selectData);	
}
/*-----ɾ��Workshopʵ�庯��----*/
/*ɾ����Ϣ*/
function deleteWorkshop()
{
	var sm = pmsworkshopGrid.getSelectionModel();
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
				url:'frmPmsWorkshopList.aspx?method=deleteWorkshop',
				method:'POST',
				params:{
					WsId:selectData.data.WsId
				},
				success: function(resp,opts){
				    dspmsworkshop.reload();
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
var pmsworkshopform=new Ext.form.FormPanel({
	url:'',
	frame:true,
	title:'',
	labelWidth:55,
	height:150,
	region: 'north',
	items:[
		{
			xtype:'hidden',
			fieldLabel:'����ID',
			columnWidth:1,
			anchor:'98%',
			name:'WsId',
			id:'WsId',
			hidden:true,
			hideable:false
		}
,		{
			xtype:'textfield',
			fieldLabel:'�������',
			columnWidth:1,
			anchor:'98%',
			name:'WsCode',
			id:'WsCode'
		}
,		{
			xtype:'textfield',
			fieldLabel:'��������',
			columnWidth:1,
			anchor:'98%',
			name:'WsName',
			id:'WsName'
		}
,		{
			xtype:'textfield',
			fieldLabel:'����',
			columnWidth:1,
			anchor:'98%',
			name:'GroupIds',
			id:'GroupIds'
		}
,		{
			xtype:'textarea',
			fieldLabel:'��ע',
			columnWidth:1,
			height:50,
			anchor:'98%',
			name:'Remark',
			id:'Remark'
		}
]
});
/*------FormPanle�ĺ������� End---------------*/
/*------��Աgrid�ĺ��� start---------------*/
var dsEmpInfo = new Ext.data.Store
({
url: 'frmPmsWorkshopList.aspx?method=getEmpInfoList',
reader:new Ext.data.JsonReader({
	totalProperty:'totalProperty',
	root:'root'
},[
	{		name:'Id'	},
	{		name:'EmpId'	},
	{		name:'EmpIdText',type: 'string'	},
	{		name:'Status',type: 'bool'
	}	])
});

var checkColumn = new Ext.grid.CheckColumn({
       header: 'ѡ��',
       dataIndex: 'Status',
       width: 50,
       align: 'center'
    });
var employeeGrid = new Ext.grid.EditorGridPanel({	
	width:'100%',
	height:'100%',
	autoWidth:true,
	autoHeight:true,
	autoScroll:true,
	region: 'center',
	id: '',
	plugins: checkColumn,
	store: dsEmpInfo,
	loadMask: {msg:'���ڼ������ݣ����Ժ��'},
	cm: new Ext.grid.ColumnModel([
		new Ext.grid.RowNumberer(),//�Զ��к�
		{
			header:'��ˮ��',
			dataIndex:'Id',
			id:'Id',
			hidden: true,
            hideable: false
		},
		{
			header:'��Աid',
			dataIndex:'EmpId',
			id:'EmpId',
			hidden: true,
            hideable: false
		},
		{
			header:'��Ա',
			dataIndex:'EmpIdText',
			id:'EmpIdText'
		},
		checkColumn 
		]),
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
/*------��Աgrid�ĺ��� End---------------*/

/*------��ʼ�������ݵĴ��� Start---------------*/
if(typeof(uploadWorkshopWindow)=="undefined"){//�������2��windows����
	uploadWorkshopWindow = new Ext.Window({
		id:'Workshopformwindow',
		title:''
		, iconCls: 'upload-win'
		, width: 500
		, height: 450
		, layout: 'border'
		, plain: true
		, modal: true
		, constrain:true
		, resizable: false
		, closeAction: 'hide'
		,autoDestroy :true
		,items:[pmsworkshopform,employeeGrid]
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
				uploadWorkshopWindow.hide();
			}
			, scope: this
		}]});
	}
	uploadWorkshopWindow.addListener("hide",function(){
	    pmsworkshopform.getForm().reset();
});

/*------��ʼ��ȡ�������ݵĺ��� start---------------*/
function saveUserData()
{
    var json = "";
    dsEmpInfo.each(function(record) {
        json += Ext.util.JSON.encode(record.data) + ',';
    });
    json = json.substring(0, json.length - 1);
    //Ȼ�����������
    //alert(json);
    
	Ext.Ajax.request({
		url:'frmPmsWorkshopList.aspx?method='+saveType,
		method:'POST',
		params:{
			WsId:Ext.getCmp('WsId').getValue(),
			WsCode:Ext.getCmp('WsCode').getValue(),
			WsName:Ext.getCmp('WsName').getValue(),
			GroupIds:Ext.getCmp('GroupIds').getValue(),
			Remark:Ext.getCmp('Remark').getValue(),
			DetailInfo:	json		},
		success: function(resp,opts){
		    if(checkExtMessage(resp)){
			    dspmsworkshop.reload();
			}
		},
		failure: function(resp,opts){
			Ext.Msg.alert("��ʾ","����ʧ��");
		}
		});
		}
/*------������ȡ�������ݵĺ��� End---------------*/

/*------��ʼ�������ݵĺ��� Start---------------*/
function setFormValue(selectData)
{
    //grid
    dsEmpInfo.load({params:{WsId:selectData.data.WsId}});
    //form
	Ext.Ajax.request({
		url:'frmPmsWorkshopList.aspx?method=getworkshop',
		params:{
			WsId:selectData.data.WsId
		},
	success: function(resp,opts){
		var data=Ext.util.JSON.decode(resp.responseText);
		Ext.getCmp("WsId").setValue(data.WsId);
		Ext.getCmp("WsCode").setValue(data.WsCode);
		Ext.getCmp("WsName").setValue(data.WsName);
		Ext.getCmp("GroupIds").setValue(data.GroupIds);
		Ext.getCmp("Remark").setValue(data.Remark);
	},
	failure: function(resp,opts){
		Ext.Msg.alert("��ʾ","��ȡ�û���Ϣʧ��");
	}
	});
}
/*------�������ý������ݵĺ��� End---------------*/

/*------��ʼ��ȡ���ݵĺ��� start---------------*/
var dspmsworkshop = new Ext.data.Store
({
url: 'frmPmsWorkshopList.aspx?method=getWorkshopList',
reader:new Ext.data.JsonReader({
	totalProperty:'totalProperty',
	root:'root'
},[
	{		name:'WsId'	},
	{		name:'WsCode'	},
	{		name:'WsName'	},
	{		name:'OrgId'	},
	{		name:'OperId'	},
	{		name:'OwnerId'	},
	{		name:'Status'	},
	{		name:'CreateDate'	},
	{		name:'UpdateDate'	},
	{		name:'GroupIds'	},
	{		name:'Remark'
	}	])
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
var pmsworkshopGrid = new Ext.grid.GridPanel({
	el: 'dataGrid',
	width:'100%',
	height:'100%',
	autoWidth:true,
	autoHeight:true,
	autoScroll:true,
	layout: 'fit',
	id: '',
	store: dspmsworkshop,
	loadMask: {msg:'���ڼ������ݣ����Ժ��'},
	sm:sm,
	cm: new Ext.grid.ColumnModel([
		sm,
		new Ext.grid.RowNumberer(),//�Զ��к�
		{
			header:'����ID',
			dataIndex:'WsId',
			id:'WsId',
			hidden:true,
			hideable:false
		},
		{
			header:'�������',
			dataIndex:'WsCode',
			id:'WsCode'
		},
		{
			header:'��������',
			dataIndex:'WsName',
			id:'WsName'
		},
		{
			header:'״̬',
			dataIndex:'Status',
			id:'Status',
			renderer:function(v){if(v==0) return '����'; if(v==1) return 'ɾ��'}
		},
		{
			header:'����',
			dataIndex:'GroupIds',
			id:'GroupIds'
		},
		{
			header:'����ʱ��',
			dataIndex:'CreateDate',
			id:'CreateDate'
		}
		]),
		bbar: new Ext.PagingToolbar({
			pageSize: 10,
			store: dspmsworkshop,
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
pmsworkshopGrid.render();
dspmsworkshop.load({params:{start:0,limit:10}});
/*------DataGrid�ĺ������� End---------------*/



})
</script>
</html>
