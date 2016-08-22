<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmPmsStockOrderInList.aspx.cs" Inherits="PMS_frmPmsStockOrder" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html>
<head>
<title>生产出入库登记</title><meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<link rel="stylesheet" type="text/css" href="../ext3/resources/css/ext-all.css" />
<script type="text/javascript" src="../ext3/adapter/ext/ext-base.js"></script>
<script type="text/javascript" src="../ext3/ext-all.js"></script>
</head>
<body>
<div id='toolbar'></div>
<div id='divForm'></div>
<div id='dataGrid'></div>
<%=getComboBoxStore() %>
</body>
<script type="text/javascript">
Ext.BLANK_IMAGE_URL = "../ext3/resources/images/default/s.gif";
Ext.onReady(function(){
var saveType;
/*------实现toolbar的函数 start---------------*/
var Toolbar = new Ext.Toolbar({
	renderTo:"toolbar",
	items:[{
		text:"新增",
		icon:"../Theme/1/images/extjs/customer/add16.gif",
		handler:function(){
		    saveType ='addOrder';
		    openAddOrderWin();
		}
		},'-',{
		text:"编辑",
		icon:"../Theme/1/images/extjs/customer/edit16.gif",
		handler:function(){
		    saveType ='saveOrder';
		    modifyOrderWin();
		}
		},'-',{
		text:"删除",
		icon:"../Theme/1/images/extjs/customer/delete16.gif",
		handler:function(){
		    deleteOrder();
		}
	}, '-', {
                text: "打印",
                icon: "../Theme/1/images/extjs/customer/edit16.gif",
                handler: function() {
                    printOrderById();
                }
            }]
});

/*------结束toolbar的函数 end---------------*/
function getUrl(imageUrl)
            {
                var index = window.location.href.toLowerCase().indexOf('/pms/');
                var tempUrl = window.location.href.substring(0,index);
                return tempUrl+"/"+imageUrl;
            }
function printOrderById()
{
var sm = pmsstockorderGrid.getSelectionModel();
                //多选
                var selectData = sm.getSelections();                
                var array = new Array(selectData.length);
                var orderIds = "";
                for(var i=0;i<selectData.length;i++)
                {
                    if(orderIds.length>0)
                        orderIds+=",";
                    orderIds += selectData[i].get('OrderId');
                }
                //页面提交
                Ext.Ajax.request({
                    url: 'frmPmsStockOrderInList.aspx?method=getprintdata',
//                    url:'frmOrderMst.aspx?method=billdata',
                    method: 'POST',
                    params: {
                        OrderId: orderIds
                    },
                   success: function(resp,opts){ 
                       var printData =  resp.responseText;
                       var printControl =  parent.parent.parent.document.getElementById("topFrame").contentWindow.getPrintControl();
                       printControl.Url =getUrl('xml');
                       printControl.MapUrl = printControl.Url+'/'+printStyleXml;//'/salePrint1.xml';
                       printControl.PrintXml = printData;
                       printControl.ColumnName="OrderId";
                       printControl.OnlyData=printOnlyData;
                       printControl.PageWidth=printPageWidth;
                       printControl.PageHeight =printPageHeight ;
                       printControl.Print();
                       
                   },
		           failure: function(resp,opts){  /* Ext.Msg.alert("提示","保存失败"); */    }
                });
}

/*------开始ToolBar事件函数 start---------------*//*-----新增Order实体类窗体函数----*/
function openAddOrderWin() {
	uploadOrderWindow.show();
}
/*-----编辑Order实体类窗体函数----*/
function modifyOrderWin() {
	var sm = pmsstockorderGrid.getSelectionModel();
	//获取选择的数据信息
	var selectData =  sm.getSelected();
	if(selectData == null){
		Ext.Msg.alert("提示","请选中需要编辑的信息！");
		return;
	}
	uploadOrderWindow.show();
	setFormValue(selectData);
}
/*-----删除Order实体函数----*/
/*删除信息*/
function deleteOrder()
{
	var sm = pmsstockorderGrid.getSelectionModel();
	//获取选择的数据信息
	var selectData =  sm.getSelected();
	//如果没有选择，就提示需要选择数据信息
	if(selectData == null){
		Ext.Msg.alert("提示","请选中需要删除的信息！");
		return;
	}
	//删除前再次提醒是否真的要删除
	Ext.Msg.confirm("提示信息","是否真的要删除选择的信息吗？",function callBack(id){
		//判断是否删除数据
		if(id=="yes")
		{
			//页面提交
			Ext.Ajax.request({
				url:'frmPmsStockOrderInList.aspx?method=deleteOrder',
				method:'POST',
				params:{
					OrderId:selectData.data.OrderId
				},
				success: function(resp,opts){
					Ext.Msg.alert("提示","数据删除成功");
				},
				failure: function(resp,opts){
					Ext.Msg.alert("提示","数据删除失败");
				}
			});
		}
	});
}

//定义下拉框异步调用方法,当前客户可订商品列表
        var dsProductUnits = new Ext.data.Store({
            url: '../scm/frmOrderDtl.aspx?method=getProductUnits',
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
                    var combo = Ext.getCmp('OutStor');
                    combo.setValue(combo.getValue());
                }
            }
        });
        dsProductUnits.load();

        function beforeEdit() {
            var productId = Ext.getCmp('AuxProductId').getValue();
            if (productId != dsProductUnits.baseParams.ProductId) {
                dsProductUnits.baseParams.ProductId = productId;
                dsProductUnits.load();
            }
        }
        
