/**

 *　检测时间是否合法(只处理格式为HH:MM:SS的时间)。

 */

function isValidTime(timeStr) {

    var strSplit;

    if(timeStr.length != 8)

    {

        window.alert("时间长度不对，请正确输入时间：HH:MM:SS\n\n其中：HH(0-23)，MM(0-59)，SS(0-59)！");

        return false;

    }



    intHour = parseInt(timeStr.substr(0, 2), 10);

    if(intHour < 0 || intHour > 23)

    {

        window.alert("时间不对，小时范围：0 ~ 23");

        return false;

    }



    strSplit = timeStr.substr(2, 1);

    if (strSplit != ":") {

        alert("时间分隔符应为':'！");

        return false;

    }



    intMin = parseInt(timeStr.substr(3, 2), 10);

    if(intMin < 0 || intMin > 59)

    {

        window.alert("时间不对，分钟范围：0 ~ 59");

        return false;

    }



    strSplit = timeStr.substr(5, 1);

    if (strSplit != ":") {

        alert("时间分隔符应为':'！");

        return false;

    }



    intSec = parseInt(timeStr.substr(6, 2), 10);

    if(intSec < 0 || intSec > 59)

    {

        window.alert("时间不对，秒范围：0 ~ 59");

        return false;

    }

    return true;

}

/**

 *　检测时间是否合法。(HHMMSS)

 */

function isValidTimeEx(timeStr) {

    if (!isNumber(timeStr))

    {

        window.alert("时间由数字组成，请正确输入时间：HH:MM:SS\n\n其中：HH(0-23)，MM(0-59)，SS(0-59)！");

        return false;

    }

    if(timeStr.length != 6)

    {

        window.alert("时间长度不对，请正确输入时间：HH:MM:SS\n\n其中：HH(0-23)，MM(0-59)，SS(0-59)！");

        return false;

    }



    intHour = parseInt(timeStr.substr(0, 2), 10);

    if(intHour < 0 || intHour > 23)

    {

        window.alert("时间不对，小时范围：0 ~ 23");

        return false;

    }



    intMin = parseInt(timeStr.substr(2, 2), 10);

    if(intMin < 0 || intMin > 59)

    {

        window.alert("时间不对，分钟范围：0 ~ 59");

        return false;

    }



    intSec = parseInt(timeStr.substr(4, 2), 10);

    if(intSec < 0 || intSec > 59)

    {

        window.alert("时间不对，秒范围：0 ~ 59");

        return false;

    }

    return true;

}

/**

 *　检测日期是否合法(只处理格式为YYYY-MM-DD的日期)。

 */

function isValidDate(dateStr) {

    var intYear;

    var intMonth;

    var intDay;

    var maxDay;

    var strSplit;



    if (dateStr.length != 10) {

        alert("请输入正确的日期，格式为: YYYY-MM-DD，例如: '2000-05-15'！");

        return false;

    }



    if (!isNumber(dateStr.substr(0, 4))) {

        alert("年份中包含有非数字字符！");

        return false;

    }



    intYear = parseInt(dateStr.substr(0, 4), 10);

    if(intYear < 1901 || intYear > 2099)

    {

        alert("输入的年份应该为(1901 ~ 2099)！");

        return false;

    }



    strSplit = dateStr.substr(4, 1);



    if (strSplit != "-") {

        alert("日期分隔符应为-！");

        return false;

    }



    if (!isNumber(dateStr.substr(5, 2))) {

        alert("月份中包含有非数字字符！");

        return false;

    }

    intMonth = parseInt(dateStr.substr(5, 2), 10);

    if(intMonth < 1 || intMonth > 12)

    {

        alert("输入的月份应该为(01 ~ 12)！");

        return false;

    }



    strSplit = dateStr.substr(7, 1);

    if (strSplit != "-") {

       alert("日期分隔符应为-！");

       return false;

    }



    if (!isNumber(dateStr.substr(8, 2))) {

        alert("日期中包含有非数字字符！");

        return false;

    }

    if (dateStr.substr(8, 2) == "00") {

        alert("输入的日期不能为00！");

        return false;

    }



    intDay = parseInt(dateStr.substr(8, 2), 10);



    maxDay = days_of_month(intYear, intMonth);

    if(intDay < 1 || intDay > maxDay)

    {

        alert("输入的日期应该为(01 ~ " + maxDay +")！");

        return false;

    }



    return true;

}



