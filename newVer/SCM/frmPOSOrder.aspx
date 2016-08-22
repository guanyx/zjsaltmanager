<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmPOSOrder.aspx.cs" Inherits="SCM_frmPOSOrder" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html>
<head>
<title>零售订单管理</title><meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<link rel="stylesheet" type="text/css" href="../ext3/resources/css/ext-all.css" />
<link rel="stylesheet" href="../css/orderdetail.css"/>
<link rel="stylesheet" type="text/css" href="../Theme/1/css/salt.css" />
<script type="text/javascript" src="../ext3/adapter/ext/ext-base.js"></script>
<script type="text/javascript" src="../ext3/ext-all.js"></script>
<script type="text/javascript" src="../js/operateResp.js"></script>
<script type="text/javascript" src="../js/floatUtil.js"></script>
<script type="text/javascript" src="../js/ExtJsHelper.js"></script>
<script type="text/javascript" src="../js/ExtFix.js"></script>
<script type="text/javascript" src="../ext3/src/locale/ext-lang-zh_CN.js"></script>

</head>
<body>
<div id='toolbar'></div>
<div id='divSearchForm'></div>
<div id='divDataGrid'></div>
<%--<object id="drawcontrol" classid="http:../WinWebPrintControl.dll#WinWebPrintControl.UserControl1" height=0px width=0px VIEWASTEXT>
    <param name='Url' value='http://172.18.2.122/printtest/xml' />
    <param name='MapUrl' value='http://172.18.2.122/printtest/xml/ckpddprint.xml' />
    </object>--%>
</body>
<%=getComboBoxStore()%>
<script type="text/javascript">
var version =parseFloat(navigator.appVersion.split("MSIE")[1]);
if(version == 6)
    version = 1;
else //!ie6 contain double size
    version = 3.1;
