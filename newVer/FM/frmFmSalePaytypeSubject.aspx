<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmFmSalePaytypeSubject.aspx.cs" Inherits="FM_frmFmSalePaytypeSubject" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html>
<head>
<title>����ҳ��</title><meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<link rel="stylesheet" type="text/css" href="../ext3/resources/css/ext-all.css" />
<script type="text/javascript" src="../ext3/adapter/ext/ext-base.js"></script>
<script type="text/javascript" src="../ext3/ext-all.js"></script>
</head>
<body>
<div id='toolbar'></div>
<div id='searchForm'></div>
<div id='dataGrid'></div>

</body>

<%= getComboBoxStore() %>

<script type="text/javascript">
Ext.BLANK_IMAGE_URL = "../ext3/resources/images/default/s.gif";
Ext.onReady(function(){
var saveType;
/*------ʵ��toolbar�ĺ��� start---------------*/
var Toolbar = new Ext.Toolbar({
	renderTo:"toolbar",
	items:[{
		text:"����",
		icon:"../Theme/1/images/extjs/customer/add16.gif",
		handler:function(){
		    saveType = 'add';
		    openAddSubjectWin();
		}
		},'-',{
		text:"�༭",
		icon:"../Theme/1/images/extjs/customer/edit16.gif",
		handler:function(){
		    saveType = 'save';
		    modifySubjectWin();
		}
		},'-',{
		text:"ɾ��",
		icon:"../Theme/1/images/extjs/customer/delete16.gif",
		handler:function(){
		    deleteSubject();
		}
	}]
});

/*------����toolbar�ĺ��� end---------------*/


/*------��ʼToolBar�¼����� start---------------*//*-----����Subjectʵ���ര�庯��----*/
function openAddSubjectWin() {
	uploadSubjectWindow.show();
}
/*-----�༭Subjectʵ���ര�庯��----*/
function modifySubjectWin() {
	var sm = dataGrid.getSelectionModel();
	//��ȡѡ���������Ϣ
	var selectData =  sm.getSelected();
	if(selectData == null){
		Ext.Msg.alert("��ʾ","��ѡ����Ҫ�༭����Ϣ��");
		return;
	}
	uploadSubjectWindow.show();
	setFormValue(selectData.data.SubjectId);
}
/*-----ɾ��Subjectʵ�庯��----*/
/*ɾ����Ϣ*/
function deleteSubject()
{
	var sm = dataGrid.getSelectionModel();
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
				url:'frmFmSalePaytypeSubject.aspx?method=deleteSubject',
				method:'POST',
				params:{
					SubjectId:selectData.data.SubjectId
				},
				success: function(resp,opts){
					Ext.Msg.alert("��ʾ","����ɾ���ɹ�");
				},
				failure: function(resp,opts){
					Ext.Msg.alert("��ʾ","����ɾ��ʧ��");
				}
			});
		}
	});
}

/*------ʵ��FormPanle�ĺ��� start---------------*/
var subjectForm =new Ext.form.FormPanel({
	url:'',
	frame:true,
	title:'',
	items:[
		{
			xtype:'hidden',
			fieldLabel:'��Ŀ�������',
			columnWidth:1,
			anchor:'90%',
			name:'SubjectId',
			id:'SubjectId',
			hidden:true,
			hideLabel:true
		}
,		{
			xtype:'combo',
			fieldLabel:'�տʽ',
			columnWidth:1,
			anchor:'90%',
			name:'PaytypeCode',
			id:'PaytypeCode',
			store:dsSalePayType,
			displayField:'DicsName',
			valueField:'DicsCode',
			mode:'local',
			editable:false,
			triggerAction:'all'
		}
,		{
			xtype:'textfield',
			fieldLabel:'��Ŀ�������',
			columnWidth:1,
			anchor:'90%',
			name:'SubjectCode',
			id:'SubjectCode'
		}
,		{
			xtype:'combo',
			fieldLabel:'��������',//��ӦFM_BANK_ACCOUNT.BANK_ID,
			columnWidth:1,
			anchor:'90%',
			name:'BankId',
			id:'BankId',
			store:dsBank,
			displayField:'BankName',
			valueField:'BankId',
			mode:'local',
			editable:false,
			triggerAction:'all'
		}
]
});
/*------FormPanle�ĺ������� End---------------*/

/*------��ʼ�������ݵĴ��� Start---------------*/
if(typeof(uploadSubjectWindow)=="undefined"){//�������2��windows����
	uploadSubjectWindow = new Ext.Window({
		id:'Subjectformwindow',
		title:'�տʽ���Ŀ�����Ӧ��ϵά��'
		, iconCls: 'upload-win'
		, width: 400
		, height: 200
		, layout: 'fit'
		, plain: true
		, modal: true
		, constrain:true
		, resizable: false
		, closeAction: 'hide'
		,autoDestroy :true
		,items:subjectForm
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
				uploadSubjectWindow.hide();
			}
			, scope: this
		}]});
	}
	uploadSubjectWindow.addListener("hide",function(){
});

