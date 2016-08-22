<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmSuppliersProductList.aspx.cs" Inherits="CRM_customer_frmSuppliersProductList" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
    <link rel="stylesheet" type="text/css" href="../../ext3/resources/css/ext-all.css" />
    <script type="text/javascript" src="../../ext3/adapter/ext/ext-base.js"></script>
    <script type="text/javascript" src="../../ext3/ext-all.js"></script>  
    <script type="text/javascript" src="../../js/operateResp.js"></script>    
    <script type="text/javascript" src="../../js/ExtJsHelper.js"></script>
    <script type="text/javascript" src="../../js/FilterControl.js"></script>
    <script type="text/javascript" src="../../js/ProductSelect.js"></script>
</head>
<body>
    <div id='toolbar'></div>
    <div id='searchForm'></div>
    <div id='searchForm12'></div>
    <div id='productGrid'></div>
</body>
<%=getComboBoxStore() %>
<script>
    var productGridData = null;
    Ext.BLANK_IMAGE_URL = "../../ext3/resources/images/default/s.gif";
    Ext.onReady(function() {
        var operType = '';
        Ext.QuickTips.init();
        Ext.form.Field.prototype.msgTarget = 'side';
        /*--------下拉框定义 start ---------------*/
        var dsSupplier; //供应商数据源
        var dsSmallProduct; //小类下拉框

        /*----------下拉框定义 end --------------*/


        /*------实现toolbar的函数 start---------------*/
        var Toolbar = new Ext.Toolbar({
            renderTo: "toolbar",
            items: [{
                text: "添加商品",
                icon: "../../Theme/1/images/extjs/customer/add16.gif",
                handler: function() {
                    addSuppliesProduct();
                }
            }, '-', {
                text: "删除商品",
                icon: "../../Theme/1/images/extjs/customer/edit16.gif",
                handler: function() {
                    delSuppliersPruducts();
                }
            }, '-', {
                text: "保存",
                icon: "../../Theme/1/images/extjs/customer/save.gif",
                handler: function() {
                    saveSuppliersPruducts();
                }
            }, '-']
        });

        setToolBarVisible(Toolbar);
        /*----------------------------------------*/
        addSuppliesProductWin = null;
        function addSuppliesProduct() {
            if (addSuppliesProductWin == null) {
                addSuppliesProductWin = parent.ExtJsShowWin('添加供应商品信息', 'frmSuppliersProductList.aspx?action=add&suppliersId=' + suppliersId, 'add', 800, 500);
                addSuppliesProductWin.show();
            }
            else {
                addSuppliesProductWin.show();
                parent.document.getElementById("iframeadd").contentWindow.suppliersId = suppliersId;
                parent.document.getElementById("iframeadd").contentWindow.loadData();
            }
        }

        function delSuppliersPruducts() {
            var sm = productGrid.getSelectionModel();
            //获取选择的数据信息
            var selectData = sm.getSelections();
            var ids = "";
            for (var i = 0; i < selectData.length; i++) {
                if (ids.length > 0)
                    ids += ",";
                ids += selectData[i].get("ProductId");
            }

            Ext.Msg.confirm("系统提示", "是否正的要删除选择的商品信息！", function callBack(id) {
                //判断是否删除数据
                if (id == "yes") {
                    Ext.Ajax.request({
                        url: 'frmSuppliersProductList.aspx?method=del',
                        method: 'POST',
                        params: {
                            SuppliersId: suppliersId,
                            ProductIds: ids
                        },
                        success: function(resp, opts) {
                            Ext.MessageBox.hide();
                            if (checkExtMessage(resp)) {
                                productGridData.reload();
                            }

                        }
         , failure: function(resp, opts) {
             Ext.MessageBox.hide();
             Ext.Msg.alert("提示", "删除失败");

         }
                    });
                }
            });
        }


        function saveSuppliersPruducts() {
            var sm = productGrid.getSelectionModel();
            //获取选择的数据信息
            var selectData = sm.getSelections();
            var ids = "";
            for (var i = 0; i < selectData.length; i++) {
                if (ids.length > 0)
                    ids += ",";
                ids += selectData[i].get("ProductId");
            }

            Ext.Ajax.request({
                url: 'frmSuppliersProductList.aspx?method=save',
                method: 'POST',
                params: {
                    SuppliersId: suppliersId,
                    ProductIds: ids
                },
                success: function(resp, opts) {
                    Ext.MessageBox.hide();
                    if (checkExtMessage(resp)) {
                        productGridData.reload();
                    }

                }
         , failure: function(resp, opts) {
             Ext.MessageBox.hide();
             Ext.Msg.alert("提示", "保存失败");

         }
            });
        }

        /*-------------------------------------------*/

        productGridData = new Ext.data.Store
({
    url: 'frmSuppliersProductList.aspx?method=getSuppliesProductList',
    reader: new Ext.data.JsonReader({
        totalProperty: 'totalProperty',
        root: 'root'
    }, [
	{
	    name: 'ProductId'
	},
	{
	    name: 'ProductNo'
	},
	{
	    name: 'MnemonicNo'
	},
	{
	    name: 'AliasNo'
	},
	{
	    name: 'MobileNo'
	},
	{
	    name: 'SpeechNo'
	},
	{
	    name: 'NetPurchasesNo'
	},
	{
	    name: 'LogisticsNo'
	},
	{
	    name: 'BarCode'
	},
	{
	    name: 'SecurityCode'
	},
	{
	    name: 'ProductName'
	},
	{
	    name: 'AliasName'
	},
	{
	    name: 'Specifications'
	},
	{
	    name: 'SpecificationsText'
	},
	{
	    name: 'Unit'
	},
	{
	    name: 'UnitText'
	},
	{
	    name: 'SalePrice', type: 'float'
	},
	{
	    name: 'SalePriceLower'
	},
	{
	    name: 'SalePriceLimit'
	},
	{
	    name: 'TaxWhPrice'
	},
	{
	    name: 'TaxRate'
	},
	{
	    name: 'Tax'
	},
	{
	    name: 'SalesTax'
	},
	{
	    name: 'UnitConvertRate'
	},
	{
	    name: 'AutoFreight'
	},
	{
	    name: 'DriverFreight'
	},
	{
	    name: 'TrainFreight'
	},
	{
	    name: 'ShipFreight'
	},
	{
	    name: 'OtherFeight'
	},
	{
	    name: 'Supplier'
	},
	{
	    name: 'SupplierText'
	},
	{
	    name: 'Origin'
	},
	{
	    name: 'OriginText'
	},
	{
	    name: 'AliasPrice'
	},
	{
	    name: 'IsPlan'
	},
	{
	    name: 'ProductType'
	},
	{
	    name: 'ProductVer'
	},
	{
	    name: 'Remark'
	},
	{
	    name: 'CreateDate'
	},
	{
	    name: 'UpdateDate'
	},
	{
	    name: 'OperId'
	},
	{
	    name: 'OrgId'
}])
	,
    sortData: function(f, direction) {
        var tempSort = Ext.util.JSON.encode(productGridData.sortInfo);
        if (sortInfor != tempSort) {
            sortInfor = tempSort;
            productGridData.baseParams.SortInfo = sortInfor;
            alert(defaultPageSize);
            productGridData.load({ params: { limit: defaultPageSize, start: 0} });
        }
    },
    listeners:
	{
	    scope: this,
	    load: function() {
	    }
	}
});



        var defaultPageSize = 10;
        var toolBar = new Ext.PagingToolbar({
            pageSize: 10,
            store: productGridData,
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

        var sm = new Ext.grid.CheckboxSelectionModel({
            singleSelect: false
        });
        var productGrid = new Ext.grid.GridPanel({
            el: 'productGrid',
            width: '100%',
            height: '100%',
            //autoWidth:true,
            //autoHeight:true,
            autoScroll: true,
            layout: 'fit',
            id: '',
            store: productGridData,
            loadMask: { msg: '正在加载数据，请稍侯……' },
            sm: sm,
            cm: new Ext.grid.ColumnModel([
		sm,
		new Ext.grid.RowNumberer(), //自动行号
		{
		header: '存货ID',
		dataIndex: 'ProductId',
		id: 'ProductId',
		hidden: true,
		hideable: false
},
		{
		    header: '存货编号',
		    dataIndex: 'ProductNo',
		    id: 'ProductNo',
		    sortable: true,
		    width: 100
		},
		{
		    header: '存货名称',
		    dataIndex: 'ProductName',
		    id: 'ProductName',
		    sortable: true,
		    width: 170
		},
		{
		    header: '助记码',
		    dataIndex: 'MnemonicNo',
		    id: 'MnemonicNo',
		    sortable: true,
		    width: 75
		},
		{
		    header: '产地',
		    dataIndex: 'OriginText',
		    id: 'OriginText',
		    sortable: true,
		    width: 80
		},
		{
		    header: '供应商',
		    dataIndex: 'SupplierText',
		    id: 'SupplierText',
		    sortable: true,
		    width: 150
		},
		{
		    header: '规格',
		    dataIndex: 'SpecificationsText',
		    id: 'SpecificationsText',
		    sortable: true,
		    width: 40
		},
		{
		    header: '换算率',
		    dataIndex: 'UnitConvertRate',
		    id: 'UnitConvertRate',
		    sortable: true,
		    width: 50
		},
		{
		    header: '计量单位',
		    dataIndex: 'UnitText',
		    id: 'UnitText',
		    sortable: true,
		    width: 60
		},
		{
		    header: '销售单价',
		    dataIndex: 'SalePrice',
		    id: 'SalePrice',
		    sortable: true,
		    width: 60
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
            height: 340,
            closeAction: 'hide',
            stripeRows: true,
            loadMask: true//,
            //autoExpandColumn: 2
        });
        
        toolBar.addField(createPrintButton(productGridData, productGrid, ''));
        productGrid.render();

        createSearch(productGrid, productGridData, "searchForm12");
        searchForm.el = "searchForm12";
        searchForm.render();

        var addRow = new fieldRowPattern({
            id: 'ProductType',
            name: '存货类别',
            dataType: 'select'
        });
        fieldStore.add(addRow);

        txtFieldValue.on("focus", selectProductType);

        function selectProductType() {
            if (cmbField.getValue() != "ProductType")
                return;
            if (selectProductForm == null) {
                //parentUrl = "../../CRM/product/frmBaProductClass.aspx?select=true&method=getbaproducttree";
                showProductForm("", "", "", true);
                selectProductForm.buttons[0].on("click", selectProductOk);
            }
            else {
                showProductForm("", "", "", true);
            }
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
            txtFieldValue.setValue(selectProductNames);
        }

        this.getSelectedValue = function() {
            return selectedProductIds;
        }

        loadData();
    })

    function loadData() {
        productGridData.baseParams.action = action;
        productGridData.baseParams.SuppliersId = suppliersId;
        productGridData.load({ params: { limit: defaultPageSize, start: 0} });
    }
function getCmbStore(columnName) {

}
</script>
</html>
