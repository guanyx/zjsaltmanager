<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmScmNoticeMain.aspx.cs" Inherits="SCM_frmScmNoticeMain" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>结算价维护</title>
 <link rel="stylesheet" type="text/css" href="../ext3/resources/css/ext-all.css" />
<script type="text/javascript" src="../ext3/adapter/ext/ext-base.js"></script>
<script type="text/javascript" src="../ext3/ext-all.js"></script>
<script type="text/javascript" src="../js/operateResp.js"></script>
<script type="text/javascript" src="../js/FilterControl.js"></script>
<script type="text/javascript" src="../js/floatUtil.js"></script>
<script type="text/javascript" src="../js/EmpSelect.js"></script>
<script type="text/javascript" src="../ext3/src/locale/ext-lang-zh_CN.js"></script>
<script type="text/javascript" src="../js/getExcelXml.js"></script>
<link rel="Stylesheet" type="text/css" href="../css/gridPrint.css" />

<style type="text/css">  
.line{ BORDER-LEFT-STYLE: none; BORDER-RIGHT-STYLE: none; BORDER-TOP-STYLE: none}
.x-grid-back-blue { 
background: #B7CBE8; 
}
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
                return store;
           
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
            text: "结算",
            icon: imageUrl + "images/extjs/customer/add16.gif",
            handler: function() {
                checkOrders();
                addSelectedRows();
                //radioGroup.setValue('2');
            }
        }]
        });


        function checkOrders() {
            var sm11 = Ext.getCmp('viewGrid').getSelectionModel();
            //获取选择的数据信息
            var selectDatas = sm11.getSelections();
            for (var i = 0; i < selectDatas.length; i++) {
                if (selectDatas[i].data.IsSettle == 1) {
                    Ext.Msg.alert("提示", "不能多次结算！");
                    return;
                }
            }
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
		            { header: '明细编号',
		                dataIndex: 'NoticeDtlId',
		                id: 'NoticeDtlId',
		                hidden: true,
		                hideable:true
		            },
	                {   header: '编号',
	                    dataIndex: 'NoticeId',
	                    id: 'NoticeId',
	                    width: 60,
		                hidden: true,
		                hideable:true
	                },
                    { header: '供应商名称',
                        dataIndex: 'ShortName',
                        id: 'ShortName',
                        width: 80
                    },
		            { header: '车船号',
		                dataIndex: 'VehicleNo',
		                id: 'VehicleNo',
		                width: 90
		            },
		            { header: '采购单位',
		                dataIndex: 'OrgShortName',
		                id: 'OrgShortName',
		                width: 130
		            },
		            { header: '商品编号',
		                dataIndex: 'ProductNo',
		                id: 'ProductNo',
		                width: 60
		            },
		            { header: '商品名称',
		                dataIndex: 'ProductName',
		                id: 'ProductName',
		                width: 150
		            },
		            {
		                header: '规格',
		                dataIndex: 'Specifications',
		                width: 50,
		                id: 'Specifications'
		            },
		            { header: '商品单位',
		                dataIndex: 'UnitId',
		                id: 'UnitId',
		                width: 60,
		                renderer:getUnitName
		            },
		            { header: '发运数量',
		                dataIndex: 'InvoiceQty',
		                id: 'InvoiceQty',
		                width: 60
		            },
		            { header: '发运价格',
		                dataIndex: 'Price',
		                id: 'Price',
		                width: 60
		            },
		            { header: '确认数量',
		                dataIndex: 'ConfirmQty',
		                id: 'ConfirmQty',
		                width: 60
		            },
		            { header: '结算价格',
		                dataIndex: 'SettlePrice',
		                id: 'SettlePrice',
		                width: 60,
		                tooltip: '实际总额'
		            },
		            { header: '是否结算',
		                dataIndex: 'IsSettle',
		                id: 'IsSettle',
		                width: 60,
		                renderer: function(v) { if (v == 1) return '<font color="blue">是</font>'; else return '<font color="red">否</font>'; },
		                tooltip: '是否结算'
		            },
//		            { header: '状态',
//		                dataIndex: 'Status',
//		                id: 'Status',
//		                width: 60
//		            },
		            {   header: '创建日期',
		                dataIndex: 'CreateDate',
		                id: 'CreateDate',
		                width: 100,
		                renderer: Ext.util.Format.dateRenderer('Y年m月d日')
		            }
            	]
        });
        var gridStore = new Ext.data.Store({
            url: 'frmScmNoticeMain.aspx?method=getnoticelist',
            reader: new Ext.data.JsonReader({
                totalProperty: 'totalProperty',
                root: 'root',
                fields: [
                { name: 'NoticeDtlId' },
                { name: 'NoticeId' },
                { name: 'ShortName', type: 'string' },
                { name: 'VehicleNo', type: 'string' },
                { name: 'OrgShortName', type: 'string' },
                { name: 'ProductNo', type: 'string' },
                { name: 'ProductName', type: 'string' },
                { name: 'Specifications', type: 'string' },
                { name: 'UnitId', type: 'string' },
                { name: 'InvoiceQty', type: 'float' },
                { name: 'ConfirmQty', type: 'float' },
                { name: 'Price', type: 'float' },
                { name: 'SettlePrice', type: 'float' },
                { name: 'IsSettle', type: 'string' },
                //{ name: 'Status', type: 'string' },
                { name: 'CreateDate', type: 'date' }
                ]
            }),
            sortData: function(f, direction) {
                var tempSort = Ext.util.JSON.encode(inOutGridData.sortInfo);
                if (sortInfor != tempSort) {
                    sortInfor = tempSort;
                    inOutGridData.baseParams.SortInfo = sortInfor;
                    inOutGridData.load({ params: { limit: 10, start: 0} });
                }
            }
        });


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
            bbar: new Ext.PagingToolbar({
                pageSize: 10,
                store: gridStore,
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
            stripeRows: true,
            height: 350,
            width: document.body.clientWidth,
            title: '子公司发运单信息'

        });
        viewGrid.render();

        createSearch(viewGrid, viewGrid.getStore(), "searchForm");
        //setControlVisibleByField();
        btnExpert.setVisible(true);
        defaultPageSize = 10;
        searchForm.el = "searchForm";
        searchForm.render();
        /******************DtlGrid*****************************/

        var checkDtlGridData = new Ext.data.Store
        ({
            reader: new Ext.data.JsonReader({
                totalProperty: 'totalProperty',
                root: 'root'
            }, [
	        {
	            name: 'NoticeDtlId'
	        },
	        {
	            name: 'NoticeId'
	        },
	        {
	            name: 'VehicleNo'
	        },
	        {
	            name: 'ProductNo'
	        },
	        {
	            name: 'ProductName'
	        },
	        {
	            name: 'UnitId'
	        },
	        {
	            name: 'InvoiceQty'
            },
	        {
	            name: 'ConfirmQty'
            },
	        {
	            name: 'Price'
            },
	        {
	            name: 'SettlePrice'
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
        function getUnitName(value, cellmeta, record, rowIndex, columnIndex, store) {
            var index = dsUnitList.find('UnitId',value);
            if (index < 0)
                return "";
            var record = dsUnitList.getAt(index);
            return record.data.UnitName;

        }


        function addSelectedRows() {
            var sm1 = Ext.getCmp('viewGrid').getSelectionModel();
            //获取选择的数据信息
            var selectData = sm1.getSelections();
            var ids = "";
            for (var i = 0; i < selectData.length; i++) {
                var rowCount = checkDtlGrid.getStore().getCount();
                var insertPos = parseInt(rowCount);
                var addRow = new headPattern({
                    NoticeDtlId: selectData[i].data.NoticeDtlId,
                    NoticeId: selectData[i].data.NoticeId,
                    VehicleNo: selectData[i].data.VehicleNo,
                    ProductNo: selectData[i].data.ProductNo,
                    ProductName: selectData[i].data.ProductName, 
                    UnitId:selectData[i].data.UnitId,
                    InvoiceQty: selectData[i].data.InvoiceQty,
                    ConfirmQty: selectData[i].data.ConfirmQty,
                    Price: selectData[i].data.Price,
                    SettlePrice: selectData[i].data.Price
                });
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
//            var height = 100;
//            if (selectData.length > 5) {

//                height = selectData.length * 25;
//            }
//            if (height > 200)
//                height = 200;
//            checkDtlGrid.setHeight(height);
        }
        var headPattern = Ext.data.Record.create([
           { name: 'NoticeDtlId' },
           { name: 'NoticeId' },
           { name: 'VehicleNo' },
	        { name: 'ProductNo' },
	        { name: 'ProductName' },
	        { name: 'UnitId' },
	        { name: 'InvoiceQty' },
	        { name: 'ConfirmQty' },
	        { name: 'Price' },
	        { name: 'SettlePrice' }
          ]);


        /*------开始DataGrid的函数 start---------------*/

        var sm = new Ext.grid.CheckboxSelectionModel({
            singleSelect: true
        });
        var checkDtlGrid = new Ext.grid.EditorGridPanel({
            width: '100%',
            height: 400,
            autoWidth: true,
            //autoHeight:true,
	        region: 'center',
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
		            header: '编号',
		            dataIndex: 'NoticeId',
		            id: 'NoticeId',
		            hidden:true,
		            hideable:true
		        },
		        {
		            header: '明细编号',
		            dataIndex: 'NoticeDtlId',
		            id: 'NoticeDtlId',
		            hidden:true,
		            hideable:true
		        },
		        {
		            header: '车船号',
		            dataIndex: 'VehicleNo',
		            width: 60,
		            id: 'VehicleNo'
                },
		        {
		            header: '产品编号',
		            dataIndex: 'ProductNo',
		            width: 60,
		            id: 'ProductNo'
                },
		        {
		            header: '产品名称',
		            dataIndex: 'ProductName',
		            width: 150,
		            id: 'ProductName'
                },
	            {
	                header: '单位',
	                dataIndex: 'UnitId',
	                width: 50,
	                id: 'UnitId',
	                renderer: getUnitName
	            },
	            {
	                header: '数量',
	                dataIndex: 'InvoiceQty',
	                width: 60,
	                align: 'right',
	                id: 'InvoiceQty'
	            },
	            {
	                header: '价格',
	                dataIndex: 'Price',
	                width: 70,
	                align: 'right',
	                id: 'Price'
	            },
	            {
	                header: '实收数',
	                dataIndex: 'ConfirmQty',
	                width: 60,
	                align: 'right',
	                id: 'ConfirmQty'
	            },
	            {
	                header: '结算价',
	                dataIndex: 'SettlePrice',
	                width: 70,
	                id: 'SettlePrice',
	                editor: new Ext.form.NumberField({	                    
                        align: 'right'
	                }),
	                align: 'right',
	                renderer: function(v, m) {
                        m.css = 'x-grid-back-blue';
                        return v;
                    }
	            }]),
            viewConfig: {
                columnsText: '显示的列',
                scrollOffset: 20,
                sortAscText: '升序',
                sortDescText: '降序',
                forceFit: false
            },
            closeAction: 'hide',
            stripeRows: true,
            loadMask: true
        });

        var checkForm = new Ext.Window(
         {
             iconCls: 'upload-win'
		    , layout: 'border'
		    , plain: true
		    , modal: true
		    , constrain: true
		    , resizable: false
		    , closeAction: 'hide'
		    , autoDestroy: true,
             width: 650,
             height: 350,
             items: [checkDtlGrid],
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


        function saveCheck() {
            /*------开始获取界面数据的函数 start---------------*/
            Ext.MessageBox.wait('正在保存数据中, 请稍候……');
            var json = '';
            checkDtlGridData.each(function(checkDtlGridData) {
                json += Ext.util.JSON.encode(checkDtlGridData.data) + ',';
            });
            
            Ext.Ajax.request({
                url: 'frmScmNoticeMain.aspx?method=saveNotice',
                method: 'POST',
                params: {
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
