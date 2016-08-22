<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmWmsLoadCompany.aspx.cs" Inherits="WMS_frmWmsLoadCompany" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html>
<head>
<title>装卸公司维护页面</title><meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<link rel="stylesheet" type="text/css" href="../ext3/resources/css/ext-all.css" />
<script type="text/javascript" src="../ext3/adapter/ext/ext-base.js"></script>
<script type="text/javascript" src="../ext3/ext-all.js"></script>
</head>
<body>
<div id='toolbar'></div>
<div id='divSearchForm'></div>
<div id='divForm'></div>
<div id='divGrid'></div>

<div style="display:none">
<select id='comboStatus' >
<option value='0'>启用</option>
<option value='1'>禁止</option>
</select></div>
</body>
<script type="text/javascript">
    Ext.BLANK_IMAGE_URL = "../ext3/resources/images/default/s.gif";
    Ext.onReady(function() {
        /*------实现toolbar的函数 start---------------*/
        var Toolbar = new Ext.Toolbar({
            renderTo: "toolbar",
            items: [{
                text: "新增",
                icon: "../theme/1/images/extjs/customer/add16.gif",
                handler: function() { openAddCompanyWin(); }
            }, '-', {
                text: "编辑",
                icon: "../theme/1/images/extjs/customer/edit16.gif",
                handler: function() { modifyCompanyWin(); }
            }, '-', {
                text: "删除",
                icon: "../theme/1/images/extjs/customer/delete16.gif",
                handler: function() { deleteCompany(); }
}]
            });

            /*------结束toolbar的函数 end---------------*/


            /*------开始ToolBar事件函数 start---------------*//*-----新增Company实体类窗体函数----*/
            function openAddCompanyWin() {
                Ext.getCmp('Id').setValue(""),
	            Ext.getCmp('Name').setValue(""),
	            Ext.getCmp('Address').setValue(""),
	            Ext.getCmp('Contact').setValue(""),
	            Ext.getCmp('Phone').setValue(""),
	            Ext.getCmp('Qq').setValue(""),
	            Ext.getCmp('Msn').setValue(""),
	            Ext.getCmp('Remark').setValue(""),
	            Ext.getCmp('Status').setValue(""),
	            uploadCompanyWindow.show();
            }
            /*-----编辑Company实体类窗体函数----*/
            function modifyCompanyWin() {
                var sm = gridData.getSelectionModel();
                //获取选择的数据信息
                var selectData = sm.getSelected();
                if (selectData == null) {
                    Ext.Msg.alert("提示", "请选中需要编辑的信息！");
                    return;
                }
                uploadCompanyWindow.show();
                setFormValue(selectData);
            }
            /*-----删除Company实体函数----*/
            /*删除信息*/
            function deleteCompany() {
                var sm = gridData.getSelectionModel();
                //获取选择的数据信息
                var selectData = sm.getSelected();
                //如果没有选择，就提示需要选择数据信息
                if (selectData == null) {
                    Ext.Msg.alert("提示", "请选中需要删除的信息！");
                    return;
                }
                //删除前再次提醒是否真的要删除
                Ext.Msg.confirm("提示信息", "是否真的要删除选择的装卸公司信息吗？", function callBack(id) {
                    //判断是否删除数据
                    if (id == "yes") {
                        //页面提交
                        Ext.Ajax.request({
                            url: 'frmWmsLoadCompany.aspx?method=deleteCompanyAction',
                            method: 'POST',
                            params: {
                                Id: selectData.data.Id
                            },
                            success: function(resp, opts) {
                                Ext.Msg.alert("提示", "数据删除成！");
                                updateDataGrid();
                            },
                            failure: function(resp, opts) {
                                Ext.Msg.alert("提示", "数据删除失败！");
                            }
                        });
                    }
                });
            }
            function updateDataGrid() {
                var Name = NamePanel.getValue();
                var Phone = PhonePanel.getValue();
                var Address = AddressPanel.getValue();
                var Status = StatusPanel.getValue();
                var type= CompanyTypePanel.getValue();

                gridDataData.baseParams.Name = Name;
                gridDataData.baseParams.Phone = Phone;
                gridDataData.baseParams.Address = Address;
                gridDataData.baseParams.Status = Status;
                gridDataData.baseParams.CompType = type;

                gridDataData.load({
                    params: {
                        start: 0,
                        limit: 10
                    }
                });
            }

            /*------实现FormPanle的函数 start---------------*/
            var formData = new Ext.form.FormPanel({
                url: '',
                //renderTo:'divForm',
                labelWidth:60,
                frame: true,
                title: '',
                items: [
		{
		    xtype: 'hidden',
		    fieldLabel: '标识',
		    columnWidth: 1,
		    anchor: '95%',
		    name: 'Id',
		    id: 'Id',
		    hidden: true,
		    hiddenLabel: true
		}
, {
    xtype: 'textfield',
    fieldLabel: '名称',
    columnWidth: 1,
    anchor: '95%',
    name: 'Name',
    id: 'Name'
}
, {
    xtype: 'textfield',
    fieldLabel: '地址',
    columnWidth: 1,
    anchor: '95%',
    name: 'Address',
    id: 'Address'
}
, {
    xtype: 'textfield',
    fieldLabel: '联系人',
    columnWidth: 1,
    anchor: '95%',
    name: 'Contact',
    id: 'Contact'
}
, {
    xtype: 'textfield',
    fieldLabel: '电话',
    columnWidth: 1,
    anchor: '95%',
    name: 'Phone',
    id: 'Phone'
}
, {
    xtype: 'textfield',
    fieldLabel: 'QQ号',
    columnWidth: 1,
    anchor: '95%',
    name: 'Qq',
    id: 'Qq'
}
, {
    xtype: 'textfield',
    fieldLabel: 'MSN',
    columnWidth: 1,
    anchor: '95%',
    name: 'Msn',
    id: 'Msn'
}
, {
    xtype: 'combo',
    fieldLabel: '单位类型',
    name: 'CompType',
    id: 'CompType',
    width: 65,
    anchor: '95%',
    store: [['W1301', "装卸单位"], ['W1302', "运输单位"]],
    typeAhead: false,
    triggerAction: 'all',
    columnWidth: 1
}
, {
    xtype: 'textfield',
    fieldLabel: '备注',
    columnWidth: 1,
    anchor: '95%',
    name: 'Remark',
    id: 'Remark'
}
, {
    xtype: 'combo',
    fieldLabel: '状态',
    columnWidth: 1,
    anchor: '95%',
    name: 'Status',
    id: 'Status',
    transform: 'comboStatus',
    typeAhead: false,
    triggerAction: 'all',
    lazyRender: true,
    editable: false
}
]
            });
            /*------FormPanle的函数结束 End---------------*/

            /*------开始界面数据的窗体 Start---------------*/
            if (typeof (uploadCompanyWindow) == "undefined") {//解决创建2个windows问题
                uploadCompanyWindow = new Ext.Window({
                    id: 'Companyformwindow'
                    //title:formTitle
		        , iconCls: 'upload-win'
		        , width: 520
		        , height: 320
		        , layout: 'fit'
		        , plain: true
		        , modal: true
		        , x: 50
		        , y: 50
		        , constrain: true
		        , resizable: false
		        , closeAction: 'hide'
		        , autoDestroy: true
		        , items: formData
		        , buttons: [{
		    text: "保存"
			, handler: function() {
			    //saveUserData();
			    getFormValue();
			    uploadCompanyWindow.hide();
			    updateDataGrid();
			}
			, scope: this
		},
		{
		    text: "取消"
			, handler: function() {
			    uploadCompanyWindow.hide();
			}
			, scope: this
}]
                });
            }
            uploadCompanyWindow.addListener("hide", function() {
            });

            /*------开始获取界面数据的函数 start---------------*/
            function getFormValue() {
                Ext.Ajax.request({
                    url: 'frmWmsLoadCompany.aspx?method=saveCompanyInfoAction',
                    method: 'POST',
                    params: {
                        Id: Ext.getCmp('Id').getValue(),
                        Name: Ext.getCmp('Name').getValue(),
                        Address: Ext.getCmp('Address').getValue(),
                        Contact: Ext.getCmp('Contact').getValue(),
                        Phone: Ext.getCmp('Phone').getValue(),
                        Qq: Ext.getCmp('Qq').getValue(),
                        CompType: Ext.getCmp('CompType').getValue(),
                        Msn: Ext.getCmp('Msn').getValue(),
                        Remark: Ext.getCmp('Remark').getValue(),
                        Status: Ext.getCmp('Status').getValue()
                    },
                    success: function(resp, opts) {
                        Ext.Msg.alert("提示", "保存成功！");
                    },
                    failure: function(resp, opts) {
                        Ext.Msg.alert("提示", "保存失败！");
                    }
                });
            }
            /*------结束获取界面数据的函数 End---------------*/

            /*------开始界面数据的函数 Start---------------*/
            function setFormValue(selectData) {
                Ext.Ajax.request({
                    url: 'frmWmsLoadCompany.aspx?method=getCompanyInfoAction',
                    params: {
                        Id: selectData.data.Id
                    },
                    success: function(resp, opts) {
                        var data = Ext.util.JSON.decode(resp.responseText);
                        Ext.getCmp("Id").setValue(data.Id);
                        Ext.getCmp("Name").setValue(data.Name);
                        Ext.getCmp("Address").setValue(data.Address);
                        Ext.getCmp("Contact").setValue(data.Contact);
                        Ext.getCmp("Phone").setValue(data.Phone);
                        Ext.getCmp("Qq").setValue(data.Qq);
                        Ext.getCmp("CompType").setValue(data.CompType);
                        Ext.getCmp("Msn").setValue(data.Msn);
                        Ext.getCmp("Remark").setValue(data.Remark);
                        Ext.getCmp("Status").setValue(data.Status);
                    },
                    failure: function(resp, opts) {
                        Ext.Msg.alert("提示", "获取装卸公司信息失败！");
                    }
                });
            }
            /*------结束设置界面数据的函数 End---------------*/
            /*------开始查询form的函数 start---------------*/

            var NamePanel = new Ext.form.TextField({
                style: 'margin-left:0px',
                cls: 'key',
                xtype: 'textfield',
                fieldLabel: '单位名称',
                anchor: '95%',
                listeners: { specialkey: function(f, e) { if (e.getKey() == e.ENTER) { Ext.getCmp('SPhone').focus(); } } }

            });


            var PhonePanel = new Ext.form.TextField({
                style: 'margin-left:0px',
                cls: 'key',
                xtype: 'textfield',
                fieldLabel: '电话',
                anchor: '95%',
                id: 'SPhone',
                listeners: { specialkey: function(f, e) { if (e.getKey() == e.ENTER) { Ext.getCmp('SAddress').focus(); } } }
            });
            var AddressPanel = new Ext.form.TextField({
                style: 'margin-left:0px',
                cls: 'key',
                xtype: 'textfield',
                fieldLabel: '地址',
                anchor: '95%',
                id: 'SAddress',
                listeners: { specialkey: function(f, e) { if (e.getKey() == e.ENTER) { CompanyTypePanel.focus(); } } }
            });
            
            var CompanyTypePanel = new Ext.form.ComboBox({
                fieldLabel: '单位类型',
                name: 'CompanyType',
                id: 'CompanyType',
                width: 65,
                anchor: '95%',
                //transform: 'comboStatus',
                store: [['W1301', "装卸单位"], ['W1302', "运输单位"]],
                typeAhead: false,
                triggerAction: 'all',
                lazyRender: true,
                editable: false,
                listeners: { specialkey: function(f, e) { if (e.getKey() == e.ENTER) { Ext.getCmp('searchebtnId').focus(); } }
                }
            });
            CompanyTypePanel.setValue('W1301');

            var StatusPanel = new Ext.form.ComboBox({
                fieldLabel: '状态',
                name: 'Status1',
                id: 'Status1',
                width: 65,
                anchor: '95%',
                //transform: 'comboStatus',
                store: [[0, "启用"], [1, "禁用"]],
                typeAhead: false,
                triggerAction: 'all',
                lazyRender: true,
                editable: false,
                listeners: { specialkey: function(f, e) { if (e.getKey() == e.ENTER) { Ext.getCmp('searchebtnId').focus(); } }

                }

            });
            StatusPanel.setValue(0);

            var divSearchForm = new Ext.FormPanel({
                renderTo: 'divSearchForm',
                labelAlign: 'left',
                buttonAlign: 'right',
                bodyStyle: 'padding:5px',
                frame: true,
                labelWidth: 70,
                items: [
                {
                    layout: 'column',   //定义该元素为布局为列布局方式
                    items: [
                    {
                        columnWidth: .25,  //该列占用的宽度，标识为20％
                        layout: 'form',
                        border: false,
                        items: [
                            NamePanel
                        ]
                    }, {
                        columnWidth: .25,
                        layout: 'form',
                        border: false,
                        items: [
                            PhonePanel
                        ]
                    }, {
                        columnWidth: .25,
                        layout: 'form',
                        border: false,
                        items: [
                            AddressPanel
                        ]
                    }]
                }, {
                    layout: 'column',   //定义该元素为布局为列布局方式
                    items: [{
                        columnWidth: .25,
                        layout: 'form',
                        border: false,
                        items: [
                            CompanyTypePanel
                        ]
                    }, {
                        columnWidth: .25,
                        layout: 'form',
                        border: false,
                        items: [
                        StatusPanel
                        ]
                    }, {
                        columnWidth: .1,
                        layout: 'form',
                        border: false,
                        items: [{ cls: 'key',
                            xtype: 'button',
                            text: '查询',
                            id: 'searchebtnId',
                            anchor: '90%',
                            handler: function() {
                                updateDataGrid();
                            }
                        }]
                    }]
                }]
            });


                        /*------开始查询form的函数 end---------------*/
                        /*------开始获取数据的函数 start---------------*/
                        var gridDataData = new Ext.data.Store
({
    url: 'frmWmsLoadCompany.aspx?method=getCompanyListAction',
    reader: new Ext.data.JsonReader({
        totalProperty: 'totalProperty',
        root: 'root'
    }, [
	{
	    name: 'Id'
	},
	{
	    name: 'Name'
	},
	{
	    name: 'Address'
	},
	{
	    name: 'Contact'
	},
	{
	    name: 'Phone'
	},
	{
	    name: 'Qq'
	},
	{
	    name: 'CompType'
	},,
	{
	    name: 'Msn'
	},
	{
	    name: 'Remark'
	},
	{
	    name: 'Status'
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
                        var gridData = new Ext.grid.GridPanel({
                            el: 'divGrid',
                            width: '100%',
                            height: '100%',
                            autoWidth: true,
                            autoHeight: true,
                            autoScroll: true,
                            layout: 'fit',
                            id: '',
                            store: gridDataData,
                            loadMask: { msg: '正在加载数据，请稍侯……' },
                            sm: sm,
                            cm: new Ext.grid.ColumnModel([
		sm,
		new Ext.grid.RowNumberer(), //自动行号
		{
		header: '标识',
		dataIndex: 'Id',
		id: 'Id',
		hidden: true,
		hideable: false
},
		{
		    header: '名称',
		    dataIndex: 'Name',
		    id: 'Name'
		},
		{
		    header: '地址',
		    dataIndex: 'Address',
		    id: 'Address'
		},
		{
		    header: '联系人',
		    dataIndex: 'Contact',
		    id: 'Contact'
		},
		{
		    header: '电话',
		    dataIndex: 'Phone',
		    id: 'Phone'
		},
		{
		    header: 'QQ号',
		    dataIndex: 'Qq',
		    id: 'Qq'
		},
		{
		    header: '单位类型',
		    dataIndex: 'CompType',
		    id: 'CompType',
		    renderer:function(val){
		        if (val == 'W1301') return '装卸单位'; if (val == 'W1302') return '运输单位'; 
		    }
		},
		{
		    header: 'MSN',
		    dataIndex: 'Msn',
		    id: 'Msn'
		},
		{
		    header: '备注',
		    dataIndex: 'Remark',
		    id: 'Remark'
		},
		{
		    header: '状态',
		    dataIndex: 'Status',
		    id: 'Status',
		    renderer: function(val) { if (val == 0) return '启用'; if (val == 1) return '禁用'; }
}]),
                            bbar: new Ext.PagingToolbar({
                                pageSize: 10,
                                store: gridDataData,
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
                        gridData.render();
                        /*------DataGrid的函数结束 End---------------*/

                        updateDataGrid();

                    })
</script>

</html>
