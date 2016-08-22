<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmWmsStockInOutSta.aspx.cs" Inherits="WMS_frmWmsStockInOutSta" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>�ޱ���ҳ</title>
    <meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<link rel="stylesheet" type="text/css" href="../ext3/resources/css/ext-all.css" />
<script type="text/javascript" src="../ext3/adapter/ext/ext-base.js"></script>
<script type="text/javascript" src="../ext3/ext-all.js"></script>
<script type="text/javascript" src="../js/getExcelXml.js"></script>
<script type="text/javascript" src="../js/ExtJsHelper.js"></script>
<script type="text/javascript" src="../js/FilterControl.js"></script>
<script type="text/javascript" src="../js/GroupFieldSelect.js"></script>
<script type="text/javascript" src="../js/ProductSelect.js"></script>
<script type="text/javascript" src="../ext3/src/locale/ext-lang-zh_CN.js"></script>
<link rel="Stylesheet" type="text/css" href="../css/gridPrint.css" />
</head>
<%=getComboBoxStore() %>
<script type="text/javascript">

var schemeGridData = new Ext.data.Store
({
url: 'frmWmsStockInOutSta.aspx?method=getSchemeList',
reader:new Ext.data.JsonReader({
	totalProperty:'totalProperty',
	root:'root'
},[{name:'SchemeId'},
	{name:'SchemeName'},
	{name:'SchemeMemo'},
	{name:'SchemeType'},
	{name:'Creater'},
	{name:'OrgId'},
	{name:'CreateDate'},
	{name:'SchemeViewname'}]),
	listeners:
	{
		scope:this,
		load:function(){
		}
	}
});
schemeGridData.baseParams.ViewName = reportViewName;

