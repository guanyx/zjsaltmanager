//信息提示统一处理入口
/**
 * 信息分四种：普通提示，警告，询问，错误。
 */
 //计算弹出信息框长度的方法
 function countWW(msg)
 {
    var ww = 350;//自定义宽度，此宽度最大不超过800

    var max_len = 22;//最大行长度默认值
    var temp_len = 0;//临时子字符串的长度
    var strAll = msg;
    var re = /\n/ig;      // 创建正则表达式模式
    var n_array = strAll.match(re);// 尝试去匹配搜索字符串。
    if(n_array!=null)
    {
      var n_num = n_array.length;// 返回的数组包含了所有 "\n"的个数

      for(var i=0;i<n_num;i++)
      {
        var j = strAll.indexOf("\n");//取得第i个"\n"的位置
        var strTemp = strAll.substring(0,j);

        temp_len = strTemp.length;
        if(temp_len>max_len)
        {
          max_len = temp_len;
        }
        strAll = strAll.substring(j+1,strAll.length);
      }
    }else{
      max_len = strAll.length;
    }
    if(max_len>22)
    {
       ww = ww + (max_len-22)*12;
    }
    if(ww>800)
    {
      ww = 800;//如果ww长度超过800，设置其等于800
    }

    return ww;
 }
 //计算弹出信息框高度的方法
 function countHH(msg,nn)
 {
  if(nn==null) nn=0;
  var hh = 120;//自定义高度，此高度最大不超过600
  var re = /\n/ig;      // 创建正则表达式模式
  var n_array = msg.match(re);// 尝试去匹配搜索字符串。
  if(n_array!=null)
  {
	  var n_num = n_array.length + 1;
	  for(var i=0;i<n_num;i++)
      {
        var j = msg.indexOf("\n");//取得第i个"\n"的位置
		var strTemp;
		if(j < 0)
			strTemp = msg;
		else
			strTemp = msg.substring(0,j);
		var linenum = Math.floor(strTemp.length/60) - 1;
		if(linenum > 0)
			nn = nn + linenum ;

        msg = msg.substring(j+1,msg.length);
	  }

	var strlen = n_array.length+nn;// 返回的数组包含了所有 "\n"的个数

	if(strlen >= 3)
	  hh = hh+18*strlen;

  }

  	if(hh>600)
	{
	  hh = 600;//如果hh高度超过600，设置其等于600
	}

  return hh;
 }

 //提示信息方法
window.alert =function(msg)
{
  msg = ""+msg; //将数字型的信息统一转换成字符串
  var ww = countWW(msg);
   var nn = 0;//表示高度要加nn*基数

  if(ww==800){

    //var nntemp = msg.length/60;
    /*
    for(var i=0;i<nntemp;i++){
      nn = i;
    }
    */
    //nn = nntemp;
    msg = msg + "\n";
  }

  var hh = countHH(msg,nn) + 20;

   window.showModalDialog("js/alert.html",msg,
   "dialogWidth:"+ww+"px;dialogHeight:"+hh+"px;dialogtop=event.screenY;dialogleft=event.screenX;scroll:0;status:0;help:no;resizable:0");
}
//确认信息方法
window.confirm = function(msg)
{
    msg = ""+msg; //将数字型的信息统一转换成字符串
    var ww = countWW(msg);
    var hh = countHH(msg);
    var bflag = window.showModalDialog("js/confirm.html",msg,
	"dialogWidth:"+ww+"px;dialogHeight:"+hh+"px;dialogtop=event.screenY;dialogleft=event.screenX;scroll:no;status:no;help:no;resizable:0");

    if(bflag==true)
    {
      return true;
    }else{
      return false;
    }
}
//是，否，取消选择窗口
function confirmext(msg)
{
    msg = ""+msg; //将数字型的信息统一转换成字符串
    var ww = countWW(msg);
    var hh = countHH(msg);
    var bflag = window.showModalDialog("js/confirmext.html",msg,
	"dialogWidth:"+ww+"px;dialogHeight:"+hh+"px;dialogtop=event.screenY;dialogleft=event.screenX;scroll:no;status:no;help:no;resizable:0");

    return bflag;
}
//警告信息方法
function alarm(msg)
{
  msg = ""+msg; //将数字型的信息统一转换成字符串
  var ww = countWW(msg);
  if(ww==800){
    var nn = 0;//表示高度要加nn*基数
    var nntemp = msg.length/60;
    for(var i=0;i<nntemp;i++){
      nn = i;
    }
    msg = msg + "\n";
  }
  var hh = countHH(msg,nn);
   window.showModalDialog("js/alarm.html",msg,
   "dialogWidth:"+ww+"px;dialogHeight:"+hh+"px;dialogtop=event.screenY;dialogleft=event.screenX;scroll:no;status:no;help:no;resizable:0");
}
//错误信息方法
function error(msg)
{
  msg = ""+msg; //将数字型的信息统一转换成字符串
  var ww = countWW(msg);
  if(ww==800){
    var nn = 0;//表示高度要加nn*基数
    var nntemp = msg.length/60;
    for(var i=0;i<nntemp;i++){
      nn = i;
    }
    msg = msg + "\n";
  }
  var hh = countHH(msg,nn);
   window.showModalDialog("js/error.html",msg,
   "dialogWidth:"+ww+"px;dialogHeight:"+hh+"px;dialogtop=event.screenY;dialogleft=event.screenX;scroll:0;status:0;help:no;resizable:0");
}
//---------------->
/**
 * 让光标跳到下一个控件。
 * 只支持回车键
 */
