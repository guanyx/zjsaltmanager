<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmPmsIngredientsEdit.aspx.cs" Inherits="PMS_frmPwsIngredients" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html>
<head>
<title>��������ά��</title><meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<link rel="stylesheet" type="text/css" href="../ext3/resources/css/ext-all.css" />
<script type="text/javascript" src="../ext3/adapter/ext/ext-base.js"></script>
<script type="text/javascript" src="../ext3/ext-all.js"></script>
<style type="text/css">
.x-grid-back-blue {  
    background: #C3D9FF;  
}  
</style>
</head>
<body>
<div id='toolbar'></div>
<div id='divForm'></div>
<div id='dtlDataGrid'></div>
<%=getComboBoxStore() %>
</body>
<script type="text/javascript">
function getParamerValue( name )
{
  name = name.replace(/[\[]/,"\\\[").replace(/[\]]/,"\\\]");
  var regexS = "[\\?&]"+name+"=([^&#]*)";
  var regex = new RegExp( regexS );
  var results = regex.exec( window.location.href );
  if( results == null )
    return "";
  else
    return results[1];
}
Ext.onReady(function(){
Ext.BLANK_IMAGE_URL = "../ext3/resources/images/default/s.gif";
/*------ʵ��FormPanle�ĺ��� start---------------*/
var IngredientsForm=new Ext.form.FormPanel({
	renderTo:'divForm',
	frame:true,
	title:'��Ʒ��Ϣ',
	labelWidth:55,
	buttonAlign:'center',
	buttons: [{
		text: "����"
		, handler: function() {
			saveUserData();
		}
		, scope: this
	},
	{
		text: "ȡ��"
		, handler: function() { 
			uploadIngredientsWindow.hide();
		}
		, scope: this
	}],
	items:[
	{
	    layout:'column',
	    items:[
		{
		    layout:'form',
			columnWidth:.4,
	        items:[
		    {
			    xtype:'hidden',
			    fieldLabel:'��ˮ',
			    name:'Id',
			    id:'Id',
			    hidden:true,
			    hideLabel:false
		    }
    ,		{            
			    xtype:'combo',
			    fieldLabel:'��Ʒ',
			    anchor:'98%',
			    name:'ProductId',
			    id:'ProductId',
			    store: dsProductList,
                displayField: 'ProductName',
                valueField: 'ProductId',
                triggerAction: 'all',
                mode:'local',
                editable: true,
                listeners:{ 
                    select:function(combo, record,index){
                        Ext.getCmp('guige').setValue(record.data.SpecificationsText);
                        Ext.getCmp('danwei').setValue(record.data.UnitText);  
                    }     
                }
			}]
		}
,		{
            layout:'form',
            columnWidth:.3,
	        items:[
		    {
			    xtype:'textfield',
			    fieldLabel:'���',
			    anchor:'98%',
			    name:'guige',
			    id:'guige',
			    readOnly:true
			}]
		}
,		{
            layout:'form',
            columnWidth:.3,
	        items:[
		    {
			    xtype:'textfield',
			    fieldLabel:'��λ',
			    anchor:'98%',
			    name:'danwei',
			    id:'danwei',
			    readOnly:true
			}]
		}]
    }		
]
});
IngredientsForm.render();
/*------FormPanle�ĺ������� End---------------*/
/*------��ʼ��ȡ�������ݵĺ��� start---------------*/
function saveUserData()
{
    var json = "";
    dsdtlIngredients.each(function(record) {
        json += Ext.util.JSON.encode(record.data) + ',';
    });
    json = json.substring(0, json.length - 1);
    //Ȼ�����������
    //alert(json);
    
	Ext.Ajax.request({
		url:'frmPmsIngredientsEdit.aspx?method=saveEditData',
		method:'POST',
		params:{
			Id:Ext.getCmp('Id').getValue(),
			ProductId:Ext.getCmp('ProductId').getValue(),
			DetailInfo:	json		},
		success: function(resp,opts){
			Ext.Msg.alert("��ʾ","����ɹ�");
		},
		failure: function(resp,opts){
			Ext.Msg.alert("��ʾ","����ʧ��");
		}
		});
		}
/*------������ȡ�������ݵĺ��� End---------------*/

/*------��ʼ�������ݵĺ��� Start---------------*/
function setFormValue(Id,ProductId)
{
	Ext.Ajax.request({
		url:'frmPmsIngredientsEdit.aspx?method=getingredients',
		params:{
			Id:Id
		},
	success: function(resp,opts){
		var data=Ext.util.JSON.decode(resp.responseText);
		Ext.getCmp("Id").setValue(data.Id);
		Ext.getCmp("ProductId").setValue(data.ProductId);
		Ext.getCmp("guige").setValue(data.SpecificationsText);
		Ext.getCmp("danwei").setValue(data.UnitText);
		
		//ˢ��dtl
		dsdtlIngredients.load({
		    params:{
		        start:0,limit:10,ParentId:ProductId
		    },
		    callback : function(r, options, success) {
                inserNewBlankRow();
            }
		    });
	},
	failure: function(resp,opts){
		Ext.Msg.alert("��ʾ","��ȡ�û���Ϣʧ��");
	}
	});
}
/*------�������ý������ݵĺ��� End---------------*/


/***********dtl**********************/
var RowPattern = Ext.data.Record.create([
   { name: 'Id', type: 'string' },
   { name: 'ProductId', type: 'string' },
   { name: 'Rate', type: 'float' },
   { name: 'ParentId', type: 'string' },
   { name: 'SpecificationsText', type: 'string' },
   { name: 'UnitText', type: 'string' }
 ]);
var dsdtlIngredients = new Ext.data.Store
({
    url: 'frmPmsIngredientsEdit.aspx?method=getingredientsdtllist',
    reader:new Ext.data.JsonReader({
	    totalProperty:'totalProperty',
	    root:'root'
    },RowPattern)
});
function inserNewBlankRow() {
    var rowCount = IngredientsDtlGrid.getStore().getCount();
    //alert(rowCount);
    var insertPos = parseInt(rowCount);
    var addRow = new RowPattern({
        Id: '-1',
        ProductId: '',
        Rate: '',
        ParentId: '',
        SpecificationsText: '',
        UniteText: ''
    });
    IngredientsDtlGrid.stopEditing();
    //����һ����
    if (insertPos > 0) {
        var rowIndex = dsdtlIngredients.insert(insertPos, addRow);
        IngredientsDtlGrid.startEditing(insertPos, 0);
    }
    else {
        var rowIndex = dsdtlIngredients.insert(0, addRow);
        IngredientsDtlGrid.startEditing(0, 0);
    }
}
function addNewBlankRow(combo, record, index) {
    var rowIndex = IngredientsDtlGrid.getStore().indexOf(IngredientsDtlGrid.getSelectionModel().getSelected());
    var rowCount = IngredientsDtlGrid.getStore().getCount();
    //alert('insertPos:'+rowCount+":"+rowIndex);
    //provideGridDtlData.getSelectionModel().selectRow(rowCount - 1,true);   
    if ((rowIndex == 0 && rowCount == 1) || rowIndex == rowCount - 1) {
        inserNewBlankRow();
    }
}

/*------��ʼDataGrid�ĺ��� start---------------*/
var productIntigCombo = new Ext.form.ComboBox({
    store: dsProductList,
    displayField: 'ProductName',
    valueField: 'ProductId',
    triggerAction: 'all',
    id: 'productIntigCombo',
    typeAhead: true,
    mode: 'local',
    emptyText: '',
    selectOnFocus: false,
    editable: true,
    onSelect: function(record) {
        var sm = IngredientsDtlGrid.getSelectionModel().getSelected();
        sm.set('ProductId', record.data.ProductId);
        sm.set('SpecificationsText', record.data.SpecificationsText);
        sm.set('UnitText', record.data.UnitText);
        //�����ֶθ�ֵ
        if(sm.get('id') == undefined ||sm.get('id')==null ||sm.get('id') =="")
        {
            sm.set('Id', 0);
            sm.set('ParentId', 0);
        }        
        addNewBlankRow();
        this.collapse();        
        var rowid = IngredientsDtlGrid.getStore().indexOf(sm);
        IngredientsDtlGrid.startEditing(rowid,6);
    }
});

var smdtl= new Ext.grid.CheckboxSelectionModel({
	singleSelect:true
});
var IngredientsDtlGrid = new Ext.grid.EditorGridPanel({
	el: 'dtlDataGrid',
	width:'100%',
	height:220,
	autoWidth:true,
	clicksToEdit: 1,
	autoScroll:true,
	layout: 'fit',
	title: '������Ϣ',
	store: dsdtlIngredients,
	loadMask: {msg:'���ڼ������ݣ����Ժ��'},
	sm:smdtl,
	cm: new Ext.grid.ColumnModel([
		smdtl,
		new Ext.grid.RowNumberer(),//�Զ��к�
		{
			header:'��ˮ',
			dataIndex:'Id',
			id:'Id',
			hidden:true,
			hideable:false
		},
		{
			header:'����',
			dataIndex:'ProductId',
			id:'ProductId',
			width:150,
			editor:productIntigCombo,
            renderer: function(value, cellmeta, record, rowIndex, columnIndex, store) {
                //���ֵ��ʾ����
                //��ȡ��ǰid="combo_process"��comboBoxѡ���ֵ
                var index = dsProductList.findBy(function(record, id) {
                    return record.get(productIntigCombo.valueField) == value;
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
			dataIndex:'SpecificationsText',
			id:'SpecificationsText',
            renderer:{fn:function(value,cellmeta){
                cellmeta.css='x-grid-back-blue'; 
                return value;
            }}
		},
		{
			header:'��λ',
			dataIndex:'UnitText',
			id:'UnitText',
            renderer:{fn:function(value,cellmeta){
                cellmeta.css='x-grid-back-blue'; 
                return value;
            }}
		},
		{
			header:'����(%)',
			dataIndex:'Rate',
			id:'Rate',
			width:50,
			editor: new Ext.form.NumberField({ allowBlank: true })
		},
		{
			header:'��Ʒ',
			dataIndex:'ParentId',
			id:'ParentId',
			hidden:true,
			hideable:false
		}
		]),
		bbar: new Ext.PagingToolbar({
			pageSize: 10,
			store: dsdtlIngredients,
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
		autoExpandColumn: 2
	});
IngredientsDtlGrid.render();
/*------DataGrid�ĺ������� End---------------*/

var id = getParamerValue('id');
var ProductId = getParamerValue('ProductId');
if(id>0)
    setFormValue(id,ProductId);
else
    addNewBlankRow();

})
</script>
</html>

