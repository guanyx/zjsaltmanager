<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmAdmRoleList.aspx.cs" Inherits="sysadmin_frmAdmRoleList" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>无标题页</title>
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
	            title: "角色资源配置"
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
	                                                        text: "关闭"
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
	        roleactions = ExtJsShowWin('角色功能信息', 'frmRoleAction.aspx?roleid=' + roleid, 'roleaction', 600, 450);
	    }
	    else {
	        document.getElementById("frameroleaction").src = "frmRoleAction.aspx?roleid=" + roleid;
	    }
	    roleactions.show();
	}
	Ext.onReady(function() {
	    var saveType = "";
	    /*------实现toolbar的函数 start---------------*/
	    var Toolbar = new Ext.Toolbar({
	        renderTo: "toolbar",
	        items: [{
	            text: "新增",
	            icon: imageUrl + "/images/extjs/customer/add16.gif",
	            handler: function() {
	                saveType = "add";
	                //新增窗体显示
	                openAddUserWin();
	            }
	        }, '-', {
	            text: "编辑",
	            icon: imageUrl + "/images/extjs/customer/edit16.gif",
	            handler: function() {
	                saveType = "editRole";
	                modifyRoleWin();
	            }
	        }, '-', {
	            text: "资源配置",
	            icon: imageUrl + "/images/extjs/customer/add16.gif",
	            handler: function() {
	                //资源配置
	                var sm = Ext.getCmp('userGrid').getSelectionModel();
	                var selectData = sm.getSelected();
	                if (selectData == null) {
	                    Ext.Msg.alert("提示", "请选中需要编辑的角色信息！");
	                    return;
	                }
	                modifyRoleRes(selectData.data.RoleId);
	            }
	        }, '-', {
	            text: "功能配置",
	            icon: imageUrl + "/images/extjs/customer/add16.gif",
	            handler: function() {
	                //资源配置
	                var sm = Ext.getCmp('userGrid').getSelectionModel();
	                var selectData = sm.getSelected();
	                if (selectData == null) {
	                    Ext.Msg.alert("提示", "请选中需要功能配置的角色信息！");
	                    return;
	                }
	                modifyRoleActions(selectData.data.RoleId);
	            }
	        }, '-', {
	            text: "删除",
	            icon: imageUrl + "/images/extjs/customer/delete16.gif",
	            handler: function() {
	                //删除角色
	                deleteRole();
	            }
}]
	        });

	        /*------结束toolbar的函数 end---------------*/

	        /*------实现toolbar的按钮函数 start---------------*/
	        /*  新增窗口  */
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


	        /*  修改窗口  */
	        function modifyRoleWin() {
	            var sm = Ext.getCmp('userGrid').getSelectionModel();
	            var selectData = sm.getSelected();
	            if (selectData == null) {
	                Ext.Msg.alert("提示", "请选中需要编辑的角色信息！");
	            }
	            else {
	                uploadUserWindow.show();
	                setFormValue(selectData);
	            }
	        }

	        /*删除角色信息*/
	        function deleteRole() {

	            var sm = Ext.getCmp('userGrid').getSelectionModel();
	            //获取选择的数据信息
	            var selectData = sm.getSelected();
	            //如果没有选择，就提示需要选择数据信息
	            if (selectData == null) {
	                Ext.Msg.alert("提示", "请选中需要删除的角色信息！");
	                return;
	            }
	            //删除前再次提醒是否真的要删除
	            Ext.Msg.confirm("提示信息", "是否真的要删除选择的角色信息吗？", function callBack(id) {
	                if (id == "yes") {
	                    //页面提交
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
	                            Ext.Msg.alert("提示", "数据删除失败");
	                        }
	                    });
	                }
	            });
	        }


	        /*------实现FormPanle的函数 start---------------*/
	        var rolediv = new Ext.form.FormPanel({
	            //url:'',
	            //renderTo:'divForm',
	            frame: true,
	            id: "rolediv",
	            //title:'角色信息',
	            items: [
		{
		    xtype: 'hidden',
		    fieldLabel: '标识',
		    columnWidth: 1,
		    anchor: '90%',
		    name: 'RoleId',
		    id: 'RoleId',
		    hide: true
		}
, {
    xtype: 'textfield',
    fieldLabel: '角色名称',
    columnWidth: 1,
    anchor: '90%',
    name: 'RoleName',
    id: 'RoleName'
}
, {
    xtype: 'hidden',
    fieldLabel: '角色级别',
    columnWidth: 1,
    anchor: '90%',
    name: 'RoleLeave',
    id: 'RoleLeave',
    hide: true
},
 {
     xtype: 'combo',
     fieldLabel: '角色类型',
     columnWidth: 1,
     anchor: '90%',
     name: 'RoleType',
     id: 'RoleType',
     store: RoleTypeStore,
     displayField: 'DicsName',
     valueField: 'OrderIndex',
     typeAhead: true,
     mode: 'local',
     emptyText: '请选择角色类型信息',
     triggerAction: 'all'

 }
, {
    xtype: 'textarea',
    fieldLabel: '角色备注',
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
	        /*------FormPanle的函数结束 End---------------*/

	        /*------开始获取数据的函数 start---------------*/
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


	        /*------获取数据的函数 结束 End---------------*/

	        /*------开始DataGrid的函数 start---------------*/

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
	            loadMask: { msg: '正在加载数据，请稍侯……' },
	            sm: sm,
	            cm: new Ext.grid.ColumnModel([
		sm,
		new Ext.grid.RowNumberer(), //自动行号
		{
		    header: '角色名称',
		    dataIndex: 'RoleName',
		    id: 'RoleName',
		    width:150
        },	
		{
		    header: '角色备注',
		    dataIndex: 'RoleComment',
		    id: 'RoleComment',
		    width:240
		},
		{
		    header: '角色类型',
		    dataIndex: 'RoleType',
		    id: 'RoleType',
		    width:100,
		    renderer: cmbText
        },	
		{
		    header: '创建单位',
		    dataIndex: 'OrgShortName',
		    id: 'OrgShortName',
		    width:240
		}]),
        bbar: new Ext.PagingToolbar({
            pageSize: 100,
            store: useruserGridData,
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
    /*------DataGrid的函数结束 End---------------*/
    useruserGridData.load({
        params: {
            start: 0,
            limit: 100
        }
    });



	        if (typeof (uploadUserWindow) == "undefined") {//解决创建2个windows问题
	            uploadUserWindow = new Ext.Window({
	                id: 'userformwindow',
	                title: "新增角色"
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
	            //userForm.getForm().reset();
	        });


	        /* 保存函数 */
	        function saveUserData() {
	            getFormValue();
	        }

	        /*------开始界面数据的函数 Start---------------*/
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
	                    Ext.Msg.alert("提示", "获取用户信息失败");
	                }
	            });
	        }
	        /*------结束设置界面数据的函数 End---------------*/

	        /*------开始获取界面数据的函数 start---------------*/
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
	                    Ext.Msg.alert("提示", "保存失败");
	                }
	            });
	        }
	        /*------结束获取界面数据的函数 End---------------*/
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
