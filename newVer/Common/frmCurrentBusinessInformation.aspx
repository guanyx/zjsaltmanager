<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmCurrentBusinessInformation.aspx.cs" Inherits="Common_frmCurrentBusinessInformation" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>无标题页</title>
</head>
<body>
    <form id="form1" runat="server">
    <div>当前还没有开票的订单数<%=orderNoBillCount.ToString() %>;<p />
    当前还没有付款的订单数    <%=orderNoPayCount.ToString() %>;<p></p>
    当前还没有付款和开票的订单数<%=orderNoPayNoBillCount.ToString() %>;<p></p>
    当前退货还没有退款的退货单数<%=returnNoPayedCount.ToString() %><p></p>
    当前退货还没有入库的退货单数<%=returnNoInCount.ToString() %><p></p>
    当前退货还没有开红字的退货单数<%=returnNoRedCount.ToString() %><p></p>
    当前采购分割中还没有入库的单据数<%=purchNoStore.ToString() %>;<p></p>
    当前采购订单已核销未结算数<%=purchCheckNoPayCount.ToString() %>;<p></p>
    当前移库已经出库但是还没有入库的单据数<%=moveNoInCount.ToString() %><p></p>
    当前升溢单还没有完成的单据数<%=storeOverCount.ToString() %><p></p>
    当前损耗单还没有完成的单据数<%=storeLosingCount.ToString() %>
    
    </div>
    </form>
</body>
</html>
