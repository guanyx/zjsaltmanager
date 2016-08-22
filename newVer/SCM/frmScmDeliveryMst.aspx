<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmScmDeliveryMst.aspx.cs" Inherits="SCM_frmScmDeliveryMst" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html>
<head>
<title>测试页面</title><meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<link rel="stylesheet" type="text/css" href="../ext3/resources/css/ext-all.css" />
<script type="text/javascript" src="../ext3/adapter/ext/ext-base.js"></script>
<script type="text/javascript" src="../ext3/ext-all.js"></script>
<script type="text/javascript" src="../js/operateResp.js"></script>
<style type="text/css">
.x-date-menu {
   width: 175px;
}
</style>
</head>
<script type="text/javascript">
Ext.BLANK_IMAGE_URL = "../ext3/resources/images/default/s.gif" ;
var gridDataData =null;
Ext.onReady(function(){
var saveType="";
/*------实现toolbar的函数 start---------------*/
var Toolbar = new Ext.Toolbar({
	renderTo:"toolbar",
	items:[{
		text:"新增",
		icon:"../Theme/1/images/extjs/customer/add16.gif",
		handler:function(){
		    saveType="Add"; openAddMstWin();
		}
		},'-',{
		text:"编辑",
		icon:"../Theme/1/images/extjs/customer/edit16.gif",
		handler:function(){
		    saveType="Update"; modifyMstWin();
		}
		},'-',{
		text:"删除",
		icon:"../Theme/1/images/extjs/customer/delete16.gif",
		handler:function(){
		    deleteMst();
		}
		},'-',{
		text:"直出库",
		icon:"../Theme/1/images/extjs/customer/1edit16.gif",
		handler:function(){
		    directStockOut();
		}
		},'-',{
		text:"结算",
		icon:"../Theme/1/images/extjs/customer/edit16.gif",
		handler:function(){
		    settleFee();
		}
		},'-',{
		text:"打印",
		icon:"../Theme/1/images/extjs/customer/edit16.gif",
		handler:function(){
		    printMst();
		}
		},'-',{
		text:"查看",
		icon:"../Theme/1/images/extjs/customer/view16.gif",
		handler:function(){
		    viewMstWin();
		}
	}]
});

/*------结束toolbar的函数 end---------------*/


/*------开始ToolBar事件函数 start---------------*//*-----新增Mst实体类窗体函数----*/
function openAddMstWin() {
	uploadMstWindow.show();
    if(document.getElementById("editIFrame").src.indexOf("frmScmDeliveryDtl")==-1)
    {   
        document.getElementById("editIFrame").src = "frmScmDeliveryDtl.aspx?OpenType=oper&DeliveryId=0" ;
    }
    else{
        document.getElementById("editIFrame").contentWindow.DeliveryId=0;
        document.getElementById("editIFrame").contentWindow.setFormValue('oper');
    }
}
/*-----编辑Mst实体类窗体函数----*/
function modifyMstWin() {
	var sm = gridData.getSelectionModel();
	//获取选择的数据信息
	var selectData =  sm.getSelected();
	if(selectData == null){
		Ext.Msg.alert("提示","请选中需要编辑的信息！");
		return;
	}
	uploadMstWindow.show();
    if(document.getElementById("editIFrame").src.indexOf("frmScmDeliveryDtl")==-1)
    {                
        document.getElementById("editIFrame").src = "frmScmDeliveryDtl.aspx?OpenType=oper&DeliveryId=" + selectData.data.DeliveryId;
    }
    else{
        document.getElementById("editIFrame").contentWindow.DeliveryId=selectData.data.DeliveryId;
        document.getElementById("editIFrame").contentWindow.setFormValue('oper');
    }
}
function viewMstWin(){
    var sm = gridData.getSelectionModel();
	//获取选择的数据信息
	var selectData =  sm.getSelected();
	if(selectData == null){
		Ext.Msg.alert("提示","请选中需要查看的信息！");
		return;
	}
	uploadMstWindow.show();
    if(document.getElementById("editIFrame").src.indexOf("frmScmDeliveryDtl")==-1)
    {                
        document.getElementById("editIFrame").src = "frmScmDeliveryDtl.aspx?OpenType=view&DeliveryId=" + selectData.data.DeliveryId;
    }
    else{
        document.getElementById("editIFrame").contentWindow.DeliveryId=selectData.data.DeliveryId;
        document.getElementById("editIFrame").contentWindow.setFormValue('view');
    }
}
function settleFee(){
    var sm = gridData.getSelectionModel();
	//获取选择的数据信息
	var selectData =  sm.getSelected();
	//如果没有选择，就提示需要选择数据信息
	if(selectData == null){
		Ext.Msg.alert("提示","请选中需要运费结算的信息！");
		return;
	}
	    
	//结算前再次提醒是否真的要删除
	Ext.Msg.confirm("提示信息","是否真的要结算选择的信息吗？",function callBack(id){
		//判断是否删除数据
		if(id=="yes")
		{
			//页面提交
			Ext.Ajax.request({
				url:'frmScmDeliveryMst.aspx?method=settleFee',
				method:'POST',
				params:{
					DeliveryId:selectData.data.DeliveryId
				},
				success: function(resp,opts){
				    if( checkExtMessage(resp) )
                     {
                       gridData.getStore().reload();
                     }					
				},
				failure: function(resp,opts){
					Ext.Msg.alert("提示","结算失败");
				}
			});
		}
	});
}
function directStockOut(){
    var sm = gridData.getSelectionModel();
	//获取选择的数据信息
	var selectData =  sm.getSelected();
	//如果没有选择，就提示需要选择数据信息
	if(selectData == null){
		Ext.Msg.alert("提示","请选中需要出库的信息！");
		return;
	}
	//删除前再次提醒是否真的要删除
	Ext.Msg.confirm("提示信息","是否真的要出库选择的信息吗？",function callBack(id){
		//判断是否删除数据
		if(id=="yes")
		{
			//页面提交
			Ext.Ajax.request({
				url:'frmScmDeliveryMst.aspx?method=directStockOutMst',
				method:'POST',
				params:{
					DeliveryId:selectData.data.DeliveryId
				},
				success: function(resp,opts){
				    if( checkExtMessage(resp) )
                     {
                       gridData.getStore().reload();
                     }					
				},
				failure: function(resp,opts){
					Ext.Msg.alert("提示","出库失败");
				}
			});
		}
	});
}
/*-----删除Mst实体函数----*/
/*删除信息*/
function deleteMst()
{
	var sm = gridData.getSelectionModel();
	//获取选择的数据信息
	var selectData =  sm.getSelected();
	//如果没有选择，就提示需要选择数据信息
	if(selectData == null){
		Ext.Msg.alert("提示","请选中需要删除的信息！");
		return;
	}
	
	if(selectData.data.DeliveryStatus==1){
	    //结算前再次提醒是否真的要继续
	    Ext.Msg.confirm("提示信息","是否真的要对已经结算的信息删除？",function callBack(id){
		    //判断是否删除数据
		    if(id == "yes")
		    {
		        deleteMstDo(selectData.data.DeliveryId);
		    }
        });
    }else{
        deleteMstDo(selectData.data.DeliveryId);
    }   
}
function deleteMstDo(deliveryId)
{
    //删除前再次提醒是否真的要删除
	Ext.Msg.confirm("提示信息","是否真的要删除选择的信息吗？",function callBack(id){
		//判断是否删除数据
		if(id=="yes")
		{
			//页面提交
			Ext.Ajax.request({
				url:'frmScmDeliveryMst.aspx?method=deleteMst',
				method:'POST',
				params:{
					DeliveryId:deliveryId
				},
				success: function(resp,opts){
					if( checkExtMessage(resp) )
                     {
                       gridData.getStore().reload();
                     }	
				},
				failure: function(resp,opts){
					Ext.Msg.alert("提示","数据删除失败");
				}
			});
		}
	});
}

/*------实现FormPanle的函数 start---------------*/
var deliveryForm=new Ext.form.FormPanel({
	//url:'',
	renderTo:'searchForm',
	frame:true,
	title:'',
	labelWidth:65,
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
            items: [{
                xtype:'textfield',
		        fieldLabel:'配载编号',
		        columnWidth:1,
		        anchor:'98%',
		        name:'DeliveryNumber',
		        id:'DeliveryNumber'
            }]
        },
		{
            layout:'form',
            border: false,
            columnWidth:0.3,
            items: [{
                xtype:'textfield',
                fieldLabel:'驾驶员',
                columnWidth:0.33,
                anchor:'98%',
                name:'DriverName',
                id:'DriverName'
            }]
        }
,		{
            layout:'form',
            border: false,
            columnWidth:0.3,
            items: [{
                xtype:'textfield',
                fieldLabel:'车辆编号',
                columnWidth:0.33,
                anchor:'98%',
                name:'VehicleNo',
                id:'VehicleNo'
            }]
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
            columnWidth:0.3,
            items: [{
                xtype:'datefield',
                fieldLabel:'开始日期',
                columnWidth:0.5,
                anchor:'98%',
                name:'StartDate',
                id:'StartDate',
                value:new Date().clearTime(),
                format:'Y年m月d日'
            }]
        },
		{
            layout:'form',
            border: false,
            columnWidth:0.3,
            items: [{
                xtype:'datefield',
                fieldLabel:'结束日期',
                columnWidth:0.5,
                anchor:'98%',
                name:'EndDate',
                id:'EndDate',
                value:new Date(),
                format:'Y年m月d日'
            }]
        } ,
  		{
            layout:'form',
            border: false,
            columnWidth:0.23,
            items: [{
                xtype:'combo',
                fieldLabel:'配载类型',
                columnWidth:0.5,
                anchor:'98%',
                name:'DeliveryType',
                id:'DeliveryType',
                mode:'local',
                store:new Ext.data.SimpleStore({
                    fields:
                        ['id',  'name']
                    ,data:[['C011','大配送'],['C012','小配送']]
                }),
                valueField:'id',
                displayField:'name'
            }]            
        },
  		{
            layout:'form',
            border: false,
            columnWidth:0.1,
            items: [{
                cls: 'key',
                xtype: 'button',
                text: '查询',
                buttonAlign:'right',
                id: 'searchebtnId',
                anchor: '70%',
                handler: function() {QueryDataGrid();}
            }]            
        }]
     }]
});
/*------FormPanle的函数结束 End---------------*/

