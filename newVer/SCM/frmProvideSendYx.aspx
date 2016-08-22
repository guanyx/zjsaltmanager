<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmProvideSendYx.aspx.cs" Inherits="SCM_frmProvideSendYx" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>���˵�(ʡ��˾��¼)</title>
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
     //��ʼ����
    var provideStartPanel = new Ext.form.DateField({
        xtype:'datefield',
        fieldLabel:'������ʼ����',
        anchor:'98%',
        name:'StartDate',
        id:'StartDate',
        format: 'Y��m��d��',  //���������ʽ
        value:new Date().clearTime() 
    });

    //��������
    var provideEndPanel = new Ext.form.DateField({
        xtype:'datefield',
        fieldLabel:'������������',
        anchor:'98%',
        name:'EndDate',
        id:'EndDate',
        format: 'Y��m��d��',  //���������ʽ
        value:new Date().clearTime()
    });
    
    var ArrivePostPanel = new Ext.form.TextField({
        style: 'margin-left:0px',
        cls: 'key',
        xtype: 'textfield',
        fieldLabel: '��վ��Ϣ',
        anchor: '98%'
    });
    
    var ArriveShipPanel = new Ext.form.TextField({
        style: 'margin-left:0px',
        cls: 'key',
        xtype: 'textfield',
        fieldLabel: '������',
        anchor: '98%'
    });
    
    var ArriveCompanyPanel = new Ext.form.TextField({
        style: 'margin-left:0px',
        cls: 'key',
        xtype: 'textfield',
        fieldLabel: '�ӹ�˾����',
        anchor: '98%'
    });
    
    var ArriveProdutTypePanel = new Ext.form.TextField({
        style: 'margin-left:0px',
        cls: 'key',
        xtype: 'textfield',
        fieldLabel: '��������',
        anchor: '98%'
    });
    
    var ArriveSupplierPanel = new Ext.form.TextField({
        style: 'margin-left:0px',
        cls: 'key',
        xtype: 'textfield',
        fieldLabel: '��Ӧ������',
        anchor: '98%'
    });

    var serchform = new Ext.FormPanel({
        renderTo: 'searchForm',
        title:'��ѯ����',
        labelAlign: 'left',
        buttonAlign: 'right',
        bodyStyle: 'padding:1px',
        frame: true,
        titleCollapse:true,
        //collapsed: true,
        collapsible:true,
        labelWidth: 80,
        items: [{
            layout: 'column',   //�����Ԫ��Ϊ����Ϊ�в��ַ�ʽ
            border: false,
            items: [{
                columnWidth: .25,  //����ռ�õĿ�ȣ���ʶΪ20��
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
            layout: 'column',   //�����Ԫ��Ϊ����Ϊ�в��ַ�ʽ
            border: false,
            items: [{
                columnWidth: .25,  //����ռ�õĿ�ȣ���ʶΪ20��
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
                    text: '��ѯ',
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
    data:[['01','1��'],['02','2��'],['03','3��'],['04','4��'],['05','5��'],['06','6��'],['07','7��'],['08','8��'],['09','9��'],['10','10��'],['11','11��'],['12','12��']],
    autoLoad: false}); 
    //�����Ʒ�������첽���÷���
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
    // �����������첽������ʾģ��
    var resultTpl = new Ext.XTemplate(
    '<tpl for="."><div id="searchdivid" class="search-item">',
        '<h3><span>{ProductName}&nbsp;&nbsp;<font color=blue>{ProductNo}</font>&nbsp;&nbsp;{SpecificationsText}</span></h3>',
    '</div></tpl>'
     );
    //�����������첽���÷���,��ǰ�ͻ��ɶ���Ʒ�б�
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
	    title:'��ϸ��Ϣ',
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
			        fieldLabel:'��Ӧ�̷�������ʶ',
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
			        fieldLabel:'��Ӧ������',
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
			        fieldLabel:'��������',
			        anchor:'98%',
			        name:'SendDate',
			        id:'SendDate',
			        format:'Y��m��d��',
			        value:new Date().clearTime()
			    }]
	        },{
                layout:'form',
                columnWidth:0.162,
	            labelWidth: 65,
                items:[
                {
                    xtype: 'combo',
                    fieldLabel:'��ɼƻ�*',
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
		            fieldLabel:'��ɼƻ�*',
		            anchor:'98%',
		            name:'PlanPeriod',
		            id:'PlanPeriod',
		            format: 'Y��m��',
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
			        fieldLabel:'��Ʊ��',
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
                    fieldLabel:'���˷�ʽ',
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
			        fieldLabel:'������',
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
			        fieldLabel:'׼��֤��',
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
			        fieldLabel:'���ͬ�е�',
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
                    fieldLabel:'��Ʒ����',
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
                            //��ȡ��λ�ɹ��۸񣬼�����
                            dsProductUnits.baseParams.ProductId = opp.getValue();
                            dsProductUnits.load({
                                callback:function(){
                                    //�ɹ��۸�
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
                                    //����ɹ����
                                    Ext.getCmp('PurchaseAmt').setValue(Ext.getCmp('PurchasePrice').getValue().mul(Ext.getCmp('Qty').getValue()).toFixed(2));                               
                                    if(Ext.getCmp('CompanyId').getValue()>0){
                                    //��ȡ�����
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
                                                    Ext.Msg.alert("��ʾ", "Ҫ����λ�Ľ���۸�С�ڲɹ��۸�");
                                                //���������
                                                Ext.getCmp('SaleAmt').setValue(Ext.getCmp('Qty').getValue().mul(dataPrice.price).toFixed(2));
                                            }
                                            else
                                                Ext.Msg.alert("��ʾ", "Ҫ����λ�Ľ���۸�δ���ã�");
                                        },
                                        failure: function(resp, opts) {
                                            Ext.Msg.alert("��ʾ", "��ȡ�������Ϣʧ�ܣ�");
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
			        fieldLabel:'�ɹ�����',
			        anchor:'98%',
			        name:'Qty',
			        id:'Qty',
			        value:0,
			        listeners:{
			            'change':function(opp){
			                //����ɹ����
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
                    fieldLabel:'��λ',
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
			        fieldLabel:'�ɹ��۸�',
			        anchor:'98%',
			        name:'PurchasePrice',
			        id:'PurchasePrice',
			        listeners:{
			            'change':function(opp){
			                //����ɹ����
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
			        fieldLabel:'�ɹ��ܽ��',
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
			        fieldLabel:'�ӹ�˾����',
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
                            //�õ���վ��Ϣ�����ۼ۸�   
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
                                //��ȡ�����
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
                                                Ext.Msg.alert("��ʾ", "Ҫ����λ�Ľ���۸�С�ڲɹ��۸�");
                                            //���������
                                            Ext.getCmp('SaleAmt').setValue(Ext.getCmp('Qty').getValue().mul(dataPrice.price).toFixed(2));
                                        }
                                        else
                                            Ext.Msg.alert("��ʾ", "Ҫ����λ�Ľ���۸�δ���ã�");
                                    },
                                    failure: function(resp, opts) {
                                        Ext.Msg.alert("��ʾ", "��ȡ�������Ϣʧ�ܣ�");
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
			        fieldLabel:'��վ��Ϣ',
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
			        fieldLabel:'���ۼ۸�',
			        anchor:'98%',
			        name:'SalePrice',
			        id:'SalePrice',
			        listeners:{
			            'change':function(opp){
			                //����ɹ����
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
			        fieldLabel:'�����ܽ��',
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
			        fieldLabel:'��ע',
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
            text: "����",
            scope: this,
            id: 'addButton',
            handler: function() {
                saveMstData('add');
            }
        },{
            text: "����",
            scope: this,
            id: 'saveButton',
            handler: function() {
                saveMstData('update');
            }
        },{
            text: "ɾ��",
            scope: this,
            id: 'delButton',
            handler: function() {
                deleteMst()
            }
        },{
            text: "�ύ",
            scope: this,
            id: 'submitButton',
            handler: function() {
                submitMst();
            }
        },{
            text: "��Ʊȷ��",
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
    Ext.getCmp('SupplierId').on('beforequery',function(qe){  
        regexValue(qe);
    });  
    
    /*------��ʼ��ȡ���ݵĺ��� start---------------*/
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
	    title:'����б�',
        height: '100%',
	    //autoWidth:true,
	    //autoHeight:true,
	    autoScroll:true,
	    layout: 'fit',
	    id: '',
	    store: dsprovideGridData,
	    loadMask: {msg:'���ڼ������ݣ����Ժ��'},
	    sm:sm,
	    cm: new Ext.grid.ColumnModel([
		    sm,
		    new Ext.grid.RowNumberer(),//�Զ��к�
		    {
			    header:'�ӹ�˾',
			    dataIndex:'PurchaseOrgName',
			    id:'PurchaseOrgName',
			    width:70
		    },
		    {
			    header:'��Ʒ����',
			    dataIndex:'ProductName',
			    id:'ProductName',
			    width:150
		    },
    		{
    			header:'������',
    			dataIndex:'ShipNo',
    			id:'ShipNo',
			    width:80
    		},
    		{
    			header:'��վ',
    			dataIndex:'DestInfo',
    			id:'DestInfo',
			    width:65
    		},
		    {
			    header:'������λ',
			    dataIndex:'SupplierName',
			    id:'SupplierName',
			    width:80
		    },
		    {
			    header:'״̬',
			    dataIndex:'Status',
			    id:'Status',
			    width:65,
			    renderer:{fn:function(value, cellmeta, record, rowIndex, columnIndex, store){
		           var index = dsStatus.findBy(function(record, id) {  // dsPayType Ϊ����Դ
				     return record.get('DicsCode')==value; //'DicsCode' Ϊ����Դ��id��
			       });
                   var record = dsStatus.getAt(index);
                   return record.data.DicsName;  // DicsNameΪ����Դ��name��
		        }}
		    },
		    {
			    header:'����',
			    dataIndex:'InvoiceQty',
			    id:'InvoiceQty',
			    width:55,
			    renderer:{fn:function(value, cellmeta, record, rowIndex, columnIndex, store){
                   var unitname = record.get('UnitName');
                   return value+' '+unitname;  // DicsNameΪ����Դ��name��
		        }}
		    },
		    {
			    header:'��������',
			    dataIndex:'SendDate',
			    id:'SendDate',
			    renderer: Ext.util.Format.dateRenderer('Y��m��d��'),
			    width:105
		    },
		    {
			    header:'���ͬ�е���',
			    dataIndex:'TransportNo',
			    id:'TransportNo',
			    hidden:true
		    },
		    {
			    header:'׼��֤��',
			    dataIndex:'NavicertNo',
			    id:'NavicertNo',
			    width:60
		    },
		    {
			    header:'������λ',
			    dataIndex:'OpOrgName',
			    id:'OpOrgName',
			    width:60
		    },
		    {
			    header:'����Ա',
			    dataIndex:'OperName',
			    id:'OperName',
			    width:50
		    },
		    {
			    header:'����ʱ��',
			    dataIndex:'CreateDate',
			    id:'CreateDate',
			    renderer: Ext.util.Format.dateRenderer('Y��m��d��'),
			    width:105
		    }		
		]),
		bbar: new Ext.PagingToolbar({
			pageSize: 10,
			store: dsprovideGridData,
			displayMsg: '��ʾ��{0}����{1}����¼,��{2}��',
			emptyMsy: 'û�м�¼',
			displayInfo: true
		}),
		viewConfig: {
			columnsText: '��ʾ����',
			scrollOffset: 20,
			sortAscText: '����',
			sortDescText: '����',
			forceFit: false,
            getRowClass: function(r, i, p, s) {
                if (r.data.OpOrg == 1) {
                    return "x-grid-canop";
                }
            }
		},
		//enableHdMenu: false,  //����ʾ�����ֶκ���ʾ����������
		//enableColumnMove: false,//�в����ƶ�
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
    /*ɾ����Ϣ*/
    function deleteMst()
    {
	    var sm = provideGridData.getSelectionModel();
	    //��ȡѡ���������Ϣ
	    var selectData =  sm.getSelected();
	    //���û��ѡ�񣬾���ʾ��Ҫѡ��������Ϣ
	    if(selectData == null){
		    Ext.Msg.alert("��ʾ","��ѡ����Ҫɾ������Ϣ��");
		    return;
	    }
    	
	    if(selectData.data.Status >= 'S254'){
	        Ext.Msg.alert("��ʾ","�ѷֽ�ȷ�ϼ�¼������ɾ����");
		    return;
	    }
    	
	    //ɾ��ǰ�ٴ������Ƿ����Ҫɾ��
	    Ext.Msg.confirm("��ʾ��Ϣ","�Ƿ����Ҫɾ��ѡ�����Ϣ��",function callBack(id){
		    //�ж��Ƿ�ɾ������
		    if(id=="yes")
		    {
		        Ext.Msg.wait("������....","��ʾ");
			    //ҳ���ύ
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
					    Ext.Msg.alert("��ʾ","����ɾ��ʧ�ܣ�");
				    }
			    });
		    }
	    });
    }
    ///
    function submitMst()
    {
        var sm = provideGridData.getSelectionModel();
	    //��ȡѡ���������Ϣ
	    var selectData =  sm.getSelected();
	    //���û��ѡ�񣬾���ʾ��Ҫѡ��������Ϣ
	    if(selectData == null){
		    Ext.Msg.alert("��ʾ","��ѡ����Ҫ�ύ����Ϣ��");
		    return;
	    }
    	
	    if(selectData.data.Status != 'S253'){
	        Ext.Msg.alert("��ʾ","���ݷǳ�ʼ״̬������ȷ���ύ��");
		    return;
	    }
    	
	    //�ύǰ�ٴ������Ƿ����Ҫ�ύ
	    Ext.Msg.confirm("��ʾ��Ϣ","�Ƿ����Ҫ�ύѡ�����Ϣ��",function callBack(id){
		    //�ж��Ƿ��ύ����
		    if(id=="yes")
		    {
		        Ext.MessageBox.wait("���ڴ������Ժ򡭡�", "ϵͳ��ʾ");
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
			            Ext.Msg.alert("��ʾ","�ύʧ�ܣ�");
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
            Ext.Msg.alert("��ʾ","��Ʒ��Ϣ����ѡ�����޸ģ�");
            return;
        }
        var transType = Ext.getCmp('TransType').getValue();
        if(transType == null||transType ==""){
            Ext.Msg.alert("��ʾ","���˷�ʽ����ѡ�����޸ģ�");
            return;
        }
        var shipNo = Ext.getCmp('ShipNo').getValue();
        if(shipNo ==null||shipNo ==""){
            Ext.Msg.alert("��ʾ","�����ű�����д�����޸ģ�");
            return;
        }
        var destInfo = Ext.getCmp('DestInfo').getValue();
        if(destInfo ==null||destInfo ==""){
            Ext.Msg.alert("��ʾ","��վ��Ϣ����ѡ�����޸ģ�");
            return;
        }        
        if(Ext.getCmp('DoneYear').getValue()+Ext.getCmp('DoneMonth').getValue()=="")
        {
            Ext.Msg.alert("��ʾ","��������ɼƻ��·ݣ�");
            return;
        }        
        var purchasePrice = Ext.getCmp('PurchasePrice').getValue();
        if(purchasePrice<= 0 ||purchasePrice ==""){
            Ext.Msg.alert("��ʾ","�ɹ��۸������д�����޸ģ�");
            return;
        }
        var salePrice = Ext.getCmp('SalePrice').getValue();
        if(salePrice <= 0||salePrice ==""){
            Ext.Msg.alert("��ʾ","���ۼ۸������д�����޸ģ�");
            return;
        }                
        //alert(json);
        Ext.MessageBox.wait("���ڴ������Ժ򡭡�", "ϵͳ��ʾ");
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
			    Ext.Msg.alert("��ʾ","����ʧ��");
		    }
	    });
	}
	function saveMstData(saveType) {    
	    var sendId = Ext.getCmp('SendId').getValue();
	    if(saveType == 'update'){
	        var status = Ext.getCmp('Status').getValue();
	        if(status >= 'S254'){
	            Ext.Msg.alert("��ʾ","���ݷǳ�ʼ״̬�������޸ģ�");
		        return;
	        }
	        if(sendId <=0) {
	            Ext.Msg.alert("��ʾ","������¼�����������������б��棡");
		        return;
	        }
	        saveUserData();
	    }else if(saveType == 'add'){
	        if(sendId > 0){
	            Ext.Msg.confirm("��ʾ��Ϣ","�÷��˵�����ԭ���ϸ����޸ĵ���Ϣ���Ƿ���Ĳ����޸ĵ���Ϣ����������",function callBack(id){
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
	    //��ȡѡ���������Ϣ
	    var selectData =  sm.getSelected();
	    //���û��ѡ�񣬾���ʾ��Ҫѡ��������Ϣ
	    if(selectData == null){
		    Ext.Msg.alert("��ʾ","��ѡ����Ҫȷ�ϵ���Ϣ��");
		    return;
	    }
    	
	    if(selectData.data.Status != 'S256'){
	        Ext.Msg.alert("��ʾ","����δȷ�ϻ�ûȫ��ȷ�ϣ�����ȷ�Ͽ�Ʊ��");
		    return;
	    }
    	
	    //�ύǰ�ٴ������Ƿ����Ҫ�ύ
	    Ext.Msg.confirm("��ʾ��Ϣ","�Ƿ����Ҫȷ��ѡ�����Ϣ��",function callBack(id){
		    //�ж��Ƿ��ύ����
		    if(id=="yes")
		    {
		        Ext.MessageBox.wait("���ڴ������Ժ򡭡�", "ϵͳ��ʾ");
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
			            Ext.Msg.alert("��ʾ","ȷ��ʧ�ܣ�");
		            }
	            });
		    }
	    });
    }
});
</script>
</body>
</html>
