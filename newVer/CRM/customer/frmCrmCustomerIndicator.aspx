<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmCrmCustomerIndicator.aspx.cs" Inherits="CRM_customer_frmCrmCustomerIndicator" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html>
<head>
<title>�ͻ�����ָ��</title><meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<link rel="stylesheet" type="text/css" href="../../ext3/resources/css/ext-all.css" />
<script type="text/javascript" src="../../ext3/adapter/ext/ext-base.js"></script>
<script type="text/javascript" src="../../ext3/ext-all.js"></script>
<script type="text/javascript" src="../../js/operateResp.js"></script>
</head>
<body>
<div id='toolbar'></div>
<div id='searchForm'></div>
<div id='dataGrid'></div>
<%=getComboBoxStore( ) %>
</body>
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
		    saveType = "addIndicator";
		    openAddIndicatorWin();
		}
		},'-',{
		text:"�༭",
		icon:"../../Theme/1/images/extjs/customer/edit16.gif",
		handler:function(){
		    saveType = "saveIndicator";
		    modifyIndicatorWin();
		}
	}]
});

/*------����toolbar�ĺ��� end---------------*/


/*------��ʼToolBar�¼����� start---------------*//*-----����Indicatorʵ���ര�庯��----*/
function openAddIndicatorWin() {
	uploadIndicatorWindow.show();
}
/*-----�༭Indicatorʵ���ര�庯��----*/
function modifyIndicatorWin() {
	var sm = IndicatorGrid.getSelectionModel();
	//��ȡѡ���������Ϣ
	var selectData =  sm.getSelected();
	if(selectData == null){
		Ext.Msg.alert("��ʾ","��ѡ����Ҫ�༭����Ϣ��");
		return;
	}
	uploadIndicatorWindow.show();
	setFormValue(selectData);
}
/*------ʵ��FormPanle�ĺ��� start---------------*/
var yearStore = new Ext.data.SimpleStore({
   fields: ['id', 'name'],        
   data : [        
   ['1', 'һ��']
   ]});
var yearRowPatter = Ext.data.Record.create([
           { name: 'id', type: 'string' },
           { name: 'name', type: 'string' }
          ]);
yearStore.removeAll();
var currentYear = (new Date()).getFullYear();
currentYear = parseInt(currentYear)+1;
for(var i=2009;i<currentYear;i++)
{
    var year = new yearRowPatter({id:i,name:i});
    yearStore.add(year);
}
var IndicatorForm=new Ext.form.FormPanel({
	frame:true,
	title:'',
	labelWidth:55,
	items:[
	{
	    layout:'column',
	    items:[
		{
		    layout:'form',		    
			columnWidth:.5,
		    items:[
		    {
			    xtype:'hidden',
			    fieldLabel:'ָ��ID',
			    name:'IndicatorId',
			    id:'IndicatorId',
			    hidden:true,
			    hideLabel:true
		    }
            ,{
			    xtype:'combo',
			    fieldLabel:'�ͻ�����',
			    anchor:'98%',
			    name:'CustomerMangerId',
			    id:'CustomerMangerId',
			    store:dsEmployee,
			    displayField:'EmpName',
			    valueField:'EmpId',
			    triggerAction:'all',
			    mode:'local'
		    }]
		},
		{
		    layout:'form',		    
			columnWidth:.5,
		    items:[
		    {
			    xtype:'combo',
			    fieldLabel:'�������',
			    anchor:'98%',
			    name:'IndicatorType',
			    id:'IndicatorType',
			    store:[[0,'���д��'],[1,'����'],[2,'������']],
			    mode:'local',
			    triggerAction:'all',
			    editable:false
		    }]
		}]
    }
    ,{
        layout:'column',
	    items:[
		{
		    layout:'form',		    
			columnWidth:.33,
		    items:[
		    {
			    xtype:'numberfield',
			    fieldLabel:'�ͻ���',
			    anchor:'98%',
			    name:'Customers',
			    id:'Customers',
			    decimalPrecision:0
		    }]
		},		
		{
		    layout:'form',		    
			columnWidth:.33,
		    items:[
		    {
			    xtype:'numberfield',
			    fieldLabel:'������',
			    anchor:'98%',
			    name:'Orders',
			    id:'Orders',
			    decimalPrecision:0
			}]
		},		
		{
		    layout:'form',		    
			columnWidth:.34,
		    items:[
		    {
			    xtype:'numberfield',
			    fieldLabel:'�������',
			    anchor:'98%',
			    name:'OrderAmount',
			    id:'OrderAmount',
			    decimalPrecision:8
			}]
		}]
    },
    {
        layout:'column',
	    items:[
	    {
		    layout:'form',		    
			columnWidth:.34,
		    items:[
		    {
			    xtype:'combo',
			    fieldLabel:'���',
			    anchor:'98%',
			    name:'IndicatorPeriod',
			    id:'IndicatorPeriod',
			    store:yearStore,
			    displayField:'name',
			    valueField:'id',
			    mode:'local',
			    triggerAction:'all'
			}]
		},
		{
		    layout:'form',		    
			columnWidth:.33,
		    items:[
    		{
			    xtype:'combo',
			    fieldLabel:'�Ƿ�����',
			    anchor:'98%',
			    name:'IsEnable',
			    id:'IsEnable',
			    store:[[1,'����'],[0,'������']],
			    mode:'local',
			    triggerAction:'all',
			    editable:false
		    }]
		}]
    },		
    {
        layout:'column',
	    items:[
		{
		    layout:'form',		    
			columnWidth:1,
		    items:[
    		{
			    xtype:'textarea',
			    fieldLabel:'��ע',
			    anchor:'98%',
			    name:'Remark',
			    id:'Remark'
			}]
		}]
    }
]
});
/*------FormPanle�ĺ������� End---------------*/

