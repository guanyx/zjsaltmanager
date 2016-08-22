<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmProvideSend.aspx.cs" Inherits="SCM_frmProvideSend" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html>
<head>
<title>���˵�����</title><meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<link rel="stylesheet" type="text/css" href="../ext3/resources/css/ext-all.css" />
<script type="text/javascript" src="../ext3/adapter/ext/ext-base.js"></script>
<script type="text/javascript" src="../ext3/ext-all.js"></script>
<script type="text/javascript" src="../ext3/example/ItemDeleter.js"></script>
<script type="text/javascript" src="../js/operateResp.js"></script>
<script type="text/javascript" src="../ext3/src/locale/ext-lang-zh_CN.js"></script>
<script type="text/javascript" src="../js/floatUtil.js"></script>
<style type="text/css">
.extensive-remove
{
    background-image: url(../Theme/1/images/extjs/customer/cross.gif) !important;
}
.x-date-menu {
   width: 175px;
}
</style>
</head>
<body>
<div id='toolbar'></div>
<div id='searchForm'></div>
<div id='dataGrid'></div>
<div id='sendDtlGrid'></div>
<%=getComboBoxStore() %>
</body>
<script type="text/javascript">  
Ext.BLANK_IMAGE_URL = "../ext3/resources/images/default/s.gif";
Ext.onReady(function(){
var saveType = "";
var curId =<% =ZJSIG.UIProcess.ADM.UIAdmUser.OrgID(this)%>;
/*------ʵ��toolbar�ĺ��� start---------------*/
var Toolbar = new Ext.Toolbar({
	renderTo:"toolbar",
	items:[{
		text:"����",
		icon:"../Theme/1/images/extjs/customer/add16.gif",
		handler:function(){
		    openAddMstWin();
		    Ext.getCmp('savebtnId').setText('�����ر�');
		    Ext.getCmp('savebtnIdnext').show();
		}
		},'-',{
		text:"�༭",
		icon:"../Theme/1/images/extjs/customer/edit16.gif",
		handler:function(){
		    saveType = 'save';
		    modifyMstWin();
		    Ext.getCmp('savebtnId').setText('����');
		    Ext.getCmp('savebtnId').show();
		    Ext.getCmp('savebtnIdnext').show();
		}
		},'-',{
		text:"ɾ��",
		icon:"../Theme/1/images/extjs/customer/delete16.gif",
		handler:function(){
		    deleteMst();
		}
		},'-',{
		text:"�鿴��ϸ",
		icon:"../Theme/1/images/extjs/customer/view16.gif",
		handler:function(){
		    viewDetail();	    
		}
		},'-',{
		text:"ȷ���ύ",
		icon:"../Theme/1/images/extjs/customer/view16.gif",
		handler:function(){
		    saveType = 'submit';
		    modifyMstWin();
		    Ext.getCmp('savebtnId').setText('ȷ���ύ');		    
		    Ext.getCmp('savebtnId').show();
		    Ext.getCmp('savebtnIdnext').hide();
		}
		}		
	    ,'-',{
	    text:"��Ʊȷ��",
	    icon:"../Theme/1/images/extjs/customer/edit16.gif",
	    id:'kpqr',
	    hidden:true,
	    handler:function(){
	        saveType = 'confirm';
	        modifyMstWin();
	        Ext.getCmp('savebtnId').setText('ȷ�Ͽ�Ʊ');//����Ӧ��	        
		    Ext.getCmp('savebtnId').show();
	        Ext.getCmp('savebtnIdnext').hide();
	    }	    
	}]
});
if(curId==1){
    <% if (!ZJSIG.UIProcess.ADM.UIAdmUser.IsCustomer(this)){%>
    Ext.getCmp('kpqr').show(true);
    <%} %>
}
/*------����toolbar�ĺ��� end---------------*/


/*------��ʼToolBar�¼����� start---------------*//*-----����Mstʵ���ര�庯��----*/
function openAddMstWin() {
    saveType = 'add';
    var cm = provideGridDtlData.getColumnModel();   
    for(var i=0;i<cm.getColumnCount();i++)
        provideGridDtlData.getColumnModel().setEditable(i,true);
    provideGridDtlData.getColumnModel().setHidden(cm.getColumnCount()-2,true);
	
	uploadMstWindow.show();
	addNewBlankRow();
	customerShow();
    if(curId!=1){
        Ext.getCmp('TotalAmt').getEl().up('.x-form-item').setDisplayed(false);
        Ext.getCmp('TotalTax').getEl().up('.x-form-item').setDisplayed(false);
        provideGridDtlData.getColumnModel().setHidden(6,true);
    }
}
/*-----�༭Mstʵ���ര�庯��----*/
function modifyMstWin() {    
	var sm = provideGridData.getSelectionModel();
	//��ȡѡ���������Ϣ
	var selectData =  sm.getSelected();
	if(selectData == null){
		Ext.Msg.alert("��ʾ","��ѡ����Ҫ�༭����Ϣ��");
		return;
	}
	if(saveType == 'save'){
	    if(selectData.data.Status != 'S250' && selectData.data.Status != 'S251'){
	        Ext.Msg.alert("��ʾ","���ݷǳ�ʼ״̬�������޸ģ�");
		    return;
	    }
	    dsProducts.load({
            params:{
                SuppierId:selectData.data.SupplierId                            
            }
        });  
	}else if(saveType == 'submit'){
	    if(selectData.data.Status != 'S250'){
	        Ext.Msg.alert("��ʾ","���ݷǳ�ʼ״̬������ȷ���ύ��");
		    return;
	    }
	}else{
	     if(selectData.data.Status != 'S256'){
	        Ext.Msg.alert("��ʾ","����δȷ�ϻ�ûȫ��ȷ�ϣ�����ȷ�Ͽ�Ʊ��");
		    return;
	    }
	}
	
	uploadMstWindow.show();
	setFormValue(selectData);
	setGridValue(selectData);
	var cm = provideGridDtlData.getColumnModel();
	if(saveType == 'save'||saveType == 'submit'){
	    for(var i=0;i<cm.getColumnCount();i++)
	        provideGridDtlData.getColumnModel().setEditable(i,true);
	}else{	    
	    for(var i=0;i<cm.getColumnCount();i++)
	        provideGridDtlData.getColumnModel().setEditable(i,false);
	    provideGridDtlData.getColumnModel().setHidden(cm.getColumnCount()-2,false);
	}
    if(curId!=1){
        Ext.getCmp('TotalAmt').getEl().up('.x-form-item').setDisplayed(false);
        Ext.getCmp('TotalTax').getEl().up('.x-form-item').setDisplayed(false);
        provideGridDtlData.getColumnModel().setHidden(6,true);
    }
	customerShow();
}
/*-----ɾ��Mstʵ�庯��----*/
/*ɾ����Ϣ*/
function deleteMst()
{
	var sm = provideGridData.getSelectionModel();
	//��ȡѡ���������Ϣ
	var selectData =  sm.getSelected();
	//���û��ѡ�񣬾���ʾ��Ҫѡ��������Ϣ
	if(selectData == null){
		Ext.Msg.alert("��ʾ","��ѡ����Ҫɾ������Ϣ��");
		return;
	}
	
	if(selectData.data.Status != 'S250' && selectData.data.Status != 'S251'){
	    Ext.Msg.alert("��ʾ","�ǳ�ʼ���ݣ�����ɾ����");
		return;
	}
	
	//ɾ��ǰ�ٴ������Ƿ����Ҫɾ��
	Ext.Msg.confirm("��ʾ��Ϣ","�Ƿ����Ҫɾ��ѡ�����Ϣ��",function callBack(id){
		//�ж��Ƿ�ɾ������
		if(id=="yes")
		{
		    Ext.Msg.wait("������....","��ʾ");
			//ҳ���ύ
			Ext.Ajax.request({
				url:'frmProvideSend.aspx?method=deleteProvideSend',
				method:'POST',
				params:{
					SendId:selectData.data.SendId
				},
				success: function(resp,opts){
				    Ext.Msg.hide();
				    if(checkExtMessage(resp)){
					    refreshData();
					}
				},
				failure: function(resp,opts){
				    Ext.Msg.hide();
					Ext.Msg.alert("��ʾ","����ɾ��ʧ��");
				}
			});
		}
	});
}

function viewDetail(){
    var sm = provideGridData.getSelectionModel();
	//��ȡѡ���������Ϣ
	var selectData =  sm.getSelected();
	//���û��ѡ�񣬾���ʾ��Ҫѡ��������Ϣ
	if(selectData == null){
		Ext.Msg.alert("��ʾ","��ѡ����Ҫ�鿴����Ϣ��");
		return;
	}
	uploadDtlViewWindow.show();
	setGridValue(selectData);
    ///-----
    if(curId!=1)
    {
        provideViewGridDtl.getColumnModel().setHidden(6,true); 
        provideViewGridDtl.getColumnModel().setHidden(7,true);
        provideViewGridDtl.getColumnModel().setHidden(8,true); 
    }
}
/*------ʵ��FormPanle�ĺ��� start---------------*/                
var provideForm = new Ext.form.FormPanel({
	frame:true,
	title:'',
	region:'north',
	height:180,
	labelWidth: 80,
	items:[
	{
	    layout:'column',
	    items:[
		{
		    layout:'form',
		    columnWidth:0.5,
		    items:[
		    {
			    xtype:'hidden',
			    fieldLabel:'��Ӧ�̷�������ʶ',
			    anchor:'90%',
			    name:'SendId',
			    id:'SendId',
			    value:0,
			    hidden:true,
			    hideLabel:true
		    },
		    {
		        xtype:'combo',
			    fieldLabel:'������λ',
			    anchor:'90%',
			    name:'SupplierId',
			    id:'SupplierId',
			    store:dsSupplier,
			    triggerAction:'all',
			    mode:'local',
			    displayField:'ShortName',
			    valueField:'CustomerId',
			    listeners:{
			        "select": function(record) {
                        dsProducts.load({
                            params:{
                                SuppierId:Ext.getCmp('SupplierId').getValue(),
                                CanSale:Ext.getCmp('cansale').getValue()                            
                            }
                        });   
                        provideGridDtlData.getStore().removeAll();
                        addNewBlankRow();                
                    } 
//                    "beforequery":function(e) {
//                        var combo = e.combo;  
//                        if(!e.forceAll){  
//                            var value = e.query;  
//                            combo.store.filterBy(function(record,id){  
//                                var text = record.get(combo.displayField);  
//                                 //���Լ��Ĺ��˹���,��д����ʽ  
//                                return (text.indexOf(value)!=-1);  
//                            });  
//                            combo.expand();  
//                            return false;  
//                        }  
//                    }
                }
			 }]
		}
        ,{
            layout:'form',
		    columnWidth:0.5,
		    items:[
		    {
			    xtype:'datefield',
			    fieldLabel:'��������',
			    anchor:'90%',
			    name:'SendDate',
			    id:'SendDate',
			    format:'Y��m��d��',
			    value:new Date().clearTime()
			}]
	    }]
	}   
    ,{
        layout:'column',
        items:[
	    {
	        layout:'form',
	        columnWidth:0.5,
		    items:[
            {
			    xtype:'textfield',
			    fieldLabel:'���ͬ�е���',
			    anchor:'90%',
			    name:'TransportNo',
			    id:'TransportNo'
		    }]
		}
        ,{
            layout:'form',
		    columnWidth:0.5,
		    items:[
		    {
			    xtype:'textfield',
			    fieldLabel:'��Ʊ��',
			    anchor:'90%',
			    name:'Voucher',
			    id:'Voucher'
			}]
	    }]
    }
    ,{
        layout:'column',
        items:[
	    {
	        layout:'form',
	        columnWidth:0.5,
		    items:[
            {
			    xtype:'textfield',
			    fieldLabel:'׼��֤���',
			    anchor:'90%',
			    name:'NavicertNo',
			    id:'NavicertNo'
			}]
		}
        ,{
            layout:'form',
	        columnWidth:0.5,
		    items:[
            {
			    xtype:'numberfield',
			    fieldLabel:'�ϼ�����',
			    anchor:'90%',
			    name:'TotalQty',
			    id:'TotalQty',
		  	    decimalPrecision:8
			}]
		}]
	}
    ,{
        layout:'column',
        items:[
	    {
	        layout:'form',
	        columnWidth:0.5,
		    items:[
            {
		        xtype:'numberfield',
		        fieldLabel:'��˰���',
		        anchor:'90%',
		        name:'TotalAmt',
		        id:'TotalAmt',
			    decimalPrecision:2,
			    value:0
		    }]
		}
        ,{
            layout:'form',
	        columnWidth:0.5,
		    items:[
            {
			    xtype:'numberfield',
			    fieldLabel:'˰��',
			    anchor:'90%',
			    name:'TotalTax',
			    id:'TotalTax',
			    decimalPrecision:2,
			    value:0
			}]
		}
		,{
	        layout:'form',
	        columnWidth:0.5,
		    items:[
            {
			    xtype:'hidden',
			    fieldLabel:'��ϸ��',
			    anchor:'90%',
			    name:'DtlCount',
			    id:'DtlCount',
			    hidden:true,
			    hideLabel:true
		    }]
		}]
	}
    ,{
        layout:'column',
        items:[
	    {
            layout:'form',
            columnWidth:0.33,
            items:[
            {
                xtype: 'combo',
                fieldLabel:'��ɼƻ�*',
                anchor: '98%',
                name: 'DoneYear',
                id: 'DoneYear',
                editable: false,
                triggerAction: 'all',
                mode: 'local',
                store:cmbDoneYearList,
                displayField: 'DicsName',
                valueField: 'DicsCode',
                value:new Date().getFullYear()
            }]
	    },
         {
            layout:'form',
            columnWidth:0.13,
            items:[
            {
                xtype: 'combo',
                anchor: '98%',
                name: 'DoneMonth',
                id: 'DoneMonth',
                editable: false,
                triggerAction: 'all',
                mode: 'local',
                displayField: 'DicsName',
                valueField: 'DicsCode',
                hideLabel: true,
                value:new Date().getMonth()+1
            }]
	    },{
            layout:'form',
            columnWidth:0.2,
            items:[
            {
                xtype:'datefield',
		        fieldLabel:'��ɼƻ�*',
		        anchor:'90%',
		        name:'PlanPeriod',
		        id:'PlanPeriod',
		        format: 'Y��m��',
                hidden: true,
                hideLabel: true,
                value:new Date().clearTime()
            }]
	    }]
	}
	,{
	    layout:'column',
        items:[
	    {
            layout:'form',
	        columnWidth:1,
		    items:[
            {
			    xtype:'textarea',
			    fieldLabel:'��ע',
			    anchor:'90%',
			    name:'Remark',
			    id:'Remark',
			    height: 30
			}]
		}]
	},{
	    layout:'column',
        items:[
	    {
            layout:'form',
	        columnWidth:1,
		    items:[
            {
			    xtype:'checkbox',
			    fieldLabel:'������Ʒ��ȡ',
			    anchor:'90%',
			    name:'cansale',
			    id:'cansale'
			}]
		}]
	}]
});

var cmbDoneMonthList=new Ext.data.SimpleStore({
fields:['DicsCode','DicsName'],
data:[['01','1��'],['02','2��'],['03','3��'],['04','4��'],['05','5��'],['06','6��'],['07','7��'],['08','8��'],['09','9��'],['10','10��'],['11','11��'],['12','12��']],
autoLoad: false});
var cmbDoneMonth = Ext.getCmp("DoneMonth");
if (cmbDoneMonth.store == null)
    cmbDoneMonth.store = new Ext.data.SimpleStore();
cmbDoneMonth.store.removeAll();
cmbDoneMonth.store.add(cmbDoneMonthList.getRange());


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
Ext.getCmp('SupplierId').on('beforequery',function(qe){  
    regexValue(qe);
});   
/*------FormPanle�ĺ������� End---------------*/

/*------��ʼ��ȡ���ݵĺ��� start---------------*/
var dsprovideGridData = new Ext.data.Store
({
url: 'frmProvideSend.aspx?method=getProvideSendList',
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
    var provideStartPanel = new Ext.form.DateField({
        xtype:'datefield',
        fieldLabel:'������ʼ����',
        anchor:'95%',
        name:'StartDate',
        id:'StartDate',
        format: 'Y��m��d��',  //���������ʽ
        value:new Date().clearTime() 
    });

    //��������
    var provideEndPanel = new Ext.form.DateField({
        xtype:'datefield',
        fieldLabel:'������������',
        anchor:'95%',
        name:'EndDate',
        id:'EndDate',
        format: 'Y��m��d��',  //���������ʽ
        value:new Date().clearTime()
    });
    
    var ArrivePostPanel = new Ext.form.TextField({
        style: 'margin-left:0px',
        cls: 'key',
        xtype: 'textfield',
        fieldLabel: '��վ��Ϣ',
        name: 'nameCust',
        anchor: '95%'
    });
    
    var ArriveShipPanel = new Ext.form.TextField({
        style: 'margin-left:0px',
        cls: 'key',
        xtype: 'textfield',
        fieldLabel: '������',
        name: 'nameCust',
        anchor: '95%'
    });
    
    var ArriveTransportPanel = new Ext.form.TextField({
        style: 'margin-left:0px',
        cls: 'key',
        xtype: 'textfield',
        fieldLabel: '���ͬ�е���',
        name: 'TransportNo',
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
        items: [{
            layout: 'column',   //�����Ԫ��Ϊ����Ϊ�в��ַ�ʽ
            border: false,
            items: [{
                columnWidth: .27,  //����ռ�õĿ�ȣ���ʶΪ20��
                layout: 'form',
                border: false,
                items: [
                    provideStartPanel
                ]
            }, {
                columnWidth: .27,
                layout: 'form',
                border: false,
                items: [
                    provideEndPanel
                    ]
            }, {
                name: 'cusStyle',
                columnWidth: .27,
                layout: 'form',
                border: false,
                labelWidth: 80,
                items: [
                    ArrivePostPanel
                ]
            }]
        },{
           layout: 'column',   //�����Ԫ��Ϊ����Ϊ�в��ַ�ʽ
            border: false,
            items: [{
                name: 'cusStyle',
                columnWidth: .27,
                layout: 'form',
                border: false,
                labelWidth: 80,
                items: [
                    ArriveTransportPanel
                ]
            }, {
                name: 'cusStyle',
                columnWidth: .27,
                layout: 'form',
                border: false,
                labelWidth: 80,
                items: [
                    ArriveShipPanel
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
                        refreshData();
                    }
                }]
            }] 
        }]
    });
function refreshData()
{
    //dsprovideGridDtlData clear
    dsprovideGridDtlData.removeAll();
    
    var starttime=provideStartPanel.getValue();
    var endtime=provideEndPanel.getValue();
    var postinfo=ArrivePostPanel.getValue();
    var shipno = ArriveShipPanel.getValue();
    var transportno = ArriveTransportPanel.getValue();
    
    dsprovideGridData.baseParams.StartSendDate=Ext.util.Format.date(starttime,'Y/m/d');
    dsprovideGridData.baseParams.EndSendDate=Ext.util.Format.date(endtime,'Y/m/d');
    dsprovideGridData.baseParams.InstorInfo=postinfo;
    dsprovideGridData.baseParams.ShipNo=shipno;
    dsprovideGridData.baseParams.TransportNo=transportno;
    
    dsprovideGridData.load({
                params : {
                start : 0,
                limit : 10
                } });
}
/*------��ʼ��ѯform end---------------*/
/*------��ʼDataGrid�ĺ��� start---------------*/

var sm= new Ext.grid.CheckboxSelectionModel({
	singleSelect:true
});
var provideGridData = new Ext.grid.GridPanel({
	el: 'dataGrid',
	width:'100%',
	//height:'100%',
	autoWidth:true,
	//autoHeight:true,
	autoScroll:true,
	layout: 'fit',
	id: '',
	store: dsprovideGridData,
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
			header:'������λ',
			dataIndex:'SupplierId',
			id:'SupplierId',
			hideable:false,
			renderer:{
			    fn:function(value, cellmeta, record, rowIndex, columnIndex, store){
			        dsSupplier.clearFilter();
		            var index = dsSupplier.findBy(function(trecord, id) {  // dsPayType Ϊ����Դ
				        return trecord.get('CustomerId')==value; //'DicsCode' Ϊ����Դ��id��
			        });
                    var frecord = dsSupplier.getAt(index);
                    return frecord.data.ShortName;  // DicsNameΪ����Դ��name��
                }
			}
		},
		{
			header:'��������',
			dataIndex:'SendDate',
			id:'SendDate',
			renderer: Ext.util.Format.dateRenderer('Y��m��d��')
		},
//		{
//			header:'��Ʊ��',
//			dataIndex:'Voucher',
//			id:'Voucher'
//		},
		{
			header:'���ͬ�е���',
			dataIndex:'TransportNo',
			id:'TransportNo'
		},
		{
			header:'׼��֤���',
			dataIndex:'NavicertNo',
			id:'NavicertNo'
		},
		{
			header:'�ϼ�����',
			dataIndex:'TotalQty',
			id:'TotalQty'
		},
		{
			header:'��˰���',
			dataIndex:'TotalAmt',
			id:'TotalAmt',
			hideable:false
		},
		{
			header:'˰��',
			dataIndex:'TotalTax',
			id:'TotalTax',
			hideable:false
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
               var record = dsStatus.getAt(index);
               return record.data.DicsName;  // DicsNameΪ����Դ��name��
		    }}
		}		]),
		bbar: new Ext.PagingToolbar({
			pageSize: 10,
			store: dsprovideGridData,
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
		height: 280,
		closeAction: 'hide',
		stripeRows: true,
		loadMask: true,
		autoExpandColumn: 2
	});