/*------开始界面数据的窗体 Start---------------*/
if(typeof(uploadMstWindow)=="undefined"){//解决创建2个windows问题
	uploadMstWindow = new Ext.Window({
		id:'Mstformwindow',
		title:'配载调度'
		, iconCls: 'upload-win'
		, width: 680
		, height: 490
		, plain: true
		, modal: true
		, constrain:true
		, resizable: false
		, closeAction: 'hide'
		,autoDestroy :true
		, html: '<iframe id="editIFrame" width="100%" height="100%" border=0 src=""></iframe>' 
		});
	}
	uploadMstWindow.addListener("hide",function(){
});

/*------开始获取界面数据的函数 start---------------*/
function getFormValue()
{

	Ext.Ajax.request({
		url:'',
		method:'POST',
		params:{
			DeliveryId:Ext.getCmp('DeliveryId').getValue(),
			DriverId:Ext.getCmp('DriverId').getValue(),
			VehicleId:Ext.getCmp('VehicleId').getValue(),
			CreateDate:Ext.getCmp('CreateDate').getValue(),
			DeliveryDate:Ext.getCmp('DeliveryDate').getValue(),
			OrgId:Ext.getCmp('OrgId').getValue(),
			DeptId:Ext.getCmp('DeptId').getValue(),
			OperId:Ext.getCmp('OperId').getValue(),
			OwnerId:Ext.getCmp('OwnerId').getValue(),
			DeliveryType:Ext.getCmp('DeliveryType').getValue(),
			DeliveryStatus:Ext.getCmp('DeliveryStatus').getValue(),
			IsActive:Ext.getCmp('IsActive').getValue(),
			TotalQty:Ext.getCmp('TotalQty').getValue(),
			TotalAmt:Ext.getCmp('TotalAmt').getValue(),
			TotalTransFee:Ext.getCmp('TotalTransFee').getValue(),
			DtlCount:Ext.getCmp('DtlCount').getValue(),
			DeliveryCount:Ext.getCmp('DeliveryCount').getValue(),
			DeliveryNumber:Ext.getCmp('DeliveryNumber').getValue(),
			Ramark:Ext.getCmp('Ramark').getValue(),
			TotalLoadFee:Ext.getCmp('TotalLoadFee').getValue()		},
		success: function(resp,opts){
			Ext.Msg.alert("提示","保存成功");
		},
		failure: function(resp,opts){
			Ext.Msg.alert("提示","保存失败");
		}
		});
		}
