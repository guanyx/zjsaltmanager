<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmQCNoticeList.aspx.cs" Inherits="WMS_frmQCNoticeList" %>

<html>
<head>
<title>�ʼ�֪ͨ���б�ҳ��</title><meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
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
    var states = [['1', '�ʼ����'], ['0', '�ʼ�δ���'], ['2', '�������']];
    
    Ext.BLANK_IMAGE_URL = "../ext3/resources/images/default/s.gif";
    Ext.onReady(function() {
        /*------ʵ��toolbar�ĺ��� start---------------*/
        var windowTitle = "";
        var Toolbar = new Ext.Toolbar({
            renderTo: "toolbar",
            items: [{
                text: "���ɽ�����ֵ�",
                icon: "../theme/1/images/extjs/customer/add16.gif",
                handler: function() { 
                    generateInStockOrderWin(); 
                }
            }, '-', 
            {
                text: "�鿴�ʼ쵥",
                icon: "../theme/1/images/extjs/customer/add16.gif",
                handler: function() { 
                    lookQCNoticeOrderWin(); 
                }
            }]
        });
        /*------����toolbar�ĺ��� end---------------*/
        /*------��ʼToolBar�¼����� start---------------*//*-----����Orderʵ���ര�庯��----*/
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
            //��ȡѡ���������Ϣ
            var selectData = sm.getSelected();
            if (selectData == null) {
                Ext.Msg.alert("��ʾ", "��ѡ���ʼ�֪ͨ����¼��");
                return;
            }
            if (selectData.data.CheckStatus != "2") {
                Ext.Msg.alert("��ʾ", "���ʼ챨�浥��δ���ɣ�");
                return;
            }
            showresult(selectData.data.ProductNo, selectData.data.CheckId);
        }
        //������ⵥ
        function generateInStockOrderWin() {
            var sm = userGrid.getSelectionModel();
            //��ȡѡ���������Ϣ
            var selectData = sm.getSelected();
            if (selectData == null) {
                Ext.Msg.alert("��ʾ", "��ѡ���ʼ�֪ͨ����¼��");
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
        /*-----�쿴Orderʵ���ര�庯��----*/
        function lookOrderWin() {
            var status = "readonly";
            uploadPurchaseOrderWindow.setTitle("�鿴��������ϸ��Ϣ");
            openOrderWin(status);
        }
        function confirmOrderWin() {
            var status = "confirm";
            uploadPurchaseOrderWindow.setTitle("ȷ�Ͻ�������Ʒ����");
            openOrderWin(status);
        }
        function confirmPriceOrderWin() {
            var status = "confirmprice";
            uploadPurchaseOrderWindow.setTitle("ȷ�Ͻ�������Ʒ�۸�");
            openOrderWin(status);
        }
        function openOrderWin(status) {
            //alert(status);
            var sm = userGrid.getSelectionModel();
            var selectData = sm.getSelected();
            if (selectData == null) {
                Ext.Msg.alert("��ʾ", "��ѡ����Ҫ�鿴����Ϣ��");
                return;
            }
            uploadPurchaseOrderWindow.show();
            document.getElementById("editPurchaseIFrame").src = "frmPurchaseOrderEdit.aspx?status=" + status + "&id=" + selectData.data.OrderId;
        }
        /*------��ʼ�������ݵĴ��� Start---------------*/
        if (typeof (uploadOrderWindow) == "undefined") {//�������2��windows����
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

        if (typeof (uploadPurchaseOrderWindow) == "undefined") {//�������2��windows����
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

        /*------��ʼ��ȡ�������ݵĺ��� start---------------*/
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
                    Ext.Msg.alert("��ʾ", "����ɹ���");
                },
                failure: function(resp, opts) {
                    Ext.Msg.alert("��ʾ", "����ʧ�ܣ�");
                }
            });
        }
        /*------������ȡ�������ݵĺ��� End---------------*/

        /*------��ʼ�������ݵĺ��� Start---------------*/
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
                    Ext.Msg.alert("��ʾ", "��ȡ������Ϣʧ�ܣ�");
                }
            });
        }
        /*------�������ý������ݵĺ��� End---------------*/

        /*------��ʼ��ѯform�ĺ��� start---------------*/
        var SupplierNamePanel = new Ext.form.TextField({
            name: 'SupplierName',
            id: 'SupplierName',
            fieldLabel: '������λ',
            anchor: '90%',
            listeners: { specialkey: function(f, e) { if (e.getKey() == e.ENTER) { Ext.getCmp('SWhName').focus(); } } }

        });
        var WhNamePanel = new Ext.form.ComboBox({
            name: 'warehouseCombo',
            store: dsWarehouseList,
            displayField: 'WhName',
            valueField: 'WhId',
            typeAhead: true, //�Զ�����һ����������ѡ�ȫ����
            triggerAction: 'all',
            emptyText: '��ѡ��ֿ�',
            selectOnFocus: true,
            forceSelection: true,
            mode: 'local',
            fieldLabel: '�ֿ�����',
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
            emptyText: 'ѡ���ʼ�״̬',
            selectOnFocus: true,
            fieldLabel: '�ʼ�״̬',
            id: 'CheckStatus',
            anchor: '90%'
        });
        var BillStatusPanel = new Ext.form.ComboBox({
            name: 'billStatusCombo',
            store: dsBillStatus,
            displayField: 'BillStatusName',
            valueField: 'BillStatusId',
            typeAhead: true, //�Զ�����һ����������ѡ�ȫ����
            triggerAction: 'all',
            value: 0, //δ���
            selectOnFocus: true,
            forceSelection: true,
            editable: false,
            mode: 'local',
            fieldLabel: '����״̬',
            anchor: '90%',
            id: 'BillStatus',
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
            //layout: 'fit',
            buttonAlign: 'right',
            bodyStyle: 'padding:5px',
            frame: true,
            labelWidth: 55,
            items: [
            {
                layout: 'column',   //�����Ԫ��Ϊ����Ϊ�в��ַ�ʽ
                border: false,
                items: [
                {
                    columnWidth: .3,  //����ռ�õĿ�ȣ���ʶΪ20��
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
                layout: 'column',   //�����Ԫ��Ϊ����Ϊ�в��ַ�ʽ
                border: false,
                items: [
                {
                    columnWidth: .3,  //����ռ�õĿ�ȣ���ʶΪ20��
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

        /*------��ȡ���ݵĺ��� ���� End---------------*/

        /*------��ʼDataGrid�ĺ��� start---------------*/

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
            loadMask: { msg: '���ڼ������ݣ����Ժ��' },
            sm: sm,
            cm: new Ext.grid.ColumnModel([
	            sm,
	            new Ext.grid.RowNumberer(), //�Զ��к�
                //{ header: '������˾', dataIndex: 'OwnDept' },
	            {header: '�ʼ�����', dataIndex: 'CheckType', renderer: rendererQCType },
	            { header: '�������', dataIndex: 'DeliveryNo' },
	            { header: '������', dataIndex: 'ShipNo' },
                //{ header: '��Ӧ�̱��', hiddataIndex: 'ProviderNo' },
			    {header: '������λ', dataIndex: 'ProviderName' },
			    { header: '��Ʒ���', dataIndex: 'ProductNo' },
			    { header: '��Ʒ����', dataIndex: 'ProductName' },
			    { header: '������', dataIndex: 'RepresentAmount' },
			    { header: 'δ�����', dataIndex: 'NocheckNo' },
			    { header: '��������', dataIndex: 'ProductDate' },
			    { header: '���õص�', dataIndex: 'Location', renderer: rendererWarehouse },
			    { header: '�ʼ�״̬', dataIndex: 'CheckStatus', renderer: cktp}
			]),
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
                forceFit: true
            },
            height: 280,
            closeAction: 'hide',
            stripeRows: true,
            loadMask: true,
            autoExpandColumn: 2
        });
        userGrid.render();
        /*------DataGrid�ĺ������� End---------------*/
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
        if (typeof (resultWindow) == "undefined") {//�������2��windows����
            var resultWindow = new Ext.Window({
                title: '����ָ��',
                modal: 'true',
                width: 600,
                y: 50,
                autoHeigth: true,
                collapsible: true, //�Ƿ�����۵� 
                closable: true, //�Ƿ���Թر� 
                //maximizable : true,//�Ƿ������� 
                closeAction: 'hide',
                constrain: true,
                resizable: false,
                plain: true,
                // ,items: addQuotaForm
                buttons: [{
                    text: '�ر�',
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
                   checkid: checkid  //�ʼ쵥��
                    , prno: prno              //��ƷID(Ψһ���)
               },
                success: function(response, options) {
                    var data = response.responseText;
                    var divobj = document.createElement("div");
                  
                    if (data == "") {
                        Ext.Msg.alert("��ʾ", "�ʼ챨����δ���ɣ�");
                        return;
                    }
                    resultWindow.show();
                    divobj.innerHTML = data;
                    result.getEl().dom.lastChild.lastChild.appendChild(divobj);

                },
                failure: function() {
                    Ext.Msg.alert("��ʾ", "��ȡָ�����������,�����´򿪸�ҳ��");
                }
            });
        }
    })
</script>

</html>
