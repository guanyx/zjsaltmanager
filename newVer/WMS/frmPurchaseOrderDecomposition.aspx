<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmPurchaseOrderDecomposition.aspx.cs" Inherits="WMS_frmPurchaseOrderDecomposition" %>

<html>
<head>
<title>�ɹ��ָ��б�ҳ��</title><meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<link rel="stylesheet" type="text/css" href="../ext3/resources/css/ext-all.css" />
<script type="text/javascript" src="../ext3/adapter/ext/ext-base.js"></script>
<script type="text/javascript" src="../ext3/ext-all.js"></script>
<script type="text/javascript" src="../ext3/example/ItemDeleter.js"></script>
<script type="text/javascript" src="../js/operateResp.js"></script>
<script type="text/javascript" src="../js/floatUtil.js"></script>
<script type="text/javascript" src="../ext3/src/locale/ext-lang-zh_CN.js"></script>
<style type="text/css">
.extensive-remove {
background-image: url(../Theme/1/images/extjs/customer/cross.gif) ! important;
}
.x-grid-back-blue { 
background: #C3D9FF; 
}
.x-date-menu {
   width: 175px;
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
    Ext.onReady(function() {
        var Direct_Type = 'Org';
        var Split_Order_Type = 'W0120';
        var SelectedShippingStatus = 0;
        var SelectRowData = null;
        /*------ʵ��toolbar�ĺ��� start---------------*/
        var Toolbar = new Ext.Toolbar({
            renderTo: "toolbar",
            items: [{
                text: "���ɲɹ���",
                icon: "../theme/1/images/extjs/customer/add16.gif",
                handler: function() { genPurchaseOrderWin(); }
              }, '-', {
                text: "ȡ��������",
                icon: "../theme/1/images/extjs/customer/cross.gif",
                handler: function() {cancelShippingOrderWin(); }
              }, '-', {
                text: "�鿴",
                icon: "../theme/1/images/extjs/customer/view16.gif",
                handler: function() {lookPurchaseOrderWin(); }
//            }, '-', {
//                text: "ֱ���ӹ�˾",
//                icon: "../theme/1/images/extjs/customer/add16.gif",
//                handler: function() {genDirectPurchaseOrderWin(); }
//             }, '-', {
//                text: "ֱ���ͻ�",
//                icon: "../theme/1/images/extjs/customer/add16.gif",
//                handler: function() {genDirectPurchaseOrderToCustomerWin(); }
            }, '-', {
                text: "ȷ�Ϸ��˵��ָ����",
                icon: "../theme/1/images/extjs/customer/add16.gif",
                handler: function() {confirmShippingOrderWin(); }
              }, '-', {
                text: "ȡ���ָ����ȷ��",
                icon: "../theme/1/images/extjs/customer/cross.gif",
                handler: function() {rollbackShippingOrderWin(); }
}]
            });

            /*------����toolbar�ĺ��� end---------------*/


            /*------��ʼToolBar�¼����� start---------------*//*-----����Orderʵ���ര�庯��----*/
            function updateDataGrid() {

                var ShippingStatus = ShippingStatusPanel.getValue();
                var SupplierName = SupplierNamePanel.getValue();
                var StartDate = Ext.util.Format.date(StartDatePanel.getValue(),'Y/m/d');
                var EndDate = Ext.util.Format.date(EndDatePanel.getValue(),'Y/m/d');
                
                userGridData.baseParams.BillType = 'W0111';
                userGridData.baseParams.ShippingStatus = ShippingStatus;
                userGridData.baseParams.SupplierName = SupplierName;
                userGridData.baseParams.StartDate = StartDate;
                userGridData.baseParams.EndDate = EndDate;

                userGridData.load({
                    params: {
                        start: 0,
                        limit: 10
                    }
                });
                
               
            }
            //���ɲɹ���
            function genPurchaseOrderWin() {
                Split_Order_Type = 'W0120';
                Direct_Type = 'Org';
                IsReader = false;
                var sm = Ext.getCmp('userGrid').getSelectionModel();
                var selectData = sm.getSelected();
                if(selectData == null){
                    Ext.Msg.alert("��ʾ", "��ѡ��һ����¼��");
                    return;
                }
                
                SelectedShippingStatus = selectData.data.ShippingStatus;
                if(SelectedShippingStatus == 1){
                    Ext.Msg.alert("��ʾ", "�ü�¼�Ѿ��ָ���ɣ�");
                    return;
                }
                SelectRowData = selectData;
                
                uploadPurchaseOrderWindow.setTitle("�ָ�ɹ���");
                uploadPurchaseOrderWindow.show();

                userGridData_shipping.load({
                    params:{
                        start:0,
                        limit:100,
                        OrderId:selectData.data.OrderId
                    }
                });
                
                 dsPurchaseOrderProduct.load({
                    params:{
                        BillType:Split_Order_Type,
                        FromBillId:selectData.data.OrderId,
                        DirectType:Direct_Type
                    }
                });
                userGrid_purchase.colModel.setHidden(11,true);
                userGrid_purchase.colModel.setHidden(12,false);
                userGrid_purchase.colModel.setHidden(14,true);
                userGrid_purchase.colModel.setHidden(15,true);
                //setFormValue(selectData);
            }
             //�鿴�ָ���
            function lookPurchaseOrderWin() {
                Split_Order_Type = 'W0120';
                Direct_Type = 'Org';
                IsReader = true;
                var sm = Ext.getCmp('userGrid').getSelectionModel();
                var selectData = sm.getSelected();
                if(selectData == null){
                    Ext.Msg.alert("��ʾ", "��ѡ��һ����¼��");
                    return;
                }
                
                SelectedShippingStatus = selectData.data.ShippingStatus;
                SelectRowData = selectData;
                
                uploadPurchaseOrderWindow.setTitle("�鿴�ָ");
                uploadPurchaseOrderWindow.show();

                userGridData_shipping.load({
                    params:{
                        start:0,
                        limit:100,
                        OrderId:selectData.data.OrderId
                    }
                });
                
                 dsPurchaseOrderProduct.load({
                    params:{
                        BillType:Split_Order_Type,
                        FromBillId:selectData.data.OrderId,
                        DirectType:Direct_Type,
                        IsReader:IsReader
                    }
                });           
                userGrid_purchase.colModel.setHidden(8,false);     
                userGrid_purchase.colModel.setHidden(11,false);
                userGrid_purchase.colModel.setHidden(12,false);
                userGrid_purchase.colModel.setHidden(14,false);
                userGrid_purchase.colModel.setHidden(15,false);
  
            }
            //����ֱ����
            function genDirectPurchaseOrderWin() {
                Split_Order_Type = 'W0112';
                Direct_Type = 'Org';
                IsReader = false;
                var sm = Ext.getCmp('userGrid').getSelectionModel();
                var selectData = sm.getSelected();
                if(selectData == null){
                    Ext.Msg.alert("��ʾ", "��ѡ��һ����¼��");
                    return;
                }
                SelectedShippingStatus = selectData.data.ShippingStatus;
                SelectRowData = selectData;
                
                uploadPurchaseOrderWindow.setTitle("�ָ�ֱ�������ӹ�˾");
                uploadPurchaseOrderWindow.show();
                
                 
                userGridData_shipping.load({
                    params:{
                        start:0,
                        limit:100,
                        OrderId:selectData.data.OrderId
                    }
                });
                
                 dsPurchaseOrderProduct.load({
                    params:{
                        BillType:Split_Order_Type,
                        FromBillId:selectData.data.OrderId,
                        DirectType:Direct_Type
                    }
                });
                userGrid_purchase.colModel.setHidden(11,false);
                userGrid_purchase.colModel.setHidden(12,true);
                userGrid_purchase.colModel.setHidden(14,true);
                userGrid_purchase.colModel.setHidden(15,false);
                //setFormValue(selectData);  
            }
            function genDirectPurchaseOrderToCustomerWin(){
                Split_Order_Type = 'W0112';
                Direct_Type = 'Customer';
                IsReader = false;
                var sm = Ext.getCmp('userGrid').getSelectionModel();
                var selectData = sm.getSelected();
                if(selectData == null){
                    Ext.Msg.alert("��ʾ", "��ѡ��һ����¼��");
                    return;
                }
                SelectedShippingStatus = selectData.data.ShippingStatus;
                SelectRowData = selectData;
                
                uploadPurchaseOrderWindow.setTitle("�ָ�ֱ�������ͻ�");
                uploadPurchaseOrderWindow.show();
                
                 
                userGridData_shipping.load({
                    params:{
                        start:0,
                        limit:100,
                        OrderId:selectData.data.OrderId
                    }
                });
                
                 dsPurchaseOrderProduct.load({
                    params:{
                        BillType:Split_Order_Type,
                        FromBillId:selectData.data.OrderId,
                        DirectType:Direct_Type
                    }
                });
                userGrid_purchase.colModel.setHidden(11,true);//�ӹ�˾
                userGrid_purchase.colModel.setHidden(12,true);//�ֿ�
                userGrid_purchase.colModel.setHidden(14,false);//�ͻ�
                userGrid_purchase.colModel.setHidden(15,false);//ֱ����
            
            }

            //ȷ�Ϸ��˵��ָ����
            function confirmShippingOrderWin() {
                var sm = Ext.getCmp('userGrid').getSelectionModel();
                //��ȡѡ���������Ϣ
                var selectData = sm.getSelected();
                //���û��ѡ�񣬾���ʾ��Ҫѡ��������Ϣ
                if (selectData == null) {
                    Ext.Msg.alert("��ʾ", "��ѡ��һ����¼��");
                    return;
                }
                if(selectData.data.ShippingStatus == 1){
                    Ext.Msg.alert("��ʾ", "�÷��˵��ѷָ���ɲ�ȷ���ˣ�����Ҫ�ٴβ�����");
                    return;
                }
                Ext.Msg.confirm("��ʾ��Ϣ", "�Ƿ����Ҫȷ�Ϸָ������", function callBack(id) {
                    if (id == "yes") {
                        //ҳ���ύ
                        Ext.Ajax.request({
                            url: 'frmPurchaseOrderDecomposition.aspx?method=confirmShippingOrder',
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
            
            //ȡ�������ɹ����ɵķ��˵���Ϣ
            function cancelShippingOrderWin() {
                var sm = Ext.getCmp('userGrid').getSelectionModel();
                //��ȡѡ���������Ϣ
                var selectData = sm.getSelected();
                //���û��ѡ�񣬾���ʾ��Ҫѡ��������Ϣ
                if (selectData == null) {
                    Ext.Msg.alert("��ʾ", "��ѡ��һ����¼��");
                    return;
                }
                if(selectData.data.ShippingStatus == 1){
                    Ext.Msg.alert("��ʾ", "�÷��˵��ѷָ���ɲ�ȷ���ˣ�������ȡ��������");
                    //return;
                }
                Ext.Msg.confirm("��ʾ��Ϣ", "�Ƿ����Ҫȡ��ȡ������", function callBack(id) {
                    if (id == "yes") {
                        //ҳ���ύ
                        Ext.Ajax.request({
                            url: 'frmPurchaseOrderDecomposition.aspx?method=cancelShipepingOrder',
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
            
            //ȡ���ָ���Ϣ
            function rollbackShippingOrderWin() {
                var sm = Ext.getCmp('userGrid').getSelectionModel();
                //��ȡѡ���������Ϣ
                var selectData = sm.getSelected();
                //���û��ѡ�񣬾���ʾ��Ҫѡ��������Ϣ
                if (selectData == null) {
                    Ext.Msg.alert("��ʾ", "��ѡ��һ����¼��");
                    return;
                }
//                if(selectData.data.ShippingStatus == 0){
//                    Ext.Msg.alert("��ʾ", "�÷��˵�δ���ָ����ȷ�ϣ�����Ҫ��ȡ��������");
//                    return;
//                }
                Ext.Msg.confirm("��ʾ��Ϣ", "�Ƿ����Ҫȡ���ָ���ɣ�", function callBack(id) {
                    if (id == "yes") {
                        //ҳ���ύ
                        Ext.Ajax.request({
                            url: 'frmPurchaseOrderDecomposition.aspx?method=rollbackShipepingOrder',
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

            /*------��ʼ��ѯform�ĺ��� start---------------*/
            
            var SupplierNamePanel = new Ext.form.TextField({
                style: 'margin-left:0px',
                cls: 'key',
                xtype: 'textfield',
                fieldLabel: '��Ӧ��',
                anchor: '90%',
                listeners: { specialkey: function(f, e) { if (e.getKey() == e.ENTER) { Ext.getCmp('ShippingStatus').focus(); } } }
            });

            var ShippingStatusPanel = new Ext.form.ComboBox({
                name: 'shippingStatusCombo',
                store: dsShippingStatusList,
                displayField: 'ShippingStatusName',
                valueField: 'ShippingStatusId',
                typeAhead: true, //�Զ�����һ����������ѡ�ȫ����
                triggerAction: 'all',
                selectOnFocus: true,
                forceSelection: true,
                mode: 'local',
                fieldLabel: '״̬',
                anchor: '90%',
                id: 'ShippingStatus',
                value:dsShippingStatusList.getRange()[0].data.ShippingStatusId,
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
                layout: 'fit',
                buttonAlign: 'right',
                bodyStyle: 'padding:5px',
                frame: true,
                labelWidth: 55,
                items: [{
                    layout: 'column',   //�����Ԫ��Ϊ����Ϊ�в��ַ�ʽ
                    border: false,
                    items: [{
                        columnWidth: .2,  //����ռ�õĿ�ȣ���ʶΪ20��
                        layout: 'form',
                        border: false,
                        items: [
                        SupplierNamePanel
                    ]
                    }, {
                        columnWidth: .2,
                        layout: 'form',
                        border: false,
                        items: [
                        ShippingStatusPanel
                        ]
                    }, {
                        columnWidth: .2,  //����ռ�õĿ�ȣ���ʶΪ20��
                        layout: 'form',
                        border: false,
                        items: [
                        StartDatePanel
                    ]
                    }, {
                        columnWidth: .2,
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
                        var userGridData = new Ext.data.Store
                        ({
                            url: 'frmPurchaseOrderDecomposition.aspx?method=getShippingOrderList',
                            reader: new Ext.data.JsonReader({
                                totalProperty: 'totalProperty',
                                root: 'root'
                                }, [{ name: 'OrderId'},
	                            { name: 'SupplierId'},
	                            { name: 'WhId'},
	                            { name: 'OrgId' },
	                            { name: 'OwnerId' },
	                            { name: 'OperId'},
	                            { name: 'CreateDate' },
	                            { name: 'UpdateDate' },
	                            { name: 'BillType' },
	                            { name: 'FromBillId' },
	                            { name: 'BillStatus' },
	                            { name: 'CarBoatNo' },
	                            { name: 'Remark' },
	                            { name: 'SupplierName'},
	                            { name: 'ShippingStatus'},
	                            { name: 'OperName' },
	                            { name: 'CustomerId' }
                            ]),
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
                            //autoWidth: true,
                            //autoHeight: true,
                            autoScroll: true,
                            layout: 'fit',
                            id: 'userGrid',
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
					width:60
                            },
		                    {
		                        header: '��Ӧ��',
		                        dataIndex: 'SupplierName',
		                        id: 'SupplierName',
					width:150
		                    },
		                    {
		                        header: '������',
		                        dataIndex: 'OperName',
		                        id: 'OperName',
					width:80
                            },
		                    {
		                        header: '����ʱ��',
		                        dataIndex: 'CreateDate',
		                        id: 'CreateDate',
		                        format: 'Y��m��d��',
					width:100
		                    },
		                    {
		                        header: '��������',
		                        dataIndex: 'BillType',
		                        id: 'BillType',
		                        renderer: function(val, params, record) {
		                            if (dsBillType.getCount() == 0) {
		                                dsBillType.load();
		                            }
		                            dsBillType.each(function(r) {
		                                if (val == r.data['DicsCode']) {
		                                    val = r.data['DicsName'];
		                                    return;
		                                }
		                            });
		                            return val;
		                        },
					width:80
                            },
		                    {
		                        header: '���˵�״̬',
		                        dataIndex: 'ShippingStatus',
		                        id: 'ShippingStatus',
		                        renderer: function(val, params, record) {
		                            if (dsShippingStatusList.getCount() == 0) {
		                                dsShippingStatusList.load();
		                            }
		                            dsShippingStatusList.each(function(r) {
		                                if (val == r.data['ShippingStatusId']) {
		                                    val = r.data['ShippingStatusName'];
		                                    return;
		                                }
		                            });
		                            return val;
		                        }
                            },
		                    {
		                        header: '������',
		                        dataIndex: 'CarBoatNo',
		                        id: 'CarBoatNo',
					width:120
		                    },
		                    {
		                        header: '��ע',
		                        dataIndex: 'Remark',
		                        id: 'Remark',
					width:150
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
                                forceFit: false
                            },
                            height: 320,
                            closeAction: 'hide',
                            stripeRows: true,
                            loadMask: true//,
                            //autoExpandColumn: 2
                        });
                        userGrid.render();
                        /*------DataGrid�ĺ������� End---------------*/
                        updateDataGrid();
 //===========================================================================================================
  //===============================================================

            /*------��ʼ��ȡ���ݵĺ��� start---------------*/
            var userGridData_shipping = new Ext.data.Store
            ({
                url: 'frmPurchaseOrderDecomposition.aspx?method=getShippingOrderDetailList',
                reader: new Ext.data.JsonReader({
                    totalProperty: 'totalProperty',
                    root: 'root'
                }, 
                [
                    {name: 'OrderDetailId'},
	                {name: 'OrderId'},
	                {name: 'ProductId'},
	                {name: 'ProductName'},
	                {name: 'ProductUnit'},
	                {name: 'ProductSpec'},
	                {name: 'ProductCode'},
	                {name: 'ProductPrice',type:'float'},
	                {name: 'BookQty',type:'float'},
	                {name: 'RealQty',type:'float'},
	                {name: 'WhId'},
	                {name: 'remark'},
	                {name: 'CarBoatNo'},
	                {name: 'SupplierId'},
	                {name: 'BillType'},
	                {name: 'FromBillId'},
	                {name: 'BillStatus'},
	                {name:'BookWeight'},
	                {name:'RealWeight'},
	                {name:'UnitId'},
	                {name:'SalePrice',type:'float'}
                ]),
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
            var userGrid_shipping = new Ext.grid.GridPanel({
                width: '100%',
                autoWidth: true,
                autoScroll: true,
                layout: 'fit',
                id: '',
                store: userGridData_shipping,
                loadMask: { msg: '���ڼ������ݣ����Ժ��' },
                sm: sm,
                cm: new Ext.grid.ColumnModel([
		        sm,
		        new Ext.grid.RowNumberer(), //�Զ��к�
		        {
		            header: '���',
		            dataIndex: 'OrderDetailId',
		            id: 'OrderDetailId',
		            hidden:true
                },
		        {
		            header: '����',
		            dataIndex: 'ProductCode',
		            id: 'ProductCode'
		        },
		        {
		            header: '��Ʒ����',
		            dataIndex: 'ProductName',
		            id: 'ProductName'
		        },
		        {
		            header: '��λ',
		            dataIndex: 'UnitId',
		            id: 'UnitId',
		            renderer: function(value, cellmeta, record, rowIndex, columnIndex, store) {
		                var index = dsProductUnitList.findBy(function(record, id) {  
	                        return record.get(productUnitCombo.valueField)==value; 
                        });
                        
                        //var index = dsProductUnitList.find(productUnitCombo.valueField, value);

                        var record = dsProductUnitList.getAt(index);
                        var displayText = "";
                        if (record == null) {
                            displayText = value;
                        } else {
                            displayText = record.data.UnitName; 
                        }
                        return displayText;
                    }
		        },
		        {
		            header: '���',
		            dataIndex: 'ProductSpec',
		            id: 'ProductSpec',
		            renderer: function(value, cellmeta, record, rowIndex, columnIndex, store) {
                        var index = dsProductSpecList.findBy(function(record, id) {  
	                        return record.get(productSpecCombo.valueField)==value; 
                        });
                        //var index = dsProductSpecList.find(productSpecCombo.valueField, value);
                        var record = dsProductSpecList.getAt(index);
                        var displayText = "";
                        if (record == null) {
                            displayText = value;
                        } else {
                            displayText = record.data.DicsName; 
                        }
                        return displayText;
                    }
		        },
		        {
		            header: '�۸�',
		            type:'float',
		            dataIndex: 'SalePrice',
		            id: 'SalePrice'
		        },
		         {
		            header: '��������',
		            type:'float',
		            dataIndex: 'RealWeight',
		            id: 'RealWeight'
		        },
		        {
		            header: '��������',
		            type:'float',
		            dataIndex: 'BookQty',
		            id: 'BookQty'
		        },
		        {
		            header: '�ɷ�������',
		            type:'float',
		            dataIndex: 'RealQty',
		            id: 'RealQty'
		        }]),
                viewConfig: {
                    columnsText: '��ʾ����',
                    scrollOffset: 20,
                    sortAscText: '����',
                    sortDescText: '����',
                    forceFit: true
                },
                height: 150,
                closeAction: 'hide',
                stripeRows: true,
                loadMask: true,
                autoExpandColumn: 2,
                listeners: {
                    rowclick: function(grid, rowIndex, e) {
 			if(uploadPurchaseOrderWindow.title=='�鿴�ָ') return;
                        var curRowData = userGridData_shipping.getAt(rowIndex).data;
                        inserNewBlankRow(curRowData);
                    }
                }
            });
            //userGrid.render();
            /*------DataGrid�ĺ������� End---------------*/
            /*------�˻����ɱ༭DataGrid�ĺ�����ʼ---------------*/
            function inserNewBlankRow(curRowData) {
                var rowCount = userGrid_purchase.getStore().getCount();
                var insertPos = parseInt(rowCount);
                
                var addRow;
                if(Split_Order_Type == 'W0120'){
                    addRow = new RowPattern({
                        ProductId: curRowData.ProductId,
                        ProductCode: curRowData.ProductCode,
                        ProductName: curRowData.ProductName,
                        ProductUnit: curRowData.ProductUnit,
                        ProductSpec: curRowData.ProductSpec,
                        ProductPrice: curRowData.ProductPrice,
                        BookQty: curRowData.RealQty,
                        UnitId:curRowData.UnitId,
                        RealQty:0,
                        SupplierId:SelectRowData.data.SupplierId,//Ext.getCmp("SupplierId").getValue(),
                        CarBoatNo:SelectRowData.data.CarBoatNo,//Ext.getCmp("CarBoatNo").getValue(),
                        BillType:Split_Order_Type,
                        FromBillId:curRowData.OrderId,
                        BillStatus:0,
                        ShippingStatus:0,
                        OrgId:<%=ZJSIG.UIProcess.ADM.UIAdmUser.OrgID(this) %>,
                        OperId:<%=ZJSIG.UIProcess.ADM.UIAdmUser.EmployeeID(this) %>,
                        OwnerId:<%=ZJSIG.UIProcess.ADM.UIAdmUser.EmployeeID(this) %>,
                        Remark:'',
                        CreateDate:new Date(),
                        UpdateDate:new Date(),
                        CustomerId:0
                    });
                }
                else{
                    addRow = new RowPattern({
                        ProductId: curRowData.ProductId,
                        ProductCode: curRowData.ProductCode,
                        ProductCode: curRowData.ProductCode,
                        ProductUnit: curRowData.ProductUnit,
                        ProductSpec: curRowData.ProductSpec,
                        ProductPrice: curRowData.SalePrice,
                        SalePrice:curRowData.SalePrice,
                        BookQty: curRowData.RealQty,
                        UnitId:curRowData.UnitId,
                        RealQty:0,
                        SupplierId:SelectRowData.data.SupplierId,//Ext.getCmp("SupplierId").getValue(),
                        CarBoatNo:SelectRowData.data.CarBoatNo,//Ext.getCmp("CarBoatNo").getValue(),
                        BillType:Split_Order_Type,
                        FromBillId:curRowData.OrderId,
                        BillStatus:0,
                        ShippingStatus:-1,//��Ϊֱ������ʵ�ͷ��˵���ͳһ�ģ�����������ԭ����0��Ϊ-1
                        //OrgId:<%=ZJSIG.UIProcess.ADM.UIAdmUser.OrgID(this) %>,
                        OperId:<%=ZJSIG.UIProcess.ADM.UIAdmUser.EmployeeID(this) %>,
                        OwnerId:<%=ZJSIG.UIProcess.ADM.UIAdmUser.EmployeeID(this) %>,
                        Remark:'',
                        CreateDate:new Date(),
                        UpdateDate:new Date(),
                        WhId:0
                    });
                }
                userGrid_purchase.stopEditing();
                //����һ����
                if (insertPos > 0) {
                    var rowIndex = dsPurchaseOrderProduct.insert(insertPos, addRow);
                    userGrid_purchase.startEditing(insertPos, 0);
                }
                else {
                    var rowIndex = dsPurchaseOrderProduct.insert(0, addRow);
                    userGrid_purchase.startEditing(0, 0);
                }
            }
            //���÷ָ��Ĳɹ�grid�ɱ༭��
            function setGridStatus() {
                var columnCount = userGrid_purchase.getColumnModel().getColumnCount();
                
                for (var i = 0; i < columnCount-11; i++) {
                    userGrid_purchase.getColumnModel().setEditable(i, false);
                }
                
            }
//            var orgCombo = new Ext.form.ComboBox({
//                store: dsChildOrgList,
//                displayField: 'OrgName',
//                valueField: 'OrgId',
//                triggerAction: 'all',
//                id: 'orgCombo',
//                typeAhead: true,
//                mode: 'local',
//                emptyText: '',
//                selectOnFocus: false,
//                editable: false
//            });
            var warehouseCombo = new Ext.form.ComboBox({
                store: dsWarehouseList,
                displayField: 'WhName',
                valueField: 'WhId',
                triggerAction: 'all',
                id: 'warehouseCombo',
                typeAhead: true,
                mode: 'local',
                emptyText: '',
                selectOnFocus: false,
                editable: false
            });
//            var customerCombo = new Ext.form.ComboBox({
//                store: dsCustomerList,
//                displayField: 'ShortName',
//                valueField: 'CustomerId',
//                triggerAction: 'all',
//                id: 'customerCombo',
//                typeAhead: true,
//                mode: 'local',
//                emptyText: '',
//                selectOnFocus: false,
//                editable: false
//            });
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
                editable: false
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
                editable: false
            });
//            var productCombo = new Ext.form.ComboBox({
//                store: dsProductList,
//                displayField: 'ProductName',
//                valueField: 'ProductId',
//                triggerAction: 'all',
//                id: 'productCombo',
//                //pageSize: 5,
//                //minChars: 2,
//                //hideTrigger: true,
//                typeAhead: true,
//                mode: 'local',
//                emptyText: '',
//                selectOnFocus: false,
//                editable: true,
//                onSelect: function(record) {
//                    var sm = userGrid_purchase.getSelectionModel().getSelected();
//                    sm.set('ProductCode', record.data.ProductNo);
//                    sm.set('ProductSpec', record.data.Specifications);
//                    sm.set('ProductUnit', record.data.Unit);
//                    sm.set('ProductId', record.data.ProductId);
//                    
//                    //addNewBlankRow();
//                }
//            });
            var cm_purchase = new Ext.grid.ColumnModel([
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
                    width: 60,
                    editor: new Ext.form.TextField({ allowBlank: false })
                },
                {
                    id: 'ProductId',
                    header: "��Ʒ",
                    dataIndex: 'ProductId',
                    hidden: true
//                    editor: productCombo,
//                    renderer: function(value, cellmeta, record, rowIndex, columnIndex, store) {
//                        //���ֵ��ʾ����
//                        //��ȡ��ǰid="combo_process"��comboBoxѡ���ֵ
//                        var index = dsProductList.findBy(
//                            function(record, id) {
//                                return record.get(productCombo.valueField) == value;
//                            }
//                        );
//                        var record = dsProductList.getAt(index);
//                        var displayText = "";
//                        // ��������б�û�б�ѡ����ôrecordҲ�Ͳ����ڣ���ʱ�򣬷��ش�������value��
//                        // �����value����grid��USER_REALNAME�е�value������ֱ�ӷ���
//                        if (record == null) {
//                            //����Ĭ��ֵ��
//                            displayText = value;
//                        } else {
//                            displayText = record.data.ProductName; //��ȡrecord�е����ݼ��е�process_name�ֶε�ֵ
//                        }
//                        return displayText;
//                    }
                },
                {
                    id: 'ProductName',
                    header: "��Ʒ",
                    dataIndex: 'ProductName',
                    width: 150   
                },
                {
                    id: "UnitId",
                    header: "��λ",
                    dataIndex: "UnitId",
                    width: 60,
                    editor: productUnitCombo,
                    renderer: function(value, cellmeta, record, rowIndex, columnIndex, store) {
                        //���ֵ��ʾ����
                        //��ȡ��ǰid="combo_process"��comboBoxѡ���ֵ
                        var index = dsProductUnitList.findBy(function(record, id) {  
	                        return record.get(productUnitCombo.valueField)==value; 
                        });
                        //var index = dsProductUnitList.find(productUnitCombo.valueField, value);
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
                    width: 60,
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
                    width: 60,
                    renderer: function(v, m) {
                        m.css = 'x-grid-back-blue';
                        return v;
                    },
                    editor: new Ext.form.TextField({ allowBlank: false })
                 
                }, {
                    id: 'BookQty',
                    header: "��������",
                    dataIndex: 'BookQty',
                    width: 50,
                    type:'float',
                    hidden:true,
                    editor: new Ext.form.TextField({ allowBlank: false })
                 }, {
                    id: 'RealQty',
                    header: "��������",
                    dataIndex: 'RealQty',
                    width: 80,
                    type:'float',
                    renderer: function(v, m) {
                        m.css = 'x-grid-back-blue';
                        return v;
                    },editor: new Ext.form.TextField({ allowBlank: false })
                },{
                    id: 'OrgId',
                    header: "��˾",
                    dataIndex: 'OrgId',
                    hidden:true
                },{
                    id: 'OrgName',
                    header: "��˾",
                    dataIndex: 'OrgName',
                    name:'OrgName',
                    width: 100
                },{
                    id: 'WhId',
                    header: "�ɹ��ֿ�",
                    dataIndex: 'WhId',
                    name:'WhName',
                    width: 80,
                    editor:warehouseCombo,
                    renderer: function(value, cellmeta, record, rowIndex, columnIndex, store) {
                        var index = dsWarehouseList.find(warehouseCombo.valueField, value);
                        var record = dsWarehouseList.getAt(index);
                        var displayText = "";
                        if (record == null) {
                            displayText = value;
                        } else {
                            displayText = record.data.WhName; 
                        }
                        cellmeta.css = 'x-grid-back-blue';
                        return displayText;
                        
                    }
                },
                {
                    id: 'CustomerId',
                    header: "�ͻ�",
                    dataIndex: 'CustomerId',
                    name:'ShortName',
                    hidden:true
//                    width: 40,
//                    editor:customerCombo,
//                    renderer: function(value, cellmeta, record, rowIndex, columnIndex, store) {
//                        var index = dsCustomerList.find(customerCombo.valueField, value);
//                        var record = dsCustomerList.getAt(index);
//                        var displayText = "";
//                        if (record == null) {
//                            displayText = value;
//                        } else {
//                            displayText = record.data.ShortName; 
//                        }
//                        cellmeta.css = 'x-grid-back-blue';
//                        return displayText;
//                        
//                    }
                },{
                    id: 'CustomerName',
                    header: "�ͻ�",
                    dataIndex: 'CustomerName',
                    name:'CustomerName',
                    width: 100
                }, {
                    id: 'SalePrice',
                    header: "ֱ���۸�",
                    dataIndex: 'SalePrice',
                    width: 60
                },{
                    id: 'DetailRemark',
                    header: "��ע",
                    dataIndex: 'DetailRemark',
                    width: 120,
                    renderer: function(v, m) {
                        m.css = 'x-grid-back-blue';
                        return v;
                    },editor: new Ext.form.TextArea({ allowBlank: false })
                }, new Extensive.grid.ItemDeleter()
            ]);
            cm_purchase.defaultSortable = true;
            

            var RowPattern = Ext.data.Record.create([
               { name: 'OrderDetailId', type: 'string' },
               { name: 'ProductId', type: 'string' },
               { name: 'ProductCode', type: 'string' },
               { name: 'ProductName', type: 'string' },
               { name: 'ProductUnit', type: 'string' },
               { name: 'ProductSpec', type: 'string' },
               { name: 'ProductPrice', type: 'float' },
               { name: 'RealQty', type: 'float' },
               { name: 'WhId',type:'string'},
               { name: 'BookQty',type:'float'},
               { name: 'SupplierId',type:'string'},
               { name: 'SupplierName',type:'string'},
               { name: 'CarBoatNo',type:'string'},
               { name: 'BillType',type:'string'},
               { name: 'FromBillId',type:'string'},
               { name: 'BillStatus',type:'string'},
               { name: 'ShippingStatus',type:'string'},
               { name: 'OrgId',type:'string'},
               { name: 'OrgName',type:'string'},
               { name: 'OperId',type:'string'},
               { name: 'OwnerId',type:'string'},
               { name: 'Remark',type:'string'},
               { name: 'CreateDate',type:'string'},
               { name: 'OrderId',type:'string'},
               { name: 'DetailRemark',type:'string'},
               { name: 'SalePrice', type:'string'},
               { name: 'UnitId', type:'string'},
               { name: 'CustomerId', type:'string'},
               { name: 'CustomerName', type:'string'}
            ]);

            var dsPurchaseOrderProduct;
            if (dsPurchaseOrderProduct == null) {
                dsPurchaseOrderProduct = new Ext.data.Store
	            ({
	                url: 'frmPurchaseOrderDecomposition.aspx?method=getPurchaseOrderProductByShippingId',
	                reader: new Ext.data.JsonReader({
	                    totalProperty: 'totalProperty',
	                    root: 'root'
	                }, RowPattern)
	            });
	          
            }
            var userGrid_purchase = new Ext.grid.EditorGridPanel({
                //region: 'south',
                store: dsPurchaseOrderProduct,
                cm: cm_purchase,
                selModel: new Extensive.grid.ItemDeleter(),
                layout: 'fit',
                width: '100%',
                autoScroll: true,
                height: 210,
                stripeRows: true,
                frame: true,
                clicksToEdit: 1,
                viewConfig: {
                    columnsText: '��ʾ����',
                    scrollOffset: 20,
                    sortAscText: '����',
                    sortDescText: '����',
                    forceFit: false
                }
            });
          
            //===============================================================
            if (typeof (uploadPurchaseOrderWindow) == "undefined") {
                uploadPurchaseOrderWindow = new Ext.Window({
                    id: 'PurchaseOrderformwindow'
		            , iconCls: 'upload-win'
		            , width: 780
		            , height: 440
		            , layout: 'form'
		            , plain: true
		            , modal: true
		            , constrain: true
		            , resizable: false
		            , closeAction: 'hide'
		            , autoDestroy: true
		            , items: [
                         {       layout:'form',
                                border: false,
                                columnWidth:1,
                                items: [  userGrid_shipping ]
                         },
                         {       layout:'form',
                                border: false,
                                columnWidth:1,
                                items: [  userGrid_purchase ]
                         }
		            ]
		            , buttons: [{
		                text: "����"
		                ,id:"btnSave"
			            , handler: function() {       
			                if(!checkUIData()) return;//�������
		                    var json = "";
		                    dsPurchaseOrderProduct.each(function(dsPurchaseOrderProduct) {
		                        var curData = dsPurchaseOrderProduct.data;
		                        json += Ext.util.JSON.encode(curData) + ',';
		                    });
		                    json = json.substring(0, json.length - 1);
    		                
		                   // alert(json);//return;

		                    Ext.Ajax.request({
		                        url: 'frmPurchaseOrderDecomposition.aspx?method=savePurchaseOrderInfo',
		                        method: 'POST',
		                        params: {
		                            DetailInfo: json
		                        },
		                        success: function(resp, opts) {
		                            if (checkExtMessage(resp)) {
		                                updateDataGrid();
		                                uploadPurchaseOrderWindow.hide();
    		                            
		                            }
		                        }
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
                //shippingOrderForm.getForm().reset();
                userGrid_shipping.getStore().removeAll();
                userGrid_purchase.getStore().removeAll();
                //purchaseOrderForm.getForm().reset();
            });
            uploadPurchaseOrderWindow.addListener("show",function(){
            //alert(SelectedShippingStatus);
                if(SelectedShippingStatus == 1 || IsReader == true){
                    Ext.getCmp("btnSave").hide();
                }
                else{
                    Ext.getCmp("btnSave").show();
                }
            });
            
            //�����ָGrid�����¼�
            userGrid_purchase.on({
                beforeedit:function(o){
                    if(o.field != 'RealQty')
                        return;
                    beforeQty = parseFloat(o.value); 
                },
                afteredit:function(o){
                    if(o.field != 'RealQty')
                        return;
                    caculationQty(o.record);
                },
               cellclick:function(grid, rowIndex, columnIndex, e){
                    if(columnIndex==grid.getColumnModel().getIndexById('deleter')) {
		                //if(grid.getSelectionModel().hasNext()){//���һ�в�����ɾ��
			                var record = grid.getStore().getAt(rowIndex);		
			                grid.getStore().remove(record);
			                grid.getView().refresh();
			                //caculate start
			                beforeQty = undefined;
			                caculationQty(record);
			                //caculate end	
			            //}    
		            }
               }
            });
            //������Ʒ�ɷ�������
            function caculationQty(trecord){
                var hasQty = 0;
                var index = userGrid_shipping.store.findBy(function(record, id) {  
		             return record.get('ProductId') == trecord.get('ProductId'); 
	               });	
	            if(index == -1) return; 
	            
	             var nrecord = userGrid_shipping.store.getAt(index); 
	             var afterQty = parseFloat(trecord.get('RealQty'));
	             
	             if(afterQty < 0){
	                Ext.Msg.alert("��ʾ","������������Ϊ������");
                    trecord.set('RealQty',beforeQty);
                    return;
	             }
                if(beforeQty == undefined){//ɾ����¼
                    hasQty = hasQty.add(nrecord.get('RealQty')).add(afterQty);
                }
                else{//���������޸�
	                hasQty = hasQty.add(nrecord.get('RealQty')).add(beforeQty).sub(afterQty);
	             }
	             if(hasQty<0){
	                Ext.Msg.alert("��ʾ","�ܷ����������˷���������");
                    trecord.set('RealQty',beforeQty);
                    return;
	             }
	             nrecord.set('RealQty',parseFloat(hasQty));

                nrecord.commit();
           }
            function caculation(trecord){
                var hasQty = 0;
                userGrid_purchase.store.each(function(record) {
                    if(record.get('ProductId') == trecord.get('ProductId')){
                        hasQty =hasQty.add(record.get('RealQty'));
                    }
                });
                var index = userGrid_shipping.store.findBy(function(record, id) {  
		             return record.get('ProductId') == trecord.get('ProductId'); 
	               });		  
	            if(index == -1) return ; 
                var nrecord = userGrid_shipping.store.getAt(index); 
                
                if(nrecord.get('BookQty').sub(hasQty) < 0)
                {  
                    Ext.Msg.alert("��ʾ","�ܷ����������˽���������");
                    trecord.set('RealQty',beforeQty);
                    return;
                }    
                nrecord.set('RealQty',nrecord.get('BookQty').sub(hasQty));
                nrecord.commit();
            }
            //��������ǰ
            function checkUIData(){
                var check = true;
                dsPurchaseOrderProduct.each(function(record){
                    if(Split_Order_Type == "W0120"){
                        if(record.get("WhId") == undefined){
                            Ext.Msg.alert("��ʾ", "����вֿ�û��ѡ��");
                            check = false;
                            return;
                        }
                    }
                    else{
                        if(Direct_Type == 'Org'){
                            if(record.get("OrgId") == undefined){
                                Ext.Msg.alert("��ʾ", "������ӹ�˾û��ѡ��");
                                check = false;
                                return;
                            }
                        }
                        else{
                            if(record.get("CustomerId") == undefined){
                                Ext.Msg.alert("��ʾ", "����пͻ�û��ѡ��");
                                check = false;
                                return;
                            }
                        }
                    }
                    if(record.get("RealQty") == undefined || parseFloat(record.get("RealQty"))<=0){
                        Ext.Msg.alert("��ʾ", "����з�������û����д��");
                        check = false;
                        return;
                    }
                });
                if(dsPurchaseOrderProduct.getCount() == 0){
                    Ext.Msg.alert("��ʾ","����ǰ��ѡ������Ʒ��");
                    return false;
                }
                return check;
            }
            setGridStatus();

    })
</script>

</html>
