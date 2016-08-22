<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmWmsRSDDetailReport.aspx.cs" Inherits="RPT_WMS_frmWmsRSDDetailReport" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html>
<head>
    <title>仓库收发存明细查询报表</title>
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
    <script type="text/javascript" src="../../ext3/src/locale/ext-lang-zh_CN.js"></script>
</head>
<body> 
<div id='searchForm'></div>
<div id='gird'></div>
</body>
<%=getComboBoxStore( )%>
<script type="text/javascript">
Ext.BLANK_IMAGE_URL = "../../ext3/resources/images/default/s.gif";
var colModel = new Ext.grid.ColumnModel({
	columns: [
		new Ext.grid.RowNumberer(),
		 {
		     header: '单据类型',
		     dataIndex: 'TypeName',
		     id: 'TypeName',
		     tooltip: '单据类型'
		 },
		{
		    header: '出入库单号',
		    dataIndex: 'OrderId',
		    id: 'OrderId',
		    tooltip: '出入库单号'
		},
		{
		    header: '分公司',
		    dataIndex: 'OrgName',
		    id: 'OrgName',
		    tooltip: '分公司'

		},
		{
		    header: '仓库',
		    dataIndex: 'WhName',
		    id: 'WhName',
		    tooltip: '仓库'

		},		
		{
			header:'产品编号',
			dataIndex:'ProductCode',
			id: 'ProductCode',
			tooltip:'产品编号'
		},
		{
		    header:'产品名称',
			dataIndex:'ProductName',
			id: 'ProductName',
			tooltip:'产品名称'
		},
		{
			header:'单位',
			dataIndex:'UnitText',
			id: 'UnitText',
			tooltip: '单位',
			width: 30
		},
		
		
		
		{
		    header: '收入数量',
		    dataIndex: 'IncomeQty',
		    id: 'IncomeQty',
		    tooltip: '收入数量'
		},
		{
		    header: '支出数量',
		    dataIndex: 'ExpQty',
		    id: 'ExpQty',
		    tooltip: '支出数量'
		},
		{
			header:'收发时间',
			dataIndex: 'CreateDate',
			id: 'CreateDate',
			renderer: Ext.util.Format.dateRenderer('Y年m月d日'),
			tooltip: '收发时间'
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
    fieldLabel: '分公司',
    name: 'nameOrg',
    anchor: '95%',
    store: dsOrgListInfo,
    mode: 'local',
    displayField: 'OrgName',
    valueField: 'OrgId',
    triggerAction: 'all',
    editable: false,
    value: dsOrgListInfo.getAt(0).data.OrgId
});
var ArriveBillTypePostPanel = new Ext.form.ComboBox({
    style: 'margin-left:0px',
    cls: 'key',
    xtype: 'combo',
    fieldLabel: '单据类型',
    name: 'nameBillType',
    anchor: '95%',
    store: dsRSDBillTypeListInfo,
    mode: 'local',
    displayField: 'DicsName',
    valueField: 'DicsCode',
    triggerAction: 'all',
    editable: false,
    value: dsRSDBillTypeListInfo.getAt(0).data.DicsCode
});
var ArriveProductPostPanel = new Ext.form.ComboBox({
    style: 'margin-left:0px',
    cls: 'key',
    xtype: 'combo',
    fieldLabel: '产品名称',
    name: 'nameProduct',
    anchor: '95%',
    store: dsProductList,
    emptyText: '全部商品',
    mode: 'local',
    displayField: 'ProductName',
    valueField: 'ProductId',
    triggerAction: 'all',
    editable: false//,
    //value: dsProductList.getAt(0).data.ProductId
});
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
    var ArriveOrderIdPostPanel = new Ext.form.TextField({
        style: 'margin-left:0px',
        cls: 'key',
        xtype: 'textfield',
        fieldLabel: '出入库号',
        name: 'nameOrderId',
        anchor: '95%',
        triggerAction: 'all',
        editable: true
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
        labelWidth: 60,
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
            }, {
                columnWidth: .3,
                layout: 'form',
                border: false,
                items: [
                    ArriveWhPostPanel
                    ]
            }, {
                columnWidth: .3,
                layout: 'form',
                border: false,
                items: [
                    ArriveOrderIdPostPanel
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
                    ArriveProductPostPanel
                ]
        }, {
            columnWidth: .3,
            layout: 'form',
            border: false,
            items: [
                    ArriveBillTypePostPanel
                    ]

        }, {
            columnWidth: .3,
            layout: 'form',
            border: false,
            items: [
                    {
                    cls: 'key',
                    xtype: 'combo',
                    fieldLabel: '显示单位 ',
                    name: 'UnitTypeCombo',
                    id: 'UnitTypeCombo',
                    store: [[0,'库存单位'],[1,'销售单位']],
                    mode: 'local',
                    triggerAction: 'all',
                    editable: false,
                    anchor: '95%',
                    value: 0
                    // maxLength: 1000,  
                    // allowBlank : true
                }
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

                    var whId = ArriveWhPostPanel.getValue();
                    var orgId = ArriveOrgPostPanel.getValue();
                    var beginStartDate = beginStartDatePanel.getValue();
                    var beginEndDate = beginEndDatePanel.getValue();
                    var orderId = ArriveOrderIdPostPanel.getValue();
                    var billType = ArriveBillTypePostPanel.getValue();
                    var productId = ArriveProductPostPanel.getValue();
                    var unitType = Ext.getCmp('UnitTypeCombo').getValue();

                    gridStore.baseParams.StartDate = Ext.util.Format.date(beginStartDate, 'Y/m/d');
                    gridStore.baseParams.EndDate = Ext.util.Format.date(beginEndDate, 'Y/m/d');

                    gridStore.baseParams.whId = whId;
                    gridStore.baseParams.billType = billType;
                    gridStore.baseParams.UnitType=unitType;

                    gridStore.baseParams.orderId = orderId;
                    gridStore.baseParams.productId = productId;
                    gridStore.baseParams.orgId = orgId;

                    gridStore.load();
                }
}]
}]
}]
        });

/*----------------------------*/

    var gridStore = new Ext.data.Store({
    url: 'frmWmsRSDDetailReport.aspx?method=getlist',
        reader: new Ext.data.JsonReader({
            totalProperty: 'totalProperty',
            root: 'root',
            fields: [
    { name: 'OrderId' },
    { name: 'FromBillType' },
    { name: 'TypeName' },
	{ name: 'ProductId' },
	{ name: 'ProductCode' },
	{ name: 'ProductName' },
	{ name: 'WhName' },
	{ name: 'UnitText' },
	{ name: 'IncomeQty' ,type: 'float'},
	{ name: 'ExpQty' ,type: 'float'},
	{ name: 'CreateDate' },
	{ name: 'OrgName' }
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
    store: gridStore ,
    autoscroll:true,
    height:500,
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
        forceFit: true
    },
    loadMask: true,
    closeAction: 'hide',
    stripeRows: true    
});
ArriveOrgPostPanel.setValue(<% =ZJSIG.UIProcess.ADM.UIAdmUser.OrgID(this)%>);
ArriveOrgPostPanel.setDisabled(true);
})
</script>
</html>