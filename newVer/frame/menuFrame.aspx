<%@ Page Language="C#" AutoEventWireup="true" CodeFile="menuFrame.aspx.cs" Inherits="frame_menuFrame" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head >
    <title>菜单</title>
    <link rel="StyleSheet" href="../Theme/1/css/dtree.css" type="text/css" /> 
	
	<link rel="stylesheet" type="text/css" href="../ext3/resources/css/ext-all.css" />
    <script type="text/javascript" src="../ext3/adapter/ext/ext-base.js"></script>
    <script type="text/javascript" src="../ext3/ext-all.js"></script>
    <script type="text/javascript" src="../js/dtree.js"></script> 
</head>

<script type="text/javascript">
//    document.oncontextmenu=new Function("event.returnValue=false;");
//    document.onselectstart=new Function("event.returnValue=false;");

//定义右键菜单
var rightClick = null;
var selectedNodeId='';
Ext.onReady(function(){
    rightClick = new Ext.menu.Menu({
        id :'rightClickCont',
        items : [{
            id:'addItem',
            text : '添加到常用链接',
            icon:"../../Theme/1/images/extjs/customer/add16.gif",
            //增加菜单点击事件
            handler:function (){                
                addMoreUse();
            }
            
        },{
            id:'delItem',
            text : '删除链接',
            icon:"../../Theme/1/images/extjs/customer/add16.gif",
            //增加菜单点击事件
            handler:function (){                
                delEmpResource();
            }
            
        }]});
        
        function delEmpResource()
        {
//            Ext.MessageBox.wait("数据正在保存，请稍后……");
            Ext.Ajax.request({
                url: 'menuFrame.aspx?method=deluseresource',
                method: 'POST',
                params: {
                    ResourceId:selectedNodeId
                },
                success: function(resp, opts) {
//                    if (checkExtMessage(resp)) {
//                        Ext.Msg.alert("提示", "保存成功");
//                    }
                },
                failure: function(resp, opts) {
//                    Ext.Msg.alert("提示", "保存失败");
                }
        });
        }
        function addMoreUse()
        {
//            Ext.MessageBox.wait("数据正在保存，请稍后……");
            Ext.Ajax.request({
                url: 'menuFrame.aspx?method=savetouse',
                method: 'POST',
                params: {
                    ResourceId:selectedNodeId
                },
                success: function(resp, opts) {
//                    if (checkExtMessage(resp)) {
//                        Ext.Msg.alert("提示", "保存成功");
//                    }
                },
                failure: function(resp, opts) {
//                    Ext.Msg.alert("提示", "保存失败");
                }
        });
        }
});

</script>
<%=soPoolPassWord() %>
<body bgcolor="#F2F5FE" style="padding: 0px; margin: 0px; width: 100%; height: 100%">
    <div class="dtree" id="treemenu"> 
 
	<p></p> 
    <script type="text/javascript"> 
		<!--
        
		d = new dTree('d');
	    d.config.folderLinks=false;
	    //d.config.target="contentFrme"; //默认点击后刷新contentFrame
	    /*
	    a.config.folderLinks=false;
        a.config.useIcons=false;
        a.config.useLines=false;
        a.config.useSelection=false;
        a.config.useCookies=false;
        */
        
        /*
         *构造方法：
         *add(id, pid, name, url, title, target, icon, iconOpen, open)
         *add(节点编号,父节点,节点名称,导航地址,导航页名称,显示目标,当前图片,点击打卡后图片,是否打开)
         */
 
		d.add(0,-1,'<%=OrgName %>');
		<% 
		foreach(string[] nodes in menus){
		if(nodes[3].ToString()==""){
		%>
		d.add(<%=nodes[0]%>,<%=nodes[1] %>,'<%=nodes[2].ToString() %>','');
		<%} else {%>
		d.add(<%=nodes[0]%>,<%=nodes[1] %>,'<%=nodes[2].ToString() %>','javascript:dosomething(\'<%=nodes[2].ToString() %>\',\'<%=nodes[3].ToString() %>\');');
        <%}} %>
 
		document.write(d);
	    
 
		//-->
		/*
		 * 将菜单名称传到tab名称上,绕开默认的target方式
		 */
		function dosomething(name,url){
		    if(url==null || url == "")
		        return;
		    top.createDiv(name,getDomainUrl(url));
		}
		
		function getDomainUrl(url)
		{
		    if(sId!='')
		    {
		        if(url.indexOf('?')!=-1)
		        {
		            url+="&sessionId="+sId;
		        }
		        else{
		            url+="?sessionId="+sId;
		        }
		    }
		    return url;
		}
	</script> 
    </div>
    <div style="width: 100%; background-color:Gray; display:none; height: 100%; position:absolute; left: 0; top: 0;" id="xie"><font color='red'>
    请及时更新密码，原始密码不能操作任何业务，谢谢；更新密码后请重新登陆</font>
    </div>

    <script>
    if(soPoolPass)
    {
    document.getElementById("xie").style.display ="";
    document.getElementById("treemenu").style.display ="none";
    }
    else
    {
        document.getElementById("xie").style.display ="none";
    }
    document.oncontextmenu=new Function("event.returnValue=false;");
    document.onselectstart=new Function("event.returnValue=false;");
    </script>
    
    <p></p> 
</body>
</html>
