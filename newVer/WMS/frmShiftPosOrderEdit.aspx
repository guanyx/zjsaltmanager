<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmShiftPosOrderEdit.aspx.cs" Inherits="WMS_frmShiftPosOrderEdit" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html>
<head>
<title>�ƿⵥ�༭ҳ��</title><meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
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
 <div id="transport">
    </div>
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
 var version =parseFloat(navigator.appVersion.split("MSIE")[1]);
        if(version == 6)
            version = 1;
        else //!ie6 contain double size
            version = 2; //alert(OrderId+":"+FromBillType);
function getRadioValue(radioName) {
    var radios = document.getElementsByName(radioName);
    if (radios != null) {
        for (var i = 0; i < radios.length; i++) {
            //alert(radios.item(i).checked + '---' + radios.item(i).value);
            var obj = radios.item(i);
            if (obj.checked) {
                return obj.value;
            }
        }
    }
    return radios.item(0).value;
}
function setRadioValue(radioName, inputValue) {
    var radios = document.getElementsByName(radioName);
    if (radios == null) return;
    for (var i = 0; i < radios.length; i++) {
        var obj = radios.item(i);
        if (inputValue == obj.value) {
            obj.checked = true;
        }
        
    }
}
var defaultUserWhId = 0;
if(dsWarehouseListByUserId.getRange().length>0)
{
    defaultUserWhId = dsWarehouseListByUserId.getRange()[0].data.WhId;
}

/*------��ʼ�������ݵĺ��� Start---------------*/
var dsShiftPosOrderProduct;
var dsWarehousePosList; //��λ������
var userGrid;

