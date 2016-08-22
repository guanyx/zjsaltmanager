<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmScmDeliveryDtl.aspx.cs" Inherits="SCM_frmScmDeliveryDtl" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html>
<head>
<title>测试页面</title><meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<link rel="stylesheet" type="text/css" href="../ext3/resources/css/ext-all.css" />
<script type="text/javascript" src="../ext3/adapter/ext/ext-base.js"></script>
<script type="text/javascript" src="../ext3/ext-all.js"></script>
<script type="text/javascript" src="../ext3/example/CustomerNumberField.js"></script>
<script type="text/javascript" src="../js/operateResp.js"></script>
<script type="text/javascript" src="../ext3/src/locale/ext-lang-zh_CN.js"></script>
<style type="text/css">
.x-item-disabled-ie {
    color:white;cursor:default;opacity:.9;-moz-opacity:.9; -ms-filter:"progid:DXImageTransform.Microsoft.Alpha(Opacity=90)";
}
.disabledTextField {
	background-color: white;
	color: black;
	opacity:1.0;
	-moz-opacity:1.0;
	filter:alpha(opacity=100);
}
</style>
</head>
<body>
<div id='userGrid'></div>
<div id='divForm'></div>
<div id='divBotton'></div>

</body>
<%=getComboBoxStore()%>
<script type="text/javascript">
Ext.BLANK_IMAGE_URL = "../ext3/resources/images/default/s.gif" ;
function GetUrlParms() {
    var args = new Object();
    var query = location.search.substring(1); //获取查询串   
    var pairs = query.split("&"); //在逗号处断开   
    for (var i = 0; i < pairs.length; i++) {
        var pos = pairs[i].indexOf('='); //查找name=value   
        if (pos == -1) continue; //如果没有找到就跳过   
        var argname = pairs[i].substring(0, pos); //提取name   
        var value = pairs[i].substring(pos + 1); //提取value   
        args[argname] = unescape(value); //存为属性   
    }
    return args;
}
var gridData=null;
var dsOrderProduct = null;
var args = new Object();
args = GetUrlParms();
//如果要查找参数key:
var DeliveryId = args["DeliveryId"];
var OperType = args["OpenType"];