provideGridData.render();
if(curId !=1){ 
    provideGridData.getColumnModel().setHidden(8,true);
    provideGridData.getColumnModel().setHidden(9,true);
}
/*------DataGrid�ĺ������� End---------------*/

/*------��ʼ��ȡ��ϸ���ݵĺ��� start---------------*/
var RowPattern = Ext.data.Record.create([
   { name: 'SendDtlId', type: 'string' },
   { name: 'SendId', type: 'string' },
   { name: 'ProductId', type: 'string' },
   { name: 'Qty', type: 'float' },
   { name: 'Price', type: 'float' },
   { name: 'Amt', type: 'float' },
   { name: 'Tax', type: 'float' },
   { name: 'TaxRate', type: 'float' },
   { name: 'DestInfo', type: 'string' },
   { name: 'ShipNo', type: 'string' },
   { name: 'TransType', type: 'string' },
   { name: 'InvoiceInfo', type: 'string' },
   { name: 'UnitId', type: 'string' },
   { name: 'UnitText', type: 'string' }
 ]);
var dsprovideGridDtlData = new Ext.data.Store
({
    url: 'frmProvideSend.aspx?method=getProvideSendDtl',
    reader:new Ext.data.JsonReader({
	    totalProperty:'totalProperty',
	    root:'root'
    },RowPattern)
});
function inserNewBlankRow() {
    var rowCount = provideGridDtlData.getStore().getCount();
    //alert(rowCount);
    if(rowCount>1){
        var shipno= provideGridDtlData.getStore().getAt(0).data.ShipNo;
        var rec = provideGridDtlData.getSelectionModel().getSelected();
        if(rec!=null)
            provideGridDtlData.getSelectionModel().getSelected().set("ShipNo",shipno);
    }
    var insertPos = parseInt(rowCount);
    var addRow = new RowPattern({
        SendDtlId: '',
        SendId: '',
        ProductId: '',
        Qty: '',
        Price: '',
        Amt: '0',
        Tax: '0',
        TaxRate: '',
        DestInfo: '',
        ShipNo: '',
        TransType:''
    });
    provideGridDtlData.stopEditing();
    //����һ����
    if (insertPos > 0) {
        var rowIndex = dsprovideGridDtlData.insert(insertPos, addRow);
        provideGridDtlData.startEditing(insertPos, 0);
    }
    else {
        var rowIndex = dsprovideGridDtlData.insert(0, addRow);
        provideGridDtlData.startEditing(0, 0);
    }
}
function addNewBlankRow(combo, record, index) {
    var rowIndex = provideGridDtlData.getStore().indexOf(provideGridDtlData.getSelectionModel().getSelected());
    var rowCount = provideGridDtlData.getStore().getCount();
    //alert('insertPos:'+rowCount+":"+rowIndex);
    //provideGridDtlData.getSelectionModel().selectRow(rowCount - 1,true);   
    if ((rowIndex == 0 && rowCount == 1) || rowIndex == rowCount - 1) {
        inserNewBlankRow();
    }
}
/*------��ȡ��ϸ���ݵĺ��� ���� End---------------*/
/*------��ʼ��ϸDataGrid�ĺ��� start---------------*/
//�����Ʒ�������첽���÷���
var dsProducts;
if (dsProducts == null) {
    dsProducts = new Ext.data.Store({
        url: 'frmProvideSend.aspx?method=getSppierProducts',
        reader: new Ext.data.JsonReader({
            root: 'root',
            totalProperty: 'totalProperty'
        }, [
                { name: 'ProductId', mapping: 'ProductId' },
                { name: 'ProductNo', mapping: 'ProductNo' },
                { name: 'ProductName', mapping: 'ProductName' },
                { name: 'Unit', mapping: 'Unit' },
                { name: 'UnitText', mapping: 'UnitText' },
                { name: 'TaxRate', mapping: 'TaxRate' },
                { name: 'SalePrice', mapping: 'SalePrice' },
                { name: 'SpecificationsText', mapping: 'SpecificationsText' }
            ])
    });
}
// �����������첽������ʾģ��
var resultTpl = new Ext.XTemplate(
'<tpl for="."><div id="searchdivid" class="search-item">',
    '<h3><span>{ProductName}&nbsp;&nbsp;<font color=blue>{ProductNo}</font>&nbsp;&nbsp;{SpecificationsText}</span></h3>',
'</div></tpl>'
 );
