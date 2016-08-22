<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmProductPrice.aspx.cs"
    Inherits="CRM_product_frmCrmCustomerFixPrice" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
    <title>��Ʒ�������ۼ�����</title>
    <meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
    <link rel="stylesheet" type="text/css" href="../../ext3/resources/css/ext-all.css" />
    <link rel="stylesheet" type="text/css" href="../../Theme/1/css/salt.css" />
    <script type="text/javascript" src="../../ext3/adapter/ext/ext-base.js"></script>
    <script type="text/javascript" src="../../ext3/ext-all.js"></script>
<%--    <script type="text/javascript" src="../../ext3/src/locale/ext-lang-zh_CN.js"></script>--%>
    <script type="text/javascript" src="../../js/operateResp.js"></script>

</head>
<body>
    <div id='toolbar'>
    </div>
    <div id='searchForm'>
    </div>
    <div id='crmCustomreFixPriceGrid'>
    </div>
</body>

<%= getComboBoxStore() %>

<script type="text/javascript">
    var crmCustomreFixPricegridData;
    var uploadFixpiceWindow;
    /*������Ʒ������Ϣ*/
    function loadData() {
        uploadFixpiceWindow.hide();
        if (productName != "") {
            crmCustomreFixPricegridData.baseParams.ProductName = productName;
            crmCustomreFixPricegridData.load({ params: { limit: 10, start: 0} });
            Ext.getCmp("searchebtnId").setDisabled(true);
        }
        else {
            Ext.getCmp("searchebtnId").setDisabled(false);
        }
    } 

