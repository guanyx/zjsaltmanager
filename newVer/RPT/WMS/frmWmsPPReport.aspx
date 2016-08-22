<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmWmsPPReport.aspx.cs" Inherits="RPT_WMS_frmWmsPPReport" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html>
<head>
    <title>采购收货查询</title>
    <link rel="stylesheet" type="text/css" href="../../ext3/resources/css/ext-all.css" />
    <script type="text/javascript" src="../../ext3/adapter/ext/ext-base.js"></script>
    <script type="text/javascript" src="../../ext3/ext-all.js"></script>
    <script type="text/javascript" src="../../ext3/example/ItemDeleter.js"></script>
    <!--link rel="stylesheet" type="text/css" href="../../css/GroupHeaderPlugin.css" /-->
    <script type="text/javascript" src="../../js/floatUtil.js"></script>
    <!--script type="text/javascript" src="../../js/GroupHeaderPlugin.js"></script-->
    <link rel="stylesheet" href="../../css/Ext.ux.grid.GridSummary.css" />
    <!--script type="text/javascript" src="../../js/FilterControl.js"></script-->
    <script type="text/javascript" src='../../js/Ext.ux.grid.GridSummary.js'></script>
    <link rel="stylesheet" type="text/css" href="../../ext3/example/GroupSummary.css" />
    <script type="text/javascript" src="../../ext3/example/GroupSummary.js"></script>
    <script type="text/javascript" src="../../js/operateResp.js"></script>
    <script type="text/javascript" src="../../ext3/src/locale/ext-lang-zh_CN.js"></script>
    <script type="text/javascript" src="../../js/OrgsSelect.js"></script>
    <script type="text/javascript" src="../../js/FilterControl.js"></script>
    <script type="text/javascript" src="../../js/GroupFieldSelect.js"></script>
     <script type="text/javascript" src="../../js/ProductSelect.js"></script>
</head>
<body> 
<div id='toolbar'></div>
<div id='searchForm'></div>
<div id='gird'></div>
<div id='searchGrid'></div>
</body>
<%=getComboBoxStore( )%>
<script type="text/javascript">
Ext.BLANK_IMAGE_URL = "../../ext3/resources/images/default/s.gif";
var colModel = new Ext.grid.ColumnModel({
	columns: [
		new Ext.grid.RowNumberer(),
		 {
		     header: '进货单号',
		     dataIndex: 'OrderNumber',
		     id: 'OrderNumber',
		     tooltip: '进货单号'
		 },
		{
		    header: '发货单位',
		    dataIndex: 'SupplierName',
		    id: 'SupplierName',
		    tooltip: '发货单位'
		},		
		{
			header:'产品编号',
			dataIndex:'ProductCode',
			id: 'ProductCode',
			tooltip:'产品编号'
		},
		{
		    header:'产品名称',
			dataIndex:'ProductName',
			id: 'ProductName',
			tooltip:'产品名称'
		},
		
		
		{
			header:'车船号',
			dataIndex: 'CarBoatNo',
			id: 'CarBoatNo',
			tooltip: '车船号'

        },
		{
		    header: '发运数量',
		    dataIndex: 'BookQty',
		    id: 'BookQty',
		    tooltip: '发运数量'
		},
		{
		    header: '实收数量',
		    dataIndex: 'RealQty',
		    id: 'RealQty',
		    tooltip: '实收数量'
		},
		{
			header:'发运时间',
			dataIndex: 'CreateDate',
			id: 'CreateDate',
			renderer: Ext.util.Format.dateRenderer('Y年m月d日'),
			tooltip: '发运时间'
		},
		{
			header:'状态',
			dataIndex: 'BillStatus',
			id: 'BillStatus',
			renderer: function(v){if(v==0)return '待入库';else return '已入库'},
			tooltip: '发运时间'
		},
		
		{
		    header:'ID',
			dataIndex:'ProductId',
			id:'ProductId',
			tooltip:'',
			hidden:true,
			hideable:false
		}
        ]
});
/*--------------serach--------------*/
//var ArriveOrgPostPanel = new Ext.form.ComboBox({
//    style: 'margin-left:0px',
//    cls: 'key',
//    xtype: 'combo',
//    fieldLabel: '公司',
//    name: 'nameOrg',
//    anchor: '95%',
//    store: dsOrgListInfo,
//    mode: 'local',
//    displayField: 'OrgName',
//    valueField: 'OrgId',
//    triggerAction: 'all',
//    editable: false,
//    value: dsOrgListInfo.getAt(0).data.OrgId
//});