/*------实现FormPanle的函数 start---------------*/
var pmsstockorderform=new Ext.form.FormPanel({
	url:'',
	frame:true,
	title:'',
	labelWidth:55,
	items:[
		{
			xtype:'hidden',
			fieldLabel:'订单号',
			name:'OrderId',
			id:'OrderId',
			hidden:true,
			hideLabel:false
		}
,		{
            layout:'column',
            items:[
            {
                layout:'form',
                columnWidth:.48,
                items:[
                {
                    xtype:'combo',
			        fieldLabel:'车间',
			        anchor:'98%',
			        name:'WsId',
			        id:'WsId',
	                store:dsWs,
	                displayField:'WsName',
                    valueField:'WsId',
                    mode:'local',
                    triggerAction:'all',
                    editable: false
                }
                ]
            },
            {               
                layout:'form',
                columnWidth:.48,
                items:[
                {
                    xtype:'combo',
		            fieldLabel:'仓库',
		            columnWidth:1,
		            anchor:'98%',
		            name:'AuxWhId',
		            id:'AuxWhId',
		            store:dsWarehouseList,
	                displayField:'WhName',
                    valueField:'WhId',
                    mode:'local',
                    triggerAction:'all',
                    editable: false
                }
                ]
            }
            ]			
		}
,		{
            layout:'column',
            items:[
            {
                layout:'form',
                columnWidth:.48,
                items:[
                {
			        xtype:'combo',
			        fieldLabel:'成品',
			        columnWidth:1,
			        anchor:'98%',
			        name:'AuxProductId',
			        id:'AuxProductId',
                    store: dsProductList,
                    displayField: 'ProductName',
                    valueField: 'ProductId',
                    triggerAction: 'all',
                    typeAhead: true,
                    mode: 'local',
                    emptyText: '',
                    selectOnFocus: false,
                    editable: true,
                    listeners: {
                        "select": beforeEdit
                    }
			        
			    }
			    ]
			},
			{
			    layout:'form',
                columnWidth:.28,
                items:[
                {
                    xtype:'numberfield',
			        fieldLabel:'数量',
			        columnWidth:1,
			        anchor:'98%',
			        name:'Qty',
			        id:'Qty'
			    }
			    ]
			}, {
			    layout: 'form',
			    columnWidth: .2,
			    items: [
                {
                    xtype: 'combo',
                    store: dsProductUnits, //dsWareHouse,
                    valueField: 'UnitId',
                    displayField: 'UnitName',
                    mode: 'local',
                    forceSelection: true,
                    editable: false,
                    name: 'OutStor',
                    id: 'OutStor',
                    emptyValue: '',
                    triggerAction: 'all',
                    //fieldLabel: '单位',
                    hideLabel:true,
                    selectOnFocus: true,
                    anchor: '98%'
                }
			    ]
}]
		}
,		{
            layout:'column',
            items:[
            {
                layout:'form',
                columnWidth:.3,
                items:[
                {
			        xtype:'combo',
			        fieldLabel:'操作类型',
			        columnWidth:1,
			        anchor:'95%',
			        name:'IsOutOrder',
			        id:'IsOutOrder',
                    store: dsStatus,
                    displayField: 'DicsName',
                    valueField: 'DicsCode',
                    triggerAction: 'all',
                    typeAhead: true,
                    mode: 'local',
                    emptyText: '',
                    selectOnFocus: false,                    
                    value:dsStatus.getAt(0).data.DicsCode,
                    disabled: true
			    }]
			},
			{
			    layout:'form',
                columnWidth:.685,
                items:[
                {
			        xtype:'textfield',
			        fieldLabel:'原始单号',
			        columnWidth:1,
			        anchor:'95%',
			        name:'InitOrderId',
			        id:'InitOrderId'
			    }]
			}
			]
		}
,		{
			xtype:'textarea',
			fieldLabel:'备注',
			columnWidth:1,
			anchor:'95%',
			name:'Remark',
			id:'Remark'
		}
]
});
/*------FormPanle的函数结束 End---------------*/

