<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmReportHtml.aspx.cs" Inherits="RPT_SCM_frmReportHtml" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>无标题页</title>
    <link rel="stylesheet" type="text/css" href="../../ext3/resources/css/ext-all.css" />
    <script type="text/javascript" src="../../ext3/adapter/ext/ext-base.js"></script>
    <script type="text/javascript" src="../../ext3/ext-all.js"></script>
    <script type="text/javascript" src="../../js/OrgsSelect.js"></script>
    <script type="text/javascript" src="../../js/ProductSelect.js"></script>
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
    background-color: #cccccc; 
    border-top: solid 0px gray; border-bottom: solid 1px gray; border-left: solid 0px gray; border-right: solid 1px gray;    
}    
td.HLocked {    
/* 水平方向锁住单元格 */   
    z-index: 10;
     position: relative; 
     left: expression(parentNode.parentNode.parentNode.parentNode.scrollLeft);     
    background-color: #cccccc;
    border-top: solid 0px gray; border-bottom: solid 1px gray; border-left: solid 0px gray; border-right: solid 1px gray;    
}    
td.VLocked {    
/* 垂直方向锁住单元格 */   
    z-index: 20; position: relative; top: expression(parentNode.parentNode.parentNode.parentNode.scrollTop);     
    background-color: #cccccc;
    border-top: solid 0px gray; border-bottom: solid 1px gray; border-left: solid 0px gray; border-right: solid 1px gray;    
} 

</style> 
<script type="text/javascript"> 
/**************************************** 
蒋玉龙编制于2002-8-6     星期二 
QQ:66840199 
用时5个小时，功能：实现首行根据边框调整表格大小； 
请保留相关信息 

Powered   by   Stone,   2003-04-15 
****************************************/ 

//modified   by   liu_xc   2004.6.28   对功能进行封装 
function DragedTableWidth(tableId) 
{ 
    var oTable = document.all(tableId); 
    for(var i=0; i <oTable.rows[4].cells.length; i++) 
    {               
        oTable.rows[4].cells[i].onmousemove = function() 
        {                       
            moveCol(this); 
        } 
    } 
    document.body.onmousedown   =   downBody; 
    document.body.onmouseover   =   moveBody; 
    document.body.onmouseup   =   upBody; 
    document.body.onselectstart   =   selectBody; 
    createElementsUsed(); 
} 
//创建需要的中间层 
function   createElementsUsed() 
{ 
    var oDiv=document.createElement( "div"); 
    oDiv.id= "dragWidthDiv"; 
    oDiv.style.height="201";     
    oDiv.style.left="12"; 
    oDiv.style.position="absolute"; 
    oDiv.style.top="50px"; 
    oDiv.style.width="28px"; 
    oDiv.style.zIndex="1"; 
    oDiv.style.display="none";         
    oDiv.innerHTML="<HR id='dragWidthLine' width='1' size='200' noshade color='black'>"; 
    document.body.appendChild(oDiv); 
} 
//modified   by   liu_xc   2004.6.28   对功能进行封装 


//记录鼠标状态,   记录鼠标按下,   记录当前列 
var   curState,   curDown,   curCol; 
var   oldPlace,   newPlace; 

function   getTable(item)   
{ 
    var obj= null; 
    do   
    { 
        if(item.tagName=="TABLE")   
        { 
          obj   =   item; 
          break; 
        } 
        item=item.offsetParent; 
    } 
    while(item!=null);       
    return obj; 
} 

function calculateOffset(item, offsetName)
{ 
    var totalOffset=0; 
    do   
    { 
        totalOffset += eval( 'item.offset' + offsetName); 
        item = item.offsetParent; 
    } 
    while(item != null); 
    return totalOffset; 
} 

