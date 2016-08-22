<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmAdmPosition.aspx.cs" Inherits="BA_sysadmin_frmAdmPosition" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>无标题页</title>
    <meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<link rel="stylesheet" type="text/css" href="../../ext3/resources/css/ext-all.css" />
<script type="text/javascript" src="../../ext3/adapter/ext/ext-base.js"></script>
<script type="text/javascript" src="../../ext3/ext-all.js"></script>
<script type="text/javascript" src="../../js/operateResp.js"></script>
<script type="text/javascript" src="../../js/ExtJsHelper.js"></script>
<script type="text/javascript" src="../../js/RouteSelectChen.js"></script>
</head>
<%=getComboBoxSource() %>
<%=OrgInformation %>
<script type="text/javascript">
var imageUrl = "../../Theme/1/";
Ext.onReady(function() {
    Ext.BLANK_IMAGE_URL = "../../ext3/resources/images/default/s.gif";
    var saveType = "";
    var formTitle = "";
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
                openAddPositionWin();
                Ext.getCmp('DeptId').setDisabled(false);
                Ext.getCmp('PositionParent').setValue("");
                Ext.getCmp('PositionParentName').setValue("");
                AddKeyDownEvent('PositionForm');
            }
        }, '-', {
            text: "新增子岗位",
            icon: imageUrl + "images/extjs/customer/add16.gif",
            handler: function() {
                var sm = Ext.getCmp('PositionGrid').getSelectionModel();
                //获取选择的数据信息
                var selectData = sm.getSelected();
                if (selectData == null) {
                    Ext.Msg.alert("提示", "请选中需要添加子岗位的岗位信息！");
                    return;
                }
                Ext.getCmp('DeptId').setDisabled(true);
                saveType = "add";
                openAddPositionWin();
                Ext.getCmp('PositionParent').setValue(selectData.data.PositionId);
                Ext.getCmp('PositionParentName').setValue(selectData.data.PositionName);
                Ext.getCmp('DeptId').setValue(selectData.data.DeptId);
                AddKeyDownEvent('PositionForm');

            }
        }, '-', {
            text: "编辑",
            icon: imageUrl + "images/extjs/customer/edit16.gif",
            handler: function() {
                saveType = "editposition";
                Ext.getCmp('DeptId').setDisabled(true);
                modifyPositionWin();
                AddKeyDownEvent('PositionForm');

            }
        }, '-', {
            text: "删除",
            icon: imageUrl + "images/extjs/customer/delete16.gif",
            handler: function() {

                deletePosition();
            }
        }, '-', {
            text: "设置客户区域",
            icon: imageUrl + "images/extjs/customer/edit16.gif",
            handler: function() {
                //设置客户经理所管辖的客户区域
                setPositionArea();
            }
}]
        });

        /*------结束toolbar的函数 end---------------*/

var urlRoute = 'frmAdmPosition.aspx?method=getPositionRoute&positionId=';
function setPositionArea()
{
    var sm = Ext.getCmp('PositionGrid').getSelectionModel();
    //获取选择的数据信息
    var selectData = sm.getSelected();
    if (selectData == null) {
        Ext.Msg.alert("提示", "请选中需要设置的信息！");
        return;
    }
    var positionId = selectData.data.PositionId;
    if(selectRouteForm==null)
    {
        showRouteForm("","线路选择",urlRoute+positionId);
        Ext.getCmp("btnRouteOk").on("click",addRoute);
    }
    else
    {
        tree_refresh(positionId);
        selectRouteForm.show();
    }
}

