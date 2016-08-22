<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmRoleAction.aspx.cs" Inherits="BA_sysadmin_frmRoleAction" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <link rel="stylesheet" type="text/css" href="../../ext3/resources/css/ext-all.css" />

    <script type="text/javascript" src="../../ext3/adapter/ext/ext-base.js"></script>

    <script type="text/javascript" src="../../ext3/ext-all.js"></script>
    <script type="text/javascript" src="../../ext3/example/ItemDeleter.js"></script>
    <%=getComboBoxSource() %>
    <script>
        Ext.onReady(function() {
            var actionGridData = new Ext.data.Store
({
    url: 'frmRoleAction.aspx?method=getactionlist',
    reader: new Ext.data.JsonReader({
        totalProperty: 'totalProperty',
        root: 'root'
    }, [
	{
	    name: 'ResourceName'
	},
	{
	    name: 'ResourceID'
	},
	{
	    name: 'ActionId'
	},
	{
	    name: 'ActionName'
	},
	{
	    name: 'Purview'
	},
	{
	    name: 'RoleId'
	},
	{
	    name: 'ActionChecked'
}])
	,
    listeners:
	{
	    scope: this,
	    load: function() {
	    }
	}
});

            actionGridData.load({
                params: {
                    start: 0,
                    limit: 10,
                    roleid: roleid
                }

            });

            var cmbPurview = new Ext.form.ComboBox({
                name: 'cmbPurview',
                id: 'cmbPurview',
                store: purviewStore,
                displayField: 'DicsName',
                valueField: 'OrderIndex',
                mode: 'local',
                emptyText: '请选择数据权限',
                triggerAction: 'all'
            });

            var fm = Ext.form;

            var itemDeleter = new Extensive.grid.ItemDeleter();
            var sm = new Ext.grid.CheckboxSelectionModel({
                singleSelect: true
            });
            var actionGrid = new Ext.grid.EditorGridPanel({
                el: "actionGrid",
                width: '100%',
                height: '100%',
                autoWidth: true,
                autoHeight: true,
                autoScroll: true,
                stripeRows: true,
                layout: 'fit',
                selModel: itemDeleter,
                //region: "center",
                border: true,
                id: 'actionGrid',
                clicksToEdit: 1,
                store: actionGridData,
                loadMask: { msg: '正在加载数据，请稍侯……' },
                sm: sm,
                cm: new Ext.grid.ColumnModel([
		new Ext.grid.RowNumberer(), //自动行号
		{
		header: '资源信息',
		dataIndex: 'ResourceName',
		id: 'ResourceName',
		width: 100
		, editor: new fm.TextField({
		    allowBlank: false
		})
}, {
    header: '功能',
    dataIndex: 'ActionName',
    id: 'ActionName',
    width: 100
    //		    ,editor:new fm.TextField({
    //		        allowBlank:false
    //		        })
}, {
    header: '是否拥有',
    dataIndex: 'ActionChecked',
    id: 'ActionChecked',
    width: 100
		    , editor: new fm.Checkbox({
		}),
		renderer: cmbCheckBox
}, {
    header: '数据权限',
    dataIndex: 'Purview',
    id: 'Purview',
    width: 100,
    editor: cmbPurview,
    renderer: cmbText

    //		    , editor: new fm.Checkbox({
    //		})
}
		        ]),
                tbar: [{
                    text: '保存',
                    //iconCls:'tianjia',   
                    handler: function(src) {
                        var json = "";
                        actionGridData.each(function(actionGridData) {
                            json += Ext.util.JSON.encode(actionGridData.data) + ',';
                        });
                        json = json.substring(0, json.length - 1);
                        Ext.Ajax.request({
                            url: 'frmRoleAction.aspx?method=saveroleaction',
                            method: 'POST',
                            params: {
                                Json: json
                            },
                            success: function(resp, opts) {
                                Ext.Msg.alert("提示", "数据保存成功");
                            },
                            failure: function(resp, opts) {
                                Ext.Msg.alert("提示", "数据保存失败");
                            }
                        });
                    }
}]
                });
                actionGrid.render();

                function cmbText(val) {
                    var index = purviewStore.find('OrderIndex', val);
                    if (index < 0)
                        return "";
                    var record = purviewStore.getAt(index);
                    return record.data.DicsName;
                }
                function cmbCheckBox(val) {
                    if (val)
                        return "是";
                    return "否";
                }

            })
    </script>
</head>
<body>
    <form id="form1" runat="server">
    <div id="actionGrid"></div>
    </form>
</body>
</html>
