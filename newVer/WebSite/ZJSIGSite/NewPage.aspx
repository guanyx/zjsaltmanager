<%@ Page Language="C#" AutoEventWireup="true" CodeFile="NewPage.aspx.cs" Inherits="NewPage" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
   <title>业务综合管理系统</title>
    <link rel="stylesheet" type="text/css" href="/css/bootstrap.min.css"/>
    <link rel="stylesheet" type="text/css" href="/css/bootstrap-responsive.min.css"/>
    <link rel="stylesheet" type="text/css" href="/css/list.css"/>
	<link rel="stylesheet" href="/css/font-awesome.min.css"/>
    <script type="text/javascript" src="/js/jquery-1.8.2.min.js"></script>
    <script type="text/javascript" src="/js/bootstrap.min.js"></script>
    <script type="text/javascript" src="/js/NewPage/util.js"></script>
    
</head>
<body>
    <div class="container">
	<div class="header-warpper">
		<div class="header">
			<img class="header-logo" src="./images/ui/listLogo.png"></img>
			<h1>业务综合管理系统</h1>
			<div class="user">
				<i></i>
				<%=LoginName %>
				<em class="caret"></em>
			</div>
			<div class="user-msg">
				新消息
				<i>0</i>
			</div>
		</div>
		<div class="tools-bar">
			<div class="time">
				<h2>9:35AM</h2>
				<div class="time-msg">
					<div class="date">2016年5月24日</div>
					<div class="week">星期二</div>
					<div class="city">杭州</div>
				</div>
			</div>
			<div class="weather">
				<img src="./images/ui/icon-weather.png" style="margin-top:-5px;">
				<i>23</i>
			</div>
			<div class="notice">
				最新公告
				<img src="./images/ui/icon-notice.png">
				<em>无信息公告</em>
			</div>
			<a class="print-tool">打印设置</a>
			
			<div class="dropdown download-tool">
			  <a class="dropdown-toggle" id="dLabel" role="button" data-toggle="dropdown" data-target="#">
			    下载中心
			    <b class="caret"></b>
			  </a>
			  <ul class="dropdown-menu" role="menu" aria-labelledby="dLabel">
			    <li>option</li>
			  </ul>
			</div>
			<div class="dropdown convert-tool">
			  <a class="dropdown-toggle" id="dLabel" role="button" data-toggle="dropdown" data-target="#">
			    单位转换
			    <b class="caret"></b>
			  </a>
			  <ul class="dropdown-menu" role="menu" aria-labelledby="dLabel">
			    <li role="presentation">
			    	<a role="menuitem" tabindex="-1" href="#">Action</a>
			    </li>
			  </ul>
			</div>
		</div>

	</div>
	<div class="nav-warpper">
		<div class="nav">
			<div class="company-title">浙江盐业集团有限公司</div>
			<ul id="menu2" class="nav-option">
				<li class="active">
                    <a href="#">我的菜单</a>
                    <ul style="display:none">
                        <% 
                            foreach (System.Collections.Generic.KeyValuePair<string, string[]> kv in myMenus)
                            {%>
                                <li><i class="fa fa-user" url="<%=kv.Value[1]%>"></i><%=kv.Value[0]%></li>
                         <%
                            }%> 
                    </ul>
				</li>
				<li>
                    <a href="#">销售管理</a>
                    <ul style="display:none">
                         <li><i class="fa fa-file" url="SCM/frmOrderMst.aspx"></i>订单管理</li>
                    </ul>
				</li>
				<li>
                    <a href="#">仓库管理</a>
                    <ul style="display:none"></ul>
				</li>
				<li>
                    <a href="#">报表查询</a>
                    <ul style="display:none"></ul>
				</li>
				<li>
                    <a href="#">生产质检</a>
                    <ul style="display:none"></ul>
				</li>
				<li>
                    <a href="#">基础数据</a>
                    <ul style="display:none"></ul>
				</li>
			</ul>
            <script type="text/javascript">
                $(function () {
                    $('#menu2 li').click(function () {
                        $('#menu3').children().remove();
                        $('#menu2 li').removeClass("active");
                        $(this).addClass("active");
                        if ($(this).find('ul').children().length>0){
                            $(this).find('ul').children().clone().appendTo($('#menu3'));
                        }
                    });
                    $('#menu3 li').live("click", function () {
                        $('#contentFrame').attr('src',$(this).find('i').attr('url'));
                    });
                    $('#menu2 li:eq(0)').click();
                });
            </script>
		</div>
	</div>
	<div class="row">
		<div class="aside">
			<ul id="menu3" class="aside-option">
				<li><i class="fa fa-wpforms"></i>欢迎使用</li>
			</ul>
		</div>
		<div class="content">
			<em>&#9670;</em>
        	<span>&#9670;</span>
        	<div class="table-warpper" style="position:relative; overflow-y:hidden">
	        	<iframe id="contentFrame" width="100%" style="border:0" height="100%" frameborder="0" framespacing="0" src="#"></iframe>
        	</div>
        	<div class="holder"></div>
        	
		</div>
	</div>
</div>
</body>
<script type="text/javascript">
  $(function(){  
	function setDate() {
          var time = new Date();
          $(".time h2").html(Util.formatTime(time.getHours(), time.getMinutes()));
          $(".time-msg .date").html(Util.formatDate(time.getFullYear(), time.getMonth()+1, time.getDate()));
          $(".time-msg .week").html(Util.formatWeek(time.getDay()));
          console.log("!")
      }
	if ($(".weather")) {
	    setDate();
	    // 定时刷新时间
	    setInterval(setDate, 60000);
	    $.ajax({
	        dataType: 'jsonp',
	        url: 'http://api.map.baidu.com/telematics/v3/weather?location=%E6%9D%AD%E5%B7%9E&output=json&ak=694b44d7b725793f18a34676c1b41293',
	        success: function (data) {
	            //处理data数据
	            var currentTemp = data.results[0].weather_data[0].temperature.slice(0, 2);
	            $(".weather i").text(currentTemp);
	        }
	    });
	}
  });
</script>
</html>
