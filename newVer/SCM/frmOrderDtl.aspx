<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmOrderDtl.aspx.cs" Inherits="SCM_frmOrderDtl" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html>
<head>
<title>����ά��</title><meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<link rel="stylesheet" type="text/css" href="../ext3/resources/css/ext-all.css" />
<link rel="stylesheet" type="text/css" href="../Theme/1/css/salt.css" />
<script type="text/javascript" src="../ext3/adapter/ext/ext-base.js"></script>
<script type="text/javascript" src="../ext3/ext-all.js"></script>
<script type="text/javascript" src="../ext3/example/ItemDeleter.js"></script>
<script type="text/javascript" src="../js/operateResp.js"></script>
<script type="text/javascript" src="../ext3/src/locale/ext-lang-zh_CN.js"></script>
<style type="text/css">
.extensive-remove {
background-image: url(../Theme/1/images/extjs/customer/cross.gif) ! important;
}
.x-grid-back-blue { 
background: #B7CBE8; 
}
.x-grid3-row-alt {
background-color:#CFE8FF
}
</style>
</head>
<body>
<div id='divForm'></div>
<div id='divGrid'></div>
<div id='divBotton'></div>
</body>
<%= getComboBoxStore() %>
<script type="text/javascript">

/*------��ʼ�������ݵĺ��� Start---------------*/
     var dsDeliverAdd;//�ͻ��ص�
     if (dsDeliverAdd == null) { //��ֹ�ظ�����
        dsDeliverAdd = new Ext.data.JsonStore({
            totalProperty: "result",
            root: "root",
            url: 'frmOrderDtl.aspx?method=getCustomerAddList',
            fields: ['AttributeValue']
        })
     };
    function setFormValue() {
        Ext.getCmp("OrderId").setValue(OrderId);
        //��������
        if(OrderId==0)
        {
            Ext.getCmp("cusno").getEl().dom.readOnly=false;
            Ext.getCmp("DlvDate").setValue( (new Date()).clearTime() );
            Ext.getCmp("PayType").setValue('S021');
            Ext.getCmp("BillMode").setValue("S031");
            Ext.getCmp("DlvType").setValue("S041");
            Ext.getCmp("DlvLevel").setValue("S051");
            Ext.getCmp("IsPayed").setValue(0);
            Ext.getCmp("IsBill").setValue(0);
            Ext.getCmp("SaleInvId").setValue(0);
            Ext.getCmp("Status").setValue(1);
            Ext.getCmp("IsActive").setValue(1);
            Ext.getCmp("CreateDate").setValue((new Date()).clearTime());
            
            Ext.getCmp("DlvAdd").setValue("");
            Ext.getCmp("Remark").setValue("");
            Ext.getCmp("DlvDesc").setValue("");
            
            Ext.getCmp("CustomerId").setValue("");
            Ext.getCmp("cusno").setValue("");;
            Ext.getCmp("cusname").setValue("");
            Ext.getCmp("mobile").setValue("");
            Ext.getCmp("person").setValue("");
            Ext.getCmp("cusadd").setValue("");
            
            if(dsProductList!=null)
            {
                dsOrderProduct.removeAll();
                var orderProduct = new dsOrderProduct.recordType({SaleQty:0});
                dsOrderProduct.add(orderProduct);
            }
            return;
        }
        Ext.Ajax.request({
            url: 'frmOrderMst.aspx?method=getOrder',
            params: {
                orderid: OrderId,
                limit:1,
                start:0
            },
            success: function(resp, opts) {           
                var data = Ext.util.JSON.decode(resp.responseText);
                Ext.getCmp("OrgId").setValue(data.OrgId);
                Ext.getCmp("SaleDept").setValue(data.DeptId);
                Ext.getCmp("OutStor").setValue(data.OutStor);
                Ext.getCmp("CustomerId").setValue(data.CustomerId);
                Ext.getCmp("cusno").setValue(data.CustomerNo);
                Ext.getCmp("cusname").setValue(data.CustomerName);
                Ext.getCmp("mobile").setValue(data.LinkTel);
                Ext.getCmp("person").setValue(data.LinkMan);
                Ext.getCmp("cusadd").setValue(data.Address);
                Ext.getCmp("DlvDate").setValue(new Date(data.DlvDate.replace(/-/g, "/")));
                Ext.getCmp("DlvAdd").setValue(data.DlvAdd);
//		                Ext.getCmp("OrderType").setValue(data.OrderType);
                Ext.getCmp("PayType").setValue(data.PayType);
                Ext.getCmp("BillMode").setValue(data.BillMode);
                Ext.getCmp("DlvType").setValue(data.DlvType);
                Ext.getCmp("DlvLevel").setValue(data.DlvLevel);
                Ext.getCmp("OrderTotalAmt").setValue(data.SaleTotalAmt);
                Ext.getCmp("IsPayed").setValue(data.IsPayed);
                Ext.getCmp("IsBill").setValue(data.IsBill);
                Ext.getCmp("Remark").setValue(data.Remark);		  
                Ext.getCmp("DlvDesc").setValue(data.DlvDesc);	  
                Ext.getCmp("CreateDate").setValue((new Date(data.CreateDate.replace(/-/g, "/"))));
                Ext.getCmp("Status").setValue(data.Status);
                Ext.getCmp("SaleInvId").setValue(data.SaleInvId);
                Ext.getCmp("OutedQty").setValue(data.OutedQty);
                Ext.getCmp("IsActive").setValue(data.IsActive);
                Ext.getCmp("TransOrg").setValue(data.TransOrg);
                Ext.getCmp("SaleOrg").setValue(data.SaleOrg);
                if(data.Ext1=="0")
                {
                    Ext.getCmp("DriverId").setValue("");
                }
                else
                {
                    Ext.getCmp("DriverId").setValue(data.Ext1);
                }
                
                Ext.getCmp("cusno").getEl().dom.readOnly=true;
                if(dsProductList!=null)
                {
                    //��Ʒ�б�
                    dsProductList.baseParams.CustomerId = data.CustomerId;
                    dsProductList.load();                    
                }
                
                if(dsProductList!=null)
                {
                    dsOrderProduct.load({
                        params: { 
                            start: 0,
                            limit: 100,
                            OrderId: OrderId
                        },
                        callback: function(r, options, success) {
                            if (success == true) {
                                var orderProduct1 = new dsOrderProduct.recordType({SaleQty:'0',SalePrice:'0'});
                                dsOrderProduct.add(orderProduct1);
                                //userGrid.getSelectionModel().selectFirstRow(); 
                                //userGrid.getView().getRow(0).focus();
                                }
                            }                                
                        });
                }
                
                //��ַ��Ϣ
                dsDeliverAdd.baseParams.CustomerId = data.CustomerId;
                dsDeliverAdd.load();
            },
            failure: function(resp, opts) {
                Ext.Msg.alert("��ʾ", "��ȡ��ʼ���ֿ���Ϣʧ�ܣ�");
            }
        });
    }
    /*------��ʼ�������ݵĺ��� End---------------*/
    
