<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmWmsWarehouse.aspx.cs" Inherits="WMS_frmWmsWarehouse" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html>
<head>
<title>�ֿ�ά��ҳ</title>
<meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<link rel="stylesheet" type="text/css" href="../ext3/resources/css/ext-all.css" />
<script type="text/javascript" src="../ext3/adapter/ext/ext-base.js"></script>
<script type="text/javascript" src="../ext3/ext-all.js"></script>
<script type="text/javascript" src="../js/operateResp.js"></script>

</head>
<body>
<div id='toolbar'></div>
<div id='searchForm'></div>
<div id='userGrid'></div>
<div style="display:none">
<select id='comboStatus' >
<option value='0'>����</option>
<option value='1'>��ֹ</option>
</select>
<select id='comboWhType' >
<option value='01'>��ҵ�ֿ�</option>
<option value='02'>ս���βֿ�</option>
<option value='03'>ʡ�����ֿ�</option>
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
                    openAddWarehouseWin();
                }
            }, '-', {
                text: "�༭",
                icon: "../Theme/1/images/extjs/customer/edit16.gif",
                handler: function() {
                    modifyWarehouseWin();
                }
//            }, '-', {
//                text: "ɾ��",
//                icon: "../Theme/1/images/extjs/customer/delete16.gif",
//                handler: function() {
//                    deleteWarehouse();
//                }
}]
            });


            /*------����toolbar�ĺ��� end---------------*/


            /*------��ʼToolBar�¼����� start---------------*//*-----����Warehouseʵ���ര�庯��----*/
            function openAddWarehouseWin() {
                uploadWarehouseWindow.setTitle("�����ֿ�");
                uploadWarehouseWindow.show();
                
                warehouseForm.getForm().reset();

            }
            /*-----�༭Warehouseʵ���ര�庯��----*/
            function modifyWarehouseWin() {
                var sm = userGrid.getSelectionModel();
                //��ȡѡ���������Ϣ
                var selectData = sm.getSelected();
                if (selectData == null) {
                    Ext.Msg.alert("��ʾ", "��ѡ����Ҫ�༭����Ϣ��");
                    return;
                }
                uploadWarehouseWindow.setTitle("�༭�ֿ�");
                uploadWarehouseWindow.show();
                
                setFormValue(selectData);
            }
            /*-----ɾ��Warehouseʵ�庯��----*/
            /*ɾ����Ϣ*/
            function deleteWarehouse() {
                var sm = userGrid.getSelectionModel();
                //��ȡѡ���������Ϣ
                var selectData = sm.getSelected();
                //���û��ѡ�񣬾���ʾ��Ҫѡ��������Ϣ
                if (selectData == null) {
                    Ext.Msg.alert("��ʾ", "��ѡ����Ҫɾ������Ϣ��");
                    return;
                }
                //ɾ��ǰ�ٴ������Ƿ����Ҫɾ��
                Ext.Msg.confirm("��ʾ��Ϣ", "�Ƿ����Ҫɾ��ѡ��Ĳֿ���Ϣ��", function callBack(id) {
                    //�ж��Ƿ�ɾ������
                    if (id == "yes") {
                        //ҳ���ύ
                        Ext.Ajax.request({
                            url: 'frmWmsWarehouse.aspx?method=deleteWarehouse',
                            method: 'POST',
                            params: {
                                WhId: selectData.data.WhId
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
                var WhCode = WhCodePanel.getValue();
                var WhName = WhNamePanel.getValue();
                userGridData.baseParams.WhCode = WhCode;
                userGridData.baseParams.WhName = WhName;
                userGridData.baseParams.start = 0;
                userGridData.baseParams.limit = 100;

                userGridData.load();
            }

            /*------ʵ��FormPanle�ĺ��� start---------------*/
            var warehouseForm = new Ext.form.FormPanel({
                url: '',
                frame: true,
                title: '',
                items: [
	            {
	                layout: 'column',
	                border: false,
	                labelSeparator: '��',
	                items: [
		            {
		                layout: 'form',
		                border: false,
		                columnWidth: 1,
		                items: [
		                    {
		                        xtype: 'hidden',
		                        fieldLabel: '�ֿ�ID',
		                        name: 'WhId',
		                        id: 'WhId',
		                        hidden: true,
		                        hiddenLabel: true
		                    },
				            {
				                xtype: 'textfield',
				                fieldLabel: '�ֿ����',
				                columnWidth: 1,
				                anchor: '90%',
				                name: 'WhCode',
				                id: 'WhCode'
				            }
		            ]
		            }
	            ]
	            },
	            {
	                layout: 'column',
	                border: false,
	                labelSeparator: '��',
	                items: [
		            {
		                layout: 'form',
		                border: false,
		                columnWidth: 1,
		                items: [
				            {
				                xtype: 'textfield',
				                fieldLabel: '�ֿ�����',
				                columnWidth: 1,
				                anchor: '90%',
				                name: 'WhName',
				                id: 'WhName'
				            }
		            ]
		            }
	            ]
	            },
	            {
	                layout: 'column',
	                border: false,
	                labelSeparator: '��',
	                items: [
		            {
		                layout: 'form',
		                border: false,
		                columnWidth: 1,
		                items: [
				            {
				                xtype: 'combo',
				                fieldLabel: '��������վ',
				                columnWidth: 1,
				                anchor: '90%',
				                name: 'StationId',
				                id: 'StationId'
				                , displayField: 'DeptName'
                                , valueField: 'DeptId'
                                , editable: false
                                , store: dsDistributionCenterListInfo
                                , triggerAction: 'all'
                                , mode: 'local'

				            }
		            ]
		            }
	            ]
	            },
	            {
	                layout: 'column',
	                border: false,
	                labelSeparator: '��',
	                items: [
		            {
		                layout: 'form',
		                border: false,
		                columnWidth: 1,
		                items: [
				            {
				                xtype: 'textfield',
				                fieldLabel: '��ַ',
				                columnWidth: 1,
				                anchor: '90%',
				                name: 'Address',
				                id: 'Address'
				            }
		            ]
		            }
	            ]
	            },
	            {
	                layout: 'column',
	                border: false,
	                labelSeparator: '��',
	                items: [
		            {
		                layout: 'form',
		                border: false,
		                columnWidth: 1,
		                items: [
				            {
				                xtype: 'textfield',
				                fieldLabel: '�ֿ�����',
				                columnWidth: 1,
				                anchor: '90%',
				                name: 'Description',
				                id: 'Description'
				            }
		            ]
		            }
	            ]
	            },
	            {
	                layout: 'column',
	                border: false,
	                labelSeparator: '��',
	                items: [
		            {
		                layout: 'form',
		                border: false,
		                columnWidth: 1,
		                items: [
				            {
				                xtype: 'textfield',
				                fieldLabel: '��ע',
				                columnWidth: 1,
				                anchor: '90%',
				                name: 'Remark',
				                id: 'Remark'
				            }
		            ]
		            }
	            ]
	            },
	            {
	                layout: 'column',
	                border: false,
	                labelSeparator: '��',
	                items: [
		            {
		                layout: 'form',
		                border: false,
		                columnWidth: 1,
		                items: [
				            {
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
		            }
	            ]
	            },
	            {
	                layout: 'column',
	                border: false,
	                labelSeparator: '��',
	                items: [
		            {
		                layout: 'form',
		                border: false,
		                columnWidth: 1,
		                items: [
				            {
				                xtype: 'combo',
				                fieldLabel: '�ֿ�����',
				                columnWidth: 1,
				                anchor: '90%',
				                name: 'WhType',
				                id: 'WhType',
				                transform: 'comboWhType',
				                typeAhead: false,
				                triggerAction: 'all',
				                lazyRender: true,
				                editable: false,
                                value:'01'
				            }
		            ]
		            }
	            ]
	            }
            ]
            });
            /*------FormPanle�ĺ������� End---------------*/

            /*------��ʼ�������ݵĴ��� Start---------------*/
            if (typeof (uploadWarehouseWindow) == "undefined") {//�������2��windows����
                uploadWarehouseWindow = new Ext.Window({
                    id: 'Warehouseformwindow'
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
		            , items: warehouseForm
		            , buttons: [{
		                text: "����"
			            , handler: function() {
			                if (!checkData()) return;
			                getFormValue();
			                //warehouseForm.getForm().reset();
			                uploadWarehouseWindow.hide();
			                updateDataGrid();
			            }
			            , scope: this
		            },
		            {
		                text: "ȡ��"
			            , handler: function() {
			                uploadWarehouseWindow.hide();
			            }
			            , scope: this
}]
                });
            }
            uploadWarehouseWindow.addListener("hide", function() {
            });
            String.prototype.trim = function() {
                // ��������ʽ��ǰ��ո�  
                // �ÿ��ַ��������  
                return this.replace(/(^\s*)|(\s*$)/g, "");
            }
            //������ݡ�
            function checkData() {
                var stationId = Ext.getCmp("StationId").getValue().trim();
                if (stationId == "") {
                    Ext.Msg.alert("��ʾ", "��������վ����Ϊ�գ�");
                    return false;
                }
                var whCode = Ext.getCmp("WhCode").getValue().trim();
                if (whCode == "") {
                    Ext.Msg.alert("��ʾ", "�ֿ���벻��Ϊ�գ�");
                    return false;
                }
                var whName = Ext.getCmp("WhName").getValue().trim();
                if (whName == "") {
                    Ext.Msg.alert("��ʾ", "�ֿ����Ʋ���Ϊ�գ�");
                    return false;
                }
                return true;
            }
            /*------��ʼ��ȡ�������ݵĺ��� start---------------*/
            function getFormValue() {
                Ext.Ajax.request({
                    url: 'frmWmsWarehouse.aspx?method=saveWarehouse',
                    method: 'POST',
                    params: {
                        WhId: Ext.getCmp('WhId').getValue(),
                        WhCode: Ext.getCmp('WhCode').getValue(),
                        WhName: Ext.getCmp('WhName').getValue(),
                        StationId: Ext.getCmp('StationId').getValue(),
                        Address: Ext.getCmp('Address').getValue(),
                        Description: Ext.getCmp('Description').getValue(),
                        Remark: Ext.getCmp('Remark').getValue(),
                        Status: Ext.getCmp('Status').getValue(),
                        WhType: Ext.getCmp('WhType').getValue()
                    },
                    success: function(resp, opts) {
                        if (checkExtMessage(resp)) {
                            updateDataGrid();
                        }
                    }
                });
            }
            /*------������ȡ�������ݵĺ��� End---------------*/

            /*------��ʼ�������ݵĺ��� Start---------------*/
            function setFormValue(selectData) {

                Ext.Ajax.request({
                    url: 'frmWmsWarehouse.aspx?method=getWarehouseInfo',
                    params: {
                        WhId: selectData.data.WhId
                    },
                    success: function(resp, opts) {
                        var data = Ext.util.JSON.decode(resp.responseText);
                        Ext.getCmp("WhId").setValue(data.WhId);
                        Ext.getCmp("WhCode").setValue(data.WhCode);
                        Ext.getCmp("WhName").setValue(data.WhName);
                        Ext.getCmp("StationId").setValue(data.StationId);
                        Ext.getCmp("Address").setValue(data.Address);
                        Ext.getCmp("Description").setValue(data.Description);
                        Ext.getCmp("Remark").setValue(data.Remark);
                        Ext.getCmp("Status").setValue(data.Status);
                        Ext.getCmp("WhType").setValue(data.WhType);
                    },
                    failure: function(resp, opts) {
                        Ext.Msg.alert("��ʾ", "��ȡ�ֿ���Ϣʧ�ܣ�");
                    }
                });
            }
            /*------�������ý������ݵĺ��� End---------------*/

            /*------��ʼ��ѯform�ĺ��� start---------------*/

            var WhCodePanel = new Ext.form.TextField({
                style: 'margin-left:0px',
                cls: 'key',
                xtype: 'textfield',
                fieldLabel: '�ֿ����',
                anchor: '70%',
                listeners: { specialkey: function(f, e) { if (e.getKey() == e.ENTER) { Ext.getCmp('SWhName').focus(); } } }

            });


            var WhNamePanel = new Ext.form.TextField({
                style: 'margin-left:0px',
                cls: 'key',
                xtype: 'textfield',
                fieldLabel: '�ֿ�����',
                anchor: '70%',
                id: 'SWhName',
                listeners: { specialkey: function(f, e) { if (e.getKey() == e.ENTER) { Ext.getCmp('searchebtnId').focus(); } } }
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
                        columnWidth: .4,  //����ռ�õĿ�ȣ���ʶΪ20��
                        layout: 'form',
                        border: false,
                        items: [
                        WhCodePanel
                    ]
                    }, {
                        columnWidth: .4,
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
}]
}]
}]
                        });


                        /*------��ʼ��ѯform�ĺ��� end---------------*/

                        /*------��ʼ��ȡ���ݵĺ��� start---------------*/
                        var userGridData = new Ext.data.Store
                        ({
                            url: 'frmWmsWarehouse.aspx?method=getWarehouseList',
                            reader: new Ext.data.JsonReader({
                                totalProperty: 'totalProperty',
                                root: 'root'
                            }, [
	                        {
	                            name: 'WhId'
	                        },
	                        {
	                            name: 'WhCode'
	                        },
	                        {
	                            name: 'WhName'
	                        },
	                        {
	                            name: 'StationId'
	                        },
	                        {
	                            name: 'Address'
	                        },
	                        {
	                            name: 'Description'
	                        },
	                        {
	                            name: 'Remark'
	                        },
	                        {
	                            name: 'Status'
	                        },
	                        {
	                            name: 'WhType'
	                        },
	                        {
	                            name: 'OrgId'
	                        },
	                        {
	                            name: 'OperId'
	                        },
	                        {
	                            name: 'OwnerId'
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
                        var userGrid = new Ext.grid.GridPanel({
                            el: 'userGrid',
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
	                            header: '�ֿ�ID',
	                            dataIndex: 'WhId',
	                            id: 'WhId',
	                            hidden: true,
	                            hideable: false
	                        },
	                            {
	                                header: '�ֿ���',
	                                dataIndex: 'WhCode',
	                                id: 'WhCode'
	                            },
	                            {
	                                header: '�ֿ�����',
	                                dataIndex: 'WhName',
	                                id: 'WhName'
	                            },
	                            {
	                                header: '��������վ',
	                                dataIndex: 'StationId',
	                                id: 'StationId',
	                                renderer: function(val, params, record) {
	                                    dsDistributionCenterListInfo.each(function(r) {
	                                        if (val == r.data['DeptId']) {
	                                            val = r.data['DeptName'];
	                                            return;
	                                        }
	                                    });
	                                    return val;
	                                }
	                            },
	                            {
	                                header: '��ַ',
	                                dataIndex: 'Address',
	                                id: 'Address'
	                            },
	                            {
	                                header: '�ֿ�����',
	                                dataIndex: 'Description',
	                                id: 'Description'
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
	                                renderer: function(val) { if (val == 0) return '����'; if (val == 1) return '����'; }

}]),
                            bbar: new Ext.PagingToolbar({
                                pageSize: 100,
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
