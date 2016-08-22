<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmStaticScheme.aspx.cs" Inherits="BA_sysadmin_frmStaticScheme" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>�ޱ���ҳ</title>
    <meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<link rel="stylesheet" type="text/css" href="../../ext3/resources/css/ext-all.css" />
<script type="text/javascript" src="../../ext3/adapter/ext/ext-base.js"></script>
<script type="text/javascript" src="../../ext3/ext-all.js"></script>
<script type="text/javascript" src="../../ext3/example/ItemDeleter.js"></script>
<script type="text/javascript" src="../../js/ExtJsHelper.js"></script>
<style type="text/css">
.extensive-remove {
background-image: url(../../Theme/1/images/extjs/customer/cross.gif) ! important;
}
</style>
</head>
<%=getComboBoxSource() %>
<script type="text/javascript">

function setReportGraph(schemId) {
	    if (document.getElementById("iframegraph") == null) {
	        roleactions = ExtJsShowWin('ͳ�Ʒ�������', 'frmAdmGraphStaticSetting.aspx?schemeId=' + schemId, 'graph', 500, 350);
	    }
	    else {
	        document.getElementById("iframegraph").src = 'frmAdmGraphStaticSetting.aspx?schemeId=' + schemId;
	    }
	    roleactions.show();
	}
	
