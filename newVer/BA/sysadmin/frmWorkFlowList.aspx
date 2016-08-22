<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmWorkFlowList.aspx.cs" Inherits="BA_sysadmin_frmWorkFlowList" %>

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
<%=getComboBoxSource() %>
<script>

    var wfGridData;
    function loadData() {
        wfGridData.baseParams.GroupId = groupId;
        wfGridData.load({ params: { limit: 20, start: 0} });
    }
    Ext.onReady(function() {
    var saveType;
    var imageUrl = "../../Theme/1/";
        /*------实现toolbar的函数 start---------------*/
        var Toolbar = new Ext.Toolbar({
            renderTo: "toolbar",
            items: [{
                text: "新增",
                icon: imageUrl+"images/extjs/customer/add16.gif",
                handler: function() {
                    saveType = "addworkflow";
                    openAddWorkflowWin();
                }
            }, '-', {
                text: "编辑",
                icon: imageUrl+"images/extjs/customer/edit16.gif",
                handler: function() {
                    saveType = "editworkflow";
                    modifyWorkflowWin();
                }
            }, '-', {
                text: "删除",
                icon: imageUrl+"images/extjs/customer/delete16.gif",
                handler: function() {
                    deleteWorkflow();
                }
            }, '-', {
                text: "设置步骤",
                icon: imageUrl+"images/extjs/customer/edit16.gif",
                handler: function() {
                    setStepInformation();
                }
}]
            });

            /*------结束toolbar的函数 end---------------*/

            var uploadSetWindow = null;
            //设置步骤信息
            function setStepInformation() {
                var sm = Ext.getCmp('gridDiv').getSelectionModel();
                //获取选择的数据信息
                var selectData = sm.getSelected();
                if (selectData == null) {
                    Ext.Msg.alert("提示", "请选中需要设置步骤的工作流信息！");
                    return;
                }

                if (uploadSetWindow == null) {
                    uploadSetWindow = ExtJsShowWin('设置步骤信息', '#', 'set', 700, 500)
                }
                uploadSetWindow.show();
                if (document.getElementById("iframeset").src.indexOf("frmWfStepList.aspx") == -1) {
                    document.getElementById("iframeset").src = "frmWfStepList.aspx?wfid=" + selectData.data.WorkflowId;
                }
                else {
                    document.getElementById("iframeset").contentWindow.wfid = selectData.data.WorkflowId;
                    document.getElementById("iframeset").contentWindow.loadData();
                }

            }

            /*------开始ToolBar事件函数 start---------------*//*-----新增Workflow实体类窗体函数----*/
            function openAddWorkflowWin() {
                Ext.getCmp('WorkflowId').setValue(""),
	            Ext.getCmp('WorkflowName').setValue(""),
	            Ext.getCmp('WorkflowCode').setValue(""),
	            Ext.getCmp('WorkflowPhysicstable').setValue(""),
	            Ext.getCmp('WorkflowIdentity').setValue(""),
	            Ext.getCmp('WorkflowType').setValue(""),
	            //Ext.getCmp('GroupId').setValue(""),
	            Ext.getCmp('GroupStep').setValue(""),
	            Ext.getCmp('WorkflowDetail').setValue(""),
	            uploadWorkflowWindow.show();
            }
            /*-----编辑Workflow实体类窗体函数----*/
            function modifyWorkflowWin() {
                var sm = Ext.getCmp('gridDiv').getSelectionModel();
                //获取选择的数据信息
                var selectData = sm.getSelected();
                if (selectData == null) {
                    Ext.Msg.alert("提示", "请选中需要编辑的信息！");
                    return;
                }
                uploadWorkflowWindow.show();
                setFormValue(selectData);
            }
            /*-----删除Workflow实体函数----*/
            /*删除信息*/
            function deleteWorkflow() {
                var sm = Ext.getCmp('gridDiv').getSelectionModel();
                //获取选择的数据信息
                var selectData = sm.getSelected();
                //如果没有选择，就提示需要选择数据信息
                if (selectData == null) {
                    Ext.Msg.alert("提示", "请选中需要删除的信息！");
                    return;
                }
                //删除前再次提醒是否真的要删除
                Ext.Msg.confirm("提示信息", "是否真的要删除选择的工作流信息吗？", function callBack(id) {
                    //判断是否删除数据
                    if (id == "yes") {
                        //页面提交
                        Ext.Ajax.request({
                            url: 'frmWorkflowList.aspx?method=delworkflow',
                            method: 'POST',
                            params: {
                                WorkflowId: selectData.data.WorkflowId
                            },
                            success: function(resp, opts) {
                                if (checkExtMessage(resp)) {
                                    wfGridData.reload();
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
            var divWF = new Ext.form.FormPanel({
                frame: true,
                items: [
	{
	    layout: 'column',
	    border: false,
	    labelSeparator: '：',
	    items: [
		{
		    layout: 'form',
		    border: false,
		    columnWidth: 1,
		    items: [
				{
				    xtype: 'hidden',
				    columnWidth: 1,
				    anchor: '90%',
				    name: 'WorkflowId',
				    id: 'WorkflowId',
				    hidden: true
				}
		]
		}
	]
	},
	{
	    layout: 'column',
	    border: false,
	    labelSeparator: '：',
	    items: [
		{
		    layout: 'form',
		    border: false,
		    columnWidth: 0.66,
		    items: [
				{
				    xtype: 'textfield',
				    fieldLabel: '名称',
				    columnWidth: 0.66,
				    anchor: '90%',
				    name: 'WorkflowName',
				    id: 'WorkflowName'
				}
		]
		}
, {
    layout: 'form',
    border: false,
    columnWidth: 0.33,
    items: [
				{
				    xtype: 'textfield',
				    fieldLabel: '编码',
				    columnWidth: 0.33,
				    anchor: '90%',
				    name: 'WorkflowCode',
				    id: 'WorkflowCode'
				}
		]
}
	]
	},
	{
	    layout: 'column',
	    border: false,
	    labelSeparator: '：',
	    items: [
		{
		    layout: 'form',
		    border: false,
		    columnWidth: 0.33,
		    items: [
				{
				    xtype: 'textfield',
				    fieldLabel: '对应物理表',
				    columnWidth: 0.33,
				    anchor: '90%',
				    name: 'WorkflowPhysicstable',
				    id: 'WorkflowPhysicstable'
				}
		]
		}
, {
    layout: 'form',
    border: false,
    columnWidth: 0.33,
    items: [
				{
				    xtype: 'textfield',
				    fieldLabel: '主键信息',
				    columnWidth: 0.33,
				    anchor: '90%',
				    name: 'WorkflowIdentity',
				    id: 'WorkflowIdentity'
				}
		]
}
, {
    layout: 'form',
    border: false,
    columnWidth: 0.33,
    items: [
				{
				    xtype: 'textfield',
				    fieldLabel: '类型',
				    columnWidth: 0.33,
				    anchor: '90%',
				    name: 'WorkflowType',
				    id: 'WorkflowType'
				}
		]
}
	]
	},
	{
	    layout: 'column',
	    border: false,
	    labelSeparator: '：',
	    items: [
		{
		    layout: 'form',
		    border: false,
		    columnWidth: 0.66,
		    items: [
				{
				    xtype: 'textfield',
				    fieldLabel: '对应组',
				    columnWidth: 0.66,
				    anchor: '90%',
				    name: 'GroupName',
				    id: 'GroupName'
				}
		]
		}
, {
    layout: 'form',
    border: false,
    columnWidth: 0.33,
    items: [
				{
				    xtype: 'textfield',
				    fieldLabel: '组步骤',
				    columnWidth: 0.33,
				    anchor: '90%',
				    name: 'GroupStep',
				    id: 'GroupStep'
				}
		]
}
	]
	},
	{
	    layout: 'column',
	    border: false,
	    labelSeparator: '：',
	    items: [
		{
		    layout: 'form',
		    border: false,
		    columnWidth: 1,
		    items: [
				{
				    xtype: 'textarea',
				    fieldLabel: '详细信息',
				    columnWidth: 1,
				    anchor: '90%',
				    name: 'WorkflowDetail',
				    id: 'WorkflowDetail'
				}
		]
		}
	]
	}
]
            });
            /*------FormPanle的函数结束 End---------------*/

            /*------开始界面数据的窗体 Start---------------*/
            if (typeof (uploadWorkflowWindow) == "undefined") {//解决创建2个windows问题
                uploadWorkflowWindow = new Ext.Window({
                    id: 'Workflowformwindow',
                    title: '工作流信息设置'
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
		, items: divWF
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
			    uploadWorkflowWindow.hide();
			}
			, scope: this
}]
                });
            }
            uploadWorkflowWindow.addListener("hide", function() {
            });

            /*------开始获取界面数据的函数 start---------------*/
            function getFormValue() {

                Ext.Ajax.request({
                    url: 'frmWorkflowList.aspx?method=' + saveType,
                    method: 'POST',
                    params: {
                        WorkflowId: Ext.getCmp('WorkflowId').getValue(),
                        WorkflowName: Ext.getCmp('WorkflowName').getValue(),
                        WorkflowCode: Ext.getCmp('WorkflowCode').getValue(),
                        WorkflowPhysicstable: Ext.getCmp('WorkflowPhysicstable').getValue(),
                        WorkflowIdentity: Ext.getCmp('WorkflowIdentity').getValue(),
                        WorkflowType: Ext.getCmp('WorkflowType').getValue(),
                        GroupId:groupId,
                        GroupStep: Ext.getCmp('GroupStep').getValue(),
                        WorkflowDetail: Ext.getCmp('WorkflowDetail').getValue()
                    },
                    success: function(resp, opts) {
                        if (checkExtMessage(resp)) {
                            wfGridData.reload();
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
                    url: 'frmWorkflowList.aspx?method=getworkflow',
                    params: {
                        WorkflowId: selectData.data.WorkflowId
                    },
                    success: function(resp, opts) {
                        var data = Ext.util.JSON.decode(resp.responseText);
                        Ext.getCmp("WorkflowId").setValue(data.WorkflowId);
                        Ext.getCmp("WorkflowName").setValue(data.WorkflowName);
                        Ext.getCmp("WorkflowCode").setValue(data.WorkflowCode);
                        Ext.getCmp("WorkflowPhysicstable").setValue(data.WorkflowPhysicstable);
                        Ext.getCmp("WorkflowIdentity").setValue(data.WorkflowIdentity);
                        Ext.getCmp("WorkflowType").setValue(data.WorkflowType);
//                        Ext.getCmp("GroupId").setValue(data.GroupId);
                        Ext.getCmp("GroupStep").setValue(data.GroupStep);
                        Ext.getCmp("WorkflowDetail").setValue(data.WorkflowDetail);
                    },
                    failure: function(resp, opts) {
                        Ext.Msg.alert("提示", "获取用户信息失败");
                    }
                });
            }
            /*------结束设置界面数据的函数 End---------------*/

            /*------开始获取数据的函数 start---------------*/
            wfGridData = new Ext.data.Store
({
    url: 'frmWorkflowList.aspx?method=getworkflowlist',
    reader: new Ext.data.JsonReader({
        totalProperty: 'totalProperty',
        root: 'root'
    }, [
	{
	    name: 'WorkflowId'
	},
	{
	    name: 'WorkflowName'
	},
	{
	    name: 'WorkflowDetail'
	},
	{
	    name: 'WorkflowPhysicstable'
	},
	{
	    name: 'WorkflowIdentity'
	},
	{
	    name: 'WorkflowCode'
	},
	{
	    name: 'WorkflowType'
	},
	{
	    name: 'WorkflowFile'
	},
	{
	    name: 'WorkflowWorkpress'
	},
	{
	    name: 'WorkflowWorkday'
	},
	{
	    name: 'GroupId'
	},
	{
	    name: 'GroupStep'
	},
	{
	    name: 'OrgId'
	},
	{
	    name: 'OperId'
	},
	{
	    name: 'CreateDate'
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
            var wfGrid = new Ext.grid.GridPanel({
                el: 'gridDiv',
                width: '100%',
                height: '100%',
                autoWidth: true,
                autoHeight: true,
                autoScroll: true,
                layout: 'fit',
                id: 'gridDiv',
                store: wfGridData,
                loadMask: { msg: '正在加载数据，请稍侯……' },
                sm: sm,
                cm: new Ext.grid.ColumnModel([
		sm,
		new Ext.grid.RowNumberer(), //自动行号
		{
		header: '名称',
		dataIndex: 'WorkflowName',
		id: 'WorkflowName'
},
		{
		    header: '对应物理表',
		    dataIndex: 'WorkflowPhysicstable',
		    id: 'WorkflowPhysicstable'
		},
		{
		    header: '主键信息',
		    dataIndex: 'WorkflowIdentity',
		    id: 'WorkflowIdentity'
		},
		{
		    header: '编码',
		    dataIndex: 'WorkflowCode',
		    id: 'WorkflowCode'
		},
		{
		    header: '类型',
		    dataIndex: 'WorkflowType',
		    id: 'WorkflowType'
		},
		{
		    header: '对应组',
		    dataIndex: 'GroupId',
		    id: 'GroupId'
		},
		{
		    header: '组步骤',
		    dataIndex: 'GroupStep',
		    id: 'GroupStep'
		},
		{
		    header: '创建时间',
		    dataIndex: 'CreateDate',
		    id: 'CreateDate'
}]),
                bbar: new Ext.PagingToolbar({
                    pageSize: 10,
                    store: wfGridData,
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
            wfGrid.render();
            /*------DataGrid的函数结束 End---------------*/
            loadData();


        })
</script>
<body>
<div id='toolbar'></div>
<div id='divForm'></div>
<div id='gridDiv'></div>

</body>
</html>
