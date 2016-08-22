<%@ Page Language="C#" AutoEventWireup="true" CodeFile="createOrder.aspx.cs" Inherits="SCM_portel_createOrder" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>��Ʒ��������</title>
    <meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
    <link rel="stylesheet" type="text/css" href="../../ext3/resources/css/ext-all.css" />
    <link rel="stylesheet" type="text/css" href="../../Theme/1/css/salt.css" />
    <script type="text/javascript" src="../../ext3/adapter/ext/ext-base.js"></script>
    <script type="text/javascript" src="../../ext3/ext-all.js"></script>
    <script type="text/javascript" src="../../ext3/example/ItemDeleter.js"></script>
    <script type="text/javascript" src="../../js/operateResp.js"></script>
    <link rel="stylesheet" href="../../css/Ext.ux.grid.GridSummary.css"/>
    <script type="text/javascript" src='../../js/Ext.ux.grid.GridSummary.js'></script>
    <script type="text/javascript" src="../../js/floatUtil.js"></script>
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
    //���Ҫ���Ҳ���key:
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
                 
    
    var initOrderForm = new Ext.form.FormPanel({
           renderTo: 'divForm',
           frame: true,
           monitorValid: true, // ����formBind:true�İ�ť����֤��
           labelWidth: 70,
           items:
           [{
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
                                    mode:'local'   
				                }
		                            ]
		                },{
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
                                   value:dsDlvType.getAt(0).data.DicsCode
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
			                        format:'Y��m��d��',
			                        value:new Date().clearTime()
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
                                   anchor: '98%',
                                   value:dsDlvLevel.getAt(0).data.DicsCode
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
           ]
         })
    
        //-------------------Grid Start-----------------------------
        function inserNewBlankRow() {
            var rowCount = userGrid.getStore().getCount();
            var insertPos = parseInt(rowCount);
            var addRow = new RowPattern({
                ProductId:'',
			    SaleQty:'',
			    SalePrice:'',
			    SaleAmt:'',
			    SaleTax:'',
			    TaxRate:''
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
            url: 'createOrder.aspx?method=getCustomProduct',  
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
                {name: 'TaxRate', mapping: 'TaxRate'}
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
            onSelect: function(record) { alert(1);
                var sm = userGrid.getSelectionModel().getSelected();
                sm.set('ProductCode', record.data.ProductNo);
                sm.set('Specifications', record.data.Specifications);
                sm.set('Unit', record.data.Unit);
                sm.set('ProductId', record.data.ProductId);
                sm.set('ProductName',record.data.ProductName);
                sm.set('SalePrice',record.data.SalePrice);
                sm.set('SaleTax',record.data.SaleTax); 
                sm.set('TaxRate',record.data.TaxRate);
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
            editable:false,
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
            width: 30,
            editor: productSpecCombo,
            renderer: function(value, cellmeta, record, rowIndex, columnIndex, store) {
                //���ֵ��ʾ����
                //��ȡ��ǰid="combo_process"��comboBoxѡ���ֵ
                var index = dsProductSpecList.findBy(function(record, id) {  
	                return record.get(productSpecCombo.valueField)==value; 
                });
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
            editable:false,
            editor: new Ext.form.NumberField({ allowBlank: false,decimalPrecision:8  })
        },
        {
            id: 'SaleAmt',
            header: "���",
            editable:false,
            dataIndex: 'SaleAmt',
            width: 20,
            summaryType: 'sum'
        },
        {
            id: 'TaxRate',
            header: "˰��",
            hideable:false,
            hidden:true,
            dataIndex: 'TaxRate'
        },
        {
            id: 'SaleTax',
            header: "˰��",
            editable:false,
            dataIndex: 'SaleTax',
            width: 20,
            summaryType: 'sum'
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
           { name: 'SaleQty', type: 'float' },
           { name: 'SalePrice', type: 'float' },
           { name: 'SaleAmt', type: 'float' },
           { name: 'SaleTax', type: 'float'},
           { name: 'TaxRate', type: 'float'}
          ]);


    var dsOrderProduct;
    if (dsOrderProduct == null) {
        dsOrderProduct = new Ext.data.Store
	        ({
	            url: 'createOrder.aspx?method=getDtlList',
	            reader: new Ext.data.JsonReader({
	                totalProperty: 'totalProperty',
	                root: 'root'
	            }, RowPattern)
	        });       
    }
    //�ϼ���
    var summary = new Ext.ux.grid.GridSummary();
    var userGrid = new Ext.grid.EditorGridPanel({
        store: dsOrderProduct,
        cm: cm,
        selModel: new Extensive.grid.ItemDeleter(),
        layout: 'fit',
        renderTo: 'divGrid',
        width: '100%',
        height: 210,
        stripeRows: true,
        frame: true,
        plugins:[summary],
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
                        if(field ='SaleQty'){  
                            record.set('SaleAmt', accMul(record.data.SaleQty , record.data.SalePrice));
                            record.set('SaleTax', accMul(record.get('SaleAmt') ,record.get('TaxRate')) ); //Math.Round(3.445, 1); 
                        }
                    }
               }

    });
    /*------��ʼ�������ݵĺ��� Start---------------*/
    function setFormValue() {
        Ext.Ajax.request({
            url: 'createOrder.aspx?method=getOrder',
            params: {
                orderid: OrderId,
                limit:1,
                start:0
            },
            success: function(resp, opts) {           
                var data = Ext.util.JSON.decode(resp.responseText);
                        Ext.getCmp("OrgId").setValue(data.OrgId);
		                Ext.getCmp("SaleDept").setValue(data.DeptId);
		                Ext.getCmp("DlvDate").setValue(new Date(data.DlvDate.replace(/-/g, "/")));
		                Ext.getCmp("DlvAdd").setValue(data.DlvAdd);
		                Ext.getCmp("BillMode").setValue(data.BillMode);
		                Ext.getCmp("DlvType").setValue(data.DlvType);
		                Ext.getCmp("DlvLevel").setValue(data.DlvLevel);
		                Ext.getCmp("IsPayed").setValue(data.IsPayed);
		                Ext.getCmp("IsBill").setValue(data.IsBill);
		                Ext.getCmp("Remark").setValue(data.Remark);		  
		                Ext.getCmp("DlvDesc").setValue(data.DlvDesc);	  
		                Ext.getCmp("SaleInvId").setValue(data.SaleInvId);
		                Ext.getCmp("OutedQty").setValue(data.OutedQty);
		                

            },
            failure: function(resp, opts) {
                Ext.Msg.alert("��ʾ", "��ȡ��Ϣʧ�ܣ�");
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
                    url: 'createOrder.aspx?method=saveOrder',
                    method: 'POST',
                    params: {
                        //������
                        OrderId:Ext.getCmp('OrderId').getValue(),
		                OrgId:Ext.getCmp('OrgId').getValue(),
		                DlvDate:Ext.util.Format.date(Ext.getCmp('DlvDate').getValue(),'Y/m/d'),
		                DlvAdd:Ext.getCmp('DlvAdd').getValue(),
		                DlvDesc:Ext.getCmp('DlvDesc').getValue(),
		                OrderType:'S013',
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
                                          Ext.getCmp('saveButton').setDisabled(true);
                                        }
                                   },
		            failure: function(resp,opts){  Ext.Msg.alert("��ʾ","����ʧ��");     }
                });
                //
            }
        },
                         {
                             text: "�ر�",
                             scope: this,
                             handler: function() {
                                   window.opener=null;
                                   window.open('','_self');
                                   window.close();  
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
        
        Ext.getCmp("BillMode").setValue("S031");
        Ext.getCmp("DlvType").setValue("S041");
        Ext.getCmp("DlvLevel").setValue("S051");
        Ext.getCmp("IsPayed").setValue(0);
        Ext.getCmp("IsBill").setValue(0);

    }
    
    if (OrderId > 0) {
        setFormValue();
        
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
    if(customerID!=0){
        //��Ʒ�б�
        dsProductList.baseParams.CustomerId = customerID;
        dsProductList.load();
        //������ϸ�б�
        dsOrderProduct.baseParams.start  =  0;
        dsOrderProduct.baseParams.limit  =  10;
        dsOrderProduct.baseParams.CustomerId =  customerID;
        dsOrderProduct.baseParams.OrderId  =  0;                        
        dsOrderProduct.baseParams.Type =  "New";//������ʱ��
        dsOrderProduct.load();                        
        
    }
    Ext.getCmp('OrgId').setValue(<% =ZJSIG.UIProcess.ADM.UIAdmUser.OrgID(this)%>);
    Ext.getCmp('OrgId').setDisabled(true);
})

</script>

</html>