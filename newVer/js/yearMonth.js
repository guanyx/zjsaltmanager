    var now = new Date();
    var year = now.getFullYear();
    var month = now.getMonth()+1;
function createYMObj(parentObj,objid,vYear,vMonth){

  var yearObj = document.createElement("<select name='"+objid+"_year'"+" id='"+objid+"_year'" +" class='select4'></select>");
	for(var i = 1990;i <2010;i++){
	  var strYear = i+"年";
	  yearObj.options[yearObj.options.length] = new Option(strYear,i,false)
	}
	if(vYear == null || vYear == ""){
	  for(var i = 0;i <yearObj.options.length;i++){
		if(yearObj.options[i].value == year){
		  yearObj.options[i].selected = "selected";
		  break;
		}
	  }
	}else{
	  for(var i = 0;i <yearObj.options.length;i++){
		if(yearObj.options[i].value == vYear){
		  yearObj.options[i].selected = "selected";
		  break;
		}
	  }
	}

var monthObj = document.createElement("<select name='"+objid+"_month'"+" id='"+objid+"_month'" +" class='select2'></select>");
	for(var i = 1;i <=12;i++){
	  var strMonth = i+"月";
	  monthObj.options[monthObj.options.length] = new Option(strMonth,i,false)
	}

	if(vMonth == null || vMonth == ""){
	  for(var i = 0;i <monthObj.options.length;i++){
		if(monthObj.options[i].value == month){
		  monthObj.options[i].selected = "selected";
		  break;
		}
	  }
	}else{
	  for(var i = 0;i <monthObj.options.length;i++){
		if(monthObj.options[i].value == vMonth){
		  monthObj.options[i].selected = "selected";
		  break;
		}
	  }
	}
  var tmpTable = document.createElement("<table width='100%' border='0' cellpadding='0' cellspacing='0'>");
  var tmpRow = tmpTable.insertRow();
  var tmpCell = tmpRow.insertCell();
  tmpCell.appendChild(yearObj);
  tmpCell.appendChild(monthObj);
  parentObj.appendChild(tmpTable);
}
function newYearMonthControl(parentObj,objid,vYear,vMonth){

   if(objid == null || objid ==""){
	alert("参数错误，请检查");
	return;
   }
  createYMObj(parentObj,objid,vYear,vMonth);
}
function getYMValue(objid,separator){
   if(objid == null || objid ==""){
	alert("参数错误，请检查");
	return "";
   }
  var strReturn = "";
  var strTemp = "document.all."+objid+"_year";
  var objY ;
  objY = eval(strTemp);
  strReturn = objY.options[objY.selectedIndex].value
  strTemp = "document.all."+objid+"_month";
  objY = eval(strTemp);
  var strMonth = objY.options[objY.selectedIndex].value;
  if(strMonth.length == 1){
	strMonth = "0"+strMonth;
  }
  if(separator == null || separator == ""){
	strReturn = strReturn + strMonth;
  }else{
	strReturn = strReturn + separator+strMonth;
  }
  return strReturn;
}
