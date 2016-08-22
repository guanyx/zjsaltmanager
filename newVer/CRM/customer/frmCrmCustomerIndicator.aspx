<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmCrmCustomerIndicator.aspx.cs" Inherits="CRM_customer_frmCrmCustomerIndicator" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html>
<head>
<title>客户经理指标</title><meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<link rel="stylesheet" type="text/css" href="../../ext3/resources/css/ext-all.css" />
<script type="text/javascript" src="../../ext3/adapter/ext/ext-base.js"></script>
<script type="text/javascript" src="../../ext3/ext-all.js"></script>
<script type="text/javascript" src="../../js/operateResp.js"></script>
</head>
<body>
<div id='toolbar'></div>
<div id='searchForm'></div>
<div id='dataGrid'></div>
<%=getComboBoxStore( ) %>
</body>
<script type="text/javascript">
Ext.BLANK_IMAGE_URL = "../../ext3/resources/images/default/s.gif";
Ext.onReady(function(){
var saveType;
/*------实现toolbar的函数 start---------------*/
var Toolbar = new Ext.Toolbar({
	renderTo:"toolbar",
	items:[{
		text:"新增",
		icon:"../../Theme/1/images/extjs/customer/add16.gif",
		handler:function(){
		    saveType = "addIndicator";
		    openAddIndicatorWin();
		}
		},'-',{
		text:"编辑",
		icon:"../../Theme/1/images/extjs/customer/edit16.gif",
		handler:function(){
		    saveType = "saveIndicator";
		    modifyIndicatorWin();
		}
	}]
});

/*------结束toolbar的函数 end---------------*/


/*------开始ToolBar事件函数 start---------------*//*-----新增Indicator实体类窗体函数----*/
function openAddIndicatorWin() {
	uploadIndicatorWindow.show();
}
/*-----编辑Indicator实体类窗体函数----*/
function modifyIndicatorWin() {
	var sm = IndicatorGrid.getSelectionModel();
	//获取选择的数据信息
	var selectData =  sm.getSelected();
	if(selectData == null){
		Ext.Msg.alert("提示","请选中需要编辑的信息！");
		return;
	}
	uploadIndicatorWindow.show();
	setFormValue(selectData);
}
/*------实现FormPanle的函数 start---------------*/
var yearStore = new Ext.data.SimpleStore({
   fields: ['id', 'name'],        
   data : [        
   ['1', '一月']
   ]});
var yearRowPatter = Ext.data.Record.create([
           { name: 'id', type: 'string' },
           { name: 'name', type: 'string' }
          ]);
yearStore.removeAll();
var currentYear = (new Date()).getFullYear();
currentYear = parseInt(currentYear)+1;
for(var i=2009;i<currentYear;i++)
{
    var year = new yearRowPatter({id:i,name:i});
    yearStore.add(year);
}
var IndicatorForm=new Ext.form.FormPanel({
	frame:true,
	title:'',
	labelWidth:55,
	items:[
	{
	    layout:'column',
	    items:[
		{
		    layout:'form',		    
			columnWidth:.5,
		    items:[
		    {
			    xtype:'hidden',
			    fieldLabel:'指标ID',
			    name:'IndicatorId',
			    id:'IndicatorId',
			    hidden:true,
			    hideLabel:true
		    }
            ,{
			    xtype:'combo',
			    fieldLabel:'客户经理',
			    anchor:'98%',
			    name:'CustomerMangerId',
			    id:'CustomerMangerId',
			    store:dsEmployee,
			    displayField:'EmpName',
			    valueField:'EmpId',
			    triggerAction:'all',
			    mode:'local'
		    }]
		},
		{
		    layout:'form',		    
			columnWidth:.5,
		    items:[
		    {
			    xtype:'combo',
			    fieldLabel:'存货类型',
			    anchor:'98%',
			    name:'IndicatorType',
			    id:'IndicatorType',
			    store:[[0,'所有存货'],[1,'盐类'],[2,'非盐类']],
			    mode:'local',
			    triggerAction:'all',
			    editable:false
		    }]
		}]
    }
    ,{
        layout:'column',
	    items:[
		{
		    layout:'form',		    
			columnWidth:.33,
		    items:[
		    {
			    xtype:'numberfield',
			    fieldLabel:'客户数',
			    anchor:'98%',
			    name:'Customers',
			    id:'Customers',
			    decimalPrecision:0
		    }]
		},		
		{
		    layout:'form',		    
			columnWidth:.33,
		    items:[
		    {
			    xtype:'numberfield',
			    fieldLabel:'订单数',
			    anchor:'98%',
			    name:'Orders',
			    id:'Orders',
			    decimalPrecision:0
			}]
		},		
		{
		    layout:'form',		    
			columnWidth:.34,
		    items:[
		    {
			    xtype:'numberfield',
			    fieldLabel:'订单金额',
			    anchor:'98%',
			    name:'OrderAmount',
			    id:'OrderAmount',
			    decimalPrecision:8
			}]
		}]
    },
    {
        layout:'column',
	    items:[
	    {
		    layout:'form',		    
			columnWidth:.34,
		    items:[
		    {
			    xtype:'combo',
			    fieldLabel:'年份',
			    anchor:'98%',
			    name:'IndicatorPeriod',
			    id:'IndicatorPeriod',
			    store:yearStore,
			    displayField:'name',
			    valueField:'id',
			    mode:'local',
			    triggerAction:'all'
			}]
		},
		{
		    layout:'form',		    
			columnWidth:.33,
		    items:[
    		{
			    xtype:'combo',
			    fieldLabel:'是否启用',
			    anchor:'98%',
			    name:'IsEnable',
			    id:'IsEnable',
			    store:[[1,'启用'],[0,'不启用']],
			    mode:'local',
			    triggerAction:'all',
			    editable:false
		    }]
		}]
    },		
    {
        layout:'column',
	    items:[
		{
		    layout:'form',		    
			columnWidth:1,
		    items:[
    		{
			    xtype:'textarea',
			    fieldLabel:'备注',
			    anchor:'98%',
			    name:'Remark',
			    id:'Remark'
			}]
		}]
    }
]
});
/*------FormPanle的函数结束 End---------------*/

/*------开始界面数据的窗体 Start---------------*/
if(typeof(uploadIndicatorWindow)=="undefined"){//解决创建2个windows问题
	uploadIndicatorWindow = new Ext.Window({
		id:'Indicatorformwindow',
		title:'指标制定'
		, iconCls: 'upload-win'
		, width: 600
		, height: 280
		, layout: 'fit'
		, plain: true
		, modal: true
		, constrain:true
		, resizable: false
		, closeAction: 'hide'
		,autoDestroy :true
		,items:IndicatorForm
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
				uploadIndicatorWindow.hide();
			}
			, scope: this
		}]});
	}
	uploadIndicatorWindow.addListener("hide",function(){
	    IndicatorForm.getForm().reset();
});

