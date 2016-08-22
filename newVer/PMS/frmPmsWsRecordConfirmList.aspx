<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmPmsWsRecordConfirmList.aspx.cs" Inherits="PMS_frmPmsWsRecord" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html>
<head>
<title>车间生产登记审核</title><meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<link rel="stylesheet" type="text/css" href="../ext3/resources/css/ext-all.css" />
<script type="text/javascript" src="../ext3/adapter/ext/ext-base.js"></script>
<script type="text/javascript" src="../ext3/ext-all.js"></script>
<script type="text/javascript" src="../js/operateResp.js"></script>
<script type="text/javascript" src="../ext3/src/locale/ext-lang-zh_CN.js"></script>
<style type="text/css">
.x-grid-back-blue {  
    background: #C3D9FF;  
}  
</style>
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
            text: "审核",
            icon: "../Theme/1/images/extjs/customer/edit16.gif",
            handler: function() {
                saveType = 'confirmWorkshop';
                modifyRecordWin();
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
var sm = pmswsrecordGrid.getSelectionModel();
                //多选
                var selectData = sm.getSelections();                
                var array = new Array(selectData.length);
                var orderIds = "";
                for(var i=0;i<selectData.length;i++)
                {
                    if(orderIds.length>0)
                        orderIds+=",";
                    orderIds += selectData[i].get('RecodrId');
                }
                //页面提交
                Ext.Ajax.request({
                    url: 'frmPmsWsRecordList.aspx?method=getprintdata',
//                    url:'frmOrderMst.aspx?method=billdata',
                    method: 'POST',
                    params: {
                        RecordId: orderIds
                    },
                   success: function(resp,opts){ 
                       var printData =  resp.responseText;
                       var printControl =  parent.parent.parent.document.getElementById("topFrame").contentWindow.getPrintControl();
                       printControl.Url =getUrl('xml');
                       printControl.MapUrl = printControl.Url+'/'+printStyleXml;//'/salePrint1.xml';
                       printControl.PrintXml = printData;
                       printControl.ColumnName="RecordId";
                       printControl.OnlyData=printOnlyData;
                       printControl.PageWidth=printPageWidth;
                       printControl.PageHeight =printPageHeight ;
                       printControl.Print();
//                    var billControl = document.getElementById('billControl');
//                    billControl.PrintXml = printData;
//                    billControl.setFormValue(0);
                       
                   },
		           failure: function(resp,opts){  /* Ext.Msg.alert("提示","保存失败"); */    }
                });
}

        /*------开始ToolBar事件函数 start---------------*//*-----新增Record实体类窗体函数----*/
        /*-----编辑Record实体类窗体函数----*/
        function modifyRecordWin() {
            var sm = pmswsrecordGrid.getSelectionModel();
            //获取选择的数据信息
            var selectData = sm.getSelected();
            if (selectData == null) {
                Ext.Msg.alert("提示", "请选中需要编辑的信息！");
                return;
            }
            if (selectData.data.BizStatus != 'P011') {
                Ext.Msg.alert("提示", "该记录信息不需要审核！");
                return;
            }
            uploadRecordWindow.show();
            setFormValue(selectData);
            setGridValue(selectData);
        }
        /*------实现FormPanle的函数 start---------------*/
        var pmswsrecordform = new Ext.form.FormPanel({
            url: '',
            frame: true,
            title: '',
            region: 'north',
            height: 100,
            labelWidth: 55,
            items: [
	{
	    layout: 'column',
	    items: [
	    {
	        layout: 'form',
	        border: false,
	        columnWidth: .5,
	        items: [
		    {
		        xtype: 'hidden',
		        fieldLabel: '记录ID',
		        name: 'RecodrId',
		        id: 'RecodrId',
		        hidden: true,
		        hideLabel: true
		    },
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
		        disabled: true,
		        listeners: { select: function(combo, record, index) {
		            //刷新班次
		            Ext.getCmp('GroupId').setValue(record.get('GroupIds'));
		            this.collapse();
		        } 
		        }
}]
	    },
		{
		    layout: 'form',
		    border: false,
		    columnWidth: .5,
		    items: [
		    {
		        xtype: 'textfield',
		        fieldLabel: '班次',
		        anchor: '98%',
		        name: 'GroupId',
		        id: 'GroupId',
		        readOnly: true
}]
}]
	},
    {
        layout: 'column',
        items: [
	    {
	        layout: 'form',
	        border: false,
	        columnWidth: .5,
	        items: [
		    {
		        xtype: 'datefield',
		        fieldLabel: '生产日期',
		        columnWidth: 1,
		        anchor: '98%',
		        name: 'ManuDate',
		        id: 'ManuDate',
		        format: 'Y年m月d日',
		        value: new Date().clearTime(),
		        readOnly: true
}]
	    },
		{
		    layout: 'form',
		    border: false,
		    columnWidth: .5,
		    items: [
	        {
	            xtype: 'combo',
	            fieldLabel: '业务状态',
	            columnWidth: 1,
	            anchor: '98%',
	            name: 'BizStatus',
	            id: 'BizStatus',
	            store: dsStatus,
	            displayField: 'DicsName',
	            valueField: 'DicsCode',
	            mode: 'local',
	            triggerAction: 'all',
	            disabled: true,
	            value: dsStatus.getAt(0).data.DicsCode
}]
}]
    },
    {
        layout: 'column',
        items: [
		{
		    layout: 'form',
		    border: false,
		    columnWidth: .5,
		    items: [
	        {
	            xtype: 'combo',
	            fieldLabel: '入库仓库',
	            columnWidth: 1,
	            anchor: '98%',
	            name: 'WhId',
	            id: 'WhId',
	            store: dsWh,
	            displayField: 'WhName',
	            valueField: 'WhId',
	            mode: 'local',
	            triggerAction: 'all',
	            value: dsWh.getAt(0).data.WhId
}]
}]
    }
]
        });
        /*------FormPanle的函数结束 End---------------*/
        /*------明细grid的函数 start---------------*/
        var RowPattern = Ext.data.Record.create([
   { name: 'Id', type: 'string' },
   { name: 'RecordId', type: 'string' },
   { name: 'ProductId', type: 'string' },
   { name: 'SpecificationsText', type: 'string' },   
   { name: 'UnitText', type: 'string' },
   { name: 'ManuQty', type: 'float' },
   { name: 'ManuAmt', type: 'float' },
   { name: 'ProductPrice', type: 'float' },
   { name: 'UnitId', type: 'string' }
 ]);
        var dsRecordDtlInfo = new Ext.data.Store
