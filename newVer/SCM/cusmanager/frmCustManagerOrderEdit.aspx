<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmCustManagerOrderEdit.aspx.cs" Inherits="SCM_frmCustManagerOrderEdit" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html>
<head>
<title>�ͻ�������ά��</title>
<meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<link rel="stylesheet" type="text/css" href="../../ext3/resources/css/ext-all.css" />
<link rel="stylesheet" type="text/css" href="../../Theme/1/css/salt.css" />
<script type="text/javascript" src="../../ext3/adapter/ext/ext-base.js"></script>
<script type="text/javascript" src="../../ext3/ext-all.js"></script>
<script type="text/javascript" src="../../ext3/example/ItemDeleter.js"></script>
<script type="text/javascript" src="../../js/operateResp.js"></script>
<script type="text/javascript" src="../../ext3/src/locale/ext-lang-zh_CN.js"></script>
<style type="text/css">
.extensive-remove {
background-image: url(../../Theme/1/images/extjs/customer/cross.gif) ! important;
}
.x-grid-back-blue { 
background: #B7CBE8; 
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
Ext.BLANK_IMAGE_URL = "../../ext3/resources/images/default/s.gif";
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
    var args = new Object();
    args = GetUrlParms();
    //���Ҫ���Ҳ���key:
    var OrderId = args["id"];
    var OperType = args["OpenType"];
    var customerID = args["customerid"]; 



    Ext.onReady(function() {  
    
        Ext.form.TextField.prototype.afterRender = Ext.form.TextField.prototype.afterRender.createSequence(function() {
         this.relayEvents(this.el, ['onblur']);
        });
        
        //var dsDept; //����������
        //if (dsDept == null) { //��ֹ�ظ�����
        //    dsDept = new Ext.data.JsonStore({
        //        totalProperty: "result",
        //        root: "root",
        //        url: 'frmCustManagerOrderEdit.aspx?method=getDeptSimple',
        //        fields: ['DeptId', 'DeptName']
        //    })
        // };
            
                 
    
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
                   columnWidth: 1,  //����ռ�õĿ�ȣ���ʶΪ20��
                   border: false,
                   items: [{
                        style: 'margin-left:0px',
                        cls: 'key',
                        xtype: 'textfield',
                        fieldLabel: '�ͻ����',
                        name: 'cusno',
                        id:'cusno',
                        anchor: '98%'
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
                       disabled:true,
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
                       disabled:true,
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
                       disabled:true,
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
                   columnWidth: 1,  //����ռ�õĿ�ȣ���ʶΪ20��
                   border: false,
                   items: [{
                       cls: 'key',
                       xtype: 'textfield',
                       disabled:true,
                       fieldLabel: '�ͻ���ַ',
                       name: 'cusadd',
                       id: 'cusadd',
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
                                    fieldLabel:'��˾��ʶ',
                                    anchor:'98%',
                                    name:'OrgName',
                                    id:'OrgId',
                                    store: dsOrg,
                                    displayField: 'OrgName',  //����ֶκ�ҵ��ʵ�����ֶ�ͬ��
                                    valueField: 'OrgId',      //����ֶκ�ҵ��ʵ�����ֶ�ͬ��
                                    typeAhead: true, //�Զ�����һ����������ѡ�ȫ����
                                    triggerAction: 'all',
                                    emptyValue: '',
                                    selectOnFocus: true,
                                    forceSelection: true,
                                    mode:'local'   // ,
//                                    listeners: {
//                                       select: function(combo, record, index) {
//                                            var curWhId = Ext.getCmp('OrgId').getValue();
//                                            dsDept.load({
//                                                params: {
//                                                    orgID: curWhId
//                                                }
//                                            });
//                                        }
//                                    }  
				                }
		                            ]
		                }		                
                ,		{
			                layout:'form',
			                border: false,
			                columnWidth:0.33,
			                items: [
				                {
					                xtype:'combo',
                                    fieldLabel:'����',
                                    anchor:'98%',
                                    name:'SaleDept',
                                    id:'SaleDept',
                                    store: dsDept,
                                    displayField: 'DeptName',  //����ֶκ�ҵ��ʵ�����ֶ�ͬ��
                                    valueField: 'DeptId',      //����ֶκ�ҵ��ʵ�����ֶ�ͬ��
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
                                   editable: false,
                                   name:'OutStor',
                                   id:'OutStor',
                                   emptyValue: '',
                                   triggerAction: 'all',
                                   fieldLabel: '�ֿ�*',
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
					               xtype:'textfield',
			                        fieldLabel:'�ͻ��ص�',
			                        anchor:'98%',
			                        name:'DlvAdd',
			                        id:'DlvAdd'
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
    
        //�����������첽���÷���
        var dsCustomer = new Ext.data.Store({   
            url: 'frmCustManagerOrderEdit.aspx?method=getCusByConLike',  
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
                {name: 'DeliverAdd', mapping: 'DeliverAdd'}
            ]) 
        });  
        // �����������첽������ʾģ��
        var resultTpl = new Ext.XTemplate(  
            '<tpl for="."><div id="searchdivid" class="search-item">',  
                '<h3><span>���:{CustomerNo}&nbsp;  ����:{ShortName}&nbsp;  ��ϵ��:{LinkMan}&nbsp;  �绰:{LinkTel}</span></h3>',
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
                        Ext.getCmp("CustomerId").setValue(record.data.CustomerId);
                        Ext.getCmp("cusno").setValue(record.data.CustomerNo);
                        Ext.getCmp("cusname").setValue(record.data.ShortName);
                        Ext.getCmp("cusadd").setValue(record.data.Address);
                        Ext.getCmp("mobile").setValue(record.data.LinkTel);
                        Ext.getCmp("person").setValue(record.data.LinkMan);
                        Ext.getCmp("DlvAdd").setValue(record.data.DeliverAdd);
                        this.collapse();//���������б�
                        //��Ʒ�б�
                        dsProductList.baseParams.CustomerId = record.data.CustomerId;
                        dsProductList.load();
                        //������ϸ�б�
                        dsOrderProduct.baseParams.start  =  0;
                        dsOrderProduct.baseParams.limit  =  10;
                        dsOrderProduct.baseParams.CustomerId =  record.data.CustomerId;
                        dsOrderProduct.baseParams.OrderId  =  0;                        
                        dsOrderProduct.baseParams.Type =  "New";//������ʱ��
                        dsOrderProduct.load();                        
                        
                    }
               });
    

        //-------------------Grid Start-----------------------------
        function inserNewBlankRow() {
            var rowCount = userGrid.getStore().getCount();
            var insertPos = parseInt(rowCount);
            var addRow = new RowPattern({
                ProductId:'',
			    SaleQty:'',
			    SalePrice:'',
			    SaleAmt:'',
			    SaleTax:''
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
        var dsProductList = new Ext.data.Store({   
            url: 'frmCustManagerOrderEdit.aspx?method=getCustomProduct',  
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
                {name: 'SalePrice', mapping: 'SalePrice'}
            ]) 
        }); 
        // �����������첽������ʾģ��
        var resultPrdTpl = new Ext.XTemplate(  
            '<tpl for="."><div id="productdivid" class="search-item">',  
                '<h3><span>{ProductName}&nbsp</h3>',
            '</div></tpl>'  
        ); 

        //������λ������
        var UnitCombo = new Ext.form.ComboBox({
            store: dsUnitList,
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
        var productSpecCombo = new Ext.form.ComboBox({
            store: dsProductSpecList,
            displayField: 'DicsName',
            valueField: 'DicsCode',
            triggerAction: 'all',
            id: 'productSpecCombo',
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
        //��Ʒ������
        var productCombo = new Ext.form.ComboBox({
            store: dsProductList,
            displayField: 'ProductName',
            valueField: 'ProductId',
            triggerAction: 'all',
            id: 'productCombo',
            //pageSize: 5,
            //minChars: 2,
            tpl:resultPrdTpl,
            hideTrigger:true, 
            itemSelector: 'div.search-item',  
            editable:false,
            typeAhead: true,
            mode: 'local',
            emptyText: '',
            selectOnFocus: false,
            //lastQuery:'',
            onSelect: function(record) {
                var sm = userGrid.getSelectionModel().getSelected();
                sm.set('ProductCode', record.data.ProductNo);
                sm.set('Specifications', record.data.Specifications);
                sm.set('Unit', record.data.Unit);
                sm.set('ProductId', record.data.ProductId);
                sm.set('ProductName',record.data.ProductName);
                sm.set('SalePrice',record.data.SalePrice);
                //sm.set('SalePrice',record.data.Price);
                productCombo.setValue(record.data.ProductId);
                addNewBlankRow();
                
                this.collapse();//���������б�
            }
        });
        
        var cm = new Ext.grid.ColumnModel([
        new Ext.grid.RowNumberer(), //�Զ��к�
        {
        id: 'OrderDtlId',
        header: "������ϸID",
        dataIndex: 'OrderDtlId',
        width: 30,
        hidden: true,
        editor: new Ext.form.TextField({ allowBlank: false })
    },
         {
            id: 'ProductCode',
            header: "����",
            dataIndex: 'ProductCode',
            width: 30
        },
        {
            id: 'ProductName',
            header: "��Ʒ����",
            dataIndex: 'ProductName',
            width: 65,
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
            editable:false,
            width: 20,
            editor: UnitCombo,
            renderer: function(value, cellmeta, record, rowIndex, columnIndex, store) {
                //���ֵ��ʾ����
                //��ȡ��ǰid="combo_process"��comboBoxѡ���ֵ
                var index = dsUnitList.find(UnitCombo.valueField, value);
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
            width: 30,
            editor: productSpecCombo,
            renderer: function(value, cellmeta, record, rowIndex, columnIndex, store) {
                //���ֵ��ʾ����
                //��ȡ��ǰid="combo_process"��comboBoxѡ���ֵ
                var index = dsProductSpecList.find(productSpecCombo.valueField, value);
                var record = dsProductSpecList.getAt(index);
                var displayText = "";
                // ��������б�û�б�ѡ����ôrecordҲ�Ͳ����ڣ���ʱ�򣬷��ش�������value��
                // �����value����grid��USER_REALNAME�е�value������ֱ�ӷ���
                if (record == null) {
                    //����Ĭ��ֵ��
                    displayText = value;
                } else {
                    displayText = record.data.DicsName; //��ȡrecord�е����ݼ��е�process_name�ֶε�ֵ
                }
                return displayText;
            }
        }, {
            id: 'SaleQty',
            header: "����",
            dataIndex: 'SaleQty',
            width: 20,
            editor: new Ext.form.NumberField({ allowBlank: false,decimalPrecision:8  })
        }, 
        {
            id: 'SalePrice',
            header: "����",
            dataIndex: 'SalePrice',
            width: 20,
            editor: new Ext.form.NumberField({ allowBlank: false,decimalPrecision:8  })
        },
        {
            id: 'SaleAmt',
            header: "���",
            editable:false,
            dataIndex: 'SaleAmt',
            width: 20
        },
        {
            id: 'SaleTax',
            header: "˰��",
            editable:false,
            dataIndex: 'SaleTax',
            width: 20
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
           { name: 'SaleTax', type: 'string'}
          ]);


    var dsOrderProduct;
    if (dsOrderProduct == null) {
        dsOrderProduct = new Ext.data.Store
	        ({
	            url: 'frmCustManagerOrderEdit.aspx?method=getDtlList',
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
        width: '100%',
        height: 180,
        stripeRows: true,
        frame: true,
        //plugins: USER_ISLOCKEDColumn,
        clicksToEdit: 1,
        viewConfig: {
            columnsText: '��ʾ����',
            scrollOffset: 20,
            sortAscText: '����',
            sortDescText: '����',
            forceFit: true
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
                        if(field ='SaleQty' || field=='SalePrice'){
                            record.set('SaleAmt', accMul(record.data.SaleQty , record.data.SalePrice));
                            record.set('SaleTax', accMul(record.get('SaleAmt') ,0.17) ); //Math.Round(3.445, 1); 
                        }
                    }
               }

    });
    function accMul(arg1,arg2)
    {//�����������
        var m=0,s1=arg1.toString(),s2=arg2.toString();
        try{m+=s1.split(".")[1].length}catch(e){}
        try{m+=s2.split(".")[1].length}catch(e){}
        return Number(s1.replace(".",""))*Number(s2.replace(".",""))/Math.pow(10,m)
    }
    /*------��ʼ�������ݵĺ��� Start---------------*/
    function setFormValue() {
        Ext.Ajax.request({
            url: 'frmCustManagerOrder.aspx?method=getOrder',
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
		                Ext.getCmp("mobile").setValue(data.LinkMan);
		                Ext.getCmp("person").setValue(data.LinkTel);
		                Ext.getCmp("cusadd").setValue(data.Address);
		                Ext.getCmp("DlvDate").setValue(new Date(data.DlvDate.replace(/-/g, "/")));
		                Ext.getCmp("DlvAdd").setValue(data.DlvAdd);
//		                Ext.getCmp("OrderType").setValue(data.OrderType);
		                Ext.getCmp("PayType").setValue(data.PayType);
		                Ext.getCmp("BillMode").setValue(data.BillMode);
		                Ext.getCmp("DlvType").setValue(data.DlvType);
		                Ext.getCmp("DlvLevel").setValue(data.DlvLevel);
		                //Ext.getCmp("Status").setValue(data.Status);
		                Ext.getCmp("IsPayed").setValue(data.IsPayed);
		                Ext.getCmp("IsBill").setValue(data.IsBill);
		                Ext.getCmp("Remark").setValue(data.Remark);		  
		                Ext.getCmp("DlvDesc").setValue(data.DlvDesc);	  
		                Ext.getCmp("CreateDate").setValue((new Date(data.CreateDate.replace(/-/g, "/"))));
		                Ext.getCmp("Status").setValue(data.Status);
		                Ext.getCmp("SaleInvId").setValue(data.SaleInvId);
		                Ext.getCmp("OutedQty").setValue(data.OutedQty);
		                Ext.getCmp("IsActive").setValue(data.IsActive);
		                

            },
            failure: function(resp, opts) {
                Ext.Msg.alert("��ʾ", "��ȡ��ʼ���ֿ���Ϣʧ�ܣ�");
            }
        });
    }
    /*------��ʼ�������ݵĺ��� End---------------*/
    //-------------------Grid End-------------------------------
    inserNewBlankRow(); //GridĬ�ϳ�ʼ��
    /*----------------footerframe----------------*/
    //��grid��ϸ��¼��װ��json���ύ��UI��decode
    var json = '';
    var footerForm = new Ext.FormPanel({
        renderTo: 'divBotton',
        border: true, // û�б߿�
        labelAlign: 'left',
        buttonAlign: 'center',
        bodyStyle: 'padding:1px',
        height: 25,
        frame: true,
        labelWidth: 55,        
        buttons: [{
            text: "����",
            scope: this,
            id: 'saveButton',
            handler: function() {
            
                //�����ͷ�ʽΪ�����ʱ�����ָ������ֿ�
                 var psfs = Ext.getCmp('DlvType').getValue();
                 if (psfs == "S042") //����
                 {            
                    var whbm = Ext.getCmp('OutStor').getValue();
                    if(whbm==undefined||whbm==null||whbm==""||whbm==0)
                    {
                        Ext.Msg.alert("��ʾ", "��ָ������ֿ⣡");
                        return;
                    }
                 }
            
                json = "";
                count = 0;
                dsOrderProduct.each(function(dsOrderProduct) {                   
                    var saleqty = dsOrderProduct.get('SaleQty');
                    if (saleqty > 0 )
                    {
                        json += Ext.util.JSON.encode(dsOrderProduct.data) + ',';
                        count = count + 1;
                    }
                });
                if ( count == 0 )
                {
                    Ext.Msg.alert("��ʾ", "������������");
                    return;
                }
                //json = json.substring(0, json.length - 1);
                
                if (dsOrderProduct.getCount() <= 1)
                {
                     Ext.Msg.alert("��ʾ", "��ѡ�񶩹�����Ʒ��");
                     return;
                }
                
                Ext.MessageBox.wait("�������ڱ��棬���Ժ򡭡�");
                //Ȼ�����������
                Ext.Ajax.request({
                    url: 'frmCustManagerOrderEdit.aspx?method=saveOrder'+owner,
                    method: 'POST',
                    params: {
                        //������
                        OrderId:Ext.getCmp('OrderId').getValue(),
		                OrgId:Ext.getCmp('OrgId').getValue(),
		                DeptId:Ext.getCmp('SaleDept').getValue(),
		                OutStor:Ext.getCmp('OutStor').getValue(),
		                CustomerId:Ext.getCmp('CustomerId').getValue(),
		                DlvDate:Ext.util.Format.date(Ext.getCmp('DlvDate').getValue(),'Y/m/d'),
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
		                Remark:Ext.getCmp('Remark').getValue()	,
		                OutedQty:Ext.getCmp('OutedQty').getValue(),
		                SaleInvId:Ext.getCmp('SaleInvId').getValue(),
		                IsActive:1,
			
                        //��ϸ����
                        DetailInfo: json
                    },
                    success: function(resp,opts){ 
                                    if( checkExtMessage(resp) )
                                        {
                                           parent.OrderMstGridData.reload();
                                           parent.uploadOrderWindow.hide();                                            
                                        }
                                   },
		            failure: function(resp,opts){  Ext.Msg.alert("��ʾ","����ʧ��");     }
                });
                //
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
        Ext.getCmp("OutStor").setDisabled(true);                
        Ext.getCmp('DlvDate').setDisabled(true);
        Ext.getCmp('DlvAdd').setDisabled(true);
        Ext.getCmp('DlvDesc').setDisabled(true);
        Ext.getCmp('PayType').setDisabled(true);
        Ext.getCmp('BillMode').setDisabled(true);
        Ext.getCmp('DlvType').setDisabled(true);
        Ext.getCmp('DlvLevel').setDisabled(true);
        Ext.getCmp('IsPayed').setDisabled(true);
        Ext.getCmp('IsBill').setDisabled(true);
        Ext.getCmp('Remark').setDisabled(true);
        Ext.getCmp('OutedQty').setDisabled(true);
        Ext.getCmp('SaleInvId').setDisabled(true);
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
        Ext.getCmp("cusno").setDisabled(true);
        
        //��Ʒ�б�
        dsProductList.baseParams.CustomerId = customerID;
        dsProductList.load();
                           
        dsOrderProduct.load({
            params: { 
                start: 0,
                limit: 10,
                OrderId: OrderId,
                CustomerId:0,
                Type:"Edit"//�޸�ʱ��
            },
            callback: function(r, options, success) {
                if (success == true) {
                    inserNewBlankRow();
                    }
                }
            
        });
    }
    
    Ext.getCmp('OrgId').setValue(<% =ZJSIG.UIProcess.ADM.UIAdmUser.OrgID(this)%>);
    Ext.getCmp('OrgId').setDisabled(true);
    Ext.getCmp('SaleDept').setValue(<% =ZJSIG.UIProcess.ADM.UIAdmUser.DeptID(this)%>);
    Ext.getCmp('SaleDept').setDisabled(true);
    
})

</script>

</html>