Ext.onReady(function(){
var saveType='';
/*------ʵ��toolbar�ĺ��� start---------------*/
var Toolbar = new Ext.Toolbar({
	renderTo:"toolbar",
	items:[{
		text:"����",
		icon:"images/extjs/customer/add16.gif",
		handler:function(){
		        saveType="addscheme";
		        openAddSchemeWin();
		    }
		},'-',{
		text:"�༭",
		icon:"images/extjs/customer/edit16.gif",
		handler:function(){
		        saveType="editscheme";
		        modifySchemeWin();
		    }
		},'-',{
		text:"ɾ��",
		icon:"images/extjs/customer/delete16.gif",
		handler:function(){
		        deleteScheme();
		    }
	},'-',{
		text:"����ͼ����Ϣ",
		icon:"images/extjs/customer/edit16.gif",
		handler:function(){
		        setSchemeGraph();
		    }
	}]
});

/*------����toolbar�ĺ��� end---------------*/


/*------��ʼToolBar�¼����� start---------------*//*-----����Schemeʵ���ര�庯��----*/
function openAddSchemeWin() {
	Ext.getCmp('SchemeId').setValue("");
	Ext.getCmp('SchemeName').setValue("");
	Ext.getCmp('SchemeMemo').setValue("");
	Ext.getCmp('SchemeType').setValue("");	
	Ext.getCmp('SchemeViewname').setValue(viewName);
	
	schemeDtlGridData.removeAll();
	insertNewBlankRow();
	uploadSchemeWindow.show();
}
/*-----�༭Schemeʵ���ര�庯��----*/
function modifySchemeWin() {
	var sm = Ext.getCmp('schemeGrid').getSelectionModel();
	//��ȡѡ���������Ϣ
	var selectData =  sm.getSelected();
	if(selectData == null){
		Ext.Msg.alert("��ʾ","��ѡ����Ҫ�༭����Ϣ��");
		return;
	}
	uploadSchemeWindow.show();
	setFormValue(selectData);
}

/*-----�༭Schemeʵ���ര�庯��----*/
function setSchemeGraph() {
	var sm = Ext.getCmp('schemeGrid').getSelectionModel();
	//��ȡѡ���������Ϣ
	var selectData =  sm.getSelected();
	if(selectData == null){
		Ext.Msg.alert("��ʾ","��ѡ����Ҫ����ͼ��ͳ����Ϣ�ķ�����");
		return;
	}
	setReportGraph(selectData.data.SchemeId);
}
/*-----ɾ��Schemeʵ�庯��----*/
/*ɾ����Ϣ*/
function deleteScheme()
{
	var sm = Ext.getCmp('schemeGrid').getSelectionModel();
	//��ȡѡ���������Ϣ
	var selectData =  sm.getSelected();
	//���û��ѡ�񣬾���ʾ��Ҫѡ��������Ϣ
	if(selectData == null){
		Ext.Msg.alert("��ʾ","��ѡ����Ҫɾ������Ϣ��");
		return;
	}
	//ɾ��ǰ�ٴ������Ƿ����Ҫɾ��
	Ext.Msg.confirm("��ʾ��Ϣ","�Ƿ����Ҫɾ��ѡ��ķ�����Ϣ��",function callBack(id){
		//�ж��Ƿ�ɾ������
		if(id=="yes")
		{
			//ҳ���ύ
			Ext.Ajax.request({
				url:'frmStaticScheme.aspx?method=deletscheme',
				method:'POST',
				params:{
					SchemeId:selectData.data.SchemeId
				},
				success: function(resp,opts){
					Ext.Msg.alert("��ʾ","����ɾ����");
				},
				failure: function(resp,opts){
					Ext.Msg.alert("��ʾ","����ɾ��ʧ��");
				}
			});
		}
	});
}

/*------ʵ��FormPanle�ĺ��� start---------------*/
var schemeDiv=new Ext.form.FormPanel({
	frame:true,
	title:'',
	region:'north',
	height:120,
	layout:'column',
	items:[
	{
		layout:'column',
		border: false,
		columnWidth:1,
		labelSeparator: '��',
		items: [
		{
			layout:'form',
			border: false,
			columnWidth:1,
			items: [
				{
					xtype:'hidden',
					fieldLabel:'��ʶ',
					columnWidth:1,
					anchor:'98%',
					name:'SchemeId',
					id:'SchemeId'
				}
		]
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
			columnWidth:1,
			items: [
				{
					xtype:'textfield',
					fieldLabel:'��������',
					columnWidth:1,
					anchor:'98%',
					name:'SchemeName',
					id:'SchemeName'
				}
		]
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
			columnWidth:0.5,
			items: [
				{
					xtype:'textfield',
					fieldLabel:'�������',
					columnWidth:0.5,
					anchor:'98%',
					name:'SchemeType',
					id:'SchemeType'
				}
		]
		}
,		{
			layout:'form',
			border: false,
			columnWidth:0.5,
			items: [
				{
					xtype:'textfield',
					fieldLabel:'��ͼ����',
					columnWidth:0.5,
					anchor:'98%',
					name:'SchemeViewname',
					id:'SchemeViewname'
				}
		]
		}
	]},{
		layout:'column',
		border: false,
		labelSeparator: '��',
		items: [
		{
			layout:'form',
			border: false,
			columnWidth:0.5,
			items: [
				{
					xtype:'textfield',
					fieldLabel:'���˻����ֶ�',
					columnWidth:0.5,
					anchor:'98%',
					name:'OrgFilter',
					id:'OrgFilter'
				}
		]
		}
,		{
			layout:'form',
			border: false,
			columnWidth:0.5,
			items: [
				{
					xtype:'textfield',
					fieldLabel:'����Ա���ֶ�',
					columnWidth:0.5,
					anchor:'98%',
					name:'EmpFilter',
					id:'EmpFilter'
				}
		]
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
			columnWidth:1,
			items: [
				{
					xtype:'textarea',
					fieldLabel:'������ע',
					columnWidth:1,
					anchor:'98%',
					name:'SchemeMemo',
					id:'SchemeMemo'
				}
		]
		}
	]
	}
]
});
/*------FormPanle�ĺ������� End---------------*/

/*------��ʼ��ȡ���ݵĺ��� start---------------*/
var schemeDtlGridData = new Ext.data.Store
({
url:'frmStaticScheme.aspx?method=getschemedtllist',
reader:new Ext.data.JsonReader({
	totalProperty:'totalProperty',
	root:'root'
},[
	        {name:'SchemeDtlId'},
	        {name:'SchemeId'},
	        {name:'DtlColumn'},
	        {name:'DtlName'	},
	        {name:'DtlFout',type:'bool'	},
	        {name:'DtlRule'},
	        {name:'DtlGroupby'},
	        {name:'DtlSort'},
	        {name:'DtlExpression'},
	        {name:'DtlCmpyear',type:'bool'},
	        {name:'DtlCmpchain',type:'bool'},
	        {name:'DtlDatecolumn'}])
	,
	listeners:
	{
		scope:this,
		load:function(store){		    
		    if(store.data.length==0)
		    {
		        insertNewBlankRow();
		    }		    
		}
	}
});

var headPattern = Ext.data.Record.create([
            {name:'SchemeDtlId'},
	        {name:'SchemeId'},
	        {name:'DtlColumn'},
	        {name:'DtlName'	},
	        {name:'DtlFout',type:'bool'	},
	        {name:'DtlRule'},
	        {name:'DtlGroupby'},
	        {name:'DtlSort'},
	        {name:'DtlExpression'},
	        {name:'DtlCmpyear',type:'bool'},
	        {name:'DtlCmpchain',type:'bool'},
	        {name:'DtlDatecolumn'}
   ]);
   
function insertNewBlankRow() {
    var rowCount = schemeDtlGrid.getStore().getCount();
    var insertPos = parseInt(rowCount);
    var addRow = new headPattern({
        SchemeDtlId:(1+rowCount),
        SchemeId: '0',
        DtlColumn: '',
        DtlName: '',
        DtlFout:true,
        DtlRule:'',
        DtlGroupby:'',
        DtlSort:rowCount,
        DtlExpression:'',
        DtlCmpyear:false,
        DtlCmpchain:false,
        DtlDatecolumn:''
    });
    schemeDtlGrid.stopEditing();
    if (insertPos > 0) {
        var rowIndex = schemeDtlGrid.getStore().insert(insertPos, addRow);
        schemeDtlGrid.startEditing(insertPos, 0);
    }
    else {
        var rowIndex = schemeDtlGrid.getStore().insert(0, addRow);
        // planDtlGrid.startEditing(0, 0);
    }
}

function insertNewBlankRowByColumnName(column) {
    if(column==null)
        column="";
    var rowCount = schemeDtlGrid.getStore().getCount();
    var insertPos = parseInt(rowCount);
    var addRow = new headPattern({
        SchemeDtlId:(1+rowCount),
        SchemeId: '0',
        DtlColumn: column,
        DtlName: '',
        DtlFout:true,
        DtlRule:'',
        DtlGroupby:'',
        DtlSort:rowCount,
        DtlExpression:'',
        DtlCmpyear:false,
        DtlCmpchain:false,
        DtlDatecolumn:''
    });
    schemeDtlGrid.stopEditing();
    if (insertPos > 0) {
        var rowIndex = schemeDtlGrid.getStore().insert(insertPos, addRow);
        schemeDtlGrid.startEditing(insertPos, 0);
    }
    else {
        var rowIndex = schemeDtlGrid.getStore().insert(0, addRow);
        // planDtlGrid.startEditing(0, 0);
    }
}

function addNewBlankRow() {
    var rowIndex = schemeDtlGrid.getStore().indexOf(schemeDtlGrid.getSelectionModel().getSelected());
    var rowCount = schemeDtlGrid.getStore().getCount();
    if ((rowIndex == 0 && rowCount == 1) || rowIndex == rowCount - 1) {
        insertNewBlankRow();
    }
}
/*------��ȡ���ݵĺ��� ���� End---------------*/

var groupByStore = new Ext.data.SimpleStore({
   fields: ['GroupType', 'GroupText'],        
   data : [        
   ['Sum', '�ϼ�'],
   ['Group By', '����'],        
   ['Max', '���'],
   ['Min', '��С'],
   ['Agv', 'ƽ��'],
   ['Count', '����']  
   ]});
   
function convertBool(val)
{
    if(val==true)
        return "��";
    else(val==false)
        return "��";
    return "";
}
/*------��ʼDataGrid�ĺ��� start---------------*/

var sm= new Ext.grid.CheckboxSelectionModel({
	singleSelect:true
});

var itemDeleter = new Extensive.grid.ItemDeleter();

var schemeDtlGrid = new Ext.grid.EditorGridPanel({
	width:'100%',
	height:'100%',
	region:'center',
	autoWidth:true,
	autoHeight:true,
	autoScroll:true,
	layout: 'fit',
	id: 'schemeDtlGrid',
	selModel: itemDeleter,
	store: schemeDtlGridData,
	loadMask: {msg:'���ڼ������ݣ����Ժ��'},
	//sm:sm,
	cm: new Ext.grid.ColumnModel([
		sm,itemDeleter,
		{
			header:'ͳ����',
			dataIndex:'DtlColumn',
			id:'DtlColumn',
			editor:new Ext.form.TextField({
			    listeners:{'change':function(){
                    addNewBlankRow();
                }}
			})
		},
		{
			header:'����',
			dataIndex:'DtlName',
			id:'DtlName',
			editor:new Ext.form.TextField({})
		},
		{
			header:'�Ƿ����',
			dataIndex:'DtlFout',
			id:'DtlFout',
			renderer:convertBool,
			editor:new Ext.form.Checkbox({})
		},
		{
			header:'ͳ�ƹ���',
			dataIndex:'DtlRule',
			id:'DtlRule',
			editor:new Ext.form.TextField({})
		},
		{
			header:'ͳ�Ʒ�ʽ',
			dataIndex:'DtlGroupby',
			id:'DtlGroupby',
			editor:new Ext.form.ComboBox({
                    store: groupByStore, // ��������           
                    displayField:'GroupText', //��ʾ�����fields�е�state�е�����,�൱��option��textֵ        
                    valueField: 'GroupType', // ѡ���ֵ, �൱��option��valueֵ         
                    mode: 'local', // ����Ҫ,���Ϊ remote, �����ajax��ȡ����        
                    triggerAction: 'all', // ���������ʱ��, all Ϊչ������Store��data������        
                    readOnly: true, // �����Ϊtrue,�����һ���������һ����Ĭ����false,�����벢�Զ�ƥ��        
                    emptyText:'��ѡ��Ƚ�����',   
                    width:100,  
                    hidden:true,
                    editable:false,    
                    selectOnFocus:true
			    })
		},
		{
			header:'����',
			dataIndex:'DtlSort',
			id:'DtlSort',
			editor:new Ext.form.TextField({})
		},
		{
			header:'�м�����ʽ',
			dataIndex:'DtlExpression',
			id:'DtlExpression',
			editor:new Ext.form.TextField({})
		},
		{
			header:'ͬ��',
			dataIndex:'DtlCmpyear',
			id:'DtlCmpyear',
			renderer:convertBool,
			editor:new Ext.form.Checkbox({})
		},
		{
			header:'����',
			dataIndex:'DtlCmpchain',
			id:'DtlCmpchain',
			renderer:convertBool,
			editor:new Ext.form.Checkbox({})
		},
		{
			header:'��Ӧʱ����',
			dataIndex:'DtlDatecolumn',
			id:'DtlDatecolumn',
			editor:new Ext.form.TextField({})
		}		]),
		
		tbar : [{
                    id : 'btnLoad',
                    text : '��ȡ����Ϣ',
                    iconCls : 'add',
                    handler : function() {
                        getColumnInformation();
                    }
                    }],
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
	
function getColumnInformation()
{
    Ext.Msg.wait("���ڻ�ȡ��������Ϣ","ϵͳ��ʾ");
    Ext.Ajax.request({
		url:'frmAdmStaticReportDesign.aspx?method=getviewcolumn',
		method:'POST',
		params:{			
			ReportView:Ext.getCmp('SchemeViewname').getValue()
        },
		success: function(resp,opts){
			var resu = Ext.decode(resp.responseText);
		    var array = resu.errorinfo.split(',');
		    for(var i=0;i<array.length;i++)
		    {
		        var index = schemeDtlGridData.find('HeaderMapcolumn', array[i]);
                if (index < 0)
                {
                    insertNewBlankRowByColumnName(array[i]);
                }                
		    }
		    Ext.Msg.hide();
		},
		failure: function(resp,opts){
			Ext.Msg.hide();
		}
    });
}
/*------��ʼ�������ݵĴ��� Start---------------*/
if(typeof(uploadSchemeWindow)=="undefined"){//�������2��windows����
	uploadSchemeWindow = new Ext.Window({
		id:'Schemeformwindow',
		title:''
		, iconCls: 'upload-win'
		, width: 600
		, height: 350
		,autoScroll:true
		, layout: 'border'
		, plain: true
		, modal: true
		, x:50
		, y:50
		, constrain:true
		, resizable: false
		, closeAction: 'hide'
		,autoDestroy :true
		,items:[schemeDiv,schemeDtlGrid]
		,buttons: [{
			text: "����"
			, handler: function() {
				getFormValue();
			}
			, scope: this
		},
		{
			text: "ȡ��"
			, handler: function() { 
				uploadSchemeWindow.hide();
			}
			, scope: this
		}]});
	}
	uploadSchemeWindow.addListener("hide",function(){
});

/*------��ʼ��ȡ�������ݵĺ��� start---------------*/
function getFormValue()
{
    var headDetail="";
    var i;
    schemeDtlGridData.each(function(store) {
        if(store.data.DtlColumn!='')
        {
            headDetail += Ext.util.JSON.encode(store.data) + ',';
        }
     });
    headDetail = headDetail.substring(0, headDetail.length - 1);
	Ext.Ajax.request({
		url:'frmStaticScheme.aspx?method='+saveType,
		method:'POST',
		params:{
			SchemeId:Ext.getCmp('SchemeId').getValue(),
			SchemeName:Ext.getCmp('SchemeName').getValue(),
			SchemeMemo:Ext.getCmp('SchemeMemo').getValue(),
			SchemeType:Ext.getCmp('SchemeType').getValue(),
			SchemeViewname:Ext.getCmp('SchemeViewname').getValue(),
			OrgFilter:Ext.getCmp('OrgFilter').getValue(),
			EmpFilter:Ext.getCmp('EmpFilter').getValue(),
			ReportId:reportId,
			schemeDtl:headDetail
			},
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
function setFormValue(selectData)
{
	Ext.Ajax.request({
		url:'frmStaticScheme.aspx?method=getscheme',
		params:{
			SchemeId:selectData.data.SchemeId
		},
	success: function(resp,opts){
		var data=Ext.util.JSON.decode(resp.responseText);
		Ext.getCmp("SchemeId").setValue(data.SchemeId);
		Ext.getCmp("SchemeName").setValue(data.SchemeName);
		Ext.getCmp("SchemeMemo").setValue(data.SchemeMemo);
		Ext.getCmp("SchemeType").setValue(data.SchemeType);	
		Ext.getCmp('SchemeViewname').setValue(data.SchemeViewname);
		Ext.getCmp('OrgFilter').setValue(data.OrgFilter),
		Ext.getCmp('EmpFilter').setValue(data.EmpFilter),
		schemeDtlGridData.baseParams.SchemeId = selectData.data.SchemeId;
		schemeDtlGridData.reload();
	},
	failure: function(resp,opts){
		Ext.Msg.alert("��ʾ","��ȡ�û���Ϣʧ��");
	}
	});
}
/*------�������ý������ݵĺ��� End---------------*/

/*------��ʼ��ȡ���ݵĺ��� start---------------*/
var schemeGridData = new Ext.data.Store
({
url: 'frmStaticScheme.aspx?method=getschemelist',
reader:new Ext.data.JsonReader({
	totalProperty:'totalProperty',
	root:'root'
},[
	{
		name:'SchemeId'
	},
	{
		name:'SchemeName'
	},
	{
		name:'SchemeMemo'
	},
	{
		name:'SchemeType'
	},
	{
		name:'Creater'
	},
	{
		name:'OrgId'
	},
	{
		name:'CreateDate'
	},
	{
		name:'DeptId'
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
var schemeGrid = new Ext.grid.GridPanel({
	el: 'schemeGrid1',
	width:'100%',
	height:'100%',
	autoWidth:true,
	autoHeight:true,
	autoScroll:true,
	layout: 'fit',
	id: 'schemeGrid',
	store: schemeGridData,
	loadMask: {msg:'���ڼ������ݣ����Ժ��'},
	sm:sm,
	cm: new Ext.grid.ColumnModel([
		sm,
		new Ext.grid.RowNumberer(),//�Զ��к�
		{
			header:'��������',
			dataIndex:'SchemeName',
			id:'SchemeName'
		},
		{
			header:'������ע',
			dataIndex:'SchemeMemo',
			id:'SchemeMemo'
		},
		{
			header:'�������',
			dataIndex:'SchemeType',
			id:'SchemeType'
		}]),
		bbar: new Ext.PagingToolbar({
			pageSize: 10,
			store: schemeGridData,
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
schemeGrid.render();
/*------DataGrid�ĺ������� End---------------*/

schemeGridData.baseParams.reportId = reportId;
schemeGridData.baseParams.limit=10;
schemeGridData.baseParams.start=0;
schemeGridData.load();

})
</script>
<body>
    <form id="form1" runat="server">
    <div id="toolbar">    
    </div>
    <div id="schemeGrid1"></div>
    </form>
</body>
</html>