function addRoute()
{
    var sm = Ext.getCmp('PositionGrid').getSelectionModel();
    //获取选择的数据信息
    var selectData = sm.getSelected();
    if (selectData == null) {
        Ext.Msg.alert("提示", "请选中需要设置的信息！");
        return;
    }
    getRouteSelectNodes();
    //页面提交
    Ext.Ajax.request({
        url: 'frmAdmPosition.aspx?method=savePositionRoute',
        method: 'POST',
        params: {
            PositionId: selectData.data.PositionId,
            RouteIds:selectedRouteID
        },
        success: function(resp, opts) {
            if (checkExtMessage(resp)) {
               
            }
        },
        failure: function(resp, opts) {
            Ext.Msg.alert("提示", "线路设置失败");
        }
    });
                    
}
function tree_refresh(positionId){
   var tree = Ext.getCmp('selectRouteTree');
   var loader = new Ext.tree.TreeLoader({dataUrl:urlRoute+positionId});
   loader.load(tree.root);
}
        /*------开始ToolBar事件函数 start---------------*//*-----新增Position实体类窗体函数----*/
        function openAddPositionWin() {
            Ext.getCmp('PositionId').setValue("");
            Ext.getCmp('PositionName').setValue("");
            Ext.getCmp('PositionSort').setValue("");
            Ext.getCmp('PositionMemo').setValue("");
            Ext.getCmp('PositionParent').setValue("");
            Ext.getCmp('PositionType').setValue("");
            Ext.getCmp('PositionRole').setValue("");
            Ext.getCmp('OrgId').setValue(orgId);
            Ext.getCmp("DeptId").setValue("");
            Ext.getCmp('OrgName').setValue(orgName);
            //Ext.getCmp("DeptName").setValue("");
            if (currentNode != null) {
                Ext.getCmp("DeptId").setValue(currentNode.id.substring(4));
                //Ext.getCmp("DeptName").setValue(currentNode.text);
            }
            //            Ext.getCmp('OperatorId').setValue("");
            //            Ext.getCmp('CreateDate').setValue("");
            //            Ext.getCmp('RecOrgId').setValue("");
            uploadPositionWindow.show();
        }
        /*-----编辑Position实体类窗体函数----*/
        function modifyPositionWin() {
            var sm = Ext.getCmp('PositionGrid').getSelectionModel();
            //获取选择的数据信息
            var selectData = sm.getSelected();
            if (selectData == null) {
                Ext.Msg.alert("提示", "请选中需要编辑的信息！");
                return;
            }
            uploadPositionWindow.show();
            setFormValue(selectData);
        }
        /*-----删除Position实体函数----*/
        /*删除信息*/
        function deletePosition() {
            var sm = Ext.getCmp('PositionGrid').getSelectionModel();
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
                        url: 'frmAdmPosition.aspx?method=deleteposition',
                        method: 'POST',
                        params: {
                            PositionId: selectData.data.PositionId
                        },
                        success: function(resp, opts) {
                            if (checkExtMessage(resp)) {
                                PositionGridData.reload();
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
        var PositionForm = new Ext.form.FormPanel({
            items: [
		{
		    xtype: 'hidden',
		    fieldLabel: '岗位标识',
		    columnWidth: 1,
		    anchor: '90%',
		    name: 'PositionId',
		    id: 'PositionId'
		}
, {
    xtype: 'textfield',
    fieldLabel: '岗位名称',
    columnWidth: 1,
    anchor: '90%',
    name: 'PositionName',
    id: 'PositionName'
}, {
    xtype: 'combo',
    fieldLabel: '岗位类别',
    columnWidth: 1,
    anchor: '90%',
    name: 'PositionType',
    id: 'PositionType',
    editable: false,
    store: typeStore,
    displayField: 'DicsName',
    valueField: 'DicsCode',
    typeAhead: true,
    mode: 'local',
    emptyText: '请选择岗位类别信息',
    triggerAction: 'all'

}
, {
    xtype: 'textfield',
    fieldLabel: '对应角色',
    columnWidth: 1,
    anchor: '90%',
    name: 'PositionRole',
    id: 'PositionRole'

}
, {
    xtype: 'textfield',
    fieldLabel: '序号',
    columnWidth: 1,
    anchor: '90%',
    name: 'PositionSort',
    id: 'PositionSort'
}
, {
    xtype: 'hidden',
    fieldLabel: '上级岗位',
    columnWidth: 1,
    anchor: '90%',
    name: 'PositionParent',
    id: 'PositionParent',
    hidden: true
}, {
    xtype: 'textfield',
    fieldLabel: '上级岗位',
    columnWidth: 1,
    anchor: '90%',
    readOnly: true,
    name: 'PositionParentName',
    id: 'PositionParentName'
}, {
    xtype: 'combo',
    fieldLabel: '部门',
    columnWidth: 1,
    anchor: '90%',
    name: 'DeptId',
    id: 'DeptId',
    editable: false,
    store: DeptStore,
    displayField: 'DeptName',
    valueField: 'DeptId',
    typeAhead: true,
    mode: 'local',
    emptyText: '请选择部门信息',
    triggerAction: 'all'

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
    xtype: 'textarea',
    fieldLabel: '岗位说明',
    columnWidth: 1,
    anchor: '90%',
    name: 'PositionMemo',
    id: 'PositionMemo'
}
]
        });
        /*------FormPanle的函数结束 End---------------*/

        /*------开始界面数据的窗体 Start---------------*/
        if (typeof (uploadPositionWindow) == "undefined") {//解决创建2个windows问题
            uploadPositionWindow = new Ext.Window({
                id: 'Positionformwindow',
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
		, items: PositionForm
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
			    uploadPositionWindow.hide();
			}
			, scope: this
}]
            });
        }
        uploadPositionWindow.addListener("hide", function() {
        });

        /*------开始获取界面数据的函数 start---------------*/
        function getFormValue() {
            if (Ext.getCmp("DeptId").getValue() == "") {
                Ext.Msg.alert("创建的岗位信息没有选择部门信息！");
                return;
            }
            Ext.MessageBox.wait('正在保存数据中, 请稍候……');
            Ext.Ajax.request({
                url: 'frmAdmPosition.aspx?method=' + saveType,
                method: 'POST',
                params: {
                    PositionId: Ext.getCmp('PositionId').getValue(),
                    PositionName: Ext.getCmp('PositionName').getValue(),
                    PositionSort: Ext.getCmp('PositionSort').getValue(),
                    PositionParent: Ext.getCmp('PositionParent').getValue(),
                    OrgId: Ext.getCmp('OrgId').getValue(),
                    DeptId: Ext.getCmp("DeptId").getValue(),
                    PositionMemo: Ext.getCmp("PositionMemo").getValue(),
                    PositionType: Ext.getCmp("PositionType").getValue(),
                    PositionRole: ''
                },
                success: function(resp, opts) {
                    Ext.MessageBox.hide();
                    if (checkExtMessage(resp)) {
                        uploadPositionWindow.hide();
                        PositionGridData.reload();
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
                url: 'frmAdmPosition.aspx?method=getposition',
                params: {
                    PositionId: selectData.data.PositionId
                },
                success: function(resp, opts) {
                    var data = Ext.util.JSON.decode(resp.responseText);
                    Ext.getCmp("PositionId").setValue(data.PositionId);
                    Ext.getCmp("PositionName").setValue(data.PositionName);
                    Ext.getCmp("PositionSort").setValue(data.PositionSort);
                    Ext.getCmp("PositionParent").setValue(data.PositionParent);
                    Ext.getCmp("OrgId").setValue(data.OrgId);
                    Ext.getCmp("OrgName").setValue(orgName);
                    Ext.getCmp("DeptId").setValue(data.DeptId);
                    Ext.getCmp("PositionMemo").setValue(data.PositionMemo);
                    Ext.getCmp("PositionType").setValue(data.PositionType);

                },
                failure: function(resp, opts) {
                    Ext.Msg.alert("提示", "获取岗位信息失败");
                }
            });
        }
        /*------结束设置界面数据的函数 End---------------*/

        /*------开始获取数据的函数 start---------------*/
        var PositionGridData = new Ext.data.Store
        ({
            url: 'frmAdmPosition.aspx?method=getlist&orgid=' + orgId,
            reader: new Ext.data.JsonReader({
                totalProperty: 'totalProperty',
                root: 'root'
            }, [
        {
            name: 'PositionId'
        },
        	{
        	    name: 'PositionName'
        	},
        	{
        	    name: 'PositionSort'
        	},
        	{
        	    name: 'PositionParent'
        	},
        	{
        	    name: 'PositionParentName'
        	},
        	{
        	    name: 'OrgId'
        	},
        	{
        	    name: 'OrgName'
        	},
        	{
        	    name: 'DeptName'
        	},
        	{
        	    name: 'DeptId'
}])
        	,
            listeners:
        	{
        	    scope: this,
        	    load: function() {
        	    }
        	}
        });

        function loadData() {
            PositionGridData.load({
                params: {
                    start: 0,
                    limit: 10,
                    orgId: orgId
                }
            });
        }
        loadData();

        /*------获取数据的函数 结束 End---------------*/

        /*------开始DataGrid的函数 start---------------*/

        function getParentDepart(val) {
            var index = PositionGridData.find('PositionId', val);
            if (index < 0)
                return "";
            var record = PositionGridData.getAt(index);
            return record.data.PositionName;

        }


        var sm = new Ext.grid.CheckboxSelectionModel({
            singleSelect: true
        });
        var PositionGrid = new Ext.grid.GridPanel({
            //el: "PositionGrid",
            //width: '100%',
            width: 400,
            height: '100%',
            autoWidth: true,
            autoHeight: true,
            autoScroll: true,
            //layout: 'fit',
            region: "center",
            border: true,
            //                id: 'PositionGrid',
            id: 'PositionGrid',
            store: PositionGridData,
            loadMask: { msg: '正在加载数据，请稍侯……' },
            sm: sm,
            cm: new Ext.grid.ColumnModel([
        		sm,
        		new Ext.grid.RowNumberer(), //自动行号
        		{
        		header: '岗位标识',
        		dataIndex: 'PositionId',
        		id: 'PositionId',
        		hidden: true
      },
        		{
        		    header: '岗位名称',
        		    dataIndex: 'PositionName',
        		    width: 200,
        		    id: 'PositionName'
        		},
        		{
        		    header: '排序',
        		    dataIndex: 'PositionSort',
        		    width: 200,
        		    id: 'PositionSort'
        		},
        		{
        		    header: '上级岗位',
        		    dataIndex: 'PositionParentName',
        		    width: 200,
        		    id: 'PositionParentName'
        		},
        		{
        		    header: '组织机构',
        		    dataIndex: 'OrgName',
        		    width: 200,
        		    id: 'OrgName'
        		},
        		{
        		    header: '部门',
        		    dataIndex: 'DeptName',
        		    id: 'DeptName',
        		    width: 200
        		}
        ]),
            bbar: new Ext.PagingToolbar({
                pageSize: 10,
                store: PositionGridData,
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
        //PositionGrid.render();
        /*------DataGrid的函数结束 End---------------*/

        /*---------创建界面分布信息-----------------*/

        //{ title: "菜单", region: "west", width: 200, collapsible: true, html: "菜单栏" },

        var root = new Ext.tree.AsyncTreeNode({
            text: '部门信息',
            draggable: false,
            id: 'source'
        });

        var url = 'frmAdmPosition.aspx?method=getorgdepttree&orgid=' + orgId;
        var selectDeptTree = new Ext.tree.TreePanel({//就是用来呈现树的"控件"吧
            //el: "divTree",//在page中用来渲染的标签(容器)
            useArrows: true,
            autoScroll: true,
            animate: true,
            enableDD: true,
            containerScroll: true,
            region: 'west',
            width: 150,
            //rootVisible: false,
            loader: new Ext.tree.TreeLoader({
                //dataUrl: url, // 'frmAdmEmpList.aspx?method=gettreecolumnlist&parent=' + parentID,
                dataUrl: url
            }),

            root: root
        });

        var currentNode = null;
        //在beforeload事件中重设dataUrl，以达到动态加载的目的
        selectDeptTree.on('beforeload', function(node) {
            selectDeptTree.loader.dataUrl = url + '&nodeid=' + node.id + '&nodeType=' + node.attributes.NodeType;
        });

        var filterStore = new Ext.data.SimpleStore({
            fields: ['ColumnName', 'Compare', 'ColumnValue'],
            data: [
   ['OrgId', '4', orgId],
   ['DeptId', '4', '0']
   ]
        });

        selectDeptTree.on('click', function(node) {
            if (node.attributes.NodeType == 'dept') {
                currentNode = node;
                filterStore.data.items[1].data.ColumnValue = node.id.substring(4);
                //alert(filterStore.data.items[1].data.ColumnValue);
                var json = "";
                filterStore.each(function(filterStore) {
                    json += Ext.util.JSON.encode(filterStore.data) + ',';
                });
                json = json.substring(0, json.length - 1);
                PositionGridData.baseParams.filter = json;
                PositionGridData.baseParams.limit = 10;
                PositionGridData.baseParams.start = 0;
                PositionGridData.load();
            }
        });


        new Ext.Viewport({ layout: 'border', items: [selectDeptTree,
            Toolbar, PositionGrid]
        })

    })
</script>
<body>
    <form id="form1" runat="server">
    <div id='toolbar'></div>
<div id='divForm'></div>
<div id='PositionGrid'></div>
    </form>
</body>
</html>

