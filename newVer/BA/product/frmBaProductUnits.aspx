<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmBaProductUnits.aspx.cs" Inherits="BA_product_frmBaProductUnits" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>无标题页</title>
    <meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<link rel="stylesheet" type="text/css" href="../../ext3/resources/css/ext-all.css" />
<script type="text/javascript" src="../../ext3/adapter/ext/ext-base.js"></script>
<script type="text/javascript" src="../../ext3/ext-all.js"></script>
<script type="text/javascript" src="../../ext3/example/ItemDeleter.js"></script>
<script type="text/javascript" src="../../js/operateResp.js"></script>
<style type="text/css">
.extensive-remove {
background-image: url(../../Theme/1/images/extjs/customer/cross.gif) ! important;
}
.x-grid-back-blue { 
background: #B7CBE8; 
}
</style>
</head>
<%=getComboBoxStore() %>
<script type="text/javascript">
    Ext.BLANK_IMAGE_URL = "../../ext3/resources/images/default/s.gif";
    Ext.onReady(function() {
        /*------实现toolbar的函数 start---------------*/
        var Toolbar = new Ext.Toolbar({
            renderTo: "toolbar",
            items: [{
                text: "新增",
                icon: "../../Theme/1/images/extjs/customer/add16.gif",
                handler: function() {
                    inserNewBlankRow();
                }
            }, '-', {
                text: "保存",
                icon: "../../Theme/1/images/extjs/customer/edit16.gif",
                handler: function() {
                    saveUnits();
                }
//            }, '-', {
//                text: "删除",
//                icon: "../../Theme/1/images/extjs/customer/delete16.gif",
//                handler: function() {
//                }
            }]
            });

            function saveUnits() {
                json = "";
                ProductUnitsGridData.each(function(ProductUnitsGridData) {
                    json += Ext.util.JSON.encode(ProductUnitsGridData.data) + ',';
                });
                //json = json.substring(0, json.length - 1);

                Ext.MessageBox.wait("数据正在保存，请稍候……");
                //然后传入参数保存
                Ext.Ajax.request({
                    url: 'frmBaProductUnits.aspx?method=save',
                    method: 'POST',
                    params: {
                        //明细参数
                        ProductUnits: json
                    },
                    success: function(resp, opts) {
                        Ext.MessageBox.hide();
                        if (checkParentExtMessage(resp, parent)) {
                            //parent.OrderMstGridData.reload();
                           // parent.uploadOrderWindow.hide();
                        }
                    },
                    failure: function(resp, opts) {
                        Ext.MessageBox.hide();
                        Ext.Msg.alert("提示", "保存失败");
                    }


                });
            }
            /*------结束toolbar的函数 end---------------*/

            var RowPattern = Ext.data.Record.create([
	{ name: 'ProductId' },
	{ name: 'UnitId' },
	{ name: 'ToWeight' },
	{ name: 'ToVolume' },
	{ name: 'IsMinPackage',type:'bool' },
	{ name: 'UnitSpec'},
	{ name: 'Memo'}]);
            /*------开始获取数据的函数 start---------------*/
            var ProductUnitsGridData = new Ext.data.Store
({
    url: 'frmBaProductUnits.aspx?method=getproductunits',
    reader: new Ext.data.JsonReader({
        totalProperty: 'totalProperty',
        root: 'root'
    }, [
	{
	    name: 'ProductId'
	},
	{
	    name: 'UnitId'
	},
	{
	    name: 'ToWeight'
	},
	{
	    name: 'ToVolume'
	},
	{
	    name: 'IsMinPackage'
	},
	{ name:'UnitSpec'},
	{
	    name: 'Memo'
}])
	,
    listeners:
	{
	    scope: this,
	    load: function() {
	    }
	}
});

            function inserNewBlankRow() {
                var rowCount = ProductUnitsGrid.getStore().getCount();
                var insertPos = parseInt(rowCount);
                var addRow = new RowPattern({
                    ProductId: productId,
                    UnitId: '0',
                    ToWeight: '0',
                    ToVolume: '0',
                    IsMinPackage: 'false',
                    UnitSpec:'',
                    Memo: ''
                });
                ProductUnitsGrid.stopEditing();
                //增加一新行
                if (insertPos > 0) {
                    var rowIndex = ProductUnitsGridData.insert(insertPos, addRow);
                    ProductUnitsGrid.startEditing(insertPos, 0);
                }
                else {
                    var rowIndex = ProductUnitsGridData.insert(0, addRow);
                    ProductUnitsGrid.startEditing(0, 0);
                }
            }
            function addNewBlankRow(combo, record, index) {
                var rowIndex = ProductUnitsGrid.getStore().indexOf(ProductUnitsGrid.getSelectionModel().getSelected());
                var rowCount = ProductUnitsGrid.getStore().getCount();
                if ((rowIndex == 0 && rowCount == 1) || rowIndex == rowCount - 1) {
                    inserNewBlankRow();
                }
            }

            /*------获取数据的函数 结束 End---------------*/

            //计量单位下拉框
            var UnitCombo = new Ext.form.ComboBox({
                store: dsUnitList,
                displayField: 'UnitName',
                valueField: 'UnitId',
                triggerAction: 'all',
                id: 'UnitCombo',
                //pageSize: 5,  
                //minChars: 2,  
                //hideTrigger: true,  
                typeAhead: true,
                mode: 'local',
                emptyText: '',
                selectOnFocus: false,
                editable: false,
                listeners: {
                    "select": addNewBlankRow
                }
            });
            /*------开始DataGrid的函数 start---------------*/

            var sm = new Ext.grid.CheckboxSelectionModel({
                singleSelect: true
            });
            var ProductUnitsGrid = new Ext.grid.EditorGridPanel({
                el: 'ProductUnitsGridDiv',
                width: '100%',
                height: '100%',
                autoScroll: true,
                layout: 'fit',
                id: 'ProductUnitsGrid',
                clicksToEdit: 1,
                store: ProductUnitsGridData,
                loadMask: { msg: '正在加载数据，请稍侯……' },
                selModel: new Extensive.grid.ItemDeleter(),
                cm: new Ext.grid.ColumnModel([
		sm,
		new Ext.grid.RowNumberer(), //自动行号
		{
		header: '存货信息',
		dataIndex: 'ProductId',
		id: 'ProductId',
		//		editor: new Ext.form.TextField({}),
		hidden: true
},
		{
		    header: '单位信息',
		    dataIndex: 'UnitId',
		    id: 'UnitId',
		    editor: UnitCombo,
		    renderer: function(value, cellmeta, record, rowIndex, columnIndex, store) {
		        var index = dsUnitList.findBy(function(record, id) {
		            return record.get(UnitCombo.valueField) == value;
		        });
		        var record = dsUnitList.getAt(index);
		        var displayText = "";
		        // 如果下拉列表没有被选择，那么record也就不存在，这时候，返回传进来的value，
		        // 而这个value就是grid的USER_REALNAME列的value，所以直接返回
		        if (record == null) {
		            //返回默认值，
		            displayText = value;
		        } else {
		            displayText = record.data.UnitName; //获取record中的数据集中的process_name字段的值
		        }
		        return displayText;
		    }

		},
		{
		    header: '规格',
		    dataIndex: 'UnitSpec',
		    id: 'UnitSpec',
		    editor: new Ext.form.TextField({})
		},
		{
		    header: '转换为公斤数',
		    dataIndex: 'ToWeight',
		    id: 'ToWeight',
		    editor: new Ext.form.TextField({})
		},
		{
		    header: '转换为体积数',
		    dataIndex: 'ToVolume',
		    id: 'ToVolume',
		    editor: new Ext.form.TextField({})
		},
		{
		    header: '是否最小包装',
		    dataIndex: 'IsMinPackage',
		    id: 'IsMinPackage',
		    editor: new Ext.form.TextField({})
		},
		{
		    header: '备注',
		    dataIndex: 'Memo',
		    id: 'Memo',
		    editor: new Ext.form.TextField({})
		}, new Extensive.grid.ItemDeleter()]),
                bbar: new Ext.PagingToolbar({
                    pageSize: 10,
                    store: ProductUnitsGridData,
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
            ProductUnitsGrid.render();
            /*------DataGrid的函数结束 End---------------*/

            this.loadData = function() {
                ProductUnitsGridData.removeAll();
                if (productId > 0) {
                    ProductUnitsGridData.baseParams.ProductId = productId;
                    ProductUnitsGridData.load({ params: { limit: 100, start: 0} });
                }
                inserNewBlankRow();
            };
            loadData();
        })
</script>
<body>
<div id='toolbar'></div>
<div id='divForm'></div>
<div id='ProductUnitsGridDiv'></div>

</body>
</html>