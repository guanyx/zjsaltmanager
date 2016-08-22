<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmPrintConfig.aspx.cs" Inherits="BA_sysadmin_frmOrgConfig" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>无标题页</title>
    <link rel="stylesheet" type="text/css" href="../../ext3/resources/css/ext-all.css" />
<script type="text/javascript" src="../../ext3/adapter/ext/ext-base.js"></script>
<script type="text/javascript" src="../../ext3/ext-all.js"></script>
<script type="text/javascript" src="../../js/operateResp.js"></script>
</head>
<%=getComboBoxStore() %>
<script type="text/javascript">
Ext.onReady(function(){
    /*------实现toolbar的函数 start---------------*/
    var Toolbar = new Ext.Toolbar({
	    renderTo:"toolbar",
	    items:[{
		    text:"保存设置",
		    icon:"../../Theme/1/images/extjs/customer/add16.gif",
		    handler:function(){
		        Ext.Ajax.request({
                    url: 'frmPrintConfig.aspx?method=saveconfig',
                    method: 'POST',
                    params: {
                        newPrintOn: Ext.getCmp("newPrintOn").getValue(),
                        printTitle:Ext.getCmp("printTitle").getValue()
                        
                    },
                   success: function(resp,opts){ 
                       checkExtMessage(resp);                       
                   },
		           failure: function(resp,opts){  /* Ext.Msg.alert("提示","保存失败"); */    }
                });
		    }
		    },'-']
    });
    
    /*------实现FormPanle的函数 start---------------*/
var orgConfigForm=new Ext.form.FormPanel({
	renderTo:'divForm',
	frame:true,
	title:'打印通用设置',
	labelWidth: 155,
    labelAlign: 'right',
	items:[
		{
			xtype:'checkbox',
			fieldLabel:'是否启用新打印功能',
			columnWidth:1,
			anchor:'70%',
			name:'newPrintOn',
			id:'newPrintOn',
			checked:newPrintOn
		}
,		{
			xtype:'textfield',
			fieldLabel:'打印单据抬头自定义设置',
			columnWidth:1,
			anchor:'70%',
			name:'printTitle',
			id:'printTitle',
			value:printTitle
		}
]
});
})
</script>
<body>
<div id='toolbar'></div>
    <div id='divForm'>    
    </div>
</body>
</html>
