<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmFmAccReceCheck.aspx.cs" Inherits="FM_frmFmAccReceCheck" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html>
<head>
<title>Ԥ���ʿ��������</title><meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<link rel="stylesheet" type="text/css" href="../ext3/resources/css/ext-all.css" />
<script type="text/javascript" src="../ext3/adapter/ext/ext-base.js"></script>
<script type="text/javascript" src="../ext3/ext-all.js"></script>
<script type="text/javascript" src="../js/operateResp.js"></script>
<script type="text/javascript" src="../ext3/src/locale/ext-lang-zh_CN.js"></script>
<style type="text/css">
.x-grid-back-blue { 
background: #B7CBE8; 
}
</style>

</head>
<body>
<div id='toolbar'></div>
<div id='divSearchForm'></div>
<div id='divDataGrid'></div>
<div id='divDataDtlGrid'></div>
</body>
<%=getComboBoxStore()%>
<script type="text/javascript">
Ext.BLANK_IMAGE_URL = "../ext3/resources/images/default/s.gif";
var MstGridData = null;
var ModDtlGridData =null;
Ext.onReady(function() {

    /*------ʵ��toolbar�ĺ��� start---------------*/
    var Toolbar = new Ext.Toolbar({
        renderTo: "toolbar",
        items: [{
            text: "�����տ��¼",
            icon: "../Theme/1/images/extjs/customer/add16.gif",
            handler: function() { popAddWin(); }
        },{
            text: "ɾ���տ��¼",
            icon: "../Theme/1/images/extjs/customer/delete16.gif",
            handler: function() { deleteAcc(); }
        },{
            text: "�տ����ά��",
            icon: "../Theme/1/images/extjs/customer/edit16.gif",
            handler: function() { popCheckWin(); }
        }]
        });
        /*------����toolbar�ĺ��� end---------------*/

        //�ͻ��б�ѡ��
        function QueryDataGrid() {
            MstGridData.baseParams.CustomerId = Ext.getCmp('CustomerId').getValue();
            MstGridData.baseParams.StartDate=Ext.util.Format.date(Ext.getCmp('StartDate').getValue(),'Y/m/d');
            MstGridData.baseParams.EndDate=Ext.util.Format.date(Ext.getCmp('EndDate').getValue(),'Y/m/d');
            var status='';
            if(Ext.getCmp('Status').getValue()=='�Ѻ���')
                status ='true'; 
            if(Ext.getCmp('Status').getValue()=='δ����')
                status ='false'; 
            if(status!='')
                MstGridData.baseParams.IsDone = status;
            else
                MstGridData.baseParams.IsDone = '';

            MstGridData.load({
                params: {
                    start: 0,
                    limit: 20
                }
            });
            ModDtlGridData.removeAll();
        }

        //������������
        function popAddWin() {        
            var selectData = Ext.getCmp("CustomerId").getValue();
            if (selectData == null || selectData == "") {
                Ext.Msg.alert("��ʾ", "��ѡ��¼���տ��¼�Ŀͻ���");
                return;
            }            
            openAddWin.show();            

            Ext.getCmp("ModCustomerNo").setValue(Ext.getCmp("CustomerNo").getValue());
            Ext.getCmp("ModCustomerName").setValue(Ext.getCmp("ChineseName").getValue());
            Ext.getCmp("FundType").setValue("F052");
            Ext.getCmp("FundType").disable();
            Ext.getCmp("BusinessType").setValue("F061");
            Ext.getCmp("BusinessType").disable();
            dsPayType.clearFilter();
            dsPayType.filterBy(function(rec) {   
                return rec.get('DicsCode') != 'F01E';   
            }); 
        }


        //��������
        function saveAdd() {
            Ext.MessageBox.wait("�������ڱ��棬���Ժ򡭡�");
            Ext.Ajax.request({
                url: 'frmFmAccRece.aspx?method=saveAdd',
                method: 'POST',
                params: {
                    BusinessType: Ext.getCmp('BusinessType').getValue(),
                    FundType: Ext.getCmp('FundType').getValue(),
                    PayType: Ext.getCmp('PayType').getValue(),
                    Amount: Ext.getCmp('Amount').getValue(),
                    CustomerId: Ext.getCmp('CustomerId').getValue(),
                    CustomerNo: Ext.getCmp('CustomerNo').getValue(),
                    CustomerName: Ext.getCmp('ChineseName').getValue(),
                    Notes:Ext.getCmp('Notes').getValue()
                },
                success: function(resp, opts) {
                    Ext.MessageBox.hide();
                    if (checkExtMessage(resp)) {
                        MstGridData.reload();
                    }
                },
                failure: function(resp, opts) {
                    Ext.MessageBox.hide();
                    Ext.Msg.alert("��ʾ", "����ʧ��"); 
                }
            });
        }
        
        function deleteAcc(){
            var sm = MstGrid.getSelectionModel();
            var selectData = sm.getSelections();
            var array = new Array(selectData.length);
            if (selectData == null || selectData == "") {
                Ext.Msg.alert("��ʾ", "��ѡ���տ��¼��");
                return;
            }
            for(var i=0;i<selectData.length;i++)
            {
                array[i] = selectData[i].get('ReceivableId');
            }
            if (array.length != 1) {
                Ext.Msg.alert("��ʾ", "��ѡ��һ����¼��");
                return;
            }
            //ɾ��ǰ�ٴ������Ƿ����Ҫɾ��
            Ext.Msg.confirm("��ʾ��Ϣ", "�Ƿ����Ҫɾ��ѡ��ļ�¼��", function callBack(id) {
                //�ж��Ƿ�ɾ������
                if (id == "yes") {
                    //ҳ���ύ
                    Ext.Ajax.request({
                        url: 'frmFmAccReceCheck.aspx?method=DeletePreAcc',
                        method: 'POST',
                        params: {
                            ReceivableId: array[0]
                        },
                        success: function(resp,opts){  if(checkExtMessage(resp)){MstGridData.reload();  }},
	                    failure: function(resp,opts){  Ext.Msg.alert("��ʾ","����ʧ��");     }
                    });
                }
            });
        }
        function popCheckWin(){
            var sm = MstGrid.getSelectionModel();
            var selectData = sm.getSelections();
            if (selectData == null || selectData == "") {
                Ext.Msg.alert("��ʾ", "��ѡ���տ��¼��");
                return;
            }
            var ReceivableIds = "";
            for(var i=0;i<selectData.length;i++)
            {
                ReceivableIds = selectData[i].get('ReceivableId')+",";
                if(selectData[i].get('CustomerId') != Ext.getCmp("CustomerId").getValue())
                {
                    Ext.Msg.alert("��ʾ", "��ѡ��ͬһ���ͻ����տ��¼��");
                    return;
                }
                if(selectData[i].get('Ext1')=="0")
                {   
                    Ext.Msg.alert("��ʾ", "��ѡ��δ������δ��ȫ������Ԥ�տ��¼��");
                    return;;
                }
            }
            ReceivableIds = ReceivableIds.substring(0, ReceivableIds.length - 1);
            uploadOrderWindow.show();               
            document.getElementById("editIFrame").src = "frmFmAccReceCheckDesk.aspx?id="+ReceivableIds ;
            
        }
        //////////////////////////////Start �б����/////////////////////////////////////////////////////////////////
        var serchform = new Ext.FormPanel({
            renderTo: 'divSearchForm',
            labelAlign: 'left',
            //                    layout: 'fit',
            buttonAlign: 'right',
            bodyStyle: 'padding:5px',
            frame: true,
            items: [
	                {
	                    layout: 'column',
	                    border: false,
	                    labelSeparator: '��',
	                    items: [
		                {
		                    layout: 'form',
		                    border: false,
                            labelWidth: 45,
		                    columnWidth: 0.25,
		                    items: [
	                        {
			                    xtype: 'hidden',
			                    fieldLabel: '�ͻ�',
			                    columnWidth: 0.33,
			                    anchor: '90%',
			                    name: 'CustomerId',
			                    id: 'CustomerId',
			                    hideLabel:true
			                },
			                {
			                    xtype: 'hidden',
			                    fieldLabel: '�ͻ�',
			                    columnWidth: 0.33,
			                    anchor: '90%',
			                    name: 'CustomerNo',
			                    id: 'CustomerNo',
			                    hideLabel:true
			                },
			                {
			                    xtype: 'textfield',
			                    fieldLabel: '�ͻ�',
			                    columnWidth: 0.25,
			                    anchor: '95%',
			                    name: 'ChineseName',
			                    id: 'ChineseName',
			                    listeners: {
		                            blur: function(f) {
		                                if (f.getValue() == ''){
		                                    Ext.getCmp("CustomerId").setValue("");
		                                    Ext.getCmp("CustomerNo").setValue("");
		                                }
		                            }
		                        }
			                }]
		                }
                , {
                    layout: 'form',
                    border: false,
                    labelWidth: 55,
                    columnWidth: 0.25,
                    items: [
	                {
	                    xtype: 'datefield',
	                    fieldLabel: '��ʼ����',
	                    columnWidth: 0.25,
	                    anchor: '95%',
	                    name: 'StartDate',
	                    id: 'StartDate',
	                    format:'Y��m��d��',
	                    value:new Date().clearTime() 
	                }]
                }
                , {
                    layout: 'form',
                    border: false,
                    labelWidth: 55,
                    columnWidth: 0.25,
                    items: [
	                {
	                    xtype: 'datefield',
	                    fieldLabel: '��������',
	                    columnWidth: 0.25,
	                    anchor: '95%',
	                    name: 'EndDate',
	                    id: 'EndDate',
	                    format:'Y��m��d��',
	                    value:new Date().clearTime() 
	                }]
                }
                , {
                    layout: 'form',
                    border: false,
                    labelWidth: 45,
                    columnWidth: 0.17,
                    items: [
	                {
	                    xtype: 'combo',
	                    fieldLabel: '״̬',
	                    columnWidth: 0.17,
	                    anchor: '95%',
	                    name: 'Status',
	                    id: 'Status',
	                    store: ['ȫ��','�Ѻ���','δ����'],
                        triggerAction: 'all',
                        emptyValue: '',
                        selectOnFocus: true,
                        forceSelection: true,
                        value:'δ����',
                        mode:'local'
	                }]
                }
                , {
                    layout: 'form',
                    border: false,
                    columnWidth: 0.08,
                    items: [
	                {
	                    cls: 'key',
	                    xtype: 'button',
	                    text: '��ѯ',
	                    buttonAlign: 'right',
	                    id: 'searchebtnId',
	                    anchor: '95%',
	                    handler: function() { QueryDataGrid(); }
	                }]
                }]
	        }]
        });
         //����ͻ��������첽���÷���            
        var dsCustomers;
        if (dsCustomers == null) {
            dsCustomers = new Ext.data.Store({
                url: 'frmFmAccReceCheck.aspx?method=getCustomers',
                reader: new Ext.data.JsonReader({
                    root: 'root',
                    totalProperty: 'totalProperty'
                }, [
                        { name: 'CustomerId', mapping: 'CustomerId' },
                        { name: 'CustomerNo', mapping: 'CustomerNo' },
                        { name: 'ChineseName', mapping: 'ChineseName' },
                        { name: 'Address', mapping: 'Address' }
                    ])
            });
        }
        // ����ͻ��������첽������ʾģ��
        var resultTpl = new Ext.XTemplate(
            '<tpl for="."><div id="searchkhdivid" class="search-item">',
                '<h3><span>�ͻ���ţ�{CustomerNo}  �ͻ�ȫ�ƣ� {ChineseName}</span>  </h3>',
                    //'�ͻ���ַ��{Address}<br>����ʱ�䣺{createDate}',  
            '</div></tpl>'
        );
        var customerFilterCombo = new Ext.form.ComboBox({
                store: dsCustomers,
                displayField: 'ChineseName',
                displayValue: 'CustomerId',
                typeAhead: false,
                minChars: 1,
                loadingText: 'Searching...',
                tpl: resultTpl,
                pageSize: 10,
                hideTrigger: true,
                listWidth:300,
                applyTo: 'ChineseName',
                itemSelector: 'div.search-item',
                onSelect: function(record) { // override default onSelect to do redirect  
                    Ext.getCmp('CustomerId').setValue(record.data.CustomerId);
                    Ext.getCmp('CustomerNo').setValue(record.data.CustomerNo);
                    Ext.getCmp('ChineseName').setValue(record.data.ChineseName);
                    this.collapse();
                }
            });

        /*------��ʼ��ȡ���ݵĺ��� start---------------*/
        MstGridData = new Ext.data.Store
        ({
            url: 'frmFmAccReceCheck.aspx?method=getCustomerAccReceList',
            reader: new Ext.data.JsonReader({
                totalProperty: 'totalProperty',
                root: 'root'
            }, [
                { name: "ReceivableId" },
                { name: "BusinessType" },
                { name: "FundType" },
                { name: "CustomerId" },
                { name: "CustomerNo" },
                { name: "CustomerName" },
                { name: "PayType" },
                { name: "Amount" },
                { name: "TotalAmount" },
                { name: "OperId" },
                { name: "Ext1" },
                { name: "Ext2" },
                { name: "PayTypeText" },
                { name: "OperName" },
                { name: 'CreateDate' }
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
        var MstGrid = new Ext.grid.GridPanel({
            el: 'divDataGrid',
            width:document.body.offsetWidth,
            height: '100%',
            //autoWidth: true,
            //autoHeight: true,
            autoScroll: true,
            monitorResize: true, 
            columnLines:true,
            title: 'Ԥ������Ϣ',
            id: '',
            store: MstGridData,
            loadMask: { msg: '���ڼ������ݣ����Ժ��' },
            sm: sm,
            cm: new Ext.grid.ColumnModel([
            sm,
            new Ext.grid.RowNumberer(), //�Զ��к�
              {header: "�ͻ�ID", dataIndex: 'CustomerId', hidden: true, hideable: false },
              { header: "�տ���", width: 70, sortable: true, dataIndex: 'ReceivableId' },
              { header: "�ͻ����", width: 80, sortable: true, dataIndex: 'CustomerNo' },
              { header: "�ͻ�����", width: 180, sortable: true, dataIndex: 'CustomerName' },
              { header: "Ԥ�����", width: 80, sortable: true, dataIndex: 'Amount', align:'right' },
              { header: "δ�˽��", width: 80, sortable: true, dataIndex: 'Ext1' , align:'right'},
              { header: "�Ѻ���", width: 50, sortable: true, dataIndex: 'Ext1', renderer:function(v){if(v==0) return '��';else return '��';} },
              { header: "��������", width: 80, sortable: true, dataIndex: 'PayTypeText' },
              { header: "����Ա", width: 60, sortable: true, dataIndex: 'OperName' },
              { header: "����ʱ��", width: 110, sortable: true, dataIndex: 'CreateDate', renderer: Ext.util.Format.dateRenderer('Y��m��d��') },
              { header: '��ע',width: 100, sortable: true, dataIndex: 'Notes'}

            ]),
            bbar: new Ext.PagingToolbar({
                pageSize: 10,
                store: MstGridData,
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
            height: 280,
            closeAction: 'hide',
            stripeRows: true,
            loadMask: true//,
            //autoExpandColumn: 2
        });
        MstGrid.on("afterrender", function(component) {
            component.getBottomToolbar().refresh.hideParent = true;
            component.getBottomToolbar().refresh.hide();
        });
        MstGrid.on("rowclick",function(grid, rowIndex, e){
            Ext.getCmp('CustomerId').setValue(grid.getStore().getAt(rowIndex).data.CustomerId);
            Ext.getCmp('CustomerNo').setValue(grid.getStore().getAt(rowIndex).data.CustomerNo);
            Ext.getCmp('ChineseName').setValue(grid.getStore().getAt(rowIndex).data.CustomerName);
        });
        MstGrid.on("rowdblclick",function(grid, rowIndex, e){
            ModDtlGridData.load({params:{
                    ReceivableId:grid.getStore().getAt(rowIndex).data.ReceivableId,
                    CustomerId:grid.getStore().getAt(rowIndex).data.CustomerId
                }});
        });
        
        MstGrid.render();
        /*------DataGrid�ĺ������� End---------------*/
        //////////////////////////////////End �б����/////////////////////////////////////////////////////////////

        /*------��ʼ�������ݵĴ��� Start---------------*/
        if (typeof (uploadOrderWindow) == "undefined") {//�������2��windows����
            uploadOrderWindow = new Ext.Window({
                id: 'checkformwindow',
                iconCls: 'upload-win'
                , width: 750
                , height: 500
                , plain: true
                , modal: true
                , constrain: true
                , resizable: false
                , closeAction: 'hide'
                , autoDestroy: true
                , html: '<iframe id="editIFrame" width="100%" height="100%" border=0 src=""></iframe>' 
                
            });
        }

        ////////////////////////Start �޸Ľ���///////////////////////////////////////////////////////////////////////        
        var modDtlForm = new Ext.FormPanel({
            labelAlign: 'left',
            buttonAlign: 'right',
            bodyStyle: 'padding:5px',
            frame: true,
            labelWidth: 55,
            height: 80,
            items: [
            {
                layout: 'column',
                border: false,
                labelSeparator: '��',
                items: [
                {
                    layout: 'form',
                    border: false,
                    columnWidth: 0.98,
                    items: [
                    {
                        xtype: 'textfield',
                        fieldLabel: '�ͻ�����',
                        columnWidth: 0.98,
                        anchor: '90%',
                        name: 'ModCustomerNo',
                        id: 'ModCustomerNo',
                        readOnly: true
                    }]
                }
                , {
                    layout: 'form',
                    border: false,
                    columnWidth: 0.98,
                    items: [
                    {
                        xtype: 'textfield',
                        fieldLabel: '�ͻ�����',
                        columnWidth: 0.98,
                        anchor: '90%',
                        name: 'ModCustomerName',
                        id: 'ModCustomerName',
                        readOnly: true
                    }]
                }]
            }]
        });


        /*------��ʼ��ȡ���ݵĺ��� start---------------*/
        ModDtlGridData = new Ext.data.Store
        ({
            url: 'frmFmAccReceCheck.aspx?method=getAccountYetReceDtl',
            reader: new Ext.data.JsonReader({
                totalProperty: 'totalProperty',
                root: 'root'
            }, [
                { name: 'SaleCheckDtlId' },
                { name: 'SaleCheckId' },
                { name: 'ReceivableId' },
                { name: 'CustomerId' },
                { name: 'CustomerNo' },
                { name: 'CustomerName' },
                { name: 'ObjectId' },
                { name: 'CheckNum' },
                { name: 'CheckPrice' },
                { name: 'CheckOther' },
                { name: 'CheckAmt' },
                { name: 'CheckTax' },
                { name: 'OrderDtlId' },
                { name: 'OrderId' },
                { name: 'ProductId' },
                { name: 'OrderNumber' },
                { name: 'ProductId' },
                { name: 'ProductName' },
                { name: 'SpecificationsText' },
                { name: 'SalePrice' },
                { name: 'SaleQty' },
                { name: 'UnitText' },
                { name: 'SaleAmt' },
                { name: 'SaleTax' },
                { name: 'CheckAmt' },
                { name: 'Unit' },
                { name: 'OperId' },
                { name: 'OrgId' },
                { name: 'OwnerId' },
                { name: 'CreateDate' },
                { name: 'Ext1' },
                { name: 'Ext2' },
                { name: 'Notes' },
                { name: 'OperName' },
                { name: 'CheckDate' }
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
            singleSelect: false
        });
        var ModOrderDtlGrid = new Ext.grid.GridPanel({
            autoScroll: true,
            autoHeight: true,
            width: document.body.offsetWidth,
            el:'divDataDtlGrid',
            store: ModDtlGridData,
           // title:'�Ѻ�����Ϣ',
            loadMask: { msg: '���ڼ������ݣ����Ժ��' },
            sm: sm,
            cm: new Ext.grid.ColumnModel([
                sm,
                new Ext.grid.RowNumberer(), //�Զ��к�
                {
                    header: '���',
                    dataIndex: 'SaleCheckDtlId',
                    id: 'SaleCheckDtlId',
                    hidden:true,
                    hideable:true
                },
                {
                    header: '�������',
                    dataIndex: 'OrderNumber',
                    id: 'OrderNumber',
                    width:85
                },
                {
                    header: '��Ʒ����',
                    dataIndex: 'ProductName',
                    id: 'ProductName',
                    width:160
                },
                {
                    header: '���',
                    dataIndex: 'SpecificationsText',
                    id: 'SpecificationsText',
                    width:60
                },
                {
                    header: '����',
                    dataIndex: 'SaleQty',
                    id: 'SaleQty',
                    align:'right',
                    width:60
                },
                {
                    header: '����',
                    dataIndex: 'SalePrice',
                    id: 'SalePrice',
                    align:'right',
                    width:60
                },
                {
                    header: '���۽��',
                    dataIndex: 'SaleAmt',
                    id: 'SaleAmt',
                    align:'right',
                    renderer: function(v) {
                        return Number(v).toFixed(2);
                    },
                    width:80
                },
                {
                    header: '�Ѻ˽��',
                    dataIndex: 'CheckAmt',
                    id: 'CheckAmt',
                    renderer: function(v) {
                        return Number(v).toFixed(2);
                    },
                    align:'right',
                    width:80
                },
                {
                    header: '������',
                    dataIndex: 'OperName',
                    id: 'OperName',
                    width:60
                },
                {
                    header: '��������',
                    dataIndex: 'CreateDate',
                    id: 'CreateDate',
                    renderer: Ext.util.Format.dateRenderer('Y��m��d��'),
                    width:110
                }
                ]),
//            bbar: new Ext.PagingToolbar({
//                pageSize: 10,
//                store: ModDtlGridData,
//                displayMsg: '��ʾ��{0}����{1}����¼,��{2}��',
//                emptyMsy: 'û�м�¼',
//                displayInfo: true
//            }),
            tbar: [{
                id: 'btnALC',
                text: 'ɾ��������¼',
                iconCls: 'add',
                icon:'../Theme/1/images/extjs/customer/delete16.gif',
                handler: function() { 
                    var sm = ModOrderDtlGrid.getSelectionModel();
                    var selectData = sm.getSelections();
                    var array = new Array(selectData.length);
                    if (selectData == null || selectData == "") {
                        Ext.Msg.alert("��ʾ", "��ѡ���Ѻ˼�¼��");
                        return;
                    }
                    for(var i=0;i<selectData.length;i++)
                    {
                        array[i] = selectData[i].get('SaleCheckDtlId');
                    }
                    if (array.length != 1) {
                        Ext.Msg.alert("��ʾ", "��ѡ��һ����¼��");
                        return;
                    }
                    //ɾ��ǰ�ٴ������Ƿ����Ҫɾ��
                    Ext.Msg.confirm("��ʾ��Ϣ", "�Ƿ����Ҫɾ��ѡ��ļ�¼��", function callBack(id) {
                        //�ж��Ƿ�ɾ������
                        if (id == "yes") {
                            //ҳ���ύ
                            Ext.Ajax.request({
                                url: 'frmFmAccReceCheck.aspx?method=DeleteSaleCheckDtl',
                                method: 'POST',
                                params: {
                                    SaleCheckDtlId: array[0]
                                },
                                success: function(resp,opts){  if(checkExtMessage(resp)){ModDtlGridData.reload(); MstGridData.reload(); }},
	                            failure: function(resp,opts){  Ext.Msg.alert("��ʾ","����ʧ��");     }
                            });
                        }
                    });                 
                     
                }
            }],
            viewConfig: {
                columnsText: '��ʾ����',
                scrollOffset: 20,
                sortAscText: '����',
                sortDescText: '����',
                forceFit: false
            },
            closeAction: 'hide',
            stripeRows: true,
            loadMask: true//,
            //autoExpandColumn: 2

        });
//        ModOrderDtlGrid.on("afterrender", function(component) {
//            component.getBottomToolbar().refresh.hideParent = true;
//            component.getBottomToolbar().refresh.hide();
//        });
        ModOrderDtlGrid.render();

        //Ӧ���ʿ���������
        var modDtlFormInput = new Ext.FormPanel({
            labelAlign: 'left',
            buttonAlign: 'right',
            bodyStyle: 'padding:5px',
            frame: true,
            labelWidth: 55,
            height: 100,
            items: [
            {
                layout: 'column',
                border: false,
                labelSeparator: '��',
                items: [
                {
                    layout: 'form',
                    border: false,
                    columnWidth: 0.49,
                    items: [
                    {
                        xtype: 'combo',
                        store: dsBizType,
                        valueField: 'DicsCode',
                        displayField: 'DicsName',
                        mode: 'local',
                        forceSelection: true,
                        editable: false,
                        emptyValue: '',
                        triggerAction: 'all',
                        fieldLabel: 'ҵ������',
                        name: 'BusinessType',
                        id: 'BusinessType',
                        selectOnFocus: true,
                        anchor: '90%'
                    }]
                }
                , {
                    layout: 'form',
                    border: false,
                    columnWidth: 0.49,
                    items: [
                    {
                        xtype: 'combo',
                        store: dsFundType,
                        valueField: 'DicsCode',
                        displayField: 'DicsName',
                        mode: 'local',
                        forceSelection: true,
                        editable: false,
                        emptyValue: '',
                        triggerAction: 'all',
                        fieldLabel: '�ʽ���',
                        name: 'FundType',
                        id: 'FundType',
                        selectOnFocus: true,
                        anchor: '90%',
                        listeners: {
                            select: function(combo, record, index) {
                                Ext.getCmp('PayType').setValue("");
                                dsPayType.filterBy(function(rec) {   
                                        return rec.get('DicsCode') != '';   
                                }); 
                                if(combo.getValue()=='F052'){
                                    dsPayType.clearFilter();
                                    dsPayType.filterBy(function(rec) {   
                                        return rec.get('DicsCode') != 'F01E';   
                                    }); 
                                }else{
                                    dsPayType.clearFilter();
                                    dsPayType.filterBy(function(rec) {   
                                        return rec.get('DicsCode') == 'F01E';   
                                    }); 
                                }
                            }
                        }
                    }]
                }
                 , {
                      layout: 'form',
                      border: false,
                      columnWidth: 0.49,
                      items: [
                        {
                            xtype: 'combo',
                            store: dsPayType,
                            valueField: 'DicsCode',
                            displayField: 'DicsName',
                            mode: 'local',
                            forceSelection: true,
                            editable: false,
                            emptyValue: '',
                            triggerAction: 'all',
                            fieldLabel: '��������',
                            name: 'PayType',
                            id: 'PayType',
                            selectOnFocus: true,
                            anchor: '90%',
                            lastQuery:''
                        }]
                  }
                 , {
                     layout: 'form',
                     border: false,
                     columnWidth: 0.49,
                     items: [
                    {
                        xtype: 'numberfield',
                        fieldLabel: '���',
                        columnWidth: 0.25,
                        anchor: '90%',
                        name: 'Amount',
                        id: 'Amount',
                        editable: false
                    }]
                }]
            },{
                layout: 'column',
                border: false,
                labelSeparator: '��',
                items: [
                {
                    layout: 'form',
                    border: false,
                    columnWidth: 1,
                    items: [
                    {
                        xtype: 'textfield',
                        fieldLabel: '��ע',
                        columnWidth: 1,
                        anchor: '93%',
                        name: 'Notes',
                        id: 'Notes',
                        editable: false
                    }]
                }]            
            }]
        });


        if (typeof (openAddWin) == "undefined") {//�������2��windows����
            openAddWin = new Ext.Window({
                id: 'openModWin',
                title: 'Ӧ���ʿ�ά��'
		            , iconCls: 'upload-win'
		            , width: 550
		            , height: 260
		            , layout: 'form'
		            , plain: true
		            , modal: true
		            , constrain: true
		            , resizable: false
		            , closeAction: 'hide'
		            , autoDestroy: true
		            , items: [

                         { layout: 'form',
                             border: false,
                             columnWidth: 1,
                             items: [modDtlForm]
                         },
                         { layout: 'form',
                             border: false,
                             columnWidth: 1,
                             items: [modDtlFormInput]
                         }

		            ]
		            , buttons: [{
		                text: "����"
			            , handler: function() {
			                saveAdd();
			                ModDtlGridData.reload();
			            }
			            , scope: this
		            },
		            {
		                text: "ȡ��"
			            , handler: function() {
			                openAddWin.hide();			                
			            }
			            , scope: this
}]
            });
        }
        openAddWin.addListener("hide", function() {
            Ext.getCmp("FundType").enable();
            Ext.getCmp("BusinessType").enable();
            MstGridData.reload();
        });

        ////////////////////////End �޸Ľ���///////////////////////////////////////////////////////////////////////

    })
</script>

</html>
