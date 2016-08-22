<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmScmRebateOrderDtl.aspx.cs" Inherits="SCM_frmScmRebateOrderDtl" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html>
<head>
<title>����ҳ��</title><meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<link rel="stylesheet" type="text/css" href="../ext3/resources/css/ext-all.css" />
<script type="text/javascript" src="../ext3/adapter/ext/ext-base.js"></script>
<script type="text/javascript" src="../ext3/ext-all.js"></script>
<script type="text/javascript" src="../ext3/example/ItemDeleter.js"></script>
<script type="text/javascript" src="../js/operateResp.js"></script>
<script type="text/javascript" src="../ext3/src/locale/ext-lang-zh_CN.js"></script>
<script type="text/javascript" src="../js/SelectModule.js"></script>
<style type="text/css">
.extensive-remove {
background-image: url(../Theme/1/images/extjs/customer/cross.gif) ! important;
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
var args = new Object();
args = GetUrlParms();
//���Ҫ���Ҳ���key:
var RebateId = args["id"];
var OperType = args["OpenType"];
    
Ext.onReady(function(){

/*------ʵ��FormPanle�ĺ��� start---------------*/
var initOrderForm = new Ext.form.FormPanel({
           renderTo: 'divForm',
           frame: true,
           monitorValid: true, // ����formBind:true�İ�ť����֤��
           labelWidth: 70,
           bodyStyle: 'padding:1px',
           items:
           [
            {
		                layout:'column',
		                border: false,
		                labelSeparator: '��',
		                items: [
		                {
			                layout:'form',
			                border: false,
			                columnWidth:0.49,
			                items: [
				                {
					                xtype: 'combo',
                                   store:dsBusinessType,
                                   valueField: 'DicsCode',
                                   displayField: 'DicsName',
                                   mode: 'local',
                                   forceSelection: true,
                                   editable: false,
                                   emptyValue: '',
                                   triggerAction: 'all',
                                   fieldLabel: 'ҵ������',
                                   name:'BusinessType',
                                   id:'BusinessType',
                                   selectOnFocus: true,
                                   disabled:true,
                                   anchor: '98%'
				                }
		                            ]
		                }		                
                ,		{
			                layout:'form',
			                border: false,
			                columnWidth:0.49,
			                items: [
				                {
					               xtype: 'combo',
                                   store: dsRebateType,
                                   valueField: 'DicsCode',
                                   displayField: 'DicsName',
                                   mode: 'local',
                                   forceSelection: true,
                                   editable: false,
                                   emptyValue: '',
                                   triggerAction: 'all',
                                   fieldLabel: '��������',
                                   name:'RebateType',
                                   id:'RebateType',
                                   selectOnFocus: true,
                                   disabled:true,
                                   anchor: '98%'
				                }
		                ]
		                }
	                ]},{
                layout:'column',
                border: true,                                 
                items:
                [{
                   layout: 'form',
                   columnWidth: .93,  //����ռ�õĿ�ȣ���ʶΪ20��
                   border: false,
                   items: [{
                            style: 'margin-left:0px',
                            cls: 'key',
                            xtype: 'textfield',
                            fieldLabel: '���̱��',
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
                            hideLabel:true,
                            id:'customFind',
                            listeners:{
                                click:function(v){
                                    getCustomerInfo(initCustomerInfo,<%=ZJSIG.UIProcess.ADM.UIAdmUser.OrgID(this) %>,'',550,300);                                    
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
                   columnWidth: .49,  //����ռ�õĿ�ȣ���ʶΪ20��
                   border: false,
                   items: [{
                       cls: 'key',
                       xtype: 'textfield',
                       disabled:true,
                       fieldLabel: '��������',
                       name: 'cusname',
                       id: 'cusname',
                       anchor: '98%'
                           }]
                  },
                  {
                   layout: 'form',
                   columnWidth: .49,  //����ռ�õĿ�ȣ���ʶΪ20��
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
                  }]
            },
            {
                layout:'column',
                border: false,
                items:
                [{
                   layout: 'form',
                   columnWidth: .98,  //����ռ�õĿ�ȣ���ʶΪ20��
                   border: false,
                   items: [{
                       xtype: 'hidden',
                       fieldLabel: '����ID',
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
			                        name:'RebateId',
			                        id:'RebateId'
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
			                columnWidth:0.49,
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
                                   fieldLabel: '�ֿ�',
                                   selectOnFocus: true,
                                   anchor: '98%',
                                   listeners: {
                                        select: function(combo, record, index) {
                                            var curWhId = Ext.getCmp("OutStor").getValue();
                                            if(dsWarehousePosList.baseParams.WhId!=curWhId)
		                                    {
		                                        dsWarehousePosList.baseParams.WhId=curWhId;
		                                        dsWarehousePosList.load();
		                                    }//                                            
                                        }
				                    }
		                
		                          }]
		                 },{
			                layout:'form',
			                border: false,
			                columnWidth:0.49,
			                items: [
				                {
					               xtype:'textfield',
		                            fieldLabel:'�������ݺ�',
		                            columnWidth:1,
		                            anchor:'98%',
		                            name:'FromBillId',
		                            id:'FromBillId'
				                }
		                            ]
		                },
		                {
			                layout:'form',
			                border: false,
			                columnWidth:0.3,
			                items: [
				                {
					                xtype: 'combo',
                                   store: dsFromBillType,
                                   valueField: 'DicsCode',
                                   displayField: 'DicsName',
                                   mode: 'local',
                                   forceSelection: true,
                                   editable: false,
                                   emptyValue: '',
                                   triggerAction: 'all',
                                   fieldLabel: '����������',
                                    name:'FromBillType',
                                   id:'FromBillType',
                                   selectOnFocus: true,
                                   anchor: '98%',
                                   hidden:true,
                                   hideLabel:true
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
			                columnWidth:.98,
			                items: [
				                {
					                xtype:'textarea',
			                        fieldLabel:'��ע',
			                        columnWidth:1,
			                        height:38,
			                        anchor:'98%',
			                        name:'Remark',
			                        id:'Remark'
				                }
		                            ]
		                }		                
                    ]} 
           ]
         })
/*------FormPanle�ĺ������� End---------------*/
//�����������첽���÷���
        var dsCustomer = new Ext.data.Store({   
            url: 'frmScmRebateOrder.aspx?method=getCusByConLike',  
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
                        initCustomerInfo(record);
                        this.collapse();//���������б�
                    }
               });
               //��λ����Դ
    var dsWarehousePosList;
    if (dsWarehousePosList == null) { //��ֹ�ظ�����
        dsWarehousePosList = new Ext.data.Store
        ({
            url: 'frmScmRebateOrder.aspx?method=getWarehousePosList',
            reader: new Ext.data.JsonReader({
                totalProperty: 'totalProperty',
                root: 'root'
            }, [
                {
                    name: 'WhpId'
                },
                {
                    name: 'WhpName'
                }
            ])
        });
    }
//�����������첽���÷���,��ǰ���̿ɶ���Ʒ�б�
        var dsProductUnits = new Ext.data.Store({   
            url: 'frmScmRebateOrder.aspx?method=getProductUnits',  
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
        function inserNewBlankRow() {
            var rowCount = userGrid.getStore().getCount();
            var insertPos = parseInt(rowCount);
            var addRow = new RowPattern({
                WhpId:'',
                ProductId:'',
			    Qty:'0',
			    Price:'0',
			    Amt:'0',
			    Tax:'',
			    TaxRate:'0'
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
        function initCustomerInfo( record){     
            Ext.getCmp("CustomerId").setValue(record.data.CustomerId);
            Ext.getCmp("cusno").setValue(record.data.CustomerNo);
            Ext.getCmp("cusname").setValue(record.data.ShortName);
            Ext.getCmp("mobile").setValue(record.data.LinkTel);
            dsProductList.baseParams.CustomerId=record.data.CustomerId;
            dsProductList.load();      
        }
        //�����������첽���÷���,��ǰ���̿ɶ���Ʒ�б�
        var dsProductList = new Ext.data.Store({   
            url: 'frmScmRebateOrder.aspx?method=getCustomProduct',  
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
        //�����Ʒ�������첽���÷���
            var dsProducts;
            if (dsProducts == null) {
                dsProducts = new Ext.data.Store({
                    url: 'frmScmRebateOrder.aspx?method=getProductByNameNo',
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
        // �����������첽������ʾģ��
        var resultPrdTpl = new Ext.XTemplate(  
            '<tpl for="."><div id="productdivid" class="search-item">',  
                '<h3><span>{ProductName}&nbsp</h3>',
            '</div></tpl>'  
        );
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
                sm.set('ProductNo', record.data.ProductNo);
                sm.set('Specifications', record.data.Specifications);
                sm.set('UnitId', record.data.Unit);
                sm.set('ProductId', record.data.ProductId);
                sm.set('ProductName',record.data.ProductName);
                //sm.set('Price',record.data.SalePrice);
                sm.set('TaxRate',record.data.SalesTax);
                setDefaultWhp(sm);
                //sm.set('Price',record.data.Price);
                productCombo.setValue(record.data.ProductId);
                addNewBlankRow();
                
                this.collapse();//���������б�
            }
        });
var productText = new Ext.form.TextField({
    name:"ProductNameTpl",
    id:"ProductNameTpl"});
var strTemplate='<h3><span>{ProductNo}&nbsp;&nbsp;<font color=\"red\">{ProductName}&nbsp;</font></span></h3>';
productText.on("focus",setProductFilter);
var resultTpl = new Ext.XTemplate(  
            '<tpl for="."><div id="searchdivid" class="search-item">',  
                strTemplate,
            '</div></tpl>'  
        ); 
        var productFilterCombo=null;
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
                           sm.set('UnitId', record.data.UnitId);
                           sm.set('Qty','0');
                           sm.set('Tax','0');
                           sm.set('Amt','0');
                          if(spCustomerId == null ||spCustomerId =='')
                          {
                            productText.setValue(record.data.ProductNo);
                                    sm.set('ProductNo', record.data.ProductNo);
                                    sm.set('Specifications', record.data.Specifications);
                                    //sm.set('Unit', record.data.Unit);
                                    sm.set('ProductId', record.data.ProductId);
                                    sm.set('ProductName',record.data.ProductName);
                                    //sm.set('Price',record.data.SalePrice);
                                    //setDefaultWhp(sm);
                                    addNewBlankRow();
                                    this.collapse();
                            return;
                          }
                          //��ȡ��Ʒ�۸���Ϣ
                          Ext.Ajax.request({
		                        url:'frmScmRebateOrder.aspx?method=getProductInfo',
		                        params:{
			                        ProductNo:record.data.ProductNo,
			                        CustomerId:spCustomerId
		                        },
	                        success: function(resp,opts){
	                            //alert(resp.responseText);
	                            if(resp.responseText.length>20){
		                            var data=Ext.util.JSON.decode(resp.responseText); 
		                            
                                    sm.set('ProductNo', record.data.ProductNo);
                                    sm.set('Specifications', data.Specifications);
                                    //sm.set('Unit', data.Unit);
                                    sm.set('ProductId', data.ProductId);
                                    sm.set('ProductName',data.ProductName);
                                    //sm.set('Price',data.SalePrice);
                                    sm.set('TaxRate',data.SalesTax);
                                    if(sm.get('Qty')>0){                                       
                                        sm.set('Amt', accMul(record.data.Qty , data.Price).toFixed(2));
                                        //sm.set('Tax', accMul(record.get('Amt') ,data.TaxRate) ); //Math.Round(3.445, 1);                         
                                        sm.set('Tax', accMul(accDiv(record.get('Amt'),accAdd(1,record.data.TaxRate)) ,record.data.TaxRate).toFixed(2) );
                                    }
                                    //sm.set('Price',record.data.Price);
                                    //productCombo.setValue(data.ProductId);
                                    setDefaultWhp(sm);
                                    addNewBlankRow();
//                                    try
//                                    {
                                        productFilterCombo.collapse();
//                                    }
//                                    catch(err)
//                                    {
//                                    }
                                }
		                    }
		                  });         
            
                    
                }
            });
            }
        }
//��λ
var warehousePosCombo = new Ext.form.ComboBox({
    store: dsWarehousePosList,
    displayField: 'WhpName',
    valueField: 'WhpId',
    triggerAction: 'all',
    id: 'warehousePosCombo',
    typeAhead: true,
    mode: 'local',
    emptyText: '',
    selectOnFocus: false,
    editable: false,
    listeners: {
        "select": addNewBlankRow
    }
});
function setDefaultWhp(record)
{
    if(record.get('WhpId')=='')
    {
        
        if(dsWarehousePosList.getCount()==1)
        {
            record.set('WhpId',dsWarehousePosList.getAt(0).get("WhpId"));
        }
    }
}
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
            id: 'WhpId',
            header: "��λ",
            dataIndex: 'WhpId',
            width: 75,
            editor: warehousePosCombo,
            renderer: function(value, cellmeta, record, rowIndex, columnIndex, store) {
                //���ֵ��ʾ����
                var index = dsWarehousePosList.find(warehousePosCombo.valueField, value);
                var record = dsWarehousePosList.getAt(index);
                var displayText = "";
                if (record == null) {
                    displayText = value;
                } else {
                    displayText = record.data.WhpName; 
                }
                return displayText;
            }         
        },
         {
            id: 'ProductNo',
            header: "��Ʒ����",
            dataIndex: 'ProductNo',
            width: 75,
            editor:productText
        },
        {
            id: 'ProductName',
            header: "��Ʒ����",
            dataIndex: 'ProductName',
            width: 155,
            editor: productCombo,
            renderer: function(value, cellmeta, record, rowIndex, columnIndex, store) {
                 var index = dsProductList.find(productCombo.valueField, value);
                var record = dsProductList.getAt(index);
                var displayText = "";
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
            id: "UnitId",
            header: "��λ",
            dataIndex: "UnitId",
//            editable:false,
            width: 50,
            editor: UnitCombo,
            renderer: function(value, cellmeta, record, rowIndex, columnIndex, store) {
                var index = dsUnitList.findBy(function(record, id) {  
	                return record.get(UnitCombo.valueField)==value; 
                });
                var record = dsUnitList.getAt(index);
                var displayText = "";
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
            width: 50
        }, {
            id: 'Qty',
            header: "����",
            dataIndex: 'Qty',
            width: 55,
		    align: 'right',
            editor: new Ext.form.NumberField({ 
                allowBlank: false,
	            align: 'right',
                decimalPrecision:8,
                listeners: {
	                    'focus': function() {
	                        this.selectText();
	                    }
		        }})
        }, 
        {
            id: 'Price',
            header: "����",
            dataIndex: 'Price',
            width: 55,
		    align: 'right',
            editor: new Ext.form.NumberField({ 
                allowBlank: false,
	            align: 'right',
                decimalPrecision:8,
                listeners: {
		                'focus': function() {
		                    this.selectText();
		            }
		        }})
        },
        {
            id: 'Amt',
            header: "���",
            dataIndex: 'Amt',
            width: 80,
		    align: 'right',
            editor: new Ext.form.NumberField({ 
                allowBlank: false,
	            align: 'right',                
                listeners: {
		                'focus': function() {
		                    this.selectText();
		                }
		            },
		        decimalPrecision:8 })
        },
        {
            id: 'TaxRate',
            header: "˰��",
            editable:false,
		    align: 'right',
            dataIndex: 'TaxRate',
            width: 50
        },
        {
            id: 'Tax',
            header: "˰��",
            editable:false,
		    align: 'right',
            dataIndex: 'Tax',
            width: 70
        },
        new Extensive.grid.ItemDeleter()
        ]);
    cm.defaultSortable = true;

    var RowPattern = Ext.data.Record.create([
           { name: 'RebateDtlId', type: 'string' },
           { name: 'WhpId', type: 'string' },
           { name: 'ProductNo', type: 'string' },
           { name: 'ProductId', type: 'string' },
           { name: 'ProductName', type: 'string' },
           { name: 'UnitId', type: 'string' },
           { name: 'Specifications', type: 'string' },
           { name: 'Qty', type: 'string' },
           { name: 'Price', type: 'string' },
           { name: 'Amt', type: 'float' },
           { name: 'Tax', type: 'string'},
           { name: 'TaxRate', type: 'string'}
          ]);

    var dsOrderProduct;
    if (dsOrderProduct == null) {
        dsOrderProduct = new Ext.data.Store
	        ({
	            url: 'frmScmRebateOrder.aspx?method=getDtlList',
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
        height: 180,
        columnLines:true,
        stripeRows: true,
        frame: true,
        //plugins: USER_ISLOCKEDColumn,
        clicksToEdit: 1,
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
                        if(field=="Amt")
                        {
                            //record.set('Price', accD(record.data.Amt , record.data.Qty,8));
                            record.set('Tax', accMul(accDiv(record.data.Amt,accAdd(1,record.data.TaxRate)) ,record.data.TaxRate).toFixed(2) ); //Math.Round(3.445, 1); 
                            return;
                        }
                        if(field ='Qty' || field=='Price'){
                            //record.set('Amt', accMul(record.data.Qty , record.data.Price).toFixed(2));
                            ///record.set('Tax', accMul(accDiv(record.data.Amt,accAdd(1,record.data.Tax)) ,record.data.Tax).toFixed(2) ); //Math.Round(3.445, 1); 
                        }
                    }
               }

    });
    function accAdd(arg1,arg2){  
        var r1,r2,m;  
        try{r1=arg1.toString().split(".")[1].length}catch(e){r1=0}  
        try{r2=arg2.toString().split(".")[1].length}catch(e){r2=0}  
        m=Math.pow(10,Math.max(r1,r2))  
        return (arg1*m+arg2*m)/m  
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
    function accMul(arg1,arg2)
    {//�����������
        var m=0,s1=arg1.toString(),s2=arg2.toString();
        try{m+=s1.split(".")[1].length}catch(e){}
        try{m+=s2.split(".")[1].length}catch(e){}
        return Number(s1.replace(".",""))*Number(s2.replace(".",""))/Math.pow(10,m)
    }

var footerForm = new Ext.FormPanel({
        renderTo: 'divBotton',
        border: true, // û�б߿�
        labelAlign: 'left',
        buttonAlign: 'center',
        bodyStyle: 'padding:1px',
        height: 20,
        frame: true,
        labelWidth: 55,        
        buttons: [{
            text: "����",
            scope: this,
            id: 'saveButton',
            handler: function() { 
                var whbm = Ext.getCmp('OutStor').getValue();
                if(whbm==undefined||whbm==null||whbm==""||whbm==0)
                {
                    Ext.Msg.alert("��ʾ", "��ָ������ֿ⣡");
                    return;
                }
                  
                json = "";
                for(var i=0;i<dsOrderProduct.getCount();i++)
                {
                    var checkData = dsOrderProduct.getAt(i);
                    if(checkData.data.ProductId!='')
                    {
                        if(checkData.data.WhpId=='')
                        {
                            Ext.Msg.alert("��ʾ","��ѡ���λ��Ϣ");
                            return;
                        }
                    }
                }
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
                     Ext.Msg.alert("��ʾ", "������Ϣ������ѡ����ȷ���̣�");
                     return;
                }
                Ext.MessageBox.wait("�������ڱ��棬���Ժ򡭡�");
                //Ȼ�����������
                Ext.Ajax.request({
                    url: 'frmScmRebateOrder.aspx?method=saveOrder',
                    method: 'POST',
                    params: {
                        //������
                        RebateId:Ext.getCmp('RebateId').getValue(),
		                WhId:Ext.getCmp('OutStor').getValue(),
		                CustomerId:Ext.getCmp('CustomerId').getValue(),
		                FromBillId:Ext.getCmp('FromBillId').getValue(),
		                RebateType:Ext.getCmp('RebateType').getValue(),
		                BusinessType:Ext.getCmp('BusinessType').getValue(),
		                FromBillType:Ext.getCmp('FromBillType').getValue(),
		                Remark:Ext.getCmp('Remark').getValue()	,
		                RebateId:Ext.getCmp('RebateId').getValue(),
                        //��ϸ����
                        DetailInfo: json
                    },
                    success: function(resp,opts){ 
                    Ext.MessageBox.hide();
                                    if( checkParentExtMessage(resp,parent) )
                                         {                                           
                                           parent.usergridDataData.reload();
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
    
this.setFormValues=function(){
        Ext.getCmp("RebateId").setValue(RebateId);
        if (RebateId == 0) {    
            Ext.getCmp("cusno").setDisabled(false);
            Ext.getCmp("BusinessType").setValue('S321');
            Ext.getCmp("RebateType").setValue("S311");
            
            Ext.getCmp("Remark").setValue("");
            Ext.getCmp("FromBillId").setValue("");
            
            Ext.getCmp("CustomerId").setValue("");
            Ext.getCmp("cusno").setValue("");;
            Ext.getCmp("cusname").setValue("");
            Ext.getCmp("mobile").setValue("");
            
            if(dsProductList!=null)
            {
                dsOrderProduct.removeAll();
//                var orderProduct = new dsOrderProduct.recordType({SaleQty:0});
//                dsOrderProduct.add(orderProduct);
                inserNewBlankRow();
            }
        }    
        if (RebateId > 0) {
        
            setFormValue();
            Ext.getCmp("cusno").setDisabled(true);           
            
        }
    }
    
     function setFormValue() {
        Ext.Ajax.request({
            url: 'frmScmRebateOrder.aspx?method=getOrder',
            params: {
                RebateId: RebateId,
                limit:1,
                start:0
            },
            success: function(resp, opts) {           
                var data = Ext.util.JSON.decode(resp.responseText);
		                //Ext.getCmp("OutStor").setValue(data.OutStor);
		                
//		                var curWhId = Ext.getCmp("OutStor").getValue();
                        if(dsWarehousePosList.baseParams.WhId!=data.WhId)
                        {
                            haveEvent = true;
                            dsWarehousePosList.baseParams.WhId=data.WhId;
                            dsWarehousePosList.on('load',loadOrderProduct,this,true);
                            dsWarehousePosList.load();
                            //dsWarehousePosList.un('load',loadOrderProduct,this,true);
                        }
                        else
                        {
                            loadOrderProduct();
                        }
		
		                Ext.getCmp("CustomerId").setValue(data.CustomerId);
		                Ext.getCmp("cusno").setValue(data.CustomerNo);
		                Ext.getCmp("cusname").setValue(data.CustomerName);
		                //Ext.getCmp("mobile").setValue(data.LinkTel);
		                Ext.getCmp("OutStor").setValue(data.WhId);
		                Ext.getCmp("BusinessType").setValue(data.BusinessType);
		                Ext.getCmp("RebateType").setValue(data.RebateType);
		                Ext.getCmp("FromBillType").setValue(data.FromBillType);
		                Ext.getCmp("Remark").setValue(data.Remark);		  
		                Ext.getCmp("FromBillId").setValue(data.FromBillId);
		                //��Ʒ�б�
                        dsProductList.baseParams.CustomerId = data.CustomerId;
                        dsProductList.load();

            },
            failure: function(resp, opts) {
                Ext.Msg.alert("��ʾ", "��ȡ��ʼ���ֿ���Ϣʧ�ܣ�");
            }
        });
    }
    var haveEvent = false;
    function loadOrderProduct()
    {
        if(haveEvent)
        {
            haveEvent = false;
            dsWarehousePosList.un('load',loadOrderProduct,this,true);
        }
        dsOrderProduct.load({
                params: { 
                    start: 0,
                    limit: 100,
                    RebateId: RebateId
                },
                callback: function(r, options, success) {
                    if (success == true) {
                        inserNewBlankRow();
                        }
                    }
                
            });
    }
    inserNewBlankRow();
    setFormValues();
/*------DataGrid�ĺ������� End---------------*/
if(OperType=='query'){
    Ext.getCmp("saveButton").hide();      
    var cm = userGrid.getColumnModel();
    for(var i=0;i<cm.getColumnCount();i++)
        cm.setEditable(i,false);      
    Ext.getCmp("customFind").getEl().dom.readOnly=true;
    Ext.getCmp("OutStor").getEl().dom.readOnly=true;
//      Ext.getCmp("DlvAdd").getEl().dom.readOnly=true;
//      Ext.getCmp("DlvDesc").getEl().dom.readOnly=true;
//      Ext.getCmp("DlvLevel").getEl().dom.readOnly=true;
//      Ext.getCmp("PayType").getEl().dom.readOnly=true;
//      Ext.getCmp("BillMode").getEl().dom.readOnly=true;
//      Ext.getCmp("DlvType").getEl().dom.readOnly=true;
//      Ext.getCmp("IsPayed").getEl().dom.readOnly=true;
//      Ext.getCmp("IsBill").getEl().dom.readOnly=true;
//      Ext.getCmp("Remark").getEl().dom.readOnly=true;
}
})
</script>
</html>
