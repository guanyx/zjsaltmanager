<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmPurchaseOrderList.aspx.cs" Inherits="WMS_frmPurchaseOrderList" %>

<html>
<head>
<title>采购单列表页面</title><meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
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
    Ext.BLANK_IMAGE_URL = "../ext3/resources/images/default/s.gif";
    Ext.onReady(function() {
        /*------实现toolbar的函数 start---------------*/
        var windowTitle = "";
        var Toolbar = new Ext.Toolbar({
            renderTo: "toolbar",
            items: [{
                text: "生成入仓单",
                icon: "../theme/1/images/extjs/customer/add16.gif",
                handler: function() { generateInStockOrderWin(); }
            }, '-', {
                text: "分割取消",
                icon: "../theme/1/images/extjs/customer/edit16.gif",
                handler: function() { cancelSplit(); }
            }, '-', {
                text: "查看采购单",
                icon: "../theme/1/images/extjs/customer/edit16.gif",
                handler: function() { lookOrderWin(); }
            }, '-', {
                text: "数量确认",
                icon: "../theme/1/images/extjs/customer/edit16.gif",
                handler: function() { confirmOrderWin(); }
            }, '-', {
                text: "价格确认",
                icon: "../theme/1/images/extjs/customer/edit16.gif",
                handler: function() { confirmPriceOrderWin(); }
            }, '-', {
                xtype: 'splitbutton',
                text: "打印",
                icon: "../Theme/1/images/extjs/customer/edit16.gif",
                menu:createPrintMenu()
            }, '-', {
                text: "金额调整",
                icon: "../theme/1/images/extjs/customer/edit16.gif",
                handler: function() { addPurchaseAdjustWin(); }
            }]
        });
        
        function createPrintMenu()
        {
	        var menu = new Ext.menu.Menu({
                id: 'printMenus',
                style: {
                    overflow: 'visible'
                },
                items: [
	            {
	               id:'mixedprint',
                   text: '单据打印',
                   handler: function(){
                     printOrderById(printStyleXmlV2);
                   }
                },
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
                },
	            {
                  text: '货物装卸单打印',
                  handler: printLoadrById
                },{
                   text: '货物运输出库单打印',
                   handler: printTransById
                }]});
            <%=setPrintPrivilege()%>
	        return menu;        }
        
        function printLoadrById()
        {
            var sm = userGrid.getSelectionModel();
                //多选
                var selectData = sm.getSelections();                
                var array = new Array(selectData.length);
                var orderIds = "";
                for(var i=0;i<selectData.length;i++)
                {
                    if(orderIds.length>0)
                        orderIds+=",";
                    orderIds += selectData[i].get('OrderId');
                }
                //页面提交
                Ext.Ajax.request({
                    url: 'frmPurchaseOrderList.aspx?method=getrateprintdata',
//                    url:'frmOrderMst.aspx?method=billdata',
                    method: 'POST',
                    params: {
                        OrderId: orderIds,
                        TypeName:'货物装卸操作'
                    },
                   success: function(resp,opts){ 
                       var printData =  resp.responseText;
                       var printControl =  parent.parent.parent.document.getElementById("topFrame").contentWindow.getPrintControl();
                       printControl.Url =getUrl('xml');
                       printControl.MapUrl = printControl.Url+'/'+printRateStyleXml;//'/salePrint1.xml';
                       printControl.PrintXml = printData;
                       printControl.ColumnName="OrderId";
                       printControl.OnlyData=printOnlyData;
                       printControl.PageWidth=printRatePageWidth;
                       printControl.PageHeight =printRatePageHeight ;
                       printControl.Print();
                       
                   },
		           failure: function(resp,opts){  
//		                Ext.Msg.alert("提示",resp);   
		            }
                });
}

function printTransById()
{
var sm = userGrid.getSelectionModel();
                //多选
                var selectData = sm.getSelections();                
                var array = new Array(selectData.length);
                var orderIds = "";
                for(var i=0;i<selectData.length;i++)
                {
                    if(orderIds.length>0)
                        orderIds+=",";
                    orderIds += selectData[i].get('OrderId');
                }
                //页面提交
                Ext.Ajax.request({
                    url: 'frmPurchaseOrderList.aspx?method=getrateprintdata',
//                    url:'frmOrderMst.aspx?method=billdata',
                    method: 'POST',
                    params: {
                        OrderId: orderIds,
                        TypeName:'货物运输入库'
                    },
                   success: function(resp,opts){ 
                       var printData =  resp.responseText;
                       var printControl =  parent.parent.parent.document.getElementById("topFrame").contentWindow.getPrintControl();
                       printControl.Url =getUrl('xml');
                       printControl.MapUrl = printControl.Url+'/'+printRateStyleXml;//'/salePrint1.xml';
                       printControl.PrintXml = printData;
                       printControl.ColumnName="OrderId";
                       printControl.OnlyData=printOnlyData;
                       printControl.PageWidth=printRatePageWidth;
                       printControl.PageHeight =printRatePageHeight ;
                       printControl.Print();
                       
                   },
		           failure: function(resp,opts){  
//		                Ext.Msg.alert("提示",resp);   
		             }
                });
}
        
        setToolBarVisible(Toolbar);
            /*------结束toolbar的函数 end---------------*/
        function getUrl(imageUrl)
            {
                var index = window.location.href.toLowerCase().indexOf('/wms/');
                var tempUrl = window.location.href.substring(0,index);
                return tempUrl+"/"+imageUrl;
            }
            function printOrderById(xmlUrl)
            {
                var sm = userGrid.getSelectionModel();
                //多选
                var selectData = sm.getSelections();                
                var array = new Array(selectData.length);
                var orderIds = "";
                for(var i=0;i<selectData.length;i++)
                {
                    if(orderIds.length>0)
                        orderIds+=",";
                    orderIds += selectData[i].get('OrderId');
                }
                //页面提交
                Ext.Ajax.request({
                    url: 'frmPurchaseOrderList.aspx?method=getprintdata',
//                    url:'frmOrderMst.aspx?method=billdata',
                    method: 'POST',
                    params: {
                        OrderId: orderIds
                    },
                   success: function(resp,opts){ 
                       var printData =  resp.responseText;
                       var printControl =  parent.parent.parent.document.getElementById("topFrame").contentWindow.getPrintControl();
                       printControl.Url =getUrl('xml');
                       printControl.MapUrl = printControl.Url+'/'+xmlUrl;//'/salePrint1.xml';
                       printControl.PrintXml = printData;
                       printControl.ColumnName="OrderId";
                       printControl.OnlyData=printOnlyData;
                       printControl.PageWidth=printPageWidth;
                       printControl.PageHeight =printPageHeight ;
                       printControl.Print();
//                    var billControl = document.getElementById('billControl');
//                    billControl.PrintXml = printData;
//                    billControl.setFormValue(0);
                       
                   },
		           failure: function(resp,opts){  /* Ext.Msg.alert("提示","保存失败"); */    }
                });
}
            /*------开始ToolBar事件函数 start---------------*//*-----新增Order实体类窗体函数----*/
            function updateDataGrid() {

                var WhId = WhNamePanel.getValue();
                var SupplierId = SupplierNamePanel.getValue();
                var StartDate = Ext.util.Format.date(StartDatePanel.getValue(),'Y/m/d');
                var EndDate = Ext.util.Format.date(EndDatePanel.getValue(),'Y/m/d');
                var BillStatus = BillStatusPanel.getValue();

                userGridData.baseParams.WhId = WhId;
                userGridData.baseParams.SupplierId = SupplierId;
                userGridData.baseParams.StartDate = StartDate;
                userGridData.baseParams.EndDate = EndDate;
                userGridData.baseParams.BillStatus = BillStatus;
                userGridData.baseParams.ReturnStatus = '';

                userGridData.load({
                    params: {
                        start: 0,
                        limit: 10
                    }
                });

            }
            //生成入库单
            function generateInStockOrderWin() {
                var sm = userGrid.getSelectionModel();
                //获取选择的数据信息
                var selectData = sm.getSelected();
                if (selectData == null) {
                    Ext.Msg.alert("提示", "请选择采购单记录！");
                    return;
                }
                if (selectData.data.BillStatus != 0)//不是未入仓状态
                {
                    Ext.Msg.alert("提示", "只有未入仓的采购单才能做入仓操作！");
                    return;
                }
                
                //提醒未确认
                if(selectData.data.ConfirmStatus==0){
                    Ext.Msg.confirm("提示信息", "该采购单未做数量确认，如果继续将默认发运数量是正确的，是否继续？", function callBack(id) {
                        if (id == "yes") {
                            uploadOrderWindow.show();
                            document.getElementById("editIFrame").src = "frmInStockBill.aspx?type=W0201&id=" + selectData.data.OrderId;
                        }
                    });
                }else{                
                    uploadOrderWindow.show();
                    document.getElementById("editIFrame").src = "frmInStockBill.aspx?type=W0201&id=" + selectData.data.OrderId;
                }
                //                if(document.getElementById("editIFrame").src.indexOf("frmInStockBill")==-1)
                //                {                
                //                    document.getElementById("editIFrame").src ="frmInStockBill.aspx?type=W0201&id=" + selectData.data.OrderId;
                //                }
                //                else{
                //                    document.getElementById("editIFrame").contentWindow.OrderId=selectData.data.OrderId;                    
                //                    document.getElementById("editIFrame").contentWindow.FromBillType='W0201';
                //                    document.getElementById("editIFrame").contentWindow.setAllKindValue();
                //                }
            }
            /*-----察看Order实体类窗体函数----*/
            function cancelSplit() {
                var sm = userGrid.getSelectionModel();
                //获取选择的数据信息
                var selectData = sm.getSelected();
                //如果没有选择，就提示需要选择数据信息
                if (selectData == null) {
                    Ext.Msg.alert("提示", "请选中需要取消的信息！");
                    return;
                }
                //删除前再次提醒是否真的要删除
                Ext.Msg.confirm("提示信息", "是否真的要取消选择的单据吗？", function callBack(id) {
                    //判断是否删除数据
                    if (id == "yes") {
                        //页面提交
                        Ext.Ajax.request({
                            url: 'frmPurchaseOrderList.aspx?method=cancelSplit',
                            method: 'POST',
                            params: {
                                OrderId: selectData.data.OrderId
                            },
                            success: function(resp, opts) {
                                if (checkExtMessage(resp)) {
                                    updateDataGrid(); //刷新页面
                                }
                            },
                            failure: function(resp, opts) {
                                Ext.Msg.alert("提示", "数据取消失败！");
                            }
                        });
                    }
                });
            }

            function lookOrderWin() {
                var status = "readonly";
                uploadPurchaseOrderWindow.setTitle("查看采购单详细信息");
                openOrderWin(status);
            }

            function confirmOrderWin() {
                var status = "confirm";
                uploadPurchaseOrderWindow.setTitle("确认采购单商品数量");
                openOrderWin(status);
            }
            function confirmPriceOrderWin() {
                var status = "confirmprice";
                uploadPurchaseOrderWindow.setTitle("确认采购单商品价格");
                openOrderWin(status);
            }
            function addPurchaseAdjustWin() {
                var status = "adjustAmt";
                uploadPurchaseOrderWindow.setTitle("调整采购单商品金额");
                openOrderWin(status);
            }

            function openOrderWin(status) {
                //alert(status);
                var sm = userGrid.getSelectionModel();
                var selectData = sm.getSelected();
                if (selectData == null) {
                    Ext.Msg.alert("提示", "请选中需要操作的采购单的信息！");
                    return;
                }
                if(status=='confirm'){
                    if(selectData.data.ConfirmStatus==1){
                        if (!confirm("已经做过数量确认，是否继续？")) 
                            return;                        
                    }
                }                
                uploadPurchaseOrderWindow.show();
                document.getElementById("editPurchaseIFrame").src = "frmPurchaseOrderEdit.aspx?status=" + status + "&id=" + selectData.data.OrderId;
                //                if (document.getElementById("editPurchaseIFrame").src.indexOf("frmPurchaseOrderEdit") == -1) {
                //                    document.getElementById("editPurchaseIFrame").src = "frmPurchaseOrderEdit.aspx?status=" + status + "&id=" + selectData.data.OrderId;
                //                }
                //                else {
                //                    document.getElementById("editPurchaseIFrame").contentWindow.OrderId = selectData.data.OrderId;

                //                    document.getElementById("editPurchaseIFrame").contentWindow.PageStatus = status;
                //                    document.getElementById("editPurchaseIFrame").contentWindow.setAllValue();
                //                }
            }
            /*------开始界面数据的窗体 Start---------------*/
            if (typeof (uploadOrderWindow) == "undefined") {//解决创建2个windows问题
                uploadOrderWindow = new Ext.Window({
                    id: 'Orderformwindow'
		            , iconCls: 'upload-win'
		            , width: 750
		            , height: 515
		            , layout: 'fit'
		            , plain: true
		            , modal: true
		            , constrain: true
		            , resizable: false
		            , closeAction: 'hide'
		            , autoDestroy: true
		            , html: '<iframe id="editIFrame" width="100%" height="100%" border=0 src="#"></iframe>'

                });
            }
            uploadOrderWindow.addListener("hide", function() {
                updateDataGrid();
            });

            if (typeof (uploadPurchaseOrderWindow) == "undefined") {//解决创建2个windows问题
                uploadPurchaseOrderWindow = new Ext.Window({
                    id: 'PurchaseOrderWindow'
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
		            , html: '<iframe id="editPurchaseIFrame" width="100%" height="100%" border=0 src="#"></iframe>'

                });
            }
            uploadPurchaseOrderWindow.addListener("hide", function() {
                updateDataGrid();
            });

            /*------开始获取界面数据的函数 start---------------*/
            function getFormValue() {
                var dateCreateDate = Ext.get("CreateDate").getValue();
                if (dateCreateDate != '')
                    dateCreateDate = Ext.util.Format.date(dateCreateDate,'Y/m/d');

                Ext.Ajax.request({
                    url: 'frmPurchaseOrderList.aspx?method=SaveOrder',
                    method: 'POST',
                    params: {
                        OrderId: Ext.getCmp('OrderId').getValue(),
                        SupplierId: Ext.getCmp('SupplierId').getValue(),
                        WhId: Ext.getCmp('WhId').getValue(),
                        OrgId: Ext.getCmp('OrgId').getValue(),
                        OwnerId: Ext.getCmp('OwnerId').getValue(),
                        OperId: Ext.getCmp('OperId').getValue(),
                        CreateDate: dateCreateDate,
                        UpdateDate: Ext.getCmp('UpdateDate').getValue(),
                        BillType: Ext.getCmp('BillType').getValue(),
                        FromBillId: Ext.getCmp('FromBillId').getValue(),
                        BillStatus: Ext.getCmp('BillStatus').getValue(),
                        Remark: Ext.getCmp('Remark').getValue()
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
                    url: 'frmPurchaseOrderList.aspx?method=getPurchaseOrder',
                    params: {
                        OrderId: selectData.data.OrderId
                    },
                    success: function(resp, opts) {
                        var data = Ext.util.JSON.decode(resp.responseText);
                        Ext.getCmp("OrderId").setValue(data.OrderId);
                        Ext.getCmp("SupplierId").setValue(data.SupplierId);
                        Ext.getCmp("WhId").setValue(data.WhId);
                        Ext.getCmp("OrgId").setValue(data.OrgId);
                        Ext.getCmp("OwnerId").setValue(data.OwnerId);
                        Ext.getCmp("OperId").setValue(data.OperId);
                        if (data.CreateDate != '')
                            Ext.getCmp("CreateDate").setValue(Ext.util.Format.date(data.CreateDate,'Y/m/d'));
                        Ext.getCmp("UpdateDate").setValue(data.UpdateDate);
                        Ext.getCmp("BillType").setValue(data.BillType);
                        Ext.getCmp("FromBillId").setValue(data.FromBillId);
                        Ext.getCmp("BillStatus").setValue(data.BillStatus);
                        Ext.getCmp("Remark").setValue(data.Remark);
                    },
                    failure: function(resp, opts) {
                        Ext.Msg.alert("提示", "获取进货信息失败！");
                    }
                });
            }
            /*------结束设置界面数据的函数 End---------------*/

            /*------开始查询form的函数 start---------------*/

            var SupplierNamePanel = new Ext.form.ComboBox({
                name: 'supplierCombo',
                store: dsSuppliesListInfo,
                displayField: 'ChineseName',
                valueField: 'CustomerId',
                typeAhead: false, //自动将第一个搜索到的选项补全输入
                triggerAction: 'all',
                emptyText: '请选择供应商',
                selectOnFocus: true,
                forceSelection: false,
                mode: 'local',
                fieldLabel: '供应商',
                anchor: '90%',
                listeners: { specialkey: function(f, e) { if (e.getKey() == e.ENTER) { Ext.getCmp('SWhName').focus(); } } }

            });
            SupplierNamePanel.on('beforequery',function(qe){  
                regexValue(qe);
            }); 

            var WhNamePanel = new Ext.form.ComboBox({
                name: 'warehouseCombo',
                store: dsWarehouseList,
                displayField: 'WhName',
                valueField: 'WhId',
                typeAhead: true, //自动将第一个搜索到的选项补全输入
                triggerAction: 'all',
                emptyText: '请选择仓库',
                selectOnFocus: true,
                forceSelection: true,
                mode: 'local',
                fieldLabel: '仓库名称',
                anchor: '90%',
                id: 'SWhName',
                listeners: { specialkey: function(f, e) { if (e.getKey() == e.ENTER) { Ext.getCmp('BillStatus').focus(); } } }
            });

            var BillStatusPanel = new Ext.form.ComboBox({
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
                anchor: '90%',
                id: 'BillStatus',
                listeners: { specialkey: function(f, e) { if (e.getKey() == e.ENTER) { Ext.getCmp('StartDate').focus(); } } }
            });
            var StartDatePanel = new Ext.form.DateField({
                style: 'margin-left:0px',
                cls: 'key',
                xtype: 'datefield',
                fieldLabel: '开始时间',
                format: 'Y年m月d日',
                anchor: '90%',
                value: new Date().getFirstDateOfMonth().clearTime(),
                id: 'StartDate',
                listeners: { specialkey: function(f, e) { if (e.getKey() == e.ENTER) { Ext.getCmp('EndDate').focus(); } } }
            });
            var EndDatePanel = new Ext.form.DateField({
                style: 'margin-left:0px',
                cls: 'key',
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
                        columnWidth: .3,  //该列占用的宽度，标识为20％
                        layout: 'form',
                        border: false,
                        items: [
                        SupplierNamePanel
                    ]
                    }, {
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
                        BillStatusPanel
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

function regexValue(qe){
    var combo = qe.combo;  
    //q is the text that user inputed.  
    var q = qe.query;  
    forceAll = qe.forceAll;  
    if(forceAll === true || (q.length >= combo.minChars)){  
     if(combo.lastQuery !== q){  
         combo.lastQuery = q;  
         if(combo.mode == 'local'){  
             combo.selectedIndex = -1;  
             if(forceAll){  
                 combo.store.clearFilter();  
             }else{  
                 combo.store.filterBy(function(record,id){  
                     var text = record.get(combo.displayField);  
                     //在这里写自己的过滤代码  
                     return (text.indexOf(q)!=-1);  
                 });  
             }  
             combo.onLoad();  
         }else{  
             combo.store.baseParams[combo.queryParam] = q;  
             combo.store.load({  
                 params: combo.getParams(q)  
             });  
             combo.expand();  
         }  
     }else{  
         combo.selectedIndex = -1;  
         combo.onLoad();  
     }  
    }  
    return false;  
}
            /*------开始查询form的函数 end---------------*/

            /*------开始获取数据的函数 start---------------*/
            var userGridData = new Ext.data.Store
({
    url: 'frmPurchaseOrderList.aspx?method=getPurchaseOrderList',
    reader: new Ext.data.JsonReader({
        totalProperty: 'totalProperty',
        root: 'root'
    }, [
	{
	    name: 'OrderId'
	},
	{
	    name: 'SupplierId'
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
	    name: 'BillType'
	},
	{
	    name: 'FromBillId'
	},
	{
	    name: 'BillStatus'
	},
	{
	    name: 'ConfirmStatus'
	},
	{
	    name: 'CarBoatNo'
	},
	{
	    name: 'Remark'
	},
	{
	    name: 'SupplierName'
	},
	{
	    name: 'OperName'
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
		    header: '订单号',
		    dataIndex: 'FromBillId',
		    id: 'FromBillId'
        },{
		    header: '分割单号',
		    dataIndex: 'OrderId',
		    id: 'OrderId'
        },
		{
		    header: '供应商',
		    dataIndex: 'SupplierName',
		    id: 'SupplierName'
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
                //		{
                //			header:'组织ID',
                //			dataIndex:'OrgId',
                //			id:'OrgId'
                //		},
		{
		header: '操作者',
		dataIndex: 'OperName',
		id: 'OperName'
},
		{
		    header: '创建时间',
		    dataIndex: 'CreateDate',
		    id: 'CreateDate',
		    format: 'Y年m月d日'
		},
                //		{
                //			header:'更新时间',
                //			dataIndex:'UpdateDate',
                //			id:'UpdateDate'
                //		},
		{
		header: '单据类型',
		dataIndex: 'BillType',
		id: 'BillType',
		renderer: function(val, params, record) {
		    if (dsBillType.getCount() == 0) {
		        dsBillType.load();
		    }
		    dsBillType.each(function(r) {
		        if (val == r.data['DicsCode']) {
		            val = r.data['DicsName'];
		            return;
		        }
		    });
		    return val;
		}
},
                //		{
                //		    header: '来源单据号',
                //		    dataIndex: 'FromBillId',
                //		    id: 'FromBillId'
                //		},
		{
		header: '单据状态',
		dataIndex: 'BillStatus',
		id: 'BillStatus',
		renderer: function(val, params, record) {
		    if (dsBillStatus.getCount() == 0) {
		        dsBillStatus.load();
		    }
		    dsBillStatus.each(function(r) {		
		        if(val==2) val=0;        
		        if (val == r.data['BillStatusId']) {
		            val = r.data['BillStatusName'];
		            return;
		        }
		    });
		    return val;
		}
},
		{
		    header: '车船号',
		    dataIndex: 'CarBoatNo',
		    id: 'CarBoatNo'
		},
		{
			header:'确认状态',
			//hidden:true,
			dataIndex:'ConfirmStatus',
			id:'ConfirmStatus',
			renderer:function(v){
			    if(v==1) return '已确认';
			    return '未确认';
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
                              if(v==1||v==2||v==3)
                                {
                                    if(showTipRowIndex == rowIndex)
                                        return;
                                    else
                                        showTipRowIndex = rowIndex;
                                        
                                     tip.body.dom.innerHTML="正在加载数据……";
                                        //页面提交
                                        Ext.Ajax.request({
                                            url: 'frmPurchaseOrderList.aspx?method=getdetailinfo',
                                            method: 'POST',
                                            params: {
                                                OrderId: grid.getStore().getAt(rowIndex).data.OrderId
                                            },
                                            success: function(resp, opts) {
                                                tip.body.dom.innerHTML = resp.responseText;
//                                                Ext.Msg.alert(resp.responseText);
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
