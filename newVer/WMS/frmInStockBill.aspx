<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmInStockBill.aspx.cs" Inherits="WMS_frmInStockBill" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
    <title>��λ����ҳ��</title>
    <meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
    <link rel="stylesheet" type="text/css" href="../ext3/resources/css/ext-all.css" />

    <script type="text/javascript" src="../ext3/adapter/ext/ext-base.js"></script>

    <script type="text/javascript" src="../ext3/ext-all.js"></script>

    <script type="text/javascript" src="../ext3/example/ItemDeleter.js"></script>
    <script type="text/javascript" src="../js/operateResp.js"></script>
    <script type="text/javascript" src="../ext3/src/locale/ext-lang-zh_CN.js"></script>
    <style type="text/css">
        .extensive-remove
        {
            background-image: url(../Theme/1/images/extjs/customer/cross.gif) !important;
        }
        .x-grid-back-blue { 
            background: #C3D9FF; 
        }
    </style>
    <script type="text/javascript">
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
        var OrderId = args["id"];
        var FromBillType = args["type"];
        var QcProductId = args["productId"];
        var CheckId = args["checkId"];
        var version =parseFloat(navigator.appVersion.split("MSIE")[1]);
        if(version == 6)
            version = 1;
        else //!ie6 contain double size
            version = 2; //alert(OrderId+":"+FromBillType);
            
        var dsWarehousePosList;
        var dsInStockProductDetail;
        var userGrid;
        var productCombo;
    </script>
</head>
<body>
    <div id='title' style='background-color:#DFE8F6;width: 100%; height: 35px; overflow: hidden; padding-top: 5px;'>
        <table width="100%" style="background-color:#DFE8F6">
            <tr>
                <%--<td align="right" valign="bottom">
                    No. δ���� <!--No.2000909090009��c#��ȡ��-->
                </td>--%>
                <td style="width: 5px">
                </td>
            </tr>
            <tr>
                <td align="center" valign="middle" style="font-size: larger;" colspan="2">
                    <%=ZJSIG.UIProcess.ADM.UIAdmUser.OrgName(this) %><span id="stockMode">��</span>�ֵ�
                </td>
            </tr>
        </table>
    </div>
    <div id="topform">
    </div>
    <div id="userdatagrid">
    </div>
    <div id="transport">
    </div>
    <div id="footer">
    </div>
    <select id='bindipSelct' style="display: none;">
        <option value="��">��</option>
        <option value="��">��</option>
    </select>
</body>
<%= getComboBoxStore() %>

<script type="text/javascript">
Ext.BLANK_IMAGE_URL = "../ext3/resources/images/default/s.gif";
//���´��벻Ҫ�� 
Ext.grid.CheckColumn = function(config) {
    Ext.apply(this, config);
    if (!this.id) {
        this.id = Ext.id();
    }
    this.renderer = this.renderer.createDelegate(this);
};

