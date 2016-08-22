<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmWmsRSDReport.aspx.cs" Inherits="RPT_WMS_frmWmsRSDReport" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html>
<head>
    <title>仓库收发存报表</title>
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
    <script type="text/javascript" src="../../js/ProductSelect.js"></script>
</head>
<body> 
<div id='searchForm'></div>
<div id='gird'></div>
</body>
<%=getComboBoxStore( )%>
<script type="text/javascript">
Ext.BLANK_IMAGE_URL = "../../ext3/resources/images/default/s.gif";
var colModel = new Ext.grid.ColumnModel({
	columns: [
		new Ext.grid.RowNumberer(),
		 {
		     header: '开始时间',
		     dataIndex: 'StartDate',
		     id: 'StartDate',
		     tooltip: '开始时间',
		     width: 60
		 },
		{
		    header: '结束时间',
		    dataIndex: 'EndDate',
		    id: 'EndDate',
		    tooltip: '结束时间',
		    width: 60
		},
		{
		    header: '仓库',
		    dataIndex: 'WhName',
		    id: 'WhName',
		    tooltip: '仓库',
		    width: 50
		},	
		{
			header:'产品编号',
			dataIndex:'ProductNo',
			id: 'ProductNo',
			tooltip: '产品编号',
			width: 40
		},
		{
		    header:'产品名称',
			dataIndex:'ProductName',
			id: 'ProductName',
			tooltip: '产品名称',
			width: 80
		},
		{
			header:'规格',
			dataIndex: 'SpecificationsText',
			id: 'SpecificationsText',
			tooltip: '规格',
			width: 30
		},
		{
			header:'单位',
			dataIndex:'UnitText',
			id: 'UnitText',
			tooltip: '单位',
			width: 30
		},
	   
		
		{
			header:'期初数量',
			dataIndex: 'LastDayStock',
			id: 'LastDayStock',
			tooltip: '期初数量',
			width: 40
        },
		{
		    header: '收入数量',
		    dataIndex: 'IncomeQty',
		    id: 'IncomeQty',
		    tooltip: '收入数量',
		    width: 30
		},
		{
		    header: '支出数量',
		    dataIndex: 'ExpenditureQty',
		    id: 'ExpenditureQty',
		    tooltip: '支出数量',
		    width: 30
		},
		{
			header:'期末数量',
			dataIndex: 'TheDayStock',
			id: 'TheDayStock',
			tooltip: '期末数量',
			width: 40
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

var selectOrgIds = orgId;
var arriveOrgText = new Ext.form.TextField({
    fieldLabel: '公司',
    id: 'orgSelect',
    value: orgName,
    anchor: '95%',
    style: 'margin-left:0px',
    disabled: true
});

currentSelect = arriveOrgText;
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


/*--------------serach--------------*/

var ArriveProductPostPanel = new Ext.form.TextField({
    style: 'margin-left:0px',
    cls: 'key',
    fieldLabel: '商品',
    name: 'nameCust',
    anchor: '95%',
    style: 'margin-left:0px',
    disabled: true
    //value: dsProductList.getAt(0).data.ProductId
});

function selectProductType() {
    selectShow("ProductType");
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
    ArriveProductPostPanel.setValue(selectProductNames);
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
    }
}


var dsWareHouse;
if (dsWareHouse == null) { //防止重复加载
    dsWareHouse = new Ext.data.JsonStore({
        totalProperty: "result",
        root: "root",
        url: '../../scm/frmOrderStatistics.aspx?method=getWhSimple',
        fields: ['WhId', 'WhName']
    });
    dsWareHouse.load();
};

function wareHouseLoad() {
    if (selectOrgIds == '')
        selectOrgIds = orgId;
    if (dsWareHouse.baseParams.OrgId != selectOrgIds) {
        dsWareHouse.baseParams.OrgId = selectOrgIds;
        dsWareHouse.baseParams.ForBusi = 1;
        dsWareHouse.load({callback:function(v){ArriveWhPostPanel.setValue(-1)}});
    }
}

var ArriveWhPostPanel = new Ext.form.ComboBox({
        style: 'margin-left:0px',
        cls: 'key',
        xtype: 'combo',
        fieldLabel: '仓库',
        name: 'nameCust',
        anchor: '95%',
        store: dsWareHouse,
        mode:'local',
        displayField:'WhName',
        valueField:'WhId',
        triggerAction:'all',
        editable:false
        
    });
    wareHouseLoad();
//    var ArriveProductPostPanel = new Ext.form.ComboBox({
//        style: 'margin-left:0px',
//        cls: 'key',
//        xtype: 'combo',
//        fieldLabel: '商品',
//        name: 'nameCust',
//        anchor: '95%',
//        store: dsProductList,
//        emptyText: '全部商品',
//        mode: 'local',
//        displayField: 'ProductName',
//        valueField: 'ProductId',
//        triggerAction: 'all',
//        editable: false//,
//        //value: dsProductList.getAt(0).data.ProductId
//    });
    //开始日期
    var beginStartDatePanel = new Ext.form.DateField({
        xtype:'datefield',
        fieldLabel:'开始日期',
        anchor:'95%',
        format: 'Y年m月d日',  //添加中文样式
        value:new Date().getFirstDateOfMonth().clearTime() 
    });

    //结束日期
    var beginEndDatePanel = new Ext.form.DateField({
        xtype:'datefield',
        fieldLabel:'结束日期',
        anchor:'95%',
        format: 'Y年m月d日',  //添加中文样式
        value:new Date().clearTime()
    });

    var serchform = new Ext.FormPanel({
        renderTo: 'searchForm',
        labelAlign: 'left',
        // layout:'fit',
        buttonAlign: 'right',
        bodyStyle: 'padding:5px',
        frame: true,
        labelWidth: 60,
        items: [
    {
        layout: 'column',   //定义该元素为布局为列布局方式
        border: false,
        items: [{
            columnWidth: .3,  //该列占用的宽度，标识为20％
            layout: 'form',
            border: false,
            items: [
                    arriveOrgText
                ]
        }, {
            layout: 'form',
            columnWidth: .03,  //该列占用的宽度，标识为20％
            border: false,
            items: [
                   {
                       xtype: 'button',
                       iconCls: "find",
                       autoWidth: true,
                       autoHeight: true,
                       hideLabel: true,
                       listeners: {
                           click: function(v) {
                               selectOrgType();
                           }
                       }
}]
        }, {
            columnWidth: .3,  //该列占用的宽度，标识为20％
            layout: 'form',
            border: false,
            items: [
                    ArriveWhPostPanel
                ]
        }, {
            columnWidth: .3,
            layout: 'form',
            border: false,
            items: [
                    ArriveProductPostPanel
                    ]

        }, {
            layout: 'form',
            columnWidth: .03,  //该列占用的宽度，标识为20％
            border: false,
            items: [
                   {
                       xtype: 'button',
                       iconCls: "find",
                       autoWidth: true,
                       autoHeight: true,
                       hideLabel: true,
                       listeners: {
                           click: function(v) {
                               selectProductType();
                           }
                       }
}]
}]
        },

    {
        layout: 'column',   //定义该元素为布局为列布局方式
        border: false,
        items: [{
            columnWidth: .3,  //该列占用的宽度，标识为20％
            layout: 'form',
            border: false,
            items: [
                    beginStartDatePanel
                ]
        }, {
            columnWidth: .3,
            layout: 'form',
            border: false,
            items: [
                    beginEndDatePanel
                    ]
        }, {
            columnWidth: .25,
            layout: 'form',
            border: false,
            items: [
                    {
                    cls: 'key',
                    xtype: 'combo',
                    fieldLabel: '显示单位 ',
                    name: 'UnitTypeCombo',
                    id: 'UnitTypeCombo',
                    store: [[0,'库存单位'],[1,'销售单位']],
                    mode: 'local',
                    triggerAction: 'all',
                    editable: false,
                    anchor: '95%',
                    value: 0
                    // maxLength: 1000,  
                    // allowBlank : true
                }
                    ]
        },{
            columnWidth: .15,
            layout: 'form',
            border: false,
            items: [{ cls: 'key',
                xtype: 'button',
                text: '查询',
                anchor: '70%',
                handler: function() {
                    var orgId = <%=ZJSIG.UIProcess.ADM.UIAdmUser.OrgID(this) %>
                    var whId = ArriveWhPostPanel.getValue();
                    var productId = ArriveProductPostPanel.getValue();
                    var beginStartDate = beginStartDatePanel.getValue();
                    var beginEndDate = beginEndDatePanel.getValue();
                    var unitType = Ext.getCmp('UnitTypeCombo').getValue();
                    gridStore.baseParams.StartDate = Ext.util.Format.date(beginStartDate, 'Y/m/d');
                    gridStore.baseParams.EndDate = Ext.util.Format.date(beginEndDate, 'Y/m/d');
                    gridStore.baseParams.orgId = orgId;
                    gridStore.baseParams.UnitType=unitType;
                    if(whId != -1)
                        gridStore.baseParams.whId = whId;
//                    gridStore.baseParams.productId = productId;
                    gridStore.baseParams.filter = "{ColumnName:'ProductType',Compare:'select',ColumnValue:'" + selectedProductIds + "'}";

                    gridStore.load();
                }
}]
}]
}]
    });

/*----------------------------*/

    var gridStore = new Ext.data.Store({
        url: 'frmWmsRSDReport.aspx?method=getlist',
        reader: new Ext.data.JsonReader({
            totalProperty: 'totalProperty',
            root: 'root',
            fields: [
	{ name: 'ProductId' },
	{ name: 'ProductNo' },
	{ name: 'ProductName' },
	{ name: 'SpecificationsText' },
	{ name: 'UnitText' },
	{ name: 'LastDayStock' ,type: 'float'},
	{ name: 'TheDayStock' ,type: 'float'},
	{ name: 'IncomeQty' ,type: 'float'},
	{ name: 'ExpenditureQty' ,type: 'float'},
	{ name: 'WhName' },
	{ name: 'StartDate' },
	{ name: 'EndDate' }
	]
        })
    });

</script>
<script type="text/javascript">

 function getCmbStore(columnName)
{
    return null;
}
    
Ext.onReady(function(){



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
    height:550,
    width:'100%',
    title:'',
    loadMask: { msg: '正在加载数据，请稍侯……' },
    sm: sm,
    cm:colModel,
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

})
</script>
</html>