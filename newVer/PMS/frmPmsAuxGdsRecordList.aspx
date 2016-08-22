<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmPmsAuxGdsRecordList.aspx.cs" Inherits="PMS_frmPmsAuxGdsRecord" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html>
<head>
<title>����ʣ�Ϲ���</title><meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<link rel="stylesheet" type="text/css" href="../ext3/resources/css/ext-all.css" />
<script type="text/javascript" src="../ext3/adapter/ext/ext-base.js"></script>
<script type="text/javascript" src="../ext3/ext-all.js"></script>
<script type="text/javascript" src="../ext3/src/locale/ext-lang-zh_CN.js"></script>
</head>

<body>
<div id='toolbar'></div>
<div id='divForm'></div>
<div id='dataGrid'></div>
<%=getComboBoxStore() %>
</body>
<script type="text/javascript">
Ext.onReady(function(){
var saveType;
Ext.BLANK_IMAGE_URL = "../ext3/resources/images/default/s.gif";
/*------ʵ��toolbar�ĺ��� start---------------*/
var Toolbar = new Ext.Toolbar({
	renderTo:"toolbar",
	items:[{
		text:"����",
		icon:"../Theme/1/images/extjs/customer/add16.gif",
		handler:function(){
		    saveType="addRecord";
		    openAddRecordWin();
		}
		},'-',{
		text:"�༭",
		icon:"../Theme/1/images/extjs/customer/edit16.gif",
		handler:function(){
		    saveType = "saveRecord";
		    modifyRecordWin();
		}
		},'-',{
		text:"ɾ��",
		icon:"../Theme/1/images/extjs/customer/delete16.gif",
		handler:function(){
		    deleteRecord();
		}
	}]
});

/*------����toolbar�ĺ��� end---------------*/


/*------��ʼToolBar�¼����� start---------------*//*-----����Recordʵ���ര�庯��----*/
function openAddRecordWin() {
	uploadRecordWindow.show();
}
/*-----�༭Recordʵ���ര�庯��----*/
function modifyRecordWin() {
	var sm = pmsauxgdsrecordGrid.getSelectionModel();
	//��ȡѡ���������Ϣ
	var selectData =  sm.getSelected();
	if(selectData == null){
		Ext.Msg.alert("��ʾ","��ѡ����Ҫ�༭����Ϣ��");
		return;
	}
	uploadRecordWindow.show();
	setFormValue(selectData);
}
/*-----ɾ��Recordʵ�庯��----*/
/*ɾ����Ϣ*/
function deleteRecord()
{
	var sm = pmsauxgdsrecordGrid.getSelectionModel();
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
				url:'frmPmsAuxGdsRecordList.aspx?method=deleteRecord',
				method:'POST',
				params:{
					Id:selectData.data.Id
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
var pmsAuxGdsForm=new Ext.form.FormPanel({
	url:'',
	frame:true,
	title:'',
	labelWidth:55,
	items:[
		{
			xtype:'hidden',
			name:'Id',
			id:'Id',
			hidden:true,
			hideLabel:false
		}
,		{
			xtype:'combo',
			fieldLabel:'����',
			columnWidth:1,
			anchor:'95%',
			name:'WsId',
			id:'WsId',
		    store:dsWs,
		    displayField:'WsName',
		    valueField:'WsId',
		    mode:'local',
		    triggerAction:'all',
		    editable: true
		}
,		{
			xtype:'combo',
			fieldLabel:'����ԭ��',
			columnWidth:1,
			anchor:'95%',
			name:'AuxProductId',
			id:'AuxProductId',
            store: dsProductList,
            displayField: 'ProductName',
            valueField: 'ProductId',
            triggerAction: 'all',
            typeAhead: true,
            mode: 'local',
            emptyText: '',
            selectOnFocus: false,
            editable: true
		}
,		{
            layout:'column',
            items:[
            {
                layout:'form',
                columnWidth:.475,
                items:[
                {
                    xtype:'combo',
			        fieldLabel:'�Ǽ�����',			
			        anchor:'95%',
			        name:'Type',
			        id:'Type',
			        store:[[0,'ʣ�ϵǼ�'],[1,'ʣ������']],
			        mode:'local',
			        triggerAction:'all',
			        editable:false
                }
                ]
            },
            {
                layout:'form',
                columnWidth:.475,
                items:[
                {
                    xtype:'numberfield',
			        fieldLabel:'����',
			        columnWidth:.5,
			        anchor:'95%',
			        name:'Qty',
			        id:'Qty'
                }
                ]
            }
            ]			
		}
,		{
			xtype:'datefield',
			fieldLabel:'����ʱ��',
			columnWidth:1,
			anchor:'95%',
			name:'InTime',
			id:'InTime',
			format:'Y��m��d�� H:i:s',
			value:new Date()
		}
,		{
			xtype:'textfield',
			fieldLabel:'ԭʼ����',
			columnWidth:1,
			anchor:'95%',
			name:'OrigNo',
			id:'OrigNo'
		}
,		{
			xtype:'textarea',
			fieldLabel:'��ע',
			columnWidth:1,
			anchor:'95%',
			name:'Remark',
			id:'Remark'
		}
]
});
/*------FormPanle�ĺ������� End---------------*/

/*------��ʼ�������ݵĴ��� Start---------------*/
if(typeof(uploadRecordWindow)=="undefined"){//�������2��windows����
	uploadRecordWindow = new Ext.Window({
		id:'Recordformwindow',
		title:''
		, iconCls: 'upload-win'
		, width: 500
		, height: 300
		, layout: 'fit'
		, plain: true
		, modal: true
		, constrain:true
		, resizable: false
		, closeAction: 'hide'
		,autoDestroy :true
		,items:pmsAuxGdsForm
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
				uploadRecordWindow.hide();
			}
			, scope: this
		}]});
	}
	uploadRecordWindow.addListener("hide",function(){
	    pmsAuxGdsForm.getForm().reset();
	    pmsauxgdsrecordGrid.getStore().reload();
});

/*------��ʼ��ȡ�������ݵĺ��� start---------------*/
function saveUserData()
{

	Ext.Ajax.request({
		url:'frmPmsAuxGdsRecordList.aspx?method='+saveType,
		method:'POST',
		params:{
			Id:Ext.getCmp('Id').getValue(),
			WsId:Ext.getCmp('WsId').getValue(),
			AuxProductId:Ext.getCmp('AuxProductId').getValue(),
			Type:Ext.getCmp('Type').getValue(),
			Qty:Ext.getCmp('Qty').getValue(),
			InTime:Ext.util.Format.date(Ext.getCmp('InTime').getValue(),'Y/m/d H:i:s'),
			OrigNo:Ext.getCmp('OrigNo').getValue(),
			Remark:Ext.getCmp('Remark').getValue()
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
		url:'frmPmsAuxGdsRecordList.aspx?method=getrecord',
		params:{
			Id:selectData.data.Id
		},
	success: function(resp,opts){
		var data=Ext.util.JSON.decode(resp.responseText);
		Ext.getCmp("Id").setValue(data.Id);
		Ext.getCmp("WsId").setValue(data.WsId);
		Ext.getCmp("AuxProductId").setValue(data.AuxProductId);
		Ext.getCmp("Type").setValue(data.Type);
		Ext.getCmp("Qty").setValue(data.Qty);
		Ext.getCmp("InTime").setValue((new Date(data.InTime.replace(/-/g,"/"))));
		Ext.getCmp("OrigNo").setValue(data.OrigNo);
		Ext.getCmp("Remark").setValue(data.Remark);
	},
	failure: function(resp,opts){
		Ext.Msg.alert("��ʾ","��ȡ�û���Ϣʧ��");
	}
	});
}
/*------�������ý������ݵĺ��� End---------------*/
/*------��ʼ��ѯform end---------------*/
//��������
var auxWsNamePanel = new Ext.form.ComboBox({
    xtype:'combo',
    fieldLabel:'����',
    anchor:'95%',
	store:dsWs,
	displayField:'WsName',
    valueField:'WsId',
    mode:'local',
    triggerAction:'all',
    editable: false
});

//ԭʼ���ݱ��
var auxiniOrderIdPanel = new Ext.form.TextField({
    xtype:'textfield',
    fieldLabel:'ԭʼ���ݱ��',
    anchor:'95%'
});
//��ʼʱ��
var auxksrq = new Ext.form.DateField({
    xtype:'datefield',
    fieldLabel:'��ʼʱ��',
    anchor:'95%',
    format: 'Y��m��d�� H:i:s',  //���������ʽ
    value:new Date() 
});

//����ʱ��
var auxjsrq = new Ext.form.DateField({
    xtype:'datefield',
    fieldLabel:'����ʱ��',
    anchor:'95%',
    format: 'Y��m��d�� H:i:s',  //���������ʽ
    value:new Date()
});

var serchform = new Ext.FormPanel({
    el:'divForm',
    id:'serchform',
    labelAlign: 'left',
    buttonAlign: 'right',
    bodyStyle: 'padding:5px',
    frame: true,    
    items: [{
        layout: 'column',   //�����Ԫ��Ϊ����Ϊ�в��ַ�ʽ
        border: false,
        items: [{
            columnWidth: .4,  //����ռ�õĿ�ȣ���ʶΪ20��
            layout: 'form',
            border: false,
            labelWidth: 55,
            items: [
                auxWsNamePanel
            ]
        }, {
            columnWidth: .4,
            layout: 'form',
            border: false,
            labelWidth: 80,
            items: [
                auxiniOrderIdPanel
                ]
        }]
    },
    {
        layout: 'column',   //�����Ԫ��Ϊ����Ϊ�в��ַ�ʽ
        border: false,
        items: [{
            name: 'cusStyle',
            columnWidth: .4,
            layout: 'form',
            border: false,
            labelWidth: 55,
            items: [
                auxksrq
            ]
        },{
            name: 'cusStyle',
            columnWidth: .4,
            layout: 'form',
            border: false,
            labelWidth: 80,
            items: [
                auxjsrq
            ]
        }, {            
            layout: 'form',
            columnWidth: .2,
            border: false,
            items: [{ cls: 'key',
                xtype: 'button',
                text: '��ѯ',
                anchor: '50%',
                handler :function(){
                
                var strWsId=auxWsNamePanel.getValue();
                var striniOrderId=auxiniOrderIdPanel.getValue();
                var strStartTime=auxksrq.getValue();
                var strEndTime=auxjsrq.getValue();
                
                dspmsauxgdsrecord.baseParams.WorkshopId=strWsId;
                dspmsauxgdsrecord.baseParams.IniOrderId=striniOrderId;
                dspmsauxgdsrecord.baseParams.StartTime=Ext.util.Format.date(strStartTime,'Y/m/d');
                dspmsauxgdsrecord.baseParams.EndTime=Ext.util.Format.date(strEndTime,'Y/m/d H:i:s');
                
                dspmsauxgdsrecord.load({
                            params : {
                            start : 0,
                            limit : 10
                            } });
                }
            }]
        }]
    }]
});
serchform.render();
/*------��ʼ��ѯform end---------------*/
/*------��ʼ��ȡ���ݵĺ��� start---------------*/
var dspmsauxgdsrecord = new Ext.data.Store
({
url: 'frmPmsAuxGdsRecordList.aspx?method=getrecordList',
reader:new Ext.data.JsonReader({
	totalProperty:'totalProperty',
	root:'root'
},[
	{		name:'Id'	},
	{		name:'WsId'	},
	{		name:'AuxProductId'	},
	{		name:'Type'	},
	{		name:'Qty'	},
	{		name:'InTime'	},
	{		name:'OrigNo'	},
	{		name:'Remark'	},
	{		name:'OrgId'	},
	{		name:'OperId'	},
	{		name:'OwnerId'	},
	{		name:'CreateDate'
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
var pmsauxgdsrecordGrid = new Ext.grid.GridPanel({
	el: 'dataGrid',
	width:'100%',
	height:'100%',
	autoWidth:true,
	autoHeight:true,
	autoScroll:true,
	layout: 'fit',
	id: '',
	store: dspmsauxgdsrecord,
	loadMask: {msg:'���ڼ������ݣ����Ժ��'},
	sm:sm,
	cm: new Ext.grid.ColumnModel([
		sm,
		new Ext.grid.RowNumberer(),//�Զ��к�
		{
			header:'ID',
			dataIndex:'Id',
			id:'Id',
			hidden:true,
			hideable:false
		},
		{
			header:'����',
			dataIndex:'WsId',
			id:'WsId',
			renderer:function(val){
			    dsWs.each(function(r) {
		            if (val == r.data['WsId']) {
		                val = r.data['WsName'];
		                return;
		            }
		        });
		        return val;
			}
		},
		{
			header:'����ԭ��',
			dataIndex:'AuxProductId',
			id:'AuxProductId'
		},
		{
			header:'�������',
			dataIndex:'Type',
			id:'Type',
			renderer:function(v){
			    if(v==1)
			        return 'ʣ�ϵǼ�';
			    else
			        return 'ʣ������';
			}
		},
		{
			header:'����',
			dataIndex:'Qty',
			id:'Qty'
		},
		{
			header:'ԭʼ����',
			dataIndex:'OrigNo',
			id:'OrigNo'
		},
		{
			header:'�Ǽ�����',
			dataIndex:'InTime',
			id:'InTime',
			renderer: Ext.util.Format.dateRenderer('Y��m��d��')
		}
		]),
		bbar: new Ext.PagingToolbar({
			pageSize: 10,
			store: dspmsauxgdsrecord,
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
pmsauxgdsrecordGrid.render();
/*------DataGrid�ĺ������� End---------------*/



})
</script>
</html>
