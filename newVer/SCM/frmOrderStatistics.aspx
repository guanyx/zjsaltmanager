<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmOrderStatistics.aspx.cs" Inherits="SCM_frmOrderStatistics" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html>
<head>
<title>订单统计</title><meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<link rel="stylesheet" type="text/css" href="../ext3/resources/css/ext-all.css" />
<link rel="stylesheet" type="text/css" href="../Theme/1/css/salt.css" />
<script type="text/javascript" src="../ext3/adapter/ext/ext-base.js"></script>
<script type="text/javascript" src="../ext3/ext-all.js"></script>
<script type="text/javascript" src="../ext3/src/locale/ext-lang-zh_CN.js"></script>
<script type="text/javascript" src="../../js/OrgsSelect.js"></script>
<script type="text/javascript" src="../../js/ExtFix.js"></script>
<script type="text/javascript" src="../../js/RouteSelect.js"></script>
<style type="text/css">
.x-grid-done { 
color:red; 
}
.x-grid-do { 
color:blue; 
}
</style>
</head>
<body>
<div id='divSearchForm'></div>
<div id='divDataGrid'></div>
</body>
<%=getComboBoxStore()%>
<script type="text/javascript">
Ext.BLANK_IMAGE_URL = "../ext3/resources/images/default/s.gif";
Ext.onReady(function() {
    /****************************************************************/
    var dsWareHouse;
    if (dsWareHouse == null) { //防止重复加载
        dsWareHouse = new Ext.data.JsonStore({
            totalProperty: "result",
            root: "root",
            url: 'frmOrderStatistics.aspx?method=getWhSimple',
            fields: ['WhId', 'WhName']
        });
        dsWareHouse.load();
    };
    /****************************************************************/

    var selectOrgIds = orgId;
    var ArriveOrgText = new Ext.form.TextField({
        fieldLabel: '公司',
        id: 'orgSelect',
        value: orgName,
        anchor: '95%',
        style: 'margin-left:0px',
        disabled: true
    });

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
        ArriveOrgText.setValue(selectOrgNames);
        dsWareHouse.load({ params: { OrgId: selectOrgIds, ForBusi: 1} });
    }



    function treeCheckChange(node, checked) {
        node.expand();
        node.attributes.checked = checked;
        node.eachChild(function(child) {
            child.ui.toggleCheck(checked);
            child.attributes.checked = checked;
            child.fireEvent('checkchange', child, checked);
        });
        selectOrgTree.un('checkchange', treeCheckChange, selectOrgTree);
        checkParentNode(node);
        selectOrgTree.on('checkchange', treeCheckChange, selectOrgTree);
    }
    function checkParentNode(currentNode) {
        if (currentNode.parentNode != null) {
            var tempNode = currentNode.parentNode;
            //如果是跟节点，就不做处理了
            if (tempNode.parentNode == null)
                return;
            //如果是选择了，那么父节点也必须是出于选择状态的
            if (currentNode.attributes.checked) {
                if (!tempNode.attributes.checked) {
                    tempNode.fireEvent('checkchange', tempNode, true);
                    tempNode.ui.toggleCheck(true);
                    tempNode.attributes.checked = true;

                }
            }
            //取消选择
            else {
                var tempCheck = false;
                tempNode.eachChild(function(child) {
                    if (child.attributes.checked) {
                        tempCheck = true;
                        return;
                    }
                });
                if (!tempCheck) {
                    tempNode.fireEvent('checkchange', tempNode, false);
                    tempNode.ui.toggleCheck(false);
                    tempNode.attributes.checked = false;
                }

            }
            checkParentNode(tempNode);
        }
    }
    function parentNodeChecked(node) {
        if (node.parentNode != null) {
            if (node.attributes.checked) {
                node.parentNode.ui.toggleCheck(checked);
                node.parentNode.attributes.checked = true;
            }
            else {
                for (var i = 0; i < node.parentNode.childNodes.length; i++) {
                    if (node.parentNode.childNodes[i].attributes.checked) {
                        return;
                    }
                }
            }
            parentNodeChecked(node.parentNode);
        }
    }

    var searchOrderPanel = new Ext.Panel({
        frame: true,
        renderTo: 'divSearchForm',
        buttonAlign: 'center',
        monitorValid: true, // 把有formBind:true的按钮和验证绑定
        items: [
	       {
	           layout: 'column',
	           border: false,
	           items: [
                {
                    layout: 'form',
                    border: false,
                    labelWidth: 55,
                    columnWidth: 0.3,
                    items: [ArriveOrgText
                    //		            {
                    //		                xtype:'combo',
                    //                        fieldLabel:'公司标识',
                    //                        anchor:'98%',
                    //                        name:'OrgName',
                    //                        id:'OrgId',
                    //                        store: dsOrg,
                    //                        displayField: 'OrgName',  //这个字段和业务实体中字段同名
                    //                        valueField: 'OrgId',      //这个字段和业务实体中字段同名
                    //                        typeAhead: true, //自动将第一个搜索到的选项补全输入
                    //                        triggerAction: 'all',
                    //                        emptyValue: '',
                    //                        selectOnFocus: true,
                    //                        forceSelection: true,
                    //                        mode:'local' ,
                    //                        listeners: {
                    //                           select: function(combo, record, index) {
                    ////                                var curOrgId = Ext.getCmp('OrgId').getValue();
                    ////                                dsWareHouse.load({
                    ////                                    params: {
                    ////                                        orgID: curOrgId
                    ////                                    }
                    ////                                });
                    //                            }
                    //                        }  
                    //		            }
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
                }
                , {
                    layout: 'form',
                    border: false,
                    labelWidth: 55,
                    columnWidth: 0.33,
                    items: [
	                {
	                    xtype: 'combo',
	                    store: dsWareHouse, //dsWareHouse,
	                    valueField: 'WhId',
	                    displayField: 'WhName',
	                    mode: 'local',
	                    forceSelection: true,
	                    editable: false,
	                    name: 'OutStor',
	                    id: 'OutStor',
	                    emptyValue: '',
	                    triggerAction: 'all',
	                    fieldLabel: '仓库',
	                    selectOnFocus: true,
	                    anchor: '98%'
}]
                },
		        {
		            layout: 'form',
		            border: false,
		            labelWidth: 55,
		            columnWidth: 0.33,
		            items: [
		            {
		                xtype: 'combo',
		                store: dsDlvType,
		                valueField: 'DicsCode',
		                displayField: 'DicsName',
		                mode: 'local',
		                forceSelection: true,
		                editable: false,
		                emptyValue: '',
		                triggerAction: 'all',
		                fieldLabel: '配送方式',
		                name: 'DlvType',
		                id: 'DlvType',
		                selectOnFocus: true,
		                anchor: '98%'
}]
}]
	       }, {
	           layout: 'column',
	           border: false,
	           items: [
                {
                    layout: 'form',
                    border: false,
                    labelWidth: 55,
                    columnWidth: 0.33,
                    items: [
		            {
		                xtype: 'textfield',
		                fieldLabel: '客户名称',
		                anchor: '98%',
		                name: 'CustomerId',
		                id: 'CustomerId'
}]
                }
                , {
                    layout: 'form',
                    border: false,
                    labelWidth: 55,
                    columnWidth: 0.33,
                    items: [
	                {
	                    xtype: 'textfield',
	                    fieldLabel: '商品名称',
	                    anchor: '98%',
	                    name: 'ProductName',
	                    id: 'ProductName'
}]
                },
                {
                    layout: 'form',
                    border: false,
                    labelWidth: 55,
                    columnWidth: 0.33,
                    items: [
		            {
		                xtype: 'combo',
		                store: dsOrderType,
		                valueField: 'DicsCode',
		                displayField: 'DicsName',
		                mode: 'local',
		                forceSelection: true,
		                editable: false,
		                emptyValue: '',
		                triggerAction: 'all',
		                fieldLabel: '订单类型',
		                name: 'OrderType',
		                id: 'OrderType',
		                selectOnFocus: true,
		                anchor: '98%',
		                editable: false
}]
}]
	       }, {
	           layout: 'column',
	           border: false,
	           items: [
                {
                    layout: 'form',
                    border: false,
                    labelWidth: 55,
                    columnWidth: 0.3,
                    items: [
		            {
		                xtype: 'textfield',
		                fieldLabel: '线路',
		                anchor: '98%',
		                name: 'RouteName',
		                id: 'RouteName',
		                listeners: {
		                    blur: function(f) {
		                        if (f.getValue() == '')
		                            Ext.getCmp("RouteId").setValue("");
		                    }
		                }
		            }, {
		                xtype: 'hidden',
		                name: 'RouteId',
		                id: 'RouteId',
		                anchor: '90%'
		                // maxLength: 1000,  
		                // allowBlank : true

}]
                },
                {
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
                               selectRoute(function(ids,names){                                    
                                    document.getElementById('RouteName').value=names;
                                    document.getElementById('RouteId').value=ids; 
                               });
                           }
                       }
}]
                },
                {
                    layout: 'form',
                    border: false,
                    labelWidth: 55,
                    columnWidth: 0.33,
                    items: [
	                {
	                    xtype: 'datefield',
	                    fieldLabel: '开始日期',
	                    anchor: '98%',
	                    name: 'StartDate',
	                    id: 'StartDate',
	                    format: 'Y年m月d日',
	                    value: new Date().clearTime()
}]
                },
                {
                    layout: 'form',
                    border: false,
                    labelWidth: 55,
                    columnWidth: 0.33,
                    items: [
	                {
	                    xtype: 'datefield',
	                    fieldLabel: '结束时间',
	                    anchor: '98%',
	                    name: 'EndDate',
	                    id: 'EndDate',
	                    format: 'Y年m月d日',
	                    value: new Date().clearTime()
        }]
        }]
        }],
        buttons: [
		    {
		        text: "查询",
		        handler: function() {
		            selectSearchData();
		        },
		        scope: this
		    },
		    {
		        text: "跟踪",
		        handler: function() {
		            trackOrder();
		        },
		        scope: this
            },
		    {
			    text:"导出(Excel)",
	            menu: new Ext.menu.Menu({ 
                    id:   'basicMenu ', 
	                items:[{	    
		                text:"当前结果",
		                icon:"../Theme/1/images/extjs/customer/edit16.gif",
		                handler:function(){
		                    exportExcel(false);
		                }
	                },{	    
		                text:"全部结果",
		                icon:"../Theme/1/images/extjs/customer/edit16.gif",
		                handler:function(){
		                    exportExcel(true);
		                }
	                }]
	            })
		    }]
    });
