<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmOrgBusiUseStatics.aspx.cs" Inherits="RPT_WMS_frmOrgBusiUseStatics" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>
	    无标题页
    </title>
    <style>
        .GridViewStyle
        {
            font-size: 12px;
            width: 100%;
            border-right: 1px solid #CCCDD2;
            border-bottom: 1px solid #CCCDD2;
            border-left: 1px solid CCCDD2;
            border-top: 1 px solid CCCDD2;
            padding: 2px;
        }
        .GridViewStyle a
        {
            color: #000000;
          text-decoration:none;

        }
        
        .GridViewHeaderStyle th
        {
            border-left: 1px solid #CCCDD2;
            border-right: 1px solid #CCCDD2;
            height: 19px;
            
        }
        
        .GridViewHeaderStyle
        {
            /* background-color: #F6F6F8;*/
            background: url(1.jpg);
        }
        
        .GridViewFooterStyle
        {
            background-color: #5D7B9D;
            font-weight: bold;
            color: White;
        }
        
        .GridViewRowStyle
        {
            height: 20px; /*background-color: #FFFFFF; */
        }
        
        .GridViewAlternatingRowStyle
        {
            height: 20px; /*background-color: #F7F6F3; */
        }
        
        .GridViewRowStyle td, .GridViewAlternatingRowStyle td
        {
            text-indent: 10px;
            color: "#F00";
            border: 1px solid #CCCDD2;
        }
        
        .GridViewSelectedRowStyle
        {
            background-color: #E2DED6;
            font-weight: bold;
            color: #333333;
        }
        
        .GridViewPagerStyle
        {
            background-color: #284775;
            color: #FFFFFF;
        }
        
        .GridViewPagerStyle table /**/ /* to center the paging links*/
        {
            margin: 0 auto 0 auto;
        }
           .xuhao
        {
            background-color: #EEF3F7;
        }
        .sanjiao
        {
            border-top: 4px solid #FFFFFF;
            border-left: 4px solid #000000;
            border-bottom: 4px solid #FFFFFF;
            float: left;
            margin-left: 4px;
            margin-top: 4px;
            background-color: #EEF3F7;
        }
    </style>
    <script type="text/javascript" src="../../js/calendar.js"></script>
</head> 
<body style="margin: 1px; padding: 2px; border-width: 1px;">
    <form id="form1" runat="server">
    <div style="background-color: #DFE8F8">
        <asp:Label ID="Label4" runat="server" Text="开始日期："></asp:Label>
        <asp:TextBox ID="TextBox1" runat="server" onfocus="setday(this,false);"></asp:TextBox>
        <asp:Label ID="Label1" runat="server" Text="结束日期："></asp:Label>
        <asp:TextBox ID="TextBox2" runat="server" onfocus="setday(this,false);"></asp:TextBox>
        <asp:Button ID="Button1" runat="server" Text="查询" onclick="Button1_Click" />
        <asp:Button ID="Button2" runat="server" Text="导出" onclick="Button2_Click" />
    </div>
    <div style="OVERFLOW: auto; "><!--HEIGHT: 600px-->
    <table border="1px" cellpadding="0" cellspacing="0" width="100%" 
            style="border-color: #DFE8F8"> 
    <tr> 
        <td align="center" height="30px" style="font-size: large" valign="middle"> 订单数量与金额分析 </td> 
     </tr>
     <tr>
        <td>  
    <asp:GridView ID="GridView1" runat="server" CellPadding="1" ForeColor="#333333" 
            BorderWidth="1px" Font-Size="13px" 
            BackColor="#DFE8F8" Width="100%" 
            FooterStyle-Wrap="False" HeaderStyle-Wrap="False" RowStyle-Wrap="False" 
            ShowFooter="True" onrowdatabound="GridView1_RowDataBound" 
            AllowSorting="True" onsorting="GridView1_Sorting" 
                onrowcreated="GridView1_RowCreated">
        <RowStyle BackColor="#EFF3FB" />
        <Columns>
            <asp:TemplateField HeaderText="序号">
            </asp:TemplateField>
        </Columns>
        <FooterStyle BackColor="#507CD1" Font-Bold="True" ForeColor="White" />
        <PagerStyle BackColor="#2461BF" ForeColor="White" HorizontalAlign="Center" />
        <SelectedRowStyle BackColor="#507CD1" Font-Bold="True" ForeColor="#669999" />
        <HeaderStyle BackColor="#DFE8F8" Font-Bold="True" ForeColor="#333333" Wrap="false" />
        <EditRowStyle BackColor="#DFE8F8" Wrap="false"/>
        <AlternatingRowStyle BackColor="White" />
    </asp:GridView> 
    </tr>
</table>        
    <div style="height:2px;width:100%"></div>
    <asp:Label ID="Label3" runat="server" BackColor="#99BBE8" Width="100%">请点击查询按钮刷新数据。。。</asp:Label>
    </div>
    
    </form>
</body>
<script type="text/javascript">
    function exportExcel(){
        var w = window.open("./frmOrgBusiUseStatics.aspx?method=export", "Excel", "height=0, width=0");
    }
</script>













</html>
