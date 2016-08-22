<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmBaProductUnit.aspx.cs" Inherits="BA_product_frmBaProductUnit" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html>
<head>
<title>计量单位维护</title><meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<link rel="stylesheet" type="text/css" href="../../ext3/resources/css/ext-all.css" />
<script type="text/javascript" src="../../ext3/adapter/ext/ext-base.js"></script>
<script type="text/javascript" src="../../ext3/ext-all.js"></script>
</head>
<body>
<div id='toolbar'></div>
<div id='searchForm'></div>
<div id='unitGrid'></div>

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
		    saveType = "add";
		    openAddUnitWin();
		}
		},'-',{
		text:"编辑",
		icon:"../../Theme/1/images/extjs/customer/edit16.gif",
		handler:function(){
		    saveType = "save";
		    modifyUnitWin();
		}
		},'-',{
		text:"删除",
		icon:"../../Theme/1/images/extjs/customer/delete16.gif",
		handler:function(){
		    deleteUnit();
		}
	}]
});

/*------结束toolbar的函数 end---------------*/


/*------开始ToolBar事件函数 start---------------*//*-----新增Unit实体类窗体函数----*/
function openAddUnitWin() {	
	uploadUnitWindow.show();
}
/*-----编辑Unit实体类窗体函数----*/
function modifyUnitWin() {
	var sm = gridData.getSelectionModel();
	//获取选择的数据信息
	var selectData =  sm.getSelected();
	if(selectData == null){
		Ext.Msg.alert("提示","请选中需要编辑的信息！");
		return;
	}
	uploadUnitWindow.show();
	setFormValue(selectData);
}
/*-----删除Unit实体函数----*/
/*删除信息*/
function deleteUnit()
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
				url:'frmBaProductUnit.aspx?method=deleteUnit',
				method:'POST',
				params:{
					UnitId:selectData.data.UnitId
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

/*------实现FormPanle的函数 start---------------*/
var uintForm=new Ext.form.FormPanel({
	url:'frmBaProductUnit.aspx?method=getUnitInfo',
	//renderTo:'divForm',
	frame:true,
	title:'',
	items:[
		{
			xtype:'hidden',
			fieldLabel:'计量单位ID',
			columnWidth:1,
			anchor:'90%',
			name:'UnitId',
			id:'UnitId',
			hidden:true,
			hideLabel:true
		}
,		{
			xtype:'textfield',
			fieldLabel:'计量单位名称',
			columnWidth:1,
			anchor:'90%',
			name:'UnitName',
			id:'UnitName'
		}
,		{
			xtype:'combo',
			fieldLabel:'所属量纲',
			columnWidth:.5,
			anchor:'90%',
			name:'Dimension',
			id:'Dimension'
			, displayField: 'UnitName'
            , valueField: 'UnitId'
            , hiddenName: 'UnitId'
            , editable: false
            , store: dsDimension
            , triggerAction: 'all'
            , mode:'local'
		}
,		{
			xtype:'checkbox',
			boxLabel:'是否基本量纲',
			columnWidth:.5,
			anchor:'90%',
			name:'IsBaseDimension',
			id:'IsBaseDimension'
			//hideLabel:true
		}
]
});
/*------FormPanle的函数结束 End---------------*/

/*------开始界面数据的窗体 Start---------------*/
if(typeof(uploadUnitWindow)=="undefined"){//解决创建2个windows问题
	uploadUnitWindow = new Ext.Window({
		id:'Unitformwindow'
		, iconCls: 'upload-win'
		, width: 400
		, height: 200
		, layout: 'fit'
		, plain: true
		, modal: true
		, constrain:true
		, resizable: false
		, closeAction: 'hide'
		,autoDestroy :true
		,items:uintForm
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
				uploadUnitWindow.hide();
			}
			, scope: this
		}]});
	}
	uploadUnitWindow.addListener("hide",function(){
	    uintForm.getForm().reset();
});

