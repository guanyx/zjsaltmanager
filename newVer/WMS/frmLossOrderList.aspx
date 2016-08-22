<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmLossOrderList.aspx.cs" Inherits="WMS_frmLossOrderList" %>

<html>
<head>
<title>损溢单列表页面</title><meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<link rel="stylesheet" type="text/css" href="../ext3/resources/css/ext-all.css" />
<script type="text/javascript" src="../ext3/adapter/ext/ext-base.js"></script>
<script type="text/javascript" src="../ext3/ext-all.js"></script>
<script type="text/javascript" src="../ext3/src/locale/ext-lang-zh_CN.js"></script>
<script type="text/javascript" src="../js/operateResp.js"></script>
<style  type="text/css">
.x-date-menu {
   width: 175;
}
</style>
</head>
<body>
<div id='toolbar'></div>
<div id='divSearchForm'></div>
<div id='divForm'></div>
<div id='divOrderGrid'></div>

</body>
<%=getComboBoxStore()%>
<script type="text/javascript">
	function getParamerValue( name )
	{
  	name = name.replace(/[\[]/,"\\\[").replace(/[\]]/,"\\\]");
  	var regexS = "[\\?&]"+name+"=([^&#]*)";
  	var regex = new RegExp( regexS );
  	var results = regex.exec( window.location.href );
  	if( results == null )
   	 return "";
  	else
   	 return results[1];
}
var toolbarStatus = getParamerValue("role");
    var bType = getParamerValue("billtype"); //0 - 升溢  1 - 损耗
    //alert(parseInt(bType));
    var bName = "升溢";
    if (parseInt(bType) == 1) {
        bName = "损耗";
    }
    var BillType = (parseInt(bType) == 1) ? "W0214" : "W0208";
    //alert(BillType+'--'+parent.BillType);
    
    
    window.document.title = bName +"单列表页";
    Ext.BLANK_IMAGE_URL = "../ext3/resources/images/default/s.gif";
    Ext.onReady(function() {
        /*------实现toolbar的函数 start---------------*/
        var windowTitle = "";
        var Toolbar = new Ext.Toolbar({
            renderTo: "toolbar",
            items: [{
                text: "新增",
                icon: "../theme/1/images/extjs/customer/add16.gif",
                handler: function() { AddOrderWin(); }
            }, '-', {
                text: "编辑",
                icon: "../theme/1/images/extjs/customer/edit16.gif",
                handler: function() { EditOrderWin(); }
            }, '-', {
                text: "删除",
                icon: "../theme/1/images/extjs/customer/delete16.gif",
                handler: function() { deleteOrderWin(); }
            }, '-', {
                text: "查看",
                icon: "../theme/1/images/extjs/customer/view16.gif",
                handler: function() { LookOrderWin(); }
            }, '-', {
                text: "送配送中心",
                icon: "../theme/1/images/extjs/customer/edit16.gif",
                handler: function() { sendCenter(); }
            }, '-', {
                text: "送领导",
                icon: "../theme/1/images/extjs/customer/edit16.gif",
                handler: function() { sendLeader(); }
            }, '-', {
                text: "领导确认",
                icon: "../theme/1/images/extjs/customer/edit16.gif",
                handler: function() { commitLossOrderWin(); }
            }, '-', {
                text: "退回",
                icon: "../theme/1/images/extjs/customer/rollback.gif",
                handler: function() { rollbackLossOrderWin(); }
            }, '-', {
                xtype: 'splitbutton',
                text: "打印",
                icon: "../Theme/1/images/extjs/customer/edit16.gif",
                menu:createPrintMenu()
}]
            });
            
            function createPrintMenu()
        {
	        var menu = new Ext.menu.Menu({
                id: 'exportMenu',
                style: {
                    overflow: 'visible'
               },
               items: [
	        {
                   text: '含税金额打印',
                   handler: function(){
                     printOrderById(printStyleXml);
                   }
                },
	        {
                   text: '除税金额打印',
                   handler: function(){
                    printOrderById(printNoTaxStyleXml);
                   }
                }]});
	        return menu;
        }

            //设置Toolbar条隐藏
            function setToolbarHidden(index) {
                Toolbar.items.items[index].setVisible(false);
                Toolbar.items.removeAt(index);
                index--;
                if (index > 0) {
                    Toolbar.items.items[index].setVisible(false);
                    Toolbar.items.removeAt(index);
                }
            }

            function defaultToolbarFun() {
                setToolbarHidden(14); //隐藏回退
                setToolbarHidden(12); //隐藏确认提交
                setToolbarHidden(10); //隐藏送领导                
            }

            function centerToolbarFun() {
                setToolbarHidden(12); //隐藏确认提交
                setToolbarHidden(8); //隐藏送配送中心
                setToolbarHidden(4);
                setToolbarHidden(2);
                setToolbarHidden(0);
            }
            function leaderToolbarFun() {
                setToolbarHidden(10); //隐藏送领导
                setToolbarHidden(8); //隐藏送配送中心
                setToolbarHidden(4);
                setToolbarHidden(2);
                setToolbarHidden(0);
            }
            switch (toolbarStatus) {
                case "center":
                    centerToolbarFun();
                    break;
                case "leader":
                    leaderToolbarFun();
                    break;
                default:
                    defaultToolbarFun();
                    break;
            }

            /*------结束toolbar的函数 end---------------*/
            function getUrl(imageUrl) {
                var index = window.location.href.toLowerCase().indexOf('/wms/');
                var tempUrl = window.location.href.substring(0, index);
                return tempUrl + "/" + imageUrl;
            }
            function printOrderById(xmlUrl) {
                var sm = userGrid.getSelectionModel();
                //多选
                var selectData = sm.getSelections();
                var array = new Array(selectData.length);
                var orderIds = "";
                for (var i = 0; i < selectData.length; i++) {
                    if (orderIds.length > 0)
                        orderIds += ",";
                    orderIds += selectData[i].get('OrderId');
                }
                //页面提交
                Ext.Ajax.request({
                    url: 'frmLossOrderList.aspx?method=printdate',
                    method: 'POST',
                    params: {
                        OrderId: orderIds
                    },
                    success: function(resp, opts) {
                        var printData = resp.responseText;
                        var printControl = parent.parent.parent.document.getElementById("topFrame").contentWindow.getPrintControl();
                        printControl.Url = getUrl('xml');
                        printControl.MapUrl = printControl.Url + '/' + xmlUrl; //'/salePrint1.xml';
                        printControl.PrintXml = printData;
                        printControl.ColumnName = "OrderId";
                        printControl.OnlyData = printOnlyData;
                        printControl.PageWidth = printPageWidth;
                        printControl.PageHeight = printPageHeight;
                        printControl.Print();

                    },
                    failure: function(resp, opts) {  /* Ext.Msg.alert("提示","保存失败"); */ }
                });
            }
            /*------开始ToolBar事件函数 start---------------*//*-----新增Order实体类窗体函数----*/
            function updateDataGrid() {
                var WhId = WhNamePanel.getValue();
                var StartDate = Ext.util.Format.date(StartDatePanel.getValue(),'Y/m/d');
                var EndDate = Ext.util.Format.date(EndDatePanel.getValue(),'Y/m/d');
                var Status = StatusPanel.getValue();


                userGridData.baseParams.WhId = WhId;
                userGridData.baseParams.StartDate = StartDate;
                userGridData.baseParams.EndDate = EndDate;
                userGridData.baseParams.Status = Status;
                userGridData.baseParams.BillType = BillType;
                userGridData.load({
                    params: {
                        start: 0,
                        limit: 10
                    }
                });

            }

            function AddOrderWin() {
                uploadLossOrderWindow.show();
                uploadLossOrderWindow.setTitle("新增" + bName + "单");
                document.getElementById("editLossOrderIFrame").src = "frmLossOrderEdit.aspx?id=0";
                //                if (document.getElementById("editLossOrderIFrame").src.indexOf("frmLossOrderEdit") == -1) {
                //                    document.getElementById("editLossOrderIFrame").src = "frmLossOrderEdit.aspx?id=0";
                //                }
                //                else {
                //                    document.getElementById("editLossOrderIFrame").contentWindow.OrderId = 0;
                //                    document.getElementById("editLossOrderIFrame").contentWindow.UIStatus = "add";
                //                    document.getElementById("editLossOrderIFrame").contentWindow.setAllValue();
                //                }
            }

            function EditOrderWin() {
                var sm = userGrid.getSelectionModel();
                //获取选择的数据信息
                var selectData = sm.getSelected();
                if (selectData == null) {
                    Ext.Msg.alert("提示", "请选择" + bName + "单记录！");
                    return;
                }
                if (selectData.data.Status != 0)//不是未入仓状态
                {
                    Ext.Msg.alert("提示", "该" + bName + "单已提交，不能再编辑！");
                    return;
                }
                uploadLossOrderWindow.show();
                uploadLossOrderWindow.setTitle("编辑" + bName + "单");
                document.getElementById("editLossOrderIFrame").src = "frmLossOrderEdit.aspx?id=" + selectData.data.OrderId;
                //                if (document.getElementById("editLossOrderIFrame").src.indexOf("frmLossOrderEdit") == -1) {
                //                    document.getElementById("editLossOrderIFrame").src = "frmLossOrderEdit.aspx?id=" + selectData.data.OrderId;
                //                }
                //                else {
                //                    document.getElementById("editLossOrderIFrame").contentWindow.OrderId = selectData.data.OrderId;
                //                    document.getElementById("editLossOrderIFrame").contentWindow.UIStatus = "edit";
                //                    document.getElementById("editLossOrderIFrame").contentWindow.setAllValue();
                //                }
            }

            function LookOrderWin() {
                var sm = userGrid.getSelectionModel();
                //获取选择的数据信息
                var selectData = sm.getSelected();
                if (selectData == null) {
                    Ext.Msg.alert("提示", "请选择" + bName + "单记录！");
                    return;
                }

                uploadLossOrderWindow.show();
                uploadLossOrderWindow.setTitle("查看" + bName + "单");
                document.getElementById("editLossOrderIFrame").src = "frmLossOrderEdit.aspx?id=" + selectData.data.OrderId + "&status=look";
                //                if (document.getElementById("editLossOrderIFrame").src.indexOf("frmLossOrderEdit") == -1) {
                //                    document.getElementById("editLossOrderIFrame").src = "frmLossOrderEdit.aspx?id=" + selectData.data.OrderId + "&status=look";
                //                }
                //                else {
                //                    document.getElementById("editLossOrderIFrame").contentWindow.OrderId = selectData.data.OrderId;
                //                    document.getElementById("editLossOrderIFrame").contentWindow.UIStatus = "look";
                //                    document.getElementById("editLossOrderIFrame").contentWindow.setAllValue();
                //                }
            }

            function deleteOrderWin() {
                var sm = userGrid.getSelectionModel();
                //获取选择的数据信息
                var selectData = sm.getSelected();
                //如果没有选择，就提示需要选择数据信息
                if (selectData == null) {
                    Ext.Msg.alert("提示", "请选中需要删除的信息！");
                    return;
                }
                if (selectData.data.Status != 0)//不是未入仓状态
                {
                    Ext.Msg.alert("提示", "已提交的" + bName + "单不能删除！");
                    return;
                }
                //删除前再次提醒是否真的要删除
                Ext.Msg.confirm("提示信息", "是否真的要删除选择的" + bName + "单吗？", function callBack(id) {
                    //判断是否删除数据
                    if (id == "yes") {
                        //页面提交
                        Ext.Ajax.request({
                            url: 'frmLossOrderList.aspx?method=deleteLossOrder',
                            method: 'POST',
                            params: {
                                OrderId: selectData.data.OrderId
                            },
                            success: function(resp, opts) {
                                Ext.Msg.alert("提示", "数据删除成功！");
                                updateDataGrid(); //刷新页面
                            },
                            failure: function(resp, opts) {
                                Ext.Msg.alert("提示", "数据删除失败！");
                            }
                        });
                    }
                });
            }
            //送配送中心
            function sendCenter() {
                var sm = userGrid.getSelectionModel();
                //获取选择的数据信息
                var selectData = sm.getSelected();
                if (selectData == null) {
                    Ext.Msg.alert("提示", "请选择" + bName + "单！");
                    return;
                }
                if (selectData.data.Status != 0)//只有草稿时才允许送配送中心
                {
                    Ext.Msg.alert("提示", "已提交，不需再次提交！");
                    return;
                }

                Ext.Msg.confirm("提示信息", "是否真的要提交选择的" + bName + "单吗？", function callBack(id) {
                    if (id == "yes") {
                        //页面提交
                        Ext.Ajax.request({
                            url: 'frmLossOrderList.aspx?method=sendCenter',
                            method: 'POST',
                            params: {
                                OrderId: selectData.data.OrderId
                            },
                            success: function(resp, opts) {
                                Ext.Msg.alert("提示", "" + bName + "单数据提交成功！");
                                updateDataGrid(); //刷新页面
                            },
                            failure: function(resp, opts) {
                                Ext.Msg.alert("提示", "" + bName + "单数据提交失败！");
                            }
                        });
                    }
                });
            }
            //送领导
            function sendLeader() {
                var sm = userGrid.getSelectionModel();
                //获取选择的数据信息
                var selectData = sm.getSelected();
                if (selectData == null) {
                    Ext.Msg.alert("提示", "请选择" + bName + "单！");
                    return;
                }
                if (selectData.data.Status != 1)//只有上级确认时才允许送领导确认
                {
                    Ext.Msg.alert("提示", "上级确认时,才能提交！");
                    return;
                }

                Ext.Msg.confirm("提示信息", "是否真的要提交选择的" + bName + "单吗？", function callBack(id) {
                    if (id == "yes") {
                        //页面提交
                        Ext.Ajax.request({
                            url: 'frmLossOrderList.aspx?method=sendLeader',
                            method: 'POST',
                            params: {
                                OrderId: selectData.data.OrderId
                            },
                            success: function(resp, opts) {
                                if( checkExtMessage(resp) ){
                                    //Ext.Msg.alert("提示", "" + bName + "单数据提交成功！");
                                    updateDataGrid(); //刷新页面
                                }
                            },
                            failure: function(resp, opts) {
                                Ext.Msg.alert("提示", "" + bName + "单数据提交失败！");
                            }
                        });
                    }
                });
            }
            //提交"+bName+"单
            function commitLossOrderWin() {
                var sm = userGrid.getSelectionModel();
                //获取选择的数据信息
                var selectData = sm.getSelected();
                if (selectData == null) {
                    Ext.Msg.alert("提示", "请选择" + bName + "单！");
                    return;
                }
                if (selectData.data.Status != 2)//已提交
                {
                    Ext.Msg.alert("提示", "领导确认时,才能提交！");
                    return;
                }

                Ext.Msg.confirm("提示信息", "是否真的要提交选择的" + bName + "单吗？", function callBack(id) {
                    if (id == "yes") {
                        //页面提交
                        Ext.Ajax.request({
                            url: 'frmLossOrderList.aspx?method=commitLossOrder',
                            method: 'POST',
                            params: {
                                OrderId: selectData.data.OrderId
                            },
                            success: function(resp, opts) {
                                if(checkExtMessage(resp))
                                {
                                    //Ext.Msg.alert("提示", "" + bName + "单数据提交成功！");
                                    updateDataGrid(); //刷新页面
                                }                                
                            },
                            failure: function(resp, opts) {
                                Ext.Msg.alert("提示", "" + bName + "单数据提交失败！");
                            }
                        });
                    }
                });
            }
            //回退"+bName+"单
            function rollbackLossOrderWin() {
                var sm = userGrid.getSelectionModel();
                //获取选择的数据信息
                var selectData = sm.getSelected();
                if (selectData == null) {
                    Ext.Msg.alert("提示", "请选择" + bName + "单！");
                    return;
                }
                if (selectData.data.Status == 3)//已提交
                {
                    Ext.Msg.alert("提示", "已经确认记录,不能退回！");
                    return;
                }
                Ext.Msg.confirm("提示信息", "是否真的要退回选择的" + bName + "单吗？", function callBack(id) {
                    if (id == "yes") {
                        //页面提交
                        Ext.Ajax.request({
                            url: 'frmLossOrderList.aspx?method=rollbackLossOrder',
                            method: 'POST',
                            params: {
                                OrderId: selectData.data.OrderId
                            },
                            success: function(resp, opts) {
                                if(checkExtMessage(resp))
                                {
                                    Ext.Msg.alert("提示", "" + bName + "单数据退回成功！");
                                    updateDataGrid(); //刷新页面
                                }
                            },
                            failure: function(resp, opts) {
                                Ext.Msg.alert("提示", "" + bName + "单数据退回失败！");
                            }
                        });
                    }
                });
            }

            /*------开始界面数据的窗体 Start---------------*/
            if (typeof (uploadLossOrderWindow) == "undefined") {//解决创建2个windows问题
                uploadLossOrderWindow = new Ext.Window({
                    id: 'LossOrderWindow'
		            , iconCls: 'upload-win'
		            , width: 750
		            , height: 490
		            , layout: 'fit'
		            , plain: true
		            , modal: true
		            , constrain: true
		            , resizable: false
		            , closeAction: 'hide'
		            , autoDestroy: true
		            , html: '<iframe id="editLossOrderIFrame" width="100%" height="100%" border=0 src="#"></iframe>'

                });
            }
            uploadLossOrderWindow.addListener("hide", function() {
                updateDataGrid();
            });


            /*------开始查询form的函数 start---------------*/

            var WhNamePanel = new Ext.form.ComboBox({
                name: 'WarehouseCombo',
                store: dsWarehouseList,
                displayField: 'WhName',
                valueField: 'WhId',
                typeAhead: true, //自动将第一个搜索到的选项补全输入
                triggerAction: 'all',
                emptyText: '请选择仓库',
                selectOnFocus: true,
                forceSelection: true,
                mode: 'local',
                fieldLabel: '仓库',
                anchor: '90%',
                id: 'WhName',
                listeners: { specialkey: function(f, e) { if (e.getKey() == e.ENTER) { Ext.getCmp('Type').focus(); } } }

            });
            var TypePanel = new Ext.form.ComboBox({
                name: 'LossTypeCombo',
                store: dsLossTypeList,
                displayField: 'DicsName',
                valueField: 'DicsCode',
                typeAhead: true, //自动将第一个搜索到的选项补全输入
                triggerAction: 'all',
                emptyText: '请选择' + bName + '类型',
                selectOnFocus: true,
                forceSelection: true,
                mode: 'local',
                fieldLabel: bName + '类型',
                anchor: '90%',
                id: 'Type',
                listeners: { specialkey: function(f, e) { if (e.getKey() == e.ENTER) { Ext.getCmp('BillStatus').focus(); } } }

            });
            var StatusPanel = new Ext.form.ComboBox({
                name: 'billStatusCombo',
                store: dsBillStatus,
                displayField: 'BillStatusName',
                valueField: 'BillStatusId',
                typeAhead: true, //自动将第一个搜索到的选项补全输入
                triggerAction: 'all',
                value: 0, //未入仓
                selectOnFocus: true,
                forceSelection: true,
                editable: false,
                mode: 'local',
                fieldLabel: '单据状态',
                value: (toolbarStatus == 'center') ? 1 : ((toolbarStatus == 'leader') ? 2 : 0),
                anchor: '90%',
                id: 'BillStatus',
                listeners: { specialkey: function(f, e) { if (e.getKey() == e.ENTER) { Ext.getCmp('StartDate').focus(); } } }
            });
            var StartDatePanel = new Ext.form.DateField({
                //style: 'margin-left:0px',
                //cls: 'key',
                xtype: 'datefield',
                fieldLabel: '开始时间',
                format: 'Y年m月d日',
                anchor: '90%',
                value: new Date().getFirstDateOfMonth().clearTime(),
                id: 'StartDate',
                listeners: { specialkey: function(f, e) { if (e.getKey() == e.ENTER) { Ext.getCmp('EndDate').focus(); } } }
            });
            var EndDatePanel = new Ext.form.DateField({
                //style: 'margin-left:0px',
                //cls: 'key',
                xtype: 'datefield',
                fieldLabel: '结束时间',
                anchor: '90%',
                format: 'Y年m月d日',
                id: 'EndDate',
                value: new Date().clearTime(),
                listeners: { specialkey: function(f, e) { if (e.getKey() == e.ENTER) { Ext.getCmp('searchebtnId').focus(); } } }
            });
            var serchform = new Ext.FormPanel({
                renderTo: 'divSearchForm',
                labelAlign: 'left',
                //layout: 'fit',
                buttonAlign: 'right',
                bodyStyle: 'padding:5px',
                frame: true,
                labelWidth: 55,
                items: [{
                    layout: 'column',   //定义该元素为布局为列布局方式
                    border: false,
                    items: [{
                        columnWidth: .3,
                        layout: 'form',
                        border: false,
                        items: [
                        WhNamePanel
                        ]
                    }, {
                        columnWidth: .3,
                        layout: 'form',
                        border: false,
                        items: [
                        StatusPanel
                        ]
                    }, {
                        columnWidth: .3,
                        layout: 'form',
                        border: false,
                        items: [
                        TypePanel
                        ]
                    }
                    ]
                }
                    ,
                    {

                        layout: 'column',   //定义该元素为布局为列布局方式
                        border: false,
                        items: [{
                            columnWidth: .3,  //该列占用的宽度，标识为20％
                            layout: 'form',
                            border: false,
                            items: [
                        StartDatePanel
                    ]
                        }, {
                            columnWidth: .3,
                            layout: 'form',
                            border: false,
                            items: [
                        EndDatePanel
                        ]
                        }, {
                            columnWidth: .2,
                            layout: 'form',
                            border: false,
                            items: [{ cls: 'key',
                                xtype: 'button',
                                text: '查询',
                                id: 'searchebtnId',
                                anchor: '50%',
                                handler: function() {
                                    updateDataGrid();
                                }
}]
}]
}]
            });


            /*------开始查询form的函数 end---------------*/

            /*------开始获取数据的函数 start---------------*/
            var userGridData = new Ext.data.Store
({
    url: 'frmLossOrderList.aspx?method=getLossOrderList',
    reader: new Ext.data.JsonReader({
        totalProperty: 'totalProperty',
        root: 'root'
    }, [
	{
	    name: 'OrderId'
	},
	{
	    name: 'WhId'
	},
	{
	    name: 'OrgId'
	},
	{
	    name: 'OwnerId'
	},
	{
	    name: 'OperId'
	},
	{
	    name: 'CreateDate'
	},
	{
	    name: 'UpdateDate'
	},
	{
	    name: 'Status'
	},
	{
	    name: 'Type'
	},
	{
	    name: 'OriginBillId'
	},
	{
	    name: 'Remark'
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

            /*------开始DataGrid的函数 start---------------*/

            var sm = new Ext.grid.CheckboxSelectionModel({
                singleSelect: true
            });
            var userGrid = new Ext.grid.GridPanel({
                el: 'divOrderGrid',
                width: '100%',
                height: '100%',
                autoWidth: true,
                autoHeight: true,
                autoScroll: true,
                layout: 'fit',
                id: '',
                store: userGridData,
                loadMask: { msg: '正在加载数据，请稍侯……' },
                sm: sm,
                cm: new Ext.grid.ColumnModel([
		sm,
		new Ext.grid.RowNumberer(), //自动行号
		{
		header: bName+'单号',
		dataIndex: 'OrderId',
		id: 'OrderId'
},
		{
		    header: '仓库',
		    dataIndex: 'WhId',
		    id: 'WhId',
		    renderer: function(val, params, record) {
		        if (dsWarehouseList.getCount() == 0) {
		            dsWarehouseList.load();
		        }
		        dsWarehouseList.each(function(r) {
		            if (val == r.data['WhId']) {
		                val = r.data['WhName'];
		                return;
		            }
		        });
		        return val;
		    }
		},

		{
		    header: '操作者',
		    dataIndex: 'OperId',
		    id: 'OperId',
		    renderer: function(val, params, record) {
		        if (dsOperationList.getCount() == 0) {
		            dsOperationList.load();
		        }
		        dsOperationList.each(function(r) {
		            if (val == r.data['EmpId']) {
		                val = r.data['EmpName'];
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
            header: bName + '环节',
            dataIndex: 'Type',
            id: 'Type',
            renderer: function(val, params, record) {
                if (dsLossTypeList.getCount() == 0) {
                    dsLossTypeList.load();
                }
                dsLossTypeList.each(function(r) {
                    if (val == r.data['DicsCode']) {
                        val = r.data['DicsName'];
                        return;
                    }
                });
                return val;
            }
        },
        {
            header: '原始单据号',
            dataIndex: 'OriginBillId',
            id: 'OriginBillId'
        },
		{
		    header: '单据状态',
		    dataIndex: 'Status',
		    id: 'Status',
		    renderer: function(val, params, record) {
		        if (dsBillStatus.getCount() == 0) {
		            dsBillStatus.load();
		        }
		        dsBillStatus.each(function(r) {
		            if (val == r.data['BillStatusId']) {
		                val = r.data['BillStatusName'];
		                return;
		            }
		        });
		        return val;
		    }
		},

		{
		    header: '备注',
		    dataIndex: 'Remark',
		    id: 'Remark'
}]),
                bbar: new Ext.PagingToolbar({
                    pageSize: 10,
                    store: userGridData,
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
            
            userGrid.on('render', function(grid) {
                var store = grid.getStore();  // Capture the Store.  
                var view = grid.getView();    // Capture the GridView.
            userGrid.tip = new Ext.ToolTip({
                    target: view.mainBody,    // The overall target element.  
                    delegate: '.x-grid3-row', // Each grid row causes its own seperate show and hide.  
                    trackMouse: true,         // Moving within the row should not hide the tip.  
                    renderTo: document.body,  // Render immediately so that tip.body can be referenced prior to the first show.  
                    listeners: {              // Change content dynamically depending on which element triggered the show.  
                        beforeshow: function updateTipBody(tip) {
                            var rowIndex = view.findRowIndex(tip.triggerElement);
                            
                            var element = document.elementFromPoint(tip.x-20, tip.y-20);
                             var v = view.findCellIndex(element);
                             //细项信息
                              if(v==4||v==2||v==3)
                                {
                                    if(showTipRowIndex == rowIndex)
                                        return;
                                    else
                                        showTipRowIndex = rowIndex;
                                        
                                     tip.body.dom.innerHTML="正在加载数据……";
                                        //页面提交
                                        Ext.Ajax.request({
                                            url: 'frmLossOrderList.aspx?method=getdetailinfo',
                                            method: 'POST',
                                            params: {
                                                OrderId: grid.getStore().getAt(rowIndex).data.OrderId
                                            },
                                            success: function(resp, opts) {
                                                tip.body.dom.innerHTML = resp.responseText;
                                            },
                                            failure: function(resp, opts) {
                                                userGrid.tip.hide();
                                            }
                                        });
                                }                                
                                else
                                {
                                    userGrid.tip.hide();
                                }
                        }
                    }
                });
    });
    var showTipRowIndex =-1;
            userGrid.render();
            /*------DataGrid的函数结束 End---------------*/
            updateDataGrid();


        })
</script>

</html>
