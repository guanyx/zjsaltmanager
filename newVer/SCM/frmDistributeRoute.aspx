<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmDistributeRoute.aspx.cs" Inherits="SCM_frmDistributeRoute" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html>
<head>
<title>������·ά��</title><meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<link rel="stylesheet" type="text/css" href="../ext3/resources/css/ext-all.css" />
<script type="text/javascript" src="../ext3/adapter/ext/ext-base.js"></script>
<script type="text/javascript" src="../ext3/ext-all.js"></script>
</head>
<body>
<div id='toolbar'></div>
<div id='searchForm'></div>
<div id='dataGrid'></div>
<%=getComboBoxStore() %>
</body>
<script type="text/javascript">
Ext.BLANK_IMAGE_URL = "../ext3/resources/images/default/s.gif";
Ext.onReady(function(){
var saveType;
var currentRouteId;
/*------ʵ��toolbar�ĺ��� start---------------*/
var Toolbar = new Ext.Toolbar({
	renderTo:"toolbar",
	items:[{
		text:"����",
		icon:"../Theme/1/images/extjs/customer/add16.gif",
		handler:function(){
		    saveType='add';
		    openAddRouteWin();
		}
		},'-',{
		text:"�༭",
		icon:"../Theme/1/images/extjs/customer/edit16.gif",
		handler:function(){
		    saveType='save';
		    modifyRouteWin();
		}
		},'-',{
		text:"ɾ��",
		icon:"../Theme/1/images/extjs/customer/delete16.gif",
		handler:function(){
		    deleteRoute();
		}
		},'-',{
		text:"��������·",
		icon:"../Theme/1/images/extjs/customer/edit16.gif",
		handler:function(){
		    saveType='add';
		    openAddRouteChildWin();
		}
		},'-',{
		text:"ά����·�ͻ�",
		icon:"../Theme/1/images/extjs/customer/view16.gif",
		handler:function(){
		    ManageRouteCustomer();
		}
	}]
});

/*------����toolbar�ĺ��� end---------------*/


/*------��ʼToolBar�¼����� start---------------*//*-----����Routeʵ���ര�庯��----*/
function openAddRouteWin() {	
	uploadRouteWindow.show();
}
function openAddRouteChildWin(){
    var sm = gridRouteData.getSelectionModel();
	//��ȡѡ���������Ϣ
	var selectData =  sm.getSelected();
	if(selectData == null){
		Ext.Msg.alert("��ʾ","��ѡ�и���·����Ϣ��");
		return;
	}
    uploadRouteWindow.show();
    Ext.getCmp("RouteParent").setValue(selectData.data.RouteId);
    Ext.getCmp("RouteParentNo").setValue(selectData.data.RouteNo);
}
/*-----�༭Routeʵ���ര�庯��----*/
function modifyRouteWin() {    
	var sm = gridRouteData.getSelectionModel();
	//��ȡѡ���������Ϣ
	var selectData =  sm.getSelected();
	if(selectData == null){
		Ext.Msg.alert("��ʾ","��ѡ����Ҫ�༭����Ϣ��");
		return;
	}
	uploadRouteWindow.show();
	setFormValue(selectData);
}
/*-----ɾ��Routeʵ�庯��----*/
/*ɾ����Ϣ*/
function deleteRoute()
{
	var sm = gridRouteData.getSelectionModel();
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
				url:'frmDistributeRoute.aspx?method=deleteRoute',
				method:'POST',
				params:{
					RouteId:selectData.data.RouteId
				},
				success: function(resp,opts){
				    gridRouteData.getStore().reload();
					Ext.Msg.alert("��ʾ","����ɾ���ɹ�");
				},
				failure: function(resp,opts){
					Ext.Msg.alert("��ʾ","����ɾ��ʧ��");
				}
			});
		}
	});
}
function ManageRouteCustomer(){
    var sm = gridRouteData.getSelectionModel();
	//��ȡѡ���������Ϣ
	var selectData =  sm.getSelected();
	//���û��ѡ�񣬾���ʾ��Ҫѡ��������Ϣ
	if(selectData == null){
		Ext.Msg.alert("��ʾ","��ѡ����Ҫ���õ���·��Ϣ��");
		return;
	}
    currentRouteId = selectData.data.RouteId;
    uploadRouteCustomerWindow.show();
    dsGridRouteCustomer.baseParams.RouteId = currentRouteId;
    dsGridRouteCustomer.load({
        params : {
        start : 0,
        limit : 10
        } 
     }); 
}
/*------ʵ��FormPanle�ĺ��� start---------------*/
var routeForm=new Ext.form.FormPanel({
	url:'',
	//renderTo:'divForm',
	frame:true,
	title:'',
	items:[
		{
			xtype:'hidden',
			fieldLabel:'�ƻ����ܱ�ʶ',
			columnWidth:1,
			anchor:'90%',
			name:'RouteId',
			id:'RouteId',
			hidden:true,
			hideLabel:true
		}
,		{
			xtype:'hidden',
			fieldLabel:'����·���',
			columnWidth:1,
			anchor:'90%',
			name:'RouteParent',
			id:'RouteParent',
			hidden:true,
			hideLabel:true
		}
,		{
			xtype:'textfield',
			fieldLabel:'����·���',
			columnWidth:1,
			anchor:'90%',
			name:'RouteParentNo',
			id:'RouteParentNo',
			readOnly:true
		}
,		{
			xtype:'textfield',
			fieldLabel:'��·���',
			columnWidth:1,
			anchor:'90%',
			name:'RouteNo',
			id:'RouteNo'
		}
,		{
			xtype:'textfield',
			fieldLabel:'��·����',
			columnWidth:1,
			anchor:'90%',
			name:'RouteName',
			id:'RouteName'
		}
,		{
			xtype:'combo',
			fieldLabel:'��·����',
			columnWidth:1,
			anchor:'90%',
			name:'RouteType',
			id:'RouteType',
			store:dsRouteType,
			displayField:'DicsName',
			valueField:'DicsCode',
			mode:'local',
			triggerAction:'all',
			editable:false
		}
,		{
			xtype:'combo',
			fieldLabel:'������',
			columnWidth:1,
			anchor:'90%',
			name:'ChargePerson',
			id:'ChargePerson',
			store:dsOper,
			displayField:'EmpName',
			valueField:'EmpId',
			mode:'local',
			triggerAction:'all',
			editable:false
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
if(typeof(uploadRouteWindow)=="undefined"){//�������2��windows����
	uploadRouteWindow = new Ext.Window({
		id:'Routeformwindow',
		title:'������·ά��'
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
		,items:routeForm
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
				uploadRouteWindow.hide();
			}
			, scope: this
		}]});
	}
	uploadRouteWindow.addListener("hide",function(){
	 routeForm.getForm().reset();
});

/*------��ʼ��ȡ�������ݵĺ��� start---------------*/
function saveUserData()
{
    if(saveType == 'add')
        saveType = 'addRoute';
    else if(saveType == 'save')
        saveType = 'saveRoute';
	Ext.Ajax.request({
		url:'frmDistributeRoute.aspx?method='+saveType,
		method:'POST',
		params:{
			RouteId:Ext.getCmp('RouteId').getValue(),
			RouteNo:Ext.getCmp('RouteNo').getValue(),
			RouteName:Ext.getCmp('RouteName').getValue(),
			RouteType:Ext.getCmp('RouteType').getValue(),
			RouteParent:Ext.getCmp('RouteParent').getValue(),
			ChargePerson:Ext.getCmp('ChargePerson').getValue(),
			Remark:Ext.getCmp('Remark').getValue()
			},
		success: function(resp,opts){
			Ext.Msg.alert("��ʾ","����ɹ�");
			uploadRouteWindow.hide();
			gridRouteData.getStore().reload();
		},
		failure: function(resp,opts){
			Ext.Msg.alert("��ʾ","����ʧ��");
		}
		});
		}
/*------������ȡ�������ݵĺ��� End---------------*/
/*------ʵ��searchForm�ĺ��� start---------------*/
var nameRoutePanel = new Ext.form.TextField({
    style: 'margin-left:0px',
    cls: 'key',
    xtype: 'textfield',
    fieldLabel: '��·����',
    name: 'name',
    anchor: '90%'
});
var searchForm = new Ext.form.FormPanel({
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
        items: [{
            columnWidth: .33,
            layout: 'form',
            border: false,
            items: [
                nameRoutePanel
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
                    var name=nameRoutePanel.getValue();
                    //alert(name +":"+type);
                    dsGridRouteData.baseParams.RouteName=name;
                    dsGridRouteData.load({
                                params : {
                                start : 0,
                                limit : 10
                                } 
                              }); 
                    }
                }]
        },{
            columnWidth: .56,  //����ռ�õĿ�ȣ���ʶΪ20��
            layout: 'form',
            border: false
        }]
    }]

});

