<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmProvideSendStatics.aspx.cs" Inherits="SCM_frmProvideSendStatics" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html>
<head>
<title>����ͳ��</title><meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
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
<div id='sendDtlGrid'></div>
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
		text:"�������",
		icon:"../Theme/1/images/extjs/customer/edit16.gif",
		handler:function(){
		    modifyMstWin();
		}
	}]
});

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
	if(selectData.data.Status!='S257'){
		Ext.Msg.alert("��ʾ","��ѡ����ȷ�Ͽ�Ʊ����Ϣ��");
		return;
	}
	//ǰ�ٴ������Ƿ�������ȷ
	Ext.Msg.confirm("��ʾ��Ϣ","�Ƿ�����Ѿ�ȷ������",function callBack(id){
		//�ж��Ƿ�ɾ������
		if(id=="yes")
		{
		    Ext.MessageBox.wait("�������ڱ��棬���Ժ򡭡�");
			//ҳ���ύ
			Ext.Ajax.request({
				url:'frmProvideSendStatics.aspx?method=finisProvideSend',
				method:'POST',
				params:{
					SendId:selectData.data.SendId
				},
				success: function(resp,opts){
				    Ext.MessageBox.hide();
				    if(checkExtMessage(resp)){
					    dsProvideGrid.reload();
					}
				},
				failure: function(resp,opts){
				    Ext.MessageBox.hide();
					Ext.Msg.alert("��ʾ","����ʧ��");
				}
			});
		}
	});
}