var productCombo = new Ext.form.ComboBox({
    store: dsProducts,
    displayField: 'ProductName',
    valueField: 'ProductId',
    triggerAction: 'all',
    id: 'productCombo',
    typeAhead: false,
    mode: 'local',
    emptyText: '',
    tpl: resultTpl,  
    itemSelector: 'div.search-item', 
    listWidth:380,
    selectOnFocus: false,
    editable: true,
    onSelect: function(record) {
        var sm = provideGridDtlData.getSelectionModel().getSelected();
        sm.set('ProductId', record.data.ProductId);
        sm.set('TaxRate', record.data.TaxRate);
        sm.set('Price', record.data.SalePrice);
        sm.set('UnitText',record.data.UnitText);
        sm.set('UnitId',record.data.Unit);
        //�����ֶθ�ֵ
        if(sm.get('SendDtlId') == undefined ||sm.get('SendDtlId')==null ||sm.get('SendDtlId') =="")
        {
            sm.set('SendDtlId', 0);
            sm.set('SendId', 0);
        }
        
        addNewBlankRow();
        this.collapse();
    },
    listeners:{
        beforequery:function(qe){  
            regexValue(qe);
        }
    }
});
//�����������첽���÷���,��ǰ�ͻ��ɶ���Ʒ�б�
var dsProductUnits = new Ext.data.Store({   
    url: 'frmProvideSend.aspx?method=getProductUnits',  
    params: {
        ProductId:0
    },
    reader: new Ext.data.JsonReader({  
        root: 'root',  
        totalProperty: 'totalProperty',  
        id: 'ProductUnits'  
    }, [  
        {name: 'UnitId', mapping: 'UnitId'}, 
        {name: 'UnitName', mapping: 'UnitName'}, 
        {name: 'ToWeight', mapping: 'ToWeight'}
    ]) 
});  