function moveCol(objCol)   
{ 
    window.status = window.document.body.scrollLeft; 
    if (!curDown)   
    { 
        //curCol   =   objCol; 
        //鼠标没有按下 
        if(window.event.x + window.document.body.scrollLeft > calculateOffset(objCol,"Left") + objCol.offsetWidth-3)
        { 
                //移动到了相应的部位/改变鼠标 
                curState=true; 
                window.document.body.style.cursor = "col-resize"; 
        } 
        else   
        { 
                curState = false; 
                window.document.body.style.cursor="default "; 
        } 
        curCol=objCol; 
    } 
}   
  
function upBody()   
{ 
    //鼠标抬起/一切恢复原状态     
    if (curState)   
    { 
        //---------------------------调整表格-------------------------- 
        //调整条件:(层左侧+线左侧=线绝对左侧坐标)> 目标的左侧坐标+20 
        newPlace = window.event.x + window.document.body.scrollLeft; 
        if   (dragWidthDiv.offsetLeft + dragWidthLine.offsetLeft > calculateOffset(curCol, "Left") + 20)   
        { 
            if(curCol.width>oldPlace-newPlace) 
                curCol.width   -=   oldPlace   -   newPlace; 
            var curTable = getTable(curCol); 
            if(curTable!=null) 
                curTable.width-=oldPlace-newPlace; 
            //curCol.innerText   =   curCol.width; 
        } 
        //------------------------------------------------------------- 
        curState=false; 
        curDown=false; 
        dragWidthDiv.style.display="none "; 
        window.document.body.style.cursor="default "; 
    } 
} 
  
function downBody()   { 
    //鼠标按下 
    if(curState)   
    { 
        curDown=true; 
        var curTable=getTable(window.event.srcElement); 
        if(curTable!=null)   { 
            //---------定位竖线---------- 
            dragWidthDiv.style.display ="";         //层可见 
            dragWidthLine.style.height=curTable.offsetHeight; 
            dragWidthLine.style.width=1; 
            dragWidthDiv.style.left=window.event.x+window.document.body.scrollLeft-dragWidthLine.offsetLeft; 
            dragWidthDiv.style.top=calculateOffset(curTable,"Top")-dragWidthLine.offsetTop; 
            //--------------------------- 
            oldPlace=window.event.x+window.document.body.scrollLeft; 
        } 
    } 
}   
  
function   moveBody()   
{ 
    //鼠标移动 
    if   (curDown)   
    { 
        //鼠标按下状态 
        dragWidthDiv.style.left=window.event.x + window.document.body.scrollLeft-dragWidthLine.offsetLeft; 
        window.document.body.style.cursor="col-resize"; 
    } 
} 

function selectBody()   { 
    //鼠标选择文本[不支持动态调整？] 
    if(curDown)   //鼠标按下于调整状态 
        window.event.returnValue = false; 
} 

function setTableBorder(objTable)   
{ 
    var i,j; 
    for(i =0;i<objTable.rows.length;i++) 
    { 
        for(j=0;j<objTable.rows(i).cells.length;j++)   
        { 
            if(objTable.rows(i).cells(j).innerHTML   =="") 
                objTable.rows(i).cells(j).innerHTML  ="&nbsp;"; 
        } 
    } 
} 

function advanceMonthChange(changeObj)
{
    var startMonth = document.getElementById("ddlMonth");
    var endMonth = document.getElementById("ddlEndMonth");
    var startIndex = startMonth.selectedIndex;
    var endIndex = endMonth.selectedIndex;
    //违反逻辑
    if(startIndex>endIndex)
    {
        switch(changeObj)
        {
            case"start":
                endMonth.selectedIndex = startIndex;
                break;
            default:
                startMonth.selectedIndex = endIndex;
                break;
        }
    }
}
</script> 
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
    document.getElementById("btnBack").visible=true;
}

