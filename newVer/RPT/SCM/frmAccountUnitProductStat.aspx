<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmAccountUnitProductStat.aspx.cs" Inherits="RPT_SCM_frmAccountUnitProductStat" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html>
<head>
    <title>核算单位商品查询</title>
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
<div id='toolBar'></div>
<div id='searchForm'></div>
<div id='gird'></div>
<div id='searchGrid'></div>
</body>
<%=getComboBoxStore( ) %>
<script type="text/javascript">
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
                    dataUrl: '/crm/DefaultFind.aspx?method=getLineTreeByOrg&OrgId=<% =ZJSIG.UIProcess.ADM.UIAdmUser.OrgID(this)%>'
                })
            });
            routetree.on('click', function(node) {
                if (node.id == 0)//||!node.isLeaf()
                    return;
                selectedRouteIds = node.id;
                currentSelect.setValue(node.text);
                routeSelectWin.hide();
            });
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
            });
            routetree.root.reload();
        }
        routeSelectWin.show();
    }
</script>
<script type="text/javascript">
Ext.BLANK_IMAGE_URL = "../../ext3/resources/images/default/s.gif";
var colModel = new Ext.grid.ColumnModel({
	columns: [ 
		new Ext.grid.RowNumberer(),			
		{
			header:'产品编号',
			dataIndex:'ProductCode',
			id:'ProductCode',
			tooltip:'产品编号'
		},
		{
		    header:'产品名称',
			dataIndex:'ProductName',
			id:'ProductName',
			tooltip:'产品名称'
		},
		{
			header:'规格',
			dataIndex:'SpecificationsText',
			id:'SpecificationsText',
			tooltip:'规格'
		},
		{
			header:'单位',
			dataIndex:'UnitText',
			id:'UnitText',
			tooltip:'单位'
		},
		{
		    header:'领货数量',
			dataIndex:'DrawQty',
			id:'DrawQty',
			tooltip:''
		},
		{
		    header:'总领货重量',
			dataIndex:'TotalDrawQty',
			id:'TotalDrawQty',
			tooltip:''
		},
		{
		    header:'确认数量',
			dataIndex:'CheckQty',
			id:'CheckQty',
			tooltip:''
		},
		{
		    header:'总确认重量',
			dataIndex:'TotalCheckQty',
			id:'TotalCheckQty',
			tooltip:''
		},
		{
		    header:'总销售额',
			dataIndex:'Amt',
			id:'Amt',
			tooltip:''
		}
        ]
});/*--------------serach--------------*/
//var ArriveOrgPostPanel = new Ext.form.ComboBox({
//        style: 'margin-left:0px',
//        cls: 'key',
//        xtype: 'combo',
//        fieldLabel: '组织',
//        name: 'nameCust',
//        anchor: '95%',
//        store:dsOrgList,
//        mode:'local',
//        displayField:'OrgName',
//        valueField:'OrgId',
//        triggerAction:'all',
//        editable:false,
//        value:dsOrgList.getAt(0).data.OrgId
//    });
//    var ArriveStatusPostPanel = new Ext.form.ComboBox({
//        style: 'margin-left:0px',
//        cls: 'key',
//        xtype: 'combo',
//        fieldLabel: '组织',
//        name: 'nameCust',
//        anchor: '95%',
//        store:dsStatusList,
//        mode:'local',
//        displayField:'Name',
//        valueField:'Id',
//        triggerAction:'all',
//        editable:false,
//        width:80,
//        value:dsOrgList.getAt(0).data.Id
//    });
//    
//var serchform = new Ext.FormPanel({
//    renderTo: 'searchForm',
//    //labelAlign: 'left',
//   // layout:'fit',
//    buttonAlign: 'right',
//    bodyStyle: 'padding:5px',
//    frame: true,
//    layout:'table',     
//    height:70,   
//    layoutConfig:{columns:9},//将父容器分成3列   
//    items:[   
//    {items:ArriveOrgPostPanel},
//    {items:ArriveStatusPostPanel},
//    {items:cmbDateType},   
//    {items:cmbYear},   
//    {items:cmbQuarterly},
//    {items:cmbMonth},
//    {items:startDate},    
//    {items:endDate},
//    {items:btnFliter}
//   ]   
//});

/*----------------------------*/

var gridStore = new Ext.data.Store({
    url: 'frmAccountUnitProductStat.aspx?method=getlist',
     reader :new Ext.data.JsonReader({
    totalProperty: 'totalProperty',
    root: 'root',
    fields: [
	{		name:'ProductId'	},
	{		name:'ProductCode'	},
	{		name:'ProductName'	},
	{		name:'SpecificationsText'	},
	{		name:'UnitText'	},
	{		name:'DrawQty'	},
	{		name:'TotalDrawQty'	},
	{		name:'CheckQty'	},
	{		name:'TotalCheckQty'	},
	{		name:'Amt'	},
	{       name:'SpecificationsText' },
	{       name:'UnitText' }
	]
    })
});

</script>
<script type="text/javascript">

 function getCmbStore(columnName) {
     switch (columnName) {
         case "Status":
             return dsStatusList;
     }
    return null;
}
    
Ext.onReady(function(){
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
    renderTo:"gird",                
    id: 'viewGrid',
    //region:'center',
    split:true,
    store: gridStore ,
    autoscroll:true,
    height:400,
    width:'100%',
    title:'',
    loadMask: { msg: '正在加载数据，请稍侯……' },
    sm: sm,
    cm:colModel,
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

createSearch(viewGrid, gridStore, "searchForm");
    searchForm.el = "searchForm";
    searchForm.render();
    
    btnFilter

    var addRow = new fieldRowPattern({
        id: 'OrgId',
        name: '公司',
        dataType: 'select'
    });
    fieldStore.insert(0, addRow);
    addRow = new fieldRowPattern({
        id: 'CreateDate',
        name: '订单时间',
        dataType: 'date'
    });
    fieldStore.add(addRow);

    addRow = new fieldRowPattern({
        id: 'Status',
        name: '状态',
        dataType: ''
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