//var ArriveWhPostPanel = new Ext.form.ComboBox({
//        style: 'margin-left:0px',
//        cls: 'key',
//        xtype: 'combo',
//        fieldLabel: '仓库',
//        name: 'nameCust',
//        anchor: '95%',
//        store:dsWarehouseList,
//        mode:'local',
//        displayField:'WhName',
//        valueField:'WhId',
//        triggerAction:'all',
//        editable:false,
//        value:dsWarehouseList.getAt(0).data.WhId
//    });
//    var ArriveCarBoatNoPostPanel = new Ext.form.TextField({
//        style: 'margin-left:0px',
//        cls: 'key',
//        xtype: 'textfield',
//        fieldLabel: '车船号',
//        name: 'nameCarBoatNo',
//        anchor: '95%',
//        triggerAction: 'all',
//        editable: true
//    });
//    var ArriveOrderIdPostPanel = new Ext.form.TextField({
//        style: 'margin-left:0px',
//        cls: 'key',
//        xtype: 'textfield',
//        fieldLabel: '发运单号',
//        name: 'nameOrderId',
//        anchor: '95%',
//        triggerAction: 'all',
//        editable: true
//    });
//    //开始日期
//    var beginStartDatePanel = new Ext.form.DateField({
//        xtype:'datefield',
//        fieldLabel:'开始日期',
//        anchor:'95%',
//        format: 'Y年m月d日',  //添加中文样式
//        value:new Date().getFirstDateOfMonth().clearTime() 
//    });

//    //结束日期
//    var beginEndDatePanel = new Ext.form.DateField({
//        xtype:'datefield',
//        fieldLabel:'结束日期',
//        anchor:'95%',
//        format: 'Y年m月d日',  //添加中文样式
//        value:new Date().clearTime()
//    });

//    var serchform = new Ext.FormPanel({
//        renderTo: 'searchForm',
//        labelAlign: 'left',
//        // layout:'fit',
//        buttonAlign: 'right',
//        bodyStyle: 'padding:5px',
//        frame: true,
//        labelWidth: 55,
//        items: [
//        {
//            layout: 'column',   //定义该元素为布局为列布局方式
//            border: false,
//            items: [{
//                columnWidth: .3,  //该列占用的宽度，标识为20％
//                layout: 'form',
//                border: false,
//                items: [
//                    ArriveOrderIdPostPanel
//                ]
//            }, {
//                columnWidth: .3,
//                layout: 'form',
//                border: false,
//                items: [
//                    ArriveCarBoatNoPostPanel
//                    ]

//}]
//            },
//    {
//        layout: 'column',   //定义该元素为布局为列布局方式
//        border: false,
//        items: [{
//            columnWidth: .3,  //该列占用的宽度，标识为20％
//            layout: 'form',
//            border: false,
//            items: [
//                    ArriveOrgPostPanel
//                ]
//        }, {
//            columnWidth: .3,
//            layout: 'form',
//            border: false,
//            items: [
//                    ArriveWhPostPanel
//                    ]

//}]
//        },

//    {
//        layout: 'column',   //定义该元素为布局为列布局方式
//        border: false,
//        items: [{
//            columnWidth: .3,  //该列占用的宽度，标识为20％
//            layout: 'form',
//            border: false,
//            items: [
//                    beginStartDatePanel
//                ]
//        }, {
//            columnWidth: .3,
//            layout: 'form',
//            border: false,
//            items: [
//                    beginEndDatePanel
//                    ]
//        }, {
//            columnWidth: .2,
//            layout: 'form',
//            border: false,
//            items: [{ cls: 'key',
//                xtype: 'button',
//                text: '查询',
//                anchor: '50%',
//                handler: function() {

//                    var whId = ArriveWhPostPanel.getValue();
//                    var orgId = ArriveOrgPostPanel.getValue();
//                    var beginStartDate = beginStartDatePanel.getValue();
//                    var beginEndDate = beginEndDatePanel.getValue();
//                    var orderId = ArriveOrderIdPostPanel.getValue();
//                    var carBoatNo = ArriveCarBoatNoPostPanel.getValue();

