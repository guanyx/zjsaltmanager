<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmAccountUnitDrawStat.aspx.cs" Inherits="RPT_SCM_frmAccountUnitDrawStat" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">


<html>
<head>
    <title>核算单位配送查询</title>
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
    
    
//var dateTypeStore = new Ext.data.SimpleStore({
//   fields: ['id', 'name'],        
//   data : [
//   ['1', '按年'],
//   ['2', '按季度'],
//   ['3', '按月度'],
//   ['4', '按天'] 
//]});

//var yearStore = new Ext.data.SimpleStore({
//   fields: ['id', 'name'],        
//   data : [        
//   ['1', '一月']
//   ]});
//var yearRowPatter = Ext.data.Record.create([
//           { name: 'id', type: 'string' },
//           { name: 'name', type: 'string' }
//          ]);
//yearStore.removeAll();
//var currentYear = (new Date()).getFullYear();
//currentYear = parseInt(currentYear)+1;
//for(var i=2009;i<currentYear;i++)
//{
//    var year = new yearRowPatter({id:i,name:i});
//    yearStore.add(year);
//}
//   
//var monthStore = new Ext.data.SimpleStore({
//   fields: ['id', 'name'],        
//   data : [        
//   ['1', '一月'],
//   ['2', '二月'],        
//   ['3', '三月'],
//   ['4', '四月'],        
//   ['5', '五月'],
//   ['6', '六月'],        
//   ['7', '七月'],
//   ['8', '八月'],        
//   ['9', '九月'],
//   ['10', '十月'],        
//   ['11', '十一月'],
//   ['12', '十二月'] 
//   ]});

//var quarterlyStore = new Ext.data.SimpleStore({
//   fields: ['id', 'name'],        
//   data : [        
//   ['1', '第一季度'],
//   ['2', '第二季度'],        
//   ['3', '第三季度'],
//   ['4', '第四季度'] 
//   ]});

////var fieldStore = new Ext.data.SimpleStore({
////   fields: ['id', 'name','dataType'],        
////   data : [        
////   ['1', '第一季度',''],
////   ['2', '第二季度',''],        
////   ['3', '第三季度',''],
////   ['3', '第四季度',''] 
////   ]});
//   
//var fieldRowPattern = Ext.data.Record.create([
//           { name: 'id', type: 'string' },
//           { name: 'name', type: 'string' },
//           { name: 'dataType', type: 'string' }
//          ]);
//          
// //时间方式
//var cmbDateType = new Ext.form.ComboBox({
//        id: 'cmbDateType',
//        store: dateTypeStore, // 下拉数据           
//        displayField:'name', //显示上面的fields中的state列的内容,相当于option的text值        
//        valueField: 'id', // 选项的值, 相当于option的value值        
//        name: 'cmbDateType',        
//        mode: 'local', // 必须要,如果为 remote, 则会用ajax获取数据        
//        triggerAction: 'all', // 点击下拉的时候, all 为展出所有Store中data的数据        
//        readOnly: true, // 如果设为true,则好像一般的下拉框一样，默认是false,可输入并自动匹配        
//        emptyText:'请选择比较类型',  
//        width:100,   
//        editable:false,  
//        selectOnFocus:true});

