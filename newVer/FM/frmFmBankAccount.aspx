<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmFmBankAccount.aspx.cs" Inherits="FM_frmFmBankAccount" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html>
<head>
<title>开户银行维护</title><meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<link rel="stylesheet" type="text/css" href="../ext3/resources/css/ext-all.css" />
<script type="text/javascript" src="../ext3/adapter/ext/ext-base.js"></script>
<script type="text/javascript" src="../ext3/ext-all.js"></script>
</head>
<body>
<div id='toolbar'></div>
<div id='searchForm'></div>
<div id='dataGrid'></div>

</body>
<script type="text/javascript">
Ext.BLANK_IMAGE_URL = "../ext3/resources/images/default/s.gif";  //作为：让下拉框的三角形下拉图片显示
Ext.onReady(function() {
var saveType;
/*------实现toolbar的函数 start---------------*/
var Toolbar = new Ext.Toolbar({
	renderTo:"toolbar",
	items:[{
		text:"新增",
		icon:"../Theme/1/images/extjs/customer/add16.gif",
		handler:function(){
		    saveType='add';
		    openAddAccountWin();
		}
		},'-',{
		text:"编辑",
		icon:"../Theme/1/images/extjs/customer/edit16.gif",
		handler:function(){
		    saveType='save';
		    modifyAccountWin();
		}
		},'-',{
		text:"删除",
		icon:"../Theme/1/images/extjs/customer/delete16.gif",
		handler:function(){
		    deleteAccount();
		}
	}]
});

/*------结束toolbar的函数 end---------------*/


/*------开始ToolBar事件函数 start---------------*//*-----新增Account实体类窗体函数----*/
function openAddAccountWin() {	
	uploadAccountWindow.show();
}
/*-----编辑Account实体类窗体函数----*/
function modifyAccountWin() {
	var sm = dataGrid.getSelectionModel();
	//获取选择的数据信息
	var selectData =  sm.getSelected();
	if(selectData == null){
		Ext.Msg.alert("提示","请选中需要编辑的信息！");
		return;
	}
	uploadAccountWindow.show();
	setFormValue(selectData);
}
/*-----删除Account实体函数----*/
/*删除信息*/
function deleteAccount()
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
				url:'frmFmBankAccount.aspx?method=deleteBankAccount',
				method:'POST',
				params:{
					BankId:selectData.data.BankId
				},
				success: function(resp,opts){
					Ext.Msg.alert("提示","数据删除成功");
					dataGrid.getStore().remove(selectData);
				},
				failure: function(resp,opts){
					Ext.Msg.alert("提示","数据删除失败");
				}
			});
		}
	});
}

/*------实现FormPanle的函数 start---------------*/
var bankForm = new Ext.form.FormPanel({
	url:'',
	frame:true,
	title:'',
	items:[
		{
			xtype:'hidden',
			fieldLabel:'序号',
			columnWidth:1,
			anchor:'90%',
			name:'BankId',
			id:'BankId',
			hidden:true,
			hideLabel:true
		}
,		{
			xtype:'textfield',
			fieldLabel:'银行名称',
			columnWidth:1,
			anchor:'90%',
			name:'BankName',
			id:'BankName'
		}
,		{
			xtype:'textfield',
			fieldLabel:'银行账户',
			columnWidth:1,
			anchor:'90%',
			name:'BankAcount',
			id:'BankAcount'
		}
,		{
			xtype:'textfield',
			fieldLabel:'税号',
			columnWidth:1,
			anchor:'90%',
			name:'TaxNo',
			id:'TaxNo'
		}
,		{
			xtype:'checkbox',
			boxLabel:'基本结算行',
			columnWidth:1,
			anchor:'90%',
			name:'IsBase',
			id:'IsBase'
		}
,		{
			xtype:'textfield',
			fieldLabel:'电话号码',
			columnWidth:1,
			anchor:'90%',
			name:'BankPhone',
			id:'BankPhone'
		}
,		{
			xtype:'textfield',
			fieldLabel:'银行地址',
			columnWidth:1,
			anchor:'90%',
			name:'BankAdress',
			id:'BankAdress'
		}
]
});
/*------FormPanle的函数结束 End---------------*/

