<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmDrawInvWaitOut.aspx.cs" Inherits="SCM_frmDrawInvWaitOut" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>待出库通知确认</title>
<link rel="stylesheet" type="text/css" href="../ext3/resources/css/ext-all.css" />
<script type="text/javascript" src="../ext3/adapter/ext/ext-base.js"></script>
<script type="text/javascript" src="../ext3/ext-all.js"></script>
<script type="text/javascript" src="../js/operateResp.js"></script>
<script type="text/javascript" src="../ext3/src/locale/ext-lang-zh_CN.js"></script>
<script type="text/javascript" src="../js/operateResp.js"></script>
<style type="text/css">
.x-grid-back-blue { 
background: #B7CBE8; 
}
.x-date-menu {
   width: 175px;
}
</style>
</head>
<body>    
    <div id='toolbar'></div>
    <div id="searchForm"></div>
    <div id="DrawInvGrid"></div>
</body>

<!-- 所有数据源打印到这里 -->
<%= getComboBoxStore() %>

<script type="text/javascript">
Ext.BLANK_IMAGE_URL = "../ext3/resources/images/default/s.gif";  //作为：让下拉框的三角形下拉图片显示
Ext.onReady(function() {

    /*------实现toolbar的函数 start---------------*/
    var Toolbar = new Ext.Toolbar({
        renderTo: "toolbar",
        items: [{
            text: "确认",
            icon: "../Theme/1/images/extjs/customer/add16.gif",
            handler: function() { saveUpdate(); }
        }, '-', {
            text: "删除领货单",
            icon: "../Theme/1/images/extjs/customer/delete16.gif",
            handler: function() {
                delDrawInv();

            }
        }, '-', {
            text: "领货单打印",
            icon: "../Theme/1/images/extjs/customer/print1.png",
            handler: function() { printOrderById();}
        }, '-', {
            text: "配送单打印",
            icon: "../Theme/1/images/extjs/customer/print2.png",
            handler: function() { printSendOrder();}
        }, '-', {
            text: "自提单打印",
            icon: "../Theme/1/images/extjs/customer/print3.png",
            handler: function() { printSelfOrder();}
        }, '-'
                   ]
    });
    
    setToolBarVisible(Toolbar);
    /*------结束toolbar的函数 end---------------*/
    function getUrl(imageUrl)
            {
                var index = window.location.href.toLowerCase().indexOf('/scm/');
                var tempUrl = window.location.href.substring(0,index);
                return tempUrl+"/"+imageUrl;
            }
function printSelfOrder()
{
    var sm = DrawInvGrid.getSelectionModel();
    //多选
    var selectData = sm.getSelections();                
    var array = new Array(selectData.length);
    var orderIds = "";
    var havePrint ="";
    for(var i=0;i<selectData.length;i++)
    {
        if(orderIds.length>0)
            orderIds+=",";
        orderIds += selectData[i].get('DrawInvId');
        if(selectData[i].get('DrawTypeName').indexOf('自提')==-1)
        {
            Ext.Msg.alert("系统提示","请选择配送单进行打印！");
            return;
        }
        if(selectData[i].get('PrintCount')!='0')
        {
            havePrint+="领货单"+selectData[i].get('DrawNumber')+";";
        }
    }
    if(orderIds=="")
    {
        Ext.Msg.alert("系统提示","请选择需要打印的单据信息！");
        return;
    }
    if(havePrint.length>0)
    {
        Ext.Msg.confirm("提示信息", havePrint+"已经打印过了，真的还需要打印吗？", function callBack(id) {
            //判断是否删除数据
            if (id == "yes") {
                  printDrawOrder(orderIds,'printdate',printPageWidth,printPageHeight,printStyleXml);
          }
        });  
    }
    else
    {
         printDrawOrder(orderIds,'printdate',printPageWidth,printPageHeight,printStyleXml);
    }
}
function printSendOrder()
{
    var sm = DrawInvGrid.getSelectionModel();
    //多选
    var selectData = sm.getSelections();                
    var array = new Array(selectData.length);
    var orderIds = "";
    var havePrint ="";
    for(var i=0;i<selectData.length;i++)
    {
        if(orderIds.length>0)
            orderIds+=",";
        orderIds += selectData[i].get('DrawInvId');
        if(selectData[i].get('DrawTypeName').indexOf('配送')==-1)
        {
            Ext.Msg.alert("系统提示","请选择配送单进行打印！");
            return;
        }
        if(selectData[i].get('PrintCount')!='0')
        {
            havePrint+="领货单"+selectData[i].get('DrawNumber')+";";
        }
    }
    if(orderIds=="")
    {
        Ext.Msg.alert("系统提示","请选择需要打印的单据信息！");
        return;
    }
    if(havePrint.length>0)
    {
        Ext.Msg.confirm("提示信息", havePrint+"已经打印过了，真的还需要打印吗？", function callBack(id) {
            //判断是否删除数据
            if (id == "yes") {
                  printDrawOrder(orderIds,'printdate',printPageWidth,printPageHeight,printStyleXml);
          }
        });  
    }
    else
    {
         printDrawOrder(orderIds,'printdate',printPageWidth,printPageHeight,printStyleXml);
    }
    
    
    
}
function setPrintState(){
    var sm = DrawInvGrid.getSelectionModel();
    //多选
    var selectData = sm.getSelections(); 
    for(var i=0;i<selectData.length;i++)
    {
        var times = selectData[i].get('PrintCount');
        selectData[i].set('PrintCount',parseInt(times,10) + 1);
    }
}
function printOrderById()
{
var sm = DrawInvGrid.getSelectionModel();
    //多选
    var selectData = sm.getSelections();                
    var array = new Array(selectData.length);
    var orderIds = "";
    var havePrint="";
    for(var i=0;i<selectData.length;i++)
    {
        if(orderIds.length>0)
            orderIds+=",";
        orderIds += selectData[i].get('DrawInvId');
        if(selectData[i].get('PrintCount')!='0')
        {
            havePrint+="领货单"+selectData[i].get('DrawNumber')+";";
        }
    }
    if(orderIds=="")
    {
        Ext.Msg.alert("系统提示","请选择需要打印的单据信息！");
        return;
    }
    if(havePrint.length>0)
    {
        Ext.Msg.confirm("提示信息", havePrint+"已经打印过了，真的还需要打印吗？", function callBack(id) {
            //判断是否删除数据
            if (id == "yes") {
                  printDrawOrder(orderIds,'printdate',printPageWidth,printPageHeight,printStyleXml);
          }
        });  
    }
    else
    {
         printDrawOrder(orderIds,'printdate',printPageWidth,printPageHeight,printStyleXml);
    }
                //页面提交
//                Ext.Ajax.request({
//                    url: 'frmDrawInvWaitOut.aspx?method=selfprintdata',
////                    url:'frmOrderMst.aspx?method=billdata',
//                    method: 'POST',
//                    params: {
//                        DrawInvId: orderIds
//                    },
//                   success: function(resp,opts){ 
//                       var printData =  resp.responseText;
//                       var printControl =  parent.parent.parent.document.getElementById("topFrame").contentWindow.getPrintControl();
//                       printControl.Url =getUrl('xml');
//                       printControl.MapUrl = printControl.Url+'/'+printStyleXml;//'/salePrint1.xml';
//                       printControl.PrintXml = printData;
//                       printControl.ColumnName="DrawInvId";
//                       printControl.OnlyData=printOnlyData;
//                       printControl.PageWidth=printPageWidth;
//                       printControl.PageHeight =printPageHeight ;
//                       printControl.Print();
////                    var billControl = document.getElementById('billControl');
////                    billControl.PrintXml = printData;
////                    billControl.setFormValue(0);
//                       
//                   },
//		           failure: function(resp,opts){  /* Ext.Msg.alert("提示","保存失败"); */    }
//                });
}

function printDrawOrder(orderIds,method,width,height,xmlName)
{
     //页面提交
                Ext.Ajax.request({
                    url: 'frmDrawInvWaitOut.aspx?method='+method,
//                    url:'frmOrderMst.aspx?method=billdata',
                    method: 'POST',
                    params: {
                        DrawInvId: orderIds
                    },
                   success: function(resp,opts){ 
                       var printData =  resp.responseText;
                       var printControl =  parent.parent.parent.document.getElementById("topFrame").contentWindow.getPrintControl();
                       printControl.Url =getUrl('xml');
                       printControl.MapUrl = printControl.Url+'/'+xmlName;//'/salePrint1.xml';
                       printControl.PrintXml = printData;
                       printControl.ColumnName="DrawInvId";
                       printControl.OnlyData=printOnlyData;
                       printControl.PageWidth=width;
                       printControl.PageHeight =height ;
                       printControl.Print();
//                    var billControl = document.getElementById('billControl');
//                    billControl.PrintXml = printData;
//                    billControl.setFormValue(0);

                      //页面提交
                       Ext.Ajax.request({
                           url: 'frmDrawInvWaitOut.aspx?method=print',
                           method: 'POST',
                           params: {
                               OrderId: orderIds
                           },
                          success: function(resp,opts){ /* checkExtMessage(resp) */ },
		                  failure: function(resp,opts){  /* Ext.Msg.alert("提示","保存失败"); */    }
                       });
                       //QueryDataGrid();
                       setPrintState();
                   },
		           failure: function(resp,opts){  /* Ext.Msg.alert("提示","保存失败"); */    }
                });
}


    //领货单列表
    function QueryDataGrid() {
        DrawInvGridData.baseParams.CustomerId = Ext.getCmp('CustomerId').getValue();
        DrawInvGridData.baseParams.StartDate = Ext.util.Format.date(Ext.getCmp('StartDate').getValue(), 'Y/m/d');
        DrawInvGridData.baseParams.EndDate = Ext.util.Format.date(Ext.getCmp('EndDate').getValue(), 'Y/m/d');
        DrawInvGridData.load({
            params: {
                start: 0,
                limit: defaultPageSize
            }
        });
    }

    //保存
    function delDrawInv() {
        var sm = DrawInvGrid.getSelectionModel();
        //多选
        var selectData = sm.getSelections();
        var array = new Array(selectData.length);
        for (var i = 0; i < selectData.length; i++) {
            array[i] = selectData[i].get('DrawInvId');
        }

        //如果没有选择，就提示需要选择数据信息
        if (selectData == null || selectData == "") {
            Ext.Msg.alert("提示", "请选中需要确认的领货单信息！");
            return;
        }
        Ext.Msg.confirm("提示信息", "如果删除该领货单，那么该领货单对应的订单的其他领货单也会被删除，真的要删除吗？", function callBack(id) {
            //判断是否删除数据
            if (id == "yes") {
                //页面提交
                Ext.Ajax.request({
                    url: 'frmDrawInvWaitOut.aspx?method=delDrawInv',
                    method: 'POST',
                    params: {
                        DrawInvId: array[0]
                    },
                    success: function(resp, opts) {
                        if (checkExtMessage(resp)) {
                            DrawInvGrid.getStore().reload();
                        }
                    },
                    failure: function(resp, opts) { Ext.Msg.alert("提示", "数据生成失败！"); }
                });
            }
        });


    }

    //保存
    function saveUpdate() {
        var sm = DrawInvGrid.getSelectionModel();
        //多选
        var selectData = sm.getSelections();
        var array = new Array(selectData.length);
        for (var i = 0; i < selectData.length; i++) {
            array[i] = selectData[i].get('DrawInvId');
        }

        //如果没有选择，就提示需要选择数据信息
        if (selectData == null || selectData == "") {
            Ext.Msg.alert("提示", "请选中需要确认的领货单信息！");
            return;
        }

        //页面提交
        Ext.Ajax.request({
            url: 'frmDrawInvWaitOut.aspx?method=saveUpdate',
            method: 'POST',
            params: {
                DrawInvId: array.join('-')//传入多项的id串
            },
            success: function(resp, opts) {
                if (checkExtMessage(resp)) {
                    DrawInvGrid.getStore().reload();
                }
            },
            failure: function(resp, opts) { Ext.Msg.alert("提示", "数据生成失败！"); }
        });


    }



    /*-----------------------查询界面start------------------------*/
    var searchForm = new Ext.form.FormPanel({
        renderTo: 'searchForm',
        frame: true,
        buttonAlign: 'center',
        items: [
            {//第一行
                layout: 'column',
                items: [
                    {//第一单元格
                        layout: 'form',
                        border: false,
                        labelWidth: 70,
                        columnWidth: .3,
                        items: [{
                            xtype: 'textfield',
                            fieldLabel: '客户编号',
                            anchor: '95%',
                            id: 'CustomerId',
                            name: 'CustomerId'
}]
                        },
                    {//第二单元格
                        layout: 'form',
                        border: false,
                        labelWidth: 70,
                        columnWidth: .3,
                        items: [{
                            xtype: 'datefield',
                            fieldLabel: '开始日期',
                            anchor: '95%',
                            id: 'StartDate',
                            name: 'StartDate',
                            format: 'Y年m月d日',
                            value: new Date().getFirstDateOfMonth().clearTime(),
                            editable: false
}]
                        },
                    {//第三单元格
                        layout: 'form',
                        border: false,
                        labelWidth: 70,
                        columnWidth: .3,
                        items: [{
                            xtype: 'datefield',
                            fieldLabel: '结束日期',
                            anchor: '95%',
                            id: 'EndDate',
                            name: 'EndDate',
                            format: 'Y年m月d日',
                            value: new Date().clearTime(),
                            editable: false
}]
                        },
                    {//第四单元格
                        layout: 'form',
                        border: false,
                        labelWidth: 70,
                        columnWidth: .1,
                        items: [{
                            xtype: 'button',
                            text: '查询',
                            width: 70,
                            //iconCls:'excelIcon',
                            scope: this,
                            handler: function() {
                                QueryDataGrid();
                            }
}]
                        }
                ]
            }
        ]
    });
    /*-----------------------查询界面end------------------------*/



    /*------开始获取数据的函数 start---------------*/
    var DrawInvGridData = new Ext.data.Store
                        ({
                            url: 'frmDrawInvWaitOut.aspx?method=getDrawInvList',
                            reader: new Ext.data.JsonReader({
                                totalProperty: 'totalProperty',
                                root: 'root'
                            }, [
                                {
                                    name: 'DrawInvId'
                                },
	                            {
	                                name: 'DrawNumber'
	                            },
	                            {
	                                name: 'OutStor'
	                            },
	                            {
	                                name: 'OutStorName'
	                            },
	                            {
	                                name: 'CustomerId'
	                            },
	                            {
	                                name: 'CustomerName'
	                            },
	                            {
	                                name: 'CustomerCode'
	                            },
	                            {
	                                name: 'DrawType'
	                            },
	                            {
	                                name: 'DrawTypeName'
	                            },
	                            {
	                                name: 'DriverId'
	                            },
	                            {
	                                name: 'DriverName'
	                            },
	                            {
	                                name: 'VehicleId'
	                            },
	                            {
	                                name: 'VehicleName'
	                            },
	                            {
	                                name: 'ControlDate'
	                            },
	                            {
	                                name: 'TotalQty'
	                            },
	                            {
	                                name: 'TotalAmt'
	                            },
	                            {
	                                name: 'OrderId'
	                            },{
	                                name: 'OrderNumber'
	                            },{name: 'PrintCount'}])

	            ,sortData: function(f, direction) {
                    var tempSort = Ext.util.JSON.encode(DrawInvGridData.sortInfo);
                    if (sortInfor != tempSort) {
                        sortInfor = tempSort;
                        if(tempSort.indexOf("OrderNumber")!=-1)
                        {
                            tempSort = tempSort.replace("OrderNumber","OrderId");
                        }
                        DrawInvGridData.baseParams.SortInfo = tempSort;
                        DrawInvGridData.load({ params: { limit: defaultPageSize, start: 0} });
                    }
                },
                            listeners:
	            {
	                scope: this,
	                load: function() {
	                }
	            }
                        });
                        
                        var sortInfor='';
    /*------获取数据的函数 结束 End---------------*/
var defaultPageSize = 10;
    var toolBar = new Ext.PagingToolbar({
        pageSize: 10,
        store: DrawInvGridData,
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

    var sm = new Ext.grid.CheckboxSelectionModel({
        singleSelect: false
    });
    var DrawInvGrid = new Ext.grid.GridPanel({
        el: 'DrawInvGrid',
        width: '100%',
        height: '100%',
        autoWidth: true,
        autoHeight: true,
        autoScroll: true,
        layout: 'fit',
        id: '',
        store: DrawInvGridData,
        loadMask: { msg: '正在加载数据，请稍侯……' },
        sm: sm,
        cm: new Ext.grid.ColumnModel([

		                    sm,
		                    new Ext.grid.RowNumberer(), //自动行号
		                    {
		                    header: '领货单号',
		                    dataIndex: 'DrawInvId',
		                    id: 'DrawInvId',
		                    hidden: true
		                },
		                    {
		                        header: '订单编号',
		                        dataIndex: 'OrderNumber',
		                        sortable: true,
		                        id: 'OrderNumber'
		                    }, {
		                        header: '领货单号',
		                        dataIndex: 'DrawNumber',
		                        sortable: true,
		                        id: 'DrawNumber'
		                    },
		                    {
		                        header: '仓库',
		                        dataIndex: 'OutStorName',
		                        sortable: true,
		                        id: 'OutStorName'
		                    },
		                    {
		                        header: '客户编码',
		                        dataIndex: 'CustomerCode',
		                        sortable: true,
		                        id: 'CustomerCode'
		                    },
		                    {
		                        header: '客户名称',
		                        dataIndex: 'CustomerName',
		                        sortable: true,
		                        id: 'CustomerName'
		                    },
		                    {
		                        header: '类型',
		                        dataIndex: 'DrawTypeName',
		                        sortable: true,
		                        id: 'DrawTypeName'
		                    },
		                    {
		                        header: '总量',
		                        dataIndex: 'TotalQty',
		                        id: 'TotalQty'
		                    },
		                    {
		                        header: '订单ID',
		                        dataIndex: 'OrderId',
		                        id: 'OrderId',
		                        hidden: true
		                    }


		                    	]),
        bbar: toolBar,
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
    DrawInvGrid.on("afterrender", function(component) {
        component.getBottomToolbar().refresh.hideParent = true;
        component.getBottomToolbar().refresh.hide();
    });
    
    DrawInvGrid.on('render', function(grid) {  
        var store = grid.getStore();  // Capture the Store.  
  
        var view = grid.getView();    // Capture the GridView.  
  
        DrawInvGrid.tip = new Ext.ToolTip({  
            target: view.mainBody,    // The overall target element.  
      
            delegate: '.x-grid3-row', // Each grid row causes its own seperate show and hide.  
      
            trackMouse: true,         // Moving within the row should not hide the tip.  
      
            renderTo: document.body,  // Render immediately so that tip.body can be referenced prior to the first show.  
      
            listeners: {              // Change content dynamically depending on which element triggered the show.  
      
                beforeshow: function updateTipBody(tip) {  
                    var rowIndex = view.findRowIndex(tip.triggerElement);
                            var element = document.elementFromPoint(tip.x-20, tip.y-20);
                             var v = view.findCellIndex(element);
                             if(v==4||v==5||v==3)
                             {
                              
                                if(showTipRowIndex == rowIndex)
                                    return;
                                else
                                    showTipRowIndex = rowIndex;
                                     tip.body.dom.innerHTML="正在加载数据……";
                                        //页面提交
                                        Ext.Ajax.request({
                                            url: 'frmDrawInvSplit.aspx?method=getdrawdetail',
                                            method: 'POST',
                                            params: {
                                                DrawInvId: grid.getStore().getAt(rowIndex).data.DrawInvId
                                            },
                                            success: function(resp, opts) {
                                                tip.body.dom.innerHTML = resp.responseText;
                                            },
                                            failure: function(resp, opts) {
                                                DrawInvGrid.tip.hide();
                                            }
                                        });
                                }//细项信息                                                   
                                else
                                {
                                    DrawInvGrid.tip.hide();
                                }
                        
            }  }});
        });  
    var showTipRowIndex=-1;
    DrawInvGrid.render();
    /*------DataGrid的函数结束 End---------------*/


QueryDataGrid();

DrawInvGrid.on('rowdblclick', function(grid, rowIndex, e) {
    //弹出商品明细
var _record = DrawInvGrid.getStore().getAt(rowIndex).data.DrawInvId;
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
                        url: 'frmDrawInvWaitOut.aspx?method=getDtlInfo',
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

})

</script>

</html>
