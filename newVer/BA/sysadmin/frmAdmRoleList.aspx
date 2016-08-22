<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmAdmRoleList.aspx.cs" Inherits="sysadmin_frmAdmRoleList" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>�ޱ���ҳ</title>
    <meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
    <link rel="stylesheet" type="text/css" href="../../ext3/resources/css/ext-all.css" />
	<script type="text/javascript" src="../../ext3/adapter/ext/ext-base.js"></script>	
	<script type="text/javascript" src="../../ext3/ext-all.js"></script>
	<script type="text/javascript" src="../../js/ExtJsHelper.js"></script>
	<script type="text/javascript" src="../../js/operateResp.js"></script>
	<%=getComboBoxSource() %>
	<script type="text/javascript">
	    var imageUrl = "../../Theme/1/";
	    var roleres = null;
	    var roleactions = null;
	function modifyRoleRes(roleid) {
	    if (document.getElementById("roleres") == null) {
	        roleres = new Ext.Window({
	        id: 'roleresWindows',
	            title: "��ɫ��Դ����"
	                                                    , iconCls: 'upload-win'
	                                                    , width: 400
	                                                    , height: 500
	                                                    , layout: 'fit'
	                                                    , plain: true
	                                                    , modal: true
	                                                    , x: 50
	                                                    , y: 50
	                                                    , constrain: true
	                                                    ,closeAction:'hide'
	                                                    , resizable: false
	                                                    , closeAction: 'hide'
	                                                    , autoDestroy: true
	                                                    , html: "<iframe id='roleres' src='frmRoleResource.aspx?roleid=" + roleid + "' width='100%' height='100%'></iframe>"
	                                                    , buttons: [
	                                                    {
	                                                        text: "�ر�"
		                                                    , handler: function() {
		                                                        roleres.hide();
		                                                    }
		                                                    , scope: this
}]
	        });
	    }
	    else {

	        document.getElementById("roleres").src = "frmRoleResource.aspx?roleid=" + roleid;
	        //window.open("frmRoleResource.aspx?roleid=" + roleid, "roleres");
	    }   
	    
	    roleres.show();
	}

	function modifyRoleActions(roleid) {
	    if (document.getElementById("frameroleaction") == null) {
	        roleactions = ExtJsShowWin('��ɫ������Ϣ', 'frmRoleAction.aspx?roleid=' + roleid, 'roleaction', 600, 450);
	    }
	    else {
	        document.getElementById("frameroleaction").src = "frmRoleAction.aspx?roleid=" + roleid;
	    }
	    roleactions.show();
	}
	Ext.onReady(function() {
	    var saveType = "";
	    /*------ʵ��toolbar�ĺ��� start---------------*/
	    var Toolbar = new Ext.Toolbar({
	        renderTo: "toolbar",
	        items: [{
	            text: "����",
	            icon: imageUrl + "/images/extjs/customer/add16.gif",
	            handler: function() {
	                saveType = "add";
	                //����������ʾ
	                openAddUserWin();
	            }
	        }, '-', {
	            text: "�༭",
	            icon: imageUrl + "/images/extjs/customer/edit16.gif",
	            handler: function() {
	                saveType = "editRole";
	                modifyRoleWin();
	            }
	        }, '-', {
	            text: "��Դ����",
	            icon: imageUrl + "/images/extjs/customer/add16.gif",
	            handler: function() {
	                //��Դ����
	                var sm = Ext.getCmp('userGrid').getSelectionModel();
	                var selectData = sm.getSelected();
	                if (selectData == null) {
	                    Ext.Msg.alert("��ʾ", "��ѡ����Ҫ�༭�Ľ�ɫ��Ϣ��");
	                    return;
	                }
	                modifyRoleRes(selectData.data.RoleId);
	            }
	        }, '-', {
	            text: "��������",
	            icon: imageUrl + "/images/extjs/customer/add16.gif",
	            handler: function() {
	                //��Դ����
	                var sm = Ext.getCmp('userGrid').getSelectionModel();
	                var selectData = sm.getSelected();
	                if (selectData == null) {
	                    Ext.Msg.alert("��ʾ", "��ѡ����Ҫ�������õĽ�ɫ��Ϣ��");
	                    return;
	                }
	                modifyRoleActions(selectData.data.RoleId);
	            }
	        }, '-', {
	            text: "ɾ��",
	            icon: imageUrl + "/images/extjs/customer/delete16.gif",
	            handler: function() {
	                //ɾ����ɫ
	                deleteRole();
	            }
}]
	        });

	        /*------����toolbar�ĺ��� end---------------*/

	        /*------ʵ��toolbar�İ�ť���� start---------------*/
	        /*  ��������  */
	        function openAddUserWin() {
	            Ext.getCmp("RoleId").setValue("");
	            Ext.getCmp("RoleName").setValue("");
	            Ext.getCmp("RoleLeave").setValue("");
	            Ext.getCmp("RoleComment").setValue("");
	            //  Ext.getCmp("RoleCreater").setValue("");
	            //  Ext.getCmp("RoleCreatedate").setValue("");
	            // Ext.getCmp("RoleOwnerdepart").setValue("");
	            Ext.getCmp("RoleType").setValue("");

	            if (topOrg) {
	                Ext.getCmp("RoleType").setVisible(true);
	            }
	            else {
	                Ext.getCmp("RoleType").setVisible(false);
	                Ext.getCmp("RoleType").setValue(childOrgType);
	            }
	            uploadUserWindow.show();
	        }


	        /*  �޸Ĵ���  */
	        function modifyRoleWin() {
	            var sm = Ext.getCmp('userGrid').getSelectionModel();
	            var selectData = sm.getSelected();
	            if (selectData == null) {
	                Ext.Msg.alert("��ʾ", "��ѡ����Ҫ�༭�Ľ�ɫ��Ϣ��");
	            }
	            else {
	                uploadUserWindow.show();
	                setFormValue(selectData);
	            }
	        }

	        /*ɾ����ɫ��Ϣ*/
	        function deleteRole() {

	            var sm = Ext.getCmp('userGrid').getSelectionModel();
	            //��ȡѡ���������Ϣ
	            var selectData = sm.getSelected();
	            //���û��ѡ�񣬾���ʾ��Ҫѡ��������Ϣ
	            if (selectData == null) {
	                Ext.Msg.alert("��ʾ", "��ѡ����Ҫɾ���Ľ�ɫ��Ϣ��");
	                return;
	            }
	            //ɾ��ǰ�ٴ������Ƿ����Ҫɾ��
	            Ext.Msg.confirm("��ʾ��Ϣ", "�Ƿ����Ҫɾ��ѡ��Ľ�ɫ��Ϣ��", function callBack(id) {
	                if (id == "yes") {
	                    //ҳ���ύ
	                    Ext.Ajax.request({
	                        url: 'frmAdmRoleList.aspx?method=deleteRole',
	                        method: 'POST',
	                        params: {
	                            RoleId: selectData.data.RoleId
	                        },
	                        success: function(resp, opts) {
	                            if (checkExtMessage(resp)) {
	                                useruserGridData.reload();
	                            }
	                        },
	                        failure: function(resp, opts) {
	                            Ext.Msg.alert("��ʾ", "����ɾ��ʧ��");
	                        }
	                    });
	                }
	            });
	        }


	        /*------ʵ��FormPanle�ĺ��� start---------------*/
	        var rolediv = new Ext.form.FormPanel({
	            //url:'',
	            //renderTo:'divForm',
	            frame: true,
	            id: "rolediv",
	            //title:'��ɫ��Ϣ',
	            items: [
		{
		    xtype: 'hidden',
		    fieldLabel: '��ʶ',
		    columnWidth: 1,
		    anchor: '90%',
		    name: 'RoleId',
		    id: 'RoleId',
		    hide: true
		}
, {
    xtype: 'textfield',
    fieldLabel: '��ɫ����',
    columnWidth: 1,
    anchor: '90%',
    name: 'RoleName',
    id: 'RoleName'
}
, {
    xtype: 'hidden',
    fieldLabel: '��ɫ����',
    columnWidth: 1,
    anchor: '90%',
    name: 'RoleLeave',
    id: 'RoleLeave',
    hide: true
},
 {
     xtype: 'combo',
     fieldLabel: '��ɫ����',
     columnWidth: 1,
     anchor: '90%',
     name: 'RoleType',
     id: 'RoleType',
     store: RoleTypeStore,
     displayField: 'DicsName',
     valueField: 'OrderIndex',
     typeAhead: true,
     mode: 'local',
     emptyText: '��ѡ���ɫ������Ϣ',
     triggerAction: 'all'

 }
, {
    xtype: 'textarea',
    fieldLabel: '��ɫ��ע',
    columnWidth: 1,
    anchor: '90%',
    name: 'RoleComment',
    id: 'RoleComment'
}
]
	        });

	        function cmbText(val) {
	            var index = RoleTypeStore.find('OrderIndex', val);
	            if (index < 0)
	                return "";
	            var record = RoleTypeStore.getAt(index);
	            return record.data.DicsName;
	        }
	        /*------FormPanle�ĺ������� End---------------*/

	        /*------��ʼ��ȡ���ݵĺ��� start---------------*/
	        var useruserGridData = new Ext.data.Store
({
    url: 'frmAdmRoleList.aspx?method=getrolelist',
    reader: new Ext.data.JsonReader({
        totalProperty: 'totalProperty',
        root: 'root'
    }, [
	{ name: 'RoleId' },
	{ name: 'RoleName' },
	{ name: 'RoleLeave' },
	{ name: 'RoleComment' },
	{ name: 'RoleCreater' },
	{ name: 'RoleCreatedate' },
	{ name: 'RoleOwnerdepart' },
	{ name: 'RoleType' },
	{ name: 'OrgShortName' }
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
	            el: 'userGrid',
	            width: '100%',
	            height: '100%',
	            autoWidth: true,
	            autoHeight: true,
	            autoScroll: true,
	            layout: 'fit',
	            id: 'userGrid',
	            store: useruserGridData,
	            loadMask: { msg: '���ڼ������ݣ����Ժ��' },
	            sm: sm,
	            cm: new Ext.grid.ColumnModel([
		sm,
		new Ext.grid.RowNumberer(), //�Զ��к�
		{
		    header: '��ɫ����',
		    dataIndex: 'RoleName',
		    id: 'RoleName',
		    width:150
        },	
		{
		    header: '��ɫ��ע',
		    dataIndex: 'RoleComment',
		    id: 'RoleComment',
		    width:240
		},
		{
		    header: '��ɫ����',
		    dataIndex: 'RoleType',
		    id: 'RoleType',
		    width:100,
		    renderer: cmbText
        },	
		{
		    header: '������λ',
		    dataIndex: 'OrgShortName',
		    id: 'OrgShortName',
		    width:240
		}]),
        bbar: new Ext.PagingToolbar({
            pageSize: 100,
            store: useruserGridData,
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
    useruserGridData.load({
        params: {
            start: 0,
            limit: 100
        }
    });



	        if (typeof (uploadUserWindow) == "undefined") {//�������2��windows����
	            uploadUserWindow = new Ext.Window({
	                id: 'userformwindow',
	                title: "������ɫ"
	                                                    , iconCls: 'upload-win'
	                                                    , width: 600
	                                                    , height: 300
	                                                    , layout: 'fit'
	                                                    , plain: true
	                                                    , modal: true
	                                                    , x: 50
	                                                    , y: 50
	                                                    , constrain: true
	                                                    , resizable: false
	                                                    , closeAction: 'hide'
	                                                    , autoDestroy: true

	                                                   , items: rolediv
                                                         , buttons: [{
                                                             text: "����"
		                                                    , handler: function() {
		                                                        saveUserData();

		                                                    }
			                                                    , scope: this
                                                         },
	                                                    {
	                                                        text: "ȡ��"
		                                                    , handler: function() {
		                                                        uploadUserWindow.hide();
		                                                    }
		                                                    , scope: this
}]
	            });
	        }

	        uploadUserWindow.addListener("hide", function() {
	            //userForm.getForm().reset();
	        });


	        /* ���溯�� */
	        function saveUserData() {
	            getFormValue();
	        }

	        /*------��ʼ�������ݵĺ��� Start---------------*/
	        function setFormValue(selectData) {
	            Ext.Ajax.request({
	                url: 'frmAdmRoleList.aspx?method=getrole',
	                params: {
	                    RoleId: selectData.data.RoleId
	                },
	                success: function(resp, opts) {
	                    var data = Ext.util.JSON.decode(resp.responseText);
	                    Ext.getCmp("RoleId").setValue(data.RoleId);
	                    Ext.getCmp("RoleName").setValue(data.RoleName);
	                    Ext.getCmp("RoleLeave").setValue(data.RoleLeave);
	                    Ext.getCmp("RoleComment").setValue(data.RoleComment);
	                    //	                    Ext.getCmp("RoleCreater").setValue(data.RoleCreater);
	                    //	                    Ext.getCmp("RoleCreatedate").setValue(data.RoleCreatedate);
	                    //	                    Ext.getCmp("RoleOwnerdepart").setValue(data.RoleOwnerdepart);
	                    Ext.getCmp("RoleType").setValue(data.RoleType);
	                },
	                failure: function(resp, opts) {
	                    Ext.Msg.alert("��ʾ", "��ȡ�û���Ϣʧ��");
	                }
	            });
	        }
	        /*------�������ý������ݵĺ��� End---------------*/

	        /*------��ʼ��ȡ�������ݵĺ��� start---------------*/
	        function getFormValue() {
	            var roleType = 3;
	            if(topOrg)
	            {
	                roleType = Ext.getCmp('RoleType').getValue();
	            }
	            Ext.Ajax.request({
	                url: 'frmAdmRoleList.aspx?method=' + saveType,
	                method: 'POST',
	                params: {
	                    RoleId: Ext.getCmp('RoleId').getValue(),
	                    RoleName: Ext.getCmp('RoleName').getValue(),
	                    RoleLeave: Ext.getCmp('RoleLeave').getValue(),
	                    RoleComment: Ext.getCmp('RoleComment').getValue(),
	                    //	                    RoleCreater: Ext.getCmp('RoleCreater').getValue(),
	                    //	                    RoleCreatedate: Ext.getCmp('RoleCreatedate').getValue(),
	                    //	                    RoleOwnerdepart: Ext.getCmp('RoleOwnerdepart').getValue(),
	                    RoleType: roleType
	                },
	                success: function(resp, opts) {
	                    if (checkExtMessage(resp)) {
	                        uploadUserWindow.hide();
	                        useruserGridData.reload();
	                    }
	                },
	                failure: function(resp, opts) {
	                    Ext.Msg.alert("��ʾ", "����ʧ��");
	                }
	            });
	        }
	        /*------������ȡ�������ݵĺ��� End---------------*/
	    })
</script>

</head>
<body>
    <form id="form1" runat="server">
    <div id='toolbar'></div>
<div id='userGrid'></div>
    </form>
</body>
</html>