////时间方式
//var cmbYear = new Ext.form.ComboBox({
//        id: 'cmbYear',
//        store: yearStore, // 下拉数据           
//        displayField:'name', //显示上面的fields中的state列的内容,相当于option的text值        
//        valueField: 'id', // 选项的值, 相当于option的value值        
//        name: 'cmbYear',        
//        mode: 'local', // 必须要,如果为 remote, 则会用ajax获取数据        
//        triggerAction: 'all', // 点击下拉的时候, all 为展出所有Store中data的数据        
//        //readOnly: true, // 如果设为true,则好像一般的下拉框一样，默认是false,可输入并自动匹配        
//        emptyText:'请选择年度',   
//        width:100,
//        hidden:true,
//        //editable:false,   
//        selectOnFocus:true});
//        
// //时间方式
//var cmbMonth = new Ext.form.ComboBox({
//        id: 'cmbMonth',
//        store: monthStore, // 下拉数据           
//        displayField:'name', //显示上面的fields中的state列的内容,相当于option的text值        
//        valueField: 'id', // 选项的值, 相当于option的value值        
//        name: 'cmbMonth',        
//        mode: 'local', // 必须要,如果为 remote, 则会用ajax获取数据        
//        triggerAction: 'all', // 点击下拉的时候, all 为展出所有Store中data的数据        
//        readOnly: true, // 如果设为true,则好像一般的下拉框一样，默认是false,可输入并自动匹配        
//        emptyText:'请选择比较类型',   
//        width:100,  
//        hidden:true,
//        editable:false,    
//        selectOnFocus:true});
//        
// //季度方式
//var cmbQuarterly = new Ext.form.ComboBox({
//        id: 'cmbQuarterly',
//        store: quarterlyStore, // 下拉数据           
//        displayField:'name', //显示上面的fields中的state列的内容,相当于option的text值        
//        valueField: 'id', // 选项的值, 相当于option的value值        
//        name: 'cmbQuarterly',        
//        mode: 'local', // 必须要,如果为 remote, 则会用ajax获取数据        
//        triggerAction: 'all', // 点击下拉的时候, all 为展出所有Store中data的数据        
//        readOnly: true, // 如果设为true,则好像一般的下拉框一样，默认是false,可输入并自动匹配        
//        emptyText:'请选择比较类型',   
//        width:100,
//        hidden:true,
//        editable:false,      
//        selectOnFocus:true});
//var startDate = new Ext.form.DateField({id:'startDate',name:'startDate',format:'Y-m-d',value:new Date().clearTime(),hidden:true});
//var endDate = new Ext.form.DateField({id:'endDate',name:'endDate',format:'Y-m-d',value:new Date().clearTime(),hidden:true});
//var btnFliter = new Ext.Button({text:'查询'});
//cmbDateType.on("select",dataTypeChange);
//function dataTypeChange()
//{
//    switch(cmbDateType.getValue())
//    {
//        //普通
//        case "4":
//            //cmbDateType.setVisible(true);
//            startDate.setVisible(true);
//            endDate.setVisible(true);
//            cmbMonth.setVisible(false);
//            cmbQuarterly.setVisible(false);
//            cmbYear.setVisible(false);
//            break;
//        //按年度
//        case "1":
//            //cmbDateType.setVisible(true);
//            startDate.setVisible(false);
//            endDate.setVisible(false);
//            cmbMonth.setVisible(false);
//            cmbQuarterly.setVisible(false);
//             cmbYear.setVisible(true);
//            break;
//         //按季度
//        case "2":
//            startDate.setVisible(false);
//            endDate.setVisible(false);
//            cmbMonth.setVisible(false);
//            cmbQuarterly.setVisible(true);
//             cmbYear.setVisible(true);
//            break;
//            //按月度
//         case "3":
//            startDate.setVisible(false);
//            endDate.setVisible(false);
//            cmbMonth.setVisible(true);
//            cmbQuarterly.setVisible(false);
//             cmbYear.setVisible(true);
//            break;
//    }
//}
//btnFliter.on("click",btnFilterClick);
//function btnFilterClick()
//{
//    var strStartDate = '';
//    var strEndDate='';
//    if(!cmbYear.hidden)
//    {
//        strStartDate = cmbYear.getValue()+"-01-01";
//        strEndDate =  (parseInt(cmbYear.getValue())+1)+"-01-01";
//    }
//    //月度可见
//    if(!cmbMonth.hidden)
//    {
//       strStartDate = cmbYear.getValue()+"-"+cmbMonth.getValue()+"-01";
//       strEndDate =  cmbYear.getValue()+"-"+(parseInt(cmbMonth.getValue())+1)+"-01";
//    }
//    //季度可见
//    if(!cmbQuarterly.hidden)
//    {
//        var jd = parseInt(cmbQuarterly.getValue());
//        strStartDate = cmbYear.getValue()+"-"+(1+(jd-1)*3)+"-01";
//        if(jd==4)
//        {
//            strEndDate =  (parseInt(cmbYear.getValue())+1)+"-01-01";
//        }
//        else
//        {
//            strEndDate =  cmbYear.getValue()+"-"+(jd*3+1)+"-01";
//        }
//    }
//    //普通模式
//    if(!startDate.hidden)
//    {
//        strStartDate = document.getElementById("startDate").value;//.getText();
//        strEndDate = document.getElementById("endDate").value;
//    }
//    //alert( strStartDate +":"+strEndDate);
//    gridStore.baseParams.OrgId = selectOrgIds;  //ArriveOrgPostPanel.getValue();
//   gridStore.baseParams.StartDate=strStartDate;
//   gridStore.baseParams.EndDate=strEndDate;
//   gridStore.baseParams.limit=10000000;
//   gridStore.baseParams.start=0;
//   gridStore.load();
//}
</script>
<script type="text/javascript">
Ext.BLANK_IMAGE_URL = "../../ext3/resources/images/default/s.gif";
var colModel = new Ext.grid.ColumnModel({
	columns: [ 
		new Ext.grid.RowNumberer(),			
		{
			header:'订单编号',
			dataIndex:'OrderId',
			id:'OrderId',
			tooltip:'订单编号',			
			summaryType:'count',
            summaryRenderer: function(v, params, data){
                return '共(' + v +')条订单';
            }
		},
		{
		    header:'客户编号',
			dataIndex:'CustomerNo',
			id:'CustomerNo',
			tooltip:'客户编号'
		},
		{
			header:'客户名称',
			dataIndex:'CustomerName',
			id:'CustomerName',
			tooltip:'客户名称'
		},
		{
			header:'配送类型',
			dataIndex:'DlvTypeName',
			id:'DlvTypeName',
			tooltip:'配送类型'
		},
		{
		    header:'订单金额',
			dataIndex:'SaleTotalAmt',
			id:'SaleTotalAmt',
			tooltip:'订单金额',			
			renderer:function(v){
			    return Number(v).toFixed(2)+'元'; //保留2位 
			},
			summaryType:'sum',
            summaryRenderer: function(v, params, data){
                return Number(v).toFixed(2)+' 元'; //保留2位 
            }
		},
		{
		    header:'下单人',
			dataIndex:'OperName',
			id:'OperName',
			tooltip:'下单人'
		}
        ]
});
/*--------------serach--------------*/
/*--------------线路信息------------*/
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
//    { items: ArriveOrgText },
//    {items:{
//                       xtype: 'button',
//                       iconCls: "find",
//                       autoWidth: true,
//                       autoHeight: true,
//                       hideLabel: true,
//                       listeners: {
//                           click: function(v) {
//                               selectOrgType();
//                           }
//                       }
//}},
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
    url: 'frmAccountUnitDrawStat.aspx?method=getlist',
     reader :new Ext.data.JsonReader({
    totalProperty: 'totalProperty',
    root: 'root',
    fields: [
	{		name:'OrderId'	},
	{		name:'CustomerNo'	},
	{		name:'CustomerName'	},
	{		name:'DlvTypeName'	},
	{       name:'SaleTotalAmt',type:'float' },
	{       name:'CreateDate' },
	{       name:'OperName' }
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



    var summary = new Ext.ux.grid.GridSummary();
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
        height: 400,
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
        plugins: summary,
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
    addRow = new fieldRowPattern({
        id: 'CreateDate',
        name: '订单时间',
        dataType: 'date'
    });
    fieldStore.add(addRow);
    addRow = new fieldRowPattern({
        id: 'RouteId',
        name: '线路信息',
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
    //ArriveOrgPostPanel.setValue(<% =ZJSIG.UIProcess.ADM.UIAdmUser.OrgID(this)%>);
    //ArriveOrgPostPanel.setDisabled(true);

})
</script>

</html>
