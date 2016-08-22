<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmProductSelect.aspx.cs" Inherits="ZJ_frmProductSelect" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title></title>
    <meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
    <link rel="stylesheet" type="text/css" href="../../ext3/resources/css/ext-all.css" />
    <script type="text/javascript" src="../ext3/adapter/ext/ext-base.js"></script>
    <script type="text/javascript" src="../ext3/ext-all.js"></script>  
    <script type="text/javascript" src="../js/operateResp.js"></script>    
    <script type="text/javascript" src="../js/ExtJsHelper.js"></script>
    <script type="text/javascript" src="../js/FilterControl.js"></script>
    <script type="text/javascript" src="../js/ProductSelect.js"></script>
</head>
<body>
    <div id='toolbar'></div>
    <div id='searchForm'></div>
    <div id='searchForm12'></div>
    <div id='productGrid'></div>
</body>
<%=getComboBoxStore() %>
<script>
    var productGridData = null;
    Ext.BLANK_IMAGE_URL = "../../ext3/resources/images/default/s.gif";
    Ext.onReady(function() {
        var operType = '';
        Ext.QuickTips.init();
        Ext.form.Field.prototype.msgTarget = 'side';
        /*--------�������� start ---------------*/
        var dsSupplier; //��Ӧ������Դ
        var dsSmallProduct; //С��������

        /*----------�������� end --------------*/


        /*------ʵ��toolbar�ĺ��� start---------------*/
        var Toolbar = new Ext.Toolbar({
            renderTo: "toolbar",
            items: [ {
                text: "����",
                icon: "../Theme/1/images/extjs/customer/save.gif",
                handler: function() {
                    saveTypePruducts();
                }
            }, '-']
        });
        

        
        function saveTypePruducts() {
            var sm = productGrid.getSelectionModel();
            //��ȡѡ���������Ϣ
            var selectData = sm.getSelections();
            if(selectData.length==0)
            {
                Ext.Msg.alert("��ʾ", "��ѡ���¼��");
                return ;
            }
            var ids = "";
            for (var i = 0; i < selectData.length; i++) {
                if (ids.length > 0)
                    ids += ",";
                ids += selectData[i].get("ProductId");
            }

            Ext.Ajax.request({
                url: 'frmSaltProductList.aspx?method=saveSaltProduct',
                method: 'POST',
                params: {
                    SaltId: saltId,
                    ProductId: ids
                },
                success: function(resp, opts) {
                    if (checkExtMessage(resp)) {
                        productGridData.reload();
                    }

                }
         , failure: function(resp, opts) {
             Ext.MessageBox.hide();
             Ext.Msg.alert("��ʾ", "����ʧ��");

         }
            });
        }

        /*-------------------------------------------*/

        productGridData = new Ext.data.Store
({
    url: 'frmSaltProductList.aspx?method=getProductList',
    reader: new Ext.data.JsonReader({
        totalProperty: 'totalProperty',
        root: 'root'
    }, [
	{
	    name: 'ProductId'
	},
	{
	    name: 'ProductNo'
	},
	{
	    name: 'MnemonicNo'
	},
	{
	    name: 'AliasNo'
	},
	{
	    name: 'MobileNo'
	},
	{
	    name: 'SpeechNo'
	},
	{
	    name: 'NetPurchasesNo'
	},
	{
	    name: 'LogisticsNo'
	},
	{
	    name: 'BarCode'
	},
	{
	    name: 'SecurityCode'
	},
	{
	    name: 'ProductName'
	},
	{
	    name: 'AliasName'
	},
	{
	    name: 'Specifications'
	},
	{
	    name: 'SpecificationsText'
	},
	{
	    name: 'Unit'
	},
	{
	    name: 'UnitText'
	},
	{
	    name: 'SalePrice', type: 'float'
	},
	{
	    name: 'SalePriceLower'
	},
	{
	    name: 'SalePriceLimit'
	},
	{
	    name: 'TaxWhPrice'
	},
	{
	    name: 'TaxRate'
	},
	{
	    name: 'Tax'
	},
	{
	    name: 'SalesTax'
	},
	{
	    name: 'UnitConvertRate'
	},
	{
	    name: 'AutoFreight'
	},
	{
	    name: 'DriverFreight'
	},
	{
	    name: 'TrainFreight'
	},
	{
	    name: 'ShipFreight'
	},
	{
	    name: 'OtherFeight'
	},
	{
	    name: 'Supplier'
	},
	{
	    name: 'SupplierText'
	},
	{
	    name: 'Origin'
	},
	{
	    name: 'OriginText'
	},
	{
	    name: 'AliasPrice'
	},
	{
	    name: 'IsPlan'
	},
	{
	    name: 'ProductType'
	},
	{
	    name: 'InUse'
	},
	{
	    name: 'Remark'
	},
	{
	    name: 'CreateDate'
	},
	{
	    name: 'UpdateDate'
	},
	{
	    name: 'OperId'
	},
	{
	    name: 'OrgId'
}])
	,
    sortData: function(f, direction) {
        var tempSort = Ext.util.JSON.encode(productGridData.sortInfo);
        if (sortInfor != tempSort) {
            sortInfor = tempSort;
            productGridData.baseParams.SortInfo = sortInfor;
            alert(defaultPageSize);
            productGridData.load({ params: { limit: defaultPageSize, start: 0} });
        }
    },
    listeners:
	{
	    scope: this,
	    load: function() {
	    }
	}
});



        var defaultPageSize = 10;
        var toolBar = new Ext.PagingToolbar({
            pageSize: 10,
            store: productGridData,
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

        var sm = new Ext.grid.CheckboxSelectionModel({
            singleSelect: false
        });
        var productGrid = new Ext.grid.GridPanel({
            el: 'productGrid',
            width: '100%',
            height: '100%',
            //autoWidth:true,
            //autoHeight:true,
            autoScroll: true,
            layout: 'fit',
            id: '',
            store: productGridData,
            loadMask: { msg: '���ڼ������ݣ����Ժ��' },
            sm: sm,
            cm: new Ext.grid.ColumnModel([
		sm,
		new Ext.grid.RowNumberer(), //�Զ��к�
		{
		header: '���ID',
		dataIndex: 'ProductId',
		id: 'ProductId',
		hidden: true,
		hideable: false
},
		{
		    header: '������',
		    dataIndex: 'ProductNo',
		    id: 'ProductNo',
		    sortable: true,
		    width: 100
		},
		{
		    header: '�������',
		    dataIndex: 'ProductName',
		    id: 'ProductName',
		    sortable: true,
		    width: 170
		},
		{
		    header: '������',
		    dataIndex: 'MnemonicNo',
		    id: 'MnemonicNo',
		    sortable: true,
		    width: 75
		},
		{
		    header: '����',
		    dataIndex: 'OriginText',
		    id: 'OriginText',
		    sortable: true,
		    width: 80
		},
		{
		    header: '��Ӧ��',
		    dataIndex: 'SupplierText',
		    id: 'SupplierText',
		    sortable: true,
		    width: 150
		},
		{
		    header: '���',
		    dataIndex: 'SpecificationsText',
		    id: 'SpecificationsText',
		    sortable: true,
		    width: 40
		},
		{
		    header: '������',
		    dataIndex: 'UnitConvertRate',
		    id: 'UnitConvertRate',
		    sortable: true,
		    width: 50
		},
		{
		    header: '������λ',
		    dataIndex: 'UnitText',
		    id: 'UnitText',
		    sortable: true,
		    width: 60
		},
		{
		    header: '���۵���',
		    dataIndex: 'SalePrice',
		    id: 'SalePrice',
		    sortable: true,
		    width: 60
		},
		{
		    header: 'ȫ����Ʒ',
		    dataIndex: 'InUse',
		    id: 'IsAll',
		    sortable: true,
		    width: 100
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
        
        toolBar.addField(createPrintButton(productGridData, productGrid, ''));
        productGrid.render();

        createSearch(productGrid, productGridData, "searchForm12");
        searchForm.el = "searchForm12";
        searchForm.render();


//        txtFieldValue.on("focus", selectProductType);

//        function selectProductType() {
//            currentSelect = txtFieldValue;
//            selectShow(cmbField.getValue());
//        }
//        var selectedProductIds = "";
//        function selectProductOk() {
//            var selectProductNames = "";
//            selectedProductIds = "";
//            var selectNodes = selectProductTree.getChecked();
//            for (var i = 0; i < selectNodes.length; i++) {
//                if (selectProductNames != "") {
//                    selectProductNames += ",";
//                    selectedProductIds += ",";
//                }
//                selectProductNames += selectNodes[i].text;
//                selectedProductIds += selectNodes[i].id + '!' + selectNodes[i].text + '!' + selectNodes[i].attributes.CustomerColumn;
//            }
//            currentSelect.setValue(selectProductNames);
//        }

        this.getSelectedValue = function() {
            return "";
        }


        loadData();
    })

    function loadData() {
        productGridData.baseParams.SaltId = saltId;
        productGridData.load({ params: { limit: defaultPageSize, start: 0} });
    }
function getCmbStore(columnName) {

}
</script>
</html>