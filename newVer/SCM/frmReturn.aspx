<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmReturn.aspx.cs" Inherits="SCM_frmReturn" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">


<html>
<head>
<title>退货单管理</title><meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<link rel="stylesheet" type="text/css" href="../ext3/resources/css/ext-all.css" />
<script type="text/javascript" src="../ext3/adapter/ext/ext-base.js"></script>
<script type="text/javascript" src="../ext3/ext-all.js"></script>
<script type="text/javascript" src="../js/operateResp.js"></script>
<script type="text/javascript" src="../js/ExtJsHelper.js"></script>
<script type="text/javascript" src="../ext3/src/locale/ext-lang-zh_CN.js"></script>
<style type="text/css">
.x-grid-back-blue { 
background: #B7CBE8; 
}
</style>

</head>
<body>
<div id='toolbar'></div>
<div id='divSearchForm'></div>
<div id='divDataGrid'></div>
</body>
<%=getComboBoxStore()%>
<script type="text/javascript">
Ext.BLANK_IMAGE_URL = "../ext3/resources/images/default/s.gif";
Ext.onReady(function() {



    /*------实现toolbar的函数 start---------------*/
    var Toolbar = new Ext.Toolbar({
        renderTo: "toolbar",
        items: [{
            text: "新增",
            icon: "../Theme/1/images/extjs/customer/add16.gif",
            handler: function() { popAddWin(); }
        }, '-', {
            text: "编辑",
            icon: "../Theme/1/images/extjs/customer/edit16.gif",
            handler: function() { popModifyWin(); }
        }, '-', {
            text: "删除",
            icon: "../Theme/1/images/extjs/customer/delete16.gif",
            handler: function() { deleteData(); }
        }
        <%=getPrivCode() %>
        , '-', {
//            text: "作废",
//            icon: "../Theme/1/images/extjs/customer/delete16.gif",
//            handler: function() { abandonBill(); }
//        }, '-', {
            text: "冲红",
            icon: "../Theme/1/images/extjs/customer/delete16.gif",
            handler: function() { generBill(); }
        }, '-', {
            text: "退款",
            icon: "../Theme/1/images/extjs/customer/edit16.gif",
            handler: function() { AcctRece(); }
        }, '-', {
            text: "用途设置",
            icon: "../Theme/1/images/extjs/customer/edit16.gif",
            handler: function() {  
                productUseAdd();
            }
        }, '-', {
            text: "打印退货单",
            icon: "../Theme/1/images/extjs/customer/edit16.gif",
            handler: function() { printOrderById(); }
        }]
        });
        /*------结束toolbar的函数 end---------------*/
        var productUseAddWin = null;
        function productUseAdd()
        {
            var record=MstGrid.getSelectionModel().getSelections();
            if(record == null || record.length == 0)
            {
                Ext.Msg.alert('提示消息', '请选择需要设置的订单信息，可以多个订单同时处理');
                return null;
            }

            var orderIds = '';
            for(var i=0;i<record.length;i++)
            {
                if(orderIds.length>0)
                    orderIds+=",";
                orderIds += record[i].get('ReturnId');
            }
            if(productUseAddWin==null)
            {
                productUseAddWin = ExtJsShowWin('退货订单产品用途信息设置','../../Common/frmOrderDtailUpdate.aspx?formType=returnproductuse&&OrderIds='+orderIds,'productUse',600,450);
                productUseAddWin.show();
            }
            else
            {
                productUseAddWin.show();
                document.getElementById("iframeproductUse").contentWindow.loadData(orderIds);
            } 
        }
function getUrl(imageUrl)
            {
                var index = window.location.href.toLowerCase().indexOf('/scm/');
                var tempUrl = window.location.href.substring(0,index);
                return tempUrl+"/"+imageUrl;
            }
function printOrderById()
{
var sm = MstGrid.getSelectionModel();
                //多选
                var selectData = sm.getSelections();                
                var array = new Array(selectData.length);
                var orderIds = "";
                for(var i=0;i<selectData.length;i++)
                {
                    if(orderIds.length>0)
                        orderIds+=",";
                    orderIds += selectData[i].get('ReturnId');
                }
                //页面提交
                Ext.Ajax.request({
                    url: 'frmReturn.aspx?method=getprintdata',
//                    url:'frmOrderMst.aspx?method=billdata',
                    method: 'POST',
                    params: {
                        ReturnId: orderIds
                    },
                   success: function(resp,opts){ 
                       var printData =  resp.responseText;
                       var printControl =  parent.parent.parent.document.getElementById("topFrame").contentWindow.getPrintControl();
                       printControl.Url =getUrl('xml');
                       printControl.MapUrl = printControl.Url+'/'+printStyleXml;//'/salePrint1.xml';
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

        //生成入库单
        function generateInStockOrderWin() {
            var sm = MstGrid.getSelectionModel();
            var selectData = sm.getSelected();
            //如果没有选择，就提示需要选择数据信息
            if (selectData == null || selectData == "") {
                Ext.Msg.alert("提示", "请选中需要操作的记录！");
                return;
            }
            if (selectData.data.Status != 1) {
                Ext.Msg.alert("提示", "仓库已处理，不允许操作！");
                return;
            }
            //页面提交
            Ext.Ajax.request({
                url: 'frmReturnCheck.aspx?method=checkReturn',
                method: 'POST',
                params: {
                    ReturnId: selectData.data.ReturnId,
		            Status:1
                },
                success: function(resp, opts) {
                    var data = Ext.util.JSON.decode(resp.responseText);
                    //alert(data.success);
                    if (data.success) {
                        uploadOrderWindow.show();
                        document.getElementById("editIFrame").src = "../WMS/frmInStockBill.aspx?type=W0204&id=" + data.id;
                    }
                },
                failure: function(resp, opts) {
                    Ext.Msg.alert("提示", "数据操作失败");
                }
            });


        }
        //入仓单界面      
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
		            , html: '<iframe id="editIFrame" width="100%" height="100%" border=0 src="frmInStockBill.aspx"></iframe>'

            });
        }
        uploadOrderWindow.addListener("hide", function() {
            var sm = MstGrid.getSelectionModel();
            var selectData = sm.getSelected();
            //页面提交
            Ext.Ajax.request({
                url: 'frmReturn.aspx?method=checkReturn',
                method: 'POST',
                params: {
                    ReturnId: selectData.data.ReturnId
                },
                success: function(resp, opts) {
                    var data = Ext.util.JSON.decode(resp.responseText);
                    if (data.success) {
                        MstGridData.reload();
                    }
                },
                failure: function(resp, opts) {
                    //Ext.Msg.alert("提示", "数据操作失败");
                }
            });

        });

        //开票功能
        function generBill() {
            var sm = MstGrid.getSelectionModel();
            var selectData = sm.getSelected();
            //如果没有选择，就提示需要选择数据信息
            if (selectData == null || selectData == "") {
                Ext.Msg.alert("提示", "请选中需要操作的记录！");
                return;
            }
            if(selectData.data.IsBill==1){
                Ext.Msg.alert("提示", "请选中未冲红的记录！");
                return;
            }

            var strOrderId = "";
            var customerid = 0;
            var customername = "";
            var billtype = 2; //红字发票

            customerid = selectData.data.CustomerId;
            customername = selectData.data.CustomerName;
            strOrderId = selectData.data.ReturnId;

            openBillWindow.show();
            document.getElementById("billIFrame").src = "frmBillEdit.aspx?billtype=2&strCustomerid=" + customerid + "&strCustomername=" + escape(customername) + "&kpfs=0&strOrderId=" + strOrderId;

        }
        //开票界面
        if (typeof (openBillWindow) == "undefined") {//解决创建2个windows问题
            openBillWindow = new Ext.Window({
                id: 'openBillWindow',
                iconCls: 'upload-win'
                    , width: 680
                    , height: 460
                    , plain: true
                    , modal: true
                    , constrain: true
                    , resizable: false
                    , closeAction: 'hide'
                    , autoDestroy: true
                    , html: '<iframe id="billIFrame" width="100%" height="100%" border=0 src="frmBillEdit.aspx"></iframe>'

            });
        }
        openBillWindow.addListener("hide", function() {
            MstGridData.reload();
            document.getElementById("billIFrame").src = "frmBillEdit.aspx?billtype=2&strCustomerid=0&strCustomername=0&kpfs=0&strOrderId=0";
        });


        //退款功能
        function AcctRece() {
            var sm = MstGrid.getSelectionModel();
            var selectData = sm.getSelected();
            //如果没有选择，就提示需要选择数据信息
            if (selectData == null || selectData == "") {
                Ext.Msg.alert("提示", "请选中需要操作的记录！");
                return;
            }

            if(selectData.data.IsPayed==1){
                Ext.Msg.alert("提示", "请选中未退款的记录！");
                return;
            }
            var strOrderId = selectData.data.ReturnId;
            var strCustomerId = selectData.data.CustomerId;
            var strAmt = selectData.data.TotalAmt;

            openAcctWindow.show();
            document.getElementById("acctIFrame").src = "frmScmAcctRece.aspx?billtype=2&strCustomerId=" + strCustomerId + "&sumAmt=" + strAmt + "&strOrderId=" + strOrderId;

        }


        //收款界面
        if (typeof (openAcctWindow) == "undefined") {//解决创建2个windows问题
            openAcctWindow = new Ext.Window({
                id: 'openAcctWindow',
                iconCls: 'upload-win'
                    , width: 380
                    , height: 240
                    , plain: true
                    , modal: true
                    , constrain: true
                    , resizable: false
                    , closeAction: 'hide'
                    , autoDestroy: true
                    , html: '<iframe id="acctIFrame" width="100%" height="100%" border=0 src="frmScmAcctRece.aspx"></iframe>'

            });
        }
        openAcctWindow.addListener("hide", function() {
            document.getElementById("acctIFrame").src = "frmScmAcctRece.aspx?billtype=2&strOrderId=0&sumAmt=0&strOrderId=0"; //清楚其内容，建议在子页面提供一个方法来调用
        });



        //退货单列表选择
        function QueryDataGrid() {
            MstGridData.baseParams.CustomerId = Ext.getCmp('CustomerId').getValue();
            MstGridData.baseParams.StartDate = Ext.util.Format.date(Ext.getCmp('StartDate').getValue(), 'Y/m/d');
            MstGridData.baseParams.EndDate = Ext.util.Format.date(Ext.getCmp('EndDate').getValue(), 'Y/m/d');

            MstGridData.load({
                params: {
                    start: 0,
                    limit: 10
                    //                        OrgId:Ext.getCmp('OrgId').getValue(),	                
                }
            });
        }
        //可退订单列表选择(新增时)
        function QueryOrderMstGrid() {
            OrderMstGridData.baseParams.CustomerId = Ext.getCmp('Add_CustomerId').getValue();
            OrderMstGridData.baseParams.StartDate = Ext.util.Format.date(Ext.getCmp('Add_StartDate').getValue(), 'Y/m/d');
            OrderMstGridData.baseParams.EndDate = Ext.util.Format.date(Ext.getCmp('Add_EndDate').getValue(), 'Y/m/d');
            OrderMstGridData.load({
                params: {
                    start: 0,
                    limit: 10
                }
            });
        }
        //可编辑退货订单明细(新增时)
        function QueryOrderDtlGrid() {
            var sm = OrderMstGrid.getSelectionModel();
            var selectData = sm.getSelected();
            if (selectData != null || selectData == "") {
                DtlGridData.baseParams.OrderId =selectData.data.OrderId;//选中行的订单标识
                DtlGridData.load({
                    params: {
                        start: 0,
                        limit: defaultPageSize
                    }
                });
            }
        }
        //弹出新增窗口
        function popAddWin() {
            Ext.getCmp("Add_StartDate").setValue(new Date().getFirstDateOfMonth().clearTime());
            openAddWin.show();
            QueryOrderMstGrid();
            showhidenorder(false);
        }
        
        //控制
        function showhidenorder( flag)
        {
            if(!flag){
                Ext.getCmp('noOrderWhId').hide();
                Ext.getCmp('noOrderCustomerName').hide();
                Ext.getCmp('noOrderWhId').getEl().up('.x-form-item').setDisplayed(false); // hide label  
                Ext.getCmp('noOrderCustomerName').getEl().up('.x-form-item').setDisplayed(false); // hide label  
            }else{
                Ext.getCmp('noOrderWhId').show();
                Ext.getCmp('noOrderCustomerName').show();
                Ext.getCmp('noOrderWhId').getEl().up('.x-form-item').setDisplayed(true); // hide label  
                Ext.getCmp('noOrderCustomerName').getEl().up('.x-form-item').setDisplayed(true); // hide label  
                if(customerFilterCombo==null){
                    customerFilterCombo = new Ext.form.ComboBox({
                    store: dsCustomers,
                    displayField: 'ChineseName',
                    displayValue: 'CustomerId',
                    typeAhead: false,
                    minChars: 1,
                    loadingText: 'Searching...',
                    tpl: resultTpl,
                    pageSize: 10,
                    hideTrigger: true,
                    applyTo: 'noOrderCustomerName',
                    itemSelector: 'div.search-item',
                    onSelect: function(record) { // override default onSelect to do redirect  
                        Ext.getCmp('noOrderCustomerName').setValue(record.data.ChineseName);
                        Ext.getCmp('noOrderCustomerId').setValue(record.data.CustomerId);
                        this.collapse();
                        }
                    });
                }
            }
        }
        
        //新增保存
        function saveAdd() {
            //获取主表信息
            var sm = OrderMstGrid.getSelectionModel();
            var selectData = sm.getSelected();
            //组装明细表信息
            var json = "";
            DtlGridData.each(function(DtlGridData) {
                json += Ext.util.JSON.encode(DtlGridData.data) + ',';
            });
            if(selectData==null||selectData==undefined){
                Ext.Ajax.request({
                    url: 'frmReturn.aspx?method=saveAdd',
                    method: 'POST',
                    params: {
                        IN_STOR: Ext.getCmp('noOrderWhId').getValue(),
                        CUSTOMER_ID: Ext.getCmp('noOrderCustomerId').getValue(),
                        RETURN_REASON: Ext.getCmp('ReturnReason').getValue(),
                        OLD_ORDER_ID: -1,
                        REMARK: Ext.getCmp('Remark').getValue(),
                        //明细参数
                        DetailInfo: json
                    },
                    success: function(resp, opts) {
                        checkExtMessage(resp);
                        QueryDataGrid();
                        openAddWin.hide();
                    },
                    failure: function(resp, opts) { Ext.Msg.alert("提示", "保存失败"); }
                });
            }else{
                Ext.Ajax.request({
                    url: 'frmReturn.aspx?method=saveAdd',
                    method: 'POST',
                    params: {
                        IN_STOR: selectData.data.OutStor,
                        CUSTOMER_ID: selectData.data.CustomerId,
                        RETURN_REASON: Ext.getCmp('ReturnReason').getValue(),
                        OLD_ORDER_ID: selectData.data.OrderId,
                        REMARK: Ext.getCmp('Remark').getValue(),
                        //明细参数
                        DetailInfo: json
                    },
                    success: function(resp, opts) {
                        checkExtMessage(resp);
                        QueryDataGrid();
                        openAddWin.hide();
                    },
                    failure: function(resp, opts) { Ext.Msg.alert("提示", "保存失败"); }
                });
            }
        }


        //修改窗口
        function popModifyWin() {
            var sm = MstGrid.getSelectionModel();
            //获取选择的数据信息
            var selectData = sm.getSelected();
            if (selectData == null || selectData == "") {
                Ext.Msg.alert("提示", "请选中需要编辑的信息！");
                return;
            }
            if (selectData.data.Status != 1) {
                Ext.Msg.alert("提示", "仓库已处理，不允许编辑！");
                return;
            }

            openModWin.show();
            Ext.getCmp("ModRemark").setValue(selectData.data.Remark);
            Ext.getCmp("ModReturnReason").setValue(selectData.data.ReturnReason);
            QueryReturnDtlGrid();

        }
        //可编辑退货单明细(修改时)
        function QueryReturnDtlGrid() {
            var sm = MstGrid.getSelectionModel();
            var selectData = sm.getSelected();            
            ModDtlGridData.baseParams.ReturnId =selectData.data.ReturnId;//选中行的订单标识
            ModDtlGridData.load({
                params: {
                    start: 0,
                    limit: defaultPageSize
                }
            });
        }

        //修改保存
        function saveUpdate() {
            //获取主表信息
            var sm = MstGrid.getSelectionModel();
            var selectData = sm.getSelected();
            //组装明细表信息
            var json = "";
            ModDtlGridData.each(function(ModDtlGridData) {
                json += Ext.util.JSON.encode(ModDtlGridData.data) + ',';
            });
            Ext.Ajax.request({
                url: 'frmReturn.aspx?method=saveUpdate',
                method: 'POST',
                params: {
                    RETURN_ID: selectData.data.ReturnId,
                    RETURN_REASON: Ext.getCmp('ModReturnReason').getValue(),
                    REMARK: Ext.getCmp('ModRemark').getValue(),
                    //明细参数
                    DetailInfo: json
                },
                success: function(resp, opts) { checkExtMessage(resp);QueryDataGrid();openModWin.hide(); },
                failure: function(resp, opts) { Ext.Msg.alert("提示", "保存失败"); }
            });
        }


        /*删除信息*/
        function deleteData() {
            var sm = MstGrid.getSelectionModel();
            var selectData = sm.getSelected();
            //如果没有选择，就提示需要选择数据信息
            if (selectData == null || selectData == "") {
                Ext.Msg.alert("提示", "请选中需要删除的信息！");
                return;
            }
            if (selectData.data.Status != 1) {
                Ext.Msg.alert("提示", "仓库已处理，不允许操作！");
                return;
            }
            //删除前再次提醒是否真的要删除
            Ext.Msg.confirm("提示信息", "是否真的要删除选择的记录吗？", function callBack(id) {
                //判断是否删除数据
                if (id == "yes") {
                    //页面提交
                    Ext.Ajax.request({
                        url: 'frmReturn.aspx?method=delete',
                        method: 'POST',
                        params: {
                            ReturnId: selectData.data.ReturnId
                        },
                        success: function(resp, opts) {
                            checkExtMessage(resp);
                            MstGridData.reload();
                        },
                        failure: function(resp, opts) {
                            Ext.Msg.alert("提示", "数据删除失败");
                        }
                    });

                }
            });
        }

        //////////////////////////////Start 列表界面/////////////////////////////////////////////////////////////////
        var serchform = new Ext.FormPanel({
            renderTo: 'divSearchForm',
            labelAlign: 'left',
            //                    layout: 'fit',
            buttonAlign: 'right',
            bodyStyle: 'padding:5px',
            frame: true,
            labelWidth: 55,
            items: [
	                {
	                    layout: 'column',
	                    border: false,
	                    labelSeparator: '：',
	                    items: [
		                {
		                    layout: 'form',
		                    border: false,
		                    columnWidth: 0.33,
		                    items: [
				                {
				                    xtype: 'textfield',
				                    fieldLabel: '客户',
				                    columnWidth: 0.33,
				                    anchor: '90%',
				                    name: 'CustomerId',
				                    id: 'CustomerId'
				                }
		                            ]
		                }
                , {
                    layout: 'form',
                    border: false,
                    columnWidth: 0.25,
                    items: [
				                {
				                    xtype: 'datefield',
				                    fieldLabel: '开始日期',
				                    columnWidth: 0.5,
				                    anchor: '90%',
				                    name: 'StartDate',
				                    id: 'StartDate',
				                    value: new Date().getFirstDateOfMonth().clearTime(),
				                    format: 'Y年m月d日'
				                }
		                ]
                }
                , {
                    layout: 'form',
                    border: false,
                    columnWidth: 0.25,
                    items: [
				                {
				                    xtype: 'datefield',
				                    fieldLabel: '结束日期',
				                    columnWidth: 0.5,
				                    anchor: '90%',
				                    name: 'EndDate',
				                    id: 'EndDate',
				                    value: new Date().clearTime(),
				                    format: 'Y年m月d日'
				                }
		                ]
                }
                , {
                    layout: 'form',
                    border: false,
                    columnWidth: 0.1,
                    items: [{
                        cls: 'key',
                        xtype: 'button',
                        text: '查询',
                        buttonAlign: 'right',
                        id: 'searchebtnId',
                        anchor: '90%',
                        handler: function() { QueryDataGrid(); }
}]
                    }
	                ]
	                }
                ]
        });


        /*------开始获取数据的函数 start---------------*/
        var MstGridData = new Ext.data.Store
                        ({
                            url: 'frmReturn.aspx?method=getReturnList',
                            reader: new Ext.data.JsonReader({
                                totalProperty: 'totalProperty',
                                root: 'root'
                            }, [
                                {
                                    name: 'ReturnId'
                                },
	                            {
	                                name: 'ReturnNumber'
	                            },
	                            {
	                                name: 'OrgId'
	                            },
	                            {
	                                name: 'OrgName'
	                            },
	                            {
	                                name: 'InStor'
	                            },
	                            {
	                                name: 'CustomerId'
	                            },
	                            {
	                                name: 'ReturnReason'
	                            },
	                            {
	                                name: 'TotalQty'
	                            },
	                            {
	                                name: 'TotalAmt'
	                            },
	                            {
	                                name: 'DtlCount'
	                            },
	                            {
	                                name: 'Status'
	                            },
	                            {
	                                name: 'InStorId'
	                            },
	                            {
	                                name: 'OldOrderId'
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
	                                name: 'OwnerId'
	                            },
	                            {
	                                name: 'BizAudit'
	                            },
	                            {
	                                name: 'AuditDate'
	                            },
	                            {
	                                name: 'Remark'
	                            },
	                            {
	                                name: 'IsActive'
	                            },
	                            {
	                                name: 'StorName'
	                            },
	                            {
	                                name: 'CustomerName'
	                            },
	                            {
	                                name: 'CustomerCode'
	                            },
	                            {
	                                name: 'Address'
	                            },
	                            {
	                                name: 'StatusName'
	                            },
	                            {
	                                name: 'OperName'
	                            },
	                            {
	                                name: 'IsBill'
	                            },
	                            {
	                                name: 'IsPayed'
	                            },
	                            {
	                                name: 'OwnerName'
	                            },
	                            {
	                                name: 'IsActiveName'
	                            }, {
	                                name: 'OrderNumber'
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
        var MstGrid = new Ext.grid.GridPanel({
            el: 'divDataGrid',
            width: document.body.offsetWidth,
            height: '100%',
            //autoWidth: true,
            //autoHeight: true,
            autoScroll: true,
            layout: 'fit',
            id: '',
            store: MstGridData,
            loadMask: { msg: '正在加载数据，请稍侯……' },
            sm: sm,
            cm: new Ext.grid.ColumnModel([

		                    sm,
		                    new Ext.grid.RowNumberer(), //自动行号
		                    {
		                    header: '标识',
		                    dataIndex: 'ReturnId',
		                    id: 'ReturnId',
		                    hidden: true
		                },
		                    {
		                        header: '原订单编号',
		                        dataIndex: 'OrderNumber',
		                        id: 'OrderNumber',
		                        width: 80
		                    },
		                    {
		                        header: '公司名称',
		                        dataIndex: 'OrgName',
		                        id: 'OrgName',
		                        hidden: true
		                    },
		                    {
		                        header: '仓库',
		                        dataIndex: 'StorName',
		                        id: 'StorName',
		                        width: 70
		                    },
		                    {
		                        header: '客户编码',
		                        dataIndex: 'CustomerCode',
		                        id: 'CustomerCode',
		                        width: 60
		                    },
		                    {
		                        header: '客户名称',
		                        dataIndex: 'CustomerName',
		                        id: 'CustomerName',
		                        width: 145
		                    },
		                    {
		                        header: '退货总量',
		                        dataIndex: 'TotalQty',
		                        id: 'TotalQty',
		                        width: 60
		                    },
		                    {
		                        header: '退货原因',
		                        dataIndex: 'ReturnReason',
		                        id: 'ReturnReason',
		                        width: 100
		                    },
		                    {
		                        header: '操作员',
		                        dataIndex: 'OperName',
		                        id: 'OperName',
		                        width: 50
		                    },
		                    {
		                        header: '创建时间',
		                        dataIndex: 'CreateDate',
		                        id: 'CreateDate',
		                        width: 60,
		                        renderer:Ext.util.Format.dateRenderer('Y年m月d日')
		                    },
		                    {
		                        header: '状态',
		                        dataIndex: 'StatusName',
		                        id: 'StatusName',
		                        width: 60
		                    },
		                    {
		                        header: '是否冲红发票 ',
		                        dataIndex: 'IsBill',
		                        id: 'IsBill',
		                        width: 60,
		                        renderer:function(v){if(v==1)return '已冲红';else return '未冲红';}
		                    },
		                    {
		                        header: '是否退款',
		                        dataIndex: 'IsPayed',
		                        id: 'IsPayed',
		                        width: 60,
		                        renderer:function(v){if(v==1)return '已退款';else return '未退款';}
		                    }

		                    ]),
            bbar: new Ext.PagingToolbar({
                pageSize: 10,
                store: MstGridData,
                displayMsg: '显示第{0}条到{1}条记录,共{2}条',
                emptyMsy: '没有记录',
                displayInfo: true
            }),
            viewConfig: {
                columnsText: '显示的列',
                scrollOffset: 20,
                sortAscText: '升序',
                sortDescText: '降序',
                forceFit: false
            },
            height: 320,
            closeAction: 'hide',
            stripeRows: true,
            loadMask: true//,
            //autoExpandColumn: 2
        });
        MstGrid.on("afterrender", function(component) {
            component.getBottomToolbar().refresh.hideParent = true;
            component.getBottomToolbar().refresh.hide();
        });
        
        MstGrid.on('render', function(grid) {  
        var store = grid.getStore();  // Capture the Store.  
  
        var view = grid.getView();    // Capture the GridView. 
         MstGrid.tip = new Ext.ToolTip({  
            target: view.mainBody,    // The overall target element.  
      
            delegate: '.x-grid3-row', // Each grid row causes its own seperate show and hide.  
      
            trackMouse: true,         // Moving within the row should not hide the tip.  
      
            renderTo: document.body,  // Render immediately so that tip.body can be referenced prior to the first show.  
      
            listeners: {              // Change content dynamically depending on which element triggered the show.  
      
                beforeshow: function updateTipBody(tip) {  
                    var rowIndex = view.findRowIndex(tip.triggerElement);
                            var element = document.elementFromPoint(tip.x-20, tip.y-20);
                             var v = view.findCellIndex(element);
                             if(v==3||v==5)
                             {
                              
                                if(showTipRowIndex == rowIndex)
                                    return;
                                else
                                    showTipRowIndex = rowIndex;
                                     tip.body.dom.innerHTML="正在加载数据……";
                                        //页面提交
                                        Ext.Ajax.request({
                                            url: 'frmReturn.aspx?method=getreturndetailinfo',
                                            method: 'POST',
                                            params: {
                                                ReturnId: grid.getStore().getAt(rowIndex).data.ReturnId
                                            },
                                            success: function(resp, opts) {
                                                tip.body.dom.innerHTML = resp.responseText;
                                            },
                                            failure: function(resp, opts) {
                                                MstGrid.tip.hide();
                                            }
                                        });
                                }//细项信息                                                   
                                else
                                {
                                    MstGrid.tip.hide();
                                }
                        
            }  }});
        });  
    var showTipRowIndex=-1;
        
        MstGrid.render();
        /*------DataGrid的函数结束 End---------------*/
        //////////////////////////////////End 列表界面/////////////////////////////////////////////////////////////

        /////////////////////////Start 新增界面//////////////////////////////////////////////////////////////////

        //新增界面查询条件
        var addWinSerchform = new Ext.FormPanel({
            labelAlign: 'left',
            buttonAlign: 'right',
            bodyStyle: 'padding:5px',
            frame: true,
            labelWidth: 55,
            //                    region:'north',
            height: 50,
            items: [
	                {
	                    layout: 'column',
	                    border: false,
	                    labelSeparator: '：',
	                    items: [
		                {
		                    layout: 'form',
		                    border: false,
		                    columnWidth: 0.3,
		                    items: [
				                {
				                    xtype: 'textfield',
				                    fieldLabel: '客户',
				                    columnWidth: 0.33,
				                    anchor: '90%',
				                    name: 'Add_CustomerId',
				                    id: 'Add_CustomerId'
				                }
		                            ]
		                }
                , {
                    layout: 'form',
                    border: false,
                    columnWidth: 0.3,
                    items: [
				                {
				                    xtype: 'datefield',
				                    fieldLabel: '开始日期',
				                    columnWidth: 0.5,
				                    anchor: '90%',
				                    name: 'Add_StartDate',
				                    id: 'Add_StartDate',
				                    value: new Date().getFirstDateOfMonth().clearTime(),
				                    format: 'Y年m月d日'
				                }
		                ]
                }
                , {
                    layout: 'form',
                    border: false,
                    columnWidth: 0.3,
                    items: [
				                {
				                    xtype: 'datefield',
				                    fieldLabel: '结束日期',
				                    columnWidth: 0.5,
				                    anchor: '90%',
				                    name: 'Add_EndDate',
				                    id: 'Add_EndDate',
				                    value: new Date().clearTime(),
				                    format: 'Y年m月d日'
				                }
		                ]
                }
                , {
                    layout: 'form',
                    border: false,
                    columnWidth: 0.1,
                    items: [{
                        cls: 'key',
                        xtype: 'button',
                        text: '查询',
                        buttonAlign: 'right',
                        id: 'addSerchBtnId',
                        anchor: '25%',
                        handler: function() {
                            QueryOrderMstGrid();
                            QueryOrderDtlGrid();
                        }
}]
                    }
	                ]
	                }
                ]
        });

        //新增可退订单主表列表
        var OrderMstGridData = new Ext.data.Store
        ({
            url: 'frmReturn.aspx?method=getOrderList',
            reader: new Ext.data.JsonReader({
                totalProperty: 'totalProperty',
                root: 'root'
            }, [
                {name: 'OrderId'},
                {name: 'OrderNumber'},
                {name: 'OrgId'},
                {name: 'OrgName'},
                {name: 'DeptId'},	                            
                {name: 'DeptName'},
                {name: 'OutStor'},
                {name: 'OutStorName'},
                {name: 'CustomerId'},
                {name: 'CustomerName'},
                {name: 'DlvDate'},
                {name: 'DlvAdd'},
                {name: 'DlvDesc'},
                {name: 'OrderType'},
                {name: 'OrderTypeName'},
                {name: 'PayType'},
                {name: 'PayTypeName'},
                {name: 'BillMode'},
                {name: 'BillModeName'},
                {name: 'DlvType'},
                {name: 'DlvTypeName'},
                {name: 'DlvLevel'},
                {name: 'DlvLevelName'},
                {name: 'Status'},
                {name: 'StatusName'},
                {name: 'IsPayed'},
                {name: 'IsPayedName'},
                {name: 'IsBill'},
                {name: 'IsBillName'},
                {name: 'SaleInvId'},
                {name: 'SaleTotalQty'},
                {name: 'OutedQty'},
                {name: 'SaleTotalAmt'},
                {name: 'SaleTotalTax'},
                {name: 'DtlCount'},
                {name: 'OperId'},
                {name: 'OperName'},
                {name: 'CreateDate'},
                {name: 'UpdateDate'},
                {name: 'OwnerId'},
                {name: 'OwnerName'},
                {name: 'BizAudit'},
                {name: 'AuditDate'},
                {name: 'Remark'},
                {name: 'IsActive'},
                {name: 'IsActiveName'}
                ]) ,
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
            singleSelect: false
        });
        var OrderMstGrid = new Ext.grid.GridPanel({
            autoScroll: true,
            height: 200,
            //                            region:'center',
            id: '',
            store: OrderMstGridData,
            loadMask: { msg: '正在加载数据，请稍侯……' },
            sm: sm,
            cm: new Ext.grid.ColumnModel([
		                    sm,
		                    new Ext.grid.RowNumberer(), //自动行号
		                    {
		                    header: '订单标识',
		                    dataIndex: 'OrderId',
		                    id: 'OrderId',
		                    hidden: true
		                },
		                    {
		                        header: '订单编号',
		                        dataIndex: 'OrderNumber',
		                        id: 'OrderNumber',
		                        width: 80
		                    },
		                    {
		                    header: '客户名称',
		                    dataIndex: 'CustomerName',
		                    id: 'CustomerName',
		                    width: 160
		                },
		                    {
		                        header: '送货日期',
		                        dataIndex: 'DlvDate',
		                        id: 'DlvDate',
		                        width: 60
		                    },
		                    {
		                        header: '订单类型',
		                        dataIndex: 'OrderTypeName',
		                        id: 'OrderTypeName',
		                        width: 60
		                    },
		                    {
		                    header: '配送方式',
		                    dataIndex: 'DlvTypeName',
		                    id: 'DlvTypeName',
		                    width: 60
		                },
		                    {
		                    header: '订货总数量',
		                    dataIndex: 'SaleTotalQty',
		                    id: 'SaleTotalQty',
		                    width: 60
		                    },
		                    {
		                    header: '操作员',
		                    dataIndex: 'OperName',
		                    id: 'OperName',
		                    width: 60
		                },
		                    {
		                        header: '创建时间',
		                        dataIndex: 'CreateDate',
		                        id: 'CreateDate',
		                        renderer: Ext.util.Format.dateRenderer('Y年m月d日'),
		                        width: 60
            }]),
            bbar: new Ext.PagingToolbar({
                pageSize: 10,
                store: OrderMstGridData,
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
            closeAction: 'hide',
            stripeRows: true,
            loadMask: true,
            autoExpandColumn: 2,
            listeners: {
                rowclick: function(grid, rowIndex, e) {
                    QueryOrderDtlGrid();
                }
            }
        });
        OrderMstGrid.on("afterrender", function(component) {
            component.getBottomToolbar().refresh.hideParent = true;
            component.getBottomToolbar().refresh.hide();
        });
        /*------DataGrid的函数结束 End---------------*/
        //定义客户下拉框异步调用方法            
        var dsCustomers;
        if (dsCustomers == null) {
            dsCustomers = new Ext.data.Store({
                url: 'frmReturn.aspx?method=getCustomers',
                reader: new Ext.data.JsonReader({
                    root: 'root',
                    totalProperty: 'totalProperty'
                }, [
                        { name: 'CustomerId', mapping: 'CustomerId' },
                        { name: 'CustomerNo', mapping: 'CustomerNo' },
                        { name: 'ChineseName', mapping: 'ChineseName' },
                        { name: 'Address', mapping: 'Address' }
                    ])
            });
        }
        // 定义客户下拉框异步返回显示模板
        var resultTpl = new Ext.XTemplate(
            '<tpl for="."><div id="searchkhdivid" class="search-item">',
                '<h3><span> {ChineseName}</span> </h3>',
            '</div></tpl>'
        );
        var customerFilterCombo = null;
        var dtlForm = new Ext.FormPanel({
            labelAlign: 'left',
            buttonAlign: 'right',
            bodyStyle: 'padding:5px',
            frame: true,
            labelWidth: 65,
            //height: 70,
            autoHeight:true,
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
                    items: [
                    {   
                        xtype: 'hidden',
			            fieldLabel: '存货ID',
			            hidden: true,
			            name: 'noOrderCustomerId',
			            id: 'noOrderCustomerId',
			            hiddenLabel: true
                    },
                    {
                        xtype: 'textfield',
                        fieldLabel: '客户名称*',
                        columnWidth: 0.33,
                        anchor: '90%',
                        name: 'noOrderCustomerName',
                        id: 'noOrderCustomerName'
                    }]
                }
                ,{
                    layout: 'form',
                    border: false,
                    columnWidth: 0.5,
                    items: [
                    {
                        xtype: 'combo',
                        store: dsWareHouse, 
                        valueField: 'WhId',
                        displayField: 'WhName',
                        mode: 'local',
                        forceSelection: true,
                        emptyValue: '',
                        triggerAction: 'all',
                        selectOnFocus: true,
                        fieldLabel: '退货仓库*',
                        columnWidth: 0.5,
                        anchor: '90%',
                        name: 'noOrderWhId',
                        id: 'noOrderWhId'
                    }]
                }]
           },
            {
                layout: 'column',
                border: false,
                labelSeparator: '：',
                items: [
                {
                    layout: 'form',
                    border: false,
                    columnWidth: 0.5,
                    items: [
                    {
                        xtype: 'textfield',
                        fieldLabel: '退货原因',
                        columnWidth: 0.33,
                        anchor: '90%',
                        name: 'ReturnReason',
                        id: 'ReturnReason'
                    }]
                }
                , {
                    layout: 'form',
                    border: false,
                    columnWidth: 0.5,
                    items: [
                    {
                        xtype: 'textfield',
                        fieldLabel: '备注',
                        columnWidth: 0.5,
                        anchor: '90%',
                        name: 'Remark',
                        id: 'Remark'
                    }]
                }]
            }]
        });


        /*------开始获取数据的函数 start---------------*/
        var DtlGridData = new Ext.data.Store
                        ({
                            url: 'frmReturn.aspx?method=getOrderDtlList',
                            reader: new Ext.data.JsonReader({
                                totalProperty: 'totalProperty',
                                root: 'root'
                            }, [
                                {
                                    name: 'OrderDtlId'
                                },
	                            {
	                                name: 'ProductId'
	                            },
	                            {
	                                name: 'ProductCode'
	                            },
	                            {
	                                name: 'ProductName'
	                            },
	                            {
	                                name: 'Unit'
	                            },
	                            {
	                                name: 'UnitName'
	                            },
	                            {
	                                name: 'Specifications'
	                            },
	                            {
	                                name: 'SpecificationsName'
	                            },
	                            {
	                                name: 'SaleQty'
	                            },
	                            {
	                                name: 'SalePrice'
	                            },
	                            {
	                                name: 'SaleAmt'
	                            },
	                            {
	                                name: 'ReturnQty'
	                            },
	                            {
	                                name: 'SaleTax'
	                            },
	                            {
	                                name: 'TaxRate'
	                            },
	                            {
	                                name: 'UnitId'
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
        //定义下拉框异步调用方法,当前客户可订商品列表
        var dsProductUnits = new Ext.data.Store({
            url: 'frmOrderDtl.aspx?method=getProductUnits',
            params: {
                ProductId: 0
            },
            reader: new Ext.data.JsonReader({
                root: 'root',
                totalProperty: 'totalProperty',
                id: 'ProductUnits'
            }, [
                { name: 'UnitId', mapping: 'UnitId' },
                { name: 'UnitName', mapping: 'UnitName' }
            ])
        });

        //计量单位下拉框
        var UnitCombo = new Ext.form.ComboBox({
            store: dsProductUnits,
            displayField: 'UnitName',
            valueField: 'UnitId',
            triggerAction: 'all',
            id: 'UnitCombo',
            //pageSize: 5,  
            //minChars: 2,  
            //hideTrigger: true,  
            typeAhead: true,
            mode: 'local',
            emptyText: '',
            selectOnFocus: false,
            editable: false
            //                listeners: {
            //                    "select": addNewBlankRow
            //                }
        });
        /*------开始DataGrid的函数 start---------------*/
        //商品下拉框
        var dsProduct =new Ext.data.Store({
            url: 'frmPOSOrderEdit.aspx?method=getProductByNameNo',
            reader: new Ext.data.JsonReader({
                root: 'root',
                totalProperty: 'totalProperty'
            }, [
                    { name: 'ProductId', mapping: 'ProductId' },
                    { name: 'ProductNo', mapping: 'ProductNo' },
                    { name: 'ProductName', mapping: 'ProductName' },
                    { name: 'Unit', mapping: 'Unit' },
                    { name: 'SalePrice', mapping: 'SalePrice' },
                    { name: 'SalePriceLower', mapping: 'SalePriceLower' },
                    { name: 'SalePriceLimit', mapping: 'SalePriceLimit' },
                    { name: 'UnitText', mapping: 'UnitText' },
                    { name: 'Specifications', mapping: 'Specifications' },
                    { name: 'SpecificationsText', mapping: 'SpecificationsText' },
                    { name: 'UnitId', mapping: 'UnitId' },
                    { name:'WhQty',mapping:'WhQty'}
                ])
        });
        var strTemplate='<h3><span>{ProductNo}&nbsp;&nbsp;<font color=\"red\">{ProductName}&nbsp;</font></span></h3>';
        var resultPTpl = new Ext.XTemplate(  
            '<tpl for="."><div id="searchdivid" class="search-item">',  
                strTemplate,
            '</div></tpl>'  
        ); 
        
        var productCombo = new Ext.form.ComboBox({
            store: dsProduct,
            displayField: 'ProductName',
            valueField: 'ProductId',
            typeAhead: false,
            minChars: 1,
            width:400,
            loadingText: 'Searching...',
            tpl: resultPTpl,  
            itemSelector: 'div.search-item',  
            pageSize: 10,
            hideTrigger: true,
            listWidth:200,
            onSelect: function(record) {
                dsProductUnits.baseParams.ProductId = record.data.ProductId;
                dsProductUnits.load();
                var sm = OrderDtlGrid.getSelectionModel().getSelected();
                sm.set('ProductId', record.data.ProductId);
                sm.set('ProductCode', record.data.ProductNo);
                sm.set('ProductName', record.data.ProductName);
                sm.set('UnitName', record.data.UnitText);
                sm.set('SpecificationsName', record.data.SpecificationsText);
                sm.set('Unit',record.data.UnitId); 
                sm.set('UnitId',record.data.UnitId);
                sm.set('SaleQty','0');
                sm.set('SalePrice','0');
                sm.set('TaxRate',record.SalesTax);
                //获取商品价格信息
                  Ext.Ajax.request({
                        url:'frmPOSOrderEdit.aspx?method=getProductInfo',
                        params:{
                            ProductNo:record.data.ProductNo,
                            CustomerId:-1
                        },
                    success: function(resp,opts){
                        //alert(resp.responseText);
                        if(resp.responseText.length>20){
                            var data=Ext.util.JSON.decode(resp.responseText)                                        
	                        sm.set('TaxRate',data.SalesTax);
                        }
                    }
                  }); 
                this.collapse();//隐藏下拉列表
                var row = OrderDtlGrid.getStore().indexOf(sm);
                OrderDtlGrid.startEditing(3,row); 
            }
        });
        /////////////////////////////////
        var defaultPageSize = 10;
        var toolBar = new Ext.PagingToolbar({
            pageSize: 10,
            store: DtlGridData,
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
            QueryOrderDtlGrid();
        }, toolBar);
        /////////////////////////////////
        var sm = new Ext.grid.CheckboxSelectionModel({
            singleSelect: false
        });
        var OrderDtlGrid = new Ext.grid.EditorGridPanel({
            autoScroll: true,
            height: 200,
            region: 'south',
            id: '',
            store: DtlGridData,
            loadMask: { msg: '正在加载数据，请稍侯……' },
            sm: sm,
            cm: new Ext.grid.ColumnModel([
		                    sm,
		                    new Ext.grid.RowNumberer(), //自动行号
		                    {
		                        header: '商品代码',
		                        dataIndex: 'ProductId',
		                        id: 'ProductId',
		                        hidden:true,
		                        hideable:true
		                    },
		                    {
		                        header: '商品编码',
		                        dataIndex: 'ProductCode',
		                        id: 'ProductCode',
		                        editor:productCombo
		                    },
		                    {
		                        header: '名称',
		                        dataIndex: 'ProductName',
		                        id: 'ProductName'
		                    },
		                    {
		                        header: '单位',
		                        dataIndex: 'UnitName',
		                        id: 'UnitName',
		                        width:60
		                    },
		                    {
		                        header: '规格',
		                        dataIndex: 'SpecificationsName',
		                        id: 'SpecificationsName',
		                        width:60
		                    },
		                    {
		                        header: '订货数量',
		                        dataIndex: 'SaleQty',
		                        id: 'SaleQty',
		                        width:80
		                    },
		                    {
		                        header: '退货单位',
		                        dataIndex: 'Unit',
		                        id: 'Unit',
		                        hidden:true,
		                        hideable:true
		                    },
		                    {
		                        header: '退货单位',
		                        dataIndex: 'UnitId',
		                        id: 'UnitId',
		                        editor: UnitCombo,
		                        renderer: function(value, cellmeta, record, rowIndex, columnIndex, store) {
		                            var index = dsUnitList.findBy(function(record, id) {
		                                return record.get(UnitCombo.valueField) == value;
		                            });
		                            var record = dsUnitList.getAt(index);
		                            var displayText = "";
		                            // 如果下拉列表没有被选择，那么record也就不存在，这时候，返回传进来的value，
		                            // 而这个value就是grid的USER_REALNAME列的value，所以直接返回
		                            if (record == null) {
		                                //返回默认值，
		                                displayText = value;
		                            } else {
		                                displayText = record.data.UnitName; //获取record中的数据集中的process_name字段的值
		                            }
		                            return displayText;
		                        },
		                        width:60
		                    },
		                    {
		                        header: '退货数量',
		                        dataIndex: 'ReturnQty',
		                        id: 'ReturnQty',
		                        editor: new Ext.form.NumberField({ allowBlank: false,
		                        decimalPrecision:6 }),
		                        renderer: function(v, m) {
		                            m.css = 'x-grid-back-blue';
		                            return v;
		                        },
		                        align: 'right',
		                        width:80
		                    },
		                    {
		                        header: '单价',
		                        dataIndex: 'SalePrice',
		                        id: 'SalePrice',
		                        editor: new Ext.form.NumberField({ allowBlank: false,
		                        decimalPrecision:8 }),
		                        renderer: function(v, m) {
		                            m.css = 'x-grid-back-blue';
		                            return v;
		                        },
		                        align: 'right',
		                        width:80
		                    },
		                    {
		                        header: '税率',
		                        dataIndex: 'TaxRate',
		                        id: 'TaxRate'
		                    }

		                    ]),
            bbar: toolBar,
            tbar:[{
		        id: 'btnSearch',
		        text: '新增',
		        iconCls: 'add',
		        handler: function() {
		            OrderDtlGrid.setHeight(180);
		            inserNewBlankRow() ;
                }
            }],
            viewConfig: {
                columnsText: '显示的列',
                scrollOffset: 20,
                sortAscText: '升序',
                sortDescText: '降序',
                forceFit: true
            },
            closeAction: 'hide',
            stripeRows: true,
            loadMask: true,
            clicksToEdit:1,
            autoExpandColumn: 2

        });
        OrderDtlGrid.on("afterrender", function(component) {
            component.getBottomToolbar().refresh.hideParent = true;
            component.getBottomToolbar().refresh.hide();
        });

        OrderDtlGrid.on("beforeedit", beforeEdit, OrderDtlGrid);
        function beforeEdit(e) {
            var record = e.record;            
            if (record.data.ProductId != dsProductUnits.baseParams.ProductId
                && record.data.ProductId>0) {
                dsProductUnits.baseParams.ProductId = record.data.ProductId;
                dsProductUnits.load();
            }
        }
        var RowPattern = Ext.data.Record.create([
           { name: 'ProductId', type: 'string' },
           { name: 'ProductCode', type: 'string' },
           { name: 'ProductName', type: 'string' },
           { name: 'UnitName', type: 'string' },
           { name: 'SpecificationsName', type: 'string' },
           { name: 'Unit', type: 'string' },
           { name: 'UnitId', type: 'string' },
           { name: 'ReturnQty', type: 'string' },
           { name: 'SalePrice', type: 'string' }
          ]);
        function inserNewBlankRow() {
            var rowCount = OrderDtlGrid.getStore().getCount();
            var insertPos = parseInt(rowCount);
            var addRow = new RowPattern({
                ProductId:'',
                ProductCode: '',
                ProductName: '',
                UnitName: '',
                SpecificationsName: '',
                Unit: '',
                UnitId: '',
                ReturnQty: '0',
                SalePrice: '0' 
            });
            OrderDtlGrid.stopEditing();
            //增加一新行
            if (insertPos > 0) {
                var rowIndex = DtlGridData.insert(insertPos, addRow);
                OrderDtlGrid.startEditing(insertPos, 0);
            }
            else {
                var rowIndex = DtlGridData.insert(0, addRow);
                OrderDtlGrid.startEditing(0, 0);
            }
            showhidenorder(true);
        }
        if (typeof (openAddWin) == "undefined") {//解决创建2个windows问题
            openAddWin = new Ext.Window({
                id: 'openAddWin',
                title: '退货单维护'
		            , iconCls: 'upload-win'
		            , width: 750
		            , height: 580
		            , layout: 'form'
		            , plain: true
		            , modal: true
		            , constrain: true
		            , resizable: false
		            , closeAction: 'hide'
		            , autoDestroy: true
		            , items: [
		                { layout: 'form',
		                    border: false,
		                    columnWidth: 1,
		                    items: [addWinSerchform]
		                },
                         { layout: 'form',
                             border: false,
                             columnWidth: 1,
                             items: [OrderMstGrid]
                         },
                         { layout: 'form',
                             border: false,
                             columnWidth: 1,
                             items: [dtlForm]
                         },
                         { layout: 'form',
                             border: false,
                             columnWidth: 1,
                             items: [OrderDtlGrid]
                         }

		            ]
		            , buttons: [{
		                text: "保存"
			            , handler: function() {
			                saveAdd();
			            }
			            , scope: this
		            },
		            {
		                text: "取消"
			            , handler: function() {
			                openAddWin.hide();
			                MstGridData.reload();
			            }
			            , scope: this
}]
            });
        }
        openAddWin.addListener("hide", function() {
            DtlGridData.removeAll();
            showhidenorder(false);
        });

        ////////////////////////End 新增界面///////////////////////////////////////////////////////////////////////



        ////////////////////////Start 修改界面///////////////////////////////////////////////////////////////////////

        var modDtlForm = new Ext.FormPanel({
            labelAlign: 'left',
            buttonAlign: 'right',
            bodyStyle: 'padding:5px',
            frame: true,
            labelWidth: 55,
            height: 40,
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
	                                items: [
			                            {
			                                xtype: 'textfield',
			                                fieldLabel: '退货原因',
			                                columnWidth: 0.33,
			                                anchor: '90%',
			                                name: 'ModReturnReason',
			                                id: 'ModReturnReason'
			                            }
	                                        ]
	                            }
                        , {
                            layout: 'form',
                            border: false,
                            columnWidth: 0.5,
                            items: [
			                            {
			                                xtype: 'textfield',
			                                fieldLabel: '备注',
			                                columnWidth: 0.5,
			                                anchor: '90%',
			                                name: 'ModRemark',
			                                id: 'ModRemark'
			                            }
	                            ]
                        }


                            ]
                            }
                        ]
        });


        /*------开始获取数据的函数 start---------------*/
        var ModDtlGridData = new Ext.data.Store
                        ({
                            url: 'frmReturn.aspx?method=getReturnDtlList',
                            reader: new Ext.data.JsonReader({
                                totalProperty: 'totalProperty',
                                root: 'root'
                            }, [
                                {
                                    name: 'ReturnDtlId'
                                },
	                            {
	                                name: 'ReturnId'
	                            },
	                            {
	                                name: 'ProductId'
	                            },
	                            {
	                                name: 'ProductCode'
	                            },
	                            {
	                                name: 'ProductName'
	                            },
	                            {
	                                name: 'Unit'
	                            },
	                            {
	                                name: 'UnitName'
	                            },
	                            {
	                                name: 'Spec'
	                            },
	                            {
	                                name: 'SpecName'
	                            },
	                            {
	                                name: 'ReturnQty'
	                            },
	                            {
	                                name: 'Price'
	                            },
	                            {
	                                name: 'Amt'
	                            },
	                            {
	                                name: 'Tax'
	                            },
	                            {
	                                name: 'Rate'
	                            },
	                            {
	                                name: 'UnitId'
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

        //        var dsProductUnits = new Ext.data.Store({
        //            url: 'frmOrderDtl.aspx?method=getProductUnits',
        //            params: {
        //                ProductId: 0
        //            },
        //            reader: new Ext.data.JsonReader({
        //                root: 'root',
        //                totalProperty: 'totalProperty',
        //                id: 'ProductUnits'
        //            }, [
        //                        { name: 'UnitId', mapping: 'UnitId' },
        //                        { name: 'UnitName', mapping: 'UnitName' }
        //                    ])
        //        });

        var UnitCombo1 = new Ext.form.ComboBox({
            store: dsProductUnits,
            displayField: 'UnitName',
            valueField: 'UnitId',
            triggerAction: 'all',
            id: 'UnitCombo1',
            //pageSize: 5,  
            //minChars: 2,  
            //hideTrigger: true,  
            typeAhead: true,
            mode: 'local',
            emptyText: '',
            selectOnFocus: false,
            editable: false
        });

        /*------开始DataGrid的函数 start---------------*/

        var sm = new Ext.grid.CheckboxSelectionModel({
            singleSelect: false
        });
        var ModOrderDtlGrid = new Ext.grid.EditorGridPanel({
            autoScroll: true,
            height: 220,
            id: '',
            store: ModDtlGridData,
            loadMask: { msg: '正在加载数据，请稍侯……' },
            cm: new Ext.grid.ColumnModel([
		                    new Ext.grid.RowNumberer(), //自动行号
		                    {
		                        header: '商品代码',
		                        dataIndex: 'ProductCode',
		                        id: 'ProductCode',
		                        width:80
		                    },
		                    {
		                        header: '名称',
		                        dataIndex: 'ProductName',
		                        id: 'ProductName',
		                        width:180
		                    },
		                    {
		                        header: '单位',
		                        dataIndex: 'UnitName',
		                        id: 'UnitName',
		                        width:50
		                    },
		                    {
		                        header: '规格',
		                        dataIndex: 'SpecName',
		                        id: 'SpecName',
		                        width:60
		                    },
		                    {
		                        header: '退货单位',
		                        dataIndex: 'UnitId',
		                        id: 'UnitId',
		                        editor: UnitCombo1,
		                        renderer: function(value, cellmeta, record, rowIndex, columnIndex, store) {
		                            //var index = dsUnitList.find('UnitId', value);
		                            var index = dsUnitList.findBy(function(record, id) {
		                                return record.get(UnitCombo.valueField) == value;
		                            });
		                            if (index < 0)
		                                return "";
		                            var record = dsUnitList.getAt(index);
		                            return record.data.UnitName;
		                        }
		                    },
		                    {
		                        header: '退货数量',
		                        dataIndex: 'ReturnQty',
		                        id: 'ReturnQty',
		                        editor: new Ext.form.NumberField({ allowBlank: false }),
		                        renderer: function(v, m) {
		                            m.css = 'x-grid-back-blue';
		                            return v;
		                        },
		                        align: 'right',
		                        width:80
		                    },
		                    {
		                        header: '单价',
		                        dataIndex: 'Price',
		                        id: 'Price',
		                        editor: new Ext.form.NumberField({ allowBlank: false,
		                        decimalPrecision:8 }),
		                        renderer: function(v, m) {
		                            m.css = 'x-grid-back-blue';
		                            return v;
		                        },
		                        align: 'right',
		                        width:80
		                    },
		                    {
		                        header: '税率',
		                        dataIndex: 'Rate',
		                        id: 'Rate',
		                        width:40
		                    }

		                    ]),
            bbar: new Ext.PagingToolbar({
                pageSize: 10,
                store: ModDtlGridData,
                displayMsg: '显示第{0}条到{1}条记录,共{2}条',
                emptyMsy: '没有记录',
                displayInfo: true
            }),
            viewConfig: {
                columnsText: '显示的列',
                scrollOffset: 20,
                sortAscText: '升序',
                sortDescText: '降序',
                forceFit: false
            },
            closeAction: 'hide',
            stripeRows: true,
            clicksToEdit: 1,
            loadMask: true//,
           // autoExpandColumn: 2

        });
        ModOrderDtlGrid.on("afterrender", function(component) {
            component.getBottomToolbar().refresh.hideParent = true;
            component.getBottomToolbar().refresh.hide();
        });

        ModOrderDtlGrid.on("beforeedit", modBeforeEdit, ModOrderDtlGrid);
        function modBeforeEdit(e) {
            var record = e.record;
            if (record.data.ProductId != dsProductUnits.baseParams.ProductId
                && record.data.ProductId>0) {
                dsProductUnits.baseParams.ProductId = record.data.ProductId;
                dsProductUnits.load();
            }
        }

        if (typeof (openModWin) == "undefined") {//解决创建2个windows问题
            openModWin = new Ext.Window({
                id: 'openModWin',
                title: '退货单维护'
		            , iconCls: 'upload-win'
		            , width: 750
		            , height: 350
		            , layout: 'form'
		            , plain: true
		            , modal: true
		            , constrain: true
		            , resizable: false
		            , closeAction: 'hide'
		            , autoDestroy: true
		            , items: [

                         { layout: 'form',
                             border: false,
                             columnWidth: 1,
                             items: [modDtlForm]
                         },
                         { layout: 'form',
                             border: false,
                             columnWidth: 1,
                             items: [ModOrderDtlGrid]
                         }

		            ]
		            , buttons: [{
		                text: "保存"
			            , handler: function() {
			                saveUpdate();
			            }
			            , scope: this
		            },
		            {
		                text: "取消"
			            , handler: function() {
			                openModWin.hide();
			                MstGridData.reload();
			            }
			            , scope: this
}]
            });
        }
        openModWin.addListener("hide", function() {
        });



        ////////////////////////End 修改界面///////////////////////////////////////////////////////////////////////




    })
</script>

</html>

