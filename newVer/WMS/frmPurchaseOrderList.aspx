<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmPurchaseOrderList.aspx.cs" Inherits="WMS_frmPurchaseOrderList" %>

<html>
<head>
<title>�ɹ����б�ҳ��</title><meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
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
        /*------ʵ��toolbar�ĺ��� start---------------*/
        var windowTitle = "";
        var Toolbar = new Ext.Toolbar({
            renderTo: "toolbar",
            items: [{
                text: "������ֵ�",
                icon: "../theme/1/images/extjs/customer/add16.gif",
                handler: function() { generateInStockOrderWin(); }
            }, '-', {
                text: "�ָ�ȡ��",
                icon: "../theme/1/images/extjs/customer/edit16.gif",
                handler: function() { cancelSplit(); }
            }, '-', {
                text: "�鿴�ɹ���",
                icon: "../theme/1/images/extjs/customer/edit16.gif",
                handler: function() { lookOrderWin(); }
            }, '-', {
                text: "����ȷ��",
                icon: "../theme/1/images/extjs/customer/edit16.gif",
                handler: function() { confirmOrderWin(); }
            }, '-', {
                text: "�۸�ȷ��",
                icon: "../theme/1/images/extjs/customer/edit16.gif",
                handler: function() { confirmPriceOrderWin(); }
            }, '-', {
                xtype: 'splitbutton',
                text: "��ӡ",
                icon: "../Theme/1/images/extjs/customer/edit16.gif",
                menu:createPrintMenu()
            }, '-', {
                text: "������",
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
                   text: '���ݴ�ӡ',
                   handler: function(){
                     printOrderById(printStyleXmlV2);
                   }
                },
	            {
                   text: '��˰����ӡ',
                   handler: function(){
                     printOrderById(printStyleXml);
                   }
                },
	            {
                   text: '��˰����ӡ',
                   handler: function(){
                    printOrderById(printNoTaxStyleXml);
                   }
                },
	            {
                  text: '����װж����ӡ',
                  handler: printLoadrById
                },{
                   text: '����������ⵥ��ӡ',
                   handler: printTransById
                }]});
            <%=setPrintPrivilege()%>
	        return menu;        }
        
        function printLoadrById()
        {
            var sm = userGrid.getSelectionModel();
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
                    url: 'frmPurchaseOrderList.aspx?method=getrateprintdata',
//                    url:'frmOrderMst.aspx?method=billdata',
                    method: 'POST',
                    params: {
                        OrderId: orderIds,
                        TypeName:'����װж����'
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
//		                Ext.Msg.alert("��ʾ",resp);   
		            }
                });
}

