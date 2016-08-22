<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmAllotOrderEdit.aspx.cs" Inherits="WMS_frmAllotOrderEdit" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
 
<html>
<head>
<title>仓库调拨单编辑页面</title><meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<link rel="stylesheet" type="text/css" href="../ext3/resources/css/ext-all.css" />
<script type="text/javascript" src="../ext3/adapter/ext/ext-base.js"></script>
<script type="text/javascript" src="../ext3/ext-all.js"></script>
<script type="text/javascript" src="../ext3/example/TabCloseMenu.js" charset="gb2312"></script>
<script type="text/javascript" src="../ext3/example/ItemDeleter.js"></script>
<script type="text/javascript" src="../js/operateResp.js"></script>
<script type="text/javascript" src="../ext3/src/locale/ext-lang-zh_CN.js"></script>
<script type="text/javascript" src="../js/ProductShowCommon.js"></script>
<style type="text/css">
.extensive-remove {
background-image: url(../Theme/1/images/extjs/customer/cross.gif) ! important;
}
.x-grid-back-blue { 
background: #C3D9FF; 
}
.x-item-disabled-ie {
    color:white;cursor:default;opacity:.99;-moz-opacity:.99; -ms-filter:"progid:DXImageTransform.Microsoft.Alpha(Opacity=99)";
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
    var OperType = args["type"];


    var dsAllotOrderProduct;

    Ext.onReady(function() {
        var dsWarehouseOutList; 
        if (dsWarehouseOutList == null) { //防止重复加载
            dsWarehouseOutList = new Ext.data.JsonStore({
                totalProperty: "result",
                root: "root",
                url: 'frmAllotDirectOrderEdit.aspx?method=getWarehouseListByOrg',
                fields: ['WhId', 'WhName']
            });
            dsWarehouseOutList.baseParams.forbusi = true;

        }
        var dsWarehouseInList; 
        if (dsWarehouseInList == null) { //防止重复加载
            dsWarehouseInList = new Ext.data.JsonStore({
                totalProperty: "result",
                root: "root",
                url: 'frmAllotDirectOrderEdit.aspx?method=getWarehouseListByOrg',
                fields: ['WhId', 'WhName']
            });
            dsWarehouseInList.baseParams.forbusi = true;

        }
        var curOrgId = <% =ZJSIG.UIProcess.ADM.UIAdmUser.OrgID(this)%>;
        var AllotOrderForm = new Ext.form.FormPanel({
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
                        xtype: 'hidden',
                        fieldLabel: '订单号',
                        name: 'OrderId',
                        id: 'OrderId',
                        hide: true
                    }
                    ,{
                        xtype: 'hidden',
                        fieldLabel: '1',
                        name: 'IsActive',
                        id: 'IsActive',
                        hide: true
                    }
                    , {
                        xtype: 'hidden',
                        fieldLabel: '组织',
                        name: 'OrgId',
                        id: 'OrgId',
                        hide: true,
                        value:<%=ZJSIG.UIProcess.ADM.UIAdmUser.DeptID(this)%>
                    }
                    , {
                        xtype: 'combo',
                        fieldLabel: '调入仓库',
                        columnWidth: 1,
                        anchor: '95%',
                        name: 'InWhId',
                        id: 'InWhId',
                        displayField: 'WhName',
                        valueField: 'WhId',
                        editable: false,
                        store: dsWarehouseInList,
                        mode: 'local',
                        triggerAction: 'all',
		    	        disabledClass: Ext.isIE ? 'x-item-disabled-ie' : 'x-item-disabled',
                        listeners: {
                            select: function(combo, record, index) {
                                var inWhId = Ext.getCmp("InWhId").getValue();
                                var outWhId = Ext.getCmp("OutWhId").getValue();
                                if(inWhId == outWhId){
                                    Ext.Msg.alert("提示","调入仓库不能和调出仓库相同！");
                                    Ext.getCmp("InWhId").setValue("");
                                }
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
                    store:dsOperationList,
			        mode:'local',
			        displayField:'EmpName',
			        valueField:'EmpId',
			        //triggerAction: 'all',
			        editable:false,
		    	    disabledClass: Ext.isIE ? 'x-item-disabled-ie' : 'x-item-disabled',
			        value:<%=ZJSIG.UIProcess.ADM.UIAdmUser.EmployeeID(this) %>,
			        disabled:true
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
                        xtype: 'combo',
                        fieldLabel: '调出仓库',
                        columnWidth: 1,
                        anchor: '95%',
                        name: 'OutWhId',
                        id: 'OutWhId',
                        displayField: 'WhName',
                        valueField: 'WhId',
                        editable: false,
                        store: dsWarehouseAdminList,
                        mode: 'local',
		    	        disabledClass: Ext.isIE ? 'x-item-disabled-ie' : 'x-item-disabled',
                        triggerAction: 'all',
                        //value:dsWarehouseOutList.getRange()[0].data.WhId,
                        listeners: {
                        //                            select: function(combo, record, index) {
                        //                                var curWhId = Ext.getCmp("OutWhId").getValue();
                        //                                dsWarehousePosList.load({
                        //                                    params: {
                        //                                        WhId: curWhId
                        //                                    }
                        //                                });
                        //                            }
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
                        fieldLabel: '驾驶员',
                        columnWidth: 1,
                        anchor: '95%',
                        name: 'DriverId',
                        id: 'DriverId',
                        displayField: 'DriverName',
                        valueField: 'DriverId',
                        typeAhead: false,
                        triggerAction: 'all',
                        lazyRender: true,
                        editable: true,
                        store:dsDriverList,
		    	        disabledClass: Ext.isIE ? 'x-item-disabled-ie' : 'x-item-disabled',
                        mode: 'local'
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
                        fieldLabel: '创建时间',
                        columnWidth: 1,
                        anchor: '95%',
                        name: 'CreateDate',
                        id: 'CreateDate',
                        format: 'Y年m月d日',
                        value: new Date(),
                        disabled:true
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
                        fieldLabel: '出仓状态',
                        columnWidth: 1,
                        anchor: '95%',
                        name: 'OutStatus',
                        id: 'OutStatus',
                        transform: 'comboStatus',
                        //readOnly: true,
                        disabled: true,
                        typeAhead: false,
                        triggerAction: 'all',
                        lazyRender: true,
		    	        disabledClass: Ext.isIE ? 'x-item-disabled-ie' : 'x-item-disabled',
                        editable: false
                    }
                ]
            }
            ]
        },
        {
            layout: 'column',   //定义该元素为布局为列布局方式
            border: false,
            items: [{
                columnWidth: 1,  //该列占用的宽度，标识为20％
                layout: 'form',
                border: false,
                items: [{
                    xtype: 'textarea',
                    fieldLabel: '备注',
                    columnWidth: 1,
                    anchor: '100%',
                    name: 'Remark',
                    id: 'Remark'
}]
}]
}]
        });


        //alert(Ext.getCmp("OperId").getValue());
        //-------------------Form结束-----------------------------



        //-------------------Grid Start-----------------------------

        function inserNewBlankRow() {
            var rowCount = userGrid.getStore().getCount();
            //alert(rowCount);
            var insertPos = parseInt(rowCount);
            var addRow = new RowPattern({
                //WhpId: '',
                ProductId: '',
                ProductCode: '',
                ProductUnit: '',
                ProductSpec: '',
                ProductPrice: '',
                OutQty: ''//,
                //CREATE_DATE: (new Date()).clearTime() 
            });
            userGrid.stopEditing();
            //增加一新行
            if (insertPos > 0) {
                var rowIndex = dsAllotOrderProduct.insert(insertPos, addRow);
                userGrid.startEditing(insertPos, 0);
            }
            else {
                var rowIndex = dsAllotOrderProduct.insert(0, addRow);
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

        var dsProductCostPrice;
        if( dsProductCostPrice == null){
            dsProductCostPrice = new Ext.data.Store
            ({
                url: 'frmAllotOrderEdit.aspx?method=getProductCostPrice',
                reader: new Ext.data.JsonReader({
                    totalProperty: 'totalProperty',
                    root: 'root'
                }, [
	                {
	                    name: 'ProductPrice'
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
            //pageSize: 5,
            //minChars: 2,
            //hideTrigger: true,
            typeAhead: true,
            mode: 'local',
            emptyText: '',
            selectOnFocus: false,
            editable: true,
            onSelect: function(record) {
                var sm = userGrid.getSelectionModel().getSelected();
                var curWhId = Ext.getCmp("OutWhId").getValue();
                if(curWhId < 1){
                    alert("请先选择出仓仓库！");
                    return;
                }
                sm.set('ProductCode', record.data.ProductNo);
                sm.set('ProductSpec', record.data.SpecificationsText);
                sm.set('ProductUnit', record.data.UnitText); 
                sm.set('ProductId', record.data.ProductId);
                sm.set('UnitId',record.data.UnitId);
                addNewBlankRow();
                
                dsProductCostPrice.load({
                    params: {
                        WhId: curWhId,
                        ProductId:record.data.ProductId
                    },
                    callback: function(r, options, success) {
                        if (success == true) {
                        var price = dsProductCostPrice.getAt(0).get("ProductPrice");
                        sm.set('ProductPrice', price);
                        }
                    }
                });
            }
        });
        
        getProductUrl ="../Scm/frmOrderDtl.aspx";
        createProductList();
        this.setProductFilter=function()
        {
            dsProducts.baseParams.WhId=Ext.getCmp('OutWhId').getValue();
        };
        this.selectedEvent =function (record)
        {
            var curWhId = Ext.getCmp("OutWhId").getValue();
            if(curWhId < 1){
                alert("请先选择出仓仓库！");
                return;
            }
            var sm = userGrid.getSelectionModel().getSelected(); 
            productText.setValue(  record.data.ProductNo);                         
            sm.set('ProductCode', record.data.ProductNo);
            sm.set('ProductName', record.data.ProductName);
            sm.set('ProductSpec', record.data.SpecificationsText);
            sm.set('ProductUnit', record.data.UnitText); 
            sm.set('ProductId', record.data.ProductId);
            sm.set('UnitId',record.data.Unit);
            addNewBlankRow();
            
            dsProductCostPrice.load({
                params: {
                    WhId: curWhId,
                    ProductId:record.data.ProductId
                },
                callback: function(r, options, success) {
                    if (success == true) {
                    var price = dsProductCostPrice.getAt(0).get("ProductPrice");
                    sm.set('ProductPrice', price);
                    }
                }
            });
        }  
        
        
        setProductSpec = function(record)
        {
            var sm = userGrid.getSelectionModel().getSelected();
            sm.set('ProductSpec', record.data.UnitSpec);
            UnitCombo.setValue(record.data.UnitId);
            UnitCombo.collapse();
            addNewBlankRow();
        }
        
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
            id: 'ProductCode',
            header: "代码",
            dataIndex: 'ProductCode',
            width: 30,
            renderer: function(v, m) {
                m.css = 'x-grid-back-blue';
                return v;
            },
            editor:productText
//            editor: new Ext.form.TextField({ 
//                allowBlank: false,
//                enableKeyEvents: true, 
//                initEvents: function() {  
//                    var keyPress = function(e){  
//                        if (e.getKey() == e.ENTER) {   
//                            var curWhId = Ext.getCmp("OutWhId").getValue();
//                            if(curWhId < 1){
//                                alert("请先选择出仓仓库！");
//                                return;
//                            }
//                            var textValue = this.getValue();
//                            var index = dsProductList.findBy(
//                                function(record, id) {
//                                    return record.get('ProductNo') == textValue;
//                                }
//                            );
//                            var record = dsProductList.getAt(index);
//                            var sm = userGrid.getSelectionModel().getSelected();                            
//                            sm.set('ProductCode', record.data.ProductNo);
//                            sm.set('ProductName', record.data.ProductName);
//                            sm.set('ProductSpec', record.data.SpecificationsText);
//                            sm.set('ProductUnit', record.data.UnitText); 
//                            sm.set('ProductId', record.data.ProductId);
//                            addNewBlankRow();
//                            
//                            dsProductCostPrice.load({
//                                params: {
//                                    WhId: curWhId,
//                                    ProductId:record.data.ProductId
//                                },
//                                callback: function(r, options, success) {
//                                    if (success == true) {
//                                    var price = dsProductCostPrice.getAt(0).get("ProductPrice");
//                                    sm.set('ProductPrice', price);
//                                    }
//                                }
//                            });
//                        }  
//                    };  
//                    this.el.on("keypress", keyPress, this);  
//                }  
//             })
        },
        {
            id: 'ProductName',
            header: "商品",
            dataIndex: 'ProductName',
            width: 65
        },
        {
            id: 'ProductId',
            header: "商品",
            dataIndex: 'ProductId',
            hidden:true,
            width: 65/*,
            editor: productCombo ,
            renderer: function(value, cellmeta, record, rowIndex, columnIndex, store) {
              
                //解决值显示问题
                //获取当前id="combo_process"的comboBox选择的值
                var index = dsProductList.findBy(
                    function(record, id) {
                        return record.get(productCombo.valueField) == value;
                    }
                );
                var record = dsProductList.getAt(index);
                var displayText = "";
                // 如果下拉列表没有被选择，那么record也就不存在，这时候，返回传进来的value，
                // 而这个value就是grid的USER_REALNAME列的value，所以直接返回
                if (record == null) {
                    //返回默认值，
                    displayText = value;
                } else {
                    displayText = record.data.ProductName; //获取record中的数据集中的process_name字段的值
                }
                 cellmeta.css = 'x-grid-back-blue';
                return displayText;
               
            } */
        },
            
        {
            id: "UnitId",
            header: "单位",
            dataIndex: "UnitId",
            width: 20,
            editor:UnitCombo,
            renderer:function(value){
                return getUnitName(value,dsProductUnitList);
            }
             /*,
            editor: productUnitCombo,
            renderer: function(value, cellmeta, record, rowIndex, columnIndex, store) {
                //解决值显示问题
                //获取当前id="combo_process"的comboBox选择的值
                var index = dsProductUnitList.find(productUnitCombo.valueField, value);
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
            }*/
        }
        , {
            id: 'ProductSpec',
            header: "规格",
            dataIndex: 'ProductSpec',
            width: 30/*,
            editor: productSpecCombo,
            renderer: function(value, cellmeta, record, rowIndex, columnIndex, store) {
                //解决值显示问题
                //获取当前id="combo_process"的comboBox选择的值
                var index = dsProductSpecList.find(productSpecCombo.valueField, value);
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
            }*/
        }, {
            id: 'ProductPrice',
            header: "单价",
            dataIndex: 'ProductPrice',
            width: 20,
            renderer: function(v, m) {
                m.css = 'x-grid-back-blue';
                return v;
            },
            editor: new Ext.form.TextField({ 
                allowBlank: false ,
	            align: 'right',
                decimalPrecision:8, 
                listeners: {  
    	            'focus':function(){  
        		        this.selectText();
        		        selectRecord = userGrid.getSelectionModel().getSelected(); 
    	            }}})
        }, {
            id: 'OutQty',
            header: "数量",
            dataIndex: 'OutQty',
            width: 20,
            renderer: function(v, m) {
                m.css = 'x-grid-back-blue';
                return v;
            },
            editor: new Ext.form.TextField({ 
                allowBlank: false ,
	            align: 'right',
                decimalPrecision:6, 
                listeners: {  
    	            'focus':function(){  
        		        this.selectText();
        		        selectRecord = userGrid.getSelectionModel().getSelected(); 
    	            }} })
        }, new Extensive.grid.ItemDeleter()
        ]);
    cm.defaultSortable = true;

    var RowPattern = Ext.data.Record.create([
           { name: 'OrderDetailId', type: 'string' },
           { name: 'ProductId', type: 'string' },
           { name: 'ProductName', type: 'string' },
           { name: 'ProductCode', type: 'string' },
           { name: 'ProductUnit', type: 'string' },
           { name: 'ProductSpec', type: 'string' },
           { name: 'ProductPrice', type: 'string' },
           { name: 'OutQty', type: 'string' },
           { name: 'UnitId', type: 'string' }
          ]);

    
    if (dsAllotOrderProduct == null) {
        dsAllotOrderProduct = new Ext.data.Store
	        ({
	            url: 'frmAllotOrderEdit.aspx?method=getAllotOutOrderProductList',
	            reader: new Ext.data.JsonReader({
	                totalProperty: 'totalProperty',
	                root: 'root'
	            }, RowPattern)
	        });
    }
    var userGrid = new Ext.grid.EditorGridPanel({
        store: dsAllotOrderProduct,
        cm: cm,
        selModel: new Extensive.grid.ItemDeleter(),
        layout: 'fit',
        renderTo: 'divGrid',
        width: '100%',
        height: 200,
        stripeRows: true,
        frame: true,
        clicksToEdit: 1,
        viewConfig: {
            columnsText: '显示的列',
            scrollOffset: 20,
            sortAscText: '升序',
            sortDescText: '降序',
            forceFit: true
        }
    });
    
    userGrid.on("beforeedit",beforeEdit,userGrid);
    /*------开始界面数据的函数 Start---------------*/
    function setFormValue() {
        Ext.Ajax.request({
            url: 'frmAllotOrderEdit.aspx?method=getAllotOrderInfo',
            params: {
                OrderId: OrderId
            },
            success: function(resp, opts) {
                var data = Ext.util.JSON.decode(resp.responseText);
                Ext.getCmp("OrderId").setValue(data.OrderId);
                Ext.getCmp("OrgId").setValue(data.OrgId);
                //Ext.getCmp("OutWhId").setValue(data.OutWhId);
                //Ext.getCmp("InWhId").setValue(data.InWhId);
                Ext.getCmp("OperId").setValue(data.OperId);
                Ext.getCmp("OutStatus").setValue(data.OutStatus);
                Ext.getCmp("CreateDate").setValue((new Date(data.CreateDate.replace(/-/g, "/")))); ;
                Ext.getCmp("Remark").setValue(data.Remark);
                Ext.getCmp("DriverId").setValue(data.DriverId);
                Ext.getCmp("IsActive").setValue(data.IsActive);
                dsWarehouseOutList.load({
                params:{OrgId:data.OutOrg},
                callback: function(r, options, success) {
                    if (success == true) {
                        if(data.OutWhId>0)
                           Ext.getCmp("OutWhId").setValue(data.OutWhId);
                        }
                    }
                });
                dsWarehouseInList.load({
                params:{OrgId:data.InOrg},
                    callback: function(r, options, success) {
                        if (success == true) {
                           if(data.InWhId>0)
                            Ext.getCmp("InWhId").setValue(data.InWhId);
                        }
                    }
                });
            },
            failure: function(resp, opts) {
                Ext.Msg.alert("提示", "获取调拨单信息失败！");
            }
        });
    }
    /*------开始界面数据的函数 End---------------*/
    //-------------------Grid End-------------------------------
    inserNewBlankRow(); //Grid默认初始行
    /*----------------footerframe----------------*/
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
        buttons: [{
            text: "保存",
            scope: this,
            id: 'saveButton',
            handler: function() {
                if(!checkUIData()) return;
                 
                json = "";
                dsAllotOrderProduct.each(function(dsAllotOrderProduct) {
                    json += Ext.util.JSON.encode(dsAllotOrderProduct.data) + ',';
                });
                json = json.substring(0, json.length - 1);
                //alert(json);
                //alert(Ext.getCmp('InventoryDate').getValue());
                //然后传入参数保存

                Ext.Ajax.request({
                    url: 'frmAllotOrderEdit.aspx?method=saveAllotOrderInfo',
                    method: 'POST',
                    params: {
                        //主参数
                        OutWhId: Ext.getCmp("OutWhId").getValue(),
                        InWhId: Ext.getCmp('InWhId').getValue(),
                        OperId: Ext.getCmp('OperId').getValue(),
                        CreateDate: Ext.util.Format.date(Ext.getCmp('CreateDate').getValue(),'Y/m/d'),
                        Remark: Ext.getCmp('Remark').getValue(),
                        OutStatus: Ext.getCmp("OutStatus").getValue(),
                        OrderId: Ext.getCmp("OrderId").getValue(),
                        DriverId: Ext.getCmp("DriverId").getValue(),
                        IsActive: Ext.getCmp("IsActive").getValue(),
                        //明细参数
                        DetailInfo: json
                    },
                    success: function(resp, opts) {
                       if(checkParentExtMessage(resp,parent))
                        {
                            //Ext.getCmp("saveButton").setDisabled(true);
                            parent.uploadAllotOrderWindow.hide();  
                        }
                    }
                });
            }
        },
        //        {
        //            text: "提交",
        //            scope: this,
        //            id: 'commitButton',
        //            handler: function() {
        //                Ext.MessageBox.confirm("提示信息", "是否真的要提交该仓库初始化信息？", function callBack(id) {
        //                    //判断是否删除数据
        //                    if (id == "yes") {
        //                        json = "";
        //                        dsAllotOrderProduct.each(function(dsAllotOrderProduct) {
        //                            json += Ext.util.JSON.encode(dsAllotOrderProduct.data) + ',';
        //                        });
        //                        json = json.substring(0, json.length - 1);
        //                        alert(json);
        //                        //页面提交
        //                        Ext.Ajax.request({
        //                            url: 'frmInitWarehouseEdit.aspx?method=saveInitWarehouseInfo&isCommit=1',
        //                            method: 'POST',
        //                            params: {
        //                                //主参数
        //                                //OrderDetailId:Ext.getCmp("OrderDetailId").getValue(),
        //                                WhId: Ext.getCmp('WhId').getValue(),
        //                                OperId: Ext.getCmp('OperId').getValue(),
        //                                InventoryDate: Ext.getCmp('InventoryDate').getValue().toLocaleDateString(),
        //                                Remark: Ext.getCmp('Remark').getValue(),
        //                                Status: Ext.getCmp("Status").getValue(),
        //                                OrderId: Ext.getCmp("OrderId").getValue(),
        //                                //明细参数
        //                                DetailInfo: json
        //                            },
        //                            success: function(resp, opts) {
        //                                Ext.Msg.alert("提示", "数据初始化成功！");
        //                            },
        //                            failure: function(resp, opts) {
        //                                Ext.Msg.alert("提示", "数据初始化失败！");
        //                            }
        //                        });
        //                    }
        //                });
        //            }
        //        },
                         {
                         text: "取消",
                         scope: this,
                         handler: function() {
                             parent.uploadAllotOrderWindow.hide();
                         }
}]
    });
    footerForm.render();
    Ext.getCmp("OrderId").setValue(OrderId);

    if (OrderId > 0) {
        setFormValue();
        dsAllotOrderProduct.load({
            params: { start: 0,
                limit: 10,
                OrderId: OrderId
            },
            callback: function(r, options, success) {
                if (success == true) {
                    inserNewBlankRow();
                    
                    
                }
            }
        });
    } else {
        AllotOrderForm.getForm().reset();
        dsAllotOrderProduct.removeAll();
//        dsWarehouseOutList.load({params:{OrgId:curOrgId},callback:function(v){
//        Ext.getCmp("OutWhId").setValue(dsWarehouseOutList.getRange()[0].data.WhId);
//        }});
        dsWarehouseInList.load({params:{OrgId:curOrgId}});
        
        inserNewBlankRow();
    }
var columnCount = userGrid.getColumnModel().getColumnCount();
for (var i = 0; i < columnCount; i++) {
    userGrid.getColumnModel().setEditable(i, false);
}
if(OperType != "look"){
    userGrid.getColumnModel().setEditable(2, true);
    //userGrid.getColumnModel().setEditable(3, true);
    userGrid.getColumnModel().setEditable(7, true)
    userGrid.getColumnModel().setEditable(8, true); 
    userGrid.getColumnModel().setEditable(5, true); 
}
else{
    Ext.getCmp("saveButton").hide();
    Ext.getCmp("InWhId").setDisabled(true);
    Ext.getCmp("OutWhId").setDisabled(true);
    Ext.getCmp("Remark").setDisabled(true);
    Ext.getCmp("DriverId").setDisabled(true);
}
    /*----------------footerframe----------------*/
    if(dsDriverList.getCount()>0){
        Ext.getCmp('DriverId').setValue(dsDriverList.getRange()[0].data.DriverId);
    }; 
})


