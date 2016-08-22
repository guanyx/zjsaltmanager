<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmLoadFeeCount.aspx.cs" Inherits="RPT_WMS_frmLoadFeeStatics" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
    <title>装卸费统计</title>
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
<div id='toolbar'></div>
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
			header:'出入库编号',
			dataIndex:'OrderId',
			id:'OrderId',
			tooltip:'出入库编号'
//			summaryType:'count',
//            summaryRenderer: function(v, params, data){
//                return '共(' + v +')条订单';
//            }
		},
		{
		    header:'装卸公司',
			dataIndex:'LoadCompany',
			id:'LoadCompany',
			tooltip:'装卸公司'
		},
		{
			header:'客户名称',
			dataIndex:'ShortName',
			id:'ShortName',
			tooltip:'客户名称'
		},
		{
			header:'车船号',
			dataIndex:'CarBoatNo',
			id:'CarBoatNo',
			tooltip:'车船号'
		},
		{
			header:'商品编号',
			dataIndex:'ProductNo',
			id:'ProductNo',
			tooltip:'商品编号'
		},	
        {
            header:'商品名称',
			dataIndex:'ProductName',
			id:'ProductName',
			tooltip:'商品名称'
		},
		{
		    header:'装卸类型',
			dataIndex:'LoadTypeText',
			id:'LoadTypeText',
			tooltip:'装卸类型'
		},
		{
		    header:'数量',
			dataIndex:'BookQty',
			id:'BookQty'
		},
		{
		    header:'重量',
			dataIndex:'OrderQty',
			id:'OrderQty',
			summaryType: 'sum',
            summaryRenderer: function(v, params, data){  
                return Number(v).toFixed(3)+'吨'; //保留3位  
            } 
		},
		{
		    header:'装卸单价',
			dataIndex:'LoadPrice',
			id:'LoadPrice',
			renderer: function(v){  
                return Number(v).toFixed(2)+'元'; //保留2位  
            } 
		},
		{
		    header:'装卸费用',
			dataIndex:'LoadAmt',
			id:'LoadAmt',
			tooltip:'装卸费用',
			summaryType: 'sum',
            summaryRenderer: function(v, params, data){  
                return Number(v).toFixed(4)+'元'; //保留4位  
            } 
		},
		{
		    header:'日期',
			dataIndex:'CreateDate',
			id:'CreateDate'
		},
		{
		    header:'结算类型',
			dataIndex:'PayTypeText',
			id:'PayTypeText'
		},
		{
		    header:'配送类型',
			dataIndex:'DistributionTypeText',
			id:'DistributionTypeText'
		}
//		{
//		    header:'运输类型',
//			dataIndex:'TransTypeText',
//			id:'TransTypeText',
//			tooltip:'运输类型'
//		},
//		{
//		    header:'运输单价',
//			dataIndex:'TransPrice',
//			id:'TransPrice'
//		},
//		{
//		    header:'运输费用',
//			dataIndex:'TransAmt',
//			id:'TransAmt',
//			tooltip:'运输费用'
//		}
        ]
});
/*--------------serach--------------*/
var ArriveFeePostPanel = new Ext.form.ComboBox({
        style: 'margin-left:0px',
        cls: 'key',
        xtype: 'combo',
        fieldLabel: '装卸公司',
        name: 'nameCust',
        anchor: '95%',
        store:dsCompanyList,
        mode:'local',
        displayField:'Name',
        valueField:'Id',
        triggerAction:'all',
        editable:false,
        value:dsCompanyList.getAt(0).data.Id
    });
var ArriveOrderPostPanel = new Ext.form.TextField({
        style: 'margin-left:0px',
        cls: 'key',
        xtype: 'combo',
        fieldLabel: '进出库编号',
        name: 'nameOrder',
        anchor: '95%'
    });
var ArriveCustPostPanel = new Ext.form.TextField({
        style: 'margin-left:0px',
        cls: 'key',
        xtype: 'combo',
        fieldLabel: '客户名称',
        name: 'nameCust',
        anchor: '95%'
    });
var ArrivePnamePostPanel = new Ext.form.TextField({
        style: 'margin-left:0px',
        cls: 'key',
        xtype: 'combo',
        fieldLabel: '产品名称',
        name: 'nameP',
        anchor: '95%'
    });
var typePanel = new  Ext.form.ComboBox({
        style: 'margin-left:0px',
        cls: 'key',
        xtype: 'combo',
        fieldLabel: '单据类型',
        name: 'BillType',
        anchor: '95%',
        store:[['W0201','采购入库'],['W0202','配送出库']],
        mode:'local',
        triggerAction:'all',
        editable:false,
        value:'W0201'
    });    
      
