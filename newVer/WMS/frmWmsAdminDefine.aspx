<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmWmsAdminDefine.aspx.cs" Inherits="WMS_frmWmsAdminDefine" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html>
<head>
<title>仓库管理员维护</title><meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<link rel="stylesheet" type="text/css" href="../ext3/resources/css/ext-all.css" />
<script type="text/javascript" src="../ext3/adapter/ext/ext-base.js"></script>
<script type="text/javascript" src="../ext3/ext-all.js"></script>
<script type="text/javascript" src="../js/operateResp.js"></script>
</head>
<body>
<div id='toolbar'></div>
<div id='searchForm'></div>
<div id='dataGrid'></div>

</body>
<%=getComboBoxStore()%>
<script type="text/javascript">
    Ext.onReady(function() {
        Ext.BLANK_IMAGE_URL = "../ext3/resources/images/default/s.gif";
        /*------实现toolbar的函数 start---------------*/
        var Toolbar = new Ext.Toolbar({
            renderTo: "toolbar",
            items: [{
                text: "新增",
                icon: "../Theme/1/images/extjs/customer/add16.gif",
                handler: function() {
                    saveType = 'add';
                    openAddDefineWin();
                }
            }, '-', {
                text: "编辑",
                icon: "../Theme/1/images/extjs/customer/edit16.gif",
                handler: function() {
                    saveType = 'add';
                    modifyDefineWin();
                }
            }, '-', {
                text: "删除",
                icon: "../Theme/1/images/extjs/customer/delete16.gif",
                handler: function() {
                    deleteDefine();
                }
}]
            });

            /*------结束toolbar的函数 end---------------*/


            /*------开始ToolBar事件函数 start---------------*//*-----新增Define实体类窗体函数----*/
            function openAddDefineWin() {
                uploadDefineWindow.show();
                Ext.getCmp("WhId").disabled = false;
                Ext.getCmp("AdminId").disabled = false;
            }
            /*-----编辑Define实体类窗体函数----*/
            function modifyDefineWin() {
                var sm = defineGridData.getSelectionModel();
                //获取选择的数据信息
                var selectData = sm.getSelected();
                if (selectData == null) {
                    Ext.Msg.alert("提示", "请选中需要编辑的信息！");
                    return;
                }
                uploadDefineWindow.show();
                setFormValue(selectData.data.Id);
            }
            /*-----删除Define实体函数----*/
            /*删除信息*/
            function deleteDefine() {
                var sm = defineGridData.getSelectionModel();
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
                            url: 'frmWmsAdminDefine.aspx?method=deleteDefine',
                            method: 'POST',
                            params: {
                                Id: selectData.data.Id
                            },
                            success: function(resp, opts) {
                                if (checkExtMessage(resp)) {
                                    updateDataGrid();
                                }
                            }
                        });
                    }
                });
            }
            function setFormValue(selectedId) {
                Ext.Ajax.request({
                    url: 'frmWmsAdminDefine.aspx?method=getAdminDefineInfo',
                    params: {
                        Id: selectedId
                    },
                    success: function(resp, opts) {
                        var data = Ext.util.JSON.decode(resp.responseText);

                        Ext.getCmp("Id").setValue(data.Id);
                        Ext.getCmp("WhId").setValue(data.WhId);
                        Ext.getCmp("AdminId").setValue(data.AdminId);
                        Ext.getCmp("Status").setValue(data.Status);
                        Ext.getCmp("Remark").setValue(data.Remark);

                        Ext.getCmp("WhId").disabled = true;
                        //Ext.getCmp("AdminId").disabled = true;
                    },
                    failure: function(resp, opts) {
                        Ext.Msg.alert("提示", "获取仓管员信息失败！");
                    }
                });
            }
            /*------实现FormPanle的函数 start---------------*/
            var adminForm = new Ext.form.FormPanel({
                url: '',
                height: '100%',
                frame: true,
                labelWidth: 55,
                items: [
		{
		    xtype: 'hidden',
		    fieldLabel: '流水ID',
		    columnWidth: 1,
		    anchor: '90%',
		    name: 'Id',
		    id: 'Id',
		    hidden: true,
		    hideLabel: true
		}
, {
    xtype: 'combo',
    fieldLabel: '仓库',
    columnWidth: 1,
    anchor: '90%',
    name: 'WhId',
    id: 'WhId',
    store: dsWh,
    mode: 'local',
    displayField: 'WhName',
    valueField: 'WhId',
    editable: false,
    triggerAction: 'all'
}
, {
    xtype: 'combo',
    fieldLabel: '仓管员',
    columnWidth: 1,
    anchor: '90%',
    name: 'AdminId',
    id: 'AdminId',
    store: dsAdminCombo,
    mode: 'local',
    displayField: 'EmpName',
    valueField: 'EmpId',
    triggerAction: 'all',
    editable: false
}

, {
    xtype: 'combo',
    fieldLabel: '状态',
    columnWidth: 1,
    anchor: '90%',
    name: 'Status',
    id: 'Status',
    store: dsStatusList,
    mode: 'local',
    displayField: 'StatusName',
    valueField: 'StatusId',
    triggerAction: 'all',
    editable: false,
    value: 0
}

, {
    xtype: 'textarea',
    fieldLabel: '备注',
    columnWidth: 1,
    anchor: '90%',
    name: 'Remark',
    id: 'Remark'
}
]
            });
            /*------FormPanle的函数结束 End---------------*/

            /*------开始界面数据的窗体 Start---------------*/
            if (typeof (uploadDefineWindow) == "undefined") {//解决创建2个windows问题
                uploadDefineWindow = new Ext.Window({
                    id: 'Defineformwindow',
                    title: '仓库管理员维护'
		, iconCls: 'upload-win'
		, width: 350
		, height: 250
		, layout: 'fit'
		, plain: true
		, modal: true
		, constrain: true
		, resizable: false
		, closeAction: 'hide'
		, autoDestroy: true
		, items: adminForm
		, buttons: [{
		    text: "保存",
		    id: 'btnSave'
			, handler: function() {
			    if (!checkData()) return;
			    saveUserData();
			    Ext.getCmp("btnSave").disabled = true;
			}
			, scope: this
		},
		{
		    text: "取消"
			, handler: function() {
			    uploadDefineWindow.hide();
			}
			, scope: this
}]
                });
            }
            uploadDefineWindow.addListener("hide", function() {
                adminForm.getForm().reset();
                updateDataGrid();
                Ext.getCmp("btnSave").disabled = false;
            });

            /*------开始获取界面数据的函数 start---------------*/
            function saveUserData() {
                Ext.Ajax.request({
                    url: 'frmWmsAdminDefine.aspx?method=saveDefine',
                    method: 'POST',
                    params: {
                        Id: Ext.getCmp('Id').getValue(),
                        AdminId: Ext.getCmp('AdminId').getValue(),
                        WhId: Ext.getCmp('WhId').getValue(),
                        Remark: Ext.getCmp('Remark').getValue()
                    },
                    success: function(resp, opts) {
                        if (checkExtMessage(resp)) {
                        }
                    }
                });
            }
            //检查UI输入数据
            function checkData() {
                var WhId = Ext.getCmp("WhId").getValue().trim();
                if (WhId == "") {
                    Ext.Msg.alert("提示", "所属仓库不能为空！");
                    return false;
                }
                var AdminId = Ext.getCmp("AdminId").getValue().trim();
                if (AdminId == "") {
                    Ext.Msg.alert("提示", "仓管员不能为空！");
                    return false;
                }
                return true;
            }
            function updateDataGrid() {
                var WhId = DefineCombo.getValue();
                var AdminDefineName = defineNamePanel.getValue();

                dsDefine.baseParams.WhId = WhId;
                dsDefine.baseParams.AdminDefineName = AdminDefineName;
                
                dsDefine.load({
                    params: {
                        start: 0,
                        limit: 10
                    }
                });
            }
            /*------结束获取界面数据的函数 End---------------*/

            /*------开始获取数据的函数 start---------------*/
            var dsDefine = new Ext.data.Store
