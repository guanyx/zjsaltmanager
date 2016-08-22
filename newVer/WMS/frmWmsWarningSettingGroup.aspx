<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmWmsWarningSettingGroup.aspx.cs" Inherits="WMS_frmWmsWarningSettingGroup" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html>
<head>
<title>�ֿ�Ԥ������</title><meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<link rel="stylesheet" type="text/css" href="../ext3/resources/css/ext-all.css" />
<script type="text/javascript" src="../ext3/adapter/ext/ext-base.js"></script>
<script type="text/javascript" src="../ext3/ext-all.js"></script>
<script type="text/javascript" src="../js/operateResp.js"></script>
<script type="text/javascript" src="../js/ProductSelect.js"></script><style type="text/css">
.x-grid-tanstype { 
color:red; 
}
</style>
</head>
<body>
<div id='toolbar'></div>
<div id='searchForm'></div>
<div id='dataGrid'></div>

</body>

<%= getComboBoxStore() %>

<script type="text/javascript">
Ext.BLANK_IMAGE_URL = "../ext3/resources/images/default/s.gif";  //��Ϊ���������������������ͼƬ��ʾ
Ext.onReady(function(){
var saveType;
var dsModeStore = new Ext.data.ArrayStore({
    fields: ['Id', 'Mode'],
    data: [['1','����ӹ�˾�趨'],['2','��Ե����趨'],['9','���ȫʡ�趨']]//['0','����ӹ�˾�ֿ��趨'],�ݲ�֧��
});
var dsProductType = new Ext.data.ArrayStore({
    fields: ['Id', 'Type'],
    data: [['0','���ղ�����Ʒ�����趨'],['1','���ձ�����Ʒ�����趨']]
});
/*------ʵ��toolbar�ĺ��� start---------------*/
var Toolbar = new Ext.Toolbar({
	renderTo:"toolbar",
	items:[{
		text:"����",
		icon:"../Theme/1/images/extjs/customer/add16.gif",
		handler:function(){
		    saveType='add';
		    openAddSettingWin();    
		    
		}
		},'-',{
		text:"ɾ��",
		icon:"../Theme/1/images/extjs/customer/delete16.gif",
		handler:function(){
		    deleteSetting();
		}
	}]
});

/*------����toolbar�ĺ��� end---------------*/


/*------��ʼToolBar�¼����� start---------------*//*-----����Settingʵ���ര�庯��----*/
function openAddSettingWin() {
    Ext.getCmp("ProductName").setDisabled(false);    
	uploadSettingWindow.show();
	Ext.getCmp("ClassType").setValue(0);  
	Ext.getCmp("WarningMode").setValue(1);
	setProductType(0);
}

/*-----ɾ��Settingʵ�庯��----*/
/*ɾ����Ϣ*/
function deleteSetting()
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
				url:'frmWmsWarningSettingGroup.aspx?method=deleteGroupSetting',
				method:'POST',
				params:{
					WarningId:selectData.data.WarningId
				},
				success: function(resp,opts){
					if (checkExtMessage(resp)) {
					    gridData.getStore().remove(selectData);
					}
				},
				failure: function(resp,opts){
					Ext.Msg.alert("��ʾ","����ɾ��ʧ��");
				}
			});
		}
	});
}
var warnNow ="";
function updateUserGrid(){
    var warningType=warningTypePanel.getValue();
    var ProductName=settingNamePanel.getValue();
    
    dsSetting.baseParams.WarningType = warningType;
    dsSetting.baseParams.ProductName = ProductName;
    dsSetting.baseParams.WarnNow = warnNow;
    
     dsSetting.load({
                params : {
                start : 0,
                limit : defaultPageSize
                } 
        });
}
/*------ʵ��FormPanle�ĺ��� start---------------*/