//������λ������
var UnitCombo = new Ext.form.ComboBox({
    store: dsProductUnits,
    displayField: 'UnitName',
    valueField: 'UnitId',
    triggerAction: 'all',
    id: 'UnitCombo',
    //pageSize: 5,  
    //minChars: 2,  
    //hideTrigger: true,  
    typeAhead: true,
    mode: 'local',
    emptyText: '',
    selectOnFocus: false,
    editable: false,
    listeners: {
        "select": function(conpt){
            var rec = provideGridDtlData.getSelectionModel().getSelected();
            var index = dsProductUnits.find('UnitId',rec.data.UnitId);
            var oldTw = dsProductUnits.getAt(index).get('ToWeight');
            index = dsProductUnits.find('UnitId',conpt.getValue());
            var newTw = dsProductUnits.getAt(index).get('ToWeight');
            rec.set('Price', accDiv(accMul(rec.get('Price'),newTw),oldTw));
            addNewBlankRow();
         }
    }
});
var itemDeleter = new Extensive.grid.ItemDeleter();
var provideGridDtlData = new Ext.grid.EditorGridPanel({
	region: 'center',
	width:'100%',
	//height:'100%',
	autoWidth:true,
	//autoHeight:true,
	height: 280,
	autoScroll:true,
	layout: 'fit',
	id: 'provideGridDtlId',
	clicksToEdit: 1,
	enableHdMenu: false,  //����ʾ�����ֶκ���ʾ����������
	enableColumnMove: false,//�в����ƶ�
	store: dsprovideGridDtlData,
	loadMask: {msg:'���ڼ������ݣ����Ժ��'},
	selModel: itemDeleter,
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
			header:'��Ʒ����',
			dataIndex:'ProductId',
			id:'ProductId',
			width:200,
			editor: productCombo,
            renderer: function(value, cellmeta, record, rowIndex, columnIndex, store) {
                //���ֵ��ʾ����
                //��ȡ��ǰid="combo_process"��comboBoxѡ���ֵ
                var index = dsProductList.findBy(function(record, id) {
                    return record.get(productCombo.valueField) == value;
                });
                var record = dsProductList.getAt(index);
                var displayText = "";
                // ��������б�û�б�ѡ����ôrecordҲ�Ͳ����ڣ���ʱ�򣬷��ش�������value��
                // �����value����grid��USER_REALNAME�е�value������ֱ�ӷ���
                if (record == null) {
                    //����Ĭ��ֵ��
                    displayText = value;
                } else {
                    displayText = record.data.ProductName; //��ȡrecord�е����ݼ��е�process_name�ֶε�ֵ
                }
                return displayText;
            }
		},
		{
			header:'����',
			dataIndex:'Qty',
			id:'Qty',
			width:70,
			editor: new Ext.form.NumberField({ allowBlank: false,decimalPrecision:8 })
		},
		{
			header:'��λ',
			dataIndex:'UnitId',
			id:'UnitId',
			width:50,
            editor: UnitCombo,
            renderer: function(value, cellmeta, record, rowIndex, columnIndex, store) {
                var index = dsUnitList.findBy(function(record, id) {  
	                return record.get(UnitCombo.valueField)==value; 
                });
                var record = dsUnitList.getAt(index);
                var displayText = "";
                if (record == null) {
                    displayText = value;
                } else {
                    displayText = record.data.UnitName; 
                }
                return displayText;
            }
		},
		{
			header:'����',
			dataIndex:'Price',
			id:'Price',
			width:55,
			editor: new Ext.form.NumberField({ allowBlank: false,decimalPrecision:8 }),
			hideable:false
		},
		{
			header:'˰��',
			dataIndex:'TaxRate',
			id:'TaxRate',
			width:55,
			editor: new Ext.form.NumberField({ allowBlank: false })
		},
		{
			header:'���˷�ʽ',
			dataIndex:'TransType',
			id:'TransType',
			editor: new Ext.form.ComboBox({ 
			    store:dsTransType,
			    editable:true,
			    triggerAction:'all',
			    displayField:'DicsName',
			    valueField:'DicsCode',
			    mode:'local'
			}),
			renderer:function(value){
			    //filter arrivepos
			    dsDestination.clearFilter(); 
			    dsDestination.filterBy(function(vec) {   
                    return vec.get('SendType') == value;   
                }); 
			    
			    var index = dsTransType.findBy(function(record, id) {  
				 return record.get('DicsCode')==value; 
			   });			   
			   if(index == -1) return "";
               var nrecord = dsTransType.getAt(index);
               return nrecord.data.DicsName; 
			}
		}
		,
		{
			header:'������',
			dataIndex:'ShipNo',
			id:'ShipNo',
			editor: new Ext.form.TextField({ allowBlank: false })
		},
		{
			header:'��վ',
			dataIndex:'DestInfo',
			id:'DestInfo',
			editor: new Ext.form.ComboBox({ 
			    store:dsDestination,
			    editable:true,
			    triggerAction:'all',
			    valueField:'DestInfo',
			    displayField:'DestInfo',
			    mode:'local',
			    lastQuery:'',
			    listeners:{
			        beforequery:function(qe){  
                        regexValue(qe);
                    }
			    }
			})
		},
		{
		    header:'��Ʊ��',
			dataIndex:'InvoiceInfo',
			id:'InvoiceInfo',
			hidden:true
		}, itemDeleter		]),
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
provideGridDtlData.on("beforeedit",beforeEdit,provideGridDtlData);
function beforeEdit(e)
{
    var record = e.record;
    if(record.data.ProductId != dsProductUnits.baseParams.ProductId)
    {
        dsProductUnits.baseParams.ProductId = record.data.ProductId;
        dsProductUnits.load();
    }
}
provideGridDtlData.on({
    afteredit:function(e){ 
        if(e.field == 'Qty'||e.field == 'Price'||e.field == 'TaxRate') 
        {    
            var totalqty = 0;
            var totalamt = 0;
            var totaltax = 0;
            provideGridDtlData.store.each(function(record) { 
                if(record.get('Qty')!=''&&record.get('Qty')!=undefined){                
                    totalqty = totalqty.add(record.get('Qty'));    
                    if(record.get('Price')!=''&&record.get('Price')!=undefined){
                        totalamt = totalamt.add(record.get('Qty').mul(record.get('Price')));
                        if(record.get('TaxRate')!=''&&record.get('TaxRate')!=undefined){
                            totaltax = totaltax.add(record.get('Qty').mul(record.get('Price')).mul(record.get('TaxRate')));
                        }
                    }
                }
            });
            Ext.getCmp('TotalTax').setValue(totaltax.toFixed(2));
            Ext.getCmp('TotalAmt').setValue(totalamt.toFixed(2));
            Ext.getCmp('TotalQty').setValue(totalqty);
        }    
    }
});
var sm = provideGridDtlData.getSelectionModel();
     sm.onEditorKey = function(field, e) {
         var k = e.getKey(), newCell, g = sm.grid, ed = g.activeEditor;
         if (k == e.ENTER) {
             e.stopEvent();
             ed.completeEdit();
             if (e.shiftKey) {
                 newCell = g.walkCells(ed.row, ed.col - 1, -1, sm.acceptsNav, sm);
             } else {
                 newCell = g.walkCells(ed.row, ed.col + 1, 1, sm.acceptsNav, sm);
             }
         } else if (k == e.TAB) {
             e.stopEvent();
             ed.completeEdit();
             if (e.shiftKey) {
                 newCell = g.walkCells(ed.row-1, ed.col, -1, sm.acceptsNav, sm);
             } else {
                 newCell = g.walkCells(ed.row+1, ed.col, 1, sm.acceptsNav, sm);
             }
             if (ed.col == 1) {
                 if (e.shiftKey) {
                     newCell = g.walkCells(ed.row, ed.col + 1, -1, sm.acceptsNav, sm);
                 } else {
                     newCell = g.walkCells(ed.row, ed.col + 1, 1, sm.acceptsNav, sm);
                 }
             }
         } else if (k == e.ESC) {
             ed.cancelEdit();
         }
         if (newCell) {
             g.startEditing(newCell[0], newCell[1]);
         }

};	
/*------��ϸDataGrid�ĺ������� End---------------*/
/*------��ʼ�������ݵĴ��� Start---------------*/
if(typeof(uploadMstWindow)=="undefined"){//�������2��windows����
	uploadMstWindow = new Ext.Window({
		id:'Mstformwindow',
		title:'���˵�ά��'
		, iconCls: 'upload-win'
		, width: 680
		, height: 460
		, layout: 'border'
		, plain: true
		, modal: true
		, constrain:true
		, resizable: false
		, closeAction: 'hide'
		,autoDestroy :true
		,items:[provideForm,provideGridDtlData]
		,buttons: [{
			text: "�����ر�"
			,id:'savebtnId'
			, handler: function() {
				saveUserData(false);
			}
			, scope: this
		},
		{
			text: "�����������"
			,id:'savebtnIdnext'
			, handler: function() {
				saveUserData(true);
			}
			, scope: this
		},
		{
			text: "ȡ�����ر�"
			, handler: function() { 
				uploadMstWindow.hide();
			}
			, scope: this
		}]});
	}
	uploadMstWindow.addListener("hide",function(){
	    provideForm.getForm().reset();
	    provideGridDtlData.getStore().removeAll();
});

