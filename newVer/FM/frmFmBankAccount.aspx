<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmFmBankAccount.aspx.cs" Inherits="FM_frmFmBankAccount" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html>
<head>
<title>��������ά��</title><meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<link rel="stylesheet" type="text/css" href="../ext3/resources/css/ext-all.css" />
<script type="text/javascript" src="../ext3/adapter/ext/ext-base.js"></script>
<script type="text/javascript" src="../ext3/ext-all.js"></script>
</head>
<body>
<div id='toolbar'></div>
<div id='searchForm'></div>
<div id='dataGrid'></div>

</body>
<script type="text/javascript">
Ext.BLANK_IMAGE_URL = "../ext3/resources/images/default/s.gif";  //��Ϊ���������������������ͼƬ��ʾ
Ext.onReady(function() {
var saveType;
/*------ʵ��toolbar�ĺ��� start---------------*/
var Toolbar = new Ext.Toolbar({
	renderTo:"toolbar",
	items:[{
		text:"����",
		icon:"../Theme/1/images/extjs/customer/add16.gif",
		handler:function(){
		    saveType='add';
		    openAddAccountWin();
		}
		},'-',{
		text:"�༭",
		icon:"../Theme/1/images/extjs/customer/edit16.gif",
		handler:function(){
		    saveType='save';
		    modifyAccountWin();
		}
		},'-',{
		text:"ɾ��",
		icon:"../Theme/1/images/extjs/customer/delete16.gif",
		handler:function(){
		    deleteAccount();
		}
	}]
});

/*------����toolbar�ĺ��� end---------------*/


/*------��ʼToolBar�¼����� start---------------*//*-----����Accountʵ���ര�庯��----*/
function openAddAccountWin() {	
	uploadAccountWindow.show();
}
/*-----�༭Accountʵ���ര�庯��----*/
function modifyAccountWin() {
	var sm = dataGrid.getSelectionModel();
	//��ȡѡ���������Ϣ
	var selectData =  sm.getSelected();
	if(selectData == null){
		Ext.Msg.alert("��ʾ","��ѡ����Ҫ�༭����Ϣ��");
		return;
	}
	uploadAccountWindow.show();
	setFormValue(selectData);
}
/*-----ɾ��Accountʵ�庯��----*/
/*ɾ����Ϣ*/
function deleteAccount()
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
				url:'frmFmBankAccount.aspx?method=deleteBankAccount',
				method:'POST',
				params:{
					BankId:selectData.data.BankId
				},
				success: function(resp,opts){
					Ext.Msg.alert("��ʾ","����ɾ���ɹ�");
					dataGrid.getStore().remove(selectData);
				},
				failure: function(resp,opts){
					Ext.Msg.alert("��ʾ","����ɾ��ʧ��");
				}
			});
		}
	});
}

/*------ʵ��FormPanle�ĺ��� start---------------*/
var bankForm = new Ext.form.FormPanel({
	url:'',
	frame:true,
	title:'',
	items:[
		{
			xtype:'hidden',
			fieldLabel:'���',
			columnWidth:1,
			anchor:'90%',
			name:'BankId',
			id:'BankId',
			hidden:true,
			hideLabel:true
		}
,		{
			xtype:'textfield',
			fieldLabel:'��������',
			columnWidth:1,
			anchor:'90%',
			name:'BankName',
			id:'BankName'
		}
,		{
			xtype:'textfield',
			fieldLabel:'�����˻�',
			columnWidth:1,
			anchor:'90%',
			name:'BankAcount',
			id:'BankAcount'
		}
,		{
			xtype:'textfield',
			fieldLabel:'˰��',
			columnWidth:1,
			anchor:'90%',
			name:'TaxNo',
			id:'TaxNo'
		}
,		{
			xtype:'checkbox',
			boxLabel:'����������',
			columnWidth:1,
			anchor:'90%',
			name:'IsBase',
			id:'IsBase'
		}
,		{
			xtype:'textfield',
			fieldLabel:'�绰����',
			columnWidth:1,
			anchor:'90%',
			name:'BankPhone',
			id:'BankPhone'
		}
,		{
			xtype:'textfield',
			fieldLabel:'���е�ַ',
			columnWidth:1,
			anchor:'90%',
			name:'BankAdress',
			id:'BankAdress'
		}
]
});
/*------FormPanle�ĺ������� End---------------*/

var namePanel = new Ext.form.TextField({
    style: 'margin-left:0px',
    cls: 'key',
    xtype: 'textfield',
    fieldLabel: '��������',
    name: 'name',
    anchor: '90%'
});

var serchform = new Ext.FormPanel({
    renderTo: 'searchForm',
    labelAlign: 'left',
    layout:'fit',
    buttonAlign: 'right',
    bodyStyle: 'padding:5px',
    frame: true,
    labelWidth: 55,
    items: [{
        layout: 'column',   //�����Ԫ��Ϊ����Ϊ�в��ַ�ʽ
        border: false,
        items: [{
            columnWidth: .33,
            layout: 'form',
            border: false,
            items: [
                namePanel
                ]
        },{
            columnWidth: .10,
            layout: 'form',
            border: false,
            items: [{ cls: 'key',
                xtype: 'button',
                text: '��ѯ',
                anchor: '50%',
                handler :function(){                
                    var name=namePanel.getValue();
                    dsDataGrid.baseParams.BankName = name;
                    dsDataGrid.load({
                                params : {
                                start : 0,
                                limit : 10
                                } 
                              }); 
                    }
                }]
        },{
            columnWidth: .57,  //����ռ�õĿ�ȣ���ʶΪ20��
            layout: 'form',
            border: false
        }]
    }]
});
/*------�����ѯform end ----------------*/


