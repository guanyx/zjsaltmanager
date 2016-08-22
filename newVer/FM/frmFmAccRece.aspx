<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmFmAccRece.aspx.cs" Inherits="FM_frmFmAccRece" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html>
<head>
<title>应收帐款管理</title><meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
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

    /*------实现toolbar的函数 start---------------*/
    var Toolbar = new Ext.Toolbar({
        renderTo: "toolbar",
        items: [{
            text: "新增收款记录",
            icon: "../Theme/1/images/extjs/customer/add16.gif",
            handler: function() { popAddWin(); }
}]
        });
        /*------结束toolbar的函数 end---------------*/

        //客户列表选择
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

        //弹出新增窗口
        function popAddWin() {
            var sm = MstGrid.getSelectionModel();
            var selectData = sm.getSelected();
            if (selectData == null || selectData == "") {
                Ext.Msg.alert("提示", "请选中录入收款记录的客户！");
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


        //新增保存
        function saveAdd() {
            //获取主表信息
            var sm = MstGrid.getSelectionModel();
            var selectData = sm.getSelected();
            Ext.MessageBox.wait("数据正在保存，请稍候……");
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
                    Ext.Msg.alert("提示", "保存失败"); 
                }
            });
        }

        //////////////////////////////Start 列表界面/////////////////////////////////////////////////////////////////
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
                labelSeparator: '：',
                items: [
                {
                    layout: 'form',
                    border: false,
                    columnWidth: 0.33,
                    items: [
	                {
	                    xtype: 'textfield',
	                    fieldLabel: '客户编号',
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
	                    fieldLabel: '客户名称',
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
	                    text: '查询',
	                    buttonAlign: 'right',
	                    id: 'searchebtnId',
	                    anchor: '25%',
	                    handler: function() { QueryDataGrid(); }
	                }]
                }]
	        }]
        });


        /*------开始获取数据的函数 start---------------*/
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

        /*------获取数据的函数 结束 End---------------*/

        /*------开始DataGrid的函数 start---------------*/

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
            loadMask: { msg: '正在加载数据，请稍侯……' },
            sm: sm,
            cm: new Ext.grid.ColumnModel([

            sm,
            new Ext.grid.RowNumberer(), //自动行号
              {header: "客户ID", dataIndex: 'CustomerId', hidden: true, hideable: false },
              { header: "客户编号", width: 100, sortable: true, dataIndex: 'CustomerNo' },
              { header: "客户名称", width: 180, sortable: true, dataIndex: 'ShortName' },
              { header: "联系人", width: 100, sortable: true, dataIndex: 'LinkMan' },
              { header: "联系电话", width: 80, sortable: true, dataIndex: 'LinkTel' },
              { header: "移动电话", width: 80, sortable: true, dataIndex: 'LinkMobile', hidden: true, hideable: false },
              { header: "传真", width: 80, sortable: true, dataIndex: 'Fax', hidden: true, hideable: false },
              { header: "配送类型", width: 60, sortable: true, dataIndex: 'DistributionTypeText' },
              { header: "月用量", width: 50, sortable: true, dataIndex: 'MonthQuantity' },
              { header: "是客商", width: 50, sortable: true, dataIndex: 'IsCust', renderer: { fn: function(v) { if (v == 1) return '是'; return '否'; } } },
              { header: "是供应商", width: 60, sortable: true, dataIndex: 'IsProvide', renderer: { fn: function(v) { if (v == 1) return '是'; return '否'; } } },
              { header: "创建时间", width: 110, sortable: true, dataIndex: 'CreateDate', renderer: Ext.util.Format.dateRenderer('Y年m月d日')}//renderer: Ext.util.Format.dateRenderer('m/d/Y'),

            ]),
            bbar: new Ext.PagingToolbar({
                pageSize: 10,
                store: MstGridData,
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
        /*------DataGrid的函数结束 End---------------*/
        //////////////////////////////////End 列表界面/////////////////////////////////////////////////////////////



        ////////////////////////Start 修改界面///////////////////////////////////////////////////////////////////////        
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
                labelSeparator: '：',
                items: [
                {
                    layout: 'form',
                    border: false,
                    columnWidth: 0.3,
                    items: [
                    {
                        xtype: 'textfield',
                        fieldLabel: '客户编码',
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
                        fieldLabel: '客户名称',
                        columnWidth: 0.7,
                        anchor: '90%',
                        name: 'ModCustomerName',
                        id: 'ModCustomerName',
                        readOnly: true
                    }]
                }]
            }]
        });


        /*------开始获取数据的函数 start---------------*/
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

        /*------获取数据的函数 结束 End---------------*/

        /*------开始DataGrid的函数 start---------------*/

        var sm = new Ext.grid.CheckboxSelectionModel({
            singleSelect: true
        });
        var ModOrderDtlGrid = new Ext.grid.EditorGridPanel({
            autoScroll: true,
            height: 220,
            id: '',
            store: ModDtlGridData,
            loadMask: { msg: '正在加载数据，请稍侯……' },
            sm: sm,
            cm: new Ext.grid.ColumnModel([
		                    sm,
		                    new Ext.grid.RowNumberer(), //自动行号
		                    {
		                        header: '序号',
		                        dataIndex: 'ReceivableId',
		                        id: 'ReceivableId',
		                        width:70
		                    },
		                    {
		                        header: '业务种类',
		                        dataIndex: 'BusinessTypeText',
		                        id: 'BusinessTypeText',
		                        width:60
		                    },
		                    {
		                        header: '资金方向',
		                        dataIndex: 'FundType',
		                        id: 'FundType',
		                        renderer: function(v,meta,rec) {
		                            if(rec.data.BusinessType=='F062')
		                            {
		                                if(v=='F051') return '应退';
		                                else if(v=='F052') return '退款';
		                            }
		                            var index = dsFundType.findBy(function(record, id) {
		                                return record.get('DicsCode') == v;
		                            });
		                            return dsFundType.getAt(index).get('DicsName');

		                        },
		                        width:60
		                    },
		                    {
		                        header: '付款类型',
		                        dataIndex: 'PayTypeText',
		                        id: 'PayTypeText',
		                        width:60
		                    },
		                    {
		                        header: '金额',
		                        dataIndex: 'Amount',
		                        id: 'Amount',
		                        renderer: function(v) {
		                            return Number(v).toFixed(2);
		                        },
		                        align:'right',
		                        width:100
		                    },
		                    {
		                        header: '累计金额',
		                        dataIndex: 'TotalAmount',
		                        id: 'TotalAmount',
		                        renderer: function(v) {
		                            return Number(v).toFixed(2);
		                        },
		                        align:'right',
		                        width:100
		                    },
		                    {
		                        header: '操作员',
		                        dataIndex: 'OperName',
		                        id: 'OperName',
		                        width:60
		                    },
		                    {
		                        header: '操作日期',
		                        dataIndex: 'CreateDate',
		                        id: 'CreateDate',
		                        renderer: Ext.util.Format.dateRenderer('Y年m月d日'),
		                        width:110
		                    },
		                    {
		                        header: '备注',
		                        dataIndex: 'Notes',
		                        id: 'Notes',
		                        width:60
		                    }
		                    ]),
            bbar: new Ext.PagingToolbar({
                pageSize: 10,
                store: ModDtlGridData,
                displayMsg: '显示第{0}条到{1}条记录,共{2}条',
                emptyMsy: '没有记录',
                displayInfo: true
            }),
            tbar:new Ext.Toolbar({
                items: [{
                    text: "修改记录",
                    icon: "../Theme/1/images/extjs/customer/edit16.gif",
                    handler: function() { editorRecord();}
                },{
                    text: "删除记录",
                    icon: "../Theme/1/images/extjs/customer/delete16.gif",
                    handler: function() { deleteRecord();}
                }]
            }),
            viewConfig: {
                columnsText: '显示的列',
                scrollOffset: 20,
                sortAscText: '升序',
                sortDescText: '降序',
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

        //应收帐款输入内容
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
                labelSeparator: '：',
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
                        fieldLabel: '业务种类',
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
                                            rec.set('DicsName','应退');
                                        else if(rec.get('DicsCode')=='F052')
                                            rec.set('DicsName','退款');
                                    }
                                    else if(Ext.getCmp('BusinessType').getValue()=='F061'){
                                        if(rec.get('DicsCode')=='F051')
                                            rec.set('DicsName','应收');
                                        else if(rec.get('DicsCode')=='F052')
                                            rec.set('DicsName','收款');
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
                        fieldLabel: '资金方向',
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
                            fieldLabel: '付款类型',
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
                            fieldLabel: '金额',
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
                labelSeparator: '：',
                items: [
                {
                    layout: 'form',
                    border: false,
                    columnWidth: 1,
                    items: [
                    {
                        xtype: 'textfield',
                        fieldLabel: '备注',
                        columnWidth: 1,
                        anchor: '98%',
                        name: 'Notes',
                        id: 'Notes',
                        editable: false
                    }]
                }]
            }]
        });
    
        if (typeof (openAddWin) == "undefined") {//解决创建2个windows问题
            openAddWin = new Ext.Window({
                id: 'openModWin',
                title: '应收帐款维护'
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
		                text: "保存"
			            , handler: function() {
			                saveAdd();
			            }
			            , scope: this
		            },
		            {
		                text: "取消"
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

        ////////////////////////End 修改界面///////////////////////////////////////////////////////////////////////
        function deleteRecord()
        {
            Ext.Msg.confirm("提示信息", "确定要删除记录？", function callBack(id) {
                //判断是否删除数据
                if (id == "yes") {
                    var sm = ModOrderDtlGrid.getSelectionModel();
                    var selectData = sm.getSelected();
                    Ext.MessageBox.wait("数据正在处理，请稍候……");
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
                            Ext.Msg.alert("提示", "保存失败"); 
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
                labelSeparator: '：',
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
                        fieldLabel: '业务种类',
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
                                            rec.set('DicsName','应退');
                                        else if(rec.get('DicsCode')=='F052')
                                            rec.set('DicsName','退款');
                                    }
                                    else if(Ext.getCmp('EBusinessType').getValue()=='F061'){
                                        if(rec.get('DicsCode')=='F051')
                                            rec.set('DicsName','应收');
                                        else if(rec.get('DicsCode')=='F052')
                                            rec.set('DicsName','收款');
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
                fieldLabel: '资金方向',
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
                        fieldLabel: '付款类型',
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
                    fieldLabel: '金额',
                    columnWidth: 0.25,
                    anchor: '90%',
                    name: 'EAmount',
                    id: 'EAmount',
                    editable: false
                },{
                    xtype:'hidden',
                    fieldLabel:'标识',
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
                labelSeparator: '：',
                items: [
                {
                    layout: 'form',
                    border: false,
                    columnWidth: 1,
                    items: [
                    {
                        xtype: 'textfield',
                        fieldLabel: '备注',
                        columnWidth: 1,
                        anchor: '98%',
                        name: 'ENotes',
                        id: 'ENotes',
                        editable: false
                    }]
                }]
            }]
    });
    if (typeof (openEditWin) == "undefined") {//解决创建2个windows问题
            openEditWin = new Ext.Window({
                title: '应收帐款维护'
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
		                text: "保存"
			            , handler: function() {
			                //获取主表信息
                            Ext.MessageBox.wait("数据正在保存，请稍候……");
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
                                    Ext.Msg.alert("提示", "保存失败"); 
                                }
                            });
			            }
			            , scope: this
		            },
		            {
		                text: "取消"
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
              Ext.Msg.alert("提示", "请选择需要修改的记录！");
            }
        }
    })
</script>

</html>