var RowPattern = Ext.data.Record.create([
           { name: 'OrderDetailId', type: 'string' },
           { name: 'ProductId', type: 'string' },
           { name: 'ProductCode', type: 'string' },
           { name: 'ProductUnit', type: 'string' },
           { name: 'ProductSpec', type: 'string' },
           { name: 'ProductPrice', type: 'string' },
           { name: 'ProductQty', type: 'string' }
          ]);
          
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
                ProductQty: ''
            });
            userGrid.stopEditing();
            //����һ����
            if (insertPos > 0) {
                var rowIndex = dsShiftPosOrderProduct.insert(insertPos, addRow);
                userGrid.startEditing(insertPos, 0);
            }
            else {
                var rowIndex = dsShiftPosOrderProduct.insert(0, addRow);
                userGrid.startEditing(0, 0);
            }
        }
        
    function setFormValue() {
        Ext.Ajax.request({
            url: 'frmShiftPosOrderEdit.aspx?method=getShiftPosOrderInfo',
            params: {
                OrderId: OrderId
            },
            success: function(resp, opts) {
                var data = Ext.util.JSON.decode(resp.responseText);
                
                dsWarehousePosList.load({
                    params:{
                        WhId:data.WhId
                    },
                    callback: function(r, options, success) {
                        if (success == true) {
                            Ext.getCmp("OutWhpId").setValue(data.OutWhpId);
                            Ext.getCmp("InWhpId").setValue(data.InWhpId);
                        }
                    
                    }
                });
                Ext.getCmp("OrderId").setValue(data.OrderId);
                Ext.getCmp("OrgId").setValue(data.OrgId);
                Ext.getCmp("WhId").setValue(data.WhId);
                //Ext.getCmp("OutWhpId").setValue(data.OutWhpId);
                //Ext.getCmp("InWhpId").setValue(data.InWhpId);
                Ext.getCmp("OperId").setValue(data.OperId);
                Ext.getCmp("Status").setValue(data.Status);
                Ext.getCmp("CreateDate").setValue((new Date(data.CreateDate.replace(/-/g, "/")))); ;
                Ext.getCmp("Remark").setValue(data.Remark);
                Ext.getCmp("LoadAmount").setValue(data.LoadAmount);
                Ext.getCmp("TransAmount").setValue(data.TransAmount);
                if(data.LoadComId==0)
                {
                     Ext.getCmp("LoadComId").setValue("");
                }
                else{
                    Ext.getCmp("LoadComId").setValue(data.LoadComId);
                }
                setRadioValue("LoadType",data.LoadType);
                Ext.getCmp("LoadPrice").setValue(data.LoadPrice);
                Ext.getCmp("CarBoatNo").setValue(data.CarBoatNo);
                setRadioValue("TransType",data.TransType);
                Ext.getCmp("TransPrice").setValue(data.TransPrice);
                
            },
            failure: function(resp, opts) {
                Ext.Msg.alert("��ʾ", "��ȡ�ƿⵥ��Ϣʧ�ܣ�");
            }
        });
    }
    
    function setAllFormValue()
    {
        Ext.getCmp("saveButton").show();
        Ext.getCmp("commitButton").show();
        userGrid.enable();
        if (OrderId > 0) {
        setFormValue();        
        dsShiftPosOrderProduct.load({
            params: { start: 0,
                limit: 10,
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
             Ext.getCmp('OutWhpId').setValue("");
             Ext.getCmp('InWhpId').setValue("");
             Ext.getCmp("OperId").setValue(operId);
            Ext.getCmp("Status").setValue(0);
            Ext.getCmp("CreateDate").setValue(new Date()); ;
            Ext.getCmp("Remark").setValue("");
            Ext.getCmp("LoadAmount").setValue("");
            Ext.getCmp("TransAmount").setValue("");
            Ext.getCmp("LoadComId").setValue("");
            setRadioValue("LoadType","W0401");
            Ext.getCmp("LoadPrice").setValue("");
            Ext.getCmp("CarBoatNo").setValue("");
            setRadioValue("TransType","W0401");
            Ext.getCmp("TransPrice").setValue("");
            if(dsShiftPosOrderProduct!=null)
            {
                dsShiftPosOrderProduct.removeAll();
                inserNewBlankRow();
            }
        }
    }
    /*------��ʼ�������ݵĺ��� End---------------*/
    
    Ext.onReady(function() {
        
        if (dsWarehousePosList == null) { //��ֹ�ظ�����
            dsWarehousePosList = new Ext.data.JsonStore({
                totalProperty: "result",
                root: "root",
                url: 'frmShiftPosOrderEdit.aspx?method=getWarehousePositionList',
                fields: ['WhpId', 'WhpName']
            });
        }
            
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
                    }
                    , {
                        xtype: 'hidden',
                        fieldLabel: '��֯',
                        name: 'OrgId',
                        id: 'OrgId',
                        hide: true,
                        value:<%=ZJSIG.UIProcess.ADM.UIAdmUser.OrgID(this)%>
                    }
                    , {
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
                        value:defaultUserWhId,//dsWarehouseListByUserId.getRange()[0].data.WhId,
                        listeners: {
                            select: function(combo, record, index) {
                                var curWhId = Ext.getCmp("WhId").getValue();
                                dsWarehousePosList.load({
                                    params: {
                                        WhId: curWhId
                                    }
                                });
                                Ext.getCmp('OutWhpId').setValue("");
                                Ext.getCmp('InWhpId').setValue("");
                                dsProducts.baseParams.WhId = curWhId;
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
                        name: 'OutWhpId',
                        id: 'OutWhpId',
                        displayField: 'WhpName',
                        valueField: 'WhpId',
                        editable: false,
                        store: dsWarehousePosList,
                        mode: 'local',
                        triggerAction: 'all',
                        //value:dsWarehouseListByUserId.getRange()[0].data.WhId,
                        listeners: {
                        //                            select: function(combo, record, index) {
                        //                                var curWhId = Ext.getCmp("OutWhId").getValue();
                        //                                dsWarehousePosList.load({
                        //                                    params: {
                        //                                        WhId: curWhId
                        //                                    }
                        //                                });
                        //                            }
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
                        fieldLabel: '�����λ',
                        columnWidth: 1,
                        anchor: '95%',
                        name: 'InWhpId',
                        id: 'InWhpId',
                        displayField: 'WhpName',
                        valueField: 'WhpId',
                        editable: false,
                        store: dsWarehousePosList,
                        mode: 'local',
                        triggerAction: 'all',
                        //value:dsWarehouseListByUserId.getRange()[0].data.WhId,
                        listeners: {
                        //                            select: function(combo, record, index) {
                        //                                var curWhId = Ext.getCmp("OutWhId").getValue();
                        //                                dsWarehousePosList.load({
                        //                                    params: {
                        //                                        WhId: curWhId
                        //                                    }
                        //                                });
                        //                            }
                    }
                }
                ]
            }
            ]
             }
        ]
        });
        //-------------------Form����-----------------------------