function checkUIData(){
    var check = true;
   
    if(Ext.getCmp("InWhId").getValue()+0 == 0)
    {
        Ext.Msg.alert("提示", "检查有调入仓库没有选择！");
        check = false;
        return false;
    }   
    var rowCount = dsAllotOrderProduct.getCount();
    var index = 0;
    dsAllotOrderProduct.each(function(record,grid){
        if(index<rowCount-1){
            index++;//alert(record.get("WhpId"));
           
            if(record.get("OutQty") == undefined || record.get("OutQty") ==""){
                Ext.Msg.alert("提示", "检查有数量没有填写！");
                check = false;
                return;
            }
            else{
                if(parseFloat(record.get("OutQty"))<=0){
                    Ext.Msg.alert("提示", "检查有数量不能小于等于零！");
                    check = false;
                    return;
                }
            }
            if(record.get("ProductPrice") == undefined || record.get("ProductPrice") == "" || parseFloat(record.get("ProductPrice"))<=0){
                Ext.Msg.alert("提示", "检查有商品价格没有填写！");
                check = false;
                return;
            }
            
            if(record.get("ProductId") == undefined || record.get("ProductId") == "" || parseInt(record.get("ProductId"))<=0){
                Ext.Msg.alert("提示", "检查有商品没有选择！");
                check = false;
                return;
            }
            
        }
    });
    if(rowCount == 1){
        Ext.Msg.alert("提示","请选择商品记录！");
        return false;
    }
    return check;
}

</script>

</html>

