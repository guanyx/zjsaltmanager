<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmCrmCustClassProduct.aspx.cs" Inherits="CRM_customer_frmCrmCustClassProduct" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>存货分类商品对应关系维护</title>
    <meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
    <link rel="stylesheet" type="text/css" href="../../ext3/resources/css/ext-all.css" />
	<script type="text/javascript" src="../../ext3/adapter/ext/ext-base.js"></script>	
	<script type="text/javascript" src="../../ext3/ext-all.js"></script>
</head>
<body>   
   <div id ='toolbar'></div>
   <div id = 'searchForm'></div>
   <div id ='GridPanel'></div>
   <div id ='tree-div'></div>
   <div id='productGrid'></div>
   <div id = 'productSearchForm'></div>
</body>
<script type="text/javascript">
Ext.BLANK_IMAGE_URL = "../../ext3/resources/images/default/s.gif";
Ext.onReady(function(){
var strCustomerId = 0;
var currentNodeId = 0;
/*------定义toolbar start---------------*/
var Toolbar = new Ext.Toolbar({
        renderTo : "toolbar",
		items:[{
        text : "类别商品配置",
        icon: '../../Theme/1/images/extjs/customer/add16.gif', 
        handler : function(){
            cfgProductWin();//点击后弹出原有信息
		}
    }]
});
/*------定义toolbar end ----------------*/
/*------定义查询form start ----------------*/
var cusidPanel = new Ext.form.TextField({
    style: 'margin-left:0px',
    cls: 'key',
    xtype: 'textfield',
    fieldLabel: '客户编号',
    name: 'cusid',
    id:'search',
    anchor: '90%'
});


var namePanel = new Ext.form.TextField({
    style: 'margin-left:0px',
    cls: 'key',
    xtype: 'textfield',
    fieldLabel: '客户名称',
    name: 'name',
    anchor: '90%'
});

var serchform = new Ext.FormPanel({
    renderTo: 'searchForm',
    labelAlign: 'left',
    layout:'fit',
    buttonAlign: 'right',
    bodyStyle: 'padding:5px',
    frame: true,
    labelWidth: 55,
    items: [{
        layout: 'column',   //定义该元素为布局为列布局方式
        border: false,
        items: [{
            columnWidth: .32,  //该列占用的宽度，标识为20％
            layout: 'form',
            border: false,
            items: [
            cusidPanel
            ]
        }, {
            columnWidth: .33,
            layout: 'form',
            border: false,
            items: [
                namePanel
                ]
        }, {
            columnWidth: .10,
            layout: 'form',
            border: false,
            items: [{ cls: 'key',
                xtype: 'button',
                text: '查询',
                anchor: '50%',
                handler :function(){                
                    var cusid=cusidPanel.getValue();
                    var name=namePanel.getValue();
                    
                    customerListStore.baseParams.CustomerNo = cusid;
                    customerListStore.baseParams.ChineseName = name;
                    customerListStore.load({
                                params : {
                                start : 0,
                                limit : 10
                                } 
                              }); 
                    }
                }]
        }]
    }]
});
/*------定义查询form end ----------------*/
/*------定义列表Grid start ----------------*/
var customerListStore = new Ext.data.Store
	({
	    url: 'frmCrmCustClassProduct.aspx?method=getCustomers',
	    reader: new Ext.data.JsonReader({
	        totalProperty: 'totalProperty',
	        root: 'root'
	    }, [
	        { name: "CustomerId" },
	        { name: "ShortName" },
	        { name: "LinkMan" },
	        { name: "LinkTel" },
	        { name: "LinkMobile" },
	        { name: "Fax" },
	        { name: "DistributionTypeText" },
	        { name: "MonthQuantity" },
	        { name: "IsCust" },
	        { name: "IsProvide" },
	        { name: 'CreateDate'}
	    ])
	});
var sm= new Ext.grid.CheckboxSelectionModel(
{
    singleSelect : true,
    listeners: {
        rowselect: function(sm, row, rec) {
            strCustomerId = rec.data.CustomerId;
        }
    } 
});
var CustomerGrid = new Ext.grid.GridPanel({
        el: 'GridPanel',
        width:'100%',
        height:'100%',
        autoWidth:true,
        autoHeight:true,
        autoScroll:true,
        layout: 'fit',
        id: 'customerdatagrid',
        store: customerListStore,
        loadMask: {msg:'正在加载数据，请稍侯……'},
        sm:sm,
        cm: new Ext.grid.ColumnModel([
        sm,
        new Ext.grid.RowNumberer(),//自动行号
       { header: "客户编号",dataIndex: 'CustomerId' ,hidden:true},
       { header: "客户名称",dataIndex: 'ShortName' },
       { header: "联系人", dataIndex: 'LinkMan' },
       { header: "联系电话", dataIndex: 'LinkTel' },
       { header: "移动电话", dataIndex: 'LinkMobile' },
       { header: "传真", dataIndex: 'Fax' },
       { header: "配送类型",dataIndex: 'DistributionTypeText' },
       { header: "月用量", dataIndex: 'MonthQuantity' },
       { header: "客商", dataIndex: 'IsCust' ,renderer:{ fn:function(v){ if(v==1)return '是';return '否'}}},
       { header: "供应商", dataIndex: 'IsProvide',renderer:{ fn:function(v){ if(v==1)return '是';return '否'}}},
       { header: "创建时间", dataIndex: 'CreateDate' }//
       ]),
      bbar: new Ext.PagingToolbar({
        pageSize: 10,
        store: customerListStore,
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
CustomerGrid.render();

/*------定义列表Grid end ----------------*/


/*------实现tree的函数 start---------------*/
Ext.BLANK_IMAGE_URL = "../../ext3/resources/images/default/s.gif";	
var Tree = Ext.tree;
var tree = new Tree.TreePanel({
    el:'tree-div',
    region:'west',
    useArrows:true,//是否使用箭头
    autoScroll:true,
    animate:true,
    width:'150',
    height:'100%',
    minSize: 150,
	maxSize: 180,
    enableDD:false,
    frame:true,
    border: false,
    containerScroll: true, 
    loader: new Tree.TreeLoader({
       dataUrl:'frmCrmCustClassProduct.aspx?method=gettreelist',
       baseParams:{
            CustomerId:strCustomerId
       }}),
    listeners : {  
        'beforeload' : function(node) { 
            tree.getLoader().baseParams.CustomerId = strCustomerId;
        }
    }
});
tree.on('click',function(node){  
    if(node.id ==0)
        return;
     refreshGrid(node.id);  
}); 
// set the root node
var root = new Tree.AsyncTreeNode({
    text: '存货分类',
    draggable:false,
    id:'0'
});
tree.setRootNode(root);

function refreshGrid(nodeId){
    currentNodeId = nodeId;
    productGridData.baseParams.CustomerId = strCustomerId;
    productGridData.baseParams.BuyClassId = currentNodeId;
    productGridData.load({
        params:{
               limit:10,
               start:0
	        }
    });
}
/*------结束tree的函数 end---------------*/
/*------开始已配置产品列表 start---------------*/
var productGridData;
if(productGridData==null){
    productGridData = new Ext.data.Store({
        url:"frmCrmCustClassProduct.aspx?method=getProducts",
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
	            {name:'SalePrice'},
	            {name:'SalePriceLower'},
	            {name:'SalePriceLimit'},
	            {name:'TaxWhPrice'},
	            {name:'TaxRate'},
	            {name:'Tax'},
	            {name:'SalesTax'},
	            {name:'UnitConvertRate'},
	            {name:'AutoFreight'},
	            {name:'DriverFreight'},
	            {name:'TrainFreight'},
	            {name:'ShipFreight'},
	            {name:'OtherFeight'},
	            {name:'Supplier'},
	            {name:'Origin'},
	            {name:'OriginText'},
	            {name:'AliasPrice'},
	            {name:'IsPlan'},
	            {name:'ProductType'},
	            {name:'ProductVer'},
	            { name:'Remark'},
	            {name:'CreateDate'},
	            {name:'UpdateDate'},
	            {name:'OperId'},
	            {name:'OrgId'}
	        ])	        
    });
}

var smRel= new Ext.grid.CheckboxSelectionModel({
	singleSelect:false
});
var productGrid = new Ext.grid.GridPanel({
    region:'center',
	width:'100%',
	height:'100%',
	autoWidth:true,
	autoScroll:true,
	layout: 'fit',
	id: '',
	store: productGridData,
	loadMask: {msg:'正在加载数据，请稍侯……'},
	sm:smRel,
	cm: new Ext.grid.ColumnModel([
		smRel,
		new Ext.grid.RowNumberer(),//自动行号
		{
			header:'存货ID',
			dataIndex:'ProductId',
			id:'ProductId',
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
//		tbar: new Ext.Toolbar({
//	        items:[{
//		        text:"新增",
//		        icon:"../../Theme/1/images/extjs/customer/add16.gif",
//		        handler:function(){
//                    openNonSelectWindowShow();
//		        }
//		        },'-',{
//		        text:"删除",
//		        icon:"../../Theme/1/images/extjs/customer/delete16.gif",
//		        handler:function(){
//		            deleteProducInfos();
//		        }
//	        }]
//        }),
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
		height: 280,
		closeAction: 'hide',
		stripeRows: true,
		loadMask: true,
		autoExpandColumn: 2
	});
	
	var defaultPageSize = 10;
	var toolBar = productGrid.getBottomToolbar();
	var pageSizestore = new Ext.data.SimpleStore({
	    fields: ['pageSize'],
	    data: [[10], [20], [30]]
	});
	var combo1 = new Ext.form.ComboBox({
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
	toolBar.addField(combo1);
	combo1.on("change", function(c, value) {
	    toolBar.pageSize = value;
	    defaultPageSize = toolBar.pageSize;
	}, toolBar);
	combo1.on("select", function(c, record) {
	    toolBar.pageSize = parseInt(record.get("pageSize"));
	    defaultPageSize = toolBar.pageSize;
	    toolBar.doLoad(0);
	}, toolBar);


function deleteProducInfos(){
    var sm = productGrid.getSelectionModel();
    var selectData = sm.getSelected();
    var record=sm.getSelections();
    
    if (selectData == null || selectData.length == 0) 
    {
        Ext.Msg.alert("提示", "请选中一行！");
    }
    else 
    {   
        var array = new Array(selectData.length);
        for(var i=0;i<selectData.length;i++)
        {
            array[i] = selectData[i].get('ProductId');
        }
        Ext.Ajax.request({
        url: 'frmSysDicsInfo.aspx?method=deleteProductInfos',
            params: {
            ProductId: array.join('-')//传入多想的id串
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

/*------结束已配置产品列表 end---------------*/
/*-------------客户存货分类配置详细信息 start -------*/
var productWin = null;
function cfgProductWin(){
    var sm = CustomerGrid.getSelectionModel();
    var selectData =  sm.getSelected();

    if(selectData == null){
        Ext.Msg.alert("提示","请选中一行！");
    }
    else
    {
        //弹出一个window窗口
        if( productWin == null){
            productWin = new Ext.Window({
                 title:'客户存货类别商品配置详细信息',
                 id:'cfgWin',
                 width:750 ,
                 height:500, 
                 constrain:true,
                 layout: 'border', 
                 plain: true, 
                 modal: true,
                 closeAction: 'hide',
                 autoDestroy :true,
                 resizable:true,
                 items: [tree,productGrid] ,
                 buttons: [
                    {
                        text: "关闭"
                        , handler: function() {
                            productWin.hide();
                        }
                        , scope: this
                    }]
            });
            productWin.addListener("hide",function(){
	                productGrid.getStore().removeAll();
            });
        }
        
        productWin.show();
        tree.getLoader().baseParams.CustomerId = strCustomerId;
        tree.root.reload();
    }
}

/*-------------客户存货分配配置详细信息 end -------*/
/*------开始查询form的函数 start---------------*/
var MnemonicNoPanel = new Ext.form.TextField({
    style: 'margin-left:0px',
    cls: 'key',
    xtype: 'textfield',
    fieldLabel: '助记码',
    anchor: '90%',
    listeners: { specialkey: function(f, e) { if (e.getKey() == e.ENTER) { Ext.getCmp('ProductName').focus(); } } }

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

                    productNoneGridData.baseParams.MnemonicNo = MnemonicNo;
                    productNoneGridData.baseParams.ProductName = ProductName;
                    productNoneGridData.baseParams.CustomerId = strCustomerId;
                    productNoneGridData.baseParams.BuyClassId = currentNodeId;
                    productNoneGridData.load({
                        params: {
                            start: 0
                        }
                    });
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
        url:"frmCrmCustClassProduct.aspx?method=getNonProducts",
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
	            {name:'Unit'},
	            {name:'SalePrice'},
	            {name:'SalePriceLower'},
	            {name:'SalePriceLimit'},
	            {name:'TaxWhPrice'},
	            {name:'TaxRate'},
	            {name:'Tax'},
	            {name:'SalesTax'},
	            {name:'UnitConvertRate'},
	            {name:'AutoFreight'},
	            {name:'DriverFreight'},
	            {name:'TrainFreight'},
	            {name:'ShipFreight'},
	            {name:'OtherFeight'},
	            {name:'Supplier'},
	            {name:'Origin'},
	            {name:'AliasPrice'},
	            {name:'IsPlan'},
	            {name:'ProductType'},
	            {name:'ProductVer'},
	            { name:'Remark'},
	            {name:'CreateDate'},
	            {name:'UpdateDate'},
	            {name:'OperId'},
	            {name:'OrgId'}
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
			dataIndex:'ProductId',
			id:'ProductId',
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
			dataIndex:'Specifications',
			id:'Specifications'
		},
		{
			header:'计量单位',
			dataIndex:'Unit',
			id:'Unit'
		},
		{
			header:'销售单价',
			dataIndex:'SalePrice',
			id:'SalePrice'
		},
		{
			header:'产地',
			dataIndex:'Origin',
			id:'Origin'
		}		]),
		bbar: new Ext.PagingToolbar({
			pageSize: 10,
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

/*------结束已配置产品列表 end---------------*/
/*-------------客户存货分类配置增加 start -------*/
var productNonWin = null;
function openNonSelectWindowShow(){
    var sm = productNonGrid.getSelectionModel();
    var selectData =  sm.getSelected();
    if(selectData != null){
        Ext.Msg.alert("提示","请选中一行！");
    }
    else
    {
        //弹出一个window窗口
        if( productNonWin == null){
            productNonWin = new Ext.Window({
                 title:'客户存货类别商品增加',
                 id:'cfgNonWin',
                 width:600 ,
                 height:400, 
                 constrain:true,
                 plain: true, 
                 modal: true,
                 closeAction: 'hide',
                 autoDestroy :true,
                 resizable:true,
                 items: [productSerchform,productNonGrid],
                 buttons: [
                    {
                        text: "保存"
                        , handler: function() {
                            var sm = productNonGrid.getSelectionModel();
                            var selectData = sm.getSelected();
                            var record=sm.getSelections();

                            if (selectData == null || selectData.length == 0) 
                            {
                                Ext.Msg.alert("提示", "请选中一行！");
                            }
                            else 
                            {   
                                var array = new Array(selectData.length);
                                for(var i=0;i<selectData.length;i++)
                                {
                                    array[i] = selectData[i].get('ProductId');
                                }
                                Ext.Ajax.request({
                                url: 'frmCrmCustClassProduct.aspx?method=saveProductInfos',
                                    params: {
                                    ProductId: array.join('-')//传入多想的id串
                                    },
                                    success: function(resp, opts) {
                                        //var data=Ext.util.JSON.decode(resp.responseText);
                                        Ext.Msg.alert("提示", "保存成功！");
                                        //重新取数据
                                        productGridData.reload({
                                            params:{
                                             CustomerId:strCustomerId,
                                             BuyClassId:currentNodeId
                                             }
                                        });
                                        productNonWin.hide();
                                    },
                                    failure: function(resp, opts) {
                                        Ext.Msg.alert("提示", "保存失败！");
                                    }
                                });
                            }
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
        }
     
        productNonWin.show();
    }
}

/*-------------客户存货分类配置增加 end -------*/


})
</script>
</html>