Ext.grid.CheckColumn.prototype = {
    init: function(grid) {
        this.grid = grid;
        this.grid.on('render', function() {
            var view = this.grid.getView();
            view.mainBody.on('mousedown', this.onMouseDown, this);
        }, this);
    },
    onMouseDown: function(e, t) {
        if (t.className && t.className.indexOf('x-grid3-cc-' + this.id) != -1) {
            e.stopEvent();
            var index = this.grid.getView().findRowIndex(t);
            var record = this.grid.store.getAt(index);
            record.set(this.dataIndex, !record.data[this.dataIndex]);
        }
    },
    renderer: function(v, p, record) {
        p.css += ' x-grid3-check-col-td';
        return '<div class="x-grid3-check-col' + (v ? '-on' : '') + ' x-grid3-cc-' + this.id + '"> </div>';
    }
};
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
/*********************/
function caculateFee(flag){
    var totalTransAmount =0;
    var totalLoadAmount =0;
    dsInStockProductDetail.each(function(record,grid){
        var qty = record.get("RealQty"); 
        if (qty =="" ||qty==0) return;
        try{
            if(flag==0)
                totalTransAmount += accMul(parseFloat(qty),record.get("TransPrice"));
            if(flag==1)
                totalLoadAmount += accMul(parseFloat(qty),record.get("LoadPrice"));
        }catch(err){
        }
    });    
    if(flag==1){
        if(totalLoadAmount>0 && getRadioValue('LoadType')=='W0401'){
            setRadioValue('LoadType','W0402');//default car
            Ext.getCmp('LoadComId').setDisabled(false);
        }
        Ext.getCmp('TotalLoadAmount').setValue(totalLoadAmount.toFixed(2));  
    }
    if(flag==0){
        if(totalTransAmount>0 && getRadioValue('TransType')=='W0401'){
            setRadioValue('TransType','W0402');//default car
            Ext.getCmp('TransComId').setDisabled(false);
        }
        Ext.getCmp('TotalTransAmount').setValue(totalTransAmount.toFixed(2));  
    }  
}
/*********************/
var scope;
Ext.onReady(function() {

scope = this;
//��grid��ϸ��¼��װ��json���ύ��UI��decode
var json = '';
/*----------------topframe----------------*/
var topForm = new Ext.FormPanel({
    el: 'topform',
    border: true, // û�б߿�
    labelAlign: 'left',
    buttonAlign: 'right',
    bodyStyle: 'padding:2px',
    height: 65,
    frame: true,
    labelWidth: 55,
    items: [{
        layout: 'column',   //�����Ԫ��Ϊ����Ϊ�в��ַ�ʽ
        border: false,
        items: [{
            columnWidth: .25,  //����ռ�õĿ�ȣ���ʶΪ20��
            layout: 'form',
            border: false,
            items: [
            {
                xtype: 'hidden',
                fieldLabel: 'ԭʼ������',
                name: 'FromBillId',
                id: 'FromBillId',
                hide: true
            },
            {
                xtype: 'hidden',
                fieldLabel: '������',
                name: 'OrderId',
                id: 'OrderId',
                hide: true
            }
            , {
                xtype: 'combo',
                fieldLabel: '��������',
                anchor: '95%',
                id: 'FromBillType',
                displayField: 'DicsName',
                valueField: 'DicsCode',
                editable: false,
                store: dsBillTypeList,
                mode: 'local',
                triggerAction: 'all',
                disabled:true
                }]
                <%if(type=="W0202"){ %>
            }, {
                columnWidth: .3,
                layout: 'form',
                border: false,
                items: [{
                     xtype: 'textfield',
                    fieldLabel: '�ͻ�',
                    anchor: '95%',
                    id: 'CustomerName',
                    disabled:true
//                    xtype: 'combo',
//                    fieldLabel: '�ͻ�',
//                    anchor: '95%',
//                    id: 'CustomerId',
//                    displayField: 'ChineseName',
//                    valueField: 'CustomerId',
//                    editable: false,
//                    store: dsCustomerListInfo,
//                    mode: 'local',
//                    triggerAction: 'all',
//                    disabled:true
                 },{
                    xtype: 'hidden',
                    fieldLabel: '�ͻ�',
                    anchor: '95%',
                    id: 'CustomerId',
                    hide: true,
                    hideLabel:true
                }]
                <%}else{ %>
                }, {
                columnWidth: .3,
                layout: 'form',
                border: false,
                items: [{
                    xtype: 'textfield',
                    fieldLabel: '��Ӧ��',
                    anchor: '95%',
                    id: 'SupplierName',
                    disabled:true
//                    xtype: 'combo',
//                    fieldLabel: '��Ӧ��',
//                    anchor: '95%',
//                    id: 'SupplierId',
//                    displayField: 'ChineseName',
//                    valueField: 'CustomerId',
//                    editable: false,
//                    store: dsSuppliesListInfo,
//                    mode: 'local',
//                    triggerAction: 'all',
//                    disabled:true
                },{
                    xtype: 'hidden',
                    fieldLabel: '��Ӧ��',
                    anchor: '95%',
                    id: 'SupplierId',
                    hide: true,
                    hideLabel:true
                }
                ]
                <%} %>
            }, {
                layout: 'table',
                columnWidth: .25,
                items: [
                {
                    layout: 'fit',
                    anchor: '95%'//,
                    //html: '¼������:&nbsp;&nbsp;'
                }, {
                    columnWidth: .5//,
//                    items: [new Ext.form.Radio({
//                        id: 'Normal',
//                        name: 'IsRedWord',
//                        checked: true,
//                        anchor: '95%',
//                        boxLabel: '����',
//                        inputValue: 0
//                    })
//                 ]
                }, {
                    columnWidth: .5//,
//                    items: [new Ext.form.Radio({
//                        id: 'RedFont',
//                        name: 'IsRedWord',
//                        anchor: '95%',
//                        boxLabel: '����',
//                        inputValue: 1
//                    })]
                }]
            }, {
                columnWidth: .2, 
                layout: 'form',
                border: false,
                items: [{
                    xtype: 'label',
                    style: 'vertical-align: bottom;',
                    text: '״̬:'
                }, {
                    xtype: 'label',
                    text: '�ݸ�',
                    readOnly: true,
                    y: 5,
                    id: 'zt'
                }]
            }]
        }, {
            layout: 'column',   //�����Ԫ��Ϊ����Ϊ�в��ַ�ʽ
            border: false,
            items: [
            {
                columnWidth: .25,  //����ռ�õĿ�ȣ���ʶΪ20��
                layout: 'form',
                border: false,
                items: [{
                    xtype: 'textfield',
                    fieldLabel: '�ֹ�˾',
                    anchor: '95%',
                    id: 'OrgName',
                    value:'<%=ZJSIG.UIProcess.ADM.UIAdmUser.OrgName(this)%>',
                    disabled:true
                },{
                    xtype: 'hidden',
                    fieldLabel: '�ֹ�˾ID',
                    anchor: '95%',
                    id: 'OrgId',
                    hide: true,
                    hideLabel:true
//                    xtype: 'combo',
//                    fieldLabel: '�ֹ�˾',
//                    anchor: '95%',
//                    id: 'OrgId',
//                    displayField: 'OrgName',
//                    valueField: 'OrgId',
//                    editable: false,
//                    store: dsOrgListInfo,
//                    mode: 'local',
//                    triggerAction: 'all',
//                    disabled:true
                }]
            }, {
                columnWidth: .3,
                layout: 'form',
                border: false,
                items: [{
                    xtype: 'combo',
                    fieldLabel: '�ֿ�����',
                    anchor: '95%',
                    id: 'WhId',
                    displayField: 'WhName',
                    valueField: 'WhId',
                    editable: false,
                    store: dsWarehouseList,
                    mode: 'local',
                    triggerAction: 'all',
                    disabled:true,
                    listeners: {
                        select: function(combo, record, index) {
                            var curWhId = Ext.getCmp("WhId").getValue();
                            dsWarehousePosList.load({
                                params: {
                                    WhId: curWhId
                                }
                            });
                            //clear whp
                            var icount = dsInStockProductDetail.getCount();
                            for(var i =0;i<icount -1;i++)
                                dsInStockProductDetail.getAt(i).set('WhpId',"0");
                        }
                    }
                }]
            }, {
                columnWidth: .25,
                layout: 'form',
                border: false,
                items: [{
                    xtype: 'combo',
                    fieldLabel: '����Ա',
                    anchor: '95%',
                    id: 'WarehouseAdmin',
                    displayField: 'EmpName',
                    valueField: 'EmpId',
                    editable: false,
                    store: dsOperationList,
                    mode: 'local',
                    triggerAction: 'all',
                    disabled:true,
                    value:<%=ZJSIG.UIProcess.ADM.UIAdmUser.EmployeeID(this) %>
                    }]
            }, {
                columnWidth: .2,
                layout: 'form',
                border: false,
                items: [{
                    xtype: 'checkbox',
                    boxLabel: '�Ƿ��ʼ��',
                    hideLabel: true,
                    anchor: '95%',
                    id: 'IsInitBill'}]
        }]
    }]
});
topForm.render();
/*----------------topframe----------------*/

function addNewBlankRow(combo, record, index) {
    var rowIndex = userGrid.getStore().indexOf(userGrid.getSelectionModel().getSelected());
    var rowCount = userGrid.getStore().getCount();
    if ((rowIndex == 0 && rowCount == 1) || rowIndex == rowCount - 1) {
        inserNewBlankRow();
    }
}

//��λ����Դ

if (dsWarehousePosList == null) { //��ֹ�ظ�����
    //alert(Ext.getCmp("WhId").getValue());
    dsWarehousePosList = new Ext.data.Store
    ({
        url: 'frmInStockBill.aspx?method=getWarehousePosList',
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
productCombo = new Ext.form.ComboBox({
    store: dsProductList,
    displayField: 'ProductName',
    valueField: 'ProductId',
    triggerAction: 'all',
    id: 'productCombo',
    //typeAhead: true,
    mode: 'local',
    emptyText: '',
    selectOnFocus: true,
    editable: true,
    onSelect: function(record) {
        var sm = userGrid.getSelectionModel().getSelected();
        sm.set('ProductCode', record.data.ProductNo);
        sm.set('ProductSpec', record.data.Specifications);
        sm.set('ProductUnit', record.data.Unit);
        sm.set('ProductId', record.data.ProductId);
        sm.set('ProductPrice',record.data.ProductPrice);
        if(record.data.RealQty>0)
            sm.set('BookQty',record.data.RealQty);
        if(FromBillType != "W0211")
            sm.set('UnitId',record.data.UnitId);        
        addNewBlankRow();
        
    }
});

function regexValue(qe){
    var combo = qe.combo;  
    //q is the text that user inputed.  
    var q = qe.query;  
    forceAll = qe.forceAll;  
    if(forceAll === true || (q.length >= combo.minChars)){  
     if(combo.lastQuery !== q){  
         combo.lastQuery = q;  
         if(combo.mode == 'local'){  
             combo.selectedIndex = -1;  
             if(forceAll){  
                 combo.store.clearFilter();  
             }else{  
                 combo.store.filterBy(function(record,id){  
                     var text = record.get(combo.displayField);  
                     //������д�Լ��Ĺ��˴���  
                     return (text.indexOf(q)!=-1);  
                 });  
             }  
             combo.onLoad();  
         }else{  
             combo.store.baseParams[combo.queryParam] = q;  
             combo.store.load({  
                 params: combo.getParams(q)  
             });  
             combo.expand();  
         }  
     }else{  
         combo.selectedIndex = -1;  
         combo.onLoad();  
     }  
    }  
    return false;  
}
productCombo.on('beforequery',function(qe){  
    regexValue(qe);
});

function formatDate(value) {
    return value ? value.dateFormat('Y��m��d��') : '';
};
// shorthand alias  
var fm = Ext.form;

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
        "select": function(combo, record, index) {
                    addNewBlankRow(combo, record, index);
                    userGrid.startEditing(2,0);                    
                }
    }
});
var selectRecord = null;
var itemDeleter = new Extensive.grid.ItemDeleter();
var sm = new Ext.grid.CheckboxSelectionModel({ singleSelect: true });
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
        width: 70,
        editor: warehousePosCombo,
        renderer: function(value, cellmeta, record, rowIndex, columnIndex, store) {
            var index = dsWarehousePosList.findBy(function(record, id) {
                return record.get(warehousePosCombo.valueField) == value;
            });
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
        header: "��Ʒ����",
        dataIndex: 'ProductCode',
        width: 55,
        editor: new Ext.form.TextField({ allowBlank: false })
    },
//    {
//    id: 'ProductName',
//        header: "��Ʒ",
//        dataIndex: 'ProductName',
//        width: 85
//        },
    {
        id: 'ProductId',
        header: "��Ʒ����",
        dataIndex: 'ProductId',
        width: 150,
        editor: productCombo,
        renderer: function(value, cellmeta, record, rowIndex, columnIndex, store) {
            var index = dsProductList.findBy(function(record, id) {
                return record.get(productCombo.valueField) == value;
            });

            var record = dsProductList.getAt(index);
            var displayText = "";
            if (record == null) {
                displayText = value;
            } else {
                displayText = record.data.ProductName; 
            }
            productCombo.collapse();//hide
            cellmeta.css = 'x-grid-back-blue';
            return displayText;
        }
    },

    {
        id: 'ProductSpec',
        header: "���",
        dataIndex: 'ProductSpec',
        width: 50,
        editor: new Ext.form.TextField({ allowBlank: false })
    }, {
        id: "ProductUnit",
        header: "��λ",
        dataIndex: "ProductUnit",
        width: 40,
        editor: new Ext.form.TextField({ allowBlank: false })
    }
    , {
        id: 'ProductPrice',
        header: "�۸�",
        dataIndex: 'ProductPrice',
		decimalPrecision:8,
        width: 50,
        <%if(type == "W0206"||type == "W0211"){ %>
        renderer: function(v, m) {
                m.css = 'x-grid-back-blue';
                return v;
            },
        <%} %>
        editor: new Ext.form.TextField({ allowBlank: false })
    }, {
        id: 'BookQty',
        header: "��������",
        dataIndex: 'BookQty',
        decimalPrecision:6,
        width: 60,
        editor: new Ext.form.TextField({ allowBlank: false })
    }, {
        id: 'RealQty',
        header: "ʵ������",
        dataIndex: 'RealQty',
        decimalPrecision:6,
        width: 60,
        renderer: function(v, m) {
                m.css = 'x-grid-back-blue';
                return v;
            },
        editor: new Ext.form.TextField({ allowBlank: false })
    }, {
        id: 'TransPrice',
        header: "���䵥��",
        dataIndex: 'TransPrice',
        width: 55,
        editor: new Ext.form.NumberField({ 
            allowBlank: false, 
            decimalPrecision:8,
            listeners: {  
                 'focus':function(){  
        		        this.selectText();
        		        selectRecord = userGrid.getSelectionModel().getSelected();   
        	     },
    	         'change': function(oppt){
    	            var record = selectRecord;
        	        record.set('TransPrice', oppt.value);
    	            caculateFee(0);
    	        } 
           }
        })
    }, {
        id: 'LoadPrice',
        header: "װж����",
        dataIndex: 'LoadPrice',
        decimalPrecision:8,
        width: 55,
        value:0,
        editor: new Ext.form.NumberField({ 
            allowBlank: false , 
            decimalPrecision:8,
            listeners: {  
                 'focus':function(){                      
        		    this.selectText();
        		    selectRecord = userGrid.getSelectionModel().getSelected();   
        	     },
    	         'change': function(oppt){
    	            var record = selectRecord;
        	        record.set('LoadPrice', oppt.value);
    	            caculateFee(1);
    	        } 
           }
        })
    }, {
        id: "UnitId",
        header: "��λ",
        dataIndex: "UnitId",
        hidden: true,
        hidable:true
    }, itemDeleter
]);
cm.defaultSortable = true;
var RowPattern_Purchase = Ext.data.Record.create([
//{ name: 'OrderDetailId', type: 'string' },
   {name: 'WhpId', type: 'string' },
   { name: 'ProductCode', type: 'string' },
   { name: 'ProductId', type: 'string' },
   { name: 'ProductName', type: 'string' },
   { name: 'ProductSpec', type: 'string' },
   { name: 'ProductUnit', type: 'string' },
   { name: 'ProductPrice', type: 'string' },
   { name: 'BookQty', type: 'string' },
   { name: 'RealQty', type: 'string' },
   { name: 'UnitId', type: 'string' },
   { name: 'LoadPrice', type: 'string' },
   { name: 'TransPrice', type: 'string' }
 ]);

