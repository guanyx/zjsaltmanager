<%@ Page Language="C#" AutoEventWireup="true" EnableEventValidation="false" CodeFile="frmProductCostView.aspx.cs" Inherits="RPT_WMS_frmProductCostView" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>无标题页</title>
    <link rel="stylesheet" type="text/css" href="../../ext3/resources/css/ext-all.css" />
    <script type="text/javascript" src="../../ext3/adapter/ext/ext-base.js"></script>
    <script type="text/javascript" src="../../ext3/ext-all.js"></script>
</head>
<script type="text/javascript">
Ext.BLANK_IMAGE_URL = "../../ext3/resources/images/default/s.gif";
</script>
<script type="text/javascript" src="../../js/ProductSelect.js"></script>
<script type="text/javascript" src="../../js/mulWhSelect.js"></script>
<script type="text/javascript">
function showFrom()
{
    if (selectProductForm == null) {
        parentUrl = "../../CRM/product/frmBaProductClass.aspx?ShowSale=true&select=true&method=getbaproducttypetree";
        showProductForm("", "", "", true);
        selectProductForm.buttons[0].on("click", selectProductOk);
    }
    else {
        showProductForm("", "", "", true);
    }
}
var selectedProductIds = "";
function selectProductOk() {
    var selectProductNames = "";
    selectedProductIds = "";
    var selectNodes = selectProductTree.getChecked();
    for (var i = 0; i < selectNodes.length; i++) {
        if (selectProductNames != "") {
            selectProductNames += ",";
            selectedProductIds += ",";
        }
        selectProductNames += selectNodes[i].text;
        selectedProductIds += selectNodes[i].id + '!' + selectNodes[i].text + '!' + selectNodes[i].attributes.CustomerColumn;
    }
    document.getElementById('TextBox2').value=selectProductNames;
    document.getElementById('hiddenProductClass').value=selectedProductIds;  
}

function showWhTreeForm()
    {
        if(selectWhForm==null)
        {
            var url = "../../crm/DefaultFind.aspx?method=getWhTreeByOrg&ShowCheckBox=true"
            showWhForm("","",url);
            selectWhForm.buttons[0].on("click", selectWhOk);
        }
        else{
            selectWhForm.show();
        }
    }
    
    function selectWhOk(){
        var selectNodes = selectWhTree.getChecked();
            var selectedWhId = "";
            var selectedWhName="";
            for (var i = 0; i < selectNodes.length; i++) {
                if (selectedWhId.length > 0)
                {
                    selectedWhId += ",";
                    selectedWhName+=",";
                }
                selectedWhId += selectNodes[i].id;
                selectedWhName+=selectNodes[i].text;
            }
            document.getElementById('txtWh').value=selectedWhName;
            document.getElementById('hiddenWh').value=selectedWhId;  
        selectWhForm.hide();
    }
</script>   
<body style="margin: 0px; padding: 0px; border-top-style: 0; border-right-style: 0; border-bottom-style: 0; border-left-style: 0; border-width: 0px; border-top-color: 0; border-right-color: 0; border-bottom-color: 0; border-left-color: 0">
    <form id="form1" runat="server">
    <div style="width:100%; background-color: #DFE8F8;">
        <asp:Label ID="Label1" runat="server" Text="仓库：" Font-Size="Small" ></asp:Label>
        <asp:DropDownList ID="DropDownList1"  Visible =false runat="server" Font-Size="Small" >
        </asp:DropDownList>&nbsp;&nbsp
        <asp:Label ID="lblWh" Font-Size="Small" Text="仓库" Visible="false" runat="server" ></asp:Label><asp:TextBox ID="txtWh"  Text=""  runat="server" onclick="showWhTreeForm();"></asp:TextBox>
    <asp:HiddenField ID="hiddenWh" runat="server" />
        <asp:Label ID="Label4" runat="server" Text="存货类别：" Font-Size="Small" ></asp:Label>        
        <asp:TextBox ID="TextBox2" runat="server" onclick="showFrom();"></asp:TextBox>
        <asp:HiddenField ID='hiddenProductClass' runat="server" />
        <asp:Label ID="Label2" runat="server" Text="产品名称：" Font-Size="Small" ></asp:Label>        
        <asp:TextBox ID="TextBox1" runat="server"></asp:TextBox>
    
    </div>
    <div style="background-color: #DFE8F8;">
    <asp:Label Text="查询月份" ID="lblStatDate" runat="server" Font-Size="Small"></asp:Label>
    <asp:DropDownList ID="ddlYear" runat="server">
        </asp:DropDownList>
    <asp:DropDownList ID="ddlMonth" runat="server">
        </asp:DropDownList>
    <asp:CheckBox ID="CheckBox1" runat="server" Text="合并盐品种" Font-Size="Small"  />
    <asp:Button ID="Button1" runat="server" Text="  查询  " BorderStyle="NotSet" 
            Font-Size="Small" onclick="Button1_Click1" />
     <asp:Button ID="Button2" runat="server" Text="  导出  " BorderStyle="NotSet" 
            Font-Size="Small" onclick="Button_print_Click" />
    </div>
    
    <div style="OVERFLOW: auto; HEIGHT: 500px">
    <asp:GridView ID="GridView1" runat="server" CellPadding="1" ForeColor="#333333" 
            BorderWidth="1px" Font-Size="13px" 
            BackColor="#DFE8F8" Width="100%" onrowcreated="GridView1_RowCreated" 
            FooterStyle-Wrap="False" HeaderStyle-Wrap="False" RowStyle-Wrap="False" 
            onrowdatabound="GridView1_RowDataBound" ShowFooter="True">
        <RowStyle BackColor="#EFF3FB" />
        <FooterStyle BackColor="#507CD1" Font-Bold="True" ForeColor="White" />
        <PagerStyle BackColor="#2461BF" ForeColor="White" HorizontalAlign="Center" />
        <SelectedRowStyle BackColor="#507CD1" Font-Bold="True" ForeColor="#669999" />
        <HeaderStyle BackColor="#DFE8F8" Font-Bold="True" ForeColor="#333333" Wrap="false" />
        <EditRowStyle BackColor="#DFE8F8" Wrap="false"/>
        <AlternatingRowStyle BackColor="White" />
    </asp:GridView>        
    </div>
    <div style="display:none">
    <asp:Label ID="Label3" runat="server"></asp:Label>
    </div>
    </form>
</body>
</html>
