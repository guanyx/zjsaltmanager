<%@ Page Language="C#" AutoEventWireup="true" CodeFile="userManager.aspx.cs" Inherits="sysadmin_userManager" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
    <title>����ҳ��</title>
    <meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
    <link rel="stylesheet" type="text/css" href="../../ext3/resources/css/ext-all.css" />
	<script type="text/javascript" src="../../ext3/adapter/ext/ext-base.js"></script>	
	<script type="text/javascript" src="../../ext3/ext-all.js"></script>
	<script type="text/javascript" src="../../js/operateResp.js"></script>
	<script type="text/javascript" src="../../js/FilterControl.js"></script>
</head>

<script type="text/javascript">
    var saveType = "";
    var selectedUserId = "";
    function getCmbStore(columnName) {
       
        return null;
    }
    Ext.BLANK_IMAGE_URL = "../../ext3/resources/images/default/s.gif"
    Ext.onReady(function() {
        var Toolbar = new Ext.Toolbar({
            renderTo: "usertoolbar",
            items: [
//            {
//                text: "����",
//                icon: "../../Theme/1/images/extjs/customer/add16.gif",
//                handler: function() {
//                    //add                   
//                    saveType = "addUser";
//                    tree.dataUrl = 'userManager.aspx?method=getRoleByUser&userid=0';
//                    openAddUserWin(); //����󣬵��������Ϣ����
//                }
//            }, '-', 
            {
                text: "�༭",
                icon: "../../Theme/1/images/extjs/customer/edit16.gif",
                handler: function() {
                    saveType = "saveUser";
                    modifyUserWin(); //����󵯳�ԭ����Ϣ

                }
            }, '-', {
                text: "ɾ��",
                icon: "../../Theme/1/images/extjs/customer/delete16.gif",
                handler: function() {
                    deleteUser();
                }
}]
            });

            /*------ʵ��toolbar�İ�ť���� start---------------*/
            /*  ��������  */
            function openAddUserWin() {
                Ext.getCmp("UserId").setValue("0");
                Ext.getCmp("UserName").setValue("");
                Ext.getCmp("UserRealname").setValue("");
                Ext.getCmp("UserIslocked").checked = false;
                Ext.getCmp("UserBindip").checked = false;
                Ext.getCmp("UserIpaddress").setValue("");
                selectedUserId = "0";
                tree.root.reload();
                uploadUserWindow.show();
            }
            /*  �޸Ĵ���  */
            function modifyUserWin() {
                var sm = Ext.getCmp('userdatagrid').getSelectionModel();
                var selectData = sm.getSelected();
                if (selectData == null) {
                    Ext.Msg.alert("��ʾ", "��ѡ��һ�У�");
                }
                else {
                    Ext.Ajax.request({
                        url: 'userManager.aspx?method=getModifyUser',
                        params: {
                            UserId: selectData.data.UserId//�����û�seqId
                        },
                        success: function(resp, opts) {
                            var data = Ext.util.JSON.decode(resp.responseText);
                            selectedUserId = data.UserId;
                            tree.root.reload();
                            uploadUserWindow.show();
                            Ext.getCmp("UserId").setValue(data.UserId);
                            Ext.getCmp("UserName").setValue(data.UserName);
                            Ext.getCmp("UserRealname").setValue(data.UserRealname);
                            if (data.UserIslocked == true) {
                                Ext.getCmp("UserIslocked").el.dom.checked = true;
                            };
                            if (data.UserBindip == true) {
                                Ext.getCmp("UserBindip").el.dom.checked = true;
                            };
                            Ext.getCmp("UserIpaddress").setValue(data.UserIpaddress);

                        },
                        failure: function(resp, opts) {
                            Ext.Msg.alert("��ʾ", "��ȡ�û���Ϣʧ��");
                        }
                    });
                }
            }
            /*  ɾ������  */
            function deleteUser() {
                var sm = Ext.getCmp('userdatagrid').getSelectionModel();
                var selectData = sm.getSelected();

                if (selectData == null || selectData.length == 0 || selectData.length > 1) {
                    Ext.Msg.alert("��ʾ", "��ѡ��һ�У�");
                }
                else {
                
                     //ɾ��ǰ�ٴ������Ƿ����Ҫɾ��
                     Ext.Msg.confirm("��ʾ��Ϣ", "�Ƿ����Ҫɾ��ѡ�����Ϣ��", function callBack(id) {
                    //�ж��Ƿ�ɾ������
                    if (id == "yes") {
                            Ext.Ajax.request({
                                url: 'userManager.aspx?method=deleteUser',
                                params: {
                                    USER_ID: selectData.data.UserId//�����û�seqId
                                },
                                success: function(resp, opts) {
                                    //var data=Ext.util.JSON.decode(resp.responseText);
                                    if(checkExtMessage(resp))
                                    {
                                        userListStore.reload();
                                    }
                                },
                                failure: function(resp, opts) {
                                    Ext.Msg.alert("��ʾ", "ɾ��ʧ�ܣ�");
                                }
                            });
                         }
                     });
                }
            }
            /*------ʵ��toolbar�İ�ť���� end---------------*/

            var userListStore = new Ext.data.Store
			({
			    url: 'userManager.aspx?method=getUser',
			    reader: new Ext.data.JsonReader({
			        totalProperty: 'totalProperty',
			        root: 'root'
			    }, [
			    { name: "UserId" },
			    { name: "UserName" },
			    { name: "UserRealname" },
			    { name: "UserIslocked",type:'bool' },
			    { name: "UserBindip", type: 'bool' },
			    { name: "UserIpaddress" },
			    { name: "CreateDate" ,type:'date'},
			    { name: "RoleName" }
			    ])
			   ,
			    listeners:
			      {
			          scope: this,
			          load: function() {
			              //���ݼ���Ԥ����,������һЩ�ϲ�����ʽ����Ȳ���
			          }
			      }
			});
            var sm = new Ext.grid.CheckboxSelectionModel(
        {
            singleSelect: true
        }
     );
            var userGrid = new Ext.grid.GridPanel({
                el: 'userdatagrid',
                width: '100%',
                height: '100%',
                autoWidth: true,
                autoHeight: true,
                autoScroll: true,
                layout: 'fit',
                id: 'userdatagrid',
                store: userListStore,
                loadMask: { msg: '���ڼ������ݣ����Ժ��' },
                sm: sm,
                cm: new Ext.grid.ColumnModel([
                        sm,
                        new Ext.grid.RowNumberer(), //�Զ��к�

			      {header: "�û����", width: 5, dataIndex: 'UserId', hidden: true },
			      { header: "�û�����", width: 60, sortable: true, dataIndex: 'UserName' },
			      { header: "��ʵ����", width: 30, dataIndex: 'UserRealname' },
			      { header: "�Ƿ�����", width: 30, dataIndex: 'UserIslocked',renderer:function(v){if(v)return '��';else return '��';} }, //��c#�з���
			      {header: "�Ƿ��IP", width: 30, dataIndex: 'UserBindip',renderer:function(v){if(v)return '��';else return '��';}  }, //��c#�з���
			      {header: "IP��ַ", width: 25, dataIndex: 'UserIpaddress' },
			      {header: "��ɫ��Ϣ", width: 25, dataIndex: 'RoleName' },
			      { header: "����ʱ��", width: 60, dataIndex: 'CreateDate',renderer: Ext.util.Format.dateRenderer('Y��m��d��')}//renderer: Ext.util.Format.dateRenderer('m/d/Y'),

			  ]),
                bbar: new Ext.PagingToolbar({
                    pageSize: 10,
                    store: userListStore,
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

            createSearch(userGrid, userListStore, "searchForm");
            searchForm.el = "searchForm";
            searchForm.render();

            var USER_NAMEPanel = new Ext.form.TextField({
                style: 'margin-left:0px',
                cls: 'key',
                xtype: 'textfield',
                fieldLabel: '�û�����',
                name: 'UserNameField',
                id: 'search',
                anchor: '90%'

            });


            var USER_REALNAMEPanel = new Ext.form.TextField({
                style: 'margin-left:0px',
                cls: 'key',
                xtype: 'textfield',
                fieldLabel: '��ʵ����',
                name: 'User_RealnameField',
                anchor: '90%'
            });

//            var serchform = new Ext.FormPanel({
//                renderTo: 'userserchform',
//                labelAlign: 'left',
//                layout: 'fit',
//                buttonAlign: 'right',
//                bodyStyle: 'padding:5px',
//                frame: true,
//                labelWidth: 55,
//                items: [{
//                    layout: 'column',   //�����Ԫ��Ϊ����Ϊ�в��ַ�ʽ
//                    border: false,
//                    items: [{
//                        columnWidth: .4,  //����ռ�õĿ�ȣ���ʶΪ20��
//                        layout: 'form',
//                        border: false,
//                        items: [
//                            USER_NAMEPanel
//                        ]
//                    }, {
//                        columnWidth: .4,
//                        layout: 'form',
//                        border: false,
//                        items: [
//                            USER_REALNAMEPanel
//                            ]
//                    }, {
//                        columnWidth: .2,
//                        layout: 'form',
//                        border: false,
//                        items: [{ cls: 'key',
//                            xtype: 'button',
//                            text: '��ѯ',
//                            anchor: '50%',
//                            handler: function() {

//                                var USER_NAME = USER_NAMEPanel.getValue();
//                                var USER_REALNAME = USER_REALNAMEPanel.getValue();

//                                userListStore.load({
//                                    params: {
//                                        start: 0,
//                                        limit: 10,
//                                        UserName: USER_NAME,
//                                        UserRealname: USER_REALNAME
//                                    }
//                                });
//                            }
//}]
//}]
//}]
//                        });

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
        columnWidth: 0.5,
        items: [{
            xtype: 'textfield',
            fieldLabel: '�û���ʶ',
            anchor: '90%',
            id: 'UserId'}]
        }
        , {
            layout: 'form',
            border: false,
            columnWidth: 0.5,
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

                        /*���ɽ�ɫѡ���Tree����Ϣ******/
                        var Tree = Ext.tree;

                        var tree = new Tree.TreePanel({
                            //el: 'tree-div',
                            useArrows: true,
                            region: "center",
                            autoScroll: true,
                            animate: true,
                            enableDD: true,
                            containerScroll: true,
                            //height:150,
                            
                            rootVisible: false,

                            loader: new Tree.TreeLoader({
                                dataUrl: 'userManager.aspx?method=getRoleByUser'
                            })
                        });
                        tree.getLoader().on("beforeload", function(treeLoader, node) {
                            treeLoader.baseParams.UserId = selectedUserId;
                        }, this);

                        tree.on('checkchange', function(node, checked) {
                            node.expand();
                            node.attributes.checked = checked;
                            node.eachChild(function(child) {
                                child.ui.toggleCheck(checked);
                                child.attributes.checked = checked;
                                child.fireEvent('checkchange', child, checked);
                            });
                        }, tree);


                        // set the root node
                        var root = new Tree.AsyncTreeNode({
                            text: '��ɫ��Ϣ',
                            draggable: false,
                            id: 'source'
                        });
                        tree.setRootNode(root);


                        //��ȡѡ��Ľڵ���Ϣ
                        function getSelectNodes() {
                            var selectNodes = tree.getChecked();
                            var ids = "";
                            if(selectNodes!=null)
                            {
                                for (var i = 0; i < selectNodes.length; i++) {
                                    if (ids.length > 0)
                                        ids += ",";
                                    ids += selectNodes[i].id;
                                }
                            }
                            return ids;
                        }

                        //treeˢ��
                        function treeReLoad(userID) {


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

	                                                   , items: [userForm, tree]
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
                            userForm.getForm().reset();
                        });

                        function saveUserData() {
                            var strUSER_ISLOCKED = false;
                            //�û�����
                            if (Ext.get("UserIslocked").dom.checked) {
                                strUSER_ISLOCKED = true;
                            }
                            //��ip
                            var strUSER_BINDIP = false;
                            if (Ext.get("UserBindip").dom.checked) {
                                strUSER_BINDIP = true
                            }
                            var ids = getSelectNodes();
                            Ext.Ajax.request({
                                url: 'userManager.aspx?method=' + saveType,
                                method: 'POST',
                                params: {
                                    UserIslocked: strUSER_ISLOCKED,
                                    UserBindip: strUSER_BINDIP,
                                    UserId: Ext.getCmp('UserId').getValue(),
                                    UserName: Ext.getCmp('UserName').getValue(),
                                    UserRealname: Ext.getCmp('UserRealname').getValue(),
                                    UserPassword: Ext.getCmp('UserPassword').getValue(),
                                    UserIpaddress: Ext.getCmp('UserIpaddress').getValue(),
                                    UserRoles: ids
                                },
                                success: function(resp, opts) {
                                   if(checkExtMessage(resp))
                                   {
                                        uploadUserWindow.hide();
                                        userListStore.reload();
                                   }

                                }
         , failure: function(resp, opts) {
             Ext.Msg.alert("��ʾ", "����ʧ��");
         }
                            });
                        }

                    })
</script>
<body>
<div id='usertoolbar'></div>
<div id="searchForm"></div>
<div id="userdatagrid"></div>

</body>
</html>