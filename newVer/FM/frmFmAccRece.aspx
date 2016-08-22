<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmFmAccRece.aspx.cs" Inherits="FM_frmFmAccRece" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html>
<head>
<title>Ӧ���ʿ����</title><meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<link rel="stylesheet" type="text/css" href="../ext3/resources/css/ext-all.css" />
<script type="text/javascript" src="../ext3/adapter/ext/ext-base.js"></script>
<script type="text/javascript" src="../ext3/ext-all.js"></script>
<script type="text/javascript" src="../js/operateResp.js"></script>
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
</body>
<%=getComboBoxStore()%>
<script type="text/javascript">
Ext.BLANK_IMAGE_URL = "../ext3/resources/images/default/s.gif";
Ext.onReady(function() {

    /*------ʵ��toolbar�ĺ��� start---------------*/
    var Toolbar = new Ext.Toolbar({
        renderTo: "toolbar",
        items: [{
            text: "�����տ��¼",
            icon: "../Theme/1/images/extjs/customer/add16.gif",
            handler: function() { popAddWin(); }
}]
        });
        /*------����toolbar�ĺ��� end---------------*/

        //�ͻ��б�ѡ��
        function QueryDataGrid() {
            MstGridData.baseParams.CustomerId = Ext.getCmp('CustomerNo').getValue();
            MstGridData.baseParams.ShortName = Ext.getCmp('CustomerName').getValue();
            MstGridData.baseParams.ChineseName = Ext.getCmp('CustomerName').getValue();
            MstGridData.baseParams.DistributionType = "";

            MstGridData.load({
                params: {
                    start: 0,
                    limit: 10
                }
            });
        }

        //������������
        function popAddWin() {
            var sm = MstGrid.getSelectionModel();
            var selectData = sm.getSelected();
            if (selectData == null || selectData == "") {
                Ext.Msg.alert("��ʾ", "��ѡ��¼���տ��¼�Ŀͻ���");
                return;
            }
            openAddWin.show();
            ModDtlGridData.baseParams.CustomerId = selectData.data.CustomerId;
            ModDtlGridData.load({
                params: {
                    start: 0,
                    limit: 10
                }
            });

            Ext.getCmp("ModCustomerNo").setValue(selectData.data.CustomerNo);
            Ext.getCmp("ModCustomerName").setValue(selectData.data.ShortName);
            Ext.getCmp("FundType").setValue("F051");
            Ext.getCmp("BusinessType").setValue("F061");
            //Ext.getCmp("PayType").setValue("F011");

        }


        //��������
        function saveAdd() {
            //��ȡ������Ϣ
            var sm = MstGrid.getSelectionModel();
            var selectData = sm.getSelected();
            Ext.MessageBox.wait("�������ڱ��棬���Ժ򡭡�");
            Ext.Ajax.request({
                url: 'frmFmAccRece.aspx?method=saveAdd',
                method: 'POST',
                params: {
                    BusinessType: Ext.getCmp('BusinessType').getValue(),
                    FundType: Ext.getCmp('FundType').getValue(),
                    PayType: Ext.getCmp('PayType').getValue(),
                    Amount: Ext.getCmp('Amount').getValue(),
                    CustomerId: selectData.data.CustomerId,
                    CustomerNo: selectData.data.CustomerNo,
                    CustomerName: selectData.data.ShortName,
                    Notes: Ext.getCmp('Notes').getValue()
                },
                success: function(resp, opts) {
                    Ext.MessageBox.hide();
                    if (checkExtMessage(resp)) { 
			            ModDtlGridData.reload();
                    }
                },
                failure: function(resp, opts) {
                    Ext.MessageBox.hide();
                    Ext.Msg.alert("��ʾ", "����ʧ��"); 
                }
            });
        }

        //////////////////////////////Start �б����/////////////////////////////////////////////////////////////////
        var serchform = new Ext.FormPanel({
            renderTo: 'divSearchForm',
            labelAlign: 'left',
            //                    layout: 'fit',
            buttonAlign: 'right',
            bodyStyle: 'padding:5px',
            frame: true,
            labelWidth: 55,
            items: [
            {
                layout: 'column',
                border: false,
                labelSeparator: '��',
                items: [
                {
                    layout: 'form',
                    border: false,
                    columnWidth: 0.33,
                    items: [
	                {
	                    xtype: 'textfield',
	                    fieldLabel: '�ͻ����',
	                    columnWidth: 0.33,
	                    anchor: '90%',
	                    name: 'CustomerNo',
	                    id: 'CustomerNo'
	                }]
                }
                , {
                    layout: 'form',
                    border: false,
                    columnWidth: 0.33,
                    items: [
	                {
	                    xtype: 'textfield',
	                    fieldLabel: '�ͻ�����',
	                    columnWidth: 0.33,
	                    anchor: '90%',
	                    name: 'CustomerName',
	                    id: 'CustomerName'
	                }]
                }
                , {
                    layout: 'form',
                    border: false,
                    columnWidth: 0.34,
                    items: [
	                {
	                    cls: 'key',
	                    xtype: 'button',
	                    text: '��ѯ',
	                    buttonAlign: 'right',
	                    id: 'searchebtnId',
	                    anchor: '25%',
	                    handler: function() { QueryDataGrid(); }
	                }]
                }]
	        }]
        });


        /*------��ʼ��ȡ���ݵĺ��� start---------------*/
        var MstGridData = new Ext.data.Store
                        ({
                            url: 'frmFmAccRece.aspx?method=getCustomerList',
                            reader: new Ext.data.JsonReader({
                                totalProperty: 'totalProperty',
                                root: 'root'
                            }, [
                                { name: "CustomerId" },
			                    { name: "CustomerNo" },
			                    { name: "ShortName" },
			                    { name: "LinkMan" },
			                    { name: "LinkTel" },
			                    { name: "LinkMobile" },
			                    { name: "Fax" },
			                    { name: "DistributionTypeText" },
			                    { name: "MonthQuantity" },
			                    { name: "IsCust" },
			                    { name: "IsProvide" },
			                    { name: 'CreateDate' }
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

        /*------��ʼDataGrid�ĺ��� start---------------*/

        var sm = new Ext.grid.CheckboxSelectionModel({
            singleSelect: true
        });
        var MstGrid = new Ext.grid.GridPanel({
            el: 'divDataGrid',
            width: '100%',
            height: '100%',
            autoWidth: true,
            autoHeight: true,
            autoScroll: true,
            //layout: 'fit',
            id: '',
            store: MstGridData,
            loadMask: { msg: '���ڼ������ݣ����Ժ��' },
            sm: sm,
            cm: new Ext.grid.ColumnModel([

            sm,
            new Ext.grid.RowNumberer(), //�Զ��к�
              {header: "�ͻ�ID", dataIndex: 'CustomerId', hidden: true, hideable: false },
              { header: "�ͻ����", width: 100, sortable: true, dataIndex: 'CustomerNo' },
              { header: "�ͻ�����", width: 180, sortable: true, dataIndex: 'ShortName' },
              { header: "��ϵ��", width: 100, sortable: true, dataIndex: 'LinkMan' },
              { header: "��ϵ�绰", width: 80, sortable: true, dataIndex: 'LinkTel' },
              { header: "�ƶ��绰", width: 80, sortable: true, dataIndex: 'LinkMobile', hidden: true, hideable: false },
              { header: "����", width: 80, sortable: true, dataIndex: 'Fax', hidden: true, hideable: false },
              { header: "��������", width: 60, sortable: true, dataIndex: 'DistributionTypeText' },
              { header: "������", width: 50, sortable: true, dataIndex: 'MonthQuantity' },
              { header: "�ǿ���", width: 50, sortable: true, dataIndex: 'IsCust', renderer: { fn: function(v) { if (v == 1) return '��'; return '��'; } } },
              { header: "�ǹ�Ӧ��", width: 60, sortable: true, dataIndex: 'IsProvide', renderer: { fn: function(v) { if (v == 1) return '��'; return '��'; } } },
              { header: "����ʱ��", width: 110, sortable: true, dataIndex: 'CreateDate', renderer: Ext.util.Format.dateRenderer('Y��m��d��')}//renderer: Ext.util.Format.dateRenderer('m/d/Y'),

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
        MstGrid.render();
        /*------DataGrid�ĺ������� End---------------*/
        //////////////////////////////////End �б����/////////////////////////////////////////////////////////////



        ////////////////////////Start �޸Ľ���///////////////////////////////////////////////////////////////////////        
        var modDtlForm = new Ext.FormPanel({
            labelAlign: 'left',
            buttonAlign: 'right',
            bodyStyle: 'padding:5px',
            frame: true,
            labelWidth: 55,
            height: 40,
            items: [
            {
                layout: 'column',
                border: false,
                labelSeparator: '��',
                items: [
                {
                    layout: 'form',
                    border: false,
                    columnWidth: 0.3,
                    items: [
                    {
                        xtype: 'textfield',
                        fieldLabel: '�ͻ�����',
                        columnWidth: 0.3,
                        anchor: '90%',
                        name: 'ModCustomerNo',
                        id: 'ModCustomerNo',
                        readOnly: true
                    }]
                }
                , {
                    layout: 'form',
                    border: false,
                    columnWidth: 0.7,
                    items: [
                    {
                        xtype: 'textfield',
                        fieldLabel: '�ͻ�����',
                        columnWidth: 0.7,
                        anchor: '90%',
                        name: 'ModCustomerName',
                        id: 'ModCustomerName',
                        readOnly: true
                    }]
                }]
            }]
        });


        /*------��ʼ��ȡ���ݵĺ��� start---------------*/
        var ModDtlGridData = new Ext.data.Store
                        ({
                            url: 'frmFmAccRece.aspx?method=getAccountReceDtl',
                            reader: new Ext.data.JsonReader({
                                totalProperty: 'totalProperty',
                                root: 'root'
                            }, [
                                { name: 'Ext3' },
                                { name: 'Ext4' },
                                { name: 'ReceivableId' },
                                { name: 'CustomerId' },
                                { name: 'CustomerNo' },
                                { name: 'CustomerName' },
                                { name: 'BusinessType' },
                                { name: 'FundType' },
                                { name: 'PayType' },
                                { name: 'Amount' },
                                { name: 'TotalAmount' },
                                { name: 'CertificateStatus' },
                                { name: 'OperId' },
                                { name: 'OrgId' },
                                { name: 'OwnerId' },
                                { name: 'CreateDate' },
                                { name: 'Ext1' },
                                { name: 'Ext2' },
                                { name: 'Notes' },
                                { name: 'BusinessTypeText' },
                                { name: 'FundTypeText' },
                                { name: 'OperName' },
                                { name: 'PayTypeText' }
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

        /*------��ʼDataGrid�ĺ��� start---------------*/

        var sm = new Ext.grid.CheckboxSelectionModel({
            singleSelect: true
        });
        var ModOrderDtlGrid = new Ext.grid.EditorGridPanel({
            autoScroll: true,
            height: 220,
            id: '',
            store: ModDtlGridData,
            loadMask: { msg: '���ڼ������ݣ����Ժ��' },
            sm: sm,
            cm: new Ext.grid.ColumnModel([
		                    sm,
		                    new Ext.grid.RowNumberer(), //�Զ��к�
		                    {
		                        header: '���',
		                        dataIndex: 'ReceivableId',
		                        id: 'ReceivableId',
		                        width:70
		                    },
		                    {
		                        header: 'ҵ������',
		                        dataIndex: 'BusinessTypeText',
		                        id: 'BusinessTypeText',
		                        width:60
		                    },
		                    {
		                        header: '�ʽ���',
		                        dataIndex: 'FundType',
		                        id: 'FundType',
		                        renderer: function(v,meta,rec) {
		                            if(rec.data.BusinessType=='F062')
		                            {
		                                if(v=='F051') return 'Ӧ��';
		                                else if(v=='F052') return '�˿�';
		                            }
		                            var index = dsFundType.findBy(function(record, id) {
		                                return record.get('DicsCode') == v;
		                            });
		                            return dsFundType.getAt(index).get('DicsName');

		                        },
		                        width:60
		                    },
		                    {
		                        header: '��������',
		                        dataIndex: 'PayTypeText',
		                        id: 'PayTypeText',
		                        width:60
		                    },
		                    {
		                        header: '���',
		                        dataIndex: 'Amount',
		                        id: 'Amount',
		                        renderer: function(v) {
		                            return Number(v).toFixed(2);
		                        },
		                        align:'right',
		                        width:100
		                    },
		                    {
		                        header: '�ۼƽ��',
		                        dataIndex: 'TotalAmount',
		                        id: 'TotalAmount',
		                        renderer: function(v) {
		                            return Number(v).toFixed(2);
		                        },
		                        align:'right',
		                        width:100
		                    },
		                    {
		                        header: '����Ա',
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
		                    },
		                    {
		                        header: '��ע',
		                        dataIndex: 'Notes',
		                        id: 'Notes',
		                        width:60
		                    }
		                    ]),
            bbar: new Ext.PagingToolbar({
                pageSize: 10,
                store: ModDtlGridData,
                displayMsg: '��ʾ��{0}����{1}����¼,��{2}��',
                emptyMsy: 'û�м�¼',
                displayInfo: true
            }),
            tbar:new Ext.Toolbar({
                items: [{
                    text: "�޸ļ�¼",
                    icon: "../Theme/1/images/extjs/customer/edit16.gif",
                    handler: function() { editorRecord();}
                },{
                    text: "ɾ����¼",
                    icon: "../Theme/1/images/extjs/customer/delete16.gif",
                    handler: function() { deleteRecord();}
                }]
            }),
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
        ModOrderDtlGrid.on("afterrender", function(component) {
            component.getBottomToolbar().refresh.hideParent = true;
            component.getBottomToolbar().refresh.hide();
        });

        //Ӧ���ʿ���������
        var modDtlFormInput = new Ext.FormPanel({
            labelAlign: 'left',
            buttonAlign: 'right',
            bodyStyle: 'padding:4px',
            frame: true,
            labelWidth: 55,
            height: 65,
            items: [
            {
                layout: 'column',
                border: false,
                labelSeparator: '��',
                items: [
                {
                    layout: 'form',
                    border: false,
                    columnWidth: 0.25,
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
                        anchor: '90%',
                        editable: false,
                        listeners:{
                            select:function(combo,record,index){
                                dsFundType.each(function(rec) {
                                    if(Ext.getCmp('BusinessType').getValue()=='F062'){
                                        if(rec.get('DicsCode')=='F051')
                                            rec.set('DicsName','Ӧ��');
                                        else if(rec.get('DicsCode')=='F052')
                                            rec.set('DicsName','�˿�');
                                    }
                                    else if(Ext.getCmp('BusinessType').getValue()=='F061'){
                                        if(rec.get('DicsCode')=='F051')
                                            rec.set('DicsName','Ӧ��');
                                        else if(rec.get('DicsCode')=='F052')
                                            rec.set('DicsName','�տ�');
                                    }
                                });
                                Ext.getCmp('FundType').setValue('F051');
                            }
                        }
                    }]
	            }
                , {
                    layout: 'form',
                    border: false,
                    columnWidth: 0.25,
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
                        editable: false,
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
                      columnWidth: 0.25,
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
                            editable: false,
                            lastQuery:''
                        }]
                  }
                     , {
                         layout: 'form',
                         border: false,
                         columnWidth: 0.25,
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
            },
            {
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
                        anchor: '98%',
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
		            , width: 750
		            , height: 400
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
                             items: [ModOrderDtlGrid]
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
			            }
			            , scope: this
		            },
		            {
		                text: "ȡ��"
			            , handler: function() {
			                openAddWin.hide();
			                MstGridData.reload();
			            }
			            , scope: this
                }]
            });
        }
        openAddWin.addListener("hide", function() {                 
            Ext.getCmp('PayType').clearValue();       
            dsPayType.clearFilter();
            dsPayType.filterBy(function(rec) {   
                return rec.get('DicsCode') == 'F01E';   
            });   
            Ext.getCmp('Amount').setValue(''); 
        });


        dsPayType.clearFilter();
        dsPayType.filterBy(function(rec) {   
            return rec.get('DicsCode') == 'F01E';   
        }); 

        ////////////////////////End �޸Ľ���///////////////////////////////////////////////////////////////////////
        function deleteRecord()
        {
            Ext.Msg.confirm("��ʾ��Ϣ", "ȷ��Ҫɾ����¼��", function callBack(id) {
                //�ж��Ƿ�ɾ������
                if (id == "yes") {
                    var sm = ModOrderDtlGrid.getSelectionModel();
                    var selectData = sm.getSelected();
                    Ext.MessageBox.wait("�������ڴ������Ժ򡭡�");
                    Ext.Ajax.request({
                        url: 'frmFmAccRece.aspx?method=deleteRecord',
                        method: 'POST',
                        params: {
                            ReceivableId: selectData.data.ReceivableId
                        },
                        success: function(resp, opts) {
                            Ext.MessageBox.hide();
                            if (checkExtMessage(resp)) { 
			                    ModDtlGridData.reload();
                            }
                        },
                        failure: function(resp, opts) {
                            Ext.MessageBox.hide();
                            Ext.Msg.alert("��ʾ", "����ʧ��"); 
                        }
                    });        
                }
            });            
        }
        var modeditForm = new Ext.FormPanel({
            labelAlign: 'left',
            buttonAlign: 'right',
            bodyStyle: 'padding:5px',
            frame: true,
            labelWidth: 55,
            height: 70,
            items: [
            {
                layout: 'column',
                border: false,
                labelSeparator: '��',
                items: [
                {
                    layout: 'form',
                    border: false,
                    columnWidth: 0.25,
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
                        name: 'EBusinessType',
                        id: 'EBusinessType',
                        selectOnFocus: true,
                        anchor: '90%',
                        editable: false,
                        listeners:{
                            select:function(combo,record,index){
                                dsFundType.each(function(rec) {
                                    if(Ext.getCmp('EBusinessType').getValue()=='F062'){
                                        if(rec.get('DicsCode')=='F051')
                                            rec.set('DicsName','Ӧ��');
                                        else if(rec.get('DicsCode')=='F052')
                                            rec.set('DicsName','�˿�');
                                    }
                                    else if(Ext.getCmp('EBusinessType').getValue()=='F061'){
                                        if(rec.get('DicsCode')=='F051')
                                            rec.set('DicsName','Ӧ��');
                                        else if(rec.get('DicsCode')=='F052')
                                            rec.set('DicsName','�տ�');
                                    }
                                });
                                Ext.getCmp('EFundType').setValue('F051');
                            }
                        }
                    }]
                }
        , {
            layout: 'form',
            border: false,
            columnWidth: 0.25,
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
                name: 'EFundType',
                id: 'EFundType',
                selectOnFocus: true,
                anchor: '90%',
                editable: false,
                listeners: {
                    select: function(combo, record, index) {
                        Ext.getCmp('EPayType').setValue("");
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
                  columnWidth: 0.25,
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
                        name: 'EPayType',
                        id: 'EPayType',
                        selectOnFocus: true,
                        anchor: '90%',
                        editable: false,
                        lastQuery:''
                    }]
              }
             , {
                 layout: 'form',
                 border: false,
                 columnWidth: 0.25,
                 items: [
                {
                    xtype: 'numberfield',
                    fieldLabel: '���',
                    columnWidth: 0.25,
                    anchor: '90%',
                    name: 'EAmount',
                    id: 'EAmount',
                    editable: false
                },{
                    xtype:'hidden',
                    fieldLabel:'��ʶ',
                    columnWidth:1,
                    anchor:'98%',
                    name:'EReceivableId',
                    id:'EReceivableId'
                }]
	        }]
        },
            {
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
                        anchor: '98%',
                        name: 'ENotes',
                        id: 'ENotes',
                        editable: false
                    }]
                }]
            }]
    });
    if (typeof (openEditWin) == "undefined") {//�������2��windows����
            openEditWin = new Ext.Window({
                title: 'Ӧ���ʿ�ά��'
		            , iconCls: 'upload-win'
		            , width: 750
		            , height: 150
		            , layout: 'form'
		            , plain: true
		            , modal: true
		            , constrain: true
		            , resizable: false
		            , closeAction: 'hide'
		            , autoDestroy: true
		            , items: [modeditForm]
		            , buttons: [{
		                text: "����"
			            , handler: function() {
			                //��ȡ������Ϣ
                            Ext.MessageBox.wait("�������ڱ��棬���Ժ򡭡�");
                            Ext.Ajax.request({
                                url: 'frmFmAccRece.aspx?method=adjustRecord',
                                method: 'POST',
                                params: {
                                    ReceivableId: Ext.getCmp('EReceivableId').getValue(),
                                    BusinessType: Ext.getCmp('EBusinessType').getValue(),
                                    FundType: Ext.getCmp('EFundType').getValue(),
                                    PayType: Ext.getCmp('EPayType').getValue(),
                                    Amount: Ext.getCmp('EAmount').getValue(),
                                    Notes: Ext.getCmp('ENotes').getValue()
                                },
                                success: function(resp, opts) {
                                    Ext.MessageBox.hide();
                                    if (checkExtMessage(resp)) { 
			                            ModDtlGridData.reload();
                                    }
                                },
                                failure: function(resp, opts) {
                                    Ext.MessageBox.hide();
                                    Ext.Msg.alert("��ʾ", "����ʧ��"); 
                                }
                            });
			            }
			            , scope: this
		            },
		            {
		                text: "ȡ��"
			            , handler: function() {
			                openEditWin.hide();
			                ModDtlGridData.reload();
			            }
			            , scope: this
                }]
            });
        }
        function editorRecord()
        {   
            var sm = ModOrderDtlGrid.getSelectionModel();
            var selectData = sm.getSelected();
            if(selectData != null){
                openEditWin.show();
                dsPayType.clearFilter();
                Ext.getCmp('EReceivableId').setValue(selectData.data.ReceivableId);
                Ext.getCmp('EBusinessType').setValue(selectData.data.BusinessType);
                Ext.getCmp('EFundType').setValue(selectData.data.FundType);
                Ext.getCmp('EPayType').setValue(selectData.data.PayType);
                Ext.getCmp('EAmount').setValue(selectData.data.Amount);
                Ext.getCmp('ENotes').setValue(selectData.data.Notes);
            }else{                
              Ext.Msg.alert("��ʾ", "��ѡ����Ҫ�޸ĵļ�¼��");
            }
        }
    })
</script>

</html>
