<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmSysMessage.aspx.cs" Inherits="BA_sysadmin_frmSysMessage" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html>
<head>
<title>ϵͳ����ά��</title><meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
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
/*------ʵ��toolbar�ĺ��� start---------------*/
var Toolbar = new Ext.Toolbar({
	renderTo:"toolbar",
	items:[{
		text:"����",
		icon:"../../Theme/1/images/extjs/customer/add16.gif",
		handler:function(){
		    saveType ='addMessage';
		    openAddMessageWin();
		}
		},'-',{
		text:"�༭",
		icon:"../../Theme/1/images/extjs/customer/edit16.gif",
		handler:function(){
		    saveType ='saveMessage';
		    modifyMessageWin();
		}
		},'-',{
		text:"ɾ��",
		icon:"../../Theme/1/images/extjs/customer/delete16.gif",
		handler:function(){
		    deleteMessage();
		}
	}]
});

/*------����toolbar�ĺ��� end---------------*/


/*------��ʼToolBar�¼����� start---------------*//*-----����Messageʵ���ര�庯��----*/
function openAddMessageWin() {
	uploadMessageWindow.show();
}
/*-----�༭Messageʵ���ര�庯��----*/
function modifyMessageWin() {
	var sm = msggridData.getSelectionModel();
	//��ȡѡ���������Ϣ
	var selectData =  sm.getSelected();
	if(selectData == null){
		Ext.Msg.alert("��ʾ","��ѡ����Ҫ�༭����Ϣ��");
		return;
	}
	uploadMessageWindow.show();
	setFormValue(selectData);
}
/*-----ɾ��Messageʵ�庯��----*/
/*ɾ����Ϣ*/
function deleteMessage()
{
	var sm = msggridData.getSelectionModel();
	//��ȡѡ���������Ϣ
	var selectData =  sm.getSelected();
	//���û��ѡ�񣬾���ʾ��Ҫѡ��������Ϣ
	if(selectData == null){
		Ext.Msg.alert("��ʾ","��ѡ����Ҫɾ������Ϣ��");
		return;
	}
	//ɾ��ǰ�ٴ������Ƿ����Ҫɾ��
	Ext.Msg.confirm("��ʾ��Ϣ","�Ƿ����Ҫɾ��ѡ�����Ϣ��",function callBack(id){
		//�ж��Ƿ�ɾ������
		if(id=="yes")
		{
			//ҳ���ύ
			Ext.Ajax.request({
				url:'frmSysMessageList.aspx?method=deleteMessage',
				method:'POST',
				params:{
					MessageId:selectData.data.MessageId
				},
				success: function(resp,opts){
					Ext.Msg.alert("��ʾ","����ɾ���ɹ�");
					msggridData.getStore().reload();
				},
				failure: function(resp,opts){
					Ext.Msg.alert("��ʾ","����ɾ��ʧ��");
				}
			});
		}
	});
}
/*------��ʼ��ѯform�ĺ��� start---------------*/
var msgNAMEPanel = new Ext.form.TextField({
    style: 'margin-left:0px',
    cls: 'key',
    xtype: 'textfield',
    fieldLabel: '��Ϣ����',
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
        layout: 'column',   //�����Ԫ��Ϊ����Ϊ�в��ַ�ʽ
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
                text: '��ѯ',
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


/*------��ʼ��ѯform�ĺ��� end---------------*/
var selectOrgIds = orgId;
var ArriveOrgText = new Ext.form.TextField({
    fieldLabel: '��˾',
    id: 'orgSelect',
    value: orgName,
    anchor: '98%',
    style: 'margin-left:0px',
    disabled: false,
    eiditable:false
});
 
/*------ʵ��FormPanle�ĺ��� start---------------*/
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
			fieldLabel:'��ϢID',
			name:'MessageId',
			id:'MessageId',
			hidden:true,
			hideLabel:true
		},		
		{
			xtype:'textfield',
			fieldLabel:'��Ϣ����',
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
			fieldLabel:'��Ϣ����',
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
                    columnWidth: .04,  //����ռ�õĿ�ȣ���ʶΪ20��
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
			            fieldLabel:'��Ч����',
			            columnWidth:1,
			            anchor:'98%',
			            name:'ExpirationDate',
			            id:'ExpirationDate',
		                format:'Y��m��d��',
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
			    fieldLabel:'��ע',
			    columnWidth:1,
			    anchor:'98%',
			    name:'Remark',
			    id:'Remark'
			}]
		}
]
});
/*------FormPanle�ĺ������� End---------------*/

