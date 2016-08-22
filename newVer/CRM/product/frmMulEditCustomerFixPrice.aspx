<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmMulEditCustomerFixPrice.aspx.cs" Inherits="CRM_product_frmMulEditCustomerFixPrice" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>内部客户特殊定价--批量新增</title>
    <meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
    <link rel="stylesheet" type="text/css" href="../../ext3/resources/css/ext-all.css" />
    <link rel="Stylesheet" type="text/css" href="../../css/columnLock.css" />
    <script type="text/javascript" src="../../ext3/adapter/ext/ext-base.js"></script>
    <script type="text/javascript" src="../../ext3/ext-all.js"></script>
    <script type="text/javascript" src="../../js/operateResp.js"></script>
    <script type="text/javascript" src="../../js/columnLock.js"></script>
</head>
<script>
    Ext.onReady(function() {
        var saveType;
        //定义客户下拉框异步调用方法            
        var dsCustomers;
        if (dsCustomers == null) {
            dsCustomers = new Ext.data.Store({
                url: 'frmInnerCustomerFixPrice.aspx?method=getCustomers',
                reader: new Ext.data.JsonReader({
                    root: 'root',
                    totalProperty: 'totalProperty'
                }, [
                    { name: 'CustomerId', mapping: 'CustomerId' },
                    { name: 'CustomerNo', mapping: 'CustomerNo' },
                    { name: 'ChineseName', mapping: 'ChineseName' },
                    { name: 'Address', mapping: 'Address' }
                ])
            });
        }
        // 定义客户下拉框异步返回显示模板
        var resultTpl = new Ext.XTemplate(
            '<tpl for="."><div id="searchkhdivid" class="search-item">',
                '<h3><span>客户编号：{CustomerNo}  客户全称： {ChineseName}</span>  客户地址：{Address}</h3>',
        //'<br>创建时间：{createDate}',  
            '</div></tpl>'
        );

        /*------开始获取数据的函数 start---------------*/
        var crmCustomreFixPricegridData = new Ext.data.Store
({
    url: 'frmInnerCustomerFixPrice.aspx?method=getFixpiceList',
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
	{ name: 'Remark' },
	{ name: 'CreateDate' },
	{ name: 'UpdateDate' },
	{ name: 'OperId' },
	{ name: 'OrgId'}])
	,
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
            listeners: { specialkey: function(f, e) { if (e.getKey() == e.ENTER) { Ext.getCmp('searchebtnId').focus(); } } }
        });

        var sm = new Ext.grid.CheckboxSelectionModel({
            singleSelect: true
        });
        sm.width = 20;

        var rowNum = new Ext.grid.RowNumberer();
        rowNum.locked = true;
        rowNum.width = 20;

        var crmCustomreFixPricegrid = new Ext.grid.EditorGridPanel({
            el: 'crmCustomreFixPriceGrid',
            width: 900,
            height: '100%',

            //region: "center",
            //layout: 'fit',
            stripeRows: true,
            id: 'crmCustomreFixPricegrid',
            store: crmCustomreFixPricegridData,
            sm: sm,
            columns: [
		sm,
		rowNum, //自动行号		
		{
		    header: '客户名称',
		    dataIndex: 'CustomerName',
		    id: 'CustomerName',
		    width: 150,
		    locked: true
		},
		{
		    header: '商品名称',
		    dataIndex: 'ProductName',
		    id: 'ProductIdText',
		    width: 150,
		    locked: true
		},
		{
		    header: '规格',
		    dataIndex: 'SpecificationsText',
		    width: 150,
		    id: 'ProductIdUnit'
		},
		{
		    header: '销售价上限',
		    dataIndex: 'SalePriceLimit',
		    id: 'SalePriceLimit',
		    width: 80,
		    editor: new Ext.form.NumberField
		},
		{
		    header: '销售价下限',
		    dataIndex: 'SalePriceLower',
		    id: 'SalePriceLower',
		    width: 80,
		    editor: new Ext.form.NumberField
		},
		{
		    header: '销售单价',
		    dataIndex: 'SalePrice',
		    id: 'SalePrice',
		    width: 80,
		    editor: new Ext.form.NumberField
		},
		{
		    header: '含税入库价',
		    dataIndex: 'TaxWhPrice',
		    id: 'TaxWhPrice',
		    width: 80,
		    editor: new Ext.form.NumberField
		},
		{
		    header: '税率',
		    dataIndex: 'TaxRate',
		    id: 'TaxRate',
		    width: 80,
		    editor: new Ext.form.NumberField
		},
		{
		    header: '税金',
		    dataIndex: 'Tax',
		    id: 'Tax',
		    width: 80,
		    editor: new Ext.form.NumberField
		},
		{
		    header: '销售税率',
		    dataIndex: 'SalesTax',
		    id: 'SalesTax',
		    width: 80,
		    editor: new Ext.form.NumberField
		},
		{
		    header: '备注',
		    dataIndex: 'Remark',
		    id: 'Remark',
		    width: 120,
		    editor: new Ext.form.TextArea
}],
            bbar: new Ext.PagingToolbar({
                pageSize: 100,
                store: crmCustomreFixPricegridData,
                displayMsg: '显示第{0}条到{1}条记录,共{2}条',
                emptyMsy: '没有记录',
                displayInfo: true
            }),
            viewConfig: {
                columnsText: '显示的列',
                scrollOffset: 20,
                sortAscText: '升序',
                sortDescText: '降序'
            },
            height: 280,
            
            tbar: [{
                id: 'btnSave',
                text: '获取供应商商品',
                iconCls: 'add',
                handler: function() {
                    selectProductWindow.show();
                }
}]
            });
            crmCustomreFixPricegrid.render();


            /*------开始获取数据的函数 start---------------*/
            var productGridData = new Ext.data.Store
