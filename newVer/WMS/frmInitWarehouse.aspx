<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmInitWarehouse.aspx.cs" Inherits="WMS_frmInitWarehouse" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html>
<head>
<title>仓库初始化页面</title><meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<link rel="stylesheet" type="text/css" href="../ext3/resources/css/ext-all.css" />
<script type="text/javascript" src="../ext3/adapter/ext/ext-base.js"></script>
<script type="text/javascript" src="../ext3/ext-all.js"></script>
<script type="text/javascript" src="../ext3/example/TabCloseMenu.js" charset="gb2312"></script>
<script type="text/javascript" src="../js/operateResp.js"></script>
</head>
<body>
<div id='toolbar'></div>
<div id='divSearchForm'></div>
<div id='divDataGrid'></div>

</body>
<%=getComboBoxStore()%>
<script type="text/javascript">
    Ext.BLANK_IMAGE_URL = "../ext3/resources/images/default/s.gif";
    Ext.onReady(function() {

        /*------实现toolbar的函数 start---------------*/
        var Toolbar = new Ext.Toolbar({
            renderTo: "toolbar",
            items: [{
                text: "新增",
                icon: "../Theme/1/images/extjs/customer/add16.gif",
                handler: function() { openAddOrderWin(); }
            }, '-', {
                text: "编辑",
                icon: "../Theme/1/images/extjs/customer/edit16.gif",
                handler: function() { modifyOrderWin(); }
            }, '-', {
                text: "删除",
                icon: "../Theme/1/images/extjs/customer/delete16.gif",
                handler: function() { deleteOrder(); }
            }, '-', {
                text: "提交",
                icon: "../Theme/1/images/extjs/customer/edit16.gif",
                handler: function() { commitOrder(); }
            }, '-', {
                text: "查看",
                icon: "../Theme/1/images/extjs/customer/delete16.gif",
                handler: function() { lookOrderWin(); }
}]
            });

            /*------结束toolbar的函数 end---------------*/


            /*------开始ToolBar事件函数 start---------------*//*-----新增Order实体类窗体函数----*/
            function openAddOrderWin() {
                uploadOrderWindow.setTitle("新增仓库初始化");
                uploadOrderWindow.show();
                document.getElementById("editIFrame").src = "frmInitWarehouseEdit.aspx";
            }

            /*-----编辑Order实体类窗体函数----*/
            function modifyOrderWin() {
                var sm = initWarehouseGrid.getSelectionModel();
                //获取选择的数据信息
                var selectData = sm.getSelected();
                if (selectData == null) {
                    Ext.Msg.alert("提示", "请选中需要编辑的信息！");
                    return;
                }
                if (selectData.data.Status == 1) {
                    Ext.Msg.alert("提示", "该仓库已经初始化完成，不能编辑！");
                    return;
                }
                uploadOrderWindow.setTitle("编辑仓库初始化");
                uploadOrderWindow.show();
                document.getElementById("editIFrame").src = "frmInitWarehouseEdit.aspx?id=" + selectData.data.OrderId;
            }
            function lookOrderWin() {
                var sm = initWarehouseGrid.getSelectionModel();
                //获取选择的数据信息
                var selectData = sm.getSelected();
                if (selectData == null) {
                    Ext.Msg.alert("提示", "请选中需要查看的信息！");
                    return;
                }
                uploadOrderWindow.setTitle("查看仓库初始化");
                uploadOrderWindow.show();
                document.getElementById("editIFrame").src = "frmInitWarehouseEdit.aspx?type=look&id=" + selectData.data.OrderId;
            }
            /*-----删除Order实体函数----*/
            /*删除信息*/
            function deleteOrder() {
                var sm = initWarehouseGrid.getSelectionModel();
                //获取选择的数据信息
                var selectData = sm.getSelected();
                //如果没有选择，就提示需要选择数据信息
                if (selectData == null) {
                    Ext.Msg.alert("提示", "请选中需要删除的信息！");
                    return;
                }
                if (selectData.data.Status == 1) {
                    Ext.Msg.alert("提示", "该仓库已经初始化完成，不能删除！");
                    return;
                }
                //删除前再次提醒是否真的要删除
                Ext.Msg.confirm("提示信息", "是否真的要删除选择的仓库信息吗？", function callBack(id) {
                    //判断是否删除数据
                    if (id == "yes") {
                        //页面提交
                        Ext.Ajax.request({
                            url: 'frmInitWarehouse.aspx?method=deleteInitWarehouse',
                            method: 'POST',
                            params: {
                                OrderId: selectData.data.OrderId
                            },
                            success: function(resp, opts) {
                                if (checkExtMessage(resp)) {
                                    //updateDataGrid();
                                }
                            }
                        });
                    }
                });
            }
            function commitOrder() {
                var sm = initWarehouseGrid.getSelectionModel();
                //获取选择的数据信息
                var selectData = sm.getSelected();
                //如果没有选择，就提示需要选择数据信息
                if (selectData == null) {
                    Ext.Msg.alert("提示", "请选中需要提交的信息！");
                    return;
                }
                if (selectData.data.Status == 1) {
                    Ext.Msg.alert("提示", "该仓库已经初始化完成，不能重复提交！");
                    return;
                }
                //删除前再次提醒是否真的要删除
                Ext.Msg.confirm("提示信息", "是否真的要提交选择的仓库信息吗？", function callBack(id) {
                    //判断是否删除数据
                    if (id == "yes") {
                        //页面提交
                        Ext.Ajax.request({
                            url: 'frmInitWarehouse.aspx?method=commitInitWarehouse',
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
            function updateDataGrid() {
                var WhName = WhNamePanel.getValue();

                initWarehouseGridData.baseParams.WhId = WhName;
                initWarehouseGridData.baseParams.IsInitBill = 0;
                initWarehouseGridData.baseParams.start = 0;
                initWarehouseGridData.baseParams.limit = 10;                
                initWarehouseGridData.load();
            }


            var WhNamePanel = new Ext.form.ComboBox({
                fieldLabel: '仓库名称',
                name: 'warehouseCombo',
                store: dsWarehouseList,
                displayField: 'WhName',
                valueField: 'WhId',
                typeAhead: true, //自动将第一个搜索到的选项补全输入
                triggerAction: 'all',
                emptyText: '请选择仓库',
                emptyValue: '',
                selectOnFocus: true,
                forceSelection: true,
                anchor: '90%',
                mode: 'local',
                listeners: { specialkey: function(f, e) { if (e.getKey() == e.ENTER) { Ext.getCmp('searchebtnId').focus(); } } //,
                    // blur: function(field) { if (field.getRawValue() == '') { field.clearValue(); } } 
                }

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
                        WhNamePanel
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
                        }, {
                            columnWidth: .6,
                            layout: 'form',
                            border: false

}]
}]
}]
                        });


                        /*------开始查询form的函数 end---------------*/

                        /*------开始界面数据的窗体 Start---------------*/
                        if (typeof (uploadOrderWindow) == "undefined") {//解决创建2个windows问题
                            uploadOrderWindow = new Ext.Window({
                                id: 'Orderformwindow',
                                iconCls: 'upload-win'
		                        , width: 700
		                        , height: 462
		                        , layout: 'fit'
		                        , plain: true
		                        , modal: true
		                        , constrain: true
		                        , resizable: false
		                        , closeAction: 'hide'
		                        , autoDestroy: true
		                        , html: '<iframe id="editIFrame" width="100%" height="100%" border=0 src="frmInitWarehouseEdit.aspx"></iframe>'//initWarehouseForm

                            });
                        }
                        uploadOrderWindow.addListener("hide", function() {
                            updateDataGrid();
                        });

                        /*------开始获取界面数据的函数 start---------------*/
                        function getFormValue() {
                            Ext.Ajax.request({
                                url: 'frmInitWarehouse.aspx?method=saveInitWarehouse',
                                method: 'POST',
                                params: {
                                    OrderId: Ext.getCmp('OrderId').getValue(),
                                    OrgId: Ext.getCmp('OrgId').getValue(),
                                    WhId: Ext.getCmp('WhId').getValue(),
                                    OperId: Ext.getCmp('OperId').getValue(),
                                    InventoryDate: Ext.getCmp('InventoryDate').getValue(),
                                    OwnerId: Ext.getCmp('OwnerId').getValue(),
                                    Remark: Ext.getCmp('Remark').getValue(),
                                    IsInitBill: Ext.getCmp('IsInitBill').getValue(),
                                    Status: Ext.getCmp('Status').getValue(),
                                    CreateDate: Ext.getCmp('CreateDate').getValue(),
                                    UpdateDate: Ext.getCmp('UpdateDate').getValue()
                                },
                                success: function(resp, opts) {
                                    if (checkExtMessage(resp)) {

                                    }
                                }
                            });
                        }
                        /*------结束获取界面数据的函数 End---------------*/



                        /*------开始获取数据的函数 start---------------*/
                        var initWarehouseGridData = new Ext.data.Store
                        ({
                            url: 'frmInitWarehouse.aspx?method=getInitWarehouseList',
                            reader: new Ext.data.JsonReader({
                                totalProperty: 'totalProperty',
                                root: 'root'
                            }, [
	                        {
	                            name: 'OrderId'
	                        },
	                        {
	                            name: 'OrgId'
	                        },
	                        {
	                            name: 'WhId'
	                        },
	                        {
	                            name: 'OperId'
	                        },
	                        {
	                            name: 'InventoryDate'
	                        },
	                        {
	                            name: 'OwnerId'
	                        },
	                        {
	                            name: 'Remark'
	                        },
	                        {
	                            name: 'IsInitBill'
	                        },
	                        {
	                            name: 'Status'
	                        },
	                        {
	                            name: 'CreateDate'
	                        },
	                        {
	                            name: 'UpdateDate'
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
                        var initWarehouseGrid = new Ext.grid.GridPanel({
                            el: 'divDataGrid',
                            width: '100%',
                            height: '100%',
                            autoWidth: true,
                            autoHeight: true,
                            autoScroll: true,
                            layout: 'fit',
                            id: '',
                            store: initWarehouseGridData,
                            loadMask: { msg: '正在加载数据，请稍侯……' },
                            sm: sm,
                            cm: new Ext.grid.ColumnModel([
		                    sm,
		                        new Ext.grid.RowNumberer(), //自动行号
		                        {
		                        header: '订单ID',
		                        dataIndex: 'OrderId',
		                        id: 'OrderId',
		                        hidden: true
		                    },
		                {
		                    header: '组织ＩＤ',
		                    dataIndex: 'OrgId',
		                    id: 'OrgId',
		                    hidden: true
		                },
		                {
		                    header: '仓库名称',
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
		                    header: '初始化时间',
		                    dataIndex: 'InventoryDate',
		                    id: 'InventoryDate'
		                },
		                {
		                    header: '备注',
		                    dataIndex: 'Remark',
		                    id: 'Remark'
		                },
		                {
		                    header: '是否初始单',
		                    dataIndex: 'IsInitBill',
		                    id: 'IsInitBill',
		                    hidden: true
		                },
		                {
		                    header: '状态',
		                    dataIndex: 'Status',
		                    id: 'Status',
		                    value: 0,
		                    renderer: function(val) { if (val == 0) return '草稿'; if (val == 1) return '已提交'; }

}]),
                            bbar: new Ext.PagingToolbar({
                                pageSize: 10,
                                store: initWarehouseGridData,
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
                        initWarehouseGrid.render();
                        /*------DataGrid的函数结束 End---------------*/
                        updateDataGrid();


                    })
</script>

</html>

