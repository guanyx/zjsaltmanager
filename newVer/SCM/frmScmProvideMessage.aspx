<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmScmProvideMessage.aspx.cs" Inherits="SCM_frmScmProvideMessage" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>无标题页</title>
    <link rel="stylesheet" type="text/css" href="../ext3/resources/css/ext-all.css" />
    <link rel="stylesheet" href="../css/orderdetail.css"/>
<script type="text/javascript" src="../ext3/adapter/ext/ext-base.js"></script>
<script type="text/javascript" src="../ext3/ext-all.js"></script>
<script type="text/javascript" src="../ext3/src/locale/ext-lang-zh_CN.js"></script>
<script type="text/javascript" src="../js/operateResp.js"></script>
<script type="text/javascript" src="../js/FilterControl.js"></script>
<script type="text/javascript" src="../js/ExtJsHelper.js"></script>
<script type="text/javascript" src="../js/floatUtil.js"></script>
<script type="text/javascript" src="../js/getExcelXml.js"></script>
<script type="text/javascript" src="../js/ExtJsHelper.js"></script>
<style type="text/css">
.x-grid-record-red table{  
    color: #FF0000;  
} 
</style>
<%=getComboBoxSource()%>
<script type="text/javascript">
    var imageUrl = "../Theme/1/";
    function getCmbStore(columnName) {
        switch (columnName) {
            case "PlanType":
                return cmbPlanTypeList;
            case "Status":
                return cmbStatusList;
            default:
                return null;
        }
    }

    var formTitle = '';
    Ext.onReady(function() {
        Ext.BLANK_IMAGE_URL = "../ext3/resources/images/default/s.gif"
        Ext.form.TextField.prototype.afterRender = Ext.form.TextField.prototype.afterRender.createSequence(function() {
            this.relayEvents(this.el, ['onblur']);
        });
        Ext.QuickTips.init();
        var saveType = "";
        /*------实现toolbar的函数 start---------------*/
        var Toolbar = new Ext.Toolbar({
            renderTo: "toolbar"
            //	items:[{
            //		text:"新增",
            //		icon:imageUrl+"images/extjs/customer/add16.gif",
            //		handler:function(){
            //		        
            ////		        messageQtv;
            //		    }
            //		},'-',{
            //		text:"编辑",
            //		icon:imageUrl+"images/extjs/customer/edit16.gif",
            //		handler:function(){
            //		       
            //		    }
            //		},'-',{
            //		text:"删除",
            //		icon:imageUrl+"images/extjs/customer/delete16.gif",
            //		handler:function(){
            //		        DeleteMessage();
            //		        
            //		    }
            //		},'-',{
            //		text:"确认",
            //		icon:imageUrl+"images/extjs/customer/edit16.gif",
            //		handler:function(){
            //		        ConfirmMessage();
            //		    }
            //		}
            //	]
        });

        iniToolBar(Toolbar);
        //添加ToolBar事件
        function addToolBarEvent() {
            for (var i = 0; i < Toolbar.items.length; i++) {
                switch (Toolbar.items.items[i].text) {
                    case "新增":
                        Toolbar.items.items[i].on("click", openAddMessageWin);
                        break;
                    case "编辑":
                        Toolbar.items.items[i].on("click", modifyMessageWin);
                        break;
                    case "删除":
                        Toolbar.items.items[i].on("click", DeleteMessage);
                        break;
                    case "查看":
                        Toolbar.items.items[i].on("click", viewMessage);
                        break;
                    case "确认":
                        Toolbar.items.items[i].on("click", ConfirmMessage);
                        break;
                    case "生成入仓进货单":
                        Toolbar.items.items[i].on("click", createStoreOrder);
                        break;
                    case "打印":
                        Toolbar.items.items[i].on("click", printOrderById);
                        break;
                    case "取消确认":
                        Toolbar.items.items[i].on("click", cancleMessage);
                        break;

                }
            }
        }
        addToolBarEvent();
        /*------结束toolbar的函数 end---------------*/
function getUrl(imageUrl)
            {
                var index = window.location.href.toLowerCase().indexOf('/scm/');
                var tempUrl = window.location.href.substring(0,index);
                return tempUrl+"/"+imageUrl;
            }
function printOrderById()
{
var sm = messageGrid.getSelectionModel();
                //多选
                var selectData = sm.getSelections();                
                var array = new Array(selectData.length);
                var orderIds = "";
                for(var i=0;i<selectData.length;i++)
                {
                    if(orderIds.length>0)
                        orderIds+=",";
                    orderIds += selectData[i].get('ProvideMessageId');
                }
                //页面提交
                Ext.Ajax.request({
                    url: 'frmScmProvideMessage.aspx?method=getprintdata',
//                    url:'frmOrderMst.aspx?method=billdata',
                    method: 'POST',
                    params: {
                        ProvideMessageId: orderIds
                    },
                   success: function(resp,opts){ 
                       var printData =  resp.responseText;
                       var printControl =  parent.parent.parent.document.getElementById("topFrame").contentWindow.getPrintControl();
                       printControl.Url =getUrl('xml');
                       printControl.MapUrl = printControl.Url+'/'+printStyleXml;//'/salePrint1.xml';
                       printControl.PrintXml = printData;
                       printControl.ColumnName="ProvideMessageId";
                       printControl.OnlyData=printOnlyData;
                       printControl.PageWidth=printPageWidth;
                       printControl.PageHeight =printPageHeight ;
                       printControl.Print();
//                    var billControl = document.getElementById('billControl');
//                    billControl.PrintXml = printData;
//                    billControl.setFormValue(0);
                       
                   },
		           failure: function(resp,opts){  /* Ext.Msg.alert("提示","保存失败"); */    }
                });
}
        /*------开始ToolBar事件函数 start---------------*/
        /*------打印选定的记录数据信息-----------*/
        var printform = null;
        function printMessage() {
            var sm = Ext.getCmp('messageGrid').getSelectionModel();
            //获取选择的数据信息
            var selectData = sm.getSelected();
            if (selectData == null) {
                Ext.Msg.alert("提示", "请选中需要打印的信息！");
                return;
            }

            if (printform == null) {
                printform = ExtJsShowWin('单据打印', '../common/frmDocReport.aspx?reportId=121&ObjectKeyValue=' + selectData.data.ProvideMessageId, 'doc', 800, 600);
            }
            else {
                document.getElementById('iframedoc').src = '../common/frmDocReport.aspx?reportId=121&ObjectKeyValue=' + selectData.data.ProvideMessageId;
            }
            printform.show();
        }

        /*-----新增Message实体类窗体函数----*/
        function openAddMessageWin() {
            Ext.getCmp('CustomerId').setValue("");
            Ext.getCmp('CustomerName').setValue("");
            Ext.getCmp('SendDate').setValue("");
            //Ext.getCmp('OperatId').setValue("");
            //Ext.getCmp('CreateDate').setValue("");
            Ext.getCmp('Status').setValue("S2801");
            Ext.getCmp('PlanType').setValue("");
            Ext.getCmp('StartDate').setValue(new Date().clearTime());
            Ext.getCmp('EndDate').setValue("");
            uploadMessageWindow.show();
            //设置保存时类型	
            saveType = "add";
            //清楚细项数据
            msgDtlGridData.removeAll();
            //新增KeyDown事件
            AddKeyDownEvent('messageDiv');
            //设置弹出客户信息
            if (customer == null) {
                setCustomerShow();
            }
            //设置选择产品信息为空
            productGrid.removeAll();
            
            //调整privilege
            checkPrivilege(msgDtlGrid);
        }
        /*-----编辑Message实体类窗体函数----*/
        function modifyMessageWin() {
            var sm = Ext.getCmp('messageGrid').getSelectionModel();
            //获取选择的数据信息
            var selectData = sm.getSelected();
            if (selectData == null) {
                Ext.Msg.alert("提示", "请选中需要编辑的信息！");
                return;
            }
            uploadMessageWindow.show();
            setFormValue(selectData);

            saveType = "edit";
            AddKeyDownEvent('messageDiv');
            if (customer == null) {
                setCustomerShow();
            }
            
            //调整privilege
            checkPrivilege(msgDtlGrid);
        }

        function cancleMessage() {
            var sm = Ext.getCmp('messageGrid').getSelectionModel();
            //获取选择的数据信息
            var selectData = sm.getSelected();
            if (selectData == null) {
                Ext.Msg.alert("提示", "请选中需要取消的信息！");
                return;
            }
            //删除前再次提醒是否真的要删除
            Ext.Msg.confirm("提示信息", "是否真的要取消选择的信息吗？", function callBack(id) {
                //判断是否删除数据
                if (id == "yes") {
                    //页面提交
                    Ext.Ajax.request({
                        url: 'frmScmProvideMessage.aspx?method=cancleMessage',
                        method: 'POST',
                        params: {
                            MessageId: selectData.data.ProvideMessageId
                        },
                        success: function(resp, opts) {
                            if (checkExtMessage(resp)) {
                                messageGridData.reload();
                            }
                        },
                        failure: function(resp, opts) {
                            Ext.Msg.alert("提示", "数据确认失败");
                        }
                    });
                }
            });
        }

        /*-----查看-----------*/
        function viewMessage() {
            var sm = Ext.getCmp('messageGrid').getSelectionModel();
            //获取选择的数据信息
            var selectData = sm.getSelected();
            if (selectData == null) {
                Ext.Msg.alert("提示", "请选中需要查看的信息！");
                return;
            }
            setFormValue(selectData);
            uploadMessageWindow.show();
            uploadMessageWindow.buttons[0].setVisible(false);
        }
        /*-----删除Message实体函数----*/
        /*删除信息*/
        function DeleteMessage() {
            var sm = Ext.getCmp('messageGrid').getSelectionModel();
            //获取选择的数据信息
            var selectData = sm.getSelected();
            //如果没有选择，就提示需要选择数据信息
            if (selectData == null) {
                Ext.Msg.alert("提示", "请选中需要删除的采购信息！");
                return;
            }
            //删除前再次提醒是否真的要删除
            Ext.Msg.confirm("提示信息", "是否真的要确认选择的采购信息吗？", function callBack(id) {
                //判断是否删除数据
                if (id == "yes") {
                    //页面提交
                    Ext.Ajax.request({
                        url: 'frmScmProvideMessage.aspx?method=deletemessage',
                        method: 'POST',
                        params: {
                            ProvideMessageId: selectData.data.ProvideMessageId
                        },
                        success: function(resp, opts) {
                            if (checkExtMessage(resp)) {
                                messageGridData.reload();
                            }
                        },
                        failure: function(resp, opts) {
                            Ext.Msg.alert("提示", "数据删除失败");
                        }
                    });
                }
            });
        }
        /*删除信息*/
        function ConfirmMessage() {
            var sm = Ext.getCmp('messageGrid').getSelectionModel();
            //获取选择的数据信息
            var selectData = sm.getSelected();
            //如果没有选择，就提示需要选择数据信息
            if (selectData == null) {
                Ext.Msg.alert("提示", "请选中需要确认的信息！");
                return;
            }
            //删除前再次提醒是否真的要删除
            Ext.Msg.confirm("提示信息", "是否真的要确认选择的信息吗？", function callBack(id) {
                //判断是否删除数据
                if (id == "yes") {
                    //页面提交
                    Ext.Ajax.request({
                        url: 'frmScmProvideMessage.aspx?method=confirmmessage',
                        method: 'POST',
                        params: {
                            MessageId: selectData.data.ProvideMessageId
                        },
                        success: function(resp, opts) {
                            if (checkExtMessage(resp)) {
                                messageGridData.reload();
                            }
                        },
                        failure: function(resp, opts) {
                            Ext.Msg.alert("提示", "数据确认失败");
                        }
                    });
                }
            });
        }

        /*删除信息*/
        function createStoreOrder() {
            var sm = Ext.getCmp('messageGrid').getSelectionModel();
            //获取选择的数据信息
            var selectData = sm.getSelected();
            //如果没有选择，就提示需要选择数据信息
            if (selectData == null) {
                Ext.Msg.alert("提示", "请选中需要生成进仓单的采购信息！");
                return;
            }
            //删除前再次提醒是否真的要删除
            Ext.Msg.confirm("提示信息", "是否真的要确认生成进仓单信息吗？", function callBack(id) {
                //判断是否删除数据
                if (id == "yes") {
                    //页面提交
                    Ext.Ajax.request({
                        url: 'frmScmProvideMessage.aspx?method=createstore',
                        method: 'POST',
                        params: {
                            ProvideMessageId: selectData.data.ProvideMessageId
                        },
                        success: function(resp, opts) {
                            if (checkExtMessage(resp)) {
                                messageGridData.reload();
                            }
                        },
                        failure: function(resp, opts) {
                            Ext.Msg.alert("提示", "生成进仓单信息失败");
                        }
                    });
                }
            });
        }
    /*------实现FormPanle的函数 start---------------*/
    var messageDiv = new Ext.form.FormPanel({
        frame: true,
        title: '',
        region: 'north',
        height: 80,
        items: [
	    {
	        layout: 'column',
	        border: false,
	        labelSeparator: '：',
	        items: [
		    {
		        layout: 'form',
		        border: false,
		        columnWidth: 0.66,
		        items: [
			    {
			        xtype: 'textfield',
			        fieldLabel: '供应商标识',
			        columnWidth: 0.66,
			        anchor: '90%',
			        name: 'CustomerId',
			        id: 'CustomerId',
			        hideLabel: true,
			        hidden: true
			    }]
		    }, 
            {
                layout: 'form',
                border: false,
                columnWidth: 0.66,
                items: [
                {
                    xtype: 'textfield',
                    fieldLabel: '供应商',
                    columnWidth: 0.66,
                    anchor: '90%',
                    name: 'CustomerName',
                    id: 'CustomerName'
                }]
		    }
            , {
                layout: 'form',
                border: false,
                columnWidth: 0.33,
                items: [
				{
				    xtype: 'datefield',
				    fieldLabel: '确认日期',
				    columnWidth: 0.33,
				    anchor: '90%',
				    name: 'SendDate',
				    id: 'SendDate',
				    format: "Y年m月d日",
				    disabled: true
				}]
            }]
	    },
        //	{
        //	    layout: 'column',
        //	    border: false,
        //	    labelSeparator: '：',
        //	    items: [
        //		{
        //		    layout: 'form',
        //		    border: false,
        //		    columnWidth: 0.33,
        //		    items: [
        //				{
        //				    xtype: 'textfield',
        //				    fieldLabel: '操作人',
        //				    columnWidth: 0.33,
        //				    anchor: '90%',
        //				    name: 'OperatId',
        //				    id: 'OperatId'
        //				}
        //		]
        //		}
        //, {
        //    layout: 'form',
        //    border: false,
        //    columnWidth: 0.33,
        //    items: [
        //				{
        //				    xtype: 'datefield',
        //				    fieldLabel: '创建时间',
        //				    columnWidth: 0.33,
        //				    anchor: '90%',
        //				    name: 'CreateDate',
        //				    id: 'CreateDate',
        //				    format: "Y年m月d日"
        //				}
        //		]
        //}
        //, {
        //    layout: 'form',
        //    border: false,
        //    columnWidth: 0.33,
        //    items: [
        //				{
        //				    xtype: 'combo',
        //				    fieldLabel: '状态',
        //				    columnWidth: 0.33,
        //				    anchor: '90%',
        //				    name: 'Status',
        //				    id: 'Status',
        //				    store: cmbStatusList,
        //				    editable: false,
        //				    triggerAction: 'all',
        //				    mode: 'local',
        //				    displayField: 'DicsName',
        //				    valueField: 'DicsCode',
        //				    disabled: true
        //				}
        //		]
        //}
        //	]
        //	},
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
	                xtype: 'combo',
	                fieldLabel: '状态',
	                columnWidth: 0.33,
	                anchor: '90%',
	                name: 'Status',
	                id: 'Status',
	                store: cmbStatusList,
	                editable: false,
	                triggerAction: 'all',
	                mode: 'local',
	                displayField: 'DicsName',
	                valueField: 'DicsCode',
	                disabled: true
	            }]
	        },
	        {
	            layout: 'form',
	            border: false,
	            columnWidth: 0.33,
	            labelWidth:60,
	            items: [
		        {
	                xtype: 'textfield',
			        fieldLabel: '车船号',
			        columnWidth: 0.66,
			        anchor: '80%',
			        name: 'ShipNo',
			        id: 'ShipNo'
			    }]
	        },
		    {
		        layout: 'form',
		        border: false,
		        columnWidth: 0.33,
		        items: [
			    {
			        xtype: 'combo',
			        //fieldLabel: '对应计划类型',
			        columnWidth: 0.33,
			        anchor: '90%',
			        name: 'PlanType',
			        id: 'PlanType',
			        store: cmbPlanTypeList,
			        editable: false,
			        triggerAction: 'all',
			        mode: 'local',
			        displayField: 'DicsName',
			        valueField: 'DicsCode',
			        hidden: true
			    }]
		    }
            , {
                layout: 'form',
                border: false,
                columnWidth: 0.33,
                items: [
	            {
	                xtype: 'datefield',
	                fieldLabel: '订单日期',
	                columnWidth: 0.33,
	                anchor: '90%',
	                name: 'StartDate',
	                id: 'StartDate',
	                format: "Y年m月d日",
	                value: new Date().clearTime() 
	            }]
            }
            , {
                layout: 'form',
                border: false,
                columnWidth: 0.33,
                items: [
	            {
	                xtype: 'datefield',
	                //fieldLabel: '结束日期',
	                columnWidth: 0.33,
	                anchor: '90%',
	                name: 'EndDate',
	                id: 'EndDate',
	                format: "Y年m月d日",
	                hidden: true
	            }]
            }]
        }]
    });
        /*------FormPanle的函数结束 End---------------*/

        //定义下拉框异步调用方法
        var dsCustomer = new Ext.data.Store({
            url: 'frmScmProvideMessage.aspx?method=getsuppiler',
            reader: new Ext.data.JsonReader({
                root: 'root',
                totalProperty: 'totalProperty',
                id: 'cusno'
            }, [
                { name: 'CustomerId', mapping: 'CustomerId' },
                { name: 'CustomerNo', mapping: 'CustomerNo' },
                { name: 'ShortName', mapping: 'ShortName' },
                { name: 'ChineseName', mapping: 'ChineseName' },
                { name: 'Address', mapping: 'Address' },
                { name: 'LinkMan', mapping: 'LinkMan' },
                { name: 'LinkTel', mapping: 'LinkTel' },
                { name: 'DeliverAdd', mapping: 'DeliverAdd' }
            ])
        });
        // 定义下拉框异步返回显示模板
        var resultTpl = new Ext.XTemplate(
            '<tpl for="."><div id="searchdivid" class="search-item">',
                '<h3><span>编号:{CustomerNo}&nbsp;  名称:{ShortName}&nbsp;  联系人:{LinkMan}&nbsp;  电话:{LinkTel}</span></h3>',
            '</div></tpl>'
        );

        var customer = null;
        function setCustomerShow() {
            customer = new Ext.form.ComboBox({
                xtype: 'combo',
                store: dsCustomer,
                applyTo: 'CustomerName',
                minChars: 1,
                pageSize: 10,
                tpl: resultTpl,
                hideTrigger: true,
                itemSelector: 'div.search-item',
                anchor: '98%',
                onSelect: function(record) {
                    Ext.getCmp("CustomerId").setValue(record.data.CustomerId);
                    Ext.getCmp("CustomerName").setValue(record.data.ShortName);
                    //                    if (productGridData.baseParams.Supplier != record.data.CustomerId) {
                    //                        productGridData.removeAll();
                    //                        productGridData.baseParams.Supplier = record.data.CustomerId;
                    //                        productGridData.reload();
                    //                    }
                    this.collapse(); //隐藏下拉列表
                }
            });
        }

        /*------开始获取细项数据的函数 start---------------*/
       
        var msgDtlGridData = new Ext.data.Store
