<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmWmsWarehousePosition.aspx.cs"
    Inherits="WMS_frmWmsWarehousePosition" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
    <title>仓位维护页面</title>
    <meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
    <link rel="stylesheet" type="text/css" href="../ext3/resources/css/ext-all.css" />
    <script type="text/javascript" src="../ext3/adapter/ext/ext-base.js"></script>
    <script type="text/javascript" src="../ext3/ext-all.js"></script>
    <script type="text/javascript" src="../ext3/example/TabCloseMenu.js" charset="gb2312"></script>
    <script type="text/javascript" src="../js/operateResp.js"></script>
</head>
<body>
    <div id='toolbar'>
    </div>
    <div id='searchForm'>
    </div>
    <div id='warehousePositionGrid'>
    </div>
    <div style="display:none">
<select id='comboStatus' >
<option value='0'>启用</option>
<option value='1'>禁止</option>
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
                    openAddPositionWin();
                }
            }, '-', {
                text: "编辑",
                icon: "../Theme/1/images/extjs/customer/edit16.gif",
                handler: function() { modifyPositionWin(); }
            }, '-', {
                text: "删除",
                icon: "../Theme/1/images/extjs/customer/delete16.gif",
                handler: function() { deletePosition(); }
}]
            });

            /*------结束toolbar的函数 end---------------*/


            /*------开始ToolBar事件函数 start---------------*//*-----新增Position实体类窗体函数----*/
            function updateDataGrid() {
                var WhId = WhNamePanel.getValue();
                warehousePositionGridData.baseParams.WhId = WhId;
                warehousePositionGridData.load({
                    params: {
                        start: 0,
                        limit: 10
                    }
                });
            }
            //新增
            function openAddPositionWin() {
                uploadPositionWindow.setTitle("新增仓位");
                uploadPositionWindow.show();

                warehousePositionForm.getForm().reset();

                Ext.getCmp("WhId").setDisabled(false);

            }
            /*-----编辑Position实体类窗体函数----*/
            function modifyPositionWin() {
                var sm = warehousePositionGrid.getSelectionModel();
                //获取选择的数据信息
                var selectData = sm.getSelected();
                if (selectData == null) {
                    Ext.Msg.alert("提示", "请选中需要编辑的信息！");
                    return;
                }
                uploadPositionWindow.setTitle("编辑仓位");
                uploadPositionWindow.show();
                setFormValue(selectData);
            }
            /*-----删除Position实体函数----*/
            /*删除信息*/
            function deletePosition() {
                var sm = warehousePositionGrid.getSelectionModel();
                //获取选择的数据信息
                var selectData = sm.getSelected();
                //如果没有选择，就提示需要选择数据信息
                if (selectData == null) {
                    Ext.Msg.alert("提示", "请选中需要删除的信息！");
                    return;
                }
                //删除前再次提醒是否真的要删除
                Ext.Msg.confirm("提示信息", "是否真的要删除选择的仓位信息吗？", function callBack(id) {
                    //判断是否删除数据
                    if (id == "yes") {
                        //页面提交
                        Ext.Ajax.request({
                            url: 'frmWmsWarehousePosition.aspx?method=deleteWarehousePos',
                            method: 'POST',
                            params: {
                                WhpId: selectData.data.WhpId
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
            //alert(1);
            /*------实现FormPanle的函数 start---------------*/
            var warehousePositionForm = new Ext.form.FormPanel({
                url: '',
                frame: true,
                title: '',
                items: [
		        {
		            xtype: 'hidden',
		            fieldLabel: '仓位ID',
		            name: 'WhpId',
		            id: 'WhpId',
		            hidden: true,
		            hiddenLabel: true
		        }
                , {
                    xtype: 'combo',
                    fieldLabel: '所属仓库',
                    columnWidth: 1,
                    anchor: '90%',
                    name: 'WhId',
                    id: 'WhId'
				    , displayField: 'WhName'
                    , valueField: 'WhId'
                    , editable: false
                    , store: dsWarehouseList
                    , triggerAction: 'all'
                    , mode: 'local'
                }
                , {
                    xtype: 'textfield',
                    fieldLabel: '仓位编码',
                    columnWidth: 1,
                    anchor: '90%',
                    name: 'WhpCode',
                    id: 'WhpCode'
                }
                , {
                    xtype: 'textfield',
                    fieldLabel: '仓位名称',
                    columnWidth: 1,
                    anchor: '90%',
                    name: 'WhpName',
                    id: 'WhpName'
                }
                , {
                    xtype: 'textfield',
                    fieldLabel: '仓位地址',
                    columnWidth: 1,
                    anchor: '90%',
                    name: 'WhpAddr',
                    id: 'WhpAddr'
                }
                , {
                    xtype: 'numberfield',
                    fieldLabel: '最大体积',
                    columnWidth: 1,
                    anchor: '90%',
                    name: 'MaxCapacity',
                    id: 'MaxCapacity'
                }
                , {
                    xtype: 'numberfield',
                    fieldLabel: '最大重量',
                    columnWidth: 1,
                    anchor: '90%',
                    name: 'MaxWeight',
                    id: 'MaxWeight'
                }
                , {
                    xtype: 'textfield',
                    fieldLabel: '备注',
                    columnWidth: 1,
                    anchor: '90%',
                    name: 'Remark',
                    id: 'Remark'
                }
                , {
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
            }); //alert(2);
            /*------FormPanle的函数结束 End---------------*/

            /*------开始界面数据的窗体 Start---------------*/
            if (typeof (uploadPositionWindow) == "undefined") {//解决创建2个windows问题
                uploadPositionWindow = new Ext.Window({
                    id: 'Positionformwindow'
                    //title:formTitle
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
		            , items: warehousePositionForm
		            , buttons: [{
		                text: "保存"
			            , handler: function() {
			                if (!checkData()) return;
			                getFormValue();
			                //uploadPositionWindow.hide();
			            }
			            , scope: this
		            },
		            {
		                text: "取消"
			            , handler: function() {
			                uploadPositionWindow.hide();
			            }
			            , scope: this
}]
                });
            }
            uploadPositionWindow.addListener("hide", function() {
            });
            String.prototype.trim = function() {
                // 用正则表达式将前后空格  
                // 用空字符串替代。  
                return this.replace(/(^\s*)|(\s*$)/g, "");
            }
            //检查数据。
            function checkData() {
                var whId = Ext.getCmp("WhId").getValue().trim();
                if (whId == "") {
                    Ext.Msg.alert("提示", "所属仓库不能为空！");
                    return false;
                }
                var whpCode = Ext.getCmp("WhpCode").getValue().trim();
                if (whpCode == "") {
                    Ext.Msg.alert("提示", "仓位编码不能为空！");
                    return false;
                }
                var whpName = Ext.getCmp("WhpName").getValue().trim();
                if (whpName == "") {
                    Ext.Msg.alert("提示", "仓位名称不能为空！");
                    return false;
                }
                return true;
            }
            /*------开始获取界面数据的函数 start---------------*/
            function getFormValue() {
                Ext.Ajax.request({
                    url: 'frmWmsWarehousePosition.aspx?method=saveWarehousePos',
                    method: 'POST',
                    params: {
                        WhpId: Ext.getCmp('WhpId').getValue(),
                        WhId: Ext.getCmp('WhId').getValue(),
                        WhpCode: Ext.getCmp('WhpCode').getValue(),
                        WhpName: Ext.getCmp('WhpName').getValue(),
                        WhpAddr: Ext.getCmp('WhpAddr').getValue(),
                        MaxCapacity: Ext.getCmp('MaxCapacity').getValue(),
                        MaxWeight: Ext.getCmp('MaxWeight').getValue(),
                        Remark: Ext.getCmp('Remark').getValue(),
                        Status: Ext.getCmp('Status').getValue()
                    },
                    success: function(resp, opts) {
                        if (checkExtMessage(resp)) {
                            updateDataGrid();
                        }
                    }
                });
            }
            /*------结束获取界面数据的函数 End---------------*/
            //alert(3);
            /*------开始界面数据的函数 Start---------------*/
            function setFormValue(selectData) {
                Ext.Ajax.request({
                    url: 'frmWmsWarehousePosition.aspx?method=getWarehousePos',
                    params: {
                        WhpId: selectData.data.WhpId
                    },
                    success: function(resp, opts) {
                        var data = Ext.util.JSON.decode(resp.responseText);
                        Ext.getCmp("WhpId").setValue(data.WhpId);
                        Ext.getCmp("WhId").setValue(data.WhId);

                        Ext.getCmp("WhId").disable();
                        Ext.getCmp("WhpCode").setValue(data.WhpCode);
                        //Ext.getCmp("WhpName").disable();
                        Ext.getCmp("WhpName").setValue(data.WhpName);
                        Ext.getCmp("WhpAddr").setValue(data.WhpAddr);
                        Ext.getCmp("MaxCapacity").setValue(data.MaxCapacity);
                        Ext.getCmp("MaxWeight").setValue(data.MaxWeight);
                        Ext.getCmp("Remark").setValue(data.Remark);
                        Ext.getCmp("Status").setValue(data.Status);
                    },
                    failure: function(resp, opts) {
                        Ext.Msg.alert("提示", "获取仓位信息失败！");
                    }
                });
            }
            /*------结束设置界面数据的函数 End---------------*/
            /*------开始查询form的函数 start---------------*/

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
                mode: 'local',
                anchor: '90%',
                listeners: { specialkey: function(f, e) { if (e.getKey() == e.ENTER) { Ext.getCmp('searchebtnId').focus(); } },
                    blur: function(field) { if (field.getRawValue() == '') { field.clearValue(); } }
                }

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

                        /*------开始获取数据的函数 start---------------*/
                        var warehousePositionGridData = new Ext.data.Store
                        ({
                            url: 'frmWmsWarehousePosition.aspx?method=getWarehousePosList',
                            reader: new Ext.data.JsonReader({
                                totalProperty: 'totalProperty',
                                root: 'root'
                            }, [
	                        {
	                            name: 'WhpId'
	                        },
	                        {
	                            name: 'WhId'
	                        },
	                        {
	                            name: 'WhpCode'
	                        },
	                        {
	                            name: 'WhpName'
	                        },
	                        {
	                            name: 'WhpAddr'
	                        },
	                        {
	                            name: 'MaxCapacity'
	                        },
	                        {
	                            name: 'MaxWeight'
	                        },
	                        {
	                            name: 'Barcode'
	                        },
	                        {
	                            name: 'Remark'
	                        },
	                        {
	                            name: 'Status'
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
                        //alert(4);
                        /*------开始DataGrid的函数 start---------------*/

                        var sm = new Ext.grid.CheckboxSelectionModel({
                            singleSelect: true
                        });
                        var warehousePositionGrid = new Ext.grid.GridPanel({
                            el: 'warehousePositionGrid',
                            width: '100%',
                            height: '100%',
                            autoWidth: true,
                            autoHeight: true,
                            autoScroll: true,
                            layout: 'fit',
                            id: 'divGrid',
                            store: warehousePositionGridData,
                            loadMask: { msg: '正在加载数据，请稍侯……' },
                            sm: sm,
                            cm: new Ext.grid.ColumnModel([
		                        sm,
		                        new Ext.grid.RowNumberer(), //自动行号
		                        {
		                        header: '仓位ID',
		                        dataIndex: 'WhpId',
		                        id: 'WhpId',
		                        hidden: true,
		                        hideable: false
		                    },
		                    {
		                        header: '所属仓库',
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
		                        header: '仓位编码',
		                        dataIndex: 'WhpCode',
		                        id: 'WhpCode'
		                    },
		                    {
		                        header: '仓位名称',
		                        dataIndex: 'WhpName',
		                        id: 'WhpName'
		                    },
		                    {
		                        header: '仓位地址',
		                        dataIndex: 'WhpAddr',
		                        id: 'WhpAddr'
		                    },
		                    {
		                        header: '最大体积',
		                        dataIndex: 'MaxCapacity',
		                        id: 'MaxCapacity'
		                    },
		                    {
		                        header: '最大重量',
		                        dataIndex: 'MaxWeight',
		                        id: 'MaxWeight'
		                    },
		                    {
		                        header: '条形码',
		                        dataIndex: 'Barcode',
		                        id: 'Barcode',
		                        hidden: true,
		                        hideable: false
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
		                        value: 0,
		                        renderer: function(val) { if (val == 0) return '启用'; if (val == 1) return '禁用'; }

}]),
                            bbar: new Ext.PagingToolbar({
                                pageSize: 10,
                                store: warehousePositionGridData,
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
                        warehousePositionGrid.render();
                        /*------DataGrid的函数结束 End---------------*/
                        updateDataGrid();
                    })
</script>

</html>
