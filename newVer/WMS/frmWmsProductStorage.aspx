<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmWmsProductStorage.aspx.cs" Inherits="WMS_frmWmsProductStorage" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html>
<head>
<title>商品存放管理</title><meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<link rel="stylesheet" type="text/css" href="../ext3/resources/css/ext-all.css" />
<script type="text/javascript" src="../ext3/adapter/ext/ext-base.js"></script>
<script type="text/javascript" src="../ext3/ext-all.js"></script>
<script type="text/javascript" src="../ext3/example/ItemDeleter.js"></script>
<script type="text/javascript" src="../js/operateResp.js"></script>
<style type="text/css">
.extensive-remove {
background-image: url(../Theme/1/images/extjs/customer/cross.gif) ! important;
}
</style>
</head>

<body>
<div id='toolbar'></div>
<div id='searchForm'></div>
<div id='dataGrid'></div>

</body>
<%= getComboBoxStore() %>
<script type="text/javascript">
Ext.BLANK_IMAGE_URL = "../ext3/resources/images/default/s.gif";
Ext.onReady(function() {
    var saveType;
    /*------实现toolbar的函数 start---------------*/
    var Toolbar = new Ext.Toolbar({
        renderTo: "toolbar",
        items: [{
            text: "新增",
            icon: "../Theme/1/images/extjs/customer/add16.gif",
            handler: function() {
                saveType = 'add';
                openAddStorageWin();
            }
        }, '-', {
            text: "编辑",
            icon: "../Theme/1/images/extjs/customer/edit16.gif",
            handler: function() {
                saveType = 'save';
                modifyStorageWin();
            }
        }, '-', {
            text: "删除",
            icon: "../Theme/1/images/extjs/customer/delete16.gif",
            handler: function() {
                deleteStorage();
            }
        }, '-', {
            text: "仓位存放配置",
            icon: "../Theme/1/images/extjs/customer/delete16.gif",
            handler: function() {
                configStorageWhp();
            }
}]
        });

        /*------结束toolbar的函数 end---------------*/


        /*------开始ToolBar事件函数 start---------------*//*-----新增Storage实体类窗体函数----*/
        function openAddStorageWin() {
            uploadStorageWindow.show();
        }
        /*-----编辑Storage实体类窗体函数----*/
        function modifyStorageWin() {
            var sm = gridData.getSelectionModel();
            //获取选择的数据信息
            var selectData = sm.getSelected();
            if (selectData == null) {
                Ext.Msg.alert("提示", "请选中需要编辑的信息！");
                return;
            }
            uploadStorageWindow.show();
            setFormValue(selectData);
        }
        /*-----删除Storage实体函数----*/
        /*删除信息*/
        function deleteStorage() {
            var sm = gridData.getSelectionModel();
            //获取选择的数据信息
            var selectData = sm.getSelected();
            //如果没有选择，就提示需要选择数据信息
            if (selectData == null) {
                Ext.Msg.alert("提示", "请选中需要删除的信息！");
                return;
            }
            //删除前再次提醒是否真的要删除
            Ext.Msg.confirm("提示信息", "是否真的要删除选择的信息吗？", function callBack(id) {
                //判断是否删除数据
                if (id == "yes") {
                    //页面提交
                    Ext.Ajax.request({
                        url: 'frmWmsProductStorage.aspx?method=deleteStorage',
                        method: 'POST',
                        params: {
                            StorId: selectData.data.StorId
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
        /*-----配置StorageWhp实体类窗体函数----*/
        function configStorageWhp() {
            var sm = gridData.getSelectionModel();
            //获取选择的数据信息
            var selectData = sm.getSelected();
            //如果没有选择，就提示需要选择数据信息
            if (selectData == null) {
                Ext.Msg.alert("提示", "请选中需要配置的信息！");
                return;
            }
            dsWarehousePosList.load({
                params: {
                    WhId: selectData.data.WhId
                }
            });
            uploadWhpWindow.show();
            dsStorageWhp.load({
                params: {
                    limit: 10,
                    start: 0,
                    StorId: selectData.data.StorId
                },
                callback: function(records, options, success) {
                    inserNewBlankRow()
                }
            });

        }
        /*------实现FormPanle的函数 start---------------*/
        /*------定义商品下拉框 start ----------*/
        var dsProductList;
        //用于下拉列表的store
        if (dsProductList == null) { //防止重复加载
            dsProductList = new Ext.data.JsonStore({
                totalProperty: "results",
                root: "root",
                url: 'frmWmsProductStorage.aspx?method=getProducts',
                fields: ['ProductId', 'ProductName']
            });
            // dsProductList.load();	
        }
        // 定义下拉框异步返回显示模板
        var resultTpl = new Ext.XTemplate(  
            '<tpl for="."><div id="searchdivid" class="search-item">',  
                '<h3><span>编号:{ProductNo}&nbsp;  名称:{ProductName}</span></h3>',
            '</div></tpl>'  
        ); 
        var storageForm = new Ext.form.FormPanel({
            url: '',
            //renderTo:'divForm',
            frame: true,
            title: '',
            items: [
		{
		    xtype: 'hidden',
		    fieldLabel: '存放ID',
		    columnWidth: 1,
		    anchor: '90%',
		    name: 'StorId',
		    id: 'StorId',
		    hidden: true,
		    hideLabel: true
		}
, {
    xtype: 'combo',
    fieldLabel: '仓库',
    columnWidth: 1,
    anchor: '90%',
    name: 'WhId',
    id: 'WhId',
    store: dsWh,
    displayField: 'WhName',
    valueField: 'WhId',
    mode: 'local',
    triggerAction: 'all',
    editable: false
}
, {
    xtype: 'textfield',
    fieldLabel: '商品ID',
    columnWidth: 1,
    anchor: '90%',
    name: 'ProductId',
    id: 'ProductId',
    hidden: true,
    hideLabel: true
}
, {
    xtype: 'combo',
    fieldLabel: '商品',
    columnWidth: 1,
    anchor: '90%',
    name: 'ProductName',
    id: 'ProductName',
    store: dsProductList,
    pageSize: 10,
    minChars: 1,
    hideTrigger: true,
    typeAhead: false,
    emptyText: '请选择商品',
    selectOnFocus: false,
    editable: true,
    displayField: 'ProductName',
    valueField: 'ProductId',
    tpl: resultTpl,  
    itemSelector: 'div.search-item', 
    listeners: {
        "select": function(combo, record, index) {
            Ext.getCmp("ProductId").setValue(record.data.ProductId);
            this.collapse();
        }
    }
}
, {
    xtype: 'textfield',
    fieldLabel: '最小重量',
    columnWidth: 1,
    anchor: '90%',
    name: 'MinWeight',
    id: 'MinWeight',
    value: 0
}
, {
    xtype: 'textfield',
    fieldLabel: '最大重量',
    columnWidth: 1,
    anchor: '90%',
    name: 'MaxWeight',
    id: 'MaxWeight',
    value: 0
}
, {
    xtype: 'combo',
    fieldLabel: '是否预警',
    columnWidth: 1,
    anchor: '90%',
    name: 'IsWarning',
    id: 'IsWarning',
    store: [[0, '启用'], [1, '禁用']],
    mode: 'local',
    triggerAction: 'all',
    editable: false,
    value: 0
}
]
        });
        /*------FormPanle的函数结束 End---------------*/

        /*------开始界面数据的窗体 Start---------------*/
        if (typeof (uploadStorageWindow) == "undefined") {//解决创建2个windows问题
            uploadStorageWindow = new Ext.Window({
                id: 'Storageformwindow',
                title: '商品存放管理'
		, iconCls: 'upload-win'
		, width: 350
		, height: 220
		, layout: 'fit'
		, plain: true
		, modal: true
		, constrain: true
		, resizable: false
		, closeAction: 'hide'
		, autoDestroy: true
		, items: storageForm
		, buttons: [{
		    text: "保存"
			, handler: function() {
			    saveUserData();
			}
			, scope: this
		},
		{
		    text: "取消"
			, handler: function() {
			    uploadStorageWindow.hide();
			}
			, scope: this
}]
            });
        }
        uploadStorageWindow.addListener("hide", function() {
            storageForm.getForm().reset();
            updateDataGrid();
        });

        /*------开始获取界面数据的函数 start---------------*/
        function saveUserData() {
            Ext.Ajax.request({
                url: 'frmWmsProductStorage.aspx?method=saveStorage',
                method: 'POST',
                params: {
                    StorId: Ext.getCmp('StorId').getValue(),
                    WhId: Ext.getCmp('WhId').getValue(),
                    ProductId: Ext.getCmp('ProductId').getValue(),
                    MinWeight: Ext.getCmp('MinWeight').getValue(),
                    MaxWeight: Ext.getCmp('MaxWeight').getValue(),
                    IsWarning: Ext.getCmp('IsWarning').getValue()
                },
                success: function(resp, opts) {
                    if (checkExtMessage(resp)) {

                    }
                }
            });
        }
        /*------结束获取界面数据的函数 End---------------*/

        /*------开始界面数据的函数 Start---------------*/
        function setFormValue(selectData) {
            Ext.Ajax.request({
                url: 'frmWmsProductStorage.aspx?method=getStorage',
                params: {
                    StorId: selectData.data.StorId
                },
                success: function(resp, opts) {
                    var data = Ext.util.JSON.decode(resp.responseText);
                    Ext.getCmp("StorId").setValue(data.StorId);
                    Ext.getCmp("WhId").setValue(data.WhId);
                    Ext.getCmp("ProductId").setValue(data.ProductId);
                    Ext.getCmp("ProductName").setValue(data.ProductName);
                    Ext.getCmp("MinWeight").setValue(data.MinWeight);
                    Ext.getCmp("MaxWeight").setValue(data.MaxWeight);
                    Ext.getCmp("IsWarning").setValue(data.IsWarning);
                },
                failure: function(resp, opts) {
                    Ext.Msg.alert("提示", "获取商品存放信息失败！");
                }
            });
        }
        function updateDataGrid() {
            var WhId = storageWhNamePanel.getValue();
            var ProductName = storageNamePanel.getValue();

            dsStorage.baseParams.WhId = WhId;
            dsStorage.baseParams.ProductName = ProductName;

            dsStorage.load({
                params: {
                    start: 0,
                    limit: 10
                }
            });
        }
        /*------结束设置界面数据的函数 End---------------*/

        /*------开始查询form的函数 start---------------*/

        var storageWhNamePanel = new Ext.form.ComboBox({
            fieldLabel: '仓库名称',
            name: 'settingwarehouseCombo',
            store: dsWh,
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
            editable: false,
            listeners: { specialkey: function(f, e) {
                if (e.getKey() == e.ENTER) {
                    //Ext.getCmp('searchebtnId').focus(); 
                }
            } //
            }

        });
        var storageNamePanel = new Ext.form.TextField({
            style: 'margin-left:0px',
            cls: 'key',
            xtype: 'textfield',
            fieldLabel: '产品名称',
            name: 'settinNameProduct',
            anchor: '90%'
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
                storageWhNamePanel
            ]
                }, {
                    columnWidth: .4,
                    layout: 'form',
                    border: false,
                    items: [
                storageNamePanel
                ]
                }, {
                    columnWidth: .2,
                    layout: 'form',
                    border: false,
                    items: [{ cls: 'key',
                        xtype: 'button',
                        text: '查询',
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
                    var dsStorage = new Ext.data.Store
({
    url: 'frmWmsProductStorage.aspx?method=getStorageList',
    reader: new Ext.data.JsonReader({
        totalProperty: 'totalProperty',
        root: 'root'
    }, [
	{ name: 'StorId' },
	{ name: 'WhId' },
	{ name: 'WhName' },
	{ name: 'ProductId' },
	{ name: 'ProductName' },
	{ name: 'MinWeight' },
	{ name: 'MaxWeight' },
	{ name: 'IsWarning' },
	{ name: 'OrgId' },
	{ name: 'OperId' },
	{ name: 'OwnerId' },
	{ name: 'CreateDate' },
	{ name: 'UpdateDate' }
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
                    var gridData = new Ext.grid.GridPanel({
                        el: 'dataGrid',
                        width: '100%',
                        height: '100%',
                        autoWidth: true,
                        autoHeight: true,
                        autoScroll: true,
                        layout: 'fit',
                        id: '',
                        store: dsStorage,
                        loadMask: { msg: '正在加载数据，请稍侯……' },
                        sm: sm,
                        cm: new Ext.grid.ColumnModel([
		sm,
		new Ext.grid.RowNumberer(), //自动行号
		{
		header: '存放ID',
		dataIndex: 'StorId',
		id: 'StorId',
		hidden: true,
		hideable: false
},
		{
		    header: '仓库',
		    dataIndex: 'WhName',
		    id: 'WhName'
		},
		{
		    header: '商品',
		    dataIndex: 'ProductName',
		    id: 'ProductName'
		},
		{
		    header: '最小重量',
		    dataIndex: 'MinWeight',
		    id: 'MinWeight'
		},
		{
		    header: '最大重量',
		    dataIndex: 'MaxWeight',
		    id: 'MaxWeight'
		},
		{
		    header: '是否预警',
		    dataIndex: 'IsWarning',
		    id: 'IsWarning',
		    renderer: { fn: function(v) {
		        if (v > 0) return '禁用';
		        return '启用';
		    }
		    }
		},
		{
		    header: '创建日期',
		    dataIndex: 'CreateDate',
		    id: 'CreateDate'
		}
		]),
                        bbar: new Ext.PagingToolbar({
                            pageSize: 10,
                            store: dsStorage,
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
                    gridData.render();
                    /*------DataGrid的函数结束 End---------------*/

                    /*------WhpDataGrid的函数结束 start---------------*/
                    var dsWarehousePosList;
                    if (dsWarehousePosList == null) { //防止重复加载
                        dsWarehousePosList = new Ext.data.Store
                        ({
                            url: 'frmWmsProductStorage.aspx?method=getWarehousePosList',
                            reader: new Ext.data.JsonReader({
                                totalProperty: 'totalProperty',
                                root: 'root'
                            }, [
                                { name: 'WhpId' },
                                { name: 'WhpName' }
                            ])
                        });
                    }
                    /*------开始获取数据的函数 start---------------*/
                    var dsStorageWhp = new Ext.data.Store
                    ({
                        url: 'frmWmsProductStorage.aspx?method=getAllWhp',
                        reader: new Ext.data.JsonReader({
                            totalProperty: 'totalProperty',
                            root: 'root'
                        }, [
	                    { name: 'Id' },
	                    { name: 'StorId' },
	                    { name: 'WhpId' },
	                    { name: 'Priority' }
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
                    var positionCombobox = new Ext.form.ComboBox({
                        name: 'warehouseCombo',
                        store: dsWarehousePosList,
                        displayField: 'WhpName',
                        valueField: 'WhpId',
                        hiddenName: 'WhpId',
                        typeAhead: true, //自动将第一个搜索到的选项补全输入
                        triggerAction: 'all',
                        emptyText: '请选择仓位',
                        emptyValue: '',
                        selectOnFocus: true,
                        forceSelection: true,
                        anchor: '90%',
                        mode: 'local',
                        listeners: {
                            select: function(combo, record, index) {
                                addNewBlankRow();
                            }
                        }
                    });
                    var sm = new Ext.grid.CheckboxSelectionModel({
                        singleSelect: true
                    });
                    var gridWhpData = new Ext.grid.EditorGridPanel({
                        height: 250,
                        width: '100%',
                        autoWidth: true,
                        //autoHeight:true,
                        autoScroll: true,
                        layout: 'fit',
                        clicksToEdit: 1,
                        id: '',
                        store: dsStorageWhp,
                        loadMask: { msg: '正在加载数据，请稍侯……' },
                        selModel: new Extensive.grid.ItemDeleter(),
                        cm: new Ext.grid.ColumnModel([
		new Ext.grid.RowNumberer(), //自动行号
		{
		header: '流水号',
		dataIndex: 'Id',
		id: 'Id',
		hidden: true,
		hideable: false
},
		{
		    header: '存放ID',
		    dataIndex: 'StorId',
		    id: 'StorId',
		    hidden: true,
		    hideable: false
		},
		{
		    header: '仓位',
		    dataIndex: 'WhpId',
		    id: 'WhpId',
		    editor: positionCombobox,
		    renderer: function(value, cellmeta, record, rowIndex, columnIndex, store) {
		        var index = dsWarehousePosList.findBy(function(record, id) {
		            return record.get(positionCombobox.valueField) == value;
		        });
		        var record = dsWarehousePosList.getAt(index);
		        var displayText = "";
		        if (record == null) {
		            displayText = value;
		        } else {
		            displayText = record.data.WhpName;
		        }
		        //alert(displayText);
		        return displayText;
		    }
		},
		{
		    header: '优先级', //1~99，序号越小，优先级越高
		    dataIndex: 'Priority',
		    id: 'Priority',
		    editor: new Ext.form.TextField({
		        allowBlank: false
		    })
		}, new Extensive.grid.ItemDeleter()
		]),
                        bbar: new Ext.PagingToolbar({
                            pageSize: 10,
                            store: dsStorageWhp,
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

                    /*------开始界面数据的窗体 Start---------------*/
                    if (typeof (uploadWhpWindow) == "undefined") {//解决创建2个windows问题
                        uploadWhpWindow = new Ext.Window({
                            id: 'Whpformwindow',
                            title: '添加仓位信息'
		, iconCls: 'upload-win'
		, width: 400
		, height: 300
		, layout: 'fit'
		, plain: true
		, modal: true
		, constrain: true
		, resizable: false
		, closeAction: 'hide'
		, autoDestroy: true
		, items: gridWhpData
		, buttons: [{
		    text: "保存"
			, handler: function() {
			    var json = '';
			    dsStorageWhp.each(function(dsStorageWhp) {
			        json += Ext.util.JSON.encode(dsStorageWhp.data) + ',';
			    });
			    json = json.substring(0, json.length - 1);
			    //alert(json);  
			    Ext.Ajax.request({
			        url: 'frmWmsProductStorage.aspx?method=saveStoreWhp',
			        method: 'POST',
			        params: {
			            WhpData: json
			        },
			        success: function(resp, opts) {
			            if (checkExtMessage(resp)) {

			            }
			        }
			    });
			}
			, scope: this
		},
		{
		    text: "取消"
			, handler: function() {
			    uploadWhpWindow.hide();
			}
			, scope: this
}]
                        });
                    }
                    uploadWhpWindow.addListener("hide", function() {
                        gridWhpData.getStore().removeAll();
                    });
                    var RowPattern = Ext.data.Record.create([
                       { name: 'Id', type: 'string' },
                       { name: 'StorId', type: 'string' },
                       { name: 'WhpId', type: 'string' },
                       { name: 'Priority', type: 'string' }
                    ]);
                    function inserNewBlankRow() {
                        var rowCount = gridWhpData.getStore().getCount();
                        //alert(rowCount);
                        var sm = gridData.getSelectionModel();
                        //获取选择的数据信息
                        var selectData = sm.getSelected();
                        var insertPos = parseInt(rowCount);
                        var addRow = new RowPattern({
                            Id: '0',
                            StorId: selectData.data.StorId,
                            WhpId: '',
                            Priority: ''
                        });
                        gridWhpData.stopEditing();
                        //增加一新行
                        if (insertPos > 0) {
                            var rowIndex = dsStorageWhp.insert(insertPos, addRow);
                            gridWhpData.startEditing(insertPos, 0);
                        }
                        else {
                            var rowIndex = dsStorageWhp.insert(0, addRow);
                            gridWhpData.startEditing(0, 0);
                        }
                    }
                    function addNewBlankRow() {
                        var rowIndex = gridWhpData.getStore().indexOf(gridWhpData.getSelectionModel().getSelected());
                        var rowCount = gridWhpData.getStore().getCount();
                        //alert(rowIndex+":"+rowCount);    
                        if ((rowIndex == 0 && rowCount == 1) || rowIndex == rowCount - 1) {
                            inserNewBlankRow();
                        }
                    }
                    /*------WhpDataGrid的函数结束 End---------------*/
                    updateDataGrid();
                })
</script>

</html>
