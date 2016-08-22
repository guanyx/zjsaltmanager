<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmPmsIngredients.aspx.cs" Inherits="PMS_frmPmsIngredients" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html>
<head>
<title>生产配料维护</title><meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<link rel="stylesheet" type="text/css" href="../ext3/resources/css/ext-all.css" />
<script type="text/javascript" src="../ext3/adapter/ext/ext-base.js"></script>
<script type="text/javascript" src="../ext3/ext-all.js"></script>
</head>
<body>
<div id='toolbar'></div>
<div id='searchForm'></div>
<div id='dataGrid'></div>
<div id='dtlGrid'></div>

</body>
<script type="text/javascript">
Ext.onReady(function(){
/*------实现toolbar的函数 start---------------*/
var saveType;
var Toolbar = new Ext.Toolbar({
	renderTo:"toolbar",
	items:[{
		text:"新增",
		icon:"../Theme/1/images/extjs/customer/add16.gif",
		handler:function(){
		    openAddIngredientsWin();
		}
		},'-',{
		text:"编辑",
		icon:"../Theme/1/images/extjs/customer/edit16.gif",
		handler:function(){
		    modifyIngredientsWin();
		}
		},'-',{
		text:"删除",
		icon:"../Theme/1/images/extjs/customer/delete16.gif",
		handler:function(){
		    deleteIngredients();
		}
	}]
});

/*------结束toolbar的函数 end---------------*/


/*------开始ToolBar事件函数 start---------------*//*-----新增Ingredients实体类窗体函数----*/
function openAddIngredientsWin() {
	uploadIngredientsWindow.show();
	document.getElementById("editIntgriIFrame").src = "frmPmsIngredientsEdit.aspx?id=0";
}
/*-----编辑Ingredients实体类窗体函数----*/
function modifyIngredientsWin() {
	var sm = IngredientsGrid.getSelectionModel();
	//获取选择的数据信息
	var selectData =  sm.getSelected();
	if(selectData == null){
		Ext.Msg.alert("提示","请选中需要编辑的信息！");
		return;
	}
	uploadIngredientsWindow.show();
	document.getElementById("editIntgriIFrame").src = "frmPmsIngredientsEdit.aspx?id=" + selectData.data.Id+"&ProductId="+selectData.data.ProductId;
}
/*-----删除Ingredients实体函数----*/
/*删除信息*/
function deleteIngredients()
{
	var sm = IngredientsGrid.getSelectionModel();
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
				url:'frmAdmRoleList.aspx?method=deleteIngredients',
				method:'POST',
				params:{
					Id:selectData.data.Id
				},
				success: function(resp,opts){
					Ext.Msg.alert("提示","数据删除成功");
				},
				failure: function(resp,opts){
					Ext.Msg.alert("提示","数据删除失败");
				}
			});
		}
	});
}

/*------开始界面数据的窗体 Start---------------*/
if(typeof(uploadIngredientsWindow)=="undefined"){//解决创建2个windows问题
	uploadIngredientsWindow = new Ext.Window({
		id:'Ingredientsformwindow',
		title:''
		, iconCls: 'upload-win'
		, width: 600
		, height: 400
		, plain: true
		, modal: true
		, constrain:true
		, resizable: false
		, closeAction: 'hide'
		, autoDestroy :true
		, html: '<iframe id="editIntgriIFrame" width="100%" height="100%" border=0 src="frmPmsIngredientsEdit.aspx"></iframe>' 
    });
}
uploadIngredientsWindow.addListener("hide",function(){
});

/*------开始查询form end---------------*/
var produceIntPanel = new Ext.form.TextField({
    style: 'margin-left:0px',
    cls: 'key',
    xtype: 'textfield',
    fieldLabel: '成品名称',
    name: 'nameCust',
    anchor: '95%'
});