Ext.BLANK_IMAGE_URL = "../ext3/resources/images/default/s.gif";
    function GetUrlParms() {
        var args = new Object();
        var query = location.search.substring(1); //��ȡ��ѯ��   
        var pairs = query.split("&"); //�ڶ��Ŵ��Ͽ�   
        for (var i = 0; i < pairs.length; i++) {
            var pos = pairs[i].indexOf('='); //����name=value   
            if (pos == -1) continue; //���û���ҵ�������   
            var argname = pairs[i].substring(0, pos); //��ȡname   
            var value = pairs[i].substring(pos + 1); //��ȡvalue   
            args[argname] = unescape(value); //��Ϊ����   
        }
        return args;
    }
    var dsProductList=null;
    var dsOrderProduct = null;
    var args = new Object();
    args = GetUrlParms();
    //���Ҫ���Ҳ���key:
    var OrderId = args["id"];
    var OperType = args["OpenType"];
    var OperAction = args["Action"];



    Ext.onReady(function() {  
    
        Ext.form.TextField.prototype.afterRender = Ext.form.TextField.prototype.afterRender.createSequence(function() {
         this.relayEvents(this.el, ['onblur']);
        });
        
    var dsWareHouse; //������
    if (dsWareHouse == null) { //��ֹ�ظ�����
        dsWareHouse = new Ext.data.JsonStore({
            totalProperty: "result",
            root: "root",
            url: 'frmOrderDtl.aspx?method=getWareHouse',
            fields: ['WhId', 'WhName']
        })
     };    
       
    function initCustomerInfo( record){     
        Ext.getCmp("CustomerId").setValue(record.data.CustomerId);
        Ext.getCmp("cusno").setValue(record.data.CustomerNo);
        Ext.getCmp("cusname").setValue(record.data.ShortName);
        Ext.getCmp("cusadd").setValue(record.data.Address);
        Ext.getCmp("mobile").setValue(record.data.LinkTel);
        Ext.getCmp("person").setValue(record.data.LinkMan); 
        Ext.getCmp("DlvAdd").setValue(record.data.DeliverAdd);
        if(record.data.InvoiceType!=''&&record.data.InvoiceType.indexOf('S')>-1)
            Ext.getCmp("BillMode").setValue(record.data.InvoiceType);
        if(record.data.SettlementWay!='')
            Ext.getCmp("PayType").setValue(record.data.SettlementWay);
        dsProductList.baseParams.CustomerId=record.data.CustomerId;
        dsProductList.load();  
        //��ַ��Ϣ
        dsDeliverAdd.baseParams.CustomerId = record.data.CustomerId;
        dsDeliverAdd.load();     
    }
    
    var initOrderForm = new Ext.form.FormPanel({
           renderTo: 'divForm',
           frame: true,
           monitorValid: true, // ����formBind:true�İ�ť����֤��
           labelWidth: 70,
           items:
           [
            {
                layout:'column',
                border: true,                                 
                items:
                [{
                   layout: 'form',
                   columnWidth: .95,  //����ռ�õĿ�ȣ���ʶΪ20��
                   border: false,
                   items: [{
                            style: 'margin-left:0px',
                            cls: 'key',
                            xtype: 'textfield',
                            fieldLabel: '�ͻ����',
                            name: 'cusno',
                            id:'cusno',
                            anchor: '100%'
                          }]
                 },
                 {
                   layout: 'form',
                   columnWidth: .05,  //����ռ�õĿ�ȣ���ʶΪ20��
                   border: false,
                   items: [{
                            xtype:'button', 
                            iconCls:"find",
                            autoWidth : true,
                            autoHeight : true,
                            id:'customFind',
                            hideLabel:true,
                            listeners:{
                                click:function(v){
                                   getCustomerInfo(initCustomerInfo,Ext.getCmp('SaleOrg').getValue());                                    
                                   //getProductInfo(function(record){ });
                                }
                            }
                          }]
                 }]
            } ,
            {
                layout:'column',
                border: false,
                items:
                [{
                   layout: 'form',
                   columnWidth: .33,  //����ռ�õĿ�ȣ���ʶΪ20��
                   border: false,
                   items: [{
                       cls: 'key',
                       xtype: 'textfield',
                       readOnly:true,
                       fieldLabel: '�ͻ�����',
                       name: 'cusname',
                       id: 'cusname',
                       anchor: '98%'
                           }]
                  },
                  {
                   layout: 'form',
                   columnWidth: .33,  //����ռ�õĿ�ȣ���ʶΪ20��
                   border: false,
                   items: [{
                       cls: 'key',
                       xtype: 'textfield',
                       readOnly:true,
                       fieldLabel: '��ϵ�绰',
                       name: 'mobile',
                       id: 'mobile',
                       anchor: '98%'
                          }]
                  } ,
                  {
                   layout: 'form',
                   columnWidth: .33,  //����ռ�õĿ�ȣ���ʶΪ20��
                   border: false,
                   items: [{
                       cls: 'key',
                       xtype: 'textfield',
                       readOnly:true,
                       fieldLabel: '������',
                       name: 'person',
                       id: 'person',
                       anchor: '98%'
                          }]
                 }]
            },
            {
                layout:'column',
                border: false,
                items:
                [{
                   layout: 'form',
                   columnWidth: .66,  //����ռ�õĿ�ȣ���ʶΪ20��
                   border: false,
                   items: [{
                       cls: 'key',
                       xtype: 'textfield',
                       readOnly:true,
                       fieldLabel: '�ͻ���ַ',
                       name: 'cusadd',
                       id: 'cusadd',
                       anchor: '98%'
                          }]
                 },{
		            layout: 'form',
                    border: false,
                    columnWidth: .33,
                    items: [{
                        xtype: 'combo',
                        fieldLabel: '������',
                        anchor: '95%',
                        id: 'DriverId',
                        name: 'DriverId',
                        store: dsDriver,
                        triggerAction: 'all',
                        mode: 'local',
                        displayField: 'DriverName',
                        valueField: 'DriverId',
                        editable: false
                    }]
                }]
             },
            {
                layout:'column',
                border: false,
                items:
                [{
                   layout: 'form',
                   columnWidth: 1,  //����ռ�õĿ�ȣ���ʶΪ20��
                   border: false,
                   items: [{
                       xtype: 'hidden',
                       fieldLabel: '�ͻ�ID',
                       name: 'CustomerId',
                       id: 'CustomerId',
                       anchor: '98%',
                       hidden:true,
                       hideLabel:true
                          }]
                 }]
             },
             {
		                layout:'column',
		                border: false,
		                labelSeparator: '��',
		                items: [
		                {
			                layout:'form',
			                border: false,
			                columnWidth: 1,
			                items: [{
		                            xtype:'hidden',
			                        fieldLabel:'������ʶ',
			                        columnWidth:1,
			                        anchor:'98%',
			                        name:'OrderId',
			                        id:'OrderId'
		                        }]
		                },{
			                layout:'form',
			                border: false,
			                columnWidth: 1,
			                items: [{
		                            xtype:'hidden',
			                        fieldLabel:'��֯��ʶ',
			                        columnWidth:1,
			                        anchor:'98%',
			                        name:'OrgId',
			                        id:'OrgId'
		                        }]
		                }
                ]},{
		                layout:'column',
		                border: false,
		                labelSeparator: '��',
		                items: [
		                {
			                layout:'form',
			                border: false,
			                columnWidth:0.33,
			                items: [
				                {
					                xtype:'combo',
                                    fieldLabel:'���۵�λ',
                                    anchor:'98%',
                                    name:'SaleOrgName',
                                    id:'SaleOrg',
                                    store: dsOrg,
                                    displayField: 'OrgName',  //����ֶκ�ҵ��ʵ�����ֶ�ͬ��
                                    valueField: 'OrgId',      //����ֶκ�ҵ��ʵ�����ֶ�ͬ��
                                    typeAhead: true, //�Զ�����һ����������ѡ�ȫ����
                                    triggerAction: 'all',
                                    emptyValue: '',
                                    selectOnFocus: true,
                                    forceSelection: true,
                                    mode:'local'    ,
                                    listeners: {
                                       select: function(combo, record, index) {
                                            var curOrgId = Ext.getCmp('SaleOrg').getValue();
                                            if(Ext.getCmp('OrgId').getValue() == curOrgId){
                                                dsWareHouse.load({
                                                    params: {
                                                        orgID: curOrgId
                                                    }
                                                });
                                            }
                                            dsCustomer.baseParams.OrgId=curOrgId;
                                        }
                                    }  
				                }
		                            ]
		                }		                
                ,		{
			                layout:'form',
			                border: false,
			                columnWidth:0.33,
			                items: [
				                {
					                xtype:'hidden',
					                hideLabel:true,
                                    fieldLabel:'���۲���',
                                    anchor:'98%',
                                    name:'SaleDept',
                                    id:'SaleDept'//,
//                                    store: dsDept,
//                                    displayField: 'DeptName',  //����ֶκ�ҵ��ʵ�����ֶ�ͬ��
//                                    valueField: 'DeptId',      //����ֶκ�ҵ��ʵ�����ֶ�ͬ��
//                                    typeAhead: true, //�Զ�����һ����������ѡ�ȫ����
//                                    triggerAction: 'all',
//                                    emptyValue: '',
//                                    selectOnFocus: true,
//                                    forceSelection: true,
//                                    mode:'local'    
				                },
				                {
					                xtype:'combo',
                                    fieldLabel:'���͵�λ',
                                    anchor:'98%',
                                    name:'TransOrg',
                                    id:'TransOrg',
                                    store: dsTransOrg,
                                    displayField: 'OrgName',  //����ֶκ�ҵ��ʵ�����ֶ�ͬ��
                                    valueField: 'OrgId',      //����ֶκ�ҵ��ʵ�����ֶ�ͬ��
                                    typeAhead: true, //�Զ�����һ����������ѡ�ȫ����
                                    triggerAction: 'all',
                                    emptyValue: '',
                                    selectOnFocus: true,
                                    forceSelection: true,
                                    mode:'local'    
				                }
		                ]
		                }
                ,		{
			                layout:'form',
			                border: false,
			                columnWidth:0.33,
			                items: [
				                {
					                 xtype: 'combo',
                                   store: dsWareHouse,//dsWareHouse,
                                   valueField: 'WhId',
                                   displayField: 'WhName',
                                   mode: 'local',
                                   forceSelection: true,
                                   editable: true,
                                   name:'OutStor',
                                   id:'OutStor',
                                   emptyValue: '',
                                   triggerAction: 'all',
                                   fieldLabel: '����ֿ�',
                                   selectOnFocus: true,
                                   anchor: '98%'
				                }
		                ]
		                }
	                ]},{
		                layout:'column',
		                border: false,
		                labelSeparator: '��',
		                items: [
		                {
			                layout:'form',
			                border: false,
			                columnWidth:0.33,
			                items: [
				                {
					                 xtype:'datefield',
			                        fieldLabel:'�ͻ�����',
			                        columnWidth:0.33,
			                        anchor:'98%',
			                        name:'DlvDate',
			                        id:'DlvDate',
			                        format:'Y��m��d��'
				                }
		                            ]
		                }		                
                ,		{
			                layout:'form',
			                border: false,
			                columnWidth:0.66,
			                items: [
				                {
					               xtype:'combo',
			                        fieldLabel:'�ͻ��ص�',
			                        anchor:'98%',
			                        name:'DlvAdd',
			                        id:'DlvAdd',
                                    mode:'local',
                                    store:dsDeliverAdd,
                                    valueField: 'AttributeValue',
                                    displayField: 'AttributeValue',
                                    mode:'local',
                                    
                                   triggerAction: 'all'                                
				                }
		                ]
		                }
                      ]},{
		                layout:'column',
		                border: false,
		                labelSeparator: '��',
		                items: [
		                {
			                layout:'form',
			                border: false,
			                columnWidth:0.66,
			                items: [
				                {
					               xtype:'textfield',
		                            fieldLabel:'�ͻ�����',
		                            columnWidth:1,
		                            anchor:'98%',
		                            name:'DlvDesc',
		                            id:'DlvDesc'
				                }
		                            ]
		                },
		                {
			                layout:'form',
			                border: false,
			                columnWidth:0.33,
			                items: [
				                {
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
                                   anchor: '98%'
				                }
		                            ]
		                }		 		               
	                ]},{
		                layout:'column',
		                border: false,
		                labelSeparator: '��',
		                items: [
		                {
			                layout:'form',
			                border: false,
			                columnWidth:0.33,
			                items: [
				                {
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
                                   anchor: '98%'
				                }
		                            ]
		                }		                
                ,		{
			                layout:'form',
			                border: false,
			                columnWidth:0.33,
			                items: [
				                {
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
                                   anchor: '98%'
				                }
		                ]
		                }
                ,		{
			                layout:'form',
			                border: false,
			                columnWidth:0.33,
			                items: [
				                {
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
                                   anchor: '98%',
                                   listeners:
	                               {
	                                select: function(combo, record, index) {
                                        if(combo.getValue()=='S042')
                                            Ext.getCmp('DriverId').setValue('');
                                        }
	                               }
				                }
		                ]
		                }
	                ]},{
		                layout:'column',
		                border: false,
		                labelSeparator: '��',
		                items: [		                               
                        {
			                layout:'form',
			                border: false,
			                columnWidth:0.33,
			                items: [
				                {
					                xtype:'hidden',
					                fieldLabel:'�Ƿ���',
					                columnWidth:0.33,
					                anchor:'98%',
					                store:[[1,'��'],[0,'��']],
					                name:'IsPayed',
					                id:'IsPayed'
				                }
		                ]
		                }
                ,		{
			                layout:'form',
			                border: false,
			                columnWidth:0.34,
			                items: [
				                {
					                xtype:'hidden',
					                fieldLabel:'�Ƿ�Ʊ',
					                columnWidth:0.33,
					                anchor:'98%',
					                store:[[1,'��'],[0,'��']],
					                name:'IsBill',
					                id:'IsBill'
				                }
		                ]
		                }
	                ]},{
		                layout:'column',
		                border: false,
		                labelSeparator: '��',
		                items: [
		                {
			                layout:'form',
			                border: false,
			                columnWidth:1,
			                items: [
				                {
					                xtype:'textarea',
			                        fieldLabel:'��ע',
			                        columnWidth:1,
			                        height:40,
			                        anchor:'98%',
			                        name:'Remark',
			                        id:'Remark'
				                }
		                            ]
		                }		                
                    ]}
                    ,{
		                layout:'column',
		                border: false,
		                labelSeparator: '��',
		                items: [
		                {
			                layout:'form',
			                border: false,
			                columnWidth:1,
			                items: [
				                {
					                xtype:'hidden',
			                        fieldLabel:'״̬',
			                        columnWidth:1,
			                        anchor:'98%',
			                        name:'Status',
			                        id:'Status'
			                        
				                }
		                            ]
		                }		                
                    ]}
                    ,{
		                layout:'column',
		                border: false,
		                labelSeparator: '��',
		                items: [
		                {
			                layout:'form',
			                border: false,
			                columnWidth:1,
			                items: [
				                {
					                xtype:'hidden',
			                        fieldLabel:'���۷�Ʊ��',
			                        columnWidth:1,
			                        anchor:'98%',
			                        name:'SaleInvId',
			                        id:'SaleInvId'
			                        
				                }
		                            ]
		                }		                
                    ]}
                    ,{
		                layout:'column',
		                border: false,
		                labelSeparator: '��',
		                items: [
		                {
			                layout:'form',
			                border: false,
			                columnWidth:1,
			                items: [
				                {
					                xtype:'hidden',
			                        fieldLabel:'�ѳ�������',
			                        columnWidth:1,
			                        anchor:'98%',
			                        name:'OutedQty',
			                        id:'OutedQty'
			                        
				                }
		                            ]
		                }		                
                    ]}
                     ,{
		                layout:'column',
		                border: false,
		                labelSeparator: '��',
		                items: [
		                {
			                layout:'form',
			                border: false,
			                columnWidth:1,
			                items: [
				                {
					                xtype:'hidden',
			                        fieldLabel:'��������',
			                        columnWidth:1,
			                        anchor:'98%',
			                        name:'CreateDate',
			                        id:'CreateDate',
			                        hidden:true,
			                        hideLabel:true
			                        
				                }
		                            ]
		                }		                
                    ]}
                    ,{
		                layout:'column',
		                border: false,
		                labelSeparator: '��',
		                items: [
		                {
			                layout:'form',
			                border: false,
			                columnWidth:1,
			                items: [
				                {
					                xtype:'hidden',
			                        fieldLabel:'�Ƿ���Ч',
			                        columnWidth:1,
			                        anchor:'98%',
			                        name:'IsActive',
			                        id:'IsActive'
			                        
				                }
		                            ]
		                }		                
                    ]} 
           ]
         })
        //���زֿ�
        dsWareHouse.load({callback:function(v){
            //if wh isnoney setit
            if(dsWareHouse.getCount()==1)
                Ext.getCmp('OutStor').setValue(dsWareHouse.getAt(0).get("WhId")); 
        }});
        //�����������첽���÷���
        var dsCustomer = new Ext.data.Store({   
            url: 'frmOrderDtl.aspx?method=getCusByConLike',  
            reader: new Ext.data.JsonReader({  
                root: 'root',  
                totalProperty: 'totalProperty',  
                id: 'cusno'  
            }, [  
                {name: 'CustomerId', mapping: 'CustomerId'}, 
                {name: 'CustomerNo', mapping: 'CustomerNo'},  
                {name: 'ShortName', mapping: 'ShortName'},
                {name: 'ChineseName', mapping: 'ChineseName'},
                {name: 'Address', mapping: 'Address'},
                {name: 'LinkMan', mapping: 'LinkMan'},  
                {name: 'LinkTel', mapping: 'LinkTel'}, 
                {name: 'DeliverAdd', mapping: 'DeliverAdd'},
                {name: 'Remark', mapping: 'Remark'},
                {name: 'IsOrthercust', mapping: 'IsOrthercust'},
                {name: 'InvoiceType', mapping: 'InvoiceType'},
                {name: 'SettlementWay', mapping: 'SettlementWay'},                
                {name: 'CustomizeInfo', mapping: 'CustomizeInfo'}
                
            ]) 
        });  
        // �����������첽������ʾģ��
        var resultTpl = new Ext.XTemplate(  
            '<tpl for="."><div id="searchdivid" class="search-item">',  
                '<h3><span>���:{CustomerNo}&nbsp;  ����:{ShortName}&nbsp;  ��ϵ��:{LinkMan}&nbsp;  ��·:{Remark}</span></h3>',
            '</div></tpl>'  
        ); 
           var customer = new Ext.form.ComboBox({
                   xtype: 'combo',
                   store: dsCustomer,
                   applyTo: 'cusno',
                   minChars:1,  
                   pageSize:10,  
                   tpl:resultTpl,
                   hideTrigger:true, 
                   itemSelector: 'div.search-item',  
                   anchor: '98%',
                   onSelect: function(record) {
                        initCustomerInfo(record);
                        this.collapse();//���������б�
                        if(record.data.IsOrthercust == 1)
                            Ext.Msg.alert("��ʾ", "�ÿͻ�Ϊ�޵��οͻ���");
                        if(record.data.CustomizeInfo != null && record.data.CustomizeInfo != "")
                            Ext.Msg.alert("��ʾ", record.data.CustomizeInfo);
                    }
               });
    

        //-------------------Grid Start-----------------------------
        function inserNewBlankRow() {
            var rowCount = userGrid.getStore().getCount();
            var insertPos = parseInt(rowCount);
            var addRow = new RowPattern({
                ProductId:'',
                ProductCode:'',
			    SaleQty:'0',
			    SalePrice:'0',
			    SaleAmt:'0',
			    SaleTax:'0',
			    DiscountRate:'0',
			    DiscountAmt:'0',
			    Tax:'0',
			    TransFee:'0',
			    ProductUse:''
            });
            userGrid.stopEditing();
            //����һ����
            if (insertPos > 0) {
                var rowIndex = dsOrderProduct.insert(insertPos, addRow);
                userGrid.startEditing(insertPos, 0);
            }
            else {
                var rowIndex = dsOrderProduct.insert(0, addRow);
                userGrid.startEditing(0, 0);
            }
        }
        function addNewBlankRow(combo, record, index) {
            var rowIndex = userGrid.getStore().indexOf(userGrid.getSelectionModel().getSelected());
            var rowCount = userGrid.getStore().getCount();
            if ((rowIndex == 0 && rowCount == 1) || rowIndex == rowCount - 1) {
                inserNewBlankRow();
            }
        }
        
        
        
        //�����������첽���÷���,��ǰ�ͻ��ɶ���Ʒ�б�
        dsProductList = new Ext.data.Store({   
            url: 'frmOrderDtl.aspx?method=getCustomProduct',  
            params: {
                //CustomerId: Ext.getCmp('CustomerId').getValue(),
                limit:1,
                start:0
            },
            reader: new Ext.data.JsonReader({  
                root: 'root',  
                totalProperty: 'totalProperty',  
                id: 'productlist'  
            }, [  
                {name: 'ProductId', mapping: 'ProductId'}, 
                {name: 'ProductName', mapping: 'ProductName'},  
                {name: 'ProductNo', mapping: 'ProductNo'},
                {name: 'Specifications', mapping: 'Specifications'},  
                {name: 'SpecificationsText', mapping: 'SpecificationsText'}, 
                {name: 'Unit', mapping: 'Unit'}, 
                {name: 'UnitText', mapping: 'UnitText'},
                {name: 'SalePrice', mapping: 'SalePrice'},
                {name: 'SalesTax', mapping: 'SalesTax'}
            ]) 
        }); 
        // �����������첽������ʾģ��
        var resultPrdTpl = new Ext.XTemplate(  
            '<tpl for="."><div id="productdivid" class="search-item">',  
                '<h3><span>{ProductName}&nbsp</h3>',
            '</div></tpl>'  
        ); 
        
        //�����������첽���÷���,��ǰ�ͻ��ɶ���Ʒ�б�
        var dsProductUnits = new Ext.data.Store({   
            url: 'frmOrderDtl.aspx?method=getProductUnits',  
            params: {
                ProductId:0
            },
            reader: new Ext.data.JsonReader({  
                root: 'root',  
                totalProperty: 'totalProperty',  
                id: 'ProductUnits'  
            }, [  
                {name: 'UnitId', mapping: 'UnitId'}, 
                {name: 'UnitName', mapping: 'UnitName'}
            ]) 
        });

        //������λ������
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
            editable: false,
            listeners: {
                "select": addNewBlankRow
            }
        });
        //���������
