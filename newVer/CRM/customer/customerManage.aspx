<%@ Page Language="C#" AutoEventWireup="true" CodeFile="CustomerManage.aspx.cs" Inherits="customer_customerManage" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html id="Html1" xmlns="http://www.w3.org/1999/xhtml" runat="server">
<head>
    <title></title>
    <meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
    <link rel="stylesheet" type="text/css" href="../../ext3/resources/css/ext-all.css" />
	<script type="text/javascript" src="../../ext3/adapter/ext/ext-base.js"></script>	
	<script type="text/javascript" src="../../ext3/ext-all.js"></script>
	<script type="text/javascript" src="../../js/userCreate.js"></script>
    <script type="text/javascript" src="../../js/operateResp.js"></script>
     <script type="text/javascript" src="../../js/FilterControl.js"></script>
    <script type="text/javascript" src="../../ext3/src/locale/ext-lang-zh_CN.js"></script>
    <script type="text/javascript" src="../../js/ExtJsHelper.js"></script>
    <link rel="stylesheet" type="text/css" href="../../Theme/1/css/salt.css" />
    <link rel="Stylesheet" type="text/css" href="../../css/gridPrint.css" />
    <script type="text/javascript" src="../../js/OrgsSelect.js"></script>
    <meta http-equiv="X-UA-Compatible" content="IE=EmulateIE7" />
</head>
<body style="padding: 0px; margin: 0px; width: 100%; height: 100%">
	<div id="toolbar"></div>
    <div id="serchform"></div>
    <div id="searchForm"></div>
    <div id="datagrid"></div>
    <div id="address"></div>
</body>
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
var IsCustManager = getParamerValue('custManager');
</script>
<%= getComboBoxStore() %>

<script type="text/javascript">
Ext.BLANK_IMAGE_URL = "../../ext3/resources/images/default/s.gif";
var saveType="";
var cusid=null;
/* ȫ�ֱ�����������Ȩ�޿��Ƶı���ֻ���ص�һ�� start */
var custTypeComBoxStore ;
var version =parseFloat(navigator.appVersion.split("MSIE")[1]);
if(version == 6)
    version = 2.06;
else //!ie6 contain double size
    version = 3.1;
/* ȫ�ֱ�����������Ȩ�޿��Ƶı���ֻ���ص�һ�� end */

