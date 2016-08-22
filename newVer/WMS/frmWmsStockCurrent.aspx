<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmWmsStockCurrent.aspx.cs" Inherits="WMS_frmWmsStockCurrent" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html>
<head>
<title>实时库存查询页面</title><meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<link rel="stylesheet" type="text/css" href="../ext3/resources/css/ext-all.css" />
<script type="text/javascript" src="../ext3/adapter/ext/ext-base.js"></script>
<script type="text/javascript" src="../ext3/ext-all.js"></script>
<script type="text/javascript" src="../js/OrgsSelect.js"></script>
    <script type="text/javascript" src="../js/FilterControl.js"></script>
    <script type="text/javascript" src="../js/GroupFieldSelect.js"></script>
     <script type="text/javascript" src="../js/ProductSelect.js"></script>
     <script type="text/javascript" src="../js/ExtJsHelper.js"></script>
     <link rel="Stylesheet" type="text/css" href="../css/gridPrint.css" />
     <script type="text/javascript" src="../js/operateResp.js"></script>
     <script type="text/javascript" src="../js/getExcelXml.js"></script>
</head>
<body>
<div id='toolbar'></div>
<div id='searchForm'></div>
<div id='divForm'></div>
<div id='seachFormDiv'></div>
<div id='stockGridDiv'></div>
<div id='searchGrid'></div>


</body>
<%=getComboBoxStore() %>

