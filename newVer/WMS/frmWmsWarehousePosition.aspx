<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmWmsWarehousePosition.aspx.cs"
    Inherits="WMS_frmWmsWarehousePosition" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
    <title>��λά��ҳ��</title>
    <meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
    <link rel="stylesheet" type="text/css" href="../ext3/resources/css/ext-all.css" />
    <script type="text/javascript" src="../ext3/adapter/ext/ext-base.js"></script>
    <script type="text/javascript" src="../ext3/ext-all.js"></script>
    <script type="text/javascript" src="../ext3/example/TabCloseMenu.js" charset="gb2312"></script>
    <script type="text/javascript" src="../js/operateResp.js"></script>
</head>
<body>
    <div id='toolbar'>
    </div>
    <div id='searchForm'>
    </div>
    <div id='warehousePositionGrid'>
    </div>
    <div style="display:none">
<select id='comboStatus' >
<option value='0'>����</option>
<option value='1'>��ֹ</option>
</select></div>
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
                handler: function() {
                    openAddPositionWin();
                }
            }, '-', {
                text: "�༭",
                icon: "../Theme/1/images/extjs/customer/edit16.gif",
                handler: function() { modifyPositionWin(); }
            }, '-', {
                text: "ɾ��",
                icon: "../Theme/1/images/extjs/customer/delete16.gif",
                handler: function() { deletePosition(); }
}]
            });

            /*------����toolbar�ĺ��� end---------------*/


            /*------��ʼToolBar�¼����� start---------------*//*-----����Positionʵ���ര�庯��----*/
            function updateDataGrid() {
                var WhId = WhNamePanel.getValue();
                warehousePositionGridData.baseParams.WhId = WhId;
                warehousePositionGridData.load({
                    params: {
                        start: 0,
                        limit: 10
                    }
                });
            }
            //����
            function openAddPositionWin() {
                uploadPositionWindow.setTitle("������λ");
                uploadPositionWindow.show();

                warehousePositionForm.getForm().reset();

                Ext.getCmp("WhId").setDisabled(false);

            }
            /*-----�༭Positionʵ���ര�庯��----*/
            function modifyPositionWin() {
                var sm = warehousePositionGrid.getSelectionModel();
                //��ȡѡ���������Ϣ
                var selectData = sm.getSelected();
                if (selectData == null) {
                    Ext.Msg.alert("��ʾ", "��ѡ����Ҫ�༭����Ϣ��");
                    return;
                }
                uploadPositionWindow.setTitle("�༭��λ");
                uploadPositionWindow.show();
                setFormValue(selectData);
            }
            /*-----ɾ��Positionʵ�庯��----*/
            /*ɾ����Ϣ*/
            function deletePosition() {
                var sm = warehousePositionGrid.getSelectionModel();
                //��ȡѡ���������Ϣ
                var selectData = sm.getSelected();
                //���û��ѡ�񣬾���ʾ��Ҫѡ��������Ϣ
                if (selectData == null) {
                    Ext.Msg.alert("��ʾ", "��ѡ����Ҫɾ������Ϣ��");
                    return;
                }
                //ɾ��ǰ�ٴ������Ƿ����Ҫɾ��
                Ext.Msg.confirm("��ʾ��Ϣ", "�Ƿ����Ҫɾ��ѡ��Ĳ�λ��Ϣ��", function callBack(id) {
                    //�ж��Ƿ�ɾ������
                    if (id == "yes") {
                        //ҳ���ύ
                        Ext.Ajax.request({
                            url: 'frmWmsWarehousePosition.aspx?method=deleteWarehousePos',
                            method: 'POST',
                            params: {
                                WhpId: selectData.data.WhpId
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
            //alert(1);
            /*------ʵ��FormPanle�ĺ��� start---------------*/
            var warehousePositionForm = new Ext.form.FormPanel({
                url: '',
                frame: true,
                title: '',
                items: [
		        {
		            xtype: 'hidden',
		            fieldLabel: '��λID',
		            name: 'WhpId',
		            id: 'WhpId',
		            hidden: true,
		            hiddenLabel: true
		        }
                , {
                    xtype: 'combo',
                    fieldLabel: '�����ֿ�',
                    columnWidth: 1,
                    anchor: '90%',
                    name: 'WhId',
                    id: 'WhId'
				    , displayField: 'WhName'
                    , valueField: 'WhId'
                    , editable: false
                    , store: dsWarehouseList
                    , triggerAction: 'all'
                    , mode: 'local'
                }
                , {
                    xtype: 'textfield',
                    fieldLabel: '��λ����',
                    columnWidth: 1,
                    anchor: '90%',
                    name: 'WhpCode',
                    id: 'WhpCode'
                }
                , {
                    xtype: 'textfield',
                    fieldLabel: '��λ����',
                    columnWidth: 1,
                    anchor: '90%',
                    name: 'WhpName',
                    id: 'WhpName'
                }
                , {
                    xtype: 'textfield',
                    fieldLabel: '��λ��ַ',
                    columnWidth: 1,
                    anchor: '90%',
                    name: 'WhpAddr',
                    id: 'WhpAddr'
                }
                , {
                    xtype: 'numberfield',
                    fieldLabel: '������',
                    columnWidth: 1,
                    anchor: '90%',
                    name: 'MaxCapacity',
                    id: 'MaxCapacity'
                }
                , {
                    xtype: 'numberfield',
                    fieldLabel: '�������',
                    columnWidth: 1,
                    anchor: '90%',
                    name: 'MaxWeight',
                    id: 'MaxWeight'
                }
                , {
                    xtype: 'textfield',
                    fieldLabel: '��ע',
                    columnWidth: 1,
                    anchor: '90%',
                    name: 'Remark',
                    id: 'Remark'
                }
                , {
                    xtype: 'combo',
                    fieldLabel: '״̬',
                    columnWidth: 1,
                    anchor: '90%',
                    name: 'Status',
                    id: 'Status',
                    transform: 'comboStatus',
                    typeAhead: false,
                    triggerAction: 'all',
                    lazyRender: true,
                    editable: false
                }
                ]
            }); //alert(2);
            /*------FormPanle�ĺ������� End---------------*/

            /*------��ʼ�������ݵĴ��� Start---------------*/
            if (typeof (uploadPositionWindow) == "undefined") {//�������2��windows����
                uploadPositionWindow = new Ext.Window({
                    id: 'Positionformwindow'
                    //title:formTitle
		            , iconCls: 'upload-win'
		            , width: 600
		            , height: 300
		            , layout: 'fit'
		            , plain: true
		            , modal: true
		            , constrain: true
		            , resizable: false
		            , closeAction: 'hide'
		            , autoDestroy: true
		            , items: warehousePositionForm
		            , buttons: [{
		                text: "����"
			            , handler: function() {
			                if (!checkData()) return;
			                getFormValue();
			                //uploadPositionWindow.hide();
			            }
			            , scope: this
		            },
		            {
		                text: "ȡ��"
			            , handler: function() {
			                uploadPositionWindow.hide();
			            }
			            , scope: this
}]
                });
            }
            uploadPositionWindow.addListener("hide", function() {
            });
            String.prototype.trim = function() {
                // ��������ʽ��ǰ��ո�  
                // �ÿ��ַ��������  
                return this.replace(/(^\s*)|(\s*$)/g, "");
            }
            //������ݡ�
            function checkData() {
                var whId = Ext.getCmp("WhId").getValue().trim();
                if (whId == "") {
                    Ext.Msg.alert("��ʾ", "�����ֿⲻ��Ϊ�գ�");
                    return false;
                }
                var whpCode = Ext.getCmp("WhpCode").getValue().trim();
                if (whpCode == "") {
                    Ext.Msg.alert("��ʾ", "��λ���벻��Ϊ�գ�");
                    return false;
                }
                var whpName = Ext.getCmp("WhpName").getValue().trim();
                if (whpName == "") {
                    Ext.Msg.alert("��ʾ", "��λ���Ʋ���Ϊ�գ�");
                    return false;
                }
                return true;
            }
            /*------��ʼ��ȡ�������ݵĺ��� start---------------*/
            function getFormValue() {
                Ext.Ajax.request({
                    url: 'frmWmsWarehousePosition.aspx?method=saveWarehousePos',
                    method: 'POST',
                    params: {
                        WhpId: Ext.getCmp('WhpId').getValue(),
                        WhId: Ext.getCmp('WhId').getValue(),
                        WhpCode: Ext.getCmp('WhpCode').getValue(),
                        WhpName: Ext.getCmp('WhpName').getValue(),
                        WhpAddr: Ext.getCmp('WhpAddr').getValue(),
                        MaxCapacity: Ext.getCmp('MaxCapacity').getValue(),
                        MaxWeight: Ext.getCmp('MaxWeight').getValue(),
                        Remark: Ext.getCmp('Remark').getValue(),
                        Status: Ext.getCmp('Status').getValue()
                    },
                    success: function(resp, opts) {
                        if (checkExtMessage(resp)) {
                            updateDataGrid();
                        }
                    }
                });
            }
            /*------������ȡ�������ݵĺ��� End---------------*/
            //alert(3);
            /*------��ʼ�������ݵĺ��� Start---------------*/
            function setFormValue(selectData) {
                Ext.Ajax.request({
                    url: 'frmWmsWarehousePosition.aspx?method=getWarehousePos',
                    params: {
                        WhpId: selectData.data.WhpId
                    },
                    success: function(resp, opts) {
                        var data = Ext.util.JSON.decode(resp.responseText);
                        Ext.getCmp("WhpId").setValue(data.WhpId);
                        Ext.getCmp("WhId").setValue(data.WhId);

                        Ext.getCmp("WhId").disable();
                        Ext.getCmp("WhpCode").setValue(data.WhpCode);
                        //Ext.getCmp("WhpName").disable();
                        Ext.getCmp("WhpName").setValue(data.WhpName);
                        Ext.getCmp("WhpAddr").setValue(data.WhpAddr);
                        Ext.getCmp("MaxCapacity").setValue(data.MaxCapacity);
                        Ext.getCmp("MaxWeight").setValue(data.MaxWeight);
                        Ext.getCmp("Remark").setValue(data.Remark);
                        Ext.getCmp("Status").setValue(data.Status);
                    },
                    failure: function(resp, opts) {
                        Ext.Msg.alert("��ʾ", "��ȡ��λ��Ϣʧ�ܣ�");
                    }
                });
            }
            /*------�������ý������ݵĺ��� End---------------*/
            /*------��ʼ��ѯform�ĺ��� start---------------*/

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
                mode: 'local',
                anchor: '90%',
                listeners: { specialkey: function(f, e) { if (e.getKey() == e.ENTER) { Ext.getCmp('searchebtnId').focus(); } },
                    blur: function(field) { if (field.getRawValue() == '') { field.clearValue(); } }
                }

            });

            var serchform = new Ext.FormPanel({
                renderTo: 'searchForm',
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

                        /*------��ʼ��ȡ���ݵĺ��� start---------------*/
                        var warehousePositionGridData = new Ext.data.Store
                        ({
                            url: 'frmWmsWarehousePosition.aspx?method=getWarehousePosList',
                            reader: new Ext.data.JsonReader({
                                totalProperty: 'totalProperty',
                                root: 'root'
                            }, [
	                        {
	                            name: 'WhpId'
	                        },
	                        {
	                            name: 'WhId'
	                        },
	                        {
	                            name: 'WhpCode'
	                        },
	                        {
	                            name: 'WhpName'
	                        },
	                        {
	                            name: 'WhpAddr'
	                        },
	                        {
	                            name: 'MaxCapacity'
	                        },
	                        {
	                            name: 'MaxWeight'
	                        },
	                        {
	                            name: 'Barcode'
	                        },
	                        {
	                            name: 'Remark'
	                        },
	                        {
	                            name: 'Status'
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
                        //alert(4);
                        /*------��ʼDataGrid�ĺ��� start---------------*/

                        var sm = new Ext.grid.CheckboxSelectionModel({
                            singleSelect: true
                        });
                        var warehousePositionGrid = new Ext.grid.GridPanel({
                            el: 'warehousePositionGrid',
                            width: '100%',
                            height: '100%',
                            autoWidth: true,
                            autoHeight: true,
                            autoScroll: true,
                            layout: 'fit',
                            id: 'divGrid',
                            store: warehousePositionGridData,
                            loadMask: { msg: '���ڼ������ݣ����Ժ��' },
                            sm: sm,
                            cm: new Ext.grid.ColumnModel([
		                        sm,
		                        new Ext.grid.RowNumberer(), //�Զ��к�
		                        {
		                        header: '��λID',
		                        dataIndex: 'WhpId',
		                        id: 'WhpId',
		                        hidden: true,
		                        hideable: false
		                    },
		                    {
		                        header: '�����ֿ�',
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
		                        header: '��λ����',
		                        dataIndex: 'WhpCode',
		                        id: 'WhpCode'
		                    },
		                    {
		                        header: '��λ����',
		                        dataIndex: 'WhpName',
		                        id: 'WhpName'
		                    },
		                    {
		                        header: '��λ��ַ',
		                        dataIndex: 'WhpAddr',
		                        id: 'WhpAddr'
		                    },
		                    {
		                        header: '������',
		                        dataIndex: 'MaxCapacity',
		                        id: 'MaxCapacity'
		                    },
		                    {
		                        header: '�������',
		                        dataIndex: 'MaxWeight',
		                        id: 'MaxWeight'
		                    },
		                    {
		                        header: '������',
		                        dataIndex: 'Barcode',
		                        id: 'Barcode',
		                        hidden: true,
		                        hideable: false
		                    },
		                    {
		                        header: '��ע',
		                        dataIndex: 'Remark',
		                        id: 'Remark'
		                    },
		                    {
		                        header: '״̬',
		                        dataIndex: 'Status',
		                        id: 'Status',
		                        value: 0,
		                        renderer: function(val) { if (val == 0) return '����'; if (val == 1) return '����'; }

}]),
                            bbar: new Ext.PagingToolbar({
                                pageSize: 10,
                                store: warehousePositionGridData,
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
                        warehousePositionGrid.render();
                        /*------DataGrid�ĺ������� End---------------*/
                        updateDataGrid();
                    })
</script>

</html>