/*----------------tansportframe----------------*/
var transportForm = new Ext.FormPanel({
    el: 'transport',
    border: true, // û�б߿�
    labelAlign: 'left',
    buttonAlign: 'right',
    bodyStyle: 'padding:2px',
    height: 90,
    layout:'column',
    frame: true,
    labelWidth: 55,
    items:[
    {
        layout:'form',
        columnWidth:.5,
        items:[
        {
            layout:'column',
            columnWidth:.5,
            items:[
            {
                layout:'form',
                columnWidth:.1*version,
                html: '��������:&nbsp;&nbsp;'
            }, {
                layout:'form',
                columnWidth:.1*version,
                items:[
                    new Ext.form.Radio({
                    id: 'None',
                    name: 'TransType',
                    checked: true,
                    boxLabel: '��',
                    inputValue: 'W0401',
                    hideLabel:true
                })
                ]
            }, {
                layout:'form',
                columnWidth:.1*version,
                items:[
                    new Ext.form.Radio({
                    id: 'Car',
                    name: 'TransType',
                    boxLabel: '����',
                    inputValue: 'W0402',
                    hideLabel:true
                })
                ]
            }, {
                layout:'form',
                columnWidth:.1*version,
                items: [
                    new Ext.form.Radio({
                    id: 'Trian',
                    name: 'TransType',
                    anchor: '95%',
                    boxLabel: '��',
                    inputValue: 'W0403',
                    hideLabel:true
                })]
            }, {
                layout:'form',
                columnWidth:.1*version,
                items: [new Ext.form.Radio({
                    id: 'Ship',
                    name: 'TransType',
                    anchor: '95%',
                    boxLabel: '��',
                    inputValue: 'W0404',
                    hideLabel:true
                })]
            }
            ]
        },
        {
            layout:'column',
            columnWidth:.5,
            items:[
            {
                columnWidth: .25*version,  //����ռ�õĿ�ȣ���ʶΪ20��
                layout: 'form',
                border: false,
                items: [
                {
                    xtype: 'numberfield',
                    fieldLabel: '���䵥��',
                    anchor: '90%',
                    id: 'TransPrice',
                    value: 0,
                    style: "text-align: right;",
                    listeners: {
                        "blur":function(tf){
                            var total = 0;
                            dsShiftPosOrderProduct.each(function(record,grid){
                                var qty = record.get("ProductQty");
                                try{
                                    if(qty != "")
                                        total += parseFloat(qty);
                                }catch(err){
                                }
                            });
                            Ext.getCmp("TransAmount").setValue(parseFloat(this.value)*total);
                        }
                    }   
                }]         
            },
            {
                columnWidth: .25*version,  //����ռ�õĿ�ȣ���ʶΪ20��
                layout: 'form',
                border: false,
                items: [{
                    xtype: 'numberfield',
                    fieldLabel: '�������',
                    anchor: '90%',
                    id: 'TransAmount',
                    style: "text-align: right;",
                    value: 0,
                     listeners: {
                        "blur":function(tf){
                            var total = 0;
                            dsShiftPosOrderProduct.each(function(record,grid){
                                var qty = record.get("ProductQty");
                                try{
                                    if(qty != "")
                                        total += parseFloat(qty);
                                }catch(err){
                                }
                            });
                            if(total == 0) 
                                Ext.getCmp("TransPrice").setValue(0);
                            else
                                Ext.getCmp("TransPrice").setValue(parseFloat(this.value)/total);
                        }
                     }
                }]
            }
            ]
        }
        ]
    },
    {
        layout:'form',
        columnWidth:.5,
        items:[
        {
            layout:'column',
            columnWidth:.5,
            items:[
            {
                layout:'form',
                columnWidth:.1*version,
                html: 'װж����:&nbsp;&nbsp;'
            }, {
                layout:'form',
                columnWidth:.1*version,
                items:[
                    new Ext.form.Radio({
                    id: 'ZxNone',
                    name: 'LoadType',
                    checked: true,
                    boxLabel: '��',
                    inputValue: 'W0401',
                    hideLabel:true
                })
                ]
            }, {
                layout:'form',
                columnWidth:.1*version,
                items:[
                    new Ext.form.Radio({
                    id: 'ZxCar',
                    name: 'LoadType',
                    boxLabel: '����',
                    inputValue: 'W0402',
                    hideLabel:true
                })
                ]
            }, {
                layout:'form',
                columnWidth:.1*version,
                items: [
                    new Ext.form.Radio({
                    id: 'ZxTrian',
                    name: 'LoadType',
                    anchor: '95%',
                    boxLabel: '��',
                    inputValue: 'W0403',
                    hideLabel:true
                })]
            }, {
                layout:'form',
                columnWidth:.1*version,
                items: [new Ext.form.Radio({
                    id: 'ZxShip',
                    name: 'LoadType',
                    anchor: '95%',
                    boxLabel: '��',
                    inputValue: 'W0404',
                    hideLabel:true
                })]
            }
            ]
        },
        {
            layout:'column',
            items: [
            {
                columnWidth: .5*version,  //����ռ�õĿ�ȣ���ʶΪ20��
                layout: 'form',
                border: false,
                items: [
                {
                    xtype: 'combo',
                    fieldLabel: 'װж��λ',
                    anchor: '90%',
                    id: 'LoadComId', //dsLoadCompanyList
                    displayField: 'Name',
                    valueField: 'Id',
                    editable: false,
                    store: dsLoadCompanyList,
                    mode: 'local',
                    triggerAction: 'all'
                }]
            }]
        },
        {
            layout:'column',
            columnWidth:.5,
            items: [{
                columnWidth: .25*version,  //����ռ�õĿ�ȣ���ʶΪ20��
                layout: 'form',
                border: false,
                items: [{
                    xtype: 'numberfield',
                    fieldLabel: 'װж����',
                    anchor: '90%',
                    id: 'LoadPrice',
                    style: "text-align: right;",
                    value: 0,
                    listeners: {
                        "blur":function(tf){
                            var total = 0;
                            dsShiftPosOrderProduct.each(function(record,grid){
                                var qty = record.get("ProductQty");
                                try{
                                    if(qty != "")
                                        total += parseFloat(qty);
                                }catch(err){
                                }
                            });
                            Ext.getCmp("LoadAmount").setValue(parseFloat(this.value)*total);
                        }
                    }   
                }]
            }, {
                columnWidth: .25*version,  //����ռ�õĿ�ȣ���ʶΪ20��
                layout: 'form',
                border: false,
                items: [{
                    xtype: 'numberfield',
                    fieldLabel: 'װж����',
                    anchor: '90%',
                    name: 'LoadAmount',
                    id: 'LoadAmount',
                    style: "text-align: right;",
                    value: 0,
                     listeners: {
                        "blur":function(tf){
                            var total = 0;
                            dsShiftPosOrderProduct.each(function(record,grid){
                                var qty = record.get("ProductQty");
                                try{
                                    if(qty != "")
                                        total += parseFloat(qty);
                                }catch(err){
                                }
                            });
                            if(total == 0) 
                                Ext.getCmp("LoadPrice").setValue(0);
                            else
                                Ext.getCmp("LoadPrice").setValue(parseFloat(this.value)/total);
                        }
                     }
                }]
            }]
        }
        ]
    }
    ]
});
transportForm.render();

        //-------------------Grid Start-----------------------------

        
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
                //sm.set('ProductPrice',record.data.ProductPrice);
                addNewBlankRow();
            }
        });
        
        /*********************��Ʒѡ��*******************************/
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
        getProductUrl ="frmAllotOrderEdit.aspx";
        createProductList();
        dsProducts.baseParams.WhId=Ext.getCmp('WhId').getValue();
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
            sm.set('ProductUnit', record.data.Unit); 
            sm.set('ProductId', record.data.ProductId);
            
            dsProductUnitList.baseParams.ProductId = record.data.ProductId;
            dsProductUnitList.load();
            
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
            id: 'ProductCode',
            header: "����",
            dataIndex: 'ProductCode',
            width: 30,
            //editor: new Ext.form.TextField({ allowBlank: false })
            editor:productText,
            renderer:function(value,cellmeta){
                cellmeta.css = 'x-grid-back-blue';
                return value;
            }
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
                //cellmeta.css = 'x-grid-back-blue';
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
                var index = dsProductUnitList.findBy(function(record, id) {
                    return record.get(productUnitCombo.valueField) == value;
                });
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
                cellmeta.css = 'x-grid-back-blue';
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
                var index = dsProductSpecList.findBy(function(record, id) {
                    return record.get(productSpecCombo.valueField) == value;
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

    

    
    if (dsShiftPosOrderProduct == null) {
        dsShiftPosOrderProduct = new Ext.data.Store
	        ({
	            url: 'frmShiftPosOrderEdit.aspx?method=getShiftPosOrderProductList',
	            reader: new Ext.data.JsonReader({
	                totalProperty: 'totalProperty',
	                root: 'root'
	            }, RowPattern)
	        });
    }
    userGrid = new Ext.grid.EditorGridPanel({
        store: dsShiftPosOrderProduct,
        cm: cm,
        selModel: new Extensive.grid.ItemDeleter(),
        layout: 'fit',
        renderTo: 'divGrid',
        width: '100%',
        height: 170,
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
                    if(record.data.ProductId != dsProductUnitList.baseParams.ProductId)
                    {
                        dsProductUnitList.baseParams.ProductId = record.data.ProductId;
                        dsProductUnitList.load();
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
        height: 125,
        frame: true,
        labelWidth: 55,
        items: [
    {//��һ��
        layout: 'column',   //�����Ԫ��Ϊ����Ϊ�в��ַ�ʽ
        border: false,
        items: [{
            columnWidth: .35,  //����ռ�õĿ�ȣ���ʶΪ20��
            layout: 'form',
            border: false,
            items: [{
                xtype: 'textfield',
                fieldLabel: '������',
                readOnly: false,
                id: 'CarBoatNo',
                name: 'CarBoatNo',
                anchor: '90%'
            }]
            }, {
                columnWidth: .3,  //����ռ�õĿ�ȣ���ʶΪ30��
                layout: 'form',
                border: false,
                html: '&nbsp'
            }, {
                columnWidth: .35,  //����ռ�õĿ�ȣ���ʶΪ20��
                layout: 'form',
                border: false,
                items: [{
                    xtype: 'textfield',
                    //readOnly:true,
                    disabled: false,
                    fieldLabel: '��ע',
                    anchor: '90%',
                    name: 'Remark',
                    id: 'Remark'
                }]
            }]
        }, {//�ڶ���
            layout: 'column',   //�����Ԫ��Ϊ����Ϊ�в��ַ�ʽ
            border: false,
            items: [{
                columnWidth: .35,  //����ռ�õĿ�ȣ���ʶΪ20��
                layout: 'form',
                border: false,
                items: [{
               
                    xtype: 'combo',
                    fieldLabel: '����Ա',
                    anchor: '90%',
                    id: 'OperId',
                    displayField: 'EmpName',
                    valueField: 'EmpId',
                    editable: false,
                    store: dsOperationList,
                    mode: 'local',
                    value:<%=ZJSIG.UIProcess.ADM.UIAdmUser.EmployeeID(this) %>,
                    triggerAction: 'all',
                    disabled:true
                }]
                }, {
                    columnWidth: .3,  //����ռ�õĿ�ȣ���ʶΪ30��
                    layout: 'form',
                    border: false,
                    html: '&nbsp'
                }, {
                    columnWidth: .35,  //����ռ�õĿ�ȣ���ʶΪ20��
                    layout: 'form',
                    border: false,
                    items: [{
                        xtype: 'datefield',
                        disabled: true,
                        fieldLabel: '��������',
                        anchor: '90%',
                        format: 'Y��m��d��',
                        value: (new Date()),
                        id: 'CreateDate',
                        name: 'CreateDate'
                    }]
                }]
            }],
        buttons: [{
            text: "����",
            scope: this,
            id: 'saveButton',
            handler: function() {
                if(!checkUIData()) return;
                json = "";
                dsShiftPosOrderProduct.each(function(dsShiftPosOrderProduct) {
                    json += Ext.util.JSON.encode(dsShiftPosOrderProduct.data) + ',';
                });
                json = json.substring(0, json.length - 1);
                //alert(json);
                //alert(Ext.getCmp('InventoryDate').getValue());
                //Ȼ�����������
                Ext.Msg.wait("���ڱ�����Ϣ����","ϵͳ��ʾ");
                Ext.Ajax.request({
                    url: 'frmShiftPosOrderEdit.aspx?method=saveShiftPosOrderInfo',
                    method: 'POST',
                    params: {
                        //������
                        WhId: Ext.getCmp("WhId").getValue(),
                        OutWhpId: Ext.getCmp("OutWhpId").getValue(),
                        InWhpId: Ext.getCmp('InWhpId').getValue(),
                        OperId: Ext.getCmp('OperId').getValue(),
                        CreateDate: Ext.util.Format.date(Ext.getCmp('CreateDate').getValue(),'Y/m/d'),
                        Remark: Ext.getCmp('Remark').getValue(),
                        Status: Ext.getCmp("Status").getValue(),
                        OrderId: Ext.getCmp("OrderId").getValue(),
                        OrgId:Ext.getCmp("OrgId").getValue(),
                        LoadAmount:Ext.getCmp("LoadAmount").getValue(),
                        TransAmount:Ext.getCmp("TransAmount").getValue(),
                        TransType: getRadioValue('TransType'),
                        LoadType: getRadioValue('LoadType'),
                        LoadComId: Ext.getCmp('LoadComId').getValue(),
                        CarBoatNo: Ext.getCmp('CarBoatNo').getValue(),
                        LoadPrice: Ext.getCmp('LoadPrice').getValue(),
                        TransPrice: Ext.getCmp('TransPrice').getValue(),
                        //��ϸ����
                        DetailInfo: json
                    },
                    success: function(resp, opts) {
                        Ext.Msg.hide();
                       if(checkParentExtMessage(resp,parent))
                        {
                            //Ext.getCmp("saveButton").setDisabled(true);
                            //parent.updateDataGrid();
                            //parent.uploadShiftPosOrderWindow.hide();
                            parent.uploadShiftPosOrderWindow.hide();
                        }
                    }
                , failure: function(resp, opts) {
                    Ext.Msg.hide();
                    Ext.Msg.alert("��ʾ", "����ʧ�ܣ�");
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
                    Ext.MessageBox.confirm("��ʾ��Ϣ", "�Ƿ����Ҫ�ύ���ƿⵥ��Ϣ��", function callBack(id) {
                        //�ж��Ƿ�ɾ������
                        if (id == "yes") {
                            json = "";
                            dsShiftPosOrderProduct.each(function(dsShiftPosOrderProduct) {
                                json += Ext.util.JSON.encode(dsShiftPosOrderProduct.data) + ',';
                            });
                            json = json.substring(0, json.length - 1);
                            //alert(json);
                            //ҳ���ύ
                            Ext.Ajax.request({
                                url: 'frmShiftPosOrderEdit.aspx?method=commitShiftPosOrder',
                                method: 'POST',
                                params: {
                                    //������
                                    WhId: Ext.getCmp("WhId").getValue(),
                                    OutWhpId: Ext.getCmp("OutWhpId").getValue(),
                                    InWhpId: Ext.getCmp('InWhpId').getValue(),
                                    OperId: Ext.getCmp('OperId').getValue(),
                                    CreateDate: Ext.util.Format.date(Ext.getCmp('CreateDate').getValue(),'Y/m/d'),
                                    Remark: Ext.getCmp('Remark').getValue(),
                                    Status: Ext.getCmp("Status").getValue(),
                                    OrderId: Ext.getCmp("OrderId").getValue(),
                                    OrgId:Ext.getCmp("OrgId").getValue(),
                                    LoadAmount:Ext.getCmp("LoadAmount").getValue(),
                                    TransAmount:Ext.getCmp("TransAmount").getValue(),
                                    TransType: getRadioValue('TransType'),
                                    LoadType: getRadioValue('LoadType'),
                                    LoadComId: Ext.getCmp('LoadComId').getValue(),
                                    CarBoatNo: Ext.getCmp('CarBoatNo').getValue(),
                                    LoadPrice: Ext.getCmp('LoadPrice').getValue(),
                                    TransPrice: Ext.getCmp('TransPrice').getValue(),
                                    //��ϸ����
                                    DetailInfo: json
                                },
                                success: function(resp, opts) {
                                    if(checkExtMessage(resp))
                                    {
                                        Ext.getCmp("saveButton").setDisabled(true);
                                        Ext.getCmp("commitButton").setDisabled(true);
                                    }
                                },
                                failure: function(resp, opts) {
                                    Ext.Msg.alert("��ʾ", "�����ύʧ�ܣ�");
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
                             parent.uploadShiftPosOrderWindow.hide();
                         }
}]
    });
    footerForm.render();
    Ext.getCmp("OrderId").setValue(OrderId);

    setAllFormValue();
    
   var columnCount = userGrid.getColumnModel().getColumnCount();
    for (var i = 0; i < columnCount; i++) {
        userGrid.getColumnModel().setEditable(i, false);
    }
    
if(OperType != "look"){
    userGrid.getColumnModel().setEditable(2, true);
    userGrid.getColumnModel().setEditable(4, true);
    userGrid.getColumnModel().setEditable(3, true);
    userGrid.getColumnModel().setEditable(6, true)
    userGrid.getColumnModel().setEditable(7, true); 
}
else{
    Ext.getCmp("saveButton").hide();
    Ext.getCmp("commitButton").hide();
    Ext.getCmp("WhId").setDisabled(true);
    Ext.getCmp("OutWhpId").setDisabled(true);
    Ext.getCmp("InWhpId").setDisabled(true);
    Ext.getCmp("TransPrice").setDisabled(true);
    Ext.getCmp("LoadPrice").setDisabled(true);
    Ext.getCmp("TransAmount").setDisabled(true);
    Ext.getCmp("LoadAmount").setDisabled(true);
     Ext.getCmp("CarBoatNo").setDisabled(true);
    Ext.getCmp("LoadComId").setDisabled(true);
    Ext.getCmp("Remark").setDisabled(true);
}
 //��������ǰ
function checkUIData(){
    var check = true;
    
    var outWhpId = Ext.getCmp("OutWhpId").getValue();
    var inWhpId = Ext.getCmp("InWhpId").getValue();
    if(inWhpId == outWhpId){
        Ext.Msg.alert("��ʾ", "�Ƴ���λ���ܺ������λ��ͬ��");
        return false;
    }
    var rowCount = dsShiftPosOrderProduct.getCount();
    var index = 0;
    dsShiftPosOrderProduct.each(function(record,grid){
        if(index<rowCount-1){
            index++;//alert(record.get("WhpId"));

            if(record.get("ProductQty") == undefined || parseFloat(record.get("ProductQty"))<=0){
                Ext.Msg.alert("��ʾ", "���������û����д��");
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
        Ext.Msg.alert("��ʾ","�Ʋֲ���Ʒ����Ϊ�㣡");
        return false;
    }
    return check;
}   

    /*----------------footerframe----------------*/
})

</script>

</html>

