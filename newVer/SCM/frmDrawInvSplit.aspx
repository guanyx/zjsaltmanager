<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmDrawInvSplit.aspx.cs" Inherits="SCM_frmDrawInvSplit" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>领货单分割</title>
<link rel="stylesheet" type="text/css" href="../ext3/resources/css/ext-all.css" />
<script type="text/javascript" src="../ext3/adapter/ext/ext-base.js"></script>
<script type="text/javascript" src="../ext3/ext-all.js"></script>
<script type="text/javascript" src="../js/operateResp.js"></script>
<script type="text/javascript" src="../ext3/src/locale/ext-lang-zh_CN.js"></script>
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
            text: "分割",
            icon: "../Theme/1/images/extjs/customer/add16.gif",
            handler: function() { popModifyWin(); }
        }, '-', {
            text: "打印",
            icon: "../Theme/1/images/extjs/customer/edit16.gif",
            handler: function() { }
        }
                   ]
    });
    /*------结束toolbar的函数 end---------------*/


    //领货单列表
    function QueryDataGrid() {
        DrawInvGridData.baseParams.CustomerNo = Ext.getCmp('CustomerId').getValue();
        DrawInvGridData.baseParams.StartDate = Ext.util.Format.date(Ext.getCmp('StartDate').getValue(), 'Y/m/d');
        DrawInvGridData.baseParams.EndDate = Ext.util.Format.date(Ext.getCmp('EndDate').getValue(), 'Y/m/d');
        DrawInvGridData.load({
            params: {
                start: 0,
                limit: 10
            }
        });
    }


    //弹出窗体明细查询
    function QueryDrawDtlDataGrid() {
        var sm = DrawInvGrid.getSelectionModel();
        var selectData = sm.getSelected();
        //如果没有选择，就提示需要选择数据信息
        if (selectData == null || selectData == "") {
            Ext.Msg.alert("提示", "请选中需要分割的单据！");
            return;
        }
        ModDtlGridData.load({
            params: {
                start: 0,
                limit: 20,
                DrawInvId: selectData.data.DrawInvId
            }
        });
    }

    //弹出窗体显示
    function popModifyWin() {
        var sm = DrawInvGrid.getSelectionModel();
        //获取选择的数据信息
        var selectData = sm.getSelected();
        if (selectData == null) {
            Ext.Msg.alert("提示", "请选中需要编辑的信息！");
            return;
        }
        openModWin.show();
        Ext.getCmp("CustomerCode").setValue(selectData.data.CustomerCode);
        Ext.getCmp("CustomerName").setValue(selectData.data.CustomerName);
        Ext.getCmp("DrawType").setValue(selectData.data.DrawType);
        Ext.getCmp("TotalQty").setValue(selectData.data.TotalQty);
        Ext.getCmp("TotalAmt").setValue(selectData.data.TotalAmt);
        QueryDrawDtlDataGrid();
    }


    //保存
    function saveUpdate() {
        //check
        var isCheck = true;
        ModDtlGridData.each(function(record) {
            var productid = record.get('ProductId');
            if (productid != undefined && productid != null && productid != "" && parseInt(productid) > 0) {
                if (record.get('CheckQty') > record.get('DrawQty')) {
                    Ext.Msg.alert("提示", "预提数量不能大于总数量！");
                    isCheck = false;
                    return;
                }
            }
        });

        if (!isCheck)
            return;

        //获取主表信息
        var sm = DrawInvGrid.getSelectionModel();
        var selectData = sm.getSelected();
        //组装明细表信息
        var json = "";
        ModDtlGridData.each(function(ModDtlGridData) {
            json += Ext.util.JSON.encode(ModDtlGridData.data) + ',';
        });

        var sendDate = Ext.getCmp('SendDate').getValue();
        Ext.Ajax.request({
            url: 'frmDrawInvSplit.aspx?method=saveUpdate',
            method: 'POST',
            params: {
                DrawInvId: selectData.data.DrawInvId,
                SendDate: Ext.util.Format.date(sendDate, 'Y/m/d'),
                //明细参数
                DetailInfo: json
            },
            success: function(resp, opts) { Ext.Msg.alert("提示", "保存成功"); openModWin.hide(); DrawInvGridData.reload(); },
            failure: function(resp, opts) { Ext.Msg.alert("提示", "保存失败"); }
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
                            url: 'frmDrawInvSplit.aspx?method=getDrawInvList',
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
	                            }


	                            	])

	            ,sortData: function(f, direction) {
                    var tempSort = Ext.util.JSON.encode(DrawInvGridData.sortInfo);
                    if (sortInfor != tempSort) {
                        sortInfor = tempSort;
                        DrawInvGridData.baseParams.SortInfo = sortInfor;
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
        QueryDataGrid();
    }, toolBar);
    /*------开始DataGrid的函数 start---------------*/

    var sm = new Ext.grid.CheckboxSelectionModel({
        singleSelect: true
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
		                        header: '数量',
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
    
//    DrawInvGrid.on('render', function(grid) {
//        var store = grid.getStore();  // Capture the Store.  
//        var view = grid.getView();    // Capture the GridView.
//        DrawInvGrid.tip = new Ext.ToolTip({
//            target: view.mainBody,    // The overall target element.  
//            delegate: '.x-grid3-row', // Each grid row causes its own seperate show and hide.  
//            trackMouse: true,         // Moving within the row should not hide the tip.  
//            renderTo: document.body,  // Render immediately so that tip.body can be referenced prior to the first show.  
//            listeners: {              // Change content dynamically depending on which element triggered the show.  
//                beforeshow: function updateTipBody(tip) {
//                    var rowIndex = view.findRowIndex(tip.triggerElement);
//                    tip.body.dom.innerHTML = "可以双击此行查看出库明细！ "; //store.getAt(rowIndex).id  
//                }
//            }
//        });
//    });
    DrawInvGrid.render();
    /*------DataGrid的函数结束 End---------------*/




    ////////////////////////Start 修改界面///////////////////////////////////////////////////////////////////////

    var modDtlForm = new Ext.FormPanel({
        labelAlign: 'left',
        buttonAlign: 'right',
        bodyStyle: 'padding:5px',
        frame: true,
        labelWidth: 80,
        items: [
	                {
	                    layout: 'column',
	                    border: false,
	                    labelSeparator: '：',
	                    items: [
		                {
		                    layout: 'form',
		                    border: false,
		                    columnWidth: 0.33,
		                    items: [
				                {
				                    xtype: 'textfield',
				                    fieldLabel: '客户编码',
				                    columnWidth: 0.33,
				                    anchor: '90%',
				                    name: 'CustomerCode',
				                    id: 'CustomerCode',
				                    editable: false
				                }
		                            ]
		                }
                , {
                    layout: 'form',
                    border: false,
                    columnWidth: 0.33,
                    items: [
				                {
				                    xtype: 'textfield',
				                    fieldLabel: '客户名称',
				                    columnWidth: 0.5,
				                    anchor: '90%',
				                    name: 'CustomerName',
				                    id: 'CustomerName',
				                    editable: false
				                }
		                ]
                }
                , {
                    layout: 'form',
                    border: false,
                    columnWidth: 0.34,
                    items: [
				                {
				                    xtype: 'combo',
				                    store: dsDrawType,
				                    valueField: 'DicsCode',
				                    displayField: 'DicsName',
				                    mode: 'local',
				                    forceSelection: true,
				                    editable: false,
				                    emptyValue: '',
				                    triggerAction: 'all',
				                    fieldLabel: '单据类型',
				                    name: 'DrawType',
				                    id: 'DrawType',
				                    selectOnFocus: true,
				                    anchor: '90%',
				                    editable: false
				                }
		                          ]
                }
	                ]
	                },
	                {
	                    layout: 'column',
	                    border: false,
	                    labelSeparator: '：',
	                    items: [
		                {
		                    layout: 'form',
		                    border: false,
		                    columnWidth: 0.33,
		                    items: [
				                {
				                    xtype: 'textfield',
				                    fieldLabel: '总数量',
				                    columnWidth: 0.5,
				                    anchor: '90%',
				                    name: 'TotalQty',
				                    id: 'TotalQty',
				                    editable: false
				                }
		                          ]
		                }
                , {
                    layout: 'form',
                    border: false,
                    columnWidth: 0.33,
                    items: [
				                {
				                    xtype: 'textfield',
				                    fieldLabel: '总金额',
				                    columnWidth: 0.5,
				                    anchor: '90%',
				                    name: 'TotalAmt',
				                    id: 'TotalAmt',
				                    editable: false
				                }
		                          ]
                }
                , {
                    layout: 'form',
                    border: false,
                    columnWidth: 0.34,
                    items: [
		                    {
		                        xtype: 'datefield',
		                        fieldLabel: '送货日期*',
		                        anchor: '90%',
		                        id: 'SendDate',
		                        name: 'SendDate',
		                        format: 'Y年m月d日',
		                        value: new Date().clearTime(),
		                        editable: false
		                    }
		                    ]
                }
	                ]
	                }
                ]
    });

    /*------开始获取数据的函数 start---------------*/
    var ModDtlGridData = new Ext.data.Store
                        ({
                            url: 'frmDrawInvSplit.aspx?method=getDrawDtlList',
                            reader: new Ext.data.JsonReader({
                                totalProperty: 'totalProperty',
                                root: 'root'
                            }, [
                                {
                                    name: 'DrawInvDtlId'
                                },
	                            {
	                                name: 'DrawInvId'
	                            },
	                            {
	                                name: 'ProductId'
	                            },
	                            {
	                                name: 'DrawQty'
	                            },
	                            {
	                                name: 'CheckQty'
	                            },
	                            {
	                                name: 'Price'
	                            },
	                            {
	                                name: 'Amt'
	                            },
	                            {
	                                name: 'Tax'
	                            },
	                            {
	                                name: 'SpecName'
	                            },
	                            {
	                                name: 'ProductCode'
	                            },
	                            {
	                                name: 'UnitId'
	                            },
	                            {
	                                name: 'UnitName'
	                            },
	                            {
	                                name: 'ProductName'
}])

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
    var ModOrderDtlGrid = new Ext.grid.EditorGridPanel({
        autoScroll: true,
        height: 220,
        id: '',
        store: ModDtlGridData,
        loadMask: { msg: '正在加载数据，请稍侯……' },
        sm: sm,
        cm: new Ext.grid.ColumnModel([
		                    sm,
		                    new Ext.grid.RowNumberer(), //自动行号
		                    {
		                    header: '商品代码',
		                    dataIndex: 'ProductCode',
		                    id: 'ProductCode'
		                },
		                    {
		                        header: '名称',
		                        dataIndex: 'ProductName',
		                        id: 'ProductName'
		                    },
                            {
                                header: '单位',
                                dataIndex: 'UnitId',
                                id: 'UnitId',
                                hidden: true,
                                hideable: true
                            },
		                    {
		                        header: '单位',
		                        dataIndex: 'UnitName',
		                        id: 'UnitName'
		                    },
		                    {
		                        header: '规格',
		                        dataIndex: 'SpecName',
		                        id: 'SpecName'
		                    },
		                    {
		                        header: '总数量',
		                        dataIndex: 'DrawQty',
		                        id: 'DrawQty'
		                    },
		                    {
		                        header: '预提数量',
		                        dataIndex: 'CheckQty',
		                        id: 'CheckQty',
		                        editor: new Ext.form.NumberField({ allowBlank: false }),
		                        renderer: function(v, m) {
		                            m.css = 'x-grid-back-blue';
		                            return v;
		                        }
		                    },
		                    {
		                        header: '单价',
		                        dataIndex: 'Price',
		                        id: 'Price'
		                    }

		                    ]),
        bbar: new Ext.PagingToolbar({
            pageSize: 20,
            store: ModDtlGridData,
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
        closeAction: 'hide',
        stripeRows: true,
        loadMask: true,
        autoExpandColumn: 2

    });
    ModOrderDtlGrid.on("afterrender", function(component) {
        component.getBottomToolbar().refresh.hideParent = true;
        component.getBottomToolbar().refresh.hide();
    });

    if (typeof (openModWin) == "undefined") {//解决创建2个windows问题
        openModWin = new Ext.Window({
            id: 'openModWin',
            title: '领货单分割'
		            , iconCls: 'upload-win'
		            , width: 750
		            , height: 400
		            , layout: 'form'
		            , plain: true
		            , modal: true
		            , constrain: true
		            , resizable: false
		            , closeAction: 'hide'
		            , autoDestroy: true
		            , items: [

                         { layout: 'form',
                             border: false,
                             columnWidth: 1,
                             items: [modDtlForm]
                         },
                         { layout: 'form',
                             border: false,
                             columnWidth: 1,
                             items: [ModOrderDtlGrid]
                         }

		            ]
		            , buttons: [{
		                text: "保存"
			            , handler: function() {
			                saveUpdate();

			            }
			            , scope: this
		            },
		            {
		                text: "取消"
			            , handler: function() {
			                openModWin.hide();
			                DrawInvGridData.reload();
			            }
			            , scope: this
}]
        });
    }
    openModWin.addListener("hide", function() {
    });



    ////////////////////////End 修改界面///////////////////////////////////////////////////////////////////////


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
            pageSize: 20,
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
