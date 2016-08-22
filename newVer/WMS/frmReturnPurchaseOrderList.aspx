<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmReturnPurchaseOrderList.aspx.cs" Inherits="WMS_frmReturnPurchaseOrderList" %>

<html>
<head>
<title>�ɹ��˻����б�ҳ��</title><meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<link rel="stylesheet" type="text/css" href="../ext3/resources/css/ext-all.css" />
<script type="text/javascript" src="../ext3/adapter/ext/ext-base.js"></script>
<script type="text/javascript" src="../ext3/ext-all.js"></script>
<script type="text/javascript" src="../ext3/example/ItemDeleter.js"></script>
<script type="text/javascript" src="../js/operateResp.js"></script>
<script type="text/javascript" src="../ext3/src/locale/ext-lang-zh_CN.js"></script>
<style type="text/css">
.extensive-remove {
background-image: url(../Theme/1/images/extjs/customer/cross.gif) ! important;
}
.x-grid-back-blue { 
background: #08F5FE; 
}
</style>
</head>
<body>
<div id='toolbar'></div>
<div id='divSearchForm'></div>
<div id='divForm'></div>
<div id='divOrderGrid'></div>

</body>
<%=getComboBoxStore()%>
<script type="text/javascript">
    Ext.BLANK_IMAGE_URL = "../ext3/resources/images/default/s.gif";
    var userGridData;
    Ext.onReady(function() {
        /*------ʵ��toolbar�ĺ��� start---------------*/
        var windowTitle = "";
        var Toolbar = new Ext.Toolbar({
            renderTo: "toolbar",
            items: [{
                text: "����",
                icon: "../theme/1/images/extjs/customer/add16.gif",
                handler: function() { addOrderWin(); }
            }, '-', {
                text: "�༭",
                icon: "../theme/1/images/extjs/customer/edit16.gif",
                handler: function() { editOrderWin(); }
            }, '-', {
                text: "ɾ��",
                icon: "../theme/1/images/extjs/customer/delete16.gif",
                handler: function() { deleteOrderWin(); }
            }, '-', {
                text: "�鿴",
                icon: "../theme/1/images/extjs/customer/delete16.gif",
                handler: function() { LookOrderWin(); }
            }, '-', {
                text: "�˻�ȷ��",
                icon: "../theme/1/images/extjs/customer/edit16.gif",
                handler: function() { confirmOrderWin(); }
}, '-', {
                text: "���뵥��ӡ",
                icon: "../Theme/1/images/extjs/customer/edit16.gif",
                handler: function() {
                    printOutStock();                    
                }
            }]
            });

            /*------����toolbar�ĺ��� end---------------*/
function getUrl(imageUrl) {
                var index = window.location.href.toLowerCase().indexOf('/wms/');
                var tempUrl = window.location.href.substring(0, index);
                return tempUrl + "/" + imageUrl;
            }
        function printOutStock() {
                var sm = userGrid.getSelectionModel();
                //��ѡ
                var selectData = sm.getSelections();
                var array = new Array(selectData.length);
                var orderIds = "";
                for (var i = 0; i < selectData.length; i++) {
                    if (orderIds.length > 0)
                        orderIds += ",";
                    orderIds += selectData[i].get('OrderId');
                }
                //ҳ���ύ
                Ext.Ajax.request({
                    url: 'frmReturnOrderList.aspx?method=outprintdate',
                    method: 'POST',
                    params: {
                        OrderId: orderIds
                    },
                    success: function(resp, opts) {
                        
                        var printData = resp.responseText;
                        var printControl = parent.parent.parent.document.getElementById("topFrame").contentWindow.getPrintControl();
                        printControl.Url = getUrl('xml');
                        printControl.MapUrl = printControl.Url + '/' + printOutStyleXml; //'/salePrint1.xml';
                        printControl.PrintXml = printData;
                        printControl.ColumnName = "OrderId";
                        printControl.OnlyData = printOutOnlyData;
                        printControl.PageWidth = printOutPageWidth;
                        printControl.PageHeight = printOutPageHeight;
                        printControl.Print();

                    },
                    failure: function(resp, opts) {  /* Ext.Msg.alert("��ʾ","����ʧ��"); */ }
                });
            }
            /*------��ʼToolBar�¼����� start---------------*//*-----����Orderʵ���ര�庯��----*/
            function updateDataGrid() {
                var WhId = WhNamePanel.getValue();
                var StartDate = Ext.util.Format.date(StartDatePanel.getValue(),'Y/m/d');
                var EndDate = Ext.util.Format.date(EndDatePanel.getValue(),'Y/m/d');
                var Status = StatusPanel.getValue();
                var Type = TypePanel.getValue();
                
                userGridData.baseParams.WhId = WhId;
                userGridData.baseParams.StartDate = StartDate;
                userGridData.baseParams.Type = "W0209";//Type;
                userGridData.baseParams.EndDate = EndDate;
                userGridData.baseParams.Status = Status;
                
                userGridData.load({
                    params: {
                        start: 0,
                        limit: 10
                    }
                });
            }


            //�����ɹ��˻���
            function addOrderWin() {
                uploadPurchaseOrderWindow.show();
                //uploadReturnOrderWindow.setTitle("�˻�����ϸ��¼");
                //document.getElementById("editReturnOrderIFrame").src = "frmReturnOrderEdit.aspx?id=" + selectData.data.OrderId;
            }
            //�༭�ɹ��˻���
            function editOrderWin(){
                var sm = userGrid.getSelectionModel();
                //��ȡѡ���������Ϣ
                var selectData = sm.getSelected();
                if (selectData == null) {
                    Ext.Msg.alert("��ʾ", "��ѡ���˻�����¼��");
                    return;
                }
                if (selectData.data.Status > 0)//����δ���״̬
                {
                    Ext.Msg.alert("��ʾ", "���ύ���˻������ܱ༭��");
                    return;
                }
                uploadReturnOrderWindow.show();
                uploadReturnOrderWindow.setTitle("�˻�����ϸ��¼");
                document.getElementById("editReturnOrderIFrame").src = "frmReturnOrderEdit.aspx?id=" + selectData.data.OrderId;
            }
            function deleteOrderWin() {
                var sm = userGrid.getSelectionModel();
                //��ȡѡ���������Ϣ
                var selectData = sm.getSelected();
                //���û��ѡ�񣬾���ʾ��Ҫѡ��������Ϣ
                if (selectData == null) {
                    Ext.Msg.alert("��ʾ", "��ѡ����Ҫɾ������Ϣ��");
                    return;
                }
                if (selectData.data.Status > 0)//����δ���״̬
                {
                    Ext.Msg.alert("��ʾ", "���ύ���˻�������ɾ����");
                    return;
                }
                //ɾ��ǰ�ٴ������Ƿ����Ҫɾ��
                Ext.Msg.confirm("��ʾ��Ϣ", "�Ƿ����Ҫɾ��ѡ����˻�����", function callBack(id) {
                    //�ж��Ƿ�ɾ������
                    if (id == "yes") {
                        //ҳ���ύ
                        Ext.Ajax.request({
                            url: 'frmReturnPurchaseOrderList.aspx?method=deleteReturnOrder',
                            method: 'POST',
                            params: {
                                OrderId: selectData.data.OrderId
                            },
                            success: function(resp, opts) {
                                 if(checkExtMessage(resp))
                                    {
                                        updateDataGrid();
                                  
                                    }
                            }
                        });
                    }
                });
            }
            //�鿴
            function LookOrderWin() {
                var sm = userGrid.getSelectionModel();
                //��ȡѡ���������Ϣ
                var selectData = sm.getSelected();
                if (selectData == null) {
                    Ext.Msg.alert("��ʾ", "��ѡ��ɹ��˻�����¼��");
                    return;
                }
                uploadReturnOrderWindow.show();
                uploadReturnOrderWindow.setTitle("�鿴�ɹ��˻���");
                document.getElementById("editReturnOrderIFrame").src = "frmReturnOrderEdit.aspx?id=" + selectData.data.OrderId + "&status=look";
            }
            //�˻�ȷ��
            function confirmOrderWin(){
                var sm = userGrid.getSelectionModel();
                //��ȡѡ���������Ϣ
                var selectData = sm.getSelected();
                //���û��ѡ�񣬾���ʾ��Ҫѡ��������Ϣ
                if (selectData == null) {
                    Ext.Msg.alert("��ʾ", "��ѡ����Ҫȷ�ϵ���Ϣ��");
                    return;
                }
                if (selectData.data.Status > 0)//����δ���״̬
                {
                    Ext.Msg.alert("��ʾ", "���˻����Ѿ�ȷ�ϣ�");
                    return;
                }
                Ext.Msg.confirm("��ʾ��Ϣ", "�Ƿ����Ҫȷ��ѡ����˻�����", function callBack(id) {
                    if (id == "yes") {
                        //ҳ���ύ
                        Ext.Ajax.request({
                            url: 'frmReturnPurchaseOrderList.aspx?method=confirmReturnOrder',
                            method: 'POST',
                            params: {
                                OrderId: selectData.data.OrderId,
                                Status:1
                            },
                            success: function(resp, opts) {
                                if(checkExtMessage(resp))
                                {
                                    updateDataGrid();
                                }
                           }
                        });
                    }
                });
            }
            /*------��ʼ�������ݵĴ��� Start---------------*/
            if (typeof (uploadReturnOrderWindow) == "undefined") {//�������2��windows����
                uploadReturnOrderWindow = new Ext.Window({
                    id: 'ReturnOrderWindow'
		            , iconCls: 'upload-win'
		            , width: 750
		            , height: 490
		            , layout: 'fit'
		            , plain: true
		            , modal: true
		            , constrain: true
		            , resizable: false
		            , closeAction: 'hide'
		            , autoDestroy: true
		            , html: '<iframe id="editReturnOrderIFrame" width="100%" height="100%" border=0 src="frmReturnOrderEdit.aspx"></iframe>'

                });
            }
            uploadReturnOrderWindow.addListener("hide", function() {
                updateDataGrid();
            });


            /*------��ʼ��ѯform�ĺ��� start---------------*/

            var WhNamePanel = new Ext.form.ComboBox({
                name: 'warehouseCombo',
                store: dsWarehouseList,
                displayField: 'WhName',
                valueField: 'WhId',
                typeAhead: true, //�Զ�����һ����������ѡ�ȫ����
                triggerAction: 'all',
                emptyText: '��ѡ��ֿ�',
                selectOnFocus: true,
                forceSelection: true,
                mode: 'local',
                fieldLabel: '�ֿ�',
                anchor: '90%',
                id: 'WhName',
                value: dsWarehouseList.getRange()[0].data.WhId,
                editable: false,
                listeners: { specialkey: function(f, e) { if (e.getKey() == e.ENTER) { Ext.getCmp('Type').focus(); } }
                }

            });
            var TypePanel = new Ext.form.ComboBox({
                name: 'returnTypeCombo',
                store: dsReturnTypeList,
                displayField: 'DicsName',
                valueField: 'DicsCode',
                typeAhead: true, //�Զ�����һ����������ѡ�ȫ����
                triggerAction: 'all',
                emptyText: '��ѡ���˻�����',
                selectOnFocus: true,
                forceSelection: true,
                mode: 'local',
                fieldLabel: '�˻�����',
                anchor: '90%',
                id: 'Type',
                listeners: { specialkey: function(f, e) { if (e.getKey() == e.ENTER) { Ext.getCmp('BillStatus').focus(); } } }
            });

            var StatusPanel = new Ext.form.ComboBox({
                name: 'billStatusCombo',
                store: dsBillStatus,
                displayField: 'BillStatusName',
                valueField: 'BillStatusId',
                typeAhead: true, //�Զ�����һ����������ѡ�ȫ����
                triggerAction: 'all',
                value: 0, //δ���
                selectOnFocus: true,
                forceSelection: true,
                editable: false,
                mode: 'local',
                fieldLabel: '����״̬',
                anchor: '90%',
                id: 'BillStatus',
                listeners: { specialkey: function(f, e) { if (e.getKey() == e.ENTER) { Ext.getCmp('StartDate').focus(); } } }
            });
            var StartDatePanel = new Ext.form.DateField({
                style: 'margin-left:0px',
                cls: 'key',
                xtype: 'datefield',
                fieldLabel: '��ʼʱ��',
                format: 'Y��m��d��',
                anchor: '90%',
                value: new Date().getFirstDateOfMonth().clearTime(),
                id: 'StartDate',
                listeners: { specialkey: function(f, e) { if (e.getKey() == e.ENTER) { Ext.getCmp('EndDate').focus(); } } }
            });
            var EndDatePanel = new Ext.form.DateField({
                style: 'margin-left:0px',
                cls: 'key',
                xtype: 'datefield',
                fieldLabel: '����ʱ��',
                anchor: '90%',
                format: 'Y��m��d��',
                id: 'EndDate',
                value: new Date().clearTime(),
                listeners: { specialkey: function(f, e) { if (e.getKey() == e.ENTER) { Ext.getCmp('searchebtnId').focus(); } } }
            });
            var serchform = new Ext.FormPanel({
                renderTo: 'divSearchForm',
                labelAlign: 'left',
                //layout: 'fit',
                buttonAlign: 'right',
                bodyStyle: 'padding:5px',
                frame: true,
                labelWidth: 55,
                items: [{
                    layout: 'column',   //�����Ԫ��Ϊ����Ϊ�в��ַ�ʽ
                    border: false,
                    items: [{
                        columnWidth: .3,  //����ռ�õĿ�ȣ���ʶΪ20��
                        layout: 'form',
                        border: false,
                        items: [
                        WhNamePanel
                    ]
//                    }, {
//                        columnWidth: .3,
//                        layout: 'form',
//                        border: false,
//                        items: [
//                        TypePanel
//                        ]
                    }, {
                        columnWidth: .3,  //����ռ�õĿ�ȣ���ʶΪ20��
                        layout: 'form',
                        border: false,
                        items: [
                        StatusPanel
                    ]
                    }
                    ]
                }
                    ,
                    {

                        layout: 'column',   //�����Ԫ��Ϊ����Ϊ�в��ַ�ʽ
                        border: false,
                        items: [{
                            columnWidth: .3,  //����ռ�õĿ�ȣ���ʶΪ20��
                            layout: 'form',
                            border: false,
                            items: [
                        StartDatePanel
                    ]
                        }, {
                            columnWidth: .3,
                            layout: 'form',
                            border: false,
                            items: [
                        EndDatePanel
                        ]
                        }, {
                            columnWidth: .2,
                            layout: 'form',
                            border: false,
                            items: [{ cls: 'key',
                                xtype: 'button',
                                text: '��ѯ',
                                id: 'searchebtnId',
                                anchor: '50%',
                                handler: function() {
                                    updateDataGrid();
                                }
}]
}]
}]
            });


            /*------��ʼ��ѯform�ĺ��� end---------------*/

            /*------��ʼ��ȡ���ݵĺ��� start---------------*/
            userGridData = new Ext.data.Store
({
    url: 'frmReturnOrderList.aspx?method=getReturnOrderList',
    reader: new Ext.data.JsonReader({
        totalProperty: 'totalProperty',
        root: 'root'
    }, [
	{
	    name: 'OrderId'
	},
	{
	    name: 'WhId'
	},
	{
	    name: 'Type'
	},
	{
	    name: 'OrgId'
	},
	{
	    name: 'OwnerId'
	},
	{
	    name: 'OperId'
	},
	{
	    name: 'CreateDate'
	},
	{
	    name: 'UpdateDate'
	},
	{
	    name: 'Status'
	},
	{
	    name: 'Remark'
	},
	{
	    name: 'OriginBillId'
	},
	{
	    name: 'ReturnStatus'
	},
	{
	    name: 'OrderNumber'
	}
])
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
            var userGrid = new Ext.grid.GridPanel({
                el: 'divOrderGrid',
                width: '100%',
                height: '100%',
                autoWidth: true,
                autoHeight: true,
                autoScroll: true,
                layout: 'fit',
                id: '',
                store: userGridData,
                loadMask: { msg: '���ڼ������ݣ����Ժ��' },
                sm: sm,
                cm: new Ext.grid.ColumnModel([
		sm,
		new Ext.grid.RowNumberer(), //�Զ��к�
		{
		        header: '������',
		        dataIndex: 'OrderId',
		        id: 'OrderId',
                hidden:true,
                width:0
        },
		{
		        header: '���',
		        dataIndex: 'OrderNumber',
		        id: 'OrderNumber'
        },
		{
		    header: '�ֿ�',
		    dataIndex: 'WhId',
		    id: 'WhId',
		    renderer: function(val, params, record) {
		        if (dsWarehouseList.getCount() == 0) {
		            dsWarehouseList.load();
		        }
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
		    header: '�˻�����',
		    dataIndex: 'Type',
		    id: 'Type',
		    renderer: function(val, params, record) {
		        if (dsReturnTypeList.getCount() == 0) {
		            dsReturnTypeList.load();
		        }
		        dsReturnTypeList.each(function(r) {
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
		    dataIndex: 'OperId',
		    id: 'OperId',
		    renderer: function(val, params, record) {
		        if (dsOperationList.getCount() == 0) {
		            dsOperationList.load();
		        }
		        dsOperationList.each(function(r) {
		            if (val == r.data['EmpId']) {
		                val = r.data['EmpName'];
		                return;
		            }
		        });
		        return val;
		    }
		},
		{
		    header: '����ʱ��',
		    dataIndex: 'CreateDate',
		    id: 'CreateDate',
		    format: 'Y��m��d��'
		},

		{
		    header: '����״̬',
		    dataIndex: 'Status',
		    id: 'Status',
		    renderer: function(val, params, record) {
		        if (dsBillStatus.getCount() == 0) {
		            dsBillStatus.load();
		        }
		        dsBillStatus.each(function(r) {
		            if (val == r.data['BillStatusId']) {
		                val = r.data['BillStatusName'];
		                return;
		            }
		        });
		        return val;
		    }
		},

		{
		    header: '�˻�ԭ��',
		    dataIndex: 'Remark',
		    id: 'Remark'
}]),
                bbar: new Ext.PagingToolbar({
                    pageSize: 10,
                    store: userGridData,
                    displayMsg: '��ʾ��{0}����{1}����¼,��{2}��',
                    emptyMsy: 'û�м�¼',
                    displayInfo: true
                }),
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
            
            userGrid.on('render', function(grid) {
                var store = grid.getStore();  // Capture the Store.  
                var view = grid.getView();    // Capture the GridView.
            userGrid.tip = new Ext.ToolTip({
                    target: view.mainBody,    // The overall target element.  
                    delegate: '.x-grid3-row', // Each grid row causes its own seperate show and hide.  
                    trackMouse: true,         // Moving within the row should not hide the tip.  
                    renderTo: document.body,  // Render immediately so that tip.body can be referenced prior to the first show.  
                    listeners: {              // Change content dynamically depending on which element triggered the show.  
                        beforeshow: function updateTipBody(tip) {
                            var rowIndex = view.findRowIndex(tip.triggerElement);
                            
                            var element = document.elementFromPoint(tip.x-20, tip.y-20);
                             var v = view.findCellIndex(element);
                             //ϸ����Ϣ
                              if(v==2||v==3)
                                {
                                    if(showTipRowIndex == rowIndex)
                                        return;
                                    else
                                        showTipRowIndex = rowIndex;
                                        
                                     tip.body.dom.innerHTML="���ڼ������ݡ���";
                                        //ҳ���ύ
                                        Ext.Ajax.request({
                                            url: 'frmReturnOrderList.aspx?method=getdetailinfo',
                                            method: 'POST',
                                            params: {
                                                OrderId: grid.getStore().getAt(rowIndex).data.OrderId
                                            },
                                            success: function(resp, opts) {
                                                tip.body.dom.innerHTML = resp.responseText;
                                            },
                                            failure: function(resp, opts) {
                                                userGrid.tip.hide();
                                            }
                                        });
                                }                                
                                else
                                {
                                    userGrid.tip.hide();
                                }
                        }
                    }
                });
    });
    var showTipRowIndex =-1;
            userGrid.render();
            /*------DataGrid�ĺ������� End---------------*/
            updateDataGrid();


            //===============================================================

            function updateDataGrid_purchase() {

                var WhId = WhNamePanel_purchase.getValue();
                var SupplierId = SupplierNamePanel_purchase.getValue();
                var StartDate = Ext.util.Format.date(StartDatePanel_purchase.getValue(),'Y/m/d');
                var EndDate = Ext.util.Format.date(EndDatePanel_purchase.getValue(),'Y/m/d');
                var ShipNo= ShipNoPanel_purchase.getValue();
                var ReturnStatus = ReturnStatusPanel_purchase.getValue();
                //�Ѿ������ĵ���
                var BillStatus = 1;//BillStatusPanel_purchase.getValue();
                
                userGridData_purchase.baseParams.WhId = WhId;
                userGridData_purchase.baseParams.SupplierName = SupplierId;
                userGridData_purchase.baseParams.StartDate = StartDate;
                userGridData_purchase.baseParams.EndDate = EndDate;
                userGridData_purchase.baseParams.ShipNo = ShipNo;
                userGridData_purchase.baseParams.BillStatus = BillStatus;
                userGridData_purchase.baseParams.ReturnStatus = ReturnStatus;
                
                userGridData_purchase.load({
                    params: {
                        start: 0,
                        limit: 10
                    }
                });

            }
            /*------��ʼ��ѯform�ĺ��� start---------------*/

            var SupplierNamePanel_purchase = new Ext.form.TextField({              
                name: 'supplierCombo',
                fieldLabel: '��Ӧ��',
                anchor: '90%',
                listeners: { specialkey: function(f, e) { if (e.getKey() == e.ENTER) { Ext.getCmp('SWhName_purchase').focus(); } } }

            });


            var WhNamePanel_purchase = new Ext.form.ComboBox({
                name: 'warehouseCombo',
                store: dsWarehouseList,
                displayField: 'WhName',
                valueField: 'WhId',
                typeAhead: true, //�Զ�����һ����������ѡ�ȫ����
                triggerAction: 'all',
                emptyText: '��ѡ��ֿ�',
                selectOnFocus: true,
                forceSelection: true,
                mode: 'local',
                fieldLabel: '�ֿ�����',
                anchor: '90%',
                id: 'SWhName_purchase',
                listeners: { specialkey: function(f, e) { if (e.getKey() == e.ENTER) { Ext.getCmp('ReturnStatus_purchase').focus(); } } }
            });

            var ReturnStatusPanel_purchase = new Ext.form.ComboBox({
                name: 'returnStatusCombo',
                store: dsReturnStatus,
                displayField: 'ReturnStatusName',
                valueField: 'ReturnStatusId',
                typeAhead: true, //�Զ�����һ����������ѡ�ȫ����
                triggerAction: 'all',
                value: 0, //δ���
                selectOnFocus: true,
                forceSelection: true,
                editable: false,
                mode: 'local',
                fieldLabel: '�˻�״̬',
                anchor: '98%',
                id: 'ReturnStatus_purchase',
                listeners: { specialkey: function(f, e) { if (e.getKey() == e.ENTER) { Ext.getCmp('StartDate_purchase').focus(); } } }
            });
            var StartDatePanel_purchase = new Ext.form.DateField({
                style: 'margin-left:0px',
                cls: 'key',
                xtype: 'datefield',
                fieldLabel: '��ʼʱ��',
                format: 'Y��m��d��',
                anchor: '90%',
                value: new Date().getFirstDateOfMonth().clearTime(),
                id: 'StartDate_purchase',
                listeners: { specialkey: function(f, e) { if (e.getKey() == e.ENTER) { Ext.getCmp('EndDate_purchase').focus(); } } }
            });
            var EndDatePanel_purchase = new Ext.form.DateField({
                style: 'margin-left:0px',
                cls: 'key',
                xtype: 'datefield',
                fieldLabel: '����ʱ��',
                anchor: '90%',
                format: 'Y��m��d��',
                id: 'EndDate_purchase',
                value: new Date().clearTime(),
                listeners: { specialkey: function(f, e) { if (e.getKey() == e.ENTER) { Ext.getCmp('ShipNo_purchase').focus(); } } }
            });
            var ShipNoPanel_purchase = new Ext.form.TextField({              
                name: 'ShipNo_purchase',
                fieldLabel: '������',
                anchor: '98%',
                listeners: { specialkey: function(f, e) { if (e.getKey() == e.ENTER) { Ext.getCmp('searchebtnId_purchase').focus(); } } }

            });
            var serchform_purchase = new Ext.FormPanel({
                region: 'north',
                labelAlign: 'left',
                buttonAlign: 'right',
                bodyStyle: 'padding:5px',
                frame: true,
                labelWidth: 55,
                height: 70,
                items: [{
                    layout: 'column',   //�����Ԫ��Ϊ����Ϊ�в��ַ�ʽ
                    border: false,
                    items: [{
                        columnWidth: .3,  //����ռ�õĿ�ȣ���ʶΪ20��
                        layout: 'form',
                        border: false,
                        items: [
                            SupplierNamePanel_purchase
                    ]
                    }, {
                        columnWidth: .3,
                        layout: 'form',
                        border: false,
                        items: [
                            WhNamePanel_purchase
                        ]
                    }, {
                        columnWidth: .25,
                        layout: 'form',
                        border: false,
                        items: [
                            ReturnStatusPanel_purchase
                        ]
                    }
                    ]
                }
                    ,
                    {

                        layout: 'column',   //�����Ԫ��Ϊ����Ϊ�в��ַ�ʽ
                        border: false,
                        items: [{
                            columnWidth: .3,  //����ռ�õĿ�ȣ���ʶΪ20��
                            layout: 'form',
                            border: false,
                            items: [
                            StartDatePanel_purchase
                    ]
                        }, {
                            columnWidth: .3,
                            layout: 'form',
                            border: false,
                            items: [
                            EndDatePanel_purchase
                        ]
                        }, {
                            columnWidth: .25,
                            layout: 'form',
                            border: false,
                            items: [
                            ShipNoPanel_purchase
                        ]
                        }, {
                            columnWidth: .15,
                            layout: 'form',
                            border: false,
                            items: [{ cls: 'key',
                                xtype: 'button',
                                text: '��ѯ',
                                id: 'searchebtnId_purchase',
                                anchor: '70%',
                                handler: function() {
                                    updateDataGrid_purchase();
                                }
}]
}]
}]
            });


            /*------��ʼ��ѯform�ĺ��� end---------------*/

            /*------��ʼ��ȡ���ݵĺ��� start---------------*/
            var userGridData_purchase = new Ext.data.Store
            ({
                url: 'frmReturnPurchaseOrderList.aspx?method=getPurchaseOrderList',
                reader: new Ext.data.JsonReader({
                    totalProperty: 'totalProperty',
                    root: 'root'
                }, [
	                {
	                    name: 'OrderId'
	                },
	                {
	                    name: 'SupplierId'
	                },
	                {
	                    name: 'WhId'
	                },
	                {
	                    name: 'OrgId'
	                },
	                {
	                    name: 'OwnerId'
	                },
	                {
	                    name: 'OperId'
	                },
	                {
	                    name: 'CreateDate'
	                },
	                {
	                    name: 'UpdateDate'
	                },
	                {
	                    name: 'BillType'
	                },
	                {
	                    name: 'FromBillId'
	                },
	                {
	                    name: 'BillStatus'
	                },
	                {
	                    name: 'CarBoatNo'
	                },
	                {
	                    name: 'Remark'
	                },
	                {
	                    name: 'SupplierName'
	                },
	                {
	                    name: 'OperName'
	                },
	                {
	                    name: 'ReturnStatus'
	                }
                ])
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
            var selectCurrentRowData = null;//ѡ��Ĳɹ�����¼����
            
            var sm = new Ext.grid.CheckboxSelectionModel({
                singleSelect: true
            });
            var userGrid_Purchase = new Ext.grid.GridPanel({
                //el: 'divOrderGrid',
                //region: 'center',
                width: '100%',
                height: '80',
                autoWidth: true,
                //autoHeight: true,
                autoScroll: true,
                layout: 'fit',
                id: '',
                store: userGridData_purchase,
                loadMask: { msg: '���ڼ������ݣ����Ժ��' },
                sm: sm,
                cm: new Ext.grid.ColumnModel([
		sm,
		new Ext.grid.RowNumberer(), //�Զ��к�
		{
		header: '������',
		dataIndex: 'OrderId',
		id: 'OrderId'
},
		{
		    header: '��Ӧ��',
		    dataIndex: 'SupplierName',
		    id: 'SupplierName'
		},
		{
		    header: '�ֿ�',
		    dataIndex: 'WhId',
		    id: 'WhId',
		    renderer: function(val, params, record) {
		        if (dsWarehouseList.getCount() == 0) {
		            dsWarehouseList.load();
		        }
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
		    header: '������',
		    dataIndex: 'OperName',
		    id: 'OperName'
		},
		{
		    header: '����ʱ��',
		    dataIndex: 'CreateDate',
		    id: 'CreateDate',
		    format: 'Y��m��d��'
		},
//		{
//		    header: '��������',
//		    dataIndex: 'BillType',
//		    id: 'BillType',
//		    renderer: function(val, params, record) {
//		        if (dsBillType.getCount() == 0) {
//		            dsBillType.load();
//		        }
//		        dsBillType.each(function(r) {
//		            if (val == r.data['DicsCode']) {
//		                val = r.data['DicsName'];
//		                return;
//		            }
//		        });
//		        return val;
//		    }
//		},
		{
		    header: '�˻�״̬',
		    dataIndex: 'ReturnStatus',
		    id: 'ReturnStatus',
		    renderer: function(val, params, record) {
		        if (dsReturnStatus.getCount() == 0) {
		            dsReturnStatus.load();
		        }
		        dsReturnStatus.each(function(r) {
		            if (val == r.data['ReturnStatusId']) {
		                val = r.data['ReturnStatusName'];
		                return;
		            }
		        });
		        return val;
		    }
		},
		{
		    header: '������',
		    dataIndex: 'CarBoatNo',
		    id: 'CarBoatNo'
		},
		{
		    header: '��ע',
		    dataIndex: 'Remark',
		    id: 'Remark'
}]),
                bbar: new Ext.PagingToolbar({
                    pageSize: 100,
                    store: userGridData_purchase,
                    displayMsg: '��ʾ��{0}����{1}����¼,��{2}��',
                    emptyMsy: 'û�м�¼',
                    displayInfo: true
                }),
                viewConfig: {
                    columnsText: '��ʾ����',
                    scrollOffset: 20,
                    sortAscText: '����',
                    sortDescText: '����',
                    forceFit: true
                },
                height: 160,
                closeAction: 'hide',
                stripeRows: true,
                loadMask: true,
                autoExpandColumn: 2,
                listeners: {
                    rowclick: function(grid, rowIndex, e) {
                        selectCurrentRowData = userGridData_purchase.getAt(rowIndex).data;
                        var oId = selectCurrentRowData.OrderId;
                        var returnStatus = selectCurrentRowData.ReturnStatus;
//                        if(parseInt(returnStatus) == 1){
//                            Ext.Msg.alert("��ʾ","�òɹ����Ѿ��˹����ˣ������ٴ��ˣ�");
//                            return;
//                        }
                        GenReturnOrderGrid(oId);
                    }
                }
            });
            //userGrid.render();
            /*------DataGrid�ĺ������� End---------------*/
            /*------�˻����ɱ༭DataGrid�ĺ�����ʼ---------------*/
            function inserNewBlankRow() {
                var rowCount = userGrid_return.getStore().getCount();
                var insertPos = parseInt(rowCount);
                var addRow = new RowPattern({
                    ProductId: '',
                    ProductCode: '',
                    ProductUnit: '',
                    ProductSpec: '',
                    ProductPrice: '',
                    RealQty: ''
                });
                userGrid_return.stopEditing();
                //����һ����
                if (insertPos > 0) {
                    var rowIndex = dsPurchaseOrderProduct.insert(insertPos, addRow);
                    userGrid_return.startEditing(insertPos, 0);
                }
                else {
                    var rowIndex = dsPurchaseOrderProduct.insert(0, addRow);
                    userGrid_return.startEditing(0, 0);
                }
            }
            function addNewBlankRow(combo, record, index) {
                var rowIndex = userGrid_return.getStore().indexOf(userGrid_return.getSelectionModel().getSelected());
                var rowCount = userGrid_return.getStore().getCount();
                if ((rowIndex == 0 && rowCount == 1) || rowIndex == rowCount - 1) {
                    inserNewBlankRow();
                }
            }
            //����ɹ�����¼Ԥ�����˻���¼
            function GenReturnOrderGrid(OrderId) {
                dsPurchaseOrderProduct.load({
                    params: {
                        start: 0,
                        limit: 100,
                        OrderId: OrderId
                    },
                    callback: function(r, options, success) {
                        if (success == true) {
                            //default 0
                            dsPurchaseOrderProduct.each(function(r) {
                                r.set('ReturnQty',0);
                            });
                            var columnCount = userGrid_return.getColumnModel().getColumnCount();
                            //alert(columnCount);
                            for (var i = 0; i < columnCount; i++) {
                                userGrid_return.getColumnModel().setEditable(i, false);
                            }
                            //�˻������ɱ༭
                            userGrid_return.getColumnModel().setEditable(columnCount-2, true);
                        }
                    }
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
                    var sm = userGrid_return.getSelectionModel().getSelected();
                    sm.set('ProductCode', record.data.ProductNo);
                    sm.set('ProductSpec', record.data.Specifications);
                    sm.set('ProductUnit', record.data.Unit);
                    sm.set('ProductId', record.data.ProductId);
                    addNewBlankRow();
                }
            });
            var cm_return = new Ext.grid.ColumnModel([
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
                    header: "�ɹ�����",
                    dataIndex: 'RealQty',
                    width: 20,
                    editor: new Ext.form.TextField({ allowBlank: false })
                 }, {
                    id: 'ReturnQty',
                    header: "�˻�����",
                    dataIndex: 'ReturnQty',
                    width: 20,
                    renderer: function(v, m) {
                        m.css = 'x-grid-back-blue';
                        return v;
                    },editor: new Ext.form.TextField({ allowBlank: false })
                }, new Extensive.grid.ItemDeleter()
            ]);
            cm_return.defaultSortable = true;

            var RowPattern = Ext.data.Record.create([
               { name: 'OrderDetailId', type: 'string' },
               { name: 'ProductId', type: 'string' },
               { name: 'ProductCode', type: 'string' },
               { name: 'ProductUnit', type: 'string' },
               { name: 'ProductSpec', type: 'string' },
               { name: 'ProductPrice', type: 'string' },
               { name: 'RealQty', type: 'string' },
               { name:'ReturnQty',type:'string'},
               { name: 'UnitId', type: 'string' }
            ]);

            var dsPurchaseOrderProduct;
            if (dsPurchaseOrderProduct == null) {
                dsPurchaseOrderProduct = new Ext.data.Store
	            ({
	                url: 'frmReturnPurchaseOrderList.aspx?method=getPurchaseOrderProductList',
	                reader: new Ext.data.JsonReader({
	                    totalProperty: 'totalProperty',
	                    root: 'root'
	                }, RowPattern)
	            });
	          
            }
            var userGrid_return = new Ext.grid.EditorGridPanel({
                //region: 'south',
                store: dsPurchaseOrderProduct,
                cm: cm_return,
                selModel: new Extensive.grid.ItemDeleter(),
                layout: 'fit',
                width: '100%',
                height: 120,
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
            var returnOrderForm = new Ext.FormPanel({
                            labelAlign: 'left',
                            buttonAlign: 'right',
                            bodyStyle: 'padding:5px',
                            frame: true,
                            labelWidth: 55, 
                            height:80,
                            items:[
                            {
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
				                            fieldLabel:'�˻�ԭ��',
				                            columnWidth:1,
				                            anchor:'90%',
				                            name:'Remark',
				                            id:'Remark'
			                            }
	                            ]
	                            }
                                        
                       
                            ]}                  
                        ]});
            //userGrid.render();
            //===============================================================
            if (typeof (uploadPurchaseOrderWindow) == "undefined") {
                uploadPurchaseOrderWindow = new Ext.Window({
                    id: 'PurchaseOrderformwindow',
                    title: '���ɲɹ��˻���'
		            , iconCls: 'upload-win'
		            , width: 750
		            , height: 500
		            , layout: 'form'
		            , plain: true
		            , modal: true
		            , constrain: true
		            , resizable: false
		            , closeAction: 'hide'
		            , autoDestroy: true
		            , items: [//serchform_purchase, userGrid_Purchase, userGrid_return
		                {       layout:'form',
                                border: false,
                                columnWidth:1,
                                items: [  serchform_purchase ]
                         },
                         {       layout:'form',
                                border: false,
                                columnWidth:1,
                                items: [  userGrid_Purchase ]
                         },
                         {       layout:'form',
                                border: false,
                                columnWidth:1,
                                items: [ returnOrderForm ]
                         },
                         {       layout:'form',
                                border: false,
                                columnWidth:1,
                                items: [  userGrid_return ]
                         }
		            ]
		            , buttons: [{
		                text: "����"
			            , handler: function() {
			            
			            /*����˻������Ƿ񳬹��˲ɹ�����*/
			            for(var i=0;i<dsPurchaseOrderProduct.data.items.length;i++)
			            {
			               if(parseFloat(dsPurchaseOrderProduct.data.items[i].data.RealQty)<
			                    parseFloat(dsPurchaseOrderProduct.data.items[i].data.ReturnQty))
			                    {
			                        alert("�˻�����̫�࣬�����ɹ����ˣ�");
			                        return;
			                    }
			            }
			            
			            
			            Ext.MessageBox.wait("�������ڱ��棬���Ժ򡭡�");
			            if(!checkUIData()) return;
		                json = "";
		                dsPurchaseOrderProduct.each(function(dsPurchaseOrderProduct) {
		                    json += Ext.util.JSON.encode(dsPurchaseOrderProduct.data) + ',';
		                });
		                json = json.substring(0, json.length - 1);
		                //alert();
		                //return;
		                Ext.Ajax.request({
		                    url: 'frmReturnPurchaseOrderList.aspx?method=saveReturnOrderInfo',
		                    method: 'POST',
		                    params: {
		                        //������
		                        WhId: selectCurrentRowData.WhId,
		                   
		                        OperId: <%=ZJSIG.UIProcess.ADM.UIAdmUser.EmployeeID(this) %>,
		                        CreateDate: new Date(),
		                        Remark: Ext.getCmp("Remark").getValue(),
		                        Status: 0,
		                        OrderId: 0,
		                        OriginBillId:selectCurrentRowData.OrderId,
		                        Type:'W0209',//�ɹ��˻�
		                        OrgId: selectCurrentRowData.OrgId,
		                        //��ϸ����
		                        DetailInfo: json
		                    },
		                    success: function(resp, opts) {
		                        Ext.MessageBox.hide();
		                        if (checkExtMessage(resp)) {
		                            updateDataGrid();
		                            uploadPurchaseOrderWindow.hide();
		                            
		                        }
		                    },
		                    failure: function(resp,opts){  Ext.MessageBox.hide();} 
		                });
			                }
			                , scope: this
		                },
		                {
		                    text: "ȡ��"
			                , handler: function() {
			                    uploadPurchaseOrderWindow.hide();
			                }
			                , scope: this
                        }]
                       
                });
            }
            uploadPurchaseOrderWindow.addListener("hide", function() {
                serchform_purchase.getForm().reset();
                userGrid_Purchase.getStore().removeAll();
                userGrid_return.getStore().removeAll();
                returnOrderForm.getForm().reset();
            });
            //inserNewBlankRow();
//UI�Ϸ��Լ��      
function checkUIData(){
    var check = true;
    
    if(selectCurrentRowData == null){
        Ext.Msg.alert("��ʾ","��ѡ���˻���¼��");
        return false;
    }
    
    var remark = Ext.getCmp("Remark").getValue().replace(/(^\s*)|(\s*$)/g,"");
    //alert(remark.length);
    if(remark.length == 0){
        Ext.Msg.alert("��ʾ","�������˻�ԭ��");
        return false;
    }
    
    return check;
}
        })
</script>

</html>
