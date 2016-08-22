<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmDrawInvCtrl.aspx.cs" Inherits="SCM_frmDrawInvCtrl" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>���͵���</title>
<link rel="stylesheet" type="text/css" href="../ext3/resources/css/ext-all.css" />
<script type="text/javascript" src="../ext3/adapter/ext/ext-base.js"></script>
<script type="text/javascript" src="../ext3/ext-all.js"></script>
<script type="text/javascript" src="../js/operateResp.js"></script>
<script type="text/javascript" src="../ext3/src/locale/ext-lang-zh_CN.js"></script>
<style type="text/css">
.x-grid-back-blue { 
background: #B7CBE8; 
}
.x-date-menu {
   width: 175px;
}
</style>
</head>
<body>    

    <div id="searchForm"></div>
    <div id="deliveryForm"></div>
    <div id="DrawInvGrid"></div>
    <div id="stockGridDiv"></div>
</body>

<!-- ��������Դ��ӡ������ -->
<%= getComboBoxStore() %>

<script type="text/javascript">
Ext.BLANK_IMAGE_URL = "../ext3/resources/images/default/s.gif";  //��Ϊ���������������������ͼƬ��ʾ
Ext.onReady(function() {


    //������б�
    function QueryDataGrid() {
        Ext.getCmp('OutStor').setValue(Ext.getCmp('OutStorSearch').getValue());
        DrawInvGridData.baseParams.CustomerId = Ext.getCmp('CustomerId').getValue();
        DrawInvGridData.baseParams.StartDate = Ext.util.Format.date(Ext.getCmp('StartDate').getValue(), 'Y/m/d');
        DrawInvGridData.baseParams.EndDate = Ext.util.Format.date(Ext.getCmp('EndDate').getValue(), 'Y/m/d');
        DrawInvGridData.baseParams.OutStore = Ext.getCmp('OutStorSearch').getValue();
        DrawInvGridData.load({
            params: {
                start: 0,
                limit: 30
            }
        });
    }

    //����
    function saveUpdate() {
        var sm = DrawInvGrid.getSelectionModel();
        //��ѡ
        var selectData = sm.getSelections();
        var array = new Array(selectData.length);
        for (var i = 0; i < selectData.length; i++) {
            array[i] = selectData[i].get('DrawInvId');
        }

        //���û��ѡ�񣬾���ʾ��Ҫѡ��������Ϣ
        if (selectData == null || selectData == "") {
            Ext.Msg.alert("��ʾ", "��ѡ����Ҫ����������ļ�¼��");
            return;
        }
        //�������ǰ̨�ж�
        var carcode = Ext.getCmp('VehicleId').getValue()
        if (carcode == null || carcode == "") {
            Ext.Msg.alert("��ʾ", "��ѡ���ͻ�����!");
            return;
        }
        var DriverId = Ext.getCmp('DriverId').getValue()
        if (DriverId == null || DriverId == "") {
            Ext.Msg.alert("��ʾ", "��ѡ���ʻԱ��");
            return;
        }
        Ext.Msg.wait("������....", "��ʾ");
        //ҳ���ύ
        Ext.Ajax.request({
            url: 'frmDrawInvCtrl.aspx?method=saveUpdate',
            method: 'POST',
            params: {
                DrawInvId: array.join('-'), //��������id��
                VehicleId: Ext.getCmp('VehicleId').getValue(),
                DriverId: Ext.getCmp('DriverId').getValue(),
                DlverId: Ext.getCmp('deliveryer').getValue(),
                OutStor: Ext.getCmp('OutStor').getValue(),
                DlvDate: Ext.getCmp('deliverydate').getValue().dateFormat('Y/m/d')
            },
            success: function(resp, opts) {
                Ext.Msg.hide();
                if (checkExtMessage(resp)) {
                    //Ext.Msg.alert("��ʾ", "�������ɳɹ���");
                    DrawInvGrid.getStore().reload();
                }

            },
            failure: function(resp, opts) {
                Ext.Msg.hide();
                Ext.Msg.alert("��ʾ", "��������ʧ�ܣ�");
            }
        });


    }



    /*-----------------------��ѯ����start------------------------*/
    var searchForm = new Ext.form.FormPanel({
        renderTo: 'searchForm',
        frame: true,
        buttonAlign: 'center',
        items: [
            {//��һ��
                layout: 'column',
                items: [
                    {//�ڶ���Ԫ��
                        layout: 'form',
                        border: false,
                        labelWidth: 70,
                        columnWidth: .4,
                        items: [{
                            xtype: 'datefield',
                            fieldLabel: '��ʼ����',
                            anchor: '95%',
                            id: 'StartDate',
                            name: 'StartDate',
                            format: 'Y��m��d��',
                            value: new Date().getFirstDateOfMonth().clearTime(),
                            editable: false
}]
                        },
                    {//������Ԫ��
                        layout: 'form',
                        border: false,
                        labelWidth: 70,
                        columnWidth: .4,
                        items: [{
                            xtype: 'datefield',
                            fieldLabel: '��������',
                            anchor: '95%',
                            id: 'EndDate',
                            name: 'EndDate',
                            format: 'Y��m��d��',
                            value: new Date().clearTime(),
                            editable: false
}]
                        },
                    {//���ĵ�Ԫ��
                        layout: 'form',
                        border: false,
                        labelWidth: 70,
                        columnWidth: .1,
                        items: [{
                            xtype: 'button',
                            text: '��ѯ',
                            width: 70,
                            //iconCls:'excelIcon',
                            scope: this,
                            handler: function() {
                                QueryDataGrid();
                            }
}]
                        }
                ]
            }, {//��һ��
                layout: 'column',
                items: [{//��һ��Ԫ��
                    layout: 'form',
                    border: false,
                    labelWidth: 70,
                    columnWidth: .4,
                    items: [{
                        xtype: 'textfield',
                        fieldLabel: '�ͻ����',
                        anchor: '95%',
                        id: 'CustomerId',
                        name: 'CustomerId'
}]
                    },
                    {//��һ��Ԫ��
                        layout: 'form',
                        border: false,
                        labelWidth: 70,
                        columnWidth: .4,
                        items: [{
                            xtype: 'combo',
                            store: dsWareHouse,
                            valueField: 'WhId',
                            displayField: 'WhName',
                            mode: 'local',
                            forceSelection: true,
                            editable: false,
                            name: 'OutStorSearch',
                            id: 'OutStorSearch',
                            emptyValue: '',
                            triggerAction: 'all',
                            fieldLabel: '����ֿ�',
                            selectOnFocus: true,
                            anchor: '95%',
                            editable: false
}]}]
                        }
        ]
    });
    /*-----------------------��ѯ����end------------------------*/

    /*-----------------------������Ϣ����start------------------------*/
    //��λ����Դ
    var dsVehicle;
    if (dsVehicle == null) { //��ֹ�ظ�����
        dsVehicle = new Ext.data.Store
        ({
            url: 'frmDrawInvCtrl.aspx?method=getVehicle',
            reader: new Ext.data.JsonReader({
                totalProperty: 'totalProperty',
                root: 'root'
            }, [{name: 'VehicleId'},
                {name: 'VehicleName'}
            ])
        });
    }
    dsVehicle.load();
    var deliveryForm = new Ext.form.FormPanel({
        renderTo: 'deliveryForm',
        frame: true,
        title: '������Ϣ¼��',
        items: [
            {
                layout: 'column',
                items: [
                {
                    layout: 'form',
                    border: false,
                    labelWidth: 80,
                    columnWidth: .33,
                    items: [
                    {
                        xtype: 'combo',
                        store: dsWareHouse,
                        valueField: 'WhId',
                        displayField: 'WhName',
                        mode: 'local',
                        forceSelection: true,
                        editable: false,
                        name: 'OutStor',
                        id: 'OutStor',
                        emptyValue: '',
                        triggerAction: 'all',
                        fieldLabel: '����ֿ�',
                        selectOnFocus: true,
                        anchor: '95%',
                        editable: false
}]
                    },
          		{
          		    layout: 'form',
          		    border: false,
          		    labelWidth: 55,
          		    columnWidth: .33,
          		    items: [
                    {
                        xtype: 'datefield',
                        fieldLabel: '�ͻ�����',
                        anchor: '95%',
                        id: 'deliverydate',
                        name: 'deliverydate',
                        format: 'Y��m��d��',
                        value: new Date().clearTime(),
                        editable: false
}]
          		},
                {
                    layout: 'form',
                    border: false,
                    labelWidth: 55,
                    columnWidth: .33,
                    items: [
                    {
                        xtype: 'button',
                        text: '����',
                        width: 70,
                        //iconCls:'excelIcon', 
                        scope: this,
                        handler: function() {
                            saveUpdate()
                        }
}]
                    }
                ]
                },
            {
                layout: 'column',
                items: [
                {
                    layout: 'form',
                    border: false,
                    labelWidth: 80,
                    columnWidth: .33,
                    items: [
                    {
                        xtype: 'combo',
                        fieldLabel: '�ͻ�����',
                        anchor: '95%',
                        id: 'VehicleId',
                        name: 'VehicleId',
                        store: dsVehicle,
                        triggerAction: 'all',
                        mode: 'local',
                        displayField: 'VehicleName',
                        valueField: 'VehicleId',
                        editable: false
}]
                    },
                {
                    layout: 'form',
                    border: false,
                    labelWidth: 55,
                    columnWidth: .33,
                    items: [
                    {
                        xtype: 'combo',
                        fieldLabel: '��ʻԱ',
                        anchor: '95%',
                        id: 'DriverId',
                        name: 'DriverId',
                        store: dsDriver,
                        triggerAction: 'all',
                        mode: 'local',
                        displayField: 'DriverName',
                        valueField: 'DriverId',
                        editable: false,
                        listeners: {
                            select: function(combo, record, index) {
                                var curdriverId = Ext.getCmp("DriverId").getValue();
                                if(dsVehicle.baseParams.DriverId!=curdriverId)
                                {
                                    dsVehicle.baseParams.DriverId=curdriverId;
                                    dsVehicle.load({callback: function(resp, opts) { 
                                        if(dsVehicle.getCount()>=1)
                                            Ext.getCmp("VehicleId").setValue(dsVehicle.getAt(0).get("VehicleId"));
                                        else if(dsVehicle.getCount()==0){
                                            Ext.getCmp("VehicleId").setValue('');
                                            dsVehicle.baseParams.DriverId='';
                                            dsVehicle.load();
                                        }
                                    }});
                                }
                            }
	                     }
                    }]
                 },
                {
                    layout: 'form',
                    border: false,
                    labelWidth: 55,
                    columnWidth: .33,
                    html: '&nbsp'
}]
                },
            {
                layout: 'column',
                items: [
                {
                    layout: 'form',
                    border: false,
                    labelWidth: 80,
                    columnWidth: .33,
                    items: [
                    {
                        xtype: 'hidden',
                        fieldLabel: '�ͻ�Ա',
                        anchor: '95%',
                        id: 'deliveryer',
                        name: 'deliveryer'
}]
                    },
                {
                    layout: 'form',
                    border: false,
                    labelWidth: 55,
                    columnWidth: .33,
                    items: [
                    {
                        xtype: 'hidden',
                        fieldLabel: '������',
                        anchor: '95%',
                        id: 'driverman',
                        name: 'driverman'
}]
                    },
                {
                    layout: 'form',
                    border: false,
                    labelWidth: 55,
                    columnWidth: .33,
                    items: [
                    {
                        xtype: 'hidden',
                        fieldLabel: '��������',
                        anchor: '95%',
                        id: 'deliveryerdate',
                        name: 'deliveryerdate',
                        format: 'Y��m��d��',
                        value: new Date().clearTime(),
                        editable: false
}]
}]
}]
    });

    /*-----------------------������Ϣ����end------------------------*/


    /*------��ʼ��ȡ���ݵĺ��� start---------------*/
    var DrawInvGridData = new Ext.data.Store
                        ({
                            url: 'frmDrawInvCtrl.aspx?method=getDrawInvList',
                            reader: new Ext.data.JsonReader({
                                totalProperty: 'totalProperty',
                                root: 'root'
                            }, [
                                {
                                    name: 'DrawInvId'
                                },
	                            {
	                                name: 'DrawNumber'
	                            },
	                            {
	                                name: 'OutStor'
	                            },
	                            {
	                                name: 'OutStorName'
	                            },
	                            {
	                                name: 'SendDate'
	                            },
	                            {
	                                name: 'CustomerId'
	                            },
	                            {
	                                name: 'CustomerName'
	                            },
	                            {
	                                name: 'CustomerCode'
	                            },
	                            {
	                                name: 'DrawType'
	                            },
	                            {
	                                name: 'DrawTypeName'
	                            },
	                            {
	                                name: 'DriverId'
	                            },
	                            {
	                                name: 'DriverName'
	                            },
	                            {
	                                name: 'VehicleId'
	                            },
	                            {
	                                name: 'VehicleName'
	                            },
	                            {
	                                name: 'ControlDate'
	                            },
	                            {
	                                name: 'TotalQty'
	                            },
	                            {
	                                name: 'TotalAmt'
	                            },
	                            {
	                                name: 'OrderId'
	                            },
	                            {
	                                name: 'ProductId'
	                            },
	                            {
	                                name: 'ProductCode'
	                            },
	                            {
	                                name: 'ProductName'
	                            },
	                            {
	                                name: 'DrawQty'
	                            },
	                            {
	                                name: 'UnitText'
	                            },
	                            { name: 'OrderNumber' },
	                            { name: 'IsPayed' },
	                            { name: 'IsBill' },
	                            { name: 'DistributionType'}


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

    function converBool(v) {
        if (v == "1")
            return "��";
        return "��";
    }
    /*------��ʼDataGrid�ĺ��� start---------------*/

    var sm = new Ext.grid.CheckboxSelectionModel({
        singleSelect: false
    });
    var DrawInvGrid = new Ext.grid.GridPanel({
        el: 'DrawInvGrid',
        //width: '98%',
        //height: '100%',
        //        autoWidth: true,
        //autoHeight: true,
        autoScroll: true,
        layout: 'fit',
        id: '',
        store: DrawInvGridData,
        loadMask: { msg: '���ڼ������ݣ����Ժ��' },
        sm: sm,
        cm: new Ext.grid.ColumnModel([

		                    sm,
		                    new Ext.grid.RowNumberer({header:'���',width:34}), //�Զ��к�
		                    {
		                    header: '�������',
		                    dataIndex: 'DrawInvId',
		                    id: 'DrawInvId',
		                    hidden: true
		                },
		                    {
		                        header: '�������',
		                        dataIndex: 'DrawNumber',
		                        id: 'DrawNumber',
		                        width:95
		                    },
		                    {
		                        header: '������',
		                        dataIndex: 'OrderNumber',
		                        id: 'OrderNumber',
		                        width:95
		                    },
		                    { header: '�Ƿ񸶷�', dataIndex: 'IsPayed', id: 'IsPayed',width:60, renderer: converBool },
		                    { header: '�Ƿ�Ʊ', dataIndex: 'IsBill', id: 'IsBill',width:60, renderer: converBool },
		                    {
		                        header: '�ֿ�',
		                        dataIndex: 'OutStorName',
		                        id: 'OutStorName',
		                        width:100
		                    },
		                    { header: '��������', dataIndex: 'SendDate', id: 'SendDate',width:100 },
		                    {
		                        header: '�ͻ�����',
		                        dataIndex: 'CustomerCode',
		                        id: 'CustomerCode',
		                        width:60
		                    },
		                    {
		                        header: '�ͻ�����',
		                        dataIndex: 'CustomerName',
		                        id: 'CustomerName',
		                        width:120
		                    },
		                    {
		                        header: '����',
		                        dataIndex: 'DrawTypeName',
		                        id: 'DrawTypeName',
		                        width:60
		                    },
		                    {
		                        header: '��Ʒ����',
		                        dataIndex: 'ProductCode',
		                        id: 'ProductCode',
		                        width:60
		                    },
		                    {
		                        header: '��Ʒ����',
		                        dataIndex: 'ProductName',
		                        id: 'ProductName',
		                        width:120
		                    },
		                    {
		                        header: '����',
		                        dataIndex: 'DrawQty',
		                        id: 'DrawQty',
		                        width:60
		                    },
		                    {
		                        header: '��λ',
		                        dataIndex: 'UnitText',
		                        id: 'UnitText',
		                        width:50
		                    },
		                    {   header: '��������', 
		                        dataIndex: 'DistributionType', 
		                        id: 'DistributionType',
		                        width:60, 
		                        renderer: function(v){
		                            if(v=='C011') return '������';
		                            if(v=='C012') return 'С����';
		                             return 'Ĭ��';
		                        }
		                    }


		                    	]),
        bbar: new Ext.PagingToolbar({
            pageSize: 30,
            store: DrawInvGridData,
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
        height: 300,
        closeAction: 'hide',
        stripeRows: true,
        loadMask: true//,
        //autoExpandColumn: 2
    });
    DrawInvGrid.on("afterrender", function(component) {
        component.getBottomToolbar().refresh.hideParent = true;
        component.getBottomToolbar().refresh.hide();
    });
    DrawInvGrid.render();
    /*------DataGrid�ĺ������� End---------------*/

    DrawInvGrid.on('rowdblclick', function(sm, index, record) {
        var recordData = DrawInvGridData.getAt(index);
        if (recordData.data.ProductId != '0') {
            showStock(recordData.data.ProductId);
        }
        Ext.getCmp("OutStor").setValue(recordData.data.OutStor);
    });



    /*------ʵʱ�����Ϣ Start------------------*/

    function showStock(productId) {
        stockGridData.baseParams.ProductId = productId;
        stockGridData.load();
    }
    var stockGridData = new Ext.data.Store
({
    url: 'frmDrawInvCtrl.aspx?method=getCurrentStockList',
    reader: new Ext.data.JsonReader({
        totalProperty: 'totalProperty',
        root: 'root'
    }, [
	{
	    name: 'WhId'
	},
	{
	    name: 'ProductId'
	},
	{
	    name: 'RealQty'
	}, {
	    name: 'ProductCode'
	}, {
	    name: 'ProductName'
	}, {
	    name: 'ProductSpec'
	}, {
	    name: 'ProductUnit'
}])
	,
    listeners:
	{
	    scope: this,
	    load: function() {
	    }
	}
});

    var stockGrid = new Ext.grid.GridPanel({
        el: 'stockGridDiv',
        width: '100%',
        height: '100%',
        autoWidth: true,
        autoHeight: true,
        autoScroll: true,
        layout: 'fit',
        title: '�����Ϣ',
        id: '',
        store: stockGridData,
        loadMask: { msg: '���ڼ������ݣ����Ժ��' },
        cm: new Ext.grid.ColumnModel([
		new Ext.grid.RowNumberer(), //�Զ��к�
		{
		header: '�ֿ�����',
		dataIndex: 'WhId',
		id: 'WhId',
		width: 60,
		renderer: function(val, params, record) {
		    dsWareHouse.each(function(r) {
		        if (val == r.data['WhId']) {
		            val = r.data['WhName'];
		            return;
		        }
		    });
		    return val;
		}
},
        {
            header: '����',
            dataIndex: 'ProductCode',
            id: 'ProductCode',
            width: 30
        },
		{
		    header: '��Ʒ����',
		    dataIndex: 'ProductName',
		    id: 'ProductName',
		    width: 80
		},
        {
            header: '���',
            dataIndex: 'ProductSpec',
            id: 'ProductSpec',
            width: 30
        },
        {
            header: '��λ',
            dataIndex: 'ProductUnit',
            id: 'ProductUnit',
            width: 20

        },
		{
		    header: '�������',
		    dataIndex: 'RealQty',
		    id: 'RealQty',
		    width: 40
		}
   ]),
        bbar: new Ext.PagingToolbar({
            pageSize: 30,
            store: stockGridData,
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
    stockGrid.render();

})

</script>

</html>
