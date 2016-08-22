<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmNegtiveStockLimit.aspx.cs" Inherits="BA_product_frmNegtiveStockLimit" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>负库存出库商品设置</title>
    <meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
    <link rel="stylesheet" type="text/css" href="../../ext3/resources/css/ext-all.css" />
    <script type="text/javascript" src="../../ext3/adapter/ext/ext-base.js"></script>
    <script type="text/javascript" src="../../ext3/ext-all.js"></script>  
    <script type="text/javascript" src="../../js/operateResp.js"></script>  
</head>
<body>
    <div id='toolbar'></div>
    <div id='divForm'></div>
    <div id='searchForm'></div>
    <div id='productGrid'></div>
<%= getComboBoxStore() %>
</body>
<script type="text/javascript">
Ext.BLANK_IMAGE_URL = "../../ext3/resources/images/default/s.gif";
Ext.onReady(function(){    
    var operType = '';
    /****************************************************************/
    var dsWareHouse; 
    if (dsWareHouse == null) { //防止重复加载
        dsWareHouse = new Ext.data.JsonStore({
            totalProperty: "result",
            root: "root",
            url: 'frmNegtiveStockLimit.aspx?method=getWhSimple',
            fields: ['WhId', 'WhName']
        });
        dsWareHouse.baseParams.ForBusi='true';
        dsWareHouse.load();
     };
    /****************************************************************/
    /*------实现toolbar的函数 start---------------*/
    var Toolbar = new Ext.Toolbar({
	    //renderTo:"toolbar",
	    items:[{
		    text:"添加",
		    icon:"../../Theme/1/images/extjs/customer/add16.gif",
		    handler:function(){
		        operType = 'add';
                openWindowShow();
		    }
		    },'-',{
		    text:"删除",
		    icon:"../../Theme/1/images/extjs/customer/delete16.gif",
		    handler:function(){
		        deleteProductInfo();
		    }
	    }]
    });
    
    
    /*------开始查询form的函数 start---------------*/
    var orgPanel = new Ext.form.ComboBox({
        xtype:'combo',
        fieldLabel:'公司标识',
        anchor:'98%',
        style: 'margin-left:0px',
        cls: 'key',
        name:'OrgName',
        id:'OrgId',
        store: dsOrg,
        displayField: 'OrgName',  //这个字段和业务实体中字段同名
        valueField: 'OrgId',      //这个字段和业务实体中字段同名
        typeAhead: false, //自动将第一个搜索到的选项补全输入
        triggerAction: 'all',
        emptyValue: '',
        selectOnFocus: true,
        forceSelection: true,
        mode:'local' ,
        listeners: {
           select: function(combo, record, index) {
                var curOrgId = Ext.getCmp('OrgId').getValue();
                dsWareHouse.load({
                    params: {
                        orgID: curOrgId
                    }
                });
            },
            specialkey: function(f, e) { if (e.getKey() == e.ENTER) { whnamePanel.focus(); } } 
        }             

    });


    function regexValue(qe){
        var combo = qe.combo;  
        //q is the text that user inputed.  
        var q = qe.query;  
        forceAll = qe.forceAll;  
        if(forceAll === true || (q.length >= combo.minChars)){  
         if(combo.lastQuery !== q){  
             combo.lastQuery = q;  
             if(combo.mode == 'local'){  
                 combo.selectedIndex = -1;  
                 if(forceAll){  
                     combo.store.clearFilter();  
                 }else{  
                     combo.store.filterBy(function(record,id){  
                         var text = record.get(combo.displayField);  
                         //在这里写自己的过滤代码  
                         return (text.indexOf(q)!=-1);  
                     });  
                 }  
                 combo.onLoad();  
             }else{  
                 combo.store.baseParams[combo.queryParam] = q;  
                 combo.store.load({  
                     params: combo.getParams(q)  
                 });  
                 combo.expand();  
             }  
         }else{  
             combo.selectedIndex = -1;  
             combo.onLoad();  
         }  
        }  
        return false;  
    }
    orgPanel.on('beforequery',function(qe){  
        regexValue(qe);
    });  
    var WhNamePanel = new Ext.form.ComboBox({
        fieldLabel: '仓库名称',
        name: 'warehouseCombo',
        store: dsWareHouse,
        displayField: 'WhName',
        valueField: 'WhId',
        typeAhead: true, //自动将第一个搜索到的选项补全输入
        triggerAction: 'all',
        emptyText: '请选择仓库',
        //valueNotFoundText: 0,
        selectOnFocus: true,
        forceSelection: true,
        anchor: '90%',
        mode: 'local',
        listeners: {
            specialkey: function(f, e) {
                if (e.getKey() == e.ENTER) {
                    Ext.getCmp('searchebtnId').focus();
                }
            }
          ,
            select: function(combo, record, index) {
                
            }
        }
    });
    var serchform = new Ext.FormPanel({
        renderTo: 'searchForm',
        labelAlign: 'left',
        layout: 'fit',
        buttonAlign: 'right',
        bodyStyle: 'padding:5px',
        frame: true,
        labelWidth: 55,
        items: [{
            layout: 'column',   //定义该元素为布局为列布局方式
            border: false,
            items: [{
                columnWidth: .4,  //该列占用的宽度，标识为20％
                layout: 'form',
                border: false,
                items: [
                    orgPanel
                ]
            }, {
                columnWidth: .4,
                layout: 'form',
                border: false,
                items: [
                    WhNamePanel
                    ]
            }, {
                columnWidth: .2,
                layout: 'form',
                border: false,
                items: [{ cls: 'key',
                    xtype: 'button',
                    text: '查询',
                    id: 'searchebtnId',
                    anchor: '50%',
                    handler: function() {

                        var OrgId = orgPanel.getValue();
                        var WhId = WhNamePanel.getValue();

                        productGridData.baseParams.OrgId =   OrgId; 
                        productGridData.baseParams.WhId =   WhId;
                        productGridData.load({
                            params: {
                                start: 0,
                                limit: 20
                            }
                        });
                    }
                }]
            }]
        }]
    });
    serchform.render();
    /*------开始查询form的函数 end---------------*/
    /*------开始获取数据的函数 start---------------*/
    var productGridData = new Ext.data.Store
    ({
        url: 'frmNegtiveStockLimit.aspx?method=getProductInfoList',
        reader:new Ext.data.JsonReader({
	        totalProperty:'totalProperty',
	        root:'root'
        },[
	    {		    name:'ProductId'	    },
	    {		    name:'ProductNo'	    },
	    {		    name:'MnemonicNo'	    },
	    {		    name:'AliasNo'	    },
	    {		    name:'MobileNo'	    },	    
	                {name:'CfgId'},
	    {		    name:'SpeechNo'	    },
	    {		    name:'NetPurchasesNo'	    },
	    {		    name:'LogisticsNo'	    },
	    {		    name:'BarCode'	    },
	    {		    name:'SecurityCode'	    },
	    {		    name:'ProductName'	    },
	    {		    name:'AliasName'	    },
	    {		    name:'Specifications'	    },
	    {		    name:'SpecificationsText'	    },
	    {		    name:'Unit'	    },
	    {	        name:'UnitText'	    },
	    {		    name:'SalePrice'	    },
	    {		    name:'SalePriceLower'	    },
	    {		    name:'SalePriceLimit'	    },
	    {		    name:'TaxWhPrice'	    },
	    {		    name:'TaxRate'	    },
	    {		    name:'Tax'	    },
	    {		    name:'SalesTax'	    },
	    {		    name:'UnitConvertRate'	    },
	    {		    name:'AutoFreight'	    },
	    {		    name:'DriverFreight'	    },
	    {		    name:'TrainFreight'	    },
	    {		    name:'ShipFreight'	    },
	    {		    name:'OtherFeight'	    },
	    {		    name:'Supplier'	    },	
	    {	        name:'SupplierText'	    },
	    {		    name:'Origin'	    },	    
	    {		    name:'OriginText'	    },
	    {		    name:'AliasPrice'	    },
	    {		    name:'IsPlan'	    },
	    {		    name:'ProductType'	    },
	    {		    name:'ProductVer'	    },
	    {		    name:'Remark'	    },
	    {		    name:'CreateDate'	    },
	    {		    name:'UpdateDate'	    },
	    {		    name:'OperId'	    },
	    {		    name:'OrgShortName'	    },
	    {		    name:'WhName'	    },
	    {		    name:'OrgId'
	    }	])
	    ,
	    listeners:
	    {
		    scope:this,
		    load:function(){ 
		    }
	    }
    });

    /*------获取数据的函数 结束 End---------------*/
    /*------开始DataGrid的函数 start---------------*/

    var sm= new Ext.grid.CheckboxSelectionModel({
	    singleSelect:true
    });
    var productGrid = new Ext.grid.GridPanel({
	    el: 'productGrid',
	    width:'100%',
	    height:'100%',
	    //autoWidth:true,
	    //autoHeight:true,
	    autoScroll:true,
	    layout: 'fit',
	    id: '',
	    store: productGridData,
	    loadMask: {msg:'正在加载数据，请稍侯……'},
	    sm:sm,
	    cm: new Ext.grid.ColumnModel([
		    sm,
		    new Ext.grid.RowNumberer(),//自动行号
		    {
			    header:'ID',
			    dataIndex:'CfgId',
			    id:'CfgId',
			    hidden: true,
                hideable: false
		    },
		    {
			    header:'组织名称',
			    dataIndex:'OrgShortName',
			    id:'OrgShortName',
			    width:100
		    },
		    {
			    header:'仓库名称',
			    dataIndex:'WhName',
			    id:'WhName',
			    width:100
		    },
		    {
			    header:'存货编号',
			    dataIndex:'ProductNo',
			    id:'ProductNo',
			    width:100
		    },
		    {
			    header:'助记码',
			    dataIndex:'MnemonicNo',
			    id:'MnemonicNo',
			    width:100
		    },
		    {
			    header:'存货名称',
			    dataIndex:'ProductName',
			    id:'ProductName',
			    width:170
		    },
		    {
			    header:'规格',
			    dataIndex:'SpecificationsText',
			    id:'SpecificationsText',
			    width:40
		    },
		    {
			    header:'计量单位',
			    dataIndex:'UnitText',
			    id:'UnitText',
			    width:60
		    },
		    {
			    header:'销售单价',
			    dataIndex:'SalePrice',
			    id:'SalePrice',
			    width:60
		    },
		    {
			    header:'供应商',
			    dataIndex:'SupplierText',
			    id:'SupplierText',
			    width:150
		    },
		    {
			    header:'产地',
			    dataIndex:'OriginText',
			    id:'OriginText',
			    width:100
		    }		]),
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
		    height: 340,
		    closeAction: 'hide',
		    stripeRows: true,
		    loadMask: true,
		    tbar:[
		        {
		        text:"添加",
		        icon:"../../Theme/1/images/extjs/customer/add16.gif",
		        handler:function(){
                        openWindowShow();
		            }
		        },'-',{
		        text:"删除",
		        icon:"../../Theme/1/images/extjs/customer/delete16.gif",
		        handler:function(){
		                deleteProductInfo();
		            }
		        }
	        ]
	    });
    productGrid.render();
    function saveProductCfg(){
        var sm = productNonGrid.getSelectionModel();
        var selectData = sm.getSelected();
        var record=sm.getSelections();

        if (selectData == null || selectData.length == 0) 
        {
            Ext.Msg.alert("提示", "请选中一行！");
        }
        else 
        {   
            var array = new Array(record.length);
            for(var i=0;i<record.length;i++)
            {
                array[i] = record[i].get('ProductId');
            }
            Ext.Ajax.request({
            url: 'frmNegtiveStockLimit.aspx?method=addCfg',
                params: {
                    WhId:Ext.getCmp('whCombo').getValue(),
                    ProductId: array.join('-')//传入多想的id串
                },
                success: function(resp, opts) {
                    //var data=Ext.util.JSON.decode(resp.responseText);
                    if ( checkExtMessage(resp) ) {
                        //重新取数据
                        productGridData.baseParams.WhId=WhNamePanel.getValue();
                        productGridData.reload({
                            params:{
                             limit:20,
                             start:0
                             }
                        });
                        productNonWin.hide();
                    }
                },
                failure: function(resp, opts) {
                    Ext.Msg.alert("提示", "保存失败！");
                }
            });
        }
    }
    
    function openWindowShow(){
        productNonWin.show();
        if(WhNamePanel.getValue() != null)
            Ext.getCmp('whCombo').setValue(WhNamePanel.getValue() );
    }
    
    function deleteProductInfo(){
        var sm = productGrid.getSelectionModel();
        var selectData = sm.getSelected();
        if (selectData == null || selectData.length == 0 || selectData.length > 1) 
        {
            Ext.Msg.alert("提示", "请选中一行！");
        }
        else 
        {   //alert(selectData.data.CfgId);
            Ext.Ajax.request({
            url: 'frmNegtiveStockLimit.aspx?method=deleteProductInfo',
                params: {
                CfgId: selectData.data.CfgId
                },
                success: function(resp, opts) {
                    //var data=Ext.util.JSON.decode(resp.responseText);
                    Ext.Msg.alert("提示", "删除成功！");
                    productGrid.getStore().reload();
                },
                failure: function(resp, opts) {
                    Ext.Msg.alert("提示", "删除失败！");
                }
            });
        }
    }
    /*------DataGrid的函数结束 End---------------*/
    /*------开始查询form的函数 start---------------*/
    var MnemonicNoPanel = new Ext.form.TextField({
        style: 'margin-left:0px',
        cls: 'key',
        xtype: 'textfield',
        fieldLabel: '存货编码',
        anchor: '90%',
        listeners: { specialkey: function(f, e) { if (e.getKey() == e.ENTER) { ProductNamePanel.focus(); } } }

    });


    var ProductNamePanel = new Ext.form.TextField({
        style: 'margin-left:0px',
        cls: 'key',
        xtype: 'textfield',
        fieldLabel: '存货名称',
        anchor: '90%',
        listeners: { specialkey: function(f, e) { if (e.getKey() == e.ENTER) { Ext.getCmp('searchebtnId').focus(); } } }
    });
    var productSerchform = new Ext.FormPanel({
        region:'north',
        labelAlign: 'left',
        layout: 'fit',
        buttonAlign: 'right',
        bodyStyle: 'padding:5px',
        frame: true,
        labelWidth: 55,
        items: [{
            layout: 'column',   //定义该元素为布局为列布局方式
            border: false,
            items: [{
                columnWidth: .4,  //该列占用的宽度，标识为20％
                layout: 'form',
                border: false,
                items: [
                    MnemonicNoPanel
                ]
            }, {
                columnWidth: .4,
                layout: 'form',
                border: false,
                items: [
                    ProductNamePanel
                    ]
            }, {
                columnWidth: .2,
                layout: 'form',
                border: false,
                items: [{ cls: 'key',
                    xtype: 'button',
                    text: '查询',
                    id: 'nonSearchebtnId',
                    anchor: '50%',
                    handler: function() {

                        var MnemonicNo = MnemonicNoPanel.getValue();
                        var ProductName = ProductNamePanel.getValue();
                        
                        if(curOrgId == 1){
                            productNoneGridData.load({
                                params: {
                                    start: 0,
                                    limit: 20,
                                    MnemonicNo:MnemonicNo,
                                    ProductName:ProductName
                                }
                            });
                        }else{
                            productNoneGridData.load({
                                params: {
                                    start: 0,
                                    limit: 20,
                                    MnemonicNo:MnemonicNo,
                                    ProductName:ProductName,
                                    IsPlan:0
                                }
                            });
                        }
                    }
                }]
            }]
        }]
    });
    /*------开始查询form的函数 end---------------*/
    /*------开始已配置产品列表 start---------------*/
    var productNoneGridData;
    if(productNoneGridData==null){
        productNoneGridData = new Ext.data.Store({
            url:"frmNegtiveStockLimit.aspx?method=getAllProducts",
            reader:new Ext.data.JsonReader({
                totalProperty:'totalProperty',
	            root:'root'},
	            [
	                {name:'ProductId'},
	                {name:'ProductNo'},
	                {name:'MnemonicNo'},
	                {name:'AliasNo'},
	                {name:'MobileNo'},
	                {name:'SpeechNo'},
	                {name:'NetPurchasesNo'},
	                {name:'LogisticsNo'},
	                {name:'BarCode'},
	                {name:'SecurityCode'},
	                {name:'ProductName'},
	                {name:'AliasName'},
	                {name:'Specifications'},
	                {name:'SpecificationsText'},
	                {name:'Unit'},
	                {name:'UnitText'},
	                {name:'TaxWhPrice'},
	                {name:'AutoFreight'},
	                {name:'DriverFreight'},
	                {name:'TrainFreight'},
	                {name:'ShipFreight'},
	                {name:'OtherFeight'},
	                {name:'Supplier'},
	                {name:'Origin'},
	                {name:'OriginText'},
	                {name:'AliasPrice'},
	                {name:'ProductType'},
	                {name:'ProductVer'},
	                {name:'CreateDate'}
	            ])	        
        });
    }

    var smNonRel= new Ext.grid.CheckboxSelectionModel({
	    singleSelect:false
    });
    var productNonGrid = new Ext.grid.GridPanel({
        region:'center',
	    width:'100%',
	    height:'100%',
	    autoWidth:true,
	    autoScroll:true,
	    layout: 'fit',
	    id: '',
	    store: productNoneGridData,
	    loadMask: {msg:'正在加载数据，请稍侯……'},
	    sm:smNonRel,
	    cm: new Ext.grid.ColumnModel([
		    smNonRel,
		    new Ext.grid.RowNumberer(),//自动行号
		    {
		        header:'存货ID',
			    dataIndex:'CfgId',
			    id:'CfgId',
			    hidden: true,
                hideable: false
		    },
		    {
			    header:'存货编号',
			    dataIndex:'ProductNo',
			    id:'ProductNo'
		    },
		    {
			    header:'助记码',
			    dataIndex:'MnemonicNo',
			    id:'MnemonicNo'
		    },
		    {
			    header:'存货名称',
			    dataIndex:'ProductName',
			    id:'ProductName'
		    },
		    {
			    header:'规格',
			    dataIndex:'SpecificationsText',
			    id:'SpecificationsText'
		    },
		    {
			    header:'计量单位',
			    dataIndex:'UnitText',
			    id:'UnitText'
		    },
		    {
			    header:'销售单价',
			    dataIndex:'SalePrice',
			    id:'SalePrice'
		    },
		    {
			    header:'产地',
			    dataIndex:'OriginText',
			    id:'OriginText'
		    }		]),
		    bbar: new Ext.PagingToolbar({
			    pageSize: 20,
			    store: productNoneGridData,
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
    var whform = new Ext.FormPanel({
        region:'south',
        labelAlign: 'left',
        buttonAlign: 'right',
        bodyStyle: 'padding:5px',
        frame: true,
        labelWidth: 100,
        items: [{
            layout: 'column',   //定义该元素为布局为列布局方式
            border: false,
            items: [{
                columnWidth: .6,  //该列占用的宽度，标识为20％
                layout: 'form',
                border: false,
                items: [{
                    fieldLabel: '请选择指定仓库',
                    xtype:'combo',
                    name: 'whCombo',
                    id:'whCombo',
                    store: dsWareHouse,
                    displayField: 'WhName',
                    valueField: 'WhId',
                    typeAhead: true, //自动将第一个搜索到的选项补全输入
                    triggerAction: 'all',
                    emptyText: '请选择仓库',
                    selectOnFocus: true,
                    forceSelection: true,
                    anchor: '90%',
                    mode: 'local'
                }]
            }, {
                columnWidth: .4,
                layout: 'form',
                border: false
            }]
        }]
    });
    /*------结束已配置产品列表 end---------------*/
    //弹出一个window窗口
    var productNonWin;
    if( productNonWin == null){
        productNonWin = new Ext.Window({
             title:'客户存货类别商品增加',
             id:'cfgNonWin',
             width:600 ,
             height:450, 
             constrain:true,
             plain: true, 
             modal: true,
             closeAction: 'hide',
             autoDestroy :true,
             resizable:true,
             items: [productSerchform,productNonGrid,whform],
             buttons: [
                {
                    text: "保存"
                    , handler: function() {
                        saveProductCfg();
                    }
                    , scope: this
                },
                {
                    text: "关闭"
                    , handler: function() {
                        productNonWin.hide();
                    }
                    , scope: this
                }]
        });
        productNonWin.addListener("hide", function() {
            productSerchform.getForm().reset();
            productNonGrid.getStore().removeAll();
        });
    }
    

    orgPanel.setValue(<% =ZJSIG.UIProcess.ADM.UIAdmUser.OrgID(this)%>);
    var curOrgId = orgPanel.getValue();
    dsWareHouse.load({
        params: {
            orgID: curOrgId
        }
    });
    if(curOrgId != 1)
     orgPanel.setDisabled(true);
 
})
</script>
</html>
