<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmPmsWsRecordList.aspx.cs" Inherits="PMS_frmPmsWsRecord" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html>
<head>
<title>���������Ǽ�</title><meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<link rel="stylesheet" type="text/css" href="../ext3/resources/css/ext-all.css" />
<script type="text/javascript" src="../ext3/adapter/ext/ext-base.js"></script>
<script type="text/javascript" src="../ext3/ext-all.js"></script>
<script type="text/javascript" src="../js/operateResp.js"></script>
<script type="text/javascript" src="../ext3/src/locale/ext-lang-zh_CN.js"></script>
<script type="text/javascript" src="../js/ProductShowCommon.js"></script>
<style type="text/css">
.x-grid-back-blue {  
    background: #C3D9FF;  
}  
.x-grid-back-blue2 { 
background: #D3D9EF; 
}
</style>
</head>
<body>
<div id='toolbar'></div>
<div id='divForm'></div>
<div id='dataGrid'></div>
<%=getComboBoxStore() %>
</body>
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
                saveType = 'addWsRecord';
                openAddRecordWin();
                addNewBlankRow();
            }
        }, '-', {
            text: "�༭",
            icon: "../Theme/1/images/extjs/customer/edit16.gif",
            handler: function() {
                saveType = 'saveWorkshop';
                modifyRecordWin();
            }
        }, '-', {
            text: "ɾ��",
            icon: "../Theme/1/images/extjs/customer/delete16.gif",
            handler: function() {
                deleteRecord();
            }
        }, '-', {
            text: "���",
            icon: "../Theme/1/images/extjs/customer/edit16.gif",
            handler: function() {
                saveType = 'confirmWorkshop';
                modifyRecordWin();
            }
        }, '-', {
            text: "ȡ�����",
            icon: "../Theme/1/images/extjs/customer/edit16.gif",
            handler: function() {
                saveType = 'cancleWorkshop';
                cancleConfirmRecord();
            }
}]
        });

        /*------����toolbar�ĺ��� end---------------*/
function getUrl(imageUrl)
            {
                var index = window.location.href.toLowerCase().indexOf('/pms/');
                var tempUrl = window.location.href.substring(0,index);
                return tempUrl+"/"+imageUrl;
            }
