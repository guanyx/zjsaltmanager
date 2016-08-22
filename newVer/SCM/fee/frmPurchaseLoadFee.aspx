<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmPurchaseLoadFee.aspx.cs" Inherits="RPT_WMS_frmPurchaseLoadFee" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
    <title>驾驶员采购装卸费</title>
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
			header:'驾驶员',
			dataIndex:'DriverName',
			id:'DriverName',
			tooltip:'驾驶员'
		},
		{
		    header:'装卸公司',
			dataIndex:'LoadCompany',
			id:'LoadCompany',
			tooltip:'装卸公司'
		},
		{
			header:'订单编号',
			dataIndex:'OrderNo',
			id:'OrderNo',
			tooltip:'订单编号',		
			summaryType:'count',
            summaryRenderer: function(v, params, data){
                return '共(' + v +')条订单';
            }
		},
		{
			header:'日期',
			dataIndex:'CreateDate',
			id:'CreateDate',
			tooltip:'发生日期'
		},
		{
			header:'供应商',
			dataIndex:'ShortName',
			id:'ShortName',
			tooltip:'供应商'
		},	
//        {
//            header:'仓库',
//			dataIndex:'WhId',
//			id:'WhId',
//			tooltip:'出货仓库'
//		},
		{
		    header:'产品',
			dataIndex:'ProductName',
			id:'ProductName',
			tooltip:'产品'
		},
		{
		    header:'数量',
			dataIndex:'BookQty',
			id:'BookQty'
		},
//		{
//		    header:'运输单价',
//			dataIndex:'TransPrice',
//			id:'TransPrice'
//		},
		{
		    header:'装卸单价',
			dataIndex:'LoadPrice',
			id:'LoadPrice',
			renderer: function(v){  
                return Number(v).toFixed(2)+'元'; //保留2位  
            } 
		}	,
		{
		    header:'装卸类型',
			dataIndex:'LoadTypeText',
			id:'LoadTypeText',
			tooltip:'装卸类型'
		},
		{
		    header:'装卸费用',
			dataIndex:'LoadAmt',
			id:'LoadAmt',
			tooltip:'装卸费用',
			summaryType: 'sum',
            summaryRenderer: function(v, params, data){  
                return Number(v).toFixed(4)+'元'; //保留2位  
            } 
		}
//		{
//		    header:'运输类型',
//			dataIndex:'TransTypeText',
//			id:'TransTypeText',
//			tooltip:'运输类型'
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
var ArriveDriverPostPanel = new Ext.form.TextField({
        style: 'margin-left:0px',
        cls: 'key',
        xtype: 'combo',
        fieldLabel: '驾驶员',
        name: 'nameCust',
        anchor: '95%'
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
    layout:'fit',
    buttonAlign: 'right',
    bodyStyle: 'padding:5px',
    frame: true,    
    items: [{
        layout: 'column',   //定义该元素为布局为列布局方式
        border: false,
        items: [{
                columnWidth: .23,  //该列占用的宽度，标识为20％
                layout: 'form',
                border: false,
                labelWidth: 55,
                items: [
                    ArriveFeePostPanel
                ]
            }, {
                columnWidth: .23,
                layout: 'form',
                border: false,
                labelWidth: 50,
                items: [
                    ArriveDriverPostPanel
                    ]
            }, {
                columnWidth: .23,
                layout: 'form',
                border: false,
                labelWidth: 55,
                items: [
                    provideFeeStartPanel
                    ]
            }, {
                name: 'cusStyle',
                columnWidth: .23,
                layout: 'form',
                border: false,
                labelWidth: 55,
                items: [
                    provideFeeEndPanel
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
                var driver=ArriveDriverPostPanel.getValue();
                
                gridStore.baseParams.StartSendDate=Ext.util.Format.date(starttime,'Y/m/d');
                gridStore.baseParams.EndSendDate=Ext.util.Format.date(endtime,'Y/m/d');                
                gridStore.baseParams.LoadComId=CompanyId;
                gridStore.baseParams.DriverName=driver;
                
                gridStore.load();
                }
            }]
        }]
    }]
});

/*----------------------------*/