function getFilterStr()
{
    filterStore.removeAll();
    getFilter();
    var json = "";
                filterStore.each(function(filterStore) {
                    json += Ext.util.JSON.encode(filterStore.data) + ',';
                });
   json = json.substring(0, json.length - 1);
   return json;
}
    Ext.onReady(function() {
        /*------ʵ��toolbar�ĺ��� start---------------*/
        var Toolbar = new Ext.Toolbar({
            renderTo: "toolbar",
            items: []
        });

        var inOutGridData = new Ext.data.Store
({
    url: 'frmWMSStockInOutSta.aspx?method=getlistinout',
    reader: new Ext.data.JsonReader({
        totalProperty: 'totalProperty',
        root: 'root'
    }, [
	{ name: 'OrderId', type: 'int' },
	{ name: 'WhId', type: 'int' },
	{ name: 'CreateDate', type: 'date' },
	{ name: 'OrgId', type: 'int' },
	{ name: 'TransAmount', type: 'float' },
	{ name: 'OrderDetailId', type: 'int' },
	{ name: 'WhpId', type: 'int' },
	{ name: 'ProductId', type: 'int' },
	{ name: 'ProductPrice', type: 'float' },
	{ name: 'PurchaseTotalamt', type: 'float' },
	{ name: 'BookQty', type: 'float' },
	{ name: 'RealQty', type: 'float' },
	{ name: 'UnitName'},
	{ name: 'SameRealQty',type:'float' },
	{ name: 'CustomerId', type: 'int' },
	{ name: 'FromBillType' },
	{ name: 'FromBillId', type: 'int' },
	{ name: 'LoadComId', type: 'int' },
	{ name: 'OrgName' },
	{ name: 'CustomerName' },
	{ name: 'TrainTypeName' },
	{ name: 'FromBillTypeName' },
	{ name: 'WhName' },
	{ name: 'ProductName'},
	{ name: 'EmpName'}])
	,sortData: function(f, direction) {
        var tempSort = Ext.util.JSON.encode(inOutGridData.sortInfo);
        if (sortInfor != tempSort) {
            sortInfor = tempSort;
            inOutGridData.baseParams.SortInfo = sortInfor;
            inOutGridData.load({ params: { limit: defaultPageSize, start: 0} });
        }
    },
    listeners:
	{
	    scope: this,
	    load: function() {
	    }
	}
});

var sortInfor='';

        /*------��ȡ���ݵĺ��� ���� End---------------*/

        var defaultPageSize = 10;
        var toolBar = new Ext.PagingToolbar({
            pageSize: 10,
            store: inOutGridData,
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

            function getWhpName(val) {
                    //var index = posStore.find('WhpId', val);
                    var index = posStore.findBy(function(v, value) {  
	                    return v.get('WhpId')==val; 
                    });
                    if (index < 0)
                        return "";
                    var record = posStore.getAt(index);
                    return record.data.WhpName;
                }
                
        var sm = new Ext.grid.CheckboxSelectionModel({
            singleSelect: true
        });
        var inOutGrid = new Ext.grid.GridPanel({
            el: 'inOutGridDiv',
            //width: '100%',
            //height: '100%',
            //autoWidth: true,
            //autoHeight: true,
            autoScroll: true,
            layout: 'fit',
            id: 'inOutGrid',
            store: inOutGridData,
            loadMask: { msg: '���ڼ������ݣ����Ժ��' },
            sm: sm,
            cm: new Ext.grid.ColumnModel([
		sm,
		new Ext.grid.RowNumberer(), //�Զ��к�
		{
		header: '��ҵ����',
		dataIndex: 'FromBillTypeName',
		id: 'FromBillTypeName'
},
		{
		    header: '�ֿ�����',
		    dataIndex: 'WhName',
		    sortable: true,
		    id: 'WhName'
		},
		{
		    header: '��λ',
		    dataIndex: 'WhpId',
		    id: 'WhpId',
		    sortable: true,
		    renderer:getWhpName
		},
		{
		    header: '��Ʒ����',
		    dataIndex: 'ProductName',
		    sortable: true,
		    id: 'ProductName'
		},

		{
		    header: '��������',
		    dataIndex: 'CreateDate',
		    id: 'CreateDate',
		    sortable: true,
		    renderer: Ext.util.Format.dateRenderer('Y-m-d')
		},
		{
		    header: '��Ʒ�۸�',
		    dataIndex: 'ProductPrice',
		    id: 'ProductPrice'
		},
		{
		    header: '����',
		    dataIndex: 'RealQty',
		    id: 'RealQty'
		},{
		    header: '��λ',
		    dataIndex: 'UnitName',
		    id: 'UnitName'
		},
		{
		    header: '����',
		    dataIndex: 'SameRealQty',
		    id: 'SameRealQty'
		},
		{
		    header: '�ܽ��',
		    dataIndex: 'PurchaseTotalamt',
		    id: 'PurchaseTotalamt'
		},
		{
		    header: '�ͻ�����',
		    dataIndex: 'CustomerName',
		    sortable: true,
		    id: 'CustomerName'
		},
		{
		    header: '��������',
		    dataIndex: 'OrgName',
		    id: 'OrgName'
},{
		    header: '�ֿ������',
		    dataIndex: 'EmpName',
		    sortable: true,
		    id: 'EmpName'
		}]),
            bbar: toolBar,
            viewConfig: {
                columnsText: '��ʾ����',
                scrollOffset: 20,
                sortAscText: '����',
                sortDescText: '����',
                forceFit: false
            },
            height: 380,
            closeAction: 'hide',
            stripeRows: true,
            loadMask: true//,
            //autoExpandColumn: 2
        });
	toolBar.addField(createPrintButton(inOutGridData,inOutGrid, ''));
        inOutGrid.render();	
        /*------DataGrid�ĺ������� End---------------*/

        _grid = inOutGrid;
        iniSelectColumn(Toolbar, "searchGrid");

        createSearch(inOutGrid, inOutGridData, "searchForm");
        searchForm.el = "searchForm";
        searchForm.render();
        btnExpert.setVisible(true);
        btnFliter.on("click", staticSeach);

        function staticSeach() {
            var json = "";
            filterStore.each(function(filterStore) {
                json += Ext.util.JSON.encode(filterStore.data) + ',';
            });
            searchDataGrid(json);
        }


        var addRow = new fieldRowPattern({
            id: 'ProductType',
            name: '������',
            dataType: 'select'
        });
        fieldStore.add(addRow);

        txtFieldValue.on("focus", selectProductType);

        function selectProductType() {
            if (cmbField.getValue() != "ProductType")
                return;
            currentSelect = txtFieldValue;
            selectShow("ProductType");

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
            currentSelect.setValue(selectProductNames);
        }

        this.getSelectedValue = function() {
            return selectedProductIds;
        }


    })
function getCmbStore(columnName) {
    switch(columnName)
    {
        case"WhpId":
            return posStore;
            break;
        case "FromBillTypeName":
            var dsFromBillTypeName = new Ext.data.SimpleStore({ 
                fields:['FromBillTypeName','FromBillTypeNameText'],
                data:[['�ɹ����','�ɹ����'],['�������','�������'],
                      ['�ƿ����','�ƿ����'],['�ƿ����','�ƿ����'],['�Ʋ�','�Ʋ�'],
                      ['����','����'],['���','���'],                        
                        ['�����˻�','�����˻�'],['�ɹ��˻�','�ɹ��˻�'],                        
                        ['ֱ����','ֱ����'],['ֱ����','ֱ����'],
                        ['ת����','ת����'],['ת����','ת����'], 
                        ['�ɹ��������','�ɹ��������'],
                        ['�������','�������'],['��������','��������'],
                        ['�̵�','�̵�'],['�����˻�','�����˻�']],                     
                autoLoad: false});
            return dsFromBillTypeName;
            break;
        default:
        return null;
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
