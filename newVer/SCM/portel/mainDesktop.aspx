<%@ Page Language="C#" AutoEventWireup="true" CodeFile="mainDesktop.aspx.cs" Inherits="SCM_portel_mainDesktop" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>����̨</title>
    <meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
    <link rel="stylesheet" type="text/css" href="../../ext3/resources/css/ext-all.css" />  
    <script type="text/javascript" src="../../ext3/adapter/ext/ext-base.js"></script>  
    <script type="text/javascript" src="../../ext3/ext-all.js"></script>  
    <style type="text/css">
    .bg {
        width: 100%;
    }
    .bg li{
        float: left;
        position: relative;       
    }
    </style>   
</head>
<body style="margin:5px 5px 5px 5px">
<div id="desktop" class="bg">
<li style="width: 90px;height:120px;" >
    <div id="Div1"></div>
    <div id="Div2"></div>
    <div id="Div3"></div>
    <div id="Div4"></div>
</li>
<li style="height:120px" id='lit'>
    <div id="Info"></div>
</li>
</div>
</body>
<script type="text/javascript">  
document.getElementById('lit').style.width=200;
function opennewwindow(url,winname,w,h){
    var top=screen.availHeight/2-h;
    var left=screen.availWidth/2-w;
    window.open(url, winname, "top="+top+", left="+left
    +",toolbar=no, menubar=no, scrollbars=yes, location=no, status=no, resizable=no,width="+w+",height="+h);
}
Ext.onReady(function(){   
    var Toolbar = new Ext.Toolbar({
	renderTo:"Div1",
	items:[{
		text:"��������",
		icon:"../../Theme/1/images/extjs/customer/add16.gif",
		handler:function(){
		    opennewwindow('createOrder.aspx?OpenType=oper&customerid=<%=CustomerId %>&id=0','��Ʒ��������',620,400);
		}
	}]
});
var Toolbar = new Ext.Toolbar({
	renderTo:"Div2",
	items:[{
		text:"��ʷ����",
		icon:"../../Theme/1/images/extjs/customer/view16.gif",
		handler:function(){
		    opennewwindow('hisOrderSearch.aspx?customerid=<%=CustomerId %>&OrgId=<%=OrgId %>','��ʷ����',700,400);
		}
	}]
});
var Toolbar = new Ext.Toolbar({
	renderTo:"Div3",
	items:[{
		text:"�޸�����",
		icon:"../../Theme/1/images/frame/lock.jpg",
		handler:function(){
		    opennewwindow('/chgPswd.aspx','�޸�����',349,184);
		}
	}]
});
var Toolbar = new Ext.Toolbar({
	renderTo:"Div4",
	items:[{
		text:"�����ĵ�",
		icon:"../../Theme/1/images/frame/help.jpg",
		handler:function(){
		    //deleteInfo();
		}
	}]
});
var strinfo = '�ͻ���ţ�<%=CustomerNo %><br>�ͻ����ƣ�<%=CustomerName %><br>��ϵ�ˣ�<%=LinkMan %><br>�ͻ���ַ��<%=CustomerAddr %><br>';
var panel = new Ext.Panel({
    title:'�û���Ϣ',
    renderTo:'Info',
    frame:true,
    height:112,
    bodyStyle: 'padding:10px',
    html:strinfo
});

})

</script>
</html>