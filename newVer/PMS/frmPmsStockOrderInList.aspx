<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmPmsStockOrderInList.aspx.cs" Inherits="PMS_frmPmsStockOrder" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html>
<head>
<title>���������Ǽ�</title><meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<link rel="stylesheet" type="text/css" href="../ext3/resources/css/ext-all.css" />
<script type="text/javascript" src="../ext3/adapter/ext/ext-base.js"></script>
<script type="text/javascript" src="../ext3/ext-all.js"></script>
</head>
<body>
<div id='toolbar'></div>
<div id='divForm'></div>
<div id='dataGrid'></div>
<%=getComboBoxStore() %>
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
		    saveType ='addOrder';
		    openAddOrderWin();
		}
		},'-',{
		text:"�༭",
		icon:"../Theme/1/images/extjs/customer/edit16.gif",
		handler:function(){
		    saveType ='saveOrder';
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
var sm = pmsstockorderGrid.getSelectionModel();
                //��ѡ
                var selectData = sm.getSelections();                
                var array = new Array(selectData.length);
                var orderIds = "";
                for(var i=0;i<selectData.length;i++)
                {
                    if(orderIds.length>0)
                        orderIds+=",";
                    orderIds += selectData[i].get('OrderId');
                }
                //ҳ���ύ
                Ext.Ajax.request({
                    url: 'frmPmsStockOrderInList.aspx?method=getprintdata',
//                    url:'frmOrderMst.aspx?method=billdata',
                    method: 'POST',
                    params: {
                        OrderId: orderIds
                    },
                   success: function(resp,opts){ 
                       var printData =  resp.responseText;
                       var printControl =  parent.parent.parent.document.getElementById("topFrame").contentWindow.getPrintControl();
                       printControl.Url =getUrl('xml');
                       printControl.MapUrl = printControl.Url+'/'+printStyleXml;//'/salePrint1.xml';
                       printControl.PrintXml = printData;
                       printControl.ColumnName="OrderId";
                       printControl.OnlyData=printOnlyData;
                       printControl.PageWidth=printPageWidth;
                       printControl.PageHeight =printPageHeight ;
                       printControl.Print();
                       
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
	var sm = pmsstockorderGrid.getSelectionModel();
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
				url:'frmPmsStockOrderInList.aspx?method=deleteOrder',
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

//�����������첽���÷���,��ǰ�ͻ��ɶ���Ʒ�б�
        var dsProductUnits = new Ext.data.Store({
            url: '../scm/frmOrderDtl.aspx?method=getProductUnits',
            params: {
                ProductId: 0
            },
            reader: new Ext.data.JsonReader({
                root: 'root',
                totalProperty: 'totalProperty',
                id: 'ProductUnits'
            }, [
                { name: 'UnitId', mapping: 'UnitId' },
                { name: 'UnitName', mapping: 'UnitName' }
            ]),
            listeners: {
                load: function() {
                    var combo = Ext.getCmp('OutStor');
                    combo.setValue(combo.getValue());
                }
            }
        });
        dsProductUnits.load();

        function beforeEdit() {
            var productId = Ext.getCmp('AuxProductId').getValue();
            if (productId != dsProductUnits.baseParams.ProductId) {
                dsProductUnits.baseParams.ProductId = productId;
                dsProductUnits.load();
            }
        }
        
/*------ʵ��FormPanle�ĺ��� start---------------*/
var pmsstockorderform=new Ext.form.FormPanel({
	url:'',
	frame:true,
	title:'',
	labelWidth:55,
	items:[
		{
			xtype:'hidden',
			fieldLabel:'������',
			name:'OrderId',
			id:'OrderId',
			hidden:true,
			hideLabel:false
		}
,		{
            layout:'column',
            items:[
            {
                layout:'form',
                columnWidth:.48,
                items:[
                {
                    xtype:'combo',
			        fieldLabel:'����',
			        anchor:'98%',
			        name:'WsId',
			        id:'WsId',
	                store:dsWs,
	                displayField:'WsName',
                    valueField:'WsId',
                    mode:'local',
                    triggerAction:'all',
                    editable: false
                }
                ]
            },
            {               
                layout:'form',
                columnWidth:.48,
                items:[
                {
                    xtype:'combo',
		            fieldLabel:'�ֿ�',
		            columnWidth:1,
		            anchor:'98%',
		            name:'AuxWhId',
		            id:'AuxWhId',
		            store:dsWarehouseList,
	                displayField:'WhName',
                    valueField:'WhId',
                    mode:'local',
                    triggerAction:'all',
                    editable: false
                }
                ]
            }
            ]			
		}
,		{
            layout:'column',
            items:[
            {
                layout:'form',
                columnWidth:.48,
                items:[
                {
			        xtype:'combo',
			        fieldLabel:'��Ʒ',
			        columnWidth:1,
			        anchor:'98%',
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
                    editable: true,
                    listeners: {
                        "select": beforeEdit
                    }
			        
			    }
			    ]
			},
			{
			    layout:'form',
                columnWidth:.28,
                items:[
                {
                    xtype:'numberfield',
			        fieldLabel:'����',
			        columnWidth:1,
			        anchor:'98%',
			        name:'Qty',
			        id:'Qty'
			    }
			    ]
			}, {
			    layout: 'form',
			    columnWidth: .2,
			    items: [
                {
                    xtype: 'combo',
                    store: dsProductUnits, //dsWareHouse,
                    valueField: 'UnitId',
                    displayField: 'UnitName',
                    mode: 'local',
                    forceSelection: true,
                    editable: false,
                    name: 'OutStor',
                    id: 'OutStor',
                    emptyValue: '',
                    triggerAction: 'all',
                    //fieldLabel: '��λ',
                    hideLabel:true,
                    selectOnFocus: true,
                    anchor: '98%'
                }
			    ]
}]
		}
,		{
            layout:'column',
            items:[
            {
                layout:'form',
                columnWidth:.3,
                items:[
                {
			        xtype:'combo',
			        fieldLabel:'��������',
			        columnWidth:1,
			        anchor:'95%',
			        name:'IsOutOrder',
			        id:'IsOutOrder',
                    store: dsStatus,
                    displayField: 'DicsName',
                    valueField: 'DicsCode',
                    triggerAction: 'all',
                    typeAhead: true,
                    mode: 'local',
                    emptyText: '',
                    selectOnFocus: false,                    
                    value:dsStatus.getAt(0).data.DicsCode,
                    disabled: true
			    }]
			},
			{
			    layout:'form',
                columnWidth:.685,
                items:[
                {
			        xtype:'textfield',
			        fieldLabel:'ԭʼ����',
			        columnWidth:1,
			        anchor:'95%',
			        name:'InitOrderId',
			        id:'InitOrderId'
			    }]
			}
			]
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
if(typeof(uploadOrderWindow)=="undefined"){//�������2��windows����
	uploadOrderWindow = new Ext.Window({
		id:'Orderformwindow',
		title:''
		, iconCls: 'upload-win'
		, width: 600
		, height: 250
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
	    pmsstockorderform.getForm().reset();
});

/*------��ʼ��ȡ�������ݵĺ��� start---------------*/
function saveUserData()
{

	Ext.Ajax.request({
		url:'frmPmsStockOrderInList.aspx?method='+saveType,
		method:'POST',
		params:{
			OrderId:Ext.getCmp('OrderId').getValue(),
			WsId:Ext.getCmp('WsId').getValue(),
			AuxWhId:Ext.getCmp('AuxWhId').getValue(),
			AuxProductId:Ext.getCmp('AuxProductId').getValue(),
			Qty:Ext.getCmp('Qty').getValue(),
			InitOrderId:Ext.getCmp('InitOrderId').getValue(),
			IsOutOrder:Ext.getCmp('IsOutOrder').getValue(),
			Remark:Ext.getCmp('Remark').getValue(),
			UnitId:Ext.getCmp('OutStor').getValue()
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
		url:'frmPmsStockOrderInList.aspx?method=getorder',
		params:{
			OrderId:selectData.data.OrderId
		},
	success: function(resp,opts){
		var data=Ext.util.JSON.decode(resp.responseText);
		Ext.getCmp("OrderId").setValue(data.OrderId);
		Ext.getCmp("WsId").setValue(data.WsId);
		Ext.getCmp("AuxWhId").setValue(data.AuxWhId);
		Ext.getCmp("AuxProductId").setValue(data.AuxProductId);
		beforeEdit();
		Ext.getCmp("Qty").setValue(data.Qty);
		Ext.getCmp("InitOrderId").setValue(data.InitOrderId);
		Ext.getCmp("IsOutOrder").setValue(data.IsOutOrder);
		Ext.getCmp("Remark").setValue(data.Remark);
		Ext.getCmp("OutStor").setValue(data.UnitId);
	},
	failure: function(resp,opts){
		Ext.Msg.alert("��ʾ","��ȡ�û���Ϣʧ��");
	}
	});
}
/*------�������ý������ݵĺ��� End---------------*/
/*------��ʼ��ѯform end---------------*/
//��������
var WsNamePanel = new Ext.form.ComboBox({
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
var iniOrderIdPanel = new Ext.form.TextField({
    xtype:'textfield',
    fieldLabel:'ԭʼ���ݱ��',
    anchor:'95%'
});
//�ֿ�
var ckCombo = new Ext.form.ComboBox({
    xtype:'combo',
    fieldLabel:'�ֿ�',
    anchor:'95%',
    store:dsWarehouseList,
    displayField:'WhName',
    valueField:'WhId',
    mode:'local',
    triggerAction:'all',
    editable: false
});

//��Ʒ
var productCombo = new Ext.form.ComboBox({
    xtype:'combo',
    fieldLabel:'��Ʒ',
    anchor:'95%',
    store: dsProductList,
    displayField: 'ProductName',
    valueField: 'ProductId',
    triggerAction: 'all',
    typeAhead: true,
    mode: 'local',
    emptyText: '',
    selectOnFocus: false,
    editable: true
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
                WsNamePanel
            ]
        }, {
            columnWidth: .4,
            layout: 'form',
            border: false,
            labelWidth: 80,
            items: [
                iniOrderIdPanel
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
                ckCombo
            ]
        },{
            name: 'cusStyle',
            columnWidth: .4,
            layout: 'form',
            border: false,
            labelWidth: 80,
            items: [
                productCombo
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
                
                var strWsId=WsNamePanel.getValue();
                var striniOrderId=iniOrderIdPanel.getValue();
                var WhId=ckCombo.getValue();
                var ProductId=productCombo.getValue();
                
                dspmsstockorder.baseParams.WorkshopId=strWsId;
                dspmsstockorder.baseParams.IniOrderId=striniOrderId;
                dspmsstockorder.baseParams.WhId=WhId;
                dspmsstockorder.baseParams.ProductId=ProductId;
                dspmsstockorder.baseParams.IsOutOrder='in';
                
                dspmsstockorder.load({
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
var dspmsstockorder = new Ext.data.Store
({
url: 'frmPmsStockOrderInList.aspx?method=getOrderList',
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
			id:'OrderId',
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
			header:'�ֿ�',
			dataIndex:'AuxWhId',
			id:'AuxWhId',
			renderer:function(val){
			    dsWarehouseList.each(function(r) {
		            if (val == r.data['WhId']) {
		                val = r.data['WhName'];
		                return;
		            }
		        });
		        return val;
			}	
		},
		{
			header:'��Ʒ',
			dataIndex:'AuxProductId',
			id:'AuxProductId',
			renderer:function(val){
			    dsProductList.each(function(r) {
		            if (val == r.data['ProductId']) {
		                val = r.data['ProductName'];
		                return;
		            }
		        });
		        return val;
			}	
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
			header:'��������',
			dataIndex:'IsOutOrder',
			id:'IsOutOrder',
			renderer:function(val){
			    dsStatus.each(function(r) {
		            if (val == r.data['DicsCode']) {
		                val = r.data['DicsName'];
		                return;
		            }
		        });
		        return val;
			}			
		},
		{
			header:'����ʱ��',
			dataIndex:'CreateDate',
			id:'CreateDate'
		}
		]),
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
