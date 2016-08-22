<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmFloaw.aspx.cs" Inherits="frame_frmFloaw" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>无标题页</title>
    <script>
    function dosomething(name,url){
		    if(url==null || url == "")
		        return;
		    top.createDiv(name,url);
		}
    </script>
</head>
<body>
    <form id="form1" runat="server">
    <table width="100%" border="0" cellpadding="0" cellspacing="0" >
    <tr>
    <td style="background-image:url(../images/sea.gif);background-repeat:repeat;"></td>
    <td style="background-image:url(../images/sea.gif);background-repeat:repeat;"></td>
    <td></td>
    </tr>
    <tr>
    <td style="background-image:url(../images/sea.gif);background-repeat:repeat;"></td>
    <td><div align="center">
    <img src="../images/<%=getImageUrl() %>" border="0" usemap="#Map"/>
    <%=getMap() %>
    </div></td>
    <td></td>
    </tr>
    <tr>
    <td style="background-image:url(../images/sea.gif);background-repeat:repeat;"></td>
    <td></td>
    <td></td>
    </tr>
    </table>    
    </form>
</body>
</html>
