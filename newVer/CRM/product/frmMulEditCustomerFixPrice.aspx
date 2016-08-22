<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmMulEditCustomerFixPrice.aspx.cs" Inherits="CRM_product_frmMulEditCustomerFixPrice" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>�ڲ��ͻ����ⶨ��--��������</title>
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
        //����ͻ��������첽���÷���            
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
        // ����ͻ��������첽������ʾģ��
        var resultTpl = new Ext.XTemplate(
            '<tpl for="."><div id="searchkhdivid" class="search-item">',
                '<h3><span>�ͻ���ţ�{CustomerNo}  �ͻ�ȫ�ƣ� {ChineseName}</span>  �ͻ���ַ��{Address}</h3>',
        //'<br>����ʱ�䣺{createDate}',  
            '</div></tpl>'
        );

        /*------��ʼ��ȡ���ݵĺ��� start---------------*/
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
        /*------��ȡ���ݵĺ��� ���� End---------------*/
        /*------��ʼ��ѯform�ĺ��� start---------------*/
        var customerNamePanel = new Ext.form.TextField({
            style: 'margin-left:0px',
            cls: 'key',
            xtype: 'textfield',
            fieldLabel: '�ͻ�����',
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
		rowNum, //�Զ��к�		
		{
		    header: '�ͻ�����',
		    dataIndex: 'CustomerName',
		    id: 'CustomerName',
		    width: 150,
		    locked: true
		},
		{
		    header: '��Ʒ����',
		    dataIndex: 'ProductName',
		    id: 'ProductIdText',
		    width: 150,
		    locked: true
		},
		{
		    header: '���',
		    dataIndex: 'SpecificationsText',
		    width: 150,
		    id: 'ProductIdUnit'
		},
		{
		    header: '���ۼ�����',
		    dataIndex: 'SalePriceLimit',
		    id: 'SalePriceLimit',
		    width: 80,
		    editor: new Ext.form.NumberField
		},
		{
		    header: '���ۼ�����',
		    dataIndex: 'SalePriceLower',
		    id: 'SalePriceLower',
		    width: 80,
		    editor: new Ext.form.NumberField
		},
		{
		    header: '���۵���',
		    dataIndex: 'SalePrice',
		    id: 'SalePrice',
		    width: 80,
		    editor: new Ext.form.NumberField
		},
		{
		    header: '��˰����',
		    dataIndex: 'TaxWhPrice',
		    id: 'TaxWhPrice',
		    width: 80,
		    editor: new Ext.form.NumberField
		},
		{
		    header: '˰��',
		    dataIndex: 'TaxRate',
		    id: 'TaxRate',
		    width: 80,
		    editor: new Ext.form.NumberField
		},
		{
		    header: '˰��',
		    dataIndex: 'Tax',
		    id: 'Tax',
		    width: 80,
		    editor: new Ext.form.NumberField
		},
		{
		    header: '����˰��',
		    dataIndex: 'SalesTax',
		    id: 'SalesTax',
		    width: 80,
		    editor: new Ext.form.NumberField
		},
		{
		    header: '��ע',
		    dataIndex: 'Remark',
		    id: 'Remark',
		    width: 120,
		    editor: new Ext.form.TextArea
}],
            bbar: new Ext.PagingToolbar({
                pageSize: 100,
                store: crmCustomreFixPricegridData,
                displayMsg: '��ʾ��{0}����{1}����¼,��{2}��',
                emptyMsy: 'û�м�¼',
                displayInfo: true
            }),
            viewConfig: {
                columnsText: '��ʾ����',
                scrollOffset: 20,
                sortAscText: '����',
                sortDescText: '����'
            },
            height: 280,
            
            tbar: [{
                id: 'btnSave',
                text: '��ȡ��Ӧ����Ʒ',
                iconCls: 'add',
                handler: function() {
                    selectProductWindow.show();
                }
}]
            });
            crmCustomreFixPricegrid.render();


            /*------��ʼ��ȡ���ݵĺ��� start---------------*/
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

            /*------��ȡ���ݵĺ��� ���� End---------------*/

            /*------WindowForm ���ÿ�ʼ------------------*/


            /*------WindowForm ���ÿ�ʼ------------------*/

            /*------��ʼDataGrid�ĺ��� start---------------*/

            var txtProductName = new Ext.form.TextField({});
            var lblProductName = new Ext.form.Label({ text: "��Ʒ����" });
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
                loadMask: { msg: '���ڼ������ݣ����Ժ��' },
                sm: sm,
                cm: new Ext.grid.ColumnModel([
		sm,
		new Ext.grid.RowNumberer(), //�Զ��к�
		{
		header: '���ID',
		dataIndex: 'ProductId',
		id: 'ProductId',
		hidden: true,
		hideable: false
},
		{
		    header: '������',
		    dataIndex: 'ProductNo',
		    id: 'ProductNo',
		    width: 100
		},
		{
		    header: '������',
		    dataIndex: 'MnemonicNo',
		    id: 'MnemonicNo',
		    width: 100
		},
		{
		    header: '�������',
		    dataIndex: 'ProductName',
		    id: 'ProductName',
		    width: 170
		},
		{
		    header: '���',
		    dataIndex: 'SpecificationsText',
		    id: 'SpecificationsText',
		    width: 40
		},
		{
		    header: '������λ',
		    dataIndex: 'UnitText',
		    id: 'UnitText',
		    width: 60
		},
		{
		    header: '���۵���',
		    dataIndex: 'SalePrice',
		    id: 'SalePrice',
		    width: 60
		},
		{
		    header: '��Ӧ��',
		    dataIndex: 'SupplierText',
		    id: 'SupplierText',
		    width: 150
		},
		{
		    header: '����',
		    dataIndex: 'OriginText',
		    id: 'OriginText',
		    width: 100
}]),
                bbar: new Ext.PagingToolbar({
                    pageSize: 10,
                    store: productGridData,
                    displayMsg: '��ʾ��{0}����{1}����¼,��{2}��',
                    emptyMsy: 'û�м�¼',
                    displayInfo: true
                }),
                viewConfig: {
                    columnsText: '��ʾ����',
                    scrollOffset: 20,
                    sortAscText: '����',
                    sortDescText: '����',
                    forceFit: true
                },
                tbar: [
                lblProductName, txtProductName,
		    {
		        id: 'btnSearch',
		        text: '����',
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


            /*------DataGrid�ĺ������� End---------------*/
            if (typeof (selectProductWindow) == "undefined") {//�������2��windows����
                selectProductWindow = new Ext.Window({
                    id: 'selectProductWindow',
                    title: "ѡ��Ӧ����Ʒ"
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
                    , text: "ѡ��"
                    , handler: function() {
                        var sm = productGrid.getSelectionModel();
                        //��ȡѡ���������Ϣ
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
                    text: "ȡ��"
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
