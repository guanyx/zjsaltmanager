<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmStaticScheme.aspx.cs" Inherits="BA_sysadmin_frmStaticScheme" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>无标题页</title>
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
	        roleactions = ExtJsShowWin('统计方案设置', 'frmAdmGraphStaticSetting.aspx?schemeId=' + schemId, 'graph', 500, 350);
	    }
	    else {
	        document.getElementById("iframegraph").src = 'frmAdmGraphStaticSetting.aspx?schemeId=' + schemId;
	    }
	    roleactions.show();
	}
	
Ext.onReady(function(){
var saveType='';
/*------实现toolbar的函数 start---------------*/
var Toolbar = new Ext.Toolbar({
	renderTo:"toolbar",
	items:[{
		text:"新增",
		icon:"images/extjs/customer/add16.gif",
		handler:function(){
		        saveType="addscheme";
		        openAddSchemeWin();
		    }
		},'-',{
		text:"编辑",
		icon:"images/extjs/customer/edit16.gif",
		handler:function(){
		        saveType="editscheme";
		        modifySchemeWin();
		    }
		},'-',{
		text:"删除",
		icon:"images/extjs/customer/delete16.gif",
		handler:function(){
		        deleteScheme();
		    }
	},'-',{
		text:"设置图标信息",
		icon:"images/extjs/customer/edit16.gif",
		handler:function(){
		        setSchemeGraph();
		    }
	}]
});

/*------结束toolbar的函数 end---------------*/


/*------开始ToolBar事件函数 start---------------*//*-----新增Scheme实体类窗体函数----*/
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
/*-----编辑Scheme实体类窗体函数----*/
function modifySchemeWin() {
	var sm = Ext.getCmp('schemeGrid').getSelectionModel();
	//获取选择的数据信息
	var selectData =  sm.getSelected();
	if(selectData == null){
		Ext.Msg.alert("提示","请选中需要编辑的信息！");
		return;
	}
	uploadSchemeWindow.show();
	setFormValue(selectData);
}

/*-----编辑Scheme实体类窗体函数----*/
function setSchemeGraph() {
	var sm = Ext.getCmp('schemeGrid').getSelectionModel();
	//获取选择的数据信息
	var selectData =  sm.getSelected();
	if(selectData == null){
		Ext.Msg.alert("提示","请选中需要设置图标统计信息的方案！");
		return;
	}
	setReportGraph(selectData.data.SchemeId);
}
/*-----删除Scheme实体函数----*/
/*删除信息*/
function deleteScheme()
{
	var sm = Ext.getCmp('schemeGrid').getSelectionModel();
	//获取选择的数据信息
	var selectData =  sm.getSelected();
	//如果没有选择，就提示需要选择数据信息
	if(selectData == null){
		Ext.Msg.alert("提示","请选中需要删除的信息！");
		return;
	}
	//删除前再次提醒是否真的要删除
	Ext.Msg.confirm("提示信息","是否真的要删除选择的方案信息吗？",function callBack(id){
		//判断是否删除数据
		if(id=="yes")
		{
			//页面提交
			Ext.Ajax.request({
				url:'frmStaticScheme.aspx?method=deletscheme',
				method:'POST',
				params:{
					SchemeId:selectData.data.SchemeId
				},
				success: function(resp,opts){
					Ext.Msg.alert("提示","数据删除成");
				},
				failure: function(resp,opts){
					Ext.Msg.alert("提示","数据删除失败");
				}
			});
		}
	});
}

/*------实现FormPanle的函数 start---------------*/
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
		labelSeparator: '：',
		items: [
		{
			layout:'form',
			border: false,
			columnWidth:1,
			items: [
				{
					xtype:'hidden',
					fieldLabel:'标识',
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
		labelSeparator: '：',
		items: [
		{
			layout:'form',
			border: false,
			columnWidth:1,
			items: [
				{
					xtype:'textfield',
					fieldLabel:'方案名称',
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
		labelSeparator: '：',
		items: [
		{
			layout:'form',
			border: false,
			columnWidth:0.5,
			items: [
				{
					xtype:'textfield',
					fieldLabel:'方案类别',
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
					fieldLabel:'视图名称',
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
		labelSeparator: '：',
		items: [
		{
			layout:'form',
			border: false,
			columnWidth:0.5,
			items: [
				{
					xtype:'textfield',
					fieldLabel:'过滤机构字段',
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
					fieldLabel:'过滤员工字段',
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
		labelSeparator: '：',
		items: [
		{
			layout:'form',
			border: false,
			columnWidth:1,
			items: [
				{
					xtype:'textarea',
					fieldLabel:'方案备注',
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
/*------FormPanle的函数结束 End---------------*/

/*------开始获取数据的函数 start---------------*/
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
/*------获取数据的函数 结束 End---------------*/

var groupByStore = new Ext.data.SimpleStore({
   fields: ['GroupType', 'GroupText'],        
   data : [        
   ['Sum', '合计'],
   ['Group By', '分组'],        
   ['Max', '最大'],
   ['Min', '最小'],
   ['Agv', '平均'],
   ['Count', '计数']  
   ]});
   
function convertBool(val)
{
    if(val==true)
        return "是";
    else(val==false)
        return "否";
    return "";
}
/*------开始DataGrid的函数 start---------------*/

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
	loadMask: {msg:'正在加载数据，请稍侯……'},
	//sm:sm,
	cm: new Ext.grid.ColumnModel([
		sm,itemDeleter,
		{
			header:'统计列',
			dataIndex:'DtlColumn',
			id:'DtlColumn',
			editor:new Ext.form.TextField({
			    listeners:{'change':function(){
                    addNewBlankRow();
                }}
			})
		},
		{
			header:'别名',
			dataIndex:'DtlName',
			id:'DtlName',
			editor:new Ext.form.TextField({})
		},
		{
			header:'是否输出',
			dataIndex:'DtlFout',
			id:'DtlFout',
			renderer:convertBool,
			editor:new Ext.form.Checkbox({})
		},
		{
			header:'统计规则',
			dataIndex:'DtlRule',
			id:'DtlRule',
			editor:new Ext.form.TextField({})
		},
		{
			header:'统计方式',
			dataIndex:'DtlGroupby',
			id:'DtlGroupby',
			editor:new Ext.form.ComboBox({
                    store: groupByStore, // 下拉数据           
                    displayField:'GroupText', //显示上面的fields中的state列的内容,相当于option的text值        
                    valueField: 'GroupType', // 选项的值, 相当于option的value值         
                    mode: 'local', // 必须要,如果为 remote, 则会用ajax获取数据        
                    triggerAction: 'all', // 点击下拉的时候, all 为展出所有Store中data的数据        
                    readOnly: true, // 如果设为true,则好像一般的下拉框一样，默认是false,可输入并自动匹配        
                    emptyText:'请选择比较类型',   
                    width:100,  
                    hidden:true,
                    editable:false,    
                    selectOnFocus:true
			    })
		},
		{
			header:'排序',
			dataIndex:'DtlSort',
			id:'DtlSort',
			editor:new Ext.form.TextField({})
		},
		{
			header:'列计算表达式',
			dataIndex:'DtlExpression',
			id:'DtlExpression',
			editor:new Ext.form.TextField({})
		},
		{
			header:'同比',
			dataIndex:'DtlCmpyear',
			id:'DtlCmpyear',
			renderer:convertBool,
			editor:new Ext.form.Checkbox({})
		},
		{
			header:'环比',
			dataIndex:'DtlCmpchain',
			id:'DtlCmpchain',
			renderer:convertBool,
			editor:new Ext.form.Checkbox({})
		},
		{
			header:'对应时间列',
			dataIndex:'DtlDatecolumn',
			id:'DtlDatecolumn',
			editor:new Ext.form.TextField({})
		}		]),
		
		tbar : [{
                    id : 'btnLoad',
                    text : '获取列信息',
                    iconCls : 'add',
                    handler : function() {
                        getColumnInformation();
                    }
                    }],
		viewConfig: {
			columnsText: '显示的列',
			scrollOffset: 20,
			sortAscText: '升序',
			sortDescText: '降序',
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
    Ext.Msg.wait("正在获取列数据信息","系统提示");
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
/*------开始界面数据的窗体 Start---------------*/
if(typeof(uploadSchemeWindow)=="undefined"){//解决创建2个windows问题
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
			text: "保存"
			, handler: function() {
				getFormValue();
			}
			, scope: this
		},
		{
			text: "取消"
			, handler: function() { 
				uploadSchemeWindow.hide();
			}
			, scope: this
		}]});
	}
	uploadSchemeWindow.addListener("hide",function(){
});

/*------开始获取界面数据的函数 start---------------*/
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
			Ext.Msg.alert("提示","保存成功");
		},
		failure: function(resp,opts){
			Ext.Msg.alert("提示","保存失败");
		}
		});
		}
/*------结束获取界面数据的函数 End---------------*/

/*------开始界面数据的函数 Start---------------*/
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
		Ext.Msg.alert("提示","获取用户信息失败");
	}
	});
}
/*------结束设置界面数据的函数 End---------------*/

/*------开始获取数据的函数 start---------------*/
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

/*------获取数据的函数 结束 End---------------*/

/*------开始DataGrid的函数 start---------------*/

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
	loadMask: {msg:'正在加载数据，请稍侯……'},
	sm:sm,
	cm: new Ext.grid.ColumnModel([
		sm,
		new Ext.grid.RowNumberer(),//自动行号
		{
			header:'方案名称',
			dataIndex:'SchemeName',
			id:'SchemeName'
		},
		{
			header:'方案备注',
			dataIndex:'SchemeMemo',
			id:'SchemeMemo'
		},
		{
			header:'方案类别',
			dataIndex:'SchemeType',
			id:'SchemeType'
		}]),
		bbar: new Ext.PagingToolbar({
			pageSize: 10,
			store: schemeGridData,
			displayMsg: '显示第{0}条到{1}条记录,共{2}条',
			emptyMsy: '没有记录',
			displayInfo: true
		}),
		viewConfig: {
			columnsText: '显示的列',
			scrollOffset: 20,
			sortAscText: '升序',
			sortDescText: '降序',
			forceFit: true
		},
		height: 280,
		closeAction: 'hide',
		stripeRows: true,
		loadMask: true,
		autoExpandColumn: 2
	});
schemeGrid.render();
/*------DataGrid的函数结束 End---------------*/

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
