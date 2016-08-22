<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmSysMessage.aspx.cs" Inherits="BA_sysadmin_frmSysMessage" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html>
<head>
<title>系统公告维护</title><meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<link rel="stylesheet" type="text/css" href="../../ext3/resources/css/ext-all.css" />
<script type="text/javascript" src="../../ext3/adapter/ext/ext-base.js"></script>
<script type="text/javascript" src="../../ext3/ext-all.js"></script>
<script type="text/javascript" src="../../js/OrgsSelect.js"></script> 
<script type="text/javascript" src="../../js/operateResp.js"></script>
<script type="text/javascript" src="../../ext3/example/StarHtmlEditor.js"></script>

</head>
<body>
<div id='toolbar'></div>
<div id='searchForm'></div>
<div id='datagrid'></div>

</body>
<%=getComboBoxStore()%>
<script type="text/javascript">
Ext.onReady(function(){
var saveType;
/*------实现toolbar的函数 start---------------*/
var Toolbar = new Ext.Toolbar({
	renderTo:"toolbar",
	items:[{
		text:"新增",
		icon:"../../Theme/1/images/extjs/customer/add16.gif",
		handler:function(){
		    saveType ='addMessage';
		    openAddMessageWin();
		}
		},'-',{
		text:"编辑",
		icon:"../../Theme/1/images/extjs/customer/edit16.gif",
		handler:function(){
		    saveType ='saveMessage';
		    modifyMessageWin();
		}
		},'-',{
		text:"删除",
		icon:"../../Theme/1/images/extjs/customer/delete16.gif",
		handler:function(){
		    deleteMessage();
		}
	}]
});

/*------结束toolbar的函数 end---------------*/


/*------开始ToolBar事件函数 start---------------*//*-----新增Message实体类窗体函数----*/
function openAddMessageWin() {
	uploadMessageWindow.show();
}
/*-----编辑Message实体类窗体函数----*/
function modifyMessageWin() {
	var sm = msggridData.getSelectionModel();
	//获取选择的数据消息
	var selectData =  sm.getSelected();
	if(selectData == null){
		Ext.Msg.alert("提示","请选中需要编辑的消息！");
		return;
	}
	uploadMessageWindow.show();
	setFormValue(selectData);
}
/*-----删除Message实体函数----*/
/*删除消息*/
function deleteMessage()
{
	var sm = msggridData.getSelectionModel();
	//获取选择的数据消息
	var selectData =  sm.getSelected();
	//如果没有选择，就提示需要选择数据消息
	if(selectData == null){
		Ext.Msg.alert("提示","请选中需要删除的消息！");
		return;
	}
	//删除前再次提醒是否真的要删除
	Ext.Msg.confirm("提示消息","是否真的要删除选择的消息吗？",function callBack(id){
		//判断是否删除数据
		if(id=="yes")
		{
			//页面提交
			Ext.Ajax.request({
				url:'frmSysMessageList.aspx?method=deleteMessage',
				method:'POST',
				params:{
					MessageId:selectData.data.MessageId
				},
				success: function(resp,opts){
					Ext.Msg.alert("提示","数据删除成功");
					msggridData.getStore().reload();
				},
				failure: function(resp,opts){
					Ext.Msg.alert("提示","数据删除失败");
				}
			});
		}
	});
}
/*------开始查询form的函数 start---------------*/
var msgNAMEPanel = new Ext.form.TextField({
    style: 'margin-left:0px',
    cls: 'key',
    xtype: 'textfield',
    fieldLabel: '消息标题',
    name: 'msgNameField',
    id: 'msgNameField',
    anchor: '90%',
    listeners: { specialkey: function(f, e) { if (e.getKey() == e.ENTER) { Ext.getCmp('searchebtnId').focus(); } } }
});

var serchform = new Ext.FormPanel({
    renderTo: 'searchForm',
    labelAlign: 'left',
    layout: 'fit',
    buttonAlign: 'right',
    bodyStyle: 'padding:5px',
    frame: true,
    labelWidth: 55,
    items: [{
        layout: 'column',   //定义该元素为布局为列布局方式
        border: false,
        items: [{
            columnWidth: .3,
            layout: 'form',
            border: false,
            items: [
                msgNAMEPanel
                ]
        },{
            columnWidth: .1,
            layout: 'form',
            border: false,
            items: [{ cls: 'key',
                xtype: 'button',
                text: '查询',
                id: 'searchebtnId',
                anchor: '90%',
                handler: function() {
                    var msgName = msgNAMEPanel.getValue();

                    dsMsggridData.baseParams.Title = msgName;
                    dsMsggridData.baseParams.start = 0;
                    dsMsggridData.baseParams.limit = 10;
                    dsMsggridData.load();
                }
            }]
        }]
    }]
});


/*------开始查询form的函数 end---------------*/
var selectOrgIds = orgId;
var ArriveOrgText = new Ext.form.TextField({
    fieldLabel: '公司',
    id: 'orgSelect',
    value: orgName,
    anchor: '98%',
    style: 'margin-left:0px',
    disabled: false,
    eiditable:false
});
 
/*------实现FormPanle的函数 start---------------*/
var msgForm=new Ext.form.FormPanel({
	url:'',
	frame:true,
	title:'',
	labelWidth:55,
	items:[
	{
	    layout:'form',
        border: false,
        labelWidth: 55,
        columnWidth:1,
        items: [
		{
			xtype:'hidden',
			fieldLabel:'消息ID',
			name:'MessageId',
			id:'MessageId',
			hidden:true,
			hideLabel:true
		},		
		{
			xtype:'textfield',
			fieldLabel:'消息标题',
			columnWidth:1,
			anchor:'98%',
			name:'Title',
			id:'Title'
		}]
	},		
	{
	    layout:'form',
        border: false,
        labelWidth: 55,
        columnWidth:1,
        items: [
		{
			//xtype:'htmleditor',
			xtype:'starthtmleditor',
			fieldLabel:'消息内容',
			defaultLinkValue:"http://122.224.134.21//upload_files//message_file//",
			columnWidth:1,
			height:200,
			anchor:'98%',
			name:'Message',
			id:'Message'
		}]
	},
	{
	    layout:'form',
        border: false,
        labelWidth: 55,
        columnWidth:1,
        items: [
		{
	        layout:'column',
            border: false,
            items: [
            {
	                layout:'form',
	                border: false,
	                labelWidth: 55,
	                columnWidth:0.45,
	                items: [
		                ArriveOrgText
		            ]
		        }, {
                    layout: 'form',
                    columnWidth: .04,  //该列占用的宽度，标识为20％
                    border: false,
                    items: [
                   {
                       xtype: 'button',
                       iconCls: "find",
                       autoWidth: true,
                       autoHeight: true,
                       hideLabel: true,
                       listeners: {
                           click: function(v) {
                               selectOrgType();
                           }
                       }
                    }]
                },		
                {
                    layout:'form',
                    border: false,
	                labelWidth: 55,
	                columnWidth:0.5,
                    items: [
	                {
			            xtype:'datefield',
			            fieldLabel:'有效期限',
			            columnWidth:1,
			            anchor:'98%',
			            name:'ExpirationDate',
			            id:'ExpirationDate',
		                format:'Y年m月d日',
		                value:new Date(2099,11,31).clearTime()
		            }]
		        }]
		    }]
		},		
		{
            layout:'form',
            border: false,
            labelWidth: 55,
            columnWidth:1,
            items: [
            {
			    xtype:'textarea',
			    fieldLabel:'备注',
			    columnWidth:1,
			    anchor:'98%',
			    name:'Remark',
			    id:'Remark'
			}]
		}
]
});
/*------FormPanle的函数结束 End---------------*/

/*------开始界面数据的窗体 Start---------------*/
if(typeof(uploadMessageWindow)=="undefined"){//解决创建2个windows问题
	uploadMessageWindow = new Ext.Window({
		id:'Messageformwindow',
		title:'系统公告维护'
		, iconCls: 'upload-win'
		, width: 650
		, height: 420
		, layout: 'fit'
		, plain: true
		, modal: true
		, constrain:true
		, resizable: false
		, closeAction: 'hide'
		,autoDestroy :true
		,items:msgForm
		,buttons: [{
			text: "保存"
			, handler: function() {
				saveUserData();
			}
			, scope: this
		},
		{
			text: "取消"
			, handler: function() { 
				uploadMessageWindow.hide();
			}
			, scope: this
		}]});
	}
	uploadMessageWindow.addListener("hide",function(){
	msgForm.getForm().reset();
});

/*------开始获取界面数据的函数 start---------------*/
function saveUserData()
{       
    Ext.MessageBox.wait("数据正在处理，请稍候……");
	Ext.Ajax.request({
		url:'frmSysMessage.aspx?method='+saveType,
		method:'POST',
		params:{
			MessageId:Ext.getCmp('MessageId').getValue(),
			Title:Ext.getCmp('Title').getValue(),
			Message:Ext.util.Format.htmlEncode(Ext.getCmp('Message').getValue()),
			ExpirationDate:Ext.util.Format.date(Ext.getCmp('ExpirationDate').getValue(),'Y/m/d'),
			Remark:Ext.getCmp('Remark').getValue(),
			ReceivingOrg:selectOrgIds		},
		success: function(resp,opts){
			 Ext.MessageBox.hide();
            if( checkExtMessage(resp) )
            {
                msggridData.getStore().reload();
            }			
		},
		failure: function(resp,opts){
			Ext.Msg.alert("提示","保存失败");
			Ext.MessageBox.hide();
		}
		});
		}
/*------结束获取界面数据的函数 End---------------*/

/*------开始界面数据的函数 Start---------------*/
function setFormValue(selectData)
{
	Ext.Ajax.request({
		url:'frmSysMessage.aspx?method=getMessage',
		params:{
			MessageId:selectData.data.MessageId
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

/*------开始获取数据的函数 start---------------*/
var dsMsggridData = new Ext.data.Store
({
url: 'frmSysMessage.aspx?method=getMessageList',
reader:new Ext.data.JsonReader({
	totalProperty:'totalProperty',
	root:'root'
},[
	{		name:'MessageId'	},
	{		name:'Title'	},
	{		name:'DeleteFlg'	},
	{		name:'ExpirationDate'	},
	{		name:'Remark'	
	}	])
	,
	listeners:
	{
		scope:this,
		load:function(){
		}
	}
});

/*------获取数据的函数 结束 End---------------*/

/*------开始DataGrid的函数 start---------------*/

var sm= new Ext.grid.CheckboxSelectionModel({
	singleSelect:true
});
var msggridData = new Ext.grid.GridPanel({
	el: 'datagrid',
	width:'100%',
	height:'100%',
	autoWidth:true,
	autoHeight:true,
	autoScroll:true,
	layout: 'fit',
	id: '',
	store: dsMsggridData,
	loadMask: {msg:'正在加载数据，请稍侯……'},
	sm:sm,
	cm: new Ext.grid.ColumnModel([
		sm,
		new Ext.grid.RowNumberer(),
		{
            header: '消息编号',
            width: 20,
            dataIndex: 'MessageId',
            id: 'MessageId'
        },
        {
            header: '消息标题',
            width: 30,
            dataIndex: 'Title',
            id: 'Title'
        },
        {
            header: '失效日期',
            width: 20,
            dataIndex: 'ExpirationDate',
            id: 'ExpirationDate'
        },
        {
            header: '是否删除',
            width: 10,
            dataIndex: 'DeleteFlg',
            id: 'DeleteFlg',
            renderer:function(v){if(v==0)return '正常';else return '删除';}
        },
        {
            header: '备注',
            width: 40,
            dataIndex: 'Remark',
            id: 'Remark'	
        }	
		]),
		bbar: new Ext.PagingToolbar({
			pageSize: 10,
			store: dsMsggridData,
			displayMsg: '显示第{0}条到{1}条记录,共{2}条',
			emptyMsy: '没有记录',
			displayInfo: true
		}),
		viewConfig: {
			columnsText: '显示的列',
			scrollOffset: 20,
			sortAscText: '升序',
			sortDescText: '降序',
			forceFit: true
		},
		height: 280,
		closeAction: 'hide',
		stripeRows: true,
		loadMask: true,
		autoExpandColumn: 2
	});
msggridData.render();
/*------DataGrid的函数结束 End---------------*/

/**************公司信息选择 **************************/
    function selectOrgType() {
 
        if (selectOrgForm == null) {
            var showType = "getcurrentandchildrentree";
            if (orgId == 1) {
                showType = "getcurrentAndChildrenTreeByArea";
            }
            showOrgForm("", "", "../sysadmin/frmAdmOrgList.aspx?method=" + showType);
            selectOrgForm.buttons[0].on("click", selectOrgOk);
            if (orgId == 1) {
                selectOrgTree.on('checkchange', treeCheckChange, selectOrgTree);
            }
        }
        else {
            showOrgForm("", "", "");
        }
    }
    function selectOrgOk() {
        var selectOrgNames = "";
        selectOrgIds = "";
        var selectNodes = selectOrgTree.getChecked();
        for (var i = 0; i < selectNodes.length; i++) {
            if (selectNodes[i].id.indexOf("A") != -1)
                continue;
            if (selectOrgNames != "") {
                selectOrgNames += ",";
                selectOrgIds += ",";
            }
            selectOrgIds += selectNodes[i].id;
            selectOrgNames += selectNodes[i].text;
        }
        ArriveOrgText.setValue(selectOrgNames);
       // dsWareHouse.load({ params: { OrgId: selectOrgIds, ForBusi: 1} });
    }
   // dsWareHouse.load({ params: { OrgId: selectOrgIds, ForBusi: 1} });
 
 
    function treeCheckChange(node, checked) {
        node.expand();
        node.attributes.checked = checked;
        node.eachChild(function(child) {
            child.ui.toggleCheck(checked);
            child.attributes.checked = checked;
            child.fireEvent('checkchange', child, checked);
        });
        selectOrgTree.un('checkchange', treeCheckChange, selectOrgTree);
        checkParentNode(node);
        selectOrgTree.on('checkchange', treeCheckChange, selectOrgTree);
    }
    function checkParentNode(currentNode) {
        if (currentNode.parentNode != null) {
            var tempNode = currentNode.parentNode;
            //如果是跟节点，就不做处理了
            if (tempNode.parentNode == null)
                return;
            //如果是选择了，那么父节点也必须是出于选择状态的
            if (currentNode.attributes.checked) {
                if (!tempNode.attributes.checked) {
                    tempNode.fireEvent('checkchange', tempNode, true);
                    tempNode.ui.toggleCheck(true);
                    tempNode.attributes.checked = true;
 
                }
            }
            //取消选择
            else {
                var tempCheck = false;
                tempNode.eachChild(function(child) {
                    if (child.attributes.checked) {
                        tempCheck = true;
                        return;
                    }
                });
                if (!tempCheck) {
                    tempNode.fireEvent('checkchange', tempNode, false);
                    tempNode.ui.toggleCheck(false);
                    tempNode.attributes.checked = false;
                }
 
            }
            checkParentNode(tempNode);
        }
    }
    function parentNodeChecked(node) {
        if (node.parentNode != null) {
            if (node.attributes.checked) {
                node.parentNode.ui.toggleCheck(checked);
                node.parentNode.attributes.checked = true;
            }
            else {
                for (var i = 0; i < node.parentNode.childNodes.length; i++) {
                    if (node.parentNode.childNodes[i].attributes.checked) {
                        return;
                    }
                }
            }
            parentNodeChecked(node.parentNode);
        }
    }
/****************************************************************/

})
</script>

</html>