({
    url: 'frmPmsWsRecordList.aspx?method=getRecordDtlInfoList',
    reader: new Ext.data.JsonReader({
        totalProperty: 'totalProperty',
        root: 'root'
    }, RowPattern)
});
        function inserNewBlankRow() {
            var rowCount = recordDtlInfoGrid.getStore().getCount();
            //alert(rowCount);
            var insertPos = parseInt(rowCount);
            var addRow = new RowPattern({
                Id: '-1',
                RecordId: '-1',
                ProductId: '',
                SpecificationsText: '',                
                UnitText: '',
                ManuQty: '',
                ManuAmt: '',
                ProductPrice: '',
                UnitId: '0'
            });
            recordDtlInfoGrid.stopEditing();
            //增加一新行
            if (insertPos > 0) {
                var rowIndex = dsRecordDtlInfo.insert(insertPos, addRow);
                recordDtlInfoGrid.startEditing(insertPos, 0);
            }
            else {
                var rowIndex = dsRecordDtlInfo.insert(0, addRow);
                recordDtlInfoGrid.startEditing(0, 0);
            }
        }
        function addNewBlankRow(combo, record, index) {
            var rowIndex = recordDtlInfoGrid.getStore().indexOf(recordDtlInfoGrid.getSelectionModel().getSelected());
            var rowCount = recordDtlInfoGrid.getStore().getCount();
            //alert('insertPos:'+rowCount+":"+rowIndex);
            //provideGridDtlData.getSelectionModel().selectRow(rowCount - 1,true);   
            if ((rowIndex == 0 && rowCount == 1) || rowIndex == rowCount - 1) {
                inserNewBlankRow();
            }
        }
        function setGridValue(selectData) {
            dsRecordDtlInfo.baseParams.RecodrId = selectData.data.RecodrId;
            dsRecordDtlInfo.load({
                callback: function(r, options, success) {
                    //inserNewBlankRow();
                    var cm = recordDtlInfoGrid.getColumnModel();
                    cm.setEditable(1, false);
                    cm.setEditable(2, false);
                    cm.setEditable(3, false);
                    cm.setEditable(4, false);
                    cm.setEditable(5, false);
                    cm.setEditable(6, false);
                    cm.setEditable(7, false);
                }
            });
        }

        var smDtl = new Ext.grid.CheckboxSelectionModel({
            singleSelect: true
        });
        /*------开始明细DataGrid的函数 start---------------*/
        var productCombo = new Ext.form.ComboBox({
            store: dsProductList,
            displayField: 'ProductName',
            valueField: 'ProductId',
            triggerAction: 'all',
            id: 'productCombo',
            typeAhead: true,
            mode: 'local',
            emptyText: '',
            selectOnFocus: false,
            editable: true,
            onSelect: function(record) {
                var sm = recordDtlInfoGrid.getSelectionModel().getSelected();
                sm.set('ProductId', record.data.ProductId);
                sm.set('SpecificationsText', record.data.SpecificationsText);
                sm.set('UnitId', record.data.UnitId);
                sm.set('UnitText', record.data.UnitText);
                //隐含字段赋值
                if (sm.get('id') == undefined || sm.get('id') == null || sm.get('id') == "") {
                    sm.set('Id', 0);
                    sm.set('RecordId', 0);
                }
                addNewBlankRow();
                this.collapse();
                var rowid = recordDtlInfoGrid.getStore().indexOf(sm);
                recordDtlInfoGrid.startEditing(rowid, 6);
            }
        });
        var recordDtlInfoGrid = new Ext.grid.EditorGridPanel({
            width: '100%',
            //height:'100%',
            autoWidth: true,
            //autoHeight:true,
            autoScroll: true,
            region: 'center',
            clicksToEdit: 1,
            enableHdMenu: false,  //不显示排序字段和显示的列下拉框
            enableColumnMove: false, //列不能移动
            id: '',
            store: dsRecordDtlInfo,
            loadMask: { msg: '正在加载数据，请稍侯……' },
            sm: smDtl,
            cm: new Ext.grid.ColumnModel([
	    smDtl,
		new Ext.grid.RowNumberer(), //自动行号
		{
		header: '流水号',
		dataIndex: 'Id',
		id: 'Id',
		hidden: true,
		hideable: false
},
		{
		    header: '商品',
		    dataIndex: 'ProductId',
		    id: 'ProductId',
		    width: 150,
		    editor: productCombo,
		    renderer: function(value, cellmeta, record, rowIndex, columnIndex, store) {
		        //解决值显示问题
		        //获取当前id="combo_process"的comboBox选择的值
		        var index = dsProductList.findBy(function(record, id) {
		            return record.get(productCombo.valueField) == value;
		        });
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
		    header: '规格',
		    width: 50,
		    dataIndex: 'SpecificationsText',
		    id: 'SpecificationsText',
		    renderer: { fn: function(value, cellmeta) {
		        cellmeta.css = 'x-grid-back-blue';
		        return value;
		    } 
		    }
		},
		{
		    header: '单位id',
		    width: 50,
		    dataIndex: 'UnitId',
		    id: 'UnitId',
		    hidden:true,
		    hideable:true
		},
		{
		    header: '单位',
		    width: 50,
		    dataIndex: 'UnitText',
		    id: 'UnitText',
		    renderer: { fn: function(value, cellmeta) {
		        cellmeta.css = 'x-grid-back-blue';
		        return value;
		    } 
		    }
		},
		{
		    header: '生产数量',
		    dataIndex: 'ManuQty',
		    id: 'ManuQty',
		    width: 50,
		    editor: new Ext.form.NumberField({ allowBlank: true })
		},
		{
		    header: '生产重量',
		    dataIndex: 'ManuAmt',
		    id: 'ManuAmt',
		    width: 50,
		    editor: new Ext.form.NumberField({ allowBlank: true })
		},
		{
		    header: '价格',
		    dataIndex: 'ProductPrice',
		    id: 'ProductPrice',
		    width: 50,
		    editor: new Ext.form.NumberField({ allowBlank: false })
		}
		]),
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
        /*------明细grid的函数 End---------------*/
        /*------开始界面数据的窗体 Start---------------*/
        if (typeof (uploadRecordWindow) == "undefined") {//解决创建2个windows问题
            uploadRecordWindow = new Ext.Window({
                id: 'Recordformwindow',
                title: '生产登记维护'
		, iconCls: 'upload-win'
		, width: 600
		, height: 400
		, layout: 'border'
		, plain: true
		, modal: true
		, constrain: true
		, resizable: false
		, closeAction: 'hide'
		, autoDestroy: true
		, items: [pmswsrecordform, recordDtlInfoGrid]
		, buttons: [{
		    text: "确认"
			, handler: function() {
			    saveUserData();
			}
			, scope: this
		},
		{
		    text: "取消"
			, handler: function() {
			    uploadRecordWindow.hide();
			}
			, scope: this
}]
            });
        }
        uploadRecordWindow.addListener("hide", function() {
            pmswsrecordform.getForm().reset();
            recordDtlInfoGrid.getStore().removeAll();
        });

        /*------开始获取界面数据的函数 start---------------*/
        function saveUserData() {
            Ext.MessageBox.wait("数据正在审核，请稍候……");
            var json = "";
            dsRecordDtlInfo.each(function(v) {
                json += Ext.util.JSON.encode(v.data) + ',';
            });
            Ext.Ajax.request({
                url: 'frmPmsWsRecordConfirmList.aspx?method=' + saveType,
                method: 'POST',
                params: {
                    RecodrId: Ext.getCmp('RecodrId').getValue(),
                    WsId: Ext.getCmp('WsId').getValue(),
                    //GroupId:Ext.getCmp('GroupId').getValue(),
                    ManuDate: Ext.util.Format.date(Ext.getCmp('ManuDate').getValue(), 'Y/m/d'),
                    BizStatus: Ext.getCmp('BizStatus').getValue(),
                    WhId: Ext.getCmp('WhId').getValue(),
                    DetailInfo: json
                },
                success: function(resp, opts) {
                    Ext.MessageBox.hide();
                    if (checkExtMessage(resp)) {
                        QueryData();
                        
                        uploadRecordWindow.hide();
                    }
                },
                failure: function(resp, opts) {
                    Ext.MessageBox.hide();
                    Ext.Msg.alert("提示", "审核失败");
                }
            });
        }
        /*------结束获取界面数据的函数 End---------------*/

        /*------开始界面数据的函数 Start---------------*/
        function setFormValue(selectData) {
            Ext.Ajax.request({
                url: 'frmPmsWsRecordList.aspx?method=getrecord',
                params: {
                    RecodrId: selectData.data.RecodrId
                },
                success: function(resp, opts) {
                    var data = Ext.util.JSON.decode(resp.responseText);
                    Ext.getCmp("RecodrId").setValue(data.RecodrId);
                    Ext.getCmp("WsId").setValue(data.WsId);
                    Ext.getCmp("GroupId").setValue(data.GroupIds);
                    Ext.getCmp("ManuDate").setValue((new Date(data.ManuDate.replace(/-/g, "/"))));
                    Ext.getCmp("BizStatus").setValue(data.BizStatus);
                },
                failure: function(resp, opts) {
                    Ext.Msg.alert("提示", "获取用户信息失败");
                }
            });
        }
        /*------结束设置界面数据的函数 End---------------*/
        /*------开始查询form end---------------*/

        //生产日期
        var produceStartPanel = new Ext.form.DateField({
            xtype: 'datefield',
            fieldLabel: '生产开始日期',
            anchor: '95%',
            name: 'StartDate',
            id: 'StartDate',
            format: 'Y年m月d日',  //添加中文样式
            value: new Date().clearTime()
        });

        //结束日期
        var produceEndPanel = new Ext.form.DateField({
            xtype: 'datefield',
            fieldLabel: '生产结束日期',
            anchor: '95%',
            name: 'EndDate',
            id: 'EndDate',
            format: 'Y年m月d日',  //添加中文样式
            value: new Date().clearTime()
        });

        var producePostPanel = new Ext.form.TextField({
            style: 'margin-left:0px',
            cls: 'key',
            xtype: 'textfield',
            fieldLabel: '车间名称',
            name: 'nameCust',
            anchor: '95%'
        });

        var serchform = new Ext.FormPanel({
            renderTo: 'divForm',
            labelAlign: 'left',
            layout: 'fit',
            buttonAlign: 'right',
            bodyStyle: 'padding:5px',
            frame: true,
            labelWidth: 80,
            items: [{
                layout: 'column',   //定义该元素为布局为列布局方式
                border: false,
                items: [{
                    columnWidth: .28,  //该列占用的宽度，标识为20％
                    layout: 'form',
                    border: false,
                    items: [
                    produceStartPanel
                ]
                }, {
                    columnWidth: .28,
                    layout: 'form',
                    border: false,
                    items: [
                    produceEndPanel
                    ]
                }, {
                    name: 'cusStyle',
                    columnWidth: .36,
                    layout: 'form',
                    border: false,
                    labelWidth: 55,
                    items: [
                    producePostPanel
                ]
                }, {
                    columnWidth: .08,
                    layout: 'form',
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
                    /*------开始查询form end---------------*/
                    function QueryData() {
                        var starttime = produceStartPanel.getValue();
                        var endtime = produceEndPanel.getValue();
                        var wsinfo = producePostPanel.getValue();

                        dspmswsrecord.baseParams.StartProduceDate = Ext.util.Format.date(starttime, 'Y/m/d');
                        dspmswsrecord.baseParams.EndProduceDate = Ext.util.Format.date(endtime, 'Y/m/d');
                        dspmswsrecord.baseParams.WsName = wsinfo;

                        dspmswsrecord.load({
                            params: {
                                start: 0,
                                limit: 10
}
                            });
                        }
                        /*------开始获取数据的函数 start---------------*/
                        var dspmswsrecord = new Ext.data.Store
({
    url: 'frmPmsWsRecordList.aspx?method=getRecordList',
    reader: new Ext.data.JsonReader({
        totalProperty: 'totalProperty',
        root: 'root'
    }, [
	{ name: 'RecodrId' },
	{ name: 'WsId' },
	{ name: 'WsName' },
	{ name: 'GroupIds' },
	{ name: 'ManuDate' },
	{ name: 'OrgId' },
	{ name: 'OperId' },
	{ name: 'OwnerId' },
	{ name: 'CreateDate' },
	{ name: 'UpdateDate' },
	{ name: 'BizStatus'
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
                            singleSelect: true
                        });
                        var pmswsrecordGrid = new Ext.grid.GridPanel({
                            el: 'dataGrid',
                            width: '100%',
                            height: '100%',
                            autoWidth: true,
                            autoHeight: true,
                            autoScroll: true,
                            layout: 'fit',
                            id: '',
                            store: dspmswsrecord,
                            loadMask: { msg: '正在加载数据，请稍侯……' },
                            sm: sm,
                            cm: new Ext.grid.ColumnModel([
		sm,
		new Ext.grid.RowNumberer(), //自动行号
		{
		header: '记录ID',
		dataIndex: 'RecodrId',
		id: 'RecodrId',
		hidden: true,
		hideable: false
},
		{
		    header: '车间',
		    dataIndex: 'WsName',
		    id: 'WsName'
		},
		{
		    header: '班次',
		    dataIndex: 'GroupIds',
		    id: 'GroupIds'
		},
		{
		    header: '生产日期',
		    dataIndex: 'ManuDate',
		    id: 'ManuDate',
		    format: 'Y年m月d日',
		    renderer: Ext.util.Format.dateRenderer('Y年m月d日')
		},
		{
		    header: '业务状态',
		    dataIndex: 'BizStatus',
		    id: 'BizStatus',
		    renderer: function(val) {
		        dsStatus.each(function(r) {
		            if (val == r.data['DicsCode']) {
		                val = r.data['DicsName'];
		                return;
		            }
		        });
		        return val;
		    }
}]),
                            bbar: new Ext.PagingToolbar({
                                pageSize: 10,
                                store: dspmswsrecord,
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
                        
                        pmswsrecordGrid.on('render', function(grid) {  
        var store = grid.getStore();  // Capture the Store.  
  
        var view = grid.getView();    // Capture the GridView.  
  
        pmswsrecordGrid.tip = new Ext.ToolTip({  
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
                                            url: 'frmPmsWsRecordList.aspx?method=getpmswsdetailinfo',
                                            method: 'POST',
                                            params: {
                                                RecodrId: grid.getStore().getAt(rowIndex).data.RecodrId
                                            },
                                            success: function(resp, opts) {
                                                tip.body.dom.innerHTML = resp.responseText;
                                            },
                                            failure: function(resp, opts) {
                                                pmswsrecordGrid.tip.hide();
                                            }
                                        });
                                }//细项信息                                                   
                                else
                                {
                                    pmswsrecordGrid.tip.hide();
                                }
                        
            }  }});
        });  
    var showTipRowIndex=-1;
    
                        pmswsrecordGrid.render();
                        /*------DataGrid的函数结束 End---------------*/
                        QueryData();


                    })
</script>
</html>

