<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmWmsWarehouse.aspx.cs" Inherits="WMS_frmWmsWarehouse" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html>
<head>
<title>仓库维护页</title>
<meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<link rel="stylesheet" type="text/css" href="../ext3/resources/css/ext-all.css" />
<script type="text/javascript" src="../ext3/adapter/ext/ext-base.js"></script>
<script type="text/javascript" src="../ext3/ext-all.js"></script>
<script type="text/javascript" src="../js/operateResp.js"></script>

</head>
<body>
<div id='toolbar'></div>
<div id='searchForm'></div>
<div id='userGrid'></div>
<div style="display:none">
<select id='comboStatus' >
<option value='0'>启用</option>
<option value='1'>禁止</option>
</select>
<select id='comboWhType' >
<option value='01'>作业仓库</option>
<option value='02'>战备盐仓库</option>
<option value='03'>省储备仓库</option>
</select></div>
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
                handler: function() {
                    openAddWarehouseWin();
                }
            }, '-', {
                text: "编辑",
                icon: "../Theme/1/images/extjs/customer/edit16.gif",
                handler: function() {
                    modifyWarehouseWin();
                }
//            }, '-', {
//                text: "删除",
//                icon: "../Theme/1/images/extjs/customer/delete16.gif",
//                handler: function() {
//                    deleteWarehouse();
//                }
}]
            });


            /*------结束toolbar的函数 end---------------*/


            /*------开始ToolBar事件函数 start---------------*//*-----新增Warehouse实体类窗体函数----*/
            function openAddWarehouseWin() {
                uploadWarehouseWindow.setTitle("新增仓库");
                uploadWarehouseWindow.show();
                
                warehouseForm.getForm().reset();

            }
            /*-----编辑Warehouse实体类窗体函数----*/
            function modifyWarehouseWin() {
                var sm = userGrid.getSelectionModel();
                //获取选择的数据信息
                var selectData = sm.getSelected();
                if (selectData == null) {
                    Ext.Msg.alert("提示", "请选中需要编辑的信息！");
                    return;
                }
                uploadWarehouseWindow.setTitle("编辑仓库");
                uploadWarehouseWindow.show();
                
                setFormValue(selectData);
            }
            /*-----删除Warehouse实体函数----*/
            /*删除信息*/
            function deleteWarehouse() {
                var sm = userGrid.getSelectionModel();
                //获取选择的数据信息
                var selectData = sm.getSelected();
                //如果没有选择，就提示需要选择数据信息
                if (selectData == null) {
                    Ext.Msg.alert("提示", "请选中需要删除的信息！");
                    return;
                }
                //删除前再次提醒是否真的要删除
                Ext.Msg.confirm("提示信息", "是否真的要删除选择的仓库信息吗？", function callBack(id) {
                    //判断是否删除数据
                    if (id == "yes") {
                        //页面提交
                        Ext.Ajax.request({
                            url: 'frmWmsWarehouse.aspx?method=deleteWarehouse',
                            method: 'POST',
                            params: {
                                WhId: selectData.data.WhId
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
                var WhCode = WhCodePanel.getValue();
                var WhName = WhNamePanel.getValue();
                userGridData.baseParams.WhCode = WhCode;
                userGridData.baseParams.WhName = WhName;
                userGridData.baseParams.start = 0;
                userGridData.baseParams.limit = 100;

                userGridData.load();
            }

            /*------实现FormPanle的函数 start---------------*/
            var warehouseForm = new Ext.form.FormPanel({
                url: '',
                frame: true,
                title: '',
                items: [
	            {
	                layout: 'column',
	                border: false,
	                labelSeparator: '：',
	                items: [
		            {
		                layout: 'form',
		                border: false,
		                columnWidth: 1,
		                items: [
		                    {
		                        xtype: 'hidden',
		                        fieldLabel: '仓库ID',
		                        name: 'WhId',
		                        id: 'WhId',
		                        hidden: true,
		                        hiddenLabel: true
		                    },
				            {
				                xtype: 'textfield',
				                fieldLabel: '仓库编码',
				                columnWidth: 1,
				                anchor: '90%',
				                name: 'WhCode',
				                id: 'WhCode'
				            }
		            ]
		            }
	            ]
	            },
	            {
	                layout: 'column',
	                border: false,
	                labelSeparator: '：',
	                items: [
		            {
		                layout: 'form',
		                border: false,
		                columnWidth: 1,
		                items: [
				            {
				                xtype: 'textfield',
				                fieldLabel: '仓库名称',
				                columnWidth: 1,
				                anchor: '90%',
				                name: 'WhName',
				                id: 'WhName'
				            }
		            ]
		            }
	            ]
	            },
	            {
	                layout: 'column',
	                border: false,
	                labelSeparator: '：',
	                items: [
		            {
		                layout: 'form',
		                border: false,
		                columnWidth: 1,
		                items: [
				            {
				                xtype: 'combo',
				                fieldLabel: '所属配送站',
				                columnWidth: 1,
				                anchor: '90%',
				                name: 'StationId',
				                id: 'StationId'
				                , displayField: 'DeptName'
                                , valueField: 'DeptId'
                                , editable: false
                                , store: dsDistributionCenterListInfo
                                , triggerAction: 'all'
                                , mode: 'local'

				            }
		            ]
		            }
	            ]
	            },
	            {
	                layout: 'column',
	                border: false,
	                labelSeparator: '：',
	                items: [
		            {
		                layout: 'form',
		                border: false,
		                columnWidth: 1,
		                items: [
				            {
				                xtype: 'textfield',
				                fieldLabel: '地址',
				                columnWidth: 1,
				                anchor: '90%',
				                name: 'Address',
				                id: 'Address'
				            }
		            ]
		            }
	            ]
	            },
	            {
	                layout: 'column',
	                border: false,
	                labelSeparator: '：',
	                items: [
		            {
		                layout: 'form',
		                border: false,
		                columnWidth: 1,
		                items: [
				            {
				                xtype: 'textfield',
				                fieldLabel: '仓库描述',
				                columnWidth: 1,
				                anchor: '90%',
				                name: 'Description',
				                id: 'Description'
				            }
		            ]
		            }
	            ]
	            },
	            {
	                layout: 'column',
	                border: false,
	                labelSeparator: '：',
	                items: [
		            {
		                layout: 'form',
		                border: false,
		                columnWidth: 1,
		                items: [
				            {
				                xtype: 'textfield',
				                fieldLabel: '备注',
				                columnWidth: 1,
				                anchor: '90%',
				                name: 'Remark',
				                id: 'Remark'
				            }
		            ]
		            }
	            ]
	            },
	            {
	                layout: 'column',
	                border: false,
	                labelSeparator: '：',
	                items: [
		            {
		                layout: 'form',
		                border: false,
		                columnWidth: 1,
		                items: [
				            {
				                xtype: 'combo',
				                fieldLabel: '状态',
				                columnWidth: 1,
				                anchor: '90%',
				                name: 'Status',
				                id: 'Status',
				                transform: 'comboStatus',
				                typeAhead: false,
				                triggerAction: 'all',
				                lazyRender: true,
				                editable: false

				            }
		            ]
		            }
	            ]
	            },
	            {
	                layout: 'column',
	                border: false,
	                labelSeparator: '：',
	                items: [
		            {
		                layout: 'form',
		                border: false,
		                columnWidth: 1,
		                items: [
				            {
				                xtype: 'combo',
				                fieldLabel: '仓库类型',
				                columnWidth: 1,
				                anchor: '90%',
				                name: 'WhType',
				                id: 'WhType',
				                transform: 'comboWhType',
				                typeAhead: false,
				                triggerAction: 'all',
				                lazyRender: true,
				                editable: false,
                                value:'01'
				            }
		            ]
		            }
	            ]
	            }
            ]
            });
            /*------FormPanle的函数结束 End---------------*/

            /*------开始界面数据的窗体 Start---------------*/
            if (typeof (uploadWarehouseWindow) == "undefined") {//解决创建2个windows问题
                uploadWarehouseWindow = new Ext.Window({
                    id: 'Warehouseformwindow'
		            , iconCls: 'upload-win'
		            , width: 600
		            , height: 300
		            , layout: 'fit'
		            , plain: true
		            , modal: true
		            , constrain: true
		            , resizable: false
		            , closeAction: 'hide'
		            , autoDestroy: true
		            , items: warehouseForm
		            , buttons: [{
		                text: "保存"
			            , handler: function() {
			                if (!checkData()) return;
			                getFormValue();
			                //warehouseForm.getForm().reset();
			                uploadWarehouseWindow.hide();
			                updateDataGrid();
			            }
			            , scope: this
		            },
		            {
		                text: "取消"
			            , handler: function() {
			                uploadWarehouseWindow.hide();
			            }
			            , scope: this
}]
                });
            }
            uploadWarehouseWindow.addListener("hide", function() {
            });
            String.prototype.trim = function() {
                // 用正则表达式将前后空格  
                // 用空字符串替代。  
                return this.replace(/(^\s*)|(\s*$)/g, "");
            }
            //检查数据。
            function checkData() {
                var stationId = Ext.getCmp("StationId").getValue().trim();
                if (stationId == "") {
                    Ext.Msg.alert("提示", "所属配送站不能为空！");
                    return false;
                }
                var whCode = Ext.getCmp("WhCode").getValue().trim();
                if (whCode == "") {
                    Ext.Msg.alert("提示", "仓库编码不能为空！");
                    return false;
                }
                var whName = Ext.getCmp("WhName").getValue().trim();
                if (whName == "") {
                    Ext.Msg.alert("提示", "仓库名称不能为空！");
                    return false;
                }
                return true;
            }
            /*------开始获取界面数据的函数 start---------------*/
            function getFormValue() {
                Ext.Ajax.request({
                    url: 'frmWmsWarehouse.aspx?method=saveWarehouse',
                    method: 'POST',
                    params: {
                        WhId: Ext.getCmp('WhId').getValue(),
                        WhCode: Ext.getCmp('WhCode').getValue(),
                        WhName: Ext.getCmp('WhName').getValue(),
                        StationId: Ext.getCmp('StationId').getValue(),
                        Address: Ext.getCmp('Address').getValue(),
                        Description: Ext.getCmp('Description').getValue(),
                        Remark: Ext.getCmp('Remark').getValue(),
                        Status: Ext.getCmp('Status').getValue(),
                        WhType: Ext.getCmp('WhType').getValue()
                    },
                    success: function(resp, opts) {
                        if (checkExtMessage(resp)) {
                            updateDataGrid();
                        }
                    }
                });
            }
            /*------结束获取界面数据的函数 End---------------*/

            /*------开始界面数据的函数 Start---------------*/
            function setFormValue(selectData) {

                Ext.Ajax.request({
                    url: 'frmWmsWarehouse.aspx?method=getWarehouseInfo',
                    params: {
                        WhId: selectData.data.WhId
                    },
                    success: function(resp, opts) {
                        var data = Ext.util.JSON.decode(resp.responseText);
                        Ext.getCmp("WhId").setValue(data.WhId);
                        Ext.getCmp("WhCode").setValue(data.WhCode);
                        Ext.getCmp("WhName").setValue(data.WhName);
                        Ext.getCmp("StationId").setValue(data.StationId);
                        Ext.getCmp("Address").setValue(data.Address);
                        Ext.getCmp("Description").setValue(data.Description);
                        Ext.getCmp("Remark").setValue(data.Remark);
                        Ext.getCmp("Status").setValue(data.Status);
                        Ext.getCmp("WhType").setValue(data.WhType);
                    },
                    failure: function(resp, opts) {
                        Ext.Msg.alert("提示", "获取仓库信息失败！");
                    }
                });
            }
            /*------结束设置界面数据的函数 End---------------*/

            /*------开始查询form的函数 start---------------*/

            var WhCodePanel = new Ext.form.TextField({
                style: 'margin-left:0px',
                cls: 'key',
                xtype: 'textfield',
                fieldLabel: '仓库编码',
                anchor: '70%',
                listeners: { specialkey: function(f, e) { if (e.getKey() == e.ENTER) { Ext.getCmp('SWhName').focus(); } } }

            });


            var WhNamePanel = new Ext.form.TextField({
                style: 'margin-left:0px',
                cls: 'key',
                xtype: 'textfield',
                fieldLabel: '仓库名称',
                anchor: '70%',
                id: 'SWhName',
                listeners: { specialkey: function(f, e) { if (e.getKey() == e.ENTER) { Ext.getCmp('searchebtnId').focus(); } } }
            });

            var serchform = new Ext.FormPanel({
                renderTo: 'searchForm',
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
                        columnWidth: .4,  //该列占用的宽度，标识为20％
                        layout: 'form',
                        border: false,
                        items: [
                        WhCodePanel
                    ]
                    }, {
                        columnWidth: .4,
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
}]
}]
}]
                        });


                        /*------开始查询form的函数 end---------------*/

                        /*------开始获取数据的函数 start---------------*/
                        var userGridData = new Ext.data.Store
                        ({
                            url: 'frmWmsWarehouse.aspx?method=getWarehouseList',
                            reader: new Ext.data.JsonReader({
                                totalProperty: 'totalProperty',
                                root: 'root'
                            }, [
	                        {
	                            name: 'WhId'
	                        },
	                        {
	                            name: 'WhCode'
	                        },
	                        {
	                            name: 'WhName'
	                        },
	                        {
	                            name: 'StationId'
	                        },
	                        {
	                            name: 'Address'
	                        },
	                        {
	                            name: 'Description'
	                        },
	                        {
	                            name: 'Remark'
	                        },
	                        {
	                            name: 'Status'
	                        },
	                        {
	                            name: 'WhType'
	                        },
	                        {
	                            name: 'OrgId'
	                        },
	                        {
	                            name: 'OperId'
	                        },
	                        {
	                            name: 'OwnerId'
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
                        var userGrid = new Ext.grid.GridPanel({
                            el: 'userGrid',
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
	                            header: '仓库ID',
	                            dataIndex: 'WhId',
	                            id: 'WhId',
	                            hidden: true,
	                            hideable: false
	                        },
	                            {
	                                header: '仓库编号',
	                                dataIndex: 'WhCode',
	                                id: 'WhCode'
	                            },
	                            {
	                                header: '仓库名称',
	                                dataIndex: 'WhName',
	                                id: 'WhName'
	                            },
	                            {
	                                header: '所属配送站',
	                                dataIndex: 'StationId',
	                                id: 'StationId',
	                                renderer: function(val, params, record) {
	                                    dsDistributionCenterListInfo.each(function(r) {
	                                        if (val == r.data['DeptId']) {
	                                            val = r.data['DeptName'];
	                                            return;
	                                        }
	                                    });
	                                    return val;
	                                }
	                            },
	                            {
	                                header: '地址',
	                                dataIndex: 'Address',
	                                id: 'Address'
	                            },
	                            {
	                                header: '仓库描述',
	                                dataIndex: 'Description',
	                                id: 'Description'
	                            },
	                            {
	                                header: '备注',
	                                dataIndex: 'Remark',
	                                id: 'Remark'
	                            },
	                            {
	                                header: '状态',
	                                dataIndex: 'Status',
	                                id: 'Status',
	                                renderer: function(val) { if (val == 0) return '启用'; if (val == 1) return '禁用'; }

}]),
                            bbar: new Ext.PagingToolbar({
                                pageSize: 100,
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
