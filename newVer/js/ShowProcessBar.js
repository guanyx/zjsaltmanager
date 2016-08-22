AddProcessbar();
var bwidth=0;
var swidth = document.all.waiting.clientWidth;
var mywidth = 0 ;
var myheight = 0;
var msg;
function CheckIsProcessBar(obj)
{
  if ((obj.IsShowProcessBar=="True") &&(obj.disabled==false))
  {
    return false;
  }
  else
  {
    return true;
  }
}
function CheckClick(e)
{
  if (e == 1)
  {
    if (bwidth<swidth*0.98){
      bwidth += (swidth - bwidth) * 0.025;
    }
  }
  else
  {
    if(document.all)
    {
      if(document.all.waiting.style.visibility == 'visible')
      {
        document.all.waiting.style.visibility = 'visible';
      }
      whichIt = event.srcElement;
      while (CheckIsProcessBar(whichIt))
      {
        whichIt = whichIt.parentElement;
        if (whichIt == null)return true;
      }
      document.all.waiting.style.pixelTop = (document.body.offsetHeight - document.all.waiting.clientHeight) / 2 + document.body.scrollTop+myheight;
      document.all.waiting.style.pixelLeft = (document.body.offsetWidth - document.all.waiting.clientWidth) / 2 + document.body.scrollLeft+mywidth;
      document.all.waiting.style.visibility = 'visible';
      if(!bwidth)CheckClick(1);
    }
    else
    {
      if(document.waiting.visibility == 'show')
      {
        document.waiting.visibility = 'hide';
        document.rating.visibility = 'hide';
      }
      if(e.target.href.toString() != '')
      {
        document.waiting.top = (window.innerHeight - document.waiting.clip.height) / 2 + self.pageYOffset;
        document.waiting.left = (window.innerWidth - document.waiting.clip.width) / 2 + self.pageXOffset;
        document.waiting.visibility = 'show';
        document.rating.top = (window.innerHeight - document.waiting.clip.height) / 2 + self.pageYOffset+document.waiting.clip.height-10;
        document.rating.left = (window.innerWidth - document.waiting.clip.width) / 2 + self.pageXOffset;
        document.rating.visibility = 'show';
        if(!bwidth)CheckClick(1);
      }
    }
    return true;
  }
}
function AddProcessbar()
{
  var sDiv=""
  sDiv+= "<div id=waiting style=position:absolute;top:50px;left:100px;z-index:1;visibility:hidden >";
  sDiv+= "<layer name=waiting visibility=visible zIndex=2 >"
  sDiv+="<table width='279' height='110' border='0' align='center' cellpadding='0' cellspacing='0'>"
  sDiv+="  <tr>"
  sDiv+="  <td width='279' height='69' align='center' background='<%=request.getContextPath()%>/images/waiting01.gif'><table width='237' height='54' border='0' cellpadding='0' cellspacing='0'>"
  sDiv+="  <tr>"
  sDiv+="   <td width='159' align='center'><img src='<%=request.getContextPath()%>/images/0001.gif' width='30' height='30'></td>"
  sDiv+=" <td width='78'>&nbsp;</td>"
  sDiv+=" </tr></table></td></tr>"
  sDiv+="<tr>"
  sDiv+="   <td height='56' align='center' background='<%=request.getContextPath()%>/images/waiting02.gif' class='black01'>";
  if(msg == null || msg == ""){
    sDiv+="业务正在提交中，请稍候...</td>";
  }else{
    sDiv+=msg+"</td>";
  }
  sDiv+="    </tr></table>";
  sDiv+= "</layer>";
  sDiv+= "</div>";
  document.write(sDiv);
  if(document.all)document.onclick = CheckClick;
}
