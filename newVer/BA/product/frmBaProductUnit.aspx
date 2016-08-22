<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmBaProductUnit.aspx.cs" Inherits="BA_product_frmBaProductUnit" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html>
<head>
<title>������λά��</title><meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<link rel="stylesheet" type="text/css" href="../../ext3/resources/css/ext-all.css" />
<script type="text/javascript" src="../../ext3/adapter/ext/ext-base.js"></script>
<script type="text/javascript" src="../../ext3/ext-all.js"></script>
</head>
<body>
<div id='toolbar'></div>
<div id='searchForm'></div>
<div id='unitGrid'></div>

</body>

<%= getComboBoxStore() %>

<script type="text/javascript">
Ext.BLANK_IMAGE_URL = "../../ext3/resources/images/default/s.gif";
Ext.onReady(function(){
var saveType;
/*------ʵ��toolbar�ĺ��� start---------------*/
var Toolbar = new Ext.Toolbar({
	renderTo:"toolbar",
	items:[{
		text:"����",
		icon:"../../Theme/1/images/extjs/customer/add16.gif",
		handler:function(){
		    saveType = "add";
		    openAddUnitWin();
		}
		},'-',{
		text:"�༭",
		icon:"../../Theme/1/images/extjs/customer/edit16.gif",
		handler:function(){
		    saveType = "save";
		    modifyUnitWin();
		}
		},'-',{
		text:"ɾ��",
		icon:"../../Theme/1/images/extjs/customer/delete16.gif",
		handler:function(){
		    deleteUnit();
		}
	}]
});

/*------����toolbar�ĺ��� end---------------*/


/*------��ʼToolBar�¼����� start---------------*//*-----����Unitʵ���ര�庯��----*/
function openAddUnitWin() {	
	uploadUnitWindow.show();
}
/*-----�༭Unitʵ���ര�庯��----*/
function modifyUnitWin() {
	var sm = gridData.getSelectionModel();
	//��ȡѡ���������Ϣ
	var selectData =  sm.getSelected();
	if(selectData == null){
		Ext.Msg.alert("��ʾ","��ѡ����Ҫ�༭����Ϣ��");
		return;
	}
	uploadUnitWindow.show();
	setFormValue(selectData);
}
/*-----ɾ��Unitʵ�庯��----*/
/*ɾ����Ϣ*/
function deleteUnit()
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
				url:'frmBaProductUnit.aspx?method=deleteUnit',
				method:'POST',
				params:{
					UnitId:selectData.data.UnitId
				},
				success: function(resp,opts){
					Ext.Msg.alert("��ʾ","����ɾ���ɹ�");
					gridData.getStore().remove(selectData);
				},
				failure: function(resp,opts){
					Ext.Msg.alert("��ʾ","����ɾ��ʧ��");
				}
			});
		}
	});
}

/*------ʵ��FormPanle�ĺ��� start---------------*/
var uintForm=new Ext.form.FormPanel({
	url:'frmBaProductUnit.aspx?method=getUnitInfo',
	//renderTo:'divForm',
	frame:true,
	title:'',
	items:[
		{
			xtype:'hidden',
			fieldLabel:'������λID',
			columnWidth:1,
			anchor:'90%',
			name:'UnitId',
			id:'UnitId',
			hidden:true,
			hideLabel:true
		}
,		{
			xtype:'textfield',
			fieldLabel:'������λ����',
			columnWidth:1,
			anchor:'90%',
			name:'UnitName',
			id:'UnitName'
		}
,		{
			xtype:'combo',
			fieldLabel:'��������',
			columnWidth:.5,
			anchor:'90%',
			name:'Dimension',
			id:'Dimension'
			, displayField: 'UnitName'
            , valueField: 'UnitId'
            , hiddenName: 'UnitId'
            , editable: false
            , store: dsDimension
            , triggerAction: 'all'
            , mode:'local'
		}
,		{
			xtype:'checkbox',
			boxLabel:'�Ƿ��������',
			columnWidth:.5,
			anchor:'90%',
			name:'IsBaseDimension',
			id:'IsBaseDimension'
			//hideLabel:true
		}
]
});
/*------FormPanle�ĺ������� End---------------*/

