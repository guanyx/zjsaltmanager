<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmReturnPurchaseOrderList.aspx.cs" Inherits="WMS_frmReturnPurchaseOrderList" %>

<html>
<head>
<title>采购退货单列表页面</title><meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<link rel="stylesheet" type="text/css" href="../ext3/resources/css/ext-all.css" />
<script type="text/javascript" src="../ext3/adapter/ext/ext-base.js"></script>
<script type="text/javascript" src="../ext3/ext-all.js"></script>
<script type="text/javascript" src="../ext3/example/ItemDeleter.js"></script>
<script type="text/javascript" src="../js/operateResp.js"></script>
<script type="text/javascript" src="../ext3/src/locale/ext-lang-zh_CN.js"></script>
<style type="text/css">
.extensive-remove {
background-image: url(../Theme/1/images/extjs/customer/cross.gif) ! important;
}
.x-grid-back-blue { 
background: #08F5FE; 
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
    var userGridData;
    Ext.onReady(function() {
        /*------实现toolbar的函数 start---------------*/
        var windowTitle = "";
        var Toolbar = new Ext.Toolbar({
            renderTo: "toolbar",
            items: [{
                text: "新增",
                icon: "../theme/1/images/extjs/customer/add16.gif",
                handler: function() { addOrderWin(); }
            }, '-', {
                text: "编辑",
                icon: "../theme/1/images/extjs/customer/edit16.gif",
                handler: function() { editOrderWin(); }
            }, '-', {
                text: "删除",
                icon: "../theme/1/images/extjs/customer/delete16.gif",
                handler: function() { deleteOrderWin(); }
            }, '-', {
                text: "查看",
                icon: "../theme/1/images/extjs/customer/delete16.gif",
                handler: function() { LookOrderWin(); }
            }, '-', {
                text: "退货确认",
                icon: "../theme/1/images/extjs/customer/edit16.gif",
                handler: function() { confirmOrderWin(); }
}, '-', {
                text: "出入单打印",
                icon: "../Theme/1/images/extjs/customer/edit16.gif",
                handler: function() {
                    printOutStock();                    
                }
            }]
            });

            /*------结束toolbar的函数 end---------------*/
function getUrl(imageUrl) {
                var index = window.location.href.toLowerCase().indexOf('/wms/');
                var tempUrl = window.location.href.substring(0, index);
                return tempUrl + "/" + imageUrl;
            }
        function printOutStock() {
                var sm = userGrid.getSelectionModel();
                //多选
                var selectData = sm.getSelections();
                var array = new Array(selectData.length);
                var orderIds = "";
                for (var i = 0; i < selectData.length; i++) {
                    if (orderIds.length > 0)
                        orderIds += ",";
                    orderIds += selectData[i].get('OrderId');
                }
                //页面提交
                Ext.Ajax.request({
                    url: 'frmReturnOrderList.aspx?method=outprintdate',
                    method: 'POST',
                    params: {
                        OrderId: orderIds
                    },
                    success: function(resp, opts) {
                        
                        var printData = resp.responseText;
                        var printControl = parent.parent.parent.document.getElementById("topFrame").contentWindow.getPrintControl();
                        printControl.Url = getUrl('xml');
                        printControl.MapUrl = printControl.Url + '/' + printOutStyleXml; //'/salePrint1.xml';
                        printControl.PrintXml = printData;
                        printControl.ColumnName = "OrderId";
                        printControl.OnlyData = printOutOnlyData;
                        printControl.PageWidth = printOutPageWidth;
                        printControl.PageHeight = printOutPageHeight;
                        printControl.Print();

                    },
                    failure: function(resp, opts) {  /* Ext.Msg.alert("提示","保存失败"); */ }
                });
            }
            /*------开始ToolBar事件函数 start---------------*//*-----新增Order实体类窗体函数----*/
            function updateDataGrid() {
                var WhId = WhNamePanel.getValue();
                var StartDate = Ext.util.Format.date(StartDatePanel.getValue(),'Y/m/d');
                var EndDate = Ext.util.Format.date(EndDatePanel.getValue(),'Y/m/d');
                var Status = StatusPanel.getValue();
                var Type = TypePanel.getValue();
                
                userGridData.baseParams.WhId = WhId;
                userGridData.baseParams.StartDate = StartDate;
                userGridData.baseParams.Type = "W0209";//Type;
                userGridData.baseParams.EndDate = EndDate;
                userGridData.baseParams.Status = Status;
                
                userGridData.load({
                    params: {
                        start: 0,
                        limit: 10
                    }
                });
            }


            //新增采购退货单
            function addOrderWin() {
                uploadPurchaseOrderWindow.show();
                //uploadReturnOrderWindow.setTitle("退货单明细记录");
                //document.getElementById("editReturnOrderIFrame").src = "frmReturnOrderEdit.aspx?id=" + selectData.data.OrderId;
            }
            //编辑采购退货单
            function editOrderWin(){
                var sm = userGrid.getSelectionModel();
                //获取选择的数据信息
                var selectData = sm.getSelected();
                if (selectData == null) {
                    Ext.Msg.alert("提示", "请选择退货单记录！");
                    return;
                }
                if (selectData.data.Status > 0)//不是未入仓状态
                {
                    Ext.Msg.alert("提示", "已提交的退货单不能编辑！");
                    return;
                }
                uploadReturnOrderWindow.show();
                uploadReturnOrderWindow.setTitle("退货单明细记录");
                document.getElementById("editReturnOrderIFrame").src = "frmReturnOrderEdit.aspx?id=" + selectData.data.OrderId;
            }
            function deleteOrderWin() {
                var sm = userGrid.getSelectionModel();
                //获取选择的数据信息
                var selectData = sm.getSelected();
                //如果没有选择，就提示需要选择数据信息
                if (selectData == null) {
                    Ext.Msg.alert("提示", "请选中需要删除的信息！");
                    return;
                }
                if (selectData.data.Status > 0)//不是未入仓状态
                {
                    Ext.Msg.alert("提示", "已提交的退货单不能删除！");
                    return;
                }
                //删除前再次提醒是否真的要删除
                Ext.Msg.confirm("提示信息", "是否真的要删除选择的退货单吗？", function callBack(id) {
                    //判断是否删除数据
                    if (id == "yes") {
                        //页面提交
                        Ext.Ajax.request({
                            url: 'frmReturnPurchaseOrderList.aspx?method=deleteReturnOrder',
                            method: 'POST',
                            params: {
                                OrderId: selectData.data.OrderId
                            },
                            success: function(resp, opts) {
                                 if(checkExtMessage(resp))
                                    {
                                        updateDataGrid();
                                  
                                    }
                            }
                        });
                    }
                });
            }
            //查看
            function LookOrderWin() {
                var sm = userGrid.getSelectionModel();
                //获取选择的数据信息
                var selectData = sm.getSelected();
                if (selectData == null) {
                    Ext.Msg.alert("提示", "请选择采购退货单记录！");
                    return;
                }
                uploadReturnOrderWindow.show();
                uploadReturnOrderWindow.setTitle("查看采购退货单");
                document.getElementById("editReturnOrderIFrame").src = "frmReturnOrderEdit.aspx?id=" + selectData.data.OrderId + "&status=look";
            }
            //退货确认
            function confirmOrderWin(){
                var sm = userGrid.getSelectionModel();
                //获取选择的数据信息
                var selectData = sm.getSelected();
                //如果没有选择，就提示需要选择数据信息
                if (selectData == null) {
                    Ext.Msg.alert("提示", "请选中需要确认的信息！");
                    return;
                }
                if (selectData.data.Status > 0)//不是未入仓状态
                {
                    Ext.Msg.alert("提示", "该退货单已经确认！");
                    return;
                }
                Ext.Msg.confirm("提示信息", "是否真的要确认选择的退货单吗？", function callBack(id) {
                    if (id == "yes") {
                        //页面提交
                        Ext.Ajax.request({
                            url: 'frmReturnPurchaseOrderList.aspx?method=confirmReturnOrder',
                            method: 'POST',
                            params: {
                                OrderId: selectData.data.OrderId,
                                Status:1
                            },
                            success: function(resp, opts) {
                                if(checkExtMessage(resp))
                                {
                                    updateDataGrid();
                                }
                           }
                        });
                    }
                });
            }
            /*------开始界面数据的窗体 Start---------------*/
            if (typeof (uploadReturnOrderWindow) == "undefined") {//解决创建2个windows问题
                uploadReturnOrderWindow = new Ext.Window({
                    id: 'ReturnOrderWindow'
		            , iconCls: 'upload-win'
		            , width: 750
		            , height: 490
		            , layout: 'fit'
		            , plain: true
		            , modal: true
		            , constrain: true
		            , resizable: false
		            , closeAction: 'hide'
		            , autoDestroy: true
		            , html: '<iframe id="editReturnOrderIFrame" width="100%" height="100%" border=0 src="frmReturnOrderEdit.aspx"></iframe>'

                });
            }
            uploadReturnOrderWindow.addListener("hide", function() {
                updateDataGrid();
            });


            /*------开始查询form的函数 start---------------*/

            var WhNamePanel = new Ext.form.ComboBox({
                name: 'warehouseCombo',
                store: dsWarehouseList,
                displayField: 'WhName',
                valueField: 'WhId',
                typeAhead: true, //自动将第一个搜索到的选项补全输入
                triggerAction: 'all',
                emptyText: '请选择仓库',
                selectOnFocus: true,
                forceSelection: true,
                mode: 'local',
                fieldLabel: '仓库',
                anchor: '90%',
                id: 'WhName',
                value: dsWarehouseList.getRange()[0].data.WhId,
                editable: false,
                listeners: { specialkey: function(f, e) { if (e.getKey() == e.ENTER) { Ext.getCmp('Type').focus(); } }
                }

            });
            var TypePanel = new Ext.form.ComboBox({
                name: 'returnTypeCombo',
                store: dsReturnTypeList,
                displayField: 'DicsName',
                valueField: 'DicsCode',
                typeAhead: true, //自动将第一个搜索到的选项补全输入
                triggerAction: 'all',
                emptyText: '请选择退货类型',
                selectOnFocus: true,
                forceSelection: true,
                mode: 'local',
                fieldLabel: '退货类型',
                anchor: '90%',
                id: 'Type',
                listeners: { specialkey: function(f, e) { if (e.getKey() == e.ENTER) { Ext.getCmp('BillStatus').focus(); } } }
            });

            var StatusPanel = new Ext.form.ComboBox({
                name: 'billStatusCombo',
                store: dsBillStatus,
                displayField: 'BillStatusName',
                valueField: 'BillStatusId',
                typeAhead: true, //自动将第一个搜索到的选项补全输入
                triggerAction: 'all',
                value: 0, //未入仓
                selectOnFocus: true,
                forceSelection: true,
                editable: false,
                mode: 'local',
                fieldLabel: '单据状态',
                anchor: '90%',
                id: 'BillStatus',
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
                //layout: 'fit',
                buttonAlign: 'right',
                bodyStyle: 'padding:5px',
                frame: true,
                labelWidth: 55,
                items: [{
                    layout: 'column',   //定义该元素为布局为列布局方式
                    border: false,
                    items: [{
                        columnWidth: .3,  //该列占用的宽度，标识为20％
                        layout: 'form',
                        border: false,
                        items: [
                        WhNamePanel
                    ]
//                    }, {
//                        columnWidth: .3,
//                        layout: 'form',
//                        border: false,
//                        items: [
//                        TypePanel
//                        ]
                    }, {
                        columnWidth: .3,  //该列占用的宽度，标识为20％
                        layout: 'form',
                        border: false,
                        items: [
                        StatusPanel
                    ]
                    }
                    ]
                }
                    ,
                    {

                        layout: 'column',   //定义该元素为布局为列布局方式
                        border: false,
                        items: [{
                            columnWidth: .3,  //该列占用的宽度，标识为20％
                            layout: 'form',
                            border: false,
                            items: [
                        StartDatePanel
                    ]
                        }, {
                            columnWidth: .3,
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
            userGridData = new Ext.data.Store
({
    url: 'frmReturnOrderList.aspx?method=getReturnOrderList',
    reader: new Ext.data.JsonReader({
        totalProperty: 'totalProperty',
        root: 'root'
    }, [
	{
	    name: 'OrderId'
	},
	{
	    name: 'WhId'
	},
	{
	    name: 'Type'
	},
	{
	    name: 'OrgId'
	},
	{
	    name: 'OwnerId'
	},
	{
	    name: 'OperId'
	},
	{
	    name: 'CreateDate'
	},
	{
	    name: 'UpdateDate'
	},
	{
	    name: 'Status'
	},
	{
	    name: 'Remark'
	},
	{
	    name: 'OriginBillId'
	},
	{
	    name: 'ReturnStatus'
	},
	{
	    name: 'OrderNumber'
	}
])
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
            var userGrid = new Ext.grid.GridPanel({
                el: 'divOrderGrid',
                width: '100%',
                height: '100%',
                autoWidth: true,
                autoHeight: true,
                autoScroll: true,
                layout: 'fit',
                id: '',
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
                hidden:true,
                width:0
        },
		{
		        header: '编号',
		        dataIndex: 'OrderNumber',
		        id: 'OrderNumber'
        },
		{
		    header: '仓库',
		    dataIndex: 'WhId',
		    id: 'WhId',
		    renderer: function(val, params, record) {
		        if (dsWarehouseList.getCount() == 0) {
		            dsWarehouseList.load();
		        }
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
		    header: '退货类型',
		    dataIndex: 'Type',
		    id: 'Type',
		    renderer: function(val, params, record) {
		        if (dsReturnTypeList.getCount() == 0) {
		            dsReturnTypeList.load();
		        }
		        dsReturnTypeList.each(function(r) {
		            if (val == r.data['DicsCode']) {
		                val = r.data['DicsName'];
		                return;
		            }
		        });
		        return val;
		    }
		},

		{
		    header: '操作者',
		    dataIndex: 'OperId',
		    id: 'OperId',
		    renderer: function(val, params, record) {
		        if (dsOperationList.getCount() == 0) {
		            dsOperationList.load();
		        }
		        dsOperationList.each(function(r) {
		            if (val == r.data['EmpId']) {
		                val = r.data['EmpName'];
		                return;
		            }
		        });
		        return val;
		    }
		},
		{
		    header: '创建时间',
		    dataIndex: 'CreateDate',
		    id: 'CreateDate',
		    format: 'Y年m月d日'
		},

		{
		    header: '单据状态',
		    dataIndex: 'Status',
		    id: 'Status',
		    renderer: function(val, params, record) {
		        if (dsBillStatus.getCount() == 0) {
		            dsBillStatus.load();
		        }
		        dsBillStatus.each(function(r) {
		            if (val == r.data['BillStatusId']) {
		                val = r.data['BillStatusName'];
		                return;
		            }
		        });
		        return val;
		    }
		},

		{
		    header: '退货原因',
		    dataIndex: 'Remark',
		    id: 'Remark'
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
                    forceFit: true
                },
                height: 280,
                closeAction: 'hide',
                stripeRows: true,
                loadMask: true,
                autoExpandColumn: 2
            });
            
            userGrid.on('render', function(grid) {
                var store = grid.getStore();  // Capture the Store.  
                var view = grid.getView();    // Capture the GridView.
            userGrid.tip = new Ext.ToolTip({
                    target: view.mainBody,    // The overall target element.  
                    delegate: '.x-grid3-row', // Each grid row causes its own seperate show and hide.  
                    trackMouse: true,         // Moving within the row should not hide the tip.  
                    renderTo: document.body,  // Render immediately so that tip.body can be referenced prior to the first show.  
                    listeners: {              // Change content dynamically depending on which element triggered the show.  
                        beforeshow: function updateTipBody(tip) {
                            var rowIndex = view.findRowIndex(tip.triggerElement);
                            
                            var element = document.elementFromPoint(tip.x-20, tip.y-20);
                             var v = view.findCellIndex(element);
                             //细项信息
                              if(v==2||v==3)
                                {
                                    if(showTipRowIndex == rowIndex)
                                        return;
                                    else
                                        showTipRowIndex = rowIndex;
                                        
                                     tip.body.dom.innerHTML="正在加载数据……";
                                        //页面提交
                                        Ext.Ajax.request({
                                            url: 'frmReturnOrderList.aspx?method=getdetailinfo',
                                            method: 'POST',
                                            params: {
                                                OrderId: grid.getStore().getAt(rowIndex).data.OrderId
                                            },
                                            success: function(resp, opts) {
                                                tip.body.dom.innerHTML = resp.responseText;
                                            },
                                            failure: function(resp, opts) {
                                                userGrid.tip.hide();
                                            }
                                        });
                                }                                
                                else
                                {
                                    userGrid.tip.hide();
                                }
                        }
                    }
                });
    });
    var showTipRowIndex =-1;
            userGrid.render();
            /*------DataGrid的函数结束 End---------------*/
            updateDataGrid();


            //===============================================================

            function updateDataGrid_purchase() {

                var WhId = WhNamePanel_purchase.getValue();
                var SupplierId = SupplierNamePanel_purchase.getValue();
                var StartDate = Ext.util.Format.date(StartDatePanel_purchase.getValue(),'Y/m/d');
                var EndDate = Ext.util.Format.date(EndDatePanel_purchase.getValue(),'Y/m/d');
                var ShipNo= ShipNoPanel_purchase.getValue();
                var ReturnStatus = ReturnStatusPanel_purchase.getValue();
                //已经出入库的单据
                var BillStatus = 1;//BillStatusPanel_purchase.getValue();
                
                userGridData_purchase.baseParams.WhId = WhId;
                userGridData_purchase.baseParams.SupplierName = SupplierId;
                userGridData_purchase.baseParams.StartDate = StartDate;
                userGridData_purchase.baseParams.EndDate = EndDate;
                userGridData_purchase.baseParams.ShipNo = ShipNo;
                userGridData_purchase.baseParams.BillStatus = BillStatus;
                userGridData_purchase.baseParams.ReturnStatus = ReturnStatus;
                
                userGridData_purchase.load({
                    params: {
                        start: 0,
                        limit: 10
                    }
                });

            }
            /*------开始查询form的函数 start---------------*/

            var SupplierNamePanel_purchase = new Ext.form.TextField({              
                name: 'supplierCombo',
                fieldLabel: '供应商',
                anchor: '90%',
                listeners: { specialkey: function(f, e) { if (e.getKey() == e.ENTER) { Ext.getCmp('SWhName_purchase').focus(); } } }

            });


            var WhNamePanel_purchase = new Ext.form.ComboBox({
                name: 'warehouseCombo',
                store: dsWarehouseList,
                displayField: 'WhName',
                valueField: 'WhId',
                typeAhead: true, //自动将第一个搜索到的选项补全输入
                triggerAction: 'all',
                emptyText: '请选择仓库',
                selectOnFocus: true,
                forceSelection: true,
                mode: 'local',
                fieldLabel: '仓库名称',
                anchor: '90%',
                id: 'SWhName_purchase',
                listeners: { specialkey: function(f, e) { if (e.getKey() == e.ENTER) { Ext.getCmp('ReturnStatus_purchase').focus(); } } }
            });

            var ReturnStatusPanel_purchase = new Ext.form.ComboBox({
                name: 'returnStatusCombo',
                store: dsReturnStatus,
                displayField: 'ReturnStatusName',
                valueField: 'ReturnStatusId',
                typeAhead: true, //自动将第一个搜索到的选项补全输入
                triggerAction: 'all',
                value: 0, //未入仓
                selectOnFocus: true,
                forceSelection: true,
                editable: false,
                mode: 'local',
                fieldLabel: '退货状态',
                anchor: '98%',
                id: 'ReturnStatus_purchase',
                listeners: { specialkey: function(f, e) { if (e.getKey() == e.ENTER) { Ext.getCmp('StartDate_purchase').focus(); } } }
            });
            var StartDatePanel_purchase = new Ext.form.DateField({
                style: 'margin-left:0px',
                cls: 'key',
                xtype: 'datefield',
                fieldLabel: '开始时间',
                format: 'Y年m月d日',
                anchor: '90%',
                value: new Date().getFirstDateOfMonth().clearTime(),
                id: 'StartDate_purchase',
                listeners: { specialkey: function(f, e) { if (e.getKey() == e.ENTER) { Ext.getCmp('EndDate_purchase').focus(); } } }
            });
            var EndDatePanel_purchase = new Ext.form.DateField({
                style: 'margin-left:0px',
                cls: 'key',
                xtype: 'datefield',
                fieldLabel: '结束时间',
                anchor: '90%',
                format: 'Y年m月d日',
                id: 'EndDate_purchase',
                value: new Date().clearTime(),
                listeners: { specialkey: function(f, e) { if (e.getKey() == e.ENTER) { Ext.getCmp('ShipNo_purchase').focus(); } } }
            });
            var ShipNoPanel_purchase = new Ext.form.TextField({              
                name: 'ShipNo_purchase',
                fieldLabel: '车船号',
                anchor: '98%',
                listeners: { specialkey: function(f, e) { if (e.getKey() == e.ENTER) { Ext.getCmp('searchebtnId_purchase').focus(); } } }

            });
            var serchform_purchase = new Ext.FormPanel({
                region: 'north',
                labelAlign: 'left',
                buttonAlign: 'right',
                bodyStyle: 'padding:5px',
                frame: true,
                labelWidth: 55,
                height: 70,
                items: [{
                    layout: 'column',   //定义该元素为布局为列布局方式
                    border: false,
                    items: [{
                        columnWidth: .3,  //该列占用的宽度，标识为20％
                        layout: 'form',
                        border: false,
                        items: [
                            SupplierNamePanel_purchase
                    ]
                    }, {
                        columnWidth: .3,
                        layout: 'form',
                        border: false,
                        items: [
                            WhNamePanel_purchase
                        ]
                    }, {
                        columnWidth: .25,
                        layout: 'form',
                        border: false,
                        items: [
                            ReturnStatusPanel_purchase
                        ]
                    }
                    ]
                }
                    ,
                    {

                        layout: 'column',   //定义该元素为布局为列布局方式
                        border: false,
                        items: [{
                            columnWidth: .3,  //该列占用的宽度，标识为20％
                            layout: 'form',
                            border: false,
                            items: [
                            StartDatePanel_purchase
                    ]
                        }, {
                            columnWidth: .3,
                            layout: 'form',
                            border: false,
                            items: [
                            EndDatePanel_purchase
                        ]
                        }, {
                            columnWidth: .25,
                            layout: 'form',
                            border: false,
                            items: [
                            ShipNoPanel_purchase
                        ]
                        }, {
                            columnWidth: .15,
                            layout: 'form',
                            border: false,
                            items: [{ cls: 'key',
                                xtype: 'button',
                                text: '查询',
                                id: 'searchebtnId_purchase',
                                anchor: '70%',
                                handler: function() {
                                    updateDataGrid_purchase();
                                }
}]
}]
}]
            });


            /*------开始查询form的函数 end---------------*/

            /*------开始获取数据的函数 start---------------*/
            var userGridData_purchase = new Ext.data.Store
            ({
                url: 'frmReturnPurchaseOrderList.aspx?method=getPurchaseOrderList',
                reader: new Ext.data.JsonReader({
                    totalProperty: 'totalProperty',
                    root: 'root'
                }, [
	                {
	                    name: 'OrderId'
	                },
	                {
	                    name: 'SupplierId'
	                },
	                {
	                    name: 'WhId'
	                },
	                {
	                    name: 'OrgId'
	                },
	                {
	                    name: 'OwnerId'
	                },
	                {
	                    name: 'OperId'
	                },
	                {
	                    name: 'CreateDate'
	                },
	                {
	                    name: 'UpdateDate'
	                },
	                {
	                    name: 'BillType'
	                },
	                {
	                    name: 'FromBillId'
	                },
	                {
	                    name: 'BillStatus'
	                },
	                {
	                    name: 'CarBoatNo'
	                },
	                {
	                    name: 'Remark'
	                },
	                {
	                    name: 'SupplierName'
	                },
	                {
	                    name: 'OperName'
	                },
	                {
	                    name: 'ReturnStatus'
	                }
                ])
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
            var selectCurrentRowData = null;//选择的采购单记录数据
            
            var sm = new Ext.grid.CheckboxSelectionModel({
                singleSelect: true
            });
            var userGrid_Purchase = new Ext.grid.GridPanel({
                //el: 'divOrderGrid',
                //region: 'center',
                width: '100%',
                height: '80',
                autoWidth: true,
                //autoHeight: true,
                autoScroll: true,
                layout: 'fit',
                id: '',
                store: userGridData_purchase,
                loadMask: { msg: '正在加载数据，请稍侯……' },
                sm: sm,
                cm: new Ext.grid.ColumnModel([
		sm,
		new Ext.grid.RowNumberer(), //自动行号
		{
		header: '订单号',
		dataIndex: 'OrderId',
		id: 'OrderId'
},
		{
		    header: '供应商',
		    dataIndex: 'SupplierName',
		    id: 'SupplierName'
		},
		{
		    header: '仓库',
		    dataIndex: 'WhId',
		    id: 'WhId',
		    renderer: function(val, params, record) {
		        if (dsWarehouseList.getCount() == 0) {
		            dsWarehouseList.load();
		        }
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
		    header: '操作者',
		    dataIndex: 'OperName',
		    id: 'OperName'
		},
		{
		    header: '创建时间',
		    dataIndex: 'CreateDate',
		    id: 'CreateDate',
		    format: 'Y年m月d日'
		},
//		{
//		    header: '单据类型',
//		    dataIndex: 'BillType',
//		    id: 'BillType',
//		    renderer: function(val, params, record) {
//		        if (dsBillType.getCount() == 0) {
//		            dsBillType.load();
//		        }
//		        dsBillType.each(function(r) {
//		            if (val == r.data['DicsCode']) {
//		                val = r.data['DicsName'];
//		                return;
//		            }
//		        });
//		        return val;
//		    }
//		},
		{
		    header: '退货状态',
		    dataIndex: 'ReturnStatus',
		    id: 'ReturnStatus',
		    renderer: function(val, params, record) {
		        if (dsReturnStatus.getCount() == 0) {
		            dsReturnStatus.load();
		        }
		        dsReturnStatus.each(function(r) {
		            if (val == r.data['ReturnStatusId']) {
		                val = r.data['ReturnStatusName'];
		                return;
		            }
		        });
		        return val;
		    }
		},
		{
		    header: '车船号',
		    dataIndex: 'CarBoatNo',
		    id: 'CarBoatNo'
		},
		{
		    header: '备注',
		    dataIndex: 'Remark',
		    id: 'Remark'
}]),
                bbar: new Ext.PagingToolbar({
                    pageSize: 100,
                    store: userGridData_purchase,
                    displayMsg: '显示第{0}条到{1}条记录,共{2}条',
                    emptyMsy: '没有记录',
                    displayInfo: true
                }),
                viewConfig: {
                    columnsText: '显示的列',
                    scrollOffset: 20,
                    sortAscText: '升序',
                    sortDescText: '降序',
                    forceFit: true
                },
                height: 160,
                closeAction: 'hide',
                stripeRows: true,
                loadMask: true,
                autoExpandColumn: 2,
                listeners: {
                    rowclick: function(grid, rowIndex, e) {
                        selectCurrentRowData = userGridData_purchase.getAt(rowIndex).data;
                        var oId = selectCurrentRowData.OrderId;
                        var returnStatus = selectCurrentRowData.ReturnStatus;
//                        if(parseInt(returnStatus) == 1){
//                            Ext.Msg.alert("提示","该采购单已经退过货了，不能再次退！");
//                            return;
//                        }
                        GenReturnOrderGrid(oId);
                    }
                }
            });
            //userGrid.render();
            /*------DataGrid的函数结束 End---------------*/
            /*------退货单可编辑DataGrid的函数开始---------------*/
            function inserNewBlankRow() {
                var rowCount = userGrid_return.getStore().getCount();
                var insertPos = parseInt(rowCount);
                var addRow = new RowPattern({
                    ProductId: '',
                    ProductCode: '',
                    ProductUnit: '',
                    ProductSpec: '',
                    ProductPrice: '',
                    RealQty: ''
                });
                userGrid_return.stopEditing();
                //增加一新行
                if (insertPos > 0) {
                    var rowIndex = dsPurchaseOrderProduct.insert(insertPos, addRow);
                    userGrid_return.startEditing(insertPos, 0);
                }
                else {
                    var rowIndex = dsPurchaseOrderProduct.insert(0, addRow);
                    userGrid_return.startEditing(0, 0);
                }
            }
            function addNewBlankRow(combo, record, index) {
                var rowIndex = userGrid_return.getStore().indexOf(userGrid_return.getSelectionModel().getSelected());
                var rowCount = userGrid_return.getStore().getCount();
                if ((rowIndex == 0 && rowCount == 1) || rowIndex == rowCount - 1) {
                    inserNewBlankRow();
                }
            }
            //点击采购单记录预生成退货记录
            function GenReturnOrderGrid(OrderId) {
                dsPurchaseOrderProduct.load({
                    params: {
                        start: 0,
                        limit: 100,
                        OrderId: OrderId
                    },
                    callback: function(r, options, success) {
                        if (success == true) {
                            //default 0
                            dsPurchaseOrderProduct.each(function(r) {
                                r.set('ReturnQty',0);
                            });
                            var columnCount = userGrid_return.getColumnModel().getColumnCount();
                            //alert(columnCount);
                            for (var i = 0; i < columnCount; i++) {
                                userGrid_return.getColumnModel().setEditable(i, false);
                            }
                            //退货数量可编辑
                            userGrid_return.getColumnModel().setEditable(columnCount-2, true);
                        }
                    }
                });
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
                typeAhead: true,
                mode: 'local',
                emptyText: '',
                selectOnFocus: false,
                editable: false,
                listeners: {
                    "select": addNewBlankRow
                }
            });


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
                    var sm = userGrid_return.getSelectionModel().getSelected();
                    sm.set('ProductCode', record.data.ProductNo);
                    sm.set('ProductSpec', record.data.Specifications);
                    sm.set('ProductUnit', record.data.Unit);
                    sm.set('ProductId', record.data.ProductId);
                    addNewBlankRow();
                }
            });
            var cm_return = new Ext.grid.ColumnModel([
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
                        return displayText;
                    }
                },

                {
                    id: "ProductUnit",
                    header: "单位",
                    dataIndex: "ProductUnit",
                    width: 20,
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
                    }
                }
                , {
                    id: 'ProductSpec',
                    header: "规格",
                    dataIndex: 'ProductSpec',
                    width: 30,
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
                    width: 20,
                    editor: new Ext.form.TextField({ allowBlank: false })
                }, {
                    id: 'RealQty',
                    header: "采购数量",
                    dataIndex: 'RealQty',
                    width: 20,
                    editor: new Ext.form.TextField({ allowBlank: false })
                 }, {
                    id: 'ReturnQty',
                    header: "退货数量",
                    dataIndex: 'ReturnQty',
                    width: 20,
                    renderer: function(v, m) {
                        m.css = 'x-grid-back-blue';
                        return v;
                    },editor: new Ext.form.TextField({ allowBlank: false })
                }, new Extensive.grid.ItemDeleter()
            ]);
            cm_return.defaultSortable = true;

            var RowPattern = Ext.data.Record.create([
               { name: 'OrderDetailId', type: 'string' },
               { name: 'ProductId', type: 'string' },
               { name: 'ProductCode', type: 'string' },
               { name: 'ProductUnit', type: 'string' },
               { name: 'ProductSpec', type: 'string' },
               { name: 'ProductPrice', type: 'string' },
               { name: 'RealQty', type: 'string' },
               { name:'ReturnQty',type:'string'},
               { name: 'UnitId', type: 'string' }
            ]);

            var dsPurchaseOrderProduct;
            if (dsPurchaseOrderProduct == null) {
                dsPurchaseOrderProduct = new Ext.data.Store
	            ({
	                url: 'frmReturnPurchaseOrderList.aspx?method=getPurchaseOrderProductList',
	                reader: new Ext.data.JsonReader({
	                    totalProperty: 'totalProperty',
	                    root: 'root'
	                }, RowPattern)
	            });
	          
            }
            var userGrid_return = new Ext.grid.EditorGridPanel({
                //region: 'south',
                store: dsPurchaseOrderProduct,
                cm: cm_return,
                selModel: new Extensive.grid.ItemDeleter(),
                layout: 'fit',
                width: '100%',
                height: 120,
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
            var returnOrderForm = new Ext.FormPanel({
                            labelAlign: 'left',
                            buttonAlign: 'right',
                            bodyStyle: 'padding:5px',
                            frame: true,
                            labelWidth: 55, 
                            height:80,
                            items:[
                            {
	                            layout:'column',
	                            border: false,
	                            labelSeparator: '：',
	                            items: [
	                            {
		                            layout:'form',
		                            border: false,
		                            columnWidth:1,
		                            items: [
			                            {
				                            xtype:'textarea',
				                            fieldLabel:'退货原因',
				                            columnWidth:1,
				                            anchor:'90%',
				                            name:'Remark',
				                            id:'Remark'
			                            }
	                            ]
	                            }
                                        
                       
                            ]}                  
                        ]});
            //userGrid.render();
            //===============================================================
            if (typeof (uploadPurchaseOrderWindow) == "undefined") {
                uploadPurchaseOrderWindow = new Ext.Window({
                    id: 'PurchaseOrderformwindow',
                    title: '生成采购退货单'
		            , iconCls: 'upload-win'
		            , width: 750
		            , height: 500
		            , layout: 'form'
		            , plain: true
		            , modal: true
		            , constrain: true
		            , resizable: false
		            , closeAction: 'hide'
		            , autoDestroy: true
		            , items: [//serchform_purchase, userGrid_Purchase, userGrid_return
		                {       layout:'form',
                                border: false,
                                columnWidth:1,
                                items: [  serchform_purchase ]
                         },
                         {       layout:'form',
                                border: false,
                                columnWidth:1,
                                items: [  userGrid_Purchase ]
                         },
                         {       layout:'form',
                                border: false,
                                columnWidth:1,
                                items: [ returnOrderForm ]
                         },
                         {       layout:'form',
                                border: false,
                                columnWidth:1,
                                items: [  userGrid_return ]
                         }
		            ]
		            , buttons: [{
		                text: "保存"
			            , handler: function() {
			            
			            /*检查退货数量是否超过了采购数量*/
			            for(var i=0;i<dsPurchaseOrderProduct.data.items.length;i++)
			            {
			               if(parseFloat(dsPurchaseOrderProduct.data.items[i].data.RealQty)<
			                    parseFloat(dsPurchaseOrderProduct.data.items[i].data.ReturnQty))
			                    {
			                        alert("退货数量太多，超过采购量了！");
			                        return;
			                    }
			            }
			            
			            
			            Ext.MessageBox.wait("数据正在保存，请稍候……");
			            if(!checkUIData()) return;
		                json = "";
		                dsPurchaseOrderProduct.each(function(dsPurchaseOrderProduct) {
		                    json += Ext.util.JSON.encode(dsPurchaseOrderProduct.data) + ',';
		                });
		                json = json.substring(0, json.length - 1);
		                //alert();
		                //return;
		                Ext.Ajax.request({
		                    url: 'frmReturnPurchaseOrderList.aspx?method=saveReturnOrderInfo',
		                    method: 'POST',
		                    params: {
		                        //主参数
		                        WhId: selectCurrentRowData.WhId,
		                   
		                        OperId: <%=ZJSIG.UIProcess.ADM.UIAdmUser.EmployeeID(this) %>,
		                        CreateDate: new Date(),
		                        Remark: Ext.getCmp("Remark").getValue(),
		                        Status: 0,
		                        OrderId: 0,
		                        OriginBillId:selectCurrentRowData.OrderId,
		                        Type:'W0209',//采购退货
		                        OrgId: selectCurrentRowData.OrgId,
		                        //明细参数
		                        DetailInfo: json
		                    },
		                    success: function(resp, opts) {
		                        Ext.MessageBox.hide();
		                        if (checkExtMessage(resp)) {
		                            updateDataGrid();
		                            uploadPurchaseOrderWindow.hide();
		                            
		                        }
		                    },
		                    failure: function(resp,opts){  Ext.MessageBox.hide();} 
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
                serchform_purchase.getForm().reset();
                userGrid_Purchase.getStore().removeAll();
                userGrid_return.getStore().removeAll();
                returnOrderForm.getForm().reset();
            });
            //inserNewBlankRow();
//UI合法性检查      
function checkUIData(){
    var check = true;
    
    if(selectCurrentRowData == null){
        Ext.Msg.alert("提示","请选择退货记录！");
        return false;
    }
    
    var remark = Ext.getCmp("Remark").getValue().replace(/(^\s*)|(\s*$)/g,"");
    //alert(remark.length);
    if(remark.length == 0){
        Ext.Msg.alert("提示","请输入退货原因！");
        return false;
    }
    
    return check;
}
        })
</script>

</html>
