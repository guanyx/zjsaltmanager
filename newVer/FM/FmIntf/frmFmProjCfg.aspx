<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmFmProjCfg.aspx.cs" Inherits="FM_FmIntf_frmFmProjCfg" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html>
<head>
<title>财务数据交换方案配置</title><meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<link rel="stylesheet" type="text/css" href="../../ext3/resources/css/ext-all.css" />
<script type="text/javascript" src="../../ext3/adapter/ext/ext-base.js"></script>
<script type="text/javascript" src="../../ext3/ext-all.js"></script>
</head>
<body>
<div id='toolbar'></div>
<div id='searchForm'></div>
<div id='dataGrid'></div>

</body>
<%= getComboBoxStore() %>
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
		    saveType = 'add';
		    openAddCfgWin();
		}
		},'-',{
		text:"编辑",
		icon:"../../Theme/1/images/extjs/customer/edit16.gif",
		handler:function(){
		    saveType = 'save';
		    modifyCfgWin();
		}
		},'-',{
		text:"删除",
		icon:"../../Theme/1/images/extjs/customer/delete16.gif",
		handler:function(){
		    deleteCfg();
		}
		},'-',{
		text:"字段配置",
		icon:"../../Theme/1/images/extjs/customer/view16.gif",
		handler:function(){
		    viewCfg();
		}
	}]
});

/*------结束toolbar的函数 end---------------*/


/*------开始ToolBar事件函数 start---------------*//*-----新增Cfg实体类窗体函数----*/
function openAddCfgWin() {
	uploadCfgWindow.show();
}
/*-----编辑Cfg实体类窗体函数----*/
function modifyCfgWin() {
	var sm = gridData.getSelectionModel();
	//获取选择的数据信息
	var selectData =  sm.getSelected();
	if(selectData == null){
		Ext.Msg.alert("提示","请选中需要编辑的信息！");
		return;
	}
	uploadCfgWindow.show();
	setFormValue(selectData);
}
/*-----删除Cfg实体函数----*/
/*删除信息*/
function deleteCfg()
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
				url:'frmFmProjCfg.aspx?method=deleteCfg',
				method:'POST',
				params:{
					ProjectNo:selectData.data.ProjectNo
				},
				success: function(resp,opts){
					Ext.Msg.alert("提示","数据删除成功");
					gridData.getStore().remove(selectData);
				},
				failure: function(resp,opts){
					Ext.Msg.alert("提示","数据删除失败");
				}
			});
		}
	});
}
/*-----字段相关属性Cfg实体函数----*/
/*字段相关属性配置信息*/
function viewCfg() {	
	var sm = gridData.getSelectionModel();
	//获取选择的数据信息
	var selectData =  sm.getSelected();
	//如果没有选择，就提示需要选择数据信息
	if(selectData == null){
		Ext.Msg.alert("提示","请选中需要配置的信息！");
		return;
	}
	uploadGridCfgWindow.show();
	gridField.getStore().baseParams.ProjectNo=selectData.data.ProjectNo;
	gridField.getStore().load({
	    params:{
	        limit:15,
	        start:0
	    }
	});
}

/*------实现FormPanle的函数 start---------------*/
var dsOrgList ;
if (dsOrgList == null) { //防止重复加载
    dsOrgList = new Ext.data.JsonStore({
        totalProperty: "result",
        root: "root",
        url: 'frmFmProjCfg.aspx?method=getOrgList',
        fields: ['OrgId', 'OrgName']
    });
    dsOrgList.load({
        params:{
            limit:100,
            start:0
        },
     callback:function(v,p){
        var gs =Ext.getCmp('prjOrg');
        gs.setValue(<% =ZJSIG.UIProcess.ADM.UIAdmUser.OrgID(this)%>);
        gs.setDisabled(true);
     }
    });
}    

