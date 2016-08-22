<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmWmsProductCostAlgConf.aspx.cs" Inherits="WMS_frmWmsProductCostAlgConf" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html>
<head>
<title>�ֿ���Ʒ�ɱ��㷨���� </title><meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<link rel="stylesheet" type="text/css" href="../ext3/resources/css/ext-all.css" />
<script type="text/javascript" src="../ext3/adapter/ext/ext-base.js"></script>
<script type="text/javascript" src="../ext3/ext-all.js"></script>
<script type="text/javascript" src="../js/operateResp.js"></script>
</head>

<body>
<div id='toolbar'></div>
<div id='divForm'></div>
<div id='dataGrid'></div>

</body>

<%= getComboBoxStore() %>

<script type="text/javascript">
    Ext.BLANK_IMAGE_URL = "../ext3/resources/images/default/s.gif";
Ext.onReady(function(){
/*------ʵ��toolbar�ĺ��� start---------------*/
var Toolbar = new Ext.Toolbar({
	renderTo:"toolbar",
	items:[{
		text:"����",
		icon:"../Theme/1/images/extjs/customer/add16.gif",
		handler:function(){
		    openAddConfWin();
		}
		},'-',{
		text:"�༭",
		icon:"../Theme/1/images/extjs/customer/edit16.gif",
		handler:function(){
		    modifyConfWin();
		}
		},'-',{
		text:"ɾ��",
		icon:"../Theme/1/images/extjs/customer/delete16.gif",
		handler:function(){
		    deleteConf();
		}
	}]
});

/*------����toolbar�ĺ��� end---------------*/


/*------��ʼToolBar�¼����� start---------------*//*-----����Confʵ���ര�庯��----*/
function openAddConfWin() {
    Ext.getCmp("ProductName").setDisabled(false);
    Ext.getCmp("WhId").setDisabled(false);
	uploadConfWindow.show();
}
/*-----�༭Confʵ���ര�庯��----*/
function modifyConfWin() {
	var sm = gridData.getSelectionModel();
	//��ȡѡ���������Ϣ
	var selectData =  sm.getSelected();
	if(selectData == null){
		Ext.Msg.alert("��ʾ","��ѡ����Ҫ�༭����Ϣ��");
		return;
	}
	Ext.getCmp("ProductName").setDisabled(true);
	Ext.getCmp("WhId").setDisabled(true);
	uploadConfWindow.show();
	setFormValue(selectData);
}
/*-----ɾ��Confʵ�庯��----*/
/*ɾ����Ϣ*/
function deleteConf()
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
				url:'frmWmsProductCostAlgConf.aspx?method=deleteConf',
				method:'POST',
				params:{
					Id:selectData.data.Id
				},
				success: function(resp,opts){
				    if (checkExtMessage(resp)) {
				        updateDataGrid();
				    }
				}
			});
		}
	});
}

/*------ʵ��FormPanle�ĺ��� start---------------*/
/*------������Ʒ������ start ----------*/
    
var AlgConfForm=new Ext.form.FormPanel({
	url:'',
	//renderTo:'divForm',
	frame:true,
	title:'',
	items:[
		{
			xtype:'textfield',
			fieldLabel:'��ˮID',
			columnWidth:1,
			anchor:'90%',
			name:'Id',
			id:'Id',
			hidden:true,
			hideLabel:true
		}
,		{
			xtype:'combo',
			fieldLabel:'�ֿ�',
			columnWidth:1,
			anchor:'90%',
			name:'WhId',
			id:'WhId',
			store:dsWh,
			displayField:'WhName',
			valueField:'WhId',
			mode:'local',
			triggerAction:'all',
			editable:false
		}
,		{
			xtype:'textfield',
			fieldLabel:'��ƷID',
			columnWidth:1,
			anchor:'90%',
			name:'ProductId',
			id:'ProductId',
			hidden:true,
			hideLabel:true
		}
,		{
			xtype:'combo',
			fieldLabel:'��Ʒ',
			columnWidth:1,
			anchor:'90%',
			name:'ProductName',
			id:'ProductName',
			store:dsProductList,
			pageSize: 5,  
            minChars: 0,  
            hideTrigger: true,  
            typeAhead: true,  
            mode: 'local',      
            emptyText: '��ѡ����Ʒ',   
            selectOnFocus: false,
            editable: true,
            displayField:'ProductName',
            valueField:'ProductId',
            listeners:{ 
            "select":function(combo, record, index){ 
                Ext.getCmp("ProductId").setValue(record.data.ProductId);
                this.collapse();
             }
            }              
		}
,		{
			xtype:'combo',
			fieldLabel:'�ɱ��㷨',
			columnWidth:1,
			anchor:'90%',
			name:'AlgorithmId',
			id:'AlgorithmId',
			store:dsFormula,
			displayField:'AlgorithmName',
			valueField:'AlgorithmId',
			mode:'local',
			triggerAction:'all',
			editable:false
		}
]
});
/*------FormPanle�ĺ������� End---------------*/

