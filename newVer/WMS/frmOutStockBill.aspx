<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmOutStockBill.aspx.cs" Inherits="WMS_frmOutStockBill" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
    <title>仅供参考使用页面</title>
    <meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
    <link rel="stylesheet" type="text/css" href="../ext3/resources/css/ext-all.css" />

    <script type="text/javascript" src="../ext3/adapter/ext/ext-base.js"></script>

    <script type="text/javascript" src="../ext3/ext-all.js"></script>

    <script type="text/javascript" src="../ext3/example/ItemDeleter.js"></script>
    <script type="text/javascript" src="../ext3/src/locale/ext-lang-zh_CN.js"></script>
    <style type="text/css">
        .extensive-remove
        {
            background-image: url(../Theme/1/images/extjs/customer/cross.gif) !important;
        }
    </style>
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
        var OrderId = args["id"];
        var FromBillType = args["type"];
    </script>
</head>
<body>
    <div id='title' style='width: 100%; height: 50px; overflow: hidden; padding-top: 5px;'>
        <table width="100%">
            <tr>
                <td align="right" valign="bottom">
                    No.2000909090009<!--从c#中取出-->
                </td>
                <td style="width: 5px">
                </td>
            </tr>
            <tr>
                <td align="center" valign="middle" style="font-size: larger;" colspan="2">
                    浙江省盐业集团杭州市盐业公司进仓单
                </td>
            </tr>
        </table>
    </div>
    <div id="topform">
    </div>
    <div id="userdatagrid">
    </div>
    <div id="transport">
    </div>
    <div id="footer">
    </div>
    <select id='bindipSelct' style="display: none;">
        <option value="是">是</option>
        <option value="否">否</option>
    </select>
</body>
<%= getComboBoxStore() %>

