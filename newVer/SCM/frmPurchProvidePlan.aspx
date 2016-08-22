<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmPurchProvidePlan.aspx.cs" Inherits="SCM_frmPurchProvidePlan" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>无标题页</title>
    <link rel="stylesheet" type="text/css" href="../ext3/resources/css/ext-all.css" />
<link rel="stylesheet" href="../css/Ext.ux.grid.GridSummary.css"/>
<script type="text/javascript" src="../ext3/adapter/ext/ext-base.js"></script>
<script type="text/javascript" src="../ext3/ext-all.js"></script>
<script type="text/javascript" src="../ext3/example/ItemDeleter.js"></script>
<script type="text/javascript" src="../js/floatUtil.js"></script>
<link rel="stylesheet" type="text/css" href="../ext3/example/GroupSummary.css" />
<script type="text/javascript" src="../ext3/example/GroupSummary.js"></script>
<link rel="stylesheet" href="../css/Ext.ux.grid.GridSummary.css"/>
<script src='../js/Ext.ux.grid.GridSummary.js'></script>

<%=getComboBoxSource()%>
<script type="text/javascript">
Ext.onReady(function() {

 /*------实现toolbar的函数 start---------------*/
    var Toolbar = new Ext.Toolbar({
        renderTo: "toolbar"
        });

iniToolBar(Toolbar);
//添加ToolBar事件
function addToolBarEvent()
{
    for(var i=0;i<Toolbar.items.length;i++)
    {
        switch(Toolbar.items.items[i].text)
        {
            case"新增要货单":
                Toolbar.items.items[i].on("click",createProvideMessage);
                break;
            case"按供应商分组":
                Toolbar.items.items[i].on("click",groupLoadByCustomerName);
                break;
            case"按产品分组":
                Toolbar.items.items[i].on("click",groupLoadByProductName);
                break;            
        }
    }
}
addToolBarEvent();
 /*------toolbar事件 start---------------*/
function groupLoadByCustomerName()
{
    planDtlGridData.groupField="ChineseName";
    planDtlGridData.load();
}

function groupLoadByProductName()
{
    planDtlGridData.groupField="ProductName";
    planDtlGridData.load();
}

function createProvideMessage()
{
    alert('ok');
}

 /*------toolbar事件 end---------------*/
 
 var planDtlGridData = new Ext.data.GroupingStore
({
    url: 'frmPurchProvidePlan.aspx?method=getdtllist',
    reader: new Ext.data.JsonReader({
        totalProperty: 'totalProperty',
        root: 'root'
    }, [
	{
	    name: 'PlanDtlId'
	},
	{
	    name: 'PlanId'
	},
	{
	    name: 'ParentProductId'
	},
	{
	    name: 'PlanQty',type:'float'
	},
	{
	    name: 'ProductName'
	},
	{
	    name: 'UnitName'
	},
	{
	    name: 'ProductCode'
    },
	{
	    name: 'CustomerId'
    },
	{
	    name: 'ChineseName'
    },
	{
	    name: 'ProductId'
    },
	{
	    name: 'ProvideQty',type:'float'
    }])
	,
    groupField: 'ChineseName',
    sortInfo: {field: 'ProductId', direction: 'ASC'},
    listeners:
	{
	    scope: this,
	    load: function() {
	    }
	}
});
planDtlGridData.baseParams.PlanId=planId;
planDtlGridData.load();
var itemDeleter = new Extensive.grid.ItemDeleter();
        var sm = new Ext.grid.CheckboxSelectionModel({
            singleSelect: true
        });
//合计项
var summary = new Ext.ux.grid.GridSummary();
 var summary1 = new Ext.ux.grid.GroupSummary();
var planeGrid = new Ext.grid.EditorGridPanel({
                renderTo:"gridPlan",                
                id: 'planeGrid',
                region:'center',
                split:true,
                store: planDtlGridData ,
                loadMask: { msg: '正在加载数据，请稍侯……' },
                sm: sm,
                cm: new Ext.grid.ColumnModel([sm,
		       // new Ext.grid.RowNumberer(), //自动行号		
		        {
		            header: '商品名称',
		            dataIndex: 'ProductName',
		            id: 'ProductName',
		            //editor: productFilterCombo,
		            renderer: function(value, cellmeta, record, rowIndex, columnIndex, store) {

		                return "<font color='red'>" + record.data.ProductName + "</font>";
		            }
		        },{
		            header: '单位',
		            dataIndex: 'UntilId',
		            id: 'UntilId'
		        },
		        {
		            header: '商品编号',
		            dataIndex: 'ProductCode',
		            id: 'ProductCode'
		        },
                {
                    header: '计划数量',
                    dataIndex: 'PlanQty',
                    id: 'PlanQty'
                    //summaryType: 'sum',
//                    summaryRenderer: function(v, params, data){  
//                        return Number(v).toFixed(4)+'吨'; //保留2位  
//                    }  
                },
                {
                    header: '供应商',
                    dataIndex: 'ChineseName',
                    id: 'ChineseName'
                },
                {
                    header: '采购量',
                    dataIndex: 'ProvideQty',
                    id: 'ProvideQty',
                    summaryType: 'sum'
                }]),
                height:350,
                width:600,
                title:'采购要盐情况',
                plugins:[summary1,summary],
                view: new Ext.grid.GroupingView({
                    forceFit: true,
                    showGroupName: false,
                    enableNoGroups: false,
			        enableGroupingMenu: false,
                    hideGroupedColumn: true
                })
                
            });
            planeGrid.render();
})
</script>
</head>
<body>
    <form id="form1" runat="server">
    <div id="toolbar"></div>
    <div id="gridPlan">
    
    </div>
    </form>
</body>
</html>
