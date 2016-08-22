 <%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmBaProduct.aspx.cs" Inherits="CRM_product_frmProduct" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head >
    <title>��Ʒά��</title>
    <meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
    <link rel="stylesheet" type="text/css" href="../../ext3/resources/css/ext-all.css" />
    <script type="text/javascript" src="../../ext3/adapter/ext/ext-base.js"></script>
    <script type="text/javascript" src="../../ext3/ext-all.js"></script>  
    <script type="text/javascript" src="../../js/operateResp.js"></script>    
    <script type="text/javascript" src="../../js/ExtJsHelper.js"></script>
    <script type="text/javascript" src="../../js/FilterControl.js"></script>
    <script type="text/javascript" src="../../js/ProductSelect.js"></script>
    <link rel="Stylesheet" type="text/css" href="../../css/gridPrint.css" />
</head>
<body>
    <div id='toolbar'></div>
    <div id='searchForm'></div>
    <div id='searchForm12'></div>
    <div id='productGrid'></div>
</body>

<%= getComboBoxStore() %>

<script type="text/javascript">
var copyProductUnitWin=null;
Ext.BLANK_IMAGE_URL = "../../ext3/resources/images/default/s.gif";
Ext.onReady(function() {
    var operType = '';
    Ext.QuickTips.init();
    Ext.form.Field.prototype.msgTarget = 'side';
    /*--------�������� start ---------------*/
    var dsSupplier; //��Ӧ������Դ
    var dsSmallProduct; //С��������

    /*----------�������� end --------------*/


    /*------ʵ��toolbar�ĺ��� start---------------*/
    var Toolbar = new Ext.Toolbar({
        renderTo: "toolbar",
        items: [{
            text: "����",
            icon: "../../Theme/1/images/extjs/customer/add16.gif",
            handler: function() {
                uploadUserWindow.setTitle("���������Ϣ");
                operType = 'add';
                openWindowShow();
            }
        }, '-', {
            text: "�༭",
            icon: "../../Theme/1/images/extjs/customer/edit16.gif",
            handler: function() {
                operType = 'edit';
                editProdctInfo();
            }
        }, '-', {
            text: "ɾ��",
            icon: "../../Theme/1/images/extjs/customer/delete16.gif",
            handler: function() {
                deleteProductInfo();
            }
        }, '-', {
            text: "���õ�λת��",
            icon: "../../Theme/1/images/extjs/customer/edit16.gif",
            handler: function() {
                setProductUnitWin();
            }
        }, '-', {
            text: "���Ƶ�λ��ϵ",
            icon: "../../Theme/1/images/extjs/customer/edit16.gif",
            handler: function() {
                //setProductUnitWin();
                setCopyProductUnitWin();
            }
        }, '-', {
            text: "���ü۸���ϵ",
            icon: "../../Theme/1/images/extjs/customer/edit16.gif",
            handler: function() {
                setProductPriceWin();
            }
        }, '-', {
            text: "�鿴",
            icon: "../../Theme/1/images/extjs/customer/delete16.gif",
            handler: function() {
                editProdctInfo();
                Ext.getCmp("savebuttonid").hide();
            }
        }, '-']
    });

    setToolBarVisible(Toolbar);
    /*  �޸Ĵ���  */
    function editProdctInfo() {
        uploadUserWindow.setTitle("�����Ϣά��");
        setFormValue(); //����������ֵ   
    }
    /*  ɾ������  */
    function deleteProductInfo() {
        var sm = productGrid.getSelectionModel();
        var selectData = sm.getSelected();
        /*
        var record=sm.getSelections();
        if(record == null || record.length == 0)
        return null;
        var array = new Array(record.length);
        for(var i=0;i<record.length;i++)
        {
        array[i] = record[i].get('uid');
        }
        */
        if (selectData == null || selectData.length == 0 || selectData.length > 1) {
            Ext.Msg.alert("��ʾ", "��ѡ��һ�У�");
        }
        else {
            //ɾ��ǰ�ٴ������Ƿ����Ҫɾ��
            Ext.Msg.confirm("��ʾ��Ϣ", "�Ƿ����Ҫɾ��ѡ�����Ϣ��", function callBack(id) {
                //�ж��Ƿ�ɾ������
                if (id == "yes") {
                    Ext.Ajax.request({
                        url: 'frmBaProduct.aspx?method=deleteProductInfo',
                        params: {
                            ProductId: selectData.data['ProductId']//����frmSysDicsInfo
                        },
                        success: function(resp, opts) {
                            if (checkExtMessage(resp)) {
                                //var data=Ext.util.JSON.decode(resp.responseText);
                                //Ext.Msg.alert("��ʾ", "ɾ���ɹ���");
                                productGrid.getStore().reload();
                            }
                        },
                        failure: function(resp, opts) {
                            Ext.Msg.alert("��ʾ", "ɾ��ʧ�ܣ�");
                        }
                    });
                }
            });
        }
    }

    /*���ø�����Ʒ��λ��Ϣ*/
    copyProductUnitWin = ExtJsShowWin("���ø�����Ʒ��λ��Ϣ", "#", "copyProductUnit", 700, 500);
    function setCopyProductUnitWin() {

        var sm = productGrid.getSelectionModel();
        var selectData = sm.getSelected();
        if (selectData == null || selectData.length == 0 || selectData.length > 1) {
            Ext.Msg.alert("��ʾ", "��ѡ����Ҫ���õĴ����Ϣ��");
            return;
        }
        copyProductUnitWin.show();
        if (document.getElementById("iframecopyProductUnit").src.indexOf("frmCopyProductUnit") == -1) {
            document.getElementById("iframecopyProductUnit").src = "frmCopyProductUnit.aspx?productId=" + selectData.data.ProductId;

        }
        else {
            document.getElementById("iframecopyProductUnit").contentWindow.productId = selectData.data.ProductId;
            document.getElementById("iframecopyProductUnit").contentWindow.loadData();
        }

    }

    /*����ѡ����Ʒ�ĵ�λ��Ϣ*/
    var productPriceWin = ExtJsShowWin("������Ʒ��λ��Ϣ", "#", "productPrice", 700, 500);
    function setProductPriceWin() {

        var sm = productGrid.getSelectionModel();
        var selectData = sm.getSelected();
        if (selectData == null || selectData.length == 0 || selectData.length > 1) {
            Ext.Msg.alert("��ʾ", "��ѡ����Ҫ���õĴ����Ϣ��");
            return;
        }
        productPriceWin.show();
        if (document.getElementById("iframeproductPrice").src.indexOf("frmProductPrice") == -1) {
            document.getElementById("iframeproductPrice").src = "frmProductPrice.aspx?productId=" + selectData.data.ProductId + "&productName=" + selectData.data.ProductName +
                "&specifications=" + selectData.data.Specifications + "&specificationsText=" + selectData.data.SpecificationsText;

        }
        else {
            document.getElementById("iframeproductPrice").contentWindow.productId = selectData.data.ProductId;
            document.getElementById("iframeproductPrice").contentWindow.productName = selectData.data.ProductName;
            document.getElementById("iframeproductPrice").contentWindow.specifications = selectData.data.Specifications;
            document.getElementById("iframeproductPrice").contentWindow.loadData();
        }

    }

    /*����ѡ����Ʒ�ĵ�λ��Ϣ*/
    var productUnitWin = ExtJsShowWin("������Ʒ��λ��Ϣ", "#", "productUnit", 600, 450);
    function setProductUnitWin() {

        var sm = productGrid.getSelectionModel();
        var selectData = sm.getSelected();
        if (selectData == null || selectData.length == 0 || selectData.length > 1) {
            Ext.Msg.alert("��ʾ", "��ѡ����Ҫ���õĴ����Ϣ��");
            return;
        }
        productUnitWin.show();
        if (document.getElementById("iframeproductUnit").src.indexOf("frmBaProductUnits") == -1) {
            document.getElementById("iframeproductUnit").src = "frmBaProductUnits.aspx?productId=" + selectData.data.ProductId + "&productName=" + selectData.data.ProductName;

        }
        else {
            document.getElementById("iframeproductUnit").contentWindow.productId = selectData.data.ProductId;
            document.getElementById("iframeproductUnit").contentWindow.productName = selectData.data.ProductName;
            document.getElementById("iframeproductUnit").contentWindow.loadData();
        }

    }

    function openWindowShow() {
        uploadUserWindow.show();
        Ext.getCmp('ProductVer').setValue(1);
        //Ext.getCmp('ProductNo').setDisabled(false);
        //Ext.getCmp('ProductName').setDisabled(false);
	    //Ext.getCmp('ClassType').setDisabled(false);
	    /*---��ȡ���---*/
	    if(operType == 'add'){
	        //��ȡ���
            Ext.Ajax.request({
                url: 'frmBaProduct.aspx?method=getProductNo',
                success: function(resp, opts) {
                    var dataNo = Ext.util.JSON.decode(resp.responseText);
                    Ext.getCmp('ProductNo').setValue(dataNo.ProductNo); 
                },
                failure: function(resp, opts) {
                    Ext.Msg.alert("��ʾ", "��ȡ���ʧ�ܣ�");
                }
            });        
        }
        /*----------���幩Ӧ����Ͽ� start -------------*/
        //�����������첽���÷���
        dsSupplier = new Ext.data.Store({
            url: 'frmBaProduct.aspx?method=getSupplieres',
            reader: new Ext.data.JsonReader({
                root: 'root',
                totalProperty: 'totalProperty',
                id: 'searchSupplierId'
            }, [
                { name: 'CustomerId', mapping: 'CustomerId' },
                { name: 'ChineseName', mapping: 'ChineseName' }
            ]),
            params: {
                SupplierId: Ext.getCmp('Supplier').getValue()
            }
        });
        var search = new Ext.form.ComboBox({
            store: dsSupplier,
            displayField: 'ChineseName',
            displayValue: 'CustomerId',
            typeAhead: false,
            minChars: 1,
            loadingText: 'Searching...',
            //width: 200,  
            pageSize: 10,
            hideTrigger: true,
            id: 'SupplierCombo',
            applyTo: 'Supplier',
            onSelect: function(record) { // override default onSelect to do redirect  
                //alert(record.data.cusid); 
                //alert(Ext.getCmp('search').getValue());                            
                Ext.getCmp('Supplier').setValue(record.data.ChineseName);
                Ext.getCmp('haddenSupplier').setValue(record.data.CustomerId);
                //Ext.getCmp('searchdivid').style.overflow='hidden';
                this.collapse();
            }
        });

        /*----------���幩Ӧ����Ͽ� end -------------*/
        /*----------����С����Ͽ� start ---------*/
        dsSmallProduct = new Ext.data.Store({
            url: 'frmBaProduct.aspx?method=getSmallClasses',
            reader: new Ext.data.JsonReader({
                root: 'root',
                totalProperty: 'totalProperty',
                id: 'searchSamllProductId'
            }, [
                { name: 'ClassId', mapping: 'ClassId' },
                { name: 'ClassName', mapping: 'ClassName' },
                { name: 'Specifications', mapping: 'Specifications' },
                { name: 'Unit', mapping: 'Unit' }
            ])
        });
        var searchSmallClass = new Ext.form.ComboBox({
            store: dsSmallProduct,
            displayField: 'ClassName',
            displayValue: 'ClassId',
            typeAhead: false,
            minChars: 1,
            loadingText: 'Searching...',
            //width: 200,  
            pageSize: 10,
            hideTrigger: true,
            id: 'SSmallClassCombo',
            applyTo: 'ClassType',
            onSelect: function(record) { // override default onSelect to do redirect  
                //alert(record.data.cusid); 
                //alert(Ext.getCmp('search').getValue());                            
                Ext.getCmp('ClassType').setValue(record.data.ClassName);
                Ext.getCmp('haddenClassType').setValue(record.data.ClassId);
                Ext.getCmp('ProductName').setValue(record.data.ClassName);
                Ext.getCmp('Specifications').setValue(record.data.Specifications);
                Ext.getCmp('Unit').setValue(record.data.Unit);
                //Ext.getCmp('searchdivid').style.overflow='hidden';
                this.collapse();
            }
        });
        /*----------����С����Ͽ� end ---------*/
    }
    /*------����toolbar�ĺ��� end---------------*/


    /*------ʵ��FormPanle�ĺ��� start---------------*/
    var productForm = new Ext.form.FormPanel({
        url: '',
        autoDestroy: true,
        frame: true,
        labelAlign: 'left',
        buttonAlign: 'right',
        bodyStyle: 'padding:5px',
        items: [
	{
	    layout: 'column',
	    border: false,
	    items: [
		{
		    layout: 'form',
		    border: false,
		    columnWidth: .66,
		    items: [
			    {
			        xtype: 'hidden',
			        fieldLabel: '���ID',
			        //columnWidth:1,
			        //anchor:'95%',
			        hidden: true,
			        name: 'ProductId',
			        id: 'ProductId',
			        hiddenLabel: true
			    },
				{
				    xtype: 'textfield',
				    fieldLabel: '<b>������*</b>',
				    anchor: '95%',
				    name: 'ProductNo',
				    id: 'ProductNo'
}]
		},
		{
		    layout: 'form',
		    border: false,
		    columnWidth: .34,
		    items: [{
		            xtype: 'hidden',
	                fieldLabel: '�汾',
	                //columnWidth:1,
	                //anchor:'95%',
	                hidden: true,
	                name: 'ProductVer',
	                id: 'ProductVer',
	                hiddenLabel: true
	            },
				{
				    xtype: 'textfield',
				    fieldLabel: 'Ʒ��',
				    anchor: '95%',
				    name: 'Brand',
				    id: 'Brand'
				}
		]
		}
	]
	},
	{
	    layout: 'column',
	    border: false,
	    items: [
        {
            layout: 'form',
            border: false,
            columnWidth: .66,
            items: [
			{
			    xtype: 'textfield',
			    fieldLabel: '<b>�ɹ���Ʒ���*</b>',
			    anchor: '95%',
			    name: 'ClassType',
			    id: 'ClassType'
			},
	        {
	            xtype: 'hidden',
	            fieldLabel: '�ɹ���Ʒ���ID',
	            name: 'haddenClassType',
	            id: 'haddenClassType'

}]
        },
        {
            layout: 'form',
            border: false,
            columnWidth: .34,
            items: [
		        {
		            xtype: 'combo',
		            fieldLabel: '<b>������*</b>', //�Ƿ���Ʒ���Ƿ���
		            anchor: '95%',
		            name: 'ProductType',
		            id: 'ProductType'
			        , displayField: 'DicsName'
                    , valueField: 'DicsCode'
                    , editable: false
                    , store: dsProductType
                    , triggerAction: 'all'
                    , mode: 'local'
}]
        }
	]
	},
	{
	    layout: 'column',
	    border: false,
	    items: [
        {
            layout: 'form',
            border: false,
            columnWidth: .66,
            items: [
			{
			    xtype: 'textfield',
			    fieldLabel: '<b>�������*</b>',
			    anchor: '95%',
			    name: 'ProductName',
			    id: 'ProductName'
}]
        },
        {
            layout: 'form',
            border: false,
            columnWidth: .34,
            items: [
		        {
		            xtype: 'textfield',
		            fieldLabel: '<b>���*</b>',
		            anchor: '95%',
		            name: 'Specifications',
		            id: 'Specifications'
//			        , displayField: 'DicsName'
//                    , valueField: 'DicsCode'
//                    , editable: false
//                    , store: dsSpecifications
//                    , triggerAction: 'all'
//                    , mode: 'local'
}]
        }
	]
	},
	{
	    layout: 'column',
	    border: false,
	    items: [
		{
		    layout: 'form',
		    border: false,
		    columnWidth: .33,
		    items: [
	        {
	            xtype: 'textfield',
	            fieldLabel: '<b>���㵥��*</b>',
	            anchor: '95%',
	            name: 'SalePrice',
	            id: 'SalePrice'
}]
		},
		{
		    layout: 'form',
		    border: false,
		    columnWidth: .33,
		    items: [
	        {
	            xtype: 'combo',
	            fieldLabel: '<b>������λ*</b>',
	            anchor: '95%',
	            name: 'Unit',
	            id: 'Unit'
		        , displayField: 'UnitName'
                , valueField: 'UnitId'
                , editable: false
                , store: dsUnit
                , triggerAction: 'all'
                , mode: 'local'
}]
		},
		{
		    layout: 'form',
		    border: false,
		    columnWidth: .33,
		    items: [
	        {
	            xtype: 'combo',
	            fieldLabel: '<b>��浥λ*</b>',
	            anchor: '95%',
	            name: 'StoreUnitId',
	            id: 'StoreUnitId'
		        , displayField: 'UnitName'
                , valueField: 'UnitId'
                , editable: false
                , store: dsUnit
                , triggerAction: 'all'
                , mode: 'local'
}]
		}
	    //		,
	    //		{
	    //		    layout: 'form',
	    //		    border: false,
	    //		    columnWidth: .34,
	    //		    items: [
	    //			{
	    //			    xtype: 'textfield',
	    //			    fieldLabel: '��λ������',
	    //			    anchor: '95%',
	    //			    name: 'UnitConvertRate',
	    //			    id: 'UnitConvertRate'
	    //}]
	    //		}
	]
	},
	{
	    layout: 'column',
	    border: false,
	    items: [
		{
		    layout: 'form',
		    border: false,
		    columnWidth: .33,
		    items: [
				{
				    xtype: 'numberfield',
				    fieldLabel: '���������',
				    anchor: '95%',
				    name: 'SalePriceLower',
				    id: 'SalePriceLower'
}]
		},
		{
		    layout: 'form',
		    border: false,
		    columnWidth: .33,
		    items: [
		        {
		            xtype: 'numberfield',
		            fieldLabel: '���������',
		            anchor: '95%',
		            name: 'SalePriceLimit',
		            id: 'SalePriceLimit'
}]
		},
		 {
		     layout: 'form',
		     border: false,
		     columnWidth: .34,
		     items: [
				{
				    xtype: 'textfield',
				    fieldLabel: '������',
				    anchor: '95%',
				    name: 'MnemonicNo',
				    id: 'MnemonicNo'
				}
		]
		 }
	]
	},
	{
	    layout: 'column',
	    border: false,
	    items: [
		{
		    layout: 'form',
		    border: false,
		    columnWidth: .66,
		    items: [
				{
				    xtype: 'textfield',
				    fieldLabel: '<b>��Ӧ��*</b>',
				    anchor: '95%',
				    name: 'Supplier',
				    id: 'Supplier'
				},
		        {
		            xtype: 'hidden',
		            fieldLabel: '��Ӧ��ID',
		            name: 'haddenSupplier',
		            id: 'haddenSupplier'
		        }
		]
		},
		{
		    layout: 'form',
		    border: false,
		    columnWidth: .34,
		    items: [
				{
				    xtype: 'combo',
				    fieldLabel: '<b>����*</b>',
				    anchor: '95%',
				    name: 'Origin',
				    id: 'Origin'
			        , displayField: 'DicsName'
                    , valueField: 'DicsCode'
                    , editable: false
                    , store: dsOrigin
                    , triggerAction: 'all'
                    , mode: 'local'
				}
		]
		}
	]
	},
	{
	    layout: 'column',
	    border: false,
	    items: [
		{
		    layout: 'form',
		    border: false,
		    columnWidth: .33,
		    items: [
				{
				    xtype: 'textfield',
				    fieldLabel: '�������',
				    anchor: '95%',
				    name: 'AliasNo',
				    id: 'AliasNo'
				}
		]
		},
		{
		    layout: 'form',
		    border: false,
		    columnWidth: .33,
		    items: [
				{
				    xtype: 'textfield',
				    fieldLabel: '�������',
				    anchor: '95%',
				    name: 'AliasName',
				    id: 'AliasName'
}]
		},
		{
		    layout: 'form',
		    border: false,
		    columnWidth: .33,
		    items: [
		    {
		        xtype: 'checkbox',
		        fieldLabel: '�Ƿ�ƻ���Ʒ',
		        anchor: '95%',
		        name: 'IsPlan',
		        id: 'IsPlan'
}]
		    }
	]
	},
	{
	    layout: 'column',
	    border: false,
	    items: [
		{
		    layout: 'form',
		    border: false,
		    columnWidth: .33,
		    items: [
				{
				    xtype: 'textfield',
				    fieldLabel: '�ֻ����ű���',
				    anchor: '95%',
				    name: 'MobileNo',
				    id: 'MobileNo'
				}
		]
		},
		{
		    layout: 'form',
		    border: false,
		    columnWidth: .33,
		    items: [
				{
				    xtype: 'textfield',
				    fieldLabel: '��������',
				    anchor: '95%',
				    name: 'SpeechNo',
				    id: 'SpeechNo'
				}
		]
		},
		{
		    layout: 'form',
		    border: false,
		    columnWidth: .34,
		    items: [
				{
				    xtype: 'textfield',
				    fieldLabel: '��������',
				    anchor: '95%',
				    name: 'NetPurchasesNo',
				    id: 'NetPurchasesNo'
				}
		]
		}
	]
	},
	{
	    layout: 'column',
	    border: false,
	    items: [
		{
		    layout: 'form',
		    border: false,
		    columnWidth: .33,
		    items: [
				{
				    xtype: 'textfield',
				    fieldLabel: '������',
				    anchor: '95%',
				    name: 'LogisticsNo',
				    id: 'LogisticsNo'
				}
		]
		},
		{
		    layout: 'form',
		    border: false,
		    columnWidth: .33,
		    items: [
				{
				    xtype: 'textfield',
				    fieldLabel: '������',
				    anchor: '95%',
				    name: 'BarCode',
				    id: 'BarCode'
				}
		]
		},
		{
		    layout: 'form',
		    border: false,
		    columnWidth: .34,
		    items: [
				{
				    xtype: 'textfield',
				    fieldLabel: '��α��',
				    anchor: '95%',
				    name: 'SecurityCode',
				    id: 'SecurityCode'
				}
		]
		}
	]
	},
	{
	    layout: 'column',
	    border: false,
	    items: [
		{
		    layout: 'form',
		    border: false,
		    columnWidth: .33,
		    items: [
				{
				    xtype: 'textfield',
				    fieldLabel: '<b>˰��*</b>',
				    anchor: '95%',
				    name: 'TaxRate',
				    id: 'TaxRate'
				}
		]
		},
		{
		    layout: 'form',
		    border: false,
		    columnWidth: .33,
		    items: [
				{
				    xtype: 'textfield',
				    fieldLabel: '˰��',
				    anchor: '95%',
				    name: 'Tax',
				    id: 'Tax'
				}
		]
		},
		{
		    layout: 'form',
		    border: false,
		    columnWidth: .34,
		    items: [
				{
				    xtype: 'combo',
				    fieldLabel: '�Ƽ۷���',
				    anchor: '95%',
				    name: 'AliasPrice',
				    id: 'AliasPrice'
			        , displayField: 'DicsName'
                    , valueField: 'DicsCode'
                    , editable: false
                    , store: dsAliasPrice
                    , triggerAction: 'all'
                    , mode: 'local'
				}
		]
		}
	]
	},
        //	{
        //		layout:'column',
        //		border: false,
        //		items: [
        //		{
        //			layout:'form',
        //			border: false,
        //			columnWidth:.33,
        //			items: [
        //				{
        //			        xtype:'textfield',
        //			        fieldLabel:'��˰����',
        //			        anchor:'90%',
        //			        name:'TaxWhPrice',
        //			        id:'TaxWhPrice'
        //		        }
        //		]
        //		},
        //		{
        //			layout:'form',
        //			border: false,
        //			columnWidth:.33,
        //			items: [
        //				{
        //			        xtype:'textfield',
        //			        fieldLabel:'����˰��',
        //			        anchor:'90%',
        //			        name:'SalesTax',
        //			        id:'SalesTax'
        //		        }]
        //		},
        //		 {
        //		    layout:'form',
        //	        border: false,
        //	        columnWidth:.34
        //		 }
        //	]},
        //	{
        //		layout:'column',
        //		border: false,
        //		items: [
        //		{
        //			layout:'form',
        //			border: false,
        //			columnWidth:.33,
        //			items: [
        //				{
        //			        xtype:'textfield',
        //			        fieldLabel:'�����˷�',
        //			        anchor:'90%',
        //			        name:'AutoFreight',
        //			        id:'AutoFreight'
        //		        }
        //		]
        //		},
        //		{
        //			layout:'form',
        //			border: false,
        //			columnWidth:.33,
        //			items: [
        //				{
        //			        xtype:'textfield',
        //			        fieldLabel:'��ʻԱ�˷�',
        //			        anchor:'90%',
        //			        name:'DriverFreight',
        //			        id:'DriverFreight'
        //		        }]
        //		},
        //		 {
        //		    layout:'form',
        //	        border: false,
        //	        columnWidth:.34
        //		 }
        //	]},
        //	{
        //		layout:'column',
        //		border: false,
        //		items: [
        //		{
        //			layout:'form',
        //			border: false,
        //			columnWidth:.33,
        //			items: [
        //				{
        //			        xtype:'textfield',
        //			        fieldLabel:'���˷�',
        //			        anchor:'90%',
        //			        name:'TrainFreight',
        //			        id:'TrainFreight'
        //		        }
        //		]
        //		},
        //		{
        //			layout:'form',
        //			border: false,
        //			columnWidth:.33,
        //			items: [
        //				{
        //			        xtype:'textfield',
        //			        fieldLabel:'���˷�',
        //			        anchor:'90%',
        //			        name:'ShipFreight',
        //			        id:'ShipFreight'
        //		        }
        //		]
        //		},
        //		{
        //			layout:'form',
        //			border: false,
        //			columnWidth:.34,
        //			items: [
        //				{
        //			        xtype:'textfield',
        //			        fieldLabel:'�����˷�',
        //			        anchor:'90%',
        //			        name:'OtherFeight',
        //			        id:'OtherFeight'
        //		        }
        //		]
        //		}
        //	]},
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
				    xtype: 'textarea',
				    fieldLabel: '��ע',
				    anchor: '95%',
				    name: 'Remark',
				    id: 'Remark',
				    height: 60
				}
		]
		}
	]
}
]
    });
    /*------FormPanle�ĺ������� End---------------*/


    /*------��ʼ��ѯform�ĺ��� start---------------*/

    var MnemonicNoPanel = new Ext.form.TextField({
        style: 'margin-left:0px',
        cls: 'key',
        xtype: 'textfield',
        fieldLabel: '������',
        anchor: '70%',
        listeners: { specialkey: function(f, e) { if (e.getKey() == e.ENTER) { Ext.getCmp('ProductName').focus(); } } }

    });


    var ProductNamePanel = new Ext.form.TextField({
        style: 'margin-left:0px',
        cls: 'key',
        xtype: 'textfield',
        fieldLabel: '�������',
        anchor: '70%',
        listeners: { specialkey: function(f, e) { if (e.getKey() == e.ENTER) { Ext.getCmp('searchebtnId').focus(); } } }
    });

    //    var serchform = new Ext.FormPanel({
    //        renderTo: 'searchForm',
    //        labelAlign: 'left',
    //        layout: 'fit',
    //        buttonAlign: 'right',
    //        bodyStyle: 'padding:5px',
    //        frame: true,
    //        labelWidth: 55,
    //        items: [{
    //            layout: 'column',   //�����Ԫ��Ϊ����Ϊ�в��ַ�ʽ
    //            border: false,
    //            items: [{
    //                columnWidth: .4,  //����ռ�õĿ�ȣ���ʶΪ20��
    //                layout: 'form',
    //                border: false,
    //                items: [
    //                        MnemonicNoPanel
    //                    ]
    //            }, {
    //                columnWidth: .4,
    //                layout: 'form',
    //                border: false,
    //                items: [
    //                        ProductNamePanel
    //                        ]
    //            }, {
    //                columnWidth: .2,
    //                layout: 'form',
    //                border: false,
    //                items: [{ cls: 'key',
    //                    xtype: 'button',
    //                    text: '��ѯ',
    //                    id: 'searchebtnId',
    //                    anchor: '50%',
    //                    handler: function() {

    //                        var MnemonicNo = MnemonicNoPanel.getValue();
    //                        var ProductName = ProductNamePanel.getValue();

    //                        productGridData.baseParams.MnemonicNo = MnemonicNo;
    //                        productGridData.baseParams.ProductName = ProductName;
    //                        productGridData.load({
    //                            params: {
    //                                start: 0,
    //                                limit: defaultPageSize
    //                            }
    //                        });
    //                    }
    //}]
    //}]
    //}]
    //                });


    /*------��ʼ��ѯform�ĺ��� end---------------*/


    /*------��ʼ��ȡ�������ݵĺ��� start---------------*/
    function saveFormValue() {
        var IsPlan = 0;
        if (Ext.get("IsPlan").dom.checked)
            IsPlan = 1;

        if (operType == 'add')
            suffix = 'saveAddProductInfo';
        else if (operType == 'edit')
            suffix = 'saveModifyProductInfo';

        Ext.MessageBox.wait("�������ڱ��棬���Ժ󡭡�");
        Ext.Ajax.request({
            url: 'frmBaProduct.aspx?method=' + suffix,
            method: 'POST',
            params: {
                ProductId: Ext.getCmp('ProductId').getValue(),
                ProductNo: Ext.getCmp('ProductNo').getValue(),
                ProductName: Ext.getCmp('ProductName').getValue(),
                Specifications: Ext.getCmp('Specifications').getValue(),
                IsPlan: IsPlan,
                ProductType: Ext.getCmp('ProductType').getValue(),
                Unit: Ext.getCmp('Unit').getValue(),
                SalePrice: Ext.getCmp('SalePrice').getValue(),
                StoreUnitId: Ext.getCmp('StoreUnitId').getValue(),
                SalePriceLower: Ext.getCmp('SalePriceLower').getValue(),
                SalePriceLimit: Ext.getCmp('SalePriceLimit').getValue(),
                MnemonicNo: Ext.getCmp('MnemonicNo').getValue(),
                //Supplier:Ext.getCmp('Supplier').getValue(),
                Supplier: Ext.getCmp('haddenSupplier').getValue(), //ȡid
                ClassId: Ext.getCmp('haddenClassType').getValue(), //ȡid
                Origin: Ext.getCmp('Origin').getValue(),
                AliasNo: Ext.getCmp('AliasNo').getValue(),
                AliasName: Ext.getCmp('AliasName').getValue(),
                MobileNo: Ext.getCmp('MobileNo').getValue(),
                SpeechNo: Ext.getCmp('SpeechNo').getValue(),
                NetPurchasesNo: Ext.getCmp('NetPurchasesNo').getValue(),
                LogisticsNo: Ext.getCmp('LogisticsNo').getValue(),
                BarCode: Ext.getCmp('BarCode').getValue(),
                SecurityCode: Ext.getCmp('SecurityCode').getValue(),
                TaxRate: Ext.getCmp('TaxRate').getValue(),
                Tax: Ext.getCmp('Tax').getValue(),
                AliasPrice: Ext.getCmp('AliasPrice').getValue(),
                //			TaxWhPrice:Ext.getCmp('TaxWhPrice').getValue(),
                SalesTax: Ext.getCmp('TaxRate').getValue(),
                //			AutoFreight:Ext.getCmp('AutoFreight').getValue(),
                //			DriverFreight:Ext.getCmp('DriverFreight').getValue(),
                //			TrainFreight:Ext.getCmp('TrainFreight').getValue(),
                //			ShipFreight:Ext.getCmp('ShipFreight').getValue(),
                //			OtherFeight:Ext.getCmp('OtherFeight').getValue(),
                Remark: Ext.getCmp('Remark').getValue(),
                ProductVer: Ext.getCmp('ProductVer').getValue(),
                Brand: Ext.getCmp('Brand').getValue()
            },
            success: function(resp, opts) {
                if (checkExtMessage(resp)) {
                    Ext.MessageBox.hide();
                    Ext.Msg.alert("��ʾ", "����ɹ�");
                    productGridData.reload();
                    uploadUserWindow.hide();
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
    function setFormValue() {
        var sm = productGrid.getSelectionModel();
        var selectData = sm.getSelected();
        if (selectData == null) {
            Ext.Msg.alert("��ʾ", "��ѡ��һ�У�");
        }
        else {
            //����ʾ����
            openWindowShow();

            //������Ʋ������޸�
            Ext.getCmp('ProductNo').setDisabled(true);
            //Ext.getCmp('ProductName').setDisabled(true);
            //Ext.getCmp('ClassType').setDisabled(true);

            //�ȸ���codeȡ�����ݣ���д��form�У�Ҳ���Խ�grid���record����form
            Ext.Ajax.request({
                url: 'frmBaProduct.aspx?method=getModifyProductInfo',
                params: {
                    ProductId: selectData.data['ProductId']
                },
                success: function(resp, opts) {
                    //alert(resp.responseText);
                    var data = Ext.util.JSON.decode(resp.responseText);
                    Ext.getCmp("ProductId").setValue(data.ProductId);
                    Ext.getCmp("ProductNo").setValue(data.ProductNo);
                    Ext.getCmp("ProductName").setValue(data.ProductName);

                    if (data.IsPlan == 1) {
                        Ext.get("IsPlan").dom.checked = true;
                    }

                    //�������ʼ��������setValue������ʾdisplayText
                    Ext.getCmp("Unit").setValue(data.Unit);
                    Ext.getCmp("Specifications").setValue(data.Specifications);
                    Ext.getCmp("ProductType").setValue(data.ProductType);
                    Ext.getCmp("Origin").setValue(data.Origin);
                    Ext.getCmp("AliasPrice").setValue(data.AliasPrice);
                    Ext.getCmp("SalePrice").setValue(data.SalePrice);
//                    Ext.getCmp("UnitConvertRate").setValue(data.UnitConvertRate);
                    Ext.getCmp("SalePriceLower").setValue(data.SalePriceLower);
                    Ext.getCmp("SalePriceLimit").setValue(data.SalePriceLimit);
                    Ext.getCmp("MnemonicNo").setValue(data.MnemonicNo);
                    Ext.getCmp("StoreUnitId").setValue(data.StoreUnitId);
                    //����������Ҫ�Ӻ�̨ȥȡ
                    var strSupplierName = "";
                    dsSupplier.on('load', function(store, records) {
                        strSupplierName = records[0].get('ChineseName');
                        //�������첽�ģ������ڼ��ص����ݺ��ٸ�ֵ
                        //alert(strSupplierName);
                        Ext.getCmp("Supplier").setValue(strSupplierName); //name
                        Ext.getCmp('haddenSupplier').setValue(records[0].CustomerId); //id
                    });
                    dsSupplier.load({
                        params: {
                            SupplierId: data.Supplier
                        }
                    });
                    var strClassName = "";
                    dsSmallProduct.on('load', function(store, records) {
                        strClassName = records[0].get('ClassName');
                        //�������첽�ģ������ڼ��ص����ݺ��ٸ�ֵ
                        //alert(strClassName);
                        Ext.getCmp("ClassType").setValue(strClassName); //name
                        Ext.getCmp('haddenClassType').setValue(records[0].ClassId); //id
                    });
                    dsSmallProduct.load({
                        params: {
                            limit: 1,
                            start: 0,
                            ClassId: data.ClassId
                        }
                    });
                    Ext.getCmp("haddenSupplier").setValue(data.Supplier); //ID   

                    Ext.getCmp("AliasNo").setValue(data.AliasNo);
                    Ext.getCmp("AliasName").setValue(data.AliasName);
                    Ext.getCmp("MobileNo").setValue(data.MobileNo);
                    Ext.getCmp("SpeechNo").setValue(data.SpeechNo);
                    Ext.getCmp("NetPurchasesNo").setValue(data.NetPurchasesNo);
                    Ext.getCmp("LogisticsNo").setValue(data.LogisticsNo);
                    Ext.getCmp("BarCode").setValue(data.BarCode);
                    Ext.getCmp("SecurityCode").setValue(data.SecurityCode);
                    Ext.getCmp("TaxRate").setValue(data.TaxRate);
                    Ext.getCmp("Tax").setValue(data.Tax);
                    //		    Ext.getCmp("TaxWhPrice").setValue(data.TaxWhPrice);
                    //		    Ext.getCmp("SalesTax").setValue(data.SalesTax);
                    //		    Ext.getCmp("AutoFreight").setValue(data.AutoFreight);
                    //		    Ext.getCmp("DriverFreight").setValue(data.DriverFreight);
                    //		    Ext.getCmp("TrainFreight").setValue(data.TrainFreight);
                    //		    Ext.getCmp("ShipFreight").setValue(data.ShipFreight);
                    //		    Ext.getCmp("OtherFeight").setValue(data.OtherFeight);
                    Ext.getCmp("Remark").setValue(data.Remark);
                    Ext.getCmp("ProductVer").setValue(data.ProductVer) + 1; //����1
                    Ext.getCmp("Brand").setValue(data.Brand);
                    //Ext.getCmp("CreateDate").setValue(data.CreateDate);
                    //Ext.getCmp("UpdateDate").setValue(data.UpdateDate);
                    //Ext.getCmp("OperId").setValue(data.OperId);
                    //Ext.getCmp("OrgId").setValue(data.OrgId);
                },
                failure: function(resp, opts) {
                    Ext.Msg.alert("��ʾ", "��ȡ��Ʒ��Ϣʧ��");
                }
            });
        }
    }
    /*------�������ý������ݵĺ��� End---------------*/

    /*------��ʼ��ȡ���ݵĺ��� start---------------*/
    var productGridData = new Ext.data.Store
({
    url: 'frmBaProduct.aspx?method=getProductInfoList',
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
	    name: 'StoreUnitId'
	},
	{
	    name: 'UnitText'
	},
	{
	    name: 'SalePrice', type: 'float'
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
    sortData: function(f, direction) {
        var tempSort = Ext.util.JSON.encode(productGridData.sortInfo);
        if (sortInfor != tempSort) {
            sortInfor = tempSort;
            productGridData.baseParams.SortInfo = sortInfor;
            productGridData.load({ params: { limit: defaultPageSize, start: 0} });
        }
    },
    listeners:
	{
	    scope: this,
	    load: function() {
	    }
	}
});

    var sortInfor = "";
    /*------��ȡ���ݵĺ��� ���� End---------------*/

    /*------WindowForm ���ÿ�ʼ------------------*/
    if (typeof (uploadUserWindow) == "undefined") {//�������2��windows����
        uploadUserWindow = new Ext.Window({
            id: 'userformwindow',
            title: "������Ʒ"
                , iconCls: 'upload-win'
                , width: 700
                , height: 430
                , layout: 'fit'
                , plain: true
                , modal: true
            // , x: 50
            // , y: 50
                , constrain: true
                , resizable: false
                , closeAction: 'hide'
                , autoDestroy: true
                , items: productForm
                , buttons: [{
                    id: 'savebuttonid'
                    , text: "����"
                    , handler: function() {
                        saveUserData();
                        //alert(Ext.getCmp('Supplier').getValue());
                        //alert(Ext.getCmp('haddenSupplier').getValue());
                    }
                    , scope: this
                },
                {
                    text: "ȡ��"
                    , handler: function() {
                        uploadUserWindow.hide();
                    }
                    , scope: this
}]
        });
    }

    uploadUserWindow.addListener("hide", function() {
        Ext.getCmp("savebuttonid").show();
        productForm.getForm().reset();
    });

    function saveUserData() {
        saveFormValue();
    }
    /*------WindowForm ���ÿ�ʼ------------------*/


    var defaultPageSize = 10;
    var toolBar = new Ext.PagingToolbar({
        pageSize: 10,
        store: productGridData,
        displayMsg: '��ʾ��{0}����{1}����¼,��{2}��',
        emptyMsy: 'û�м�¼',
        displayInfo: true
    });
    var pageSizestore = new Ext.data.SimpleStore({
        fields: ['pageSize'],
        data: [[10], [20], [30]]
    });
    var combo = new Ext.form.ComboBox({
        regex: /^\d*$/,
        store: pageSizestore,
        displayField: 'pageSize',
        typeAhead: true,
        mode: 'local',
        emptyText: '����ÿҳ��¼��',
        triggerAction: 'all',
        selectOnFocus: true,
        width: 135
    });
    toolBar.addField(combo);

    combo.on("change", function(c, value) {
        toolBar.pageSize = value;
        defaultPageSize = toolBar.pageSize;
    }, toolBar);
    combo.on("select", function(c, record) {
        toolBar.pageSize = parseInt(record.get("pageSize"));
        defaultPageSize = toolBar.pageSize;
        toolBar.doLoad(0);
    }, toolBar);
    /*------��ʼDataGrid�ĺ��� start---------------*/

    var sm = new Ext.grid.CheckboxSelectionModel({
        singleSelect: true
    });
    var productGrid = new Ext.grid.GridPanel({
        el: 'productGrid',
        width: '100%',
        height: '100%',
        //autoWidth:true,
        //autoHeight:true,
        autoScroll: true,
        layout: 'fit',
        id: '',
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
		    sortable: true,
		    width: 100
		},
		{
		    header: '�������',
		    dataIndex: 'ProductName',
		    id: 'ProductName',
		    sortable: true,
		    width: 170
		},
		{
		    header: '������',
		    dataIndex: 'MnemonicNo',
		    id: 'MnemonicNo',
		    sortable: true,
		    width: 75
		},
		{
		    header: '����',
		    dataIndex: 'OriginText',
		    id: 'OriginText',
		    sortable: true,
		    width: 80
		},
		{
		    header: '��Ӧ��',
		    dataIndex: 'SupplierText',
		    id: 'SupplierText',
		    sortable: true,
		    width: 150
		},
		{
		    header: '���',
		    dataIndex: 'SpecificationsText',
		    id: 'SpecificationsText',
		    sortable: true,
		    width: 40
		},
		{
		    header: '������',
		    dataIndex: 'UnitConvertRate',
		    id: 'UnitConvertRate',
		    sortable: true,
		    width: 50
		},
		{
		    header: '������λ',
		    dataIndex: 'UnitText',
		    id: 'UnitText',
		    sortable: true,
		    width: 60
		},
		{
		    header: '���㵥��',
		    dataIndex: 'SalePrice',
		    id: 'SalePrice',
		    sortable: true,
		    width: 60
		}
		]),
        bbar: toolBar,
        viewConfig: {
            columnsText: '��ʾ����',
            scrollOffset: 20,
            sortAscText: '����',
            sortDescText: '����',
            forceFit: false
        },
        height: 340,
        closeAction: 'hide',
        stripeRows: true,
        loadMask: true//,
        //autoExpandColumn: 2
    });

    toolBar.addField(createPrintButton(productGridData, productGrid, ''));
    printTitle = "�����Ϣ";
    productGrid.render();
    /*------DataGrid�ĺ������� End---------------*/

    createSearch(productGrid, productGridData, "searchForm12");
    searchForm.el = "searchForm12";
    searchForm.render();

    var addRow = new fieldRowPattern({
        id: 'ProductType',
        name: '������',
        dataType: 'select'
    });
    fieldStore.add(addRow);

    txtFieldValue.on("focus", selectProductType);

    function selectProductType() {
        currentSelect = txtFieldValue;
        selectShow(cmbField.getValue());
        //        if (cmbField.getValue() != "ProductType")
        //            return;
        //        if (selectProductForm == null) {
        //            parentUrl = "../../CRM/product/frmBaProductClass.aspx?select=true&method=getbaproducttree";
        //            showProductForm("", "", "", true);
        //            selectProductForm.buttons[0].on("click", selectProductOk);
        //        }
        //        else {
        //            showProductForm("", "", "", true);
        //        }
    }
    var selectedProductIds = "";
    function selectProductOk() {
        var selectProductNames = "";
        selectedProductIds = "";
        var selectNodes = selectProductTree.getChecked();
        for (var i = 0; i < selectNodes.length; i++) {
            if (selectProductNames != "") {
                selectProductNames += ",";
                selectedProductIds += ",";
            }
            selectProductNames += selectNodes[i].text;
            selectedProductIds += selectNodes[i].id + '!' + selectNodes[i].text + '!' + selectNodes[i].attributes.CustomerColumn;
        }
        currentSelect.setValue(selectProductNames);
    }

    this.selectShow = function(columnName) {
        switch (columnName) {
            case 'ProductType':
                if (selectProductForm == null) {
                    parentUrl = "../../CRM/product/frmBaProductClass.aspx?select=true&method=getbaproducttree";
                    showProductForm("", "", "", true);
                    selectProductForm.buttons[0].on("click", selectProductOk);
                }
                else {
                    showProductForm("", "", "", true);
                }
                break;
        }
    };
    this.getSelectedValue = function() {
        return selectedProductIds;
    }
})
            
            
            function getCmbStore(columnName)
            {
                
            }
</script>
</html>
