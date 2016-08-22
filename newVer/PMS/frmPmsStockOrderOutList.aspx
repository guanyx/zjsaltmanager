<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmPmsStockOrderOutList.aspx.cs" Inherits="PMS_frmPmsStockOrder" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html>
<head>
<title>生产出入库登记</title><meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<link rel="stylesheet" type="text/css" href="../ext3/resources/css/ext-all.css" />
<script type="text/javascript" src="../ext3/adapter/ext/ext-base.js"></script>
<script type="text/javascript" src="../ext3/ext-all.js"></script>
<script type="text/javascript" src="../js/operateResp.js"></script>
<script type="text/javascript" src="../ext3/src/locale/ext-lang-zh_CN.js"></script>
</head>
<body>
<div id='toolbar'></div>
<div id='divForm'></div>
<div id='dataGrid'></div>
<%=getComboBoxStore() %>
</body>
<script type="text/javascript">
Ext.BLANK_IMAGE_URL = "../ext3/resources/images/default/s.gif";
Ext.onReady(function() {
    var saveType;
    /*------实现toolbar的函数 start---------------*/
    var Toolbar = new Ext.Toolbar({
        renderTo: "toolbar",
        items: [{
            text: "新增",
            icon: "../Theme/1/images/extjs/customer/add16.gif",
            handler: function() {
                saveType = 'addOrder';
                openAddOrderWin();
            }
        }, '-', {
            text: "编辑",
            icon: "../Theme/1/images/extjs/customer/edit16.gif",
            handler: function() {
                saveType = 'saveOrder';
                modifyOrderWin();
            }
        }, '-', {
            text: "删除",
            icon: "../Theme/1/images/extjs/customer/delete16.gif",
            handler: function() {
                deleteOrder();
            }
}, '-', {
                text: "打印",
                icon: "../Theme/1/images/extjs/customer/edit16.gif",
                handler: function() {
                    printOrderById();
                }
            }]
        });

        /*------结束toolbar的函数 end---------------*/
function getUrl(imageUrl)
            {
                var index = window.location.href.toLowerCase().indexOf('/pms/');
                var tempUrl = window.location.href.substring(0,index);
                return tempUrl+"/"+imageUrl;
            }
function printOrderById()
{
var sm = pmsstockorderGrid.getSelectionModel();
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
                //页面提交
                Ext.Ajax.request({
                    url: 'frmPmsStockOrderInList.aspx?method=getprintdata',
//                    url:'frmOrderMst.aspx?method=billdata',
                    method: 'POST',
                    params: {
                        OrderId: orderIds
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
		           failure: function(resp,opts){  /* Ext.Msg.alert("提示","保存失败"); */    }
                });
}


        /*------开始ToolBar事件函数 start---------------*//*-----新增Order实体类窗体函数----*/
        function openAddOrderWin() {
            uploadOrderWindow.show();
        }
        /*-----编辑Order实体类窗体函数----*/
        function modifyOrderWin() {
            var sm = pmsstockorderGrid.getSelectionModel();
            //获取选择的数据信息
            var selectData = sm.getSelected();
            if (selectData == null) {
                Ext.Msg.alert("提示", "请选中需要编辑的信息！");
                return;
            }
            uploadOrderWindow.show();
            setFormValue(selectData);
        }
        /*-----删除Order实体函数----*/
        /*删除信息*/
        function deleteOrder() {
            var sm = pmsstockorderGrid.getSelectionModel();
            //获取选择的数据信息
            var selectData = sm.getSelected();
            //如果没有选择，就提示需要选择数据信息
            if (selectData == null) {
                Ext.Msg.alert("提示", "请选中需要删除的信息！");
                return;
            }
            //删除前再次提醒是否真的要删除
            Ext.Msg.confirm("提示信息", "是否真的要删除选择的信息吗？", function callBack(id) {
                //判断是否删除数据
                if (id == "yes") {
                    //页面提交
                    Ext.Ajax.request({
                        url: 'frmPmsStockOrderOutList.aspx?method=deleteOrder',
                        method: 'POST',
                        params: {
                            OrderId: selectData.data.OrderId
                        },
                        success: function(resp, opts) {
                            Ext.Msg.alert("提示", "数据删除成功");
                        },
                        failure: function(resp, opts) {
                            Ext.Msg.alert("提示", "数据删除失败");
                        }
                    });
                }
            });
        }

        /*------实现FormPanle的函数 start---------------*/

        //定义下拉框异步调用方法,当前客户可订商品列表
        var dsProductUnits = new Ext.data.Store({
            url: '../scm/frmOrderDtl.aspx?method=getProductUnits',
            params: {
                ProductId: 0
            },
            reader: new Ext.data.JsonReader({
                root: 'root',
                totalProperty: 'totalProperty',
                id: 'ProductUnits'
            }, [
                { name: 'UnitId', mapping: 'UnitId' },
                { name: 'UnitName', mapping: 'UnitName' }
            ]),
            listeners: {
                load: function() {
                    var combo = Ext.getCmp('OutStor');
                    combo.setValue(combo.getValue());
                }
            }
        });
        dsProductUnits.load();

        // 定义下拉框异步返回显示模板
        var resultTpl = new Ext.XTemplate(
        '<tpl for="."><div id="searchdivid" class="search-item">',
            '<h3><span><font color=blue>{ProductNo}</font>&nbsp;&nbsp;{ProductName}&nbsp;&nbsp;{SpecificationsText}</span></h3>',
        '</div></tpl>'
         );

        var pmsstockorderform = new Ext.form.FormPanel({
            url: '',
            frame: true,
            title: '',
            labelWidth: 55,
            items: [
		{
		    xtype: 'hidden',
		    fieldLabel: '订单号',
		    name: 'OrderId',
		    id: 'OrderId',
		    hidden: true,
		    hideLabel: false
		}
, {
    layout: 'column',
    items: [
            {
                layout: 'form',
                columnWidth: .48,
                items: [
                {
                    xtype: 'combo',
                    fieldLabel: '车间',
                    anchor: '98%',
                    name: 'WsId',
                    id: 'WsId',
                    store: dsWs,
                    displayField: 'WsName',
                    valueField: 'WsId',
                    mode: 'local',
                    triggerAction: 'all',
                    editable: false
                }
                ]
            },
            {
                layout: 'form',
                columnWidth: .48,
                items: [
                {
                    xtype: 'combo',
                    fieldLabel: '仓库',
                    columnWidth: 1,
                    anchor: '98%',
                    name: 'AuxWhId',
                    id: 'AuxWhId',
                    store: dsWarehouseList,
                    displayField: 'WhName',
                    valueField: 'WhId',
                    mode: 'local',
                    triggerAction: 'all',
                    editable: false
                }
                ]
            }
            ]
}
, {
    layout: 'column',
    items: [
            {
                layout: 'form',
                columnWidth: .48,
                items: [
                {
                    xtype: 'combo',
                    fieldLabel: '领料',
                    columnWidth: 1,
                    anchor: '98%',
                    name: 'AuxProductId',
                    id: 'AuxProductId',
                    store: dsStockProductList,
                    displayField: 'ProductName',
                    valueField: 'ProductId',
                    triggerAction: 'all',
                    //typeAhead: true,
                    tpl: resultTpl,
                    itemSelector: 'div.search-item', 
                    listWidth:300,
                    mode: 'local',
                    emptyText: '',
                    selectOnFocus: true,
                    editable: true,
                    listeners: {
                        "select": beforeEdit
                    }

                }
			    ]
            },
			{
			    layout: 'form',
			    columnWidth: .3,
			    items: [
                {
                    xtype: 'numberfield',
                    fieldLabel: '数量',
                    columnWidth: 1,
                    anchor: '98%',
                    name: 'Qty',
                    id: 'Qty'
                }
			    ]
			}, {
			    layout: 'form',
			    columnWidth: .175,
			    items: [
                {
                    //                    xtype: 'combo',
                    //                    fieldLabel: '单位',
                    //                    columnWidth: 1,
                    //                    anchor: '98%',
                    //                    name: 'UnitId',
                    //                    id: 'UnitId',
                    //                    store: dsProductUnits,
                    //                    displayField: 'UnitName',
                    //                    valueField: 'UnitId',
                    //                    //                    mode: 'local',
                    //                    //                    triggerAction: 'all',
                    //                    mode: 'local',
                    //                    forceSelection: true,
                    //                    editable: false,
                    //                    emptyValue: '',
                    //                    triggerAction: 'all',
                    //                    selectOnFocus: true,
                    //                    anchor: '98%',

                    xtype: 'combo',
                    store: dsProductUnits, //dsWareHouse,
                    valueField: 'UnitId',
                    displayField: 'UnitName',
                    mode: 'local',
                    forceSelection: true,
                    editable: false,
                    name: 'OutStor',
                    id: 'OutStor',
                    emptyValue: '',
                    triggerAction: 'all',
                    hideLabel:true,
                    selectOnFocus: true,
                    anchor: '98%'
                }
			    ]
}]
}
, {
    layout: 'column',
    items: [
            {
                layout: 'form',
                columnWidth: .3,
                items: [
                {
                    xtype: 'combo',
                    fieldLabel: '操作类型',
                    columnWidth: 1,
                    anchor: '95%',
                    name: 'IsOutOrder',
                    id: 'IsOutOrder',
                    store: dsStatus,
                    displayField: 'DicsName',
                    valueField: 'DicsCode',
                    triggerAction: 'all',
                    typeAhead: true,
                    mode: 'local',
                    emptyText: '',
                    selectOnFocus: false,
                    value: dsStatus.getAt(1).data.DicsCode,
                    disabled: true
}]
                },
			{
			    layout: 'form',
			    columnWidth: .685,
			    items: [
                {
                    xtype: 'textfield',
                    fieldLabel: '原始单号',
                    columnWidth: 1,
                    anchor: '95%',
                    name: 'InitOrderId',
                    id: 'InitOrderId'
}]
			}
			]
}
, {
    xtype: 'textarea',
    fieldLabel: '备注',
    columnWidth: 1,
    anchor: '95%',
    name: 'Remark',
    id: 'Remark'
}
]
        });
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
                             var text = record.get('ProductNo');  
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
        Ext.getCmp('AuxProductId').on('beforequery',function(qe){  
            regexValue(qe);
        }); 
        var dsIndv = new Ext.data.Store({
            url: 'frmPmsStockOrderOutList.aspx?method=getProductIndv',
            reader: new Ext.data.JsonReader({
                root: 'root',
                totalProperty: 'totalProperty'
            }, [
                    { name: 'UnitId', mapping: 'UnitId' }
                ])
        }); 
        /*------FormPanle的函数结束 End---------------*/
        function beforeEdit() {
            var productId = Ext.getCmp('AuxProductId').getValue();
            if (productId != dsProductUnits.baseParams.ProductId) {
                dsProductUnits.baseParams.ProductId = productId;
                dsProductUnits.load({
                callback:function(r){
                    //设置单位
//                    dsIndv.baseParams.ProductId = productId;
//                    dsIndv.load({
//                    callback:function(r){
//                        if(dsIndv.getCount()==1)
//                            Ext.getCmp('OutStor').setValue(dsIndv.getAt(0).get("UnitId")); 
//                    }});
                    }
                });
            }
        }
        /*------开始界面数据的窗体 Start---------------*/
        if (typeof (uploadOrderWindow) == "undefined") {//解决创建2个windows问题
            uploadOrderWindow = new Ext.Window({
                id: 'Orderformwindow',
                title: ''
		, iconCls: 'upload-win'
		, width: 600
		, height: 250
		, layout: 'fit'
		, plain: true
		, modal: true
		, constrain: true
		, resizable: false
		, closeAction: 'hide'
		, autoDestroy: true
		, items: pmsstockorderform
		, buttons: [{
		    text: "保存"
			, handler: function() {
			    saveUserData();
			}
			, scope: this
		},
		{
		    text: "取消"
			, handler: function() {
			    uploadOrderWindow.hide();
			}
			, scope: this
}]
            });
        }
        uploadOrderWindow.addListener("hide", function() {
            pmsstockorderform.getForm().reset();
        });

        /*------开始获取界面数据的函数 start---------------*/
        function saveUserData() {
            if(Ext.getCmp('AuxWhId').getValue()<=0)
            {
                Ext.Msg.alert("提示", "请选择仓库！");
                return;
            }
            if(Ext.getCmp('AuxProductId').getValue()<=0)
            {
                Ext.Msg.alert("提示", "请选择具体品种！");
                return;
            }
            if(Ext.getCmp('Qty').getValue()<=0)
            {
                Ext.Msg.alert("提示", "请输入数量！");
                return;
            }
            if(Ext.getCmp('OutStor').getValue()<=0)
            {
                Ext.Msg.alert("提示", "请选择数量对应的计量单位！");
                return;
            }

            Ext.MessageBox.wait("数据正在保存，请稍候……");
            Ext.Ajax.request({
                url: 'frmPmsStockOrderOutList.aspx?method=' + saveType,
                method: 'POST',
                params: {
                    OrderId: Ext.getCmp('OrderId').getValue(),
                    WsId: Ext.getCmp('WsId').getValue(),
                    AuxWhId: Ext.getCmp('AuxWhId').getValue(),
                    AuxProductId: Ext.getCmp('AuxProductId').getValue(),
                    Qty: Ext.getCmp('Qty').getValue(),
                    InitOrderId: Ext.getCmp('InitOrderId').getValue(),
                    IsOutOrder: Ext.getCmp('IsOutOrder').getValue(),
                    Remark: Ext.getCmp('Remark').getValue(),
                    UnitId: Ext.getCmp('OutStor').getValue()
                },
                success: function(resp, opts) {
                    Ext.MessageBox.hide();
                    if( checkExtMessage(resp) )
                    {
                        //Ext.Msg.alert("提示", "保存成功");
                        uploadOrderWindow.hide();
                        QueryData();			            
                    }
                },
                failure: function(resp, opts) {
                    Ext.MessageBox.hide();
                    Ext.Msg.alert("提示", "保存失败");
                }
            });
        }
        /*------结束获取界面数据的函数 End---------------*/

        /*------开始界面数据的函数 Start---------------*/
        function setFormValue(selectData) {
            Ext.Ajax.request({
                url: 'frmPmsStockOrderOutList.aspx?method=getorder',
                params: {
                    OrderId: selectData.data.OrderId
                },
                success: function(resp, opts) {
                    var data = Ext.util.JSON.decode(resp.responseText);
                    Ext.getCmp("OrderId").setValue(data.OrderId);
                    Ext.getCmp("WsId").setValue(data.WsId);
                    Ext.getCmp("AuxWhId").setValue(data.AuxWhId);
                    Ext.getCmp("AuxProductId").setValue(data.AuxProductId);
                    beforeEdit();
                    Ext.getCmp("Qty").setValue(data.Qty);
                    Ext.getCmp("InitOrderId").setValue(data.InitOrderId);
                    Ext.getCmp("IsOutOrder").setValue(data.IsOutOrder);
                    Ext.getCmp("Remark").setValue(data.Remark);
                    Ext.getCmp("OutStor").setValue(data.UnitId);
                },
                failure: function(resp, opts) {
                    Ext.Msg.alert("提示", "获取领料信息失败");
                }
            });
        }
        /*------结束设置界面数据的函数 End---------------*/
        /*------开始查询form end---------------*/
        //车间名称
        var WsNamePanel = new Ext.form.ComboBox({
            xtype: 'combo',
            fieldLabel: '车间',
            anchor: '95%',
            store: dsWs,
            displayField: 'WsName',
            valueField: 'WsId',
            mode: 'local',
            triggerAction: 'all',
            editable: false
        });

        //原始单据编号
        var iniOrderIdPanel = new Ext.form.TextField({
            xtype: 'textfield',
            fieldLabel: '原始单据编号',
            anchor: '95%'
        });
        //仓库
        var ckCombo = new Ext.form.ComboBox({
            xtype: 'combo',
            fieldLabel: '仓库',
            anchor: '95%',
            store: dsWarehouseList,
            displayField: 'WhName',
            valueField: 'WhId',
            mode: 'local',
            triggerAction: 'all',
            editable: false
        });

        //成品
        var productCombo = new Ext.form.ComboBox({
            xtype: 'combo',
            fieldLabel: '成品',
            anchor: '95%',
            store: dsStockProductList,
            displayField: 'ProductName',
            valueField: 'ProductId',
            triggerAction: 'all',
            typeAhead: true,
            mode: 'local',
            emptyText: '',
            selectOnFocus: false,
            editable: true
        });

        var serchform = new Ext.FormPanel({
            el: 'divForm',
            id: 'serchform',
            labelAlign: 'left',
            buttonAlign: 'right',
            bodyStyle: 'padding:5px',
            frame: true,
            items: [{
                layout: 'column',   //定义该元素为布局为列布局方式
                border: false,
                items: [{
                    columnWidth: .4,  //该列占用的宽度，标识为20％
                    layout: 'form',
                    border: false,
                    labelWidth: 55,
                    items: [
                WsNamePanel
            ]
                }, {
                    columnWidth: .4,
                    layout: 'form',
                    border: false,
                    labelWidth: 80,
                    items: [
                iniOrderIdPanel
                ]
}]
                },{
                layout: 'column',   //定义该元素为布局为列布局方式
                border: false,
                items: [{
                    columnWidth: .4,  //该列占用的宽度，标识为20％
                    layout: 'form',
                    border: false,
                    labelWidth: 55,
                    items: {
                         cls: 'key',
                        xtype: 'datefield',
                        fieldLabel: '开始日期',
                        anchor: '95%',
                        id:'startDate',
                        name:'startDate',
                        format: "Y-m-d"
                        
                    }
                }, {
                    columnWidth: .4,
                    layout: 'form',
                    border: false,
                    labelWidth: 80,
                    items: {
                        cls: 'key',
                        xtype: 'datefield',
                        fieldLabel: '结束时间',
                        anchor: '95%',
                        id:'endDate',
                        name:'endDate',
                        format: "Y-m-d"
                        }
}]
                },
    {
        layout: 'column',   //定义该元素为布局为列布局方式
        border: false,
        items: [{
            name: 'cusStyle',
            columnWidth: .4,
            layout: 'form',
            border: false,
            labelWidth: 55,
            items: [
                ckCombo
            ]
        }, {
            name: 'cusStyle',
            columnWidth: .4,
            layout: 'form',
            border: false,
            labelWidth: 80,
            items: [
                productCombo
            ]
        }, {
            layout: 'form',
            columnWidth: .2,
            border: false,
            items: [{ cls: 'key',
                xtype: 'button',
                text: '查询',
                anchor: '50%',
                handler: function() {

                    QueryData();
                }
}]
}]
}]
            });
            serchform.render();

            function QueryData() {
                var strWsId = WsNamePanel.getValue();
                var striniOrderId = iniOrderIdPanel.getValue();
                var WhId = ckCombo.getValue();
                var ProductId = productCombo.getValue();

                dspmsstockorder.baseParams.WorkshopId = strWsId;
                dspmsstockorder.baseParams.IniOrderId = striniOrderId;
                dspmsstockorder.baseParams.WhId = WhId;
                dspmsstockorder.baseParams.ProductId = ProductId;
                dspmsstockorder.baseParams.IsOutOrder = 'out';
                dspmsstockorder.baseParams.StartDate=document.getElementById("startDate").value;
                dspmsstockorder.baseParams.EndDate=document.getElementById("endDate").value;
                dspmsstockorder.load({
                    params: {
                        start: 0,
                        limit: 10
                    }
                });

            }
            /*------开始查询form end---------------*/
            /*------开始获取数据的函数 start---------------*/
            var dspmsstockorder = new Ext.data.Store
({
    url: 'frmPmsStockOrderOutList.aspx?method=getOrderList',
    reader: new Ext.data.JsonReader({
        totalProperty: 'totalProperty',
        root: 'root'
    }, [
	{ name: 'OrderId' },
	{ name: 'OrgId' },
	{ name: 'WsId' },
	{ name: 'AuxWhId' },
	{ name: 'AuxProductId' },
	{ name: 'Qty' },
	{ name: 'InitOrderId' },
	{ name: 'IsOutOrder' },
	{ name: 'CreateDate' },
	{ name: 'UpdateDate' },
	{ name: 'OperId' },
	{ name: 'OwnerId' },
	{ name: 'Remark'
}])
	,
	sortData: function(f, direction) {
        var tempSort = Ext.util.JSON.encode(dspmsstockorder.sortInfo);
        if (sortInfor != tempSort) {
            sortInfor = tempSort;
            dspmsstockorder.baseParams.SortInfo = sortInfor;
            dspmsstockorder.load({ params: { limit: defaultPageSize, start: 0} });
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
        store: dspmsstockorder,
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
                singleSelect: true
            });
            var pmsstockorderGrid = new Ext.grid.GridPanel({
                el: 'dataGrid',
                width: '100%',
                height: '100%',
                autoWidth: true,
                autoHeight: true,
                autoScroll: true,
                layout: 'fit',
                id: '',
                store: dspmsstockorder,
                loadMask: { msg: '正在加载数据，请稍侯……' },
                sm: sm,
                cm: new Ext.grid.ColumnModel([
		sm,
		new Ext.grid.RowNumberer(), //自动行号
		{
		header: '订单号',
		dataIndex: 'OrderId',
		id: 'OrderId',
		hidden: true,
		hideable: false
},
		{
		    header: '车间',
		    dataIndex: 'WsId',
		    id: 'WsId',
		    sortable: true,
		    renderer: function(val) {
		        dsWs.each(function(r) {
		            if (val == r.data['WsId']) {
		                val = r.data['WsName'];
		                return;
		            }
		        });
		        return val;
		    }
		},
		{
		    header: '仓库',
		    dataIndex: 'AuxWhId',
		    id: 'AuxWhId',
		    sortable: true,
		    renderer: function(val) {
		        dsWarehouseList.each(function(r) {
		            if (val == r.data['WhId']) {
		                val = r.data['WhName'];
		                return;
		            }
		        });
		        return val;
		    }
		},
		{
		    header: '原料',
		    dataIndex: 'AuxProductId',
		    id: 'AuxProductId',
		    sortable: true,
		    renderer: function(val) {
		        dsStockProductList.each(function(r) {
		            if (val == r.data['ProductId']) {
		                val = r.data['ProductName'];
		                return;
		            }
		        });
		        return val;
		    }
		},
		{
		    header: '数量',
		    dataIndex: 'Qty',
		    id: 'Qty'
		},
		{
		    header: '原始单号',
		    dataIndex: 'InitOrderId',
		    id: 'InitOrderId'
		},
		{
		    header: '操作类型',
		    dataIndex: 'IsOutOrder',
		    id: 'IsOutOrder',
		    renderer: function(val) {
		        dsStatus.each(function(r) {
		            if (val == r.data['DicsCode']) {
		                val = r.data['DicsName'];
		                return;
		            }
		        });
		        return val;
		    }
		},
		{
		    header: '领料时间',
		    dataIndex: 'CreateDate',
		    sortable: true,
		    id: 'CreateDate'
		},
		{
		    header: '备注',
		    dataIndex: 'Remark',
		    sortable: true,
		    id: 'Remark'
		}
		]),
                bbar:toolBar,
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
            pmsstockorderGrid.render();
            /*------DataGrid的函数结束 End---------------*/

            QueryData();

        })
</script>

</html>
