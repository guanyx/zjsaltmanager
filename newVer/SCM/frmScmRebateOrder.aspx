<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmScmRebateOrder.aspx.cs" Inherits="SCM_frmScmRebateOrder" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html>
<head>
<title>����ҳ��</title><meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<link rel="stylesheet" type="text/css" href="../ext3/resources/css/ext-all.css" />
<script type="text/javascript" src="../ext3/adapter/ext/ext-base.js"></script>
<script type="text/javascript" src="../ext3/ext-all.js"></script>
<script type="text/javascript" src="../js/operateResp.js"></script>
<script type="text/javascript" src="../js/floatUtil.js"></script>
<script type="text/javascript" src="../js/ExtJsHelper.js"></script>
<script type="text/javascript" src="../ext3/src/locale/ext-lang-zh_CN.js"></script>
</head>
<body>
<div id='toolbar'></div>
<div id='divSearchForm'></div>
<div id='userGrid'></div>

</body>
<%=getComboBoxStore() %>
<script type="text/javascript">
Ext.BLANK_IMAGE_URL = "../ext3/resources/images/default/s.gif";
var usergridDataData=null;
Ext.onReady(function(){
var saveType="";
/*------ʵ��toolbar�ĺ��� start---------------*/
var Toolbar = new Ext.Toolbar({
	renderTo:"toolbar",
	items:[{
		text:"����",
		icon:"../Theme/1/images/extjs/customer/add16.gif",
		handler:function(){
		     saveType="Add";
		     openAddOrderWin(); 
		}
		},'-',{
		text:"�༭",
		icon:"../Theme/1/images/extjs/customer/edit16.gif",
		handler:function(){
		     saveType="Update"; 
		     modifyOrderWin();
		}
		},'-',{
		text:"ɾ��",
		icon:"../Theme/1/images/extjs/customer/delete16.gif",
		handler:function(){
		    deleteOrder();
		}
		},'-',{
		text:"���",
		icon:"../Theme/1/images/extjs/customer/checked.gif",
		handler:function(){
		    confirmOrder();
		}
		},'-',{
		text:"�鿴",
		icon:"../Theme/1/images/extjs/customer/view16.gif",
		handler:function(){
		    viewOrder();
		}
	}]
});

/*------����toolbar�ĺ��� end---------------*/


/*------��ʼToolBar�¼����� start---------------*//*-----����Orderʵ���ര�庯��----*/
function openAddOrderWin() {
	uploadOrderWindow.show();
	document.getElementById("editIFrame").src = "frmScmRebateOrderDtl.aspx?OpenType=oper&id=0";
}
function viewOrder(){
    var sm = gridData.getSelectionModel();
	//��ȡѡ���������Ϣ
	var selectData =  sm.getSelected();
	if(selectData == null){
		Ext.Msg.alert("��ʾ","��ѡ����Ҫ�鿴����Ϣ��");
		return;
	}	 
    uploadOrderWindow.show();
	document.getElementById("editIFrame").src = "frmScmRebateOrderDtl.aspx?OpenType=query&id=" + selectData.data.RebateId;
}
/*-----�༭Orderʵ���ര�庯��----*/
function modifyOrderWin() {
	var sm = gridData.getSelectionModel();
	//��ȡѡ���������Ϣ
	var selectData =  sm.getSelected();
	if(selectData == null){
		Ext.Msg.alert("��ʾ","��ѡ����Ҫ�༭����Ϣ��");
		return;
	}	   
    if (selectData.get('BillStatus') == 1)
    {
        Ext.Msg.alert("��ʾ", "�����¼�������޸ģ�");
        return;
    }
    uploadOrderWindow.show();
    if(document.getElementById("editIFrame").src.indexOf("frmPOSOrderEdit")==-1)
    {                
        document.getElementById("editIFrame").src = "frmScmRebateOrderDtl.aspx?OpenType=oper&id=" + selectData.data.RebateId;
    }
    else{
        document.getElementById("editIFrame").contentWindow.RebateId=selectData.data.RebateId;
        document.getElementById("editIFrame").contentWindow.setFormValues();
    }
	
}
/*-----ɾ��Orderʵ�庯��----*/
/*ɾ����Ϣ*/
function deleteOrder()
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
				url:'frmScmRebateOrder.aspx?method=deleteOrder',
				method:'POST',
				params:{
					RebateId:selectData.data.RebateId
				},
				success: function(resp,opts){
					 if( checkExtMessage(resp,parent) )
                                         { usergridDataData.reload(); }
				},
				failure: function(resp,opts){
					Ext.Msg.alert("��ʾ","����ɾ��ʧ��");
				}
			});
		}
	});
}

