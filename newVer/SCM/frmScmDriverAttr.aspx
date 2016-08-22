<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmScmDriverAttr.aspx.cs" Inherits="SCM_frmScmDriverAttr" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html>
<head>
<title>驾驶员维护</title><meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<link rel="stylesheet" type="text/css" href="../ext3/resources/css/ext-all.css" />
<script type="text/javascript" src="../ext3/adapter/ext/ext-base.js"></script>
<script type="text/javascript" src="../ext3/ext-all.js"></script>
<script type="text/javascript" src="../js/operateResp.js"></script>
</head>
<body>
<div id='toolbar'></div>
<div id='searchForm'></div>
<div id='dateGrid'></div>
</body>

<%= getComboBoxStore() %>

<script type="text/javascript">
Ext.onReady(function(){
Ext.BLANK_IMAGE_URL = "../ext3/resources/images/default/s.gif";
var saveType="";
/*------实现toolbar的函数 start---------------*/
var Toolbar = new Ext.Toolbar({
	renderTo:"toolbar",
	items:[{
		text:"新增",
		icon:"../Theme/1/images/extjs/customer/add16.gif",
		handler:function(){
		    saveType= 'add';
		    openAddAttrWin();
		}
		},'-',{
		text:"编辑",
		icon:"../Theme/1/images/extjs/customer/edit16.gif",
		handler:function(){
		    saveType= 'save';
		    modifyAttrWin();
		}
		},'-',{
		text:"删除",
		icon:"../Theme/1/images/extjs/customer/delete16.gif",
		handler:function(){
		    deleteAttr();
		}
		},'-',{
		text:"车辆配置",
		icon:"../Theme/1/images/extjs/customer/edit16.gif",
		handler:function(){
		    addVehicle();
		}
	}]
});

/*------结束toolbar的函数 end---------------*/


/*------开始ToolBar事件函数 start---------------*//*-----新增Attr实体类窗体函数----*/
function openAddAttrWin() {
	driverFrom.getForm().reset();
	uploadAttrWindow.show();

    var firstValue = dsNation.getRange()[0].data.DicsCode;//这种方法可以获得第一项的值  
    //firstValue  = dsNation.getAt(0).data.DicsCode;//这种方法也可以获得第一项的值  
    Ext.getCmp('Nation').setValue(dsNation.getAt(0).data.DicsCode);//选中 

}
/*-----编辑Attr实体类窗体函数----*/
function modifyAttrWin() {
	var sm = gridData.getSelectionModel();
	//获取选择的数据信息
	var selectData =  sm.getSelected();
	if(selectData == null){
		Ext.Msg.alert("提示","请选中需要编辑的信息！");
		return;
	}
	uploadAttrWindow.show();
	setFormValue(selectData);
}
/*-----删除Attr实体函数----*/
/*删除信息*/
function deleteAttr()
{
	var sm = gridData.getSelectionModel();
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
				url:'frmScmDriverAttr.aspx?method=deleteAttr',
				method:'POST',
				params:{
					DriverId:selectData.data.DriverId
				},
				success: function(resp,opts){
					Ext.Msg.alert("提示","数据删除成功");
					gridData.getStore().reload();
				},
				failure: function(resp,opts){
					Ext.Msg.alert("提示","数据删除失败");
				}
			});
		}
	});
}
//配置与车辆的对应关系
function addVehicle()
{
    var sm = gridData.getSelectionModel();
	//获取选择的数据信息
	var selectData =  sm.getSelected();
	//如果没有选择，就提示需要选择数据信息
	if(selectData == null){
		Ext.Msg.alert("提示","请选中需要配置的驾驶员信息！");
		return;
	}
	//
	uploadVehicleWindow.show();
	setGridValue(selectData);
}
/*------实现searchForm的函数 start---------------*/
var namePanel = new Ext.form.TextField({
    style: 'margin-left:0px',
    cls: 'key',
    xtype: 'textfield',
    fieldLabel: '驾驶员名称',
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
                namePanel
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
                    var name=namePanel.getValue();
                    //alert(name +":"+type);
                    gridDataData.baseParams.DriverName = name;
                    gridDataData.load({
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

/*------实现FormPanle的函数 start---------------*/
var driverFrom=new Ext.form.FormPanel({
	url:'',
	//renderTo:'divForm',
	frame: true,
    title: '',
    labelAlign: 'left',
    buttonAlign: 'right',
    bodyStyle: 'padding:5px',
    labelWith: 55,
	items:[
	{
	    layout:'column',
	    border: false,
	    items:[
	    {
	        layout:'form',
	        columnWidth:.5,
	        border: false,
	        items:[
	        {
	            xtype:'hidden',
			    fieldLabel:'驾驶员标识',
			    name:'DriverId',
			    id:'DriverId',
			    hidden:true,
			    hideLabel:true
	        },
	        {
	            xtype:'textfield',
			    fieldLabel:'姓名*',
			    anchor:'90%',
			    name:'DriverName',
			    id:'DriverName'
	        }
	        ]
	    },
	    {
	        layout:'form',
	        columnWidth:.5,
	        border: false,
	        items:[
	        {
	            xtype:'hidden',
	            fieldLabel:'性别',
			    name:'Gender',
			    id:'Gender',
			    hidden:true,
			    hideLabel:true
	        },
	        {
	            xtype:'radiogroup',
			    fieldLabel:'性别',
			    anchor:'90%',
			    id:'distinction',
			    name:'distinction',
			    items: [
                    {boxLabel: '男', id:'male', name: 'Gender', checked: true},
                    {boxLabel: '女', id:'female', name: 'Gender'}
                ],
                listeners:{
                change: function(el, checked) { 
                        if(Ext.getCmp('male').getValue())
                            Ext.getCmp('Gender').setValue(1);
                        if(Ext.getCmp('female').getValue())
                            Ext.getCmp('Gender').setValue(0); 
                        //alert(Ext.getCmp('Gender').getValue());                  
                   }
                }
	        }
	        ]
	    }
	    ]
	},
	{
	    layout:'column',
	    border: false,
	    items:[
	    {
	        layout:'form',
	        columnWidth:.5,
	        border: false,
	        items:[
	        {
	            xtype:'textfield',
			    fieldLabel:'联系电话*',
			    anchor:'90%',
			    name:'Tel',
			    id:'Tel'
	        }
	        ]
	    },
	    {
	        layout:'form',
	        columnWidth:.5,
	        border: false,
	        items:[
	        {
	            xtype:'textfield',
			    fieldLabel:'身份证号',
			    anchor:'90%',
			    name:'IdentityCard',
			    id:'IdentityCard'
	        }
	        ]
	    }
	    ]
	},
	{
	    layout:'column',
	    border: false,
	    items:[
	    {
	        layout:'form',
	        columnWidth:.5,
	        border: false,
	        items:[
	        {
	            xtype:'textfield',
			    fieldLabel:'住址',
			    anchor:'90%',
			    name:'IdAddress',
			    id:'IdAddress'
	        }
	        ]
	    },
	    {
	        layout:'form',
	        columnWidth:.5,
	        border: false,
	        items:[
	        {
	            xtype:'combo',
			    fieldLabel:'民族',
			    anchor:'90%',
			    name:'Nation',
			    id:'Nation',
			    store: dsNation,
			    displayField:'DicsName',
			    valueField:'DicsCode',
			    mode:'local',
			    editable:false,
			    triggerAction:'all'
	        }
	        ]
	    }
	    ]
	},
	{
	    layout:'column',
	    border: false,
	    items:[
	    {
	        layout:'form',
	        columnWidth:.5,
	        border: false,
	        items:[
	        {
	            xtype:'textfield',
			    fieldLabel:'籍贯',
			    anchor:'90%',
			    name:'NationPlace',
			    id:'NationPlace'
	        }
	        ]
	    },
	    {
	        layout:'form',
	        columnWidth:.5,
	        border: false,
	        items:[
	        {
	            xtype:'textfield',
			    fieldLabel:'驾驶证号*',
			    anchor:'90%',
			    name:'DriveCard',
			    id:'DriveCard'
	        }
	        ]
	    }
	    ]
	},
	{
	    layout:'column',
	    border: false,
	    items:[
	    {
	        layout:'form',
	        columnWidth:1,
	        border: false,
	        items:[
	        {
	            xtype: 'combo',
                fieldLabel: '装卸单位',
                anchor: '80%',
                id: 'LoadCompId', 
                displayField: 'Name',
                valueField: 'Id',
                editable: false,
                store: dsLoadCompanyList,
                mode: 'local',
                triggerAction: 'all'
	        }
	        ]
	    }
	    ]
	},
	{
	    layout:'column',
	    border: false,
	    items:[
	    {
	        layout:'form',
	        columnWidth:1,
	        border: false,
	        items:[
	        {
	            xtype:'textarea',
			    fieldLabel:'备注',
			    anchor:'90%',
			    name:'Remark',
			    id:'Remark'
	        }
	        ]
	    }
	    ]
	}
	]
});
/*------FormPanle的函数结束 End---------------*/

/*------开始界面数据的窗体 Start---------------*/
if(typeof(uploadAttrWindow)=="undefined"){//解决创建2个windows问题
	uploadAttrWindow = new Ext.Window({
		id:'Attrformwindow',
		title:'驾驶员信息维护'
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
		,items:driverFrom
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
				uploadAttrWindow.hide();
			}
			, scope: this
		}]});
	}
	uploadAttrWindow.addListener("hide",function(){
	    driverFrom.getForm().reset();
});


/*------开始获取界面数据的函数 start---------------*/
function saveUserData()
{
    if(saveType == 'add')
        saveType = 'addAttr';
    if(saveType == 'save')
        saveType = 'saveAttr';
    var gender = 0; 
    if (Ext.getCmp('male').getValue())
        gender = 1;
 
	Ext.Ajax.request({
		url:'frmScmDriverAttr.aspx?method='+saveType,
		method:'POST',
		params:{
			DriverId:Ext.getCmp('DriverId').getValue(),
			DriverName:Ext.getCmp('DriverName').getValue(),
			Gender:gender,
			Tel:Ext.getCmp('Tel').getValue(),
			IdentityCard:Ext.getCmp('IdentityCard').getValue(),
			IdAddress:Ext.getCmp('IdAddress').getValue(),
			Nation:Ext.getCmp('Nation').getValue(),
			NationPlace:Ext.getCmp('NationPlace').getValue(),
			DriveCard:Ext.getCmp('DriveCard').getValue(),
			LoadCompId:Ext.getCmp('LoadCompId').getValue(),
			Remark:Ext.getCmp('Remark').getValue(),
			IsActive:1
			},		
		    success: function(resp,opts){ 
                            if( checkExtMessage(resp) ) 
                                    uploadAttrWindow.hide();
                                    gridData.getStore().reload();
                                   //uploadAttrWindow.hide();
                           },
            failure: function(resp,opts){  Ext.Msg.alert("提示","保存失败");     }
		    });
		}
/*------结束获取界面数据的函数 End---------------*/

/*------开始界面数据的函数 Start---------------*/
function setFormValue(selectData)
{
	Ext.Ajax.request({
		url:'frmScmDriverAttr.aspx?method=getattr',
		params:{
			DriverId:selectData.data.DriverId
		},
	success: function(resp,opts){
		var data=Ext.util.JSON.decode(resp.responseText);
		Ext.getCmp("DriverId").setValue(data.DriverId);
		Ext.getCmp("DriverName").setValue(data.DriverName);
		if(data.Gender=="1")
		    Ext.getCmp("male").setValue(true);
		else
		    Ext.getCmp("female").setValue(true);
		Ext.getCmp("Tel").setValue(data.Tel);
		Ext.getCmp("IdentityCard").setValue(data.IdentityCard);
		Ext.getCmp("IdAddress").setValue(data.IdAddress);
		Ext.getCmp("Nation").setValue(data.Nation);
		Ext.getCmp("NationPlace").setValue(data.NationPlace);
		Ext.getCmp("DriveCard").setValue(data.DriveCard);
		Ext.getCmp("Remark").setValue(data.Remark);
		Ext.getCmp("LoadCompId").setValue(data.LoadCompId);
	},
	failure: function(resp,opts){
		Ext.Msg.alert("提示","获取用户信息失败");
	}
	});
}
/*------结束设置界面数据的函数 End---------------*/

/*------开始获取数据的函数 start---------------*/
var gridDataData = new Ext.data.Store
({
url: 'frmScmDriverAttr.aspx?method=getAttrlist',
reader:new Ext.data.JsonReader({
	totalProperty:'totalProperty',
	root:'root'
},[
	{
		name:'DriverId'
	},
	{
		name:'DriverName'
	},
	{
		name:'LoadCompId'
	},
	{
		name:'Gender'
	},
	{
		name:'Tel'
	},
	{
		name:'IdentityCard'
	},
	{
		name:'IdAddress'
	},
	{
		name:'Nation'
	},
	{
		name:'NationPlace'
	},
	{
		name:'DriveCard'
	},
	{
		name:'Remark'
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
	singleSelect:true
});
var gridData = new Ext.grid.GridPanel({
	el: 'dateGrid',
	width:'100%',
	height:'100%',
	autoWidth:true,
	autoHeight:true,
	autoScroll:true,
	layout: 'fit',
	id: '',
	store: gridDataData,
	loadMask: {msg:'正在加载数据，请稍侯……'},
	sm:sm,
	cm: new Ext.grid.ColumnModel([
		sm,
		new Ext.grid.RowNumberer(),//自动行号
		{
			header:'驾驶员标识',
			dataIndex:'DriverId',
			id:'DriverId',
			hidden:true,
			hideable:false
		},
		{
			header:'装卸公司',
			dataIndex:'LoadCompId',
			width:150,
			id:'LoadCompId',
			renderer:{
			    fn:function(val, params, record) {
			if (val ==0) return val;
		        if (dsLoadCompanyList.getCount() == 0) {
		            dsLoadCompanyList.load();
		        }
		        dsLoadCompanyList.each(function(r) {
		            if (val == r.data['Id']) {
		                val = r.data['Name'];
		                return;
		            }
		        });
		        return val;
		    }
			}
		},
		{
			header:'姓名',
			dataIndex:'DriverName',
			width:80,
			id:'DriverName'
		},
		{
			header:'性别',
			dataIndex:'Gender',
			id:'Gender',
			width:50,
			renderer:{
			    fn:function(v){
			        if(v=='0') return '女';
			        if(v=='1') return '男';
			    }
			}
		},
		{
			header:'联系电话',
			width:80,
			dataIndex:'Tel',
			id:'Tel'
		},
		{
			header:'身份证号',
			width:80,
			dataIndex:'IdentityCard',
			id:'IdentityCard'
		},
		{
			header:'住址',
			width:150,
			dataIndex:'IdAddress',
			id:'IdAddress'
		},
		{
			header:'民族',
			width:50,
			dataIndex:'Nation',
			id:'Nation',
			renderer:{
			    fn:function(val, params, record) {
		        if (dsNation.getCount() == 0) {
		            dsNation.load();
		        }
		        dsNation.each(function(r) {
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
			header:'籍贯',
			width:50,
			dataIndex:'NationPlace',
			id:'NationPlace'
		},
		{
			header:'驾驶证号',
			hidden:true,
			dataIndex:'DriveCard',
			id:'DriveCard'
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
var gridVehicleDataData = new Ext.data.Store
({
url: 'frmScmDriverAttr.aspx?method=getVehiclelist',
reader:new Ext.data.JsonReader({
	totalProperty:'totalProperty',
	root:'root'
},[
	{		name:'DriverId'	},
	{		name:'VehicleId'	},
	{		name:'VehicleName'	},
	{		name:'VehicleNo'	},
	{		name:'VehicleType'	},
	{		name:'VehicleTon'	},
	{		name:'MinQty'	},
	{		name:'MaxQty'	},
	{		name:'OperId'	},
	{		name:'CreateDate'	},
	{		name:'Remark'	}
	])
	,
	listeners:
	{
		scope:this,
		load:function(){
		}
	}
});
var vsm= new Ext.grid.CheckboxSelectionModel({
	singleSelect:true
});
var vehicleGrid = new Ext.grid.GridPanel({
	width:'100%',
	height:'100%',
	autoWidth:true,
	autoHeight:true,
	autoScroll:true,
	layout: 'fit',
	store: gridVehicleDataData,
	loadMask: {msg:'正在加载数据，请稍侯……'},
	sm:vsm,
	cm: new Ext.grid.ColumnModel([
		vsm,
		new Ext.grid.RowNumberer(),//自动行号
		{
			header:'标识',
			dataIndex:'RelId',
			id:'RelId',
			hidden:true,
			hideable:false
		},
		{
			header:'车辆名称',
			dataIndex:'VehicleName',
			width:150,
			id:'VehicleName'
		},
		{
			header:'车牌号',
			dataIndex:'VehicleNo',
			width:80,
			id:'VehicleNo'
		},
		{
			header:'车型',
			dataIndex:'VehicleType',
			id:'VehicleType',
			width:50
		},
		{
			header:'载重量(吨)',
			width:80,
			dataIndex:'VehicleTon',
			id:'VehicleTon'
		},
		{
			header:'备注',
			width:150,
			dataIndex:'Remark',
			id:'Remark'
		}		]),
		tbar: new Ext.Toolbar({
	        items:[{
		        text:"新增",
		        icon:"../Theme/1/images/extjs/customer/add16.gif",
		        handler:function(){
                    openScmVehicleWindowShow();
		        }
		        },'-',{
		        text:"删除",
		        icon:"../Theme/1/images/extjs/customer/delete16.gif",
		        handler:function(){
		            deleteRelInfo();
		        }
	        }]
        }),
		bbar: new Ext.PagingToolbar({
			pageSize: 10,
			store: gridVehicleDataData,
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

if(typeof(uploadVehicleWindow)=="undefined"){//解决创建2个windows问题
	uploadVehicleWindow = new Ext.Window({
		id:'vecleformwindow',
		title:'车辆信息维护'
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
		,items:vehicleGrid
		,buttons: [{
			text: "取消"
			, handler: function() { 
				uploadVehicleWindow.hide();
			}
			, scope: this
		}]});
	}
	uploadVehicleWindow.addListener("hide",function(){
	    vehicleGrid.getStore().removeAll();
});

function setGridValue( record)
{
    gridVehicleDataData.load({params:{start:0,limit:10,DriverId:record.data.DriverId}});
}
function deleteRelInfo()
{
	var sm = vehicleGrid.getSelectionModel();
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
				url:'frmScmDriverAttr.aspx?method=deleteRelInfo',
				method:'POST',
				params:{
					DriverId:selectData.data.RelId
				},
				success: function(resp,opts){
					Ext.Msg.alert("提示","数据删除成功");
					vehicleGrid.getStore().reload();
				},
				failure: function(resp,opts){
					Ext.Msg.alert("提示","数据删除失败");
				}
			});
		}
	});
}

/************************************************/
var gridScmVehicleData = new Ext.data.Store
        ({
        url: 'frmVehicleAttr.aspx?method=getattrlist',
        reader:new Ext.data.JsonReader({
	        totalProperty:'totalProperty',
	        root:'root'
        },[
	        {		        name:'VehicleId'	        },
	        {		        name:'VehicleName'	        },
	        {		        name:'OrgId'	        },
	        {		        name:'VehicleNo'	        },
	        {		        name:'VehicleType'	        },
	        {		        name:'VehicleTon'	        },
	        {		        name:'MinQty'	        },
	        {		        name:'MaxQty'	        },
	        {		        name:'DefDlvId'	        },
	        {		        name:'DefDriver'	        },
	        {		        name:'OperId'	        },
	        {		        name:'CreateDate'	        },
	        {		        name:'UpdateDate'	        },
	        {		        name:'OwnerId'	        },
	        {		        name:'Remark'	        },
	        {		        name:'IsActive'	        }	])
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

        var scmsm= new Ext.grid.CheckboxSelectionModel({
	        singleSelect:true
        });
        var scmVehicleGrid = new Ext.grid.GridPanel({
	        width:'100%',
	        height:'100%',
	        autoWidth:true,
	        autoHeight:true,
	        autoScroll:true,
	        layout: 'fit',
	        store: gridScmVehicleData,
	        loadMask: {msg:'正在加载数据，请稍侯……'},
	        sm:scmsm,
	        cm: new Ext.grid.ColumnModel([
		        scmsm,
		        new Ext.grid.RowNumberer(),//自动行号
		        {
			        header:'车辆标识',
			        dataIndex:'VehicleId',
			        id:'VehicleId'
		        },
		        {
			        header:'名称',
			        dataIndex:'VehicleName',
			        id:'VehicleName'
		        },
		        {
			        header:'车牌号',
			        dataIndex:'VehicleNo',
			        id:'VehicleNo'
		        },
		        {
			        header:'车型',
			        dataIndex:'VehicleType',
			        id:'VehicleType'
		        },
		        {
			        header:'载重量(吨)',
			        dataIndex:'VehicleTon',
			        id:'VehicleTon'
		        },
		        {
			        header:'下限容量(吨)',
			        dataIndex:'MinQty',
			        id:'MinQty'
		        },
		        {
			        header:'上限容量(吨)',
			        dataIndex:'MaxQty',
			        id:'MaxQty'
		        },
		        {
			        header:'创建时间',
			        dataIndex:'CreateDate',
			        id:'CreateDate',
			       renderer: Ext.util.Format.dateRenderer('Y年m月d日')
		        }		
		        ]),
		        bbar: new Ext.PagingToolbar({
			        pageSize: 10,
			        store: gridScmVehicleData,
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
if(typeof(uploadScmVehicleWindow)=="undefined"){//解决创建2个windows问题
	uploadScmVehicleWindow = new Ext.Window({
		id:'scmvecleformwindow',
		title:'车辆信息维护'
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
		,items:scmVehicleGrid
		,buttons: [{
			text: "保存"
			, handler: function() { 
				saveScmVehicleData();
				}
			},{
			text: "取消"
			, handler: function() { 
				uploadScmVehicleWindow.hide();
			}
			, scope: this
		}]});
	}
	uploadScmVehicleWindow.addListener("hide",function(){
	    scmVehicleGrid.getStore().removeAll();
		gridVehicleDataData.reload();
});
function openScmVehicleWindowShow()
{
    uploadScmVehicleWindow.show();
    gridScmVehicleData.load({params:{start:0,limit:10}});
}
function saveScmVehicleData()
{
    var sm = gridData.getSelectionModel();
	//获取选择的数据信息
	var selectData =  sm.getSelected();
	
	var vscsm = scmVehicleGrid.getSelectionModel();
	//获取选择的数据信息
	var selectVehicle =  vscsm.getSelected();;
    Ext.Ajax.request({
		url:'frmScmDriverAttr.aspx?method=saveDriverVehicleRel',
		method:'POST',
		params:{
			DriverId:selectData.data.DriverId,
			VehicleId:selectVehicle.data.VehicleId
		},		
	    success: function(resp,opts){ 
            if( checkExtMessage(resp) ) 
                uploadVehicleWindow.hide();               
           },
        failure: function(resp,opts){  Ext.Msg.alert("提示","保存失败");     }
	    });
}


})
</script>



</html>
