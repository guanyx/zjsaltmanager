<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmOrgDestinationCfg.aspx.cs" Inherits="SCM_frmOrgDestinationCfg" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>机构到站信息配置维护</title>
    <meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<link rel="stylesheet" type="text/css" href="../ext3/resources/css/ext-all.css" />
<script type="text/javascript" src="../ext3/adapter/ext/ext-base.js"></script>
<script type="text/javascript" src="../ext3/ext-all.js"></script>
<script type="text/javascript" src="../js/FilterControl.js"></script>
</head>
<body>
<div id='toolbar'></div>
<div id='divForm'></div>
<div id='searchForm'></div>
<div id='orgCfgDiv'></div>
<%=getComboBoxStore() %>
</body>
<script>
Ext.onReady(function() {
var saveType = '';
Ext.BLANK_IMAGE_URL = "../ext3/resources/images/default/s.gif";
/*------实现toolbar的函数 start---------------*/
var Toolbar = new Ext.Toolbar({
    renderTo: "toolbar",
    items: [{
        text: "新增",
        icon: "../Theme/1/images/extjs/customer/add16.gif",
        handler: function() {
            saveType = "add";
            openAddCfgWin();
        }
    }, '-', {
        text: "编辑",
        icon: "../Theme/1/images/extjs/customer/edit16.gif",
        handler: function() {
            saveType = "edit";
            modifyCfgWin();
        }
    }, '-', {
        text: "删除",
        icon: "../Theme/1/images/extjs/customer/delete16.gif",
        handler: function() {
            deleteCfg();
        }
    }]
});

/*------结束toolbar的函数 end---------------*/


/*------开始ToolBar事件函数 start---------------*//*-----新增Cfg实体类窗体函数----*/
function openAddCfgWin() {
    Ext.getCmp('OrgShortName').setValue("");
    Ext.getCmp('OrgCode').setValue("");
    Ext.getCmp('OrgName').setValue("");
    Ext.getCmp('SendType').setValue("");
    //Ext.getCmp('SendTypeText').setValue("");
    uploadCfgWindow.show();
}
/*-----编辑Cfg实体类窗体函数----*/
function modifyCfgWin() {
    var sm = Ext.getCmp('orgCfg').getSelectionModel();
    //获取选择的数据信息
    var selectData = sm.getSelected();
    if (selectData == null) {
        Ext.Msg.alert("提示", "请选中需要编辑的信息！");
        return;
    }
    uploadCfgWindow.show();
    setFormValue(selectData);
}
/*-----删除Cfg实体函数----*/
/*删除信息*/
function deleteCfg() {
    var sm = Ext.getCmp('orgCfg').getSelectionModel();
    //获取选择的数据信息
    var selectData = sm.getSelected();
    //如果没有选择，就提示需要选择数据信息
    if (selectData == null) {
        Ext.Msg.alert("提示", "请选中需要删除的信息！");
        return;
    }
    //删除前再次提醒是否真的要删除
    Ext.Msg.confirm("提示信息", "是否真的要删除选择的机构到站配置信息吗？", function callBack(id) {
        //判断是否删除数据
        if (id == "yes") {
            //页面提交
            Ext.Ajax.request({
                url: 'frmOrgDestinationCfg.aspx?method=deleteCfg',
                method: 'POST',
                params: {
                    DestId: selectData.data.DestId
                },
                success: function(resp, opts) {
                    Ext.Msg.alert("提示", "数据删除成功！");
                },
                failure: function(resp, opts) {
                    Ext.Msg.alert("提示", "数据删除失败！");
                }
            });
        }
    });
}

/*------实现FormPanle的函数 start---------------*/
var destform = new Ext.form.FormPanel({
    url: '',
    frame: true, 
    bodyStyle: 'padding:2px',
    frame: true,
    labelWidth: 70,
    items: [
	{
	    layout: 'column',
	    border: false,
	    labelSeparator: '：',
	    items: [
        {
            layout: 'form',
            border: false,
            columnWidth: 0.5,
            items:
			[{
			    xtype: 'hidden',
			    fieldLabel: '序号',
			    columnWidth: 0.5,
			    anchor: '98%',
			    name: 'DestId',
			    id: 'DestId'
            },{
			    xtype: 'textfield',
			    fieldLabel: '公司代码',
			    columnWidth: 0.5,
			    anchor: '98%',
			    name: 'OrgCode',
			    id: 'OrgCode',
			    enableKeyEvents: true,  
                initEvents: function() {  
                     var keyPress = function(e){  
                         if (e.getKey() == e.ENTER) { 
                             Ext.Ajax.request({
                                 url: 'frmOrgDestinationCfg.aspx?method=getOrgInfo',
                                 params: {
                                    OrgCode: this.getValue()
                                 },
                                 success: function(resp, opts) {
                                     var data = Ext.util.JSON.decode(resp.responseText);
                                     Ext.getCmp("OrgId").setValue(data.OrgId);
                                     Ext.getCmp("OrgShortName").setValue(data.OrgShortName);
                                     Ext.getCmp("OrgName").setValue(data.OrgName);
                                     //Ext.getCmp("SendType").setValue(data.SendType);
                                 },
                                 failure: function(resp, opts) {
                                    Ext.Msg.alert("提示", "获取公司信息失败");
                                 }
                             });                             
                         }  
                     };  
                     this.el.on("keypress", keyPress, this);  
                } 
            }]
        },
		{
		    layout: 'form',
		    border: false,
		    columnWidth: 0.5,
		    items:
			[{
			    xtype: 'hidden',
			    fieldLabel: '编号',
			    columnWidth: 0.5,
			    anchor: '98%',
			    name: 'OrgId',
			    id: 'OrgId'
            },{
			    xtype: 'textfield',
			    fieldLabel: '简称',
			    columnWidth: 0.5,
			    anchor: '98%',
			    readOnly:true,
			    name: 'OrgShortName',
			    id: 'OrgShortName'
            }]
		}
	]
	},
	{
	    layout: 'column',
	    border: false,
	    labelSeparator: '：',
	    items:
		[{
		    layout: 'form',
		    border: false,
		    columnWidth: 1,
		    items:
			[{
			    xtype: 'textfield',
			    fieldLabel: '机构名称',
			    columnWidth: 1,
			    anchor: '98%',
			    name: 'OrgName',
			    id: 'OrgName'
            }]
        }]
	},
	{
	    layout: 'column',
	    border: false,
	    labelSeparator: '：',
	    items:
		[{
		    layout: 'form',
		    border: false,
		    columnWidth: 0.5,
		    items:
			[{
			    xtype: 'combo',
			    fieldLabel: '发运方式',
			    columnWidth: 0.5,
			    anchor: '98%',
			    name: 'SendType',
			    id: 'SendType',
			    store: dsTransType,
			    displayField: 'DicsName',
			    valueField:'DicsCode',
			    triggerAction:'all',
			    mode:'local'
            }]
		}
        , {
            layout: 'form',
            border: false,
            columnWidth: 0.5,
            items:
			[{
			    xtype: 'textfield',
			    fieldLabel: '目的地',
			    columnWidth: 0.5,
			    anchor: '98%',
			    name: 'DestInfo',
			    id: 'DestInfo'
            }]
        }]
    }]
});
/*------FormPanle的函数结束 End---------------*/

/*------开始界面数据的窗体 Start---------------*/
if (typeof (uploadCfgWindow) == "undefined") {//解决创建2个windows问题
    uploadCfgWindow = new Ext.Window({
        id: 'Cfgformwindow',
        title: '到站信息维护'
		, iconCls: 'upload-win'
		, width: 400
		, height: 200
		, layout: 'fit'
		, plain: true
		, modal: true
		, constrain: true
		, resizable: false
		, closeAction: 'hide'
		, autoDestroy: true
		, items: destform
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
			    uploadCfgWindow.hide();
			}
			, scope: this
        }]
    });
}
uploadCfgWindow.addListener("hide", function() {
});

