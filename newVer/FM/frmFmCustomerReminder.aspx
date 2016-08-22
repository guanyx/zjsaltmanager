<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmFmCustomerReminder.aspx.cs" Inherits="FM_frmFmCustomerReminder" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html>
<head>
<title>�ͻ��߽ɼ�¼ά��</title><meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<link rel="stylesheet" type="text/css" href="../ext3/resources/css/ext-all.css" />
<script type="text/javascript" src="../ext3/adapter/ext/ext-base.js"></script>
<script type="text/javascript" src="../ext3/ext-all.js"></script>
</head>

<body>
<div id='toolbar'></div>
<div id='divForm'></div>
<div id='dataGrid'></div>

</body>
<script type="text/javascript">
function getParamerValue( name )
{
  name = name.replace(/[\[]/,"\\\[").replace(/[\]]/,"\\\]");
  var regexS = "[\\?&]"+name+"=([^&#]*)";
  var regex = new RegExp( regexS );
  var results = regex.exec( window.location.href );
  if( results == null )
    return "";
  else
    return results[1];
}
var CustomerId = getParamerValue('CustomerId');
</script>
<%= getComboBoxStore() %>
<script type="text/javascript">
Ext.BLANK_IMAGE_URL = "../ext3/resources/images/default/s.gif"; 
Ext.onReady(function(){
var saveType;
/*------ʵ��toolbar�ĺ��� start---------------*/
var Toolbar = new Ext.Toolbar({
	renderTo:"toolbar",
	items:[{
		text:"����",
		icon:"../Theme/1/images/extjs/customer/add16.gif",
		handler:function(){
		    saveType = 'addReminder';
		    openAddReminderWin();
		}
		},'-',{
		text:"�༭",
		icon:"../Theme/1/images/extjs/customer/edit16.gif",
		handler:function(){
		    saveType = 'saveReminder';
		    modifyReminderWin();
		}
	}]
});

/*------����toolbar�ĺ��� end---------------*/


/*------��ʼToolBar�¼����� start---------------*/
/*-----����Reminderʵ���ര�庯��----*/
function openAddReminderWin() {
	uploadReminderWindow.show();
}
/*-----�༭Reminderʵ���ര�庯��----*/
function modifyReminderWin() {
	var sm = gridData.getSelectionModel();
	//��ȡѡ���������Ϣ
	var selectData =  sm.getSelected();
	if(selectData == null){
		Ext.Msg.alert("��ʾ","��ѡ����Ҫ�༭����Ϣ��");
		return;
	}
	uploadReminderWindow.show();
	setFormValue(selectData);
}


/*------ʵ��FormPanle�ĺ��� start---------------*/
var remindForm=new Ext.form.FormPanel({
	labelWidth:55,
	frame:true,
	title:'',
	items:[
		{
			xtype:'hidden',
			fieldLabel:'�������',
			columnWidth:.9,
			anchor:'90%',
			name:'ReminderId',
			id:'ReminderId',
			hidden:true,
			hideLabel:true
		}
,		{
			xtype:'combo',
			fieldLabel:'�߽ɷ�ʽ',
			columnWidth:.9,
			anchor:'90%',
			name:'ReminderType',
			id:'ReminderType',
			store:dsReminderType,
			displayField:'DicsName',
			valueField:'DicsCode',
			triggerAction:'all',
			mode:'local',
			editable:false
		}
,		{
			xtype:'combo',
			fieldLabel:'ҵ��״̬',
			columnWidth:.9,
			anchor:'90%',
			name:'ReminderStatus',
			id:'ReminderStatus',
			store:dsStatus,
			displayField:'DicsName',
			valueField:'DicsCode',
			triggerAction:'all',
			mode:'local',
			editable:false
		}
,		{
			xtype:'textarea',
			fieldLabel:'������Ϣ',
			columnWidth:.9,
			anchor:'90%',
			name:'FeedbackInfo',
			id:'FeedbackInfo',
			height:100
		}
]
});
/*------FormPanle�ĺ������� End---------------*/

/*------��ʼ�������ݵĴ��� Start---------------*/
if(typeof(uploadReminderWindow)=="undefined"){//�������2��windows����
	uploadReminderWindow = new Ext.Window({
		id:'Reminderformwindow',
		title:'�ͻ���ͨ��Ϣ�Ǽ�'
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
		,items:remindForm
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
				uploadReminderWindow.hide();
			}
			, scope: this
		}]});
	}
	uploadReminderWindow.addListener("hide",function(){
});

