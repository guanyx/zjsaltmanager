<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmShiftPosOrderList.aspx.cs" Inherits="WMS_frmShiftPosOrderList" %>

<html>
<head>
<title>�ƿⵥ�б�ҳ��</title><meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<link rel="stylesheet" type="text/css" href="../ext3/resources/css/ext-all.css" />
<script type="text/javascript" src="../ext3/adapter/ext/ext-base.js"></script>
<script type="text/javascript" src="../ext3/ext-all.js"></script>
<script type="text/javascript" src="../js/operateResp.js"></script>
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
    var userGridData;
    Ext.onReady(function() {
        /*------ʵ��toolbar�ĺ��� start---------------*/
        var windowTitle = "";
        var Toolbar = new Ext.Toolbar({
            renderTo: "toolbar",
            items: [{
                text: "����",
                icon: "../theme/1/images/extjs/customer/add16.gif",
                handler: function() { AddOrderWin(); }
            }, '-', {
                text: "�༭",
                icon: "../theme/1/images/extjs/customer/edit16.gif",
                handler: function() { EditOrderWin(); }
            }, '-', {
                text: "ɾ��",
                icon: "../theme/1/images/extjs/customer/delete16.gif",
                handler: function() { deleteOrderWin(); }
            }, '-', {
                text: "�ύ",
                icon: "../theme/1/images/extjs/customer/edit16.gif",
                handler: function() { commitOrderWin(); }
            }, '-', {
                text: " �鿴�Ʋֵ�",
                icon: "../theme/1/images/extjs/customer/edit16.gif",
                handler: function() { lookOrderWin(); }
}]
            });

            /*------����toolbar�ĺ��� end---------------*/
            var dsWarehousePosList; //��λ������
            if (dsWarehousePosList == null) { //��ֹ�ظ�����
                dsWarehousePosList = new Ext.data.JsonStore({
                    totalProperty: "result",
                    root: "root",
                    url: 'frmShiftPosOrderList.aspx?method=getWarehousePositionList',
                    fields: ['WhpId', 'WhpName']
                });
            }

            var defaultWhId = 0;
            if (dsWarehouseList.getRange().length > 0) {
                defaultWhId = dsWarehouseList.getRange()[0].data.WhId;
            }
            /*------��ʼToolBar�¼����� start---------------*//*-----����Orderʵ���ര�庯��----*/
            function updateDataGrid() {
                var WhId = WhNamePanel.getValue();
                var OutWhpId = OutWhpNamePanel.getValue();
                var InWhpId = InWhpNamePanel.getValue();
                var StartDate = Ext.util.Format.date(StartDatePanel.getValue(),'Y/m/d');
                var EndDate = Ext.util.Format.date(EndDatePanel.getValue(),'Y/m/d');
                var Status = StatusPanel.getValue();

                userGridData.baseParams.WhId = WhId;
                userGridData.baseParams.OutWhpId = OutWhpId;
                userGridData.baseParams.InWhpId = InWhpId;
                userGridData.baseParams.StartDate = StartDate;
                userGridData.baseParams.EndDate = EndDate;
                userGridData.baseParams.Status = Status;

                userGridData.load({
                    params: {
                        start: 0,
                        limit: 10
                    }
                });
                //alert(WhId);
                if (WhId < 1) {
                    WhId = defaultWhId; //dsWarehouseList.getRange()[0].data.WhId;
                }
                dsWarehousePosList.load({

                    params: {
                        WhId: WhId
                    }
                });
            }

            function AddOrderWin() {
                uploadShiftPosOrderWindow.show();
                uploadShiftPosOrderWindow.setTitle("�����Ʋֵ�");
                document.getElementById("editShiftPosOrderIFrame").src = "frmShiftPosOrderEdit.aspx?id=0";

                //                if (document.getElementById("editShiftPosOrderIFrame").src.indexOf("frmShiftPosOrderEdit") == -1) {
                //                    document.getElementById("editShiftPosOrderIFrame").src = "frmShiftPosOrderEdit.aspx?id=0";
                //                }
                //                else {
                //                    document.getElementById("editShiftPosOrderIFrame").contentWindow.OrderId = 0;
                //                    document.getElementById("editShiftPosOrderIFrame").contentWindow.setAllFormValue();
                //                }
            }

            function EditOrderWin() {
                var sm = userGrid.getSelectionModel();
                //��ȡѡ���������Ϣ
                var selectData = sm.getSelected();
                if (selectData == null) {
                    Ext.Msg.alert("��ʾ", "��ѡ���Ʋֵ���¼��");
                    return;
                }
                if (selectData.data.Status != 0)//����δ���״̬
                {
                    Ext.Msg.alert("��ʾ", "ֻ��δ�ύ���ƿⵥ�����ܱ༭��");
                    return;
                }
                uploadShiftPosOrderWindow.show();
                uploadShiftPosOrderWindow.setTitle("�༭�Ʋֵ�");
                document.getElementById("editShiftPosOrderIFrame").src = "frmShiftPosOrderEdit.aspx?id=" + selectData.data.OrderId;

                //                if (document.getElementById("editShiftPosOrderIFrame").src.indexOf("frmShiftPosOrderEdit") == -1) {
                //                    document.getElementById("editShiftPosOrderIFrame").src = "frmShiftPosOrderEdit.aspx?id=" + selectData.data.OrderId;
                //                }
                //                else {
                //                    document.getElementById("editShiftPosOrderIFrame").contentWindow.OrderId = selectData.data.OrderId;
                //                    document.getElementById("editShiftPosOrderIFrame").contentWindow.setAllFormValue();
                //                }
            }

            function deleteOrderWin() {
                var sm = userGrid.getSelectionModel();
                //��ȡѡ���������Ϣ
                var selectData = sm.getSelected();
                //���û��ѡ�񣬾���ʾ��Ҫѡ��������Ϣ
                if (selectData == null) {
                    Ext.Msg.alert("��ʾ", "��ѡ����Ҫɾ������Ϣ��");
                    return;
                }
                if (selectData.data.Status != 0)//����δ���״̬
                {
                    Ext.Msg.alert("��ʾ", "���ύ���ƿⵥ����ɾ����");
                    return;
                }
                //ɾ��ǰ�ٴ������Ƿ����Ҫɾ��
                Ext.Msg.confirm("��ʾ��Ϣ", "�Ƿ����Ҫɾ��ѡ����ƿⵥ��", function callBack(id) {
                    //�ж��Ƿ�ɾ������
                    if (id == "yes") {
                        //ҳ���ύ
                        Ext.Ajax.request({
                            url: 'frmShiftPosOrderList.aspx?method=deleteShiftPosOrder',
                            method: 'POST',
                            params: {
                                OrderId: selectData.data.OrderId
                            },
                            success: function(resp, opts) {
                                Ext.Msg.alert("��ʾ", "����ɾ���ɹ���");
                                updateDataGrid(); //ˢ��ҳ��
                            },
                            failure: function(resp, opts) {
                                Ext.Msg.alert("��ʾ", "����ɾ��ʧ�ܣ�");
                            }
                        });
                    }
                });
            }

            //�ύ
            function commitOrderWin() {
                var sm = userGrid.getSelectionModel();
                //��ȡѡ���������Ϣ
                var selectData = sm.getSelected();
                if (selectData == null) {
                    Ext.Msg.alert("��ʾ", "��ѡ���ƿⵥ��");
                    return;
                }
                if (selectData.data.Status == 1)//���ύ
                {
                    Ext.Msg.alert("��ʾ", "���ƿⵥ�Ѿ��ύ��");
                    return;
                }
                Ext.Msg.confirm("��ʾ��Ϣ", "�Ƿ����Ҫ�ύѡ����ƿⵥ��", function callBack(id) {
                    //�ж��Ƿ�ɾ������
                    if (id == "yes") {
                        //ҳ���ύ
                        Ext.Ajax.request({
                            url: 'frmShiftPosOrderList.aspx?method=commitShiftPosOrder',
                            method: 'POST',
                            params: {
                                OrderId: selectData.data.OrderId
                            },
                            success: function(resp, opts) {
                                if (checkExtMessage(resp)) {
                                    //Ext.Msg.alert("��ʾ", "�����ύ�ɹ���");
                                    updateDataGrid(); //ˢ��ҳ��
                                }
                            },
                            failure: function(resp, opts) {
                                Ext.Msg.alert("��ʾ", "�����ύʧ�ܣ�");
                            }
                        });
                    }
                });
            }
            function lookOrderWin() {
                var sm = userGrid.getSelectionModel();
                //��ȡѡ���������Ϣ
                var selectData = sm.getSelected();
                if (selectData == null) {
                    Ext.Msg.alert("��ʾ", "��ѡ���ƿⵥ��¼��");
                    return;
                }
                uploadShiftPosOrderWindow.show();
                uploadShiftPosOrderWindow.setTitle("�鿴�ƿⵥ");
                document.getElementById("editShiftPosOrderIFrame").src = "frmShiftPosOrderEdit.aspx?type=look&id=" + selectData.data.OrderId;
            }
            /*------��ʼ�������ݵĴ��� Start---------------*/
            if (typeof (uploadShiftPosOrderWindow) == "undefined") {//�������2��windows����
                uploadShiftPosOrderWindow = new Ext.Window({
                    id: 'ShiftPosOrderWindow'
		            , iconCls: 'upload-win'
		            , width: 750
		            , height: 490
		            , layout: 'fit'
		            , plain: true
		            , modal: true
		            , constrain: true
		            , resizable: false
		            , closeAction: 'hide'
		            , autoDestroy: true
		            , html: '<iframe id="editShiftPosOrderIFrame" width="100%" height="100%" border=0 src="#"></iframe>'

                });
            }
            uploadShiftPosOrderWindow.addListener("hide", function() {
                updateDataGrid();
            });


            /*------��ʼ��ѯform�ĺ��� start---------------*/

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
                fieldLabel: '�ֿ�',
                anchor: '90%',
                id: 'WhName',
                value: defaultWhId, //dsWarehouseList.getRange()[0].data.WhId,
                editable: false,
                listeners: { specialkey: function(f, e) { if (e.getKey() == e.ENTER) { Ext.getCmp('OutWhpName').focus(); } },
                    select: function(combo, record, index) {
                        var curWhId = WhNamePanel.getValue();
                        dsWarehousePosList.load({
                            params: {
                                WhId: curWhId
                            }
                        });
                        Ext.getCmp('OutWhpName').setValue("");
                        Ext.getCmp('InWhpName').setValue("");
                    }
                }

            });


            dsWarehousePosList.load({
                params: {
                    WhId: WhNamePanel.getValue()
                }
            });

            var OutWhpNamePanel = new Ext.form.ComboBox({
                name: 'outWarehousePosCombo',
                store: dsWarehousePosList,
                displayField: 'WhpName',
                valueField: 'WhpId',
                typeAhead: true, //�Զ�����һ����������ѡ�ȫ����
                triggerAction: 'all',
                emptyText: '��ѡ���λ',
                selectOnFocus: true,
                forceSelection: true,
                mode: 'local',
                fieldLabel: '������λ',
                anchor: '90%',
                id: 'OutWhpName',
                listeners: { specialkey: function(f, e) { if (e.getKey() == e.ENTER) { Ext.getCmp('inWhpName').focus(); } } }
            });
            var InWhpNamePanel = new Ext.form.ComboBox({
                name: 'inWarehousePosCombo',
                store: dsWarehousePosList,
                displayField: 'WhpName',
                valueField: 'WhpId',
                typeAhead: true, //�Զ�����һ����������ѡ�ȫ����
                triggerAction: 'all',
                emptyText: '��ѡ���λ',
                selectOnFocus: true,
                forceSelection: true,
                mode: 'local',
                fieldLabel: '�����λ',
                anchor: '90%',
                id: 'InWhpName',
                listeners: { specialkey: function(f, e) { if (e.getKey() == e.ENTER) { Ext.getCmp('Status').focus(); } } }
            });

            var StatusPanel = new Ext.form.ComboBox({
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
                id: 'Status',
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
                        WhNamePanel
                    ]
                    }, {
                        columnWidth: .3,
                        layout: 'form',
                        border: false,
                        items: [
                        OutWhpNamePanel
                        ]
                    }, {
                        columnWidth: .3,
                        layout: 'form',
                        border: false,
                        items: [
                        InWhpNamePanel
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
                        StatusPanel
                    ]
                        }, {
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
                            columnWidth: .1,
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
            userGridData = new Ext.data.Store
({
    url: 'frmShiftPosOrderList.aspx?method=getShiftPosOrderList',
    reader: new Ext.data.JsonReader({
        totalProperty: 'totalProperty',
        root: 'root'
    }, [
	{
	    name: 'OrderId'
	},
	{
	    name: 'WhId'
	},
	{
	    name: 'OutWhpId'
	},
	{
	    name: 'InWhpId'
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
	    name: 'Status'
	},
	{
	    name: 'Remark'
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
		header: '�Ʋֵ���',
		dataIndex: 'OrderId',
		id: 'OrderId'
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
		{
		    header: '������λ',
		    dataIndex: 'OutWhpId',
		    id: 'OutWhpId',
		    renderer: function(val, params, record) {
		        dsWarehousePosList.each(function(r) {
		            if (val == r.data['WhpId']) {
		                val = r.data['WhpName'];
		                return;
		            }
		        });
		        return val;
		    }
		},
		{
		    header: '�����λ',
		    dataIndex: 'InWhpId',
		    id: 'InWhpId',
		    renderer: function(val, params, record) {
		        dsWarehousePosList.each(function(r) {
		            if (val == r.data['WhpId']) {
		                val = r.data['WhpName'];
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
		    header: '����ʱ��',
		    dataIndex: 'CreateDate',
		    id: 'CreateDate',
		    format: 'Y��m��d��'
		},

		{
		    header: '����״̬',
		    dataIndex: 'Status',
		    id: 'Status',
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
