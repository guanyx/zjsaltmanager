<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmProvideSendStatics.aspx.cs" Inherits="SCM_frmProvideSendStatics" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html>
<head>
<title>发货统计</title><meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<link rel="stylesheet" type="text/css" href="../ext3/resources/css/ext-all.css" />
<script type="text/javascript" src="../ext3/adapter/ext/ext-base.js"></script>
<script type="text/javascript" src="../ext3/ext-all.js"></script>
<script type="text/javascript" src="../js/floatUtil.js"></script>
<link rel="stylesheet" href="../css/Ext.ux.grid.GridSummary.css"/>
<script type="text/javascript" src='../js/Ext.ux.grid.GridSummary.js'></script>
<link rel="stylesheet" href="../ext3/example/GroupSummary.css"/>
<script type="text/javascript" src="../ext3/example/GroupSummary.js"></script>
<script type="text/javascript" src="../js/operateResp.js"></script>
<script type="text/javascript" src="../ext3/src/locale/ext-lang-zh_CN.js"></script>
</head>
<body>
<div id='toolbar'></div>
<div id='searchForm'></div>
<div id='sendGrid'></div>
<div id='sendDtlGrid'></div>
<div id='confirmGrid'></div>
<%=getComboBoxStore() %>
</body>
<script type="text/javascript">
Ext.BLANK_IMAGE_URL = "../ext3/resources/images/default/s.gif";
Ext.onReady(function(){
var saveType = "";
/*------实现toolbar的函数 start---------------*/
var Toolbar = new Ext.Toolbar({
	renderTo:"toolbar",
	items:[{
		text:"发运完成",
		icon:"../Theme/1/images/extjs/customer/edit16.gif",
		handler:function(){
		    modifyMstWin();
		}
	}]
});

/*------结束toolbar的函数 end---------------*/


/*------开始ToolBar事件函数 start---------------*//*-----新增Mst实体类窗体函数----*/
/*-----编辑Mst实体类窗体函数----*/
function modifyMstWin() {
    saveType = 'save';
	var sm = provideGrid.getSelectionModel();
	//获取选择的数据信息
	var selectData =  sm.getSelected();
	if(selectData == null){
		Ext.Msg.alert("提示","请选中需要编辑的信息！");
		return;
	}
	if(selectData.data.Status!='S257'){
		Ext.Msg.alert("提示","请选中已确认开票的信息！");
		return;
	}
	//前再次提醒是否数据正确
	Ext.Msg.confirm("提示信息","是否货物已经确认无误？",function callBack(id){
		//判断是否删除数据
		if(id=="yes")
		{
		    Ext.MessageBox.wait("数据正在保存，请稍候……");
			//页面提交
			Ext.Ajax.request({
				url:'frmProvideSendStatics.aspx?method=finisProvideSend',
				method:'POST',
				params:{
					SendId:selectData.data.SendId
				},
				success: function(resp,opts){
				    Ext.MessageBox.hide();
				    if(checkExtMessage(resp)){
					    dsProvideGrid.reload();
					}
				},
				failure: function(resp,opts){
				    Ext.MessageBox.hide();
					Ext.Msg.alert("提示","操作失败");
				}
			});
		}
	});
}

/*------开始获取数据的函数 start---------------*/
var dsProvideGrid = new Ext.data.Store
({
url: 'frmProvideSendStatics.aspx?method=getProvideSendList',
reader:new Ext.data.JsonReader({
	totalProperty:'totalProperty',
	root:'root'
},[
	{		name:'SendId'	},
	{		name:'OrgId'	},
	{       name:'OrgName'  },
	{		name:'SupplierId'	},
	{		name:'SendDate'	},
	{		name:'Voucher'	},
	{		name:'TransportNo'	},
	{		name:'VehicleNo'	},
	{		name:'NavicertNo'	},
	{		name:'TotalQty'	},
	{		name:'TotalAmt'	},
	{		name:'TotalTax'	},
	{		name:'DtlCount'	},
	{		name:'InstorInfo'	},
	{		name:'OperId'	},
	{		name:'CreateDate'	},
	{		name:'UpdateDate'	},
	{		name:'OwnerId'	},
	{		name:'Status'	},
	{		name:'OpName'	},
	{		name:'Remark'	},
	{		name:'IsActive'	}	
	])
	,
	listeners:
	{
		scope:this,
		load:function(){
		}
	}
});

/*------获取数据的函数 结束 End---------------*/
/*------开始查询form end---------------*/

    //开始日期
    var provideStaticStartPanel = new Ext.form.DateField({
        xtype:'datefield',
        fieldLabel:'发货开始日期',
        anchor:'95%',
        name:'StartDate',
        id:'StartDate',
        format: 'Y年m月d日',  //添加中文样式
        value:new Date().clearTime() 
    });

    //结束日期
    var provideStaticEndPanel = new Ext.form.DateField({
        xtype:'datefield',
        fieldLabel:'发货结束日期',
        anchor:'95%',
        name:'EndDate',
        id:'EndDate',
        format: 'Y年m月d日',  //添加中文样式
        value:new Date().clearTime()
    });
    
    var ArriveStaticPostPanel = new Ext.form.TextField({
        style: 'margin-left:0px',
        cls: 'key',
        xtype: 'textfield',
        fieldLabel: '到站信息',
        name: 'nameCust',
        anchor: '95%'
    });
    
    var provideStaticInvoicePanel = new Ext.form.TextField({
        style: 'margin-left:0px',
        cls: 'key',
        xtype: 'textfield',
        fieldLabel: '发票号码',
        name: 'InvoiceNo',
        anchor: '95%'
    });
    
    var provideStaticVechilePanel = new Ext.form.TextField({
        style: 'margin-left:0px',
        cls: 'key',
        xtype: 'textfield',
        fieldLabel: '车船号',
        name: 'VechNo',
        anchor: '95%'
    });
    
    var  provideStaticSupplier = new Ext.form.ComboBox({
        fieldLabel: '供应商',
        store: dsSupplier,
        displayField: 'ShortName',
        valueField: 'CustomerId',
        triggerAction: 'all',
        typeAhead: false,
        mode: 'local',
        emptyText: '',
        selectOnFocus: false,
        editable: true,
        anchor: '95%'
    });

    var serchform = new Ext.FormPanel({
        renderTo: 'searchForm',
        labelAlign: 'left',
        //layout:'fit',
        buttonAlign: 'right',
        bodyStyle: 'padding:5px',
        frame: true,
        labelWidth: 80,
        items: [
        {
            layout: 'column',   //定义该元素为布局为列布局方式
            border: false,
            items: [{
                columnWidth: .28,  //该列占用的宽度，标识为20％
                layout: 'form',
                border: false,
                items: [
                    provideStaticStartPanel
                ]
            }, {
                columnWidth: .28,
                layout: 'form',
                border: false,
                items: [
                    provideStaticEndPanel
                    ]
            }, {
                name: 'cusStyle',
                columnWidth: .35,
                layout: 'form',
                border: false,
                labelWidth: 55,
                items: [
                    ArriveStaticPostPanel
                ]
            }, {
                columnWidth: .07,
                layout: 'form',
                border: false,
                html: '&nbsp;'
            }]
        },
        {
            layout: 'column',   //定义该元素为布局为列布局方式
            border: false,
            items: [{
                columnWidth: .28,  //该列占用的宽度，标识为20％
                layout: 'form',
                border: false,
                items: [
                    provideStaticInvoicePanel
                ]
            }, {
                columnWidth: .28,
                layout: 'form',
                border: false,
                items: [
                    provideStaticVechilePanel
                    ]
            }, {
                columnWidth: .3,
                layout: 'form',
                border: false,
                labelWidth: 55,
                items: [
                    provideStaticSupplier
                    ]
            },{
                columnWidth: .14,  //该列占用的宽度，标识为20％
                layout: 'form',
                border: false,
                items: [
                    { cls: 'key',
                    xtype: 'button',
                    text: '查询',
                    anchor: '50%',
                    handler :function(){
                    
                    var starttime=provideStaticStartPanel.getValue();
                    var endtime=provideStaticEndPanel.getValue();
                    var postinfo=ArriveStaticPostPanel.getValue();
                    var invNo=provideStaticInvoicePanel.getValue();
                    var vechNo=provideStaticVechilePanel.getValue();
                    var supplierId=provideStaticSupplier.getValue();
                    
                    dsProvideGrid.baseParams.StartSendDate=Ext.util.Format.date(starttime,'Y/m/d');
                    dsProvideGrid.baseParams.EndSendDate=Ext.util.Format.date(endtime,'Y/m/d');
                    dsProvideGrid.baseParams.InstorInfo=postinfo;
                    dsProvideGrid.baseParams.ShipNo=vechNo;
                    dsProvideGrid.baseParams.Voucher=invNo;
                    dsProvideGrid.baseParams.SupplierId=supplierId;
                    
                    dsProvideGrid.load({
                                params : {
                                start : 0,
                                limit : 10
                                } });
                    }
                }]
            }]
        }]
    });
/*------开始查询form end---------------*/
function regexValue(qe){
    var combo = qe.combo;  
    //q is the text that user inputed.  
    var q = qe.query;  
    forceAll = qe.forceAll;  
    if(forceAll === true || (q.length >= combo.minChars)){  
     if(combo.lastQuery !== q){  
         combo.lastQuery = q;  
         if(combo.mode == 'local'){  
             combo.selectedIndex = -1;  
             if(forceAll){  
                 combo.store.clearFilter();  
             }else{  
                 combo.store.filterBy(function(record,id){  
                     var text = record.get(combo.displayField);  
                     //在这里写自己的过滤代码  
                     return (text.indexOf(q)!=-1);  
                 });  
             }  
             combo.onLoad();  
         }else{  
             combo.store.baseParams[combo.queryParam] = q;  
             combo.store.load({  
                 params: combo.getParams(q)  
             });  
             combo.expand();  
         }  
     }else{  
         combo.selectedIndex = -1;  
         combo.onLoad();  
     }  
    }  
    return false;  
}
provideStaticSupplier.on('beforequery',function(qe){  
    regexValue(qe);
});  
function customerShow() {  
    if(<%=CustomerId %> < 0) return;
    provideStaticSupplier.setValue(<%=EmployeeID %>);	
    provideStaticSupplier.setDisabled(true);  
}
customerShow();
/*------开始DataGrid的函数 start---------------*/

var sm= new Ext.grid.CheckboxSelectionModel({
	singleSelect:true
});
var provideGrid = new Ext.grid.GridPanel({
	el: 'sendGrid',
	width:'100%',
	//height:'100%',
	height: 250,
	autoWidth:true,
	//autoHeight:true,
	autoScroll:true,
	layout: 'fit',
	title: '发货单',
	store: dsProvideGrid,
	loadMask: {msg:'正在加载数据，请稍侯……'},
	sm:sm,
	cm: new Ext.grid.ColumnModel([
		sm,
		new Ext.grid.RowNumberer(),//自动行号
		{
			header:'供应商发货单标识',
			dataIndex:'SendId',
			id:'SendId',
			hidden:true,
			hideable:false
		},
		{
			header:'公司标识 (省公司)',
			dataIndex:'OrgId',
			id:'OrgId',
			hidden:true,
			hideable:false
		},
		{
			header:'供应商标识',
			dataIndex:'SupplierId',
			id:'SupplierId',
			hidden:true,
			hideable:false
		},
		{
			header:'公司',
			dataIndex:'OrgName',
			id:'OrgName',
			hideable:false
		},
		{
			header:'发货日期',
			dataIndex:'SendDate',
			id:'SendDate',
			renderer: Ext.util.Format.dateRenderer('Y年m月d日')
		},
		{
			header:'发票号',
			dataIndex:'Voucher',
			id:'Voucher'
		},
		{
			header:'随货同行单号',
			dataIndex:'TransportNo',
			id:'TransportNo'
		},
//		{
//			header:'准运证编号',
//			dataIndex:'NavicertNo',
//			id:'NavicertNo'
//		},
		{
			header:'合计数量',
			dataIndex:'TotalQty',
			id:'TotalQty'
		},
		{
			header:'含税金额',
			dataIndex:'TotalAmt',
			id:'TotalAmt'
		},
		{
			header:'税额',
			dataIndex:'TotalTax',
			id:'TotalTax'
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
			renderer:{fn:function(value, cellmeta, record, rowIndex, columnIndex, store){
		       var index = dsStatus.findBy(function(record, id) {  // dsPayType 为数据源
				 return record.get('DicsCode')==value; //'DicsCode' 为数据源的id列
			   });
			   if(index == -1) return value;
               var record = dsStatus.getAt(index);
               return record.data.DicsName;  // DicsName为数据源的name列
		    }}
		},
		{
			header:'操作员',
			dataIndex:'OpName',
			id:'OpName'
		}		]),
		bbar: new Ext.PagingToolbar({
			pageSize: 10,
			store: dsProvideGrid,
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
		enableHdMenu: false,  //不显示排序字段和显示的列下拉框
		enableColumnMove: false,//列不能移动
		closeAction: 'hide',
		stripeRows: true,
		loadMask: true,
		autoExpandColumn: 2
	});
provideGrid.render();
/*dblclick*/
provideGrid.on({ 
    rowdblclick:function(grid, rowIndex, e) {
        var rec = grid.store.getAt(rowIndex);
        //alert(rec.get("SendId"));
        dsprovideGridDtl.baseParams.SendId = rec.get("SendId");
        dsprovideGridDtl.load();
        dsProvideGridStat.baseParams.SendId = rec.get("SendId");
        dsProvideGridStat.load();
    }
});
/*------DataGrid的函数结束 End---------------*/
var dsprovideGridDtl = new Ext.data.Store
({
    url: 'frmProvideSendStatics.aspx?method=getProvideSendDtl',
    reader:new Ext.data.JsonReader({
	    totalProperty:'totalProperty',
	    root:'root'
    },
   [{ name: 'SendDtlId', type: 'string' },
   { name: 'SendId', type: 'string' },
   { name: 'ProductId', type: 'string' },
   { name: 'Qty', type: 'string' },
   { name: 'Price', type: 'string' },
   { name: 'Amt', type: 'string' },
   { name: 'Tax', type: 'string' },
   { name: 'TaxRate', type: 'string' },
   { name: 'DestInfo', type: 'string' },
   { name: 'ShipNo', type: 'string' }]
   )
});
var provideGridDtl = new Ext.grid.GridPanel({
    el:'sendDtlGrid',
	layout: 'fit',
	width:'100%',
	//height:'100%',
	autoWidth:true,
	//autoHeight:true,
	height: 130,
	autoScroll:true,
	layout: 'fit',
	title: '发货单明细',
	store: dsprovideGridDtl,
	loadMask: {msg:'正在加载数据，请稍侯……'},
	cm: new Ext.grid.ColumnModel([
		new Ext.grid.RowNumberer(),//自动行号
		{
			header:'流水号',
			dataIndex:'SendDtlId',
			id:'SendDtlId',
			hidden:true,
			hideable:false
		},
		{
			header:'供应商发货单标识',
			dataIndex:'SendId',
			id:'SendId',
			hidden:true,
			hideable:false
		},
		{
			header:'商品',
			dataIndex:'ProductId',
			id:'ProductId',
			width:100,
		    renderer:{fn:function(value, cellmeta, record, rowIndex, columnIndex, store){
		    
		       var index = dsProductList.findBy(function(record, id) {  // dsPayType 为数据源
				 return record.get('ProductId')==value; //'DicsCode' 为数据源的id列
			   });			   
			   if(index == -1) return "";
               var nrecord = dsProductList.getAt(index);
               return nrecord.data.ProductName;  // DicsName为数据源的name列
		    }}
		},
		{
			header:'数量',
			dataIndex:'Qty',
			id:'Qty'
		},
		{
			header:'单价',
			dataIndex:'Price',
			id:'Price'
		},
		{
			header:'金额',
			dataIndex:'AmtRate',
			id:'AmtRate'
		},
		{
			header:'税率',
			dataIndex:'TaxRate',
			id:'TaxRate'
		},
		{
			header:'税额',
			dataIndex:'Tax',
			id:'Tax'
		},
		{
			header:'到站信息',
			dataIndex:'DestInfo',
			id:'DestInfo'
		},
		{
			header:'车船号',
			dataIndex:'ShipNo',
			id:'ShipNo'
		}
		]),
		viewConfig: {
			columnsText: '显示的列',
			scrollOffset: 20,
			sortAscText: '升序',
			sortDescText: '降序',
			forceFit: true
		},		
		closeAction: 'hide',
		stripeRows: true,
		loadMask: true,
		autoExpandColumn: 3
});
provideGridDtl.render();
/**********************confirm info*******************************/
var dsProvideGridStat = new Ext.data.GroupingStore
({
url: 'frmProvideSendStatics.aspx?method=getconfirmStaticList',
reader:new Ext.data.JsonReader({
	totalProperty:'totalProperty',
	root:'root'
},[
	{		name:'NoticeDtlId'	},
	{		name:'NoticeId'	},
	{		name:'OrgId'	},
	{		name:'OrgName'	},
	{		name:'ProductId'	},
	{		name:'ProductName'	},
	{		name:'InvoiceQty',mapping:'InvoiceQty',type:'float'  	},
	{		name:'ConfirmQty',mapping:'ConfirmQty',type:'float'  	},
	{		name:'Price',mapping:'Price',type:'float'  	},
	{		name:'Amt',mapping:'Amt',type:'float'  },
	{		name:'Tax',mapping:'Tax',type:'float'  	},	
	{       name:'Status' }
	]),
    sortInfo: {field: 'OrgId', direction: 'ASC'},
    groupField: 'ProductName'
});

//合计项
var summary = new Ext.ux.grid.GridSummary();
var groupsummary = new Ext.ux.grid.GroupSummary();
var provideGridStaticDtl = new Ext.grid.GridPanel({
	el: 'confirmGrid',
	width:'100%',
	height:'100%',
	autoWidth:true,
	autoHeight:true,
	autoScroll:true,
	layout: 'fit',
	title: '<font color=red>到货确认情况</font>',
	enableHdMenu: false,  //不显示排序字段和显示的列下拉框
	enableColumnMove: false,//列不能移动
	store: dsProvideGridStat,
	loadMask: {msg:'正在加载数据，请稍侯……'},
	cm: new Ext.grid.ColumnModel([
		new Ext.grid.RowNumberer(),//自动行号
		{
			header:'流水号',
			dataIndex:'SendDtlId',
			id:'SendDtlId',
			hidden:true,
			hideable:false
		},
		{
			header:'供应商发货单标识',
			dataIndex:'SendId',
			id:'SendId',
			hidden:true,
			hideable:false
		},
		{
			header:'要货单位',
			dataIndex:'OrgName',
			id:'OrgName'
		},
		{
			header:'商品',
			dataIndex:'ProductName',
			id:'ProductName',
			width:100
		},
		{
			header:'进货数量',
			dataIndex:'InvoiceQty',
			id:'InvoiceQty',
			summaryType: 'sum'
		},
		{
			header:'确认数量',
			dataIndex:'ConfirmQty',
			id:'ConfirmQty',
			summaryType: 'sum'
		},
//		{
//			header:'单价',
//			dataIndex:'Price',
//			id:'Price'
//		},
//		{
//			header:'含税金额',
//			dataIndex:'Amt',
//			id:'Amt',
//			summaryType: 'sum'
//		},
//		{
//			header:'税额',
//			dataIndex:'Tax',
//			id:'Tax',
//			summaryType: 'sum'
//		},
		{
			header:'状态',
			dataIndex:'Status',
			id:'Status',
			renderer:{
			    fn:function(value, cellmeta, record, rowIndex, columnIndex, store){
		            var index = dsNoticeStatus.findBy(function(record, id) {  // dsPayType 为数据源
				        return record.get('DicsCode')==value; //'DicsCode' 为数据源的id列
			        });
			        if(index == -1) return value;
                    var record = dsNoticeStatus.getAt(index);
                    return record.data.DicsName;  // DicsName为数据源的name列
		        }}
		}
		]),
		plugins: [summary,groupsummary],
		view: new Ext.grid.GroupingView({
            forceFit: true,
            showGroupName: false,
            enableNoGroups: false,
			enableGroupingMenu: false,
            hideGroupedColumn: true
        }),		
		stripeRows: true,
		loadMask: true,
		autoExpandColumn: 3
});
provideGridStaticDtl.render();
/*------明细DataGrid的函数结束 End---------------*/

})
    document.oncontextmenu=new Function("event.returnValue=false;");
    document.onselectstart=new Function("event.returnValue=false;");
</script>

</html>