if (dsInStockProductDetail == null) {
    if (FromBillType == "W0201") {
        dsInStockProductDetail = new Ext.data.Store
        ({
            url: 'frmInStockBill.aspx?method=getPurchaseOrderListInfo',
            reader: new Ext.data.JsonReader({
                totalProperty: 'totalProperty',
                root: 'root'
            }, RowPattern_Purchase)
        });
    }
    else if(FromBillType == "W0211"){
        //alert(FromBillType+"ppp");
        dsInStockProductDetail = new Ext.data.Store
        ({
            url: 'frmInStockBill.aspx?method=getPurchaseOrderListInfo',
            reader: new Ext.data.JsonReader({
                totalProperty: 'totalProperty',
                root: 'root'
            }, RowPattern_Purchase)
        });
    }
    else if(FromBillType == "W0202"){//������ϸ��¼
        dsInStockProductDetail = new Ext.data.Store
        ({
            url: 'frmInStockBill.aspx?method=getSalesOrderListInfo',
            reader: new Ext.data.JsonReader({
                totalProperty: 'totalProperty',
                root: 'root'
            }, RowPattern_Purchase)
        });
    }
    else if (FromBillType == "W0205") {
        //alert('W0205');
        dsInStockProductDetail = new Ext.data.Store
        ({
            url: 'frmInStockBill.aspx?method=getAllotOrderOutListInfo',
            reader: new Ext.data.JsonReader({
                totalProperty: 'totalProperty',
                root: 'root'
            }, RowPattern_Purchase)
        });
    }
    else if (FromBillType == "W0206") {
        dsInStockProductDetail = new Ext.data.Store
        ({
            url: 'frmInStockBill.aspx?method=getAllotOrderInListInfo',
            reader: new Ext.data.JsonReader({
                totalProperty: 'totalProperty',
                root: 'root'
            }, RowPattern_Purchase)
        });
    }
    else if (FromBillType == "W0204" || FromBillType == "W0209") {// || FromBillType == "W0210"
        dsInStockProductDetail = new Ext.data.Store
        ({
            url: 'frmInStockBill.aspx?method=getReturnOrderListInfo',
            reader: new Ext.data.JsonReader({
                totalProperty: 'totalProperty',
                root: 'root'
            }, RowPattern_Purchase)
        });
    }
    else if(FromBillType == "W0210" || FromBillType == "W0212" || FromBillType == "W0213" ){//������ϸ��¼
        dsInStockProductDetail = new Ext.data.Store
        ({
            url: 'frmInStockBill.aspx?method=getProduceOrderListInfo',
            reader: new Ext.data.JsonReader({
                totalProperty: 'totalProperty',
                root: 'root'
            }, RowPattern_Purchase)
        });
    }
    else {
        dsInStockProductDetail = new Ext.data.Store
        ({
            url: 'frmInStockBill.aspx?method=getInStockProductDetailInfo',
            reader: new Ext.data.JsonReader({
                totalProperty: 'totalProperty',
                root: 'root'
            }, RowPattern)
        });
    }
    
}
//grid
userGrid = new Ext.grid.EditorGridPanel({
    id:'userGrid',
    store: dsInStockProductDetail,
    cm: cm,
    selModel: itemDeleter,
    layout: 'fit',
    bodyStyle:'padding:0px',
    renderTo: 'userdatagrid',
    width: document.body.offsetWidth,
    height: 160,
    stripeRows: true,
    frame: true,
    clicksToEdit: 1,
    viewConfig: {
        columnsText: '��ʾ����',
        scrollOffset: 20,
        sortAscText: '����',
        sortDescText: '����',
        forceFit: false
    },
    listeners : { 
        beforeedit : function(obj){             
            userGrid.getSelectionModel().selectRow(obj.row);
        } 
    }
});

