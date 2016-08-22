<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmBaSaleProduct.aspx.cs" Inherits="BA_product_frmBaSaleProduct" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <link rel="stylesheet" type="text/css" href="../../ext3/resources/css/ext-all.css" />
    <script type="text/javascript" src="../../ext3/adapter/ext/ext-base.js"></script>
    <script type="text/javascript" src="../../ext3/ext-all.js"></script>  
    <script type="text/javascript" src="../../js/operateResp.js"></script>    
    <script type="text/javascript" src="../../js/ExtJsHelper.js"></script>
    <script type="text/javascript" src="../../js/FilterControl.js"></script>
    <script type="text/javascript" src="../../js/ProductSelect.js"></script>
    <link rel="Stylesheet" type="text/css" href="../../css/gridPrint.css" />
	<script src="../../js/getExcelXml.js"></script>
</head>
<%=getComboBoxStore()%>
<script type="text/javascript">
    Ext.BLANK_IMAGE_URL = "../../ext3/resources/images/default/s.gif";
    Ext.onReady(function() {
        /*------实现toolbar的函数 start---------------*/
        var Toolbar = new Ext.Toolbar({
            renderTo: "toolbar",
            items: [{
                text: "新增",
                icon: "../../Theme/1/images/extjs/customer/add16.gif",
                handler: function() {
                    openAddIndividualWin();
                }
            }, '-', {
                text: "编辑",
                icon: "../../Theme/1/images/extjs/customer/edit16.gif",
                handler: function() {
                    modifyIndividualWin();
                }
            }, '-', {
                text: "删除",
                icon: "../../Theme/1/images/extjs/customer/delete16.gif",
                handler: function() {
                    deleteIndividual();
                }
}, '-', {
                text: "停止销售",
                icon: "../../Theme/1/images/extjs/customer/delete16.gif",
                handler: function() {
                    stopSale();
                }
}, '-', {
                text: "继续销售",
                icon: "../../Theme/1/images/extjs/customer/delete16.gif",
                handler: function() {
                    reStartSale();
                }
}]
            });

            /*------结束toolbar的函数 end---------------*/
            //定义产品下拉框异步调用方法
            var dsProducts;
            if (dsProducts == null) {
                dsProducts = new Ext.data.Store({
                    url: 'frmBaSaleProduct.aspx?method=getProducts',
                    reader: new Ext.data.JsonReader({
                        root: 'root',
                        totalProperty: 'totalProperty'
                    }, [
                            { name: 'ProductId', mapping: 'ProductId' },
                            { name: 'ProductNo', mapping: 'ProductNo' },
                            { name: 'ProductName', mapping: 'ProductName' },
                            { name: 'Unit', mapping: 'Unit' },
                            { name: 'Supplier', mapping: 'Supplier' },
                            { name: 'SalePriceLower', mapping: 'SalePriceLower' },
                            { name: 'SalePriceLimit', mapping: 'SalePriceLimit' },
                            { name: 'UnitText', mapping: 'UnitText' },
                            { name: 'Specifications', mapping: 'Specifications' },
                            { name: 'SpecificationsText', mapping: 'SpecificationsText' }
                        ])
                });
            }

            var dsTaxType;
            if (dsTaxType == null) { //防止重复加载
                dsTaxType = new Ext.data.Store
                ({
                    url: 'frmBaSaleProduct.aspx?method=getTaxCodes',
                    reader: new Ext.data.JsonReader({
                        totalProperty: 'totalProperty',
                        root: 'root'
                    }, [{ name: 'TaxCode' }, { name: 'TaxProduct' }, { name: 'TaxRate'}])
                });
            }
            dsTaxType.load({ params: { start: 0, limit: 1234} });
            

            var productFilterCombo = null;
            function createProductFilterCombo() {
                productFilterCombo = new Ext.form.ComboBox({
                    store: dsProducts,
                    displayField: 'ProductName',
                    displayValue: 'ProductId',
                    typeAhead: false,
                    minChars: 1,
                    id: 'productFilterCombo',
                    loadingText: 'Searching...',
                    tpl: resultPTpl,
                    itemSelector: 'div.search-item',  
                    pageSize: 10,
                    hideTrigger: true,
                    applyTo: 'ProductName',
                    onSelect: function(record) { // override default onSelect to do redirect  
                        setProducrAttributes(record);
                        this.collapse();
                    }
                });
            }

            function setProducrAttributes(record) {

                Ext.getCmp('ProductName').setValue(record.data.ProductName);
                Ext.getCmp('ProductId').setValue(record.data.ProductId);
                Ext.getCmp('ProductNo').setValue(record.data.ProductNo);
                Ext.getCmp('MnemonicNo').setValue(record.data.MnemonicNo);
                Ext.getCmp('Specifications').setValue(record.data.specificationsText);
                //Ext.getCmp('UnitName').setValue(record.data.UnitText);
                Ext.getCmp("UnitId").setValue(record.data.Unit);
                Ext.getCmp('Ext2').setValue('');
                Ext.getCmp('Ext3').setValue('');
                Ext.getCmp('Ext6').setValue('');
                Ext.getCmp('Ext7').setValue('');
                beforeEdit();

            }

            /*------开始ToolBar事件函数 start---------------*//*-----新增Individual实体类窗体函数----*/
            function openAddIndividualWin() {

                uploadIndividualWindow.show();
                if (productFilterCombo == null) {
                    createProductFilterCombo();
                }
                //Ext.getCmp('OrgId').setValue("");
                Ext.getCmp('ProductId').setValue("");
                Ext.getCmp('SmsCode').setValue("");
                Ext.getCmp('TaxSubject').setValue("");
                Ext.getCmp('ProductNo').setValue("");
                Ext.getCmp('MnemonicNo').setValue("");
                //                Ext.getCmp('AliasNo').setValue("");
                Ext.getCmp('ProductName').setValue("");

                Ext.getCmp('Specifications').setValue("");
                Ext.getCmp('UnitId').setValue("");
                Ext.getCmp('Ext2').setValue("");
                Ext.getCmp('Ext3').setValue("");
                Ext.getCmp('Ext6').setValue("");
                Ext.getCmp('Ext7').setValue("");
                Ext.getCmp('ProductName').setDisabled(false);
            }
            /*-----编辑Individual实体类窗体函数----*/
            function modifyIndividualWin() {
                var sm = Ext.getCmp('saleProductGrid').getSelectionModel();
                //获取选择的数据信息
                var selectData = sm.getSelected();
                if (selectData == null) {
                    Ext.Msg.alert("提示", "请选中需要编辑的信息！");
                    return;
                }
                Ext.getCmp('ProductName').setDisabled(true);
                uploadIndividualWindow.show();
                setFormValue(selectData);
            }
            
            /*-----停止销售商品函数----*/
            function reStartSale()
            {
                var sm = Ext.getCmp('saleProductGrid').getSelectionModel();
                //获取选择的数据信息
                var selectData = sm.getSelected();
                //如果没有选择，就提示需要选择数据信息
                if (selectData == null) {
                    Ext.Msg.alert("提示", "请选中需要停止销售的商品信息！");
                    return;
                }
                //删除前再次提醒是否真的要删除
                Ext.Msg.confirm("提示信息", "是否真的要重新开始销售选择的可售商品信息吗？", function callBack(id) {
                    //判断是否删除数据
                    if (id == "yes") {
                        //页面提交
                        Ext.Ajax.request({
                            url: 'frmBaSaleProduct.aspx?method=restart',
                            method: 'POST',
                            params: {
                                ProductId: selectData.data.ProductId
                            },
                            success: function(resp, opts) {
                                if (checkExtMessage(resp)) {
                                    saleProductGridData.reload({params:{start:0,limit:10}});
                                }
                            },
                            failure: function(resp, opts) {
                                Ext.Msg.alert("提示", "重新开始销售操作除失败");
                            }
                        });
                    }
                });
             }
            /*停止销售商品*/
            function stopSale() {
                var sm = Ext.getCmp('saleProductGrid').getSelectionModel();
                //获取选择的数据信息
                var selectData = sm.getSelected();
                //如果没有选择，就提示需要选择数据信息
                if (selectData == null) {
                    Ext.Msg.alert("提示", "请选中需要停止销售的商品信息！");
                    return;
                }
                //删除前再次提醒是否真的要删除
                Ext.Msg.confirm("提示信息", "是否真的要停止销售选择的可售商品信息吗？", function callBack(id) {
                    //判断是否删除数据
                    if (id == "yes") {
                        //页面提交
                        Ext.Ajax.request({
                            url: 'frmBaSaleProduct.aspx?method=stop',
                            method: 'POST',
                            params: {
                                ProductId: selectData.data.ProductId
                            },
                            success: function(resp, opts) {
                                if (checkExtMessage(resp)) {
                                    saleProductGridData.reload({params:{start:0,limit:10}});
                                }
                            },
                            failure: function(resp, opts) {
                                Ext.Msg.alert("提示", "停止销售操作除失败");
                            }
                        });
                    }
                });
            }
            /*-----删除Individual实体函数----*/
            /*删除信息*/
            function deleteIndividual() {
                var sm = Ext.getCmp('saleProductGrid').getSelectionModel();
                //获取选择的数据信息
                var selectData = sm.getSelected();
                //如果没有选择，就提示需要选择数据信息
                if (selectData == null) {
                    Ext.Msg.alert("提示", "请选中需要删除的信息！");
                    return;
                }
                //删除前再次提醒是否真的要删除
                Ext.Msg.confirm("提示信息", "是否真的要删除选择的可售商品信息吗？", function callBack(id) {
                    //判断是否删除数据
                    if (id == "yes") {
                        //页面提交
                        Ext.Ajax.request({
                            url: 'frmBaSaleProduct.aspx?method=del',
                            method: 'POST',
                            params: {
                                ProductId: selectData.data.ProductId
                            },
                            success: function(resp, opts) {
                                if (checkExtMessage(resp)) {
                                    saleProductGridData.reload({params:{start:0,limit:defaultPageSize}});
                                }
                            },
                            failure: function(resp, opts) {
                                Ext.Msg.alert("提示", "数据删除失败");
                            }
                        });
                    }
                });
            }

            //定义下拉框异步调用方法,当前客户可订商品列表
            var dsProductUnits = new Ext.data.Store({
                url: '../../scm/frmOrderDtl.aspx?method=getProductUnits',
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
            ]),
                listeners: {
                    load: function() {
                        var combo = Ext.getCmp('UnitId');
                        combo.setValue(combo.getValue());
                    }
                }
            });
            dsProductUnits.load();
            
            //定义下拉框异步调用方法,当前客户可订商品列表
            var dsProductReportUnits = new Ext.data.Store({
                url: 'frmBaSaleProduct.aspx?method=getreprotunits',
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
            ]),
                listeners: {
                    load: function() {
                        var combo = Ext.getCmp('Ext7');
                        combo.setValue(combo.getValue());
                    }
                }
            });
            dsProductReportUnits.load();

            function beforeEdit() {
                var productId = Ext.getCmp('ProductId').getValue();
                if (productId != dsProductUnits.baseParams.ProductId) {
                    dsProductUnits.baseParams.ProductId = productId;
                    dsProductUnits.load();
                    dsProductReportUnits.baseParams.ProductId = productId;
                    dsProductReportUnits.load();
                }
            }
            /*------实现FormPanle的函数 start---------------*/
            //定义下拉框异步返回显示模板
            var resultPTpl = new Ext.XTemplate(
            '<tpl for="."><div id="searchdivid" class="search-item">',
                '<h3><span>商品编号:{ProductNo}&nbsp;  商品名称:{ProductName}&nbsp;  规格:{SpecificationsText}&nbsp;单位:{UnitText}&nbsp;}</span></h3>',
            '</div></tpl>'
             );
        var resultTpl = new Ext.XTemplate(  
            '<tpl for="."><div id="searchdivid" class="search-item">',  
                '<h3><span>商品类别:{TaxProduct}&nbsp;  税目:{TaxCode}&nbsp;  税率:{TaxRate}&nbsp;}</span></h3>',
            '</div></tpl>'  
        ); 
            var saleForm = new Ext.form.FormPanel({
                frame: true,
                title: '',
                items: [
                //		{
                //			xtype:'textfield',
                //			fieldLabel:'创建组织',
                //			columnWidth:1,
                //			anchor:'90%',
                //			name:'OrgId',
                //			id:'OrgId'
                //		}
		{
		xtype: 'hidden',
		fieldLabel: '商品ID',
		columnWidth: 1,
		anchor: '90%',
		name: 'ProductId',
		id: 'ProductId'
},
{
    xtype: 'textfield',
    fieldLabel: '产品名称',
    columnWidth: 1,
    anchor: '90%',
    name: 'ProductName',
    id: 'ProductName'
}
, {
    xtype: 'textfield',
    fieldLabel: '短信码',
    columnWidth: 1,
    anchor: '90%',
    name: 'SmsCode',
    id: 'SmsCode'
}, {
    xtype: 'textfield',
    fieldLabel: '语音码',
    columnWidth: 1,
    anchor: '90%',
    name: 'Ext6',
    id: 'Ext6',
    renderer:function(v){
     if(v==0) return ''; 
   }
}
, {
    xtype: 'combo',
    fieldLabel: '税目',
    columnWidth: 1,
    anchor: '90%',
    name: 'TaxSubject',
    id: 'TaxSubject',
    displayField:'TaxProduct',
    valueField:'TaxCode',
    mode:'local',
    triggerAction:'all',
    selectOnFocus: true,
    forceSelection: true,
    store:dsTaxType,
    tpl:resultTpl,
    itemSelector: 'div.search-item',
    listeners:{
        beforequery:function(qe){  
            regexValue(qe);
        }
    }
}
, {
    xtype: 'textfield',
    fieldLabel: '产品编号',
    columnWidth: 1,
    anchor: '90%',
    name: 'ProductNo',
    id: 'ProductNo',
    disabled: true
}
, {
    xtype: 'textfield',
    fieldLabel: '助记码',
    columnWidth: 1,
    anchor: '90%',
    name: 'MnemonicNo',
    id: 'MnemonicNo',
    disabled: true
}
, {
    xtype: 'textfield',
    fieldLabel: '规格',
    columnWidth: 1,
    anchor: '90%',
    name: 'Specifications',
    id: 'Specifications',
    disabled: true
},
{
    xtype: 'combo',
    store: dsProductUnits, //dsWareHouse,
    valueField: 'UnitId',
    displayField: 'UnitName',
    mode: 'local',
    forceSelection: true,
    editable: false,
    name: 'UnitId',
    id: 'UnitId',
    emptyValue: '',
    triggerAction: 'all',
    fieldLabel: '销售单位',
    selectOnFocus: true,
    anchor: '90%'
},
{
    xtype: 'combo',
    store: dsProductReportUnits, //dsWareHouse,
    valueField: 'UnitId',
    displayField: 'UnitName',
    mode: 'local',
    forceSelection: true,
    editable: false,
    name: 'Ext7',
    id: 'Ext7',
    emptyValue: '',
    triggerAction: 'all',
    fieldLabel: '报表单位',
    selectOnFocus: true,
    anchor: '90%'
}, {
    xtype: 'combo',
    store: dsWareHouse, //dsWareHouse,
    valueField: 'WhId',
    displayField: 'WhName',
    mode: 'local',
    forceSelection: true,
    name: 'Ext3',
    id: 'Ext3',
    emptyValue: '',
    triggerAction: 'all',
    fieldLabel: '仓库',
    selectOnFocus: true,
    anchor: '90%'
}, {
    xtype: 'textfield',
    fieldLabel: '销售自定义名称',
    columnWidth: 1,
    anchor: '90%',
    name: 'Ext2',
    id: 'Ext2'
}
]
});