/*�����Ϣ*/
function confirmOrder()
{
	var sm = gridData.getSelectionModel();
	//��ȡѡ���������Ϣ
	var selectData =  sm.getSelected();
	//���û��ѡ�񣬾���ʾ��Ҫѡ��������Ϣ
	if(selectData == null){
		Ext.Msg.alert("��ʾ","��ѡ����Ҫ��˵���Ϣ��");
		return;
	}
	//ɾ��ǰ�ٴ������Ƿ����Ҫɾ��
	Ext.Msg.confirm("��ʾ��Ϣ","�Ƿ����Ҫ���ѡ�����Ϣ��",function callBack(id){
		//�ж��Ƿ�ɾ������
		if(id=="yes")
		{
		    Ext.MessageBox.wait("���������ύ�����Ժ򡭡�");
			//ҳ���ύ
			Ext.Ajax.request({
				url:'frmScmRebateOrder.aspx?method=confirmOrder',
				method:'POST',
				params:{
					RebateId:selectData.data.RebateId
				},
				success: function(resp,opts){
				    Ext.MessageBox.hide();
					if( checkExtMessage(resp,parent) )
                        { usergridDataData.reload(); }
				},
				failure: function(resp,opts){
				    Ext.MessageBox.hide();
					Ext.Msg.alert("��ʾ","�������ʧ�ܣ�");
				}
			});
		}
	});
}  
/*------FormPanle�ĺ������� End---------------*/
//�ֿ�
   var ck = new Ext.form.ComboBox({
       xtype: 'combo',
       store: dsWareHouse,
       valueField: 'WhId',
       displayField: 'WhName',
       mode: 'local',
       forceSelection: true,
       //editable: false,
       name:'OutStor',
       id:'OutStor',
       emptyValue: '',
       triggerAction: 'all',
       fieldLabel: '�ֿ�',
       selectOnFocus: true,
       anchor: '90%'//,
	   //editable:false
   });
   //��ʼ����
   var ksrq = new Ext.form.DateField({
	    xtype:'datefield',
        fieldLabel:'��ʼ����',
        anchor:'90%',
        name:'StartDate',
        id:'StartDate',
        format: 'Y��m��d��',  //���������ʽ
        value:new Date().clearTime() 
   });
   
   //��������
   var jsrq = new Ext.form.DateField({
	    xtype:'datefield',
        fieldLabel:'��������',
        anchor:'90%',
        name:'EndDate',
        id:'EndDate',
        format: 'Y��m��d��',  //���������ʽ
        value:new Date().clearTime()
   });
