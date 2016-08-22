<%@ Page Language="C#" AutoEventWireup="true" CodeFile="DeskTop.aspx.cs" Inherits="QT_Frames_DeskTop" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>�㽭��ҵ�������޹�˾-�ʼ������ϵͳ</title>
    <meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
    <link rel="icon" type="image/x-icon" href="../../Theme/1/images/index.ico"/>
    <link rel="stylesheet" type="text/css" href="../../ext3/resources/css/ext-all.css" />
	<script type="text/javascript" src="../../ext3/adapter/ext/ext-base.js"></script>	
	<script type="text/javascript" src="../../ext3/ext-all.js"></script>
	<script type="text/javascript" src="../../ext3/example/TabCloseMenu.js" charset="gb2312"></script>
	<style type="text/css">
    body{
	    margin: 0 0 0 0;
	    overflow:hidden;
	    }
    td{
	    font-size:12px;
	    }
    .link {
		    cursor:hand;
		    color:#6A5ACD;
		    text-decoration: none;
		    border:1 none white;
		    padding:0 0 0 0;
		    font-weight: bold;
	    }
    </style>
</head>
<body onunload="unload()">
   
</body>
<script type="text/javascript">
Ext.BLANK_IMAGE_URL = "ext3/resources/images/default/s.gif"; 
Ext.onReady(function(){
    var tabPanel =	new Ext.TabPanel({
			region:'center',
			deferredRender:false,
			autoScroll :true,
			//autoWidth :true,
			autoShow :true,
			autoDestroy :true,
			minTabWidth: 200,		//tabҳ�ı�������С�ߴ�,������Ҫ��Ч, ��������resizeTabs:true
			resizeTabs:true,		//tabҳ�ı������Ƿ�֧���Զ�����
			enableTabScroll:true,
			activeTab:0,
			plugins: new Ext.ux.TabCloseMenu()
	});
	
  var orgPanel = new Ext.Panel(
  {
		region:'west',
		id:'west-panel',
		title:' ',
		split:true,
		width: 202,
		minSize: 202,
		maxSize: 250,
		collapsible: true,
		margins:'0 0 0 5',
		  html:'<iframe width="100%" style="border:0" height="100%" frameborder="0" framespacing="0" src="MenuFrame.aspx"></iframe>',

		layoutConfig:{
		    animate:false
		}       
       
	});

	var bottomPanel = new Ext.Panel(
	{
	layoutConfig:{
		    animate:false
		},
	   collapsible: true,
		region:'south',
		html:'<table border="0" cellspacing="0" cellpadding="0" style="background-image:url(../../Theme/1/images/frame/downbg.jpg);width:100%">'+
      '<tr valign="top">'+
        '<td><img src="../../Theme/1/images/frame/pepol.jpg" alt="" width="13" height="16" border="0" align="middle" style="vertical-align: middle" /> ��ǰ����Ա��<%=LoginName %></td>'+
        '<td><img src="../../Theme/1/images/frame/bh.jpg" alt="" width="15" height="16" border="0" align="middle" style="vertical-align: middle" /> ����Ա�������ţ�<a href="#" onclick="changeDepartment();" class="link" title="�л�����"><span id="currentChangeDepart" class="link"><%=LoginDepart %></span></a></td>'+
      '<td><img src="../../Theme/1/images/frame/zz.jpg" alt="" width="15" height="16 border="0" align="middle" style="vertical-align: middle" /> ��ǰ��¼��֯��<span id="loginedOrgName"><%=LoginOrg %></span></td>'+
     //  '<td><img src="Theme/1/images/frame/zxr.jpg" alt="" width="13" height="16" border="0" align="middle" style="vertical-align: middle" />�����û���&nbsp;<a href="#" onclick="showOnLineOper();" class="zxLink" title="��ʾ�����û��б�"><span id="onlineopercount" class="link">1</span></a>��</td>'+
     //   '<td>������&nbsp;192.168.0.1</td>'+
      '</tr>'+
    '</table>'
	});
    var viewport = new Ext.Viewport({
          layout:'border',
          items:[
              new Ext.Panel({ // raw
			      id:'northPanel',
			      collapsible: true,
                  region:'north',
                  height:75,
                  html:'<iframe width="100%" id="topFrame" style="border:0" height="100%" frameborder="0" framespacing="0" src="TopFrame.aspx"></iframe>'
                 // autoLoad:{url:'frame/topFrame.html', scripts:true}
              }),bottomPanel, orgPanel,tabPanel
           ]
      });
      this.addTab=function(menuName,menuUrl){ 
        //menuUrl='customer/customerManage.aspx';
        var cookie = new Ext.state.CookieProvider();
        if(cookie.get("MenuType")){//�����0:���˵���1:���˵�
            tabPanel.removeAll();
        }
        if(!tabPanel.findById(menuName)){//û���ҵ��ò˵�������
            tabPanel.add({
                id:menuName,
                title: menuName,                
                iconCls: 'tabs',
                autoDestroy :true,
                html:'<iframe width="100%" style="border:0" height="100%" frameborder="0" framespacing="0" src="'+menuUrl+'"></iframe>',
                //autoLoad:{url:menuUrl, scripts:true,nocache:true},
                closable:true
            }).show();
         }else{//���֮ǰ�иò˵���ֱ����ʾ
            tabPanel.setActiveTab(tabPanel.findById(menuName));
         }
    }   
    //��һ��ҳ��
    tabPanel.add({
                id:'��ʼ����',
                title: '��ʼ����',                
                iconCls: 'tabs',
                autoDestroy :true,
                html:'<iframe width="100%" style="border:0" height="100%" frameborder="0" framespacing="0" src="PageStart.aspx"></iframe>',
                //autoLoad:{url:menuUrl, scripts:true,nocache:true},
                closable:false
            }).show();  
    tabPanel.setHeight(tabPanel.getHeight()-20);
   
    this.hideTopPanel=function(){
        var w = Ext.getCmp('northPanel');  
        w.collapse();  
        //orgPanel.collapsed ? orgPanel.expand() : orgPanel.collapse();  
    }
    this.unload=function()     
    {         
        Ext.Ajax.request({
            url: 'logined.aspx?method=exit'
        });
    }
});
function createDiv(menuName,menuUrl){
    addTab(menuName,menuUrl);
}
var loginUser = '<%=UserName %>';
</script>
</html>