/*------结束获取界面数据的函数 End---------------*/

/*------开始获取数据的函数 start---------------*/
gridDataData = new Ext.data.Store
({
url: 'frmScmDeliveryMst.aspx?method=getDeliveryMstList',
reader:new Ext.data.JsonReader({
	totalProperty:'totalProperty',
	root:'root'
},[
	{		name:'DeliveryId'	},
	{		name:'DriverId'	},
	{		name:'VehicleId'	},
	{		name:'DriverName'	},
	{		name:'VehicleId'	},
	{		name:'VehicleNo'	},
	{		name:'CreateDate'	},
	{		name:'DeliveryDate'	},
	{		name:'OrgId'	},
	{		name:'DeptId'	},
	{		name:'OperId'	},
	{		name:'OwnerId'	},
	{		name:'DeliveryType'	},
	{		name:'DeliveryStatus'	},
	{		name:'IsActive'	},
	{		name:'TotalQty'	},
	{		name:'TotalAmt'	},
	{		name:'TotalTransFee'	},
	{		name:'DtlCount'	},
	{		name:'DeliveryCount'	},
	{		name:'DeliveryNumber'	},
	{		name:'StockStatus'	},
	{		name:'Ramark'	},
	{		name:'TotalLoadFee'	}	
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

/*------开始DataGrid的函数 start---------------*/

var sm= new Ext.grid.CheckboxSelectionModel({
	singleSelect:true
});
var gridData = new Ext.grid.GridPanel({
	el: 'userGrid',
	width:document.body.offsetWidth,
	height:'100%',
	//autoWidth:true,
	//autoHeight:true,
	autoScroll:true,
	layout: 'fit',
	id: '',
	store: gridDataData,
	loadMask: {msg:'正在加载数据，请稍侯……'},
	sm:sm,
	cm: new Ext.grid.ColumnModel([
		sm,
		new Ext.grid.RowNumberer(),//自动行号
		{
			header:'配载单序号',
			dataIndex:'DeliveryId',
			id:'DeliveryId',
			hidden:true,
			hideable:true
		},
		{
			header:'配载编号',
			dataIndex:'DeliveryNumber',
			id:'DeliveryNumber',
			width:100
		},
		{
			header:'驾驶员',
			dataIndex:'DriverName',
			id:'DriverName',
			width:120
		},
		{
			header:'车辆',
			dataIndex:'VehicleNo',
			id:'VehicleNo',
			width:80
		},
		{
			header:'总数量',
			dataIndex:'TotalQty',
			id:'TotalQty',
			width:60
		},
		{
			header:'总金额',
			dataIndex:'TotalAmt',
			id:'TotalAmt',
			width:70
		},
		{
			header:'总运费',
			dataIndex:'TotalTransFee',
			id:'TotalTransFee',
			width:70
		},
//		{
//			header:'创建日期',
//			dataIndex:'CreateDate',
//			id:'CreateDate'
//		},
		{
			header:'发运日期',
			dataIndex:'DeliveryDate',
			id:'DeliveryDate',
			renderer: Ext.util.Format.dateRenderer('Y年m月d日'),
			width:110
		},
		{
			header:'配载类型',
			dataIndex:'DeliveryType',
			id:'DeliveryType',
			renderer: function(v) { if (v == 'C011') return '大配送'; else if(v == 'C012') return '小配送'; },
			width:60
		},
		{
			header:'是否出库',
			dataIndex:'StockStatus',
			id:'StockStatus',
			renderer: function(v) { if (v == 1) return '<font color="blue">是</font>'; else return '<font color="red">否</font>'; },
			width:60
		},
		{
			header:'是否已结',
			dataIndex:'DeliveryStatus',
			id:'DeliveryStatus',
			renderer: function(v) { if (v == 1) return '<font color="blue">是</font>'; else return '<font color="red">否</font>'; },
			width:80
		},
		{
			header:'明细数',
			dataIndex:'DtlCount',
			id:'DtlCount',
			width:50
		},
		{
			header:'配送户数',
			dataIndex:'DeliveryCount',
			id:'DeliveryCount',
			width:60
		},
		{
			header:'备注',
			dataIndex:'Ramark',
			id:'Ramark',
			width:100
		}		]),
		bbar: new Ext.PagingToolbar({
			pageSize: 10,
			store: gridDataData,
			displayMsg: '显示第{0}条到{1}条记录,共{2}条',
			emptyMsy: '没有记录',
			displayInfo: true
		}),
		viewConfig: {
			columnsText: '显示的列',
			scrollOffset: 20,
			sortAscText: '升序',
			sortDescText: '降序',
			forceFit: false
		},
		height: 280,
		closeAction: 'hide',
		stripeRows: true,
		loadMask: true//,
		//autoExpandColumn: 2
	});
gridData.render();
/*------DataGrid的函数结束 End---------------*/

function QueryDataGrid() {
    gridDataData.baseParams.OrgId = Ext.getCmp('DeliveryNumber').getValue();            
    gridDataData.baseParams.CustomerId = Ext.getCmp('DriverName').getValue();
    gridDataData.baseParams.BillMode = Ext.getCmp('VehicleNo').getValue();	
    gridDataData.baseParams.StartDate = Ext.util.Format.date(Ext.getCmp('StartDate').getValue(),'Y/m/d');
    gridDataData.baseParams.EndDate =  Ext.util.Format.date(Ext.getCmp('EndDate').getValue(),'Y/m/d');
    gridDataData.load({
        params: {
            start: 0,
            limit: 10
        }
    });
}
gridData.on('rowdblclick', function(grid, rowIndex, e) {
    //弹出商品明细
    var _record = gridData.getStore().getAt(rowIndex).data.DeliveryId;
    if (!_record) {
        Ext.example.msg('操作', '请选择要查看的记录！');
    } else {
        gridDataDtlData.load({params:{DeliveryId:_record}});
    }

});
///////////////////////////////////////////////
var gridDataDtlData = new Ext.data.Store
({
url: 'frmScmDeliveryMst.aspx?method=getDeliveryProdctList',
reader:new Ext.data.JsonReader({
	totalProperty:'totalProperty',
	root:'root'
},[
	{		name:'ProductId'	},
	{		name:'ProductNo'	},
	{		name:'ProductName'	},
	{		name:'SpecificationsText'	},
	{		name:'UnitId'	},
	{		name:'UnitText'	},
	{		name:'DeliveryQty'	},
	{		name:'TransAmt'	},
	{		name:'LoadAmt'	},
	{		name:'TransPrice'	},
	{		name:'LoadPrice'	}
	])
});
var gridDtlData = new Ext.grid.GridPanel({
	el: 'userDtlGrid',
	//width:'100%',
	height:'100%',
	//autoWidth:true,
	//autoHeight:true,
	autoScroll:true,
	layout: 'fit',
	title: '配送商品明细',
	store: gridDataDtlData,
	loadMask: {msg:'正在加载数据，请稍侯……'},
	cm: new Ext.grid.ColumnModel([
		new Ext.grid.RowNumberer(),//自动行号
		{
			header:'序号',
			dataIndex:'ProductId',
			id:'ProductId',
			hidden:true,
			hideable:false
		},
		{
			header:'产品编号',
			dataIndex:'ProductNo',
			id:'ProductNo',
			width:100
		},
		{
			header:'产品名称',
			dataIndex:'ProductName',
			id:'ProductName',
			width:180
		},
		{
			header:'规格',
			dataIndex:'SpecificationsText',
			id:'SpecificationsText',
			width:80
		},
		{
			header:'单位',
			dataIndex:'UnitText',
			id:'UnitText',
			width:60
		},
		{
			header:'数量',
			dataIndex:'DeliveryQty',
			id:'DeliveryQty',
			width:60
		},
		{
			header:'运费',
			dataIndex:'TransAmt',
			id:'TransAmt',
			width:70
		}
		]),
		viewConfig: {
			columnsText: '显示的列',
			scrollOffset: 20,
			sortAscText: '升序',
			sortDescText: '降序',
			forceFit: false
		},
		height: 220,
		closeAction: 'hide',
		stripeRows: true,
		loadMask: true//,
		//autoExpandColumn: 2
	});
gridDtlData.render();
///////////////////////////////////////////////
})
</script>
<body>
<div id='toolbar'></div>
<div id='searchForm'></div>
<div id='userGrid'></div>
<div id='userDtlGrid'></div>

</body>
</html>