function regexValue(qe) {
    var combo = qe.combo;
    //q is the text that user inputed.  
    var q = qe.query;
    forceAll = qe.forceAll;
    if (forceAll === true || (q.length >= combo.minChars)) {
        if (combo.lastQuery !== q) {
            combo.lastQuery = q;
            if (combo.mode == 'local') {
                combo.selectedIndex = -1;
                if (forceAll) {
                    combo.store.clearFilter();
                } else {
                    combo.store.filterBy(function(record, id) {
                        var text = record.get(combo.displayField);
                        //在这里写自己的过滤代码  
                        return (text.indexOf(q) != -1);
                    });
                }
                combo.onLoad();
            } else {
                combo.store.baseParams[combo.queryParam] = q;
                combo.store.load({
                    params: combo.getParams(q)
                });
                combo.expand();
            }
        } else {
            combo.selectedIndex = -1;
            combo.onLoad();
        }
    }
    return false;
}
            /*------FormPanle的函数结束 End---------------*/

            /*------开始界面数据的窗体 Start---------------*/
            if (typeof (uploadIndividualWindow) == "undefined") {//解决创建2个windows问题
                uploadIndividualWindow = new Ext.Window({
                    id: 'Individualformwindow',
                    title: '可购商品信息维护'
		, iconCls: 'upload-win'
		, width: 600
		, height: 410
		, layout: 'fit'
		, plain: true
		, modal: true
		, x: 50
		, y: 50
		, constrain: true
		, resizable: false
		, closeAction: 'hide'
		, autoDestroy: true
		, items: saleForm
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
			    uploadIndividualWindow.hide();
			}
			, scope: this
}]
                });
            }
            uploadIndividualWindow.addListener("hide", function() {
            });

            /*------开始获取界面数据的函数 start---------------*/
            function getFormValue() {
                Ext.Ajax.request({
                    url: 'frmBaSaleProduct.aspx?method=save',
                    method: 'POST',
                    params: {
                        ProductId: Ext.getCmp('ProductId').getValue(),
                        SmsCode: Ext.getCmp('SmsCode').getValue(),
                        TaxSubject: Ext.getCmp('TaxSubject').getValue(),
                        Ext1: Ext.getCmp("UnitId").getValue(),
                        Ext2: Ext.getCmp("Ext2").getValue(),
                        Ext3: Ext.getCmp("Ext3").getValue(),
                        Ext6:Ext.getCmp("Ext6").getValue(),
                        Ext7:Ext.getCmp("Ext7").getValue()
                    },
                    success: function(resp, opts) {
                        if (checkExtMessage(resp)) {
                            //saleProductGridData.reload({params:{start:0,limit:10}});
                            saleProductGridData.reload({params:{start:0,limit:10}});
                            uploadIndividualWindow.hide();
                        }
                    },
                    failure: function(resp, opts) {
                        Ext.Msg.alert("提示", "保存失败");
                    }
                });
            }
            /*------结束获取界面数据的函数 End---------------*/

            /*------开始界面数据的函数 Start---------------*/
            function setFormValue(selectData) {
                var data = selectData.data;
                //Ext.getCmp("OrgId").setValue(data.OrgId);
                Ext.getCmp("ProductId").setValue(data.ProductId);
                Ext.getCmp("SmsCode").setValue(data.SmsCode);
                Ext.getCmp("TaxSubject").setValue(data.TaxSubject);
                Ext.getCmp("ProductNo").setValue(data.ProductNo);
                Ext.getCmp("MnemonicNo").setValue(data.MnemonicNo);
                Ext.getCmp("ProductName").setValue(data.ProductName);
                Ext.getCmp("Specifications").setValue(data.Specifications);
                beforeEdit();
                Ext.getCmp("UnitId").setValue(data.Ext1);
                if (data.Ext3 == '0') {
                    Ext.getCmp("Ext3").setValue('');
                }
                else {
                    Ext.getCmp("Ext3").setValue(data.Ext3);
                }
                if (data.Ext6 == '0') {
                    Ext.getCmp("Ext6").setValue('');
                }
                else {
                    Ext.getCmp("Ext6").setValue(data.Ext6);
                }
                if(data.Ext7=='0'){
                    Ext.getCmp("Ext7").setValue('');
                }
                else{
                    Ext.getCmp("Ext7").setValue(data.Ext7);
                }
				Ext.getCmp("Ext2").setValue(data.Ext2);

            }
            /*------结束设置界面数据的函数 End---------------*/

            /*------开始获取数据的函数 start---------------*/
            var saleProductGridData = new Ext.data.Store