Ext.onReady(function() {
/*------����toolbar start---------------*/
var Toolbar = new Ext.Toolbar({
    renderTo: "toolbar",
    items: [{
        text: "����",
        icon: '../../Theme/1/images/extjs/customer/add16.gif',
        //iconCls: 'blist',
        //cls: 'x-btn-text-icon', //class��ʽ
        //ctCls: '', //�ͻ��Զ���class��ʽ
        //Anchor LayoutҪ��:"1.�����ڵ����Ҫôָ����ȣ�Ҫô��anchor��ͬʱָ����/��2.anchorֵͨ��ֻ��Ϊ��ֵ(ָ�ǰٷֱ�ֵ)����ֵû�����壬3.anchor����Ϊ�ַ���ֵ"
        //height: 100,anchor: '-50',�߶ȵ���100�����=�������-50
        //height: 100,anchor: '50%',�߶ȵ���100,���=������ȵ�50%
        //anchor: '-10, -250',���=�������-10,�߶�=�������-250
        handler: function() {
            saveType = "add";
            openAddCustomerWin(); //����󣬵��������Ϣ����
        }
    }, '-', {
        text: "ɾ��",
        icon: '../../Theme/1/images/extjs/customer/delete16.gif',
        handler: function() {
            deleteCustomer();
        }
    }, '-', {
        text: "�༭",
        icon: '../../Theme/1/images/extjs/customer/edit16.gif',
        handler: function() {
            saveType = "edit";
            modifyCustomerWin(); //����󵯳�ԭ����Ϣ
        }
    }, '-', {
        text: "����",
        icon: '../../Theme/1/images/extjs/customer/forbidden16.gif',
        handler: function() {
            forbiddenCustomer();
        }
    }, '-', {
        text: "��Ʒ����۸�",
        icon: '../../Theme/1/images/extjs/customer/s_add.gif',
        handler: function() {
            especialProductPrice();
        }
    }, '-', {
        text: "�ɶ�����Ʒ",
        icon: '../../Theme/1/images/extjs/customer/s_add.gif',
       // hidden:true,
        handler: function() {
            var sm = CustomerGrid.getSelectionModel();
            var selectData = sm.getSelected();
            if (selectData == null) {
                Ext.Msg.alert("��ʾ", "��ѡ��һ�У�");
                return;
            }
            if(selectData.data.IsCust==0)
            {
                Ext.Msg.alert("��ʾ","ѡ��ĵ�ǰ�ͻ����ǿ��̣��������ö�����Ʒ��");
                return;
            }
            especialProductClass();
        }
    }, '-', {
        text: "�����ͻ��û�",
        icon: '../../Theme/1/images/extjs/customer/s_add.gif',
        handler: function() {
            var sm = CustomerGrid.getSelectionModel();
            var selectData = sm.getSelected();
            if (selectData == null) {
                Ext.Msg.alert("��ʾ", "��ѡ��һ�У�");
                return;
            }
            modifyUserWin(selectData.data.CustomerId, selectData.data.ShortName);
        }
    },'-', {
        text: "���ù�Ӧ����Ʒ",
        icon: '../../Theme/1/images/extjs/customer/s_add.gif',
        handler: function() {
            var sm = CustomerGrid.getSelectionModel();
            var selectData = sm.getSelected();
            if (selectData == null) {
                Ext.Msg.alert("��ʾ", "��ѡ��һ�У�");
                return;
            }
            if(selectData.data.IsProvide==0)
            {
                Ext.Msg.alert("��ʾ","ѡ��ĵ�ǰ�ͻ����ǹ�Ӧ�̣��������ù�Ӧ��Ʒ��");
                return;
            }
            suppliersProducts();
        }
    },'-',{
        xtype: 'splitbutton',
        text:'������Ϣ',
        icon: '../../Theme/1/images/extjs/customer/s_add.gif',
        menu:createMenu()
    },'-',{
        xtype: 'splitbutton',
        text:'����',
        icon: '../../Theme/1/images/extjs/customer/s_add.gif',
        menu:createExportMenu()
    },'-']
 });
 
function createMenu()
{
	var menu = new Ext.menu.Menu({
        id: 'mainMenu',
        style: {
            overflow: 'visible'
       },
       items: [
	{
           text: '�ͻ�������Ϣ',
           handler: customerAdd
        },
        {
            text:'���Ŷ�������',
            handler:setSmsPassWord
        },
	{
           text: '�����������',
           handler: customerSaltAdd
        },{
           text: '�����������',
           handler: customerOtherAdd
        },{
           text: '�γ���Ϣ',
           handler: saltWorksAdd
        }]});
	return menu;
}
function createExportMenu()
{
	var menu = new Ext.menu.Menu({
        id: 'exportMenu',
        style: {
            overflow: 'visible'
       },
       items: [
	{
           text: '��ǰ���',
           handler: function(){
            exportExcel(false);
           }
        },
	{
           text: 'ȫ�����',
           handler: function(){
            exportExcel(true);
           }
        }]});
	return menu;
}
/*------ʵ��toolbar�İ�ť���� start---------------*/
//����
function exportExcel(flag) {             
    if (!Ext.fly('test'))   
    {   
        var frm = document.createElement('form');   
        frm.id = 'test';   
        frm.name = id;   
        //frm.style.display = 'none';   
        frm.className = 'x-hidden'; 
        document.body.appendChild(frm);   
    }  
    var testPms = customerListStore.baseParams;
    testPms.isAll = flag;
    Ext.Ajax.request({   
        url: 'customerManage.aspx?method=exportData', 
        form: Ext.fly('test'),   
        method: 'POST',     
        isUpload: true,          
        params: testPms,
        success: function(resp, opts) {
            //Ext.Msg.hide();
        },
        failure: function(resp, opts) {
             //Ext.Msg.hide();
        }
    });  
}

var smsPasswordWin = null;
function setSmsPassWord()
{
    var record=CustomerGrid.getSelectionModel().getSelections();
                if(record == null || record.length == 0)
                {
                 Ext.Msg.alert('��ʾ��Ϣ', '��ѡ����Ҫ���õĿͻ���Ϣ�����Զ���ͻ�ͬʱ����');
                    return null;
                }

    var customerIds = '';
    for(var i=0;i<record.length;i++)
    {
        if(customerIds.length>0)
            customerIds+=",";
        customerIds += record[i].get('CustomerId');
    }
    if(smsPasswordWin==null)
    {
        smsPasswordWin = ExtJsShowWin('�ͻ����Ŷ�������','../../Common/frmCommonListUpdate.aspx?formType=sms&CustomerIds='+customerIds,'smsbase',600,450);
        smsPasswordWin.show();
    }
    else
    {
        smsPasswordWin.show();
        document.getElementById("iframesmsbase").contentWindow.loadData(customerIds);
    } 
}

var saltWorksAddWin = null;
function saltWorksAdd()
{
    var record=CustomerGrid.getSelectionModel().getSelections();
                if(record == null || record.length == 0)
                {
                 Ext.Msg.alert('��ʾ��Ϣ', '��ѡ����Ҫ���õĿͻ���Ϣ�����Զ���ͻ�ͬʱ����');
                    return null;
                }

    var customerIds = '';
    for(var i=0;i<record.length;i++)
    {
        if(customerIds.length>0)
            customerIds+=",";
        customerIds += record[i].get('CustomerId');
    }
    if(saltWorksAddWin==null)
    {
        saltWorksAddWin = ExtJsShowWin('�γ�������Ϣ','../../Common/frmCommonListUpdate.aspx?formType=saltworks&CustomerIds='+customerIds,'saltworksbase',600,450);
        saltWorksAddWin.show();
    }
    else
    {
        saltWorksAddWin.show();
        document.getElementById("iframesaltworksbase").contentWindow.loadData(customerIds);
    } 
}
//�ͻ�������Ϣ
var customerAddWin = null;
function customerAdd()
{
    var record=CustomerGrid.getSelectionModel().getSelections();
                if(record == null || record.length == 0)
                {
                 Ext.Msg.alert('��ʾ��Ϣ', '��ѡ����Ҫ���õĿͻ���Ϣ�����Զ���ͻ�ͬʱ����');
                    return null;
                }

    var customerIds = '';
    for(var i=0;i<record.length;i++)
    {
        if(customerIds.length>0)
            customerIds+=",";
        customerIds += record[i].get('CustomerId');
    }
    if(customerAddWin==null)
    {
        customerAddWin = ExtJsShowWin('�ͻ�������Ϣ','../../Common/frmCommonListUpdate.aspx?formType=customer&CustomerIds='+customerIds,'customerbase',600,450);
        customerAddWin.show();
    }
    else
    {
        customerAddWin.show();
        document.getElementById("iframecustomerbase").contentWindow.loadData(customerIds);
    }
    
    
    
}

var customerSaltAddWin = null;
function customerSaltAdd()
{
var record=CustomerGrid.getSelectionModel().getSelections();
                if(record == null || record.length == 0)
                {
                 Ext.Msg.alert('��ʾ��Ϣ', '��ѡ����Ҫ���õĿͻ���Ϣ�����Զ���ͻ�ͬʱ����');
                    return null;
                }

    var customerIds = '';
    for(var i=0;i<record.length;i++)
    {
        if(customerIds.length>0)
            customerIds+=",";
        customerIds += record[i].get('CustomerId');
    }
    if(customerSaltAddWin==null)
    {
        customerSaltAddWin = ExtJsShowWin('�ͻ������������','../../Common/frmCommonListUpdate.aspx?formType=customersalt&CustomerIds='+customerIds,'customersalt',600,450);
        customerSaltAddWin.show();
    }
    else
    {
        customerSaltAddWin.show();
        document.getElementById("iframecustomersalt").contentWindow.loadData(customerIds);
    }
}

var customerOtherAddWin = null;
function customerOtherAdd()
{
    var sm = CustomerGrid.getSelectionModel();
    var selectData = sm.getSelected();
    if(selectData==null)
    {
        Ext.Msg.alert('��ʾ��Ϣ', '��ѡ����Ҫ���õĿͻ���Ϣ��ֻ��ͬʱ����1���ͻ���Ϣ');
                    return null;
    }
    customerIds = selectData.data.CustomerId;
    if(customerOtherAddWin==null)
    {
        customerOtherAddWin = ExtJsShowWin('�ͻ��������������','../../Common/frmCommonListUpdate.aspx?formType=customerother&CustomerIds='+customerIds,'customerother',600,450);
        customerOtherAddWin.show();
    }
    else
    {
    customerOtherAddWin.show();
    
    document.getElementById("iframecustomerother").contentWindow.loadData(selectData.data.CustomerId);
    }
}

setToolBarVisible(Toolbar);
/*  ��������  */
function openAddCustomerWin() {
    uploadWindow.show();
    content.setActiveTab(0);
    Ext.getCmp('RouteName').setDisabled(false);

}
/*  �޸Ĵ���  */
function modifyCustomerWin() {
    var sm = CustomerGrid.getSelectionModel();
    var selectData = sm.getSelected();
    if (selectData == null) {
        Ext.Msg.alert("��ʾ", "��ѡ��һ�У�");
    }
    else {
        //check
        if(selectData.data.OrgId != <% =ZJSIG.UIProcess.ADM.UIAdmUser.OrgID(this)%>){
            Ext.Msg.alert("��ʾ", "�ÿͻ���ʡ��˾ͳһά����");
            return;
        }
        openAddCustomerWin();

        Ext.Ajax.request({
            url: 'customerManage.aspx?method=getCustInfo',
            params: {
                CustomerId: selectData.data['CustomerId']//����ͻ�seqId
            },
            success: function(resp, opts) {

                var data = Ext.util.JSON.decode(resp.responseText);

                Ext.getCmp('CustomerId').setValue(data.CustomerId); //ID
                Ext.getCmp('CustomerNo').setValue(data.CustomerNo); //���
                Ext.getCmp('ChineseName').setValue(data.ChineseName); //��������                    
                Ext.getCmp('MnemonicNo').setValue(data.MnemonicNo); //������
                Ext.getCmp('EnglishName').setValue(data.EnglishName); //Ӣ������
                Ext.getCmp('ShortName').setValue(data.ShortName); //���
                Ext.getCmp('Address').setValue(data.Address); //��ַ
                Ext.getCmp('LinkMan').setValue(data.LinkMan); //��ϵ��
                Ext.getCmp('LinkTel').setValue(data.LinkTel); //��ϵ�绰
                Ext.getCmp('LinkMobile').setValue(data.LinkMobile); //�ƶ��绰
                Ext.getCmp('Zipcode').setValue(data.Zipcode); //�ʱ�
                Ext.getCmp('Fax').setValue(data.Fax); //����
                Ext.getCmp('Email').setValue(data.Email); //����
                Ext.getCmp('DeliverDate').setValue(data.DeliverDate); //�ͻ�ʱ��
                Ext.getCmp('DeliverAdd').setValue(data.DeliverAdd); //�ͻ���ַ
                Ext.getCmp('DistributionType').setValue(data.DistributionType); //��������
                Ext.getCmp('DeliverCorp').setValue(data.DeliverCorp); //�ͻ���˾
                Ext.getCmp('MonthQuantity').setValue(data.MonthQuantity); //������
                Ext.getCmp('CorpKind').setValue(data.CorpKind); //��˾����
                Ext.getCmp('CustKind').setValue(data.CustKind); //��ҵ����
                Ext.getCmp('EodrDate').setValue((new Date(data.EodrDate.replace(/-/g, "/")))); //����ʱ��
                Ext.getCmp('Province').setValue(data.Province); //����ʡ
                Ext.getCmp('City').setValue(data.City); //������
                Ext.getCmp('Town').setValue(data.Town); //��������
                if (data.IsIncust == 1 || data.IsIncust == '1') {
                    Ext.get("IsIncust").dom.checked = true; //�ڲ��ͻ�
                }
                if (data.IsProvide == 1 || data.IsProvide == '1') {
                    Ext.get("IsProvide").dom.checked = true; //��Ӧ��
                }
                if (data.IsCust == 1 || data.IsCust == '1') {
                    Ext.get("IsCust").dom.checked = true; //����
                }
                if (data.IsOrthercust == 1 || data.IsOrthercust == '1') {
                    Ext.get("IsOrthercust").dom.checked = true; //��������
                }
                Ext.getCmp('State').setValue(data.State); //�ͻ�״̬
                //Ext.getCmp('OwenId').setValue(data.OwenId);//ҵ��Ա
                //Ext.getCmp('OwenOrg').setValue(data.OwenOrg);//��֯
                Ext.getCmp('CreditSum').setValue(data.CreditSum); //���ö��
                Ext.getCmp('SettlementWay').setValue(data.SettlementWay); //���㷽ʽ
                if (data.IsMakeinvoice == 1 || data.IsMakeinvoice == '1') {
                    Ext.get("IsMakeinvoice").dom.checked = true; //�Ƿ�Ʊ
                }
                Ext.getCmp('AwarDdate').setValue((new Date(data.AwarDdate.replace(/-/g, "/")))); //��֤����
                Ext.getCmp('TradeType').setValue(data.TradeType); //��ҵ
                Ext.getCmp('SettlementParty').setValue(data.SettlementParty); //���㷽
                Ext.getCmp('ClearingOrg').setValue(data.ClearingOrg); //������֯
                Ext.getCmp('SettlementType').setValue(data.SettlementType); //��������
                Ext.getCmp('SettlementCurrency').setValue(data.SettlementCurrency); //�������
                Ext.getCmp('Principal').setValue(data.Principal); //������
                Ext.getCmp('PrincipalTel').setValue(data.PrincipalTel); //�����˵绰
                Ext.getCmp('BankAccount').setValue(data.BankAccount); //�����˻�
                Ext.getCmp('BankId').setValue(data.BankId); //��������
                Ext.getCmp('BankDate').setValue((new Date(data.BankDate.replace(/-/g, "/")))); //����ʱ��
                Ext.getCmp('LicenseNo').setValue(data.LicenseNo); //���֤��
                Ext.getCmp('BusinessNo').setValue(data.BusinessNo); //���̱��
                Ext.getCmp('TaxNo').setValue(data.TaxNo); //˰��
                Ext.getCmp('Remark').setValue(data.Remark); //��ע
                Ext.getCmp('IsShare').setValue(data.IsShare); //��ע
                Ext.getCmp('InvoiceType').setValue(data.InvoiceType); //��ע                            

                Ext.getCmp('BankName').setValue(data.BankName);//
                Ext.getCmp('BalanceBankName').setValue(data.BalanceBankName);//
                Ext.getCmp('BlanaceBankAccount').setValue(data.BlanaceBankAccount);//
                
                Ext.getCmp('CustomizeInfo').setValue(data.CustomizeInfo);//
                /*
                Ext.getCmp('OrgId').setValue(data.OrgId); //������֯
                */
                Ext.getCmp('RouteName').setValue(data.RouteName);
                //Ext.getCmp('RouteName').setDisabled(true);

            },
            failure: function(resp, opts) {
                Ext.Msg.alert("��ʾ", "��ȡ�û���Ϣʧ��");
            }
        });
    }
}
/*  ɾ������  */
function deleteCustomer() {
    var sm = CustomerGrid.getSelectionModel();
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
    if (selectData == null || selectData.length == 0 || selectData.length > 1) {
        Ext.Msg.alert("��ʾ", "��ѡ��һ�У�");
    }
    else {
        //check
        if(selectData.data.OrgId != <% =ZJSIG.UIProcess.ADM.UIAdmUser.OrgID(this)%>){
            Ext.Msg.alert("��ʾ", "�ÿͻ���ʡ��˾ͳһά����");
            return;
        }
    
        //ɾ��ǰ�ٴ������Ƿ����Ҫɾ��
        Ext.Msg.confirm("��ʾ��Ϣ", "�Ƿ����Ҫɾ��ѡ�����Ϣ��", function callBack(id) {
            //�ж��Ƿ�ɾ������
            if (id == "yes") {
                Ext.Ajax.request({
                    url: 'customerManage.aspx?method=delete',
                    params: {
                        CustomerId: selectData.data['CustomerId']//����ͻ�seqId
                    },
                    success: function(resp, opts) {
                        if(checkExtMessage(resp))
                            CustomerGrid.getStore().remove(selectData);
                    },
                    failure: function(resp, opts) {
                        Ext.Msg.alert("��ʾ", "ɾ��ʧ�ܣ�");
                    }
                });
            }
        });
    }
}
/* ��ֹ����  */
function forbiddenCustomer() {
    var sm = CustomerGrid.getSelectionModel();
    var selectData = sm.getSelected();
    if (selectData == null || selectData.length == 0 || selectData.length > 1) {
        Ext.Msg.alert("��ʾ", "��ѡ��һ�У�");
    }
    else {
        //check
        if(selectData.data.OrgId != <% =ZJSIG.UIProcess.ADM.UIAdmUser.OrgID(this)%>){
            Ext.Msg.alert("��ʾ", "�ÿͻ���ʡ��˾ͳһά����");
            return;
        }
        //ɾ��ǰ�ٴ������Ƿ����Ҫɾ��
        Ext.Msg.confirm("��ʾ��Ϣ", "�Ƿ����Ҫ��ֹѡ�����Ϣ��", function callBack(id) {
            //�ж��Ƿ�ɾ������
            if (id == "yes") {
                Ext.Ajax.request({
                    url: 'customerManage.aspx?method=forbidden',
                    params: {
                        CustomerId: selectData.data['CustomerId']//����ͻ�seqId
                    },
                    success: function(resp, opts) {
                        //var data=Ext.util.JSON.decode(resp.responseText);
                        if(checkExtMessage(resp))
                            CustomerGrid.getStore().remove(selectData);
                    },
                    failure: function(resp, opts) {
                        Ext.Msg.alert("��ʾ", "��ֹʧ�ܣ�");
                    }
                });
            }
        });
    }
}

/* ��Ʒ����۸�ָ��  */
function especialProductPrice() {
    var sm = CustomerGrid.getSelectionModel();
    var selectData = sm.getSelected();
    if (selectData == null || selectData.length == 0 || selectData.length > 1) {
        Ext.Msg.alert("��ʾ", "��ѡ��һ�У�");
    }
    else {
        uploadespecialProductWindow.show();
        uploadespecialProductWindow.setTitle("��Ʒ����۸�����"); //alert(selectData.data.DrawInvId);
        //document.getElementById("especialProductw").src = "../product/frmCrmCustomerFixPriceHotKey.aspx?CustomerId=" + selectData.data.CustomerId;
        if (document.getElementById("especialProductw").src.indexOf("frmCrmCustomerFixPriceHotKey") == -1) {
            document.getElementById("especialProductw").src = "../product/frmCrmCustomerFixPriceHotKey.aspx?CustomerId=" + selectData.data.CustomerId;
        }
        else {
            document.getElementById("especialProductw").contentWindow.customerId = selectData.data.CustomerId;
            document.getElementById("especialProductw").contentWindow.customerName = selectData.data.ShortName;
            document.getElementById("especialProductw").contentWindow.reloadCustomerFixPrice();                        
        }
    }
}

/* �ͻ��ɶ������ָ��  */
function especialProductClass() {
    var sm = CustomerGrid.getSelectionModel();
    var selectData = sm.getSelected();
    if (selectData == null || selectData.length == 0 || selectData.length > 1) {
        Ext.Msg.alert("��ʾ", "��ѡ��һ�У�");
    }
    else {
        uploadespecialClassWindow.show();
        uploadespecialClassWindow.setTitle("�ͻ��ɶ����������"); //alert(selectData.data.DrawInvId);
//                    document.getElementById("especialProductClass").src = "../product/frmCrmCustomerFixPriceHotKey.aspx?CustomerId=" + selectData.data.CustomerId;
        if (document.getElementById("especialProductClass").src.indexOf("frmCrmSpeakfor") == -1) {
            document.getElementById("especialProductClass").src = "frmCrmSpeakfor.aspx?CustomerId=" + selectData.data.CustomerId;
        }
        else {
            document.getElementById("especialProductClass").contentWindow.customerId = selectData.data.CustomerId;
            document.getElementById("especialProductClass").contentWindow.customerName = selectData.data.ShortName;
            document.getElementById("especialProductClass").contentWindow.loadData();                        
        }
    }
}
            
/* ��Ӧ�̹�Ӧ��Ʒ��Ϣ  */
function suppliersProducts() {
    var sm = CustomerGrid.getSelectionModel();
    var selectData = sm.getSelected();
    if (selectData == null || selectData.length == 0 || selectData.length > 1) {
        Ext.Msg.alert("��ʾ", "��ѡ����Ҫ���õĹ�Ӧ����Ϣһ�У�");
    }
    else {
        //check
        if(selectData.data.OrgId != <% =ZJSIG.UIProcess.ADM.UIAdmUser.OrgID(this)%>){
            Ext.Msg.alert("��ʾ", "�ÿͻ���ʡ��˾ͳһά����");
            return;
        }
        suppliersProductWindow.show();
        suppliersProductWindow.setTitle("��Ӧ�̹�Ӧ��Ʒ����"); //alert(selectData.data.DrawInvId);
//                    document.getElementById("especialProductClass").src = "../product/frmCrmCustomerFixPriceHotKey.aspx?CustomerId=" + selectData.data.CustomerId;
        if (document.getElementById("suppliersProductFrame").src.indexOf("frmSuppliersProductList.aspx") == -1) {
            document.getElementById("suppliersProductFrame").src = "frmSuppliersProductList.aspx?suppliersId=" + selectData.data.CustomerId;
        }
        else {
            document.getElementById("suppliersProductFrame").contentWindow.suppliersId = selectData.data.CustomerId;
            document.getElementById("suppliersProductFrame").contentWindow.loadData();                        
        }
    }
}

/*------��ʼ�������ݵĴ��� Start---------------*/
if (typeof (suppliersProductWindow) == "undefined") {//�������2��windows����
    suppliersProductWindow = new Ext.Window({
        id: 'DvlsuppliersProductWindow'
        , iconCls: 'upload-win'
        , height: 500
        , width: 700
        , layout: 'fit'
        , plain: true
        , modal: true
        //, border:false
        , constrain: true
        , resizable: false
        , closeAction: 'hide'
        , autoDestroy: true
        , html: '<iframe id="suppliersProductFrame" width="100%" height="100%" border=0 src="#"></iframe>'
        //,autoScroll:true
    });
}
suppliersProductWindow.addListener("hide", function() {
});
/*------ʵ��toolbar�İ�ť���� end---------------*/
/*------����toolbar end---------------*/

/*------��ʼ�������ݵĴ��� Start---------------*/
if (typeof (uploadespecialProductWindow) == "undefined") {//�������2��windows����
    uploadespecialProductWindow = new Ext.Window({
        id: 'DvlespecialProductWindow'
        , iconCls: 'upload-win'
        , height: 400
        , width: 600
        , layout: 'fit'
        , plain: true
        , modal: true
        //, border:false
        , constrain: true
        , resizable: false
        , closeAction: 'hide'
        , autoDestroy: true
        , html: '<iframe id="especialProductw" width="100%" height="100%" border=0 src="#"></iframe>'
        //,autoScroll:true
    });
}
uploadespecialProductWindow.addListener("hide", function() {
});

/*-----------��·��Ϣ����-----------------------/

/*------��ʼ�������ݵĴ��� Start---------------*/
if (typeof (uploadespecialClassWindow) == "undefined") {//�������2��windows����
    uploadespecialClassWindow = new Ext.Window({
        id: 'DvlespecialProductClassWindow'
        , iconCls: 'upload-win'
        , height: 500
        , width: 700
        , layout: 'fit'
        , plain: true
        , modal: true
        //, border:false
        , constrain: true
        , resizable: false
        , closeAction: 'hide'
        , autoDestroy: true
        , html: '<iframe id="especialProductClass" width="100%" height="100%" border=0 src="#"></iframe>'
        //,autoScroll:true
    });
}
uploadespecialClassWindow.addListener("hide", function() {
});

/*------����ͻ��������������� start--------*/
var combo = new Ext.form.ComboBox({

    fieldLabel: '��������',
    name: 'folderMoveTo',
    store: dsDistributionType,
    displayField: 'DicsName',
    valueField: 'DicsCode',
    mode: 'local',
    editable: false,
    //loadText:'loading ...',
    typeAhead: true, //�Զ�����һ����������ѡ�ȫ����
    triggerAction: 'all',
    selectOnFocus: true,
    forceSelection: true,
    width: 100

});

/* ----------------����datagrid�б�json��ʽ ----------*/
var customerListStore = new Ext.data.Store
({
    url: 'customerManage.aspx?method=getCus' + owner,
    reader: new Ext.data.JsonReader({
        totalProperty: 'totalProperty',
        root: 'root'
    }, [
    { name: "CustomerId" },
    { name: "CustomerNo" },
    { name: "ShortName" },
    { name: "ChineseName" },
    { name: "LinkMan" },
    { name: "LinkTel" },
    { name: "LinkMobile" },
    { name: "Fax" },
    { name: "DistributionTypeText" },
    { name: "MonthQuantity",type:'float' },
    { name: "IsCust" },
    { name: "OrgId" },
    { name: "IsProvide" },
    { name: "IsOrthercust" },
    { name: 'CreateDate',type:'date' },
    { name: 'RouteNo'}
    ])
   ,
   sortData: function(f, direction) {
        var tempSort = Ext.util.JSON.encode(customerListStore.sortInfo);
        if (sortInfor != tempSort) {
            sortInfor = tempSort;
            customerListStore.baseParams.SortInfo = sortInfor;
            customerListStore.load({ params: { limit: defaultPageSize, start: 0} });
        }
    },
    listeners:
    {
      scope: this,
      load: function() {
          //���ݼ���Ԥ����,������һЩ�ϲ�����ʽ����Ȳ���
      }
    }
});

customerListStore.baseParams.IsCustManager = custManager;
			  
var sortInfor = "";
			
var defaultPageSize = 10;
var toolBar = new Ext.PagingToolbar({
    pageSize: 10,
    store: customerListStore,
    displayMsg: '��ʾ��{0}����{1}����¼,��{2}��',
    emptyMsy: 'û�м�¼',
    displayInfo: true
});
var pageSizestore = new Ext.data.SimpleStore({
    fields: ['pageSize'],
    data: [[10], [20], [30]]
});
var combo1 = new Ext.form.ComboBox({
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
toolBar.addField(combo1);
combo1.on("change", function(c, value) {
    toolBar.pageSize = value;
    defaultPageSize = toolBar.pageSize;
}, toolBar);
combo1.on("select", function(c, record) {
    toolBar.pageSize = parseInt(record.get("pageSize"));
    defaultPageSize = toolBar.pageSize;
    toolBar.doLoad(0);
}, toolBar);


var sm = new Ext.grid.CheckboxSelectionModel({singleSelect: false});
            
var CustomerGrid = new Ext.grid.GridPanel({
    el: 'datagrid',
    //width: '100%',
    height: '100%',
    width:document.body.offsetWidth,
    //autoWidth: true,
    //autoHeight: true,
    autoScroll: true,
    bodyStyle: 'padding:0px,0px,2px,0px',
    monitorResize: true, 
    columnLines:true,
    layout: 'fit',
    id: 'customerdatagrid',
    store: customerListStore,
    loadMask: { msg: '���ڼ������ݣ����Ժ��' },
    sm: sm,
    /*  ����м�û�в�ѯ����form��ô����ֱ����tbar��ʵ����ɾ��
    tbar:[{
    text:"���",
    handler:this.showAdd,
    scope:this
    },"-",
    {
    text:"�޸�"
    },"-",{
    text:"ɾ��",
    handler:this.deleteBranch,
    scope:this
    }],
    */
    cm: new Ext.grid.ColumnModel([
        sm,
         new Ext.grid.RowNumberer(), //�Զ��к�
        {header: "�ͻ�ID", dataIndex: 'CustomerId', hidden: true, hideable: false },
        { header: "�ͻ����", width: 70, sortable: true, dataIndex: 'CustomerNo' },
        { header: "�ͻ����", width: 130, sortable: true, dataIndex: 'ShortName' },
        { header: "�ͻ�ȫ��", width: 180, sortable: true, dataIndex: 'ChineseName' },
        { header: "��ϵ��", width: 60, sortable: true, dataIndex: 'LinkMan' },
        { header: "��ϵ�绰", width: 90, sortable: true, dataIndex: 'LinkTel' },
        { header: "�ƶ��绰", width: 90, sortable: true, dataIndex: 'LinkMobile' },
        //{ header: "����", width: 30, sortable: true, dataIndex: 'Fax', hidden: true, hideable: false },
        { header: "��������", width: 60, sortable: true, dataIndex: 'DistributionTypeText' },
        //{ header: "������", width: 20, sortable: true, dataIndex: 'MonthQuantity' },
        { header: "����", width: 45, sortable: true, dataIndex: 'IsCust', renderer: { fn: function(v) { if (v == 1) return '��'; return '��'; } } },
        { header: "��Ӧ��", width: 55, sortable: true, dataIndex: 'IsProvide', renderer: { fn: function(v) { if (v == 1) return '��'; return '��'; } } },
        { header: "�޵��ο���", width: 80, sortable: true, dataIndex: 'IsOrthercust', renderer: { fn: function(v) { if (v == 1) return '��'; return '��'; } } },
        { header: "����ʱ��", width: 120, sortable: true, dataIndex: 'CreateDate', renderer: Ext.util.Format.dateRenderer('Y��m��d��')}//renderer: Ext.util.Format.dateRenderer('m/d/Y'),
    ]), listeners:
    {
        afterrender: function(component) {
	          //component.getBottomToolbar().refresh.hideParent = true;
	          //component.getBottomToolbar().refresh.hide();
        }
    },
    bbar:toolBar,
    viewConfig: {
        columnsText: '��ʾ����',
        scrollOffset: 20,
        sortAscText: '����',
        sortDescText: '����',
        forceFit: false
    }, 
    height: 350,
    closeAction: 'hide',
    stripeRows: true,
    loadMask: true//,
    //autoExpandColumn: 2
});

toolBar.addField(createPrintButton(customerListStore, CustomerGrid, ''));
printTitle = "�ͻ���Ϣ";
            
/**************��������ѡ����Ϣ***********************************/
//var orgId = 1;
        var selectOrgIds = 1;
        function selectOrgType() {

            if (selectOrgForm == null) {
                var showType = "getcurrentandchildrentree";
                if (orgId == 1) {
                    showType = "getcurrentAndChildrenTreeByArea";
                }
                showOrgForm("", "", "../../ba/sysadmin/frmAdmOrgList.aspx?method=" + showType);
                selectOrgForm.buttons[0].on("click", selectOrgOk);
                //            if (orgId == 1) {
                //                selectOrgTree.on('checkchange', treeCheckChange, selectOrgTree);
                //            }
                selectOrgTree.on('checkchange', treeOrgCheckChange, selectOrgTree);
            }
            else {
                showOrgForm("", "", "");
            }
        }
        function selectOrgOk() {
            var selectOrgNames = "";
            selectOrgIds = "";
            var selectNodes = selectOrgTree.getChecked();
            for (var i = 0; i < selectNodes.length; i++) {
                if (selectNodes[i].id.indexOf("A") != -1)
                    continue;
                if (selectOrgNames != "") {
                    selectOrgNames += ",";
                    selectOrgIds += ",";
                }
                selectOrgIds += selectNodes[i].id;
                selectOrgNames += selectNodes[i].text;

            }
            currentSelect.setValue(selectOrgNames);
        }

        //����ѡ
        function treeOrgCheckChange(node, checked) {
            selectOrgTree.un('checkchange', treeOrgCheckChange, selectOrgTree);
            if (checked) {
                var selectNodes = selectOrgTree.getChecked();
                for (var i = 0; i < selectNodes.length; i++) {
                    if (selectNodes[i].id != node.id) {
                        selectNodes[i].ui.toggleCheck(false);
                        selectNodes[i].attributes.checked = false;
                    }
                }
            }
            selectOrgTree.on('checkchange', treeOrgCheckChange, selectOrgTree);
        }
        
        this.getSelectedValue = function(columnName) {
            switch (columnName) {
                case "ProductType":
                    return selectedProductIds;
                case "OrgId":
                    if (selectOrgIds == '1')
                        return "";
                    return selectOrgIds;
                case"RouteId":
                    return selectedRouteId;
            }
        }
        
        this.selectShow = function(columnName) {
            switch (columnName) {
                case "OrgId":
                    selectOrgType();
                    break;
                case"RouteId":
                    selectRoute();
                    break;
            }
        }
/***********************����ѡ����Ϣ����*****************************************/
createSearch(CustomerGrid, customerListStore, "searchForm");
searchForm.el = "searchForm";
searchForm.render();

if(orgId==1)
{
var addRow = new fieldRowPattern({
            id: 'OrgId',
            name: '������λ',
            dataType: 'select'
        });
        fieldStore.add(addRow);
        }
 else
 {
    var addRow = new fieldRowPattern({
        id: 'RouteId',
        name: '��·��Ϣ',
        dataType: 'select'});
        fieldStore.add(addRow);
    addRow = new fieldRowPattern({
        id: 'RouteNo',
        name: '��·���',
        dataType: 'input'});
        fieldStore.add(addRow);
 }
        
txtFieldValue.on("focus", selectProductType);


        function selectProductType() {
            switch (cmbField.getValue()) {
                case "ProductType":
                    currentSelect = txtFieldValue;
                    selectShow("ProductType");
                    break;
                case "OrgId":
                    currentSelect = txtFieldValue;
                    selectOrgType();
                    break;
                case"RouteId":
                    currentSelect = txtFieldValue;
                    selectShow("ProductType");
                    break;
            }
        }

CustomerGrid.render();

 var cusidPanel = new Ext.form.TextField({
    style: 'margin-left:0px',
    cls: 'key',
    xtype: 'textfield',
    fieldLabel: '�ͻ����',
    name: 'cusid',
    id: 'searchCust',
    anchor: '90%'
    // maxLength: 1000,  
    // allowBlank : true

});
var namePanel = new Ext.form.TextField({
    style: 'margin-left:0px',
    cls: 'key',
    xtype: 'textfield',
    fieldLabel: '�ͻ�����',
    name: 'nameCust',
    anchor: '90%'
});

//�����������첽���÷���
var ds = new Ext.data.Store({
    url: 'customerManage.aspx?method=getCusByConLike',
    reader: new Ext.data.JsonReader({
        root: 'root',
        totalProperty: 'totalProperty',
        id: 'searchId'
    }, [
    { name: 'CustomerId', mapping: 'CustomerId' },
    { name: 'CustomerNo', mapping: 'CustomerNo' },
    { name: 'ShortName', mapping: 'ShortName' },
    { name: 'LinkMan', mapping: 'LinkMan' },
    { name: 'CreateDate', mapping: 'CreateDate' }, // type: 'date', dateFormat: 'timestamp'},  
    {name: 'DistributionType', mapping: 'DistributionType' }
    ])
});
// �����������첽������ʾģ��
var resultTpl = new Ext.XTemplate(
    '<tpl for="."><div id="searchdivid" class="search-item">',
    '<h3><span>�ͻ���ţ�{CustomerNo}<br />�ͻ����ƣ� {ShortName}</span>�������ͣ�{DistributionType}</h3>',
    //'<br>����ʱ�䣺{createDate}',  
    '</div></tpl>'
);

var basicform = new Ext.FormPanel({
    id: 'basicform',
    title: '������Ϣ',
    name: 'basicform',
    labelAlign: 'left',
    buttonAlign: 'right',
    bodyStyle: 'padding:5px',
    //width:700,
    //height:450,
    frame: true,
    labelWidth: 70,
    autoDestroy: true,
    items:
    [{
        layout: 'column',   //�����Ԫ��Ϊ����Ϊ�в��ַ�ʽ
        border: false,
        items:
        [{//��һ�п�ʼ
            columnWidth: .33,  //����ռ�õĿ�ȣ���ʶΪ50��
            layout: 'form',
            border: false,
            items: 
            [{
                cls: 'key',
                xtype: 'textfield',
                fieldLabel: '�ͻ�id',
                name: 'CustomerId',
                id: 'CustomerId',
                anchor: '90%',
                vtype: 'alphanum', //ֻ��������ĸ�����֣��޷���������
                vtypeText: 'ֻ��������ĸ������',
                hidden: true,
                hideLabel: true
                // allowBlank : true
            },
            {
                cls: 'key',
                xtype: 'textfield',
                fieldLabel: '<b>���*</b>',
                name: 'CustomerNo',
                id: 'CustomerNo',
                anchor: '90%'//,
                //vtype: 'alphanum', //ֻ��������ĸ�����֣��޷���������
                //vtypeText: 'ֻ��������ĸ������'
                // maxLength: 1000,  
                // allowBlank : true
            }]
        }, //��һ�е�һ��
        {
            columnWidth: .67,  //����ռ�õĿ�ȣ���ʶΪ50��
            layout: 'form',
            border: false,
            items: [{
              cls: 'key',
              xtype: 'textfield',
              fieldLabel: '<font color=red><b>��������*</b></font>',
              name: 'ChineseName',
              id: 'ChineseName',
              anchor: '90%'
              // maxLength: 1000,  
                // allowBlank : true
            }]//��һ�еڶ���
        }]
    },
    {//�ڶ��п�ʼ
        layout: 'column',   //�����Ԫ��Ϊ����Ϊ�в��ַ�ʽ
        border: false,
        items: [{
            columnWidth: .33,  //����ռ�õĿ�ȣ���ʶΪ50��
            layout: 'form',
            border: false,
            items: [{//�ڶ��е�һ��
                cls: 'key',
                xtype: 'textfield',
                fieldLabel: '������',
                name: 'MnemonicNo',
                id: 'MnemonicNo',
                anchor: '90%'
                // maxLength: 1000,  
                // allowBlank : true
            }]
        },
        {//�ڶ��еڶ���
            columnWidth: .67,  //����ռ�õĿ�ȣ���ʶΪ50��
            layout: 'form',
            border: false,
            items: [{
                cls: 'key',
                xtype: 'textfield',
                fieldLabel: 'Ӣ������',
                name: 'EnglishName',
                id: 'EnglishName',
                anchor: '90%'
                // maxLength: 1000,  
                // allowBlank : true
            }]
        }]
    },
    {//�����п�ʼ
        layout: 'column',   //�����Ԫ��Ϊ����Ϊ�в��ַ�ʽ
        border: false,
        items: [{//�����е�һ��
            columnWidth: .33,  //����ռ�õĿ�ȣ���ʶΪ50��
            layout: 'form',
            border: false,
            items: [{

                cls: 'key',
                xtype: 'textfield',
                fieldLabel: '<b>���*</b>',
                name: 'ShortName',
                id: 'ShortName',
                anchor: '90%'
                // maxLength: 1000,  
                // allowBlank : true

            }]
        },
        {//�����еڶ���
            columnWidth: .67,  //����ռ�õĿ�ȣ���ʶΪ50��
            layout: 'form',
            border: false,
            items: [{

                cls: 'key',
                xtype: 'textfield',
                fieldLabel: '<b>��ַ*</b>',
                name: 'Address',
                id: 'Address',
                anchor: '90%'
                // maxLength: 1000,  
                // allowBlank : true

            }]
        }]
    },
    {//�����п�ʼ
        layout: 'column',   //�����Ԫ��Ϊ����Ϊ�в��ַ�ʽ
        border: false,
        items: [{//�����е�һ��
            columnWidth: .33,  //����ռ�õĿ�ȣ���ʶΪ50��
            layout: 'form',
            border: false,
            items: [{

                cls: 'key',
                xtype: 'textfield',
                fieldLabel: '<b>��ϵ��*</b>',
                name: 'LinkMan',
                id: 'LinkMan',
                anchor: '90%'
                // maxLength: 1000,  
                // allowBlank : true

                }]
            },
            {//�����еڶ���
                columnWidth: .318,  //����ռ�õĿ�ȣ���ʶΪ50��
                layout: 'form',
                border: false,
                items: [{

                    cls: 'key',
                    xtype: 'textfield',
                    fieldLabel: '��ϵ�绰',
                    name: 'LinkTel',
                    id: 'LinkTel',
                    anchor: '90%'
                    // maxLength: 1000,  
                    // allowBlank : true

                }]
            },
            {//�����е�����
                columnWidth: .317,  //����ռ�õĿ�ȣ���ʶΪ50��
                layout: 'form',
                border: false,
                items: [{

                    cls: 'key',
                    xtype: 'textfield',
                    fieldLabel: '�ƶ��绰',
                    name: 'LinkMobile',
                    id: 'LinkMobile',
                    anchor: '90%'
                    // maxLength: 1000,  
                    // allowBlank : true

                }]
            }]
        },
        {//�����п�ʼ
            layout: 'column',   //�����Ԫ��Ϊ����Ϊ�в��ַ�ʽ
            border: false,
            items: [{//�����е�һ��
                columnWidth: .33,  //����ռ�õĿ�ȣ���ʶΪ50��
                layout: 'form',
                border: false,
                items: [{

                    cls: 'key',
                    xtype: 'textfield',
                    fieldLabel: '�ʱ�',
                    name: 'Zipcode',
                    id: 'Zipcode',
                    anchor: '90%'
                    // maxLength: 1000,  
                    // allowBlank : true

                }]
            },
            {//�����еڶ���
                columnWidth: .318,  //����ռ�õĿ�ȣ���ʶΪ50��
                layout: 'form',
                border: false,
                items: [{

                    cls: 'key',
                    xtype: 'textfield',
                    fieldLabel: '����',
                    name: 'Fax',
                    id: 'Fax',
                    anchor: '90%'
                    // maxLength: 1000,  
                    // allowBlank : true

                }]
            },
            {//�����е�����
                columnWidth: .317,  //����ռ�õĿ�ȣ���ʶΪ50��
                layout: 'form',
                border: false,
                items: [{

                    cls: 'key',
                    xtype: 'textfield',
                    fieldLabel: '��������',
                    name: 'Email',
                    id: 'Email',
                    anchor: '90%',
                    vtype: 'email', //email��֤��Ҫ��ĸ�ʽ��"langsin@gmail.com"
                    vtypeText: '������Ч�������ַ,��ʽΪ:username@domain.com'//������ʾ��Ϣ,
                    // maxLength: 1000,  
                    // allowBlank : true

                }]
            }]
        },
        {//������
            layout: 'column',   //�����Ԫ��Ϊ����Ϊ�в��ַ�ʽ
            border: false,
            items: [{//�����е�һ��
                columnWidth: .33,  //����ռ�õĿ�ȣ���ʶΪ50��
                layout: 'form',
                border: false,
                items: [{

                    cls: 'key',
                    xtype: 'textfield',
                    fieldLabel: '�ͻ�ʱ��',
                    name: 'DeliverDate',
                    id: 'DeliverDate',
                    anchor: '90%'
                    //editable: false
                    // maxLength: 1000,  
                    // allowBlank : true

                }]
            },
            {//�����еڶ���
                columnWidth: .67,  //����ռ�õĿ�ȣ���ʶΪ50��
                layout: 'form',
                border: false,
                items: [{
                    layout:'column',
                    border: false,
                    labelSeparator: '��',
                    items: [{
                        layout:'form',
	                    border: false,
	                    columnWidth:0.275*version,
	                    items: [
	                    {
                            cls: 'key',
                            xtype: 'textfield',
                            fieldLabel: '�ͻ���ַ',
                            name: 'DeliverAdd',
                            id: 'DeliverAdd',
                            anchor: '100%'
                            // maxLength: 1000,  
                            // allowBlank : true
                        }]
                    },{
                       layout: 'form',
                       columnWidth: .035*version,  //����ռ�õĿ�ȣ���ʶΪ20��
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
                                     manageAddContent();
                                }
                            }
                        }]
                    }]
               }]
            }]
        },
        {//������
            layout: 'column',   //�����Ԫ��Ϊ����Ϊ�в��ַ�ʽ
            border: false,
            items: [{//�����е�һ��
                columnWidth: .33,  //����ռ�õĿ�ȣ���ʶΪ50��
                layout: 'form',
                border: false,
                items: [{
                    cls: 'key',
                    xtype: 'combo',
                    fieldLabel: '��������',
                    name: 'DistributionType',
                    id: 'DistributionType',
                    anchor: '90%',
                    editable: false,
                    triggerAction: 'all',
                    store: dsDistributionType,
                    displayField: 'DicsName',
                    valueField: 'DicsCode',
                    mode: 'local',
                    value: dsDistributionType.getAt(0).data.DicsCode
                    // maxLength: 1000,  
                    // allowBlank : true

                }]
            },
            {//�����еڶ���
                columnWidth: .67,  //����ռ�õĿ�ȣ���ʶΪ50��
                layout: 'form',
                border: false,
                items: [{

                    cls: 'key',
                    xtype: 'textfield',
                    fieldLabel: '�ͻ���λ',
                    name: 'DeliverCorp',
                    id: 'DeliverCorp',
                    anchor: '90%'
                    // maxLength: 1000,  
                    // allowBlank : true

                }]
            }]
        },
        {//�ڰ���
            layout: 'column',   //�����Ԫ��Ϊ����Ϊ�в��ַ�ʽ
            border: false,
            items: [{//�ڰ��е�һ��
                columnWidth: .33,  //����ռ�õĿ�ȣ���ʶΪ50��
                layout: 'form',
                border: false,
                items: [{

                    cls: 'key',
                    xtype: 'textfield',
                    fieldLabel: '������',
                    name: 'MonthQuantity',
                    id: 'MonthQuantity',
                    anchor: '90%'
                    // maxLength: 1000,  
                    // allowBlank : true

                }]
            },
            {//�ڰ��еڶ���
                columnWidth: .318,  //����ռ�õĿ�ȣ���ʶΪ50��
                layout: 'form',
                border: false,
                items: [{

                    cls: 'key',
                    xtype: 'combo',
                    fieldLabel: '��ҵ����',
                    name: 'CorpKind',
                    id: 'CorpKind',
                    displayField: 'DicsName',
                    valueField: 'DicsCode',
                    store: dsCorpKind,
                    mode: 'local',
                    triggerAction: 'all',
                    anchor: '90%',
                    value: dsCorpKind.getAt(0).data.DicsCode
                    // maxLength: 1000,  
                    // allowBlank : true

                }]
            },
            {//�ڰ��е�����
                columnWidth: .317,  //����ռ�õĿ�ȣ���ʶΪ50��
                layout: 'form',
                border: false,
                items: [{

                    cls: 'key',
                    xtype: 'datefield',
                    fieldLabel: '����ʱ��',
                    name: 'EodrDate',
                    id: 'EodrDate',
                    anchor: '90%',
                    format: 'Y��m��d��'
                    //editable: false
                    // maxLength: 1000,  
                    // allowBlank : true

                }]
            }]
        },
        {//�ھ���
            layout: 'column',   //�����Ԫ��Ϊ����Ϊ�в��ַ�ʽ
            border: false,
            items: [{//�ھ��е�һ��
                columnWidth: .33,  //����ռ�õĿ�ȣ���ʶΪ50��
                layout: 'form',
                border: false,
                items: [{
                    cls: 'key',
                    xtype: 'combo',
                    fieldLabel: '����ʡ',
                    name: 'Province',
                    id: 'Province',
                    displayField: 'DicsName',
                    valueField: 'DicsCode',
                    store: dsProvince,
                    mode: 'local',
                    triggerAction: 'all',
                    anchor: '90%',
                    value: dsProvince.getAt(0).data.DicsCode
                    // maxLength: 1000,  
                    // allowBlank : true

                }]
            },
            {//�ھ��еڶ���
                columnWidth: .318,  //����ռ�õĿ�ȣ���ʶΪ50��
                layout: 'form',
                border: false,
                items: [{
                    cls: 'key',
                    xtype: 'combo',
                    fieldLabel: '������',
                    name: 'City',
                    id: 'City',
                    displayField: 'DicsName',
                    valueField: 'DicsCode',
                    store: dsCity,
                    mode: 'local',
                    triggerAction: 'all',
                    anchor: '90%',
                    value: dsCity.getAt(0).data.DicsCode
                    // maxLength: 1000,  
                    // allowBlank : true

                }]
            },
            {//�ھ��е�����
                columnWidth: .317,  //����ռ�õĿ�ȣ���ʶΪ50��
                layout: 'form',
                border: false,
                items: [{
                    cls: 'key',
                    xtype: 'combo',
                    fieldLabel: '��������',
                    name: 'Town',
                    id: 'Town',
                    displayField: 'DicsName',
                    valueField: 'DicsCode',
                    store: dsTown,
                    mode: 'local',
                    triggerAction: 'all',
                    anchor: '90%',
                    value: dsTown.getAt(0).data.DicsCode
                    // maxLength: 1000,  
                    // allowBlank : true

                }]
            }]
        },
        {//��ʮ��
            layout: 'column',   //�����Ԫ��Ϊ����Ϊ�в��ַ�ʽ
            border: false,
            items: [{//��ʮ�е�һ��
                style: 'align:left',
                columnWidth: .25,  //����ռ�õĿ�ȣ���ʶΪ50��
                layout: 'form',
                border: false,
                items: [{
                    cls: 'key',
                    xtype: 'checkbox',
                    boxLabel: '�ڲ��ͻ�',
                    name: 'IsIncust',
                    id: 'IsIncust',
                    anchor: '90%',
                    hideLabel: true
                    // maxLength: 1000,  
                    // allowBlank : true

            }]
            },
            {   //��ʮ�еڶ���
                style: 'align:left',
                columnWidth: .25,  //����ռ�õĿ�ȣ���ʶΪ50��
                layout: 'form',
                border: false,
                items: [{

                    cls: 'key',
                    xtype: 'checkbox',
                    value: 'gys',
                    boxLabel: '��Ӧ��',
                    name: 'IsProvide',
                    id: 'IsProvide',
                    anchor: '90%',
                    hideLabel: true
                    // maxLength: 1000,  
                    // allowBlank : true

                }]
            },
            {   //��ʮ�е�����
                style: 'align:left',
                columnWidth: .25,  //����ռ�õĿ�ȣ���ʶΪ50��
                layout: 'form',
                border: false,
                items: [{

                    cls: 'key',
                    xtype: 'checkbox',
                    boxLabel: '����',
                    name: 'IsCust',
                    id: 'IsCust',
                    anchor: '90%',
                    hideLabel: true
                    // maxLength: 1000,  
                    // allowBlank : true

                }]
            },
            {   //��ʮ�е�����
                style: 'align:left',
                columnWidth: .25,  //����ռ�õĿ�ȣ���ʶΪ50��
                layout: 'form',
                border: false,
                items: [{

                    cls: 'key',
                    xtype: 'checkbox',
                    boxLabel: '�޵��ο���',
                    name: 'IsOrthercust',
                    id: 'IsOrthercust',
                    anchor: '90%',
                    hideLabel: true
                    // maxLength: 1000,  
                    // allowBlank : true

                }]
            }]
        },
        {//��ʮһ��
            layout: 'column',   //�����Ԫ��Ϊ����Ϊ�в��ַ�ʽ
            border: false,
            items: [{//��ʮһ�е�һ��
                columnWidth: .318,  //����ռ�õĿ�ȣ���ʶΪ50��
                layout: 'form',
                border: false,
                items: [{
                    cls: 'key',
                    xtype: 'combo', //combo
                    fieldLabel: '�ͻ�����',
                    name: 'CustKind',
                    id: 'CustKind',
                    anchor: '90%',
                    displayField: 'DicsName',
                    valueField: 'DicsCode',
                    store: dsCustKind,
                    mode: 'local',
                    triggerAction: 'all',
                    anchor: '90%',
                    value: dsCustKind.getAt(0).data.DicsCode
                }]
            },
            {//��ʮһ�еڶ���
                columnWidth: .33,  //����ռ�õĿ�ȣ���ʶΪ50��
                layout: 'form',
                border: false,
                items: [{
                    cls: 'key',
                    xtype: 'combo',
                    fieldLabel: '<b>�ͻ�״̬*</b>',
                    name: 'State',
                    id: 'State',
                    store: [[0, '����'], [1, '����'], [2, 'ɾ��']],
                    mode: 'local',
                    triggerAction: 'all',
                    editable: false,
                    anchor: '90%',
                    value: 0
                    // maxLength: 1000,  
                    // allowBlank : true
                }]
            },
            {//��ʮһ�е�����
                columnWidth: .317,  //����ռ�õĿ�ȣ���ʶΪ50��
                layout: 'form',
                border: false,
                items: [{
                    cls: 'key',
                    xtype: 'combo',
                    fieldLabel: '�Ƿ���',
                    name: 'IsShare',
                    id: 'IsShare',
                    store: [[0, '������'], [1, '����']],
                    mode: 'local',
                    triggerAction: 'all',
                    editable: false,
                    anchor: '90%',
                    value: 0
                    // maxLength: 1000,  
                    // allowBlank : true
                }]
            }]
        }]
});