<script type="text/javascript">

 
    Ext.BLANK_IMAGE_URL = "../ext3/resources/images/default/s.gif";
    Ext.onReady(function() {

        var dsWarehouseList;
        if (dsWarehouseList == null) { //防止重复加载
            dsWarehouseList = new Ext.data.JsonStore({
                totalProperty: "result",
                root: "root",
                url: '../scm/frmOrderStatistics.aspx?method=getWhSimple',
                fields: ['WhId', 'WhName']
            });
            //dsWarehouseList.load();
        };

        //dsWarehouseList.load({ params: { OrgId: orgId, ForBusi: 1} });
        function wareHouseLoad() {
            if (dsWarehouseList.baseParams.OrgId != selectOrgIds) {
                dsWarehouseList.baseParams.OrgId = selectOrgIds;
                dsWarehouseList.baseParams.ForBusi = 1;
                dsWarehouseList.load();
            }
        }


        var selectOrgIds = orgId;
        var ArriveOrgText = new Ext.form.TextField({
            fieldLabel: '公司',
            id: 'orgSelect',
            value: orgName
            //disabled:true
        });

        wareHouseLoad();

        ArriveOrgText.on("focus", selectOrgType);
        function selectOrgType() {

            if (selectOrgForm == null) {
                var showType = "getcurrentandchildrentree";
                if (orgId == 1) {
                    showType = "getcurrentAndChildrenTreeByArea";
                }
                showOrgForm("", "", "../ba/sysadmin/frmAdmOrgList.aspx?method=" + showType);
                selectOrgForm.buttons[0].on("click", selectOrgOk);
                if (orgId == 1) {
                    selectOrgTree.on('checkchange', treeCheckChange, selectOrgTree);
                }
            }
            else {
                showOrgForm("", "", "");
            }
        }
        function selectOrgOk() {
            var selectOrgNames = "";
            selectOrgIds = "";
            var selectNodes = selectOrgTree.getChecked();
            for (var i = 0; i < selectNodes.length; i++) {
                if (selectNodes[i].id.indexOf("A") != -1)
                    continue;
                if (selectOrgNames != "") {
                    selectOrgNames += ",";
                    selectOrgIds += ",";
                }
                selectOrgIds += selectNodes[i].id;
                selectOrgNames += selectNodes[i].text;

            }
            if (selectOrgIds == '') {
                selectOrgIds = orgId;
                currentSelect.setValue(orgName);
            }
            else {
                currentSelect.setValue(selectOrgNames);
            }
            wareHouseLoad();

        }

        //允许单选
        function treeCheckChange(node, checked) {
            selectOrgTree.un('checkchange', treeCheckChange, selectOrgTree);
            if (checked) {
                var selectNodes = selectOrgTree.getChecked();
                for (var i = 0; i < selectNodes.length; i++) {
                    if (selectNodes[i].id != node.id) {
                        selectNodes[i].ui.toggleCheck(false);
                        selectNodes[i].attributes.checked = false;
                    }
                }
            }
            selectOrgTree.on('checkchange', treeCheckChange, selectOrgTree);
        }

        var dsWarehousePositionList; //仓位下拉框
        if (dsWarehousePositionList == null) { //防止重复加载
            dsWarehousePositionList = new Ext.data.JsonStore({
                totalProperty: "result",
                root: "root",
                url: 'frmWmsStockCurrent.aspx?method=getWarehousePositionList',
                fields: ['WhpId', 'WhpName']
            });
        }

        var dsWarehousePositionList_grid; //仓位下拉框
        if (dsWarehousePositionList_grid == null) { //防止重复加载
            //alert(1);
            dsWarehousePositionList_grid = new Ext.data.JsonStore({
                totalProperty: "result",
                root: "root",
                url: 'frmWmsStockCurrent.aspx?method=getWarehousePositionList',
                fields: ['WhpId', 'WhpName']
            });
            dsWarehousePositionList_grid.load();
        }

        //        function updateDataGrid() {

        //            var WhId = WhNamePanel.getValue();
        //            var WhpId = WhpNamePanel.getValue();
        ////            var ProductId = ProductNamePanel.getValue();
        //            stockGridData.baseParams.WhId = WhId;
        //            stockGridData.baseParams.WhpId = WhpId;
        ////            stockGridData.baseParams.ProductId = ProductId;
        //            stockGridData.baseParams.OrgId = selectOrgIds;
        //            stockGridData.baseParams.ProductName = ProductNamePanel.getValue();
        //            stockGridData.load({
        //                params: {
        //                    start: 0,
        //                    limit: 16
        //                }
        //            });

        //        }



        /*------开始获取数据的函数 start---------------*/
        var stockGridData = new Ext.data.Store
({
    url: 'frmWmsStockCurrent.aspx?method=getCurrentStockList',
    reader: new Ext.data.JsonReader({
        totalProperty: 'totalProperty',
        root: 'root'
    }, [
	{
	    name: 'Id'
	},
	{
	    name: 'OrgId'
	},
	{
	    name: 'WhId'
	},
	{
	    name: 'WhpId'
	},
	{
	    name: 'BatchNo'
	},
	{
	    name: 'ProductId'
	},
	{
	    name: 'PrestreQty'
	}, {
	    name: 'ProductCode'
	}, {
	    name: 'ProductName'
	}, {
	    name: 'ProductSpec'
	}, {
	    name: 'AliasRealQty', type: 'float'
	},{
	    name: 'ProductUnit'
	},	{
	    name: 'RealQty', type: 'float'
	},	{
	    name: 'BaseUnitName'
	}, {
	    name: 'ProductPrice'
	}, { name: 'WhName' }, { name: 'WhpName'}])
	,
    listeners:
	{
	    scope: this,
	    load: function() {
	    }
	}
});
        /*------搜索------Start-----------------------*/
        //        var WhNamePanel = new Ext.form.ComboBox({
        //            fieldLabel: '仓库名称',
        //            name: 'warehouseCombo',
        //            store: dsWarehouseList,
        //            displayField: 'WhName',
        //            valueField: 'WhId',
        //            typeAhead: true, //自动将第一个搜索到的选项补全输入
        //            triggerAction: 'all',
        //            emptyText: '请选择仓库',
        //            selectOnFocus: true,
        //            forceSelection: true,
        //            anchor: '90%',
        //            mode: 'local',
        //            listeners: {
        //                specialkey: function(f, e) {
        //                    if (e.getKey() == e.ENTER) {
        //                        Ext.getCmp('WhpId').focus();
        //                    }
        //                }
        //              ,
        //                select: function(combo, record, index) {
        //                    var curWhId = WhNamePanel.getValue();
        //                    dsWarehousePositionList.load({
        //                        params: {
        //                            WhId: curWhId
        //                        }
        //                    });
        //                    Ext.getCmp('WhpId').setValue("");
        //                }
        //            }
        //        });


        //        var WhpNamePanel = new Ext.form.ComboBox({
        //            fieldLabel: '仓位名称',
        //            name: 'warehousePosCombo',
        //            store: dsWarehousePositionList,
        //            displayField: 'WhpName',
        //            valueField: 'WhpId',
        //            typeAhead: true, //自动将第一个搜索到的选项补全输入
        //            triggerAction: 'all',
        //            emptyText: '请选择仓位',
        //            //valueNotFoundText: 0,
        //            selectOnFocus: true,
        //            forceSelection: true,
        //            mode: 'local',
        //            id: 'WhpId',
        //            anchor: '90%',
        //            listeners: { specialkey: function(f, e) { if (e.getKey() == e.ENTER) { Ext.getCmp('ProductId').focus(); } },
        //                blur: function(field) { if (field.getRawValue() == '') { field.clearValue(); } }
        //            }

        //        });
        //        //        var ProductNamePanel = new Ext.form.ComboBox({
        //        //            fieldLabel: '商品名称',
        //        //            name: 'productCombo',
        //        //            store: dsProductList,
        //        //            displayField: 'ProductName',
        //        //            valueField: 'ProductId',
        //        //            typeAhead: true, //自动将第一个搜索到的选项补全输入
        //        //            triggerAction: 'all',
        //        //            emptyText: '请选择商品',
        //        //            //valueNotFoundText: 0,
        //        //            selectOnFocus: true,
        //        //            forceSelection: true,
        //        //            id: 'ProductId',
        //        //            anchor: '90%',
        //        //            mode: 'local',
        //        //            listeners: { specialkey: function(f, e) { if (e.getKey() == e.ENTER) { Ext.getCmp('searchebtnId').focus(); } } }

        //        //        });

        //        var ProductNamePanel = new Ext.form.TextField({
        //            fieldLabel: '商品名称',
        //            name: 'productName'
        //        });


        //        var serchform = new Ext.FormPanel({
        //            renderTo: 'seachFormDiv',
        //            labelAlign: 'left',
        //            layout: 'fit',
        //            buttonAlign: 'right',
        //            bodyStyle: 'padding:5px',
        //            frame: true,
        //            labelWidth: 55,
        //            items: [{
        //                layout: 'column',   //定义该元素为布局为列布局方式
        //                border: false,
        //                items: [{
        //                    columnWidth: .3,  //该列占用的宽度，标识为20％
        //                    layout: 'form',
        //                    border: false,
        //                    items: [
        //                        ArriveOrgText
        //                    ]
        //                }, {
        //                    columnWidth: .2,  //该列占用的宽度，标识为20％
        //                    layout: 'form',
        //                    border: false,
        //                    items: [
        //                        WhNamePanel
        //                    ]
        //                }, {
        //                    columnWidth: .2,
        //                    layout: 'form',
        //                    border: false,
        //                    items: [
        //                        WhpNamePanel
        //                        ]
        //                }, {
        //                    columnWidth: .2,
        //                    layout: 'form',
        //                    border: false,
        //                    items: [
        //                        ProductNamePanel
        //                        ]
        //                }, {
        //                    columnWidth: .1,
        //                    layout: 'form',
        //                    border: false,
        //                    items: [{ cls: 'key',
        //                        xtype: 'button',
        //                        text: '查询',
        //                        id: 'searchebtnId',
        //                        anchor: '50%',
        //                        handler: function() {
        //                            updateDataGrid();
        //                        }
        //}]
        //}]
        //}]
        //                    });
        /*------搜索------END-------------------------*/

        /*------获取数据的函数 结束 End---------------*/

        /*------实现toolbar的函数 start---------------*/
        var Toolbar = new Ext.Toolbar({
            renderTo: 'toolbar',
            region: "north",
            height: 25//,
//            items: [{
//                text: "清除零库存信息",
//                icon: "../Theme/1/images/extjs/customer/add16.gif",
//                handler: function() {
//                    clearZeroProductStore();
//                }
//            }]
        });

function clearZeroProductStore()
{
    var sm = stockGrid.getSelectionModel();
    //获取选择的数据信息
    var selectData = sm.getSelected();
    //如果没有选择，就提示需要选择数据信息
    if (selectData == null) {
        Ext.Msg.alert("提示", "请选中需要删除的零库存信息！");
        return;
    }
    //删除前再次提醒是否真的要删除
    Ext.Msg.confirm("提示信息", "是否真的要删除选择的零库存商品信息吗？", function callBack(id) {
        //判断是否删除数据
        if (id == "yes") {
            //页面提交
            Ext.Ajax.request({
                url: 'frmWmsStockCurrent.aspx?method=clearZeroProductStore',
                method: 'POST',
                params: {
                    Id: selectData.data.Id
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
        iniSelectColumn(Toolbar, "searchGrid");
        //btnFliter.on("click", staticSeach);
        //btnContinueFliter.on("click", staticSeach);

        function staticSeach() {
            var json = "";
            filterStore.each(function(filterStore) {
                if (filterStore.data.ColumnName != '') {
                    json += Ext.util.JSON.encode(filterStore.data) + ',';
                }
            });

            searchDataGrid(json);
        }


        var defaultPageSize = 10;
        var toolBar = new Ext.PagingToolbar({
            pageSize: 10,
            store: stockGridData,
            displayMsg: '显示第{0}条到{1}条记录,共{2}条',
            emptyMsy: '没有记录',
            displayInfo: true
        });
        var pageSizestore = new Ext.data.SimpleStore({
            fields: ['pageSize'],
            data: [[10], [20], [30]]
        });
        var combo = new Ext.form.ComboBox({
            regex: /^\d*$/,
            store: pageSizestore,
            displayField: 'pageSize',
            typeAhead: true,
            mode: 'local',
            emptyText: '更改每页记录数',
            triggerAction: 'all',
            selectOnFocus: true,
            width: 135
        });
        toolBar.addField(combo);

        combo.on("change", function(c, value) {
            toolBar.pageSize = value;
            defaultPageSize = toolBar.pageSize;
        }, toolBar);
        combo.on("select", function(c, record) {
            toolBar.pageSize = parseInt(record.get("pageSize"));
            defaultPageSize = toolBar.pageSize;
            toolBar.doLoad(0);
        }, toolBar);

        /*------开始DataGrid的函数 start---------------*/
        var stockGrid = new Ext.grid.GridPanel({
            el: 'stockGridDiv',
            //width: '100%',
            //height: '100%',
            //autoWidth: true,
            //autoHeight: true,
            autoScroll: true,
            layout: 'fit',
            id: '',
            store: stockGridData,
            loadMask: { msg: '正在加载数据，请稍侯……' },
            cm: new Ext.grid.ColumnModel([
		new Ext.grid.RowNumberer(), //自动行号
		{
		header: '仓库名称',
		dataIndex: 'WhName',
		id: 'WhName',
		width: 100
},
		{   
		    header: '仓位名称',
		    dataIndex: 'WhpName',
		    id: 'WhpName',
		    width: 100
		},
        {
            header: '编码',
            dataIndex: 'ProductCode',
            id: 'ProductCode',
            width: 80
        },
		{
		    header: '商品名称',
		    dataIndex: 'ProductName',
		    id: 'ProductName',
		    width: 220
		},
        {
            header: '规格',
            dataIndex: 'ProductSpec',
            id: 'Productspec',
            width: 80
        },
        {
		    header: '计量数量',
		    dataIndex: 'AliasRealQty',
		    id: 'AliasRealQty',
		    width: 80
        },
        {
            header: '计量单位',
            dataIndex: 'ProductUnit',
            id: 'Productunit',
            width: 60

        },
        {
            header: '库存数量',
		dataIndex: 'RealQty',
		id: 'RealQty',
		width: 80//,
		    //hidden:true

        },

            //		{
            //		    header: '预入库量',
            //		    dataIndex: 'PrestreQty',
            //		    id: 'PrestreQty',
            //		    hide: true
            //		},
		{
		header: '库存单位',
            dataIndex: 'BaseUnitName',
            id: 'BaseUnitName',
            width: 60//,
            //hidden: true
}
   ]),
            bbar: toolBar,
            viewConfig: {
                columnsText: '显示的列',
                scrollOffset: 20,
                sortAscText: '升序',
                sortDescText: '降序',
                forceFit: false
            },
            height: 300,
            closeAction: 'hide',
            stripeRows: true,
            loadMask: true//,
            //autoExpandColumn: 2
        });

        toolBar.addField(createPrintButton(stockGridData, stockGrid, ''));
        stockGrid.render();
        printTitle = "存货实时库存信息";
        /*------DataGrid的函数结束 End---------------*/


        createSearch(stockGrid, stockGridData, "searchForm");
        searchForm.el = "searchForm";
        searchForm.render();

        var addRow = new fieldRowPattern({
            id: 'OrgId',
            name: '公司',
            dataType: 'select'
        });
        fieldStore.insert(0, addRow);
        addRow = new fieldRowPattern({
            id: 'ProductType',
            name: '产品类别',
            dataType: 'select'
        });
        fieldStore.add(addRow);



        txtFieldValue.on("focus", selectProductType);

        function selectProductType() {
            currentSelect = txtFieldValue;
            selectShow(cmbField.getValue());
        }

        var selectedProductIds = "";
        function selectProductOk() {
            var selectProductNames = "";
            selectedProductIds = "";
            var selectNodes = selectProductTree.getChecked();
            for (var i = 0; i < selectNodes.length; i++) {
                if (selectProductNames != "") {
                    selectProductNames += ",";
                    selectedProductIds += ",";
                }
                selectProductNames += selectNodes[i].text;
                selectedProductIds += selectNodes[i].id + '!' + selectNodes[i].text + '!' + selectNodes[i].attributes.CustomerColumn;
            }
            currentSelect.setValue(selectProductNames);
        }

        this.selectShow = function(columnName) {
            switch (columnName) {
                case "ProductType":
                    if (selectProductForm == null) {
                        parentUrl = "../CRM/product/frmBaProductClass.aspx?select=true&method=getbaproducttree";
                        showProductForm("", "", "", true);
                        selectProductForm.buttons[0].on("click", selectProductOk);
                    }
                    else {
                        showProductForm("", "", "", true);
                    }
                    break;
                case "OrgId":
                    selectOrgType();
                    break;
            }
        }
        this.getSelectedValue = function(columnName) {
            var value = '';
            switch (columnName) {
                case "ProductType":
                    value = selectedProductIds;
                    break;

                case "OrgId":
                    value = selectOrgIds;
                default:
                    break;
            }
            return value;
        }

        _grid = stockGrid;

        btnFliter.on("click", staticSeach);
        btnContinueFliter.on("click", staticSeach);

        function staticSeach() {
            var json = "";
            filterStore.each(function(filterStore) {
                if (filterStore.data.ColumnName != '') {
                    json += Ext.util.JSON.encode(filterStore.data) + ',';
                }
            });

            searchDataGrid(json);
        }

        this.getCmbStore = function(columnName) {
            switch (columnName) {
                case "WhId":
                    return dsWarehouseList;
                case "WhpId":
                    return dsWarehousePositionList;
            }
            return null;
        }
    })
</script>

</html>

