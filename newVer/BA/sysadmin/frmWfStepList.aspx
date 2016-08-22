<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmWfStepList.aspx.cs" Inherits="BA_sysadmin_frmWfStepList" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <link rel="stylesheet" type="text/css" href="../../ext3/resources/css/ext-all.css" />
    <script type="text/javascript" src="../../ext3/adapter/ext/ext-base.js"></script>
    <script type="text/javascript" src="../../ext3/ext-all.js"></script>
    <script type="text/javascript" src="../../js/operateResp.js"></script>
</head>
<%=getComboBoxSource() %>
<script type="text/javascript">

    var stepGridData;
    function loadData() {
        stepGridData.baseParams.wfid = wfid;
        stepGridData.load({ params: { limit: 1000, start: 0} });
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
                    saveType = 'addstep';
                    openAddStepWin();
                }
            }, '-', {
                text: "编辑",
                icon: imageUrl + "images/extjs/customer/edit16.gif",
                handler: function() {
                    saveType = "editstep";
                    modifyStepWin();
                }
            }, '-', {
                text: "删除",
                icon: imageUrl + "images/extjs/customer/delete16.gif",
                handler: function() {
                    deleteStep();
                }
            }, '-', {
                text: "设置路由",
                icon: imageUrl + "images/extjs/customer/delete16.gif",
                handler: function() {
                    setRouteInformation();
                }
            }, '-', {
                text: "设置路由条件",
                icon: imageUrl + "images/extjs/customer/delete16.gif",
                handler: function() {
                    setConditionInformation();
                }
            }, '-', {
                text: "设置物理值信息",
                icon: imageUrl + "images/extjs/customer/delete16.gif",
                handler: function() {
                    setSetColumnInformation();
                }
}]
            });

            /*------结束toolbar的函数 end---------------*/
            function selectedRow(showNoSelectedMessage) {
                var sm = Ext.getCmp('stepGrid').getSelectionModel();
                //获取选择的数据信息
                var selectData = sm.getSelected();
                if (selectData == null) {
                    Ext.Msg.alert("提示", showNoSelectedMessage);
                    return;
                }
                return selectData;

            }

            var uploadRouteWindow = null;
            //设置步骤信息
            function setRouteInformation() {

                var selectData = selectedRow("请先选择设置路由的步骤信息！");
                if (selectData == null)
                    return;
                if (uploadRouteWindow == null) {
                    uploadRouteWindow = parent.ExtJsShowWin('路由信息', '#', 'route', 600, 450)
                }
                uploadRouteWindow.show();
                if (parent.document.getElementById("iframeroute").src.indexOf("frmWfRouteList.aspx") == -1) {
                    parent.document.getElementById("iframeroute").src = "frmWfRouteList.aspx?stepId=" + selectData.data.StepId;
                }
                else {
                    parent.document.getElementById("iframeroute").contentWindow.stepId = selectData.data.StepId;
                    parent.document.getElementById("iframeroute").contentWindow.loadData();
                }

            }

            var uploadConditionWindow = null;
            //设置步骤信息
            function setConditionInformation() {
                var selectData = selectedRow("请先选择设置条件跳转信息的步骤信息！");
                if (selectData == null)
                    return;

                if (uploadConditionWindow == null) {
                    uploadConditionWindow = parent.ExtJsShowWin('条件跳转信息', '#', 'condition', 600, 450)
                }
                uploadConditionWindow.show();
                if (parent.document.getElementById("iframecondition").src.indexOf("frmWfConditionList.aspx") == -1) {
                    parent.document.getElementById("iframecondition").src = "frmWfConditionList.aspx?stepId=" + selectData.data.StepId;
                }
                else {
                    parent.document.getElementById("iframecondition").contentWindow.stepId = selectData.data.StepId;
                    parent.document.getElementById("iframecondition").contentWindow.loadData();
                }

            }

            var uploadSetColumnWindow = null;
            //设置步骤信息
            function setSetColumnInformation() {
                var selectData = selectedRow("请先选择设置对应物理表数据的步骤信息！");
                if (selectData == null)
                    return;
                if (uploadSetColumnWindow == null) {
                    uploadSetColumnWindow = parent.ExtJsShowWin('对应物理表数据信息', '#', 'column', 600, 450)
                }
                uploadSetColumnWindow.show();
                if (parent.document.getElementById("iframecolumn").src.indexOf("frmWfSetColumnList.aspx") == -1) {
                    parent.document.getElementById("iframecolumn").src = "frmWfSetColumnList.aspx?stepId=" + selectData.data.StepId;
                }
                else {
                    parent.document.getElementById("iframecolumn").contentWindow.stepId = selectData.data.StepId;
                    parent.document.getElementById("iframecolumn").contentWindow.loadData();
                }

            }

            /*------开始ToolBar事件函数 start---------------*//*-----新增Step实体类窗体函数----*/
            function openAddStepWin() {
                Ext.getCmp('StepId').setValue("");
                //Ext.getCmp('WorkflowId').setValue("");
                Ext.getCmp('StepName').setValue("");
                Ext.getCmp('StepIsend').setValue("");
                Ext.getCmp('StepCurrent').setValue("");
                Ext.getCmp('StepTimes').setValue("");
                Ext.getCmp('StepJoblevel').setValue(""),
	            Ext.getCmp('StepWorkingday').setValue("");
                Ext.getCmp('StepHour').setValue("");
                Ext.getCmp('StepRemainhour').setValue("");

                var index = parent.wfGridData.find('WorkflowId', wfid);
                if (index >= 0) {
                    var record = parent.wfGridData.getAt(index);
                    Ext.getCmp("WorkflowName").setValue(record.data.WorkflowName);
                }
                //Ext.getCmp("WorkflowId").setValue("");
                uploadStepWindow.show();
            }
            /*-----编辑Step实体类窗体函数----*/
            function modifyStepWin() {
                var sm = Ext.getCmp('stepGrid').getSelectionModel();
                //获取选择的数据信息
                var selectData = sm.getSelected();
                if (selectData == null) {
                    Ext.Msg.alert("提示", "请选中需要编辑的信息！");
                    return;
                }
                uploadStepWindow.show();
                setFormValue(selectData);
            }
            /*-----删除Step实体函数----*/
            /*删除信息*/
            function deleteStep() {
                var sm = Ext.getCmp('stepGrid').getSelectionModel();
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
                            url: 'frmWfStepList.aspx?method=delstep',
                            method: 'POST',
                            params: {
                                StepId: selectData.data.StepId
                            },
                            success: function(resp, opts) {
                                Ext.Msg.alert("提示", "数据删除成");
                            },
                            failure: function(resp, opts) {
                                Ext.Msg.alert("提示", "数据删除失败");
                            }
                        });
                    }
                });
            }

            /*------实现FormPanle的函数 start---------------*/
            var stepForm = new Ext.form.FormPanel({
                frame: true,
                items: [
		{
		    xtype: 'hidden',
		    fieldLabel: '标识',
		    columnWidth: 1,
		    anchor: '90%',
		    name: 'StepId',
		    id: 'StepId'
		}
, {
    xtype: 'textfield',
    fieldLabel: '工作流名称',
    columnWidth: 1,
    anchor: '90%',
    name: 'WorkflowName',
    id: 'WorkflowName'
}
, {
    xtype: 'textfield',
    fieldLabel: '步骤名称',
    columnWidth: 1,
    anchor: '90%',
    name: 'StepName',
    id: 'StepName'
}
, {
    xtype: 'checkbox',
    fieldLabel: '是否结束',
    columnWidth: 1,
    anchor: '90%',
    name: 'StepIsend',
    id: 'StepIsend'
}
, {
    xtype: 'numberfield',
    fieldLabel: '当前步骤',
    columnWidth: 1,
    anchor: '90%',
    name: 'StepCurrent',
    id: 'StepCurrent'
}
, {
    xtype: 'numberfield',
    fieldLabel: '提醒次数',
    columnWidth: 1,
    anchor: '90%',
    name: 'StepTimes',
    id: 'StepTimes'
}
, {
    xtype: 'numberfield',
    fieldLabel: '级别',
    columnWidth: 1,
    anchor: '90%',
    name: 'StepJoblevel',
    id: 'StepJoblevel'
}
, {
    xtype: 'numberfield',
    fieldLabel: '工作天数',
    columnWidth: 1,
    anchor: '90%',
    name: 'StepWorkingday',
    id: 'StepWorkingday'
}
, {
    xtype: 'numberfield',
    fieldLabel: '小时',
    columnWidth: 1,
    anchor: '90%',
    name: 'StepHour',
    id: 'StepHour'
}
, {
    xtype: 'numberfield',
    fieldLabel: '保持时间',
    columnWidth: 1,
    anchor: '90%',
    name: 'StepRemainhour',
    id: 'StepRemainhour'
}
]
            });
            /*------FormPanle的函数结束 End---------------*/

            /*------开始界面数据的窗体 Start---------------*/
            if (typeof (uploadStepWindow) == "undefined") {//解决创建2个windows问题
                uploadStepWindow = new Ext.Window({
                    id: 'Stepformwindow',
                    title: '工作流步骤信息'
		, iconCls: 'upload-win'
		, width: 600
		, height: 340
		, layout: 'fit'
		, plain: true
		, modal: true
		, x: 50
		, y: 50
		, constrain: true
		, resizable: false
		, closeAction: 'hide'
		, autoDestroy: true
		, items: stepForm
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
			    uploadStepWindow.hide();
			}
			, scope: this
}]
                });
            }
            uploadStepWindow.addListener("hide", function() {
            });

            /*------开始获取界面数据的函数 start---------------*/
            function getFormValue() {

                Ext.Ajax.request({
                    url: 'frmWfStepList.aspx?method=' + saveType,
                    method: 'POST',
                    params: {
                        StepId: Ext.getCmp('StepId').getValue(),
                        WorkflowId: wfid,
                        StepName: Ext.getCmp('StepName').getValue(),
                        StepIsend: Ext.getCmp('StepIsend').getValue(),
                        StepCurrent: Ext.getCmp('StepCurrent').getValue(),
                        StepTimes: Ext.getCmp('StepTimes').getValue(),
                        StepJoblevel: Ext.getCmp('StepJoblevel').getValue(),
                        StepWorkingday: Ext.getCmp('StepWorkingday').getValue(),
                        StepHour: Ext.getCmp('StepHour').getValue(),
                        StepRemainhour: Ext.getCmp('StepRemainhour').getValue()
                    },
                    success: function(resp, opts) {
                        if (checkExtMessage(resp)) {
                            stepGridData.reload();
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
                    url: 'frmWfStepList.aspx?method=getstep',
                    params: {
                        StepId: selectData.data.StepId
                    },
                    success: function(resp, opts) {
                        var data = Ext.util.JSON.decode(resp.responseText);
                        Ext.getCmp("StepId").setValue(data.StepId);
                        //Ext.getCmp("WorkflowId").setValue(data.WorkflowId);
                        Ext.getCmp("StepName").setValue(data.StepName);
                        Ext.getCmp("StepIsend").setValue(data.StepIsend);
                        Ext.getCmp("StepCurrent").setValue(data.StepCurrent);
                        Ext.getCmp("StepTimes").setValue(data.StepTimes);
                        Ext.getCmp("StepJoblevel").setValue(data.StepJoblevel);
                        Ext.getCmp("StepWorkingday").setValue(data.StepWorkingday);
                        Ext.getCmp("StepHour").setValue(data.StepHour);
                        Ext.getCmp("StepRemainhour").setValue(data.StepRemainhour);
                        var index = parent.wfGridData.find('WorkflowId', data.WorkflowId);
                        if (index >= 0) {
                            var record = parent.wfGridData.getAt(index);
                            Ext.getCmp("WorkflowName").setValue(record.data.WorkflowName);
                        }
                    },
                    failure: function(resp, opts) {
                        Ext.Msg.alert("提示", "获取信息失败");
                    }
                });
            }
            /*------结束设置界面数据的函数 End---------------*/

            /*------开始获取数据的函数 start---------------*/
            stepGridData = new Ext.data.Store
({
    url: 'frmWfStepList.aspx?method=getsteplist',
    reader: new Ext.data.JsonReader({
        totalProperty: 'totalProperty',
        root: 'root'
    }, [
	{
	    name: 'StepId'
	},
	{
	    name: 'WorkflowId'
	},
	{
	    name: 'StepName'
	},
	{
	    name: 'StepIsend'
	},
	{
	    name: 'StepCurrent'
	},
	{
	    name: 'StepTimes'
	},
	{
	    name: 'StepJoblevel'
	},
	{
	    name: 'StepWorkingday'
	},
	{
	    name: 'StepHour'
	},
	{
	    name: 'StepRemainhour'
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
            function getWorkFlowName(v) {
                var index = parent.wfGridData.find('WorkflowId', wfid);
                if (index >= 0) {
                    var record = parent.wfGridData.getAt(index);
                    return record.data.WorkflowName;
                }
                return "";
            }

            function getBoolValue(v) {
                if (v)
                    return "是";
                return "否";
            }

            /*------开始DataGrid的函数 start---------------*/

            var sm = new Ext.grid.CheckboxSelectionModel({
                singleSelect: true
            });
            var stepGrid = new Ext.grid.GridPanel({
                el: 'stepGrid',
                width: '100%',
                height: '100%',
                autoWidth: true,
                autoHeight: true,
                autoScroll: true,
                layout: 'fit',
                id: 'stepGrid',
                store: stepGridData,
                loadMask: { msg: '正在加载数据，请稍侯……' },
                sm: sm,
                cm: new Ext.grid.ColumnModel([
		sm,
		new Ext.grid.RowNumberer(), //自动行号
		{
		header: '工作流标识',
		dataIndex: 'WorkflowId',
		id: 'WorkflowId',
		renderer: getWorkFlowName
},
		{
		    header: '步骤名称',
		    dataIndex: 'StepName',
		    id: 'StepName'
		},
		{
		    header: '是否结束',
		    dataIndex: 'StepIsend',
		    id: 'StepIsend',
		    renderer: getBoolValue
		},
		{
		    header: '当前步骤',
		    dataIndex: 'StepCurrent',
		    id: 'StepCurrent'
		},
		{
		    header: '提醒次数',
		    dataIndex: 'StepTimes',
		    id: 'StepTimes'
		},
		{
		    header: '级别',
		    dataIndex: 'StepJoblevel',
		    id: 'StepJoblevel'
		},
		{
		    header: '工作天数',
		    dataIndex: 'StepWorkingday',
		    id: 'StepWorkingday'
		},
		{
		    header: '小时',
		    dataIndex: 'StepHour',
		    id: 'StepHour'
		},
		{
		    header: '保持时间',
		    dataIndex: 'StepRemainhour',
		    id: 'StepRemainhour'
}]),
                bbar: new Ext.PagingToolbar({
                    pageSize: 10,
                    store: stepGridData,
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
            stepGrid.render();
            /*------DataGrid的函数结束 End---------------*/
            loadData();


        })
</script>
<body>
<div id='toolbar'></div>
<div id='divForm'></div>
<div id='stepGrid'></div>

</body>
</html>