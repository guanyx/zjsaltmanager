<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmProvideSendYx.aspx.cs" Inherits="SCM_frmProvideSendYx" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>发运单(省公司代录)</title>
    <meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
    <link rel="stylesheet" type="text/css" href="../ext3/resources/css/ext-all.css" />
    <script type="text/javascript" src="../ext3/adapter/ext/ext-base.js"></script>
    <script type="text/javascript" src="../ext3/ext-all.js"></script>
    <script type="text/javascript" src="../ext3/example/ItemDeleter.js"></script>
    <script type="text/javascript" src="../js/operateResp.js"></script>
    <script type="text/javascript" src="../ext3/src/locale/ext-lang-zh_CN.js"></script>
    <script type="text/javascript" src="../js/floatUtil.js"></script>
    <style type="text/css">
    .extensive-remove
    {
        background-image: url(../Theme/1/images/extjs/customer/cross.gif) !important;
    }
    .x-grid-canop { 
        color:blue; 
    }
    </style>
</head>
<%=getComboBoxStore() %>
<body>
<div id='searchForm'></div>
<div id='operateForm'></div>
<div id='datadetailGrid'></div>

<script type="text/javascript">  
Ext.BLANK_IMAGE_URL = "../ext3/resources/images/default/s.gif";
Ext.onReady(function(){    
     //开始日期
    var provideStartPanel = new Ext.form.DateField({
        xtype:'datefield',
        fieldLabel:'发货开始日期',
        anchor:'98%',
        name:'StartDate',
        id:'StartDate',
        format: 'Y年m月d日',  //添加中文样式
        value:new Date().clearTime() 
    });

    //结束日期
    var provideEndPanel = new Ext.form.DateField({
        xtype:'datefield',
        fieldLabel:'发货结束日期',
        anchor:'98%',
        name:'EndDate',
        id:'EndDate',
        format: 'Y年m月d日',  //添加中文样式
        value:new Date().clearTime()
    });
    
    var ArrivePostPanel = new Ext.form.TextField({
        style: 'margin-left:0px',
        cls: 'key',
        xtype: 'textfield',
        fieldLabel: '到站信息',
        anchor: '98%'
    });
    
    var ArriveShipPanel = new Ext.form.TextField({
        style: 'margin-left:0px',
        cls: 'key',
        xtype: 'textfield',
        fieldLabel: '车船号',
        anchor: '98%'
    });
    
    var ArriveCompanyPanel = new Ext.form.TextField({
        style: 'margin-left:0px',
        cls: 'key',
        xtype: 'textfield',
        fieldLabel: '子公司名称',
        anchor: '98%'
    });
    
    var ArriveProdutTypePanel = new Ext.form.TextField({
        style: 'margin-left:0px',
        cls: 'key',
        xtype: 'textfield',
        fieldLabel: '盐种名称',
        anchor: '98%'
    });
    
    var ArriveSupplierPanel = new Ext.form.TextField({
        style: 'margin-left:0px',
        cls: 'key',
        xtype: 'textfield',
        fieldLabel: '供应商名称',
        anchor: '98%'
    });

    var serchform = new Ext.FormPanel({
        renderTo: 'searchForm',
        title:'查询条件',
        labelAlign: 'left',
        buttonAlign: 'right',
        bodyStyle: 'padding:1px',
        frame: true,
        titleCollapse:true,
        //collapsed: true,
        collapsible:true,
        labelWidth: 80,
        items: [{
            layout: 'column',   //定义该元素为布局为列布局方式
            border: false,
            items: [{
                columnWidth: .25,  //该列占用的宽度，标识为20％
                layout: 'form',
                border: false,
                items: [
                    provideStartPanel
                ]
            }, {
                columnWidth: .25,
                layout: 'form',
                border: false,
                items: [
                    provideEndPanel
                    ]
            }, {
                columnWidth: .25,
                layout: 'form',
                border: false,
                labelWidth: 55,
                items: [
                    ArrivePostPanel
                ]
            }, {
                columnWidth: .23,
                layout: 'form',
                border: false,
                labelWidth: 50,
                items: [
                    ArriveShipPanel
                ]
            }]
        },{
            layout: 'column',   //定义该元素为布局为列布局方式
            border: false,
            items: [{
                columnWidth: .25,  //该列占用的宽度，标识为20％
                layout: 'form',
                border: false,
                labelWidth: 80,
                items: [
                    ArriveCompanyPanel
                ]
            }, {
                columnWidth: .25,
                layout: 'form',
                border: false,
                labelWidth: 80,
                items: [
                    ArriveSupplierPanel
                    ]
            }, {
                columnWidth: .25,
                layout: 'form',
                border: false,
                labelWidth: 55,
                items: [
                    ArriveProdutTypePanel
                ]
            }, {
                columnWidth: .23,
                layout: 'form',
                border: false,
                items: [{ cls: 'key',
                    xtype: 'button',
                    text: '查询',
                    anchor: '50%',
                    handler :function(){
                        retriveData();
                    }
                }]
            }]
        }]
    });
    function retriveData()
    {        
        var starttime=provideStartPanel.getValue();
        var endtime=provideEndPanel.getValue();
        var postinfo=ArrivePostPanel.getValue();
        var shipno = ArriveShipPanel.getValue();
        var sppliername= ArriveSupplierPanel.getValue();
        var productname= ArriveProdutTypePanel.getValue();
        var companyname= ArriveCompanyPanel.getValue();
        
        dsprovideGridData.baseParams.StartSendDate=Ext.util.Format.date(starttime,'Y/m/d');
        dsprovideGridData.baseParams.EndSendDate=Ext.util.Format.date(endtime,'Y/m/d');
        dsprovideGridData.baseParams.InstorInfo=postinfo;
        dsprovideGridData.baseParams.ShipNo=shipno;
        dsprovideGridData.baseParams.SupplierName=sppliername;
        dsprovideGridData.baseParams.ProductName=productname;
        dsprovideGridData.baseParams.CompanyName=companyname;
        
        dsprovideGridData.load({
                    params : {
                    start : 0,
                    limit : 10
                    } });
    }
    var cmbDoneMonthList=new Ext.data.SimpleStore({
    fields:['DicsCode','DicsName'],
    data:[['01','1月'],['02','2月'],['03','3月'],['04','4月'],['05','5月'],['06','6月'],['07','7月'],['08','8月'],['09','9月'],['10','10月'],['11','11月'],['12','12月']],
    autoLoad: false}); 
    //定义产品下拉框异步调用方法
    var dsProducts;
    if (dsProducts == null) {
        dsProducts = new Ext.data.Store({
            url: 'frmProvideSendYx.aspx?method=getSppierProducts',
            reader: new Ext.data.JsonReader({
                root: 'root',
                totalProperty: 'totalProperty'
            }, [
                    { name: 'ProductId', mapping: 'ProductId' },
                    { name: 'ProductNo', mapping: 'ProductNo' },
                    { name: 'ProductName', mapping: 'ProductName' },
                    { name: 'Unit', mapping: 'Unit' },
                    { name: 'UnitText', mapping: 'UnitText' },
                    { name: 'TaxRate', mapping: 'TaxRate' },
                    { name: 'SalePrice', mapping: 'SalePrice' },
                    { name: 'SpecificationsText', mapping: 'SpecificationsText' }
                ])
        });
    }
    // 定义下拉框异步返回显示模板
    var resultTpl = new Ext.XTemplate(
    '<tpl for="."><div id="searchdivid" class="search-item">',
        '<h3><span>{ProductName}&nbsp;&nbsp;<font color=blue>{ProductNo}</font>&nbsp;&nbsp;{SpecificationsText}</span></h3>',
    '</div></tpl>'
     );
    //定义下拉框异步调用方法,当前客户可订商品列表
    var dsProductUnits = new Ext.data.Store({   
        url: 'frmProvideSendYx.aspx?method=getProductUnits',  
        params: {
            ProductId:0
        },
        reader: new Ext.data.JsonReader({  
            root: 'root',  
            totalProperty: 'totalProperty',  
            id: 'ProductUnits'  
        }, [  
            {name: 'UnitId', mapping: 'UnitId'}, 
            {name: 'UnitName', mapping: 'UnitName'}, 
            {name: 'ToWeight', mapping: 'ToWeight'}
        ]) 
    });    
    var provideForm = new Ext.form.FormPanel({
	    frame:true,
	    title:'详细信息',
	    renderTo:'operateForm',
	    region:'north',
        titleCollapse:true,
        //collapsed: true,
        collapsible:true,
	    height:210,
	    labelWidth: 80,
	    items:[
	    {
	        layout:'column',
	        items:[
		    {
		        layout:'form',
		        columnWidth:0.25,
	            labelWidth: 65,
		        items:[
		        {
			        xtype:'hidden',
			        fieldLabel:'供应商发货单标识',
			        anchor:'90%',
			        name:'SendId',
			        id:'SendId',
			        value:0,
			        hidden:true,
			        hideLabel:true
		        },{
			        xtype:'hidden',
			        fieldLabel:'Status',
			        anchor:'90%',
			        name:'Status',
			        id:'Status',
			        value:0,
			        hidden:true,
			        hideLabel:true
		        },
		        {
		            xtype:'combo',
			        fieldLabel:'供应商名称',
			        anchor:'98%',
			        name:'SupplierId',
			        id:'SupplierId',
			        store:dsSupplier,
			        triggerAction:'all',
			        mode:'local',
			        displayField:'ShortName',
			        valueField:'CustomerId',
			        listeners:{
			            "select": function(record) {
			                Ext.getCmp('ProductId').setRawValue('') 
                            Ext.getCmp('ProductId').setValue('') 
                            dsProducts.load({
                                params:{
                                    SuppierId:Ext.getCmp('SupplierId').getValue()                         
                                }
                            });                 
                        } 
                    }
			     }]
		    }
            ,{
                layout:'form',
		        columnWidth:0.25,
	            labelWidth: 55,
		        items:[
		        {
			        xtype:'datefield',
			        fieldLabel:'发货日期',
			        anchor:'98%',
			        name:'SendDate',
			        id:'SendDate',
			        format:'Y年m月d日',
			        value:new Date().clearTime()
			    }]
	        },{
                layout:'form',
                columnWidth:0.162,
	            labelWidth: 65,
                items:[
                {
                    xtype: 'combo',
                    fieldLabel:'完成计划*',
                    anchor: '98%',
                    name: 'DoneYear',
                    id: 'DoneYear',
                    editable: false,
                    triggerAction: 'all',
                    mode: 'local',
                    store:cmbDoneYearList,
                    displayField: 'DicsName',
                    valueField: 'DicsCode',
                    value:new Date().getFullYear()
                }]
	        },
             {
                layout:'form',
                columnWidth:0.06,
                items:[
                {
                    xtype: 'combo',
                    anchor: '95%',
                    name: 'DoneMonth',
                    id: 'DoneMonth',
                    editable: false,
                    triggerAction: 'all',
                    mode: 'local',
                    store:new Ext.data.SimpleStore(),
                    displayField: 'DicsName',
                    valueField: 'DicsCode',
                    hideLabel: true,
                    value:new Date().getMonth()+1
                }]
	        },{
                layout:'form',
                items:[
                {
                    xtype:'datefield',
		            fieldLabel:'完成计划*',
		            anchor:'98%',
		            name:'PlanPeriod',
		            id:'PlanPeriod',
		            format: 'Y年m月',
                    hidden: true,
                    hideLabel: true,
                    value:new Date().clearTime()
                }]
	        }
            ,{
                layout:'form',
		        columnWidth:0.25,
	            labelWidth: 65,
		        items:[
		        {
			        xtype:'textfield',
			        fieldLabel:'发票号',
			        anchor:'98%',
			        name:'Voucher',
			        id:'Voucher'
			    }]
	        }]
	    }   
        ,{
            layout:'column',
            items:[ 
            {
                layout:'form',
                columnWidth:0.25,
	            labelWidth: 65,
                items:[
                {
                    xtype: 'combo',
                    fieldLabel:'发运方式',
                    anchor: '98%',
                    name: 'TransType',
                    id: 'TransType',
                    editable: false,
                    store:dsTransType,
			        triggerAction:'all',
			        displayField:'DicsName',
			        valueField:'DicsCode',
			        mode:'local',
			        value:'A401',
			        listeners:{
			            "select": function(opp) {
                            //filter arrivepos
			                dsDestination.clearFilter(); 
			                var CompanyId=Ext.getCmp('CompanyId').getValue();
			                dsDestination.filterBy(function(vec) {   
                                return (vec.get('SendType') == opp.getValue()&&vec.get('OrgId') ==CompanyId);   
                            });     
                            if(dsDestination.getCount()>0){
                                Ext.getCmp('DestInfo').setValue(dsDestination.getAt(0).data.DestInfo);
                            }else{
                                Ext.getCmp('DestInfo').setRawValue('') 
                                Ext.getCmp('DestInfo').setValue('') 
                            }         
                        } 
                    }			        
                }]
	        },           
	        {
	            layout:'form',
	            columnWidth:0.25,
	            labelWidth: 55,
		        items:[
                {
			        xtype:'textfield',
			        fieldLabel:'车船号',
			        anchor:'98%',
			        name:'ShipNo',
			        id:'ShipNo'
		        }]
		    }
            ,{
                layout:'form',
		        columnWidth:0.22,
	            labelWidth: 65,
		        items:[
		        {
			        xtype:'textfield',
			        fieldLabel:'准运证号',
			        anchor:'98%',
			        name:'NavicertNo',
			        id:'NavicertNo'
			    }]
	        }
	        ,{
	            layout:'form',
	            columnWidth:0.25,
	            labelWidth: 65,
		        items:[
                {
			        xtype:'textfield',
			        fieldLabel:'随货同行单',
			        anchor:'98%',
			        name:'TransportNo',
			        id:'TransportNo'
			    }]
		    }]
        }
        ,{
            layout:'column',
            items:[            
	        {
	            layout:'form',
	            columnWidth:0.25,
	            labelWidth: 65,
		        items:[
                {
                    xtype: 'combo',
                    fieldLabel:'商品名称',
                    anchor: '98%',
                    name: 'ProductId',
                    id: 'ProductId',
			        store: dsProducts,
                    displayField: 'ProductName',
                    valueField: 'ProductId',
                    triggerAction: 'all',
                    typeAhead: false,
                    mode: 'local',
                    emptyText: '',
                    tpl: resultTpl,  
                    itemSelector: 'div.search-item', 
                    listWidth:320,
                    selectOnFocus: false,
                    editable: true,
                    listeners:{
                        beforequery:function(qe){  
                            regexValue(qe);
                        },
                        select:function(opp){
                            //获取单位采购价格，计算金额
                            dsProductUnits.baseParams.ProductId = opp.getValue();
                            dsProductUnits.load({
                                callback:function(){
                                    //采购价格
                                    var index = dsProducts.findBy(function(vec, id) { 
		                                 return vec.get('ProductId')==opp.getValue(); 
                                    });
                                    if(index == -1)
                                        Ext.getCmp('PurchasePrice').setValue(0);
                                    else
                                    {
                                        Ext.getCmp('PurchasePrice').setValue(dsProducts.getAt(index).data.SalePrice);
                                        Ext.getCmp('ProductUnit').setValue(dsProducts.getAt(index).data.Unit);
                                    }     
                                    //计算采购金额
                                    Ext.getCmp('PurchaseAmt').setValue(Ext.getCmp('PurchasePrice').getValue().mul(Ext.getCmp('Qty').getValue()).toFixed(2));                               
                                    if(Ext.getCmp('CompanyId').getValue()>0){
                                    //获取结算价
                                    Ext.Ajax.request({
                                        url: 'frmTransitDistribute.aspx?method=getSettlePrice',
                                        params: {
                                            ProductId: Ext.getCmp('ProductId').getValue(),
                                            OrgId: Ext.getCmp('CompanyId').getValue(),
                                            UnitId:Ext.getCmp('ProductUnit').getValue()
                                        },
                                        success: function(resp, opts) {
                                            var dataPrice = Ext.util.JSON.decode(resp.responseText);
                                            if(dataPrice.sucess=="true"){
                                                Ext.getCmp('SalePrice').setValue(dataPrice.price);
                                                if(dataPrice.price< Ext.getCmp('PurchasePrice').getValue())
                                                    Ext.Msg.alert("提示", "要货单位的结算价格小于采购价格！");
                                                //计算结算金额
                                                Ext.getCmp('SaleAmt').setValue(Ext.getCmp('Qty').getValue().mul(dataPrice.price).toFixed(2));
                                            }
                                            else
                                                Ext.Msg.alert("提示", "要货单位的结算价格未配置！");
                                        },
                                        failure: function(resp, opts) {
                                            Ext.Msg.alert("提示", "获取结算价信息失败！");
                                        }
                                    });  
                                } 
                                }
                            });
                            if(Ext.getCmp('CompanyId').getValue()>0){
                                if(dsDestination.getCount()>0){
                                    Ext.getCmp('DestInfo').setValue(dsDestination.getAt(0).data.DestInfo);
                                }else{
                                    Ext.getCmp('DestInfo').setRawValue('') 
                                    Ext.getCmp('DestInfo').setValue('') 
                                }   
                            }                            
                        }
                    }
		        }]
		    },
		    {
	            layout:'form',
	            columnWidth:0.18,
	            labelWidth: 55,
		        items:[
                {
			        xtype:'numberfield',
			        fieldLabel:'采购数量',
			        anchor:'98%',
			        name:'Qty',
			        id:'Qty',
			        value:0,
			        listeners:{
			            'change':function(opp){
			                //计算采购金额
			                if(Ext.getCmp('Qty').getValue()>0){
			                    if(Ext.getCmp('PurchasePrice').getValue()>0)
                                    Ext.getCmp('PurchaseAmt').setValue(Ext.getCmp('PurchasePrice').getValue().mul(Ext.getCmp('Qty').getValue()).toFixed(2));
                                else
                                    Ext.getCmp('PurchaseAmt').setValue(0);
                                if(Ext.getCmp('SalePrice').getValue()>0)
                                    Ext.getCmp('SaleAmt').setValue(Ext.getCmp('SalePrice').getValue().mul(Ext.getCmp('Qty').getValue()).toFixed(2));
                                else
                                    Ext.getCmp('SaleAmt').setValue(0);
                            }
			            }
			        }
		        }]
		    },{
                layout:'form',
                columnWidth:0.072,
                items:[
                {
                    xtype: 'combo',
                    fieldLabel:'单位',
                    hideLabel:true,
                    anchor: '85%',
                    name: 'ProductUnit',
                    id: 'ProductUnit',
                    editable: false,
                    triggerAction: 'all',
                    mode: 'local',
                    store:dsProductUnits,
                    displayField: 'UnitName',
                    valueField: 'UnitId',
                    value:''
                }]
	        },
	        {
	            layout:'form',
	            columnWidth:0.22,
	            labelWidth: 65,
		        items:[
                {
			        xtype:'numberfield',
			        fieldLabel:'采购价格',
			        anchor:'98%',
			        name:'PurchasePrice',
			        id:'PurchasePrice',
			        listeners:{
			            'change':function(opp){
			                //计算采购金额
                            Ext.getCmp('PurchaseAmt').setValue(opp.getValue().mul(Ext.getCmp('Qty').getValue()).toFixed(2));                               
                        }     
                    }   
		        }]
		    },
		    {
	            layout:'form',
	            columnWidth:0.25,
	            labelWidth: 65,
		        items:[
                {
			        xtype:'numberfield',
			        fieldLabel:'采购总金额',
			        anchor:'98%',
			        name:'PurchaseAmt',
			        id:'PurchaseAmt'
		        }]
		    }
	        ]
	    }
        ,{
            layout:'column',
            items:[            
	        {
	            layout:'form',
	            columnWidth:0.25,
	            labelWidth: 65,
		        items:[
                {
			        xtype:'combo',
			        fieldLabel:'子公司名称',
			        anchor:'98%',
			        name:'CompanyId',
			        id:'CompanyId',
			        store:dsOrg,
			        triggerAction:'all',
			        mode:'local',
			        displayField:'OrgShortName',
			        valueField:'OrgId',
			        listeners:{
			            "select": function(opp) {
                            //得到到站信息，销售价格   
                            //filter arrivepos
			                dsDestination.clearFilter(); 
			                var transType=Ext.getCmp('TransType').getValue();
			                dsDestination.filterBy(function(vec) {   
                                return (vec.get('OrgId') == opp.getValue()&&vec.get('SendType') ==transType);   
                            });  
                            if(Ext.getCmp('TransType').getValue()!=''){
                                if(dsDestination.getCount()>0){
                                    Ext.getCmp('DestInfo').setValue(dsDestination.getAt(0).data.DestInfo);
                                }else{
                                    Ext.getCmp('DestInfo').setRawValue('') 
                                    Ext.getCmp('DestInfo').setValue('') 
                                }   
                            }
                            if(Ext.getCmp('ProductId').getValue()>0){
                                //获取结算价
                                Ext.Ajax.request({
                                    url: 'frmTransitDistribute.aspx?method=getSettlePrice',
                                    params: {
                                        ProductId: Ext.getCmp('ProductId').getValue(),
                                        OrgId: opp.getValue(),
                                        UnitId:Ext.getCmp('ProductUnit').getValue()
                                    },
                                    success: function(resp, opts) {
                                        var dataPrice = Ext.util.JSON.decode(resp.responseText);
                                        if(dataPrice.sucess=="true"){
                                            Ext.getCmp('SalePrice').setValue(dataPrice.price);
                                            if(dataPrice.price< Ext.getCmp('PurchasePrice').getValue())
                                                Ext.Msg.alert("提示", "要货单位的结算价格小于采购价格！");
                                            //计算结算金额
                                            Ext.getCmp('SaleAmt').setValue(Ext.getCmp('Qty').getValue().mul(dataPrice.price).toFixed(2));
                                        }
                                        else
                                            Ext.Msg.alert("提示", "要货单位的结算价格未配置！");
                                    },
                                    failure: function(resp, opts) {
                                        Ext.Msg.alert("提示", "获取结算价信息失败！");
                                    }
                                });  
                            }                                      
                        } 
                    }
                }]
		    },
		    {
	            layout:'form',
	            columnWidth:0.25,
	            labelWidth: 55,
		        items:[
                {
			        xtype:'combo',
			        fieldLabel:'到站信息',
			        anchor:'98%',
			        id:'DestInfo',
			        name:'DestInfo',
			        store:dsDestination,
			        editable:true,
			        triggerAction:'all',
			        valueField:'DestInfo',
			        displayField:'DestInfo',
			        mode:'local',
			        lastQuery:'',
			        listeners:{
			            beforequery:function(qe){  
                            regexValue(qe);
                        }
			        }
		        }]
		    },
		    {
	            layout:'form',
	            columnWidth:0.22,
	            labelWidth: 65,
		        items:[
                {
			        xtype:'numberfield',
			        fieldLabel:'销售价格',
			        anchor:'98%',
			        name:'SalePrice',
			        id:'SalePrice',
			        listeners:{
			            'change':function(opp){
			                //计算采购金额
                            Ext.getCmp('SaleAmt').setValue(Ext.getCmp('Qty').getValue().mul(opp.getValue()).toFixed(2));
                        }     
                    }   
		        }]
		    },
		    {
	            layout:'form',
	            columnWidth:0.25,
	            labelWidth: 65,
		        items:[
                {
			        xtype:'numberfield',
			        fieldLabel:'销售总金额',
			        anchor:'98%',
			        name:'SaleAmt',
			        id:'SaleAmt'
		        }]
		    }
	        ]
	    }
	    ,{
	        layout:'column',
            items:[
	        {
                layout:'form',
	            columnWidth:1,
	            labelWidth: 65,
		        items:[
                {
			        xtype:'textarea',
			        fieldLabel:'备注',
			        anchor:'98%',
			        name:'Remark',
			        id:'Remark',
			        height: 30
			    }]
		    }]
	    }],
        buttonAlign: 'center',
        bodyStyle: 'padding:1px',
	    buttons: [{
            text: "新增",
            scope: this,
            id: 'addButton',
            handler: function() {
                saveMstData('add');
            }
        },{
            text: "更新",
            scope: this,
            id: 'saveButton',
            handler: function() {
                saveMstData('update');
            }
        },{
            text: "删除",
            scope: this,
            id: 'delButton',
            handler: function() {
                deleteMst()
            }
        },{
            text: "提交",
            scope: this,
            id: 'submitButton',
            handler: function() {
                submitMst();
            }
        },{
            text: "开票确认",
            scope: this,
            id: 'confirmButton',
            handler: function() {
                confirmMst();
            }
        }]
    });
    var cmbDoneMonth = Ext.getCmp("DoneMonth");
    if (cmbDoneMonth.store == null)
        cmbDoneMonth.store = new Ext.data.SimpleStore();
    cmbDoneMonth.store.removeAll();
    cmbDoneMonth.store.add(cmbDoneMonthList.getRange());
    cmbDoneMonth.setValue(new Date().getMonth()+1);
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
    Ext.getCmp('SupplierId').on('beforequery',function(qe){  
        regexValue(qe);
    });  
    
    /*------开始获取数据的函数 start---------------*/
    var dsprovideGridData = new Ext.data.Store
    ({
    url: 'frmProvideSendYx.aspx?method=getProvideSendList',
    reader:new Ext.data.JsonReader({
	    totalProperty:'totalProperty',
	    root:'root'
    },[
	    {		name:'SendId'	},
	    {		name:'OrgId'	},
	    {       name:'OrgName'  },
	    {		name:'SupplierId'	},
	    {		name:'SupplierName'	},
	    {		name:'SendDate'	},
	    {		name:'PurchaseOrg'	},
	    {		name:'PurchaseOrgName'	},
	    {		name:'ProductId'	},
	    {		name:'ProductName'	},
	    {		name:'InvoiceQty'	},
	    {		name:'PlanPeriod'	},
	    {		name:'ShipNo'	},
	    {		name:'NavicertNo'	},
	    {		name:'Voucher'	},
	    {		name:'TransportNo'	},
	    {		name:'TransType'	},
	    {		name:'PurchasePrice'	},
	    {		name:'Price'	},
	    {		name:'IsSettle'	},
	    {		name:'OpOrg'	},
	    {		name:'OpOrgName'	},
	    {		name:'OperName'	},
	    {		name:'DtlCount'	},
	    {		name:'DestInfo'	},
	    {		name:'OperId'	},
	    {		name:'UnitId'	},
	    {		name:'UnitName'	},
	    {		name:'CreateDate'	},
	    {		name:'SettleDate'	},
	    {		name:'OwnerId'	},
	    {		name:'Status'	},
	    {		name:'Remark'	},
	    {		name:'IsActive'	}	
	    ])
	    ,
	    listeners:
	    {
		    scope:this,
		    load:function(){
		    }
	    }
    });
    var sm= new Ext.grid.CheckboxSelectionModel({
	    singleSelect:true
    });
    var provideGridData = new Ext.grid.GridPanel({
	    el: 'datadetailGrid',
        width:document.body.offsetWidth-20,
	    title:'结果列表',
        height: '100%',
	    //autoWidth:true,
	    //autoHeight:true,
	    autoScroll:true,
	    layout: 'fit',
	    id: '',
	    store: dsprovideGridData,
	    loadMask: {msg:'正在加载数据，请稍侯……'},
	    sm:sm,
	    cm: new Ext.grid.ColumnModel([
		    sm,
		    new Ext.grid.RowNumberer(),//自动行号
		    {
			    header:'子公司',
			    dataIndex:'PurchaseOrgName',
			    id:'PurchaseOrgName',
			    width:70
		    },
		    {
			    header:'商品名称',
			    dataIndex:'ProductName',
			    id:'ProductName',
			    width:150
		    },
    		{
    			header:'车船号',
    			dataIndex:'ShipNo',
    			id:'ShipNo',
			    width:80
    		},
    		{
    			header:'到站',
    			dataIndex:'DestInfo',
    			id:'DestInfo',
			    width:65
    		},
		    {
			    header:'供货单位',
			    dataIndex:'SupplierName',
			    id:'SupplierName',
			    width:80
		    },
		    {
			    header:'状态',
			    dataIndex:'Status',
			    id:'Status',
			    width:65,
			    renderer:{fn:function(value, cellmeta, record, rowIndex, columnIndex, store){
		           var index = dsStatus.findBy(function(record, id) {  // dsPayType 为数据源
				     return record.get('DicsCode')==value; //'DicsCode' 为数据源的id列
			       });
                   var record = dsStatus.getAt(index);
                   return record.data.DicsName;  // DicsName为数据源的name列
		        }}
		    },
		    {
			    header:'数量',
			    dataIndex:'InvoiceQty',
			    id:'InvoiceQty',
			    width:55,
			    renderer:{fn:function(value, cellmeta, record, rowIndex, columnIndex, store){
                   var unitname = record.get('UnitName');
                   return value+' '+unitname;  // DicsName为数据源的name列
		        }}
		    },
		    {
			    header:'发货日期',
			    dataIndex:'SendDate',
			    id:'SendDate',
			    renderer: Ext.util.Format.dateRenderer('Y年m月d日'),
			    width:105
		    },
		    {
			    header:'随货同行单号',
			    dataIndex:'TransportNo',
			    id:'TransportNo',
			    hidden:true
		    },
		    {
			    header:'准运证号',
			    dataIndex:'NavicertNo',
			    id:'NavicertNo',
			    width:60
		    },
		    {
			    header:'操作单位',
			    dataIndex:'OpOrgName',
			    id:'OpOrgName',
			    width:60
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
			    width:105
		    }		
		]),
		bbar: new Ext.PagingToolbar({
			pageSize: 10,
			store: dsprovideGridData,
			displayMsg: '显示第{0}条到{1}条记录,共{2}条',
			emptyMsy: '没有记录',
			displayInfo: true
		}),
		viewConfig: {
			columnsText: '显示的列',
			scrollOffset: 20,
			sortAscText: '升序',
			sortDescText: '降序',
			forceFit: false,
            getRowClass: function(r, i, p, s) {
                if (r.data.OpOrg == 1) {
                    return "x-grid-canop";
                }
            }
		},
		//enableHdMenu: false,  //不显示排序字段和显示的列下拉框
		//enableColumnMove: false,//列不能移动
		height: 325,
		closeAction: 'hide',
		stripeRows: true,
		loadMask: true
	});
    provideGridData.render();
    provideGridData.on('rowdblclick', function(grid, rowIndex, e) {
        //edit
        var data = dsprovideGridData.getAt(rowIndex).data;
        if (!data) return;
        if (data.OpOrg != 1) return;
        Ext.getCmp("SendId").setValue(data.SendId);
		Ext.getCmp("SupplierId").setValue(data.SupplierId);
		dsProducts.load({
            params:{
                SuppierId:Ext.getCmp('SupplierId').getValue()                         
            },
            callback:function(){
               Ext.getCmp("ProductId").setValue(data.ProductId); 
            }
        });
        dsProductUnits.baseParams.ProductId = data.ProductId;
        dsProductUnits.load({
            callback:function(){
		        Ext.getCmp("ProductUnit").setValue(data.UnitId);                
            }
        });
		Ext.getCmp("SendDate").setValue((new Date(data.SendDate.replace(/-/g,"/"))));
		Ext.getCmp("Voucher").setValue(data.Voucher);
		Ext.getCmp("TransportNo").setValue(data.TransportNo);
		Ext.getCmp("NavicertNo").setValue(data.NavicertNo);
		Ext.getCmp("ShipNo").setValue(data.ShipNo);
		Ext.getCmp("TransType").setValue(data.TransType);
		Ext.getCmp("CompanyId").setValue(data.PurchaseOrg);
		//filter arrivepos
        dsDestination.clearFilter(); 
        var CompanyId = data.PurchaseOrg;
        dsDestination.filterBy(function(vec) {   
            return (vec.get('SendType') == data.TransType && vec.get('OrgId') == CompanyId);   
        });     
        if(dsDestination.getCount()>0){            
		    Ext.getCmp("DestInfo").setValue(data.DestInfo);
        }    
		Ext.getCmp("Qty").setValue(data.InvoiceQty);		
		Ext.getCmp("SalePrice").setValue(data.Price);
		Ext.getCmp("PurchasePrice").setValue(data.PurchasePrice);
		Ext.getCmp('SaleAmt').setValue(Ext.getCmp('Qty').getValue().mul(data.Price).toFixed(2));
		Ext.getCmp('PurchaseAmt').setValue(Ext.getCmp('Qty').getValue().mul(data.PurchasePrice).toFixed(2));
		Ext.getCmp("Remark").setValue(data.Remark);
		Ext.getCmp("PlanPeriod").setValue(new Date(parseInt(data.PlanPeriod.substr(0,4)),parseInt(data.PlanPeriod.substr(4,2))-1));
		Ext.getCmp('DoneYear').setValue(data.PlanPeriod.substr(0,4));
        Ext.getCmp('DoneMonth').setValue(data.PlanPeriod.substr(4,2));
        Ext.getCmp("Status").setValue(data.Status);
    });
    ///
    /*删除信息*/
    function deleteMst()
    {
	    var sm = provideGridData.getSelectionModel();
	    //获取选择的数据信息
	    var selectData =  sm.getSelected();
	    //如果没有选择，就提示需要选择数据信息
	    if(selectData == null){
		    Ext.Msg.alert("提示","请选中需要删除的信息！");
		    return;
	    }
    	
	    if(selectData.data.Status >= 'S254'){
	        Ext.Msg.alert("提示","已分解确认记录，不能删除！");
		    return;
	    }
    	
	    //删除前再次提醒是否真的要删除
	    Ext.Msg.confirm("提示信息","是否真的要删除选择的信息吗？",function callBack(id){
		    //判断是否删除数据
		    if(id=="yes")
		    {
		        Ext.Msg.wait("处理中....","提示");
			    //页面提交
			    Ext.Ajax.request({
				    url:'frmProvideSendYx.aspx?method=deleteProvideSend',
				    method:'POST',
				    params:{
					    SendId:selectData.data.SendId
				    },
				    success: function(resp,opts){
				        Ext.Msg.hide();
				        if(checkExtMessage(resp)){
					        retriveData();
					    }
				    },
				    failure: function(resp,opts){
				        Ext.Msg.hide();
					    Ext.Msg.alert("提示","数据删除失败！");
				    }
			    });
		    }
	    });
    }
    ///
    function submitMst()
    {
        var sm = provideGridData.getSelectionModel();
	    //获取选择的数据信息
	    var selectData =  sm.getSelected();
	    //如果没有选择，就提示需要选择数据信息
	    if(selectData == null){
		    Ext.Msg.alert("提示","请选中需要提交的信息！");
		    return;
	    }
    	
	    if(selectData.data.Status != 'S253'){
	        Ext.Msg.alert("提示","数据非初始状态，不能确认提交！");
		    return;
	    }
    	
	    //提交前再次提醒是否真的要提交
	    Ext.Msg.confirm("提示信息","是否真的要提交选择的信息吗？",function callBack(id){
		    //判断是否提交数据
		    if(id=="yes")
		    {
		        Ext.MessageBox.wait("正在处理，请稍候……", "系统提示");
	            Ext.Ajax.request({
		            url:'frmProvideSendYx.aspx?method=submitProvideSend',
		            method:'POST',
		            params:{
			            SendId:selectData.data.SendId
			        },
		            success: function(resp,opts){
		                Ext.MessageBox.hide();
		                if(checkExtMessage(resp))
		                {
		                    retriveData();
			            }
		            },
		            failure: function(resp,opts){
		                Ext.MessageBox.hide();
			            Ext.Msg.alert("提示","提交失败！");
		            }
	            });
		    }
	    });
	}
	/////
	function saveUserData()
    {
        var productId = Ext.getCmp('ProductId').getValue();
        if(productId <= 0){
            Ext.Msg.alert("提示","商品信息必须选择，请修改！");
            return;
        }
        var transType = Ext.getCmp('TransType').getValue();
        if(transType == null||transType ==""){
            Ext.Msg.alert("提示","发运方式必须选择，请修改！");
            return;
        }
        var shipNo = Ext.getCmp('ShipNo').getValue();
        if(shipNo ==null||shipNo ==""){
            Ext.Msg.alert("提示","车船号必须填写，请修改！");
            return;
        }
        var destInfo = Ext.getCmp('DestInfo').getValue();
        if(destInfo ==null||destInfo ==""){
            Ext.Msg.alert("提示","到站信息必须选择，请修改！");
            return;
        }        
        if(Ext.getCmp('DoneYear').getValue()+Ext.getCmp('DoneMonth').getValue()=="")
        {
            Ext.Msg.alert("提示","请输入完成计划月份！");
            return;
        }        
        var purchasePrice = Ext.getCmp('PurchasePrice').getValue();
        if(purchasePrice<= 0 ||purchasePrice ==""){
            Ext.Msg.alert("提示","采购价格必须填写，请修改！");
            return;
        }
        var salePrice = Ext.getCmp('SalePrice').getValue();
        if(salePrice <= 0||salePrice ==""){
            Ext.Msg.alert("提示","销售价格必须填写，请修改！");
            return;
        }                
        //alert(json);
        Ext.MessageBox.wait("正在处理，请稍候……", "系统提示");
	    Ext.Ajax.request({
		    url:'frmProvideSendYx.aspx?method=saveProvideSend',
		    method:'POST',
		    params:{
			    SendId:Ext.getCmp('SendId').getValue(),
			    SupplierId:Ext.getCmp('SupplierId').getValue(),
			    SendDate:Ext.util.Format.date(Ext.getCmp('SendDate').getValue(),'Y/m/d'),
			    Voucher:Ext.getCmp('Voucher').getValue(),
			    TransportNo:Ext.getCmp('TransportNo').getValue(),
			    NavicertNo:Ext.getCmp('NavicertNo').getValue(),
			    Qty:Ext.getCmp('Qty').getValue(),
			    Remark:Ext.getCmp('Remark').getValue(),
			    PlanPeriod:Ext.util.Format.date(Ext.getCmp('PlanPeriod').getValue(),'Ym'), 
                DoneYear: Ext.getCmp('DoneYear').getValue(),
                DoneMonth: Ext.getCmp('DoneMonth').getValue(),
			    ProductId:	Ext.getCmp('ProductId').getValue(),	
			    UnitId:	Ext.getCmp('ProductUnit').getValue(),		
			    TransType:	Ext.getCmp('TransType').getValue(),	
			    ShipNo:	Ext.getCmp('ShipNo').getValue(),	
			    PurchasePrice:	Ext.getCmp('PurchasePrice').getValue(),	
			    SalePrice:	Ext.getCmp('SalePrice').getValue(),		
			    PurchaseOrg:	Ext.getCmp('CompanyId').getValue(),	
			    DestInfo:	Ext.getCmp('DestInfo').getValue()
			    },
		    success: function(resp,opts){
		        Ext.MessageBox.hide();
		        if(checkExtMessage(resp))
		        {
		            retriveData();
			    }
		    },
		    failure: function(resp,opts){
		        Ext.MessageBox.hide();
			    Ext.Msg.alert("提示","保存失败");
		    }
	    });
	}
	function saveMstData(saveType) {    
	    var sendId = Ext.getCmp('SendId').getValue();
	    if(saveType == 'update'){
	        var status = Ext.getCmp('Status').getValue();
	        if(status >= 'S254'){
	            Ext.Msg.alert("提示","数据非初始状态，不能修改！");
		        return;
	        }
	        if(sendId <=0) {
	            Ext.Msg.alert("提示","新增记录，请点击“新增”进行保存！");
		        return;
	        }
	        saveUserData();
	    }else if(saveType == 'add'){
	        if(sendId > 0){
	            Ext.Msg.confirm("提示信息","该发运单是在原单上复制修改的信息，是否真的采用修改的信息进行新增？",function callBack(id){
		            if(id!="yes")           
		                return;
		            Ext.getCmp('SendId').setValue(0)
		            saveUserData();
		        });
	        }else{
	            saveUserData();
	        }
	    }    	
    }
    function confirmMst(){
        var sm = provideGridData.getSelectionModel();
	    //获取选择的数据信息
	    var selectData =  sm.getSelected();
	    //如果没有选择，就提示需要选择数据信息
	    if(selectData == null){
		    Ext.Msg.alert("提示","请选中需要确认的信息！");
		    return;
	    }
    	
	    if(selectData.data.Status != 'S256'){
	        Ext.Msg.alert("提示","数据未确认或没全部确认，不能确认开票！");
		    return;
	    }
    	
	    //提交前再次提醒是否真的要提交
	    Ext.Msg.confirm("提示信息","是否真的要确认选择的信息吗？",function callBack(id){
		    //判断是否提交数据
		    if(id=="yes")
		    {
		        Ext.MessageBox.wait("正在处理，请稍候……", "系统提示");
	            Ext.Ajax.request({
		            url:'frmProvideSendYx.aspx?method=confirmProvideSend',
		            method:'POST',
		            params:{
			            SendId:Ext.getCmp('SendId').getValue()
			        },
		            success: function(resp,opts){
		                Ext.MessageBox.hide();
		                if(checkExtMessage(resp))
		                {
		                    retriveData();
			            }
		            },
		            failure: function(resp,opts){
		                Ext.MessageBox.hide();
			            Ext.Msg.alert("提示","确认失败！");
		            }
	            });
		    }
	    });
    }
});
</script>
</body>
</html>
