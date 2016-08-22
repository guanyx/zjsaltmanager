<%@ Page Language="C#" AutoEventWireup="true" CodeFile="userManager.aspx.cs" Inherits="sysadmin_userManager" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
    <title>测试页面</title>
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
//                text: "新增",
//                icon: "../../Theme/1/images/extjs/customer/add16.gif",
//                handler: function() {
//                    //add                   
//                    saveType = "addUser";
//                    tree.dataUrl = 'userManager.aspx?method=getRoleByUser&userid=0';
//                    openAddUserWin(); //点击后，弹出添加信息窗口
//                }
//            }, '-', 
            {
                text: "编辑",
                icon: "../../Theme/1/images/extjs/customer/edit16.gif",
                handler: function() {
                    saveType = "saveUser";
                    modifyUserWin(); //点击后弹出原有信息

                }
            }, '-', {
                text: "删除",
                icon: "../../Theme/1/images/extjs/customer/delete16.gif",
                handler: function() {
                    deleteUser();
                }
}]
            });

            /*------实现toolbar的按钮函数 start---------------*/
            /*  新增窗口  */
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
            /*  修改窗口  */
            function modifyUserWin() {
                var sm = Ext.getCmp('userdatagrid').getSelectionModel();
                var selectData = sm.getSelected();
                if (selectData == null) {
                    Ext.Msg.alert("提示", "请选中一行！");
                }
                else {
                    Ext.Ajax.request({
                        url: 'userManager.aspx?method=getModifyUser',
                        params: {
                            UserId: selectData.data.UserId//传入用户seqId
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
                            Ext.Msg.alert("提示", "获取用户信息失败");
                        }
                    });
                }
            }
            /*  删除操作  */
            function deleteUser() {
                var sm = Ext.getCmp('userdatagrid').getSelectionModel();
                var selectData = sm.getSelected();

                if (selectData == null || selectData.length == 0 || selectData.length > 1) {
                    Ext.Msg.alert("提示", "请选中一行！");
                }
                else {
                
                     //删除前再次提醒是否真的要删除
                     Ext.Msg.confirm("提示信息", "是否真的要删除选择的信息吗？", function callBack(id) {
                    //判断是否删除数据
                    if (id == "yes") {
                            Ext.Ajax.request({
                                url: 'userManager.aspx?method=deleteUser',
                                params: {
                                    USER_ID: selectData.data.UserId//传入用户seqId
                                },
                                success: function(resp, opts) {
                                    //var data=Ext.util.JSON.decode(resp.responseText);
                                    if(checkExtMessage(resp))
                                    {
                                        userListStore.reload();
                                    }
                                },
                                failure: function(resp, opts) {
                                    Ext.Msg.alert("提示", "删除失败！");
                                }
                            });
                         }
                     });
                }
            }
            /*------实现toolbar的按钮函数 end---------------*/

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
			              //数据加载预处理,可以做一些合并、格式处理等操作
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
                loadMask: { msg: '正在加载数据，请稍侯……' },
                sm: sm,
                cm: new Ext.grid.ColumnModel([
                        sm,
                        new Ext.grid.RowNumberer(), //自动行号

			      {header: "用户编号", width: 5, dataIndex: 'UserId', hidden: true },
			      { header: "用户名称", width: 60, sortable: true, dataIndex: 'UserName' },
			      { header: "真实姓名", width: 30, dataIndex: 'UserRealname' },
			      { header: "是否锁定", width: 30, dataIndex: 'UserIslocked',renderer:function(v){if(v)return '是';else return '否';} }, //在c#中翻译
			      {header: "是否绑定IP", width: 30, dataIndex: 'UserBindip',renderer:function(v){if(v)return '是';else return '否';}  }, //在c#中翻译
			      {header: "IP地址", width: 25, dataIndex: 'UserIpaddress' },
			      {header: "角色信息", width: 25, dataIndex: 'RoleName' },
			      { header: "创建时间", width: 60, dataIndex: 'CreateDate',renderer: Ext.util.Format.dateRenderer('Y年m月d日')}//renderer: Ext.util.Format.dateRenderer('m/d/Y'),

			  ]),
                bbar: new Ext.PagingToolbar({
                    pageSize: 10,
                    store: userListStore,
                    displayMsg: '显示第{0}条到{1}条记录,共{2}条',
                    emptyMsy: '没有记录',
                    displayInfo: true
                }),
                viewConfig: {
                    columnsText: '显示的列',
                    scrollOffset: 20,
                    sortAscText: '升序',
                    sortDescText: '降序',
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
                fieldLabel: '用户名称',
                name: 'UserNameField',
                id: 'search',
                anchor: '90%'

            });


            var USER_REALNAMEPanel = new Ext.form.TextField({
                style: 'margin-left:0px',
                cls: 'key',
                xtype: 'textfield',
                fieldLabel: '真实姓名',
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
//                    layout: 'column',   //定义该元素为布局为列布局方式
//                    border: false,
//                    items: [{
//                        columnWidth: .4,  //该列占用的宽度，标识为20％
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
//                            text: '查询',
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
            fieldLabel: '用户标识',
            anchor: '90%',
            id: 'UserId'}]
        }
        , {
            layout: 'form',
            border: false,
            columnWidth: 0.5,
            items: [{
                xtype: 'textfield',
                fieldLabel: '用户名',
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
            fieldLabel: '真实姓名',
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
                fieldLabel: '密码',
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
            fieldLabel: '是否锁定',
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
                fieldLabel: '是否绑定IP',
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
            fieldLabel: 'IP地址',
            anchor: '70%',
            id: 'UserIpaddress'}]
}]
}]
                        });

                        /*生成角色选择的Tree树信息******/
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
                            text: '角色信息',
                            draggable: false,
                            id: 'source'
                        });
                        tree.setRootNode(root);


                        //获取选择的节点信息
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

                        //tree刷新
                        function treeReLoad(userID) {


                        }
                        /*****/

                        if (typeof (uploadUserWindow) == "undefined") {//解决创建2个windows问题
                            uploadUserWindow = new Ext.Window({
                                id: 'userformwindow',
                                title: "新增用户"
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
                                                             text: "保存"
		                                                    , handler: function() {
		                                                        saveUserData();

		                                                    }
			                                                    , scope: this
                                                         },
	                                                    {
	                                                        text: "取消"
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
                            //用户锁定
                            if (Ext.get("UserIslocked").dom.checked) {
                                strUSER_ISLOCKED = true;
                            }
                            //绑定ip
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
             Ext.Msg.alert("提示", "保存失败");
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