var serchform = new Ext.FormPanel({
        renderTo: 'divSearchForm',
        labelAlign: 'left',
        //layout: 'fit',
        buttonAlign: 'center',
        bodyStyle: 'padding:5px',
        frame: true,
        labelWidth: 55,
        items:[
        {
            layout:'column',
            border: false,
            labelSeparator: '��',
            items: [
    		{
                layout:'form',
                border: false,
                columnWidth:0.5,
                items:[
                {
                    xtype:'textfield',
                    fieldLabel:'����',
                    anchor:'99%',
                    name:'CustomerId',
                    id:'CustomerId'
                }]
            },
            {
               layout: 'form',
               columnWidth: .05,  //����ռ�õĿ�ȣ���ʶΪ20��
               border: false,
               items: [
               {
                    xtype:'button', 
                    iconCls:"find",
                    autoWidth : true,
                    autoHeight : true,
                    hideLabel:true,
                    listeners:{
                        click:function(v){
                              getCustomerInfo(function(record){Ext.getCmp('CustomerId').setValue(record.data.ShortName); },<%=ZJSIG.UIProcess.ADM.UIAdmUser.OrgID(this) %>);    
                        }
                    }
               }]
            },
            {
                layout:'form',
                border: false,
                columnWidth:0.01,
                html: '&nbsp;'
            },
            {
                layout:'form',
                border: false,
                columnWidth:0.3,
                items: [ck]
            }]
        },
        {
            layout:'column',
            border: false,
            labelSeparator: '��',
            items: [
            {
                layout:'form',
                border: false,
                columnWidth:0.28,
                items: [
                {
	                xtype:'datefield',
	                fieldLabel:'��ʼ����',
	                columnWidth:0.5,
	                anchor:'90%',
	                name:'StartDate',
	                id:'StartDate',
                    format: 'Y��m��d��',  //���������ʽ
                    value:new Date().getFirstDateOfMonth().clearTime()
                }]
            },		
            {
                layout:'form',
                border: false,
                columnWidth:0.28,
                items: [
                {
	                xtype:'datefield',
	                fieldLabel:'��������',
	                columnWidth:0.5,
	                anchor:'90%',
	                name:'EndDate',
	                id:'EndDate',
                    format: 'Y��m��d��',  //���������ʽ
                    value:new Date().clearTime()
                }]
            },	
            {
                layout:'form',
                border: false,
                columnWidth:0.3,
                items: [
                {
	                xtype:'textfield',
	                fieldLabel:'��������',
	                columnWidth:0.3,
	                anchor:'90%',
	                name:'FromBillId',
	                id:'FromBillId'
                }]
            },
            {//������Ԫ��
                layout:'form',
                border: false,
                labelWidth:70,
                columnWidth:0.12,
                items:[
                {
                   xtype:'button',
                    text:'��ѯ',
                    width:70,
                    //iconCls:'excelIcon',
                    scope:this,
                    handler:function(){
                        QueryDataGrid();
                    }
                }]
            }]
        }]    
    });


function QueryDataGrid() {
        usergridDataData.baseParams.OutStor=Ext.getCmp('OutStor').getValue();		                
        usergridDataData.baseParams.CustomerId=Ext.getCmp('CustomerId').getValue();	      
        usergridDataData.baseParams.StartDate=Ext.util.Format.date(Ext.getCmp('StartDate').getValue(),'Y/m/d');
        usergridDataData.baseParams.EndDate=Ext.util.Format.date(Ext.getCmp('EndDate').getValue(),'Y/m/d');
        usergridDataData.load({
            params: {
                start: 0,
                limit: 10
            }
        });
    }


/*------��ʼ�������ݵĴ��� Start---------------*/
if(typeof(uploadOrderWindow)=="undefined"){//�������2��windows����
	uploadOrderWindow = new Ext.Window({
		id:'Orderformwindow'
		, iconCls: 'upload-win'
		, width: 700
		, height: 450
		, layout: 'fit'
		, plain: true
		, modal: true
		, x:50
		, y:50
		, constrain:true
		, resizable: false
		, closeAction: 'hide'
		,autoDestroy :true
		, html: '<iframe id="editIFrame" width="100%" height="100%" border=0 src=""></iframe>' 
		});
	}
	uploadOrderWindow.addListener("hide",function(){
});