//    var routetree = null;
//    var routediv = null;
//    var routeSelectWin = null;
//    function routeTreeCheckChange(node, checked) {
//        node.expand();
//        node.attributes.checked = checked;
//        node.eachChild(function(child) {
//            child.ui.toggleCheck(checked);
//            child.attributes.checked = checked;
//            child.fireEvent('checkchange', child, checked);
//        });
//        routetree.un('checkchange', routeTreeCheckChange, routetree);
//        checkParentNode(node);
//        routetree.on('checkchange', routeTreeCheckChange, routetree);
//    }    
//    function selectRoute() {
//        if (routediv == null) {
//            routediv = document.createElement('div');
//            routediv.setAttribute('id', 'routetreeDiv');
//            Ext.getBody().appendChild(routediv);
//        }
//        var Tree = Ext.tree;
//        var parentUrl = '/crm/DefaultFind.aspx?method=getLineTreeByOrg&OrgId=<% =ZJSIG.UIProcess.ADM.UIAdmUser.OrgID(this)%>';
//        if (routetree == null) {
//            // set the root node
//            var root = new Tree.AsyncTreeNode({
//                text: '线路情况',
//                draggable: false,
//                id: '0'
//            });
//            routetree = new Tree.TreePanel({
//                useArrows: true, //是否使用箭头
//                autoScroll: true,
//                animate: true,
//                enableDD: false,
//                containerScroll: true,
//                loader: new Tree.TreeLoader({
//                    dataUrl: parentUrl,
//                    baseAttrs:{ uiProvider: Ext.tree.TreeCheckNodeUI } 
//                }),
//                root:root
//            });
//            routetree.on('beforeload', function(node) {
//                routetree.loader.dataUrl = parentUrl + '&routeid=' + node.id ;
//            });
//            routetree.on('checkchange', routeTreeCheckChange, routetree);
//        }
//        if (routeSelectWin == null) {
//            routeSelectWin = new Ext.Window({
//                title: '线路信息',
//                style: 'margin-left:0px',
//                width: 500,
//                height: 300,
//                constrain: true,
//                layout: 'fit',
//                plain: true,
//                modal: true,
//                closeAction: 'hide',
//                autoDestroy: true,
//                resizable: true,
//                items: [routetree]
//                , buttons: [{
//		            text: "确定"
//		            ,id:'btnYes'
//			        , handler: function() {
//			            selectRouteOk();
//			            routeSelectWin.hide();
//			        }
//			        , scope: this
//		        },
//		        {
//		            text: "取消"
//			        , handler: function() {
//			            selectedProductID = "";
//			            routeSelectWin.hide();
//			        }
//			    , scope: this
//             }]
//            });
//            routetree.root.reload();
//        }
//        routeSelectWin.show();
//    }
//    var selectedRouteIds = "";
//        function selectRouteOk() {
//            var selectRouteNames = "";
//            selectedRouteIds = "";
//            var selectNodes = routetree.getChecked();
//            for (var i = 0; i < selectNodes.length; i++) {
//                if (selectRouteNames != "") {
//                    selectRouteNames += ",";
//                    selectedRouteIds += ",";
//                }
//                selectRouteNames += selectNodes[i].text;
//                selectedRouteIds += selectNodes[i].id;
//            }
//            document.getElementById('RouteName').value=selectRouteNames;
//            document.getElementById('RouteId').value=selectedRouteIds;            
//        }
    
    searchOrderPanel.render();
    function selectSearchData() {
        OrderSerachGridData.baseParams.OrgId = selectOrgIds;
        OrderSerachGridData.baseParams.OutStor = Ext.getCmp('OutStor').getValue();
        OrderSerachGridData.baseParams.CustomerId = Ext.getCmp('CustomerId').getValue();
        OrderSerachGridData.baseParams.ProductName = Ext.getCmp('ProductName').getValue();
        OrderSerachGridData.baseParams.OrderType = Ext.getCmp('OrderType').getValue();
        OrderSerachGridData.baseParams.DlvType = Ext.getCmp('DlvType').getValue();
        OrderSerachGridData.baseParams.RouteId = Ext.getCmp('RouteId').getValue();
        OrderSerachGridData.baseParams.StartDate = Ext.util.Format.date(Ext.getCmp('StartDate').getValue(), 'Y/m/d');
        OrderSerachGridData.baseParams.EndDate = Ext.util.Format.date(Ext.getCmp('EndDate').getValue(), 'Y/m/d');
        OrderSerachGridData.load({
            params: {
                start: 0,
                limit: 10
            }
        });
    }
    function trackOrder(){
        var sm = OrderSerachGrid.getSelectionModel();
        //多选
        var selectData = sm.getSelections();          
        if(selectData.length==0)
        {
            return;
        }     
      
        if (typeof (newFormWin) == "undefined") {
            newFormWin = new Ext.Window({
                layout: 'fit',
                width: 400,
                height: 300,
                closeAction: 'hide',
                plain: true,
                constrain: true,
                modal: true,
                autoDestroy: true,
                title: '跟踪信息',
                items: orderTrackInfoGrid
            });
        }
        newFormWin.show();
        //查数据
        orderTrackInfoStore.baseParams.OrderId = selectData[0].data.OrderId;
        orderTrackInfoStore.load();    
    }
    var orderTrackInfoStore = new Ext.data.Store
    ({
        url: 'frmOrderStatistics.aspx?method=TrackOrder',
        reader: new Ext.data.JsonReader({
            totalProperty: 'totalProperty',
            root: 'root'
        }, [
        { name: 'Id' },
        { name: 'Name' },
        { name: 'Oper' },
        { name: 'OpDate' }
        ])
    });
    var orderTrackInfoGrid = new Ext.grid.GridPanel({
        width: document.body.offsetWidth,
        //height: '100%',
        //autoWidth: true,
        //autoHeight: true,
        autoScroll: true,
        layout: 'fit',
        store: orderTrackInfoStore,
        loadMask: { msg: '正在加载数据，请稍侯……' },
        cm: new Ext.grid.ColumnModel([
                new Ext.grid.RowNumberer({header:'序号',width:34}), //自动行号
                {
                    header: '序号',
                    dataIndex: 'Id',
                    id: 'Id',
                    width:40
                },
                {
                    header: '内容',
                    dataIndex: 'Name',
                    id: 'Name',
                    width: 80
                },
                {
                    header: '操作人员',
                    dataIndex: 'Oper',
                    id: 'Oper',
                    width:40
                },
                {
                    header: '操作时间',
                    dataIndex: 'OpDate',
                    id: 'OpDate',
                    width:60
                }
            ]),
        viewConfig: {
            columnsText: '显示的列',
            scrollOffset: 20,
            sortAscText: '升序',
            sortDescText: '降序',
            forceFit: true,
            getRowClass: function(r, i, p, s) {
                if (r.data.Name.indexOf('未') > -1) {
                    return "x-grid-done";
                }else{
                    return "x-grid-do";
                }
            }
        },
        height: 280,
        closeAction: 'hide',
        stripeRows: true,
        loadMask: true
    });
