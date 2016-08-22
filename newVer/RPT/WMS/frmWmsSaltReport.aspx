<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmWmsSaltReport.aspx.cs" Inherits="RPT_WMS_frmWmsSaltReport" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html>
<head>
    <title>销售出库查询</title>
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
    <script type="text/javascript" src="../../js/getExcelXml.js"></script>
    <script type="text/javascript" src="../../js/ExtJsHelper.js"></script>
    <script type="text/javascript" src="../../js/operateResp.js"></script>
    <script type="text/javascript" src="../../ext3/src/locale/ext-lang-zh_CN.js"></script>
    <script type="text/javascript" src="../../js/FilterControl.js"></script>
    <script type="text/javascript" src="../../js/GroupFieldSelect.js"></script>
     <script type="text/javascript" src="../../js/ProductSelect.js"></script>
     <script type="text/javascript" src="../../js/OrgsSelect.js"></script>
</head>
<body> 
<div id='toolbar'></div>
<div id='searchForm'></div>
<div id='searchForm12'></div>
<div id='gird'></div>
<div id='searchGrid'></div>

</body>
<%=getComboBoxStore( )%>
<script type="text/javascript">
    Ext.BLANK_IMAGE_URL = "../../ext3/resources/images/default/s.gif";
    parentUrl = "../../CRM/product/frmBaProductClass.aspx?method=getbaproducttypetree";
