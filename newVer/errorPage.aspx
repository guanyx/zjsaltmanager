<%@ Page Language="C#" AutoEventWireup="true" CodeFile="errorPage.aspx.cs" Inherits="errorPage" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>权限验证错误</title>
    <link rel="stylesheet" type="text/css" href="Theme/1/css/frame/table-style.css" />
    <link rel="stylesheet" type="text/css" href="Theme/1/css/frame/main-style.css" />
</head>
<script type="text/javascript">
var t = '<%=errCode %>';
var m = "<%=errMessage %>";
if(t=='1001'||t=='1003'){
    m = m.replace(/<a (.+?)>(.*?)<\/a>/ig,"$2");
    if(window.confirm(m)) 
        top.window.location.href="login.html";
}else if(t=='1002'){
    if(window.confirm(m))        
        window.open("fastlogin.html?loginUser="+top.loginUser,"快速登录","height=150,width=335,status=no,toolbar=no,menubar=no,location=no"); 
}else{
    window.alert(m)
    window.close();
}
</script>