inserNewBlankRow();
/*----------------tansportframe----------------*/
var transportForm = new Ext.FormPanel({
    el: 'transport',
    border: true, // û�б߿�
    labelAlign: 'left',
    buttonAlign: 'right',
    bodyStyle: 'padding:2px',
    height: 65,
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
                    hideLabel:true,
                    listeners: {
                        "check": onCheckedTrans
                    }
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
            items: [
            {
                columnWidth: .5*version,  //����ռ�õĿ�ȣ���ʶΪ20��
                layout: 'form',
                border: false,
                items: [
                {
                    xtype: 'combo',
                    fieldLabel: '���䵥λ',
                    anchor: '95%',
                    id: 'TransComId', //dsLoadCompanyList
                    displayField: 'Name',
                    valueField: 'Id',
                    editable: false,
                    store: dsTransCompanyList,
                    mode: 'local',
                    triggerAction: 'all'
                }]
            }]
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
                    hideLabel:true,
                    listeners: {
                        "check": onCheckedLoad
                    }
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
                    anchor: '95%',
                    id: 'LoadComId', //dsLoadCompanyList
                    displayField: 'Name',
                    valueField: 'Id',
                    editable: false,
                    store: dsLoadCompanyList,
                    mode: 'local',
                    triggerAction: 'all'
                }]
            }]
        }
        ]
    }
    ]
});
transportForm.render();

