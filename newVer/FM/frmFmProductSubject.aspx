<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmFmProductSubject.aspx.cs" Inherits="FM_frmFmProductSubject" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html>
<head>
<title>��Ʒ���Ŀ��Ӧ��ϵά��</title><meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<link rel="stylesheet" type="text/css" href="../ext3/resources/css/ext-all.css" />
<script type="text/javascript" src="../ext3/adapter/ext/ext-base.js"></script>
<script type="text/javascript" src="../ext3/ext-all.js"></script>
</head>
<body>
<div id='toolbar'></div>
<div id='searchForm'></div>
<div id='dateGrid'></div>

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
		    saveType ='add';
		    openAddSubjectWin();
		}
		},'-',{
		text:"�༭",
		icon:"../Theme/1/images/extjs/customer/edit16.gif",
		handler:function(){
		    saveType ='add';
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
	/*----------���幩Ӧ����Ͽ� start -------------*/ 
    //�����Ʒ�������첽���÷���
    var dsProducts;
    if(dsProducts == null){
        dsProducts = new Ext.data.Store({
            url: 'frmFmProductSubject.aspx?method=getProducts',  
            reader: new Ext.data.JsonReader({  
                root: 'root',  
                totalProperty: 'totalProperty'
            }, [  
                {name: 'ProductId', mapping: 'ProductId'}, 
                {name: 'ProductNo', mapping: 'ProductNo'},  
                {name: 'ProductName', mapping: 'ProductName'}
            ])
        });
    }
   var productFilterCombo = new Ext.form.ComboBox({  
                store: dsProducts,  
                displayField:'ProductName',
                displayValue:'ProductId',
                typeAhead: false,  
                minChars:1,
                loadingText: 'Searching...',  
                //tpl: resultTpl,  
                pageSize:10,  
                hideTrigger:true,  
                applyTo: 'ProductName',
                onSelect: function(record){ // override default onSelect to do redirect  
                    //alert(record.data.cusid); 
                    //alert(Ext.getCmp('search').getValue());                        
                    Ext.getCmp('ProductName').setValue(record.data.ProductName);
                    Ext.getCmp('ProductId').setValue(record.data.ProductId);
                    Ext.getCmp('SubjectCode').focus(); 
                }  
            });     
    /*----------�����Ʒ��Ͽ� end -------------*/
    
    Ext.getCmp('ProductName').setDisabled(false);
}
/*-----�༭Subjectʵ���ര�庯��----*/
function modifySubjectWin() {
	var sm = gridData.getSelectionModel();
	//��ȡѡ���������Ϣ
	var selectData =  sm.getSelected();
	if(selectData == null){
		Ext.Msg.alert("��ʾ","��ѡ����Ҫ�༭����Ϣ��");
		return;
	}
	uploadSubjectWindow.show();
	Ext.getCmp('ProductName').setDisabled(true);
	setFormValue(selectData);
}
/*-----ɾ��Subjectʵ�庯��----*/
/*ɾ����Ϣ*/
function deleteSubject()
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
				url:'frmFmProductSubject.aspx?method=deleteSubject',
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
var prodForm=new Ext.form.FormPanel({
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
			xtype:'hidden',
			fieldLabel:'��Ʒ����',
			columnWidth:1,
			anchor:'90%',
			name:'ProductId',
			id:'ProductId',
			hidden:true,
			hideLabel:true
		}
,		{
			xtype:'textfield',
			fieldLabel:'��Ʒ����',
			columnWidth:1,
			anchor:'90%',
			name:'ProductName',
			id:'ProductName'
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
			fieldLabel:'��Ӧ����',
			columnWidth:1,
			anchor:'90%',
			name:'RegexType',
			id:'RegexType',
			store:dsRegexType,
			mode:'local',
			displayField:'DicsName',
			valueField:'DicsCode',
			triggerAction:'all',
			editable:false
		}
]
});
/*------FormPanle�ĺ������� End---------------*/

/*------��ʼ�������ݵĴ��� Start---------------*/
if(typeof(uploadSubjectWindow)=="undefined"){//�������2��windows����
	uploadSubjectWindow = new Ext.Window({
		id:'Subjectformwindow',
		title:'��Ʒ���Ŀ��Ӧ��ϵά��'
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
		,items:prodForm
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
	prodForm.getForm().reset();
});

/*------��ʼ��ȡ�������ݵĺ��� start---------------*/
function saveUserData()
{
    if(saveType=='add')
        saveType='addProductSubject';
    else if(saveType=='save')
        saveType='saveProductSubject';
	Ext.Ajax.request({
		url:'frmFmProductSubject.aspx?method='+saveType,
		method:'POST',
		params:{
			SubjectId:Ext.getCmp('SubjectId').getValue(),
			ProductId:Ext.getCmp('ProductId').getValue(),
			SubjectCode:Ext.getCmp('SubjectCode').getValue(),
			RegexType:Ext.getCmp('RegexType').getValue(),
				},
		success: function(resp,opts){
			Ext.Msg.alert("��ʾ","����ɹ�");
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
		url:'frmFmProductSubject.aspx?method=getSubject',
		params:{
			SubjectId:selectData.data.SubjectId
		},
	success: function(resp,opts){
		var data=Ext.util.JSON.decode(resp.responseText);
		Ext.getCmp("SubjectId").setValue(data.SubjectId);
		Ext.getCmp("ProductId").setValue(data.ProductId);
		Ext.getCmp("ProductName").setValue(data.ProductName);
		Ext.getCmp("SubjectCode").setValue(data.SubjectCode);
		Ext.getCmp("RegexType").setValue(data.RegexType);
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
url: 'frmFmProductSubject.aspx?method=getProductSubjectList',
reader:new Ext.data.JsonReader({
	totalProperty:'totalProperty',
	root:'root'
},[
	{
		name:'SubjectId'
	},
	{
		name:'ProductId'
	},
	{
		name:'ProductName'
	},
	{
		name:'SubjectCode'
	},
	{
		name:'SubjectName'
	},
	{
		name:'OwnerOrg'
	},
	{
		name:'OrgName'
	},
	{
		name:'RegexType'
	},
	{
		name:'RegexName'
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


/*------FormPanle�ĺ������� End---------------*/
var namePanel = new Ext.form.TextField({
    style: 'margin-left:0px',
    cls: 'key',
    xtype: 'textfield',
    fieldLabel: '��Ʒ����',
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
                    dsgridData.baseParams.ProductName = name;
                    dsgridData.load({
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


/*------��ʼDataGrid�ĺ��� start---------------*/

var sm= new Ext.grid.CheckboxSelectionModel({
	singleSelect:true
});
var gridData = new Ext.grid.GridPanel({
	el: 'dateGrid',
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
			header:'��Ʒ����',
			dataIndex:'ProductId',
			id:'ProductId',
			hidden:true,
			hideable:false
		},
		{
			header:'��Ʒ����',
			dataIndex:'ProductName',
			id:'ProductName'
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
			header:'������˾',
			dataIndex:'OwnerOrg',
			id:'OwnerOrg',
			hidden:true,
			hideable:false
		},
		{
			header:'������˾',
			dataIndex:'OrgName',
			id:'OrgName'
		},
		{
			header:'������˾',
			dataIndex:'RegexType',
			id:'RegexType',
			hidden:true,
			hideable:false
		},
		{
			header:'��Ӧ����',
			dataIndex:'RegexName',
			id:'RegexName'
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


/*------DataGrid�ĺ������� End---------------*/



})
</script>

</html>