//开始日期
    var provideFeeStartPanel = new Ext.form.DateField({
        xtype:'datefield',
        fieldLabel:'开始日期',
        anchor:'95%',
        format: 'Y年m月d日',  //添加中文样式
        value:new Date().clearTime() 
    });

    //结束日期
    var provideFeeEndPanel = new Ext.form.DateField({
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
    bodyStyle: 'padding:2px',
    frame: true,    
    items: [
    {
        layout: 'column',   //定义该元素为布局为列布局方式
        border: false,
        items: [{
                columnWidth: .27,  //该列占用的宽度，标识为20％
                layout: 'form',
                border: false,
                labelWidth: 55,
                items: [
                    ArriveFeePostPanel
                ]
            }, {
                columnWidth: .24,
                layout: 'form',
                border: false,
                labelWidth:70,
                items: [
                    ArriveOrderPostPanel
                    ]
            }, {
                columnWidth: .245,
                layout: 'form',
                border: false,
                labelWidth: 55,
                items: [
                    provideFeeStartPanel
                    ]
            }, {
                name: 'cusStyle',
                columnWidth: .245,
                layout: 'form',
                border: false,
                labelWidth: 55,
                items: [
                    provideFeeEndPanel
                ]
            }
        ]
    }, {
        layout: 'column',   //定义该元素为布局为列布局方式
        border: false,
        items: [{
                columnWidth: .35,
                layout: 'form',
                border: false,
                labelWidth: 55,
                items: [
                    ArriveCustPostPanel
                    ]
            }, {
                name: 'cusStyle',
                columnWidth: .35,
                layout: 'form',
                border: false,
                labelWidth: 55,
                items: [
                    ArrivePnamePostPanel
                ]
            },{
                columnWidth: .22,
                layout: 'form',
                border: false,
                labelWidth: 55,
                items: [
                    typePanel
                    ]
            }, {
            columnWidth: .08,
            layout: 'form',
            border: false,
            items: [{ cls: 'key',
                xtype: 'button',
                text: '查询',
                anchor: '50%',
                handler :function(){
                
                var CompanyId=ArriveFeePostPanel.getValue();
                var starttime=provideFeeStartPanel.getValue();
                var endtime=provideFeeEndPanel.getValue();
                var order=ArriveOrderPostPanel.getValue();
                var type = typePanel.getValue();
                var customerName = ArriveCustPostPanel.getValue();
                var productName = ArrivePnamePostPanel.getValue();
                
                gridStore.baseParams.StartSendDate=Ext.util.Format.date(starttime,'Y/m/d');
                gridStore.baseParams.EndSendDate=Ext.util.Format.date(endtime,'Y/m/d');                
                gridStore.baseParams.LoadComId=CompanyId;
                gridStore.baseParams.OrderId=order;
                gridStore.baseParams.Type=type;
                gridStore.baseParams.CustomerName=customerName;
                gridStore.baseParams.ProductName=productName;
                
                gridStore.load();
                }
            }]
        }]
    }]
});

/*----------------------------*/

var gridStore = new Ext.data.GroupingStore({
    url: 'frmLoadFeeStatics.aspx?method=getlist',
     reader :new Ext.data.JsonReader({
    totalProperty: 'totalProperty',
    root: 'root',
    fields: [
	{       name:'LoadAmt',type:'float'},
	{		name:'WhId'	},
	{		name:'SupplierId'	},
	{		name:'CreateDate'	},
	{		name:'IsConfirm'	},
	{		name:'ShortName'	},
	{		name:'OrgId'	},
	{		name:'OwnerId'	},
	{		name:'OperId'	},
	{		name:'PayTypeText'	},
	{		name:'OrderQty'	},
	{		name:'ConfirmDate'	},
	{		name:'LoadComId'	},
	{		name:'CarBoatNo'	},,
	{		name:'LoadType'	},
	{		name:'LoadTypeText'	},
	{		name:'LoadAmt'	},
	{		name:'TransType'	},
	{		name:'TransTypeText'	},
	{		name:'TransAmt'	},
	{		name:'OrderDetailId'	},
	{		name:'OrderId'	},
	{   	name:'OrderNo'	},
	{		name:'WhpId'	},
	{		name:'ProductName'	},
	{		name:'ProductPrice'	},
	{		name:'BookQty'	},
	{		name:'ProductNo'	},
	{		name:'TransPrice',type:'float'	},
	{		name:'LoadPrice',type:'float'	},
	{		name:'ProductBn'	},
	{		name:'ProductDate'	},
	{       name:'DistributionTypeText'   },
	{	    name:'LoadCompany'
	}
	]
    }),
    sortInfo: {field: 'CreateDate', direction: 'ASC'},
    groupField: 'LoadCompany'
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
var summary = new Ext.ux.grid.GroupSummary();  
var uxsummary = new Ext.ux.grid.GridSummary(); 
//合计项
var viewGrid = new Ext.grid.EditorGridPanel({
    renderTo:"gird",                
    id: 'viewGrid',
    //region:'center',
    split:true,
    store: gridStore ,
    autoscroll:true,
    loadMask: { msg: '正在加载数据，请稍侯……' },
    sm: sm,
    cm:colModel,
    plugins:[summary,uxsummary],
    view: new Ext.grid.GroupingView({
        forceFit: true,
        showGroupName: false,
        enableNoGroups: false,
        enableGroupingMenu: false,
        hideGroupedColumn: true
    }),
    closeAction: 'hide',
    stripeRows: true,
    height:550,
    width:'100%',
    title:''
});
})
</script>
</html>
