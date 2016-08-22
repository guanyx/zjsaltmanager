<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmScmOrderBalance.aspx.cs" Inherits="SCM_frmScmOrderBalance" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html>
<head>
<title>订单管理</title><meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<link rel="stylesheet" type="text/css" href="../ext3/resources/css/ext-all.css" />
<link rel="stylesheet" href="../css/orderdetail.css"/>
<link rel="stylesheet" type="text/css" href="../Theme/1/css/salt.css" />
<script type="text/javascript" src="../ext3/adapter/ext/ext-base.js"></script>
<script type="text/javascript" src="../ext3/ext-all.js"></script>
<script type="text/javascript" src="../js/operateResp.js"></script>
<script type="text/javascript" src="../js/floatUtil.js"></script>
<script type="text/javascript" src="../js/ExtJsHelper.js"></script>
<script type="text/javascript" src="../ext3/src/locale/ext-lang-zh_CN.js"></script>
<link rel="stylesheet" type="text/css" href="../ext3/example/file-upload.css" />
<script type="text/javascript" src="../ext3/example/FileUploadField.js"></script>
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
<form id="form2">
<div id='file'></div>
</form>
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
                text: "发送结算邮件",
                icon: "../Theme/1/images/extjs/customer/add16.gif",
                handler: function() { sendAbcMail(); }
            }, '-', {
                text: "接收邮件",
                icon: "../Theme/1/images/extjs/customer/edit16.gif",
                handler: function() { receiveMail(); }
            },'-',{
                text:"导出文件",
                icon:"../Theme/1/images/extjs/customer/edit16.gif",
                handler:function(){exportUucData();}
            },'-',{
                text:"导入文件",
                icon:"../Theme/1/images/extjs/customer/edit16.gif",
                handler:function(){importData();}
            },'-', {
                text: "开票",
                icon: "../Theme/1/images/extjs/customer/edit16.gif",
                handler: function() {  generBill(); }
            }, '-', {
                text: "查看今天结算情况",
                icon: "../Theme/1/images/extjs/customer/edit16.gif",
                handler: function() {  viewBalanceData(); }
            }, '-'
            ]
            });
            
            setToolBarVisible(Toolbar);
            
            //定义下拉框异步调用方法,当前客户可订商品列表
        var dsBalanceData = new Ext.data.Store({   
            url: 'frmScmOrderBalance.aspx?method=viewbalance',  
            params: {
                Bank:bankType
            },
            reader: new Ext.data.JsonReader({  
                root: 'root',  
                totalProperty: 'totalProperty',  
                id: 'ProductUnits'  
            }, [  
                {name: 'SLXH'}, 
                {name: 'MC'},
                {name: 'JE'},
                {name: 'KHBH'},
                {name: 'SBYY'}
            ]) 
        });
        var sm1 = new Ext.grid.CheckboxSelectionModel({
            singleSelect: true
        });
        var balanceDataGrid = new Ext.grid.EditorGridPanel({ 
                             width: 530,
                            region: 'center',
                //            height: 240,
                //            autoWidth: true,
                            autoHeight: true,
                            //autoScroll: true,
                            stripeRows: true,
                            layout: 'fit',
                            //region: "center",
                            border: true,
                            id: 'planDtlGrid',
                            store: dsBalanceData,
                            sm: sm1,
                            cm: new Ext.grid.ColumnModel([                            
		                    sm1,
		                    {
			                    header:'订单编号',
			                    dataIndex:'SLXH',
			                    id:'SLXH',
			                    sortable: true,
			                    width:120
		                    },
		                    {
		                        header:'账号名称',
			                    dataIndex:'MC',
			                    id:'MC',
			                    width:120
		                    },
		                    {
		                        header:'客户编号',
			                    dataIndex:'KHBH',
			                    id:'KHBH',
			                    sortable: true,
			                    width:70
		                    },
		                    {
		                        header:'受理结果',
			                    dataIndex:'SBYY',
			                    id:'SBYY',
			                    sortable: true,
			                    width:150
		                    },{
		                        header:'金额',
			                    dataIndex:'JE',
			                    id:'JE',
			                    sortable: true,
			                    width:80
		                    }]),
		                    viewConfig: {                   
                                forceFit: true
                            },
                            closeAction: 'hide',
                            stripeRows: true,
                            loadMask: true,
                            autoExpandColumn: 2});
		   /*------开始界面数据的窗体 Start---------------*/
