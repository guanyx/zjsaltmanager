<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmReturnOrderList.aspx.cs" Inherits="WMS_frmReturnOrderList" %>

<html>
<head>
<title>退货单列表页面</title><meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<link rel="stylesheet" type="text/css" href="../ext3/resources/css/ext-all.css" />
<script type="text/javascript" src="../ext3/adapter/ext/ext-base.js"></script>
<script type="text/javascript" src="../ext3/ext-all.js"></script>
<script type="text/javascript" src="../ext3/src/locale/ext-lang-zh_CN.js"></script>
<style  type="text/css">
.x-date-menu {
   width: 175;
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
                text: "编辑",
                icon: "../theme/1/images/extjs/customer/add16.gif",
                handler: function() { lookOrderWin(); }
            }, '-', {
                text: "取消确认",
                icon: "../theme/1/images/extjs/customer/edit16.gif",
                handler: function() { cancelOrder(); }
            }, '-', {
                text: "生成出入库单",
                icon: "../theme/1/images/extjs/customer/edit16.gif",
                handler: function() { generateOrderWin(); }
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
            //取消退货确认信息
            function cancelOrder() {
                var sm = userGrid.getSelectionModel();
                //获取选择的数据信息
                var selectData = sm.getSelected();
                if (selectData == null) {
                    Ext.Msg.alert("提示", "请选择退货单记录！");
                    return;
                }
                
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
                userGridData.baseParams.EndDate = EndDate;
                userGridData.baseParams.Type = Type;
                userGridData.baseParams.Status = Status;

                userGridData.load({
                    params: {
                        start: 0,
                        limit: 10
                    }
                });
            }



            function lookOrderWin() {
                var sm = userGrid.getSelectionModel();
                //获取选择的数据信息
                var selectData = sm.getSelected();
                if (selectData == null) {
                    Ext.Msg.alert("提示", "请选择退货单记录！");
                    return;
                }

                uploadReturnOrderWindow.show();
                uploadReturnOrderWindow.setTitle("退货单明细记录");
                document.getElementById("editReturnOrderIFrame").src = "frmReturnOrderEdit.aspx?id=" + selectData.data.OrderId;
            }



            //生成出库单
            function generateOrderWin() {
                var sm = userGrid.getSelectionModel();
                //获取选择的数据信息
                var selectData = sm.getSelected();
                if (selectData == null) {
                    Ext.Msg.alert("提示", "请选择退货单！");
                    return;
                }
                if (selectData.data.Status == 2)//已出仓状态
                {
                    Ext.Msg.alert("提示", "该退货单已经做过出入仓操作！");
                    return;
                }
                var returnType = selectData.data.Type;
                uploadOrderWindow.show();
                document.getElementById("editIFrame").src = "frmInStockBill.aspx?type=" + returnType + "&id=" + selectData.data.OrderId;
            }

            /*------开始界面数据的窗体 Start---------------*/
            if (typeof (uploadOrderWindow) == "undefined") {//解决创建2个windows问题
                uploadOrderWindow = new Ext.Window({
                    id: 'Orderformwindow'
		            , iconCls: 'upload-win'
		            , width: 750
		            , height: 515
		            , layout: 'fit'
		            , plain: true
		            , modal: true
		            , constrain: true
		            , resizable: false
		            , closeAction: 'hide'
		            , autoDestroy: true
		            , html: '<iframe id="editIFrame" width="100%" height="100%" border=0 src="frmInStockBill.aspx"></iframe>'

                });
            }
            uploadOrderWindow.addListener("hide", function() {
                updateDataGrid();
            });

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
                listeners: { specialkey: function(f, e) { if (e.getKey() == e.ENTER) { Ext.getCmp('Status').focus(); } } }
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
                id: 'Status',
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
                    }, {
                        columnWidth: .3,
                        layout: 'form',
                        border: false,
                        items: [
                        TypePanel
                        ]
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
	    name: 'OrderNumber'
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
		hidden: true,
		hideable: false
}, {
    header: '订单编号',
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
		        if(val == 2)
                {
                    if(record.data.Type=="W0204")
                        return '已入库';
                    else
                        return '已出库';
                }
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
		    header: '备注',
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


        })
</script>

</html>