/*------开始获取界面数据的函数 start---------------*/
function saveUserData() {

    Ext.Ajax.request({
        url: 'frmOrgDestinationCfg.aspx?method=' + saveType,
        method: 'POST',
        params: {
            OrgShortName: Ext.getCmp('OrgShortName').getValue(),
            OrgCode: Ext.getCmp('OrgCode').getValue(),
            OrgName: Ext.getCmp('OrgName').getValue(),
            SendType: Ext.getCmp('SendType').getValue(),
            DestInfo: Ext.getCmp('DestInfo').getValue(),
            OrgId: Ext.getCmp('OrgId').getValue(),
            DestId: Ext.getCmp('DestId').getValue(),
            Ext2: ''
        },
        success: function(resp, opts) {
            Ext.Msg.alert("提示", "保存成功");
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
        url: 'frmOrgDestinationCfg.aspx?method=getcfg',
        params: {
            DestId: selectData.data.DestId
        },
        success: function(resp, opts) {
            var data = Ext.util.JSON.decode(resp.responseText);
            Ext.getCmp("OrgShortName").setValue(data.OrgShortName);
            Ext.getCmp("OrgCode").setValue(data.OrgCode);
            Ext.getCmp("OrgName").setValue(data.OrgName);
            Ext.getCmp("SendType").setValue(data.SendType);
            Ext.getCmp("DestInfo").setValue(data.DestInfo);
            Ext.getCmp("DestId").setValue(data.DestId);
        },
        failure: function(resp, opts) {
            Ext.Msg.alert("提示", "获取公司信息失败");
        }
    });
}
            /*------结束设置界面数据的函数 End---------------*/

            /*------开始获取数据的函数 start---------------*/
            var orgCfgData = new Ext.data.Store
({
    url: 'frmOrgDestinationCfg.aspx?method=getlist',
    reader: new Ext.data.JsonReader({
        totalProperty: 'totalProperty',
        root: 'root'
    }, [
	{
	    name: 'DestId'
	},
	{
	    name: 'OrgId'
	},
	{
	    name: 'OrgShortName'
	},
	{
	    name: 'OrgCode'
	},
	{
	    name: 'OrgName'
	},
	{
	    name: 'SendType'
	},
	{
	    name: 'SendTypeText'
	},
	{
	    name: 'DestInfo'
	}
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
var defaultPageSize = 10;
var toolBar = new Ext.PagingToolbar({
    pageSize: 10,
    store: orgCfgData,
    displayMsg: '显示第{0}条到{1}条记录,共{2}条',
    emptyMsy: '没有记录',
    displayInfo: true
});
var pageSizestore = new Ext.data.SimpleStore({
    fields: ['pageSize'],
    data: [[10], [20], [30]]
});
var combo = new Ext.form.ComboBox({
    regex: /^\d*$/,
    store: pageSizestore,
    displayField: 'pageSize',
    typeAhead: true,
    mode: 'local',
    emptyText: '更改每页记录数',
    triggerAction: 'all',
    selectOnFocus: true,
    width: 135
});
toolBar.addField(combo);

combo.on("change", function(c, value) {
    toolBar.pageSize = value;
    defaultPageSize = toolBar.pageSize;
}, toolBar);
combo.on("select", function(c, record) {
    toolBar.pageSize = parseInt(record.get("pageSize"));
    defaultPageSize = toolBar.pageSize;
    toolBar.doLoad(0);
}, toolBar);
/*------开始DataGrid的函数 start---------------*/

var sm = new Ext.grid.CheckboxSelectionModel({
    singleSelect: true
});
var orgCfg = new Ext.grid.GridPanel({
    el: 'orgCfgDiv',
    width: '100%',
    height: '100%',
    autoWidth: true,
    autoHeight: true,
    autoScroll: true,
    layout: 'fit',
    id: 'orgCfg',
    store: orgCfgData,
    loadMask: { msg: '正在加载数据，请稍侯……' },
    sm: sm,
    cm: new Ext.grid.ColumnModel([
		sm,
		new Ext.grid.RowNumberer(), //自动行号
		{
		    header: '公司代码',
		    dataIndex: 'OrgCode',
		    id: 'OrgCode'
        }, {
		    header: '简称',
		    dataIndex: 'OrgShortName',
		    id: 'OrgShortName'
        },
		{
		    header: '机构名称',
		    dataIndex: 'OrgName',
		    id: 'OrgName'
		},
		{
		    header: '目的地',
		    dataIndex: 'DestInfo',
		    id: 'DestInfo'
		},
		{
		    header: '发运方式',
		    dataIndex: 'SendTypeText',
		    id: 'SendTypeText'
		}
		]),
		bbar: toolBar,
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
    orgCfg.render();
    /*------DataGrid的函数结束 End---------------*/

    createSearch(orgCfg, orgCfgData, "searchForm");
    searchForm.el = "searchForm";
    searchForm.render();

})
function getCmbStore(columnName) {

}
</script>

</html>
