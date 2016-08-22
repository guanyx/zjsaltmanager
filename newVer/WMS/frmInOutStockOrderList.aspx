<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmInOutStockOrderList.aspx.cs" Inherits="WMS_frmInOutStockOrderList" %>

<html>
<head>
<title>�����ֵ����б�ҳ��</title><meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<link rel="stylesheet" type="text/css" href="../ext3/resources/css/ext-all.css" />
<script type="text/javascript" src="../ext3/adapter/ext/ext-base.js"></script>
<script type="text/javascript" src="../ext3/ext-all.js"></script>
<script type="text/javascript" src="../ext3/src/locale/ext-lang-zh_CN.js"></script>
</head>
<body>
<div id='toolbar'></div>
<div id='divSearchForm'></div>
<div id='divForm'></div>
<div id='divOrderGrid'></div>

</body>
<%=getComboBoxStore()%>
<script type="text/javascript">
    Ext.BLANK_IMAGE_URL = "../ext3/resources/images/default/s.gif";
    Ext.onReady(function() {
        /*------ʵ��toolbar�ĺ��� start---------------*/
        var Toolbar = new Ext.Toolbar({
            renderTo: "toolbar",
            items: [{
                text: "������ֵ�",
                icon: "../theme/1/images/extjs/customer/add16.gif",
                handler: function() { generateInStockOrderWin(); }
            }, '-', {
                text: "�鿴������",
                icon: "../theme/1/images/extjs/customer/edit16.gif",
                handler: function() { lookOrderWin(); }
            }]
            });

            /*------����toolbar�ĺ��� end---------------*/


            /*------��ʼToolBar�¼����� start---------------*//*-----����Orderʵ���ര�庯��----*/
            function updateDataGrid() {

                var WhId = WhNamePanel.getValue();
                var SupplierId = SupplierNamePanel.getValue();
                var StartDate = Ext.util.Format.date(StartDatePanel.getValue(),'Y/m/d');
                var EndDate = Ext.util.Format.date(EndDatePanel.getValue(),'Y/m/d');
                var BillStatus = BillStatusPanel.getValue();
                userGridData.load({
                    params: {
                        start: 0,
                        limit: 10,
                        WhId: WhId,
                        SupplierId: SupplierId,
                        StartDate: StartDate,
                        EndDate: EndDate,
                        BillStatus: BillStatus
                    }
                });

            }
            //������ⵥ
            function generateInStockOrderWin() {
                var sm = userGrid.getSelectionModel();
                //��ȡѡ���������Ϣ
                var selectData = sm.getSelected();
                if (selectData == null) {
                    Ext.Msg.alert("��ʾ", "��ѡ���������¼��");
                    return;
                }
                if (selectData.data.BillStatus != 0)//����δ���״̬
                {
                    Ext.Msg.alert("��ʾ", "ֻ��δ��ֵĽ�������������ֲ�����");
                    return;
                }
                uploadOrderWindow.show();
                document.getElementById("editIFrame").src = "frmInStockBill.aspx?type=W0201&id=" + selectData.data.OrderId;
            }
            /*-----�쿴Orderʵ���ര�庯��----*/
            function lookOrderWin() {
                var sm = userGrid.getSelectionModel();
                //��ȡѡ���������Ϣ
                var selectData = sm.getSelected();
                if (selectData == null) {
                    Ext.Msg.alert("��ʾ", "��ѡ����Ҫ�鿴����Ϣ��");
                    return;
                }
                uploadPurchaseOrderWindow.show();
                document.getElementById("editPurchaseIFrame").src = "frmPurchaseOrderEdit.aspx?status=readonly&id=" + selectData.data.OrderId;
            }


            /*------��ʼ�������ݵĴ��� Start---------------*/
            if (typeof (uploadOrderWindow) == "undefined") {//�������2��windows����
                uploadOrderWindow = new Ext.Window({
                    id: 'Orderformwindow'
		            , iconCls: 'upload-win'
		            , width: 750
		            , height: 555
		            , layout: 'fit'
		            , plain: true
		            , modal: true
		            , constrain: true
		            , resizable: false
		            , closeAction: 'hide'
		            , autoDestroy: true
		            , html: '<iframe id="editIFrame" width="100%" height="100%" border=0 src="frmInStockBill.aspx"></iframe>'

                });
            }
            uploadOrderWindow.addListener("hide", function() {
            });

            if (typeof (uploadPurchaseOrderWindow) == "undefined") {//�������2��windows����
                uploadPurchaseOrderWindow = new Ext.Window({
                id: 'PurchaseOrderWindow'
		            , iconCls: 'upload-win'
		            , width: 750
		            , height: 480
		            , layout: 'fit'
		            , plain: true
		            , modal: true
		            , constrain: true
		            , resizable: false
		            , closeAction: 'hide'
		            , autoDestroy: true
		            , html: '<iframe id="editPurchaseIFrame" width="100%" height="100%" border=0 src="frmPurchaseOrderEdit.aspx"></iframe>'

                });
            }
            uploadPurchaseOrderWindow.addListener("hide", function() {
        });
            
            /*------��ʼ��ȡ�������ݵĺ��� start---------------*/
            function getFormValue() {
                var dateCreateDate = Ext.get("CreateDate").getValue();
                if (dateCreateDate != '')
                    dateCreateDate = Ext.util.Format.date(dateCreateDate,'Y/m/d');

                Ext.Ajax.request({
                    url: 'frmInOutStockOrderList.aspx?method=SaveOrder',
                    method: 'POST',
                    params: {
                        OrderId: Ext.getCmp('OrderId').getValue(),
                        SupplierId: Ext.getCmp('SupplierId').getValue(),
                        WhId: Ext.getCmp('WhId').getValue(),
                        OrgId: Ext.getCmp('OrgId').getValue(),
                        OwnerId: Ext.getCmp('OwnerId').getValue(),
                        OperId: Ext.getCmp('OperId').getValue(),
                        CreateDate: dateCreateDate,
                        UpdateDate: Ext.getCmp('UpdateDate').getValue(),
                        BillType: Ext.getCmp('BillType').getValue(),
                        FromBillId: Ext.getCmp('FromBillId').getValue(),
                        BillStatus: Ext.getCmp('BillStatus').getValue(),
                        Remark: Ext.getCmp('Remark').getValue()
                    },
                    success: function(resp, opts) {
                        Ext.Msg.alert("��ʾ", "����ɹ���");
                    },
                    failure: function(resp, opts) {
                        Ext.Msg.alert("��ʾ", "����ʧ�ܣ�");
                    }
                });
            }
            /*------������ȡ�������ݵĺ��� End---------------*/

            /*------��ʼ�������ݵĺ��� Start---------------*/
            function setFormValue(selectData) {
                Ext.Ajax.request({
                    url: 'frmInOutStockOrderList.aspx?method=getInOutStockOrder',
                    params: {
                        OrderId: selectData.data.OrderId
                    },
                    success: function(resp, opts) {
                        var data = Ext.util.JSON.decode(resp.responseText);
                        Ext.getCmp("OrderId").setValue(data.OrderId);
                        Ext.getCmp("SupplierId").setValue(data.SupplierId);
                        Ext.getCmp("WhId").setValue(data.WhId);
                        Ext.getCmp("OrgId").setValue(data.OrgId);
                        Ext.getCmp("OwnerId").setValue(data.OwnerId);
                        Ext.getCmp("OperId").setValue(data.OperId);
                        if (data.CreateDate != '')
                            Ext.getCmp("CreateDate").setValue(Ext.util.Format.date(data.CreateDate,'Y/m/d'));
                        Ext.getCmp("UpdateDate").setValue(data.UpdateDate);
                        Ext.getCmp("BillType").setValue(data.BillType);
                        Ext.getCmp("FromBillId").setValue(data.FromBillId);
                        Ext.getCmp("BillStatus").setValue(data.BillStatus);
                        Ext.getCmp("Remark").setValue(data.Remark);
                    },
                    failure: function(resp, opts) {
                        Ext.Msg.alert("��ʾ", "��ȡ������Ϣʧ�ܣ�");
                    }
                });
            }
            /*------�������ý������ݵĺ��� End---------------*/

            /*------��ʼ��ѯform�ĺ��� start---------------*/

            var SupplierNamePanel = new Ext.form.ComboBox({
                name: 'supplierCombo',
                store: dsSuppliesListInfo,
                displayField: 'ChineseName',
                valueField: 'CustomerId',
                typeAhead: true, //�Զ�����һ����������ѡ�ȫ����
                triggerAction: 'all',
                emptyText: '��ѡ��Ӧ��',
                selectOnFocus: true,
                forceSelection: true,
                mode: 'local',
                fieldLabel: '��Ӧ��',
                anchor: '90%',
                listeners: { specialkey: function(f, e) { if (e.getKey() == e.ENTER) { Ext.getCmp('SWhName').focus(); } } }

            });


            var WhNamePanel = new Ext.form.ComboBox({
                name: 'warehouseCombo',
                store: dsWarehouseList,
                displayField: 'WhName',
                valueField: 'WhId',
                typeAhead: true, //�Զ�����һ����������ѡ�ȫ����
                triggerAction: 'all',
                emptyText: '��ѡ��ֿ�',
                selectOnFocus: true,
                forceSelection: true,
                mode: 'local',
                fieldLabel: '�ֿ�����',
                anchor: '90%',
                id: 'SWhName',
                listeners: { specialkey: function(f, e) { if (e.getKey() == e.ENTER) { Ext.getCmp('BillStatus').focus(); } } }
            });

            var BillStatusPanel = new Ext.form.ComboBox({
                name: 'billStatusCombo',
                store: dsBillStatus,
                displayField: 'BillStatusName',
                valueField: 'BillStatusId',
                typeAhead: true, //�Զ�����һ����������ѡ�ȫ����
                triggerAction: 'all',
                value: 0, //δ���
                selectOnFocus: true,
                forceSelection: true,
                editable: false,
                mode: 'local',
                fieldLabel: '����״̬',
                anchor: '90%',
                id: 'BillStatus',
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
                renderTo: 'divSearchForm',
                labelAlign: 'left',
                //layout: 'fit',
                buttonAlign: 'right',
                bodyStyle: 'padding:5px',
                frame: true,
                labelWidth: 55,
                items: [{
                    layout: 'column',   //�����Ԫ��Ϊ����Ϊ�в��ַ�ʽ
                    border: false,
                    items: [{
                        columnWidth: .3,  //����ռ�õĿ�ȣ���ʶΪ20��
                        layout: 'form',
                        border: false,
                        items: [
                        SupplierNamePanel
                    ]
                    }, {
                        columnWidth: .3,
                        layout: 'form',
                        border: false,
                        items: [
                        WhNamePanel
                        ]
                    }, {
                        columnWidth: .3,
                        layout: 'form',
                        border: false,
                        items: [
                        BillStatusPanel
                        ]
                    }
                    ]
                }
                    ,
                    {

                        layout: 'column',   //�����Ԫ��Ϊ����Ϊ�в��ַ�ʽ
                        border: false,
                        items: [{
                            columnWidth: .3,  //����ռ�õĿ�ȣ���ʶΪ20��
                            layout: 'form',
                            border: false,
                            items: [
                        StartDatePanel
                    ]
                        }, {
                            columnWidth: .3,
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


            /*------��ʼ��ѯform�ĺ��� end---------------*/

            /*------��ʼ��ȡ���ݵĺ��� start---------------*/
            var userGridData = new Ext.data.Store
({
    url: 'frmInOutStockOrderList.aspx?method=getInOutStockOrderList',
    reader: new Ext.data.JsonReader({
        totalProperty: 'totalProperty',
        root: 'root'
    }, [
	{
	    name: 'OrderId'
	},
	{
	    name: 'SupplierId'
	},
	{
	    name: 'WhId'
	},
	{
	    name: 'OrgId'
	},
	{
	    name: 'OwnerId'
	},
	{
	    name: 'OperId'
	},
	{
	    name: 'CreateDate'
	},
	{
	    name: 'UpdateDate'
	},
	{
	    name: 'BillType'
	},
	{
	    name: 'FromBillId'
	},
	{
	    name: 'BillStatus'
	},
	{
	    name: 'CarBoatNo'
	},
	{
	    name: 'Remark'
	},
	{
	    name: 'SupplierName'
	},
	{
	    name: 'OperName'
	}
])
	,
    listeners:
	{
	    scope: this,
	    load: function() {
	    }
	}
});

            /*------��ȡ���ݵĺ��� ���� End---------------*/

            /*------��ʼDataGrid�ĺ��� start---------------*/

            var sm = new Ext.grid.CheckboxSelectionModel({
                singleSelect: true
            });
            var userGrid = new Ext.grid.GridPanel({
                el: 'divOrderGrid',
                width: '100%',
                height: '100%',
                autoWidth: true,
                autoHeight: true,
                autoScroll: true,
                layout: 'fit',
                id: '',
                store: userGridData,
                loadMask: { msg: '���ڼ������ݣ����Ժ��' },
                sm: sm,
                cm: new Ext.grid.ColumnModel([
		sm,
		new Ext.grid.RowNumberer(), //�Զ��к�
		{
		header: '������',
		dataIndex: 'OrderId',
		id: 'OrderId'
},
		{
		    header: '��Ӧ��',
		    dataIndex: 'SupplierName',
		    id: 'SupplierName'
		},
		{
		    header: '�ֿ�',
		    dataIndex: 'WhId',
		    id: 'WhId',
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
                //		{
                //			header:'��֯ID',
                //			dataIndex:'OrgId',
                //			id:'OrgId'
                //		},
                //		{
                //			header:'������ID',
                //			dataIndex:'OwnerId',
                //			id:'OwnerId'
                //		},
		{
		header: '������',
		dataIndex: 'OperName',
		id: 'OperName'
},
		{
		    header: '����ʱ��',
		    dataIndex: 'CreateDate',
		    id: 'CreateDate',
		    format: 'Y��m��d��'
		},
                //		{
                //			header:'����ʱ��',
                //			dataIndex:'UpdateDate',
                //			id:'UpdateDate'
                //		},
		{
		header: '��������',
		dataIndex: 'BillType',
		id: 'BillType',
		renderer: function(val, params, record) {
		    if (dsBillType.getCount() == 0) {
		        dsBillType.load();
		    }
		    dsBillType.each(function(r) {
		        if (val == r.data['DicsCode']) {
		            val = r.data['DicsName'];
		            return;
		        }
		    });
		    return val;
		}
},
                //		{
                //		    header: '��Դ���ݺ�',
                //		    dataIndex: 'FromBillId',
                //		    id: 'FromBillId'
                //		},
		{
		header: '����״̬',
		dataIndex: 'BillStatus',
		id: 'BillStatus',
		renderer: function(val, params, record) {
		    if (dsBillStatus.getCount() == 0) {
		        dsBillStatus.load();
		    }
		    dsBillStatus.each(function(r) {
		        if (val == r.data['BillStatusId']) {
		            val = r.data['BillStatusName'];
		            return;
		        }
		    });
		    return val;
		}
},
		{
		    header: '������',
		    dataIndex: 'CarBoatNo',
		    id: 'CarBoatNo'
		},
		{
		    header: '��ע',
		    dataIndex: 'Remark',
		    id: 'Remark'
}]),
                bbar: new Ext.PagingToolbar({
                    pageSize: 10,
                    store: userGridData,
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
            userGrid.render();
            /*------DataGrid�ĺ������� End---------------*/
            updateDataGrid();


        })
</script>

</html>
