<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmInventoryOrderEdit.aspx.cs" Inherits="WMS_frmInventoryOrderEdit" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html>
<head>
<title>�ֿ��̵�༭ҳ��</title><meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<link rel="stylesheet" type="text/css" href="../ext3/resources/css/ext-all.css" />
<script type="text/javascript" src="../ext3/adapter/ext/ext-base.js"></script>
<script type="text/javascript" src="../ext3/ext-all.js"></script>
<script type="text/javascript" src="../ext3/example/TabCloseMenu.js" charset="gb2312"></script>
<script type="text/javascript" src="../ext3/example/ItemDeleter.js"></script>
<script type="text/javascript" src="../js/operateResp.js"></script>
<script type="text/javascript" src="../ext3/src/locale/ext-lang-zh_CN.js"></script>
<style type="text/css">
    .extensive-remove
    {
        background-image: url(../Theme/1/images/extjs/customer/remove.gif) !important;
    }
    .x-grid-back-blue { 
        background: #C3D9FF; 
    }
</style>
</head>
<body>
<div id='divForm'></div>
<div id='divGrid'></div>
<div id='divBotton'></div>
<div style="display:none">
<select id='comboStatus' >
<option value='0'>�ݸ�</option>
<option value='1'>���ύ</option>
</select></div>
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
    var OrderId = args["id"];
 var OperType = args["type"];


/*------��ʼ�������ݵĺ��� Start---------------*/

var dsInventoryOrderProduct=null;
var dsWarehousePosList = null;

var RowPattern = Ext.data.Record.create([
           { name: 'OrderDetailId', type: 'string' },
           { name: 'WhpId', type: 'string' },
           { name: 'ProductId', type: 'string' },
           { name: 'ProductCode', type: 'string' },
           { name: 'ProductUnit', type: 'string' },
           { name: 'ProductSpec', type: 'string' },
           { name: 'ProductPrice', type: 'string' },
           { name: 'BookQty', type: 'string' },
           { name: 'RealQty', type: 'string' }
          ]);
          