/*------��ʼ�������ݵĴ��� Start---------------*/
if(typeof(uploadIndicatorWindow)=="undefined"){//�������2��windows����
	uploadIndicatorWindow = new Ext.Window({
		id:'Indicatorformwindow',
		title:'ָ���ƶ�'
		, iconCls: 'upload-win'
		, width: 600
		, height: 280
		, layout: 'fit'
		, plain: true
		, modal: true
		, constrain:true
		, resizable: false
		, closeAction: 'hide'
		,autoDestroy :true
		,items:IndicatorForm
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
				uploadIndicatorWindow.hide();
			}
			, scope: this
		}]});
	}
	uploadIndicatorWindow.addListener("hide",function(){
	    IndicatorForm.getForm().reset();
});

/*------��ʼ��ȡ�������ݵĺ��� start---------------*/
function saveUserData()
{
	Ext.Ajax.request({
		url:'frmCrmCustomerIndicator.aspx?method='+saveType,
		method:'POST',
		params:{
			IndicatorId:Ext.getCmp('IndicatorId').getValue(),
			CustomerMangerId:Ext.getCmp('CustomerMangerId').getValue(),
			IndicatorType:Ext.getCmp('IndicatorType').getValue(),
			Customers:Ext.getCmp('Customers').getValue(),
			Orders:Ext.getCmp('Orders').getValue(),
			OrderAmount:Ext.getCmp('OrderAmount').getValue(),
			IsEnable:Ext.getCmp('IsEnable').getValue(),
			IndicatorPeriod:Ext.getCmp('IndicatorPeriod').getValue(),
			Remark:Ext.getCmp('Remark').getValue()
			},
		success: function(resp,opts){
			if(checkExtMessage(resp)){
			    IndicatorGrid.getStore().reload();
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
		url:'frmCrmCustomerIndicator.aspx?method=getIndicator',
		params:{
			IndicatorId:selectData.data.IndicatorId
		},
	success: function(resp,opts){
		var data=Ext.util.JSON.decode(resp.responseText);
		Ext.getCmp("IndicatorId").setValue(data.IndicatorId);
		Ext.getCmp("CustomerMangerId").setValue(data.CustomerMangerId);
		Ext.getCmp("IndicatorType").setValue(data.IndicatorType);
		Ext.getCmp("Customers").setValue(data.Customers);
		Ext.getCmp("Orders").setValue(data.Orders);
		Ext.getCmp("OrderAmount").setValue(data.OrderAmount);
		Ext.getCmp("IsEnable").setValue(data.IsEnable);
		Ext.getCmp("IndicatorPeriod").setValue(data.IndicatorPeriod);
		Ext.getCmp("Remark").setValue(data.Remark);
	},
	failure: function(resp,opts){
		Ext.Msg.alert("��ʾ","��ȡ�û���Ϣʧ��");
	}
	});
}
/*------�������ý������ݵĺ��� End---------------*/
/*------��ʼ��ѯform end---------------*/   
var CustYearPanel = new Ext.form.ComboBox({
    style: 'margin-left:0px',
    cls: 'key',
    xtype: 'combo',
    fieldLabel: '���',
    name: 'Year',
    anchor: '95%',
    store:yearStore,
    displayField:'name',
    valueField:'id',
    mode:'local',
    triggerAction:'all'
});
var CustManagerPanel = new Ext.form.TextField({
    style: 'margin-left:0px',
    cls: 'key',
    xtype: 'textfield',
    fieldLabel: '�ͻ�����',
    name: 'CustManager',
    anchor: '95%'
});

var serchform = new Ext.FormPanel({
    renderTo: 'searchForm',
    labelAlign: 'left',
    layout:'fit',
    buttonAlign: 'right',
    bodyStyle: 'padding:5px',
    frame: true,
    labelWidth: 80,
    items: [{
        layout: 'column',   //�����Ԫ��Ϊ����Ϊ�в��ַ�ʽ
        border: false,
        items: [
        {
            name: 'cusStyle',
            columnWidth: .2,
            layout: 'form',
            border: false,
            labelWidth: 55,
            items: [
                CustYearPanel
            ]
        },{
            name: 'cusStyle',
            columnWidth: .25,
            layout: 'form',
            border: false,
            labelWidth: 55,
            items: [
                CustManagerPanel
            ]
        }, {
            columnWidth: .08,
            layout: 'form',
            border: false,
            items: [{ cls: 'key',
                xtype: 'button',
                text: '��ѯ',
                anchor: '50%',
                handler :function(){
                
                var CustManager=CustManagerPanel.getValue();
                var CustYear = CustYearPanel.getValue();
                
                dsIndicatorGrid.baseParams.CustManager=CustManager;
                dsIndicatorGrid.baseParams.IndicatorPeriod= CustYear;
                
                dsIndicatorGrid.load({
                            params : {
                            start : 0,
                            limit : 10
                            } });
                }
            }]
        }]
    }]
});
/*------��ʼ��ѯform end---------------*/
/*------��ʼ��ȡ���ݵĺ��� start---------------*/
var dsIndicatorGrid = new Ext.data.Store
({
url: 'frmCrmCustomerIndicator.aspx?method=getIndicatorList',
reader:new Ext.data.JsonReader({
	totalProperty:'totalProperty',
	root:'root'
},[
	{		name:'IndicatorId'	},
	{		name:'CustomerMangerId'	},
	{		name:'IndicatorType'	},
	{		name:'Customers'	},
	{		name:'Orders'	},
	{		name:'OrderAmount'	},
	{		name:'IsEnable'	},
	{		name:'ValidDate'	},
	{		name:'ExpireDate'	},
	{		name:'Remark'	},
	{		name:'OperId'	},
	{		name:'OrgId'	},
	{		name:'CreateDate'	},
	{		name:'UpdateDate'	},
	{       name:'IndicatorPeriod'},
	{		name:'CustomerManger'	}	
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
var IndicatorGrid= new Ext.grid.GridPanel({
	el: 'dataGrid',
	width:'100%',
	height:'100%',
	autoWidth:true,
	autoHeight:true,
	autoScroll:true,
	layout: 'fit',
	id: '',
	store: dsIndicatorGrid,
	loadMask: {msg:'���ڼ������ݣ����Ժ��'},
	sm:sm,
	cm: new Ext.grid.ColumnModel([
		sm,
		new Ext.grid.RowNumberer(),//�Զ��к�
		{
			header:'ָ��ID',
			dataIndex:'IndicatorId',
			id:'IndicatorId',
			hidden:true,
			hideable:false
		},
		{
			header:'�ͻ�����',
			dataIndex:'CustomerMangerId',
			id:'CustomerMangerId',
			renderer:function(v){
			    var ret = '';
			    dsEmployee.each(function(record){
			        if(record.data.EmpId==v)
			            ret= record.data.EmpName;
			            return;
			    });
			    return ret;
			}
		},
		{
			header:'�������',
			dataIndex:'IndicatorType',
			id:'IndicatorType',
			renderer:function(v){
			    if(v==0)return '���д��';
			    if(v==1)return '����';
			    if(v==2)return '������';
			}
		},
		{
			header:'�ͻ���',
			dataIndex:'Customers',
			id:'Customers'
		},
		{
			header:'������',
			dataIndex:'Orders',
			id:'Orders'
		},
		{
			header:'���������',
			dataIndex:'OrderAmount',
			id:'OrderAmount'
		},
		{
			header:'�Ƿ�����',
			dataIndex:'IsEnable',
			id:'IsEnable',
			renderer:function(v){
			    if(v==1)return '����';
			    if(v==0)return 'δ����';
			}
		},
		{
			header:'��Чʱ��',
			dataIndex:'ValidDate',
			id:'ValidDate',
			format:'Y��m��d��',
			renderer: Ext.util.Format.dateRenderer('Y��m��d��')
		},
		{
			header:'ʧЧʱ��',
			dataIndex:'ExpireDate',
			id:'ExpireDate',
			format:'Y��m��d��',
			renderer: Ext.util.Format.dateRenderer('Y��m��d��')
		}
		]),
		bbar: new Ext.PagingToolbar({
			pageSize: 10,
			store: dsIndicatorGrid,
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
IndicatorGrid.render();
/*------DataGrid�ĺ������� End---------------*/



})
</script>
</html>