({
    url: 'frmWmsAdminDefine.aspx?method=getDefineList',
    reader: new Ext.data.JsonReader({
        totalProperty: 'totalProperty',
        root: 'root'
    }, [
	{ name: 'Id' },
	{ name: 'AdminId' },
	{ name: 'WhId' },
	{ name: 'CreateDate' },
	{ name: 'UpdateDate' },
	{ name: 'OrgId' },
	{ name: 'Remark' },
	{ name: 'AdmName' },
	{ name: 'OrgName' },
	{ name: 'WhName' },
	{ name: 'Status' }
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
            /*------定义客户配送类型下拉框 start--------*/
            var DefineCombo = new Ext.form.ComboBox({

                fieldLabel: '所属仓库',
                name: 'ownCk',
                store: dsWh,
                displayField: 'WhName',
                valueField: 'WhId',
                mode: 'local',
                editable: false,
                //loadText:'loading ...',
                typeAhead: true, //自动将第一个搜索到的选项补全输入
                triggerAction: 'all',
                selectOnFocus: true,
                forceSelection: true,
                width: 150

            });


            var defineNamePanel = new Ext.form.TextField({
                style: 'margin-left:0px',
                cls: 'key',
                xtype: 'textfield',
                fieldLabel: '管理员名称',
                name: 'nameDefine',
                anchor: '90%'
            });

            var serchform = new Ext.FormPanel({
                renderTo: 'searchForm',
                labelAlign: 'left',
                layout: 'fit',
                buttonAlign: 'right',
                bodyStyle: 'padding:5px',
                frame: true,
                labelWidth: 80,
                items: [{
                    layout: 'column',   //定义该元素为布局为列布局方式
                    border: false,
                    items: [{
                        columnWidth: .4,  //该列占用的宽度，标识为20％
                        layout: 'form',
                        border: false,
                        items: [
                                DefineCombo
                                ]
                    }, {
                        columnWidth: .4,
                        layout: 'form',
                        border: false,
                        items: [
                                    defineNamePanel
                                    ]
                    }, {
                        columnWidth: .2,
                        layout: 'form',
                        border: false,
                        items: [{ cls: 'key',
                            xtype: 'button',
                            text: '查询',
                            anchor: '50%',
                            handler: function() {
                                updateDataGrid();

                            }
}]
}]
}]
                        });


                        /*------开始DataGrid的函数 start---------------*/

                        var sm = new Ext.grid.CheckboxSelectionModel({
                            singleSelect: true
                        });
                        var defineGridData = new Ext.grid.GridPanel({
                            el: 'dataGrid',
                            width: '100%',
                            height: '100%',
                            autoWidth: true,
                            autoHeight: true,
                            autoScroll: true,
                            layout: 'fit',
                            id: '',
                            store: dsDefine,
                            loadMask: { msg: '正在加载数据，请稍侯……' },
                            sm: sm,
                            cm: new Ext.grid.ColumnModel([
		sm,
		new Ext.grid.RowNumberer(), //自动行号
		{
		header: '流水ID',
		dataIndex: 'Id',
		id: 'Id',
		hidden: true,
		hideable: false
},
		{
		    header: '仓管员ID',
		    dataIndex: 'AdminId',
		    id: 'AdminId',
		    hidden: true,
		    hideable: false
		},
		{
		    header: '仓管员',
		    dataIndex: 'AdmName',
		    id: 'AdmName'
		},
		{
		    header: '仓库ID',
		    dataIndex: 'WhId',
		    id: 'WhId',
		    hidden: true,
		    hideable: false
		},
		{
		    header: '仓库',
		    dataIndex: 'WhName',
		    id: 'WhName'
		},
		{
		    header: '组织',
		    dataIndex: 'OrgName',
		    id: 'OrgName'
		},
		{
		    header: '组织ID',
		    dataIndex: 'OrgId',
		    id: 'OrgId',
		    hidden: true,
		    hideable: false
		},
		{
		    header: '状态',
		    dataIndex: 'Status',
		    id: 'Status',
		    renderer: function(val, params, record) {
		        if (dsStatusList.getCount() == 0) {
		            dsStatusList.load();
		        }
		        dsStatusList.each(function(r) {
		            if (val == r.data['StatusId']) {
		                val = r.data['StatusName'];
		                return;
		            }
		        });
		        return val;
		    }
		},
		{
		    header: '创建时间',
		    dataIndex: 'CreateDate',
		    id: 'CreateDate',
		    format: 'Y年m月d日'
		},
		{
		    header: '备注',
		    dataIndex: 'Remark',
		    id: 'Remark'
		}
		]),
                            bbar: new Ext.PagingToolbar({
                                pageSize: 10,
                                store: dsDefine,
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
                        defineGridData.render();
                        /*------DataGrid的函数结束 End---------------*/

                        updateDataGrid();

                    })
</script>

</html>