function printOrderById()
{
var sm = pmswsrecordGrid.getSelectionModel();
                //��ѡ
                var selectData = sm.getSelections();                
                var array = new Array(selectData.length);
                var orderIds = "";
                for(var i=0;i<selectData.length;i++)
                {
                    if(orderIds.length>0)
                        orderIds+=",";
                    orderIds += selectData[i].get('RecodrId');
                }
                //ҳ���ύ
                Ext.Ajax.request({
                    url: 'frmPmsWsRecordList.aspx?method=getprintdata',
//                    url:'frmOrderMst.aspx?method=billdata',
                    method: 'POST',
                    params: {
                        RecordId: orderIds
                    },
                   success: function(resp,opts){ 
                       var printData =  resp.responseText;
                       var printControl =  parent.parent.parent.document.getElementById("topFrame").contentWindow.getPrintControl();
                       printControl.Url =getUrl('xml');
                       printControl.MapUrl = printControl.Url+'/'+printStyleXml;//'/salePrint1.xml';
                       printControl.PrintXml = printData;
                       printControl.ColumnName="RecordId";
                       printControl.OnlyData=printOnlyData;
                       printControl.PageWidth=printPageWidth;
                       printControl.PageHeight =printPageHeight ;
                       printControl.Print();
//                    var billControl = document.getElementById('billControl');
//                    billControl.PrintXml = printData;
//                    billControl.setFormValue(0);
                       
                   },
		           failure: function(resp,opts){  /* Ext.Msg.alert("��ʾ","����ʧ��"); */    }
                });
}
        /*-----ȡ�����Recordʵ�庯��----*/
        /*ȡ�����*/
        function cancleConfirmRecord() {
            var sm = pmswsrecordGrid.getSelectionModel();
            //��ȡѡ���������Ϣ
            var selectData = sm.getSelected();
            //���û��ѡ�񣬾���ʾ��Ҫѡ��������Ϣ
            if (selectData == null) {
                Ext.Msg.alert("��ʾ", "��ѡ����Ҫȡ����˵���Ϣ��");
                return;
            }
            //ɾ��ǰ�ٴ������Ƿ����Ҫɾ��
            Ext.Msg.confirm("��ʾ��Ϣ", "�Ƿ����Ҫȡ�����ѡ�����Ϣ��", function callBack(id) {
                //�ж��Ƿ�ɾ������
                if (id == "yes") {
                    //ҳ���ύ
                    Ext.Ajax.request({
                        url: 'frmPmsWsRecordList.aspx?method=cancleWorkshop',
                        method: 'POST',
                        params: {
                            RecodrId: selectData.data.RecodrId
                        },
                        success: function(resp, opts) {
                            if (checkExtMessage(resp)) {
                                QueryData();                               
                            }
                        },
                        failure: function(resp, opts) {
                            Ext.Msg.alert("��ʾ", "ȡ�����ʧ��");
                        }
                    });
                }
            });
        }
        /*------��ʼToolBar�¼����� start---------------*//*-----����Recordʵ���ര�庯��----*/
        function openAddRecordWin() {
            uploadRecordWindow.show();
        }
        /*-----�༭Recordʵ���ര�庯��----*/
        function modifyRecordWin() {
            var sm = pmswsrecordGrid.getSelectionModel();
            //��ȡѡ���������Ϣ
            var selectData = sm.getSelected();
            if (selectData == null) {
                Ext.Msg.alert("��ʾ", "��ѡ����Ҫ�༭����Ϣ��");
                return;
            }
            uploadRecordWindow.show();
            setFormValue(selectData);
            setGridValue(selectData);
        }
        /*-----ɾ��Recordʵ�庯��----*/
        /*ɾ����Ϣ*/
        function deleteRecord() {
            var sm = pmswsrecordGrid.getSelectionModel();
            //��ȡѡ���������Ϣ
            var selectData = sm.getSelected();
            //���û��ѡ�񣬾���ʾ��Ҫѡ��������Ϣ
            if (selectData == null) {
                Ext.Msg.alert("��ʾ", "��ѡ����Ҫɾ������Ϣ��");
                return;
            }
            //ɾ��ǰ�ٴ������Ƿ����Ҫɾ��
            Ext.Msg.confirm("��ʾ��Ϣ", "�Ƿ����Ҫɾ��ѡ�����Ϣ��", function callBack(id) {
                //�ж��Ƿ�ɾ������
                if (id == "yes") {
                    //ҳ���ύ
                    Ext.Ajax.request({
                        url: 'frmPmsWsRecordList.aspx?method=deleteRecord',
                        method: 'POST',
                        params: {
                            RecodrId: selectData.data.RecodrId
                        },
                        success: function(resp, opts) {
                            if (checkExtMessage(resp)) {
                                Ext.Msg.alert("��ʾ", "����ɾ���ɹ�");
                                QueryData();
                            }                            
                            QueryData();
                        },
                        failure: function(resp, opts) {
                            Ext.Msg.alert("��ʾ", "����ɾ��ʧ��");
                        }
                    });
                }
            });
        }

        /*------ʵ��FormPanle�ĺ��� start---------------*/
        var pmswsrecordform = new Ext.form.FormPanel({
            url: '',
            frame: true,
            title: '',
            region: 'north',
            height: 100,
            labelWidth: 55,
            items: [
	{
	    layout: 'column',
	    items: [
	    {
	        layout: 'form',
	        border: false,
	        columnWidth: .5,
	        items: [
		    {
		        xtype: 'hidden',
		        fieldLabel: '��¼ID',
		        name: 'RecodrId',
		        id: 'RecodrId',
		        hidden: true,
		        hideLabel: true
		    },
		    {
		        xtype: 'combo',
		        fieldLabel: '����',
		        anchor: '98%',
		        name: 'WsId',
		        id: 'WsId',
		        store: dsWs,
		        displayField: 'WsName',
		        valueField: 'WsId',
		        mode: 'local',
		        triggerAction: 'all',
		        editable: true,
		        listeners: { select: function(combo, record, index) {
		            //ˢ�°��
		            Ext.getCmp('GroupId').setValue(record.get('GroupIds'));
		            this.collapse();
		        }
		        }
}]
	    },
		{
		    layout: 'form',
		    border: false,
		    columnWidth: .5,
		    items: [
		    {
		        xtype: 'textfield',
		        fieldLabel: '���',
		        anchor: '98%',
		        name: 'GroupId',
		        id: 'GroupId',
		        readOnly: true
}]
}]
	},
    {
        layout: 'column',
        items: [
	    {
	        layout: 'form',
	        border: false,
	        columnWidth: .5,
	        items: [
		    {
		        xtype: 'datefield',
		        fieldLabel: '��������',
		        columnWidth: 1,
		        anchor: '98%',
		        name: 'ManuDate',
		        id: 'ManuDate',
		        format: 'Y��m��d��',
		        value: new Date().clearTime()
}]
	    },
		{
		    layout: 'form',
		    border: false,
		    columnWidth: .5,
		    items: [
	        {
	            xtype: 'combo',
	            fieldLabel: 'ҵ��״̬',
	            columnWidth: 1,
	            anchor: '98%',
	            name: 'BizStatus',
	            id: 'BizStatus',
	            store: dsStatus,
	            displayField: 'DicsName',
	            valueField: 'DicsCode',
	            mode: 'local',
	            triggerAction: 'all',
	            disabled: true,
	            value: dsStatus.getAt(0).data.DicsCode
}]
}]
    }, {
        layout: 'column',
        items: [
		{
		    layout: 'form',
		    border: false,
		    columnWidth: .5,
		    items: [
	        {
	            xtype: 'combo',
	            fieldLabel: '���ֿ�',
	            columnWidth: 1,
	            anchor: '98%',
	            name: 'WhId',
	            id: 'WhId',
	            store: dsWh,
	            displayField: 'WhName',
	            valueField: 'WhId',
	            mode: 'local',
	            triggerAction: 'all',
	            value: dsWh.getAt(0).data.WhId
}]
}]
    }
]
        });
        /*------FormPanle�ĺ������� End---------------*/
        /*------��ϸgrid�ĺ��� start---------------*/
        var RowPattern = Ext.data.Record.create([
   { name: 'Id', type: 'string' },
   { name: 'RecordId', type: 'string' },
   { name: 'ProductId', type: 'string' },
   { name: 'SpecificationsText', type: 'string' },
   { name: 'UnitText', type: 'string' },
   { name: 'ManuQty', type: 'float' },
   { name: 'ManuAmt', type: 'float' },
   { name: 'ProductNo', type: 'string' },
   { name: 'UnitId', type: 'string' }
 ]);
        var dsRecordDtlInfo = new Ext.data.Store