//        var productSpecCombo = new Ext.form.ComboBox({
//            store: dsProductSpecList,
//            displayField: 'DicsName',
//            valueField: 'DicsCode',
//            triggerAction: 'all',
//            id: 'productSpecCombo',
//            //pageSize: 5,  
//            //minChars: 2,  
//            //hideTrigger: true,  
//            typeAhead: true,
//            mode: 'local',
//            emptyText: '',
//            selectOnFocus: false,
//            editable: false,
//            listeners: {
//                "select": addNewBlankRow
//            }
//        });
        //��Ʒ������
        var productCombo = new Ext.form.ComboBox({
            store: dsProductList,
            displayField: 'ProductName',
            valueField: 'ProductId',
            triggerAction: 'all',
            id: 'productCombo1',
            //pageSize: 5,
            //minChars: 2,
            //tpl:resultPrdTpl,
            hideTrigger:true, 
            //itemSelector: 'div.search-item',  
            editable:false,
            typeAhead: true,
            mode: 'local',
            emptyText: '',
            selectOnFocus: false,
            //lastQuery:'',
            onSelect: function(record) {
                dsProductUnits.baseParams.ProductId = record.data.ProductId;
                dsProductUnits.load();
                var sm = userGrid.getSelectionModel().getSelected();
                sm.set('ProductCode', record.data.ProductNo);
                sm.set('Specifications', record.data.Specifications);
                sm.set('Unit', record.data.Unit);
                sm.set('ProductId', record.data.ProductId);
                sm.set('ProductName',record.data.ProductName);
                sm.set('SalePrice',record.data.SalePrice);
                sm.set('Tax',record.data.SalesTax); 
                sm.set('DiscountRate','0');
                sm.set('DiscountAmt','0');
                sm.set('TransFee','0');
                //sm.set('SalePrice',record.data.Price);
                productCombo.setValue(record.data.ProductId); 
                addNewBlankRow();
                
                this.collapse();//���������б�
            }
        });
        
        
        //�����Ʒ�������첽���÷���
            var dsProducts;
            if (dsProducts == null) {
                dsProducts = new Ext.data.Store({
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
            }   


        var productText = new Ext.form.TextField({
            name:"ProductNameTpl",
            id:"ProductNameTpl"});
        
        productText.on("focus",setProductFilter);
//        productText.on("blur",lostfocus);
//        function lostfocus()
//        {
//            alert("ok");
//        }
        var productFilterCombo=null;
        
        // �����������첽������ʾģ��
//        var resultTpl = new Ext.XTemplate(  
//            '<tpl for="."><div id="searchdivid" class="search-item">',  
//                '<h3><span>���:{ProductNo}&nbsp;  ����:{ProductName}</span></h3>',
//            '</div></tpl>'  
//        ); 
        var resultTpl = new Ext.XTemplate(  
            '<tpl for="."><div id="searchdivid" class="search-item">',  
                strTemplate,
            '</div></tpl>'  
        ); 
        
        function setProductFilter()
        {
            dsProducts.baseParams.WhId = Ext.getCmp('OutStor').getValue();
            dsProducts.baseParams.CustomerId=Ext.getCmp("CustomerId").getValue();
            if(productFilterCombo==null)
            {
                productFilterCombo = new Ext.form.ComboBox({
                store: dsProducts,
                displayField: 'ProductName',
                displayValue: 'ProductId',
                typeAhead: false,
                minChars: 1,
                width:400,
                loadingText: 'Searching...',
                tpl: resultTpl,  
                itemSelector: 'div.search-item',  
                pageSize: 10,
                hideTrigger: true,
                applyTo: 'ProductNameTpl',
                onSelect: function(record) { // override default onSelect to do redirect  
                           var sm = userGrid.getSelectionModel().getSelected();
                           var spCustomerId = Ext.getCmp('CustomerId').getValue();
                           
                           dsProductUnits.baseParams.ProductId = record.data.ProductId;
                                    dsProductUnits.load();
                           sm.set('Unit', record.data.UnitId);
                           sm.set('DiscountRate','0');
                           sm.set('DiscountAmt','0');
                           sm.set('TransFee','0');
                           sm.set('SaleQty','0');
                           sm.set('SaleTax','0');
                           sm.set('SaleAmt','0');
                          if(spCustomerId == null ||spCustomerId =='')
                          {
                            productText.setValue(record.data.ProductNo);
                                    sm.set('ProductCode', record.data.ProductNo);
                                    sm.set('Specifications', record.data.Specifications);
                                    
                                    sm.set('ProductId', record.data.ProductId);
                                    sm.set('ProductName',record.data.ProductName);
                                    sm.set('SalePrice',record.data.SalePrice);
                                    sm.set('DiscountRate','0');
                                    sm.set('DiscountAmt','0');
                                    sm.set('TransFee','0');
                                    addNewBlankRow();
                                    this.collapse();
                            return;
                          }
                          //��ȡ��Ʒ�۸���Ϣ
                          Ext.Ajax.request({
		                        url:'frmPOSOrderEdit.aspx?method=getProductInfo',
		                        params:{
			                        ProductNo:record.data.ProductNo,
			                        CustomerId:spCustomerId
		                        },
	                        success: function(resp,opts){
	                            //alert(resp.responseText);
	                            if(resp.responseText.length>20){
		                            var data=Ext.util.JSON.decode(resp.responseText); 
		                            
                                    sm.set('ProductCode', record.data.ProductNo);
                                    sm.set('Specifications', data.Specifications);
                                    //sm.set('Unit', data.Unit);
                                    sm.set('ProductId', data.ProductId);
                                    sm.set('ProductName',data.ProductName);
                                    sm.set('SalePrice',data.SalePrice);
				                    sm.set('Tax',data.SalesTax);
                                    if(sm.get('SaleQty')>0){                                       
                                        sm.set('SaleAmt', accMul(record.data.SaleQty , data.SalePrice).toFixed(2));
                                        //sm.set('SaleTax', accMul(record.get('SaleAmt') ,data.Tax) ); //Math.Round(3.445, 1);                         
                                        sm.set('SaleTax', accMul(accDiv(record.get('SaleAmt'),accAdd(1,record.data.Tax)) ,record.data.Tax).toFixed(2) );
                                    }                                    
                                    sm.set('DiscountRate','0');
                                    sm.set('DiscountAmt','0');                                     
                                    sm.set('TransFee','0');
                                    if(data.OtherFeight>0)
                                        sm.set('TransFee',data.OtherFeight);
                                    //sm.set('SalePrice',record.data.Price);
                                    //productCombo.setValue(data.ProductId);
                                    addNewBlankRow();
//                                    try
//                                    {
                                        productFilterCombo.collapse();
//                                    }
//                                    catch(err)
//                                    {
//                                    }
                                }else{
                                    alert(record.data.ProductName+"���ۻ�׼��δ���ã�����ϵ�۸�ά����Ա���ã�");
                                }
		                    }
		                  });         
            
                    
                }
            });
            }
        }
        
        var cmbProductUse = new Ext.form.ComboBox({
                store: dsProductUse,
                displayField: 'CodeName',
                valueField: 'CodeId',
                id:'cmbProductUse',
                typeAhead: true, 
                triggerAction: 'all',
                selectOnFocus: true,
                mode:'local',
                emptyText: '',
                selectOnFocus: false,
                editable: false,
                listeners: {
                    "select": addNewBlankRow
                } 
               });
               
        var selectRecord = null;
        var cm = new Ext.grid.ColumnModel([
        new Ext.grid.RowNumberer(), //�Զ��к�
        {
        id: 'OrderDtlId',
        header: "������ϸID",
        dataIndex: 'OrderDtlId',
        width: 30,
        hidden: true
    },
         {
            id: 'ProductCode',
            header: "��Ʒ����",
            dataIndex: 'ProductCode',
            width: 60,
            editor:productText
        },
        {
            id: 'ProductName',
            header: "��Ʒ����",
            dataIndex: 'ProductName',
            width: 160,
            editor: productCombo,
            renderer: function(value, cellmeta, record, rowIndex, columnIndex, store) {
                //���ֵ��ʾ����
                //��ȡ��ǰid="combo_process"��comboBoxѡ���ֵ
                 var index = dsProductList.find(productCombo.valueField, value);
                var record = dsProductList.getAt(index);
                var displayText = "";
                // ��������б�û�б�ѡ����ôrecordҲ�Ͳ����ڣ���ʱ�򣬷��ش�������value��
                // �����value����grid��USER_REALNAME�е�value������ֱ�ӷ���
                if (record == null) {
                    //����Ĭ��ֵ��
                    displayText = value;
                } else {
                    displayText = record.data.ProductName; //��ȡrecord�е����ݼ��е�process_name�ֶε�ֵ
                }

                return displayText;
            }
        },
        {
            id: "Unit",
            header: "��λ",
            dataIndex: "Unit",
            //editable:false,
            width: 35,
            editor: UnitCombo,
            renderer: function(value, cellmeta, record, rowIndex, columnIndex, store) {
                var index = dsUnitList.findBy(function(record, id) {  
	                return record.get(UnitCombo.valueField)==value; 
                });
                var record = dsUnitList.getAt(index);
                var displayText = "";
                // ��������б�û�б�ѡ����ôrecordҲ�Ͳ����ڣ���ʱ�򣬷��ش�������value��
                // �����value����grid��USER_REALNAME�е�value������ֱ�ӷ���
                if (record == null) {
                    //����Ĭ��ֵ��
                    displayText = value;
                } else {
                    displayText = record.data.UnitName; //��ȡrecord�е����ݼ��е�process_name�ֶε�ֵ
                }
                return displayText;
            }
        }
        , {
            id: 'Specifications',
            header: "���",
            editable:false,
            dataIndex: 'Specifications',
            width: 65//,
//            editor: productSpecCombo,
//            renderer: function(value, cellmeta, record, rowIndex, columnIndex, store) {
//                var index = dsProductSpecList.findBy(function(record, id) {  
//	                return record.get(productSpecCombo.valueField)==value; 
//                });
//                var record = dsProductSpecList.getAt(index);
//                var displayText = "";
//                // ��������б�û�б�ѡ����ôrecordҲ�Ͳ����ڣ���ʱ�򣬷��ش�������value��
//                // �����value����grid��USER_REALNAME�е�value������ֱ�ӷ���
//                if (record == null) {
//                    //����Ĭ��ֵ��
//                    displayText = value;
//                } else {
//                    displayText = record.data.DicsName; //��ȡrecord�е����ݼ��е�process_name�ֶε�ֵ
//                }
//                return displayText;
//            }
        }, {
            id: 'SaleQty',
            header: "����",
            dataIndex: 'SaleQty',
            width: 55,
		    align: 'right',
            editor: new Ext.form.NumberField({ 
	            allowBlank: false,
	            align: 'right',
	            decimalPrecision:6,
	            listeners: {  
    	            'focus':function(){  
        		        this.selectText();
        		        selectRecord = userGrid.getSelectionModel().getSelected(); 
    	            },
        	         'change': function(oppt){
        	            var record = selectRecord;
        	            record.set('SaleAmt', accMul(oppt.value , accAdd(record.data.SalePrice,record.data.TransFee)).toFixed(2));
                        record.set('SaleTax', accMul(accDiv(record.data.SaleAmt,accAdd(1,record.data.Tax)) ,record.data.Tax).toFixed(2) ); //Math.Round(3.445, 1); 
                        selectRecord = null;
        	        }   
		        }
		    })
        }, 
        {
            id: 'SalePrice',
            header: "����",
            dataIndex: 'SalePrice',
            width: 55,
		    align: 'right',
            editor: new Ext.form.NumberField({ 
		        allowBlank: false,
		        align: 'right',
		        decimalPrecision:8,
		        listeners: {  
        	        'focus':function(){  
        		        this.selectText();  
        		        selectRecord = userGrid.getSelectionModel().getSelected(); 
        	        },
        	         'change': function(oppt){
        	            var record = selectRecord;
        	            record.set('SaleAmt', accMul(record.data.SaleQty , accAdd(record.data.TransFee,oppt.value)).toFixed(2));
                        record.set('SaleTax', accMul(accDiv(record.data.SaleAmt,accAdd(1,record.data.Tax)) ,record.data.Tax).toFixed(2) ); //Math.Round(3.445, 1); 
        	            selectRecord = null;
        	        }   
    		    }
		    })
        },
        {
            id: 'TransFee',
            header: "�˼�",
            dataIndex: 'TransFee',
            width: 55,
		    align: 'right',
            editor: new Ext.form.NumberField({ 
		        allowBlank: false,
		        align: 'right',
		        decimalPrecision:8,
		        listeners: {  
        	        'focus':function(){  
            		        this.selectText(); 
            		        selectRecord = userGrid.getSelectionModel().getSelected();  
        	        },
        	         'change': function(oppt){
        	            var record = selectRecord;
        	            record.set('SaleAmt', accMul(record.data.SaleQty , accAdd(record.data.SalePrice,oppt.value)).toFixed(2));
                        record.set('SaleTax', accMul(accDiv(record.data.SaleAmt,accAdd(1,record.data.Tax)) ,record.data.Tax).toFixed(2) ); //Math.Round(3.445, 1); 
                        selectRecord = null;
        	        } 
                }
		    })
        },
        {
            id: 'DiscountRate',
            header: "�ۿ���%",
            dataIndex: 'DiscountRate',
            width: 65,
		    align: 'right',
            editor: new Ext.form.NumberField({ 
                allowBlank: false,
                align: 'right',
                decimalPrecision:6,
                listeners: {  
    	            'focus':function(){  
        		            this.selectText();  
        		            selectRecord = userGrid.getSelectionModel().getSelected(); 
    	            },
        	         'change': function(oppt){
        	            if(oppt.value<=100 && oppt.value>=0){
        	                var record = selectRecord;
                            record.set('DiscountAmt', accMul(accMul(record.data.SaleQty , accAdd(record.data.SalePrice,record.data.TransFee)) , accDiv(oppt.value,100)).toFixed(2));
                            record.set('SaleAmt', accAdd(accMul(record.data.SaleQty , accAdd(record.data.SalePrice,record.data.TransFee)),-record.data.DiscountAmt).toFixed(2));
                            record.set('SaleTax', accMul(accDiv(record.data.SaleAmt,accAdd(1,record.data.Tax)) ,record.data.Tax).toFixed(2) ); //Math.Round(3.445, 1);                              
                        }
                        selectRecord = null;
        	        }  
    		    }
            })
        },
        {
            id: 'DiscountAmt',
            header: "�ۿ۽��",
            dataIndex: 'DiscountAmt',
            width: 65,
		    align: 'right',
            editor: new Ext.form.NumberField({ 
                allowBlank: false,
                align: 'right',
                decimalPrecision:6,
                listeners: {  
    	            'focus':function(){  
        		            this.selectText();  
        		            selectRecord = userGrid.getSelectionModel().getSelected(); 
    	            },
        	         'change': function(oppt){
        	            if(oppt.value>=0){
        	                var record = selectRecord;
                            record.set('SaleAmt', accAdd(accMul(record.data.SaleQty , accAdd(record.data.SalePrice,record.data.TransFee)),- oppt.value).toFixed(2));
                            record.set('SaleTax', accMul(accDiv(record.data.SaleAmt,accAdd(1,record.data.Tax)) ,record.data.Tax).toFixed(2) ); //Math.Round(3.445, 1);
                            record.set('DiscountRate', accMul(accDiv(oppt.value , accMul(record.data.SaleQty , accAdd(record.data.SalePrice,record.data.TransFee))),100).toFixed(0));                                                                
                        }
                        selectRecord = null;
        	        } 
    		    }
            })
        },
        {
            id: 'SaleAmt',
            header: "�ܽ��",
            //editable:false,
            dataIndex: 'SaleAmt',
            width: 80,
		    align: 'right',
            editor: new Ext.form.NumberField({ allowBlank: false,align: 'right',
            listeners: {
		            'focus': function() {
		                this.selectText();
		            }
		        },
		        decimalPrecision:2 })
        },
        {
            id: 'Tax',
            header: "˰��",
            editable:false,
		    align: 'right',
            dataIndex: 'Tax',
            width: 50
        },
        {
            id: 'SaleTax',
            header: "˰��",
		    align: 'right',
            editable:false,
            dataIndex: 'SaleTax',
            width: 80
        },{
            id: "ProductUse",
            header: "��;",
            dataIndex: "ProductUse",
            //editable:false,
            width: 50,
            editor: cmbProductUse,
            renderer: function(value, cellmeta, record, rowIndex, columnIndex, store) {
                if(typeof(value)=="undefined")
                {
                    return "";
                }
                var index = dsProductUse.findBy(function(record, id) {  
	                return record.get(cmbProductUse.valueField)==value; 
                });
                if(index==-1)
                    return "";
                var record1 = dsProductUse.getAt(index);
                return record1.data.CodeName
            }
        },
        new Extensive.grid.ItemDeleter()
        ]);
    cm.defaultSortable = true;

    var RowPattern = Ext.data.Record.create([
           { name: 'OrderDtlId', type: 'string' },
           { name: 'ProductCode', type: 'string' },
           { name: 'ProductId', type: 'string' },
           { name: 'ProductName', type: 'string' },
           { name: 'Unit', type: 'string' },
           { name: 'Specifications', type: 'string' },
           { name: 'SaleQty', type: 'string' },
           { name: 'SalePrice', type: 'string' },
           { name: 'SaleAmt', type: 'string' },
           { name: 'SaleTax', type: 'string'},
           { name: 'Tax', type: 'string'},
           { name: 'DiscountRate', type: 'string'},
           { name: 'DiscountAmt', type: 'string'},
           { name: 'TransFee', type: 'string'},
           { name: 'ProductUse', type: 'string'}
          ]);

//    var dsOrderProduct;
    if (dsOrderProduct == null) {
        dsOrderProduct = new Ext.data.Store
	        ({
	            url: 'frmOrderDtl.aspx?method=getDtlList',
	            reader: new Ext.data.JsonReader({
	                totalProperty: 'totalProperty',
	                root: 'root'
	            }, RowPattern)
	        });
       
    }
    var userGrid = new Ext.grid.EditorGridPanel({
        store: dsOrderProduct,
        cm: cm,
        selModel: new Extensive.grid.ItemDeleter(),
        layout: 'fit',
        renderTo: 'divGrid',
        width: document.body.offsetWidth,
        autoScroll: true,
        height: 180,
        columnLines:true,
        stripeRows: true,
        frame: true,
        //plugins: USER_ISLOCKEDColumn,
        clicksToEdit: 1,
        bbar:['->',{             
            text:'Ӧ�ս��:',
            xtype: 'label'
        },
        {             
            xtype: 'numberfield',
            format:true,
            width: 80,
	        id:'OrderTotalAmt',
	        name:'OrderTotalAmt',
	        value:0,
	        style: 'color:blue;background:white;text-align: right',
	        readOnly:true
        }],
        viewConfig: {
            columnsText: '��ʾ����',
            scrollOffset: 20,
            sortAscText: '����',
            sortDescText: '����',
            forceFit: false
        },
        listeners:{
            afteredit: function(e){ 
                    if(e.row<e.grid.getStore().getCount()){
                        e.grid.stopEditing();
                        if(e.column < e.record.fields.getCount()-1)
                        {//���һ�в�������
                            //alert('e.column+1');
                             e.grid.startEditing(e.row, e.column+1);
                        }
                        else
                        {
                            //alert('e.row+1')
                             e.grid.startEditing(e.row+1, 1);
                        }
                    }
                    //�Զ�����
                    var record = e.record;//��ȡ���޸ĵ�������
                    var field = e.field;//��ȡ���޸ĵ�����
                    var row = e.row;//��ȡ�к�
                    var column =e.column; //��ȡ�к�
                    if(field=="SaleAmt")
                    {
                        if(record.data.SalePrice == 0){                            
                            record.set('SalePrice', accD(accAdd(accAdd(record.data.SaleAmt,record.data.DiscountAmt),-accMul(record.data.SaleQty ,record.data.TransFee)),record.data.SaleQty,8));
                            record.set('SaleTax', accMul(accDiv(record.data.SaleAmt,accAdd(1,record.data.Tax)) ,record.data.Tax).toFixed(2) ); //Math.Round(3.445, 1);                              
                        }
                    }
                    e.record.commit();
                }                
           }
    });
    userGrid.getView().on('rowsinserted',setAllTotalAmt);
    userGrid.getView().on('rowupdated',setAllTotalAmt);
    userGrid.getView().on('rowremoved',setAllTotalAmt);
    function setAllTotalAmt(){
        var tamt =0;
        dsOrderProduct.each(function(rec) {
            if(rec.data.SaleAmt == null && rec.data.SaleAmt == undefined)
                rec.data.SaleAmt = 0;
            tamt =accAdd(rec.data.SaleAmt,tamt);
        });
        Ext.getCmp('OrderTotalAmt').setValue(tamt);
    }
    userGrid.on("beforeedit",beforeEdit,userGrid);
    function beforeEdit(e)
    {
        var record = e.record;
        if(record.data.ProductId != dsProductUnits.baseParams.ProductId)
        {
            dsProductUnits.baseParams.ProductId = record.data.ProductId;
            dsProductUnits.load();
        }
    }
    function accD(arg1,arg2,pos)
    {
        //Math.round(src*Math.pow(10, pos))/Math.pow(10, pos);
        //�����������
        m = 0;
        s1=arg1.toString();
        s2=arg2.toString();
        try{m+=s1.split(".")[1].length}catch(e){}
        try{m-=s2.split(".")[1].length}catch(e){}
        var num = Number(s1.replace(".",""))/Number(s2.replace(".",""))/Math.pow(10,m);
        return Math.round(num * Math.pow(10,pos))/Math.pow(10,pos);
    }
    function accAdd(arg1,arg2){  
        var r1,r2,m;  
        try{r1=arg1.toString().split(".")[1].length}catch(e){r1=0}  
        try{r2=arg2.toString().split(".")[1].length}catch(e){r2=0}  
        m=Math.pow(10,Math.max(r1,r2))  
        return (arg1*m+arg2*m)/m  
    }  
    function accMul(arg1,arg2)
    {
        try
        {
        //�����������
        var m=0,s1=arg1.toString(),s2=arg2.toString();
        try{m+=s1.split(".")[1].length}catch(e){}
        try{m+=s2.split(".")[1].length}catch(e){}
        return Number(s1.replace(".",""))*Number(s2.replace(".",""))/Math.pow(10,m);
        }
        catch(err)
        {
            return 0;
        }
    }
    function accDiv(arg1,arg2){  
        var t1=0,t2=0,r1,r2;  
        try{t1=arg1.toString().split(".")[1].length}catch(e){}  
        try{t2=arg2.toString().split(".")[1].length}catch(e){}  
        with(Math){  
            r1=Number(arg1.toString().replace(".",""))  
            r2=Number(arg2.toString().replace(".",""))  
            return (r1/r2)*pow(10,t2-t1);  
        }  
    } 
    
    //-------------------Grid End-------------------------------
    inserNewBlankRow(); //GridĬ�ϳ�ʼ��
    /*----------------footerframe----------------*/
    //��grid��ϸ��¼��װ��json���ύ��UI��decode
    var json = '';
    var footerForm = new Ext.FormPanel({
        renderTo: 'divBotton',
        //border: true, // û�б߿�
        //labelAlign: 'left',
        buttonAlign: 'center',
        bodyStyle: 'padding:1px',
        //height: 25,
        frame: true,
        //labelWidth: 55,     
        buttons: [{
            text: "����",
            scope: this,
            id: 'saveButton',
            handler: function() {
            
                 //�����ͷ�ʽΪ�����ʱ�����ָ������ֿ�
                 var psfs = Ext.getCmp('DlvType').getValue();
                 var allowid = 1;
                 var orgids = Ext.getCmp('OrgId').getValue();
                 if(orgids==127||orgids==121){
                    allowid = 0;
                 }
                 if (psfs == "S042"&&allowid==1) //����
                 {            
                    var whbm = Ext.getCmp('OutStor').getValue();
                    if(whbm==undefined||whbm==null||whbm==""||whbm==0)
                    {
                        Ext.Msg.alert("��ʾ", "��ָ������ֿ⣡");
                        return;
                    }
                 }
            
                json = "";
                dsOrderProduct.each(function(dsOrderProduct) {
                    json += Ext.util.JSON.encode(dsOrderProduct.data) + ',';
                });
                json = json.substring(0, json.length - 1);
                
                if (dsOrderProduct.getCount() <= 1)
                {
                     Ext.Msg.alert("��ʾ", "��ѡ�񶩹�����Ʒ��");
                     return;
                }
                if(Ext.getCmp('CustomerId').getValue()=='') 
                {
                     Ext.Msg.alert("��ʾ", "�ͻ���Ϣ������ѡ����ȷ�ͻ���");
                     return;
                }
                if(Ext.getCmp('DlvDate').getValue()< (new Date()).clearTime()) 
                {
                    if(!window.confirm("�ͻ�����С�ڵ������ڣ��Ƿ�������棿"))                      
                        return;
                }
                Ext.MessageBox.wait("�������ڱ��棬���Ժ򡭡�");
                //Ȼ�����������
                Ext.Ajax.request({
                    url: 'frmOrderDtl.aspx?method=saveOrder',
                    method: 'POST',
                    params: {
                        //������
                        OrderId:Ext.getCmp('OrderId').getValue(),
		                OrgId:Ext.getCmp('OrgId').getValue(),
		                DeptId:Ext.getCmp('SaleDept').getValue(),
		                OutStor:Ext.getCmp('OutStor').getValue(),
		                CustomerId:Ext.getCmp('CustomerId').getValue(),
		                DlvDate:Ext.getCmp('DlvDate').getValue().dateFormat('Y/m/d'),
		                DlvAdd:Ext.getCmp('DlvAdd').getValue(),
		                DlvDesc:Ext.getCmp('DlvDesc').getValue(),
		                OrderType:'S011',
		                PayType:Ext.getCmp('PayType').getValue(),
		                BillMode:Ext.getCmp('BillMode').getValue(),
		                DlvType:Ext.getCmp('DlvType').getValue(),
		                DlvLevel:Ext.getCmp('DlvLevel').getValue(),
		                Status:1,
		                IsPayed:Ext.getCmp('IsPayed').getValue(),
		                IsBill:Ext.getCmp('IsBill').getValue(),		
		                Remark:Ext.getCmp('Remark').getValue(),
		                OutedQty:Ext.getCmp('OutedQty').getValue(),
		                SaleInvId:Ext.getCmp('SaleInvId').getValue(),
		                IsActive:1,
		                TransOrg:Ext.getCmp('TransOrg').getValue(),
		                SaleOrg:Ext.getCmp('SaleOrg').getValue(),
			            Ext1:Ext.getCmp('DriverId').getValue(),
			
                        //��ϸ����
                        DetailInfo: json
                    },
                    success: function(resp,opts){ 
                                    Ext.MessageBox.hide();
                                    if( checkParentExtMessage(resp,parent) )
                                         {
                                           parent.OrderMstGridData.reload();
                                           parent.uploadOrderWindow.hide();  
                                         }
                                   },
		            failure: function(resp,opts){  
		                Ext.MessageBox.hide();
		                Ext.Msg.alert("��ʾ","����ʧ��");     
		            }

               
                });
                //
            }
        },{
                             text: "���",
                             id:'btnCommit',
                             scope: this,
                             hidden:true,
                             handler:function(){
                                parent.ViewCommit(OrderId);
                                parent.uploadOrderWindow.hide();
                             }
},
                         {
                             text: "ȡ��",
                             scope: this,
                             handler: function() {
                                 parent.uploadOrderWindow.hide();
                             }
}]
    });
    
    
    Ext.getCmp("OrderId").setValue(OrderId);
    
    if (OperType == "query")
    {
      Ext.getCmp("saveButton").hide();      
      var cm = userGrid.getColumnModel();
      for(var i=0;i<cm.getColumnCount();i++)
            cm.setEditable(i,false);      
      Ext.getCmp("customFind").getEl().dom.readOnly=true;
      Ext.getCmp("OrderId").getEl().dom.readOnly=true;
      Ext.getCmp("OutStor").getEl().dom.readOnly=true;
      Ext.getCmp("DlvDate").getEl().dom.readOnly=true;
      Ext.getCmp("DlvAdd").getEl().dom.readOnly=true;
      Ext.getCmp("DlvDesc").getEl().dom.readOnly=true;
      Ext.getCmp("DlvLevel").getEl().dom.readOnly=true;
      Ext.getCmp("PayType").getEl().dom.readOnly=true;
      Ext.getCmp("BillMode").getEl().dom.readOnly=true;
      Ext.getCmp("DlvType").getEl().dom.readOnly=true;
      Ext.getCmp("IsPayed").getEl().dom.readOnly=true;
      Ext.getCmp("IsBill").getEl().dom.readOnly=true;
      Ext.getCmp("Remark").getEl().dom.readOnly=true;
      
      
    }
    if(OperAction=="check")
    {
        Ext.getCmp("btnCommit").show();
    }
    if(OperAction=="create")
    {
        Ext.getCmp("btnCommit").show();
        Ext.getCmp("btnCommit").setText("���������");
    }

    if (OrderId == 0) {    
        
        Ext.getCmp("DlvDate").setValue( (new Date()).clearTime() );
        Ext.getCmp("PayType").setValue('S021');
        Ext.getCmp("BillMode").setValue("S031");
        Ext.getCmp("DlvType").setValue("S041");
        Ext.getCmp("DlvLevel").setValue("S051");
        Ext.getCmp("IsPayed").setValue(0);
        Ext.getCmp("IsBill").setValue(0);
        Ext.getCmp("Status").setValue(1);
        Ext.getCmp("IsActive").setValue(1);
        Ext.getCmp("CreateDate").setValue((new Date()).clearTime());
    }
    
    if (OrderId > 0) {
        setFormValue();
        Ext.getCmp("cusno").getEl().dom.readOnly=true;
        
        var curId = <% =ZJSIG.UIProcess.ADM.UIAdmUser.OrgID(this)%>;
        if(Ext.getCmp("OrgId").getValue() == curId){
            Ext.getCmp("TransOrg").getEl().dom.readOnly=true;
        }
        dsOrderProduct.load({
            params: { 
                start: 0,
                limit: 100,
                OrderId: OrderId
            },
            callback: function(r, options, success) {
                if (success == true) {
                    inserNewBlankRow();
                    }
                }
            
        });
    }else{
        Ext.getCmp('OrgId').setValue(<% =ZJSIG.UIProcess.ADM.UIAdmUser.OrgID(this)%>);
        Ext.getCmp('SaleOrg').setValue(<% =ZJSIG.UIProcess.ADM.UIAdmUser.OrgID(this)%>);
        //Ext.getCmp('OrgId').setDisabled(true);
        Ext.getCmp('TransOrg').setValue(<% =ZJSIG.UIProcess.ADM.UIAdmUser.OrgID(this)%>);
        Ext.getCmp('SaleDept').setValue(<% =ZJSIG.UIProcess.ADM.UIAdmUser.DeptID(this)%>);
        Ext.getCmp('SaleDept').getEl().dom.readOnly=true;        
    }
    
    var sm = userGrid.getSelectionModel();
    sm.onEditorKey = function(field, e) {
     var k = e.getKey(), newCell, g = sm.grid, ed = g.activeEditor;
     if (k == e.ENTER) {
         e.stopEvent();
         ed.completeEdit();         
         var i = 1;
         if(ed.col==2) i+=2;//skip pname    
         if(ed.col==10) g.getSelectionModel().selectNext(false);//nextrow
         if (e.shiftKey) {
             newCell = g.walkCells(ed.row, ed.col - i, -i, sm.acceptsNav, sm);
         } else {
             newCell = g.walkCells(ed.row, ed.col + i, i, sm.acceptsNav, sm);
         }
     } else if (k == e.TAB) {
         e.stopEvent();
         ed.completeEdit();
         if (e.shiftKey) {
             newCell = g.walkCells(ed.row-1, ed.col, -1, sm.acceptsNav, sm);
         } else {
             newCell = g.walkCells(ed.row+1, ed.col, 1, sm.acceptsNav, sm);
         }
         if (ed.col == 1) {
             if (e.shiftKey) {
                 newCell = g.walkCells(ed.row, ed.col + 1, -1, sm.acceptsNav, sm);
             } else {
                 newCell = g.walkCells(ed.row, ed.col + 1, 1, sm.acceptsNav, sm);
             }
         }
     } else if (k == e.ESC) {
         ed.cancelEdit();
     }
     if (newCell) {
         g.startEditing(newCell[0], newCell[1]);
     }

    };	
           
})

</script>
</html>

<script type="text/javascript" src="../js/SelectModule.js"></script>