var namePanel = new Ext.form.TextField({
    style: 'margin-left:0px',
    cls: 'key',
    xtype: 'textfield',
    fieldLabel: '银行名称',
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
                    dsDataGrid.baseParams.BankName = name;
                    dsDataGrid.load({
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


/*------开始界面数据的窗体 Start---------------*/
if(typeof(uploadAccountWindow)=="undefined"){//解决创建2个windows问题
	uploadAccountWindow = new Ext.Window({
		id:'Accountformwindow',
		title:'开户银行维护'
		, iconCls: 'upload-win'
		, width: 400
		, height: 250
		, layout: 'fit'
		, plain: true
		, modal: true
		, constrain:true
		, resizable: false
		, closeAction: 'hide'
		,autoDestroy :true
		,items:bankForm
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
				uploadAccountWindow.hide();
			}
			, scope: this
		}]});
	}
	uploadAccountWindow.addListener("hide",function(){
	    bankForm.getForm().reset();
});

/*------开始获取界面数据的函数 start---------------*/
function saveUserData()
{
    if(saveType =='add')
        saveType = 'addBankAccount';
    else if(saveType == 'save')
        saveType = 'saveBankAccount';

    var IsBase = false;
    if(Ext.getCmp('IsBase').getValue())
        IsBase = true;
        
	Ext.Ajax.request({
		url:'frmFmBankAccount.aspx?method='+saveType,
		method:'POST',
		params:{
			BankId:Ext.getCmp('BankId').getValue(),
			BankName:Ext.getCmp('BankName').getValue(),
			BankAcount:Ext.getCmp('BankAcount').getValue(),
			TaxNo:Ext.getCmp('TaxNo').getValue(),
			IsBase:IsBase,
			BankPhone:Ext.getCmp('BankPhone').getValue(),
			BankAdress:Ext.getCmp('BankAdress').getValue()
			},
		success: function(resp,opts){
			Ext.Msg.alert("提示","保存成功");
			dsDataGrid.reload();
			uploadAccountWindow.hide();
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
		url:'frmFmBankAccount.aspx?method=getBankAccount',
		params:{
			BankId:selectData.data.BankId
		},
	success: function(resp,opts){
		var data=Ext.util.JSON.decode(resp.responseText);
		var isBase = false;
		if(data.IsBase)
		    isBase = true;
		Ext.getCmp("BankId").setValue(data.BankId);
		Ext.getCmp("BankName").setValue(data.BankName);
		Ext.getCmp("BankAcount").setValue(data.BankAcount);
		Ext.getCmp("TaxNo").setValue(data.TaxNo);
		Ext.getCmp("IsBase").setValue(isBase);
		Ext.getCmp("BankPhone").setValue(data.BankPhone);
		Ext.getCmp("BankAdress").setValue(data.BankAdress);
	},
	failure: function(resp,opts){
		Ext.Msg.alert("提示","获取用户信息失败");
	}
	});
}
/*------结束设置界面数据的函数 End---------------*/

/*------开始获取数据的函数 start---------------*/
var dsDataGrid = new Ext.data.Store
({
url: 'frmFmBankAccount.aspx?method=getBankAccountList',
reader:new Ext.data.JsonReader({
	totalProperty:'totalProperty',
	root:'root'
},[
	{
		name:'BankId'
	},
	{
		name:'BankName'
	},
	{
		name:'BankAcount'
	},
	{
		name:'TaxNo'
	},
	{
		name:'IsBase'
	},
	{
		name:'BankPhone'
	},
	{
		name:'BankAdress'
	},
	{
		name:'OwnerOrg'
	},
	{
		name:'CreateDate'
	},
	{
		name:'OperId'
	},
	{
		name:'OrgId'
	},
	{
		name:'OwnerId'
	},
	{
		name:'Status'
	},
	{
		name:'Ext1'
	},
	{
		name:'Ext2'
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
var dataGrid = new Ext.grid.GridPanel({
	el: 'dataGrid',
	width:'100%',
	height:'100%',
	autoWidth:true,
	autoHeight:true,
	autoScroll:true,
	layout: 'fit',
	id: 'dataGrid',
	store: dsDataGrid,
	loadMask: {msg:'正在加载数据，请稍侯……'},
	sm:sm,
	cm: new Ext.grid.ColumnModel([
		sm,
		new Ext.grid.RowNumberer(),//自动行号
		{
			header:'序号',
			dataIndex:'BankId',
			id:'BankId',
			hidden:true,
			hideable:false
		},
		{
			header:'银行名称',
			dataIndex:'BankName',
			id:'BankName'
		},
		{
			header:'银行账户',
			dataIndex:'BankAcount',
			id:'BankAcount'
		},
		{
			header:'税号',
			dataIndex:'TaxNo',
			id:'TaxNo'
		},
		{
			header:'是否基本结算行',
			dataIndex:'IsBase',
			id:'IsBase',
			renderer:{fn:function(v){if(v)return '是';else return '否';}}
		},
		{
			header:'电话号码',
			dataIndex:'BankPhone',
			id:'BankPhone'
		},
		{
			header:'银行地址',
			dataIndex:'BankAdress',
			id:'BankAdress'
		},
		{
			header:'所属公司',
			dataIndex:'OwnerOrg',
			id:'OwnerOrg'
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
			store: dsDataGrid,
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
dataGrid.render();
/*------DataGrid的函数结束 End---------------*/



})
</script>
</html>
