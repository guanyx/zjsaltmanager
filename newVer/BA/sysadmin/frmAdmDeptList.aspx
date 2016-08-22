<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmAdmDeptList.aspx.cs" Inherits="BA_sysadmin_frmAdmDeptList" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>部门管理</title>
    <meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<link rel="stylesheet" type="text/css" href="../../ext3/resources/css/ext-all.css" />
<script type="text/javascript" src="../../ext3/adapter/ext/ext-base.js"></script>
<script type="text/javascript" src="../../ext3/ext-all.js"></script>
<script type="text/javascript" src="../../ext3/example/ColumnNodeUI.js"></script>
<link rel="Stylesheet" type="text/css" href="../../ext3/example/ColumnNodeUI.css" />
<script type="text/javascript" src="../../js/operateResp.js"></script>
<script type="text/javascript" src="../../js/ExtJsHelper.js"></script>
</head>
<%=getComboBoxSource() %>
<%=OrgInformation %>
<script type="text/javascript">
    var imageUrl = "../../Theme/1/";

    Ext.onReady(function() {
    Ext.BLANK_IMAGE_URL = "../../ext3/resources/images/default/s.gif";
    var saveType = "";
    var formTitle = "";
    Ext.QuickTips.init();//开启表单提示
    Ext.form.Field.prototype.msgTarget ='side';//设置提示信息位置为边上
    /*------实现toolbar的函数 start---------------*/
    var Toolbar = new Ext.Toolbar({
        //renderTo: "toolbar",
        region: "north",
        height: 25,
        items: [{
            text: "新增",
            icon: imageUrl + "images/extjs/customer/add16.gif",
            handler: function() {
                saveType = "add";
                openAddDeptWin();
                AddKeyDownEvent('deptForm');
            }
        }, '-', {
            text: "新增子部门",
            icon: imageUrl + "images/extjs/customer/add16.gif",
            handler: function() {
//                var sm = Ext.getCmp('deptGrid').getSelectionModel();
//                //获取选择的数据信息
//                var selectData = sm.getSelected();
//                if (selectData == null) {
//                    Ext.Msg.alert("提示", "请选中需要添加子部门的部门信息！");
//                    return;
//                }
                if (tree.selModel.selNode == null) {
                        Ext.Msg.alert("提示", "请选中需要添加子部门的部门信息！");
                        return;
                    }
                saveType = "add";
                openAddDeptWin();
                Ext.getCmp('DeptParent').setValue(tree.selModel.selNode.id);
                Ext.getCmp('DeptParentName').setValue(tree.selModel.selNode.text);
                AddKeyDownEvent('deptForm');
                
            }
        }, '-', {
            text: "编辑",
            icon: imageUrl + "images/extjs/customer/edit16.gif",
            handler: function() {
                saveType = "editdept";
                modifyDeptWin();
                AddKeyDownEvent('deptForm');
                
            }
        }, '-', {
            text: "删除",
            icon: imageUrl + "images/extjs/customer/delete16.gif",
            handler: function() {

                deleteDept();
            }
}]
        });

        /*------结束toolbar的函数 end---------------*/


        /*------开始ToolBar事件函数 start---------------*//*-----新增Dept实体类窗体函数----*/
        function openAddDeptWin() {
            Ext.getCmp('DeptId').setValue("");
            Ext.getCmp('DeptName').setValue("");
            Ext.getCmp('DeptCode').setValue("");
            Ext.getCmp('DeptParent').setValue("");
            Ext.getCmp('OrgId').setValue(orgId);
            Ext.getCmp('OrgName').setValue(orgName);
            Ext.getCmp("DeptType").setValue("");
            Ext.getCmp("DeptParentName").setValue("");
            //            Ext.getCmp('OperatorId').setValue("");
            //            Ext.getCmp('CreateDate').setValue("");
            //            Ext.getCmp('RecOrgId').setValue("");
            uploadDeptWindow.show();
        }
        /*-----编辑Dept实体类窗体函数----*/
        function modifyDeptWin() {
//            var sm = Ext.getCmp('deptGrid').getSelectionModel();
//            //获取选择的数据信息
//            var selectData = sm.getSelected();
//            if (selectData == null) {
//                Ext.Msg.alert("提示", "请选中需要编辑的信息！");
//                return;
//            }
            if (tree.selModel.selNode == null) {
                        Ext.Msg.alert("提示", "请选中需要编辑的信息！");
                        return;
                    }
            uploadDeptWindow.show();
                setFormValue(tree.selModel.selNode.id);
            
        }
        /*-----删除Dept实体函数----*/
        /*删除信息*/
        function deleteDept() {
//            var sm = Ext.getCmp('deptGrid').getSelectionModel();
//            //获取选择的数据信息
//            var selectData = sm.getSelected();
//            //如果没有选择，就提示需要选择数据信息
//            if (selectData == null) {
//                Ext.Msg.alert("提示", "请选中需要删除的信息！");
//                return;
//            }
            if (tree.selModel.selNode == null) {
                        Ext.Msg.alert("提示", "请选中需要删除的信息！");
                        return;
                    }
                    
            //删除前再次提醒是否真的要删除
            Ext.Msg.confirm("提示信息", "是否真的要删除选择的信息吗？", function callBack(id) {
                //判断是否删除数据
                if (id == "yes") {
                    //页面提交
                    Ext.Ajax.request({
                        url: 'frmAdmDeptList.aspx?method=deletedept',
                        method: 'POST',
                        params: {
                            DeptId: tree.selModel.selNode.id
                        },
                        success: function(resp, opts) {
                           if(checkExtMessage(resp))
                           {
                                //deptGridData.reload();
                                tree.root.reload();
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
        var deptForm = new Ext.form.FormPanel({
            items: [
		{
		    xtype: 'hidden',
		    fieldLabel: '部门标识',
		    columnWidth: 1,
		    anchor: '90%',
		    name: 'DeptId',
		    id: 'DeptId'
		}
, {
    xtype: 'textfield',
    fieldLabel: '部门名称',
    columnWidth: 1,
    anchor: '90%',
    name: 'DeptName',
    id: 'DeptName',
    allowBlank:false,
    blankText: '部门名称不能为空'
}
, {
    xtype: 'textfield',
    fieldLabel: '部门编码',
    columnWidth: 1,
    anchor: '90%',
    name: 'DeptCode',
    id: 'DeptCode',
    allowBlank:false,
    blankText: '部门编码不能为空'
}
, {
    xtype: 'hidden',
    fieldLabel: '上级部门',
    columnWidth: 1,
    anchor: '90%',
    name: 'DeptParent',
    id: 'DeptParent',
    hidden:true
},{
    xtype: 'textfield',
    fieldLabel: '上级部门',
    columnWidth: 1,
    anchor: '90%',
    readOnly:true,
    name: 'DeptParentName',
    id: 'DeptParentName'
}
, {
    xtype: 'hidden',
    fieldLabel: '组织机构',
    columnWidth: 1,
    anchor: '90%',
    name: 'OrgId',
    id: 'OrgId'
}
, {
    xtype: 'textfield',
    fieldLabel: '机构名称',
    columnWidth: 1,
    anchor: '90%',
    name: 'OrgName',
    id: 'OrgName'
}, {
    xtype: 'combo',
    fieldLabel: '部门类别',
    columnWidth: 1,
    anchor: '90%',
    name: 'DeptType',
    id: 'DeptType',
    editable:false,
    store: DeptTypeStore,
    displayField: 'DicsName',
    valueField: 'DicsCode',
    typeAhead: true,
    mode: 'local',
    emptyText: '请选择部门类别信息',
    triggerAction: 'all'
}
]
        });
        /*------FormPanle的函数结束 End---------------*/

        /*------开始界面数据的窗体 Start---------------*/
        if (typeof (uploadDeptWindow) == "undefined") {//解决创建2个windows问题
            uploadDeptWindow = new Ext.Window({
                id: 'Deptformwindow',
                title: formTitle
		, iconCls: 'upload-win'
		, width: 450
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
		, items: deptForm
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
			    uploadDeptWindow.hide();
			}
			, scope: this
}]
            });
        }
        uploadDeptWindow.addListener("hide", function() {
        });

        /*------开始获取界面数据的函数 start---------------*/
        function getFormValue() {
            //检查
	    if(!deptForm.form.isValid()) {
                Ext.Msg.alert("提示", "请检查是否还有内容没有填写");
                return;
            }

            Ext.MessageBox.wait('正在保存数据中, 请稍候……');
            Ext.Ajax.request({
                url: 'frmAdmDeptList.aspx?method=' + saveType,
                method: 'POST',
                params: {
                    DeptId: Ext.getCmp('DeptId').getValue(),
                    DeptName: Ext.getCmp('DeptName').getValue(),
                    DeptCode: Ext.getCmp('DeptCode').getValue(),
                    DeptParent: Ext.getCmp('DeptParent').getValue(),
                    OrgId: Ext.getCmp('OrgId').getValue(),
                    DeptType: Ext.getCmp("DeptType").getValue()
                },
                success: function(resp, opts) {
                    Ext.MessageBox.hide();
                    if(checkExtMessage(resp))
                    {
                        uploadDeptWindow.hide();
                        deptGridData.reload();
                        tree.root.reload();
                    }
                },
                failure: function(resp, opts) {
                    Ext.MessageBox.hide();
                    Ext.Msg.alert("提示", "保存失败");
                }
            });
        }
        /*------结束获取界面数据的函数 End---------------*/

        /*------开始界面数据的函数 Start---------------*/
        function setFormValue(selectData) {
            Ext.Ajax.request({
                url: 'frmAdmDeptList.aspx?method=getdept',
                params: {
                    DeptId: selectData
                },
                success: function(resp, opts) {
                    var data = Ext.util.JSON.decode(resp.responseText);
                    Ext.getCmp("DeptId").setValue(data.DeptId);
                    Ext.getCmp("DeptName").setValue(data.DeptName);
                    Ext.getCmp("DeptCode").setValue(data.DeptCode);
                    Ext.getCmp("DeptParent").setValue(data.DeptParent);
                    Ext.getCmp("OrgId").setValue(data.OrgId);
                    Ext.getCmp("OrgName").setValue(orgName);
                    //                    Ext.getCmp("OperatorId").setValue(data.OperatorId);
                    //                    Ext.getCmp("CreateDate").setValue(data.CreateDate);
                    //                    Ext.getCmp("RecOrgId").setValue(data.RecOrgId);
                    Ext.getCmp("DeptType").setValue(data.DeptType);
                    //                    if (data.DeptDispatching == 1) {
                    //                        Ext.getCmp("DeptDispatching").dom.checked = true;
                    //                    }
                    //                    else {
                    //                        Ext.getCmp("DeptDispatching").dom.checked = false;
                    //                    }
                    Ext.getCmp("DeptParentName").setValue(getParentDepart(data.DeptParent));
                },
                failure: function(resp, opts) {
                    Ext.Msg.alert("提示", "获取部门信息失败");
                }
            });
        }
        /*------结束设置界面数据的函数 End---------------*/

        /*------开始获取数据的函数 start---------------*/
        var deptGridData = new Ext.data.Store
        ({
            url: 'frmAdmDeptList.aspx?method=getlist&orgid=' + orgId,
            reader: new Ext.data.JsonReader({
                totalProperty: 'totalProperty',
                root: 'root'
            }, [
        {
            name: 'DeptId'
        },
        	{
        	    name: 'DeptName'
        	},
        	{
        	    name: 'DeptCode'
        	},
        	{
        	    name: 'DeptParent'
        	},
        	{
        	    name: 'OrgId'
        	},
        	{
        	    name: 'OperatorId'
        	},
        	{
        	    name: 'CreateDate'
        	},
        	{
        	    name: 'RecOrgId'
},{name:'DeptType'}])
        	,
            listeners:
        	{
        	    scope: this,
        	    load: function() {
        	    }
        	}
        });

//        function loadData() {
//            deptGridData.load({
//                params: {
//                    start: 0,
//                    limit: 10,
//                    orgId: orgId
//                }
//            });
//        }
//        loadData();

        /*------获取数据的函数 结束 End---------------*/

        /*------开始DataGrid的函数 start---------------*/

function getParentDepart(val)
{
    var index = deptGridData.find('DeptId', val);
                    if (index < 0)
                        return "";
                    var record = deptGridData.getAt(index);
                    return record.data.DeptName;
            
}

function cmbDeptType(val) {
                    var index = DeptTypeStore.find('DicsCode', val);
                    if (index < 0)
                        return "";
                    var record = DeptTypeStore.getAt(index);
                    return record.data.DicsName;
                }
        var sm = new Ext.grid.CheckboxSelectionModel({
            singleSelect: true
        });
        var deptGrid = new Ext.grid.GridPanel({
            //el: "deptGrid",
            //width: '100%',
            width:400,
            height: '100%',
            autoWidth: true,
            autoHeight: true,
            autoScroll: true,
            //layout: 'fit',
            region: "center",
            border: true,
            //                id: 'deptGrid',
            id: 'deptGrid',
            store: deptGridData,
            loadMask: { msg: '正在加载数据，请稍侯……' },
            sm: sm,
            cm: new Ext.grid.ColumnModel([
        		sm,
        		new Ext.grid.RowNumberer(), //自动行号
        		{
        		header: '部门标识',
        		dataIndex: 'DeptId',
        		id: 'DeptId',
        		hidden:true
      },
        		{
        		    header: '部门名称',
        		    dataIndex: 'DeptName',
        		    width:200,
        		    id: 'DeptName'
        		},
        		{
        		    header: '部门编码',
        		    dataIndex: 'DeptCode',
        		    width:200,
        		    id: 'DeptCode'
        		},
        		{
        		    header: '上级部门',
        		    dataIndex: 'DeptParent',
        		    width:200,
        		    id: 'DeptParent',
        		    renderer:getParentDepart
        		},
        		{
        		    header: '组织机构',
        		    dataIndex: 'OrgId',
        		    width:200,
        		    id: 'OrgId'
        		},
        		{
        		    header: '部门类别',
        		    dataIndex: 'DeptType',
        		    id: 'DeptType',
        		    width:200,
        		    renderer:cmbDeptType
        		}
        ]),
            bbar: new Ext.PagingToolbar({
                pageSize: 10,
                store: deptGridData,
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

deptGrid.hide();
var tree = new Ext.ux.tree.ColumnTree({
                    width: 800,
                    height: 300,
                    rootVisible: false,
                    autoScroll: true,
                    title: '资源信息',
                    renderTo: 'orgDept',
                    id: 'treeColumn',

                    columns: [{
                        header: '部门名称',
                        width: 220,
                        dataIndex: 'text'
                    }, {
                        header: '部门代码',
                        width: 100,
                        dataIndex: 'CustomerColumn'
                    }, {
                        header: '部门类别',
                        width: 200,
                        dataIndex: 'CustomerColumn1',
                         renderer:cmbDeptType
                    }],

                        loader: new Ext.tree.TreeLoader({
                            dataUrl: 'frmAdmDeptList.aspx?method=gettreecolumnlist',
                            uiProviders: {
                                'col': Ext.ux.tree.ColumnNodeUI
                            }
                        }),

                        root: new Ext.tree.AsyncTreeNode({
                            text: 'Tasks'
                        })
                    });
                    tree.render();
        //        var tree = new Ext.ux.tree.ColumnTree({
        //            width: 800,
        //            height: 300,
        //            rootVisible: false,
        //            autoScroll: true,
        //            title: '机构信息',
        //            renderTo: 'orgGrid',
        //            id: 'treeColumn',

        //            columns: [{
        //                header: '部门名称',
        //                width: 220,
        //                dataIndex: 'text'
        //            }, {
        //                header: '部门编号',
        //                width: 100,
        //                dataIndex: 'CustomerColumn'
        //}],

        //                loader: new Ext.tree.TreeLoader({
        //                    dataUrl: 'frmAdmOrgList.aspx?method=gettreecolumnlist',
        //                    uiProviders: {
        //                        'col': Ext.ux.tree.ColumnNodeUI
        //                    }
        //                }),

        //                root: new Ext.tree.AsyncTreeNode({
        //                    text: 'Tasks'
        //                })
        //            });
        //            tree.render();
        //deptGrid.render();
        /*------DataGrid的函数结束 End---------------*/

        /*---------创建界面分布信息-----------------*/

        //{ title: "菜单", region: "west", width: 200, collapsible: true, html: "菜单栏" },
        new Ext.Viewport({ layout: 'border', items: [
            Toolbar, deptGrid]
        })

    })
</script>
<body>
    <form id="form1" runat="server">
    <div id='toolbar'></div>
<div id='divForm'></div>
<div id='deptGrid'></div>
<div id='orgDept'></div>
    </form>
</body>
</html>