function btnBackClick() {
    document.getElementById('reportType').value = "";
    document.getElementById('classType').value = "";
   document.getElementById('btnSearch').click();
   document.getElementById("btnBack").visible=false;
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
        
        var routetree = null;
var routediv = null;
var routeSelectWin = null;
var selectedRouteId = '';
var fieldId = '';
function selectRoute()
{    
    selectedRouteId = '';
    fieldId = this.id;
    if(routediv == null){
        routediv = document.createElement('div');
        routediv.setAttribute('id', 'routetreeDiv');
        Ext.getBody().appendChild(routediv); 
    }
    var Tree = Ext.tree;    
    if( routetree == null){
        routetree = new Tree.TreePanel({
            el:'routetreeDiv',
            style: 'margin-left:0px',
            useArrows:true,//是否使用箭头
            autoScroll:true,
            animate:true,
            width:'150',
            height:'100%',
            minSize: 150,
	        maxSize: 180,
            enableDD:false,
            frame:true,
            border: false,
            containerScroll: true, 
            loader: new Tree.TreeLoader({
               dataUrl:'/crm/DefaultFind.aspx?method=getLineTreeByOrg&OrgId=<% =ZJSIG.UIProcess.ADM.UIAdmUser.OrgID(this)%>'
               })
        });
        routetree.on('click',function(node){  
            if(node.id ==0)//||!node.isLeaf()
                return;
            if(fieldId=='RouteName'){
//                Ext.getCmp('RouteId').setValue(node.id);
//                Ext.getCmp('RouteName').setValue(node.text);
                document.getElementById("txtRouteName").value=node.text;
            }else{
//                selectedRouteId = node.id;
                document.getElementById("hidRouteId").value = node.id;
                document.getElementById("txtRouteName").value=node.text;
            }
            routeSelectWin.hide();
        }); 
        // set the root node
        var root = new Tree.AsyncTreeNode({
            text: '线路情况',
            draggable:false,
            id:'0'
        });
        routetree.setRootNode(root);
    }    
    if( routeSelectWin == null){
        routeSelectWin = new Ext.Window({
             title:'线路信息',
             style: 'margin-left:0px',
             width:500 ,
             height:300, 
             constrain:true,
             layout: 'fit', 
             plain: true, 
             modal: true,
             closeAction: 'hide',
             autoDestroy :true,
             resizable:true,
             items: [routetree] 
        });
        routetree.root.reload();
    }
    routeSelectWin.show();    
}
</script>
</head>
<body  style="margin: 0px; padding: 0px; border-top-style: 0; border-right-style: 0; border-bottom-style: 0; border-left-style: 0; border-width: 0px; border-top-color: 0; border-right-color: 0; border-bottom-color: 0; border-left-color: 0">
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
    <td width="480px">
    <asp:Label id="lblOrg" Visible="false" runat="server" Text="单位信息" Font-Size="Small"></asp:Label>
    <asp:DropDownList ID="ddlOrg" runat="server" 
            Visible="false"  ></asp:DropDownList>
    <asp:Button ID="btnSearch" Text="查     询" Width="100px" Height="24px" class="button"
            runat="server" OnClick="btnSearchClick" OnClientClick="setTimeout(function(){document.getElementById('btnSearch').disabled='disabled';},50);" BorderStyle="NotSet" Font-Size="Small" />
            <asp:Button ID="btnCreate" Text="生成" Width="100px" Height="24px" class="button"
            runat="server" OnClick="btnCreateClick" OnClientClick="setTimeout(function(){document.getElementById('btnCreate').disabled='disabled';},50);" BorderStyle="NotSet" Font-Size="Small" />
    </td><td width="100"><asp:Button ID="btnExport" Text="导出Excel文件" Width="100px" class="button"
                Height="24px" runat="server" OnClick="btnExport_Click" Font-Size="Small" />
                </td><td>
                <asp:Button ID="btnBack" Text="返     回" Width="100px" class="button"
                Height="24px"   runat="server" OnClientClick="btnBackClick(); return false;" 
                Visible=false Font-Size="Small" />
    </td>
    <%--<asp:Button ID="btnPrint" Text ="打印" OnClientClick="window.print();DragedTableWidth('DragedTableWidth'); return false" runat="Server" />
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
    <asp:Label Text="报表种类" ID="lblReportType" runat="server" Font-Size="Small"></asp:Label>   
    <asp:DropDownList 
            ID="ddlReportType" runat="server" 
            onselectedindexchanged="ddlReportType_SelectedIndexChanged" AutoPostBack ="true"></asp:DropDownList>
            <asp:Label Text="统计时间" ID="lblStatDate" runat="server" Font-Size="Small"></asp:Label>
    <%-- <label style="font-size: small">统计时间</label>--%><%--<asp:TextBox ID="txtDay" runat="server"></asp:TextBox>
        <asp:TextBox ID="txtDay1" runat="server"></asp:TextBox>--%>
        <asp:DropDownList ID="ddlYear" runat="server">
        </asp:DropDownList>
        <asp:DropDownList ID="ddlMonth" onchange="advanceMonthChange('start');" runat="server">
        </asp:DropDownList>
        <asp:DropDownList ID="ddlEndMonth" onchange="advanceMonthChange('end');" runat="server">
        </asp:DropDownList>
        <asp:DropDownList ID="ddlQ" runat="server" Visible="false"></asp:DropDownList>
        <asp:TextBox ID="txtDate" runat="server" onfocus="setday(this,false);" 
            onkeydown="event.returnValue=false"></asp:TextBox>
        <asp:TextBox ID="txtEndDate" runat="server" onfocus="setday(this,false);" 
            onkeydown="event.returnValue=false" Visible="false"></asp:TextBox>
        <asp:Label ID="lblProduct" Text="产品类别" runat="server" Font-Size="Small"> </asp:Label><asp:TextBox ID="txtProduct" Text="" runat="server" onclick="showFrom();"></asp:TextBox>
    <asp:HiddenField ID='hiddenProduct' runat="server" />
        <asp:Label ID="lblFinanceDate" Text="关帐时间" runat="server" Visible="true" Font-Size="Small"> </asp:Label><asp:CheckBox ID="chbFinanceDate" runat="server" />
        <asp:Label Text="按仓库统计" ID="lblWhGroup" runat="server" Font-Size="Small"></asp:Label><asp:CheckBox ID="chbWhGroupBy" runat="server" />
        <%--        <asp:DropDownList ID="ddlDepartMent" runat="server" Visible="false"></asp:DropDownList>
    <asp:DropDownList ID="ddlYG" runat="server" Visible="false"></asp:DropDownList>--%>
            
    </td>
    </tr>
    <tr>
    <td>
    <asp:Label ID="lblCustomerName" Text="客户名称" runat="server" Visible="false" Font-Size="Small"> </asp:Label><asp:TextBox ID="txtCustomerName" Text="" runat="server" Visible="false" ></asp:TextBox>
    <asp:Label ID="lblRouteName" Text="线路信息" runat="server" Visible="false" Font-Size="Small"> </asp:Label><asp:TextBox ID="txtRouteName" Text="" runat="server" Visible="false" onfocus="selectRoute();"></asp:TextBox>
    <asp:HiddenField ID="hidRouteId" Value="0" runat="server" /><asp:Label ID="lblWh" Font-Size="Small" Text="仓库" runat="server" ></asp:Label><asp:TextBox ID="txtWh"  Text=""  runat="server" onclick="showWhTreeForm();"></asp:TextBox>
    <asp:HiddenField ID="hiddenWh" runat="server" />
    </td>
    </tr>
    </table>    
        </asp:Panel>
    <asp:HiddenField ID="reportType" runat="server" />
    <asp:HiddenField ID="classType" runat="server" />
    </div>
    <!--startprint 打印开始-->
        <asp:Panel ID="divBoxing" ClassName="divBoxing" style="width: 100%; height:600px;" runat="server" >
        </asp:Panel>
    <!--endprint 打印结束-->
    
    </form>
    <script>
        var height = 368;
        if(document.getElementById("pnlProduct")!=null)
            height=388;
        document.getElementById("divBoxing").style.height=window.screen.height-height;
    </script>
    
</body>
</html>