//判断输入的月份是否合法(只处理格式为YYYY-MM的月份)

function isValidMonth(dateStr) {

    var intYear;

    var intMonth;

     var strSplit;



    if (dateStr.length != 7) {

        alert("请输入正确的日期，格式为: YYYY-MM，例如: '2000-05'！");

        return false;

    }



    if (!isNumber(dateStr.substr(0, 4))) {

        alert("年份中包含有非数字字符！");

        return false;

    }



    intYear = parseInt(dateStr.substr(0, 4), 10);

    if(intYear < 1901 || intYear > 2099)

    {

        alert("输入的年份应该为(1901 ~ 2099)！");

        return false;

    }



    strSplit = dateStr.substr(4, 1);

    if (strSplit != "-") {

        alert("日期分隔符应为-！");

        return false;

    }



    if (!isNumber(dateStr.substr(5, 2))) {

        alert("月份中包含有非数字字符！");

        return false;

    }

    intMonth = parseInt(dateStr.substr(5, 2), 10);

    if(intMonth < 1 || intMonth > 12)

    {

        alert("输入的月份应该为(01 ~ 12)！");

        return false;

    }



    return true;

}

//判断输入的月份是否合法(只处理格式为YYYYMM的月份)

function isCheckValidMonth(dateStr) {

    var intYear;

    var intMonth;

     var strSplit;



    if (dateStr.length != 6) {

        alert("请输入正确的日期，格式为: YYYYMM，例如: '200005'！");

        return false;

    }



    if (!isNumber(dateStr.substr(0, 4))) {

        alert("年份中包含有非数字字符！");

        return false;

    }



    intYear = parseInt(dateStr.substr(0, 4), 10);

    if(intYear < 1901 || intYear > 2099)

    {

        alert("输入的年份应该为(1901 ~ 2099)！");

        return false;

    }



    if (!isNumber(dateStr.substr(4, 2))) {

        alert("月份中包含有非数字字符！");

        return false;

    }

    intMonth = parseInt(dateStr.substr(4, 2), 10);

    if(intMonth < 1 || intMonth > 12)

    {

        alert("输入的月份应该为(01 ~ 12)！");

        return false;

    }



    return true;

}

//转换月份输入格式，返回：YYYY-MM-01 00:00:00

//-----jiangwj--------

function convertMonth(dateStr) {

    var intYear;

    var intMonth;



   if (dateStr.length != 6) {

      return dateStr;

   }

    intYear = parseInt(dateStr.substr(0, 4), 10);

   intMonth = parseInt(dateStr.substr(4, 2), 10);

    if (intMonth<10)

	   return intYear+"-0"+intMonth+"-01 00:00:00";

	 else

	   return intYear+"-"+intMonth+"-01 00:00:00";

}

/**

 *　检测日期时间是否合法(YYYY-MM-DD HH:MM:SS)。

 */

function isValidDateTime(dateTime) {

    var strSplit;

    if (dateTime.length != 19) {

        alert("请输入格式如下的日期：YYYY-MM-DD HH:MM:SS");

        return false;

    }



    if(!isValidDate(dateTime.substr(0, 10))) {

        return false;

    }



    strSplit = dateTime.substr(10, 1)

    if (strSplit != " ") {

        alert("日期格式不对,应为：YYYY-MM-DD HH:MM:SS!");

        return false;

    }



    if (!isValidTime(dateTime.substr(11, 8))) {

        return false;

    }

    return true;

}

/**

 *　检测日期是否合法。(只处理格式为YYYYMMDD的日期)

 */