/*------开始界面数据的窗体 Start---------------*/
if(typeof(uploadOrderWindow)=="undefined"){//解决创建2个windows问题
	uploadOrderWindow = new Ext.Window({
		id:'Orderformwindow',
		title:''
		, iconCls: 'upload-win'
		, width: 600
		, height: 250
		, layout: 'fit'
		, plain: true
		, modal: true
		, constrain:true
		, resizable: false
		, closeAction: 'hide'
		,autoDestroy :true
		,items:pmsstockorderform
		,buttons: [{
			text: "保存"
			, handler: function() {
				saveUserData();
			}
			, scope: this
		},
		{
			text: "取消"
			, handler: function() { 
				uploadOrderWindow.hide();
			}
			, scope: this
		}]});
	}
	uploadOrderWindow.addListener("hide",function(){
	    pmsstockorderform.getForm().reset();
});

/*------开始获取界面数据的函数 start---------------*/
function saveUserData()
{

	Ext.Ajax.request({
		url:'frmPmsStockOrderInList.aspx?method='+saveType,
		method:'POST',
		params:{
			OrderId:Ext.getCmp('OrderId').getValue(),
			WsId:Ext.getCmp('WsId').getValue(),
			AuxWhId:Ext.getCmp('AuxWhId').getValue(),
			AuxProductId:Ext.getCmp('AuxProductId').getValue(),
			Qty:Ext.getCmp('Qty').getValue(),
			InitOrderId:Ext.getCmp('InitOrderId').getValue(),
			IsOutOrder:Ext.getCmp('IsOutOrder').getValue(),
			Remark:Ext.getCmp('Remark').getValue(),
			UnitId:Ext.getCmp('OutStor').getValue()
				},
		success: function(resp,opts){
			Ext.Msg.alert("提示","保存成功");
		},
		failure: function(resp,opts){
			Ext.Msg.alert("提示","保存失败");
		}
		});
		}
/*------结束获取界面数据的函数 End---------------*/

/*------开始界面数据的函数 Start---------------*/
function setFormValue(selectData)
{
	Ext.Ajax.request({
		url:'frmPmsStockOrderInList.aspx?method=getorder',
		params:{
			OrderId:selectData.data.OrderId
		},
	success: function(resp,opts){
		var data=Ext.util.JSON.decode(resp.responseText);
		Ext.getCmp("OrderId").setValue(data.OrderId);
		Ext.getCmp("WsId").setValue(data.WsId);
		Ext.getCmp("AuxWhId").setValue(data.AuxWhId);
		Ext.getCmp("AuxProductId").setValue(data.AuxProductId);
		beforeEdit();
		Ext.getCmp("Qty").setValue(data.Qty);
		Ext.getCmp("InitOrderId").setValue(data.InitOrderId);
		Ext.getCmp("IsOutOrder").setValue(data.IsOutOrder);
		Ext.getCmp("Remark").setValue(data.Remark);
		Ext.getCmp("OutStor").setValue(data.UnitId);
	},
	failure: function(resp,opts){
		Ext.Msg.alert("提示","获取用户信息失败");
	}
	});
}
/*------结束设置界面数据的函数 End---------------*/
/*------开始查询form end---------------*/
//车间名称
var WsNamePanel = new Ext.form.ComboBox({
    xtype:'combo',
    fieldLabel:'车间',
    anchor:'95%',
	store:dsWs,
	displayField:'WsName',
    valueField:'WsId',
    mode:'local',
    triggerAction:'all',
    editable: false
});

//原始单据编号
var iniOrderIdPanel = new Ext.form.TextField({
    xtype:'textfield',
    fieldLabel:'原始单据编号',
    anchor:'95%'
});
//仓库
var ckCombo = new Ext.form.ComboBox({
    xtype:'combo',
    fieldLabel:'仓库',
    anchor:'95%',
    store:dsWarehouseList,
    displayField:'WhName',
    valueField:'WhId',
    mode:'local',
    triggerAction:'all',
    editable: false
});

//成品
var productCombo = new Ext.form.ComboBox({
    xtype:'combo',
    fieldLabel:'成品',
    anchor:'95%',
    store: dsProductList,
    displayField: 'ProductName',
    valueField: 'ProductId',
    triggerAction: 'all',
    typeAhead: true,
    mode: 'local',
    emptyText: '',
    selectOnFocus: false,
    editable: true
});

