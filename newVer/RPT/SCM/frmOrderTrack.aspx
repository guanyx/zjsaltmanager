<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmOrderTrack.aspx.cs" Inherits="RPT_frmOrderTrack" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
    <title>订单跟踪</title>
    <link rel="stylesheet" type="text/css" href="../../ext3/resources/css/ext-all.css" />
    <script type="text/javascript" src="../../ext3/adapter/ext/ext-base.js"></script>
    <script type="text/javascript" src="../../ext3/ext-all.js"></script>
    <script type="text/javascript" src="../../ext3/example/ItemDeleter.js"></script>
    <link rel="stylesheet" type="text/css" href="../../css/GroupHeaderPlugin.css" />
    <script type="text/javascript" src="../../js/floatUtil.js"></script>
    <script type="text/javascript" src="../../js/GroupHeaderPlugin.js"></script>
    <link rel="stylesheet" href="../../css/Ext.ux.grid.GridSummary.css" />
    <script type="text/javascript" src="../../js/FilterControl.js"></script>
    <script type="text/javascript" src='../../js/Ext.ux.grid.GridSummary.js'></script>
</head>
<script type="text/javascript">
var colModel = new Ext.grid.ColumnModel({
	columns: [
		new Ext.grid.RowNumberer(),				
		{
		    header:'订单标识',
			dataIndex:'OrderId',
			id:'OrderId',
			hidden:true,
			hideable:true
		}
		,
		{
			header:'订单编号',
			dataIndex:'OrderNumber',   
			id:'OrderNumber',
			width:100
		}
		,
		{
			header:'客户',
			dataIndex:'CustomerName',   
			id:'CustomerName',
			width:120
		}
		,
		{
			header:'仓库',
			dataIndex:'OutStorName',
			id:'OutStorName',
			width:60
		}
//		,			
//		{
//			header:'创建时间',
//			dataIndex:'CreateDate',
//			id:'CreateDate',
//			tooltip:'创建时间'
//		}
		,
		{
		    header:'送货日期',
			dataIndex:'DlvDate',
			type:'date',
			id:'DlvDate',
			renderer:function(v){
			    return Ext.util.Format.date(v,'Y/m/d');
			},
			width:95
		}
//		,
//		{
//		    header:'送货地点',
//			dataIndex:'DlvAdd',
//			id:'DlvAdd',
//			width:60
//		}
		,
		{
		    header:'订单类型',
			dataIndex:'OrderTypeName',
			id:'OrderTypeName',
			width:60
		}
		,
		{
		    header:'支付方式',
			dataIndex:'PayTypeName',
			id:'PayTypeName',
			width:60
		}
		
		,
		{
		    header:'开票方式',
			dataIndex:'BillModeName',
			id:'BillModeName',
			width:60
		}
		,
		{
		    header:'配送方式',
			dataIndex:'DlvTypeName',
			id:'DlvTypeName',
			width:60
		}
//		,
//		{
//		    header:'送货等级',
//			dataIndex:'DlvLevelName',
//			id:'DlvLevelName',
//			width:60
//		}
		,
		{
		    header:'当前状态',
			dataIndex:'StatusName',
			id:'StatusName',
			width:65
		}
		,
		{
		    header:'结款情况',
			dataIndex:'IsPayedName',
			id:'IsPayedName',
			width:60
		}
		,
		{
		    header:'开票情况',
			dataIndex:'IsBillName',
			id:'IsBillName',
			width:60
		}
		,
		{
		    header:'总数量',
			dataIndex:'SaleTotalQty',
			id:'SaleTotalQty',
			width:60
		}
		,
		{
		    header:'已出库数量',
			dataIndex:'OutedQty',
			id:'OutedQty',
			width:60
		}
		,
		{
		    header:'总金额',
			dataIndex:'SaleTotalAmt',
			id:'SaleTotalAmt',
			width:60
		}
		,
		{
		    header:'总税额',
			dataIndex:'SaleTotalTax',
			id:'SaleTotalTax',
			width:60
		}
		,
		{
		    header:'商品个数',
			dataIndex:'DtlCount',
			id:'DtlCount',
			width:60
		}
        ]
});
var gridStore = new Ext.data.Store({
    url: 'frmOrderTrack.aspx?method=getlist',
     reader :new Ext.data.JsonReader({
    totalProperty: 'totalProperty',
    root: 'root',
    fields: [
    {
        name:'OrderId'},
    {
		name:'OutStorName'
	},
	{
		name:'CustomerName'
	},
	{
		name:'DlvAdd'
	}
//	,
//	{
//		name:'CreateDate'
//	}
	,
	{
	    name:'DlvDate',
	    type:'date'
	}
	,
	{
	    name:'DlvAdd'
	}
	,
	{
	    name:'OrderTypeName'
	}
	,
	{
		name:'PayTypeName'
	}
	
	,
	{
		name:'BillModeName'
	}
	,
	{
		name:'DlvTypeName'
	}
	,
	{
		name:'DlvLevelName'
	}
	,
	{
	    name:'StatusName'
	}
	,
	{
		name:'IsPayedName'
	}
	,
	{
		name:'IsBillName'
	}
	,
	{
		name:'SaleTotalQty'
	}
	,
	{
		name:'OutedQty'
	}
	,
	{
		name:'SaleTotalAmt'
	}
	,
	{
		name:'SaleTotalTax'
	}
	,
	{
		name:'DtlCount'
	},
	{
		name:'OrderNumber'
	}
	]})
});

