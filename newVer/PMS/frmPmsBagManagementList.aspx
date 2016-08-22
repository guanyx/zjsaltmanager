<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmPmsBagManagementList.aspx.cs" Inherits="PMS_frmPmsBagManagemen" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html>
<head>
<title>��֯����ת�Ǽǹ���</title><meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
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
Ext.BLANK_IMAGE_URL = "../ext3/resources/images/default/s.gif";
Ext.onReady(function(){
var followState;
var saveType;
//form
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
//��ʼʱ��
var ksrq = new Ext.form.DateField({
    xtype:'datefield',
    fieldLabel:'��ʼʱ��',
    anchor:'95%',
    format: 'Y��m��d�� H:i:s',  //���������ʽ
    value:new Date() 
});

//����ʱ��
var jsrq = new Ext.form.DateField({
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
                ksrq
            ]
        },{
            name: 'cusStyle',
            columnWidth: .4,
            layout: 'form',
            border: false,
            labelWidth: 80,
            items: [
                jsrq
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
                var strStartTime=ksrq.getValue();
                var strEndTime=jsrq.getValue();
                
                dspmsbagmanagent.baseParams.WorkshopId=strWsId;
                dspmsbagmanagent.baseParams.IniOrderId=striniOrderId;
                dspmsbagmanagent.baseParams.StartTime=Ext.util.Format.date(strStartTime,'Y/m/d');
                dspmsbagmanagent.baseParams.EndTime=Ext.util.Format.date(strEndTime,'Y/m/d H:i:s');
                dspmsbagmanagent.baseParams.followState=followState;
                
                dspmsbagmanagent.load({
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

//grid
/*------��ʼ��ȡ���ݵĺ��� start---------------*/
var dspmsbagmanagent = new Ext.data.Store
({
url: 'frmPmsBagManagementList.aspx?method=getManagementList',
reader:new Ext.data.JsonReader({
	totalProperty:'totalProperty',
	root:'root'
},[
	{		name:'Id'	},
	{		name:'WsId'	},
	{		name:'IsDamaged'	},
	{		name:'Qty'	},
	{		name:'InitOrderId'	},
	{		name:'Remark'	},
	{		name:'FlowLink'	},
	{		name:'BusiType'	},
	{		name:'ProductName'	},
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
var cm1 = new Ext.grid.ColumnModel([
		sm,
		new Ext.grid.RowNumberer(),//�Զ��к�
		{
			header:'��ˮ��',
			dataIndex:'Id',
			id:'Id',
			hidden:true,
			hideable:false
		},
		{
			header:'����',
			dataIndex:'WsId',
			id:'WsId',
			width:80,
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
			header:'�Ƿ�����',
			dataIndex:'IsDamaged',
			id:'IsDamaged',
			width:50,
			renderer:function(v){
			    if(v==1)
			        return '��';
			    else
			        return '��';
			}
		},
		{
			header:'����',
			width:50,
			dataIndex:'Qty',
			id:'Qty'
		},
		{
			header:'ԭʼ����',
			width:50,
			dataIndex:'InitOrderId',
			id:'InitOrderId'
		},
		{
			header:'��ת����',
			dataIndex:'FlowLink',
			id:'FlowLink',
			width:50,
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
			header:'״̬',
			dataIndex:'BusiType',
			id:'BusiType',
			width:50,
			renderer:function(val){
			    if(val == 'P032') val ='��ʼ�Ǽ�';
			    if(val == 'P033') val ='��ת������';
			    if(val == 'P034') val ='���̽���';
			    if(val == 'P035') val ='���Ƴ�Ʒ';
		        return val;
			}
		},
		{
			header:'��Ʒ',
			width:120,
			dataIndex:'ProductName',
			id:'ProductName',
			renderer:function(v){
			    return v;
			}
		},
		{
			header:'����ʱ��',
			width:80,
			dataIndex:'CreateDate',
			id:'CreateDate'
		}		
]);
var cm2 = new Ext.grid.ColumnModel([
		sm,
		new Ext.grid.RowNumberer(),//�Զ��к�
		{
			header:'��ˮ��',
			dataIndex:'Id',
			id:'Id',
			hidden:true,
			hideable:false
		},
		{
			header:'����',
			dataIndex:'WsId',
			id:'WsId',
			width:80,
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
			header:'�Ƿ�����',
			dataIndex:'IsDamaged',
			id:'IsDamaged',
			width:50,
			renderer:function(v){
			    if(v==1)
			        return '��';
			    else
			        return '��';
			}
		},
		{
			header:'����',
			width:50,
			dataIndex:'Qty',
			id:'Qty'
		},
		{
			header:'ԭʼ����',
			width:50,
			dataIndex:'InitOrderId',
			id:'InitOrderId'
		},
		{
			header:'��ת����',
			dataIndex:'FlowLink',
			id:'FlowLink',
			width:50,
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
			width:80,
			dataIndex:'CreateDate',
			id:'CreateDate'
		}		
]);
var pmsbagmanagentGrid = new Ext.grid.GridPanel({
    el:'dataGrid',
	width:'100%',
	height:'100%',
	autoWidth:true,
	autoHeight:true,
	autoScroll:true,
	layout: 'fit',
	id: 'pmsbagmanagentGrid',
	store: dspmsbagmanagent,
	loadMask: {msg:'���ڼ������ݣ����Ժ��'},
	sm:sm,
	cm: cm1,
	bbar: new Ext.PagingToolbar({
		pageSize: 10,
		store: dspmsbagmanagent,
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
pmsbagmanagentGrid.render();
/*------DataGrid�ĺ������� End---------------*/

/* clear */
function resetformandgridvalue(){
    WsNamePanel.setValue("");
    iniOrderIdPanel.setValue("");
    ksrq.setValue(new Date());
    jsrq.setValue(new Date());    
    
    pmsbagmanagentGrid.getStore().removeAll();
}
function setfollowState(state){
    followState = state;
    
    var dynamicCm;
    if(state=='four')
        dynamicCm = cm1;
    else 
        dynamicCm = cm2;
        
    //���°�grid
    pmsbagmanagentGrid.reconfigure(dspmsbagmanagent, dynamicCm);
    //���°󶨷�ҳ������
    pmsbagmanagentGrid.getBottomToolbar().bind(dspmsbagmanagent);
    
}
/*-----�༭Managementʵ���ര�庯��----*/
var productCombo = new Ext.form.ComboBox({
    fieldLabel:"��Ʒ����",//�ı������
    columnWidth:1,
    id:'pcobox',
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
function modifyManagementWin() {
	var sm = pmsbagmanagentGrid.getSelectionModel();
	//��ȡѡ���������Ϣ
	var selectData =  sm.getSelected();
	if(selectData == null){
		Ext.Msg.alert("��ʾ","��ѡ����Ҫ�༭����Ϣ��");
		return;
	}
	//�ж�
	if(saveType.indexOf('edit')>-1){
	    //alert(selectData.data.BusiType);
	    if(selectData.data.FlowLink != ret_flowLink(followState)){
            Ext.Msg.alert("��ʾ","�Ǳ��������ӵļ�¼�����޸ģ�");
            return;
        }
    	
        if(selectData.data.BusiType != 'P032'){
            Ext.Msg.alert("��ʾ","����ת���¼�����޸ģ�");
            return;
        }
    }
    if(saveType.indexOf('sale')>-1){
        if(selectData.data.FlowLink != ret_flowLink('two'))
            return;
        if(selectData.data.BusiType != 'P032'){
            Ext.Msg.alert("��ʾ","����ת���¼�������ۣ�");
            return;
        }
    }
    if(saveType.indexOf('produce')>-1){
        if(selectData.data.FlowLink != ret_flowLink('four'))
            return;
        if(selectData.data.BusiType != 'P032'){
            Ext.Msg.alert("��ʾ","����תδ������");
            return;
        }
        if(pmsbagmanagementform.findById('pcobox')==null)
            pmsbagmanagementform.add(productCombo);        
    }
    if(saveType.indexOf('accept')>-1){
        if(selectData.data.FlowLink != ret_lastflowLink(followState))
            return;
    }
    
	uploadManagementWindow.show();
	setFormValue(selectData);
}
/*------��ʼ�������ݵĺ��� Start---------------*/
function setFormValue(selectData)
{
	Ext.Ajax.request({
		url:'frmPmsBagManagementList.aspx?method=getmanagement',
		params:{
			Id:selectData.data.Id
		},
	success: function(resp,opts){
		var data=Ext.util.JSON.decode(resp.responseText);
		Ext.getCmp("Id").setValue(data.Id);
		Ext.getCmp("WsId").setValue(data.WsId);
		Ext.getCmp("IsDamaged").setValue(data.IsDamaged);
		Ext.getCmp("Qty").setValue(data.Qty);
		Ext.getCmp("InitOrderId").setValue(data.InitOrderId);
		Ext.getCmp("Remark").setValue(data.Remark);
		if(saveType.indexOf('edit')>-1)
		    Ext.getCmp("FlowLink").setValue(data.FlowLink);
	},
	failure: function(resp,opts){
		Ext.Msg.alert("��ʾ","��ȡ�û���Ϣʧ��");
	}
	});
}
/*------ʵ��FormPanle�ĺ��� start---------------*/
var pmsbagmanagementform=new Ext.form.FormPanel({
	url:'',
	frame:true,
	title:'',
	items:[
		{
			xtype:'hidden',
			fieldLabel:'��ˮ��',
			name:'Id',
			id:'Id',
			hidden:true,
			hideLabel:false
		}
,		{
			xtype:'combo',
			fieldLabel:'�����ʶ',
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
            layout:'column',
            items:[{
                layout:'form',
			    columnWidth:.5,
                items:[{
			        xtype:'combo',
			        fieldLabel:'�Ƿ�����',
			        anchor:'90%',
			        name:'IsDamaged',
			        id:'IsDamaged',
			        store:[[1,'��'],[0,'��']],
			        editable:false,
			        triggerAction:'all',
			        mode:'local'
			    }]
			},
			{
                layout:'form',
			    columnWidth:.5,
                items:[{
			        xtype:'numberfield',
			        fieldLabel:'����',
			        columnWidth:1,
			        anchor:'90%',
			        name:'Qty',
			        id:'Qty'
			    }]
			}]
		}
,		{
			xtype:'textfield',
			fieldLabel:'ԭʼ����',
			columnWidth:1,
			anchor:'95%',
			name:'InitOrderId',
			id:'InitOrderId'
		}
,		{
			xtype:'combo',
			fieldLabel:'��ת����',
			columnWidth:1,
			anchor:'95%',
			name:'FlowLink',
			id:'FlowLink',
			store:dsStatus,
			displayField:'DicsName',
			valueField:'DicsCode',
			mode:'local',
			triggerAction:'all',
			disabled:true
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
if(typeof(uploadManagementWindow)=="undefined"){//�������2��windows����
	uploadManagementWindow = new Ext.Window({
		id:'Managementformwindow',
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
		,items:pmsbagmanagementform
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
				uploadManagementWindow.hide();
			}
			, scope: this
		}]});
}
uploadManagementWindow.addListener("hide",function(){
	    pmsbagmanagementform.getForm().reset();
});
uploadManagementWindow.addListener("show",function(){
	    if(followState == 'one')
	        Ext.getCmp('FlowLink').setValue(dsStatus.getAt(0).data.DicsCode);
	    if(followState == 'two')
	        Ext.getCmp('FlowLink').setValue(dsStatus.getAt(1).data.DicsCode);
	    if(followState == 'three')
	        Ext.getCmp('FlowLink').setValue(dsStatus.getAt(2).data.DicsCode);
	    if(followState == 'four')
	        Ext.getCmp('FlowLink').setValue(dsStatus.getAt(3).data.DicsCode);
});

function ret_flowLink(v){
    if(v == 'one')
        return dsStatus.getAt(0).data.DicsCode;
    if(v == 'two')
        return dsStatus.getAt(1).data.DicsCode;
    if(v == 'three')
        return dsStatus.getAt(2).data.DicsCode;
    if(v == 'four')
        return dsStatus.getAt(3).data.DicsCode;
}

function ret_lastflowLink(v){
    if(v == 'two')
        return dsStatus.getAt(0).data.DicsCode;
    if(v == 'three')
        return dsStatus.getAt(1).data.DicsCode;
    if(v == 'four')
        return dsStatus.getAt(2).data.DicsCode;
}

/*------��ʼ��ȡ�������ݵĺ��� start---------------*/
function saveUserData()
{

	Ext.Ajax.request({
		url:'frmPmsBagManagementList.aspx?method='+saveType,
		method:'POST',
		params:{
			Id:Ext.getCmp('Id').getValue(),
			WsId:Ext.getCmp('WsId').getValue(),
			IsDamaged:Ext.getCmp('IsDamaged').getValue(),
			Qty:Ext.getCmp('Qty').getValue(),
			InitOrderId:Ext.getCmp('InitOrderId').getValue(),
			Remark:Ext.getCmp('Remark').getValue(),
			FlowLink:Ext.getCmp('FlowLink').getValue(),
			followState:followState,
			ProductId:productCombo.getValue()
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
var onePanel = new Ext.Panel(
{
	title:'�������',
	split:true,
	width:'100%',
	autoScroll:true,
	collapsible: true,
	margins:'0 0 0 0',
	bodyStyle:'height:0px;',
	tbar:new Ext.Toolbar({
	    items:[{
		    text:"ԭ���Ǽ�",
		    icon:"../Theme/1/images/extjs/customer/add16.gif",
		    handler:function(){
		        saveType='addOne';
		        uploadManagementWindow.show();
		    }
		    },'-',{
		    text:"�༭",
		    icon:"../Theme/1/images/extjs/customer/edit16.gif",
		    handler:function(){
		        saveType='editOne';
		        modifyManagementWin();
		    }
	    }]
    }),
    listeners : {
        'deactivate' : function(panel){
            resetformandgridvalue();
        },
        'activate' : function (){ setfollowState('one')}
    }
});
var twoPanel = new Ext.Panel(
{
	title:'����ӹ�����',
	split:true,
	width: '100%',
	collapsible: true,
	margins:'0 0 0 0',
	bodyStyle:'height:0px;',
	tbar:new Ext.Toolbar({
	    items:[{
		    text:"ԭ������",
		    icon:"../Theme/1/images/extjs/customer/add16.gif",
		    handler:function(){
		        saveType='acceptTwo';
		        modifyManagementWin();
		    }
		    },'-',{
		    text:"�༭",
		    icon:"../Theme/1/images/extjs/customer/edit16.gif",
		    handler:function(){
		        saveType='editTwo';
		        modifyManagementWin();
		    }
		    },'-',{
		    text:"ԭ������",
		    icon:"../Theme/1/images/extjs/customer/1edit16.gif",
		    handler:function(){
		        saveType='saleTwo';
		        modifyManagementWin();
		    }
	    }]
    }),
    listeners : {
        'deactivate' : function(panel){
            resetformandgridvalue();
        } ,
        'activate' : function (){ setfollowState('two')}
    }
});
var threePanel = new Ext.Panel(
{
	title:'��ϴ����',
	split:true,
	width: '100%',
	collapsible: true,
	margins:'0 0 0 0',
	bodyStyle:'height:0px;',
	tbar:new Ext.Toolbar({
	    items:[{
		    text:"ԭ������",
		    icon:"../Theme/1/images/extjs/customer/add16.gif",
		    handler:function(){
		        saveType='acceptThree';
		        modifyManagementWin();
		    }
		    },'-',{
		    text:"�༭",
		    icon:"../Theme/1/images/extjs/customer/edit16.gif",
		    handler:function(){
		        saveType='editThree';
		        modifyManagementWin();
		    }
	    }]
    }),
    listeners : {
        'deactivate' : function(panel){
            resetformandgridvalue();
        },
        'activate' : function (){ setfollowState('three')}
    }
});
var fourPanel = new Ext.Panel(
{
	title:'��������',
	split:true,
	width: '100%',
	collapsible: true,
	margins:'0 0 0 0',
	bodyStyle:'height:0px;',
	tbar:new Ext.Toolbar({
	    items:[{
		    text:"ԭ������",
		    icon:"../Theme/1/images/extjs/customer/add16.gif",
		    handler:function(){
		        saveType='acceptFour';
		        modifyManagementWin();
		    }
		    },'-',{
		    text:"�༭",
		    icon:"../Theme/1/images/extjs/customer/edit16.gif",
		    handler:function(){
		        saveType='editFour';
		        modifyManagementWin();
		    }
		    },'-',{
		    text:"��Ʒ�Ƴ�",
		    icon:"../Theme/1/images/extjs/customer/1edit16.gif",
		    handler:function(){
		        saveType='produceFour';
		        modifyManagementWin();
		    }
	    }]
    }),
    listeners : {
        'deactivate' : function(panel){
            resetformandgridvalue();
        },
        'activate' : function (){ setfollowState('four')}
    }
});
var tabPanel =	new Ext.TabPanel({
		el:'toolbar',
		deferredRender:false,
		width:'100%',
	    autoWidth:true,
	    autoScroll:true,
		autoShow :true,
		autoDestroy :true,
		minTabWidth: 200,		//tabҳ�ı�������С�ߴ�,������Ҫ��Ч, ��������resizeTabs:true
		resizeTabs:true,		//tabҳ�ı������Ƿ�֧���Զ�����
		enableTabScroll:true,
		activeTab:0,
		items:[onePanel,twoPanel,threePanel,fourPanel]
});
tabPanel.render();


})
</script>
</html>
