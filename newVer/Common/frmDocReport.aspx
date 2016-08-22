<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmDocReport.aspx.cs" Inherits="Common_frmDocReport" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>无标题页</title>
    <script type="text/javascript" src="../js/OfficeOperator.js"></script>
    
</head>
<script>
function getUrl(imageUrl)
{
    var index = window.location.href.toLowerCase().indexOf('/common/');
    var tempUrl = window.location.href.substring(0,index);
    return tempUrl+"/"+imageUrl;
}
</script>
<body>
    <form id="form1" runat="server">
     <object classid='clsid:00460182-9E5E-11d5-B7C8-B8269041DD57' codebase="../Scm/dsoframer.ocx" id='oframe' width='100%' height='100%'>"+
         <param name='BorderStyle' value='1'>
         <param name='TitlebarColor' value='52479'>
         <param name='TitlebarTextColor' value='0'>
         <param name='Toolbars' value='1'> 
         <param name='Menubar' value='1'> 
         </object>
         <%=createDocHtml()%>
    </form>
</body>
</html>
