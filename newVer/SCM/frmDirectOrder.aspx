<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmDirectOrder.aspx.cs" Inherits="SCM_frmDirectOrder" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html>
<head>
<title>ֱ����������</title><meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<link rel="stylesheet" type="text/css" href="../ext3/resources/css/ext-all.css" />
<link rel="stylesheet" type="text/css" href="../Theme/1/css/salt.css" />
<script type="text/javascript" src="../ext3/adapter/ext/ext-base.js"></script>
<script type="text/javascript" src="../ext3/ext-all.js"></script>
<script type="text/javascript" src="../js/operateResp.js"></script>
<script type="text/javascript" src="../js/floatUtil.js"></script>
<script type="text/javascript" src="../js/ExtJsHelper.js"></script>
<script type="text/javascript" src="../ext3/src/locale/ext-lang-zh_CN.js"></script>
<style type="text/css">
.x-date-menu {
   width: 175px;
}
</style>
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
Ext.BLANK_IMAGE_URL = "../ext3/resources/images/default/s.gif";  //��Ϊ���������������������ͼƬ��ʾ
Ext.onReady(function() {
    
    var saveType="";
    
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
                text: "��ӡ",
                icon: "../Theme/1/images/extjs/customer/edit16.gif",
                handler: function() { 
                    printOrderById();
                
                }
            }, '-', {
                text: "�տ�",
                icon: "../Theme/1/images/extjs/customer/edit16.gif",
                handler: function() { AcctRece();  }
            }, '-', {
                text: "��Ʊ",
                icon: "../Theme/1/images/extjs/customer/edit16.gif",
                handler: function() {  generBill(); }
            } , '-', {
                text: "�ύ",
                icon: "../Theme/1/images/extjs/customer/edit16.gif",
                handler: function() {  Purchase(); }
            }
            
            ]
            });
            /*------����toolbar�ĺ��� end---------------*/


            /*------��ʼToolBar�¼����� start---------------*//*-----����Orderʵ���ര�庯��----*/
            function openAddOrderWin() {

                uploadOrderWindow.show();
                document.getElementById("editIFrame").src = "frmDirectOrderEdit.aspx?OpenType=oper&id=0";
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
                //��ѡ
                var selectData = sm.getSelections();                
                var array = new Array(selectData.length);
                var orderIds = "";
                for(var i=0;i<selectData.length;i++)
                {
                    if(orderIds.length>0)
                        orderIds+=",";
                    orderIds += selectData[i].get('OrderId');
                }
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
                       printControl.MapUrl = printControl.Url+'/salePrint1.xml';
                       printControl.PrintXml = printData;
                       printControl.ColumnName="OrderId";
                       printControl.OnlyData=true;
                       printControl.PageWidth=365;
                       printControl.PageHeight = 931;
                       printControl.Print();
                       
                   },
		           failure: function(resp,opts){  /* Ext.Msg.alert("��ʾ","����ʧ��"); */    }
                });
            }
            /*-----ɾ��Orderʵ�庯��----*/
            function deleteOrder() {
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
                
                if (status != 2)
                {
                    Ext.Msg.alert("��ʾ", "�����ѳ��⣬��������ɾ����");
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
            
            //�ύ��Ч����
            function Purchase()
            {
                Ext.MessageBox.wait("���������ύ�����Ժ򡭡�");
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
                    Ext.MessageBox.hide();
                    Ext.Msg.alert("��ʾ", "��ѡ����Ҫ�����ļ�¼��");
                    return;
                }
                
                if (array.length != 1) {
                    Ext.MessageBox.hide();
                    Ext.Msg.alert("��ʾ", "��ѡ��һ����¼��");
                    return;
                }
                
                if (status != 2)
                {
                    Ext.MessageBox.hide();
                    Ext.Msg.alert("��ʾ", "�����ѳ��⣬���������ύ��");
                    return;
                }
                
                //ҳ���ύ
                Ext.Ajax.request({
                    url: 'frmDirectOrder.aspx?method=Purchase',
                    method: 'POST',
                    params: {
                        strOrderId: array[0]
                    },
                   success: function(resp,opts){ 
                      Ext.MessageBox.hide();
                      if( checkExtMessage(resp) )
                      {
                        OrderMstGridData.reload();
                      }
                       
                   },
		           failure: function(resp,opts){ Ext.MessageBox.hide(); /* Ext.Msg.alert("��ʾ","����ʧ��"); */    }
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
                //�տ��ȷ�϶������
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
                    
                    isbill = selectData[0].get('IsBill'); 
                    if (isbill == 1)
                    {
                        Ext.Msg.alert("��ʾ", "��ѡ��δ��Ʊ������¼!");
                        return;
                    }
                }                
                strOrderId = strOrderId.substring(0, strOrderId.length - 1);
                
                if(isdiff == 1){
                    Ext.Msg.confirm("��ʾ��Ϣ", "���ڶ���ͻ��Ķ������Ƿ�������ɿ�Ʊ��¼��¼��", function callBack(id) {
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
            
            if (typeof (uploadOrderWindow) == "undefined") {//�������2��windows����
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
		                        , html: '<iframe id="editIFrame" width="100%" height="100%" border=0 src=""></iframe>' 
                                
                            });
                        }
                        uploadOrderWindow.addListener("hide", function() {
                           //document.getElementById("editIFrame").src = "frmOrderDtl.aspx?OpenType=oper&id=0";//��������ݣ���������ҳ���ṩһ������������
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
                
                if (status != 2)
                {
                    Ext.Msg.alert("��ʾ", "�����ѳ��⣬�������޸ģ�");
                    return;
                }
                
                
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
                        
                        
            /*-----��ӡOrderʵ�庯��----*/
            var printform =null;// ExtJsShowWin('���ݴ�ӡ','#','doc',800,600);
            function printOrder() {            
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
                
                if(printform==null)
                {
                    printform = ExtJsShowWin('���ݴ�ӡ','../common/frmDocReport.aspx?reportName=�ຼ���۷�����&reportId='+array[0],'doc',800,600);
                }
                else{                    
                    document.getElementById('iframedoc').src='../common/frmDocReport.aspx?reportName=�ຼ���۷�����&reportId='+array[0];
                }
                printform.show();
                
                //ҳ���ύ
                Ext.Ajax.request({
                    url: 'frmOrderMst.aspx?method=print',
                    method: 'POST',
                    params: {
                        OrderId: array[0]
                    },
                   success: function(resp,opts){ /* checkExtMessage(resp) */ },
		           failure: function(resp,opts){ /*  Ext.Msg.alert("��ʾ","����ʧ��");  */   }
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
                OrderMstGridData.baseParams.TransType=3;	//ֻ��ʾֱ������	                
                OrderMstGridData.baseParams.StartDate=Ext.util.Format.date(Ext.getCmp('StartDate').getValue(),'Y/m/d');
                OrderMstGridData.baseParams.EndDate=Ext.util.Format.date(Ext.getCmp('EndDate').getValue(),'Y/m/d');
                OrderMstGridData.load({
                    params: {
                        start: 0,
                        limit: 10
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
                   editable: false,
                   name:'OutStor',
                   id:'OutStor',
                   emptyValue: '',
                   triggerAction: 'all',
                   fieldLabel: '�ֿ�',
                   selectOnFocus: true,
                   anchor: '90%',
				   editable:false
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
				   value:'S014',
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
			                    columnWidth:0.274*version,
			                    items: [
			                    {
				                    xtype:'textfield',
				                    fieldLabel:'�ͻ�',
				                    anchor:'99%',
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
					                store:[[1,'��'],[0,'��']],
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
					                store:[[1,'��'],[0,'��']],
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
                                columnWidth:0.34,
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
		                        , width: 750
		                        , height: 530
		                        , plain: true
		                        , modal: true
		                        , constrain: true
		                        , resizable: false
		                        , closeAction: 'hide'
		                        , autoDestroy: true
		                        , html: '<iframe id="editIFrame" width="100%" height="100%" border=0 src="frmDirectOrderEdit.aspx"></iframe>' 
                                
                            });
                        }
                        uploadOrderWindow.addListener("hide", function() {                            
                           document.getElementById("editIFrame").src = "frmDirectOrderEdit.aspx?OpenType=oper&id=0";//��������ݣ���������ҳ���ṩһ������������                           
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
		                            name:'IsActiveName'
	                            }	])
	                         
	            ,
                listeners:
	            {
	                scope: this,
	                load: function() {
	                }
	            }
            });

                        /*------��ȡ���ݵĺ��� ���� End---------------*/

                            function getStatusName(v){
			                        if(v>2)
			                            return '��';
			                        return '��';
			               }
                        /*------��ʼDataGrid�ĺ��� start---------------*/

                        var sm = new Ext.grid.CheckboxSelectionModel({
                            singleSelect: false
                        });
                        var OrderMstGrid = new Ext.grid.GridPanel({
                            el: 'divDataGrid', 
                            height: '100%',
                            //autoHeight: true,
                            autoScroll: true,
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
			                    id:'OrderId',
			                    width:100
		                    },
//		                    {
//		                        header:'��˾����',
//			                    dataIndex:'OrgName',
//			                    id:'OrgName'
//		                    },
//		                    {
//		                        header:'���۲���',
//			                    dataIndex:'DeptName',
//			                    id:'DeptName'
//		                    },
		                    {
		                        header:'����ֿ�',
			                    dataIndex:'OutStorName',
			                    id:'OutStorName',
			                    width:80
		                    },
		                    {
		                        header:'�ͻ�����',
			                    dataIndex:'CustomerName',
			                    id:'CustomerName',
			                    width:160
		                    },
		                    {
			                    header:'�ͻ�����',
			                    dataIndex:'DlvDate',
			                    id:'DlvDate',
			                    renderer: Ext.util.Format.dateRenderer('m��d��'),
			                    width:85
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
			                    width:60
		                    },
		                    {
		                        header:'���ͷ�ʽ',
			                    dataIndex:'DlvTypeName',
			                    id:'DlvTypeName',
			                    width:60
		                    },
		                    {
		                        header:'�Ƿ����',
			                    dataIndex:'Status',
			                    id:'Status',
			                    width:60,
			                    renderer:getStatusName
		                    },
		                    {
		                        header:'�Ƿ�Ʊ',
			                    dataIndex:'IsBillName',
			                    id:'IsBillName',
			                    width:60
		                    },
		                    {
		                        header:'�Ƿ���',
			                    dataIndex:'IsPayedName',
			                    id:'IsPayedName',
			                    width:60
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
			                    width:60
		                    },
		                    {
			                    header:'�ܽ��',
			                    dataIndex:'SaleTotalAmt',
			                    id:'SaleTotalAmt',
			                    width:60
		                    },
		                    {
		                        header:'����Ա',
			                    dataIndex:'OperName',
			                    id:'OperName',
			                    width:60
		                    },
		                    {
			                    header:'����ʱ��',
			                    dataIndex:'CreateDate',
			                    id:'CreateDate',
			                    renderer: Ext.util.Format.dateRenderer('m��d��'),
			                    width:85
		                    }		]),
                            bbar: new Ext.PagingToolbar({
                                pageSize: 10,
                                store: OrderMstGridData,
                                displayMsg: '��ʾ��{0}����{1}����¼,��{2}��',
                                emptyMsy: 'û�м�¼',
                                displayInfo: true
                            }),
                            viewConfig: {
                                columnsText: '��ʾ����',
                                scrollOffset: 20,
                                sortAscText: '����',
                                sortDescText: '����',
                                forceFit: false
                            },
                            height: 350
//                            closeAction: 'hide',
//                            stripeRows: true,
//                            loadMask: true,
//                            autoExpandColumn: 2
                        });
                        OrderMstGrid.on("afterrender", function(component) {
                            component.getBottomToolbar().refresh.hideParent = true;
                            component.getBottomToolbar().refresh.hide(); 
                        });
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
                        /*------DataGrid�ĺ������� End---------------*/
                        //QueryDataGrid();

                       gs.setValue(<% =ZJSIG.UIProcess.ADM.UIAdmUser.OrgID(this)%>);
                       gs.setDisabled(true);
                       bm.setValue(<% =ZJSIG.UIProcess.ADM.UIAdmUser.DeptID(this)%>);
                       bm.setDisabled(true);
                    })
</script>

</html>
<script type="text/javascript" src="../js/SelectModule.js"></script>
