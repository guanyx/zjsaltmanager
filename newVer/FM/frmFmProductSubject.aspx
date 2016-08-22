<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmFmProductSubject.aspx.cs" Inherits="FM_frmFmProductSubject" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html>
<head>
<title>商品与科目对应关系维护</title><meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<link rel="stylesheet" type="text/css" href="../ext3/resources/css/ext-all.css" />
<script type="text/javascript" src="../ext3/adapter/ext/ext-base.js"></script>
<script type="text/javascript" src="../ext3/ext-all.js"></script>
</head>
<body>
<div id='toolbar'></div>
<div id='searchForm'></div>
<div id='dateGrid'></div>

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
		    saveType ='add';
		    openAddSubjectWin();
		}
		},'-',{
		text:"编辑",
		icon:"../Theme/1/images/extjs/customer/edit16.gif",
		handler:function(){
		    saveType ='add';
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
	/*----------定义供应商组合框 start -------------*/ 
    //定义产品下拉框异步调用方法
    var dsProducts;
    if(dsProducts == null){
        dsProducts = new Ext.data.Store({
            url: 'frmFmProductSubject.aspx?method=getProducts',  
            reader: new Ext.data.JsonReader({  
                root: 'root',  
                totalProperty: 'totalProperty'
            }, [  
                {name: 'ProductId', mapping: 'ProductId'}, 
                {name: 'ProductNo', mapping: 'ProductNo'},  
                {name: 'ProductName', mapping: 'ProductName'}
            ])
        });
    }
   var productFilterCombo = new Ext.form.ComboBox({  
                store: dsProducts,  
                displayField:'ProductName',
                displayValue:'ProductId',
                typeAhead: false,  
                minChars:1,
                loadingText: 'Searching...',  
                //tpl: resultTpl,  
                pageSize:10,  
                hideTrigger:true,  
                applyTo: 'ProductName',
                onSelect: function(record){ // override default onSelect to do redirect  
                    //alert(record.data.cusid); 
                    //alert(Ext.getCmp('search').getValue());                        
                    Ext.getCmp('ProductName').setValue(record.data.ProductName);
                    Ext.getCmp('ProductId').setValue(record.data.ProductId);
                    Ext.getCmp('SubjectCode').focus(); 
                }  
            });     
    /*----------定义产品组合框 end -------------*/
    
    Ext.getCmp('ProductName').setDisabled(false);
}
/*-----编辑Subject实体类窗体函数----*/
function modifySubjectWin() {
	var sm = gridData.getSelectionModel();
	//获取选择的数据信息
	var selectData =  sm.getSelected();
	if(selectData == null){
		Ext.Msg.alert("提示","请选中需要编辑的信息！");
		return;
	}
	uploadSubjectWindow.show();
	Ext.getCmp('ProductName').setDisabled(true);
	setFormValue(selectData);
}
/*-----删除Subject实体函数----*/
/*删除信息*/
function deleteSubject()
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
				url:'frmFmProductSubject.aspx?method=deleteSubject',
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
var prodForm=new Ext.form.FormPanel({
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
			xtype:'hidden',
			fieldLabel:'商品代码',
			columnWidth:1,
			anchor:'90%',
			name:'ProductId',
			id:'ProductId',
			hidden:true,
			hideLabel:true
		}
,		{
			xtype:'textfield',
			fieldLabel:'商品名称',
			columnWidth:1,
			anchor:'90%',
			name:'ProductName',
			id:'ProductName'
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
			fieldLabel:'对应类型',
			columnWidth:1,
			anchor:'90%',
			name:'RegexType',
			id:'RegexType',
			store:dsRegexType,
			mode:'local',
			displayField:'DicsName',
			valueField:'DicsCode',
			triggerAction:'all',
			editable:false
		}
]
});
/*------FormPanle的函数结束 End---------------*/

/*------开始界面数据的窗体 Start---------------*/
if(typeof(uploadSubjectWindow)=="undefined"){//解决创建2个windows问题
	uploadSubjectWindow = new Ext.Window({
		id:'Subjectformwindow',
		title:'商品与科目对应关系维护'
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
		,items:prodForm
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
	prodForm.getForm().reset();
});

/*------开始获取界面数据的函数 start---------------*/
function saveUserData()
{
    if(saveType=='add')
        saveType='addProductSubject';
    else if(saveType=='save')
        saveType='saveProductSubject';
	Ext.Ajax.request({
		url:'frmFmProductSubject.aspx?method='+saveType,
		method:'POST',
		params:{
			SubjectId:Ext.getCmp('SubjectId').getValue(),
			ProductId:Ext.getCmp('ProductId').getValue(),
			SubjectCode:Ext.getCmp('SubjectCode').getValue(),
			RegexType:Ext.getCmp('RegexType').getValue(),
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
		url:'frmFmProductSubject.aspx?method=getSubject',
		params:{
			SubjectId:selectData.data.SubjectId
		},
	success: function(resp,opts){
		var data=Ext.util.JSON.decode(resp.responseText);
		Ext.getCmp("SubjectId").setValue(data.SubjectId);
		Ext.getCmp("ProductId").setValue(data.ProductId);
		Ext.getCmp("ProductName").setValue(data.ProductName);
		Ext.getCmp("SubjectCode").setValue(data.SubjectCode);
		Ext.getCmp("RegexType").setValue(data.RegexType);
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
url: 'frmFmProductSubject.aspx?method=getProductSubjectList',
reader:new Ext.data.JsonReader({
	totalProperty:'totalProperty',
	root:'root'
},[
	{
		name:'SubjectId'
	},
	{
		name:'ProductId'
	},
	{
		name:'ProductName'
	},
	{
		name:'SubjectCode'
	},
	{
		name:'SubjectName'
	},
	{
		name:'OwnerOrg'
	},
	{
		name:'OrgName'
	},
	{
		name:'RegexType'
	},
	{
		name:'RegexName'
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


/*------FormPanle的函数结束 End---------------*/
var namePanel = new Ext.form.TextField({
    style: 'margin-left:0px',
    cls: 'key',
    xtype: 'textfield',
    fieldLabel: '商品名称',
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
    labelWidth: 55,
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
                    dsgridData.baseParams.ProductName = name;
                    dsgridData.load({
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
			header:'商品代码',
			dataIndex:'ProductId',
			id:'ProductId',
			hidden:true,
			hideable:false
		},
		{
			header:'商品名称',
			dataIndex:'ProductName',
			id:'ProductName'
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
			header:'所属公司',
			dataIndex:'OwnerOrg',
			id:'OwnerOrg',
			hidden:true,
			hideable:false
		},
		{
			header:'所属公司',
			dataIndex:'OrgName',
			id:'OrgName'
		},
		{
			header:'所属公司',
			dataIndex:'RegexType',
			id:'RegexType',
			hidden:true,
			hideable:false
		},
		{
			header:'对应类型',
			dataIndex:'RegexName',
			id:'RegexName'
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


/*------DataGrid的函数结束 End---------------*/



})
</script>

</html>