//		   var uploadBalanceWindow;
		   function viewBalanceData()
		   {
                if (typeof (uploadBalanceWindow) == "undefined") {//解决创建2个windows问题
                    uploadBalanceWindow = new Ext.Window({
                        id: 'Mstformwindow',
                        title: '结算情况查看'
		                , iconCls: 'upload-win'
		                , width: 800
		                , height: 450
		                , layout: 'border'
		                , plain: true
		                , modal: true
		                , x: 50
		                , y: 50
		                , constrain: true
		                , resizable: false
		                , closeAction: 'hide'
		                , autoScroll: true
		                , autoDestroy: true
		                , items: [balanceDataGrid]
		                , buttons: [{
		                    text: "关闭"
			                , handler: function() {
			                    uploadBalanceWindow.hide();
			                }
			                , scope: this
		                }]
                    });
                  }
                  dsBalanceData.baseParams.Bank = bankType;
                  dsBalanceData.load();
                  uploadBalanceWindow.show();
             }                 
            
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
                    
                    isbill = selectData[i].get('IsBill'); 
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
            /*------结束toolbar的函数 end---------------*/
            var fileWindow = null;
function importData(){
    if(fileWindow== null || typeof (fileWindow) == "undefined"){
        var upform = new Ext.form.FormPanel({
            title:'请选择导入文件',
            frame: true,
            layout: 'fit',
            labelAlign: 'left',
            buttonAlign: 'center',
            bodyStyle: 'padding:5px',
            labelWidth: 55,
            fileUpload:true, 
            defaults: {
               msgTarget: 'side'
            },
            items: [
	        {
	            layout: 'form',
	            border: false,
	            columnWidth: 1,
                    items: [
		            {
		                xtype: 'fileuploadfield',
		                fieldLabel: '文件名称',
		                emptyText:'请选择附件',
		                anchor: '90%',
		                name: 'ContarctAttach',
		                id: 'ContarctAttach',
		                buttonText: '选择'
                        //disabled:true
                        //readOnly:true,
		            }]
	        }]
        });
        fileWindow = new Ext.Window({
            id: 'upl1',
            title: "文件选择框"
	        , iconCls: 'upload-win'
	        , width: 400
	        , height: 150
	        , plain: true
	        , modal: true
	        , constrain: true
	        , resizable: false
	        , closeAction: 'hide'
	        , autoScroll:true
	        , autoDestroy: true
	        , items: [upform]
	        , buttons: [{
	            text: "保存"
		        , handler: function() {
		             upform.getForm().submit({  
                            url : 'frmScmOrderBalance.aspx?method=importData',
                            method: 'POST',
                            success: function(form, action){
                               fileWindow.hide();  
                               checkExtMessage(action.response);
//                               Ext.Msg.alert("提示", action.result);
                            },      
                           failure: function(){      
                              Ext.Msg.alert("提示", "导入失败");
                           }  
                     });  
		        }
		        , scope: this
	        },
	        {
	            text: "取消"
		        , handler: function() {
		            fileWindow.hide();
		        }
		        , scope: this
            }]
        });
        fileWindow.addListener("hide", function() {
            upform.getForm().reset();
        });
    }
    fileWindow.show();  
}
            function exportUucData()
            {
                var sm = OrderMstGrid.getSelectionModel();
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
                if(orderIds.length==0)
                {
                    Ext.Msg.alert("请选择需要联合银行结算的数据！","系统提示");
                    return;
                }
                Ext.Msg.wait("正在生成文件，请稍后！");
                if (!Ext.fly('frmDummye')) {
                    var frm = document.createElement('form');
                    frm.id = 'frmDummye';
                    frm.name = id;
                    frm.className = 'x-hidden';
                    document.body.appendChild(frm);
                }
                Ext.Ajax.request({
                    url: 'frmScmOrderBalance.aspx?method=geturcbfile',//将生成的xml发送到服务器端
                    method: 'POST',
                    form: Ext.fly('frmDummye'),
                    callback: function(o, s, r) {
                        Ext.Msg.hide();//alert(r.responseText);
                    },
                    isUpload: true,
                    params: { OrderIds: orderIds,ExportFile: 'URCB' },
                    success: function(form, action){
                               Ext.Msg.hide();
                            },      
                           failure: function(){      
                              Ext.Msg.hide();
                           }  
                });
                Ext.Msg.hide();
            }