/*------��ʼ�������ݵĴ��� Start---------------*/
if(typeof(uploadMessageWindow)=="undefined"){//�������2��windows����
	uploadMessageWindow = new Ext.Window({
		id:'Messageformwindow',
		title:'ϵͳ����ά��'
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
			text: "����"
			, handler: function() {
				saveUserData();
			}
			, scope: this
		},
		{
			text: "ȡ��"
			, handler: function() { 
				uploadMessageWindow.hide();
			}
			, scope: this
		}]});
	}
	uploadMessageWindow.addListener("hide",function(){
	msgForm.getForm().reset();
});

/*------��ʼ��ȡ�������ݵĺ��� start---------------*/
function saveUserData()
{       
    Ext.MessageBox.wait("�������ڴ������Ժ򡭡�");
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
			Ext.Msg.alert("��ʾ","����ʧ��");
			Ext.MessageBox.hide();
		}
		});
		}
/*------������ȡ�������ݵĺ��� End---------------*/

/*------��ʼ�������ݵĺ��� Start---------------*/
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
		Ext.Msg.alert("��ʾ","��ȡ��Ϣ��Ϣʧ��");
	}
	});
}
/*------�������ý������ݵĺ��� End---------------*/

/*------��ʼ��ȡ���ݵĺ��� start---------------*/
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

/*------��ȡ���ݵĺ��� ���� End---------------*/

/*------��ʼDataGrid�ĺ��� start---------------*/

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
	loadMask: {msg:'���ڼ������ݣ����Ժ��'},
	sm:sm,
	cm: new Ext.grid.ColumnModel([
		sm,
		new Ext.grid.RowNumberer(),
		{
            header: '��Ϣ���',
            width: 20,
            dataIndex: 'MessageId',
            id: 'MessageId'
        },
        {
            header: '��Ϣ����',
            width: 30,
            dataIndex: 'Title',
            id: 'Title'
        },
        {
            header: 'ʧЧ����',
            width: 20,
            dataIndex: 'ExpirationDate',
            id: 'ExpirationDate'
        },
        {
            header: '�Ƿ�ɾ��',
            width: 10,
            dataIndex: 'DeleteFlg',
            id: 'DeleteFlg',
            renderer:function(v){if(v==0)return '����';else return 'ɾ��';}
        },
        {
            header: '��ע',
            width: 40,
            dataIndex: 'Remark',
            id: 'Remark'	
        }	
		]),
		bbar: new Ext.PagingToolbar({
			pageSize: 10,
			store: dsMsggridData,
			displayMsg: '��ʾ��{0}����{1}����¼,��{2}��',
			emptyMsy: 'û�м�¼',
			displayInfo: true
		}),
		viewConfig: {
			columnsText: '��ʾ����',
			scrollOffset: 20,
			sortAscText: '����',
			sortDescText: '����',
			forceFit: true
		},
		height: 280,
		closeAction: 'hide',
		stripeRows: true,
		loadMask: true,
		autoExpandColumn: 2
	});
msggridData.render();
/*------DataGrid�ĺ������� End---------------*/

/**************��˾��Ϣѡ�� **************************/
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
            //����Ǹ��ڵ㣬�Ͳ���������
            if (tempNode.parentNode == null)
                return;
            //�����ѡ���ˣ���ô���ڵ�Ҳ�����ǳ���ѡ��״̬��
            if (currentNode.attributes.checked) {
                if (!tempNode.attributes.checked) {
                    tempNode.fireEvent('checkchange', tempNode, true);
                    tempNode.ui.toggleCheck(true);
                    tempNode.attributes.checked = true;
 
                }
            }
            //ȡ��ѡ��
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
