<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmSysMessageShow.aspx.cs" Inherits="BA_sysadmin_frmSysMessageShow" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html>
<head>
<title>ϵͳ����鿴</title><meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<link rel="stylesheet" type="text/css" href="../../ext3/resources/css/ext-all.css" />
<script type="text/javascript" src="../../ext3/adapter/ext/ext-base.js"></script>
<script type="text/javascript" src="../../ext3/ext-all.js"></script>
<script type="text/javascript" src="../../ext3/example/Ext.form.DisplayField.js"></script>
</head>
<body>
<div id='divForm'></div>
</body>
    <script type="text/javascript">
        function GetUrlParms() {
            var args = new Object();
            var query = location.search.substring(1); //��ȡ��ѯ��   
            var pairs = query.split("&"); //�ڶ��Ŵ��Ͽ�   
            for (var i = 0; i < pairs.length; i++) {
                var pos = pairs[i].indexOf('='); //����name=value   
                if (pos == -1) continue; //���û���ҵ�������   
                var argname = pairs[i].substring(0, pos); //��ȡname   
                var value = pairs[i].substring(pos + 1); //��ȡvalue   
                args[argname] = unescape(value); //��Ϊ����   
            }
            return args;
        }
        var args = new Object();
        args = GetUrlParms();
        var messageId = args["msgid"];
    </script>
<script type="text/javascript">
Ext.onReady(function(){
/*------ʵ��FormPanle�ĺ��� start---------------*/
var msgForm=new Ext.form.FormPanel({
	el:'divForm',
	frame:true,
	title:'ϵͳ����鿴',
	labelWidth:55,
	items:[
		{
			xtype:'hidden',
			fieldLabel:'��ϢID',
			name:'MessageId',
			id:'MessageId',
			hidden:true,
			hideLabel:true
		}
,		{
			xtype:'textfield',
			fieldLabel:'��Ϣ����',
			columnWidth:1,
			anchor:'98%',
			name:'Title',
			id:'Title',
			readOnly:true
		}
,		{
			xtype:'displayfield',
			fieldLabel:'��Ϣ����',
			columnWidth:1,
			height:200,
			anchor:'98%',
			name:'Message',
			id:'Message',
			readOnly:true
		}
,		{
			xtype:'datefield',
			fieldLabel:'��Ч����',
			columnWidth:1,
			anchor:'50%',
			name:'ExpirationDate',
			id:'ExpirationDate',
			format: 'Y��m��d��',
		    disabled:true
		}
,		{
			xtype:'textarea',
			fieldLabel:'��ע',
			columnWidth:1,
			anchor:'98%',
			name:'Remark',
			id:'Remark',
			readOnly:true
		}
]
});
msgForm.render();
/*------FormPanle�ĺ������� End---------------*/

/*------��ʼ�������ݵĺ��� Start---------------*/
function setFormValue(MessageId)
{
	Ext.Ajax.request({
		url:'frmSysMessage.aspx?method=getMessage',
		params:{
			MessageId:MessageId
		},
	success: function(resp,opts){
		var data=Ext.util.JSON.decode(resp.responseText);
		Ext.getCmp("MessageId").setValue(data.MessageId);
		Ext.getCmp("Title").setValue(data.Title);
		Ext.getCmp("Message").setValue(Ext.util.Format.htmlDecode(data.Message));
		Ext.getCmp("ExpirationDate").setValue((new Date(data.ExpirationDate.replace(/-/g,"/"))));
		Ext.getCmp("Remark").setValue(data.Remark);
	},
	failure: function(resp,opts){
		Ext.Msg.alert("��ʾ","��ȡ��Ϣ��Ϣʧ��");
	}
	});
}
/*------�������ý������ݵĺ��� End---------------*/
if(messageId != "" && messageId != null)
    setFormValue(messageId);
})
</script>

</html>