var projectCfg = new Ext.form.FormPanel({
	url:'',
	//renderTo:'divForm',
	frame:true,
	title:'',
	labelWidth:80,
	items:[
		{
			xtype:'hidden',
			fieldLabel:'方案序号',
			name:'ProjectNo',
			id:'ProjectNo',
			hidden:true,
			hideLabel:true
		}
,       {
			xtype:'textfield',
			fieldLabel:'方案名称',
			columnWidth:1,
			anchor:'95%',
			name:'ProjectName',
			id:'ProjectName'
		}
,       {
			xtype:'combo',
			fieldLabel:'方案类型',
			columnWidth:1,
			anchor:'95%',
			name:'BillType',
			id:'BillType',
			store:dsBillType,
			displayField:'DicsName',
			valueField:'DicsCode',
			mode:'local',
		    triggerAction:'all',
		    disabled:true,
		    value:dsBillType.getAt(0).data.DicsCode
		}
,       {
			xtype:'combo',
			fieldLabel:'字段分隔符',
			columnWidth:1,
			anchor:'95%',
			name:'FieldSeparator',
			id:'FieldSeparator',
			store:dsFieldSparator,
			displayField:'DicsName',
			valueField:'DicsCode',
			mode:'local',
		    triggerAction:'all',
		    editable:false
		}
,       {
			xtype:'combo',
			fieldLabel:'单据分隔符',
			columnWidth:1,
			anchor:'95%',
			name:'BillSeparator',
			id:'BillSeparator',
			store:dsBillSparator,
			displayField:'DicsName',
			valueField:'DicsCode',
			mode:'local',
		    triggerAction:'all',
		    editable:false
		}
,		{
			xtype:'combo',
			fieldLabel:'方案归属组织',
			columnWidth:1,
			anchor:'95%',
			name:'ProjectOrg',
			id:'ProjectOrg',
			store:dsOrgList,
			displayField:'OrgName',
			valueField:'OrgId',
			mode:'local',
		    triggerAction:'all',
		    editable:false,
		    value:<% =ZJSIG.UIProcess.ADM.UIAdmUser.OrgID(this)%>,
		    disabled:true
		}
,       {
		    layout:'column',
		    items:[
    		{
    		    layout:'form',
    		    columnWidth:.5,
    		    items:[{
			        xtype:'combo',
			        fieldLabel:'传输方向',			    
			        anchor:'90%',
			        name:'TransType',
			        id:'TransType',
			        store:[[0,'数据导出'],[1,'数据导入']],
			        mode:'local',
			        triggerAction:'all',
			        editable:false
			    }]
		    }
    ,		{
                layout:'form',
    		    columnWidth:.5,
    		    items:[{
			        xtype:'combo',
			        fieldLabel:'启用状态',
			        anchor:'90%',
			        name:'PStatus',
			        id:'PStatus',
			        store:[[0,'启用'],[1,'禁用']],
			        mode:'local',
			        triggerAction:'all',
			        editable:false
			    }]
		    }
		    ]
		}
,		{
			xtype:'textarea',
			fieldLabel:'备注',
			columnWidth:1,
			anchor:'95%',
			name:'Notes',
			id:'Notes'
		}
]
});
/*------FormPanle的函数结束 End---------------*/

/*------开始界面数据的窗体 Start---------------*/
if(typeof(uploadCfgWindow)=="undefined"){//解决创建2个windows问题
	uploadCfgWindow = new Ext.Window({
		id:'formwindow',
		title:'配置方案维护'
		, iconCls: 'upload-win'
		, width: 400
		, height: 350
		, layout: 'fit'
		, plain: true
		, modal: true
		, constrain:true
		, resizable: false
		, closeAction: 'hide'
		,autoDestroy :true
		,items:projectCfg
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
				uploadCfgWindow.hide();
			}
			, scope: this
		}]});
	}
	uploadCfgWindow.addListener("hide",function(){
	    projectCfg.getForm().reset();
});

/*------开始获取界面数据的函数 start---------------*/
function saveUserData()
{
    if(saveType == 'add')
        saveType = 'addCfg';
    else if(saveType =='save')
        saveType = 'saveCfg';
	Ext.Ajax.request({
		url:'frmFmProjCfg.aspx?method='+saveType,
		method:'POST',
		params:{
			ProjectNo:Ext.getCmp('ProjectNo').getValue(),
			ProjectName:Ext.getCmp('ProjectName').getValue(),
			BillType:Ext.getCmp('BillType').getValue(),
			FieldSeparator:Ext.getCmp('FieldSeparator').getValue(),
			BillSeparator:Ext.getCmp('BillSeparator').getValue(),
			ProjectOrg:Ext.getCmp('ProjectOrg').getValue(),
			TransType:Ext.getCmp('TransType').getValue(),
			Status:Ext.getCmp('PStatus').getValue(),
			Notes:Ext.getCmp('Notes').getValue()
					},
		success: function(resp,opts){
			Ext.Msg.alert("提示","保存成功");
			gridData.getStore().reload();
			uploadCfgWindow.hide();
		},
		failure: function(resp,opts){
			Ext.Msg.alert("提示","保存失败");
		}
		});
		}
