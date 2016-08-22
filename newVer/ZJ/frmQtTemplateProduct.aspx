<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmQtTemplateProduct.aspx.cs" Inherits="ZJ_frmQtTemplateProduct" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>型号对应盐品信息</title>
    <meta http-equiv="Content-Type" content="text/html; charset=GB2312">
    <link rel="stylesheet" type="text/css" href="../ext3/resources/css/ext-all.css" />
	<script type="text/javascript" src="../ext3/adapter/ext/ext-base.js"></script>	
	<script type="text/javascript" src="../ext3/ext-all.js"></script>
	
<script type="text/javascript">

Ext.onReady(function(){

/* 设置型号对应的产品信息 */

//分类商品信息
var productGridData = new Ext.data.Store
({
    url: 'frmQtTemplateProduct.aspx?method=getTemplateProduct',
    reader: new Ext.data.JsonReader({
        totalProperty: 'totalProperty',
        root: 'root'
    }, [
	{
	    name: 'ProductId'
	},
	{
	    name: 'ProductNo'
	},
	{
	    name: 'ProductName'
	},
	{
	    name: 'ProductName'
	},
	{
	    name: 'SpecificationsText'
	},
	{
	    name: 'UnitText'
	},
	{
	    name: 'SupplierText'
	},
	])
	,
    sortData: function(f, direction) {
        var tempSort = Ext.util.JSON.encode(productGridData.sortInfo);
        if (sortInfor != tempSort) {
            sortInfor = tempSort;
            productGridData.baseParams.SortInfo = sortInfor;
            productGridData.load({ params: { limit: defaultPageSize, start: 0} });
        }
    },
    listeners:
	{
	    scope: this,
	    load: function() {
	    }
	}
});

        /*------开始DataGrid的函数 start---------------*/

        var sm = new Ext.grid.CheckboxSelectionModel({
            singleSelect: false
        });
        var productGrid = new Ext.grid.GridPanel({
            width: '100%',
            height: '100%',
            el:'divGrid',
            //autoWidth:true,
            //autoHeight:true,
            autoScroll: true,
            layout: 'fit',
            id: 'productGrid',
            store: productGridData,
            loadMask: { msg: '正在加载数据，请稍侯……' },
            sm: sm,
            cm: new Ext.grid.ColumnModel([
		sm,
		new Ext.grid.RowNumberer(), //自动行号
		{
		header: '存货ID',
		dataIndex: 'ProductId',
		id: 'ProductId',
		hidden: true,
		hideable: false
},
		{
		    header: '存货编号',
		    dataIndex: 'ProductNo',
		    id: 'ProductNo',
		    sortable: true,
		    width: 100
		},
		{
		    header: '存货名称',
		    dataIndex: 'ProductName',
		    id: 'ProductName',
		    sortable: true,
		    width: 170
		},
		{
		    header: '产地',
		    dataIndex: 'OriginText',
		    id: 'OriginText',
		    sortable: true,
		    width: 80
		},
		{
		    header: '供应商',
		    dataIndex: 'SupplierText',
		    id: 'SupplierText',
		    sortable: true,
		    width: 150
		},
		{
		    header: '规格',
		    dataIndex: 'SpecificationsText',
		    id: 'SpecificationsText',
		    sortable: true,
		    width: 40
		},
		{
		    header: '计量单位',
		    dataIndex: 'UnitText',
		    id: 'UnitText',
		    sortable: true,
		    width: 60
		}
		]),tbar: new Ext.Toolbar({
	        items:[{
		        text:"新增",
		        icon:"../../Theme/1/images/extjs/customer/add16.gif",
		        handler:function(){		       
		            addTypeProduct();
		        }},'-',{
		        text:"删除",
		        icon:"../../Theme/1/images/extjs/customer/delete16.gif",
		        handler:function(){
		            //deleteSmallClassInfo();
		        }
	        }]
        }),
            bbar: toolBar,
            viewConfig: {
                columnsText: '显示的列',
                scrollOffset: 20,
                sortAscText: '升序',
                sortDescText: '降序',
                forceFit: false
            },
            height: 340,
            closeAction: 'hide',
            stripeRows: true,
            loadMask: true//,
            //autoExpandColumn: 2
        });


});
</script>
</head>
<body>
    <form id="form1" runat="server">
    <div>
    
    </div>
    </form>
</body>
</html>
