<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmChart.aspx.cs" Inherits="RPT_SCM_frmChart" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>通用图表页面</title>
    <meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
    <meta http-equiv="X-UA-Compatible" content="IE=EmulateIE7" />
    <script type="text/javascript" src="../../js/Ajax.js"></script>
    <script type="text/javascript" src="../../FusionCharts/FusionCharts.js"></script>
    <script type="text/javascript" src="../../FusionCharts/FusionChartsUtil.js"></script>
    <style type="text/css">
    /*通用样式*/
    html,body,div,p,ul,ol,li,dl,dt,dd,h1,h2,h3,h4,h5,h6,object,iframe,form,blockquote,fieldset,input,textarea,code,address,caption,cite,code,em,i,ins{font-style:normal;font-size:12px;font-weight:normal;}
    </style>
</head>
<body>
<script type="text/javascript">
var strFullPath=window.document.location.href; 
var strPath=window.document.location.pathname; 
var pos=strFullPath.indexOf(strPath); 
var prePath=strFullPath.substring(0,pos); 
var postPath=strPath.substring(0,strPath.substr(1).indexOf('/')+1);
function getRadioGroupValue(name){
    var arry = document.getElementsByName(name);
    for(i=0;i <arry.length;i++)
    { 
	    if(arry[i].checked) 
		    return arry[i].value;
    } 
}
function getCheckGroupValue(name)
{
	var retVal="";
	var arry = document.getElementsByName(name)
	for(i=0;i <arry.length;i++)
	{ 
		if(arry[i].checked) 
			retVal +=","+arry[i].value;
	} 
	if(retVal!="")
		retVal = retVal.substr(1);
	return retVal;
}

</script>
    <div id='condDiv'><!--后台UI层添加内容-->
    
    </div>
    <div id='buttonsDiv'><!--后台UI层添加内容-->
    
    </div>
    <div id="init" style="display:none" runat="server"></div><!--后台asp.cs存放js并执行-->
    <div id='chartDiv'><!--图表区-->
    
    </div>
    </body>
</html>
