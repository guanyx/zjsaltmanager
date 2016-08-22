<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmProvideSendInvoice.aspx.cs" Inherits="SCM_frmProvideSendInvoice" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html>
<head>
<title>������Ʊ����</title><meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<link rel="stylesheet" type="text/css" href="../ext3/resources/css/ext-all.css" />
<script type="text/javascript" src="../ext3/adapter/ext/ext-base.js"></script>
<script type="text/javascript" src="../ext3/ext-all.js"></script>
<script type="text/javascript" src="../js/floatUtil.js"></script>
<link rel="stylesheet" href="../css/Ext.ux.grid.GridSummary.css"/>
<script type="text/javascript" src='../js/Ext.ux.grid.GridSummary.js'></script>
<link rel="stylesheet" href="../ext3/example/GroupSummary.css"/>
<script type="text/javascript" src="../ext3/example/GroupSummary.js"></script>
<script type="text/javascript" src="../js/operateResp.js"></script>
<script type="text/javascript" src="../ext3/src/locale/ext-lang-zh_CN.js"></script>
</head>
<body>
<div id='toolbar'></div>
<div id='searchForm'></div>
<div id='sendGrid'></div>
<div id='confirmGrid'></div>
<%=getComboBoxStore() %>
</body>
<script type="text/javascript">
Ext.BLANK_IMAGE_URL = "../ext3/resources/images/default/s.gif";
Ext.onReady(function(){
var saveType = "";
/*------ʵ��toolbar�ĺ��� start---------------*/
var Toolbar = new Ext.Toolbar({
	renderTo:"toolbar",
	items:[{
		text:"ά����Ʊ��Ϣ",
		icon:"../Theme/1/images/extjs/customer/add16.gif",
		handler:function(){
		    modifyMstWin();
		}
	},{
	    text:"����Excel",
	    icon:"../Theme/1/images/extjs/customer/edit16.gif",
	    menu: new Ext.menu.Menu({ 
            id:   'basicMenu ', 
	        items:[{	    
		        text:"����ѡ�м�¼",
		        icon:"../Theme/1/images/extjs/customer/edit16.gif",
		        handler:function(){
		            exportExcel(false);
		        }
//	        },{	       
//		        text:"�������",
//		        icon:"../Theme/1/images/extjs/customer/edit16.gif",
//		        handler:function(){
//		            exportExcel(false);
//		        }
	        },{	 
		        text:"����ȫ��",
		        icon:"../Theme/1/images/extjs/customer/edit16.gif",
		        handler:function(){
		            exportExcel(true);
		        }
	        }]
	    })
	}]
});
function exportExcel(isAll) {  
    var _urls="frmProvideSendInvoice.aspx?method=exportData&IsAll="+isAll;
    if(!isAll){
        var sm = provideGrid.getSelectionModel();
	    //��ȡѡ���������Ϣ
	    var selectData =  sm.getSelections();
	    //���û��ѡ�񣬾���ʾ��Ҫѡ��������Ϣ
	    if(selectData == null || selectData == "") {
	        Ext.MessageBox.hide();
		    Ext.Msg.alert("��ʾ","��ѡ����Ҫ�����ļ�¼��");
		    return;
        }
        
        var json = "";
        for(var i=0;i<selectData.length;i++)
        {
            json += selectData[i].data.SendDtlId + ',';
        }    
        json = json.substring(0,json.length-1);
        //alert(json);      
        _urls+="&SendDtlIds="+json;
    }else{     
        if(provideGrid.getStore().getCount() <=0)
        {
            Ext.Msg.alert("��ʾ","���ѯ����Ҫ�����ļ�¼��");
            return;
        }   
        _urls +="&StartSendDate="+dsProvideGrid.baseParams.StartSendDate;
        _urls +="&EndSendDate="+dsProvideGrid.baseParams.EndSendDate;
        _urls +="&VehicleNo="+dsProvideGrid.baseParams.VehicleNo;
        _urls +="&ProductName="+dsProvideGrid.baseParams.ProductName;
    }
    
    //check
    window.open(_urls,"");    
}  
/*------����toolbar�ĺ��� end---------------*/


/*------��ʼToolBar�¼����� start---------------*//*-----����Mstʵ���ര�庯��----*/
/*-----�༭Mstʵ���ര�庯��----*/
function modifyMstWin() {
    saveType = 'save';
	var sm = provideGrid.getSelectionModel();
	//��ȡѡ���������Ϣ
	var selectData =  sm.getSelected();
	if(selectData == null){
		Ext.Msg.alert("��ʾ","��ѡ����Ҫ�༭����Ϣ��");
		return;
	}
	selectData = sm.getSelections();                
    var array = new Array(selectData.length);
    var orderIds = "";
    for(var i=0;i<selectData.length;i++)
    {
        if(selectData[i].get('Status') !='S256'){
	        Ext.Msg.alert("��ʾ","��ѡ��״̬Ϊȫ��ȷ�ϵ���Ϣ��");
	        return;
        }
        if(orderIds.length>0)
            orderIds+=",";
        orderIds += selectData[i].get('SendDtlId');
    }	
	uploadMstWindow.show();
	setGridValue(orderIds);	
}
function setGridValue(orderIds){
    dsprovideGridDtlData.baseParams.SendDtlIds=orderIds;                    
    dsprovideGridDtlData.load({params:{start:0,limit:1000}});
}
var RowPattern = Ext.data.Record.create([
   { name: 'SendDtlId', type: 'string' },
   { name: 'SendId', type: 'string' },
   { name: 'ProductName', type: 'string' },
   { name: 'Qty', type: 'float' },
   { name: 'Price', type: 'float' },
   { name: 'Amt', type: 'float' },
   { name: 'Tax', type: 'float' },
   { name: 'TaxRate', type: 'float' },
   { name: 'DestInfo', type: 'string' },
   { name: 'ShipNo', type: 'string' },
   { name: 'InvoiceInfo', type: 'string' },
   { name: 'TransType', type: 'string' }
 ]);
var dsprovideGridDtlData = new Ext.data.Store
({
    url: 'frmProvideSendInvoice.aspx?method=getProvideSendDtl',
    reader:new Ext.data.JsonReader({
	    totalProperty:'totalProperty',
	    root:'root'
    },RowPattern)
});
var provideGridDtlData = new Ext.grid.EditorGridPanel({
	region: 'center',
	width:'100%',
	//height:'100%',
	//autoWidth:true,
	//autoHeight:true,
	height: 200,
	autoScroll:true,
	layout: 'fit',
	id: 'provideGridDtlId',
	clicksToEdit: 1,
	enableHdMenu: false,  //����ʾ�����ֶκ���ʾ����������
	enableColumnMove: false,//�в����ƶ�
	store: dsprovideGridDtlData,
	loadMask: {msg:'���ڼ������ݣ����Ժ��'},
	cm: new Ext.grid.ColumnModel([
		new Ext.grid.RowNumberer(),//�Զ��к�
		{
			header:'��ˮ��',
			dataIndex:'SendDtlId',
			id:'SendDtlId',
			hidden:true,
			hideable:false
		},
		{
			header:'��Ӧ�̷�������ʶ',
			dataIndex:'SendId',
			id:'SendId',
			hidden:true,
			hideable:false
		},
		{
			header:'<font color="red">��Ʊ��</font>',
			dataIndex:'InvoiceInfo',
			id:'InvoiceInfo',
			width:150,
			editor: new Ext.form.TextField({ allowBlank: false })			
		},
		{
			header:'��Ʒ',
			dataIndex:'ProductName',
			id:'ProductName',
			width:150
		},
		{
			header:'����',
			dataIndex:'Qty',
			id:'Qty',
			width:55
		},
		{
			header:'����',
			dataIndex:'Price',
			id:'Price',
			width:55
		},
		{
			header:'˰��',
			dataIndex:'TaxRate',
			id:'TaxRate',
			width:55
		},
		{
			header:'���˷�ʽ',
			dataIndex:'TransType',
			id:'TransType',
			renderer:function(value){
			    //filter arrivepos
			    dsDestination.clearFilter();
			    dsDestination.filterBy(function(record) {   
                    return record.get('SendType') == value;   
                }); 
			    
			    var index = dsTransType.findBy(function(record, id) {  
				 return record.get('DicsCode')==value; 
			   });			   
			   if(index == -1) return "";
               var nrecord = dsTransType.getAt(index);
               return nrecord.data.DicsName; 
			}
		},
		{
			header:'������',
			dataIndex:'ShipNo',
			id:'ShipNo'
		},
		{
			header:'��վ',
			dataIndex:'DestInfo',
			id:'DestInfo'
		}]),
		viewConfig: {
			columnsText: '��ʾ����',
			scrollOffset: 20,
			sortAscText: '����',
			sortDescText: '����',
			forceFit: false
		},		
		closeAction: 'hide',
		stripeRows: true,
		loadMask: true//,
		//autoExpandColumn: 3
});
/*------��ʼ�������ݵĴ��� Start---------------*/
if(typeof(uploadMstWindow)=="undefined"){//�������2��windows����
	uploadMstWindow = new Ext.Window({
		id:'Mstformwindow',
		title:'���˵�ά��'
		, iconCls: 'upload-win'
		, width: 600
		, height: 350
		, layout: 'border'
		, plain: true
		, modal: true
		, constrain:true
		, resizable: false
		, closeAction: 'hide'
		,autoDestroy :true
		,items:[provideGridDtlData]
		,buttons: [{
			text: "����"
			,id:'savebtnId'
			, handler: function() {
				saveUserData();
			}
			, scope: this
		},
		{
			text: "ȡ��"
			, handler: function() { 
				uploadMstWindow.hide();
			}
			, scope: this
		}]});
	}
	uploadMstWindow.addListener("hide",function(){
	    provideGridDtlData.getStore().removeAll();
});

/*------��ʼ��ȡ�������ݵĺ��� start---------------*/
function saveUserData()
{
    var json ="";
    var ispass = true;
    dsprovideGridDtlData.each(function(record) {
        json += Ext.util.JSON.encode(record.data) + ',';
        
        if(record.data.InvoiceInfo == null||record.data.InvoiceInfo =="")
        {
            if(record.data.ProductId>0){
                ispass = false;
                return;
            }
        }
    });
 
    if(!ispass)
    {
        Ext.Msg.alert("��ʾ","��Ʊ�ű���ѡ�����޸ģ�");
        return;
    }
    //Ȼ�����������
    //alert(json);
    Ext.MessageBox.wait("���ڱ��棬���Ժ򡭡�", "ϵͳ��ʾ");
	Ext.Ajax.request({
		url:'frmProvideSendInvoice.aspx?method=saveProvideSendDtl',
		method:'POST',
		params:{
			DetailInfo:	json	
	    },
		success: function(resp,opts){
		    Ext.MessageBox.hide();
		    if(checkExtMessage(resp))
		    {
		        dsProvideGrid.reload({
				    params : {
                        start : 0,
                        limit : 50
                        }
                });
		        uploadMstWindow.hide();
			    //other operation
			}
		},
		failure: function(resp,opts){
		    Ext.MessageBox.hide();
			Ext.Msg.alert("��ʾ","����ʧ��");
		}
		});
}
/*------������ȡ�������ݵĺ��� End---------------*/

/*------��ʼ��ȡ���ݵĺ��� start---------------*/
var dsProvideGrid = new Ext.data.Store
({
url: 'frmProvideSendInvoice.aspx?method=getProvideSendList',
reader:new Ext.data.JsonReader({
	totalProperty:'totalProperty',
	root:'root'
},[
	{		name:'SendId'	},
	{		name:'OrgId'	},
	{       name:'OrgName'  },
	{		name:'SupplierId'	},
	{		name:'SendDate'	},
	{		name:'Voucher'	},
	{		name:'TransportNo'	},
	{		name:'VehicleNo'	},
	{		name:'NavicertNo'	},
	{		name:'TotalQty'	},
	{		name:'TotalAmt'	},
	{		name:'TotalTax'	},
	{		name:'DtlCount'	},
	{		name:'InstorInfo'	},
	{		name:'OperId'	},
	{		name:'CreateDate'	},
	{		name:'UpdateDate'	},
	{		name:'OwnerId'	},
	{		name:'Status'	},
	{		name:'Remark'	},
	{		name:'IsActive'	},
	{ name: 'SendDtlId', type: 'string' },	
	{ name: 'ProductId', type: 'string' },
	{ name: 'Qty', type: 'string' },
	{ name: 'Price', type: 'string' },
	{ name: 'Amt', type: 'string' },
	{ name: 'Tax', type: 'string' },
	{ name: 'TaxRate', type: 'string' },
	{ name: 'DestInfo', type: 'string' },
	{ name: 'ProductNo', type: 'string' },
	{ name: 'ProductName', type: 'string' },
	{ name: 'InvoiceInfo', type: 'string' },
	{ name: 'ShipNo', type: 'string' }
	]),
	listeners:
	{
		scope:this,
		load:function(){
		}
	}
});

/*------��ȡ���ݵĺ��� ���� End---------------*/
/*------��ʼ��ѯform end---------------*/

    //��ʼ����
    var provideStaticStartPanel = new Ext.form.DateField({
        xtype:'datefield',
        fieldLabel:'������ʼ����',
        anchor:'90%',
        name:'StartDate',
        id:'StartDate',
        format: 'Y��m��d��',  //���������ʽ
        value:new Date().clearTime() 
    });

    //��������
    var provideStaticEndPanel = new Ext.form.DateField({
        xtype:'datefield',
        fieldLabel:'������������',
        anchor:'90%',
        name:'EndDate',
        id:'EndDate',
        format: 'Y��m��d��',  //���������ʽ
        value:new Date().clearTime()
    });
    
    var sendProductPanel = new Ext.form.TextField({
        style: 'margin-left:0px',
        cls: 'key',
        xtype: 'textfield',
        fieldLabel: '��Ʒ��Ϣ',
        name: 'ProductName',
        anchor: '90%'
    });
    
    var vehicleNoPanel = new Ext.form.TextField({
        style: 'margin-left:0px',
        cls: 'key',
        xtype: 'textfield',
        fieldLabel: '������',
        name: 'VehicleNo',
        anchor: '90%'
    });
    
    var provideStaticInvoicePanel = new Ext.form.TextField({
        style: 'margin-left:0px',
        cls: 'key',
        xtype: 'textfield',
        fieldLabel: '��Ʊ����',
        name: 'InvoiceNo',
        anchor: '90%'
    });
    
    var ArriveStaticPostPanel = new Ext.form.TextField({
        style: 'margin-left:0px',
        cls: 'key',
        xtype: 'textfield',
        fieldLabel: '��վ��Ϣ',
        name: 'nameCust',
        anchor: '90%'
    });

    var serchform = new Ext.FormPanel({
        renderTo: 'searchForm',
        labelAlign: 'left',
        //layout:'fit',
        buttonAlign: 'right',
        bodyStyle: 'padding:5px',
        frame: true,
        labelWidth: 80,
        items: [
        {
            layout: 'column',   //�����Ԫ��Ϊ����Ϊ�в��ַ�ʽ
            border: false,
            items: [{
                columnWidth: .3,  //����ռ�õĿ�ȣ���ʶΪ20��
                layout: 'form',
                border: false,
                items: [
                    provideStaticStartPanel
                ]
            }, {
                columnWidth: .3,
                layout: 'form',
                border: false,
                items: [
                    provideStaticEndPanel
                ]
            }, {
                columnWidth: .3,
                layout: 'form',
                border: false,
                items: [
                    sendProductPanel
                ]
            }, {
                columnWidth: .1,
                layout: 'form',
                border: false,
                html:'&nbsp;'
            }]
        },{
            layout: 'column',   //�����Ԫ��Ϊ����Ϊ�в��ַ�ʽ
            border: false,
            items: [{
                columnWidth: .3,  //����ռ�õĿ�ȣ���ʶΪ20��
                layout: 'form',
                border: false,
                items: [
                    provideStaticInvoicePanel
                ]
            }, {
                columnWidth: .3,
                layout: 'form',
                border: false,
                items: [
                    vehicleNoPanel
                    ]
            }, {
                columnWidth: .3,
                layout: 'form',
                border: false,
                items: [
                    ArriveStaticPostPanel
                    ]
            }, {
                columnWidth: .1,
                layout: 'form',
                border: false,
                items: [{ cls: 'key',
                    xtype: 'button',
                    text: '��ѯ',
                    anchor: '50%',
                    handler :function(){
                    
                    var starttime=provideStaticStartPanel.getValue();
                    var endtime=provideStaticEndPanel.getValue();
                    var vehicleno=vehicleNoPanel.getValue();
                    var productname=sendProductPanel.getValue();
                    var postinfo = ArriveStaticPostPanel.getValue();
                    var invNo=provideStaticInvoicePanel.getValue();
                    
                    dsProvideGrid.baseParams.StartSendDate=Ext.util.Format.date(starttime,'Y/m/d');
                    dsProvideGrid.baseParams.EndSendDate=Ext.util.Format.date(endtime,'Y/m/d');
                    dsProvideGrid.baseParams.VehicleNo=vehicleno;
                    dsProvideGrid.baseParams.ProductName=productname;
                    dsProvideGrid.baseParams.InstorInfo=postinfo;
                    dsProvideGrid.baseParams.Voucher=invNo;
                    
                    dsProvideGrid.load({
                                params : {
                                start : 0,
                                limit : 50
                                } });
                    }
                }]
            }]
        }]
    });
/*------��ʼ��ѯform end---------------*/
/*------��ʼDataGrid�ĺ��� start---------------*/

var sm= new Ext.grid.CheckboxSelectionModel({
	singleSelect:false
});
var provideGrid = new Ext.grid.GridPanel({
	el: 'sendGrid',
	width:'100%',
	height:'100%',
	height: 300,
	//autoWidth:true,
	//autoHeight:true,
	autoScroll:true,
	layout: 'fit',
	title: '������',
	store: dsProvideGrid,
	loadMask: {msg:'���ڼ������ݣ����Ժ��'},
	sm:sm,
	cm: new Ext.grid.ColumnModel([
		sm,
		new Ext.grid.RowNumberer(),//�Զ��к�
		{
			header:'��Ӧ�̷�������ʶ',
			dataIndex:'SendId',
			id:'SendId',
			hidden:true,
			hideable:false
		},
		{
			header:'��˾��ʶ (ʡ��˾)',
			dataIndex:'OrgId',
			id:'OrgId',
			hidden:true,
			hideable:false
		},
		{
			header:'��Ӧ�̱�ʶ',
			dataIndex:'SupplierId',
			id:'SupplierId',
			hidden:true,
			hideable:false
		},
		{
			header:'��˾',
			dataIndex:'OrgName',
			id:'OrgName',
			hidden:true,
			hideable:false,
			width:145
		},
		{
			header:'��������',
			dataIndex:'SendDate',
			id:'SendDate',
			renderer: Ext.util.Format.dateRenderer('Y��m��d��'),
			width:105
		},
		{
			header:'������',
			dataIndex:'ShipNo',
			id:'ShipNo',
			width:70
		},
		{
			header:'��վ��Ϣ',
			dataIndex:'DestInfo',
			id:'DestInfo',
			width:70
		},
		{
			header:'��Ʊ��',
			dataIndex:'InvoiceInfo',
			id:'InvoiceInfo',
			width:70
		},
		{
			header:'��ˮ��',
			dataIndex:'SendDtlId',
			id:'SendDtlId',
			hidden:true,
			hideable:true
		},
		{
			header:'��Ӧ�̷�������ʶ',
			dataIndex:'SendId',
			id:'SendId',
			hidden:true,
			hideable:true
		},
		{
			header:'��Ʒ����',
			dataIndex:'ProductNo',
			id:'ProductNo',
			width:60
		},
		{
			header:'��Ʒ����',
			dataIndex:'ProductName',
			id:'ProductName',
			width:180
		},
		{
			header:'����',
			dataIndex:'Qty',
			id:'Qty',
			width:50
		},
		{
			header:'����',
			dataIndex:'Price',
			id:'Price',
			width:50
		},
		{
			header:'���',
			dataIndex:'Amt',
			id:'Amt',
			width:70
		},
		{
			header:'˰��',
			dataIndex:'TaxRate',
			id:'TaxRate',
			width:40
		},
		{
			header:'˰��',
			dataIndex:'Tax',
			id:'Tax',
			width:70
		},
		{
			header:'״̬',
			dataIndex:'Status',
			id:'Status',
			renderer:{fn:function(value, cellmeta, record, rowIndex, columnIndex, store){
		       var index = dsStatus.findBy(function(record, id) {  // dsPayType Ϊ����Դ
				 return record.get('DicsCode')==value; //'DicsCode' Ϊ����Դ��id��
			   });
			   if(index == -1) return value;
               var record = dsStatus.getAt(index);
               return record.data.DicsName;  // DicsNameΪ����Դ��name��
		    }}
		}
				]),
		viewConfig: {
			columnsText: '��ʾ����',
			scrollOffset: 20,
			sortAscText: '����',
			sortDescText: '����',
			forceFit: false
		},
		enableHdMenu: false,  //����ʾ�����ֶκ���ʾ����������
		enableColumnMove: false,//�в����ƶ�
		closeAction: 'hide',
		stripeRows: true,
		loadMask: true//,
		//autoExpandColumn: 2
	});
provideGrid.render();
/*dblclick*/
provideGrid.on({ 
    rowdblclick:function(grid, rowIndex, e) {
        var rec = grid.store.getAt(rowIndex);
        //alert(rec.get("SendId"));
        dsProvideGridStat.baseParams.SendId = rec.get("SendId");
        dsProvideGridStat.load();
    }
});
/**********************confirm info*******************************/
var dsProvideGridStat = new Ext.data.GroupingStore
({
url: 'frmProvideSendInvoice.aspx?method=getconfirmStaticList',
reader:new Ext.data.JsonReader({
	totalProperty:'totalProperty',
	root:'root'
},[
	{		name:'NoticeDtlId'	},
	{		name:'NoticeId'	},
	{		name:'OrgId'	},
	{		name:'OrgName'	},
	{		name:'ProductId'	},
	{		name:'ProductName'	},
	{		name:'InvoiceQty',mapping:'InvoiceQty',type:'float'  	},
	{		name:'ConfirmQty',mapping:'ConfirmQty',type:'float'  	},
	{		name:'Price',mapping:'Price',type:'float'  	},
	{		name:'Amt',mapping:'Amt',type:'float'  },
	{		name:'Tax',mapping:'Tax',type:'float'  	},	
	{       name:'Status' }
	]),
    sortInfo: {field: 'OrgId', direction: 'ASC'},
    groupField: 'ProductName'
});

//�ϼ���
var summary = new Ext.ux.grid.GridSummary();
var groupsummary = new Ext.ux.grid.GroupSummary();
var provideGridStaticDtl = new Ext.grid.GridPanel({
	el: 'confirmGrid',
	width:'100%',
	height:'100%',
	autoWidth:true,
	autoHeight:true,
	autoScroll:true,
	layout: 'fit',
	title: '<font color=red>����ȷ�����</font>',
	enableHdMenu: false,  //����ʾ�����ֶκ���ʾ����������
	enableColumnMove: false,//�в����ƶ�
	store: dsProvideGridStat,
	loadMask: {msg:'���ڼ������ݣ����Ժ��'},
	cm: new Ext.grid.ColumnModel([
		new Ext.grid.RowNumberer(),//�Զ��к�
		{
			header:'��ˮ��',
			dataIndex:'SendDtlId',
			id:'SendDtlId',
			hidden:true,
			hideable:false
		},
		{
			header:'��Ӧ�̷�������ʶ',
			dataIndex:'SendId',
			id:'SendId',
			hidden:true,
			hideable:false
		},
		{
			header:'Ҫ����λ',
			dataIndex:'OrgName',
			id:'OrgName'
		},
		{
			header:'��Ʒ',
			dataIndex:'ProductName',
			id:'ProductName',
			width:100
		},
		{
			header:'��������',
			dataIndex:'InvoiceQty',
			id:'InvoiceQty',
			summaryType: 'sum'
		},
		{
			header:'ȷ������',
			dataIndex:'ConfirmQty',
			id:'ConfirmQty',
			summaryType: 'sum'
		},
//		{
//			header:'����',
//			dataIndex:'Price',
//			id:'Price'
//		},
//		{
//			header:'��˰���',
//			dataIndex:'Amt',
//			id:'Amt',
//			summaryType: 'sum'
//		},
//		{
//			header:'˰��',
//			dataIndex:'Tax',
//			id:'Tax',
//			summaryType: 'sum'
//		},
		{
			header:'״̬',
			dataIndex:'Status',
			id:'Status',
			renderer:{
			    fn:function(value, cellmeta, record, rowIndex, columnIndex, store){
		            var index = dsNoticeStatus.findBy(function(record, id) {  // dsPayType Ϊ����Դ
				        return record.get('DicsCode')==value; //'DicsCode' Ϊ����Դ��id��
			        });
			        if(index == -1) return value;
                    var record = dsNoticeStatus.getAt(index);
                    return record.data.DicsName;  // DicsNameΪ����Դ��name��
		        }}
		}
		]),
		plugins: [summary,groupsummary],
		view: new Ext.grid.GroupingView({
            forceFit: true,
            showGroupName: false,
            enableNoGroups: false,
			enableGroupingMenu: false,
            hideGroupedColumn: true
        }),		
		stripeRows: true,
		loadMask: true,
		autoExpandColumn: 3
});
provideGridStaticDtl.render();
/*------��ϸDataGrid�ĺ������� End---------------*/

})
    document.oncontextmenu=new Function("event.returnValue=false;");
    document.onselectstart=new Function("event.returnValue=false;");
</script>

</html>
