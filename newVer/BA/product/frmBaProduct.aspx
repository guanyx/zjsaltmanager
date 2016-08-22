 <%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmBaProduct.aspx.cs" Inherits="CRM_product_frmProduct" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head >
    <title>商品维护</title>
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
    /*--------下拉框定义 start ---------------*/
    var dsSupplier; //供应商数据源
    var dsSmallProduct; //小类下拉框

    /*----------下拉框定义 end --------------*/


    /*------实现toolbar的函数 start---------------*/
    var Toolbar = new Ext.Toolbar({
        renderTo: "toolbar",
        items: [{
            text: "新增",
            icon: "../../Theme/1/images/extjs/customer/add16.gif",
            handler: function() {
                uploadUserWindow.setTitle("新增存货信息");
                operType = 'add';
                openWindowShow();
            }
        }, '-', {
            text: "编辑",
            icon: "../../Theme/1/images/extjs/customer/edit16.gif",
            handler: function() {
                operType = 'edit';
                editProdctInfo();
            }
        }, '-', {
            text: "删除",
            icon: "../../Theme/1/images/extjs/customer/delete16.gif",
            handler: function() {
                deleteProductInfo();
            }
        }, '-', {
            text: "设置单位转换",
            icon: "../../Theme/1/images/extjs/customer/edit16.gif",
            handler: function() {
                setProductUnitWin();
            }
        }, '-', {
            text: "复制单位体系",
            icon: "../../Theme/1/images/extjs/customer/edit16.gif",
            handler: function() {
                //setProductUnitWin();
                setCopyProductUnitWin();
            }
        }, '-', {
            text: "设置价格体系",
            icon: "../../Theme/1/images/extjs/customer/edit16.gif",
            handler: function() {
                setProductPriceWin();
            }
        }, '-', {
            text: "查看",
            icon: "../../Theme/1/images/extjs/customer/delete16.gif",
            handler: function() {
                editProdctInfo();
                Ext.getCmp("savebuttonid").hide();
            }
        }, '-']
    });

    setToolBarVisible(Toolbar);
    /*  修改窗口  */
    function editProdctInfo() {
        uploadUserWindow.setTitle("存货信息维护");
        setFormValue(); //往界面上填值   
    }
    /*  删除操作  */
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
            Ext.Msg.alert("提示", "请选中一行！");
        }
        else {
            //删除前再次提醒是否真的要删除
            Ext.Msg.confirm("提示信息", "是否真的要删除选择的信息吗？", function callBack(id) {
                //判断是否删除数据
                if (id == "yes") {
                    Ext.Ajax.request({
                        url: 'frmBaProduct.aspx?method=deleteProductInfo',
                        params: {
                            ProductId: selectData.data['ProductId']//传入frmSysDicsInfo
                        },
                        success: function(resp, opts) {
                            if (checkExtMessage(resp)) {
                                //var data=Ext.util.JSON.decode(resp.responseText);
                                //Ext.Msg.alert("提示", "删除成功！");
                                productGrid.getStore().reload();
                            }
                        },
                        failure: function(resp, opts) {
                            Ext.Msg.alert("提示", "删除失败！");
                        }
                    });
                }
            });
        }
    }

    /*设置复制商品单位信息*/
    copyProductUnitWin = ExtJsShowWin("设置复制商品单位信息", "#", "copyProductUnit", 700, 500);
    function setCopyProductUnitWin() {

        var sm = productGrid.getSelectionModel();
        var selectData = sm.getSelected();
        if (selectData == null || selectData.length == 0 || selectData.length > 1) {
            Ext.Msg.alert("提示", "请选中需要设置的存货信息！");
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

    /*设置选定产品的单位信息*/
    var productPriceWin = ExtJsShowWin("设置商品单位信息", "#", "productPrice", 700, 500);
    function setProductPriceWin() {

        var sm = productGrid.getSelectionModel();
        var selectData = sm.getSelected();
        if (selectData == null || selectData.length == 0 || selectData.length > 1) {
            Ext.Msg.alert("提示", "请选中需要设置的存货信息！");
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

    /*设置选定产品的单位信息*/
    var productUnitWin = ExtJsShowWin("设置商品单位信息", "#", "productUnit", 600, 450);
    function setProductUnitWin() {

        var sm = productGrid.getSelectionModel();
        var selectData = sm.getSelected();
        if (selectData == null || selectData.length == 0 || selectData.length > 1) {
            Ext.Msg.alert("提示", "请选中需要设置的存货信息！");
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
	    /*---获取编号---*/
	    if(operType == 'add'){
	        //获取编号
            Ext.Ajax.request({
                url: 'frmBaProduct.aspx?method=getProductNo',
                success: function(resp, opts) {
                    var dataNo = Ext.util.JSON.decode(resp.responseText);
                    Ext.getCmp('ProductNo').setValue(dataNo.ProductNo); 
                },
                failure: function(resp, opts) {
                    Ext.Msg.alert("提示", "获取编号失败！");
                }
            });        
        }
        /*----------定义供应商组合框 start -------------*/
        //定义下拉框异步调用方法
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

        /*----------定义供应商组合框 end -------------*/
        /*----------定义小类组合框 start ---------*/
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
        /*----------定义小类组合框 end ---------*/
    }
    /*------结束toolbar的函数 end---------------*/


    /*------实现FormPanle的函数 start---------------*/
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
			        fieldLabel: '存货ID',
			        //columnWidth:1,
			        //anchor:'95%',
			        hidden: true,
			        name: 'ProductId',
			        id: 'ProductId',
			        hiddenLabel: true
			    },
				{
				    xtype: 'textfield',
				    fieldLabel: '<b>存货编号*</b>',
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
	                fieldLabel: '版本',
	                //columnWidth:1,
	                //anchor:'95%',
	                hidden: true,
	                name: 'ProductVer',
	                id: 'ProductVer',
	                hiddenLabel: true
	            },
				{
				    xtype: 'textfield',
				    fieldLabel: '品牌',
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
			    fieldLabel: '<b>采购商品类别*</b>',
			    anchor: '95%',
			    name: 'ClassType',
			    id: 'ClassType'
			},
	        {
	            xtype: 'hidden',
	            fieldLabel: '采购商品类别ID',
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
		            fieldLabel: '<b>存货类别*</b>', //是否商品、是否辅料
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
			    fieldLabel: '<b>存货名称*</b>',
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
		            fieldLabel: '<b>规格*</b>',
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
	            fieldLabel: '<b>结算单价*</b>',
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
	            fieldLabel: '<b>计量单位*</b>',
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
	            fieldLabel: '<b>库存单位*</b>',
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
	    //			    fieldLabel: '单位换算率',
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
				    fieldLabel: '结算价下限',
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
		            fieldLabel: '结算价上限',
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
				    fieldLabel: '助记码',
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
				    fieldLabel: '<b>供应商*</b>',
				    anchor: '95%',
				    name: 'Supplier',
				    id: 'Supplier'
				},
		        {
		            xtype: 'hidden',
		            fieldLabel: '供应商ID',
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
				    fieldLabel: '<b>产地*</b>',
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
				    fieldLabel: '别名编号',
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
				    fieldLabel: '存货别名',
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
		        fieldLabel: '是否计划商品',
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
				    fieldLabel: '手机短信编码',
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
				    fieldLabel: '语音短码',
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
				    fieldLabel: '网购编码',
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
				    fieldLabel: '物流码',
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
				    fieldLabel: '条形码',
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
				    fieldLabel: '防伪码',
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
				    fieldLabel: '<b>税率*</b>',
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
				    fieldLabel: '税金',
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
				    fieldLabel: '计价方法',
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
        //			        fieldLabel:'含税入库价',
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
        //			        fieldLabel:'销售税率',
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
        //			        fieldLabel:'汽车运费',
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
        //			        fieldLabel:'驾驶员运费',
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
        //			        fieldLabel:'火车运费',
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
        //			        fieldLabel:'船运费',
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
        //			        fieldLabel:'其他运费',
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
				    fieldLabel: '备注',
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
    /*------FormPanle的函数结束 End---------------*/


    /*------开始查询form的函数 start---------------*/

    var MnemonicNoPanel = new Ext.form.TextField({
        style: 'margin-left:0px',
        cls: 'key',
        xtype: 'textfield',
        fieldLabel: '助记码',
        anchor: '70%',
        listeners: { specialkey: function(f, e) { if (e.getKey() == e.ENTER) { Ext.getCmp('ProductName').focus(); } } }

    });


    var ProductNamePanel = new Ext.form.TextField({
        style: 'margin-left:0px',
        cls: 'key',
        xtype: 'textfield',
        fieldLabel: '存货名称',
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
    //            layout: 'column',   //定义该元素为布局为列布局方式
    //            border: false,
    //            items: [{
    //                columnWidth: .4,  //该列占用的宽度，标识为20％
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
    //                    text: '查询',
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


    /*------开始查询form的函数 end---------------*/


    /*------开始获取界面数据的函数 start---------------*/
    function saveFormValue() {
        var IsPlan = 0;
        if (Ext.get("IsPlan").dom.checked)
            IsPlan = 1;

        if (operType == 'add')
            suffix = 'saveAddProductInfo';
        else if (operType == 'edit')
            suffix = 'saveModifyProductInfo';

        Ext.MessageBox.wait("数据正在保存，请稍后……");
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
                Supplier: Ext.getCmp('haddenSupplier').getValue(), //取id
                ClassId: Ext.getCmp('haddenClassType').getValue(), //取id
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
                    Ext.Msg.alert("提示", "保存成功");
                    productGridData.reload();
                    uploadUserWindow.hide();
                }
            },
            failure: function(resp, opts) {
                Ext.MessageBox.hide();
                Ext.Msg.alert("提示", "保存失败");
            }
        });
    }
    /*------结束获取界面数据的函数 End---------------*/

    /*------开始界面数据的函数 Start---------------*/
    function setFormValue() {
        var sm = productGrid.getSelectionModel();
        var selectData = sm.getSelected();
        if (selectData == null) {
            Ext.Msg.alert("提示", "请选中一行！");
        }
        else {
            //先显示窗口
            openWindowShow();

            //编号名称不允许修改
            Ext.getCmp('ProductNo').setDisabled(true);
            //Ext.getCmp('ProductName').setDisabled(true);
            //Ext.getCmp('ClassType').setDisabled(true);

            //先跟据code取来数据，填写到form中，也可以将grid里的record放在form
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

                    //下拉框初始化，否则setValue不能显示displayText
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
                    //这里名字需要从后台去取
                    var strSupplierName = "";
                    dsSupplier.on('load', function(store, records) {
                        strSupplierName = records[0].get('ChineseName');
                        //由于是异步的，所以在加载到数据后再赋值
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
                        //由于是异步的，所以在加载到数据后再赋值
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
                    Ext.getCmp("ProductVer").setValue(data.ProductVer) + 1; //自增1
                    Ext.getCmp("Brand").setValue(data.Brand);
                    //Ext.getCmp("CreateDate").setValue(data.CreateDate);
                    //Ext.getCmp("UpdateDate").setValue(data.UpdateDate);
                    //Ext.getCmp("OperId").setValue(data.OperId);
                    //Ext.getCmp("OrgId").setValue(data.OrgId);
                },
                failure: function(resp, opts) {
                    Ext.Msg.alert("提示", "获取商品信息失败");
                }
            });
        }
    }
    /*------结束设置界面数据的函数 End---------------*/

    /*------开始获取数据的函数 start---------------*/
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
    /*------获取数据的函数 结束 End---------------*/

    /*------WindowForm 配置开始------------------*/
    if (typeof (uploadUserWindow) == "undefined") {//解决创建2个windows问题
        uploadUserWindow = new Ext.Window({
            id: 'userformwindow',
            title: "新增商品"
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
                    , text: "保存"
                    , handler: function() {
                        saveUserData();
                        //alert(Ext.getCmp('Supplier').getValue());
                        //alert(Ext.getCmp('haddenSupplier').getValue());
                    }
                    , scope: this
                },
                {
                    text: "取消"
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
    /*------WindowForm 配置开始------------------*/


    var defaultPageSize = 10;
    var toolBar = new Ext.PagingToolbar({
        pageSize: 10,
        store: productGridData,
        displayMsg: '显示第{0}条到{1}条记录,共{2}条',
        emptyMsy: '没有记录',
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
        emptyText: '更改每页记录数',
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
    /*------开始DataGrid的函数 start---------------*/

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
		    sortable: true,
		    width: 100
		},
		{
		    header: '存货名称',
		    dataIndex: 'ProductName',
		    id: 'ProductName',
		    sortable: true,
		    width: 170
		},
		{
		    header: '助记码',
		    dataIndex: 'MnemonicNo',
		    id: 'MnemonicNo',
		    sortable: true,
		    width: 75
		},
		{
		    header: '产地',
		    dataIndex: 'OriginText',
		    id: 'OriginText',
		    sortable: true,
		    width: 80
		},
		{
		    header: '供应商',
		    dataIndex: 'SupplierText',
		    id: 'SupplierText',
		    sortable: true,
		    width: 150
		},
		{
		    header: '规格',
		    dataIndex: 'SpecificationsText',
		    id: 'SpecificationsText',
		    sortable: true,
		    width: 40
		},
		{
		    header: '换算率',
		    dataIndex: 'UnitConvertRate',
		    id: 'UnitConvertRate',
		    sortable: true,
		    width: 50
		},
		{
		    header: '计量单位',
		    dataIndex: 'UnitText',
		    id: 'UnitText',
		    sortable: true,
		    width: 60
		},
		{
		    header: '结算单价',
		    dataIndex: 'SalePrice',
		    id: 'SalePrice',
		    sortable: true,
		    width: 60
		}
		]),
        bbar: toolBar,
        viewConfig: {
            columnsText: '显示的列',
            scrollOffset: 20,
            sortAscText: '升序',
            sortDescText: '降序',
            forceFit: false
        },
        height: 340,
        closeAction: 'hide',
        stripeRows: true,
        loadMask: true//,
        //autoExpandColumn: 2
    });

    toolBar.addField(createPrintButton(productGridData, productGrid, ''));
    printTitle = "存货信息";
    productGrid.render();
    /*------DataGrid的函数结束 End---------------*/

    createSearch(productGrid, productGridData, "searchForm12");
    searchForm.el = "searchForm12";
    searchForm.render();

    var addRow = new fieldRowPattern({
        id: 'ProductType',
        name: '存货类别',
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
