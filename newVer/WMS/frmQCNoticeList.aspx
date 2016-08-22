<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmQCNoticeList.aspx.cs" Inherits="WMS_frmQCNoticeList" %>

<html>
<head>
<title>质检通知单列表页面</title><meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<link rel="stylesheet" type="text/css" href="../ext3/resources/css/ext-all.css" />
<script type="text/javascript" src="../ext3/adapter/ext/ext-base.js"></script>
<script type="text/javascript" src="../ext3/ext-all.js"></script>
<script type="text/javascript" src="../ext3/src/locale/ext-lang-zh_CN.js"></script>
</head>
<body>
<div id='toolbar'></div>
<div id='divSearchForm'></div>
<div id='divForm'></div>
<div id='divOrderGrid'></div>

</body>
<%=getComboBoxStore()%>
<script type="text/javascript">
    var states = [['1', '质检完成'], ['0', '质检未完成'], ['2', '报告完成']];
    
    Ext.BLANK_IMAGE_URL = "../ext3/resources/images/default/s.gif";
    Ext.onReady(function() {
        /*------实现toolbar的函数 start---------------*/
        var windowTitle = "";
        var Toolbar = new Ext.Toolbar({
            renderTo: "toolbar",
            items: [{
                text: "生成降级入仓单",
                icon: "../theme/1/images/extjs/customer/add16.gif",
                handler: function() { 
                    generateInStockOrderWin(); 
                }
            }, '-', 
            {
                text: "查看质检单",
                icon: "../theme/1/images/extjs/customer/add16.gif",
                handler: function() { 
                    lookQCNoticeOrderWin(); 
                }
            }]
        });
        /*------结束toolbar的函数 end---------------*/
        /*------开始ToolBar事件函数 start---------------*//*-----新增Order实体类窗体函数----*/
        function updateDataGrid() {
            var WhId = WhNamePanel.getValue();
            var SupplierName = SupplierNamePanel.getValue();
            var StartDate = Ext.util.Format.date(StartDatePanel.getValue(),'Y/m/d');
            var EndDate = Ext.util.Format.date(EndDatePanel.getValue(),'Y/m/d');
            var CheckStatus = CheckStatusPanel.getValue();

            userGridData.baseParams.WhId = WhId;
            userGridData.baseParams.SupplierName = SupplierName;
            userGridData.baseParams.StartDate = StartDate;
            userGridData.baseParams.EndDate = EndDate;
            userGridData.baseParams.CheckStatus = CheckStatus;
            
            userGridData.load({
                params: {
                    start: 0,
                    limit: 10
                }
            });

        }
        function lookQCNoticeOrderWin() {
            var sm = userGrid.getSelectionModel();
            //获取选择的数据信息
            var selectData = sm.getSelected();
            if (selectData == null) {
                Ext.Msg.alert("提示", "请选择质检通知单记录！");
                return;
            }
            if (selectData.data.CheckStatus != "2") {
                Ext.Msg.alert("提示", "该质检报告单尚未生成！");
                return;
            }
            showresult(selectData.data.ProductNo, selectData.data.CheckId);
        }
        //生成入库单
        function generateInStockOrderWin() {
            var sm = userGrid.getSelectionModel();
            //获取选择的数据信息
            var selectData = sm.getSelected();
            if (selectData == null) {
                Ext.Msg.alert("提示", "请选择质检通知单记录！");
                return;
            }
            var type = "W0211";
            if (selectData.data.CheckType == "Q0901") {
                type = "W0211";
            }
            else if (selectData.data.CheckType == "Q0902") {
                type = "W0212";
            }
            uploadOrderWindow.show();
            document.getElementById("editIFrame").src = "frmInStockBill.aspx?type=" + type + "&id=" + selectData.data.DeliveryNo + "&productId=" + selectData.data.ProductNo + "&checkId=" + selectData.data.CheckId;
        }
        /*-----察看Order实体类窗体函数----*/
        function lookOrderWin() {
            var status = "readonly";
            uploadPurchaseOrderWindow.setTitle("查看进货单详细信息");
            openOrderWin(status);
        }
        function confirmOrderWin() {
            var status = "confirm";
            uploadPurchaseOrderWindow.setTitle("确认进货单商品数量");
            openOrderWin(status);
        }
        function confirmPriceOrderWin() {
            var status = "confirmprice";
            uploadPurchaseOrderWindow.setTitle("确认进货单商品价格");
            openOrderWin(status);
        }
        function openOrderWin(status) {
            //alert(status);
            var sm = userGrid.getSelectionModel();
            var selectData = sm.getSelected();
            if (selectData == null) {
                Ext.Msg.alert("提示", "请选中需要查看的信息！");
                return;
            }
            uploadPurchaseOrderWindow.show();
            document.getElementById("editPurchaseIFrame").src = "frmPurchaseOrderEdit.aspx?status=" + status + "&id=" + selectData.data.OrderId;
        }
        /*------开始界面数据的窗体 Start---------------*/
        if (typeof (uploadOrderWindow) == "undefined") {//解决创建2个windows问题
            uploadOrderWindow = new Ext.Window({
                id: 'Orderformwindow'
	            , iconCls: 'upload-win'
	            , width: 750
	            , height: 515
	            , layout: 'fit'
	            , plain: true
	            , modal: true
	            , constrain: true
	            , resizable: false
	            , closeAction: 'hide'
	            , autoDestroy: true
	            , html: '<iframe id="editIFrame" width="100%" height="100%" border=0 src="frmInStockBill.aspx"></iframe>'
            });
        }
        uploadOrderWindow.addListener("hide", function() {
            updateDataGrid();
        });

        if (typeof (uploadPurchaseOrderWindow) == "undefined") {//解决创建2个windows问题
            uploadPurchaseOrderWindow = new Ext.Window({
                id: 'PurchaseOrderWindow'
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
	            , html: '<iframe id="editPurchaseIFrame" width="100%" height="100%" border=0 src="frmPurchaseOrderEdit.aspx"></iframe>'
            });
        }
        uploadPurchaseOrderWindow.addListener("hide", function() {
        });

        /*------开始获取界面数据的函数 start---------------*/
        function getFormValue() {
            var dateCreateDate = Ext.get("CreateDate").getValue();
            if (dateCreateDate != '')
                dateCreateDate = Ext.util.Format.date(dateCreateDate,'Y/m/d');

            Ext.Ajax.request({
                url: 'frmPurchaseOrderList.aspx?method=SaveOrder',
                method: 'POST',
                params: {
                    OrderId: Ext.getCmp('OrderId').getValue(),
                    SupplierId: Ext.getCmp('SupplierId').getValue(),
                    WhId: Ext.getCmp('WhId').getValue(),
                    OrgId: Ext.getCmp('OrgId').getValue(),
                    OwnerId: Ext.getCmp('OwnerId').getValue(),
                    OperId: Ext.getCmp('OperId').getValue(),
                    CreateDate: dateCreateDate,
                    UpdateDate: Ext.getCmp('UpdateDate').getValue(),
                    BillType: Ext.getCmp('BillType').getValue(),
                    FromBillId: Ext.getCmp('FromBillId').getValue(),
                    BillStatus: Ext.getCmp('BillStatus').getValue(),
                    Remark: Ext.getCmp('Remark').getValue()
                },
                success: function(resp, opts) {
                    Ext.Msg.alert("提示", "保存成功！");
                },
                failure: function(resp, opts) {
                    Ext.Msg.alert("提示", "保存失败！");
                }
            });
        }
        /*------结束获取界面数据的函数 End---------------*/

        /*------开始界面数据的函数 Start---------------*/
        function setFormValue(selectData) {
            Ext.Ajax.request({
                url: 'frmPurchaseOrderList.aspx?method=getPurchaseOrder',
                params: {
                    OrderId: selectData.data.OrderId
                },
                success: function(resp, opts) {
                    var data = Ext.util.JSON.decode(resp.responseText);
                    Ext.getCmp("OrderId").setValue(data.OrderId);
                    Ext.getCmp("SupplierId").setValue(data.SupplierId);
                    Ext.getCmp("WhId").setValue(data.WhId);
                    Ext.getCmp("OrgId").setValue(data.OrgId);
                    Ext.getCmp("OwnerId").setValue(data.OwnerId);
                    Ext.getCmp("OperId").setValue(data.OperId);
                    if (data.CreateDate != '')
                        Ext.getCmp("CreateDate").setValue(Ext.util.Format.date(data.CreateDate,'Y/m/d'));
                    Ext.getCmp("UpdateDate").setValue(data.UpdateDate);
                    Ext.getCmp("BillType").setValue(data.BillType);
                    Ext.getCmp("FromBillId").setValue(data.FromBillId);
                    Ext.getCmp("BillStatus").setValue(data.BillStatus);
                    Ext.getCmp("Remark").setValue(data.Remark);
                },
                failure: function(resp, opts) {
                    Ext.Msg.alert("提示", "获取进货信息失败！");
                }
            });
        }
        /*------结束设置界面数据的函数 End---------------*/

        /*------开始查询form的函数 start---------------*/
        var SupplierNamePanel = new Ext.form.TextField({
            name: 'SupplierName',
            id: 'SupplierName',
            fieldLabel: '供货单位',
            anchor: '90%',
            listeners: { specialkey: function(f, e) { if (e.getKey() == e.ENTER) { Ext.getCmp('SWhName').focus(); } } }

        });
        var WhNamePanel = new Ext.form.ComboBox({
            name: 'warehouseCombo',
            store: dsWarehouseList,
            displayField: 'WhName',
            valueField: 'WhId',
            typeAhead: true, //自动将第一个搜索到的选项补全输入
            triggerAction: 'all',
            emptyText: '请选择仓库',
            selectOnFocus: true,
            forceSelection: true,
            mode: 'local',
            fieldLabel: '仓库名称',
            anchor: '90%',
            id: 'SWhName',
            listeners: { specialkey: function(f, e) { if (e.getKey() == e.ENTER) { Ext.getCmp('BillStatus').focus(); } } }
        });
        var ckstore = new Ext.data.ArrayStore({
            fields: ['id', 'state'],
            data: states
        });
        var CheckStatusPanel = new Ext.form.ComboBox({
            store: ckstore,
            displayField: 'state',
            valueField: 'id',
            typeAhead: true,
            mode: 'local',
            triggerAction: 'all',
            emptyText: '选择质检状态',
            selectOnFocus: true,
            fieldLabel: '质检状态',
            id: 'CheckStatus',
            anchor: '90%'
        });
        var BillStatusPanel = new Ext.form.ComboBox({
            name: 'billStatusCombo',
            store: dsBillStatus,
            displayField: 'BillStatusName',
            valueField: 'BillStatusId',
            typeAhead: true, //自动将第一个搜索到的选项补全输入
            triggerAction: 'all',
            value: 0, //未入仓
            selectOnFocus: true,
            forceSelection: true,
            editable: false,
            mode: 'local',
            fieldLabel: '单据状态',
            anchor: '90%',
            id: 'BillStatus',
            listeners: { specialkey: function(f, e) { if (e.getKey() == e.ENTER) { Ext.getCmp('StartDate').focus(); } } }
        });
        var StartDatePanel = new Ext.form.DateField({
            style: 'margin-left:0px',
            cls: 'key',
            xtype: 'datefield',
            fieldLabel: '开始时间',
            format: 'Y年m月d日',
            anchor: '90%',
            value: new Date().getFirstDateOfMonth().clearTime(),
            id: 'StartDate',
            listeners: { specialkey: function(f, e) { if (e.getKey() == e.ENTER) { Ext.getCmp('EndDate').focus(); } } }
        });
        var EndDatePanel = new Ext.form.DateField({
            style: 'margin-left:0px',
            cls: 'key',
            xtype: 'datefield',
            fieldLabel: '结束时间',
            anchor: '90%',
            format: 'Y年m月d日',
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
            items: [
            {
                layout: 'column',   //定义该元素为布局为列布局方式
                border: false,
                items: [
                {
                    columnWidth: .3,  //该列占用的宽度，标识为20％
                    layout: 'form',
                    border: false,
                    items: [
                        SupplierNamePanel
                    ]
                }, {
                    columnWidth: .3,
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
                        CheckStatusPanel//BillStatusPanel
                    ]
                }]
            },
            {
                layout: 'column',   //定义该元素为布局为列布局方式
                border: false,
                items: [
                {
                    columnWidth: .3,  //该列占用的宽度，标识为20％
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
                    items: [
                    {   
                        cls: 'key',
                        xtype: 'button',
                        text: '查询',
                        id: 'searchebtnId',
                        anchor: '50%',
                        handler: function() {
                            updateDataGrid();
                        }
                    }]
                }]
            }]
        });

        /*------开始查询form的函数 end---------------*/

        /*------开始获取数据的函数 start---------------*/
        var userGridData = new Ext.data.Store
        ({
            url: 'frmQCNoticeList.aspx?method=getQCNoticeList',
            reader: new Ext.data.JsonReader({
                totalProperty: 'totalProperty',
                root: 'root'
            }, [
            { name: 'CheckId' },
		    { name: 'CheckType' },
		    { name: 'DeliveryNo' },
		    { name: 'OrderDtlId' },
            { name: 'ShipNo' },
		    { name: 'ProviderNo' },
            { name: 'ProductNo' },
            { name: 'ProductName' },
            { name: 'NocheckNo' },
            { name: 'RepresentAmount' },
            { name: 'NocheckNo' },
		    { name: 'DeliveryDate' },
            { name: 'Location' },
            { name: 'CheckStatus' },
            { name: 'ProductDate' },
            { name: 'Note' },
            { name: 'ProviderName' },
		    { name: 'CreateDate' },
		    { name: 'OperId' },
		    { name: 'OwnDept' }
            ]),
            listeners:
            {
                scope: this,
                load: function() {
                }
            }
        });

        /*------获取数据的函数 结束 End---------------*/

        /*------开始DataGrid的函数 start---------------*/

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
            loadMask: { msg: '正在加载数据，请稍侯……' },
            sm: sm,
            cm: new Ext.grid.ColumnModel([
	            sm,
	            new Ext.grid.RowNumberer(), //自动行号
                //{ header: '所属公司', dataIndex: 'OwnDept' },
	            {header: '质检类型', dataIndex: 'CheckType', renderer: rendererQCType },
	            { header: '货单编号', dataIndex: 'DeliveryNo' },
	            { header: '车船号', dataIndex: 'ShipNo' },
                //{ header: '供应商编号', hiddataIndex: 'ProviderNo' },
			    {header: '供货单位', dataIndex: 'ProviderName' },
			    { header: '产品编号', dataIndex: 'ProductNo' },
			    { header: '产品名称', dataIndex: 'ProductName' },
			    { header: '代表量', dataIndex: 'RepresentAmount' },
			    { header: '未检测量', dataIndex: 'NocheckNo' },
			    { header: '进仓日期', dataIndex: 'ProductDate' },
			    { header: '放置地点', dataIndex: 'Location', renderer: rendererWarehouse },
			    { header: '质检状态', dataIndex: 'CheckStatus', renderer: cktp}
			]),
            bbar: new Ext.PagingToolbar({
                pageSize: 10,
                store: userGridData,
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
        userGrid.render();
        /*------DataGrid的函数结束 End---------------*/
        updateDataGrid();

        function cktp(val) {
            var index = CheckStatusPanel.getStore().find('id', val);
            if (index < 0)
                return "";
            var record = CheckStatusPanel.getStore().getAt(index);
            return record.data.state;
        }

        function rendererWarehouse(val, params, record) {
            dsWarehouseList.each(function(r) {
                if (val == r.data['WhId']) {
                    val = r.data['WhName'];
                    return;
                }
            });
            return val;
        }

        function rendererQCType(val, params, record) {
            dsCheckType.each(function(r) {
                if (val == r.data['DicsCode']) {
                    val = r.data['DicsName'];
                    return;
                }
            });
            return val;
        }

        //==============
        if (typeof (resultWindow) == "undefined") {//解决创建2个windows问题
            var resultWindow = new Ext.Window({
                title: '新增指标',
                modal: 'true',
                width: 600,
                y: 50,
                autoHeigth: true,
                collapsible: true, //是否可以折叠 
                closable: true, //是否可以关闭 
                //maximizable : true,//是否可以最大化 
                closeAction: 'hide',
                constrain: true,
                resizable: false,
                plain: true,
                // ,items: addQuotaForm
                buttons: [{
                    text: '关闭',
                    handler: function() {
                        resultWindow.hide();
                        var s = result.getEl().dom.lastChild.lastChild;
                        var ss = s.childNodes;
                        var sss = ss.length;
                        s.removeChild(ss[sss - 1]);
                    }
                }]
            });
        }

        var result = new Ext.Panel({
            // html: 'asdada'
        });
        var resultFmForm = new Ext.form.FormPanel({
            labelWidth: 70,
            autoWidth: true,
            frame: true,
            autoHeight: true,
            items: [result]
        });
        resultWindow.add(resultFmForm);

        function showresult(prno, checkid) {
            Ext.Ajax.request({
                url: "frmQCNoticeList.aspx?method=showQCNotice"
               , params: {
                   checkid: checkid  //质检单号
                    , prno: prno              //商品ID(唯一编号)
               },
                success: function(response, options) {
                    var data = response.responseText;
                    var divobj = document.createElement("div");
                  
                    if (data == "") {
                        Ext.Msg.alert("提示", "质检报告尚未生成！");
                        return;
                    }
                    resultWindow.show();
                    divobj.innerHTML = data;
                    result.getEl().dom.lastChild.lastChild.appendChild(divobj);

                },
                failure: function() {
                    Ext.Msg.alert("提示", "获取指标配置项出错,请重新打开该页！");
                }
            });
        }
    })
</script>

</html>