Ext.onReady(function(){
/*------实现toolbar的函数 start---------------*/
var Toolbar = new Ext.Toolbar({
	//renderTo:"toolbar",
    id:'optoolbar',
	items:[{
		text:"增加",
		icon:"../Theme/1/images/extjs/customer/add16.gif",
		handler:function(){
		    openAddDtlWin();
		}
		},'-',{
		text:"删除",
		icon:"../Theme/1/images/extjs/customer/delete16.gif",
		handler:function(){
		    deleteDtl();
		}
	}]
});

/*------结束toolbar的函数 end---------------*/


/*------开始ToolBar事件函数 start---------------*//*-----新增Dtl实体类窗体函数----*/
function openAddDtlWin() {

	uploadDtlWindow.show();
	
	Ext.getCmp('CustomerNo').setValue("");
	Ext.getCmp('DeliveryType').setValue("");
	Ext.getCmp('ProductNo').setValue("");
}
/*-----删除Dtl实体函数----*/
/*删除信息*/
function deleteDtl()
{
	var sm = Ext.getCmp('gridData').getSelectionModel();
	//获取选择的数据信息
	var selectData =  sm.getSelected();
	//如果没有选择，就提示需要选择数据信息
	if(selectData == null){
		Ext.Msg.alert("提示","请选中需要删除的信息！");
		return;
	}
	//删除前再次提醒是否真的要删除
	Ext.Msg.confirm("提示信息","是否真的要删除选择的角色信息吗？",function callBack(id){
		//判断是否删除数据
		if(id=="yes")
		{
			//页面提交
			Ext.Ajax.request({
				url:'frmScmDeliveryDtlList.aspx?method=deleteDtl',
				method:'POST',
				params:{
					DeliveryDtlId:selectData.data.DeliveryDtlId
				},
				success: function(resp,opts){
					Ext.Msg.alert("提示","数据删除成");
				},
				failure: function(resp,opts){
					Ext.Msg.alert("提示","数据删除失败");
				}
			});
		}
	});
}
var dsVehicle;
if (dsVehicle == null) { //防止重复加载
    dsVehicle = new Ext.data.Store
    ({
        url: 'frmDrawInvCtrl.aspx?method=getVehicle',
        reader: new Ext.data.JsonReader({
            totalProperty: 'totalProperty',
            root: 'root'
        }, [{name: 'VehicleId'},
            {name: 'VehicleName'}
        ])
    });
}
dsVehicle.load();
/*------实现FormPanle的函数 start---------------*/
var deliveryDtlForm=new Ext.form.FormPanel({
	//url:'',
	renderTo:'divForm',
	frame:true,
	labelWidth: 80,
	title:'',
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
                xtype:'hidden',
		        fieldLabel:'配载序号',
		        columnWidth:1,
		        anchor:'98%',
		        name:'DeliveryId',
		        id:'DeliveryId'
            }]
        },
        {
            layout:'form',
            border: false,
            columnWidth:0.3,
            items: [{
                xtype:'hidden',
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
            columnWidth:0.33,
            items: [{
                xtype:'numberfield',
                fieldLabel:'总配送数量',
                columnWidth:0.5,
                anchor:'98%',
                name:'TotalQty',
                id:'TotalQty',
                readOnly:true,
                value:0,
                style: 'color:blue;background:white;text-align: right'
            }]
        },
		{
            layout:'form',
            border: false,
            columnWidth:0.33,
            items: [
            {
                xtype:'numberfield',
                fieldLabel:'驾驶员运费',
                columnWidth:0.5,
                anchor:'98%',
                name:'TransAmt',
                id:'TransAmt',
                readOnly:true,
                style: 'color:blue;background:white;text-align: right',
                value:0
            }]
        } ,
//		{
//            layout:'form',
//            border: false,
//            columnWidth:0.33,
//            items: [
//            {
//                xtype:'numberfield',
//                fieldLabel:'装卸费',
//                columnWidth:0.5,
//                anchor:'98%',
//                name:'LoadAmt',
//                id:'LoadAmt',
//                readOnly:true,
//                style: 'color:blue;background:white;text-align: right',
//                value:0
//            }]
//        } ,
  		{
            layout:'form',
            border: false,
            columnWidth:0.34,
            items: [{
                xtype:'textfield',
                fieldLabel:'配送户数',
                columnWidth:0.5,
                anchor:'98%',
                name:'DeliveryCount',
                id:'DeliveryCount',
                readOnly:true,
                value:0,
                style: 'color:blue;background:white;text-align: right'
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
            columnWidth:0.33,
            items: [{
                xtype:'combo',
                fieldLabel:'驾驶员',
                columnWidth:0.33,
                anchor:'98%',
                name:'DriverId',
                id:'DriverId',
                store: dsDriver,
                triggerAction: 'all',
                mode: 'local',
                displayField: 'DriverName',
                valueField: 'DriverId',
                editable: false,
                listeners: {
                    select: function(combo, record, index) {
                        var curdriverId = Ext.getCmp("DriverId").getValue();
                        if(dsVehicle.baseParams.DriverId!=curdriverId)
                        {
                            dsVehicle.baseParams.DriverId=curdriverId;
                            dsVehicle.load({callback: function(resp, opts) { 
                                if(dsVehicle.getCount()>=1)
                                    Ext.getCmp("VehicleId").setValue(dsVehicle.getAt(0).get("VehicleId"));
                                else if(dsVehicle.getCount()==0){
                                    Ext.getCmp("VehicleId").setValue('');
                                    dsVehicle.baseParams.DriverId='';
                                    dsVehicle.load();
                                }
                            }});
                        }
                    }
                 }
            }]
        },
		{
            layout:'form',
            border: false,
            columnWidth:0.33,
            items: [{
                xtype:'combo',
                fieldLabel:'车辆编号',
                columnWidth:0.33,
                anchor:'98%',
                name:'VehicleId',
                id:'VehicleId',
                store: dsVehicle,
                triggerAction: 'all',
                mode: 'local',
                displayField: 'VehicleName',
                valueField: 'VehicleId',
                editable: false
            }]
        },
        {
            layout:'form',
            border: false,
            columnWidth:0.34,
            items: [{
                xtype:'datefield',
                fieldLabel:'发运日期',
                columnWidth:0.5,
                anchor:'98%',
                name:'DeliveryDate',
                id:'DeliveryDate',
                value:new Date().clearTime(),
                format:'Y年m月d日'
            }]
        }]
     },
     {
        layout:'column',
        border: false,
        labelSeparator: '：',
        items: [
        {
            layout:'form',
            border: false,
            columnWidth:0.33,
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
                displayField:'name',
                disabled: true,
    	        disabledClass: 'disabledTextField'
            }]            
        },
        {
            layout:'form',
            border: false,
            columnWidth:.67,
            items: [{
                xtype:'textarea',
                fieldLabel:'备注',
                columnWidth:0.5,
                anchor:'98%',
                height:25,
                name:'Remark',
                id:'Remark'
            }]
        }]
     }
]
});
/*------FormPanle的函数结束 End---------------*/

