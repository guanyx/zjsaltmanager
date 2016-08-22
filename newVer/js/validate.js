/**
 * 说明：返回字符串的字节数
 * 使用：getLength("返回字节数函数test!")
 * 注意：当输入字符串为空或null时返回0
 */
function getLength(value){
	var n = 0;
	if(value == null || value == "") return 0;
	for(var i=0; i<value.length; i++){
		n += (value.charAt(i) <= "~")? 1:2;
	}
	return(n);
}
/**
 * 说明：测试是否为邮件地址
 * 使用：isMailAddress("mssnzxm@hotmail.com")
 * 注意：当输入字符串为空或null时返回false
 */
function isMailAddress(value){
	if(value == null || value.length == 0) return false;
	value = value.toLowerCase();
	var tmpValue = new Array();
	tmpValue = value.match(/^[a-z,0-9,\-,\_,\.]+@[a-z,0-9]+(\.[a-z,0-9]+)+$/);
	if(tmpValue !=null && tmpValue[0] == value) return true;
	return false;
}
/**
 * 根据类型验证数据的有效性
 * 统一运用正则表达式进行判断
 * 例子：isValidate("12.56","float",true)
 * minSize 表示值最小长度
 * maxSize 表示值最大长度
 * pointMinSize 表示小数点后最小长度
 * pointMaxSize 表示小数点后最大长度
 */
function isValidate(value,fieldType,isAlert,minSize,maxSize,pointMinSize,pointMaxSize){
	if(isAlert==null){
		isAlert=false;
	}
	if(value==null||value==""){
		return false;//进行校验的值必须为非空值
	}
	if(fieldType==null||fieldType==""){
		return false;
	}
        if(minSize==null){
           minSize = 1;
        }
        if(maxSize==null){
           maxSize = 8;
        }
        if(pointMinSize==null){
           pointMinSize = 1;
        }
        if(pointMaxSize==null){
           pointMaxSize = 2;
        }
	if (fieldType == "datetime") { //19位日期1900-2099
			var re = new RegExp("^(19[0-9][0-9]|[2][0][0-9][0-9])-([0][1-9]|[1][0-2])-([0][1-9]|[1-2][0-9]|[3][0-1]) ([0-1][0-9]|[2][0-3]):([0-5][0-9]):([0-5][0-9])$", "g");
			if(!re.test(value)){
				if(isAlert==true){
				   alert("『" + value + "』：日期输入错误！");
				}
				return false;
			}
	} else if (fieldType == "date") { //10位日期
			var re = new RegExp("^(19[0-9][0-9]|[2][0][0-9][0-9])-([0][1-9]|[1][0-2])-([0][1-9]|[1-2][0-9]|[3][0-1])$", "g");
			if(!re.test(value)){
				if(isAlert==true){
				   alert("『" + value + "』：日期输入错误！");
				}
				return false;
			}
	} else if (fieldType == "mail") { //电子邮件
			if (!isMailAddress(value)) {
				if(isAlert==true){
				   alert("『" + value + "』：电子邮件输入错误！");
				}
				return false;
			}
	} else if (fieldType == "postcode") { //邮政编码
			var re = new RegExp("^[0-9]{6,6}$", "");
			if(!re.test(value)){
				if(isAlert==true){
				   alert("『" + value + "』：邮政编码输入错误！");
				}
				return false;
			}
	} else if (fieldType == "integer") { //整数，有位数限制
			var re = new RegExp("^[0-9]{"+ minSize + "," + maxSize + "}$", "g");
			if (!re.test(value)) {
				if(isAlert==true){
				   alert("『" + value + "』：整数输入错误！");
				}
				return false;
			}
	} else if (fieldType == "float") { //小数，有位数限制
			var re = new RegExp("^[0-9]{"+ minSize + "," + maxSize + "}(\.[0-9]{" + pointMinSize +  "," + pointMaxSize + "})?$");
			if (!re.test(value)) {
				if(isAlert==true){
				   alert("『" + value + "』：小数输入错误！");
				}
				return false;
			}
	} else if (fieldType == "signedfloat") { //带符号小数，有位数限制,
            if(value == "-"){
                return true;
            }
			var re = new RegExp("^[0-9]{"+ minSize + "," + maxSize + "}(\.[0-9]{" + pointMinSize +  "," + pointMaxSize + "})?$");
                        var re2 = new RegExp("^\-[0-9]{"+ minSize + "," + maxSize + "}(\.[0-9]{" + pointMinSize +  "," + pointMaxSize + "})?$");
			if (!re.test(value)&&!re2.test(value)) {
				if(isAlert==true){
				   alert("『" + value + "』：小数输入错误！");
				}
				return false;
			}
	}  else{
		alert("未知字段类型！");
		return false;
	}
	return true;
}
