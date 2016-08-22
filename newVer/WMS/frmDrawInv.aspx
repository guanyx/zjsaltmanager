<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmDrawInv.aspx.cs" Inherits="WMS_frmDrawInv" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html>
<head>
    <title>销售出库</title><meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<link rel="stylesheet" type="text/css" href="../ext3/resources/css/ext-all.css" />
<script type="text/javascript" src="../ext3/adapter/ext/ext-base.js"></script>
<script type="text/javascript" src="../ext3/ext-all.js"></script>
<script type="text/javascript" src="../ext3/example/TabCloseMenu.js" charset="gb2312"></script>
<script type="text/javascript" src="../ext3/example/ItemDeleter.js"></script>
<script type="text/javascript" src="../js/operateResp.js"></script>
<script type="text/javascript" src="../ext3/src/locale/ext-lang-zh_CN.js"></script>
<style type="text/css">
.x-grid-back-blue { 
background: #C3D9FF; 
}
.x-date-menu {
   width: 175px;
}
</style>
</head>
<body>
<div id='MainToolbar'></div>
<div id='MainSearchForm'></div>
<div id='MainDataGrid'></div>

</body>
<%=getComboBoxStore()%>
<script type="text/javascript">
var orgId;
var orgName;
var operId;
var whId;
var customerId;
var customerName;
Ext.BLANK_IMAGE_URL = "../ext3/resources/images/default/s.gif"; 
Ext.onReady(function() {
    /*------实现toolbar的函数 start---------------*/
    var Toolbar = new Ext.Toolbar({
        renderTo: "MainToolbar",
        items: [
//        {
//            text: "查看领货单",
//            icon: "../Theme/1/images/extjs/customer/view16.gif",
//            handler: function() {  }
//        },
        {
            text: "销售出库",
            icon: "../Theme/1/images/extjs/customer/add16.gif",
            handler: function() { OutDraw() ;  }
        },'-',
        {
            text: "取消出库通知",
            icon: "../Theme/1/images/extjs/customer/delete16.gif",
            handler: function() { 
                CancelDrawInv();  
            
            }
        },'-',{
        xtype: 'splitbutton',
        text:'单据打印',
        icon: '../../Theme/1/images/extjs/customer/print3.png',
        menu:createMenu()
    }]
        });
        
        function createMenu()
{
	var menu = new Ext.menu.Menu({
        id: 'mainMenu',
        style: {
            overflow: 'visible'
       },
       items: [
	{
           text: '出库单打印',
           icon: '../../Theme/1/images/extjs/customer/print1.png',
           handler: printOrderById
        },
	{
           text: '货物装卸单打印',
           icon: '../../Theme/1/images/extjs/customer/print2.png',
           handler: printLoadrById
        },{
           text: '货物运输出库单打印',
           icon: '../../Theme/1/images/extjs/customer/print3.png',
           handler: printTransById
        }]});
	return menu;
}

function printLoadrById()
{
var sm = OutDrawGrid.getSelectionModel();
                //多选
                var selectData = sm.getSelections();                
                var array = new Array(selectData.length);
                var orderIds = "";
                for(var i=0;i<selectData.length;i++)
                {
                    if(orderIds.length>0)
                        orderIds+=",";
                    orderIds += selectData[i].get('DrawInvId');
                }
                //页面提交
                Ext.Ajax.request({
                    url: 'frmDrawInv.aspx?method=getrateprintdata',
//                    url:'frmOrderMst.aspx?method=billdata',
                    method: 'POST',
                    params: {
                        DrawInvId: orderIds,
                        TypeName:'货物装卸操作'
                    },
                   success: function(resp,opts){ 
                       var printData =  resp.responseText;
                       var printControl =  parent.parent.parent.document.getElementById("topFrame").contentWindow.getPrintControl();
                       printControl.Url =getUrl('xml');
                       printControl.MapUrl = printControl.Url+'/'+printRateStyleXml;//'/salePrint1.xml';
                       printControl.PrintXml = printData;
                       printControl.ColumnName="OrderId";
                       printControl.OnlyData=printOnlyData;
                       printControl.PageWidth=printRatePageWidth;
                       printControl.PageHeight =printRatePageHeight ;
                       printControl.Print();
                       
                   },
		           failure: function(resp,opts){  
//		                Ext.Msg.alert("提示",resp);   
		            }
                });
}

function printTransById()
{
var sm = OutDrawGrid.getSelectionModel();
                //多选
                var selectData = sm.getSelections();                
                var array = new Array(selectData.length);
                var orderIds = "";
                for(var i=0;i<selectData.length;i++)
                {
                    if(orderIds.length>0)
                        orderIds+=",";
                    orderIds += selectData[i].get('DrawInvId');
                }
                //页面提交
                Ext.Ajax.request({
                    url: 'frmDrawInv.aspx?method=getrateprintdata',
//                    url:'frmOrderMst.aspx?method=billdata',
                    method: 'POST',
                    params: {
                        DrawInvId: orderIds,
                        TypeName:'货物运输出库'
                    },
                   success: function(resp,opts){ 
                       var printData =  resp.responseText;
                       var printControl =  parent.parent.parent.document.getElementById("topFrame").contentWindow.getPrintControl();
                       printControl.Url =getUrl('xml');
                       printControl.MapUrl = printControl.Url+'/'+printRateStyleXml;//'/salePrint1.xml';
                       printControl.PrintXml = printData;
                       printControl.ColumnName="OrderId";
                       printControl.OnlyData=printOnlyData;
                       printControl.PageWidth=printRatePageWidth;
                       printControl.PageHeight =printRatePageHeight ;
                       printControl.Print();
                       
                   },
		           failure: function(resp,opts){  
//		                Ext.Msg.alert("提示",resp);   
		             }
                });
}
    /*------结束toolbar的函数 end---------------*/
function getUrl(imageUrl)
            {
                var index = window.location.href.toLowerCase().indexOf('/wms/');
                var tempUrl = window.location.href.substring(0,index);
                return tempUrl+"/"+imageUrl;
            }
function printOrderById()
{
var sm = OutDrawGrid.getSelectionModel();
                //多选
                var selectData = sm.getSelections();                
                var array = new Array(selectData.length);
                var orderIds = "";
                for(var i=0;i<selectData.length;i++)
                {
                    if(orderIds.length>0)
                        orderIds+=",";
                    orderIds += selectData[i].get('DrawInvId');
                }
                //页面提交
                Ext.Ajax.request({
                    url: 'frmDrawInv.aspx?method=getprintdata',
//                    url:'frmOrderMst.aspx?method=billdata',
                    method: 'POST',
                    params: {
                        DrawInvId: orderIds
                    },
                   success: function(resp,opts){ 
                       var printData =  resp.responseText;
                       var printControl =  parent.parent.parent.document.getElementById("topFrame").contentWindow.getPrintControl();
                       printControl.Url =getUrl('xml');
                       printControl.MapUrl = printControl.Url+'/'+printStyleXml;//'/salePrint1.xml';
                       printControl.PrintXml = printData;
                       printControl.ColumnName="OrderId";
                       printControl.OnlyData=printOnlyData;
                       printControl.PageWidth=printPageWidth;
                       printControl.PageHeight =printPageHeight ;
                       printControl.Print();
                       
                   },
		           failure: function(resp,opts){  Ext.Msg.alert("提示",resp);   }
                });
}
//保存
    function CancelDrawInv() {
        var sm = OutDrawGrid.getSelectionModel();
        //多选
        var selectData = sm.getSelections();
        var array = new Array(selectData.length);
        for (var i = 0; i < selectData.length; i++) {
            array[i] = selectData[i].get('DrawInvId');
            if(selectData[i].data.Status>3)
            {
                Ext.Msg.alert("提示","该笔单据已经出库，不能再取消了！");
                return;
            }
        }

        //如果没有选择，就提示需要选择数据信息
        if (selectData == null || selectData == "") {
            Ext.Msg.alert("提示", "请选中需要取消的领货单信息！");
            return;
        }

        //页面提交
        Ext.Ajax.request({
            url: 'frmDrawInv.aspx?method=canceldrawinvwaitout',
            method: 'POST',
            params: {
                DrawInvId: array.join('-')//传入多项的id串
            },
            success: function(resp, opts) {
                if (checkExtMessage(resp)) {
                    OutDrawGrid.getStore().reload();
                }
            },
            failure: function(resp, opts) { Ext.Msg.alert("提示", "数据取消失败！"); }
        });


    }
    /*-----实体函数----*/
    function OutDraw() {
    //uploadOrderWindow.show();
    
   
        var sm = OutDrawGrid.getSelectionModel();
        var selectData = sm.getSelected();
        if (selectData == null) {
            Ext.Msg.alert("提示", "请选中需要编辑的信息！");
            return;
        }
        if(selectData.data.Status>3)
        {
            Ext.Msg.alert("提示","该笔单据已经出库，不能再出库了！");
            return;
        }
        orgId = selectData.data.OrgId;
        operId = selectData.data.OperId;
        whId = selectData.data.OutStor;
        customerName = selectData.data.CustomerName;
        customerId = selectData.data.CustomerId
        orgName = selectData.data.OrgName;
        uploadOrderWindow.show();
        uploadOrderWindow.setTitle("新增销售出库单");//alert(selectData.data.DrawInvId);
        document.getElementById("SaleIFrame").src = "frmInStockBill.aspx?type=W0202&id="+selectData.data.DrawInvId;
//        if(document.getElementById("SaleIFrame").src.indexOf("frmInStockBill")==-1)
//        {                
//            document.getElementById("SaleIFrame").src ="frmInStockBill.aspx?type=W0202&id="+selectData.data.DrawInvId;
//        }
//        else{
//            document.getElementById("SaleIFrame").contentWindow.OrderId=selectData.data.DrawInvId;                    
//            document.getElementById("SaleIFrame").contentWindow.FromBillType='W0202';
//            document.getElementById("SaleIFrame").contentWindow.setAllKindValue();
//        }
        /*  
        //多选
        var selectData = sm.getSelections();                
        var array = new Array(selectData.length);
        for(var i=0;i<selectData.length;i++)
        {
            array[i] = selectData[i].get('OrderId');
        }

        //如果没有选择，就提示需要选择数据信息
        if (selectData == null|| selectData.length == 0) {
            Ext.Msg.alert("提示", "请选中需要生成领货单的订单记录！");
            return;
        }
               
        uploadOrderWindow.show();
        uploadOrderWindow.setTitle("新增移库单");
        document.getElementById("editShiftPosOrderIFrame").src = "frmShiftPosOrderEdit.aspx?id=0";
                       
        //页面提交
        Ext.Ajax.request({
            url: 'frmSelfDlv.aspx?method=gener',
            method: 'POST',
            params: {
                OrderId: array.join('-')//传入多项的id串
            },
            success: function(resp, opts) {
                Ext.Msg.alert("提示", "数据生成成功！");
                OrderMstGrid.getStore().reload();
                
            },
            failure: function(resp, opts) {
                Ext.Msg.alert("提示", "数据生成失败！");
            }
        });
        */
    }
    
    /*------开始界面数据的窗体 Start---------------*/
    if (typeof (uploadOrderWindow) == "undefined") {//解决创建2个windows问题
        uploadOrderWindow = new Ext.Window({
            id: 'DvlSaleOrderWindow'
            , iconCls: 'upload-win'
            , height:465
            , width:700
            , x:window.screen.width/2 -500
            , y:window.screen.height/2 -300
            //, autoWidth: true
            //, autoHeight: true
            , layout: 'fit'
            , plain: true
            , modal: true
            //, border:false
            , constrain: true
            , resizable: false
            , closeAction: 'hide'
            , autoDestroy: true
            , html: '<iframe id="SaleIFrame" width="100%" height="100%" border=0 src="#"></iframe>'
           //,autoScroll:true
        });
    }
    uploadOrderWindow.addListener("hide", function() {
        OutDrawGridData.reload();
    });
    
    function QueryDataGrid() {
        OutDrawGridData.baseParams.OrgId = <% =ZJSIG.UIProcess.ADM.UIAdmUser.OrgID(this)%>;
        OutDrawGridData.baseParams.DeptId = <% =ZJSIG.UIProcess.ADM.UIAdmUser.DeptID(this)%>;
        OutDrawGridData.baseParams.OutStor = Ext.getCmp('MOutStor').getValue();
        OutDrawGridData.baseParams.CustomerId = Ext.getCmp('MCustomerId').getValue();
        OutDrawGridData.baseParams.DlvType = Ext.getCmp('MDlvType').getValue();
        OutDrawGridData.baseParams.StartDate = Ext.util.Format.date(Ext.getCmp('MStartDate').getValue(),'Y/m/d');
        OutDrawGridData.baseParams.EndDate = Ext.util.Format.date(Ext.getCmp('MEndDate').getValue(),'Y/m/d');
        OutDrawGridData.baseParams.Status = Ext.getCmp('chbOut').getValue();
        OutDrawGridData.baseParams.BillNo = Ext.getCmp('MBillNo').getValue();
        OutDrawGridData.load({
            params: {
                start: 0,
                limit: defaultPageSize
            }
        });
    }
            

      //仓库
       var ck = new Ext.form.ComboBox({
           xtype: 'combo',
           store: dsWareHouse,
           valueField: 'WhId',
           displayField: 'WhName',
           mode: 'local',
           forceSelection: true,
           name:'MOutStor',
           id:'MOutStor',
           emptyValue: '',
           triggerAction: 'all',
           fieldLabel: '仓库',
           selectOnFocus: true,
           anchor: '98%',
           editable:false
       });
               
               
       //开始日期
       var ksrq = new Ext.form.DateField({
   		    xtype:'datefield',
	        fieldLabel:'开始日期',
	        anchor:'98%',
	        name:'MStartDate',
	        id:'MStartDate',
	        format: 'Y年m月d日',  //添加中文样式
            value:new Date().getFirstDateOfMonth().clearTime()
        });
               
       //结束日期
       var jsrq = new Ext.form.DateField({
   		    xtype:'datefield',
	        fieldLabel:'结束日期',
	        anchor:'98%',
	        name:'MEndDate',
	        id:'MEndDate',
	        format: 'Y年m月d日',  //添加中文样式
            value:(new Date()).clearTime()
       });              
               
               
        //订单类型
        var ddlx = new Ext.form.ComboBox({
           xtype: 'combo',
           store: dsDrawType,
           valueField: 'DicsCode',
           displayField: 'DicsName',
           mode: 'local',
           forceSelection: true,
           editable: false,
           emptyValue: '',
           triggerAction: 'all',
           fieldLabel: '配送方式',
           name:'MDlvType',
           id:'MDlvType',
           selectOnFocus: true,
           anchor: '98%',
           editable:false
       });  
               
       var serchDrawInvform = new Ext.FormPanel({
            renderTo: 'MainSearchForm',
            labelAlign: 'left',
            buttonAlign: 'center',
            bodyStyle: 'padding:5px',
            frame: true,
            labelWidth: 55,
            items:[
            {
                layout:'column',
                border: false,
                items: [
                {
	                layout:'form',
	                border: false,
	                columnWidth:0.3,
	                items: [{
			                xtype:'textfield',
			                fieldLabel:'客户',
			                columnWidth:0.33,
			                anchor:'98%',
			                name:'MCustomerId',
			                id:'MCustomerId'
		                }]
                } ,		
                {
	                layout:'form',
	                border: false,
	                columnWidth:0.3,
	                items: [ddlx]
                },		
                {
	                layout:'form',
	                border: false,
	                columnWidth:0.25,
	                items: [ck]
                },		
                {
                    layout:'form',
                    border: false,
                    style: 'align:left',
                    columnWidth:0.15,
                    labelWidth: 15,
                    items:[{
                        xtype:'checkbox',
                        id: 'chbOut',
                        boxLabel:'出库',
                        name:'chbOut',
                        cls: 'key'
                    }]
                }
            ]},
            {
                layout:'column',
                border: false,
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
		                    name:'MStartDate',
		                    id:'MStartDate',
		                    value:new Date().getFirstDateOfMonth().clearTime(),
		                    format:'Y年m月d日'
	                    }]
                } ,		
                {
                    layout:'form',
                    border: false,
                    columnWidth:0.3,
                    items: [{
		                    xtype:'datefield',
		                    fieldLabel:'结束日期',
		                    columnWidth:0.5,
		                    anchor:'98%',
		                    name:'MEndDate',
		                    id:'MEndDate',
		                    value:new Date().clearTime(),
		                    format:'Y年m月d日'
	                    }]
                } ,		
                {
                    layout:'form',
                    border: false,
                    style: 'align:left',
                    columnWidth:0.24,
                    items:[{
                        xtype:'textfield',
		                fieldLabel:'发票号码',
		                columnWidth:0.25,
		                anchor:'98%',
		                name:'MBillNo',
		                id:'MBillNo'
                    }]
                },			
                {
                    layout:'form',
                    border: false,
                    style: 'align:left',
                    columnWidth:0.03,
                    html:'&nbsp;'
                },	
                {
                    layout:'form',
                    border: false,
                    columnWidth:0.12,
                    style: 'align:center',
                    items:[{
                        xtype:'button',
                        id: 'searchMainbtnId',
                        text: '查询',
                        handler: function() {QueryDataGrid();}
                    }]
                }]
            }]
    });


    /*------开始获取数据的函数 start---------------*/
    var OutDrawGridData = new Ext.data.Store
    ({
        url: 'frmDrawInv.aspx?method=getDrawInvList',
        reader: new Ext.data.JsonReader({
            totalProperty: 'totalProperty',
            root: 'root'
        }, [
            {name:'OrderId'},
            {name:'OrgId'},
            {name:'OrgName'},
            {name:'DeptId'},
            {name:'DeptName'},
            {name:'OutStor'},
            {name:'OutStorName'},
            {name:'CustomerId'},
            {name:'CustomerName'},
            {name:'SendDate'},
            {name:'DlvAdd'},
            {name:'DlvDesc'},
            {name:'OrderType'},
            {name:'OrderTypeName'},
            {name:'PayType'},
            {name:'PayTypeName'},
            {name:'BillMode'},
            {name:'BillModeName'},
            {name:'DrawType'},
            {name:'DlvTypeName'},
            {name:'DlvLevel'},
            {name:'DlvLevelName'},
            {name:'Status'},
            {name:'StatusName'},
            {name:'IsPayed'},
            {name:'IsPayedName'},
            {name:'IsBill'},
            {name:'IsBillName'},
            {name:'SaleInvId'},
            {name:'TotalQty'},
            {name:'OutedQty'},
            {name:'TotalAmt'},
            {name:'TotalTax'},
            {name:'DtlCount'},
            {name:'OperId'},
            {name:'OperName'},
            {name:'OperDate'},
            {name:'UpdateDate'},
            {name:'OwnerId'},
            {name:'OwnerName'},
            {name:'BizAudit'},
            {name:'AuditDate'},
            {name:'Remark'},
            {name:'DrawInvId'},
            {name:'DrawNumber'},
            {name:'IsActiveName'},
            {name:'OrderNumber'},
            {name:'BillNo'}	])
            ,
        sortData: function(f, direction) {
            var tempSort = Ext.util.JSON.encode(OutDrawGridData.sortInfo);
            if (sortInfor != tempSort) {
                sortInfor = tempSort;
                if(tempSort.indexOf("OrderNumber")!=-1)
                {
                    tempSort = tempSort.replace("OrderNumber","OrderId");
                }
                OutDrawGridData.baseParams.SortInfo = tempSort;
                OutDrawGridData.load({ params: { limit: defaultPageSize, start: 0} });
            }
        },
        listeners:
        {
            scope: this,
            load: function() {
            }
        }
    });

    var sortInfor="";
    /*------获取数据的函数 结束 End---------------*/

