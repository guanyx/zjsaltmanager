<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmWmsStockDayStat.aspx.cs" Inherits="RPT_WMS_frmWmsStockDayStat" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html>
<head>
    <title>仓库日统计</title>
    <link rel="stylesheet" type="text/css" href="../../ext3/resources/css/ext-all.css" />
    <script type="text/javascript" src="../../ext3/adapter/ext/ext-base.js"></script>
    <script type="text/javascript" src="../../ext3/ext-all.js"></script>
    <script type="text/javascript" src="../../ext3/example/ItemDeleter.js"></script>
    <!--link rel="stylesheet" type="text/css" href="../../css/GroupHeaderPlugin.css" /-->
    <script type="text/javascript" src="../../js/floatUtil.js"></script>
    <!--script type="text/javascript" src="../../js/GroupHeaderPlugin.js"></script-->
    <link rel="stylesheet" href="../../css/Ext.ux.grid.GridSummary.css" />
    <!--script type="text/javascript" src="../../js/FilterControl.js"></script-->
    <script type="text/javascript" src='../../js/Ext.ux.grid.GridSummary.js'></script>
    <link rel="stylesheet" type="text/css" href="../../ext3/example/GroupSummary.css" />
    <script type="text/javascript" src="../../ext3/example/GroupSummary.js"></script>
    <script type="text/javascript" src="../../js/operateResp.js"></script>
    <script type="text/javascript" src="../../js/getExcelXml.js"></script>
    <script type="text/javascript" src="../../ext3/src/locale/ext-lang-zh_CN.js"></script>
