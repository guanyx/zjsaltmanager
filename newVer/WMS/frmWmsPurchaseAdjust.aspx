<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmWmsPurchaseAdjust.aspx.cs" Inherits="WMS_frmWmsPurchaseAdjust" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html>
<head>
<title>采购调整单查询页面</title><meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<link rel="stylesheet" type="text/css" href="../ext3/resources/css/ext-all.css" />
<script type="text/javascript" src="../ext3/adapter/ext/ext-base.js"></script>
<script type="text/javascript" src="../ext3/ext-all.js"></script>
<script type="text/javascript" src="../ext3/src/locale/ext-lang-zh_CN.js"></script>
</head>
<body>
<div id='toolbar'></div>
<div id='divForm'></div>
<div id='seachFormDiv'></div>
<div id='userGridDiv'></div>


</body>
<%=getComboBoxStore() %>

<script type="text/javascript">
Ext.BLANK_IMAGE_URL = "../ext3/resources/images/default/s.gif";
Ext.onReady(function() {
        
function updateDataGrid() {
    var WhId = WhNamePanel.getValue();
    //var OrgId = OrgNamePanel.getValue();
    var ProductId = ProductNamePanel.getValue();
    var StartDate = Ext.util.Format.date(StartDatePanel.getValue(),'Y/m/d');
    var EndDate = Ext.util.Format.date(EndDatePanel.getValue(),'Y/m/d');
        
    userGridData.baseParams.WhId = WhId;
    //userGridData.baseParams.OrgId = OrgId;
    userGridData.baseParams.ProductId = ProductId;
    userGridData.baseParams.StartDate = StartDate;
    userGridData.baseParams.EndDate = EndDate;
    userGridData.load({
        params: {
            start: 0,
            limit: 10
        }
    });
}

/*------开始获取数据的函数 start---------------*/
var userGridData = new Ext.data.Store
({
    url: 'frmWmsPurchaseAdjust.aspx?method=getPurchaseAdjustList',
    reader: new Ext.data.JsonReader({
        totalProperty: 'totalProperty',
        root: 'root'
    }, [
	{	    name: 'AdjustId'	},
	{	    name: 'OrgId'	},
	{	    name: 'WhId'	},
	{	    name: 'ProductId'	},
	{	    name: 'ProductQty'	}, 
	{	    name: 'ProductCode'	}, 
	{	    name: 'ProductName'	}, 
	{	    name: 'ProductSpec'	}, 
	{	    name: 'ProductUnit'	}, 
    {	    name: 'ProductPrice'    },
    {	    name: 'AdjustAmount'	},
    {	    name: 'FromBillType'	},
    {	    name: 'FromBillId'	},
    {	    name: 'CreateDate'	},
    {	    name: 'OperId'	}
    ])	,
    listeners:
	{
	    scope: this,
	    load: function() {
	    }
	}
});
/*------搜索------Start-----------------------*/
var WhNamePanel = new Ext.form.ComboBox({
    fieldLabel: '仓库名称',
    name: 'warehouseCombo',
    store: dsWarehouseList,
    displayField: 'WhName',
    valueField: 'WhId',
    typeAhead: true, //自动将第一个搜索到的选项补全输入
    triggerAction: 'all',
    emptyText: '请选择仓库',
    selectOnFocus: true,
    forceSelection: true,
    anchor: '90%',
    mode: 'local',
    listeners: { specialkey: function(f, e) { if (e.getKey() == e.ENTER) { Ext.getCmp('ProductId').focus(); } } }
});
var ProductNamePanel = new Ext.form.ComboBox({
    fieldLabel: '商品名称',
    name: 'productCombo',
    store: dsProductList,
    displayField: 'ProductName',
    valueField: 'ProductId',
    typeAhead: true, //自动将第一个搜索到的选项补全输入
    triggerAction: 'all',
    emptyText: '请选择商品',
    //valueNotFoundText: 0,
    selectOnFocus: true,
    forceSelection: true,
    id: 'ProductId',
    anchor: '90%',
    mode: 'local',
    listeners: { specialkey: function(f, e) { if (e.getKey() == e.ENTER) { Ext.getCmp('StartDate').focus(); } } }

});

var StartDatePanel = new Ext.form.DateField({
        style: 'margin-left:0px',
        cls: 'key',
        xtype: 'datefield',
        fieldLabel: '开始时间',
        format: 'Y年m月d日',
        anchor: '90%',
        value: new Date().getFirstDateOfMonth().clearTime(),
        id: 'StartDate',
        listeners: { specialkey: function(f, e) { if (e.getKey() == e.ENTER) { Ext.getCmp('EndDate').focus(); } } }
    });
    var EndDatePanel = new Ext.form.DateField({
        style: 'margin-left:0px',
        cls: 'key',
        xtype: 'datefield',
        fieldLabel: '结束时间',
        anchor: '90%',
        format: 'Y年m月d日',
        id: 'EndDate',
        value: new Date().clearTime(),
        listeners: { specialkey: function(f, e) { if (e.getKey() == e.ENTER) { Ext.getCmp('searchebtnId').focus(); } } }
    });
var serchform = new Ext.FormPanel({
    renderTo: 'seachFormDiv',
    labelAlign: 'left',
    buttonAlign: 'right',
    bodyStyle: 'padding:5px',
    frame: true,
    labelWidth: 55,
    items: [
    {
        layout: 'column',   //定义该元素为布局为列布局方式
        border: false,
        items: [{
            columnWidth: .4,
            layout: 'form',
            border: false,
            items: [
                WhNamePanel
                ]
        }, {
            columnWidth: .4,
            layout: 'form',
            border: false,
            items: [
                ProductNamePanel
                ]
        }]
        },{
        layout: 'column',   //定义该元素为布局为列布局方式
        border: false,
        items: [{
            columnWidth: .4,
            layout: 'form',
            border: false,
            items: [
                StartDatePanel
                ]
        }, {
            columnWidth: .4,
            layout: 'form',
            border: false,
            items: [
                EndDatePanel
                ]
        }, {
            columnWidth: .2,
            layout: 'form',
            border: false,
            items: [{ cls: 'key',
                xtype: 'button',
                text: '查询',
                id: 'searchebtnId',
                anchor: '50%',
                handler: function() {
                    updateDataGrid();
                }
            }]
        }]
    }]
});
/*------搜索------END-------------------------*/

/*------获取数据的函数 结束 End---------------*/

/*------开始DataGrid的函数 start---------------*/
var userGrid = new Ext.grid.GridPanel({
    el: 'userGridDiv',
    width: '100%',
    height: '100%',
    autoWidth: true,
    autoHeight: true,
    autoScroll: true,
    layout: 'fit',
    id: 'aa',
    store: userGridData,
    loadMask: { msg: '正在加载数据，请稍侯……' },
    cm: new Ext.grid.ColumnModel([
	new Ext.grid.RowNumberer(), //自动行号
	{
        header: '仓库名称',
        dataIndex: 'WhId',
        id: 'WhId',
        width: 80,
        renderer: function(val, params, record) {
            if (dsWarehouseList.getCount() == 0) {
                dsWarehouseList.load();
            }
            dsWarehouseList.each(function(r) {
                if (val == r.data['WhId']) {
                    val = r.data['WhName'];
                    return;
                }
            });
            return val;
        }
        },
        {
            header: '编码',
            dataIndex: 'ProductCode',
            id: 'ProductCode',
            width:60
        },
        {
            header: '商品名称',
            dataIndex: 'ProductName',
            id: 'ProductName',
            width:200
        },
        {
            header: '规格',
            dataIndex: 'ProductSpec',
            id: 'ProductSpec',
            width:60
        },
        {
            header: '单位',
            dataIndex: 'ProductUnit',
            id: 'ProductUnit',
            width:40

        },
        {
            header: '调整价格',
            dataIndex: 'ProductPrice',
            id: 'ProductPrice',
            width:70
        },
        {
            header: '库存数量',
            dataIndex: 'ProductQty',
            id: 'ProductQty',
            width:70
        },
        {
            header: '调整金额',
            dataIndex: 'AdjustAmount',
            id: 'AdjustAmount',
            hide: true,
            width:80
        },
        {
            header: '创建日期',
            dataIndex: 'CreateDate',
            id: 'CreateDate',
            width:120
        }
        ]),
        bbar: new Ext.PagingToolbar({
            pageSize: 16,
            store: userGridData,
            displayMsg: '显示第{0}条到{1}条记录,共{2}条',
            emptyMsy: '没有记录',
            displayInfo: true
        }),
        viewConfig: {
            columnsText: '显示的列',
            scrollOffset: 20,
            sortAscText: '升序',
            sortDescText: '降序'//,
            //forceFit: true
        },
        height: 280,
        closeAction: 'hide',
        stripeRows: true,
        loadMask: true//,
        //autoExpandColumn: 2
    });
    userGrid.render();
    /*------DataGrid的函数结束 End---------------*/

    updateDataGrid();

})
</script>

</html>