function doEnterKeyDown(nextObject)
{
    if(window.event.keyCode == 13)
    {
        if(null == nextObject)
        {
            return;
        }
        nextObject.focus();
    }
}
/**
 * 让光标跳到下一个控件。
 * 支持TAB键和回车键
 */
function doKeyDown(nextObject)
{
    if(window.event.keyCode == 13 || window.event.keyCode == 9)
    {
        if(null == nextObject)
        {
            return;
        }
        nextObject.focus();
    }
}
/**
 * 将窗口中的鼠标变成等待状态。
 */
function toWaitCursor(idName)
{
    document.getElementById(idName).style.cursor = "wait";
}
/**
 * 将窗口中的鼠标变成默认状态。
 */
function toDefaultCursor(idName)
{
    document.getElementById(idName).style.cursor = "default";
}
//检查值是否为空
function isNotNull(value)
{
    if(value != null && value != "")
    {
        return true;
    }
    return false;
}
//检测手机号是否合法。客服视图 isAlert=false;表示不弹出信息框 
function isValidMobileNo(mobileNo,isAlert)
{
	if(isAlert == null)
		isAlert = true;
    var networkSegment;
    if (mobileNo == "")
    {
		if(isAlert)
			alert("手机号不能为空!");
        return false;
    }
    if (!isNumber(mobileNo))
    {
		if(isAlert)
			alert("手机号必须为数字！");
        return false;
    }

	//去掉对号码前3位判断
    if (mobileNo.length != 11)
    {
		if(isAlert)
			alert("手机号必须为11位！");
        return false;
    }
    return true;
}

//检测手机号是否合法:包含所有号码段
function isValidAllMobileNo(mobileNo)
{
    var networkSegment;
    if (mobileNo == "")
    {
        alert("手机号不能为空!");
        return false;
    }
    if (!isNumber(mobileNo))
    {
        alert("手机号必须为数字！");
        return false;
    }

	//去掉对号码前3位判断
    if (mobileNo.length != 11)
    {
        alert("手机号必须为11位！");
        return false;
    }
    return true;
}
/**
 * 查测字符串是否为数字字符串(只适用于整数)。
 */
function isNumber(str)
{
    if (str == "")
    {
      return false;
    }
    for(var i = 0; i < str.length; ++i)
    {
     if((str.charAt(i)<'0') || (str.charAt(i)>'9'))
     {
                return false;
     }
    }
    return true;
}
//----------------------------------------->
/**
 * 去掉字符串前后空格
 */