function showFrom()
{
    if (selectProductForm == null) {
        parentUrl = "../CRM/product/frmBaProductClass.aspx?select=true&method=getbaproducttypetree";
        showProductForm("", "", "", true);
        selectProductForm.buttons[0].on("click", selectProductOk);
    }
    else {
        showProductForm("", "", "", true);
    }
}var selectedProductIds = "";
function selectProductOk() {
    var selectProductNames = "";
    selectedProductIds = "";
    var selectNodes = selectProductTree.getChecked();
    if(selectNodes.length>0){
        if(selectNodes.length>1)
            alert("���ѣ���ѡ���˶��Ʒ�֣�ϵͳ��ֻ���õ�һ��Ʒ�֣�");
        Ext.getCmp('ProductId').setValue(selectNodes[0].attributes.id); 
        Ext.getCmp('ProductName').setValue(selectNodes[0].attributes.text);
    }else{
        Ext.getCmp('ProductName').setValue("");
        Ext.getCmp('ProductId').setValue(""); 
    }
}
/*------������Ʒ������ start ----------*/
var dsProdcutStore ;    
//���������б��store
if (dsProdcutStore == null) { //��ֹ�ظ�����
    dsProdcutStore = new Ext.data.JsonStore({ 
    totalProperty : "results", 
    root : "root", 
    url : 'frmWmsWarningSettingGroup.aspx?method=getProductsReport', 
    fields : ['ClassId', 'ClassName'] 
        }); 
    dsProdcutStore.load();	
}
var  dsWarningOrg;
if (dsWarningOrg == null) { //��ֹ�ظ�����
    dsWarningOrg = new Ext.data.JsonStore({ 
    totalProperty : "results", 
    root : "root", 
    url : 'frmWmsWarningSettingGroup.aspx?method=getSettingOrg', 
    fields : ['OrgId', 'OrgName'] 
        }); 
    dsWarningOrg.load({params:{WarningMode:1}});	
}

