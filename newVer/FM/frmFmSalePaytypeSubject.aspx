<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmFmSalePaytypeSubject.aspx.cs" Inherits="FM_frmFmSalePaytypeSubject" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html>
<head>
<title>测试页面</title><meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<link rel="stylesheet" type="text/css" href="../ext3/resources/css/ext-all.css" />
<script type="text/javascript" src="../ext3/adapter/ext/ext-base.js"></script>
<script type="text/javascript" src="../ext3/ext-all.js"></script>
</head>
<body>
<div id='toolbar'></div>
<div id='searchForm'></div>
<div id='dataGrid'></div>

</body>

<%= getComboBoxStore() %>

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
		    saveType = 'add';
		    openAddSubjectWin();
		}
		},'-',{
		text:"编辑",
		icon:"../Theme/1/images/extjs/customer/edit16.gif",
		handler:function(){
		    saveType = 'save';
		    modifySubjectWin();
		}
		},'-',{
		text:"删除",
		icon:"../Theme/1/images/extjs/customer/delete16.gif",
		handler:function(){
		    deleteSubject();
		}
	}]
});

/*------结束toolbar的函数 end---------------*/


/*------开始ToolBar事件函数 start---------------*//*-----新增Subject实体类窗体函数----*/
function openAddSubjectWin() {
	uploadSubjectWindow.show();
}
/*-----编辑Subject实体类窗体函数----*/
function modifySubjectWin() {
	var sm = dataGrid.getSelectionModel();
	//获取选择的数据信息
	var selectData =  sm.getSelected();
	if(selectData == null){
		Ext.Msg.alert("提示","请选中需要编辑的信息！");
		return;
	}
	uploadSubjectWindow.show();
	setFormValue(selectData.data.SubjectId);
}
/*-----删除Subject实体函数----*/
/*删除信息*/
function deleteSubject()
{
	var sm = dataGrid.getSelectionModel();
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
				url:'frmFmSalePaytypeSubject.aspx?method=deleteSubject',
				method:'POST',
				params:{
					SubjectId:selectData.data.SubjectId
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
var subjectForm =new Ext.form.FormPanel({
	url:'',
	frame:true,
	title:'',
	items:[
		{
			xtype:'hidden',
			fieldLabel:'科目代码序号',
			columnWidth:1,
			anchor:'90%',
			name:'SubjectId',
			id:'SubjectId',
			hidden:true,
			hideLabel:true
		}
,		{
			xtype:'combo',
			fieldLabel:'收款方式',
			columnWidth:1,
			anchor:'90%',
			name:'PaytypeCode',
			id:'PaytypeCode',
			store:dsSalePayType,
			displayField:'DicsName',
			valueField:'DicsCode',
			mode:'local',
			editable:false,
			triggerAction:'all'
		}
,		{
			xtype:'textfield',
			fieldLabel:'科目代码编码',
			columnWidth:1,
			anchor:'90%',
			name:'SubjectCode',
			id:'SubjectCode'
		}
,		{
			xtype:'combo',
			fieldLabel:'开户银行',//对应FM_BANK_ACCOUNT.BANK_ID,
			columnWidth:1,
			anchor:'90%',
			name:'BankId',
			id:'BankId',
			store:dsBank,
			displayField:'BankName',
			valueField:'BankId',
			mode:'local',
			editable:false,
			triggerAction:'all'
		}
]
});
/*------FormPanle的函数结束 End---------------*/

/*------开始界面数据的窗体 Start---------------*/
if(typeof(uploadSubjectWindow)=="undefined"){//解决创建2个windows问题
	uploadSubjectWindow = new Ext.Window({
		id:'Subjectformwindow',
		title:'收款方式与科目代码对应关系维护'
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
		,items:subjectForm
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
				uploadSubjectWindow.hide();
			}
			, scope: this
		}]});
	}
	uploadSubjectWindow.addListener("hide",function(){
});