/*------开始获取界面数据的函数 start---------------*/
function saveUserData()
{
    if(saveType == 'add')
        saveType = 'addUnitInfo';
    else if (saveType == 'save')
        saveType = 'saveUnitInfo';
    
    var isBaseDim = 0;
    if(Ext.getCmp('IsBaseDimension').getValue())
        isBaseDim = 1;
        
	Ext.Ajax.request({
		url:'frmBaProductUnit.aspx?method='+saveType,
		method:'POST',
		params:{
			UnitId:Ext.getCmp('UnitId').getValue(),
			UnitName:Ext.getCmp('UnitName').getValue(),
			Dimension:Ext.getCmp('Dimension').getValue(),
			IsBaseDimension:isBaseDim
					},
		success: function(resp,opts){
			Ext.Msg.alert("提示","保存成功");
			var name=namePanel.getValue();
            uploadUnitWindow.hide();        
            unitGridData.load({
                    params : {
                    start : 0,
                    limit : 10,
                    UnitName:name
                    } 
                  }); 
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
		url:'frmBaProductUnit.aspx?method=getUnitInfo',
		params:{
			UnitId:selectData.data.UnitId
		},
	success: function(resp,opts){
		var data=Ext.util.JSON.decode(resp.responseText);
		Ext.getCmp("UnitId").setValue(data.UnitId);
		Ext.getCmp("UnitName").setValue(data.UnitName);
		Ext.getCmp("Dimension").setValue(data.Dimension);
		if(data.IsBaseDimension==1){
			Ext.get("IsBaseDimension").dom.checked=true;
		}
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
    fieldLabel: '计量单位名称',
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
    labelWidth: 95,
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
                    unitGridData.baseParams.UnitName = name;
                    unitGridData.load({
                                params : {
                                start : 0,
                                limit : 10
                                } 
                              }); 
                    }
                }]
        },{
            columnWidth: .57,  //该列占用的宽度，标识为20％
            layout: 'form',
            border: false
        }]
    }]
});
/*------定义查询form end ----------------*/


/*------开始获取数据的函数 start---------------*/
var unitGridData = new Ext.data.Store
({
url: 'frmBaProductUnit.aspx?method=getUnitList',
reader:new Ext.data.JsonReader({
	totalProperty:'totalProperty',
	root:'root'
},[
	{
		name:'UnitId'
	},
	{
		name:'UnitName'
	},
	{
		name:'Dimension'
	},
	{
		name:'IsBaseDimension'
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
var gridData = new Ext.grid.GridPanel({
	el: 'unitGrid',
	width:'100%',
	height:'100%',
	autoWidth:true,
	autoHeight:true,
	autoScroll:true,
	layout: 'fit',
	store: unitGridData,
	loadMask: {msg:'正在加载数据，请稍侯……'},
	sm:sm,
	cm: new Ext.grid.ColumnModel([
		sm,
		new Ext.grid.RowNumberer(),//自动行号
		{
			header:'计量单位ID',
			dataIndex:'UnitId',
			id:'UnitId'
			,hidden:true
			,hideable:false
		},
		{
			header:'计量单位名称',
			dataIndex:'UnitName',
			id:'UnitName'
		},
		{
			header:'所属量纲',
			dataIndex:'Dimension',
			id:'Dimension',
			renderer: function(val, params, record) {
			    if(val == 0 ) return "无";
		        if (dsDimension.getCount() == 0) {
		            dsDimension.load();
		        }
		        dsDimension.each(function(r) {
		            if (val == r.data['UnitId']) {
		                val = r.data['UnitName'];
		                return;
		            }
		        });
		        return val;
		    }
		},
		{
			header:'是否基本量纲',
			dataIndex:'IsBaseDimension',
			id:'IsBaseDimension',
			renderer: function(val, params, record) {
			    if(val==1)
			        return '是';
			    else 
			        return '否';
			}
		}		]),
		bbar: new Ext.PagingToolbar({
			pageSize: 10,
			store: unitGridData,
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