({
    url: 'frmScmProvideMessage.aspx?method=getdtllist',
    reader: new Ext.data.JsonReader({
        totalProperty: 'totalProperty',
        root: 'root'
    }, [
	{ name: 'ProvideMessageDetailId' },
	{ name: 'ProvideMessageId' },
	{ name: 'ProvidePlanId' },
	{ name: 'ProductId' },
	{ name: 'MessageQtv' },
	{ name: 'MessagePrice' },
	{ name: 'MessageAmt' },
	{ name: 'MessageUnit' },
	{ name: 'SenderAdd' },
	{ name: 'SendType' },
	{ name: 'ProductName' },
	{ name: 'Memo'}])
});

        var RowPattern = Ext.data.Record.create([
            { name: 'ProvideMessageDetailId' },
	        { name: 'ProvideMessageId' },
	        { name: 'ProvidePlanId' },
	        { name: 'ProductId' },
	        { name: 'MessageQtv' },
	        { name: 'MessagePrice' },
	        { name: 'MessageAmt' },
	        { name: 'MessageUnit' },
	        { name: 'SenderAdd' },
	        { name: 'SendType' },
	        { name: 'ProductName' },
	        { name: 'Memo'}]);

        function insertNewBlankRow(selectedData) {
            if (msgDtlGridData.find("ProductId", selectedData.data.ProductId) != -1)
                return;
            var rowCount = msgDtlGrid.getStore().getCount();
            var insertPos = parseInt(rowCount);
            var addRow = new RowPattern({
                ProvideMessageDetailId: -rowCount,
                ProvideMessageId: '0',
                ProvidePlanId: 0,
                ProductId: selectedData.data.ProductId,
                MessageQtv: 0,
                MessagePrice: selectedData.data.SalePrice,
                MessageAmt: 0,
                MessageUnit: selectedData.data.Unit,
                SenderAdd: '',
                SendType: '',
                ProductName: selectedData.data.ProductName,
                Memo: ''
            });
            msgDtlGrid.stopEditing();
            if (insertPos > 0) {
                var rowIndex = msgDtlGridData.insert(insertPos, addRow);
                msgDtlGrid.startEditing(insertPos, 0);
            }
            else {
                var rowIndex = msgDtlGridData.insert(0, addRow);
                // planDtlGrid.startEditing(0, 0);
            }
        }
        /*------获取数据的函数 结束 End---------------*/

        function cmbSendType(val) {
            var index = SendTypeStore.find('DicsCode', val);
            if (index < 0)
                return "";
            var record = SendTypeStore.getAt(index);
            return record.data.DicsName;
        }
        /*------开始DataGrid的函数 start---------------*/

        /************设置单位信息 ***********************************/

        //定义下拉框异步调用方法,当前客户可订商品列表
        var dsProductUnits = new Ext.data.Store({
            url: 'frmOrderDtl.aspx?method=getProductUnits',
            params: {
                ProductId: 0
            },
            reader: new Ext.data.JsonReader({
                root: 'root',
                totalProperty: 'totalProperty',
                id: 'ProductUnits'
            }, [
                { name: 'UnitId', mapping: 'UnitId' },
                { name: 'UnitName', mapping: 'UnitName' }
            ])
        });

        //计量单位下拉框
        var UnitCombo = new Ext.form.ComboBox({
            store: dsProductUnits,
            displayField: 'UnitName',
            valueField: 'UnitId',
            triggerAction: 'all',
            id: 'UnitCombo',
            //pageSize: 5,  
            //minChars: 2,  
            //hideTrigger: true,  
            typeAhead: true,
            mode: 'local',
            emptyText: '',
            selectOnFocus: false,
            editable: false
        });

        function beforeEdit(e) {
            var record = e.record;
            if (record.data.ProductId != dsProductUnits.baseParams.ProductId) {
                dsProductUnits.baseParams.ProductId = record.data.ProductId;
                dsProductUnits.load();
            }
        }
  
           
        var sm = new Ext.grid.CheckboxSelectionModel({
            singleSelect: true
        });
        var msgDtlGrid = new Ext.grid.EditorGridPanel({
            width: '100%',
            //height: 200,
            autoWidth: true,
            region: 'center',
            //autoHeight: true,
            autoScroll: true,
            layout: 'fit',
            clicksToEdit: 1,
            id: 'msgDtlGrid',
            store: msgDtlGridData,
            loadMask: { msg: '正在加载数据，请稍侯……' },
            sm: sm,
            cm: new Ext.grid.ColumnModel([
		    sm,
		    new Ext.grid.RowNumberer(), //自动行号
		    {
		        header: '产品名称',
		        dataIndex: 'ProductName',
		        id: 'ProductName',
		        width:260
            },
		    {
		        header: '订购数量',
		        dataIndex: 'MessageQtv',
		        id: 'MessageQtv',
		        editor: new Ext.form.NumberField({
                    listeners: {
                        'focus': function() {
                            this.selectText();
                        }
                    },
                    decimalPrecision: 6
                })
		    }, {
		        header: '单位',
		        dataIndex: 'MessageUnit',
		        id: 'MessageUnit',
		        editor: UnitCombo,
		        renderer: function(value, cellmeta, record, rowIndex, columnIndex, store) {
		        var index = dsUnitList.findBy(function(record, id) {
		            return record.get(UnitCombo.valueField) == value;
		        });
		            var record = dsUnitList.getAt(index);
		            var displayText = "";
		            // 如果下拉列表没有被选择，那么record也就不存在，这时候，返回传进来的value，
		            // 而这个value就是grid的USER_REALNAME列的value，所以直接返回
		            if (record == null) {
		                //返回默认值，
		                displayText = value;
		            } else {
		                displayText = record.data.UnitName; //获取record中的数据集中的process_name字段的值
		            }
		            return displayText;
		        }
		    }, {
		        header: '价格',
		        dataIndex: 'MessagePrice',
		        id: 'MessagePrice',
		        editor: new Ext.form.NumberField({
		            listeners: {
		                'focus': function() {
		                    this.selectText();
		                }
		            },
		            decimalPrecision: 8
		        })
		    }, {
		        header: '金额',
		        dataIndex: 'MessageAmt',
		        id: 'MessageAmt',
		        editor: new Ext.form.NumberField({ decimalPrecision: 2 })
		    },
		    {
		        header: '送货港口',
		        dataIndex: 'SenderAdd',
		        id: 'SenderAdd',
		        editor: new Ext.form.TextField({})
		    },
		    {
		        header: '发送方式',
		        dataIndex: 'SendType',
		        id: 'SendType',
		        renderer: cmbSendType,
		        editor: new Ext.form.ComboBox({
		            name: 'SendType',
		            id: 'SendType',
		            store: SendTypeStore,
		            displayField: 'DicsName',
		            valueField: 'DicsCode',
		            typeAhead: true,
		            editable: false,
		            mode: 'local',
		            emptyText: '请选择发送方式信息',
		            triggerAction: 'all'
		        })
		    },
		    {
		        header: '备注',
		        dataIndex: 'Memo',
		        id: 'Memo',
		        editor: new Ext.form.TextField({})
            }]),
            viewConfig: {
                columnsText: '显示的列',
                scrollOffset: 20,
                sortAscText: '升序',
                sortDescText: '降序',
                forceFit: true,
                getRowClass : function(record,rowIndex,rowParams,store){  
                    //禁用数据显示红色  
                    if(record.data.MessagePrice==0){  
                        return 'x-grid-record-red';  
                    }else{  
                        return '';  
                    }  
                      
                }
            },
            height: 280,
            closeAction: 'hide',
            stripeRows: true,
            loadMask: true,
            autoExpandColumn: 2,
            tbar: [{
                id: 'btnSave',
                text: '获取供应商商品',
                iconCls: 'add',
                handler: function() {
                    var customerId = Ext.getCmp("CustomerId").getValue()
                    if (productGridData.baseParams.Supplier != customerId) {
                        productGridData.removeAll();
                        productGridData.baseParams.Supplier = customerId;
                        productGridData.reload();
                    }
                    selectProductWindow.show();
                }
}],
                listeners: {
                    afteredit: function(e) {
                        //                    if (e.row < e.grid.getStore().getCount()) {
                        //                        e.grid.stopEditing();
                        //                        if (e.column < e.record.fields.getCount() - 1) {//最后一行操作不算
                        //                            //alert('e.column+1');
                        //                            e.grid.startEditing(e.row, e.column + 1);
                        //                        }
                        //                        else {
                        //                            //alert('e.row+1')
                        //                            e.grid.startEditing(e.row + 1, 1);
                        //                        }
                        //                    }
                        //自动计算
                        var record = e.record; //获取被修改的行数据
                        var field = e.field; //获取被修改的列名
                        var row = e.row; //获取行号
                        var column = e.column; //获取列号
                        if (field = 'MessageQtv' || field == 'MessagePrice') {
                            record.set('MessageAmt', accMul(record.data.MessageQtv, record.data.MessagePrice));
                        }
                    }
                }
            });

            msgDtlGrid.on("beforeedit", beforeEdit, msgDtlGrid);
            msgDtlGrid.on('render', function(grid) {    
                var store = grid.getStore();  // Capture the Store.                
                var view = grid.getView();    // Capture the GridView.
                msgDtlGrid.tip = new Ext.ToolTip({    
                    target: view.mainBody,    // The overall target element. 
                    delegate: '.x-grid3-row', // Each grid row causes its own seperate show and hide. 
                    trackMouse: true,         // Moving within the row should not hide the tip.   
                    renderTo: document.body,  // Render immediately so that tip.body can be referenced prior to the first show.    
                    listeners: {              // Change content dynamically depending on which element triggered the show.    
                        beforeshow: function updateTipBody(tip) {    
                           var rowIndex = view.findRowIndex(tip.triggerElement);
                           var price = msgDtlGrid.getStore().getAt(rowIndex).data.MessagePrice
                            if(price==0){                                                              
                                tip.body.dom.innerHTML = "提示信息：采购价格不应为零！";
                            }else{
                                return false; //停止执行，从而禁止显示Tip
                                tip.destroy();
                            }                        
                        }    
                    }    
                });    
            });   
            /*------DataGrid的函数结束 End---------------*/

            /*------开始界面数据的窗体 Start---------------*/
            if (typeof (uploadMessageWindow) == "undefined") {//解决创建2个windows问题
                uploadMessageWindow = new Ext.Window({
                    id: 'Messageformwindow',
                    title: formTitle
		, iconCls: 'upload-win'
		, width: 750
		, height: 400
		, layout: 'border'
		, plain: true
		, modal: true
		, x: 50
		, y: 50
		, constrain: true
		, resizable: false
		, closeAction: 'hide'
		, autoDestroy: true
		, autoScroll: true
		, items: [messageDiv, msgDtlGrid]
		, buttons: [{
		    text: "保存"
			, handler: function() {
			    getFormValue();
			}
			, scope: this
		},
		{
		    text: "取消"
			, handler: function() {
			    uploadMessageWindow.hide();
			}
			, scope: this
}]
                });
            }
            uploadMessageWindow.addListener("hide", function() {
            });

            /*---------保存数据函数---------------*/
            //保存数据信息
            function saveMessageDetailData() {
                if (saveType == "add") {
                    getFormValue();
                    return;
                }
                var json = "";
                var gridStore = msgDtlGrid.getStore();
                gridStore.each(function(gridStore) {
                    json += Ext.util.JSON.encode(gridStore.data) + ',';
                });
                json = json.substring(0, json.length - 1);
                Ext.Msg.wait("数据正在保存……");
                Ext.Ajax.request({
                    url: 'frmScmProvideMessage.aspx?method=savemessagedetail',
                    method: 'POST',
                    params: {
                        Json: json
                    },
                    success: function(resp, opts) {
                        Ext.Msg.hide();
                        if (checkExtMessage(resp)) {
                            uploadMessageWindow.hide();
                        }
                    },
                    failure: function(resp, opts) {
                        Ext.Msg.hide();
                        Ext.Msg.alert("提示", "保存失败");
                    }
                });
            }
            /*------开始获取界面数据的函数 start---------------*/
            function getFormValue() {
                var json = "";
                var gridStore = msgDtlGrid.getStore();
                gridStore.each(function(gridStore) {
                    json += Ext.util.JSON.encode(gridStore.data) + ',';
                });
                json = json.substring(0, json.length - 1);
                var startDate = Ext.getCmp('StartDate').getValue();
                if (startDate != "")
                    startDate = Ext.util.Format.date(startDate,'Y/m/d');
                var endDate = Ext.getCmp('EndDate').getValue();
                if (endDate != "")
                    endDate = Ext.util.Format.date(endDate,'Y/m/d');
                //                var createDate = Ext.getCmp("CreateDate").getValue();
                //                if (createDate != "")
                //                    createDate = createDate.toLocaleDateString();
                var sendDate = Ext.getCmp('SendDate').getValue();
                if (sendDate != "")
                    sendDate = Ext.util.Format.date(sendDate,'Y/m/d');
                var shipNo = Ext.getCmp('ShipNo').getValue();
                var sm = Ext.getCmp('messageGrid').getSelectionModel();
                //获取选择的数据信息
                var selectData = sm.getSelected();
                var id = 0;
                if (selectData != null)
                    id = selectData.data.ProvideMessageId;
                Ext.MessageBox.wait("正在保存，请稍候……", "系统提示");
                Ext.Ajax.request({
                    url: 'frmScmProvideMessage.aspx?method=' + saveType,
                    method: 'POST',
                    params: {
                        ProvideMessageId: id,
                        CustomerId: Ext.getCmp('CustomerId').getValue(),
                        SendDate: sendDate,
                        //OperatId:Ext.getCmp('OperatId').getValue(),
                        //CreateDate: createDate,
                        Status: Ext.getCmp('Status').getValue(),
                        PlanType: 'S203',
                        StartDate: startDate,
                        EndDate: endDate,
                        ShipNo:shipNo,
                        Json: json
                    },
                    success: function(resp, opts) {
                        Ext.MessageBox.hide();
                        if (checkExtMessage(resp)) {
                            uploadMessageWindow.hide();
                            //messageGridData.reload();
                        }
                    },
                    failure: function(resp, opts) {
                        Ext.MessageBox.hide();
                        Ext.Msg.alert("提示", "保存失败");
                    }
                });
            }
            /*------结束获取界面数据的函数 End---------------*/

            /*------开始界面数据的函数 Start---------------*/
            function setFormValue(selectData) {

                Ext.Ajax.request({
                    url: 'frmScmProvideMessage.aspx?method=getmessage',
                    params: {
                        ProvideMessageId: selectData.data.ProvideMessageId
                    },
                    success: function(resp, opts) {
                        var data = Ext.util.JSON.decode(resp.responseText);
                        Ext.getCmp("CustomerId").setValue(data.CustomerId);
                        Ext.getCmp("SendDate").setValue(data.SendDate);
                        //Ext.getCmp("OperatId").setValue(data.OperatId);
                        //                        if (data.CreateDate != '') {
                        //                            Ext.getCmp("CreateDate").setValue((new Date(Date.parse(data.CreateDate))).clearTime());
                        //                        }
                        Ext.getCmp("Status").setValue(data.Status);
                        Ext.getCmp("PlanType").setValue(data.PlanType);

                        if (data.StartDate != '') {
                            Ext.getCmp("StartDate").setValue((new Date(Date.parse(data.StartDate))).clearTime());
                        }
                        else {
                            Ext.getCmp("StartDate").setValue("");
                        }
                        if (data.EndDate != '') {
                            Ext.getCmp("EndDate").setValue((new Date(Date.parse(data.EndDate))).clearTime());
                        }
                        else {
                            Ext.getCmp("EndDate").setValue("");
                        }
                        Ext.getCmp("ShipNo").setValue(selectData.data.ShipNo);
                        Ext.getCmp("CustomerName").setValue(selectData.data.CustomerName);
                        //Ext.getCmp("OperatId").setValue(selectData.data.EmpName);
                        msgDtlGridData.baseParams.ProvideMessageId = selectData.data.ProvideMessageId;
                        msgDtlGridData.baseParams.limit = 100;
                        msgDtlGridData.baseParams.start = 0;
                        msgDtlGridData.reload();

                    },
                    failure: function(resp, opts) {
                        Ext.Msg.alert("提示", "获取用户信息失败");
                    }
                });
            }
            /*------结束设置界面数据的函数 End---------------*/

            /*------开始获取数据的函数 start---------------*/
            var messageGridData = new Ext.data.Store
