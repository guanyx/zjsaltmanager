<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmPmsIngredients.aspx.cs" Inherits="PMS_frmPmsIngredients" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html>
<head>
<title>��������ά��</title><meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<link rel="stylesheet" type="text/css" href="../ext3/resources/css/ext-all.css" />
<script type="text/javascript" src="../ext3/adapter/ext/ext-base.js"></script>
<script type="text/javascript" src="../ext3/ext-all.js"></script>
</head>
<body>
<div id='toolbar'></div>
<div id='searchForm'></div>
<div id='dataGrid'></div>
<div id='dtlGrid'></div>

</body>
<script type="text/javascript">
Ext.onReady(function(){
/*------ʵ��toolbar�ĺ��� start---------------*/
var saveType;
var Toolbar = new Ext.Toolbar({
	renderTo:"toolbar",
	items:[{
		text:"����",
		icon:"../Theme/1/images/extjs/customer/add16.gif",
		handler:function(){
		    openAddIngredientsWin();
		}
		},'-',{
		text:"�༭",
		icon:"../Theme/1/images/extjs/customer/edit16.gif",
		handler:function(){
		    modifyIngredientsWin();
		}
		},'-',{
		text:"ɾ��",
		icon:"../Theme/1/images/extjs/customer/delete16.gif",
		handler:function(){
		    deleteIngredients();
		}
	}]
});

/*------����toolbar�ĺ��� end---------------*/


/*------��ʼToolBar�¼����� start---------------*//*-----����Ingredientsʵ���ര�庯��----*/
function openAddIngredientsWin() {
	uploadIngredientsWindow.show();
	document.getElementById("editIntgriIFrame").src = "frmPmsIngredientsEdit.aspx?id=0";
}
/*-----�༭Ingredientsʵ���ര�庯��----*/
function modifyIngredientsWin() {
	var sm = IngredientsGrid.getSelectionModel();
	//��ȡѡ���������Ϣ
	var selectData =  sm.getSelected();
	if(selectData == null){
		Ext.Msg.alert("��ʾ","��ѡ����Ҫ�༭����Ϣ��");
		return;
	}
	uploadIngredientsWindow.show();
	document.getElementById("editIntgriIFrame").src = "frmPmsIngredientsEdit.aspx?id=" + selectData.data.Id+"&ProductId="+selectData.data.ProductId;
}
/*-----ɾ��Ingredientsʵ�庯��----*/
/*ɾ����Ϣ*/
function deleteIngredients()
{
	var sm = IngredientsGrid.getSelectionModel();
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
				url:'frmAdmRoleList.aspx?method=deleteIngredients',
				method:'POST',
				params:{
					Id:selectData.data.Id
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

/*------��ʼ�������ݵĴ��� Start---------------*/
if(typeof(uploadIngredientsWindow)=="undefined"){//�������2��windows����
	uploadIngredientsWindow = new Ext.Window({
		id:'Ingredientsformwindow',
		title:''
		, iconCls: 'upload-win'
		, width: 600
		, height: 400
		, plain: true
		, modal: true
		, constrain:true
		, resizable: false
		, closeAction: 'hide'
		, autoDestroy :true
		, html: '<iframe id="editIntgriIFrame" width="100%" height="100%" border=0 src="frmPmsIngredientsEdit.aspx"></iframe>' 
    });
}
uploadIngredientsWindow.addListener("hide",function(){
});

/*------��ʼ��ѯform end---------------*/
var produceIntPanel = new Ext.form.TextField({
    style: 'margin-left:0px',
    cls: 'key',
    xtype: 'textfield',
    fieldLabel: '��Ʒ����',
    name: 'nameCust',
    anchor: '95%'
});

var serchform = new Ext.FormPanel({
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
            name: 'cusStyle',
            columnWidth: .36,
            layout: 'form',
            border: false,
            labelWidth: 55,
            items: [
                produceIntPanel
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
                
                var wsinfo=produceIntPanel.getValue();
                
                dsIngredients.baseParams.ProductName=wsinfo;                
                dsIngredients.load({
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
var dsIngredients = new Ext.data.Store
({
url: 'frmPmsIngredients.aspx?method=getingredientslist',
reader:new Ext.data.JsonReader({
	totalProperty:'totalProperty',
	root:'root'
},[
	{		name:'Id'	},
	{		name:'ProductId'	},
	{		name:'Rate'	},
	{		name:'ParentId'	},
	{       name:'ProductName'},
	{       name:'SpecificationsText'},
	{       name:'UnitText'},
	{		name:'Status'	},
	{		name:'OrgId'	},
	{		name:'OperId'	},
	{		name:'OwnerId'	},
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
var IngredientsGrid = new Ext.grid.GridPanel({
	el: 'dataGrid',
	width:'100%',
	height:180,
	autoWidth:true,
	//autoHeight:true,
	autoScroll:true,
	layout: 'fit',
	title: '��Ʒ��Ϣ',
	store: dsIngredients,
	loadMask: {msg:'���ڼ������ݣ����Ժ��'},
	sm:sm,
	cm: new Ext.grid.ColumnModel([
		sm,
		new Ext.grid.RowNumberer(),//�Զ��к�
		{
			header:'��ˮ',
			dataIndex:'Id',
			id:'Id',
			hidden:true,
			hideable:false
		},
		{
			header:'��Ʒid',
			dataIndex:'ProductId',
			id:'ProductId',
			hidden:true,
			hideable:false
		},
		{
			header:'��Ʒ',
			dataIndex:'ProductName',
			id:'ProductName'
		},
		{
			header:'���',
			dataIndex:'SpecificationsText',
			id:'SpecificationsText'
		},
		{
			header:'��λ',
			dataIndex:'UnitText',
			id:'UnitText'
		},
		{
			header:'����ʱ��',
			dataIndex:'CreateDate',
			id:'CreateDate'
		}
		]),
		bbar: new Ext.PagingToolbar({
			pageSize: 10,
			store: dsIngredients,
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
IngredientsGrid.render();
/*------DataGrid�ĺ������� End---------------*/
/*dblclick*/
IngredientsGrid.on({ 
    rowdblclick:function(grid, rowIndex, e) {
        var rec = grid.store.getAt(rowIndex);
        //alert(rec.get("SendId"));
        dsdtlIngredients.baseParams.ParentId = rec.get("ProductId");
        dsdtlIngredients.load({params:{start:0,limit:10}});
    }
});
/***********dtl**********************/
var dsdtlIngredients = new Ext.data.Store
({
url: 'frmPmsIngredients.aspx?method=getingredientsdtllist',
reader:new Ext.data.JsonReader({
	totalProperty:'totalProperty',
	root:'root'
},[
	{		name:'Id'	},
	{		name:'ProductId'	},
	{		name:'Rate'	},
	{		name:'ParentId'	},
	{       name:'ProductName'},
	{       name:'SpecificationsText'},
	{       name:'UnitText'},
	{		name:'Status'	},
	{		name:'OrgId'	},
	{		name:'OperId'	},
	{		name:'OwnerId'	},
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
/*------��ʼDataGrid�ĺ��� start---------------*/

var smdtl= new Ext.grid.CheckboxSelectionModel({
	singleSelect:true
});
var IngredientsDtlGrid = new Ext.grid.GridPanel({
	el: 'dtlGrid',
	width:'100%',
	height:220,
	autoWidth:true,
	//autoHeight:true,
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
			header:'��Ʒid',
			dataIndex:'ProductId',
			id:'ProductId',
			hidden:true,
			hideable:false
		},
		{
			header:'����',
			dataIndex:'ProductName',
			id:'ProductName'
		},
		{
			header:'���',
			dataIndex:'SpecificationsText',
			id:'SpecificationsText'
		},
		{
			header:'��λ',
			dataIndex:'UnitText',
			id:'UnitText'
		},
		{
			header:'����(%)',
			dataIndex:'Rate',
			id:'Rate'
		},
		{
			header:'����ʱ��',
			dataIndex:'CreateDate',
			id:'CreateDate'
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


})
</script>
</html>

