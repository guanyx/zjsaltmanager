<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmTransitDistribute.aspx.cs" Inherits="SCM_frmTransitDistribute" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>分配明细操作</title>
    <meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
    <link rel="stylesheet" type="text/css" href="../ext3/resources/css/ext-all.css" />
    <script type="text/javascript" src="../ext3/adapter/ext/ext-base.js"></script>
    <script type="text/javascript" src="../ext3/ext-all.js"></script>
    <link rel="stylesheet" href="../css/Ext.ux.grid.GridSummary.css"/>
    <script type="text/javascript" src='../js/Ext.ux.grid.GridSummary.js'></script>
    <script type="text/javascript" src="../js/operateResp.js"></script>
    <script type="text/javascript" src="../js/floatUtil.js"></script>
    <style type="text/css">
    .extensive-remove
    {
        background-image: url(../Theme/1/images/extjs/customer/cross.gif) !important;
    }
    .x-grid-back-blue {  
        background: #C3D9FF;  
    }  
    </style>
</head>
<script type="text/javascript">
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
        var args = new Object();
        args = GetUrlParms();
        var SendId = args["SendId"];
        var opType = args["opType"];
    </script>
<body>
<%= getComboBoxStore() %>
    <div id='top'></div>
    <div id='middle'></div>
    <div id='bottom'></div>
