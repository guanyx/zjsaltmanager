<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmReourceDescView.aspx.cs" Inherits="BA_sysadmin_frmReourceDescView" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html>
<head>
<title>日志查询跟踪</title><meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<link rel="stylesheet" type="text/css" href="../../ext3/resources/css/ext-all.css" />
<script type="text/javascript" src="../../ext3/adapter/ext/ext-base.js"></script>
<script type="text/javascript" src="../../ext3/ext-all.js"></script>
</head>
<body>
<div id='divSearchForm'></div>
<div id='divDataGrid'></div>
</body>
<script type="text/javascript">
Ext.BLANK_IMAGE_URL = "../ext3/resources/images/default/s.gif";  //作为：让下拉框的三角形下拉图片显示
Ext.onReady(function() {

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
            columnWidth:0.33,
            items: [
                {
	                xtype:'textfield',
	                fieldLabel:'功能名称',
	                columnWidth:0.5,
	                anchor:'90%',
	                name:'ResourceName',
	                id:'ResourceName'
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
                        resourceViewData.baseParams.ResourceName = Ext.getCmp('ResourceName').getValue();
                        //operID
                        resourceViewData.load({params:{start:0,limit:10}});
                    }
                }
                    ]
        }
    ]}             
    ]

});

/*------开始查询form的函数 end---------------*/

/*------开始获取数据的函数 start---------------*/
var resourceViewData = new Ext.data.Store
({
    url: 'frmReourceDescView.aspx?method=getResourceList',
    reader: new Ext.data.JsonReader({
        totalProperty: 'totalProperty',
        root: 'root'
    }, [
        {
            name:'ResourceName'
        },
        {
            name:'ResourceMemo'
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
var resourceGrid = new Ext.grid.GridPanel({
    el: 'divDataGrid', 
    height: '100%',
    autoHeight: true,
    autoScroll: true,
    layout: 'fit',
    id: '',
    store: resourceViewData,
    loadMask: { msg: '正在加载数据，请稍侯……' },
    sm: sm,
    cm: new Ext.grid.ColumnModel([
    sm,
    new Ext.grid.RowNumberer(),//自动行号
    {
        header:'名称',
        dataIndex:'ResourceName',
        id:'ResourceName',
        width:100
    },
    {
        header:'功能简介',
        dataIndex:'ResourceMemo',
        id:'ResourceMemo',
        width:400
    }		]),
    bbar: new Ext.PagingToolbar({
        pageSize: 10,
        store: resourceViewData,
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
resourceGrid.render();
/*------DataGrid的函数结束 End---------------*/
})
</script>

</html>

