<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmScmOrderMst.aspx.cs" Inherits="SCM_frmScmOrderMst" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html>
<head>
<title>订单管理</title><meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<link rel="stylesheet" type="text/css" href="../../ext3/resources/css/ext-all.css" />
<link rel="stylesheet" type="text/css" href="../../Theme/1/css/salt.css" />
<script type="text/javascript" src="../../ext3/adapter/ext/ext-base.js"></script>
<script type="text/javascript" src="../../ext3/ext-all.js"></script>
<script type="text/javascript" src="../../js/operateResp.js"></script>
<script type="text/javascript" src="../../js/floatUtil.js"></script>
<script type="text/javascript" src="../../js/ExtJsHelper.js"></script>
<script type="text/javascript" src="../../ext3/src/locale/ext-lang-zh_CN.js"></script>
</head>
<body>
<div id='toolbar'></div>
<div id='divSearchForm'></div>
<div id='divDataGrid'></div>
</body>
<%=getComboBoxStore()%>
<script type="text/javascript">
var version =parseFloat(navigator.appVersion.split("MSIE")[1]);
if(version == 6)
    version = 1;
else //!ie6 contain double size
    version = 3.1;
var OrderMstGridData=null;
Ext.BLANK_IMAGE_URL = "../../ext3/resources/images/default/s.gif";  //作为：让下拉框的三角形下拉图片显示
Ext.onReady(function() {
    
    var saveType="";
    
        /*------实现toolbar的函数 start---------------*/
        var Toolbar = new Ext.Toolbar({
            renderTo: "toolbar",
            items: [{
                text: "清除",
                icon: "../../Theme/1/images/extjs/customer/cross.gif",
                handler: function() {  eraserOrder(); }
            },
            {
                text: "更改主项",
                icon: "../../Theme/1/images/extjs/customer/edit16.gif",
                handler: function() {  changeAccent(); }
            },
            {
                text: "商品单位修改",
                icon: "../../Theme/1/images/extjs/customer/edit16.gif",
                handler: function() {  changeDetailUnit(); }
            },
            {
                text: "商品商品信息",
                icon: "../../Theme/1/images/extjs/customer/edit16.gif",
                handler: function() {  changeDetailProduct(); }
            },
            {
                text: "商品商品价格",
                icon: "../../Theme/1/images/extjs/customer/edit16.gif",
                handler: function() {  changeDetailPrice(); }
            },
            {
                text: "更改销售数量",
                icon: "../../Theme/1/images/extjs/customer/edit16.gif",
                handler: function() {  changeDetailQty(); }
            }
            
            ]
            });
            /*------结束toolbar的函数 end---------------*/
function getUrl(imageUrl)
            {
                var index = window.location.href.toLowerCase().indexOf('/scm/');
                var tempUrl = window.location.href.substring(0,index);
                return tempUrl+"/"+imageUrl;
            }
function printOrderById()
{
var sm = OrderMstGrid.getSelectionModel();
                //多选
                var selectData = sm.getSelections();                
                var array = new Array(selectData.length);
                var orderIds = "";
                for(var i=0;i<selectData.length;i++)
                {
                    if(orderIds.length>0)
                        orderIds+=",";
                    orderIds += selectData[i].get('OrderId');
                }
                alert(orderIds);
                //页面提交
                Ext.Ajax.request({
                    url: 'frmScmOrderMst.aspx?method=printdate',
                    method: 'POST',
                    params: {
                        OrderId: orderIds
                    },
                   success: function(resp,opts){ 
                       var printData =  resp.responseText;
                       var printControl =  parent.parent.parent.document.getElementById("topFrame").contentWindow.getPrintControl();
                       printControl.Url =getUrl('xml');
                       printControl.MapUrl = printControl.Url+'/salePrint1.xml';
                       printControl.PrintXml = printData;
                       printControl.ColumnName="OrderId";
                       printControl.OnlyData=true;
                       printControl.PageWidth=931;
                       printControl.PageHeight =365 ;
                       printControl.Print();
                       
                   },
		           failure: function(resp,opts){  /* Ext.Msg.alert("提示","保存失败"); */    }
                });
}

            /*------开始ToolBar事件函数 start---------------*//*-----新增Order实体类窗体函数----*/
            
            function eraserOrder(){
                //check user
                var uname = '<%=UserName %>';
                if(uname.indexOf('Admin')<=0){
                    Ext.Msg.alert("提示", "请使用管理员操作！");
                    return ;
                }
                var sm = OrderMstGrid.getSelectionModel();
                //多选
                var selectData = sm.getSelections();                
                var array = new Array(selectData.length);
                for(var i=0;i<selectData.length;i++)
                {
                    array[i] = selectData[i].get('OrderId');
                }

                //如果没有选择，就提示需要选择数据信息
                if (selectData == null || selectData == "") {
                    Ext.Msg.alert("提示", "请选中需要操作的记录！");
                    return;
                }
                
                if (array.length != 1) {
                    Ext.Msg.alert("提示", "请选中一条记录！");
                    return;
                }
                //清除前再次提醒是否真的要删除
                Ext.Msg.confirm("提示信息", "提醒订单清除后不能够恢复！是否真的要清除选择的记录？", function callBack(id) {
                    //判断是否删除数据
                    if (id == "yes") {
                         Ext.MessageBox.wait("数据正在处理，请稍候……");
                        //页面提交
                        Ext.Ajax.request({
                            timeout: 180000,
                            url: 'frmScmOrderMst.aspx?method=eraserOrder',
                            method: 'POST',
                            params: {
                                OrderId: array[0]
                            },
                            success: function(resp,opts){  Ext.MessageBox.hide();checkExtMessage(resp);OrderMstGridData.reload();  },
		                    failure: function(resp,opts){  Ext.MessageBox.hide();Ext.Msg.alert("提示","操作失败");     }
                        });
                    }
                });
            }
            
            var printform =null;// ExtJsShowWin('单据打印','#','doc',800,600);
            /*-----打印Order实体函数----*/
            function printOrder() {
               var sm = OrderMstGrid.getSelectionModel();
                //多选
                var selectData = sm.getSelections();                
                var array = new Array(selectData.length);
                for(var i=0;i<selectData.length;i++)
                {
                    array[i] = selectData[i].get('OrderId');
                }

                //如果没有选择，就提示需要选择数据信息
                if (selectData == null || selectData == "") {
                    Ext.Msg.alert("提示", "请选中需要操作的记录！");
                    return;
                }
                
//                if (array.length != 1) {
//                    Ext.Msg.alert("提示", "请选中一条记录！");
//                    return;
//                }
                
                if(printform==null)
                {
                    printform = ExtJsShowWin('单据打印','../common/frmDocReport.aspx?reportName=余杭销售发货单&reportId='+array.join(),'doc',780,480);
                }
                else{                    
                    document.getElementById('iframedoc').src='../common/frmDocReport.aspx?reportName=余杭销售发货单&reportId='+array.join();
                }
                printform.show();
                
                //页面提交
                Ext.Ajax.request({
                    url: 'frmScmOrderMst.aspx?method=print',
                    method: 'POST',
                    params: {
                        OrderId: array[0]
                    },
                   success: function(resp,opts){ /* checkExtMessage(resp) */ },
		           failure: function(resp,opts){  /* Ext.Msg.alert("提示","保存失败"); */    }
                });
                
            }
            function QueryDataGrid() {
                OrderMstGridData.baseParams.OrgId=Ext.getCmp('OrgId').getValue();
                OrderMstGridData.baseParams.OutStor=Ext.getCmp('OutStor').getValue();
                OrderMstGridData.baseParams.OutStor=Ext.getCmp('OutStor').getValue();		                
                OrderMstGridData.baseParams.CustomerId=Ext.getCmp('CustomerId').getValue();
                OrderMstGridData.baseParams.IsPayed=Ext.getCmp('IsPayed').getValue();
                OrderMstGridData.baseParams.IsBill=Ext.getCmp('IsBill').getValue();	                
                OrderMstGridData.baseParams.OrderType=Ext.getCmp('OrderType').getValue();
                OrderMstGridData.baseParams.PayType=Ext.getCmp('PayType').getValue();
                OrderMstGridData.baseParams.BillMode=Ext.getCmp('BillMode').getValue();		                
                OrderMstGridData.baseParams.DlvType=Ext.getCmp('DlvType').getValue();
                OrderMstGridData.baseParams.DlvLevel=Ext.getCmp('DlvLevel').getValue();
                if(Ext.getCmp('OrderType').getValue()=='S014')
                    OrderMstGridData.baseParams.TransType='3';	//只显示直拨订单   
                else
                    OrderMstGridData.baseParams.TransType='';	//只显示直拨订单   
                OrderMstGridData.baseParams.StartDate=Ext.util.Format.date(Ext.getCmp('StartDate').getValue(),'Y/m/d');
                OrderMstGridData.baseParams.EndDate=Ext.util.Format.date(Ext.getCmp('EndDate').getValue(),'Y/m/d');
                OrderMstGridData.load({
                    params: {
                        start: 0,
                        limit: 10
                    }
                });
            }
            
function saveDetailChange()
{
    var json="";
    dsOrderProduct.each(function(dsOrderProduct) {
                    json += Ext.util.JSON.encode(dsOrderProduct.data) + ',';
    });
    Ext.MessageBox.wait("数据正在处理，请稍候……");
    //然后传入参数保存
    Ext.Ajax.request({
        url: 'frmScmOrderMst.aspx?method=savedetail',
        method: 'POST',
        params: {
            //主参数
            ChangeMode:changeMode,
            Json:json
       },
       success: function(resp,opts){ 
            Ext.MessageBox.hide();checkExtMessage(resp);
           },
        failure: function(resp,opts){  
            Ext.MessageBox.hide();Ext.Msg.alert("提示","保存失败");     
        }});
}
var changeMode="";
/*订单细项商品销售数量允许修改 */
function changeDetailQty()
{
    var orderId = getSelectId();
    //判断是否有选择的订单数据
    if(orderId==-1)
        return;
        
    //商品不允许编辑
    detailGrid.getColumnModel().setEditable(2, false);//product
    detailGrid.getColumnModel().setEditable(7, true);//qty
    detailGrid.getColumnModel().setEditable(8, false);//price
    
    UnitCombo.disable();
    dsOrderProduct.baseParams.OrderId=orderId;
    dsOrderProduct.load();
    detailChangeWindow.show();
    changeMode="Qty";
}
/*订单细项商品单位允许修改  */
function    changeDetailUnit()
{
    var orderId = getSelectId();
    //判断是否有选择的订单数据
    if(orderId==-1)
        return;
    //商品不允许编辑
    detailGrid.getColumnModel().setEditable(2, false);//product
    detailGrid.getColumnModel().setEditable(7, false);//qty
    detailGrid.getColumnModel().setEditable(8, false);//price
    
    UnitCombo.enable();
    dsOrderProduct.baseParams.OrderId=orderId;
    dsOrderProduct.load();
    detailChangeWindow.show();
    changeMode="Unit";
}
var selectCustomerId = null;
/*订单细项商品允许修改  */
function    changeDetailProduct()
{
    var orderId = getSelectId();
    //判断是否有选择的订单数据
    if(orderId==-1)
        return;
    //商品不允许编辑
    detailGrid.getColumnModel().setEditable(2, true);//product
    detailGrid.getColumnModel().setEditable(7, false);//qty
    detailGrid.getColumnModel().setEditable(8, false);//price
    
    UnitCombo.disable();
    dsOrderProduct.baseParams.OrderId=orderId;
    dsOrderProduct.load();
    detailChangeWindow.show();
    changeMode="Product";
}

/*订单细项商品价格允许修改*/
function changeDetailPrice()
{
    var orderId = getSelectId();
    //判断是否有选择的订单数据
    if(orderId==-1)
        return;
    //商品不允许编辑
    detailGrid.getColumnModel().setEditable(2, false);//product
    detailGrid.getColumnModel().setEditable(7, false);//qty
    detailGrid.getColumnModel().setEditable(8, true);//price
    
    UnitCombo.disable();
    dsOrderProduct.baseParams.OrderId=orderId;
    dsOrderProduct.load();
    detailChangeWindow.show();
    changeMode="Price";
}

/*订单细项信息修改 可以修改产品信息，数量，价格，单位等信息*/   
function getSelectId()
{
    var sm = OrderMstGrid.getSelectionModel();
                //多选
                var selectData = sm.getSelections();                
                var array = new Array(selectData.length);
                for(var i=0;i<selectData.length;i++)
                {
                    array[i] = selectData[i].get('OrderId');
                }

                //如果没有选择，就提示需要选择数据信息
                if (selectData == null || selectData == "") {
                    Ext.Msg.alert("提示", "请选中需要操作的记录！");
                    return -1;
                }
                
                if (array.length != 1) {
                    Ext.Msg.alert("提示", "请选中一条记录！");
                    return -1;
                }
                selectCustomerId = selectData[0].get('CustomerId');
                return array[0];
}
function changeDetail(){
    var sm = OrderMstGrid.getSelectionModel();
                //多选
                var selectData = sm.getSelections();                
                var array = new Array(selectData.length);
                for(var i=0;i<selectData.length;i++)
                {
                    array[i] = selectData[i].get('OrderId');
                }

                //如果没有选择，就提示需要选择数据信息
                if (selectData == null || selectData == "") {
                    Ext.Msg.alert("提示", "请选中需要操作的记录！");
                    return;
                }
                
                if (array.length != 1) {
                    Ext.Msg.alert("提示", "请选中一条记录！");
                    return;
                }
      dsOrderProduct.baseParams.OrderId=array[0];
      dsOrderProduct.load();
      detailChangeWindow.show();
}

//商品下拉框
        var productCombo = new Ext.form.ComboBox({
            store: dsProductList,
            displayField: 'ProductName',
            valueField: 'ProductId',
            triggerAction: 'all',
            id: 'productCombo1',
            //pageSize: 5,
            //minChars: 2,
            //tpl:resultPrdTpl,
            hideTrigger:true, 
            //itemSelector: 'div.search-item',  
            editable:false,
            typeAhead: true,
            mode: 'local',
            emptyText: '',
            selectOnFocus: false,
            //lastQuery:'',
            onSelect: function(record) {
                dsProductUnits.baseParams.ProductId = record.data.ProductId;
                dsProductUnits.load();
                var sm = detailGrid.getSelectionModel().getSelected();
                sm.set('ProductCode', record.data.ProductNo);
                sm.set('Specifications', record.data.Specifications);
                sm.set('Unit', record.data.Unit);
                sm.set('ProductId', record.data.ProductId);
                sm.set('ProductName',record.data.ProductName);
                sm.set('SalePrice',record.data.SalePrice);
                sm.set('Tax',record.data.SalesTax); 
                sm.set('DiscountRate','0');
                sm.set('DiscountAmt','0');
                sm.set('TransFee','0');
                //sm.set('SalePrice',record.data.Price);
                productCombo.setValue(record.data.ProductId); 
                
                this.collapse();//隐藏下拉列表
            }
        });
        
        //定义下拉框异步调用方法,当前客户可订商品列表
        var dsProductList = new Ext.data.Store({   
            url: 'frmOrderDtl.aspx?method=getCustomProduct',  
            params: {
                //CustomerId: Ext.getCmp('CustomerId').getValue(),
                limit:1,
                start:0
            },
            reader: new Ext.data.JsonReader({  
                root: 'root',  
                totalProperty: 'totalProperty',  
                id: 'productlist'  
            }, [  
                {name: 'ProductId', mapping: 'ProductId'}, 
                {name: 'ProductName', mapping: 'ProductName'},  
                {name: 'ProductNo', mapping: 'ProductNo'},
                {name: 'Specifications', mapping: 'Specifications'},  
                {name: 'SpecificationsText', mapping: 'SpecificationsText'}, 
                {name: 'Unit', mapping: 'Unit'}, 
                {name: 'UnitText', mapping: 'UnitText'},
                {name: 'SalePrice', mapping: 'SalePrice'},
                {name: 'SalesTax', mapping: 'SalesTax'}
            ]) 
        }); 
        // 定义下拉框异步返回显示模板
        var resultPrdTpl = new Ext.XTemplate(  
            '<tpl for="."><div id="productdivid" class="search-item">',  
                '<h3><span>{ProductName}&nbsp</h3>',
            '</div></tpl>'  
        ); 
        
        //定义下拉框异步调用方法,当前客户可订商品列表
        var dsProductUnits = new Ext.data.Store({   
            url: 'frmScmOrderMst.aspx?method=getProductUnits',  
            params: {
                ProductId:0
            },
            reader: new Ext.data.JsonReader({  
                root: 'root',  
                totalProperty: 'totalProperty',  
                id: 'ProductUnits'  
            }, [  
                {name: 'UnitId', mapping: 'UnitId'}, 
                {name: 'UnitName', mapping: 'UnitName'}
            ]) 
        });

        //计量单位下拉框
        var UnitCombo = new Ext.form.ComboBox({
            store: dsProductUnits,
            displayField: 'UnitName',
            valueField: 'UnitId',
            triggerAction: 'all',
            id: 'UnitCombo',
            //pageSize: 5,  
            //minChars: 2,  
            //hideTrigger: true,  
            typeAhead: true,
            mode: 'local',
            emptyText: '',
            selectOnFocus: false,
            editable: false
        });
        //规格下拉框
        var productSpecCombo = new Ext.form.ComboBox({
            store: dsProductSpecList,
            displayField: 'DicsName',
            valueField: 'DicsCode',
            triggerAction: 'all',
            id: 'productSpecCombo',
            //pageSize: 5,  
            //minChars: 2,  
            //hideTrigger: true,  
            typeAhead: true,
            mode: 'local',
            emptyText: '',
            selectOnFocus: false,
            editable: false
        });
        
        var qtyEditor=new Ext.form.NumberField({ 
	            allowBlank: false,
	            align: 'right',
	            decimalPrecision:6,
	            //readOnly:true,
	            listeners: {  
    	            'focus':function(){  
        		        this.selectText();
        		        selectRecord = detailGrid.getSelectionModel().getSelected(); 
    	            },
        	         'change': function(oppt){
        	            var record = selectRecord;
        	            record.set('SaleAmt', accMul(oppt.value , accAdd(record.data.SalePrice,record.data.TransFee)).toFixed(2));
                        record.set('SaleTax', accMul(accDiv(record.data.SaleAmt,accAdd(1,record.data.Tax)) ,record.data.Tax).toFixed(2) ); //Math.Round(3.445, 1); 
                        selectRecord = null;
        	        }   
		        }
		    });
        var priceEditor =  new Ext.form.NumberField({ 
		        allowBlank: false,
		        align: 'right',
		        decimalPrecision:8,
		        //readOnly:true,
		        listeners: {  
        	        'focus':function(){  
        		        this.selectText();  
        		        selectRecord = detailGrid.getSelectionModel().getSelected(); 
        	        },
        	         'change': function(oppt){
        	            var record = selectRecord;
        	            record.set('SaleAmt', accMul(record.data.SaleQty , accAdd(record.data.TransFee,oppt.value)).toFixed(2));
                        record.set('SaleTax', accMul(accDiv(record.data.SaleAmt,accAdd(1,record.data.Tax)) ,record.data.Tax).toFixed(2) ); //Math.Round(3.445, 1); 
        	            selectRecord = null;
        	        }   
    		    }
		    });
        //定义产品下拉框异步调用方法
            var dsProducts;
            if (dsProducts == null) {
                dsProducts = new Ext.data.Store({
                    url: 'frmScmOrderMst.aspx?method=getProductByNameNo',
                    reader: new Ext.data.JsonReader({
                        root: 'root',
                        totalProperty: 'totalProperty'
                    }, [
                            { name: 'ProductId', mapping: 'ProductId' },
                            { name: 'ProductNo', mapping: 'ProductNo' },
                            { name: 'ProductName', mapping: 'ProductName' },
                            { name: 'Unit', mapping: 'Unit' },
                            { name: 'SalePrice', mapping: 'SalePrice' },
                            { name: 'SalePriceLower', mapping: 'SalePriceLower' },
                            { name: 'SalePriceLimit', mapping: 'SalePriceLimit' },
                            { name: 'UnitText', mapping: 'UnitText' },
                            { name: 'Specifications', mapping: 'Specifications' },
                            { name: 'SpecificationsText', mapping: 'SpecificationsText' },
                            { name: 'UnitId', mapping: 'UnitId' },
                            { name:'WhQty',mapping:'WhQty'}
                        ])
                });
            } 
            
        var productText = new Ext.form.TextField({
            name:"ProductNameTpl",
            id:"ProductNameTpl"});
        
        productText.on("focus",setProductFilter);
        
        var productFilterCombo=null;
        
        // 定义下拉框异步返回显示模板
//        var resultTpl = new Ext.XTemplate(  
//            '<tpl for="."><div id="searchdivid" class="search-item">',  
//                '<h3><span>编号:{ProductNo}&nbsp;  名称:{ProductName}</span></h3>',
//            '</div></tpl>'  
//        ); 
var strTemplate='<h3><span>{ProductNo}&nbsp;&nbsp;<font color=\"red\">{ProductName}&nbsp;</font></span></h3>';
        var resultTpl = new Ext.XTemplate(  
            '<tpl for="."><div id="searchdivid" class="search-item">',  
                strTemplate,
            '</div></tpl>'  
        ); 
        
        function setProductFilter()
        {
            //dsProducts.baseParams.WhId = Ext.getCmp('OutStor').getValue();
            dsProducts.baseParams.CustomerId=selectCustomerId;
            if(productFilterCombo==null)
            {
                productFilterCombo = new Ext.form.ComboBox({
                store: dsProducts,
                displayField: 'ProductName',
                displayValue: 'ProductId',
                typeAhead: false,
                minChars: 1,
                width:400,
                loadingText: 'Searching...',
                tpl: resultTpl,  
                itemSelector: 'div.search-item',  
                pageSize: 10,
                hideTrigger: true,
                applyTo: 'ProductNameTpl',
                onSelect: function(record) { // override default onSelect to do redirect  
                           var sm = detailGrid.getSelectionModel().getSelected();                           
                           sm.set('ProductId', record.data.ProductId);
                           sm.set('ProductName',record.data.ProductName);
                           sm.set('ProductCode',record.data.ProductNo);
                           productFilterCombo.collapse();
                           //sm.set('ProductName',record.ProductName);              
            
                    
                }
            });
            }
        }
        
        var productFilterCombo = null;

      var cm = new Ext.grid.ColumnModel([
        new Ext.grid.RowNumberer(), //自动行号
        {
        id: 'OrderDtlId',
        header: "订单明细ID",
        dataIndex: 'OrderDtlId',
        width: 30,
        hidden: true
    },
         {
            id: 'ProductCode',
            header: "商品编码",
            dataIndex: 'ProductCode',
            width: 60,
            editor:productText
        },
        {
            id: 'WhpId',
            header: "仓位",
            dataIndex: 'WhpId',
            hidden: true,
            hideable:false
        },
        {
            id: 'ProductName',
            header: "商品名称",
            dataIndex: 'ProductName',
            width: 160,
            editor: productCombo,
            renderer: function(value, cellmeta, record, rowIndex, columnIndex, store) {
                //解决值显示问题
                //获取当前id="combo_process"的comboBox选择的值
                 var index = dsProductList.find(productCombo.valueField, value);
                var record = dsProductList.getAt(index);
                var displayText = "";
                // 如果下拉列表没有被选择，那么record也就不存在，这时候，返回传进来的value，
                // 而这个value就是grid的USER_REALNAME列的value，所以直接返回
                if (record == null) {
                    //返回默认值，
                    displayText = value;
                } else {
                    displayText = record.data.ProductName; //获取record中的数据集中的process_name字段的值
                }

                return displayText;
            }
        },
        {
            id: "Unit",
            header: "单位",
            dataIndex: "Unit",
            //editable:false,
            width: 50,
            editor: UnitCombo,
            renderer: function(value, cellmeta, record, rowIndex, columnIndex, store) {
                var index = dsUnitList.findBy(function(record, id) {  
	                return record.get(UnitCombo.valueField)==value; 
                });
                var record = dsUnitList.getAt(index);
                var displayText = "";
                // 如果下拉列表没有被选择，那么record也就不存在，这时候，返回传进来的value，
                // 而这个value就是grid的USER_REALNAME列的value，所以直接返回
                if (record == null) {
                    //返回默认值，
                    displayText = value;
                } else {
                    displayText = record.data.UnitName; //获取record中的数据集中的process_name字段的值
                }
                return displayText;
            }
        }
        , {
            id: 'Specifications',
            header: "规格",
            editable:false,
            dataIndex: 'Specifications',
            width: 50,
            editor: productSpecCombo,
            renderer: function(value, cellmeta, record, rowIndex, columnIndex, store) {
                var index = dsProductSpecList.findBy(function(record, id) {  
	                return record.get(productSpecCombo.valueField)==value; 
                });
                var record = dsProductSpecList.getAt(index);
                var displayText = "";
                // 如果下拉列表没有被选择，那么record也就不存在，这时候，返回传进来的value，
                // 而这个value就是grid的USER_REALNAME列的value，所以直接返回
                if (record == null) {
                    //返回默认值，
                    displayText = value;
                } else {
                    displayText = record.data.DicsName; //获取record中的数据集中的process_name字段的值
                }
                return displayText;
            }
        }, {
            id: 'SaleQty',
            header: "数量",
            dataIndex: 'SaleQty',
            width: 55,
		    align: 'right',
            editor: qtyEditor
        }, 
        {
            id: 'SalePrice',
            header: "单价",
            dataIndex: 'SalePrice',
            width: 55,
		    align: 'right',
            editor:priceEditor
        },
        {
            id: 'TransFee',
            header: "运价",
            dataIndex: 'TransFee',
            width: 55,
		    align: 'right',
            editor: new Ext.form.NumberField({ 
		        allowBlank: false,
		        align: 'right',
		        readOnly:true,
		        decimalPrecision:8,
		        listeners: {  
        	        'focus':function(){  
            		        this.selectText(); 
            		        selectRecord = detailGrid.getSelectionModel().getSelected();  
        	        },
        	         'change': function(oppt){
        	            var record = selectRecord;
        	            record.set('SaleAmt', accMul(record.data.SaleQty , accAdd(record.data.SalePrice,oppt.value)).toFixed(2));
                        record.set('SaleTax', accMul(accDiv(record.data.SaleAmt,accAdd(1,record.data.Tax)) ,record.data.Tax).toFixed(2) ); //Math.Round(3.445, 1); 
                        selectRecord = null;
        	        } 
                }
		    })
        },
        {
            id: 'DiscountRate',
            header: "折扣率%",
            dataIndex: 'DiscountRate',
            width: 65,
		    align: 'right',
            editor: new Ext.form.NumberField({ 
                allowBlank: false,
                align: 'right',
                readOnly:true,
                decimalPrecision:6,
                listeners: {  
    	            'focus':function(){  
        		            this.selectText();  
        		            selectRecord = detailGrid.getSelectionModel().getSelected(); 
    	            },
        	         'change': function(oppt){
        	            if(oppt.value<=100 && oppt.value>=0){
        	                var record = selectRecord;
                            record.set('DiscountAmt', accMul(accMul(record.data.SaleQty , accAdd(record.data.SalePrice,record.data.TransFee)) , accDiv(oppt.value,100)).toFixed(2));
                            record.set('SaleAmt', accAdd(accMul(record.data.SaleQty , accAdd(record.data.SalePrice,record.data.TransFee)),-record.data.DiscountAmt).toFixed(2));
                            record.set('SaleTax', accMul(accDiv(record.data.SaleAmt,accAdd(1,record.data.Tax)) ,record.data.Tax).toFixed(2) ); //Math.Round(3.445, 1);                              
                        }
                        selectRecord = null;
        	        }  
    		    }
            })
        },
        {
            id: 'DiscountAmt',
            header: "折扣金额",
            dataIndex: 'DiscountAmt',
            width: 65,
		    align: 'right',
            editor: new Ext.form.NumberField({ 
                allowBlank: false,
                align: 'right',
                readOnly:true,
                decimalPrecision:6,
                listeners: {  
    	            'focus':function(){  
        		            this.selectText();  
        		            selectRecord = detailGrid.getSelectionModel().getSelected(); 
    	            },
        	         'change': function(oppt){
        	            if(oppt.value>=0){
        	                var record = selectRecord;
                            record.set('SaleAmt', accAdd(accMul(record.data.SaleQty , accAdd(record.data.SalePrice,record.data.TransFee)),- oppt.value).toFixed(2));
                            record.set('SaleTax', accMul(accDiv(record.data.SaleAmt,accAdd(1,record.data.Tax)) ,record.data.Tax).toFixed(2) ); //Math.Round(3.445, 1);
                            record.set('DiscountRate', accMul(accDiv(oppt.value , accMul(record.data.SaleQty , accAdd(record.data.SalePrice,record.data.TransFee))),100).toFixed(0));                                                                
                        }
                        selectRecord = null;
        	        } 
    		    }
            })
        },
        {
            id: 'SaleAmt',
            header: "总金额",
            //editable:false,
            dataIndex: 'SaleAmt',
            width: 80,
		    align: 'right',
		    readOnly:true,
            editor: new Ext.form.NumberField({ allowBlank: false,align: 'right',
            listeners: {
		            'focus': function() {
		                this.selectText();
		            }
		        },
		        decimalPrecision:2 })
        },
        {
            id: 'Tax',
            header: "税率",
            editable:false,
		    align: 'right',
            dataIndex: 'Tax',
            width: 50
        },
        {
            id: 'SaleTax',
            header: "税额",
		    align: 'right',
            editable:false,
            dataIndex: 'SaleTax',
            width: 80
        }
        ]);
    cm.defaultSortable = true;

    var RowPattern = Ext.data.Record.create([
           { name: 'OrderDtlId', type: 'string' },
           { name: 'OrderId', type: 'string' },
           { name: 'ProductCode', type: 'string' },
           { name: 'ProductId', type: 'string' },
           { name: 'ProductName', type: 'string' },
           { name: 'Unit', type: 'string' },
           { name: 'Specifications', type: 'string' },
           { name: 'SaleQty', type: 'string' },
           { name: 'SalePrice', type: 'string' },
           { name: 'SaleAmt', type: 'string' },
           { name: 'SaleTax', type: 'string'},
           { name: 'Tax', type: 'string'},
           { name: 'DiscountRate', type: 'string'},
           { name: 'DiscountAmt', type: 'string'},
           { name: 'TransFee', type: 'string'},
           { name: 'ProductUse', type: 'string'},
           { name: 'WhpId', type: 'string'}
          ]);

    var dsOrderProduct=null;
    if (dsOrderProduct == null) {
        dsOrderProduct = new Ext.data.Store
	        ({
	            url: 'frmScmOrderMst.aspx?method=getDtlList',
	            reader: new Ext.data.JsonReader({
	                totalProperty: 'totalProperty',
	                root: 'root'
	            }, RowPattern)
	        });
       
    }
    
    var sm1 = new Ext.grid.CheckboxSelectionModel({
            singleSelect: true
        });
    var detailGrid = new Ext.grid.EditorGridPanel({
        store: dsOrderProduct,
        cm: cm,
        layout: 'fit',
        width: 550,
        autoScroll: true,
        height: 190,
        columnLines:true,
        stripeRows: true,
        frame: true,
        sm:sm1,
	    enableHdMenu: false,  //不显示排序字段和显示的列下拉框
	    enableColumnMove: false,//列不能移动
        //plugins: USER_ISLOCKEDColumn,
        clicksToEdit: 1,
        bbar:['->'],
        viewConfig: {
            columnsText: '显示的列',
            scrollOffset: 20,
            sortAscText: '升序',
            sortDescText: '降序',
            forceFit: false
        },
        listeners:{
            afteredit: function(e){ 
                    if(e.row<e.grid.getStore().getCount()){
                        e.grid.stopEditing();
                        if(e.column < e.record.fields.getCount()-1)
                        {//最后一行操作不算
                            //alert('e.column+1');
                             e.grid.startEditing(e.row, e.column+1);
                        }
                        else
                        {
                            //alert('e.row+1')
                             e.grid.startEditing(e.row+1, 1);
                        }
                    }
                    //自动计算
                    var record = e.record;//获取被修改的行数据
                    var field = e.field;//获取被修改的列名
                    var row = e.row;//获取行号
                    var column =e.column; //获取列号
                    e.record.commit();
                }                
           }
    });   
    var selectRecord = null;
    detailGrid.on("beforeedit",beforeEdit,detailGrid);
    function beforeEdit(e)
    {
        var record = e.record;
        if(record.data.ProductId != dsProductUnits.baseParams.ProductId)
        {
            dsProductUnits.baseParams.ProductId = record.data.ProductId;
            dsProductUnits.load();
        }
    }
            
            
    if (typeof (detailChangeWindow) == "undefined") {//解决创建2个windows问题
            detailChangeWindow = new Ext.Window({
                id: 'detailwindow',
                title: '修改订单信息'
		, iconCls: 'upload-win'
		, width: 600
		, height: 300
		, layout: 'fit'
		, plain: true
		, modal: true
		, x: 50
		, y: 50
		, constrain: true
		, resizable: false
		, closeAction: 'hide'
		, autoDestroy: true
		, items: detailGrid
		, buttons: [{
		    text: "保存"
			, handler: function() {
			    saveDetailChange();
			}
			, scope: this
		},
		{
		    text: "取消"
			, handler: function() {
			    detailChangeWindow.hide();
			}
			, scope: this
}]
            });
        }
/*订单细项修改完成*****************************************/            
            var initOrderForm = new Ext.form.FormPanel({
           frame: true,
           monitorValid: true, // 把有formBind:true的按钮和验证绑定
           labelWidth: 70,
           items:
           [
            {
                layout:'column',
                border: true,                                 
                items:
                [{
                   layout: 'form',
                   columnWidth: .95,  //该列占用的宽度，标识为20％
                   border: false,
                   items: [{
                            
                            cls: 'key',
                       xtype: 'textfield',
                       readOnly:true,
                       fieldLabel: '客户名称',
                       name: 'editcusname',
                       id: 'editcusname',
                       anchor: '98%'
                          }]
                 }
                 ]
            } ,
            {
                layout:'column',
                border: false,
                items:
                [{
                   layout: 'form',
                   columnWidth: .33,  //该列占用的宽度，标识为20％
                   border: false,
                   items: [{
                       style: 'margin-left:0px',
                            cls: 'key',
                            xtype: 'textfield',
                            fieldLabel: '客户编号',
                            readOnly:true,
                            name: 'editcusno',
                            id:'editcusno',
                            anchor: '100%'
                           }]
                  },
                  {
                   layout: 'form',
                   columnWidth: .33,  //该列占用的宽度，标识为20％
                   border: false,
                   items: [{
                       cls: 'key',
                       xtype: 'textfield',
                       readOnly:true,
                       fieldLabel: '联系电话',
                       name: 'editmobile',
                       id: 'editmobile',
                       anchor: '98%'
                          }]
                  } ,
                  {
                   layout: 'form',
                   columnWidth: .33,  //该列占用的宽度，标识为20％
                   border: false,
                   items: [{
                       cls: 'key',
                       xtype: 'textfield',
                       readOnly:true,
                       fieldLabel: '负责人',
                       name: 'editperson',
                       id: 'editperson',
                       anchor: '98%'
                          }]
                 }]
            },
            {
                layout:'column',
                border: false,
                items:
                [{
                   layout: 'form',
                   columnWidth: .66,  //该列占用的宽度，标识为20％
                   border: false,
                   items: [{
                       cls: 'key',
                       xtype: 'textfield',
                       readOnly:true,
                       fieldLabel: '客户地址',
                       name: 'editcusadd',
                       id: 'editcusadd',
                       anchor: '98%'
                          }]
                 }]
             },
            {
                layout:'column',
                border: false,
                items:
                [{
                   layout: 'form',
                   columnWidth: 1,  //该列占用的宽度，标识为20％
                   border: false,
                   items: [{
                       xtype: 'hidden',
                       fieldLabel: '客户ID',
                       name: 'editCustomerId',
                       id: 'editCustomerId',
                       anchor: '98%',
                       hidden:true,
                       hideLabel:true
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
			                items: [
				                {
					                 xtype:'datefield',
			                        fieldLabel:'送货日期',
			                        columnWidth:0.33,
			                        anchor:'98%',
			                        name:'editDlvDate',
			                        id:'editDlvDate',
			                        format:'Y年m月d日'
				                }
		                            ]
		                }		                
//                ,		{
//			                layout:'form',
//			                border: false,
//			                columnWidth:0.66,
//			                items: [
//				                {
//					               xtype:'combo',
//			                        fieldLabel:'送货地点',
//			                        anchor:'98%',
//			                        name:'DlvAdd',
//			                        id:'DlvAdd',
//                                    mode:'local',
//                                    store:dsDeliverAdd,
//                                    valueField: 'AttributeValue',
//                                    displayField: 'AttributeValue',
//                                    mode:'local',
//                                    
//                                   triggerAction: 'all'//                                
//				                }
//		                ]
//		                }
                      ]},{
		                layout:'column',
		                border: false,
		                labelSeparator: '：',
		                items: [
		                {
			                layout:'form',
			                border: false,
			                columnWidth:0.66,
			                items: [
				                {
					               xtype:'textfield',
		                            fieldLabel:'送货描述',
		                            columnWidth:1,
		                            anchor:'98%',
		                            name:'editDlvDesc',
		                            id:'editDlvDesc'
				                }
		                            ]
		                },
		                {
			                layout:'form',
			                border: false,
			                columnWidth:0.33,
			                items: [
				                {
					                xtype: 'combo',
                                   store: dsDlvLevel,
                                   valueField: 'DicsCode',
                                   displayField: 'DicsName',
                                   mode: 'local',
                                   forceSelection: true,
                                   editable: false,
                                   emptyValue: '',
                                   triggerAction: 'all',
                                   fieldLabel: '送货等级',
                                    name:'editDlvLevel',
                                   id:'editDlvLevel',
                                   selectOnFocus: true,
                                   anchor: '98%'
				                }
		                            ]
		                }		 		               
	                ]},{
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
					                xtype: 'combo',
                                   store:dsBillMode,
                                   valueField: 'DicsCode',
                                   displayField: 'DicsName',
                                   mode: 'local',
                                   forceSelection: true,
                                   editable: false,
                                   emptyValue: '',
                                   triggerAction: 'all',
                                   fieldLabel: '结算方式',
                                   name:'editPayType',
                                   id:'editPayType',
                                   selectOnFocus: true,
                                   anchor: '98%'
				                }
		                            ]
		                }		                
                ,		{
			                layout:'form',
			                border: false,
			                columnWidth:0.33,
			                items: [
				                {
					                xtype: 'combo',
                                   store: dsPayType,
                                   valueField: 'DicsCode',
                                   displayField: 'DicsName',
                                   mode: 'local',
                                   forceSelection: true,
                                   editable: false,
                                   emptyValue: '',
                                   triggerAction: 'all',
                                   fieldLabel: '开票方式',
                                   name:'editBillMode',
                                   id:'editBillMode',
                                   selectOnFocus: true,
                                   anchor: '98%'
				                }
		                ]
		                }
                ,		{
			                layout:'form',
			                border: false,
			                columnWidth:0.33,
			                items: [
				                {
					                xtype: 'combo',
                                   store: dsDlvType,
                                   valueField: 'DicsCode',
                                   displayField: 'DicsName',
                                   mode: 'local',
                                   forceSelection: true,
                                   editable: false,
                                   emptyValue: '',
                                   triggerAction: 'all',
                                   fieldLabel: '配送方式',
                                    name:'editDlvType',
                                   id:'editDlvType',
                                   selectOnFocus: true,
                                   anchor: '98%',
                                   listeners:
	                               {
	                                select: function(combo, record, index) {
                                        if(combo.getValue()=='S042')
                                            Ext.getCmp('DriverId').setValue('');
                                        }
	                               }
				                }
		                ]
		                }
	                ]},{
		                layout:'column',
		                border: false,
		                labelSeparator: '：',
		                items: [
		                {
			                layout:'form',
			                border: false,
			                columnWidth:1,
			                items: [
				                {
					                xtype:'textarea',
			                        fieldLabel:'备注',
			                        columnWidth:1,
			                        height:40,
			                        anchor:'98%',
			                        name:'editRemark',
			                        id:'editRemark'
				                }
		                            ]
		                }		                
                    ]}
                    
           ]
         });
            /*更改开票方式*/
        /*------FormPanle的函数结束 End---------------*/
        function changeAccent()
        {
            var sm = OrderMstGrid.getSelectionModel();
                //多选
                var selectData = sm.getSelections();                
                var array = new Array(selectData.length);
                for(var i=0;i<selectData.length;i++)
                {
                    array[i] = selectData[i].get('OrderId');
                }

                //如果没有选择，就提示需要选择数据信息
                if (selectData == null || selectData == "") {
                    Ext.Msg.alert("提示", "请选中需要操作的记录！");
                    return;
                }
                
                if (array.length != 1) {
                    Ext.Msg.alert("提示", "请选中一条记录！");
                    return;
                }
                setFormValue(array[0]);
        }
        
        function changeOrderValue()
        {
            var sm = OrderMstGrid.getSelectionModel();
                //多选
                var selectData = sm.getSelections();                
                var array = new Array(selectData.length);
                for(var i=0;i<selectData.length;i++)
                {
                    array[i] = selectData[i].get('OrderId');
                }

                //如果没有选择，就提示需要选择数据信息
                if (selectData == null || selectData == "") {
                    Ext.Msg.alert("提示", "请选中需要操作的记录！");
                    return;
                }
                
                if (array.length != 1) {
                    Ext.Msg.alert("提示", "请选中一条记录！");
                    return;
                }
                
            Ext.Ajax.request({
                url: 'frmScmOrderMst.aspx?method=changeorder',
                params: {
                    OrderId: array[0],
                    DlvDate:Ext.getCmp("editDlvDate").getValue(),
                    PayType:Ext.getCmp("editPayType").getValue(),
                    BillMode:Ext.getCmp("editBillMode").getValue(),
                    DlvType:Ext.getCmp("editDlvType").getValue(),
                    DlvLevel: Ext.getCmp("editDlvLevel").getValue(),
                    Remark: Ext.getCmp("editRemark").getValue(),
                    DlvDesc:Ext.getCmp("editDlvDesc").getValue()
                },
                success: function(resp, opts) {
                    changeBillWindow.hide();
                    checkExtMessage(resp);
                    OrderMstGridData.reload();
                },
                failure: function(resp, opts) {
                    Ext.Msg.alert("提示", "获取订单信息失败");
                }
            });
        }
        
