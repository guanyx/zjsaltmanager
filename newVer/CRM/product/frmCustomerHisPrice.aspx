<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmCustomerHisPrice.aspx.cs" Inherits="CRM_product_frmCustomerHisPrice" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>�ͻ�������ʷ��ѯ</title>
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
    /*------��ʼ��ȡ���ݵĺ��� start---------------*/
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
        listeners: { specialkey: function(f, e) { if (e.getKey() == e.ENTER) { Ext.getCmp('sProductrSearch').focus(); } } }
    });
    
    var productNamePanel = new Ext.form.TextField({
        style: 'margin-left:0px',
        cls: 'key',
        xtype: 'textfield',
        fieldLabel: '��Ʒ����',
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
            layout: 'column',   //�����Ԫ��Ϊ����Ϊ�в��ַ�ʽ
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
                    text: '��ѯ',
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
                    columnWidth: .4,  //����ռ�õĿ�ȣ���ʶΪ20��
                    layout: 'form',
                    border: false,
                    html: '&nbsp'
                }]
            }]
        }]
    });


    /*------��ʼ��ѯform�ĺ��� end---------------*/

    /*------��ʼDataGrid�ĺ��� start---------------*/

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
        loadMask: { msg: '���ڼ������ݣ����Ժ��' },
        sm: sm,
        cm: new Ext.grid.ColumnModel([
		sm,
		new Ext.grid.RowNumberer(), //�Զ��к�
		{
	        header: '�ͻ���Ʒ���ⶨ��ID',
	        dataIndex: 'SpecialPricingId',
	        id: 'SpecialPricingId',
	        hidden: true,
	        hideable: false
        },
		{
		    header: '�ͻ�Id',
		    dataIndex: 'CustomerId',
		    id: 'CustomerId',
		    hidden: true,
		    hideable: false
		},
		{
		    header: '��ƷID',
		    dataIndex: 'ProductId',
		    id: 'ProductId',
		    hidden: true,
		    hideable: false
		},
		{
		    header: '�ͻ�����',
		    dataIndex: 'CustomerName',
		    id: 'CustomerName'
		},
		{
		    header: '��Ʒ����',
		    dataIndex: 'ProductName',
		    id: 'ProductIdText'
		},
		{
		    header: '���',
		    dataIndex: 'SpecificationsText',
		    id: 'ProductIdUnit',
		    width:80
		},
		{
		    header: '���ۼ�����',
		    dataIndex: 'SalePriceLimit',
		    id: 'SalePriceLimit',
		    width:110
		},
		{
		    header: '���ۼ�����',
		    dataIndex: 'SalePriceLower',
		    id: 'SalePriceLower',
		    width:110
		},
		{
		    header: '���۵���',
		    dataIndex: 'SalePrice',
		    id: 'SalePrice',
		    width:90
		},
		{
		    header: '˰��',
		    dataIndex: 'TaxRate',
		    id: 'TaxRate',
		    width:90
        },
		{
		    header: '˰��',
		    dataIndex: 'Tax',
		    id: 'Tax',
		    width:90
		},
		{
		    header: '����˰��',
		    dataIndex: 'SalesTax',
		    id: 'SalesTax',
		    width:90
		},
		{
		    header: '��Чʱ��',
		    dataIndex: 'ValidDate',
		    id: 'ValidDate',
		    sortable:true,
		    renderer: Ext.util.Format.dateRenderer('Y��m��d��')
		},
		{
		    header: 'ʧЧʱ��',
		    dataIndex: 'ExpireDate',
		    id: 'ExpireDate',
		    sortable:true,
		    renderer: Ext.util.Format.dateRenderer('Y��m��d��')
		},
		{
		    header: '��ע',
		    dataIndex: 'Remark',
		    id: 'Remark'
        }]),
        bbar: new Ext.PagingToolbar({
            pageSize: 10,
            store: crmCustomreFixPricegridData,
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
