<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmWmsFinanceRSDReport.aspx.cs" Inherits="RPT_WMS_frmWmsFinanceRSDReport" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html>
<head>
    <title>财务收发存报表</title>
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
    <script type="text/javascript" src="../../js/GroupHeaderPlugin.js">
    </script><link rel="stylesheet" type="text/css" href="../../css/GroupHeaderPlugin.css" />
    <script type="text/javascript" src="../../ext3/src/locale/ext-lang-zh_CN.js"></script>
</head>
<body> 
<div id='searchForm'></div>
<div id='gird'></div>
</body>
<%=getComboBoxStore( )%>
<script type="text/javascript">
    Ext.BLANK_IMAGE_URL = "../../ext3/resources/images/default/s.gif";
    var headerModel = new Ext.ux.plugins.GroupHeaderGrid({
        rows: [
		[

			{
			    colspan: 1,
			    align: 'center'
			}, {
			    colspan: 1,
			    align: 'center'
			}, {
			    colspan: 1,
			    align: 'center'
			},
			{
			    colspan: 1,
			    align: 'center'
			},
			{
			    colspan: 1,
			    align: 'center'
			},
			{
			    colspan: 1,
			    align: 'center'
			},
			{
			    colspan: 1,
			    align: 'center'
			},
			{
			    header: '期初',
			    colspan: 2,
			    align: 'center'
			},
			{
			    header: '收料入库',
			    colspan: 2,
			    align: 'center'
			},
			{
			    header: '领料出库',
			    colspan: 2,
			    align: 'center'
			},
			{
			    header: '期末',
			    colspan: 2,
			    align: 'center'
			}

]]
    });
