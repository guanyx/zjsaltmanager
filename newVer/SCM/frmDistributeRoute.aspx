<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmDistributeRoute.aspx.cs" Inherits="SCM_frmDistributeRoute" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html>
<head>
<title>配置线路维护</title><meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<link rel="stylesheet" type="text/css" href="../ext3/resources/css/ext-all.css" />
<script type="text/javascript" src="../ext3/adapter/ext/ext-base.js"></script>
<script type="text/javascript" src="../ext3/ext-all.js"></script>
</head>
<body>
<div id='toolbar'></div>
<div id='searchForm'></div>
<div id='dataGrid'></div>
<%=getComboBoxStore() %>
</body>
<script type="text/javascript">
Ext.BLANK_IMAGE_URL = "../ext3/resources/images/default/s.gif";
Ext.onReady(function(){
var saveType;
var currentRouteId;
/*------实现toolbar的函数 start---------------*/
var Toolbar = new Ext.Toolbar({
	renderTo:"toolbar",
	items:[{
		text:"新增",
		icon:"../Theme/1/images/extjs/customer/add16.gif",
		handler:function(){
		    saveType='add';
		    openAddRouteWin();
		}
		},'-',{
		text:"编辑",
		icon:"../Theme/1/images/extjs/customer/edit16.gif",
		handler:function(){
		    saveType='save';
		    modifyRouteWin();
		}
		},'-',{
		text:"删除",
		icon:"../Theme/1/images/extjs/customer/delete16.gif",
		handler:function(){
		    deleteRoute();
		}
		},'-',{
		text:"新增子线路",
		icon:"../Theme/1/images/extjs/customer/edit16.gif",
		handler:function(){
		    saveType='add';
		    openAddRouteChildWin();
		}
		},'-',{
		text:"维护线路客户",
		icon:"../Theme/1/images/extjs/customer/view16.gif",
		handler:function(){
		    ManageRouteCustomer();
		}
	}]
});

/*------结束toolbar的函数 end---------------*/


/*------开始ToolBar事件函数 start---------------*//*-----新增Route实体类窗体函数----*/
function openAddRouteWin() {	
	uploadRouteWindow.show();
}
function openAddRouteChildWin(){
    var sm = gridRouteData.getSelectionModel();
	//获取选择的数据信息
	var selectData =  sm.getSelected();
	if(selectData == null){
		Ext.Msg.alert("提示","请选中父线路的信息！");
		return;
	}
    uploadRouteWindow.show();
    Ext.getCmp("RouteParent").setValue(selectData.data.RouteId);
    Ext.getCmp("RouteParentNo").setValue(selectData.data.RouteNo);
}
/*-----编辑Route实体类窗体函数----*/
function modifyRouteWin() {    
	var sm = gridRouteData.getSelectionModel();
	//获取选择的数据信息
	var selectData =  sm.getSelected();
	if(selectData == null){
		Ext.Msg.alert("提示","请选中需要编辑的信息！");
		return;
	}
	uploadRouteWindow.show();
	setFormValue(selectData);
}
/*-----删除Route实体函数----*/
/*删除信息*/
function deleteRoute()
{
	var sm = gridRouteData.getSelectionModel();
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
				url:'frmDistributeRoute.aspx?method=deleteRoute',
				method:'POST',
				params:{
					RouteId:selectData.data.RouteId
				},
				success: function(resp,opts){
				    gridRouteData.getStore().reload();
					Ext.Msg.alert("提示","数据删除成功");
				},
				failure: function(resp,opts){
					Ext.Msg.alert("提示","数据删除失败");
				}
			});
		}
	});
}
function ManageRouteCustomer(){
    var sm = gridRouteData.getSelectionModel();
	//获取选择的数据信息
	var selectData =  sm.getSelected();
	//如果没有选择，就提示需要选择数据信息
	if(selectData == null){
		Ext.Msg.alert("提示","请选中需要配置的线路信息！");
		return;
	}
    currentRouteId = selectData.data.RouteId;
    uploadRouteCustomerWindow.show();
    dsGridRouteCustomer.baseParams.RouteId = currentRouteId;
    dsGridRouteCustomer.load({
        params : {
        start : 0,
        limit : 10
        } 
     }); 
}
/*------实现FormPanle的函数 start---------------*/
var routeForm=new Ext.form.FormPanel({
	url:'',
	//renderTo:'divForm',
	frame:true,
	title:'',
	items:[
		{
			xtype:'hidden',
			fieldLabel:'计划汇总标识',
			columnWidth:1,
			anchor:'90%',
			name:'RouteId',
			id:'RouteId',
			hidden:true,
			hideLabel:true
		}
,		{
			xtype:'hidden',
			fieldLabel:'父线路编号',
			columnWidth:1,
			anchor:'90%',
			name:'RouteParent',
			id:'RouteParent',
			hidden:true,
			hideLabel:true
		}
,		{
			xtype:'textfield',
			fieldLabel:'父线路编号',
			columnWidth:1,
			anchor:'90%',
			name:'RouteParentNo',
			id:'RouteParentNo',
			readOnly:true
		}
,		{
			xtype:'textfield',
			fieldLabel:'线路编号',
			columnWidth:1,
			anchor:'90%',
			name:'RouteNo',
			id:'RouteNo'
		}
,		{
			xtype:'textfield',
			fieldLabel:'线路名称',
			columnWidth:1,
			anchor:'90%',
			name:'RouteName',
			id:'RouteName'
		}
,		{
			xtype:'combo',
			fieldLabel:'线路类型',
			columnWidth:1,
			anchor:'90%',
			name:'RouteType',
			id:'RouteType',
			store:dsRouteType,
			displayField:'DicsName',
			valueField:'DicsCode',
			mode:'local',
			triggerAction:'all',
			editable:false
		}
,		{
			xtype:'combo',
			fieldLabel:'负责人',
			columnWidth:1,
			anchor:'90%',
			name:'ChargePerson',
			id:'ChargePerson',
			store:dsOper,
			displayField:'EmpName',
			valueField:'EmpId',
			mode:'local',
			triggerAction:'all',
			editable:false
		}
,		{
			xtype:'textarea',
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
if(typeof(uploadRouteWindow)=="undefined"){//解决创建2个windows问题
	uploadRouteWindow = new Ext.Window({
		id:'Routeformwindow',
		title:'配置线路维护'
		, iconCls: 'upload-win'
		, width: 400
		, height: 280
		, layout: 'fit'
		, plain: true
		, modal: true
		, constrain:true
		, resizable: false
		, closeAction: 'hide'
		,autoDestroy :true
		,items:routeForm
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
				uploadRouteWindow.hide();
			}
			, scope: this
		}]});
	}
	uploadRouteWindow.addListener("hide",function(){
	 routeForm.getForm().reset();
});

/*------开始获取界面数据的函数 start---------------*/
function saveUserData()
{
    if(saveType == 'add')
        saveType = 'addRoute';
    else if(saveType == 'save')
        saveType = 'saveRoute';
	Ext.Ajax.request({
		url:'frmDistributeRoute.aspx?method='+saveType,
		method:'POST',
		params:{
			RouteId:Ext.getCmp('RouteId').getValue(),
			RouteNo:Ext.getCmp('RouteNo').getValue(),
			RouteName:Ext.getCmp('RouteName').getValue(),
			RouteType:Ext.getCmp('RouteType').getValue(),
			RouteParent:Ext.getCmp('RouteParent').getValue(),
			ChargePerson:Ext.getCmp('ChargePerson').getValue(),
			Remark:Ext.getCmp('Remark').getValue()
			},
		success: function(resp,opts){
			Ext.Msg.alert("提示","保存成功");
			uploadRouteWindow.hide();
			gridRouteData.getStore().reload();
		},
		failure: function(resp,opts){
			Ext.Msg.alert("提示","保存失败");
		}
		});
		}
/*------结束获取界面数据的函数 End---------------*/
/*------实现searchForm的函数 start---------------*/
var nameRoutePanel = new Ext.form.TextField({
    style: 'margin-left:0px',
    cls: 'key',
    xtype: 'textfield',
    fieldLabel: '线路名称',
    name: 'name',
    anchor: '90%'
});
var searchForm = new Ext.form.FormPanel({
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
        items: [{
            columnWidth: .33,
            layout: 'form',
            border: false,
            items: [
                nameRoutePanel
                ]
        },{
            columnWidth: .10,
            layout: 'form',
            border: false,
            items: [{ cls: 'key',
                xtype: 'button',
                text: '查询',
                anchor: '50%',
                handler :function(){                
                    var name=nameRoutePanel.getValue();
                    //alert(name +":"+type);
                    dsGridRouteData.baseParams.RouteName=name;
                    dsGridRouteData.load({
                                params : {
                                start : 0,
                                limit : 10
                                } 
                              }); 
                    }
                }]
        },{
            columnWidth: .56,  //该列占用的宽度，标识为20％
            layout: 'form',
            border: false
        }]
    }]

});

