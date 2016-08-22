<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmWmsAdminDefine.aspx.cs" Inherits="WMS_frmWmsAdminDefine" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html>
<head>
<title>�ֿ����Աά��</title><meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<link rel="stylesheet" type="text/css" href="../ext3/resources/css/ext-all.css" />
<script type="text/javascript" src="../ext3/adapter/ext/ext-base.js"></script>
<script type="text/javascript" src="../ext3/ext-all.js"></script>
<script type="text/javascript" src="../js/operateResp.js"></script>
</head>
<body>
<div id='toolbar'></div>
<div id='searchForm'></div>
<div id='dataGrid'></div>

</body>
<%=getComboBoxStore()%>
<script type="text/javascript">
    Ext.onReady(function() {
        Ext.BLANK_IMAGE_URL = "../ext3/resources/images/default/s.gif";
        /*------ʵ��toolbar�ĺ��� start---------------*/
        var Toolbar = new Ext.Toolbar({
            renderTo: "toolbar",
            items: [{
                text: "����",
                icon: "../Theme/1/images/extjs/customer/add16.gif",
                handler: function() {
                    saveType = 'add';
                    openAddDefineWin();
                }
            }, '-', {
                text: "�༭",
                icon: "../Theme/1/images/extjs/customer/edit16.gif",
                handler: function() {
                    saveType = 'add';
                    modifyDefineWin();
                }
            }, '-', {
                text: "ɾ��",
                icon: "../Theme/1/images/extjs/customer/delete16.gif",
                handler: function() {
                    deleteDefine();
                }
}]
            });

            /*------����toolbar�ĺ��� end---------------*/


            /*------��ʼToolBar�¼����� start---------------*//*-----����Defineʵ���ര�庯��----*/
            function openAddDefineWin() {
                uploadDefineWindow.show();
                Ext.getCmp("WhId").disabled = false;
                Ext.getCmp("AdminId").disabled = false;
            }
            /*-----�༭Defineʵ���ര�庯��----*/
            function modifyDefineWin() {
                var sm = defineGridData.getSelectionModel();
                //��ȡѡ���������Ϣ
                var selectData = sm.getSelected();
                if (selectData == null) {
                    Ext.Msg.alert("��ʾ", "��ѡ����Ҫ�༭����Ϣ��");
                    return;
                }
                uploadDefineWindow.show();
                setFormValue(selectData.data.Id);
            }
            /*-----ɾ��Defineʵ�庯��----*/
            /*ɾ����Ϣ*/
            function deleteDefine() {
                var sm = defineGridData.getSelectionModel();
                //��ȡѡ���������Ϣ
                var selectData = sm.getSelected();
                //���û��ѡ�񣬾���ʾ��Ҫѡ��������Ϣ
                if (selectData == null) {
                    Ext.Msg.alert("��ʾ", "��ѡ����Ҫɾ������Ϣ��");
                    return;
                }
                //ɾ��ǰ�ٴ������Ƿ����Ҫɾ��
                Ext.Msg.confirm("��ʾ��Ϣ", "�Ƿ����Ҫɾ��ѡ�����Ϣ��", function callBack(id) {
                    //�ж��Ƿ�ɾ������
                    if (id == "yes") {
                        //ҳ���ύ
                        Ext.Ajax.request({
                            url: 'frmWmsAdminDefine.aspx?method=deleteDefine',
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
            function setFormValue(selectedId) {
                Ext.Ajax.request({
                    url: 'frmWmsAdminDefine.aspx?method=getAdminDefineInfo',
                    params: {
                        Id: selectedId
                    },
                    success: function(resp, opts) {
                        var data = Ext.util.JSON.decode(resp.responseText);

                        Ext.getCmp("Id").setValue(data.Id);
                        Ext.getCmp("WhId").setValue(data.WhId);
                        Ext.getCmp("AdminId").setValue(data.AdminId);
                        Ext.getCmp("Status").setValue(data.Status);
                        Ext.getCmp("Remark").setValue(data.Remark);

                        Ext.getCmp("WhId").disabled = true;
                        //Ext.getCmp("AdminId").disabled = true;
                    },
                    failure: function(resp, opts) {
                        Ext.Msg.alert("��ʾ", "��ȡ�ֹ�Ա��Ϣʧ�ܣ�");
                    }
                });
            }
            /*------ʵ��FormPanle�ĺ��� start---------------*/
            var adminForm = new Ext.form.FormPanel({
                url: '',
                height: '100%',
                frame: true,
                labelWidth: 55,
                items: [
		{
		    xtype: 'hidden',
		    fieldLabel: '��ˮID',
		    columnWidth: 1,
		    anchor: '90%',
		    name: 'Id',
		    id: 'Id',
		    hidden: true,
		    hideLabel: true
		}
, {
    xtype: 'combo',
    fieldLabel: '�ֿ�',
    columnWidth: 1,
    anchor: '90%',
    name: 'WhId',
    id: 'WhId',
    store: dsWh,
    mode: 'local',
    displayField: 'WhName',
    valueField: 'WhId',
    editable: false,
    triggerAction: 'all'
}
, {
    xtype: 'combo',
    fieldLabel: '�ֹ�Ա',
    columnWidth: 1,
    anchor: '90%',
    name: 'AdminId',
    id: 'AdminId',
    store: dsAdminCombo,
    mode: 'local',
    displayField: 'EmpName',
    valueField: 'EmpId',
    triggerAction: 'all',
    editable: false
}

, {
    xtype: 'combo',
    fieldLabel: '״̬',
    columnWidth: 1,
    anchor: '90%',
    name: 'Status',
    id: 'Status',
    store: dsStatusList,
    mode: 'local',
    displayField: 'StatusName',
    valueField: 'StatusId',
    triggerAction: 'all',
    editable: false,
    value: 0
}

, {
    xtype: 'textarea',
    fieldLabel: '��ע',
    columnWidth: 1,
    anchor: '90%',
    name: 'Remark',
    id: 'Remark'
}
]
            });
            /*------FormPanle�ĺ������� End---------------*/

            /*------��ʼ�������ݵĴ��� Start---------------*/
            if (typeof (uploadDefineWindow) == "undefined") {//�������2��windows����
                uploadDefineWindow = new Ext.Window({
                    id: 'Defineformwindow',
                    title: '�ֿ����Աά��'
		, iconCls: 'upload-win'
		, width: 350
		, height: 250
		, layout: 'fit'
		, plain: true
		, modal: true
		, constrain: true
		, resizable: false
		, closeAction: 'hide'
		, autoDestroy: true
		, items: adminForm
		, buttons: [{
		    text: "����",
		    id: 'btnSave'
			, handler: function() {
			    if (!checkData()) return;
			    saveUserData();
			    Ext.getCmp("btnSave").disabled = true;
			}
			, scope: this
		},
		{
		    text: "ȡ��"
			, handler: function() {
			    uploadDefineWindow.hide();
			}
			, scope: this
}]
                });
            }
            uploadDefineWindow.addListener("hide", function() {
                adminForm.getForm().reset();
                updateDataGrid();
                Ext.getCmp("btnSave").disabled = false;
            });

            /*------��ʼ��ȡ�������ݵĺ��� start---------------*/
            function saveUserData() {
                Ext.Ajax.request({
                    url: 'frmWmsAdminDefine.aspx?method=saveDefine',
                    method: 'POST',
                    params: {
                        Id: Ext.getCmp('Id').getValue(),
                        AdminId: Ext.getCmp('AdminId').getValue(),
                        WhId: Ext.getCmp('WhId').getValue(),
                        Remark: Ext.getCmp('Remark').getValue()
                    },
                    success: function(resp, opts) {
                        if (checkExtMessage(resp)) {
                        }
                    }
                });
            }
            //���UI��������
            function checkData() {
                var WhId = Ext.getCmp("WhId").getValue().trim();
                if (WhId == "") {
                    Ext.Msg.alert("��ʾ", "�����ֿⲻ��Ϊ�գ�");
                    return false;
                }
                var AdminId = Ext.getCmp("AdminId").getValue().trim();
                if (AdminId == "") {
                    Ext.Msg.alert("��ʾ", "�ֹ�Ա����Ϊ�գ�");
                    return false;
                }
                return true;
            }
            function updateDataGrid() {
                var WhId = DefineCombo.getValue();
                var AdminDefineName = defineNamePanel.getValue();

                dsDefine.baseParams.WhId = WhId;
                dsDefine.baseParams.AdminDefineName = AdminDefineName;
                
                dsDefine.load({
                    params: {
                        start: 0,
                        limit: 10
                    }
                });
            }
            /*------������ȡ�������ݵĺ��� End---------------*/

            /*------��ʼ��ȡ���ݵĺ��� start---------------*/
            var dsDefine = new Ext.data.Store
({
    url: 'frmWmsAdminDefine.aspx?method=getDefineList',
    reader: new Ext.data.JsonReader({
        totalProperty: 'totalProperty',
        root: 'root'
    }, [
	{ name: 'Id' },
	{ name: 'AdminId' },
	{ name: 'WhId' },
	{ name: 'CreateDate' },
	{ name: 'UpdateDate' },
	{ name: 'OrgId' },
	{ name: 'Remark' },
	{ name: 'AdmName' },
	{ name: 'OrgName' },
	{ name: 'WhName' },
	{ name: 'Status' }
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
            /*------����ͻ��������������� start--------*/
            var DefineCombo = new Ext.form.ComboBox({

                fieldLabel: '�����ֿ�',
                name: 'ownCk',
                store: dsWh,
                displayField: 'WhName',
                valueField: 'WhId',
                mode: 'local',
                editable: false,
                //loadText:'loading ...',
                typeAhead: true, //�Զ�����һ����������ѡ�ȫ����
                triggerAction: 'all',
                selectOnFocus: true,
                forceSelection: true,
                width: 150

            });


            var defineNamePanel = new Ext.form.TextField({
                style: 'margin-left:0px',
                cls: 'key',
                xtype: 'textfield',
                fieldLabel: '����Ա����',
                name: 'nameDefine',
                anchor: '90%'
            });

            var serchform = new Ext.FormPanel({
                renderTo: 'searchForm',
                labelAlign: 'left',
                layout: 'fit',
                buttonAlign: 'right',
                bodyStyle: 'padding:5px',
                frame: true,
                labelWidth: 80,
                items: [{
                    layout: 'column',   //�����Ԫ��Ϊ����Ϊ�в��ַ�ʽ
                    border: false,
                    items: [{
                        columnWidth: .4,  //����ռ�õĿ�ȣ���ʶΪ20��
                        layout: 'form',
                        border: false,
                        items: [
                                DefineCombo
                                ]
                    }, {
                        columnWidth: .4,
                        layout: 'form',
                        border: false,
                        items: [
                                    defineNamePanel
                                    ]
                    }, {
                        columnWidth: .2,
                        layout: 'form',
                        border: false,
                        items: [{ cls: 'key',
                            xtype: 'button',
                            text: '��ѯ',
                            anchor: '50%',
                            handler: function() {
                                updateDataGrid();

                            }
}]
}]
}]
                        });


                        /*------��ʼDataGrid�ĺ��� start---------------*/

                        var sm = new Ext.grid.CheckboxSelectionModel({
                            singleSelect: true
                        });
                        var defineGridData = new Ext.grid.GridPanel({
                            el: 'dataGrid',
                            width: '100%',
                            height: '100%',
                            autoWidth: true,
                            autoHeight: true,
                            autoScroll: true,
                            layout: 'fit',
                            id: '',
                            store: dsDefine,
                            loadMask: { msg: '���ڼ������ݣ����Ժ��' },
                            sm: sm,
                            cm: new Ext.grid.ColumnModel([
		sm,
		new Ext.grid.RowNumberer(), //�Զ��к�
		{
		header: '��ˮID',
		dataIndex: 'Id',
		id: 'Id',
		hidden: true,
		hideable: false
},
		{
		    header: '�ֹ�ԱID',
		    dataIndex: 'AdminId',
		    id: 'AdminId',
		    hidden: true,
		    hideable: false
		},
		{
		    header: '�ֹ�Ա',
		    dataIndex: 'AdmName',
		    id: 'AdmName'
		},
		{
		    header: '�ֿ�ID',
		    dataIndex: 'WhId',
		    id: 'WhId',
		    hidden: true,
		    hideable: false
		},
		{
		    header: '�ֿ�',
		    dataIndex: 'WhName',
		    id: 'WhName'
		},
		{
		    header: '��֯',
		    dataIndex: 'OrgName',
		    id: 'OrgName'
		},
		{
		    header: '��֯ID',
		    dataIndex: 'OrgId',
		    id: 'OrgId',
		    hidden: true,
		    hideable: false
		},
		{
		    header: '״̬',
		    dataIndex: 'Status',
		    id: 'Status',
		    renderer: function(val, params, record) {
		        if (dsStatusList.getCount() == 0) {
		            dsStatusList.load();
		        }
		        dsStatusList.each(function(r) {
		            if (val == r.data['StatusId']) {
		                val = r.data['StatusName'];
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
		    header: '��ע',
		    dataIndex: 'Remark',
		    id: 'Remark'
		}
		]),
                            bbar: new Ext.PagingToolbar({
                                pageSize: 10,
                                store: dsDefine,
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
                        defineGridData.render();
                        /*------DataGrid�ĺ������� End---------------*/

                        updateDataGrid();

                    })
</script>

</html>
