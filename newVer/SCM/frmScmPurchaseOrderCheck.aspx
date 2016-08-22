<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmScmPurchaseOrderCheck.aspx.cs"
    Inherits="SCM_frmScmPurchaseOrderCheck" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>采购核销</title>
        <link rel="stylesheet" type="text/css" href="../ext3/resources/css/ext-all.css" />
        <link rel="stylesheet" href="../css/Ext.ux.grid.GridSummary.css"/>
<script type="text/javascript" src="../ext3/adapter/ext/ext-base.js"></script>
<script type="text/javascript" src="../ext3/ext-all.js"></script>
<script type="text/javascript" src="../js/operateResp.js"></script>
<script type="text/javascript" src="../js/getExcelXml.js"></script>
<script type="text/javascript" src="../js/FilterControl.js"></script>
<script type="text/javascript" src="../js/floatUtil.js"></script>
<script type="text/javascript" src="../js/EmpSelect.js"></script>
<script type="text/javascript" src="../ext3/src/locale/ext-lang-zh_CN.js"></script>
<script type="text/javascript" src='../js/Ext.ux.grid.GridSummary.js'></script>

<style type="text/css">  
.line{ BORDER-LEFT-STYLE: none; BORDER-RIGHT-STYLE: none; BORDER-TOP-STYLE: none}
</style> 

</head>
<%=getComboBoxSource()%>
<script type="text/javascript">
var store = new Ext.data.SimpleStore({
        fields: ['id', 'name'],
        data : [
        ['1', '是'],
        ['0', '否']
        ]
});
function getCmbStore(columnName)
    { 
        switch(columnName)
        {            
            case "IsSettle":
            case "IsCheck":
                return store;
//            case "EmpBz":
//                return EmpBzStore;
        }
        return null;
    }