({
    url: 'frmPmsWsRecordList.aspx?method=getRecordDtlInfoList',
    reader: new Ext.data.JsonReader({
        totalProperty: 'totalProperty',
        root: 'root'
    }, RowPattern)
});
        function inserNewBlankRow() {
            var rowCount = recordDtlInfoGrid.getStore().getCount();
            //alert(rowCount);
            var insertPos = parseInt(rowCount);
            var addRow = new RowPattern({
                Id: '-1',
                RecordId: '-1',
                ProductId: '',
                SpecificationsText: '',
                UnitText: '',
                ManuQty: '',
                ManuAmt: '',
                ProductNo: '',
                UnitId: ''
            });
            recordDtlInfoGrid.stopEditing();
            //����һ����
            if (insertPos > 0) {
                var rowIndex = dsRecordDtlInfo.insert(insertPos, addRow);
                recordDtlInfoGrid.startEditing(insertPos, 0);
            }
            else {
                var rowIndex = dsRecordDtlInfo.insert(0, addRow);
                recordDtlInfoGrid.startEditing(0, 0);
            }
        }
        function addNewBlankRow(combo, record, index) {
            var rowIndex = recordDtlInfoGrid.getStore().indexOf(recordDtlInfoGrid.getSelectionModel().getSelected());
            var rowCount = recordDtlInfoGrid.getStore().getCount();
            //alert('insertPos:'+rowCount+":"+rowIndex);
            //provideGridDtlData.getSelectionModel().selectRow(rowCount - 1,true);   
            if ((rowIndex == 0 && rowCount == 1) || rowIndex == rowCount - 1) {
                inserNewBlankRow();
            }
        }
        function setGridValue(selectData) {
            dsRecordDtlInfo.baseParams.RecodrId = selectData.data.RecodrId;
            dsRecordDtlInfo.load({
                callback: function(r, options, success) {
                    inserNewBlankRow();
                }
            });
        }

        var smDtl = new Ext.grid.CheckboxSelectionModel({
            singleSelect: true
        });
        /*------��ʼ��ϸDataGrid�ĺ��� start---------------*/
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
                var sm = recordDtlInfoGrid.getSelectionModel().getSelected();
                sm.set('ProductId', record.data.ProductId);
                sm.set('ProductNo', record.data.ProductNo);
                sm.set('SpecificationsText', record.data.SpecificationsText);
                sm.set('UnitText', record.data.UnitText);
                sm.set('UnitId', record.data.Unit);
                //�����ֶθ�ֵ
                if (sm.get('Id') == undefined || sm.get('Id') == null || sm.get('Id') == "") {
                    sm.set('Id', 0);
                    sm.set('RecordId', 0);
                }
                addNewBlankRow();
                this.collapse();
                var rowid = recordDtlInfoGrid.getStore().indexOf(sm);
                recordDtlInfoGrid.startEditing(rowid, 6);
            }
        });

        getProductUrl = "../scm/frmPOSOrderEdit.aspx";
        this.selectedEvent = function(record) {
            productText.setValue(record.data.ProductNo);
            var sm = recordDtlInfoGrid.getSelectionModel().getSelected();
            sm.set('ProductId', record.data.ProductId);
            sm.set('ProductNo', record.data.ProductNo);
            sm.set('SpecificationsText', record.data.SpecificationsText);
            sm.set('UnitText', record.data.UnitText);
            sm.set('UnitId', record.data.Unit);
            //�����ֶθ�ֵ
            if (sm.get('Id') == undefined || sm.get('Id') == null || sm.get('Id') == "") {
                sm.set('Id', 0);
                sm.set('RecordId', 0);
            }
            addNewBlankRow();
            var rowid = recordDtlInfoGrid.getStore().indexOf(sm);
            recordDtlInfoGrid.startEditing(rowid, 6);
        };
        createProductList();
        var recordDtlInfoGrid = new Ext.grid.EditorGridPanel({
            width: '100%',
            //height:'100%',
            autoWidth: true,
            //autoHeight:true,
            autoScroll: true,
            region: 'center',
            clicksToEdit: 1,
            enableHdMenu: false,  //����ʾ�����ֶκ���ʾ����������
            enableColumnMove: false, //�в����ƶ�
            id: '',
            store: dsRecordDtlInfo,
            loadMask: { msg: '���ڼ������ݣ����Ժ��' },
            sm: smDtl,
            cm: new Ext.grid.ColumnModel([
	    smDtl,
		new Ext.grid.RowNumberer(), //�Զ��к�
		{
		    header: '��ˮ��',
		    dataIndex: 'Id',
		    id: 'Id',
		    hidden: true,
		    hideable: false
        },
		{
		    id: 'ProductNo',
		    header: "����",
		    dataIndex: 'ProductNo',
		    width: 60,
		    renderer: function(v, m) {
		        m.css = 'x-grid-back-blue2';
		        return v;
		    },
		    editor: productText
		    //		    editor: new Ext.form.TextField({
		    //		        allowBlank: false,
		    //		        enableKeyEvents: true,
		    //		        initEvents: function() {
		    //		            var keyPress = function(e) {
		    //		                if (e.getKey() == e.ENTER) {
		    //		                    var textValue = this.getValue();
		    //		                    var index = dsProductList.findBy(
		    //                                function(record, id) {
		    //                                    return record.get('ProductNo') == textValue;
		    //                                }
		    //                            );
		    //		                    if (index < 0) {
		    //		                        alert('������Ʒ�����Ƿ���ȷ��');
		    //		                        return;
		    //		                    }
		    //		                    var record = dsProductList.getAt(index);
		    //		                    var sm = recordDtlInfoGrid.getSelectionModel().getSelected();
		    //		                    sm.set('ProductId', record.data.ProductId);
		    //		                    sm.set('SpecificationsText', record.data.SpecificationsText);
		    //		                    sm.set('UnitText', record.data.UnitText);
		    //		                    //�����ֶθ�ֵ
		    //		                    if (sm.get('id') == undefined || sm.get('id') == null || sm.get('id') == "") {
		    //		                        sm.set('Id', 0);
		    //		                        sm.set('RecordId', 0);
		    //		                    }
		    //		                    addNewBlankRow();
		    //		                    var rowid = recordDtlInfoGrid.getStore().indexOf(sm);
		    //		                    recordDtlInfoGrid.startEditing(rowid, 6);
		    //		                }
		    //		            };
		    //		            this.el.on("keypress", keyPress, this);
		    //		        }
		    //		    })
		},
		{
		    header: '��Ʒ����',
		    dataIndex: 'ProductId',
		    id: 'ProductId',
		    width: 150,
		    editor: productCombo,
		    renderer: function(value, cellmeta, record, rowIndex, columnIndex, store) {
		        //���ֵ��ʾ����
		        //��ȡ��ǰid="combo_process"��comboBoxѡ���ֵ
		        var index = dsProductList.findBy(function(record, id) {
		            return record.get(productCombo.valueField) == value;
		        });
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
		    header: '���',
		    width: 50,
		    dataIndex: 'SpecificationsText',
		    id: 'SpecificationsText',
		    renderer: { fn: function(value, cellmeta) {
		        cellmeta.css = 'x-grid-back-blue';
		        return value;
		    }
		    }
		},
		{
		    header: '��λ',
		    width: 50,
		    dataIndex: 'UnitText',
		    id: 'UnitText',
		    renderer: { fn: function(value, cellmeta) {
		        cellmeta.css = 'x-grid-back-blue';
		        return value;
		    }
		    }
		},
		{
		    header: '��������',
		    dataIndex: 'ManuQty',
		    id: 'ManuQty',
		    width: 50,
		    editor: new Ext.form.NumberField({ allowBlank: true })
		},
		{
		    header: '��������',
		    dataIndex: 'ManuAmt',
		    id: 'ManuAmt',
		    width: 50,
		    editor: new Ext.form.NumberField({ allowBlank: true, decimalPrecision: 6 })
		}
		]),
            viewConfig: {
                columnsText: '��ʾ����',
                scrollOffset: 20,
                sortAscText: '����',
                sortDescText: '����',
                forceFit: true
            },
            height: 280,
            closeAction: 'hide',
            stripeRows: true,
            loadMask: true,
            autoExpandColumn: 2,
            listeners: {
                afteredit: function(e) {
                    //�Զ�����
                    var record = e.record; //��ȡ���޸ĵ�������
                    var field = e.field; //��ȡ���޸ĵ�����
                    if (field = 'ManuQty') {
                        Ext.Ajax.request({
                            url: 'frmPmsWsRecordList.aspx?method=getConvertPercent',
                            params: {
                                ProductId: record.data.ProductId
                            },
                            success: function(resp, opts) {
                                var data = Ext.util.JSON.decode(resp.responseText);
                                record.set('ManuAmt', accMul(data.percent, record.get('ManuQty')).toFixed(6));
                            },
                            failure: function(resp, opts) {
                                Ext.Msg.alert("��ʾ", "��ȡ��Ϣʧ��");
                            }
                        });
                    }
                }
            }
        });
        /*------��ϸgrid�ĺ��� End---------------*/
        /*------��ʼ�������ݵĴ��� Start---------------*/
        if (typeof (uploadRecordWindow) == "undefined") {//�������2��windows����
            uploadRecordWindow = new Ext.Window({
                id: 'Recordformwindow',
                title: '�����Ǽ�ά��'
		, iconCls: 'upload-win'
		, width: 600
		, height: 400
		, layout: 'border'
		, plain: true
		, modal: true
		, constrain: true
		, resizable: false
		, closeAction: 'hide'
		, autoDestroy: true
		, items: [pmswsrecordform, recordDtlInfoGrid]
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
			    uploadRecordWindow.hide();
			}
			, scope: this
}]
            });
        }
        uploadRecordWindow.addListener("hide", function() {
            pmswsrecordform.getForm().reset();
            recordDtlInfoGrid.getStore().removeAll();
        });

        /*------��ʼ��ȡ�������ݵĺ��� start---------------*/

        function saveUserData() {
            var json = "";
            dsRecordDtlInfo.each(function(record) {
                json += Ext.util.JSON.encode(record.data) + ',';
            });
            json = json.substring(0, json.length - 1);
            //Ȼ�����������
            //alert(json);
            //alert(saveType);
            Ext.Ajax.request({
                url: 'frmPmsWsRecordList.aspx?method=' + saveType,
                method: 'POST',
                params: {
                    RecodrId: Ext.getCmp('RecodrId').getValue(),
                    WsId: Ext.getCmp('WsId').getValue(),
                    //GroupId:Ext.getCmp('GroupId').getValue(),
                    ManuDate: Ext.util.Format.date(Ext.getCmp('ManuDate').getValue(), 'Y/m/d'),
                    BizStatus: Ext.getCmp('BizStatus').getValue(),
                    WhId: Ext.getCmp('WhId').getValue(),
                    DetailInfo: json
                },
                success: function(resp, opts) {
                    if (checkExtMessage(resp)) {
                        QueryData();
                        uploadRecordWindow.hide();
                    }
                },
                failure: function(resp, opts) {
                    Ext.Msg.alert("��ʾ", "����ʧ��");
                }
            });
        }
        /*------������ȡ�������ݵĺ��� End---------------*/

        /*------��ʼ�������ݵĺ��� Start---------------*/
        function setFormValue(selectData) {
            Ext.Ajax.request({
                url: 'frmPmsWsRecordList.aspx?method=getrecord',
                params: {
                    RecodrId: selectData.data.RecodrId
                },
                success: function(resp, opts) {
                    var data = Ext.util.JSON.decode(resp.responseText);
                    Ext.getCmp("RecodrId").setValue(data.RecodrId);
                    Ext.getCmp("WsId").setValue(data.WsId);
                    Ext.getCmp("GroupId").setValue(data.GroupIds);
                    Ext.getCmp("ManuDate").setValue((new Date(data.ManuDate.replace(/-/g, "/"))));
                    Ext.getCmp("BizStatus").setValue(data.BizStatus);
                    if (data.WhId != '0') {
                        Ext.getCmp("WhId").setValue(data.WhId);
                    }
                },
                failure: function(resp, opts) {
                    Ext.Msg.alert("��ʾ", "��ȡ�û���Ϣʧ��");
                }
            });
        }
        /*------�������ý������ݵĺ��� End---------------*/
        /*------��ʼ��ѯform end---------------*/

        //��������
        var produceStartPanel = new Ext.form.DateField({
            xtype: 'datefield',
            fieldLabel: '������ʼ����',
            anchor: '95%',
            name: 'StartDate',
            id: 'StartDate',
            format: 'Y��m��d��',  //���������ʽ
            value: new Date().clearTime()
        });

        //��������
        var produceEndPanel = new Ext.form.DateField({
            xtype: 'datefield',
            fieldLabel: '������������',
            anchor: '95%',
            name: 'EndDate',
            id: 'EndDate',
            format: 'Y��m��d��',  //���������ʽ
            value: new Date().clearTime()
        });

        var producePostPanel = new Ext.form.TextField({
            style: 'margin-left:0px',
            cls: 'key',
            xtype: 'textfield',
            fieldLabel: '��������',
            name: 'nameCust',
            anchor: '95%'
        });

        var serchform = new Ext.FormPanel({
            renderTo: 'divForm',
            labelAlign: 'left',
            layout: 'fit',
            buttonAlign: 'right',
            bodyStyle: 'padding:5px',
            frame: true,
            labelWidth: 80,
            items: [{
                layout: 'column',   //�����Ԫ��Ϊ����Ϊ�в��ַ�ʽ
                border: false,
                items: [{
                    columnWidth: .28,  //����ռ�õĿ�ȣ���ʶΪ20��
                    layout: 'form',
                    border: false,
                    items: [
                    produceStartPanel
                ]
                }, {
                    columnWidth: .28,
                    layout: 'form',
                    border: false,
                    items: [
                    produceEndPanel
                    ]
                }, {
                    name: 'cusStyle',
                    columnWidth: .36,
                    layout: 'form',
                    border: false,
                    labelWidth: 55,
                    items: [
                    producePostPanel
                ]
                }, {
                    columnWidth: .08,
                    layout: 'form',
                    border: false,
                    items: [{ cls: 'key',
                        xtype: 'button',
                        text: '��ѯ',
                        anchor: '50%',
                        handler: function() {
                            QueryData();

                        }
}]
}]
}]
                    });
                    /*------��ʼ��ѯform end---------------*/
                    function QueryData() {
                        var starttime = produceStartPanel.getValue();
                        var endtime = produceEndPanel.getValue();
                        var wsinfo = producePostPanel.getValue();

                        dspmswsrecord.baseParams.StartProduceDate = Ext.util.Format.date(starttime, 'Y/m/d');
                        dspmswsrecord.baseParams.EndProduceDate = Ext.util.Format.date(endtime, 'Y/m/d');
                        dspmswsrecord.baseParams.WsName = wsinfo;

                        dspmswsrecord.load({
                            params: {
                                start: 0,
                                limit: 10
                            }
                        });
                    }
                    /*------��ʼ��ȡ���ݵĺ��� start---------------*/
                    var dspmswsrecord = new Ext.data.Store