var headerModel = new Ext.ux.plugins.GroupHeaderGrid({
	rows: [
]});

var reportView='v_scm_orderstatusinfoquery';
</script>
<script type="text/javascript">

 function getCmbStore(columnName)
{
    return null;
}
    
Ext.onReady(function(){
var sm = new Ext.grid.CheckboxSelectionModel({
            singleSelect: true
});
        
//合计项
var viewGrid = new Ext.grid.EditorGridPanel({
    renderTo:"gird",                
    id: 'viewGrid',
    //region:'center',
    split:true,
    store: gridStore ,
    autoscroll:true,
    clicksToEdit:1,
    loadMask: { msg: '正在加载数据，请稍侯……' },
    sm: sm,
    cm:colModel,  
    bbar: new Ext.PagingToolbar({
			pageSize: 18,
			store: gridStore,
			displayMsg: '显示第{0}条到{1}条记录,共{2}条',
			emptyMsy: '没有记录',
			displayInfo: true
		}),              
    viewConfig: {
        columnsText: '显示的列',
        scrollOffset: 20,
        sortAscText: '升序',
        sortDescText: '降序',
        forceFit: false
    },
    stripeRows: true,
    height:495,
    width:document.body.offsetWidth-5,
    title:'',
    plugins:[headerModel]
    
});
defaultPageSize = 18;
gridStore.baseParams.ReportView=reportView;
createSearch(viewGrid,gridStore,"searchForm");
//setControlVisibleByField();
searchForm.el="searchForm";
searchForm.render();

viewGrid.on('rowdblclick', function(grid, rowIndex, e) {
    //弹出
    var orderId = viewGrid.getStore().getAt(rowIndex).data.OrderId;
    if (!orderId) {
        Ext.example.msg('操作', '请选择要查看的记录！');
    } else {
        OpenStatusWin(orderId);
    }

});
/****************************************************************/
function OpenStatusWin(orderId) {
    if (typeof (newFormWin) == "undefined") {
        newFormWin = new Ext.Window({
            layout: 'fit',
            width: 600,
            height: 300,
            closeAction: 'hide',
            plain: true,
            constrain: true,
            modal: true,
            autoDestroy: true,
            title: '状态信息',
            items: orderDtInfoGrid
        });
        newFormWin.addListener("hide", function() {
               orderDtInfoStore.removeAll();               
            });
    }
    newFormWin.show();
    //查数据
    orderDtInfoStore.baseParams.OrderId = orderId;
    orderDtInfoStore.load({
        params: {
        limit: 10,
        start: 0
        }
    });
}

var orderDtInfoStore = new Ext.data.Store
({
    url: 'frmOrderTrack.aspx?method=getStatusInfo',
    reader: new Ext.data.JsonReader({
    totalProperty: 'totalProperty',
    root: 'root'
    }, [
        { name: 'Status' },
        { name: 'Opdate' },
        { name: 'Opname' },
        { name: 'Content' }
    ])
});

var smDtl = new Ext.grid.CheckboxSelectionModel({
    singleSelect: true
});
var orderDtInfoGrid = new Ext.grid.GridPanel({
    //width: '100%',
    //height: '100%',
    autoWidth: true,
    autoHeight: true,
    autoScroll: true,
    layout: 'fit',
    id: '',
    store: orderDtInfoStore,
    loadMask: { msg: '正在加载数据，请稍侯……' },
    sm: smDtl,
    cm: new Ext.grid.ColumnModel([
        smDtl,
        new Ext.grid.RowNumberer(), //自动行号
        {
            header: '日期',
            dataIndex: 'Opdate',
            id: 'Opdate',
            renderer: Ext.util.Format.dateRenderer('Y年m月d日H时i分s秒'),
            width: 180
        },
        {
            header: '操作员',
            dataIndex: 'Opname',
            id: 'Opname',
            width: 60
        },
        {
            header: '状态',
            dataIndex: 'Status',
            id: 'Status',
            width: 90
        },
        {
            header: '备注',
            dataIndex: 'Content',
            id: 'Content',
            width: 200
        }
    ]),
    viewConfig: {
        columnsText: '显示的列',
        scrollOffset: 20,
        sortAscText: '升序',
        sortDescText: '降序',
        forceFit: false
    },
    //height: 280,
    closeAction: 'hide',
    stripeRows: true,
    loadMask: true//,
    //autoExpandColumn: 2
});

})
</script>
<body>    
<div>
<input type="hidden" name="__VIEWSTATE" id="__VIEWSTATE" value="/wEPDwULLTE5MjEyMTQyMzZkZIBFRIV0usSugne+1AQWcQKzta8t" />
</div>
<div id='searchForm'></div>
<div id='gird'></div>
</body>
</html>
