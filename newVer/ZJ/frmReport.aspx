<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmReport.aspx.cs" Inherits="RPT_SCM_frmReport" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>无标题页</title>
    <link rel="stylesheet" type="text/css" href="../../ext3/resources/css/ext-all.css" />
    <script type="text/javascript" src="../../ext3/adapter/ext/ext-base.js"></script>
    <script type="text/javascript" src="../../ext3/ext-all.js"></script>
    <script type="text/javascript" src="../../js/OrgsSelect.js"></script>
    <script type="text/javascript" src="../../js/ProductSelect.js"></script>
    <script type="text/javascript" src="../../js/ReportTypeSelect.js"></script>
    <script type="text/javascript" src="../../js/RouteSelectChen.js"></script>
    <script type="text/javascript" src="../../js/mulWhSelect.js"></script>
    <style media=print>
.Noprint{display:none;}  
.button{height:18px;width:18px;padding-top:5px;text-align:center}


</style>

<style type="text/css">
    .Freezing { 
     z-index: 10; 
     position: relative; 
     top: expression(this.offsetParent.scrollTop)
    }
   
    .FreezingCol { 
     z-index: 1; 
     left: expression(document.getElementById("pnlHtml").scrollLeft); 
     position: relative
    }
   
    #DataGrid1 tr{color:#003399;background-color:White;}
    
    a:link {
color: #000000;
}
a:visited {
color: #000000;
}
a:hover {
color: #FF9900;
}
a:active {
color: #000000;
} 
   </style>
<style type="text/css">
div#divBoxing {    
    overflow: scroll; border: solid 1px gray; clear:both;position: relative;
}    
td.Locked {    
/* 水平与垂直方向锁住单元格, 不随鼠标或滚动条移动 */   
    z-index: 30; position: relative;
    top: expression(parentNode.parentNode.parentNode.parentNode.scrollTop);     
    left: expression(parentNode.parentNode.parentNode.parentNode.scrollLeft);     
    background-color: #cccccc; text-align: center;     
    border-top: solid 0px gray; border-bottom: solid 1px gray; border-left: solid 0px gray; border-right: solid 1px gray;    
}    
td.HLocked {    
/* 水平方向锁住单元格 */   
    z-index: 10;
     position: relative; 
     left: expression(parentNode.parentNode.parentNode.parentNode.scrollLeft);     
    background-color: #cccccc; text-align: center;     
    border-top: solid 0px gray; border-bottom: solid 1px gray; border-left: solid 0px gray; border-right: solid 1px gray;    
}    
td.VLocked {    
/* 垂直方向锁住单元格 */   
    z-index: 20; position: relative; top: expression(parentNode.parentNode.parentNode.parentNode.scrollTop);     
    background-color: #cccccc; text-align: center;     
    border-top: solid 0px gray; border-bottom: solid 1px gray; border-left: solid 0px gray; border-right: solid 1px gray;    
} 

</style> 
<%=getComboBoxStore() %>
<script>



    Ext.BLANK_IMAGE_URL = "../../ext3/resources/images/default/s.gif";
    var selectOrgIds = orgId;
    var orgId = 1;
    function selectOrgType() {

        if (selectOrgForm == null) {
            var showType = "getcurrentandchildrentree";
            if (orgId == 1) {
                showType = "getcurrentAndChildrenTreeByArea";
            }
            showOrgForm("", "", "../../ba/sysadmin/frmAdmOrgList.aspx?method=" + showType);
            selectOrgForm.buttons[0].on("click", selectOrgOk);
//            if (orgId == 1) {
//                selectOrgTree.on('checkchange', treeCheckChange, selectOrgTree);
//            }
            selectOrgTree.on('checkchange', treeCheckChange, selectOrgTree);
        }
        else {
            showOrgForm("", "", "");
        }
    }
    function selectOrgOk() {
        var selectOrgNames = "";
        selectOrgIds = "";
        var selectNodes = selectOrgTree.getChecked();
        for (var i = 0; i < selectNodes.length; i++) {
            if (selectNodes[i].id.indexOf("A") != -1)
                continue;
            if (selectOrgNames != "") {
                selectOrgNames += ",";
                selectOrgIds += ",";
            }
            selectOrgIds += selectNodes[i].id;
            selectOrgNames += selectNodes[i].text;

        }
        document.getElementById('txtDate').value=selectOrgNames;
        //currentSelect.setValue(selectOrgNames);
    }

//允许单选
    function treeCheckChange(node, checked) {
        selectOrgTree.un('checkchange', treeCheckChange, selectOrgTree);
        if (checked) {
            var selectNodes = selectOrgTree.getChecked();
            for (var i = 0; i < selectNodes.length; i++) {
                if (selectNodes[i].id != node.id) {
                    selectNodes[i].ui.toggleCheck(false);
                    selectNodes[i].attributes.checked = false;
                }
            }
        }
    }
    
    function showTdValue()
    {
        if(excelName=='')
        {
            return true;
        }
        window.open ('../../common/frmDocReport.aspx?ReportName=excel&FileName='+excelName+'&ReportId=-1','','resizable=yes,location=no;');//, 'newwindow', 'height=400, width=800, top=0, left=0'); //这句要写成一行 
        return false;
    }
