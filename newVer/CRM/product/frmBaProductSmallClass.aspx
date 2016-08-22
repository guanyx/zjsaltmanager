<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmBaProductSmallClass.aspx.cs" Inherits="CRM_product_frmBaProductClass" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>存货采购计划分类小类对应关系维护</title>
    <meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
    <link rel="stylesheet" type="text/css" href="../../ext3/resources/css/ext-all.css" />
	<script type="text/javascript" src="../../ext3/adapter/ext/ext-base.js"></script>	
	<script type="text/javascript" src="../../ext3/ext-all.js"></script>
	<script type="text/javascript" src="../../js/operateResp.js"></script>
</head>
<body>
   <div id ='toolbar'></div>
   <div id ='searchForm'></div>
   <div id ='dataGrid'></div>
</body>

<%=getComboBoxStore() %>

<script type="text/javascript">
var saveType;
Ext.BLANK_IMAGE_URL = "../../ext3/resources/images/default/s.gif";	
Ext.onReady(function(){
/*------实现toolbar的函数 start---------------*/
var Toolbar = new Ext.Toolbar({
	renderTo:"toolbar",
	items:[{
		text:"新增",
		icon:"../../Theme/1/images/extjs/customer/add16.gif",
		handler:function(){
		    saveType ='add';
		    openAddClassWin();
		}
		},'-',{
		text:"编辑",
		icon:"../../Theme/1/images/extjs/customer/edit16.gif",
		handler:function(){
		    saveType = 'save';
		    modifyClassWin();
		}
		},'-',{
		text:"删除",
		icon:"../../Theme/1/images/extjs/customer/delete16.gif",
		handler:function(){
		    deleteClass();
		}
	}]
});

/*------结束toolbar的函数 end---------------*/


/*------开始ToolBar事件函数 start---------------*//*-----新增Class实体类窗体函数----*/
function openAddClassWin() {
	uploadClassWindow.show();
	//获取编号
    Ext.Ajax.request({
        url: 'frmBaProductSmallClass.aspx?method=getProductNo',
        success: function(resp, opts) {
            var dataNo = Ext.util.JSON.decode(resp.responseText);
            Ext.getCmp('ClassNo').setValue(dataNo.ProductNo); 
        },
        failure: function(resp, opts) {
            Ext.Msg.alert("提示", "获取编号失败！");
        }
    }); 
}
/*-----编辑Class实体类窗体函数----*/
function modifyClassWin() {
	var sm = gridData.getSelectionModel();
	//获取选择的数据信息
	var selectData =  sm.getSelected();
	if(selectData == null){
		Ext.Msg.alert("提示","请选中需要编辑的信息！");
		return;
	}
	uploadClassWindow.show();
	setFormValue(selectData);
}
/*-----删除Class实体函数----*/
/*删除信息*/
function deleteClass()
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
				url:'frmBaProductSmallClass.aspx?method=deleteSmallClass',
				method:'POST',
				params:{
					ClassId:selectData.data.ClassId
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

/*------实现FormPanle的函数 start---------------*/
var smallClassForm = new Ext.form.FormPanel({
	url:'',
	//renderTo:'divForm',
	frame:true,
	title:'',
	labelWidth:80,
	items:[
		{
			xtype:'hidden',
			fieldLabel:'小类ID',
			columnWidth:1,
			anchor:'90%',
			name:'ClassId',
			id:'ClassId',
			hidden:true,
			hideLabel:false
		}
,		{
			xtype:'textfield',
			fieldLabel:'小类编码',
			columnWidth:1,
			anchor:'90%',
			name:'ClassNo',
			id:'ClassNo'
		}
,		{
			xtype:'textfield',
			fieldLabel:'小类名称',
			columnWidth:1,
			anchor:'90%',
			name:'ClassName',
			id:'ClassName'
		}
,		{
			xtype:'textfield',
			fieldLabel:'小类规格',
			columnWidth:1,
			anchor:'90%',
			name:'Specifications',
			id:'Specifications'//,
//			store:dsSpecifications,
//			displayField:'DicsName',
//			valueField:'DicsCode',
//			mode:'local',
//			editable:false,
//			triggerAction:'all'
		}
,		{
			xtype:'combo',
			fieldLabel:'计量单位',
			columnWidth:1,
			anchor:'90%',
			name:'Unit',
			id:'Unit',
			store:dsUnit,
			displayField:'UnitName',
			valueField:'UnitId',
			mode:'local',
			editable:false,
			triggerAction:'all'
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
if(typeof(uploadClassWindow)=="undefined"){//解决创建2个windows问题
	uploadClassWindow = new Ext.Window({
		id:'Classformwindow',
		title:'采购计划商品小类维护'
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
		,items:smallClassForm
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
				uploadClassWindow.hide();
			}
			, scope: this
		}]});
	}
	uploadClassWindow.addListener("hide",function(){
	    smallClassForm.getForm().reset();
});

/*------开始获取界面数据的函数 start---------------*/
function saveUserData()
{
    if(saveType =='add')
        saveType = 'addSmallClass';
    else if(saveType == 'save')
        saveType = 'saveSmallclass';
        
	Ext.Ajax.request({
		url:'frmBaProductSmallClass.aspx?method='+saveType,
		method:'POST',
		params:{
			ClassId:Ext.getCmp('ClassId').getValue(),
			ClassNo:Ext.getCmp('ClassNo').getValue(),
			ClassName:Ext.getCmp('ClassName').getValue(),
			Specifications:Ext.getCmp('Specifications').getValue(),
			Unit:Ext.getCmp('Unit').getValue(),
			//Supplier:getCmp('CustomerId').getValue(),
			Remark:Ext.getCmp('Remark').getValue()
			},
		success: function(resp,opts){
			if(checkExtMessage(resp))
            {
                gridData.getStore().reload();
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
		url:'frmBaProductSmallClass.aspx?method=getSmallClass',
		params:{
			ClassId:selectData.data.ClassId
		},
	success: function(resp,opts){
		var data=Ext.util.JSON.decode(resp.responseText);
		Ext.getCmp("ClassId").setValue(data.ClassId);
		Ext.getCmp("ClassNo").setValue(data.ClassNo);
		Ext.getCmp("ClassName").setValue(data.ClassName);
		Ext.getCmp("Specifications").setValue(data.Specifications);
		Ext.getCmp("Unit").setValue(data.Unit);
		//Ext.getCmp("CustomerId").setValue(data.Supplier);
		Ext.getCmp("Remark").setValue(data.Remark);
	},
	failure: function(resp,opts){
		Ext.Msg.alert("提示","获取用户信息失败");
	}
	});
}
/*------结束设置界面数据的函数 End---------------*/

/*------定义查询form start ----------------*/
var namePanel = new Ext.form.TextField({
    style: 'margin-left:0px',
    cls: 'key',
    xtype: 'textfield',
    fieldLabel: '小类商品编号或名称',
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
    labelWidth: 120,
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
        }, {
            columnWidth: .10,
            layout: 'form',
            border: false,
            items: [{ cls: 'key',
                xtype: 'button',
                text: '查询',
                anchor: '50%',
                handler :function(){                
                    var name=namePanel.getValue();
                    
                    dsSmallClass.baseParams.ClassName = name;
                    dsSmallClass.load({
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
var dsSmallClass = new Ext.data.Store
({
url: 'frmBaProductSmallClass.aspx?method=getSmallClassList',
reader:new Ext.data.JsonReader({
	totalProperty:'totalProperty',
	root:'root'
},[
	{		name:'ClassId'},
	{		name:'ClassNo'},
	{		name:'ClassName'},
	{		name:'Specifications'},
	{		name:'SpecificationsText'},
	{		name:'Unit'},
	{		name:'UnitText'},
	{		name:'State'},
	{		name:'Remark'},
	{		name:'CreateDate'},
	{		name:'UpdateDate'},
	{		name:'OperId'},
	{		name:'OrgId'},
	{		name:'ValidDate'},
	{		name:'ExpireDate'},
	{		name:'ExpireOperId'},
	{		name:'ExpireOrg'},
	{		name:'ClassScheme'}	])
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
	id: '',
	store: dsSmallClass,
	loadMask: {msg:'正在加载数据，请稍侯……'},
	sm:sm,
	cm: new Ext.grid.ColumnModel([
		sm,
		new Ext.grid.RowNumberer(),//自动行号
		{
			header:'小类ID',
			dataIndex:'ClassId',
			id:'ClassId',
			hidden:true,
			hideable:false
		},
		{
			header:'小类编码',
			dataIndex:'ClassNo',
			id:'ClassNo'
		},
		{
			header:'小类名称',
			dataIndex:'ClassName',
			id:'ClassName'
		},
		{
			header:'小类规格',
			dataIndex:'SpecificationsText',
			id:'SpecificationsText'
		},
		{
			header:'计量单位',
			dataIndex:'UnitText',
			id:'UnitText'
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
			store: dsSmallClass,
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



})
</script>

</html>