</body>
<script type="text/javascript">
Ext.BLANK_IMAGE_URL = "../ext3/resources/images/default/s.gif";
Ext.onReady(function(){
/*----------------发运单商品明细--------------------*/
var dsDistributeGridDtl = new Ext.data.Store
({
    url: 'frmTransitDistribute.aspx?method=getProvideSendDtl',
    reader:new Ext.data.JsonReader({
	    totalProperty:'totalProperty',
	    root:'root'
    },
   [{ name: 'SendDtlId', type: 'string' },
   { name: 'SendId', type: 'string' },
   { name: 'ProductId', type: 'string' },
   { name: 'Qty', mapping:'Qty' ,type: 'float' },
   { name: 'Available' ,mapping:'Available',type:'float'},
   { name: 'HideQty',mapping:'Available' , type: 'float' },
   { name: 'Price', type: 'float' },
   { name: 'Amt', type: 'float' },
   { name: 'Tax', type: 'float' },
   { name: 'TaxRate', type: 'string' },
   { name: 'DestInfo', type: 'string' },
   { name: 'ShipNo', type: 'string' },
   { name: 'TransType', type: 'string' },
   { name: 'PurchasePrice', type: 'float' },
   { name: 'UnitId', type: 'string' },
   { name: 'UnitText', type: 'string' }]
   )
});
var DistributeGridDtl = new Ext.grid.GridPanel({
    el:'top',
	layout: 'fit',
	width:'100%',
	//height:'100%',
	autoWidth:true,
	//autoHeight:true,
	height: 150,
	autoScroll:true,
	enableColumnMove:false,
	layout: 'fit',
	title: '发货单明细',
	store: dsDistributeGridDtl,
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
			dataIndex:'UnitId',
			id:'UnitId',
			width:100,
			hidden:true,
			hideable:true
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
			header:'发运数量',
			dataIndex:'Qty',
			id:'Qty',
			type: 'float',
			renderer:function(v,cm,r){ return v.toFixed(3)+' '+r.data.UnitText;}
		},
		{
			header:'待分配数量',
			dataIndex:'Available',
			id:'Available',
			type: 'float',
			renderer:function(v,cm,r){ return v.toFixed(3)+' '+r.data.UnitText;}
		},
		{
			header:'单价',
			dataIndex:'Price',
			id:'Price',
			renderer:function(v){ return v.toFixed(8)+' 元';}
		},
		{
			header:'金额',
			dataIndex:'Amt',
			id:'Amt',
			renderer:function(v){ return v.toFixed(8)+' 元';}
		},
		{
			header:'税额',
			dataIndex:'Tax',
			id:'Tax',
			renderer:function(v){ return v.toFixed(8)+' 元';}
		},
		{
			header:'税率',
			dataIndex:'TaxRate',
			width:40,
			id:'TaxRate'
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
DistributeGridDtl.render();
/*dblclick*/
DistributeGridDtl.on({ 
    rowdblclick:function(grid, rowIndex, e) {
        var rec = grid.store.getAt(rowIndex);
        if(rec.get('Available')<= 0){
            Ext.Msg.alert("提示","该商品数量已经分配完！");
            return;
        }
        var index = dsProductList.findBy(function(record, id) {  
			 return record.get('ProductId') == rec.get('ProductId'); 
		   });		
		//alert(index);	   
		if(index == -1) return ;
        var nrecord = dsProductList.getAt(index);
        var transrec = transmitGrid.store.getAt(transmitGrid.store.getCount() - 1);
        transrec.set('ProductId' ,nrecord.get("ProductId"));
        transrec.set('UnitText' ,rec.get("UnitText"));
        transrec.set('SpecificationsText' ,nrecord.get("SpecificationsText"));
        transrec.set('InvoiceQty',rec.get('Available'));
        transrec.set('PurchasePrice',rec.get('Price'));
        transrec.set('Price',0);
        transrec.set('DestInfo',rec.get('DestInfo'));
        transrec.set('VehicleNo',rec.get('ShipNo'));
        transrec.set('ShipNo',rec.get('ShipNo'));
        transrec.set('TransType',rec.get('TransType'));
        transrec.set('TaxRate',rec.get('TaxRate')); 
        transrec.set('UnitId',rec.get('UnitId')); 
        rec.set('Available',0);
        rec.commit();
        inserNewBlankRow();
    }
});
/*------明细DataGrid的函数结束 End---------------*/
/*------分配明细DataGrid的函数 Start---------------*/
//定义下拉框异步调用方法
//var dsSuppliesProductList;   
//if(dsSuppliesProductList==null){
//    dsSuppliesProductList = new Ext.data.Store({
//        url:"frmTransitDistribute.aspx?method=getProducts",
//        reader:new Ext.data.JsonReader({
//            totalProperty:'totalProperty',
//	        root:'root'},
//	        [
//	            {name:'ClassId'},
//	            {name:'ClassNo'},
//	            {name:'ClassName'},
//	            {name:'SpecificationsText'},
//	            {name:'UnitText'},
//	            {name:'CreateDate'},
//	            {name:'Remark'}
//	        ])
//    });
//}  
var productcombobox = new Ext.form.ComboBox({
    store: dsProductList,
    displayField: 'ProductName',
    valueField: 'ProductId',
    triggerAction: 'all',
    id: 'productCombo',
    //typeAhead: true,
    mode: 'local',
    selectOnFocus: false,
    editable: true
});
//productcombobox.on({
//    select:function(combo, record,index)
//    {
//        var sm = transmitGrid.getSelectionModel().getSelected();
//        sm.set('SpecificationsText', record.data.SpecificationsText);
//        sm.set('UnitText', record.data.UnitText);
//        sm.set('ProductId', record.data.ProductId);          
//        addNewBlankRow();        
//        productcombobox.collapse();  
//    }
//});
var dsDistributOrgList = new Ext.data.Store({   
    url: 'frmTransitDistribute.aspx?method=getOrgBydestination',  
    reader: new Ext.data.JsonReader({  
        root: 'root',  
        totalProperty: 'totalProperty',  
        id: 'searchOrgId'  
    }, [  
        {name: 'OrgId', mapping: 'OrgId'},  
        {name: 'OrgName', mapping: 'OrgName'} ,  
        {name: 'OrgShortName', mapping: 'OrgShortName'} 
    ])          
});  
var orgcombobox = new Ext.form.ComboBox({
    store: dsDistributOrgList,
    displayField: 'OrgShortName',
    valueField: 'OrgId',
    triggerAction: 'all',
    id: 'orgCombo',
    //typeAhead: true, 
    mode: 'local',
    selectOnFocus: false,
    editable: true
});
orgcombobox.on({
    select:function(combo, record,index)
    {
        var sm = transmitGrid.getSelectionModel().getSelected();
        sm.set('PurchaseOrg', record.data.OrgId); 
        //获取结算价
        Ext.Ajax.request({
            url: 'frmTransitDistribute.aspx?method=getSettlePrice',
            params: {
                ProductId: sm.get('ProductId'),
                OrgId: record.data.OrgId,
                UnitId:sm.get('UnitId')
            },
            success: function(resp, opts) {
                var dataPrice = Ext.util.JSON.decode(resp.responseText);
                if(dataPrice.sucess=="true")
                    sm.set('Price', dataPrice.price);
                else
                    Ext.Msg.alert("提示", "要货单位的结算价格未配置！");
            },
            failure: function(resp, opts) {
                Ext.Msg.alert("提示", "获取结算价信息失败！");
            }
        });               
        addNewBlankRow();         
        orgcombobox.collapse();    
    }
});

var RowPattern = Ext.data.Record.create([
   { name: 'VehicleNo', type: 'string' },
   { name: 'NoticeDtlId', type: 'string' },
   { name: 'NoticeId', type: 'string' },
   { name: 'ProductId', type: 'string' },
   { name: 'UnitId', type:'string' },
   { name: 'UnitText', type:'string' },
   { name: 'SpecificationsText', type:'string' },
   { name: 'InvoiceQty', type: 'float' },
   { name: 'Price', type: 'float' },
   { name :'TaxRate', type: 'float'},
   { name: 'PurchaseOrg', type: 'string' },
   { name: 'Remark', type: 'string' },
   { name: 'DestInfo',type: 'string' },
   { name: 'ShipNo',type: 'string' },
   { name: 'TransType',type: 'string' },   
   { name: 'PurchasePrice', type: 'float' }
 ]);

var transmitGridData = new Ext.data.Store
({
    url: 'frmTransitDistribute.aspx?method=getTransmitDtlList',
    reader: new Ext.data.JsonReader({
        totalProperty: 'totalProperty',
        root: 'root'
    }, 
    RowPattern
    )
});
var sm = new Ext.grid.CheckboxSelectionModel({
        singleSelect: false
    });
var GridSummary = new Ext.ux.grid.GridSummary();
var totalQry = 0;
var transmitGrid = new Ext.grid.EditorGridPanel({
    renderTo:"middle",                
    id: 'planeGrid',
    split:true,
    clicksToEdit: 1,
    width:'100%',
	//height:'100%',
	height: 300,
	autoWidth:true,
	//autoHeight:true,
	frame:true,	
	autoScroll:true,
	enableColumnMove:false,
    store: transmitGridData ,
    loadMask: { msg: '正在加载数据，请稍侯……' },
    sm:sm,
    cm: new Ext.grid.ColumnModel([
    // new Ext.grid.RowNumberer(), //自动行号		
    {
        header: '车船号',
        dataIndex: 'VehicleNo',
        id: 'VehicleNo',
        width:80,
        resizable:true,
        renderer:{fn:function(value,cellmeta){
            cellmeta.css='x-grid-back-blue'; 
            return value;
        }}
    },{
        header: '商品',
        dataIndex: 'ProductId',
        id: 'ProductId',
        width:150,
        resizable:false,
        editable:false,
        editor: productcombobox,
        renderer:{fn:function(value, cellmeta, record, rowIndex, columnIndex, store){	
           cellmeta.css='x-grid-back-blue'; 	    
	       var index = dsProductList.findBy(function(record, id) {  // dsPayType 为数据源
			 return record.get('ProductId')==value; //'DicsCode' 为数据源的id列
		   });			   
		   if(index == -1) return "";
           var nrecord = dsProductList.getAt(index);
           return nrecord.data.ProductName;  // DicsName为数据源的name列
	    }}
    },{
        header: '单位',
        dataIndex: 'UnitId',
        id: 'UnitId',
        width:55,
        hidden:true,
        hideable:true
    },{
        header: '单位',
        dataIndex: 'UnitText',
        id: 'UnitText',
        width:55,
        resizable:false,
	decimalPrecision:8,
        renderer:{fn:function(value,cellmeta){
            cellmeta.css='x-grid-back-blue'; 
            return value;
        }}
    },
    {
        header: '规格',
        dataIndex: 'SpecificationsText',
        id: 'SpecificationsText',
        width:55,
        resizable:false,
        renderer:{fn:function(value,cellmeta){
            cellmeta.css='x-grid-back-blue'; 
            return value;
        }}
    },
    {
        header: '分配数量',
        dataIndex: 'InvoiceQty',
        id: 'InvoiceQty',
        width:70,
        type:'float',
        resizable:true,	
        editor:new Ext.form.NumberField({ allowBlank: false,decimalPrecision:3 }),
        summaryType: 'sum',
        summaryRenderer: function(v, params, data){
                return '共 ' + v.toFixed(2) + ' 吨';
        }
    },
    {
        header: '结算价',
        dataIndex: 'Price',
        id: 'Price',
        type:'float',
        width:50,	
        editor:new Ext.form.NumberField({ allowBlank: true,decimalPrecision:8 })
    },
    {
        header: '税率',
        dataIndex: 'TaxRate',
        id: 'TaxRate',
        type:'float',
        width:50,
        editor:new Ext.form.NumberField({ allowBlank: true })
    },
    {
        header: '要货单位',
        dataIndex: 'PurchaseOrg',
        id: 'PurchaseOrg',
        width:120,
        resizable:false,
        editor: orgcombobox,
        renderer:{fn:function(value, cellmeta, record, rowIndex, columnIndex, store){
	       var index = dsOrgList.findBy(function(record, id) {  // dsPayType 为数据源
			 return record.get('OrgId')==value; //'DicsCode' 为数据源的id列
		   });			   
		   if(index == -1) return "";
           var nrecord = dsOrgList.getAt(index);
           return nrecord.data.OrgShortName;  // DicsName为数据源的name列
	    }}
    },
    {
        header: '备注',
        dataIndex: 'Remark',
        id: 'Remark',
        editor:new Ext.form.TextArea({ allowBlank: true })
    },
    {
         header: '',
         id:'deleter',
         width:25,
         renderer: function(v, p, record, rowIndex){
            return '<div class="extensive-remove" style="width: 15px; height: 16px;"></div>';
        }
    }
    ]),
    stripeRows: true,
    autoExpandColumn: 'company',
    buttonAlign:'center',
    title:'<font color=red>调运分配情况</font>',
    plugins:GridSummary,
	viewConfig: {
		columnsText: '显示的列',
		scrollOffset: 20,
		sortAscText: '升序',
		sortDescText: '降序',
		forceFit: true
	},
    buttons : [{
        id : 'btnConfirm',
        text : '确定',
        icon : '../Theme/1/images/extjs/customer/add16.gif',        
        handler : function() {
            confirmTransmitData();
        }
        },{
        id : 'btnSave',
        text : '保存',
        icon : '../Theme/1/images/extjs/customer/save.gif',        
        handler : function() {
            saveTransmitData();
        }
        }]
});
transmitGrid.render();
/*-----确认--------*/
function confirmTransmitData(){
    var hasQty = 0;
    var beforeQty = 0;
    transmitGrid.store.each(function(record) {
        hasQty = hasQty.add(record.get('InvoiceQty'));
    });
    DistributeGridDtl.store.each(function(record) {
        beforeQty = beforeQty.add(record.get('Qty'));
    });
    
    if(hasQty!=beforeQty){
        Ext.Msg.alert("提示信息","发运单未分配完前不能做确认！");
        return false;
    }

    //删除前再次提醒是否真的要删除
	Ext.Msg.confirm("提示信息","确认后如果要货单位入库后将不能再修改！是否继续？",function callBack(id){
		//判断是否删除数据
		if(id=="yes")
		{
		    Ext.Msg.wait("正在确认，请稍后……");
			//页面提交
			Ext.Ajax.request({
				url:'frmTransitDistribute.aspx?method=comfirmTransmitData',
				method:'POST',
				params:{
					SendId:SendId
				},
				success: function(resp,opts){
				    Ext.Msg.hide();
				    if(checkParentExtMessage(resp,parent)){
				        transmitGridData.reload();
                        dsDistributeGridDtl.removeAll();
				        parent.uploadTransWindow.hide();					   
					}
				},
				failure: function(resp,opts){
				    Ext.MessageBox.hide();
					Ext.Msg.alert("提示","数据确认操作失败");
				}
			});
		}
	});

}
/*-----保存--------*/
function saveTransmitData(){
    //check
    var check = true;
    transmitGridData.each(function(record) {
        var productid = record.get('ProductId');
        if( productid != undefined && productid != null && productid != "" && parseInt(productid) > 0)
        {
            if(record.get('Price')==''){
                check = false;
                Ext.Msg.alert("提示", "检查有单价没有填写！");
                return;
            }
            if(record.get('PurchaseOrg')==''){
                check = false;
                Ext.Msg.alert("提示", "检查有要货单位没有选择！");
                return;
            }
            if(record.get('InvoiceQty')==''){
                check = false;
                Ext.Msg.alert("提示", "检查有分配数量没有填写！");
                return;
            }
            if(record.get('TaxRate')==''){
                check = false;
                Ext.Msg.alert("提示", "检查有税率没有填写！");
                return;
            }
        }
    });
    if(!check)
        return;
    
    json = "";
    transmitGridData.each(function(record) {
        json += Ext.util.JSON.encode(record.data) + ',';
    });
    json = json.substring(0, json.length - 1);
    
    Ext.MessageBox.wait("数据正在保存，请稍后……");
    //然后传入参数保存
    Ext.Ajax.request({
        url: 'frmTransitDistribute.aspx?method=addTransmitDistribute',
        method: 'POST',
        params: {
            //主参数
            SendId:SendId,

            //明细参数
            DetailInfo: json
        },
        success: function(resp, opts) {
            Ext.MessageBox.hide();
            if(checkParentExtMessage(resp,parent)){
                transmitGridData.reload();
                dsDistributeGridDtl.removeAll();
                parent.uploadTransWindow.hide();
            }
        }, 
        failure: function(resp, opts) {
            Ext.MessageBox.hide();
            Ext.Msg.alert("提示", "保存失败！");

    }
    });
}

/***caculate****/
var beforeQty = 0;
transmitGrid.on({
    beforeedit:function(o){
        //设置要货单位参数
        if(o.field == 'PurchaseOrg'){ 
            dsDistributOrgList.baseParams.DestInfo = o.record.get('DestInfo');
            dsDistributOrgList.load();
        }
        
        if(o.field != 'InvoiceQty')
            return;
        beforeQty = o.value; 
    },
    afteredit:function(o){
        if(o.field != 'InvoiceQty')
            return;
        caculation(o.record);
    },
   cellclick:function(grid, rowIndex, columnIndex, e){
        if(columnIndex==grid.getColumnModel().getIndexById('deleter')) {
            if(opType == 'confirm') return;
		    if(grid.getSelectionModel().hasNext()){//最后一行不允许删除
			    var record = grid.getStore().getAt(rowIndex);		
			    grid.getStore().remove(record);
			    grid.getView().refresh();
			    //caculate start
			    caculation(record);
			    //caculate end	
			}    
		}
   }
});
function caculation(trecord){
    var hasQty = 0;
    transmitGrid.store.each(function(record) {
        //alert(record.get('ProductId')+":"+trecord.get('ProductId'));
        if(record.get('ProductId') == trecord.get('ProductId'))
            hasQty = hasQty.add(record.get('InvoiceQty'));
    });
    var index = DistributeGridDtl.store.findBy(function(record, id) {  
		 return record.get('ProductId') == trecord.get('ProductId'); 
	   });		  
	if(index == -1) return ; 
    var nrecord = DistributeGridDtl.store.getAt(index); 
    
    if(nrecord.get('Qty').sub(hasQty) < 0)
    {  
        Ext.Msg.alert("提示","总分配量大于了进货数量！");
        trecord.set('InvoiceQty',beforeQty);
        return;
    }   
    nrecord.set('Available',nrecord.get('Qty').sub(hasQty));
    nrecord.commit();
}
/*------分配明细DataGrid的函数结束 End---------------*/
function inserNewBlankRow() {
    var rowCount = transmitGrid.getStore().getCount();
    //alert(rowCount);
    var insertPos = parseInt(rowCount);
    var addRow = new RowPattern({
        VehicleNo: '',
        NoticeDtlId: '0',
        NoticeId:'0',
        ProductId: '0',
        UnitName: '',
        SpecificationsName: '',
        InvoiceQty: '0',
        Price:'0',
        TaxRate:'0.17',
        PurchaseOrg: '',
        Remark: '',
        DestInfo:'',
        ShipNo:'',
        TransType:'',
        PurchasePrice:'0'
    });
    transmitGrid.stopEditing();
    //增加一新行
    if (insertPos > 0) { 
        var rowIndex = transmitGridData.insert(insertPos, addRow);
        transmitGrid.startEditing(insertPos, 0);
    }
    else {
        var rowIndex = transmitGridData.insert(0, addRow);
        transmitGrid.startEditing(0, 0);
    }
}
function addNewBlankRow(combo, record, index) {
    var rowIndex = transmitGrid.getStore().indexOf(transmitGrid.getSelectionModel().getSelected());
    var rowCount = transmitGrid.getStore().getCount();
    //alert('insertPos:'+rowCount+":"+rowIndex);
    //provideGridDtlData.getSelectionModel().selectRow(rowCount - 1,true);   
    if ((rowIndex == 0 && rowCount == 1) || rowIndex == rowCount - 1) {
        inserNewBlankRow();
    }
}
/*****--- load ------****/
dsDistributeGridDtl.baseParams.SendId=SendId;
dsDistributeGridDtl.load();
transmitGridData.baseParams.SendId=SendId;
transmitGridData.load({
    callback : function(r, options, success) {
        inserNewBlankRow();
    }
});
/****----button------****/
if(opType == 'confirm'){
    Ext.getCmp('btnSave').setDisabled(true);
    Ext.getCmp('btnConfirm').setDisabled(false);
    //不可编辑
    transmitGrid.getColumnModel().isCellEditable=function(colIndex, rowIndex) {
        return false;
    }
}
else
{
    Ext.getCmp('btnSave').setDisabled(false);
    Ext.getCmp('btnConfirm').setDisabled(true);
    //可编辑
    transmitGrid.getColumnModel().isCellEditable=function(colIndex, rowIndex) {
        return true;
    }
}

});
</script>
</html>