function inserNewBlankRow() {
    var rowCount = dsInventoryOrderProduct.getCount();
    var insertPos = parseInt(rowCount);
    var addRow = new RowPattern({
        WhpId: '',
        ProductId: '',
        ProductCode: '',
        ProductUnit: '',
        ProductSpec: '',
        ProductPrice: '',
        BookQty: '',
        RealQty: ''
    });
    //����һ����
    if (insertPos > 0) {
        var rowIndex = dsInventoryOrderProduct.insert(insertPos, addRow);
        //userGrid.startEditing(insertPos, 0);
    }
    else {
        var rowIndex = dsInventoryOrderProduct.insert(0, addRow);
        //userGrid.startEditing(0, 0);
    }
}
function addNewInventoryOrder()
{
    Ext.getCmp("OrderId").setValue("0");
    Ext.getCmp("OrgId").setValue("0");
    Ext.getCmp("WhId").setValue("");
    
    Ext.getCmp("OperId").setValue(operId);
    Ext.getCmp("Status").setValue("0");
    Ext.getCmp("InventoryDate").setValue(new Date()); ;

    Ext.getCmp("Remark").setValue("");   
    inserNewBlankRow();
    Ext.getCmp("saveButton").show();
    Ext.getCmp("commitButton").show();
    Ext.getCmp("WhId").setDisabled(false);
    Ext.getCmp("commitButton").hide();
}
    function setFormValue() {
        Ext.getCmp("saveButton").setDisabled(false);
         if(dsInventoryOrderProduct!=null)
         {
            dsInventoryOrderProduct.removeAll();
            
         }
         if(dsWarehousePosList!=null)
            {
                dsWarehousePosList.removeAll();
            }
        if(OrderId==0)
        {
            addNewInventoryOrder();
            return;
        }
        Ext.Ajax.request({
            url: 'frmInventoryOrderEdit.aspx?method=getInventoryOrderInfo',
            params: {
                OrderId: OrderId
            },
            success: function(resp, opts) {
                var data = Ext.util.JSON.decode(resp.responseText);
                Ext.getCmp("OrderId").setValue(data.OrderId);
                Ext.getCmp("OrgId").setValue(data.OrgId);
                Ext.getCmp("WhId").setValue(data.WhId);
                
                dsWarehousePosList.load({
                    params:{
                        WhId:data.WhId
                    }
                });
                Ext.getCmp("OperId").setValue(data.OperId);
                Ext.getCmp("Status").setValue(data.Status);
                Ext.getCmp("InventoryDate").setValue((new Date(data.InventoryDate.replace(/-/g, "/")))); ;

                Ext.getCmp("Remark").setValue(data.Remark);
                
                dsInventoryOrderProduct.load({
                    params: { start: 0,
                        limit: 1000,
                        OrderId: OrderId
                    },
                    callback: function(r, options, success) {
                        if (success == true) {
                        Ext.getCmp("WhId").setDisabled(true);
                            inserNewBlankRow();
                            if (Ext.getCmp("Status").getValue() == 1) {
                                Ext.getCmp("saveButton").hide();
                                Ext.getCmp("commitButton").hide();
                                userGrid.disable();
                            }
                            else{
                                Ext.getCmp("saveButton").show();
                                Ext.getCmp("commitButton").show();
                            }
                        }
                    }
                });
            },
            failure: function(resp, opts) {
                Ext.Msg.alert("��ʾ", "��ȡ�ֿ��̵���Ϣʧ�ܣ�");
            }
        });
    }
    /*------��ʼ�������ݵĺ��� End---------------*/
    
    Ext.onReady(function() {
        var initWarehouseForm = new Ext.form.FormPanel({
            url: '',
            renderTo: 'divForm',
            frame: true,
            title: '',
            items: [
            {
                layout: 'column',   //�����Ԫ��Ϊ����Ϊ�в��ַ�ʽ
                border: false,
                items: [
            {
                columnWidth: .5,  //����ռ�õĿ��ȣ���ʶΪ20��
                layout: 'form',
                border: false,
                items: [
                    {
                        xtype: 'hidden',
                        fieldLabel: '������',
                        name: 'OrderId',
                        id: 'OrderId',
                        hide: true
                    }
                    , {
                        xtype: 'hidden',
                        fieldLabel: '��֯�ɣ�',
                        name: 'OrgId',
                        id: 'OrgId',
                        hide: true
                    }
                    , {
                        xtype: 'combo',
                        fieldLabel: '�ֿ�����',
                        columnWidth: 1,
                        anchor: '95%',
                        name: 'WhId',
                        id: 'WhId',
                        displayField: 'WhName',
                        valueField: 'WhId',
                        editable: false,
                        store: dsNeedInitWarehouseList,
                        mode: 'local',
                        triggerAction: 'all',
                        listeners: {
                            select: function(combo, record, index) {
                                if(OrderId>0)
                                {
                                    dsInventoryOrderProduct.proxy.conn.url='frmInventoryOrderEdit.aspx?method=getInventoryOrderProductList';
                                }
                                else
                                {
                                    dsInventoryOrderProduct.proxy.conn.url='frmInventoryOrderEdit.aspx?method=getCurrenStockByWarehouse';
                                }
                                var curWhId = Ext.getCmp("WhId").getValue();
                                dsWarehousePosList.load({
                                    params: {
                                        WhId: curWhId
                                    },
                                    callback:function(rec,opt,flag){
                                        dsInventoryOrderProduct.load({
                                            params: {
                                                start: 0,
                                                limit: 1000,
                                                WhId: curWhId
                                            },
                                            callback: function(r, options, success) {
                                                if (success == true) {
                                                    inserNewBlankRow();
                                                }
                                            }
                                        });                                   
                                    
                                    }
                                });
                                
                                
                            }
                        }
                    }
                ]
            },
            {
                columnWidth: .5,  //����ռ�õĿ��ȣ���ʶΪ20��
                layout: 'form',
                border: false,
                items: [
                {
                    xtype: 'combo',
                    fieldLabel: '������',
                    columnWidth: 1,
                    anchor: '95%',
                    name: 'OperId',
                    id: 'OperId',
                    displayField: 'EmpName',
                    valueField: 'EmpId',
                    editable: false,
                    store: dsOperationList,
                    mode: 'local',
                    triggerAction: 'all',
                    value: <%=ZJSIG.UIProcess.ADM.UIAdmUser.EmployeeID(this) %>,
                    disabled: true,
                    listeners: {}
                }
                ]
            }
            ]
            },
        {
            layout: 'column',   //�����Ԫ��Ϊ����Ϊ�в��ַ�ʽ
            border: false,
            items: [
            {
                columnWidth: .5,  //����ռ�õĿ��ȣ���ʶΪ20��
                layout: 'form',
                border: false,
                items: [
                    {
                        xtype: 'datefield',
                        fieldLabel: '�̵�ʱ��',
                        columnWidth: 1,
                        anchor: '95%',
                        name: 'InventoryDate',
                        id: 'InventoryDate',
                        format: 'Y��m��d��',
                        value: new Date(),
                        disabled: true
                    }
                ]
            },
            {
                columnWidth: .5,  //����ռ�õĿ��ȣ���ʶΪ20��
                layout: 'form',
                border: false,
                items: [
                    {
                        xtype: 'combo',
                        fieldLabel: '״̬',
                        columnWidth: 1,
                        anchor: '95%',
                        name: 'Status',
                        id: 'Status',
                        transform: 'comboStatus',
                        //readOnly: true,
                        disabled: true,
                        typeAhead: false,
                        triggerAction: 'all',
                        lazyRender: true,
                        editable: false
                    }
                ]
            }
            ]
        },
        {
            layout: 'column',   //�����Ԫ��Ϊ����Ϊ�в��ַ�ʽ
            border: false,
            items: [{
                columnWidth: 1,  //����ռ�õĿ��ȣ���ʶΪ20��
                layout: 'form',
                border: false,
                items: [{
                    xtype: 'textarea',
                    fieldLabel: '��ע',
                    columnWidth: 1,
                    anchor: '100%',
                    height: 50,
                    name: 'Remark',
                    id: 'Remark'
}]
}]
}]
        });

        //-------------------Form����-----------------------------


//�����Ʒ�������첽���÷���
            var dsProducts;
            if (dsProducts == null) {
                dsProducts = new Ext.data.Store({
                    url: 'frmInventoryOrderEdit.aspx?method=getProductByNameNo',
                    reader: new Ext.data.JsonReader({
                        root: 'root',
                        totalProperty: 'totalProperty'
                    }, [
                            { name: 'ProductId', mapping: 'ProductId' },
                            { name: 'ProductNo', mapping: 'ProductNo' },
                            { name: 'ProductName', mapping: 'ProductName' },
                            { name: 'Unit', mapping: 'Unit' },
                            { name: 'SalePriceLower', mapping: 'SalePriceLower' },
                            { name: 'SalePriceLimit', mapping: 'SalePriceLimit' },
                            { name: 'UnitText', mapping: 'UnitText' },
                            { name: 'Specifications', mapping: 'Specifications' },
                            { name: 'SpecificationsText', mapping: 'SpecificationsText' }
                        ])
                });
            }            

        //-------------------Grid Start-----------------------------

        
        function addNewBlankRow(combo, record, index) {
            var rowIndex = userGrid.getStore().indexOf(userGrid.getSelectionModel().getSelected());
            var rowCount = userGrid.getStore().getCount();
            if ((rowIndex == 0 && rowCount == 1) || rowIndex == rowCount - 1) {
                inserNewBlankRow();
            }
        }

        //��λ����Դ
//        var dsWarehousePosList;
        if (dsWarehousePosList == null) { //��ֹ�ظ�����
            dsWarehousePosList = new Ext.data.Store
            ({
                url: 'frmInventoryOrderEdit.aspx?method=getWarehousePosList',
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
        var dsProductCostPrice;
        if( dsProductCostPrice == null){
            dsProductCostPrice = new Ext.data.Store
            ({
                url: 'frmInventoryOrderEdit.aspx?method=getProductCostPrice',
                reader: new Ext.data.JsonReader({
                    totalProperty: 'totalProperty',
                    root: 'root'
                }, [
	                {
	                    name: 'ProductPrice'
	                }
                ])
            });
        }
        //�����������첽���÷���,��ǰ�ͻ��ɶ���Ʒ�б�
        var dsProductUnits = new Ext.data.Store({   
            url: 'frmInventoryOrderEdit.aspx?method=getProductUnits',  
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
        var productUnitCombo = new Ext.form.ComboBox({
            store:dsProductUnits,
            //store: dsProductUnitList,
            displayField: 'UnitName',
            valueField: 'UnitId',
            triggerAction: 'all',
            id: 'productUnitCombo',
            typeAhead: true,
            mode: 'local',
            emptyText: '',
            selectOnFocus: false,
            editable: false,
            listeners: {
                "select": addNewBlankRow
            }
        });
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

        var productText = new Ext.form.TextField({
            name:"ProductName",
            id:"ProductName"});
        
        productText.on("focus",setProductFilter);
        
        var productFilterCombo=null;
        
        // �����������첽������ʾģ��
        var resultTpl = new Ext.XTemplate(  
            '<tpl for="."><div id="searchdivid" class="search-item">',  
                '<h3><span>���:{ProductNo}&nbsp;  ����:{ProductName}</span></h3>',
            '</div></tpl>'  
        ); 
        
        function setProductFilter()
        {
            if(productFilterCombo==null)
            {
                productFilterCombo = new Ext.form.ComboBox({
                store: dsProducts,
                displayField: 'ProductName',
                displayValue: 'ProductId',
                typeAhead: false,
                minChars: 1,
                width:300,
                loadingText: 'Searching...',
                tpl: resultTpl,  
                itemSelector: 'div.search-item',  
                pageSize: 10,
                hideTrigger: true,
                applyTo: 'ProductName',
                onSelect: function(record) { // override default onSelect to do redirect  
                    var sm = userGrid.getSelectionModel().getSelected();
                var curWhId = Ext.getCmp("WhId").getValue();
                if(curWhId < 1){
                    alert("����ѡ��ֿ⣡");
                    return;
                }
                dsProductUnits.baseParams.ProductId = record.data.ProductId;
                dsProductUnits.load();
                sm.set('ProductUnit', record.data.Unit);
               
                sm.set('ProductCode', record.data.ProductNo);
                sm.set('ProductSpec', record.data.Specifications);
                //sm.set('ProductUnit', record.data.Unit);
                sm.set('ProductId', record.data.ProductId);
                sm.set('BookQty',0);
                addNewBlankRow();
                
                dsProductCostPrice.load({
                    params: {
                        WhId: curWhId,
                        ProductId:record.data.ProductId
                    },
                    callback: function(r, options, success) {
                        if (success == true) {
                        var price = dsProductCostPrice.getAt(0).get("ProductPrice");
                        sm.set('ProductPrice', price);
                        }
                    }
                });
            
                    this.collapse();
                }
            });
            }
        }
        
        var productCombo = new Ext.form.ComboBox({
            store: dsProductList,
            displayField: 'ProductName',
            valueField: 'ProductId',
            triggerAction: 'all',
            id: 'productCombo',
            //pageSize: 5,
            //minChars: 2,
            //hideTrigger: true,
            typeAhead: true,
            mode: 'local',
            emptyText: '',
            selectOnFocus: false,
            editable: true,
            onSelect: function(record) {
                var sm = userGrid.getSelectionModel().getSelected();
                var curWhId = Ext.getCmp("WhId").getValue();
                if(curWhId < 1){
                    alert("����ѡ��ֿ⣡");
                    return;
                }
                dsProductUnits.baseParams.ProductId = record.data.ProductId;
                dsProductUnits.load();
                sm.set('ProductUnit', record.data.Unit);
                
                sm.set('ProductCode', record.data.ProductNo);
                sm.set('ProductSpec', record.data.Specifications);
                //sm.set('ProductUnit', record.data.StoreUnitId);
                sm.set('ProductId', record.data.ProductId);
                sm.set('BookQty',0);
                addNewBlankRow();
                
                dsProductCostPrice.load({
                    params: {
                        WhId: curWhId,
                        ProductId:record.data.ProductId
                    },
                    callback: function(r, options, success) {
                        if (success == true) {
                        var price = dsProductCostPrice.getAt(0).get("ProductPrice");
                        sm.set('ProductPrice', price);
                        }
                    }
                });
            }
        });
        var cm = new Ext.grid.ColumnModel([
        new Ext.grid.RowNumberer(), //�Զ��к�
        {
        id: 'OrderDetailId',
        header: "������ϸID",
        dataIndex: 'OrderDetailId',
        width: 30,
        hidden: true,
        editor: new Ext.form.TextField({ allowBlank: false })
    },
        {
            id: 'WhpId',
            header: "��λ",
            dataIndex: 'WhpId',
            width: 20,
            editor: warehousePosCombo,
            renderer: function(value, cellmeta, record, rowIndex, columnIndex, store) {
                //���ֵ��ʾ����
                var index = dsWarehousePosList.findBy(
                        function(record, id) {
                            return record.get(warehousePosCombo.valueField) == value;
                        }
                    );
                var record = dsWarehousePosList.getAt(index);
                var displayText = "";
                // ��������б�û�б�ѡ����ôrecordҲ�Ͳ����ڣ���ʱ�򣬷��ش�������value��
                // �����value����grid��USER_REALNAME�е�value������ֱ�ӷ���
                if (record == null) {
                    //����Ĭ��ֵ��
                    displayText = value;
                } else {
                    displayText = record.data.WhpName; //��ȡrecord�е����ݼ��е�process_name�ֶε�ֵ
                }
                 cellmeta.css = 'x-grid-back-blue';
                return displayText;
            }
        }, {
            id: 'ProductCode',
            header: "����",
            dataIndex: 'ProductCode',
            width: 30,
            editor: productText//new Ext.form.TextField({ allowBlank: false })
        },
        {
            id: 'ProductId',
            header: "��Ʒ",
            dataIndex: 'ProductId',
            width: 65,
            editor: productCombo,
            renderer: function(value, cellmeta, record, rowIndex, columnIndex, store) {
                //���ֵ��ʾ����
                //��ȡ��ǰid="combo_process"��comboBoxѡ���ֵ
                var index = dsProductList.findBy(
                        function(record, id) {
                            return record.get(productCombo.valueField) == value;
                        }
                    );
                var record = dsProductList.getAt(index);
                var displayText = "";
                // ��������б�û�б�ѡ����ôrecordҲ�Ͳ����ڣ���ʱ�򣬷��ش�������value��
                // �����value����grid��USER_REALNAME�е�value������ֱ�ӷ���
                if (record == null) {
                    //����Ĭ��ֵ��
                    displayText = value;
                } else {
                    displayText = record.data.ProductName; //��ȡrecord�е����ݼ��е�process_name�ֶε�ֵ
                    //alert(record.data.ProductName); alert(record.data.ProductId);
                }
                 cellmeta.css = 'x-grid-back-blue';
                return displayText;
            }
        },

        {
            id: "ProductUnit",
            header: "��λ",
            dataIndex: "ProductUnit",
            width: 20,
            editor: productUnitCombo,
            renderer: function(value, cellmeta, record, rowIndex, columnIndex, store) {
                //���ֵ��ʾ����
                //��ȡ��ǰid="combo_process"��comboBoxѡ���ֵ
                var index = dsProductUnitList.findBy(
                            function(record, id) {
                                return record.get(productUnitCombo.valueField) == value;
                            }
                        );
                var record = dsProductUnitList.getAt(index);
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
            id: 'ProductSpec',
            header: "���",
            dataIndex: 'ProductSpec',
            width: 30,
            editor: productSpecCombo,
            renderer: function(value, cellmeta, record, rowIndex, columnIndex, store) {
                //���ֵ��ʾ����
                //��ȡ��ǰid="combo_process"��comboBoxѡ���ֵ
                var index = dsProductSpecList.findBy(
                            function(record, id) {
                                return record.get(productSpecCombo.valueField) == value;
                            }
                        );
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
            id: 'ProductPrice',
            header: "�ɱ��۸�",
            dataIndex: 'ProductPrice',
            width: 30,
            editor: new Ext.form.TextField({ allowBlank: false })
        }, {
            id: 'BookQty',
            header: "��������",
            dataIndex: 'BookQty',
            width: 30,
            editor: new Ext.form.TextField({ allowBlank: false })
        }, {
            id: 'RealQty',
            header: "�̵�����",
            dataIndex: 'RealQty',
            width: 30,
            renderer: function(v, m) {
                m.css = 'x-grid-back-blue';
                return v;
            },
            editor: new Ext.form.TextField({ allowBlank: false,
                    listeners: {
                        'focus': function() {
                            this.selectText();
                        }
                    }
                 })
        }, new Extensive.grid.ItemDeleter()
        ]);
    cm.defaultSortable = true;

    

    var RowPattern_Stock = Ext.data.Record.create([
           { name: 'WhpId', type: 'string' },
           { name: 'ProductId', type: 'string' },
           { name: 'ProductCode', type: 'string' },
           { name: 'ProductUnit', type: 'string' },
           { name: 'ProductSpec', type: 'string' },
           { name: 'ProductPrice', type: 'string' },
           { name: 'BookQty', type: 'string' },
           { name: 'RealQty', type: 'string' }
          ]);

//    var dsInventoryOrderProduct;
    if (dsInventoryOrderProduct == null) {

        //alert(OrderId);
        if (OrderId > 0) {
            dsInventoryOrderProduct = new Ext.data.Store
	        ({
	            url: 'frmInventoryOrderEdit.aspx?method=getInventoryOrderProductList',
	            reader: new Ext.data.JsonReader({
	                totalProperty: 'totalProperty',
	                root: 'root'
	            }, RowPattern)
	        });
        }
        else {
            dsInventoryOrderProduct = new Ext.data.Store
	        ({
	            url: 'frmInventoryOrderEdit.aspx?method=getCurrenStockByWarehouse',
	            reader: new Ext.data.JsonReader({
	                totalProperty: 'totalProperty',
	                root: 'root'
	            }, RowPattern_Stock)
	        });
        }
        //inserNewBlankRow(); //--------------------------------------------------------
    }
    var userGrid = new Ext.grid.EditorGridPanel({
        store: dsInventoryOrderProduct,
        cm: cm,
        selModel: new Extensive.grid.ItemDeleter(),
        layout: 'fit',
        renderTo: 'divGrid',
        width: '100%',
        height: 245,
        //autoHeight: true,
        stripeRows: true,
        frame: true,
        clicksToEdit: 1,
        viewConfig: {
            columnsText: '��ʾ����',
            scrollOffset: 20,
            sortAscText: '����',
            sortDescText: '����',
            forceFit: true
        }
    });
    
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
    //-------------------Grid End-------------------------------
    inserNewBlankRow(); //GridĬ�ϳ�ʼ��
    /*----------------footerframe----------------*/
    //��grid��ϸ��¼��װ��json���ύ��UI��decode
    var json = '';
    var footerForm = new Ext.FormPanel({
        el: 'divBotton',
        border: true, // û�б߿�
        labelAlign: 'left',
        buttonAlign: 'center',
        bodyStyle: 'padding:2px',
        height: 55,
        frame: true,
        labelWidth: 55,
        buttons: [{
            text: "����",
            scope: this,
            id: 'saveButton',
            handler: function() {
                if(!checkUIData()) return;
                json = "";
                dsInventoryOrderProduct.each(function(dsInventoryOrderProduct) {
                    json += Ext.util.JSON.encode(dsInventoryOrderProduct.data) + ',';
                });
                json = json.substring(0, json.length - 1);
                //alert(json);
                //alert(Ext.getCmp('InventoryDate').getValue());
                //Ȼ�����������
                Ext.MessageBox.wait("���������ύ�����Ժ򡭡�");
                Ext.Ajax.request({
                    url: 'frmInventoryOrderEdit.aspx?method=saveInventoryOrderInfo',
                    method: 'POST',
                    params: {
                        //������
                        WhId: Ext.getCmp('WhId').getValue(),
                        OperId: Ext.getCmp('OperId').getValue(),
                        InventoryDate: Ext.util.Format.date(Ext.getCmp('InventoryDate').getValue(),'Y/m/d'),
                        Remark: Ext.getCmp('Remark').getValue(),
                        Status: Ext.getCmp("Status").getValue(),
                        OrderId: Ext.getCmp("OrderId").getValue(),
                        IsInitBill:1,//�̵�
                        //��ϸ����
                        DetailInfo: json
                    },
                    success: function(resp, opts) {
                        Ext.MessageBox.hide();
                        if (checkParentExtMessage(resp,parent)) {
                            Ext.getCmp("saveButton").setDisabled(true);
                            parent.uploadOrderWindow.hide();
                        }

                    }
                });
            }
        },
        {
            text: "�ύ",
            scope: this,
            id: 'commitButton',
            handler: function() {
                Ext.MessageBox.confirm("��ʾ��Ϣ", "�Ƿ����Ҫ�ύ���̵㵥��Ϣ��", function callBack(id) {
                    //�ж��Ƿ�ɾ������
                    if (id == "yes") {
                        if(!checkUIData()) return;
                        json = "";
                        dsInventoryOrderProduct.each(function(dsInventoryOrderProduct) {
                            json += Ext.util.JSON.encode(dsInventoryOrderProduct.data) + ',';
                        });
                        json = json.substring(0, json.length - 1);
                        //alert(json);
                        //ҳ���ύ
                        Ext.Ajax.request({
                            url: 'frmInventoryOrderEdit.aspx?method=commitInventoryOrderInfo',
                            method: 'POST',
                            params: {
                                //������
                                //OrderDetailId:Ext.getCmp("OrderDetailId").getValue(),
                                WhId: Ext.getCmp('WhId').getValue(),
                                OperId: Ext.getCmp('OperId').getValue(),
                                InventoryDate: Ext.util.Format.date(Ext.getCmp('InventoryDate').getValue(),'Y/m/d'),
                                Remark: Ext.getCmp('Remark').getValue(),
                                Status: Ext.getCmp("Status").getValue(),
                                OrderId: Ext.getCmp("OrderId").getValue(),
                                IsInitBill: 1, //�̵�
                                //��ϸ����
                                DetailInfo: json
                            },
                            success: function(resp, opts) {
                                 if (checkParentExtMessage(resp,parent)) {
                                    Ext.getCmp("saveButton").setDisabled(true);
                                    Ext.getCmp("commitButton").setDisabled(true);
                                    
                                    parent.uploadOrderWindow.hide();
                                }
                            }
                        });
                    }
                });
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
    footerForm.render();
    Ext.getCmp("OrderId").setValue(OrderId);
    if (OrderId > 0) {
        setFormValue();
        //alert("ddd");
        userGrid.getColumnModel().setHidden(10, true);
        
    } else {
        Ext.getCmp("commitButton").hide();
    }
    //userGrid.getColumnModel().setEditable(3, false);
    userGrid.getColumnModel().setEditable(5, false);
    userGrid.getColumnModel().setEditable(6, false);
    //userGrid.getColumnModel().setEditable(7, false);
    userGrid.getColumnModel().setEditable(8, false);
    /*----------------footerframe----------------*/
    
     if(OperType == "look"){
        Ext.getCmp("commitButton").hide();
        Ext.getCmp("saveButton").hide();
    }
    
    function checkUIData(){
    var check = true;
    if(Ext.getCmp("WhId").getValue()==""){
        Ext.Msg.alert("��ʾ","����ѡ���̵�ֿ⣡");
        return;
    }
    var rowCount = dsInventoryOrderProduct.getCount();
    var index = 0;
    dsInventoryOrderProduct.each(function(record,grid){
        if(index<rowCount-1){
            index++;//alert(record.get("WhpId"));
            if(record.get("WhpId") == undefined || record.get("WhpId") == "" ||parseInt(record.get("WhpId"))<1){
                Ext.Msg.alert("��ʾ", "����в�λû��ѡ��");
                check = false;
                return;
            }
           
            if(record.get("RealQty") == undefined || record.get("RealQty") ==""){
                Ext.Msg.alert("��ʾ", "���������û����д��");
                check = false;
                return;
            }
            else{
//                if(parseFloat(record.get("RealQty"))<=0){
//                    Ext.Msg.alert("��ʾ", "�������������С�ڵ����㣡");
//                    check = false;
//                    return;
//                }
            }
            if(record.get("ProductId") == undefined || record.get("ProductId") == "" || parseInt(record.get("ProductId"))<=0){
                Ext.Msg.alert("��ʾ", "�������Ʒû��ѡ��");
                check = false;
                return;
            }
            
        }
    });
    if(rowCount == 1){
        Ext.Msg.alert("��ʾ","��ѡ����Ʒ��¼��");
        return false;
    }
    return check;
}
})

</script>

</html>
