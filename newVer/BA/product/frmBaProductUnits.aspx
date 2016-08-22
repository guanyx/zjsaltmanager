<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmBaProductUnits.aspx.cs" Inherits="BA_product_frmBaProductUnits" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>�ޱ���ҳ</title>
    <meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<link rel="stylesheet" type="text/css" href="../../ext3/resources/css/ext-all.css" />
<script type="text/javascript" src="../../ext3/adapter/ext/ext-base.js"></script>
<script type="text/javascript" src="../../ext3/ext-all.js"></script>
<script type="text/javascript" src="../../ext3/example/ItemDeleter.js"></script>
<script type="text/javascript" src="../../js/operateResp.js"></script>
<style type="text/css">
.extensive-remove {
background-image: url(../../Theme/1/images/extjs/customer/cross.gif) ! important;
}
.x-grid-back-blue { 
background: #B7CBE8; 
}
</style>
</head>
<%=getComboBoxStore() %>
<script type="text/javascript">
    Ext.BLANK_IMAGE_URL = "../../ext3/resources/images/default/s.gif";
    Ext.onReady(function() {
        /*------ʵ��toolbar�ĺ��� start---------------*/
        var Toolbar = new Ext.Toolbar({
            renderTo: "toolbar",
            items: [{
                text: "����",
                icon: "../../Theme/1/images/extjs/customer/add16.gif",
                handler: function() {
                    inserNewBlankRow();
                }
            }, '-', {
                text: "����",
                icon: "../../Theme/1/images/extjs/customer/edit16.gif",
                handler: function() {
                    saveUnits();
                }
//            }, '-', {
//                text: "ɾ��",
//                icon: "../../Theme/1/images/extjs/customer/delete16.gif",
//                handler: function() {
//                }
            }]
            });

            function saveUnits() {
                json = "";
                ProductUnitsGridData.each(function(ProductUnitsGridData) {
                    json += Ext.util.JSON.encode(ProductUnitsGridData.data) + ',';
                });
                //json = json.substring(0, json.length - 1);

                Ext.MessageBox.wait("�������ڱ��棬���Ժ򡭡�");
                //Ȼ�����������
                Ext.Ajax.request({
                    url: 'frmBaProductUnits.aspx?method=save',
                    method: 'POST',
                    params: {
                        //��ϸ����
                        ProductUnits: json
                    },
                    success: function(resp, opts) {
                        Ext.MessageBox.hide();
                        if (checkParentExtMessage(resp, parent)) {
                            //parent.OrderMstGridData.reload();
                           // parent.uploadOrderWindow.hide();
                        }
                    },
                    failure: function(resp, opts) {
                        Ext.MessageBox.hide();
                        Ext.Msg.alert("��ʾ", "����ʧ��");
                    }


                });
            }
            /*------����toolbar�ĺ��� end---------------*/

            var RowPattern = Ext.data.Record.create([
	{ name: 'ProductId' },
	{ name: 'UnitId' },
	{ name: 'ToWeight' },
	{ name: 'ToVolume' },
	{ name: 'IsMinPackage',type:'bool' },
	{ name: 'UnitSpec'},
	{ name: 'Memo'}]);
            /*------��ʼ��ȡ���ݵĺ��� start---------------*/
            var ProductUnitsGridData = new Ext.data.Store
({
    url: 'frmBaProductUnits.aspx?method=getproductunits',
    reader: new Ext.data.JsonReader({
        totalProperty: 'totalProperty',
        root: 'root'
    }, [
	{
	    name: 'ProductId'
	},
	{
	    name: 'UnitId'
	},
	{
	    name: 'ToWeight'
	},
	{
	    name: 'ToVolume'
	},
	{
	    name: 'IsMinPackage'
	},
	{ name:'UnitSpec'},
	{
	    name: 'Memo'
}])
	,
    listeners:
	{
	    scope: this,
	    load: function() {
	    }
	}
});

            function inserNewBlankRow() {
                var rowCount = ProductUnitsGrid.getStore().getCount();
                var insertPos = parseInt(rowCount);
                var addRow = new RowPattern({
                    ProductId: productId,
                    UnitId: '0',
                    ToWeight: '0',
                    ToVolume: '0',
                    IsMinPackage: 'false',
                    UnitSpec:'',
                    Memo: ''
                });
                ProductUnitsGrid.stopEditing();
                //����һ����
                if (insertPos > 0) {
                    var rowIndex = ProductUnitsGridData.insert(insertPos, addRow);
                    ProductUnitsGrid.startEditing(insertPos, 0);
                }
                else {
                    var rowIndex = ProductUnitsGridData.insert(0, addRow);
                    ProductUnitsGrid.startEditing(0, 0);
                }
            }
            function addNewBlankRow(combo, record, index) {
                var rowIndex = ProductUnitsGrid.getStore().indexOf(ProductUnitsGrid.getSelectionModel().getSelected());
                var rowCount = ProductUnitsGrid.getStore().getCount();
                if ((rowIndex == 0 && rowCount == 1) || rowIndex == rowCount - 1) {
                    inserNewBlankRow();
                }
            }

            /*------��ȡ���ݵĺ��� ���� End---------------*/

            //������λ������
            var UnitCombo = new Ext.form.ComboBox({
                store: dsUnitList,
                displayField: 'UnitName',
                valueField: 'UnitId',
                triggerAction: 'all',
                id: 'UnitCombo',
                //pageSize: 5,  
                //minChars: 2,  
                //hideTrigger: true,  
                typeAhead: true,
                mode: 'local',
                emptyText: '',
                selectOnFocus: false,
                editable: false,
                listeners: {
                    "select": addNewBlankRow
                }
            });
            /*------��ʼDataGrid�ĺ��� start---------------*/

            var sm = new Ext.grid.CheckboxSelectionModel({
                singleSelect: true
            });
            var ProductUnitsGrid = new Ext.grid.EditorGridPanel({
                el: 'ProductUnitsGridDiv',
                width: '100%',
                height: '100%',
                autoScroll: true,
                layout: 'fit',
                id: 'ProductUnitsGrid',
                clicksToEdit: 1,
                store: ProductUnitsGridData,
                loadMask: { msg: '���ڼ������ݣ����Ժ��' },
                selModel: new Extensive.grid.ItemDeleter(),
                cm: new Ext.grid.ColumnModel([
		sm,
		new Ext.grid.RowNumberer(), //�Զ��к�
		{
		header: '�����Ϣ',
		dataIndex: 'ProductId',
		id: 'ProductId',
		//		editor: new Ext.form.TextField({}),
		hidden: true
},
		{
		    header: '��λ��Ϣ',
		    dataIndex: 'UnitId',
		    id: 'UnitId',
		    editor: UnitCombo,
		    renderer: function(value, cellmeta, record, rowIndex, columnIndex, store) {
		        var index = dsUnitList.findBy(function(record, id) {
		            return record.get(UnitCombo.valueField) == value;
		        });
		        var record = dsUnitList.getAt(index);
		        var displayText = "";
		        // ��������б�û�б�ѡ����ôrecordҲ�Ͳ����ڣ���ʱ�򣬷��ش�������value��
		        // �����value����grid��USER_REALNAME�е�value������ֱ�ӷ���
		        if (record == null) {
		            //����Ĭ��ֵ��
		            displayText = value;
		        } else {
		            displayText = record.data.UnitName; //��ȡrecord�е����ݼ��е�process_name�ֶε�ֵ
		        }
		        return displayText;
		    }

		},
		{
		    header: '���',
		    dataIndex: 'UnitSpec',
		    id: 'UnitSpec',
		    editor: new Ext.form.TextField({})
		},
		{
		    header: 'ת��Ϊ������',
		    dataIndex: 'ToWeight',
		    id: 'ToWeight',
		    editor: new Ext.form.TextField({})
		},
		{
		    header: 'ת��Ϊ�����',
		    dataIndex: 'ToVolume',
		    id: 'ToVolume',
		    editor: new Ext.form.TextField({})
		},
		{
		    header: '�Ƿ���С��װ',
		    dataIndex: 'IsMinPackage',
		    id: 'IsMinPackage',
		    editor: new Ext.form.TextField({})
		},
		{
		    header: '��ע',
		    dataIndex: 'Memo',
		    id: 'Memo',
		    editor: new Ext.form.TextField({})
		}, new Extensive.grid.ItemDeleter()]),
                bbar: new Ext.PagingToolbar({
                    pageSize: 10,
                    store: ProductUnitsGridData,
                    displayMsg: '��ʾ��{0}����{1}����¼,��{2}��',
                    emptyMsy: 'û�м�¼',
                    displayInfo: true
                }),
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
            ProductUnitsGrid.render();
            /*------DataGrid�ĺ������� End---------------*/

            this.loadData = function() {
                ProductUnitsGridData.removeAll();
                if (productId > 0) {
                    ProductUnitsGridData.baseParams.ProductId = productId;
                    ProductUnitsGridData.load({ params: { limit: 100, start: 0} });
                }
                inserNewBlankRow();
            };
            loadData();
        })
</script>
<body>
<div id='toolbar'></div>
<div id='divForm'></div>
<div id='ProductUnitsGridDiv'></div>

</body>
</html>