var colModel = new Ext.grid.ColumnModel({
	columns: [
		new Ext.grid.RowNumberer({header:'序号',width:34}),
		 {
		     header: '发运单编号',
		     dataIndex: 'DrawInvId',
		     id: 'OrderId',
		     tooltip: '发运单编号'
		 },
		{
		    header: '客户编号',
		    dataIndex: 'CustomerNo',
		    id: 'CustomerNo',
		    tooltip: '客户编号'
		},	
		{
		    header: '客户名称',
		    dataIndex: 'CustomerName',
		    id: 'CustomerName',
		    tooltip: '客户名称'
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
			header:'配送类型',
			dataIndex: 'DrawName',
			id: 'DrawName',
			tooltip: '配送类型'

        },
		{
		    header: '数量',
		    dataIndex: 'RealQty',
		    id: 'RealQty',
		    tooltip: '数量'
		},
		{
			header:'送货时间',
			dataIndex: 'SendDate',
			id: 'SendDate',
			renderer: Ext.util.Format.dateRenderer('Y年m月d日'),
			tooltip: '送货时间'
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

var routetree = null;
var routediv = null;
var routeSelectWin = null;
var selectedRouteIds = '';
function selectRoute() {
    if (routediv == null) {
        routediv = document.createElement('div');
        routediv.setAttribute('id', 'routetreeDiv');
        Ext.getBody().appendChild(routediv);
    }
    var Tree = Ext.tree;
    if (routetree == null) {
        routetree = new Tree.TreePanel({
            el: 'routetreeDiv',
            style: 'margin-left:0px',
            useArrows: true, //是否使用箭头
            autoScroll: true,
            animate: true,
            width: '150',
            height: '100%',
            minSize: 150,
            maxSize: 180,
            enableDD: false,
            frame: true,
            border: false,
            containerScroll: true,
            loader: new Tree.TreeLoader({
                dataUrl: '/crm/DefaultFind.aspx?ShowCheckBox=true&method=getLineTreeByOrg&OrgId=<% =ZJSIG.UIProcess.ADM.UIAdmUser.OrgID(this)%>'
            })
        });
//        routetree.on('click', function(node) {
//            if (node.id == 0)//||!node.isLeaf()
//                return;
//            selectedRouteIds = node.id;
//            currentSelect.setValue(node.text);
//            routeSelectWin.hide();
//        });
        // set the root node
        var root = new Tree.AsyncTreeNode({
            text: '线路情况',
            draggable: false,
            id: '0'
        });
        routetree.setRootNode(root);
    }
    if (routeSelectWin == null) {
        routeSelectWin = new Ext.Window({
            title: '线路信息',
            style: 'margin-left:0px',
            width: 500,
            height: 300,
            constrain: true,
            layout: 'fit',
            plain: true,
            modal: true,
            closeAction: 'hide',
            autoDestroy: true,
            resizable: true,
            items: [routetree]
            , buttons: [{
		        text: "确定"
		        ,id:'btnYes'
			    , handler: function() {
			        routeSelectWin.hide();
			        selectRouteOk();
			    }
			, scope: this
		    },
		    {
		        text: "取消"
			    , handler: function() {
			        routeSelectWin.hide();
			    }
			    , scope: this
            }]
        });
        routetree.root.reload();
    }
    routeSelectWin.show();
}
function selectRouteOk() {
    var selectRouteNames = "";
    selectedRouteIds = "";
    var selectNodes = routetree.getChecked();
    for (var i = 0; i < selectNodes.length; i++) {
        if (selectNodes[i].id.indexOf("A") != -1)
            continue;
        if (selectRouteNames != "") {
            selectRouteNames += ",";
            selectedRouteIds += ",";
        }
        selectedRouteIds += selectNodes[i].id;
        selectRouteNames += selectNodes[i].text;

    }
    currentSelect.setValue(selectRouteNames);
}
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
//var ArriveDrawTypePostPanel = new Ext.form.ComboBox({
//    style: 'margin-left:0px',
//    cls: 'key',
//    xtype: 'combo',
//    fieldLabel: '配送类型',
//    name: 'nameDraw',
//    anchor: '95%',
//    store: dsDrawListInfo,
//    mode: 'local',
//    displayField: 'DicsName',
//    valueField: 'DicsCode',
//    triggerAction: 'all',
//    editable: false,
//    value: dsDrawListInfo.getAt(0).data.DicsCode
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
//    var ArriveCusotmerPostPanel = new Ext.form.TextField({
//        style: 'margin-left:0px',
//        cls: 'key',
//        xtype: 'textfield',
//        fieldLabel: '客户名称',
//        name: 'nameCustomer',
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
//                    ArriveCusotmerPostPanel
//                    ]


//},{
//                    layout: 'form',
//                    border: false,
//                    labelWidth: 55,
//                    columnWidth: 0.3,
//                    items: [
//		            {
//		                xtype: 'textfield',
//		                fieldLabel: '线路',
//		                anchor: '98%',
//		                name: 'RouteName',
//		                id: 'RouteName',
//		                listeners: {
//		                    blur: function(f) {
//		                        if (f.getValue() == '')
//		                            Ext.getCmp("RouteId").setValue("");
//		                    }
//		                }
//		            }, {
//		                xtype: 'hidden',
//		                name: 'RouteId',
//		                id: 'RouteId',
//		                anchor: '90%'
//		                // maxLength: 1000,  
//		                // allowBlank : true

//}]
//                },
//                {
//                    layout: 'form',
//                    columnWidth: .03,  //该列占用的宽度，标识为20％
//                    border: false,
//                    items: [
//                   {
//                       xtype: 'button',
//                       iconCls: "find",
//                       autoWidth: true,
//                       autoHeight: true,
//                       hideLabel: true,
//                       listeners: {
//                           click: function(v) {
//                               selectRoute();
//                           }
//                       }
//}]
//                }]
//            },
//    {
//        layout: 'column',   //定义该元素为布局为列布局方式
//        border: false,
//        items: [{
//            columnWidth: .3,  //该列占用的宽度，标识为20％
//            layout: 'form',
//            border: false,
//            items: [
//                    ArriveDrawTypePostPanel
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
//                    //var orgId = ArriveOrgPostPanel.getValue();
//                    var beginStartDate = beginStartDatePanel.getValue();
//                    var beginEndDate = beginEndDatePanel.getValue();
//                    var orderId = ArriveOrderIdPostPanel.getValue();
//                    var drawType = ArriveDrawTypePostPanel.getValue();
//                    var customerName = ArriveCusotmerPostPanel.getValue();

//                    gridStore.baseParams.StartDate = Ext.util.Format.date(beginStartDate, 'Y/m/d');
//                    gridStore.baseParams.EndDate = Ext.util.Format.date(beginEndDate, 'Y/m/d');

//                    gridStore.baseParams.whId = whId;
//                    gridStore.baseParams.drawType = drawType;

//                    gridStore.baseParams.orderId = orderId;
//                    gridStore.baseParams.customerName = customerName;

//                    gridStore.load();
//                }
//}]
//}]
//}]
//        });

/*----------------------------*/

    var gridStore = new Ext.data.Store({
        url: 'frmWmsSaltReport.aspx?method=getlist',
        reader: new Ext.data.JsonReader({
            totalProperty: 'totalProperty',
            root: 'root',
            fields: [
    { name: 'DrawInvId' },
    { name: 'CustomerId' },
    { name: 'CustomerNo' },
    { name: 'CustomerName' },
	{ name: 'ProductId' },
	{ name: 'ProductCode' },
	{ name: 'ProductName' },
	{ name: 'DrawType' },
	{ name: 'DrawName' },
	{ name: 'RealQty',type:'float' },
	{ name: 'SendDate',type:'date' }
	]
        })
    });

</script>
<script type="text/javascript">

 function getCmbStore(columnName)
{
    return null;
}

Ext.onReady(function() {

    /*------实现toolbar的函数 start---------------*/
    var Toolbar = new Ext.Toolbar({
        renderTo: 'toolbar',
        region: "north",
        height: 25
    });

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
        renderTo: "gird",
        id: 'viewGrid',
        //region:'center',
        split: true,
        store: gridStore,
        autoscroll: true,
        height: 350,
        width: '100%',
        title: '',
        loadMask: { msg: '正在加载数据，请稍侯……' },
        sm: sm,
        cm: colModel,
        bbar: toolBar,
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



    createSearch(viewGrid, gridStore, "searchForm12");
    searchForm.el = "searchForm12";
    searchForm.render();

    var addRow = new fieldRowPattern({
        id: 'OrgId',
        name: '公司',
        dataType: 'select'
    });
    fieldStore.insert(0, addRow);
    addRow = new fieldRowPattern({
        id: 'RouteId',
        name: '线路信息',
        dataType: 'select'
    });
    fieldStore.add(addRow);

    addRow = new fieldRowPattern({
        id: 'ProductType',
        name: '存货类别',
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