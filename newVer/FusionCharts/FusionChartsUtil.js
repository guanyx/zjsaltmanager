/*****************************************************
//将Div的边框和附加的盒子设置为0，最后正式调用那个函数。
//调用的时候直接使用
//   createChartSection("/charts/***.swf","divName","xml定义")即可
*****************************************************/
function createChartSection(chartswf,divid,xmldata,chartid,autowidth,autoheight,width,height)
 {
  
  var div = document.getElementById(divid);
  if(null==chartswf||null==divid||div==null)
  {
   return;
  }
  
  div.style.border=0;
  div.style.padding=0;
  div.style.margin=0;
  if(chartid==null)chartid=random();
  
  var regex = /set/ig;      // 创建正则表达式模式。
  var times = xmldata.match(regex).length;   // 尝试去匹配搜索字符串。
  var chart = null;
  
  if(null==width||0==width)
        width = document.body.clientWidth;
    if(null==height||0==height)
        height = document.body.clientHeight;
  //alert(width+":"+height);
  //alert(div.clientWidth+':'+div.clientHeight);
  //alert('time:'+times);
  //表头100
  if(autoheight){
    chart = new FusionCharts(chartswf,chartid, width,100 + times * 30, "0", "0");
  }
  else if (autowidth)
        chart = new FusionCharts(chartswf,chartid, 100 + times * 30 ,height, "0", "0");
  else
    chart = new FusionCharts(chartswf,chartid, width ,height, "0", "0");
  chart.addParam("wmode","transparent");
  chart.setDataXML(xmldata);
  chart.render(divid);
 }