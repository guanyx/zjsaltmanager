<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmReturnOrderEdit.aspx.cs" Inherits="WMS_frmReturnOrderEdit" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html>
<head>
<title>�˻����༭ҳ��</title><meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
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
    var UIStatus = args["status"];

    Ext.onReady(function() {
        var ShiftPosOrderForm = new Ext.form.FormPanel({
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
                    },
                    {
                        xtype: 'hidden',
                        fieldLabel: '��֯',
                        name: 'OrgId',
                        id: 'OrgId',
                        hide: true,
                        value:<%=ZJSIG.UIProcess.ADM.UIAdmUser.OrgID(this)%>
                    }, 
                    {
                        xtype: 'combo',
                        fieldLabel: '�ֿ�',
                        columnWidth: 1,
                        anchor: '95%',
                        name: 'WhId',
                        id: 'WhId',
                        displayField: 'WhName',
                        valueField: 'WhId',
                        editable: false,
                        store: dsWarehouseListByUserId,
                        mode: 'local',
                        triggerAction: 'all',
                        value:dsWarehouseListByUserId.getRange()[0].data.WhId
                       
                    }]
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
                        store:dsOperationList,
			            mode:'local',
			            displayField:'EmpName',
			            valueField:'EmpId',
			            //triggerAction: 'all',
			            editable:false,
			            value:<%=ZJSIG.UIProcess.ADM.UIAdmUser.EmployeeID(this) %>,
                        disabled:true
                    }]
                }]
             },
             {
                 layout: 'column',   //�����Ԫ��Ϊ����Ϊ�в��ַ�ʽ
                 border: false,
                 items: [{
                columnWidth: .5,  //����ռ�õĿ�ȣ���ʶΪ20��
                layout: 'form',
                border: false,
                items: [
                    {
                        xtype: 'combo',
                        fieldLabel: '�˻�����',
                        columnWidth: 1,
                        anchor: '95%',
                        name: 'Type',
                        id: 'Type',
                        displayField: 'DicsName',
                        valueField: 'DicsCode',
                        editable: false,
                        store: dsReturnTypeList,
                        mode: 'local',
                        triggerAction: 'all',
                        disabled:true
                    }
                ]
            },
            {
                columnWidth: .5,  //����ռ�õĿ�ȣ���ʶΪ20��
                layout: 'form',
                border: false,
                items: [{
                        xtype: 'textfield',
                        fieldLabel: 'ԭʼ���ݺ�',
                        columnWidth: 1,
                        anchor: '95%',
                        name: 'OriginBillId',
                        id: 'OriginBillId'
                        
                        }]
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
                ProductId: '',
                ProductCode: '',
                ProductUnit: '',
                ProductSpec: '',
                ProductPrice: '',
                RealQty: '',
                UnitId:''
            });
            userGrid.stopEditing();
            //����һ����
            if (insertPos > 0) {
                var rowIndex = dsReturnOrderProduct.insert(insertPos, addRow);
                userGrid.startEditing(insertPos, 0);
            }
            else {
                var rowIndex = dsReturnOrderProduct.insert(0, addRow);
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
                sm.set('ProductCode', record.data.ProductNo);
                sm.set('ProductSpec', record.data.Specifications);
                sm.set('ProductUnit', record.data.Unit);
                sm.set('ProductId', record.data.ProductId);
                addNewBlankRow();
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
            editor: new Ext.form.TextField({ allowBlank: false })
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
                }
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
            id: 'ProductPrice',
            header: "�۸�",
            dataIndex: 'ProductPrice',
            width: 20,
            editor: new Ext.form.TextField({ allowBlank: false })
        }, {
            id: 'RealQty',
            header: "�˻�����",
            dataIndex: 'RealQty',
            width: 20,
            renderer: function(v, m) {
                m.css = 'x-grid-back-blue';
                return v;
            },
            editor: new Ext.form.TextField({ allowBlank: false })
        },
        {
            id: 'UnitId',
            header: "��λid",
            dataIndex: 'UnitId',
            hidden: true,
            hideable: false
        }, new Extensive.grid.ItemDeleter()
        ]);
    cm.defaultSortable = true;

    var RowPattern = Ext.data.Record.create([
           { name: 'OrderDetailId', type: 'string' },
           { name: 'ProductId', type: 'string' },
           { name: 'ProductCode', type: 'string' },
           { name: 'ProductUnit', type: 'string' },
           { name: 'ProductSpec', type: 'string' },
           { name: 'ProductPrice', type: 'string' },
           { name: 'RealQty', type: 'string' },
           { name: 'UnitId', type: 'string' }
          ]);

    var dsReturnOrderProduct;
    if (dsReturnOrderProduct == null) {
        dsReturnOrderProduct = new Ext.data.Store
	        ({
	            url: 'frmReturnOrderEdit.aspx?method=getReturnOrderProductList',
	            reader: new Ext.data.JsonReader({
	                totalProperty: 'totalProperty',
	                root: 'root'
	            }, RowPattern)
	        });
    }
    var userGrid = new Ext.grid.EditorGridPanel({
        store: dsReturnOrderProduct,
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
            url: 'frmReturnOrderEdit.aspx?method=getReturnOrderInfo',
            params: {
                OrderId: OrderId
            },
            success: function(resp, opts) {
                var data = Ext.util.JSON.decode(resp.responseText);
                 
                Ext.getCmp("OrderId").setValue(data.OrderId);
                Ext.getCmp("OrgId").setValue(data.OrgId);
                Ext.getCmp("WhId").setValue(data.WhId);
                Ext.getCmp("Type").setValue(data.Type);
                Ext.getCmp("OperId").setValue(data.OperId);
                Ext.getCmp("Status").setValue(data.Status);
                Ext.getCmp("CreateDate").setValue((new Date(data.CreateDate.replace(/-/g, "/")))); ;
                Ext.getCmp("Remark").setValue(data.Remark);
                Ext.getCmp("OriginBillId").setValue(data.OriginBillId);
              
            },
            failure: function(resp, opts) {
                Ext.Msg.alert("��ʾ", "��ȡ�˻�����Ϣʧ�ܣ�");
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
                json = "";
                dsReturnOrderProduct.each(function(dsReturnOrderProduct) {
                    json += Ext.util.JSON.encode(dsReturnOrderProduct.data) + ',';
                });
                json = json.substring(0, json.length - 1);
                //alert(json);
                //alert(Ext.getCmp('InventoryDate').getValue());
                //Ȼ�����������

                Ext.Ajax.request({
                    url: 'frmReturnOrderEdit.aspx?method=saveReturnOrderInfo',
                    method: 'POST',
                    params: {
                        //������
                        WhId: Ext.getCmp("WhId").getValue(),
                        OperId: Ext.getCmp('OperId').getValue(),
                        CreateDate: Ext.util.Format.date(Ext.getCmp('CreateDate').getValue(),'Y/m/d'),
                        Remark: Ext.getCmp('Remark').getValue(),
                        Status: Ext.getCmp("Status").getValue(),
                        OrderId: Ext.getCmp("OrderId").getValue(),
                        OrgId:Ext.getCmp("OrgId").getValue(),
                        //��ϸ����
                        DetailInfo: json
                    },
                    success: function(resp, opts) {
                       if(checkParentExtMessage(resp))
                        {
                            //parent.updateDataGrid();
                            parent.uploadReturnOrderWindow.hide();
                        }
                    }
                
                });
            }
        },
             {
                text: "�˻�ȷ��",
                scope: this,
                id: 'commitButton',
                handler: function() {
                    Ext.MessageBox.confirm("��ʾ��Ϣ", "�Ƿ����Ҫȷ�ϸ��˻�����Ϣ��", function callBack(id) {
                        if (id == "yes") {
                            json = "";
                            dsReturnOrderProduct.each(function(dsReturnOrderProduct) {
                                json += Ext.util.JSON.encode(dsReturnOrderProduct.data) + ',';
                            });
                            json = json.substring(0, json.length - 1);
                            //alert(json);
                            //ҳ���ύ
                            Ext.Ajax.request({
                                url: 'frmReturnOrderEdit.aspx?method=saveReturnOrderInfo',
                                method: 'POST',
                                params: {
                                    //������
                                    WhId: Ext.getCmp("WhId").getValue(),
                                    OperId: Ext.getCmp('OperId').getValue(),
                                    CreateDate: Ext.util.Format.date(Ext.getCmp('CreateDate').getValue(),'Y/m/d'),
                                    Remark: Ext.getCmp('Remark').getValue(),
                                    Status: 1,
                                    OrderId: Ext.getCmp("OrderId").getValue(),
                                    OrgId:Ext.getCmp("OrgId").getValue(),
                                    //��ϸ����
                                    DetailInfo: json
                                },
                                success: function(resp, opts) {
                                    if(checkParentExtMessage(resp))
                                    {
                                        Ext.getCmp("commitButton").disable();
                                        Ext.getCmp("saveButton").disable();
                                        //parent.updateDataGrid();
                                        //setTimeout(parent.uploadReturnOrderWindow.hide(),3000);
                                        parent.uploadReturnOrderWindow.hide();
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
                             parent.uploadReturnOrderWindow.hide();
                         }
}]
    });
    footerForm.render();
    Ext.getCmp("OrderId").setValue(OrderId);

    if (OrderId > 0) {
        setFormValue();
        dsReturnOrderProduct.load({
            params: { start: 0,
                limit: 10,
                OrderId: OrderId
            },
            callback: function(r, options, success) {
                if (success == true) {
                    //inserNewBlankRow();
                    var columnCount = userGrid.getColumnModel().getColumnCount();
                    for (var i = 0; i < columnCount; i++) {
                        userGrid.getColumnModel().setEditable(i, false);
                    }
                    //userGrid.getColumnModel().setEditable(3, true);
                    userGrid.getColumnModel().setEditable(6, true)
                    userGrid.getColumnModel().setEditable(7, true); 
                    if (Ext.getCmp("Status").getValue() >= 1) {
                        Ext.getCmp("saveButton").hide();
                        Ext.getCmp("commitButton").hide();
                        
                        Ext.getCmp("WhId").setDisabled(true);
                        Ext.getCmp("OriginBillId").setDisabled(true);
                        Ext.getCmp("Remark").setDisabled(true);
                        //userGrid.disable();
                    }
                    if (UIStatus == "look") {
                        Ext.getCmp("saveButton").hide();
                        Ext.getCmp("commitButton").hide();
			            userGrid.getColumnModel().setEditable(7, false); 
                    }
                }
            }
        });
    } else {
         Ext.getCmp("commitButton").hide();
         dsWarehousePosList.load({
                    params:{
                        WhId:Ext.getCmp("WhId").getValue()
                    }
                });
    }
   

    /*----------------footerframe----------------*/
})

</script>

</html>