({
    url: 'frmScmProvideMessage.aspx?method=getmessagelist&Action=' + action,
    reader: new Ext.data.JsonReader({
        totalProperty: 'totalProperty',
        root: 'root'
    }, [
	{
	    name: 'ProvideMessageId'
	},
	{
	    name: 'CustomerId'
	}, {
	    name: 'CustomerName'
	},
	{
	    name: 'SendDate', type: 'date'
	},
	{
	    name: 'MessageNum'
	},
	{
	    name: 'OperatId'
	}, {
	    name: 'EmpName'
	},
	{
	    name: 'CreateDate'
	},
	{
	    name: 'MessageChecker'
	},
	{
	    name: 'CheckDate', type: 'date'
	},
	{
	    name: 'MessageSight'
	},
	{
	    name: 'Status'
	},
	{
	    name: 'PlanType'
	},
	{
	    name: 'ShipNo'
	},
	{
	    name: 'StartDate', type: 'date'
	},
	{
	    name: 'EndDate', type: 'date'
}])
	,
    listeners:
	{
	    scope: this,
	    load: function() {
	    }
	}
});

            messageGridData.load({ params: {
                start: 0,
                limit: 10
            }
            });
            /*------获取数据的函数 结束 End---------------*/

            /*------开始DataGrid的函数 start---------------*/

            var sm = new Ext.grid.CheckboxSelectionModel({
                singleSelect: true
            });

            function cmbStatus(val) {
                var index = cmbStatusList.find('DicsCode', val);
                if (index < 0)
                    return "";
                var record = cmbStatusList.getAt(index);
                return record.data.DicsName;
            }

            function cmbType(val) {
                var index = cmbPlanTypeList.find('DicsCode', val);
                if (index < 0)
                    return "";
                var record = cmbPlanTypeList.getAt(index);
                return record.data.DicsName;
            }

            function renderDate(value) {
                var reDate = /\d{4}\-\d{2}\-\d{2}/gi;
                return value.match(reDate);
            }

            var messageGrid = new Ext.grid.GridPanel({
                el: 'messageGrid',
                width: '100%',
                height: '100%',
                //autoWidth: true,
                autoHeight: true,
                autoScroll: true,
                layout: 'fit',
                id: 'messageGrid',
                store: messageGridData,
                loadMask: { msg: '正在加载数据，请稍侯……' },
                sm: sm,
                cm: new Ext.grid.ColumnModel([
		sm,
		new Ext.grid.RowNumberer(), //自动行号
		{
            header: '供应商',
            dataIndex: 'CustomerName',
            id: 'CustomerName'
        },
		{
		    header: '车船号',
		    dataIndex: 'ShipNo',
		    id: 'ShipNo'
		},
		{
		    header: '确认日期',
		    dataIndex: 'SendDate',
		    id: 'SendDate',
		    renderer: Ext.util.Format.dateRenderer('Y年m月d日')
		},
		{
		    header: '操作人',
		    dataIndex: 'EmpName',
		    id: 'EmpName'
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
		    renderer: cmbStatus
		},
                //		{
                //		    header: '对应计划类型',
                //		    dataIndex: 'PlanType',
                //		    id: 'PlanType',
                //		    renderer: cmbType
                //		},
		{
		header: '开始日期',
		dataIndex: 'StartDate',
		id: 'StartDate',
		renderer: Ext.util.Format.dateRenderer('Y年m月d日')
},
		{
		    header: '结束日期',
		    dataIndex: 'EndDate',
		    id: 'EndDate',
		    renderer: Ext.util.Format.dateRenderer('Y年m月d日')
}]),
                bbar: new Ext.PagingToolbar({
                    pageSize: 10,
                    store: messageGridData,
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
            
            messageGrid.on('render', function(grid) {
                var store = grid.getStore();  // Capture the Store.  
                var view = grid.getView();    // Capture the GridView.
                messageGrid.tip = new Ext.ToolTip({
                    target: view.mainBody,    // The overall target element.  
                    delegate: '.x-grid3-row', // Each grid row causes its own seperate show and hide.  
                    trackMouse: true,         // Moving within the row should not hide the tip.  
                    renderTo: document.body,  // Render immediately so that tip.body can be referenced prior to the first show.  
                    listeners: {              // Change content dynamically depending on which element triggered the show.  
                        beforeshow: function updateTipBody(tip) {
                            var rowIndex = view.findRowIndex(tip.triggerElement);
                            
                            var element = document.elementFromPoint(tip.x-20, tip.y-20);
                             var v = view.findCellIndex(element);
                             if(v==2)
                             {
                              
                                if(showTipRowIndex == rowIndex)
                                    return;
                                else
                                    showTipRowIndex = rowIndex;
                                    
                                     tip.body.dom.innerHTML="正在加载数据……";
                                        //页面提交
                                        Ext.Ajax.request({
                                            url: 'frmScmProvideMessage.aspx?method=getdtlinfo',
                                            method: 'POST',
                                            params: {
                                                ProvideMessageId: grid.getStore().getAt(rowIndex).data.ProvideMessageId
                                            },
                                            success: function(resp, opts) {
                                                tip.body.dom.innerHTML = resp.responseText;
                                            },
                                            failure: function(resp, opts) {
                                                messageGrid.tip.hide();
                                            }
                                        });
                                }
                                else
                                {
                                    messageGrid.tip.hide();
                                }
//                            }
//                            else
//                            {
//                                planeGrid.tip.hide();
//                            }
//                            if(header)
//                            {
//                                tip.body.dom.innerHTML = "可以双击此行查看出库明细！ "; //store.getAt(rowIndex).id  
//                            }
//                            else
//                            {
//                                planeGrid.tip.hide();
//                            }
                        }
                    }
                });
    });
    var showTipRowIndex =-1;
    
            messageGrid.render();
            /*------DataGrid的函数结束 End---------------*/
            /*------查询信息 ---------*/
            createSearch(messageGrid, messageGridData, "searchForm");
            //setControlVisibleByField();
            searchForm.el = "searchForm";
            searchForm.render();

            /*------开始获取数据的函数 start---------------*/
            var productGridData = new Ext.data.Store
({
    url: 'frmScmProvideMessage.aspx?method=getProductInfoList',
    reader: new Ext.data.JsonReader({
        totalProperty: 'totalProperty',
        root: 'root'
    }, [
	{
	    name: 'ProductId'
	},
	{
	    name: 'ProductNo'
	},
	{
	    name: 'MnemonicNo'
	},
	{
	    name: 'AliasNo'
	},
	{
	    name: 'MobileNo'
	},
	{
	    name: 'SpeechNo'
	},
	{
	    name: 'NetPurchasesNo'
	},
	{
	    name: 'LogisticsNo'
	},
	{
	    name: 'BarCode'
	},
	{
	    name: 'SecurityCode'
	},
	{
	    name: 'ProductName'
	},
	{
	    name: 'AliasName'
	},
	{
	    name: 'Specifications'
	},
	{
	    name: 'SpecificationsText'
	},
	{
	    name: 'Unit'
	},
	{
	    name: 'UnitText'
	},
	{
	    name: 'SalePrice'
	},
	{
	    name: 'SalePriceLower'
	},
	{
	    name: 'SalePriceLimit'
	},
	{
	    name: 'TaxWhPrice'
	},
	{
	    name: 'TaxRate'
	},
	{
	    name: 'Tax'
	},
	{
	    name: 'SalesTax'
	},
	{
	    name: 'UnitConvertRate'
	},
	{
	    name: 'AutoFreight'
	},
	{
	    name: 'DriverFreight'
	},
	{
	    name: 'TrainFreight'
	},
	{
	    name: 'ShipFreight'
	},
	{
	    name: 'OtherFeight'
	},
	{
	    name: 'Supplier'
	},
	{
	    name: 'SupplierText'
	},
	{
	    name: 'Origin'
	},
	{
	    name: 'OriginText'
	},
	{
	    name: 'AliasPrice'
	},
	{
	    name: 'IsPlan'
	},
	{
	    name: 'ProductType'
	},
	{
	    name: 'ProductVer'
	},
	{
	    name: 'Remark'
	},
	{
	    name: 'CreateDate'
	},
	{
	    name: 'UpdateDate'
	},
	{
	    name: 'OperId'
	},
	{
	    name: 'OrgId'
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

            /*------WindowForm 配置开始------------------*/


            /*------WindowForm 配置开始------------------*/

            /*------开始DataGrid的函数 start---------------*/

            var txtProductName = new Ext.form.TextField({});
            var lblProductName = new Ext.form.Label({ text: "商品名称" });
            var txtProductNo = new Ext.form.TextField({});
            var lblProductNo = new Ext.form.Label({ text: "商品编号" });
            var sm = new Ext.grid.CheckboxSelectionModel({
                singleSelect: false
            });
            var productGrid = new Ext.grid.GridPanel({
                width: '100%',
                height: '100%',
                //autoWidth:true,
                //autoHeight:true,
                autoScroll: true,
                layout: 'fit',
                store: productGridData,
                loadMask: { msg: '正在加载数据，请稍侯……' },
                sm: sm,
                cm: new Ext.grid.ColumnModel([
		sm,
		new Ext.grid.RowNumberer(), //自动行号
		{
		header: '存货ID',
		dataIndex: 'ProductId',
		id: 'ProductId',
		hidden: true,
		hideable: false
},
		{
		    header: '存货编号',
		    dataIndex: 'ProductNo',
		    id: 'ProductNo',
		    width: 100
		},
		{
		    header: '助记码',
		    dataIndex: 'MnemonicNo',
		    id: 'MnemonicNo',
		    width: 100
		},
		{
		    header: '存货名称',
		    dataIndex: 'ProductName',
		    id: 'ProductName',
		    width: 170
		},
		{
		    header: '规格',
		    dataIndex: 'SpecificationsText',
		    id: 'SpecificationsText',
		    width: 40
		},
		{
		    header: '计量单位',
		    dataIndex: 'UnitText',
		    id: 'UnitText',
		    width: 60
		},
		{
		    header: '销售单价',
		    dataIndex: 'SalePrice',
		    id: 'SalePrice',
		    width: 60
		},
		{
		    header: '供应商',
		    dataIndex: 'SupplierText',
		    id: 'SupplierText',
		    width: 150
		},
		{
		    header: '产地',
		    dataIndex: 'OriginText',
		    id: 'OriginText',
		    width: 100
}]),
                bbar: new Ext.PagingToolbar({
                    pageSize: 10,
                    store: productGridData,
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
                tbar: [
                lblProductNo, txtProductNo, lblProductName, txtProductName,
		    {
		        id: 'btnSearch',
		        text: '查找',
		        iconCls: 'add',
		        handler: function() {
		            if (productGridData.baseParams.ProductName != txtProductName.getValue()) {
		                productGridData.baseParams.ProductName = txtProductName.getValue();
		            }

		            if (productGridData.baseParams.ProductNo != txtProductNo.getValue()) {
		                productGridData.baseParams.ProductNo = txtProductNo.getValue();
		            }
		            if (productGridData.getCount() == 0) {
		                productGridData.baseParams.limit = 10;
		                productGridData.baseParams.start = 0;
		                productGridData.load();
		            }
		            else {
		                productGridData.reload();
		            }
		        }
}],
                height: 340,
                closeAction: 'hide',
                stripeRows: true,
                loadMask: true//,
                //autoExpandColumn: 2
            });


            /*------DataGrid的函数结束 End---------------*/
            if (typeof (selectProductWindow) == "undefined") {//解决创建2个windows问题
                selectProductWindow = new Ext.Window({
                    id: 'selectProductWindow',
                    title: "选择供应商商品"
                , iconCls: 'upload-win'
                , width: 750
                , height: 500
                , layout: 'fit'
                , plain: true
                , modal: true
                    // , x: 50
                    // , y: 50
                , constrain: true
                , resizable: false
                , closeAction: 'hide'
                , autoDestroy: true
                , items: productGrid
                , buttons: [{
                    id: 'savebuttonid'
                    , text: "选择"
                    , handler: function() {
                        var sm = productGrid.getSelectionModel();
                        //获取选择的数据信息
                        var selectData = sm.getSelections();
                        var ids = "";
                        for (var i = 0; i < selectData.length; i++) {
                            insertNewBlankRow(selectData[i]);
                        }
                        selectProductWindow.hide();
                    }
                    , scope: this
                },
                {
                    text: "取消"
                    , handler: function() {
                        selectProductWindow.hide();
                    }
                    , scope: this
}]
                });
            }

        })    
    document.oncontextmenu=new Function("event.returnValue=false;");
    document.onselectstart=new Function("event.returnValue=false;");
</script>
</head>
<body>
    <form id="form1" runat="server">
    <div id='toolbar'></div>
    <div id='searchForm'></div>
<div id='divForm'></div>
<div id='messageGrid'></div>
    </form>
</body>
</html>
