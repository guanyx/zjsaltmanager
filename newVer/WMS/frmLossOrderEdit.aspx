<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmLossOrderEdit.aspx.cs" Inherits="WMS_frmLossOrderEdit" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html>
<head>
<title>���絥�༭ҳ��</title><meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<link rel="stylesheet" type="text/css" href="../ext3/resources/css/ext-all.css" />
<script type="text/javascript" src="../ext3/adapter/ext/ext-base.js"></script>
<script type="text/javascript" src="../ext3/ext-all.js"></script>
<script type="text/javascript" src="../ext3/example/TabCloseMenu.js" charset="gb2312"></script>
<script type="text/javascript" src="../ext3/example/ItemDeleter.js"></script>
    <script type="text/javascript" src="../js/operateResp.js"></script>
    <script type="text/javascript" src="../ext3/src/locale/ext-lang-zh_CN.js"></script>
    <script type="text/javascript" src="../js/ProductShowCommon.js"></script>
<style type="text/css">
.extensive-remove {
background-image: url(../Theme/1/images/extjs/customer/cross.gif) ! important;
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
    var UIStatus = args["status"];

    document.title = parent.bName+"���༭ҳ��";
    
    
    var RowPattern = Ext.data.Record.create([
           { name: 'OrderDetailId', type: 'string' },
           { name: 'WhpId', type: 'string' },
           { name: 'ProductId', type: 'string' },
           { name: 'ProductCode', type: 'string' },
           { name: 'ProductName', type: 'string' },
           { name: 'ProductUnit', type: 'string' },
           { name: 'ProductSpec', type: 'string' },
           { name: 'ProductPrice', type: 'string' },
           { name: 'ProductQty', type: 'string' },
           { name: 'UnitId', type: 'string' }
          ]);

function inserNewBlankRow() {
            var rowCount = userGrid.getStore().getCount();
            //alert(rowCount);
            var insertPos = parseInt(rowCount);
            var addRow = new RowPattern({
                WhpId: '',
                ProductId: '',
                ProductCode: '',
                ProductName: '',
                ProductUnit: '',
                ProductSpec: '',
                ProductPrice: '',
                ProductQty: ''
            });
            userGrid.stopEditing();
            //����һ����
            if (insertPos > 0) {
                var rowIndex = dsLossOrderProduct.insert(insertPos, addRow);
                userGrid.startEditing(insertPos, 0);
            }
            else {
                var rowIndex = dsLossOrderProduct.insert(0, addRow);
                userGrid.startEditing(0, 0);
            }
        }
        
    var dsLossOrderProduct;
    var userGrid;
    var dsWarehousePosList;
    
    /*------��ʼ�������ݵĺ��� Start---------------*/
    function setFormValue() {
        Ext.Ajax.request({
            url: 'frmLossOrderEdit.aspx?method=getLossOrderInfo',
            params: {
                OrderId: OrderId
            },
            success: function(resp, opts) {
                var data = Ext.util.JSON.decode(resp.responseText);
                Ext.getCmp("OrderId").setValue(data.OrderId);
                Ext.getCmp("OrgId").setValue(data.OrgId);
                Ext.getCmp("WhId").setValue(data.WhId);
                dsWarehousePosList.load({
                    params: { WhId: data.WhId }
                });
                Ext.getCmp("OperId").setValue(data.OperId);
                Ext.getCmp("Status").setValue(data.Status);
                Ext.getCmp("CreateDate").setValue((new Date(data.CreateDate.replace(/-/g, "/"))));
                Ext.getCmp("Type").setValue(data.Type);
                Ext.getCmp("OriginBillId").setValue(data.OriginBillId);

                Ext.getCmp("Remark").setValue(data.Remark);
            },
            failure: function(resp, opts) {
                Ext.Msg.alert("��ʾ", "��ȡ"+parent.bName+"����Ϣʧ�ܣ�");
            }
        });
    }
    
    function setAllValue()
    {
        userGrid.enable();
         Ext.getCmp("saveButton").show();
         Ext.getCmp("commitButton").show();
        if (OrderId > 0) {
        setFormValue();
        dsLossOrderProduct.load({
            params: { start: 0,
                limit: 10000,
                OrderId: OrderId
            },
            callback: function(r, options, success) {
                if (success == true) {
                    inserNewBlankRow();
                    if (Ext.getCmp("Status").getValue() == 1) {
                        Ext.getCmp("saveButton").hide();
                        Ext.getCmp("commitButton").hide();
                        userGrid.disable();
                    }
                    if (UIStatus == "look") {
                        Ext.getCmp("saveButton").hide();
                        Ext.getCmp("commitButton").hide();
                    }
                }
            }
        });
        } else {
            Ext.getCmp("saveButton").show();
            Ext.getCmp("commitButton").hide();
            Ext.getCmp("OrderId").setValue(OrderId);
                Ext.getCmp("WhId").setValue("");
                Ext.getCmp("OperId").setValue(operId);
                Ext.getCmp("Status").setValue(0);
                Ext.getCmp("CreateDate").setValue(new Date());
                Ext.getCmp("Type").setValue("");
                Ext.getCmp("OriginBillId").setValue("");

                Ext.getCmp("Remark").setValue("");
                dsLossOrderProduct.removeAll();
                inserNewBlankRow();
        }
    }
    /*------��ʼ�������ݵĺ��� End---------------*/
    
    Ext.onReady(function() {


        var lossOrderForm = new Ext.form.FormPanel({
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
                columnWidth: .5,  //����ռ�õĿ�ȣ���ʶΪ20��
                layout: 'form',
                border: false,
                items: [
                    {
                        xtype: 'hidden',
                        fieldLabel: '������',
                        //columnWidth: 1,
                        //anchor: '90%',
                        name: 'OrderId',
                        id: 'OrderId',
                        hide: true
                    }
                    , {
                        xtype: 'hidden',
                        fieldLabel: '��֯�ɣ�',
                        //columnWidth: 1,
                        //anchor: '90%',
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
                        store: dsWarehouseList,
                        mode: 'local',
                        triggerAction: 'all',
                        listeners: {
                            select: function(combo, record, index) {
                                var curWhId = Ext.getCmp("WhId").getValue();
                                dsWarehousePosList.load({
                                    params: {
                                        WhId: curWhId
                                    }
                                });
                            }
                        }
                    }
                ]
            },
            {
                columnWidth: .5,  //����ռ�õĿ�ȣ���ʶΪ20��
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
                    value:<%=ZJSIG.UIProcess.ADM.UIAdmUser.EmployeeID(this) %>,
                    disabled: true
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
                columnWidth: .5,  //����ռ�õĿ�ȣ���ʶΪ20��
                layout: 'form',
                border: false,
                items: [
                    {
                        xtype: 'datefield',
                        fieldLabel: '����ʱ��',
                        columnWidth: 1,
                        anchor: '95%',
                        name: 'CreateDate',
                        id: 'CreateDate',
                        format: 'Y��m��d��',
                        value: new Date(),
                        disabled:true
                    }
                ]
            },
            {
                columnWidth: .5,  //����ռ�õĿ�ȣ���ʶΪ20��
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
            items: [
            {
                columnWidth: .5,  //����ռ�õĿ�ȣ���ʶΪ20��
                layout: 'form',
                border: false,
                items: [
                    {
                        xtype: 'combo',
                        fieldLabel: parent.bName+'����',
                        columnWidth: 1,
                        anchor: '95%',
                        name: 'Type',
                        id: 'Type',
                        displayField: 'DicsName',
                        valueField: 'DicsCode',
                        editable: false,
                        store: dsLossTypeList,
                        mode: 'local',
                        triggerAction: 'all'
                    }
                ]
            },
            {
                columnWidth: .5,  //����ռ�õĿ�ȣ���ʶΪ20��
                layout: 'form',
                border: false,
                items: [
                    {
                        xtype: 'textfield',
                        fieldLabel: 'ԭʼ���ݺ�',
                        columnWidth: 1,
                        anchor: '95%',
                        name: 'OriginBillId',
                        id: 'OriginBillId'
                    }
                ]
            }
            ]
        },
        {
            layout: 'column',   //�����Ԫ��Ϊ����Ϊ�в��ַ�ʽ
            border: false,
            items: [{
                columnWidth: 1,  //����ռ�õĿ�ȣ���ʶΪ20��
                layout: 'form',
                border: false,
                items: [{
                    xtype: 'textarea',
                    fieldLabel: '��ע',
                    columnWidth: 1,
                    anchor: '100%',
                    name: 'Remark',
                    id: 'Remark'
}]
}]
}]
        });


        //alert(Ext.getCmp("OperId").getValue());
        //-------------------Form����-----------------------------



        //-------------------Grid Start-----------------------------

        
        function addNewBlankRow(combo, record, index) {
            var rowIndex = userGrid.getStore().indexOf(userGrid.getSelectionModel().getSelected());
            var rowCount = userGrid.getStore().getCount();
            if ((rowIndex == 0 && rowCount == 1) || rowIndex == rowCount - 1) {
                inserNewBlankRow();
            }
        }

        //��λ����Դ
        
        if (dsWarehousePosList == null) { //��ֹ�ظ�����
            dsWarehousePosList = new Ext.data.Store
            ({
                url: 'frmLossOrderEdit.aspx?method=getWarehousePosList',
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
                url: 'frmLossOrderEdit.aspx?method=getProductCostPrice',
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
        var productUnitCombo = new Ext.form.ComboBox({
            store: dsProductUnitList,
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

        var productCombo = new Ext.form.ComboBox({
            store: dsProductList,
            displayField: 'ProductName',
            valueField: 'ProductId',
            triggerAction: 'all',
            id: 'productCombo',
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
                
                sm.set('ProductCode', record.data.ProductNo);
                sm.set('ProductSpec', record.data.Specifications);
                sm.set('ProductUnit', record.data.Unit);
                sm.set('ProductId', record.data.ProductId);
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
        
        setProductSpec = function(record)
        {
            var sm = userGrid.getSelectionModel().getSelected();
            sm.set('ProductSpec', record.data.UnitSpec);
            UnitCombo.setValue(record.data.UnitId);
            UnitCombo.collapse();
            addNewBlankRow();
        }
        
        /**********************/
        getProductUrl ="../Scm/frmOrderDtl.aspx";
        createProductList();
        this.setProductFilter=function()
        {
            dsProducts.baseParams.WhId=Ext.getCmp('WhId').getValue();
        };
        this.selectedEvent =function (record)
        {
            var curWhId = Ext.getCmp("WhId").getValue();
            if(curWhId < 1){
                alert("����ѡ����ֲֿ⣡");
                return;
            }
            var sm = userGrid.getSelectionModel().getSelected(); 
            productText.setValue(  record.data.ProductNo);                         
            sm.set('ProductCode', record.data.ProductNo);
                            sm.set('ProductName', record.data.ProductName);
                            sm.set('ProductSpec', record.data.SpecificationsText);
                            sm.set('ProductUnit', record.data.UnitText); 
                            sm.set('ProductId', record.data.ProductId);
                            sm.set('UnitId',record.data.Unit);
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
            //hidden: true,
            editor: warehousePosCombo,
            renderer: function(value, cellmeta, record, rowIndex, columnIndex, store) {
                //���ֵ��ʾ����
                //��ȡ��ǰid="combo_process"��comboBoxѡ���ֵ
                var index = dsWarehousePosList.findBy(
                            function(record, id) {
                                return record.get('WhpId') == value;
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
            renderer: function(v, m) {
                m.css = 'x-grid-back-blue';
                return v;
            },
            editor:productText
//            editor: new Ext.form.TextField({ 
//                allowBlank: false,
//                enableKeyEvents: true, 
//                initEvents: function() {  
//                    var keyPress = function(e){  
//                        if (e.getKey() == e.ENTER) {   
//                            var curWhId = Ext.getCmp("WhId").getValue();
//                            if(curWhId < 1){
//                                alert("����ѡ����ֲֿ⣡");
//                                return;
//                            }
//                            var textValue = this.getValue();
//                            var index = dsProductList.findBy(
//                                function(record, id) {
//                                    return record.get('ProductNo') == textValue;
//                                }
//                            );
//                            var record = dsProductList.getAt(index);
//                            var sm = userGrid.getSelectionModel().getSelected();                            
//                            sm.set('ProductCode', record.data.ProductNo);
//                            sm.set('ProductName', record.data.ProductName);
//                            sm.set('ProductSpec', record.data.SpecificationsText);
//                            sm.set('ProductUnit', record.data.UnitText); 
//                            sm.set('ProductId', record.data.ProductId);
//                            addNewBlankRow();
//                            
//                            dsProductCostPrice.load({
//                                params: {
//                                    WhId: curWhId,
//                                    ProductId:record.data.ProductId
//                                },
//                                callback: function(r, options, success) {
//                                    if (success == true) {
//                                    var price = dsProductCostPrice.getAt(0).get("ProductPrice");
//                                    sm.set('ProductPrice', price);
//                                    }
//                                }
//                            });
//                        }  
//                    };  
//                    this.el.on("keypress", keyPress, this);  
//                } 
//            })
        },
        {
            id: 'ProductName',
            header: "��Ʒ",
            dataIndex: 'ProductName',
            width: 65
        },
        {
            id: 'ProductId',
            header: "��Ʒ",
            dataIndex: 'ProductId',
            hidden:true,
            width: 65/*,
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
            }*/
        },

        {
            id: "UnitId",
            header: "��λ",
            dataIndex: "UnitId",
            width: 20,
            editor: UnitCombo,
            renderer: function(value, cellmeta, record, rowIndex, columnIndex, store) {
                //���ֵ��ʾ����
                //��ȡ��ǰid="combo_process"��comboBoxѡ���ֵ
                var index = dsProductUnitList.findBy(
                            function(record, id) {
                                return record.get(UnitCombo.valueField) == value;
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
            header: "����",
            dataIndex: 'ProductPrice',
            width: 20,
            renderer: function(v, m) {
                m.css = 'x-grid-back-blue';
                return v;
            },
            editor: new Ext.form.TextField({ allowBlank: false })
        }, {
            id: 'ProductQty',
            header: "����",
            dataIndex: 'ProductQty',
            width: 20,
            renderer: function(v, m) {
                m.css = 'x-grid-back-blue';
                return v;
            },
            editor: new Ext.form.TextField({ allowBlank: false })
        }, new Extensive.grid.ItemDeleter()
        ]);
    cm.defaultSortable = true;

    
    if (dsLossOrderProduct == null) {
        dsLossOrderProduct = new Ext.data.Store
	        ({
	            url: 'frmLossOrderEdit.aspx?method=getLossOrderProductList',
	            reader: new Ext.data.JsonReader({
	                totalProperty: 'totalProperty',
	                root: 'root'
	            }, RowPattern)
	        });
        //inserNewBlankRow(); //--------------------------------------------------------
    }
    userGrid = new Ext.grid.EditorGridPanel({
        store: dsLossOrderProduct,
        cm: cm,
        selModel: new Extensive.grid.ItemDeleter(),
        layout: 'fit',
        renderTo: 'divGrid',
        width: '100%',
        height: 200,
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
        }
    });
    userGrid.on("beforeedit",beforeEdit,userGrid);
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
        height: 85,
        frame: true,
        labelWidth: 55,
        buttons: [{
            text: "����",
            scope: this,
            id: 'saveButton',
            handler: function() {
                if(!checkUIData()) return;
                
                json = "";
                dsLossOrderProduct.each(function(dsLossOrderProduct) {
                    json += Ext.util.JSON.encode(dsLossOrderProduct.data) + ',';
                });
                json = json.substring(0, json.length - 1);
                //alert(json);
                //alert(Ext.getCmp('InventoryDate').getValue());
                //Ȼ�����������

                Ext.Ajax.request({
                    url: 'frmLossOrderEdit.aspx?method=saveLossOrderInfo',
                    method: 'POST',
                    params: {
                        //������
                        //OrderDetailId:Ext.getCmp("OrderDetailId").getValue(),
                        WhId: Ext.getCmp('WhId').getValue(),
                        OperId: Ext.getCmp('OperId').getValue(),
                        InventoryDate: Ext.util.Format.date(Ext.getCmp('CreateDate').getValue(),'Y/m/d'),
                        Remark: Ext.getCmp('Remark').getValue(),
                        Status: Ext.getCmp("Status").getValue(),
                        OrderId: Ext.getCmp("OrderId").getValue(),
                        Type: Ext.getCmp("Type").getValue(),
                        OriginBillId: Ext.getCmp("OriginBillId").getValue(),
                        BillType:parent.BillType,
                        //��ϸ����
                        DetailInfo: json
                    },
                    success: function(resp, opts) {
                        if(checkParentExtMessage(resp,parent))
                        {
                            Ext.getCmp("saveButton").setDisabled(true);
                            //Ext.getCmp("commitButton").setDisabled(false);
                            //Ext.getCmp("commitButton").show();
                            
                            parent.uploadLossOrderWindow.hide();
                        }
                    }
                , failure: function(resp, opts) {
                    Ext.Msg.alert("��ʾ", "����ʧ�ܣ�");

                }
                });
                //
            }
        },
        {
            text: "����������",
            scope: this,
            id: 'commitButton',
            handler: function() {
                Ext.MessageBox.confirm("��ʾ��Ϣ", "�Ƿ����Ҫ�͸�"+parent.bName+"����Ϣ���������ģ�", function callBack(id) {
                    //�ж��Ƿ�ɾ������
                    if (id == "yes") {
                        if(!checkUIData()) return;
                    
                        json = "";
                        dsLossOrderProduct.each(function(dsLossOrderProduct) {
                            json += Ext.util.JSON.encode(dsLossOrderProduct.data) + ',';
                        });
                        json = json.substring(0, json.length - 1);
                        //alert(json);
                        //ҳ���ύ
                        Ext.Ajax.request({
                            url: 'frmLossOrderEdit.aspx?method=sendCenterByForm',//saveLossOrderInfo&isCommit=1',
                            method: 'POST',
                            params: {
                                //������
                                //OrderDetailId:Ext.getCmp("OrderDetailId").getValue(),
                                WhId: Ext.getCmp('WhId').getValue(),
                                OperId: Ext.getCmp('OperId').getValue(),
                                InventoryDate: Ext.util.Format.date(Ext.getCmp('CreateDate').getValue(),'Y/m/d'),
                                Remark: Ext.getCmp('Remark').getValue(),
                                Status: Ext.getCmp("Status").getValue(),
                                OrderId: Ext.getCmp("OrderId").getValue(),
                                Type: Ext.getCmp("Type").getValue(),
                                OriginBillId: Ext.getCmp("OriginBillId").getValue(),
                                BillType:parent.BillType,
                                //��ϸ����
                                DetailInfo: json
                            },
                            success: function(resp, opts) {
                                if(checkParentExtMessage(resp,parent))
                                {
                                    Ext.getCmp("saveButton").setDisabled(true);
                                    Ext.getCmp("commitButton").setDisabled(true);
                                    
                                    parent.uploadLossOrderWindow.hide();
                                }
                            },
                            failure: function(resp, opts) {
                                Ext.Msg.alert("��ʾ", parent.bName+"�������ύʧ�ܣ�");
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
                                 parent.uploadLossOrderWindow.hide();
                                 lossOrderForm.getForm().reset();
                                 userGrid.getStore().removeAll();
                             }
}]
    });
    footerForm.render();
    Ext.getCmp("OrderId").setValue(OrderId);
    
    /*----------------footerframe----------------*/
        //userGrid.getColumnModel().setEditable(3, false);
        //userGrid.getColumnModel().setEditable(2, false);
//    userGrid.getColumnModel().setEditable(6, false);
    userGrid.getColumnModel().setEditable(7, false);
    //userGrid.getColumnModel().setEditable(7, false);
    //userGrid.getColumnModel().setEditable(8, false);
    
    setAllValue();
function checkUIData(){
    var check = true;
  
    var rowCount = dsLossOrderProduct.getCount();
    var index = 0;
    dsLossOrderProduct.each(function(record,grid){
        if(index<rowCount-1){
            index++;//alert(record.get("WhpId"));
            if(record.get("WhpId") == undefined || record.get("WhpId") == "" ||parseInt(record.get("WhpId"))<1){
                Ext.Msg.alert("��ʾ", "����в�λû��ѡ��");
                check = false;
                return;
            }
           
            if(record.get("ProductQty") == undefined || record.get("ProductQty") ==""){
                Ext.Msg.alert("��ʾ", "���������û����д��");
                check = false;
                return;
            }
            else{
                if(parseFloat(record.get("ProductQty"))<=0){
                    Ext.Msg.alert("��ʾ", "�������������С�ڵ����㣡");
                    check = false;
                    return;
                }
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