/****************************************************/
    function exportExcel(isAll) { 
            
        //alert(json);      
        var _urls="frmOrderStatistics.aspx?method=exportData&IsAll="+isAll;
        
        _urls += '&OrgId='+OrderSerachGridData.baseParams.OrgId;
        _urls += '&OutStor='+OrderSerachGridData.baseParams.OutStor;
        _urls += '&CustomerId='+OrderSerachGridData.baseParams.CustomerId;
        _urls += '&ProductName='+OrderSerachGridData.baseParams.ProductName;
        _urls += '&OrderType='+OrderSerachGridData.baseParams.OrderType;
        _urls += '&DlvType='+OrderSerachGridData.baseParams.DlvType;
        _urls += '&RouteId='+OrderSerachGridData.baseParams.RouteId;
        _urls += '&StartDate='+OrderSerachGridData.baseParams.StartDate;
        _urls += '&EndDate='+OrderSerachGridData.baseParams.EndDate;
        _urls += '&start='+ (OrderSerachGrid.getBottomToolbar().getPageData().activePage - 1);
        _urls += '&limit=10';
        //check
        window.open(_urls,"");    
    }  
    //添加默认项
    dsDlvType.insert(0, new Ext.data.Record({ 'DicsCode': '', 'DicsName': '全部' }, '-1'));
    Ext.getCmp('DlvType').setValue('');
    dsOrderType.insert(0, new Ext.data.Record({ 'DicsCode': '', 'DicsName': '全部' }, '-1'));
    Ext.getCmp('OrderType').setValue('');
    /****************************************************************/
    var OrderSerachGridData = new Ext.data.Store({
        url: 'frmOrderStatistics.aspx?method=getOrderList',
        reader: new Ext.data.JsonReader({
            totalProperty: 'totalProperty',
            root: 'root'
        }, [
            { name: 'OrderId' },
            { name: 'OutStor' },
            { name: 'OutStorName' },
            { name: 'CustomerName' },
            { name: 'DlvDate' },
            { name: 'DlvAdd' },
            { name: 'DlvDesc' },
            { name: 'OrderTypeName' },
            { name: 'PayTypeName' },
            { name: 'BillMode' },
            { name: 'BillModeName' },
            { name: 'DlvTypeName' },
            { name: 'DlvLevelName' },
            { name: 'StatusName' },
            { name: 'IsPayedName' },
            { name: 'IsBillName' },
            { name: 'SaleInvId' },
            { name: 'SaleTotalQty' },
            { name: 'OutedQty' },
            { name: 'SaleTotalAmt' },
            { name: 'SaleTotalTax' },
            { name: 'OperName' },
            { name: 'CreateDate' },
            { name: 'OrgName' },
            { name: 'OwnerName' },
            { name: 'BizAudit' },
            { name: 'OrderNumber' },
            { name: 'StatusName' },
            { name: 'AuditDate' },
            { name: 'Remark' },
            { name: 'IsActiveName' }
            ])
    });
    var OrderSerachGrid = new Ext.grid.GridPanel({
        el: 'divDataGrid',
        //width: '100%',
        height: '100%',
        //autoWidth: true,
        //autoHeight: true,
        autoScroll: true,
        layout: 'fit',
        id: '',
        store: OrderSerachGridData,
        loadMask: { msg: '正在加载数据，请稍侯……' },
        cm: new Ext.grid.ColumnModel([
        new Ext.grid.RowNumberer(), //自动行号
        {
        header: '订单标识',
        dataIndex: 'OrderId',
        id: 'OrderId',
        hidden: true,
        hideable: false
    },
        {
            header: '订单编号',
            dataIndex: 'OrderNumber',
            id: 'OrderNumber'
        },
        {
            header: '公司名称',
            dataIndex: 'OrgName',
            id: 'OrgName'
        },
        {
            header: '出库仓库',
            dataIndex: 'OutStorName',
            id: 'OutStorName'
        },
        {
            header: '客户名称',
            dataIndex: 'CustomerName',
            id: 'CustomerName'
        },
        {
            header: '配送方式',
            dataIndex: 'DlvTypeName',
            id: 'DlvTypeName'
        },
        {
            header: '订货总数量',
            dataIndex: 'SaleTotalQty',
            id: 'SaleTotalQty'
        },
        {
            header: '订货总金额',
            dataIndex: 'SaleTotalAmt',
            id: 'SaleTotalAmt'
        },
        {
            header: '状态',
            dataIndex: 'StatusName',
            id: 'StatusName'
        },
        {
            header: '操作员',
            dataIndex: 'OperName',
            id: 'OperName'
        },
        {
            header: '创建时间',
            dataIndex: 'CreateDate',
            id: 'CreateDate',
            renderer: Ext.util.Format.dateRenderer('Y年m月d日')
        },
        {
             header: '备注',
            dataIndex: 'Remark',
            id: 'Remark'
}]),
    bbar: new Ext.PagingToolbar({
        pageSize: 10,
        store: OrderSerachGridData,
        displayMsg: '显示第{0}条到{1}条记录,共{2}条',
        emptyMsy: '没有记录',
        displayInfo: true
    }),
    viewConfig: {
        columnsText: '显示的列',
        scrollOffset: 20,
        sortAscText: '升序',
        sortDescText: '降序',
        forceFit: false
    },
    height: 280,
    closeAction: 'hide',
    stripeRows: true,
    loadMask: true//,
    //autoExpandColumn: 2
});
OrderSerachGrid.render();
OrderSerachGrid.on('rowdblclick', function(grid, rowIndex, e) {
    //弹出商品明细
    var _record = OrderSerachGrid.getStore().getAt(rowIndex).data.OrderId;
    if (!_record) {
        Ext.example.msg('操作', '请选择要查看的记录！');
    } else {
        OpenDtlWin(_record);
    }

});

