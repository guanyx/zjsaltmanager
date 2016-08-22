<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmCustomerReport.aspx.cs" Inherits="RPT_SCM_frmCustomerReport" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>客户统计</title>
        <meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<link rel="stylesheet" type="text/css" href="../../ext3/resources/css/ext-all.css" />
<script type="text/javascript" src="../../ext3/adapter/ext/ext-base.js"></script>
<script type="text/javascript" src="../../ext3/ext-all.js"></script>
<script type="text/javascript" src="../../js/getExcelXml.js"></script>
<script type="text/javascript" src="../../js/ExtJsHelper.js"></script>
<script type="text/javascript" src="../../js/FilterControl.js"></script>
<script type="text/javascript" src="../../js/GroupFieldSelect.js"></script>
<script type="text/javascript" src="../../js/ProductSelect.js"></script>
<script type="text/javascript" src="../../js/OrgsSelect.js"></script>
<link rel="Stylesheet" type="text/css" href="../../css/gridPrint.css" />
</head>
<%=getComboBoxStore()%>
<script type="text/javascript">
    Ext.onReady(function() {
        Ext.BLANK_IMAGE_URL = "../../ext3/resources/images/default/s.gif";
        /*------实现toolbar的函数 start---------------*/
        var Toolbar = new Ext.Toolbar({
            renderTo: "toolbar",
            items: []
        });

        var inOutGridData = new Ext.data.Store
({
    url: 'frmCustomerReport.aspx?method=getlist',
    reader: new Ext.data.JsonReader({
        totalProperty: 'totalProperty',
        root: 'root'
    }, [
	{ name: 'ShortName' },
	{ name: 'OrgShortName' },
	{ name: 'SaltName' },
	{ name: 'Qty', type: 'float' },
	{ name: 'Amt', type: 'float' }
	])
	,
    listeners:
	{
	    scope: this,
	    load: function() {
	        var saltName = ''
	        if (chbAdvanceSearch.getValue()) {
	            saltName = Ext.getCmp("filterProductType").getValue();
	        }
	        else {

	        }
	        if (saltName == '')
	            saltName = '全部';
	        inOutGridData.each(function(record) {
	            record.set("SaltName", saltName);
	        });

	    }
	}
});

        /*------获取数据的函数 结束 End---------------*/

        var defaultPageSize = 10;
        var toolBar = new Ext.PagingToolbar({
            pageSize: 10,
            store: inOutGridData,
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
            singleSelect: true
        });
        var inOutGrid = new Ext.grid.GridPanel({
            el: 'inOutGridDiv',
            width: '100%',
            height: '100%',
            autoWidth: true,
            autoHeight: true,
            autoScroll: true,
            layout: 'fit',
            id: 'inOutGrid',
            store: inOutGridData,
            loadMask: { msg: '正在加载数据，请稍侯……' },
            sm: sm,
            cm: new Ext.grid.ColumnModel([
		sm,
		new Ext.grid.RowNumberer(), //自动行号
		{
		    header: '所属机构',
		    dataIndex: 'OrgShortName',
		    id: 'OrgShortName' 
        },
		{
		    header: '客户名称',
	        dataIndex: 'ShortName',
	        id: 'CustomerName'
		},
		{
		    header: '产品',
		    dataIndex: 'SaltName',
		    id: 'SaltName'
		},
		{
		    header: '数量',
		    dataIndex: 'Qty',
		    id: 'Qty'
		},

		{
		    header: '金额',
		    dataIndex: 'Amt',
		    id: 'Amt',
		    renderer:function(v){
		        return v.toFixed(2);
		    }
}]),
            bbar: toolBar,
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
        toolBar.addField(createPrintButton(inOutGridData, inOutGrid, ''));
        inOutGrid.render();
        /*------DataGrid的函数结束 End---------------*/

        function newExpertClick(obj){
            var json = "";
            filterStore.each(function(filterStore) {
                json += Ext.util.JSON.encode(filterStore.data) + ',';
            });
            json = json.substring(0, json.length - 1);    
            if (!Ext.fly('exportdivData'))   
            {   
                var frm = document.createElement('form');   
                frm.id = 'exportdivData';   
                frm.name = id ;   
                //frm.style.display = 'none';   
                frm.className = 'x-hidden'; 
                document.body.appendChild(frm);   
            }  
            var SaltName = selectProductNames;
            if (SaltName == '')
	            SaltName = '全部';
            Ext.Ajax.request({   
                url: 'frmCustomerReport.aspx?method=exportData', 
                form: Ext.fly('exportdivData'),   
                method: 'POST',     
                isUpload: true,          
                params: {
                    SaleName:SaltName,
                    limit: defaultPageSize,
                    start: 0,
                    filter:json
                },
                success: function(resp, opts) {
                    //Ext.Msg.hide();
                },
                failure: function(resp, opts) {
                     //Ext.Msg.hide();
                }
            });
       }
        
        btnExpert.on("click", newExpertClick);
        createSearch(inOutGrid, inOutGridData, "searchForm");
        btnExpert.un("click", btnExpertClick);
        searchForm.el = "searchForm";
        searchForm.render();
        btnExpert.setVisible(true);


        var addRow = new fieldRowPattern({
            id: 'ProductType',
            name: '存货类别',
            dataType: 'select'
        });
        fieldStore.add(addRow);

        var addRow = new fieldRowPattern({
            id: 'TradeType',
            name: '行业类别',
            dataType: ''
        });
        fieldStore.add(addRow);

        var addRow = new fieldRowPattern({
            id: 'OrgId',
            name: '所属单位',
            dataType: 'select'
        });
        fieldStore.add(addRow);

        var addRow = new fieldRowPattern({
            id: 'CreateDate',
            name: '销售日期',
            dataType: 'date'
        });
        fieldStore.add(addRow);

        var orgId = 1;
        var selectOrgIds = 1;
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
                selectOrgTree.on('checkchange', treeOrgCheckChange, selectOrgTree);
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
        function treeOrgCheckChange(node, checked) {
            selectOrgTree.un('checkchange', treeOrgCheckChange, selectOrgTree);
            if (checked) {
                var selectNodes = selectOrgTree.getChecked();
                for (var i = 0; i < selectNodes.length; i++) {
                    if (selectNodes[i].id != node.id) {
                        selectNodes[i].ui.toggleCheck(false);
                        selectNodes[i].attributes.checked = false;
                    }
                }
            }
            selectOrgTree.on('checkchange', treeOrgCheckChange, selectOrgTree);
        }

        txtFieldValue.on("focus", selectProductType);


        function selectProductType() {
            if (cmbField.getValue() != "ProductType")
                return;
            switch (cmbField.getValue()) {
                case "ProductType":
                    currentSelect = txtFieldValue;
                    selectShow("ProductType");
                    break;
                case "OrgId":
                    currentSelect = txtFieldValue;
                    selectOrgType();
                    break;
            }


        }

        this.selectShow = function(columnName) {
            switch (columnName) {
                case "ProductType":
                    if (selectProductForm == null) {
                        parentUrl = "../../CRM/product/frmBaProductClass.aspx?select=true&method=getbaproducttree";
                        showProductForm("", "", "", true);
                        selectProductTree.on('checkchange', treeCheckChange, selectProductTree);
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

        function treeCheckChange(node, checked) {
            selectProductTree.un('checkchange', treeCheckChange, selectProductTree);
            if (checked) {
                var selectNodes = selectProductTree.getChecked();
                for (var i = 0; i < selectNodes.length; i++) {
                    if (selectNodes[i].id != node.id) {
                        selectNodes[i].ui.toggleCheck(false);
                        selectNodes[i].attributes.checked = false;
                    }
                }
            }
            selectProductTree.on('checkchange', treeCheckChange, selectProductTree);
        }

        var selectedProductIds = "";
        var selectProductNames = "";
        function selectProductOk() {
            selectProductNames = "";
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

        this.getSelectedValue = function(columnName) {
            switch (columnName) {
                case "ProductType":
                    return selectedProductIds;
                case "OrgId":
                    if (selectOrgIds == '1')
                        return "";
                    return selectOrgIds;
            }
        }


    })
    function getCmbStore(columnName) {
        switch (columnName) {
            case "TradeType":
                return dsTradeType;
        }   
   
}
</script>
<body>
    <form id="form1" runat="server">
<div id='toolbar'></div>
<div id='searchForm'></div>
<div id='inOutGridDiv'></div>
<div id="searchGrid"></div>
    </form>
</body>
</html>