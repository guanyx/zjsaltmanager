<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmWmsProductCostAlgConf.aspx.cs" Inherits="WMS_frmWmsProductCostAlgConf" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html>
<head>
<title>仓库商品成本算法配置 </title><meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<link rel="stylesheet" type="text/css" href="../ext3/resources/css/ext-all.css" />
<script type="text/javascript" src="../ext3/adapter/ext/ext-base.js"></script>
<script type="text/javascript" src="../ext3/ext-all.js"></script>
<script type="text/javascript" src="../js/operateResp.js"></script>
</head>

<body>
<div id='toolbar'></div>
<div id='divForm'></div>
<div id='dataGrid'></div>

</body>

<%= getComboBoxStore() %>

<script type="text/javascript">
    Ext.BLANK_IMAGE_URL = "../ext3/resources/images/default/s.gif";
Ext.onReady(function(){
/*------实现toolbar的函数 start---------------*/
var Toolbar = new Ext.Toolbar({
	renderTo:"toolbar",
	items:[{
		text:"新增",
		icon:"../Theme/1/images/extjs/customer/add16.gif",
		handler:function(){
		    openAddConfWin();
		}
		},'-',{
		text:"编辑",
		icon:"../Theme/1/images/extjs/customer/edit16.gif",
		handler:function(){
		    modifyConfWin();
		}
		},'-',{
		text:"删除",
		icon:"../Theme/1/images/extjs/customer/delete16.gif",
		handler:function(){
		    deleteConf();
		}
	}]
});

/*------结束toolbar的函数 end---------------*/


/*------开始ToolBar事件函数 start---------------*//*-----新增Conf实体类窗体函数----*/
function openAddConfWin() {
    Ext.getCmp("ProductName").setDisabled(false);
    Ext.getCmp("WhId").setDisabled(false);
	uploadConfWindow.show();
}
/*-----编辑Conf实体类窗体函数----*/
function modifyConfWin() {
	var sm = gridData.getSelectionModel();
	//获取选择的数据信息
	var selectData =  sm.getSelected();
	if(selectData == null){
		Ext.Msg.alert("提示","请选中需要编辑的信息！");
		return;
	}
	Ext.getCmp("ProductName").setDisabled(true);
	Ext.getCmp("WhId").setDisabled(true);
	uploadConfWindow.show();
	setFormValue(selectData);
}
/*-----删除Conf实体函数----*/
/*删除信息*/
function deleteConf()
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
				url:'frmWmsProductCostAlgConf.aspx?method=deleteConf',
				method:'POST',
				params:{
					Id:selectData.data.Id
				},
				success: function(resp,opts){
				    if (checkExtMessage(resp)) {
				        updateDataGrid();
				    }
				}
			});
		}
	});
}

/*------实现FormPanle的函数 start---------------*/
/*------定义商品下拉框 start ----------*/
    
var AlgConfForm=new Ext.form.FormPanel({
	url:'',
	//renderTo:'divForm',
	frame:true,
	title:'',
	items:[
		{
			xtype:'textfield',
			fieldLabel:'流水ID',
			columnWidth:1,
			anchor:'90%',
			name:'Id',
			id:'Id',
			hidden:true,
			hideLabel:true
		}
,		{
			xtype:'combo',
			fieldLabel:'仓库',
			columnWidth:1,
			anchor:'90%',
			name:'WhId',
			id:'WhId',
			store:dsWh,
			displayField:'WhName',
			valueField:'WhId',
			mode:'local',
			triggerAction:'all',
			editable:false
		}
,		{
			xtype:'textfield',
			fieldLabel:'商品ID',
			columnWidth:1,
			anchor:'90%',
			name:'ProductId',
			id:'ProductId',
			hidden:true,
			hideLabel:true
		}
,		{
			xtype:'combo',
			fieldLabel:'商品',
			columnWidth:1,
			anchor:'90%',
			name:'ProductName',
			id:'ProductName',
			store:dsProductList,
			pageSize: 5,  
            minChars: 0,  
            hideTrigger: true,  
            typeAhead: true,  
            mode: 'local',      
            emptyText: '请选择商品',   
            selectOnFocus: false,
            editable: true,
            displayField:'ProductName',
            valueField:'ProductId',
            listeners:{ 
            "select":function(combo, record, index){ 
                Ext.getCmp("ProductId").setValue(record.data.ProductId);
                this.collapse();
             }
            }              
		}
,		{
			xtype:'combo',
			fieldLabel:'成本算法',
			columnWidth:1,
			anchor:'90%',
			name:'AlgorithmId',
			id:'AlgorithmId',
			store:dsFormula,
			displayField:'AlgorithmName',
			valueField:'AlgorithmId',
			mode:'local',
			triggerAction:'all',
			editable:false
		}
]
});
/*------FormPanle的函数结束 End---------------*/

