<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmWmsPurchaseAdjust.aspx.cs" Inherits="WMS_frmWmsPurchaseAdjust" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html>
<head>
<title>�ɹ���������ѯҳ��</title><meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<link rel="stylesheet" type="text/css" href="../ext3/resources/css/ext-all.css" />
<script type="text/javascript" src="../ext3/adapter/ext/ext-base.js"></script>
<script type="text/javascript" src="../ext3/ext-all.js"></script>
<script type="text/javascript" src="../ext3/src/locale/ext-lang-zh_CN.js"></script>
</head>
<body>
<div id='toolbar'></div>
<div id='divForm'></div>
<div id='seachFormDiv'></div>
<div id='userGridDiv'></div>


</body>
<%=getComboBoxStore() %>

<script type="text/javascript">
Ext.BLANK_IMAGE_URL = "../ext3/resources/images/default/s.gif";
Ext.onReady(function() {
        
function updateDataGrid() {
    var WhId = WhNamePanel.getValue();
    //var OrgId = OrgNamePanel.getValue();
    var ProductId = ProductNamePanel.getValue();
    var StartDate = Ext.util.Format.date(StartDatePanel.getValue(),'Y/m/d');
    var EndDate = Ext.util.Format.date(EndDatePanel.getValue(),'Y/m/d');
        
    userGridData.baseParams.WhId = WhId;
    //userGridData.baseParams.OrgId = OrgId;
    userGridData.baseParams.ProductId = ProductId;
    userGridData.baseParams.StartDate = StartDate;
    userGridData.baseParams.EndDate = EndDate;
    userGridData.load({
        params: {
            start: 0,
            limit: 10
        }
    });
}

/*------��ʼ��ȡ���ݵĺ��� start---------------*/
var userGridData = new Ext.data.Store
({
    url: 'frmWmsPurchaseAdjust.aspx?method=getPurchaseAdjustList',
    reader: new Ext.data.JsonReader({
        totalProperty: 'totalProperty',
        root: 'root'
    }, [
	{	    name: 'AdjustId'	},
	{	    name: 'OrgId'	},
	{	    name: 'WhId'	},
	{	    name: 'ProductId'	},
	{	    name: 'ProductQty'	}, 
	{	    name: 'ProductCode'	}, 
	{	    name: 'ProductName'	}, 
	{	    name: 'ProductSpec'	}, 
	{	    name: 'ProductUnit'	}, 
    {	    name: 'ProductPrice'    },
    {	    name: 'AdjustAmount'	},
    {	    name: 'FromBillType'	},
    {	    name: 'FromBillId'	},
    {	    name: 'CreateDate'	},
    {	    name: 'OperId'	}
    ])	,
    listeners:
	{
	    scope: this,
	    load: function() {
	    }
	}
});
/*------����------Start-----------------------*/
var WhNamePanel = new Ext.form.ComboBox({
    fieldLabel: '�ֿ�����',
    name: 'warehouseCombo',
    store: dsWarehouseList,
    displayField: 'WhName',
    valueField: 'WhId',
    typeAhead: true, //�Զ�����һ����������ѡ�ȫ����
    triggerAction: 'all',
    emptyText: '��ѡ��ֿ�',
    selectOnFocus: true,
    forceSelection: true,
    anchor: '90%',
    mode: 'local',
    listeners: { specialkey: function(f, e) { if (e.getKey() == e.ENTER) { Ext.getCmp('ProductId').focus(); } } }
});
var ProductNamePanel = new Ext.form.ComboBox({
    fieldLabel: '��Ʒ����',
    name: 'productCombo',
    store: dsProductList,
    displayField: 'ProductName',
    valueField: 'ProductId',
    typeAhead: true, //�Զ�����һ����������ѡ�ȫ����
    triggerAction: 'all',
    emptyText: '��ѡ����Ʒ',
    //valueNotFoundText: 0,
    selectOnFocus: true,
    forceSelection: true,
    id: 'ProductId',
    anchor: '90%',
    mode: 'local',
    listeners: { specialkey: function(f, e) { if (e.getKey() == e.ENTER) { Ext.getCmp('StartDate').focus(); } } }

});

var StartDatePanel = new Ext.form.DateField({
        style: 'margin-left:0px',
        cls: 'key',
        xtype: 'datefield',
        fieldLabel: '��ʼʱ��',
        format: 'Y��m��d��',
        anchor: '90%',
        value: new Date().getFirstDateOfMonth().clearTime(),
        id: 'StartDate',
        listeners: { specialkey: function(f, e) { if (e.getKey() == e.ENTER) { Ext.getCmp('EndDate').focus(); } } }
    });
    var EndDatePanel = new Ext.form.DateField({
        style: 'margin-left:0px',
        cls: 'key',
        xtype: 'datefield',
        fieldLabel: '����ʱ��',
        anchor: '90%',
        format: 'Y��m��d��',
        id: 'EndDate',
        value: new Date().clearTime(),
        listeners: { specialkey: function(f, e) { if (e.getKey() == e.ENTER) { Ext.getCmp('searchebtnId').focus(); } } }
    });
var serchform = new Ext.FormPanel({
    renderTo: 'seachFormDiv',
    labelAlign: 'left',
    buttonAlign: 'right',
    bodyStyle: 'padding:5px',
    frame: true,
    labelWidth: 55,
    items: [
    {
        layout: 'column',   //�����Ԫ��Ϊ����Ϊ�в��ַ�ʽ
        border: false,
        items: [{
            columnWidth: .4,
            layout: 'form',
            border: false,
            items: [
                WhNamePanel
                ]
        }, {
            columnWidth: .4,
            layout: 'form',
            border: false,
            items: [
                ProductNamePanel
                ]
        }]
        },{
        layout: 'column',   //�����Ԫ��Ϊ����Ϊ�в��ַ�ʽ
        border: false,
        items: [{
            columnWidth: .4,
            layout: 'form',
            border: false,
            items: [
                StartDatePanel
                ]
        }, {
            columnWidth: .4,
            layout: 'form',
            border: false,
            items: [
                EndDatePanel
                ]
        }, {
            columnWidth: .2,
            layout: 'form',
            border: false,
            items: [{ cls: 'key',
                xtype: 'button',
                text: '��ѯ',
                id: 'searchebtnId',
                anchor: '50%',
                handler: function() {
                    updateDataGrid();
                }
            }]
        }]
    }]
});
/*------����------END-------------------------*/

/*------��ȡ���ݵĺ��� ���� End---------------*/

/*------��ʼDataGrid�ĺ��� start---------------*/
var userGrid = new Ext.grid.GridPanel({
    el: 'userGridDiv',
    width: '100%',
    height: '100%',
    autoWidth: true,
    autoHeight: true,
    autoScroll: true,
    layout: 'fit',
    id: 'aa',
    store: userGridData,
    loadMask: { msg: '���ڼ������ݣ����Ժ��' },
    cm: new Ext.grid.ColumnModel([
	new Ext.grid.RowNumberer(), //�Զ��к�
	{
        header: '�ֿ�����',
        dataIndex: 'WhId',
        id: 'WhId',
        width: 80,
        renderer: function(val, params, record) {
            if (dsWarehouseList.getCount() == 0) {
                dsWarehouseList.load();
            }
            dsWarehouseList.each(function(r) {
                if (val == r.data['WhId']) {
                    val = r.data['WhName'];
                    return;
                }
            });
            return val;
        }
        },
        {
            header: '����',
            dataIndex: 'ProductCode',
            id: 'ProductCode',
            width:60
        },
        {
            header: '��Ʒ����',
            dataIndex: 'ProductName',
            id: 'ProductName',
            width:200
        },
        {
            header: '���',
            dataIndex: 'ProductSpec',
            id: 'ProductSpec',
            width:60
        },
        {
            header: '��λ',
            dataIndex: 'ProductUnit',
            id: 'ProductUnit',
            width:40

        },
        {
            header: '�����۸�',
            dataIndex: 'ProductPrice',
            id: 'ProductPrice',
            width:70
        },
        {
            header: '�������',
            dataIndex: 'ProductQty',
            id: 'ProductQty',
            width:70
        },
        {
            header: '�������',
            dataIndex: 'AdjustAmount',
            id: 'AdjustAmount',
            hide: true,
            width:80
        },
        {
            header: '��������',
            dataIndex: 'CreateDate',
            id: 'CreateDate',
            width:120
        }
        ]),
        bbar: new Ext.PagingToolbar({
            pageSize: 16,
            store: userGridData,
            displayMsg: '��ʾ��{0}����{1}����¼,��{2}��',
            emptyMsy: 'û�м�¼',
            displayInfo: true
        }),
        viewConfig: {
            columnsText: '��ʾ����',
            scrollOffset: 20,
            sortAscText: '����',
            sortDescText: '����'//,
            //forceFit: true
        },
        height: 280,
        closeAction: 'hide',
        stripeRows: true,
        loadMask: true//,
        //autoExpandColumn: 2
    });
    userGrid.render();
    /*------DataGrid�ĺ������� End---------------*/

    updateDataGrid();

})
</script>

</html>

