<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmInitWarehouse.aspx.cs" Inherits="WMS_frmInitWarehouse" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html>
<head>
<title>�ֿ��ʼ��ҳ��</title><meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<link rel="stylesheet" type="text/css" href="../ext3/resources/css/ext-all.css" />
<script type="text/javascript" src="../ext3/adapter/ext/ext-base.js"></script>
<script type="text/javascript" src="../ext3/ext-all.js"></script>
<script type="text/javascript" src="../ext3/example/TabCloseMenu.js" charset="gb2312"></script>
<script type="text/javascript" src="../js/operateResp.js"></script>
</head>
<body>
<div id='toolbar'></div>
<div id='divSearchForm'></div>
<div id='divDataGrid'></div>

</body>
<%=getComboBoxStore()%>
<script type="text/javascript">
    Ext.BLANK_IMAGE_URL = "../ext3/resources/images/default/s.gif";
    Ext.onReady(function() {

        /*------ʵ��toolbar�ĺ��� start---------------*/
        var Toolbar = new Ext.Toolbar({
            renderTo: "toolbar",
            items: [{
                text: "����",
                icon: "../Theme/1/images/extjs/customer/add16.gif",
                handler: function() { openAddOrderWin(); }
            }, '-', {
                text: "�༭",
                icon: "../Theme/1/images/extjs/customer/edit16.gif",
                handler: function() { modifyOrderWin(); }
            }, '-', {
                text: "ɾ��",
                icon: "../Theme/1/images/extjs/customer/delete16.gif",
                handler: function() { deleteOrder(); }
            }, '-', {
                text: "�ύ",
                icon: "../Theme/1/images/extjs/customer/edit16.gif",
                handler: function() { commitOrder(); }
            }, '-', {
                text: "�鿴",
                icon: "../Theme/1/images/extjs/customer/delete16.gif",
                handler: function() { lookOrderWin(); }
}]
            });

            /*------����toolbar�ĺ��� end---------------*/


            /*------��ʼToolBar�¼����� start---------------*//*-----����Orderʵ���ര�庯��----*/
            function openAddOrderWin() {
                uploadOrderWindow.setTitle("�����ֿ��ʼ��");
                uploadOrderWindow.show();
                document.getElementById("editIFrame").src = "frmInitWarehouseEdit.aspx";
            }

            /*-----�༭Orderʵ���ര�庯��----*/
            function modifyOrderWin() {
                var sm = initWarehouseGrid.getSelectionModel();
                //��ȡѡ���������Ϣ
                var selectData = sm.getSelected();
                if (selectData == null) {
                    Ext.Msg.alert("��ʾ", "��ѡ����Ҫ�༭����Ϣ��");
                    return;
                }
                if (selectData.data.Status == 1) {
                    Ext.Msg.alert("��ʾ", "�òֿ��Ѿ���ʼ����ɣ����ܱ༭��");
                    return;
                }
                uploadOrderWindow.setTitle("�༭�ֿ��ʼ��");
                uploadOrderWindow.show();
                document.getElementById("editIFrame").src = "frmInitWarehouseEdit.aspx?id=" + selectData.data.OrderId;
            }
            function lookOrderWin() {
                var sm = initWarehouseGrid.getSelectionModel();
                //��ȡѡ���������Ϣ
                var selectData = sm.getSelected();
                if (selectData == null) {
                    Ext.Msg.alert("��ʾ", "��ѡ����Ҫ�鿴����Ϣ��");
                    return;
                }
                uploadOrderWindow.setTitle("�鿴�ֿ��ʼ��");
                uploadOrderWindow.show();
                document.getElementById("editIFrame").src = "frmInitWarehouseEdit.aspx?type=look&id=" + selectData.data.OrderId;
            }
            /*-----ɾ��Orderʵ�庯��----*/
            /*ɾ����Ϣ*/
            function deleteOrder() {
                var sm = initWarehouseGrid.getSelectionModel();
                //��ȡѡ���������Ϣ
                var selectData = sm.getSelected();
                //���û��ѡ�񣬾���ʾ��Ҫѡ��������Ϣ
                if (selectData == null) {
                    Ext.Msg.alert("��ʾ", "��ѡ����Ҫɾ������Ϣ��");
                    return;
                }
                if (selectData.data.Status == 1) {
                    Ext.Msg.alert("��ʾ", "�òֿ��Ѿ���ʼ����ɣ�����ɾ����");
                    return;
                }
                //ɾ��ǰ�ٴ������Ƿ����Ҫɾ��
                Ext.Msg.confirm("��ʾ��Ϣ", "�Ƿ����Ҫɾ��ѡ��Ĳֿ���Ϣ��", function callBack(id) {
                    //�ж��Ƿ�ɾ������
                    if (id == "yes") {
                        //ҳ���ύ
                        Ext.Ajax.request({
                            url: 'frmInitWarehouse.aspx?method=deleteInitWarehouse',
                            method: 'POST',
                            params: {
                                OrderId: selectData.data.OrderId
                            },
                            success: function(resp, opts) {
                                if (checkExtMessage(resp)) {
                                    //updateDataGrid();
                                }
                            }
                        });
                    }
                });
            }
            function commitOrder() {
                var sm = initWarehouseGrid.getSelectionModel();
                //��ȡѡ���������Ϣ
                var selectData = sm.getSelected();
                //���û��ѡ�񣬾���ʾ��Ҫѡ��������Ϣ
                if (selectData == null) {
                    Ext.Msg.alert("��ʾ", "��ѡ����Ҫ�ύ����Ϣ��");
                    return;
                }
                if (selectData.data.Status == 1) {
                    Ext.Msg.alert("��ʾ", "�òֿ��Ѿ���ʼ����ɣ������ظ��ύ��");
                    return;
                }
                //ɾ��ǰ�ٴ������Ƿ����Ҫɾ��
                Ext.Msg.confirm("��ʾ��Ϣ", "�Ƿ����Ҫ�ύѡ��Ĳֿ���Ϣ��", function callBack(id) {
                    //�ж��Ƿ�ɾ������
                    if (id == "yes") {
                        //ҳ���ύ
                        Ext.Ajax.request({
                            url: 'frmInitWarehouse.aspx?method=commitInitWarehouse',
                            method: 'POST',
                            params: {
                                OrderId: selectData.data.OrderId
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
            function updateDataGrid() {
                var WhName = WhNamePanel.getValue();

                initWarehouseGridData.baseParams.WhId = WhName;
                initWarehouseGridData.baseParams.IsInitBill = 0;
                initWarehouseGridData.baseParams.start = 0;
                initWarehouseGridData.baseParams.limit = 10;                
                initWarehouseGridData.load();
            }


            var WhNamePanel = new Ext.form.ComboBox({
                fieldLabel: '�ֿ�����',
                name: 'warehouseCombo',
                store: dsWarehouseList,
                displayField: 'WhName',
                valueField: 'WhId',
                typeAhead: true, //�Զ�����һ����������ѡ�ȫ����
                triggerAction: 'all',
                emptyText: '��ѡ��ֿ�',
                emptyValue: '',
                selectOnFocus: true,
                forceSelection: true,
                anchor: '90%',
                mode: 'local',
                listeners: { specialkey: function(f, e) { if (e.getKey() == e.ENTER) { Ext.getCmp('searchebtnId').focus(); } } //,
                    // blur: function(field) { if (field.getRawValue() == '') { field.clearValue(); } } 
                }

            });

            var serchform = new Ext.FormPanel({
                renderTo: 'divSearchForm',
                labelAlign: 'left',
                layout: 'fit',
                buttonAlign: 'right',
                bodyStyle: 'padding:5px',
                frame: true,
                labelWidth: 55,
                items: [{
                    layout: 'column',   //�����Ԫ��Ϊ����Ϊ�в��ַ�ʽ
                    border: false,
                    items: [{
                        columnWidth: .2,  //����ռ�õĿ�ȣ���ʶΪ20��
                        layout: 'form',
                        border: false,
                        items: [
                        WhNamePanel
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
                        }, {
                            columnWidth: .6,
                            layout: 'form',
                            border: false

}]
}]
}]
                        });


                        /*------��ʼ��ѯform�ĺ��� end---------------*/

                        /*------��ʼ�������ݵĴ��� Start---------------*/
                        if (typeof (uploadOrderWindow) == "undefined") {//�������2��windows����
                            uploadOrderWindow = new Ext.Window({
                                id: 'Orderformwindow',
                                iconCls: 'upload-win'
		                        , width: 700
		                        , height: 462
		                        , layout: 'fit'
		                        , plain: true
		                        , modal: true
		                        , constrain: true
		                        , resizable: false
		                        , closeAction: 'hide'
		                        , autoDestroy: true
		                        , html: '<iframe id="editIFrame" width="100%" height="100%" border=0 src="frmInitWarehouseEdit.aspx"></iframe>'//initWarehouseForm

                            });
                        }
                        uploadOrderWindow.addListener("hide", function() {
                            updateDataGrid();
                        });

                        /*------��ʼ��ȡ�������ݵĺ��� start---------------*/
                        function getFormValue() {
                            Ext.Ajax.request({
                                url: 'frmInitWarehouse.aspx?method=saveInitWarehouse',
                                method: 'POST',
                                params: {
                                    OrderId: Ext.getCmp('OrderId').getValue(),
                                    OrgId: Ext.getCmp('OrgId').getValue(),
                                    WhId: Ext.getCmp('WhId').getValue(),
                                    OperId: Ext.getCmp('OperId').getValue(),
                                    InventoryDate: Ext.getCmp('InventoryDate').getValue(),
                                    OwnerId: Ext.getCmp('OwnerId').getValue(),
                                    Remark: Ext.getCmp('Remark').getValue(),
                                    IsInitBill: Ext.getCmp('IsInitBill').getValue(),
                                    Status: Ext.getCmp('Status').getValue(),
                                    CreateDate: Ext.getCmp('CreateDate').getValue(),
                                    UpdateDate: Ext.getCmp('UpdateDate').getValue()
                                },
                                success: function(resp, opts) {
                                    if (checkExtMessage(resp)) {

                                    }
                                }
                            });
                        }
                        /*------������ȡ�������ݵĺ��� End---------------*/



                        /*------��ʼ��ȡ���ݵĺ��� start---------------*/
                        var initWarehouseGridData = new Ext.data.Store
                        ({
                            url: 'frmInitWarehouse.aspx?method=getInitWarehouseList',
                            reader: new Ext.data.JsonReader({
                                totalProperty: 'totalProperty',
                                root: 'root'
                            }, [
	                        {
	                            name: 'OrderId'
	                        },
	                        {
	                            name: 'OrgId'
	                        },
	                        {
	                            name: 'WhId'
	                        },
	                        {
	                            name: 'OperId'
	                        },
	                        {
	                            name: 'InventoryDate'
	                        },
	                        {
	                            name: 'OwnerId'
	                        },
	                        {
	                            name: 'Remark'
	                        },
	                        {
	                            name: 'IsInitBill'
	                        },
	                        {
	                            name: 'Status'
	                        },
	                        {
	                            name: 'CreateDate'
	                        },
	                        {
	                            name: 'UpdateDate'
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

                        /*------��ʼDataGrid�ĺ��� start---------------*/

                        var sm = new Ext.grid.CheckboxSelectionModel({
                            singleSelect: true
                        });
                        var initWarehouseGrid = new Ext.grid.GridPanel({
                            el: 'divDataGrid',
                            width: '100%',
                            height: '100%',
                            autoWidth: true,
                            autoHeight: true,
                            autoScroll: true,
                            layout: 'fit',
                            id: '',
                            store: initWarehouseGridData,
                            loadMask: { msg: '���ڼ������ݣ����Ժ��' },
                            sm: sm,
                            cm: new Ext.grid.ColumnModel([
		                    sm,
		                        new Ext.grid.RowNumberer(), //�Զ��к�
		                        {
		                        header: '����ID',
		                        dataIndex: 'OrderId',
		                        id: 'OrderId',
		                        hidden: true
		                    },
		                {
		                    header: '��֯�ɣ�',
		                    dataIndex: 'OrgId',
		                    id: 'OrgId',
		                    hidden: true
		                },
		                {
		                    header: '�ֿ�����',
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
		                {
		                    header: '������',
		                    dataIndex: 'OperId',
		                    id: 'OperId',
		                    renderer: function(val, params, record) {
		                        if (dsOperationList.getCount() == 0) {
		                            dsOperationList.load();
		                        }
		                        dsOperationList.each(function(r) {
		                            if (val == r.data['EmpId']) {
		                                val = r.data['EmpName'];
		                                return;
		                            }
		                        });
		                        return val;
		                    }
		                },
		                {
		                    header: '��ʼ��ʱ��',
		                    dataIndex: 'InventoryDate',
		                    id: 'InventoryDate'
		                },
		                {
		                    header: '��ע',
		                    dataIndex: 'Remark',
		                    id: 'Remark'
		                },
		                {
		                    header: '�Ƿ��ʼ��',
		                    dataIndex: 'IsInitBill',
		                    id: 'IsInitBill',
		                    hidden: true
		                },
		                {
		                    header: '״̬',
		                    dataIndex: 'Status',
		                    id: 'Status',
		                    value: 0,
		                    renderer: function(val) { if (val == 0) return '�ݸ�'; if (val == 1) return '���ύ'; }

}]),
                            bbar: new Ext.PagingToolbar({
                                pageSize: 10,
                                store: initWarehouseGridData,
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
                        initWarehouseGrid.render();
                        /*------DataGrid�ĺ������� End---------------*/
                        updateDataGrid();


                    })
</script>

</html>

