<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmSysDicsInfo.aspx.cs" Inherits="sysadmin_frmysDicsInfo" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>系统字典配置信息维护界面</title>
    <meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
    <link rel="stylesheet" type="text/css" href="../../ext3/resources/css/ext-all.css" />
    <script type="text/javascript" src="../../ext3/adapter/ext/ext-base.js"></script>
    <script type="text/javascript" src="../../ext3/ext-all.js"></script>
    <script type="text/javascript" src="../../js/operateResp.js"></script>
</head>
<body>
    <div id='toolbar'>
    </div>
    <div id='divForm'>
    </div>
    <div id='dataGrid'>
    </div>
</body>

<script type="text/javascript">
Ext.onReady(function() {
    var operType = '';
    /*------实现toolbar的函数 start---------------*/
    var Toolbar = new Ext.Toolbar({
        renderTo: "toolbar",
        items: [{
                    text: "新增",
                    icon: "../../Theme/1/images/extjs/customer/add16.gif",
                    handler: function() {
                        operType = 'add';
                        uploadUserWindow.show();
                    }
                },
                '-', //分隔符
                {
                    text: "编辑",
                    icon: "../../Theme/1/images/extjs/customer/edit16.gif",
                    handler: function() {
                        operType = 'edit';
                        editSysDicsInfo(); 
                    }
                }
                , '-', //分隔符
                {
                    text: "删除",
                    icon: "../../Theme/1/images/extjs/customer/delete16.gif",
                    handler: function() { deleteSysDicsInfo(); }
                }]
        });
        /*  修改窗口  */
        function editSysDicsInfo() 
        {
          setFormValue();//往界面上填值   
        }
        /*  删除操作  */
        function deleteSysDicsInfo() {
            var sm = dataGrid.getSelectionModel();
            var selectData = sm.getSelected();
            /*
            var record=sm.getSelections();
            if(record == null || record.length == 0)
            return null;
            var array = new Array(record.length);
            for(var i=0;i<record.length;i++)
            {
            array[i] = record[i].get('uid');
            }
            */
            if (selectData == null || selectData.length == 0 || selectData.length > 1) 
            {
                Ext.Msg.alert("提示", "请选中一行！");
            }
            else 
            {
                Ext.Ajax.request({
                url: 'frmSysDicsInfo.aspx?method=deleteDicsInfo',
                    params: {
                    DicsCode: selectData.data['DicsCode']//传入frmSysDicsInfo
                    },
                    success: function(resp, opts) {
                        //var data=Ext.util.JSON.decode(resp.responseText);
                        Ext.Msg.alert("提示", "删除成功！");
                        dataGrid.getStore().reload();
                    },
                    failure: function(resp, opts) {
                        Ext.Msg.alert("提示", "删除失败！");
                    }
                });
            }
        }
        /*------结束toolbar的函数 end---------------*/


        /*------实现FormPanle的函数 start---------------*/
        var sysdicsinfo = new Ext.form.FormPanel({
            id: 'sysdicsinfo',
            autoDestroy: true,
            frame: true,
            labelAlign: 'left',
            buttonAlign: 'right',
            bodyStyle: 'padding:5px',
            items: [
	        {
	            xtype: 'textfield',
	            fieldLabel: '系统代码',
	            columnWidth: 1,
	            anchor: '95%',
	            name: 'DicsCode',
	            id: 'DicsCode',
	            maxLength : 5,
	            listeners: { specialkey: function(f, e) { if (e.getKey() == e.ENTER) { Ext.getCmp('DicsName').focus(); } } }
	        }, 
	        {
                xtype: 'textfield',
                fieldLabel: '系统名称',
                columnWidth: 1,
                anchor: '95%',
                name: 'DicsName',
                id: 'DicsName',
                listeners: { specialkey: function(f, e) { if (e.getKey() == e.ENTER) { Ext.getCmp('DicsAliasname').focus(); } } }
            }, 
            {
                xtype: 'textfield',
                fieldLabel: '系统别名',
                columnWidth: 1,
                anchor: '95%',
                name: 'DicsAliasname',
                id: 'DicsAliasname',
                //regex: /^[\u4E00-\u9FA5]+$/,  
                //regexText:'只能输入汉字', 
                //regex: /^[a-zA-Z0-9_\u4e00-\u9fa5]+$/,
                //regexText: '格式应由汉字、数字、字母或下划线组成.',
                listeners: { specialkey: function(f, e) { if (e.getKey() == e.ENTER) { Ext.getCmp('OrderIndex').focus(); } } }
            }, 
            {
                xtype: 'textfield',
                fieldLabel: '排序号',
                columnWidth: 1,
                anchor: '95%',
                name: 'OrderIndex',
                id: 'OrderIndex',
                listeners: { specialkey: function(f, e) { if (e.getKey() == e.ENTER) { Ext.getCmp('ParentsCode').focus(); } } }
            }, 
            {
                xtype: 'textfield',
                fieldLabel: '父代码',
                columnWidth: 1,
                anchor: '95%',
                name: 'ParentsCode',
                id: 'ParentsCode',
                listeners: { specialkey: function(f, e) { if (e.getKey() == e.ENTER) { Ext.getCmp('Isactive').focus(); } } }
            }, 
            {
                xtype: 'checkbox',
                fieldLabel: '是否可用',
                columnWidth: 1,
                anchor: '95%',
                name: 'Isactive',
                id: 'Isactive',
                listeners: { specialkey: function(f, e) { if (e.getKey() == e.ENTER) { Ext.getCmp('Ismodify').focus(); } } }
            }, 
            {
                xtype: 'checkbox',
                fieldLabel: '是否允许修改',
                columnWidth: 1,
                anchor: '95%',
                name: 'Ismodify',
                id: 'Ismodify',
                listeners: { specialkey: function(f, e) { if (e.getKey() == e.ENTER) { Ext.getCmp('Remark').focus(); } } }
            }, 
            {
                xtype: 'textfield',
                fieldLabel: '备注',
                columnWidth: 1,
                anchor: '95%',
                name: 'Remark',
                id: 'Remark',
                listeners: { specialkey: function(f, e) { if (e.getKey() == e.ENTER) { Ext.getCmp('savebuttonid').focus(); } } }
            }]
        });
        /*------FormPanle的函数结束 End---------------*/

        /*------开始获取界面数据的函数 start---------------*/
        function saveFormValue() 
        {
            var Isactive=0;
            var Ismodify=0;
            if (Ext.get("Isactive").dom.checked)
                Isactive= 1;
            if (Ext.get("Ismodify").dom.checked)
                Ismodify= 1;
            
            if(operType == 'add')
                suffix = 'saveAddDicsInfo';
            else if (operType == 'edit')
                suffix = 'saveModifyDicsInfo';
                
            Ext.Ajax.request({
                url: 'frmSysDicsInfo.aspx?method='+suffix,
                method: 'POST',
                timeout: 30000,
                params: {
                    DicsCode: Ext.getCmp('DicsCode').getValue(),
                    DicsName: Ext.getCmp('DicsName').getValue(),
                    DicsAliasname: Ext.getCmp('DicsAliasname').getValue(),
                    OrderIndex: Ext.getCmp('OrderIndex').getValue(),
                    ParentsCode: Ext.getCmp('ParentsCode').getValue(),
                    Isactive: Isactive,
                    Ismodify: Ismodify,
                    Remark: Ext.getCmp('Remark').getValue()
                },
                success: function(resp, opts) 
                {
                    if(checkExtMessage(resp))
                    {
                        dataGrid.getStore().reload();
                    }                    
                },
                failure: function(resp, opts) 
                {
                    Ext.Msg.alert("提示", "保存失败");
                }
            });
        }
        /*------结束获取界面数据的函数 End---------------*/

        /*------开始界面数据的函数 Start---------------*/
        function setFormValue() 
        {
            var sm = dataGrid.getSelectionModel();
            var selectData = sm.getSelected();
            if (selectData == null) 
            {
                Ext.Msg.alert("提示", "请选中一行！");
            }
            else 
            { 
                //先跟据code取来数据，填写到form中，也可以将grid里的record放在form
                Ext.Ajax.request({
                    url: 'frmSysDicsInfo.aspx?method=getModifyDicsInfo',
                    params: {
                        DicsCode: selectData.data['DicsCode']
                    },
                    success: function(resp, opts) {
                        uploadUserWindow.show();
                        var data = Ext.util.JSON.decode(resp.responseText);
                        Ext.getCmp("DicsCode").setValue(data.DicsCode);
                        Ext.getCmp("DicsName").setValue(data.DicsName);
                        Ext.getCmp("DicsAliasname").setValue(data.DicsAliasname);
                        Ext.getCmp("OrderIndex").setValue(data.OrderIndex);
                        Ext.getCmp("ParentsCode").setValue(data.ParentsCode);
                        if (data.Isactive == 1) {
                            Ext.get("Isactive").dom.checked = true;
                        }
                        if (data.Ismodify == 1) {
                            Ext.get("Ismodify").dom.checked = true;
                        }
                        Ext.getCmp("Remark").setValue(data.Remark);
                    },
                    failure: function(resp, opts) {
                        Ext.Msg.alert("提示", "获取系统配置信息失败");
                    }
                });
            }
        }
        /*------结束设置界面数据的函数 End---------------*/

        /*------开始获取数据的函数 start---------------*/
        var userdataGridData = new Ext.data.Store
        ({
            url: 'frmSysDicsInfo.aspx?method=getDicsInfoList',
            reader: new Ext.data.JsonReader({
                totalProperty: 'totalProperty',
                root: 'root'}, 
                [{name: 'DicsCode'},
                {name: 'DicsName'},
                {name: 'DicsAliasname'},
                {name: 'OrderIndex'},
                {name: 'ParentsCode'},
                {name: 'Isactive'},
                {name: 'Ismodify'},
                {name: 'Remark'}]),
                listeners:{
	                    scope: this,
	                    load: function() {
	                    //            
	                    }
	            }
        });

        /*------获取数据的函数 结束 End---------------*/

        /*------开始查询form的函数 start---------------*/

        var dscsCodePanel = new Ext.form.TextField({
            style: 'margin-left:0px',
            cls: 'key',
            xtype: 'textfield',
            fieldLabel: '系统代码',
            name: 'dicsCodeField',
            id: 'dicsCodeField',
            anchor: '90%',
            listeners: { specialkey: function(f, e) { if (e.getKey() == e.ENTER) { Ext.getCmp('dicsParentCodeField').focus(); } } }

        });
        
        var dscsParentCodePanel = new Ext.form.TextField({
            style: 'margin-left:0px',
            cls: 'key',
            xtype: 'textfield',
            fieldLabel: '父代码',
            name: 'dicsParentCodeField',
            id: 'dicsParentCodeField',
            anchor: '90%',
            listeners: { specialkey: function(f, e) { if (e.getKey() == e.ENTER) { Ext.getCmp('dicsNameField').focus(); } } }

        });


        var dicsNameNAMEPanel = new Ext.form.TextField({
            style: 'margin-left:0px',
            cls: 'key',
            xtype: 'textfield',
            fieldLabel: '系统名称',
            name: 'dicsNameField',
            id: 'dicsNameField',
            anchor: '90%',
            listeners: { specialkey: function(f, e) { if (e.getKey() == e.ENTER) { Ext.getCmp('searchebtnId').focus(); } } }
        });

        var serchform = new Ext.FormPanel({
            renderTo: 'divForm',
            labelAlign: 'left',
            layout: 'fit',
            buttonAlign: 'right',
            bodyStyle: 'padding:5px',
            frame: true,
            labelWidth: 55,
            items: [{
                layout: 'column',   //定义该元素为布局为列布局方式
                border: false,
                items: [{
                    columnWidth: .3,  //该列占用的宽度，标识为20％
                    layout: 'form',
                    border: false,
                    items: [
                        dscsCodePanel 
                    ]
                }, {
                    columnWidth: .3,
                    layout: 'form',
                    border: false,
                    items: [
                        dscsParentCodePanel
                        ]
                }, {
                    columnWidth: .3,
                    layout: 'form',
                    border: false,
                    items: [
                        dicsNameNAMEPanel
                        ]
                },{
                    columnWidth: .1,
                    layout: 'form',
                    border: false,
                    items: [{ cls: 'key',
                        xtype: 'button',
                        text: '查询',
                        id: 'searchebtnId',
                        anchor: '90%',
                        handler: function() {

                            var dicsCode = dscsCodePanel.getValue();
                            var ParentsCode = dscsParentCodePanel.getValue();
                            var dicsName = dicsNameNAMEPanel.getValue();

                            userdataGridData.baseParams.DicsCode = dicsCode;
                            userdataGridData.baseParams.ParentsCode = ParentsCode;
                            userdataGridData.baseParams.DicsName = dicsName;
                            userdataGridData.load({
                                params: {
                                    start: 0,
                                    limit: 10
                                }
                            });
                        }
                    }]
                }]
            }]
        });


        /*------开始查询form的函数 end---------------*/

        /*------开始DataGrid的函数 start---------------*/

        var sm = new Ext.grid.CheckboxSelectionModel({
            singleSelect: true
        });
        var dataGrid = new Ext.grid.GridPanel({
            el: 'dataGrid',
            id: 'dicsInfoDatagrid',
            width: '100%',
            height: '100%',
            autoWidth: true,
            autoHeight: true,
            autoScroll: true,
            layout: 'fit',
            id: '',
            store: userdataGridData,
            loadMask: { msg: '正在加载数据，请稍侯……' },
            sm: sm,
            cm: new Ext.grid.ColumnModel([
            sm,
            new Ext.grid.RowNumberer(), //自动行号
            {
                header: '系统代码',
                width: 20,
                dataIndex: 'DicsCode',
                id: 'DicsCode'
            },
            {
                header: '系统名称',
                width: 30,
                dataIndex: 'DicsName',
                id: 'DicsName'
            },
            {
                header: '系统别名',
                width: 30,
                dataIndex: 'DicsAliasname',
                id: 'DicsAliasname'
            },
            {
                header: '排序号',
                width: 10,
                dataIndex: 'OrderIndex',
                id: 'OrderIndex'
            },
            {
                header: '父代码',
                width: 20,
                dataIndex: 'ParentsCode',
                id: 'ParentsCode'
            },
            {
                header: '是否可用',
                width: 10,
                dataIndex: 'Isactive',
                id: 'Isactive',
                renderer:function(v){
                    if(v==0) return '否';
                    if(v==1) return '是';
                }
            },
            {
                header: '是否允许修改',
                width: 10,
                dataIndex: 'Ismodify',
                id: 'Ismodify',
                renderer:function(v){
                    if(v==0) return '否';
                    if(v==1) return '是';
                }
            },
            {
                header: '备注',
                width: 40,
                dataIndex: 'Remark',
                id: 'Remark'
            }]),
            bbar: new Ext.PagingToolbar({
                pageSize: 10,
                store: userdataGridData,
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
        //渲染到页面
        dataGrid.render();
        /*------DataGrid的函数结束 End---------------*/

        /*------WindowForm 配置开始------------------*/
        if (typeof (uploadUserWindow) == "undefined") {//解决创建2个windows问题
            uploadUserWindow = new Ext.Window({
                id: 'userformwindow',
                title: "新增用户"
                , iconCls: 'upload-win'
                , width: 480
                , height: 320
                , layout: 'fit'
                , plain: true
                , modal: true
                // , x: 50
                // , y: 50
                , constrain: true
                , resizable: false
                , closeAction: 'hide'
                , autoDestroy: true
                , items: sysdicsinfo
                , buttons: [{
                     id: 'savebuttonid'
                    , text: "保存"
                    , handler: function() {
                        if (confirm("确认保存？")) {
                            saveUserData();
                            uploadUserWindow.hide();
                        }
                    }
                    , scope: this
                },
                {
                    text: "取消"
                    , handler: function() {
                        uploadUserWindow.hide();
                    }
                    , scope: this
                }]
            });
         }

        uploadUserWindow.addListener("hide", function() {
            sysdicsinfo.getForm().reset();
        });
        /*------WindowForm 配置开始------------------*/
        function saveUserData() 
        {
            saveFormValue();
        }


})
</script>

</html>
