<%@ Page Language="C#" AutoEventWireup="true" CodeFile="alarmcontent.aspx.cs" Inherits="frame_alarm_Default" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title></title>
<script type="text/javascript" src="../../js/Ajax.js"></script>

<style>
/* 通用 */
html, body, ul, li, p, h1, h2, h3, h4, h5, h6, form, fieldset, table, td, img {margin: 0;padding: 0;border: 0;}
ul{list-style-type:none;}
select,input{vertical-align:middle;}
body {background:#fff;color:#333;font-family:"宋体";font-size:12px;padding:0px 0;}
td,p,li,select,input,textarea {font-size:13px;}
a {text-decoration: none;}
a:link {color: #333;}
a:visited {color: #333;}
a:hover, a:active, a:focus {color: #f00;text-decoration:underline;}
.clearit{clear:both;font-size:0;line-height:0;height:0;overflow:hidden;}
.space{height:10px;background:#fff;overflow:hidden;clear:both;}
#wrap{width:950px;margin:0 auto;background:#fff;overflow:hidden; }
.blogrecommend{width:260px;height:190px;background:url(tc_bj.gif) no-repeat left top;overflow:hidden;}
.blogrecommend .BR_title{height:30px;}
.BR_ImgTxt{width:250px;margin:0 auto;overflow:auto;padding:5px 0;}
.BR_ImgTxt img{float:left;border:1px solid #000;}
.BR_ImgTxt ul{line-height:20px;padding-left:90px;}
.BR_ImgTxt li{padding-left:8px;background:url(images/heidian.gif) no-repeat left center;}
.blogrecommend p{line-height:20px;padding-left:10px;}
</style>
<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE7" />
</head>
<script type="text/javascript">
var strFullPath=window.document.location.href; 
var strPath=window.document.location.pathname; 
var pos=strFullPath.indexOf(strPath); 
var prePath=strFullPath.substring(0,pos); 
var postPath=strPath.substring(0,strPath.substr(1).indexOf('/')+1);
function showMsg(msg){
if(msg!="")
    document.getElementById("newMsgHint").innerHTML=msg;
}
function showCount(msg){
var strs= new Array(); //定义一数组 
strs=msg.split(":"); //字符分割 
if(strs[1]!="0"&&strs[1]!=0)
    document.getElementById(strs[0]).innerHTML=strs[1];
}
</script>
<body  style= "background-color:transparent "><div class="blogrecommend">
  <div class="BR_title"></div>
  <div class="BR_conts">    
    <div class="" id="shBlogP"> 
      <% if (is_purchase_alerm)
         { %>
      <p id='purchase'>
       ·<a href='javascript:show_content("purchase")'>等待提交发运单记录: <font color='blue' id='purchaseid'>0</font> 条.</a><br>
      </p>
      <script type="text/javascript">
        Ajax(prePath+"/DeskTop.aspx?method=getPurchaseCount",showCount);
      </script>
      <% } %>
      <% if (is_distribute_alerm)
         { %>
      <p id='distribute'>
       ·<a href='javascript:show_content("distribute")'>等待分配发运单记录: <font color='blue' id='distributeid'>0</font> 条.</a><br>
      </p>
      <script type="text/javascript">
        Ajax(prePath+"/DeskTop.aspx?method=getDistributeCount",showCount);
      </script>
      <% } %>
      <% if (is_send_alerm)
         { %>
      <p id='stock'>
       ·<a href='javascript:show_content("stock")'>采购入库提醒信息记录: <font color='blue' id='stockid'>0</font> 条.</a><br>
      </p>
      <script type="text/javascript">
        Ajax(prePath+"/DeskTop.aspx?method=getStockCount",showCount);
      </script>
      <% } %>
      <% if (is_purchase_alerm||is_send_alerm)
         { %>
	  <span style="line-height: 20px; color: #003366; font-size: 12px;font-style: normal;"> &nbsp;&nbsp;————————————————————</span>
      <% } %>
      <% if (is_wh_alerm)
         { %>
      <p id='warehouse'>
       ·<a href='javascript:show_content("wharehouse")'>仓库预警信息记录: <font color='blue'  id='wharehouseid'>0</font> 条.</a><br>
      </p>
      <script type="text/javascript">
        Ajax(prePath+"/DeskTop.aspx?method=getWharehouseCount",showCount);
      </script>
      <% } %>
      <% if (is_receive_alerm)
         { %>
      <p id='receive'>
       ·<a href='javascript:show_content("receive")'>客户应收款提醒记录: <font color='blue' id='receiveid'>0</font> 条.</a><br>
      </p>
      <script type="text/javascript">
        Ajax(prePath+"/DeskTop.aspx?method=getReceiveCount",showCount);
      </script>
      <% } %>
      <% if (is_wh_alerm || is_receive_alerm)
         { %>
	  <span style="line-height: 20px; color: #003366; font-size: 12px;font-style: normal;"> &nbsp;&nbsp;————————————————————</span>
      <% } %>
      <p id='message'>
      ·最新公告: <font color='blue' id='newMsgHint'>无消息.</font>
      </p>
      <script type="text/javascript">
        Ajax(prePath+"/logined.aspx?method=getNews",showMsg);
      </script>
    </div>
  
  </div>
</div>
</body>
<script type="text/javascript">function showmsgdtl(a){
    var url = "../../BA/sysadmin/frmSysMessageShow.aspx?msgid="+a;
    var iTop = (window.screen.availHeight-30-380)/2;       //获得窗口的垂直位置;
    var iLeft = (window.screen.availWidth-10-620)/2;           //获得窗口的水平位置;
    window.open(url,"","toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=no,width=700,height=380,top="+iTop+",left="+iLeft);
}
function show_content(type){

    if(document.getElementById(type+"id").innerHTML=="0")
        return;
    
    var url = "showalarmcontent.html?method="+type;
    var iTop = (window.screen.availHeight-30-380)/2;       //获得窗口的垂直位置;
    var iLeft = (window.screen.availWidth-10-620)/2;           //获得窗口的水平位置;
    window.open(url,"","toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=no,width=700,height=380,top="+iTop+",left="+iLeft);
}
</script>
</html>
