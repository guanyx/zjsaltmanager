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
/* 全局变量，控制无权限控制的变量只加载第一次 start */
var custTypeComBoxStore ;
var version =parseFloat(navigator.appVersion.split("MSIE")[1]);
if(version == 6)
    version = 2.06;
else //!ie6 contain double size
    version = 3.1;
/* 全局变量，控制无权限控制的变量只加载第一次 end */

Ext.onReady(function() {
/*------定义toolbar start---------------*/
var Toolbar = new Ext.Toolbar({
    renderTo: "toolbar",
    items: [{
        text: "新增",
        icon: '../../Theme/1/images/extjs/customer/add16.gif',
        //iconCls: 'blist',
        //cls: 'x-btn-text-icon', //class样式
        //ctCls: '', //客户自定义class样式
        //Anchor Layout要点:"1.容器内的组件要么指定宽度，要么在anchor中同时指定高/宽，2.anchor值通常只能为负值(指非百分比值)，正值没有意义，3.anchor必须为字符串值"
        //height: 100,anchor: '-50',高度等于100，宽度=容器宽度-50
        //height: 100,anchor: '50%',高度等于100,宽度=容器宽度的50%
        //anchor: '-10, -250',宽度=容器宽度-10,高度=容器宽度-250
        handler: function() {
            saveType = "add";
            openAddCustomerWin(); //点击后，弹出添加信息窗口
        }
    }, '-', {
        text: "删除",
        icon: '../../Theme/1/images/extjs/customer/delete16.gif',
        handler: function() {
            deleteCustomer();
        }
    }, '-', {
        text: "编辑",
        icon: '../../Theme/1/images/extjs/customer/edit16.gif',
        handler: function() {
            saveType = "edit";
            modifyCustomerWin(); //点击后弹出原有信息
        }
    }, '-', {
        text: "禁用",
        icon: '../../Theme/1/images/extjs/customer/forbidden16.gif',
        handler: function() {
            forbiddenCustomer();
        }
    }, '-', {
        text: "商品特殊价格",
        icon: '../../Theme/1/images/extjs/customer/s_add.gif',
        handler: function() {
            especialProductPrice();
        }
    }, '-', {
        text: "可订购商品",
        icon: '../../Theme/1/images/extjs/customer/s_add.gif',
       // hidden:true,
        handler: function() {
            var sm = CustomerGrid.getSelectionModel();
            var selectData = sm.getSelected();
            if (selectData == null) {
                Ext.Msg.alert("提示", "请选中一行！");
                return;
            }
            if(selectData.data.IsCust==0)
            {
                Ext.Msg.alert("提示","选择的当前客户不是客商，不用设置订购商品！");
                return;
            }
            especialProductClass();
        }
    }, '-', {
        text: "创建客户用户",
        icon: '../../Theme/1/images/extjs/customer/s_add.gif',
        handler: function() {
            var sm = CustomerGrid.getSelectionModel();
            var selectData = sm.getSelected();
            if (selectData == null) {
                Ext.Msg.alert("提示", "请选中一行！");
                return;
            }
            modifyUserWin(selectData.data.CustomerId, selectData.data.ShortName);
        }
    },'-', {
        text: "设置供应商商品",
        icon: '../../Theme/1/images/extjs/customer/s_add.gif',
        handler: function() {
            var sm = CustomerGrid.getSelectionModel();
            var selectData = sm.getSelected();
            if (selectData == null) {
                Ext.Msg.alert("提示", "请选中一行！");
                return;
            }
            if(selectData.data.IsProvide==0)
            {
                Ext.Msg.alert("提示","选择的当前客户不是供应商，不能设置供应商品！");
                return;
            }
            suppliersProducts();
        }
    },'-',{
        xtype: 'splitbutton',
        text:'附加信息',
        icon: '../../Theme/1/images/extjs/customer/s_add.gif',
        menu:createMenu()
    },'-',{
        xtype: 'splitbutton',
        text:'导出',
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
           text: '客户基本信息',
           handler: customerAdd
        },
        {
            text:'短信订单密码',
            handler:setSmsPassWord
        },
	{
           text: '盐类销售情况',
           handler: customerSaltAdd
        },{
           text: '非盐销售情况',
           handler: customerOtherAdd
        },{
           text: '盐场信息',
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
           text: '当前结果',
           handler: function(){
            exportExcel(false);
           }
        },
	{
           text: '全部结果',
           handler: function(){
            exportExcel(true);
           }
        }]});
	return menu;
}
/*------实现toolbar的按钮函数 start---------------*/
//导出
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
                 Ext.Msg.alert('提示消息', '请选择需要设置的客户信息，可以多个客户同时处理');
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
        smsPasswordWin = ExtJsShowWin('客户短信订单密码','../../Common/frmCommonListUpdate.aspx?formType=sms&CustomerIds='+customerIds,'smsbase',600,450);
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
                 Ext.Msg.alert('提示消息', '请选择需要设置的客户信息，可以多个客户同时处理');
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
        saltWorksAddWin = ExtJsShowWin('盐场基本信息','../../Common/frmCommonListUpdate.aspx?formType=saltworks&CustomerIds='+customerIds,'saltworksbase',600,450);
        saltWorksAddWin.show();
    }
    else
    {
        saltWorksAddWin.show();
        document.getElementById("iframesaltworksbase").contentWindow.loadData(customerIds);
    } 
}
//客户附加信息
var customerAddWin = null;
function customerAdd()
{
    var record=CustomerGrid.getSelectionModel().getSelections();
                if(record == null || record.length == 0)
                {
                 Ext.Msg.alert('提示消息', '请选择需要设置的客户信息，可以多个客户同时处理');
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
        customerAddWin = ExtJsShowWin('客户基本信息','../../Common/frmCommonListUpdate.aspx?formType=customer&CustomerIds='+customerIds,'customerbase',600,450);
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
                 Ext.Msg.alert('提示消息', '请选择需要设置的客户信息，可以多个客户同时处理');
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
        customerSaltAddWin = ExtJsShowWin('客户盐类销售情况','../../Common/frmCommonListUpdate.aspx?formType=customersalt&CustomerIds='+customerIds,'customersalt',600,450);
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
        Ext.Msg.alert('提示消息', '请选择需要设置的客户信息，只能同时处理1个客户信息');
                    return null;
    }
    customerIds = selectData.data.CustomerId;
    if(customerOtherAddWin==null)
    {
        customerOtherAddWin = ExtJsShowWin('客户非盐类销售情况','../../Common/frmCommonListUpdate.aspx?formType=customerother&CustomerIds='+customerIds,'customerother',600,450);
        customerOtherAddWin.show();
    }
    else
    {
    customerOtherAddWin.show();
    
    document.getElementById("iframecustomerother").contentWindow.loadData(selectData.data.CustomerId);
    }
}