/*------实现searchForm的函数 start---------------*/
/*------开始界面数据的函数 Start---------------*/
function setFormValue(selectData)
{
	Ext.Ajax.request({
		url:'frmDistributeRoute.aspx?method=getRoute',
		params:{
			RouteId:selectData.data.RouteId
		},
	success: function(resp,opts){
		var data=Ext.util.JSON.decode(resp.responseText);
		Ext.getCmp("RouteId").setValue(data.RouteId);
		Ext.getCmp("RouteNo").setValue(data.RouteNo);
		Ext.getCmp("RouteName").setValue(data.RouteName);
		Ext.getCmp("RouteType").setValue(data.RouteType);
		Ext.getCmp("RouteParent").setValue(data.RouteParent);
		Ext.getCmp("RouteParentNo").setValue(data.RouteParentNo);
		Ext.getCmp("ChargePerson").setValue(data.ChargePerson);
		Ext.getCmp("Remark").setValue(data.Remark);
	},
	failure: function(resp,opts){
		Ext.Msg.alert("提示","获取用户信息失败");
	}
	});
}
/*------结束设置界面数据的函数 End---------------*/

/*------开始获取数据的函数 start---------------*/
var dsGridRouteData = new Ext.data.Store
({
url: 'frmDistributeRoute.aspx?method=getRouteList',
reader:new Ext.data.JsonReader({
	totalProperty:'totalProperty',
	root:'root'
},[
	{		name:'RouteId'	},
	{		name:'RouteNo'	},
	{		name:'RouteName'	},
	{		name:'RouteType'	},
	{		name:'Remark'	},
	{		name:'OperId'	},
	{		name:'CreateDate'	},
	{		name:'UpdateDate'	},
	{		name:'OrgId'	},
	{		name:'OwnerId'	},
	{		name:'RouteParent'	},
	{		name:'RouteParentNo'	},
	{		name:'ChargePerson'	},
	{		name:'ChargePersonName'	}	
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
var gridRouteData = new Ext.grid.GridPanel({
	el: 'dataGrid',
	width:'100%',
	height:'100%',
	autoWidth:true,
	autoHeight:true,
	autoScroll:true,
	layout: 'fit',
	id: '',
	store: dsGridRouteData,
	loadMask: {msg:'正在加载数据，请稍侯……'},
	sm:sm,
	cm: new Ext.grid.ColumnModel([
		sm,
		new Ext.grid.RowNumberer(),//自动行号
		{
			header:'线路标识',
			dataIndex:'RouteId',
			id:'RouteId',
			hidden:true,
			hideable:false
		},
		{
			header:'线路编号',
			dataIndex:'RouteNo',
			id:'RouteNo'
		},
		{
			header:'线路名称',
			dataIndex:'RouteName',
			id:'RouteName'
		},
		{
			header:'线路类型',
			dataIndex:'RouteType',
			id:'RouteType',
			renderer:{
			    fn:function(val, params, record) {
		        if (dsRouteType.getCount() == 0) {
		            dsRouteType.load();
		        }
		        dsRouteType.each(function(r) {
		            if (val == r.data['DicsCode']) {
		                val = r.data['DicsName'];
		                return;
		            }
		        });
		        return val;
		        }
			}
		},
		{
			header:'父线路编号',
			dataIndex:'RouteParentNo',
			id:'RouteParentNo'
		},
		{
			header:'负责人',
			dataIndex:'ChargePersonName',
			id:'ChargePersonName'
		},
		{
			header:'备注',
			dataIndex:'Remark',
			id:'Remark'
		}
		]),
		bbar: new Ext.PagingToolbar({
			pageSize: 10,
			store: dsGridRouteData,
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
gridRouteData.render();
/*------DataGrid的函数结束 End---------------*/

/*------开始获取数据的函数 start---------------*/
var dsGridRouteCustomer = new Ext.data.Store
({
url: 'frmDistributeRoute.aspx?method=getRouteCustomerList',
reader:new Ext.data.JsonReader({
	totalProperty:'totalProperty',
	root:'root'
},[
	{		name:'RelationId'	},
	{		name:'RouteId'	},
	{		name:'CustomerId'	},
	{		name:'CreateDate'	},
	{		name:'UpdateDate'	},
	{		name:'OperId'	},
	{		name:'OrgId'	},
	{		name:'OwnerId'	},
	{		name:'RouteNo'	},
	{		name:'RouteType'	},
	{		name:'RouteName'	},
	{		name:'CustomerNo'	},
	{		name:'ShortName'	},
	{		name:'ChineseName'	},
	{		name:'Address'	},
	{		name:'RouteTypeText'}	
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

var smC= new Ext.grid.CheckboxSelectionModel({
	singleSelect:true
});
var routeCustomerGrid = new Ext.grid.GridPanel({
	width:'100%',
	height:'100%',
	autoWidth:true,
	autoHeight:true,
	autoScroll:true,
	layout: 'fit',
	id: '',
	store: dsGridRouteCustomer,
	loadMask: {msg:'正在加载数据，请稍侯……'},
	sm:smC,
	cm: new Ext.grid.ColumnModel([
		smC,
		new Ext.grid.RowNumberer(),//自动行号
		{
			header:'线路关联序号',
			dataIndex:'RelationId',
			id:'RelationId',
			hidden:true,
			hideable:false
		},
		{
			header:'线路序号',
			dataIndex:'RouteId',
			id:'RouteId',
			hidden:true,
			hideable:false
		},
		{
			header:'线路编号',
			dataIndex:'RouteNo',
			id:'RouteNo'
		},
		{
			header:'线路名称',
			dataIndex:'RouteName',
			id:'RouteName'
		},
		{
		    header:'线路类型',
			dataIndex:'RouteTypeText',
			id:'RouteTypeText'
		},
		{
			header:'客户编号',
			dataIndex:'CustomerNo',
			id:'CustomerNo'
		},
		{
			header:'客户简称',
			dataIndex:'ShortName',
			id:'ShortName'
		},
		{
			header:'客户地址',
			dataIndex:'Address',
			id:'Address'
		},
		{
			header:'创建日期',
			dataIndex:'CreateDate',
			id:'CreateDate',
			renderer: Ext.util.Format.dateRenderer('Y年m月d日')
		}
		]),
		tbar:new Ext.Toolbar({
	        items:[{
		        text:"新增",
		        icon:"../Theme/1/images/extjs/customer/add16.gif",
		        handler:function(){		            
                    uploadCtmGridWindow.show();
		        }
		        },'-',{
		        text:"删除",
		        icon:"../Theme/1/images/extjs/customer/delete16.gif",
		        handler:function(){
		            deleteRouteCustomerRelInfo();
		        }
	        }]
        }),
		bbar: new Ext.PagingToolbar({
			pageSize: 10,
			store: dsGridRouteCustomer,
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
function deleteRouteCustomerRelInfo(){
    var sm = routeCustomerGrid.getSelectionModel();
    //var selectData = sm.getSelected();
    var records=sm.getSelections();
    
    if (records == null || records.length == 0) 
    {
        Ext.Msg.alert("提示", "请选中一行！");
    }
    else 
    {   
        var array = new Array(records.length);
        for(var i=0;i<records.length;i++)
        {
            array[i] = records[i].get('RelationId');
        }
        Ext.Ajax.request({
        url: 'frmDistributeRoute.aspx?method=deleteRouteCustomerInfo',
            params: {
            RelationId: array.join('-')//传入多想的id串
            },
            success: function(resp, opts) {
                //var data=Ext.util.JSON.decode(resp.responseText);
                Ext.Msg.alert("提示", "删除成功！");
                routeCustomerGrid.getStore().reload();
            },
            failure: function(resp, opts) {
                Ext.Msg.alert("提示", "删除失败！");
            }
        });
    }

}		
/*------DataGrid的函数结束 End---------------*/

/*------开始客户配置界面数据的窗体 Start---------------*/
if(typeof(uploadRouteCustomerWindow)=="undefined"){//解决创建2个windows问题
	uploadRouteCustomerWindow = new Ext.Window({
		id:'RouteCustomerformwindow',
		title:'配置客户线路维护'
		, iconCls: 'upload-win'
		, width: 600
		, height: 400
		, layout: 'fit'
		, plain: true
		, modal: true
		, constrain:true
		, resizable: false
		, closeAction: 'hide'
		,autoDestroy :true
		,items:routeCustomerGrid
		,buttons: [
		{
			text: "关闭"
			, handler: function() { 
				uploadRouteCustomerWindow.hide();
			}
			, scope: this
		}]});
	}
	uploadRouteCustomerWindow.addListener("hide",function(){
	    routeCustomerGrid.getStore().removeAll();
		    
});
/*------结束客户配置界面数据的窗体 End---------------*/

/*------实现searchForm的函数 start---------------*/
var nameRouteCustomerNoPanel = new Ext.form.TextField({
    style: 'margin-left:0px',
    cls: 'key',
    xtype: 'textfield',
    fieldLabel: '客户编号',
    name: 'name',
    anchor: '90%'
});
var nameRouteCustomerPanel = new Ext.form.TextField({
    style: 'margin-left:0px',
    cls: 'key',
    xtype: 'textfield',
    fieldLabel: '客户名称',
    name: 'name',
    anchor: '90%'
});
var searchRelForm = new Ext.form.FormPanel({
    labelAlign: 'left',
    region:'north',
    buttonAlign: 'right',
    bodyStyle: 'padding:5px',
    frame: true,
    height:50,
    labelWidth: 80,
    items: [{
        layout: 'column',   //定义该元素为布局为列布局方式
        border: false,
        items: [{
            columnWidth: .33,
            layout: 'form',
            border: false,
            items: [
                nameRouteCustomerNoPanel
                ]
        }, {
            columnWidth: .33,
            layout: 'form',
            border: false,
            items: [
                nameRouteCustomerPanel
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
                    var name = nameRouteCustomerPanel.getValue();
                    var no = nameRouteCustomerNoPanel.getValue();
                    //alert(name +":"+type);
                    dsRCustomerGrid.baseParams.ChineseName = name;
                    dsRCustomerGrid.baseParams.CustomerId = no;
                    dsRCustomerGrid.load({
                                params : {
                                start : 0,
                                limit : 10
                                } 
                              }); 
                    }
                }]
        },{
            columnWidth: .56,  //该列占用的宽度，标识为20％
            layout: 'form',
            border: false
        }]
    }]

});

/*------实现searchForm的函数 start---------------*/

/*------新增客户选择列表 start --------------*/
var dsRCustomerGrid;
if(dsRCustomerGrid==null){
    dsRCustomerGrid = new Ext.data.Store({
        url:"frmDistributeRoute.aspx?method=getNonCustomers",
        reader:new Ext.data.JsonReader({
            totalProperty:'totalProperty',
	        root:'root'},
	        [
	            { name: "CustomerId" },
			    { name: "CustomerNo" },
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
}

var smRel= new Ext.grid.CheckboxSelectionModel({
	singleSelect:false
});
var rCustomerGrid = new Ext.grid.GridPanel({
	width:'100%',
	height:'100%',
	autoWidth:true,
	autoHeight:true,
	autoScroll:true,
	region: 'center',
	id: '',
	store: dsRCustomerGrid,
	loadMask: {msg:'正在加载数据，请稍侯……'},
	sm:smRel,
	cm: new Ext.grid.ColumnModel([
		smRel,
		new Ext.grid.RowNumberer(),//自动行号
	    { header: "客户ID",dataIndex: 'CustomerId' ,hidden:true,hideable:false},
        { header: "客户编号", width: 60, sortable: true, dataIndex: 'CustomerNo' },
        { header: "客户名称", width: 60, sortable: true, dataIndex: 'ShortName' },
        { header: "联系人", width: 30, sortable: true, dataIndex: 'LinkMan' },
        { header: "联系电话", width: 30, sortable: true, dataIndex: 'LinkTel' },
        { header: "创建时间", width: 60, sortable: true, dataIndex: 'CreateDate',
                renderer: Ext.util.Format.dateRenderer('Y年m月d日') }
		]),
		bbar: new Ext.PagingToolbar({
			pageSize: 10,
			store: dsRCustomerGrid,
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


/*------新增客户选择列表 end --------------*/

/*------开始客户配置界面数据的窗体 Start---------------*/
if(typeof(uploadCtmGridWindow)=="undefined"){//解决创建2个windows问题
	uploadCtmGridWindow = new Ext.Window({
		id:'Customerformwindow',
		title:'客户信息'
		, iconCls: 'upload-win'
		, width: 700
		, height: 450
		, layout: 'border'
		, plain: true
		, modal: true
		, constrain:true
		, resizable: false
		, closeAction: 'hide'
		,autoDestroy :true
		,items:[searchRelForm,rCustomerGrid]
		,buttons: [{
			text: "保存"
			, handler: function() {
				saveCustoemrData();
			}
			, scope: this
		},
		{
			text: "取消"
			, handler: function() { 
				uploadCtmGridWindow.hide();
			}
			, scope: this
		}]});
	}
	uploadCtmGridWindow.addListener("hide",function(){
	    searchRelForm.getForm().reset();
	    rCustomerGrid.getStore().removeAll();   
});
function saveCustoemrData(){
    var sm = rCustomerGrid.getSelectionModel();
    //var selectData = sm.getSelected(); //这个仅仅是对getSelections.itemAt[0]的封装，对于多选不适用
    var records=sm.getSelections();
    
    if (records == null || records.length == 0) 
    {
        Ext.Msg.alert("提示", "请选中一行！");
    }
    else 
    { 
        Ext.Msg.confirm("提示信息", "确认保存？", function callBack(id) {
                //判断是否删除数据
                if (id == "yes") {
                     var array = new Array(records.length);
                    for(var i=0;i<records.length;i++)
                    {
                        array[i] = records[i].get('CustomerId');
                    }
                    Ext.Ajax.request({
                    url: 'frmDistributeRoute.aspx?method=saveCustomerRelInfo',
                        params: {
                            RouteId: currentRouteId ,
                            CustomerId: array.join('-')//传入多项的id串
                        },
                        success: function(resp, opts) {
                            //var data=Ext.util.JSON.decode(resp.responseText);
                            Ext.Msg.alert("提示", "保存成功！");
                            dsGridRouteCustomer.reload();
                            uploadCtmGridWindow.hide();
                        },
                        failure: function(resp, opts) {
                            Ext.Msg.alert("提示", "保存失败！");
                        }
                    });
                }
             });
        
       
    }

}
/*------结束客户配置界面数据的窗体 End---------------*/

})
</script>

</html>