</script>
<script src="../../js/calendar.js"></script>
    <script language="javascript">
　　var i=0;
　　var izoom = 20;
　　document.onkeydown = zoom;
　　function zoom(){
　　var IEKey = event.keyCode;
　　if (IEKey == 76) {
　　i++;
　　document.all['pnlHtml'].style.zoom=1+i/izoom;
//　　document.body.style.zoom=1+i/10;
　　}
　　if (IEKey == 83) {
　　i--;
//　　document.body.style.zoom=1+i/10;
　　document.all['pnlHtml'].style.zoom=1+i/izoom;
　　}
　　if (IEKey == 82) {
//　　document.body.style.zoom=1;
　　document.all['pnlHtml'].style.zoom=1;
　　i=1;
　　}
　　}
　　
　　function btnlarge()
　　{
　　    i++;
　　    document.all['pnlHtml'].style.zoom=1+i/izoom;
　　}
　　function btnlittle()
　　{
　　    i--;
　　    if(i==-10)
　　        i=0;
　　    document.all['pnlHtml'].style.zoom=1+i/izoom;
　　}
　　
function changeReportType(orgtype) {
    document.getElementById('reportType').value = orgtype;
    document.getElementById('btnSearch').click();
}

function btnBackClick() {
    document.getElementById('reportType').value = "";
    document.getElementById('classType').value = "";
    document.getElementById('btnSearch').click();
}

function changeReportType(orgtype, classId) {
    document.getElementById('classType').value = classId;
    document.getElementById('reportType').value = orgtype;
    document.getElementById('btnSearch').click();
}

function showTdValue()
{
if(excelName=='')
{
    return true;
}
window.open ('../../common/frmDocReport.aspx?ReportName=excel&FileName='+excelName+'&ReportId=-1','','resizable=yes,location=no;');//, 'newwindow', 'height=400, width=800, top=0, left=0'); //这句要写成一行 
return false;
}
</script>
<script type="text/javascript">
function showReportTypeFrom()
    {
        if (selectReportTypeForm == null) {
            parentReportUrl="../../crm/product/frmBaProductTypeForPlan.aspx?method=gettreelist";
            showReportTypeForm("", "", "", true);
            selectReportTypeForm.buttons[0].on("click", selectReportTypeOk);
        }
        else {
            showReportTypeForm("", "", "", true);
        }
    }
    
    var selectedReportTypeIds = "";
        function selectReportTypeOk() {
            var selectReportTypeNames = "";
            selectedReportTypeIds = "";
            var selectNodes =  selectReportTypeTree.getSelectionModel().getSelectedNode();
//            var selectNodes = selectReportTypeTree.getChecked();
//            for (var i = 0; i < selectNodes.length; i++) {
//                if (selectReportTypeNames != "") {
//                    selectReportTypeNames += ",";
//                    selectedReportTypeIds += ",";
//                }
                selectReportTypeNames = selectNodes.text;
                selectedReportTypeIds = selectNodes.id
//            }
            document.getElementById('txtReportType').value=selectReportTypeNames;
            document.getElementById('hiddenReportType').value=selectedReportTypeIds;  
        }
