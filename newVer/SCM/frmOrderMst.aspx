<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmOrderMst.aspx.cs" Inherits="SCM_frmOrderMst" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html>
<head>
<title>��������</title><meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
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
<style type="text/css">
.x-grid-tanstype { 
color:blue; 
}
</style>
</head>
<body>
<div id='toolbar'></div>
<div id='divSearchForm'></div>
<div id='divOrderDataGrid'></div>
</body>
<%=getComboBoxStore()%>
<script type="text/javascript">
var version =parseFloat(navigator.appVersion.split("MSIE")[1]);
if(version == 6)
    version = 1;
else //!ie6 contain double size
    version = 3.1;
var OrderMstGridData=null;
Ext.BLANK_IMAGE_URL = "../ext3/resources/images/default/s.gif";  //��Ϊ���������������������ͼƬ��ʾ
Ext.onReady(function() {
    
    var saveType="";
    var printStyleXmlName = printStyleXml;
    var printOnlyDataValue = printOnlyData;
    var printPageWidthValue = printPageWidth;
    var printPageHeightValue = printPageHeight;
    
        /*------ʵ��toolbar�ĺ��� start---------------*/
        var Toolbar = new Ext.Toolbar({
            renderTo: "toolbar",
            items: [{
                text: "����",
                icon: "../Theme/1/images/extjs/customer/add16.gif",
                handler: function() { saveType="Add"; openAddOrderWin(); }
            }, '-', {
                text: "�༭",
                icon: "../Theme/1/images/extjs/customer/edit16.gif",
                handler: function() { saveType="Update"; modifyOrderWin(); }
            }, '-', {
                text: "ɾ��",
                icon: "../Theme/1/images/extjs/customer/delete16.gif",
                handler: function() {deleteOrder();  }
            }, '-', {
                id:'printMenus',
                text: "��ӡ",
                icon: "../Theme/1/images/extjs/customer/edit16.gif",
                handler: function() {
                    printStyleXmlName = printStyleXml;                    
                    printOnlyDataValue=printOnlyData;
                    printPageWidthValue=printPageWidth;
                    printPageHeightValue =printPageHeight;
                    printOrderById();
//                    if(navigator.userAgent.indexOf("2.0.50727")==-1)
//                    {
//                        alert("��û�а�װ.net 2.0 ��ܣ���ӡ��Ҫ��װ�˿�ܣ�");
//                    }
//                    else
//                    {
//                        alert("�Ѿ���װ.net 2.0 ��ܣ���ӡOK��");
//                    }
//                var printControl = document.getElementById('drawcontrol');
//                    printControl.PrintXml = printData;
//                    printControl.OnePageNum = 2;
//                    printControl.Print();
//                printOrder(); 
                }
                <%=setPrintPrivilege()%>                
            }, '-', {
                text: "�տ�",
                icon: "../Theme/1/images/extjs/customer/edit16.gif",
                handler: function() { AcctRece();  }
            }, '-', {
                text: "ȡ���տ�",
                icon: "../Theme/1/images/extjs/customer/edit16.gif",
                handler: function() { CancelAcctRece();  }
            }, '-', {
                text: "��Ʊ",
                icon: "../Theme/1/images/extjs/customer/edit16.gif",
                handler: function() {  generBill(); }
            }, '-', {
                text: "��;����",
                icon: "../Theme/1/images/extjs/customer/edit16.gif",
                handler: function() {  
                    productUseAdd();
                }
            }, '-', {
                text: "����ҵ��Ա",
                icon: "../Theme/1/images/extjs/customer/edit16.gif",
                handler: function() {  
                    customerManagerAdd();
                }
                <% if(ZJSIG.UIProcess.UIProcessBase.LodopPrintOn(this)) {%>
            }, '-', {
                text: "��ӡ(P)",
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
        Ext.Msg.alert('��ʾ��Ϣ', '��ѡ����Ҫ���õĶ�����Ϣ�����Զ������ͬʱ����');
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
        productUseAddWin = ExtJsShowWin('������Ʒ��;��Ϣ����','../../Common/frmOrderDtailUpdate.aspx?formType=productuse&OrderIds='+orderIds,'productUse',600,450);
        productUseAddWin.show();
    }
    else
    {
        productUseAddWin.show();
        document.getElementById("iframeproductUse").contentWindow.loadData(orderIds);
    } 
}
function customerManagerAdd()
{
    var record=OrderMstGrid.getSelectionModel().getSelections();
    if(record == null || record.length == 0)
    {
        Ext.Msg.alert('��ʾ��Ϣ', '��ѡ����Ҫ���õĶ�����Ϣ�����Զ������ͬʱ����');
        return null;
    }
    var orderIds = '';
    var sumAmt = 0;
    for(var i=0;i<record.length;i++)
    {
        if(orderIds.length>0)
            orderIds+=",";
        orderIds += record[i].get('OrderId');
        var saletotalamt = record[i].get('SaleTotalAmt');
        sumAmt =  accAdd(sumAmt,saletotalamt);//�ܶ�
    }
    openAcctWindow.show();
    document.getElementById("acctIFrame").src = "frmScmCustomerManager.aspx?sumAmt=" + sumAmt + "&strOrderId=" + orderIds;
}
/*------����toolbar�ĺ��� end---------------*/
function getUrl(imageUrl)
            {
                var index = window.location.href.toLowerCase().indexOf('/scm/');
                var tempUrl = window.location.href.substring(0,index);
                return tempUrl+"/"+imageUrl;
            }
function printOrderById()
{
    var sm = OrderMstGrid.getSelectionModel();
    //��ѡ
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
            if(!confirm(selectData[i].get('OrderNumber')+'�Ѿ���ӡ���Ƿ�Ҫ������ӡ��'))
                return;
        }
    }
    //alert(orderIds);
    //ҳ���ύ
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
           printControl.MapUrl = printControl.Url+'/'+printStyleXmlName;//'/salePrint1.xml';
           printControl.PrintXml = printData;
           printControl.ColumnName="OrderId";
           printControl.OnlyData=printOnlyDataValue;
           printControl.PageWidth=printPageWidthValue;
           printControl.PageHeight =printPageHeightValue ;
           printControl.Print();
           
           //ҳ���ύ
           Ext.Ajax.request({
               url: 'frmOrderMst.aspx?method=print',
               method: 'POST',
               params: {
                   OrderId: orderIds
               },
              success: function(resp,opts){ /* checkExtMessage(resp) */ },
              failure: function(resp,opts){  /* Ext.Msg.alert("��ʾ","����ʧ��"); */    }
           });
       },
       failure: function(resp,opts){  /* Ext.Msg.alert("��ʾ","����ʧ��"); */    }
    });
}
function printOrderByLodop(printType){
    var sm = OrderMstGrid.getSelectionModel();
    //��ѡ
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
            if(!confirm(selectData[i].get('OrderNumber')+'�Ѿ���ӡ���Ƿ�Ҫ������ӡ��'))
                return;
        }
    }
    //ҳ���ύ
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
                    alert("δ���ô�ӡ��ʽ������ϵ���Ź�˾��");
                    return;
                }
                var arrayPrintData = resu.PrintDataArray;
                var LODOP=getLodop(); 	
                LODOP.PRINT_INIT("saleprint");
                LODOP.SET_PRINT_PAGESIZE(1,resu.PrintPageWidth,resu.PrintPageHeight,"Letter");
                //LODOP.ADD_PRINT_HTM(0,0,resu.PrintPageWidth+"px",resu.PrintPageHeight+"px","�°��ӡ�������ڿ����У������ڴ�~");
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
           
           //ҳ���ύ
           Ext.Ajax.request({
               url: 'frmOrderMst.aspx?method=print',
               method: 'POST',
               params: {
                   OrderId: orderIds
               },
              success: function(resp,opts){ /* checkExtMessage(resp) */ },
              failure: function(resp,opts){  /* Ext.Msg.alert("��ʾ","����ʧ��"); */    }
           });
           
       },
       failure: function(resp,opts){  /* Ext.Msg.alert("��ʾ","����ʧ��"); */    }
    });
}

            /*------��ʼToolBar�¼����� start---------------*//*-----����Orderʵ���ര�庯��----*/
            function openAddOrderWin() {

                uploadOrderWindow.show();
                if(document.getElementById("editIFrame").src.indexOf("frmOrderDtl")==-1)
                {                
                    document.getElementById("editIFrame").src = "frmOrderDtl.aspx?OpenType=oper&id=0" ;
                }
                else{
                    document.getElementById("editIFrame").contentWindow.OrderId=0;
                    document.getElementById("editIFrame").contentWindow.setFormValue();
                    document.getElementById("editIFrame").contentWindow.OpenType='oper';
                }
                //document.getElementById("editIFrame").src = "frmOrderDtl.aspx?OpenType=oper&id=0";
            }
            
            function getSelectOrderId() {

            }
            
            //ȡ���տ�
            function CancelAcctRece()
            {
                var sm = OrderMstGrid.getSelectionModel();
                //��ѡ
                var selectData = sm.getSelections();          
                if(selectData.length==0)
                {
                    return;
                }      
                
                if(selectData[0].get('IsPayed')==0)
                {
                    Ext.Msg.alert("��ʾ", "������"+selectData[0].get('OrderNumber')+"��û�н�");
                    return;
                }
                 //Ȼ�����������
                Ext.Ajax.request({
                    url: 'frmOrderMst.aspx?method=cancelaccrect',
                    method: 'POST',
                    params: {
                        //������
                        OrderId:selectData[0].get('OrderId')
                        },
                    success: function(resp,opts){ 
                                    if( checkExtMessage(resp) )
                                         {
                                           OrderMstGridData.reload();
                                         }
                                   },
		            failure: function(resp,opts){  
		                Ext.Msg.alert("��ʾ","ȡ��ʧ��");     
		            } 
		            });               
            }
            //�տ��
            function AcctRece()
            {
                var sm = OrderMstGrid.getSelectionModel();
                //��ѡ
                var selectData = sm.getSelections();                
                var array = new Array(selectData.length);
                var sumAmt = 0;
                var strOrderId = "";
                var saletotalamt = 0;
                for(var i=0;i<selectData.length;i++)
                {
                    array[i] = selectData[i].get('OrderId');
                    saletotalamt = selectData[i].get('SaleTotalAmt');
                    sumAmt =  accAdd(sumAmt,saletotalamt);//�ܶ�
                    strOrderId = strOrderId + array[i] + ",";//�ַ���
                    
                    if(selectData[i].get('IsPayed')>0)
                    {
                        Ext.Msg.alert("��ʾ", "������"+selectData[i].get('OrderNumber')+"�ѽ�");
                        return;
                    }
                }
                
                strOrderId = strOrderId.substring(0, strOrderId.length - 1);

                //���û��ѡ�񣬾���ʾ��Ҫѡ��������Ϣ
                if (selectData == null || selectData == "") {
                    Ext.Msg.alert("��ʾ", "��ѡ����Ҫ�����ļ�¼��");
                    return;
                }
                
                openAcctWindow.show();
                document.getElementById("acctIFrame").src = "frmScmAcctRece.aspx?sumAmt=" + sumAmt + "&strOrderId=" + strOrderId;
                
            }
            
            
            //�տ����
            if (typeof (openAcctWindow) == "undefined") {//�������2��windows����
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
               OrderMstGridData.reload();
               if(document.getElementById("acctIFrame").src.indexOf('frmScmAcctRece')>-1)
                   document.getElementById("acctIFrame").src = "frmScmAcctRece.aspx?umAmt=0&strOrderId=0";//��������ݣ���������ҳ���ṩһ������������
            });
            
            //��Ʊ����
            function generBill()
            {
                var sm = OrderMstGrid.getSelectionModel();
                var selectData = sm.getSelections();    
                //���û��ѡ�񣬾���ʾ��Ҫѡ��������Ϣ
                if (selectData == null || selectData == "") {
                    Ext.Msg.alert("��ʾ", "��ѡ����Ҫ�����ļ�¼��");
                    return;
                }
                
                var array = new Array(selectData.length);
                var strOrderId = "";//����ID
                var customerid = 0;//�ͻ�
                var customername = "";//�ͻ�����
                var isbill = 0;//�Ƿ��ѿ�Ʊ
                var isdiff = 0;
                
                var kpfs = "S031";//��ͨ��Ʊ                
                kpfs = selectData[0].get('BillMode'); 
                customerid = selectData[0].get('CustomerId'); 
                customername = selectData[0].get('CustomerName'); 
                for(var i=0;i<selectData.length;i++)
                {
                    array[i] = selectData[i].get('OrderId');
                    strOrderId = strOrderId + array[i] + ",";//�ַ���
                    if (i != 0)
                    {
                        if (kpfs != selectData[i].get('BillMode')) 
                        {
                            Ext.Msg.alert("��ʾ", "��ѡ����ͬ�Ŀ�Ʊ��ʽ�Ķ���!");
                            return;
                        }
                        if (customername != selectData[i].get('CustomerName')) 
                        {
                            //Ext.Msg.alert("��ʾ", "������ͻ�����!");                            
                            customername = "";
                            customerid = -1;
                            isdiff = 1;
                        }
                    }
                    
                    isbill = selectData[i].get('IsBill'); 
                    if (isbill == 1)
                    {
                        Ext.Msg.alert("��ʾ", "��ѡ��δ��Ʊ������¼!");
                        return;
                    }
                }                
                strOrderId = strOrderId.substring(0, strOrderId.length - 1);
                
                if(isdiff == 1){
                    Ext.Msg.confirm("��ʾ��Ϣ", "���ڶ���ͻ��Ķ������Ƿ�������ɿ�Ʊ��¼��", function callBack(id) {
                        //�ж��Ƿ�ɾ������
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
            //��Ʊ����
            if (typeof (openBillWindow) == "undefined") {//�������2��windows����
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
            
            /*-----�༭Orderʵ���ര�庯��----*/
            function modifyOrderWin() {
                var sm = OrderMstGrid.getSelectionModel();
                //��ѡ
                var selectData = sm.getSelections();                
                var array = new Array(selectData.length);
                var status = 1;
                for(var i=0;i<selectData.length;i++)
                {
                    array[i] = selectData[i].get('OrderId');
                    status = selectData[i].get('Status');
                }

                //���û��ѡ�񣬾���ʾ��Ҫѡ��������Ϣ
                if (selectData == null || selectData == "") {
                    Ext.Msg.alert("��ʾ", "��ѡ����Ҫ�����ļ�¼��");
                    return;
                }
                
                if (array.length != 1) {
                    Ext.Msg.alert("��ʾ", "��ѡ��һ����¼��");
                    return;
                }
                //��ui-check
//                if (status != 1)
//                {
//                    Ext.Msg.alert("��ʾ", "������������ѳ��⣬�������޸ģ�");
//                    return;
//                }
                
                
                uploadOrderWindow.show();
                if(document.getElementById("editIFrame").src.indexOf("frmOrderDtl")==-1)
                {                
                    document.getElementById("editIFrame").src = "frmOrderDtl.aspx?OpenType=oper&id=" + selectData[0].data.OrderId;
                }
                else{
                    document.getElementById("editIFrame").contentWindow.OrderId=selectData[0].data.OrderId;
                    document.getElementById("editIFrame").contentWindow.setFormValue();
                    document.getElementById("editIFrame").contentWindow.OpenType='oper';
                }
            }
            /*-----ɾ��Orderʵ�庯��----*/
            function deleteOrder() {
                var sm = OrderMstGrid.getSelectionModel();
                //��ѡ
                var selectData = sm.getSelections();                
                var array = new Array(selectData.length);
                for(var i=0;i<selectData.length;i++)
                {
                    array[i] = selectData[i].get('OrderId');
                }

                //���û��ѡ�񣬾���ʾ��Ҫѡ��������Ϣ
                if (selectData == null || selectData == "") {
                    Ext.Msg.alert("��ʾ", "��ѡ����Ҫ�����ļ�¼��");
                    return;
                }
                
                if (array.length != 1) {
                    Ext.Msg.alert("��ʾ", "��ѡ��һ����¼��");
                    return;
                }
                
                //ɾ��ǰ�ٴ������Ƿ����Ҫɾ��
                Ext.Msg.confirm("��ʾ��Ϣ", "�Ƿ����Ҫɾ��ѡ��ļ�¼��", function callBack(id) {
                    //�ж��Ƿ�ɾ������
                    if (id == "yes") {
                        //ҳ���ύ
                        Ext.Ajax.request({
                            url: 'frmOrderMst.aspx?method=Delete',
                            method: 'POST',
                            params: {
                                OrderId: array[0]
                            },
                            success: function(resp,opts){  checkExtMessage(resp);OrderMstGridData.reload();  },
		                    failure: function(resp,opts){  Ext.Msg.alert("��ʾ","����ʧ��");     }
                        });
                    }
                });
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
//                OrderMstGridData.baseParams.Status=1;		                
                OrderMstGridData.baseParams.StartDate=Ext.util.Format.date(Ext.getCmp('StartDate').getValue(),'Y/m/d');
                OrderMstGridData.baseParams.EndDate=Ext.util.Format.date(Ext.getCmp('EndDate').getValue(),'Y/m/d');
                OrderMstGridData.baseParams.CustomerServer=1;
                OrderMstGridData.load({
                    params: {
                        start: 0,
                        limit: defaultPageSize
                    }
                });
            }
            

              //�ֿ�
               var ck = new Ext.form.ComboBox({
                   xtype: 'combo',
                   store: dsWareHouse,
                   valueField: 'WhId',
                   displayField: 'WhName',
                   mode: 'local',
                   forceSelection: true,
                   editable: true,
                   name:'OutStor',
                   id:'OutStor',
                   emptyValue: '',
                   triggerAction: 'all',
                   fieldLabel: '�ֿ�',
                   selectOnFocus: true,
                   anchor: '90%'
               });
               //���ͷ�ʽ
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
                   fieldLabel: '���ͷ�ʽ',
                    name:'DlvType',
                   id:'DlvType',
                   selectOnFocus: true,
                   anchor: '90%',
				   editable:false
               });               
               
               //��ʼ����
               var ksrq = new Ext.form.DateField({
           		    xtype:'datefield',
			        fieldLabel:'��ʼ����',
			        anchor:'90%',
			        name:'StartDate',
			        id:'StartDate',
			        format: 'Y��m��d��',  //���������ʽ
                    value:new Date().clearTime() 
               });
               
               //��������
               var jsrq = new Ext.form.DateField({
           		    xtype:'datefield',
			        fieldLabel:'��������',
			        anchor:'90%',
			        name:'EndDate',
			        id:'EndDate',
			        format: 'Y��m��d��',  //���������ʽ
                    value:new Date().clearTime()
               });
               
               //�ͻ��ȼ�
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
                   fieldLabel: '�ͻ��ȼ�',
                    name:'DlvLevel',
                   id:'DlvLevel',
                   selectOnFocus: true,
                   anchor: '90%',
				   editable:false
               });
               
               //���㷽ʽ
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
                   fieldLabel: '���㷽ʽ',
                   name:'PayType',
                   id:'PayType',
                   selectOnFocus: true,
                   anchor: '90%',
				   editable:false
               });
               //��Ʊ��ʽ
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
                   fieldLabel: '��Ʊ��ʽ',
                   name:'BillMode',
                   id:'BillMode',
                   selectOnFocus: true,
                   anchor: '90%',
				   editable:false
               });
                //��������
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
                   fieldLabel: '��������',
                   name:'OrderType',
                   id:'OrderType',
                   selectOnFocus: true,
                   anchor: '90%',
				   editable:false,
				   value:'S011',
				   disabled:true
               });
               
               //��˾������
               var gs = new Ext.form.ComboBox({
                    xtype:'combo',
                    fieldLabel:'��˾��ʶ',
                    anchor:'90%',
                    name:'OrgId',
                    id:'OrgId',
                    store: dsOrg,
                    displayField: 'OrgName',  //����ֶκ�ҵ��ʵ�����ֶ�ͬ��
                    valueField: 'OrgId',      //����ֶκ�ҵ��ʵ�����ֶ�ͬ��
                    typeAhead: true, //�Զ�����һ����������ѡ�ȫ����
                    triggerAction: 'all',
                    emptyValue: '',
                    selectOnFocus: true,
                    forceSelection: true,
				    editable:false,
                    mode:'local'        //��������趨�ӱ�ҳ��ȡ����Դ�����ܹ���ֵ��λ
               })
               
               //����������
               var bm = new Ext.form.ComboBox({
                    xtype:'combo',
                    fieldLabel:'����',
                    anchor:'90%',
                    name:'QryDeptID',
                    id:'QryDeptID',
                    store:dsDept,
                    displayField: 'DeptName',  //����ֶκ�ҵ��ʵ�����ֶ�ͬ��
                    valueField: 'DeptId',      //����ֶκ�ҵ��ʵ�����ֶ�ͬ��
                    typeAhead: true, //�Զ�����һ����������ѡ�ȫ����
                    triggerAction: 'all',
                    emptyValue: '',
                    selectOnFocus: true,
                    forceSelection: true,
                    editable:false,
                    mode:'local'        //��������趨�ӱ�ҳ��ȡ����Դ�����ܹ���ֵ��λ
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
		                labelSeparator: '��',
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
		                    labelSeparator: '��',
		                    items: [
			                {
			                    layout:'form',
			                    border: false,
			                    columnWidth:0.275*version,
			                    items: [
			                    {
				                    xtype:'textfield',
				                    fieldLabel:'�ͻ�',
				                    anchor:'100%',
				                    name:'CustomerId',
				                    id:'CustomerId'
				                }
			                    ]
			                },
			                {
                               layout: 'form',
                               columnWidth: .03*version,  //����ռ�õĿ�ȣ���ʶΪ20��
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
                                              //getProductInfo(function(record){ });    
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
		                labelSeparator: '��',
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
					                fieldLabel:'�Ƿ���',
					                columnWidth:0.33,
					                anchor:'90%',
					                store:[['1','��'],['0','��']],
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
					                fieldLabel:'�Ƿ�Ʊ',
					                columnWidth:0.33,
					                anchor:'90%',
					                store:[['1','��'],['0','��']],
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
		                labelSeparator: '��',
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
		                labelSeparator: '��',
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
					                fieldLabel:'��ʼ����',
					                columnWidth:0.5,
					                anchor:'90%',
					                name:'StartDate',
					                id:'StartDate',
			                        format: 'Y��m��d��',  //���������ʽ
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
					                fieldLabel:'��������',
					                columnWidth:0.5,
					                anchor:'90%',
					                name:'EndDate',
					                id:'EndDate',
			                        format: 'Y��m��d��',  //���������ʽ
                                    value:new Date().clearTime()
				                }
		                            ]
		                }
	                ]}
	                ,{//������
                        layout:'column',
                        items:[
                            {//��һ��Ԫ��
                                layout:'form',
                                border: false,
                                labelWidth:70,
                                columnWidth:.33,
                                items:[{
                                     layout:'form',
                                    border:false,
                                    columnWidth:0.33,
                                    html:'&nbsp'
                                }]
                            },
                            {//�ڶ���Ԫ��
                                layout:'form',
                                border: false,
                                labelWidth:70,
                                columnWidth:.33,
                                items:[{
                                       
                                }]
                            },
                            {//������Ԫ��
                                layout:'form',
                                border: false,
                                labelWidth:70,
                                columnWidth:0.17,
                                items:[
                                    {
                                       xtype:'button',
                                        text:'��ѯ',
                                        width:70,
                                        //iconCls:'excelIcon',
                                        scope:this,
                                        handler:function(){
                                            QueryDataGrid();
                                        }
                                    }
                                    ]
                            },
                            {//������Ԫ��
                                layout:'form',
                                border: false,
                                labelWidth:70,
                                columnWidth:0.17,
                                items:[
                                    {
                                       xtype:'button',
                                        text:'���',
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
                                            isOutStor.setValue('');
                                        }
                                    }
                                    ]
                            }
                        ]
                    }
	                
	                
	                               
                ]
                
                });



                        /*------��ʼ��ѯform�ĺ��� end---------------*/

                        /*------��ʼ�������ݵĴ��� Start---------------*/
                        if (typeof (uploadOrderWindow) == "undefined") {//�������2��windows����
                            uploadOrderWindow = new Ext.Window({
                                id: 'Orderformwindow',
                                iconCls: 'upload-win'
		                        , width: 780
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
                           //document.getElementById("editIFrame").src = "frmOrderDtl.aspx?OpenType=oper&id=0";//��������ݣ���������ҳ���ṩһ������������
                        });

                        

                       
                        /*------��ʼ��ȡ���ݵĺ��� start---------------*/
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
	                                name:'TransType'
	                            },
	                            {
		                            name:'IsActiveName'
	                            },
	                            {
	                                name:'PrintNum'
	                            }	])
	                         
	            ,sortData: function(f, direction) {
                    var tempSort = Ext.util.JSON.encode(OrderMstGridData.sortInfo);
                    if (sortInfor != tempSort) {
                        sortInfor = tempSort;
                        OrderMstGridData.baseParams.SortInfo = sortInfor;
                        OrderMstGridData.load({ params: { limit: defaultPageSize, start: 0} });
                    }
                },
                listeners:
	            {
	                scope: this,
	                load: function() {
	                }
	            }
            });
            
            var sortInfor='';

                        /*------��ȡ���ݵĺ��� ���� End---------------*/
