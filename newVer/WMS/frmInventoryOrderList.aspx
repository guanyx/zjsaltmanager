<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmInventoryOrderList.aspx.cs" Inherits="WMS_frmInventoryOrderList" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html>
<head>
<title>�ֿ��̵��б�ҳ��</title><meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<link rel="stylesheet" type="text/css" href="../ext3/resources/css/ext-all.css" />
<script type="text/javascript" src="../ext3/adapter/ext/ext-base.js"></script>
<script type="text/javascript" src="../ext3/ext-all.js"></script>
<script type="text/javascript" src="../ext3/example/TabCloseMenu.js" charset="gb2312"></script>
<script type="text/javascript" src="../js/operateResp.js"></script>
<script type="text/javascript" src="../ext3/src/locale/ext-lang-zh_CN.js"></script>
</head>
<body>
<div id='toolbar'></div>
<div id='divSearchForm'></div>
<div id='divDataGrid'></div>

</body>
<%=getComboBoxStore()%>
<script type="text/javascript">
    Ext.BLANK_IMAGE_URL = "../ext3/resources/images/default/s.gif";
    Ext.onReady(function() {
        /*------ʵ��toolbar�ĺ��� start---------------*/
        var Toolbar = new Ext.Toolbar({
            renderTo: "toolbar",
            items: [{
                text: "����",
                icon: "../Theme/1/images/extjs/customer/add16.gif",
                handler: function() { openAddOrderWin(); }
            }, '-', {
                text: "�༭",
                icon: "../Theme/1/images/extjs/customer/edit16.gif",
                handler: function() { modifyOrderWin(); }
            }, '-', {
                text: "ɾ��",
                icon: "../Theme/1/images/extjs/customer/delete16.gif",
                handler: function() { deleteOrder(); }
            }, '-', {
                text: "�鿴",
                icon: "../Theme/1/images/extjs/customer/delete16.gif",
                handler: function() { lookOrderWin(); }
            }, '-', {
                text: "�ύ",
                icon: "../Theme/1/images/extjs/customer/edit16.gif",
                handler: function() { commitOrder(); }
            }, '-', {
                text: "��ӡ",
                icon: "../Theme/1/images/extjs/customer/edit16.gif",
                handler: function() {
                    printOrderById();
                }
}]
            });

            /*------����toolbar�ĺ��� end---------------*/

            function getUrl(imageUrl) {
                var index = window.location.href.toLowerCase().indexOf('/wms/');
                var tempUrl = window.location.href.substring(0, index);
                return tempUrl + "/" + imageUrl;
            }
            function printOrderById() {
                var sm = initWarehouseGrid.getSelectionModel();
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
                    url: 'frmInventoryOrderList.aspx?method=printdate',
                    method: 'POST',
                    params: {
                        OrderId: orderIds
                    },
                    success: function(resp, opts) {
                        var printData = resp.responseText;
                        var printControl = parent.parent.parent.document.getElementById("topFrame").contentWindow.getPrintControl();
                        printControl.Url = getUrl('xml');
                        printControl.MapUrl = printControl.Url + '/' + printStyleXml; //'/salePrint1.xml';
                        printControl.PrintXml = printData;
                        printControl.ColumnName = "OrderId";
                        printControl.OnlyData = printOnlyData;
                        printControl.PageWidth = printPageWidth;
                        printControl.PageHeight = printPageHeight;
                        printControl.Print();

                    },
                    failure: function(resp, opts) {  /* Ext.Msg.alert("��ʾ","����ʧ��"); */ }
                });
            }
            /*------��ʼToolBar�¼����� start---------------*//*-----����Orderʵ���ര�庯��----*/
            function openAddOrderWin() {
                uploadOrderWindow.setTitle("�����̵㵥");
                uploadOrderWindow.show();
                document.getElementById("editIFrame").src = "frmInventoryOrderEdit.aspx?id=0";

                //                if (document.getElementById("editIFrame").src.indexOf("frmInventoryOrderEdit") == -1) {
                //                    document.getElementById("editIFrame").src = "frmInventoryOrderEdit.aspx?id=0";
                //                }
                //                else {
                //                    document.getElementById("editIFrame").contentWindow.OrderId = 0;
                //                    document.getElementById("editIFrame").contentWindow.setFormValue();
                //                }
            }
            function getSelectOrderId() {

            }
            /*-----�༭Orderʵ���ര�庯��----*/
            function modifyOrderWin() {
                var sm = initWarehouseGrid.getSelectionModel();
                //��ȡѡ���������Ϣ
                var selectData = sm.getSelected();
                if (selectData == null) {
                    Ext.Msg.alert("��ʾ", "��ѡ����Ҫ�༭����Ϣ��");
                    return;
                }
                if (selectData.data.Status == 1) {
                    Ext.Msg.alert("��ʾ", "�òֿ��Ѿ���ʼ����ɣ����ܱ༭��");
                    return;
                }
                uploadOrderWindow.setTitle("�༭�̵㵥");
                uploadOrderWindow.show();
                //setFormValue(selectData.data.OrderId);
                document.getElementById("editIFrame").src = "frmInventoryOrderEdit.aspx?id=" + selectData.data.OrderId;
                //document.getElementById("editIFrame").getElementById("WhId").readOnly = true;
                //                if (document.getElementById("editIFrame").src.indexOf("frmInventoryOrderEdit") == -1) {
                //                    document.getElementById("editIFrame").src = "frmInventoryOrderEdit.aspx?id=" + selectData.data.OrderId;
                //                }
                //                else {
                //                    document.getElementById("editIFrame").contentWindow.OrderId = selectData.data.OrderId;
                //                    document.getElementById("editIFrame").contentWindow.setFormValue();
                //                }
            }
            function lookOrderWin() {
                var sm = initWarehouseGrid.getSelectionModel();
                //��ȡѡ���������Ϣ
                var selectData = sm.getSelected();
                if (selectData == null) {
                    Ext.Msg.alert("��ʾ", "��ѡ����Ҫ�鿴����Ϣ��");
                    return;
                }
                uploadOrderWindow.setTitle("�鿴�ֿ��̵㵥");
                uploadOrderWindow.show();
                document.getElementById("editIFrame").src = "frmInventoryOrderEdit.aspx?type=look&id=" + selectData.data.OrderId;
            }
            /*-----ɾ��Orderʵ�庯��----*/
            /*ɾ����Ϣ*/
            function deleteOrder() {
                var sm = initWarehouseGrid.getSelectionModel();
                //��ȡѡ���������Ϣ
                var selectData = sm.getSelected();
                //���û��ѡ�񣬾���ʾ��Ҫѡ��������Ϣ
                if (selectData == null) {
                    Ext.Msg.alert("��ʾ", "��ѡ����Ҫɾ������Ϣ��");
                    return;
                }
                if (selectData.data.Status == 1) {
                    Ext.Msg.alert("��ʾ", "���̵㵥�Ѿ��ύ������ɾ����");
                    return;
                }
                //ɾ��ǰ�ٴ������Ƿ����Ҫɾ��
                Ext.Msg.confirm("��ʾ��Ϣ", "�Ƿ����Ҫɾ��ѡ����̵㵥��Ϣ��", function callBack(id) {
                    //�ж��Ƿ�ɾ������
                    if (id == "yes") {
                        //ҳ���ύ
                        Ext.Ajax.request({
                            url: 'frmInventoryOrderList.aspx?method=deleteInventoryOrder',
                            method: 'POST',
                            params: {
                                OrderId: selectData.data.OrderId
                            },
                            success: function(resp, opts) {
                                if (checkExtMessage(resp)) {
                                    updateDataGrid();
                                }
                            }
                        });
                    }
                });
            }
            function commitOrder() {
                var sm = initWarehouseGrid.getSelectionModel();
                //��ȡѡ���������Ϣ
                var selectData = sm.getSelected();
                //���û��ѡ�񣬾���ʾ��Ҫѡ��������Ϣ
                if (selectData == null) {
                    Ext.Msg.alert("��ʾ", "��ѡ����Ҫ�ύ����Ϣ��");
                    return;
                }
                if (selectData.data.Status == 1) {
                    Ext.Msg.alert("��ʾ", "���̵㵥�Ѿ��ύ�������ظ��ύ��");
                    return;
                }
                //ɾ��ǰ�ٴ������Ƿ����Ҫɾ��
                Ext.Msg.confirm("��ʾ��Ϣ", "�Ƿ����Ҫ�ύѡ����̵㵥��Ϣ��", function callBack(id) {
                    //�ж��Ƿ�ɾ������
                    if (id == "yes") {
                        //ҳ���ύ
                        Ext.Ajax.request({
                            url: 'frmInventoryOrderList.aspx?method=commitInventoryOrder',
                            method: 'POST',
                            params: {
                                OrderId: selectData.data.OrderId
                            },
                            success: function(resp, opts) {
                                if (checkExtMessage(resp)) {
                                    updateDataGrid();
                                }
                            }
                        });
                    }
                });
            }
            function updateDataGrid() {
                var WhName = WhNamePanel.getValue();
                var StartDate = Ext.util.Format.date(StartDatePanel.getValue(),'Y/m/d');
                var EndDate = Ext.util.Format.date(EndDatePanel.getValue(),'Y/m/d');
                var Status = StatusPanel.getValue();

                inventoryOrderGridData.baseParams.IsInitBill = 1;
                inventoryOrderGridData.baseParams.WhId = WhName;
                inventoryOrderGridData.baseParams.Status = Status;
                inventoryOrderGridData.baseParams.StartDate = StartDate;
                inventoryOrderGridData.baseParams.EndDate = EndDate;
                inventoryOrderGridData.load({
                    params: {
                        start: 0,
                        limit: 10//,
                        //IsInitBill: 1,
                        //WhId: WhName,
                        //Status: Status,
                        //StartDate: StartDate,
                        //EndDate: EndDate
                    }
                });
            }


            var WhNamePanel = new Ext.form.ComboBox({
                fieldLabel: '�ֿ�����',
                name: 'warehouseCombo',
                store: dsWarehouseList,
                displayField: 'WhName',
                valueField: 'WhId',
                typeAhead: true, //�Զ�����һ����������ѡ�ȫ����
                triggerAction: 'all',
                emptyText: '��ѡ��ֿ�',
                emptyValue: '',
                selectOnFocus: true,
                forceSelection: true,
                anchor: '90%',
                mode: 'local',
                listeners: { specialkey: function(f, e) { if (e.getKey() == e.ENTER) { Ext.getCmp('Status').focus(); } } //,
                    // blur: function(field) { if (field.getRawValue() == '') { field.clearValue(); } } 
                }

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
                    }, {
                        columnWidth: .3,
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
                            }, {
                                columnWidth: .6,
                                layout: 'form',
                                border: false

}]
}]
}]
            });


            /*------��ʼ��ѯform�ĺ��� end---------------*/

            /*------��ʼ�������ݵĴ��� Start---------------*/
            if (typeof (uploadOrderWindow) == "undefined") {//�������2��windows����
                uploadOrderWindow = new Ext.Window({
                    id: 'Orderformwindow',
                    iconCls: 'upload-win'
		                        , width: 750
		                        , height: 462
		                        , layout: 'fit'
		                        , plain: true
		                        , modal: true
		                        , constrain: true
		                        , resizable: false
		                        , closeAction: 'hide'
		                        , autoDestroy: true
		                        , html: '<iframe id="editIFrame" width="100%" height="100%" border=0 src="#"></iframe>'//initWarehouseForm

                });
            }
            uploadOrderWindow.addListener("hide", function() {
                updateDataGrid();
            });


            /*------��ʼ��ȡ�������ݵĺ��� start---------------*/
            function getFormValue() {
                Ext.Ajax.request({
                    url: 'frmInitWarehouse.aspx?method=saveInitWarehouse',
                    method: 'POST',
                    params: {
                        OrderId: Ext.getCmp('OrderId').getValue(),
                        OrgId: Ext.getCmp('OrgId').getValue(),
                        WhId: Ext.getCmp('WhId').getValue(),
                        OperId: Ext.getCmp('OperId').getValue(),
                        InventoryDate: Ext.getCmp('InventoryDate').getValue(),
                        OwnerId: Ext.getCmp('OwnerId').getValue(),
                        Remark: Ext.getCmp('Remark').getValue(),
                        IsInitBill: Ext.getCmp('IsInitBill').getValue(),
                        Status: Ext.getCmp('Status').getValue(),
                        CreateDate: Ext.getCmp('CreateDate').getValue(),
                        UpdateDate: Ext.getCmp('UpdateDate').getValue()
                    },
                    success: function(resp, opts) {
                        if (checkExtMessage(resp)) {
                            //updateDataGrid();
                        }
                    }
                });
            }
            /*------������ȡ�������ݵĺ��� End---------------*/



            /*------��ʼ��ȡ���ݵĺ��� start---------------*/
            var inventoryOrderGridData = new Ext.data.Store
            ({
                url: 'frmInventoryOrderList.aspx?method=getInventoryOrderList',
                reader: new Ext.data.JsonReader({
                    totalProperty: 'totalProperty',
                    root: 'root'
                }, [
	            {
	                name: 'OrderId'
	            },
	            {
	                name: 'OrgId'
	            },
	            {
	                name: 'WhId'
	            },
	            {
	                name: 'OperId'
	            },
	            {
	                name: 'InventoryDate'
	            },
	            {
	                name: 'OwnerId'
	            },
	            {
	                name: 'Remark'
	            },
	            {
	                name: 'IsInitBill'
	            },
	            {
	                name: 'Status'
	            },
	            {
	                name: 'CreateDate'
	            },
	            {
	                name: 'UpdateDate'
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
            var initWarehouseGrid = new Ext.grid.GridPanel({
                el: 'divDataGrid',
                width: '100%',
                height: '100%',
                autoWidth: true,
                autoHeight: true,
                autoScroll: true,
                layout: 'fit',
                id: '',
                store: inventoryOrderGridData,
                loadMask: { msg: '���ڼ������ݣ����Ժ��' },
                sm: sm,
                cm: new Ext.grid.ColumnModel([
		sm,
		new Ext.grid.RowNumberer(), //�Զ��к�
		{
		header: '����ID',
		dataIndex: 'OrderId',
		id: 'OrderId',
		hidden: true
},
		{
		    header: '��֯�ɣ�',
		    dataIndex: 'OrgId',
		    id: 'OrgId',
		    hidden: true
		},
		{
		    header: '�ֿ�����',
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
		    header: '�̵�ʱ��',
		    dataIndex: 'InventoryDate',
		    id: 'InventoryDate'
		},
		{
		    header: '������',
		    dataIndex: 'OwnerId',
		    id: 'OwnerId',
		    hidden: true
		},
		{
		    header: '��ע',
		    dataIndex: 'Remark',
		    id: 'Remark'
		},
		{
		    header: '�Ƿ��ʼ��',
		    dataIndex: 'IsInitBill',
		    id: 'IsInitBill',
		    hidden: true
		},
		{
		    header: '״̬',
		    dataIndex: 'Status',
		    id: 'Status',
		    renderer: function(val) { if (val == 0) return '�ݸ�'; if (val == 1) return '���ύ'; }

}]),
                bbar: new Ext.PagingToolbar({
                    pageSize: 10,
                    store: inventoryOrderGridData,
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
            
            initWarehouseGrid.on('render', function(grid) {
                var store = grid.getStore();  // Capture the Store.  
                var view = grid.getView();    // Capture the GridView.
            initWarehouseGrid.tip = new Ext.ToolTip({
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
                              if(v==4||v==2||v==3)
                                {
                                    if(showTipRowIndex == rowIndex)
                                        return;
                                    else
                                        showTipRowIndex = rowIndex;
                                        
                                     tip.body.dom.innerHTML="���ڼ������ݡ���";
                                        //ҳ���ύ
                                        Ext.Ajax.request({
                                            url: 'frmInventoryOrderList.aspx?method=getdetailinfo',
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
                                    initWarehouseGrid.tip.hide();
                                }
                        }
                    }
                });
    });
    var showTipRowIndex =-1;
    
            initWarehouseGrid.render();
            /*------DataGrid�ĺ������� End---------------*/
            updateDataGrid();


        })
</script>

</html>

