<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmManageVoucer.aspx.cs" Inherits="FM_Voucer_frmManageVoucer" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>凭证维护</title>
    <meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
    <link rel="stylesheet" type="text/css" href="../../ext3/resources/css/ext-all.css" />
    <script type="text/javascript" src="../../ext3/adapter/ext/ext-base.js"></script>
    <script type="text/javascript" src="../../ext3/ext-all.js"></script>
    <script type="text/javascript" src="../../js/operateResp.js"></script>
     <script type="text/javascript" src="../../js/FilterControl.js"></script>
</head>
<body>
<div id='toolbar'></div>
<div id='searchForm'></div>
<div id='voucherGridDiv'></div>
</body>
<%=getComboBoxStore()%>
<script type="text/javascript">
Ext.BLANK_IMAGE_URL = "../../ext3/resources/images/default/s.gif";
Ext.onReady(function() {
    /*------实现toolbar的函数 start---------------*/
    var Toolbar = new Ext.Toolbar({
        renderTo: "toolbar",
        items: [{
            text: "发送凭证",
            icon: "../../Theme/1/images/extjs/customer/add16.gif",
            handler: function() {
                sendPZ();
            }
            //    }, '-', {
            //        text: "查看",
            //        icon: "../Theme/1/images/extjs/customer/edit16.gif",
            //        handler: function() {  }
        }

            ]
    });
    /*------结束toolbar的函数 end---------------*/
    function sendPZ() {
        var sm = voucherGrid.getSelectionModel();
        //获取选择的数据信息
        var selectData = sm.getSelections();
        //如果没有选择，就提示需要选择数据信息
        if (selectData == null || selectData == "") {
            Ext.Msg.alert("提示", "请选择需要发送的记录！");
            return;
        }

        if (selectData.length > 1) {
            Ext.Msg.alert("提示", "系统目前只支持单条凭证发送到NC！");
            return;
        }

        var json = "";
        for (var i = 0; i < selectData.length; i++) {
            json = selectData[i].data.VoucherId + ',';
        }
        json = json.substring(0, json.length - 1);
        //alert(json);

        //check
        Ext.MessageBox.wait("凭证数据正在发生，请稍后……");
        if (!Ext.fly('test')) {
            var frm = document.createElement('form');
            frm.id = 'testVoucher';
            frm.name = id;
            frm.style.display = 'none';
            document.body.appendChild(frm);
        }

        Ext.Ajax.request({
            url: 'frmManageVoucer.aspx?method=sendPZ',
            form: Ext.fly('test'),
            method: 'POST',
            isUpload: true,
            params: {
                VoucherId: json//传入多项的id串
            },
            success: function(resp, opts) {
                if (checkExtMessage(resp)) {
                    Ext.MessageBox.hide();
                    var frm = document.getElementById('testVoucher');
                    document.body.removeChild(frm);
                    Ext.Msg.alert("提示", "凭证" + json + "发送成功");
                }    
            },
            failure: function(resp, opts) {
                Ext.MessageBox.hide();
                Ext.Msg.alert("提示", "发送失败");
            }
        });
    }
    /*------开始获取数据的函数 start---------------*/
    var voucherGridData = new Ext.data.Store
                        ({
                            url: 'frmManageVoucer.aspx?method=getpzlist',
                            reader: new Ext.data.JsonReader({
                                totalProperty: 'totalProperty',
                                root: 'root'
                            }, [
                                { name: 'Company' },
                                { name: 'VoucherType' },
                                { name: 'FiscalYear' },
                                { name: 'AccountingPeriod' },
                                { name: 'VoucherId' },
                                { name: 'AttachmentNumber' },
                                { name: 'Prepareddate' },
                                { name: 'Enter' },
                                { name: 'Cashier' },
                                { name: 'Signature' },
                                { name: 'Checker' },
                                { name: 'PostingDate' },
                                { name: 'PostingPerson' },
                                { name: 'VoucherMakingSystem' },
                                { name: 'Memo1' },
                                { name: 'Memo2' },
                                { name: 'Reserve1' },
                                { name: 'Reserve2' },
                                { name: 'Type' },
                                { name: 'Status' },
                                { name: 'OwnOrg' },
                                { name: 'CreateDate' },
                                { name: 'OperId' },
                                { name: 'OrgId' },
                                { name: 'OwnerId' },
                                { name: 'DicsName'}]),
                            listeners:
	            {
	                scope: this,
	                load: function() {
	                }
	            }
                        });

    /*------获取数据的函数 结束 End---------------*/

    var defaultPageSize = 10;
    var toolBar = new Ext.PagingToolbar({
        pageSize: 10,
        store: voucherGridData,
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
        toolBar.doLoad(0);
    }, toolBar);
    /*------开始DataGrid的函数 start---------------*/

    var sm = new Ext.grid.CheckboxSelectionModel({
        singleSelect: false
    });
    var voucherGrid = new Ext.grid.GridPanel({
        el: 'voucherGridDiv',
        width: '100%',
        height: '100%',
        autoWidth: true,
        autoHeight: true,
        autoScroll: true,
        layout: 'fit',
        id: 'voucherGrid',
        store: voucherGridData,
        loadMask: { msg: '正在加载数据，请稍侯……' },
        sm: sm,
        cm: new Ext.grid.ColumnModel([
		sm,
		new Ext.grid.RowNumberer(), //自动行号
		{
		header: '公司主键',
		dataIndex: 'Company',
		id: 'Company'
},
		{
		    header: '凭证类别',
		    dataIndex: 'VoucherType',
		    id: 'VoucherType'
		},
		{
		    header: '会计年度',
		    dataIndex: 'FiscalYear',
		    id: 'FiscalYear'
		},
		{
		    header: '会计期间',
		    dataIndex: 'AccountingPeriod',
		    id: 'AccountingPeriod'
		},
		{
		    header: '凭证号',
		    dataIndex: 'VoucherId',
		    id: 'VoucherId'
		},
		{
		    header: '附单据数',
		    dataIndex: 'AttachmentNumber',
		    id: 'AttachmentNumber'
		},
		{
		    header: '制单日期',
		    dataIndex: 'Prepareddate',
		    id: 'Prepareddate'
		},
		{
		    header: '制单人',
		    dataIndex: 'Enter',
		    id: 'Enter'
		},
        //		{
        //		    header: '出纳',
        //		    dataIndex: 'Cashier',
        //		    id: 'Cashier'
        //		},
        //		{
        //		    header: '是否签字',
        //		    dataIndex: 'Signature',
        //		    id: 'Signature'
        //		},
		{
		header: '审核人',
		dataIndex: 'Checker',
		id: 'Checker'
},
		{
		    header: '记账日期',
		    dataIndex: 'PostingDate',
		    id: 'PostingDate'
		},
		{
		    header: '记账人',
		    dataIndex: 'PostingPerson',
		    id: 'PostingPerson'
		},
        //		{
        //		    header: '来源系统',
        //		    dataIndex: 'VoucherMakingSystem',
        //		    id: 'VoucherMakingSystem'
        //		},
        //		{
        //		    header: '备注',
        //		    dataIndex: 'Memo1',
        //		    id: 'Memo1'
        //		},
        //		{
        //		    header: '备注',
        //		    dataIndex: 'Memo2',
        //		    id: 'Memo2'
        //		},
        //		{
        //		    header: '费用类型',
        //		    dataIndex: 'Type',
        //		    id: 'Type'
        //		},
		{
		header: '状态',
		dataIndex: 'Status',
		id: 'Status'
},
        //		{
        //		    header: '归属组织',
        //		    dataIndex: 'OwnOrg',
        //		    id: 'OwnOrg'
        //		},
		{
		header: '创建日期',
		dataIndex: 'CreateDate',
		id: 'CreateDate'
},
        //		{
        //		    header: '创建人员',
        //		    dataIndex: 'OperId',
        //		    id: 'OperId'
        //		},
        //		{
        //		    header: '创建组织',
        //		    dataIndex: 'OrgId',
        //		    id: 'OrgId'
        //		},
        //		{
        //		    header: '所有者',
        //		    dataIndex: 'OwnerId',
        //		    id: 'OwnerId'
        //		},
		{
		header: '凭证类型',
		dataIndex: 'DicsName',
		id: 'DicsName'
}]),
        bbar: toolBar,
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
    voucherGrid.render();

    createSearch(voucherGrid, voucherGridData, "searchForm");
    searchForm.el = "searchForm";
    searchForm.render();
    /*------DataGrid的函数结束 End---------------*/

    this.getCmbStore = function(columnName) {
    }

})
</script>
</html>
