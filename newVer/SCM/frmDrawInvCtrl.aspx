<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmDrawInvCtrl.aspx.cs" Inherits="SCM_frmDrawInvCtrl" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>配送调度</title>
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

<!-- 所有数据源打印到这里 -->
<%= getComboBoxStore() %>

<script type="text/javascript">
Ext.BLANK_IMAGE_URL = "../ext3/resources/images/default/s.gif";  //作为：让下拉框的三角形下拉图片显示
Ext.onReady(function() {


    //领货单列表
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

    //保存
    function saveUpdate() {
        var sm = DrawInvGrid.getSelectionModel();
        //多选
        var selectData = sm.getSelections();
        var array = new Array(selectData.length);
        for (var i = 0; i < selectData.length; i++) {
            array[i] = selectData[i].get('DrawInvId');
        }

        //如果没有选择，就提示需要选择数据信息
        if (selectData == null || selectData == "") {
            Ext.Msg.alert("提示", "请选中需要生成领货单的记录！");
            return;
        }
        //输入参数前台判断
        var carcode = Ext.getCmp('VehicleId').getValue()
        if (carcode == null || carcode == "") {
            Ext.Msg.alert("提示", "请选择送货车辆!");
            return;
        }
        var DriverId = Ext.getCmp('DriverId').getValue()
        if (DriverId == null || DriverId == "") {
            Ext.Msg.alert("提示", "请选择驾驶员！");
            return;
        }
        Ext.Msg.wait("保存中....", "提示");
        //页面提交
        Ext.Ajax.request({
            url: 'frmDrawInvCtrl.aspx?method=saveUpdate',
            method: 'POST',
            params: {
                DrawInvId: array.join('-'), //传入多项的id串
                VehicleId: Ext.getCmp('VehicleId').getValue(),
                DriverId: Ext.getCmp('DriverId').getValue(),
                DlverId: Ext.getCmp('deliveryer').getValue(),
                OutStor: Ext.getCmp('OutStor').getValue(),
                DlvDate: Ext.getCmp('deliverydate').getValue().dateFormat('Y/m/d')
            },
            success: function(resp, opts) {
                Ext.Msg.hide();
                if (checkExtMessage(resp)) {
                    //Ext.Msg.alert("提示", "数据生成成功！");
                    DrawInvGrid.getStore().reload();
                }

            },
            failure: function(resp, opts) {
                Ext.Msg.hide();
                Ext.Msg.alert("提示", "数据生成失败！");
            }
        });


    }



    /*-----------------------查询界面start------------------------*/
    var searchForm = new Ext.form.FormPanel({
        renderTo: 'searchForm',
        frame: true,
        buttonAlign: 'center',
        items: [
            {//第一行
                layout: 'column',
                items: [
                    {//第二单元格
                        layout: 'form',
                        border: false,
                        labelWidth: 70,
                        columnWidth: .4,
                        items: [{
                            xtype: 'datefield',
                            fieldLabel: '开始日期',
                            anchor: '95%',
                            id: 'StartDate',
                            name: 'StartDate',
                            format: 'Y年m月d日',
                            value: new Date().getFirstDateOfMonth().clearTime(),
                            editable: false
}]
                        },
                    {//第三单元格
                        layout: 'form',
                        border: false,
                        labelWidth: 70,
                        columnWidth: .4,
                        items: [{
                            xtype: 'datefield',
                            fieldLabel: '结束日期',
                            anchor: '95%',
                            id: 'EndDate',
                            name: 'EndDate',
                            format: 'Y年m月d日',
                            value: new Date().clearTime(),
                            editable: false
}]
                        },
                    {//第四单元格
                        layout: 'form',
                        border: false,
                        labelWidth: 70,
                        columnWidth: .1,
                        items: [{
                            xtype: 'button',
                            text: '查询',
                            width: 70,
                            //iconCls:'excelIcon',
                            scope: this,
                            handler: function() {
                                QueryDataGrid();
                            }
}]
                        }
                ]
            }, {//第一行
                layout: 'column',
                items: [{//第一单元格
                    layout: 'form',
                    border: false,
                    labelWidth: 70,
                    columnWidth: .4,
                    items: [{
                        xtype: 'textfield',
                        fieldLabel: '客户编号',
                        anchor: '95%',
                        id: 'CustomerId',
                        name: 'CustomerId'
}]
                    },
                    {//第一单元格
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
                            fieldLabel: '出库仓库',
                            selectOnFocus: true,
                            anchor: '95%',
                            editable: false
}]}]
                        }
        ]
    });
    /*-----------------------查询界面end------------------------*/

    /*-----------------------配送信息界面start------------------------*/
    //仓位数据源
    var dsVehicle;
    if (dsVehicle == null) { //防止重复加载
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
        title: '调度信息录入',
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
                        fieldLabel: '出库仓库',
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
                        fieldLabel: '送货日期',
                        anchor: '95%',
                        id: 'deliverydate',
                        name: 'deliverydate',
                        format: 'Y年m月d日',
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
                        text: '保存',
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
                        fieldLabel: '送货车辆',
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
                        fieldLabel: '驾驶员',
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
                        fieldLabel: '送货员',
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
                        fieldLabel: '调度人',
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
                        fieldLabel: '调度日期',
                        anchor: '95%',
                        id: 'deliveryerdate',
                        name: 'deliveryerdate',
                        format: 'Y年m月d日',
                        value: new Date().clearTime(),
                        editable: false
}]
}]
}]
    });

    /*-----------------------配送信息界面end------------------------*/


    /*------开始获取数据的函数 start---------------*/
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
    /*------获取数据的函数 结束 End---------------*/

    function converBool(v) {
        if (v == "1")
            return "是";
        return "否";
    }
    /*------开始DataGrid的函数 start---------------*/

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
        loadMask: { msg: '正在加载数据，请稍侯……' },
        sm: sm,
        cm: new Ext.grid.ColumnModel([

		                    sm,
		                    new Ext.grid.RowNumberer({header:'序号',width:34}), //自动行号
		                    {
		                    header: '领货单号',
		                    dataIndex: 'DrawInvId',
		                    id: 'DrawInvId',
		                    hidden: true
		                },
		                    {
		                        header: '领货单号',
		                        dataIndex: 'DrawNumber',
		                        id: 'DrawNumber',
		                        width:95
		                    },
		                    {
		                        header: '订单号',
		                        dataIndex: 'OrderNumber',
		                        id: 'OrderNumber',
		                        width:95
		                    },
		                    { header: '是否付费', dataIndex: 'IsPayed', id: 'IsPayed',width:60, renderer: converBool },
		                    { header: '是否开票', dataIndex: 'IsBill', id: 'IsBill',width:60, renderer: converBool },
		                    {
		                        header: '仓库',
		                        dataIndex: 'OutStorName',
		                        id: 'OutStorName',
		                        width:100
		                    },
		                    { header: '配送日期', dataIndex: 'SendDate', id: 'SendDate',width:100 },
		                    {
		                        header: '客户编码',
		                        dataIndex: 'CustomerCode',
		                        id: 'CustomerCode',
		                        width:60
		                    },
		                    {
		                        header: '客户名称',
		                        dataIndex: 'CustomerName',
		                        id: 'CustomerName',
		                        width:120
		                    },
		                    {
		                        header: '类型',
		                        dataIndex: 'DrawTypeName',
		                        id: 'DrawTypeName',
		                        width:60
		                    },
		                    {
		                        header: '商品编码',
		                        dataIndex: 'ProductCode',
		                        id: 'ProductCode',
		                        width:60
		                    },
		                    {
		                        header: '商品名称',
		                        dataIndex: 'ProductName',
		                        id: 'ProductName',
		                        width:120
		                    },
		                    {
		                        header: '数量',
		                        dataIndex: 'DrawQty',
		                        id: 'DrawQty',
		                        width:60
		                    },
		                    {
		                        header: '单位',
		                        dataIndex: 'UnitText',
		                        id: 'UnitText',
		                        width:50
		                    },
		                    {   header: '配载类型', 
		                        dataIndex: 'DistributionType', 
		                        id: 'DistributionType',
		                        width:60, 
		                        renderer: function(v){
		                            if(v=='C011') return '大配送';
		                            if(v=='C012') return '小配送';
		                             return '默认';
		                        }
		                    }


		                    	]),
        bbar: new Ext.PagingToolbar({
            pageSize: 30,
            store: DrawInvGridData,
            displayMsg: '显示第{0}条到{1}条记录,共{2}条',
            emptyMsy: '没有记录',
            displayInfo: true
        }),
        viewConfig: {
            columnsText: '显示的列',
            scrollOffset: 20,
            sortAscText: '升序',
            sortDescText: '降序',
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
    /*------DataGrid的函数结束 End---------------*/

    DrawInvGrid.on('rowdblclick', function(sm, index, record) {
        var recordData = DrawInvGridData.getAt(index);
        if (recordData.data.ProductId != '0') {
            showStock(recordData.data.ProductId);
        }
        Ext.getCmp("OutStor").setValue(recordData.data.OutStor);
    });



    /*------实时库存信息 Start------------------*/

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
        title: '库存信息',
        id: '',
        store: stockGridData,
        loadMask: { msg: '正在加载数据，请稍侯……' },
        cm: new Ext.grid.ColumnModel([
		new Ext.grid.RowNumberer(), //自动行号
		{
		header: '仓库名称',
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
            header: '编码',
            dataIndex: 'ProductCode',
            id: 'ProductCode',
            width: 30
        },
		{
		    header: '商品名称',
		    dataIndex: 'ProductName',
		    id: 'ProductName',
		    width: 80
		},
        {
            header: '规格',
            dataIndex: 'ProductSpec',
            id: 'ProductSpec',
            width: 30
        },
        {
            header: '单位',
            dataIndex: 'ProductUnit',
            id: 'ProductUnit',
            width: 20

        },
		{
		    header: '库存数量',
		    dataIndex: 'RealQty',
		    id: 'RealQty',
		    width: 40
		}
   ]),
        bbar: new Ext.PagingToolbar({
            pageSize: 30,
            store: stockGridData,
            displayMsg: '显示第{0}条到{1}条记录,共{2}条',
            emptyMsy: '没有记录',
            displayInfo: true
        }),
        viewConfig: {
            columnsText: '显示的列',
            scrollOffset: 20,
            sortAscText: '升序',
            sortDescText: '降序',
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
