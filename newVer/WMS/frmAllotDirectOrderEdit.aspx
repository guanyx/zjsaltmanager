<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmAllotDirectOrderEdit.aspx.cs" Inherits="WMS_frmAllotDirectOrderEdit" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
 
<html>
<head>
<title>�ֿ�������༭ҳ��</title><meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<link rel="stylesheet" type="text/css" href="../ext3/resources/css/ext-all.css" />
<script type="text/javascript" src="../ext3/adapter/ext/ext-base.js"></script>
<script type="text/javascript" src="../ext3/ext-all.js"></script>
<script type="text/javascript" src="../ext3/example/TabCloseMenu.js" charset="gb2312"></script>
<script type="text/javascript" src="../ext3/example/ItemDeleter.js"></script>
<script type="text/javascript" src="../js/operateResp.js"></script>
<script type="text/javascript" src="../ext3/src/locale/ext-lang-zh_CN.js"></script>
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
    var OperType = args["type"];


    var dsAllotOrderProduct;

    Ext.onReady(function() {
        var dsDriverList; 
        if (dsDriverList == null) { //��ֹ�ظ�����
            dsDriverList = new Ext.data.JsonStore({
                totalProperty: "result",
                root: "root",
                url: 'frmAllotDirectOrderEdit.aspx?method=getDriverListByOrg',
                fields: ['DriverId', 'DriverName']
            });
            dsDriverList.load({params:{limit:3252,start:0}});
        }
        var dsWarehouseOutList; 
        if (dsWarehouseOutList == null) { //��ֹ�ظ�����
            dsWarehouseOutList = new Ext.data.JsonStore({
                totalProperty: "result",
                root: "root",
                url: 'frmAllotDirectOrderEdit.aspx?method=getWarehouseListByOrg',
                fields: ['WhId', 'WhName']
            });
            dsWarehouseOutList.baseParams.forbusi = true;

        }
        var dsWarehouseInList; 
        if (dsWarehouseInList == null) { //��ֹ�ظ�����
            dsWarehouseInList = new Ext.data.JsonStore({
                totalProperty: "result",
                root: "root",
                url: 'frmAllotDirectOrderEdit.aspx?method=getWarehouseListByOrg',
                fields: ['WhId', 'WhName']
            });
            dsWarehouseInList.baseParams.forbusi = true;

        }
        var curOrgId = <% =ZJSIG.UIProcess.ADM.UIAdmUser.OrgID(this)%>;
        
        var AllotOrderForm = new Ext.form.FormPanel({
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
                        name: 'OrderId',
                        id: 'OrderId',
                        hide: true
                    }
                    , {
                        xtype: 'hidden',
                        fieldLabel: '��֯',
                        name: 'OrgId',
                        id: 'OrgId',
                        hide: true,
                        value:<%=ZJSIG.UIProcess.ADM.UIAdmUser.DeptID(this)%>
                    }
                    , {
                        xtype: 'combo',
                        fieldLabel: '���뵥λ',
                        columnWidth: 1,
                        anchor: '95%',
                        name: 'InOrg',
                        id: 'InOrg',
                        displayField: 'OrgName',
                        valueField: 'OrgId',
                        editable: false,
                        store: dsOrgList,
                        mode: 'local',
                        triggerAction: 'all',
                        listeners: {
                            select: function(combo, record, index) {
                                var inOrgId = Ext.getCmp("InOrg").getValue();
                                var outOrgId = Ext.getCmp("OutOrg").getValue();
                                if(inOrgId == outOrgId){
                                    Ext.Msg.alert("��ʾ","���뵥λ���ܺ͵�����λ��ͬ��");
                                    Ext.getCmp("InOrg").setValue("");
                                } 
                                dsWarehouseInList.load({params:{OrgId:inOrgId}});
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
                    fieldLabel: '����ֿ�',
                    columnWidth: 1,
                    anchor: '95%',
                    name: 'InWhId',
                    id: 'InWhId',
                    store: dsWarehouseInList,
                    displayField: 'WhName',
                    valueField: 'WhId',
                    editable: false,
                    mode: 'local'
                    //triggerAction: 'all'
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
                        fieldLabel: '������λ',
                        columnWidth: 1,
                        anchor: '95%',
                        name: 'OutOrg',
                        id: 'OutOrg',
                        displayField: 'OrgName',
                        valueField: 'OrgId',
                        editable: false,
                        store: dsOrgList,
                        mode: 'local',
                        triggerAction: 'all',
                        listeners: {
                            select: function(combo, record, index) {
                               var OutOrg = Ext.getCmp("OutOrg").getValue();
                                dsWarehouseOutList.load({params:{OrgId:OutOrg}});
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
                        fieldLabel: '�����ֿ�',
                        columnWidth: 1,
                        anchor: '95%',
                        name: 'OutWhId',
                        id: 'OutWhId',
                        displayField: 'WhName',
                        valueField: 'WhId',
                        editable: false,
                        store: dsWarehouseOutList,
                        mode: 'local',
                        triggerAction: 'all'
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
                    fieldLabel: '������',
                    columnWidth: 1,
                    anchor: '95%',
                    name: 'OperId',
                    id: 'OperId',
                    store:dsOperationList,
			        mode:'local',
			        displayField:'EmpName',
			        valueField:'EmpId',
			        //triggerAction: 'all',
			        editable:false,
			        value:<%=ZJSIG.UIProcess.ADM.UIAdmUser.EmployeeID(this) %>,
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
                        fieldLabel: '��ʻԱ',
                        columnWidth: 1,
                        anchor: '95%',
                        name: 'DriverId',
                        id: 'DriverId',
                        displayField: 'DriverName',
                        valueField: 'DriverId',
                        typeAhead: false,
                        triggerAction: 'all',
                        lazyRender: true,
                        editable: true,
                        store:dsDriverList,
                        mode: 'local'
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
                        fieldLabel: '����״̬',
                        columnWidth: 1,
                        anchor: '95%',
                        name: 'OutStatus',
                        id: 'OutStatus',
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

        function inserNewBlankRow() {
            var rowCount = userGrid.getStore().getCount();
            //alert(rowCount);
            var insertPos = parseInt(rowCount);
            var addRow = new RowPattern({
                //WhpId: '',
                ProductId: '',
                ProductCode: '',
                ProductUnit: '',
                ProductSpec: '',
                ProductPrice: '',
                OutQty: ''//,
                //CREATE_DATE: (new Date()).clearTime() 
            });
            userGrid.stopEditing();
            //����һ����
            if (insertPos > 0) {
                var rowIndex = dsAllotOrderProduct.insert(insertPos, addRow);
                userGrid.startEditing(insertPos, 0);
            }
            else {
                var rowIndex = dsAllotOrderProduct.insert(0, addRow);
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

        var dsProductCostPrice;
        if( dsProductCostPrice == null){
            dsProductCostPrice = new Ext.data.Store
            ({
                url: 'frmAllotOrderEdit.aspx?method=getProductCostPrice',
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
                var curWhId = Ext.getCmp("OutWhId").getValue();
                if(curWhId < 1){
                    alert("����ѡ����ֲֿ⣡");
                    return;
                }
                sm.set('ProductCode', record.data.ProductNo);
                sm.set('ProductSpec', record.data.SpecificationsText);
                sm.set('ProductUnit', record.data.UnitText); 
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
            id: 'ProductCode',
            header: "����",
            dataIndex: 'ProductCode',
            width: 30,
            renderer: function(v, m) {
                m.css = 'x-grid-back-blue';
                return v;
            },
            editor: new Ext.form.TextField({ 
                allowBlank: false,
                enableKeyEvents: true, 
                initEvents: function() {  
                    var keyPress = function(e){  
                        if (e.getKey() == e.ENTER) {   
                            var curOrgId = Ext.getCmp("OutOrg").getValue();
                            if(curOrgId < 1){
                                alert("����ѡ����ֵ�λ��");
                                return;
                            }
                            var textValue = this.getValue();
                            var index = dsProductList.findBy(
                                function(record, id) {
                                    return record.get('ProductNo') == textValue;
                                }
                            );
                            var record = dsProductList.getAt(index);
                            var sm = userGrid.getSelectionModel().getSelected();                            
                            sm.set('ProductCode', record.data.ProductNo);
                            sm.set('ProductName', record.data.ProductName);
                            sm.set('ProductSpec', record.data.SpecificationsText);
                            sm.set('ProductUnit', record.data.UnitText); 
                            sm.set('ProductId', record.data.ProductId);
                            sm.set('ProductPrice', "");
                            addNewBlankRow();
                            
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
                        }  
                    };  
                    this.el.on("keypress", keyPress, this);  
                }  
             })
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
            editor: productCombo ,
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
                }
                 cellmeta.css = 'x-grid-back-blue';
                return displayText;
               
            } */
        },

        {
            id: "ProductUnit",
            header: "��λ",
            dataIndex: "ProductUnit",
            width: 20 /*,
            editor: productUnitCombo,
            renderer: function(value, cellmeta, record, rowIndex, columnIndex, store) {
                //���ֵ��ʾ����
                //��ȡ��ǰid="combo_process"��comboBoxѡ���ֵ
                var index = dsProductUnitList.find(productUnitCombo.valueField, value);
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
            }*/
        }
        , {
            id: 'ProductSpec',
            header: "���",
            dataIndex: 'ProductSpec',
            width: 30/*,
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
            }*/
        }, {
            id: 'ProductPrice',
            header: "�۸�",
            dataIndex: 'ProductPrice',
            width: 20,
            renderer: function(v, m) {
                m.css = 'x-grid-back-blue';
                return v;
            },
            editor: new Ext.form.TextField({ allowBlank: false })
        }, {
            id: 'OutQty',
            header: "����",
            dataIndex: 'OutQty',
            width: 20,
            renderer: function(v, m) {
                m.css = 'x-grid-back-blue';
                return v;
            },
            editor: new Ext.form.TextField({ allowBlank: false })
        }, new Extensive.grid.ItemDeleter()
        ]);
    cm.defaultSortable = true;

    var RowPattern = Ext.data.Record.create([
           { name: 'OrderDetailId', type: 'string' },
           { name: 'ProductId', type: 'string' },
           { name: 'ProductName', type: 'string' },
           { name: 'ProductCode', type: 'string' },
           { name: 'ProductUnit', type: 'string' },
           { name: 'ProductSpec', type: 'string' },
           { name: 'ProductPrice', type: 'string' },
           { name: 'OutQty', type: 'string' }
          ]);

    
    if (dsAllotOrderProduct == null) {
        dsAllotOrderProduct = new Ext.data.Store
	        ({
	            url: 'frmAllotDirectOrderEdit.aspx?method=getAllotDirectOrderProductList',
	            reader: new Ext.data.JsonReader({
	                totalProperty: 'totalProperty',
	                root: 'root'
	            }, RowPattern)
	        });
    }
    var userGrid = new Ext.grid.EditorGridPanel({
        store: dsAllotOrderProduct,
        cm: cm,
        selModel: new Extensive.grid.ItemDeleter(),
        layout: 'fit',
        renderTo: 'divGrid',
        width: '100%',
        height: 200,
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
    /*------��ʼ�������ݵĺ��� Start---------------*/
    function setFormValue() {
        Ext.Ajax.request({
            url: 'frmAllotDirectOrderEdit.aspx?method=getAllotDirectOrderInfo',
            params: {
                OrderId: OrderId
            },
            success: function(resp, opts) {
                var data = Ext.util.JSON.decode(resp.responseText);
                Ext.getCmp("OrderId").setValue(data.OrderId);
                Ext.getCmp("OrgId").setValue(data.OrgId);
                Ext.getCmp("OutOrg").setValue(data.OutOrg);
                Ext.getCmp("InOrg").setValue(data.InOrg);
                Ext.getCmp("OperId").setValue(data.OperId);
                Ext.getCmp("OutStatus").setValue(data.OutStatus);
                Ext.getCmp("CreateDate").setValue((new Date(data.CreateDate.replace(/-/g, "/")))); ;
                Ext.getCmp("Remark").setValue(data.Remark);
                dsDriverList.load({
                params:{OrgId:(data.OrgId==data.OutOrg)?data.OutOrg:data.InOrg,limit:3252,start:0},
                callback: function(r, options, success) { 
                    if (success == true) {
                        if(data.DriverId>0)
                           Ext.getCmp("DriverId").setValue(data.DriverId);  
                        }
                    }
                });
                                              
                dsWarehouseOutList.load({
                params:{OrgId:data.OutOrg},
                callback: function(r, options, success) {
                    if (success == true) {
                        if(data.OutWhId>0)
                           Ext.getCmp("OutWhId").setValue(data.OutWhId);
                        }
                    }
                });
                dsWarehouseInList.load({
                params:{OrgId:data.InOrg},
                    callback: function(r, options, success) {
                        if (success == true) {
                           if(data.InWhId>0)
                            Ext.getCmp("InWhId").setValue(data.InWhId);
                        }
                    }
                });
                if(curOrgId == data.OutOrg)
                {
                    Ext.getCmp("InOrg").setDisabled(true);
                    Ext.getCmp("InWhId").setDisabled(true);
                }
                else
                {
                    Ext.getCmp("OutOrg").setDisabled(true);
                    Ext.getCmp("OutWhId").setDisabled(true);
                }
            },
            failure: function(resp, opts) {
                Ext.Msg.alert("��ʾ", "��ȡ��������Ϣʧ�ܣ�");
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
                dsAllotOrderProduct.each(function(dsAllotOrderProduct) {
                    json += Ext.util.JSON.encode(dsAllotOrderProduct.data) + ',';
                });
                json = json.substring(0, json.length - 1);
                //alert(json);
                //alert(Ext.getCmp('InventoryDate').getValue());
                //Ȼ�����������

                Ext.Ajax.request({
                    url: 'frmAllotDirectOrderEdit.aspx?method=saveAllotDirectOrderInfo',
                    method: 'POST',
                    params: {
                        //������
                        OutOrg: Ext.getCmp("OutOrg").getValue(),
                        InOrg: Ext.getCmp('InOrg').getValue(),
                        OutWhId: Ext.getCmp("OutWhId").getValue(),
                        InWhId: Ext.getCmp('InWhId').getValue(),
                        OperId: Ext.getCmp('OperId').getValue(),
                        CreateDate: Ext.util.Format.date(Ext.getCmp('CreateDate').getValue(),'Y/m/d'),
                        Remark: Ext.getCmp('Remark').getValue(),
                        OutStatus: Ext.getCmp("OutStatus").getValue(),
                        OrderId: Ext.getCmp("OrderId").getValue(),
                        DriverId: Ext.getCmp("DriverId").getValue(),
                        //��ϸ����
                        DetailInfo: json
                    },
                    success: function(resp, opts) {
                       if(checkParentExtMessage(resp,parent))
                        {
                            //Ext.getCmp("saveButton").setDisabled(true);
                            parent.uploadAllotOrderWindow.hide();  
                        }
                    }
                });
            }
        },
        //        {
        //            text: "�ύ",
        //            scope: this,
        //            id: 'commitButton',
        //            handler: function() {
        //                Ext.MessageBox.confirm("��ʾ��Ϣ", "�Ƿ����Ҫ�ύ�òֿ��ʼ����Ϣ��", function callBack(id) {
        //                    //�ж��Ƿ�ɾ������
        //                    if (id == "yes") {
        //                        json = "";
        //                        dsAllotOrderProduct.each(function(dsAllotOrderProduct) {
        //                            json += Ext.util.JSON.encode(dsAllotOrderProduct.data) + ',';
        //                        });
        //                        json = json.substring(0, json.length - 1);
        //                        alert(json);
        //                        //ҳ���ύ
        //                        Ext.Ajax.request({
        //                            url: 'frmInitWarehouseEdit.aspx?method=saveInitWarehouseInfo&isCommit=1',
        //                            method: 'POST',
        //                            params: {
        //                                //������
        //                                //OrderDetailId:Ext.getCmp("OrderDetailId").getValue(),
        //                                WhId: Ext.getCmp('WhId').getValue(),
        //                                OperId: Ext.getCmp('OperId').getValue(),
        //                                InventoryDate: Ext.getCmp('InventoryDate').getValue().toLocaleDateString(),
        //                                Remark: Ext.getCmp('Remark').getValue(),
        //                                Status: Ext.getCmp("Status").getValue(),
        //                                OrderId: Ext.getCmp("OrderId").getValue(),
        //                                //��ϸ����
        //                                DetailInfo: json
        //                            },
        //                            success: function(resp, opts) {
        //                                Ext.Msg.alert("��ʾ", "���ݳ�ʼ���ɹ���");
        //                            },
        //                            failure: function(resp, opts) {
        //                                Ext.Msg.alert("��ʾ", "���ݳ�ʼ��ʧ�ܣ�");
        //                            }
        //                        });
        //                    }
        //                });
        //            }
        //        },
                         {
                         text: "ȡ��",
                         scope: this,
                         handler: function() {
                             parent.uploadAllotOrderWindow.hide();
                         }
}]
    });
    footerForm.render();
    Ext.getCmp("OrderId").setValue(OrderId);

    if (OrderId > 0) {
        setFormValue();
        dsAllotOrderProduct.load({
            params: { start: 0,
                limit: 10,
                OrderId: OrderId
            },
            callback: function(r, options, success) {
                if (success == true) {
                    inserNewBlankRow();
                    
                    
                }
            }
        });
    } else {
        AllotOrderForm.getForm().reset();
        dsAllotOrderProduct.removeAll();
        Ext.getCmp('OutOrg').setValue(curOrgId);
        Ext.getCmp('InOrg').setValue(curOrgId);
        dsWarehouseOutList.load({params:{OrgId:curOrgId}});
        dsWarehouseInList.load({params:{OrgId:curOrgId}});
        inserNewBlankRow();
    }
var columnCount = userGrid.getColumnModel().getColumnCount();
for (var i = 0; i < columnCount; i++) {
    userGrid.getColumnModel().setEditable(i, false);
}
if(OperType != "look"){
    userGrid.getColumnModel().setEditable(2, true);
    //userGrid.getColumnModel().setEditable(3, true);
    userGrid.getColumnModel().setEditable(7, true)
    userGrid.getColumnModel().setEditable(8, true); 
    Ext.getCmp("OutOrg").setDisabled(false);
    Ext.getCmp("InOrg").setDisabled(false);
    Ext.getCmp("InWhId").setDisabled(false);
    Ext.getCmp("OutWhId").setDisabled(false);
}
else{
    Ext.getCmp("saveButton").hide();
    Ext.getCmp("OutOrg").setDisabled(true);
    Ext.getCmp("InOrg").setDisabled(true);
    Ext.getCmp("InWhId").setDisabled(true);
    Ext.getCmp("OutWhId").setDisabled(true);
    Ext.getCmp("Remark").setDisabled(true);
    Ext.getCmp("DriverId").setDisabled(true);
}
    /*----------------footerframe----------------*/
    if(dsDriverList.getCount()>0){
        Ext.getCmp('DriverId').setValue(dsDriverList.getRange()[0].data.DriverId);
    }; 
})


function checkUIData(){
    var check = true;
    
    var inOrgId = Ext.getCmp("InOrg").getValue();
    var outOrgId = Ext.getCmp("OutOrg").getValue();
    if(inOrgId == outOrgId){
        Ext.Msg.alert("��ʾ","���뵥λ���ܺ͵�����λ��ͬ��");
        Ext.getCmp("InOrg").setValue("");
        return false;
    }
    
    var curOrgId = <% =ZJSIG.UIProcess.ADM.UIAdmUser.OrgID(this)%>;
    if(inOrgId !=curOrgId &&  outOrgId !=curOrgId){
        Ext.Msg.alert("��ʾ","���뵥λ�͵�����λ������һ���Ǳ���λ��");
        return false;
    }
       
    
  
    var rowCount = dsAllotOrderProduct.getCount();
    var index = 0;
    dsAllotOrderProduct.each(function(record,grid){
        if(index<rowCount-1){
            index++;//alert(record.get("WhpId"));
           
            if(record.get("OutQty") == undefined || record.get("OutQty") ==""){
                Ext.Msg.alert("��ʾ", "���������û����д��");
                check = false;
                return;
            }
            else{
                if(parseFloat(record.get("OutQty"))<=0){
                    Ext.Msg.alert("��ʾ", "�������������С�ڵ����㣡");
                    check = false;
                    return;
                }
            }
            if(record.get("ProductPrice") == undefined || record.get("ProductPrice") == "" || parseFloat(record.get("ProductPrice"))<=0){
                Ext.Msg.alert("��ʾ", "�������Ʒ�۸�û����д��");
                check = false;
                return;
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

</script>

</html>