/*------��ʼ�������ݵĴ��� Start---------------*/
if(typeof(uploadUnitWindow)=="undefined"){//�������2��windows����
	uploadUnitWindow = new Ext.Window({
		id:'Unitformwindow'
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
		,items:uintForm
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
				uploadUnitWindow.hide();
			}
			, scope: this
		}]});
	}
	uploadUnitWindow.addListener("hide",function(){
	    uintForm.getForm().reset();
});

/*------��ʼ��ȡ�������ݵĺ��� start---------------*/
function saveUserData()
{
    if(saveType == 'add')
        saveType = 'addUnitInfo';
    else if (saveType == 'save')
        saveType = 'saveUnitInfo';
    
    var isBaseDim = 0;
    if(Ext.getCmp('IsBaseDimension').getValue())
        isBaseDim = 1;
        
	Ext.Ajax.request({
		url:'frmBaProductUnit.aspx?method='+saveType,
		method:'POST',
		params:{
			UnitId:Ext.getCmp('UnitId').getValue(),
			UnitName:Ext.getCmp('UnitName').getValue(),
			Dimension:Ext.getCmp('Dimension').getValue(),
			IsBaseDimension:isBaseDim
					},
		success: function(resp,opts){
			Ext.Msg.alert("��ʾ","����ɹ�");
			var name=namePanel.getValue();
            uploadUnitWindow.hide();        
            unitGridData.load({
                    params : {
                    start : 0,
                    limit : 10,
                    UnitName:name
                    } 
                  }); 
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
		url:'frmBaProductUnit.aspx?method=getUnitInfo',
		params:{
			UnitId:selectData.data.UnitId
		},
	success: function(resp,opts){
		var data=Ext.util.JSON.decode(resp.responseText);
		Ext.getCmp("UnitId").setValue(data.UnitId);
		Ext.getCmp("UnitName").setValue(data.UnitName);
		Ext.getCmp("Dimension").setValue(data.Dimension);
		if(data.IsBaseDimension==1){
			Ext.get("IsBaseDimension").dom.checked=true;
		}
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
    fieldLabel: '������λ����',
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
    labelWidth: 95,
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
                    unitGridData.baseParams.UnitName = name;
                    unitGridData.load({
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


/*------��ʼ��ȡ���ݵĺ��� start---------------*/
var unitGridData = new Ext.data.Store
({
url: 'frmBaProductUnit.aspx?method=getUnitList',
reader:new Ext.data.JsonReader({
	totalProperty:'totalProperty',
	root:'root'
},[
	{
		name:'UnitId'
	},
	{
		name:'UnitName'
	},
	{
		name:'Dimension'
	},
	{
		name:'IsBaseDimension'
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
	el: 'unitGrid',
	width:'100%',
	height:'100%',
	autoWidth:true,
	autoHeight:true,
	autoScroll:true,
	layout: 'fit',
	store: unitGridData,
	loadMask: {msg:'���ڼ������ݣ����Ժ��'},
	sm:sm,
	cm: new Ext.grid.ColumnModel([
		sm,
		new Ext.grid.RowNumberer(),//�Զ��к�
		{
			header:'������λID',
			dataIndex:'UnitId',
			id:'UnitId'
			,hidden:true
			,hideable:false
		},
		{
			header:'������λ����',
			dataIndex:'UnitName',
			id:'UnitName'
		},
		{
			header:'��������',
			dataIndex:'Dimension',
			id:'Dimension',
			renderer: function(val, params, record) {
			    if(val == 0 ) return "��";
		        if (dsDimension.getCount() == 0) {
		            dsDimension.load();
		        }
		        dsDimension.each(function(r) {
		            if (val == r.data['UnitId']) {
		                val = r.data['UnitName'];
		                return;
		            }
		        });
		        return val;
		    }
		},
		{
			header:'�Ƿ��������',
			dataIndex:'IsBaseDimension',
			id:'IsBaseDimension',
			renderer: function(val, params, record) {
			    if(val==1)
			        return '��';
			    else 
			        return '��';
			}
		}		]),
		bbar: new Ext.PagingToolbar({
			pageSize: 10,
			store: unitGridData,
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