/*------��ʼ�������ݵĴ��� Start---------------*/
if(typeof(uploadAccountWindow)=="undefined"){//�������2��windows����
	uploadAccountWindow = new Ext.Window({
		id:'Accountformwindow',
		title:'��������ά��'
		, iconCls: 'upload-win'
		, width: 400
		, height: 250
		, layout: 'fit'
		, plain: true
		, modal: true
		, constrain:true
		, resizable: false
		, closeAction: 'hide'
		,autoDestroy :true
		,items:bankForm
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
				uploadAccountWindow.hide();
			}
			, scope: this
		}]});
	}
	uploadAccountWindow.addListener("hide",function(){
	    bankForm.getForm().reset();
});

/*------��ʼ��ȡ�������ݵĺ��� start---------------*/
function saveUserData()
{
    if(saveType =='add')
        saveType = 'addBankAccount';
    else if(saveType == 'save')
        saveType = 'saveBankAccount';

    var IsBase = false;
    if(Ext.getCmp('IsBase').getValue())
        IsBase = true;
        
	Ext.Ajax.request({
		url:'frmFmBankAccount.aspx?method='+saveType,
		method:'POST',
		params:{
			BankId:Ext.getCmp('BankId').getValue(),
			BankName:Ext.getCmp('BankName').getValue(),
			BankAcount:Ext.getCmp('BankAcount').getValue(),
			TaxNo:Ext.getCmp('TaxNo').getValue(),
			IsBase:IsBase,
			BankPhone:Ext.getCmp('BankPhone').getValue(),
			BankAdress:Ext.getCmp('BankAdress').getValue()
			},
		success: function(resp,opts){
			Ext.Msg.alert("��ʾ","����ɹ�");
			dsDataGrid.reload();
			uploadAccountWindow.hide();
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
		url:'frmFmBankAccount.aspx?method=getBankAccount',
		params:{
			BankId:selectData.data.BankId
		},
	success: function(resp,opts){
		var data=Ext.util.JSON.decode(resp.responseText);
		var isBase = false;
		if(data.IsBase)
		    isBase = true;
		Ext.getCmp("BankId").setValue(data.BankId);
		Ext.getCmp("BankName").setValue(data.BankName);
		Ext.getCmp("BankAcount").setValue(data.BankAcount);
		Ext.getCmp("TaxNo").setValue(data.TaxNo);
		Ext.getCmp("IsBase").setValue(isBase);
		Ext.getCmp("BankPhone").setValue(data.BankPhone);
		Ext.getCmp("BankAdress").setValue(data.BankAdress);
	},
	failure: function(resp,opts){
		Ext.Msg.alert("��ʾ","��ȡ�û���Ϣʧ��");
	}
	});
}
/*------�������ý������ݵĺ��� End---------------*/

/*------��ʼ��ȡ���ݵĺ��� start---------------*/
var dsDataGrid = new Ext.data.Store
({
url: 'frmFmBankAccount.aspx?method=getBankAccountList',
reader:new Ext.data.JsonReader({
	totalProperty:'totalProperty',
	root:'root'
},[
	{
		name:'BankId'
	},
	{
		name:'BankName'
	},
	{
		name:'BankAcount'
	},
	{
		name:'TaxNo'
	},
	{
		name:'IsBase'
	},
	{
		name:'BankPhone'
	},
	{
		name:'BankAdress'
	},
	{
		name:'OwnerOrg'
	},
	{
		name:'CreateDate'
	},
	{
		name:'OperId'
	},
	{
		name:'OrgId'
	},
	{
		name:'OwnerId'
	},
	{
		name:'Status'
	},
	{
		name:'Ext1'
	},
	{
		name:'Ext2'
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
var dataGrid = new Ext.grid.GridPanel({
	el: 'dataGrid',
	width:'100%',
	height:'100%',
	autoWidth:true,
	autoHeight:true,
	autoScroll:true,
	layout: 'fit',
	id: 'dataGrid',
	store: dsDataGrid,
	loadMask: {msg:'���ڼ������ݣ����Ժ��'},
	sm:sm,
	cm: new Ext.grid.ColumnModel([
		sm,
		new Ext.grid.RowNumberer(),//�Զ��к�
		{
			header:'���',
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
			header:'�����˻�',
			dataIndex:'BankAcount',
			id:'BankAcount'
		},
		{
			header:'˰��',
			dataIndex:'TaxNo',
			id:'TaxNo'
		},
		{
			header:'�Ƿ����������',
			dataIndex:'IsBase',
			id:'IsBase',
			renderer:{fn:function(v){if(v)return '��';else return '��';}}
		},
		{
			header:'�绰����',
			dataIndex:'BankPhone',
			id:'BankPhone'
		},
		{
			header:'���е�ַ',
			dataIndex:'BankAdress',
			id:'BankAdress'
		},
		{
			header:'������˾',
			dataIndex:'OwnerOrg',
			id:'OwnerOrg'
		},
		{
			header:'����ʱ��',
			dataIndex:'CreateDate',
			id:'CreateDate',
			renderer: Ext.util.Format.dateRenderer('Y��m��d��')
		}
		]),
		bbar: new Ext.PagingToolbar({
			pageSize: 10,
			store: dsDataGrid,
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
dataGrid.render();
/*------DataGrid�ĺ������� End---------------*/



})
</script>
</html>
