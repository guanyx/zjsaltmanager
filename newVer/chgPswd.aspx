<%@ Page Language="C#" AutoEventWireup="true" CodeFile="chgPswd.aspx.cs" Inherits="chgPswd" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<title>�����޸�</title>
<link rel="stylesheet" href="Theme/1/css/frame/mobile.css" type="text/css" />
<script type="text/javascript" >
    var theForm;

    function doInit() {
    	chgpwdForm.login_user.focus();

    }

	function doCheckForm(vFormObjName, vCaption)
	{
		var objForm = eval(vFormObjName);
		if(objForm.value == null || objForm.value == "")
		{
			alert("'" + vCaption + "'��ֵ������д��");
			objForm.focus();
			return false;
		}
		return true;
	}

	var isSubmit = false;

    function doSubmit() {

		if(isSubmit)
		{
			alert("�Ѿ��ύ�޸����������");
			return ;
			
		}
		else
		{
			isSubmit = true;
		}
      	if(doCheckForm(chgpwdForm.login_user,"��¼��") == false){
        	return false;
      	}
        if(doCheckForm(chgpwdForm.old_login_password,"ԭ����") == false){
        	return false;
      	}
        if(doCheckForm(chgpwdForm.login_password,"������") == false){
        	return false;
      	}
        if(doCheckForm(chgpwdForm.confirm_login_password,"����ȷ��") == false){
        	return false;
      	}
        if(chgpwdForm.confirm_login_password.value != chgpwdForm.login_password.value) {
            alert("����������ȷ�����벻һ�£�");
            chgpwdForm.confirm_login_password.focus();
            return false;
        }
        chgpwdForm.submit();
    }

	function doSubmitForKeyPress()
	{
    	if(window.event.keyCode == 13)
    	{
        	doSubmit();
    	}
	}

    function doCancel() {
        window.close();
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
</script>
</head>

<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">

<table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0">
  <tr>
    <td align="center" background="Theme/1/images/frame/code_bg.jpg">
      <table width="281" height="130" border="0" cellpadding="0" cellspacing="0">
<form name="chgpwdForm" method="post" action="logined.aspx?method=chgpwd">
        <tr>
          <td width="81" align="right" class="white">��¼����</td>
          <td width="200" height="25">
            <input name="login_user" type="text" class="box" value="" size="16" maxlength="16" onKeyPress="doKeyDown(chgpwdForm.old_login_password)" ></td>
        </tr>
        <tr>
          <td align="right" class="white">ԭ���룺</td>
          <td height="25">
            <input name="old_login_password" type="password" class="box" value="" size="16" maxlength="16" onKeyPress="doKeyDown(chgpwdForm.login_password)"></td>
        </tr>
        <tr>
          <td align="right" class="white">�����룺</td>
          <td height="25">
            <input name="login_password" type="password" class="box" value="" size="16" onKeyPress="doKeyDown(chgpwdForm.confirm_login_password)"> </td>
        </tr>
        <tr>
          <td align="right" class="white">����ȷ�ϣ�</td>
          <td height="25">
            <input name="confirm_login_password" type="password" class="box" value="" size="16" onKeyPress="doSubmitForKeyPress()"></td>
        </tr>
        <tr>
          <td height="38">&nbsp;</td>
          <td><table width="140" border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td><img src="Theme/1/images/frame/preset.jpg" width="62" height="17" border="0" onclick="doSubmit();"></td>
                <td><img src="Theme/1/images/frame/pclose.jpg" width="62" height="17" border="0" onclick="doCancel();"></td>
              </tr>
            </table></td>
        </tr>
</form>
      </table></td>
  </tr>
</table>
</body>
</html>