/*------开始界面数据的窗体 Start---------------*/
if(typeof(uploadConfWindow)=="undefined"){//解决创建2个windows问题
	uploadConfWindow = new Ext.Window({
		id:'Confformwindow',
		title:'仓库商品成本算法配置'
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
		,items:AlgConfForm
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
				uploadConfWindow.hide();
			}
			, scope: this
		}]});
	}
	uploadConfWindow.addListener("hide",function(){
	    AlgConfForm.getForm().reset();
	    updateDataGrid();
    });

/*------开始获取界面数据的函数 start---------------*/
function saveUserData()
{
	Ext.Ajax.request({
	    url: 'frmWmsProductCostAlgConf.aspx?method=saveAlgConf',
		method:'POST',
		params:{
			Id:Ext.getCmp('Id').getValue(),
			WhId:Ext.getCmp('WhId').getValue(),
			ProductId:Ext.getCmp('ProductId').getValue(),
			AlgorithmId:Ext.getCmp('AlgorithmId').getValue()
		},
		success: function(resp,opts){			
			if (checkExtMessage(resp)) {
			    uploadConfWindow.hide();
            }
		}
	});
}

/*------结束获取界面数据的函数 End---------------*/

/*------开始界面数据的函数 Start---------------*/
function setFormValue(selectData)
{
	Ext.Ajax.request({
		url:'frmWmsProductCostAlgConf.aspx?method=getAlgConf',
		params:{
			Id:selectData.data.Id
		},
	    success: function(resp,opts){
		    var data=Ext.util.JSON.decode(resp.responseText);
		    Ext.getCmp("Id").setValue(data.Id);
		    Ext.getCmp("WhId").setValue(data.WhId);
		    Ext.getCmp("ProductId").setValue(data.ProductId);
		    Ext.getCmp("ProductName").setValue(data.ProductName);
		    Ext.getCmp("AlgorithmId").setValue(data.AlgorithmId);
	    },
	    failure: function(resp,opts){
		    Ext.Msg.alert("提示","获取商品算法配置信息失败！");
	    }
	});
}
/*------结束设置界面数据的函数 End---------------*/

/*------开始获取数据的函数 start---------------*/
var dsAlgConf = new Ext.data.Store
({
url: 'frmWmsProductCostAlgConf.aspx?method=getAlgConfList',
reader:new Ext.data.JsonReader({
	totalProperty:'totalProperty',
	root:'root'
},[
	{
		name:'Id'
	},
	{
		name:'OrgId'
	},
	{
		name:'WhName'
	},
	{
		name:'ProductId'
	},
	{
		name:'ProductName'
	},
	{
		name:'AlgorithmName'
	},
	{
		name:'OperId'
	},
	{
		name:'OwnerId'
	},
	{
		name:'CreateDate'
	},
	{
		name:'UpdateDate'
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
var gridData = new Ext.grid.GridPanel({
	el: 'dataGrid',
	width:'100%',
	height:'100%',
	autoWidth:true,
	autoHeight:true,
	autoScroll:true,
	layout: 'fit',
	id: '',
	store: dsAlgConf,
	loadMask: {msg:'正在加载数据，请稍侯……'},
	sm:sm,
	cm: new Ext.grid.ColumnModel([
		sm,
		new Ext.grid.RowNumberer(),//自动行号
		{
			header:'流水ID',
			dataIndex:'Id',
			id:'Id',
			hidden:true,
			hideable:false
		},
		{
			header:'仓库',
			dataIndex:'WhName',
			id:'WhName'
		},
		{
			header:'商品',
			dataIndex:'ProductName',
			id:'ProductName',
			renderer: function(value, cellmeta, record, rowIndex, columnIndex, store) { 
			    if(record.get('ProductId')<=0) return '所有商品';
			}
		},
		{
			header:'成本算法',
			dataIndex:'AlgorithmName',
			id:'AlgorithmName'
		}		]),
		bbar: new Ext.PagingToolbar({
			pageSize: 10,
			store: dsAlgConf,
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

function updateDataGrid(){
    dsAlgConf.load({params:{limit:10,start:0}});
}
/*------DataGrid的函数结束 End---------------*/
updateDataGrid();


})
</script>

</html>