function setFormValue(selectData) {
            Ext.Ajax.request({
                url: 'frmScmOrderMst.aspx?method=getOrder',
                params: {
                    OrderId: selectData
                },
                success: function(resp, opts) {
                    var data = Ext.util.JSON.decode(resp.responseText);
                //Ext.getCmp("CustomerId").setValue(data.CustomerId);
                Ext.getCmp("editcusno").setValue(data.CustomerNo);
                Ext.getCmp("editcusname").setValue(data.CustomerName);
                Ext.getCmp("editmobile").setValue(data.LinkTel);
                Ext.getCmp("editperson").setValue(data.LinkMan);
                Ext.getCmp("editcusadd").setValue(data.Address);
                Ext.getCmp("editDlvDate").setValue(new Date(data.DlvDate.replace(/-/g, "/")));
//                Ext.getCmp("editDlvAdd").setValue(data.DlvAdd);
//		                Ext.getCmp("OrderType").setValue(data.OrderType);
                Ext.getCmp("editPayType").setValue(data.PayType);
                Ext.getCmp("editBillMode").setValue(data.BillMode);
                Ext.getCmp("editDlvType").setValue(data.DlvType);
                Ext.getCmp("editDlvLevel").setValue(data.DlvLevel);
               
                Ext.getCmp("editRemark").setValue(data.Remark);		  
                Ext.getCmp("editDlvDesc").setValue(data.DlvDesc);	  
                
                    changeBillWindow.show();
                    
                },
                failure: function(resp, opts) {
                    Ext.Msg.alert("提示", "获取订单信息失败");
                }
            });
        }
        /*------开始界面数据的窗体 Start---------------*/
        if (typeof (changeBillWindow) == "undefined") {//解决创建2个windows问题
            changeBillWindow = new Ext.Window({
                id: 'billformwindow',
                title: '修改订单信息'
		, iconCls: 'upload-win'
		, width: 600
		, height: 300
		, layout: 'fit'
		, plain: true
		, modal: true
		, x: 50
		, y: 50
		, constrain: true
		, resizable: false
		, closeAction: 'hide'
		, autoDestroy: true
		, items: initOrderForm
		, buttons: [{
		    text: "保存"
			, handler: function() {
			    changeOrderValue();
			}
			, scope: this
		},
		{
		    text: "取消"
			, handler: function() {
			    changeBillWindow.hide();
			}
			, scope: this
}]
            });
        }
        changeBillWindow.addListener("hide", function() {
        });
        
        function changeBillType()
        {
            
        }
        
        /*结束更改开票方式*/

              //仓库
               var ck = new Ext.form.ComboBox({
                   xtype: 'combo',
                   store: dsWareHouse,
                   valueField: 'WhId',
                   displayField: 'WhName',
                   mode: 'local',
                   forceSelection: true,
                   editable: true,
                   name:'OutStor',
                   id:'OutStor',
                   emptyValue: '',
                   triggerAction: 'all',
                   fieldLabel: '仓库',
                   selectOnFocus: true,
                   anchor: '90%'
               });
               //配送方式
               var psfs = new Ext.form.ComboBox({
                   xtype: 'combo',
                   store: dsDlvType,
                   valueField: 'DicsCode',
                   displayField: 'DicsName',
                   mode: 'local',
                   forceSelection: true,
                   editable: false,
                   emptyValue: '',
                   triggerAction: 'all',
                   fieldLabel: '配送方式',
                    name:'DlvType',
                   id:'DlvType',
                   selectOnFocus: true,
                   anchor: '90%',
				   editable:false
               });               
               
               //开始日期
               var ksrq = new Ext.form.DateField({
           		    xtype:'datefield',
			        fieldLabel:'开始日期',
			        anchor:'90%',
			        name:'StartDate',
			        id:'StartDate',
			        format: 'Y年m月d日',  //添加中文样式
                    value:new Date().clearTime() 
               });
               
               //结束日期
               var jsrq = new Ext.form.DateField({
           		    xtype:'datefield',
			        fieldLabel:'结束日期',
			        anchor:'90%',
			        name:'EndDate',
			        id:'EndDate',
			        format: 'Y年m月d日',  //添加中文样式
                    value:new Date().clearTime()
               });
               
               //送货等级
               var shdj = new Ext.form.ComboBox({
                   xtype: 'combo',
                   store: dsDlvLevel,
                   valueField: 'DicsCode',
                   displayField: 'DicsName',
                   mode: 'local',
                   forceSelection: true,
                   editable: false,
                   emptyValue: '',
                   triggerAction: 'all',
                   fieldLabel: '送货等级',
                    name:'DlvLevel',
                   id:'DlvLevel',
                   selectOnFocus: true,
                   anchor: '90%',
				   editable:false
               });
               
               //结算方式
               var jsfs = new Ext.form.ComboBox({
                   xtype: 'combo',
                   store:dsBillMode,
                   valueField: 'DicsCode',
                   displayField: 'DicsName',
                   mode: 'local',
                   forceSelection: true,
                   editable: false,
                   emptyValue: '',
                   triggerAction: 'all',
                   fieldLabel: '结算方式',
                   name:'PayType',
                   id:'PayType',
                   selectOnFocus: true,
                   anchor: '90%',
				   editable:false
               });
               //开票方式
                var kpfs = new Ext.form.ComboBox({
                   xtype: 'combo',
                   store: dsPayType,
                   valueField: 'DicsCode',
                   displayField: 'DicsName',
                   mode: 'local',
                   forceSelection: true,
                   editable: false,
                   emptyValue: '',
                   triggerAction: 'all',
                   fieldLabel: '开票方式',
                   name:'BillMode',
                   id:'BillMode',
                   selectOnFocus: true,
                   anchor: '90%',
				   editable:false
               });
                //订单类型
                var ddlx = new Ext.form.ComboBox({
                   xtype: 'combo',
                   store: dsOrderType,
                   valueField: 'DicsCode',
                   displayField: 'DicsName',
                   mode: 'local',
                   forceSelection: true,
                   editable: false,
                   emptyValue: '',
                   triggerAction: 'all',
                   fieldLabel: '订单类型',
                   name:'OrderType',
                   id:'OrderType',
                   selectOnFocus: true,
                   anchor: '90%',
				   editable:false,
				   value:'S011'
               });
               
               //公司下拉框
               var gs = new Ext.form.ComboBox({
                    xtype:'combo',
                    fieldLabel:'公司标识',
                    anchor:'90%',
                    name:'OrgId',
                    id:'OrgId',
                    store: dsOrg,
                    displayField: 'OrgName',  //这个字段和业务实体中字段同名
                    valueField: 'OrgId',      //这个字段和业务实体中字段同名
                    typeAhead: true, //自动将第一个搜索到的选项补全输入
                    triggerAction: 'all',
                    emptyValue: '',
                    selectOnFocus: true,
                    forceSelection: true,
				    editable:false,
                    mode:'local'        //这个属性设定从本页获取数据源，才能够赋值定位
               });
               
               //部门下拉框
               var bm = new Ext.form.ComboBox({
                    xtype:'combo',
                    fieldLabel:'部门',
                    anchor:'90%',
                    name:'QryDeptID',
                    id:'QryDeptID',
                    store:dsDept,
                    displayField: 'DeptName',  //这个字段和业务实体中字段同名
                    valueField: 'DeptId',      //这个字段和业务实体中字段同名
                    typeAhead: true, //自动将第一个搜索到的选项补全输入
                    triggerAction: 'all',
                    emptyValue: '',
                    selectOnFocus: true,
                    forceSelection: true,
                    editable:false,
                    mode:'local'        //这个属性设定从本页获取数据源，才能够赋值定位
               });
               
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
			                items: [gs]
		                }
                ,		{
                            layout:'form',
			                border: false,
			                columnWidth:0.33,
			                items:[
			                {
                            layout:'column',
		                    border: false,
		                    labelSeparator: '：',
		                    items: [
			                {
			                    layout:'form',
			                    border: false,
			                    columnWidth:0.275*version,
			                    items: [
			                    {
				                    xtype:'textfield',
				                    fieldLabel:'客户',
				                    anchor:'100%',
				                    name:'CustomerId',
				                    id:'CustomerId'
				                }
			                    ]
			                },
			                {
                               layout: 'form',
                               columnWidth: .03*version,  //该列占用的宽度，标识为20％
                               border: false,
                               items: [
                               {
                                    xtype:'button', 
                                    iconCls:"find",
                                    autoWidth : true,
                                    autoHeight : true,
                                    hideLabel:true,
                                    listeners:{
                                        click:function(v){
                                              getCustomerInfo(function(record){Ext.getCmp('CustomerId').setValue(record.data.ShortName); },gs.getValue());    
                                              //getProductInfo(function(record){ });    
                                        }
                                    }
                               }]
                           }]
                        }]
		                }
                ,		{
			                layout:'form',
			                border: false,
			                columnWidth:0.34,
			                items: [ck]
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
			                items: [psfs]
		                }		                
                ,		{
			                layout:'form',
			                border: false,
			                columnWidth:0.33,
			                items: [
				                {
					                xtype:'combo',
					                fieldLabel:'是否结款',
					                columnWidth:0.33,
					                anchor:'90%',
					                store:[[1,'是'],[0,'否']],
					                name:'IsPayed',
					                id:'IsPayed',
					                triggerAction:'all',
					                editable:false
				                }
		                ]
		                }
                ,		{
			                layout:'form',
			                border: false,
			                columnWidth:0.34,
			                items: [
				                {
					                xtype:'combo',
					                fieldLabel:'是否开票',
					                columnWidth:0.33,
					                anchor:'90%',
					                store:[[1,'是'],[0,'否']],
					                name:'IsBill',
					                id:'IsBill',
					                triggerAction:'all',
					                editable:false
				                }
		                ]
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
			                items: [ddlx]
		                }
                ,		{
			                layout:'form',
			                border: false,
			                columnWidth:0.33,
			                items: [jsfs]
		                }
                ,		{
			                layout:'form',
			                border: false,
			                columnWidth:0.34,
			                items: [kpfs]
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
			                items: [shdj]
		                },
		                {
			                layout:'form',
			                border: false,
			                columnWidth:0.33,
			                items: [
				                {
					                xtype:'datefield',
					                fieldLabel:'开始日期',
					                columnWidth:0.5,
					                anchor:'90%',
					                name:'StartDate',
					                id:'StartDate',
			                        format: 'Y年m月d日',  //添加中文样式
                                    value:new Date().getFirstDateOfMonth().clearTime()
				                }
		                            ]
		                }
                ,		{
			                layout:'form',
			                border: false,
			                columnWidth:0.34,
			                items: [
				                {
					                xtype:'datefield',
					                fieldLabel:'结束日期',
					                columnWidth:0.5,
					                anchor:'90%',
					                name:'EndDate',
					                id:'EndDate',
			                        format: 'Y年m月d日',  //添加中文样式
                                    value:new Date().clearTime()
				                }
		                            ]
		                }
	                ]}
	                ,{//第三行
                        layout:'column',
                        items:[
                            {//第一单元格
                                layout:'form',
                                border: false,
                                labelWidth:70,
                                columnWidth:.33,
                                items:[{
                                     layout:'form',
                                    border:false,
                                    columnWidth:0.33,
                                    html:'&nbsp'
                                }]
                            },
                            {//第二单元格
                                layout:'form',
                                border: false,
                                labelWidth:70,
                                columnWidth:.33,
                                items:[{
                                       
                                }]
                            },
                            {//第三单元格
                                layout:'form',
                                border: false,
                                labelWidth:70,
                                columnWidth:0.34,
                                items:[
                                    {
                                       xtype:'button',
                                        text:'查询',
                                        width:70,
                                        //iconCls:'excelIcon',
                                        scope:this,
                                        handler:function(){
                                            QueryDataGrid();
                                        }
                                    }
                                    ]
                            }
                        ]
                    }
	                
	                
	                               
                ]
                
                });



                        /*------开始查询form的函数 end---------------*/

                        /*------开始界面数据的窗体 Start---------------*/
                        if (typeof (uploadOrderWindow) == "undefined") {//解决创建2个windows问题
                            uploadOrderWindow = new Ext.Window({
                                id: 'Orderformwindow',
                                iconCls: 'upload-win'
		                        , width: 750
		                        , height: 530
		                        , plain: true
		                        , modal: true
		                        , constrain: true
		                        , resizable: false
		                        , closeAction: 'hide'
		                        , autoDestroy: true
		                        , html: '<iframe id="editIFrame" width="100%" height="100%" border=0 src=""></iframe>' 
                                
                            });
                        }
                        uploadOrderWindow.addListener("hide", function() {
                           //document.getElementById("editIFrame").src = "frmOrderDtl.aspx?OpenType=oper&id=0";//清楚其内容，建议在子页面提供一个方法来调用
                        });

                        

                       
                        /*------开始获取数据的函数 start---------------*/
                        OrderMstGridData = new Ext.data.Store
                        ({
                            url: 'frmScmOrderMst.aspx?method=getOrderList',
                            reader: new Ext.data.JsonReader({
                                totalProperty: 'totalProperty',
                                root: 'root'
                            }, [
                                {
		                            name:'OrderId'
	                            },
	                            {
		                            name:'OrderNumber'
	                            },
	                            {
		                            name:'OrgId'
	                            },
	                            {
		                            name:'OrgName'
	                            },
	                            {
		                            name:'DeptId'
	                            },
	                            {
		                            name:'DeptName'
	                            },
	                            {
		                            name:'OutStor'
	                            },
	                            {
		                            name:'OutStorName'
	                            },
	                            {
		                            name:'CustomerId'
	                            },
	                            {
		                            name:'CustomerName'
	                            },
	                            {
		                            name:'DlvDate'
	                            },
	                            {
		                            name:'DlvAdd'
	                            },
	                            {
		                            name:'DlvDesc'
	                            },
	                            {
		                            name:'OrderType'
	                            },
	                            {
		                            name:'OrderTypeName'
	                            },
	                            {
		                            name:'PayType'
	                            },
	                            {
		                            name:'PayTypeName'
	                            },
	                            {
		                            name:'BillMode'
	                            },
	                            {
		                            name:'BillModeName'
	                            },
	                            {
		                            name:'DlvType'
	                            },
	                            {
		                            name:'DlvTypeName'
	                            },
	                            {
		                            name:'DlvLevel'
	                            },
	                            {
		                            name:'DlvLevelName'
	                            },
	                            {
		                            name:'Status'
	                            },
	                            {
		                            name:'StatusName'
	                            },
	                            {
		                            name:'IsPayed'
	                            },
	                            {
		                            name:'IsPayedName'
	                            },
	                            {
		                            name:'IsBill'
	                            },
	                            {
		                            name:'IsBillName'
	                            },
	                            {
		                            name:'SaleInvId'
	                            },
	                            {
		                            name:'SaleTotalQty'
	                            },
	                            {
		                            name:'OutedQty'
	                            },
	                            {
		                            name:'SaleTotalAmt'
	                            },
	                            {
		                            name:'SaleTotalTax'
	                            },
	                            {
		                            name:'DtlCount'
	                            },
	                            {
		                            name:'OperId'
	                            },
	                            {
		                            name:'OperName'
	                            },
	                            {
		                            name:'CreateDate'
	                            },
	                            {
		                            name:'UpdateDate'
	                            },
	                            {
		                            name:'OwnerId'
	                            },
	                            {
		                            name:'OwnerName'
	                            },
	                            {
		                            name:'BizAudit'
	                            },
	                            {
		                            name:'AuditDate'
	                            },
	                            {
		                            name:'Remark'
	                            },
	                            {
		                            name:'IsActive'
	                            },
	                            {
		                            name:'IsActiveName'
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
                            singleSelect: false
                        });
                        var OrderMstGrid = new Ext.grid.GridPanel({
                            el: 'divDataGrid', 
                            height: '100%',
                            autoHeight: true,
                            autoScroll: true,
                            layout: 'fit',
                            id: '',
                            store: OrderMstGridData,
                            loadMask: { msg: '正在加载数据，请稍侯……' },
                            sm: sm,
                            cm: new Ext.grid.ColumnModel([
                            
		                    sm,
		                    new Ext.grid.RowNumberer(),//自动行号
		                    {
			                    header:'订单标识',
			                    dataIndex:'OrderId',
			                    id:'OrderId',
			                    hidden:true,
			                    width:0
		                    },
		                    {
			                    header:'订单编号',
			                    dataIndex:'OrderNumber',
			                    id:'OrderId',
			                    width:80
		                    },
//		                    {
//		                        header:'公司名称',
//			                    dataIndex:'OrgName',
//			                    id:'OrgName'
//		                    },
//		                    {
//		                        header:'销售部门',
//			                    dataIndex:'DeptName',
//			                    id:'DeptName'
//		                    },
		                    {
		                        header:'出库仓库',
			                    dataIndex:'OutStorName',
			                    id:'OutStorName',
			                    width:80
		                    },
		                    {
		                        header:'客户名称',
			                    dataIndex:'CustomerName',
			                    id:'CustomerName',
			                    width:160
		                    },
		                    {
			                    header:'送货日期',
			                    dataIndex:'DlvDate',
			                    id:'DlvDate',
			                    renderer: Ext.util.Format.dateRenderer('Y年m月d日'),
			                    width:85
		                    },
//		                    {
//		                        header:'订单类型',
//			                    dataIndex:'OrderTypeName',
//			                    id:'OrderTypeName',
//			                    width:60
//		                    },
//		                    {
//		                        header:'结算方式',
//			                    dataIndex:'PayTypeName',
//			                    id:'PayTypeName',
//			                    width:60
//		                    },
		                    {
		                        header:'开票方式',
			                    dataIndex:'BillModeName',
			                    id:'BillModeName',
			                    width:60
		                    },
		                    {
		                        header:'配送方式',
			                    dataIndex:'DlvTypeName',
			                    id:'DlvTypeName',
			                    width:60
		                    },
		                    {
		                        header:'是否开票',
			                    dataIndex:'IsBillName',
			                    id:'IsBillName',
			                    width:60
		                    },
		                    {
		                        header:'是否结款',
			                    dataIndex:'IsPayedName',
			                    id:'IsPayedName',
			                    width:60
		                    },
//		                    {
//		                        header:'送货等级',
//			                    dataIndex:'DlvLevelName',
//			                    id:'DlvLevelName',
//			                    width:60,
//			                    hidden:true
//		                    },
//		                    {
//			                    header:'总重量',
//			                    dataIndex:'SaleTotalQty',
//			                    id:'SaleTotalQty',
//			                    width:50
//		                    },
		                    {
			                    header:'总金额',
			                    dataIndex:'SaleTotalAmt',
			                    id:'SaleTotalAmt',
			                    width:50
		                    },
		                    {
		                        header:'操作员',
			                    dataIndex:'OperName',
			                    id:'OperName',
			                    width:60
		                    },
		                    {
			                    header:'创建时间',
			                    dataIndex:'CreateDate',
			                    id:'CreateDate',
			                    renderer: Ext.util.Format.dateRenderer('Y年m月d日'),
			                    width:85
		                    }		]),
                            bbar: new Ext.PagingToolbar({
                                pageSize: 10,
                                store: OrderMstGridData,
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
                            height: 280
//                            closeAction: 'hide',
//                            stripeRows: true,
//                            loadMask: true,
//                            autoExpandColumn: 2
                        });
                        OrderMstGrid.on("afterrender", function(component) {
                            component.getBottomToolbar().refresh.hideParent = true;
                            component.getBottomToolbar().refresh.hide(); 
                        });
                        OrderMstGrid.render();
                        OrderMstGrid.on('rowdblclick', function(grid, rowIndex, e) {
                            //弹出商品明细
                            var _record = OrderMstGrid.getStore().getAt(rowIndex).data.OrderId;
                            if (!_record) {
                                Ext.example.msg('操作', '请选择要查看的记录！');
                            } else {
                                OpenDtlWin(_record);
                            }

                        });
                        /****************************************************************/
                        function OpenDtlWin(orderId) {
                            if (typeof (uploadRouteWindow) == "undefined") {
                                newFormWin = new Ext.Window({
                                    layout: 'fit',
                                    width: 600,
                                    height: 400,
                                    closeAction: 'hide',
                                    plain: true,
                                    constrain: true,
                                    modal: true,
                                    autoDestroy: true,
                                    title: '明细信息',
                                    items: orderDtInfoGrid
                                });
                            }
                            newFormWin.show();
                            //查数据
                            orderDtInfoStore.baseParams.OrderId = orderId;
                            orderDtInfoStore.load({
                                params: {
                                    limit: 10,
                                    start: 0
                                }
                            });
                        }

                        var orderDtInfoStore = new Ext.data.Store
                            ({
                                url: '../../SCM/frmOrderStatistics.aspx?method=getDtlInfo',
                                reader: new Ext.data.JsonReader({
                                    totalProperty: 'totalProperty',
                                    root: 'root'
                                }, [
	                            { name: 'OrderDtlId' },
	                            { name: 'OrderId' },
	                            { name: 'ProductId' },
	                            { name: 'ProductNo' },
	                            { name: 'ProductName' },
	                            { name: 'Specifications' },
	                            { name: 'SpecificationsName' },
	                            { name: 'Unit' },
	                            { name: 'UnitName' },
	                            { name: 'SaleQty' },
	                            { name: 'SalePrice' },
	                            { name: 'SaleAmt' },
	                            { name: 'SaleTax' }
	                            ])
                            });

                        var smDtl = new Ext.grid.CheckboxSelectionModel({
                            singleSelect: true
                        });
                        var orderDtInfoGrid = new Ext.grid.GridPanel({
                            width: '100%',
                            height: '100%',
                            autoWidth: true,
                            autoHeight: true,
                            autoScroll: true,
                            layout: 'fit',
                            id: '',
                            store: orderDtInfoStore,
                            loadMask: { msg: '正在加载数据，请稍侯……' },
                            sm: smDtl,
                            cm: new Ext.grid.ColumnModel([
		                            smDtl,
		                            new Ext.grid.RowNumberer(), //自动行号
		                            {
		                            header: '存货编号',
		                            dataIndex: 'ProductNo',
		                            id: 'ProductNo'
		                        },
		                            {
		                                header: '存货名称',
		                                dataIndex: 'ProductName',
		                                id: 'ProductName',
		                                width: 120
		                            },
		                            {
		                                header: '规格',
		                                dataIndex: 'SpecificationsName',
		                                id: 'SpecificationsName'
		                            },
		                            {
		                                header: '计量单位',
		                                dataIndex: 'UnitName',
		                                id: 'UnitName'
		                            },
		                            {
		                                header: '销售数量',
		                                dataIndex: 'SaleQty',
		                                id: 'SaleQty'
		                            },
		                            {
		                                header: '销售单价',
		                                dataIndex: 'SalePrice',
		                                id: 'SalePrice'
		                            },
		                            {
		                                header: '销售金额',
		                                dataIndex: 'SaleAmt',
		                                id: 'SaleAmt'
		                            },
		                            {
		                                header: '税额',
		                                dataIndex: 'SaleTax',
		                                id: 'SaleTax'
		                            }
		                        ]),
                            bbar: new Ext.PagingToolbar({
                                pageSize: 10,
                                store: orderDtInfoStore,
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
                            height: 280,
                            closeAction: 'hide',
                            stripeRows: true,
                            loadMask: true,
                            autoExpandColumn: 2
                        });
                        /****************************************************************/
                        /*------DataGrid的函数结束 End---------------*/
                        //QueryDataGrid();

                       gs.setValue(<% =ZJSIG.UIProcess.ADM.UIAdmUser.OrgID(this)%>);
                       gs.setDisabled(true);
                       bm.setValue(<% =ZJSIG.UIProcess.ADM.UIAdmUser.DeptID(this)%>);
                       bm.setDisabled(true);
                    })
</script>

</html>
<script type="text/javascript" src="../../js/SelectModule.js"></script>