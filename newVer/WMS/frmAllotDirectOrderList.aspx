<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmAllotDirectOrderList.aspx.cs" Inherits="WMS_frmAllotDirectOrderList" %>

<html>
<head>
<title>�������ֵ��б�ҳ��</title><meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
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
                text: "�鿴������",
                icon: "../theme/1/images/extjs/customer/add16.gif",
                handler: function() { lookOrderWin(); }
}]
            });

            /*------����toolbar�ĺ��� end---------------*/


            /*------��ʼToolBar�¼����� start---------------*//*-----����Orderʵ���ര�庯��----*/
            function updateDataGrid() {

                var OutWhId = OutOrgNamePanel.getValue();
                var InWhId = InOrgNamePanel.getValue();
                var StartDate = Ext.util.Format.date(StartDatePanel.getValue(),'Y/m/d');
                var EndDate = Ext.util.Format.date(EndDatePanel.getValue(),'Y/m/d');
                var OutStatus = OutStatusPanel.getValue();

                userGridData.baseParams.OutOrg = OutWhId;
                userGridData.baseParams.InOrg = InWhId;
                userGridData.baseParams.OutStatus = OutStatus;
                userGridData.baseParams.EndDate = EndDate;
                userGridData.baseParams.StartDate = StartDate;
                userGridData.baseParams.AllotType = 1;

                userGridData.load({
                    params: {
                        start: 0,
                        limit: 10
                    }
                });

            }

            function AddOrderWin() {
                uploadAllotOrderWindow.show();
                uploadAllotOrderWindow.setTitle("����������");
                document.getElementById("editAllotDirectOrderIFrame").src = "frmAllotDirectOrderEdit.aspx";
            }

            function EditOrderWin() {
                var sm = userGrid.getSelectionModel();
                //��ȡѡ���������Ϣ
                var selectData = sm.getSelected();
                if (selectData == null) {
                    Ext.Msg.alert("��ʾ", "��ѡ���������¼��");
                    return;
                }
                if (selectData.data.OutStatus != 0)//����δ���״̬
                {
                    if (selectData.data.OutOrg == <% =ZJSIG.UIProcess.ADM.UIAdmUser.OrgID(this)%>) {
                        Ext.Msg.alert("��ʾ", "ֻ��δ���ֵĵ��������ܱ༭��");
                        return;
                    }
                }
                uploadAllotOrderWindow.show();
                uploadAllotOrderWindow.setTitle("�༭������");
                document.getElementById("editAllotDirectOrderIFrame").src = "frmAllotDirectOrderEdit.aspx?id=" + selectData.data.OrderId;
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
                if (selectData.data.OutStatus != 0)//����δ���״̬
                {
                    Ext.Msg.alert("��ʾ", "�ѳ���ĵ���������ɾ����");
                    return;
                }
                //ɾ��ǰ�ٴ������Ƿ����Ҫɾ��
                Ext.Msg.confirm("��ʾ��Ϣ", "�Ƿ����Ҫɾ��ѡ��ĵ�������", function callBack(id) {
                    //�ж��Ƿ�ɾ������
                    if (id == "yes") {
                        //ҳ���ύ
                        Ext.Ajax.request({
                            url: 'frmAllotDirectOrderList.aspx?method=deleteAllotDirectOrder',
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

            function lookOrderWin() {
                var sm = userGrid.getSelectionModel();
                //��ȡѡ���������Ϣ
                var selectData = sm.getSelected();
                if (selectData == null) {
                    Ext.Msg.alert("��ʾ", "��ѡ���������¼��");
                    return;
                }
                uploadAllotOrderWindow.show();
                uploadAllotOrderWindow.setTitle("�鿴������");
                document.getElementById("editAllotDirectOrderIFrame").src = "frmAllotDirectOrderEdit.aspx?type=look&id=" + selectData.data.OrderId;
            }

            /*------��ʼ�������ݵĴ��� Start---------------*/
            if (typeof (uploadOrderWindow) == "undefined") {//�������2��windows����
                uploadOrderWindow = new Ext.Window({
                    id: 'Orderformwindow'
		            , iconCls: 'upload-win'
		            , width: 800
		            , height: 515
		            , layout: 'fit'
		            , plain: true
		            , modal: true
		            , constrain: true
		            , resizable: false
		            , closeAction: 'hide'
		            , autoDestroy: true
		            , html: '<iframe id="editIFrame" width="100%" height="100%" border=0 src="#"></iframe>'

                });
            }
            uploadOrderWindow.addListener("hide", function() {
                updateDataGrid();
            });

            if (typeof (uploadAllotOrderWindow) == "undefined") {//�������2��windows����
                uploadAllotOrderWindow = new Ext.Window({
                    id: 'AllotDirectOrderWindow'
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
		            , html: '<iframe id="editAllotDirectOrderIFrame" width="100%" height="100%" border=0 src="frmAllotDirectOrderEdit.aspx"></iframe>'

                });
            }
            uploadAllotOrderWindow.addListener("hide", function() {
                updateDataGrid();
            });


            /*------��ʼ��ѯform�ĺ��� start---------------*/

            var OutOrgNamePanel = new Ext.form.ComboBox({
                name: 'outOrgCombo',
                store: dsOrgList,
                displayField: 'OrgName',
                valueField: 'OrgId',
                typeAhead: true, //�Զ�����һ����������ѡ�ȫ����
                triggerAction: 'all',
                emptyText: '��ѡ��λ',
                selectOnFocus: true,
                forceSelection: true,
                mode: 'local',
                fieldLabel: '������λ',
                anchor: '90%',
                id: 'OutOrgName',
                listeners: { specialkey: function(f, e) { if (e.getKey() == e.ENTER) { Ext.getCmp('InOrgName').focus(); } } }

            });


            var InOrgNamePanel = new Ext.form.ComboBox({
                name: 'inOrgCombo',
                store: dsOrgList,
                displayField: 'OrgName',
                valueField: 'OrgId',
                typeAhead: true, //�Զ�����һ����������ѡ�ȫ����
                triggerAction: 'all',
                emptyText: '��ѡ��λ',
                selectOnFocus: true,
                forceSelection: true,
                mode: 'local',
                fieldLabel: '���뵥λ',
                anchor: '90%',
                id: 'InOrgName',
                listeners: { specialkey: function(f, e) { if (e.getKey() == e.ENTER) { Ext.getCmp('BillStatus').focus(); } } }
            });

            var OutStatusPanel = new Ext.form.ComboBox({
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
                        OutOrgNamePanel
                    ]
                    }, {
                        columnWidth: .3,
                        layout: 'form',
                        border: false,
                        items: [
                        InOrgNamePanel
                        ]
                    }, {
                        columnWidth: .3,
                        layout: 'form',
                        border: false,
                        items: [
                        OutStatusPanel
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
    url: 'frmAllotDirectOrderList.aspx?method=getAllotDirectOrderList',
    reader: new Ext.data.JsonReader({
        totalProperty: 'totalProperty',
        root: 'root'
    }, [
	{
	    name: 'OrderId'
	},
	{
	    name: 'OutWhId'
	},
	{
	    name: 'InWhId'
	},
	{
	    name: 'OutWhName'
	},
	{
	    name: 'InWhName'
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
	    name: 'OutStatus'
	},
	{
	    name: 'DriverId'
	},
	{
	    name: 'DriverName'
	},
	{
	    name: 'Remark'
	},
	{
	    name: 'InOrg'
	},
	{
	    name: 'OutOrg'
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
		    header: '������λ',
		    dataIndex: 'OutOrg',
		    id: 'OutOrg',
		    renderer: function(val, params, record) { 
		        if (dsOrgList.getCount() == 0) {
		            dsOrgList.load();
		        }
		        dsOrgList.each(function(r) {
		            if (val == r.data['OrgId']) {
		                val = r.data['OrgName'];
		                return;
		            }
		        });
		        return val;
		    }
		},
		{
		    header: '�����ֿ�id',
		    dataIndex: 'OutWhId',
		    id: 'OutWhId',
		    hidden:true
//		    renderer: function(val, params, record) {
//		        if (dsWarehouseList.getCount() == 0) {
//		            dsWarehouseList.load();
//		        }
//		        dsWarehouseList.each(function(r) {
//		            if (val == r.data['WhId']) {
//		                val = r.data['WhName'];
//		                return;
//		            }
//		        });
//		        return val;
//		    }
		},
		{
		    header: '�����ֿ�',
		    dataIndex: 'OutWhName',
		    id: 'OutWhName'
		},
		{
		    header: '���뵥λ',
		    dataIndex: 'InOrg',
		    id: 'InOrg',
		    renderer: function(val, params, record) {
		        if (dsOrgList.getCount() == 0) {
		            dsOrgList.load();
		        }
		        dsOrgList.each(function(r) {
		            if (val == r.data['OrgId']) {
		                val = r.data['OrgName'];
		                return;
		            }
		        });
		        return val;
		    }
		},
		{
		    header: '����ֿ�id',
		    dataIndex: 'InWhId',
		    id: 'InWhId',
		    hidden:true
//		    renderer: function(val, params, record) {
//		        if (dsWarehouseList.getCount() == 0) {
//		            dsWarehouseList.load();
//		        }
//		        dsWarehouseList.each(function(r) {
//		            if (val == r.data['WhId']) {
//		                val = r.data['WhName'];
//		                return;
//		            }
//		        });
//		        return val;
//		    }
		},
		{
		    header: '����ֿ�',
		    dataIndex: 'InWhName',
		    id: 'InWhName'
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
		    dataIndex: 'OutStatus',
		    id: 'OutStatus',
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
		    header: '��ʻԱ',
		    dataIndex: 'DriverId',
		    id: 'DriverId',
		    hidden:true
//		    renderer: function(val, params, record) {
//		        if (dsDriverList.getCount() == 0) {
//		            dsDriverList.load();
//		        }
//		        dsDriverList.each(function(r) {
//		            if (val == r.data['DriverId']) {
//		                val = r.data['DriverName'];
//		                return;
//		            }
//		        });
//		        return val;
//		    }
		},
		{
		    header: '��ʻԱ',
		    dataIndex: 'DriverName',
		    id: 'DriverName'
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
