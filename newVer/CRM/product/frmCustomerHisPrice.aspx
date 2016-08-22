<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmCustomerHisPrice.aspx.cs" Inherits="CRM_product_frmCustomerHisPrice" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>客户定价历史查询</title>
    <meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
    <link rel="stylesheet" type="text/css" href="../../ext3/resources/css/ext-all.css" />
    <script type="text/javascript" src="../../ext3/adapter/ext/ext-base.js"></script>
    <script type="text/javascript" src="../../ext3/ext-all.js"></script>
    <script type="text/javascript" src="../../js/operateResp.js"></script>
</head>
<body>
    <div id ='searchForm'></div>
    <div id='crPriceGrid'></div>
</body>
<script type="text/javascript">
Ext.BLANK_IMAGE_URL = "../../ext3/resources/images/default/s.gif";	
Ext.onReady(function(){
    /*------开始获取数据的函数 start---------------*/
    var crmCustomreFixPricegridData = new Ext.data.Store
    ({
        url: 'frmCustomerHisPrice.aspx?method=getFixpiceHisList',
        reader: new Ext.data.JsonReader({
            totalProperty: 'totalProperty',
            root: 'root'
        }, [
	    { name: 'SpecialPricingId' },
	    { name: 'CustomerId' },
	    { name: "CustomerName" },
	    { name: 'ProductId' },
	    { name: 'ProductName' },
	    { name: 'SpecificationsText' },
	    { name: 'SalePriceLimit' },
	    { name: 'SalePriceLower' },
	    { name: 'SalePrice' },
	    { name: 'TaxWhPrice' },
	    { name: 'TaxRate' },
	    { name: 'Tax' },
	    { name: 'SalesTax' },
	    { name: 'AutoFreight' },
	    { name: 'DriverFreight' },
	    { name: 'TrainFreight' },
	    { name: 'ShipFreight' },
	    { name: 'OtherFeight' },
	    { name: 'ValidDate' },
	    { name: 'ExpireDate' },
	    { name: 'Remark' }
	    ]),
        listeners:
	    {
	        scope: this,
	        load: function() {
	        }
	    }
    });
    /*------获取数据的函数 结束 End---------------*/
    /*------开始查询form的函数 start---------------*/
    var customerNamePanel = new Ext.form.TextField({
        style: 'margin-left:0px',
        cls: 'key',
        xtype: 'textfield',
        fieldLabel: '客户名称',
        id: 'sCustoemrSearch',
        name: 'sCustoemrSearch',
        anchor: '70%',
        listeners: { specialkey: function(f, e) { if (e.getKey() == e.ENTER) { Ext.getCmp('sProductrSearch').focus(); } } }
    });
    
    var productNamePanel = new Ext.form.TextField({
        style: 'margin-left:0px',
        cls: 'key',
        xtype: 'textfield',
        fieldLabel: '产品名称',
        id: 'sProductrSearch',
        name: 'sProductrSearch',
        anchor: '70%',
        listeners: { specialkey: function(f, e) { if (e.getKey() == e.ENTER) { Ext.getCmp('searchebtnId').focus(); } } }
    });

    var searchform = new Ext.FormPanel({
        renderTo: 'searchForm',
        labelAlign: 'left',
        layout: 'fit',
        buttonAlign: 'right',
        bodyStyle: 'padding:5px',
        height: 50,
        frame: true,
        labelWidth: 55,
        items: [{
            layout: 'column',   //定义该元素为布局为列布局方式
            border: false,
            items: [{
                columnWidth: .4,
                layout: 'form',
                border: false,
                items: [
                    customerNamePanel
                    ]
            },{
                columnWidth: .4,
                layout: 'form',
                border: false,
                items: [
                    productNamePanel
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
                        var customerName = customerNamePanel.getValue();
                        var productName = productNamePanel.getValue();

                        crmCustomreFixPricegridData.baseParams.CustomerName = customerName;
                        crmCustomreFixPricegridData.baseParams.ProductName = productName;
                        crmCustomreFixPricegrid.getStore().load({
                            params: {
                                start: 0,
                                limit: 10
                            }
                        });
                    }
                }, {
                    columnWidth: .4,  //该列占用的宽度，标识为20％
                    layout: 'form',
                    border: false,
                    html: '&nbsp'
                }]
            }]
        }]
    });


    /*------开始查询form的函数 end---------------*/

    /*------开始DataGrid的函数 start---------------*/

    var sm = new Ext.grid.CheckboxSelectionModel({
        singleSelect: true
    });
    var crmCustomreFixPricegrid = new Ext.grid.GridPanel({
        el: 'crPriceGrid',
        width: '100%',
        height: '100%',
        autoWidth: true,
        autoHeight: true,
        autoScroll: true,
        layout: 'fit',
        id: '',
        store: crmCustomreFixPricegridData,
        loadMask: { msg: '正在加载数据，请稍侯……' },
        sm: sm,
        cm: new Ext.grid.ColumnModel([
		sm,
		new Ext.grid.RowNumberer(), //自动行号
		{
	        header: '客户商品特殊定价ID',
	        dataIndex: 'SpecialPricingId',
	        id: 'SpecialPricingId',
	        hidden: true,
	        hideable: false
        },
		{
		    header: '客户Id',
		    dataIndex: 'CustomerId',
		    id: 'CustomerId',
		    hidden: true,
		    hideable: false
		},
		{
		    header: '商品ID',
		    dataIndex: 'ProductId',
		    id: 'ProductId',
		    hidden: true,
		    hideable: false
		},
		{
		    header: '客户名称',
		    dataIndex: 'CustomerName',
		    id: 'CustomerName'
		},
		{
		    header: '商品名称',
		    dataIndex: 'ProductName',
		    id: 'ProductIdText'
		},
		{
		    header: '规格',
		    dataIndex: 'SpecificationsText',
		    id: 'ProductIdUnit',
		    width:80
		},
		{
		    header: '销售价上限',
		    dataIndex: 'SalePriceLimit',
		    id: 'SalePriceLimit',
		    width:110
		},
		{
		    header: '销售价下限',
		    dataIndex: 'SalePriceLower',
		    id: 'SalePriceLower',
		    width:110
		},
		{
		    header: '销售单价',
		    dataIndex: 'SalePrice',
		    id: 'SalePrice',
		    width:90
		},
		{
		    header: '税率',
		    dataIndex: 'TaxRate',
		    id: 'TaxRate',
		    width:90
        },
		{
		    header: '税金',
		    dataIndex: 'Tax',
		    id: 'Tax',
		    width:90
		},
		{
		    header: '销售税率',
		    dataIndex: 'SalesTax',
		    id: 'SalesTax',
		    width:90
		},
		{
		    header: '生效时间',
		    dataIndex: 'ValidDate',
		    id: 'ValidDate',
		    sortable:true,
		    renderer: Ext.util.Format.dateRenderer('Y年m月d日')
		},
		{
		    header: '失效时间',
		    dataIndex: 'ExpireDate',
		    id: 'ExpireDate',
		    sortable:true,
		    renderer: Ext.util.Format.dateRenderer('Y年m月d日')
		},
		{
		    header: '备注',
		    dataIndex: 'Remark',
		    id: 'Remark'
        }]),
        bbar: new Ext.PagingToolbar({
            pageSize: 10,
            store: crmCustomreFixPricegridData,
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
    crmCustomreFixPricegrid.render();
})
</script>

</html>
