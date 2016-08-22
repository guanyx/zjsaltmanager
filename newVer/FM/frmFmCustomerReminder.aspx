<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmFmCustomerReminder.aspx.cs" Inherits="FM_frmFmCustomerReminder" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html>
<head>
<title>客户催缴记录维护</title><meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
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
/*------实现toolbar的函数 start---------------*/
var Toolbar = new Ext.Toolbar({
	renderTo:"toolbar",
	items:[{
		text:"新增",
		icon:"../Theme/1/images/extjs/customer/add16.gif",
		handler:function(){
		    saveType = 'addReminder';
		    openAddReminderWin();
		}
		},'-',{
		text:"编辑",
		icon:"../Theme/1/images/extjs/customer/edit16.gif",
		handler:function(){
		    saveType = 'saveReminder';
		    modifyReminderWin();
		}
	}]
});

/*------结束toolbar的函数 end---------------*/


/*------开始ToolBar事件函数 start---------------*/
/*-----新增Reminder实体类窗体函数----*/
function openAddReminderWin() {
	uploadReminderWindow.show();
}
/*-----编辑Reminder实体类窗体函数----*/
function modifyReminderWin() {
	var sm = gridData.getSelectionModel();
	//获取选择的数据信息
	var selectData =  sm.getSelected();
	if(selectData == null){
		Ext.Msg.alert("提示","请选中需要编辑的信息！");
		return;
	}
	uploadReminderWindow.show();
	setFormValue(selectData);
}


/*------实现FormPanle的函数 start---------------*/
var remindForm=new Ext.form.FormPanel({
	labelWidth:55,
	frame:true,
	title:'',
	items:[
		{
			xtype:'hidden',
			fieldLabel:'付款序号',
			columnWidth:.9,
			anchor:'90%',
			name:'ReminderId',
			id:'ReminderId',
			hidden:true,
			hideLabel:true
		}
,		{
			xtype:'combo',
			fieldLabel:'催缴方式',
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
			fieldLabel:'业务状态',
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
			fieldLabel:'反馈信息',
			columnWidth:.9,
			anchor:'90%',
			name:'FeedbackInfo',
			id:'FeedbackInfo',
			height:100
		}
]
});
/*------FormPanle的函数结束 End---------------*/

/*------开始界面数据的窗体 Start---------------*/
if(typeof(uploadReminderWindow)=="undefined"){//解决创建2个windows问题
	uploadReminderWindow = new Ext.Window({
		id:'Reminderformwindow',
		title:'客户沟通信息登记'
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
			text: "保存"
			, handler: function() {
				saveUserData();
			}
			, scope: this
		},
		{
			text: "取消"
			, handler: function() { 
				uploadReminderWindow.hide();
			}
			, scope: this
		}]});
	}
	uploadReminderWindow.addListener("hide",function(){
});

/*------开始获取界面数据的函数 start---------------*/
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
			Ext.Msg.alert("提示","保存成功");
			dsGridData.reload();
		},
		failure: function(resp,opts){
			Ext.Msg.alert("提示","保存失败");
		}
	});
}
/*------结束获取界面数据的函数 End---------------*/

/*------开始界面数据的函数 Start---------------*/
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
		Ext.Msg.alert("提示","获取用户信息失败");
	}
	});
}
/*------结束设置界面数据的函数 End---------------*/

/*------开始获取数据的函数 start---------------*/
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

/*------获取数据的函数 结束 End---------------*/

/*------开始DataGrid的函数 start---------------*/

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
	loadMask: {msg:'正在加载数据，请稍侯……'},
	sm:sm,
	cm: new Ext.grid.ColumnModel([
		sm,
		new Ext.grid.RowNumberer(),//自动行号
		{
			header:'序号',
			dataIndex:'ReminderId',
			id:'ReminderId',
			hidden:true,
			hideable:false
		},
		{
			header:'客户编号',
			dataIndex:'CustomerId',
			id:'CustomerId',
			hidden:true,
			hideable:false
		},
		{
			header:'催缴方式',
			dataIndex:'ReminderTypeText',
			id:'ReminderTypeText'
		},
		{
			header:'反馈信息',
			dataIndex:'FeedbackInfo',
			id:'FeedbackInfo'
		},
		{
			header:'业务状态',
			dataIndex:'ReminderStatusText',
			id:'ReminderStatusText'
		},
		{
			header:'创建人员',
			dataIndex:'OperName',
			id:'OperName'
		},
		{
			header:'创建日期',
			dataIndex:'CreateDate',
			id:'CreateDate',
			renderer: Ext.util.Format.dateRenderer('Y年m月d日')
		}
		]),
		bbar: new Ext.PagingToolbar({
			pageSize: 10,
			store: dsGridData,
			displayMsg: '显示第{0}条到{1}条记录,共{2}条',
			emptyMsy: '没有记录',
			displayInfo: true
		}),
		viewConfig: {
			columnsText: '显示的列',
			scrollOffset: 20,
			sortAscText: '升序',
			sortDescText: '降序',
			forceFit: true
		},
		height: 280,
		closeAction: 'hide',
		stripeRows: true,
		loadMask: true,
		autoExpandColumn: 2
	});
gridData.render();
/*------DataGrid的函数结束 End---------------*/



})
</script>
</html>

