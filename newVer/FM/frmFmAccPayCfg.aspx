<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmFmAccPayCfg.aspx.cs" Inherits="FM_frmFmAccPayCfg" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html>
<head>
<title>应付款提醒指标设置</title><meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<link rel="stylesheet" type="text/css" href="../ext3/resources/css/ext-all.css" />
<script type="text/javascript" src="../ext3/adapter/ext/ext-base.js"></script>
<script type="text/javascript" src="../ext3/ext-all.js"></script>
<script type="text/javascript" src="../js/operateResp.js"></script>
<script type="text/javascript" src="../ext3/src/locale/ext-lang-zh_CN.js"></script>
</head>
<body>
<div id='toolbar'></div>
<div id='divForm'></div>
<div id='dataGrid'></div>
<%=getComboBoxStore()%>
</body>
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
		  saveType='addCfg';
		    openAddCfgWin();
		}
		},'-',{
		text:"编辑",
		icon:"../Theme/1/images/extjs/customer/edit16.gif",
		handler:function(){
		    saveType = 'saveCfg';
		    modifyCfgWin();
		}
		},'-',{
		text:"删除",
		icon:"../Theme/1/images/extjs/customer/delete16.gif",
		handler:function(){
		    deleteCfg();
		}
	}]
});

/*------结束toolbar的函数 end---------------*/


/*------开始ToolBar事件函数 start---------------*//*-----新增Cfg实体类窗体函数----*/
function openAddCfgWin() {
	uploadCfgWindow.show();
}
/*-----编辑Cfg实体类窗体函数----*/
function modifyCfgWin() {
	var sm = gridData.getSelectionModel();
	//获取选择的数据信息
	var selectData =  sm.getSelected();
	if(selectData == null){
		Ext.Msg.alert("提示","请选中需要编辑的信息！");
		return;
	}
	uploadCfgWindow.show();
	setFormValue(selectData);
}
/*-----删除Cfg实体函数----*/
/*删除信息*/
function deleteCfg()
{
	var sm = gridData.getSelectionModel();
	//获取选择的数据信息
	var selectData =  sm.getSelected();
	//如果没有选择，就提示需要选择数据信息
	if(selectData == null){
		Ext.Msg.alert("提示","请选中需要删除的信息！");
		return;
	}
	//删除前再次提醒是否真的要删除
	Ext.Msg.confirm("提示信息","是否真的要删除选择的信息吗？",function callBack(id){
		//判断是否删除数据
		if(id=="yes")
		{
			//页面提交
			Ext.Ajax.request({
				url:'frmFmAccPayCfg.aspx?method=deleteCfg',
				method:'POST',
				params:{
					DoneCode:selectData.data.DoneCode
				},
				success: function(resp,opts){
					Ext.Msg.alert("提示","数据删除成功");
					dsGridData.reload();
				},
				failure: function(resp,opts){
					Ext.Msg.alert("提示","数据删除失败");
				}
			});
		}
	});
}

/*------实现FormPanle的函数 start---------------*/
var cfgForm=new Ext.form.FormPanel({
	url:'',
	frame:true,
	title:'',
	items:[
		{
			xtype:'hidden',
			fieldLabel:'序号',
			name:'DoneCode',
			id:'DoneCode',
			hidden:true,
			hideable:false
		}
,		{
			xtype:'datefield',
			fieldLabel:'提醒日期',
			columnWidth:1,
			anchor:'90%',
			name:'DeadDate',
			id:'DeadDate',
			value: new Date().clearTime(),
			format:'Y年m月d日'			
		}
,		{
			xtype:'numberfield',
			fieldLabel:'限制金额',
			columnWidth:1,
			anchor:'90%',
			name:'LimitFund',
			id:'LimitFund'
		}
,		{
			xtype:'combo',
			fieldLabel:'提醒类型',
			columnWidth:1,
			anchor:'90%',
			name:'AlarmInter',
			id:'AlarmInter',
			store:dsAlert,
			displayField:'DicsName',
			valueField:'DicsCode',
			mode:'local',
			triggerAction:'all'
		}
]
});
/*------FormPanle的函数结束 End---------------*/

/*------开始界面数据的窗体 Start---------------*/
if(typeof(uploadCfgWindow)=="undefined"){//解决创建2个windows问题
	uploadCfgWindow = new Ext.Window({
		id:'Cfgformwindow',
		title:'指标设置'
		, iconCls: 'upload-win'
		, width: 400
		, height: 200
		, layout: 'fit'
		, plain: true
		, modal: true
		, constrain:true
		, resizable: false
		, closeAction: 'hide'
		,autoDestroy :true
		,items:cfgForm
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
				uploadCfgWindow.hide();
			}
			, scope: this
		}]});
	}
	uploadCfgWindow.addListener("hide",function(){
});

/*------开始获取界面数据的函数 start---------------*/
function saveUserData()
{
	Ext.Ajax.request({
		url:'frmFmAccPayCfg.aspx?method='+saveType,
		method:'POST',
		params:{
			DoneCode:Ext.getCmp('DoneCode').getValue(),
			DeadDate:Ext.util.Format.date(Ext.getCmp('DeadDate').getValue(),'Y/m/d'),
			LimitFund:Ext.getCmp('LimitFund').getValue(),
			AlarmInter:Ext.getCmp('AlarmInter').getValue()
				},
		success: function(resp,opts){
			if( checkExtMessage(resp) ){
			    dsGridData.reload()
			}
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
		url:'frmFmAccPayCfg.aspx?method=getCfg',
		params:{
			DoneCode:selectData.data.DoneCode
		},
	success: function(resp,opts){
		var data=Ext.util.JSON.decode(resp.responseText);
		Ext.getCmp("DoneCode").setValue(data.DoneCode);
		Ext.getCmp("DeadDate").setValue((new Date(data.DeadDate.replace(/-/g,"/"))));
		Ext.getCmp("LimitFund").setValue(data.LimitFund);
		Ext.getCmp("AlarmInter").setValue(data.AlarmInter);
	},
	failure: function(resp,opts){
		Ext.Msg.alert("提示","获取信息失败");
	}
	});
}
/*------结束设置界面数据的函数 End---------------*/

/*------开始获取数据的函数 start---------------*/
var dsGridData = new Ext.data.Store
({
url: 'frmFmAccPayCfg.aspx?method=getCfgList',
reader:new Ext.data.JsonReader({
	totalProperty:'totalProperty',
	root:'root'
},[
	{		name:'DoneCode'	},
	{		name:'DeadDate'	},
	{		name:'LimitFund'	},
	{		name:'AlarmInterText'	},
	{		name:'CrtDate'	},		
	{		name:'Status'	}	
	])
	,
	listeners:
	{
		scope:this,
		load:function(){
		}
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
			dataIndex:'DoneCode',
			id:'DoneCode',
			hidden:true,
			hideable:false
		},
		{
			header:'提醒日期',
			dataIndex:'DeadDate',
			id:'DeadDate',
			renderer: Ext.util.Format.dateRenderer('Y年m月d日')
		},
		{
			header:'限制金额',
			dataIndex:'LimitFund',
			id:'LimitFund'
		},
		{
			header:'提醒类型',
			dataIndex:'AlarmInterText',
			id:'AlarmInterText'
		},
		{
			header:'状态',
			dataIndex:'Status',
			id:'Status',
			renderer:function(v){
			    if(v==0) return '有效';
			    else return '实效';
			}
		},
		{
			header:'操作时间',
			dataIndex:'CrtDate',
			id:'CrtDate',
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
dsGridData.load({params:{start:0,limit:10}})


})
</script>
</html>