var resultGridDataData =new Ext.data.Store
({
url: 'frmScmDeliveryDtl.aspx?method=getDrawInvList',
reader:new Ext.data.JsonReader({
	totalProperty:'totalProperty',
	root:'root'
},[
	{        name: 'DrawInvId'    },
    {        name: 'DrawInvDtlId'    },
    {        name: 'DrawNumber'    },
    {        name: 'OutStor'    },
    {        name: 'OutStorName'    },
    {        name: 'SendDate'   },
    {        name: 'CustomerId'    },
    {        name: 'CustomerName'    },
    {        name: 'CustomerCode'    },
    {        name: 'DrawType'    },
    {        name: 'DrawTypeName'    },
    {        name: 'DriverId'    },
    {        name: 'DriverName'    },
    {        name: 'VehicleId'    },
    {        name: 'VehicleName'    },
    {        name: 'ControlDate'    },
    {        name: 'TotalQty'    },
    {        name: 'Price'    },
    {        name: 'TotalAmt'    },
    {        name: 'OrderId'    },
    {        name: 'ProductId'    },
    {        name: 'ProductCode'    },
    {        name: 'ProductName'    },
    {        name: 'DrawQty'    },
    {        name: 'UnitText'    },
    {        name: 'UnitId'    },
    {        name: 'SpecificationsText'    },
    {        name: 'TransFee'    },
    {        name: 'CustomerFee'    },
    { name: 'OrderNumber' },
    { name: 'TransAmt' },
    { name: 'LoadAmt' },
    { name: 'TransPrice' },
    { name: 'LoadPrice' },
    { name: 'DistributionType'}
	])
	,
	listeners:
	{
		scope:this,
		load:function(){
		}
	}
});
function accAdd(arg1,arg2){  
    var r1,r2,m;  
    try{r1=arg1.toString().split(".")[1].length}catch(e){r1=0}  
    try{r2=arg2.toString().split(".")[1].length}catch(e){r2=0}  
    m=Math.pow(10,Math.max(r1,r2))  
    return (arg1*m+arg2*m)/m  
}
function loadDrawInfo(ordernumer){    
    Ext.MessageBox.wait("数据正在读取，请稍候……");    
    resultGridDataData.load({
        params:{OrderNumber: ordernumer},
        callback : function(resp, opts){
            Ext.MessageBox.hide();
            if(resultGridDataData==null || resultGridDataData.getCount()==0)
                return;
            //copy
	        resultGridDataData.each(function(selectData) {   
	            var val=selectData.data.DrawInvDtlId;
	            var cust=selectData.data.CustomerCode;
	            var isExist = false;
	            gridDataData.each(function(r) {
                    if (val == r.data['DrawInvDtlId']) {
                        isExist = true;
                        return;
                    }
                }); 
                if(!isExist){                
                    var custC = false;
                    gridDataData.each(function(r) {
                        if (cust == r.data['CustomerCode']) {
                            custC = true;
                            return;
                        }
                    }); 
                    if(!custC){
                        Ext.getCmp('DeliveryCount').setValue(parseInt(Ext.getCmp('DeliveryCount').getValue())+1);
                    }
                    if(gridDataData.getCount()==0){
                         Ext.getCmp('DeliveryType').setValue(selectData.data.DistributionType);
                    }
                    
                    var addRow = new RowPattern({
                        DeliveryDtlId:'-1',
                        DeliveryId:'-1',
                        ProductId:selectData.data.ProductId,
                        ProductNo:selectData.data.ProductCode,
			            ProductName:selectData.data.ProductName,
			            UnitId:selectData.data.UnitId,
			            UnitName:selectData.data.UnitText,
			            Specifications:selectData.data.SpecificationsText,
			            DeliveryQty:selectData.data.DrawQty,
			            DeliveryPrice:selectData.data.Price,
			            WhId:selectData.data.OutStor,
			            WhpId:'0',
			            DrawInvDtlId:val,
			            DrawInvId:selectData.data.DrawInvId,
			            CustomerFee:selectData.data.CustomerFee,
			            TransPrice:selectData.data.TransPrice,
			            TransAmt:selectData.data.TransAmt,
			            LoadPrice:selectData.data.LoadPrice,
			            LoadAmt:selectData.data.LoadAmt,
			            OrderNumber:selectData.data.OrderNumber,
			            CustomerCode:selectData.data.CustomerCode,
			            CustomerName:selectData.data.CustomerName,
			            OrderId:selectData.data.OrderId,
			            CustomerId:selectData.data.CustomerId
                    });
                    gridData.stopEditing();
                    //增加一新行
                    var rowIndex = gridDataData.insert(0, addRow);
//                    gridData.startEditing(0, 0);    
                    Ext.getCmp('TotalQty').setValue(accAdd(Ext.getCmp('TotalQty').getValue(),selectData.data.DrawQty));
                    Ext.getCmp('TransAmt').setValue(accAdd(Ext.getCmp('TransAmt').getValue(),selectData.data.TransAmt));
                    //Ext.getCmp('LoadAmt').setValue(accAdd(Ext.getCmp('LoadAmt').getValue(),selectData.data.LoadAmt));
                    
                }
	        });
        },
        success: function(resp, opts) {            
        },
        failure: function(resp, opts) {            
            Ext.Msg.alert("提示", "获取读取信息失败！");
        } 
    });
}
/*------开始获取数据的函数 start---------------*/
var RowPattern = Ext.data.Record.create([
   { name: 'DeliveryDtlId', type: 'string' },
   { name: 'DeliveryId', type: 'string' },
   { name: 'ProductId', type: 'string' },
   { name: 'ProductNo', type: 'string' },
   { name: 'ProductName', type: 'string' },
   { name: 'UnitId', type: 'string' },
   { name: 'UnitName', type: 'string' },
   { name: 'Specifications', type: 'string' },
   { name: 'DeliveryQty', type: 'string' },
   { name: 'DeliveryPrice', type: 'string' },
   { name: 'TransFee', type: 'string' },
   { name: 'CustomerFee', type: 'string' },
   { name: 'WhId', type: 'string' },
   { name: 'WhpId', type: 'string'},
   { name: 'DrawInvDtlId', type: 'string'},
   { name: 'DrawInvId', type: 'string'},
   { name: 'CustomerCode', type: 'string'},
   { name: 'CustomerName', type: 'string'},
   { name: 'OrderNumber', type: 'string'},
   { name: 'TransPrice', type: 'string'},
   { name: 'OrderId', type: 'string'},
   { name: 'CustomerId', type: 'string'}
  ]);