Ext.BLANK_IMAGE_URL = "../../ext3/resources/images/default/s.gif";
Ext.onReady(function() {
    var saveType;
    Ext.QuickTips.init();
    Ext.form.Field.prototype.msgTarget = 'side';
    //����ͻ��������첽���÷���            
    var dsCustomers;
    if (dsCustomers == null) {
        dsCustomers = new Ext.data.Store({
            url: 'frmProductPrice.aspx?method=getCustomers',
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
            '<tpl for="."><div id="searchdivid" class="search-item">',
                '<h3><span>��Ʒ���:{ProductNo}&nbsp;  ��Ʒ����:{ProductName}&nbsp;  ���:{SpecificationsText}&nbsp;��λ:{UnitText}&nbsp;}</span></h3>',
            '</div></tpl>'
             );
    /*------ʵ��toolbar�ĺ��� start---------------*/
    var Toolbar = new Ext.Toolbar({
        renderTo: "toolbar",
        items: [{
            text: "����",
            icon: "../../Theme/1/images/extjs/customer/add16.gif",
            handler: function() {
                saveType = 'add';
                openAddFixpiceWin();
            }
        }, '-', {
            text: "�༭",
            icon: "../../Theme/1/images/extjs/customer/edit16.gif",
            handler: function() {
                saveType = 'save';
                modifyFixpiceWin();
            }
        }, '-', {
            text: "ɾ��",
            icon: "../../Theme/1/images/extjs/customer/delete16.gif",
            handler: function() {
                deleteFixpice();
            }
        }]
    });

        /*------����toolbar�ĺ��� end---------------*/

        function setProducrAttributes(record) {
            //alert(record.data.cusid); 
            //alert(Ext.getCmp('search').getValue());                        
            Ext.getCmp('ProductName').setValue(record.data.ProductName);
            Ext.getCmp('ProductId').setValue(record.data.ProductId);
            //Ext.getCmp('ProductIdUnit').setValue(record.data.Unit);
            Ext.getCmp('UnitId').setValue(record.data.Unit);
//            Ext.getCmp('ProductIdUnitName').setValue(record.data.UnitText);
            Ext.getCmp('ProductIdSup').setValue(record.data.Specifications);
            Ext.getCmp('ProductIdSupName').setValue(record.data.SpecificationsText);
            Ext.getCmp('SalePriceLower').setValue(record.data.SalePriceLower);
            Ext.getCmp('SalePriceLimit').setValue(record.data.SalePriceLimit);
            Ext.getCmp('TaxRate').setValue(record.data.SalesTax);
            Ext.getCmp('SalesTax').setValue(record.data.SalesTax);

            beforeEdit();
            //up,down,
            //����
            Ext.Ajax.request({
                url: 'frmProductPrice.aspx?method=getWhPrice',
                params: {
                    ProductId: record.data.ProductId,
                    Supplier: record.data.Supplier
                },
                success: function(resp, opts) {
                    var dataPrice = Ext.util.JSON.decode(resp.responseText);
                    Ext.getCmp("TaxWhPrice").setValue(dataPrice.price);
                },
                failure: function(resp, opts) {
                    Ext.Msg.alert("��ʾ", "��ȡ��Ʒ��Ϣʧ��");
                }
            });
        }

        /*------��ʼToolBar�¼����� start---------------*//*-----����Fixpiceʵ���ര�庯��----*/
        function openAddFixpiceWin() {
            crmCustomreFixPrice.getForm().reset();
            Ext.getCmp('ProductName').setDisabled(false);
            uploadFixpiceWindow.show();
            if (productName != "") {
                Ext.getCmp("ProductId").setValue(productId);
                Ext.getCmp("ProductName").setValue(productName);
                Ext.getCmp('ProductName').setDisabled(true);
                Ext.getCmp('ProductIdUnit').setValue(unit);
                Ext.getCmp('ProductIdUnitName').setValue(unitText);
                Ext.getCmp('ProductIdSup').setValue(specifications);
                Ext.getCmp('ProductIdSuptName').setValue(specificationsText);
            }
            /*----------���幩Ӧ����Ͽ� start -------------*/
            //�����Ʒ�������첽���÷���
            var dsProducts;
            if (dsProducts == null) {
                dsProducts = new Ext.data.Store({
                    url: 'frmProductPrice.aspx?method=getProducts',
                    reader: new Ext.data.JsonReader({
                        root: 'root',
                        totalProperty: 'totalProperty'
                    }, [
                            { name: 'ProductId', mapping: 'ProductId' },
                            { name: 'ProductNo', mapping: 'ProductNo' },
                            { name: 'ProductName', mapping: 'ProductName' },
                            { name: 'Unit', mapping: 'Unit' },
                            { name: 'Supplier', mapping: 'Supplier' },
                            { name: 'SalePriceLower', mapping: 'SalePriceLower' },
                            { name: 'SalePriceLimit', mapping: 'SalePriceLimit' },
                            { name: 'UnitText', mapping: 'UnitText' },
                            { name: 'Specifications', mapping: 'Specifications' },
                            { name: 'SpecificationsText', mapping: 'SpecificationsText' },
                            { name: 'SalesTax', mapping: 'SalesTax' }
                        ])
                });
            }

            var productFilterCombo = new Ext.form.ComboBox({
                store: dsProducts,
                displayField: 'ProductName',
                displayValue: 'ProductId',
                typeAhead: false,
                minChars: 1,
                id: 'productFilterCombo',
                loadingText: 'Searching...',
                tpl: resultTpl,  
                itemSelector: 'div.search-item', 
                pageSize: 10,
                hideTrigger: true,
                applyTo: 'ProductName',
                onSelect: function(record) { // override default onSelect to do redirect  
                    setProducrAttributes(record);
                    this.collapse();
                }
            });

        }
        /*-----�༭Fixpiceʵ���ര�庯��----*/
        function modifyFixpiceWin() {
            var sm = crmCustomreFixPricegrid.getSelectionModel();
            //��ȡѡ���������Ϣ
            var selectData = sm.getSelected();
            if (selectData == null) {
                Ext.Msg.alert("��ʾ", "��ѡ����Ҫ�༭����Ϣ��");
                return;
            }
            uploadFixpiceWindow.show();
            Ext.getCmp('ProductName').setDisabled(true);
            setFormValue(selectData);

        }
        /*-----ɾ��Fixpiceʵ�庯��----*/
        /*ɾ����Ϣ*/
        function deleteFixpice() {
            var sm = crmCustomreFixPricegrid.getSelectionModel();
            //��ȡѡ���������Ϣ
            var selectData = sm.getSelected();
            //���û��ѡ�񣬾���ʾ��Ҫѡ��������Ϣ
            if (selectData == null) {
                Ext.Msg.alert("��ʾ", "��ѡ����Ҫɾ������Ϣ��");
                return;
            }
            //ɾ��ǰ�ٴ������Ƿ����Ҫɾ��
            Ext.Msg.confirm("��ʾ��Ϣ", "�Ƿ����Ҫɾ��ѡ�����Ϣ��", function callBack(id) {
                //�ж��Ƿ�ɾ������
                if (id == "yes") {
                    //ҳ���ύ
                    Ext.Ajax.request({
                        url: 'frmProductPrice.aspx?method=deleteFixpice',
                        method: 'POST',
                        params: {
                            SpecialPricingId: selectData.data.SpecialPricingId
                        },
                        success: function(resp, opts) {
                            Ext.Msg.alert("��ʾ", "����ɾ���ɹ�");
                        },
                        failure: function(resp, opts) {
                            Ext.Msg.alert("��ʾ", "����ɾ��ʧ��");
                        }
                    });
                }
            });
        }

        //�����������첽���÷���,��ǰ�ͻ��ɶ���Ʒ�б�
        var dsProductUnits = new Ext.data.Store({
            url: '../../scm/frmOrderDtl.aspx?method=getProductUnits',
            params: {
                ProductId: 0
            },
            reader: new Ext.data.JsonReader({
                root: 'root',
                totalProperty: 'totalProperty',
                id: 'ProductUnits'
            }, [
                { name: 'UnitId', mapping: 'UnitId' },
                { name: 'UnitName', mapping: 'UnitName' }
            ]),
            listeners: {
                load: function() {
                    var combo = Ext.getCmp('UnitId');
                    combo.setValue(combo.getValue());
                }
            }
        });
        dsProductUnits.load();

        function beforeEdit() {
            var productId = Ext.getCmp('ProductId').getValue();
            if (productId != dsProductUnits.baseParams.ProductId) {
                dsProductUnits.baseParams.ProductId = productId;
                dsProductUnits.load();
            }
        }
        /*------ʵ��FormPanle�ĺ��� start---------------*/
        var crmCustomreFixPrice = new Ext.form.FormPanel({
            //renderTo: 'divForm',
            frame: true,
            items: [
                {
                    layout: 'column',
                    border: false,
                    items: [
		            {
		                layout: 'form',
		                border: false,
		                columnWidth: 1,
		                items: [
		                    {
		                        xtype: 'hidden',
		                        fieldLabel: '�ͻ���Ʒ���ⶨ��ID',
		                        name: 'SpecialPricingId',
		                        id: 'SpecialPricingId',
		                        hidden: true,
		                        hideLabel: false
		                    },
		                    {
		                        xtype: 'hidden',
		                        fieldLabel: '�ͻ�ID',
		                        name: 'CustomerId',
		                        id: 'CustomerId',
		                        hidden: true,
		                        hideLabel: false,
		                        value: -1
		                    },
		                    {
		                        xtype: 'hidden',
		                        fieldLabel: 'type',
		                        name: 'PriceType',
		                        id: 'PriceType',
		                        hidden: true,
		                        hideLabel: false,
		                        value: 1
                        }]
                    }]
                },
                {
                    layout: 'column',
                    border: false,
                    items: [
		            {
		                layout: 'form',
		                border: false,
		                columnWidth: 1,
		                items: [
			            {
			                xtype: 'hidden',
			                fieldLabel: '��ƷID',
			                anchor: '90%',
			                name: 'ProductId',
			                id: 'ProductId',
			                hidden: true,
			                hideLabel: true
			            },
                        {
                            xtype: 'textfield',
                            fieldLabel: '��Ʒ����',
                            anchor: '95%',
                            name: 'ProductName',
                            id: 'ProductName'
	                        , allowBlank: false               //������Ϊ��
                            , blankText: '�����Ϊ��!'  //��ʾΪ�յĴ�
                        }]
		                //                    },
		                //                     {
		                //                       layout: 'form',
		                //                       columnWidth: .05,  //����ռ�õĿ�ȣ���ʶΪ20��
		                //                       border: false,
		                //                       items: [{
		                //                                xtype:'button', 
		                //                                iconCls:"find",
		                //                                autoWidth : true,
		                //                                autoHeight : true,
		                //                                id:'customFind',
		                //                                hideLabel:true,
		                //                                listeners:{//���ڲ�����С����Ӧ�̵Ĳ�Ʒ���������ﲻ�ܼӣ���Ҫ������һ����
		                //                                    click:function(v){
		                //                                       //getCustomerInfo(initCustomerInfo,Ext.getCmp('OrgId').getValue());                                    
		                //                                       getProductInfo(setProducrAttributes);
		                //                                    }
		                //                                }
		                //                              }]
                    }]
                },
                {
                    layout: 'column',
                    border: false,
                    items: [
                    {
                        layout: 'form',
                        border: false,
                        columnWidth: .5,
                        items: [
			            {
			                xtype: 'textfield',
			                fieldLabel: '��λ',
			                anchor: '90%',
			                name: 'ProductIdUnit',
			                id: 'ProductIdUnit',
			                hidden: true,
			                hideLabel: true
			            },
                        {
                            xtype: 'combo',
                            store: dsProductUnits, //dsWareHouse,
                            valueField: 'UnitId',
                            displayField: 'UnitName',
                            mode: 'local',
                            forceSelection: true,
                            editable: false,
                            name: 'UnitId',
                            id: 'UnitId',
                            emptyValue: '',
                            triggerAction: 'all',
                            fieldLabel: '��λ',
                            selectOnFocus: true,
                            anchor: '90%'
                            //                            xtype: 'textfield',
                            //                            fieldLabel: '��λ',
                            //                            anchor: '90%',
                            //                            name: 'ProductIdUnitName',
                            //                            id: 'ProductIdUnitName'
                        }]
                    }, {
                        layout: 'form',
                        border: false,
                        columnWidth: 0.5,
                        items: [
			            {
			                xtype: 'textfield',
			                fieldLabel: '���',
			                anchor: '90%',
			                name: 'ProductIdSup',
			                id: 'ProductIdSup',
			                hidden: true,
			                hideLabel: true
			            },
                        {
                            xtype: 'textfield',
                            fieldLabel: '���',
                            anchor: '90%',
                            name: 'ProductIdSupName',
                            id: 'ProductIdSupName'
                        }
                        ]
                    }]
                },
                {
                    layout: 'column',
                    border: false,
                    items: [
		            {
		                layout: 'form',
		                border: false,
		                columnWidth: .5,
		                items: [
			            {
			                xtype: 'numberfield',
			                fieldLabel: '���ۼ�����',
			                anchor: '90%',
			                name: 'SalePriceLimit',
			                id: 'SalePriceLimit',
			                decimalPrecision: 6
                        }]
		            },
                    {
                        layout: 'form',
                        border: false,
                        columnWidth: .5,
                        items: [
                        {
                            xtype: 'numberfield',
                            fieldLabel: '���ۼ�����',
                            anchor: '90%',
                            name: 'SalePriceLower',
                            id: 'SalePriceLower',
                            decimalPrecision: 6
                        }]
                    }]
                },
                {
                    layout: 'column',
                    border: false,
                    items: [
		            {
		                layout: 'form',
		                border: false,
		                columnWidth: .5,
		                items: [
			            {
			                xtype: 'numberfield',
			                fieldLabel: '���۵���',
			                anchor: '90%',
			                name: 'SalePrice',
			                id: 'SalePrice'
	                        , allowBlank: false               //������Ϊ��
                            , blankText: '�����Ϊ��!'  //��ʾΪ�յĴ�
				, decimalPrecision: 6
                        }]
		            },
                     {
                         layout: 'form',
                         border: false,
                         columnWidth: .5,
                         items: [
			            {
			                xtype: 'numberfield',
			                fieldLabel: '��˰����',
			                anchor: '90%',
			                name: 'TaxWhPrice',
			                id: 'TaxWhPrice',
                            decimalPrecision: 8
                        }]
                    }]
                },
                {
                    layout: 'column',
                    border: false,
                    items: [
		            {
		                layout: 'form',
		                border: false,
		                columnWidth: .5,
		                items: [
			            {
			                xtype: 'numberfield',
			                fieldLabel: '˰��',
			                anchor: '90%',
			                name: 'TaxRate',
			                id: 'TaxRate',
					disabled: true
                        }]
		            },
                     {
                         layout: 'form',
                         border: false,
                         columnWidth: .5,
                         items: [
                        {
                            xtype: 'numberfield',
                            fieldLabel: '˰��',
                            anchor: '90%',
                            name: 'Tax',
                            id: 'Tax'
                        }]
                    }]
                },
                {
                    layout: 'column',
                    border: false,
                    items: [
		            {
		                layout: 'form',
		                border: false,
		                columnWidth: .5,
		                items: [
			            {
			                xtype: 'numberfield',
			                fieldLabel: '����˰��',
			                anchor: '90%',
			                name: 'SalesTax',
			                id: 'SalesTax',
                            decimalPrecision: 6,
					disabled: true
                        }]
		            },
                    {
                        layout: 'form',
                        border: false,
                        columnWidth: .5,
                        items: [
                        {
                            xtype: 'numberfield',
                            fieldLabel: 'װж��',
                            anchor: '90%',
                            name: 'AutoFreight',
                            id: 'AutoFreight',
                            decimalPrecision: 8
                        }]
                    }]
                },
                {
                    layout: 'column',
                    border: false,
                    items: [
		            {
		                layout: 'form',
		                border: false,
		                columnWidth: .5,
		                items: [
			            {
			                xtype: 'numberfield',
			                fieldLabel: '��ʻԱ�˷�',
			                anchor: '90%',
			                name: 'DriverFreight',
			                id: 'DriverFreight',
                            decimalPrecision: 8
                        }]
		            },
		            {
                         layout: 'form',
                         border: false,
                         columnWidth: .5,
                         items: [
                        {
                            xtype: 'numberfield',
                            fieldLabel: '�ͻ��˷�',
                            anchor: '90%',
                            name: 'OtherFeight',
                            id: 'OtherFeight',
                            decimalPrecision: 8
                        }]
                    }]
                },         
                {
                    layout: 'column',
                    border: false,
                    items: [
		            {
		                layout: 'form',
		                border: false,
		                columnWidth: .5,
		                items: [
			            {
			                xtype: 'hidden',
			                fieldLabel: '���˷�',
			                anchor: '90%',
			                name: 'ShipFreight',
			                id: 'ShipFreight',
                            decimalPrecision: 8
                        }]
		            },
                     {
                        layout: 'form',
                        border: false,
                        columnWidth: .5,
                        items: [
			            {
			                xtype: 'hidden',
			                fieldLabel: '���˷�',
			                anchor: '90%',
			                name: 'TrainFreight',
			                id: 'TrainFreight',
                            decimalPrecision: 8
                        }]
                    }]
                },
                {
                    layout: 'column',
                    border: false,
                    items: [
		            {
		                layout: 'form',
		                border: false,
		                columnWidth: .5,
		                items: [
			            {
			                xtype: 'datefield',
			                fieldLabel: '��Ч����',
			                anchor: '90%',
			                name: 'ValidDate',
			                id: 'ValidDate',
			                format: 'Y��m��d��',
			                value: new Date().clearTime()
                        }]
		            },
                     {
                         layout: 'form',
                         border: false,
                         columnWidth: .5,
                         items: [
                        {
                            xtype: 'datefield',
                            fieldLabel: 'ʧЧ����',
                            anchor: '90%',
                            name: 'ExpireDate',
                            id: 'ExpireDate',
                            format: 'Y��m��d��',
                            value: new Date("2099/12/31").clearTime()
                        }]
                    }]
                },
                {
                    ayout: 'column',
                    border: false,
                    items: [
		            {
		                layout: 'form',
		                border: false,
		                columnWidth: .1,
		                items: [
			            {
			                xtype: 'textarea',
			                fieldLabel: '��ע',
			                anchor: '95%',
			                name: 'Remark',
			                id: 'Remark'
                        }]
                    }]
                }]
        });
        /*------FormPanle�ĺ������� End---------------*/

        /*------��ʼ�������ݵĴ��� Start---------------*/
        if (typeof (uploadFixpiceWindow) == "undefined") {//�������2��windows����
            uploadFixpiceWindow = new Ext.Window({
                id: 'Fixpiceformwindow'
		, iconCls: 'upload-win'
		, width: 550
		, height: 400
		, layout: 'fit'
		, plain: true
		, modal: true
		, constrain: true
		, resizable: false
		, closeAction: 'hide'
		, autoDestroy: true
		, items: crmCustomreFixPrice
		, buttons: [{
		    text: "����"
			, handler: function() {
			    saveUserData();
			}
			, scope: this
		},
		{
		    text: "ȡ��"
			, handler: function() {
			    uploadFixpiceWindow.hide();
			}
			, scope: this
}]
            });
        }
        uploadFixpiceWindow.addListener("hide", function() {
            crmCustomreFixPrice.getForm().reset();
        });
        uploadFixpiceWindow.addListener("show", function() {

        });

        /*------��ʼ��ȡ�������ݵĺ��� start---------------*/
        function saveUserData() {
            //check
            if (!crmCustomreFixPrice.form.isValid()) {
                Ext.Msg.alert("��ʾ", "����ʧ��,����¼�������Ƿ���Ч��");
                return;
            }
            if(Ext.getCmp("UnitId").getValue()<=0) {
                Ext.Msg.alert("��ʾ", "����ʧ��,�����Ƿ�ѡ���˸�[���۵���]��Ӧ��[���۵�λ]��");
                return;
            }
                

            if (saveType == 'add')
                saveType = 'addFixpice';
            else if (saveType == 'save')
                saveType = 'saveFixpice';
            //alert(saveType);
            Ext.MessageBox.wait("�������ڱ��棬���Ժ󡭡�");
            Ext.Ajax.request({
                url: 'frmProductPrice.aspx?method=' + saveType,
                method: 'POST',
                params: {
                    SpecialPricingId: Ext.getCmp('SpecialPricingId').getValue(),
                    CustomerId: Ext.getCmp('CustomerId').getValue(),
                    ProductId: Ext.getCmp('ProductId').getValue(),
                    SalePriceLimit: Ext.getCmp('SalePriceLimit').getValue(),
                    SalePriceLower: Ext.getCmp('SalePriceLower').getValue(),
                    SalePrice: Ext.getCmp('SalePrice').getValue(),
                    TaxWhPrice: Ext.getCmp('TaxWhPrice').getValue(),
                    TaxRate: Ext.getCmp('TaxRate').getValue(),
                    Tax: Ext.getCmp('Tax').getValue(),
                    SalesTax: Ext.getCmp('SalesTax').getValue(),
                    UnitId: Ext.getCmp("UnitId").getValue(),
                    AutoFreight: Ext.getCmp('AutoFreight').getValue(),
                    DriverFreight: Ext.getCmp('DriverFreight').getValue(),
                    TrainFreight: Ext.getCmp('TrainFreight').getValue(),
                    ShipFreight: Ext.getCmp('ShipFreight').getValue(),
                    OtherFeight: Ext.getCmp('OtherFeight').getValue(),
                    PriceType: Ext.getCmp('PriceType').getValue(),
                    ValidDate: Ext.util.Format.date(Ext.getCmp('ValidDate').getValue(), 'Y/m/d'),
                    ExpireDate: Ext.util.Format.date(Ext.getCmp('ExpireDate').getValue(), 'Y/m/d'),
                    Remark: Ext.getCmp('Remark').getValue()
                },
                success: function(resp, opts) {
                    Ext.MessageBox.hide();
                    if (checkExtMessage(resp)) {
                        crmCustomreFixPricegridData.reload();
                        uploadFixpiceWindow.hide();
                    }
                },
                failure: function(resp, opts) {
                    Ext.MessageBox.hide();
                    Ext.Msg.alert("��ʾ", "����ʧ��");
                }
            });
        }
        /*------������ȡ�������ݵĺ��� End---------------*/

        /*------��ʼ�������ݵĺ��� Start---------------*/
        function setFormValue(selectData) {
            Ext.Ajax.request({
                url: 'frmProductPrice.aspx?method=getfixpice',
                params: {
                    SpecialPricingId: selectData.data.SpecialPricingId
                },
                success: function(resp, opts) {
                    var data = Ext.util.JSON.decode(resp.responseText);
                    Ext.getCmp("SpecialPricingId").setValue(data.SpecialPricingId);
                    Ext.getCmp("CustomerId").setValue(data.CustomerId);
                    Ext.getCmp("ProductId").setValue(data.ProductId);
                    beforeEdit();
                    Ext.getCmp("ProductName").setValue(data.ProductName);
                    Ext.getCmp("UnitId").setValue(data.UnitId);
                    Ext.getCmp("ProductIdSupName").setValue(data.SpecificationsText);
                    Ext.getCmp("SalePriceLimit").setValue(data.SalePriceLimit);
                    Ext.getCmp("SalePriceLower").setValue(data.SalePriceLower);
                    Ext.getCmp("SalePrice").setValue(data.SalePrice);
                    Ext.getCmp("TaxWhPrice").setValue(data.TaxWhPrice);
                    Ext.getCmp("TaxRate").setValue(data.TaxRate);
                    Ext.getCmp("Tax").setValue(data.Tax);
                    Ext.getCmp("SalesTax").setValue(data.SalesTax);
                    Ext.getCmp("AutoFreight").setValue(data.AutoFreight);
                    Ext.getCmp("DriverFreight").setValue(data.DriverFreight);
                    Ext.getCmp("TrainFreight").setValue(data.TrainFreight);
                    Ext.getCmp("ShipFreight").setValue(data.ShipFreight);
                    Ext.getCmp("OtherFeight").setValue(data.OtherFeight);
                    Ext.getCmp("PriceType").setValue(data.PriceType);
                    Ext.getCmp("Remark").setValue(data.Remark);
                    if (data.ValidDate != '') {
                        Ext.getCmp('ValidDate').setValue(new Date(Date.parse(data.ValidDate)));
                    }
                    if (data.ExpireDate != '') {
                        Ext.getCmp('ExpireDate').setValue(new Date(Date.parse(data.ExpireDate)));
                    }
                    //Ext.getCmp('ValidDate').setValue((new Date(data.ValidDate.replace(/-/g,"/"))));
                    //Ext.getCmp('ExpireDate').setValue((new Date(data.ExpireDate.replace(/-/g,"/"))));
                },
                failure: function(resp, opts) {
                    Ext.Msg.alert("��ʾ", "��ȡ�û���Ϣʧ��");
                }
            });
        }
        /*------�������ý������ݵĺ��� End---------------*/
        /*------��ʼ��ȡ���ݵĺ��� start---------------*/
        crmCustomreFixPricegridData = new Ext.data.Store
({
    url: 'frmProductPrice.aspx?method=getFixpiceList',
    reader: new Ext.data.JsonReader({
        totalProperty: 'totalProperty',
        root: 'root'
    }, [
	{ name: 'SpecialPricingId' },
	{ name: 'CustomerId' },
	{ name: "CustomerName" },
	{ name: 'ProductId' },
	{ name: 'ProductName' },
	{ name: 'ProductNo' },
	{ name: 'UnitText' },
	{ name: 'UnitName' },
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

crmCustomreFixPricegridData.baseParams.CustomerId=-1;
        /*------��ȡ���ݵĺ��� ���� End---------------*/
        /*------��ʼ��ѯform�ĺ��� start---------------*/
        var productNamePanel = new Ext.form.TextField({
            style: 'margin-left:0px',
            cls: 'key',
            xtype: 'textfield',
            fieldLabel: '��Ʒ����',
            id: 'sProductSearch',
            name: 'sProductSearch',
            anchor: '90%',
            listeners: { specialkey: function(f, e) { if (e.getKey() == e.ENTER) { Ext.getCmp('searchebtnId').focus(); } } }
        });
        
        var productNoPanel = new Ext.form.TextField({
            style: 'margin-left:0px',
            cls: 'key',
            xtype: 'textfield',
            fieldLabel: '��Ʒ����',
            id: 'sProductNoSearch',
            name: 'sProductNoSearch',
            anchor: '90%',
            listeners: { specialkey: function(f, e) { if (e.getKey() == e.ENTER) { Ext.getCmp('searchebtnId').focus(); } } }
        })

        var searchform = new Ext.FormPanel({
            renderTo: 'searchForm',
            labelAlign: 'left',
            layout: 'fit',
            buttonAlign: 'right',
            bodyStyle: 'padding:3px',
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
                        productNoPanel
                        ]
                }, {
                    columnWidth:.4,
                    layout:'form',
                    border:false,
                    items:[
                        productNamePanel
                    ]
                },{
                    columnWidth: .2,
                    layout: 'form',
                    border: false,
                    items: [{ cls: 'key',
                        xtype: 'button',
                        text: '��ѯ',
                        id: 'searchebtnId',
                        anchor: '50%',
                        handler: function() {
                            var productName = productNamePanel.getValue();
                            var productNo = productNoPanel.getValue();

                            crmCustomreFixPricegridData.baseParams.PriceType = 1;
                            crmCustomreFixPricegridData.baseParams.ProductName = productName;
                            crmCustomreFixPricegridData.baseParams.ProductNo = productNo;
                            crmCustomreFixPricegrid.getStore().load({
                                params: {
                                    start: 0,
                                    limit: 10
                                }
                            });
                        }
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
                        el: 'crmCustomreFixPriceGrid',
                        //width: '100%',
                        height: '100%',
                        //autoWidth: true,
                        //autoHeight: true,
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
		    header: '��Ʒ���',
		    dataIndex: 'ProductNo',
		    id: 'ProductIdText',
		    width: 200
		},
		{
		    header: '��Ʒ����',
		    dataIndex: 'ProductName',
		    id: 'ProductIdText',
		    width: 200
		},
		{
		    header: '���',
		    dataIndex: 'SpecificationsText',
		    id: 'ProductIdSup'
		},
		{
		    header: '���۵�λ',
		    dataIndex: 'UnitName',
		    id: 'UnitName'
		},
//		{
//		    header: '��λ',
//		    dataIndex: 'UnitText',
//		    id: 'ProductIdUnit'
//		},
		{
		    header: '���ۼ�����',
		    dataIndex: 'SalePriceLimit',
		    id: 'SalePriceLimit'
		},
		{
		    header: '���ۼ�����',
		    dataIndex: 'SalePriceLower',
		    id: 'SalePriceLower'
		},
		{
		    header: '���۵���',
		    dataIndex: 'SalePrice',
		    id: 'SalePrice'
		},
		{
		    header: '��˰����',
		    dataIndex: 'TaxWhPrice',
		    id: 'TaxWhPrice'
		},
		{
		    header: '˰��',
		    dataIndex: 'TaxRate',
		    id: 'TaxRate',
		    width: 50
		},
		{
		    header: '˰��',
		    dataIndex: 'Tax',
		    id: 'Tax',
		    width: 50
		},
		{
		    header: '����˰��',
		    dataIndex: 'SalesTax',
		    id: 'SalesTax'
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
                            forceFit: false
                        },
                        height: 320,
                        closeAction: 'hide',
                        stripeRows: true,
                        loadMask: true//,
                        //autoExpandColumn: 2
                    });
                    crmCustomreFixPricegrid.render();
                    /*------DataGrid�ĺ������� End---------------*/
                    loadData();

                })
</script>
</html>
<script type="text/javascript" src="../../js/SelectModule.js"></script>
