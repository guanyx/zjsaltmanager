<%@ Page Language="C#" AutoEventWireup="true" CodeFile="customerLogin.aspx.cs" Inherits="SCM_portel_customerLogin" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>客户登陆界面</title>
    <meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
    <link rel="stylesheet" type="text/css" href="../../ext3/resources/css/ext-all.css" />  
    <script type="text/javascript" src="../../ext3/adapter/ext/ext-base.js"></script>  
    <script type="text/javascript" src="../../ext3/ext-all.js"></script>      
</head>  
<body>  
<div id="outer">  
    <div id="middle">  
        <div id="inner">  
        <div id="container">  
                      
        </div>  
        </div>  
    </div>  
</div>   
</body> 
<script type="text/javascript">  
Ext.onReady(function(){   
    var loginform = new Ext.form.FormPanel({  
        renderTo:'container',  
        title:'会员登陆',  
        labelSeparator:":",  
        collapsible :true,  
        width:280,  
        height:150,  
        id:'login',  
        labelWidth: 70,  
        bodyStyle: 'padding:5px 5px 0 10px',  
        border: false,  
        name:'login',  
        frame:true,          
        defaults:{width:170,xtype:'textfield'},  
        items:[  
            new Ext.form.TextField({  
            fram:true,  
            fieldLabel:"用户名",  
            name:'login_user',
            id:'login_user',   
            allowBlank:false,  
            blankText:'用户名不能为空'  
        }),{  
            fieldLabel:"密码",  
            name:'login_password',
            id:'login_password',
            allowBlank:false,  
            inputType:'password',  
            blankText:'密码不能为空'  
//        },{  
//            name: 'vcode',  
//            id: 'vcode',  
//            fieldLabel: '验证码',  
//            maxLength: 4,  
//            width: 80,  
//            allowBlank: false,  
//            blankText: '验证码不能为空!'  
       }],  
        keys:{  
            key: 13,  
            fn:login  
        },  
        buttons:[{  
            text:'提 交',  
            handler:login  
        },{  
            text:'重置',handler:function(){  
                loginform.form.reset();  
            }  
        }]  
    });  
    function login(){  
        Ext.Ajax.request({
            url:'customerLogin.aspx?method=login',
            params: {
                login_user: Ext.getCmp('login_user').getValue() ,
                login_password: Ext.getCmp('login_password').getValue()
            },
            success: function(resp, opts) {
                var data=Ext.util.JSON.decode(resp.responseText);
                if(data.sucess=='false'){
                    alert(data.message);
                }else{
                    window.location.href=data.url;
                }
            },
            failure: function(resp, opts) {
                Ext.Msg.alert("提示", "登陆失败，网络异常！");
            }
        });
    }  
      
}) 
</script>   
</html>   