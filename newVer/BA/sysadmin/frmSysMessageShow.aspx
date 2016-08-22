<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmSysMessageShow.aspx.cs" Inherits="BA_sysadmin_frmSysMessageShow" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html>
<head>
<title>系统公告查看</title><meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
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
            var query = location.search.substring(1); //获取查询串   
            var pairs = query.split("&"); //在逗号处断开   
            for (var i = 0; i < pairs.length; i++) {
                var pos = pairs[i].indexOf('='); //查找name=value   
                if (pos == -1) continue; //如果没有找到就跳过   
                var argname = pairs[i].substring(0, pos); //提取name   
                var value = pairs[i].substring(pos + 1); //提取value   
                args[argname] = unescape(value); //存为属性   
            }
            return args;
        }
        var args = new Object();
        args = GetUrlParms();
        var messageId = args["msgid"];
    </script>
<script type="text/javascript">
Ext.onReady(function(){
/*------实现FormPanle的函数 start---------------*/
var msgForm=new Ext.form.FormPanel({
	el:'divForm',
	frame:true,
	title:'系统公告查看',
	labelWidth:55,
	items:[
		{
			xtype:'hidden',
			fieldLabel:'消息ID',
			name:'MessageId',
			id:'MessageId',
			hidden:true,
			hideLabel:true
		}
,		{
			xtype:'textfield',
			fieldLabel:'消息标题',
			columnWidth:1,
			anchor:'98%',
			name:'Title',
			id:'Title',
			readOnly:true
		}
,		{
			xtype:'displayfield',
			fieldLabel:'消息内容',
			columnWidth:1,
			height:200,
			anchor:'98%',
			name:'Message',
			id:'Message',
			readOnly:true
		}
,		{
			xtype:'datefield',
			fieldLabel:'有效期限',
			columnWidth:1,
			anchor:'50%',
			name:'ExpirationDate',
			id:'ExpirationDate',
			format: 'Y年m月d日',
		    disabled:true
		}
,		{
			xtype:'textarea',
			fieldLabel:'备注',
			columnWidth:1,
			anchor:'98%',
			name:'Remark',
			id:'Remark',
			readOnly:true
		}
]
});
msgForm.render();
/*------FormPanle的函数结束 End---------------*/

/*------开始界面数据的函数 Start---------------*/
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
		Ext.Msg.alert("提示","获取消息消息失败");
	}
	});
}
/*------结束设置界面数据的函数 End---------------*/
if(messageId != "" && messageId != null)
    setFormValue(messageId);
})
</script>

</html>