/*------��ʼ��ȡ���ݵĺ��� start---------------*/
var dsProvideGrid = new Ext.data.Store
({
url: 'frmProvideSendStatics.aspx?method=getProvideSendList',
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
	{		name:'OpName'	},
	{		name:'Remark'	},
	{		name:'IsActive'	}	
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
/*------��ʼ��ѯform end---------------*/

    //��ʼ����
    var provideStaticStartPanel = new Ext.form.DateField({
        xtype:'datefield',
        fieldLabel:'������ʼ����',
        anchor:'95%',
        name:'StartDate',
        id:'StartDate',
        format: 'Y��m��d��',  //���������ʽ
        value:new Date().clearTime() 
    });

    //��������
    var provideStaticEndPanel = new Ext.form.DateField({
        xtype:'datefield',
        fieldLabel:'������������',
        anchor:'95%',
        name:'EndDate',
        id:'EndDate',
        format: 'Y��m��d��',  //���������ʽ
        value:new Date().clearTime()
    });
    
    var ArriveStaticPostPanel = new Ext.form.TextField({
        style: 'margin-left:0px',
        cls: 'key',
        xtype: 'textfield',
        fieldLabel: '��վ��Ϣ',
        name: 'nameCust',
        anchor: '95%'
    });
    
    var provideStaticInvoicePanel = new Ext.form.TextField({
        style: 'margin-left:0px',
        cls: 'key',
        xtype: 'textfield',
        fieldLabel: '��Ʊ����',
        name: 'InvoiceNo',
        anchor: '95%'
    });
    
    var provideStaticVechilePanel = new Ext.form.TextField({
        style: 'margin-left:0px',
        cls: 'key',
        xtype: 'textfield',
        fieldLabel: '������',
        name: 'VechNo',
        anchor: '95%'
    });
    
    var  provideStaticSupplier = new Ext.form.ComboBox({
        fieldLabel: '��Ӧ��',
        store: dsSupplier,
        displayField: 'ShortName',
        valueField: 'CustomerId',
        triggerAction: 'all',
        typeAhead: false,
        mode: 'local',
        emptyText: '',
        selectOnFocus: false,
        editable: true,
        anchor: '95%'
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
                columnWidth: .28,  //����ռ�õĿ�ȣ���ʶΪ20��
                layout: 'form',
                border: false,
                items: [
                    provideStaticStartPanel
                ]
            }, {
                columnWidth: .28,
                layout: 'form',
                border: false,
                items: [
                    provideStaticEndPanel
                    ]
            }, {
                name: 'cusStyle',
                columnWidth: .35,
                layout: 'form',
                border: false,
                labelWidth: 55,
                items: [
                    ArriveStaticPostPanel
                ]
            }, {
                columnWidth: .07,
                layout: 'form',
                border: false,
                html: '&nbsp;'
            }]
        },
        {
            layout: 'column',   //�����Ԫ��Ϊ����Ϊ�в��ַ�ʽ
            border: false,
            items: [{
                columnWidth: .28,  //����ռ�õĿ�ȣ���ʶΪ20��
                layout: 'form',
                border: false,
                items: [
                    provideStaticInvoicePanel
                ]
            }, {
                columnWidth: .28,
                layout: 'form',
                border: false,
                items: [
                    provideStaticVechilePanel
                    ]
            }, {
                columnWidth: .3,
                layout: 'form',
                border: false,
                labelWidth: 55,
                items: [
                    provideStaticSupplier
                    ]
            },{
                columnWidth: .14,  //����ռ�õĿ�ȣ���ʶΪ20��
                layout: 'form',
                border: false,
                items: [
                    { cls: 'key',
                    xtype: 'button',
                    text: '��ѯ',
                    anchor: '50%',
                    handler :function(){
                    
                    var starttime=provideStaticStartPanel.getValue();
                    var endtime=provideStaticEndPanel.getValue();
                    var postinfo=ArriveStaticPostPanel.getValue();
                    var invNo=provideStaticInvoicePanel.getValue();
                    var vechNo=provideStaticVechilePanel.getValue();
                    var supplierId=provideStaticSupplier.getValue();
                    
                    dsProvideGrid.baseParams.StartSendDate=Ext.util.Format.date(starttime,'Y/m/d');
                    dsProvideGrid.baseParams.EndSendDate=Ext.util.Format.date(endtime,'Y/m/d');
                    dsProvideGrid.baseParams.InstorInfo=postinfo;
                    dsProvideGrid.baseParams.ShipNo=vechNo;
                    dsProvideGrid.baseParams.Voucher=invNo;
                    dsProvideGrid.baseParams.SupplierId=supplierId;
                    
                    dsProvideGrid.load({
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
function regexValue(qe){
    var combo = qe.combo;  
    //q is the text that user inputed.  
    var q = qe.query;  
    forceAll = qe.forceAll;  
    if(forceAll === true || (q.length >= combo.minChars)){  
     if(combo.lastQuery !== q){  
         combo.lastQuery = q;  
         if(combo.mode == 'local'){  
             combo.selectedIndex = -1;  
             if(forceAll){  
                 combo.store.clearFilter();  
             }else{  
                 combo.store.filterBy(function(record,id){  
                     var text = record.get(combo.displayField);  
                     //������д�Լ��Ĺ��˴���  
                     return (text.indexOf(q)!=-1);  
                 });  
             }  
             combo.onLoad();  
         }else{  
             combo.store.baseParams[combo.queryParam] = q;  
             combo.store.load({  
                 params: combo.getParams(q)  
             });  
             combo.expand();  
         }  
     }else{  
         combo.selectedIndex = -1;  
         combo.onLoad();  
     }  
    }  
    return false;  
}
provideStaticSupplier.on('beforequery',function(qe){  
    regexValue(qe);
});  
function customerShow() {  
    if(<%=CustomerId %> < 0) return;
    provideStaticSupplier.setValue(<%=EmployeeID %>);	
    provideStaticSupplier.setDisabled(true);  
}
customerShow();
/*------��ʼDataGrid�ĺ��� start---------------*/

var sm= new Ext.grid.CheckboxSelectionModel({
	singleSelect:true
});
var provideGrid = new Ext.grid.GridPanel({
	el: 'sendGrid',
	width:'100%',
	//height:'100%',
	height: 250,
	autoWidth:true,
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
			hideable:false
		},
		{
			header:'��������',
			dataIndex:'SendDate',
			id:'SendDate',
			renderer: Ext.util.Format.dateRenderer('Y��m��d��')
		},
		{
			header:'��Ʊ��',
			dataIndex:'Voucher',
			id:'Voucher'
		},
		{
			header:'���ͬ�е���',
			dataIndex:'TransportNo',
			id:'TransportNo'
		},
//		{
//			header:'׼��֤���',
//			dataIndex:'NavicertNo',
//			id:'NavicertNo'
//		},
		{
			header:'�ϼ�����',
			dataIndex:'TotalQty',
			id:'TotalQty'
		},
		{
			header:'��˰���',
			dataIndex:'TotalAmt',
			id:'TotalAmt'
		},
		{
			header:'˰��',
			dataIndex:'TotalTax',
			id:'TotalTax'
		},
		{
			header:'����ʱ��',
			dataIndex:'CreateDate',
			id:'CreateDate',
			renderer: Ext.util.Format.dateRenderer('Y��m��d��')
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
		},
		{
			header:'����Ա',
			dataIndex:'OpName',
			id:'OpName'
		}		]),
		bbar: new Ext.PagingToolbar({
			pageSize: 10,
			store: dsProvideGrid,
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
		enableHdMenu: false,  //����ʾ�����ֶκ���ʾ����������
		enableColumnMove: false,//�в����ƶ�
		closeAction: 'hide',
		stripeRows: true,
		loadMask: true,
		autoExpandColumn: 2
	});
provideGrid.render();
/*dblclick*/
provideGrid.on({ 
    rowdblclick:function(grid, rowIndex, e) {
        var rec = grid.store.getAt(rowIndex);
        //alert(rec.get("SendId"));
        dsprovideGridDtl.baseParams.SendId = rec.get("SendId");
        dsprovideGridDtl.load();
        dsProvideGridStat.baseParams.SendId = rec.get("SendId");
        dsProvideGridStat.load();
    }
});
/*------DataGrid�ĺ������� End---------------*/
var dsprovideGridDtl = new Ext.data.Store
({
    url: 'frmProvideSendStatics.aspx?method=getProvideSendDtl',
    reader:new Ext.data.JsonReader({
	    totalProperty:'totalProperty',
	    root:'root'
    },
   [{ name: 'SendDtlId', type: 'string' },
   { name: 'SendId', type: 'string' },
   { name: 'ProductId', type: 'string' },
   { name: 'Qty', type: 'string' },
   { name: 'Price', type: 'string' },
   { name: 'Amt', type: 'string' },
   { name: 'Tax', type: 'string' },
   { name: 'TaxRate', type: 'string' },
   { name: 'DestInfo', type: 'string' },
   { name: 'ShipNo', type: 'string' }]
   )
});
var provideGridDtl = new Ext.grid.GridPanel({
    el:'sendDtlGrid',
	layout: 'fit',
	width:'100%',
	//height:'100%',
	autoWidth:true,
	//autoHeight:true,
	height: 130,
	autoScroll:true,
	layout: 'fit',
	title: '��������ϸ',
	store: dsprovideGridDtl,
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
			header:'��Ʒ',
			dataIndex:'ProductId',
			id:'ProductId',
			width:100,
		    renderer:{fn:function(value, cellmeta, record, rowIndex, columnIndex, store){
		    
		       var index = dsProductList.findBy(function(record, id) {  // dsPayType Ϊ����Դ
				 return record.get('ProductId')==value; //'DicsCode' Ϊ����Դ��id��
			   });			   
			   if(index == -1) return "";
               var nrecord = dsProductList.getAt(index);
               return nrecord.data.ProductName;  // DicsNameΪ����Դ��name��
		    }}
		},
		{
			header:'����',
			dataIndex:'Qty',
			id:'Qty'
		},
		{
			header:'����',
			dataIndex:'Price',
			id:'Price'
		},
		{
			header:'���',
			dataIndex:'AmtRate',
			id:'AmtRate'
		},
		{
			header:'˰��',
			dataIndex:'TaxRate',
			id:'TaxRate'
		},
		{
			header:'˰��',
			dataIndex:'Tax',
			id:'Tax'
		},
		{
			header:'��վ��Ϣ',
			dataIndex:'DestInfo',
			id:'DestInfo'
		},
		{
			header:'������',
			dataIndex:'ShipNo',
			id:'ShipNo'
		}
		]),
		viewConfig: {
			columnsText: '��ʾ����',
			scrollOffset: 20,
			sortAscText: '����',
			sortDescText: '����',
			forceFit: true
		},		
		closeAction: 'hide',
		stripeRows: true,
		loadMask: true,
		autoExpandColumn: 3
});
provideGridDtl.render();
/**********************confirm info*******************************/
var dsProvideGridStat = new Ext.data.GroupingStore
({
url: 'frmProvideSendStatics.aspx?method=getconfirmStaticList',
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