/*------开始获取界面数据的函数 start---------------*/
function saveUserData()
{
    if(saveType=='add')
        saveType='addSalePaytype';
    else if (saveType = 'save')
        saveType = 'saveSalePaytype';
        
	Ext.Ajax.request({
		url:'frmFmSalePaytypeSubject.aspx?method='+saveType,
		method:'POST',
		params:{
			SubjectId:Ext.getCmp('SubjectId').getValue(),
			PaytypeCode:Ext.getCmp('PaytypeCode').getValue(),
			SubjectCode:Ext.getCmp('SubjectCode').getValue(),
			BankId:Ext.getCmp('BankId').getValue()
			},
		success: function(resp,opts){
			Ext.Msg.alert("提示","保存成功");
			dataGrid.getStore().reload();
			uploadSubjectWindow.hide();
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
		url:'frmFmSalePaytypeSubject.aspx?method=getSubject',
		params:{
			SubjectId:selectData.data.SubjectId
		},
	success: function(resp,opts){
		var data=Ext.util.JSON.decode(resp.responseText);
		Ext.getCmp("SubjectId").setValue(data.SubjectId);
		Ext.getCmp("PaytypeCode").setValue(data.PaytypeCode);
		Ext.getCmp("SubjectCode").setValue(data.SubjectCode);
		Ext.getCmp("BankId").setValue(data.BankId);
	},
	failure: function(resp,opts){
		Ext.Msg.alert("提示","获取用户信息失败");
	}
	});
}
/*------结束设置界面数据的函数 End---------------*/

/*------开始获取数据的函数 start---------------*/
var dsgridData = new Ext.data.Store
({
url: 'frmFmSalePaytypeSubject.aspx?method=getSubjectList',
reader:new Ext.data.JsonReader({
	totalProperty:'totalProperty',
	root:'root'
},[
	{
		name:'SubjectId'
	},
	{
		name:'PaytypeCode'
	},
	{
		name:'PaytypeName'
	},
	{
		name:'SubjectCode'
	},
	{
		name:'SubjectName'
	},
	{
		name:'BankId'
	},
	{
		name:'BankName'
	},
	{
		name:'CreateDate'
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
	el: 'dataGrid',
	width:'100%',
	height:'100%',
	autoWidth:true,
	autoHeight:true,
	autoScroll:true,
	layout: 'fit',
	id: '',
	store: dsgridData,
	loadMask: {msg:'正在加载数据，请稍侯……'},
	sm:sm,
	cm: new Ext.grid.ColumnModel([
		sm,
		new Ext.grid.RowNumberer(),//自动行号
		{
			header:'科目代码序号',
			dataIndex:'SubjectId',
			id:'SubjectId',
			hidden:true,
			hideable:false
		},
		{
			header:'收款方式',
			dataIndex:'PaytypeCode',
			id:'PaytypeCode'
		},
		{   
		    header:'收款方式注释',
		    dataIndex:'PaytypeName',
		    id:'PaytypeName'
		},
		{
			header:'科目代码编码',
			dataIndex:'SubjectCode',
			id:'SubjectCode'
		},		
		{
			header:'科目代码名称',
			dataIndex:'SubjectName',
			id:'SubjectName'
		},
		{
			header:'开户银行',//对应FM_BANK_ACCOUNT.BANK_ID
			dataIndex:'BankId',
			id:'BankId',
			hidden:true,
			hideable:false
		},
		{
			header:'开户银行',
			dataIndex:'BankName',
			id:'BankName'
		},
		{
			header:'创建时间',
			dataIndex:'CreateDate',
			id:'CreateDate',
			renderer: Ext.util.Format.dateRenderer('Y年m月d日')
		}		]),
		bbar: new Ext.PagingToolbar({
			pageSize: 10,
			store: dsgridData,
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

//页面进入就加载
dsgridData.load({
    params : {
    start : 0,
    limit : 10
    } 
});
/*------DataGrid的函数结束 End---------------*/



})
</script>
</html>