setToolBarVisible(Toolbar);
/*  新增窗口  */
function openAddCustomerWin() {
    uploadWindow.show();
    content.setActiveTab(0);
    Ext.getCmp('RouteName').setDisabled(false);

}
/*  修改窗口  */
function modifyCustomerWin() {
    var sm = CustomerGrid.getSelectionModel();
    var selectData = sm.getSelected();
    if (selectData == null) {
        Ext.Msg.alert("提示", "请选中一行！");
    }
    else {
        //check
        if(selectData.data.OrgId != <% =ZJSIG.UIProcess.ADM.UIAdmUser.OrgID(this)%>){
            Ext.Msg.alert("提示", "该客户由省公司统一维护！");
            return;
        }
        openAddCustomerWin();

        Ext.Ajax.request({
            url: 'customerManage.aspx?method=getCustInfo',
            params: {
                CustomerId: selectData.data['CustomerId']//传入客户seqId
            },
            success: function(resp, opts) {

                var data = Ext.util.JSON.decode(resp.responseText);

                Ext.getCmp('CustomerId').setValue(data.CustomerId); //ID
                Ext.getCmp('CustomerNo').setValue(data.CustomerNo); //编号
                Ext.getCmp('ChineseName').setValue(data.ChineseName); //中文名称                    
                Ext.getCmp('MnemonicNo').setValue(data.MnemonicNo); //助记码
                Ext.getCmp('EnglishName').setValue(data.EnglishName); //英文名称
                Ext.getCmp('ShortName').setValue(data.ShortName); //简称
                Ext.getCmp('Address').setValue(data.Address); //地址
                Ext.getCmp('LinkMan').setValue(data.LinkMan); //联系人
                Ext.getCmp('LinkTel').setValue(data.LinkTel); //联系电话
                Ext.getCmp('LinkMobile').setValue(data.LinkMobile); //移动电话
                Ext.getCmp('Zipcode').setValue(data.Zipcode); //邮编
                Ext.getCmp('Fax').setValue(data.Fax); //传真
                Ext.getCmp('Email').setValue(data.Email); //邮箱
                Ext.getCmp('DeliverDate').setValue(data.DeliverDate); //送货时间
                Ext.getCmp('DeliverAdd').setValue(data.DeliverAdd); //送货地址
                Ext.getCmp('DistributionType').setValue(data.DistributionType); //配送类型
                Ext.getCmp('DeliverCorp').setValue(data.DeliverCorp); //送货公司
                Ext.getCmp('MonthQuantity').setValue(data.MonthQuantity); //月用量
                Ext.getCmp('CorpKind').setValue(data.CorpKind); //公司类型
                Ext.getCmp('CustKind').setValue(data.CustKind); //企业性质
                Ext.getCmp('EodrDate').setValue((new Date(data.EodrDate.replace(/-/g, "/")))); //建交时间
                Ext.getCmp('Province').setValue(data.Province); //所在省
                Ext.getCmp('City').setValue(data.City); //所在市
                Ext.getCmp('Town').setValue(data.Town); //所在乡镇
                if (data.IsIncust == 1 || data.IsIncust == '1') {
                    Ext.get("IsIncust").dom.checked = true; //内部客户
                }
                if (data.IsProvide == 1 || data.IsProvide == '1') {
                    Ext.get("IsProvide").dom.checked = true; //供应商
                }
                if (data.IsCust == 1 || data.IsCust == '1') {
                    Ext.get("IsCust").dom.checked = true; //客商
                }
                if (data.IsOrthercust == 1 || data.IsOrthercust == '1') {
                    Ext.get("IsOrthercust").dom.checked = true; //其他客商
                }
                Ext.getCmp('State').setValue(data.State); //客户状态
                //Ext.getCmp('OwenId').setValue(data.OwenId);//业务员
                //Ext.getCmp('OwenOrg').setValue(data.OwenOrg);//组织
                Ext.getCmp('CreditSum').setValue(data.CreditSum); //信用额度
                Ext.getCmp('SettlementWay').setValue(data.SettlementWay); //结算方式
                if (data.IsMakeinvoice == 1 || data.IsMakeinvoice == '1') {
                    Ext.get("IsMakeinvoice").dom.checked = true; //是否开票
                }
                Ext.getCmp('AwarDdate').setValue((new Date(data.AwarDdate.replace(/-/g, "/")))); //发证日期
                Ext.getCmp('TradeType').setValue(data.TradeType); //行业
                Ext.getCmp('SettlementParty').setValue(data.SettlementParty); //结算方
                Ext.getCmp('ClearingOrg').setValue(data.ClearingOrg); //计算组织
                Ext.getCmp('SettlementType').setValue(data.SettlementType); //结算类型
                Ext.getCmp('SettlementCurrency').setValue(data.SettlementCurrency); //结算币种
                Ext.getCmp('Principal').setValue(data.Principal); //负责人
                Ext.getCmp('PrincipalTel').setValue(data.PrincipalTel); //负责人电话
                Ext.getCmp('BankAccount').setValue(data.BankAccount); //银行账户
                Ext.getCmp('BankId').setValue(data.BankId); //开户银行
                Ext.getCmp('BankDate').setValue((new Date(data.BankDate.replace(/-/g, "/")))); //开户时间
                Ext.getCmp('LicenseNo').setValue(data.LicenseNo); //许可证号
                Ext.getCmp('BusinessNo').setValue(data.BusinessNo); //工商编号
                Ext.getCmp('TaxNo').setValue(data.TaxNo); //税号
                Ext.getCmp('Remark').setValue(data.Remark); //备注
                Ext.getCmp('IsShare').setValue(data.IsShare); //备注
                Ext.getCmp('InvoiceType').setValue(data.InvoiceType); //备注                            

                Ext.getCmp('BankName').setValue(data.BankName);//
                Ext.getCmp('BalanceBankName').setValue(data.BalanceBankName);//
                Ext.getCmp('BlanaceBankAccount').setValue(data.BlanaceBankAccount);//
                
                Ext.getCmp('CustomizeInfo').setValue(data.CustomizeInfo);//
                /*
                Ext.getCmp('OrgId').setValue(data.OrgId); //创建组织
                */
                Ext.getCmp('RouteName').setValue(data.RouteName);
                //Ext.getCmp('RouteName').setDisabled(true);

            },
            failure: function(resp, opts) {
                Ext.Msg.alert("提示", "获取用户信息失败");
            }
        });
    }
}
/*  删除操作  */
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
        Ext.Msg.alert("提示", "请选中一行！");
    }
    else {
        //check
        if(selectData.data.OrgId != <% =ZJSIG.UIProcess.ADM.UIAdmUser.OrgID(this)%>){
            Ext.Msg.alert("提示", "该客户由省公司统一维护！");
            return;
        }
    
        //删除前再次提醒是否真的要删除
        Ext.Msg.confirm("提示信息", "是否真的要删除选择的信息吗？", function callBack(id) {
            //判断是否删除数据
            if (id == "yes") {
                Ext.Ajax.request({
                    url: 'customerManage.aspx?method=delete',
                    params: {
                        CustomerId: selectData.data['CustomerId']//传入客户seqId
                    },
                    success: function(resp, opts) {
                        if(checkExtMessage(resp))
                            CustomerGrid.getStore().remove(selectData);
                    },
                    failure: function(resp, opts) {
                        Ext.Msg.alert("提示", "删除失败！");
                    }
                });
            }
        });
    }
}
/* 禁止操作  */
function forbiddenCustomer() {
    var sm = CustomerGrid.getSelectionModel();
    var selectData = sm.getSelected();
    if (selectData == null || selectData.length == 0 || selectData.length > 1) {
        Ext.Msg.alert("提示", "请选中一行！");
    }
    else {
        //check
        if(selectData.data.OrgId != <% =ZJSIG.UIProcess.ADM.UIAdmUser.OrgID(this)%>){
            Ext.Msg.alert("提示", "该客户由省公司统一维护！");
            return;
        }
        //删除前再次提醒是否真的要删除
        Ext.Msg.confirm("提示信息", "是否真的要禁止选择的信息吗？", function callBack(id) {
            //判断是否删除数据
            if (id == "yes") {
                Ext.Ajax.request({
                    url: 'customerManage.aspx?method=forbidden',
                    params: {
                        CustomerId: selectData.data['CustomerId']//传入客户seqId
                    },
                    success: function(resp, opts) {
                        //var data=Ext.util.JSON.decode(resp.responseText);
                        if(checkExtMessage(resp))
                            CustomerGrid.getStore().remove(selectData);
                    },
                    failure: function(resp, opts) {
                        Ext.Msg.alert("提示", "禁止失败！");
                    }
                });
            }
        });
    }
}

