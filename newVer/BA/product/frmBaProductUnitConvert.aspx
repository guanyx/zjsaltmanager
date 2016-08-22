<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmBaProductUnitConvert.aspx.cs"
    Inherits="BA_product_frmBaProductUnitConvert" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
    <title>计量单位转换</title>
    <meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
    <link rel="stylesheet" type="text/css" href="../../ext3/resources/css/ext-all.css" />

    <script type="text/javascript" src="../../ext3/adapter/ext/ext-base.js"></script>

    <script type="text/javascript" src="../../ext3/ext-all.js"></script>
    <script type="text/javascript" src="../../js/FilterControl.js"></script>

</head>
<body>
    <div id='toolbar'>
    </div>
    <div id='searchForm'>
    </div>
    <div id='unitConvertGrid'>
    </div>
</body>

<%= getComboBoxStore() %>

<script type="text/javascript">
Ext.BLANK_IMAGE_URL = "../../ext3/resources/images/default/s.gif";
function getCmbStore(columnName)
    {
        
        return null;
    }
    var unitConvertGridData = null;

    function loadData() {
        unitConvertGridData.baseParams.ProductId = productId;
        unitConvertGridData.load({params:{limit:10,start:0}});
    }
    Ext.onReady(function() {
        var saveType;
        /*--------下拉框定义 start ---------------*/
        var dsProduct; //供应商数据源

        /*----------下拉框定义 end --------------*/
        /*------实现toolbar的函数 start---------------*/
        var Toolbar = new Ext.Toolbar({
            renderTo: "toolbar",
            items: [{
                text: "新增",
                icon: "../../Theme/1/images/extjs/customer/add16.gif",
                handler: function() {
                    saveType = 'add';
                    openAddConvertWin();
                    var sm = unitConvertGrid.getSelectionModel();
                    //获取选择的数据信息
                    var selectData = sm.getSelected();
                    if (selectData != null) {
                        Ext.getCmp("ProductName").setValue(selectData.data.ProductName);
                        Ext.getCmp("ProductId").setValue(selectData.data.ProductId);
                    }
                    else {
                        if (productId != 0) {
                            Ext.getCmp("ProductName").setValue(productName);
                            Ext.getCmp("ProductId").setValue(productId);
                        }
                    }
                }
            }, '-', {
                text: "编辑",
                icon: "../../Theme/1/images/extjs/customer/edit16.gif",
                handler: function() {
                    saveType = 'save';
                    modifyConvertWin();
                }
            }, '-', {
                text: "删除",
                icon: "../../Theme/1/images/extjs/customer/delete16.gif",
                handler: function() { deleteConvert(); }
}]
            });

            /*------结束toolbar的函数 end---------------*/


            /*------开始ToolBar事件函数 start---------------*//*-----新增Convert实体类窗体函数----*/
            function openAddConvertWin() {
                uploadConvertWindow.show();
                /*----------定义供应商组合框 start -------------*/
                //定义下拉框异步调用方法
                dsProduct = new Ext.data.Store({
                    url: 'frmBaProductUnitConvert.aspx?method=getProducts',
                    reader: new Ext.data.JsonReader({
                        root: 'root',
                        totalProperty: 'totalProperty',
                        id: 'searchProductId'
                    }, [
                        { name: 'ProductId', mapping: 'ProductId' },
                        { name: 'ProductName', mapping: 'ProductName' },
                        { name: 'Unit', mapping: 'Unit' }
                    ]),
                    params: {
                        ProductName: Ext.getCmp('ProductName').getValue()
                    }
                });
                var search = new Ext.form.ComboBox({
                    store: dsProduct,
                    displayField: 'ProductName',
                    displayValue: 'ProductId',
                    typeAhead: false,
                    minChars: 1,
                    loadingText: 'Searching...',
                    //width: 200,  
                    pageSize: 10,
                    hideTrigger: true,
                    id: 'ProductCombo',
                    applyTo: 'ProductName',
                    onSelect: function(record) { // override default onSelect to do redirect  
                        //alert(record.data.cusid); 
                        //alert(Ext.getCmp('search').getValue());                            
                        Ext.getCmp('ProductName').setValue(record.data.ProductName);
                        Ext.getCmp('ProductId').setValue(record.data.ProductId);
                        Ext.getCmp('SourceUnitId').setValue(record.data.Unit);
                        this.collapse();
                    }
                });

                /*----------定义供应商组合框 end -------------*/
            }
            /*-----编辑Convert实体类窗体函数----*/
            function modifyConvertWin() {
                var sm = unitConvertGrid.getSelectionModel();
                //获取选择的数据信息
                var selectData = sm.getSelected();
                if (selectData == null) {
                    Ext.Msg.alert("提示", "请选中需要编辑的信息！");
                    return;
                }
                uploadConvertWindow.show();
                setFormValue(selectData);
            }
            /*-----删除Convert实体函数----*/
            /*删除信息*/
            function deleteConvert() {
                var sm = unitConvertGrid.getSelectionModel();
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
                            url: 'frmBaProductUnitConvert.aspx?method=deleteUnitConvertInfo',
                            method: 'POST',
                            params: {
                                UnitConversionId: selectData.data.UnitConversionId
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
            var unitConvertForm = new Ext.form.FormPanel({
                url: '',
                frame: true,
                title: '',
                items: [
		{
		    xtype: 'hidden',
		    fieldLabel: '单位换算ID',
		    name: 'UnitConversionId',
		    id: 'UnitConversionId',
		    hidden: true,
		    hideLabel: true
		}
        , {
            xtype: 'textfield',
            fieldLabel: '产品名称',
            columnWidth: 1,
            anchor: '90%',
            name: 'ProductName',
            id: 'ProductName'
        }
        , {
            xtype: 'hidden',
            fieldLabel: '产品ID',
            name: 'ProductId',
            id: 'ProductId',
            hidden: true,
            hideLabel: true
        }
        , {
            xtype: 'combo',
            fieldLabel: '被换算单位',
            columnWidth: 1,
            anchor: '90%',
            name: 'SourceUnitId',
            id: 'SourceUnitId'
            , displayField: 'UnitName'
            , valueField: 'UnitId'
            , editable: false
            , store: dsUnit
            , triggerAction: 'all'
            , mode: 'local'
            , listeners: {
                change: {
                    fn: function(combo) {
                        Ext.getCmp('DecUnitId').getStore().clearFilter();
                        Ext.getCmp('DecUnitId').getStore().filterBy(function(record) {
                            return record.get('UnitId') != combo.getValue();
                        });
                    }
                }
            }
        }
        , {
            xtype: 'combo',
            fieldLabel: '换成单位',
            columnWidth: 1,
            anchor: '90%',
            name: 'DecUnitId',
            id: 'DecUnitId'
            , displayField: 'UnitName'
            , valueField: 'UnitId'
            , editable: false
            , store: dsNewUnit
            , triggerAction: 'all'
            , mode: 'local'
            , lastQuery: ''
        }
        , {
            xtype: 'numberfield',
            fieldLabel: '换成单位值',
            columnWidth: 1,
            anchor: '90%',
            name: 'ReplacedValue',
            id: 'ReplacedValue',
            decimalPrecision: 8
        }
        , {
            xtype: 'textarea',
            fieldLabel: '备注',
            columnWidth: 1,
            anchor: '90%',
            name: 'Remark',
            id: 'Remark'
        }
        ]
            });
            /*------FormPanle的函数结束 End---------------*/

            /*------开始界面数据的窗体 Start---------------*/
            if (typeof (uploadConvertWindow) == "undefined") {//解决创建2个windows问题
                uploadConvertWindow = new Ext.Window({
                    id: 'Convertformwindow'
		, iconCls: 'upload-win'
		, width: 400
		, height: 280
		, layout: 'fit'
		, plain: true
		, modal: true
		, constrain: true
		, resizable: false
		, closeAction: 'hide'
		, autoDestroy: true
		, items: unitConvertForm
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
			    uploadConvertWindow.hide();
			}
			, scope: this
}]
                });
            }
            uploadConvertWindow.addListener("hide", function() {
                unitConvertForm.getForm().reset();
            });

            /*------开始获取界面数据的函数 start---------------*/
            function saveUserData() {

                if (saveType == 'add')
                    saveType = 'addUnitConvertInfo';
                else if (saveType == 'save')
                    saveType = 'saveUnitConvertInfo';

                Ext.Ajax.request({
                    url: 'frmBaProductUnitConvert.aspx?method=' + saveType,
                    method: 'POST',
                    params: {
                        UnitConversionId: Ext.getCmp('UnitConversionId').getValue(),
                        ProductId: Ext.getCmp('ProductId').getValue(),
                        SourceUnitId: Ext.getCmp('SourceUnitId').getValue(),
                        DecUnitId: Ext.getCmp('DecUnitId').getValue(),
                        ReplacedValue: Ext.getCmp('ReplacedValue').getValue(),
                        Remark: Ext.getCmp('Remark').getValue()
                    },
                    success: function(resp, opts) {
                        Ext.Msg.alert("提示", "保存成功");
                        var name = namePanel.getValue();
                        unitConvertGridData.baseParams.UnitNam = name;
                        unitConvertGridData.load({
                            params: {
                                start: 0,
                                limit: 10
                            }
                        });
                        uploadConvertWindow.hide();

                    },
                    failure: function(resp, opts) {
                        Ext.Msg.alert("提示", "保存失败");
                    }
                });
            }
            /*------结束获取界面数据的函数 End---------------*/

            /*------开始界面数据的函数 Start---------------*/
            function setFormValue(selectData) {
                Ext.getCmp("UnitConversionId").setValue(selectData.data['UnitConversionId']);
                Ext.getCmp("ProductId").setValue(selectData.data['ProductId']);
                Ext.getCmp("ProductName").setValue(selectData.data['ProductName']);
                Ext.getCmp("SourceUnitId").setValue(selectData.data['SourceUnitId']);
                Ext.getCmp("DecUnitId").setValue(selectData.data['DecUnitId']);
                Ext.getCmp("ReplacedValue").setValue(selectData.data['ReplacedValue']);
                Ext.getCmp("Remark").setValue(selectData.data['Remark']);
            }
            /*------结束设置界面数据的函数 End---------------*/
            /*------定义查询form start ----------------*/
            var namePanel = new Ext.form.TextField({
                style: 'margin-left:0px',
                cls: 'key',
                xtype: 'textfield',
                fieldLabel: '计量单位名称',
                name: 'name',
                anchor: '90%'
            });
            //var serchform = new Ext.FormPanel({
            //    renderTo: 'searchForm',
            //    labelAlign: 'left',
            //    layout:'fit',
            //    buttonAlign: 'right',
            //    bodyStyle: 'padding:5px',
            //    frame: true,
            //    labelWidth: 95,
            //    items: [{
            //        layout: 'column',   //定义该元素为布局为列布局方式
            //        border: false,
            //        items: [{
            //            columnWidth: .33,
            //            layout: 'form',
            //            border: false,
            //            items: [
            //                namePanel
            //                ]
            //        }, {
            //            columnWidth: .10,
            //            layout: 'form',
            //            border: false,
            //            items: [{ cls: 'key',
            //                xtype: 'button',
            //                text: '查询',
            //                anchor: '50%',
            //                handler :function(){                
            //                    var name=namePanel.getValue();
            //                    unitConvertGridData.baseParams.UnitName = name;
            //                    unitConvertGridData.load({
            //                                params : {
            //                                start : 0,
            //                                limit : 10
            //                                } 
            //                              }); 
            //                    }
            //                }]
            //        },{
            //            columnWidth: .57,  //该列占用的宽度，标识为20％
            //            layout: 'form',
            //            border: false
            //        }]
            //    }]
            //});
            /*------定义查询form end ----------------*/

            /*------开始获取数据的函数 start---------------*/
            unitConvertGridData = new Ext.data.Store
({
    url: 'frmBaProductUnitConvert.aspx?method=getUnitCovertList',
    reader: new Ext.data.JsonReader({
        totalProperty: 'totalProperty',
        root: 'root'
    }, [
	{
	    name: 'UnitConversionId'
	},
	{
	    name: 'ProductId'
	},
	{
	    name: 'ProductName'
	},
	{
	    name: 'SourceUnitId'
	},
	{
	    name: 'SourceUnitText'
	},
	{
	    name: 'SpecificationsText'
	},
	{
	    name: 'DecUnitId'
	},
	{
	    name: 'DecUnitText'
	},
	{
	    name: 'ReplacedValue'
	},
	{
	    name: 'Remark'
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
            var unitConvertGrid = new Ext.grid.GridPanel({
                el: 'unitConvertGrid',
                width: '100%',
                height: '100%',
                autoWidth: true,
                autoHeight: true,
                autoScroll: true,
                layout: 'fit',
                id: '',
                store: unitConvertGridData,
                loadMask: { msg: '正在加载数据，请稍侯……' },
                sm: sm,
                cm: new Ext.grid.ColumnModel([
		sm,
		new Ext.grid.RowNumberer(), //自动行号
		{
		header: '单位换算ID',
		dataIndex: 'UnitConversionId',
		id: 'UnitConversionId'
		    , hidden: true
		    , hideable: true
},
		{
		    header: '商品ID',
		    dataIndex: 'ProductId',
		    id: 'ProductId'
		    , hidden: true
		    , hideable: true
		},
		{
		    header: '商品名称',
		    dataIndex: 'ProductName',
		    id: 'ProductName'
		},
		{
		    header: '换算单位',
		    dataIndex: 'SourceUnitId',
		    id: 'SourceUnitId'
		    , hidden: true
		    , hideable: true
		},
		{
		    header: '换算单位',
		    dataIndex: 'SourceUnitText',
		    id: 'SourceUnitText'
		},
		{
		    header: '被换成单位',
		    dataIndex: 'DecUnitId',
		    id: 'DecUnitId'
		    , hidden: true
		    , hideable: true
		},
		{
		    header: '被换成单位',
		    dataIndex: 'DecUnitText',
		    id: 'DecUnitText'
		},
		{
		    header: '规格',
		    dataIndex: 'SpecificationsText',
		    id: 'SpecificationsText'
		},
		{
		    header: '换成单位值',
		    dataIndex: 'ReplacedValue',
		    id: 'ReplacedValue'
		},
		{
		    header: '备注',
		    dataIndex: 'Remark',
		    id: 'Remark'
}]),
                bbar: new Ext.PagingToolbar({
                    pageSize: 10,
                    store: unitConvertGridData,
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
            unitConvertGrid.render();
            /*------DataGrid的函数结束 End---------------*/

            createSearch(unitConvertGrid, unitConvertGridData, "searchForm");
            //setControlVisibleByField();
            searchForm.el = "searchForm";
            searchForm.render();
            loadData();

        })
</script>

</html>
