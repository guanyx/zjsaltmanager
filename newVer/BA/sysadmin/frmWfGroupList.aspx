<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmWfGroupList.aspx.cs" Inherits="BA_sysadmin_frmWfGroupList" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <link rel="stylesheet" type="text/css" href="../../ext3/resources/css/ext-all.css" />
    <script type="text/javascript" src="../../ext3/adapter/ext/ext-base.js"></script>
    <script type="text/javascript" src="../../ext3/ext-all.js"></script>
    <script type="text/javascript" src="../../js/operateResp.js"></script>
    <script type="text/javascript" src="../../js/ExtJsHelper.js"></script>
</head>
<script type="text/javascript">
    Ext.onReady(function() {
        var saveType = 'add';
        var imageUrl = "../../Theme/1/";
        /*------实现toolbar的函数 start---------------*/
        var Toolbar = new Ext.Toolbar({
            renderTo: "toolbar",
            items: [{
                text: "新增",
                icon: imageUrl + "images/extjs/customer/add16.gif",
                handler: function() {
                    saveType = "addgroup";
                    openAddGroupWin();
                }
            }, '-', {
                text: "编辑",
                icon: imageUrl + "images/extjs/customer/edit16.gif",
                handler: function() {
                    saveType = "editgroup";
                    modifyGroupWin();
                }
            }, '-', {
                text: "删除",
                icon: imageUrl + "images/extjs/customer/delete16.gif",
                handler: function() {
                    deleteGroup();
                }
            }, '-', {
                text: "设置工作流",
                icon: imageUrl + "images/extjs/customer/edit16.gif",
                handler: function() {
                    setWorkFlowInformation();
                }
}]
            });

            /*------结束toolbar的函数 end---------------*/

            var uploadWorkFlowWindow = null;
            //设置步骤信息
            function setWorkFlowInformation() {
                var sm = groupGrid.getSelectionModel();
                //获取选择的数据信息
                var selectData = sm.getSelected();
                if (selectData == null) {
                    Ext.Msg.alert("提示", "请选中需要设置步骤的工作流信息！");
                    return;
                }

                if (uploadWorkFlowWindow == null) {
                    uploadWorkFlowWindow = ExtJsShowWin('设置工作流信息', '#', 'workflow', 800, 600)
                }
                uploadWorkFlowWindow.show();
                if (document.getElementById("iframeworkflow").src.indexOf("frmWorkFlowList.aspx") == -1) {
                    document.getElementById("iframeworkflow").src = "frmWorkFlowList.aspx?groupId=" + selectData.data.GroupId;
                }
                else {
                    document.getElementById("iframeworkflow").contentWindow.groupId = selectData.data.GroupId;
                    document.getElementById("iframeworkflow").contentWindow.loadData();
                }

            }
            /*------开始ToolBar事件函数 start---------------*//*-----新增Group实体类窗体函数----*/
            function openAddGroupWin() {
                Ext.getCmp('GroupId').setValue("");
                Ext.getCmp('GroupName').setValue("");
                Ext.getCmp('GroupMemo').setValue("");

                uploadGroupWindow.show();
            }
            /*-----编辑Group实体类窗体函数----*/
            function modifyGroupWin() {
                var sm = groupGrid.getSelectionModel();
                //获取选择的数据信息
                var selectData = sm.getSelected();
                if (selectData == null) {
                    Ext.Msg.alert("提示", "请选中需要编辑的信息！");
                    return;
                }
                uploadGroupWindow.show();
                setFormValue(selectData);
            }
            /*-----删除Group实体函数----*/
            /*删除信息*/
            function deleteGroup() {
                var sm = groupGrid.getSelectionModel();
                //获取选择的数据信息
                var selectData = sm.getSelected();
                //如果没有选择，就提示需要选择数据信息
                if (selectData == null) {
                    Ext.Msg.alert("提示", "请选中需要删除的信息！");
                    return;
                }
                //删除前再次提醒是否真的要删除
                Ext.Msg.confirm("提示信息", "是否真的要删除选择的工作流组信息吗？", function callBack(id) {
                    //判断是否删除数据
                    if (id == "yes") {
                        //页面提交
                        Ext.Ajax.request({
                            url: 'frmWfGroupList.aspx?method=delgroup',
                            method: 'POST',
                            params: {
                                GroupId: selectData.data.GroupId
                            },
                            success: function(resp, opts) {
                                if (checkExtMessage(resp)) {
                                    groupgridData.reload();
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
            var groupForm = new Ext.form.FormPanel({
                frame: true,
                items: [
		{
		    xtype: 'textfield',
		    columnWidth: 1,
		    anchor: '90%',
		    name: 'GroupId',
		    id: 'GroupId',
		    hidden: true
		}
, {
    xtype: 'textfield',
    fieldLabel: '工作流组名称',
    columnWidth: 1,
    anchor: '90%',
    name: 'GroupName',
    id: 'GroupName'
}
, {
    xtype: 'textarea',
    fieldLabel: '注释',
    columnWidth: 1,
    anchor: '90%',
    name: 'GroupMemo',
    id: 'GroupMemo'
}
, {
    xtype: 'textfield',
    columnWidth: 1,
    anchor: '90%',
    name: 'CreateDate',
    id: 'CreateDate',
    hidden: true
}
, {
    xtype: 'textfield',
    columnWidth: 1,
    anchor: '90%',
    name: 'OperId',
    id: 'OperId',
    hidden: true
}
, {
    xtype: 'textfield',
    columnWidth: 1,
    anchor: '90%',
    name: 'OrgId',
    id: 'OrgId',
    hidden: true
}
]
            });
            /*------FormPanle的函数结束 End---------------*/

            /*------开始界面数据的窗体 Start---------------*/
            if (typeof (uploadGroupWindow) == "undefined") {//解决创建2个windows问题
                uploadGroupWindow = new Ext.Window({
                    id: 'Groupformwindow',
                    title: '工作流组信息'
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
		, items: groupForm
		, buttons: [{
		    text: "保存"
			, handler: function() {
			    getFormValue();
			}
			, scope: this
		},
		{
		    text: "取消"
			, handler: function() {
			    uploadGroupWindow.hide();
			}
			, scope: this
}]
                });
            }
            uploadGroupWindow.addListener("hide", function() {
            });

            /*------开始获取界面数据的函数 start---------------*/
            function getFormValue() {

                Ext.Ajax.request({
                    url: 'frmWfGroupList.aspx?method=' + saveType,
                    method: 'POST',
                    params: {
                        GroupId: Ext.getCmp('GroupId').getValue(),
                        GroupName: Ext.getCmp('GroupName').getValue(),
                        GroupMemo: Ext.getCmp('GroupMemo').getValue()
                    },
                    success: function(resp, opts) {
                        if (checkExtMessage(resp)) {
                            groupgridData.reload();
                        }
                    },
                    failure: function(resp, opts) {
                        Ext.Msg.alert("提示", "保存失败");
                    }
                });
            }
            /*------结束获取界面数据的函数 End---------------*/

            /*------开始界面数据的函数 Start---------------*/
            function setFormValue(selectData) {
                Ext.Ajax.request({
                    url: 'frmWfGroupList.aspx?method=getgroup',
                    params: {
                        GroupId: selectData.data.GroupId
                    },
                    success: function(resp, opts) {
                        var data = Ext.util.JSON.decode(resp.responseText);
                        Ext.getCmp("GroupId").setValue(data.GroupId);
                        Ext.getCmp("GroupName").setValue(data.GroupName);
                        Ext.getCmp("GroupMemo").setValue(data.GroupMemo);
                    },
                    failure: function(resp, opts) {
                        Ext.Msg.alert("提示", "获取工作流组信息失败");
                    }
                });
            }
            /*------结束设置界面数据的函数 End---------------*/

            /*------开始获取数据的函数 start---------------*/
            var groupgridData = new Ext.data.Store
({
    url: 'frmWfGroupList.aspx?method=getgrouplist',
    reader: new Ext.data.JsonReader({
        totalProperty: 'totalProperty',
        root: 'root'
    }, [
	{
	    name: 'GroupId'
	},
	{
	    name: 'GroupName'
	},
	{
	    name: 'GroupMemo'
	},
	{
	    name: 'CreateDate'
	},
	{
	    name: 'OperId'
	},
	{
	    name: 'OrgId'
}])
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
            var groupGrid = new Ext.grid.GridPanel({
                el: 'groupListGridDiv',
                width: '100%',
                height: '100%',
                autoWidth: true,
                autoHeight: true,
                autoScroll: true,
                layout: 'fit',
                id: 'groupListGrid',
                store: groupgridData,
                loadMask: { msg: '正在加载数据，请稍侯……' },
                sm: sm,
                cm: new Ext.grid.ColumnModel([
		sm,
		new Ext.grid.RowNumberer(), //自动行号
		{
		header: '工作流组标识',
		dataIndex: 'GroupId',
		id: 'GroupId',
		hidden: true
},
		{
		    header: '工作流组名称',
		    dataIndex: 'GroupName',
		    id: 'GroupName'
		},
		{
		    header: '注释',
		    dataIndex: 'GroupMemo',
		    id: 'GroupMemo'
}]),
                bbar: new Ext.PagingToolbar({
                    pageSize: 10,
                    store: groupgridData,
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
            groupGrid.render();
            /*------DataGrid的函数结束 End---------------*/

            groupgridData.load({ params: { limit: 10, start: 0} });

        })
</script>
<body>
<div id='toolbar'></div>
<div id='divForm'></div>
<div id='groupListGridDiv'></div>

</body>
</html>