function onCheckedTrans(el){
    if(el.checked){
        Ext.getCmp('TransComId').setValue('');
        
        Ext.getCmp('TransComId').setDisabled(true);
        
        if(Ext.getCmp('TotalTransAmount')!=null)
            Ext.getCmp('TotalTransAmount').setValue(0);
    }
    else{
        Ext.getCmp('TransComId').setDisabled(false);
    }
}
function onCheckedLoad(el){
    if(el.checked){
        Ext.getCmp('LoadComId').setValue('');        
        Ext.getCmp('LoadComId').setDisabled(true);        
        if(Ext.getCmp('TotalLoadAmount')!=null)
            Ext.getCmp('TotalLoadAmount').setValue(0);
    }
    else{
        Ext.getCmp('LoadComId').setDisabled(false);
    }
}
onCheckedLoad(Ext.getCmp('ZxNone'));
onCheckedTrans(Ext.getCmp('None'));
/*----------------tansportframe----------------*/
/*----------------footerframe----------------*/
var footerForm = new Ext.FormPanel({
    el: 'footer',
    border: true, // û�б߿�
    labelAlign: 'left',
    buttonAlign: 'center',
    bodyStyle: 'padding:2px',
    height: 100,
    frame: true,
    labelWidth: 65,
    items: [
    {//��һ��
        layout: 'column',   //�����Ԫ��Ϊ����Ϊ�в��ַ�ʽ
        border: false,
        items: [{
            columnWidth: .33,  //����ռ�õĿ�ȣ���ʶΪ20��
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
                columnWidth: .33,  //����ռ�õĿ�ȣ���ʶΪ30��
                layout: 'form',
                border: false,
                items: [{
                    xtype: 'numberfield',
                    fieldLabel: '�����ܷ���',
                    anchor: '90%',
                    name: 'TotalTransAmount',
                    id: 'TotalTransAmount',
                    value: 0,
                    decimalPrecision:2,
                    style: "text-align: right;"
                }]
            }, {
                columnWidth: .33,  //����ռ�õĿ�ȣ���ʶΪ20��
                layout: 'form',
                border: false,
                items: [{
                    xtype: 'numberfield',
                    fieldLabel: 'װж�ܷ���',
                    anchor: '90%',
                    name: 'TotalLoadAmount',
                    id: 'TotalLoadAmount',
                    value: 0,
                    decimalPrecision:2,
                    style: "text-align: right;"
                }]
            }]
        }, {//�ڶ���
            layout: 'column',   //�����Ԫ��Ϊ����Ϊ�в��ַ�ʽ
            border: false,
            items: [{
                columnWidth: .33,  //����ռ�õĿ�ȣ���ʶΪ20��
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
                    triggerAction: 'all',
                    disabled:true,
                    value:<%=ZJSIG.UIProcess.ADM.UIAdmUser.EmployeeID(this) %>
                }]
                }, {
                    columnWidth: .33,  //����ռ�õĿ�ȣ���ʶΪ30��
                    layout: 'form',
                    border: false,
                    items: [{
                        xtype: 'datefield',
                        //readOnly:true,
                        disabled: true,
                        fieldLabel: '��������',
                        anchor: '90%',
                        format: 'Y��m��d��',
                        value: (new Date()),
                        id: 'CreateDate',
                        name: 'CreateDate'
                    }]
                }, {
                    columnWidth: .33,  //����ռ�õĿ�ȣ���ʶΪ20��
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
            }],
            buttons: [{
                text: "����",
                scope: this,
                id:'BtnSave',
                handler: function() {
                    Ext.MessageBox.wait("���������ύ�����Ժ򡭡�");
                    if(!checkUIData()) return;//�������
                    var loadCompany = Ext.getCmp("LoadComId").getValue();
                    var transCompany = Ext.getCmp("TransComId").getValue();
                     
                    //alert(loadAmount +"-"+transAmount+"-"+loadCompany);
                    if(getRadioValue('LoadType')!='W0401'){
                        if(loadCompany == '' || parseInt(loadCompany)<=0){
                            Ext.Msg.alert("��ʾ","װж��λ���ܿգ�");
                            return;
                        }
                    }
                    if(getRadioValue('TransType')!='W0401'){
                        if(transCompany == '' || parseInt(transCompany)<=0){
                            Ext.Msg.alert("��ʾ","���䵥λ���ܿգ�");
                            return;
                        }
                    }

                    json = "";
                    dsInStockProductDetail.each(function(dsInStockProductDetail) {
                        json += Ext.util.JSON.encode(dsInStockProductDetail.data) + ',';
                    });
                    json = json.substring(0, json.length - 1);
                    //Ȼ�����������
                    //alert(Ext.getCmp('CustomerId').getValue());
                    //return;
                    Ext.Ajax.request({
                        url: 'frmInStockBill.aspx?method=SaveInStockOrder',
                        method: 'POST',
                        params: {
                            //������
                            OrderId: Ext.getCmp('OrderId').getValue(),
                            WhId: Ext.getCmp('WhId').getValue(),
                            <%if(type=="W0201"){ %>
                            SupplierId: Ext.getCmp('SupplierId').getValue(),
                            CustomerId:0,
                            <%}else if(type=="W0202"){ %>
                            CustomerId: Ext.getCmp('CustomerId').getValue(),
                            SupplierId:0,
                            <%}else{ %>
                            SupplierId:0,
                            CustomerId:0,
                            <%} %>
                            Remark: Ext.getCmp('Remark').getValue(),
                            OrgId: Ext.getCmp('OrgId').getValue(),
                            OperId: Ext.getCmp('OperId').getValue(),
                            FromBillType: Ext.getCmp('FromBillType').getValue(),
                            TransAmount: Ext.getCmp('TotalTransAmount').getValue(),
                            LoadAmount: Ext.getCmp('TotalLoadAmount').getValue(),
                            TransType: getRadioValue('TransType'),
                            LoadType: getRadioValue('LoadType'),
                            LoadComId: loadCompany,
                            TransComId: transCompany,
                            CarBoatNo: Ext.getCmp('CarBoatNo').getValue(),
                            LoadPrice: 0,
                            TransPrice: 0,
                            IsInitBill: Ext.getCmp('IsInitBill').getValue(),
                            IsRedWord: 0,//getRadioValue('IsRedWord'),
                            WarehouseAdmin: Ext.getCmp('WarehouseAdmin').getValue(),
                            QcProductId:QcProductId,//����ǰ��Ʒ
                            QcCheckId:CheckId,//����֪ͨ��ID
                            FromBillId: Ext.getCmp('FromBillId').getValue(),
                            //��ϸ����
                            DetailInfo: json
                        },
                        success: function(resp, opts) {
                            Ext.MessageBox.hide();
                            if(checkParentExtMessage(resp,parent))
                            {                                
                                Ext.getCmp("BtnSave").setDisabled(true);
                                Ext.MessageBox.hide();
                                parent.uploadOrderWindow.hide();
                            }                            
                        }
                    });

                }
            },
            {
                 text: "�ر�",
                 scope: this,
                 handler: function() {
                     parent.uploadOrderWindow.hide();
                 }
    }]
});
footerForm.render();
/*----------------footerframe----------------*/
                                                                                                                                    
 //��������ǰ