/*------ʵ��searchForm�ĺ��� start---------------*/
/*------��ʼ�������ݵĺ��� Start---------------*/
function setFormValue(selectData)
{
	Ext.Ajax.request({
		url:'frmDistributeRoute.aspx?method=getRoute',
		params:{
			RouteId:selectData.data.RouteId
		},
	success: function(resp,opts){
		var data=Ext.util.JSON.decode(resp.responseText);
		Ext.getCmp("RouteId").setValue(data.RouteId);
		Ext.getCmp("RouteNo").setValue(data.RouteNo);
		Ext.getCmp("RouteName").setValue(data.RouteName);
		Ext.getCmp("RouteType").setValue(data.RouteType);
		Ext.getCmp("RouteParent").setValue(data.RouteParent);
		Ext.getCmp("RouteParentNo").setValue(data.RouteParentNo);
		Ext.getCmp("ChargePerson").setValue(data.ChargePerson);
		Ext.getCmp("Remark").setValue(data.Remark);
	},
	failure: function(resp,opts){
		Ext.Msg.alert("��ʾ","��ȡ�û���Ϣʧ��");
	}
	});
}
/*------�������ý������ݵĺ��� End---------------*/

/*------��ʼ��ȡ���ݵĺ��� start---------------*/
var dsGridRouteData = new Ext.data.Store
({
url: 'frmDistributeRoute.aspx?method=getRouteList',
reader:new Ext.data.JsonReader({
	totalProperty:'totalProperty',
	root:'root'
},[
	{		name:'RouteId'	},
	{		name:'RouteNo'	},
	{		name:'RouteName'	},
	{		name:'RouteType'	},
	{		name:'Remark'	},
	{		name:'OperId'	},
	{		name:'CreateDate'	},
	{		name:'UpdateDate'	},
	{		name:'OrgId'	},
	{		name:'OwnerId'	},
	{		name:'RouteParent'	},
	{		name:'RouteParentNo'	},
	{		name:'ChargePerson'	},
	{		name:'ChargePersonName'	}	
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
var gridRouteData = new Ext.grid.GridPanel({
	el: 'dataGrid',
	width:'100%',
	height:'100%',
	autoWidth:true,
	autoHeight:true,
	autoScroll:true,
	layout: 'fit',
	id: '',
	store: dsGridRouteData,
	loadMask: {msg:'���ڼ������ݣ����Ժ��'},
	sm:sm,
	cm: new Ext.grid.ColumnModel([
		sm,
		new Ext.grid.RowNumberer(),//�Զ��к�
		{
			header:'��·��ʶ',
			dataIndex:'RouteId',
			id:'RouteId',
			hidden:true,
			hideable:false
		},
		{
			header:'��·���',
			dataIndex:'RouteNo',
			id:'RouteNo'
		},
		{
			header:'��·����',
			dataIndex:'RouteName',
			id:'RouteName'
		},
		{
			header:'��·����',
			dataIndex:'RouteType',
			id:'RouteType',
			renderer:{
			    fn:function(val, params, record) {
		        if (dsRouteType.getCount() == 0) {
		            dsRouteType.load();
		        }
		        dsRouteType.each(function(r) {
		            if (val == r.data['DicsCode']) {
		                val = r.data['DicsName'];
		                return;
		            }
		        });
		        return val;
		        }
			}
		},
		{
			header:'����·���',
			dataIndex:'RouteParentNo',
			id:'RouteParentNo'
		},
		{
			header:'������',
			dataIndex:'ChargePersonName',
			id:'ChargePersonName'
		},
		{
			header:'��ע',
			dataIndex:'Remark',
			id:'Remark'
		}
		]),
		bbar: new Ext.PagingToolbar({
			pageSize: 10,
			store: dsGridRouteData,
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
gridRouteData.render();
/*------DataGrid�ĺ������� End---------------*/

/*------��ʼ��ȡ���ݵĺ��� start---------------*/
var dsGridRouteCustomer = new Ext.data.Store
({
url: 'frmDistributeRoute.aspx?method=getRouteCustomerList',
reader:new Ext.data.JsonReader({
	totalProperty:'totalProperty',
	root:'root'
},[
	{		name:'RelationId'	},
	{		name:'RouteId'	},
	{		name:'CustomerId'	},
	{		name:'CreateDate'	},
	{		name:'UpdateDate'	},
	{		name:'OperId'	},
	{		name:'OrgId'	},
	{		name:'OwnerId'	},
	{		name:'RouteNo'	},
	{		name:'RouteType'	},
	{		name:'RouteName'	},
	{		name:'CustomerNo'	},
	{		name:'ShortName'	},
	{		name:'ChineseName'	},
	{		name:'Address'	},
	{		name:'RouteTypeText'}	
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

var smC= new Ext.grid.CheckboxSelectionModel({
	singleSelect:true
});
var routeCustomerGrid = new Ext.grid.GridPanel({
	width:'100%',
	height:'100%',
	autoWidth:true,
	autoHeight:true,
	autoScroll:true,
	layout: 'fit',
	id: '',
	store: dsGridRouteCustomer,
	loadMask: {msg:'���ڼ������ݣ����Ժ��'},
	sm:smC,
	cm: new Ext.grid.ColumnModel([
		smC,
		new Ext.grid.RowNumberer(),//�Զ��к�
		{
			header:'��·�������',
			dataIndex:'RelationId',
			id:'RelationId',
			hidden:true,
			hideable:false
		},
		{
			header:'��·���',
			dataIndex:'RouteId',
			id:'RouteId',
			hidden:true,
			hideable:false
		},
		{
			header:'��·���',
			dataIndex:'RouteNo',
			id:'RouteNo'
		},
		{
			header:'��·����',
			dataIndex:'RouteName',
			id:'RouteName'
		},
		{
		    header:'��·����',
			dataIndex:'RouteTypeText',
			id:'RouteTypeText'
		},
		{
			header:'�ͻ����',
			dataIndex:'CustomerNo',
			id:'CustomerNo'
		},
		{
			header:'�ͻ����',
			dataIndex:'ShortName',
			id:'ShortName'
		},
		{
			header:'�ͻ���ַ',
			dataIndex:'Address',
			id:'Address'
		},
		{
			header:'��������',
			dataIndex:'CreateDate',
			id:'CreateDate',
			renderer: Ext.util.Format.dateRenderer('Y��m��d��')
		}
		]),
		tbar:new Ext.Toolbar({
	        items:[{
		        text:"����",
		        icon:"../Theme/1/images/extjs/customer/add16.gif",
		        handler:function(){		            
                    uploadCtmGridWindow.show();
		        }
		        },'-',{
		        text:"ɾ��",
		        icon:"../Theme/1/images/extjs/customer/delete16.gif",
		        handler:function(){
		            deleteRouteCustomerRelInfo();
		        }
	        }]
        }),
		bbar: new Ext.PagingToolbar({
			pageSize: 10,
			store: dsGridRouteCustomer,
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
function deleteRouteCustomerRelInfo(){
    var sm = routeCustomerGrid.getSelectionModel();
    //var selectData = sm.getSelected();
    var records=sm.getSelections();
    
    if (records == null || records.length == 0) 
    {
        Ext.Msg.alert("��ʾ", "��ѡ��һ�У�");
    }
    else 
    {   
        var array = new Array(records.length);
        for(var i=0;i<records.length;i++)
        {
            array[i] = records[i].get('RelationId');
        }
        Ext.Ajax.request({
        url: 'frmDistributeRoute.aspx?method=deleteRouteCustomerInfo',
            params: {
            RelationId: array.join('-')//��������id��
            },
            success: function(resp, opts) {
                //var data=Ext.util.JSON.decode(resp.responseText);
                Ext.Msg.alert("��ʾ", "ɾ���ɹ���");
                routeCustomerGrid.getStore().reload();
            },
            failure: function(resp, opts) {
                Ext.Msg.alert("��ʾ", "ɾ��ʧ�ܣ�");
            }
        });
    }

}		
/*------DataGrid�ĺ������� End---------------*/

/*------��ʼ�ͻ����ý������ݵĴ��� Start---------------*/
if(typeof(uploadRouteCustomerWindow)=="undefined"){//�������2��windows����
	uploadRouteCustomerWindow = new Ext.Window({
		id:'RouteCustomerformwindow',
		title:'���ÿͻ���·ά��'
		, iconCls: 'upload-win'
		, width: 600
		, height: 400
		, layout: 'fit'
		, plain: true
		, modal: true
		, constrain:true
		, resizable: false
		, closeAction: 'hide'
		,autoDestroy :true
		,items:routeCustomerGrid
		,buttons: [
		{
			text: "�ر�"
			, handler: function() { 
				uploadRouteCustomerWindow.hide();
			}
			, scope: this
		}]});
	}
	uploadRouteCustomerWindow.addListener("hide",function(){
	    routeCustomerGrid.getStore().removeAll();
		    
});
/*------�����ͻ����ý������ݵĴ��� End---------------*/

/*------ʵ��searchForm�ĺ��� start---------------*/
var nameRouteCustomerNoPanel = new Ext.form.TextField({
    style: 'margin-left:0px',
    cls: 'key',
    xtype: 'textfield',
    fieldLabel: '�ͻ����',
    name: 'name',
    anchor: '90%'
});
var nameRouteCustomerPanel = new Ext.form.TextField({
    style: 'margin-left:0px',
    cls: 'key',
    xtype: 'textfield',
    fieldLabel: '�ͻ�����',
    name: 'name',
    anchor: '90%'
});
var searchRelForm = new Ext.form.FormPanel({
    labelAlign: 'left',
    region:'north',
    buttonAlign: 'right',
    bodyStyle: 'padding:5px',
    frame: true,
    height:50,
    labelWidth: 80,
    items: [{
        layout: 'column',   //�����Ԫ��Ϊ����Ϊ�в��ַ�ʽ
        border: false,
        items: [{
            columnWidth: .33,
            layout: 'form',
            border: false,
            items: [
                nameRouteCustomerNoPanel
                ]
        }, {
            columnWidth: .33,
            layout: 'form',
            border: false,
            items: [
                nameRouteCustomerPanel
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
                    var name = nameRouteCustomerPanel.getValue();
                    var no = nameRouteCustomerNoPanel.getValue();
                    //alert(name +":"+type);
                    dsRCustomerGrid.baseParams.ChineseName = name;
                    dsRCustomerGrid.baseParams.CustomerId = no;
                    dsRCustomerGrid.load({
                                params : {
                                start : 0,
                                limit : 10
                                } 
                              }); 
                    }
                }]
        },{
            columnWidth: .56,  //����ռ�õĿ�ȣ���ʶΪ20��
            layout: 'form',
            border: false
        }]
    }]

});

/*------ʵ��searchForm�ĺ��� start---------------*/

/*------�����ͻ�ѡ���б� start --------------*/
var dsRCustomerGrid;
if(dsRCustomerGrid==null){
    dsRCustomerGrid = new Ext.data.Store({
        url:"frmDistributeRoute.aspx?method=getNonCustomers",
        reader:new Ext.data.JsonReader({
            totalProperty:'totalProperty',
	        root:'root'},
	        [
	            { name: "CustomerId" },
			    { name: "CustomerNo" },
			    { name: "ShortName" },
			    { name: "LinkMan" },
			    { name: "LinkTel" },
			    { name: "LinkMobile" },
			    { name: "Fax" },
			    { name: "DistributionTypeText" },
			    { name: "MonthQuantity" },
			    { name: "IsCust" },
			    { name: "IsProvide" },
			    { name: 'CreateDate'}
	        ])	        
    });
}

var smRel= new Ext.grid.CheckboxSelectionModel({
	singleSelect:false
});
var rCustomerGrid = new Ext.grid.GridPanel({
	width:'100%',
	height:'100%',
	autoWidth:true,
	autoHeight:true,
	autoScroll:true,
	region: 'center',
	id: '',
	store: dsRCustomerGrid,
	loadMask: {msg:'���ڼ������ݣ����Ժ��'},
	sm:smRel,
	cm: new Ext.grid.ColumnModel([
		smRel,
		new Ext.grid.RowNumberer(),//�Զ��к�
	    { header: "�ͻ�ID",dataIndex: 'CustomerId' ,hidden:true,hideable:false},
        { header: "�ͻ����", width: 60, sortable: true, dataIndex: 'CustomerNo' },
        { header: "�ͻ�����", width: 60, sortable: true, dataIndex: 'ShortName' },
        { header: "��ϵ��", width: 30, sortable: true, dataIndex: 'LinkMan' },
        { header: "��ϵ�绰", width: 30, sortable: true, dataIndex: 'LinkTel' },
        { header: "����ʱ��", width: 60, sortable: true, dataIndex: 'CreateDate',
                renderer: Ext.util.Format.dateRenderer('Y��m��d��') }
		]),
		bbar: new Ext.PagingToolbar({
			pageSize: 10,
			store: dsRCustomerGrid,
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


/*------�����ͻ�ѡ���б� end --------------*/

/*------��ʼ�ͻ����ý������ݵĴ��� Start---------------*/
if(typeof(uploadCtmGridWindow)=="undefined"){//�������2��windows����
	uploadCtmGridWindow = new Ext.Window({
		id:'Customerformwindow',
		title:'�ͻ���Ϣ'
		, iconCls: 'upload-win'
		, width: 700
		, height: 450
		, layout: 'border'
		, plain: true
		, modal: true
		, constrain:true
		, resizable: false
		, closeAction: 'hide'
		,autoDestroy :true
		,items:[searchRelForm,rCustomerGrid]
		,buttons: [{
			text: "����"
			, handler: function() {
				saveCustoemrData();
			}
			, scope: this
		},
		{
			text: "ȡ��"
			, handler: function() { 
				uploadCtmGridWindow.hide();
			}
			, scope: this
		}]});
	}
	uploadCtmGridWindow.addListener("hide",function(){
	    searchRelForm.getForm().reset();
	    rCustomerGrid.getStore().removeAll();   
});
function saveCustoemrData(){
    var sm = rCustomerGrid.getSelectionModel();
    //var selectData = sm.getSelected(); //��������Ƕ�getSelections.itemAt[0]�ķ�װ�����ڶ�ѡ������
    var records=sm.getSelections();
    
    if (records == null || records.length == 0) 
    {
        Ext.Msg.alert("��ʾ", "��ѡ��һ�У�");
    }
    else 
    { 
        Ext.Msg.confirm("��ʾ��Ϣ", "ȷ�ϱ��棿", function callBack(id) {
                //�ж��Ƿ�ɾ������
                if (id == "yes") {
                     var array = new Array(records.length);
                    for(var i=0;i<records.length;i++)
                    {
                        array[i] = records[i].get('CustomerId');
                    }
                    Ext.Ajax.request({
                    url: 'frmDistributeRoute.aspx?method=saveCustomerRelInfo',
                        params: {
                            RouteId: currentRouteId ,
                            CustomerId: array.join('-')//��������id��
                        },
                        success: function(resp, opts) {
                            //var data=Ext.util.JSON.decode(resp.responseText);
                            Ext.Msg.alert("��ʾ", "����ɹ���");
                            dsGridRouteCustomer.reload();
                            uploadCtmGridWindow.hide();
                        },
                        failure: function(resp, opts) {
                            Ext.Msg.alert("��ʾ", "����ʧ�ܣ�");
                        }
                    });
                }
             });
        
       
    }

}
/*------�����ͻ����ý������ݵĴ��� End---------------*/

})
</script>

</html>