/*------结束获取界面数据的函数 End---------------*/


/*------开始查询界面数据的函数 start---------------*/
var prjNamePanel = new Ext.form.TextField({
    
});
                    
var orgIdPanel = new Ext.form.ComboBox({  
    
});

var serchPrjform = new Ext.FormPanel({
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
            items: [{
                xtype: 'combo',
                id:'prjOrg',
                name:'prjOrg',
                fieldLabel: '组织',
                store: dsOrgList,  
                typeAhead: false,
                loadingText: 'Searching...',  
                displayField:'OrgName',
                valueField:'OrgId',
                mode:'local',
                triggerAction:'all',
                editable:false
            }]
        }, {
            columnWidth: .33,
            layout: 'form',
            border: false,
            items: [{
                style: 'margin-left:0px',
                cls: 'key',
                xtype: 'textfield',
                fieldLabel: '方案名称',
                name: 'prjName',
                id:'prjName',
                anchor: '90%'
                }]
        }, {
            columnWidth: .10,
            layout: 'form',
            border: false,
            items: [{ cls: 'key',
                xtype: 'button',
                text: '查询',
                anchor: '50%',
                handler :function(){
                
                var prjOrg=Ext.getCmp('prjOrg').getValue();
                var prjName=Ext.getCmp('prjName').getValue();
                
                dsProjCfg.baseParams.OrgId=prjOrg;
                dsProjCfg.baseParams.ProjectName=prjName;                
                dsProjCfg.baseParams.BillType=dsBillType.getAt(0).data.DicsCode;
                dsProjCfg.load({
                            params : {
                            start : 0,
                            limit : 10
                            } });
                }
            }]
        }]
    }]
});

/*------结束查询界面数据的函数 end---------------*/

/*------开始界面数据的函数 Start---------------*/
function setFormValue(selectData)
{
	Ext.Ajax.request({
		url:'frmFmProjCfg.aspx?method=getCfg',
		params:{
			ProjectNo:selectData.data.ProjectNo
		},
	success: function(resp,opts){
		var data=Ext.util.JSON.decode(resp.responseText);
		Ext.getCmp("ProjectNo").setValue(data.ProjectNo);
		Ext.getCmp("ProjectName").setValue(data.ProjectName);
		Ext.getCmp("BillType").setValue(data.BillType);
		Ext.getCmp("FieldSeparator").setValue(data.FieldSeparator);
		Ext.getCmp("BillSeparator").setValue(data.BillSeparator);
        Ext.getCmp('ProjectOrg').setValue(data.ProjectOrg);
		Ext.getCmp("TransType").setValue(data.TransType);
		Ext.getCmp("PStatus").setValue(data.Status);
		Ext.getCmp("Notes").setValue(data.Notes);
	},
	failure: function(resp,opts){
		Ext.Msg.alert("提示","获取信息失败");
	}
	});
}
/*------结束设置界面数据的函数 End---------------*/