/*------��ʼ�������ݵĴ��� Start---------------*/
if(typeof(uploadConfWindow)=="undefined"){//�������2��windows����
	uploadConfWindow = new Ext.Window({
		id:'Confformwindow',
		title:'�ֿ���Ʒ�ɱ��㷨����'
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
		,items:AlgConfForm
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
				uploadConfWindow.hide();
			}
			, scope: this
		}]});
	}
	uploadConfWindow.addListener("hide",function(){
	    AlgConfForm.getForm().reset();
	    updateDataGrid();
    });

/*------��ʼ��ȡ�������ݵĺ��� start---------------*/
function saveUserData()
{
	Ext.Ajax.request({
	    url: 'frmWmsProductCostAlgConf.aspx?method=saveAlgConf',
		method:'POST',
		params:{
			Id:Ext.getCmp('Id').getValue(),
			WhId:Ext.getCmp('WhId').getValue(),
			ProductId:Ext.getCmp('ProductId').getValue(),
			AlgorithmId:Ext.getCmp('AlgorithmId').getValue()
		},
		success: function(resp,opts){			
			if (checkExtMessage(resp)) {
			    uploadConfWindow.hide();
            }
		}
	});
}

/*------������ȡ�������ݵĺ��� End---------------*/

/*------��ʼ�������ݵĺ��� Start---------------*/
function setFormValue(selectData)
{
	Ext.Ajax.request({
		url:'frmWmsProductCostAlgConf.aspx?method=getAlgConf',
		params:{
			Id:selectData.data.Id
		},
	    success: function(resp,opts){
		    var data=Ext.util.JSON.decode(resp.responseText);
		    Ext.getCmp("Id").setValue(data.Id);
		    Ext.getCmp("WhId").setValue(data.WhId);
		    Ext.getCmp("ProductId").setValue(data.ProductId);
		    Ext.getCmp("ProductName").setValue(data.ProductName);
		    Ext.getCmp("AlgorithmId").setValue(data.AlgorithmId);
	    },
	    failure: function(resp,opts){
		    Ext.Msg.alert("��ʾ","��ȡ��Ʒ�㷨������Ϣʧ�ܣ�");
	    }
	});
}
/*------�������ý������ݵĺ��� End---------------*/

/*------��ʼ��ȡ���ݵĺ��� start---------------*/
var dsAlgConf = new Ext.data.Store
({
url: 'frmWmsProductCostAlgConf.aspx?method=getAlgConfList',
reader:new Ext.data.JsonReader({
	totalProperty:'totalProperty',
	root:'root'
},[
	{
		name:'Id'
	},
	{
		name:'OrgId'
	},
	{
		name:'WhName'
	},
	{
		name:'ProductId'
	},
	{
		name:'ProductName'
	},
	{
		name:'AlgorithmName'
	},
	{
		name:'OperId'
	},
	{
		name:'OwnerId'
	},
	{
		name:'CreateDate'
	},
	{
		name:'UpdateDate'
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
	store: dsAlgConf,
	loadMask: {msg:'���ڼ������ݣ����Ժ��'},
	sm:sm,
	cm: new Ext.grid.ColumnModel([
		sm,
		new Ext.grid.RowNumberer(),//�Զ��к�
		{
			header:'��ˮID',
			dataIndex:'Id',
			id:'Id',
			hidden:true,
			hideable:false
		},
		{
			header:'�ֿ�',
			dataIndex:'WhName',
			id:'WhName'
		},
		{
			header:'��Ʒ',
			dataIndex:'ProductName',
			id:'ProductName',
			renderer: function(value, cellmeta, record, rowIndex, columnIndex, store) { 
			    if(record.get('ProductId')<=0) return '������Ʒ';
			}
		},
		{
			header:'�ɱ��㷨',
			dataIndex:'AlgorithmName',
			id:'AlgorithmName'
		}		]),
		bbar: new Ext.PagingToolbar({
			pageSize: 10,
			store: dsAlgConf,
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

function updateDataGrid(){
    dsAlgConf.load({params:{limit:10,start:0}});
}
/*------DataGrid�ĺ������� End---------------*/
updateDataGrid();


})
</script>

</html>
