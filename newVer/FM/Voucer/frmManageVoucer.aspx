<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmManageVoucer.aspx.cs" Inherits="FM_Voucer_frmManageVoucer" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>ƾ֤ά��</title>
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
    /*------ʵ��toolbar�ĺ��� start---------------*/
    var Toolbar = new Ext.Toolbar({
        renderTo: "toolbar",
        items: [{
            text: "����ƾ֤",
            icon: "../../Theme/1/images/extjs/customer/add16.gif",
            handler: function() {
                sendPZ();
            }
            //    }, '-', {
            //        text: "�鿴",
            //        icon: "../Theme/1/images/extjs/customer/edit16.gif",
            //        handler: function() {  }
        }

            ]
    });
    /*------����toolbar�ĺ��� end---------------*/
    function sendPZ() {
        var sm = voucherGrid.getSelectionModel();
        //��ȡѡ���������Ϣ
        var selectData = sm.getSelections();
        //���û��ѡ�񣬾���ʾ��Ҫѡ��������Ϣ
        if (selectData == null || selectData == "") {
            Ext.Msg.alert("��ʾ", "��ѡ����Ҫ���͵ļ�¼��");
            return;
        }

        if (selectData.length > 1) {
            Ext.Msg.alert("��ʾ", "ϵͳĿǰֻ֧�ֵ���ƾ֤���͵�NC��");
            return;
        }

        var json = "";
        for (var i = 0; i < selectData.length; i++) {
            json = selectData[i].data.VoucherId + ',';
        }
        json = json.substring(0, json.length - 1);
        //alert(json);

        //check
        Ext.MessageBox.wait("ƾ֤�������ڷ��������Ժ󡭡�");
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
                VoucherId: json//��������id��
            },
            success: function(resp, opts) {
                if (checkExtMessage(resp)) {
                    Ext.MessageBox.hide();
                    var frm = document.getElementById('testVoucher');
                    document.body.removeChild(frm);
                    Ext.Msg.alert("��ʾ", "ƾ֤" + json + "���ͳɹ�");
                }    
            },
            failure: function(resp, opts) {
                Ext.MessageBox.hide();
                Ext.Msg.alert("��ʾ", "����ʧ��");
            }
        });
    }
    /*------��ʼ��ȡ���ݵĺ��� start---------------*/
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

    /*------��ȡ���ݵĺ��� ���� End---------------*/

    var defaultPageSize = 10;
    var toolBar = new Ext.PagingToolbar({
        pageSize: 10,
        store: voucherGridData,
        displayMsg: '��ʾ��{0}����{1}����¼,��{2}��',
        emptyMsy: 'û�м�¼',
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
        emptyText: '����ÿҳ��¼��',
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
    /*------��ʼDataGrid�ĺ��� start---------------*/

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
        loadMask: { msg: '���ڼ������ݣ����Ժ��' },
        sm: sm,
        cm: new Ext.grid.ColumnModel([
		sm,
		new Ext.grid.RowNumberer(), //�Զ��к�
		{
		header: '��˾����',
		dataIndex: 'Company',
		id: 'Company'
},
		{
		    header: 'ƾ֤���',
		    dataIndex: 'VoucherType',
		    id: 'VoucherType'
		},
		{
		    header: '������',
		    dataIndex: 'FiscalYear',
		    id: 'FiscalYear'
		},
		{
		    header: '����ڼ�',
		    dataIndex: 'AccountingPeriod',
		    id: 'AccountingPeriod'
		},
		{
		    header: 'ƾ֤��',
		    dataIndex: 'VoucherId',
		    id: 'VoucherId'
		},
		{
		    header: '��������',
		    dataIndex: 'AttachmentNumber',
		    id: 'AttachmentNumber'
		},
		{
		    header: '�Ƶ�����',
		    dataIndex: 'Prepareddate',
		    id: 'Prepareddate'
		},
		{
		    header: '�Ƶ���',
		    dataIndex: 'Enter',
		    id: 'Enter'
		},
        //		{
        //		    header: '����',
        //		    dataIndex: 'Cashier',
        //		    id: 'Cashier'
        //		},
        //		{
        //		    header: '�Ƿ�ǩ��',
        //		    dataIndex: 'Signature',
        //		    id: 'Signature'
        //		},
		{
		header: '�����',
		dataIndex: 'Checker',
		id: 'Checker'
},
		{
		    header: '��������',
		    dataIndex: 'PostingDate',
		    id: 'PostingDate'
		},
		{
		    header: '������',
		    dataIndex: 'PostingPerson',
		    id: 'PostingPerson'
		},
        //		{
        //		    header: '��Դϵͳ',
        //		    dataIndex: 'VoucherMakingSystem',
        //		    id: 'VoucherMakingSystem'
        //		},
        //		{
        //		    header: '��ע',
        //		    dataIndex: 'Memo1',
        //		    id: 'Memo1'
        //		},
        //		{
        //		    header: '��ע',
        //		    dataIndex: 'Memo2',
        //		    id: 'Memo2'
        //		},
        //		{
        //		    header: '��������',
        //		    dataIndex: 'Type',
        //		    id: 'Type'
        //		},
		{
		header: '״̬',
		dataIndex: 'Status',
		id: 'Status'
},
        //		{
        //		    header: '������֯',
        //		    dataIndex: 'OwnOrg',
        //		    id: 'OwnOrg'
        //		},
		{
		header: '��������',
		dataIndex: 'CreateDate',
		id: 'CreateDate'
},
        //		{
        //		    header: '������Ա',
        //		    dataIndex: 'OperId',
        //		    id: 'OperId'
        //		},
        //		{
        //		    header: '������֯',
        //		    dataIndex: 'OrgId',
        //		    id: 'OrgId'
        //		},
        //		{
        //		    header: '������',
        //		    dataIndex: 'OwnerId',
        //		    id: 'OwnerId'
        //		},
		{
		header: 'ƾ֤����',
		dataIndex: 'DicsName',
		id: 'DicsName'
}]),
        bbar: toolBar,
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
    voucherGrid.render();

    createSearch(voucherGrid, voucherGridData, "searchForm");
    searchForm.el = "searchForm";
    searchForm.render();
    /*------DataGrid�ĺ������� End---------------*/

    this.getCmbStore = function(columnName) {
    }

})
</script>
</html>