</script>
<script>

    function showFrom()
    {
        if (selectProductForm == null) {
            parentUrl = "../../CRM/product/frmBaProductClass.aspx?select=true&method=getbaproducttree";
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
            document.getElementById('txtProduct').value=selectProductNames;
            document.getElementById('hiddenProduct').value=selectedProductIds;  
        }
        
    function showWhTreeForm()
    {
        if(selectWhForm==null)
        {
            var url = "../../crm/DefaultFind.aspx?method=getSaleDeptData&ShowCheckBox=true"
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
    function showRouteTreeForm()
    {
        if(selectRouteForm==null)
        {
            var url = "../../crm/DefaultFind.aspx?method=getLineTreeByOrg&ShowCheckBox=true"
            showRouteForm("","",url);
            selectRouteForm.buttons[0].on("click", selectRouteOk);
        }
        else{
            selectRouteForm.show();
        }
    }
   
        function selectRouteOk() {
            var selectNodes = selectRouteTree.getChecked();
            var selectedRoutesId = "";
            var selectedRoutesName="";
            for (var i = 0; i < selectNodes.length; i++) {
                if (selectedRoutesId.length > 0)
                {
                    selectedRoutesId += ",";
                    selectedRoutesName+=",";
                }
                selectedRoutesId += selectNodes[i].id;
                selectedRoutesName+=selectNodes[i].text;
            }
            document.getElementById('txtRouteName').value=selectedRoutesName;
            document.getElementById('hiddenRoute').value=selectedRoutesId;  
        }
</script>
</head>
<body style="margin: 0px; padding: 0px; border-top-style: 0; border-right-style: 0; border-bottom-style: 0; border-left-style: 0; border-width: 0px; border-top-color: 0; border-right-color: 0; border-bottom-color: 0; border-left-color: 0">
    <form id="form1" runat="server">
    <OBJECT   id="WebBrowser"   classid="CLSID:8856F961-340A-11D0-A96B-00C04FD705A2"   height=0   width=0>     
  </OBJECT>  
    <div>
    <table bgcolor="#DFE8F8" width='100%'>
    <tr>
    <td>
    
    <asp:Panel ID="pnlDate" runat="server" bgcolor="D6E3F2" Width='100%'>
    
    <table>
    <tr>
    <td>
    <table cellpadding="0" cellspacing="0" >
    <tr>
    <td width="100">
    <asp:Button ID="btnSearch" Text="查     询" Width="100px" Height="24px" class="button"
            runat="server" OnClick="btnSearchClick" BorderStyle="NotSet" Font-Size="Small" />    
    </td><td width="100"><asp:Button ID="btnExport" Text="导出Excel文件" Width="100px" class="button"
                Height="24px" runat="server" OnClick="btnExport_Click" Font-Size="Small" />
    </td><td width="100"><asp:Button ID="Button1" Text="导出到Excel模板" Width="100px" class="button"
                Height="24px" runat="server" OnClientClick="showTdValue(); return false" Font-Size="Small" /></td><td width="100"><asp:Button ID="btnBack" Text="返     回" Width="100px" class="button"
                Height="24px"   runat="server" OnClientClick="btnBackClick(); return false;" 
                Visible=false Font-Size="Small" />
    <%--<asp:Button ID="btnPrint" Text ="打印" OnClientClick="window.print(); return false" runat="Server" />
    <asp:Button ID="Button1" Text ="打印预览" OnClientClick="document.all.WebBrowser.ExecWB(7,1); return false" runat="Server" />
    <asp:Button ID="btnPrintCurrent" Text ="放大" OnClientClick="btnlarge(); return false" runat="Server" />
    <asp:Button ID="btnPrintSet" Text ="缩小" OnClientClick="btnlittle(); return false" runat="Server" />--%>
    </td><td>
        &nbsp;
        </td>
        </tr>
        </table>
    </td>
    </tr>
    <tr>
    <td>
     <asp:Label id="lblOrg" Visible="false" runat="server" Text="单位信息" Font-Size="Small"></asp:Label>
    <asp:DropDownList ID="ddlOrg" runat="server" AutoPostBack="true" 
            onselectedindexchanged="ddlOrg_SelectedIndexChanged" Visible="false"  ></asp:DropDownList>
    <asp:Label Text="报表种类" ID="lblReportType" runat="server" Font-Size="Small"></asp:Label>   
    <asp:DropDownList 
            ID="ddlReportType" runat="server" 
            onselectedindexchanged="ddlReportType_SelectedIndexChanged" AutoPostBack ="true"></asp:DropDownList>
            <asp:Label Text="统计时间" ID="lblStatDate" runat="server" Font-Size="Small"></asp:Label>
    <%-- <label style="font-size: small">统计时间</label>--%><%--<asp:TextBox ID="txtDay" runat="server"></asp:TextBox>
        <asp:TextBox ID="txtDay1" runat="server"></asp:TextBox>--%>
        <asp:DropDownList ID="ddlYear" runat="server">
        </asp:DropDownList>
        <asp:DropDownList ID="ddlMonth" runat="server">
        </asp:DropDownList>
        <asp:DropDownList ID="ddlQ" runat="server" Visible="false"></asp:DropDownList>
        <asp:TextBox ID="txtDate" runat="server" onfocus="setday(this,false);" 
            onkeydown="event.returnValue=false"></asp:TextBox>
        <asp:TextBox ID="txtEndDate" runat="server" onfocus="setday(this,false);" 
            onkeydown="event.returnValue=false" Visible="false"></asp:TextBox>
                <asp:Label Text="质检类型" ID="lblCheckType" runat="server" Font-Size="Small"></asp:Label><asp:DropDownList ID="ddlCheckType" runat="server" Visible="true"></asp:DropDownList>
            <asp:CheckBox ID="chbOrg" Text="显示上报单位" runat="server" Checked="false" />
    </td>
    </tr>
    <tr>
    <td>
    <table>
    <tr>
    <td>
    
    </td>
    <td>
    <asp:Panel ID="pnlProduct" runat="server" Visible="false">
    <asp:Label ID="lblProduct" Text="产品类别" runat="server" Font-Size="Small"> </asp:Label><asp:TextBox ID="txtProduct" Text="" runat="server" onclick="showFrom();"></asp:TextBox>
    <asp:HiddenField ID='hiddenProduct' runat="server" />
       
    </asp:Panel>
    </td>
    </tr>
    </table>
        
    </td>
    </tr>
    <tr>
    <td>
    
    </td>
    </tr>
    </table>    
        </asp:Panel>
    </td>
    </tr>
    
    
    </table>
    <asp:HiddenField ID="reportType" runat="server" />
    <asp:HiddenField ID="classType" runat="server" />
    <!--startprint 打印开始-->
        <asp:Panel ID="divBoxing" CssClass="divBoxing" style="width: 98%; height: 400px;" runat="server" >
        </asp:Panel>
    <!--endprint 打印结束-->
    </div>
    </form>
</body>
</html>
