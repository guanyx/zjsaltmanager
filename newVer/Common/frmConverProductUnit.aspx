<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmConverProductUnit.aspx.cs" Inherits="Common_frmConverProductUnit" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>无标题页</title>
    <link rel="stylesheet" type="text/css" href="../../ext3/resources/css/ext-all.css" />
    <script type="text/javascript" src="../../ext3/adapter/ext/ext-base.js"></script>
    <script type="text/javascript" src="../../ext3/ext-all.js"></script>  
</head>
<script>
Ext.onReady(function() {

//定义产品下拉框异步调用方法
            var dsProducts;
            if (dsProducts == null) {
                dsProducts = new Ext.data.Store({
                    url: '../Ba/product/frmBaSaleProduct.aspx?method=getProducts',
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
                            { name: 'SpecificationsText', mapping: 'SpecificationsText' }
                        ])
                });
            }
            
            // 定义下拉框异步返回显示模板
        var resultTpl = new Ext.XTemplate(  
            '<tpl for="."><div id="searchdivid" class="search-item">',  
                '<h3><span>编号:{ProductNo}&nbsp;  名称:{ProductName}</span></h3>',
            '</div></tpl>'  
        );
        
        
            var productFilterCombo = null;
            function createProductFilterCombo() {
                productFilterCombo = new Ext.form.ComboBox({
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
            
            function setProducrAttributes(record) {

                dsProductUnits.baseParams.ProductId = record.data.ProductId;
                                    dsProductUnits.load();
                Ext.getCmp('ProductName').setValue(record.data.ProductName);
                Ext.getCmp('ProductId').setValue(record.data.ProductId);
                
                Ext.getCmp("UnitId").setValue(record.data.Unit);
                Ext.getCmp("ConvertUnitId").setValue(record.data.Unit);
                beforeEdit();

            }
//            
            //定义下拉框异步调用方法,当前客户可订商品列表
            var dsProductUnits = new Ext.data.Store({
                url: 'frmConverProductUnit.aspx?method=getProductUnits',
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
                        
                        combo = Ext.getCmp('ConvertUnitId');
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
            
            
            
var saleForm = new Ext.form.FormPanel({
                frame: true,
                title: '商品单位转换',
                renderTo: 'ConvertUnitDiv',
                items: [
                {
    xtype: 'hidden',
    columnWidth: 1,
    anchor: '90%',
    name: 'ProductId',
    id: 'ProductId'
},
{
    xtype: 'textfield',
    fieldLabel: '产品名称',
    columnWidth: 1,
    anchor: '90%',
    name: 'ProductName',
    id: 'ProductName'
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
    fieldLabel: '单位',
    selectOnFocus: true,
    anchor: '90%'
},{
    xtype: 'textfield',
    fieldLabel: '数量',
    columnWidth: 1,
    anchor: '90%',
    name: 'ProductQty',
    id: 'ProductQty'
},{
    xtype: 'combo',
    store: dsProductUnits, //dsWareHouse,
    valueField: 'UnitId',
    displayField: 'UnitName',
    mode: 'local',
    forceSelection: true,
    editable: false,
    name: 'ConvertUnitId',
    id: 'ConvertUnitId',
    emptyValue: '',
    triggerAction: 'all',
    fieldLabel: '转换后单位',
    selectOnFocus: true,
    anchor: '90%'
},{
    xtype: 'textfield',
    fieldLabel: '数量',
    columnWidth: 1,
    anchor: '90%',
    name: 'ConvertUnit',
    id: 'ConvertUnit'
}
]
});


function getConvertData()
{
     Ext.Ajax.request({
		                        url:'frmConverProductUnit.aspx?method=getConvertData',
		                        params:{
			                        ProductId:Ext.getCmp("ProductId").getValue(),
			                        UnitId:Ext.getCmp("UnitId").getValue(),
			                        ProductQty:Ext.getCmp("ProductQty").getValue(),
			                        ConvertUnit:Ext.getCmp("ConvertUnitId").getValue()
		                        },
	                        success: function(resp,opts){
	                                var resu = Ext.decode(resp.responseText);
	                                Ext.getCmp("ConvertUnit").setValue(resu.errorinfo);
                                }
		                  });         
}

createProductFilterCombo();
Ext.getCmp("ConvertUnit").on("focus",getConvertData);
})
</script>
<body>
    <div id="ConvertUnitDiv">
    
    </div>
</body>
</html>