var extraform = new Ext.FormPanel({
    id: 'extraform',
    title: '��չ��Ϣ',
    name: 'extraform',
    labelAlign: 'left',
    buttonAlign: 'right',
    bodyStyle: 'padding:5px',
    frame: true,
    //width:700,
    //height:450,
    labelWidth: 70,
    autoDestroy: true,
    items:
    [{//��һ�п�ʼ
        layout: 'column',   //�����Ԫ��Ϊ����Ϊ�в��ַ�ʽ
        border: false,
        items:
        [{//��һ�е�һ�п�ʼ
            columnWidth: .33,  //����ռ�õĿ�ȣ���ʶΪ50��
            layout: 'form',
            border: false,
            items: [{

                cls: 'key',
                xtype: 'textfield',
                fieldLabel: '���ö��',
                name: 'CreditSum',
                id: 'CreditSum',
                anchor: '90%'
                // maxLength: 1000,  
                // allowBlank : true

            }]
        },
        {
            columnWidth: .318,  //����ռ�õĿ�ȣ���ʶΪ50��
            layout: 'form',
            border: false,
            items: [{
                cls: 'key',
                xtype: 'combo',
                fieldLabel: '���㷽ʽ',
                name: 'SettlementWay',
                id: 'SettlementWay',
                anchor: '90%',
                editable: false,
                triggerAction: 'all',
                displayField: 'DicsName',
                valueField: 'DicsCode',
                store: dsSettlementWay,
                mode: 'local',
                triggerAction: 'all',
                editable: false,
                value: dsSettlementWay.getAt(0).data.DicsCode

            }]
        },
       {
           columnWidth: .317,  //����ռ�õĿ�ȣ���ʶΪ50��
           layout: 'form',
           border: false,
           items: [{
               cls: 'key',
               xtype: 'checkbox',
               value: 'kp',
               boxLabel: '��Ʊ',
               name: 'IsMakeinvoice',
               id: 'IsMakeinvoice',
               anchor: '90%'
               // maxLength: 1000,  
               // allowBlank : true

            }]
        }]
    }, {
        layout: 'column',   //�����Ԫ��Ϊ����Ϊ�в��ַ�ʽ
        border: false,
        items:
        [{//
            columnWidth: .33,  //����ռ�õĿ�ȣ���ʶΪ50��
            layout: 'form',
            border: false,
            items: [{

                cls: 'key',
                xtype: 'datefield',
                fieldLabel: '��֤����',
                name: 'AwarDdate',
                id: 'AwarDdate',
                anchor: '90%',
                format: 'Y��m��d��'
                //editable: false
                // maxLength: 1000,  
                // allowBlank : true

            }]
        },
        {
            columnWidth: .67,  //����ռ�õĿ�ȣ���ʶΪ50��
            layout: 'form',
            border: false,
            items: [{

                cls: 'key',
                xtype: 'combo',
                fieldLabel: '������ҵ',
                name: 'TradeType',
                id: 'TradeType',
                anchor: '90%',
                displayField: 'DicsName',
                valueField: 'DicsCode',
                mode: 'local',
                triggerAction: 'all',
                store: dsTradeType,
                editable: false,
                value: dsTradeType.getAt(0).data.DicsCode
            }]
        }]
    },
    {
        layout: 'column',   //�����Ԫ��Ϊ����Ϊ�в��ַ�ʽ
        border: false,
        items:
        [{//
            columnWidth: .33,  //����ռ�õĿ�ȣ���ʶΪ50��
            layout: 'form',
            border: false,
            items: [{

                cls: 'key',
                xtype: 'textfield',  //combo
                fieldLabel: '���㷽',
                name: 'SettlementParty',
                id: 'SettlementParty',
                anchor: '90%',
                store: [[], [], []]
                // maxLength: 1000,  
                // allowBlank : true

            }]
        },
        {
            columnWidth: .67,  //����ռ�õĿ�ȣ���ʶΪ50��
            layout: 'form',
            border: false,
            items: [{

                cls: 'key',
                xtype: 'combo', //combo
                fieldLabel: '������֯',
                name: 'ClearingOrg',
                id: 'ClearingOrg',
                store: dsClearingOrg,
                displayField: 'OrgName',
                valueField: 'OrgId',
                typeAhead: true,
                triggerAction: 'all',
                emptyValue: '',
                selectOnFocus: true,
                forceSelection: true,
                mode:'local',
                anchor: '90%'
                // maxLength: 1000,  
                // allowBlank : true
 
            }]
        }]
    },
    {
        layout: 'column',   //�����Ԫ��Ϊ����Ϊ�в��ַ�ʽ
        border: false,
        items:
        [{
            columnWidth: .33,  //����ռ�õĿ�ȣ���ʶΪ50��
            layout: 'form',
            border: false,
            items: [{
                cls: 'key',
                xtype: 'combo',
                fieldLabel: '��������',
                name: 'SettlementType',
                id: 'SettlementType',
                anchor: '90%',
                displayField: 'DicsName',
                valueField: 'DicsCode',
                mode: 'local',
                triggerAction: 'all',
                store: dsSettlementType,
                editable: false,
                value: dsSettlementType.getAt(0).data.DicsCode

                }]
            },
            {
                columnWidth: .317,  //����ռ�õĿ�ȣ���ʶΪ50��
                layout: 'form',
                border: false,
                items: [{

                    cls: 'key',
                    xtype: 'combo',
                    fieldLabel: '�������',
                    name: 'SettlementCurrency',
                    id: 'SettlementCurrency',
                    anchor: '90%',
                    displayField: 'DicsName',
                    valueField: 'DicsCode',
                    mode: 'local',
                    triggerAction: 'all',
                    store: dsSettlementCurrency,
                    editable: false,
                    value: dsSettlementCurrency.getAt(0).data.DicsCode
                }]
            },
            {
                columnWidth: .318,  //����ռ�õĿ�ȣ���ʶΪ50��
                layout: 'form',
                border: false,
                items: [{

                    cls: 'key',
                    xtype: 'combo',
                    fieldLabel: '��Ʊ����',
                    name: 'InvoiceType',
                    id: 'InvoiceType',
                    anchor: '90%',
                    displayField: 'DicsName',
                    valueField: 'DicsCode',
                    mode: 'local',
                    triggerAction: 'all',
                    store: dsInvoice,
                    editable: false,
                    value: dsInvoice.getAt(0).data.DicsCode
                }]
            }]
        },
        {
            layout: 'column',   //�����Ԫ��Ϊ����Ϊ�в��ַ�ʽ
            border: false,
            items:
            [{//
                columnWidth: .33,  //����ռ�õĿ�ȣ���ʶΪ50��
                layout: 'form',
                border: false,
                items: [{

                    cls: 'key',
                    xtype: 'textfield',
                    fieldLabel: '������',
                    name: 'Principal',
                    id: 'Principal',
                    anchor: '90%'
                    // maxLength: 1000,  
                    // allowBlank : true

                }]
            },
            {
                columnWidth: .32,  //����ռ�õĿ�ȣ���ʶΪ50��
                layout: 'form',
                border: false,
                items: [{
                    style: 'margin-top:3px',
                    cls: 'key',
                    xtype: 'textfield',
                    fieldLabel: '�����˵绰',
                    name: 'PrincipalTel',
                    id: 'PrincipalTel',
                    anchor: '90%'
                    // maxLength: 1000,  
                    // allowBlank : true

            }]
        },
        {
            columnWidth: .32,  //����ռ�õĿ�ȣ���ʶΪ50��
            layout: 'form',
            border: false,
            items: 
            [{
                style: 'margin-top:3px',
                cls: 'key',
                xtype: 'textfield',
                fieldLabel: '��·���',
                name: 'RouteName',
                id: 'RouteName',
                anchor: '90%'
                // maxLength: 1000,  
                // allowBlank : true

            },{
                xtype: 'hidden',
                name: 'RouteId',
                id: 'RouteId',
                anchor: '90%'
                // maxLength: 1000,  
                // allowBlank : true

            }]
        }]
    },{
            layout: 'column',   //�����Ԫ��Ϊ����Ϊ�в��ַ�ʽ
            border: false,
            items:
            [{//
                columnWidth: .33,  //����ռ�õĿ�ȣ���ʶΪ50��
                layout: 'form',
                border: false,
                items: [{

                    cls: 'key',
                    xtype: 'textfield',
                    fieldLabel: '��������',
                    name: 'BalanceBankName',
                    id: 'BalanceBankName',
                    anchor: '90%'
                    // maxLength: 1000,  
                    // allowBlank : true

                }]
            },
            {
                columnWidth: .32,  //����ռ�õĿ�ȣ���ʶΪ50��
                layout: 'form',
                border: false,
                items: [{
                    style: 'margin-top:3px',
                    cls: 'key',
                    xtype: 'textfield',
                    fieldLabel: '�����˺�',
                    name: 'BlanaceBankAccount',
                    id: 'BlanaceBankAccount',
                    anchor: '90%'
                    // maxLength: 1000,  
                    // allowBlank : true

            }]
        },
        {
            columnWidth: .32,  //����ռ�õĿ�ȣ���ʶΪ50��
            layout: 'form',
            border: false,
            items: 
            [{
                cls: 'key',
                xtype: 'combo',
                fieldLabel: '��������',
                name: 'BankName',
                id: 'BankName',
                anchor: '90%',
                displayField: 'DicsName',
                valueField: 'DicsCode',
                mode: 'local',
                triggerAction: 'all',
                store: dsBalanceBank,
                editable: false//,
                //value: dsBalanceBank.getAt(0).data.DicsCode

            }]
        }]
    },
    {
        layout: 'column',   //�����Ԫ��Ϊ����Ϊ�в��ַ�ʽ
        border: false,
        items:
        [{
            columnWidth: .33,  //����ռ�õĿ�ȣ���ʶΪ50��
            layout: 'form',
            border: false,
            items: [{
                cls: 'key',
                xtype: 'textfield',
                fieldLabel: '��������',
                name: 'BankId',
                id: 'BankId',
                anchor: '90%'
                // maxLength: 1000,  
                // allowBlank : true
            }]
        }
        ,{//
            columnWidth: .318,  //����ռ�õĿ�ȣ���ʶΪ50��
            layout: 'form',
            border: false,
            items: [{
                cls: 'key',
                xtype: 'textfield',
                fieldLabel: '�����˻�',
                name: 'BankAccount',
                id: 'BankAccount',
                anchor: '90%'
                // maxLength: 1000,  
                // allowBlank : true

            }]
        },
        {
            columnWidth: .317,  //����ռ�õĿ�ȣ���ʶΪ50��
            layout: 'form',
            border: false,
            items: [{
                cls: 'key',
                xtype: 'datefield',
                fieldLabel: '����ʱ��',
                name: 'BankDate',
                id: 'BankDate',
                anchor: '90%',
                format: 'Y��m��d��'
                //editable: false
                // maxLength: 1000,  
                // allowBlank : true

            }]
        }]
    },
    {
        layout: 'column',   //�����Ԫ��Ϊ����Ϊ�в��ַ�ʽ
        border: false,
        items:
        [{//
            columnWidth: .33,  //����ռ�õĿ�ȣ���ʶΪ50��
            layout: 'form',
            border: false,
            items: [{

                cls: 'key',
                xtype: 'textfield',
                fieldLabel: '���֤��',
                name: 'LicenseNo',
                id: 'LicenseNo',
                anchor: '90%'
                // maxLength: 1000,  
                // allowBlank : true

            }]
        },
        {
            columnWidth: .318,  //����ռ�õĿ�ȣ���ʶΪ50��
            layout: 'form',
            border: false,
            items: [{

                cls: 'key',
                xtype: 'textfield',
                fieldLabel: '���̱��',
                name: 'BusinessNo',
                id: 'BusinessNo',
                anchor: '90%'
                // maxLength: 1000,  
                // allowBlank : true

            }]
        },
        {
            columnWidth: .317,  //����ռ�õĿ�ȣ���ʶΪ50��
            layout: 'form',
            border: false,
            items: [{

                cls: 'key',
                xtype: 'textfield',
                fieldLabel: '˰��',
                id: 'TaxNo',
                name: 'TaxNo',
                anchor: '90%'
                // maxLength: 1000,  
                // allowBlank : true

            }]
        }]
    },
    {
        layout: 'column',   //�����Ԫ��Ϊ����Ϊ�в��ַ�ʽ
        border: false,
        items:
        [{//
            columnWidth: 1,  //����ռ�õĿ�ȣ���ʶΪ50��
            layout: 'form',
            border: false,
            items: [{

                cls: 'key',
                xtype: 'textfield',
                fieldLabel: '�Զ�����Ϣ',
                name: 'CustomizeInfo',
                id: 'CustomizeInfo',
                anchor: '93%'
                // maxLength: 1000,  
                // allowBlank : true

            }]
        }]
    },
    {
        layout: 'column',   //�����Ԫ��Ϊ����Ϊ�в��ַ�ʽ
        border: false,
        items:
        [{//
            columnWidth: 1,  //����ռ�õĿ�ȣ���ʶΪ50��
            layout: 'form',
            height: 50,
            border: false,
            items: [{

                cls: 'key',
                xtype: 'textarea',
                fieldLabel: '��ע',
                name: 'Remark',
                id: 'Remark',
                height: 45,
                anchor: '93%'

            }]
        }]
    }]
});
Ext.getCmp("RouteName").on("focus",selectRoute);
var routetree = null;
var routediv = null;
var routeSelectWin = null;
var selectedRouteId = '';
var fieldId = '';
function selectRoute()
{    
    selectedRouteId = '';
    fieldId = this.id;
    if(routediv == null){
        routediv = document.createElement('div');
        routediv.setAttribute('id', 'routetreeDiv');
        Ext.getBody().appendChild(routediv); 
    }
    var Tree = Ext.tree;    
    if( routetree == null){
        routetree = new Tree.TreePanel({
            el:'routetreeDiv',
            style: 'margin-left:0px',
            useArrows:true,//�Ƿ�ʹ�ü�ͷ
            autoScroll:true,
            animate:true,
            width:'150',
            height:'100%',
            minSize: 150,
	        maxSize: 180,
            enableDD:false,
            frame:true,
            border: false,
            containerScroll: true, 
            loader: new Tree.TreeLoader({
               dataUrl:'/crm/DefaultFind.aspx?method=getLineTreeByOrg&OrgId=<% =ZJSIG.UIProcess.ADM.UIAdmUser.OrgID(this)%>'
               })
        });
        routetree.on('click',function(node){  
            if(node.id ==0)//||!node.isLeaf()
                return;
            if(fieldId=='RouteName'){
                Ext.getCmp('RouteId').setValue(node.id);
                Ext.getCmp('RouteName').setValue(node.text);
            }else{
                selectedRouteId = node.id;
                currentSelect.setValue(node.text);
            }
            routeSelectWin.hide();
        }); 
        // set the root node
        var root = new Tree.AsyncTreeNode({
            text: '��·���',
            draggable:false,
            id:'0'
        });
        routetree.setRootNode(root);
    }    
    if( routeSelectWin == null){
        routeSelectWin = new Ext.Window({
             title:'��·��Ϣ',
             style: 'margin-left:0px',
             width:500 ,
             height:300, 
             constrain:true,
             layout: 'fit', 
             plain: true, 
             modal: true,
             closeAction: 'hide',
             autoDestroy :true,
             resizable:true,
             items: [routetree] 
        });
        routetree.root.reload();
    }
    routeSelectWin.show();    
}
                     