function sendAbcMail()
{
    
    var sm = OrderMstGrid.getSelectionModel();
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
    if(orderIds.length==0)
    {
        Ext.Msg.alert("请选择需要农行结算的数据！","系统提示");
        return;
    }
    Ext.Msg.wait("正在生成邮件，并发送邮件！");
    Ext.Ajax.request({
        url: 'frmScmOrderBalance.aspx?method=sendAbcMail',
        method: 'POST',
        params: {
            OrderId: orderIds
        },
        success: function(resp,opts){ 
           Ext.Msg.hide();
           checkExtMessage(resp);
       },
       failure: function(resp,opts){  /* Ext.Msg.alert("提示","保存失败"); */    }
    });
}

function receiveMail()
{
    Ext.Msg.wait("正在接收邮件，并处理邮件相关信息！");
    Ext.Ajax.request({
        url: 'frmScmOrderBalance.aspx?method=receiveAbcMail',
        method: 'POST',
        params: {
            OrderId: ''
        },
        success: function(resp,opts){ 
            Ext.Msg.hide();
           checkExtMessage(resp);
       },
       failure: function(resp,opts){  /* Ext.Msg.alert("提示","保存失败"); */    }
    });
}

            /*------开始ToolBar事件函数 start---------------*//*-----新增Order实体类窗体函数----*/
                        
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
                OrderMstGridData.baseParams.Bank=bankType;
                OrderMstGridData.load({
                    params: {
                        start: 0,
                        limit: defaultPageSize
                    },
                    callback:setAllTotalAmt
                });
            }
            function setAllTotalAmt(){
                var tamt =0;
                OrderMstGridData.each(function(rec) {
                    if(rec.data.SaleTotalAmt == null && rec.data.SaleTotalAmt == undefined)
                        rec.data.SaleTotalAmt = 0;
                    tamt =accAdd(rec.data.SaleTotalAmt,tamt);
                });
                Ext.getCmp('BalanceTotalAmt').setValue(tamt.toFixed(2));
            }

              //仓库
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
                   fieldLabel: '仓库',
                   selectOnFocus: true,
                   anchor: '90%'
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
				   value:'S011',
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
			                    columnWidth:0.275*version,
			                    items: [
			                    {
				                    xtype:'textfield',
				                    fieldLabel:'客户',
				                    anchor:'100%',
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
					                store:[[1,'是'],[0,'否']],
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
					                store:[[1,'是'],[0,'否']],
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
                                labelWidth:70,
                                columnWidth:.33,
                                items:[{
                                     layout:'form',
                                    border:false,
                                    columnWidth:0.33,
                                    html:'&nbsp'
                                }]
                            },
                            {//第二单元格
                                layout:'form',
                                border: false,
                                labelWidth:70,
                                columnWidth:.33,
                                items:[{
                                       
                                }]
                            },
                            {//第三单元格
                                layout:'form',
                                border: false,
                                labelWidth:70,
                                columnWidth:0.34,
                                items:[
                                    {
                                       xtype:'button',
                                        text:'查询',
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



                        /*------开始查询form的函数 end---------------*/

                        /*------开始界面数据的窗体 Start---------------*/
                        if (typeof (uploadOrderWindow) == "undefined") {//解决创建2个windows问题
                            uploadOrderWindow = new Ext.Window({
                                id: 'Orderformwindow',
                                iconCls: 'upload-win'
		                        , width: 780
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
                           //document.getElementById("editIFrame").src = "frmOrderDtl.aspx?OpenType=oper&id=0";//清楚其内容，建议在子页面提供一个方法来调用
                        });

                        

                       
                        /*------开始获取数据的函数 start---------------*/
                        OrderMstGridData = new Ext.data.Store
                        ({
                            url: 'frmScmOrderBalance.aspx?method=getOrderList',
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

                        /*------获取数据的函数 结束 End---------------*/
var defaultPageSize = 100;
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
        width: 85
    });
    toolBar.addField(combo);
    
    var otalb = new Ext.form.Label({
        //xtype: 'numberfield',
        //format:true,
        width: 30,
        id:'BalanceTotalAmtlb',
        name:'BalanceTotalAmtlb',
        text:'合计金额:'
    });
    toolBar.addField(otalb);
    var ota = new Ext.form.NumberField({
        //xtype: 'numberfield',
        format:true,
        width: 60,
        id:'BalanceTotalAmt',
        name:'BalanceTotalAmt',
        value:'0.00',
        style: 'color:blue;background:white;text-align: right',
        readOnly:true
    });
    toolBar.addField(ota);

    combo.on("change", function(c, value) {
        toolBar.pageSize = value;
        defaultPageSize = toolBar.pageSize;
    }, toolBar);
    combo.on("select", function(c, record) {
        toolBar.pageSize = parseInt(record.get("pageSize"));
        defaultPageSize = toolBar.pageSize;
        QueryDataGrid();
    }, toolBar);
                        /*------开始DataGrid的函数 start---------------*/

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
			                    id:'OrderNumber',
			                    sortable: true,
			                    width:85
		                    },
		                    {
		                        header:'公司名称',
			                    dataIndex:'OrgName',
			                    id:'OrgName',
			                    width:120
		                    },
//		                    {
//		                        header:'销售部门',
//			                    dataIndex:'DeptName',
//			                    id:'DeptName'
//		                    },
		                    {
		                        header:'出库仓库',
			                    dataIndex:'OutStorName',
			                    id:'OutStorName',
			                    sortable: true,
			                    width:70
		                    },
		                    {
		                        header:'客户名称',
			                    dataIndex:'CustomerName',
			                    id:'CustomerName',
			                    sortable: true,
			                    width:150
		                    },
		                    {
			                    header:'送货日期',
			                    dataIndex:'DlvDate',
			                    id:'DlvDate',
			                    renderer: Ext.util.Format.dateRenderer('Y年m月d日'),
			                    sortable: true,
			                    width:95
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
			                    width:55
		                    },
		                    {
		                        header:'配送方式',
			                    dataIndex:'DlvTypeName',
			                    id:'DlvTypeName',
			                    sortable: true,
			                    width:55
		                    },
		                    {
		                        header:'是否开票',
			                    dataIndex:'IsBillName',
			                    id:'IsBillName',
			                    width:55
		                    },
		                    {
		                        header:'是否结款',
			                    dataIndex:'IsPayedName',
			                    id:'IsPayedName',
			                    sortable: true,
			                    width:55
		                    },
//		                    {
//		                        header:'送货等级',
//			                    dataIndex:'DlvLevelName',
//			                    id:'DlvLevelName',
//			                    width:60,
//			                    hidden:true
//		                    },
		                    {
			                    header:'总重量',
			                    dataIndex:'SaleTotalQty',
			                    id:'SaleTotalQty',
			                    width:50
		                    },
		                    {
			                    header:'总金额',
			                    dataIndex:'SaleTotalAmt',
			                    id:'SaleTotalAmt',
			                    sortable: true,
			                    width:50
		                    },
		                    {
		                        header:'操作员',
			                    dataIndex:'OperName',
			                    id:'OperName',
			                    width:50
		                    },
		                    {
			                    header:'创建时间',
			                    dataIndex:'CreateDate',
			                    id:'CreateDate',
			                    renderer: Ext.util.Format.dateRenderer('Y年m月d日'),
			                    width:95
		                    },
		                    {
		                        header:'打印次数',
		                        title:'该项仅供参考',
			                    dataIndex:'PrintNum',
			                    id:'PrintNum',
			                    sortable: true,
			                    width:55
		                        
		                    }		]),
                            bbar:toolBar,
                            viewConfig: {
                                columnsText: '显示的列',
                                scrollOffset: 20,
                                sortAscText: '升序',
                                sortDescText: '降序',
                                forceFit: false,
                                getRowClass: function(r, i, p, s) {
                                    if (r.data.TransType == 1) {
                                        return "x-grid-tanstype";
                                    }
                                }
                            },
                            height: 303,
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
                            if (typeof (uploadRouteWindow) == "undefined") {
                                newFormWin = new Ext.Window({
                                    layout: 'fit',
                                    width: 600,
                                    height: 350,
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
	                            { name: 'SaleTax' },
	                            { name: 'TaxRate' },
	                            { name: 'DiscountRate' },
	                            { name: 'DiscountAmt' }
	                            ])
                            });

                        var smDtl = new Ext.grid.CheckboxSelectionModel({
                            singleSelect: true
                        });
                        var orderDtInfoGrid = new Ext.grid.GridPanel({
                            //width: '100%',
                            //height: '100%',
                            //autoWidth: true,
                            //autoHeight: true,
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
		                            id: 'ProductNo',
		                                width: 65
		                        },
		                            {
		                                header: '存货名称',
		                                dataIndex: 'ProductName',
		                                id: 'ProductName',
		                                width: 150
		                            },
		                            {
		                                header: '规格',
		                                dataIndex: 'SpecificationsName',
		                                id: 'SpecificationsName',
		                                width: 65
		                            },
		                            {
		                                header: '单位',
		                                dataIndex: 'UnitName',
		                                id: 'UnitName',
		                                width: 50
		                            },
		                            {
		                                header: '税率',
		                                dataIndex: 'TaxRate',
		                                id: 'TaxRate',
		                                width: 50
		                            },
		                            {
		                                header: '数量',
		                                dataIndex: 'SaleQty',
		                                id: 'SaleQty',
		                                width: 55
		                            },
		                            {
		                                header: '单价',
		                                dataIndex: 'SalePrice',
		                                id: 'SalePrice',
		                                width: 55
		                            },
		                            {
		                                header: '金额',
		                                dataIndex: 'SaleAmt',
		                                id: 'SaleAmt',
		                                width: 65
		                            },
		                            {
		                                header: '折扣金额',
		                                dataIndex: 'DiscountAmt',
		                                id: 'DiscountAmt'
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
                                forceFit: false
                            },
                            height: 280,
                            closeAction: 'hide',
                            stripeRows: true,
                            loadMask: true//,
                            //autoExpandColumn: 2
                        });
                        /****************************************************************/
                        /*------DataGrid的函数结束 End---------------*/
                        //QueryDataGrid();
Ext.getCmp('IsPayed').setValue("0");
                       gs.setValue(<% =ZJSIG.UIProcess.ADM.UIAdmUser.OrgID(this)%>);
                       gs.setDisabled(true);
                       bm.setValue(<% =ZJSIG.UIProcess.ADM.UIAdmUser.DeptID(this)%>);
                       bm.setDisabled(true);
                    })
                    
//                    function getPayTypeIndex(selectedId)
//                    {
//                        var orderIndex = OrderMstGridData.find("
//                         var index = dsPayType.find('DicsCode', Ext.getCmp("Pay);
//                    }
</script>

</html>
<script type="text/javascript" src="../js/SelectModule.js"></script>