//                    gridStore.baseParams.StartDate = Ext.util.Format.date(beginStartDate, 'Y/m/d');
//                    gridStore.baseParams.EndDate = Ext.util.Format.date(beginEndDate, 'Y/m/d');

//                    gridStore.baseParams.whId = whId;
//                    gridStore.baseParams.orgId = orgId;

//                    gridStore.baseParams.orderId = orderId;
//                    gridStore.baseParams.carBoatNo = carBoatNo;

//                    gridStore.load();
//                }
//}]
//}]
//}]
//        });

/*----------------------------*/

    var gridStore = new Ext.data.Store({
        url: 'frmWmsPPReport.aspx?method=getlist',
        reader: new Ext.data.JsonReader({
            totalProperty: 'totalProperty',
            root: 'root',
            fields: [
    { name: 'OrderId' },
    {name:'OrderNumber'},
    { name: 'SupplierId' },
    { name: 'SupplierName' },
	{ name: 'ProductId' },
	{ name: 'ProductCode' },
	{ name: 'ProductName' },
	{ name: 'CarBoatNo' },
	{ name: 'BookQty',type:'float' },
	{ name: 'RealQty', type: 'float' },
	{ name: 'CreateDate', type: 'date' }
	]
        })
    });

</script>
<script type="text/javascript">

 function getCmbStore(columnName)
{
    switch(columnName)
    {
        case "BillStatus":
            var dsBillStatus = new Ext.data.SimpleStore({ 
                fields:['id','name'],
                data:[[0,'待入库'],[1,'已入库']],
                autoLoad: false});
            return dsBillStatus;
            break;
        default:
            return null;
    }
}
    
Ext.onReady(function(){

/*------实现toolbar的函数 start---------------*/
var Toolbar = new Ext.Toolbar({
    renderTo: 'toolbar',
    region: "north",
    height: 25
});

/**************************选择信息*****************************/
var selectOrgIds = orgId;
function selectOrgType() {

    if (selectOrgForm == null) {
        var showType = "getcurrentandchildrentree";
        if (orgId == 1) {
            showType = "getcurrentAndChildrenTreeByArea";
        }
        showOrgForm("", "", "../../ba/sysadmin/frmAdmOrgList.aspx?method=" + showType);
        selectOrgForm.buttons[0].on("click", selectOrgOk);
        //            if (orgId == 1) {
        //                selectOrgTree.on('checkchange', treeCheckChange, selectOrgTree);
        //            }
        selectOrgTree.on('checkchange', treeCheckChange, selectOrgTree);
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
    currentSelect.setValue(selectOrgNames);
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
    store: gridStore,
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

var sm = new Ext.grid.CheckboxSelectionModel({
            singleSelect: true
});
//合计项
var viewGrid = new Ext.grid.EditorGridPanel({
    renderTo:"gird",                
    id: 'viewGrid',
    //region:'center',
    split:true,
    store: gridStore ,
    autoscroll:true,
    height:300,
    width:'100%',
    title:'',
    loadMask: { msg: '正在加载数据，请稍侯……' },
    sm: sm,
    cm: colModel,
    bbar:toolBar,
    viewConfig: {
        columnsText: '显示的列',
        scrollOffset: 20,
        sortAscText: '升序',
        sortDescText: '降序',
        forceFit: true
    },
    loadMask: true,
    closeAction: 'hide',
    stripeRows: true
});

createSearch(viewGrid, gridStore, "searchForm");
searchForm.el = "searchForm";
searchForm.render();

var addRow = new fieldRowPattern({
    id: 'OrgId',
    name: '公司',
    dataType: 'select'
});
fieldStore.insert(0, addRow);

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
                parentUrl = "../../CRM/product/frmBaProductClass.aspx?select=true&method=getbaproducttree";
                showProductForm("", "", "", true);
                selectProductForm.buttons[0].on("click", selectProductOk);
            }
            else {
                showProductForm("", "", "", true);
            }
            break;
        case "RouteId":
            selectRoute();
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
        case "RouteId":
            value = selectedRouteIds;
            break;
        case "OrgId":
            value = selectOrgIds;
        default:
            break;
    }
    return value;
}

_grid = viewGrid;

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


})
</script>
</html>