var gridStore = new Ext.data.GroupingStore({
    url: 'frmPurchaseLoadFee.aspx?method=getlist',
     reader :new Ext.data.JsonReader({
    totalProperty: 'totalProperty',
    root: 'root',
    fields: [
	{   name:'LoadAmt',type:'float'},
	{		name:'WhId'	},
	{		name:'SupplierId'	},
	{		name:'CreateDate'	},
	{		name:'IsConfirm'	},
	{		name:'ShortName'	},
	{		name:'OrgId'	},
	{		name:'OwnerId'	},
	{		name:'OperId'	},
	{		name:'FromBillType'	},
	{		name:'FromBillId'	},
	{		name:'ConfirmPersonId'	},
	{		name:'ConfirmDate'	},
	{		name:'LoadComId'	},
	{		name:'CarBoatNo'	},
	{		name:'CertiNo'	},
	{		name:'WarehouseAdmin'	},
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
	{		name:'RealQty'	},
	{		name:'TransPrice',type:'float'	},
	{		name:'LoadPrice',type:'float'	},
	{		name:'ProductBn'	},
	{		name:'ProductDate'	},
	{       name:'DriverName'   },
	{	    name:'LoadCompany'
	}
	]
    }),
    sortInfo: {field: 'CreateDate', direction: 'ASC'},
    groupField: 'DriverName'
});

var reportView='v_rpt_purchase_load_fee';
</script>
<script type="text/javascript">

 function getCmbStore(columnName)
{
    return null;
}
    
Ext.onReady(function(){
/*------实现toolbar的函数 start---------------*/
var Toolbar = new Ext.Toolbar({
	renderTo:"toolbar",
	items:[{
		text:"结算",
		icon:"../../Theme/1/images/extjs/customer/add16.gif",
		handler:function(){
		    if(gridStore.getCount()<=0)
		        return;
		        
		        uploadFeeWindow.show();
		        
//	        //再次提醒是否真的要结算
//	        Ext.Msg.confirm("提示信息","是否真要结算装卸费吗？",function callBack(id){
//		        //判断是否删除数据
//		        if(id=="yes")
//		        {	  
//			        
//		        }
//	        });
		}
	}]
});
/*------实现FormPanle的函数 start---------------*/
var feeForm=new Ext.form.FormPanel({
	labelWidth:55,
	frame:true,
	title:'',
	items:[
		{
			xtype:'textfield',
			fieldLabel:'发票号',
			columnWidth:1,
			anchor:'95%',
			name:'VoiceNumber',
			id:'VoiceNumber'
		}
,		{
			xtype:'numberfield',
			fieldLabel:'总金额',
			columnWidth:1,
			anchor:'95%',
			name:'LoadAmt',
			id:'LoadAmt'
		}
,		{
			xtype:'textarea',
			fieldLabel:'备注',
			columnWidth:1,
			anchor:'95%',
			name:'Remark',
			id:'Remark'
		}
]
});
/*------FormPanle的函数结束 End---------------*/
/*------开始界面数据的窗体 Start---------------*/
if (typeof (uploadFeeWindow) == "undefined") {//解决创建2个windows问题
    uploadFeeWindow = new Ext.Window({
        id: 'feeformwindow'
        , iconCls: 'upload-win'
        , width: 400
        , height: 250
        , layout: 'fit'
        , plain: true
        , modal: true
        , constrain: true
        , resizable: false
        , closeAction: 'hide'
        , autoDestroy: true
        , items: feeForm
        , buttons: [{
                text: "保存"
                , handler: function() {
                    saveUserData();
                }
            },
            {
                text: "取消"
                , handler: function() {
                    uploadFeeWindow.hide();
                }
        }]
    });
}
uploadFeeWindow.addListener("hide", function() {
});

/*------开始获取界面数据的函数 start---------------*/
function saveUserData() {
    var amt = Ext.getCmp('LoadAmt').getValue();
    if(amt == null || amt ==""||amt<=0)
         Ext.Msg.alert("提示","请输入结算金额");
         
    //页面提交
    Ext.Msg.wait("保存中....","提示");
    Ext.Ajax.request({
        url:'frmPurchaseLoadFee.aspx?method=settleFee',
        method:'POST',
        params:{
            VoiceNumber:Ext.getCmp('VoiceNumber').getValue(),
            LoadAmt:Ext.getCmp('LoadAmt').getValue(),
            Remark:Ext.getCmp('Remark').getValue(),
            ReportView:gridStore.baseParams.ReportView,
	        StartSendDate:gridStore.baseParams.StartSendDate,
            EndSendDate:gridStore.baseParams.EndSendDate,                
            LoadComId:gridStore.baseParams.LoadComId,
            DriverName:gridStore.baseParams.DriverName,
            Type:'purchase'
        },
        success: function(resp,opts){
             Ext.Msg.hide();
	        if(checkExtMessage(resp)){
			    gridStore.reload();
			}
        },
        failure: function(resp,opts){
            Ext.Msg.hide();
	        Ext.Msg.alert("提示","保存失败");
        }
    });
}

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
        showGroupName: true,
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
gridStore.baseParams.ReportView=reportView;
//createSearch(viewGrid,gridStore,"searchForm");
//setControlVisibleByField();
//searchForm.el="searchForm";
//searchForm.render();
})
</script>
</html>