function printTransById()
{
var sm = userGrid.getSelectionModel();
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
                    url: 'frmPurchaseOrderList.aspx?method=getrateprintdata',
//                    url:'frmOrderMst.aspx?method=billdata',
                    method: 'POST',
                    params: {
                        OrderId: orderIds,
                        TypeName:'�����������'
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
//		                Ext.Msg.alert("��ʾ",resp);   
		             }
                });
}
        
        setToolBarVisible(Toolbar);
            /*------����toolbar�ĺ��� end---------------*/
        function getUrl(imageUrl)
            {
                var index = window.location.href.toLowerCase().indexOf('/wms/');
                var tempUrl = window.location.href.substring(0,index);
                return tempUrl+"/"+imageUrl;
            }
            function printOrderById(xmlUrl)
            {
                var sm = userGrid.getSelectionModel();
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
		           failure: function(resp,opts){  /* Ext.Msg.alert("��ʾ","����ʧ��"); */    }
                });
}
            /*------��ʼToolBar�¼����� start---------------*//*-----����Orderʵ���ര�庯��----*/
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
            //������ⵥ
            function generateInStockOrderWin() {
                var sm = userGrid.getSelectionModel();
                //��ȡѡ���������Ϣ
                var selectData = sm.getSelected();
                if (selectData == null) {
                    Ext.Msg.alert("��ʾ", "��ѡ��ɹ�����¼��");
                    return;
                }
                if (selectData.data.BillStatus != 0)//����δ���״̬
                {
                    Ext.Msg.alert("��ʾ", "ֻ��δ��ֵĲɹ�����������ֲ�����");
                    return;
                }
                
                //����δȷ��
                if(selectData.data.ConfirmStatus==0){
                    Ext.Msg.confirm("��ʾ��Ϣ", "�òɹ���δ������ȷ�ϣ����������Ĭ�Ϸ�����������ȷ�ģ��Ƿ������", function callBack(id) {
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
            /*-----�쿴Orderʵ���ര�庯��----*/
            function cancelSplit() {
                var sm = userGrid.getSelectionModel();
                //��ȡѡ���������Ϣ
                var selectData = sm.getSelected();
                //���û��ѡ�񣬾���ʾ��Ҫѡ��������Ϣ
                if (selectData == null) {
                    Ext.Msg.alert("��ʾ", "��ѡ����Ҫȡ������Ϣ��");
                    return;
                }
                //ɾ��ǰ�ٴ������Ƿ����Ҫɾ��
                Ext.Msg.confirm("��ʾ��Ϣ", "�Ƿ����Ҫȡ��ѡ��ĵ�����", function callBack(id) {
                    //�ж��Ƿ�ɾ������
                    if (id == "yes") {
                        //ҳ���ύ
                        Ext.Ajax.request({
                            url: 'frmPurchaseOrderList.aspx?method=cancelSplit',
                            method: 'POST',
                            params: {
                                OrderId: selectData.data.OrderId
                            },
                            success: function(resp, opts) {
                                if (checkExtMessage(resp)) {
                                    updateDataGrid(); //ˢ��ҳ��
                                }
                            },
                            failure: function(resp, opts) {
                                Ext.Msg.alert("��ʾ", "����ȡ��ʧ�ܣ�");
                            }
                        });
                    }
                });
            }

            function lookOrderWin() {
                var status = "readonly";
                uploadPurchaseOrderWindow.setTitle("�鿴�ɹ�����ϸ��Ϣ");
                openOrderWin(status);
            }

            function confirmOrderWin() {
                var status = "confirm";
                uploadPurchaseOrderWindow.setTitle("ȷ�ϲɹ�����Ʒ����");
                openOrderWin(status);
            }
            function confirmPriceOrderWin() {
                var status = "confirmprice";
                uploadPurchaseOrderWindow.setTitle("ȷ�ϲɹ�����Ʒ�۸�");
                openOrderWin(status);
            }
            function addPurchaseAdjustWin() {
                var status = "adjustAmt";
                uploadPurchaseOrderWindow.setTitle("�����ɹ�����Ʒ���");
                openOrderWin(status);
            }

            function openOrderWin(status) {
                //alert(status);
                var sm = userGrid.getSelectionModel();
                var selectData = sm.getSelected();
                if (selectData == null) {
                    Ext.Msg.alert("��ʾ", "��ѡ����Ҫ�����Ĳɹ�������Ϣ��");
                    return;
                }
                if(status=='confirm'){
                    if(selectData.data.ConfirmStatus==1){
                        if (!confirm("�Ѿ���������ȷ�ϣ��Ƿ������")) 
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
            /*------��ʼ�������ݵĴ��� Start---------------*/
            if (typeof (uploadOrderWindow) == "undefined") {//�������2��windows����
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

            if (typeof (uploadPurchaseOrderWindow) == "undefined") {//�������2��windows����
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

            /*------��ʼ��ȡ�������ݵĺ��� start---------------*/
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
                        Ext.Msg.alert("��ʾ", "����ɹ���");
                    },
                    failure: function(resp, opts) {
                        Ext.Msg.alert("��ʾ", "����ʧ�ܣ�");
                    }
                });
            }
            /*------������ȡ�������ݵĺ��� End---------------*/

            /*------��ʼ�������ݵĺ��� Start---------------*/
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
                        Ext.Msg.alert("��ʾ", "��ȡ������Ϣʧ�ܣ�");
                    }
                });
            }
            /*------�������ý������ݵĺ��� End---------------*/

            /*------��ʼ��ѯform�ĺ��� start---------------*/

            var SupplierNamePanel = new Ext.form.ComboBox({
                name: 'supplierCombo',
                store: dsSuppliesListInfo,
                displayField: 'ChineseName',
                valueField: 'CustomerId',
                typeAhead: false, //�Զ�����һ����������ѡ�ȫ����
                triggerAction: 'all',
                emptyText: '��ѡ��Ӧ��',
                selectOnFocus: true,
                forceSelection: false,
                mode: 'local',
                fieldLabel: '��Ӧ��',
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
                typeAhead: true, //�Զ�����һ����������ѡ�ȫ����
                triggerAction: 'all',
                emptyText: '��ѡ��ֿ�',
                selectOnFocus: true,
                forceSelection: true,
                mode: 'local',
                fieldLabel: '�ֿ�����',
                anchor: '90%',
                id: 'SWhName',
                listeners: { specialkey: function(f, e) { if (e.getKey() == e.ENTER) { Ext.getCmp('BillStatus').focus(); } } }
            });

            var BillStatusPanel = new Ext.form.ComboBox({
                name: 'billStatusCombo',
                store: dsBillStatus,
                displayField: 'BillStatusName',
                valueField: 'BillStatusId',
                typeAhead: true, //�Զ�����һ����������ѡ�ȫ����
                triggerAction: 'all',
                value: 0, //δ���
                selectOnFocus: true,
                forceSelection: true,
                editable: false,
                mode: 'local',
                fieldLabel: '����״̬',
                anchor: '90%',
                id: 'BillStatus',
                listeners: { specialkey: function(f, e) { if (e.getKey() == e.ENTER) { Ext.getCmp('StartDate').focus(); } } }
            });
            var StartDatePanel = new Ext.form.DateField({
                style: 'margin-left:0px',
                cls: 'key',
                xtype: 'datefield',
                fieldLabel: '��ʼʱ��',
                format: 'Y��m��d��',
                anchor: '90%',
                value: new Date().getFirstDateOfMonth().clearTime(),
                id: 'StartDate',
                listeners: { specialkey: function(f, e) { if (e.getKey() == e.ENTER) { Ext.getCmp('EndDate').focus(); } } }
            });
            var EndDatePanel = new Ext.form.DateField({
                style: 'margin-left:0px',
                cls: 'key',
                xtype: 'datefield',
                fieldLabel: '����ʱ��',
                anchor: '90%',
                format: 'Y��m��d��',
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
                    layout: 'column',   //�����Ԫ��Ϊ����Ϊ�в��ַ�ʽ
                    border: false,
                    items: [{
                        columnWidth: .3,  //����ռ�õĿ��ȣ���ʶΪ20��
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

                        layout: 'column',   //�����Ԫ��Ϊ����Ϊ�в��ַ�ʽ
                        border: false,
                        items: [{
                            columnWidth: .3,  //����ռ�õĿ��ȣ���ʶΪ20��
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
                                text: '��ѯ',
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
                     //������д�Լ��Ĺ��˴���  
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
            /*------��ʼ��ѯform�ĺ��� end---------------*/

            /*------��ʼ��ȡ���ݵĺ��� start---------------*/
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

            /*------��ȡ���ݵĺ��� ���� End---------------*/

            /*------��ʼDataGrid�ĺ��� start---------------*/

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
                loadMask: { msg: '���ڼ������ݣ����Ժ��' },
                sm: sm,
                cm: new Ext.grid.ColumnModel([
		sm,
		new Ext.grid.RowNumberer(), //�Զ��к�
		{
		    header: '������',
		    dataIndex: 'FromBillId',
		    id: 'FromBillId'
        },{
		    header: '�ָ��',
		    dataIndex: 'OrderId',
		    id: 'OrderId'
        },
		{
		    header: '��Ӧ��',
		    dataIndex: 'SupplierName',
		    id: 'SupplierName'
		},
		{
		    header: '�ֿ�',
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
                //			header:'��֯ID',
                //			dataIndex:'OrgId',
                //			id:'OrgId'
                //		},
		{
		header: '������',
		dataIndex: 'OperName',
		id: 'OperName'
},
		{
		    header: '����ʱ��',
		    dataIndex: 'CreateDate',
		    id: 'CreateDate',
		    format: 'Y��m��d��'
		},
                //		{
                //			header:'����ʱ��',
                //			dataIndex:'UpdateDate',
                //			id:'UpdateDate'
                //		},
		{
		header: '��������',
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
                //		    header: '��Դ���ݺ�',
                //		    dataIndex: 'FromBillId',
                //		    id: 'FromBillId'
                //		},
		{
		header: '����״̬',
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
		    header: '������',
		    dataIndex: 'CarBoatNo',
		    id: 'CarBoatNo'
		},
		{
			header:'ȷ��״̬',
			//hidden:true,
			dataIndex:'ConfirmStatus',
			id:'ConfirmStatus',
			renderer:function(v){
			    if(v==1) return '��ȷ��';
			    return 'δȷ��';
			}
		},
		{
		    header: '��ע',
		    dataIndex: 'Remark',
		    id: 'Remark'
}]),
                bbar: new Ext.PagingToolbar({
                    pageSize: 10,
                    store: userGridData,
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
                             //ϸ����Ϣ
                              if(v==1||v==2||v==3)
                                {
                                    if(showTipRowIndex == rowIndex)
                                        return;
                                    else
                                        showTipRowIndex = rowIndex;
                                        
                                     tip.body.dom.innerHTML="���ڼ������ݡ���";
                                        //ҳ���ύ
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
            /*------DataGrid�ĺ������� End---------------*/
            updateDataGrid();


        })
</script>
</html>