/****************************************************************/
function OpenDtlWin(orderId) {
    if (typeof (uploadRouteWindow) == "undefined") {
        newFormWin = new Ext.Window({
            layout: 'fit',
            width: 600,
            height: 400,
            closeAction: 'hide',
            plain: true,
            constrain: true,
            modal: true,
            autoDestroy: true,
            title: '明细信息',
            items: orderDtInfoGrid
        });
    }
    newFormWin.show();
    //查数据
    orderDtInfoStore.baseParams.OrderId = orderId;
    orderDtInfoStore.load({
        params: {
            limit: 10,
            start: 0
        }
    });
}

var orderDtInfoStore = new Ext.data.Store
    ({
        url: 'frmOrderStatistics.aspx?method=getDtlInfo',
        reader: new Ext.data.JsonReader({
            totalProperty: 'totalProperty',
            root: 'root'
        }, [
	    { name: 'OrderDtlId' },
	    { name: 'OrderId' },
	    { name: 'ProductId' },
	    { name: 'ProductNo' },
	    { name: 'ProductName' },
	    { name: 'Specifications' },
	    { name: 'SpecificationsName' },
	    { name: 'Unit' },
	    { name: 'UnitName' },
	    { name: 'SaleQty' },
	    { name: 'SalePrice' },
	    { name: 'SaleAmt' },
	    { name: 'SaleTax' }
	    ])
    });