({
    url: 'frmPmsWsRecordList.aspx?method=getRecordList',
    reader: new Ext.data.JsonReader({
        totalProperty: 'totalProperty',
        root: 'root'
    }, [
	{ name: 'RecodrId' },
	{ name: 'WsId' },
	{ name: 'WsName' },
	{ name: 'GroupIds' },
	{ name: 'ManuDate' },
	{ name: 'OrgId' },
	{ name: 'OperId' },
	{ name: 'OperName' },
	{ name: 'OwnerId' },
	{ name: 'CreateDate' },
	{ name: 'UpdateDate' },
	{ name: 'BizStatus'
}])
	,sortData: function(f, direction) {
        var tempSort = Ext.util.JSON.encode(dspmswsrecord.sortInfo);
        if (sortInfor != tempSort) {
            sortInfor = tempSort;
            dspmswsrecord.baseParams.SortInfo = sortInfor;
            dspmswsrecord.load({ params: { limit: defaultPageSize, start: 0} });
        }
    },
    listeners:
	{
	    scope: this,
	    load: function() {
	    }
	}
});
var sortInfor='';

                    /*------��ȡ���ݵĺ��� ���� End---------------*/

                    /*------��ʼDataGrid�ĺ��� start---------------*/

var defaultPageSize = 10;
    var toolBar = new Ext.PagingToolbar({
        pageSize: 10,
        store: dspmswsrecord,
        displayMsg: '��ʾ��{0}����{1}����¼,��{2}��',
        emptyMsy: 'û�м�¼',
        displayInfo: true
    });
    var pageSizestore = new Ext.data.SimpleStore({
        fields: ['pageSize'],
        data: [[10], [20], [30]]
    });
    var combo = new Ext.form.ComboBox({
        regex: /^\d*$/,
        store: pageSizestore,
        displayField: 'pageSize',
        typeAhead: true,
        mode: 'local',
        emptyText: '����ÿҳ��¼��',
        triggerAction: 'all',
        selectOnFocus: true,
        width: 135
    });
    toolBar.addField(combo);

    combo.on("change", function(c, value) {
        toolBar.pageSize = value;
        defaultPageSize = toolBar.pageSize;
    }, toolBar);
    combo.on("select", function(c, record) {
        toolBar.pageSize = parseInt(record.get("pageSize"));
        defaultPageSize = toolBar.pageSize;
        toolBar.doLoad(0);
    }, toolBar);
    
                    var sm = new Ext.grid.CheckboxSelectionModel({
                        singleSelect: true
                    });
                    var pmswsrecordGrid = new Ext.grid.GridPanel({
                        el: 'dataGrid',
                        width: '100%',
                        height: '100%',
                        autoWidth: true,
                        autoHeight: true,
                        autoScroll: true,
                        layout: 'fit',
                        id: '',
                        store: dspmswsrecord,
                        loadMask: { msg: '���ڼ������ݣ����Ժ��' },
                        sm: sm,
                        cm: new Ext.grid.ColumnModel([
		sm,
		new Ext.grid.RowNumberer(), //�Զ��к�
		{
		header: '��¼ID',
		dataIndex: 'RecodrId',
		id: 'RecodrId',
		hidden: true,
		hideable: false
},
		{
		    header: '����',
		    dataIndex: 'WsName',
		    id: 'WsName',
		    sortable: true
		},
		{
		    header: '���',
		    dataIndex: 'GroupIds',
		    id: 'GroupIds',
		    sortable: true
		},
		{
		    header: '��������',
		    dataIndex: 'ManuDate',
		    id: 'ManuDate',
		    format: 'Y��m��d��',
		    sortable: true,
		    renderer: Ext.util.Format.dateRenderer('Y��m��d��')
		},
		{
		    header: 'ҵ��״̬',
		    dataIndex: 'BizStatus',
		    id: 'BizStatus',
		    sortable: true,
		    renderer: function(val) {
		        dsStatus.each(function(r) {
		            if (val == r.data['DicsCode']) {
		                val = r.data['DicsName'];
		                return;
		            }
		        });
		        return val;
		    }
		},
		{
		    header: '������',
		    dataIndex: 'OperName',
		    id: 'OperName',
		    width: 60
		}

		]),
                        bbar:toolBar,
                        viewConfig: {
                            columnsText: '��ʾ����',
                            scrollOffset: 20,
                            sortAscText: '����',
                            sortDescText: '����',
                            forceFit: true
                        },
                        height: 280,
                        closeAction: 'hide',
                        stripeRows: true,
                        loadMask: true,
                        autoExpandColumn: 2
                    });
                    
                        
                        pmswsrecordGrid.on('render', function(grid) {  
        var store = grid.getStore();  // Capture the Store.  
  
        var view = grid.getView();    // Capture the GridView.  
  
        pmswsrecordGrid.tip = new Ext.ToolTip({  
            target: view.mainBody,    // The overall target element.  
      
            delegate: '.x-grid3-row', // Each grid row causes its own seperate show and hide.  
      
            trackMouse: true,         // Moving within the row should not hide the tip.  
      
            renderTo: document.body,  // Render immediately so that tip.body can be referenced prior to the first show.  
      
            listeners: {              // Change content dynamically depending on which element triggered the show.  
      
                beforeshow: function updateTipBody(tip) {  
                    var rowIndex = view.findRowIndex(tip.triggerElement);
                            var element = document.elementFromPoint(tip.x-20, tip.y-20);
                             var v = view.findCellIndex(element);
                             if(v==4||v==5||v==3)
                             {
                              
                                if(showTipRowIndex == rowIndex)
                                    return;
                                else
                                    showTipRowIndex = rowIndex;
                                     tip.body.dom.innerHTML="���ڼ������ݡ���";
                                        //ҳ���ύ
                                        Ext.Ajax.request({
                                            url: 'frmPmsWsRecordList.aspx?method=getpmswsdetailinfo',
                                            method: 'POST',
                                            params: {
                                                RecodrId: grid.getStore().getAt(rowIndex).data.RecodrId
                                            },
                                            success: function(resp, opts) {
                                                tip.body.dom.innerHTML = resp.responseText;
                                            },
                                            failure: function(resp, opts) {
                                                pmswsrecordGrid.tip.hide();
                                            }
                                        });
                                }//ϸ����Ϣ                                                   
                                else
                                {
                                    pmswsrecordGrid.tip.hide();
                                }
                        
            }  }});
        });  
    var showTipRowIndex=-1;
                    
                    pmswsrecordGrid.render();
                    /*------DataGrid�ĺ������� End---------------*/
                    function accMul(arg1, arg2) {
                        try {
                            //�����������
                            var m = 0, s1 = arg1.toString(), s2 = arg2.toString();
                            try { m += s1.split(".")[1].length } catch (e) { }
                            try { m += s2.split(".")[1].length } catch (e) { }
                            return Number(s1.replace(".", "")) * Number(s2.replace(".", "")) / Math.pow(10, m);
                        }
                        catch (err) {
                            return 0;
                        }
                    }

                    QueryData();
                })
</script>
</html>