Ext.BLANK_IMAGE_URL = "../ext3/resources/images/default/s.gif" ;
Ext.onReady(function() {
    var imageUrl = "../Theme/1/";
    /*------实现toolbar的函数 start---------------*/
    var Toolbar = new Ext.Toolbar({
        renderTo: "toolbar",
        region: "north",
        height: 25,
        items: [{
            text: "核销",
            icon: imageUrl + "images/extjs/customer/add16.gif",
            handler: function() {
                checkOrders();
                addSelectedRows();
                //radioGroup.setValue('2');
            }
        }, {
            text: "结算",
            icon: imageUrl + "images/extjs/customer/edit16.gif",
            handler: function() {
                //再次提醒是否真的要结算
                Ext.Msg.confirm("提示信息", "是否真的要结算选择的单据吗？", function callBack(id) {
                    //判断是否删除数据
                    if (id == "yes") {
                        Ext.MessageBox.wait('正在保存数据中, 请稍候……');
                        var sm112 = Ext.getCmp('viewGrid').getSelectionModel();
                        //获取选择的数据信息
                        var selectDatasa = sm112.getSelections();
                        var customerId = selectDatasa[0].data.SupplierId;
                        var json = '';
                        for (var i = 0; i < selectDatasa.length; i++) {
                            json += selectDatasa[i].data.OrderDetailId + ',';
                        }
                        json = json.substring(0, json.length - 1);
                        Ext.Ajax.request({
                            url: 'frmScmPurchaseOrderCheck.aspx?method=settlePurchase',
                            params: {
                                detail: json
                            },
                            success: function(resp, opts) {
                                Ext.MessageBox.hide();
                                if (checkExtMessage(resp)) {
                                    gridStore.reload();
                                }
                            },
                            failure: function(resp, opts) {
                                Ext.MessageBox.hide();
                                Ext.Msg.alert("提示", "保存失败");
                            }
                        });
                    }
                });
            }
}]
        });


        function checkOrders() {
            var sm11 = Ext.getCmp('viewGrid').getSelectionModel();
            //获取选择的数据信息
            var selectDatas = sm11.getSelections();
            var customerId = selectDatas[0].data.SupplierId;
            for (var i = 0; i < selectDatas.length; i++) {
                if (customerId != selectDatas[i].data.SupplierId) {
                    Ext.Msg.alert("提示", "只能对同一采购单位下的采购明细核销，请重新选择！");
                    return;
                }
                if (selectDatas[i].data.IsCheck == 1) {
                    Ext.Msg.alert("提示", "不能多次核销！");
                    return;
                }
            }

            Ext.getCmp("CheckOrg").setValue(orgName);
            Ext.getCmp("CustomerName").setValue("");
            Ext.getCmp("CustomerPhone").setValue("");
            Ext.getCmp("BillNo").setValue("");
            Ext.getCmp("BillDate").setValue("");
            Ext.getCmp("BillOper").setValue("");
            Ext.getCmp("ReceiverId").setValue("");
            Ext.getCmp("CheckOper").setValue("");
            Ext.getCmp("CheckMemo").setValue("");
            Ext.getCmp("CustomerId").setValue(customerId);
            checkDtlGridData.removeAll();
            checkForm.show();
        }
        //允许多选
        var sm = new Ext.grid.CheckboxSelectionModel({
            singleSelect: false
        });

        var colModel = new Ext.grid.ColumnModel({
            columns: [
		new Ext.grid.RowNumberer(), sm,
		    { header: '客户名称',
		        dataIndex: 'ChineseName',
		        id: 'ChineseName',
		        width: 150,
		        tooltip: '客户名称'
		    },
		            { header: '产品编号',
		                dataIndex: 'ProductNo',
		                id: 'ProductNo',
		                width: 60,
		                tooltip: '产品编号'
		            },
            { header: '入库仓库',
                dataIndex: 'WhName',
                id: 'WhName',
                width: 150,
                tooltip: '产品名称'
            },
		            { header: '产品名称',
		                dataIndex: 'ProductName',
		                id: 'ProductName',
		                width: 150,
		                tooltip: '产品名称'
		            },
		            { header: '单位',
		                dataIndex: 'UnitName',
		                id: 'UnitName',
		                width: 35,
		                tooltip: '单位'
		            },
		            { header: '采购数量',
		                dataIndex: 'BookQty',
		                id: 'BookQty',
		                width: 60,
		                tooltip: '销售数量'
		            },
		            { header: '实收数量',
		                dataIndex: 'RealQty',
		                id: 'RealQty',
		                width: 60,
		                tooltip: '实收数量'
		            },
		{
		    header: '入库量',
		    dataIndex: 'ToStockNum',
		    width: 50,
		    id: 'ToStockNum'
		},
		            { header: '已核数量',
		                dataIndex: 'CheckNum',
		                id: 'CheckNum',
		                width: 60,
		                tooltip: '已核数量'
		            },
		            { header: '采购价格',
		                dataIndex: 'ProductPrice',
		                id: 'ProductPrice',
		                width: 60,
		                tooltip: '采购价格'
		            },
		            { header: '订单日期',
		                dataIndex: 'CreateDate',
		                id: 'CreateDate',
		                renderer: Ext.util.Format.dateRenderer('Y年m月d日'),
		                tooltip: '订单日期'
		            },
		            { header: '销售总额',
		                dataIndex: 'Saleamt',
		                id: 'Saleamt',
		                width: 60,
		                tooltip: '采购总额'
		            },
		            { header: '销售税金',
		                dataIndex: 'Saletax',
		                id: 'Saletax',
		                width: 60,
		                tooltip: '采购税金'
		            },
		            { header: '实际总额',
		                dataIndex: 'Realsaleamt',
		                id: 'Realsaleamt',
		                width: 60,
		                tooltip: '实际总额'
		            },
		            { header: '实际税金',
		                dataIndex: 'Realsaletax',
		                id: 'Realsaletax',
		                width: 60,
		                tooltip: '实际税金'
		            },
		            { header: '已核总额',
		                dataIndex: 'Checksaleamt',
		                id: 'Checksaleamt',
		                width: 60,
		                tooltip: '已核总额'
		            },
		            { header: '已核税金',
		                dataIndex: 'Checksaletax',
		                id: 'Checksaletax',
		                width: 60,
		                tooltip: '已核税金'
		            },
		            { header: '是否核销',
		                dataIndex: 'IsCheck',
		                id: 'IsCheck',
		                width: 60,
		                renderer: function(v) { if (v == 1) return '<font color="blue">是</font>'; else return '<font color="red">否</font>'; },
		                tooltip: '是否核销'
		            },
		            { header: '是否结算',
		                dataIndex: 'IsSettle',
		                id: 'IsSettle',
		                width: 60,
		                renderer: function(v) { if (v == 1) return '<font color="blue">是</font>'; else return '<font color="red">否</font>'; },
		                tooltip: '是否结算'
		            }
            	]
        });
        var gridStore = new Ext.data.Store({
            url: 'frmScmPurchaseOrderCheck.aspx?method=getnochecklist',
            reader: new Ext.data.JsonReader({
                totalProperty: 'totalProperty',
                root: 'root',
                fields: [
    { name: 'OrderDetailId' },
    { name: 'SupplierId' },
	{ name: 'ChineseName', type: 'string' },
	{ name: 'ProductName', type: 'string' },
	{ name: 'ProductNo', type: 'string' },
	{ name: 'UnitName', type: 'string' },
	{ name: 'BookQty', type: 'float' },
	{ name: 'RealQty', type: 'float' },
	{ name: 'CheckNum', type: 'float' },
	{ name: 'ProductPrice', type: 'float' },
	{ name: 'CreateDate', type: 'date' },
	{ name: 'Saleamt', type: 'float' },
	{ name: 'Saletax', type: 'float' },
	{ name: 'Realsaleamt', type: 'float' },
	{ name: 'Realsaletax', type: 'float' },
	{ name: 'Checksaleamt', type: 'float' },
	{ name: 'Checksaletax', type: 'float' },
	{ name: 'IsCheck', type: 'string' },
	{ name: 'IsSettle', type: 'string' },
	{ name: 'WhName', type: 'string' },
	{ name: 'ToStockNum', type: 'float' }
	]
            })
        });

        defaultPageSize = 10;
        var toolBar = new Ext.PagingToolbar({
            pageSize: 10,
            store: gridStore,
            displayMsg: '显示第{0}条到{1}条记录,共{2}条',
            emptyMsy: '没有记录',
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
            emptyText: '更改每页记录数',
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
            gridStore.reload();
        }, toolBar);
        btnExpert.setVisible(true);
    
        //合计项
        var viewGrid = new Ext.grid.GridPanel({
            renderTo: "gird",
            id: 'viewGrid',
            split: true,
            store: gridStore,
            autoscroll: true,
            loadMask: { msg: '正在加载数据，请稍侯……' },
            sm: sm,
            cm: colModel,
            bbar: toolBar,//new Ext.PagingToolbar({
//                pageSize: 10,
//                store: gridStore,
//                displayMsg: '显示第{0}条到{1}条记录,共{2}条',
//                emptyMsy: '没有记录',
//                displayInfo: true
//            }),
            viewConfig: {
                columnsText: '显示的列',
                scrollOffset: 20,
                sortAscText: '升序',
                sortDescText: '降序',
                forceFit: false
            },
            stripeRows: true,
            height: 350,
            width: document.body.clientWidth,
            title: '需要核销的订单'

        });
        viewGrid.render();

        createSearch(viewGrid, viewGrid.getStore(), "searchForm");
        //setControlVisibleByField();
        defaultPageSize = 10;
        searchForm.el = "searchForm";
        searchForm.render();
        /******************DtlGrid*****************************/

        var checkDtlGridData = new Ext.data.Store
({
    reader: new Ext.data.JsonReader({
        totalProperty: 'totalProperty',
        groupField: 'SaleCheckId',
        root: 'root'
    }, [
	{
	    name: 'SaleCheckId'
	},
	{
	    name: 'ObjectId'
	},
	{
	    name: 'CheckNum'
	},
	{
	    name: 'CheckPrice'
	},
	{
	    name: 'CheckAmt'
	},
	{
	    name: 'CheckOther'
	},
	{
	    name: 'CheckTax'
}])
	,
    listeners:
	{
	    scope: this,
	    load: function() {
	    }
	}
});

        /*------获取数据的函数 结束 End---------------*/

        function getBookQty(value, cellmeta, record, rowIndex, columnIndex, store) {
//            var index = gridStore.find('OrderDetailId', record.data.ObjectId);
//            if (index < 0)
//                return "";
//            var record = gridStore.getAt(index);
//            return record.data.BookQty;
            var r = getStoreByValue(record.data.ObjectId);
            return r.data.BookQty;

        }

        function getRealQty(value, cellmeta, record, rowIndex, columnIndex, store) {
            var r = getStoreByValue(record.data.ObjectId);
            return r.data.RealQty;

        }

        function getUnitName(value, cellmeta, record, rowIndex, columnIndex, store) {
            var index = gridStore.find('OrderDetailId', record.data.ObjectId);
            if (index < 0)
                return "";
            var record = gridStore.getAt(index);
            return record.data.UnitName;

        }

        function getProductName(value, cellmeta, record, rowIndex, columnIndex, store) {
//            var index = gridStore.find('OrderDetailId', record.data.ObjectId);
//            if (index < 0)
//                return "";
//            var record = gridStore.getAt(index);
            var r = getStoreByValue(record.data.ObjectId);
            if(r!=null)
            {
                return r.data.ProductName;
            }
            return "";
        }
        function getStoreByValue(orderDetailId)
        {
            for(var i=0;i<gridStore.data.items.length;i++)
            {
                if(gridStore.data.items[i].data.OrderDetailId == orderDetailId)
                    return gridStore.data.items[i];
            }
            return null;
        }

        function getCheckAmt(value, cellmeta, record, rowIndex, columnIndex, store) {
            //record.data.CheckAmt=accMul(record.data.CheckNum,record.data.CheckPrice);
        }

        function addSelectedRows() {
            var sm1 = Ext.getCmp('viewGrid').getSelectionModel();
            //获取选择的数据信息
            var selectData = sm1.getSelections();
            var ids = "";
            Ext.getCmp('CustomerName').setValue(selectData[0].data.ChineseName);
            var sumAmt=0;
            for (var i = 0; i < selectData.length; i++) {
                var rowCount = checkDtlGrid.getStore().getCount();
                var insertPos = parseInt(rowCount);
                var addRow = new headPattern({
                    SaleCheckId: -(1 + rowCount),
                    ObjectId: selectData[i].data.OrderDetailId,
                    CheckNum: selectData[i].data.RealQty - selectData[i].data.CheckNum,
                    CheckPrice: selectData[i].data.ProductPrice,
                    CheckAmt: accMul(selectData[i].data.BookQty, selectData[i].data.ProductPrice),
                    CheckOther: '0',
                    CheckTax: '0'
                });
                sumAmt =accAdd(accMul(selectData[i].data.BookQty, selectData[i].data.ProductPrice),sumAmt);
                checkDtlGrid.stopEditing();
                if (insertPos > 0) {
                    var rowIndex = checkDtlGrid.getStore().insert(insertPos, addRow);
                    checkDtlGrid.startEditing(insertPos, 0);
                }
                else {
                    var rowIndex = checkDtlGrid.getStore().insert(0, addRow);
                    // planDtlGrid.startEditing(0, 0);
                }
            }
            Ext.getCmp('SumAmt').setValue(sumAmt);
            var height = 100;
            if (selectData.length > 5) {

                height = selectData.length * 25;
            }
//            if (height > 200)
//                height = 200;
//            checkDtlGrid.setHeight(height);
        }
        var headPattern = Ext.data.Record.create([
   { name: 'SaleCheckId' },
   { name: 'ObjectId' },
   { name: 'CheckNum' },
	{ name: 'CheckPrice' },
	{ name: 'CheckAmt' },
	{ name: 'CheckOther' },
	{ name: 'CheckTax' }
          ]);


        /*------开始DataGrid的函数 start---------------*/

        var sm = new Ext.grid.CheckboxSelectionModel({
            singleSelect: true
        });
        
        var checkDtlGrid = new Ext.grid.EditorGridPanel({
            width: '100%',
            height: 150,
//            autoWidth: true,
//            autoHeight:true,
            autoScroll: true,
            clicksToEdit: 1,
            layout: 'fit',
            id: 'checkDtlGrid',
            store: checkDtlGridData,
            loadMask: { msg: '正在加载数据，请稍侯……' },
            sm: sm,
            cm: new Ext.grid.ColumnModel([
		sm,
		new Ext.grid.RowNumberer(), //自动行号
		{
		header: '商品名称',
		dataIndex: 'ProductName',
		width: 150,
		id: 'ProductName',
		renderer: getProductName
},
		{
		    header: '单位',
		    dataIndex: 'UnitName',
		    width: 30,
		    id: 'UnitName',
		    renderer: getUnitName
		},
		{
		    header: '订单数量',
		    dataIndex: 'OrderQty',
		    width: 50,
		    id: 'OrderQty',
		    renderer: getBookQty
		},
		{
		    header: '实收数量',
		    dataIndex: 'RealQty',
		    width: 50,
		    id: 'RealQty',
		    renderer: getRealQty
		},
//		{
//		    header: '实收数量',
//		    dataIndex: 'RealQty',
//		    width: 50,
//		    align: 'right',
//		    id: 'RealQty',
//		    renderer: getRealQty
//		},
		{
		    header: '核销数量',
		    dataIndex: 'CheckNum',
		    width: 60,
		    align: 'right',
		    id: 'CheckNum',
		    editor: new Ext.form.NumberField({
		        align: 'right',
		        decimalPrecision:6
		    })
		},
		{
		    header: '含税单价',
		    dataIndex: 'CheckPrice',
		    width: 75,
		    id: 'CheckPrice',
		    align: 'right',
		    editor: new Ext.form.NumberField({
		        align: 'right',
		        decimalPrecision:8
		    })
		},
		{
		    header: '商品金额',
		    dataIndex: 'CheckAmt',
		    width: 70,
		    align: 'right',
		    id: 'CheckAmt',
		    editor: new Ext.form.NumberField({
		        align: 'right',
		        decimalPrecision: 2 
		    })
		    //render:getCheckAmt
		},
		{
		    header: '客户运费',
		    dataIndex: 'CheckOther',
		    width: 50,
		    id: 'CheckOther',
		    editor: new Ext.form.NumberField({
		        align: 'right',
		        decimalPrecision:2
		    })
		},
		{
		    header: '税额',
		    dataIndex: 'CheckTax',
		    width: 40,
		    id: 'CheckTax',
		    editor: new Ext.form.NumberField({
		        align: 'right',
		        decimalPrecision:2
		    })
}]),
//            viewConfig: {
//                columnsText: '显示的列',
//                scrollOffset: 20,
//                sortAscText: '升序',
//                sortDescText: '降序',
//                forceFit: true
//            },
viewConfig: {
                   
                    forceFit: true
                },
                closeAction: 'hide',
                stripeRows: true,
                loadMask: true,
                autoExpandColumn: 2,
//            bbar:['->',{             
//            text:'票号:',
//            xtype: 'label',
//            id:'BillLabel'
//        },{
//            xtype:'textfield',
//			anchor:'50%',
//			name:'BillNo',
//			id:'BillNo'
//        }],
            
//            closeAction: 'hide',
//            stripeRows: true,
//            loadMask: true,
//            autoExpandColumn: 2,
            listeners: {
                afteredit: function(e) {
                    if (e.field == 'CheckNum') {
                        //自动计算
                        var record = e.record; //获取被修改的行数据
                        record.set('CheckAmt', accMul(record.data.CheckNum, record.data.CheckPrice));
                    }  //record.set('SaleTax', accMul(record.get('SaleAmt') ,0.17) ); //Math.Round(3.445, 1); 
                }
            }
        });


        var radioGroup = new Ext.form.RadioGroup({
            fieldLabel: "类型",
            items: [
                new Ext.form.Radio({
                    name: "lType",
                    inputValue: "1",
                    boxLabel: '<span style="color:blue">蓝字 </span>',
                    checked: true,
                    listeners: {
                    //check : radiochange   
                }
            }),
                new Ext.form.Radio({
                    name: "lType",
                    inputValue: "2",
                    boxLabel: '<span style="color:#FF0000">红字 </span>',
                    listeners: {
                    //check : radiochange   
                }
            })]
        });

        var stateGroup = new Ext.form.RadioGroup({
            fieldLabel: "状态",
            items: [
                new Ext.form.Radio({
                    name: "StateType",
                    inputValue: "1",
                    boxLabel: '<span style="color:green">正常 </span>',
                    checked: true,
                    listeners: {
                    //check : radiochange   
                }
            }),
                new Ext.form.Radio({
                    name: "StateType",
                    inputValue: "2",
                    boxLabel: '<span style="color:#FF0000">暂估 </span>',
                    listeners: {
                    //check : radiochange   
                }
            })]
        });
        var checkForm1 = new Ext.Panel(
         {
             frame: true,
             border: false,
             //renderTo:renderTo,
             layout: 'table',
             width: 730,
             height: 400,
             layoutConfig: { columns: 8 }, //将父容器分成3列   
             items: [
                { items: { html: "核销单位", width: 60} },
                { items:
                    { xtype: 'textfield',
                        fieldLabel: '核销单位',
                        anchor: '90%',
                        cls: "line",
                        name: 'CheckOrg',
                        id: 'CheckOrg'
                    }
                },
			    { items: { html: "电话", width: 60} },
			    { items:
			        {
			            xtype: 'textfield',
			            fieldLabel: '单位电话',
			            anchor: '90%',
			            cls: "line",
			            name: 'OrgPhone',
			            id: 'OrgPhone'
			        }
			    }, { items: { html: "采购单位", width: 60} },
			    { items:
			        {
			            xtype: 'textfield',
			            fieldLabel: '单位电话',
			            anchor: '90%',
			            cls: "line",
			            name: 'CustomerName',
			            id: 'CustomerName'
			        }
			    }, { items: { html: "电话", width: 60} },
			    { items:
			        {
			            xtype: 'textfield',
			            fieldLabel: '单位电话',
			            cls: "line",
			            anchor: '90%',
			            name: 'CustomerPhone',
			            id: 'CustomerPhone'
			        }
			    }
			    , { colspan: 8, items: { html: '', height: 10} },			    
			    { items: { html: "发票编号", width: 60} },
			    { items:
			        {
			            xtype: 'textfield',
			            name: 'BillNo',
			            cls: "line",
			            id: 'BillNo'
			        }
			    }
			    , { items: { html: "开票日期", width: 60} },
			    { items:
			        {
			            xtype: 'datefield',
			            name: 'BillDate',
			            id: 'BillDate',
			            format: "Y-m-d"

			        }
			    }, { colspan: 2, items: radioGroup },
			    { colspan: 2, items: stateGroup },

			    { colspan: 8, items: { html: '', height: 10} },
			    { colspan: 8, items: checkDtlGrid },
			    {items:{html:"金额合计",widht:60}},
			    {colspan:7,items:{
			            xtype: 'textfield',
			            name: 'SumAmt',
			            cls: "line",
			            id: 'SumAmt'
			        }},
			    { colspan: 8, items: { html: '', height: 10} }
			    , { items: { html: "开票人", width: 60} },
			    { items: [
			        {
			            xtype: 'textfield',
			            name: 'BillOper',
			            cls: "line",
			            id: 'BillOper',
			            hidden: true
			        },
			         {
			             xtype: 'textfield',
			             name: 'BillOperName',
			             cls: "line",
			             id: 'BillOperName'

}]
			    }
			    , { items: { html: "收款人", width: 60} },
			    { colspan: 2, items: [
			        {
			            xtype: 'textfield',
			            name: 'ReceiverId',
			            cls: "line",
			            id: 'ReceiverId',
			            hidden: true

			        }, {
			            xtype: 'textfield',
			            name: 'ReceiverName',
			            cls: "line",
			            id: 'ReceiverName'

}]
			        }
			    , { items: { html: "复核人", width: 60} },
			    { colspan: 2, items: [
			        {
			            xtype: 'textfield',
			            name: 'CheckOper',
			            cls: "line",
			            id: 'CheckOper',
			            hidden: true
			        }, {
			            xtype: 'textfield',
			            name: 'CheckOperName',
			            cls: "line",
			            id: 'CheckOperName'
}]
			        }
			    , { colspan: 8, items: { html: '', height: 10} },
			    { items: { html: "备注", width: 60} },
			    { colspan: 7, items:
			        [{
			            xtype: 'textarea',
			            name: 'CheckMemo',
			            id: 'CheckMemo',
			            width: '100%'

			        }, {
			            xtype: 'hidden',
			            name: 'CustomerId',
			            id: 'CustomerId',
			            hideLabel: true
}]
			        }
           ]
         }
         );

        var checkForm = new Ext.Window(
         {
             iconCls: 'upload-win'
		    , layout: 'fit'
		    , plain: true
		    , modal: true
		    , constrain: true
		    , resizable: false
		    , closeAction: 'hide'
		    , autoDestroy: true,
             width: 780,
             height: 420,
             items: checkForm1,
             buttons: [{
                 text: "保存"
			, handler: function() {
			    saveCheck();
			}
			, scope: this
             },
		{
		    text: "取消"
			, handler: function() {
			    checkForm.hide();
			}
			, scope: this
}]
         });

        Ext.getCmp("BillOperName").on("focus", selectEmp);
        Ext.getCmp("ReceiverName").on("focus", selectEmp);
        Ext.getCmp("CheckOperName").on("focus", selectEmp);
        var current = "";
        function selectEmp(v) {
            current = v.id;
            if (selectEmpForm == null) {
                showEmpForm(0, '员工选择', '../ba/sysadmin/frmAdmAuthorize.aspx?method=gettreecolumnlist');
                selectEmpTree.on('checkchange', treeCheckChange, selectEmpTree);
                Ext.getCmp("btnOk").on("click", selectOK);
            }
            else {
                showEmpForm(0, '员工选择', '../ba/sysadmin/frmAdmAuthorize.aspx?method=gettreecolumnlist');
            }
        }

        function treeCheckChange(node, checked) {
            selectEmpTree.un('checkchange', treeCheckChange, selectEmpTree);
            if (checked) {
                var selectNodes = selectEmpTree.getChecked();
                for (var i = 0; i < selectNodes.length; i++) {
                    if (selectNodes[i].id != node.id) {
                        selectNodes[i].ui.toggleCheck(false);
                        selectNodes[i].attributes.checked = false;
                    }
                }
            }
            selectEmpTree.on('checkchange', treeCheckChange, selectEmpTree);
        }

        function selectOK() {
            var selectNodes = selectEmpTree.getChecked();
            if (selectNodes.length > 0) {
                switch (current) {
                    case "ReceiverName":
                        Ext.getCmp("ReceiverName").setValue(selectNodes[0].text);
                        Ext.getCmp("ReceiverId").setValue(selectNodes[0].id);
                        break;
                    case "CheckOperName":
                        Ext.getCmp("CheckOperName").setValue(selectNodes[0].text);
                        Ext.getCmp("CheckOper").setValue(selectNodes[0].id);
                        break;
                    case "BillOperName":
                        Ext.getCmp("BillOperName").setValue(selectNodes[0].text);
                        Ext.getCmp("BillOper").setValue(selectNodes[0].id);
                        break;
                }

            }
        }


        function saveCheck() {
            /*------开始获取界面数据的函数 start---------------*/
            Ext.MessageBox.wait('正在保存数据中, 请稍候……');
            var json = '';
            checkDtlGridData.each(function(checkDtlGridData) {
                json += Ext.util.JSON.encode(checkDtlGridData.data) + ',';
            });

            var checkType = radioGroup.getValue();
            if (checkType != null) {
                checkType = checkType.inputValue;
            }
            Ext.Ajax.request({
                url: 'frmScmPurchaseOrderCheck.aspx?method=save',
                method: 'POST',
                params: {
                    CheckOrg: Ext.getCmp('CheckOrg').getValue(),
                    CustomerName: Ext.getCmp('CustomerName').getValue(),
                    CustomerPhone: Ext.getCmp('CustomerPhone').getValue(),
                    BillNo: Ext.getCmp('BillNo').getValue(),
                    BillDate: Ext.getCmp('BillDate').getValue(),
                    Receiver: Ext.getCmp('ReceiverId').getValue(),
                    CheckOper: Ext.getCmp('CheckOper').getValue(),
                    CheckMemo: Ext.getCmp('CheckMemo').getValue(),
                    BillOper: Ext.getCmp("BillOper").getValue(),
                    CheckType: checkType,
                    CustomerId: Ext.getCmp('CustomerId').getValue(),
                    detail: json
                },
                success: function(resp, opts) {
                    Ext.MessageBox.hide();
                    if (checkExtMessage(resp)) {
                        checkForm.hide();
                        gridStore.reload();
                    }
                },
                failure: function(resp, opts) {
                    Ext.MessageBox.hide();
                    Ext.Msg.alert("提示", "保存失败");
                }
            });
        }
    })
</script>

<body>
    <form id="form1" runat="server">
    <div id="toolbar"></div>
    <div id="searchForm"></div>
    <div id="gird"></div>
    </form>
</body>
</html>
