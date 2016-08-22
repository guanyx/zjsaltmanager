<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmWmsProductCostAlg.aspx.cs" Inherits="WMS_frmWmsProductCostAlg" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html>
<head>
<title>商品成本算法维护</title><meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
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

<script type="text/javascript">

    Ext.BLANK_IMAGE_URL = "../ext3/resources/images/default/s.gif";
Ext.onReady(function() {
    /*------实现toolbar的函数 start---------------*/
    var Toolbar = new Ext.Toolbar({
        renderTo: "toolbar",
        items: [{
            text: "新增",
            icon: "../Theme/1/images/extjs/customer/add16.gif",
            handler: function() {
                openAddAlgWin();
            }
        }, '-', {
            text: "编辑",
            icon: "../Theme/1/images/extjs/customer/edit16.gif",
            handler: function() {
                modifyAlgWin();
            }
        }, '-', {
            text: "删除",
            icon: "../Theme/1/images/extjs/customer/delete16.gif",
            handler: function() {
                deleteAlg();
            }
}]
        });

        /*------结束toolbar的函数 end---------------*/


        /*------开始ToolBar事件函数 start---------------*//*-----新增Alg实体类窗体函数----*/
        function openAddAlgWin() {
            uploadAlgWindow.show();
        }
        /*-----编辑Alg实体类窗体函数----*/
        function modifyAlgWin() {
            var sm = dataAlgGrid.getSelectionModel();
            //获取选择的数据信息
            var selectData = sm.getSelected();
            if (selectData == null) {
                Ext.Msg.alert("提示", "请选中需要编辑的信息！");
                return;
            }
            uploadAlgWindow.show();
            setFormValue(selectData);
        }
        /*-----删除Alg实体函数----*/
        /*删除信息*/
        function deleteAlg() {
            var sm = dataAlgGrid.getSelectionModel();
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
                        url: 'frmWmsProductCostAlg.aspx?method=deleteAlg',
                        method: 'POST',
                        params: {
                            AlgorithmId: selectData.data.AlgorithmId
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

        /*------实现FormPanle的函数 start---------------*/
        var AlgForm = new Ext.form.FormPanel({
            url: '',
            //renderTo:'divForm',
            frame: true,
            title: '',
            labelWidth: 55,
            items: [
		{
		    xtype: 'hidden',
		    fieldLabel: '成本算法ID',
		    columnWidth: 1,
		    anchor: '95%',
		    name: 'AlgorithmId',
		    id: 'AlgorithmId',
		    hidden: true,
		    hideLabel: true
		}
, {
    xtype: 'textfield',
    fieldLabel: '算法名称',
    columnWidth: 1,
    anchor: '95%',
    name: 'AlgorithmName',
    id: 'AlgorithmName'
}
, {
    xtype: 'textarea',
    fieldLabel: '算法公式',
    columnWidth: 1,
    anchor: '95%',
    name: 'Formula',
    id: 'Formula'
}
, {
    xtype: 'textarea',
    fieldLabel: '备注',
    columnWidth: 1,
    anchor: '95%',
    name: 'Remark',
    id: 'Remark'
}
]
        });
        /*------FormPanle的函数结束 End---------------*/

        /*------开始界面数据的窗体 Start---------------*/
        if (typeof (uploadAlgWindow) == "undefined") {//解决创建2个windows问题
            uploadAlgWindow = new Ext.Window({
                id: 'Algformwindow',
                title: '商品成本算法维护'
		, iconCls: 'upload-win'
		, width: 500
		, height: 250
		, layout: 'fit'
		, plain: true
		, modal: true
		, constrain: true
		, resizable: false
		, closeAction: 'hide'
		, autoDestroy: true
		, items: AlgForm
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
			    uploadAlgWindow.hide();
			}
			, scope: this
}]
            });
        }
        uploadAlgWindow.addListener("hide", function() {
            AlgForm.getForm().reset();
            updateDataGrid();
        });

        /*------开始获取界面数据的函数 start---------------*/
        function saveUserData() {
            Ext.Ajax.request({
                url: 'frmWmsProductCostAlg.aspx?method=saveAlg',
                method: 'POST',
                params: {
                    AlgorithmId: Ext.getCmp('AlgorithmId').getValue(),
                    AlgorithmName: Ext.getCmp('AlgorithmName').getValue(),
                    Formula: Ext.getCmp('Formula').getValue(),
                    Remark: Ext.getCmp('Remark').getValue()
                },
                success: function(resp, opts) {                  
                    if (checkExtMessage(resp)) {
                        uploadAlgWindow.hide();
                    }
                }
            });
        }
        /*------结束获取界面数据的函数 End---------------*/

        /*------开始界面数据的函数 Start---------------*/
        function setFormValue(selectData) {
            Ext.Ajax.request({
                url: 'frmWmsProductCostAlg.aspx?method=getAlg',
                params: {
                    AlgorithmId: selectData.data.AlgorithmId
                },
                success: function(resp, opts) {
                    var data = Ext.util.JSON.decode(resp.responseText);
                    Ext.getCmp("AlgorithmId").setValue(data.AlgorithmId);
                    Ext.getCmp("AlgorithmName").setValue(data.AlgorithmName);
                    Ext.getCmp("Formula").setValue(data.Formula);
                    Ext.getCmp("Remark").setValue(data.Remark);
                },
                failure: function(resp, opts) {
                    Ext.Msg.alert("提示", "获取算法信息失败！");
                }
            });
        }
        /*------结束设置界面数据的函数 End---------------*/

        /*------开始获取数据的函数 start---------------*/
        var dsAlg = new Ext.data.Store
({
    url: 'frmWmsProductCostAlg.aspx?method=getAlgList',
    reader: new Ext.data.JsonReader({
        totalProperty: 'totalProperty',
        root: 'root'
    }, [
	{ name: 'AlgorithmId' },
	{ name: 'AlgorithmName' },
	{ name: 'Formula' },
	{ name: 'Remark' }
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

        /*------开始DataGrid的函数 start---------------*/

        var sm = new Ext.grid.CheckboxSelectionModel({
            singleSelect: true
        });
        var dataAlgGrid = new Ext.grid.GridPanel({
            el: 'dataGrid',
            width: '100%',
            height: '100%',
            autoWidth: true,
            autoHeight: true,
            autoScroll: true,
            layout: 'fit',
            id: '',
            store: dsAlg,
            loadMask: { msg: '正在加载数据，请稍侯……' },
            sm: sm,
            cm: new Ext.grid.ColumnModel([
		sm,
		new Ext.grid.RowNumberer(), //自动行号
		{
		header: '成本算法ID',
		dataIndex: 'AlgorithmId',
		id: 'AlgorithmId',
		hidden: true,
		hideable: false
},
		{
		    header: '算法名称',
		    dataIndex: 'AlgorithmName',
		    id: 'AlgorithmName'
		},
		{
		    header: '算法公式',
		    dataIndex: 'Formula',
		    id: 'Formula'
		},
		{
		    header: '备注',
		    dataIndex: 'Remark',
		    id: 'Remark'
}]),
            bbar: new Ext.PagingToolbar({
                pageSize: 10,
                store: dsAlg,
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
        dataAlgGrid.render();

        function updateDataGrid() {
            dsAlg.reload({ params: { limit: 10, start: 0} });
        }
        /*------DataGrid的函数结束 End---------------*/
        updateDataGrid();


    })
</script>

</html>

