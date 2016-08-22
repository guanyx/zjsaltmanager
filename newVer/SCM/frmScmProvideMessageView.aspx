<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmScmProvideMessageView.aspx.cs" Inherits="SCM_frmScmProvideMessage" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>采购订单</title>
    <link rel="stylesheet" type="text/css" href="../ext3/resources/css/ext-all.css" />
<script type="text/javascript" src="../ext3/adapter/ext/ext-base.js"></script>
<script type="text/javascript" src="../ext3/ext-all.js"></script>
<script type="text/javascript" src="../js/operateResp.js"></script>
<script type="text/javascript" src="../js/FilterControl.js"></script>
<%=getComboBoxSource()%>
<script type="text/javascript">
var imageUrl = "../Theme/1/";
function getCmbStore(columnName)
    {
        switch(columnName)
        {
            case"PlanType":
                return cmbPlanTypeList;
            case"Status":
                return cmbStatusList;
            default:
                return null;
        }
    }
    
var formTitle='';
Ext.BLANK_IMAGE_URL = "../ext3/resources/images/default/s.gif";
Ext.onReady(function(){
/*------实现toolbar的函数 start---------------*/
var Toolbar = new Ext.Toolbar({
	renderTo:"toolbar",
	items:[{
		text:"查看",
		icon:imageUrl+"images/extjs/customer/view16.gif",
		handler:function(){
		        viewMessageWin();
		    }
		}
	]
});

/*------结束toolbar的函数 end---------------*/


/*------开始ToolBar事件函数 start---------------*/
/*-----Message实体类窗体函数----*/
function viewMessageWin() {
	var sm = Ext.getCmp('messageGrid').getSelectionModel();
	//获取选择的数据信息
	var selectData =  sm.getSelected();
	if(selectData == null){
		Ext.Msg.alert("提示","请选中需要编辑的信息！");
		return;
	}
	uploadMessageWindow.show();
	setFormValue(selectData);
	
	//不可编辑
	var cm = Ext.getCmp('messageGrid').getColumnModel();
    for(var i=0;i<cm.getColumnCount();i++)
        cm.setEditable(i,false);
    messageDiv.getForm().items.eachKey(function(key,item){      
        //item.setDisabled(true)  
        if(item.xtype.indexOf('text')>-1)
            item.el.dom.readOnly=true;  
        else
            item.setDisabled(true);  
    })      
}

/*------实现FormPanle的函数 start---------------*/
var messageDiv=new Ext.form.FormPanel({
	frame:true,
	title:'',
	region:'north',
	adOnly:true,
	height:100,
	items:[
	{
		layout:'column',
		border: false,
		labelSeparator: '：',
		items: [
		{
			layout:'form',
			border: false,
			columnWidth:0.66,
			items: [
				{
					xtype:'textfield',
					fieldLabel:'供应商标识',
					columnWidth:0.66,
					anchor:'90%',
					name:'CustomerId',
					id:'CustomerId',
					hideLabel:true,
					hidden:true
				}
		]
		},{
		    layout:'form',
			border: false,
			columnWidth:0.66,
			items: [
				{
					xtype:'textfield',
					fieldLabel:'供应商',
					columnWidth:0.66,
					anchor:'90%',
					name:'CustomerName',
					id:'CustomerName'
				}
		]
		}
,		{
			layout:'form',
			border: false,
			columnWidth:0.33,
			items: [
				{
					xtype:'datefield',
					fieldLabel:'日期',
					columnWidth:0.33,
					anchor:'90%',
					name:'SendDate',
					id:'SendDate'
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
			columnWidth:0.33,
			items: [
				{
					xtype:'textfield',
					fieldLabel:'操作人',
					columnWidth:0.33,
					anchor:'90%',
					name:'OperatId',
					id:'OperatId'
				}
		]
		}
,		{
			layout:'form',
			border: false,
			columnWidth:0.33,
			items: [
				{
					xtype:'textfield',
					fieldLabel:'创建时间',
					columnWidth:0.33,
					anchor:'90%',
					name:'CreateDate',
					id:'CreateDate'
				}
		]
		}
,		{
			layout:'form',
			border: false,
			columnWidth:0.33,
			items: [
				{
					xtype:'combo',
					fieldLabel:'状态',
					columnWidth:0.33,
					anchor:'90%',
					name:'Status',
					id:'Status',
					store:cmbStatusList,
					editable:false,
			        triggerAction: 'all',
				    mode: 'local',
				    displayField: 'DicsName',
				    valueField: 'DicsCode'
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
			columnWidth:0.33,
			items: [
				{
					xtype:'combo',
					fieldLabel:'对应计划类型',
					columnWidth:0.33,
					anchor:'90%',
					name:'PlanType',
					id:'PlanType',
					store:cmbPlanTypeList,
					editable:false,
			        triggerAction: 'all',
				    mode: 'local',
				    displayField: 'DicsName',
				    valueField: 'DicsCode'
				}
		]
		}
,		{
			layout:'form',
			border: false,
			columnWidth:0.33,
			items: [
				{
					xtype:'datefield',
					fieldLabel:'开始日期',
					columnWidth:0.33,
					anchor:'90%',
					name:'StartDate',
					id:'StartDate',
					format: "Y年m月d日"
				}
		]
		}
,		{
			layout:'form',
			border: false,
			columnWidth:0.33,
			items: [
				{
					xtype:'datefield',
					fieldLabel:'结束日期',
					columnWidth:0.33,
					anchor:'90%',
					name:'EndDate',
					id:'EndDate',
					format: "Y年m月d日"
				}
		]
		}
	]
	}
]
});
/*------FormPanle的函数结束 End---------------*/

/*------开始获取细项数据的函数 start---------------*/
var msgDtlGridData = new Ext.data.Store
({
url:'frmScmProvideMessageView.aspx?method=getdtllist',
reader:new Ext.data.JsonReader({
	totalProperty:'totalProperty',
	root:'root'
},[
	{
		name:'ProvideMessageDetailId'
	},
	{
		name:'ProvideMessageId'
	},
	{
		name:'ProvidePlanId'
	},
	{
		name:'ProductId'
	},
	{
		name:'MessageQtv'
	},
	{
		name:'SenderAdd'
	},
	{
		name:'SendType'
	},
	{
		name:'ProductName'
	},
	{
		name:'Memo'
	}	])
});

/*------获取数据的函数 结束 End---------------*/

function cmbSendType(val) {
    var index = SendTypeStore.find('DicsCode', val);
    if (index < 0)
        return "";
    var record = SendTypeStore.getAt(index);
    return record.data.DicsName;
}
/*------开始DataGrid的函数 start---------------*/

var sm= new Ext.grid.CheckboxSelectionModel({
	singleSelect:true
});
var msgDtlGrid = new Ext.grid.EditorGridPanel({
	width:'100%',
	height:200,
	autoWidth:true,
	region:'center',
	autoHeight:true,
	autoScroll:true,
	layout: 'fit',
	id: 'msgDtlGrid',
	store: msgDtlGridData,
	loadMask: {msg:'正在加载数据，请稍侯……'},
	sm:sm,
	cm: new Ext.grid.ColumnModel([
		sm,
		new Ext.grid.RowNumberer(),//自动行号
		{
		    header:'产品名称',
			dataIndex:'ProductName',
			id:'ProductName'
		},
		{
		    header:'订购数量',
			dataIndex:'MessageQtv',
			id:'MessageQtv'
		},
		{
		    header:'送货港口',
			dataIndex:'SenderAdd',
			id:'SenderAdd',
			editor:new Ext.form.TextField({})
		},
		{
		    header:'发送方式',
			dataIndex:'SendType',
			id:'SendType',
			renderer:cmbSendType,
			editor:new Ext.form.ComboBox({
			    name:'SendType',
			    id:'SendType',
			    store:SendTypeStore,
			    displayField: 'DicsName',
			    valueField: 'DicsCode',
			    typeAhead: true,
			    editable:false,
			    mode: 'local',
			    emptyText: '请选择部门类别信息',
			    triggerAction: 'all'})
		},
		{
		    header:'备注',
			dataIndex:'Memo',
			id:'Memo',
			editor:new Ext.form.TextField({})
		}		]),
		bbar: new Ext.PagingToolbar({
			pageSize: 10,
			store: msgDtlGridData,
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
/*------DataGrid的函数结束 End---------------*/

/*------开始界面数据的窗体 Start---------------*/
if(typeof(uploadMessageWindow)=="undefined"){//解决创建2个windows问题
	uploadMessageWindow = new Ext.Window({
		id:'Messageformwindow',
		title:formTitle
		, iconCls: 'upload-win'
		, width: 800
		, height: 400
		, layout: 'border'
		, plain: true
		, modal: true
		, constrain:true
		, resizable: false
		, closeAction: 'hide'
		,autoDestroy :true
		,items:[messageDiv,msgDtlGrid]
		,buttons: [
		{
			text: "取消"
			, handler: function() { 
				uploadMessageWindow.hide();
			}
			, scope: this
		}]});
	}
	uploadMessageWindow.addListener("hide",function(){
});

/*------开始界面数据的函数 Start---------------*/
function setFormValue(selectData)
{
    
	Ext.Ajax.request({
		url:'frmScmProvideMessageView.aspx?method=getmessage',
		params:{
			ProvideMessageId:selectData.data.ProvideMessageId
		},
	success: function(resp,opts){
		var data=Ext.util.JSON.decode(resp.responseText);
		Ext.getCmp("CustomerId").setValue(data.CustomerId);
		Ext.getCmp("SendDate").setValue(data.SendDate);
		Ext.getCmp("OperatId").setValue(data.OperatId);
		Ext.getCmp("CreateDate").setValue(data.CreateDate);
		Ext.getCmp("Status").setValue(data.Status);
		Ext.getCmp("PlanType").setValue(data.PlanType);
		
		if(data.StartDate!='')
		{
		    Ext.getCmp("StartDate").setValue((new Date(Date.parse(data.StartDate))).clearTime());
		}
		else
		{
		    Ext.getCmp("StartDate").setValue("");
		}
		if(data.EndDate!='')
		{
		    Ext.getCmp("EndDate").setValue((new Date(Date.parse(data.EndDate))).clearTime());
		}
		else
		{
		    Ext.getCmp("EndDate").setValue("");
		}
		Ext.getCmp("CustomerName").setValue(selectData.data.CustomerName);
		Ext.getCmp("OperatId").setValue(selectData.data.EmpName);
		msgDtlGridData.baseParams.ProvideMessageId =selectData.data.ProvideMessageId;
		msgDtlGridData.baseParams.limit=10;
		msgDtlGridData.baseParams.start=0;
		msgDtlGridData.load();
		
	},
	failure: function(resp,opts){
		Ext.Msg.alert("提示","获取用户信息失败");
	}
	});
}
/*------结束设置界面数据的函数 End---------------*/

/*------开始获取数据的函数 start---------------*/
var messageGridData = new Ext.data.Store
({
url: 'frmScmProvideMessageView.aspx?method=getmessagelist',
reader:new Ext.data.JsonReader({
	totalProperty:'totalProperty',
	root:'root'
},[
	{
		name:'ProvideMessageId'
	},
	{
		name:'CustomerId'
	},{
		name:'CustomerName'
	},
	{
		name:'SendDate',type:'date'
	},
	{
		name:'MessageNum'
	},
	{
		name:'OperatId'
	},{
		name:'EmpName'
	},
	{
		name:'CreateDate'
	},
	{
		name:'MessageChecker'
	},
	{
		name:'CheckDate',type:'date'
	},
	{
		name:'MessageSight'
	},
	{
		name:'Status'
	},
	{
		name:'PlanType'
	},
	{
		name:'StartDate',type:'date'
	},
	{
		name:'EndDate',type:'date'
	}	])
	,
	listeners:
	{
		scope:this,
		load:function(){
		}
	}
});

messageGridData.load({params: {
                    start: 0,
                    limit: 10}});
/*------获取数据的函数 结束 End---------------*/

/*------开始DataGrid的函数 start---------------*/

var sm= new Ext.grid.CheckboxSelectionModel({
	singleSelect:true
});

function cmbStatus(val)
            {
                var index = cmbStatusList.find('DicsCode', val);
                    if (index < 0)
                        return "";
                    var record = cmbStatusList.getAt(index);
                    return record.data.DicsName;
            }
            
            function cmbType(val)
            {
                var index = cmbPlanTypeList.find('DicsCode', val);
                    if (index < 0)
                        return "";
                    var record = cmbPlanTypeList.getAt(index);
                    return record.data.DicsName;
            }
            
            function renderDate(value)
            {
                var reDate = /\d{4}\-\d{2}\-\d{2}/gi;
                return value.match(reDate);
            }
            
var messageGrid = new Ext.grid.GridPanel({
	el: 'messageGrid',
	width:'100%',
	height:'100%',
	autoWidth:true,
	autoHeight:true,
	autoScroll:true,
	layout: 'fit',
	id: 'messageGrid',
	store: messageGridData,
	loadMask: {msg:'正在加载数据，请稍侯……'},
	sm:sm,
	cm: new Ext.grid.ColumnModel([
		sm,
		new Ext.grid.RowNumberer(),//自动行号
		{
			header:'供应商',
			dataIndex:'CustomerName',
			id:'CustomerName'
		},
		{
			header:'日期',
			dataIndex:'SendDate',
			id:'SendDate',
			renderer: Ext.util.Format.dateRenderer('Y年m月d日')
		},
		{
			header:'操作人',
			dataIndex:'EmpName',
			id:'EmpName'
		},
		{
			header:'创建时间',
			dataIndex:'CreateDate',
			id:'CreateDate',
			renderer: Ext.util.Format.dateRenderer('Y年m月d日')
		},
		{
			header:'状态',
			dataIndex:'Status',
			id:'Status',
			renderer:cmbStatus
		},
		{
			header:'对应计划类型',
			dataIndex:'PlanType',
			id:'PlanType',
			renderer:cmbType
		},
		{
			header:'开始日期',
			dataIndex:'StartDate',
			id:'StartDate',
			renderer: Ext.util.Format.dateRenderer('Y年m月d日')
		},
		{
			header:'结束日期',
			dataIndex:'EndDate',
			id:'EndDate',
			renderer: Ext.util.Format.dateRenderer('Y年m月d日')
		}		]),
		bbar: new Ext.PagingToolbar({
			pageSize: 10,
			store: messageGridData,
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
messageGrid.on("afterrender", function(component) {
        component.getBottomToolbar().refresh.hideParent = true;
        component.getBottomToolbar().refresh.hide(); 
    });
messageGrid.render();
/*------DataGrid的函数结束 End---------------*/
/*------查询信息 ---------*/
createSearch(messageGrid,messageGridData,"searchForm");
//setControlVisibleByField();
searchForm.el="searchForm";
searchForm.render();


})
</script>
</head>
<body>
    <form id="form1" runat="server">
    <div id='toolbar'></div>
    <div id='searchForm'></div>
<div id='divForm'></div>
<div id='messageGrid'></div>
    </form>
</body>
</html>
