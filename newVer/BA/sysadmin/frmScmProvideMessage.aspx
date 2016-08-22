<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmScmProvideMessage.aspx.cs" Inherits="SCM_frmScmProvideMessage" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>自主采购订单维护</title>
    <link rel="stylesheet" type="text/css" href="../../ext3/resources/css/ext-all.css" />
<script type="text/javascript" src="../../ext3/adapter/ext/ext-base.js"></script>
<script type="text/javascript" src="../../ext3/ext-all.js"></script>
<script type="text/javascript" src="../../ext3/src/locale/ext-lang-zh_CN.js"></script>
<script type="text/javascript" src="../../js/operateResp.js"></script>
<script type="text/javascript" src="../../js/FilterControl.js"></script>
<script type="text/javascript" src="../../js/ExtJsHelper.js"></script>
<script type="text/javascript" src="../../js/floatUtil.js"></script>
<script type="text/javascript" src="../../js/getExcelXml.js"></script>
<script type="text/javascript" src="../../js/ExtJsHelper.js"></script>
<%=getComboBoxSource()%>
<script>
    var imageUrl = "../../Theme/1/";
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
        Ext.BLANK_IMAGE_URL = "../../ext3/resources/images/default/s.gif"
        Ext.form.TextField.prototype.afterRender = Ext.form.TextField.prototype.afterRender.createSequence(function() {
            this.relayEvents(this.el, ['onblur']);
        });
        var saveType = "";
        /*------实现toolbar的函数 start---------------*/
        var Toolbar = new Ext.Toolbar({
            renderTo: "toolbar"
        });
        var action="my";
        iniToolBar(Toolbar);
        //添加ToolBar事件
        function addToolBarEvent() {
            for (var i = 0; i < Toolbar.items.length; i++) {
                switch (Toolbar.items.items[i].text) {
                    case "清除":
                        Toolbar.items.items[i].on("click", eraserMessage);
                        break;

                }
            }
        }
        addToolBarEvent();
        /*------结束toolbar的函数 end---------------*/

        /*------开始ToolBar事件函数 start---------------*/
        

        function eraserMessage() {
            var sm = Ext.getCmp('messageGrid').getSelectionModel();
            //获取选择的数据信息
            var selectData = sm.getSelected();
            if (selectData == null) {
                Ext.Msg.alert("提示", "请选中需要取消的信息！");
                return;
            }
            //删除前再次提醒是否真的要删除
            Ext.Msg.confirm("提示信息", "是否真的要清除选择的信息？", function callBack(id) {
                //判断是否删除数据
                if (id == "yes") {
                    //页面提交
                    Ext.Ajax.request({
                        url: 'frmScmProvideMessage.aspx?method=eraserMessage',
                        method: 'POST',
                        params: {
                            MessageId: selectData.data.ProvideMessageId
                        },
                        success: function(resp, opts) {
                            if (checkExtMessage(resp)) {
                                messageGridData.reload();
                                msgDtlGridData.removeAll();
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
                MessagePrice: 0,
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

        var sm = new Ext.grid.CheckboxSelectionModel({
            singleSelect: true
        });
        var msgDtlGrid = new Ext.grid.EditorGridPanel({
            el:'messageDtlGrid',
            title:'采购明细信息',
            width: '100%',
            height: 200,
            autoWidth: true,
            //autoHeight: true,
            autoScroll: true,
            layout: 'fit',
            editable: false,
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
		width:200
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
		    width:150,
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
                forceFit: false
            },
            height: 280,
            closeAction: 'hide',
            stripeRows: true,
            loadMask: true,
                listeners: {
                    afteredit: function(e) {
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
            msgDtlGrid.render();
            /*------DataGrid的函数结束 End---------------*/
           
            /*------开始界面数据的函数 Start---------------*/
            function setFormValue(selectData) {
                        //Ext.getCmp("OperatId").setValue(selectData.data.EmpName);
                        msgDtlGridData.baseParams.ProvideMessageId = selectData.data.ProvideMessageId;
                        msgDtlGridData.baseParams.limit = 100;
                        msgDtlGridData.baseParams.start = 0;
                        msgDtlGridData.reload();
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
                title:'采购信息',
                width: '100%',
                height: '100%',
               // autoWidth: true,
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
                    forceFit: false
                },
                height: 280,
                closeAction: 'hide',
                stripeRows: true,
                loadMask: true
            });
            messageGrid.render();
            messageGrid.on('rowdblclick', function(grid, rowIndex, e) {
                //弹出商品明细
                var _record = grid.getStore().getAt(rowIndex);
                if (!_record) {
                    Ext.example.msg('操作', '请选择要查看的记录！');
                } else {
                   setFormValue(_record);
                }

            });
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
                    forceFit: false
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
</script>
</head>
<body>
    <form id="form1" runat="server">
    <div id='toolbar'></div>
    <div id='searchForm'></div>
<div id='divForm'></div>
<div id='messageGrid'></div>
<div id='messageDtlGrid'></div>
    </form>
</body>
</html>
