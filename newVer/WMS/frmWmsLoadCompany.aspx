<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmWmsLoadCompany.aspx.cs" Inherits="WMS_frmWmsLoadCompany" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html>
<head>
<title>װж��˾ά��ҳ��</title><meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<link rel="stylesheet" type="text/css" href="../ext3/resources/css/ext-all.css" />
<script type="text/javascript" src="../ext3/adapter/ext/ext-base.js"></script>
<script type="text/javascript" src="../ext3/ext-all.js"></script>
</head>
<body>
<div id='toolbar'></div>
<div id='divSearchForm'></div>
<div id='divForm'></div>
<div id='divGrid'></div>

<div style="display:none">
<select id='comboStatus' >
<option value='0'>����</option>
<option value='1'>��ֹ</option>
</select></div>
</body>
<script type="text/javascript">
    Ext.BLANK_IMAGE_URL = "../ext3/resources/images/default/s.gif";
    Ext.onReady(function() {
        /*------ʵ��toolbar�ĺ��� start---------------*/
        var Toolbar = new Ext.Toolbar({
            renderTo: "toolbar",
            items: [{
                text: "����",
                icon: "../theme/1/images/extjs/customer/add16.gif",
                handler: function() { openAddCompanyWin(); }
            }, '-', {
                text: "�༭",
                icon: "../theme/1/images/extjs/customer/edit16.gif",
                handler: function() { modifyCompanyWin(); }
            }, '-', {
                text: "ɾ��",
                icon: "../theme/1/images/extjs/customer/delete16.gif",
                handler: function() { deleteCompany(); }
}]
            });

            /*------����toolbar�ĺ��� end---------------*/


            /*------��ʼToolBar�¼����� start---------------*//*-----����Companyʵ���ര�庯��----*/
            function openAddCompanyWin() {
                Ext.getCmp('Id').setValue(""),
	            Ext.getCmp('Name').setValue(""),
	            Ext.getCmp('Address').setValue(""),
	            Ext.getCmp('Contact').setValue(""),
	            Ext.getCmp('Phone').setValue(""),
	            Ext.getCmp('Qq').setValue(""),
	            Ext.getCmp('Msn').setValue(""),
	            Ext.getCmp('Remark').setValue(""),
	            Ext.getCmp('Status').setValue(""),
	            uploadCompanyWindow.show();
            }
            /*-----�༭Companyʵ���ര�庯��----*/
            function modifyCompanyWin() {
                var sm = gridData.getSelectionModel();
                //��ȡѡ���������Ϣ
                var selectData = sm.getSelected();
                if (selectData == null) {
                    Ext.Msg.alert("��ʾ", "��ѡ����Ҫ�༭����Ϣ��");
                    return;
                }
                uploadCompanyWindow.show();
                setFormValue(selectData);
            }
            /*-----ɾ��Companyʵ�庯��----*/
            /*ɾ����Ϣ*/
            function deleteCompany() {
                var sm = gridData.getSelectionModel();
                //��ȡѡ���������Ϣ
                var selectData = sm.getSelected();
                //���û��ѡ�񣬾���ʾ��Ҫѡ��������Ϣ
                if (selectData == null) {
                    Ext.Msg.alert("��ʾ", "��ѡ����Ҫɾ������Ϣ��");
                    return;
                }
                //ɾ��ǰ�ٴ������Ƿ����Ҫɾ��
                Ext.Msg.confirm("��ʾ��Ϣ", "�Ƿ����Ҫɾ��ѡ���װж��˾��Ϣ��", function callBack(id) {
                    //�ж��Ƿ�ɾ������
                    if (id == "yes") {
                        //ҳ���ύ
                        Ext.Ajax.request({
                            url: 'frmWmsLoadCompany.aspx?method=deleteCompanyAction',
                            method: 'POST',
                            params: {
                                Id: selectData.data.Id
                            },
                            success: function(resp, opts) {
                                Ext.Msg.alert("��ʾ", "����ɾ���ɣ�");
                                updateDataGrid();
                            },
                            failure: function(resp, opts) {
                                Ext.Msg.alert("��ʾ", "����ɾ��ʧ�ܣ�");
                            }
                        });
                    }
                });
            }
            function updateDataGrid() {
                var Name = NamePanel.getValue();
                var Phone = PhonePanel.getValue();
                var Address = AddressPanel.getValue();
                var Status = StatusPanel.getValue();
                var type= CompanyTypePanel.getValue();

                gridDataData.baseParams.Name = Name;
                gridDataData.baseParams.Phone = Phone;
                gridDataData.baseParams.Address = Address;
                gridDataData.baseParams.Status = Status;
                gridDataData.baseParams.CompType = type;

                gridDataData.load({
                    params: {
                        start: 0,
                        limit: 10
                    }
                });
            }

            /*------ʵ��FormPanle�ĺ��� start---------------*/
            var formData = new Ext.form.FormPanel({
                url: '',
                //renderTo:'divForm',
                labelWidth:60,
                frame: true,
                title: '',
                items: [
		{
		    xtype: 'hidden',
		    fieldLabel: '��ʶ',
		    columnWidth: 1,
		    anchor: '95%',
		    name: 'Id',
		    id: 'Id',
		    hidden: true,
		    hiddenLabel: true
		}
, {
    xtype: 'textfield',
    fieldLabel: '����',
    columnWidth: 1,
    anchor: '95%',
    name: 'Name',
    id: 'Name'
}
, {
    xtype: 'textfield',
    fieldLabel: '��ַ',
    columnWidth: 1,
    anchor: '95%',
    name: 'Address',
    id: 'Address'
}
, {
    xtype: 'textfield',
    fieldLabel: '��ϵ��',
    columnWidth: 1,
    anchor: '95%',
    name: 'Contact',
    id: 'Contact'
}
, {
    xtype: 'textfield',
    fieldLabel: '�绰',
    columnWidth: 1,
    anchor: '95%',
    name: 'Phone',
    id: 'Phone'
}
, {
    xtype: 'textfield',
    fieldLabel: 'QQ��',
    columnWidth: 1,
    anchor: '95%',
    name: 'Qq',
    id: 'Qq'
}
, {
    xtype: 'textfield',
    fieldLabel: 'MSN',
    columnWidth: 1,
    anchor: '95%',
    name: 'Msn',
    id: 'Msn'
}
, {
    xtype: 'combo',
    fieldLabel: '��λ����',
    name: 'CompType',
    id: 'CompType',
    width: 65,
    anchor: '95%',
    store: [['W1301', "װж��λ"], ['W1302', "���䵥λ"]],
    typeAhead: false,
    triggerAction: 'all',
    columnWidth: 1
}
, {
    xtype: 'textfield',
    fieldLabel: '��ע',
    columnWidth: 1,
    anchor: '95%',
    name: 'Remark',
    id: 'Remark'
}
, {
    xtype: 'combo',
    fieldLabel: '״̬',
    columnWidth: 1,
    anchor: '95%',
    name: 'Status',
    id: 'Status',
    transform: 'comboStatus',
    typeAhead: false,
    triggerAction: 'all',
    lazyRender: true,
    editable: false
}
]
            });
            /*------FormPanle�ĺ������� End---------------*/

            /*------��ʼ�������ݵĴ��� Start---------------*/
            if (typeof (uploadCompanyWindow) == "undefined") {//�������2��windows����
                uploadCompanyWindow = new Ext.Window({
                    id: 'Companyformwindow'
                    //title:formTitle
		        , iconCls: 'upload-win'
		        , width: 520
		        , height: 320
		        , layout: 'fit'
		        , plain: true
		        , modal: true
		        , x: 50
		        , y: 50
		        , constrain: true
		        , resizable: false
		        , closeAction: 'hide'
		        , autoDestroy: true
		        , items: formData
		        , buttons: [{
		    text: "����"
			, handler: function() {
			    //saveUserData();
			    getFormValue();
			    uploadCompanyWindow.hide();
			    updateDataGrid();
			}
			, scope: this
		},
		{
		    text: "ȡ��"
			, handler: function() {
			    uploadCompanyWindow.hide();
			}
			, scope: this
}]
                });
            }
            uploadCompanyWindow.addListener("hide", function() {
            });

            /*------��ʼ��ȡ�������ݵĺ��� start---------------*/
            function getFormValue() {
                Ext.Ajax.request({
                    url: 'frmWmsLoadCompany.aspx?method=saveCompanyInfoAction',
                    method: 'POST',
                    params: {
                        Id: Ext.getCmp('Id').getValue(),
                        Name: Ext.getCmp('Name').getValue(),
                        Address: Ext.getCmp('Address').getValue(),
                        Contact: Ext.getCmp('Contact').getValue(),
                        Phone: Ext.getCmp('Phone').getValue(),
                        Qq: Ext.getCmp('Qq').getValue(),
                        CompType: Ext.getCmp('CompType').getValue(),
                        Msn: Ext.getCmp('Msn').getValue(),
                        Remark: Ext.getCmp('Remark').getValue(),
                        Status: Ext.getCmp('Status').getValue()
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
                    url: 'frmWmsLoadCompany.aspx?method=getCompanyInfoAction',
                    params: {
                        Id: selectData.data.Id
                    },
                    success: function(resp, opts) {
                        var data = Ext.util.JSON.decode(resp.responseText);
                        Ext.getCmp("Id").setValue(data.Id);
                        Ext.getCmp("Name").setValue(data.Name);
                        Ext.getCmp("Address").setValue(data.Address);
                        Ext.getCmp("Contact").setValue(data.Contact);
                        Ext.getCmp("Phone").setValue(data.Phone);
                        Ext.getCmp("Qq").setValue(data.Qq);
                        Ext.getCmp("CompType").setValue(data.CompType);
                        Ext.getCmp("Msn").setValue(data.Msn);
                        Ext.getCmp("Remark").setValue(data.Remark);
                        Ext.getCmp("Status").setValue(data.Status);
                    },
                    failure: function(resp, opts) {
                        Ext.Msg.alert("��ʾ", "��ȡװж��˾��Ϣʧ�ܣ�");
                    }
                });
            }
            /*------�������ý������ݵĺ��� End---------------*/
            /*------��ʼ��ѯform�ĺ��� start---------------*/

            var NamePanel = new Ext.form.TextField({
                style: 'margin-left:0px',
                cls: 'key',
                xtype: 'textfield',
                fieldLabel: '��λ����',
                anchor: '95%',
                listeners: { specialkey: function(f, e) { if (e.getKey() == e.ENTER) { Ext.getCmp('SPhone').focus(); } } }

            });


            var PhonePanel = new Ext.form.TextField({
                style: 'margin-left:0px',
                cls: 'key',
                xtype: 'textfield',
                fieldLabel: '�绰',
                anchor: '95%',
                id: 'SPhone',
                listeners: { specialkey: function(f, e) { if (e.getKey() == e.ENTER) { Ext.getCmp('SAddress').focus(); } } }
            });
            var AddressPanel = new Ext.form.TextField({
                style: 'margin-left:0px',
                cls: 'key',
                xtype: 'textfield',
                fieldLabel: '��ַ',
                anchor: '95%',
                id: 'SAddress',
                listeners: { specialkey: function(f, e) { if (e.getKey() == e.ENTER) { CompanyTypePanel.focus(); } } }
            });
            
            var CompanyTypePanel = new Ext.form.ComboBox({
                fieldLabel: '��λ����',
                name: 'CompanyType',
                id: 'CompanyType',
                width: 65,
                anchor: '95%',
                //transform: 'comboStatus',
                store: [['W1301', "װж��λ"], ['W1302', "���䵥λ"]],
                typeAhead: false,
                triggerAction: 'all',
                lazyRender: true,
                editable: false,
                listeners: { specialkey: function(f, e) { if (e.getKey() == e.ENTER) { Ext.getCmp('searchebtnId').focus(); } }
                }
            });
            CompanyTypePanel.setValue('W1301');

            var StatusPanel = new Ext.form.ComboBox({
                fieldLabel: '״̬',
                name: 'Status1',
                id: 'Status1',
                width: 65,
                anchor: '95%',
                //transform: 'comboStatus',
                store: [[0, "����"], [1, "����"]],
                typeAhead: false,
                triggerAction: 'all',
                lazyRender: true,
                editable: false,
                listeners: { specialkey: function(f, e) { if (e.getKey() == e.ENTER) { Ext.getCmp('searchebtnId').focus(); } }

                }

            });
            StatusPanel.setValue(0);

            var divSearchForm = new Ext.FormPanel({
                renderTo: 'divSearchForm',
                labelAlign: 'left',
                buttonAlign: 'right',
                bodyStyle: 'padding:5px',
                frame: true,
                labelWidth: 70,
                items: [
                {
                    layout: 'column',   //�����Ԫ��Ϊ����Ϊ�в��ַ�ʽ
                    items: [
                    {
                        columnWidth: .25,  //����ռ�õĿ�ȣ���ʶΪ20��
                        layout: 'form',
                        border: false,
                        items: [
                            NamePanel
                        ]
                    }, {
                        columnWidth: .25,
                        layout: 'form',
                        border: false,
                        items: [
                            PhonePanel
                        ]
                    }, {
                        columnWidth: .25,
                        layout: 'form',
                        border: false,
                        items: [
                            AddressPanel
                        ]
                    }]
                }, {
                    layout: 'column',   //�����Ԫ��Ϊ����Ϊ�в��ַ�ʽ
                    items: [{
                        columnWidth: .25,
                        layout: 'form',
                        border: false,
                        items: [
                            CompanyTypePanel
                        ]
                    }, {
                        columnWidth: .25,
                        layout: 'form',
                        border: false,
                        items: [
                        StatusPanel
                        ]
                    }, {
                        columnWidth: .1,
                        layout: 'form',
                        border: false,
                        items: [{ cls: 'key',
                            xtype: 'button',
                            text: '��ѯ',
                            id: 'searchebtnId',
                            anchor: '90%',
                            handler: function() {
                                updateDataGrid();
                            }
                        }]
                    }]
                }]
            });


                        /*------��ʼ��ѯform�ĺ��� end---------------*/
                        /*------��ʼ��ȡ���ݵĺ��� start---------------*/
                        var gridDataData = new Ext.data.Store
({
    url: 'frmWmsLoadCompany.aspx?method=getCompanyListAction',
    reader: new Ext.data.JsonReader({
        totalProperty: 'totalProperty',
        root: 'root'
    }, [
	{
	    name: 'Id'
	},
	{
	    name: 'Name'
	},
	{
	    name: 'Address'
	},
	{
	    name: 'Contact'
	},
	{
	    name: 'Phone'
	},
	{
	    name: 'Qq'
	},
	{
	    name: 'CompType'
	},,
	{
	    name: 'Msn'
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

                        /*------��ʼDataGrid�ĺ��� start---------------*/

                        var sm = new Ext.grid.CheckboxSelectionModel({
                            singleSelect: true
                        });
                        var gridData = new Ext.grid.GridPanel({
                            el: 'divGrid',
                            width: '100%',
                            height: '100%',
                            autoWidth: true,
                            autoHeight: true,
                            autoScroll: true,
                            layout: 'fit',
                            id: '',
                            store: gridDataData,
                            loadMask: { msg: '���ڼ������ݣ����Ժ��' },
                            sm: sm,
                            cm: new Ext.grid.ColumnModel([
		sm,
		new Ext.grid.RowNumberer(), //�Զ��к�
		{
		header: '��ʶ',
		dataIndex: 'Id',
		id: 'Id',
		hidden: true,
		hideable: false
},
		{
		    header: '����',
		    dataIndex: 'Name',
		    id: 'Name'
		},
		{
		    header: '��ַ',
		    dataIndex: 'Address',
		    id: 'Address'
		},
		{
		    header: '��ϵ��',
		    dataIndex: 'Contact',
		    id: 'Contact'
		},
		{
		    header: '�绰',
		    dataIndex: 'Phone',
		    id: 'Phone'
		},
		{
		    header: 'QQ��',
		    dataIndex: 'Qq',
		    id: 'Qq'
		},
		{
		    header: '��λ����',
		    dataIndex: 'CompType',
		    id: 'CompType',
		    renderer:function(val){
		        if (val == 'W1301') return 'װж��λ'; if (val == 'W1302') return '���䵥λ'; 
		    }
		},
		{
		    header: 'MSN',
		    dataIndex: 'Msn',
		    id: 'Msn'
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
                                pageSize: 10,
                                store: gridDataData,
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
                        gridData.render();
                        /*------DataGrid�ĺ������� End---------------*/

                        updateDataGrid();

                    })
</script>

</html>
