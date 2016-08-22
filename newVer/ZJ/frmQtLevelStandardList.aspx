<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmQtLevelStandardList.aspx.cs" Inherits="ZJ_frmQtLevelStandardList" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>无标题页</title>
<link rel="stylesheet" type="text/css" href="../../ext3/resources/css/ext-all.css" />
    <script type="text/javascript" src="../ext3/adapter/ext/ext-base.js"></script>
    <script type="text/javascript" src="../ext3/ext-all.js"></script>  
    <script type="text/javascript" src="../js/operateResp.js"></script>    
    <script type="text/javascript" src="../js/ExtJsHelper.js"></script>
    <script type="text/javascript" src="../js/FilterControl.js"></script>
    <script type="text/javascript" src="../js/ProductSelect.js"></script>
</head>
<body>
    <div id='toolbar'></div>
    <div id='searchForm'></div>
    <div id='searchForm12'></div>
    <div id='productGrid'></div>
</body>
<%=getComboBoxStore() %>
<script>
    var productGridData = null;
    Ext.BLANK_IMAGE_URL = "../../ext3/resources/images/default/s.gif";
    Ext.onReady(function() {
        var operType = '';
        Ext.QuickTips.init();
        Ext.form.Field.prototype.msgTarget = 'side';
        /*--------下拉框定义 start ---------------*/
        var dsSupplier; //供应商数据源
        var dsSmallProduct; //小类下拉框

        /*----------下拉框定义 end --------------*/


        /*------实现toolbar的函数 start---------------*/
        var Toolbar = new Ext.Toolbar({
            renderTo: "toolbar",
            items: [ {
                text: "删除",
                icon: "../../Theme/1/images/extjs/customer/save16.gif",
                handler: function() {
//                    saveTypePruducts();
                }
            }, '-',{
                text: "查看标准要求",
                icon: "../../Theme/1/images/extjs/customer/save16.gif",
                handler: function() {
//                    saveTypePruducts();
                }
            }, '-']
        });
        

        /*-------------------------------------------*/

        levelStandardGridData = new Ext.data.Store
({
    url: 'frmQtLevelStandardList.aspx?method=getlevelstandard',
    reader: new Ext.data.JsonReader({
        totalProperty: 'totalProperty',
        root: 'root'
    }, [
	{
	    name: 'LevelId'
	},
	{
	    name: 'QuotaNo'
	},
	{
	    name: 'QuotaName'
	},
	{
	    name: 'QuotaStandard'
	}])
	,
    sortData: function(f, direction) {
//        var tempSort = Ext.util.JSON.encode(saltLevelGridData.sortInfo);
//        if (sortInfor != tempSort) {
//            sortInfor = tempSort;
//            saltLevelGridData.baseParams.SortInfo = sortInfor;
//            saltLevelGridData.load({ params: { limit: defaultPageSize, start: 0} });
//        }
    },
    listeners:
	{
	    scope: this,
	    load: function() {
	    }
	}
});



        var defaultPageSize = 10;
        var toolBar = new Ext.PagingToolbar({
            pageSize: 10,
            store: levelStandardGridData,
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
        var levelStandardGrid = new Ext.grid.GridPanel({
            el: 'productGrid',
            width: '100%',
            height: '100%',
            //autoWidth:true,
            //autoHeight:true,
            autoScroll: true,
            layout: 'fit',
            id: '',
            store: levelStandardGridData,
            loadMask: { msg: '正在加载数据，请稍侯……' },
            sm: sm,
            cm: new Ext.grid.ColumnModel([
		sm,
		new Ext.grid.RowNumberer(), //自动行号
		{
		header: '存货ID',
		dataIndex: 'LevelId',
		id: 'LevelId',
		hidden: true,
		hideable: false
},{
		header: 'QuotaNo',
		dataIndex: 'QuotaNo',
		id: 'QuotaNo',
		hidden: true,
		hideable: false
},{
		    header: '指标',
		    dataIndex: 'QuotaName',
		    id: 'QuotaName',
		    sortable: true,
		    width: 100
		},{
		    header: '标准要求',
		    dataIndex: 'QuotaStandard',
		    id: 'QuotaStandard',
		    sortable: true,
		    width: 170
		}]),
            bbar: toolBar,
            viewConfig: {
                columnsText: '显示的列',
                scrollOffset: 20,
                sortAscText: '升序',
                sortDescText: '降序',
                forceFit: false
            },
            height: 300,
            closeAction: 'hide',
            stripeRows: true,
            loadMask: true//,
            //autoExpandColumn: 2
        });
        
        levelStandardGrid.render();

        createSearch(levelStandardGrid, levelStandardGridData, "searchForm12");
        searchForm.el = "searchForm12";
        searchForm.render();

        this.getSelectedValue = function() {
            return "";
        }


        loadData();
        
            function loadData() {
            
            levelStandardGridData.baseParams.LevelId = levelId;
            levelStandardGridData.load({ params: { limit: defaultPageSize, start: 0} });
        }
    })

    
function getCmbStore(columnName) {

}
</script>
</html>