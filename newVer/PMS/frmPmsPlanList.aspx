<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmPmsPlanList.aspx.cs" Inherits="PMS_frmPmsPlan" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html>
<head>
<title>�����ƻ�ά��</title><meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<link rel="stylesheet" type="text/css" href="../ext3/resources/css/ext-all.css" />
<script type="text/javascript" src="../ext3/adapter/ext/ext-base.js"></script>
<script type="text/javascript" src="../ext3/ext-all.js"></script>
<script type="text/javascript" src="../js/operateResp.js"></script>
<style type="text/css">
.x-grid-back-blue {  
    background: #C3D9FF;  
}  
</style>
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
		    saveType = 'addPlan';
		    openAddPlanWin();
		    addNewBlankRow();
		}
		},'-',{
		text:"�༭",
		icon:"../Theme/1/images/extjs/customer/edit16.gif",
		handler:function(){
		    saveType = 'savePlan';
		    modifyPlanWin();
		}
		},'-',{
		text:"ɾ��",
		icon:"../Theme/1/images/extjs/customer/delete16.gif",
		handler:function(){
		    deletePlan();
		}
	}]
});

/*------����toolbar�ĺ��� end---------------*/


/*------��ʼToolBar�¼����� start---------------*//*-----����Planʵ���ര�庯��----*/
function openAddPlanWin() {
	uploadPlanWindow.show();
}
/*-----�༭Planʵ���ര�庯��----*/
function modifyPlanWin() {
	var sm = pmsPlanGrid.getSelectionModel();
	//��ȡѡ���������Ϣ
	var selectData =  sm.getSelected();
	if(selectData == null){
		Ext.Msg.alert("��ʾ","��ѡ����Ҫ�༭����Ϣ��");
		return;
	}
	uploadPlanWindow.show();
	setFormValue(selectData);
	setGridValue(selectData);
}
/*-----ɾ��Planʵ�庯��----*/
/*ɾ����Ϣ*/
function deletePlan()
{
	var sm = pmsPlanGrid.getSelectionModel();
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
				url:'frmPmsPlanList.aspx?method=deletePlan',
				method:'POST',
				params:{
					PlanId:selectData.data.PlanId
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
var pmsPlanForm=new Ext.form.FormPanel({
	url:'',	
	frame:true,
	title:'',
	labelWidth:55,
	region:'north',
	height:140,
	items:[
		{
			xtype:'hidden',
			fieldLabel:'�ƻ�ID',
			name:'PlanId',
			id:'PlanId',
			hidden:true,
			hideLabel:true
		}
,		{
			xtype:'combo',
			fieldLabel:'����',
			columnWidth:1,
			anchor:'98%',
			name:'WorkshopId',
			id:'WorkshopId',
			store:dsWs,
			displayField:'WsName',
		    valueField:'WsId',
		    mode:'local',
		    triggerAction:'all',
		    editable: false
		}
,		{
            layout:'column',
            items:[
            {
                layout:'form',
                columnWidth:0.495,
                items:[{
			        xtype:'combo',
			        fieldLabel:'�������',			    
			        anchor:'98%',
			        name:'Year',
			        id:'Year',
			        store:dsYear,
			        displayField:'DicsName',
		            valueField:'DicsCode',
		            mode:'local',
		            triggerAction:'all'
			    }]
			},
			{
			    layout:'form',
                columnWidth:0.495,
                items:[{
			        xtype:'combo',
			        fieldLabel:'�����·�',
			        anchor:'98%',
			        name:'Month',
			        id:'Month',
			        store:dsMonth,
			        displayField:'DicsName',
		            valueField:'DicsCode',
		            mode:'local',
		            triggerAction:'all'
			    }]
		    }]
		}
,		{
			xtype:'textarea',
			fieldLabel:'��ע',
			columnWidth:1,
			anchor:'98%',
			width:50,
			name:'Remark',
			id:'Remark'
		}
]
});
/*------FormPanle�ĺ������� End---------------*/
/*------��ϸgrid�ĺ��� start---------------*/
var RowPattern = Ext.data.Record.create([
   { name: 'PlanDetailId', type: 'string' },
   { name: 'PlanId', type: 'string' },
   { name: 'ProductId', type: 'string' },
   { name: 'SpecificationsText', type: 'string' },
   { name: 'UnitText', type: 'string' },
   { name: 'PlanQty', type: 'float' },
   { name: 'PlanWeight', type: 'float' },
   { name: 'Dates', type: 'string' }
 ]);
var dspmsplandtl = new Ext.data.Store
({
url: 'frmPmsPlanList.aspxx?method=getplandtllist',
reader:new Ext.data.JsonReader({
	totalProperty:'totalProperty',
	root:'root'
},RowPattern)
});
function inserNewBlankRow() {
    var rowCount = planDtlInfoGrid.getStore().getCount();
    //alert(rowCount);
    var insertPos = parseInt(rowCount);
    var addRow = new RowPattern({
        PlanDetailId: '-1',
        PlanId: '-1',
        ProductId: '',
        SpecificationsText: '',
        UnitText: '',
        PlanQty: '',
        PlanWeight:'',
        Dates:''
    });
    planDtlInfoGrid.stopEditing();
    //����һ����
    if (insertPos > 0) {
        var rowIndex = dspmsplandtl.insert(insertPos, addRow);
        planDtlInfoGrid.startEditing(insertPos, 0);
    }
    else {
        var rowIndex = dspmsplandtl.insert(0, addRow);
        planDtlInfoGrid.startEditing(0, 0);
    }
}
function addNewBlankRow(combo, record, index) {
    var rowIndex = planDtlInfoGrid.getStore().indexOf(planDtlInfoGrid.getSelectionModel().getSelected());
    var rowCount = planDtlInfoGrid.getStore().getCount();
    //alert('insertPos:'+rowCount+":"+rowIndex);
    //provideGridDtlData.getSelectionModel().selectRow(rowCount - 1,true);   
    if ((rowIndex == 0 && rowCount == 1) || rowIndex == rowCount - 1) {
        inserNewBlankRow();
    }
}
function setGridValue(selectData){
    dspmsplandtl.baseParams.RecodrId=selectData.data.PlanId;                    
    dspmsplandtl.load({
        callback : function(r, options, success) {
            inserNewBlankRow();
        }
    });
}

var smDtl= new Ext.grid.CheckboxSelectionModel({
	singleSelect:true
});
/*------��ʼ��ϸDataGrid�ĺ��� start---------------*/
var productCombo = new Ext.form.ComboBox({
    store: dsProductList,
    displayField: 'ProductName',
    valueField: 'ProductId',
    triggerAction: 'all',
    id: 'productCombo',
    typeAhead: true,
    mode: 'local',
    emptyText: '',
    selectOnFocus: false,
    editable: true,
    onSelect: function(record) {
        var sm = planDtlInfoGrid.getSelectionModel().getSelected();
        sm.set('ProductId', record.data.ProductId);
        sm.set('SpecificationsText', record.data.SpecificationsText);
        sm.set('UnitText', record.data.UnitText);
        //�����ֶθ�ֵ
        if(sm.get('id') == undefined ||sm.get('id')==null ||sm.get('id') =="")
        {
            sm.set('Id', 0);
            sm.set('RecordId', 0);
        }        
        addNewBlankRow();
        this.collapse();        
        var rowid = planDtlInfoGrid.getStore().indexOf(sm);
        planDtlInfoGrid.startEditing(rowid,6);
    }
});
var planDtlInfoGrid = new Ext.grid.EditorGridPanel({	
	width:'100%',
	//height:'100%',
	autoWidth:true,
	//autoHeight:true,
	autoScroll:true,
	region: 'center',
	clicksToEdit: 1,
	enableHdMenu: false,  //����ʾ�����ֶκ���ʾ����������
	enableColumnMove: false,//�в����ƶ�
	id: '',
	store: dspmsplandtl,
	loadMask: {msg:'���ڼ������ݣ����Ժ��'},
	sm:smDtl,
	cm: new Ext.grid.ColumnModel([
	    smDtl,
		new Ext.grid.RowNumberer(),//�Զ��к�
		{
			header:'��ˮ��',
			dataIndex:'Id',
			id:'Id',
			hidden: true,
            hideable: false
		},
		{
			header:'��Ʒ',
			dataIndex:'ProductId',
			id:'ProductId',
			width:150,
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
			header:'���',
			width:50,
			dataIndex:'SpecificationsText',
			id:'SpecificationsText',
            renderer:{fn:function(value,cellmeta){
                cellmeta.css='x-grid-back-blue'; 
                return value;
            }}
		},
		{
			header:'��λ',
			width:50,
			dataIndex:'UnitText',
			id:'UnitText',
            renderer:{fn:function(value,cellmeta){
                cellmeta.css='x-grid-back-blue'; 
                return value;
            }}
		},
		{
			header:'Ԥ����������',
			dataIndex:'PlanQty',
			id:'PlanQty',
			width:50,
			editor: new Ext.form.NumberField({ allowBlank: true })
		},
		{
			header:'Ԥ����������',
			dataIndex:'PlanWeight',
			id:'PlanWeight',
			width:50,
			editor: new Ext.form.NumberField({ allowBlank: true })
		},
		{
			header:'�ճ̣�ָ�����º�����',
			dataIndex:'Dates',
			id:'Dates',
			width:150,
			editor: new Ext.form.TextArea({ allowBlank: false })
		}
		]),
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
/*------��ϸgrid�ĺ��� End---------------*/
/*------��ʼ�������ݵĴ��� Start---------------*/
if(typeof(uploadPlanWindow)=="undefined"){//�������2��windows����
	uploadPlanWindow = new Ext.Window({
		id:'Planformwindow',
		title:'�����ƻ�'
		, iconCls: 'upload-win'
		, width: 750
		, height: 450
		, layout: 'border'
		, plain: true
		, modal: true
		, constrain:true
		, resizable: false
		, closeAction: 'hide'
		,autoDestroy :true
		,items:[pmsPlanForm,planDtlInfoGrid]
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
				uploadPlanWindow.hide();
			}
			, scope: this
		}]});
	}
	uploadPlanWindow.addListener("hide",function(){
	    pmsPlanForm.getForm().reset();
});

/*------��ʼ��ȡ�������ݵĺ��� start---------------*/
function saveUserData()
{
    var json = "";
    dspmsplandtl.each(function(record) {
        json += Ext.util.JSON.encode(record.data) + ',';
    });
    json = json.substring(0, json.length - 1);
    //Ȼ�����������
    //alert(json);
    //alert(saveType);
	Ext.Ajax.request({
		url:'frmPmsPlanList.aspx?method='+saveType,
		method:'POST',
		params:{
			PlanId:Ext.getCmp('PlanId').getValue(),
			WorkshopId:Ext.getCmp('WorkshopId').getValue(),
			Year:Ext.getCmp('Year').getValue(),
			Month:Ext.getCmp('Month').getValue(),
			Remark:Ext.getCmp('Remark').getValue(),
			DetailInfo:json
			},
		success: function(resp,opts){
		    if(checkExtMessage(resp)){
			   dsPmsPlanData.reload({params:{start:0,limit:10}});
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
		url:'frmPmsPlanList.aspx?method=getplan',
		params:{
			PlanId:selectData.data.PlanId
		},
	success: function(resp,opts){
		var data=Ext.util.JSON.decode(resp.responseText);
		Ext.getCmp("PlanId").setValue(data.PlanId);
		Ext.getCmp("WorkshopId").setValue(data.WorkshopId);
		Ext.getCmp("Year").setValue(data.Year);
		Ext.getCmp("Month").setValue(data.Month);
		Ext.getCmp("Remark").setValue(data.Remark);
	},
	failure: function(resp,opts){
		Ext.Msg.alert("��ʾ","��ȡ�û���Ϣʧ��");
	}
	});
}
/*------�������ý������ݵĺ��� End---------------*/
/*------��ʼ��ѯform end---------------*/

    //����
    var planWsIdPanel = new Ext.form.ComboBox({
        xtype:'combo',
        fieldLabel:'����',
        anchor:'95%',
        name:'StartDate',
        id:'StartDate',
		store:dsWs,
		displayField:'WsName',
	    valueField:'WsId',
	    mode:'local',
	    triggerAction:'all',
	    editable: false
    });

    //���
    var planYearPanel = new Ext.form.ComboBox({
        xtype:'combo',
        fieldLabel:'���',
        anchor:'95%',
        name:'EndDate',
        id:'EndDate',
        store:dsYear,
        displayField:'DicsName',
        valueField:'DicsCode',
        mode:'local',
        triggerAction:'all'
    });
    //�·�
    var planMonthPanel = new Ext.form.ComboBox({
        cls: 'key',
        xtype: 'combo',
        fieldLabel: '�·�',
        name: 'nameCust',
        anchor: '95%',
        store:dsMonth,
        displayField:'DicsName',
        valueField:'DicsCode',
        mode:'local',
        triggerAction:'all'
    });

    var serchform = new Ext.FormPanel({
        renderTo: 'divForm',
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
                columnWidth: .28,  //����ռ�õĿ�ȣ���ʶΪ20��
                layout: 'form',
                border: false,
                items: [
                    planWsIdPanel
                ]
            }, {
                columnWidth: .28,
                layout: 'form',
                border: false,
                items: [
                    planYearPanel
                    ]
            }, {
                name: 'cusStyle',
                columnWidth: .36,
                layout: 'form',
                border: false,
                labelWidth: 55,
                items: [
                    planMonthPanel
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
                    
                    var strWsId=planWsIdPanel.getValue();
                    var strYear=planYearPanel.getValue();
                    var strMonth=planMonthPanel.getValue();
                    
                    dsPmsPlanData.baseParams.WorkshopId=strWsId;
                    dsPmsPlanData.baseParams.Year=strYear;
                    dsPmsPlanData.baseParams.Month=strMonth;
                    
                    dsPmsPlanData.load({
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
var dsPmsPlanData = new Ext.data.Store
({
url: 'frmPmsPlanList.aspx?method=getPmsPlanList',
reader:new Ext.data.JsonReader({
	totalProperty:'totalProperty',
	root:'root'
},[
	{		name:'PlanId'	},
	{		name:'OrgId'	},
	{		name:'OperId'	},
	{		name:'OwnerId'	},
	{		name:'WorkshopId'	},
	{		name:'Year'	},
	{		name:'Month'	},
	{		name:'Remark'	},
	{		name:'CreateDate'	},
	{		name:'UpdateDate'
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
var pmsPlanGrid = new Ext.grid.GridPanel({
	el: 'dataGrid',
	width:'100%',
	height:'100%',
	autoWidth:true,
	autoHeight:true,
	autoScroll:true,
	layout: 'fit',
	id: '',
	store: dsPmsPlanData,
	loadMask: {msg:'���ڼ������ݣ����Ժ��'},
	sm:sm,
	cm: new Ext.grid.ColumnModel([
		sm,
		new Ext.grid.RowNumberer(),//�Զ��к�
		{
			header:'�ƻ�ID',
			dataIndex:'PlanId',
			id:'PlanId',
			hidden:true,
			hideable:false
		},
		{
			header:'����',
			dataIndex:'WorkshopId',
			id:'WorkshopId',
			renderer:function(v){
			   var index = dsWs.findBy(function(record, id) {
                    return record.get('WsId') == v;
               });			    
			   return dsWs.getAt(index).get('WsName');
			}
		},
		{
			header:'�������',
			dataIndex:'Year',
			id:'Year',
			renderer:function(v){
			    return v+'��';
			}
		},
		{
			header:'�����·�',
			dataIndex:'Month',
			id:'Month',
			renderer:function(v){
			    return v+'��';
			}
		},
		{
			header:'��ע',
			dataIndex:'Remark',
			id:'Remark'
		},
		{
			header:'��������',
			dataIndex:'CreateDate',
			id:'CreateDate',
			renderer: Ext.util.Format.dateRenderer('Y��m��d��')
		}
		]),
		bbar: new Ext.PagingToolbar({
			pageSize: 10,
			store: dsPmsPlanData,
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
pmsPlanGrid.render();
/*------DataGrid�ĺ������� End---------------*/



})
</script>

</html>
