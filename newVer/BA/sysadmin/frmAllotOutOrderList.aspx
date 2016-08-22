<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmAllotOutOrderList.aspx.cs" Inherits="WMS_frmAllotOutOrderList" %>

<html>
<head>
<title>调拨出仓单列表页面</title><meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<link rel="stylesheet" type="text/css" href="../../ext3/resources/css/ext-all.css" />
<script type="text/javascript" src="../../ext3/adapter/ext/ext-base.js"></script>
<script type="text/javascript" src="../../ext3/ext-all.js"></script>
<script type="text/javascript" src="../../ext3/src/locale/ext-lang-zh_CN.js"></script>
</head>
<body>
<div id='toolbar'></div>
<div id='divSearchForm'></div>
<div id='divForm'></div>
<div id='divOrderGrid'></div>

</body>
<%=getComboBoxStore()%>
<script type="text/javascript">
    Ext.BLANK_IMAGE_URL = "../../ext3/resources/images/default/s.gif";
    Ext.onReady(function() {
        /*------实现toolbar的函数 start---------------*/
        var windowTitle = "";
        var Toolbar = new Ext.Toolbar({
            renderTo: "toolbar",
            items: [{
                text: "清除",
                icon: "../../theme/1/images/extjs/customer/cross.gif",
                handler: function() { eraserOrder(); }
            }, '-', {
                text: "查看",
                icon: "../../theme/1/images/extjs/customer/view16.gif",
                handler: function() { lookOrderWin(); }
}]
            });

            /*------结束toolbar的函数 end---------------*/
            function updateDataGrid() {

                var OutWhId = OutWhNamePanel.getValue();
                var InWhId = InWhNamePanel.getValue();
                var StartDate = Ext.util.Format.date(StartDatePanel.getValue(),'Y/m/d');
                var EndDate = Ext.util.Format.date(EndDatePanel.getValue(),'Y/m/d');
                var OutStatus = OutStatusPanel.getValue();

                userGridData.baseParams.OutWhId = OutWhId;
                userGridData.baseParams.InWhId = InWhId;
                userGridData.baseParams.OutStatus = OutStatus;
                userGridData.baseParams.EndDate = EndDate;
                userGridData.baseParams.StartDate = StartDate;

                userGridData.load({
                    params: {
                        start: 0,
                        limit: 10
                    }
                });

            }
            function eraserOrder() {
                var sm = userGrid.getSelectionModel();
                //获取选择的数据信息
                var selectData = sm.getSelected();
                //如果没有选择，就提示需要选择数据信息
                if (selectData == null) {
                    Ext.Msg.alert("提示", "请选中需要清除的信息！");
                    return;
                }
                //删除前再次提醒是否真的要删除
                Ext.Msg.confirm("提示信息", "是否真的要清除选择的移库单？", function callBack(id) {
                    //判断是否删除数据
                    if (id == "yes") {
                        //页面提交
                        Ext.Ajax.request({
                            url: 'frmAllotOutOrderList.aspx?method=eraserOrder',
                            method: 'POST',
                            params: {
                                OrderId: selectData.data.OrderId
                            },
                            success: function(resp, opts) {
                                Ext.Msg.alert("提示", "数据清除成功！");
                                updateDataGrid(); //刷新页面
                            },
                            failure: function(resp, opts) {
                                Ext.Msg.alert("提示", "数据清除失败！");
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
                uploadAllotOrderWindow.show();
                uploadAllotOrderWindow.setTitle("查看移库单");
                document.getElementById("editAllotOrderIFrame").src = "../../WMS/frmAllotOrderEdit.aspx?type=look&id=" + selectData.data.OrderId;
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
                    id: 'AllotOrderWindow'
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
		            , html: '<iframe id="editAllotOrderIFrame" width="100%" height="100%" border=0 src="frmAllotOrderEdit.aspx"></iframe>'

                });
            }
            uploadAllotOrderWindow.addListener("hide", function() {
                updateDataGrid();
            });


            /*------开始查询form的函数 start---------------*/

            var OutWhNamePanel = new Ext.form.ComboBox({
                name: 'outWarehouseCombo',
                store: dsWarehouseList,
                displayField: 'WhName',
                valueField: 'WhId',
                typeAhead: true, //自动将第一个搜索到的选项补全输入
                triggerAction: 'all',
                emptyText: '请选择仓库',
                selectOnFocus: true,
                forceSelection: true,
                mode: 'local',
                fieldLabel: '调出仓库',
                anchor: '90%',
                id: 'OutWhName',
                listeners: { specialkey: function(f, e) { if (e.getKey() == e.ENTER) { Ext.getCmp('InWhName').focus(); } } }

            });


            var InWhNamePanel = new Ext.form.ComboBox({
                name: 'inWarehouseCombo',
                store: dsWarehouseList,
                displayField: 'WhName',
                valueField: 'WhId',
                typeAhead: true, //自动将第一个搜索到的选项补全输入
                triggerAction: 'all',
                emptyText: '请选择仓库',
                selectOnFocus: true,
                forceSelection: true,
                mode: 'local',
                fieldLabel: '调入仓库',
                anchor: '90%',
                id: 'InWhName',
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
                        OutWhNamePanel
                    ]
                    }, {
                        columnWidth: .3,
                        layout: 'form',
                        border: false,
                        items: [
                        InWhNamePanel
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
    url: 'frmAllotOutOrderList.aspx?method=getAllotOutOrderList',
    reader: new Ext.data.JsonReader({
        totalProperty: 'totalProperty',
        root: 'root'
    }, [
	{
	    name: 'OrderId'
	},
	{
	    name: 'OutOrg'
	},
	{
	    name: 'InOrg'
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
	    name: 'AllotType'
	},
	{
	    name: 'IsActive'
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
		        header: '移库单号',
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
		    hidden: true
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
		    hidden: true
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
		    renderer: function(val, params, record) {
		        //  if (dsDriverList.getCount() == 0) {
		        //     dsDriverList.load();
		        // }
		        // dsDriverList.each(function(r) {
		        //     if (val == r.data['DriverId']) {
		        //         val = r.data['DriverName'];
		        //         return;
		        //     }
		        // });
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
                              if(v==4||v==2||v==3)
                                {
                                    if(showTipRowIndex == rowIndex)
                                        return;
                                    else
                                        showTipRowIndex = rowIndex;
                                        
                                     tip.body.dom.innerHTML="正在加载数据……";
                                        //页面提交
                                        Ext.Ajax.request({
                                            url: 'frmAllotOutOrderList.aspx?method=getdetailinfo',
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
