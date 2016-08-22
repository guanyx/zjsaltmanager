<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmTransmitMain.aspx.cs" Inherits="SCM_frmTransitDistribute" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html>
<head>
    <title>调运分配</title>
    <meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
    <link rel="stylesheet" type="text/css" href="../ext3/resources/css/ext-all.css" />
    <script type="text/javascript" src="../ext3/adapter/ext/ext-base.js"></script>
    <script type="text/javascript" src="../ext3/ext-all.js"></script>
    <script type="text/javascript" src="../js/operateResp.js"></script>
    <script type="text/javascript" src="../ext3/src/locale/ext-lang-zh_CN.js"></script>
</head>
<body>
<div id='toolbar'></div>
<div id='searchForm'></div>
<div id='sendGrid'></div>
<div id='sendDtlGrid'></div>
<%=getComboBoxStore() %>
</body>
<script type="text/javascript">
Ext.BLANK_IMAGE_URL = "../ext3/resources/images/default/s.gif";
var uploadTransWindow;
Ext.onReady(function() {
    var opType;
    /*------实现toolbar的函数 start---------------*/
    var Toolbar = new Ext.Toolbar({
        renderTo: "toolbar",
        items: [{
            text: "进行分配",
            icon: "../Theme/1/images/extjs/customer/edit16.gif",
            handler: function() {
                opType = 'save';
                distributMstWin();
            }
        }, {
            text: "进行确认",
            icon: "../Theme/1/images/extjs/customer/save.gif",
            handler: function() {
                opType = 'confirm';
                distributMstWin();
            }
        }, {
            text: "批量分配并确认",
            icon: "../Theme/1/images/extjs/customer/save.gif",
            handler: function() {
                batchConfirm();
            }
        }, {
            text: "取消确认",
            icon: "../Theme/1/images/extjs/customer/save.gif",
            handler: function() {
                opType = 'confirm';
                cancelAllCommit();
            }
        }, {
            text: "特殊修改",
            icon: "../Theme/1/images/extjs/customer/edit16.gif",
            handler: function() {
                opType = 'edit';
                distributMstWin();
            }
}]
        });

        /*------结束toolbar的函数 end---------------*/


        /*------开始ToolBar事件函数 start---------------*//*-----新增Mst实体类窗体函数----*/
        function cancelAllCommit() {
            var sm = distributeGrid.getSelectionModel();
            //获取选择的数据信息
            //var selectData =  sm.getSelected();
            var selectData = sm.getSelected();
            if (selectData == null) {
                Ext.Msg.alert("提示", "请选一条需要分配的信息！");
                return;
            }
            Ext.Ajax.request({
                url: 'frmTransmitMain.aspx?method=cancelCommin',
                method: 'POST',
                params: {
                    SendId: selectData.data.SendId
                },
                success: function(resp, opts) {
                    if (checkExtMessage(resp)) {
                    }
                },
                failure: function(resp, opts) {
                    Ext.Msg.alert("提示", "取消失败");
                    return;
                }
            });

        }
        /*-----调运分配Mst实体类窗体函数----*/
        function distributMstWin() {
            var sm = distributeGrid.getSelectionModel();
            //获取选择的数据信息
            //var selectData =  sm.getSelected();
            var records = sm.getSelections();
            if (records == null || records.length != 1) {
                Ext.Msg.alert("提示", "请选一条需要分配的信息！");
                return;
            }
            else {
                var selectData = sm.getSelected();
                //进行分配
                distributting(selectData);
            }
        }

        function distributting(selectData) {
            //检查状态
            if (opType == 'save') {
                if (selectData.data.Status != 'S251'
                && selectData.data.Status != 'S252') {
                    Ext.Msg.alert("提示", "您选择记录不需要进行分配！");
                    return;
                }
            }
            if (opType == 'confirm') {
                if (selectData.data.Status != 'S253') {
                    Ext.Msg.alert("提示", "您选择记录不是全部分配状态，不能确认！");
                    return;
                }
            }
            if (opType == 'edit') {
                if (selectData.data.Status > 'S254') {
                    Ext.Msg.alert("提示", "您选择记录已经到货确认，不能修改！");
                    return;
                }
                if (selectData.data.Status != 'S254') {
                    Ext.Msg.alert("提示", "您选择记录不是分解确认状态，不需要特殊修改，您可以选择“进行分配”菜单！");
                    return;
                }
            }
            //开window
            uploadTransWindow.show();
            uploadTransWindow.setTitle("发运单调运分配"); //alert(selectData.data.DrawInvId);
            document.getElementById("DistributeIFrame").src = "frmTransitDistribute.aspx?SendId=" + selectData.data.SendId
            + "&opType=" + opType + "&" + Math.random();
        }
        function batchConfirm() {
            var sm = distributeGrid.getSelectionModel();
            //获取选择的数据信息
            //var selectData =  sm.getSelected();
            var records = sm.getSelections();
            if (records == null) {
                Ext.Msg.alert("提示", "请选需要分配的信息！");
                return;
            }
            else {
                json = "";
                dsDistributeGrid.each(function(r) {
                    json += Ext.util.JSON.encode(r.data.SendId) + ',';
                });
                json = json.substring(0, json.length - 1);
                //判断到站是否一致
                //页面提交
                Ext.Msg.wait("正在判断到站是否一致，请稍后……");
                Ext.Ajax.request({
                    url: 'frmTransmitMain.aspx?method=checkBatchSendStation',
                    method: 'POST',
                    params: {
                        json: json
                    },
                    success: function(resp, opts) {
                        Ext.Msg.hide();
                        var data = Ext.util.JSON.decode(resp.responseText);
                        if (data.sucess == 'fase') {
                            Ext.Msg.alert("提示信息", "选择的记录" + data.info + "不能批量操作！");
                            return;
                        }
                    },
                    failure: function(resp, opts) {
                        Ext.MessageBox.hide();
                        Ext.Msg.alert("提示", "检查判断失败");
                        return;
                    }
                });

                //进行批量分配并确认
                Ext.Msg.wait("正在分配并确认，请稍后……");
                //页面提交
                Ext.Ajax.request({
                    url: 'frmTransmitMain.aspx?method=batchDistributAndComfirm',
                    method: 'POST',
                    params: {
                        json: json
                    },
                    success: function(resp, opts) {
                        Ext.Msg.hide();
                        if (checkExtMessage(resp)) {
                            dsDistributeGrid.reload();
                        }
                    },
                    failure: function(resp, opts) {
                        Ext.MessageBox.hide();
                        Ext.Msg.alert("提示", "批量分配并确认操作失败");
                    }
                });
            }
        }
        /*------开始获取数据的函数 start---------------*/
        var dsDistributeGrid = new Ext.data.Store
({
    url: 'frmTransmitMain.aspx?method=getProvideSendList',
    reader: new Ext.data.JsonReader({
        totalProperty: 'totalProperty',
        root: 'root'
    }, [
	{ name: 'SendId' },
	{ name: 'OrgId' },
	{ name: 'OrgName' },
	{ name: 'SupplierId' },
	{ name: 'SupplierName' },
	{ name: 'SendDate' },
	{ name: 'Voucher' },
	{ name: 'TransportNo' },
	{ name: 'VehicleNo' },
	{ name: 'NavicertNo' },
	{ name: 'TotalQty' },
	{ name: 'TotalAmt' },
	{ name: 'TotalTax' },
	{ name: 'DtlCount' },
	{ name: 'InstorInfo' },
	{ name: 'OperId' },
	{ name: 'CreateDate' },
	{ name: 'UpdateDate' },
	{ name: 'OwnerId' },
	{ name: 'Status' },
	{ name: 'Remark' },
	{ name: 'IsActive' }
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
        /*------开始查询form end---------------*/

        //开始日期
        var distributeStartPanel = new Ext.form.DateField({
            xtype: 'datefield',
            fieldLabel: '发货开始日期',
            anchor: '95%',
            name: 'StartDate',
            id: 'StartDate',
            format: 'Y年m月d日',  //添加中文样式
            value: new Date().clearTime()
        });

        //结束日期
        var distributeEndPanel = new Ext.form.DateField({
            xtype: 'datefield',
            fieldLabel: '发货结束日期',
            anchor: '95%',
            name: 'EndDate',
            id: 'EndDate',
            format: 'Y年m月d日',  //添加中文样式
            value: new Date().clearTime()
        });

        var distributePostPanel = new Ext.form.TextField({
            style: 'margin-left:0px',
            cls: 'key',
            xtype: 'textfield',
            fieldLabel: '到站信息',
            name: 'nameCust',
            anchor: '95%'
        });
        
        var ArriveShipPanel = new Ext.form.TextField({
                style: 'margin-left:0px',
                cls: 'key',
                xtype: 'textfield',
                fieldLabel: '车船号',
                name: 'nameCust',
                anchor: '95%'
            });
            
        var serchform = new Ext.FormPanel({
            renderTo: 'searchForm',
            labelAlign: 'left',
            layout: 'fit',
            buttonAlign: 'right',
            bodyStyle: 'padding:5px',
            frame: true,
            labelWidth: 80,
            items: [{
                layout: 'column',   //定义该元素为布局为列布局方式
                border: false,
                items: [{
                    columnWidth: .25,  //该列占用的宽度，标识为20％
                    layout: 'form',
                    border: false,
                    items: [
                        distributeStartPanel
                ]
                }, {
                    columnWidth: .25,
                    layout: 'form',
                    border: false,
                    items: [
                        distributeEndPanel
                    ]
                }, {
                    name: 'cusStyle',
                    columnWidth: .21,
                    layout: 'form',
                    border: false,
                    labelWidth: 55,
                    items: [
                        distributePostPanel
                    ]
                }, {
                    name: 'cusStyle',
                    columnWidth: .21,
                    layout: 'form',
                    border: false,
                    labelWidth: 55,
                    items: [
                        ArriveShipPanel
                    ]
                }, {
                    columnWidth: .08,
                    layout: 'form',
                    border: false,
                    items: [{ cls: 'key',
                        xtype: 'button',
                        text: '查询',
                        anchor: '50%',
                        handler: function() {

                            var starttime = distributeStartPanel.getValue();
                            var endtime = distributeEndPanel.getValue();
                            var postinfo = distributePostPanel.getValue();
                            var shipno = ArriveShipPanel.getValue();

                            dsDistributeGrid.baseParams.StartSendDate = Ext.util.Format.date(starttime, 'Y/m/d');
                            dsDistributeGrid.baseParams.EndSendDate = Ext.util.Format.date(endtime, 'Y/m/d');
                            dsDistributeGrid.baseParams.InstorInfo = postinfo;
                            dsDistributeGrid.baseParams.ShipNo=shipno;

                            dsDistributeGrid.load({
                                params: {
                                    start: 0,
                                    limit: 32767
                                }
                            });
                        }
}]
}]
}]
                    });
                    /*------开始查询form end---------------*/
                    /*------开始DataGrid的函数 start---------------*/

                    var sm = new Ext.grid.CheckboxSelectionModel({
                        singleSelect: false
                    });
                    var distributeGrid = new Ext.grid.GridPanel({
                        el: 'sendGrid',
                        width: '100%',
                        //height:'100%',
                        height: 300,
                        autoWidth: true,
                        //autoHeight:true,
                        autoScroll: true,
                        layout: 'fit',
                        title: '发货单',
                        store: dsDistributeGrid,
                        loadMask: { msg: '正在加载数据，请稍侯……' },
                        sm: sm,
                        cm: new Ext.grid.ColumnModel([
		sm,
		new Ext.grid.RowNumberer(), //自动行号
		{
		header: '供应商发货单标识',
		dataIndex: 'SendId',
		id: 'SendId',
		hidden: true,
		hideable: false
},
		{
		    header: '公司标识 (省公司)',
		    dataIndex: 'OrgId',
		    id: 'OrgId',
		    hidden: true,
		    hideable: false
		},
		{
		    header: '供应商标识',
		    dataIndex: 'SupplierId',
		    id: 'SupplierId',
		    hidden: true,
		    hideable: false
		},
		{
		    header: '供应商',
		    dataIndex: 'OrgName',
		    id: 'OrgName',
		    hideable: false
		},
		{
		    header: '发货日期',
		    dataIndex: 'SendDate',
		    id: 'SendDate',
		    renderer: Ext.util.Format.dateRenderer('Y年m月d日')
		},
		{
		    header: '发票号',
		    dataIndex: 'Voucher',
		    id: 'Voucher'
		},
		{
		    header: '随货同行单号',
		    dataIndex: 'TransportNo',
		    id: 'TransportNo'
		},
		{
		    header: '准运证编号',
		    dataIndex: 'NavicertNo',
		    id: 'NavicertNo'
		},
		{
		    header: '合计数量',
		    dataIndex: 'TotalQty',
		    id: 'TotalQty'
		},
		{
		    header: '含税金额',
		    dataIndex: 'TotalAmt',
		    id: 'TotalAmt'
		},
		{
		    header: '税额',
		    dataIndex: 'TotalTax',
		    id: 'TotalTax'
		},
		{
		    header: '创建时间',
		    dataIndex: 'CreateDate',
		    id: 'CreateDate',
		    renderer: Ext.util.Format.dateRenderer('Y年m月d日')
		},
		{
		    header: '状态',
		    dataIndex: 'Status',
		    id: 'Status',
		    renderer: { fn: function(value, cellmeta, record, rowIndex, columnIndex, store) {
		        var index = dsStatus.findBy(function(record, id) {  // dsPayType 为数据源
		            return record.get('DicsCode') == value; //'DicsCode' 为数据源的id列
		        });
		        if (index == -1) return value;
		        var record = dsStatus.getAt(index);
		        return record.data.DicsName;  // DicsName为数据源的name列
		    }
		    }
}]),
                        viewConfig: {
                            columnsText: '显示的列',
                            scrollOffset: 20,
                            sortAscText: '升序',
                            sortDescText: '降序',
                            forceFit: true
                        },
                        enableHdMenu: false,  //不显示排序字段和显示的列下拉框
                        enableColumnMove: false, //列不能移动
                        closeAction: 'hide',
                        stripeRows: true,
                        loadMask: true,
                        autoExpandColumn: 2
                    });
                    distributeGrid.render();
                    /*dblclick*/
                    distributeGrid.on({
                        rowdblclick: function(grid, rowIndex, e) {
                            var rec = grid.store.getAt(rowIndex);
                            //alert(rec.get("SendId"));
                            dsDistributeGridDtl.baseParams.SendId = rec.get("SendId");
                            dsDistributeGridDtl.load();
                        }
                    });
                    /*------DataGrid的函数结束 End---------------*/
                    var dsDistributeGridDtl = new Ext.data.Store
({
    url: 'frmTransmitMain.aspx?method=getProvideSendDtl',
    reader: new Ext.data.JsonReader({
        totalProperty: 'totalProperty',
        root: 'root'
    },
   [{ name: 'SendDtlId', type: 'string' },
   { name: 'SendId', type: 'string' },
   { name: 'ProductId', type: 'string' },
   { name: 'Qty', type: 'string' },
   { name: 'Price', type: 'string' },
   { name: 'Amt', type: 'string' },
   { name: 'Tax', type: 'string' },
   { name: 'TaxRate', type: 'string' },
   { name: 'DestInfo', type: 'string' },
   { name: 'ShipNo', type: 'string'}]
   )
});
                    var DistributeGridDtl = new Ext.grid.GridPanel({
                        el: 'sendDtlGrid',
                        layout: 'fit',
                        width: '100%',
                        //height:'100%',
                        autoWidth: true,
                        //autoHeight:true,
                        height: 130,
                        autoScroll: true,
                        layout: 'fit',
                        title: '发货单明细',
                        store: dsDistributeGridDtl,
                        loadMask: { msg: '正在加载数据，请稍侯……' },
                        cm: new Ext.grid.ColumnModel([
		new Ext.grid.RowNumberer(), //自动行号
		{
		header: '流水号',
		dataIndex: 'SendDtlId',
		id: 'SendDtlId',
		hidden: true,
		hideable: false
},
		{
		    header: '供应商发货单标识',
		    dataIndex: 'SendId',
		    id: 'SendId',
		    hidden: true,
		    hideable: false
		},
		{
		    header: '商品',
		    dataIndex: 'ProductId',
		    id: 'ProductId',
		    width: 100,
		    renderer: { fn: function(value, cellmeta, record, rowIndex, columnIndex, store) {

		        var index = dsProductList.findBy(function(record, id) {  // dsPayType 为数据源
		            return record.get('ProductId') == value; //'DicsCode' 为数据源的id列
		        });
		        if (index == -1) return "";
		        var nrecord = dsProductList.getAt(index);
		        return nrecord.data.ProductName;  // DicsName为数据源的name列
		    }
		    }
		},
		{
		    header: '数量',
		    dataIndex: 'Qty',
		    id: 'Qty'
		},
		{
		    header: '单价',
		    dataIndex: 'Price',
		    id: 'Price'
		},
		{
		    header: '金额',
		    dataIndex: 'Amt',
		    id: 'Amt'
		},
		{
		    header: '税率',
		    dataIndex: 'TaxRate',
		    id: 'TaxRate'
		},
		{
		    header: '税额',
		    dataIndex: 'Tax',
		    id: 'Tax'
		},
		{
		    header: '到站信息',
		    dataIndex: 'DestInfo',
		    id: 'DestInfo'
		},
		{
		    header: '车船号',
		    dataIndex: 'ShipNo',
		    id: 'ShipNo'
		}
		]),
                        viewConfig: {
                            columnsText: '显示的列',
                            scrollOffset: 20,
                            sortAscText: '升序',
                            sortDescText: '降序',
                            forceFit: true
                        },
                        closeAction: 'hide',
                        stripeRows: true,
                        loadMask: true,
                        autoExpandColumn: 3
                    });
                    DistributeGridDtl.render();
                    /*------明细DataGrid的函数结束 End---------------*/

                    /*------- 进行分配右键---start-----------------*/
                    distributeGrid.addListener('rowcontextmenu', showContextMenu);
                    function showContextMenu(distributeGrid, rowIndex, e) {
                        e.stopEvent();
                        var local = e.getXY();
                        var gridContextMenu = new Ext.menu.Menu({
                            items: [
        {
            text: '进行分配',
            handler: function() {
                opType = 'save';
                var record = distributeGrid.getStore().getAt(rowIndex);
                //进行分配
                distributting(record);
            }
        }, {
            text: '进行确认',
            handler: function() {
                opType = 'confirm';
                var record = distributeGrid.getStore().getAt(rowIndex);
                //进行确认
                distributting(record);
            }
}]
                        });
                        gridContextMenu.showAt([local[0], local[1]]);
                        e.preventDefault();
                    };
                    /*------- 进行分配右键---end-----------------*/
                    /*------开始界面数据的窗体 Start---------------*/
                    if (typeof (uploadTransWindow) == "undefined") {//解决创建2个windows问题
                        uploadTransWindow = new Ext.Window({
                            id: 'DistributeTransWindow'
        , iconCls: 'upload-win'
        , height: 500
        , width: 800
                            //        , x:window.screen.width/2 -500
                            //        , y:window.screen.height/2 -300
                            //, autoWidth: true
                            //, autoHeight: true
        , layout: 'fit'
        , plain: true
        , modal: true
                            //, border:false
        , constrain: true
        , resizable: false
        , closeAction: 'hide'
        , autoDestroy: true
        , html: '<iframe id="DistributeIFrame" width="100%" height="100%" border=0 src="#"></iframe>'
                            //,autoScroll:true
                        });
                    }
                    uploadTransWindow.addListener("hide", function() {
                        dsDistributeGrid.reload(); //刷新数据
                    });
                    /*------开始界面数据的窗体 End---------------*/


                })
</script>
</html>
