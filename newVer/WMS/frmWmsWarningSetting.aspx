<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmWmsWarningSetting.aspx.cs" Inherits="WMS_frmWmsWarningSetting" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html>
<head>
<title>�ֿ�Ԥ������</title><meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<link rel="stylesheet" type="text/css" href="../ext3/resources/css/ext-all.css" />
<script type="text/javascript" src="../ext3/adapter/ext/ext-base.js"></script>
<script type="text/javascript" src="../ext3/ext-all.js"></script>
<script type="text/javascript" src="../js/operateResp.js"></script>
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
/*------ʵ��toolbar�ĺ��� start---------------*/
var Toolbar = new Ext.Toolbar({
	renderTo:"toolbar",
	items:[{
		text:"����",
		icon:"../Theme/1/images/extjs/customer/add16.gif",
		handler:function(){
		    saveType='add';
		    openAddSettingWin();
		    if(productFilterCombo==null)
		        {
		            productFilterCombo = new Ext.form.ComboBox({
                    store: dsProducts,
                    displayField: 'ProductName',
                    displayValue: 'ProductId',
                    typeAhead: false,
                    minChars: 1,
                    id: 'productFilterCombo',
                    loadingText: 'Searching...',
                    //tpl: resultTpl,  
                    pageSize: 10,
                    hideTrigger: true,
                    applyTo: 'ProductName',
                    onSelect: function(record) { // override default onSelect to do redirect                 
                        Ext.getCmp('ProductName').setValue(record.data.ProductName);
                        Ext.getCmp('ProductId').setValue(record.data.ProductId);
                        beforeEdit();                        
                        this.collapse();
                    }
            });
            productFilterCombo.on("blur",changeProduct);
		        }
		    
		}
		},'-',{
		text:"�༭",
		icon:"../Theme/1/images/extjs/customer/edit16.gif",
		handler:function(){
		    saveType = 'save';
		    modifySettingWin();
		    if(productFilterCombo==null)
		        {
		            productFilterCombo = new Ext.form.ComboBox({
                    store: dsProducts,
                    displayField: 'ProductName',
                    displayValue: 'ProductId',
                    typeAhead: false,
                    minChars: 1,
                    id: 'productFilterCombo',
                    loadingText: 'Searching...',
                    //tpl: resultTpl,  
                    pageSize: 10,
                    hideTrigger: true,
                    applyTo: 'ProductName',
                    onSelect: function(record) { // override default onSelect to do redirect                 
                        Ext.getCmp('ProductName').setValue(record.data.ProductName);
                        Ext.getCmp('ProductId').setValue(record.data.ProductId);
                           
                        this.collapse();
                    }
            });
            productFilterCombo.on("blur",changeProduct);
		        }
		    
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
    Ext.getCmp("WhId").setDisabled(false);
	uploadSettingWindow.show();
}
/*-----�༭Settingʵ���ര�庯��----*/
function modifySettingWin() {
	var sm = gridData.getSelectionModel();
	//��ȡѡ���������Ϣ
	var selectData =  sm.getSelected();
	if(selectData == null){
		Ext.Msg.alert("��ʾ","��ѡ����Ҫ�༭����Ϣ��");
		return;
	}
	Ext.getCmp("ProductName").setDisabled(true);
	Ext.getCmp("WhId").setDisabled(true);
	uploadSettingWindow.show();
	setFormValue(selectData);
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
				url:'frmWmsWarningSetting.aspx?method=deleteSetting',
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
function updateUserGrid(){
    var WhId=settingWhNamePanel.getValue();
    var ProductName=settinNamePanel.getValue();
    
    dsSetting.baseParams.WhId = WhId;
    dsSetting.baseParams.ProductName = ProductName;
    
     dsSetting.load({
                params : {
                start : 0,
                limit : 10
                } 
        });
}
/*------ʵ��FormPanle�ĺ��� start---------------*/

//�����Ʒ�������첽���÷���
            var dsProducts;
            if (dsProducts == null) {
                dsProducts = new Ext.data.Store({
                    url: 'frmWmsWarningSetting.aspx?method=getProducts',
                    reader: new Ext.data.JsonReader({
                        root: 'root',
                        totalProperty: 'totalProperty'
                    }, [
                            { name: 'ProductId', mapping: 'ProductId' },
                            { name: 'ProductNo', mapping: 'ProductNo' },
                            { name: 'ProductName', mapping: 'ProductName' },
                            { name: 'Unit', mapping: 'Unit' },
                            { name: 'Supplier', mapping: 'Supplier' },
                            { name: 'SalePriceLower', mapping: 'SalePriceLower' },
                            { name: 'SalePriceLimit', mapping: 'SalePriceLimit' },
                            { name: 'UnitText', mapping: 'UnitText' },
                            { name: 'Specifications', mapping: 'Specifications' },
                            { name: 'SpecificationsText', mapping: 'SpecificationsText' }
                        ])
                });
            }
            

        //�����������첽���÷���,��ǰ�ͻ��ɶ���Ʒ�б�
        var dsProductUnits = new Ext.data.Store({
            url: 'frmWmsWarningSetting.aspx?method=getProductUnits',
            params: {
                ProductId: 0
            },
            reader: new Ext.data.JsonReader({
                root: 'root',
                totalProperty: 'totalProperty',
                id: 'ProductUnits'
            }, [
                { name: 'UnitId', mapping: 'UnitId' },
                { name: 'UnitName', mapping: 'UnitName' }
            ]),
            listeners: {
                load: function() {
                    var combo = Ext.getCmp('UnitId');
                    combo.setValue(combo.getValue());
                }
            }
        });
        dsProductUnits.load();
        function beforeEdit() {
            var productId = Ext.getCmp('ProductId').getValue();
            if (productId != dsProductUnits.baseParams.ProductId) {
                dsProductUnits.baseParams.ProductId = productId;
                dsProductUnits.load();
            }
        }
        
/*------������Ʒ������ start ----------*/
//var dsProdcutStore ;    
//    //���������б��store
//    if (dsProdcutStore == null) { //��ֹ�ظ�����
//        dsProdcutStore = new Ext.data.JsonStore({ 
//        totalProperty : "results", 
//        root : "root", 
//        url : 'frmWmsWarningSetting.aspx?method=getProducts', 
//        fields : ['ProductId', 'ProductName'] 
//            }); 
//       // dsProdcutStore.load();	
//    }
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
			fieldLabel:'�ֿ�',
			columnWidth:1,
			anchor:'90%',
			name:'WhId',
			id:'WhId',
			store:dsWh,
			displayField:'WhName',
			valueField:'WhId',
			mode:'local',
			triggerAction:'all',
			editable:false
		}
,		{
			xtype:'textfield',
			fieldLabel:'��Ʒid',
			columnWidth:1,
			anchor:'90%',
			name:'ProductId',
			id:'ProductId',
			hidden:true,
			hideLabel:true
		}
,		{
			xtype:'textfield',
			fieldLabel:'��Ʒ',
			columnWidth:1,
			anchor:'90%',
			name:'ProductName',
			id:'ProductName'
//			store:dsProdcutStore,
//			pageSize: 5,  
//            minChars: 0,  
//            hideTrigger: true,  
//            typeAhead: true,  
//            mode: 'remote',      
//            emptyText: '��ѡ����Ʒ��Ϣ����',   
//            selectOnFocus: false,
//            editable: true,
//            displayField:'ProductName',
//            valueField:'ProductId'
//            listeners:{ 
//            "select":function(combo, record, index){ 
//                Ext.getCmp("ProductId").setValue(record.data.ProductId);
//                this.collapse();
//             }
//            }              
		}
,		{
			xtype:'combo',
			fieldLabel:'Ԥ�����',
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
			fieldLabel:'Ԥ��ֵ',
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
            fieldLabel: '��λ',
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
/*------FormPanle�ĺ������� End---------------*/

function changeProduct()
{
    var productId = Ext.getCmp("ProductId").getValue();
    var index = dsProducts.find('ProductId', productId);
    if (index < 0)
     {
        Ext.getCmp("ProductName").setValue("");
        Ext.getCmp("ProductId").setValue("");                      
        
     }     
                   
}
/*------��ʼ�������ݵĴ��� Start---------------*/
if(typeof(uploadSettingWindow)=="undefined"){//�������2��windows����
	uploadSettingWindow = new Ext.Window({
		id:'Settingformwindow',
		title:'�ֿ���ƷԤ������'
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
        saveType = 'addSetting';
    else if(saveType =='save')
        saveType = 'saveSetting';
        
	Ext.Ajax.request({
		url:'frmWmsWarningSetting.aspx?method='+saveType,
		method:'POST',
		params:{
			WarningId:Ext.getCmp('WarningId').getValue(),
			WhId:Ext.getCmp('WhId').getValue(),
			ProductId:Ext.getCmp('ProductId').getValue(),
			WarningType:Ext.getCmp('WarningType').getValue(),
			WarningValue:Ext.getCmp('WarningValue').getValue(),
			Remark: Ext.getCmp('Remark').getValue(),
			OrgId:<% =ZJSIG.UIProcess.ADM.UIAdmUser.OrgID(this)%>,
			OperId:<% =ZJSIG.UIProcess.ADM.UIAdmUser.EmployeeID(this)%>,
			OwnerId:<% =ZJSIG.UIProcess.ADM.UIAdmUser.EmployeeID(this)%>,
			UnitId:Ext.getCmp('UnitId').getValue(),
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

/*------��ʼ�������ݵĺ��� Start---------------*/
function setFormValue(selectData)
{    
	Ext.Ajax.request({
		url:'frmWmsWarningSetting.aspx?method=getSetting',
		params:{
			WarningId:selectData.data.WarningId
		},
	success: function(resp,opts){
		var data=Ext.util.JSON.decode(resp.responseText);
		Ext.getCmp("WarningId").setValue(data.WarningId);
		Ext.getCmp("WhId").setValue(data.WhId);
		Ext.getCmp("ProductId").setValue(data.ProductId);
		Ext.getCmp("ProductName").setValue(data.ProductName);
		Ext.getCmp("WarningType").setValue(data.WarningType);
		Ext.getCmp("WarningValue").setValue(data.WarningValue);
		Ext.getCmp("Remark").setValue(data.Remark);
		beforeEdit();  
		Ext.getCmp("UnitId").setValue(data.UnitId);
	},
	failure: function(resp,opts){
		Ext.Msg.alert("��ʾ","��ȡ�ֿ�Ԥ����Ϣʧ�ܣ�");
	}
	});
}
/*------�������ý������ݵĺ��� End---------------*/


/*------��ʼ��ѯform�ĺ��� start---------------*/

var settingWhNamePanel = new Ext.form.ComboBox({
    fieldLabel: '�ֿ�����',
    name: 'settingwarehouseCombo',
    store: dsWh,
    displayField: 'WhName',
    valueField: 'WhId',
    typeAhead: true, //�Զ�����һ����������ѡ�ȫ����
    triggerAction: 'all',
    emptyText: '��ѡ��ֿ�',
    emptyValue: '',
    selectOnFocus: true,
    forceSelection: true,
    anchor: '90%',
    mode:'local',
    editable:false,
    listeners: { specialkey: function(f, e) { if (e.getKey() == e.ENTER) { 
      //Ext.getCmp('searchebtnId').focus(); 
    } } //
    }

});
var settinNamePanel = new Ext.form.TextField({
        style: 'margin-left:0px',
        cls: 'key',
        xtype: 'textfield',
        fieldLabel: '��Ʒ����',
        name: 'settinNameProduct',
        anchor: '90%'
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
            columnWidth: .4,  //����ռ�õĿ�ȣ���ʶΪ20��
            layout: 'form',
            border: false,
            items: [
                settingWhNamePanel
            ]
        }, {
            columnWidth: .4,
            layout: 'form',
            border: false,
            items: [
                settinNamePanel
                ]
        }, {
            columnWidth: .2,
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
url: 'frmWmsWarningSetting.aspx?method=getSettingList',
reader:new Ext.data.JsonReader({
	totalProperty:'totalProperty',
	root:'root'
},[
	{
		name:'WarningId'
	},
	{
		name:'WhId'
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
			header:'�ֿ�',
			dataIndex:'WhName',
			id:'WhId'
		},
		{
			header:'��Ʒ',
			dataIndex:'ProductName',
			id:'ProductName'
		},
		{
			header:'Ԥ�����',
			dataIndex:'WarningTypetext',
			id:'WarningTypetext'
		},
		{
			header:'Ԥ��ֵ',
			dataIndex:'WarningValue',
			id:'WarningValue'
		},
		{
			header:'��ע',
			dataIndex:'Remark',
			id:'Remark'
		}
		]),
		bbar: new Ext.PagingToolbar({
			pageSize: 10,
			store: dsSetting,
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
gridData.render();
/*------DataGrid�ĺ������� End---------------*/

updateUserGrid();

})
</script>

</html>
