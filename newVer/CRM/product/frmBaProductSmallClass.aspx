<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmBaProductSmallClass.aspx.cs" Inherits="CRM_product_frmBaProductClass" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>����ɹ��ƻ�����С���Ӧ��ϵά��</title>
    <meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
    <link rel="stylesheet" type="text/css" href="../../ext3/resources/css/ext-all.css" />
	<script type="text/javascript" src="../../ext3/adapter/ext/ext-base.js"></script>	
	<script type="text/javascript" src="../../ext3/ext-all.js"></script>
	<script type="text/javascript" src="../../js/operateResp.js"></script>
</head>
<body>
   <div id ='toolbar'></div>
   <div id ='searchForm'></div>
   <div id ='dataGrid'></div>
</body>

<%=getComboBoxStore() %>

<script type="text/javascript">
var saveType;
Ext.BLANK_IMAGE_URL = "../../ext3/resources/images/default/s.gif";	
Ext.onReady(function(){
/*------ʵ��toolbar�ĺ��� start---------------*/
var Toolbar = new Ext.Toolbar({
	renderTo:"toolbar",
	items:[{
		text:"����",
		icon:"../../Theme/1/images/extjs/customer/add16.gif",
		handler:function(){
		    saveType ='add';
		    openAddClassWin();
		}
		},'-',{
		text:"�༭",
		icon:"../../Theme/1/images/extjs/customer/edit16.gif",
		handler:function(){
		    saveType = 'save';
		    modifyClassWin();
		}
		},'-',{
		text:"ɾ��",
		icon:"../../Theme/1/images/extjs/customer/delete16.gif",
		handler:function(){
		    deleteClass();
		}
	}]
});

/*------����toolbar�ĺ��� end---------------*/


/*------��ʼToolBar�¼����� start---------------*//*-----����Classʵ���ര�庯��----*/
function openAddClassWin() {
	uploadClassWindow.show();
	//��ȡ���
    Ext.Ajax.request({
        url: 'frmBaProductSmallClass.aspx?method=getProductNo',
        success: function(resp, opts) {
            var dataNo = Ext.util.JSON.decode(resp.responseText);
            Ext.getCmp('ClassNo').setValue(dataNo.ProductNo); 
        },
        failure: function(resp, opts) {
            Ext.Msg.alert("��ʾ", "��ȡ���ʧ�ܣ�");
        }
    }); 
}
/*-----�༭Classʵ���ര�庯��----*/
function modifyClassWin() {
	var sm = gridData.getSelectionModel();
	//��ȡѡ���������Ϣ
	var selectData =  sm.getSelected();
	if(selectData == null){
		Ext.Msg.alert("��ʾ","��ѡ����Ҫ�༭����Ϣ��");
		return;
	}
	uploadClassWindow.show();
	setFormValue(selectData);
}
/*-----ɾ��Classʵ�庯��----*/
/*ɾ����Ϣ*/
function deleteClass()
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
				url:'frmBaProductSmallClass.aspx?method=deleteSmallClass',
				method:'POST',
				params:{
					ClassId:selectData.data.ClassId
				},
				success: function(resp,opts){
					Ext.Msg.alert("��ʾ","����ɾ���ɹ�");
					gridData.getStore().reload();
				},
				failure: function(resp,opts){
					Ext.Msg.alert("��ʾ","����ɾ��ʧ��");
				}
			});
		}
	});
}

/*------ʵ��FormPanle�ĺ��� start---------------*/
var smallClassForm = new Ext.form.FormPanel({
	url:'',
	//renderTo:'divForm',
	frame:true,
	title:'',
	labelWidth:80,
	items:[
		{
			xtype:'hidden',
			fieldLabel:'С��ID',
			columnWidth:1,
			anchor:'90%',
			name:'ClassId',
			id:'ClassId',
			hidden:true,
			hideLabel:false
		}
,		{
			xtype:'textfield',
			fieldLabel:'С�����',
			columnWidth:1,
			anchor:'90%',
			name:'ClassNo',
			id:'ClassNo'
		}
,		{
			xtype:'textfield',
			fieldLabel:'С������',
			columnWidth:1,
			anchor:'90%',
			name:'ClassName',
			id:'ClassName'
		}
,		{
			xtype:'textfield',
			fieldLabel:'С����',
			columnWidth:1,
			anchor:'90%',
			name:'Specifications',
			id:'Specifications'//,
//			store:dsSpecifications,
//			displayField:'DicsName',
//			valueField:'DicsCode',
//			mode:'local',
//			editable:false,
//			triggerAction:'all'
		}
,		{
			xtype:'combo',
			fieldLabel:'������λ',
			columnWidth:1,
			anchor:'90%',
			name:'Unit',
			id:'Unit',
			store:dsUnit,
			displayField:'UnitName',
			valueField:'UnitId',
			mode:'local',
			editable:false,
			triggerAction:'all'
		}
,		{
			xtype:'textarea',
			fieldLabel:'��ע',
			columnWidth:1,
			anchor:'90%',
			name:'Remark',
			id:'Remark'
		}
]
});
/*------FormPanle�ĺ������� End---------------*/

