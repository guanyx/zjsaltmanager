<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmPmsWorkshopList.aspx.cs" Inherits="PMS_frmPmsWorkshop" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html>
<head>
<title>生产车间登记</title><meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
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
/*------实现toolbar的函数 start---------------*/
var Toolbar = new Ext.Toolbar({
	renderTo:"toolbar",
	items:[{
		text:"新增",
		icon:"../Theme/1/images/extjs/customer/add16.gif",
		handler:function(){
		    saveType ='addWorkshop';
		    openAddWorkshopWin();
		}
		},'-',{
		text:"编辑",
		icon:"../Theme/1/images/extjs/customer/edit16.gif",
		handler:function(){
		    saveType ='saveWorkshop';
		    modifyWorkshopWin();
		}
		},'-',{
		text:"删除",
		icon:"../Theme/1/images/extjs/customer/delete16.gif",
		handler:function(){
		    deleteWorkshop();
		}
	}]
});

/*------结束toolbar的函数 end---------------*/


/*------开始ToolBar事件函数 start---------------*//*-----新增Workshop实体类窗体函数----*/
function openAddWorkshopWin() {
	uploadWorkshopWindow.show();
	dsEmpInfo.load();
}
/*-----编辑Workshop实体类窗体函数----*/
function modifyWorkshopWin() {
	var sm = pmsworkshopGrid.getSelectionModel();
	//获取选择的数据信息
	var selectData =  sm.getSelected();
	if(selectData == null){
		Ext.Msg.alert("提示","请选中需要编辑的信息！");
		return;
	}
	uploadWorkshopWindow.show();
	setFormValue(selectData);	
}
/*-----删除Workshop实体函数----*/
/*删除信息*/
function deleteWorkshop()
{
	var sm = pmsworkshopGrid.getSelectionModel();
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
				url:'frmPmsWorkshopList.aspx?method=deleteWorkshop',
				method:'POST',
				params:{
					WsId:selectData.data.WsId
				},
				success: function(resp,opts){
				    dspmsworkshop.reload();
					Ext.Msg.alert("提示","数据删除成功");
				},
				failure: function(resp,opts){
					Ext.Msg.alert("提示","数据删除失败");
				}
			});
		}
	});
}

/*------实现FormPanle的函数 start---------------*/
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
			fieldLabel:'车间ID',
			columnWidth:1,
			anchor:'98%',
			name:'WsId',
			id:'WsId',
			hidden:true,
			hideable:false
		}
,		{
			xtype:'textfield',
			fieldLabel:'车间编码',
			columnWidth:1,
			anchor:'98%',
			name:'WsCode',
			id:'WsCode'
		}
,		{
			xtype:'textfield',
			fieldLabel:'车间名称',
			columnWidth:1,
			anchor:'98%',
			name:'WsName',
			id:'WsName'
		}
,		{
			xtype:'textfield',
			fieldLabel:'班组',
			columnWidth:1,
			anchor:'98%',
			name:'GroupIds',
			id:'GroupIds'
		}
,		{
			xtype:'textarea',
			fieldLabel:'备注',
			columnWidth:1,
			height:50,
			anchor:'98%',
			name:'Remark',
			id:'Remark'
		}
]
});
/*------FormPanle的函数结束 End---------------*/
/*------人员grid的函数 start---------------*/
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
       header: '选择',
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
	loadMask: {msg:'正在加载数据，请稍侯……'},
	cm: new Ext.grid.ColumnModel([
		new Ext.grid.RowNumberer(),//自动行号
		{
			header:'流水号',
			dataIndex:'Id',
			id:'Id',
			hidden: true,
            hideable: false
		},
		{
			header:'人员id',
			dataIndex:'EmpId',
			id:'EmpId',
			hidden: true,
            hideable: false
		},
		{
			header:'人员',
			dataIndex:'EmpIdText',
			id:'EmpIdText'
		},
		checkColumn 
		]),
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
/*------人员grid的函数 End---------------*/

/*------开始界面数据的窗体 Start---------------*/
if(typeof(uploadWorkshopWindow)=="undefined"){//解决创建2个windows问题
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
			text: "保存"
			, handler: function() {
				saveUserData();
			}
			, scope: this
		},
		{
			text: "取消"
			, handler: function() { 
				uploadWorkshopWindow.hide();
			}
			, scope: this
		}]});
	}
	uploadWorkshopWindow.addListener("hide",function(){
	    pmsworkshopform.getForm().reset();
});

/*------开始获取界面数据的函数 start---------------*/
function saveUserData()
{
    var json = "";
    dsEmpInfo.each(function(record) {
        json += Ext.util.JSON.encode(record.data) + ',';
    });
    json = json.substring(0, json.length - 1);
    //然后传入参数保存
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
			Ext.Msg.alert("提示","保存失败");
		}
		});
		}
/*------结束获取界面数据的函数 End---------------*/

/*------开始界面数据的函数 Start---------------*/
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
		Ext.Msg.alert("提示","获取用户信息失败");
	}
	});
}
/*------结束设置界面数据的函数 End---------------*/

/*------开始获取数据的函数 start---------------*/
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

/*------获取数据的函数 结束 End---------------*/

/*------开始DataGrid的函数 start---------------*/

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
	loadMask: {msg:'正在加载数据，请稍侯……'},
	sm:sm,
	cm: new Ext.grid.ColumnModel([
		sm,
		new Ext.grid.RowNumberer(),//自动行号
		{
			header:'车间ID',
			dataIndex:'WsId',
			id:'WsId',
			hidden:true,
			hideable:false
		},
		{
			header:'车间编码',
			dataIndex:'WsCode',
			id:'WsCode'
		},
		{
			header:'车间名称',
			dataIndex:'WsName',
			id:'WsName'
		},
		{
			header:'状态',
			dataIndex:'Status',
			id:'Status',
			renderer:function(v){if(v==0) return '正常'; if(v==1) return '删除'}
		},
		{
			header:'班组',
			dataIndex:'GroupIds',
			id:'GroupIds'
		},
		{
			header:'创建时间',
			dataIndex:'CreateDate',
			id:'CreateDate'
		}
		]),
		bbar: new Ext.PagingToolbar({
			pageSize: 10,
			store: dspmsworkshop,
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
pmsworkshopGrid.render();
dspmsworkshop.load({params:{start:0,limit:10}});
/*------DataGrid的函数结束 End---------------*/



})
</script>
</html>
