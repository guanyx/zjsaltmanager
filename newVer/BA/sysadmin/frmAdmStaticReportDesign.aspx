<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmAdmStaticReportDesign.aspx.cs" Inherits="BA_sysadmin_frmAdmStaticReportDesign" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>无标题页</title>
    <link rel="stylesheet" type="text/css" href="../../ext3/resources/css/ext-all.css" />
<script type="text/javascript" src="../../ext3/adapter/ext/ext-base.js"></script>
<script type="text/javascript" src="../../ext3/ext-all.js"></script>
<script type="text/javascript" src="../../js/ExtJsHelper.js"></script>
<script type="text/javascript" src="../../js/operateResp.js"></script>
<%=getComboBoxSource()%>
<script type="text/javascript">

function setReportGraph(reportID,reportView) {
	    if (document.getElementById("iframescheme") == null) {
	        roleactions = ExtJsShowWin('统计方案设置', 'frmStaticScheme.aspx?reportId=' + reportID+'&viewName='+reportView, 'scheme', 700, 500);
	    }
	    else {
	        document.getElementById("iframescheme").src = 'frmStaticScheme.aspx?reportId=' + reportID+'&viewName='+reportView;
	    }
	    roleactions.show();
	}
	
Ext.onReady(function(){
var saveType="";
/*------实现toolbar的函数 start---------------*/
var Toolbar = new Ext.Toolbar({
	renderTo:"toolbar",
	items:[{
		text:"新增",
		icon:"images/extjs/customer/add16.gif",
		handler:function(){
		    saveType="add";
		    openAddReportWin();
		}
		},'-',{
		text:"编辑",
		icon:"images/extjs/customer/edit16.gif",
		handler:function(){
		        saveType="edit";
		        modifyReportWin();
		    }
		},'-',{
		text:"删除",
		icon:"images/extjs/customer/delete16.gif",
		handler:function(){
		        deleteReport();
		    }
	},'-',{
		text:"设置图标统计信息",
		icon:"images/extjs/customer/edit16.gif",
		handler:function(){
		        setStaticScheme();
		    }
	}]
});

/*------结束toolbar的函数 end---------------*/


/*------开始ToolBar事件函数 start---------------*//*-----新增Report实体类窗体函数----*/
function openAddReportWin() {
	Ext.getCmp('ReportId').setValue("");
	Ext.getCmp('ReportName').setValue("");
	Ext.getCmp('ReportView').setValue("");
	Ext.getCmp('ReportMemo').setValue("");
	Ext.getCmp('ReportType').setValue("");
	Ext.getCmp('OrgFilter').setValue("");
	Ext.getCmp('EmpFilter').setValue("");
    headGridData.removeAll();
    insertNewBlankRow();
	uploadReportWindow.show();
}
/*-----编辑Report实体类窗体函数----*/
function modifyReportWin() {
	var sm = Ext.getCmp('reportGrid').getSelectionModel();
	//获取选择的数据信息
	var selectData =  sm.getSelected();
	if(selectData == null){
		Ext.Msg.alert("提示","请选中需要编辑的信息！");
		return;
	}
	uploadReportWindow.show();
	setFormValue(selectData);
}

function setStaticScheme()
{
    var sm = Ext.getCmp('reportGrid').getSelectionModel();
	//获取选择的数据信息
	var selectData =  sm.getSelected();
	if(selectData == null){
		Ext.Msg.alert("提示","请选中需要设置方案的统计的信息！");
		return;
	}
	setReportGraph(selectData.data.ReportId,selectData.data.ReportView);
}
/*-----删除Report实体函数----*/
/*删除信息*/
function deleteReport()
{
	var sm = Ext.getCmp('reportGrid').getSelectionModel();
	//获取选择的数据信息
	var selectData =  sm.getSelected();
	//如果没有选择，就提示需要选择数据信息
	if(selectData == null){
		Ext.Msg.alert("提示","请选中需要删除的信息！");
		return;
	}
	//删除前再次提醒是否真的要删除
	Ext.Msg.confirm("提示信息","是否真的要删除选择的报表信息吗？",function callBack(id){
		//判断是否删除数据
		if(id=="yes")
		{
			//页面提交
			Ext.Ajax.request({
				url:'frmAdmStaticReportDesign.aspx?method=deleteReport',
				method:'POST',
				params:{
					ReportId:selectData.data.ReportId
				},
				success: function(resp,opts){
					Ext.Msg.alert("提示","数据删除成");
					Ext.getCmp('reportGrid').getStore().reload();
				},
				failure: function(resp,opts){
					Ext.Msg.alert("提示","数据删除失败");
				}
			});
		}
	});
}

/*------实现FormPanle的函数 start---------------*/
var reportDivform=new Ext.form.FormPanel({
   region:'north',
   height:200,
	frame:true,
	items:[
		{
			xtype:'hidden',
			fieldLabel:'标识',
			columnWidth:1,
			anchor:'90%',
			name:'ReportId',
			id:'ReportId'
		}
,		{
			xtype:'textfield',
			fieldLabel:'统计名称',
			columnWidth:1,
			anchor:'90%',
			name:'ReportName',
			id:'ReportName'
		}
,		{
			xtype:'textfield',
			fieldLabel:'所属视图',
			columnWidth:1,
			anchor:'90%',
			name:'ReportView',
			id:'ReportView'
		}
,		{
			xtype:'textfield',
			fieldLabel:'备注',
			columnWidth:1,
			anchor:'90%',
			name:'ReportMemo',
			id:'ReportMemo'
		}
,		{
			xtype: 'combo',
            fieldLabel: '部门类别',
            columnWidth: 1,
            anchor: '90%',
            name: 'ReportType',
            id: 'ReportType',
            editable:false,
            store: ReportTypeStore,
            displayField: 'DicsName',
            valueField: 'DicsCode',
            typeAhead: true,
            mode: 'local',
            emptyText: '请选择部门类别信息',
            triggerAction: 'all'
		}
,		{
			xtype:'textfield',
			fieldLabel:'主键信息',
			columnWidth:1,
			anchor:'90%',
			name:'ReportPrimarykey',
			id:'ReportPrimarykey'
		}
		,		{
			xtype:'textfield',
			fieldLabel:'过滤机构字段',
			columnWidth:1,
			anchor:'90%',
			name:'OrgFilter',
			id:'OrgFilter'
		}
		,		{
			xtype:'textfield',
			fieldLabel:'过滤员工字段',
			columnWidth:1,
			anchor:'90%',
			name:'EmpFilter',
			id:'EmpFilter'
		}
]
});
/*------FormPanle的函数结束 End---------------*/
/*------开始获取数据的函数 start---------------*/



var headGridData = new Ext.data.Store
({
url: 'frmAdmStaticReportDesign.aspx?method=getheaderlist',
reader:new Ext.data.JsonReader({
	totalProperty:'totalProperty',
	root:'root'
},[
	{
		name:'HeaderId'
	},
	{
		name:'ReprotId'
	},
	{
		name:'HeaderText'
	},
	{
		name:'HeaderMapcolumn'
	},
	{
		name:'HeaderSort'
	},
	{
		name:'HeaderLeave'
	},
	{
		name:'ParentId'
	},
	{
		name:'ColumnType'
	},{
		name:'HeaderWidth'
	}	])
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
           { name: 'HeaderId', type: 'string' },
           { name: 'ReprotId', type: 'string' },
           { name: 'HeaderText', type: 'string' },
           { name: 'HeaderMapcolumn', type: 'string' },
           { name: 'HeaderSort' },
           { name:'HeaderLeave'},
           { name:'ParentId'},
           {name:'ColumnType'},
           {name:'HeaderWidth'}
          ]);

function insertNewBlankRow() {
    var rowCount = headGrid.getStore().getCount();
    var insertPos = parseInt(rowCount);
    var addRow = new headPattern({
        HeaderId:(1+rowCount),
        ReprotId: '0',
        HeaderText: '',
        HeaderMapcolumn: '',
        HeaderSort: '1',
        HeaderLeave:'1',
        ParentId:'0',
        ColumnType:'',
        HeaderWidth:'80'
    });
    headGrid.stopEditing();
    if (insertPos > 0) {
        var rowIndex = headGrid.getStore().insert(insertPos, addRow);
        headGrid.startEditing(insertPos, 0);
    }
    else {
        var rowIndex = headGrid.getStore().insert(0, addRow);
        // planDtlGrid.startEditing(0, 0);
    }
}

function insertNewBlankRowByColumnName(column) {
    var rowCount = headGrid.getStore().getCount();
    var insertPos = parseInt(rowCount);
    var addRow = new headPattern({
        HeaderId:(1+rowCount),
        ReprotId: '0',
        HeaderText: '',
        HeaderMapcolumn: column,
        HeaderSort:'',
        HeaderLeave:'',
        ParentId:'0',
        ColumnType:''
    });
    headGrid.stopEditing();
    if (insertPos > 0) {
        var rowIndex = headGrid.getStore().insert(insertPos, addRow);
        headGrid.startEditing(insertPos, 0);
    }
    else {
        var rowIndex = headGrid.getStore().insert(0, addRow);
        // planDtlGrid.startEditing(0, 0);
    }
}

function addNewBlankRow() {
    var rowIndex = headGrid.getStore().indexOf(headGrid.getSelectionModel().getSelected());
    var rowCount = headGrid.getStore().getCount();
    if ((rowIndex == 0 && rowCount == 1) || rowIndex == rowCount - 1) {
        insertNewBlankRow();
    }
}

/*------获取数据的函数 结束 End---------------*/
/*------开始DataGrid的函数 start---------------*/

var sm= new Ext.grid.CheckboxSelectionModel({
	singleSelect:true
});
var headGrid = new Ext.grid.EditorGridPanel({
//	width:,
//	height:'100%',
	region:'center',
	autoWidth:true,
	autoHeight:true,
	autoScroll:true,
	id: 'headGrid',
	store: headGridData,
	loadMask: {msg:'正在加载数据，请稍侯……'},
	sm:sm,
	cm: new Ext.grid.ColumnModel([
		sm,{
			header:'标识',
			dataIndex:'HeaderId',
			id:'HeaderId'
		},
		{
			header:'表头',
			dataIndex:'HeaderText',
			id:'HeaderText',
			editor:new Ext.form.TextField({
			        listeners:{'change':function(){
                    addNewBlankRow();
                    }}
			    })
		},
		{
			header:'对应列',
			dataIndex:'HeaderMapcolumn',
			id:'HeaderMapcolumn',
			editor:new Ext.form.TextField({})
		},
		{
			header:'数据类型',
			dataIndex:'ColumnType',
			id:'ColumnType',
			editor:new Ext.form.TextField({})
		},{
			header:'级别',
			dataIndex:'HeaderLeave',
			id:'HeaderLeave',
			editor:new Ext.form.TextField({})
		},{
			header:'上级',
			dataIndex:'ParentId',
			id:'ParentId',
			editor:new Ext.form.TextField({})
		},
		{
			header:'序号',
			dataIndex:'HeaderSort',
			id:'HeaderSort',
			editor:new Ext.form.TextField({})
		}	,
		{
			header:'宽度',
			dataIndex:'HeaderWidth',
			id:'HeaderWidth',
			editor:new Ext.form.NumberField({})
		}	]),
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
    Ext.Ajax.request({
		url:'frmAdmStaticReportDesign.aspx?method=getviewcolumn',
		method:'POST',
		params:{			
			ReportView:Ext.getCmp('ReportView').getValue()
        },
		success: function(resp,opts){
			var resu = Ext.decode(resp.responseText);
		    var array = resu.errorinfo.split(',');
		    for(var i=0;i<array.length;i++)
		    {
		        var index = headGridData.find('HeaderMapcolumn', array[i]);
                if (index < 0)
                {
                    insertNewBlankRowByColumnName(array[i]);
                }                
		    }
		},
		failure: function(resp,opts){
			
		}
    });
}
//	var tree = new Ext.ux.tree.ColumnTree({
//        width: 800,
//        height: 300,
//        rootVisible: false,
//        autoScroll: true,
//        title: '资源信息',
//        renderTo: 'orgGrid',
//        id: 'treeColumn',

//        columns: [{
//            header: '标题',
//            width: 220,
//            dataIndex: 'text'
//        }, {
//            header: '对应字段',
//            width: 100,
//            dataIndex: 'CustomerColumn'
//        }, {
//            header: '序号',
//            width: 200,
//            dataIndex: 'CustomerColumn1'
//        }],

//            loader: new Ext.tree.TreeLoader({
//                dataUrl: 'frmAdmOrgList.aspx?method=gettreecolumnlist',
//                uiProviders: {
//                    'col': Ext.ux.tree.ColumnNodeUI
//                }
//            }),

//            root: new Ext.tree.AsyncTreeNode({
//                text: 'Tasks'
//            })
//        });
	
//    var tree = new Ext.tree.TreePanel({
//        useArrows: true,
//        region:'west',
//        id:'tree',
//        width:200,
//        autoScroll: true,
//        animate: true,
//        enableDD: true,
//        root:root
//    });
//    
//    // set the root node
//    var root=new Ext.tree.TreeNode({
//		id:"root",
//		text:"树的根"});

//    tree.setRootNode(root);
//    addTreeNode();
//    var currentNode = new Ext.tree.TreeNode;
//    tree.on('contextmenu',function(node,event){  
//          //alert("node.id="+ node.id);
//          currentNode = node;
//	      //var selModel = tree.getSelectionModel();
//	      //selModel.select(currentNode);  //右键响应定位当前节点，但不响应点击事件
//	      currentNode.select();
//          event.preventDefault(); //这行是必须的
//          //控制右键菜单子菜单          
//          rightClick.showAt(event.getXY());//取得鼠标点击坐标，展示菜单
//    });
// function iniTreeNode()
// {
//    
// }   
//    function addTreeNode()
//    {
//        var node = new Ext.tree.TreeNode({
//            id:'1'
//            ,text:'测试'});
//        root.appendChild(node);
//    }
//    
//    //定义右键菜单
//    var rightClick = new Ext.menu.Menu({
//        id :'rightClickCont',
//        items : [{
//            id:'addItem',
//            text : '新增',
//            icon:"../../Theme/1/images/extjs/customer/add16.gif",
//            //增加菜单点击事件
//            handler:function (){
//                Ext.MessageBox.prompt( 
//                    "Input", 
//                    "请输入head名称:", 
//                    function(button,text){ 
//                    if(button=="ok") 
//                    {
//                        Ext.MessageBox.alert("number","the number is "+text); 
//                        var tempNode = new Ext.tree.TreeNode({
//                            id:-20,text:text});
//                        currentNode.appendChild(tempNode);
//                    }
//                    else 
//                        Ext.MessageBox.alert("sorry","the number is null."); 
//                    } 
//                ); 
//            }
//        }, {
//            id:'deleteItem',
//            text : '新增子列头',
//            icon:"../../Theme/1/images/extjs/customer/add16.gif",
//            handler:function (){
//                 
//            }
//        }, {
//            id:'deleteItem',
//            text : '编辑',
//            icon:"../../Theme/1/images/extjs/customer/edit16.gif",
//            handler:function (){
//                 Ext.MessageBox.prompt( 
//                    "Input", 
//                    "请输入修改后的head名称:",
//                    function(button,text){ 
//                        if(button=="ok") 
//                        {
//                            currentNode.setText(text);
//                        }
//                    }
//                ); 
//            }
//        }, {
//            id:'forbiddenItem',
//            text : '删除',
//            icon:"../../Theme/1/images/extjs/customer/forbidden16.gif",
//            handler:function (){
//                 
//            }
//        }]
//     }); 


     
/*------开始界面数据的窗体 Start---------------*/
if(typeof(uploadReportWindow)=="undefined"){//解决创建2个windows问题
	uploadReportWindow = new Ext.Window({
		id:'Reportformwindow',
		title:'设置统计报表信息'
		, iconCls: 'upload-win'
		, width: 600
		, height: 450
		, plain: true
		,layout:'border'
		, modal: true
		, constrain:true
		, resizable: false
		, closeAction: 'hide'
		,autoScroll:true
		,autoDestroy :true
		,items:[reportDivform,headGrid]
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
				uploadReportWindow.hide();
			}
			, scope: this
		}]});
	}
	uploadReportWindow.addListener("hide",function(){
});

