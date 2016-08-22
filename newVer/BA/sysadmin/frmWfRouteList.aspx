<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmWfRouteList.aspx.cs" Inherits="BA_sysadmin_frmWfRouteList" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <link rel="stylesheet" type="text/css" href="../../ext3/resources/css/ext-all.css" />
    <script type="text/javascript" src="../../ext3/adapter/ext/ext-base.js"></script>
    <script type="text/javascript" src="../../ext3/ext-all.js"></script>
    <script type="text/javascript" src="../../js/operateResp.js"></script>
</head>
<%=getComboBoxSource()%>
<script type="text/javascript">

    var routeGridData = null;
    function loadData() {
        alert(stepId);
        routeGridData.baseParams.StepId = stepId;
        routeGridData.load({ params: { limit: 1000, start: 0} });
    }

    Ext.onReady(function() {
        var saveType = '';
        var imageUrl = "../../Theme/1/";
        /*------实现toolbar的函数 start---------------*/
        var Toolbar = new Ext.Toolbar({
            renderTo: "toolbar",
            items: [{
                text: "新增",
                icon: imageUrl + "images/extjs/customer/add16.gif",
                handler: function() {
                    saveType = 'addroute';
                    openAddRouteWin();
                }
            }, '-', {
                text: "编辑",
                icon: imageUrl + "images/extjs/customer/edit16.gif",
                handler: function() {
                    saveType = 'editroute';
                    modifyRouteWin();
                }
            }, '-', {
                text: "删除",
                icon: imageUrl + "images/extjs/customer/delete16.gif",
                handler: function() {
                    deleteRoute();
                }
}]
            });

            /*------结束toolbar的函数 end---------------*/
            var stepGridData = null;
            function getStepGridData() {
                var setFrame = parent.document.getElementById("iframeset");

                if (setFrame != null) {
                    stepGridData = setFrame.contentWindow.stepGridData
                }
                else {
                    setGridData = stepGridData;
                }

            }
            getStepGridData();

            /*------开始ToolBar事件函数 start---------------*//*-----新增Route实体类窗体函数----*/
            function openAddRouteWin() {
                Ext.getCmp('RouteId').setValue("");
                //Ext.getCmp('StepId').setValue("");
                Ext.getCmp('RouteToStep').setValue("");
                Ext.getCmp('RouteComment').setValue("");
                var index = stepGridData.find('StepId', stepId);
                if (index >= 0) {
                    var record = stepGridData.getAt(index);
                    Ext.getCmp("StepName").setValue(record.data.StepName);
                }
                uploadRouteWindow.show();
            }
            /*-----编辑Route实体类窗体函数----*/
            function modifyRouteWin() {
                var sm = Ext.getCmp('routeGrid').getSelectionModel();
                //获取选择的数据信息
                var selectData = sm.getSelected();
                if (selectData == null) {
                    Ext.Msg.alert("提示", "请选中需要编辑的信息！");
                    return;
                }
                uploadRouteWindow.show();
                setFormValue(selectData);
            }
            /*-----删除Route实体函数----*/
            /*删除信息*/
            function deleteRoute() {
                var sm = Ext.getCmp('routeGrid').getSelectionModel();
                //获取选择的数据信息
                var selectData = sm.getSelected();
                //如果没有选择，就提示需要选择数据信息
                if (selectData == null) {
                    Ext.Msg.alert("提示", "请选中需要删除的信息！");
                    return;
                }
                //删除前再次提醒是否真的要删除
                Ext.Msg.confirm("提示信息", "是否真的要删除选择的角色信息吗？", function callBack(id) {
                    //判断是否删除数据
                    if (id == "yes") {
                        //页面提交
                        Ext.Ajax.request({
                            url: 'frmWfRouteList.aspx?method=delroute',
                            method: 'POST',
                            params: {
                                RouteId: selectData.data.RouteId
                            },
                            success: function(resp, opts) {
                                if (checkExtMessage(resp)) {
                                    routeGridData.reload();
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
            var routeForm = new Ext.form.FormPanel({
                frame: true,
                items: [
		{
		    xtype: 'hidden',
		    fieldLabel: '路由标识',
		    columnWidth: 1,
		    anchor: '90%',
		    name: 'RouteId',
		    id: 'RouteId'
		}
, {
    xtype: 'textfield',
    fieldLabel: '步骤标识',
    columnWidth: 1,
    anchor: '90%',
    name: 'StepName',
    id: 'StepName'
}
, {
    xtype: 'combo',
    fieldLabel: '路由指向步骤',
    columnWidth: 1,
    anchor: '90%',
    name: 'RouteToStep',
    id: 'RouteToStep',
    displayField: 'StepName',
    valueField: 'StepId',
    store: stepGridData,
    typeAhead: true,
    mode: 'local',
    emptyText: '请选择指向步骤信息',
    triggerAction: 'all'
}
, {
    xtype: 'textfield',
    fieldLabel: '路由信息',
    columnWidth: 1,
    anchor: '90%',
    name: 'RouteComment',
    id: 'RouteComment'
}
]
            });
            /*------FormPanle的函数结束 End---------------*/

            /*------开始界面数据的窗体 Start---------------*/
            if (typeof (uploadRouteWindow) == "undefined") {//解决创建2个windows问题
                uploadRouteWindow = new Ext.Window({
                    id: 'Routeformwindow',
                    title: '步骤路由信息'
		, iconCls: 'upload-win'
		, width: 400
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
		, items: routeForm
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
			    uploadRouteWindow.hide();
			}
			, scope: this
}]
                });
            }
            uploadRouteWindow.addListener("hide", function() {
            });

            /*------开始获取界面数据的函数 start---------------*/
            function getFormValue() {

                Ext.Ajax.request({
                    url: 'frmWfRouteList.aspx?method=' + saveType,
                    method: 'POST',
                    params: {
                        RouteId: Ext.getCmp('RouteId').getValue(),
                        StepId: stepId,
                        RouteToStep: Ext.getCmp('RouteToStep').getValue(),
                        RouteComment: Ext.getCmp('RouteComment').getValue()
                    },
                    success: function(resp, opts) {
                        if (checkExtMessage(resp)) {
                            routeGridData.reload();
                            uploadRouteWindow.hide();
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
                    url: 'frmWfRouteList.aspx?method=getroute',
                    params: {
                        RouteId: selectData.data.RouteId
                    },
                    success: function(resp, opts) {
                        var data = Ext.util.JSON.decode(resp.responseText);
                        Ext.getCmp("RouteId").setValue(data.RouteId);
                        //                        Ext.getCmp("StepId").setValue(data.StepId);
                        Ext.getCmp("RouteToStep").setValue(data.RouteToStep);
                        Ext.getCmp("RouteComment").setValue(data.RouteComment);
                        var index = stepGridData.find('StepId', data.StepId);
                        if (index >= 0) {
                            var record = stepGridData.getAt(index);
                            Ext.getCmp("StepName").setValue(record.data.StepName);
                        }
                    },
                    failure: function(resp, opts) {
                        Ext.Msg.alert("提示", "获取信息失败");
                    }
                });
            }
            /*------结束设置界面数据的函数 End---------------*/

            /*------开始获取数据的函数 start---------------*/
            routeGridData = new Ext.data.Store
({
    url: 'frmWfRouteList.aspx?method=getroutelist',
    reader: new Ext.data.JsonReader({
        totalProperty: 'totalProperty',
        root: 'root'
    }, [
	{
	    name: 'RouteId'
	},
	{
	    name: 'StepId'
	},
	{
	    name: 'RouteToStep'
	},
	{
	    name: 'RouteComment'
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

            function getStepName(v) {
                var index = stepGridData.find('StepId', v);
                    if (index >= 0) {
                        var record = stepGridData.getAt(index);
                        return record.data.StepName;
                    }
                    return "";
            }
            /*------开始DataGrid的函数 start---------------*/

            var sm = new Ext.grid.CheckboxSelectionModel({
                singleSelect: true
            });
            var routeGrid = new Ext.grid.GridPanel({
                el: 'routeGrid',
                width: '100%',
                height: '100%',
                autoWidth: true,
                autoHeight: true,
                autoScroll: true,
                layout: 'fit',
                id: 'routeGrid',
                store: routeGridData,
                loadMask: { msg: '正在加载数据，请稍侯……' },
                sm: sm,
                cm: new Ext.grid.ColumnModel([
		sm,
		new Ext.grid.RowNumberer(), //自动行号
		{
		header: '路由标识',
		dataIndex: 'RouteId',
		id: 'RouteId',
		hidden: true
},
		{
		    header: '步骤标识',
		    dataIndex: 'StepId',
		    id: 'StepId',
		    renderer: getStepName
		},
		{
		    header: '路由指向步骤',
		    dataIndex: 'RouteToStep',
		    id: 'RouteToStep',
		    renderer: getStepName
		},
		{
		    header: '路由信息',
		    dataIndex: 'RouteComment',
		    id: 'RouteComment'
}]),
                bbar: new Ext.PagingToolbar({
                    pageSize: 10,
                    store: routeGridData,
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
            routeGrid.render();
            /*------DataGrid的函数结束 End---------------*/
            loadData();
        })
</script>
<body>
<div id='toolbar'></div>
<div id='divForm'></div>
<div id='routeGrid'></div>

</body>
</html>
