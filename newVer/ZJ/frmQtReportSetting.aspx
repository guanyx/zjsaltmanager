<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmQtReportSetting.aspx.cs" Inherits="ZJ_frmQtReportSetting" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>报表指标设置</title>
    <link rel="stylesheet" type="text/css" href="../ext3/resources/css/ext-all.css" />
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
<%--<%=getComboBoxStore() %>--%>
<script>
    var reportGridData = null;
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
                text: "添加指标",
                icon: "../../Theme/1/images/extjs/customer/add16.gif",
                handler: function() {
                    var selectData = qtReportGrid.getSelectionModel().getCount();
                           if (selectData == 0) {
                               Ext.Msg.alert("提示", "请选中要要设置的报表指标！");
                               return;
                           }
                            var recorddel = qtReportGrid.getSelectionModel().getSelections();
                           addTypeProduct(recorddel[0].data.QtReportQuotaNo);
                }
            }, {
                text: "指标情况",
                icon: "../../Theme/1/images/extjs/customer/view16.gif",
                handler: function() {
                    var selectData = qtReportGrid.getSelectionModel().getCount();
                           if (selectData == 0) {
                               Ext.Msg.alert("提示", "请选中要要设置的报表指标！");
                               return;
                           }
                            var recorddel = qtReportGrid.getSelectionModel().getSelections();
                           addQuotaListWin(recorddel[0].data.QtReportQuotaNo);
                }
            }]
        });
        
        addQuotasWin = null;
        function addTypeProduct(reportid) {
            if (addQuotasWin == null) {
                addQuotasWin = ExtJsShowWin('添加对应指标信息', 'frmQuotaItemSelect.aspx?pkId=' + reportid, 'add', 800, 500);
                addQuotasWin.show();
            }
            else {
                addQuotasWin.show();
                document.getElementById("iframeadd").contentWindow.pkId = reportid;
                document.getElementById("iframeadd").contentWindow.loadData();
            }
        }
        
        quotaListWin = null;
        function addQuotaListWin(reportid) {
            if (quotaListWin == null) {
                quotaListWin = ExtJsShowWin('对应指标信息', 'frmReportQuota.aspx?pkId=' + reportid, 'list', 800, 500);
                quotaListWin.show();
            }
            else {
                quotaListWin.show();
                document.getElementById("iframelist").contentWindow.pkId = reportid;
                document.getElementById("iframelist").contentWindow.loadData();
            }
        }

        /*-------------------------------------------*/

        qtReportGridData = new Ext.data.Store
({
    url: 'frmQtReportSetting.aspx?method=getlist',
    reader: new Ext.data.JsonReader({
        totalProperty: 'totalProperty',
        root: 'root'
    }, [
	{
	    name: 'QtReportQuotaNo'
	},
	{
	    name: 'QtReportQuotaName'
	},
	{
	    name: 'QtReportQuotaSort'
	},
	{
	    name: 'PointLength'
	},
	{
	    name: 'QuotaAlias'
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
            store: qtReportGridData,
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
        var qtReportGrid = new Ext.grid.GridPanel({
            el: 'productGrid',
            width: '100%',
            height: '100%',
            //autoWidth:true,
            //autoHeight:true,
            autoScroll: true,
            layout: 'fit',
            id: '',
            store: qtReportGridData,
            loadMask: { msg: '正在加载数据，请稍侯……' },
            sm: sm,
            cm: new Ext.grid.ColumnModel([
		sm,
		new Ext.grid.RowNumberer(), //自动行号
		{
		header: 'QtReportQuotaNo',
		dataIndex: 'QtReportQuotaNo',
		id: 'QtReportQuotaNo',
		hidden: true,
		hideable: false
},		
{
		    header: '报表指标',
		    dataIndex: 'QtReportQuotaName',
		    id: 'QtReportQuotaName',
		    sortable: true,
		    width: 100
		},{
		    header: '别名',
		    dataIndex: 'QuotaAlias',
		    id: 'QuotaAlias',
		    sortable: true,
		    width: 100
		},{
		    header: '小数点位数',
		    dataIndex: 'PointLength',
		    id: 'PointLength',
		    sortable: true,
		    width: 100
		},
		{
		    header: '排序',
		    dataIndex: 'QtReportQuotaSort',
		    id: 'QtReportQuotaSort',
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
        
        qtReportGrid.render();

        createSearch(qtReportGrid, qtReportGridData, "searchForm12");
        searchForm.el = "searchForm12";
        searchForm.render();

        this.getSelectedValue = function() {
            return "";
        }

    })

    
function getCmbStore(columnName) {

}
</script>
</html>