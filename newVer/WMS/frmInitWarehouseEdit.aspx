<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmInitWarehouseEdit.aspx.cs" Inherits="WMS_frmInitWarehouseEdit" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html>
<head>
<title>�ֿ��ʼ���༭ҳ��</title><meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
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
.x-grid-back-blue2 { 
background: #D3D9EF; 
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
                                var curWhId = Ext.getCmp("WhId").getValue();
                                dsWarehousePosList.load({
                                    params: {
                                        WhId: curWhId
                                    }
                                });
                                //Ext.getCmp('WhpId').setValue("");
                                //grid�в�λ��λ
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
                    value: <%=ZJSIG.UIProcess.ADM.UIAdmUser.EmployeeID(this) %>,
                    disabled:true,
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
                columnWidth: .5,  //����ռ�õĿ�ȣ���ʶΪ20��
                layout: 'form',
                border: false,
                items: [
                    {
                        xtype: 'datefield',
                        fieldLabel: '��ʼ������',
                        columnWidth: 1,
                        anchor: '95%',
                        name: 'InventoryDate',
                        id: 'InventoryDate',
                        format: 'Y��m��d��',
                        value: new Date(),
                        readOnly: true,
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
                    id: 'Remark',
		    height:40
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
                WhpId: '',
                ProductId: '',
                ProductCode: '',
                ProductUnit: '',
                ProductSpec: '',
                RealQty: ''//,
                //CREATE_DATE: (new Date()).clearTime() 
            });
            userGrid.stopEditing();
            //����һ����
            if (insertPos > 0) {
                var rowIndex = dsInitWarehouseProduct.insert(insertPos, addRow);
                userGrid.startEditing(insertPos, 0);
            }
            else {
                var rowIndex = dsInitWarehouseProduct.insert(0, addRow);
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

        //��λ����Դ
        var dsWarehousePosList;
        if (dsWarehousePosList == null) { //��ֹ�ظ�����
            dsWarehousePosList = new Ext.data.Store
            ({
                url: 'frmInitWarehouseEdit.aspx?method=getWarehousePosList',
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
                "select": addNewBlankRow//,
                //"focus":new function(){alert('X');}
            }
        });
        //        var resultTpl = new Ext.XTemplate(
        //                        '<table>',
        //                        '<tpl for="."><tr>',
        //                            '<td>{ProductNo}</td><td>{ProductName}</td><td>{Specifications}</td><td>{Unit}</td>',
        //                        '</tr></tpl></table>'
        //                    ); 
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
            //            tpl: resultTpl,
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
            id: 'WhpId',
            header: "��λ",
            dataIndex: 'WhpId',
            width: 20,
            editor: warehousePosCombo,
            renderer: function(value, cellmeta, record, rowIndex, columnIndex, store) {
                var index = dsWarehousePosList.findBy(
                        function(record, id) {
                            return record.get('WhpId') == value;
                        }
                    );
                var record = dsWarehousePosList.getAt(index);
                var displayText = "";
                if (record == null) {
                    displayText = value;
                } else {
                    displayText = record.data.WhpName;
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
                m.css = 'x-grid-back-blue2';
                return v;
            },
            editor: new Ext.form.TextField({ 
                allowBlank: false,
                enableKeyEvents: true, 
                initEvents: function() {  
                    var keyPress = function(e){  
                        if (e.getKey() == e.ENTER) {   
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
                            sm.set('ProductUnit', record.data.Unit); 
                            sm.set('ProductId', record.data.ProductId);
                            addNewBlankRow();                            
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
            hidden:true,
            width: 65
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
            header: "�۸�",
            dataIndex: 'ProductPrice',
            width: 20,
            renderer: function(v, m) {
                m.css = 'x-grid-back-blue';
                return v;
            },
            editor: new Ext.form.TextField({ allowBlank: false })
        }, {
            id: 'RealQty',
            header: "����",
            dataIndex: 'RealQty',
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
           { name: 'WhpId', type: 'string' },
           { name: 'ProductId', type: 'string' },
           { name: 'ProductCode', type: 'string' },
           { name: 'ProductUnit', type: 'string' },
           { name: 'ProductSpec', type: 'string' },
           { name: 'RealQty', type: 'string' },
           { name: 'ProductPrice', type:'string' }
          ]);

    var dsInitWarehouseProduct;
    if (dsInitWarehouseProduct == null) {
        dsInitWarehouseProduct = new Ext.data.Store
	        ({
	            url: 'frmInitWarehouseEdit.aspx?method=getInitWarehouseProductList',
	            reader: new Ext.data.JsonReader({
	                totalProperty: 'totalProperty',
	                root: 'root'
	            }, RowPattern)
	        });
        //inserNewBlankRow(); //--------------------------------------------------------
    }
    var userGrid = new Ext.grid.EditorGridPanel({
        store: dsInitWarehouseProduct,
        cm: cm,
        selModel: new Extensive.grid.ItemDeleter(),
        layout: 'fit',
        renderTo: 'divGrid',
        width: '100%',
        height: 255,
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
            url: 'frmInitWarehouseEdit.aspx?method=getInitWarehouseInfo',
            params: {
                OrderId: OrderId
            },
            success: function(resp, opts) {
                var data = Ext.util.JSON.decode(resp.responseText);
                Ext.getCmp("OrderId").setValue(data.OrderId);
                Ext.getCmp("OrgId").setValue(data.OrgId);
                Ext.getCmp("WhId").setValue(data.WhId);
                dsWarehousePosList.load({
                    params: {
                        WhId: data.WhId
                    },
                    callback:function(r, options, success) {
                        dsInitWarehouseProduct.load({
                            params: { start: 0,
                                limit: 32510,
                                OrderId: OrderId
                            },
                            callback: function(r, options, success) {
                                if (success == true) {
                                    inserNewBlankRow();
                                    
                                }
                            }
                        });
                    }
                });
                Ext.getCmp("OperId").setValue(data.OperId);
                Ext.getCmp("Status").setValue(data.Status);
                Ext.getCmp("InventoryDate").setValue((new Date(data.InventoryDate.replace(/-/g, "/")))); ;

                Ext.getCmp("Remark").setValue(data.Remark);
                Ext.getCmp("WhId").disabled = true;
                
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
        el: 'divBotton',
        border: true, // û�б߿�
        labelAlign: 'left',
        buttonAlign: 'center',
        bodyStyle: 'padding:2px',
        height: 40,
        frame: true,
        labelWidth: 55,
        buttons: [{
            text: "����",
            scope: this,
            id: 'saveButton',
            handler: function() {
                if(!checkUIData()) return;
                json = "";
                dsInitWarehouseProduct.each(function(dsInitWarehouseProduct) {
                    json += Ext.util.JSON.encode(dsInitWarehouseProduct.data) + ',';
                });
                json = json.substring(0, json.length - 1);
                //alert(json);
                //alert(Ext.getCmp('InventoryDate').getValue());
                //Ȼ�����������

                Ext.Ajax.request({
                    url: 'frmInitWarehouseEdit.aspx?method=saveInitWarehouseInfo',
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
                        IsInitBill: 0, //�ֿ��ʼ��
                        //��ϸ����
                        DetailInfo: json
                    },
                    success: function(resp, opts) {
                        if (checkParentExtMessage(resp,parent)) {
                            //Ext.getCmp("saveButton").setDisabled(true);
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
                if(!checkUIData()) return;
                Ext.MessageBox.confirm("��ʾ��Ϣ", "�Ƿ����Ҫ�ύ�òֿ��ʼ����Ϣ��", function callBack(id) {
                    //�ж��Ƿ�ɾ������
                    if (id == "yes") {
                        json = "";
                        dsInitWarehouseProduct.each(function(dsInitWarehouseProduct) {
                            json += Ext.util.JSON.encode(dsInitWarehouseProduct.data) + ',';
                        });
                        json = json.substring(0, json.length - 1);
                        //alert(json);
                        //ҳ���ύ
                        Ext.Ajax.request({
                            url: 'frmInitWarehouseEdit.aspx?method=commitInitWarehouseInfo',
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
                                IsInitBill: 0, //�ֿ��ʼ��
                                //��ϸ����
                                DetailInfo: json
                            },
                            success: function(resp, opts) {
                                if (checkParentExtMessage(resp,parent)) {
                                    //Ext.getCmp("saveButton").setDisabled(true);
                                    //Ext.getCmp("commitButton").setDisabled(true);
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
    } else {
        Ext.getCmp("commitButton").hide();
    }
    if (Ext.getCmp("Status").getValue() == 1) {
        Ext.getCmp("saveButton").hide()
        Ext.getCmp("commitButton").hide();
        userGrid.disable();
    }
    else{
        //userGrid.getColumnModel().setEditable(3, false);
        userGrid.getColumnModel().setEditable(6, false);
        userGrid.getColumnModel().setEditable(7, false);
    }
    if(OperType == "look"){
        Ext.getCmp("commitButton").hide();
        Ext.getCmp("saveButton").hide();
    }
//��������ǰ
function checkUIData(){
    var check = true;
    var rowCount = dsInitWarehouseProduct.getCount();
    var index = 0;
    dsInitWarehouseProduct.each(function(record,grid){
        if(index<rowCount-1){
            index++;
            if(record.get("WhpId") == undefined || record.get("WhpId") == "" || parseInt(record.get("WhpId"))<1){
                //if(parseInt(record.get("WhpId"))<1){
                    Ext.Msg.alert("��ʾ", "����в�λû��ѡ��");
                    check = false;
                    return;
                //}
            }
           
            if(record.get("RealQty") == undefined || record.get("RealQty") == "" || parseFloat(record.get("RealQty"))<0){
                Ext.Msg.alert("��ʾ", "�������������ΪС�ڵ���0����Ϊ�գ�");
                check = false;
                return;
            }
            //alert(record.get("ProductId")+"___lll");
            if(record.get("ProductId") == undefined  || record.get("ProductId") == "" || parseInt(record.get("ProductId"))<=0){
                Ext.Msg.alert("��ʾ", "�������Ʒû��ѡ��");
                check = false;
                return;
            }
            if(record.get("ProductPrice") == undefined  || record.get("ProductPrice") == "" || parseFloat(record.get("ProductPrice"))<=0){
                Ext.Msg.alert("��ʾ", "�������Ʒ�۸�û����д��");
                check = false;
                return;
            }
        }
    });
    if(rowCount == 1){
        Ext.Msg.alert("��ʾ","��ʼ����Ʒ��¼����Ϊ�㣡");
        return false;
    }
    return check;
}
    /*----------------footerframe----------------*/
})

</script>

</html>

