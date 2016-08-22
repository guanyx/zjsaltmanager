<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmTransmitMain.aspx.cs" Inherits="SCM_frmTransitDistribute" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html>
<head>
    <title>���˷���</title>
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
    /*------ʵ��toolbar�ĺ��� start---------------*/
    var Toolbar = new Ext.Toolbar({
        renderTo: "toolbar",
        items: [{
            text: "���з���",
            icon: "../Theme/1/images/extjs/customer/edit16.gif",
            handler: function() {
                opType = 'save';
                distributMstWin();
            }
        }, {
            text: "����ȷ��",
            icon: "../Theme/1/images/extjs/customer/save.gif",
            handler: function() {
                opType = 'confirm';
                distributMstWin();
            }
        }, {
            text: "�������䲢ȷ��",
            icon: "../Theme/1/images/extjs/customer/save.gif",
            handler: function() {
                batchConfirm();
            }
        }, {
            text: "ȡ��ȷ��",
            icon: "../Theme/1/images/extjs/customer/save.gif",
            handler: function() {
                opType = 'confirm';
                cancelAllCommit();
            }
        }, {
            text: "�����޸�",
            icon: "../Theme/1/images/extjs/customer/edit16.gif",
            handler: function() {
                opType = 'edit';
                distributMstWin();
            }
}]
        });

        /*------����toolbar�ĺ��� end---------------*/


        /*------��ʼToolBar�¼����� start---------------*//*-----����Mstʵ���ര�庯��----*/
        function cancelAllCommit() {
            var sm = distributeGrid.getSelectionModel();
            //��ȡѡ���������Ϣ
            //var selectData =  sm.getSelected();
            var selectData = sm.getSelected();
            if (selectData == null) {
                Ext.Msg.alert("��ʾ", "��ѡһ����Ҫ�������Ϣ��");
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
                    Ext.Msg.alert("��ʾ", "ȡ��ʧ��");
                    return;
                }
            });

        }
        /*-----���˷���Mstʵ���ര�庯��----*/
        function distributMstWin() {
            var sm = distributeGrid.getSelectionModel();
            //��ȡѡ���������Ϣ
            //var selectData =  sm.getSelected();
            var records = sm.getSelections();
            if (records == null || records.length != 1) {
                Ext.Msg.alert("��ʾ", "��ѡһ����Ҫ�������Ϣ��");
                return;
            }
            else {
                var selectData = sm.getSelected();
                //���з���
                distributting(selectData);
            }
        }

        function distributting(selectData) {
            //���״̬
            if (opType == 'save') {
                if (selectData.data.Status != 'S251'
                && selectData.data.Status != 'S252') {
                    Ext.Msg.alert("��ʾ", "��ѡ���¼����Ҫ���з��䣡");
                    return;
                }
            }
            if (opType == 'confirm') {
                if (selectData.data.Status != 'S253') {
                    Ext.Msg.alert("��ʾ", "��ѡ���¼����ȫ������״̬������ȷ�ϣ�");
                    return;
                }
            }
            if (opType == 'edit') {
                if (selectData.data.Status > 'S254') {
                    Ext.Msg.alert("��ʾ", "��ѡ���¼�Ѿ�����ȷ�ϣ������޸ģ�");
                    return;
                }
                if (selectData.data.Status != 'S254') {
                    Ext.Msg.alert("��ʾ", "��ѡ���¼���Ƿֽ�ȷ��״̬������Ҫ�����޸ģ�������ѡ�񡰽��з��䡱�˵���");
                    return;
                }
            }
            //��window
            uploadTransWindow.show();
            uploadTransWindow.setTitle("���˵����˷���"); //alert(selectData.data.DrawInvId);
            document.getElementById("DistributeIFrame").src = "frmTransitDistribute.aspx?SendId=" + selectData.data.SendId
            + "&opType=" + opType + "&" + Math.random();
        }
        function batchConfirm() {
            var sm = distributeGrid.getSelectionModel();
            //��ȡѡ���������Ϣ
            //var selectData =  sm.getSelected();
            var records = sm.getSelections();
            if (records == null) {
                Ext.Msg.alert("��ʾ", "��ѡ��Ҫ�������Ϣ��");
                return;
            }
            else {
                json = "";
                dsDistributeGrid.each(function(r) {
                    json += Ext.util.JSON.encode(r.data.SendId) + ',';
                });
                json = json.substring(0, json.length - 1);
                //�жϵ�վ�Ƿ�һ��
                //ҳ���ύ
                Ext.Msg.wait("�����жϵ�վ�Ƿ�һ�£����Ժ󡭡�");
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
                            Ext.Msg.alert("��ʾ��Ϣ", "ѡ��ļ�¼" + data.info + "��������������");
                            return;
                        }
                    },
                    failure: function(resp, opts) {
                        Ext.MessageBox.hide();
                        Ext.Msg.alert("��ʾ", "����ж�ʧ��");
                        return;
                    }
                });

                //�����������䲢ȷ��
                Ext.Msg.wait("���ڷ��䲢ȷ�ϣ����Ժ󡭡�");
                //ҳ���ύ
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
                        Ext.Msg.alert("��ʾ", "�������䲢ȷ�ϲ���ʧ��");
                    }
                });
            }
        }
        /*------��ʼ��ȡ���ݵĺ��� start---------------*/
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

        /*------��ȡ���ݵĺ��� ���� End---------------*/
        /*------��ʼ��ѯform end---------------*/

        //��ʼ����
        var distributeStartPanel = new Ext.form.DateField({
            xtype: 'datefield',
            fieldLabel: '������ʼ����',
            anchor: '95%',
            name: 'StartDate',
            id: 'StartDate',
            format: 'Y��m��d��',  //���������ʽ
            value: new Date().clearTime()
        });

        //��������
        var distributeEndPanel = new Ext.form.DateField({
            xtype: 'datefield',
            fieldLabel: '������������',
            anchor: '95%',
            name: 'EndDate',
            id: 'EndDate',
            format: 'Y��m��d��',  //���������ʽ
            value: new Date().clearTime()
        });

        var distributePostPanel = new Ext.form.TextField({
            style: 'margin-left:0px',
            cls: 'key',
            xtype: 'textfield',
            fieldLabel: '��վ��Ϣ',
            name: 'nameCust',
            anchor: '95%'
        });
        
        var ArriveShipPanel = new Ext.form.TextField({
                style: 'margin-left:0px',
                cls: 'key',
                xtype: 'textfield',
                fieldLabel: '������',
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
                layout: 'column',   //�����Ԫ��Ϊ����Ϊ�в��ַ�ʽ
                border: false,
                items: [{
                    columnWidth: .25,  //����ռ�õĿ�ȣ���ʶΪ20��
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
                        text: '��ѯ',
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
                    /*------��ʼ��ѯform end---------------*/
                    /*------��ʼDataGrid�ĺ��� start---------------*/

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
                        title: '������',
                        store: dsDistributeGrid,
                        loadMask: { msg: '���ڼ������ݣ����Ժ��' },
                        sm: sm,
                        cm: new Ext.grid.ColumnModel([
		sm,
		new Ext.grid.RowNumberer(), //�Զ��к�
		{
		header: '��Ӧ�̷�������ʶ',
		dataIndex: 'SendId',
		id: 'SendId',
		hidden: true,
		hideable: false
},
		{
		    header: '��˾��ʶ (ʡ��˾)',
		    dataIndex: 'OrgId',
		    id: 'OrgId',
		    hidden: true,
		    hideable: false
		},
		{
		    header: '��Ӧ�̱�ʶ',
		    dataIndex: 'SupplierId',
		    id: 'SupplierId',
		    hidden: true,
		    hideable: false
		},
		{
		    header: '��Ӧ��',
		    dataIndex: 'OrgName',
		    id: 'OrgName',
		    hideable: false
		},
		{
		    header: '��������',
		    dataIndex: 'SendDate',
		    id: 'SendDate',
		    renderer: Ext.util.Format.dateRenderer('Y��m��d��')
		},
		{
		    header: '��Ʊ��',
		    dataIndex: 'Voucher',
		    id: 'Voucher'
		},
		{
		    header: '���ͬ�е���',
		    dataIndex: 'TransportNo',
		    id: 'TransportNo'
		},
		{
		    header: '׼��֤���',
		    dataIndex: 'NavicertNo',
		    id: 'NavicertNo'
		},
		{
		    header: '�ϼ�����',
		    dataIndex: 'TotalQty',
		    id: 'TotalQty'
		},
		{
		    header: '��˰���',
		    dataIndex: 'TotalAmt',
		    id: 'TotalAmt'
		},
		{
		    header: '˰��',
		    dataIndex: 'TotalTax',
		    id: 'TotalTax'
		},
		{
		    header: '����ʱ��',
		    dataIndex: 'CreateDate',
		    id: 'CreateDate',
		    renderer: Ext.util.Format.dateRenderer('Y��m��d��')
		},
		{
		    header: '״̬',
		    dataIndex: 'Status',
		    id: 'Status',
		    renderer: { fn: function(value, cellmeta, record, rowIndex, columnIndex, store) {
		        var index = dsStatus.findBy(function(record, id) {  // dsPayType Ϊ����Դ
		            return record.get('DicsCode') == value; //'DicsCode' Ϊ����Դ��id��
		        });
		        if (index == -1) return value;
		        var record = dsStatus.getAt(index);
		        return record.data.DicsName;  // DicsNameΪ����Դ��name��
		    }
		    }
}]),
                        viewConfig: {
                            columnsText: '��ʾ����',
                            scrollOffset: 20,
                            sortAscText: '����',
                            sortDescText: '����',
                            forceFit: true
                        },
                        enableHdMenu: false,  //����ʾ�����ֶκ���ʾ����������
                        enableColumnMove: false, //�в����ƶ�
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
                    /*------DataGrid�ĺ������� End---------------*/
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
                        title: '��������ϸ',
                        store: dsDistributeGridDtl,
                        loadMask: { msg: '���ڼ������ݣ����Ժ��' },
                        cm: new Ext.grid.ColumnModel([
		new Ext.grid.RowNumberer(), //�Զ��к�
		{
		header: '��ˮ��',
		dataIndex: 'SendDtlId',
		id: 'SendDtlId',
		hidden: true,
		hideable: false
},
		{
		    header: '��Ӧ�̷�������ʶ',
		    dataIndex: 'SendId',
		    id: 'SendId',
		    hidden: true,
		    hideable: false
		},
		{
		    header: '��Ʒ',
		    dataIndex: 'ProductId',
		    id: 'ProductId',
		    width: 100,
		    renderer: { fn: function(value, cellmeta, record, rowIndex, columnIndex, store) {

		        var index = dsProductList.findBy(function(record, id) {  // dsPayType Ϊ����Դ
		            return record.get('ProductId') == value; //'DicsCode' Ϊ����Դ��id��
		        });
		        if (index == -1) return "";
		        var nrecord = dsProductList.getAt(index);
		        return nrecord.data.ProductName;  // DicsNameΪ����Դ��name��
		    }
		    }
		},
		{
		    header: '����',
		    dataIndex: 'Qty',
		    id: 'Qty'
		},
		{
		    header: '����',
		    dataIndex: 'Price',
		    id: 'Price'
		},
		{
		    header: '���',
		    dataIndex: 'Amt',
		    id: 'Amt'
		},
		{
		    header: '˰��',
		    dataIndex: 'TaxRate',
		    id: 'TaxRate'
		},
		{
		    header: '˰��',
		    dataIndex: 'Tax',
		    id: 'Tax'
		},
		{
		    header: '��վ��Ϣ',
		    dataIndex: 'DestInfo',
		    id: 'DestInfo'
		},
		{
		    header: '������',
		    dataIndex: 'ShipNo',
		    id: 'ShipNo'
		}
		]),
                        viewConfig: {
                            columnsText: '��ʾ����',
                            scrollOffset: 20,
                            sortAscText: '����',
                            sortDescText: '����',
                            forceFit: true
                        },
                        closeAction: 'hide',
                        stripeRows: true,
                        loadMask: true,
                        autoExpandColumn: 3
                    });
                    DistributeGridDtl.render();
                    /*------��ϸDataGrid�ĺ������� End---------------*/

                    /*------- ���з����Ҽ�---start-----------------*/
                    distributeGrid.addListener('rowcontextmenu', showContextMenu);
                    function showContextMenu(distributeGrid, rowIndex, e) {
                        e.stopEvent();
                        var local = e.getXY();
                        var gridContextMenu = new Ext.menu.Menu({
                            items: [
        {
            text: '���з���',
            handler: function() {
                opType = 'save';
                var record = distributeGrid.getStore().getAt(rowIndex);
                //���з���
                distributting(record);
            }
        }, {
            text: '����ȷ��',
            handler: function() {
                opType = 'confirm';
                var record = distributeGrid.getStore().getAt(rowIndex);
                //����ȷ��
                distributting(record);
            }
}]
                        });
                        gridContextMenu.showAt([local[0], local[1]]);
                        e.preventDefault();
                    };
                    /*------- ���з����Ҽ�---end-----------------*/
                    /*------��ʼ�������ݵĴ��� Start---------------*/
                    if (typeof (uploadTransWindow) == "undefined") {//�������2��windows����
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
                        dsDistributeGrid.reload(); //ˢ������
                    });
                    /*------��ʼ�������ݵĴ��� End---------------*/


                })
</script>
</html>
