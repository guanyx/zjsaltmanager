<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmScmDeliveryMst.aspx.cs" Inherits="SCM_frmScmDeliveryMst" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html>
<head>
<title>����ҳ��</title><meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<link rel="stylesheet" type="text/css" href="../ext3/resources/css/ext-all.css" />
<script type="text/javascript" src="../ext3/adapter/ext/ext-base.js"></script>
<script type="text/javascript" src="../ext3/ext-all.js"></script>
<script type="text/javascript" src="../js/operateResp.js"></script>
<style type="text/css">
.x-date-menu {
   width: 175px;
}
</style>
</head>
<script type="text/javascript">
Ext.BLANK_IMAGE_URL = "../ext3/resources/images/default/s.gif" ;
var gridDataData =null;
Ext.onReady(function(){
var saveType="";
/*------ʵ��toolbar�ĺ��� start---------------*/
var Toolbar = new Ext.Toolbar({
	renderTo:"toolbar",
	items:[{
		text:"����",
		icon:"../Theme/1/images/extjs/customer/add16.gif",
		handler:function(){
		    saveType="Add"; openAddMstWin();
		}
		},'-',{
		text:"�༭",
		icon:"../Theme/1/images/extjs/customer/edit16.gif",
		handler:function(){
		    saveType="Update"; modifyMstWin();
		}
		},'-',{
		text:"ɾ��",
		icon:"../Theme/1/images/extjs/customer/delete16.gif",
		handler:function(){
		    deleteMst();
		}
		},'-',{
		text:"ֱ����",
		icon:"../Theme/1/images/extjs/customer/1edit16.gif",
		handler:function(){
		    directStockOut();
		}
		},'-',{
		text:"����",
		icon:"../Theme/1/images/extjs/customer/edit16.gif",
		handler:function(){
		    settleFee();
		}
		},'-',{
		text:"��ӡ",
		icon:"../Theme/1/images/extjs/customer/edit16.gif",
		handler:function(){
		    printMst();
		}
		},'-',{
		text:"�鿴",
		icon:"../Theme/1/images/extjs/customer/view16.gif",
		handler:function(){
		    viewMstWin();
		}
	}]
});

/*------����toolbar�ĺ��� end---------------*/


/*------��ʼToolBar�¼����� start---------------*//*-----����Mstʵ���ര�庯��----*/
function openAddMstWin() {
	uploadMstWindow.show();
    if(document.getElementById("editIFrame").src.indexOf("frmScmDeliveryDtl")==-1)
    {   
        document.getElementById("editIFrame").src = "frmScmDeliveryDtl.aspx?OpenType=oper&DeliveryId=0" ;
    }
    else{
        document.getElementById("editIFrame").contentWindow.DeliveryId=0;
        document.getElementById("editIFrame").contentWindow.setFormValue('oper');
    }
}
/*-----�༭Mstʵ���ര�庯��----*/
function modifyMstWin() {
	var sm = gridData.getSelectionModel();
	//��ȡѡ���������Ϣ
	var selectData =  sm.getSelected();
	if(selectData == null){
		Ext.Msg.alert("��ʾ","��ѡ����Ҫ�༭����Ϣ��");
		return;
	}
	uploadMstWindow.show();
    if(document.getElementById("editIFrame").src.indexOf("frmScmDeliveryDtl")==-1)
    {                
        document.getElementById("editIFrame").src = "frmScmDeliveryDtl.aspx?OpenType=oper&DeliveryId=" + selectData.data.DeliveryId;
    }
    else{
        document.getElementById("editIFrame").contentWindow.DeliveryId=selectData.data.DeliveryId;
        document.getElementById("editIFrame").contentWindow.setFormValue('oper');
    }
}
function viewMstWin(){
    var sm = gridData.getSelectionModel();
	//��ȡѡ���������Ϣ
	var selectData =  sm.getSelected();
	if(selectData == null){
		Ext.Msg.alert("��ʾ","��ѡ����Ҫ�鿴����Ϣ��");
		return;
	}
	uploadMstWindow.show();
    if(document.getElementById("editIFrame").src.indexOf("frmScmDeliveryDtl")==-1)
    {                
        document.getElementById("editIFrame").src = "frmScmDeliveryDtl.aspx?OpenType=view&DeliveryId=" + selectData.data.DeliveryId;
    }
    else{
        document.getElementById("editIFrame").contentWindow.DeliveryId=selectData.data.DeliveryId;
        document.getElementById("editIFrame").contentWindow.setFormValue('view');
    }
}
function settleFee(){
    var sm = gridData.getSelectionModel();
	//��ȡѡ���������Ϣ
	var selectData =  sm.getSelected();
	//���û��ѡ�񣬾���ʾ��Ҫѡ��������Ϣ
	if(selectData == null){
		Ext.Msg.alert("��ʾ","��ѡ����Ҫ�˷ѽ������Ϣ��");
		return;
	}
	    
	//����ǰ�ٴ������Ƿ����Ҫɾ��
	Ext.Msg.confirm("��ʾ��Ϣ","�Ƿ����Ҫ����ѡ�����Ϣ��",function callBack(id){
		//�ж��Ƿ�ɾ������
		if(id=="yes")
		{
			//ҳ���ύ
			Ext.Ajax.request({
				url:'frmScmDeliveryMst.aspx?method=settleFee',
				method:'POST',
				params:{
					DeliveryId:selectData.data.DeliveryId
				},
				success: function(resp,opts){
				    if( checkExtMessage(resp) )
                     {
                       gridData.getStore().reload();
                     }					
				},
				failure: function(resp,opts){
					Ext.Msg.alert("��ʾ","����ʧ��");
				}
			});
		}
	});
}
function directStockOut(){
    var sm = gridData.getSelectionModel();
	//��ȡѡ���������Ϣ
	var selectData =  sm.getSelected();
	//���û��ѡ�񣬾���ʾ��Ҫѡ��������Ϣ
	if(selectData == null){
		Ext.Msg.alert("��ʾ","��ѡ����Ҫ�������Ϣ��");
		return;
	}
	//ɾ��ǰ�ٴ������Ƿ����Ҫɾ��
	Ext.Msg.confirm("��ʾ��Ϣ","�Ƿ����Ҫ����ѡ�����Ϣ��",function callBack(id){
		//�ж��Ƿ�ɾ������
		if(id=="yes")
		{
			//ҳ���ύ
			Ext.Ajax.request({
				url:'frmScmDeliveryMst.aspx?method=directStockOutMst',
				method:'POST',
				params:{
					DeliveryId:selectData.data.DeliveryId
				},
				success: function(resp,opts){
				    if( checkExtMessage(resp) )
                     {
                       gridData.getStore().reload();
                     }					
				},
				failure: function(resp,opts){
					Ext.Msg.alert("��ʾ","����ʧ��");
				}
			});
		}
	});
}
/*-----ɾ��Mstʵ�庯��----*/
/*ɾ����Ϣ*/
function deleteMst()
{
	var sm = gridData.getSelectionModel();
	//��ȡѡ���������Ϣ
	var selectData =  sm.getSelected();
	//���û��ѡ�񣬾���ʾ��Ҫѡ��������Ϣ
	if(selectData == null){
		Ext.Msg.alert("��ʾ","��ѡ����Ҫɾ������Ϣ��");
		return;
	}
	
	if(selectData.data.DeliveryStatus==1){
	    //����ǰ�ٴ������Ƿ����Ҫ����
	    Ext.Msg.confirm("��ʾ��Ϣ","�Ƿ����Ҫ���Ѿ��������Ϣɾ����",function callBack(id){
		    //�ж��Ƿ�ɾ������
		    if(id == "yes")
		    {
		        deleteMstDo(selectData.data.DeliveryId);
		    }
        });
    }else{
        deleteMstDo(selectData.data.DeliveryId);
    }   
}
function deleteMstDo(deliveryId)
{
    //ɾ��ǰ�ٴ������Ƿ����Ҫɾ��
	Ext.Msg.confirm("��ʾ��Ϣ","�Ƿ����Ҫɾ��ѡ�����Ϣ��",function callBack(id){
		//�ж��Ƿ�ɾ������
		if(id=="yes")
		{
			//ҳ���ύ
			Ext.Ajax.request({
				url:'frmScmDeliveryMst.aspx?method=deleteMst',
				method:'POST',
				params:{
					DeliveryId:deliveryId
				},
				success: function(resp,opts){
					if( checkExtMessage(resp) )
                     {
                       gridData.getStore().reload();
                     }	
				},
				failure: function(resp,opts){
					Ext.Msg.alert("��ʾ","����ɾ��ʧ��");
				}
			});
		}
	});
}

/*------ʵ��FormPanle�ĺ��� start---------------*/
var deliveryForm=new Ext.form.FormPanel({
	//url:'',
	renderTo:'searchForm',
	frame:true,
	title:'',
	labelWidth:65,
	items:[
	{
        layout:'column',
        border: false,
        labelSeparator: '��',
        items: [
        {
            layout:'form',
            border: false,
            columnWidth:0.3,
            items: [{
                xtype:'textfield',
		        fieldLabel:'���ر��',
		        columnWidth:1,
		        anchor:'98%',
		        name:'DeliveryNumber',
		        id:'DeliveryNumber'
            }]
        },
		{
            layout:'form',
            border: false,
            columnWidth:0.3,
            items: [{
                xtype:'textfield',
                fieldLabel:'��ʻԱ',
                columnWidth:0.33,
                anchor:'98%',
                name:'DriverName',
                id:'DriverName'
            }]
        }
,		{
            layout:'form',
            border: false,
            columnWidth:0.3,
            items: [{
                xtype:'textfield',
                fieldLabel:'�������',
                columnWidth:0.33,
                anchor:'98%',
                name:'VehicleNo',
                id:'VehicleNo'
            }]
        }
    ]},	                
    {
        layout:'column',
        border: false,
        labelSeparator: '��',
        items: [
        {
            layout:'form',
            border: false,
            columnWidth:0.3,
            items: [{
                xtype:'datefield',
                fieldLabel:'��ʼ����',
                columnWidth:0.5,
                anchor:'98%',
                name:'StartDate',
                id:'StartDate',
                value:new Date().clearTime(),
                format:'Y��m��d��'
            }]
        },
		{
            layout:'form',
            border: false,
            columnWidth:0.3,
            items: [{
                xtype:'datefield',
                fieldLabel:'��������',
                columnWidth:0.5,
                anchor:'98%',
                name:'EndDate',
                id:'EndDate',
                value:new Date(),
                format:'Y��m��d��'
            }]
        } ,
  		{
            layout:'form',
            border: false,
            columnWidth:0.23,
            items: [{
                xtype:'combo',
                fieldLabel:'��������',
                columnWidth:0.5,
                anchor:'98%',
                name:'DeliveryType',
                id:'DeliveryType',
                mode:'local',
                store:new Ext.data.SimpleStore({
                    fields:
                        ['id',  'name']
                    ,data:[['C011','������'],['C012','С����']]
                }),
                valueField:'id',
                displayField:'name'
            }]            
        },
  		{
            layout:'form',
            border: false,
            columnWidth:0.1,
            items: [{
                cls: 'key',
                xtype: 'button',
                text: '��ѯ',
                buttonAlign:'right',
                id: 'searchebtnId',
                anchor: '70%',
                handler: function() {QueryDataGrid();}
            }]            
        }]
     }]
});
/*------FormPanle�ĺ������� End---------------*/

/*------��ʼ�������ݵĴ��� Start---------------*/
if(typeof(uploadMstWindow)=="undefined"){//�������2��windows����
	uploadMstWindow = new Ext.Window({
		id:'Mstformwindow',
		title:'���ص���'
		, iconCls: 'upload-win'
		, width: 680
		, height: 490
		, plain: true
		, modal: true
		, constrain:true
		, resizable: false
		, closeAction: 'hide'
		,autoDestroy :true
		, html: '<iframe id="editIFrame" width="100%" height="100%" border=0 src=""></iframe>' 
		});
	}
	uploadMstWindow.addListener("hide",function(){
});

/*------��ʼ��ȡ�������ݵĺ��� start---------------*/
function getFormValue()
{

	Ext.Ajax.request({
		url:'',
		method:'POST',
		params:{
			DeliveryId:Ext.getCmp('DeliveryId').getValue(),
			DriverId:Ext.getCmp('DriverId').getValue(),
			VehicleId:Ext.getCmp('VehicleId').getValue(),
			CreateDate:Ext.getCmp('CreateDate').getValue(),
			DeliveryDate:Ext.getCmp('DeliveryDate').getValue(),
			OrgId:Ext.getCmp('OrgId').getValue(),
			DeptId:Ext.getCmp('DeptId').getValue(),
			OperId:Ext.getCmp('OperId').getValue(),
			OwnerId:Ext.getCmp('OwnerId').getValue(),
			DeliveryType:Ext.getCmp('DeliveryType').getValue(),
			DeliveryStatus:Ext.getCmp('DeliveryStatus').getValue(),
			IsActive:Ext.getCmp('IsActive').getValue(),
			TotalQty:Ext.getCmp('TotalQty').getValue(),
			TotalAmt:Ext.getCmp('TotalAmt').getValue(),
			TotalTransFee:Ext.getCmp('TotalTransFee').getValue(),
			DtlCount:Ext.getCmp('DtlCount').getValue(),
			DeliveryCount:Ext.getCmp('DeliveryCount').getValue(),
			DeliveryNumber:Ext.getCmp('DeliveryNumber').getValue(),
			Ramark:Ext.getCmp('Ramark').getValue(),
			TotalLoadFee:Ext.getCmp('TotalLoadFee').getValue()		},
		success: function(resp,opts){
			Ext.Msg.alert("��ʾ","����ɹ�");
		},
		failure: function(resp,opts){
			Ext.Msg.alert("��ʾ","����ʧ��");
		}
		});
		}
/*------������ȡ�������ݵĺ��� End---------------*/

/*------��ʼ��ȡ���ݵĺ��� start---------------*/
gridDataData = new Ext.data.Store
({
url: 'frmScmDeliveryMst.aspx?method=getDeliveryMstList',
reader:new Ext.data.JsonReader({
	totalProperty:'totalProperty',
	root:'root'
},[
	{		name:'DeliveryId'	},
	{		name:'DriverId'	},
	{		name:'VehicleId'	},
	{		name:'DriverName'	},
	{		name:'VehicleId'	},
	{		name:'VehicleNo'	},
	{		name:'CreateDate'	},
	{		name:'DeliveryDate'	},
	{		name:'OrgId'	},
	{		name:'DeptId'	},
	{		name:'OperId'	},
	{		name:'OwnerId'	},
	{		name:'DeliveryType'	},
	{		name:'DeliveryStatus'	},
	{		name:'IsActive'	},
	{		name:'TotalQty'	},
	{		name:'TotalAmt'	},
	{		name:'TotalTransFee'	},
	{		name:'DtlCount'	},
	{		name:'DeliveryCount'	},
	{		name:'DeliveryNumber'	},
	{		name:'StockStatus'	},
	{		name:'Ramark'	},
	{		name:'TotalLoadFee'	}	
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
var gridData = new Ext.grid.GridPanel({
	el: 'userGrid',
	width:document.body.offsetWidth,
	height:'100%',
	//autoWidth:true,
	//autoHeight:true,
	autoScroll:true,
	layout: 'fit',
	id: '',
	store: gridDataData,
	loadMask: {msg:'���ڼ������ݣ����Ժ��'},
	sm:sm,
	cm: new Ext.grid.ColumnModel([
		sm,
		new Ext.grid.RowNumberer(),//�Զ��к�
		{
			header:'���ص����',
			dataIndex:'DeliveryId',
			id:'DeliveryId',
			hidden:true,
			hideable:true
		},
		{
			header:'���ر��',
			dataIndex:'DeliveryNumber',
			id:'DeliveryNumber',
			width:100
		},
		{
			header:'��ʻԱ',
			dataIndex:'DriverName',
			id:'DriverName',
			width:120
		},
		{
			header:'����',
			dataIndex:'VehicleNo',
			id:'VehicleNo',
			width:80
		},
		{
			header:'������',
			dataIndex:'TotalQty',
			id:'TotalQty',
			width:60
		},
		{
			header:'�ܽ��',
			dataIndex:'TotalAmt',
			id:'TotalAmt',
			width:70
		},
		{
			header:'���˷�',
			dataIndex:'TotalTransFee',
			id:'TotalTransFee',
			width:70
		},
//		{
//			header:'��������',
//			dataIndex:'CreateDate',
//			id:'CreateDate'
//		},
		{
			header:'��������',
			dataIndex:'DeliveryDate',
			id:'DeliveryDate',
			renderer: Ext.util.Format.dateRenderer('Y��m��d��'),
			width:110
		},
		{
			header:'��������',
			dataIndex:'DeliveryType',
			id:'DeliveryType',
			renderer: function(v) { if (v == 'C011') return '������'; else if(v == 'C012') return 'С����'; },
			width:60
		},
		{
			header:'�Ƿ����',
			dataIndex:'StockStatus',
			id:'StockStatus',
			renderer: function(v) { if (v == 1) return '<font color="blue">��</font>'; else return '<font color="red">��</font>'; },
			width:60
		},
		{
			header:'�Ƿ��ѽ�',
			dataIndex:'DeliveryStatus',
			id:'DeliveryStatus',
			renderer: function(v) { if (v == 1) return '<font color="blue">��</font>'; else return '<font color="red">��</font>'; },
			width:80
		},
		{
			header:'��ϸ��',
			dataIndex:'DtlCount',
			id:'DtlCount',
			width:50
		},
		{
			header:'���ͻ���',
			dataIndex:'DeliveryCount',
			id:'DeliveryCount',
			width:60
		},
		{
			header:'��ע',
			dataIndex:'Ramark',
			id:'Ramark',
			width:100
		}		]),
		bbar: new Ext.PagingToolbar({
			pageSize: 10,
			store: gridDataData,
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
		loadMask: true//,
		//autoExpandColumn: 2
	});
gridData.render();
/*------DataGrid�ĺ������� End---------------*/

function QueryDataGrid() {
    gridDataData.baseParams.OrgId = Ext.getCmp('DeliveryNumber').getValue();            
    gridDataData.baseParams.CustomerId = Ext.getCmp('DriverName').getValue();
    gridDataData.baseParams.BillMode = Ext.getCmp('VehicleNo').getValue();	
    gridDataData.baseParams.StartDate = Ext.util.Format.date(Ext.getCmp('StartDate').getValue(),'Y/m/d');
    gridDataData.baseParams.EndDate =  Ext.util.Format.date(Ext.getCmp('EndDate').getValue(),'Y/m/d');
    gridDataData.load({
        params: {
            start: 0,
            limit: 10
        }
    });
}
gridData.on('rowdblclick', function(grid, rowIndex, e) {
    //������Ʒ��ϸ
    var _record = gridData.getStore().getAt(rowIndex).data.DeliveryId;
    if (!_record) {
        Ext.example.msg('����', '��ѡ��Ҫ�鿴�ļ�¼��');
    } else {
        gridDataDtlData.load({params:{DeliveryId:_record}});
    }

});
///////////////////////////////////////////////
var gridDataDtlData = new Ext.data.Store
({
url: 'frmScmDeliveryMst.aspx?method=getDeliveryProdctList',
reader:new Ext.data.JsonReader({
	totalProperty:'totalProperty',
	root:'root'
},[
	{		name:'ProductId'	},
	{		name:'ProductNo'	},
	{		name:'ProductName'	},
	{		name:'SpecificationsText'	},
	{		name:'UnitId'	},
	{		name:'UnitText'	},
	{		name:'DeliveryQty'	},
	{		name:'TransAmt'	},
	{		name:'LoadAmt'	},
	{		name:'TransPrice'	},
	{		name:'LoadPrice'	}
	])
});
var gridDtlData = new Ext.grid.GridPanel({
	el: 'userDtlGrid',
	//width:'100%',
	height:'100%',
	//autoWidth:true,
	//autoHeight:true,
	autoScroll:true,
	layout: 'fit',
	title: '������Ʒ��ϸ',
	store: gridDataDtlData,
	loadMask: {msg:'���ڼ������ݣ����Ժ��'},
	cm: new Ext.grid.ColumnModel([
		new Ext.grid.RowNumberer(),//�Զ��к�
		{
			header:'���',
			dataIndex:'ProductId',
			id:'ProductId',
			hidden:true,
			hideable:false
		},
		{
			header:'��Ʒ���',
			dataIndex:'ProductNo',
			id:'ProductNo',
			width:100
		},
		{
			header:'��Ʒ����',
			dataIndex:'ProductName',
			id:'ProductName',
			width:180
		},
		{
			header:'���',
			dataIndex:'SpecificationsText',
			id:'SpecificationsText',
			width:80
		},
		{
			header:'��λ',
			dataIndex:'UnitText',
			id:'UnitText',
			width:60
		},
		{
			header:'����',
			dataIndex:'DeliveryQty',
			id:'DeliveryQty',
			width:60
		},
		{
			header:'�˷�',
			dataIndex:'TransAmt',
			id:'TransAmt',
			width:70
		}
		]),
		viewConfig: {
			columnsText: '��ʾ����',
			scrollOffset: 20,
			sortAscText: '����',
			sortDescText: '����',
			forceFit: false
		},
		height: 220,
		closeAction: 'hide',
		stripeRows: true,
		loadMask: true//,
		//autoExpandColumn: 2
	});
gridDtlData.render();
///////////////////////////////////////////////
})
</script>
<body>
<div id='toolbar'></div>
<div id='searchForm'></div>
<div id='userGrid'></div>
<div id='userDtlGrid'></div>

</body>
</html>