var OrderMstGridData=null;
Ext.BLANK_IMAGE_URL = "../ext3/resources/images/default/s.gif";  //作为：让下拉框的三角形下拉图片显示
Ext.onReady(function() {
    
    var saveType="";
    
        /*------实现toolbar的函数 start---------------*/
        var Toolbar = new Ext.Toolbar({
            renderTo: "toolbar",
            items: [{
                text: "新增",
                icon: "../Theme/1/images/extjs/customer/add16.gif",
                handler: function() { saveType="Add"; openAddOrderWin(); }
            }, '-', {
                text: "编辑",
                icon: "../Theme/1/images/extjs/customer/edit16.gif",
                handler: function() { saveType="Update"; modifyOrderWin(); }
            }, '-', {
                text: "删除",
                icon: "../Theme/1/images/extjs/customer/delete16.gif",
                handler: function() {deleteOrder();  }
            }, '-', {
                text: "打印",
                icon: "../Theme/1/images/extjs/customer/edit16.gif",
                handler: function() { 
                    printOrderById();
                
                }
            }, '-', {
                text: "收款",
                icon: "../Theme/1/images/extjs/customer/edit16.gif",
                handler: function() { AcctRece();  }
            }, '-', {
                text: "取消收款",
                icon: "../Theme/1/images/extjs/customer/edit16.gif",
                handler: function() { CancelAcctRece();  }
            }, '-', {
                text: "开票",
                icon: "../Theme/1/images/extjs/customer/edit16.gif",
                handler: function() {  generBill(); }
            }, '-', {
                text: "取消开票",
                icon: "../Theme/1/images/extjs/customer/edit16.gif",
                handler: function() { CancelBill();  }
            }, '-', {
                text: "出库",
                icon: "../Theme/1/images/extjs/customer/edit16.gif",
                handler: function() { OutStore();  }
            }, '-', {
                text: "用途设置",
                icon: "../Theme/1/images/extjs/customer/edit16.gif",
                handler: function() {  
                    productUseAdd();
                }
                <% if(ZJSIG.UIProcess.UIProcessBase.LodopPrintOn(this)) {%>
            }, '-', {
                text: "打印(P)",
                icon: "../Theme/1/images/extjs/customer/edit16.gif",
                handler: function() { 
                    printOrderByLodop("v1");
                
                }
                 <%} %>
            }
            ]
            });
            
             var productUseAddWin = null;
function productUseAdd()
{
    var record=OrderMstGrid.getSelectionModel().getSelections();
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
        orderIds += record[i].get('OrderId');
    }
    if(productUseAddWin==null)
    {
        productUseAddWin = ExtJsShowWin('订单产品用途信息设置','../../Common/frmOrderDtailUpdate.aspx?formType=productuse&OrderIds='+orderIds,'productUse',600,450);
        productUseAddWin.show();
    }
    else
    {
        productUseAddWin.show();
        document.getElementById("iframeproductUse").contentWindow.loadData(orderIds);
    } 
}
            /*------结束toolbar的函数 end---------------*/
//取消收款
            function CancelBill()
            {
                var sm = OrderMstGrid.getSelectionModel();
                //多选
                var selectData = sm.getSelections();          
                if(selectData.length==0)
                {
                    return;
                }      
                
                if(selectData[0].get('IsBill')==0)
                {
                    Ext.Msg.alert("提示", "订单："+selectData[0].get('OrderNumber')+"还没有开票！");
                    return;
                }
                 //然后传入参数保存
                Ext.Ajax.request({
                    url: 'frmOrderMst.aspx?method=cancelbill',
                    method: 'POST',
                    params: {
                        //主参数
                        OrderId:selectData[0].get('OrderId')
                        },
                    success: function(resp,opts){ 
                                    if( checkExtMessage(resp) )
                                         {
                                           OrderMstGridData.reload();
                                         }
                                   },
		            failure: function(resp,opts){  
		                Ext.Msg.alert("提示","取消失败");     
		            } 
		            });               
            }
            //取消收款
            function CancelAcctRece()
            {
                var sm = OrderMstGrid.getSelectionModel();
                //多选
                var selectData = sm.getSelections();          
                if(selectData.length==0)
                {
                    return;
                }      
                
                if(selectData[0].get('IsPayed')==0)
                {
                    Ext.Msg.alert("提示", "订单："+selectData[0].get('OrderNumber')+"还没有结款！");
                    return;
                }
                 //然后传入参数保存
                Ext.Ajax.request({
                    url: 'frmOrderMst.aspx?method=cancelaccrect',
                    method: 'POST',
                    params: {
                        //主参数
                        OrderId:selectData[0].get('OrderId')
                        },
                    success: function(resp,opts){ 
                                    if( checkExtMessage(resp) )
                                         {
                                           OrderMstGridData.reload();
                                         }
                                   },
		            failure: function(resp,opts){  
		                Ext.Msg.alert("提示","取消失败");     
		            } 
		            });               
            }

            /*------开始ToolBar事件函数 start---------------*//*-----新增Order实体类窗体函数----*/
            function openAddOrderWin() {

                uploadOrderWindow.show();
                if(document.getElementById("editIFrame").src.indexOf("frmPOSOrderEdit")==-1)
                {                
                    document.getElementById("editIFrame").src = "frmPOSOrderEdit.aspx?OpenType=oper&id=0" ;
                }
                else{
                    document.getElementById("editIFrame").contentWindow.OrderId=0;
                    document.getElementById("editIFrame").contentWindow.setFormValues();
                    document.getElementById("editIFrame").contentWindow.OpenType='oper';
                }
                
                //uploadOrderWindow.show();
                //document.getElementById("editIFrame").src = "frmPOSOrderEdit.aspx?OpenType=oper&id=0";
            }
            
            function getSelectOrderId() {

            }
            
            function getUrl(imageUrl)
            {
                var index = window.location.href.toLowerCase().indexOf('/scm/');
                var tempUrl = window.location.href.substring(0,index);
                return tempUrl+"/"+imageUrl;
            }
            
            function printOrderById()
            {
                var sm = OrderMstGrid.getSelectionModel();
                //多选
                var selectData = sm.getSelections();      
                if(selectData.length<=0) return;          
                var array = new Array(selectData.length);
                var orderIds = "";
                for(var i=0;i<selectData.length;i++)
                {
                    if(orderIds.length>0)
                        orderIds+=",";
                    orderIds += selectData[i].get('OrderId');
                    if(selectData[i].get('PrintNum')>0){
                        if(!confirm(selectData[i].get('OrderNumber')+'已经打印，是否还要继续打印？'))
                            return;
                    }
                }
                //页面提交
                Ext.Ajax.request({
                    url: 'frmOrderMst.aspx?method=printdate',
                    method: 'POST',
                    params: {
                        OrderId: orderIds
                    },
                   success: function(resp,opts){ 
                       var printData =  resp.responseText;
                       var printControl =  parent.parent.parent.document.getElementById("topFrame").contentWindow.getPrintControl();
                       printControl.Url =getUrl('xml');
                       printControl.MapUrl = printControl.Url+"/"+printStyleXml;
                       printControl.PrintXml = printData;
                       printControl.ColumnName="OrderId";
                       printControl.OnlyData=printOnlyData;
                       printControl.PageWidth=printPageWidth;
                       printControl.PageHeight =printPageHeight ;
                       printControl.Print();
                       
                       //页面提交
                       Ext.Ajax.request({
                           url: 'frmOrderMst.aspx?method=print',
                           method: 'POST',
                           params: {
                               OrderId: orderIds
                           },
                          success: function(resp,opts){ /* checkExtMessage(resp) */ },
		                  failure: function(resp,opts){  /* Ext.Msg.alert("提示","保存失败"); */    }
                       });
                       
                   },
		           failure: function(resp,opts){  /* Ext.Msg.alert("提示","保存失败"); */    }
                });
            }
            
            function printOrderByLodop(printType){
                var sm = OrderMstGrid.getSelectionModel();
                //多选
                var selectData = sm.getSelections();      
                if(selectData.length<=0) return;          
                var array = new Array(selectData.length);
                var orderIds = "";
                for(var i=0;i<selectData.length;i++)
                {
                    if(orderIds.length>0)
                        orderIds+=",";
                    orderIds += selectData[i].get('OrderId');
                    if(selectData[i].get('PrintNum')>0){
                        if(!confirm(selectData[i].get('OrderNumber')+'已经打印，是否还要继续打印？'))
                            return;
                    }
                }
                //页面提交
                Ext.Ajax.request({
                    url: 'frmOrderMst.aspx?method=getPrintDataStr',
                    method: 'POST',
                    params: {
                        OrderId: orderIds,
                        printType: printType
                    },
                   success: function(resp,opts){ 
                       var printData =  resp.responseText;   
                       if(printData != null && printData != ""){  
                            var resu = Ext.decode(printData);
                            if(resu.NoPrintStyle){ 
                                alert("未设置打印格式，请联系集团公司！");
                                return;
                            }
                            var arrayPrintData = resu.PrintDataArray;
                            var LODOP=getLodop(); 	
                            LODOP.PRINT_INIT("saleprint");
                            LODOP.SET_PRINT_PAGESIZE(1,resu.PrintPageWidth,resu.PrintPageHeight,"Letter");
                            //LODOP.ADD_PRINT_HTM(0,0,resu.PrintPageWidth+"px",resu.PrintPageHeight+"px","新版打印功能正在开发中，敬请期待~");
                            LODOP.ADD_PRINT_HTM(0,0,resu.PrintPageWidth,resu.PrintPageHeight,arrayPrintData[0].data);
                            if(arrayPrintData.length>1){
                               for(var i=1;i<arrayPrintData.length;i++){
		                           LODOP.NewPage();     
                                   LODOP.ADD_PRINT_HTM(0,0,resu.PrintPageWidth,resu.PrintPageHeight,arrayPrintData[i].data);                    
		                       } 
                            }
                            /*
                            LODOP.ADD_PRINT_HTM(0,0,resu.PrintPageWidth+"px",resu.PrintPageHeight+"px",arrayStr[0]); 
                            for(var i=1;i<arrayStr.length;i++){
		                        LODOP.NewPage();     
                                LODOP.ADD_PRINT_HTM(0,0,resu.PrintPageWidth+"px",resu.PrintPageHeight+"px",arrayStr[i]);                    
		                    } 
		                    */                            
                            LODOP.SET_SHOW_MODE("NP_NO_RESULT",true);
                            LODOP.PREVIEW();
                       }
                       
                       
//                       //页面提交
//                       Ext.Ajax.request({
//                           url: 'frmOrderMst.aspx?method=print',
//                           method: 'POST',
//                           params: {
//                               OrderId: orderIds
//                           },
//                          success: function(resp,opts){ /* checkExtMessage(resp) */ },
//		                  failure: function(resp,opts){  /* Ext.Msg.alert("提示","保存失败"); */    }
//                       });
                       
                   },
		           failure: function(resp,opts){  /* Ext.Msg.alert("提示","保存失败"); */    }
                });
            }
            
            /*-----删除Order实体函数----*/
            function deleteOrder() {
                var sm = OrderMstGrid.getSelectionModel();
                //多选
                var selectData = sm.getSelections();                
                var array = new Array(selectData.length);
                for(var i=0;i<selectData.length;i++)
                {
                    array[i] = selectData[i].get('OrderId');
                }

                //如果没有选择，就提示需要选择数据信息
                if (selectData == null || selectData == "") {
                    Ext.Msg.alert("提示", "请选中需要操作的记录！");
                    return;
                }
                
                if (array.length != 1) {
                    Ext.Msg.alert("提示", "请选中一条记录！");
                    return;
                }
                
                //删除前再次提醒是否真的要删除
                Ext.Msg.confirm("提示信息", "是否真的要删除选择的记录吗？", function callBack(id) {
                    //判断是否删除数据
                    if (id == "yes") {
                        //页面提交
                        Ext.Ajax.request({
                            url: 'frmOrderMst.aspx?method=Delete',
                            method: 'POST',
                            params: {
                                OrderId: array[0]
                            },
                            success: function(resp,opts){  checkExtMessage(resp);OrderMstGridData.reload();  },
		                    failure: function(resp,opts){  Ext.Msg.alert("提示","保存失败");     }
                        });
                    }
                });
            }
            
            //收款功能
            function OutStore()
            {
                var sm = OrderMstGrid.getSelectionModel();
                //多选
                var selectData = sm.getSelections();     
                
                //如果没有选择，就提示需要选择数据信息
                if (selectData == null || selectData == "") {
                    Ext.Msg.alert("提示", "请选择需要出库的订单信息！");
                    return;
                }         
                var array = new Array(selectData.length);
                var sumAmt = 0;
                var strOrderId = "";
                var saletotalamt = 0;
                for(var i=0;i<selectData.length;i++)
                {
                    array[i] = selectData[i].get('OrderId');
                    saletotalamt = selectData[i].get('SaleTotalAmt');
                    sumAmt =  accAdd(sumAmt,saletotalamt);//总额
                    strOrderId = strOrderId + array[i] + ",";//字符串
                    
                    if(parseInt(selectData[i].get('Status'))>2)
                    {
                        Ext.Msg.alert("提示", "订单号为"+selectData[i].get('OrderNumber')+"的订单已经出库，请确认！");
                        return;
                    }
                }
                
                strOrderId = strOrderId.substring(0, strOrderId.length - 1);
                
                //页面提交
                Ext.Ajax.request({
                    url: 'frmOrderMst.aspx?method=outstore',
                    method: 'POST',
                    params: {
                        strOrderId: strOrderId
                    },
                   success: function(resp,opts){ 
                      if( checkExtMessage(resp) )
                      {
                        OrderMstGridData.reload();
                      }
                       
                   },
		           failure: function(resp,opts){  /* Ext.Msg.alert("提示","保存失败"); */    }
                });                          
                
            }
            
            //收款功能
            function AcctRece()
            {
                var sm = OrderMstGrid.getSelectionModel();
                //多选
                var selectData = sm.getSelections();                
                var array = new Array(selectData.length);
                var sumAmt = 0;
                var strOrderId = "";
                var saletotalamt = 0;
                for(var i=0;i<selectData.length;i++)
                {
                    array[i] = selectData[i].get('OrderId');
                    saletotalamt = selectData[i].get('SaleTotalAmt');
                    sumAmt=sumAmt.add(saletotalamt);
                    //sumAmt =  accAdd(sumAmt,saletotalamt);//总额
                    strOrderId = strOrderId + array[i] + ",";//字符串
                    sumAmt = Math.round(sumAmt*100)/100;
                    if(selectData[i].get('IsPayed')>0)
                    {
                        Ext.Msg.alert("提示", "订单："+selectData[i].get('OrderNumber')+"已结款！");
                        return;
                    }
                }
                
                strOrderId = strOrderId.substring(0, strOrderId.length - 1);

                //如果没有选择，就提示需要选择数据信息
                if (selectData == null || selectData == "") {
                    Ext.Msg.alert("提示", "请选中需要操作的记录！");
                    return;
                }
                
                openAcctWindow.show();
                //收款后确认订单完成
                document.getElementById("acctIFrame").src = "frmScmAcctRece.aspx?sumAmt=" + sumAmt + "&strOrderId=" + strOrderId;
                
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
               document.getElementById("acctIFrame").src = "frmScmAcctRece.aspx?umAmt=0&strOrderId=0";//清楚其内容，建议在子页面提供一个方法来调用
            });
            
            
            //开票功能
            function generBill()
            {
                var sm = OrderMstGrid.getSelectionModel();
                var selectData = sm.getSelections();    
                //如果没有选择，就提示需要选择数据信息
                if (selectData == null || selectData == "") {
                    Ext.Msg.alert("提示", "请选中需要操作的记录！");
                    return;
                }
                
                var array = new Array(selectData.length);
                var strOrderId = "";//订单ID
                var customerid = 0;//客户
                var customername = "";//客户名称
                var isbill = 0;//是否已开票
                var isdiff = 0;
                
                var kpfs = "S031";//普通发票                
                kpfs = selectData[0].get('BillMode'); 
                customerid = selectData[0].get('CustomerId'); 
                customername = selectData[0].get('CustomerName'); 
                for(var i=0;i<selectData.length;i++)
                {
                    array[i] = selectData[i].get('OrderId');
                    strOrderId = strOrderId + array[i] + ",";//字符串
                    if (i != 0)
                    {
                        if (kpfs != selectData[i].get('BillMode')) 
                        {
                            Ext.Msg.alert("提示", "请选择相同的开票方式的订单!");
                            return;
                        }
                        if (customername != selectData[i].get('CustomerName')) 
                        {
                            //Ext.Msg.alert("提示", "请输入客户名称!");
                            customername = "";
                            customerid = -1;
                            isdiff = 1;
                        }
                    }
                    
                    isbill = selectData[0].get('IsBill'); 
                    if (isbill == 1)
                    {
                        Ext.Msg.alert("提示", "请选择未开票订单记录!");
                        return;
                    }
                }                
                strOrderId = strOrderId.substring(0, strOrderId.length - 1);
                
                if(isdiff == 1){
                    Ext.Msg.confirm("提示信息", "存在多个客户的订单，是否继续生成开票记录记录？", function callBack(id) {
                        //判断是否删除数据
                        if (id == "yes") {
                            openBillWindow.show();
                            document.getElementById("billIFrame").src = "frmBillEdit.aspx?strCustomerid=" + customerid + "&strCustomername=" + escape(customername) + "&kpfs=" + kpfs + "&strOrderId=" + strOrderId;
                        }
                    });
                }else{   
                    openBillWindow.show();
                    document.getElementById("billIFrame").src = "frmBillEdit.aspx?strCustomerid=" + customerid + "&strCustomername=" + escape(customername) + "&kpfs=" + kpfs + "&strOrderId=" + strOrderId;
                }
                
                
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
               OrderMstGridData.reload();
               document.getElementById("billIFrame").src = "frmBillEdit.aspx?strCustomerid=0&strCustomername=0&kpfs=0&strOrderId=0";
            });
            
            if (typeof (uploadOrderWindow) == "undefined") {//解决创建2个windows问题
                            uploadOrderWindow = new Ext.Window({
                                id: 'Orderformwindow',
                                iconCls: 'upload-win'
		                        , width: 750
		                        , height: 520
		                        , plain: true
		                        , modal: true
		                        , constrain: true
		                        , resizable: false
		                        , closeAction: 'hide'
		                        , autoDestroy: true
		                        , html: '<iframe id="editIFrame" width="100%" height="100%" border=0 src=""></iframe>' 
                                
                            });
                        }
                        uploadOrderWindow.addListener("hide", function() {
                           //document.getElementById("editIFrame").src = "frmOrderDtl.aspx?OpenType=oper&id=0";//清楚其内容，建议在子页面提供一个方法来调用
                        });
                        
            /*-----编辑Order实体类窗体函数----*/
            function modifyOrderWin() {
                var sm = OrderMstGrid.getSelectionModel();
                //多选
                var selectData = sm.getSelections();                
                var array = new Array(selectData.length);
                var status = 1;
                for(var i=0;i<selectData.length;i++)
                {
                    array[i] = selectData[i].get('OrderId');
                    status = selectData[i].get('Status');
                }

                //如果没有选择，就提示需要选择数据信息
                if (selectData == null || selectData == "") {
                    Ext.Msg.alert("提示", "请选中需要操作的记录！");
                    return;
                }
                
                if (array.length != 1) {
                    Ext.Msg.alert("提示", "请选中一条记录！");
                    return;
                }
                
                if (status != 1)
                {
                    Ext.Msg.alert("提示", "订单已审或者已出库，不允许修改！");
                    return;
                }
                
                
                uploadOrderWindow.show();
                if(document.getElementById("editIFrame").src.indexOf("frmPOSOrderEdit")==-1)
                {                
                    document.getElementById("editIFrame").src = "frmPOSOrderEdit.aspx?OpenType=oper&id=" + selectData[0].data.OrderId;
                }
                else{
                    document.getElementById("editIFrame").contentWindow.OrderId=selectData[0].data.OrderId;
                    document.getElementById("editIFrame").contentWindow.setFormValues();
                    document.getElementById("editIFrame").contentWindow.OpenType='oper';
                }
            }
                       
            function QueryDataGrid() {
                OrderMstGridData.baseParams.OrgId=Ext.getCmp('OrgId').getValue();
                OrderMstGridData.baseParams.OutStor=Ext.getCmp('OutStor').getValue();
                OrderMstGridData.baseParams.OutStor=Ext.getCmp('OutStor').getValue();		                
                OrderMstGridData.baseParams.CustomerId=Ext.getCmp('CustomerId').getValue();
                OrderMstGridData.baseParams.IsPayed=Ext.getCmp('IsPayed').getValue();
                OrderMstGridData.baseParams.IsBill=Ext.getCmp('IsBill').getValue();	                
                OrderMstGridData.baseParams.OrderType=Ext.getCmp('OrderType').getValue();
                OrderMstGridData.baseParams.PayType=Ext.getCmp('PayType').getValue();
                OrderMstGridData.baseParams.BillMode=Ext.getCmp('BillMode').getValue();		                
                OrderMstGridData.baseParams.DlvType=Ext.getCmp('DlvType').getValue();
                OrderMstGridData.baseParams.DlvLevel=Ext.getCmp('DlvLevel').getValue();
                OrderMstGridData.baseParams.IsDel=isDel.getValue();		                
                OrderMstGridData.baseParams.StartDate=Ext.util.Format.date(Ext.getCmp('StartDate').getValue(),'Y/m/d');
                OrderMstGridData.baseParams.EndDate=Ext.util.Format.date(Ext.getCmp('EndDate').getValue(),'Y/m/d');
                OrderMstGridData.baseParams.IsOutStor=isOutStor.getValue();
                OrderMstGridData.baseParams.CustomerServer=1;
                OrderMstGridData.load({
                    params: {
                        start: 0,
                        limit: defaultPageSize
                    }
                });
            }
            

              //仓库
               var ck = new Ext.form.ComboBox({
                   xtype: 'combo',
                   store: dsWareHouse,
                   valueField: 'WhId',
                   displayField: 'WhName',
                   mode: 'local',
                   forceSelection: true,
                   editable: false,
                   name:'OutStor',
                   id:'OutStor',
                   emptyValue: '',
                   triggerAction: 'all',
                   fieldLabel: '仓库',
                   selectOnFocus: true,
                   anchor: '90%',
				   editable:false
               });
               //配送方式
               var psfs = new Ext.form.ComboBox({
                   xtype: 'combo',
                   store: dsDlvType,
                   valueField: 'DicsCode',
                   displayField: 'DicsName',
                   mode: 'local',
                   forceSelection: true,
                   editable: false,
                   emptyValue: '',
                   triggerAction: 'all',
                   fieldLabel: '配送方式',
                    name:'DlvType',
                   id:'DlvType',
                   selectOnFocus: true,
                   anchor: '90%',
				   editable:false
               });               
               
               //开始日期
               var ksrq = new Ext.form.DateField({
           		    xtype:'datefield',
			        fieldLabel:'开始日期',
			        anchor:'90%',
			        name:'StartDate',
			        id:'StartDate',
			        format: 'Y年m月d日',  //添加中文样式
                    value:new Date().clearTime() 
               });
               
               //结束日期
               var jsrq = new Ext.form.DateField({
           		    xtype:'datefield',
			        fieldLabel:'结束日期',
			        anchor:'90%',
			        name:'EndDate',
			        id:'EndDate',
			        format: 'Y年m月d日',  //添加中文样式
                    value:new Date().clearTime()
               });
               
               //送货等级
               var shdj = new Ext.form.ComboBox({
                   xtype: 'combo',
                   store: dsDlvLevel,
                   valueField: 'DicsCode',
                   displayField: 'DicsName',
                   mode: 'local',
                   forceSelection: true,
                   editable: false,
                   emptyValue: '',
                   triggerAction: 'all',
                   fieldLabel: '送货等级',
                    name:'DlvLevel',
                   id:'DlvLevel',
                   selectOnFocus: true,
                   anchor: '90%',
				   editable:false
               });
               
               //结算方式
               var jsfs = new Ext.form.ComboBox({
                   xtype: 'combo',
                   store:dsBillMode,
                   valueField: 'DicsCode',
                   displayField: 'DicsName',
                   mode: 'local',
                   forceSelection: true,
                   editable: false,
                   emptyValue: '',
                   triggerAction: 'all',
                   fieldLabel: '结算方式',
                   name:'PayType',
                   id:'PayType',
                   selectOnFocus: true,
                   anchor: '90%',
				   editable:false
               });
               //开票方式
                var kpfs = new Ext.form.ComboBox({
                   xtype: 'combo',
                   store: dsPayType,
                   valueField: 'DicsCode',
                   displayField: 'DicsName',
                   mode: 'local',
                   forceSelection: true,
                   editable: false,
                   emptyValue: '',
                   triggerAction: 'all',
                   fieldLabel: '开票方式',
                   name:'BillMode',
                   id:'BillMode',
                   selectOnFocus: true,
                   anchor: '90%',
				   editable:false
               });
                //订单类型
                var ddlx = new Ext.form.ComboBox({
                   xtype: 'combo',
                   store: dsOrderType,
                   valueField: 'DicsCode',
                   displayField: 'DicsName',
                   mode: 'local',
                   forceSelection: true,
                   editable: false,
                   emptyValue: '',
                   triggerAction: 'all',
                   fieldLabel: '订单类型',
                   name:'OrderType',
                   id:'OrderType',
                   selectOnFocus: true,
                   anchor: '90%',
				   editable:false,
				   value:'S016',
				   disabled:true
               });
               
               //公司下拉框
               var gs = new Ext.form.ComboBox({
                    xtype:'combo',
                    fieldLabel:'公司标识',
                    anchor:'90%',
                    name:'OrgId',
                    id:'OrgId',
                    store: dsOrg,
                    displayField: 'OrgName',  //这个字段和业务实体中字段同名
                    valueField: 'OrgId',      //这个字段和业务实体中字段同名
                    typeAhead: true, //自动将第一个搜索到的选项补全输入
                    triggerAction: 'all',
                    emptyValue: '',
                    selectOnFocus: true,
                    forceSelection: true,
				    editable:false,
                    mode:'local'        //这个属性设定从本页获取数据源，才能够赋值定位
               })
               
               //部门下拉框
               var bm = new Ext.form.ComboBox({
                    xtype:'combo',
                    fieldLabel:'部门',
                    anchor:'90%',
                    name:'QryDeptID',
                    id:'QryDeptID',
                    store:dsDept,
                    displayField: 'DeptName',  //这个字段和业务实体中字段同名
                    valueField: 'DeptId',      //这个字段和业务实体中字段同名
                    typeAhead: true, //自动将第一个搜索到的选项补全输入
                    triggerAction: 'all',
                    emptyValue: '',
                    selectOnFocus: true,
                    forceSelection: true,
                    editable:false,
                    mode:'local'        //这个属性设定从本页获取数据源，才能够赋值定位
               })
               
               //是否出库
               var isOutStor = new Ext.form.ComboBox({
                    xtype:'combo',
                    fieldLabel:'是否出库',
                    anchor:'90%',
                    name:'IsOutStor',
                    id:'IsOutStor',
                    store:[['','全部'],['0','未出库'],['1','已出库']],
                    triggerAction: 'all',
                    emptyValue: '',
                    selectOnFocus: true,
                    forceSelection: true,
                    editable:false,
                    mode:'local'        //这个属性设定从本页获取数据源，才能够赋值定位
               })
               
               //是否删除
               var isDel = new Ext.form.ComboBox({
                    xtype:'combo',
                    fieldLabel:'订单状态',
                    anchor:'90%',
                    name:'isDel',
                    id:'isDel',
                    store:[['','全部'],['1','正常'],['0','已删除']],
                    triggerAction: 'all',
                    emptyValue: '',
                    selectOnFocus: true,
                    forceSelection: true,
                    editable:false,
                    mode:'local'        //这个属性设定从本页获取数据源，才能够赋值定位
               })
               
               var serchform = new Ext.FormPanel({
                    renderTo: 'divSearchForm',
                    labelAlign: 'left',
//                    layout: 'fit',
                    buttonAlign: 'center',
                    bodyStyle: 'padding:5px',
                    frame: true,
                    labelWidth: 55,
	                items:[
	                {
		                layout:'column',
		                border: false,
		                labelSeparator: '：',
		                items: [
		                {
			                layout:'form',
			                border: false,
			                columnWidth:0.33,
			                items: [gs]
		                }
                ,		{
                            layout:'form',
			                border: false,
			                columnWidth:0.33,
			                items:[
			                {
                            layout:'column',
		                    border: false,
		                    labelSeparator: '：',
		                    items: [
			                {
			                    layout:'form',
			                    border: false,
			                    columnWidth:0.274*version,
			                    items: [
			                    {
				                    xtype:'textfield',
				                    fieldLabel:'客户',
				                    anchor:'99%',
				                    name:'CustomerId',
				                    id:'CustomerId'
				                }
			                    ]
			                },
			                {
                               layout: 'form',
                               columnWidth: .03*version,  //该列占用的宽度，标识为20％
                               border: false,
                               items: [
                               {
                                    xtype:'button', 
                                    iconCls:"find",
                                    autoWidth : true,
                                    autoHeight : true,
                                    hideLabel:true,
                                    listeners:{
                                        click:function(v){
                                              getCustomerInfo(function(record){Ext.getCmp('CustomerId').setValue(record.data.ShortName); },gs.getValue());    
                                        }
                                    }
                               }]
                           }]
                        }]
		                }
                ,		{
			                layout:'form',
			                border: false,
			                columnWidth:0.34,
			                items: [ck]
		                }
	                ]},
	                {
		                layout:'column',
		                border: false,
		                labelSeparator: '：',
		                items: [
		                {
			                layout:'form',
			                border: false,
			                columnWidth:0.33,
			                items: [psfs]
		                }		                
                ,		{
			                layout:'form',
			                border: false,
			                columnWidth:0.33,
			                items: [
				                {
					                xtype:'combo',
					                fieldLabel:'是否结款',
					                columnWidth:0.33,
					                anchor:'90%',
					                store:[['','全部'],['1','是'],['0','否']],
					                name:'IsPayed',
					                id:'IsPayed',
					                triggerAction:'all',
					                editable:false
				                }
		                ]
		                }
                ,		{
			                layout:'form',
			                border: false,
			                columnWidth:0.34,
			                items: [
				                {
					                xtype:'combo',
					                fieldLabel:'是否开票',
					                columnWidth:0.33,
					                anchor:'90%',
					                store:[['','全部'],['1','是'],['0','否']],
					                name:'IsBill',
					                id:'IsBill',
					                triggerAction:'all',
					                editable:false
				                }
		                ]
		                }
	                ]},
	                {
		                layout:'column',
		                border: false,
		                labelSeparator: '：',
		                items: [
		                {
			                layout:'form',
			                border: false,
			                columnWidth:0.33,
			                items: [ddlx]
		                }
                ,		{
			                layout:'form',
			                border: false,
			                columnWidth:0.33,
			                items: [jsfs]
		                }
                ,		{
			                layout:'form',
			                border: false,
			                columnWidth:0.34,
			                items: [kpfs]
		                }
	                ]},
	                {
		                layout:'column',
		                border: false,
		                labelSeparator: '：',
		                items: [
		                {
			                layout:'form',
			                border: false,
			                columnWidth:0.33,
			                items: [shdj]
		                },
		                {
			                layout:'form',
			                border: false,
			                columnWidth:0.33,
			                items: [
				                {
					                xtype:'datefield',
					                fieldLabel:'开始日期',
					                columnWidth:0.5,
					                anchor:'90%',
					                name:'StartDate',
					                id:'StartDate',
			                        format: 'Y年m月d日',  //添加中文样式
                                    value:new Date().getFirstDateOfMonth().clearTime()
				                }
		                            ]
		                }
                ,		{
			                layout:'form',
			                border: false,
			                columnWidth:0.34,
			                items: [
				                {
					                xtype:'datefield',
					                fieldLabel:'结束日期',
					                columnWidth:0.5,
					                anchor:'90%',
					                name:'EndDate',
					                id:'EndDate',
			                        format: 'Y年m月d日',  //添加中文样式
                                    value:new Date().clearTime()
				                }
		                            ]
		                }
	                ]}
	                ,{//第三行
                        layout:'column',
                        items:[
                            {//第一单元格
                                layout:'form',
                                border: false,
                                //labelWidth:70,
                                columnWidth:.33,
                                items:[isOutStor]
                            },
                            {//第二单元格
                                layout:'form',
                                border: false,
                                //labelWidth:70,
                                columnWidth:.33,
                                items:[isDel]
                            },
                            {//第二单元格
                                layout:'form',
                                border: false,
                                //labelWidth:70,
                                columnWidth:.17,
                                items:[{
                                       xtype:'button',
                                        text:'查询',
                                        width:70,
                                        //iconCls:'excelIcon',
                                        scope:this,
                                        handler:function(){
                                            QueryDataGrid();
                                        }
                                    }]
                            },
                            {//第三单元格
                                layout:'form',
                                border: false,
                                labelWidth:70,
                                columnWidth:0.17,
                                items:[
                                    {
                                       xtype:'button',
                                        text:'清空',
                                        width:70,
                                        //iconCls:'excelIcon',
                                        scope:this,
                                        handler:function(){
                                            Ext.getCmp('StartDate').setValue(new Date().getFirstDateOfMonth().clearTime());
                                            Ext.getCmp('EndDate').setValue(new Date().clearTime());
                                            shdj.setValue('');
                                            kpfs.setValue('');
                                            jsfs.setValue('');
//                                            ddlx.setValue('');
                                            Ext.getCmp('IsBill').setValue('');
                                            Ext.getCmp('IsPayed').setValue('');
                                            psfs.setValue('');
                                            ck.setValue('');
                                            Ext.getCmp('CustomerId');
                                            isDel.setValue('');
                                            isOutStor.setValue('');
                                        }
                                    }
                                    ]
                            }
                        ]
                    }
	                
	                
	                               
                ]
                
                });



                        /*------开始查询form的函数 end---------------*/

                        /*------开始界面数据的窗体 Start---------------*/
                        if (typeof (uploadOrderWindow) == "undefined") {//解决创建2个windows问题
                            uploadOrderWindow = new Ext.Window({
                                id: 'Orderformwindow',
                                iconCls: 'upload-win'
		                        , width: 750
		                        , height: 530
		                        , plain: true
		                        , modal: true
		                        , constrain: true
		                        , resizable: false
		                        , closeAction: 'hide'
		                        , autoDestroy: true
		                        , html: '<iframe id="editIFrame" width="100%" height="100%" border=0 src="frmPOSOrderEdit.aspx"></iframe>' 
                                
                            });
                        }
                        uploadOrderWindow.addListener("hide", function() {                            
                           //document.getElementById("editIFrame").src = "frmPOSOrderEdit.aspx?OpenType=oper&id=0";//清楚其内容，建议在子页面提供一个方法来调用                           
                        });

                        

                       
                        /*------开始获取数据的函数 start---------------*/
                        OrderMstGridData = new Ext.data.Store
                        ({
                            url: 'frmOrderMst.aspx?method=getOrderList',
                            reader: new Ext.data.JsonReader({
                                totalProperty: 'totalProperty',
                                root: 'root'
                            }, [
                                {
		                            name:'OrderId'
	                            },
	                            {
		                            name:'OrderNumber'
	                            },
	                            {
		                            name:'OrgId'
	                            },
	                            {
		                            name:'OrgName'
	                            },
	                            {
		                            name:'DeptId'
	                            },
	                            {
		                            name:'DeptName'
	                            },
	                            {
		                            name:'OutStor'
	                            },
	                            {
		                            name:'OutStorName'
	                            },
	                            {
		                            name:'CustomerId'
	                            },
	                            {
		                            name:'CustomerName'
	                            },
	                            {
		                            name:'DlvDate'
	                            },
	                            {
		                            name:'DlvAdd'
	                            },
	                            {
		                            name:'DlvDesc'
	                            },
	                            {
		                            name:'OrderType'
	                            },
	                            {
		                            name:'OrderTypeName'
	                            },
	                            {
		                            name:'PayType'
	                            },
	                            {
		                            name:'PayTypeName'
	                            },
	                            {
		                            name:'BillMode'
	                            },
	                            {
		                            name:'BillModeName'
	                            },
	                            {
		                            name:'DlvType'
	                            },
	                            {
		                            name:'DlvTypeName'
	                            },
	                            {
		                            name:'DlvLevel'
	                            },
	                            {
		                            name:'DlvLevelName'
	                            },
	                            {
		                            name:'Status'
	                            },
	                            {
		                            name:'StatusName'
	                            },
	                            {
		                            name:'IsPayed'
	                            },
	                            {
		                            name:'IsPayedName'
	                            },
	                            {
		                            name:'IsBill'
	                            },
	                            {
		                            name:'IsBillName'
	                            },
	                            {
		                            name:'SaleInvId'
	                            },
	                            {
		                            name:'SaleTotalQty'
	                            },
	                            {
		                            name:'OutedQty'
	                            },
	                            {
		                            name:'SaleTotalAmt'
	                            },
	                            {
		                            name:'SaleTotalTax'
	                            },
	                            {
		                            name:'DtlCount'
	                            },
	                            {
		                            name:'OperId'
	                            },
	                            {
		                            name:'OperName'
	                            },
	                            {
		                            name:'CreateDate'
	                            },
	                            {
		                            name:'UpdateDate'
	                            },
	                            {
		                            name:'OwnerId'
	                            },
	                            {
		                            name:'OwnerName'
	                            },
	                            {
		                            name:'BizAudit'
	                            },
	                            {
		                            name:'AuditDate'
	                            },
	                            {
		                            name:'Remark'
	                            },
	                            {
		                            name:'IsActive'
	                            },
	                            {
		                            name:'IsActiveName'
	                            },
	                            {
	                                name:'PrintNum'
	                            }	])
	                         
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
        store: OrderMstGridData,
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
        QueryDataGrid();
    }, toolBar);
    
                            function getStatusName(v){
			                        if(v>2)
			                            return '是';
			                        return '否';
			               }
                        /*------开始DataGrid的函数 start---------------*/

                        var sm = new Ext.grid.CheckboxSelectionModel({
                            singleSelect: false
                        });
                        var OrderMstGrid = new Ext.grid.GridPanel({
                            el: 'divDataGrid', 
                            height: '100%',
                            width: document.body.offsetWidth,
                            bodyStyle: 'padding:0px,0px,2px,0px',
                            monitorResize: true, 
                            columnLines:true,
                            //autoHeight: true,
                            autoScroll: true,
                            layout: 'fit',
                            id: '',
                            store: OrderMstGridData,
                            loadMask: { msg: '正在加载数据，请稍侯……' },
                            sm: sm,
                            cm: new Ext.grid.ColumnModel([
                            
		                    sm,
		                    new Ext.grid.RowNumberer(),//自动行号
		                    {
			                    header:'订单标识',
			                    dataIndex:'OrderId',
			                    id:'OrderId',
			                    hidden:true,
			                    width:0
		                    },
		                    {
			                    header:'订单编号',
			                    dataIndex:'OrderNumber',
			                    id:'OrderId',
			                    width:95
		                    },
//		                    {
//		                        header:'公司名称',
//			                    dataIndex:'OrgName',
//			                    id:'OrgName'
//		                    },
//		                    {
//		                        header:'销售部门',
//			                    dataIndex:'DeptName',
//			                    id:'DeptName'
//		                    },
		                    {
		                        header:'出库仓库',
			                    dataIndex:'OutStorName',
			                    id:'OutStorName',
			                    width:80
		                    },
		                    {
		                        header:'客户名称',
			                    dataIndex:'CustomerName',
			                    id:'CustomerName',
			                    width:150
		                    },
		                    {
			                    header:'送货日期',
			                    dataIndex:'DlvDate',
			                    id:'DlvDate',
			                    renderer: Ext.util.Format.dateRenderer('Y年m月d日'),
			                    width:100
		                    },
//		                    {
//		                        header:'订单类型',
//			                    dataIndex:'OrderTypeName',
//			                    id:'OrderTypeName',
//			                    width:60
//		                    },
//		                    {
//		                        header:'结算方式',
//			                    dataIndex:'PayTypeName',
//			                    id:'PayTypeName',
//			                    width:60
//		                    },
		                    {
		                        header:'开票方式',
			                    dataIndex:'BillModeName',
			                    id:'BillModeName',
			                    width:60
		                    },
		                    {
		                        header:'配送方式',
			                    dataIndex:'DlvTypeName',
			                    id:'DlvTypeName',
			                    width:60
		                    },
		                    {
		                        header:'是否出库',
			                    dataIndex:'Status',
			                    id:'Status',
			                    width:60,
			                    renderer:getStatusName
		                    },
		                    {
		                        header:'是否开票',
			                    dataIndex:'IsBillName',
			                    id:'IsBillName',
			                    width:60
		                    },
		                    {
		                        header:'是否结款',
			                    dataIndex:'IsPayedName',
			                    id:'IsPayedName',
			                    width:60
		                    },
//		                    {
//		                        header:'送货等级',
//			                    dataIndex:'DlvLevelName',
//			                    id:'DlvLevelName',
//			                    width:60,
//			                    hidden:true
//		                    },
//		                    {
//			                    header:'总重量',
//			                    dataIndex:'SaleTotalQty',
//			                    id:'SaleTotalQty',
//			                    width:50
//		                    },
		                    {
			                    header:'总金额',
			                    dataIndex:'SaleTotalAmt',
			                    id:'SaleTotalAmt',
			                    width:60
		                    },
		                    {
		                        header:'操作员',
			                    dataIndex:'OperName',
			                    id:'OperName',
			                    width:60
		                    },
		                    {
			                    header:'创建时间',
			                    dataIndex:'CreateDate',
			                    id:'CreateDate',
			                    renderer: Ext.util.Format.dateRenderer('m月d日'),
			                    width:85
		                    },
		                    {
		                        header:'打印次数',
		                        title:'该项仅供参考',
			                    dataIndex:'PrintNum',
			                    id:'PrintNum',
			                    width:55
		                        
		                    }		]),
                            bbar:toolBar,
                            viewConfig: {
                                columnsText: '显示的列',
                                scrollOffset: 20,
                                sortAscText: '升序',
                                sortDescText: '降序',
                                forceFit: false
                            },
                            height: 303,
                            closeAction: 'hide',
                            stripeRows: true,
                            loadMask: true
//                            autoExpandColumn: 2
                        });
                        OrderMstGrid.on("afterrender", function(component) {
                            component.getBottomToolbar().refresh.hideParent = true;
                            component.getBottomToolbar().refresh.hide(); 
                        });
                        
                        OrderMstGrid.on('render', function(grid) {
                var store = grid.getStore();  // Capture the Store.  
                var view = grid.getView();    // Capture the GridView.
                OrderMstGrid.tip = new Ext.ToolTip({
                    target: view.mainBody,    // The overall target element.  
                    delegate: '.x-grid3-row', // Each grid row causes its own seperate show and hide.  
                    trackMouse: true,         // Moving within the row should not hide the tip.  
                    renderTo: document.body,  // Render immediately so that tip.body can be referenced prior to the first show.  
                    listeners: {              // Change content dynamically depending on which element triggered the show.  
                        beforeshow: function updateTipBody(tip) {
                            var rowIndex = view.findRowIndex(tip.triggerElement);
                            
                            var element = document.elementFromPoint(tip.x-20, tip.y-20);
                             var v = view.findCellIndex(element);
                             if(v==2)
                             {
                              
                                if(showTipRowIndex == rowIndex)
                                    return;
                                else
                                    showTipRowIndex = rowIndex;
                                    
                                     tip.body.dom.innerHTML="正在加载数据……";
                                        //页面提交
                                        Ext.Ajax.request({
                                            url: 'frmOrderMst.aspx?method=getorderstateinfo',
                                            method: 'POST',
                                            params: {
                                                OrderId: grid.getStore().getAt(rowIndex).data.OrderId
                                            },
                                            success: function(resp, opts) {
                                                tip.body.dom.innerHTML = resp.responseText;
                                            },
                                            failure: function(resp, opts) {
                                                OrderMstGrid.tip.hide();
                                            }
                                        });
                                }//细项信息
                                else if(v==4)
                                {
                                    if(showTipRowIndex == rowIndex)
                                        return;
                                    else
                                        showTipRowIndex = rowIndex;
                                         tip.body.dom.innerHTML="正在加载数据……";
                                            //页面提交
                                            Ext.Ajax.request({
                                                url: 'frmOrderMst.aspx?method=getdetailinfo',
                                                method: 'POST',
                                                params: {
                                                    OrderId: grid.getStore().getAt(rowIndex).data.OrderId
                                                },
                                                success: function(resp, opts) {
                                                    tip.body.dom.innerHTML = resp.responseText;
                                                },
                                                failure: function(resp, opts) {
                                                    OrderMstGrid.tip.hide();
                                                }
                                            });
                                }                                
                                else
                                {
                                    OrderMstGrid.tip.hide();
                                }
                        }
                    }
                });
    });
    var showTipRowIndex =-1;         
    
                        OrderMstGrid.render();
                        OrderMstGrid.on('rowdblclick', function(grid, rowIndex, e) {
                            //弹出商品明细
                            var _record = OrderMstGrid.getStore().getAt(rowIndex).data.OrderId;
                            if (!_record) {
                                Ext.example.msg('操作', '请选择要查看的记录！');
                            } else {
                                OpenDtlWin(_record);
                            }

                        });
                        /****************************************************************/
                        function OpenDtlWin(orderId) {
                            if (typeof (newFormWin) == "undefined") {
                                newFormWin = new Ext.Window({
                                    layout: 'fit',
                                    width: 600,
                                    height: 400,
                                    closeAction: 'hide',
                                    plain: true,
                                    constrain: true,
                                    modal: true,
                                    autoDestroy: true,
                                    title: '明细信息',
                                    items: orderDtInfoGrid
                                });
                            }
                            newFormWin.show();
                            //查数据
                            orderDtInfoStore.baseParams.OrderId = orderId;
                            orderDtInfoStore.load({
                                params: {
                                    limit: 10,
                                    start: 0
                                }
                            });
                        }

                        var orderDtInfoStore = new Ext.data.Store
                            ({
                                url: 'frmOrderStatistics.aspx?method=getDtlInfo',
                                reader: new Ext.data.JsonReader({
                                    totalProperty: 'totalProperty',
                                    root: 'root'
                                }, [
	                            { name: 'OrderDtlId' },
	                            { name: 'OrderId' },
	                            { name: 'ProductId' },
	                            { name: 'ProductNo' },
	                            { name: 'ProductName' },
	                            { name: 'Specifications' },
	                            { name: 'SpecificationsName' },
	                            { name: 'Unit' },
	                            { name: 'UnitName' },
	                            { name: 'SaleQty' },
	                            { name: 'SalePrice' },
	                            { name: 'SaleAmt' },
	                            { name: 'SaleTax' }
	                            ])
                            });

                        var smDtl = new Ext.grid.CheckboxSelectionModel({
                            singleSelect: true
                        });
                        var orderDtInfoGrid = new Ext.grid.GridPanel({
                            width: '100%',
                            height: '100%',
                            autoWidth: true,
                            autoHeight: true,
                            autoScroll: true,
                            layout: 'fit',
                            id: '',
                            store: orderDtInfoStore,
                            loadMask: { msg: '正在加载数据，请稍侯……' },
                            sm: smDtl,
                            cm: new Ext.grid.ColumnModel([
		                            smDtl,
		                            new Ext.grid.RowNumberer(), //自动行号
		                            {
		                            header: '存货编号',
		                            dataIndex: 'ProductNo',
		                            id: 'ProductNo'
		                        },
		                            {
		                                header: '存货名称',
		                                dataIndex: 'ProductName',
		                                id: 'ProductName',
		                                width: 120
		                            },
		                            {
		                                header: '规格',
		                                dataIndex: 'SpecificationsName',
		                                id: 'SpecificationsName'
		                            },
		                            {
		                                header: '计量单位',
		                                dataIndex: 'UnitName',
		                                id: 'UnitName'
		                            },
		                            {
		                                header: '销售数量',
		                                dataIndex: 'SaleQty',
		                                id: 'SaleQty'
		                            },
		                            {
		                                header: '销售单价',
		                                dataIndex: 'SalePrice',
		                                id: 'SalePrice'
		                            },
		                            {
		                                header: '销售金额',
		                                dataIndex: 'SaleAmt',
		                                id: 'SaleAmt'
		                            },
		                            {
		                                header: '税额',
		                                dataIndex: 'SaleTax',
		                                id: 'SaleTax'
		                            }
		                        ]),
                            bbar: new Ext.PagingToolbar({
                                pageSize: 10,
                                store: orderDtInfoStore,
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
                        
                        /****************************************************************/
                        /*------DataGrid的函数结束 End---------------*/
                        //QueryDataGrid();

                       gs.setValue(<% =ZJSIG.UIProcess.ADM.UIAdmUser.OrgID(this)%>);
                       gs.setDisabled(true);
                       bm.setValue(<% =ZJSIG.UIProcess.ADM.UIAdmUser.DeptID(this)%>);
                       bm.setDisabled(true);
                        //加载仓库
                        if(dsWareHouse.getCount()==1)
                            ck.setValue(dsWareHouse.getAt(0).get("WhId"));
                       if(gs.getValue()==130) 
                       setToolBarVisible(Toolbar);
                    })
                    
</script>
</html>
<script type="text/javascript" src="../js/SelectModule.js"></script>
<script type="text/javascript" src="../js/LodopFuncs.js"></script>