function TrimDoubleBlankString(value)
{
    if(value == null || value == "")
    {
      return "";
    }
    var iStart = -1;
    var iEnd  = -1;
    for(i = 0; i < value.length; i++)
    {
        if(value.charAt(i) == " ")
        {
         continue;
        }
        iStart = i;
        break;
    }
    for(i = value.length-1; i >= 0; i--)
    {
        if(value.charAt(i) == " ")
        {
          continue;
        }
        iEnd = i;
        break;
    }
    if(iEnd == -1 || iStart == -1)
        return "";
    return value.substring(iStart, iEnd+1);
}
//------------------------------------------>
function popupWin(szUrl,w,h,winname){
        var top=screen.availHeight/2-h/2;
        var left=screen.availWidth/2-w/2;
        if(winname == ""){
          winname = "newwin";
        }
        return window.open(szUrl, winname, "height="+h+", width="+w+", top="+top+", left="+left
        +", toolbar=no, menubar=no, scrollbars=yes, location=no, status=no, resizable=yes" ) ;
}
function showModalWindow(szUrl,w,h,value){
        var top=screen.availHeight/2-h/2;
        var left=screen.availWidth/2-w/2;
        return window.showModalDialog(szUrl,value,"help:no;scroll:auto;resizable:yes;status:no;dialogLeft:"+left+"px;dialogTop:"+top+"px;;dialogHeight:"+h+"px;;dialogWidth:"+w+"px;");
}
//------------------------------------------>
//格式化金额
function formatMoney(money)
{
      var str = TrimDoubleBlankString(money);
      var tem = parseInt(money)/100;
      str = ""+tem;
      if(str.indexOf(".") > 0){
      }else{
        str = str + ".00";
      }
      return str;
}

/**
 * 判断金额是否超过指定的大小
 * 金额整数位最大长度为len
 */
function isValidMoneyLen(money,len){
  var iPoint = money.indexOf(".");
  if(iPoint>0){
     money = money.substring(0,iPoint);
     if(money.length>len){
        return false;
     }
  }else{
     if(money.length>len){
        return false;
     }
  }
  return true;
}
/**
 * 判断金额是否超过指定的大小
 * pDecimal 精度
 * 金额整数位最大长度为len
 */
function isValidMoney(money,pDecimal,len){
   money = money+"";
   var dec = -1;
   if(parseInt(pDecimal)!=NaN){
     dec = pDecimal;
   }
   var reg = "^[0-9]+(\.[0-9]{1,"+dec+"})?$";
   if(dec==0 || dec==-1)
   {
      reg = "^[0-9]+(\.[0-9]{1,10000})?$";
   }
   var re = new RegExp(reg,"g");
   if(!money.match(re)){
      return false;
   }
  var iPoint = money.indexOf(".");
  if(iPoint>0){
     money = money.substring(0,iPoint);
     if(money.length>len){
        return false;
     }
  }else{
     if(money.length>len){
        return false;
     }
  }
  return true;
}

function windowclose(){
   window.close();
}


function setGridTitle(grid,title)
{
	document.all(grid.DBGridPK + "_titleId").innerText = title;
}

//从表格中把数据倒入excel，传入参数为表格id对象
function Table2Excel(idTable)
{
   var xlApp = null;
   if(idTable == null)
   {
      alert("请正确指定表格的id.");
      return;
   }
	var oTable = idTable;
	try {
		xlApp =new ActiveXObject("excel.APPLICATION");
		var xlBook = xlApp.Workbooks.Add;
		var xlSheet1 = xlBook.Worksheets(1);
		var oTrs = oTable.all.tags("TR");
		iRow = 1;
		iCol = 1;
		for(i = 0; i < oTrs.length; i++)
		{
			var oTr = oTrs(i);
			if(oTr.tagName == "TR")
			{
				iCol = 1;
				var oTds = oTr.childNodes;
				for(j = 0; j < oTds.length; j++)
				{
					var oTd = oTds(j);
					if(oTd.tagName == "TD" || oTd.tagName == "TH")
					{
                      	                        xlSheet1.cells(iRow, iCol).NumberFormatLocal = "@";
						xlSheet1.cells(iRow, iCol).value= oTd.innerText;
						iCol += 1;
					}
				}
				iRow += 1;
			}
		}
		//划线。。。
		xlSheet1.Range(xlSheet1.cells(2,2),xlSheet1.cells(iRow - 1, iCol - 1)).Borders.LineStyle = 1;
		xlApp.Visible = true;
	}
	catch(e) {
		alert("系统错误:"+e.message);
		if(xlApp)
		{
			xlApp.quit();
			xlApp = null;
		}
	}
}

