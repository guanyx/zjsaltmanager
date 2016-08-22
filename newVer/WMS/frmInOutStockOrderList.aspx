<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmInOutStockOrderList.aspx.cs" Inherits="WMS_frmInOutStockOrderList" %>

<html>
<head>
<title>进出仓单据列表页面</title><meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<link rel="stylesheet" type="text/css" href="../ext3/resources/css/ext-all.css" />
<script type="text/javascript" src="../ext3/adapter/ext/ext-base.js"></script>
<script type="text/javascript" src="../ext3/ext-all.js"></script>
<script type="text/javascript" src="../ext3/src/locale/ext-lang-zh_CN.js"></script>
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
        /*------实现toolbar的函数 start---------------*/
        var Toolbar = new Ext.Toolbar({
            renderTo: "toolbar",
            items: [{
                text: "生成入仓单",
                icon: "../theme/1/images/extjs/customer/add16.gif",
                handler: function() { generateInStockOrderWin(); }
            }, '-', {
                text: "查看进货单",
                icon: "../theme/1/images/extjs/customer/edit16.gif",
                handler: function() { lookOrderWin(); }
            }]
            });

            /*------结束toolbar的函数 end---------------*/


            /*------开始ToolBar事件函数 start---------------*//*-----新增Order实体类窗体函数----*/
            function updateDataGrid() {

                var WhId = WhNamePanel.getValue();
                var SupplierId = SupplierNamePanel.getValue();
                var StartDate = Ext.util.Format.date(StartDatePanel.getValue(),'Y/m/d');
                var EndDate = Ext.util.Format.date(EndDatePanel.getValue(),'Y/m/d');
                var BillStatus = BillStatusPanel.getValue();
                userGridData.load({
                    params: {
                        start: 0,
                        limit: 10,
                        WhId: WhId,
                        SupplierId: SupplierId,
                        StartDate: StartDate,
                        EndDate: EndDate,
                        BillStatus: BillStatus
                    }
                });

            }
            //生成入库单
            function generateInStockOrderWin() {
                var sm = userGrid.getSelectionModel();
                //获取选择的数据信息
                var selectData = sm.getSelected();
                if (selectData == null) {
                    Ext.Msg.alert("提示", "请选择进货单记录！");
                    return;
                }
                if (selectData.data.BillStatus != 0)//不是未入仓状态
                {
                    Ext.Msg.alert("提示", "只有未入仓的进货单才能做入仓操作！");
                    return;
                }
                uploadOrderWindow.show();
                document.getElementById("editIFrame").src = "frmInStockBill.aspx?type=W0201&id=" + selectData.data.OrderId;
            }
            /*-----察看Order实体类窗体函数----*/
            function lookOrderWin() {
                var sm = userGrid.getSelectionModel();
                //获取选择的数据信息
                var selectData = sm.getSelected();
                if (selectData == null) {
                    Ext.Msg.alert("提示", "请选中需要查看的信息！");
                    return;
                }
                uploadPurchaseOrderWindow.show();
                document.getElementById("editPurchaseIFrame").src = "frmPurchaseOrderEdit.aspx?status=readonly&id=" + selectData.data.OrderId;
            }


            /*------开始界面数据的窗体 Start---------------*/
            if (typeof (uploadOrderWindow) == "undefined") {//解决创建2个windows问题
                uploadOrderWindow = new Ext.Window({
                    id: 'Orderformwindow'
		            , iconCls: 'upload-win'
		            , width: 750
		            , height: 555
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
            });

            if (typeof (uploadPurchaseOrderWindow) == "undefined") {//解决创建2个windows问题
                uploadPurchaseOrderWindow = new Ext.Window({
                id: 'PurchaseOrderWindow'
		            , iconCls: 'upload-win'
		            , width: 750
		            , height: 480
		            , layout: 'fit'
		            , plain: true
		            , modal: true
		            , constrain: true
		            , resizable: false
		            , closeAction: 'hide'
		            , autoDestroy: true
		            , html: '<iframe id="editPurchaseIFrame" width="100%" height="100%" border=0 src="frmPurchaseOrderEdit.aspx"></iframe>'

                });
            }
            uploadPurchaseOrderWindow.addListener("hide", function() {
        });
            
            /*------开始获取界面数据的函数 start---------------*/
            function getFormValue() {
                var dateCreateDate = Ext.get("CreateDate").getValue();
                if (dateCreateDate != '')
                    dateCreateDate = Ext.util.Format.date(dateCreateDate,'Y/m/d');

                Ext.Ajax.request({
                    url: 'frmInOutStockOrderList.aspx?method=SaveOrder',
                    method: 'POST',
                    params: {
                        OrderId: Ext.getCmp('OrderId').getValue(),
                        SupplierId: Ext.getCmp('SupplierId').getValue(),
                        WhId: Ext.getCmp('WhId').getValue(),
                        OrgId: Ext.getCmp('OrgId').getValue(),
                        OwnerId: Ext.getCmp('OwnerId').getValue(),
                        OperId: Ext.getCmp('OperId').getValue(),
                        CreateDate: dateCreateDate,
                        UpdateDate: Ext.getCmp('UpdateDate').getValue(),
                        BillType: Ext.getCmp('BillType').getValue(),
                        FromBillId: Ext.getCmp('FromBillId').getValue(),
                        BillStatus: Ext.getCmp('BillStatus').getValue(),
                        Remark: Ext.getCmp('Remark').getValue()
                    },
                    success: function(resp, opts) {
                        Ext.Msg.alert("提示", "保存成功！");
                    },
                    failure: function(resp, opts) {
                        Ext.Msg.alert("提示", "保存失败！");
                    }
                });
            }
            /*------结束获取界面数据的函数 End---------------*/

            /*------开始界面数据的函数 Start---------------*/
            function setFormValue(selectData) {
                Ext.Ajax.request({
                    url: 'frmInOutStockOrderList.aspx?method=getInOutStockOrder',
                    params: {
                        OrderId: selectData.data.OrderId
                    },
                    success: function(resp, opts) {
                        var data = Ext.util.JSON.decode(resp.responseText);
                        Ext.getCmp("OrderId").setValue(data.OrderId);
                        Ext.getCmp("SupplierId").setValue(data.SupplierId);
                        Ext.getCmp("WhId").setValue(data.WhId);
                        Ext.getCmp("OrgId").setValue(data.OrgId);
                        Ext.getCmp("OwnerId").setValue(data.OwnerId);
                        Ext.getCmp("OperId").setValue(data.OperId);
                        if (data.CreateDate != '')
                            Ext.getCmp("CreateDate").setValue(Ext.util.Format.date(data.CreateDate,'Y/m/d'));
                        Ext.getCmp("UpdateDate").setValue(data.UpdateDate);
                        Ext.getCmp("BillType").setValue(data.BillType);
                        Ext.getCmp("FromBillId").setValue(data.FromBillId);
                        Ext.getCmp("BillStatus").setValue(data.BillStatus);
                        Ext.getCmp("Remark").setValue(data.Remark);
                    },
                    failure: function(resp, opts) {
                        Ext.Msg.alert("提示", "获取进货信息失败！");
                    }
                });
            }
            /*------结束设置界面数据的函数 End---------------*/

            /*------开始查询form的函数 start---------------*/

            var SupplierNamePanel = new Ext.form.ComboBox({
                name: 'supplierCombo',
                store: dsSuppliesListInfo,
                displayField: 'ChineseName',
                valueField: 'CustomerId',
                typeAhead: true, //自动将第一个搜索到的选项补全输入
                triggerAction: 'all',
                emptyText: '请选择供应商',
                selectOnFocus: true,
                forceSelection: true,
                mode: 'local',
                fieldLabel: '供应商',
                anchor: '90%',
                listeners: { specialkey: function(f, e) { if (e.getKey() == e.ENTER) { Ext.getCmp('SWhName').focus(); } } }

            });


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
                fieldLabel: '仓库名称',
                anchor: '90%',
                id: 'SWhName',
                listeners: { specialkey: function(f, e) { if (e.getKey() == e.ENTER) { Ext.getCmp('BillStatus').focus(); } } }
            });

            var BillStatusPanel = new Ext.form.ComboBox({
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
                        SupplierNamePanel
                    ]
                    }, {
                        columnWidth: .3,
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
                        BillStatusPanel
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
            var userGridData = new Ext.data.Store
({
    url: 'frmInOutStockOrderList.aspx?method=getInOutStockOrderList',
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
                //		{
                //			header:'组织ID',
                //			dataIndex:'OrgId',
                //			id:'OrgId'
                //		},
                //		{
                //			header:'所有者ID',
                //			dataIndex:'OwnerId',
                //			id:'OwnerId'
                //		},
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
                //			header:'更新时间',
                //			dataIndex:'UpdateDate',
                //			id:'UpdateDate'
                //		},
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
		}
},
                //		{
                //		    header: '来源单据号',
                //		    dataIndex: 'FromBillId',
                //		    id: 'FromBillId'
                //		},
		{
		header: '单据状态',
		dataIndex: 'BillStatus',
		id: 'BillStatus',
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
            userGrid.render();
            /*------DataGrid的函数结束 End---------------*/
            updateDataGrid();


        })
</script>

</html>