function checkUIData(){
    var check = true;
  
    var rowCount = dsInStockProductDetail.getCount();
    var index = 0;
    dsInStockProductDetail.each(function(record,grid){
        if(index<rowCount-1){
            index++;//alert(record.get("WhpId"));
            if(record.get("WhpId") == undefined || record.get("WhpId") == "" ||parseInt(record.get("WhpId"))<1){
                Ext.Msg.alert("��ʾ", "����в�λû��ѡ��");
                check = false;
                return;
            }
           
            if(record.get("RealQty") == undefined || parseFloat(record.get("RealQty"))==0){
                Ext.Msg.alert("��ʾ", "�����ʵ������û����д��");
                check = false;
                return;
            }
            //alert(record.get("ProductId")+"___lll");
            if(record.get("ProductId") == undefined || record.get("ProductId") == "" || parseInt(record.get("ProductId"))<=0){
                Ext.Msg.alert("��ʾ", "�������Ʒû��ѡ��");
                check = false;
                return;
            }
            else{
                if(FromBillType == "W0211"){//�ɹ�����
                    if(QcProductId == record.get("ProductId")){
                        Ext.Msg.alert("��ʾ", "������Ʒ���ܺ�ԭ���ɹ���Ʒ��ͬ��");
                        check = false;
                        return;
                    }
                }
            }   
        }
    });
    if(rowCount == 1){
        Ext.Msg.alert("��ʾ","�������Ʒ����Ϊ�㣡");
        return false;
    }
    return check;
}

