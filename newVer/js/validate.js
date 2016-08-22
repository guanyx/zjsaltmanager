/**
 * ˵���������ַ������ֽ���
 * ʹ�ã�getLength("�����ֽ�������test!")
 * ע�⣺�������ַ���Ϊ�ջ�nullʱ����0
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
 * ˵���������Ƿ�Ϊ�ʼ���ַ
 * ʹ�ã�isMailAddress("mssnzxm@hotmail.com")
 * ע�⣺�������ַ���Ϊ�ջ�nullʱ����false
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
 * ����������֤���ݵ���Ч��
 * ͳһ����������ʽ�����ж�
 * ���ӣ�isValidate("12.56","float",true)
 * minSize ��ʾֵ��С����
 * maxSize ��ʾֵ��󳤶�
 * pointMinSize ��ʾС�������С����
 * pointMaxSize ��ʾС�������󳤶�
 */
function isValidate(value,fieldType,isAlert,minSize,maxSize,pointMinSize,pointMaxSize){
	if(isAlert==null){
		isAlert=false;
	}
	if(value==null||value==""){
		return false;//����У���ֵ����Ϊ�ǿ�ֵ
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
	if (fieldType == "datetime") { //19λ����1900-2099
			var re = new RegExp("^(19[0-9][0-9]|[2][0][0-9][0-9])-([0][1-9]|[1][0-2])-([0][1-9]|[1-2][0-9]|[3][0-1]) ([0-1][0-9]|[2][0-3]):([0-5][0-9]):([0-5][0-9])$", "g");
			if(!re.test(value)){
				if(isAlert==true){
				   alert("��" + value + "���������������");
				}
				return false;
			}
	} else if (fieldType == "date") { //10λ����
			var re = new RegExp("^(19[0-9][0-9]|[2][0][0-9][0-9])-([0][1-9]|[1][0-2])-([0][1-9]|[1-2][0-9]|[3][0-1])$", "g");
			if(!re.test(value)){
				if(isAlert==true){
				   alert("��" + value + "���������������");
				}
				return false;
			}
	} else if (fieldType == "mail") { //�����ʼ�
			if (!isMailAddress(value)) {
				if(isAlert==true){
				   alert("��" + value + "���������ʼ��������");
				}
				return false;
			}
	} else if (fieldType == "postcode") { //��������
			var re = new RegExp("^[0-9]{6,6}$", "");
			if(!re.test(value)){
				if(isAlert==true){
				   alert("��" + value + "�������������������");
				}
				return false;
			}
	} else if (fieldType == "integer") { //��������λ������
			var re = new RegExp("^[0-9]{"+ minSize + "," + maxSize + "}$", "g");
			if (!re.test(value)) {
				if(isAlert==true){
				   alert("��" + value + "���������������");
				}
				return false;
			}
	} else if (fieldType == "float") { //С������λ������
			var re = new RegExp("^[0-9]{"+ minSize + "," + maxSize + "}(\.[0-9]{" + pointMinSize +  "," + pointMaxSize + "})?$");
			if (!re.test(value)) {
				if(isAlert==true){
				   alert("��" + value + "����С���������");
				}
				return false;
			}
	} else if (fieldType == "signedfloat") { //������С������λ������,
            if(value == "-"){
                return true;
            }
			var re = new RegExp("^[0-9]{"+ minSize + "," + maxSize + "}(\.[0-9]{" + pointMinSize +  "," + pointMaxSize + "})?$");
                        var re2 = new RegExp("^\-[0-9]{"+ minSize + "," + maxSize + "}(\.[0-9]{" + pointMinSize +  "," + pointMaxSize + "})?$");
			if (!re.test(value)&&!re2.test(value)) {
				if(isAlert==true){
				   alert("��" + value + "����С���������");
				}
				return false;
			}
	}  else{
		alert("δ֪�ֶ����ͣ�");
		return false;
	}
	return true;
}
