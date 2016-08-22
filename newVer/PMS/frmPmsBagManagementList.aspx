<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmPmsBagManagementList.aspx.cs" Inherits="PMS_frmPmsBagManagemen" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html>
<head>
<title>编织袋流转登记管理</title><meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<link rel="stylesheet" type="text/css" href="../ext3/resources/css/ext-all.css" />
<script type="text/javascript" src="../ext3/adapter/ext/ext-base.js"></script>
<script type="text/javascript" src="../ext3/ext-all.js"></script>
<script type="text/javascript" src="../ext3/src/locale/ext-lang-zh_CN.js"></script>
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
var followState;
var saveType;
//form
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
//开始时间
var ksrq = new Ext.form.DateField({
    xtype:'datefield',
    fieldLabel:'开始时间',
    anchor:'95%',
    format: 'Y年m月d日 H:i:s',  //添加中文样式
    value:new Date() 
});

//结束时间
var jsrq = new Ext.form.DateField({
    xtype:'datefield',
    fieldLabel:'结束时间',
    anchor:'95%',
    format: 'Y年m月d日 H:i:s',  //添加中文样式
    value:new Date()
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
                ksrq
            ]
        },{
            name: 'cusStyle',
            columnWidth: .4,
            layout: 'form',
            border: false,
            labelWidth: 80,
            items: [
                jsrq
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
                var strStartTime=ksrq.getValue();
                var strEndTime=jsrq.getValue();
                
                dspmsbagmanagent.baseParams.WorkshopId=strWsId;
                dspmsbagmanagent.baseParams.IniOrderId=striniOrderId;
                dspmsbagmanagent.baseParams.StartTime=Ext.util.Format.date(strStartTime,'Y/m/d');
                dspmsbagmanagent.baseParams.EndTime=Ext.util.Format.date(strEndTime,'Y/m/d H:i:s');
                dspmsbagmanagent.baseParams.followState=followState;
                
                dspmsbagmanagent.load({
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

//grid
/*------开始获取数据的函数 start---------------*/
var dspmsbagmanagent = new Ext.data.Store
({
url: 'frmPmsBagManagementList.aspx?method=getManagementList',
reader:new Ext.data.JsonReader({
	totalProperty:'totalProperty',
	root:'root'
},[
	{		name:'Id'	},
	{		name:'WsId'	},
	{		name:'IsDamaged'	},
	{		name:'Qty'	},
	{		name:'InitOrderId'	},
	{		name:'Remark'	},
	{		name:'FlowLink'	},
	{		name:'BusiType'	},
	{		name:'ProductName'	},
	{		name:'CreateDate'
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
var cm1 = new Ext.grid.ColumnModel([
		sm,
		new Ext.grid.RowNumberer(),//自动行号
		{
			header:'流水号',
			dataIndex:'Id',
			id:'Id',
			hidden:true,
			hideable:false
		},
		{
			header:'车间',
			dataIndex:'WsId',
			id:'WsId',
			width:80,
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
			header:'是否破损',
			dataIndex:'IsDamaged',
			id:'IsDamaged',
			width:50,
			renderer:function(v){
			    if(v==1)
			        return '是';
			    else
			        return '否';
			}
		},
		{
			header:'数量',
			width:50,
			dataIndex:'Qty',
			id:'Qty'
		},
		{
			header:'原始单号',
			width:50,
			dataIndex:'InitOrderId',
			id:'InitOrderId'
		},
		{
			header:'流转环节',
			dataIndex:'FlowLink',
			id:'FlowLink',
			width:50,
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
			header:'状态',
			dataIndex:'BusiType',
			id:'BusiType',
			width:50,
			renderer:function(val){
			    if(val == 'P032') val ='初始登记';
			    if(val == 'P033') val ='已转下流程';
			    if(val == 'P034') val ='流程结束';
			    if(val == 'P035') val ='已制成品';
		        return val;
			}
		},
		{
			header:'成品',
			width:120,
			dataIndex:'ProductName',
			id:'ProductName',
			renderer:function(v){
			    return v;
			}
		},
		{
			header:'创建时间',
			width:80,
			dataIndex:'CreateDate',
			id:'CreateDate'
		}		
]);
var cm2 = new Ext.grid.ColumnModel([
		sm,
		new Ext.grid.RowNumberer(),//自动行号
		{
			header:'流水号',
			dataIndex:'Id',
			id:'Id',
			hidden:true,
			hideable:false
		},
		{
			header:'车间',
			dataIndex:'WsId',
			id:'WsId',
			width:80,
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
			header:'是否破损',
			dataIndex:'IsDamaged',
			id:'IsDamaged',
			width:50,
			renderer:function(v){
			    if(v==1)
			        return '是';
			    else
			        return '否';
			}
		},
		{
			header:'数量',
			width:50,
			dataIndex:'Qty',
			id:'Qty'
		},
		{
			header:'原始单号',
			width:50,
			dataIndex:'InitOrderId',
			id:'InitOrderId'
		},
		{
			header:'流转环节',
			dataIndex:'FlowLink',
			id:'FlowLink',
			width:50,
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
			width:80,
			dataIndex:'CreateDate',
			id:'CreateDate'
		}		
]);
var pmsbagmanagentGrid = new Ext.grid.GridPanel({
    el:'dataGrid',
	width:'100%',
	height:'100%',
	autoWidth:true,
	autoHeight:true,
	autoScroll:true,
	layout: 'fit',
	id: 'pmsbagmanagentGrid',
	store: dspmsbagmanagent,
	loadMask: {msg:'正在加载数据，请稍侯……'},
	sm:sm,
	cm: cm1,
	bbar: new Ext.PagingToolbar({
		pageSize: 10,
		store: dspmsbagmanagent,
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
pmsbagmanagentGrid.render();
/*------DataGrid的函数结束 End---------------*/

/* clear */
function resetformandgridvalue(){
    WsNamePanel.setValue("");
    iniOrderIdPanel.setValue("");
    ksrq.setValue(new Date());
    jsrq.setValue(new Date());    
    
    pmsbagmanagentGrid.getStore().removeAll();
}
function setfollowState(state){
    followState = state;
    
    var dynamicCm;
    if(state=='four')
        dynamicCm = cm1;
    else 
        dynamicCm = cm2;
        
    //重新绑定grid
    pmsbagmanagentGrid.reconfigure(dspmsbagmanagent, dynamicCm);
    //重新绑定分页工具栏
    pmsbagmanagentGrid.getBottomToolbar().bind(dspmsbagmanagent);
    
}
/*-----编辑Management实体类窗体函数----*/
var productCombo = new Ext.form.ComboBox({
    fieldLabel:"成品名称",//文本框标题
    columnWidth:1,
    id:'pcobox',
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
function modifyManagementWin() {
	var sm = pmsbagmanagentGrid.getSelectionModel();
	//获取选择的数据信息
	var selectData =  sm.getSelected();
	if(selectData == null){
		Ext.Msg.alert("提示","请选中需要编辑的信息！");
		return;
	}
	//判断
	if(saveType.indexOf('edit')>-1){
	    //alert(selectData.data.BusiType);
	    if(selectData.data.FlowLink != ret_flowLink(followState)){
            Ext.Msg.alert("提示","非本过程增加的记录不能修改！");
            return;
        }
    	
        if(selectData.data.BusiType != 'P032'){
            Ext.Msg.alert("提示","已流转或记录不能修改！");
            return;
        }
    }
    if(saveType.indexOf('sale')>-1){
        if(selectData.data.FlowLink != ret_flowLink('two'))
            return;
        if(selectData.data.BusiType != 'P032'){
            Ext.Msg.alert("提示","已流转或记录不能销售！");
            return;
        }
    }
    if(saveType.indexOf('produce')>-1){
        if(selectData.data.FlowLink != ret_flowLink('four'))
            return;
        if(selectData.data.BusiType != 'P032'){
            Ext.Msg.alert("提示","已流转未结束！");
            return;
        }
        if(pmsbagmanagementform.findById('pcobox')==null)
            pmsbagmanagementform.add(productCombo);        
    }
    if(saveType.indexOf('accept')>-1){
        if(selectData.data.FlowLink != ret_lastflowLink(followState))
            return;
    }
    
	uploadManagementWindow.show();
	setFormValue(selectData);
}
/*------开始界面数据的函数 Start---------------*/
function setFormValue(selectData)
{
	Ext.Ajax.request({
		url:'frmPmsBagManagementList.aspx?method=getmanagement',
		params:{
			Id:selectData.data.Id
		},
	success: function(resp,opts){
		var data=Ext.util.JSON.decode(resp.responseText);
		Ext.getCmp("Id").setValue(data.Id);
		Ext.getCmp("WsId").setValue(data.WsId);
		Ext.getCmp("IsDamaged").setValue(data.IsDamaged);
		Ext.getCmp("Qty").setValue(data.Qty);
		Ext.getCmp("InitOrderId").setValue(data.InitOrderId);
		Ext.getCmp("Remark").setValue(data.Remark);
		if(saveType.indexOf('edit')>-1)
		    Ext.getCmp("FlowLink").setValue(data.FlowLink);
	},
	failure: function(resp,opts){
		Ext.Msg.alert("提示","获取用户信息失败");
	}
	});
}
/*------实现FormPanle的函数 start---------------*/
var pmsbagmanagementform=new Ext.form.FormPanel({
	url:'',
	frame:true,
	title:'',
	items:[
		{
			xtype:'hidden',
			fieldLabel:'流水号',
			name:'Id',
			id:'Id',
			hidden:true,
			hideLabel:false
		}
,		{
			xtype:'combo',
			fieldLabel:'车间标识',
			columnWidth:1,
			anchor:'95%',
			name:'WsId',
			id:'WsId',
		    store:dsWs,
		    displayField:'WsName',
		    valueField:'WsId',
		    mode:'local',
		    triggerAction:'all',
		    editable: true
		}
,		{
            layout:'column',
            items:[{
                layout:'form',
			    columnWidth:.5,
                items:[{
			        xtype:'combo',
			        fieldLabel:'是否破损',
			        anchor:'90%',
			        name:'IsDamaged',
			        id:'IsDamaged',
			        store:[[1,'是'],[0,'否']],
			        editable:false,
			        triggerAction:'all',
			        mode:'local'
			    }]
			},
			{
                layout:'form',
			    columnWidth:.5,
                items:[{
			        xtype:'numberfield',
			        fieldLabel:'数量',
			        columnWidth:1,
			        anchor:'90%',
			        name:'Qty',
			        id:'Qty'
			    }]
			}]
		}
,		{
			xtype:'textfield',
			fieldLabel:'原始单号',
			columnWidth:1,
			anchor:'95%',
			name:'InitOrderId',
			id:'InitOrderId'
		}
,		{
			xtype:'combo',
			fieldLabel:'流转环节',
			columnWidth:1,
			anchor:'95%',
			name:'FlowLink',
			id:'FlowLink',
			store:dsStatus,
			displayField:'DicsName',
			valueField:'DicsCode',
			mode:'local',
			triggerAction:'all',
			disabled:true
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
if(typeof(uploadManagementWindow)=="undefined"){//解决创建2个windows问题
	uploadManagementWindow = new Ext.Window({
		id:'Managementformwindow',
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
		,items:pmsbagmanagementform
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
				uploadManagementWindow.hide();
			}
			, scope: this
		}]});
}
uploadManagementWindow.addListener("hide",function(){
	    pmsbagmanagementform.getForm().reset();
});
uploadManagementWindow.addListener("show",function(){
	    if(followState == 'one')
	        Ext.getCmp('FlowLink').setValue(dsStatus.getAt(0).data.DicsCode);
	    if(followState == 'two')
	        Ext.getCmp('FlowLink').setValue(dsStatus.getAt(1).data.DicsCode);
	    if(followState == 'three')
	        Ext.getCmp('FlowLink').setValue(dsStatus.getAt(2).data.DicsCode);
	    if(followState == 'four')
	        Ext.getCmp('FlowLink').setValue(dsStatus.getAt(3).data.DicsCode);
});

function ret_flowLink(v){
    if(v == 'one')
        return dsStatus.getAt(0).data.DicsCode;
    if(v == 'two')
        return dsStatus.getAt(1).data.DicsCode;
    if(v == 'three')
        return dsStatus.getAt(2).data.DicsCode;
    if(v == 'four')
        return dsStatus.getAt(3).data.DicsCode;
}

function ret_lastflowLink(v){
    if(v == 'two')
        return dsStatus.getAt(0).data.DicsCode;
    if(v == 'three')
        return dsStatus.getAt(1).data.DicsCode;
    if(v == 'four')
        return dsStatus.getAt(2).data.DicsCode;
}

/*------开始获取界面数据的函数 start---------------*/
function saveUserData()
{

	Ext.Ajax.request({
		url:'frmPmsBagManagementList.aspx?method='+saveType,
		method:'POST',
		params:{
			Id:Ext.getCmp('Id').getValue(),
			WsId:Ext.getCmp('WsId').getValue(),
			IsDamaged:Ext.getCmp('IsDamaged').getValue(),
			Qty:Ext.getCmp('Qty').getValue(),
			InitOrderId:Ext.getCmp('InitOrderId').getValue(),
			Remark:Ext.getCmp('Remark').getValue(),
			FlowLink:Ext.getCmp('FlowLink').getValue(),
			followState:followState,
			ProductId:productCombo.getValue()
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
var onePanel = new Ext.Panel(
{
	title:'拆包过程',
	split:true,
	width:'100%',
	autoScroll:true,
	collapsible: true,
	margins:'0 0 0 0',
	bodyStyle:'height:0px;',
	tbar:new Ext.Toolbar({
	    items:[{
		    text:"原袋登记",
		    icon:"../Theme/1/images/extjs/customer/add16.gif",
		    handler:function(){
		        saveType='addOne';
		        uploadManagementWindow.show();
		    }
		    },'-',{
		    text:"编辑",
		    icon:"../Theme/1/images/extjs/customer/edit16.gif",
		    handler:function(){
		        saveType='editOne';
		        modifyManagementWin();
		    }
	    }]
    }),
    listeners : {
        'deactivate' : function(panel){
            resetformandgridvalue();
        },
        'activate' : function (){ setfollowState('one')}
    }
});
var twoPanel = new Ext.Panel(
{
	title:'车间加工过程',
	split:true,
	width: '100%',
	collapsible: true,
	margins:'0 0 0 0',
	bodyStyle:'height:0px;',
	tbar:new Ext.Toolbar({
	    items:[{
		    text:"原袋接收",
		    icon:"../Theme/1/images/extjs/customer/add16.gif",
		    handler:function(){
		        saveType='acceptTwo';
		        modifyManagementWin();
		    }
		    },'-',{
		    text:"编辑",
		    icon:"../Theme/1/images/extjs/customer/edit16.gif",
		    handler:function(){
		        saveType='editTwo';
		        modifyManagementWin();
		    }
		    },'-',{
		    text:"原袋销售",
		    icon:"../Theme/1/images/extjs/customer/1edit16.gif",
		    handler:function(){
		        saveType='saleTwo';
		        modifyManagementWin();
		    }
	    }]
    }),
    listeners : {
        'deactivate' : function(panel){
            resetformandgridvalue();
        } ,
        'activate' : function (){ setfollowState('two')}
    }
});
var threePanel = new Ext.Panel(
{
	title:'清洗过程',
	split:true,
	width: '100%',
	collapsible: true,
	margins:'0 0 0 0',
	bodyStyle:'height:0px;',
	tbar:new Ext.Toolbar({
	    items:[{
		    text:"原袋接收",
		    icon:"../Theme/1/images/extjs/customer/add16.gif",
		    handler:function(){
		        saveType='acceptThree';
		        modifyManagementWin();
		    }
		    },'-',{
		    text:"编辑",
		    icon:"../Theme/1/images/extjs/customer/edit16.gif",
		    handler:function(){
		        saveType='editThree';
		        modifyManagementWin();
		    }
	    }]
    }),
    listeners : {
        'deactivate' : function(panel){
            resetformandgridvalue();
        },
        'activate' : function (){ setfollowState('three')}
    }
});
var fourPanel = new Ext.Panel(
{
	title:'制作过程',
	split:true,
	width: '100%',
	collapsible: true,
	margins:'0 0 0 0',
	bodyStyle:'height:0px;',
	tbar:new Ext.Toolbar({
	    items:[{
		    text:"原袋接收",
		    icon:"../Theme/1/images/extjs/customer/add16.gif",
		    handler:function(){
		        saveType='acceptFour';
		        modifyManagementWin();
		    }
		    },'-',{
		    text:"编辑",
		    icon:"../Theme/1/images/extjs/customer/edit16.gif",
		    handler:function(){
		        saveType='editFour';
		        modifyManagementWin();
		    }
		    },'-',{
		    text:"成品制成",
		    icon:"../Theme/1/images/extjs/customer/1edit16.gif",
		    handler:function(){
		        saveType='produceFour';
		        modifyManagementWin();
		    }
	    }]
    }),
    listeners : {
        'deactivate' : function(panel){
            resetformandgridvalue();
        },
        'activate' : function (){ setfollowState('four')}
    }
});
var tabPanel =	new Ext.TabPanel({
		el:'toolbar',
		deferredRender:false,
		width:'100%',
	    autoWidth:true,
	    autoScroll:true,
		autoShow :true,
		autoDestroy :true,
		minTabWidth: 200,		//tab页的标题栏最小尺寸,此属性要有效, 必须设置resizeTabs:true
		resizeTabs:true,		//tab页的标题栏是否支持自动缩放
		enableTabScroll:true,
		activeTab:0,
		items:[onePanel,twoPanel,threePanel,fourPanel]
});
tabPanel.render();


})
</script>
</html>
