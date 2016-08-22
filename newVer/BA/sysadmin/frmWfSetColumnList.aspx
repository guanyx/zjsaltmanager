<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmWfSetColumnList.aspx.cs" Inherits="BA_sysadmin_frmWfSetColumnList" %>

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

    var setGridData = null;
    function loadData() {
        setGridData.baseParams.StepId = stepId;
        setGridData.load({ params: { limit: 1000, start: 0} });
    }

    Ext.onReady(function() {
    var saveType = '';
    var imageUrl = "../../Theme/1/";
        /*------实现toolbar的函数 start---------------*/
        var Toolbar = new Ext.Toolbar({
            renderTo: "toolbar",
            items: [{
                text: "新增",
                icon: imageUrl+"images/extjs/customer/add16.gif",
                handler: function() {
                    saveType = 'addsetcolumn';
                    openAddSetphycolumnWin();
                }
            }, '-', {
                text: "编辑",
                icon: imageUrl+"images/extjs/customer/edit16.gif",
                handler: function() {
                    saveType = 'editsetcolumn';
                    modifySetphycolumnWin();
                }
            }, '-', {
                text: "删除",
                icon: imageUrl+"images/extjs/customer/delete16.gif",
                handler: function() {
                    deleteSetphycolumn();
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
                    setGridData = parent.stepGridData;
                }

            }
            getStepGridData();
            /*------开始ToolBar事件函数 start---------------*//*-----新增Setphycolumn实体类窗体函数----*/
            function openAddSetphycolumnWin() {
                //Ext.getCmp('StepId').setValue(""),
                Ext.getCmp('SetSight').setValue("");
                Ext.getCmp('SetEmp').setValue("");
                Ext.getCmp('SetDate').setValue("");
                Ext.getCmp('SetStatus').setValue("");
                Ext.getCmp('StatusValue').setValue("");
                Ext.getCmp('SetType').setValue("");
                var index = stepGridData.find('StepId', stepId);
                if (index >= 0) {
                    var record = stepGridData.getAt(index);
                    Ext.getCmp("StepName").setValue(record.data.StepName);
                }
                uploadSetphycolumnWindow.show();
            }
            /*-----编辑Setphycolumn实体类窗体函数----*/
            function modifySetphycolumnWin() {
                var sm = Ext.getCmp('setGrid').getSelectionModel();
                //获取选择的数据信息
                var selectData = sm.getSelected();
                if (selectData == null) {
                    Ext.Msg.alert("提示", "请选中需要编辑的信息！");
                    return;
                }
                uploadSetphycolumnWindow.show();
                setFormValue(selectData);
            }
            /*-----删除Setphycolumn实体函数----*/
            /*删除信息*/
            function deleteSetphycolumn() {
                var sm = Ext.getCmp('setGrid').getSelectionModel();
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
                            url: 'frmWfSetColumnList.aspx?method=delsetcolumn',
                            method: 'POST',
                            params: {
                                StepId: selectData.data.StepId
                            },
                            success: function(resp, opts) {
                                if (checkExtMessage(resp)) {
                                    setGridData.reload();
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
            var setForm = new Ext.form.FormPanel({
                frame: true,
                items: [
		{
		    xtype: 'textfield',
		    fieldLabel: '标识',
		    columnWidth: 1,
		    anchor: '90%',
		    name: 'StepName',
		    id: 'StepName'
		}
, {
    xtype: 'textfield',
    fieldLabel: '对应意见列',
    columnWidth: 1,
    anchor: '90%',
    name: 'SetSight',
    id: 'SetSight'
}
, {
    xtype: 'textfield',
    fieldLabel: '对应意见人列',
    columnWidth: 1,
    anchor: '90%',
    name: 'SetEmp',
    id: 'SetEmp'
}
, {
    xtype: 'textfield',
    fieldLabel: '对应日期列',
    columnWidth: 1,
    anchor: '90%',
    name: 'SetDate',
    id: 'SetDate'
}
, {
    xtype: 'textfield',
    fieldLabel: '对应状态列',
    columnWidth: 1,
    anchor: '90%',
    name: 'SetStatus',
    id: 'SetStatus'
}
, {
    xtype: 'textfield',
    fieldLabel: '状态值',
    columnWidth: 1,
    anchor: '90%',
    name: 'StatusValue',
    id: 'StatusValue'
}
, {
    xtype: 'textfield',
    fieldLabel: '设置类型（0 步骤前或1 步骤后）',
    columnWidth: 1,
    anchor: '90%',
    name: 'SetType',
    id: 'SetType'
}
]
            });
            /*------FormPanle的函数结束 End---------------*/

            /*------开始界面数据的窗体 Start---------------*/
            if (typeof (uploadSetphycolumnWindow) == "undefined") {//解决创建2个windows问题
                uploadSetphycolumnWindow = new Ext.Window({
                    id: 'Setphycolumnformwindow',
                    title: '设置物理表信息'
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
		, items: setForm
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
			    uploadSetphycolumnWindow.hide();
			}
			, scope: this
}]
                });
            }
            uploadSetphycolumnWindow.addListener("hide", function() {
            });

            /*------开始获取界面数据的函数 start---------------*/
            function getFormValue() {

                Ext.Ajax.request({
                    url: 'frmWfSetColumnList.aspx?method=' + saveType,
                    method: 'POST',
                    params: {
                        StepId: stepId,
                        SetSight: Ext.getCmp('SetSight').getValue(),
                        SetEmp: Ext.getCmp('SetEmp').getValue(),
                        SetDate: Ext.getCmp('SetDate').getValue(),
                        SetStatus: Ext.getCmp('SetStatus').getValue(),
                        StatusValue: Ext.getCmp('StatusValue').getValue(),
                        SetType: Ext.getCmp('SetType').getValue()
                    },
                    success: function(resp, opts) {
                        if (checkExtMessage(resp)) {
                            setGridData.reload();
                            uploadSetphycolumnWindow.hide();
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
                    url: 'frmWfSetColumnList.aspx?method=getsetcolumn',
                    params: {
                        StepId: selectData.data.StepId
                    },
                    success: function(resp, opts) {
                        var data = Ext.util.JSON.decode(resp.responseText);
                        //                        Ext.getCmp("StepId").setValue(data.StepId);
                        Ext.getCmp("SetSight").setValue(data.SetSight);
                        Ext.getCmp("SetEmp").setValue(data.SetEmp);
                        Ext.getCmp("SetDate").setValue(data.SetDate);
                        Ext.getCmp("SetStatus").setValue(data.SetStatus);
                        Ext.getCmp("StatusValue").setValue(data.StatusValue);
                        Ext.getCmp("SetType").setValue(data.SetType);
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
            setGridData = new Ext.data.Store
({
    url: 'frmWfSetColumnList.aspx?method=getsetcolumnlist',
    reader: new Ext.data.JsonReader({
        totalProperty: 'totalProperty',
        root: 'root'
    }, [
	{
	    name: 'StepId'
	},
	{
	    name: 'SetSight'
	},
	{
	    name: 'SetEmp'
	},
	{
	    name: 'SetDate'
	},
	{
	    name: 'SetStatus'
	},
	{
	    name: 'StatusValue'
	},
	{
	    name: 'SetType'
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
            var setGrid = new Ext.grid.GridPanel({
                el: 'setGrid',
                width: '100%',
                height: '100%',
                autoWidth: true,
                autoHeight: true,
                autoScroll: true,
                layout: 'fit',
                id: 'setGrid',
                store: setGridData,
                loadMask: { msg: '正在加载数据，请稍侯……' },
                sm: sm,
                cm: new Ext.grid.ColumnModel([
		sm,
		new Ext.grid.RowNumberer(), //自动行号
		{
		header: '标识',
		dataIndex: 'StepId',
		id: 'StepId',
		hidden: true
},
		{
		    header: '对应意见列',
		    dataIndex: 'SetSight',
		    id: 'SetSight'
		},
		{
		    header: '对应意见人列',
		    dataIndex: 'SetEmp',
		    id: 'SetEmp'
		},
		{
		    header: '对应日期列',
		    dataIndex: 'SetDate',
		    id: 'SetDate'
		},
		{
		    header: '对应状态列',
		    dataIndex: 'SetStatus',
		    id: 'SetStatus'
		},
		{
		    header: '状态值',
		    dataIndex: 'StatusValue',
		    id: 'StatusValue'
		},
		{
		    header: '设置类型（0 步骤前或1 步骤后）',
		    dataIndex: 'SetType',
		    id: 'SetType'
}]),
                bbar: new Ext.PagingToolbar({
                    pageSize: 10,
                    store: setGridData,
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
            setGrid.render();
            /*------DataGrid的函数结束 End---------------*/
            loadData();


        })
</script>
<body>
<div id='toolbar'></div>
<div id='divForm'></div>
<div id='setGrid'></div>

</body>
</html>
