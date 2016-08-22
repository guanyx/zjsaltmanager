<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmAdmGraphStaticSetting.aspx.cs" Inherits="BA_sysadmin_frmAdmGraphStaticSetting" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>无标题页</title>
        <link rel="stylesheet" type="text/css" href="../../ext3/resources/css/ext-all.css" />
<script type="text/javascript" src="../../ext3/adapter/ext/ext-base.js"></script>
<script type="text/javascript" src="../../ext3/ext-all.js"></script>
<script type="text/javascript" src="../../ext3/example/ItemDeleter.js"></script>
<style type="text/css">
.extensive-remove {
background-image: url(../../Theme/1/images/extjs/customer/cross.gif) ! important;
}
</style>
</head>
<%=getComboBoxSource() %>
<script>
Ext.onReady(function(){
/*------实现toolbar的函数 start---------------*/
var Toolbar = new Ext.Toolbar({
	renderTo:"toolbar",
	items:[{
		text:"保存",
		icon:"images/extjs/customer/save16.gif",
		handler:function(){
		        saveGraph();
		    }
		}]
});

function saveGraph()
{
    var graphs='';
    graphGridData.each(function(store) {
        if(store.data.GraphName!='' && store.data.GraphNamecolumn!='' && store.data.GraphValuecolumn!='')
        {
            graphs += Ext.util.JSON.encode(store.data) + ',';
        }
     });
    graphs = graphs.substring(0, graphs.length - 1);
    Ext.Msg.wait("正在保存，请稍后……","系统提示");
    Ext.Ajax.request({
		url:'frmAdmGraphStaticSetting.aspx?method=save',
		method:'POST',
		params:{
			schemeId:schemeId,
			graphs:graphs
			},
		success: function(resp,opts){
		    Ext.Msg.hide();
			Ext.Msg.alert("提示","保存成功");
		},
		failure: function(resp,opts){
		    Ext.Msg.hide();
			Ext.Msg.alert("提示","保存失败");
		}
		});
}
    /*------开始获取数据的函数 start---------------*/
var graphGridData = new Ext.data.Store
({
url: 'frmAdmGraphStaticSetting.aspx?method=getgraphlist',
reader:new Ext.data.JsonReader({
	totalProperty:'totalProperty',
	root:'root'
},[
	{name:'GraphId'},
	{name:'GraphType'},
	{name:'GraphNamecolumn'},
	{name:'GraphValuecolumn'},
	{name:'GraphViewname'},
	{name:'SchemeId'},
	{name:'GraphName'}])
	,
	listeners:
	{
		scope:this,
		load:function(store){
		    if(store.data.length==0)
		    {
		        insertNewBlankRow();
		    }
		}
	}
});
graphGridData.baseParams.SchemeId=schemeId;
graphGridData.load({Params:{limit:10,start:0}});
var headPattern = Ext.data.Record.create([
    {name:'GraphId'},
	{name:'GraphType'},
	{name:'GraphNamecolumn'},
	{name:'GraphValuecolumn'},
	{name:'GraphViewname'},
	{name:'SchemeId'},
	{name:'GraphName'}
   ]);
   
function insertNewBlankRow() {
    var rowCount = graphGrid.getStore().getCount();
    var insertPos = parseInt(rowCount);
    var addRow = new headPattern({
        GraphId:-rowCount,
        GraphNamecolumn: '',
        GraphValuecolumn: '',
        GraphViewname: '',
        SchemeId:schemeId,
        GraphName:''
    });
    graphGrid.stopEditing();
    if (insertPos > 0) {
        var rowIndex = graphGrid.getStore().insert(insertPos, addRow);
        graphGrid.startEditing(insertPos, 0);
    }
    else {
        var rowIndex = graphGrid.getStore().insert(0, addRow);
        // planDtlGrid.startEditing(0, 0);
    }
}

function addNewBlankRow() {
    var rowIndex = graphGrid.getStore().indexOf(graphGrid.getSelectionModel().getSelected());
    var rowCount = graphGrid.getStore().getCount();
    if ((rowIndex == 0 && rowCount == 1) || rowIndex == rowCount - 1) {
        insertNewBlankRow();
    }
}
/*------获取数据的函数 结束 End---------------*/

/*------开始DataGrid的函数 start---------------*/

var sm= new Ext.grid.CheckboxSelectionModel({
	singleSelect:true
});

var itemDeleter = new Extensive.grid.ItemDeleter();

var graphGrid = new Ext.grid.EditorGridPanel({
	el: 'graphGrid',
	width:'100%',
	height:'100%',
	autoWidth:true,
	autoHeight:true,
	autoScroll:true,
	layout: 'fit',
	id: 'graphGrid',
	store: graphGridData,
	loadMask: {msg:'正在加载数据，请稍侯……'},
	selModel:itemDeleter,
	cm: new Ext.grid.ColumnModel([
		sm,new Ext.grid.RowNumberer(),//自动行号
		itemDeleter,
		{
			header:'统计名称',
			dataIndex:'GraphName',
			id:'GraphName',
			editor:new Ext.form.TextField({
			    listeners:{'change':function(){
                    addNewBlankRow();
                }}
			})
		},		
		{
			header:'图表类型',
			dataIndex:'GraphType',
			id:'GraphType',
			editor:new Ext.form.TextField({})
		},
		{
			header:'名称列',
			dataIndex:'GraphNamecolumn',
			id:'GraphNamecolumn',
			editor:new Ext.form.TextField({})
		},
		{
			header:'值列',
			dataIndex:'GraphValuecolumn',
			id:'GraphValuecolumn',
			editor:new Ext.form.TextField({})
		},
		{
			header:'统计视图',
			dataIndex:'GraphViewname',
			id:'GraphViewname',
			editor:new Ext.form.TextField({})
		}]),
		bbar: new Ext.PagingToolbar({
			pageSize: 10,
			store: graphGridData,
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
graphGrid.render();
/*------DataGrid的函数结束 End---------------*/
})
</script>
<body>
    <form id="form1" runat="server">
    <div id='toolbar'></div>
<div id='graphGrid'></div>
    </form>
</body>
</html>