var gridDataData = new Ext.data.Store
({
url:'frmScmDeliveryDtl.aspx?method=getDeliveryDtlList',
reader:new Ext.data.JsonReader({
	totalProperty:'totalProperty',
	root:'root'
    },RowPattern )
});

/*------获取数据的函数 结束 End---------------*/

/*------开始DataGrid的函数 start---------------*/

var sm= new Ext.grid.CheckboxSelectionModel({
	singleSelect:true
});
gridData = new Ext.grid.GridPanel({
	el: 'userGrid',
	width:document.body.offsetWidth,
	//height:'100%',
	autoWidth:true,
	//autoHeight:true,
	autoScroll:true,
	layout: 'fit',
	id: '',
	store: gridDataData,
	loadMask: {msg:'正在加载数据，请稍侯……'},
	//sm:sm,
	cm: new Ext.grid.ColumnModel([
		//sm,
		//new Ext.grid.RowNumberer(),
		{
			header:'配载单序号',
			dataIndex:'DeliveryDtlId',
			id:'DeliveryDtlId',
			hidden:true,
			hideable:true
		},
		{
			header:'product序号',
			dataIndex:'ProductId',
			id:'ProductId',
			hidden:true,
			hideable:false
		},
		{
			header:'Drawdtl序号',
			dataIndex:'DrawInvDtlId',
			id:'DrawInvDtlId',
			hidden:true,
			hideable:false
		},
		{
			header:'Draw序号',
			dataIndex:'DrawInvId',
			id:'DrawInvId',
			hidden:true,
			hideable:false
		},
		{
			header:'订单编号',
			dataIndex:'OrderNumber',
			id:'OrderNumber',
			width:65
		},
		{
			header:'客户名称',
			dataIndex:'CustomerName',
			id:'CustomerName',
			width:120
		},
		{
			header:'商品编号',
			dataIndex:'ProductNo',
			id:'ProductNo',
			width:60
		},
		{
			header:'商品名称',
			dataIndex:'ProductName',
			id:'ProductName',
			width:150
		},
		{
			header:'规格',
			dataIndex:'Specifications',
			id:'Specifications',
			width:50
		},
		{
			header:'单位',
			dataIndex:'UnitName',
			id:'UnitName',
			width:45
		},
		{
			header:'数量',
			dataIndex:'DeliveryQty',
			id:'DeliveryQty',
			width:50
		},
//		{
//			header:'价格',
//			dataIndex:'DeliveryPrice',
//			id:'DeliveryPrice'
//		},
		{
			header:'客户运费',
			dataIndex:'CustomerFee',
			id:'CustomerFee',
			width:55,
			align:'right',
			renderer : new Ext.util.Format.numberRenderer('0,0.00')
		},
		{
			header:'运费单价',
			dataIndex:'TransPrice',
			id:'TransPrice',
			hidden:true,
			hideable:false
		},
		{
			header:'仓库',
			dataIndex:'WhId',
			id:'WhId',
            renderer: function(value, cellmeta, record, rowIndex, columnIndex, store) {
                var index = dsWareHouseList.find("WhId", value);
                var record = dsWareHouseList.getAt(index);
                var displayText = "";
                if (record == null) {
                    displayText = value;
                } else {
                    displayText = record.data.WhName; 
                }
                return displayText;
            }    ,
			width:50     
		},
		{
			header:'仓位',
			dataIndex:'WhpId',
			id:'WhpId',
            renderer: function(value, cellmeta, record, rowIndex, columnIndex, store) {
                var index = dsWarehousePosList.find("WhId", record.data.WhId);
                var record = dsWarehousePosList.getAt(index);
                var displayText = "";
                if (record == null) {
                    displayText = value;
                } else {
                    displayText = record.data.WhpName; 
                }
                return displayText;
            }    ,
			width:50   
		}		
		]),
//		bbar: new Ext.PagingToolbar({
//			pageSize: 0,
//			store: gridDataData,
//			displayMsg: '显示第{0}条到{1}条记录,共{2}条',
//			emptyMsy: '没有记录',
//			displayInfo: true
//		}),
        tbar:[
        {             
            text:'订单编号:',
            xtype: 'label'
        },
        {             
            xtype: 'textfield',
            width: 150,
            title:'输入订单号回车进行添加',
	        id:'OrderNumber',
	        name:'OrderNumber',
	        enableKeyEvents: true,
            initEvents: function() {  
                var keyPress = function(e){  
                    if (e.getKey() == e.ENTER) {  
                        loadDrawInfo(Ext.getCmp('OrderNumber').getValue());  
                    }  
                };  
                this.el.on("keypress", keyPress, this);  
            }  
        }],
		//tbar:Toolbar,
		viewConfig: {
			columnsText: '显示的列',
			scrollOffset: 20,
			sortAscText: '升序',
			sortDescText: '降序',
			forceFit: false
		},
		height: 300,
		closeAction: 'hide',
		stripeRows: true,
		loadMask: true//,
		//autoExpandColumn: 2
	});