({
    url: '../../scm/frmScmProvideMessage.aspx?method=getProductInfoList',
    reader: new Ext.data.JsonReader({
        totalProperty: 'totalProperty',
        root: 'root'
    }, [
	{
	    name: 'ProductId'
	},
	{
	    name: 'ProductNo'
	},
	{
	    name: 'MnemonicNo'
	},
	{
	    name: 'AliasNo'
	},
	{
	    name: 'MobileNo'
	},
	{
	    name: 'SpeechNo'
	},
	{
	    name: 'NetPurchasesNo'
	},
	{
	    name: 'LogisticsNo'
	},
	{
	    name: 'BarCode'
	},
	{
	    name: 'SecurityCode'
	},
	{
	    name: 'ProductName'
	},
	{
	    name: 'AliasName'
	},
	{
	    name: 'Specifications'
	},
	{
	    name: 'SpecificationsText'
	},
	{
	    name: 'Unit'
	},
	{
	    name: 'UnitText'
	},
	{
	    name: 'SalePrice'
	},
	{
	    name: 'SalePriceLower'
	},
	{
	    name: 'SalePriceLimit'
	},
	{
	    name: 'TaxWhPrice'
	},
	{
	    name: 'TaxRate'
	},
	{
	    name: 'Tax'
	},
	{
	    name: 'SalesTax'
	},
	{
	    name: 'UnitConvertRate'
	},
	{
	    name: 'AutoFreight'
	},
	{
	    name: 'DriverFreight'
	},
	{
	    name: 'TrainFreight'
	},
	{
	    name: 'ShipFreight'
	},
	{
	    name: 'OtherFeight'
	},
	{
	    name: 'Supplier'
	},
	{
	    name: 'SupplierText'
	},
	{
	    name: 'Origin'
	},
	{
	    name: 'OriginText'
	},
	{
	    name: 'AliasPrice'
	},
	{
	    name: 'IsPlan'
	},
	{
	    name: 'ProductType'
	},
	{
	    name: 'ProductVer'
	},
	{
	    name: 'Remark'
	},
	{
	    name: 'CreateDate'
	},
	{
	    name: 'UpdateDate'
	},
	{
	    name: 'OperId'
	},
	{
	    name: 'OrgId'
}])
	,
    listeners:
	{
	    scope: this,
	    load: function() {
	    }
	}
});

            /*------获取数据的函数 结束 End---------------*/

            /*------WindowForm 配置开始------------------*/


            /*------WindowForm 配置开始------------------*/

            /*------开始DataGrid的函数 start---------------*/

            var txtProductName = new Ext.form.TextField({});
            var lblProductName = new Ext.form.Label({ text: "商品名称" });
            var sm = new Ext.grid.CheckboxSelectionModel({
                singleSelect: false
            });
            var productGrid = new Ext.grid.GridPanel({
                width: '100%',
                height: '100%',
                //autoWidth:true,
                //autoHeight:true,
                autoScroll: true,
                layout: 'fit',
                store: productGridData,
                loadMask: { msg: '正在加载数据，请稍侯……' },
                sm: sm,
                cm: new Ext.grid.ColumnModel([
		sm,
		new Ext.grid.RowNumberer(), //自动行号
		{
		header: '存货ID',
		dataIndex: 'ProductId',
		id: 'ProductId',
		hidden: true,
		hideable: false
},
		{
		    header: '存货编号',
		    dataIndex: 'ProductNo',
		    id: 'ProductNo',
		    width: 100
		},
		{
		    header: '助记码',
		    dataIndex: 'MnemonicNo',
		    id: 'MnemonicNo',
		    width: 100
		},
		{
		    header: '存货名称',
		    dataIndex: 'ProductName',
		    id: 'ProductName',
		    width: 170
		},
		{
		    header: '规格',
		    dataIndex: 'SpecificationsText',
		    id: 'SpecificationsText',
		    width: 40
		},
		{
		    header: '计量单位',
		    dataIndex: 'UnitText',
		    id: 'UnitText',
		    width: 60
		},
		{
		    header: '销售单价',
		    dataIndex: 'SalePrice',
		    id: 'SalePrice',
		    width: 60
		},
		{
		    header: '供应商',
		    dataIndex: 'SupplierText',
		    id: 'SupplierText',
		    width: 150
		},
		{
		    header: '产地',
		    dataIndex: 'OriginText',
		    id: 'OriginText',
		    width: 100
}]),
                bbar: new Ext.PagingToolbar({
                    pageSize: 10,
                    store: productGridData,
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
                tbar: [
                lblProductName, txtProductName,
		    {
		        id: 'btnSearch',
		        text: '查找',
		        iconCls: 'add',
		        handler: function() {
		            if (productGridData.baseParams.ProductName != txtProductName.getValue()) {
		                productGridData.baseParams.ProductName = txtProductName.getValue();
		            }
		            if (productGridData.getCount() == 0) {
		                productGridData.baseParams.limit = 10;
		                productGridData.baseParams.start = 0;
		                productGridData.load();
		            }
		            else {
		                productGridData.reload();
		            }
		        }
}],
                height: 340,
                closeAction: 'hide',
                stripeRows: true,
                loadMask: true//,
                //autoExpandColumn: 2
            });


            /*------DataGrid的函数结束 End---------------*/
            if (typeof (selectProductWindow) == "undefined") {//解决创建2个windows问题
                selectProductWindow = new Ext.Window({
                    id: 'selectProductWindow',
                    title: "选择供应商商品"
                , iconCls: 'upload-win'
                , width: 750
                , height: 500
                , layout: 'fit'
                , plain: true
                , modal: true
                    // , x: 50
                    // , y: 50
                , constrain: true
                , resizable: false
                , closeAction: 'hide'
                , autoDestroy: true
                , items: productGrid
                , buttons: [{
                    id: 'savebuttonid'
                    , text: "选择"
                    , handler: function() {
                        var sm = productGrid.getSelectionModel();
                        //获取选择的数据信息
                        var selectData = sm.getSelections();
                        var ids = "";
                        //                        for (var i = 0; i < selectData.length; i++) {
                        //                            insertNewBlankRow(selectData[i]);
                        //                        }
                        selectProductWindow.hide();
                    }
                    , scope: this
                },
                {
                    text: "取消"
                    , handler: function() {
                        selectProductWindow.hide();
                    }
                    , scope: this
}]
                });
            }
        })
</script>
<body>
    <form id="form1" runat="server">
    <div id='crmCustomreFixPriceGrid'>
    </div>
    </form>
</body>
</html>
