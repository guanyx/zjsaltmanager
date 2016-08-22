<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmShiftPosOrderList.aspx.cs" Inherits="WMS_frmShiftPosOrderList" %>

<html>
<head>
<title>移库单列表页面</title><meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<link rel="stylesheet" type="text/css" href="../ext3/resources/css/ext-all.css" />
<script type="text/javascript" src="../ext3/adapter/ext/ext-base.js"></script>
<script type="text/javascript" src="../ext3/ext-all.js"></script>
<script type="text/javascript" src="../js/operateResp.js"></script>
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
    var userGridData;
    Ext.onReady(function() {
        /*------实现toolbar的函数 start---------------*/
        var windowTitle = "";
        var Toolbar = new Ext.Toolbar({
            renderTo: "toolbar",
            items: [{
                text: "新增",
                icon: "../theme/1/images/extjs/customer/add16.gif",
                handler: function() { AddOrderWin(); }
            }, '-', {
                text: "编辑",
                icon: "../theme/1/images/extjs/customer/edit16.gif",
                handler: function() { EditOrderWin(); }
            }, '-', {
                text: "删除",
                icon: "../theme/1/images/extjs/customer/delete16.gif",
                handler: function() { deleteOrderWin(); }
            }, '-', {
                text: "提交",
                icon: "../theme/1/images/extjs/customer/edit16.gif",
                handler: function() { commitOrderWin(); }
            }, '-', {
                text: " 查看移仓单",
                icon: "../theme/1/images/extjs/customer/edit16.gif",
                handler: function() { lookOrderWin(); }
}]
            });

            /*------结束toolbar的函数 end---------------*/
            var dsWarehousePosList; //仓位下拉框
            if (dsWarehousePosList == null) { //防止重复加载
                dsWarehousePosList = new Ext.data.JsonStore({
                    totalProperty: "result",
                    root: "root",
                    url: 'frmShiftPosOrderList.aspx?method=getWarehousePositionList',
                    fields: ['WhpId', 'WhpName']
                });
            }

            var defaultWhId = 0;
            if (dsWarehouseList.getRange().length > 0) {
                defaultWhId = dsWarehouseList.getRange()[0].data.WhId;
            }
            /*------开始ToolBar事件函数 start---------------*//*-----新增Order实体类窗体函数----*/
            function updateDataGrid() {
                var WhId = WhNamePanel.getValue();
                var OutWhpId = OutWhpNamePanel.getValue();
                var InWhpId = InWhpNamePanel.getValue();
                var StartDate = Ext.util.Format.date(StartDatePanel.getValue(),'Y/m/d');
                var EndDate = Ext.util.Format.date(EndDatePanel.getValue(),'Y/m/d');
                var Status = StatusPanel.getValue();

                userGridData.baseParams.WhId = WhId;
                userGridData.baseParams.OutWhpId = OutWhpId;
                userGridData.baseParams.InWhpId = InWhpId;
                userGridData.baseParams.StartDate = StartDate;
                userGridData.baseParams.EndDate = EndDate;
                userGridData.baseParams.Status = Status;

                userGridData.load({
                    params: {
                        start: 0,
                        limit: 10
                    }
                });
                //alert(WhId);
                if (WhId < 1) {
                    WhId = defaultWhId; //dsWarehouseList.getRange()[0].data.WhId;
                }
                dsWarehousePosList.load({

                    params: {
                        WhId: WhId
                    }
                });
            }

            function AddOrderWin() {
                uploadShiftPosOrderWindow.show();
                uploadShiftPosOrderWindow.setTitle("新增移仓单");
                document.getElementById("editShiftPosOrderIFrame").src = "frmShiftPosOrderEdit.aspx?id=0";

                //                if (document.getElementById("editShiftPosOrderIFrame").src.indexOf("frmShiftPosOrderEdit") == -1) {
                //                    document.getElementById("editShiftPosOrderIFrame").src = "frmShiftPosOrderEdit.aspx?id=0";
                //                }
                //                else {
                //                    document.getElementById("editShiftPosOrderIFrame").contentWindow.OrderId = 0;
                //                    document.getElementById("editShiftPosOrderIFrame").contentWindow.setAllFormValue();
                //                }
            }

            function EditOrderWin() {
                var sm = userGrid.getSelectionModel();
                //获取选择的数据信息
                var selectData = sm.getSelected();
                if (selectData == null) {
                    Ext.Msg.alert("提示", "请选择移仓单记录！");
                    return;
                }
                if (selectData.data.Status != 0)//不是未入仓状态
                {
                    Ext.Msg.alert("提示", "只有未提交的移库单单才能编辑！");
                    return;
                }
                uploadShiftPosOrderWindow.show();
                uploadShiftPosOrderWindow.setTitle("编辑移仓单");
                document.getElementById("editShiftPosOrderIFrame").src = "frmShiftPosOrderEdit.aspx?id=" + selectData.data.OrderId;

                //                if (document.getElementById("editShiftPosOrderIFrame").src.indexOf("frmShiftPosOrderEdit") == -1) {
                //                    document.getElementById("editShiftPosOrderIFrame").src = "frmShiftPosOrderEdit.aspx?id=" + selectData.data.OrderId;
                //                }
                //                else {
                //                    document.getElementById("editShiftPosOrderIFrame").contentWindow.OrderId = selectData.data.OrderId;
                //                    document.getElementById("editShiftPosOrderIFrame").contentWindow.setAllFormValue();
                //                }
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
                if (selectData.data.Status != 0)//不是未入仓状态
                {
                    Ext.Msg.alert("提示", "已提交的移库单不能删除！");
                    return;
                }
                //删除前再次提醒是否真的要删除
                Ext.Msg.confirm("提示信息", "是否真的要删除选择的移库单吗？", function callBack(id) {
                    //判断是否删除数据
                    if (id == "yes") {
                        //页面提交
                        Ext.Ajax.request({
                            url: 'frmShiftPosOrderList.aspx?method=deleteShiftPosOrder',
                            method: 'POST',
                            params: {
                                OrderId: selectData.data.OrderId
                            },
                            success: function(resp, opts) {
                                Ext.Msg.alert("提示", "数据删除成功！");
                                updateDataGrid(); //刷新页面
                            },
                            failure: function(resp, opts) {
                                Ext.Msg.alert("提示", "数据删除失败！");
                            }
                        });
                    }
                });
            }

            //提交
            function commitOrderWin() {
                var sm = userGrid.getSelectionModel();
                //获取选择的数据信息
                var selectData = sm.getSelected();
                if (selectData == null) {
                    Ext.Msg.alert("提示", "请选择移库单！");
                    return;
                }
                if (selectData.data.Status == 1)//已提交
                {
                    Ext.Msg.alert("提示", "该移库单已经提交！");
                    return;
                }
                Ext.Msg.confirm("提示信息", "是否真的要提交选择的移库单吗？", function callBack(id) {
                    //判断是否删除数据
                    if (id == "yes") {
                        //页面提交
                        Ext.Ajax.request({
                            url: 'frmShiftPosOrderList.aspx?method=commitShiftPosOrder',
                            method: 'POST',
                            params: {
                                OrderId: selectData.data.OrderId
                            },
                            success: function(resp, opts) {
                                if (checkExtMessage(resp)) {
                                    //Ext.Msg.alert("提示", "数据提交成功！");
                                    updateDataGrid(); //刷新页面
                                }
                            },
                            failure: function(resp, opts) {
                                Ext.Msg.alert("提示", "数据提交失败！");
                            }
                        });
                    }
                });
            }
            function lookOrderWin() {
                var sm = userGrid.getSelectionModel();
                //获取选择的数据信息
                var selectData = sm.getSelected();
                if (selectData == null) {
                    Ext.Msg.alert("提示", "请选择移库单记录！");
                    return;
                }
                uploadShiftPosOrderWindow.show();
                uploadShiftPosOrderWindow.setTitle("查看移库单");
                document.getElementById("editShiftPosOrderIFrame").src = "frmShiftPosOrderEdit.aspx?type=look&id=" + selectData.data.OrderId;
            }
            /*------开始界面数据的窗体 Start---------------*/
            if (typeof (uploadShiftPosOrderWindow) == "undefined") {//解决创建2个windows问题
                uploadShiftPosOrderWindow = new Ext.Window({
                    id: 'ShiftPosOrderWindow'
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
		            , html: '<iframe id="editShiftPosOrderIFrame" width="100%" height="100%" border=0 src="#"></iframe>'

                });
            }
            uploadShiftPosOrderWindow.addListener("hide", function() {
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
                value: defaultWhId, //dsWarehouseList.getRange()[0].data.WhId,
                editable: false,
                listeners: { specialkey: function(f, e) { if (e.getKey() == e.ENTER) { Ext.getCmp('OutWhpName').focus(); } },
                    select: function(combo, record, index) {
                        var curWhId = WhNamePanel.getValue();
                        dsWarehousePosList.load({
                            params: {
                                WhId: curWhId
                            }
                        });
                        Ext.getCmp('OutWhpName').setValue("");
                        Ext.getCmp('InWhpName').setValue("");
                    }
                }

            });


            dsWarehousePosList.load({
                params: {
                    WhId: WhNamePanel.getValue()
                }
            });

            var OutWhpNamePanel = new Ext.form.ComboBox({
                name: 'outWarehousePosCombo',
                store: dsWarehousePosList,
                displayField: 'WhpName',
                valueField: 'WhpId',
                typeAhead: true, //自动将第一个搜索到的选项补全输入
                triggerAction: 'all',
                emptyText: '请选择仓位',
                selectOnFocus: true,
                forceSelection: true,
                mode: 'local',
                fieldLabel: '调出仓位',
                anchor: '90%',
                id: 'OutWhpName',
                listeners: { specialkey: function(f, e) { if (e.getKey() == e.ENTER) { Ext.getCmp('inWhpName').focus(); } } }
            });
            var InWhpNamePanel = new Ext.form.ComboBox({
                name: 'inWarehousePosCombo',
                store: dsWarehousePosList,
                displayField: 'WhpName',
                valueField: 'WhpId',
                typeAhead: true, //自动将第一个搜索到的选项补全输入
                triggerAction: 'all',
                emptyText: '请选择仓位',
                selectOnFocus: true,
                forceSelection: true,
                mode: 'local',
                fieldLabel: '调入仓位',
                anchor: '90%',
                id: 'InWhpName',
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
                        OutWhpNamePanel
                        ]
                    }, {
                        columnWidth: .3,
                        layout: 'form',
                        border: false,
                        items: [
                        InWhpNamePanel
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
                        StatusPanel
                    ]
                        }, {
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
                            columnWidth: .1,
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
    url: 'frmShiftPosOrderList.aspx?method=getShiftPosOrderList',
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
	    name: 'OutWhpId'
	},
	{
	    name: 'InWhpId'
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
		header: '移仓单号',
		dataIndex: 'OrderId',
		id: 'OrderId'
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
		    header: '调出仓位',
		    dataIndex: 'OutWhpId',
		    id: 'OutWhpId',
		    renderer: function(val, params, record) {
		        dsWarehousePosList.each(function(r) {
		            if (val == r.data['WhpId']) {
		                val = r.data['WhpName'];
		                return;
		            }
		        });
		        return val;
		    }
		},
		{
		    header: '调入仓位',
		    dataIndex: 'InWhpId',
		    id: 'InWhpId',
		    renderer: function(val, params, record) {
		        dsWarehousePosList.each(function(r) {
		            if (val == r.data['WhpId']) {
		                val = r.data['WhpName'];
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