var serchform = new Ext.FormPanel({
    renderTo: 'searchForm',
    labelAlign: 'left',
    layout:'fit',
    buttonAlign: 'right',
    bodyStyle: 'padding:5px',
    frame: true,
    labelWidth: 80,
    items: [{
        layout: 'column',   //定义该元素为布局为列布局方式
        border: false,
        items: [{
            name: 'cusStyle',
            columnWidth: .36,
            layout: 'form',
            border: false,
            labelWidth: 55,
            items: [
                produceIntPanel
            ]
        }, {
            columnWidth: .08,
            layout: 'form',
            border: false,
            items: [{ cls: 'key',
                xtype: 'button',
                text: '查询',
                anchor: '50%',
                handler :function(){
                
                var wsinfo=produceIntPanel.getValue();
                
                dsIngredients.baseParams.ProductName=wsinfo;                
                dsIngredients.load({
                        params : {
                        start : 0,
                        limit : 10
                        } });                               
                
                }
            }]
        }]
    }]
});
/*------开始查询form end---------------*/
/*------开始获取数据的函数 start---------------*/
var dsIngredients = new Ext.data.Store
({
url: 'frmPmsIngredients.aspx?method=getingredientslist',
reader:new Ext.data.JsonReader({
	totalProperty:'totalProperty',
	root:'root'
},[
	{		name:'Id'	},
	{		name:'ProductId'	},
	{		name:'Rate'	},
	{		name:'ParentId'	},
	{       name:'ProductName'},
	{       name:'SpecificationsText'},
	{       name:'UnitText'},
	{		name:'Status'	},
	{		name:'OrgId'	},
	{		name:'OperId'	},
	{		name:'OwnerId'	},
	{		name:'CreateDate'	},
	{		name:'UpdateDate'
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
var IngredientsGrid = new Ext.grid.GridPanel({
	el: 'dataGrid',
	width:'100%',
	height:180,
	autoWidth:true,
	//autoHeight:true,
	autoScroll:true,
	layout: 'fit',
	title: '成品信息',
	store: dsIngredients,
	loadMask: {msg:'正在加载数据，请稍侯……'},
	sm:sm,
	cm: new Ext.grid.ColumnModel([
		sm,
		new Ext.grid.RowNumberer(),//自动行号
		{
			header:'流水',
			dataIndex:'Id',
			id:'Id',
			hidden:true,
			hideable:false
		},
		{
			header:'成品id',
			dataIndex:'ProductId',
			id:'ProductId',
			hidden:true,
			hideable:false
		},
		{
			header:'成品',
			dataIndex:'ProductName',
			id:'ProductName'
		},
		{
			header:'规格',
			dataIndex:'SpecificationsText',
			id:'SpecificationsText'
		},
		{
			header:'单位',
			dataIndex:'UnitText',
			id:'UnitText'
		},
		{
			header:'创建时间',
			dataIndex:'CreateDate',
			id:'CreateDate'
		}
		]),
		bbar: new Ext.PagingToolbar({
			pageSize: 10,
			store: dsIngredients,
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
		closeAction: 'hide',
		stripeRows: true,
		loadMask: true,
		autoExpandColumn: 2
	});
IngredientsGrid.render();
/*------DataGrid的函数结束 End---------------*/
/*dblclick*/
IngredientsGrid.on({ 
    rowdblclick:function(grid, rowIndex, e) {
        var rec = grid.store.getAt(rowIndex);
        //alert(rec.get("SendId"));
        dsdtlIngredients.baseParams.ParentId = rec.get("ProductId");
        dsdtlIngredients.load({params:{start:0,limit:10}});
    }
});
/***********dtl**********************/
var dsdtlIngredients = new Ext.data.Store
({
url: 'frmPmsIngredients.aspx?method=getingredientsdtllist',
reader:new Ext.data.JsonReader({
	totalProperty:'totalProperty',
	root:'root'
},[
	{		name:'Id'	},
	{		name:'ProductId'	},
	{		name:'Rate'	},
	{		name:'ParentId'	},
	{       name:'ProductName'},
	{       name:'SpecificationsText'},
	{       name:'UnitText'},
	{		name:'Status'	},
	{		name:'OrgId'	},
	{		name:'OperId'	},
	{		name:'OwnerId'	},
	{		name:'CreateDate'	},
	{		name:'UpdateDate'
	}	])
	,
	listeners:
	{
		scope:this,
		load:function(){
		}
	}
});
/*------开始DataGrid的函数 start---------------*/

var smdtl= new Ext.grid.CheckboxSelectionModel({
	singleSelect:true
});
var IngredientsDtlGrid = new Ext.grid.GridPanel({
	el: 'dtlGrid',
	width:'100%',
	height:220,
	autoWidth:true,
	//autoHeight:true,
	autoScroll:true,
	layout: 'fit',
	title: '配料信息',
	store: dsdtlIngredients,
	loadMask: {msg:'正在加载数据，请稍侯……'},
	sm:smdtl,
	cm: new Ext.grid.ColumnModel([
		smdtl,
		new Ext.grid.RowNumberer(),//自动行号
		{
			header:'流水',
			dataIndex:'Id',
			id:'Id',
			hidden:true,
			hideable:false
		},
		{
			header:'成品id',
			dataIndex:'ProductId',
			id:'ProductId',
			hidden:true,
			hideable:false
		},
		{
			header:'配料',
			dataIndex:'ProductName',
			id:'ProductName'
		},
		{
			header:'规格',
			dataIndex:'SpecificationsText',
			id:'SpecificationsText'
		},
		{
			header:'单位',
			dataIndex:'UnitText',
			id:'UnitText'
		},
		{
			header:'比率(%)',
			dataIndex:'Rate',
			id:'Rate'
		},
		{
			header:'创建时间',
			dataIndex:'CreateDate',
			id:'CreateDate'
		}
		]),
		bbar: new Ext.PagingToolbar({
			pageSize: 10,
			store: dsdtlIngredients,
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
		closeAction: 'hide',
		stripeRows: true,
		loadMask: true,
		autoExpandColumn: 2
	});
IngredientsDtlGrid.render();
/*------DataGrid的函数结束 End---------------*/


})
</script>
</html>

