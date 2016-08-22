<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmFmAccReceCheckDesk.aspx.cs" Inherits="FM_frmFmAccReceCheckDesk" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html>
<head>
<title>订单维护</title><meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<link rel="stylesheet" type="text/css" href="../ext3/resources/css/ext-all.css" />
<link rel="stylesheet" type="text/css" href="../Theme/1/css/salt.css" />
<script type="text/javascript" src="../ext3/adapter/ext/ext-base.js"></script>
<script type="text/javascript" src="../ext3/ext-all.js"></script>
<script type="text/javascript" src="../ext3/example/ItemDeleter.js"></script>
<script type="text/javascript" src="../js/operateResp.js"></script>
<script type="text/javascript" src="../ext3/src/locale/ext-lang-zh_CN.js"></script>
<style type="text/css">
.extensive-remove {
background-image: url(../Theme/1/images/extjs/customer/cross.gif) ! important;
}
.x-grid-back-blue { 
background: #B7CBE8; 
}
.x-grid3-row-alt {
background-color:#CFE8FF
}
</style>
</head>
<body>
<div id='divDataGrid'></div>
<div id='divDoGrid'></div>
<div id='divBotton'></div>
</body>
<%= getComboBoxStore() %>
<script type="text/javascript">
Ext.BLANK_IMAGE_URL = "../ext3/resources/images/default/s.gif";
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
//如果要查找参数key:
var ReceivableIds = args["id"];

