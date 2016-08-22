<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmPmsProductConvertList.aspx.cs" Inherits="PMS_frmPmsProductConvertList" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html>
<head>
<title>��Ʒת���б�</title>
<meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<link rel="stylesheet" type="text/css" href="../ext3/resources/css/ext-all.css" />
<script type="text/javascript" src="../ext3/adapter/ext/ext-base.js"></script>
<script type="text/javascript" src="../ext3/ext-all.js"></script>
<script type="text/javascript" src="../js/operateResp.js"></script>
<script type="text/javascript" src="../ext3/src/locale/ext-lang-zh_CN.js"></script>
</head>
<body>
<div id='toolbar'></div>
<div id='divForm'></div>
<div id='dataGrid'></div>
<%=getComboBoxStore() %>
</body>
<style type="text/css">
.x-item-disabled-ie {
    color:white;cursor:default;opacity:.9;-moz-opacity:.9; -ms-filter:"progid:DXImageTransform.Microsoft.Alpha(Opacity=90)";
}
</style>
<script type="text/javascript">
Ext.BLANK_IMAGE_URL = "../ext3/resources/images/default/s.gif";
Ext.onReady(function() {
    var saveType;
    /*------ʵ��toolbar�ĺ��� start---------------*/
    var Toolbar = new Ext.Toolbar({
        renderTo: "toolbar",
        items: [{
            text: "����",
            icon: "../Theme/1/images/extjs/customer/add16.gif",
            handler: function() {
                saveType = 'addOrder';
                openAddOrderWin();
            }
        }, '-', {
            text: "�༭",
            icon: "../Theme/1/images/extjs/customer/edit16.gif",
            handler: function() {
                saveType = 'saveOrder';
                modifyOrderWin();
            }
        }, '-', {
            text: "ɾ��",
            icon: "../Theme/1/images/extjs/customer/delete16.gif",
            handler: function() {
                saveType = 'saveOrder';
                deleteOrder();
            }
        }, '-', {
            text: "ȷ��",
            icon: "../Theme/1/images/extjs/customer/edit16.gif",
            handler: function() {
                confirmOrder();
            }
}, '-', {
                text: "��ӡ",
                icon: "../Theme/1/images/extjs/customer/edit16.gif",
                handler: function() {
                    printOrderById();
                }
            }]
        });

function getUrl(imageUrl)
            {
                var index = window.location.href.toLowerCase().indexOf('/pms/');
                var tempUrl = window.location.href.substring(0,index);
                return tempUrl+"/"+imageUrl;
            }
function printOrderById()
{
var sm = pmsstockorderGrid.getSelectionModel();
                //��ѡ
                var selectData = sm.getSelections();                
                var array = new Array(selectData.length);
                var orderIds = "";
                for(var i=0;i<selectData.length;i++)
                {
                    if(orderIds.length>0)
                        orderIds+=",";
                    orderIds += selectData[i].get('OrderId');
                }
                //alert(orderIds);
                //ҳ���ύ
                Ext.Ajax.request({
                    url: 'frmPmsProductConvertList.aspx?method=getprintdata',
                    method: 'POST',
                    params: {
                        OrderIds: orderIds
                    },
                   success: function(resp,opts){ 
                       var printData =  resp.responseText;
                       var printControl =  parent.parent.parent.document.getElementById("topFrame").contentWindow.getPrintControl();
                       printControl.Url =getUrl('xml');
                       printControl.MapUrl = printControl.Url+'/'+printStyleXml;//'/salePrint1.xml';
                       printControl.PrintXml = printData;
                       printControl.ColumnName="OrderId";
                       printControl.OnlyData=printOnlyData;
                       printControl.PageWidth=printPageWidth;
                       printControl.PageHeight =printPageHeight ;
                       printControl.Print();
                       
                   },
		           failure: function(resp,opts){  /* Ext.Msg.alert("��ʾ","����ʧ��"); */    }
                });
                }
        /*------����toolbar�ĺ��� end---------------*/
        var dsWarehousePosList;
        if (dsWarehousePosList == null) { //��ֹ�ظ�����
            //alert(Ext.getCmp("WhId").getValue());
            dsWarehousePosList = new Ext.data.Store
        ({
            url: 'frmPmsProductConvertList.aspx?method=getWarehousePosList',
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

        /*------��ʼToolBar�¼����� start---------------*//*-----����Orderʵ���ര�庯��----*/
        function openAddOrderWin() {
            uploadOrderWindow.show();
        }
        /*-----�༭Orderʵ���ര�庯��----*/
        function modifyOrderWin() {
            var sm = pmsstockorderGrid.getSelectionModel();
            //��ȡѡ���������Ϣ
            var selectData = sm.getSelected();
            if (selectData == null) {
                Ext.Msg.alert("��ʾ", "��ѡ����Ҫ�༭����Ϣ��");
                return;
            }
            if (selectData.data.BizStatus == "2") {
                Ext.Msg.alert("��ʾ", "��ת����¼�Ѿ����⣬���ܽ��б༭��");
                return;
            }
            uploadOrderWindow.show();
            setFormValue(selectData);
        }
        /*-----ɾ��Orderʵ�庯��----*/
        /*ɾ����Ϣ*/
        function deleteOrder() {
            var sm = pmsstockorderGrid.getSelectionModel();
            //��ȡѡ���������Ϣ
            var selectData = sm.getSelected();
            //���û��ѡ�񣬾���ʾ��Ҫѡ��������Ϣ
            if (selectData == null) {
                Ext.Msg.alert("��ʾ", "��ѡ����Ҫɾ������Ϣ��");
                return;
            }
            if (selectData.data.BizStatus == "2") {
                Ext.Msg.alert("��ʾ", "��ת����¼�Ѿ����⣬���ܽ���ɾ����");
                return;
            }
            //ɾ��ǰ�ٴ������Ƿ����Ҫɾ��
            Ext.Msg.confirm("��ʾ��Ϣ", "�Ƿ����Ҫɾ��ѡ�����Ϣ��", function callBack(id) {
                //�ж��Ƿ�ɾ������
                if (id == "yes") {
                    //ҳ���ύ
                    Ext.Ajax.request({
                        url: 'frmPmsProductConvertList.aspx?method=deleteOrder',
                        method: 'POST',
                        params: {
                            OrderId: selectData.data.OrderId
                        },
                        success: function(resp, opts) {
                            dspmsstockorder.reload({
                                params: {start: 0,limit: 10}
                            });
                            Ext.Msg.alert("��ʾ", "����ɾ���ɹ�");
                        },
                        failure: function(resp, opts) {
                            Ext.Msg.alert("��ʾ", "����ɾ��ʧ��");
                        }
                    });
                }
            });
        }
        /*ȷ����Ϣ*/
        function confirmOrder() {
            Ext.MessageBox.wait("�������ڱ��棬���Ժ򡭡�");
            var sm = pmsstockorderGrid.getSelectionModel();
            //��ȡѡ���������Ϣ
            var selectData = sm.getSelected();
            //���û��ѡ�񣬾���ʾ��Ҫѡ��������Ϣ
            if (selectData == null) {
                Ext.MessageBox.hide();
                Ext.Msg.alert("��ʾ", "��ѡ����Ҫȷ���ύ����Ϣ��");
                return;
            }
            if (selectData.data.BizStatus == "2") {
                Ext.MessageBox.hide();
                Ext.Msg.alert("��ʾ", "��ת����¼�Ѿ����⣬���ܽ���ȷ���ύ��");
                return;
            }
            //ɾ��ǰ�ٴ������Ƿ����Ҫɾ��
            Ext.Msg.confirm("��ʾ��Ϣ", "�Ƿ����Ҫȷ���ύѡ�����Ϣ��", function callBack(id) {
                //�ж��Ƿ�ɾ������
                if (id == "yes") {
                    //ҳ���ύ
                    Ext.Ajax.request({
                        url: 'frmPmsProductConvertList.aspx?method=confirmOrder',
                        method: 'POST',
                        params: {
                            OrderId: selectData.data.OrderId
                        },
                        success: function(resp, opts) {
                            Ext.MessageBox.hide();
                            if (checkExtMessage(resp)) {
                                dspmsstockorder.reload({
                                    params: {
                                        start: 0,
                                        limit: 10
                                    }
                                });
                            }
                        },
                        failure: function(resp, opts) {
                            Ext.MessageBox.hide();
                            Ext.Msg.alert("��ʾ", "����ȷ���ύʧ��");
                        }
                    });
                }
            });
        }

        /*------ʵ��FormPanle�ĺ��� start---------------*/
        var pmsstockorderform = new Ext.form.FormPanel({
            url: '',
            frame: true,
            title: '',
            items: [
		{
		    xtype: 'hidden',
		    fieldLabel: '������',
		    name: 'OrderId',
		    id: 'OrderId',
		    hidden: true,
		    hideLabel: false
		}
, {
    layout: 'column',
    items: [
            {
                layout: 'form',
                columnWidth: .48,
                labelWidth: 55,
                items: [
                {
                    xtype: 'combo',
                    fieldLabel: '�ֿ�',
                    columnWidth: 1,
                    anchor: '98%',
                    name: 'AuxWhId',
                    id: 'AuxWhId',
                    store: dsWarehouseList,
                    displayField: 'WhName',
                    valueField: 'WhId',
                    mode: 'local',
                    triggerAction: 'all',
                    editable: false,
                    listeners: {
                        select: function(combo, record, index) {
                            var curWhId = Ext.getCmp("AuxWhId").getValue();
                            Ext.getCmp('WhpId').setValue('');
                            Ext.getCmp('WhpId').setRawValue('');
                            dsWarehousePosList.load({
                                params: {
                                    WhId: curWhId
                                },
                                callback:function(){
                                    if(dsWarehousePosList.getCount()==1)
                                        Ext.getCmp('WhpId').setValue(dsWarehousePosList.getAt(0).get("WhpId")); 
                                }
                            });
                        }
                    }
                }
                ]
            }, {
                layout: 'form',
                columnWidth: .48,
                labelWidth: 55,
                items: [
                {
                    xtype: 'combo',
                    fieldLabel: '��λ',
                    columnWidth: 1,
                    anchor: '98%',
                    name: 'WhpId',
                    id: 'WhpId',
                    store: dsWarehousePosList,
                    displayField: 'WhpName',
                    valueField: 'WhpId',
                    mode: 'local',
                    triggerAction: 'all',
                    editable: false
                }
            ]
}]
}
, {
    xtype: 'fieldset',
    layout: 'column',
    autoHeight: true,
    title: "ת����Ʒ��Ϣ",
    items: [
    {
        layout: 'column',
        items: [
        {
            layout: 'form',
            columnWidth: .35,
            labelWidth: 60,
            items: [
            {
                xtype: 'textfield',
                fieldLabel: '��Ʒ����',
                columnWidth: 1,
                anchor: '98%',
                name: 'AuxProductNo',
                id: 'AuxProductNo',
                enableKeyEvents: true,
                initEvents: function() {
                    var keyPress = function(e) {
                        if (e.getKey() == e.ENTER) {
                            var textValue = this.getValue();
                            var index = dsProductList.findBy(
                                function(record, id) {
                                    return record.get('ProductNo') == textValue;
                                }
                            );
                            var record = dsProductList.getAt(index);
                            Ext.getCmp('AuxProductId').setValue(record.data.ProductId)
                            Ext.getCmp('Unit').setValue(record.data.Unit)
                            //��ȡ�ɱ���
                            Ext.Ajax.request({
                                url: 'frmPmsProductConvertList.aspx?method=getWhCostPrice',
                                params: {
                                    ProductId: record.data.ProductId,
                                    WhId: Ext.getCmp("AuxWhId").getValue()
                                },
                                success: function(resp, opts) {
                                    var dataPrice = Ext.util.JSON.decode(resp.responseText);
                                    Ext.getCmp("PProductPrice").setValue(dataPrice.price);
                                },
                                failure: function(resp, opts) {
                                    Ext.Msg.alert("��ʾ", "��ȡ��Ʒ��Ϣʧ��");
                                }
                            });
                        }
                    };
                    this.el.on("keypress", keyPress, this);
                }
            }
	        ]
        }, {
            layout: 'form',
            columnWidth: .65,
            labelWidth: 60,
            items: [
            {
                xtype: 'combo',
                fieldLabel: '��Ʒ����',
                columnWidth: 1,
                anchor: '98%',
                name: 'AuxProductId',
                id: 'AuxProductId',
                store: dsProductList,
                displayField: 'ProductName',
                valueField: 'ProductId',
                triggerAction: 'all',
                typeAhead: true,
                mode: 'local',
                emptyText: '',
                selectOnFocus: false,
                editable: false,
                disabled: true,
    	disabledClass: Ext.isIE ? 'x-item-disabled-ie' : 'x-item-disabled'

            }
	        ]
        }]
        },
			{
			    layout: 'column',
			    items: [
			    {
			        layout: 'form',
			        columnWidth: .263,
			        labelWidth: 60,
			        items: [
                    {
                        xtype: 'numberfield',
                        fieldLabel: '��Ʒ����',
                        columnWidth: 1,
                        anchor: '98%',
                        name: 'Qty',
                        id: 'Qty',
	                    allowBlank: false,
	                    align: 'right',
	                    decimalPrecision:6,
                        value: 0
                    }
			        ]
			    },
			    {
			        layout: 'form',
			        columnWidth: .22,
			        labelWidth: 60,
			        items: [
                    {
                        xtype: 'combo',
                        fieldLabel: '��Ʒ��λ',
                        labelWidth: 35,
                        anchor: '98%',
                        name: 'Unit',
                        id: 'Unit',
                        store: dsUnitList,
                        displayField: 'UnitName',
                        valueField: 'UnitId',
                        triggerAction: 'all',
                        typeAhead: true,
                        mode: 'local',
                        emptyText: '',
                        selectOnFocus: false,
                        editable: true
                    }
			        ]
                },
			    {
			        layout: 'form',
			        columnWidth: .26,
			        labelWidth: 80,
			        items: [
                    {
                        xtype: 'textfield',
                        fieldLabel: 'ת���ɱ��۸�',
                        labelWidth: 35,
                        anchor: '98%',
                        name: 'PProductPrice',
                        id: 'PProductPrice',
                        style:'text-align:right'
                    }
			        ]
                }]
}]
}
, {
    xtype: 'fieldset',
    layout: 'column',
    autoHeight: true,
    title: "ת����Ʒ��Ϣ",
    items: [
			{
			    layout: 'column',
			    items: [
            {
                layout: 'form',
                columnWidth: .35,
                labelWidth: 60,
                items: [
                {
                    xtype: 'textfield',
                    fieldLabel: '��Ʒ����',
                    columnWidth: 1,
                    anchor: '98%',
                    name: 'ProductNo',
                    id: 'ProductNo',
                    enableKeyEvents: true,
                    initEvents: function() {
                        var keyPress = function(e) {
                            if (e.getKey() == e.ENTER) {
                                var textValue = this.getValue();
                                var index = dsProductList.findBy(
                                        function(record, id) {
                                            return record.get('ProductNo') == textValue;
                                        }
                                    );
                                var record = dsProductList.getAt(index);
                                Ext.getCmp('ProductId').setValue(record.data.ProductId)
                                Ext.getCmp('PUnit').setValue(record.data.Unit)
                                //��ȡ�ɱ���
                                Ext.Ajax.request({
                                    url: 'frmPmsProductConvertList.aspx?method=getWhCostPrice',
                                    params: {
                                        ProductId: record.data.ProductId,
                                        WhId: Ext.getCmp("AuxWhId").getValue()
                                    },
                                    success: function(resp, opts) {
                                        var dataPrice = Ext.util.JSON.decode(resp.responseText);
                                        Ext.getCmp("ProductPrice").setValue(dataPrice.price);
                                    },
                                    failure: function(resp, opts) {
                                        Ext.Msg.alert("��ʾ", "��ȡ��Ʒ��Ϣʧ��");
                                    }
                                });
                            }
                        };
                        this.el.on("keypress", keyPress, this);
                    }
                }
			    ]
            }, {
                layout: 'form',
                columnWidth: .65,
                labelWidth: 60,
                items: [
                {
                    xtype: 'combo',
                    fieldLabel: '��Ʒ����',
                    columnWidth: 1,
                    anchor: '98%',
                    name: 'ProductId',
                    id: 'ProductId',
                    store: dsProductList,
                    displayField: 'ProductName',
                    valueField: 'ProductId',
                    triggerAction: 'all',
                    typeAhead: true,
                    mode: 'local',
                    emptyText: '',
                    selectOnFocus: false,
                    disabled: true,
		    disabledClass: Ext.isIE ? 'x-item-disabled-ie' : 'x-item-disabled'

                }
			    ]
}]
			},
			{
			    layout: 'column',
			    items: [
			    {
			        layout: 'form',
			        columnWidth: .263,
			        labelWidth: 60,
			        items: [
                    {
                        xtype: 'numberfield',
                        fieldLabel: '��Ʒ����',
                        columnWidth: 1,
                        anchor: '98%',
                        name: 'PQty',
                        id: 'PQty',
	                    allowBlank: false,
	                    align: 'right',
	                    decimalPrecision:6,
                        value: 0
                    }
			        ]
			    },
			    {
			        layout: 'form',
			        columnWidth: .22,
			        labelWidth: 60,
			        items: [
                    {
                        xtype: 'combo',
                        fieldLabel: '��Ʒ��λ',
                        labelWidth: 35,
                        anchor: '98%',
                        name: 'PUnit',
                        id: 'PUnit',
                        store: dsUnitList,
                        displayField: 'UnitName',
                        valueField: 'UnitId',
                        triggerAction: 'all',
                        typeAhead: true,
                        mode: 'local',
                        emptyText: '',
                        selectOnFocus: false,
                        editable: true
                    }
			        ]
			    },
			    {
			        layout: 'form',
			        columnWidth: .26,
			        labelWidth: 80,
			        items: [
                    {
                        xtype: 'textfield',
                        fieldLabel: 'ת��ɱ��۸�',
                        labelWidth: 35,
                        anchor: '98%',
                        name: 'ProductPrice',
                        id: 'ProductPrice',
                        style:'text-align:right'
                    }
			        ]
                }
			]
            }]
            }
            , {
                xtype: 'textarea',
                fieldLabel: '��ע',
                columnWidth: .5,
                height: 40,
			    labelWidth: 60,
                anchor: '98%',
                name: 'Remark',
                id: 'Remark'
            }
            ]
        });
        /*------FormPanle�ĺ������� End---------------*/

        /*------��ʼ�������ݵĴ��� Start---------------*/
        if (typeof (uploadOrderWindow) == "undefined") {//�������2��windows����
            uploadOrderWindow = new Ext.Window({
                id: 'Orderformwindow',
                title: ''
		, iconCls: 'upload-win'
		, width: 600
		, height: 350
		, layout: 'fit'
		, plain: true
		, modal: true
		, constrain: true
		, resizable: false
		, closeAction: 'hide'
		, autoDestroy: true
		, items: pmsstockorderform
		, buttons: [{
		    text: "����"
			, handler: function() {
			    saveUserData();
			}
			, scope: this
		},
		{
		    text: "ȡ��"
			, handler: function() {
			    uploadOrderWindow.hide();
			}
			, scope: this
}]
            });
        }
        uploadOrderWindow.addListener("hide", function() {
            pmsstockorderform.getForm().reset();
        });

        /*------��ʼ��ȡ�������ݵĺ��� start---------------*/
        function saveUserData() {
            Ext.MessageBox.wait("�������ڱ��棬���Ժ򡭡�");
            if (Ext.getCmp('AuxWhId').getValue()==""||Ext.getCmp('AuxWhId').getValue()<=0){
                Ext.MessageBox.hide();
                Ext.Msg.alert("��ʾ", "��ѡ��ֿ⣡");
                return;
            }  
            if (Ext.getCmp('WhpId').getValue()==""||Ext.getCmp('WhpId').getValue()<=0){
                Ext.MessageBox.hide();
                Ext.Msg.alert("��ʾ", "��ѡ��ֿ��µĲ�λ��");
                return;
            }    
            if (Ext.getCmp('PQty').getValue() <= 0 || Ext.getCmp('Qty').getValue() <= 0) {
                Ext.MessageBox.hide();
                Ext.Msg.alert("��ʾ", "������Ҫ�����㣡");
                return;
            }            
            if (Ext.getCmp('PUnit').getValue() != Ext.getCmp('Unit').getValue()) {
                Ext.MessageBox.hide();
                Ext.Msg.alert("��ʾ", "ת����ת����Ʒ�ĵ�λ�뱣��һ�£�");
                return;
            }
            if (Ext.getCmp('PQty').getValue() != Ext.getCmp('Qty').getValue() ) {
                Ext.MessageBox.hide();
                if (!window.confirm("ת��ת����Ʒ������һ�£��Ƿ�������棿")) { 
                    return;
                }
            }
            Ext.Ajax.request({
                url: 'frmPmsProductConvertList.aspx?method=' + saveType,
                method: 'POST',
                params: {
                    OrderId: Ext.getCmp('OrderId').getValue(),
                    AuxWhId: Ext.getCmp('AuxWhId').getValue(),
                    WhpId: Ext.getCmp('WhpId').getValue(),
                    AuxProductId: Ext.getCmp('AuxProductId').getValue(),
                    PProductPrice: Ext.getCmp('ProductPrice').getValue(),//int
                    Qty: Ext.getCmp('Qty').getValue(),
                    UnitId: Ext.getCmp('Unit').getValue(),
                    Unit: Ext.getCmp('Unit').getValue(),//
                    ProductId: Ext.getCmp('ProductId').getValue(),
                    ProductPrice: Ext.getCmp('PProductPrice').getValue(),//out
                    PQty: Ext.getCmp('PQty').getValue(),
                    PUnit: Ext.getCmp('PUnit').getValue(),//
                    Remark: Ext.getCmp('Remark').getValue()
                },
                success: function(resp, opts) {
                    Ext.MessageBox.hide();
                    if (checkExtMessage(resp)) {
                        dspmsstockorder.reload({
                            params: {
                                start: 0,
                                limit: 10
                            }
                        });
                        uploadOrderWindow.hide();
                    }
                },
                failure: function(resp, opts) {
                    Ext.MessageBox.hide();
                    Ext.Msg.alert("��ʾ", "����ʧ��");
                }
            });
        }
        /*------������ȡ�������ݵĺ��� End---------------*/

        /*------��ʼ�������ݵĺ��� Start---------------*/
        function setFormValue(selectData) {
            Ext.Ajax.request({
                url: 'frmPmsProductConvertList.aspx?method=getorder',
                params: {
                    OrderId: selectData.data.OrderId
                },
                success: function(resp, opts) {
                    var data = Ext.util.JSON.decode(resp.responseText);
                    Ext.getCmp("OrderId").setValue(data.OrderId);
                    Ext.getCmp("AuxWhId").setValue(data.AuxWhId);
                    Ext.getCmp("WhpId").setValue(data.WhpId);
                    Ext.getCmp("AuxProductId").setValue(data.AuxProductId);
                    Ext.getCmp("PProductPrice").setValue(data.ProductPrice);
                    Ext.getCmp("Qty").setValue(data.Qty);
                    Ext.getCmp("Unit").setValue(data.UnitId);
                    Ext.getCmp("ProductPrice").setValue(data.PProductPrice);
                    Ext.getCmp("ProductId").setValue(data.ProductId);
                    Ext.getCmp("PQty").setValue(data.PQty);
                    Ext.getCmp("PUnit").setValue(data.UnitId);
                    Ext.getCmp("Remark").setValue(data.Remark);
                    var index = dsProductList.findBy(
                        function(record, id) {
                            return record.get('ProductId') == data.AuxProductId;
                        }
                    );
                    var record = dsProductList.getAt(index);
                    Ext.getCmp('AuxProductNo').setValue(record.data.ProductNo)
                    index = dsProductList.findBy(
                        function(record, id) {
                            return record.get('ProductId') == data.ProductId;
                        }
                    );
                    record = dsProductList.getAt(index);
                    Ext.getCmp('ProductNo').setValue(record.data.ProductNo);
                    //dsWarehousePosList.load({
                    //    params: {
                    //        WhId: AuxWhId
                    //    }
                    //});
                },
                failure: function(resp, opts) {
                    Ext.Msg.alert("��ʾ", "��ȡ�û���Ϣʧ��");
                }
            });
        }
        /*------�������ý������ݵĺ��� End---------------*/
        /*------��ʼ��ѯform end---------------*/
        //�����Ʒ�������첽���÷���
        var dsProducts;
        if (dsProducts == null) {
            dsProducts = new Ext.data.Store({
                url: 'frmPmsProductConvertList.aspx?method=getProductByNameNo',
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
                        { name: 'UnitId', mapping: 'UnitId' }
                    ])
            });
        }
        // �����������첽������ʾģ��
        var resultTpl = new Ext.XTemplate(  
            '<tpl for="."><div id="searchdivid" class="search-item">',  
                '<h3><span>���:{ProductNo}&nbsp;  ����:{ProductName}</span></h3>',
            '</div></tpl>'  
        );
        //�ֿ�
        var ckCombo = new Ext.form.ComboBox({
            xtype: 'combo',
            fieldLabel: '�ֿ�',
            anchor: '95%',
            store: dsWarehouseList,
            displayField: 'WhName',
            valueField: 'WhId',
            mode: 'local',
            triggerAction: 'all',
            editable: false
        });

        //��Ʒ
        var productId;
        var productName = new Ext.form.ComboBox({
            xtype: 'textfield',
            fieldLabel: 'ת����Ʒ',
            anchor: '95%',
            store: dsProducts,
            displayField: 'ProductName',
            displayValue: 'ProductId',
            typeAhead: false,
            minChars: 1,
            //width:300,
            listWidth:320,
            loadingText: 'Searching...',
            tpl: resultTpl,  
            itemSelector: 'div.search-item',  
            pageSize: 10,
            hideTrigger: true,
            onSelect: function(record) {
                productName.setValue(record.data.ProductName);
                productId = record.data.ProductId;
                this.collapse();
            }
        });
        //��ʼ����
       var ksrq = new Ext.form.DateField({
   		    xtype:'datefield',
	        fieldLabel:'��ʼ����',
	        anchor:'90%',
	        name:'StartDate',
	        id:'StartDate',
	        format: 'Y��m��d��',  //���������ʽ
            value:new Date().clearTime() 
       });
       
       //��������
       var jsrq = new Ext.form.DateField({
   		    xtype:'datefield',
	        fieldLabel:'��������',
	        anchor:'90%',
	        name:'EndDate',
	        id:'EndDate',
	        format: 'Y��m��d��',  //���������ʽ
            value:new Date().clearTime()
       });

        var serchform = new Ext.FormPanel({
            el: 'divForm',
            id: 'serchform',
            labelAlign: 'left',
            buttonAlign: 'right',
            //bodyStyle: 'padding:5px',
            width:'100%',
            frame: true,
            items: [
            {
                layout: 'column',   //�����Ԫ��Ϊ����Ϊ�в��ַ�ʽ
                border: false,
                items: [{
                 columnWidth: .4,  //����ռ�õĿ�ȣ���ʶΪ20��
                    layout: 'form',
                    border: false,
                    labelWidth: 55,
                    items: [ksrq]
                },
                {
                    columnWidth: .4,
                    layout: 'form',
                    border: false,
                    labelWidth: 80,
                    items: [jsrq]
                }]
            },
            {
                layout: 'column',   //�����Ԫ��Ϊ����Ϊ�в��ַ�ʽ
                border: false,
                items: [{
                    columnWidth: .4,  //����ռ�õĿ�ȣ���ʶΪ20��
                    layout: 'form',
                    border: false,
                    labelWidth: 55,
                    items: [
                        ckCombo
                    ]
                }, {
                    columnWidth: .4,
                    layout: 'form',
                    border: false,
                    labelWidth: 80,
                    items: [
                        productName
                    ]
                }, {
                    layout: 'form',
                    columnWidth: .2,
                    border: false,
                    items: [{ cls: 'key',
                        xtype: 'button',
                        text: '��ѯ',
                        anchor: '50%',
                        handler: function() {

                            var WhId = ckCombo.getValue();
                            var ProductId = productId;
                            
                            if(productName.getValue()=="")
                                ProductId = "";

                            dspmsstockorder.baseParams.WhId = WhId;
                            dspmsstockorder.baseParams.ProductId = ProductId;
                            dspmsstockorder.baseParams.StartDate=Ext.util.Format.date(Ext.getCmp('StartDate').getValue(),'Y/m/d');
                            dspmsstockorder.baseParams.EndDate=Ext.util.Format.date(Ext.getCmp('EndDate').getValue(),'Y/m/d');
                            dspmsstockorder.load({
                                params: {
                                    start: 0,
                                    limit: 10
                                }
                            });
                        }
                    }]
                }]
            }]
        });
        serchform.render();
        /*------��ʼ��ѯform end---------------*/
        /*------��ʼ��ȡ���ݵĺ��� start---------------*/
        var dspmsstockorder = new Ext.data.Store
({
    url: 'frmPmsProductConvertList.aspx?method=getOrderList',
    reader: new Ext.data.JsonReader({
        totalProperty: 'totalProperty',
        root: 'root'
    }, [
	{ name: 'OrderId' },
	{ name: 'OrgId' },
	{ name: 'AuxWhId' },
	{ name: 'AuxProductId' },
	{ name: 'Qty' },
	{ name: 'ProductId' },
	{ name: 'PQty' },
	{ name: 'CreateDate' },
	{ name: 'OperId' },
	{ name: 'BizStatus' },
	{ name: 'OwnerId' },
	{ name: 'Remark'
}])
	,
    listeners:
	{
	    scope: this,
	    load: function() {
	    }
	}
});

                    /*------��ȡ���ݵĺ��� ���� End---------------*/

                    /*------��ʼDataGrid�ĺ��� start---------------*/

                    var sm = new Ext.grid.CheckboxSelectionModel({
                        singleSelect: true
                    });
                    var pmsstockorderGrid = new Ext.grid.GridPanel({
                        el: 'dataGrid',
                        width: document.body.offsetWidth,
                        height: '100%',
                        //autoWidth: true,
                        //autoHeight: true,
                        autoScroll: true,
                        layout: 'fit',
                        id: '',
                        store: dspmsstockorder,
                        loadMask: { msg: '���ڼ������ݣ����Ժ��' },
                        sm: sm,
                        cm: new Ext.grid.ColumnModel([
		sm,
		new Ext.grid.RowNumberer(), //�Զ��к�
		{
		header: '������',
		dataIndex: 'OrderId',
		id: 'OrderId',
		hidden: true,
		hideable: false
},
		{
		    header: '�ֿ�',
		    dataIndex: 'AuxWhId',
		    id: 'AuxWhId',
		    width:80,
		    renderer: function(val) {
		        dsWarehouseList.each(function(r) {
		            if (val == r.data['WhId']) {
		                val = r.data['WhName'];
		                return;
		            }
		        });
		        return val;
		    }
		},
		{
		    header: 'ת����Ʒ',
		    dataIndex: 'AuxProductId',
		    id: 'AuxProductId',
		    width:180,
		    renderer: function(val) {
		        dsProductList.each(function(r) {
		            if (val == r.data['ProductId']) {
		                val = r.data['ProductName'];
		                return;
		            }
		        });
		        return val;
		    }
		},
		{
		    header: '����',
		    dataIndex: 'Qty',
		    id: 'Qty',
		    width:80
		},
		{
		    header: 'ת����Ʒ',
		    dataIndex: 'ProductId',
		    id: 'ProductId',
		    width:180,
		    renderer: function(val) {
		        dsProductList.each(function(r) {
		            if (val == r.data['ProductId']) {
		                val = r.data['ProductName'];
		                return;
		            }
		        });
		        return val;
		    }
		},
		{
		    header: '����',
		    dataIndex: 'PQty',
		    id: 'PQty',
		    width:80
		}, {
		    header: 'ҵ��״̬',
		    dataIndex: 'BizStatus',
		    id: 'BizStatus',
		    renderer: function(val) {
		        if (val == 0) return '��ʼ';
		        if (val == 2) return '�ѳ���';
		    },
		    width:80
		},
		{
		    header: '����ʱ��',
		    dataIndex: 'CreateDate',
		    id: 'CreateDate'
		}
		]),
                        bbar: new Ext.PagingToolbar({
                            pageSize: 10,
                            store: dspmsstockorder,
                            displayMsg: '��ʾ��{0}����{1}����¼,��{2}��',
                            emptyMsy: 'û�м�¼',
                            displayInfo: true
                        }),
                        viewConfig: {
                            columnsText: '��ʾ����',
                            scrollOffset: 20,
                            sortAscText: '����',
                            sortDescText: '����',
                            forceFit: false
                        },
                        height: 320,
                        closeAction: 'hide',
                        stripeRows: true,
                        loadMask: true//,
                        //autoExpandColumn: 2
                    });
                    pmsstockorderGrid.render();
                    /*------DataGrid�ĺ������� End---------------*/


                })
</script>

</html>