</head>
<body> 
<div id='searchForm'></div>
<div id='gird'></div>
</body>
<%=getComboBoxStore( )%>
<script type="text/javascript">
Ext.onReady(function(){
Ext.BLANK_IMAGE_URL = "../../ext3/resources/images/default/s.gif";
var colModel = new Ext.grid.ColumnModel({
	columns: [
		new Ext.grid.RowNumberer(),			
		{
			header:'产品编号',
			dataIndex:'ProductNo',
			id:'ProductNo',
			tooltip:'产品编号'
		},
		{
		    header:'产品名称',
			dataIndex:'ProductName',
			id:'ProductName',
			tooltip:'产品名称'
		},
		{
			header:'规格',
			dataIndex:'SpecificationsText',
			id:'SpecificationsText',
			tooltip:'规格'
		},
		{
			header:'单位',
			dataIndex:'UnitText',
			id:'UnitText',
			tooltip:'单位'
		},
		{
			header:'期初数量',
			dataIndex:'LastDayStock',
			id:'LastDayStock',
			tooltip:'期初数量'
		},
	<%for(int k=0;k<WhType.Length;k++){ if(!"W0203".Equals(WhType[k][0])){ %>
	<% ="{" %>
	<% ="	header:'"+WhType[k][1]+"'," %>
	<% ="	dataIndex:'"+WhType[k][0]+"'," %>
	<% ="	id:'"+WhType[k][0]+"'," %>
	<% ="	tooltip:'"+WhType[k][1]+"'" %>
	<% ="}," %>
	<%} }%>
	    {
			header:'期末数量',
			dataIndex:'TheDayStock',
			id:'TheDayStock',
			tooltip:'期末数量'
		},
		{
		    header:'ID',
			dataIndex:'ProductId',
			id:'ProductId',
			tooltip:'',
			hidden:true,
			hideable:false
		}
        ]
});
/*--------------serach--------------*/
var ArriveWhPostPanel = new Ext.form.ComboBox({
        style: 'margin-left:0px',
        cls: 'key',
        xtype: 'combo',
        fieldLabel: '仓库',
        name: 'nameCust',
        anchor: '95%',
        store:dsWarehouseList,
        mode:'local',
        displayField:'WhName',
        valueField:'WhId',
        triggerAction:'all',
        editable:false,
        value:dsWarehouseList.getAt(0).data.WhId
    });
//开始日期
    var provideWhStartPanel = new Ext.form.DateField({
        xtype:'datefield',
        fieldLabel:'开始日期',
        anchor:'95%',
        format: 'Y年m月d日',  //添加中文样式
        value:new Date().clearTime() 
    });

    //结束日期
    var provideWhEndPanel = new Ext.form.DateField({
        xtype:'datefield',
        fieldLabel:'结束日期',
        anchor:'95%',
        format: 'Y年m月d日',  //添加中文样式
        value:new Date().clearTime()
    });    
    
var serchform = new Ext.FormPanel({
    renderTo: 'searchForm',
    labelAlign: 'left',
   // layout:'fit',
    buttonAlign: 'right',
    bodyStyle: 'padding:5px',
    frame: true,
    labelWidth: 55,
    items: [
    {
        layout: 'column',   //定义该元素为布局为列布局方式
        border: false,
        items: [{
                columnWidth: .25,  //该列占用的宽度，标识为20％
                layout: 'form',
                border: false,
                items: [
                    ArriveWhPostPanel
                ]
            },{
                columnWidth: .25,
                layout: 'form',
                border: false,
                items: [
                    provideWhStartPanel
                    ]
            }, {
                name: 'cusStyle',
                columnWidth: .25,
                layout: 'form',
                border: false,                
                items: [
                    provideWhEndPanel
                ]
            }, {
            columnWidth: .20,
            layout: 'column',
            border: false,
            items: [{ cls: 'key',
                xtype: 'button',
                text: '查询',
                anchor: '50%',
                handler :function(){
                
                var WhId=ArriveWhPostPanel.getValue();
                var starttime=provideWhStartPanel.getValue();
                var endtime=provideWhEndPanel.getValue();
                
                gridStore.baseParams.StartSendDate=Ext.util.Format.date(starttime,'Y/m/d');
                gridStore.baseParams.EndSendDate=Ext.util.Format.date(endtime,'Y/m/d');                
                gridStore.baseParams.whId=WhId;
                
                gridStore.load();
                }
            },{
                xtype:'button',
                cls:'key',
                text:'导出',
                anchor:'50%',
                handler:function(){    
                   exportExcel();
                   //alert(gridStore.getCount());
                }
            }]
        }]
    }]
});

/*----------------------------*/

var gridStore = new Ext.data.Store({
    url: 'frmWmsStockDayStat.aspx?method=getlist',
     reader :new Ext.data.JsonReader({
    totalProperty: 'totalProperty',
    root: 'root',
    fields: [
	{		name:'ProductId'	},
	{		name:'ProductNo'	},
	{		name:'ProductName'	},
	{		name:'SpecificationsText'	},
	{		name:'UnitText'	},
	{		name:'LastDayStock'	},
	{		name:'TheDayStock'	},
	<%for(int k=0;k<WhType.Length;k++){ %>
	<% ="{		name:'"+WhType[k][0]+"'	}," %>
	<%} %>
	{		name:'UnitText'	}
	]
    })
});


 function getCmbStore(columnName)
{
    return null;
}
    




var sm = new Ext.grid.CheckboxSelectionModel({
            singleSelect: true
});
//合计项
var viewGrid = new Ext.grid.EditorGridPanel({
    renderTo:"gird",                
    id: 'viewGrid',
    //region:'center',
    split:true,
    store: gridStore ,
    autoscroll:true,
    height:420,
    width:'100%',
    title:'',
    loadMask: { msg: '正在加载数据，请稍侯……' },
    sm: sm,
    cm:colModel,
    viewConfig: {
        columnsText: '显示的列',
        scrollOffset: 20,
        sortAscText: '升序',
        sortDescText: '降序',
        forceFit: false
    },
    loadMask: true,
    closeAction: 'hide',
    stripeRows: true    
});


function exportExcel(){
var vExportContent = viewGrid.getExcelXml();
var w = window.open("about:blank", "Excel", "height=0, width=0");
w.document.write(vExportContent);    
w.document.execCommand('Saveas', false, 'C:\\仓库日统计.xls');
w.close();
}


})

</script>
</html>