var content = new Ext.TabPanel({
    region: 'center',
    layoutOnTabChange: true,
    autoDestroy: true,
    activeTab: 1,
    width: 680,
    height: 490,
    border: false,
    items: [basicform, extraform]
});
                           
if (typeof (uploadWindow) == "undefined") {//�������2��windows����
    uploadWindow = new Ext.Window({
        id: 'formwindow',
        title: "�����ͻ�"
        , iconCls: 'upload-win'
        , width: 700
        , height: 420
        , layout: 'border'
        , plain: true
        , modal: true
        , constrain: true
        , resizable: false
        , closeAction: 'hide'
        , autoDestroy: true
       , items: [
         content
                //,nav
                // , new Ext.TabPanel({activeTab:0,border:false,items:extraform})
         ]

         , buttons: [{
             text: "����"
            , handler: function() {
                uploadFormValue();

            }
                , scope: this
         },
        {
            text: "ȡ��"
            , handler: function() {
                //content.remove(basicform);
                //content.remove(extraform);
                uploadWindow.hide();
            }
            , scope: this
        }]
    });
}

uploadWindow.addListener("hide", function() {
    basicform.getForm().reset();
    extraform.getForm().reset();
    //bottomform.getForm().reset(); 
});

function uploadFormValue() {
    var innercus = 0; //�ڲ��ͻ�
    if (Ext.get("IsIncust").dom.checked) {
        innercus = 1;
    }
    var supply = 0;                       //��Ӧ��
    if (Ext.get("IsProvide").dom.checked) {
        supply = 1;
    }
    var cus = 0;                          //����
    if (Ext.get("IsCust").dom.checked) {
        cus = 1;
    }
    var extracus = 0;                     //�޵��ο���
    if (Ext.get("IsOrthercust").dom.checked) {
        extracus = 1;
        cus = 1;//default
    }
    var kp = 0;                       //�Ƿ�Ʊ
    if (Ext.get("IsMakeinvoice").dom.checked) {
        kp = 1;
    }
    if(innercus+supply+cus+extracus<1){
        Ext.Msg.alert("��ʾ", "��ѡ��ͻ����ͣ�");
        return;
    }

    if (saveType == 'add')
        saveType = 'addCustomer';
    else if (saveType == 'edit')
        saveType = 'saveCustomer';

    var BankDate = Ext.getCmp('BankDate').getValue();
    if (BankDate == null || BankDate == "") {
        //alert("�����뿪��ʱ�䣡");
        //return;
        BankDate = new Date("1901-01-01 00:00:01");
    }
    var AwarDdate = Ext.getCmp('AwarDdate').getValue();
    if (AwarDdate == null || AwarDdate == "") {
        //alert("�����뷢֤���ڣ�");
        //return;
        AwarDdate = new Date("1901-01-01 00:00:01");
    }
    var EodrDate = Ext.getCmp('EodrDate').getValue();
    if (EodrDate == null || EodrDate == "") {
        //alert("�����뽨��ʱ�䣡");
        //return;
        EodrDate = new Date("1901-01-01 00:00:01");
    }
    
    Ext.MessageBox.wait("�������ڱ��棬���Ժ󡭡�");
    Ext.Ajax.request({
        url: 'customerManage.aspx?method=' + saveType + owner,
        method: 'POST',
        params: {
            CustomerId: Ext.getCmp('CustomerId').getValue(), //ID
            CustomerNo: Ext.getCmp('CustomerNo').getValue(), //���
            ChineseName: Ext.getCmp('ChineseName').getValue(), //��������
            MnemonicNo: Ext.getCmp('MnemonicNo').getValue(), //������
            EnglishName: Ext.getCmp('EnglishName').getValue(), //Ӣ������
            ShortName: Ext.getCmp('ShortName').getValue(), //���
            Address: Ext.getCmp('Address').getValue(), //��ַ
            LinkMan: Ext.getCmp('LinkMan').getValue(), //��ϵ��
            LinkTel: Ext.getCmp('LinkTel').getValue(), //��ϵ�绰
            LinkMobile: Ext.getCmp('LinkMobile').getValue(), //�ƶ��绰
            Zipcode: Ext.getCmp('Zipcode').getValue(), //�ʱ�
            Fax: Ext.getCmp('Fax').getValue(), //����
            Email: Ext.getCmp('Email').getValue(), //����
            DeliverDate: Ext.getCmp('DeliverDate').getValue(), //�ͻ�ʱ��
            DeliverAdd: Ext.getCmp('DeliverAdd').getValue(), //�ͻ���ַ
            DistributionType: Ext.getCmp('DistributionType').getValue(), //��������
            DeliverCorp: Ext.getCmp('DeliverCorp').getValue(), //�ͻ���˾
            MonthQuantity: Ext.getCmp('MonthQuantity').getValue(), //������
            CorpKind: Ext.getCmp('CorpKind').getValue(), //��˾����
            CustKind: Ext.getCmp('CustKind').getValue(), //��ҵ����
            EodrDate: Ext.util.Format.date(EodrDate,'Y/m/d'), //����ʱ��
            Province: Ext.getCmp('Province').getValue(), //����ʡ
            City: Ext.getCmp('City').getValue(), //������
            Town: Ext.getCmp('Town').getValue(), //��������
            IsIncust: innercus,                          //�ڲ��ͻ�
            IsProvide: supply,                       //��Ӧ��
            IsCust: cus,                          //����
            IsOrthercust: extracus,                     //��������
            State: Ext.getCmp('State').getValue(), //�ͻ�״̬
            //OwenId:Ext.getCmp('OwenId').getValue(),//ҵ��Ա
            //OwenOrg:Ext.getCmp('OwenOrg').getValue(),//��֯
            CreditSum: Ext.getCmp('CreditSum').getValue(), //���ö��
            SettlementWay: Ext.getCmp('SettlementWay').getValue(), //���㷽ʽ
            IsMakeinvoice: kp,                    //�Ƿ�Ʊ
            AwarDdate: Ext.util.Format.date(AwarDdate,'Y/m/d'), //��֤����
            TradeType: Ext.getCmp('TradeType').getValue(), //��ҵ
            SettlementParty: Ext.getCmp('SettlementParty').getValue(), //���㷽
            ClearingOrg: Ext.getCmp('ClearingOrg').getValue(), //������֯
            SettlementType: Ext.getCmp('SettlementType').getValue(), //��������
            SettlementCurrency: Ext.getCmp('SettlementCurrency').getValue(), //�������
            Principal: Ext.getCmp('Principal').getValue(), //������
            PrincipalTel: Ext.getCmp('PrincipalTel').getValue(), //�����˵绰
            BankAccount: Ext.getCmp('BankAccount').getValue(), //�����˻�
            BankId: Ext.getCmp('BankId').getValue(), //��������
            BankDate: Ext.util.Format.date(BankDate,'Y/m/d'), //����ʱ��
            LicenseNo: Ext.getCmp('LicenseNo').getValue(), //���֤��
            BusinessNo: Ext.getCmp('BusinessNo').getValue(), //���̱��
            TaxNo: Ext.getCmp('TaxNo').getValue(), //˰��
            Remark: Ext.getCmp('Remark').getValue(), //��ע
            IsShare: Ext.getCmp('IsShare').getValue(), //�Ƿ���
            InvoiceType: Ext.getCmp('InvoiceType').getValue(),//��Ʊ����
            RouteId:Ext.getCmp('RouteId').getValue(),//��·���
            
            BankName:Ext.getCmp('BankName').getValue(),//
            BalanceBankName:Ext.getCmp('BalanceBankName').getValue(),//
            BlanaceBankAccount:Ext.getCmp('BlanaceBankAccount').getValue(),//
            CustomizeInfo:Ext.getCmp('CustomizeInfo').getValue()//
            /*
            OrgId:Ext.getCmp('OrgId').getValue() //������֯
            */
        },
        success: function(resp, opts) {
            Ext.MessageBox.hide();
            if (checkExtMessage(resp)) {
                uploadWindow.hide();
                customerListStore.reload();
            }
        }
         , failure: function(resp, opts) {
             Ext.MessageBox.hide();
             Ext.Msg.alert("��ʾ", "����ʧ��");

         }
    });
}
//
var addressgrid ;
var dsAddress = new Ext.data.Store({
    url: 'customerManage.aspx?method=getCustomerAdd',
    reader: new Ext.data.JsonReader({
        root: 'root',
        totalProperty: 'totalProperty'
    }, [
        { name: 'AttributeId' ,mapping:'AttributeId' },
        { name: 'AttributeValue', mapping: 'AttributeValue' }
    ])
});
var RowPattern = Ext.data.Record.create([
	{ AttributeId:-1},
	{ AttributeValue: ''}]);
