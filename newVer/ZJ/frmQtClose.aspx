<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmQtClose.aspx.cs" Inherits="ZJ_frmQtClose" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>质检报告提交时间处理</title>
    <meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
    <link rel="stylesheet" type="text/css" href="../ext3/resources/css/ext-all.css" />
    <script type="text/javascript" src="../ext3/adapter/ext/ext-base.js"></script>
    <script type="text/javascript" src="../ext3/ext-all.js"></script>  
    <script type="text/javascript" src="../js/operateResp.js"></script>    
    <script type="text/javascript" src="../js/ExtJsHelper.js"></script>
</head>
<body>
    <form id="form1" runat="server">
    <table>
        <tr>
            <td>
                <asp:Label ID="lblCloseMonth" runat="server"></asp:Label>
            </td>
            <td>
                <asp:Button ID="btnClose" runat="server" Text="关帐" OnClick="btnCloseClick" />
            </td>
            <td>
                关帐后这个月的质检报告就不允许上报了哦！想上报的话，要取消关帐
            </td>
        </tr>
        <tr>
            <td>
                <asp:Label ID="lblCancel" runat="server"></asp:Label>
            </td>
            <td>
                <asp:Button ID="btnCancel" runat="server" Text="取消关帐" OnClick="btnCancelClick" />
            </td>
            <td></td>
        </tr>
    </table>
    <asp:Label ID="lblMessage" runat="server" ></asp:Label>
    </form>
</body>
</html>