var colModel = new Ext.grid.ColumnModel({
	columns: [
		new Ext.grid.RowNumberer(),
		 {
		     header: '开始时间',
		     dataIndex: 'StartDate',
		     id: 'StartDate',
		     tooltip: '开始时间',
		     width: 60,
		     renderer: Ext.util.Format.dateRenderer('Y年m月d日')
		 },
		{
		    header: '结束时间',
		    dataIndex: 'EndDate',
		    id: 'EndDate',
		    tooltip: '结束时间',
		    width: 60,
		    renderer: Ext.util.Format.dateRenderer('Y年m月d日')
		},		
		{
			header:'产品编号',
			dataIndex:'ProductNo',
			id: 'ProductNo',
			tooltip: '产品编号',
			width: 40
		},
		{
		    header:'产品名称',
			dataIndex:'ProductName',
			id: 'ProductName',
			tooltip: '产品名称',
			width: 80
		},
		{
			header:'规格',
			dataIndex: 'SpecificationsText',
			id: 'SpecificationsText',
			tooltip: '规格',
			width: 30
		},
		{
			header:'单位',
			dataIndex:'UnitText',
			id: 'UnitText',
			tooltip: '单位',
			width: 25
		},
	   
		
		{
			header:'数量',
			dataIndex: 'LastDayStock',
			id: 'LastDayStock',
			tooltip: '数量',
			width: 40,
			align: 'right'

},
        {
            header: '金额',
            dataIndex: 'LastDayAmount',
            id: 'LastDayStock',
            tooltip: '金额',
            width: 40,
            align: 'right'

        },
		{
		    header: '数量',
		    dataIndex: 'IncomeQty',
		    id: 'IncomeQty',
		    tooltip: '数量',
		    width: 30,
		    align: 'right'
		},
		{
		    header: '金额',
		    dataIndex: 'IncomeAmount',
		    id: 'IncomeAmount',
		    tooltip: '金额',
		    width: 30,
		    align: 'right'
		},
		{
		    header: '数量',
		    dataIndex: 'ExpenditureQty',
		    id: 'ExpenditureQty',
		    tooltip: '数量',
		    width: 30,
		    align: 'right'
		},
		{
		    header: '金额',
		    dataIndex: 'ExpenditureAmount',
		    id: 'ExpenditureAmount',
		    tooltip: '金额',
		    width: 30,
		    align: 'right'
		},
		{
			header:'数量',
			dataIndex: 'TheDayStock',
			id: 'TheDayStock',
			tooltip: '数量',
			width: 40,
			align: 'right'
		},
		{
		    header: '金额',
		    dataIndex: 'TheDayAmount',
		    id: 'TheDayStock',
		    tooltip: '金额',
		    width: 40,
		    align: 'right'
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
var ArriveOrgPostPanel = new Ext.form.ComboBox({
    style: 'margin-left:0px',
    cls: 'key',
    xtype: 'combo',
    fieldLabel: '公司',
    name: 'nameOrg',
    anchor: '95%',
    store: dsOrgListInfo,
    mode: 'local',
    displayField: 'OrgName',
    valueField: 'OrgId',
    triggerAction: 'all',
    editable: false,
    disabled:true,
    value: dsOrgListInfo.getAt(0).data.OrgId
});
    //开始日期
    var beginStartDatePanel = new Ext.form.DateField({
        xtype:'datefield',
        fieldLabel:'开始日期',
        anchor:'95%',
        format: 'Y年m月d日',  //添加中文样式
        value:new Date().getFirstDateOfMonth().clearTime() 
    });

    //结束日期
    var beginEndDatePanel = new Ext.form.DateField({
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
        width:1000,
        labelWidth: 55,
        items: [
    {
        layout: 'column',   //定义该元素为布局为列布局方式
        border: false,
        items: [{
            columnWidth: .3,  //该列占用的宽度，标识为20％
            layout: 'form',
            border: false,
            items: [
                    ArriveOrgPostPanel
                ]
}]
        },

    {
        layout: 'column',   //定义该元素为布局为列布局方式
        border: false,
        items: [{
            columnWidth: .3,  //该列占用的宽度，标识为20％
            layout: 'form',
            border: false,
            items: [
                    beginStartDatePanel
                ]
        }, {
            columnWidth: .3,
            layout: 'form',
            border: false,
            items: [
                    beginEndDatePanel
                    ]
        }, {
            columnWidth: .2,
            layout: 'form',
            border: false,
            items: [{ cls: 'key',
                xtype: 'button',
                text: '查询',
                anchor: '50%',
                handler: function() {

                    //var whId = ArriveWhPostPanel.getValue();
                    //var productId = ArriveProductPostPanel.getValue();
                    var orgId = ArriveOrgPostPanel.getValue();
                    var beginStartDate = beginStartDatePanel.getValue();
                    var beginEndDate = beginEndDatePanel.getValue();

                    gridStore.baseParams.StartDate = Ext.util.Format.date(beginStartDate, 'Y/m/d');
                    gridStore.baseParams.EndDate = Ext.util.Format.date(beginEndDate, 'Y/m/d');

                    //gridStore.baseParams.whId = whId;
                    //gridStore.baseParams.productId = productId;
                    gridStore.baseParams.orgId = orgId;

                    gridStore.load();
                }
}]
}]
}]
    });

/*----------------------------*/

    var gridStore = new Ext.data.Store({
    url: 'frmWmsFinanceRSDReport.aspx?method=getlist',
        reader: new Ext.data.JsonReader({
            totalProperty: 'totalProperty',
            root: 'root',
            fields: [
	{ name: 'ProductId' },
	{ name: 'ProductNo' },
	{ name: 'ProductName' },
	{ name: 'SpecificationsText' },
	{ name: 'UnitText' },
	{ name: 'LastDayStock' },
	{ name: 'LastDayAmount'},
	{ name: 'TheDayStock' },
	{ name: 'TheDayAmount'},
	{ name: 'UnitText' },
	{ name: 'IncomeQty' },
	{ name: 'IncomeAmount'},
	{ name: 'ExpenditureQty' },
	{ name: 'ExpenditureAmount'},
	{ name: 'StartDate' },
	{ name: 'EndDate' }
	]
        })
    });

</script>
<script type="text/javascript">

 function getCmbStore(columnName)
{
    return null;
}
    
Ext.onReady(function(){



var sm = new Ext.grid.CheckboxSelectionModel({
            singleSelect: true
});
//合计项
var viewGrid = new Ext.grid.EditorGridPanel({
    renderTo:"gird",                
    id: 'viewGrid',
    //region:'center',
    split:true,
    store: gridStore,
    plugins: [headerModel],
    autoscroll:true,
    height:550,
    width:'1000',
    title:'',
    loadMask: { msg: '正在加载数据，请稍侯……' },
    sm: sm,
    cm:colModel,
    viewConfig: {
        columnsText: '显示的列',
        scrollOffset: 20,
        sortAscText: '升序',
        sortDescText: '降序',
        forceFit: true
    },
    loadMask: true,
    closeAction: 'hide',
    stripeRows: true    
});
ArriveOrgPostPanel.setValue(<% =ZJSIG.UIProcess.ADM.UIAdmUser.OrgID(this)%>);
if(ArriveOrgPostPanel.getValue() ==1)
    ArriveOrgPostPanel.setDisabled(false);

})
</script>
</html>