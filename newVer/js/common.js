//��Ϣ��ʾͳһ�������
/**
 * ��Ϣ�����֣���ͨ��ʾ�����棬ѯ�ʣ�����
 */
 //���㵯����Ϣ�򳤶ȵķ���
 function countWW(msg)
 {
    var ww = 350;//�Զ����ȣ��˿����󲻳���800

    var max_len = 22;//����г���Ĭ��ֵ
    var temp_len = 0;//��ʱ���ַ����ĳ���
    var strAll = msg;
    var re = /\n/ig;      // ����������ʽģʽ
    var n_array = strAll.match(re);// ����ȥƥ�������ַ�����
    if(n_array!=null)
    {
      var n_num = n_array.length;// ���ص�������������� "\n"�ĸ���

      for(var i=0;i<n_num;i++)
      {
        var j = strAll.indexOf("\n");//ȡ�õ�i��"\n"��λ��
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
      ww = 800;//���ww���ȳ���800�����������800
    }

    return ww;
 }
 //���㵯����Ϣ��߶ȵķ���
 function countHH(msg,nn)
 {
  if(nn==null) nn=0;
  var hh = 120;//�Զ���߶ȣ��˸߶���󲻳���600
  var re = /\n/ig;      // ����������ʽģʽ
  var n_array = msg.match(re);// ����ȥƥ�������ַ�����
  if(n_array!=null)
  {
	  var n_num = n_array.length + 1;
	  for(var i=0;i<n_num;i++)
      {
        var j = msg.indexOf("\n");//ȡ�õ�i��"\n"��λ��
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

	var strlen = n_array.length+nn;// ���ص�������������� "\n"�ĸ���

	if(strlen >= 3)
	  hh = hh+18*strlen;

  }

  	if(hh>600)
	{
	  hh = 600;//���hh�߶ȳ���600�����������600
	}

  return hh;
 }

 //��ʾ��Ϣ����
window.alert =function(msg)
{
  msg = ""+msg; //�������͵���Ϣͳһת�����ַ���
  var ww = countWW(msg);
   var nn = 0;//��ʾ�߶�Ҫ��nn*����

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
//ȷ����Ϣ����
window.confirm = function(msg)
{
    msg = ""+msg; //�������͵���Ϣͳһת�����ַ���
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
//�ǣ���ȡ��ѡ�񴰿�
function confirmext(msg)
{
    msg = ""+msg; //�������͵���Ϣͳһת�����ַ���
    var ww = countWW(msg);
    var hh = countHH(msg);
    var bflag = window.showModalDialog("js/confirmext.html",msg,
	"dialogWidth:"+ww+"px;dialogHeight:"+hh+"px;dialogtop=event.screenY;dialogleft=event.screenX;scroll:no;status:no;help:no;resizable:0");

    return bflag;
}
//������Ϣ����
function alarm(msg)
{
  msg = ""+msg; //�������͵���Ϣͳһת�����ַ���
  var ww = countWW(msg);
  if(ww==800){
    var nn = 0;//��ʾ�߶�Ҫ��nn*����
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
//������Ϣ����
function error(msg)
{
  msg = ""+msg; //�������͵���Ϣͳһת�����ַ���
  var ww = countWW(msg);
  if(ww==800){
    var nn = 0;//��ʾ�߶�Ҫ��nn*����
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
 * �ù��������һ���ؼ���
 * ֻ֧�ֻس���
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
 * �ù��������һ���ؼ���
 * ֧��TAB���ͻس���
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
 * �������е�����ɵȴ�״̬��
 */
function toWaitCursor(idName)
{
    document.getElementById(idName).style.cursor = "wait";
}
/**
 * �������е������Ĭ��״̬��
 */
function toDefaultCursor(idName)
{
    document.getElementById(idName).style.cursor = "default";
}
//���ֵ�Ƿ�Ϊ��
function isNotNull(value)
{
    if(value != null && value != "")
    {
        return true;
    }
    return false;
}
//����ֻ����Ƿ�Ϸ����ͷ���ͼ isAlert=false;��ʾ��������Ϣ�� 
function isValidMobileNo(mobileNo,isAlert)
{
	if(isAlert == null)
		isAlert = true;
    var networkSegment;
    if (mobileNo == "")
    {
		if(isAlert)
			alert("�ֻ��Ų���Ϊ��!");
        return false;
    }
    if (!isNumber(mobileNo))
    {
		if(isAlert)
			alert("�ֻ��ű���Ϊ���֣�");
        return false;
    }

	//ȥ���Ժ���ǰ3λ�ж�
    if (mobileNo.length != 11)
    {
		if(isAlert)
			alert("�ֻ��ű���Ϊ11λ��");
        return false;
    }
    return true;
}

//����ֻ����Ƿ�Ϸ�:�������к����
function isValidAllMobileNo(mobileNo)
{
    var networkSegment;
    if (mobileNo == "")
    {
        alert("�ֻ��Ų���Ϊ��!");
        return false;
    }
    if (!isNumber(mobileNo))
    {
        alert("�ֻ��ű���Ϊ���֣�");
        return false;
    }

	//ȥ���Ժ���ǰ3λ�ж�
    if (mobileNo.length != 11)
    {
        alert("�ֻ��ű���Ϊ11λ��");
        return false;
    }
    return true;
}
/**
 * ����ַ����Ƿ�Ϊ�����ַ���(ֻ����������)��
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
 * ȥ���ַ���ǰ��ո�
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
//��ʽ�����
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
 * �жϽ���Ƿ񳬹�ָ���Ĵ�С
 * �������λ��󳤶�Ϊlen
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
 * �жϽ���Ƿ񳬹�ָ���Ĵ�С
 * pDecimal ����
 * �������λ��󳤶�Ϊlen
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

//�ӱ���а����ݵ���excel���������Ϊ���id����
function Table2Excel(idTable)
{
   var xlApp = null;
   if(idTable == null)
   {
      alert("����ȷָ������id.");
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
		//���ߡ�����
		xlSheet1.Range(xlSheet1.cells(2,2),xlSheet1.cells(iRow - 1, iCol - 1)).Borders.LineStyle = 1;
		xlApp.Visible = true;
	}
	catch(e) {
		alert("ϵͳ����:"+e.message);
		if(xlApp)
		{
			xlApp.quit();
			xlApp = null;
		}
	}
}

//�ӱ���а����ݵ���excel����ʱΪ������ר��
//֧�ֱ��ĵ�Ԫ�����������״̬
//������������չ�����������Ƿ��ӡ�����ǰע��
  function TableAll2Excel(idTable)
  {
    alert("�����ڵ������ΪExcel�ļ������ȷ����������");
     var xlApp = null;
     if(idTable == null)
     {
        alert("����ȷָ������id.");
        return;
     }
     var oTable = idTable;
     try
     {
        xlApp =new ActiveXObject("excel.APPLICATION");
        var xlBook = xlApp.Workbooks.Add;
        var xlSheet1 = xlBook.Worksheets(1);
        var oTrs = oTable.all.tags("TR");
        var count = oTrs(2).childNodes.length;//������ֶ���
        iRow = 1;
        iCol = 1;

        //��д����(����)
        var oTr = oTrs(0);
        var oTds,oTd;
        if(oTr.tagName == "TR")
        {
            oTds = oTr.childNodes;
            oTd = oTds(0);
            xlSheet1.Range(xlSheet1.cells(iRow,iCol),xlSheet1.cells(iRow,count)).Merge();//����
            xlSheet1.cells(iRow,iCol).NumberFormatLocal = "@";
            xlSheet1.cells(iRow,iCol).value= oTd.innerText;
            xlSheet1.cells(iRow,iCol).HorizontalAlignment = -4108;
            xlSheet1.cells(iRow,iCol).VerticalAlignment = -4108;
            iRow++;
        }

        //������������ɫ
        xlSheet1.Range(xlSheet1.cells(3,1),xlSheet1.cells(3,count)).Interior.ColorIndex = 37;

        //��ʽд�������
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
                             //��ȡ�������ֵ,��д��excel
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
        //���ߡ�����
        xlSheet1.Range(xlSheet1.cells(3,1),xlSheet1.cells(iRow - 2, count)).Borders.LineStyle = 1;
        xlApp.Visible = true;
      }
      catch(e) {
          alert("ϵͳ����:"+e.message);
          if(xlApp)
          {
              xlApp.quit();
              xlApp = null;
          }
      }
  }


/**
 *sheetObj:xsl����
 *startRow:��ʼ��
 *startCol:��ʼ��
 *tableObj:������
 *parts:
 *offsetCol:
 *tbHeadMaxRow:��ͷ�������
 *tbHeadMaxCol:��ͷ�������
 *֧�ֺ�rowspan,colspan�ı�񵼳�excel
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

    for(var j = 0;j < tbHeadMaxRow;j++){//Լ�������п�ʼ��ʾ��ͷ
        var k = j + 3;
        sheetObj.Range(sheetObj.cells(k,1),sheetObj.cells(k,tbHeadMaxCol)).Interior.ColorIndex = 37;//������������ɫ
        sheetObj.Range(sheetObj.cells(k,1),sheetObj.cells(k,tbHeadMaxCol)).Borders.LineStyle = 1;//���������л���
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
                	  //����п��еĵ�Ԫ��
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
                //������������
                if(iCol > maxCol){
                  maxCol =  iCol;
                }
                //�������û���������������
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
 * str���Ƿ����������
 * @param: str ��Ҫ�жϵ��ַ���
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