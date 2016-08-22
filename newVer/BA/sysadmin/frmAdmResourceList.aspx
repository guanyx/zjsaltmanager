<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmAdmResourceList.aspx.cs" Inherits="BA_sysadmin_frmAdmResourceList" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>无标题页</title>
    <link rel="stylesheet" type="text/css" href="../../ext3/resources/css/ext-all.css" />
	<script type="text/javascript" src="../../ext3/adapter/ext/ext-base.js"></script>	
	<script type="text/javascript" src="../../ext3/ext-all.js"></script>
	<script type="text/javascript" src="../../ext3/example/ColumnNodeUI.js"></script>
	<link rel="Stylesheet" type="text/css" href="../../ext3/example/ColumnNodeUI.css" />
	<script type="text/javascript" src="../../js/ExtJsHelper.js"></script>
	<script type="text/javascript" src="../../js/operateResp.js"></script>
	<%= resourceData%>
	<%=getComboBoxSource() %>
<script type="text/javascript">
Ext.BLANK_IMAGE_URL = "../../ext3/resources/images/default/s.gif" 
var imageUrl = "../../Theme/1/";
var formTitle = "资源信息";
Ext.onReady(function() {
    var fChild = false;
    var saveType = "";
    /*------实现toolbar的函数 start---------------*/
    var Toolbar = new Ext.Toolbar({
        renderTo: "toolbar",
        items: [{
            text: "新增",
            icon: imageUrl + "images/extjs/customer/add16.gif",
            handler: function() {
                //showRoleList();
                fChild = false;
                saveType = "add";
                //新增窗体显示
                openAddResourceWin();
                resourceDive.html = "";
            }
        }, '-', {
            text: "新增子资源",
            icon: imageUrl + "images/extjs/customer/add16.gif",
            handler: function() {

                saveType = "add";
                fChild = true;
                addChildResourceWin();
            }
        }, '-', {
            text: "编辑",
            icon: imageUrl + "images/extjs/customer/edit16.gif",
            handler: function() {
                fChild = false;
                saveType = "editresource";

                modifyResourceWin();
            }
        }, '-', {
            text: "删除",
            icon: imageUrl + "images/extjs/customer/delete16.gif",
            handler: function() {
                fChild = false;
                deleteResource();
            }
}]
        });


        /*------结束toolbar的函数 end---------------*/


        /*------开始ToolBar事件函数 start---------------*//*-----新增Resource实体类窗体函数----*/
        function openAddResourceWin() {
            Ext.getCmp('ResourceId').setValue("0"),
	Ext.getCmp('ResourceName').setValue(""),
	Ext.getCmp('ModuleId').setValue(""),
	Ext.getCmp('ResourceCode').setValue(""),
	Ext.getCmp('ResourceNavurl').setValue(""),
	Ext.getCmp('ResourceImgurl').setValue(""),
	Ext.getCmp('ResourceBigimgurl').setValue(""),
	Ext.getCmp('ResourceTarget').setValue(""),
	Ext.getCmp('ResourceSort').setValue(""),
	uploadResourceWindow.show();
        }
        var selNode;
        function addChildResourceWin() {
            //var sm = Ext.getCmp('treeColumn').getTreeSelectionModel();
            selNode = tree.selModel.selNode;
            //alert(selNode.id);
            //获取选择的数据信息
            //var selectData = sm.getSelectedNode();
            if (selNode == null) {
                Ext.Msg.alert("提示", "请选中需要新增子资源信息的资源！");
                return;
            }
            openAddResourceWin();
            //	resourceDive.hide();
            resourceDive.visible = false;
        }

        /*-----编辑Resource实体类窗体函数----*/
        function modifyResourceWin() {
            selNode = tree.selModel.selNode;
            //获取选择的数据信息
            // var selectData = sm.getSelected();
            if (selNode == null) {
                Ext.Msg.alert("提示", "请选中需要编辑的信息！");
                return;
            }
            //alert(selNode.id);
            uploadResourceWindow.show();
            setFormValue(selNode);
            //window.open("frmResourceAction.aspx?resourceId=" + selNode.id, "actionList");
            if (document.getElementById("actionList").src.indexOf("frmResourceAction") == -1) {
                document.getElementById("actionList").src = "frmResourceAction.aspx?resourceId=" + selNode.id;
            }
            else {
                document.getElementById("actionList").contentWindow.resourceID = selNode.id;
                document.getElementById("actionList").contentWindow.loadData();                        
            }
        }
        /*-----删除Resource实体函数----*/
        /*删除信息*/
        function deleteResource() {
            selNode = tree.selModel.selNode;
            //如果没有选择，就提示需要选择数据信息
            if (selNode == null) {
                Ext.Msg.alert("提示", "请选中需要删除的信息！");
                return;
            }
            //删除前再次提醒是否真的要删除
            Ext.Msg.confirm("提示信息", "是否真的要删除选择的信息吗？", function callBack(id) {
                //判断是否删除数据
                if (id == "yes") {
                    //页面提交
                    Ext.Ajax.request({
                        url: 'frmAdmResourceList.aspx?method=deleteresource',
                        method: 'POST',
                        params: {
                            ResourceId: selNode.id
                        },
                        success: function(resp, opts) {
                            if(checkExtMessage(resp))
                            {
                                var node=tree.selModel.selNode;
                                var parent=node.parentNode;                
                                parent.removeChild(node);                
                                if(!parent.childNodes) {
                                    node.parentNode.getUI().removeClass('x-tree-node-expanded');
                                    node.parentNode.getUI().addClass('x-tree-node-leaf');
                                }
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
        var resourceDive = new Ext.form.FormPanel({
            frame: true,
            width: 300,
            hide: true,
            region: 'center',
            html: "<iframe id='actionList' src=''name='actionList' style='width:100%; height:100%;'></iframe>"
        });

        var resourceForm = new Ext.form.FormPanel({
            frame: true,
            title: '资源信息',
            width: 300,
            region: 'west',
            items: [
		{
		    xtype: 'hidden',
		    fieldLabel: '资源标识',
		    columnWidth: 1,
		    anchor: '90%',
		    name: 'ResourceId',
		    id: 'ResourceId',
		    hide:true
		}
, {
    xtype: 'textfield',
    fieldLabel: '资源名称',
    columnWidth: 1,
    anchor: '90%',
    name: 'ResourceName',
    id: 'ResourceName'
}
, {
    xtype: 'textfield',
    fieldLabel: '模块标识',
    columnWidth: 1,
    anchor: '90%',
    name: 'ModuleId',
    id: 'ModuleId'
}
, {
    xtype: 'textfield',
    fieldLabel: '资源代码',
    columnWidth: 1,
    anchor: '90%',
    name: 'ResourceCode',
    id: 'ResourceCode'
}
, {
    xtype: 'textfield',
    fieldLabel: '资源Url',
    columnWidth: 1,
    anchor: '90%',
    name: 'ResourceNavurl',
    id: 'ResourceNavurl'
}
, {
    xtype: 'textfield',
    fieldLabel: '资源图片Url',
    columnWidth: 1,
    anchor: '90%',
    name: 'ResourceImgurl',
    id: 'ResourceImgurl'
}
, {
    xtype: 'textfield',
    fieldLabel: '资源大图片Url',
    columnWidth: 1,
    anchor: '90%',
    name: 'ResourceBigimgurl',
    id: 'ResourceBigimgurl'
}
, {
    xtype: 'textfield',
    fieldLabel: '资源显示目标',
    columnWidth: 1,
    anchor: '90%',
    name: 'ResourceTarget',
    id: 'ResourceTarget'
}
, {
    xtype: 'textfield',
    fieldLabel: '资源排序',
    columnWidth: 1,
    anchor: '90%',
    name: 'ResourceSort',
    id: 'ResourceSort'
}, {
    xtype: 'combo',
    fieldLabel: '资源类型',
    columnWidth: 1,
    anchor: '90%',
    name: 'ResourceType',
    id: 'ResourceType',
    store:ResourceTypeStore,
    displayField: 'DicsName',
    valueField: 'DicsCode',
    typeAhead: true,
    mode: 'local',
    emptyText: '请选择部门类别信息',
    triggerAction: 'all'
}, {
    xtype: 'textfield',
    fieldLabel: '帮助链接',
    columnWidth: 1,
    anchor: '90%',
    name: 'ResourceHelpurl',
    id: 'ResourceHelpurl'
}, {
    xtype: 'textarea',
    fieldLabel: '备注',
    columnWidth: 1,
    anchor: '90%',
    name: 'ResourceMemo',
    id: 'ResourceMemo'
}
]
        });
        /*------FormPanle的函数结束 End---------------*/

        /*------开始界面数据的窗体 Start---------------*/
        if (typeof (uploadResourceWindow) == "undefined") {//解决创建2个windows问题
            uploadResourceWindow = new Ext.Window({
                id: 'Resourceformwindow',
                title: formTitle
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
	    , items: [resourceForm, resourceDive]
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
			    uploadResourceWindow.hide();
			}
			, scope: this
}]

            });
        }
        uploadResourceWindow.addListener("hide", function() {
        });

        /*------开始获取界面数据的函数 start---------------*/
        function getFormValue() {
            var resourceParent = null;
            if (fChild) {
                selNode = tree.selModel.selNode;
                //获取选择的数据信息
                //var selectData = sm.getSelected();
                resourceParent = selNode.id;
            }
            Ext.Ajax.request({
                url: 'frmAdmResourceList.aspx?method=' + saveType,
                method: 'POST',
                params: {
                    ResourceId: Ext.getCmp('ResourceId').getValue(),
                    ResourceName: Ext.getCmp('ResourceName').getValue(),
                    ModuleId: Ext.getCmp('ModuleId').getValue(),
                    ResourceCode: Ext.getCmp('ResourceCode').getValue(),
                    ResourceNavurl: Ext.getCmp('ResourceNavurl').getValue(),
                    ResourceImgurl: Ext.getCmp('ResourceImgurl').getValue(),
                    ResourceBigimgurl: Ext.getCmp('ResourceBigimgurl').getValue(),
                    ResourceTarget: Ext.getCmp('ResourceTarget').getValue(),
                    ResourceSort: Ext.getCmp('ResourceSort').getValue(),
                    ResourceType:Ext.getCmp('ResourceType').getValue(),
                    ResourceParentid: resourceParent,
                    ResourceHelpurl:Ext.getCmp('ResourceHelpurl').getValue(),
                    ResourceMemo:Ext.getCmp('ResourceMemo').getValue()
                },
                success: function(resp, opts) {
                    if(checkExtMessage(resp))
                    {
                        var resu = Ext.decode(resp.responseText);
                        var parentNode=tree.selModel.selNode;
                        //tree.loader.reload();
                        if(saveType=="add")
                        {
                            
                            if(parentNode.childNodes==null) {
                                node.parentNode.getUI().removeClass('x-tree-node-leaf');
                                node.parentNode.getUI().addClass('x-tree-node-expanded');
                            }
                            parentNode.appendChild( Ext.decode(unescape(resu.id)));
                        }
                        else
                        {
                            parentNode.attributes.CustomerColumn = Ext.getCmp('ResourceCode').getValue();
                            parentNode.attributes.CustomerColumn1 = Ext.getCmp('ResourceNavurl').getValue();
                            parentNode.setText(Ext.getCmp('ResourceName').getValue());
                            
                        }
                        uploadResourceWindow.hide();
                    }
                },
                failure: function(resp, opts) {
                    Ext.Msg.alert("提示", "保存失败");
                }
            });
        }
        /*------结束获取界面数据的函数 End---------------*/

        /*------开始界面数据的函数 Start---------------*/
        function setFormValue(selNode) {
            Ext.Ajax.request({
                url: 'frmAdmResourceList.aspx?method=getresource',
                params: {
                    ResourceId: selNode.id
                },
                success: function(resp, opts) {
                    var data = Ext.util.JSON.decode(resp.responseText);
                    Ext.getCmp("ResourceId").setValue(data.ResourceId);
                    Ext.getCmp("ResourceName").setValue(data.ResourceName);
                    Ext.getCmp("ModuleId").setValue(data.ModuleId);
                    Ext.getCmp("ResourceCode").setValue(data.ResourceCode);
                    Ext.getCmp("ResourceNavurl").setValue(data.ResourceNavurl);
                    Ext.getCmp("ResourceImgurl").setValue(data.ResourceImgurl);
                    Ext.getCmp("ResourceBigimgurl").setValue(data.ResourceBigimgurl);
                    Ext.getCmp("ResourceTarget").setValue(data.ResourceTarget);
                    Ext.getCmp("ResourceSort").setValue(data.ResourceSort);
                    Ext.getCmp('ResourceType').setValue(data.ResourceType);
                    Ext.getCmp('ResourceHelpurl').setValue(data.ResourceHelpurl);
                    Ext.getCmp('ResourceMemo').setValue(data.ResourceMemo);
                },
                failure: function(resp, opts) {
                    Ext.Msg.alert("提示", "获取用户信息失败");
                }
            });
        }
        /*------结束设置界面数据的函数 End---------------*/

        /*------开始获取数据的函数 start---------------*/
        var resourceGridData = new Ext.data.Store
({
    //url: 'frmAdmResourceList.aspx?method=getresourcelist',
    url: 'frmAdmResourceList.aspx?method=getresourcelist',
    reader: new Ext.data.JsonReader({
        totalProperty: 'totalProperty',
        root: 'root'
    }, [
	{
	    name: 'ResourceId'
	},
	{
	    name: 'ResourceName'
	},
	{
	    name: 'ModuleId'
	},
	{
	    name: 'ResourceCode'
	},
	{
	    name: 'ResourceNavurl'
	},
	{
	    name: 'ResourceImgurl'
	},
	{
	    name: 'ResourceParentid'
	},
	{
	    name: 'ResourceBigimgurl'
	},
	{
	    name: 'ResourceTarget'
	},
	{
	    name: 'ResourceSort'
	},
	{
	    name: 'ResourceIsdel'
	},
	{
	    name: 'ResourceCreater'
	},
	{
	    name: 'ResourceCreatedate'
}])
	,
    listeners:
	{
	    scope: this,
	    load: function() {
	    }
	}
});

        resourceGridData.load({
            params: {
                start: 0,
                limit: 10
            }
        });
        /*------获取数据的函数 结束 End---------------*/

        /*------开始DataGrid的函数 start---------------*/

        // create the data store

        var tree = new Ext.ux.tree.ColumnTree({
            width: 550,
            height: 450,
            //height: document.body.clientHeight,
            rootVisible: false,
            autoScroll: true,
            title: '资源信息',
            renderTo: 'tree',
            id: 'treeColumn',

            columns: [{
                header: '资源名称',
                width: 220,
                dataIndex: 'text'
            }, {
                header: '资源代码',
                width: 100,
                dataIndex: 'CustomerColumn'
            }, {
                header: 'Url',
                width: 200,
                dataIndex: 'CustomerColumn1'
}],

                loader: new Ext.tree.TreeLoader({
                    dataUrl: 'frmAdmResourceList.aspx?method=gettreecolumnlist',
                    uiProviders: {
                        'col': Ext.ux.tree.ColumnNodeUI
                    }
                }),

                root: new Ext.tree.AsyncTreeNode({
                    text: 'Tasks'
                })
            });
            tree.render();


            //                var sm = new Ext.grid.CheckboxSelectionModel({
            //                    singleSelect: true
            //                });
            //                var resourceGrid = new Ext.grid.GridPanel({
            //                    el: 'resourceGrid',
            //                    width: '100%',
            //                    height: '100%',
            //                    autoWidth: true,
            //                    autoHeight: true,
            //                    autoScroll: true,
            //                    layout: 'fit',
            //                    id: 'resourceGrid',
            //                    store: resourceGridData,
            //                    loadMask: { msg: '正在加载数据，请稍侯……' },
            //                    sm: sm,
            //                    cm: new Ext.grid.ColumnModel([
            //		sm,
            //		new Ext.grid.RowNumberer(), //自动行号

            //		{
            //		header: '资源名称',
            //		dataIndex: 'ResourceName',
            //		id: 'ResourceName'
            //},
            //		{
            //		    header: '模块标识',
            //		    dataIndex: 'ModuleId',
            //		    id: 'ModuleId'
            //		},
            //		{
            //		    header: '资源代码',
            //		    dataIndex: 'ResourceCode',
            //		    id: 'ResourceCode'
            //		},
            //		{
            //		    header: '资源Url',
            //		    dataIndex: 'ResourceNavurl',
            //		    id: 'ResourceNavurl'
            //		},
            //		{
            //		    header: '资源图片Url',
            //		    dataIndex: 'ResourceImgurl',
            //		    id: 'ResourceImgurl'
            //		},
            //		{
            //		    header: '父资源ID',
            //		    dataIndex: 'ResourceParentid',
            //		    id: 'ResourceParentid'
            //		},
            //		{
            //		    header: '资源大图片Url',
            //		    dataIndex: 'ResourceBigimgurl',
            //		    id: 'ResourceBigimgurl'
            //		},
            //		{
            //		    header: '资源显示目标',
            //		    dataIndex: 'ResourceTarget',
            //		    id: 'ResourceTarget'
            //		},
            //		{
            //		    header: '资源排序',
            //		    dataIndex: 'ResourceSort',
            //		    id: 'ResourceSort'
            //}]),
            //                    bbar: new Ext.PagingToolbar({
            //                        pageSize: 10,
            //                        store: resourceGridData,
            //                        displayMsg: '显示第{0}条到{1}条记录,共{2}条',
            //                        emptyMsy: '没有记录',
            //                        displayInfo: true
            //                    }),
            //                    viewConfig: {
            //                        columnsText: '显示的列',
            //                        scrollOffset: 20,
            //                        sortAscText: '升序',
            //                        sortDescText: '降序',
            //                        forceFit: true
            //                    },
            //                    height: 280,
            //                    closeAction: 'hide',
            //                    stripeRows: true,
            //                    loadMask: true,
            //                    autoExpandColumn: 2
            //                });
            //resourceGrid.render();

            /*------DataGrid的函数结束 End---------------*/

            /* 保存函数 */
            function saveUserData() {
                getFormValue();
            }

        })
</script>
</head>
<body>
    <form id="form1" runat="server">
    <div id='toolbar'></div>
<div id='resourceGrid'></div>
<div id='showForm'></div>
<%--当前div不显示出来--%>
<div id="actionDiv" style="display:none"></div>
<div id="tree"></div>
    </form>
</body>
</html>