gridData.render();
/*------DataGrid的函数结束 End---------------*/
var footerForm = new Ext.FormPanel({
    renderTo: 'divBotton',
    border: true, // 没有边框
    labelAlign: 'left',
    buttonAlign: 'center',
    bodyStyle: 'padding:1px',
    height: 25,
    frame: true,
    labelWidth: 55,        
    buttons: [{
        text: "保存",
        scope: this,
        id: 'saveButton',
        handler: function() {
            var json = "";
            gridDataData.each(function(rec) {
                json += Ext.util.JSON.encode(rec.data) + ',';
            });
            //json = json.substring(0, json.length - 1);
                        
            Ext.MessageBox.wait("数据正在保存，请稍候……");
            //然后传入参数保存
            Ext.Ajax.request({
                url: 'frmScmDeliveryDtl.aspx?method=saveMst',
                method: 'POST',
                params: {
                    //主参数
                    VehicleId:Ext.getCmp('VehicleId').getValue(),
	                DriverId:Ext.getCmp('DriverId').getValue(),
	                DeliveryType:Ext.getCmp('DeliveryType').getValue(),
	                DeliveryDate:Ext.getCmp('DeliveryDate').getValue().dateFormat('Y/m/d'),
	                DeliveryId:Ext.getCmp('DeliveryId').getValue(),	
	                Remark:Ext.getCmp('Remark').getValue(),
	                DeliveryCount:Ext.getCmp("DeliveryCount").getValue(),
                    //明细参数
                    DetailInfo: json
                },
                success: function(resp,opts){ 
                Ext.MessageBox.hide();
                if( checkParentExtMessage(resp,parent) )
                     {
                       parent.gridDataData.reload();
                       parent.uploadMstWindow.hide();  
                     }
               },
	            failure: function(resp,opts){  
	                Ext.MessageBox.hide();
	                Ext.Msg.alert("提示","保存失败");     
	            }
          
            });
            //
        }
    },
     {
         text: "取消",
         scope: this,
         handler: function() {
             parent.uploadMstWindow.hide();
         }
    }]
});