function inserNewBlankRow() {
    var rowCount = addressgrid.getStore().getCount();
    var insertPos = parseInt(rowCount);
    var addRow = new RowPattern({
        AttributeId:-1,
        AttributeValue: ''
    });
    addressgrid.stopEditing();
    //����һ����
    if (insertPos > 0) {
        var rowIndex = dsAddress.insert(insertPos, addRow);
        addressgrid.startEditing(insertPos, 0);
    }
    else {
        var rowIndex = dsAddress.insert(0, addRow);
        addressgrid.startEditing(0, 0);
    }
}
function addNewBlankRow(combo, record, index) {
    var rowIndex = addressgrid.getStore().indexOf(addressgrid.getSelectionModel().getSelected());
    var rowCount = addressgrid.getStore().getCount();    
        inserNewBlankRow();
}
function manageAddContent(){
    if (typeof (addWindow) == "undefined") {//�������2��windows����
        var smadd = new Ext.grid.CheckboxSelectionModel({
                        singleSelect: false
                    });
        addressgrid = new Ext.grid.EditorGridPanel({ 
                    el:'address',
                    width: '100%',
                    height: '100%',
                    autoScroll: true,
                    bodyStyle: 'padding:5px',
                    layout: 'fit',
                    id: '',
                    clicksToEdit: 1,
                    store: dsAddress,
                    loadMask: { msg: '���ڼ������ݣ����Ժ��' },
                    sm: smadd,
                    cm: new Ext.grid.ColumnModel([
                    smadd,
                    new Ext.grid.RowNumberer(),//�Զ��к�
                    {
                        id: 'AttributeId',
                        header: "ID",
                        dataIndex: 'AttributeId',
                        width: 30,
                        hidden: true
                    },
                    {
                        header:'�ͻ��ͻ���ַ�б�',
                        dataIndex:'AttributeValue',
                        id:'AttributeValue',
                        width:180,
		                editor: new Ext.form.TextField({
		                    
		                })
                    }		]),
                    viewConfig: {
                        columnsText: '��ʾ����',
                        scrollOffset: 20,
                        sortAscText: '����',
                        sortDescText: '����',
                        forceFit: true
                    },
                    height: 120,
                    closeAction: 'hide',
                    stripeRows: true,
                    loadMask: true
                });
        addWindow = new Ext.Window({
            id:'addWindow',
            title: "�ͻ���ַά��"
            , iconCls: 'upload-win'
            , width: 400
            , height: 220
            , layout: 'fit'
            , plain: true
            , modal: true
            , constrain: true
            , resizable: false
            , closeAction: 'hide'
            , autoDestroy: true
           , items: [
                  addressgrid
             ]
             , buttons: [{
                text: "����", 
                handler: function() {
                    addNewBlankRow();
                }, scope: this
             },
             {
                text: "����", 
                handler: function() {
                    var json = "";
                    dsAddress.each(function(rec) {
                        if(rec.data.Address!='')
                            json += Ext.util.JSON.encode(rec.data) + ',';
                    });
                    //json = json.substring(0, json.length - 1);
                                        
                    Ext.Ajax.request({
                    url: 'customerManage.aspx?method=saveCustomerAdd',
                    method: 'POST',
                    params: {
                        //������
                        AttributeType:'Address',
                        CustomerId:Ext.getCmp('CustomerId').getValue(),
                        DetailInfo:json
                        },
                    success: function(resp,opts){ 
                        if( checkExtMessage(resp) )
                             {
                               dsAddress.reload({callback:inserNewBlankRow()});
                             }
                       },
		            failure: function(resp,opts){  
		                Ext.Msg.alert("��ʾ","ȡ��ʧ��");     
		            } 
		            });              

                }, scope: this
             },
             {
                text: "ѡ��", 
                handler: function() {
                    var sm = addressgrid.getSelectionModel();
                    var selectData = sm.getSelected();
                    if (selectData == null) {
                        Ext.Msg.alert("��ʾ", "��ѡ��һ�У�");
                        return;
                    }
                    if(selectData.data.AttributeId==-1){
                        Ext.Msg.alert("��ʾ", "���ȱ��������ĵ�ַ��Ϣ��");
                        return;
                    }
                    Ext.getCmp('DeliverAdd').setValue(selectData.data.AttributeValue);
                    addWindow.hide();
                }, scope: this
             }]
        });
        addWindow.addListener("hide", function() {
            dsAddress.removeAll();
        });
    }
    addWindow.show();    
    //doit
    dsAddress.baseParams.customerid=Ext.getCmp('CustomerId').getValue();
    dsAddress.baseParams.Address='Address';
    dsAddress.load({callback:inserNewBlankRow()});  
}
var recrod = new Ext.data.Record({DicsCode:'',DicsName:'��'});
dsBalanceBank.insert(0,recrod);  
//end onready
});   
function getCmbStore(columnName)
{
    switch(columnName)
    {
        case'DistributionTypeText':
            return null;
        case "IsProvide":
            var dsIsSupplier = new Ext.data.SimpleStore({ 
                fields:['IsProvide','IsProvideText'],
                data:[['','ȫ��'],['0','��'],['1','��']],
                autoLoad: false});
            return dsIsSupplier; 
        case "IsCust":
            var dsIsCust = new Ext.data.SimpleStore({ 
                fields:['IsCust','IsCustText'],
                data:[['','ȫ��'],['0','��'],['1','��']],
                autoLoad: false});
            return dsIsCust; 
        case "IsOrthercust":
            var dsIsOrthercust = new Ext.data.SimpleStore({ 
                fields:['IsOrthercust','IsOrthercustText'],
                data:[['','ȫ��'],['0','��'],['1','��']],
                autoLoad: false});
            return dsIsOrthercust; 
        default:
            return null;
    }
}                   
</script>
</html>