/*------��ʼ�������ݵĴ��� Start---------------*/
if(typeof(uploadClassWindow)=="undefined"){//�������2��windows����
	uploadClassWindow = new Ext.Window({
		id:'Classformwindow',
		title:'�ɹ��ƻ���ƷС��ά��'
		, iconCls: 'upload-win'
		, width: 400
		, height: 280
		, layout: 'fit'
		, plain: true
		, modal: true
		, constrain:true
		, resizable: false
		, closeAction: 'hide'
		,autoDestroy :true
		,items:smallClassForm
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
				uploadClassWindow.hide();
			}
			, scope: this
		}]});
	}
	uploadClassWindow.addListener("hide",function(){
	    smallClassForm.getForm().reset();
});

/*------��ʼ��ȡ�������ݵĺ��� start---------------*/
function saveUserData()
{
    if(saveType =='add')
        saveType = 'addSmallClass';
    else if(saveType == 'save')
        saveType = 'saveSmallclass';
        
	Ext.Ajax.request({
		url:'frmBaProductSmallClass.aspx?method='+saveType,
		method:'POST',
		params:{
			ClassId:Ext.getCmp('ClassId').getValue(),
			ClassNo:Ext.getCmp('ClassNo').getValue(),
			ClassName:Ext.getCmp('ClassName').getValue(),
			Specifications:Ext.getCmp('Specifications').getValue(),
			Unit:Ext.getCmp('Unit').getValue(),
			//Supplier:getCmp('CustomerId').getValue(),
			Remark:Ext.getCmp('Remark').getValue()
			},
		success: function(resp,opts){
			if(checkExtMessage(resp))
            {
                gridData.getStore().reload();
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
		url:'frmBaProductSmallClass.aspx?method=getSmallClass',
		params:{
			ClassId:selectData.data.ClassId
		},
	success: function(resp,opts){
		var data=Ext.util.JSON.decode(resp.responseText);
		Ext.getCmp("ClassId").setValue(data.ClassId);
		Ext.getCmp("ClassNo").setValue(data.ClassNo);
		Ext.getCmp("ClassName").setValue(data.ClassName);
		Ext.getCmp("Specifications").setValue(data.Specifications);
		Ext.getCmp("Unit").setValue(data.Unit);
		//Ext.getCmp("CustomerId").setValue(data.Supplier);
		Ext.getCmp("Remark").setValue(data.Remark);
	},
	failure: function(resp,opts){
		Ext.Msg.alert("��ʾ","��ȡ�û���Ϣʧ��");
	}
	});
}
/*------�������ý������ݵĺ��� End---------------*/

/*------�����ѯform start ----------------*/
var namePanel = new Ext.form.TextField({
    style: 'margin-left:0px',
    cls: 'key',
    xtype: 'textfield',
    fieldLabel: 'С����Ʒ��Ż�����',
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
    labelWidth: 120,
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
        }, {
            columnWidth: .10,
            layout: 'form',
            border: false,
            items: [{ cls: 'key',
                xtype: 'button',
                text: '��ѯ',
                anchor: '50%',
                handler :function(){                
                    var name=namePanel.getValue();
                    
                    dsSmallClass.baseParams.ClassName = name;
                    dsSmallClass.load({
                                params : {
                                start : 0,
                                limit : 10
                                } 
                              }); 
                    }
                }]
        }]
    }]
});
/*------�����ѯform end ----------------*/
var dsSmallClass = new Ext.data.Store
({
url: 'frmBaProductSmallClass.aspx?method=getSmallClassList',
reader:new Ext.data.JsonReader({
	totalProperty:'totalProperty',
	root:'root'
},[
	{		name:'ClassId'},
	{		name:'ClassNo'},
	{		name:'ClassName'},
	{		name:'Specifications'},
	{		name:'SpecificationsText'},
	{		name:'Unit'},
	{		name:'UnitText'},
	{		name:'State'},
	{		name:'Remark'},
	{		name:'CreateDate'},
	{		name:'UpdateDate'},
	{		name:'OperId'},
	{		name:'OrgId'},
	{		name:'ValidDate'},
	{		name:'ExpireDate'},
	{		name:'ExpireOperId'},
	{		name:'ExpireOrg'},
	{		name:'ClassScheme'}	])
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
	store: dsSmallClass,
	loadMask: {msg:'���ڼ������ݣ����Ժ��'},
	sm:sm,
	cm: new Ext.grid.ColumnModel([
		sm,
		new Ext.grid.RowNumberer(),//�Զ��к�
		{
			header:'С��ID',
			dataIndex:'ClassId',
			id:'ClassId',
			hidden:true,
			hideable:false
		},
		{
			header:'С�����',
			dataIndex:'ClassNo',
			id:'ClassNo'
		},
		{
			header:'С������',
			dataIndex:'ClassName',
			id:'ClassName'
		},
		{
			header:'С����',
			dataIndex:'SpecificationsText',
			id:'SpecificationsText'
		},
		{
			header:'������λ',
			dataIndex:'UnitText',
			id:'UnitText'
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
			store: dsSmallClass,
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