//从表格中把数据倒入excel，暂时为报表所专用
//支持表格的单元格是下拉框的状态
//后续还可以扩展参数，比如是否打印标题和前注等
  function TableAll2Excel(idTable)
  {
    alert("您正在导出结果为Excel文件，点击确定继续……");
     var xlApp = null;
     if(idTable == null)
     {
        alert("请正确指定表格的id.");
        return;
     }
     var oTable = idTable;
     try
     {
        xlApp =new ActiveXObject("excel.APPLICATION");
        var xlBook = xlApp.Workbooks.Add;
        var xlSheet1 = xlBook.Worksheets(1);
        var oTrs = oTable.all.tags("TR");
        var count = oTrs(2).childNodes.length;//报表的字段数
        iRow = 1;
        iCol = 1;

        //先写标题(居中)
        var oTr = oTrs(0);
        var oTds,oTd;
        if(oTr.tagName == "TR")
        {
            oTds = oTr.childNodes;
            oTd = oTds(0);
            xlSheet1.Range(xlSheet1.cells(iRow,iCol),xlSheet1.cells(iRow,count)).Merge();//居中
            xlSheet1.cells(iRow,iCol).NumberFormatLocal = "@";
            xlSheet1.cells(iRow,iCol).value= oTd.innerText;
            xlSheet1.cells(iRow,iCol).HorizontalAlignment = -4108;
            xlSheet1.cells(iRow,iCol).VerticalAlignment = -4108;
            iRow++;
        }

        //对列名进行着色
        xlSheet1.Range(xlSheet1.cells(3,1),xlSheet1.cells(3,count)).Interior.ColorIndex = 37;

        //正式写表格数据
        for(i = iRow-1; i < oTrs.length; i++)
        {
            oTr = oTrs(i);
            if(oTr.tagName == "TR")
            {
                iCol = 1;
                oTds = oTr.childNodes;
                for(j = 0; j < oTds.length; j++)
                {
                    oTd = oTds(j);
                      if(oTd.tagName == "TD" || oTd.tagName == "TH")
                      {
                          xlSheet1.cells(iRow, iCol).NumberFormatLocal = "@";
                          if(oTd.children[0]!=null&&oTd.children[0].tagName == "SELECT")
                          {
                             //读取下拉框的值,并写入excel
                             var selectObj = oTd.children[0];
                             for (var index=0; index<selectObj.options.length; index++)
                             {
                                 if(selectObj.options(index).selected)
                                 {
                                    xlSheet1.cells(iRow, iCol).value= selectObj.options(index).text;
                                    break;
                                 }
                             }
                         }
                          else
                          {
                              xlSheet1.cells(iRow, iCol).value= oTd.innerText;
                          }
                          iCol ++;
                      }
                }
              iRow ++;
            }
        }
        //划线。。。
        xlSheet1.Range(xlSheet1.cells(3,1),xlSheet1.cells(iRow - 2, count)).Borders.LineStyle = 1;
        xlApp.Visible = true;
      }
      catch(e) {
          alert("系统错误:"+e.message);
          if(xlApp)
          {
              xlApp.quit();
              xlApp = null;
          }
      }
  }