var smDtl = new Ext.grid.CheckboxSelectionModel({
    singleSelect: true
});
var orderDtInfoGrid = new Ext.grid.GridPanel({
    width: '100%',
    height: '100%',
    autoWidth: true,
    autoHeight: true,
    autoScroll: true,
    layout: 'fit',
    id: '',
    store: orderDtInfoStore,
    loadMask: { msg: '正在加载数据，请稍侯……' },
    sm: smDtl,
    cm: new Ext.grid.ColumnModel([
		    smDtl,
		    new Ext.grid.RowNumberer(), //自动行号
		    {
		    header: '存货编号',
		    dataIndex: 'ProductNo',
		    id: 'ProductNo'
		},
		    {
		        header: '存货名称',
		        dataIndex: 'ProductName',
		        id: 'ProductName',
		        width: 120
		    },
		    {
		        header: '规格',
		        dataIndex: 'SpecificationsName',
		        id: 'SpecificationsName'
		    },
		    {
		        header: '计量单位',
		        dataIndex: 'UnitName',
		        id: 'UnitName'
		    },
		    {
		        header: '销售数量',
		        dataIndex: 'SaleQty',
		        id: 'SaleQty'
		    },
		    {
		        header: '销售单价',
		        dataIndex: 'SalePrice',
		        id: 'SalePrice'
		    },
		    {
		        header: '销售金额',
		        dataIndex: 'SaleAmt',
		        id: 'SaleAmt'
		    },
		    {
		        header: '税额',
		        dataIndex: 'SaleTax',
		        id: 'SaleTax'
		    }
		]),
    bbar: new Ext.PagingToolbar({
        pageSize: 10,
        store: orderDtInfoStore,
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
/****************************************************************/
//var gs =Ext.getCmp('OrgId');
//gs.setValue(<% =ZJSIG.UIProcess.ADM.UIAdmUser.OrgID(this)%>);

//var curOrgId = Ext.getCmp('OrgId').getValue();
dsWareHouse.load({
    params: {
        orgID: orgId
    },
    success: function(resp, opts) {

    }
});
// gs.setDisabled(true);
});
</script>
</html>
