<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmOperLogView.aspx.cs" Inherits="BA_sysadmin_frmOperLogView" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html>
<head>
<title>日志查询跟踪</title><meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<link rel="stylesheet" type="text/css" href="../../ext3/resources/css/ext-all.css" />
<script type="text/javascript" src="../../ext3/adapter/ext/ext-base.js"></script>
<script type="text/javascript" src="../../ext3/ext-all.js"></script>
</head>
<body>
<div id='toolbar'></div>
<div id='divSearchForm'></div>
<div id='divDataGrid'></div>
<%=getComboBoxStore( )%>
</body>
<script type="text/javascript">
Ext.BLANK_IMAGE_URL = "../../ext3/resources/images/default/s.gif";  //作为：让下拉框的三角形下拉图片显示
Ext.onReady(function() {
    
/*------实现toolbar的函数 start---------------*/
var Toolbar = new Ext.Toolbar({
    renderTo: "toolbar",
    items: [{
        text: "详细信息",
        icon: "../../Theme/1/images/extjs/customer/view16.gif",
        handler: function() { ViewDetailWin(); }
    }]
});
/*------结束toolbar的函数 end---------------*/

/*-----编辑Order实体类窗体函数----*/
function ViewDetailWin() {
    var sm = OrderMstGrid.getSelectionModel();
    //获取选择的数据信息
    var selectData = sm.getSelected();
    if (selectData == null) {
        Ext.Msg.alert("提示", "请选中需要编辑的信息！");
        return;
    }
}
          
var serchform = new Ext.FormPanel({
    renderTo: 'divSearchForm',
    labelAlign: 'left',
//                    layout: 'fit',
    buttonAlign: 'center',
    bodyStyle: 'padding:5px',
    frame: true,
    labelWidth: 55,
    items:[
    {
        layout:'column',
        border: false,
        labelSeparator: '：',
        items: [
        {
            layout:'form',
            border: false,
            columnWidth:0.3,
            items: [
                {
	                xtype:'datefield',
	                fieldLabel:'开始日期',
	                columnWidth:0.5,
	                anchor:'90%',
	                name:'StartDate',
	                id:'StartDate',
                    format: 'Y年m月d日 H:i:s',  //添加中文样式
                    value:new Date().getFirstDateOfMonth().clearTime()
                }
                    ]
        }
,		{
            layout:'form',
            border: false,
            columnWidth:0.3,
            items: [
                {
	                xtype:'datefield',
	                fieldLabel:'结束日期',
	                columnWidth:0.5,
	                anchor:'90%',
	                name:'EndDate',
	                id:'EndDate',
                    format: 'Y年m月d日  H:i:s',  //添加中文样式
                    value:new Date()
                }
                    ]
        }        
,		{
            layout:'form',
            border: false,
            columnWidth:0.3,
            items: [
                {
	                xtype:'combo',
	                fieldLabel:'操作员',
	                columnWidth:0.5,
	                anchor:'90%',
	                name:'OperId',
	                id:'OperId',
	                store:dsOper,
	                valueField:'EmpId',
	                displayField:'EmpName',
	                editable:false,
	                triggerAction:'all',
	                mode:'local'
                }
                    ]
        }
,		{
            layout:'form',
            border: false,
            columnWidth:0.1,
            items: [
                {
	                xtype:'button',
	                text:'查询',
	                columnWidth:0.5,
	                anchor:'90%',
	                handler:function() {
                        viewLogData.baseParams.StartTime = Ext.util.Format.date(Ext.getCmp('StartDate').getValue(),'Y/m/d H:i:s');
                        viewLogData.baseParams.EndTime = Ext.util.Format.date(Ext.getCmp('EndDate').getValue(),'Y/m/d H:i:s');
                        viewLogData.baseParams.OperId = Ext.getCmp('OperId').getValue();
                        //operID
                        viewLogData.load({params:{start:0,limit:20}});
                    }
                }
                    ]
        }
    ]}             
    ]

});


/*------开始查询form的函数 end---------------*/

/*------开始获取数据的函数 start---------------*/
var viewLogData = new Ext.data.Store
({
    url: 'frmOperLogView.aspx?method=getLogList',
    reader: new Ext.data.JsonReader({
        totalProperty: 'totalProperty',
        root: 'root'
    }, [
        {
		name:'LogId'
	},
	{
		name:'LogGuid'
	},
	{
		name:'LogLevel'
	},
	{
		name:'ClassName'
	},
	{
		name:'MethodName'
	},
	{
		name:'RecordTime'
	},
	{
		name:'StackTrace'
	},
	{
		name:'OriginalUrl'
	},
	{
		name:'OtherInfo'
	},
	{
		name:'LogContent'
	},
	{
		name:'OrgId'
	},
	{
		name:'OperId'
	},
	{
		name:'OrgName'
	},
	{
		name:'UserName'
	}	])     
    ,
    listeners:
    {
        scope: this,
        load: function() {
        }
    }
});
/*------获取数据的函数 结束 End---------------*/

/*------开始DataGrid的函数 start---------------*/

var sm = new Ext.grid.CheckboxSelectionModel({
    singleSelect: true
});
var LogGrid = new Ext.grid.GridPanel({
    el: 'divDataGrid', 
    height: '100%',
    autoHeight: true,
    autoScroll: true,
    layout: 'fit',
    id: '',
    store: viewLogData,
    loadMask: { msg: '正在加载数据，请稍侯……' },
    cm: new Ext.grid.ColumnModel([
    new Ext.grid.RowNumberer(),//自动行号
    {
		header:'操作日志ID',
		dataIndex:'LogId',
		id:'LogId',
		hidden:true,
		hideable:false
	},
	{
		header:'机构名称',
		dataIndex:'OrgName',
		id:'OrgName'
	},
	{
		header:'用户名',
		dataIndex:'UserName',
		id:'UserName'
	},
	{
		header:'日志级别',
		dataIndex:'LogLevel',
		id:'LogLevel'
	},
//	{
//		header:'分类名称',
//		dataIndex:'ClassName',
//		id:'ClassName'
//	},
//	{
//		header:'方法名',
//		dataIndex:'MethodName',
//		id:'MethodName'
//	},
	{
		header:'记录时间',
		dataIndex:'RecordTime',
		id:'RecordTime'
	},
//	{
//		header:'跟踪信息',
//		dataIndex:'StackTrace',
//		id:'StackTrace'
//	},
//	{
//		header:'原始请求URL',
//		dataIndex:'OriginalUrl',
//		id:'OriginalUrl'
//	},
//	{
//		header:'其他信息',
//		dataIndex:'OtherInfo',
//		id:'OtherInfo'
//	},
	{
		header:'日志内容',
		dataIndex:'LogContent',
		id:'LogContent',
		width:200
	}
//	{
//		header:'创建组织',
//		dataIndex:'OrgId',
//		id:'OrgId'
//	},
//	{
//		header:'创建人员',
//		dataIndex:'OperId',
//		id:'OperId'
//	}
			]),
    bbar: new Ext.PagingToolbar({
        pageSize: 20,
        store: viewLogData,
        displayMsg: '显示第{0}条到{1}条记录,共{2}条',
        emptyMsy: '没有记录',
        displayInfo: true
    }),
    viewConfig: {
        columnsText: '显示的列',
        scrollOffset: 20,
        sortAscText: '升序',
        sortDescText: '降序'
    },
    height: 280
});
LogGrid.render();
/*------DataGrid的函数结束 End---------------*/
})
</script>

</html>