var serchform = new Ext.FormPanel({
    el:'divForm',
    id:'serchform',
    labelAlign: 'left',
    buttonAlign: 'right',
    bodyStyle: 'padding:5px',
    frame: true,    
    items: [{
        layout: 'column',   //定义该元素为布局为列布局方式
        border: false,
        items: [{
            columnWidth: .4,  //该列占用的宽度，标识为20％
            layout: 'form',
            border: false,
            labelWidth: 55,
            items: [
                WsNamePanel
            ]
        }, {
            columnWidth: .4,
            layout: 'form',
            border: false,
            labelWidth: 80,
            items: [
                iniOrderIdPanel
                ]
        }]
    },
    {
        layout: 'column',   //定义该元素为布局为列布局方式
        border: false,
        items: [{
            name: 'cusStyle',
            columnWidth: .4,
            layout: 'form',
            border: false,
            labelWidth: 55,
            items: [
                ckCombo
            ]
        },{
            name: 'cusStyle',
            columnWidth: .4,
            layout: 'form',
            border: false,
            labelWidth: 80,
            items: [
                productCombo
            ]
        }, {            
            layout: 'form',
            columnWidth: .2,
            border: false,
            items: [{ cls: 'key',
                xtype: 'button',
                text: '查询',
                anchor: '50%',
                handler :function(){
                
                var strWsId=WsNamePanel.getValue();
                var striniOrderId=iniOrderIdPanel.getValue();
                var WhId=ckCombo.getValue();
                var ProductId=productCombo.getValue();
                
                dspmsstockorder.baseParams.WorkshopId=strWsId;
                dspmsstockorder.baseParams.IniOrderId=striniOrderId;
                dspmsstockorder.baseParams.WhId=WhId;
                dspmsstockorder.baseParams.ProductId=ProductId;
                dspmsstockorder.baseParams.IsOutOrder='in';
                
                dspmsstockorder.load({
                            params : {
                            start : 0,
                            limit : 10
                            } });
                }
            }]
        }]
    }]
});
serchform.render();
/*------开始查询form end---------------*/
/*------开始获取数据的函数 start---------------*/
var dspmsstockorder = new Ext.data.Store
({
url: 'frmPmsStockOrderInList.aspx?method=getOrderList',
reader:new Ext.data.JsonReader({
	totalProperty:'totalProperty',
	root:'root'
},[
	{		name:'OrderId'	},
	{		name:'OrgId'	},
	{		name:'WsId'	},
	{		name:'AuxWhId'	},
	{		name:'AuxProductId'	},
	{		name:'Qty'	},
	{		name:'InitOrderId'	},
	{		name:'IsOutOrder'	},
	{		name:'CreateDate'	},
	{		name:'UpdateDate'	},
	{		name:'OperId'	},
	{		name:'OwnerId'	},
	{		name:'Remark'
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
var pmsstockorderGrid = new Ext.grid.GridPanel({
	el: 'dataGrid',
	width:'100%',
	height:'100%',
	autoWidth:true,
	autoHeight:true,
	autoScroll:true,
	layout: 'fit',
	id: '',
	store: dspmsstockorder,
	loadMask: {msg:'正在加载数据，请稍侯……'},
	sm:sm,
	cm: new Ext.grid.ColumnModel([
		sm,
		new Ext.grid.RowNumberer(),//自动行号
		{
			header:'订单号',
			dataIndex:'OrderId',
			id:'OrderId',
			hidden:true,
			hideable:false
		},
		{
			header:'车间',
			dataIndex:'WsId',
			id:'WsId',
			renderer:function(val){
			    dsWs.each(function(r) {
		            if (val == r.data['WsId']) {
		                val = r.data['WsName'];
		                return;
		            }
		        });
		        return val;
			}
		},
		{
			header:'仓库',
			dataIndex:'AuxWhId',
			id:'AuxWhId',
			renderer:function(val){
			    dsWarehouseList.each(function(r) {
		            if (val == r.data['WhId']) {
		                val = r.data['WhName'];
		                return;
		            }
		        });
		        return val;
			}	
		},
		{
			header:'成品',
			dataIndex:'AuxProductId',
			id:'AuxProductId',
			renderer:function(val){
			    dsProductList.each(function(r) {
		            if (val == r.data['ProductId']) {
		                val = r.data['ProductName'];
		                return;
		            }
		        });
		        return val;
			}	
		},
		{
			header:'数量',
			dataIndex:'Qty',
			id:'Qty'
		},
		{
			header:'原始单号',
			dataIndex:'InitOrderId',
			id:'InitOrderId'
		},
		{
			header:'操作类型',
			dataIndex:'IsOutOrder',
			id:'IsOutOrder',
			renderer:function(val){
			    dsStatus.each(function(r) {
		            if (val == r.data['DicsCode']) {
		                val = r.data['DicsName'];
		                return;
		            }
		        });
		        return val;
			}			
		},
		{
			header:'创建时间',
			dataIndex:'CreateDate',
			id:'CreateDate'
		}
		]),
		bbar: new Ext.PagingToolbar({
			pageSize: 10,
			store: dspmsstockorder,
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
pmsstockorderGrid.render();
/*------DataGrid的函数结束 End---------------*/



})
</script>

</html>
