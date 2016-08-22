<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmResourceAction.aspx.cs" Inherits="BA_sysadmin_frmResourceAction" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>无标题页</title>
    <link rel="stylesheet" type="text/css" href="../../ext3/resources/css/ext-all.css" />
    <script type="text/javascript" src="../../ext3/adapter/ext/ext-base.js"></script>
    <script type="text/javascript" src="../../ext3/ext-all.js"></script>
    <script type="text/javascript" src="../../js/operateResp.js"></script>
<%=getComboBoxSource() %>
<script type="text/javascript">
var imageUrl = "../../Theme/1/";
var formTitle = "资源信息";
var saveType = "";

var actionData;
var resourceID="";
function loadData()
{
    if(resourceID>0)
    {
        actionData.baseParams.resourceid = resourceID;
            actionData.load({
                params: {
                    start: 0,
                    limit: 10
                }
            });
        }
}

function getParamerValue(name) {
        name = name.replace(/[\[]/, "\\\[").replace(/[\]]/, "\\\]");
        var regexS = "[\\?&]" + name + "=([^&#]*)";
        var regex = new RegExp(regexS);
        var results = regex.exec(window.location.href);
        if (results == null)
            return "";
        else
            return results[1];
    }
Ext.onReady(function() {
    /*------实现toolbar的函数 start---------------*/
    var Toolbar = new Ext.Toolbar({
        renderTo: "toolbar",
        items: [{
            text: "新增",
            icon: imageUrl + "/images/extjs/customer/add16.gif",
            handler: function() {
                saveType = "addaction";
                openAddResourceactionWin();
            }
        }, '-', {
            text: "编辑",
            icon: imageUrl + "/images/extjs/customer/edit16.gif",
            handler: function() {
                saveType = "editaction";
                modifyResourceactionWin();
            }
        }, '-', {
            text: "删除",
            icon: imageUrl + "/images/extjs/customer/delete16.gif",
            handler: function() { }
}]
        });

        /*------结束toolbar的函数 end---------------*/


        /*------开始ToolBar事件函数 start---------------*/
        /*-----新增Resourceaction实体类窗体函数----*/
        function openAddResourceactionWin() {
            if (resourceID == "") {
                alert("没有选择对应的资源信息，无法新增功能信息");
                return;
            }
            Ext.getCmp('ActionId').setValue("-1"),
	Ext.getCmp('ResourceId').setValue(resourceID),
	Ext.getCmp('ActionCode').setValue(""),
	Ext.getCmp('ActionName').setValue(""),
	Ext.getCmp('ActionDes').setValue(""),
	uploadResourceactionWindow.show();
        }
        /*-----编辑Resourceaction实体类窗体函数----*/
        function modifyResourceactionWin() {
            var sm = Ext.getCmp('actionGrid').getSelectionModel();
            //获取选择的数据信息
            var selectData = sm.getSelected();
            if (selectData == null) {
                Ext.Msg.alert("提示", "请选中需要编辑的信息！");
                return;
            }
            uploadResourceactionWindow.show();
            setFormValue(selectData);
        }
        /*-----删除Resourceaction实体函数----*/
        /*删除信息*/
        function deleteResourceaction() {
            var sm = Ext.getCmp('actionGrid').getSelectionModel();
            //获取选择的数据信息
            var selectData = sm.getSelected();
            //如果没有选择，就提示需要选择数据信息
            if (selectData == null) {
                Ext.Msg.alert("提示", "请选中需要删除的信息！");
                return;
            }
            //删除前再次提醒是否真的要删除
            Ext.Msg.confirm("提示信息", "是否真的要删除选择的信息吗？", function callBack(id) {
                //判断是否删除数据
                if (id == "yes") {
                    //页面提交
                    Ext.Ajax.request({
                        url: 'frmAdmRoleList.aspx?method=deleteResourceaction',
                        method: 'POST',
                        params: {
                            ActionId: selectData.data.ActionId
                        },
                        success: function(resp, opts) {
                            Ext.Msg.alert("提示", "数据删除成功");
                        },
                        failure: function(resp, opts) {
                            Ext.Msg.alert("提示", "数据删除失败");
                        }
                    });
                }
            });
        }

        /*------实现FormPanle的函数 start---------------*/
        var actionForm = new Ext.form.FormPanel({
            frame: true,
            items: [
		{
		    xtype: 'hidden',
		    fieldLabel: '功能标识',
		    name: 'ActionId',
		    id: 'ActionId',
		    hide: true
		}
, {
    xtype: 'hidden',
    fieldLabel: '资源标识',
    columnWidth: 1,
    anchor: '90%',
    name: 'ResourceId',
    id: 'ResourceId',
    hide: true
}
, {
    xtype: 'textfield',
    fieldLabel: '功能编码',
    columnWidth: 1,
    anchor: '90%',
    name: 'ActionCode',
    id: 'ActionCode'
}
, {
    xtype: 'textfield',
    fieldLabel: '功能名称',
    columnWidth: 1,
    anchor: '90%',
    name: 'ActionName',
    id: 'ActionName'
}, {
    xtype: 'combo',
    fieldLabel: '功能类型',
    columnWidth: 1,
    anchor: '90%',
    name: 'ActionType',
    id: 'ActionType',
    store: ActionTypeStore,
    displayField: 'DicsName',
    valueField: 'OrderIndex',
    typeAhead: true,
    mode: 'local',
    emptyText: '请选择功能类型信息',
    triggerAction: 'all'
}
, {
    xtype: 'textfield',
    fieldLabel: '功能描述',
    columnWidth: 1,
    anchor: '90%',
    name: 'ActionDes',
    id: 'ActionDes'
}
]
        });
        /*------FormPanle的函数结束 End---------------*/

        /*------开始界面数据的窗体 Start---------------*/
        if (typeof (uploadResourceactionWindow) == "undefined") {//解决创建2个windows问题
            uploadResourceactionWindow = new Ext.Window({
                id: 'Resourceactionformwindow',
                title: formTitle
		, iconCls: 'upload-win'
		, width: 300
		, height: 200
		, layout: 'fit'
		, plain: true
		, modal: true
		, x: 50
		, y: 50
		, constrain: true
		, resizable: false
		, closeAction: 'hide'
		, autoDestroy: true
		, items: actionForm
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
			    uploadResourceactionWindow.hide();
			}
			, scope: this
}]
            });
        }
        uploadResourceactionWindow.addListener("hide", function() {
        });

        /*------开始获取界面数据的函数 start---------------*/
        function getFormValue() {
            var actionID = Ext.getCmp('ActionId').getValue();
            if (actionID == "")
                actionID = "-1";
            Ext.Ajax.request({
                url: 'frmResourceAction.aspx?method=' + saveType,
                method: 'POST',
                params: {
                    ActionId: actionID,
                    ResourceId: Ext.getCmp('ResourceId').getValue(),
                    ActionCode: Ext.getCmp('ActionCode').getValue(),
                    ActionName: Ext.getCmp('ActionName').getValue(),
                    ActionDes: Ext.getCmp('ActionDes').getValue(),
                    ActionType: Ext.getCmp('ActionType').getValue()
                },
                success: function(resp, opts) {
                    if(checkExtMessage(resp))
                    {
                        uploadResourceactionWindow.hide();
                        actionData.reload();
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
                url: 'frmResourceAction.aspx?method=getaction',
                params: {
                    ActionId: selectData.data.ActionId
                },
                success: function(resp, opts) {
                    var data = Ext.util.JSON.decode(resp.responseText);
                    Ext.getCmp("ActionId").setValue(data.ActionId);
                    Ext.getCmp("ResourceId").setValue(data.ResourceId);
                    Ext.getCmp("ActionCode").setValue(data.ActionCode);
                    Ext.getCmp("ActionName").setValue(data.ActionName);
                    Ext.getCmp("ActionDes").setValue(data.ActionDes);
                    Ext.getCmp('ActionType').setValue(data.ActionType);
                },
                failure: function(resp, opts) {
                    Ext.Msg.alert("提示", "获取信息失败");
                }
            });
        }
        /*------结束设置界面数据的函数 End---------------*/

        /*------开始获取数据的函数 start---------------*/
        actionData = new Ext.data.Store
({
    url: 'frmResourceAction.aspx?method=getactionlist',
    reader: new Ext.data.JsonReader({
        totalProperty: 'totalProperty',
        root: 'root'
    }, [
	{
	    name: 'ActionId'
	},
	{
	    name: 'ResourceId'
	},
	{
	    name: 'ActionCode'
	},
	{
	    name: 'ActionName'
	},
	{
	    name: 'ActionDes'
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
        var actionGrid = new Ext.grid.GridPanel({
            el: 'actionGrid',
            width: '100%',
            height: '100%',
            autoWidth: true,
            autoHeight: true,
            autoScroll: true,
            layout: 'fit',
            id: 'actionGrid',
            store: actionData,
            loadMask: { msg: '正在加载数据，请稍侯……' },
            sm: sm,
            cm: new Ext.grid.ColumnModel([
		sm,
		new Ext.grid.RowNumberer(), //自动行号

		{
		header: '功能编码',
		dataIndex: 'ActionCode',
		id: 'ActionCode'
},
		{
		    header: '功能名称',
		    dataIndex: 'ActionName',
		    id: 'ActionName'
		},
		{
		    header: '功能描述',
		    dataIndex: 'ActionDes',
		    id: 'ActionDes'
}]),
            bbar: new Ext.PagingToolbar({
                pageSize: 10,
                store: actionData,
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
        actionGrid.render();
        /*------DataGrid的函数结束 End---------------*/

        resourceID = getParamerValue("resourceId");
        loadData();

        function saveUserData() {
            getFormValue();
        }

    })
</script>
</head>
<body>
    <form id="form1" runat="server">
    <div id="toolbar"></div>
    <div id="actionGrid"></div>
    </form>
</body>
</html>
