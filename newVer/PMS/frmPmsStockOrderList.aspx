<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmPmsStockOrderList.aspx.cs" Inherits="PMS_frmPmsStockOrder" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html>
<head>
<title>����ҳ��</title><meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<link rel="stylesheet" type="text/css" href="../ext3/resources/css/ext-all.css" />
<script type="text/javascript" src="../ext3/adapter/ext/ext-base.js"></script>
<script type="text/javascript" src="../ext3/ext-all.js"></script>
<script type="text/javascript" src="../ext3/src/locale/ext-lang-zh_CN.js"></script>
</head>
<body>
<div id='toolbar'></div>
<div id='divForm'></div>
<div id='dataGrid'></div>

</body>
<%=getComboBox() %>
<script type="text/javascript">
Ext.onReady(function(){
var saveType;
/*------ʵ��toolbar�ĺ��� start---------------*/
var Toolbar = new Ext.Toolbar({
	renderTo:"toolbar",
	items:[{
		text:"����",
		icon:"../Theme/1/images/extjs/customer/add16.gif",
		handler:function(){
		    saveType ='';
		    openAddOrderWin();
		}
		},'-',{
		text:"�༭",
		icon:"../Theme/1/images/extjs/customer/edit16.gif",
		handler:function(){
		    saveType ='';
		    modifyOrderWin();
		}
		},'-',{
		text:"ɾ��",
		icon:"../Theme/1/images/extjs/customer/delete16.gif",
		handler:function(){
		    deleteOrder();
		}
	}, '-', {
                text: "��ӡ",
                icon: "../Theme/1/images/extjs/customer/edit16.gif",
                handler: function() {
                    printOrderById();
                }
            }]
});

/*------����toolbar�ĺ��� end---------------*/
function getUrl(imageUrl)
            {
                var index = window.location.href.toLowerCase().indexOf('/pms/');
                var tempUrl = window.location.href.substring(0,index);
                return tempUrl+"/"+imageUrl;
            }
function printOrderById()
{
var sm = pmswsrecordGrid.getSelectionModel();
                //��ѡ
                var selectData = sm.getSelections();                
                var array = new Array(selectData.length);
                var orderIds = "";
                for(var i=0;i<selectData.length;i++)
                {
                    if(orderIds.length>0)
                        orderIds+=",";
                    orderIds += selectData[i].get('RecodrId');
                }
                //ҳ���ύ
                Ext.Ajax.request({
                    url: 'frmPmsWsRecordList.aspx?method=getprintdata',
//                    url:'frmOrderMst.aspx?method=billdata',
                    method: 'POST',
                    params: {
                        RecordId: orderIds
                    },
                   success: function(resp,opts){ 
                       var printData =  resp.responseText;
                       var printControl =  parent.parent.parent.document.getElementById("topFrame").contentWindow.getPrintControl();
                       printControl.Url =getUrl('xml');
                       printControl.MapUrl = printControl.Url+'/'+printStyleXml;//'/salePrint1.xml';
                       printControl.PrintXml = printData;
                       printControl.ColumnName="RecordId";
                       printControl.OnlyData=printOnlyData;
                       printControl.PageWidth=printPageWidth;
                       printControl.PageHeight =printPageHeight ;
                       printControl.Print();
//                    var billControl = document.getElementById('billControl');
//                    billControl.PrintXml = printData;
//                    billControl.setFormValue(0);
                       
                   },
		           failure: function(resp,opts){  /* Ext.Msg.alert("��ʾ","����ʧ��"); */    }
                });
}

/*------��ʼToolBar�¼����� start---------------*//*-----����Orderʵ���ര�庯��----*/
function openAddOrderWin() {
	uploadOrderWindow.show();
}
/*-----�༭Orderʵ���ര�庯��----*/
function modifyOrderWin() {
	var sm = pmsstockorderGrid.getSelectionModel();
	//��ȡѡ���������Ϣ
	var selectData =  sm.getSelected();
	if(selectData == null){
		Ext.Msg.alert("��ʾ","��ѡ����Ҫ�༭����Ϣ��");
		return;
	}
	uploadOrderWindow.show();
	setFormValue(selectData);
}
/*-----ɾ��Orderʵ�庯��----*/
/*ɾ����Ϣ*/
function deleteOrder()
{
	var sm = EpmsstockorderGrid.getSelectionModel();
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
				url:'frmPmsStockOrderList.aspx?method=deleteOrder',
				method:'POST',
				params:{
					OrderId:selectData.data.OrderId
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
var pmsstockorderform=new Ext.form.FormPanel({
	url:'',
	frame:true,
	title:'',
	items:[
		{
			xtype:'textfield',
			fieldLabel:'������',
			columnWidth:1,
			anchor:'90%',
			name:'OrderId',
			id:'OrderId'
		}
,		{
			xtype:'textfield',
			fieldLabel:'��֯��ʶ',
			columnWidth:1,
			anchor:'90%',
			name:'OrgId',
			id:'OrgId'
		}
,		{
			xtype:'textfield',
			fieldLabel:'�����ʶ',
			columnWidth:1,
			anchor:'90%',
			name:'WsId',
			id:'WsId'
		}
,		{
			xtype:'textfield',
			fieldLabel:'���ϲֿ��ʶ',
			columnWidth:1,
			anchor:'90%',
			name:'AuxWhId',
			id:'AuxWhId'
		}
,		{
			xtype:'textfield',
			fieldLabel:'���ϱ�ʶ',
			columnWidth:1,
			anchor:'90%',
			name:'AuxProductId',
			id:'AuxProductId'
		}
,		{
			xtype:'textfield',
			fieldLabel:'����',
			columnWidth:1,
			anchor:'90%',
			name:'Qty',
			id:'Qty'
		}
,		{
			xtype:'textfield',
			fieldLabel:'ԭʼ����',
			columnWidth:1,
			anchor:'90%',
			name:'InitOrderId',
			id:'InitOrderId'
		}
,		{
			xtype:'textfield',
			fieldLabel:'�Ƿ����',
			columnWidth:1,
			anchor:'90%',
			name:'IsOutOrder',
			id:'IsOutOrder'
		}
,		{
			xtype:'textfield',
			fieldLabel:'����ʱ��',
			columnWidth:1,
			anchor:'90%',
			name:'CreateDate',
			id:'CreateDate'
		}
,		{
			xtype:'textfield',
			fieldLabel:'����ʱ��',
			columnWidth:1,
			anchor:'90%',
			name:'UpdateDate',
			id:'UpdateDate'
		}
,		{
			xtype:'textfield',
			fieldLabel:'�����߱�ʶ',
			columnWidth:1,
			anchor:'90%',
			name:'OperId',
			id:'OperId'
		}
,		{
			xtype:'textfield',
			fieldLabel:'�����߱�ʶ',
			columnWidth:1,
			anchor:'90%',
			name:'OwnerId',
			id:'OwnerId'
		}
,		{
			xtype:'textfield',
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
if(typeof(uploadOrderWindow)=="undefined"){//�������2��windows����
	uploadOrderWindow = new Ext.Window({
		id:'Orderformwindow',
		title:''
		, iconCls: 'upload-win'
		, width: 600
		, height: 300
		, layout: 'fit'
		, plain: true
		, modal: true
		, constrain:true
		, resizable: false
		, closeAction: 'hide'
		,autoDestroy :true
		,items:pmsstockorderform
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
				uploadOrderWindow.hide();
			}
			, scope: this
		}]});
	}
	uploadOrderWindow.addListener("hide",function(){
	    pmsstockorderform.getFomr().reset();
});

/*------��ʼ��ȡ�������ݵĺ��� start---------------*/
function saveUserData()
{

	Ext.Ajax.request({
		url:'frmPmsStockOrderList.aspx?method=deleteOrder',
		method:'POST',
		params:{
			OrderId:Ext.getCmp('OrderId').getValue(),
			OrgId:Ext.getCmp('OrgId').getValue(),
			WsId:Ext.getCmp('WsId').getValue(),
			AuxWhId:Ext.getCmp('AuxWhId').getValue(),
			AuxProductId:Ext.getCmp('AuxProductId').getValue(),
			Qty:Ext.getCmp('Qty').getValue(),
			InitOrderId:Ext.getCmp('InitOrderId').getValue(),
			IsOutOrder:Ext.getCmp('IsOutOrder').getValue(),
			CreateDate:Ext.getCmp('CreateDate').getValue(),
			UpdateDate:Ext.getCmp('UpdateDate').getValue(),
			OperId:Ext.getCmp('OperId').getValue(),
			OwnerId:Ext.getCmp('OwnerId').getValue(),
			Remark:Ext.getCmp('Remark').getValue()		},
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
		url:'frmPmsStockOrderList.aspx?method=getorder',
		params:{
			OrderId:selectData.data.OrderId
		},
	success: function(resp,opts){
		var data=Ext.util.JSON.decode(resp.responseText);
		Ext.getCmp("OrderId").setValue(data.OrderId);
		Ext.getCmp("OrgId").setValue(data.OrgId);
		Ext.getCmp("WsId").setValue(data.WsId);
		Ext.getCmp("AuxWhId").setValue(data.AuxWhId);
		Ext.getCmp("AuxProductId").setValue(data.AuxProductId);
		Ext.getCmp("Qty").setValue(data.Qty);
		Ext.getCmp("InitOrderId").setValue(data.InitOrderId);
		Ext.getCmp("IsOutOrder").setValue(data.IsOutOrder);
		Ext.getCmp("CreateDate").setValue(data.CreateDate);
		Ext.getCmp("UpdateDate").setValue(data.UpdateDate);
		Ext.getCmp("OperId").setValue(data.OperId);
		Ext.getCmp("OwnerId").setValue(data.OwnerId);
		Ext.getCmp("Remark").setValue(data.Remark);
	},
	failure: function(resp,opts){
		Ext.Msg.alert("��ʾ","��ȡ�û���Ϣʧ��");
	}
	});
}
/*------�������ý������ݵĺ��� End---------------*/

/*------��ʼ��ȡ���ݵĺ��� start---------------*/
var dspmsstockorder = new Ext.data.Store
({
url: 'frmPmsStockOrderList.aspx?method=getOrderList',
reader:new Ext.data.JsonReader({
	totalProperty:'totalProperty',
	root:'root'
},[
	{		name:'OrderId'	},
	{		name:'OrgId'	},
	{		name:'WsId'	},
	{		name:'AuxWhId'	},
	{		name:'AuxProductId'	},
	{		name:'Qty'	},
	{		name:'InitOrderId'	},
	{		name:'IsOutOrder'	},
	{		name:'CreateDate'	},
	{		name:'UpdateDate'	},
	{		name:'OperId'	},
	{		name:'OwnerId'	},
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
var pmsstockorderGrid = new Ext.grid.GridPanel({
	el: 'dataGrid',
	width:'100%',
	height:'100%',
	autoWidth:true,
	autoHeight:true,
	autoScroll:true,
	layout: 'fit',
	id: '',
	store: dspmsstockorder,
	loadMask: {msg:'���ڼ������ݣ����Ժ��'},
	sm:sm,
	cm: new Ext.grid.ColumnModel([
		sm,
		new Ext.grid.RowNumberer(),//�Զ��к�
		{
			header:'������',
			dataIndex:'OrderId',
			id:'OrderId'
		},
		{
			header:'��֯��ʶ',
			dataIndex:'OrgId',
			id:'OrgId'
		},
		{
			header:'�����ʶ',
			dataIndex:'WsId',
			id:'WsId'
		},
		{
			header:'���ϲֿ��ʶ',
			dataIndex:'AuxWhId',
			id:'AuxWhId'
		},
		{
			header:'���ϱ�ʶ',
			dataIndex:'AuxProductId',
			id:'AuxProductId'
		},
		{
			header:'����',
			dataIndex:'Qty',
			id:'Qty'
		},
		{
			header:'ԭʼ����',
			dataIndex:'InitOrderId',
			id:'InitOrderId'
		},
		{
			header:'�Ƿ����',
			dataIndex:'IsOutOrder',
			id:'IsOutOrder'
		},
		{
			header:'����ʱ��',
			dataIndex:'CreateDate',
			id:'CreateDate'
		},
		{
			header:'����ʱ��',
			dataIndex:'UpdateDate',
			id:'UpdateDate'
		},
		{
			header:'�����߱�ʶ',
			dataIndex:'OperId',
			id:'OperId'
		},
		{
			header:'�����߱�ʶ',
			dataIndex:'OwnerId',
			id:'OwnerId'
		},
		{
			header:'��ע',
			dataIndex:'Remark',
			id:'Remark'
		}		]),
		bbar: new Ext.PagingToolbar({
			pageSize: 10,
			store: dspmsstockorder,
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
pmsstockorderGrid.render();
/*------DataGrid�ĺ������� End---------------*/



})
</script>

</html>