/**
 *sheetObj:xsl对象
 *startRow:起始行
 *startCol:起始列
 *tableObj:表格对象
 *parts:
 *offsetCol:
 *tbHeadMaxRow:表头最大行数
 *tbHeadMaxCol:表头最大列数
 *支持函rowspan,colspan的表格导出excel
*/
function tableToExcel(sheetObj,startRow,startCol,tableObj,parts,offsetCol,tbHeadMaxRow,tbHeadMaxCol){
    var iRowSpanCount = 0;
    var rRowSpanColArray = new Array();
    var rRowSpanArray = new Array();
    var oTrs = tableObj.all.tags("TR");
    var iRow = startRow;
    var iCol = startCol;
    var thalf = 0;
    var maxCol = 0;
    if(parts > 1){
        thalf = Math.ceil(oTrs.length/parts);
    }

    for(var j = 0;j < tbHeadMaxRow;j++){//约定第三行开始显示表头
        var k = j + 3;
        sheetObj.Range(sheetObj.cells(k,1),sheetObj.cells(k,tbHeadMaxCol)).Interior.ColorIndex = 37;//对列名进行着色
        sheetObj.Range(sheetObj.cells(k,1),sheetObj.cells(k,tbHeadMaxCol)).Borders.LineStyle = 1;//对列名进行划线
    }

    var first = true;
    var curstart = startCol;
    for(i = 0; i < oTrs.length; i++){
        var oTr = oTrs(i);
        if(oTr.tagName == "TR"){
            if(parts > 1){
                if((iRow-startRow) >= thalf && iRowSpanCount == 0){
                    curstart += offsetCol;
                    iRow = startRow;
                }
            }
            iCol = curstart;
            var oTds = oTr.childNodes;
            var tRowSpanCount = iRowSpanCount;
            var tRowSpanId  = 1;
            var tRowFlag = false;
            //alert("rowspancount:"+tRowSpanCount);
            for(j = 0; j < oTds.length; j++){
                var oTd = oTds(j);
                if(oTd.tagName == "TD" || oTd.tagName == "TH"){
                	  //如果有跨行的单元格
                    if(tRowSpanCount>0){
                    	for(zz=0; zz<rRowSpanColArray.length; zz++){
                        if(iCol == rRowSpanColArray[zz]){
                            iCol++;
                            rRowSpanArray[zz]--;
                            if(rRowSpanArray[zz] == 1){
                                iRowSpanCount--;
                                rRowSpanColArray[zz] = -1;
                            }
                            tRowSpanCount--;
                        }
                      }
                    }
                    sheetObj.cells(iRow, iCol).NumberFormatLocal = "@";
                    var inputs = oTd.getElementsByTagName("INPUT");
                    var tvalue = "";
                        for(t=0; t<inputs.length; t++){
                          var tinput = inputs[t];
                          if(tinput.type=="text"){
                              tvalue = tinput.value;
                          }
                        }
                    if(tvalue == ""){
                        var textareas = oTd.getElementsByTagName("TEXTAREA");
                        if(textareas.length > 0){
                            tvalue = textareas[0].value;
                        }
                    }
                    if(tvalue == ""){
                       tvalue = oTd.innerText;
                    }
                    if(tvalue!=""){
                        tRowFlag = true;
                    }
                    //alert(tvalue+":"+iRow+"|"+iCol);
                    sheetObj.cells(iRow, iCol).value= tvalue;
                    if(oTd.rowSpan >1){
                        var trange = sheetObj.Range(sheetObj.cells(iRow, iCol),sheetObj.cells(iRow+oTd.rowSpan-1, iCol));
                        trange.Merge();
                        iRowSpanCount++;
                        rRowSpanColArray[iRowSpanCount] = iCol;
                        rRowSpanArray[iRowSpanCount] = oTd.rowSpan;
                    }
                    if(oTd.colSpan>1){
                        var trange = sheetObj.Range(sheetObj.cells(iRow, iCol),sheetObj.cells(iRow, iCol+oTd.colSpan-1));
                        trange.Merge();
                        trange.HorizontalAlignment = 3;
                    }
                    iCol += oTd.colSpan
                }
                //保存最大的列数
                if(iCol > maxCol){
                  maxCol =  iCol;
                }
                //若果最后还没到最大列数，处理
                if(oTds.length == j+1){
                	if(tRowSpanCount>0){
                	  for(xx=iCol; iCol<maxCol; iCol++){
                		  for(zz=0; zz<rRowSpanColArray.length; zz++){
                        if(iCol == rRowSpanColArray[zz]){
                            rRowSpanArray[zz]--;
                            if(rRowSpanArray[zz] == 1){
                                iRowSpanCount--;
                                rRowSpanColArray[zz] = -1;
                            }
                            tRowSpanCount--;
                        }
                      }
                	  }
                	}
                }

            }
            if(tRowFlag == true){
                iRow += 1;
            }
        }
        startCol = curstart;
        startRow = iRow+1;
    }
}


/**
 * str中是否包含有中文
 * @param: str 需要判断的字符串
 */
function isChinese(str){
	if(typeof(str) == "undefined" || str == null){
		return false;
	}
	return /[\u4E00-\u9FA5]/gi.test(str);
}

function getParamerValue( name )
{
  name = name.replace(/[\[]/,"\\\[").replace(/[\]]/,"\\\]");
  var regexS = "[\\?&]"+name+"=([^&#]*)";
  var regex = new RegExp( regexS );
  var results = regex.exec( window.location.href );
  if( results == null )
    return "";
  else
    return results[1];
}