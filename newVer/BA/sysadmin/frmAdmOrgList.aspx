<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmAdmOrgList.aspx.cs" Inherits="BA_sysadmin_frmAdmOrgList" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>�ޱ���ҳ</title>
    <meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
    <link rel="stylesheet" type="text/css" href="../../ext3/resources/css/ext-all.css" />
    <script type="text/javascript" src="../../ext3/adapter/ext/ext-base.js"></script>
    <script type="text/javascript" src="../../ext3/ext-all.js"></script>
    <script type="text/javascript" src="../../ext3/example/ColumnNodeUI.js"></script>
	<link rel="Stylesheet" type="text/css" href="../../ext3/example/ColumnNodeUI.css" />
	<script type="text/javascript" src="../../js/ExtJsHelper.js"></script>
	<script type="text/javascript" src="../../js/operateResp.js"></script>
	
	<%=getComboBoxSource()%>
    <script type="text/javascript">
        var deptList = null;
        function modifyDeptList(orgid) {
            if (document.getElementById("framedeptlist") == null) {
                deptList = ExtJsShowWin('����������Ϣ', 'frmAdmDeptList.aspx?orgid=' + orgid, 'deptlist', 600, 450);
            }
            else {
                document.getElementById("framedeptlist").src = "frmAdmDeptList.aspx?orgid=" + orgid;
            }
            deptList.show();
        }
        Ext.onReady(function() {
            Ext.BLANK_IMAGE_URL = "../../ext3/resources/images/default/s.gif"
            var imageUrl = "../../Theme/1/";
            var saveType = "";
            var formTitle = "";
            /*------ʵ��toolbar�ĺ��� start---------------*/
            var Toolbar = new Ext.Toolbar({
                renderTo: "toolbar",
                items: [{
                    text: "����",
                    icon: imageUrl + "images/extjs/customer/add16.gif",
                    handler: function() {
                        saveType = "add";
                        formTitle = "����������Ϣ"
                        //����������ʾ
                        openAddOrgWin();
                        AddKeyDownEvent('uploadOrgWindow');
                        Ext.getCmp('OrgName').focus();
                    }
                }, '-', {
                    text: "�༭",
                    icon: imageUrl + "images/extjs/customer/edit16.gif",
                    handler: function() {
                        saveType = "editorg";
                        formTitle = "�޸Ļ�����Ϣ"
                        modifyOrgWin();
                        AddKeyDownEvent('uploadOrgWindow');
                        Ext.getCmp('OrgName').focus();
                    }
                }, '-', {
                    text: "���ò���",
                    icon: imageUrl + "images/extjs/customer/edit16.gif",
                    handler: function() {
                        if (tree.selModel.selNode != null) {
                            modifyDeptList(tree.selModel.selNode.id);
                        }
                        else {
                            Ext.Msg.alert("��ѡ����Ҫ���õĻ�����Ϣ��");
                        }
                    }
                }, '-', {
                    text: "ɾ��",
                    icon: imageUrl + "images/extjs/customer/delete16.gif",
                    handler: function() {
                        deleteOrg();
                    }
                }, '-', {
                    text: "��������Ա",
                    icon: imageUrl + "images/extjs/customer/edit16.gif",
                    handler: function() {
                        modifyUserWin();
                    }
                }, '-']
            });

            /*------����toolbar�ĺ��� end---------------*/

            setToolBarVisible(Toolbar);
            /*------��ʼToolBar�¼����� start---------------*//*-----����Orgʵ���ര�庯��----*/
            function openAddOrgWin() {
                Ext.getCmp('OrgId').setValue("-1");
                Ext.getCmp('OrgName').setValue("");
                Ext.getCmp('OrgAddress').setValue("");
                Ext.getCmp('OrgZip').setValue("");
                Ext.getCmp('OrgCode').setValue("");
                Ext.getCmp('OrgLevel').setValue("");
                Ext.getCmp('OrgParent').setValue("");
                Ext.getCmp('OrgParentName').setValue("");
                Ext.getCmp('OrgShortName').setValue("");
                Ext.getCmp('OrgNo').setValue("");
                if (tree.selModel.selNode != null) {

                    Ext.getCmp('OrgParent').setValue(tree.selModel.selNode.id);
                    Ext.getCmp('OrgParentName').setValue(tree.selModel.selNode.attributes.text);
                }
                Ext.getCmp('OrgArea').setValue("");
                Ext.getCmp('OrgType').setValue("");
                //                    Ext.getCmp('OperatorId').setValue("");
                //                    Ext.getCmp('CreateDate').setValue("");
                //                    Ext.getCmp('RecOrgId').setValue("");

                uploadOrgWindow.show();
            }
            /*-----�༭Orgʵ���ര�庯��----*/
            function modifyOrgWin() {
                if (tree.selModel.selNode == null) {
                    Ext.Msg.alert("��ʾ", "��ѡ����Ҫ�༭����Ϣ��");
                    return;
                }
                uploadOrgWindow.show();
                setFormValue(tree.selModel.selNode.id);
            }
            /*-----ɾ��Orgʵ�庯��----*/
            /*ɾ����Ϣ*/
            function deleteOrg() {

                //���û��ѡ�񣬾���ʾ��Ҫѡ��������Ϣ
                if (tree.selModel.selNode == null) {
                    Ext.Msg.alert("��ʾ", "��ѡ����Ҫɾ������Ϣ��");
                    return;
                }
                //ɾ��ǰ�ٴ������Ƿ����Ҫɾ��
                Ext.Msg.confirm("��ʾ��Ϣ", "�Ƿ����Ҫɾ��ѡ��Ļ�����Ϣ��", function callBack(id) {
                    //�ж��Ƿ�ɾ������
                    if (id == "yes") {
                        //ҳ���ύ
                        Ext.Ajax.request({
                            url: 'frmAdmOrgList.aspx?method=deleteorg',
                            method: 'POST',
                            params: {
                                OrgId: tree.selModel.selNode.id
                            },
                            success: function(resp, opts) {
                                if (checkExtMessage(resp)) {
                                    var node = tree.selModel.selNode;
                                    var parent = node.parentNode;
                                    parent.removeChild(node);
                                    if (!parent.childNodes) {
                                        node.parentNode.getUI().removeClass('x-tree-node-expanded');
                                        node.parentNode.getUI().addClass('x-tree-node-leaf');
                                    }
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
            var orgdiv = new Ext.form.FormPanel({
                frame: true,
                title: '',
                items: [
		{
		    xtype: 'hidden',
		    fieldLabel: '������ʶ',
		    columnWidth: 1,
		    anchor: '90%',
		    name: 'OrgId',
		    id: 'OrgId'
		}
, {
    xtype: 'textfield',
    fieldLabel: '��������',
    columnWidth: 1,
    anchor: '90%',
    name: 'OrgName',
    id: 'OrgName'
}, {
    xtype: 'textfield',
    fieldLabel: '���',
    columnWidth: 1,
    anchor: '90%',
    name: 'OrgShortName',
    id: 'OrgShortName'
}, {
    xtype: 'textfield',
    fieldLabel: '������ַ',
    columnWidth: 1,
    anchor: '90%',
    name: 'OrgAddress',
    id: 'OrgAddress'
}
, {
    xtype: 'textfield',
    fieldLabel: '�����ʱ�',
    columnWidth: 1,
    anchor: '90%',
    name: 'OrgZip',
    id: 'OrgZip'
}
, {
    xtype: 'textfield',
    fieldLabel: '��������',
    columnWidth: 1,
    anchor: '90%',
    name: 'OrgCode',
    id: 'OrgCode'
}, {
    xtype: 'textfield',
    fieldLabel: '����Ʊ�ݱ��',
    columnWidth: 1,
    anchor: '90%',
    name: 'OrgNo',
    id: 'OrgNo'
}
, {
    xtype: 'textfield',
    fieldLabel: '��������',
    columnWidth: 1,
    anchor: '90%',
    name: 'OrgLevel',
    id: 'OrgLevel'
}
, {
    xtype: 'hidden',
    fieldLabel: '�ϼ�����',
    columnWidth: 1,
    anchor: '90%',
    name: 'OrgParent',
    id: 'OrgParent'
}, {
    xtype: 'textfield',
    fieldLabel: '�ϼ���������',
    columnWidth: 1,
    anchor: '90%',
    name: 'OrgParentName',
    id: 'OrgParentName'
}, {
    xtype: 'combo',
    fieldLabel: '���ڵ���',
    columnWidth: 1,
    anchor: '90%',
    name: 'OrgArea',
    id: 'OrgArea',
    editable: false,
    store: OrgAreaStore,
    displayField: 'DicsName',
    valueField: 'DicsCode',
    typeAhead: true,
    mode: 'local',
    emptyText: '��ѡ�����ڵ�����Ϣ',
    triggerAction: 'all'
}, {
    xtype: 'textfield',
    fieldLabel: '���˵�ַ',
    columnWidth: 1,
    anchor: '90%',
    name: 'SendAdd',
    id: 'SendAdd'
}, {
    xtype: 'combo',
    fieldLabel: '���˷�ʽ',
    columnWidth: 1,
    anchor: '90%',
    name: 'SendType',
    id: 'SendType',
    editable: false,
    store: SendTypeStore,
    displayField: 'DicsName',
    valueField: 'DicsCode',
    typeAhead: true,
    mode: 'local',
    emptyText: '��ѡ���˷�ʽ��Ϣ',
    triggerAction: 'all'
}, {
    xtype: 'combo',
    fieldLabel: '��������',
    columnWidth: 1,
    anchor: '90%',
    name: 'OrgType',
    id: 'OrgType',
    editable: false,
    store: OrgTypeStore,
    displayField: 'DicsName',
    valueField: 'DicsCode',
    typeAhead: true,
    mode: 'local',
    emptyText: '��ѡ�����������Ϣ',
    triggerAction: 'all'
}
]
            });
            /*------FormPanle�ĺ������� End---------------*/

            /*------��ʼ�������ݵĴ��� Start---------------*/
            if (typeof (uploadOrgWindow) == "undefined") {//�������2��windows����
                uploadOrgWindow = new Ext.Window({
                    id: 'Orgformwindow',
                    title: formTitle
		, iconCls: 'upload-win'
		, width: 600
		, height: 420
		, layout: 'fit'
		, plain: true
		, modal: true
		, x: 50
		, y: 50
		, constrain: true
		, resizable: false
		, closeAction: 'hide'
		, autoDestroy: true
		, items: orgdiv
		, buttons: [{
		    text: "����"
			, handler: function() {
			    getFormValue();
			}
			, scope: this
		},
		{
		    text: "ȡ��"
			, handler: function() {
			    uploadOrgWindow.hide();
			}
			, scope: this
}]
                });
            }
            uploadOrgWindow.addListener("hide", function() {
            });

            /*------��ʼ��ȡ�������ݵĺ��� start---------------*/
            function getFormValue() {

                Ext.Ajax.request({
                    url: 'frmAdmOrgList.aspx?method=' + saveType,
                    method: 'POST',
                    params: {
                        OrgId: Ext.getCmp('OrgId').getValue(),
                        OrgName: Ext.getCmp('OrgName').getValue(),
                        OrgAddress: Ext.getCmp('OrgAddress').getValue(),
                        OrgZip: Ext.getCmp('OrgZip').getValue(),
                        OrgCode: Ext.getCmp('OrgCode').getValue(),
                        OrgLevel: Ext.getCmp('OrgLevel').getValue(),
                        OrgParent: Ext.getCmp('OrgParent').getValue(),
                        OrgShortName: Ext.getCmp('OrgShortName').getValue(),
                        OrgNo: Ext.getCmp('OrgNo').getValue(),
                        SendAdd: Ext.getCmp('SendAdd').getValue(),
                        SendType: Ext.getCmp('SendType').getValue(),
                        OrgArea: Ext.getCmp('OrgArea').getValue(),
                        OrgType: Ext.getCmp('OrgType').getValue()
                        //                            OperatorId: Ext.getCmp('OperatorId').getValue(),
                        //                            CreateDate: Ext.getCmp('CreateDate').getValue(),
                        //                            RecOrgId: Ext.getCmp('RecOrgId').getValue()
                    },
                    success: function(resp, opts) {
                        if (checkExtMessage(resp)) {
                            var resu = Ext.decode(resp.responseText);
                            var parentNode = tree.selModel.selNode;
                            //tree.loader.reload();
                            if (saveType == "add") {

                                if (parentNode.childNodes == null) {
                                    node.parentNode.getUI().removeClass('x-tree-node-leaf');
                                    node.parentNode.getUI().addClass('x-tree-node-expanded');
                                }
                                parentNode.appendChild(Ext.decode(unescape(resu.id)));
                            }
                            else {
                                parentNode.attributes.CustomerColumn = Ext.getCmp('OrgCode').getValue();
                                parentNode.attributes.CustomerColumn1 = Ext.getCmp('OrgAddress').getValue();
                                parentNode.attributes.CustomerColumn2 = Ext.getCmp('OrgZip').getValue();
                                parentNode.setText(Ext.getCmp('OrgName').getValue());

                            }
                            //                                var node = new Ext.tree.TreeNode();
                            //                                node.id=resu.id;
                            //                                node.text=Ext.getCmp('OrgName').getValue();
                            //                                node.attributes.id=resu.id;
                            //                                node.attributes.text=Ext.getCmp('OrgName').getValue();
                            //                                node.attributes.uiProvider="col";
                            //                                node.attributes.CustomerColumn=Ext.getCmp('OrgCode').getValue();
                            //                                node.attributes.CustomerColumn1=Ext.getCmp('OrgAddress').getValue();
                            //                                node.attributes.CustomerColumn2=Ext.getCmp('OrgZip').getValue();               
                            //                                parentNode.appendChild(node);

                            uploadOrgWindow.hide();
                        }
                    },
                    failure: function(resp, opts) {
                        Ext.Msg.alert("��ʾ", "����ʧ��");
                    }
                });
            }
            /*------������ȡ�������ݵĺ��� End---------------*/

            /*------��ʼ�������ݵĺ��� Start---------------*/
            function setFormValue(selectData) {
                Ext.Ajax.request({
                    url: 'frmAdmOrgList.aspx?method=getorg',
                    params: {
                        OrgId: selectData
                    },
                    success: function(resp, opts) {
                        var data = Ext.util.JSON.decode(resp.responseText);
                        Ext.getCmp("OrgId").setValue(data.OrgId);
                        Ext.getCmp("OrgName").setValue(data.OrgName);
                        Ext.getCmp("OrgAddress").setValue(data.OrgAddress);
                        Ext.getCmp("OrgZip").setValue(data.OrgZip);
                        Ext.getCmp("OrgCode").setValue(data.OrgCode);
                        Ext.getCmp("OrgLevel").setValue(data.OrgLevel);
                        Ext.getCmp("OrgParent").setValue(data.OrgParent);
                        Ext.getCmp("OrgParentName").setValue(data.OrgParentName);
                        Ext.getCmp('OrgShortName').setValue(data.OrgShortName);
                        Ext.getCmp('SendAdd').setValue(data.SendAdd);
                        Ext.getCmp('SendType').setValue(data.SendType);
                        Ext.getCmp('OrgNo').setValue(data.OrgNo);
                        Ext.getCmp('OrgArea').setValue(data.OrgArea);
                        Ext.getCmp('OrgType').setValue(data.OrgType);
                        //                            Ext.getCmp("OperatorId").setValue(data.OperatorId);
                        //                            Ext.getCmp("CreateDate").setValue(data.CreateDate);
                        //                            Ext.getCmp("RecOrgId").setValue(data.RecOrgId);
                        //                            alert(tree.selModel.selNode.parentNode.id);
                        //                            if (tree.selModel.selNode.parentNode != null) {
                        //                                Ext.getCmp('OrgParentName').setValue(tree.selModel.selNode.parentNode.attributes.text);
                        //                            }
                    },
                    failure: function(resp, opts) {
                        Ext.Msg.alert("��ʾ", "��ȡ������Ϣʧ��");
                    }
                });
            }
            /*------�������ý������ݵĺ��� End---------------*/

            /*------��ʼ��ȡ���ݵĺ��� start---------------*/
            var gridDataData = new Ext.data.Store
({
    url: 'frmAdmOrgList.aspx?method=getorglist',
    reader: new Ext.data.JsonReader({
        totalProperty: 'totalProperty',
        root: 'root'
    }, [
	{
	    name: 'OrgId'
	},
	{
	    name: 'OrgName'
	},
	{
	    name: 'OrgAddress'
	},
	{
	    name: 'OrgZip'
	},
	{
	    name: 'OrgCode'
	},
	{
	    name: 'OrgLevel'
	},
	{
	    name: 'OrgParent'
	},
	{
	    name: 'OperatorId'
	},
	{
	    name: 'CreateDate'
	},
	{
	    name: 'RecOrgId'
	}, { name: 'OrgArea' }, { name: 'OrgType'}])
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

            var tree = new Ext.ux.tree.ColumnTree({
                width: 800,
                height: 300,
                rootVisible: false,
                autoScroll: true,
                title: '��Դ��Ϣ',
                renderTo: 'orgGrid',
                id: 'treeColumn',

                columns: [{
                    header: '��������',
                    width: 220,
                    dataIndex: 'text'
                }, {
                    header: '��������',
                    width: 100,
                    dataIndex: 'CustomerColumn'
                }, {
                    header: '������ַ',
                    width: 200,
                    dataIndex: 'CustomerColumn1'
                }, {
                    header: '�����ʱ�',
                    width: 200,
                    dataIndex: 'CustomerColum2'
}],

                    loader: new Ext.tree.TreeLoader({
                        dataUrl: 'frmAdmOrgList.aspx?method=gettreecolumnlist',
                        uiProviders: {
                            'col': Ext.ux.tree.ColumnNodeUI
                        }
                    }),

                    root: new Ext.tree.AsyncTreeNode({
                        text: 'Tasks'
                    })
                });
                tree.render();


                /*�����û���Ϣ*/
                var userForm = new Ext.form.FormPanel({
                    region: "north",
                    collapsible: true,
                    //renderTo:'cc',
                    //layout:'fit',
                    height: 150,
                    id: 'useraddfrom',
                    frame: true,
                    items: [
{
    layout: 'column',
    border: false,
    items: [{
        layout: 'form',
        border: false,
        columnWidth: 1,
        items: [{
            xtype: 'textfield',
            fieldLabel: '�û���',
            anchor: '90%',
            id: 'UserName'}]
}]
        },
{
    layout: 'column',
    border: false,
    items: [{
        layout: 'form',
        border: false,
        columnWidth: 0.5,
        items: [{
            xtype: 'textfield',
            fieldLabel: '��ʵ����',
            anchor: '90%',
            id: 'UserRealname'}]
        }
        , {
            layout: 'form',
            border: false,
            columnWidth: 0.5,
            items: [{
                xtype: 'textfield',
                inputType: 'password',
                fieldLabel: '����',
                anchor: '90%',
                id: 'UserPassword'}]
}]
            },
{
    layout: 'column',
    border: false,
    items: [{
        layout: 'form',
        border: false,
        columnWidth: 0.5,
        items: [{
            style: 'align:left',
            xtype: 'checkbox',
            fieldLabel: '�Ƿ�����',
            anchor: '90%',
            id: 'UserIslocked',
            name: 'UserIslocked'}]
        }
        , {
            layout: 'form',
            border: false,
            columnWidth: 0.5,
            items: [{
                style: 'align:left',
                xtype: 'checkbox',
                fieldLabel: '�Ƿ��IP',
                anchor: '90%',
                id: 'UserBindip',
                name: 'UserBindip'}]
}]
            },
{
    layout: 'column',
    border: false,
    items: [{
        layout: 'form',
        border: false,
        columnWidth: 1,
        items: [{
            xtype: 'textfield',
            fieldLabel: 'IP��ַ',
            anchor: '70%',
            id: 'UserIpaddress'}]
}]
}]
                });
                var selectedUserId = 0;
                /*���ɽ�ɫѡ���Tree����Ϣ******/

                var userTree = new Ext.tree.TreePanel({
                    //el: 'tree-div',
                    useArrows: true,
                    region: "center",
                    autoScroll: true,
                    animate: true,
                    enableDD: true,
                    containerScroll: true,
                    //height:150,

                    rootVisible: false,

                    loader: new Ext.tree.TreeLoader({
                        dataUrl: 'userManager.aspx?method=getRoleByUser'
                    })
                });
                userTree.getLoader().on("beforeload", function(treeLoader, node) {
                    treeLoader.baseParams.UserId = selectedUserId;
                }, this);



                // set the root node
                var root = new Ext.tree.AsyncTreeNode({
                    text: '��ɫ��Ϣ',
                    draggable: false,
                    id: 'source'
                });
                userTree.setRootNode(root);


                //��ȡѡ��Ľڵ���Ϣ
                function getUserSelectNodes() {
                    var selectNodes = userTree.getChecked();
                    var ids = "";
                    for (var i = 0; i < selectNodes.length; i++) {
                        if (ids.length > 0)
                            ids += ",";
                        ids += selectNodes[i].id;
                    }
                    return ids;
                }
                /*****/

                if (typeof (uploadUserWindow) == "undefined") {//�������2��windows����
                    uploadUserWindow = new Ext.Window({
                        id: 'userformwindow',
                        title: "�����û�"
	                                                    , iconCls: 'upload-win'
	                                                    , width: 600
	                                                    , height: 450
	                                                    , layout: 'border'
	                                                    , plain: true
	                                                    , modal: true
	                                                    , x: 50
	                                                    , y: 50
	                                                    , constrain: true
	                                                    , resizable: false
	                                                    , closeAction: 'hide'
	                                                    , autoDestroy: true

	                                                   , items: [userForm, userTree]
                                                         , buttons: [{
                                                             text: "����"
		                                                    , handler: function() {
		                                                        //saveUserData();

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

                //                        uploadUserWindow.addListener("hide", function() {
                //                            userForm.getForm().reset();
                //                        });

                /*  �޸Ĵ���  */
                function modifyUserWin() {
                    if (tree.selModel.selNode == null) {
                        Ext.Msg.alert("��ʾ", "��ѡ����Ҫ������������Ա�Ļ�����Ϣ��");
                        return;
                    }
                    uploadUserWindow.show();

                    Ext.Ajax.request({
                        url: 'frmadmorglist.aspx?method=getuserbyorgid',
                        params: {
                            OrgId: tree.selModel.selNode.id//�����û�seqId
                        },
                        success: function(resp, opts) {
                            //��û�д����û�
                            if (resp.responseText == "") {

                                Ext.getCmp("UserName").setValue("");
                                //                                Ext.getCmp("UserIslocked").dom.checked = false;
                                //                                Ext.getCmp("UserBindip").dom.checked = false;
                                Ext.getCmp("UserIpaddress").setValue("");

                                Ext.getCmp("UserRealname").setValue(tree.selModel.selNode.attributes.text);
                                selectedUserId = 0;
                                userTree.root.reload();
                                return;
                            }
                            var data = Ext.util.JSON.decode(resp.responseText);
                            selectedUserId = data.UserId;
                            userTree.root.reload();

                            //Ext.getCmp("UserId").setValue(data.UserId);
                            Ext.getCmp("UserName").setValue(data.UserName);
                            Ext.getCmp("UserRealname").setValue(data.UserRealname);
                            if (data.UserIslocked == 1 || data.UserIslocked == '1') {
                                Ext.getCmp("UserIslocked").dom.checked = true;
                            }
                            if (data.UserBindip == 1 || data.UserBindip == '1') {
                                Ext.getCmp("UserBindip").dom.checked = true
                            };
                            Ext.getCmp("UserIpaddress").setValue(data.UserIpaddress);


                        },
                        failure: function(resp, opts) {

                        }
                    });
                }
                function saveUserData() {
                    var strUSER_ISLOCKED = '0';
                    //�û�����
                    if (Ext.get("UserIslocked").dom.checked) {
                        strUSER_ISLOCKED = "1";
                    }
                    //��ip
                    var strUSER_BINDIP = '0';
                    if (Ext.get("UserBindip").dom.checked) {
                        strUSER_BINDIP = "1"
                    }
                    var ids = getUserSelectNodes();
                    Ext.Msg.wait("���ڱ��桭��");
                    Ext.Ajax.request({
                        url: 'frmAdmOrgList.aspx?method=saveUserByOrgId',
                        method: 'POST',
                        params: {
                            UserIslocked: strUSER_ISLOCKED,
                            UserBindip: strUSER_BINDIP,
                            //UserId: Ext.getCmp('UserId').getValue(),
                            UserName: Ext.getCmp('UserName').getValue(),
                            UserRealname: Ext.getCmp('UserRealname').getValue(),
                            UserPassword: Ext.getCmp('UserPassword').getValue(),
                            UserIpaddress: Ext.getCmp('UserIpaddress').getValue(),
                            UserRoles: ids,
                            OrgId: tree.selModel.selNode.id
                        },
                        success: function(resp, opts) {
                            Ext.Msg.hide();
                            if (checkExtMessage(resp)) {
                                uploadUserWindow.hide();
                            }

                        }
         , failure: function(resp, opts) {
             Ext.Msg.hide();
             Ext.Msg.alert("��ʾ", "����ʧ��");
         }
                    });
                }


            })
</script>
</head>
<body>
    <form id="form1" runat="server">
    <div id='toolbar'></div>
    <div id='divForm'></div>
    <div id='orgGrid'></div>
    </form>
</body>
</html>
