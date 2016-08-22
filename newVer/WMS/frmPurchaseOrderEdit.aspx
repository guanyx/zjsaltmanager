<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmPurchaseOrderEdit.aspx.cs" Inherits="WMS_frmPurchaseOrderEdit" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html>
<head>
<title>采购单编辑页面</title><meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<link rel="stylesheet" type="text/css" href="../ext3/resources/css/ext-all.css" />
<script type="text/javascript" src="../ext3/adapter/ext/ext-base.js"></script>
<script type="text/javascript" src="../ext3/ext-all.js"></script>
<script type="text/javascript" src="../ext3/example/TabCloseMenu.js" charset="gb2312"></script>
<script type="text/javascript" src="../ext3/example/ItemDeleter.js"></script>
<script type="text/javascript" src="../js/operateResp.js"></script>
<script type="text/javascript" src="../ext3/src/locale/ext-lang-zh_CN.js"></script>
<style type="text/css">
.extensive-remove {
background-image: url(../Theme/1/images/extjs/customer/cross.gif) ! important;
}
.x-grid-back-blue { 
background: #C3D9FF; 
}
</style>
</head>
<body>
<div id='divForm'></div>
<div id='divGrid'></div>
<div id='divBotton'></div>
<div style="display:none">
<select id='comboStatus' >
<option value='0'>草稿</option>
<option value='1'>已提交</option>
</select></div>
</body>
<%= getComboBoxStore() %>
<script type="text/javascript">
    Ext.BLANK_IMAGE_URL = "../ext3/resources/images/default/s.gif";

    function GetUrlParms() {
        var args = new Object();
        var query = location.search.substring(1); //获取查询串   
        var pairs = query.split("&"); //在逗号处断开   
        for (var i = 0; i < pairs.length; i++) {
            var pos = pairs[i].indexOf('='); //查找name=value   
            if (pos == -1) continue; //如果没有找到就跳过   
            var argname = pairs[i].substring(0, pos); //提取name   
            var value = pairs[i].substring(pos + 1); //提取value   
            args[argname] = unescape(value); //存为属性   
        }
        return args;
    }
    var args = new Object();
    args = GetUrlParms();
    //如果要查找参数key:
    var OrderId = args["id"];
    var PageStatus = args["status"];
    //alert(OrderId);


    //公共方法

    /*------开始界面数据的函数 Start---------------*/
    function setFormValue() {
        Ext.Ajax.request({
            url: 'frmPurchaseOrderEdit.aspx?method=getPurchaseOrderInfo',
            params: {
                OrderId: OrderId
            },
            success: function(resp, opts) {
                var data = Ext.util.JSON.decode(resp.responseText);
                Ext.getCmp("OrderId").setValue(data.OrderId);
                Ext.getCmp("OrgId").setValue(data.OrgId);
                Ext.getCmp("WhId").setValue(data.WhId);
                Ext.getCmp("OperId").setValue(data.OperId);
                Ext.getCmp("BillStatus").setValue(data.BillStatus);
                Ext.getCmp("CreateDate").setValue((new Date(data.CreateDate.replace(/-/g, "/"))));
                Ext.getCmp("SupplierId").setValue(data.SupplierId);
                Ext.getCmp("CarBoatNo").setValue(data.CarBoatNo);
                Ext.getCmp("Remark").setValue(data.Remark);
            },
            failure: function(resp, opts) {
                Ext.Msg.alert("提示", "获取进货单信息失败！");
            }
        });
    }

    var userGrid = null;
    var dsPruchaseOrderDetailInfo = null;
    function setAllValue() {
        Ext.getCmp("OrderId").setValue(OrderId);
        if (OrderId > 0) {
            setFormValue();
            dsPruchaseOrderDetailInfo.load({
                params: { start: 0,
                    limit: 100,
                    OrderId: OrderId
                },
                callback: function(r, options, success) {
                    if (success == true) {
                        //alert(userGrid.getColumnModel().getColumnCount() + "----");
                        var columnCount = userGrid.getColumnModel().getColumnCount();
                        for (var i = 0; i < columnCount; i++) {
                            userGrid.getColumnModel().setEditable(i, false);
                        }
                        //alert(PageStatus);
                        switch (PageStatus) {
                            case "confirm":
                                userGrid.getColumnModel().setEditable(columnCount - 2, true);
                                Ext.getCmp("confirmButton").show();
                                Ext.getCmp("confirmPriceButton").hide();
                                break;
                            case "confirmprice":
                                userGrid.getColumnModel().setEditable(columnCount - 4, true);
                                Ext.getCmp("confirmPriceButton").show();
                                Ext.getCmp("confirmButton").hide();
                                //confirmPriceButton
                                //userGrid.getView().getColumn(4).style.backgroundColor = '#DCDCDC';

                                break;
                            case "readonly":
                                Ext.getCmp("confirmButton").hide();
                                Ext.getCmp("confirmPriceButton").hide();
                                break;
                            case "adjustAmt":
                                Ext.getCmp("ajustAmtButton").show();
                                userGrid.getColumnModel().setHidden(columnCount - 1, false);
                                userGrid.getColumnModel().setEditable(columnCount - 1, true);
                                break;
                        }

                    }

                }
            });
        }
    }
    /*------开始界面数据的函数 End---------------*/
    Ext.onReady(function() {
        var initWarehouseForm = new Ext.form.FormPanel({
            url: '',
            renderTo: 'divForm',
            frame: true,
            title: '',
            items: [
            {
                layout: 'column',   //定义该元素为布局为列布局方式
                border: false,
                items: [
            {
                columnWidth: .5,  //该列占用的宽度，标识为20％
                layout: 'form',
                border: false,
                items: [
                    {
                        xtype: 'combo',
                        fieldLabel: '供应商',
                        columnWidth: 1,
                        anchor: '95%',
                        name: 'SupplierId',
                        id: 'SupplierId',
                        displayField: 'ChineseName',
                        valueField: 'CustomerId',
                        store: dsSuppliesListInfo,
                        mode: 'local',
                        typeAhead: false,
                        triggerAction: 'all',
                        lazyRender: true,
                        editable: false
                    }
                ]
            },
            {
                columnWidth: .5,  //该列占用的宽度，标识为20％
                layout: 'form',
                border: false,
                items: [
                    {
                        xtype: 'textfield',
                        fieldLabel: '车船号',
                        columnWidth: 1,
                        anchor: '95%',
                        name: 'CarBoatNo',
                        id: 'CarBoatNo',
                        editable: true,
                        readOnly: true
                    }
                ]
            }
            ]
            }, {
                layout: 'column',   //定义该元素为布局为列布局方式
                border: false,
                items: [
            {
                columnWidth: .5,  //该列占用的宽度，标识为20％
                layout: 'form',
                border: false,
                items: [
                    {
                        xtype: 'hidden',
                        fieldLabel: '订单号',
                        name: 'OrderId',
                        id: 'OrderId',
                        hide: true
                    }
                    , {
                        xtype: 'hidden',
                        fieldLabel: '组织ＩＤ',
                        name: 'OrgId',
                        id: 'OrgId',
                        hide: true
                    }
                    , {
                        xtype: 'combo',
                        fieldLabel: '仓库名称',
                        columnWidth: 1,
                        anchor: '95%',
                        name: 'WhId',
                        id: 'WhId',
                        displayField: 'WhName',
                        valueField: 'WhId',
                        editable: false,
                        store: dsNeedInitWarehouseList,
                        mode: 'local',
                        //triggerAction: 'all',
                        listeners: {
                            select: function(combo, record, index) {
                                var curWhId = Ext.getCmp("WhId").getValue();
                                dsWarehousePosList.load({
                                    params: {
                                        WhId: curWhId
                                    }
                                });
                                //Ext.getCmp('WhpId').setValue("");
                                //grid中仓位复位
                            }
                        }
                    }
                ]
            },
            {
                columnWidth: .5,  //该列占用的宽度，标识为20％
                layout: 'form',
                border: false,
                items: [
                {
                    xtype: 'combo',
                    fieldLabel: '操作者',
                    columnWidth: 1,
                    anchor: '95%',
                    name: 'OperId',
                    id: 'OperId',
                    displayField: 'EmpName',
                    valueField: 'EmpId',
                    editable: false,
                    store: dsOperationList,
                    mode: 'local',
                    readOnly: true,
                    //value:<%=ZJSIG.UIProcess.ADM.UIAdmUser.EmployeeID(this) %>,
                    disabled: true
                }
                ]
            }
            ]
            },
        {
            layout: 'column',   //定义该元素为布局为列布局方式
            border: false,
            items: [
            {
                columnWidth: .5,  //该列占用的宽度，标识为20％
                layout: 'form',
                border: false,
                items: [
                    {
                        xtype: 'datefield',
                        fieldLabel: '进货时间',
                        columnWidth: 1,
                        anchor: '95%',
                        name: 'CreateDate',
                        id: 'CreateDate',
                        format: 'Y年m月d日',
                        readOnly: true,
                        disabled: true
                    }
                ]
            },
            {
                columnWidth: .5,  //该列占用的宽度，标识为20％
                layout: 'form',
                border: false,
                items: [
                    {
                        xtype: 'combo',
                        fieldLabel: '单据状态',
                        columnWidth: 1,
                        anchor: '95%',
                        name: 'BillStatus',
                        id: 'BillStatus',
                        displayField: 'BillStatusName',
                        valueField: 'BillStatusId',
                        store: dsBillStatus,
                        mode: 'local',
                        //disabled: true,
                        typeAhead: false,
                        //triggerAction: 'all',
                        lazyRender: true,
                        editable: false,
                        disabled: true
                    }
                ]
            }
            ]
        },
        {
            layout: 'column',   //定义该元素为布局为列布局方式
            border: false,
            items: [{
                columnWidth: .975,  //该列占用的宽度，标识为20％
                layout: 'form',
                border: false,
                items: [{
                    xtype: 'textarea',
                    fieldLabel: '备注',
                    columnWidth: 1,
                    anchor: '100%',
                    height:40,
                    name: 'Remark',
                    id: 'Remark',
                    readOnly: true
}]
}]
}]
        });


        //alert(Ext.getCmp("OperId").getValue());
        //-------------------Form结束-----------------------------



        //-------------------Grid Start-----------------------------

        function inserNewBlankRow() {
            var rowCount = userGrid.getStore().getCount();
            var insertPos = parseInt(rowCount);
            var addRow = new RowPattern({
                //WhpId: '',
                ProductId: '',
                ProductCode: '',
                ProductUnit: '',
                ProductSpec: '',
                ProductPrice: '',
                BookQty: '',
                RealQty: '',
                AdjustAmt:''
            });
            userGrid.stopEditing();
            //增加一新行
            if (insertPos > 0) {
                var rowIndex = dsPruchaseOrderDetailInfo.insert(insertPos, addRow);
                userGrid.startEditing(insertPos, 0);
            }
            else {
                var rowIndex = dsPruchaseOrderDetailInfo.insert(0, addRow);
                userGrid.startEditing(0, 0);
            }
        }
        function addNewBlankRow(combo, record, index) {
            var rowIndex = userGrid.getStore().indexOf(userGrid.getSelectionModel().getSelected());
            var rowCount = userGrid.getStore().getCount();
            if ((rowIndex == 0 && rowCount == 1) || rowIndex == rowCount - 1) {
                inserNewBlankRow();
            }
        }


        var productUnitCombo = new Ext.form.ComboBox({
            store: dsProductUnitList,
            displayField: 'UnitName',
            valueField: 'UnitId',
            triggerAction: 'all',
            id: 'productUnitCombo',
            typeAhead: true,
            mode: 'local',
            emptyText: '',
            selectOnFocus: false,
            editable: false,
            listeners: {
                "select": addNewBlankRow
            }
        });
        var productSpecCombo = new Ext.form.ComboBox({
            store: dsProductSpecList,
            displayField: 'DicsName',
            valueField: 'DicsCode',
            triggerAction: 'all',
            id: 'productSpecCombo',
            //pageSize: 5,  
            //minChars: 2,  
            //hideTrigger: true,  
            typeAhead: true,
            mode: 'local',
            emptyText: '',
            selectOnFocus: false,
            editable: false,
            listeners: {
                "select": addNewBlankRow
            }
        });
        //        var warehousePosCombo = new Ext.form.ComboBox({
        //            store: dsWarehousePosList,
        //            displayField: 'WhpName',
        //            valueField: 'WhpId',
        //            triggerAction: 'all',
        //            id: 'warehousePosCombo',
        //            //pageSize: 5,  
        //            //minChars: 2,  
        //            //hideTrigger: true,  
        //            typeAhead: true,
        //            mode: 'local',
        //            emptyText: '',
        //            selectOnFocus: false,
        //            editable: false,
        //            listeners: {
        //                "select": addNewBlankRow//,
        //                //"focus":new function(){alert('X');}
        //            }
        //        });
        //        var resultTpl = new Ext.XTemplate(
        //                        '<table>',
        //                        '<tpl for="."><tr>',
        //                            '<td>{ProductNo}</td><td>{ProductName}</td><td>{Specifications}</td><td>{Unit}</td>',
        //                        '</tr></tpl></table>'
        //                    ); 
        var productCombo = new Ext.form.ComboBox({
            store: dsProductList,
            displayField: 'ProductName',
            valueField: 'ProductId',
            triggerAction: 'all',
            id: 'productCombo',
            //pageSize: 5,
            //minChars: 2,
            //hideTrigger: true,
            typeAhead: true,
            mode: 'local',
            //            tpl: resultTpl,
            emptyText: '',
            selectOnFocus: false,
            editable: true,
            onSelect: function(record) {
                var sm = userGrid.getSelectionModel().getSelected();
                sm.set('ProductCode', record.data.ProductNo);
                sm.set('ProductSpec', record.data.Specifications);
                sm.set('ProductUnit', record.data.Unit);
                sm.set('ProductId', record.data.ProductId);
                addNewBlankRow();
            }
        });
        var cm = new Ext.grid.ColumnModel([
        new Ext.grid.RowNumberer(), //自动行号
        {
        id: 'OrderDetailId',
        header: "订单明细ID",
        dataIndex: 'OrderDetailId',
        width: 30,
        hidden: true,
        editor: new Ext.form.TextField({ allowBlank: false })
    },
    //        {
    //            id: 'WhpId',
    //            header: "仓位",
    //            dataIndex: 'WhpId',
    //            width: 20,
    //            //hidden: true,
    //            editor: warehousePosCombo,
    //            renderer: function(value, cellmeta, record, rowIndex, columnIndex, store) {
    //                //解决值显示问题
    //                //获取当前id="combo_process"的comboBox选择的值
    //                var index = dsWarehousePosList.find(warehousePosCombo.valueField, value);
    //                var record = dsWarehousePosList.getAt(index);
    //                var displayText = "";
    //                // 如果下拉列表没有被选择，那么record也就不存在，这时候，返回传进来的value，
    //                // 而这个value就是grid的USER_REALNAME列的value，所以直接返回
    //                if (record == null) {
    //                    //返回默认值，
    //                    displayText = value;
    //                } else {
    //                    displayText = record.data.WhpName; //获取record中的数据集中的process_name字段的值
    //                }
    //                return displayText;
    //            }
    //        }, 
        {
        id: 'ProductCode',
        header: "代码",
        dataIndex: 'ProductCode',
        width: 60,
        editor: new Ext.form.TextField({ allowBlank: false })
    },
        {
            id: 'ProductId',
            header: "商品",
            dataIndex: 'ProductId',
            width: 160,
            editor: productCombo,
            renderer: function(value, cellmeta, record, rowIndex, columnIndex, store) {
                //解决值显示问题
                //获取当前id="combo_process"的comboBox选择的值
                var index = dsProductList.findBy(function(record, id) {
                    return record.get(productCombo.valueField) == value;
                });
                var record = dsProductList.getAt(index);
                var displayText = "";
                // 如果下拉列表没有被选择，那么record也就不存在，这时候，返回传进来的value，
                // 而这个value就是grid的USER_REALNAME列的value，所以直接返回
                if (record == null) {
                    //返回默认值，
                    displayText = value;
                } else {
                    displayText = record.data.ProductName; //获取record中的数据集中的process_name字段的值
                    //alert(record.data.ProductName); alert(record.data.ProductId);
                }
                return displayText;
            }
        },

        {
            id: 'ProductSpec',
            header: "规格",
            dataIndex: 'ProductSpec',
            width: 70,
            editor: productSpecCombo,
            renderer: function(value, cellmeta, record, rowIndex, columnIndex, store) {
                //解决值显示问题
                //获取当前id="combo_process"的comboBox选择的值
                var index = dsProductSpecList.findBy(function(record, id) {
                    return record.get(productSpecCombo.valueField) == value;
                });
                var record = dsProductSpecList.getAt(index);
                var displayText = "";
                // 如果下拉列表没有被选择，那么record也就不存在，这时候，返回传进来的value，
                // 而这个value就是grid的USER_REALNAME列的value，所以直接返回
                if (record == null) {
                    //返回默认值，
                    displayText = value;
                } else {
                    displayText = record.data.DicsName; //获取record中的数据集中的process_name字段的值
                }
                return displayText;
            }
        }, {
            id: "ProductUnit",
            header: "单位",
            dataIndex: "ProductUnit",
            width: 60,
            editor: productUnitCombo,
            renderer: function(value, cellmeta, record, rowIndex, columnIndex, store) {
                //解决值显示问题
                //获取当前id="combo_process"的comboBox选择的值
                var index = dsProductUnitList.findBy(function(record, id) {
                    return record.get(productUnitCombo.valueField) == value;
                });
                var record = dsProductUnitList.getAt(index);
                var displayText = "";
                // 如果下拉列表没有被选择，那么record也就不存在，这时候，返回传进来的value，
                // 而这个value就是grid的USER_REALNAME列的value，所以直接返回
                if (record == null) {
                    //返回默认值，
                    displayText = value;
                } else {
                    displayText = record.data.UnitName; //获取record中的数据集中的process_name字段的值
                }
                return displayText;
            }
        }
        , {
            id: 'ProductPrice',
            header: "进货价格",
            dataIndex: 'ProductPrice',
            width: 70,
            align: 'right',
            renderer: function(v, m) {
                if (PageStatus == 'confirmprice') {
                    m.css = 'x-grid-back-blue';
                }
                return v;
            },
            editor: new Ext.form.TextField({ allowBlank: false,
		        align: 'right',
		        decimalPrecision:8,
                listeners: {
                    'focus': function() {
                        this.selectText();
                }
            }
             })
        }, {
            id: 'BookQty',
            header: "帐面数量",
            dataIndex: 'BookQty',
            width: 70,
            align: 'right',
            editor: new Ext.form.TextField({ allowBlank: false })
        }, {
            id: 'RealQty',
            header: "实收数量",
            dataIndex: 'RealQty',
            width: 70,
            align: 'right',
            renderer: function(v, m) {
                if (PageStatus == 'confirm') {
                    m.css = 'x-grid-back-blue';
                }
                return v;
            },
            editor: new Ext.form.TextField({ allowBlank: false ,
		        align: 'right',
		        decimalPrecision:6,
                listeners: {
		            'focus': function() {
		                this.selectText();
		            }
		        }
            })
        }, {
            id: 'AdjustAmt',
            header: "调整金额",
            dataIndex: 'AdjustAmt',
            hidden:true,
            width:100,
            align: 'right',
            renderer: function(v, m) {
                if (PageStatus == 'adjustAmt') {
                    m.css = 'x-grid-back-blue';
                }
                return v;
            },
            editor: new Ext.form.NumberField({ 
                allowBlank: false ,
		        decimalPrecision:2,
                listeners: {
		            'focus': function() {
		                this.selectText();
		            }
		        }
		    })
        }//, new Extensive.grid.ItemDeleter()
    ]);
    cm.defaultSortable = true;

    var RowPattern = Ext.data.Record.create([
           { name: 'OrderDetailId', type: 'string' },
    //{ name: 'WhpId', type: 'string' },
           {name: 'ProductId', type: 'string' },
           { name: 'ProductCode', type: 'string' },
           { name: 'ProductUnit', type: 'string' },
           { name: 'ProductSpec', type: 'string' },
           { name: 'ProductPrice', type: 'string' },
           { name: 'BookQty', type: 'string' },
           { name: 'RealQty', type: 'string' },
           { name: 'UnitId', type: 'string' },
           { name: 'AdjustAmt', type: 'string' }
          ]);

//    var dsPruchaseOrderDetailInfo;
    if (dsPruchaseOrderDetailInfo == null) {
        dsPruchaseOrderDetailInfo = new Ext.data.Store
	        ({
	            url: 'frmPurchaseOrderEdit.aspx?method=getPurchaseOrderDetailInfo',
	            reader: new Ext.data.JsonReader({
	                totalProperty: 'totalProperty',
	                root: 'root'
	            }, RowPattern)
	        });
    }
    userGrid = new Ext.grid.EditorGridPanel({
        store: dsPruchaseOrderDetailInfo,
        cm: cm,
        selModel: new Extensive.grid.ItemDeleter(),
        layout: 'fit',
        renderTo: 'divGrid',
        width: '100%',
        height: 200,
        stripeRows: true,
        frame: true,
        clicksToEdit: 1,
        minColumnWidth:60,
        viewConfig: {
            columnsText: '显示的列',
            scrollOffset: 20,
            sortAscText: '升序',
            sortDescText: '降序',
            forceFit: true
        }
    });

    function colorChange(val) {
        return "<font color='red'>" + val + "</font>";
    }

    //-------------------Grid End-------------------------------    /*----------------footerframe----------------*/
    //将grid明细记录组装成json串提交到UI再decode
    var json = '';
    var footerForm = new Ext.FormPanel({
        el: 'divBotton',
        border: true, // 没有边框
        labelAlign: 'left',
        buttonAlign: 'center',
        bodyStyle: 'padding:2px',
        height: 85,
        frame: true,
        labelWidth: 55,
        buttons: [
        //        {
        //            text: "保存",
        //            scope: this,
        //            id: 'saveButton',
        //            handler: function() {
        //                json = "";
        //                dsPruchaseOrderDetailInfo.each(function(dsPruchaseOrderDetailInfo) {"
        //                    json += Ext.util.JSON.encode(dsPruchaseOrderDetailInfo.data) + ',';
        //                });
        //                json = json.substring(0, json.length - 1);
        //                alert(json);
        //                //alert(Ext.getCmp('InventoryDate').getValue());
        //                //然后传入参数保存

        //                Ext.Ajax.request({
        //                    url: 'frmInitWarehouseEdit.aspx?method=saveInitWarehouseInfo',
        //                    method: 'POST',
        //                    params: {
        //                        //主参数
        //                        //OrderDetailId:Ext.getCmp("OrderDetailId").getValue(),
        //                        WhId: Ext.getCmp('WhId').getValue(),
        //                        OperId: Ext.getCmp('OperId').getValue(),
        //                        InventoryDate: Ext.getCmp('InventoryDate').getValue().toLocaleDateString(),
        //                        Remark: Ext.getCmp('Remark').getValue(),
        //                        Status: Ext.getCmp("Status").getValue(),
        //                        OrderId: Ext.getCmp("OrderId").getValue(),
        //                        //明细参数
        //                        DetailInfo: json
        //                    },
        //                    success: function(resp, opts) {
        //                        Ext.Msg.alert("提示", "保存成功！");
        //                    }
        //                , failure: function(resp, opts) {
        //                    Ext.Msg.alert("提示", "保存失败！");

        //                }
        //                });
        //                //
        //            }
        //        },
                {
                text: "确认",
                scope: this,
                id: 'confirmButton',
                hidden: true,
                handler: function() {
                    Ext.MessageBox.confirm("提示信息", "是否真的要对该进货单实收数量进行确认？", function callBack(id) {
                        //判断是否确认
                        if (id == "yes") {
                            json = "";
                            dsPruchaseOrderDetailInfo.each(function(dsPruchaseOrderDetailInfo) {
                                json += Ext.util.JSON.encode(dsPruchaseOrderDetailInfo.data) + ',';
                            });
                            json = json.substring(0, json.length - 1);
                            //alert(json);
                            //页面提交
                            Ext.Ajax.request({
                                url: 'frmPurchaseOrderEdit.aspx?method=confirmPurchaseOrder',
                                method: 'POST',
                                params: {
                                    OrderId: Ext.getCmp("OrderId").getValue(),
                                    //明细参数
                                    DetailInfo: json
                                },
                                success: function(resp, opts) {
                                    if (checkParentExtMessage(resp,parent)) {
                                        parent.uploadPurchaseOrderWindow.hide();
                                    }
                                },
                                failure: function(resp, opts) {
                                    Ext.Msg.alert("提示", "数据确认失败，请检查网络！");
                                }
                            });
                        }
                    });
                }
            }, {
                text: "进价确认",
                scope: this,
                id: 'confirmPriceButton',
                hidden: true,
                handler: function() {
                    Ext.MessageBox.confirm("提示信息", "是否真的要对该进货单的进货价格进行确认？", function callBack(id) {
                        //判断是否确认
                        if (id == "yes") {
                            json = "";
                            dsPruchaseOrderDetailInfo.each(function(dsPruchaseOrderDetailInfo) {
                                json += Ext.util.JSON.encode(dsPruchaseOrderDetailInfo.data) + ',';
                            });
                            json = json.substring(0, json.length - 1);
                            //alert(json);
                            //页面提交
                            Ext.Ajax.request({
                                url: 'frmPurchaseOrderEdit.aspx?method=confirmPricePurchaseOrder',
                                method: 'POST',
                                params: {
                                    //主参数
                                    OrderId: Ext.getCmp("OrderId").getValue(),
                                    WhId: Ext.getCmp("WhId").getValue(),
                                    //明细参数
                                    DetailInfo: json
                                },
                                success: function(resp, opts) {
                                    if (checkParentExtMessage(resp,parent)) {
                                        parent.uploadPurchaseOrderWindow.hide();
                                    }
                                },
                                failure: function(resp, opts) {
                                    Ext.Msg.alert("提示", "进货价格确认失败，请检查网络！");
                                }
                            });
                        }
                    });
                }
            }, {
                text: "保存",
                scope: this,
                id: 'ajustAmtButton',
                hidden: true,
                handler: function() {
                    Ext.MessageBox.confirm("提示信息", "是否真的要保持该进货单的调整金额？", function callBack(id) {
                        //判断是否确认
                        if (id == "yes") {
                            json = "";
                            dsPruchaseOrderDetailInfo.each(function(dsPruchaseOrderDetailInfo) {
                                json += Ext.util.JSON.encode(dsPruchaseOrderDetailInfo.data) + ',';
                            });
                            json = json.substring(0, json.length - 1);
                            //alert(json);
                            //页面提交
                            Ext.Ajax.request({
                                url: 'frmPurchaseOrderEdit.aspx?method=adjustAmtPurchaseOrder',
                                method: 'POST',
                                params: {
                                    //主参数
                                    OrderId: Ext.getCmp("OrderId").getValue(),
                                    WhId: Ext.getCmp("WhId").getValue(),
                                    //明细参数
                                    DetailInfo: json
                                },
                                success: function(resp, opts) {
                                    if (checkParentExtMessage(resp,parent)) {
                                        parent.uploadPurchaseOrderWindow.hide();
                                    }
                                },
                                failure: function(resp, opts) {
                                    Ext.Msg.alert("提示", "调整金额失败，请检查网络！");
                                }
                            });
                        }
                    });
                }
            },
         {
             text: "关闭",
             scope: this,
             handler: function() {
                 parent.uploadPurchaseOrderWindow.hide();

             }
        }]
    });
    footerForm.render();
    setAllValue();
})

</script>

</html>

