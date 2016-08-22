<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmBillManage.aspx.cs" Inherits="SCM_frmBillManage" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html>
<head>
<title>发票管理</title><meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<link rel="stylesheet" type="text/css" href="../ext3/resources/css/ext-all.css" />
<script type="text/javascript" src="../ext3/adapter/ext/ext-base.js"></script>
<script type="text/javascript" src="../ext3/ext-all.js"></script>
<link rel="stylesheet" type="text/css" href="../ext3/example/file-upload.css" />
<script type="text/javascript" src="../ext3/example/FileUploadField.js"></script>
<script type="text/javascript" src="../ext3/src/locale/ext-lang-zh_CN.js"></script>
<script type="text/javascript" src="../js/operateResp.js"></script>
<script type="text/javascript" src="../js/common.js"></script>
</head>
<body>
<div id='toolbar'></div>
<div id='divSearchForm'></div>
<div id='divDataGrid'></div>
<div id='divDataDtlGrid'></div>
</body>
<%=getComboBoxStore()%>
<script type="text/javascript">
Ext.BLANK_IMAGE_URL = "../ext3/resources/images/default/s.gif"; 
    Ext.onReady(function() {
    
        /*------实现toolbar的函数 start---------------*/
        var Toolbar = new Ext.Toolbar({
            renderTo: "toolbar",
            items: [{
                text: "导出",
                icon: "../Theme/1/images/extjs/customer/edit16.gif",
                handler: function() { exportData()  }
            }, '-',{
                text: "导入",
                icon: "../Theme/1/images/extjs/customer/add16.gif",
                handler: function() { importData()    }
            }, '-',{
                text: "调整",
                icon: "../Theme/1/images/extjs/customer/edit16.gif",
                handler: function() { editData()    }
            }, '-',{
                text: "作废",
                icon: "../Theme/1/images/extjs/customer/cross.gif",
                handler: function() { discardData()    }
            }, '-',{
                text: "冲红",
                icon: "../Theme/1/images/extjs/customer/s_delete.gif",
                handler: function() { rollData()    }
            }, '-',{
                text: "明细打印",
                icon: "../Theme/1/images/extjs/customer/edit16.gif",
                handler: function() { printOrderById()    }
            }]
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
                    orderIds += selectData[i].get('BillId');
                }
                Ext.Ajax.request({
                    url: 'frmBillManage.aspx?method=printdata',
                    method: 'POST',
                    params: {
                        BillId: orderIds
                    },
                   success: function(resp,opts){ 
                       var printData =  resp.responseText;
                       var printControl =  parent.parent.parent.document.getElementById("topFrame").contentWindow.getPrintControl();
                       printControl.Url =getUrl('xml');
                       printControl.MapUrl = printControl.Url+'/'+'billprint.xml';//'/salePrint1.xml';
                       printControl.PrintXml = printData;
                       printControl.ColumnName="BillId";
                       printControl.OnlyData=false;
                       printControl.PageWidth=819;
                       printControl.PageHeight =1158;
                       printControl.Print();
                       
                   },
                   failure: function(resp,opts){  /* Ext.Msg.alert("提示","保存失败"); */    }
                });
            }

            function QueryDataGrid() {
                OrderMstGridData.baseParams.OrgId = Ext.getCmp('OrgId').getValue();            
                OrderMstGridData.baseParams.CustomerId = Ext.getCmp('CustomerId').getValue();
                OrderMstGridData.baseParams.BillMode = Ext.getCmp('BillMode').getValue();	
                OrderMstGridData.baseParams.StartDate = Ext.util.Format.date(Ext.getCmp('StartDate').getValue(),'Y/m/d');
                OrderMstGridData.baseParams.EndDate =  Ext.util.Format.date(Ext.getCmp('EndDate').getValue(),'Y/m/d');
                OrderMstGridData.baseParams.IsActive = Ext.getCmp('BillStatus').getValue();
                OrderMstGridData.baseParams.BillNo = Ext.getCmp('SBillNo').getValue();
                
                OrderMstGridData.load({
                    params: {
                        start: 0,
                        limit: defaultPageSize
                    }
                });
            }
            
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
                   editable:true
               });
               //状态
                var fpzt = new Ext.form.ComboBox({
                   xtype: 'combo',
                   store: [[1,"正常"],[0,"作废"]],
                   valueField: 'DicsCode',
                   displayField: 'DicsName',
                   mode: 'local',
                   forceSelection: true,
                   editable: false,
                   emptyValue: '',
                   triggerAction: 'all',
                   fieldLabel: '发票状态',
                   name:'BillStatus',
                   id:'BillStatus',
                   selectOnFocus: true,
                   anchor: '90%',
                   editable:true
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
                    mode:'local',        //这个属性设定从本页获取数据源，才能够赋值定位
                    editable:false
               })
                              
               var serchform = new Ext.FormPanel({
                    renderTo: 'divSearchForm',
                    labelAlign: 'left',
                    buttonAlign: 'right',
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
			                columnWidth:0.3,
			                items: [gs]
		                }
                ,		{
			                layout:'form',
			                border: false,
			                columnWidth:0.3,
			                items: [
				                {
					                xtype:'textfield',
					                fieldLabel:'客户',
					                columnWidth:0.33,
					                anchor:'90%',
					                name:'CustomerId',
					                id:'CustomerId'
				                }
		                            ]
		                }
                ,		{
			                layout:'form',
			                border: false,
			                columnWidth:0.2,
			                items: [kpfs]
		                }
                ,		{
			                layout:'form',
			                border: false,
			                columnWidth:0.2,
			                items: [fpzt]
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
			                items: [
				                {
					                xtype:'datefield',
					                fieldLabel:'开始日期',
					                columnWidth:0.5,
					                anchor:'90%',
					                name:'StartDate',
					                id:'StartDate',
					                value:new Date().getFirstDateOfMonth().clearTime(),
					                format:'Y年m月d日'
				                }
		                            ]
		                }
                ,		{
			                layout:'form',
			                border: false,
			                columnWidth:0.3,
			                items: [
				                {
					                xtype:'datefield',
					                fieldLabel:'结束日期',
					                columnWidth:0.5,
					                anchor:'90%',
					                name:'EndDate',
					                id:'EndDate',
					                value:new Date(),
					                format:'Y年m月d日'
				                }
		                            ]
		                } 
                ,		{
			                layout:'form',
			                border: false,
			                columnWidth:0.2,
			                items: [
				                {
					                xtype:'textfield',
					                fieldLabel:'发票号码',
					                columnWidth:0.33,
					                anchor:'90%',
					                name:'SBillNo',
					                id:'SBillNo'
				                }
		                            ]
		                }
		          ,		{
			                layout:'form',
			                border: false,
			                columnWidth:0.15,
			                 items: [{
				                    cls: 'key',
                                    xtype: 'button',
                                    text: '查询',
                                    buttonAlign:'right',
                                    id: 'searchebtnId',
                                    anchor: '25%',
                                    handler: function() {QueryDataGrid();}
				                }]
			                
		                }
		         
	                ]}                  
                ]});


                        /*------开始获取数据的函数 start---------------*/
                        var OrderMstGridData = new Ext.data.Store
                        ({
                            url: 'frmBillManage.aspx?method=getBillList',
                            reader: new Ext.data.JsonReader({
                                totalProperty: 'totalProperty',
                                root: 'root'
                            }, [
                                {  name:'BillId' },
                                {  name:'OrgId' },
                                { name:'CustomerId' },
                                { name:'CustomerNo' },
                                { name:'CustomerName' },
                                { name:'BillMode' },
                                { name:'AccountType' },
                                { name:'BillCode' },
                                { name:'BillNo' },
                                { name:'CreateId' },
                                { name:'PayId' },
                                { name:'CheckId' },
                                { name:'TransStatus' },
                                { name:'OperId' },
                                { name:'CreateDate' },
                                { name:'UpdateDate' },
                                { name:'OwnerId' },
                                { name:'Remark' },
                                { name:'IsActive' },
                                { name:'BillAmt' },
                                { name:'BillTax' }
	                             ])
	                         
	            ,
                listeners:
	            {
	                scope: this,
	                load: function() {
	                }
	            }
            });

                        /*------获取数据的函数 结束 End---------------*/
                        var defaultPageSize = 10;
                            var toolBar = new Ext.PagingToolbar({
                                pageSize: 10,
                                store: OrderMstGridData,
                                displayMsg: '显示第{0}条到{1}条记录,共{2}条',
                                emptyMsy: '没有记录',
                                displayInfo: true
                            });
                            var pageSizestore = new Ext.data.SimpleStore({
                                fields: ['pageSize'],
                                data: [[10], [20], [30]]
                            });
                            var combo = new Ext.form.ComboBox({
                                regex: /^\d*$/,
                                store: pageSizestore,
                                displayField: 'pageSize',
                                typeAhead: true,
                                mode: 'local',
                                emptyText: '更改每页记录数',
                                triggerAction: 'all',
                                selectOnFocus: true,
                                width: 135
                            });
                            toolBar.addField(combo);

                            combo.on("change", function(c, value) {
                                toolBar.pageSize = value;
                                defaultPageSize = toolBar.pageSize;
                            }, toolBar);
                            combo.on("select", function(c, record) {
                                toolBar.pageSize = parseInt(record.get("pageSize"));
                                defaultPageSize = toolBar.pageSize;
                                QueryDataGrid();
                            }, toolBar);
                        /*------开始DataGrid的函数 start---------------*/

                        var sm = new Ext.grid.CheckboxSelectionModel({
                            singleSelect: false
                        });
                        var OrderMstGrid = new Ext.grid.GridPanel({
                            el: 'divDataGrid',
                            //width: '100%',
                            //height: '100%',
                            //autoWidth: true,
                            //autoHeight: true,
                            autoScroll: true,
                            layout: 'fit',
                            title: '发票信息',
                            store: OrderMstGridData,
                            loadMask: { msg: '正在加载数据，请稍侯……' },
                            sm: sm,
                            cm: new Ext.grid.ColumnModel([
                            
		                    sm,
		                    new Ext.grid.RowNumberer(),//自动行号
		                    {
			                    header:'标识',
			                    dataIndex:'BillId',
			                    id:'BillId',
			                    width:80
		                    },
		                    {
			                    header:'发票号码',
			                    dataIndex:'BillNo',
			                    id:'BillNo',
			                    width:100
		                    },
		                    {
		                        header:'客户标识',
			                    dataIndex:'CustomerId',
			                    id:'CustomerId',
			                    hidden:true,
			                    hideable:true
		                    },
		                    {
		                        header:'客户编号',
			                    dataIndex:'CustomerNo',
			                    id:'CustomerNo',
			                    width:80
		                    },
		                    {
		                        header:'客户名称',
			                    dataIndex:'CustomerName',
			                    id:'CustomerName',
			                    width:160
		                    },
		                    {
			                    header:'发票类型',
			                    dataIndex:'BillMode',
			                    id:'BillMode',
			                    width:70,
		                        renderer:{
		                            fn:function(val, params, record) {
	                                if (dsPayType.getCount() == 0) {
	                                    dsPayType.load();
	                                }
	                                dsPayType.each(function(r) {
	                                    if (val == r.data['DicsCode']) {
	                                        val = r.data['DicsName'];
	                                        return;
	                                    }
	                                });
	                                return val;
	                              }
		                        }
		                    },
		                    {
		                        header:'收款方式',
			                    dataIndex:'AccountType',
			                    id:'AccountType',
			                    width:60,
		                        renderer:{
		                            fn:function(val, params, record) {
	                                if (dsAcctType.getCount() == 0) {
	                                    dsAcctType.load();
	                                }
	                                dsAcctType.each(function(r) {
	                                    if (val == r.data['DicsCode']) {
	                                        val = r.data['DicsName'];
	                                        return;
	                                    }
	                                });
	                                return val;
	                              }
		                        }
		                    },
		                    {
		                        header:'传输状态',
			                    dataIndex:'TransStatus',
			                    id:'TransStatus',
			                    width:60,
			                    renderer:{
			                        fn:function(v){
			                            if(v=='1') return '生成';
			                            if(v=='2') return '正常已发';
			                            if(v=='3') return '正常已收';
			                        }
			                    }
		                    },
		                    {
		                        header:'状态',
			                    dataIndex:'IsActive',
			                    id:'IsActive',
			                    width:60,
			                    renderer:{
			                        fn:function(v){
			                            if(v=='1') return '有效';
			                            if(v=='0') return '作废';
			                        }
			                    }
		                    },
		                    {
		                        header:'操作员',
			                    dataIndex:'OperId',
			                    id:'OperId',
			                    width:60,
		                        renderer:{
		                            fn:function(val, params, record) {
	                                if (dsUser.getCount() == 0) {
	                                    dsUser.load();
	                                }
	                                dsUser.each(function(r) {
	                                    if (val == r.data['EmpId']) {
	                                        val = r.data['EmpName'];
	                                        return;
	                                    }
	                                });
	                                return val;
	                              }
		                        }
		                    },
		                    {
			                    header:'创建时间',
			                    dataIndex:'CreateDate',
			                    id:'CreateDate',
			                    renderer: Ext.util.Format.dateRenderer('Y年m月d日'),
			                    width:90
		                    },
		                    {
		                        header:'金额',
			                    dataIndex:'BillAmt',
			                    id:'BillAmt',
			                    width:80
		                    },
		                    {
		                        header:'税额',
			                    dataIndex:'BillTax',
			                    id:'BillTax',
			                    width:80
		                    },
		                    {
		                        header:'备注',
			                    dataIndex:'Remark',
			                    id:'Remark',
			                    width:150
		                    }		]),
                            bbar: toolBar,
                            viewConfig: {
                                columnsText: '显示的列',
                                scrollOffset: 20,
                                sortAscText: '升序',
                                sortDescText: '降序',
                                forceFit: false
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
                        OrderMstGridData.on('beforeload', function(store){
                            billDtInfoStore.removeAll();
                        });
                        OrderMstGrid.on('rowdblclick', function(grid, rowIndex, e) {
                            //弹出商品明细
                            var _record = OrderMstGrid.getStore().getAt(rowIndex).data.BillId;
                            if (!_record) {
                                Ext.example.msg('操作', '请选择要查看的记录！');
                            } else {
                                billDtInfoStore.baseParams.BillId = _record;
                                billDtInfoStore.load({
                                    params: {
                                        limit: 100,
                                        start: 0
                                    }
                                });
                            }

                        });
                        /*------DataGrid的函数结束 End---------------*/
                        /****************************************************************/                        
                        var billDtInfoStore = new Ext.data.Store
                            ({
                                url: 'frmBillManage.aspx?method=getBillDtlInfo',
                                reader: new Ext.data.JsonReader({
                                    totalProperty: 'totalProperty',
                                    root: 'root'
                                }, [
	                            { name: 'BillDtlId' },
	                            { name: 'BillId' },
	                            { name: 'ProductId' },
	                            { name: 'ProductNo' },
	                            { name: 'ProductName' },
	                            { name: 'Specifications' },
	                            { name: 'SpecName'},
	                            { name: 'Unit' },
	                            { name: 'UnitName' },
	                            { name: 'Qty' },
	                            { name: 'Price' },
	                            { name: 'Rate' },
	                            { name: 'Amt' },
	                            { name: 'Tax' },
	                            { name: 'Discount' }
	                            ])
                            });

                        var smDtl = new Ext.grid.CheckboxSelectionModel({
                            singleSelect: true
                        });
                        var billDtInfoGrid = new Ext.grid.GridPanel({
                            width: '100%',
                            height: '100%',
                            //autoWidth: true,
                            autoHeight: true,
                            autoScroll: true,
                            layout: 'fit',
                            el: 'divDataDtlGrid',
                            title: '发票明细信息',
                            store: billDtInfoStore,
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
		                                dataIndex: 'SpecName',
		                                id: 'SpecName'
		                            },
		                            {
		                                header: '计量单位',
		                                dataIndex: 'UnitName',
		                                id: 'UnitName'
		                            },
		                            {
		                                header: '销售数量',
		                                dataIndex: 'Qty',
		                                id: 'Qty'
		                            },
		                            {
		                                header: '销售单价',
		                                dataIndex: 'Price',
		                                id: 'Price'
		                            },
		                            {
		                                header: '销售金额',
		                                dataIndex: 'Amt',
		                                id: 'Amt'
		                            },
		                            {
		                                header: '折扣',
		                                dataIndex: 'Discount',
		                                id: 'Discount'
		                            },
		                            {
		                                header: '税率',
		                                dataIndex: 'Rate',
		                                id: 'Rate'
		                            },
		                            {
		                                header: '税额',
		                                dataIndex: 'Tax',
		                                id: 'Tax'
		                            }
		                        ]),
                            bbar: new Ext.PagingToolbar({
                                pageSize: 10,
                                store: billDtInfoStore,
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
                            height: 150,
                            closeAction: 'hide',
                            stripeRows: true,
                            loadMask: true//,
                            //autoExpandColumn: 2
                        });
                        billDtInfoGrid.render();
                        /****************************************************************/
                         
        
                       gs.setValue(<% =ZJSIG.UIProcess.ADM.UIAdmUser.OrgID(this)%>);
                       gs.setDisabled(true);
//------------------------------------------
function exportData(){
    
    Ext.MessageBox.wait("数据正在处理，请稍候……");
    var sm = OrderMstGrid.getSelectionModel();
	//获取选择的数据信息
	var selectData =  sm.getSelections();
	//如果没有选择，就提示需要选择数据信息
	if(selectData == null || selectData == "") {
	    Ext.MessageBox.hide();
		Ext.Msg.alert("提示","请选择需要导出的记录！");
		return;
    }
    
    var json = "";
    for(var i=0;i<selectData.length;i++)
    {
        json += selectData[i].data.BillId + ',';
    }    
    json = json.substring(0,json.length-1);
    //alert(json);   
    
    //check
    Ext.Ajax.request({   
        url: 'frmBillManage.aspx?method=checkBillData',
        method: 'POST',           
        params: {
            BillId: json//传入多项的id串
        },
        success: function(resp, opts) {
            Ext.MessageBox.hide();
            var resu = Ext.decode(resp.responseText); 
            if (resu.success==true) {
                //Ext.Msg.wait("导出中....","提示");
                if (!Ext.fly('test'))   
                {   
                    var frm = document.createElement('form');   
                    frm.id = 'test';   
                    frm.name = 'test';   
                    //frm.style.display = 'none';   
                    frm.className = 'x-hidden'; 
                    document.body.appendChild(frm);   
                }  
                 
                Ext.Ajax.request({   
                    url: 'frmBillManage.aspx?method=exportData', 
                    form: Ext.fly('test'),   
                    method: 'POST',     
                    isUpload: true,          
                    params: {
                        BillId: json//传入多项的id串
                    },
                    success: function(resp, opts) {
                        //Ext.Msg.hide();
                    },
                    failure: function(resp, opts) {
                         //Ext.Msg.hide();
                    }
                });                  
            }else{
                Ext.Msg.alert('提示消息',resu.errorinfo);
            }

        }, 
        failure: function(resp, opts) {
             Ext.MessageBox.hide();
         }
    });  
}

    if (typeof (fileWindow) == "undefined"){
        fileWindow = new Ext.Window({
            id: 'upl',
            title: "文件选择框"
	        , iconCls: 'upload-win'
	        , width: 400
	        , height: 200
	        , plain: true
	        , modal: true
	        , constrain: true
	        , resizable: false
	        , closeAction: 'hide'
	        , autoScroll:true
	        , autoDestroy: true
	        , html: '<iframe id="uploadIFrame" width="100%" height="80%" border=0 src=""></iframe>' 	        	        
        });
        fileWindow.addListener("hide", function() {
        });
    }
   
function importData(){  
    fileWindow.show();
    if(document.getElementById("uploadIFrame").src.indexOf("frmUpLoadFile")==-1)
    {               
        document.getElementById("uploadIFrame").src = "/Common/frmUpLoadFile.aspx?docType=bill" ;
    } 
}
function discardData()
{
    Ext.MessageBox.wait("数据正在处理，请稍候……");
    var sm = OrderMstGrid.getSelectionModel();
	//获取选择的数据信息
	var selectData =  sm.getSelections();
	//如果没有选择，就提示需要选择数据信息
	if(selectData == null || selectData == "") {
	    Ext.MessageBox.hide();
		Ext.Msg.alert("提示","请选择需要作废的记录！");
		return;
    }
    
    var json = "";
    for(var i=0;i<selectData.length;i++)
    {
        json = selectData[i].data.BillId + ',';
    }    
    json = json.substring(0,json.length-1);
    //alert(json);   
    
    //check
    Ext.Ajax.request({   
        url: 'frmBillManage.aspx?method=discardBillData',
        method: 'POST',           
        params: {
            BillId: json//传入多项的id串
        },
        success: function(resp, opts) {
            Ext.MessageBox.hide();
            if( checkExtMessage(resp) )
            {
                QueryDataGrid();
            }
        }, 
        failure: function(resp, opts) {
             Ext.MessageBox.hide();
         }
    });  
}
function rollData(){
    var sm = OrderMstGrid.getSelectionModel();
    //获取选择的数据信息
    var selectData =  sm.getSelections();
    //如果没有选择，就提示需要选择数据信息
    if(selectData == null || selectData == "") {
        Ext.MessageBox.hide();
        Ext.Msg.alert("提示","请选择需要冲红的发票记录！");
        return;
    }
    if (selectData.length != 1) {
        Ext.Msg.alert("提示", "请选中一条需要冲红的发票记录！");
        return;
    }
    Ext.Msg.confirm("提示信息", "是否真的要将选择的发票记录全部冲红？", function callBack(id) {
        //判断是否删除数据
        if (id == "yes") {                                  
            ExtJsCustom(selectData[0].data.BillId,selectData[0].data.BillMode);                  
        }
    });    
}
function ExtJsCustom(billId,billMode){  
var config ={  
    title:"发票冲红",  
    msg:"请输入发票通知单号",  
    width:400,  
    multiline:true,  
    closable:true,  
    buttons:Ext.MessageBox.OKCANCEL,  
    icon:Ext.MessageBox.QUESTION,  
    fn:  function(btn,text){  
        if(btn=='yes'){
            //check
            if(billMode=='S032'){
                if(strLen(text)!=16){
                    Ext.Msg.alert("提示", "输入增值税专用发票通知单号有误，请检查！");
                    return;  
                }
            }
            Ext.MessageBox.wait("数据正在处理，请稍候……");
            Ext.Ajax.request({   
                url: 'frmBillManage.aspx?method=rollBillData',
                method: 'POST',           
                params: {
                    BillId: billId,//传入多项的id串
                    NoticeNo:text
                },
                success: function(resp, opts) {
                    Ext.MessageBox.hide();
                    if( checkExtMessage(resp) )
                    {
                        QueryDataGrid();
                    }
                }, 
                failure: function(resp, opts) {
                     Ext.MessageBox.hide();
                 }
            });
        }
        //Ext.MessageBox.alert("Result","你点击了'"+btn+"'按钮<br>,输入的值是："+txt); 
    }
    };  
 Ext.MessageBox.show(config);  
}
//------------------------------------------
var winbillEdit = null;
var adjustInfoFrom  = new Ext.FormPanel({
    labelAlign: 'left',
    buttonAlign: 'right',
    bodyStyle: 'padding:5px',
    //width:700,
    //height:450,
    frame: true,
    labelWidth: 70,
    autoDestroy: true,
    items:
    [{
        layout: 'column',   //定义该元素为布局为列布局方式
        border: false,
        items:
        [{//第一行开始
            columnWidth: 1,  //该列占用的宽度，标识为50％
            layout: 'form',
            border: false,
            items: 
            [{
                cls: 'key',
                xtype: 'textfield',
                fieldLabel: 'billid',
                name: 'billid',
                id: 'billid',
                anchor: '90%',
                vtype: 'alphanum', //只能输入字母和数字，无法输入其他
                vtypeText: '只能输入字母和数字',
                hidden: true,
                hideLabel: true
            },
            {
                cls: 'key',
                xtype: 'textfield',
                fieldLabel: '<b>客户名称*</b>',
                name: 'CustomerName',
                id: 'CustomerName',
                anchor: '98%'
            }]
        }]
    },
    {
        layout: 'column',   //定义该元素为布局为列布局方式
        border: false,
        items:
        [{
            columnWidth: .5,  //该列占用的宽度，标识为50％
            layout: 'form',
            border: false,
            items: [{
                cls: 'key',
                xtype: 'combo',
                store: dsPayType,
                valueField: 'DicsCode',
                displayField: 'DicsName',
                mode: 'local',
                emptyValue: '',
                triggerAction: 'all',
                fieldLabel: '<b>发票类型*</b>',
                name: 'BillType',
                id: 'BillType',
                selectOnFocus: true,
                anchor: '98%',
                editable: false
            }]
        },{
            columnWidth: .5,  //该列占用的宽度，标识为50％
            layout: 'form',
            border: false,
            items: [{//第二行第一列
                cls: 'key',
                xtype: 'combo',
                store: dsAcctType,
                valueField: 'DicsCode',
                displayField: 'DicsName',
                mode: 'local',
                emptyValue: '',
                triggerAction: 'all',
                fieldLabel: '<b>收款方式*</b>',
                name: 'AcctType',
                id: 'AcctType',
                selectOnFocus: true,
                anchor: '98%',
                editable: false
			                            
            }]
        }]
    },
    {//第三行开始
        layout: 'column',   //定义该元素为布局为列布局方式
        border: false,
        items: [{//第三行第一列
            columnWidth: .5,  //该列占用的宽度，标识为50％
            layout: 'form',
            border: false,
            items: [{

                cls: 'key',
                xtype: 'textfield',
                fieldLabel: '<b>发票代码*</b>',
                name: 'BillCode',
                id: 'BillCode',
                anchor: '98%'

            }]
        },
        {//第三行第二列
            columnWidth: .5,  //该列占用的宽度，标识为50％
            layout: 'form',
            border: false,
            items: [{

                cls: 'key',
                xtype: 'textfield',
                fieldLabel: '<b>发票号码*</b>',
                name: 'BillNo',
                id: 'BillNo',
                anchor: '98%'

            }]
        }]
    },
    {//第二行开始
        layout: 'column',   //定义该元素为布局为列布局方式
        border: false,
        items: [
        {//第二行第二列
            columnWidth: 1,  //该列占用的宽度，标识为50％
            layout: 'form',
            border: false,
            items: [{
                cls: 'key',
                xtype: 'textfield',
                fieldLabel: '<b>备注</b>',
                name: 'remark',
                id: 'remark',
                anchor: '98%'
            }]
        }]
    }]
});
function editData()
{
    var sm = OrderMstGrid.getSelectionModel();
	//获取选择的数据信息
	var selectData =  sm.getSelections();
	//如果没有选择，就提示需要选择数据信息
	if(selectData == null || selectData == "") {
		Ext.Msg.alert("提示","请选择需要调整的记录！");
		return;
    }else if(selectData.length !=1){
        Ext.Msg.alert("提示","请选择一条需要调整的记录！");
		return;
    }
    //打开
    if(winbillEdit == null){
        winbillEdit = new Ext.Window({
            title: "信息调整"
            , iconCls: 'upload-win'
            , width: 450
            , height: 220
            , layout: 'fit'
            , plain: true
            , modal: true
            , constrain: true
            , resizable: false
            , closeAction: 'hide'
            , autoDestroy: true
            , items: [
                adjustInfoFrom
             ]
             , buttons: [{
                 text: "保存"
                , handler: function() {
                    Ext.MessageBox.wait("数据正在处理，请稍候……");
                    Ext.Ajax.request({
                    url: 'frmBillManage.aspx?method=updateInfo',
                    method: 'POST',
                    params: {
                        BillId: Ext.getCmp('billid').getValue(),
                        CustomerName: Ext.getCmp('CustomerName').getValue(),
                        BillMode: Ext.getCmp('BillType').getValue(),
                        AccountType: Ext.getCmp('AcctType').getValue(),
                        BillCode: Ext.getCmp('BillCode').getValue(),
                        BillNo: Ext.getCmp('BillNo').getValue(),
                        Remark: Ext.getCmp('remark').getValue()
                    },
                    success: function(resp, opts) {
                        Ext.MessageBox.hide();
                        if( checkExtMessage(resp) )
                        {               
                            OrderMstGridData.reload();
                            winbillEdit.hide();
                        } 
                    },
                    failure: function(resp, opts) {
                        Ext.MessageBox.hide(); 
                        Ext.Msg.alert("提示", "保存失败");
                    }
                });

                }
                    , scope: this
             },
            {
                text: "取消"
                , handler: function() {
                    winbillEdit.hide();
                    adjustInfoFrom.getForm().reset();
                    OrderMstGridData.reload();
                }
                , scope: this
            }]
        });
    }
    //获取数据
    winbillEdit.show();// = selectData[0].data.BillId
    Ext.getCmp('billid').setValue(selectData[0].data.BillId);
    Ext.getCmp('CustomerName').setValue(selectData[0].data.CustomerName);
    Ext.getCmp('BillType').setValue(selectData[0].data.BillMode);
    Ext.getCmp('AcctType').setValue(selectData[0].data.AccountType);
    Ext.getCmp('BillCode').setValue(selectData[0].data.BillCode);
    Ext.getCmp('BillNo').setValue(selectData[0].data.BillNo);
    Ext.getCmp('remark').setValue(selectData[0].data.Remark);
}
//------------------------------------------
})
</script>

</html>