userGrid.getColumnModel().setEditable(3, false);
    userGrid.getColumnModel().setEditable(5, false);
    userGrid.getColumnModel().setEditable(6, false);
    if(FromBillType != "W0206"&&FromBillType != "W0211"){
        userGrid.getColumnModel().setEditable(7, false);
    }
    userGrid.getColumnModel().setEditable(8, false);
    
    setAllKindValue();
});
//���渳��ʼֵ
function setFormValue() {
    Ext.Ajax.request({
        url: 'frmInStockBill.aspx?method=getPurchaseOrderInfo',
        params: {
            OrderId: OrderId
        },
        success: function(resp, opts) {
            var data = Ext.util.JSON.decode(resp.responseText);
            Ext.getCmp("OrgId").setValue(data.OrgId);
            //Ext.getCmp("OrgName").setValue(data.OrgName);
            Ext.getCmp("WhId").setValue(data.WhId);
            dsWarehousePosList.load({
                params: {
                    WhId: data.WhId
                }
            });
            //Ext.getCmp("OperId").setValue(data.OperId);
            Ext.getCmp("SupplierId").setValue(data.SupplierId);
            Ext.getCmp("FromBillType").setValue(FromBillType);
            Ext.getCmp("SupplierName").setValue(data.SupplierName);
            Ext.getCmp("CarBoatNo").setValue(data.CarBoatNo);
            
            updateDataGrid();
        },
        failure: function(resp, opts) {
            Ext.Msg.alert("��ʾ", "��ȡ������Ϣʧ�ܣ�");
        }
    });
}
//���渳��ʼֵ-���۳��� 
function setFormValueBySaleOut() {
    //alert(parent.orgId+":"+parent.whId+":"+parent.operId);
    //alert(parent.orgName);
    Ext.getCmp("OrgId").setValue(parent.orgId);
    //Ext.getCmp("OrgName").setValue(parent.orgName);
    Ext.getCmp("WhId").setValue(parent.whId);
    dsWarehousePosList.load({
        params: {
            WhId: parent.whId
        }
    });
    //Ext.getCmp("OperId").setValue(parent.operId);
    Ext.getCmp("FromBillType").setValue(FromBillType);
    Ext.getCmp("CustomerId").setValue(parent.customerId);
    Ext.getCmp("CustomerName").setValue(parent.customerName);
    updateDataGrid();
}
//���渳��ʼֵ-�������� 
function setFormValueByAllotOut() {
    Ext.Ajax.request({
        url: 'frmInStockBill.aspx?method=getAllotOutOrderInfo',
        params: {
            OrderId: OrderId
        },
        success: function(resp, opts) {
            var data = Ext.util.JSON.decode(resp.responseText);
            Ext.getCmp("OrgId").setValue(data.OrgId);
            //Ext.getCmp("OrgName").setValue(data.OrgName);
            Ext.getCmp("WhId").setValue(data.OutWhId);
            dsWarehousePosList.load({
                params: {
                    WhId: data.OutWhId
                },
                callback: function(r, options, success) {
                    updateDataGrid();
                }
            });
            //Ext.getCmp("OperId").setValue(data.OutOperId);
            Ext.getCmp("FromBillType").setValue(FromBillType);
        },
        failure: function(resp, opts) {
            Ext.Msg.alert("��ʾ", "��ȡ����������Ϣʧ�ܣ�");
        }
    });
}
//���渳��ʼֵ-������� 
function setFormValueByAllotIn() {
    Ext.Ajax.request({
        url: 'frmInStockBill.aspx?method=getAllotOutOrderInfo',
        params: {
            OrderId: OrderId
        },
        success: function(resp, opts) {
            var data = Ext.util.JSON.decode(resp.responseText);
            Ext.getCmp("OrgId").setValue(data.OrgId);
            //Ext.getCmp("OrgName").setValue(data.OrgName);
            Ext.getCmp("WhId").setValue(data.InWhId);
            dsWarehousePosList.load({
                params: {
                    WhId: data.InWhId
                }
            });
            //Ext.getCmp("OperId").setValue(data.OutOperId);
            Ext.getCmp("FromBillType").setValue(FromBillType);
            updateDataGrid();
        },
        failure: function(resp, opts) {
            Ext.Msg.alert("��ʾ", "��ȡ���������Ϣʧ�ܣ�");
        }
    });
}
//���渳��ʼֵ-�˻���
function setFormValueByReturnOrder() {
    Ext.Ajax.request({
        url: 'frmInStockBill.aspx?method=getReturnOrderInfo',
        params: {
            OrderId: OrderId
        },
        success: function(resp, opts) {
            var data = Ext.util.JSON.decode(resp.responseText);
            Ext.getCmp("OrgId").setValue(data.OrgId);
            //Ext.getCmp("OrgName").setValue(data.OrgName);
            Ext.getCmp("WhId").setValue(data.WhId);
            dsWarehousePosList.load({
                params: {
                    WhId: data.WhId
                }
            });
            //Ext.getCmp("OperId").setValue(data.OperId);
            Ext.getCmp("FromBillType").setValue(FromBillType);
            
            updateDataGrid();
        },
        failure: function(resp, opts) {
            Ext.Msg.alert("��ʾ", "��ȡ�˻�����Ϣʧ�ܣ�");
        }
    });
}

//���渳��ʼֵ-������
function setFormValueByProduceOrder() {
    //alert(parent.orgId+":"+parent.whId+":"+parent.operId);
    //alert(parent.customerId);
    Ext.getCmp("OrgId").setValue(parent.orgId);
    //Ext.getCmp("OrgName").setValue(parent.orgName);
    Ext.getCmp("WhId").setValue(parent.whId);
    dsWarehousePosList.load({
        params: {
            WhId: parent.whId
        }
    });
    //Ext.getCmp("OperId").setValue(parent.operId);
    Ext.getCmp("FromBillType").setValue(FromBillType);
    //Ext.getCmp("CustomerId").setValue(parent.customerId);
    updateDataGrid();
}


function updateDataGrid(){
    dsInStockProductDetail.load({
        params: { start: 0,
            limit: 100,
            OrderId: OrderId,
            WhId:Ext.getCmp("WhId").getValue(),
            ProductId:QcProductId
        },
        callback: function(r, options, success) {
            if (success == true) {
                //Ext.getCmp("OrderId").setValue(OrderId);
                initTransLoadPrice();
                inserNewBlankRow();
            }
        }
    });
}
function initTransLoadPrice(){
    dsInStockProductDetail.each(function(rec){
        if(!isNumber(rec.get("LoadPrice"))) rec.set("LoadPrice",0); 
        if(!isNumber(rec.get("TransPrice"))) rec.set("TransPrice",0); 
    });    
    dsInStockProductDetail.commitChanges();
    //caculate
    caculateFee(0);
    caculateFee(1); 
}
function isNumber(oNum)
{
  if(!oNum) return false;
  var strP=/^\d+(\.\d+)?$/;
  if(!strP.test(oNum)) return false;
  try{
    if(parseFloat(oNum)!=oNum) return false;
  }
  catch(ex)
  {
     return false;
  }
  return true;
}

