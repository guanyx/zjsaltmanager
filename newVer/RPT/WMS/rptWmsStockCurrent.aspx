<%@ Page Language="C#" AutoEventWireup="true" CodeFile="rptWmsStockCurrent.aspx.cs" Inherits="WMS_frmWmsStockCurrent" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html runat="server">
<head>
<title>实时库存报表</title><meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<link rel="stylesheet" type="text/css" href="../../ext3/resources/css/ext-all.css" />
<script type="text/javascript" src="../../ext3/adapter/ext/ext-base.js"></script>
<script type="text/javascript" src="../../ext3/ext-all.js"></script>
<script type="text/javascript" src="../../FusionCharts/FusionCharts.js"></script>
<script type="text/javascript" src="../../FusionCharts/FusionChartsUtil.js"></script>
</head>
<body runat="server">
<div id='toolbar'></div>
<div id='divForm'></div>
<div id='seachFormDiv'></div>
<div id='stockGridDiv'></div>
<div id="chartDiv1" align="center">图形加载中...</div>
</body>
<%=getComboBoxStore()%>

<script type="text/javascript">
    Ext.onReady(function() {
        var dsWarehousePositionList; //仓位下拉框
        if (dsWarehousePositionList == null) { //防止重复加载
            dsWarehousePositionList = new Ext.data.JsonStore({
                totalProperty: "result",
                root: "root",
                url: 'rptWmsStockCurrent.aspx?method=getWarehousePositionList',
                fields: ['WhpId', 'WhpName']
            });
            //dsWarehousePositionList.load();

        }
        function updateDataGrid() {

            var WhId = WhNamePanel.getValue();
            var WhpId = WhpNamePanel.getValue();
            var ProductId = ProductNamePanel.getValue();

            var chartType = "../../FusionCharts/FCF_Bar2D.swf";
            var cashTypeChart = new FusionCharts(chartType,"StockCurrent","700","600");
                      
            Ext.Ajax.request({
		    url:'rptWmsStockCurrent.aspx?method=getCurrentStockList',
		    params:{
			            WhId: WhId,
                        WhpId: WhpId,
                        ProductId: ProductId
		    },
	        success: function(resp,opts){//alert(resp.responseText);
	            createChartSection(chartType,"chartDiv1",resp.responseText,"StockCurrent",false,true);
		        //cashTypeChart.setDataXML(resp.responseText);
		        //cashTypeChart.render("chartDiv1");
	        },
	        failure: function(resp,opts){
		        Ext.Msg.alert("提示","获取用户信息失败");
	        }
	        });
	
              
        //    

        }
     

        
        /*------搜索------Start-----------------------*/
        var WhNamePanel = new Ext.form.ComboBox({
            fieldLabel: '仓库名称',
            name: 'warehouseCombo',
            store: dsWarehouseList,
            displayField: 'WhName',
            valueField: 'WhId',
            typeAhead: true, //自动将第一个搜索到的选项补全输入
            triggerAction: 'all',
            emptyText: '请选择仓库',
            //valueNotFoundText: 0,
            selectOnFocus: true,
            forceSelection: true,
            anchor: '90%',
            mode: 'local',
            listeners: {
                specialkey: function(f, e) {
                    if (e.getKey() == e.ENTER) {
                        Ext.getCmp('WhpId').focus();
                    }
                }
              ,
                select: function(combo, record, index) {
                    var curWhId = WhNamePanel.getValue();                    
                    dsWarehousePositionList.load({
                        params: {
                            WhId: curWhId
                        }
                    });
                }
            }
        });


        var WhpNamePanel = new Ext.form.ComboBox({
            fieldLabel: '仓位名称',
            name: 'warehousePosCombo',
            store: dsWarehousePositionList,
            displayField: 'WhpName',
            valueField: 'WhpId',
            typeAhead: true, //自动将第一个搜索到的选项补全输入
            triggerAction: 'all',
            emptyText: '请选择仓位',
            //valueNotFoundText: 0,
            selectOnFocus: true,
            forceSelection: true,
            mode:'local',
            id: 'WhpId',
            anchor: '90%',
            listeners: { specialkey: function(f, e) { if (e.getKey() == e.ENTER) { Ext.getCmp('ProductId').focus(); } },
                blur: function(field) { if (field.getRawValue() == '') { field.clearValue(); } }
            }

        });
        var ProductNamePanel = new Ext.form.ComboBox({
            fieldLabel: '商品名称',
            name: 'productCombo',
            store: dsProductList,
            displayField: 'ProductName',
            valueField: 'ProductId',
            typeAhead: true, //自动将第一个搜索到的选项补全输入
            triggerAction: 'all',
            emptyText: '请选择商品',
            //valueNotFoundText: 0,
            selectOnFocus: true,
            forceSelection: true,
            id: 'ProductId',
            anchor: '90%',
            mode:'local',
            listeners: { specialkey: function(f, e) { if (e.getKey() == e.ENTER) { Ext.getCmp('searchebtnId').focus(); } } }

        });


        var serchform = new Ext.FormPanel({
            renderTo: 'seachFormDiv',
            labelAlign: 'left',
            layout: 'fit',
            buttonAlign: 'right',
            bodyStyle: 'padding:5px',
            frame: true,
            labelWidth: 55,
            items: [{
                layout: 'column',   //定义该元素为布局为列布局方式
                border: false,
                items: [{
                    columnWidth: .3,  //该列占用的宽度，标识为20％
                    layout: 'form',
                    border: false,
                    items: [
                        WhNamePanel
                    ]
                }, {
                    columnWidth: .3,
                    layout: 'form',
                    border: false,
                    items: [
                        WhpNamePanel
                        ]
                }, {
                    columnWidth: .3,
                    layout: 'form',
                    border: false,
                    items: [
                        ProductNamePanel
                        ]
                }, {
                    columnWidth: .1,
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
                    /*------搜索------END-------------------------*/

                    /*------获取数据的函数 结束 End---------------*/

                    /*------DataGrid的函数结束 End---------------*/

                    updateDataGrid();

                })
</script>

</html>