/* 商品特殊价格指定  */
function especialProductPrice() {
    var sm = CustomerGrid.getSelectionModel();
    var selectData = sm.getSelected();
    if (selectData == null || selectData.length == 0 || selectData.length > 1) {
        Ext.Msg.alert("提示", "请选中一行！");
    }
    else {
        uploadespecialProductWindow.show();
        uploadespecialProductWindow.setTitle("商品特殊价格设置"); //alert(selectData.data.DrawInvId);
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

/* 客户可订购类别指定  */
function especialProductClass() {
    var sm = CustomerGrid.getSelectionModel();
    var selectData = sm.getSelected();
    if (selectData == null || selectData.length == 0 || selectData.length > 1) {
        Ext.Msg.alert("提示", "请选中一行！");
    }
    else {
        uploadespecialClassWindow.show();
        uploadespecialClassWindow.setTitle("客户可订购类别设置"); //alert(selectData.data.DrawInvId);
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
            
/* 供应商供应商品信息  */
function suppliersProducts() {
    var sm = CustomerGrid.getSelectionModel();
    var selectData = sm.getSelected();
    if (selectData == null || selectData.length == 0 || selectData.length > 1) {
        Ext.Msg.alert("提示", "请选中需要设置的供应商信息一行！");
    }
    else {
        //check
        if(selectData.data.OrgId != <% =ZJSIG.UIProcess.ADM.UIAdmUser.OrgID(this)%>){
            Ext.Msg.alert("提示", "该客户由省公司统一维护！");
            return;
        }
        suppliersProductWindow.show();
        suppliersProductWindow.setTitle("供应商供应商品设置"); //alert(selectData.data.DrawInvId);
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

/*------开始界面数据的窗体 Start---------------*/
if (typeof (suppliersProductWindow) == "undefined") {//解决创建2个windows问题
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
/*------实现toolbar的按钮函数 end---------------*/
/*------定义toolbar end---------------*/

/*------开始界面数据的窗体 Start---------------*/
if (typeof (uploadespecialProductWindow) == "undefined") {//解决创建2个windows问题
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

/*-----------线路信息过滤-----------------------/

/*------开始界面数据的窗体 Start---------------*/
if (typeof (uploadespecialClassWindow) == "undefined") {//解决创建2个windows问题
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

/*------定义客户配送类型下拉框 start--------*/
var combo = new Ext.form.ComboBox({

    fieldLabel: '配送类型',
    name: 'folderMoveTo',
    store: dsDistributionType,
    displayField: 'DicsName',
    valueField: 'DicsCode',
    mode: 'local',
    editable: false,
    //loadText:'loading ...',
    typeAhead: true, //自动将第一个搜索到的选项补全输入
    triggerAction: 'all',
    selectOnFocus: true,
    forceSelection: true,
    width: 100

});

/* ----------------定义datagrid列表json格式 ----------*/
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
          //数据加载预处理,可以做一些合并、格式处理等操作
      }
    }
});

customerListStore.baseParams.IsCustManager = custManager;
			  
var sortInfor = "";
			
var defaultPageSize = 10;
var toolBar = new Ext.PagingToolbar({
    pageSize: 10,
    store: customerListStore,
    displayMsg: '显示第{0}条到{1}条记录,共{2}条',
    emptyMsy: '没有记录',
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
    emptyText: '更改每页记录数',
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
    loadMask: { msg: '正在加载数据，请稍侯……' },
    sm: sm,
    /*  如果中间没有查询条件form那么可以直接用tbar来实现增删改
    tbar:[{
    text:"添加",
    handler:this.showAdd,
    scope:this
    },"-",
    {
    text:"修改"
    },"-",{
    text:"删除",
    handler:this.deleteBranch,
    scope:this
    }],
    */
    cm: new Ext.grid.ColumnModel([
        sm,
         new Ext.grid.RowNumberer(), //自动行号
        {header: "客户ID", dataIndex: 'CustomerId', hidden: true, hideable: false },
        { header: "客户编号", width: 70, sortable: true, dataIndex: 'CustomerNo' },
        { header: "客户简称", width: 130, sortable: true, dataIndex: 'ShortName' },
        { header: "客户全称", width: 180, sortable: true, dataIndex: 'ChineseName' },
        { header: "联系人", width: 60, sortable: true, dataIndex: 'LinkMan' },
        { header: "联系电话", width: 90, sortable: true, dataIndex: 'LinkTel' },
        { header: "移动电话", width: 90, sortable: true, dataIndex: 'LinkMobile' },
        //{ header: "传真", width: 30, sortable: true, dataIndex: 'Fax', hidden: true, hideable: false },
        { header: "配送类型", width: 60, sortable: true, dataIndex: 'DistributionTypeText' },
        //{ header: "月用量", width: 20, sortable: true, dataIndex: 'MonthQuantity' },
        { header: "客商", width: 45, sortable: true, dataIndex: 'IsCust', renderer: { fn: function(v) { if (v == 1) return '是'; return '否'; } } },
        { header: "供应商", width: 55, sortable: true, dataIndex: 'IsProvide', renderer: { fn: function(v) { if (v == 1) return '是'; return '否'; } } },
        { header: "无碘盐客商", width: 80, sortable: true, dataIndex: 'IsOrthercust', renderer: { fn: function(v) { if (v == 1) return '是'; return '否'; } } },
        { header: "创建时间", width: 120, sortable: true, dataIndex: 'CreateDate', renderer: Ext.util.Format.dateRenderer('Y年m月d日')}//renderer: Ext.util.Format.dateRenderer('m/d/Y'),
    ]), listeners:
    {
        afterrender: function(component) {
	          //component.getBottomToolbar().refresh.hideParent = true;
	          //component.getBottomToolbar().refresh.hide();
        }
    },
    bbar:toolBar,
    viewConfig: {
        columnsText: '显示的列',
        scrollOffset: 20,
        sortAscText: '升序',
        sortDescText: '降序',
        forceFit: false
    }, 
    height: 350,
    closeAction: 'hide',
    stripeRows: true,
    loadMask: true//,
    //autoExpandColumn: 2
});

toolBar.addField(createPrintButton(customerListStore, CustomerGrid, ''));
printTitle = "客户信息";
            
/**************创建机构选择信息***********************************/
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

        //允许单选
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
/***********************机构选择信息结束*****************************************/
createSearch(CustomerGrid, customerListStore, "searchForm");
searchForm.el = "searchForm";
searchForm.render();

if(orgId==1)
{
var addRow = new fieldRowPattern({
            id: 'OrgId',
            name: '所属单位',
            dataType: 'select'
        });
        fieldStore.add(addRow);
        }
 else
 {
    var addRow = new fieldRowPattern({
        id: 'RouteId',
        name: '线路信息',
        dataType: 'select'});
        fieldStore.add(addRow);
    addRow = new fieldRowPattern({
        id: 'RouteNo',
        name: '线路编号',
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
    fieldLabel: '客户编号',
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
    fieldLabel: '客户名称',
    name: 'nameCust',
    anchor: '90%'
});

//定义下拉框异步调用方法
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
// 定义下拉框异步返回显示模板
var resultTpl = new Ext.XTemplate(
    '<tpl for="."><div id="searchdivid" class="search-item">',
    '<h3><span>客户编号：{CustomerNo}<br />客户名称： {ShortName}</span>配送类型：{DistributionType}</h3>',
    //'<br>创建时间：{createDate}',  
    '</div></tpl>'
);

var basicform = new Ext.FormPanel({
    id: 'basicform',
    title: '基本信息',
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
        layout: 'column',   //定义该元素为布局为列布局方式
        border: false,
        items:
        [{//第一行开始
            columnWidth: .33,  //该列占用的宽度，标识为50％
            layout: 'form',
            border: false,
            items: 
            [{
                cls: 'key',
                xtype: 'textfield',
                fieldLabel: '客户id',
                name: 'CustomerId',
                id: 'CustomerId',
                anchor: '90%',
                vtype: 'alphanum', //只能输入字母和数字，无法输入其他
                vtypeText: '只能输入字母和数字',
                hidden: true,
                hideLabel: true
                // allowBlank : true
            },
            {
                cls: 'key',
                xtype: 'textfield',
                fieldLabel: '<b>编号*</b>',
                name: 'CustomerNo',
                id: 'CustomerNo',
                anchor: '90%'//,
                //vtype: 'alphanum', //只能输入字母和数字，无法输入其他
                //vtypeText: '只能输入字母和数字'
                // maxLength: 1000,  
                // allowBlank : true
            }]
        }, //第一行第一列
        {
            columnWidth: .67,  //该列占用的宽度，标识为50％
            layout: 'form',
            border: false,
            items: [{
              cls: 'key',
              xtype: 'textfield',
              fieldLabel: '<font color=red><b>中文名称*</b></font>',
              name: 'ChineseName',
              id: 'ChineseName',
              anchor: '90%'
              // maxLength: 1000,  
                // allowBlank : true
            }]//第一行第二列
        }]
    },
    {//第二行开始
        layout: 'column',   //定义该元素为布局为列布局方式
        border: false,
        items: [{
            columnWidth: .33,  //该列占用的宽度，标识为50％
            layout: 'form',
            border: false,
            items: [{//第二行第一列
                cls: 'key',
                xtype: 'textfield',
                fieldLabel: '助记码',
                name: 'MnemonicNo',
                id: 'MnemonicNo',
                anchor: '90%'
                // maxLength: 1000,  
                // allowBlank : true
            }]
        },
        {//第二行第二列
            columnWidth: .67,  //该列占用的宽度，标识为50％
            layout: 'form',
            border: false,
            items: [{
                cls: 'key',
                xtype: 'textfield',
                fieldLabel: '英文名称',
                name: 'EnglishName',
                id: 'EnglishName',
                anchor: '90%'
                // maxLength: 1000,  
                // allowBlank : true
            }]
        }]
    },
    {//第三行开始
        layout: 'column',   //定义该元素为布局为列布局方式
        border: false,
        items: [{//第三行第一列
            columnWidth: .33,  //该列占用的宽度，标识为50％
            layout: 'form',
            border: false,
            items: [{

                cls: 'key',
                xtype: 'textfield',
                fieldLabel: '<b>简称*</b>',
                name: 'ShortName',
                id: 'ShortName',
                anchor: '90%'
                // maxLength: 1000,  
                // allowBlank : true

            }]
        },
        {//第三行第二列
            columnWidth: .67,  //该列占用的宽度，标识为50％
            layout: 'form',
            border: false,
            items: [{

                cls: 'key',
                xtype: 'textfield',
                fieldLabel: '<b>地址*</b>',
                name: 'Address',
                id: 'Address',
                anchor: '90%'
                // maxLength: 1000,  
                // allowBlank : true

            }]
        }]
    },
    {//第四行开始
        layout: 'column',   //定义该元素为布局为列布局方式
        border: false,
        items: [{//第四行第一列
            columnWidth: .33,  //该列占用的宽度，标识为50％
            layout: 'form',
            border: false,
            items: [{

                cls: 'key',
                xtype: 'textfield',
                fieldLabel: '<b>联系人*</b>',
                name: 'LinkMan',
                id: 'LinkMan',
                anchor: '90%'
                // maxLength: 1000,  
                // allowBlank : true

                }]
            },
            {//第四行第二列
                columnWidth: .318,  //该列占用的宽度，标识为50％
                layout: 'form',
                border: false,
                items: [{

                    cls: 'key',
                    xtype: 'textfield',
                    fieldLabel: '联系电话',
                    name: 'LinkTel',
                    id: 'LinkTel',
                    anchor: '90%'
                    // maxLength: 1000,  
                    // allowBlank : true

                }]
            },
            {//第四行第三列
                columnWidth: .317,  //该列占用的宽度，标识为50％
                layout: 'form',
                border: false,
                items: [{

                    cls: 'key',
                    xtype: 'textfield',
                    fieldLabel: '移动电话',
                    name: 'LinkMobile',
                    id: 'LinkMobile',
                    anchor: '90%'
                    // maxLength: 1000,  
                    // allowBlank : true

                }]
            }]
        },
        {//第五行开始
            layout: 'column',   //定义该元素为布局为列布局方式
            border: false,
            items: [{//第五行第一列
                columnWidth: .33,  //该列占用的宽度，标识为50％
                layout: 'form',
                border: false,
                items: [{

                    cls: 'key',
                    xtype: 'textfield',
                    fieldLabel: '邮编',
                    name: 'Zipcode',
                    id: 'Zipcode',
                    anchor: '90%'
                    // maxLength: 1000,  
                    // allowBlank : true

                }]
            },
            {//第五行第二列
                columnWidth: .318,  //该列占用的宽度，标识为50％
                layout: 'form',
                border: false,
                items: [{

                    cls: 'key',
                    xtype: 'textfield',
                    fieldLabel: '传真',
                    name: 'Fax',
                    id: 'Fax',
                    anchor: '90%'
                    // maxLength: 1000,  
                    // allowBlank : true

                }]
            },
            {//第五行第三列
                columnWidth: .317,  //该列占用的宽度，标识为50％
                layout: 'form',
                border: false,
                items: [{

                    cls: 'key',
                    xtype: 'textfield',
                    fieldLabel: '电子邮箱',
                    name: 'Email',
                    id: 'Email',
                    anchor: '90%',
                    vtype: 'email', //email验证，要求的格式是"langsin@gmail.com"
                    vtypeText: '不是有效的邮箱地址,格式为:username@domain.com'//错误提示信息,
                    // maxLength: 1000,  
                    // allowBlank : true

                }]
            }]
        },
        {//第六行
            layout: 'column',   //定义该元素为布局为列布局方式
            border: false,
            items: [{//第六行第一列
                columnWidth: .33,  //该列占用的宽度，标识为50％
                layout: 'form',
                border: false,
                items: [{

                    cls: 'key',
                    xtype: 'textfield',
                    fieldLabel: '送货时间',
                    name: 'DeliverDate',
                    id: 'DeliverDate',
                    anchor: '90%'
                    //editable: false
                    // maxLength: 1000,  
                    // allowBlank : true

                }]
            },
            {//第六行第二列
                columnWidth: .67,  //该列占用的宽度，标识为50％
                layout: 'form',
                border: false,
                items: [{
                    layout:'column',
                    border: false,
                    labelSeparator: '：',
                    items: [{
                        layout:'form',
	                    border: false,
	                    columnWidth:0.275*version,
	                    items: [
	                    {
                            cls: 'key',
                            xtype: 'textfield',
                            fieldLabel: '送货地址',
                            name: 'DeliverAdd',
                            id: 'DeliverAdd',
                            anchor: '100%'
                            // maxLength: 1000,  
                            // allowBlank : true
                        }]
                    },{
                       layout: 'form',
                       columnWidth: .035*version,  //该列占用的宽度，标识为20％
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
        {//第七行
            layout: 'column',   //定义该元素为布局为列布局方式
            border: false,
            items: [{//第七行第一列
                columnWidth: .33,  //该列占用的宽度，标识为50％
                layout: 'form',
                border: false,
                items: [{
                    cls: 'key',
                    xtype: 'combo',
                    fieldLabel: '配送类型',
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
            {//第七行第二列
                columnWidth: .67,  //该列占用的宽度，标识为50％
                layout: 'form',
                border: false,
                items: [{

                    cls: 'key',
                    xtype: 'textfield',
                    fieldLabel: '送货单位',
                    name: 'DeliverCorp',
                    id: 'DeliverCorp',
                    anchor: '90%'
                    // maxLength: 1000,  
                    // allowBlank : true

                }]
            }]
        },
        {//第八行
            layout: 'column',   //定义该元素为布局为列布局方式
            border: false,
            items: [{//第八行第一列
                columnWidth: .33,  //该列占用的宽度，标识为50％
                layout: 'form',
                border: false,
                items: [{

                    cls: 'key',
                    xtype: 'textfield',
                    fieldLabel: '月用量',
                    name: 'MonthQuantity',
                    id: 'MonthQuantity',
                    anchor: '90%'
                    // maxLength: 1000,  
                    // allowBlank : true

                }]
            },
            {//第八行第二列
                columnWidth: .318,  //该列占用的宽度，标识为50％
                layout: 'form',
                border: false,
                items: [{

                    cls: 'key',
                    xtype: 'combo',
                    fieldLabel: '企业性质',
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
            {//第八行第三列
                columnWidth: .317,  //该列占用的宽度，标识为50％
                layout: 'form',
                border: false,
                items: [{

                    cls: 'key',
                    xtype: 'datefield',
                    fieldLabel: '建交时间',
                    name: 'EodrDate',
                    id: 'EodrDate',
                    anchor: '90%',
                    format: 'Y年m月d日'
                    //editable: false
                    // maxLength: 1000,  
                    // allowBlank : true

                }]
            }]
        },
        {//第九行
            layout: 'column',   //定义该元素为布局为列布局方式
            border: false,
            items: [{//第九行第一列
                columnWidth: .33,  //该列占用的宽度，标识为50％
                layout: 'form',
                border: false,
                items: [{
                    cls: 'key',
                    xtype: 'combo',
                    fieldLabel: '所在省',
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
            {//第九行第二列
                columnWidth: .318,  //该列占用的宽度，标识为50％
                layout: 'form',
                border: false,
                items: [{
                    cls: 'key',
                    xtype: 'combo',
                    fieldLabel: '所在市',
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
            {//第九行第三列
                columnWidth: .317,  //该列占用的宽度，标识为50％
                layout: 'form',
                border: false,
                items: [{
                    cls: 'key',
                    xtype: 'combo',
                    fieldLabel: '所在乡镇',
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
        {//第十行
            layout: 'column',   //定义该元素为布局为列布局方式
            border: false,
            items: [{//第十行第一列
                style: 'align:left',
                columnWidth: .25,  //该列占用的宽度，标识为50％
                layout: 'form',
                border: false,
                items: [{
                    cls: 'key',
                    xtype: 'checkbox',
                    boxLabel: '内部客户',
                    name: 'IsIncust',
                    id: 'IsIncust',
                    anchor: '90%',
                    hideLabel: true
                    // maxLength: 1000,  
                    // allowBlank : true

            }]
            },
            {   //第十行第二列
                style: 'align:left',
                columnWidth: .25,  //该列占用的宽度，标识为50％
                layout: 'form',
                border: false,
                items: [{

                    cls: 'key',
                    xtype: 'checkbox',
                    value: 'gys',
                    boxLabel: '供应商',
                    name: 'IsProvide',
                    id: 'IsProvide',
                    anchor: '90%',
                    hideLabel: true
                    // maxLength: 1000,  
                    // allowBlank : true

                }]
            },
            {   //第十行第三列
                style: 'align:left',
                columnWidth: .25,  //该列占用的宽度，标识为50％
                layout: 'form',
                border: false,
                items: [{

                    cls: 'key',
                    xtype: 'checkbox',
                    boxLabel: '客商',
                    name: 'IsCust',
                    id: 'IsCust',
                    anchor: '90%',
                    hideLabel: true
                    // maxLength: 1000,  
                    // allowBlank : true

                }]
            },
            {   //第十行第四列
                style: 'align:left',
                columnWidth: .25,  //该列占用的宽度，标识为50％
                layout: 'form',
                border: false,
                items: [{

                    cls: 'key',
                    xtype: 'checkbox',
                    boxLabel: '无碘盐客商',
                    name: 'IsOrthercust',
                    id: 'IsOrthercust',
                    anchor: '90%',
                    hideLabel: true
                    // maxLength: 1000,  
                    // allowBlank : true

                }]
            }]
        },
        {//第十一行
            layout: 'column',   //定义该元素为布局为列布局方式
            border: false,
            items: [{//第十一行第一列
                columnWidth: .318,  //该列占用的宽度，标识为50％
                layout: 'form',
                border: false,
                items: [{
                    cls: 'key',
                    xtype: 'combo', //combo
                    fieldLabel: '客户性质',
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
            {//第十一行第二列
                columnWidth: .33,  //该列占用的宽度，标识为50％
                layout: 'form',
                border: false,
                items: [{
                    cls: 'key',
                    xtype: 'combo',
                    fieldLabel: '<b>客户状态*</b>',
                    name: 'State',
                    id: 'State',
                    store: [[0, '正常'], [1, '禁用'], [2, '删除']],
                    mode: 'local',
                    triggerAction: 'all',
                    editable: false,
                    anchor: '90%',
                    value: 0
                    // maxLength: 1000,  
                    // allowBlank : true
                }]
            },
            {//第十一行第三列
                columnWidth: .317,  //该列占用的宽度，标识为50％
                layout: 'form',
                border: false,
                items: [{
                    cls: 'key',
                    xtype: 'combo',
                    fieldLabel: '是否共享',
                    name: 'IsShare',
                    id: 'IsShare',
                    store: [[0, '不共享'], [1, '共享']],
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
    title: '扩展信息',
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
    [{//第一行开始
        layout: 'column',   //定义该元素为布局为列布局方式
        border: false,
        items:
        [{//第一行第一列开始
            columnWidth: .33,  //该列占用的宽度，标识为50％
            layout: 'form',
            border: false,
            items: [{

                cls: 'key',
                xtype: 'textfield',
                fieldLabel: '信用额度',
                name: 'CreditSum',
                id: 'CreditSum',
                anchor: '90%'
                // maxLength: 1000,  
                // allowBlank : true

            }]
        },
        {
            columnWidth: .318,  //该列占用的宽度，标识为50％
            layout: 'form',
            border: false,
            items: [{
                cls: 'key',
                xtype: 'combo',
                fieldLabel: '结算方式',
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
           columnWidth: .317,  //该列占用的宽度，标识为50％
           layout: 'form',
           border: false,
           items: [{
               cls: 'key',
               xtype: 'checkbox',
               value: 'kp',
               boxLabel: '开票',
               name: 'IsMakeinvoice',
               id: 'IsMakeinvoice',
               anchor: '90%'
               // maxLength: 1000,  
               // allowBlank : true

            }]
        }]
    }, {
        layout: 'column',   //定义该元素为布局为列布局方式
        border: false,
        items:
        [{//
            columnWidth: .33,  //该列占用的宽度，标识为50％
            layout: 'form',
            border: false,
            items: [{

                cls: 'key',
                xtype: 'datefield',
                fieldLabel: '发证日期',
                name: 'AwarDdate',
                id: 'AwarDdate',
                anchor: '90%',
                format: 'Y年m月d日'
                //editable: false
                // maxLength: 1000,  
                // allowBlank : true

            }]
        },
        {
            columnWidth: .67,  //该列占用的宽度，标识为50％
            layout: 'form',
            border: false,
            items: [{

                cls: 'key',
                xtype: 'combo',
                fieldLabel: '所属行业',
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
        layout: 'column',   //定义该元素为布局为列布局方式
        border: false,
        items:
        [{//
            columnWidth: .33,  //该列占用的宽度，标识为50％
            layout: 'form',
            border: false,
            items: [{

                cls: 'key',
                xtype: 'textfield',  //combo
                fieldLabel: '结算方',
                name: 'SettlementParty',
                id: 'SettlementParty',
                anchor: '90%',
                store: [[], [], []]
                // maxLength: 1000,  
                // allowBlank : true

            }]
        },
        {
            columnWidth: .67,  //该列占用的宽度，标识为50％
            layout: 'form',
            border: false,
            items: [{

                cls: 'key',
                xtype: 'combo', //combo
                fieldLabel: '结算组织',
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
        layout: 'column',   //定义该元素为布局为列布局方式
        border: false,
        items:
        [{
            columnWidth: .33,  //该列占用的宽度，标识为50％
            layout: 'form',
            border: false,
            items: [{
                cls: 'key',
                xtype: 'combo',
                fieldLabel: '结算类型',
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
                columnWidth: .317,  //该列占用的宽度，标识为50％
                layout: 'form',
                border: false,
                items: [{

                    cls: 'key',
                    xtype: 'combo',
                    fieldLabel: '结算币种',
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
                columnWidth: .318,  //该列占用的宽度，标识为50％
                layout: 'form',
                border: false,
                items: [{

                    cls: 'key',
                    xtype: 'combo',
                    fieldLabel: '开票类型',
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
            layout: 'column',   //定义该元素为布局为列布局方式
            border: false,
            items:
            [{//
                columnWidth: .33,  //该列占用的宽度，标识为50％
                layout: 'form',
                border: false,
                items: [{

                    cls: 'key',
                    xtype: 'textfield',
                    fieldLabel: '负责人',
                    name: 'Principal',
                    id: 'Principal',
                    anchor: '90%'
                    // maxLength: 1000,  
                    // allowBlank : true

                }]
            },
            {
                columnWidth: .32,  //该列占用的宽度，标识为50％
                layout: 'form',
                border: false,
                items: [{
                    style: 'margin-top:3px',
                    cls: 'key',
                    xtype: 'textfield',
                    fieldLabel: '负责人电话',
                    name: 'PrincipalTel',
                    id: 'PrincipalTel',
                    anchor: '90%'
                    // maxLength: 1000,  
                    // allowBlank : true

            }]
        },
        {
            columnWidth: .32,  //该列占用的宽度，标识为50％
            layout: 'form',
            border: false,
            items: 
            [{
                style: 'margin-top:3px',
                cls: 'key',
                xtype: 'textfield',
                fieldLabel: '线路情况',
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
            layout: 'column',   //定义该元素为布局为列布局方式
            border: false,
            items:
            [{//
                columnWidth: .33,  //该列占用的宽度，标识为50％
                layout: 'form',
                border: false,
                items: [{

                    cls: 'key',
                    xtype: 'textfield',
                    fieldLabel: '网结名称',
                    name: 'BalanceBankName',
                    id: 'BalanceBankName',
                    anchor: '90%'
                    // maxLength: 1000,  
                    // allowBlank : true

                }]
            },
            {
                columnWidth: .32,  //该列占用的宽度，标识为50％
                layout: 'form',
                border: false,
                items: [{
                    style: 'margin-top:3px',
                    cls: 'key',
                    xtype: 'textfield',
                    fieldLabel: '网结账号',
                    name: 'BlanaceBankAccount',
                    id: 'BlanaceBankAccount',
                    anchor: '90%'
                    // maxLength: 1000,  
                    // allowBlank : true

            }]
        },
        {
            columnWidth: .32,  //该列占用的宽度，标识为50％
            layout: 'form',
            border: false,
            items: 
            [{
                cls: 'key',
                xtype: 'combo',
                fieldLabel: '网结银行',
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
        layout: 'column',   //定义该元素为布局为列布局方式
        border: false,
        items:
        [{
            columnWidth: .33,  //该列占用的宽度，标识为50％
            layout: 'form',
            border: false,
            items: [{
                cls: 'key',
                xtype: 'textfield',
                fieldLabel: '开户银行',
                name: 'BankId',
                id: 'BankId',
                anchor: '90%'
                // maxLength: 1000,  
                // allowBlank : true
            }]
        }
        ,{//
            columnWidth: .318,  //该列占用的宽度，标识为50％
            layout: 'form',
            border: false,
            items: [{
                cls: 'key',
                xtype: 'textfield',
                fieldLabel: '银行账户',
                name: 'BankAccount',
                id: 'BankAccount',
                anchor: '90%'
                // maxLength: 1000,  
                // allowBlank : true

            }]
        },
        {
            columnWidth: .317,  //该列占用的宽度，标识为50％
            layout: 'form',
            border: false,
            items: [{
                cls: 'key',
                xtype: 'datefield',
                fieldLabel: '开户时间',
                name: 'BankDate',
                id: 'BankDate',
                anchor: '90%',
                format: 'Y年m月d日'
                //editable: false
                // maxLength: 1000,  
                // allowBlank : true

            }]
        }]
    },
    {
        layout: 'column',   //定义该元素为布局为列布局方式
        border: false,
        items:
        [{//
            columnWidth: .33,  //该列占用的宽度，标识为50％
            layout: 'form',
            border: false,
            items: [{

                cls: 'key',
                xtype: 'textfield',
                fieldLabel: '许可证号',
                name: 'LicenseNo',
                id: 'LicenseNo',
                anchor: '90%'
                // maxLength: 1000,  
                // allowBlank : true

            }]
        },
        {
            columnWidth: .318,  //该列占用的宽度，标识为50％
            layout: 'form',
            border: false,
            items: [{

                cls: 'key',
                xtype: 'textfield',
                fieldLabel: '工商编号',
                name: 'BusinessNo',
                id: 'BusinessNo',
                anchor: '90%'
                // maxLength: 1000,  
                // allowBlank : true

            }]
        },
        {
            columnWidth: .317,  //该列占用的宽度，标识为50％
            layout: 'form',
            border: false,
            items: [{

                cls: 'key',
                xtype: 'textfield',
                fieldLabel: '税号',
                id: 'TaxNo',
                name: 'TaxNo',
                anchor: '90%'
                // maxLength: 1000,  
                // allowBlank : true

            }]
        }]
    },
    {
        layout: 'column',   //定义该元素为布局为列布局方式
        border: false,
        items:
        [{//
            columnWidth: 1,  //该列占用的宽度，标识为50％
            layout: 'form',
            border: false,
            items: [{

                cls: 'key',
                xtype: 'textfield',
                fieldLabel: '自定义信息',
                name: 'CustomizeInfo',
                id: 'CustomizeInfo',
                anchor: '93%'
                // maxLength: 1000,  
                // allowBlank : true

            }]
        }]
    },
    {
        layout: 'column',   //定义该元素为布局为列布局方式
        border: false,
        items:
        [{//
            columnWidth: 1,  //该列占用的宽度，标识为50％
            layout: 'form',
            height: 50,
            border: false,
            items: [{

                cls: 'key',
                xtype: 'textarea',
                fieldLabel: '备注',
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
            useArrows:true,//是否使用箭头
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
            text: '线路情况',
            draggable:false,
            id:'0'
        });
        routetree.setRootNode(root);
    }    
    if( routeSelectWin == null){
        routeSelectWin = new Ext.Window({
             title:'线路信息',
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
                           
if (typeof (uploadWindow) == "undefined") {//解决创建2个windows问题
    uploadWindow = new Ext.Window({
        id: 'formwindow',
        title: "新增客户"
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
             text: "保存"
            , handler: function() {
                uploadFormValue();

            }
                , scope: this
         },
        {
            text: "取消"
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
    var innercus = 0; //内部客户
    if (Ext.get("IsIncust").dom.checked) {
        innercus = 1;
    }
    var supply = 0;                       //供应商
    if (Ext.get("IsProvide").dom.checked) {
        supply = 1;
    }
    var cus = 0;                          //客商
    if (Ext.get("IsCust").dom.checked) {
        cus = 1;
    }
    var extracus = 0;                     //无碘盐客商
    if (Ext.get("IsOrthercust").dom.checked) {
        extracus = 1;
        cus = 1;//default
    }
    var kp = 0;                       //是否开票
    if (Ext.get("IsMakeinvoice").dom.checked) {
        kp = 1;
    }
    if(innercus+supply+cus+extracus<1){
        Ext.Msg.alert("提示", "请选择客户类型！");
        return;
    }

    if (saveType == 'add')
        saveType = 'addCustomer';
    else if (saveType == 'edit')
        saveType = 'saveCustomer';

    var BankDate = Ext.getCmp('BankDate').getValue();
    if (BankDate == null || BankDate == "") {
        //alert("请输入开户时间！");
        //return;
        BankDate = new Date("1901-01-01 00:00:01");
    }
    var AwarDdate = Ext.getCmp('AwarDdate').getValue();
    if (AwarDdate == null || AwarDdate == "") {
        //alert("请输入发证日期！");
        //return;
        AwarDdate = new Date("1901-01-01 00:00:01");
    }
    var EodrDate = Ext.getCmp('EodrDate').getValue();
    if (EodrDate == null || EodrDate == "") {
        //alert("请输入建交时间！");
        //return;
        EodrDate = new Date("1901-01-01 00:00:01");
    }
    
    Ext.MessageBox.wait("数据正在保存，请稍后……");
    Ext.Ajax.request({
        url: 'customerManage.aspx?method=' + saveType + owner,
        method: 'POST',
        params: {
            CustomerId: Ext.getCmp('CustomerId').getValue(), //ID
            CustomerNo: Ext.getCmp('CustomerNo').getValue(), //编号
            ChineseName: Ext.getCmp('ChineseName').getValue(), //中文名称
            MnemonicNo: Ext.getCmp('MnemonicNo').getValue(), //助记码
            EnglishName: Ext.getCmp('EnglishName').getValue(), //英文名称
            ShortName: Ext.getCmp('ShortName').getValue(), //简称
            Address: Ext.getCmp('Address').getValue(), //地址
            LinkMan: Ext.getCmp('LinkMan').getValue(), //联系人
            LinkTel: Ext.getCmp('LinkTel').getValue(), //联系电话
            LinkMobile: Ext.getCmp('LinkMobile').getValue(), //移动电话
            Zipcode: Ext.getCmp('Zipcode').getValue(), //邮编
            Fax: Ext.getCmp('Fax').getValue(), //传真
            Email: Ext.getCmp('Email').getValue(), //邮箱
            DeliverDate: Ext.getCmp('DeliverDate').getValue(), //送货时间
            DeliverAdd: Ext.getCmp('DeliverAdd').getValue(), //送货地址
            DistributionType: Ext.getCmp('DistributionType').getValue(), //配送类型
            DeliverCorp: Ext.getCmp('DeliverCorp').getValue(), //送货公司
            MonthQuantity: Ext.getCmp('MonthQuantity').getValue(), //月用量
            CorpKind: Ext.getCmp('CorpKind').getValue(), //公司类型
            CustKind: Ext.getCmp('CustKind').getValue(), //企业性质
            EodrDate: Ext.util.Format.date(EodrDate,'Y/m/d'), //建交时间
            Province: Ext.getCmp('Province').getValue(), //所在省
            City: Ext.getCmp('City').getValue(), //所在市
            Town: Ext.getCmp('Town').getValue(), //所在乡镇
            IsIncust: innercus,                          //内部客户
            IsProvide: supply,                       //供应商
            IsCust: cus,                          //客商
            IsOrthercust: extracus,                     //其他客商
            State: Ext.getCmp('State').getValue(), //客户状态
            //OwenId:Ext.getCmp('OwenId').getValue(),//业务员
            //OwenOrg:Ext.getCmp('OwenOrg').getValue(),//组织
            CreditSum: Ext.getCmp('CreditSum').getValue(), //信用额度
            SettlementWay: Ext.getCmp('SettlementWay').getValue(), //结算方式
            IsMakeinvoice: kp,                    //是否开票
            AwarDdate: Ext.util.Format.date(AwarDdate,'Y/m/d'), //发证日期
            TradeType: Ext.getCmp('TradeType').getValue(), //行业
            SettlementParty: Ext.getCmp('SettlementParty').getValue(), //结算方
            ClearingOrg: Ext.getCmp('ClearingOrg').getValue(), //计算组织
            SettlementType: Ext.getCmp('SettlementType').getValue(), //结算类型
            SettlementCurrency: Ext.getCmp('SettlementCurrency').getValue(), //结算币种
            Principal: Ext.getCmp('Principal').getValue(), //负责人
            PrincipalTel: Ext.getCmp('PrincipalTel').getValue(), //负责人电话
            BankAccount: Ext.getCmp('BankAccount').getValue(), //银行账户
            BankId: Ext.getCmp('BankId').getValue(), //开户银行
            BankDate: Ext.util.Format.date(BankDate,'Y/m/d'), //开户时间
            LicenseNo: Ext.getCmp('LicenseNo').getValue(), //许可证号
            BusinessNo: Ext.getCmp('BusinessNo').getValue(), //工商编号
            TaxNo: Ext.getCmp('TaxNo').getValue(), //税号
            Remark: Ext.getCmp('Remark').getValue(), //备注
            IsShare: Ext.getCmp('IsShare').getValue(), //是否共享
            InvoiceType: Ext.getCmp('InvoiceType').getValue(),//开票类型
            RouteId:Ext.getCmp('RouteId').getValue(),//线路情况
            
            BankName:Ext.getCmp('BankName').getValue(),//
            BalanceBankName:Ext.getCmp('BalanceBankName').getValue(),//
            BlanaceBankAccount:Ext.getCmp('BlanaceBankAccount').getValue(),//
            CustomizeInfo:Ext.getCmp('CustomizeInfo').getValue()//
            /*
            OrgId:Ext.getCmp('OrgId').getValue() //创建组织
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
             Ext.Msg.alert("提示", "保存失败");

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
    //增加一新行
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
    if (typeof (addWindow) == "undefined") {//解决创建2个windows问题
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
                    loadMask: { msg: '正在加载数据，请稍侯……' },
                    sm: smadd,
                    cm: new Ext.grid.ColumnModel([
                    smadd,
                    new Ext.grid.RowNumberer(),//自动行号
                    {
                        id: 'AttributeId',
                        header: "ID",
                        dataIndex: 'AttributeId',
                        width: 30,
                        hidden: true
                    },
                    {
                        header:'客户送货地址列表',
                        dataIndex:'AttributeValue',
                        id:'AttributeValue',
                        width:180,
		                editor: new Ext.form.TextField({
		                    
		                })
                    }		]),
                    viewConfig: {
                        columnsText: '显示的列',
                        scrollOffset: 20,
                        sortAscText: '升序',
                        sortDescText: '降序',
                        forceFit: true
                    },
                    height: 120,
                    closeAction: 'hide',
                    stripeRows: true,
                    loadMask: true
                });
        addWindow = new Ext.Window({
            id:'addWindow',
            title: "客户地址维护"
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
                text: "新增", 
                handler: function() {
                    addNewBlankRow();
                }, scope: this
             },
             {
                text: "保存", 
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
                        //主参数
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
		                Ext.Msg.alert("提示","取消失败");     
		            } 
		            });              

                }, scope: this
             },
             {
                text: "选择", 
                handler: function() {
                    var sm = addressgrid.getSelectionModel();
                    var selectData = sm.getSelected();
                    if (selectData == null) {
                        Ext.Msg.alert("提示", "请选中一行！");
                        return;
                    }
                    if(selectData.data.AttributeId==-1){
                        Ext.Msg.alert("提示", "请先保存新增的地址信息！");
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
var recrod = new Ext.data.Record({DicsCode:'',DicsName:'无'});
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
                data:[['','全部'],['0','否'],['1','是']],
                autoLoad: false});
            return dsIsSupplier; 
        case "IsCust":
            var dsIsCust = new Ext.data.SimpleStore({ 
                fields:['IsCust','IsCustText'],
                data:[['','全部'],['0','否'],['1','是']],
                autoLoad: false});
            return dsIsCust; 
        case "IsOrthercust":
            var dsIsOrthercust = new Ext.data.SimpleStore({ 
                fields:['IsOrthercust','IsOrthercustText'],
                data:[['','全部'],['0','否'],['1','是']],
                autoLoad: false});
            return dsIsOrthercust; 
        default:
            return null;
    }
}                   
</script>
</html>