/*------��ʼ��ȡ�������ݵĺ��� start---------------*/
function saveUserData()
{
    if(saveType=='add')
        saveType='addSalePaytype';
    else if (saveType = 'save')
        saveType = 'saveSalePaytype';
        
	Ext.Ajax.request({
		url:'frmFmSalePaytypeSubject.aspx?method='+saveType,
		method:'POST',
		params:{
			SubjectId:Ext.getCmp('SubjectId').getValue(),
			PaytypeCode:Ext.getCmp('PaytypeCode').getValue(),
			SubjectCode:Ext.getCmp('SubjectCode').getValue(),
			BankId:Ext.getCmp('BankId').getValue()
			},
		success: function(resp,opts){
			Ext.Msg.alert("��ʾ","����ɹ�");
			dataGrid.getStore().reload();
			uploadSubjectWindow.hide();
		},
		failure: function(resp,opts){
			Ext.Msg.alert("��ʾ","����ʧ��");
		}
		});
		}
/*------������ȡ�������ݵĺ��� End---------------*/

/*------��ʼ�������ݵĺ��� Start---------------*/
function setFormValue(selectData)
{
	Ext.Ajax.request({
		url:'frmFmSalePaytypeSubject.aspx?method=getSubject',
		params:{
			SubjectId:selectData.data.SubjectId
		},
	success: function(resp,opts){
		var data=Ext.util.JSON.decode(resp.responseText);
		Ext.getCmp("SubjectId").setValue(data.SubjectId);
		Ext.getCmp("PaytypeCode").setValue(data.PaytypeCode);
		Ext.getCmp("SubjectCode").setValue(data.SubjectCode);
		Ext.getCmp("BankId").setValue(data.BankId);
	},
	failure: function(resp,opts){
		Ext.Msg.alert("��ʾ","��ȡ�û���Ϣʧ��");
	}
	});
}
/*------�������ý������ݵĺ��� End---------------*/

/*------��ʼ��ȡ���ݵĺ��� start---------------*/
var dsgridData = new Ext.data.Store
({
url: 'frmFmSalePaytypeSubject.aspx?method=getSubjectList',
reader:new Ext.data.JsonReader({
	totalProperty:'totalProperty',
	root:'root'
},[
	{
		name:'SubjectId'
	},
	{
		name:'PaytypeCode'
	},
	{
		name:'PaytypeName'
	},
	{
		name:'SubjectCode'
	},
	{
		name:'SubjectName'
	},
	{
		name:'BankId'
	},
	{
		name:'BankName'
	},
	{
		name:'CreateDate'
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
var gridData = new Ext.grid.GridPanel({
	el: 'dataGrid',
	width:'100%',
	height:'100%',
	autoWidth:true,
	autoHeight:true,
	autoScroll:true,
	layout: 'fit',
	id: '',
	store: dsgridData,
	loadMask: {msg:'���ڼ������ݣ����Ժ��'},
	sm:sm,
	cm: new Ext.grid.ColumnModel([
		sm,
		new Ext.grid.RowNumberer(),//�Զ��к�
		{
			header:'��Ŀ�������',
			dataIndex:'SubjectId',
			id:'SubjectId',
			hidden:true,
			hideable:false
		},
		{
			header:'�տʽ',
			dataIndex:'PaytypeCode',
			id:'PaytypeCode'
		},
		{   
		    header:'�տʽע��',
		    dataIndex:'PaytypeName',
		    id:'PaytypeName'
		},
		{
			header:'��Ŀ�������',
			dataIndex:'SubjectCode',
			id:'SubjectCode'
		},		
		{
			header:'��Ŀ��������',
			dataIndex:'SubjectName',
			id:'SubjectName'
		},
		{
			header:'��������',//��ӦFM_BANK_ACCOUNT.BANK_ID
			dataIndex:'BankId',
			id:'BankId',
			hidden:true,
			hideable:false
		},
		{
			header:'��������',
			dataIndex:'BankName',
			id:'BankName'
		},
		{
			header:'����ʱ��',
			dataIndex:'CreateDate',
			id:'CreateDate',
			renderer: Ext.util.Format.dateRenderer('Y��m��d��')
		}		]),
		bbar: new Ext.PagingToolbar({
			pageSize: 10,
			store: dsgridData,
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
gridData.render();

//ҳ�����ͼ���
dsgridData.load({
    params : {
    start : 0,
    limit : 10
    } 
});
/*------DataGrid�ĺ������� End---------------*/



})
</script>
</html>
