<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmFmAccPayCfg.aspx.cs" Inherits="FM_frmFmAccPayCfg" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html>
<head>
<title>Ӧ��������ָ������</title><meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<link rel="stylesheet" type="text/css" href="../ext3/resources/css/ext-all.css" />
<script type="text/javascript" src="../ext3/adapter/ext/ext-base.js"></script>
<script type="text/javascript" src="../ext3/ext-all.js"></script>
<script type="text/javascript" src="../js/operateResp.js"></script>
<script type="text/javascript" src="../ext3/src/locale/ext-lang-zh_CN.js"></script>
</head>
<body>
<div id='toolbar'></div>
<div id='divForm'></div>
<div id='dataGrid'></div>
<%=getComboBoxStore()%>
</body>
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
		  saveType='addCfg';
		    openAddCfgWin();
		}
		},'-',{
		text:"�༭",
		icon:"../Theme/1/images/extjs/customer/edit16.gif",
		handler:function(){
		    saveType = 'saveCfg';
		    modifyCfgWin();
		}
		},'-',{
		text:"ɾ��",
		icon:"../Theme/1/images/extjs/customer/delete16.gif",
		handler:function(){
		    deleteCfg();
		}
	}]
});

/*------����toolbar�ĺ��� end---------------*/


/*------��ʼToolBar�¼����� start---------------*//*-----����Cfgʵ���ര�庯��----*/
function openAddCfgWin() {
	uploadCfgWindow.show();
}
/*-----�༭Cfgʵ���ര�庯��----*/
function modifyCfgWin() {
	var sm = gridData.getSelectionModel();
	//��ȡѡ���������Ϣ
	var selectData =  sm.getSelected();
	if(selectData == null){
		Ext.Msg.alert("��ʾ","��ѡ����Ҫ�༭����Ϣ��");
		return;
	}
	uploadCfgWindow.show();
	setFormValue(selectData);
}
/*-----ɾ��Cfgʵ�庯��----*/
/*ɾ����Ϣ*/
function deleteCfg()
{
	var sm = gridData.getSelectionModel();
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
				url:'frmFmAccPayCfg.aspx?method=deleteCfg',
				method:'POST',
				params:{
					DoneCode:selectData.data.DoneCode
				},
				success: function(resp,opts){
					Ext.Msg.alert("��ʾ","����ɾ���ɹ�");
					dsGridData.reload();
				},
				failure: function(resp,opts){
					Ext.Msg.alert("��ʾ","����ɾ��ʧ��");
				}
			});
		}
	});
}

/*------ʵ��FormPanle�ĺ��� start---------------*/
var cfgForm=new Ext.form.FormPanel({
	url:'',
	frame:true,
	title:'',
	items:[
		{
			xtype:'hidden',
			fieldLabel:'���',
			name:'DoneCode',
			id:'DoneCode',
			hidden:true,
			hideable:false
		}
,		{
			xtype:'datefield',
			fieldLabel:'��������',
			columnWidth:1,
			anchor:'90%',
			name:'DeadDate',
			id:'DeadDate',
			value: new Date().clearTime(),
			format:'Y��m��d��'			
		}
,		{
			xtype:'numberfield',
			fieldLabel:'���ƽ��',
			columnWidth:1,
			anchor:'90%',
			name:'LimitFund',
			id:'LimitFund'
		}
,		{
			xtype:'combo',
			fieldLabel:'��������',
			columnWidth:1,
			anchor:'90%',
			name:'AlarmInter',
			id:'AlarmInter',
			store:dsAlert,
			displayField:'DicsName',
			valueField:'DicsCode',
			mode:'local',
			triggerAction:'all'
		}
]
});
/*------FormPanle�ĺ������� End---------------*/

/*------��ʼ�������ݵĴ��� Start---------------*/
if(typeof(uploadCfgWindow)=="undefined"){//�������2��windows����
	uploadCfgWindow = new Ext.Window({
		id:'Cfgformwindow',
		title:'ָ������'
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
		,items:cfgForm
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
				uploadCfgWindow.hide();
			}
			, scope: this
		}]});
	}
	uploadCfgWindow.addListener("hide",function(){
});

/*------��ʼ��ȡ�������ݵĺ��� start---------------*/
function saveUserData()
{
	Ext.Ajax.request({
		url:'frmFmAccPayCfg.aspx?method='+saveType,
		method:'POST',
		params:{
			DoneCode:Ext.getCmp('DoneCode').getValue(),
			DeadDate:Ext.util.Format.date(Ext.getCmp('DeadDate').getValue(),'Y/m/d'),
			LimitFund:Ext.getCmp('LimitFund').getValue(),
			AlarmInter:Ext.getCmp('AlarmInter').getValue()
				},
		success: function(resp,opts){
			if( checkExtMessage(resp) ){
			    dsGridData.reload()
			}
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
		url:'frmFmAccPayCfg.aspx?method=getCfg',
		params:{
			DoneCode:selectData.data.DoneCode
		},
	success: function(resp,opts){
		var data=Ext.util.JSON.decode(resp.responseText);
		Ext.getCmp("DoneCode").setValue(data.DoneCode);
		Ext.getCmp("DeadDate").setValue((new Date(data.DeadDate.replace(/-/g,"/"))));
		Ext.getCmp("LimitFund").setValue(data.LimitFund);
		Ext.getCmp("AlarmInter").setValue(data.AlarmInter);
	},
	failure: function(resp,opts){
		Ext.Msg.alert("��ʾ","��ȡ��Ϣʧ��");
	}
	});
}
/*------�������ý������ݵĺ��� End---------------*/

/*------��ʼ��ȡ���ݵĺ��� start---------------*/
var dsGridData = new Ext.data.Store
({
url: 'frmFmAccPayCfg.aspx?method=getCfgList',
reader:new Ext.data.JsonReader({
	totalProperty:'totalProperty',
	root:'root'
},[
	{		name:'DoneCode'	},
	{		name:'DeadDate'	},
	{		name:'LimitFund'	},
	{		name:'AlarmInterText'	},
	{		name:'CrtDate'	},		
	{		name:'Status'	}	
	])
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
	store: dsGridData,
	loadMask: {msg:'���ڼ������ݣ����Ժ��'},
	sm:sm,
	cm: new Ext.grid.ColumnModel([
		sm,
		new Ext.grid.RowNumberer(),//�Զ��к�
		{
			header:'���',
			dataIndex:'DoneCode',
			id:'DoneCode',
			hidden:true,
			hideable:false
		},
		{
			header:'��������',
			dataIndex:'DeadDate',
			id:'DeadDate',
			renderer: Ext.util.Format.dateRenderer('Y��m��d��')
		},
		{
			header:'���ƽ��',
			dataIndex:'LimitFund',
			id:'LimitFund'
		},
		{
			header:'��������',
			dataIndex:'AlarmInterText',
			id:'AlarmInterText'
		},
		{
			header:'״̬',
			dataIndex:'Status',
			id:'Status',
			renderer:function(v){
			    if(v==0) return '��Ч';
			    else return 'ʵЧ';
			}
		},
		{
			header:'����ʱ��',
			dataIndex:'CrtDate',
			id:'CrtDate',
			renderer: Ext.util.Format.dateRenderer('Y��m��d��')
		}
		]),
		bbar: new Ext.PagingToolbar({
			pageSize: 10,
			store: dsGridData,
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
/*------DataGrid�ĺ������� End---------------*/
dsGridData.load({params:{start:0,limit:10}})


})
</script>
</html>