/*------��ʼ��ȡ���ݵĺ��� start---------------*/
usergridDataData = new Ext.data.Store
({
    url: 'frmScmRebateOrder.aspx?method=getOrderList',
    reader:new Ext.data.JsonReader({
	    totalProperty:'totalProperty',
	    root:'root'
    },[
	    {		name:'RebateId'	},
	    {		name:'CustomerId'	},
	    {		name:'CustomerNo'	},
	    {		name:'CustomerName'	},
	    {		name:'WhId'	},
	    {		name:'CarBoat'	},
	    {		name:'IsCheck'	},
	    {		name:'RebateType'	},
	    {		name:'BusinessType'	},
	    {		name:'FromBillId'	},
	    {		name:'BusinessType'	},
	    {		name:'BillStatus'	},
	    {		name:'IsCertificate'	},
	    {		name:'IsActive'	},
	    {		name:'RebateNumber'	},
	    {		name:'Remark'	},
	    {		name:'OperId'	},
	    {		name:'OperName'	},
	    {		name:'CreateDate'	},
	    {		name:'AuditId'	},
	    {		name:'AuditName'	},
	    {		name:'AuditDate'	},
	    {		name:'WhName'	},
	    {		name:'OrgId'	}	])
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
	el: 'userGrid',
	width:document.body.offsetWidth,
	height:'100%',
	//autoWidth:true,
	//autoHeight:true,
	autoScroll:true,
	layout: 'fit',
	id: '',
	store: usergridDataData,
	loadMask: {msg:'���ڼ������ݣ����Ժ��'},
	sm:sm,
	cm: new Ext.grid.ColumnModel([
		sm,
		new Ext.grid.RowNumberer(),//�Զ��к�
		{
			header:'���������',
			dataIndex:'RebateId',
			id:'RebateId',
			hidden:true,
			hideable:true
		},
		{
			header:'����id',
			dataIndex:'CustomerId',
			id:'CustomerId',
			hidden:true,
			hideable:true
		},
		{
			header:'���̱��',
			dataIndex:'CustomerNo',
			id:'CustomerNo',
			width:65
		},
		{
			header:'��������',
			dataIndex:'CustomerName',
			id:'CustomerName',
			width:150
		},
		{
			header:'�ֿ�����',
			dataIndex:'WhName',
			id:'WhName',
			width:70
		},
//		{
//			header:'��������(�ֽ���������ֿ�)',
//			dataIndex:'RebateType',
//			id:'RebateType'
//		},
//		{
//			header:'ҵ������(�ɹ�����/���ۻؿ�)',
//			dataIndex:'BusinessType',
//			id:'BusinessType'
//		},
		{
			header:'�������ݺ�',
			dataIndex:'FromBillId',
			id:'FromBillId',
			width:80
		},
		{
			header:'����״̬',
			dataIndex:'BillStatus',
			id:'BillStatus',
			width:65,
			renderer: function(val, params, record) {
			    if(val ==0) return '��ʼ';
			    else return '���';
			}
		},
		{
			header:'����Ա',
			dataIndex:'OperName',
			id:'OperName',
			width:60
		},
		{
			header:'��������',
			dataIndex:'CreateDate',
			id:'CreateDate',
            renderer: Ext.util.Format.dateRenderer('Y��m��d��'),
            width:105
		},
		{
			header:'���Ա',
			dataIndex:'AuditName',
			id:'AuditName',
			width:60
		},
		{
			header:'�������',
			dataIndex:'AuditDate',
			id:'AuditDate',
            renderer: Ext.util.Format.dateRenderer('Y��m��d��'),
            width:105
		},
		{
			header:'��ע',
			dataIndex:'Remark',
			id:'Remark',
			width:100
		}
		]),
		bbar: new Ext.PagingToolbar({
			pageSize: 10,
			store: usergridDataData,
			displayMsg: '��ʾ��{0}����{1}����¼,��{2}��',
			emptyMsy: 'û�м�¼',
			displayInfo: true
		}),
		viewConfig: {
			columnsText: '��ʾ����',
			scrollOffset: 20,
			sortAscText: '����',
			sortDescText: '����',
			forceFit: false
		},
		height: 280,
		closeAction: 'hide',
		stripeRows: true,
		loadMask: true
	});
gridData.render();
/*------DataGrid�ĺ������� End---------------*/
QueryDataGrid();
})
</script>

</html>
<script type="text/javascript" src="../js/SelectModule.js"></script>
