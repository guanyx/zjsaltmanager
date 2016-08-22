<%@ Page Language="C#" AutoEventWireup="true" CodeFile="test.aspx.cs" Inherits="SCM_test" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>无标题页</title>
    <meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
    <link rel="stylesheet" type="text/css" href="../ext3/resources/css/ext-all.css" />
    <script type="text/javascript" src="../ext3/adapter/ext/ext-base.js"></script>
    <script type="text/javascript" src="../ext3/ext-all.js"></script>
    <link rel="stylesheet" type="text/css" href="../ext3/example/file-upload.css" />
    <script type="text/javascript" src="../ext3/example/FileUploadField.js"></script>
</head>
<body>
    <div id="toolbar">    
    </div>
    <div id='divForm'></div>
</body>
</html>
<script type="text/javascript">
Ext.onReady(function() {
/*------实现toolbar的函数 start---------------*/
var Toolbar = new Ext.Toolbar({
    renderTo: "toolbar",
    items: [{
        text: "导出",
        icon: "../../Theme/1/images/extjs/customer/delete16.gif",
        handler: function() { viewContractAttach();}
    }]
    });      
function viewContractAttach(){    
    if (!Ext.fly('test'))   
    {   
        var frm = document.createElement('form');   
        frm.id = 'test';   
        frm.name = id;   
        frm.style.display = 'none';   
        document.body.appendChild(frm);   
    }   
    Ext.Ajax.request({   
        url: 'test.aspx?method=exportInvoice', 
        form: Ext.fly('test'),   
        method: 'POST',     
        isUpload: true,  
        DetailInfo: '发票序号信息'
    });  
}
//------
function importContractAttach(){    
    if (!Ext.fly('test'))   
    {   
        var frm = document.createElement('form');   
        frm.id = 'test';   
        frm.name = id;   
        frm.style.display = 'none';   
        document.body.appendChild(frm);   
    }   
    Ext.Ajax.request({   
        url: 'test.aspx?method=exportInvoice', 
        form: Ext.fly('test'),   
        method: 'POST',     
        isUpload: true,  
        DetailInfo: '发票序号信息'
    });  
}
/*------实现FormPanle的函数 start---------------*/
var crmContract = new Ext.form.FormPanel({
    url: '',
    renderTo: 'divForm',
    frame: true,
    title: '',
    labelAlign: 'left',
    buttonAlign: 'center',
    bodyStyle: 'padding:5px',
    labelWidth: 55,
    width:400,
    fileUpload:true, 
    buttons:[{
	    text: "导入"
		, handler: function() {
		    crmContract.getForm().submit({  
                        url : 'test.aspx?method=importInvoice',
                        method: 'POST',
                        params:{
                            OtherInfo:'其他信息'
                        },
                        success: function(form, action){  
                           Ext.Msg.alert("提示", "导入成功");;  
                        },      
                       failure: function(){      
                          Ext.Msg.alert("提示", "导入失败");
                       }  
                 });  
		}
		, scope: this		
    }],
    defaults: {
       msgTarget: 'side'
    },
    items: [
	{
	    layout: 'form',
	    border: false,
	    columnWidth: 1,
	    items: [
			{
			    xtype: 'fileuploadfield',
			    fieldLabel: '合同附件',
			    emptyText:'请选择附件',
			    anchor: '90%',
			    name: 'ContarctAttach',
			    id: 'ContarctAttach',
			    buttonText: '选择'
                //disabled:true
                //readOnly:true,
			}
	]
	}]
});

});
</script>