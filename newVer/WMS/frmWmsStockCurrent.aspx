<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmWmsStockCurrent.aspx.cs" Inherits="WMS_frmWmsStockCurrent" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html>
<head>
<title>ʵʱ����ѯҳ��</title><meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
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
        if (dsWarehouseList == null) { //��ֹ�ظ�����
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
            fieldLabel: '��˾',
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

        var dsWarehousePositionList; //��λ������
        if (dsWarehousePositionList == null) { //��ֹ�ظ�����
            dsWarehousePositionList = new Ext.data.JsonStore({
                totalProperty: "result",
                root: "root",
                url: 'frmWmsStockCurrent.aspx?method=getWarehousePositionList',
                fields: ['WhpId', 'WhpName']
            });
        }

        var dsWarehousePositionList_grid; //��λ������
        if (dsWarehousePositionList_grid == null) { //��ֹ�ظ�����
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



        /*------��ʼ��ȡ���ݵĺ��� start---------------*/
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
        /*------����------Start-----------------------*/
        //        var WhNamePanel = new Ext.form.ComboBox({
        //            fieldLabel: '�ֿ�����',
        //            name: 'warehouseCombo',
        //            store: dsWarehouseList,
        //            displayField: 'WhName',
        //            valueField: 'WhId',
        //            typeAhead: true, //�Զ�����һ����������ѡ�ȫ����
        //            triggerAction: 'all',
        //            emptyText: '��ѡ��ֿ�',
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
        //            fieldLabel: '��λ����',
        //            name: 'warehousePosCombo',
        //            store: dsWarehousePositionList,
        //            displayField: 'WhpName',
        //            valueField: 'WhpId',
        //            typeAhead: true, //�Զ�����һ����������ѡ�ȫ����
        //            triggerAction: 'all',
        //            emptyText: '��ѡ���λ',
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
        //        //            fieldLabel: '��Ʒ����',
        //        //            name: 'productCombo',
        //        //            store: dsProductList,
        //        //            displayField: 'ProductName',
        //        //            valueField: 'ProductId',
        //        //            typeAhead: true, //�Զ�����һ����������ѡ�ȫ����
        //        //            triggerAction: 'all',
        //        //            emptyText: '��ѡ����Ʒ',
        //        //            //valueNotFoundText: 0,
        //        //            selectOnFocus: true,
        //        //            forceSelection: true,
        //        //            id: 'ProductId',
        //        //            anchor: '90%',
        //        //            mode: 'local',
        //        //            listeners: { specialkey: function(f, e) { if (e.getKey() == e.ENTER) { Ext.getCmp('searchebtnId').focus(); } } }

        //        //        });

        //        var ProductNamePanel = new Ext.form.TextField({
        //            fieldLabel: '��Ʒ����',
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
        //                layout: 'column',   //�����Ԫ��Ϊ����Ϊ�в��ַ�ʽ
        //                border: false,
        //                items: [{
        //                    columnWidth: .3,  //����ռ�õĿ�ȣ���ʶΪ20��
        //                    layout: 'form',
        //                    border: false,
        //                    items: [
        //                        ArriveOrgText
        //                    ]
        //                }, {
        //                    columnWidth: .2,  //����ռ�õĿ�ȣ���ʶΪ20��
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
        //                        text: '��ѯ',
        //                        id: 'searchebtnId',
        //                        anchor: '50%',
        //                        handler: function() {
        //                            updateDataGrid();
        //                        }
        //}]
        //}]
        //}]
        //                    });
        /*------����------END-------------------------*/

        /*------��ȡ���ݵĺ��� ���� End---------------*/

        /*------ʵ��toolbar�ĺ��� start---------------*/
        var Toolbar = new Ext.Toolbar({
            renderTo: 'toolbar',
            region: "north",
            height: 25//,
//            items: [{
//                text: "���������Ϣ",
//                icon: "../Theme/1/images/extjs/customer/add16.gif",
//                handler: function() {
//                    clearZeroProductStore();
//                }
//            }]
        });

function clearZeroProductStore()
{
    var sm = stockGrid.getSelectionModel();
    //��ȡѡ���������Ϣ
    var selectData = sm.getSelected();
    //���û��ѡ�񣬾���ʾ��Ҫѡ��������Ϣ
    if (selectData == null) {
        Ext.Msg.alert("��ʾ", "��ѡ����Ҫɾ����������Ϣ��");
        return;
    }
    //ɾ��ǰ�ٴ������Ƿ����Ҫɾ��
    Ext.Msg.confirm("��ʾ��Ϣ", "�Ƿ����Ҫɾ��ѡ���������Ʒ��Ϣ��", function callBack(id) {
        //�ж��Ƿ�ɾ������
        if (id == "yes") {
            //ҳ���ύ
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

        /*------��ʼDataGrid�ĺ��� start---------------*/
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
            loadMask: { msg: '���ڼ������ݣ����Ժ��' },
            cm: new Ext.grid.ColumnModel([
		new Ext.grid.RowNumberer(), //�Զ��к�
		{
		header: '�ֿ�����',
		dataIndex: 'WhName',
		id: 'WhName',
		width: 100
},
		{   
		    header: '��λ����',
		    dataIndex: 'WhpName',
		    id: 'WhpName',
		    width: 100
		},
        {
            header: '����',
            dataIndex: 'ProductCode',
            id: 'ProductCode',
            width: 80
        },
		{
		    header: '��Ʒ����',
		    dataIndex: 'ProductName',
		    id: 'ProductName',
		    width: 220
		},
        {
            header: '���',
            dataIndex: 'ProductSpec',
            id: 'Productspec',
            width: 80
        },
        {
		    header: '��������',
		    dataIndex: 'AliasRealQty',
		    id: 'AliasRealQty',
		    width: 80
        },
        {
            header: '������λ',
            dataIndex: 'ProductUnit',
            id: 'Productunit',
            width: 60

        },
        {
            header: '�������',
		dataIndex: 'RealQty',
		id: 'RealQty',
		width: 80//,
		    //hidden:true

        },

            //		{
            //		    header: 'Ԥ�����',
            //		    dataIndex: 'PrestreQty',
            //		    id: 'PrestreQty',
            //		    hide: true
            //		},
		{
		header: '��浥λ',
            dataIndex: 'BaseUnitName',
            id: 'BaseUnitName',
            width: 60//,
            //hidden: true
}
   ]),
            bbar: toolBar,
            viewConfig: {
                columnsText: '��ʾ����',
                scrollOffset: 20,
                sortAscText: '����',
                sortDescText: '����',
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
        printTitle = "���ʵʱ�����Ϣ";
        /*------DataGrid�ĺ������� End---------------*/


        createSearch(stockGrid, stockGridData, "searchForm");
        searchForm.el = "searchForm";
        searchForm.render();

        var addRow = new fieldRowPattern({
            id: 'OrgId',
            name: '��˾',
            dataType: 'select'
        });
        fieldStore.insert(0, addRow);
        addRow = new fieldRowPattern({
            id: 'ProductType',
            name: '��Ʒ���',
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