var defaultPageSize = 10;
    var toolBar = new Ext.PagingToolbar({
        pageSize: 10,
        store: OrderMstGridData,
        displayMsg: '��ʾ��{0}����{1}����¼,��{2}��',
        emptyMsy: 'û�м�¼',
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
        emptyText: '����ÿҳ��¼��',
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
                        /*------��ʼDataGrid�ĺ��� start---------------*/

                        var sm = new Ext.grid.CheckboxSelectionModel({
                            singleSelect: false
                        });
                        var OrderMstGrid = new Ext.grid.GridPanel({
                            el: 'divOrderDataGrid', 
                            width:document.body.offsetWidth,
                            height: '100%',
                            //autoHeight: true,
                            //autoWidth : true, 
                            autoScroll: true,
                            bodyStyle: 'padding:0px,0px,2px,0px',
                            monitorResize: true, 
                            columnLines:true,
                            layout: 'fit',
                            id: '',
                            store: OrderMstGridData,
                            loadMask: { msg: '���ڼ������ݣ����Ժ��' },
                            sm: sm,
                            cm: new Ext.grid.ColumnModel([
                            
		                    sm,
		                    new Ext.grid.RowNumberer(),//�Զ��к�
		                    {
			                    header:'������ʶ',
			                    dataIndex:'OrderId',
			                    id:'OrderId',
			                    hidden:true,
			                    width:0
		                    },
		                    {
			                    header:'�������',
			                    dataIndex:'OrderNumber',
			                    id:'OrderNumber',
			                    sortable: true,
			                    width:85
		                    },
		                    {
		                        header:'��˾����',
			                    dataIndex:'OrgName',
			                    id:'OrgName',
			                    width:120
		                    },
//		                    {
//		                        header:'���۲���',
//			                    dataIndex:'DeptName',
//			                    id:'DeptName'
//		                    },
		                    {
		                        header:'����ֿ�',
			                    dataIndex:'OutStorName',
			                    id:'OutStorName',
			                    sortable: true,
			                    width:70
		                    },
		                    {
		                        header:'�ͻ�����',
			                    dataIndex:'CustomerName',
			                    id:'CustomerName',
			                    sortable: true,
			                    width:150
		                    },
		                    {
			                    header:'�ͻ�����',
			                    dataIndex:'DlvDate',
			                    id:'DlvDate',
			                    renderer: Ext.util.Format.dateRenderer('Y��m��d��'),
			                    sortable: true,
			                    width:95
		                    },
//		                    {
//		                        header:'��������',
//			                    dataIndex:'OrderTypeName',
//			                    id:'OrderTypeName',
//			                    width:60
//		                    },
//		                    {
//		                        header:'���㷽ʽ',
//			                    dataIndex:'PayTypeName',
//			                    id:'PayTypeName',
//			                    width:60
//		                    },
		                    {
		                        header:'��Ʊ��ʽ',
			                    dataIndex:'BillModeName',
			                    id:'BillModeName',
			                    sortable: true,
			                    width:55
		                    },
		                    {
		                        header:'���ͷ�ʽ',
			                    dataIndex:'DlvTypeName',
			                    id:'DlvTypeName',
			                    sortable: true,
			                    width:55
		                    },
		                    {
		                        header:'�Ƿ�Ʊ',
			                    dataIndex:'IsBillName',
			                    id:'IsBillName',
			                    sortable: true,
			                    width:55
		                    },
		                    {
		                        header:'�Ƿ���',
			                    dataIndex:'IsPayedName',
			                    id:'IsPayedName',
			                    sortable: true,
			                    width:55
		                    },
//		                    {
//		                        header:'�ͻ��ȼ�',
//			                    dataIndex:'DlvLevelName',
//			                    id:'DlvLevelName',
//			                    width:60,
//			                    hidden:true
//		                    },
		                    {
			                    header:'������',
			                    dataIndex:'SaleTotalQty',
			                    id:'SaleTotalQty',
			                    sortable: true,
			                    width:50
		                    },
		                    {
			                    header:'�ܽ��',
			                    dataIndex:'SaleTotalAmt',
			                    id:'SaleTotalAmt',
			                    sortable: true,
			                    width:50
		                    },
		                    {
		                        header:'����Ա',
			                    dataIndex:'OperName',
			                    id:'OperName',
			                    sortable: true,
			                    width:50
		                    },
		                    {
			                    header:'����ʱ��',
			                    dataIndex:'CreateDate',
			                    id:'CreateDate',
			                    renderer: Ext.util.Format.dateRenderer('Y��m��d��'),
			                    sortable: true,
			                    width:95
		                    },
		                    {
		                        header:'��ӡ����',
		                        title:'��������ο�',
			                    dataIndex:'PrintNum',
			                    id:'PrintNum',
			                    sortable: true,
			                    width:55
		                        
		                    },
		                    {
		                        header:'���㷽ʽ',
			                    dataIndex:'PayTypeName',
			                    id:'PayTypeName',
			                    sortable: true,
			                    width:55
		                    }		]),
                            bbar:toolBar,
                            viewConfig: {
                                columnsText: '��ʾ����',
                                scrollOffset: 20,
                                sortAscText: '����',
                                sortDescText: '����',
                                forceFit: false,
                                getRowClass: function(r, i, p, s) {
                                    if (r.data.TransType == 1) {
                                        return "x-grid-tanstype";
                                    }
                                }
                            },
                            height: 303,                            
		                    //enableHdMenu: false,  //����ʾ�����ֶκ���ʾ����������
		                    //enableColumnMove: false,//�в����ƶ�
                            closeAction: 'hide',
                            stripeRows: true,
                            loadMask: true//,
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
                                    
                                     tip.body.dom.innerHTML="���ڼ������ݡ���";
                                        //ҳ���ύ
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
                                }//ϸ����Ϣ
                                else if(v==4)
                                {
                                    if(showTipRowIndex == rowIndex)
                                        return;
                                    else
                                        showTipRowIndex = rowIndex;
                                         tip.body.dom.innerHTML="���ڼ������ݡ���";
                                            //ҳ���ύ
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
                            //������Ʒ��ϸ
                            var _record = OrderMstGrid.getStore().getAt(rowIndex).data.OrderId;
                            if (!_record) {
                                Ext.example.msg('����', '��ѡ��Ҫ�鿴�ļ�¼��');
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
                                    title: '��ϸ��Ϣ',
                                    items: orderDtInfoGrid
                                });
                            }
                            newFormWin.show();
                            //������
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
	                            { name: 'SaleTax' },
	                            { name: 'DiscountRate' },
	                            { name: 'DiscountAmt' }
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
                            loadMask: { msg: '���ڼ������ݣ����Ժ��' },
                            sm: smDtl,
                            cm: new Ext.grid.ColumnModel([
		                            smDtl,
		                            new Ext.grid.RowNumberer(), //�Զ��к�
		                            {
		                            header: '������',
		                            dataIndex: 'ProductNo',
		                            id: 'ProductNo'
		                        },
		                            {
		                                header: '�������',
		                                dataIndex: 'ProductName',
		                                id: 'ProductName',
		                                width: 120
		                            },
		                            {
		                                header: '���',
		                                dataIndex: 'SpecificationsName',
		                                id: 'SpecificationsName'
		                            },
		                            {
		                                header: '������λ',
		                                dataIndex: 'UnitName',
		                                id: 'UnitName'
		                            },
		                            {
		                                header: '��������',
		                                dataIndex: 'SaleQty',
		                                id: 'SaleQty'
		                            },
		                            {
		                                header: '���۵���',
		                                dataIndex: 'SalePrice',
		                                id: 'SalePrice'
		                            },
		                            {
		                                header: '���۽��',
		                                dataIndex: 'SaleAmt',
		                                id: 'SaleAmt'
		                            },
		                            {
		                                header: '�ۿ۽��',
		                                dataIndex: 'DiscountAmt',
		                                id: 'DiscountAmt'
		                            },
		                            {
		                                header: '˰��',
		                                dataIndex: 'SaleTax',
		                                id: 'SaleTax'
		                            }
		                        ]),
                            bbar: new Ext.PagingToolbar({
                                pageSize: 10,
                                store: orderDtInfoStore,
                                displayMsg: '��ʾ��{0}����{1}����¼,��{2}��',
                                emptyMsy: 'û�м�¼',
                                displayInfo: true
                            }),
                            viewConfig: {
                                columnsText: '��ʾ����',
                                scrollOffset: 20,
                                sortAscText: '����',
                                sortDescText: '����',
                                forceFit: true
                            },
                            height: 280,
                            closeAction: 'hide',
                            stripeRows: true,
                            loadMask: true,
                            autoExpandColumn: 2
                        });
                        /****************************************************************/
                        /*------DataGrid�ĺ������� End---------------*/
                        //QueryDataGrid();                        

                       gs.setValue(<% =ZJSIG.UIProcess.ADM.UIAdmUser.OrgID(this)%>);
                       gs.setDisabled(true);
                       bm.setValue(<% =ZJSIG.UIProcess.ADM.UIAdmUser.DeptID(this)%>);
                       bm.setDisabled(true);
                       
                       if(gs.getValue()==2){
                         Ext.getCmp('IsBill').setValue(0);
                       }
                       //���زֿ�
                        if(dsWareHouse.getCount()==1)
                            ck.setValue(dsWareHouse.getAt(0).get("WhId")); 
                       var orderType='<%=Request.QueryString["OrderType"] %>';
                       if(orderType!='')
                            ddlx.setValue(orderType);
                       //setToolBarVisible(Toolbar);
                    })
                    
//                    function getPayTypeIndex(selectedId)
//                    {
//                        var orderIndex = OrderMstGridData.find("
//                         var index = dsPayType.find('DicsCode', Ext.getCmp("Pay);
//                    }                
                
</script>

</html>
<script type="text/javascript" src="../js/SelectModule.js"></script>
<script type="text/javascript" src="../js/LodopFuncs.js"></script>