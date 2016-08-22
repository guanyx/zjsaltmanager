<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmPurchaseOrderDecomposition.aspx.cs" Inherits="WMS_frmPurchaseOrderDecomposition" %>

<html>
<head>
<title>采购分割列表页面</title><meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<link rel="stylesheet" type="text/css" href="../ext3/resources/css/ext-all.css" />
<script type="text/javascript" src="../ext3/adapter/ext/ext-base.js"></script>
<script type="text/javascript" src="../ext3/ext-all.js"></script>
<script type="text/javascript" src="../ext3/example/ItemDeleter.js"></script>
<script type="text/javascript" src="../js/operateResp.js"></script>
<script type="text/javascript" src="../js/floatUtil.js"></script>
<script type="text/javascript" src="../ext3/src/locale/ext-lang-zh_CN.js"></script>
<style type="text/css">
.extensive-remove {
background-image: url(../Theme/1/images/extjs/customer/cross.gif) ! important;
}
.x-grid-back-blue { 
background: #C3D9FF; 
}
.x-date-menu {
   width: 175px;
}
</style>
</head>
<body>
<div id='toolbar'></div>
<div id='divSearchForm'></div>
<div id='divForm'></div>
<div id='divOrderGrid'></div>

</body>
<%=getComboBoxStore()%>
<script type="text/javascript">
    Ext.BLANK_IMAGE_URL = "../ext3/resources/images/default/s.gif";
    Ext.onReady(function() {
        var Direct_Type = 'Org';
        var Split_Order_Type = 'W0120';
        var SelectedShippingStatus = 0;
        var SelectRowData = null;
        /*------实现toolbar的函数 start---------------*/
        var Toolbar = new Ext.Toolbar({
            renderTo: "toolbar",
            items: [{
                text: "生成采购单",
                icon: "../theme/1/images/extjs/customer/add16.gif",
                handler: function() { genPurchaseOrderWin(); }
              }, '-', {
                text: "取消进货单",
                icon: "../theme/1/images/extjs/customer/cross.gif",
                handler: function() {cancelShippingOrderWin(); }
              }, '-', {
                text: "查看",
                icon: "../theme/1/images/extjs/customer/view16.gif",
                handler: function() {lookPurchaseOrderWin(); }
//            }, '-', {
//                text: "直拨子公司",
//                icon: "../theme/1/images/extjs/customer/add16.gif",
//                handler: function() {genDirectPurchaseOrderWin(); }
//             }, '-', {
//                text: "直拨客户",
//                icon: "../theme/1/images/extjs/customer/add16.gif",
//                handler: function() {genDirectPurchaseOrderToCustomerWin(); }
            }, '-', {
                text: "确认发运单分割完成",
                icon: "../theme/1/images/extjs/customer/add16.gif",
                handler: function() {confirmShippingOrderWin(); }
              }, '-', {
                text: "取消分割完成确认",
                icon: "../theme/1/images/extjs/customer/cross.gif",
                handler: function() {rollbackShippingOrderWin(); }
}]
            });

            /*------结束toolbar的函数 end---------------*/


            /*------开始ToolBar事件函数 start---------------*//*-----新增Order实体类窗体函数----*/
            function updateDataGrid() {

                var ShippingStatus = ShippingStatusPanel.getValue();
                var SupplierName = SupplierNamePanel.getValue();
                var StartDate = Ext.util.Format.date(StartDatePanel.getValue(),'Y/m/d');
                var EndDate = Ext.util.Format.date(EndDatePanel.getValue(),'Y/m/d');
                
                userGridData.baseParams.BillType = 'W0111';
                userGridData.baseParams.ShippingStatus = ShippingStatus;
                userGridData.baseParams.SupplierName = SupplierName;
                userGridData.baseParams.StartDate = StartDate;
                userGridData.baseParams.EndDate = EndDate;

                userGridData.load({
                    params: {
                        start: 0,
                        limit: 10
                    }
                });
                
               
            }
            //生成采购单
            function genPurchaseOrderWin() {
                Split_Order_Type = 'W0120';
                Direct_Type = 'Org';
                IsReader = false;
                var sm = Ext.getCmp('userGrid').getSelectionModel();
                var selectData = sm.getSelected();
                if(selectData == null){
                    Ext.Msg.alert("提示", "请选中一条记录！");
                    return;
                }
                
                SelectedShippingStatus = selectData.data.ShippingStatus;
                if(SelectedShippingStatus == 1){
                    Ext.Msg.alert("提示", "该记录已经分割完成！");
                    return;
                }
                SelectRowData = selectData;
                
                uploadPurchaseOrderWindow.setTitle("分割采购单");
                uploadPurchaseOrderWindow.show();

                userGridData_shipping.load({
                    params:{
                        start:0,
                        limit:100,
                        OrderId:selectData.data.OrderId
                    }
                });
                
                 dsPurchaseOrderProduct.load({
                    params:{
                        BillType:Split_Order_Type,
                        FromBillId:selectData.data.OrderId,
                        DirectType:Direct_Type
                    }
                });
                userGrid_purchase.colModel.setHidden(11,true);
                userGrid_purchase.colModel.setHidden(12,false);
                userGrid_purchase.colModel.setHidden(14,true);
                userGrid_purchase.colModel.setHidden(15,true);
                //setFormValue(selectData);
            }
             //查看分割单情况
            function lookPurchaseOrderWin() {
                Split_Order_Type = 'W0120';
                Direct_Type = 'Org';
                IsReader = true;
                var sm = Ext.getCmp('userGrid').getSelectionModel();
                var selectData = sm.getSelected();
                if(selectData == null){
                    Ext.Msg.alert("提示", "请选中一条记录！");
                    return;
                }
                
                SelectedShippingStatus = selectData.data.ShippingStatus;
                SelectRowData = selectData;
                
                uploadPurchaseOrderWindow.setTitle("查看分割单");
                uploadPurchaseOrderWindow.show();

                userGridData_shipping.load({
                    params:{
                        start:0,
                        limit:100,
                        OrderId:selectData.data.OrderId
                    }
                });
                
                 dsPurchaseOrderProduct.load({
                    params:{
                        BillType:Split_Order_Type,
                        FromBillId:selectData.data.OrderId,
                        DirectType:Direct_Type,
                        IsReader:IsReader
                    }
                });           
                userGrid_purchase.colModel.setHidden(8,false);     
                userGrid_purchase.colModel.setHidden(11,false);
                userGrid_purchase.colModel.setHidden(12,false);
                userGrid_purchase.colModel.setHidden(14,false);
                userGrid_purchase.colModel.setHidden(15,false);
  
            }
            //生成直拨单
            function genDirectPurchaseOrderWin() {
                Split_Order_Type = 'W0112';
                Direct_Type = 'Org';
                IsReader = false;
                var sm = Ext.getCmp('userGrid').getSelectionModel();
                var selectData = sm.getSelected();
                if(selectData == null){
                    Ext.Msg.alert("提示", "请选中一条记录！");
                    return;
                }
                SelectedShippingStatus = selectData.data.ShippingStatus;
                SelectRowData = selectData;
                
                uploadPurchaseOrderWindow.setTitle("分割直拨单到子公司");
                uploadPurchaseOrderWindow.show();
                
                 
                userGridData_shipping.load({
                    params:{
                        start:0,
                        limit:100,
                        OrderId:selectData.data.OrderId
                    }
                });
                
                 dsPurchaseOrderProduct.load({
                    params:{
                        BillType:Split_Order_Type,
                        FromBillId:selectData.data.OrderId,
                        DirectType:Direct_Type
                    }
                });
                userGrid_purchase.colModel.setHidden(11,false);
                userGrid_purchase.colModel.setHidden(12,true);
                userGrid_purchase.colModel.setHidden(14,true);
                userGrid_purchase.colModel.setHidden(15,false);
                //setFormValue(selectData);  
            }
            function genDirectPurchaseOrderToCustomerWin(){
                Split_Order_Type = 'W0112';
                Direct_Type = 'Customer';
                IsReader = false;
                var sm = Ext.getCmp('userGrid').getSelectionModel();
                var selectData = sm.getSelected();
                if(selectData == null){
                    Ext.Msg.alert("提示", "请选中一条记录！");
                    return;
                }
                SelectedShippingStatus = selectData.data.ShippingStatus;
                SelectRowData = selectData;
                
                uploadPurchaseOrderWindow.setTitle("分割直拨单到客户");
                uploadPurchaseOrderWindow.show();
                
                 
                userGridData_shipping.load({
                    params:{
                        start:0,
                        limit:100,
                        OrderId:selectData.data.OrderId
                    }
                });
                
                 dsPurchaseOrderProduct.load({
                    params:{
                        BillType:Split_Order_Type,
                        FromBillId:selectData.data.OrderId,
                        DirectType:Direct_Type
                    }
                });
                userGrid_purchase.colModel.setHidden(11,true);//子公司
                userGrid_purchase.colModel.setHidden(12,true);//仓库
                userGrid_purchase.colModel.setHidden(14,false);//客户
                userGrid_purchase.colModel.setHidden(15,false);//直拨价
            
            }

            //确认发运单分割完成
            function confirmShippingOrderWin() {
                var sm = Ext.getCmp('userGrid').getSelectionModel();
                //获取选择的数据信息
                var selectData = sm.getSelected();
                //如果没有选择，就提示需要选择数据信息
                if (selectData == null) {
                    Ext.Msg.alert("提示", "请选中一条记录！");
                    return;
                }
                if(selectData.data.ShippingStatus == 1){
                    Ext.Msg.alert("提示", "该发运单已分割完成并确认了，不需要再次操作！");
                    return;
                }
                Ext.Msg.confirm("提示信息", "是否真的要确认分割完成吗？", function callBack(id) {
                    if (id == "yes") {
                        //页面提交
                        Ext.Ajax.request({
                            url: 'frmPurchaseOrderDecomposition.aspx?method=confirmShippingOrder',
                            method: 'POST',
                            params: {
                                OrderId: selectData.data.OrderId
                            },
                            success: function(resp, opts) {
                                if (checkExtMessage(resp)) {
		                            updateDataGrid();
		                        }
                            }
                        });
                    }
                });
            }
            
            //取消自主采购生成的发运单信息
            function cancelShippingOrderWin() {
                var sm = Ext.getCmp('userGrid').getSelectionModel();
                //获取选择的数据信息
                var selectData = sm.getSelected();
                //如果没有选择，就提示需要选择数据信息
                if (selectData == null) {
                    Ext.Msg.alert("提示", "请选中一条记录！");
                    return;
                }
                if(selectData.data.ShippingStatus == 1){
                    Ext.Msg.alert("提示", "该发运单已分割完成并确认了，不能做取消操作！");
                    //return;
                }
                Ext.Msg.confirm("提示信息", "是否真的要取消取货单？", function callBack(id) {
                    if (id == "yes") {
                        //页面提交
                        Ext.Ajax.request({
                            url: 'frmPurchaseOrderDecomposition.aspx?method=cancelShipepingOrder',
                            method: 'POST',
                            params: {
                                OrderId: selectData.data.OrderId
                            },
                            success: function(resp, opts) {
                                if (checkExtMessage(resp)) {
		                            updateDataGrid();
		                        }
                            }
                        });
                    }
                });
            }
            
            //取消分割信息
            function rollbackShippingOrderWin() {
                var sm = Ext.getCmp('userGrid').getSelectionModel();
                //获取选择的数据信息
                var selectData = sm.getSelected();
                //如果没有选择，就提示需要选择数据信息
                if (selectData == null) {
                    Ext.Msg.alert("提示", "请选中一条记录！");
                    return;
                }
//                if(selectData.data.ShippingStatus == 0){
//                    Ext.Msg.alert("提示", "该发运单未做分割完成确认，不需要做取消操作！");
//                    return;
//                }
                Ext.Msg.confirm("提示信息", "是否真的要取消分割完成？", function callBack(id) {
                    if (id == "yes") {
                        //页面提交
                        Ext.Ajax.request({
                            url: 'frmPurchaseOrderDecomposition.aspx?method=rollbackShipepingOrder',
                            method: 'POST',
                            params: {
                                OrderId: selectData.data.OrderId
                            },
                            success: function(resp, opts) {
                                if (checkExtMessage(resp)) {
		                            updateDataGrid();
		                        }
                            }
                        });
                    }
                });
            }

            /*------开始查询form的函数 start---------------*/
            
            var SupplierNamePanel = new Ext.form.TextField({
                style: 'margin-left:0px',
                cls: 'key',
                xtype: 'textfield',
                fieldLabel: '供应商',
                anchor: '90%',
                listeners: { specialkey: function(f, e) { if (e.getKey() == e.ENTER) { Ext.getCmp('ShippingStatus').focus(); } } }
            });

            var ShippingStatusPanel = new Ext.form.ComboBox({
                name: 'shippingStatusCombo',
                store: dsShippingStatusList,
                displayField: 'ShippingStatusName',
                valueField: 'ShippingStatusId',
                typeAhead: true, //自动将第一个搜索到的选项补全输入
                triggerAction: 'all',
                selectOnFocus: true,
                forceSelection: true,
                mode: 'local',
                fieldLabel: '状态',
                anchor: '90%',
                id: 'ShippingStatus',
                value:dsShippingStatusList.getRange()[0].data.ShippingStatusId,
                listeners: { specialkey: function(f, e) { if (e.getKey() == e.ENTER) { Ext.getCmp('StartDate').focus(); } } }
            });

            var StartDatePanel = new Ext.form.DateField({
                style: 'margin-left:0px',
                cls: 'key',
                xtype: 'datefield',
                fieldLabel: '开始时间',
                format: 'Y年m月d日',
                anchor: '90%',
                value: new Date().getFirstDateOfMonth().clearTime(),
                id: 'StartDate',
                listeners: { specialkey: function(f, e) { if (e.getKey() == e.ENTER) { Ext.getCmp('EndDate').focus(); } } }
            });
            var EndDatePanel = new Ext.form.DateField({
                style: 'margin-left:0px',
                cls: 'key',
                xtype: 'datefield',
                fieldLabel: '结束时间',
                anchor: '90%',
                format: 'Y年m月d日',
                id: 'EndDate',
                value: new Date().clearTime(),
                listeners: { specialkey: function(f, e) { if (e.getKey() == e.ENTER) { Ext.getCmp('searchebtnId').focus(); } } }
            });
            var serchform = new Ext.FormPanel({
                renderTo: 'divSearchForm',
                labelAlign: 'left',
                layout: 'fit',
                buttonAlign: 'right',
                bodyStyle: 'padding:5px',
                frame: true,
                labelWidth: 55,
                items: [{
                    layout: 'column',   //定义该元素为布局为列布局方式
                    border: false,
                    items: [{
                        columnWidth: .2,  //该列占用的宽度，标识为20％
                        layout: 'form',
                        border: false,
                        items: [
                        SupplierNamePanel
                    ]
                    }, {
                        columnWidth: .2,
                        layout: 'form',
                        border: false,
                        items: [
                        ShippingStatusPanel
                        ]
                    }, {
                        columnWidth: .2,  //该列占用的宽度，标识为20％
                        layout: 'form',
                        border: false,
                        items: [
                        StartDatePanel
                    ]
                    }, {
                        columnWidth: .2,
                        layout: 'form',
                        border: false,
                        items: [
                        EndDatePanel
                        ]
                    }, {
                        columnWidth: .2,
                        layout: 'form',
                        border: false,
                        items: [{ cls: 'key',
                            xtype: 'button',
                            text: '查询',
                            id: 'searchebtnId',
                            anchor: '50%',
                            handler: function() {
                                updateDataGrid();
                            }
}]
}]
}]
                        });


                        /*------开始查询form的函数 end---------------*/

                        /*------开始获取数据的函数 start---------------*/
                        var userGridData = new Ext.data.Store
                        ({
                            url: 'frmPurchaseOrderDecomposition.aspx?method=getShippingOrderList',
                            reader: new Ext.data.JsonReader({
                                totalProperty: 'totalProperty',
                                root: 'root'
                                }, [{ name: 'OrderId'},
	                            { name: 'SupplierId'},
	                            { name: 'WhId'},
	                            { name: 'OrgId' },
	                            { name: 'OwnerId' },
	                            { name: 'OperId'},
	                            { name: 'CreateDate' },
	                            { name: 'UpdateDate' },
	                            { name: 'BillType' },
	                            { name: 'FromBillId' },
	                            { name: 'BillStatus' },
	                            { name: 'CarBoatNo' },
	                            { name: 'Remark' },
	                            { name: 'SupplierName'},
	                            { name: 'ShippingStatus'},
	                            { name: 'OperName' },
	                            { name: 'CustomerId' }
                            ]),
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
                        var userGrid = new Ext.grid.GridPanel({
                            el: 'divOrderGrid',
                            width: '100%',
                            height: '100%',
                            //autoWidth: true,
                            //autoHeight: true,
                            autoScroll: true,
                            layout: 'fit',
                            id: 'userGrid',
                            store: userGridData,
                            loadMask: { msg: '正在加载数据，请稍侯……' },
                            sm: sm,
                            cm: new Ext.grid.ColumnModel([
		                    sm,
		                    new Ext.grid.RowNumberer(), //自动行号
		                    {
		                        header: '订单号',
		                        dataIndex: 'OrderId',
		                        id: 'OrderId',
					width:60
                            },
		                    {
		                        header: '供应商',
		                        dataIndex: 'SupplierName',
		                        id: 'SupplierName',
					width:150
		                    },
		                    {
		                        header: '操作者',
		                        dataIndex: 'OperName',
		                        id: 'OperName',
					width:80
                            },
		                    {
		                        header: '创建时间',
		                        dataIndex: 'CreateDate',
		                        id: 'CreateDate',
		                        format: 'Y年m月d日',
					width:100
		                    },
		                    {
		                        header: '单据类型',
		                        dataIndex: 'BillType',
		                        id: 'BillType',
		                        renderer: function(val, params, record) {
		                            if (dsBillType.getCount() == 0) {
		                                dsBillType.load();
		                            }
		                            dsBillType.each(function(r) {
		                                if (val == r.data['DicsCode']) {
		                                    val = r.data['DicsName'];
		                                    return;
		                                }
		                            });
		                            return val;
		                        },
					width:80
                            },
		                    {
		                        header: '发运单状态',
		                        dataIndex: 'ShippingStatus',
		                        id: 'ShippingStatus',
		                        renderer: function(val, params, record) {
		                            if (dsShippingStatusList.getCount() == 0) {
		                                dsShippingStatusList.load();
		                            }
		                            dsShippingStatusList.each(function(r) {
		                                if (val == r.data['ShippingStatusId']) {
		                                    val = r.data['ShippingStatusName'];
		                                    return;
		                                }
		                            });
		                            return val;
		                        }
                            },
		                    {
		                        header: '车船号',
		                        dataIndex: 'CarBoatNo',
		                        id: 'CarBoatNo',
					width:120
		                    },
		                    {
		                        header: '备注',
		                        dataIndex: 'Remark',
		                        id: 'Remark',
					width:150
                            }]),
                            bbar: new Ext.PagingToolbar({
                                pageSize: 10,
                                store: userGridData,
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
                        userGrid.render();
                        /*------DataGrid的函数结束 End---------------*/
                        updateDataGrid();
 //===========================================================================================================
  //===============================================================

            /*------开始获取数据的函数 start---------------*/
            var userGridData_shipping = new Ext.data.Store
            ({
                url: 'frmPurchaseOrderDecomposition.aspx?method=getShippingOrderDetailList',
                reader: new Ext.data.JsonReader({
                    totalProperty: 'totalProperty',
                    root: 'root'
                }, 
                [
                    {name: 'OrderDetailId'},
	                {name: 'OrderId'},
	                {name: 'ProductId'},
	                {name: 'ProductName'},
	                {name: 'ProductUnit'},
	                {name: 'ProductSpec'},
	                {name: 'ProductCode'},
	                {name: 'ProductPrice',type:'float'},
	                {name: 'BookQty',type:'float'},
	                {name: 'RealQty',type:'float'},
	                {name: 'WhId'},
	                {name: 'remark'},
	                {name: 'CarBoatNo'},
	                {name: 'SupplierId'},
	                {name: 'BillType'},
	                {name: 'FromBillId'},
	                {name: 'BillStatus'},
	                {name:'BookWeight'},
	                {name:'RealWeight'},
	                {name:'UnitId'},
	                {name:'SalePrice',type:'float'}
                ]),
                listeners:
	            {
	                scope: this,
	                load: function() {
	                }
	            }
            });

            /*------获取数据的函数 结束 End---------------*/

            /*------开始DataGrid的函数 start---------------*/
            var selectCurrentRowData = null;//选择的采购单记录数据
            
            var sm = new Ext.grid.CheckboxSelectionModel({
                singleSelect: true
            });
            var userGrid_shipping = new Ext.grid.GridPanel({
                width: '100%',
                autoWidth: true,
                autoScroll: true,
                layout: 'fit',
                id: '',
                store: userGridData_shipping,
                loadMask: { msg: '正在加载数据，请稍侯……' },
                sm: sm,
                cm: new Ext.grid.ColumnModel([
		        sm,
		        new Ext.grid.RowNumberer(), //自动行号
		        {
		            header: '序号',
		            dataIndex: 'OrderDetailId',
		            id: 'OrderDetailId',
		            hidden:true
                },
		        {
		            header: '代码',
		            dataIndex: 'ProductCode',
		            id: 'ProductCode'
		        },
		        {
		            header: '商品名称',
		            dataIndex: 'ProductName',
		            id: 'ProductName'
		        },
		        {
		            header: '单位',
		            dataIndex: 'UnitId',
		            id: 'UnitId',
		            renderer: function(value, cellmeta, record, rowIndex, columnIndex, store) {
		                var index = dsProductUnitList.findBy(function(record, id) {  
	                        return record.get(productUnitCombo.valueField)==value; 
                        });
                        
                        //var index = dsProductUnitList.find(productUnitCombo.valueField, value);

                        var record = dsProductUnitList.getAt(index);
                        var displayText = "";
                        if (record == null) {
                            displayText = value;
                        } else {
                            displayText = record.data.UnitName; 
                        }
                        return displayText;
                    }
		        },
		        {
		            header: '规格',
		            dataIndex: 'ProductSpec',
		            id: 'ProductSpec',
		            renderer: function(value, cellmeta, record, rowIndex, columnIndex, store) {
                        var index = dsProductSpecList.findBy(function(record, id) {  
	                        return record.get(productSpecCombo.valueField)==value; 
                        });
                        //var index = dsProductSpecList.find(productSpecCombo.valueField, value);
                        var record = dsProductSpecList.getAt(index);
                        var displayText = "";
                        if (record == null) {
                            displayText = value;
                        } else {
                            displayText = record.data.DicsName; 
                        }
                        return displayText;
                    }
		        },
		        {
		            header: '价格',
		            type:'float',
		            dataIndex: 'SalePrice',
		            id: 'SalePrice'
		        },
		         {
		            header: '发运重量',
		            type:'float',
		            dataIndex: 'RealWeight',
		            id: 'RealWeight'
		        },
		        {
		            header: '发运数量',
		            type:'float',
		            dataIndex: 'BookQty',
		            id: 'BookQty'
		        },
		        {
		            header: '可分配数量',
		            type:'float',
		            dataIndex: 'RealQty',
		            id: 'RealQty'
		        }]),
                viewConfig: {
                    columnsText: '显示的列',
                    scrollOffset: 20,
                    sortAscText: '升序',
                    sortDescText: '降序',
                    forceFit: true
                },
                height: 150,
                closeAction: 'hide',
                stripeRows: true,
                loadMask: true,
                autoExpandColumn: 2,
                listeners: {
                    rowclick: function(grid, rowIndex, e) {
 			if(uploadPurchaseOrderWindow.title=='查看分割单') return;
                        var curRowData = userGridData_shipping.getAt(rowIndex).data;
                        inserNewBlankRow(curRowData);
                    }
                }
            });
            //userGrid.render();
            /*------DataGrid的函数结束 End---------------*/
            /*------退货单可编辑DataGrid的函数开始---------------*/
            function inserNewBlankRow(curRowData) {
                var rowCount = userGrid_purchase.getStore().getCount();
                var insertPos = parseInt(rowCount);
                
                var addRow;
                if(Split_Order_Type == 'W0120'){
                    addRow = new RowPattern({
                        ProductId: curRowData.ProductId,
                        ProductCode: curRowData.ProductCode,
                        ProductName: curRowData.ProductName,
                        ProductUnit: curRowData.ProductUnit,
                        ProductSpec: curRowData.ProductSpec,
                        ProductPrice: curRowData.ProductPrice,
                        BookQty: curRowData.RealQty,
                        UnitId:curRowData.UnitId,
                        RealQty:0,
                        SupplierId:SelectRowData.data.SupplierId,//Ext.getCmp("SupplierId").getValue(),
                        CarBoatNo:SelectRowData.data.CarBoatNo,//Ext.getCmp("CarBoatNo").getValue(),
                        BillType:Split_Order_Type,
                        FromBillId:curRowData.OrderId,
                        BillStatus:0,
                        ShippingStatus:0,
                        OrgId:<%=ZJSIG.UIProcess.ADM.UIAdmUser.OrgID(this) %>,
                        OperId:<%=ZJSIG.UIProcess.ADM.UIAdmUser.EmployeeID(this) %>,
                        OwnerId:<%=ZJSIG.UIProcess.ADM.UIAdmUser.EmployeeID(this) %>,
                        Remark:'',
                        CreateDate:new Date(),
                        UpdateDate:new Date(),
                        CustomerId:0
                    });
                }
                else{
                    addRow = new RowPattern({
                        ProductId: curRowData.ProductId,
                        ProductCode: curRowData.ProductCode,
                        ProductCode: curRowData.ProductCode,
                        ProductUnit: curRowData.ProductUnit,
                        ProductSpec: curRowData.ProductSpec,
                        ProductPrice: curRowData.SalePrice,
                        SalePrice:curRowData.SalePrice,
                        BookQty: curRowData.RealQty,
                        UnitId:curRowData.UnitId,
                        RealQty:0,
                        SupplierId:SelectRowData.data.SupplierId,//Ext.getCmp("SupplierId").getValue(),
                        CarBoatNo:SelectRowData.data.CarBoatNo,//Ext.getCmp("CarBoatNo").getValue(),
                        BillType:Split_Order_Type,
                        FromBillId:curRowData.OrderId,
                        BillStatus:0,
                        ShippingStatus:-1,//因为直拨单其实和发运单是统一的，所以这里由原来的0变为-1
                        //OrgId:<%=ZJSIG.UIProcess.ADM.UIAdmUser.OrgID(this) %>,
                        OperId:<%=ZJSIG.UIProcess.ADM.UIAdmUser.EmployeeID(this) %>,
                        OwnerId:<%=ZJSIG.UIProcess.ADM.UIAdmUser.EmployeeID(this) %>,
                        Remark:'',
                        CreateDate:new Date(),
                        UpdateDate:new Date(),
                        WhId:0
                    });
                }
                userGrid_purchase.stopEditing();
                //增加一新行
                if (insertPos > 0) {
                    var rowIndex = dsPurchaseOrderProduct.insert(insertPos, addRow);
                    userGrid_purchase.startEditing(insertPos, 0);
                }
                else {
                    var rowIndex = dsPurchaseOrderProduct.insert(0, addRow);
                    userGrid_purchase.startEditing(0, 0);
                }
            }
            //设置分割后的采购grid可编辑项
            function setGridStatus() {
                var columnCount = userGrid_purchase.getColumnModel().getColumnCount();
                
                for (var i = 0; i < columnCount-11; i++) {
                    userGrid_purchase.getColumnModel().setEditable(i, false);
                }
                
            }
//            var orgCombo = new Ext.form.ComboBox({
//                store: dsChildOrgList,
//                displayField: 'OrgName',
//                valueField: 'OrgId',
//                triggerAction: 'all',
//                id: 'orgCombo',
//                typeAhead: true,
//                mode: 'local',
//                emptyText: '',
//                selectOnFocus: false,
//                editable: false
//            });
            var warehouseCombo = new Ext.form.ComboBox({
                store: dsWarehouseList,
                displayField: 'WhName',
                valueField: 'WhId',
                triggerAction: 'all',
                id: 'warehouseCombo',
                typeAhead: true,
                mode: 'local',
                emptyText: '',
                selectOnFocus: false,
                editable: false
            });
//            var customerCombo = new Ext.form.ComboBox({
//                store: dsCustomerList,
//                displayField: 'ShortName',
//                valueField: 'CustomerId',
//                triggerAction: 'all',
//                id: 'customerCombo',
//                typeAhead: true,
//                mode: 'local',
//                emptyText: '',
//                selectOnFocus: false,
//                editable: false
//            });
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
                editable: false
            });
            var productSpecCombo = new Ext.form.ComboBox({
                store: dsProductSpecList,
                displayField: 'DicsName',
                valueField: 'DicsCode',
                triggerAction: 'all',
                id: 'productSpecCombo',
                typeAhead: true,
                mode: 'local',
                emptyText: '',
                selectOnFocus: false,
                editable: false
            });
//            var productCombo = new Ext.form.ComboBox({
//                store: dsProductList,
//                displayField: 'ProductName',
//                valueField: 'ProductId',
//                triggerAction: 'all',
//                id: 'productCombo',
//                //pageSize: 5,
//                //minChars: 2,
//                //hideTrigger: true,
//                typeAhead: true,
//                mode: 'local',
//                emptyText: '',
//                selectOnFocus: false,
//                editable: true,
//                onSelect: function(record) {
//                    var sm = userGrid_purchase.getSelectionModel().getSelected();
//                    sm.set('ProductCode', record.data.ProductNo);
//                    sm.set('ProductSpec', record.data.Specifications);
//                    sm.set('ProductUnit', record.data.Unit);
//                    sm.set('ProductId', record.data.ProductId);
//                    
//                    //addNewBlankRow();
//                }
//            });
            var cm_purchase = new Ext.grid.ColumnModel([
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
                    width: 60,
                    editor: new Ext.form.TextField({ allowBlank: false })
                },
                {
                    id: 'ProductId',
                    header: "商品",
                    dataIndex: 'ProductId',
                    hidden: true
//                    editor: productCombo,
//                    renderer: function(value, cellmeta, record, rowIndex, columnIndex, store) {
//                        //解决值显示问题
//                        //获取当前id="combo_process"的comboBox选择的值
//                        var index = dsProductList.findBy(
//                            function(record, id) {
//                                return record.get(productCombo.valueField) == value;
//                            }
//                        );
//                        var record = dsProductList.getAt(index);
//                        var displayText = "";
//                        // 如果下拉列表没有被选择，那么record也就不存在，这时候，返回传进来的value，
//                        // 而这个value就是grid的USER_REALNAME列的value，所以直接返回
//                        if (record == null) {
//                            //返回默认值，
//                            displayText = value;
//                        } else {
//                            displayText = record.data.ProductName; //获取record中的数据集中的process_name字段的值
//                        }
//                        return displayText;
//                    }
                },
                {
                    id: 'ProductName',
                    header: "商品",
                    dataIndex: 'ProductName',
                    width: 150   
                },
                {
                    id: "UnitId",
                    header: "单位",
                    dataIndex: "UnitId",
                    width: 60,
                    editor: productUnitCombo,
                    renderer: function(value, cellmeta, record, rowIndex, columnIndex, store) {
                        //解决值显示问题
                        //获取当前id="combo_process"的comboBox选择的值
                        var index = dsProductUnitList.findBy(function(record, id) {  
	                        return record.get(productUnitCombo.valueField)==value; 
                        });
                        //var index = dsProductUnitList.find(productUnitCombo.valueField, value);
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
                    id: 'ProductSpec',
                    header: "规格",
                    dataIndex: 'ProductSpec',
                    width: 60,
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
                    }
                }, {
                    id: 'ProductPrice',
                    header: "价格",
                    dataIndex: 'ProductPrice',
                    width: 60,
                    renderer: function(v, m) {
                        m.css = 'x-grid-back-blue';
                        return v;
                    },
                    editor: new Ext.form.TextField({ allowBlank: false })
                 
                }, {
                    id: 'BookQty',
                    header: "发运数量",
                    dataIndex: 'BookQty',
                    width: 50,
                    type:'float',
                    hidden:true,
                    editor: new Ext.form.TextField({ allowBlank: false })
                 }, {
                    id: 'RealQty',
                    header: "分配数量",
                    dataIndex: 'RealQty',
                    width: 80,
                    type:'float',
                    renderer: function(v, m) {
                        m.css = 'x-grid-back-blue';
                        return v;
                    },editor: new Ext.form.TextField({ allowBlank: false })
                },{
                    id: 'OrgId',
                    header: "公司",
                    dataIndex: 'OrgId',
                    hidden:true
                },{
                    id: 'OrgName',
                    header: "公司",
                    dataIndex: 'OrgName',
                    name:'OrgName',
                    width: 100
                },{
                    id: 'WhId',
                    header: "采购仓库",
                    dataIndex: 'WhId',
                    name:'WhName',
                    width: 80,
                    editor:warehouseCombo,
                    renderer: function(value, cellmeta, record, rowIndex, columnIndex, store) {
                        var index = dsWarehouseList.find(warehouseCombo.valueField, value);
                        var record = dsWarehouseList.getAt(index);
                        var displayText = "";
                        if (record == null) {
                            displayText = value;
                        } else {
                            displayText = record.data.WhName; 
                        }
                        cellmeta.css = 'x-grid-back-blue';
                        return displayText;
                        
                    }
                },
                {
                    id: 'CustomerId',
                    header: "客户",
                    dataIndex: 'CustomerId',
                    name:'ShortName',
                    hidden:true
//                    width: 40,
//                    editor:customerCombo,
//                    renderer: function(value, cellmeta, record, rowIndex, columnIndex, store) {
//                        var index = dsCustomerList.find(customerCombo.valueField, value);
//                        var record = dsCustomerList.getAt(index);
//                        var displayText = "";
//                        if (record == null) {
//                            displayText = value;
//                        } else {
//                            displayText = record.data.ShortName; 
//                        }
//                        cellmeta.css = 'x-grid-back-blue';
//                        return displayText;
//                        
//                    }
                },{
                    id: 'CustomerName',
                    header: "客户",
                    dataIndex: 'CustomerName',
                    name:'CustomerName',
                    width: 100
                }, {
                    id: 'SalePrice',
                    header: "直拨价格",
                    dataIndex: 'SalePrice',
                    width: 60
                },{
                    id: 'DetailRemark',
                    header: "备注",
                    dataIndex: 'DetailRemark',
                    width: 120,
                    renderer: function(v, m) {
                        m.css = 'x-grid-back-blue';
                        return v;
                    },editor: new Ext.form.TextArea({ allowBlank: false })
                }, new Extensive.grid.ItemDeleter()
            ]);
            cm_purchase.defaultSortable = true;
            

            var RowPattern = Ext.data.Record.create([
               { name: 'OrderDetailId', type: 'string' },
               { name: 'ProductId', type: 'string' },
               { name: 'ProductCode', type: 'string' },
               { name: 'ProductName', type: 'string' },
               { name: 'ProductUnit', type: 'string' },
               { name: 'ProductSpec', type: 'string' },
               { name: 'ProductPrice', type: 'float' },
               { name: 'RealQty', type: 'float' },
               { name: 'WhId',type:'string'},
               { name: 'BookQty',type:'float'},
               { name: 'SupplierId',type:'string'},
               { name: 'SupplierName',type:'string'},
               { name: 'CarBoatNo',type:'string'},
               { name: 'BillType',type:'string'},
               { name: 'FromBillId',type:'string'},
               { name: 'BillStatus',type:'string'},
               { name: 'ShippingStatus',type:'string'},
               { name: 'OrgId',type:'string'},
               { name: 'OrgName',type:'string'},
               { name: 'OperId',type:'string'},
               { name: 'OwnerId',type:'string'},
               { name: 'Remark',type:'string'},
               { name: 'CreateDate',type:'string'},
               { name: 'OrderId',type:'string'},
               { name: 'DetailRemark',type:'string'},
               { name: 'SalePrice', type:'string'},
               { name: 'UnitId', type:'string'},
               { name: 'CustomerId', type:'string'},
               { name: 'CustomerName', type:'string'}
            ]);

            var dsPurchaseOrderProduct;
            if (dsPurchaseOrderProduct == null) {
                dsPurchaseOrderProduct = new Ext.data.Store
	            ({
	                url: 'frmPurchaseOrderDecomposition.aspx?method=getPurchaseOrderProductByShippingId',
	                reader: new Ext.data.JsonReader({
	                    totalProperty: 'totalProperty',
	                    root: 'root'
	                }, RowPattern)
	            });
	          
            }
            var userGrid_purchase = new Ext.grid.EditorGridPanel({
                //region: 'south',
                store: dsPurchaseOrderProduct,
                cm: cm_purchase,
                selModel: new Extensive.grid.ItemDeleter(),
                layout: 'fit',
                width: '100%',
                autoScroll: true,
                height: 210,
                stripeRows: true,
                frame: true,
                clicksToEdit: 1,
                viewConfig: {
                    columnsText: '显示的列',
                    scrollOffset: 20,
                    sortAscText: '升序',
                    sortDescText: '降序',
                    forceFit: false
                }
            });
          
            //===============================================================
            if (typeof (uploadPurchaseOrderWindow) == "undefined") {
                uploadPurchaseOrderWindow = new Ext.Window({
                    id: 'PurchaseOrderformwindow'
		            , iconCls: 'upload-win'
		            , width: 780
		            , height: 440
		            , layout: 'form'
		            , plain: true
		            , modal: true
		            , constrain: true
		            , resizable: false
		            , closeAction: 'hide'
		            , autoDestroy: true
		            , items: [
                         {       layout:'form',
                                border: false,
                                columnWidth:1,
                                items: [  userGrid_shipping ]
                         },
                         {       layout:'form',
                                border: false,
                                columnWidth:1,
                                items: [  userGrid_purchase ]
                         }
		            ]
		            , buttons: [{
		                text: "保存"
		                ,id:"btnSave"
			            , handler: function() {       
			                if(!checkUIData()) return;//检查数据
		                    var json = "";
		                    dsPurchaseOrderProduct.each(function(dsPurchaseOrderProduct) {
		                        var curData = dsPurchaseOrderProduct.data;
		                        json += Ext.util.JSON.encode(curData) + ',';
		                    });
		                    json = json.substring(0, json.length - 1);
    		                
		                   // alert(json);//return;

		                    Ext.Ajax.request({
		                        url: 'frmPurchaseOrderDecomposition.aspx?method=savePurchaseOrderInfo',
		                        method: 'POST',
		                        params: {
		                            DetailInfo: json
		                        },
		                        success: function(resp, opts) {
		                            if (checkExtMessage(resp)) {
		                                updateDataGrid();
		                                uploadPurchaseOrderWindow.hide();
    		                            
		                            }
		                        }
		                    });
			                }
			                , scope: this
		                },
		                {
		                    text: "取消"
			                , handler: function() {
			                    uploadPurchaseOrderWindow.hide();
			                }
			                , scope: this
                        }]
                       
                });
            }
            uploadPurchaseOrderWindow.addListener("hide", function() {
                //shippingOrderForm.getForm().reset();
                userGrid_shipping.getStore().removeAll();
                userGrid_purchase.getStore().removeAll();
                //purchaseOrderForm.getForm().reset();
            });
            uploadPurchaseOrderWindow.addListener("show",function(){
            //alert(SelectedShippingStatus);
                if(SelectedShippingStatus == 1 || IsReader == true){
                    Ext.getCmp("btnSave").hide();
                }
                else{
                    Ext.getCmp("btnSave").show();
                }
            });
            
            //进货分割单Grid监听事件
            userGrid_purchase.on({
                beforeedit:function(o){
                    if(o.field != 'RealQty')
                        return;
                    beforeQty = parseFloat(o.value); 
                },
                afteredit:function(o){
                    if(o.field != 'RealQty')
                        return;
                    caculationQty(o.record);
                },
               cellclick:function(grid, rowIndex, columnIndex, e){
                    if(columnIndex==grid.getColumnModel().getIndexById('deleter')) {
		                //if(grid.getSelectionModel().hasNext()){//最后一行不允许删除
			                var record = grid.getStore().getAt(rowIndex);		
			                grid.getStore().remove(record);
			                grid.getView().refresh();
			                //caculate start
			                beforeQty = undefined;
			                caculationQty(record);
			                //caculate end	
			            //}    
		            }
               }
            });
            //计算商品可分配数量
            function caculationQty(trecord){
                var hasQty = 0;
                var index = userGrid_shipping.store.findBy(function(record, id) {  
		             return record.get('ProductId') == trecord.get('ProductId'); 
	               });	
	            if(index == -1) return; 
	            
	             var nrecord = userGrid_shipping.store.getAt(index); 
	             var afterQty = parseFloat(trecord.get('RealQty'));
	             
	             if(afterQty < 0){
	                Ext.Msg.alert("提示","分配数量不能为负数！");
                    trecord.set('RealQty',beforeQty);
                    return;
	             }
                if(beforeQty == undefined){//删除记录
                    hasQty = hasQty.add(nrecord.get('RealQty')).add(afterQty);
                }
                else{//新增或者修改
	                hasQty = hasQty.add(nrecord.get('RealQty')).add(beforeQty).sub(afterQty);
	             }
	             if(hasQty<0){
	                Ext.Msg.alert("提示","总分配量大于了发运数量！");
                    trecord.set('RealQty',beforeQty);
                    return;
	             }
	             nrecord.set('RealQty',parseFloat(hasQty));

                nrecord.commit();
           }
            function caculation(trecord){
                var hasQty = 0;
                userGrid_purchase.store.each(function(record) {
                    if(record.get('ProductId') == trecord.get('ProductId')){
                        hasQty =hasQty.add(record.get('RealQty'));
                    }
                });
                var index = userGrid_shipping.store.findBy(function(record, id) {  
		             return record.get('ProductId') == trecord.get('ProductId'); 
	               });		  
	            if(index == -1) return ; 
                var nrecord = userGrid_shipping.store.getAt(index); 
                
                if(nrecord.get('BookQty').sub(hasQty) < 0)
                {  
                    Ext.Msg.alert("提示","总分配量大于了进货数量！");
                    trecord.set('RealQty',beforeQty);
                    return;
                }    
                nrecord.set('RealQty',nrecord.get('BookQty').sub(hasQty));
                nrecord.commit();
            }
            //保存数据前
            function checkUIData(){
                var check = true;
                dsPurchaseOrderProduct.each(function(record){
                    if(Split_Order_Type == "W0120"){
                        if(record.get("WhId") == undefined){
                            Ext.Msg.alert("提示", "检查有仓库没有选择！");
                            check = false;
                            return;
                        }
                    }
                    else{
                        if(Direct_Type == 'Org'){
                            if(record.get("OrgId") == undefined){
                                Ext.Msg.alert("提示", "检查有子公司没有选择！");
                                check = false;
                                return;
                            }
                        }
                        else{
                            if(record.get("CustomerId") == undefined){
                                Ext.Msg.alert("提示", "检查有客户没有选择！");
                                check = false;
                                return;
                            }
                        }
                    }
                    if(record.get("RealQty") == undefined || parseFloat(record.get("RealQty"))<=0){
                        Ext.Msg.alert("提示", "检查有分配数量没有填写！");
                        check = false;
                        return;
                    }
                });
                if(dsPurchaseOrderProduct.getCount() == 0){
                    Ext.Msg.alert("提示","保存前请选分配商品！");
                    return false;
                }
                return check;
            }
            setGridStatus();

    })
</script>

</html>
