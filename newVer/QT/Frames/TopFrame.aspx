<%@ Page Language="C#" AutoEventWireup="true" CodeFile="TopFrame.aspx.cs" Inherits="QT_Frames_TopFrame" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>无标题页</title>
	<script type="text/javascript" src="../../ext3/adapter/ext/ext-base.js"></script>	
	<script type="text/javascript" src="../../ext3/ext-all.js"></script>
    <style type="text/css">
        * {
            font-size: 12px;
            font-family: Tahoma,Verdana,微软雅黑,新宋体;
        }
        body {
	        margin: 0px;
	        padding: 0px;
	        overflow:hidden; 	    
            background:url('../../images/icon_subsystem.jpg') no-repeat;
	    }/*body*/    
        a:hover 
        {
            border: 1px solid #7EABCD;
            background: url('../../images/sub_menu_hover.png') repeat-x left bottom;
            _padding: 0px 5px 0px 0px;
            -moz-border-radius: 3px;
            -webkit-border-radius: 3px;
            font-weight:bold;
        }
	    .icon-about{
	        background:url('../../images/about.png') no-repeat;
        }
        .icon-logout
        {
            background:url('../../images/logout.jpg') no-repeat;
        }
        .icon-password
        {
            background:url('../../Theme/1/images/frame/lock.jpg') no-repeat;
        }
        .linkbutton
        {
            display: inline-block;
            padding: 6px 0px 6px 1px;
            line-height: 16px;
            height: 18px;
            color: #444;
        }
    </style>
</head>
<body style="margin: 0px;padding: 0px;">
    <div style="float:right;width:200px;height:32px;text-align:right; border:1px solid gray;">
        <a href="javascript:about();" id="aboutbut" plain="true" style="padding-left: 3px;height: 25px;text-decoration: underline;"><span class="linkbutton"><span class="icon-about" style="padding-left: 20px; height:20px;line-height:20px; ">关于</span></span></a>
        <a href="javascript:EditPassword();" id="editpassword" plain="true" style="padding-left: 3px;height: 25px;text-decoration: underline;"><span class="linkbutton"><span class="icon-password" style="padding-left: 20px; ">修改密码</span></span></a>&nbsp;&nbsp;
        <a href="javascript:logout();" id="exitbut" plain="true" style="padding-left: 3px;height: 25px;text-decoration: underline;"><span class="linkbutton"><span class="icon-logout" style="padding-left: 20px; ">退出</span></span></a>
        &nbsp;
    </div>
    <object id="printControl" classid="http:WinWebPrintControl.dll#WinWebPrintControl.UserControl1" height=0px width=0px VIEWASTEXT>
</object>
</body>
<script type="text/javascript">
function about(){
}
function logout(){
  if(confirm("确定离开？")){    
    var submitForm = parent.document.createElement("FORM");
    parent.document.body.appendChild(submitForm);
    submitForm.method = "POST";
    submitForm.action= "../../Default.aspx?method=logout";
    submitForm.target="_top";
    //window.close();
    submitForm.submit();
  }
}

function EditPassword(){
    var theUrl = "../../chgPswd.aspx";
    popupWin(theUrl,349,184,'chgPswd');
}
function popupWin(szUrl,w,h,winname){
        var top=screen.availHeight/2-h/2;
        var left=screen.availWidth/2-w/2;
        if(winname == ""){
          winname = "newwin";
        }
        return window.open(szUrl, winname, "height="+h+", width="+w+", top="+top+", left="+left
        +", toolbar=no, menubar=no, scrollbars=yes, location=no, status=no, resizable=yes" ) ;
}
    function getPrintControl() {
        return document.getElementById("printControl");
    }
</script>
</html>
