<%@ Page Language="C#" AutoEventWireup="true" CodeFile="MenuFrame.aspx.cs" Inherits="QT_Frames_MenuFrame" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>无标题页</title>
    <meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
    <link rel="stylesheet" type="text/css" href="../../ext3/resources/css/ext-all.css" />
	<script type="text/javascript" src="../../ext3/adapter/ext/ext-base.js"></script>	
	<script type="text/javascript" src="../../ext3/ext-all.js"></script>
	<style type="text/css">
	* {
            font-size: 12px;
            font-family: Tahoma,Verdana,微软雅黑,新宋体;
     }
    .x-panel-collapsed .x-accordion-hd .x-tool-toggle {
        background-position: 0 -60px;
    }
    .x-panel-collapsed .x-accordion-hd .x-tool-toggle-over {
        background-position: -15px -60px; /*-195  -210*/
    }
    .x-accordion-hd .x-tool-toggle {
        background-position: 0 -75px;
    }
    .x-accordion-hd .x-tool-toggle-over {
        background-position: -15px -75px;
    }
    a:hover {
        border: 1px solid #7EABCD;
        background: url('../../images/sub_menu_hover.png') repeat-x left bottom;
        _padding: 0px 5px 0px 0px;
        -moz-border-radius: 3px;
        -webkit-border-radius: 3px;
        font-weight:bold;
    }
    a:link { text-decoration: none;}
    a:visited { text-decoration: none;}
    .sub_menu_contain {
        width: 100%;
        height: 22px;
        margin-bottom: 3px;
        cursor: pointer;      
    }
    .sub_menu {
        display: inline-block;
        height: 16px;
        line-height: 16px;
        color: black;
    }
    .ui-icon-triangle-1-e {
        width: 16px;
        height: 16px;
        background: url('../../images/ArrowIcon.gif');
    }
	</style>
</head>
<body bgcolor="#F2F5FE" style="padding: 0px; margin: 0px; width: 100%; height: 100%">
   
          
</body>
<script type="text/javascript">
Ext.BLANK_IMAGE_URL = "ext3/resources/images/default/s.gif"; 
Ext.onReady(function(){
    var viewport = new Ext.Viewport({
          layout:'accordion',
          layoutConfig:{  
           animate:true  
          //titleCollapse:true,  
          //activeOnTop:false  
        },  
          items:[
            <%  int i=1;
            foreach (System.Collections.Generic.KeyValuePair<string, string> kv in menusdic)
             { %>
              {
                title:'<font style="color:#15428B;"><%=kv.Key%></font>',
                autoHeight:true, 
                html:'<%=kv.Value%>'
              }
            <%i++;
              if(i==menusdic.Count){
              %> ,
               <%}
             }%> 
           ]
     });
});
function dosomething(n,u){
    if(u == null || u == "")
		return;
	top.createDiv(n,"../../"+u);
}
</script>
</html>
