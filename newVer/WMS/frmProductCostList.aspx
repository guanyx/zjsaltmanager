<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmProductCostList.aspx.cs" Inherits="WMS_frmProductCostList" %>

<html>
<head>
<title>仓库成本计算维护页面</title><meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<link rel="stylesheet" type="text/css" href="../ext3/resources/css/ext-all.css" />
<script type="text/javascript" src="../ext3/adapter/ext/ext-base.js"></script>
<script type="text/javascript" src="../ext3/ext-all.js"></script>
<script type="text/javascript" src="../js/operateResp.js"></script>
<script type="text/javascript" src="../ext3/src/locale/ext-lang-zh_CN.js"></script>
<script type="text/javascript" src="../js/ExtJsHelper.js"></script>
<style type="text/css">
.x-date-menu {
   width: 175;
}
</style>
</head>
<body>
<div id='toolbar'></div>
<div id='divSearchForm'></div>
<div id='divForm'></div>
<div id='divOrderGrid'></div>
<div style="display:none">
<select id='comboYear' >
<option value='2009'>2009</option>
<option value='2010'>2010</option>
<option value='2011'>2011</option>
<option value='2012'>2012</option>
<option value='2013'>2013</option>
<option value='2014'>2014</option>
<option value='2015'>2015</option>
<option value='2016'>2016</option>
</select></div>
<div style="display:none">
<select id='comboMonth' >
<option value='1'>1</option>
<option value='2'>2</option>
<option value='3'>3</option>
<option value='4'>4</option>
<option value='5'>5</option>
<option value='6'>6</option>
<option value='7'>7</option>
<option value='8'>8</option>
<option value='9'>9</option>
<option value='10'>10</option>
<option value='11'>11</option>
<option value='12'>12</option>
</select></div>
</body>
<%=getComboBoxStore()%>
<script type="text/javascript">
    Ext.BLANK_IMAGE_URL = "../ext3/resources/images/default/s.gif";
    Ext.onReady(function() {
        /*------实现toolbar的函数 start---------------*/
        var windowTitle = "";
        var Toolbar = new Ext.Toolbar({
            renderTo: "toolbar",
            items: [{
                text: "计算成本价",
                icon: "../theme/1/images/extjs/customer/add16.gif",
                handler: function() { calcPriceCostWin(); }
},{
                text: "成本调整",
                icon: "../theme/1/images/extjs/customer/add16.gif",
                handler: function() { productCostUpdate(); }
}]
            });

            /*------结束toolbar的函数 end---------------*/
var productCostUpdateWin = null;
function productCostUpdate()
{
var record=userGrid.getSelectionModel().getSelections();
                if(record == null || record.length == 0)
                {
                 Ext.Msg.alert('提示消息', '请选择需要修改的成本信息，可以多个存货成本同时处理');
                    return null;
                }

    var ids = '';
    for(var i=0;i<record.length;i++)
    {
        if(ids.length>0)
            ids+=",";
        ids += record[i].get('Id');
    }
    if(productCostUpdateWin==null)
    {
        productCostUpdateWin = ExtJsShowWin('存货成本修改','../Common/frmOtherUpdate.aspx?formType=productcost&ids='+ids,'productsalt',600,450);
        productCostUpdateWin.show();
    }
    else
    {
        productCostUpdateWin.show();
        document.getElementById("iframeproductsalt").contentWindow.loadData(ids);
    }
}

            /*------开始ToolBar事件函数 start---------------*//*-----新增Order实体类窗体函数----*/
            function updateDataGrid() {

                var WhId = WhNamePanel.getValue();
                var StartDate = Ext.util.Format.date(StartDatePanel.getValue(),'Y/m/d');
                var EndDate = Ext.util.Format.date(EndDatePanel.getValue(),'Y/m/d');

                userGridData.baseParams.WhId = WhId;
                userGridData.baseParams.StartDate = StartDate;
                userGridData.baseParams.EndDate = EndDate;
                userGridData.baseParams.ProductNo=Ext.getCmp('ProductNo').getValue();
                userGridData.baseParams.ProductName=Ext.getCmp('ProductName').getValue();

                userGridData.load({
                    params: {
                        start: 0,
                        limit: 10
                    }
                });

            }

            function calcPriceCostWin() {
                uploadOrderWindow.show();
            }
            /*------实现FormPanle的函数 start---------------*/
            var formData = new Ext.form.FormPanel({
                //url: '',
                frame: true,
                title: '',
                items: [
                {
                    xtype: 'combo',
                    columnWidth: 1,
                    name: 'TargetWhId',
                    id: 'TargetWhId',
                    store: dsWarehouseList,
                    displayField: 'WhName',
                    valueField: 'WhId',
                    typeAhead: true, //自动将第一个搜索到的选项补全输入
                    triggerAction: 'all',
                    emptyText: '全部仓库',
                    selectOnFocus: true,
                    forceSelection: true,
                    mode: 'local',
                    fieldLabel: '仓库',
                    //value: dsWarehouseList.getRange()[0].data.WhId,
                    anchor: '100%'
                }, {
                    xtype: 'combo',
                    fieldLabel: '年份',
                    columnWidth: 1,
                    anchor: '100%',
                    name: 'Year',
                    id: 'Year',
                    transform: 'comboYear',
                    typeAhead: false,
                    triggerAction: 'all',
                    lazyRender: true,
                    editable: false,
                    value: new Date().getFullYear()
                }, {
                    xtype: 'combo',
                    fieldLabel: '月份',
                    columnWidth: 1,
                    anchor: '100%',
                    name: 'Month',
                    id: 'Month',
                    transform: 'comboMonth',
                    typeAhead: false,
                    triggerAction: 'all',
                    lazyRender: true,
                    editable: false,
                    value: new Date().getMonth() + 1
                }, {
                    xtype:'label',
                    html: "<div align='center'><br><br><font style='font-weight:bold;color:red'>点击下一步进行业务检查</font></div>",
                    columnWidth: 1,
                    anchor:'100%'
                }
                ]
            });
            /*------开始界面数据的窗体 Start---------------*/

    var checkPanel = new Ext.Panel({  
        frame: true,  
        title: '成本计算前进行业务检查',   
        html:'点击下一步按钮进行第一步检查',
        autoScroll:true
  
    });  
    var checkStep = "";
    var rawstring = "";
    var i = 0;  
    function cardHandler(direction) {  
        if (direction == -1) {  
            i--;  
            if (i < 0) {  
                i = 0;  
            }  
        }  
        if (direction == 1) {  
            i++;  
            if (i > 1) {  
                i = 1;  
            }  
        }  
        var btnNext = Ext.getCmp("move-next");  
        var btnPrev = Ext.getCmp("move-prev");  
        var btnSave = Ext.getCmp("move-save");  
        if (i == 0) {  
            btnSave.hide();  
            btnNext.enable();  
            btnPrev.disable();   
            rawstring =''; //清空内容 
            checkPanel.body.update('');//清空内容        
            cardPanel.getLayout().setActiveItem(i);  
        }  
        var currendIdx = cardPanel.items.indexOf(cardPanel.layout.activeItem);        
        if (i == 1) { 
            if( currendIdx == 1)
            {
                 Ext.Ajax.request({
                    url: 'frmProductCostList.aspx?method=checkProductCost&checkStep='+checkStep,
                    method: 'POST',
                    params: {
                        WhId: Ext.getCmp('TargetWhId').getValue(),
                        Year: Ext.getCmp('Year').getValue(),
                        Month: Ext.getCmp('Month').getValue()
                    },
                    success: function(resp, opts) {
                        var resu = Ext.decode(resp.responseText);//要UIMessageBase格式                
                        var isfinish = false;  
                        if(resu.success)
                        {                 
                            //获取下一步
                            checkStep = resu.id;                              
                            //显示检查成功
                            if(checkStep==0)                        
                            {//最后检查成功
                                rawstring = '检查完毕！';
                                btnNext.disable();
                                btnSave.show(); 
                            }
                            //显示结果信息  
                            rawstring = rawstring+resu.errorinfo+'<br>';
                            checkPanel.body.update(rawstring); 
                        }
                        else
                        {
                            //显示结果信息  
                            //获取下一步
                            if(resu.id != -1)
                                checkStep = resu.id; 
                            rawstring = rawstring+'<font color="red">'+resu.errorinfo+'</font>'+'<br>';
                            checkPanel.body.update(rawstring); 
                        }           
                                          
                    }
                });     
                         
            }else{                                
                //btnSave.show();  
                //btnNext.disable();  
                btnPrev.enable();  
                
                cardPanel.getLayout().setActiveItem(i);
            }
        }
                
    }; 
    //CARD总面板  
    var cardPanel = new Ext.Panel({  
        frame: true,  
        height: 400,  
        width: 300,  
        layout: 'card',  
        activeItem: 0,  
        bbar: ['->', {  
            id: 'move-prev',  
            text: '上一步', 
            disabled:true, 
            handler: cardHandler.createDelegate(this, [-1])  
        },  
        {  
            id: 'move-save',  
            text: '保存',  
            hidden: true,  
            handler: function () {  
                calcProductCost();
            }  
        },  
        {  
            id: 'move-next',  
            text: '下一步',  
            handler: cardHandler.createDelegate(this, [1])  
        },  
        {  
            id: 'hide-win',  
            text: '取消',  
            handler: function() {
                uploadOrderWindow.hide();                
            } 
        }],  
        items: [formData,checkPanel]  
    });  
    
   
            if (typeof (uploadOrderWindow) == "undefined") {//解决创建2个windows问题
                uploadOrderWindow = new Ext.Window({
                    id: 'Orderformwindow'
		            , iconCls: 'upload-win'
		            , title: '请选择仓库和年月计算成本价'
		            , width: 400
		            , height: 300
		            , layout: 'fit'
		            , plain: true
		            , modal: true
		            , constrain: true
		            , resizable: false
		            , closeAction: 'hide'
		            , autoDestroy: true
		            , items: cardPanel

                });
            }
            uploadOrderWindow.addListener("hide", function() {
                checkPanel.body.update('');//清空内容
                cardHandler(-1);//还原界面
                updateDataGrid();
            });

            /*------开始获取界面数据的函数 start---------------*/
            function calcProductCost() {
            
                Ext.MessageBox.wait("数据正在处理，请稍候……");
                Ext.Ajax.request({
                    timeout: 180000,
                    url: 'frmProductCostList.aspx?method=calcProductCost',
                    method: 'POST',
                    params: {
                        WhId: Ext.getCmp('TargetWhId').getValue(),
                        Year: Ext.getCmp('Year').getValue(),
                        Month: Ext.getCmp('Month').getValue()
                    },
                    success: function(resp, opts) {
                        Ext.MessageBox.hide();
                        if (checkExtMessage(resp)) {                            
                            uploadOrderWindow.hide();
                        }
                    }, 
                    failure: function(resp, opts) {
                         Ext.MessageBox.hide();
                     }
                });
            }
            /*------结束获取界面数据的函数 End---------------*/

            /*------开始查询form的函数 start---------------*/
            var WhNamePanel = new Ext.form.ComboBox({
                name: 'warehouseCombo',
                store: dsWarehouseList,
                displayField: 'WhName',
                valueField: 'WhId',
                typeAhead: true, //自动将第一个搜索到的选项补全输入
                triggerAction: 'all',
                emptyText: '请选择仓库',
                selectOnFocus: true,
                forceSelection: true,
                mode: 'local',
                fieldLabel: '仓库名称',
                anchor: '90%',
                id: 'SWhName',
                listeners: { specialkey: function(f, e) { if (e.getKey() == e.ENTER) { Ext.getCmp('StartDate').focus(); } } }
            });


            var StartDatePanel = new Ext.form.DateField({
                style: 'margin-left:0px',
                cls: 'key',
                xtype: 'datefield',
                fieldLabel: '开始时间',
                format: 'Y年m月d日',
                anchor: '90%',
                value: new Date().getFirstDateOfMonth().clearTime(),
                id: 'StartDate',
                listeners: { specialkey: function(f, e) { if (e.getKey() == e.ENTER) { Ext.getCmp('EndDate').focus(); } } }
            });
            var EndDatePanel = new Ext.form.DateField({
                style: 'margin-left:0px',
                cls: 'key',
                xtype: 'datefield',
                fieldLabel: '结束时间',
                anchor: '90%',
                format: 'Y年m月d日',
                id: 'EndDate',
                value: new Date().getLastDateOfMonth().clearTime(),
                listeners: { specialkey: function(f, e) { if (e.getKey() == e.ENTER) { Ext.getCmp('searchebtnId').focus(); } } }
            });
            var serchform = new Ext.FormPanel({
                renderTo: 'divSearchForm',
                labelAlign: 'left',
                buttonAlign: 'right',
                bodyStyle: 'padding:5px',
                frame: true,
                labelWidth: 55,
                items: [{
                    layout: 'column',   //定义该元素为布局为列布局方式
                    border: false,
                    items: [{
                        columnWidth: .3,
                        layout: 'form',
                        border: false,
                        items: [
                            WhNamePanel
                        ]
                    },{
                        columnWidth: .3,
                        layout: 'form',
                        border: false,
                        items: [{
                            xtype: 'textfield',
			                fieldLabel: '产品编号',
			                columnWidth: 1,
			                anchor: '90%',
			                name: 'ProductNo',
			                id: 'ProductNo'
                        }]
                    },{
                        columnWidth: .3,
                        layout: 'form',
                        border: false,
                        items: [{
                            xtype: 'textfield',
			                fieldLabel: '产品名称',
			                columnWidth: 1,
			                anchor: '90%',
			                name: 'ProductName',
			                id: 'ProductName'
                        }]
                    }
                    ]
                }, {
                    layout: 'column',   //定义该元素为布局为列布局方式
                    border: false,
                    items: [{
                        columnWidth: .3,  //该列占用的宽度，标识为20％
                        layout: 'form',
                        border: false,
                        items: [
                                StartDatePanel
                            ]
                    }, {
                        columnWidth: .3,
                        layout: 'form',
                        border: false,
                        items: [
                                EndDatePanel
                            ]
                    }, {
                        columnWidth: .2,
                        layout: 'form',
                        border: false,
                        items: [{ cls: 'key',
                            xtype: 'button',
                            text: '查询',
                            id: 'searchebtnId',
                            anchor: '50%',
                            handler: function() {
                                updateDataGrid();
                            }
}]
}]
}]
                        });


                        /*------开始查询form的函数 end---------------*/

                        /*------开始获取数据的函数 start---------------*/
                        var userGridData = new Ext.data.Store
            ({
                url: 'frmProductCostList.aspx?method=getProductCostList',
                reader: new Ext.data.JsonReader({
                    totalProperty: 'totalProperty',
                    root: 'root'
                }, [{ name: 'Id' },
	            {
	                name: 'YearMonth'
	            },
	            {
	                name: 'WhId'
	            },
	            {
	                name: 'OrgId'
	            },
	            {
	                name: 'OwnerId'
	            },
	            {
	                name: 'OperId'
	            },
	            {
	                name: 'CreateDate'
	            },
	            {
	                name: 'UpdateDate'
	            },
	            {
	                name: 'ProductId'
	            },
	            {
	                name: 'CostPrice'
	            },
	            {
	                name: 'PureCostPrice'
	            },
	            {
	                name: 'SpecCostPrice'
	            },
	            {
	                name: 'ProductCode'
	            },
	            {
	                name: 'ProductName'
	            },
	            {
	                name: 'ProductUnit'
	            },
	            {
	                name: 'SpecUnitName'
	            },
	            {
	                name: 'ProductSpec'
	            },
	            {
	                name: 'TotalQty'
	            }

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

    /*------开始DataGrid的函数 start---------------*/
    var defaultPageSize = 10;
    var toolBar = new Ext.PagingToolbar({
        pageSize: 10,
        store: userGridData,
        displayMsg: '显示第{0}条到{1}条记录,共{2}条',
        emptyMsy: '没有记录',
        displayInfo: true
    });
    var pageSizestore = new Ext.data.SimpleStore({
        fields: ['pageSize'],
        data: [[10], [20], [30]]
    });
    var combo1 = new Ext.form.ComboBox({
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
    toolBar.addField(combo1);
    combo1.on("change", function(c, value) {
        toolBar.pageSize = value;
        defaultPageSize = toolBar.pageSize;
    }, toolBar);
    combo1.on("select", function(c, record) {
        toolBar.pageSize = parseInt(record.get("pageSize"));
        defaultPageSize = toolBar.pageSize;
        toolBar.doLoad(0);
    }, toolBar);
    var sm = new Ext.grid.CheckboxSelectionModel({
        singleSelect: true
    });
    var userGrid = new Ext.grid.GridPanel({
        el: 'divOrderGrid',
        //width: '100%',
        height: '100%',
        //autoWidth: true,
        //autoHeight: true,
        autoScroll: true,
        layout: 'fit',
        id: '',
        store: userGridData,
        loadMask: { msg: '正在加载数据，请稍侯……' },
        sm: sm,
        cm: new Ext.grid.ColumnModel([
		//sm,
		new Ext.grid.RowNumberer(), //自动行号
		{
	        header: '流水号',
	        dataIndex: 'OrderId',
	        id: 'OrderId',
	        hidden: true
        },
		{
		    header: '年月',
		    dataIndex: 'YearMonth',
		    id: 'YearMonth',
		    renderer: Ext.util.Format.dateRenderer('Y年m月')
		},
		{
		    header: '仓库',
		    dataIndex: 'WhId',
		    id: 'WhId',
		    renderer: function(val, params, record) {
		        if (dsWarehouseList.getCount() == 0) {
		            dsWarehouseList.load();
		        }
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
		    header: '商品编码',
		    dataIndex: 'ProductCode',
		    id: 'ProductCode',
		    width:80
		},
		{
		    header: '商品ID',
		    dataIndex: 'ProductId',
		    id: 'ProductId',
		    hidden: true
		},
		{
		    header: '商品',
		    dataIndex: 'ProductName',
		    id: 'ProductName',
		    width:150
		},
		{
		    header: '单位',
		    dataIndex: 'ProductUnit',
		    id: 'ProductUnit',
		    hidden:true,
		    hidable:true
		},
		{
		    header: '单位',
		    dataIndex: 'SpecUnitName',
		    id: 'SpecUnitName',
		    width:40
		},
		{
		    header: '规格',
		    dataIndex: 'ProductSpec',
		    id: 'ProductSpec',
		    width:60
		},
        {
            header: '自定义单位成本价（去税）',
            dataIndex: 'SpecCostPrice',
            id: 'SpecCostPrice',
		    hidden:true,
		    hidable:true
        },
        {
            header: '成本价',
            dataIndex: 'CostPrice',
            id: 'CostPrice',
		    width:80
        },
        {
            header: '去税成本价',
            dataIndex: 'PureCostPrice',
            id: 'PureCostPrice',
		    width:80
        },
		{
		    header: '创建时间',
		    dataIndex: 'CreateDate',
		    id: 'CreateDate',
		    format: 'Y年m月d日'
		}

		]),
        bbar: toolBar,
        viewConfig: {
            columnsText: '显示的列',
            scrollOffset: 20,
            sortAscText: '升序',
            sortDescText: '降序',
            forceFit: false
        },
        height: 280,
        closeAction: 'hide',
        stripeRows: true,
        loadMask: true//,
        //autoExpandColumn: 2
    });
    userGrid.render();
    /*------DataGrid的函数结束 End---------------*/
    updateDataGrid();
})
                   
</script>

</html>