<script type="text/javascript">
    //以下代码不要动 
    Ext.grid.CheckColumn = function(config) {
        Ext.apply(this, config);
        if (!this.id) {
            this.id = Ext.id();
        }
        this.renderer = this.renderer.createDelegate(this);
    };

    Ext.grid.CheckColumn.prototype = {
        init: function(grid) {
            this.grid = grid;
            this.grid.on('render', function() {
                var view = this.grid.getView();
                view.mainBody.on('mousedown', this.onMouseDown, this);
            }, this);
        },
        onMouseDown: function(e, t) {
            if (t.className && t.className.indexOf('x-grid3-cc-' + this.id) != -1) {
                e.stopEvent();
                var index = this.grid.getView().findRowIndex(t);
                var record = this.grid.store.getAt(index);
                record.set(this.dataIndex, !record.data[this.dataIndex]);
            }
        },
        renderer: function(v, p, record) {
            p.css += ' x-grid3-check-col-td';
            return '<div class="x-grid3-check-col' + (v ? '-on' : '') + ' x-grid3-cc-' + this.id + '"> </div>';
        }
    };
    var scope;
    Ext.onReady(function() {

        scope = this;
        //将grid明细记录组装成json串提交到UI再decode
        var json = '';
        /*----------------topframe----------------*/
        var topForm = new Ext.FormPanel({
            el: 'topform',
            border: true, // 没有边框
            labelAlign: 'left',
            buttonAlign: 'right',
            bodyStyle: 'padding:2px',
            height: 70,
            frame: true,
            labelWidth: 55,
            items: [{
                layout: 'column',   //定义该元素为布局为列布局方式
                border: false,
                items: [{
                    columnWidth: .25,  //该列占用的宽度，标识为20％
                    layout: 'form',
                    border: false,
                    items: [
                    {
                        xtype: 'hidden',
                        fieldLabel: '原始订单号',
                        name: 'FromBillId',
                        id: 'FromBillId',
                        hide: true
                    },
                    {
                        xtype: 'hidden',
                        fieldLabel: '订单号',
                        name: 'OrderId',
                        id: 'OrderId',
                        hide: true
                    }
                    , {
                        xtype: 'combo',
                        fieldLabel: '单据类型',
                        anchor: '95%',
                        id: 'FromBillType',
                        displayField: 'DicsName',
                        valueField: 'DicsCode',
                        editable: false,
                        store: dsBillTypeList,
                        mode: 'local',
                        triggerAction: 'all'
                       }]
                    }, {
                        columnWidth: .3,
                        layout: 'form',
                        border: false,
                        items: [{
                            xtype: 'combo',
                            fieldLabel: '供应商',
                            anchor: '95%',
                            id: 'SupplierId',
                            displayField: 'ChineseName',
                            valueField: 'CustomerId',
                            editable: false,
                            store: dsSuppliesListInfo,
                            mode: 'local',
                            triggerAction: 'all'
}]
                        }, {
                            layout: 'table',
                            columnWidth: .25,
                            items: [{
                                layout: 'fit',
                                anchor: '95%',
                                html: '录入类型:&nbsp;&nbsp;'
                            }, {
                                columnWidth: .5,
                                items: [new Ext.form.Radio({
                                    id: 'Normal',
                                    name: 'IsRedWord',
                                    checked: true,
                                    anchor: '95%',
                                    boxLabel: '正常',
                                    inputValue: 0
                                })]
                            }, {
                                columnWidth: .5,
                                items: [new Ext.form.Radio({
                                    id: 'RedFont',
                                    name: 'IsRedWord',
                                    anchor: '95%',
                                    boxLabel: '红字',
                                    inputValue: 1
                                })]
}]
                            }, {
                                columnWidth: .2, //xtype:"panel", labelWidth:50
                                layout: 'form',
                                border: false,
                                items: [{
                                    xtype: 'label',
                                    style: 'vertical-align: bottom;',
                                    text: '状态:'
                                }, {
                                    xtype: 'label',
                                    text: '草稿',
                                    readOnly: true,
                                    y: 5,
                                    id: 'zt'
}]
}]
                                }, {
                                    layout: 'column',   //定义该元素为布局为列布局方式
                                    border: false,
                                    items: [{
                                        columnWidth: .25,  //该列占用的宽度，标识为20％
                                        layout: 'form',
                                        border: false,
                                        items: [{
                                            xtype: 'combo',
                                            fieldLabel: '分公司',
                                            anchor: '95%',
                                            id: 'OrgId'}]
                                        }, {
                                            columnWidth: .3,
                                            layout: 'form',
                                            border: false,
                                            items: [{
                                                xtype: 'combo',
                                                fieldLabel: '仓库名称',
                                                anchor: '95%',
                                                id: 'WhId',
                                                displayField: 'WhName',
                                                valueField: 'WhId',
                                                editable: false,
                                                store: dsWarehouseList,
                                                mode: 'local',
                                                triggerAction: 'all',
                                                listeners: {
                                                    select: function(combo, record, index) {
                                                        var curWhId = Ext.getCmp("WhId").getValue();

                                                        dsWarehousePosList.load({
                                                            params: {
                                                                WhId: curWhId
                                                            }
                                                        });
                                                    }
                                                }
}]
                                            }, {
                                                columnWidth: .25,
                                                layout: 'form',
                                                border: false,
                                                items: [{
                                                    xtype: 'combo',
                                                    fieldLabel: '仓管员',
                                                    anchor: '95%',
                                                    id: 'WarehouseAdmin'}]
                                                }, {
                                                    columnWidth: .2,
                                                    layout: 'form',
                                                    border: false,
                                                    items: [{
                                                        xtype: 'checkbox',
                                                        boxLabel: '是否初始单',
                                                        hideLabel: true,
                                                        anchor: '95%',
                                                        id: 'IsInitBill'}]
}]
}]
                                                    });
                                                    topForm.render();
                                                    /*----------------topframe----------------*/
                                                    function inserNewBlankRow() {
                                                        var rowCount = userGrid.getStore().getCount();
                                                        //alert(rowCount);
                                                        var insertPos = parseInt(rowCount);
                                                        var addRow = new RowPattern({
                                                            WhpId: '',
                                                            ProductCode: '',
                                                            ProductId: '',
                                                            ProductUnit: '',
                                                            ProductSpec: '',
                                                            ProductPrice: '',
                                                            BookQty: '',
                                                            RealQty: ''
                                                        });
                                                        userGrid.stopEditing();
                                                        //增加一新行
                                                        if (insertPos > 0) {
                                                            var rowIndex = dsInStockProductDetail.insert(insertPos, addRow);
                                                            userGrid.startEditing(insertPos, 0);
                                                        }
                                                        else {
                                                            var rowIndex = dsInStockProductDetail.insert(0, addRow);
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


                                                    //仓位数据源
                                                    var dsWarehousePosList;
                                                    if (dsWarehousePosList == null) { //防止重复加载
                                                        //alert(Ext.getCmp("WhId").getValue());
                                                        dsWarehousePosList = new Ext.data.Store
                                                        ({
                                                            url: 'frmInStockBill.aspx?method=getWarehousePosList',
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
                                                    var productCombo = new Ext.form.ComboBox({
                                                        store: dsProductList,
                                                        displayField: 'ProductName',
                                                        valueField: 'ProductId',
                                                        triggerAction: 'all',
                                                        id: 'productCombo',
                                                        typeAhead: true,
                                                        mode: 'local',
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

                                                    function formatDate(value) {
                                                        return value ? value.dateFormat('Y年m月d日') : '';
                                                    };
                                                    // shorthand alias  
                                                    var fm = Ext.form;

                                                    var warehousePosCombo = new Ext.form.ComboBox({
                                                        store: dsWarehousePosList,
                                                        displayField: 'WhpName',
                                                        valueField: 'WhpId',
                                                        triggerAction: 'all',
                                                        id: 'warehousePosCombo',
                                                        typeAhead: true,
                                                        mode: 'local',
                                                        emptyText: '',
                                                        selectOnFocus: false,
                                                        editable: false,
                                                        listeners: {
                                                            "select": addNewBlankRow
                                                        }
                                                    });
                                                    var productUnitCombo = new Ext.form.ComboBox({
                                                        store: dsProductUnitList,
                                                        displayField: 'UnitName',
                                                        valueField: 'UnitId',
                                                        triggerAction: 'all',
                                                        id: 'productUnitCombo',
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
                                                    var itemDeleter = new Extensive.grid.ItemDeleter();
                                                    var sm = new Ext.grid.CheckboxSelectionModel({ singleSelect: true });
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
        {
            id: 'WhpId',
            header: "仓位",
            dataIndex: 'WhpId',
            width: 20,
            //hidden: true,
            editor: warehousePosCombo,
            renderer: function(value, cellmeta, record, rowIndex, columnIndex, store) {
                //解决值显示问题
                //获取当前id="combo_process"的comboBox选择的值
                //alert(warehousePosCombo.valueField);
                var index = dsWarehousePosList.find(warehousePosCombo.valueField, value);
                var record = dsWarehousePosList.getAt(index);
                var displayText = "";
                // 如果下拉列表没有被选择，那么record也就不存在，这时候，返回传进来的value，
                // 而这个value就是grid的USER_REALNAME列的value，所以直接返回
                if (record == null) {
                    //返回默认值，
                    displayText = value;
                } else {
                    displayText = record.data.WhpName; //获取record中的数据集中的process_name字段的值
                }
                return displayText;
            }
        }, {
            id: 'ProductCode',
            header: "代码",
            dataIndex: 'ProductCode',
            width: 30,
            editor: new Ext.form.TextField({ allowBlank: false })
        },
        {
            id: 'ProductId',
            header: "商品",
            dataIndex: 'ProductId',
            width: 65,
            editor: productCombo,
            renderer: function(value, cellmeta, record, rowIndex, columnIndex, store) {
                //解决值显示问题
                //获取当前id="combo_process"的comboBox选择的值
                //alert(value);
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
                    //alert(record.data.ProductName + "--" + record.data.ProductId);
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
            width: 30,
            editor: productSpecCombo,
            renderer: function(value, cellmeta, record, rowIndex, columnIndex, store) {
                //解决值显示问题
                //获取当前id="combo_process"的comboBox选择的值
                var index = dsProductSpecList.findBy(function(record, id) {
                    return record.get(productCombo.valueField) == value;
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
            width: 20,
            editor: productUnitCombo,
            renderer: function(value, cellmeta, record, rowIndex, columnIndex, store) {
                //解决值显示问题
                //获取当前id="combo_process"的comboBox选择的值
                var index = dsProductUnitList.findBy(function(record, id) {
                    return record.get(productCombo.valueField) == value;
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
            header: "价格",
            dataIndex: 'ProductPrice',
            width: 30,
            editor: new Ext.form.TextField({ allowBlank: false })
        }, {
            id: 'BookQty',
            header: "帐面数量",
            dataIndex: 'BookQty',
            width: 30,
            editor: new Ext.form.TextField({ allowBlank: false })
        }, {
            id: 'RealQty',
            header: "实收数量",
            dataIndex: 'RealQty',
            width: 30,
            editor: new Ext.form.TextField({ allowBlank: false })
        }, itemDeleter
    ]);
                                                    cm.defaultSortable = true;
                                                    var RowPattern_Purchase = Ext.data.Record.create([
                                                    //{ name: 'OrderDetailId', type: 'string' },
                                                       {name: 'WhpId', type: 'string' },
                                                       { name: 'ProductCode', type: 'string' },
                                                       { name: 'ProductId', type: 'string' },
                                                       { name: 'ProductSpec', type: 'string' },
                                                       { name: 'ProductUnit', type: 'string' },
                                                       { name: 'ProductPrice', type: 'string' },
                                                       { name: 'BookQty', type: 'string' },
                                                       { name: 'RealQty', type: 'string' }
                                                     ]);

                                                    var RowPattern = Ext.data.Record.create([
                                                       { name: 'OrderDetailId', type: 'string' },
                                                       { name: 'WhpId', type: 'string' },
                                                       { name: 'ProductCode', type: 'string' },
                                                       { name: 'ProductId', type: 'string' },
                                                       { name: 'ProductSpec', type: 'string' },
                                                       { name: 'ProductUnit', type: 'string' },
                                                       { name: 'ProductPrice', type: 'string' },
                                                       { name: 'BookQty', type: 'string' },
                                                       { name: 'RealQty', type: 'string' }
                                                     ]);

                                                    var dsInStockProductDetail;
                                                    if (dsInStockProductDetail == null) {
                                                        if (FromBillType == "W0201") {
                                                            dsInStockProductDetail = new Ext.data.Store
	                                                        ({
	                                                            url: 'frmInStockBill.aspx?method=getPurchaseOrderListInfo',
	                                                            reader: new Ext.data.JsonReader({
	                                                                totalProperty: 'totalProperty',
	                                                                root: 'root'
	                                                            }, RowPattern_Purchase)
	                                                        });
                                                        }
                                                        else {
                                                            dsInStockProductDetail = new Ext.data.Store
	                                                        ({
	                                                            url: 'frmInStockBill.aspx?method=getInStockProductDetailInfo',
	                                                            reader: new Ext.data.JsonReader({
	                                                                totalProperty: 'totalProperty',
	                                                                root: 'root'
	                                                            }, RowPattern)
	                                                        });
                                                        }
                                                    }
                                                    //grid
                                                    var userGrid = new Ext.grid.EditorGridPanel({
                                                        store: dsInStockProductDetail,
                                                        cm: cm,
                                                        selModel: itemDeleter,
                                                        layout: 'fit',
                                                        renderTo: 'userdatagrid',
                                                        width: '100%',
                                                        height: 200,
                                                        stripeRows: true,
                                                        frame: true,
                                                        //plugins:USER_ISLOCKEDColumn,  
                                                        clicksToEdit: 1,
                                                        viewConfig: {
                                                            columnsText: '显示的列',
                                                            scrollOffset: 20,
                                                            sortAscText: '升序',
                                                            sortDescText: '降序',
                                                            forceFit: true
                                                        }
                                                    });

                                                    inserNewBlankRow();

                                                    /*----------------tansportframe----------------*/
                                                    var transportForm = new Ext.FormPanel({
                                                        el: 'transport',
                                                        border: true, // 没有边框
                                                        labelAlign: 'left',
                                                        buttonAlign: 'right',
                                                        bodyStyle: 'padding:2px',
                                                        height: 90,
                                                        frame: true,
                                                        labelWidth: 55,
                                                        items: [{
                                                            layout: 'column',   //定义该元素为布局为列布局方式
                                                            border: false,
                                                            items: [{
                                                                columnWidth: .5,  //该列占用的宽度，标识为20％
                                                                layout: 'form',
                                                                border: false,
                                                                items: [{
                                                                    layout: 'column',
                                                                    columnWidth: .5,
                                                                    items: [{
                                                                        layout: 'fit',
                                                                        anchor: '95%',
                                                                        html: '运输类型:&nbsp;&nbsp;'
                                                                    }, {
                                                                        columnWidth: .25,
                                                                        items: [new Ext.form.Radio({
                                                                            id: 'None',
                                                                            name: 'TransType',
                                                                            anchor: '90%',
                                                                            checked: true,
                                                                            boxLabel: '无',
                                                                            inputValue: 'W0401'
                                                                        })]
                                                                    }, {
                                                                        columnWidth: .25,
                                                                        items: [new Ext.form.Radio({
                                                                            id: 'Car',
                                                                            name: 'TransType',
                                                                            anchor: '95%',
                                                                            boxLabel: '汽车',
                                                                            inputValue: 'W0402'
                                                                        })]
                                                                    }, {
                                                                        columnWidth: .25,
                                                                        items: [new Ext.form.Radio({
                                                                            id: 'Trian',
                                                                            name: 'TransType',
                                                                            anchor: '95%',
                                                                            boxLabel: '火车',
                                                                            inputValue: 'W0403'
                                                                        })]
                                                                    }, {
                                                                        columnWidth: .25,
                                                                        items: [new Ext.form.Radio({
                                                                            id: 'Ship',
                                                                            name: 'TransType',
                                                                            anchor: '95%',
                                                                            boxLabel: '船',
                                                                            inputValue: 'W0404'
                                                                        })]
}]
}]
                                                                    }, {
                                                                        columnWidth: .5,  //该列占用的宽度，标识为20％
                                                                        layout: 'form',
                                                                        border: false,
                                                                        items: [
                    {
                        layout: 'column',
                        columnWidth: .5,
                        items: [{
                            layout: 'fit',
                            anchor: '95%',
                            html: '装卸类型:&nbsp;&nbsp;'
                        }, {
                            columnWidth: .25,
                            items: [new Ext.form.Radio({
                                id: 'ZxNone',
                                name: 'LoadType',
                                anchor: '90%',
                                checked: true,
                                boxLabel: '无',
                                inputValue: 'W0301'
                            })]
                        }, {
                            columnWidth: .25,
                            items: [new Ext.form.Radio({
                                id: 'ZxCar',
                                name: 'LoadType',
                                anchor: '95%',
                                boxLabel: '卸汽车',
                                inputValue: 'W0302'
                            })]
                        }, {
                            columnWidth: .25,
                            items: [new Ext.form.Radio({
                                id: 'ZxTrian',
                                name: 'LoadType',
                                anchor: '95%',
                                boxLabel: '卸火车',
                                inputValue: 'W0303'
                            })]
                        }, {
                            columnWidth: .25,
                            items: [new Ext.form.Radio({
                                id: 'ZxShip',
                                name: 'LoadType',
                                anchor: '95%',
                                boxLabel: '卸船',
                                inputValue: 'W0304'
                            })]
}]
                        }
                  ]
                                                                    }
             ]
                                                                }, {//第二行
                                                                    layout: 'column',   //定义该元素为布局为列布局方式
                                                                    border: false,
                                                                    items: [{//左列
                                                                        columnWidth: .5, //xtype:"panel", labelWidth:50
                                                                        layout: 'column',
                                                                        border: false,
                                                                        items: [{
                                                                            columnWidth: .5,  //该列占用的宽度，标识为20％
                                                                            layout: 'form',
                                                                            border: false,
                                                                            items: [{
                                                                                xtype: 'textfield',
                                                                                fieldLabel: '运输单价',
                                                                                anchor: '95%',
                                                                                id: 'TransPrice',
                                                                                value: 0
}]
                                                                            }, {
                                                                                columnWidth: .5,  //该列占用的宽度，标识为20％
                                                                                layout: 'form',
                                                                                border: false,
                                                                                items: [{
                                                                                    xtype: 'textfield',
                                                                                    fieldLabel: '运输费用',
                                                                                    anchor: '95%',
                                                                                    id: 'TransAmount',
                                                                                    value: 0

}]
}]
                                                                                }, {//右列
                                                                                    columnWidth: .5, //xtype:"panel", labelWidth:50
                                                                                    layout: 'form',
                                                                                    border: false,
                                                                                    items: [{
                                                                                        columnWidth: .5,  //该列占用的宽度，标识为20％
                                                                                        layout: 'form',
                                                                                        border: false,
                                                                                        items: [{
                                                                                            xtype: 'combo',
                                                                                            fieldLabel: '装卸单位',
                                                                                            anchor: '80%',
                                                                                            id: 'LoadComId', //dsLoadCompanyList
                                                                                            displayField: 'Name',
                                                                                            valueField: 'Id',
                                                                                            editable: false,
                                                                                            store: dsLoadCompanyList,
                                                                                            mode: 'local',
                                                                                            triggerAction: 'all'
}]
}]
}]
                                                                                        }, {//第三行
                                                                                            layout: 'column',   //定义该元素为布局为列布局方式
                                                                                            border: false,
                                                                                            items: [{//左列
                                                                                                columnWidth: .5, //xtype:"panel", labelWidth:50
                                                                                                layout: 'form',
                                                                                                border: false,
                                                                                                html: '&nbsp'
                                                                                            }, {//右列
                                                                                                columnWidth: .5, //xtype:"panel", labelWidth:50
                                                                                                layout: 'column',
                                                                                                border: false,
                                                                                                items: [{
                                                                                                    columnWidth: .5,  //该列占用的宽度，标识为20％
                                                                                                    layout: 'form',
                                                                                                    border: false,
                                                                                                    items: [{
                                                                                                        xtype: 'numberfield',
                                                                                                        fieldLabel: '装卸单价',
                                                                                                        anchor: '95%',
                                                                                                        id: 'LoadPrice',
                                                                                                        value: 0
}]
                                                                                                    }, {
                                                                                                        columnWidth: .5,  //该列占用的宽度，标识为20％
                                                                                                        layout: 'form',
                                                                                                        border: false,
                                                                                                        items: [{
                                                                                                            xtype: 'numberfield',
                                                                                                            fieldLabel: '装卸费用',
                                                                                                            anchor: '95%',
                                                                                                            name: 'LoadAmount',
                                                                                                            id: 'LoadAmount',
                                                                                                            value: 0
}]
}]
}]
}]
                                                                                                        });
                                                                                                        transportForm.render();
                                                                                                        /*----------------tansportframe----------------*/
                                                                                                        /*----------------footerframe----------------*/
                                                                                                        var footerForm = new Ext.FormPanel({
                                                                                                            el: 'footer',
                                                                                                            border: true, // 没有边框
                                                                                                            labelAlign: 'left',
                                                                                                            buttonAlign: 'center',
                                                                                                            bodyStyle: 'padding:2px',
                                                                                                            height: 105,
                                                                                                            frame: true,
                                                                                                            labelWidth: 55,
                                                                                                            items: [{//第一行
                                                                                                                layout: 'column',   //定义该元素为布局为列布局方式
                                                                                                                border: false,
                                                                                                                items: [{
                                                                                                                    columnWidth: .3,  //该列占用的宽度，标识为20％
                                                                                                                    layout: 'form',
                                                                                                                    border: false,
                                                                                                                    items: [{
                                                                                                                        xtype: 'textfield',
                                                                                                                        fieldLabel: '车船号',
                                                                                                                        readOnly: false,
                                                                                                                        id: 'CarBoatNo',
                                                                                                                        name: 'CarBoatNo'
}]
                                                                                                                    }, {
                                                                                                                        columnWidth: .4,  //该列占用的宽度，标识为30％
                                                                                                                        layout: 'form',
                                                                                                                        border: false,
                                                                                                                        html: '&nbsp'
                                                                                                                    }, {
                                                                                                                        columnWidth: .3,  //该列占用的宽度，标识为20％
                                                                                                                        layout: 'form',
                                                                                                                        border: false,
                                                                                                                        items: [{
                                                                                                                            xtype: 'textfield',
                                                                                                                            //readOnly:true,
                                                                                                                            disabled: false,
                                                                                                                            fieldLabel: '备注',
                                                                                                                            anchor: '95%',
                                                                                                                            name: 'Remark',
                                                                                                                            id: 'Remark'
}]
}]
                                                                                                                        }, {//第二行
                                                                                                                            layout: 'column',   //定义该元素为布局为列布局方式
                                                                                                                            border: false,
                                                                                                                            items: [{
                                                                                                                                columnWidth: .3,  //该列占用的宽度，标识为20％
                                                                                                                                layout: 'form',
                                                                                                                                border: false,
                                                                                                                                items: [{
                                                                                                                                    xtype: 'textfield',
                                                                                                                                    fieldLabel: '操作员',
                                                                                                                                    readOnly: false,
                                                                                                                                    id: 'OperId',
                                                                                                                                    name: 'OperId'
}]
                                                                                                                                }, {
                                                                                                                                    columnWidth: .4,  //该列占用的宽度，标识为30％
                                                                                                                                    layout: 'form',
                                                                                                                                    border: false,
                                                                                                                                    html: '&nbsp'
                                                                                                                                }, {
                                                                                                                                    columnWidth: .3,  //该列占用的宽度，标识为20％
                                                                                                                                    layout: 'form',
                                                                                                                                    border: false,
                                                                                                                                    items: [{
                                                                                                                                        xtype: 'datefield',
                                                                                                                                        //readOnly:true,
                                                                                                                                        disabled: true,
                                                                                                                                        fieldLabel: '进仓日期',
                                                                                                                                        anchor: '95%',
                                                                                                                                        format: 'Y年m月d日',
                                                                                                                                        value: (new Date()),
                                                                                                                                        id: 'CreateDate',
                                                                                                                                        name: 'CreateDate'
}]
}]
}],
                                                                                                                                        buttons: [{
                                                                                                                                            text: "保存",
                                                                                                                                            scope: this,
                                                                                                                                            handler: function() {
                                                                                                                                                json = "";
                                                                                                                                                dsInStockProductDetail.each(function(dsInStockProductDetail) {
                                                                                                                                                    json += Ext.util.JSON.encode(dsInStockProductDetail.data) + ',';
                                                                                                                                                });
                                                                                                                                                json = json.substring(0, json.length - 1);
                                                                                                                                                //然后传入参数保存
                                                                                                                                                alert(json);
                                                                                                                                                Ext.Ajax.request({
                                                                                                                                                    url: 'frmInStockBill.aspx?method=SaveInStockOrder',
                                                                                                                                                    method: 'POST',
                                                                                                                                                    timeout: 300000,
                                                                                                                                                    params: {
                                                                                                                                                        //主参数
                                                                                                                                                        OrderId: Ext.getCmp('OrderId').getValue(),
                                                                                                                                                        WhId: Ext.getCmp('WhId').getValue(),
                                                                                                                                                        SupplierId: Ext.getCmp('SupplierId').getValue(),
                                                                                                                                                        CreateDate: Ext.getCmp('CreateDate').getValue(),
                                                                                                                                                        Remark: Ext.getCmp('Remark').getValue(),
                                                                                                                                                        OrgId: 1, //Ext.getCmp('OrgId').getValue(),
                                                                                                                                                        OperId: Ext.getCmp('OperId').getValue(),
                                                                                                                                                        FromBillType: Ext.getCmp('FromBillType').getValue(),
                                                                                                                                                        TransAmount: Ext.getCmp('TransAmount').getValue(),
                                                                                                                                                        LoadAmount: Ext.getCmp('LoadAmount').getValue(),
                                                                                                                                                        TransType: getRadioValue('TransType'),
                                                                                                                                                        LoadType: getRadioValue('LoadType'),
                                                                                                                                                        LoadComId: Ext.getCmp('LoadComId').getValue(),
                                                                                                                                                        CarBoatNo: Ext.getCmp('CarBoatNo').getValue(),
                                                                                                                                                        LoadPrice: Ext.getCmp('LoadPrice').getValue(),
                                                                                                                                                        TransPrice: Ext.getCmp('TransPrice').getValue(),
                                                                                                                                                        IsInitBill: Ext.getCmp('IsInitBill').getValue(),
                                                                                                                                                        IsRedWord: getRadioValue('IsRedWord'),
                                                                                                                                                        WarehouseAdmin: Ext.getCmp('WarehouseAdmin').getValue(),
                                                                                                                                                        FromBillId: Ext.getCmp('FromBillId').getValue(),
                                                                                                                                                        //明细参数
                                                                                                                                                        DetailInfo: json
                                                                                                                                                    },
                                                                                                                                                    success: function(resp, opts) {
                                                                                                                                                        var responseData = Ext.decode(resp.responseText);
                                                                                                                                                        if (responseData.success) {
                                                                                                                                                            Ext.Msg.alert("提示", "保存成功！");
                                                                                                                                                        }
                                                                                                                                                        else {
                                                                                                                                                            Ext.Msg.alert("提示", "保存失败，原因" + responseData.data.msg);
                                                                                                                                                        }

                                                                                                                                                    }
                     , failure: function(resp, opts) {
                         Ext.Msg.alert("提示", "保存失败，请检查网络！");

                     }
                                                                                                                                                });

                                                                                                                                            }
                                                                                                                                        },
         {
             text: "打印",
             scope: this,
             handler: function() {
                 alert(getRadioValue('LoadType'));
             }
}]
                                                                                                                                    });
                                                                                                                                    footerForm.render();
                                                                                                                                    /*----------------footerframe----------------*/
                                                                                                                                    function getRadioValue(radioName) {
                                                                                                                                        var radios = document.getElementsByName(radioName);
                                                                                                                                        if (radios != null) {
                                                                                                                                            for (var i = 0; i < radios.length; i++) {
                                                                                                                                                //alert(radios.item(i).checked + '---' + radios.item(i).value);
                                                                                                                                                var obj = radios.item(i);
                                                                                                                                                if (obj.checked) {
                                                                                                                                                    return obj.value;
                                                                                                                                                }
                                                                                                                                            }
                                                                                                                                        }
                                                                                                                                        return radios.item(0).value;
                                                                                                                                    }
                                                                                                                                    function setRadioValue(radioName, inputValue) {
                                                                                                                                        var radios = document.getElementsByName(radioName);
                                                                                                                                        if (radios != null) return;
                                                                                                                                        for (var i = 0; i < radios.length; i++) {
                                                                                                                                            var obj = radios.item(i);
                                                                                                                                            if (inputValue == obj.value) {
                                                                                                                                                obj.checked = true;
                                                                                                                                            }
                                                                                                                                        }
                                                                                                                                    }
                                                                                                                                    //界面赋初始值
                                                                                                                                    function setFormValue() {
                                                                                                                                        Ext.Ajax.request({
                                                                                                                                            url: 'frmInStockBill.aspx?method=getPurchaseOrderInfo',
                                                                                                                                            params: {
                                                                                                                                                OrderId: OrderId
                                                                                                                                            },
                                                                                                                                            success: function(resp, opts) {
                                                                                                                                                var data = Ext.util.JSON.decode(resp.responseText);
                                                                                                                                                //Ext.getCmp("FromBillId").setValue(OrderId);
                                                                                                                                                Ext.getCmp("OrgId").setValue(data.OrgId);
                                                                                                                                                Ext.getCmp("WhId").setValue(data.WhId);
                                                                                                                                                dsWarehousePosList.load({
                                                                                                                                                    params: {
                                                                                                                                                        WhId: data.WhId
                                                                                                                                                    }
                                                                                                                                                });

                                                                                                                                                //alert(FromBillType); alert(data.SupplierId);
                                                                                                                                                Ext.getCmp("OperId").setValue(data.OperId);
                                                                                                                                                //Ext.getCmp("Status").setValue(data.Status);
                                                                                                                                                Ext.getCmp("SupplierId").setValue(data.SupplierId);
                                                                                                                                                Ext.getCmp("FromBillType").setValue(FromBillType);


                                                                                                                                                //Ext.getCmp("InventoryDate").setValue((new Date(data.InventoryDate.replace(/-/g, "/")))); ;
                                                                                                                                                //Ext.getCmp("Remark").setValue(data.Remark);
                                                                                                                                            },
                                                                                                                                            failure: function(resp, opts) {
                                                                                                                                                Ext.Msg.alert("提示", "获取进仓信息失败！");
                                                                                                                                            }
                                                                                                                                        });
                                                                                                                                    }
                                                                                                                                    Ext.getCmp("FromBillId").setValue(OrderId);
                                                                                                                                    alert(Ext.getCmp("FromBillId").getValue());
                                                                                                                                    alert(OrderId);
                                                                                                                                    if (OrderId > 0) {
                                                                                                                                        setFormValue();
                                                                                                                                        dsInStockProductDetail.load({
                                                                                                                                            params: { start: 0,
                                                                                                                                                limit: 100,
                                                                                                                                                OrderId: OrderId
                                                                                                                                            },
                                                                                                                                            callback: function(r, options, success) {
                                                                                                                                                if (success == true) {
                                                                                                                                                    inserNewBlankRow();
                                                                                                                                                    //                        if (Ext.getCmp("Status").getValue() == 1) {
                                                                                                                                                    //                            Ext.getCmp("saveButton").setDisabled(true);
                                                                                                                                                    //                            Ext.getCmp("commitButton").setDisabled(true);
                                                                                                                                                    //                            userGrid.disable();
                                                                                                                                                    //                        }
                                                                                                                                                }
                                                                                                                                            }
                                                                                                                                        });
                                                                                                                                    }

                                                                                                                                });

</script>

</html>