/*------��ʼ��ȡ�������ݵĺ��� start---------------*/
function saveUserData()
{
	Ext.Ajax.request({
		url:'frmFmCustomerReminder.aspx?method='+saveType,
		method:'POST',
		params:{
		    CustomerId:CustomerId,
			ReminderId:Ext.getCmp('ReminderId').getValue(),
			ReminderType:Ext.getCmp('ReminderType').getValue(),
			FeedbackInfo:Ext.getCmp('FeedbackInfo').getValue(),
			ReminderStatus:Ext.getCmp('ReminderStatus').getValue()
			},
		success: function(resp,opts){
			Ext.Msg.alert("��ʾ","����ɹ�");
			dsGridData.reload();
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
	Ext.Ajax.request({
		url:'frmFmCustomerReminder.aspx?method=getReminder',
		params:{
			ReminderId:selectData.data.ReminderId
		},
	success: function(resp,opts){
		var data=Ext.util.JSON.decode(resp.responseText);
		Ext.getCmp("ReminderId").setValue(data.ReminderId);
		Ext.getCmp("ReminderType").setValue(data.ReminderType);
		Ext.getCmp("FeedbackInfo").setValue(data.FeedbackInfo);
		Ext.getCmp("ReminderStatus").setValue(data.ReminderStatus);
	},
	failure: function(resp,opts){
		Ext.Msg.alert("��ʾ","��ȡ�û���Ϣʧ��");
	}
	});
}
/*------�������ý������ݵĺ��� End---------------*/

/*------��ʼ��ȡ���ݵĺ��� start---------------*/
var dsGridData = new Ext.data.Store
({
url: 'frmFmCustomerReminder.aspx?method=getReminderList',
reader:new Ext.data.JsonReader({
	totalProperty:'totalProperty',
	root:'root'
},[
	{		name:'ReminderId'	},
	{		name:'ReceivableId'	},
	{		name:'ReminderType'	},
	{		name:'FeedbackInfo'	},
	{		name:'ReminderStatus'	},
	{		name:'Status'	},
	{		name:'OperId'	},
	{		name:'OrgId'	},
	{		name:'CustomerId'	},
	{		name:'CreateDate'	},
	{		name:'ReminderTypeText'	},
	{		name:'ReminderStatusText'	},
	{		name:'OperName'
	}	])
	,
	listeners:
	{
		scope:this,
		load:function(){
		}
	}
});
dsGridData.baseParams.CustomerId = CustomerId;
dsGridData.load({
    params:{
        limit:10,
        start:0
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
	id: '',
	store: dsGridData,
	loadMask: {msg:'���ڼ������ݣ����Ժ��'},
	sm:sm,
	cm: new Ext.grid.ColumnModel([
		sm,
		new Ext.grid.RowNumberer(),//�Զ��к�
		{
			header:'���',
			dataIndex:'ReminderId',
			id:'ReminderId',
			hidden:true,
			hideable:false
		},
		{
			header:'�ͻ����',
			dataIndex:'CustomerId',
			id:'CustomerId',
			hidden:true,
			hideable:false
		},
		{
			header:'�߽ɷ�ʽ',
			dataIndex:'ReminderTypeText',
			id:'ReminderTypeText'
		},
		{
			header:'������Ϣ',
			dataIndex:'FeedbackInfo',
			id:'FeedbackInfo'
		},
		{
			header:'ҵ��״̬',
			dataIndex:'ReminderStatusText',
			id:'ReminderStatusText'
		},
		{
			header:'������Ա',
			dataIndex:'OperName',
			id:'OperName'
		},
		{
			header:'��������',
			dataIndex:'CreateDate',
			id:'CreateDate',
			renderer: Ext.util.Format.dateRenderer('Y��m��d��')
		}
		]),
		bbar: new Ext.PagingToolbar({
			pageSize: 10,
			store: dsGridData,
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



})
</script>
</html>

