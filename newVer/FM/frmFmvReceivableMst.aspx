<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmFmvReceivableMst.aspx.cs" Inherits="FM_frmFmvReceivableMst" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>�ޱ���ҳ</title>
    <meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
    <link rel="stylesheet" type="text/css" href="../ext3/resources/css/ext-all.css" />
    <script type="text/javascript" src="../ext3/adapter/ext/ext-base.js"></script>
    <script type="text/javascript" src="../ext3/ext-all.js"></script>
    <script type="text/javascript" src="../js/OrgsSelect.js"></script>
    <script type="text/javascript" src="../js/getExcelXml.js"></script>
    <script type="text/javascript" src="../js/FilterControl.js"></script>
    <script type="text/javascript" src="../js/GroupFieldSelect.js"></script>
</head>
<%=getComboBoxStore()%>
<script>

    var selectOrgIds = orgId;
    function selectOrgType() {

        if (selectOrgForm == null) {
            var showType = "getcurrentandchildrentree";
            if (orgId == 1) {
                showType = "getcurrentAndChildrenTreeByArea";
            }
            showOrgForm("", "", "../ba/sysadmin/frmAdmOrgList.aspx?method=" + showType);
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

    //����ѡ
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
                useArrows: true, //�Ƿ�ʹ�ü�ͷ
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
                {
                    selectedRouteIds ="";
                    currentSelect.setValue("");
                    routeSelectWin.hide();
                    return;
                }
                    
                selectedRouteIds = node.id;
                currentSelect.setValue(node.text);
                routeSelectWin.hide();
            });
            // set the root node
            var root = new Tree.AsyncTreeNode({
                text: '��·���',
                draggable: false,
                id: '0'
            });
            routetree.setRootNode(root);
        }
        if (routeSelectWin == null) {
            routeSelectWin = new Ext.Window({
                title: '��·��Ϣ',
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
    Ext.onReady(function() {
        /*------ʵ��toolbar�ĺ��� start---------------*/
        var Toolbar = new Ext.Toolbar({
            renderTo: "toolbar"
        });

        iniSelectColumn(Toolbar, "searchGrid");

        var fmReceiveGridData = new Ext.data.Store
({
    url: 'frmFmvReceivableMst.aspx?method=getlist',
    reader: new Ext.data.JsonReader({
        totalProperty: 'totalProperty',
        root: 'root'
    }, [
	{
	    name: 'ReceivableId'
	},
	{
	    name: 'CustomerId'
	},
	{
	    name: 'Amount', type: 'float'
	},
	{
	    name: 'TotalAmount', type: 'float'
	},
	{
	    name: 'CertificateStatus'
	},
	{
	    name: 'OrgId'
	},
	{
	    name: 'OwnerId'
	},
	{
	    name: 'CreateDate', type: 'date'
	},
	{
	    name: 'RouteName'
	},
	{
	    name: 'CustomerNo'
	},
	{
	    name: 'ShortName'
	},
	{
	    name: 'ChineseName'
	},
	{
	    name: 'BusinessTypeText'
	},
	{
	    name: 'FundTypeText'
	},
	{
	    name: 'PayTypeText'
}])
	,
    listeners:
	{
	    scope: this,
	    load: function() {
	    }
	}
});

        /*------��ȡ���ݵĺ��� ���� End---------------*/
        var defaultPageSize = 10;
        var toolBar = new Ext.PagingToolbar({
            pageSize: 10,
            store: fmReceiveGridData,
            displayMsg: '��ʾ��{0}����{1}����¼,��{2}��',
            emptyMsy: 'û�м�¼',
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
            emptyText: '����ÿҳ��¼��',
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
        btnExpert.setVisible(true);
        /*------��ʼDataGrid�ĺ��� start---------------*/

        var sm = new Ext.grid.CheckboxSelectionModel({
            singleSelect: true
        });
        var fmReceiveGrid = new Ext.grid.GridPanel({
            el: 'fmReceiveGridDiv',
            width: '100%',
            height: '100%',
            autoWidth: true,
            autoHeight: true,
            autoScroll: true,
            layout: 'fit',
            id: 'fmReceiveGridDiv',
            store: fmReceiveGridData,
            loadMask: { msg: '���ڼ������ݣ����Ժ��' },
            sm: sm,
            cm: new Ext.grid.ColumnModel([
		sm,
		new Ext.grid.RowNumberer(), //�Զ��к�
		{
		header: '��·����',
		dataIndex: 'RouteName',
		id: 'RouteName'
},
		{
		header: '�ͻ����',
		dataIndex: 'ShortName',
		id: 'ShortName'
},
		{
		    header: '�ͻ�����',
		    dataIndex: 'ChineseName',
		    id: 'ChineseName'
		},
		{
		    header: 'ҵ������',
		    dataIndex: 'BusinessTypeText',
		    id: 'BusinessTypeText'
		},
		{
		    header: '֧������',
		    dataIndex: 'FundTypeText',
		    id: 'FundTypeText'
		},
		{
		    header: '���㷽ʽ',
		    dataIndex: 'PayTypeText',
		    id: 'PayTypeText'
		},
		{
		    header: '���',
		    dataIndex: 'TotalAmount',
		    id: 'TotalAmount'
		}
]),
            bbar: toolBar,
            viewConfig: {
                columnsText: '��ʾ����',
                scrollOffset: 20,
                sortAscText: '����',
                sortDescText: '����',
                forceFit: true
            },
            height: 280,
            closeAction: 'hide',
            stripeRows: true,
            loadMask: true,
            autoExpandColumn: 2
        });
        fmReceiveGrid.render();
        /*------DataGrid�ĺ������� End---------------*/

        createSearch(fmReceiveGrid, fmReceiveGridData, "searchForm");
        searchForm.el = "searchForm";
        searchForm.render();

        
        var addRow = new fieldRowPattern({
        id: 'OrgId',
        name: '��˾',
        dataType: 'select'
        });
        fieldStore.insert(0, addRow);
        
        addRow = new fieldRowPattern({
        id: 'RouteId',
        name: '��·',
        dataType: 'select'
        });
        fieldStore.insert(1, addRow);
        /*
        addRow = new fieldRowPattern({
        id: 'RouteId',
        name: '��·��Ϣ',
        dataType: 'select'
        });
        fieldStore.add(addRow);
        */
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

        _grid = fmReceiveGrid;

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

    });

        function getCmbStore(columnName) {
            return null;
        }
</script>
<body>
    <form id="form1" runat="server">
    <div id='toolbar'></div>
    <div id='searchForm'></div>
    <div id='fmReceiveGridDiv'></div>
    <div id='searchGrid'></div>
    </form>
</body>
</html>