function isValidDateEx(dateStr) {

    var intYear;

    var intMonth;

    var intDay;

    var maxDay;



    if (dateStr.length != 8) {

        alert("请输入正确的日期，格式为: YYYYMMDD，例如: '20000515'！");

        return false;

    }



    if (!isNumber(dateStr)) {

        alert("日期中包含有非数字字符！");

        return false;

    }



    intYear = parseInt(dateStr.substr(0, 4), 10);

    if(intYear < 1901 || intYear > 2099)

    {

        alert("输入的年份应该为(1901 ~ 2099)！");

        return false;

    }



    intMonth = parseInt(dateStr.substr(4, 2), 10);

    if(intMonth < 1 || intMonth > 12)

    {

        alert("输入的月份应该为(01 ~ 12)！");

        return false;

    }



    if (dateStr.substr(6, 2) == "00") {

        alert("输入的日期不能为00！");

        return false;

    }



    intDay = parseInt(dateStr.substr(6, 2), 10);



    maxDay = days_of_month(intYear, intMonth);

    if(intDay < 1 || intDay > maxDay)

    {

        alert("输入的日期应该为(01 ~ " + maxDay +")！");

        return false;

    }



    return true;

}

/**

 * 得到指定年指定月的当月最大天数。

 */

function days_of_month(year, month)

{

    switch (month)

    {

        case 1:

        case 3:

        case 5:

        case 7:

        case 8:

        case 10:

        case 12:

            return 31;

        case 4:

        case 6:

        case 9:

        case 11:

            return 30;

        case 2:

            if (is_leap_year(year)) {

                return 29;

            } else {

                return 28;

            }

    }

}



/**

 * 检测是否为闰年。

 */

function is_leap_year(year)

{

    if(((year % 4 == 0) && (year % 100 != 0)) || (year % 400 == 0)) {

        return true;

    } else {

        return false;

    }

}



//得到相隔N年的月份

function addMonth(dateStr) {

    var intYear;

    var intMonth;



    intYear = parseInt(dateStr.substr(0, 4), 10);

    intYear=intYear+1;

    if(intYear < 1901 || intYear > 2099)

    {

        alert("输入的年份应该为(1901 ~ 2099)！");

        return "";

    }

   intMonth = parseInt(dateStr.substr(4, 2), 10);

   intMonth=11-Math.abs(intMonth-12);

    if (intMonth<10)

	   return intYear+"0"+intMonth;

	 else

	   return intYear+""+intMonth;

}

/**

 *日期方法增加月份,返回格式：YYYY-MM-DD

 */

function addMonths(strDate,iNum)

{
    if(!isValidDate(strDate))

        return;

    var iYear = 1900 ;

    var iMonth = 1 ;

    var strYear = "" ;

    var strMonth  = "" ;

    var strDayTime = "" ;

    var iAllMonths = 0 ;

    iYear = Number(strDate.substr(0,4));

    iMonth = Number(strDate.substr(5,2));

    strDayTime = strDate.substr(8,strDate.length-8);

    iAllMonths = iYear * 12 + iMonth - 1 + iNum ;



    iYear = parseInt(iAllMonths / 12) ;

    iMonth = iAllMonths % 12 + 1;



    strYear = String("0000") + parseInt(iYear);

    strYear = strYear.substring(strYear.length-4,strYear.length);

    strMonth="00"+parseInt(iMonth);

    strMonth = strMonth.substring(strMonth.length-2,strMonth.length);
    /***added by huzf  begin ***/
    //zhangxm2 edit 20070904 parseInt()问题，一定要指明是十进制
    //new Date(2007,11,31)=2007.12.1
    var newDateObj = new Date(strYear, strMonth-1, strDayTime);
    var newMonth = newDateObj.getMonth()+1;
    var newDay = newDateObj.getDate();
    if( newMonth > parseInt(strMonth,10) ){
      strDayTime = parseInt(strDayTime) - newDay;
    }
    /***added by huzf  end ***/
    strDate = strYear+"-"+strMonth+"-"+strDayTime ;
    return strDate;

}