/*------开始获取界面数据的函数 start---------------*/
function getFormValue()
{
     var headDetail="";
         headGridData.each(function(store) {
            if(store.data.HeaderSort=='')
            {
                
            }
            else
            {
                headDetail += Ext.util.JSON.encode(store.data) + ',';
            }
         });
         headDetail = headDetail.substring(0, headDetail.length - 1);

	Ext.Ajax.request({
		url:'frmAdmStaticReportDesign.aspx?method='+saveType,
		method:'POST',
		params:{
			ReportId:Ext.getCmp('ReportId').getValue(),
			ReportName:Ext.getCmp('ReportName').getValue(),
			ReportView:Ext.getCmp('ReportView').getValue(),
			ReportMemo:Ext.getCmp('ReportMemo').getValue(),
			ReportType:Ext.getCmp('ReportType').getValue(),
			ReportPrimarykey:Ext.getCmp('ReportPrimarykey').getValue(),
			OrgFilter:Ext.getCmp('OrgFilter').getValue(),
			EmpFilter:Ext.getCmp('EmpFilter').getValue(),
//			OperId:Ext.getCmp('OperId').getValue(),
//			CreateDate:Ext.getCmp('CreateDate').getValue(),
//			OrgId:Ext.getCmp('OrgId').getValue(),
			headDetail:headDetail
        },
		success: function(resp,opts){
			if(checkExtMessage(resp))
            {
               
            }
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
		url:'frmAdmStaticReportDesign.aspx?method=getreport',
		params:{
			ReportId:selectData.data.ReportId
		},
	success: function(resp,opts){
		var data=Ext.util.JSON.decode(resp.responseText);
		Ext.getCmp("ReportId").setValue(data.ReportId);
		Ext.getCmp("ReportName").setValue(data.ReportName);
		Ext.getCmp("ReportView").setValue(data.ReportView);
		Ext.getCmp("ReportMemo").setValue(data.ReportMemo);
		Ext.getCmp("ReportType").setValue(data.ReportType);
		Ext.getCmp('ReportPrimarykey').setValue(data.ReportPrimarykey);
		Ext.getCmp('OrgFilter').setValue(data.OrgFilter);
		Ext.getCmp('EmpFilter').setValue(data.EmpFilter);
//		Ext.getCmp("OperId").setValue(data.OperId);
//		Ext.getCmp("CreateDate").setValue(data.CreateDate);
//		Ext.getCmp("OrgId").setValue(data.OrgId);
        if(headGridData.baseParams.ReportId!=data.ReportId)
        {
            headGridData.baseParams.ReportId = data.ReportId;
            headGridData.load();
        }
	},
	failure: function(resp,opts){
		Ext.Msg.alert("提示","获取用户信息失败");
	}
	});
}
/*------结束设置界面数据的函数 End---------------*/

/*------开始获取数据的函数 start---------------*/
var reportGridData = new Ext.data.Store
({
url: 'frmAdmStaticReportDesign.aspx?method=getreportlist',
reader:new Ext.data.JsonReader({
	totalProperty:'totalProperty',
	root:'root'
},[
	{
		name:'ReportId'
	},
	{
		name:'ReportName'
	},
	{
		name:'ReportView'
	},
	{
		name:'ReportMemo'
	},
	{
		name:'ReportType'
	},
	{
		name:'OperId'
	},
	{
		name:'CreateDate'
	},
	{
		name:'OrgId'
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

function cmbReportType(val) {
    var index = ReportTypeStore.find('DicsCode', val);
    if (index < 0)
        return "";
    var record = ReportTypeStore.getAt(index);
    return record.data.DicsName;
}
/*------开始DataGrid的函数 start---------------*/

var sm= new Ext.grid.CheckboxSelectionModel({
	singleSelect:true
});
var reportGrid = new Ext.grid.GridPanel({
	el: 'reportGrid',
	width:'100%',
	height:'100%',
	autoWidth:true,
	autoHeight:true,
	autoScroll:true,
	layout: 'fit',
	id: 'reportGrid',
	store: reportGridData,
	loadMask: {msg:'正在加载数据，请稍侯……'},
	sm:sm,
	cm: new Ext.grid.ColumnModel([
		sm,
		new Ext.grid.RowNumberer(),//自动行号
		{
			header:'标识',
			dataIndex:'ReportId',
			id:'ReportId'
		},
		{
			header:'统计名称',
			dataIndex:'ReportName',
			id:'ReportName'
		},
		{
			header:'所属视图',
			dataIndex:'ReportView',
			id:'ReportView'
		},
		{
			header:'备注',
			dataIndex:'ReportMemo',
			id:'ReportMemo'
		},
		{
			header:'统计类型',
			dataIndex:'ReportType',
			id:'ReportType',
			renderer:cmbReportType
		},
		{
			header:'创建人',
			dataIndex:'OperId',
			id:'OperId'
		},
		{
			header:'创建时间',
			dataIndex:'CreateDate',
			id:'CreateDate'
		},
		{
			header:'所属机构',
			dataIndex:'OrgId',
			id:'OrgId'
		}		]),
		bbar: new Ext.PagingToolbar({
			pageSize: 10,
			store: reportGridData,
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
reportGrid.render();
/*------DataGrid的函数结束 End---------------*/



})
</script>
</head>
<body>
<div id='toolbar'></div>
<div id='reportDiv'></div>
<div id='reportGrid'></div>

</body>
</html>
