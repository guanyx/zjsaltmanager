/*创建用户信息*/
var isCustomer=true;
var html="";
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
    items: [ {
            layout: 'form',
            border: false,
            columnWidth: 1,
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
var selectedUserId=0;
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
                                dataUrl: '../../ba/sysadmin/userManager.aspx?action=customer&method=getRoleByUser'
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
                            for (var i = 0; i < selectNodes.length; i++) {
                                if (ids.length > 0)
                                    ids += ",";
                                ids += selectNodes[i].id;
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
		                                                        //saveUserData();
		                                                       
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
 var customer = 0;                   
                        /*  修改窗口  */
            function modifyUserWin(customerID,shortName) {
                        uploadUserWindow.show();
                    customer = customerID;
                    Ext.Ajax.request({
                        url: 'customerManage.aspx?method=getuserbycustomerId',
                        params: {
                            customerid: customerID//传入用户seqId
                        },
                        success: function(resp, opts) {
                            //还没有创建用户
                            if(resp.responseText=="")
                            {
                                Ext.getCmp("UserRealname").setValue(shortName);
                                selectedUserId = 0;
                                tree.root.reload();
                                return;
                            }
                            var data = Ext.util.JSON.decode(resp.responseText);
                            selectedUserId = data.UserId;
                            tree.root.reload();
                            
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
                            //用户锁定
                            if (Ext.get("UserIslocked").dom.checked) {
                                strUSER_ISLOCKED = "1";
                            }
                            //绑定ip
                            var strUSER_BINDIP = '0';
                            if (Ext.get("UserBindip").dom.checked) {
                                strUSER_BINDIP = "1"
                            }
                            var ids = getSelectNodes();
                        Ext.Msg.wait("正在保存……");
                            Ext.Ajax.request({
                                url: 'customerManage.aspx?method=saveuserbycustomer',
                                method: 'POST',
                                params: {
                                    UserIslocked: strUSER_ISLOCKED,
                                    UserBindip: strUSER_BINDIP,
                                    //UserId: Ext.getCmp('UserId').getValue(),
                                    UserName: Ext.getCmp('UserName').getValue(),
                                    UserRealname: Ext.getCmp('UserRealname').getValue(),
                                    //UserPassword: Ext.getCmp('UserPassword').getValue(),
                                    UserIpaddress: Ext.getCmp('UserIpaddress').getValue(),
                                    UserRoles: ids,
                                    EmpId:customer,
                                    UserIscustomer:isCustomer
                                },
                                success: function(resp, opts) {
                                    Ext.Msg.hide();
                                    if(checkExtMessage(resp))
                                    {
                                        uploadUserWindow.hide();
                                    }

                                }
         , failure: function(resp, opts) {
            Ext.Msg.hide();
             Ext.Msg.alert("提示", "保存失败");
         }
                            });
                        }