function setAllKindValue()
{
    Ext.getCmp("BtnSave").setDisabled(false);
    Ext.Ajax.request({
        url: 'frmInStockBill.aspx?method=getProductListByOrder&type='+FromBillType+'&id='+OrderId,
        success: function(resp, opts) {
//            dsProductList = new Ext.data.SimpleStore(eval(resp.responseText));
            dsProductList.removeAll();
            var productStore =eval(resp.responseText);
            productStore.each(function(productStore){
                dsProductList.add(productStore);
            });
            Ext.getCmp("FromBillId").setValue(OrderId);
            if (OrderId > 0) {
                switch (FromBillType) {
                    case "W0201":
                        setFormValue();
                        
                        break;
                    case "W0211":
                        setFormValue();
                        break;
                    case "W0202":
                        document.getElementById("stockMode").innerHTML = "��";
                        setFormValueBySaleOut();
                        Ext.getCmp("WhId").setDisabled(false);
                        Ext.getCmp("OrgId").setDisabled(true);
                        //Ext.getCmp("SupplierId").container.up('div.x-form-item').hide(); 
                        Ext.getCmp("FromBillType").setValue('W0202');
                        Ext.getCmp("FromBillType").setDisabled(true);
                        break;
                    
                    case "W0213":
                        document.getElementById("stockMode").innerHTML = "��";
			            setFormValueByProduceOrder();
                        Ext.getCmp("WhId").setDisabled(true);
                        Ext.getCmp("OrgId").setDisabled(true); 
                        Ext.getCmp("FromBillType").setValue(FromBillType);
                        Ext.getCmp("FromBillType").setDisabled(true);
                        //Ext.getCmp("SupplierId").setVisible(false); 
                        Ext.getCmp("SupplierName").container.up('.x-form-item').setDisplayed(false); 
			break;
                    case "W0210":
                    case "W0212":
                        document.getElementById("stockMode").innerHTML = "��";
                        setFormValueByProduceOrder();
                        Ext.getCmp("WhId").setDisabled(true);
                        Ext.getCmp("OrgId").setDisabled(true); 
                        Ext.getCmp("FromBillType").setValue(FromBillType);
                        Ext.getCmp("FromBillType").setDisabled(true);
                        //Ext.getCmp("SupplierId").setVisible(false); 
                        Ext.getCmp("SupplierName").container.up('.x-form-item').setDisplayed(false); 
                        break;
                    case "W0205":
                        //alert(document.getElementById("stockMode").innerHTML);
                        document.getElementById("stockMode").innerHTML = "��";
                        setFormValueByAllotOut();
                        Ext.getCmp("FromBillType").setDisabled(true);
                        Ext.getCmp("WhId").setDisabled(true);
                        Ext.getCmp("OrgId").setDisabled(true);
                        //Ext.getCmp("SupplierId").up('.x-form-item').setDisplayed(false);   
                        Ext.getCmp("SupplierName").container.up('.x-form-item').setDisplayed(false);                                                                                                                                      

                        break;
                    case "W0206":
                        document.getElementById("stockMode").innerHTML = "��";
                        setFormValueByAllotIn();
                        Ext.getCmp("FromBillType").setDisabled(true);
                        Ext.getCmp("WhId").setDisabled(true);
                        Ext.getCmp("OrgId").setDisabled(true);
                        //Ext.getCmp("SupplierId").setVisible(false); 
                        Ext.getCmp("SupplierName").container.up('.x-form-item').setDisplayed(false); 
                        break;
                    case "W0204":
                        document.getElementById("stockMode").innerHTML = "��";
                        setFormValueByReturnOrder();
                        Ext.getCmp("WhId").setDisabled(true);
                        Ext.getCmp("OrgId").setDisabled(true);
                        //Ext.getCmp("SupplierId").setVisible(false); 
                        Ext.getCmp("SupplierName").container.up('.x-form-item').setDisplayed(false); 
                        break;
                    case "W0209"://�ɹ��˻�
                    case "W0210"://�����˻�
                        document.getElementById("stockMode").innerHTML = "��";
                        setFormValueByReturnOrder();
                        Ext.getCmp("WhId").setDisabled(false);
                        Ext.getCmp("OrgId").setDisabled(true);
                        //Ext.getCmp("SupplierId").container.up('div.x-form-item').hide(); 
                        Ext.getCmp("SupplierName").container.up('.x-form-item').setDisplayed(false); 
                        break;
                }                
            }
        }
   });          
}

function inserNewBlankRow() {
    var rowCount = userGrid.getStore().getCount();
    //alert(rowCount);
    var insertPos = parseInt(rowCount);
    var addRow = new RowPattern({
        WhpId: '',
        ProductCode: '',
        ProductId: '',
        ProductUnit: '',
        ProductSpec: '',
        ProductPrice: '',
        BookQty: '',
        RealQty: '',
        UnitId:''
    });
    userGrid.stopEditing();
    //����һ����
    if (insertPos > 0) {
        var rowIndex = dsInStockProductDetail.insert(insertPos, addRow);
        userGrid.startEditing(insertPos, 0);
    }
    else {
        var rowIndex = dsInStockProductDetail.insert(0, addRow);
        userGrid.startEditing(0, 0);
    }
}

var RowPattern = Ext.data.Record.create([
   { name: 'OrderDetailId', type: 'string' },
   { name: 'WhpId', type: 'string' },
   { name: 'ProductCode', type: 'string' },
   { name: 'ProductId', type: 'string' },
   { name: 'ProductSpec', type: 'string' },
   { name: 'ProductUnit', type: 'string' },
   { name: 'ProductPrice', type: 'string' },
   { name: 'BookQty', type: 'string' },
   { name: 'RealQty', type: 'string' },
   { name: 'UnitId', type: 'string' },
   { name: 'RealQty', type: 'string' },
   { name: 'LoadPrice', type: 'string' },
   { name: 'TransPrice', type: 'string' }
 ]);

</script>

</html>