/*------开始获取界面数据的函数 start---------------*/
function saveUserData()
{
	Ext.Ajax.request({
		url:'frmCrmCustomerIndicator.aspx?method='+saveType,
		method:'POST',
		params:{
			IndicatorId:Ext.getCmp('IndicatorId').getValue(),
			CustomerMangerId:Ext.getCmp('CustomerMangerId').getValue(),
			IndicatorType:Ext.getCmp('IndicatorType').getValue(),
			Customers:Ext.getCmp('Customers').getValue(),
			Orders:Ext.getCmp('Orders').getValue(),
			OrderAmount:Ext.getCmp('OrderAmount').getValue(),
			IsEnable:Ext.getCmp('IsEnable').getValue(),
			IndicatorPeriod:Ext.getCmp('IndicatorPeriod').getValue(),
			Remark:Ext.getCmp('Remark').getValue()
			},
		success: function(resp,opts){
			if(checkExtMessage(resp)){
			    IndicatorGrid.getStore().reload();
			}
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
		url:'frmCrmCustomerIndicator.aspx?method=getIndicator',
		params:{
			IndicatorId:selectData.data.IndicatorId
		},
	success: function(resp,opts){
		var data=Ext.util.JSON.decode(resp.responseText);
		Ext.getCmp("IndicatorId").setValue(data.IndicatorId);
		Ext.getCmp("CustomerMangerId").setValue(data.CustomerMangerId);
		Ext.getCmp("IndicatorType").setValue(data.IndicatorType);
		Ext.getCmp("Customers").setValue(data.Customers);
		Ext.getCmp("Orders").setValue(data.Orders);
		Ext.getCmp("OrderAmount").setValue(data.OrderAmount);
		Ext.getCmp("IsEnable").setValue(data.IsEnable);
		Ext.getCmp("IndicatorPeriod").setValue(data.IndicatorPeriod);
		Ext.getCmp("Remark").setValue(data.Remark);
	},
	failure: function(resp,opts){
		Ext.Msg.alert("提示","获取用户信息失败");
	}
	});
}
/*------结束设置界面数据的函数 End---------------*/
/*------开始查询form end---------------*/   
var CustYearPanel = new Ext.form.ComboBox({
    style: 'margin-left:0px',
    cls: 'key',
    xtype: 'combo',
    fieldLabel: '年份',
    name: 'Year',
    anchor: '95%',
    store:yearStore,
    displayField:'name',
    valueField:'id',
    mode:'local',
    triggerAction:'all'
});
var CustManagerPanel = new Ext.form.TextField({
    style: 'margin-left:0px',
    cls: 'key',
    xtype: 'textfield',
    fieldLabel: '客户经理',
    name: 'CustManager',
    anchor: '95%'
});

var serchform = new Ext.FormPanel({
    renderTo: 'searchForm',
    labelAlign: 'left',
    layout:'fit',
    buttonAlign: 'right',
    bodyStyle: 'padding:5px',
    frame: true,
    labelWidth: 80,
    items: [{
        layout: 'column',   //定义该元素为布局为列布局方式
        border: false,
        items: [
        {
            name: 'cusStyle',
            columnWidth: .2,
            layout: 'form',
            border: false,
            labelWidth: 55,
            items: [
                CustYearPanel
            ]
        },{
            name: 'cusStyle',
            columnWidth: .25,
            layout: 'form',
            border: false,
            labelWidth: 55,
            items: [
                CustManagerPanel
            ]
        }, {
            columnWidth: .08,
            layout: 'form',
            border: false,
            items: [{ cls: 'key',
                xtype: 'button',
                text: '查询',
                anchor: '50%',
                handler :function(){
                
                var CustManager=CustManagerPanel.getValue();
                var CustYear = CustYearPanel.getValue();
                
                dsIndicatorGrid.baseParams.CustManager=CustManager;
                dsIndicatorGrid.baseParams.IndicatorPeriod= CustYear;
                
                dsIndicatorGrid.load({
                            params : {
                            start : 0,
                            limit : 10
                            } });
                }
            }]
        }]
    }]
});
/*------开始查询form end---------------*/
/*------开始获取数据的函数 start---------------*/
var dsIndicatorGrid = new Ext.data.Store
({
url: 'frmCrmCustomerIndicator.aspx?method=getIndicatorList',
reader:new Ext.data.JsonReader({
	totalProperty:'totalProperty',
	root:'root'
},[
	{		name:'IndicatorId'	},
	{		name:'CustomerMangerId'	},
	{		name:'IndicatorType'	},
	{		name:'Customers'	},
	{		name:'Orders'	},
	{		name:'OrderAmount'	},
	{		name:'IsEnable'	},
	{		name:'ValidDate'	},
	{		name:'ExpireDate'	},
	{		name:'Remark'	},
	{		name:'OperId'	},
	{		name:'OrgId'	},
	{		name:'CreateDate'	},
	{		name:'UpdateDate'	},
	{       name:'IndicatorPeriod'},
	{		name:'CustomerManger'	}	
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
	singleSelect:true
});
var IndicatorGrid= new Ext.grid.GridPanel({
	el: 'dataGrid',
	width:'100%',
	height:'100%',
	autoWidth:true,
	autoHeight:true,
	autoScroll:true,
	layout: 'fit',
	id: '',
	store: dsIndicatorGrid,
	loadMask: {msg:'正在加载数据，请稍侯……'},
	sm:sm,
	cm: new Ext.grid.ColumnModel([
		sm,
		new Ext.grid.RowNumberer(),//自动行号
		{
			header:'指标ID',
			dataIndex:'IndicatorId',
			id:'IndicatorId',
			hidden:true,
			hideable:false
		},
		{
			header:'客户经理',
			dataIndex:'CustomerMangerId',
			id:'CustomerMangerId',
			renderer:function(v){
			    var ret = '';
			    dsEmployee.each(function(record){
			        if(record.data.EmpId==v)
			            ret= record.data.EmpName;
			            return;
			    });
			    return ret;
			}
		},
		{
			header:'存货类型',
			dataIndex:'IndicatorType',
			id:'IndicatorType',
			renderer:function(v){
			    if(v==0)return '所有存货';
			    if(v==1)return '盐类';
			    if(v==2)return '非盐类';
			}
		},
		{
			header:'客户数',
			dataIndex:'Customers',
			id:'Customers'
		},
		{
			header:'订单数',
			dataIndex:'Orders',
			id:'Orders'
		},
		{
			header:'订单金额数',
			dataIndex:'OrderAmount',
			id:'OrderAmount'
		},
		{
			header:'是否启用',
			dataIndex:'IsEnable',
			id:'IsEnable',
			renderer:function(v){
			    if(v==1)return '启用';
			    if(v==0)return '未启用';
			}
		},
		{
			header:'生效时间',
			dataIndex:'ValidDate',
			id:'ValidDate',
			format:'Y年m月d日',
			renderer: Ext.util.Format.dateRenderer('Y年m月d日')
		},
		{
			header:'失效时间',
			dataIndex:'ExpireDate',
			id:'ExpireDate',
			format:'Y年m月d日',
			renderer: Ext.util.Format.dateRenderer('Y年m月d日')
		}
		]),
		bbar: new Ext.PagingToolbar({
			pageSize: 10,
			store: dsIndicatorGrid,
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
IndicatorGrid.render();
/*------DataGrid的函数结束 End---------------*/



})
</script>
</html>