if(OperType!='oper')
{
    //Ext.getCmp('optoolbar').hide();
    Ext.getCmp('OrderNumber').getEl().dom.readOnly = true
    Ext.getCmp("saveButton").hide();
}
this.setFormValue=function(operType) {
    OperType = operType;
    Ext.getCmp("DeliveryId").setValue(DeliveryId);
    Ext.getCmp('OrderNumber').setValue('');
    if(OperType=='oper')
    {
        Ext.getCmp('OrderNumber').getEl().dom.readOnly = false
        Ext.getCmp("saveButton").show();
    }else{
        Ext.getCmp('OrderNumber').getEl().dom.readOnly = true
        Ext.getCmp("saveButton").hide();
    }
    //新增数据
    if(DeliveryId==0)
    {
        Ext.getCmp("DeliveryDate").setValue( (new Date()).clearTime() );
        Ext.getCmp("TotalQty").setValue(0);
        Ext.getCmp("TransAmt").setValue(0);
        //Ext.getCmp("LoadAmt").setValue(0);
        Ext.getCmp("DeliveryCount").setValue(0);
        
        Ext.getCmp("DeliveryType").setValue("");
        Ext.getCmp("Remark").setValue("");
        
        gridData.getStore().removeAll();
                
        return;
    }    
    
    Ext.Ajax.request({
        url: 'frmScmDeliveryMst.aspx?method=getDeliveryMst',
        params: {
            DeliveryId: DeliveryId,
            limit:1,
            start:0
        },
        success: function(resp, opts) {           
            var data = Ext.util.JSON.decode(resp.responseText);
            Ext.getCmp("DeliveryType").setValue(data.DeliveryType);
            Ext.getCmp("TotalQty").setValue(data.TotalQty);
            Ext.getCmp("TransAmt").setValue(data.TotalTransFee);
            //Ext.getCmp("LoadAmt").setValue(data.TotalLoadFee);
            Ext.getCmp("DeliveryCount").setValue(data.DeliveryCount);
            Ext.getCmp("DriverId").setValue(data.DriverId);
            Ext.getCmp("VehicleId").setValue(data.VehicleId);
            Ext.getCmp("DeliveryDate").setValue(new Date(data.DeliveryDate.replace(/-/g, "/")));
            Ext.getCmp("Remark").setValue(data.Remark);	
            
            if(gridDataData!= null)
                gridDataData.load({params:{DeliveryId:DeliveryId,limit:32765,start:0}});
            
        },
        failure: function(resp, opts) {
            Ext.Msg.alert("提示", "获取初始化信息失败！");
        }
    });
}
if(DeliveryId>0)
    setFormValue();

})
</script>

</html>