Ext.onReady(function() {  

    Ext.form.TextField.prototype.afterRender = Ext.form.TextField.prototype.afterRender.createSequence(function() {
     this.relayEvents(this.el, ['onblur']);
    });
    
    /*------开始获取数据的函数 start---------------*/
    var MstGridData = new Ext.data.Store
    ({
        url: 'frmFmAccReceCheckDesk.aspx?method=getCustomerAccReceList',
        reader: new Ext.data.JsonReader({
            totalProperty: 'totalProperty',
            root: 'root'
        }, [
            { name: "ReceivableId" },
            { name: "BusinessType" },
            { name: "FundType" },
            { name: "CustomerId" },
            { name: "CustomerNo" },
            { name: "CustomerName" },
            { name: "PayType" },
            { name: "Amount" },
            { name: "TotalAmount" },
            { name: "OperId" },
            { name: "Ext1" },
            { name: "Ext2" },
            { name: "Notes" },
            { name: "PayTypeText" },
            { name: "OperName" },
            { name: 'CreateDate' }
          ]),
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
        singleSelect: true
    });
    var MstGrid = new Ext.grid.GridPanel({
        el: 'divDataGrid',
        width:document.body.offsetWidth,
        height: 200,
        columnLines:true,
        autoScroll: true,
        title: '预付款信息',
        id: '',
        store: MstGridData,
        loadMask: { msg: '正在加载数据，请稍侯……' },
        sm: sm,
        cm: new Ext.grid.ColumnModel([
        sm,
        new Ext.grid.RowNumberer(), //自动行号
          {header: "客户ID", dataIndex: 'CustomerId', hidden: true, hideable: false },
          { header: "收款编号", width: 70, sortable: true, dataIndex: 'ReceivableId' },
          { header: "客户编号", width: 80, sortable: true, dataIndex: 'CustomerNo' },
          { header: "客户名称", width: 170, sortable: true, dataIndex: 'CustomerName' },
          { header: "预付金额", width: 75, sortable: true, dataIndex: 'Amount' },
          { header: "未核金额", width: 75, sortable: true, dataIndex: 'Ext1' },
          { header: "是否已全核", width: 50, sortable: true, dataIndex: 'Ext1', renderer:function(v){if(v==0) return '是';else return '否';} },
          { header: "付款类型", width: 70, sortable: true, dataIndex: 'PayTypeText' },
          { header: "操作员", width: 60, sortable: true, dataIndex: 'OperName' },
          { header: "创建时间", width: 110, sortable: true, dataIndex: 'CreateDate', renderer: Ext.util.Format.dateRenderer('Y年m月d日') },
          { header: '备注',width: 100, sortable: true, dataIndex: 'Notes'}

        ]),
        bbar: new Ext.PagingToolbar({
            pageSize: 10,
            store: MstGridData,
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
        closeAction: 'hide',
        stripeRows: true,
        loadMask: true//,
        //autoExpandColumn: 2
    });
    MstGrid.on("afterrender", function(component) {
        component.getBottomToolbar().refresh.hideParent = true;
        component.getBottomToolbar().refresh.hide();
    });
    MstGrid.on("rowdblclick",function(grid, rowIndex, e){
        ModDtlGridData.load({params:{
                ReceivableId:grid.getStore().getAt(rowIndex).data.ReceivableId,
                CustomerId:grid.getStore().getAt(rowIndex).data.CustomerId
            }});
    });
    
    MstGrid.render();
    /*------DataGrid的函数结束 End---------------*/
    /*------开始获取数据的函数 start---------------*/
        var ModDtlGridData = new Ext.data.Store
        ({
            url: 'frmFmAccReceCheckDesk.aspx?method=getAccountNoneReceDtl',
            timeout:300000,
            reader: new Ext.data.JsonReader({
                totalProperty: 'totalProperty',
                root: 'root'
            }, [
                { name: 'OrderDtlId' },
                { name: 'OrderId' },
                { name: 'ProductId' },
                { name: 'ProductNo' },
                { name: 'ProductName' },
                { name: 'SpecificationsName' },
                { name: 'UnitName' },
                { name: 'SaleQty' },
                { name: 'SalePrice' },
                { name: 'SaleAmt' },
                { name: 'SaleTax' },
                { name: 'OutStorname' },
                { name: 'WhpId' },
                { name: 'Ext1' },
                { name: 'Ext2' },
                { name: 'TaxRate' },
                { name: 'SaleInvId' },
                { name: 'DiscountRate' },
                { name: 'DiscountAmt' },
                { name: 'TransFee' },
                { name: 'OrgId' },
                { name: 'CheckNum' },
                { name: 'CheckOldAmt' },
                { name: 'CheckAmt' },
                { name: 'SaleCheckId' },
                { name: 'SaleCheckDtlId' },
                { name: 'ObjectId' },
                { name: 'OrderNumber' },
                { name: 'CheckPrice' },
                { name: 'OperName' }
                ]),
                listeners:
	            {
	                scope: this,
	                load: function() {
	                }
	            }
        });

        /*------获取数据的函数 结束 End---------------*/
        function accD(arg1,arg2,pos)
        {
            //Math.round(src*Math.pow(10, pos))/Math.pow(10, pos);
            //解决浮点问题
            m = 0;
            s1=arg1.toString();
            s2=arg2.toString();
            try{m+=s1.split(".")[1].length}catch(e){}
            try{m-=s2.split(".")[1].length}catch(e){}
            var num = Number(s1.replace(".",""))/Number(s2.replace(".",""))/Math.pow(10,m);
            return Math.round(num * Math.pow(10,pos))/Math.pow(10,pos);
        }
        function accAdd(arg1,arg2){  
            var r1,r2,m;  
            try{r1=arg1.toString().split(".")[1].length}catch(e){r1=0}  
            try{r2=arg2.toString().split(".")[1].length}catch(e){r2=0}  
            m=Math.pow(10,Math.max(r1,r2))  
            return (arg1*m+arg2*m)/m  
        }  
        function accMul(arg1,arg2)
        {
            try
            {
            //解决浮点问题
            var m=0,s1=arg1.toString(),s2=arg2.toString();
            try{m+=s1.split(".")[1].length}catch(e){}
            try{m+=s2.split(".")[1].length}catch(e){}
            return Number(s1.replace(".",""))*Number(s2.replace(".",""))/Math.pow(10,m);
            }
            catch(err)
            {
                return 0;
            }
        }
        function accDiv(arg1,arg2){  
            var t1=0,t2=0,r1,r2;  
            try{t1=arg1.toString().split(".")[1].length}catch(e){}  
            try{t2=arg2.toString().split(".")[1].length}catch(e){}  
            with(Math){  
                r1=Number(arg1.toString().replace(".",""))  
                r2=Number(arg2.toString().replace(".",""))  
                return (r1/r2)*pow(10,t2-t1);  
            }  
        } 
        /*------开始DataGrid的函数 start---------------*/
        var selectRecord = null;
        var sm = new Ext.grid.CheckboxSelectionModel({
            singleSelect: true
        });
        var ModOrderDtlGrid = new Ext.grid.EditorGridPanel({
            autoScroll: true,
            height:200,
            //autoHeight: true,
            clicksToEdit: 1,
            columnLines:true,
            width: document.body.offsetWidth,
            el:'divDoGrid',
            store: ModDtlGridData,
            //title:'订单明细信息',
            loadMask: { msg: '正在加载数据，请稍侯……' },
            sm: sm,
            cm: new Ext.grid.ColumnModel([
                sm,
                new Ext.grid.RowNumberer(), //自动行号
                {
                    header: '订单编号',
                    dataIndex: 'OrderNumber',
                    id: 'OrderNumber',
                    width:85
                },
                {
                    header: '产品编号',
                    dataIndex: 'ProductNo',
                    id: 'ProductNo',
                    width:55
                },
                {
                    header: '产品名称',
                    dataIndex: 'ProductName',
                    id: 'ProductName',
                    width:120
                },
                {
                    header: '规格',
                    dataIndex: 'SpecificationsName',
                    id: 'SpecificationsName',
                    width:40
                },
                {
                    header: '数量',
                    dataIndex: 'SaleQty',
                    id: 'SaleQty',
                    align: 'right',
                    width:55
                },
                {
                    header: '单位',
                    dataIndex: 'UnitName',
                    id: 'UnitName',
                    width:40
                },
                {
                    header: '单价',
                    dataIndex: 'SalePrice',
                    id: 'SalePrice',
                    align: 'right',
                    width:50
                },
                {
                    header: '金额',
                    dataIndex: 'SaleAmt',
                    id: 'SaleAmt',
                    align: 'right',
                    width:60
                },
//                {
//                    header: '运费',
//                    dataIndex: 'TransFee',
//                    id: 'TransFee',
//                    align: 'right',
//                    width:40
//                },
//                {
//                    header: '折扣',
//                    dataIndex: 'DiscountAmt',
//                    id: 'DiscountAmt',
//                    align: 'right',
//                    width:40
//                },
                {
                    header: '已核金额',
                    dataIndex: 'CheckOldAmt',
                    id: 'CheckOldAmt',
                    align: 'right',
                    width:60
                },
                {
                    header: '核销金额',
                    dataIndex: 'CheckAmt',
                    id: 'CheckAmt',
                    width:60,
                    align: 'right',
                    editor: new Ext.form.NumberField({ 
	                    allowBlank: false,
	                    align: 'right',
	                    decimalPrecision:6,
	                    enableKeyEvents: true,
	                    listeners: {  
    	                    'focus':function(){  
        		                this.selectText();
        		                selectRecord = ModOrderDtlGrid.getSelectionModel().getSelected(); 
    	                    },
        	                 'change': function(oppt,newv,oldv){
        	                    var record = selectRecord;
        	                    //record.set('SaleAmt', accMul(oppt.value , accAdd(record.data.SalePrice,record.data.TransFee)).toFixed(2));
                                //record.set('SaleTax', accMul(accDiv(record.data.SaleAmt,accAdd(1,record.data.Tax)) ,record.data.Tax).toFixed(2) ); //Math.Round(3.445, 1); 
                                var needcheckamt=accAdd(record.data.SaleAmt, - record.data.CheckOldAmt); 
                                var newval = newv;
                                if(newv > needcheckamt){
                                    newval = needcheckamt;
                                }
                                
                                var amt=0;var totalamt=0;
                                for(var i=0;i<MstGridData.getCount();i++){
                                    amt =  MstGridData.getAt(i).data.Ext1;  
                                    totalamt = accAdd(amt,oldv); 
                                    if(newval >totalamt){
                                        oppt.setValue(totalamt);
                                        record.set('CheckAmt',totalamt);
                                        MstGrid.getStore().getAt(i).set('Ext1',0);
                                        break;
                                    }else{
                                        amt = accAdd(totalamt,-newval);
                                        oppt.setValue(newval);
                                        record.set('CheckAmt',newval);
                                        MstGrid.getStore().getAt(i).set('Ext1',amt);
                                        break;
                                    }        
                                }
                                selectRecord = null;    
		                        ModOrderDtlGrid.getSelectionModel().selectNext(false);                           
        	                }
		                }
		            }),
	                renderer: function(v, m) {
                        m.css = 'x-grid-back-blue';
                        return v;
                    }
                },
                {
                    header: '操作员',
                    dataIndex: 'OperName',
                    id: 'OperName',
                    width:60
                },
                {
                    header: '仓库名称',
                    dataIndex: 'OutStorname',
                    id: 'OutStorname',
                    width:100
                },
                {
                    header: 'savedtlid',
                    dataIndex: 'SaleCheckDtlId',
                    id: 'SaleCheckDtlId',
                    hidden:true,
                    hideable:true
                },
                {
                    header: 'saveid',
                    dataIndex: 'SaleCheckId',
                    id: 'SaleCheckId',
                    hidden:true,
                    hideable:true
                }

                ]),
            viewConfig: {
                columnsText: '显示的列',
                scrollOffset: 20,
                sortAscText: '升序',
                sortDescText: '降序',
                forceFit: false
            },
            tbar: [{
                id: 'btnALC',
                text: '自动计算',
                iconCls: 'add',
                icon:'../Theme/1/images/extjs/customer/edit16.gif',
                handler: function() {     
                    
                    for(var j=0;j<ModDtlGridData.getCount();j++){  
                        if( ModDtlGridData.getAt(j).data.CheckAmt>0)
                            ModOrderDtlGrid.getStore().getAt(j).set('CheckAmt',0);
                    }      
                    MstGridData.reload({
                        callback: function(r, options, success) {
                            if (Ext.getCmp('btnALC').text=='自动计算') 
                            {                        
                                var amt=0;var tempamt=0;
                                for(var i=0;i<MstGridData.getCount();i++){
                                    amt =  MstGridData.getAt(i).data.Ext1;
                                    for(var j=0;j<ModDtlGridData.getCount();j++){                                
                                        tempamt = ModDtlGridData.getAt(j).data.SaleAmt
                                                - ModDtlGridData.getAt(j).data.CheckOldAmt;
                                        if(tempamt>amt)
                                        {
                                            ModOrderDtlGrid.getStore().getAt(j).set('CheckAmt',amt);
                                            MstGrid.getStore().getAt(i).set('Ext1',0);
                                            amt=0;
                                            break;
                                        }
                                        else
                                        {
                                            ModOrderDtlGrid.getStore().getAt(j).set('CheckAmt',tempamt);
                                            amt = amt - tempamt;
                                            MstGrid.getStore().getAt(i).set('Ext1',amt);
                                        }
                                    }
                                }
                                Ext.getCmp('btnALC').setText('取消计算');
                            }else{                        
                                Ext.getCmp('btnALC').setText('自动计算');
                            } 
                        }
                    });                           
                }
            }],
            closeAction: 'hide',
            stripeRows: true,
            loadMask: true//,
            //autoExpandColumn: 2

        });
        ModOrderDtlGrid.render();
        ModOrderDtlGrid.on('rowclick', function(grid, rowIndex, e) {
            ModOrderDtlGrid.getSelectionModel().selectRow(rowIndex,false);
        });
    /*----------------footerframe----------------*/
    //将grid明细记录组装成json串提交到UI再decode
    var json = '';
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
                ModDtlGridData.each(function(vc) {
                    if(vc.data.CheckAmt>0||(vc.data.CheckAmt==0&&vc.data.SaleAmt==0)){//全赠送
                        json += Ext.util.JSON.encode(vc.data) + ',';
                    }
                });
               
                Ext.MessageBox.wait("数据正在保存，请稍候……");
                //然后传入参数保存
                Ext.Ajax.request({
                    url: 'frmFmAccReceCheckDesk.aspx?method=saveCheckData',
                    method: 'POST',
                    params: {
                        //主参数
                        ReceivableId:ReceivableIds,
			            CustomerId:MstGridData.getAt(0).data.CustomerId,
                        //明细参数
                        DetailInfo: json
                    },
                    success: function(resp,opts){ 
                        Ext.MessageBox.hide();
                        if( checkParentExtMessage(resp,parent) )
                             {
                               parent.MstGridData.reload();
                               parent.ModDtlGridData.reload();
                               parent.uploadOrderWindow.hide();  
                             }
                       },
		            failure: function(resp,opts){  
		                Ext.MessageBox.hide();
		                Ext.Msg.alert("提示","保存失败");     
		            }
                });
            }
        },{
             text: "取消",
             scope: this,
             handler: function() {
                 parent.uploadOrderWindow.hide();
             }
        }]
    });    
    
    if(ReceivableIds!=""){
        //加载
        MstGridData.load({params:{ReceivableIds:ReceivableIds}});
    }
});
</script>
</html>