({
    url: 'frmBaSaleProduct.aspx?method=getlist',
    reader: new Ext.data.JsonReader({
        totalProperty: 'totalProperty',
        root: 'root'
    }, [
	{ name: 'OrgId' },
	{ name: 'ProductId' },
	{ name: 'SmsCode' },
	{ name: 'TaxSubject' },
	{ name: 'ProductNo' },
	{ name: 'MnemonicNo' },
	{ name: 'AliasNo' },
	{ name: 'ProductName' },
	{ name: 'SpecificationsText' },
	{ name: 'UnitText' },
	{ name: 'Unit' },
	{ name: 'Ext1' },
	{ name: 'Ext2' },
	{ name: 'Ext3'},
	{ name: 'Ext6'},
	{ name: 'Ext7'},
	{ name: 'Ext9'}])
	,
    listeners:
	{
	    scope: this,
	    load: function() {
	    }
	}
});

            /*------获取数据的函数 结束 End---------------*/
            defaultPageSize = 15;
            var toolBar = new Ext.PagingToolbar({
                pageSize: defaultPageSize,
                store: saleProductGridData,
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
                singleSelect: true
            });
            var saleProductGrid = new Ext.grid.GridPanel({
                el: 'saleProductGridDiv',
                width: document.body.offsetWidth,
                height: '100%',
                autoWidth: true,
                autoScroll: true,
                layout: 'fit',
                id: 'saleProductGrid',
                store: saleProductGridData,
                loadMask: { msg: '正在加载数据，请稍侯……' },
                sm: sm,
                cm: new Ext.grid.ColumnModel([
		sm,
		new Ext.grid.RowNumberer(), //自动行号
		
		{
		    header: '产品编号',
		    dataIndex: 'ProductNo',
		    id: 'ProductNo',
		    width:60
		},
		{
		    header: '产品名称',
		    dataIndex: 'ProductName',
		    id: 'ProductName',
		    width:180
        },
		{
		    header: '规格',
		    dataIndex: 'SpecificationsText',
		    id: 'SpecificationsText',
		    width:60
		},
		{
		    header: '销售单位',
		    dataIndex: 'Ext1',
		    id: 'Ext1',
		    width:60,
		    renderer: getUnitName
        },
		{
		    header: '报表单位',
		    dataIndex: 'Ext7',
		    id: 'Ext7',
		    width:60,
		    renderer: getUnitName
        },
		{
		    header: '短信码',
		    dataIndex: 'SmsCode',
		    id: 'SmsCode',
		    width:70
		},
		{
		    header: '语音码',
		    dataIndex: 'Ext6',
		    id: 'Ext6',
		    width:70
		},
		{
		    header: '税号',
		    dataIndex: 'TaxSubject',
		    id: 'TaxSubject',
		    width:100,
		    renderer: getTaxSubjectName
		},
		{
		    header: '销售自定义名称',
		    dataIndex: 'Ext2',
		    id: 'Ext2',
		    width:100
        },
		{
		    header: '状态',
		    dataIndex: 'Ext9',
		    id: 'Ext9',
		    width:60,
            renderer:{
                fn:function(v){
                    if(v=='0') return '有效';
                    if(v=='1') return '停售';
                }
            }
		},
		{
		    header: '其他',
		    dataIndex: 'AliasNo',
		    id: 'AliasNo'
		}]),
                bbar: toolBar,
                viewConfig: {
                    columnsText: '显示的列',
                    scrollOffset: 20,
                    sortAscText: '升序',
                    sortDescText: '降序',
                    forceFit: false
                },
                height: 415,
                closeAction: 'hide',
                stripeRows: true,
                loadMask: true//,
                //autoExpandColumn: 2
            });

            toolBar.addField(createPrintButton(saleProductGridData, saleProductGrid, ''));
            saleProductGrid.render();

            printTitle = "可售商品信息";
            /*------DataGrid的函数结束 End---------------*/
            createSearch(saleProductGrid, saleProductGridData, "searchForm");
            searchForm.el = "searchForm";
            searchForm.render();

            var addRow = new fieldRowPattern({
                id: 'ProductType',
                name: '存货类别',
                dataType: 'select'
            });
            fieldStore.add(addRow);

            txtFieldValue.on("focus", selectProductType);

            function selectProductType() {
                if (cmbField.getValue() != "ProductType")
                    return;
                if (selectProductForm == null) {
                    parentUrl = "../../CRM/product/frmBaProductClass.aspx?select=true&method=getbaproducttree";
                    showProductForm("", "", "", true);
                    selectProductForm.buttons[0].on("click", selectProductOk);
                }
                else {
                    showProductForm("", "", "", true);
                }
            }
            var selectedProductIds = "";
            function selectProductOk() {
                var selectProductNames = "";
                selectedProductIds = "";
                var selectNodes = selectProductTree.getChecked();
                for (var i = 0; i < selectNodes.length; i++) {
                    if (selectProductNames != "") {
                        selectProductNames += ",";
                        selectedProductIds += ",";
                    }
                    selectProductNames += selectNodes[i].text;
                    selectedProductIds += selectNodes[i].id + '!' + selectNodes[i].text + '!' + selectNodes[i].attributes.CustomerColumn;
                }
                txtFieldValue.setValue(selectProductNames);
            }

            this.selectShow = function(columnName) {
                switch (columnName) {
                    case 'ProductType':
                        if (selectProductForm == null) {
                            parentUrl = "../../CRM/product/frmBaProductClass.aspx?select=true&method=getbaproducttree";
                            showProductForm("", "", "", true);
                            selectProductForm.buttons[0].on("click", selectProductOk);
                        }
                        else {
                            showProductForm("", "", "", true);
                        }
                        break;
                }
            };
            
            this.getSelectedValue = function() {
                return selectedProductIds;
            }

btnExpert.setVisible(true);

function getTaxSubjectName(val){
            var subjectName ='';
            dsTaxType.clearFilter();
            dsTaxType.each(function(vec) {
            if (vec.data.TaxCode == val) {
                subjectName = vec.data.TaxProduct;
                    
                }
            });
           return subjectName;
        }

        })
        
        function getUnitName(val) {
            var unitName = '';
            dsUnitList.each(function(dsUnitList) {
            if (dsUnitList.data.UnitId == val) {
                unitName = dsUnitList.data.UnitName;
                    
                }
            });
           return unitName;
        }
        
        function getCommonName(val)
        {
            if(val=='0')
                return '否';
            else return '是';
        }
        function getCmbStore(columnName) {
            switch (columnName) {
                case "Ext1":
                    return dsUnitList;
                default:
                    return null;
            }

        }
</script>
<body>
<div id='toolbar'></div>
<div id='divForm'></div>
<div id='searchForm'></div>
<div id='saleProductGridDiv'></div>

</body>
</html>

