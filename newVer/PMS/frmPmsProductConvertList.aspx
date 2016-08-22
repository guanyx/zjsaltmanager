<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmPmsProductConvertList.aspx.cs" Inherits="PMS_frmPmsProductConvertList" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html>
<head>
<title>产品转换列表</title>
<meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<link rel="stylesheet" type="text/css" href="../ext3/resources/css/ext-all.css" />
<script type="text/javascript" src="../ext3/adapter/ext/ext-base.js"></script>
<script type="text/javascript" src="../ext3/ext-all.js"></script>
<script type="text/javascript" src="../js/operateResp.js"></script>
<script type="text/javascript" src="../ext3/src/locale/ext-lang-zh_CN.js"></script>
</head>
<body>
<div id='toolbar'></div>
<div id='divForm'></div>
<div id='dataGrid'></div>
<%=getComboBoxStore() %>
</body>
<style type="text/css">
.x-item-disabled-ie {
    color:white;cursor:default;opacity:.9;-moz-opacity:.9; -ms-filter:"progid:DXImageTransform.Microsoft.Alpha(Opacity=90)";
}
</style>
<script type="text/javascript">
Ext.BLANK_IMAGE_URL = "../ext3/resources/images/default/s.gif";
Ext.onReady(function() {
    var saveType;
    /*------实现toolbar的函数 start---------------*/
    var Toolbar = new Ext.Toolbar({
        renderTo: "toolbar",
        items: [{
            text: "新增",
            icon: "../Theme/1/images/extjs/customer/add16.gif",
            handler: function() {
                saveType = 'addOrder';
                openAddOrderWin();
            }
        }, '-', {
            text: "编辑",
            icon: "../Theme/1/images/extjs/customer/edit16.gif",
            handler: function() {
                saveType = 'saveOrder';
                modifyOrderWin();
            }
        }, '-', {
            text: "删除",
            icon: "../Theme/1/images/extjs/customer/delete16.gif",
            handler: function() {
                saveType = 'saveOrder';
                deleteOrder();
            }
        }, '-', {
            text: "确认",
            icon: "../Theme/1/images/extjs/customer/edit16.gif",
            handler: function() {
                confirmOrder();
            }
}, '-', {
                text: "打印",
                icon: "../Theme/1/images/extjs/customer/edit16.gif",
                handler: function() {
                    printOrderById();
                }
            }]
        });

function getUrl(imageUrl)
            {
                var index = window.location.href.toLowerCase().indexOf('/pms/');
                var tempUrl = window.location.href.substring(0,index);
                return tempUrl+"/"+imageUrl;
            }
function printOrderById()
{
var sm = pmsstockorderGrid.getSelectionModel();
                //多选
                var selectData = sm.getSelections();                
                var array = new Array(selectData.length);
                var orderIds = "";
                for(var i=0;i<selectData.length;i++)
                {
                    if(orderIds.length>0)
                        orderIds+=",";
                    orderIds += selectData[i].get('OrderId');
                }
                //alert(orderIds);
                //页面提交
                Ext.Ajax.request({
                    url: 'frmPmsProductConvertList.aspx?method=getprintdata',
                    method: 'POST',
                    params: {
                        OrderIds: orderIds
                    },
                   success: function(resp,opts){ 
                       var printData =  resp.responseText;
                       var printControl =  parent.parent.parent.document.getElementById("topFrame").contentWindow.getPrintControl();
                       printControl.Url =getUrl('xml');
                       printControl.MapUrl = printControl.Url+'/'+printStyleXml;//'/salePrint1.xml';
                       printControl.PrintXml = printData;
                       printControl.ColumnName="OrderId";
                       printControl.OnlyData=printOnlyData;
                       printControl.PageWidth=printPageWidth;
                       printControl.PageHeight =printPageHeight ;
                       printControl.Print();
                       
                   },
		           failure: function(resp,opts){  /* Ext.Msg.alert("提示","保存失败"); */    }
                });
                }
        /*------结束toolbar的函数 end---------------*/
        var dsWarehousePosList;
        if (dsWarehousePosList == null) { //防止重复加载
            //alert(Ext.getCmp("WhId").getValue());
            dsWarehousePosList = new Ext.data.Store
        ({
            url: 'frmPmsProductConvertList.aspx?method=getWarehousePosList',
            reader: new Ext.data.JsonReader({
                totalProperty: 'totalProperty',
                root: 'root'
            }, [
                {
                    name: 'WhpId'
                },
                {
                    name: 'WhpName'
                }
            ])
        });
        }

        /*------开始ToolBar事件函数 start---------------*//*-----新增Order实体类窗体函数----*/
        function openAddOrderWin() {
            uploadOrderWindow.show();
        }
        /*-----编辑Order实体类窗体函数----*/
        function modifyOrderWin() {
            var sm = pmsstockorderGrid.getSelectionModel();
            //获取选择的数据信息
            var selectData = sm.getSelected();
            if (selectData == null) {
                Ext.Msg.alert("提示", "请选中需要编辑的信息！");
                return;
            }
            if (selectData.data.BizStatus == "2") {
                Ext.Msg.alert("提示", "该转换记录已经出库，不能进行编辑！");
                return;
            }
            uploadOrderWindow.show();
            setFormValue(selectData);
        }
        /*-----删除Order实体函数----*/
        /*删除信息*/
        function deleteOrder() {
            var sm = pmsstockorderGrid.getSelectionModel();
            //获取选择的数据信息
            var selectData = sm.getSelected();
            //如果没有选择，就提示需要选择数据信息
            if (selectData == null) {
                Ext.Msg.alert("提示", "请选中需要删除的信息！");
                return;
            }
            if (selectData.data.BizStatus == "2") {
                Ext.Msg.alert("提示", "该转换记录已经出库，不能进行删除！");
                return;
            }
            //删除前再次提醒是否真的要删除
            Ext.Msg.confirm("提示信息", "是否真的要删除选择的信息吗？", function callBack(id) {
                //判断是否删除数据
                if (id == "yes") {
                    //页面提交
                    Ext.Ajax.request({
                        url: 'frmPmsProductConvertList.aspx?method=deleteOrder',
                        method: 'POST',
                        params: {
                            OrderId: selectData.data.OrderId
                        },
                        success: function(resp, opts) {
                            dspmsstockorder.reload({
                                params: {start: 0,limit: 10}
                            });
                            Ext.Msg.alert("提示", "数据删除成功");
                        },
                        failure: function(resp, opts) {
                            Ext.Msg.alert("提示", "数据删除失败");
                        }
                    });
                }
            });
        }
        /*确认信息*/
        function confirmOrder() {
            Ext.MessageBox.wait("数据正在保存，请稍候……");
            var sm = pmsstockorderGrid.getSelectionModel();
            //获取选择的数据信息
            var selectData = sm.getSelected();
            //如果没有选择，就提示需要选择数据信息
            if (selectData == null) {
                Ext.MessageBox.hide();
                Ext.Msg.alert("提示", "请选中需要确认提交的信息！");
                return;
            }
            if (selectData.data.BizStatus == "2") {
                Ext.MessageBox.hide();
                Ext.Msg.alert("提示", "该转换记录已经出库，不能进行确认提交！");
                return;
            }
            //删除前再次提醒是否真的要删除
            Ext.Msg.confirm("提示信息", "是否真的要确认提交选择的信息吗？", function callBack(id) {
                //判断是否删除数据
                if (id == "yes") {
                    //页面提交
                    Ext.Ajax.request({
                        url: 'frmPmsProductConvertList.aspx?method=confirmOrder',
                        method: 'POST',
                        params: {
                            OrderId: selectData.data.OrderId
                        },
                        success: function(resp, opts) {
                            Ext.MessageBox.hide();
                            if (checkExtMessage(resp)) {
                                dspmsstockorder.reload({
                                    params: {
                                        start: 0,
                                        limit: 10
                                    }
                                });
                            }
                        },
                        failure: function(resp, opts) {
                            Ext.MessageBox.hide();
                            Ext.Msg.alert("提示", "数据确认提交失败");
                        }
                    });
                }
            });
        }

        /*------实现FormPanle的函数 start---------------*/
        var pmsstockorderform = new Ext.form.FormPanel({
            url: '',
            frame: true,
            title: '',
            items: [
		{
		    xtype: 'hidden',
		    fieldLabel: '订单号',
		    name: 'OrderId',
		    id: 'OrderId',
		    hidden: true,
		    hideLabel: false
		}
, {
    layout: 'column',
    items: [
            {
                layout: 'form',
                columnWidth: .48,
                labelWidth: 55,
                items: [
                {
                    xtype: 'combo',
                    fieldLabel: '仓库',
                    columnWidth: 1,
                    anchor: '98%',
                    name: 'AuxWhId',
                    id: 'AuxWhId',
                    store: dsWarehouseList,
                    displayField: 'WhName',
                    valueField: 'WhId',
                    mode: 'local',
                    triggerAction: 'all',
                    editable: false,
                    listeners: {
                        select: function(combo, record, index) {
                            var curWhId = Ext.getCmp("AuxWhId").getValue();
                            Ext.getCmp('WhpId').setValue('');
                            Ext.getCmp('WhpId').setRawValue('');
                            dsWarehousePosList.load({
                                params: {
                                    WhId: curWhId
                                },
                                callback:function(){
                                    if(dsWarehousePosList.getCount()==1)
                                        Ext.getCmp('WhpId').setValue(dsWarehousePosList.getAt(0).get("WhpId")); 
                                }
                            });
                        }
                    }
                }
                ]
            }, {
                layout: 'form',
                columnWidth: .48,
                labelWidth: 55,
                items: [
                {
                    xtype: 'combo',
                    fieldLabel: '仓位',
                    columnWidth: 1,
                    anchor: '98%',
                    name: 'WhpId',
                    id: 'WhpId',
                    store: dsWarehousePosList,
                    displayField: 'WhpName',
                    valueField: 'WhpId',
                    mode: 'local',
                    triggerAction: 'all',
                    editable: false
                }
            ]
}]
}
, {
    xtype: 'fieldset',
    layout: 'column',
    autoHeight: true,
    title: "转出商品信息",
    items: [
    {
        layout: 'column',
        items: [
        {
            layout: 'form',
            columnWidth: .35,
            labelWidth: 60,
            items: [
            {
                xtype: 'textfield',
                fieldLabel: '商品编码',
                columnWidth: 1,
                anchor: '98%',
                name: 'AuxProductNo',
                id: 'AuxProductNo',
                enableKeyEvents: true,
                initEvents: function() {
                    var keyPress = function(e) {
                        if (e.getKey() == e.ENTER) {
                            var textValue = this.getValue();
                            var index = dsProductList.findBy(
                                function(record, id) {
                                    return record.get('ProductNo') == textValue;
                                }
                            );
                            var record = dsProductList.getAt(index);
                            Ext.getCmp('AuxProductId').setValue(record.data.ProductId)
                            Ext.getCmp('Unit').setValue(record.data.Unit)
                            //获取成本价
                            Ext.Ajax.request({
                                url: 'frmPmsProductConvertList.aspx?method=getWhCostPrice',
                                params: {
                                    ProductId: record.data.ProductId,
                                    WhId: Ext.getCmp("AuxWhId").getValue()
                                },
                                success: function(resp, opts) {
                                    var dataPrice = Ext.util.JSON.decode(resp.responseText);
                                    Ext.getCmp("PProductPrice").setValue(dataPrice.price);
                                },
                                failure: function(resp, opts) {
                                    Ext.Msg.alert("提示", "获取商品信息失败");
                                }
                            });
                        }
                    };
                    this.el.on("keypress", keyPress, this);
                }
            }
	        ]
        }, {
            layout: 'form',
            columnWidth: .65,
            labelWidth: 60,
            items: [
            {
                xtype: 'combo',
                fieldLabel: '商品名称',
                columnWidth: 1,
                anchor: '98%',
                name: 'AuxProductId',
                id: 'AuxProductId',
                store: dsProductList,
                displayField: 'ProductName',
                valueField: 'ProductId',
                triggerAction: 'all',
                typeAhead: true,
                mode: 'local',
                emptyText: '',
                selectOnFocus: false,
                editable: false,
                disabled: true,
    	disabledClass: Ext.isIE ? 'x-item-disabled-ie' : 'x-item-disabled'

            }
	        ]
        }]
        },
			{
			    layout: 'column',
			    items: [
			    {
			        layout: 'form',
			        columnWidth: .263,
			        labelWidth: 60,
			        items: [
                    {
                        xtype: 'numberfield',
                        fieldLabel: '商品数量',
                        columnWidth: 1,
                        anchor: '98%',
                        name: 'Qty',
                        id: 'Qty',
	                    allowBlank: false,
	                    align: 'right',
	                    decimalPrecision:6,
                        value: 0
                    }
			        ]
			    },
			    {
			        layout: 'form',
			        columnWidth: .22,
			        labelWidth: 60,
			        items: [
                    {
                        xtype: 'combo',
                        fieldLabel: '商品单位',
                        labelWidth: 35,
                        anchor: '98%',
                        name: 'Unit',
                        id: 'Unit',
                        store: dsUnitList,
                        displayField: 'UnitName',
                        valueField: 'UnitId',
                        triggerAction: 'all',
                        typeAhead: true,
                        mode: 'local',
                        emptyText: '',
                        selectOnFocus: false,
                        editable: true
                    }
			        ]
                },
			    {
			        layout: 'form',
			        columnWidth: .26,
			        labelWidth: 80,
			        items: [
                    {
                        xtype: 'textfield',
                        fieldLabel: '转出成本价格',
                        labelWidth: 35,
                        anchor: '98%',
                        name: 'PProductPrice',
                        id: 'PProductPrice',
                        style:'text-align:right'
                    }
			        ]
                }]
}]
}
, {
    xtype: 'fieldset',
    layout: 'column',
    autoHeight: true,
    title: "转入商品信息",
    items: [
			{
			    layout: 'column',
			    items: [
            {
                layout: 'form',
                columnWidth: .35,
                labelWidth: 60,
                items: [
                {
                    xtype: 'textfield',
                    fieldLabel: '商品编码',
                    columnWidth: 1,
                    anchor: '98%',
                    name: 'ProductNo',
                    id: 'ProductNo',
                    enableKeyEvents: true,
                    initEvents: function() {
                        var keyPress = function(e) {
                            if (e.getKey() == e.ENTER) {
                                var textValue = this.getValue();
                                var index = dsProductList.findBy(
                                        function(record, id) {
                                            return record.get('ProductNo') == textValue;
                                        }
                                    );
                                var record = dsProductList.getAt(index);
                                Ext.getCmp('ProductId').setValue(record.data.ProductId)
                                Ext.getCmp('PUnit').setValue(record.data.Unit)
                                //获取成本价
                                Ext.Ajax.request({
                                    url: 'frmPmsProductConvertList.aspx?method=getWhCostPrice',
                                    params: {
                                        ProductId: record.data.ProductId,
                                        WhId: Ext.getCmp("AuxWhId").getValue()
                                    },
                                    success: function(resp, opts) {
                                        var dataPrice = Ext.util.JSON.decode(resp.responseText);
                                        Ext.getCmp("ProductPrice").setValue(dataPrice.price);
                                    },
                                    failure: function(resp, opts) {
                                        Ext.Msg.alert("提示", "获取商品信息失败");
                                    }
                                });
                            }
                        };
                        this.el.on("keypress", keyPress, this);
                    }
                }
			    ]
            }, {
                layout: 'form',
                columnWidth: .65,
                labelWidth: 60,
                items: [
                {
                    xtype: 'combo',
                    fieldLabel: '商品名称',
                    columnWidth: 1,
                    anchor: '98%',
                    name: 'ProductId',
                    id: 'ProductId',
                    store: dsProductList,
                    displayField: 'ProductName',
                    valueField: 'ProductId',
                    triggerAction: 'all',
                    typeAhead: true,
                    mode: 'local',
                    emptyText: '',
                    selectOnFocus: false,
                    disabled: true,
		    disabledClass: Ext.isIE ? 'x-item-disabled-ie' : 'x-item-disabled'

                }
			    ]
}]
			},
			{
			    layout: 'column',
			    items: [
			    {
			        layout: 'form',
			        columnWidth: .263,
			        labelWidth: 60,
			        items: [
                    {
                        xtype: 'numberfield',
                        fieldLabel: '商品数量',
                        columnWidth: 1,
                        anchor: '98%',
                        name: 'PQty',
                        id: 'PQty',
	                    allowBlank: false,
	                    align: 'right',
	                    decimalPrecision:6,
                        value: 0
                    }
			        ]
			    },
			    {
			        layout: 'form',
			        columnWidth: .22,
			        labelWidth: 60,
			        items: [
                    {
                        xtype: 'combo',
                        fieldLabel: '商品单位',
                        labelWidth: 35,
                        anchor: '98%',
                        name: 'PUnit',
                        id: 'PUnit',
                        store: dsUnitList,
                        displayField: 'UnitName',
                        valueField: 'UnitId',
                        triggerAction: 'all',
                        typeAhead: true,
                        mode: 'local',
                        emptyText: '',
                        selectOnFocus: false,
                        editable: true
                    }
			        ]
			    },
			    {
			        layout: 'form',
			        columnWidth: .26,
			        labelWidth: 80,
			        items: [
                    {
                        xtype: 'textfield',
                        fieldLabel: '转入成本价格',
                        labelWidth: 35,
                        anchor: '98%',
                        name: 'ProductPrice',
                        id: 'ProductPrice',
                        style:'text-align:right'
                    }
			        ]
                }
			]
            }]
            }
            , {
                xtype: 'textarea',
                fieldLabel: '备注',
                columnWidth: .5,
                height: 40,
			    labelWidth: 60,
                anchor: '98%',
                name: 'Remark',
                id: 'Remark'
            }
            ]
        });
        /*------FormPanle的函数结束 End---------------*/

        /*------开始界面数据的窗体 Start---------------*/
        if (typeof (uploadOrderWindow) == "undefined") {//解决创建2个windows问题
            uploadOrderWindow = new Ext.Window({
                id: 'Orderformwindow',
                title: ''
		, iconCls: 'upload-win'
		, width: 600
		, height: 350
		, layout: 'fit'
		, plain: true
		, modal: true
		, constrain: true
		, resizable: false
		, closeAction: 'hide'
		, autoDestroy: true
		, items: pmsstockorderform
		, buttons: [{
		    text: "保存"
			, handler: function() {
			    saveUserData();
			}
			, scope: this
		},
		{
		    text: "取消"
			, handler: function() {
			    uploadOrderWindow.hide();
			}
			, scope: this
}]
            });
        }
        uploadOrderWindow.addListener("hide", function() {
            pmsstockorderform.getForm().reset();
        });

        /*------开始获取界面数据的函数 start---------------*/
        function saveUserData() {
            Ext.MessageBox.wait("数据正在保存，请稍候……");
            if (Ext.getCmp('AuxWhId').getValue()==""||Ext.getCmp('AuxWhId').getValue()<=0){
                Ext.MessageBox.hide();
                Ext.Msg.alert("提示", "请选择仓库！");
                return;
            }  
            if (Ext.getCmp('WhpId').getValue()==""||Ext.getCmp('WhpId').getValue()<=0){
                Ext.MessageBox.hide();
                Ext.Msg.alert("提示", "请选择仓库下的仓位！");
                return;
            }    
            if (Ext.getCmp('PQty').getValue() <= 0 || Ext.getCmp('Qty').getValue() <= 0) {
                Ext.MessageBox.hide();
                Ext.Msg.alert("提示", "数量需要大于零！");
                return;
            }            
            if (Ext.getCmp('PUnit').getValue() != Ext.getCmp('Unit').getValue()) {
                Ext.MessageBox.hide();
                Ext.Msg.alert("提示", "转出和转入商品的单位请保持一致！");
                return;
            }
            if (Ext.getCmp('PQty').getValue() != Ext.getCmp('Qty').getValue() ) {
                Ext.MessageBox.hide();
                if (!window.confirm("转出转入商品数量不一致，是否继续保存？")) { 
                    return;
                }
            }
            Ext.Ajax.request({
                url: 'frmPmsProductConvertList.aspx?method=' + saveType,
                method: 'POST',
                params: {
                    OrderId: Ext.getCmp('OrderId').getValue(),
                    AuxWhId: Ext.getCmp('AuxWhId').getValue(),
                    WhpId: Ext.getCmp('WhpId').getValue(),
                    AuxProductId: Ext.getCmp('AuxProductId').getValue(),
                    PProductPrice: Ext.getCmp('ProductPrice').getValue(),//int
                    Qty: Ext.getCmp('Qty').getValue(),
                    UnitId: Ext.getCmp('Unit').getValue(),
                    Unit: Ext.getCmp('Unit').getValue(),//
                    ProductId: Ext.getCmp('ProductId').getValue(),
                    ProductPrice: Ext.getCmp('PProductPrice').getValue(),//out
                    PQty: Ext.getCmp('PQty').getValue(),
                    PUnit: Ext.getCmp('PUnit').getValue(),//
                    Remark: Ext.getCmp('Remark').getValue()
                },
                success: function(resp, opts) {
                    Ext.MessageBox.hide();
                    if (checkExtMessage(resp)) {
                        dspmsstockorder.reload({
                            params: {
                                start: 0,
                                limit: 10
                            }
                        });
                        uploadOrderWindow.hide();
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
        function setFormValue(selectData) {
            Ext.Ajax.request({
                url: 'frmPmsProductConvertList.aspx?method=getorder',
                params: {
                    OrderId: selectData.data.OrderId
                },
                success: function(resp, opts) {
                    var data = Ext.util.JSON.decode(resp.responseText);
                    Ext.getCmp("OrderId").setValue(data.OrderId);
                    Ext.getCmp("AuxWhId").setValue(data.AuxWhId);
                    Ext.getCmp("WhpId").setValue(data.WhpId);
                    Ext.getCmp("AuxProductId").setValue(data.AuxProductId);
                    Ext.getCmp("PProductPrice").setValue(data.ProductPrice);
                    Ext.getCmp("Qty").setValue(data.Qty);
                    Ext.getCmp("Unit").setValue(data.UnitId);
                    Ext.getCmp("ProductPrice").setValue(data.PProductPrice);
                    Ext.getCmp("ProductId").setValue(data.ProductId);
                    Ext.getCmp("PQty").setValue(data.PQty);
                    Ext.getCmp("PUnit").setValue(data.UnitId);
                    Ext.getCmp("Remark").setValue(data.Remark);
                    var index = dsProductList.findBy(
                        function(record, id) {
                            return record.get('ProductId') == data.AuxProductId;
                        }
                    );
                    var record = dsProductList.getAt(index);
                    Ext.getCmp('AuxProductNo').setValue(record.data.ProductNo)
                    index = dsProductList.findBy(
                        function(record, id) {
                            return record.get('ProductId') == data.ProductId;
                        }
                    );
                    record = dsProductList.getAt(index);
                    Ext.getCmp('ProductNo').setValue(record.data.ProductNo);
                    //dsWarehousePosList.load({
                    //    params: {
                    //        WhId: AuxWhId
                    //    }
                    //});
                },
                failure: function(resp, opts) {
                    Ext.Msg.alert("提示", "获取用户信息失败");
                }
            });
        }
        /*------结束设置界面数据的函数 End---------------*/
        /*------开始查询form end---------------*/
        //定义产品下拉框异步调用方法
        var dsProducts;
        if (dsProducts == null) {
            dsProducts = new Ext.data.Store({
                url: 'frmPmsProductConvertList.aspx?method=getProductByNameNo',
                reader: new Ext.data.JsonReader({
                    root: 'root',
                    totalProperty: 'totalProperty'
                }, [
                        { name: 'ProductId', mapping: 'ProductId' },
                        { name: 'ProductNo', mapping: 'ProductNo' },
                        { name: 'ProductName', mapping: 'ProductName' },
                        { name: 'Unit', mapping: 'Unit' },
                        { name: 'SalePrice', mapping: 'SalePrice' },
                        { name: 'SalePriceLower', mapping: 'SalePriceLower' },
                        { name: 'SalePriceLimit', mapping: 'SalePriceLimit' },
                        { name: 'UnitText', mapping: 'UnitText' },
                        { name: 'Specifications', mapping: 'Specifications' },
                        { name: 'SpecificationsText', mapping: 'SpecificationsText' },
                        { name: 'UnitId', mapping: 'UnitId' }
                    ])
            });
        }
        // 定义下拉框异步返回显示模板
        var resultTpl = new Ext.XTemplate(  
            '<tpl for="."><div id="searchdivid" class="search-item">',  
                '<h3><span>编号:{ProductNo}&nbsp;  名称:{ProductName}</span></h3>',
            '</div></tpl>'  
        );
        //仓库
        var ckCombo = new Ext.form.ComboBox({
            xtype: 'combo',
            fieldLabel: '仓库',
            anchor: '95%',
            store: dsWarehouseList,
            displayField: 'WhName',
            valueField: 'WhId',
            mode: 'local',
            triggerAction: 'all',
            editable: false
        });

        //成品
        var productId;
        var productName = new Ext.form.ComboBox({
            xtype: 'textfield',
            fieldLabel: '转出商品',
            anchor: '95%',
            store: dsProducts,
            displayField: 'ProductName',
            displayValue: 'ProductId',
            typeAhead: false,
            minChars: 1,
            //width:300,
            listWidth:320,
            loadingText: 'Searching...',
            tpl: resultTpl,  
            itemSelector: 'div.search-item',  
            pageSize: 10,
            hideTrigger: true,
            onSelect: function(record) {
                productName.setValue(record.data.ProductName);
                productId = record.data.ProductId;
                this.collapse();
            }
        });
        //开始日期
       var ksrq = new Ext.form.DateField({
   		    xtype:'datefield',
	        fieldLabel:'开始日期',
	        anchor:'90%',
	        name:'StartDate',
	        id:'StartDate',
	        format: 'Y年m月d日',  //添加中文样式
            value:new Date().clearTime() 
       });
       
       //结束日期
       var jsrq = new Ext.form.DateField({
   		    xtype:'datefield',
	        fieldLabel:'结束日期',
	        anchor:'90%',
	        name:'EndDate',
	        id:'EndDate',
	        format: 'Y年m月d日',  //添加中文样式
            value:new Date().clearTime()
       });

        var serchform = new Ext.FormPanel({
            el: 'divForm',
            id: 'serchform',
            labelAlign: 'left',
            buttonAlign: 'right',
            //bodyStyle: 'padding:5px',
            width:'100%',
            frame: true,
            items: [
            {
                layout: 'column',   //定义该元素为布局为列布局方式
                border: false,
                items: [{
                 columnWidth: .4,  //该列占用的宽度，标识为20％
                    layout: 'form',
                    border: false,
                    labelWidth: 55,
                    items: [ksrq]
                },
                {
                    columnWidth: .4,
                    layout: 'form',
                    border: false,
                    labelWidth: 80,
                    items: [jsrq]
                }]
            },
            {
                layout: 'column',   //定义该元素为布局为列布局方式
                border: false,
                items: [{
                    columnWidth: .4,  //该列占用的宽度，标识为20％
                    layout: 'form',
                    border: false,
                    labelWidth: 55,
                    items: [
                        ckCombo
                    ]
                }, {
                    columnWidth: .4,
                    layout: 'form',
                    border: false,
                    labelWidth: 80,
                    items: [
                        productName
                    ]
                }, {
                    layout: 'form',
                    columnWidth: .2,
                    border: false,
                    items: [{ cls: 'key',
                        xtype: 'button',
                        text: '查询',
                        anchor: '50%',
                        handler: function() {

                            var WhId = ckCombo.getValue();
                            var ProductId = productId;
                            
                            if(productName.getValue()=="")
                                ProductId = "";

                            dspmsstockorder.baseParams.WhId = WhId;
                            dspmsstockorder.baseParams.ProductId = ProductId;
                            dspmsstockorder.baseParams.StartDate=Ext.util.Format.date(Ext.getCmp('StartDate').getValue(),'Y/m/d');
                            dspmsstockorder.baseParams.EndDate=Ext.util.Format.date(Ext.getCmp('EndDate').getValue(),'Y/m/d');
                            dspmsstockorder.load({
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
        serchform.render();
        /*------开始查询form end---------------*/
        /*------开始获取数据的函数 start---------------*/
        var dspmsstockorder = new Ext.data.Store
({
    url: 'frmPmsProductConvertList.aspx?method=getOrderList',
    reader: new Ext.data.JsonReader({
        totalProperty: 'totalProperty',
        root: 'root'
    }, [
	{ name: 'OrderId' },
	{ name: 'OrgId' },
	{ name: 'AuxWhId' },
	{ name: 'AuxProductId' },
	{ name: 'Qty' },
	{ name: 'ProductId' },
	{ name: 'PQty' },
	{ name: 'CreateDate' },
	{ name: 'OperId' },
	{ name: 'BizStatus' },
	{ name: 'OwnerId' },
	{ name: 'Remark'
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

                    /*------开始DataGrid的函数 start---------------*/

                    var sm = new Ext.grid.CheckboxSelectionModel({
                        singleSelect: true
                    });
                    var pmsstockorderGrid = new Ext.grid.GridPanel({
                        el: 'dataGrid',
                        width: document.body.offsetWidth,
                        height: '100%',
                        //autoWidth: true,
                        //autoHeight: true,
                        autoScroll: true,
                        layout: 'fit',
                        id: '',
                        store: dspmsstockorder,
                        loadMask: { msg: '正在加载数据，请稍侯……' },
                        sm: sm,
                        cm: new Ext.grid.ColumnModel([
		sm,
		new Ext.grid.RowNumberer(), //自动行号
		{
		header: '订单号',
		dataIndex: 'OrderId',
		id: 'OrderId',
		hidden: true,
		hideable: false
},
		{
		    header: '仓库',
		    dataIndex: 'AuxWhId',
		    id: 'AuxWhId',
		    width:80,
		    renderer: function(val) {
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
		    header: '转出商品',
		    dataIndex: 'AuxProductId',
		    id: 'AuxProductId',
		    width:180,
		    renderer: function(val) {
		        dsProductList.each(function(r) {
		            if (val == r.data['ProductId']) {
		                val = r.data['ProductName'];
		                return;
		            }
		        });
		        return val;
		    }
		},
		{
		    header: '数量',
		    dataIndex: 'Qty',
		    id: 'Qty',
		    width:80
		},
		{
		    header: '转入商品',
		    dataIndex: 'ProductId',
		    id: 'ProductId',
		    width:180,
		    renderer: function(val) {
		        dsProductList.each(function(r) {
		            if (val == r.data['ProductId']) {
		                val = r.data['ProductName'];
		                return;
		            }
		        });
		        return val;
		    }
		},
		{
		    header: '数量',
		    dataIndex: 'PQty',
		    id: 'PQty',
		    width:80
		}, {
		    header: '业务状态',
		    dataIndex: 'BizStatus',
		    id: 'BizStatus',
		    renderer: function(val) {
		        if (val == 0) return '初始';
		        if (val == 2) return '已出库';
		    },
		    width:80
		},
		{
		    header: '创建时间',
		    dataIndex: 'CreateDate',
		    id: 'CreateDate'
		}
		]),
                        bbar: new Ext.PagingToolbar({
                            pageSize: 10,
                            store: dspmsstockorder,
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
                        height: 320,
                        closeAction: 'hide',
                        stripeRows: true,
                        loadMask: true//,
                        //autoExpandColumn: 2
                    });
                    pmsstockorderGrid.render();
                    /*------DataGrid的函数结束 End---------------*/


                })
</script>

</html>