var defaultPageSize = 10;
    var toolBar = new Ext.PagingToolbar({
        pageSize: 10,
        store: OutDrawGridData,
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
        toolBar.doLoad(0);
    }, toolBar);
    
    /*------开始DataGrid的函数 start---------------*/

    var Mainsm = new Ext.grid.CheckboxSelectionModel({
        singleSelect: true
    });
    var OutDrawGrid = new Ext.grid.GridPanel({
        el: 'MainDataGrid',
        //width: '100%',
        width:document.body.offsetWidth,
        //height: '100%',
        //autoWidth: true,
        //autoHeight: true,
        autoScroll: true,
        layout: 'fit',
        id: '',
        store: OutDrawGridData,
        loadMask: { msg: '正在加载数据，请稍侯……' },
        sm: Mainsm,
        cm: new Ext.grid.ColumnModel([
        
        Mainsm,
        new Ext.grid.RowNumberer(),//自动行号
        {//DrawInvId
            header:'领货单ID',
            dataIndex:'DrawInvId',
            id:'DrawInvId',
            hidden:true,
            hideable:false
        },
        {
            header:'订单标识',
            dataIndex:'OrderId',
            id:'OrderId',
            hidden:true,
            hideable:false
        },
        {
            header:'订单编号',
            dataIndex:'OrderNumber',
           sortable: true,
            id:'OrderNumber',
            width:95
        },
        {
            header:'领货编号',
            dataIndex:'DrawNumber',
            sortable: true,
            id:'DrawNumber',
            width:95
        },
        {
            header:'出库仓库',
            dataIndex:'OutStorName',
            id:'OutStorName',
            width:85
        },
        {
            header:'客户名称',
            dataIndex:'CustomerName',
            id:'CustomerName',
            width:180
        },
        {
            header:'送货日期',
            dataIndex:'SendDate',
            sortable: true,
            id:'SendDate',
            renderer: Ext.util.Format.dateRenderer('Y年m月d日'),
            width:95
        },
        {
            header:'配送方式',
            dataIndex:'DrawType',
            id:'DrawType',
            sortable: true,
            renderer:{fn:function(v){
		        //根据key定位下拉框中的value
		        var index = dsDrawType.find('DicsCode', v);
                var record = dsDrawType.getAt(index);
                return record.data.DicsName;
		     }},
            width:60
        },
        {
            header:'订货总数量',
            dataIndex:'TotalQty',
            id:'TotalQty',
            width:70
        },
        {
            header:'发票号码',
            dataIndex:'BillNo',
            id:'BillNo',
            width:80
        },
        {
            header:'创建时间',
            dataIndex:'OperDate',
            id:'OperDate',
            renderer: Ext.util.Format.dateRenderer('Y年m月d日 H时i分s秒'),
            width:180
        }			]),
        bbar: toolBar,
        viewConfig: {
            columnsText: '显示的列',
            scrollOffset: 20,
            sortAscText: '升序',
            sortDescText: '降序'//,
            //forceFit: true
        },
        height: 280,
        closeAction: 'hide',
        stripeRows: true,
        loadMask: true//,
        //autoExpandColumn: 2
    });
    
    /*------DataGrid的函数结束 End---------------*/
    QueryDataGrid();
    OutDrawGrid.on('render', function(grid) {  
        var store = grid.getStore();  // Capture the Store.  
  
        var view = grid.getView();    // Capture the GridView.  
  
        OutDrawGrid.tip = new Ext.ToolTip({  
            target: view.mainBody,    // The overall target element.  
      
            delegate: '.x-grid3-row', // Each grid row causes its own seperate show and hide.  
      
            trackMouse: true,         // Moving within the row should not hide the tip.  
      
            renderTo: document.body,  // Render immediately so that tip.body can be referenced prior to the first show.  
      
            listeners: {              // Change content dynamically depending on which element triggered the show.  
      
                beforeshow: function updateTipBody(tip) {  
                    var rowIndex = view.findRowIndex(tip.triggerElement);
                            var element = document.elementFromPoint(tip.x-20, tip.y-20);
                             var v = view.findCellIndex(element);
                             if(v==4||v==5)
                             {
                              
                                if(showTipRowIndex == rowIndex)
                                    return;
                                else
                                    showTipRowIndex = rowIndex;
                                     tip.body.dom.innerHTML="正在加载数据……";
                                        //页面提交
                                        Ext.Ajax.request({
                                            url: 'frmDrawInv.aspx?method=getdrawdetail',
                                            method: 'POST',
                                            params: {
                                                DrawInvId: grid.getStore().getAt(rowIndex).data.DrawInvId
                                            },
                                            success: function(resp, opts) {
                                                tip.body.dom.innerHTML = resp.responseText;
                                            },
                                            failure: function(resp, opts) {
                                                OutDrawGrid.tip.hide();
                                            }
                                        });
                                }//细项信息                                                   
                                else
                                {
                                    OutDrawGrid.tip.hide();
                                }
                        
            }  }});
        });  
    var showTipRowIndex=-1;
     OutDrawGrid.render();
    OutDrawGrid.on('rowdblclick', function(grid, rowIndex, e) {
                //弹出商品明细
                var _record = OutDrawGrid.getStore().getAt(rowIndex).data.DrawInvId;
                if (!_record) {
                    // Ext.example.msg('操作', '请选择要查看的记录！');
                } else {
                    OpenDtlWin(_record);
                }

            });
            /****************************************************************/
            function OpenDtlWin(orderId) {
                if (typeof (uploadRouteWindow) == "undefined") {
                    newFormWin = new Ext.Window({
                        layout: 'fit',
                        width: 500,
                        height: 250,
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
                orderDtInfoStore.baseParams.DrawInvId = orderId;
                orderDtInfoStore.load({
                    params: {
                        limit: 100,
                        start: 0
                    }
                });
            }

            var orderDtInfoStore = new Ext.data.Store
                            ({
                                url: '../scm/frmDrawInvWaitOut.aspx?method=getDtlInfo',
                                reader: new Ext.data.JsonReader({
                                    totalProperty: 'totalProperty',
                                    root: 'root'
                                }, [
	                            { name: 'DrawInvDtlId' },
	                            { name: 'DrawInvId' },
	                            { name: 'ProductId' },
	                            { name: 'ProductCode' },
	                            { name: 'ProductName' },
	                            { name: 'SpecName' },
	                            { name: 'UnitName' },
	                            { name: 'DrawQty' },
	                            { name: 'Price' },
	                            { name: 'Amt' },
	                            { name: 'Tax' }
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
		                            dataIndex: 'ProductCode',
		                            id: 'ProductCode'
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
		                                header: '数量',
		                                dataIndex: 'DrawQty',
		                                id: 'DrawQty'
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
    
});

</script>

</html>