/*------开始获取数据的函数 start---------------*/
var dsProjCfg = new Ext.data.Store
({
url: 'frmFmProjCfg.aspx?method=getCfgList',
reader:new Ext.data.JsonReader({
	totalProperty:'totalProperty',
	root:'root'
},[
	{		name:'ProjectNo'	},
	{		name:'ProjectName'	},
	{		name:'BillType'	},
	{		name:'FieldSeparator'	},
	{		name:'BillSeparator'	},
	{		name:'ProjectOrg'	},
	{		name:'TransType'	},
	{		name:'Status'	},
	{		name:'Notes'	},
	{		name:'OperId'	},
	{		name:'OrgId'	},
	{		name:'OwerId'	}	
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
	el: 'dataGrid',
	width:'100%',
	height:'100%',
	autoWidth:true,
	autoHeight:true,
	autoScroll:true,
	layout: 'fit',
	id: 'gridData',
	store: dsProjCfg ,
	loadMask: {msg:'正在加载数据，请稍侯……'},
	sm:sm,
	cm: new Ext.grid.ColumnModel([
		sm,
		new Ext.grid.RowNumberer(),//自动行号
		{
			header:'方案序号',
			dataIndex:'ProjectNo',
			id:'ProjectNo',
			hidden:true,
			hideable:false
		},
		{
			header:'方案名称',
			dataIndex:'ProjectName',
			id:'ProjectName'
		},
		{
			header:'方案类型',
			dataIndex:'BillType',
			id:'BillType',
			renderer: function(val, params, record) {
		        if (dsBillType.getCount() == 0) {
		            dsBillType.load();
		        }
		        dsBillType.each(function(r) {
		            if (val == r.data['DicsCode']) {
		                val = r.data['DicsName'];
		                return;
		            }
		        });
		        return val;
		    }
		},
		{
			header:'字段分隔符',
			dataIndex:'FieldSeparator',
			id:'FieldSeparator',
			renderer: function(val, params, record) {
		        if (dsFieldSparator.getCount() == 0) {
		            dsFieldSparator.load();
		        }
		        dsFieldSparator.each(function(r) {
		            if (val == r.data['DicsCode']) {
		                val = r.data['DicsName'];
		                return;
		            }
		        });
		        return val;
		    }
		},
		{
			header:'单据分隔符',
			dataIndex:'BillSeparator',
			id:'BillSeparator',
			renderer: function(val, params, record) {
		        if (dsBillSparator.getCount() == 0) {
		            dsBillSparator.load();
		        }
		        dsBillSparator.each(function(r) {
		            if (val == r.data['DicsCode']) {
		                val = r.data['DicsName'];
		                return;
		            }
		        });
		        return val;
		    }
		},
		{
			header:'方案归属组织',
			dataIndex:'ProjectOrg',
			id:'ProjectOrg',
			renderer: function(val, params, record) {
		        if (dsOrgList.getCount() == 0) {
		            dsOrgList.load();
		        }
		        dsOrgList.each(function(r) {
		            if (val == r.data['OrgId']) {
		                val = r.data['OrgName'];
		                return;
		            }
		        });
		        return val;
		    }
		},
		{
			header:'传输方向',
			dataIndex:'TransType',
			id:'TransType',
			renderer:{
			    fn:function(v){
			        if(v==1)return '导入';
			        return '导出';
			    }
			}
		},
		{
			header:'启用状态',
			dataIndex:'Status',
			id:'Status',
			renderer:{
			    fn:function(v){
			        if(v==1)return '禁用';
			        return '启用';
			    }
			}
		}		]),
		bbar: new Ext.PagingToolbar({
			pageSize: 10,
			store: dsProjCfg,
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

/*------------------字段配置页面-------------------*/
var saveFieldType;
var dsFieldStore = new Ext.data.Store
({
url: 'frmFmProjCfg.aspx?method=getFieldList',
reader:new Ext.data.JsonReader({
	totalProperty:'totalProperty',
	root:'root'
},[
	{		name:'FieldId'	},
	{		name:'ProjectNo'	},
	{		name:'ProjectName'	},
	{		name:'ErpFeild'	},
	{		name:'ErpFeildname'	},
	{		name:'ErpFtype'	},
	{		name:'ErpForder'	},
	{		name:'ErpFlength'	},
	{		name:'ErpFprecision'	},
	{		name:'ErpFdformat'	},
	{		name:'FinanceFeild'	},
	{		name:'FinanceFname'	},
	{		name:'FinanceForder'	},
	{		name:'FinanceFtype'	},
	{		name:'FinanceFlength'	},
	{		name:'FinanceFprecision'	},
	{		name:'FinanceFdformat'	},
	{		name:'Status'	},
	{		name:'Notes'	}
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

var smField= new Ext.grid.CheckboxSelectionModel({
	singleSelect:true
});
var gridField = new Ext.grid.GridPanel({
	width:'100%',
	height:'100%',
	autoWidth:true,
	autoHeight:true,
	autoScroll:true,
	layout: 'fit',
	id: 'gridField',
	store: dsFieldStore,
	loadMask: {msg:'正在加载数据，请稍侯……'},
	sm:smField,
	cm: new Ext.grid.ColumnModel([
		smField,
		new Ext.grid.RowNumberer(),//自动行号
		{
			header:'方案序号',
			dataIndex:'FieldId',
			id:'FieldId',
			hidden:true,
			hideable:false
		},
		{
			header:'方案序号',
			dataIndex:'ProjectNo',
			id:'ProjectNo',
			hidden:true,
			hideable:false
		},
		{
			header:'业务字段',
			dataIndex:'ErpFeild',
			id:'ErpFeild'
		},
		{
			header:'业务字段描述',
			dataIndex:'ErpFeildname',
			id:'ErpFeildname',
			hidden:true,
			hideable:false
		},
		{
			header:'业务字段类型',
			dataIndex:'ErpFtype',
			id:'ErpFtype',
			renderer: function(val, params, record) {
		        if (dsFieldType.getCount() == 0) {
		            dsFieldType.load();
		        }
		        dsFieldType.each(function(r) {
		            if (val == r.data['DicsCode']) {
		                val = r.data['DicsName'];
		                return;
		            }
		        });
		        return val;
		    }
		},
		{
			header:'业务字段顺序',
			dataIndex:'ErpForder',
			id:'ErpForder',
			hidden:true,
			hideable:false
		},
		{
			header:'业务字段长度',
			dataIndex:'ErpFlength',
			id:'ErpFlength',
			hidden:true,
			hideable:false
		},
		{
			header:'业务字段精度',
			dataIndex:'ErpFprecision',
			id:'ErpFprecision',
			hidden:true,
			hideable:false
		},
		{
			header:'业务字段日期格式',
			dataIndex:'ErpFdformat',
			id:'ErpFdformat',
			hidden:true,
			hideable:false
		},
		{
			header:'财务字段',
			dataIndex:'FinanceFeild',
			id:'FinanceFeild'
		},
		{
			header:'财务字段类型',
			dataIndex:'FinanceFtype',
			id:'FinanceFtype',
			renderer: function(val, params, record) {
		        if (dsFieldType.getCount() == 0) {
		            dsFieldType.load();
		        }
		        dsFieldType.each(function(r) {
		            if (val == r.data['DicsCode']) {
		                val = r.data['DicsName'];
		                return;
		            }
		        });
		        return val;
		    }
		},
		{
			header:'财务字段描述',
			dataIndex:'FinanceFname',
			id:'FinanceFname',
			hidden:true,
			hideable:false
		},
		{
			header:'财务字段顺序',
			dataIndex:'FinanceForder',
			id:'FinanceForder'
		},
		{
			header:'财务字段长度',
			dataIndex:'FinanceFlength',
			id:'FinanceFlength',
			hidden:true,
			hideable:false
		},
		{
			header:'财务字段字段精度',
			dataIndex:'FinanceFprecision',
			id:'FinanceFprecision',
			hidden:true,
			hideable:false
		},
		{
			header:'财务字段日期格式',
			dataIndex:'FinanceFdformat',
			id:'FinanceFdformat',
			hidden:true,
			hideable:false
		},
		{
			header:'启用状态',
			dataIndex:'Status',
			id:'Status',
			renderer:{
			    fn:function(v){
			        if(v==1)return '禁用';
			        return '启用';
			    }
			}
		}
		
		]),
		tbar: new Ext.Toolbar({
	        items:[{
		        text:"新增",
		        icon:"../../Theme/1/images/extjs/customer/add16.gif",
		        handler:function(){
		            saveFieldType='add';
                    openFieldAddCfgWin();
		        }
		        },'-',{
		        text:"修改",
		        icon:"../../Theme/1/images/extjs/customer/edit16.gif",
		        handler:function(){
		            saveFieldType='save';
		            modifyFieldCfgWin();
		        }
		        },'-',{
		        text:"删除",
		        icon:"../../Theme/1/images/extjs/customer/delete16.gif",
		        handler:function(){
		            deleteFieldCfg();
		        }
	        }]
        }),
		bbar: new Ext.PagingToolbar({
			pageSize: 10,
			store: dsFieldStore,
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
/*------DataGrid的函数结束 End---------------*/

/*------开始grid数据的窗体 Start---------------*/
if(typeof(uploadGridCfgWindow)=="undefined"){//解决创建2个windows问题
	uploadGridCfgWindow = new Ext.Window({
		id:'Cfgformwindow',
		title:'配置字段维护'
		, iconCls: 'upload-win'
		, width: 650
		, height: 450
		, layout: 'fit'
		, plain: true
		, modal: true
		, constrain:true
		, resizable: false
		, closeAction: 'hide'
		,autoDestroy :true
		,items:gridField
		});
	}
	uploadGridCfgWindow.addListener("hide",function(){
	    gridField.getStore().removeAll();
});
/*------结束grid数据的窗体 End---------------*/
/*------开始ToolBar事件函数 start---------------*//*-----新增Cfg实体类窗体函数----*/
function openFieldAddCfgWin() {
    var sm = gridData.getSelectionModel();
	//获取选择的数据信息
	var selectData =  sm.getSelected();
	if(selectData == null){
		Ext.Msg.alert("提示","请选中需要增加的方案信息！");
		return;
	}
	uploadFieldCfgWindow.show();
	Ext.getCmp('FProjectNo').setValue(selectData.data.ProjectNo);
	Ext.getCmp('FProjectName').setValue(selectData.data.ProjectName);
}
/*-----编辑Cfg实体类窗体函数----*/
function modifyFieldCfgWin() {
	var sm = gridField.getSelectionModel();
	//获取选择的数据信息
	var selectData =  sm.getSelected();
	if(selectData == null){
		Ext.Msg.alert("提示","请选中需要编辑的方案信息！");
		return;
	}
	uploadFieldCfgWindow.show();
	setFieldFormValue(selectData);
}
/*-----删除Cfg实体函数----*/
/*删除信息*/
function deleteFieldCfg()
{
	var sm = gridField.getSelectionModel();
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
				url:'frmFmProjCfg.aspx?method=deleteFeildCfg',
				method:'POST',
				params:{
					FieldId:selectData.data.FieldId
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
var feildForm=new Ext.form.FormPanel({
	url:'',
	//renderTo:'divForm',
	frame:true,
	title:'',
	items:[{
	    layout:'column',
	    items:[
	    {
	        layout:'form',
	        columnWidth:.65,
	        items:[{
			    xtype:'hidden',
			    fieldLabel:'配置序号',
			    name:'FieldId',
			    id:'FieldId',
			    hidden:true,
			    hideLabel:true
		    },
		    {
			    xtype:'hidden',
			    fieldLabel:'方案序号',
			    name:'FProjectNo',
			    id:'FProjectNo',
			    hidden:true,
			    hideLabel:true
		    },
		    {
			    xtype:'textfield',
			    fieldLabel:'方案名称',
			    anchor:'90%',
			    name:'FProjectName',
			    id:'FProjectName',
			    readOnly:true
		    }]
		}
        ,{
            layout:'form',
            labelWidth:55,
            columnWidth:.33,
	        items:[{
			    xtype:'combo',
			    fieldLabel:'启用状态',
			    anchor:'90%',
			    name:'FStatus',
			    id:'FStatus',
			    store:[[0,'启用'],[1,'禁用']],
			    mode:'local',
			    editable:false,
			    triggerAction:'all'
			}]
		}]  
	}
,	{
        layout:'column',
	    items:[
	    {
	        layout:'form',
	        columnWidth:.5,
	        items:[{
			    xtype:'textfield',
			    fieldLabel:'业务字段',
			    anchor:'90%',
			    name:'ErpFeild',
			    id:'ErpFeild'
			}]
		}
        ,{
            layout:'form',
            columnWidth:.5,
	        items:[{
			    xtype:'textfield',
			    fieldLabel:'财务字段',
			    anchor:'90%',
			    name:'FinanceFeild',
			    id:'FinanceFeild'
			}]
		}]
    }		
,	{
        layout:'column',
	    items:[
	    {
	        layout:'form',
	        columnWidth:.5,
	        items:[{
			    xtype:'textfield',
			    fieldLabel:'业务字段描述',
			    anchor:'90%',
			    name:'ErpFeildname',
			    id:'ErpFeildname'
			}]
		},
		{
		    layout:'form',
		    columnWidth:.5,
	        items:[{
			    xtype:'textfield',
			    fieldLabel:'财务字段描述',
			    anchor:'90%',
			    name:'FinanceFname',
			    id:'FinanceFname'
			}]
		}]
	}	
,	{
        layout:'column',
	    items:[
	    {
	        layout:'form',
	        columnWidth:.5,
	        items:[{
			    xtype:'combo',
			    fieldLabel:'业务字段类型',
			    anchor:'90%',
			    name:'ErpFtype',
			    id:'ErpFtype',
			    store:dsFieldType,
			    displayField:'DicsName',
			    valueField:'DicsCode',
			    mode:'local',
			    triggerAction:'all',
			    editable:false
			}]
		}
        ,{
            layout:'form',
            columnWidth:.5,
	        items:[{
			    xtype:'combo',
			    fieldLabel:'财务字段类型',
			    anchor:'90%',
			    name:'FinanceFtype',
			    id:'FinanceFtype',
			    store:dsFieldType,
			    displayField:'DicsName',
			    valueField:'DicsCode',
			    mode:'local',
			    triggerAction:'all',
			    editable:false
			}]
		}]
	}	
,	{
        layout:'column',
	    items:[
	    {
	        layout:'form',
	        columnWidth:.5,
	        items:[{
			    xtype:'numberfield',
			    fieldLabel:'业务字段顺序',
			    anchor:'90%',
			    name:'ErpForder',
			    id:'ErpForder'
			}]
		}
        ,{
            layout:'form',
            columnWidth:.5,
	        items:[{
			    xtype:'numberfield',
			    fieldLabel:'财务字段顺序',
			    anchor:'90%',
			    name:'FinanceForder',
			    id:'FinanceForder'
			}]
		}]
	}
,	{
        layout:'column',
	    items:[
	    {
	        layout:'form',
	        columnWidth:.5,
	        items:[{
			    xtype:'numberfield',
			    fieldLabel:'业务字段长度',
			    anchor:'90%',
			    name:'ErpFlength',
			    id:'ErpFlength'
			}]
		}
        ,{
            layout:'form',
            columnWidth:.5,
	        items:[{
			    xtype:'numberfield',
			    fieldLabel:'财务字段长度',
			    anchor:'90%',
			    name:'FinanceFlength',
			    id:'FinanceFlength'
			}]
		}]
	}
    ,{
        layout:'column',
	    items:[
	    {
	        layout:'form',
	        columnWidth:.5,
	        items:[{
			    xtype:'numberfield',
			    fieldLabel:'业务字段精度',
			    anchor:'90%',
			    name:'ErpFprecision',
			    id:'ErpFprecision'
			}]
		}
        ,{
            layout:'form',
            columnWidth:.5,
	        items:[{
			    xtype:'numberfield',
			    fieldLabel:'财务字段字段精度',
			    anchor:'90%',
			    name:'FinanceFprecision',
			    id:'FinanceFprecision'
			}]
		}]
    }
,	{
        layout:'column',
	    items:[
	    {
	        layout:'form',
	        columnWidth:.5,
	        items:[{
			    xtype:'textfield',
			    fieldLabel:'业务字段日期格式',
			    anchor:'90%',
			    name:'ErpFdformat',
			    id:'ErpFdformat'
			}]
		}
        ,{
            layout:'form',
            columnWidth:.5,
	        items:[{
			    xtype:'textfield',
			    fieldLabel:'财务字段日期格式',
			    anchor:'90%',
			    name:'FinanceFdformat',
			    id:'FinanceFdformat'
			}]
		}]
	}
    ,{
        layout:'column',
	    items:[
	    {
	        layout:'form',
	        columnWidth:1,
	        items:[{
			    xtype:'textarea',
			    fieldLabel:'备注',
			    anchor:'90%',
			    height:50,
			    name:'FNotes',
			    id:'FNotes'
			}]
		}]
    }
]
});
/*------FormPanle的函数结束 End---------------*/

/*------开始界面数据的窗体 Start---------------*/
if(typeof(uploadFieldCfgWindow)=="undefined"){//解决创建2个windows问题
	uploadFieldCfgWindow = new Ext.Window({
		id:'Cfgfeildformwindow',
		title:'业务字段配置'
		, iconCls: 'upload-win'
		, width: 600
		, height: 350
		, layout: 'fit'
		, plain: true
		, modal: true
		, constrain:true
		, resizable: false
		, closeAction: 'hide'
		,autoDestroy :true
		,items:feildForm
		,buttons: [{
			text: "保存"
			, handler: function() {
				saveFieldData();
			}
			, scope: this
		},
		{
			text: "取消"
			, handler: function() { 
				uploadFieldCfgWindow.hide();
			}
			, scope: this
		}]});
	}
	uploadFieldCfgWindow.addListener("hide",function(){
	    feildForm.getForm().reset();
});

/*------开始获取界面数据的函数 start---------------*/
function saveFieldData()
{
    if(saveFieldType=='add')
       saveFieldType = 'addFieldCfg';
    else if(saveFieldType == 'save')
        saveFieldType = 'saveFieldCfg';
	Ext.Ajax.request({
		url:'frmFmProjCfg.aspx?method='+saveFieldType,
		method:'POST',
		params:{
		    FieldId:Ext.getCmp('FieldId').getValue(),
			ProjectNo:Ext.getCmp('FProjectNo').getValue(),
			ErpFeild:Ext.getCmp('ErpFeild').getValue(),
			ErpFeildname:Ext.getCmp('ErpFeildname').getValue(),
			ErpFtype:Ext.getCmp('ErpFtype').getValue(),
			ErpForder:Ext.getCmp('ErpForder').getValue(),
			ErpFlength:Ext.getCmp('ErpFlength').getValue(),
			ErpFprecision:Ext.getCmp('ErpFprecision').getValue(),
			ErpFdformat:Ext.getCmp('ErpFdformat').getValue(),
			FinanceFeild:Ext.getCmp('FinanceFeild').getValue(),
			FinanceFname:Ext.getCmp('FinanceFname').getValue(),
			FinanceForder:Ext.getCmp('FinanceForder').getValue(),
			FinanceFtype:Ext.getCmp('FinanceFtype').getValue(),
			FinanceFlength:Ext.getCmp('FinanceFlength').getValue(),
			FinanceFprecision:Ext.getCmp('FinanceFprecision').getValue(),
			FinanceFdformat:Ext.getCmp('FinanceFdformat').getValue(),
		    Status:Ext.getCmp("FStatus").getValue(),
		    Notes:Ext.getCmp("FNotes").getValue()
			
			},
		success: function(resp,opts){
			Ext.Msg.alert("提示","保存成功");
			gridField.getStore().reload();
			uploadFieldCfgWindow.hide();
		},
		failure: function(resp,opts){
			Ext.Msg.alert("提示","保存失败");
		}
		});
		}
/*------结束获取界面数据的函数 End---------------*/

/*------开始界面数据的函数 Start---------------*/
function setFieldFormValue(selectData)
{
	Ext.Ajax.request({
		url:'frmFmProjCfg.aspx?method=getFieldCfg',
		params:{
			FieldId:selectData.data.FieldId
		},
	success: function(resp,opts){
		var data=Ext.util.JSON.decode(resp.responseText);
		Ext.getCmp("FieldId").setValue(data.FieldId);
		Ext.getCmp("ProjectNo").setValue(data.ProjectNo);
		Ext.getCmp("FProjectName").setValue(data.ProjectName);
		Ext.getCmp("ErpFeild").setValue(data.ErpFeild);
		Ext.getCmp("ErpFeildname").setValue(data.ErpFeildname);
		Ext.getCmp("ErpFtype").setValue(data.ErpFtype);
		Ext.getCmp("ErpForder").setValue(data.ErpForder);
		Ext.getCmp("ErpFlength").setValue(data.ErpFlength);
		Ext.getCmp("ErpFprecision").setValue(data.ErpFprecision);
		Ext.getCmp("ErpFdformat").setValue(data.ErpFdformat);
		Ext.getCmp("FinanceFeild").setValue(data.FinanceFeild);
		Ext.getCmp("FinanceFname").setValue(data.FinanceFname);
		Ext.getCmp("FinanceForder").setValue(data.FinanceForder);
		Ext.getCmp("FinanceFtype").setValue(data.FinanceFtype);
		Ext.getCmp("FinanceFlength").setValue(data.FinanceFlength);
		Ext.getCmp("FinanceFprecision").setValue(data.FinanceFprecision);
		Ext.getCmp("FinanceFdformat").setValue(data.FinanceFdformat);
		Ext.getCmp("FStatus").setValue(data.Status);
		Ext.getCmp("FNotes").setValue(data.Notes);
	},
	failure: function(resp,opts){
		Ext.Msg.alert("提示","获取信息失败");
	}
	});
}
/*------结束设置界面数据的函数 End---------------*/



/*------------------字段配置页面-------------------*/


})
</script>

</html>
