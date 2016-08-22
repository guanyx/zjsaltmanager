<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmUpLoadFile.aspx.cs" Inherits="Common_frmUpLoadFile" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>无标题页</title>
</head>
<body TOPMARGIN=0 LEFTMARGIN=0 MARGINHEIGHT=0 MARGINWIDTH=0>
    <form id="form1" runat="server">
    <div style="background-color: #99CCFF; width: 350px;">
     <asp:FileUpload ID="FileUpload1" runat="server" CssClass="background-color:#eee;border:1px solid #ccc;" />
     <asp:Button ID="Button1" runat="server" onclick="Button1_Click" 
        Text="上传文件" />
     <asp:HiddenField runat="server" ID="HiddenField1" />
    </div>
    </form>
</body>
</html>

