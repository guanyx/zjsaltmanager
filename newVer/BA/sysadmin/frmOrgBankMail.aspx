<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmOrgBankMail.aspx.cs" Inherits="BA_sysadmin_frmOrgBankMail" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <link rel="stylesheet" type="text/css" href="../../ext3/resources/css/ext-all.css" />
    <script type="text/javascript" src="../../ext3/adapter/ext/ext-base.js"></script>
    <script type="text/javascript" src="../../ext3/ext-all.js"></script>
</head>
<script type="text/javascript">
Ext.onReady(function(){
/*------实现toolbar的函数 start---------------*/
var Toolbar = new Ext.Toolbar({
	renderTo:"toolbar",
	items:[{
		text:"新增",
		icon:"images/extjs/customer/add16.gif",
		handler:function(){
		        openAddBankmainWin();
		    }
		},'-',{
		text:"编辑",
		icon:"images/extjs/customer/edit16.gif",
		handler:function(){
		        modifyBankmainWin();
		    }
		},'-',{
		text:"删除",
		icon:"images/extjs/customer/delete16.gif",
		handler:function(){
		    deleteBankmain();    
		}
	}]
});

/*------结束toolbar的函数 end---------------*/


/*------开始ToolBar事件函数 start---------------*//*-----新增Bankmain实体类窗体函数----*/
function openAddBankmainWin() {
    Ext.getCmp('MailId').setValue("0"),
	Ext.getCmp('MailName').setValue(""),
	Ext.getCmp('SmtpServer').setValue(""),
	Ext.getCmp('SmtpPort').setValue(""),
	Ext.getCmp('PopServer').setValue(""),
	Ext.getCmp('PopPort').setValue(""),
	Ext.getCmp('MailUserName').setValue(""),
	Ext.getCmp('MailPassword').setValue(""),
	Ext.getCmp('BankName').setValue(""),
	Ext.getCmp('BankMail').setValue(""),
	Ext.getCmp('MailTitle').setValue(""),
	Ext.getCmp('MailAttName').setValue(""),
	Ext.getCmp('BankAttName').setValue(""),
	uploadBankmainWindow.show();
}
/*-----编辑Bankmain实体类窗体函数----*/
function modifyBankmainWin() {
	var sm = Ext.getCmp('userGrid').getSelectionModel();
	//获取选择的数据信息
	var selectData =  sm.getSelected();
	if(selectData == null){
		Ext.Msg.alert("提示","请选中需要编辑的信息！");
		return;
	}
	uploadBankmainWindow.show();
	setFormValue(selectData);
}
/*-----删除Bankmain实体函数----*/
/*删除信息*/
function deleteBankmain()
{
	var sm = Ext.getCmp('userGrid').getSelectionModel();
	//获取选择的数据信息
	var selectData =  sm.getSelected();
	//如果没有选择，就提示需要选择数据信息
	if(selectData == null){
		Ext.Msg.alert("提示","请选中需要删除的信息！");
		return;
	}
	//删除前再次提醒是否真的要删除
	Ext.Msg.confirm("提示信息","是否真的要删除选择的银行邮箱信息吗？",function callBack(id){
		//判断是否删除数据
		if(id=="yes")
		{
			//页面提交
			Ext.Ajax.request({
				url:'frmOrgBankMail.aspx?method=deleteBankmain',
				method:'POST',
				params:{
					MailId:selectData.data.MailId
				},
				success: function(resp,opts){
					Ext.Msg.alert("提示","数据删除成");
				},
				failure: function(resp,opts){
					Ext.Msg.alert("提示","数据删除失败");
				}
			});
		}
	});
}

/*------实现FormPanle的函数 start---------------*/
var bankForm=new Ext.form.FormPanel({
	frame:true,
	title:'',
	items:[
		{
			 xtype: 'hidden',
		    fieldLabel: '标识',
		    columnWidth: 1,
		    anchor: '90%',
		    name: 'MailId',
		    id: 'MailId',
		    hide: true
		}
,		{
			xtype:'textfield',
			fieldLabel:'我的邮件名称',
			columnWidth:1,
			anchor:'90%',
			name:'MailName',
			id:'MailName',
			vtypeText:'请输入联系的邮箱'
		}
,		{
			xtype:'textfield',
			fieldLabel:'Smtp服务',
			columnWidth:1,
			anchor:'90%',
			name:'SmtpServer',
			id:'SmtpServer'
		}
,		{
			xtype:'textfield',
			fieldLabel:'smtp端口',
			columnWidth:1,
			anchor:'90%',
			name:'SmtpPort',
			id:'SmtpPort'
		}
,		{
			xtype:'textfield',
			fieldLabel:'Pop3服务',
			columnWidth:1,
			anchor:'90%',
			name:'PopServer',
			id:'PopServer'
		}
,		{
			xtype:'textfield',
			fieldLabel:'Pop3端口',
			columnWidth:1,
			anchor:'90%',
			name:'PopPort',
			id:'PopPort'
		}
,		{
			xtype:'textfield',
			fieldLabel:'邮箱用户名',
			columnWidth:1,
			anchor:'90%',
			name:'MailUserName',
			id:'MailUserName',
			vtypeText:'请输入联系的邮箱'
		}
,		{
			xtype:'textfield',
			fieldLabel:'邮箱密码',
			columnWidth:1,
			anchor:'90%',
			name:'MailPassword',
			id:'MailPassword',
			inputType:'password'
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
			fieldLabel:'银行邮箱',
			columnWidth:1,
			anchor:'90%',
			name:'BankMail',
			id:'BankMail'
		}
,		{
			xtype:'textfield',
			fieldLabel:'邮件主题',
			columnWidth:1,
			anchor:'90%',
			name:'MailTitle',
			id:'MailTitle'
		}
,		{
			xtype:'textfield',
			fieldLabel:'发送邮件的附件名称',
			columnWidth:1,
			anchor:'90%',
			name:'MailAttName',
			id:'MailAttName'
		}
,		{
			xtype:'textfield',
			fieldLabel:'接收银行邮件的附件主题',
			columnWidth:1,
			anchor:'90%',
			name:'BankAttName',
			id:'BankAttName'
		}
]
});
/*------FormPanle的函数结束 End---------------*/

/*------开始界面数据的窗体 Start---------------*/
if(typeof(uploadBankmainWindow)=="undefined"){//解决创建2个windows问题
	uploadBankmainWindow = new Ext.Window({
		id:'Bankmainformwindow',
		title:'银行联系邮箱设置'
		, iconCls: 'upload-win'
		, width: 600
		, height: 450
		, layout: 'fit'
		, plain: true
		, modal: true
		, x:50
		, y:50
		, constrain:true
		, resizable: false
		, closeAction: 'hide'
		,autoDestroy :true
		,items:bankForm
		,buttons: [{
			text: "保存"
			, handler: function() {
				getFormValue();
			}
			, scope: this
		},
		{
			text: "取消"
			, handler: function() { 
				uploadBankmainWindow.hide();
			}
			, scope: this
		}]});
	}
	uploadBankmainWindow.addListener("hide",function(){
});

/*------开始获取界面数据的函数 start---------------*/
function getFormValue()
{

	Ext.Ajax.request({
		url:'frmOrgBankMail.aspx?method=savemail',
		method:'POST',
		params:{
		    MailId:Ext.getCmp('MailId').getValue(),
			MailName:Ext.getCmp('MailName').getValue(),
			SmtpServer:Ext.getCmp('SmtpServer').getValue(),
			SmtpPort:Ext.getCmp('SmtpPort').getValue(),
			PopServer:Ext.getCmp('PopServer').getValue(),
			PopPort:Ext.getCmp('PopPort').getValue(),
			MailUserName:Ext.getCmp('MailUserName').getValue(),
			MailPassword:Ext.getCmp('MailPassword').getValue(),
			BankName:Ext.getCmp('BankName').getValue(),
			BankMail:Ext.getCmp('BankMail').getValue(),
			MailTitle:Ext.getCmp('MailTitle').getValue(),
			MailAttName:Ext.getCmp('MailAttName').getValue(),
			BankAttName:Ext.getCmp('BankAttName').getValue()		},
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
		url:'frmOrgBankMail.aspx?method=getbankmain',
		params:{
			MailId:selectData.data.MailId
		},
	success: function(resp,opts){
		var data=Ext.util.JSON.decode(resp.responseText);
		Ext.getCmp("MailId").setValue(data.MailId);
		Ext.getCmp("MailName").setValue(data.MailName);
		Ext.getCmp("SmtpServer").setValue(data.SmtpServer);
		Ext.getCmp("SmtpPort").setValue(data.SmtpPort);
		Ext.getCmp("PopServer").setValue(data.PopServer);
		Ext.getCmp("PopPort").setValue(data.PopPort);
		Ext.getCmp("MailUserName").setValue(data.MailUserName);
		Ext.getCmp("MailPassword").setValue(data.MailPassword);
		Ext.getCmp("BankName").setValue(data.BankName);
		Ext.getCmp("BankMail").setValue(data.BankMail);
		Ext.getCmp("MailTitle").setValue(data.MailTitle);
		Ext.getCmp("MailAttName").setValue(data.MailAttName);
		Ext.getCmp("BankAttName").setValue(data.BankAttName);
	},
	failure: function(resp,opts){
		Ext.Msg.alert("提示","获取用户信息失败");
	}
	});
}
/*------结束设置界面数据的函数 End---------------*/

/*------开始获取数据的函数 start---------------*/
var usergridData= new Ext.data.Store
({
url: 'frmOrgBankMail.aspx?method=getmaillist',
reader:new Ext.data.JsonReader({
	totalProperty:'totalProperty',
	root:'root'
},[
	{
		name:'MailId'
	},
	{
		name:'OrgId'
	},
	{
		name:'MailName'
	},
	{
		name:'SmtpServer'
	},
	{
		name:'SmtpPort'
	},
	{
		name:'PopServer'
	},
	{
		name:'PopPort'
	},
	{
		name:'MailUserName'
	},
	{
		name:'MailPassword'
	},
	{
		name:'BankName'
	},
	{
		name:'BankMail'
	},
	{
		name:'MailTitle'
	},
	{
		name:'MailAttName'
	},
	{
		name:'BankAttName'
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
	el: 'userGrid',
	width:'100%',
	height:'100%',
	autoWidth:true,
	autoHeight:true,
	autoScroll:true,
	layout: 'fit',
	id: 'userGrid',
	store: usergridData,
	loadMask: {msg:'正在加载数据，请稍侯……'},
	sm:sm,
	cm: new Ext.grid.ColumnModel([
		sm,
		new Ext.grid.RowNumberer(),//自动行号
		{
			header:'我的邮件名称',
			dataIndex:'MailName',
			id:'MailName'
		},
		{
			header:'Smtp服务',
			dataIndex:'SmtpServer',
			id:'SmtpServer'
		},
		{
			header:'smtp端口',
			dataIndex:'SmtpPort',
			id:'SmtpPort'
		},
		{
			header:'Pop3服务',
			dataIndex:'PopServer',
			id:'PopServer'
		},
		{
			header:'Pop3端口',
			dataIndex:'PopPort',
			id:'PopPort'
		},
		{
			header:'邮箱有户名',
			dataIndex:'MailUserName',
			id:'MailUserName'
		},
		{
			header:'邮箱密码',
			dataIndex:'MailPassword',
			id:'MailPassword'
		},
		{
			header:'银行名称',
			dataIndex:'BankName',
			id:'BankName'
		},
		{
			header:'银行邮箱',
			dataIndex:'BankMail',
			id:'BankMail'
		},
		{
			header:'邮件主题',
			dataIndex:'MailTitle',
			id:'MailTitle'
		},
		{
			header:'发送邮件的附件名称',
			dataIndex:'MailAttName',
			id:'MailAttName'
		},
		{
			header:'接收银行邮件的附件主题',
			dataIndex:'BankAttName',
			id:'BankAttName'
		}		]),
		bbar: new Ext.PagingToolbar({
			pageSize: 0,
			store: usergridData,
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
<body>
<div id='toolbar'></div>
<div id='divForm'></div>
<div id='userGrid'></div>
</body>
</html>
