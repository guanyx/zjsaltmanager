<%@ Page Title="主页" Language="C#" AutoEventWireup="true" CodeFile="Default.aspx.cs" Inherits="_Default" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en">
<head id="Head1" runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
    <title></title>
    <style type="text/css">
    body
    {
        margin: 0px;
        padding: 0px;
        font-size: 12px;
        font-family: Tahoma,Verdana,微软雅黑,新宋体;
    }
    a:link {
	    text-decoration: none;
	    color: #666;
    }

    a:visited {
	    text-decoration: none;
	    color: #666;
    }

    a:hover {
	    text-decoration: none;
	    color: #2478b4;
    }

    a:active {
	    text-decoration: none;
	    color: #666;
    }
    .content {
        height: 580px;
        position: relative;
        zoom: 1;
        background-image: url("../images/loginbg.jpg");
        background-repeat: no-repeat;
    }
    .logo
    {
        position: absolute;
        z-index: 2;
        left: 1px;
        top: 1px;
        width: 76px;
        height: 60px;
    }
    .login
    {
        z-index: 2;
        position: absolute;
        left: 556px;
        top: 150px;
        width: 270px;
        height: 180px;
        /*border: 1px solid #000000;*/
        margin-left:16px;
    }
    .rightsave
    {
        z-index: 2;
        position: absolute;
        left: 65px;
        top: 480px;
        width: 386px;
        height: 37px;
    }
    .footer
    {
        margin-top: 5px;
        position: relative;
        zoom: 1;
    }
    </style>
</head>
<body style="align:center">
    <form name="frmLogin" method="post" action="Default.aspx?method=Login" onsubmit="return submitForm();">
    <div style="width: 960px;margin: 0 auto;display: block;">
        <div style="height: 40px;position: relative;zoom: 1;display: block;"></div>
        <div class="content">
           <div class="logo"></div>
           <div class="login">
               <table id="ctlLogin" cellspacing="0" cellpadding="0" style="border-style:None;border-collapse:collapse;">
	                <tbody><tr>
		                <td>
                                    <table style="width:270px;height:180px;">
                                        <tbody><tr style="height:20px;">
                                           <td colspan="2" style="color:Red;"></td>
                                        </tr>
                                        <tr style="height:35px;">
                                           <td>用户：</td>
                                           <td>                        
                                                <input name="login_user" type="text" id="login_user" size="26" value="0000lh" style="width: 180px; height: 20px;
                                                line-height: 18px; border: 1px #A4BED4 solid;background-color: #FAFFBD;">
                                                <span id="ctlLogin_UserNameRequired" title="用户名不能为空！" style="color:Red;font-size:Large;font-weight:bold;visibility:hidden;">*</span>
                                            </td>
                                        </tr>
                                        <tr style="height:35px;">
                                           <td>密码：</td>
                                           <td>  
                                                <input name="login_password" type="password" id="login_password" size="26" value="123456" style="width: 180px;
                                                    height: 20px; line-height: 18px; border: 1px #A4BED4 solid;background-color: #FAFFBD;">
                               
                                           </td>
                                        </tr>
                                        <tr style="height:35px;">
                                           <td>验证码：</td>
                                           <td>
                                                    <input name="ValidateCode" type="text" id="ValidateCode" size="12" style="width: 72px; height: 20px;
                                                        line-height: 18px; border: 1px #A4BED4 solid;">
                                                    <span id="ctlLogin_ValidateCodeRequired" title="校验码不能为空！" style="color:Red;font-size:Large;font-weight:bold;visibility:hidden;">*</span>
                                
                                                &nbsp; <a href="javascript:change();" tabindex="-1">
                                                    <img id="ctlLogin_Image2" src="Default.aspx?method=getValidateCode" style="height:25px;width:80px;position: absolute; border:1px solid #A4BED4; display: inline;">
                                                </a>
                                           </td>
                                        </tr>
                                        <tr style="height:30px;">
                                         <td></td>
                                         <td>
                                             <a href="#" title="" onclick="javascript:ForgetPwd();">忘记密码？</a>&nbsp;&nbsp;&nbsp;&nbsp;<a href="#" title="" onclick="javascript:EditPassword();">修改密码？</a>  
                                         </td>
                                        </tr>
                                        <tr style="height:10px;">
                                           <td colspan="2" style="color:Red;"></td>
                                        </tr>
                                        <tr>
                                          <td>
                                        </td>
                                          <td style="padding-left:88px;">
                                          <input type="image" name="ctlLogin$LoginButton" id="ctlLogin_LoginButton" src="images/log.png"  style="height:31px;width:93px;" />
                          
                                         </td>
                         
                                        </tr>
                                    </tbody></table>
                                </td>
	                </tr>
                </tbody></table>
               
                           </div>
            <div class="rightsave">
                <p><font color="red">浙江省盐务管理局</font>|<font color="blue">浙江省盐业集团有限公司</font></p><!--img src="../images/tab-strip-bg.gif" alt="版权信息"-->
                <p>盐产品质量检测中心版权所有</p>
            </div>
        </div>
        <div class="footer"></div>
    </div>
    </form>
</body>
<script type="text/javascript">
    var isLogin = false;
    function change() 
    {
      var myDate = new Date();
      document.getElementById('ctlLogin_Image2').src = "Default.aspx?method=getValidateCode&" + 'NoMean=' + myDate.toLocaleString();
    }
    function submitForm() {
        if (frmLogin.login_user.value == "") {
            alert("登录名称不能为空!");
            frmLogin.login_user.focus();
            frmLogin.login_user.select();
            return false;
        }
        if (frmLogin.login_password.value == "") {
            alert("登录密码不能为空!");
            frmLogin.login_password.focus();
            frmLogin.login_password.select();
            return false;
        }
        if (frmLogin.ValidateCode.value == "") {
            alert("验证码不能为空!");
            frmLogin.ValidateCode.focus();
            frmLogin.ValidateCode.select();
            return false;
        }
	    if(isLogin)
	    {
		     alert("正在登录!");
		     return false;
	    }
	    else
		    isLogin = true;
        return true;
    }
    function ForgetPwd(){
        alert("请联系系统管理员进行初始化！");
    }
    function popupWin(szUrl,w,h,winname){
            var top=screen.availHeight/2-h/2;
            var left=screen.availWidth/2-w/2;
            if(winname == ""){
              winname = "newwin";
            }
            return window.open(szUrl, winname, "height="+h+", width="+w+", top="+top+", left="+left
            +", toolbar=no, menubar=no, scrollbars=yes, location=no, status=no, resizable=yes" ) ;
    }
    function EditPassword(){
        var theUrl = "../chgPswd.aspx";
        popupWin(theUrl,349,184,'chgPswd');
    }
</script>
</html>