/**

 * 日期方法增加天数

 * 注意：strDate格式为YYYY-MM-DD

 * 返回格式：YYYY-MM-DD

 */

function addDays(strDate,iNum)

{

    var iYear = 1900 ;

    var iMonth = 1 ;

    var strYear = "" ;

    var strMonth  = "" ;

    var strDayTime = "" ;

    var iAllMonths = 0 ;

    iYear = Number(strDate.substr(0,4));

    iMonth = Number(strDate.substr(5,2))-1;

    iDay = Number(strDate.substr(8,2));



    var returnDate=new Date();

    returnDate.setFullYear(iYear,iMonth,iDay);

    returnDate.setDate(returnDate.getDate()+parseInt(iNum));



    strYear = String("0000") + returnDate.getFullYear();

    strYear = strYear.substring(strYear.length-4,strYear.length);

    strMonth="00"+parseInt(parseInt(returnDate.getMonth())+parseInt("1"));

    strMonth = strMonth.substring(strMonth.length-2,strMonth.length);

    strDayTime = "00"+parseInt(returnDate.getDate());

    strDayTime = strDayTime.substring(strDayTime.length-2,strDayTime.length);

    strDate = strYear+"-"+strMonth+"-"+strDayTime;

    return strDate;

}

/**

 * 得到当前时间

 * 格式：2006-08-08 23:04:11

 */

function getNowTime(separator)

{

    var today = new Date();

    var month = 1+today.getMonth();

    var strMonth = "";

    if(month <10){

      strMonth = "0"+month;

    }else{

      strMonth = month;

    }

    var myday = today.getDate();

    var strDay = "";

    if(myday <10){

      strDay = "0"+myday;

    }else{

      strDay = ""+myday;

    }

    var strToDay = today.getFullYear()+separator+strMonth+separator+strDay;

    var hour = today.getHours();

    if(hour <10){

      hour = "0"+hour;

    }

    var minute =today.getMinutes();

    if(minute <10){

      minute = "0"+minute;

    }

    var second = today.getSeconds();

    if(second <10){

      second = "0"+second;

    }

    var strTime = strToDay+" "+hour+":"+minute+":"+second;

    return strTime;

}

//得到今天时间

function getToDay(separator)

{

    var today = new Date();

    var month = 1+today.getMonth();

    var strMonth = "";

    if(month <10){

      strMonth = "0"+month;

    }else{

      strMonth = month;

    }

    var myday = today.getDate();

    var strDay = "";

    if(myday <10){

      strDay = "0"+myday;

    }else{

      strDay = ""+myday;

    }

    var strToDay = today.getFullYear()+separator+strMonth+separator+strDay;

    return strToDay;

}

//得到昨天时间

function getYesterday(separator)

{

	var today = new Date();

    today.setDate(today.getDate()-1);

    var month = 1+today.getMonth();

    var strMonth = "";

    if(month <10){

      strMonth = "0"+month;

    }else{

      strMonth = month;

    }

    var myday = today.getDate();

    var strDay = "";

    if(myday <10){

      strDay = "0"+myday;

    }else{

      strDay = ""+myday;

    }

    var strToDay = today.getFullYear()+separator+strMonth+separator+strDay;

    return strToDay;

}

//得到明天时间

function getTomorrow(separator)

{

	var today = new Date();

    today.setDate(today.getDate()+1);

    var month = 1+today.getMonth();

    var strMonth = "";

    if(month <10){

      strMonth = "0"+month;

    }else{

      strMonth = month;

    }

    var myday = today.getDate();

    var strDay = "";

    if(myday <10){

      strDay = "0"+myday;

    }else{

      strDay = ""+myday;

    }

    var strToDay = today.getFullYear()+separator+strMonth+separator+strDay;

    return strToDay;

}
//得到本月月初时间

