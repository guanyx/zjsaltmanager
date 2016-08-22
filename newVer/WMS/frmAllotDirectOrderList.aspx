<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmAllotDirectOrderList.aspx.cs" Inherits="WMS_frmAllotDirectOrderList" %>

<html>
<head>
<title>调拨出仓单列表页面</title><meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
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
                text: "查看调拨单",
                icon: "../theme/1/images/extjs/customer/add16.gif",
                handler: function() { lookOrderWin(); }
}]
            });

            /*------结束toolbar的函数 end---------------*/


            /*------开始ToolBar事件函数 start---------------*//*-----新增Order实体类窗体函数----*/
            function updateDataGrid() {

                var OutWhId = OutOrgNamePanel.getValue();
                var InWhId = InOrgNamePanel.getValue();
                var StartDate = Ext.util.Format.date(StartDatePanel.getValue(),'Y/m/d');
                var EndDate = Ext.util.Format.date(EndDatePanel.getValue(),'Y/m/d');
                var OutStatus = OutStatusPanel.getValue();

                userGridData.baseParams.OutOrg = OutWhId;
                userGridData.baseParams.InOrg = InWhId;
                userGridData.baseParams.OutStatus = OutStatus;
                userGridData.baseParams.EndDate = EndDate;
                userGridData.baseParams.StartDate = StartDate;
                userGridData.baseParams.AllotType = 1;

                userGridData.load({
                    params: {
                        start: 0,
                        limit: 10
                    }
                });

            }

            function AddOrderWin() {
                uploadAllotOrderWindow.show();
                uploadAllotOrderWindow.setTitle("新增调拨单");
                document.getElementById("editAllotDirectOrderIFrame").src = "frmAllotDirectOrderEdit.aspx";
            }

            function EditOrderWin() {
                var sm = userGrid.getSelectionModel();
                //获取选择的数据信息
                var selectData = sm.getSelected();
                if (selectData == null) {
                    Ext.Msg.alert("提示", "请选择调拨单记录！");
                    return;
                }
                if (selectData.data.OutStatus != 0)//不是未入仓状态
                {
                    if (selectData.data.OutOrg == <% =ZJSIG.UIProcess.ADM.UIAdmUser.OrgID(this)%>) {
                        Ext.Msg.alert("提示", "只有未出仓的调拨单才能编辑！");
                        return;
                    }
                }
                uploadAllotOrderWindow.show();
                uploadAllotOrderWindow.setTitle("编辑调拨单");
                document.getElementById("editAllotDirectOrderIFrame").src = "frmAllotDirectOrderEdit.aspx?id=" + selectData.data.OrderId;
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
                if (selectData.data.OutStatus != 0)//不是未入仓状态
                {
                    Ext.Msg.alert("提示", "已出库的调拨单不能删除！");
                    return;
                }
                //删除前再次提醒是否真的要删除
                Ext.Msg.confirm("提示信息", "是否真的要删除选择的调拨单吗？", function callBack(id) {
                    //判断是否删除数据
                    if (id == "yes") {
                        //页面提交
                        Ext.Ajax.request({
                            url: 'frmAllotDirectOrderList.aspx?method=deleteAllotDirectOrder',
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

            function lookOrderWin() {
                var sm = userGrid.getSelectionModel();
                //获取选择的数据信息
                var selectData = sm.getSelected();
                if (selectData == null) {
                    Ext.Msg.alert("提示", "请选择调拨单记录！");
                    return;
                }
                uploadAllotOrderWindow.show();
                uploadAllotOrderWindow.setTitle("查看调拨单");
                document.getElementById("editAllotDirectOrderIFrame").src = "frmAllotDirectOrderEdit.aspx?type=look&id=" + selectData.data.OrderId;
            }

            /*------开始界面数据的窗体 Start---------------*/
            if (typeof (uploadOrderWindow) == "undefined") {//解决创建2个windows问题
                uploadOrderWindow = new Ext.Window({
                    id: 'Orderformwindow'
		            , iconCls: 'upload-win'
		            , width: 800
		            , height: 515
		            , layout: 'fit'
		            , plain: true
		            , modal: true
		            , constrain: true
		            , resizable: false
		            , closeAction: 'hide'
		            , autoDestroy: true
		            , html: '<iframe id="editIFrame" width="100%" height="100%" border=0 src="#"></iframe>'

                });
            }
            uploadOrderWindow.addListener("hide", function() {
                updateDataGrid();
            });

            if (typeof (uploadAllotOrderWindow) == "undefined") {//解决创建2个windows问题
                uploadAllotOrderWindow = new Ext.Window({
                    id: 'AllotDirectOrderWindow'
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
		            , html: '<iframe id="editAllotDirectOrderIFrame" width="100%" height="100%" border=0 src="frmAllotDirectOrderEdit.aspx"></iframe>'

                });
            }
            uploadAllotOrderWindow.addListener("hide", function() {
                updateDataGrid();
            });


            /*------开始查询form的函数 start---------------*/

            var OutOrgNamePanel = new Ext.form.ComboBox({
                name: 'outOrgCombo',
                store: dsOrgList,
                displayField: 'OrgName',
                valueField: 'OrgId',
                typeAhead: true, //自动将第一个搜索到的选项补全输入
                triggerAction: 'all',
                emptyText: '请选择单位',
                selectOnFocus: true,
                forceSelection: true,
                mode: 'local',
                fieldLabel: '调出单位',
                anchor: '90%',
                id: 'OutOrgName',
                listeners: { specialkey: function(f, e) { if (e.getKey() == e.ENTER) { Ext.getCmp('InOrgName').focus(); } } }

            });


            var InOrgNamePanel = new Ext.form.ComboBox({
                name: 'inOrgCombo',
                store: dsOrgList,
                displayField: 'OrgName',
                valueField: 'OrgId',
                typeAhead: true, //自动将第一个搜索到的选项补全输入
                triggerAction: 'all',
                emptyText: '请选择单位',
                selectOnFocus: true,
                forceSelection: true,
                mode: 'local',
                fieldLabel: '调入单位',
                anchor: '90%',
                id: 'InOrgName',
                listeners: { specialkey: function(f, e) { if (e.getKey() == e.ENTER) { Ext.getCmp('BillStatus').focus(); } } }
            });

            var OutStatusPanel = new Ext.form.ComboBox({
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
                        OutOrgNamePanel
                    ]
                    }, {
                        columnWidth: .3,
                        layout: 'form',
                        border: false,
                        items: [
                        InOrgNamePanel
                        ]
                    }, {
                        columnWidth: .3,
                        layout: 'form',
                        border: false,
                        items: [
                        OutStatusPanel
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
    url: 'frmAllotDirectOrderList.aspx?method=getAllotDirectOrderList',
    reader: new Ext.data.JsonReader({
        totalProperty: 'totalProperty',
        root: 'root'
    }, [
	{
	    name: 'OrderId'
	},
	{
	    name: 'OutWhId'
	},
	{
	    name: 'InWhId'
	},
	{
	    name: 'OutWhName'
	},
	{
	    name: 'InWhName'
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
	    name: 'OutStatus'
	},
	{
	    name: 'DriverId'
	},
	{
	    name: 'DriverName'
	},
	{
	    name: 'Remark'
	},
	{
	    name: 'InOrg'
	},
	{
	    name: 'OutOrg'
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
		    header: '调出单位',
		    dataIndex: 'OutOrg',
		    id: 'OutOrg',
		    renderer: function(val, params, record) { 
		        if (dsOrgList.getCount() == 0) {
		            dsOrgList.load();
		        }
		        dsOrgList.each(function(r) {
		            if (val == r.data['OrgId']) {
		                val = r.data['OrgName'];
		                return;
		            }
		        });
		        return val;
		    }
		},
		{
		    header: '调出仓库id',
		    dataIndex: 'OutWhId',
		    id: 'OutWhId',
		    hidden:true
//		    renderer: function(val, params, record) {
//		        if (dsWarehouseList.getCount() == 0) {
//		            dsWarehouseList.load();
//		        }
//		        dsWarehouseList.each(function(r) {
//		            if (val == r.data['WhId']) {
//		                val = r.data['WhName'];
//		                return;
//		            }
//		        });
//		        return val;
//		    }
		},
		{
		    header: '调出仓库',
		    dataIndex: 'OutWhName',
		    id: 'OutWhName'
		},
		{
		    header: '调入单位',
		    dataIndex: 'InOrg',
		    id: 'InOrg',
		    renderer: function(val, params, record) {
		        if (dsOrgList.getCount() == 0) {
		            dsOrgList.load();
		        }
		        dsOrgList.each(function(r) {
		            if (val == r.data['OrgId']) {
		                val = r.data['OrgName'];
		                return;
		            }
		        });
		        return val;
		    }
		},
		{
		    header: '调入仓库id',
		    dataIndex: 'InWhId',
		    id: 'InWhId',
		    hidden:true
//		    renderer: function(val, params, record) {
//		        if (dsWarehouseList.getCount() == 0) {
//		            dsWarehouseList.load();
//		        }
//		        dsWarehouseList.each(function(r) {
//		            if (val == r.data['WhId']) {
//		                val = r.data['WhName'];
//		                return;
//		            }
//		        });
//		        return val;
//		    }
		},
		{
		    header: '调入仓库',
		    dataIndex: 'InWhName',
		    id: 'InWhName'
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
		    dataIndex: 'OutStatus',
		    id: 'OutStatus',
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
		    header: '驾驶员',
		    dataIndex: 'DriverId',
		    id: 'DriverId',
		    hidden:true
//		    renderer: function(val, params, record) {
//		        if (dsDriverList.getCount() == 0) {
//		            dsDriverList.load();
//		        }
//		        dsDriverList.each(function(r) {
//		            if (val == r.data['DriverId']) {
//		                val = r.data['DriverName'];
//		                return;
//		            }
//		        });
//		        return val;
//		    }
		},
		{
		    header: '驾驶员',
		    dataIndex: 'DriverName',
		    id: 'DriverName'
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
