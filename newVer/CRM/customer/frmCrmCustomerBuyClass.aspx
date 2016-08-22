<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmCrmCustomerBuyClass.aspx.cs" Inherits="CRM_customer_frmCrmCustomerBuyClass" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html>
<head>
<title>客户可订购分类</title><meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<link rel="stylesheet" type="text/css" href="../../ext3/resources/css/ext-all.css" />
<script type="text/javascript" src="../../ext3/adapter/ext/ext-base.js"></script>
<script type="text/javascript" src="../../ext3/ext-all.js"></script>
<script type="text/javascript" src="../../ext3/src/locale/ext-lang-zh_CN.js"></script>
</head>
<body>
<div id='toolbar'></div>
<div id='searchForm'></div>
<div id='classGrid'></div>
</body>
<script type="text/javascript">
Ext.BLANK_IMAGE_URL = "../../ext3/resources/images/default/s.gif";
var BuyClassId =0;
Ext.onReady(function(){
/*------实现toolbar的函数 start---------------*/
var saveType;
var Toolbar = new Ext.Toolbar({
	renderTo:"toolbar",
	items:[{
		text:"新增",
		icon:"../../Theme/1/images/extjs/customer/add16.gif",
		handler:function(){
		    saveType = "add";
		    openAddClassWin();
		}
		},'-',{
		text:"编辑",
		icon:"../../Theme/1/images/extjs/customer/edit16.gif",
		handler:function(){
		    saveType = "save";
		    modifyClassWin();
		}
		},'-',{
		text:"删除",
		icon:"../../Theme/1/images/extjs/customer/delete16.gif",
		handler:function(){
		    deleteClass();
		}
		},'-',{
		text:"类别下商品配置",
		icon:"../../Theme/1/images/extjs/customer/edit16.gif",
		handler:function(){
		    configClassProduct();
		}
	}]
});

/*------结束toolbar的函数 end---------------*/

/*------开始ToolBar事件函数 start---------------*//*-----新增Class实体类窗体函数----*/
function openAddClassWin() {
	buyClassForm.getForm().reset();
	Ext.getCmp("CreateDate").setValue(new Date().clearTime());
	Ext.getCmp("UpdateDate").setValue(new Date().clearTime());
	uploadClassWindow.show();
}
/*-----编辑Class实体类窗体函数----*/
function modifyClassWin() {
	var sm = gridData.getSelectionModel();
	//获取选择的数据信息
	//var selectData =  sm.getSelected();
	var selectData =  sm.getSelections();
	if(selectData == null||selectData.length == 0){
		Ext.Msg.alert("提示","请选中需要编辑的信息！");
		return;
	}
	uploadClassWindow.show();
	var selectData =  sm.getSelected();
	
	Ext.Ajax.request({
	    url:'frmCrmCustomerBuyClass.aspx?method=getClasseInfo',
	    params:{
		    BuyClassId:selectData.data.BuyClassId
	    },
	    success: function(resp,opts){
	        //alert(resp.responseText);
		    var data=Ext.util.JSON.decode(resp.responseText);
		    Ext.getCmp('BuyClassId').setValue(data.BuyClassId);
		    Ext.getCmp('BuyClassNo').setValue(data.BuyClassNo);
		    Ext.getCmp('BuyClassName').setValue(data.BuyClassName);
		    
		    Ext.getCmp('Remark').setValue(data.Remark);
		    Ext.getCmp('CreateDate').setValue((new Date(data.CreateDate.replace(/-/g,"/"))).clearTime());
		    Ext.getCmp('UpdateDate').setValue((new Date()).clearTime());
	    },
	    failure: function(resp,opts){
		    Ext.Msg.alert("提示","加载失败");
	    }
	});
}
/*-----删除Class实体函数----*/
/*删除信息*/
function deleteClass()
{
	var sm = gridData.getSelectionModel();
	//获取选择的数据信息
	//var selectData =  sm.getSelected();
	var selectData =  sm.getSelections();
	//如果没有选择，就提示需要选择数据信息
	if(selectData == null||selectData.length==0){
		Ext.Msg.alert("提示","请选中需要删除的信息！");
		return;
	}
	//删除前再次提醒是否真的要删除
	Ext.Msg.confirm("提示信息","是否真的要删除选择的存货分类信息吗？",function callBack(id){
		//判断是否删除数据
		if(id=="yes")
		{
		    var array = new Array(selectData.length);
            for(var i=0;i<selectData.length;i++)
            {
                array[i] = selectData[i].get('BuyClassId');
            }
			//页面提交
			Ext.Ajax.request({
				url:'frmCrmCustomerBuyClass.aspx?method=deleteClasses',
				method:'POST',
				params:{
					BuyClassId:array.join('-')//传入多项的id串
				},
				success: function(resp,opts){
				    for(var i=0;i<selectData.length;i++)
                    {
                        gridData.getStore().remove(selectData[i]);
                    }
					Ext.Msg.alert("提示","数据删除成功");
				},
				failure: function(resp,opts){
					Ext.Msg.alert("提示","数据删除失败");
				}
			});
		}
	});
}
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

                    productNoneGridData.baseParams.MnemonicNo=MnemonicNo;
                    productNoneGridData.baseParams.ProductName=ProductName;
                    productNoneGridData.baseParams.BuyClassId=BuyClassId;
                    productNoneGridData.load({
                        params: {
                            start: 0,
                            limit: 10
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
        url:"frmCrmCustomerBuyClass.aspx?method=getNonProducts",
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
var productWin = null;
function configClassProduct(){
var sm = gridData.getSelectionModel();
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
                 items: productGrid ,
                 buttons: [
                    {
                        text: "关闭"
                        , handler: function() {
                            productWin.hide();
                        }
                        , scope: this
                    }]
            });
        }
        
        productWin.show();
        
        //load      
        productGridData.baseParams.BuyClassId=BuyClassId;
        productGridData.reload({
            params:{
             limit:10,
             start:0
             }
        });
    }
}
//弹出一个window窗口
var productNonWin;
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
                        var array = new Array(record.length);
                        for(var i=0;i<record.length;i++)
                        {
                            array[i] = record[i].get('ProductId');
                        }
                        Ext.Ajax.request({
                        url: 'frmCrmCustomerBuyClass.aspx?method=saveProductInfos',
                            params: {
                                BuyClassId:BuyClassId,
                                ProductId: array.join('-')//传入多想的id串
                            },
                            success: function(resp, opts) {
                                //var data=Ext.util.JSON.decode(resp.responseText);
                                Ext.Msg.alert("提示", "保存成功！");
                                //重新取数据
                                productGridData.baseParams.BuyClassId=BuyClassId;
                                productGridData.reload({
                                    params:{
                                     limit:10,
                                     start:0
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
function openNonSelectWindowShow(){
    var sm = gridData.getSelectionModel();
    var selectData =  sm.getSelected();
    if(selectData == null){
        Ext.Msg.alert("提示","请选中一行！");
    }
    else
    {
        productNonWin.show();
    }
}
productNonWin.addListener("hide",function(){
   productNoneGridData.removeAll();
});
/*------实现FormPanle的函数 start---------------*/
var buyClassForm=new Ext.form.FormPanel({
	url:'frmCrmCustomerBuyClass.aspx',
	reader: new Ext.data.JsonReader(
	    {root:'list'},
        [
            {name: 'BuyClassId',mapping:'BuyClassId',type:'string'},
            {name: 'BuyClassNo',mapping:'BuyClassNo',type:'string'},
            {name: 'BuyClassName',mapping:'BuyClassName',type:'string'},
            {name: 'Remark',mapping:'Remark',type:'string'},
            {name: 'CreateDate',mapping:'CreateDate',type:'date', dateFormat:'Y年m月d日'},
            {name: 'UpdateDate',mapping:'UpdateDate',type:'date',dateFormat:'Y年m月d日'},
            //{name: 'OperId',mapping:'OperId',type:'int'},
            //{name: 'OrgId',mapping:'OrgId',type:'int'}
        ]),
	//renderTo:'divForm'
    bodyStyle: 'padding:5px',
    frame: true,   
    labelWidth:60, 
    waitMsgTarget : true,
	items:[
		{
			xtype:'textfield',
			fieldLabel:'可购分类ID',
			name:'BuyClassId',
			id:'BuyClassId',
			hidden:true,
			hideLabel:true
		}
,		{
			xtype:'textfield',
			fieldLabel:'分类编码',
			columnWidth:1,
			anchor:'95%',
			name:'BuyClassNo',
			id:'BuyClassNo'
		}
,		{
			xtype:'textfield',
			fieldLabel:'分类名称',
			columnWidth:1,
			anchor:'95%',
			name:'BuyClassName',
			id:'BuyClassName'
		}
,		{
			xtype:'textarea',
			fieldLabel:'备注',
			columnWidth:1,
			anchor:'95%',
			name:'Remark',
			id:'Remark'
		}
,		{
			xtype:'datefield',
			fieldLabel:'创建日期',
			columnWidth:1,
			anchor:'60%',
			name:'CreateDate',
			id:'CreateDate',
			disabled:true,
			format:'Y年m月d日'
		}
,		{
			xtype:'datefield',
			fieldLabel:'更新日期',
			columnWidth:1,
			anchor:'60%',
			name:'UpdateDate',
			id:'UpdateDate',
			disabled:true,
			format:'Y年m月d日'
		}
]
});
/*------FormPanle的函数结束 End---------------*/

/*------开始界面数据的窗体 Start---------------*/
if(typeof(uploadClassWindow)=="undefined"){//解决创建2个windows问题
	uploadClassWindow = new Ext.Window({
		id:'Classformwindow',
		title:'客户可订购分类维护'
		, iconCls: 'upload-win'
		, width: 450
		, height: 300
		, layout: 'fit'
		, plain: true
		, modal: true
		, constrain:true
		, resizable: false
		, closeAction: 'hide'
		,autoDestroy :true
		,items:buyClassForm
		,buttons: [{
			text: "保存"
			, handler: function() {
				if (buyClassForm.getForm().isValid()) {
				    if(saveType=="add")
                            saveType = "addClassInfo";
                        else if(saveType == "save")
                            saveType = "saveClassInfo";
                            
                    buyClassForm.getForm().submit( {
                        url : 'frmCrmCustomerBuyClass.aspx?method='+saveType,
                        success : function(from, action) {
                            Ext.Msg.alert('保存成功', '添加存货分类成功！');
                            var BuyClassName = classNamePanel.getValue();
                            gridDataData.load({
                                params: {
                                    start: 0,
                                    limit: 10,
                                    BuyClassName: BuyClassName
                                }
                            });
                        },
                        failure : function(form, action) {
                            Ext.Msg.alert('保存失败', '添加存货分类失败！');
                        }
                        
                    });
                    uploadClassWindow.hide();
                } else {
                    Ext.Msg.alert('信息', '请填写完成再提交!');
                }
			}
			, scope: this
		},
		{
			text: "取消"
			, handler: function() { 
				uploadClassWindow.hide();
			}
			, scope: this
		}]});
	}
	uploadClassWindow.addListener("hide",function(){
});


/*------开始查询form的函数 start---------------*/
var classNamePanel = new Ext.form.TextField({
    style: 'margin-left:0px',
    cls: 'key',
    xtype: 'textfield',
    fieldLabel: '分类名称',
    anchor: '90%',
    listeners: { specialkey: function(f, e) { if (e.getKey() == e.ENTER) { Ext.getCmp('searchebtnId').focus(); } } }
});

var searchForm = new Ext.FormPanel({
    renderTo:'searchForm',
    labelAlign: 'left',
    layout: 'fit',
    buttonAlign: 'right',
    bodyStyle: 'padding:5px',
    frame: true,
    height:45,
    labelWidth: 55,
    items: [{
        layout: 'column',   //定义该元素为布局为列布局方式
        border: false,
        items: [ {
            columnWidth: .3,
            layout: 'form',
            border: false,
            items: [
                classNamePanel
                ]
        }, {
            columnWidth: .2,
            layout: 'form',
            border: false,
            items: [{ cls: 'key',
                xtype: 'button',
                text: '模糊查询',
                id: 'searchebtnId',
                anchor: '50%',
                handler: function() {
                    var BuyClassName = classNamePanel.getValue();

                    gridDataData.baseParams.BuyClassName = BuyClassName;
                    gridDataData.load({
                        params: {
                            start: 0,
                            limit: 10
                        }
                    });
                }
            }]
        },{
            columnWidth: .5,  //该列占用的宽度，标识为20％
            layout: 'form',
            border: false
        }
        ]
    }]
});


/*------开始查询form的函数 end---------------*/

/*------开始获取数据的函数 start---------------*/
var gridDataData = new Ext.data.Store
({
url: 'frmCrmCustomerBuyClass.aspx?method=getClassInfoList',
reader:new Ext.data.JsonReader({
	totalProperty:'totalProperty',
	root:'root'
},[
	{
		name:'BuyClassId'
	},
	{
		name:'BuyClassNo'
	},
	{
		name:'BuyClassName'
	},
	{
		name:'Remark'
	},
	{
		name:'CreateDate'
	},
	{
		name:'UpdateDate'
	}
		])
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
	singleSelect:false,
    listeners: {
        rowselect: function(sm, row, rec) {
            BuyClassId = rec.data.BuyClassId;
        }
    }
});
var gridData = new Ext.grid.GridPanel({
	el: 'classGrid',
	width:'100%',
	height:'100%',
	autoWidth:true,
	autoHeight:true,
	autoScroll:true,
	layout: 'fit',
	store: gridDataData,
	loadMask: {msg:'正在加载数据，请稍侯……'},
	sm:sm,
	cm: new Ext.grid.ColumnModel([
		sm,
		new Ext.grid.RowNumberer(),//自动行号
		{
			header:'可购分类ID',
			dataIndex:'BuyClassId',
			id:'BuyClassId',
			hidden:true,
			hideable:true
		},
		{
			header:'分类编码',
			dataIndex:'BuyClassNo',
			id:'BuyClassNo'
		},
		{
			header:'分类名称',
			dataIndex:'BuyClassName',
			id:'BuyClassName'
		},
		{
			header:'备注',
			dataIndex:'Remark',
			id:'Remark'
		},
		{
			header:'创建日期',
			dataIndex:'CreateDate',
			id:'CreateDate',
			renderer: Ext.util.Format.dateRenderer('Y年m月d日')
		},
		{
			header:'更新日期',
			dataIndex:'UpdateDate',
			id:'UpdateDate'
		}		]),
		bbar: new Ext.PagingToolbar({
			pageSize: 10,
			store: gridDataData,
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
gridData.render();
/*------DataGrid的函数结束 End---------------*/
/*------开始已配置产品列表 start---------------*/
var productGridData;
if(productGridData==null){
    productGridData = new Ext.data.Store({
        url:"frmCrmCustomerBuyClass.aspx?method=getProducts",
        reader:new Ext.data.JsonReader({
            totalProperty:'totalProperty',
	        root:'root'},
	        [
	            {name:'BuyClassProductId'},
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
	            {name:'AliasPrice'},
	            {name:'IsPlan'},
	            {name:'ProductType'},
	            {name:'ProductVer'},
	            { name:'Remark'},
	            {name:'CreateDate'},
	            {name:'UpdateDate'},
	            {name:'OperId'},
	            {name:'OrgId'},
	            {name:'OriginText'}
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
			header:'ID',
			dataIndex:'BuyClassProductId',
			id:'BuyClassProductId',
			hidden: true,
            hideable: false
		},
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
		tbar: new Ext.Toolbar({
	        items:[{
		        text:"新增",
		        icon:"../../Theme/1/images/extjs/customer/add16.gif",
		        handler:function(){
                    openNonSelectWindowShow();
		        }
		        },'-',{
		        text:"删除",
		        icon:"../../Theme/1/images/extjs/customer/delete16.gif",
		        handler:function(){
		            deleteProducInfos();
		        }
	        }]
        }),
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
        var array = new Array(record.length);
        for(var i=0;i<record.length;i++)
        {
            array[i] = record[i].get('BuyClassProductId');
        }
        Ext.Ajax.request({
        url: 'frmCrmCustomerBuyClass.aspx?method=deleteProductInfos',
            params: {
                BuyClassId:BuyClassId,
                BuyClassProductId: array.join('-')//传入多想的id串
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
/*-------------客户存货分类配置详细信息 start -------*/


})
</script>

</html>