var settingForm=new Ext.form.FormPanel({
	url:'',
	//renderTo:'divForm',
	frame:true,
	title:'',
	items:[
		{
			xtype:'textfield',
			fieldLabel:'Ԥ����ˮ',
			columnWidth:1,
			anchor:'90%',
			name:'WarningId',
			id:'WarningId',
			hidden:true,
			hideLabel:true
		}
,		{
			xtype:'combo',
			fieldLabel:'Ԥ����ʽ*',
			columnWidth:1,
			anchor:'90%',
			name:'WarningMode',
			id:'WarningMode',
			store:dsModeStore,
            displayField:'Mode',
            valueField:'Id',
			mode:'local',
			triggerAction:'all',
			editable:false ,
            listeners:{ 
            "select":function(combo, record, index){ 
                dsWarningOrg.load({params:{WarningMode:combo.getValue()}});
                this.collapse();
             }
            }   
		}
,		{
			xtype:'combo',
			fieldLabel:'Ԥ����֯*',
			columnWidth:1,
			anchor:'90%',
			name:'WarningOrg',
			id:'WarningOrg',
			store:dsWarningOrg,
			displayField:'OrgName',
			valueField:'OrgId',
			mode:'local',
			triggerAction:'all',
			editable:false
		}
,		{
			xtype:'combo',
			fieldLabel:'Ԥ��Ʒ�����*',
			columnWidth:1,
			anchor:'90%',
			name:'ClassType',
			id:'ClassType',
			store:dsProductType,
            displayField:'Type',
            valueField:'Id',
			mode:'local',
			triggerAction:'all',
			editable:false,
            listeners:{ 
            "select":function(combo, record, index){ 
                setProductType(combo.getValue());
                this.collapse();
             }
            }   
		}
,		{
			xtype:'textfield',
			fieldLabel:'���id',
			columnWidth:1,
			anchor:'90%',
			name:'ProductId',
			id:'ProductId',
			hidden:true,
			hideLabel:true
		}
,		{
			xtype:'textfield',
			fieldLabel:'Ʒ������*',
			columnWidth:1,
			anchor:'90%',
			name:'ProductName',
			id:'ProductName',
            listeners:{ 
            'render': function(combo) { combo.getEl().on('click', showFrom); }
            }              
		}
,		{
			xtype:'combo',
			fieldLabel:'Ʒ������*',
			columnWidth:1,
			anchor:'90%',
			name:'ClassName',
			id:'ClassName',
			store:dsProdcutStore,
            typeAhead: true,  
            mode: 'local',      
            emptyText: '��ѡ����Ʒ��Ϣ����',   
            selectOnFocus: false,
            editable: true,
            displayField:'ClassName',
            valueField:'ClassId',
            listeners:{ 
            "select":function(combo, record, index){ 
                Ext.getCmp("ProductId").setValue(record.data.ClassId);
                this.collapse();
             }
            }              
		}
,		{
			xtype:'combo',
			fieldLabel:'Ԥ������*',
			columnWidth:1,
			anchor:'90%',
			name:'WarningType',
			id:'WarningType',
			store:dsWarningType,
			displayField:'DicsName',
			valueField:'DicsCode',
			mode:'local',
			triggerAction:'all',
			editable:false
		}
,		{
			xtype:'numberfield',
			fieldLabel:'Ԥ��ֵ*',
			columnWidth:1,
			anchor:'90%',
			name:'WarningValue',
			id:'WarningValue'
		},
        {
            xtype: 'combo',
            store: dsProductUnits, //dsWareHouse,
            valueField: 'UnitId',
            displayField: 'UnitName',
            mode: 'local',
            forceSelection: true,
            editable: false,
            name: 'UnitId',
            id: 'UnitId',
            emptyValue: '',
            triggerAction: 'all',
            fieldLabel: '��λ*',
            selectOnFocus: true,
            anchor: '90%'
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
function setProductType( type)
{
 if(type==0){
    Ext.getCmp('ClassName').setVisible(false);   
    Ext.getCmp('ClassName').getEl().up('.x-form-item').setDisplayed(false);  
    Ext.getCmp('ProductName').setVisible(true);   
    Ext.getCmp('ProductName').getEl().up('.x-form-item').setDisplayed(true); 
 }
 else{
    Ext.getCmp('ProductName').setVisible(false);   
    Ext.getCmp('ProductName').getEl().up('.x-form-item').setDisplayed(false);  
    Ext.getCmp('ClassName').setVisible(true);   
    Ext.getCmp('ClassName').getEl().up('.x-form-item').setDisplayed(true); 
 }
}
/*------FormPanle�ĺ������� End---------------*/
/*------��ʼ�������ݵĴ��� Start---------------*/
if(typeof(uploadSettingWindow)=="undefined"){//�������2��windows����
	uploadSettingWindow = new Ext.Window({
		id:'Settingformwindow',
		title:'�ֿ���ƷԤ������'
		, iconCls: 'upload-win'
		, width: 600
		, height: 350
		, layout: 'fit'
		, plain: true
		, modal: true
		, constrain:true
		, resizable: false
		, closeAction: 'hide'
		,autoDestroy :true
		,items:settingForm
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
				uploadSettingWindow.hide();
			}
			, scope: this
		}]});
	}
	uploadSettingWindow.addListener("hide",function(){
	settingForm.getForm().reset();
});

var productFilterCombo = null;

/*------��ʼ��ȡ�������ݵĺ��� start---------------*/
function saveUserData()
{
    if(saveType =='add')
        saveType = 'addSettingGroup';
        
	Ext.Ajax.request({
		url:'frmWmsWarningSettingGroup.aspx?method='+saveType,
		method:'POST',
		params:{
			WarningId:Ext.getCmp('WarningId').getValue(),
			//WhId:Ext.getCmp('WhId').getValue(), �ݲ�ʵ�ֲֿ�
			WarningMode:Ext.getCmp('WarningMode').getValue(),
			WarningOrg:Ext.getCmp('WarningOrg').getValue(),
			ClassType:Ext.getCmp('ClassType').getValue(),
			ProductId:Ext.getCmp('ProductId').getValue(),
			WarningType:Ext.getCmp('WarningType').getValue(),
			WarningValue:Ext.getCmp('WarningValue').getValue(),
			Remark: Ext.getCmp('Remark').getValue(),
			OrgId:<% =ZJSIG.UIProcess.ADM.UIAdmUser.OrgID(this)%>,
			OperId:<% =ZJSIG.UIProcess.ADM.UIAdmUser.EmployeeID(this)%>,
			OwnerId:<% =ZJSIG.UIProcess.ADM.UIAdmUser.EmployeeID(this)%>,
			UnitId:Ext.getCmp('UnitId').getValue()
				},
		success: function(resp,opts){
			if (checkExtMessage(resp)) {
			    dsSetting.reload();
			    uploadSettingWindow.hide();
			}
		},
		failure: function(resp,opts){
			Ext.Msg.alert("��ʾ","����ʧ�ܣ�");
		}
	});
}
/*------������ȡ�������ݵĺ��� End---------------*/

/*------��ʼ��ѯform�ĺ��� start---------------*/

var warningTypePanel = new Ext.form.ComboBox({
    fieldLabel: 'Ԥ������',
    name: 'settingTypeCombo',
    store: dsWarningType,
    displayField: 'DicsName',
    valueField: 'DicsCode',
    typeAhead: true, //�Զ�����һ����������ѡ�ȫ����
    triggerAction: 'all',
    emptyText: '��ѡ��',
    emptyValue: '',
    selectOnFocus: true,
    forceSelection: true,
    anchor: '98%',
    mode:'local',
    editable:false,
    listeners: { specialkey: function(f, e) { if (e.getKey() == e.ENTER) { 
      //Ext.getCmp('searchebtnId').focus(); 
    } } //
    }

});
var settingNamePanel = new Ext.form.TextField({
        style: 'margin-left:0px',
        cls: 'key',
        xtype: 'textfield',
        fieldLabel: '��֯����',
        name: 'settingNameOrg',
        anchor: '98%'
    });
                    
var serchform = new Ext.FormPanel({
    renderTo: 'searchForm',
    labelAlign: 'left',
    layout: 'fit',
    buttonAlign: 'right',
    bodyStyle: 'padding:5px',
    frame: true,
    labelWidth: 55,
    items: [{
        layout: 'column',   //�����Ԫ��Ϊ����Ϊ�в��ַ�ʽ
        border: false,
        items: [{
            columnWidth: .3,  //����ռ�õĿ�ȣ���ʶΪ20��
            layout: 'form',
            border: false,
            items: [
                warningTypePanel
            ]
        }, {
            columnWidth: .3,
            layout: 'form',
            border: false,
            items: [
                settingNamePanel
                ]
        }, {
            columnWidth: .3,
            layout: 'form',
            border: false,
            labelWidth: 70,
            items: [{
                xtype: 'checkbox',
			    anchor: '98%',
			    name: 'ShowActionValue',
			    id: 'ShowActionValue',
			    fieldLabel: '��ʾʵ��ֵ',                
			    listeners: {
                    check: function(checkbox, checked) {
                        if (checked) 
                            warnNow="true";
                        else
                            warnNow="";
                        alert(warnNow);alert(checked);
                    }
                }
            }]
        }, {
            columnWidth: .1,
            layout: 'form',
            border: false,
            items: [{ cls: 'key',
                xtype: 'button',
                text: '��ѯ',
                anchor: '50%',
                handler :function(){
                updateUserGrid();
                
                }
            }]
        }]
    }]
});


/*------��ʼ��ѯform�ĺ��� end---------------*/


/*------��ʼ��ȡ���ݵĺ��� start---------------*/
var dsSetting = new Ext.data.Store
({
url: 'frmWmsWarningSettingGroup.aspx?method=getSettingGroupList',
reader:new Ext.data.JsonReader({
	totalProperty:'totalProperty',
	root:'root'
},[
	{
		name:'WarningId'
	},
	{
		name:'WarningOrg'
	},
	{
		name:'WhId'
	},
	{
		name:'OrgName'
	},
	{
		name:'WhName'
	},
	{
		name:'ProductId'
	},
	{
		name:'ProductName'
	},
	{
		name:'WarningTypetext'
	},
	{
		name:'WarningValue'
	},
	{
		name:'ActualValue'
	},
	{
		name:'UnitId'
	},
	{
		name:'ClassType'
	},
	{
		name:'ClassId'
	},
	{
		name:'Remark'
	}
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
 defaultPageSize = 10;
    var toolBar = new Ext.PagingToolbar({
        pageSize: defaultPageSize,
        store: dsSetting,
        displayMsg: '��ʾ��{0}����{1}����¼,��{2}��',
        emptyMsy: 'û�м�¼',
        displayInfo: true
    });
    var pageSizestore = new Ext.data.SimpleStore({
        fields: ['pageSize'],
        data: [[10], [20], [30]]
    });
    var combo = new Ext.form.ComboBox({
        regex: /^\d*$/,
        store: pageSizestore,
        displayField: 'pageSize',
        typeAhead: true,
        mode: 'local',
        emptyText: '����ÿҳ��¼��',
        triggerAction: 'all',
        selectOnFocus: true,
        width: 135
    });
    toolBar.addField(combo);

    combo.on("change", function(c, value) {
        toolBar.pageSize = value;
        defaultPageSize = toolBar.pageSize;
    }, toolBar);
    combo.on("select", function(c, record) {
        toolBar.pageSize = parseInt(record.get("pageSize"));
        defaultPageSize = toolBar.pageSize;
        updateUserGrid();
    }, toolBar);
var sm= new Ext.grid.CheckboxSelectionModel({
	singleSelect:true
});
var gridData = new Ext.grid.GridPanel({
	el: 'dataGrid',
	width:'100%',
	height:'100%',
	autoWidth:true,
	autoHeight:true,
	autoScroll:true,
	layout: 'fit',
	id: '',
	store: dsSetting,
	loadMask: {msg:'���ڼ������ݣ����Ժ��'},
	sm:sm,
	cm: new Ext.grid.ColumnModel([
		sm,
		new Ext.grid.RowNumberer(),//�Զ��к�
		{
			header:'Ԥ����ˮ',
			dataIndex:'WarningId',
			id:'WarningId',
			hidden:true,
			hideable:false
		},
		{
			header:'��֯����',
			dataIndex:'OrgName',
			id:'OrgName'
		},
		{
			header:'Ʒ������',
			dataIndex:'ProductName',
			id:'ProductName'
		},
		{
			header:'Ԥ������',
			dataIndex:'WarningTypetext',
			id:'WarningTypetext'
		},
		{
			header:'Ԥ��ֵ',
			dataIndex:'WarningValue',
			id:'WarningValue'
		},
		{
			header:'ʵ��ֵ',
			dataIndex:'ActualValue',
			id:'ActualValue'
		},
		{
			header:'��λ',
			dataIndex:'UnitId',
			id:'UnitId',
			renderer: function(value, cellmeta, record, rowIndex, columnIndex, store) {
                var index = dsProductUnits.findBy(function(record, id) {  
	                return record.get("UnitId")==value; 
                });
                var record = dsProductUnits.getAt(index);
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
			header:'��ע',
			dataIndex:'Remark',
			id:'Remark'
		}
		]),
		bbar: toolBar,
		viewConfig: {
			columnsText: '��ʾ����',
			scrollOffset: 20,
			sortAscText: '����',
			sortDescText: '����',
			forceFit: true,
			getRowClass: function(r, i, p, s) {
                if (r.data.WarningTypetext.indexOf('ȱ��') > -1) {
                    if(r.data.WarningValue>=r.data.ActualValue)
                        return "x-grid-tanstype";
                }else if(r.data.WarningTypetext.indexOf('����') > -1) {
                    if(r.data.WarningValue<r.data.ActualValue)
                        return "x-grid-tanstype";
                }
            }
		},
		height: 280,
		closeAction: 'hide',
		stripeRows: true,
		loadMask: true,
		autoExpandColumn: 2
	});
gridData.render();
/*------DataGrid�ĺ������� End---------------*/

//updateUserGrid();

})
</script>

</html>