function getThisMonthFirstDay(separator)

{

	var today = new Date();

    today.setDate(1);

    var month = 1+today.getMonth();

    var strMonth = "";

    if(month <10){

      strMonth = "0"+month;

    }else{

      strMonth = month;

    }

    var myday = today.getDate();

    var strDay = "";

    if(myday <10){

      strDay = "0"+myday;

    }else{

      strDay = ""+myday;

    }

    var strToDay = today.getFullYear()+separator+strMonth+separator+strDay;

    return new Date(Date.parse(strToDay));

}
//得到本月月末时间

function getThisMonthLastDay(separator)

{

	return new Date(Date.parse(getThisMonthFirstDay)).setDate(0);

}
/**

 * 比较两个日期的大小。

 */

function compareDate(startDate, endDate)

{

    startDate = (new String(startDate)).replace(/-/g, "/");

    endDate = (new String(endDate)).replace(/-/g, "/");

    var eDate = new Date(Date.parse(endDate));

    var sDate = new Date(Date.parse(startDate));

    sDate.setHours(0);

    sDate.setMinutes(0);

    sDate.setSeconds(0);

    //return (Date.parse(sDate) <= eDate);

    return (Date.parse(sDate) <= Date.parse(eDate));

}



//校验日期范围

function checkDateRange(BeginDate,EndDate)

{

    var strBegindate = BeginDate.substring(0,4)+BeginDate.substring(5,7)+BeginDate.substring(8,10);

    var strEnddate = EndDate.substring(0,4)+EndDate.substring(5,7)+EndDate.substring(8,10);

    if(parseInt(strBegindate)>parseInt(strEnddate))

    {

        alert("开始日期不能大于截止日期！");

        return false;

    }

    return true;

}

//校验日期时间 格式如：YYYY-MM-DD HH:MM:SS

//zhangxm2 add

function compareDateRange(BeginDate,EndDate)

{

    var strBegindate = BeginDate.substring(0,4)+BeginDate.substring(5,7)

	              +BeginDate.substring(8,10);

	var strBegindate_time=BeginDate.substring(11,13)

				  +BeginDate.substring(14,16)+BeginDate.substring(17,19);

    var strEnddate = EndDate.substring(0,4)+EndDate.substring(5,7)

	              +EndDate.substring(8,10);

	var strEnddate_time=EndDate.substring(11,13)

				  +EndDate.substring(14,16)+EndDate.substring(17,19);

    if(parseInt(strBegindate,10)>parseInt(strEnddate,10))

    {

        return false;

    }else if(parseInt(strBegindate,10)==parseInt(strEnddate,10)){

	  if(parseInt(strBegindate_time,10)>parseInt(strEnddate_time,10)){

		return false;

	  }

	}

    return true;

}

//校验日期时间 格式如：YYYY-MM-DD

function checkDateRangeCaption(BeginDate,BeginCaption,EndDate,EndCaption)

{

    var strBegindate = BeginDate.substring(0,4)+BeginDate.substring(5,7)+BeginDate.substring(8,10);

    var strEnddate = EndDate.substring(0,4)+EndDate.substring(5,7)+EndDate.substring(8,10);

    if(parseInt(strBegindate)>parseInt(strEnddate))

    {

        alert(BeginCaption +"不能大于"+EndCaption +"！");

        return false;

    }

    return true;

}

//月份比较

function compareMonth(vBeginMonth, vEndMonth)

{

    if(!isCheckValidMonth(vBeginMonth) || !isCheckValidMonth(vEndMonth))

    {

        return false;

    }

    return (parseInt(vBeginMonth) <= parseInt(vEndMonth));

}

//日期比较，返回两个日期相差的天数

function DateCompare(asStartDate,asEndDate){

 var miStart = Date.parse(asStartDate.replace(/\-/g, '/'));

 var miEnd   = Date.parse(asEndDate.replace(/\-/g, '/'));

 return (miEnd-miStart)/(1000*24*3600);

}