/*------��ʼ��ȡ�������ݵĺ��� start---------------*/
function saveUserData(hasnext)
{
    if(saveType=='add')
        saveType = 'addProvideSend';
    else if(saveType == 'save')
        saveType = 'saveProvideSend';
    else if(saveType == 'confirm')
        saveType = 'confirmProvideSend';
    else if(saveType == 'submit')
        saveType = 'submitProvideSend';
    var amt =0;
    var json = "";
    var ispass =true;
    var shipNoIspass = true;
    var destInfoIspass = true;
    var destInfoValidIspass = true;
    dsprovideGridDtlData.each(function(record) {
        json += Ext.util.JSON.encode(record.data) + ',';
        amt+=record.data.Qty;
        if(record.data.TransType == null||record.data.TransType =="")
        {
            if(record.data.ProductId>0){
                ispass = false;
                return;
            }
        }
        if(record.data.ShipNo ==null||record.data.ShipNo ==""){
            if(record.data.ProductId>0){
                shipNoIspass = false;
                return;
            }
        }
        if(record.data.DestInfo ==null||record.data.DestInfo ==""){
            if(record.data.ProductId>0){
                destInfoIspass = false;
                return;
            }
        }else{
            //��վ��Ϣ�Ƿ���ȷ
            dsDestination.clearFilter();
            dsDestination.filterBy(function(vec) {   
                return vec.get('SendType') == record.data.TransType;   
            }); 
            var index = dsDestination.findBy(function(vec, id) { 
				 return vec.get('DestInfo')==record.data.DestInfo; 
            });			   
            if(index == -1){
                destInfoValidIspass =false;
                return;
            }
        }
    });
    //if(Ext.getCmp('PlanPeriod').getValue()=="")
    if(Ext.getCmp('DoneYear').getValue()+Ext.getCmp('DoneMonth').getValue()=="")
    {
        Ext.Msg.alert("��ʾ","��������ɼƻ��·ݣ�");
        return;
    }
    if(!ispass)
    {
        Ext.Msg.alert("��ʾ","���˷�ʽ����ѡ�����޸ģ�");
        return;
    }
    if(!shipNoIspass)
    {
        Ext.Msg.alert("��ʾ","�����ű���ѡ�����޸ģ�");
        return;
    }
    if(!destInfoIspass)
    {
        Ext.Msg.alert("��ʾ","��վ����ѡ�����޸ģ�");
        return;
    }
    if(!destInfoValidIspass)
    {
        Ext.Msg.alert("��ʾ","��վ����ȷ�����޸ģ�");
        return;
    }
    if(Ext.getCmp('TotalQty').getValue() != Number(amt).toFixed(6)){
        Ext.Msg.alert("��ʾ","��������ϸ������һ�£����޸ģ�");
        return;
    }
    
    json = json.substring(0, json.length - 1);
    //Ȼ�����������
    //alert(json);
    Ext.MessageBox.wait("���ڱ��棬���Ժ򡭡�", "ϵͳ��ʾ");
	Ext.Ajax.request({
		url:'frmProvideSend.aspx?method='+saveType,
		method:'POST',
		params:{
			SendId:Ext.getCmp('SendId').getValue(),
			SupplierId:Ext.getCmp('SupplierId').getValue(),
			SendDate:Ext.util.Format.date(Ext.getCmp('SendDate').getValue(),'Y/m/d'),
			Voucher:Ext.getCmp('Voucher').getValue(),
			TransportNo:Ext.getCmp('TransportNo').getValue(),
			NavicertNo:Ext.getCmp('NavicertNo').getValue(),
			TotalQty:Ext.getCmp('TotalQty').getValue(),
			TotalAmt:Ext.getCmp('TotalAmt').getValue(),
			TotalTax:Ext.getCmp('TotalTax').getValue(),
			DtlCount:Ext.getCmp('DtlCount').getValue(),
			Remark:Ext.getCmp('Remark').getValue(),
			PlanPeriod:Ext.util.Format.date(Ext.getCmp('PlanPeriod').getValue(),'Ym'), 
            DoneYear: Ext.getCmp('DoneYear').getValue(),
            DoneMonth: Ext.getCmp('DoneMonth').getValue(),
			DetailInfo:	json	},
		success: function(resp,opts){
		    Ext.MessageBox.hide();
		    if(checkExtMessage(resp))
		    {
		        refreshData();
                if(!hasnext)
		            uploadMstWindow.hide();
		        else
		            Ext.getCmp("SendId").setValue(0);
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

/*------��ʼ�������ݵĺ��� Start---------------*/
function setFormValue(selectData)
{
	Ext.Ajax.request({
		url:'frmProvideSend.aspx?method=getProvideSend',
		params:{
			SendId:selectData.data.SendId
		},
	success: function(resp,opts){
		var data=Ext.util.JSON.decode(resp.responseText); 
		Ext.getCmp("SendId").setValue(data.SendId);
		Ext.getCmp("SupplierId").setValue(data.SupplierId);
		Ext.getCmp("SendDate").setValue((new Date(data.SendDate.replace(/-/g,"/"))));
		Ext.getCmp("Voucher").setValue(data.Voucher);
		Ext.getCmp("TransportNo").setValue(data.TransportNo);
		Ext.getCmp("NavicertNo").setValue(data.NavicertNo);
		Ext.getCmp("TotalQty").setValue(data.TotalQty);
		Ext.getCmp("TotalAmt").setValue(data.TotalAmt);
		Ext.getCmp("TotalTax").setValue(data.TotalTax);
		Ext.getCmp("DtlCount").setValue(data.DtlCount);
		Ext.getCmp("Remark").setValue(data.Remark);
		Ext.getCmp("PlanPeriod").setValue(new Date(parseInt(data.PlanPeriod.substr(0,4)),parseInt(data.PlanPeriod.substr(4,2))-1));
		Ext.getCmp('DoneYear').setValue(data.PlanPeriod.substr(0,4));
        Ext.getCmp('DoneMonth').setValue(data.PlanPeriod.substr(4,2));
	},
	failure: function(resp,opts){
		Ext.Msg.alert("��ʾ","��ȡ�û���Ϣʧ��");
	}
	});
}
function setGridValue(selectData){
    dsprovideGridDtlData.baseParams.SendId=selectData.data.SendId;                    
    dsprovideGridDtlData.load({
        callback : function(r, options, success) {
            inserNewBlankRow();
        }
    });
}
/*------�������ý������ݵĺ��� End---------------*/


/*------�鿴��ϸ����grid ��ʼ---------------*/
var provideViewGridDtl = new Ext.grid.GridPanel({
	layout: 'fit',
	width:'100%',
	//height:'100%',
	autoWidth:true,
	//autoHeight:true,
	height: 300,
	autoScroll:true,
	layout: 'fit',
	id: '',
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
			header:'��λ',
			dataIndex:'UnitId',
			id:'UnitId',
			width:50,
            renderer: function(value, cellmeta, record, rowIndex, columnIndex, store) {
                var index = dsUnitList.findBy(function(record, id) {  
	                return record.get(UnitCombo.valueField)==value; 
                });
                var record = dsUnitList.getAt(index);
                var displayText = "";
                if (record == null) {
                    displayText = value;
                } else {
                    displayText = record.data.UnitName; 
                }
                return displayText;
            }
		},
		{
			header:'����',
			dataIndex:'Price',
			id:'Price',
			hideable:false
		},
		{
			header:'���',
			dataIndex:'Amt',
			id:'Amt',
			hideable:false
		},
		{
			header:'˰��',
			dataIndex:'Tax',
			id:'Tax',
			hideable:false
		},
		{
			header:'���˷�ʽ',
			dataIndex:'TransType',
			id:'TransType',
			renderer:function(value){
			    var index = dsTransType.findBy(function(record, id) {  
				 return record.get('DicsCode')==value; 
			   });			   
			   if(index == -1) return "";
               var nrecord = dsTransType.getAt(index);
               return nrecord.data.DicsName; 
			}
		},
		{
			header:'��վ',
			dataIndex:'DestInfo',
			id:'DestInfo'
		},
		{
		    header:'������',
			dataIndex:'ShipNo',
			id:'ShipNo'
		},
		{
		    header:'��Ʊ��',
			dataIndex:'InvoiceInfo',
			id:'InvoiceInfo'
		}
		]),
        bbar: new Ext.PagingToolbar({
            pageSize: 10,
            store: dsprovideGridDtlData,
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
		closeAction: 'hide',
		stripeRows: true,
		loadMask: true,
		autoExpandColumn: 3
});
if(typeof(uploadDtlViewWindow)=="undefined"){//�������2��windows����
	uploadDtlViewWindow = new Ext.Window({
		id:'',
		title:'���˵�ά��'
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
		,items:provideViewGridDtl
		,buttons: [
		{
			text: "ȡ��"
			, handler: function() { 
				uploadDtlViewWindow.hide();
			}
			, scope: this
		}]});
	}
	uploadDtlViewWindow.addListener("hide",function(){
	    provideViewGridDtl.getStore().removeAll();
	});
	provideViewGridDtl.getStore().on('remove',onStoreRemove, this);
	function onStoreRemove(thiz, record, index) {
        var totalqty = Ext.getCmp('TotalQty').getValue();
        var totalamt = Ext.getCmp('TotalAmt').getValue();
        var totaltax = Ext.getCmp('TotalTax').getValue();
        if(record.get('Qty')!=''&&record.get('Qty')!=undefined){            
            totalqty = totalqty.sub(record.get('Qty'));    
            if(record.get('Price')!=''&&record.get('Price')!=undefined){
                totalamt = totalamt.sub(record.get('Qty').mul(record.get('Price')));
                if(record.get('TaxRate')!=''&&record.get('TaxRate')!=undefined){
                    totaltax = totaltax.sub(record.get('Qty').mul(record.get('Price')).mul(record.get('TaxRate')));
                }
            }
        }
        Ext.getCmp('TotalTax').setValue(totaltax.toFixed(2));
        Ext.getCmp('TotalAmt').setValue(totalamt.toFixed(2));
        Ext.getCmp('TotalQty').setValue(totalqty);
    }
    function customerShow() {  
        if(<%=CustomerId %> < 0) return;
	    Ext.getCmp('SupplierId').setValue(<%=EmployeeID %>);	    
        dsProducts.load({
            params:{
                SuppierId:Ext.getCmp('SupplierId').getValue()                            
            }
        }); 
        Ext.getCmp('SupplierId').setDisabled(true);  
	}
/*------�鿴��ϸ����grid ����---------------*/

/*dblclick*/
provideGridData.on({ 
    rowdblclick:function(grid, rowIndex, e) {
        var rec = grid.store.getAt(rowIndex);
        //alert(rec.get("SendId"));
        dsprovideGridDtlData.baseParams.SendId = rec.get("SendId");
        dsprovideGridDtlData.load();
    }
});
var provideGridDtl = new Ext.grid.GridPanel({
    el:'sendDtlGrid',
	layout: 'fit',
	width:'100%',
	//height:'100%',
	autoWidth:true,
	autoHeight:true,
	height: 100,
	autoScroll:true,
	layout: 'fit',
	title: '��ϸ��Ϣ',
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
			header:'��λ',
			dataIndex:'UnitId',
			id:'UnitId',
			width:50,
            renderer: function(value, cellmeta, record, rowIndex, columnIndex, store) {
                var index = dsUnitList.findBy(function(record, id) {  
	                return record.get(UnitCombo.valueField)==value; 
                });
                var record = dsUnitList.getAt(index);
                var displayText = "";
                if (record == null) {
                    displayText = value;
                } else {
                    displayText = record.data.UnitName; 
                }
                return displayText;
            }
		},
		{
			header:'����',
			dataIndex:'Price',
			id:'Price',
			hideable:false
		},
		{
			header:'���',
			dataIndex:'Amt',
			id:'Amt',
			hideable:false
		},
		{
			header:'˰��',
			dataIndex:'Tax',
			id:'Tax',
			hideable:false
		},
		{
			header:'���˷�ʽ',
			dataIndex:'TransType',
			id:'TransType',
			renderer:function(value){
			    var index = dsTransType.findBy(function(record, id) {  
				 return record.get('DicsCode')==value; 
			   });			   
			   if(index == -1) return "";
               var nrecord = dsTransType.getAt(index);
               return nrecord.data.DicsName; 
			}
		},
		{
			header:'��վ',
			dataIndex:'DestInfo',
			id:'DestInfo'
		},
		{
		    header:'������',
			dataIndex:'ShipNo',
			id:'ShipNo'
		},
		{
		    header:'��Ʊ��',
			dataIndex:'InvoiceInfo',
			id:'InvoiceInfo'
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
if(curId!=1)
{   
    provideGridDtl.getColumnModel().setHidden(6,true); 
    provideGridDtl.getColumnModel().setHidden(7,true);
    provideGridDtl.getColumnModel().setHidden(8,true); 
}

})
    document.oncontextmenu=new Function("event.returnValue=false;");
    document.onselectstart=new Function("event.returnValue=false;");
</script>

</html>
