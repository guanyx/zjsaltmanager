<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmPmsStockOrderList.aspx.cs" Inherits="PMS_frmPmsStockOrder" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html>
<head>
<title>测试页面</title><meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<link rel="stylesheet" type="text/css" href="../ext3/resources/css/ext-all.css" />
<script type="text/javascript" src="../ext3/adapter/ext/ext-base.js"></script>
<script type="text/javascript" src="../ext3/ext-all.js"></script>
<script type="text/javascript" src="../ext3/src/locale/ext-lang-zh_CN.js"></script>
</head>
<body>
<div id='toolbar'></div>
<div id='divForm'></div>
<div id='dataGrid'></div>

</body>
<%=getComboBox() %>
<script type="text/javascript">
Ext.onReady(function(){
var saveType;
/*------实现toolbar的函数 start---------------*/
var Toolbar = new Ext.Toolbar({
	renderTo:"toolbar",
	items:[{
		text:"新增",
		icon:"../Theme/1/images/extjs/customer/add16.gif",
		handler:function(){
		    saveType ='';
		    openAddOrderWin();
		}
		},'-',{
		text:"编辑",
		icon:"../Theme/1/images/extjs/customer/edit16.gif",
		handler:function(){
		    saveType ='';
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
var sm = pmswsrecordGrid.getSelectionModel();
                //多选
                var selectData = sm.getSelections();                
                var array = new Array(selectData.length);
                var orderIds = "";
                for(var i=0;i<selectData.length;i++)
                {
                    if(orderIds.length>0)
                        orderIds+=",";
                    orderIds += selectData[i].get('RecodrId');
                }
                //页面提交
                Ext.Ajax.request({
                    url: 'frmPmsWsRecordList.aspx?method=getprintdata',
//                    url:'frmOrderMst.aspx?method=billdata',
                    method: 'POST',
                    params: {
                        RecordId: orderIds
                    },
                   success: function(resp,opts){ 
                       var printData =  resp.responseText;
                       var printControl =  parent.parent.parent.document.getElementById("topFrame").contentWindow.getPrintControl();
                       printControl.Url =getUrl('xml');
                       printControl.MapUrl = printControl.Url+'/'+printStyleXml;//'/salePrint1.xml';
                       printControl.PrintXml = printData;
                       printControl.ColumnName="RecordId";
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
	var sm = EpmsstockorderGrid.getSelectionModel();
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
				url:'frmPmsStockOrderList.aspx?method=deleteOrder',
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

/*------实现FormPanle的函数 start---------------*/
var pmsstockorderform=new Ext.form.FormPanel({
	url:'',
	frame:true,
	title:'',
	items:[
		{
			xtype:'textfield',
			fieldLabel:'订单号',
			columnWidth:1,
			anchor:'90%',
			name:'OrderId',
			id:'OrderId'
		}
,		{
			xtype:'textfield',
			fieldLabel:'组织标识',
			columnWidth:1,
			anchor:'90%',
			name:'OrgId',
			id:'OrgId'
		}
,		{
			xtype:'textfield',
			fieldLabel:'车间标识',
			columnWidth:1,
			anchor:'90%',
			name:'WsId',
			id:'WsId'
		}
,		{
			xtype:'textfield',
			fieldLabel:'辅料仓库标识',
			columnWidth:1,
			anchor:'90%',
			name:'AuxWhId',
			id:'AuxWhId'
		}
,		{
			xtype:'textfield',
			fieldLabel:'辅料标识',
			columnWidth:1,
			anchor:'90%',
			name:'AuxProductId',
			id:'AuxProductId'
		}
,		{
			xtype:'textfield',
			fieldLabel:'数量',
			columnWidth:1,
			anchor:'90%',
			name:'Qty',
			id:'Qty'
		}
,		{
			xtype:'textfield',
			fieldLabel:'原始单号',
			columnWidth:1,
			anchor:'90%',
			name:'InitOrderId',
			id:'InitOrderId'
		}
,		{
			xtype:'textfield',
			fieldLabel:'是否出库',
			columnWidth:1,
			anchor:'90%',
			name:'IsOutOrder',
			id:'IsOutOrder'
		}
,		{
			xtype:'textfield',
			fieldLabel:'创建时间',
			columnWidth:1,
			anchor:'90%',
			name:'CreateDate',
			id:'CreateDate'
		}
,		{
			xtype:'textfield',
			fieldLabel:'更新时间',
			columnWidth:1,
			anchor:'90%',
			name:'UpdateDate',
			id:'UpdateDate'
		}
,		{
			xtype:'textfield',
			fieldLabel:'操作者标识',
			columnWidth:1,
			anchor:'90%',
			name:'OperId',
			id:'OperId'
		}
,		{
			xtype:'textfield',
			fieldLabel:'所有者标识',
			columnWidth:1,
			anchor:'90%',
			name:'OwnerId',
			id:'OwnerId'
		}
,		{
			xtype:'textfield',
			fieldLabel:'备注',
			columnWidth:1,
			anchor:'90%',
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
		, height: 300
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
	    pmsstockorderform.getFomr().reset();
});

/*------开始获取界面数据的函数 start---------------*/
function saveUserData()
{

	Ext.Ajax.request({
		url:'frmPmsStockOrderList.aspx?method=deleteOrder',
		method:'POST',
		params:{
			OrderId:Ext.getCmp('OrderId').getValue(),
			OrgId:Ext.getCmp('OrgId').getValue(),
			WsId:Ext.getCmp('WsId').getValue(),
			AuxWhId:Ext.getCmp('AuxWhId').getValue(),
			AuxProductId:Ext.getCmp('AuxProductId').getValue(),
			Qty:Ext.getCmp('Qty').getValue(),
			InitOrderId:Ext.getCmp('InitOrderId').getValue(),
			IsOutOrder:Ext.getCmp('IsOutOrder').getValue(),
			CreateDate:Ext.getCmp('CreateDate').getValue(),
			UpdateDate:Ext.getCmp('UpdateDate').getValue(),
			OperId:Ext.getCmp('OperId').getValue(),
			OwnerId:Ext.getCmp('OwnerId').getValue(),
			Remark:Ext.getCmp('Remark').getValue()		},
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
		url:'frmPmsStockOrderList.aspx?method=getorder',
		params:{
			OrderId:selectData.data.OrderId
		},
	success: function(resp,opts){
		var data=Ext.util.JSON.decode(resp.responseText);
		Ext.getCmp("OrderId").setValue(data.OrderId);
		Ext.getCmp("OrgId").setValue(data.OrgId);
		Ext.getCmp("WsId").setValue(data.WsId);
		Ext.getCmp("AuxWhId").setValue(data.AuxWhId);
		Ext.getCmp("AuxProductId").setValue(data.AuxProductId);
		Ext.getCmp("Qty").setValue(data.Qty);
		Ext.getCmp("InitOrderId").setValue(data.InitOrderId);
		Ext.getCmp("IsOutOrder").setValue(data.IsOutOrder);
		Ext.getCmp("CreateDate").setValue(data.CreateDate);
		Ext.getCmp("UpdateDate").setValue(data.UpdateDate);
		Ext.getCmp("OperId").setValue(data.OperId);
		Ext.getCmp("OwnerId").setValue(data.OwnerId);
		Ext.getCmp("Remark").setValue(data.Remark);
	},
	failure: function(resp,opts){
		Ext.Msg.alert("提示","获取用户信息失败");
	}
	});
}
/*------结束设置界面数据的函数 End---------------*/

/*------开始获取数据的函数 start---------------*/
var dspmsstockorder = new Ext.data.Store
({
url: 'frmPmsStockOrderList.aspx?method=getOrderList',
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
			id:'OrderId'
		},
		{
			header:'组织标识',
			dataIndex:'OrgId',
			id:'OrgId'
		},
		{
			header:'车间标识',
			dataIndex:'WsId',
			id:'WsId'
		},
		{
			header:'辅料仓库标识',
			dataIndex:'AuxWhId',
			id:'AuxWhId'
		},
		{
			header:'辅料标识',
			dataIndex:'AuxProductId',
			id:'AuxProductId'
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
			header:'是否出库',
			dataIndex:'IsOutOrder',
			id:'IsOutOrder'
		},
		{
			header:'创建时间',
			dataIndex:'CreateDate',
			id:'CreateDate'
		},
		{
			header:'更新时间',
			dataIndex:'UpdateDate',
			id:'UpdateDate'
		},
		{
			header:'操作者标识',
			dataIndex:'OperId',
			id:'OperId'
		},
		{
			header:'所有者标识',
			dataIndex:'OwnerId',
			id:'OwnerId'
		},
		{
			header:'备注',
			dataIndex:'Remark',
			id:'Remark'
		}		]),
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
