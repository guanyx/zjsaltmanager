<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmReportQuota.aspx.cs" Inherits="ZJ_frmReportQuota" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>无标题页</title>
<meta http-equiv="Content-Type" content="text/html; charset=GB2312">
    <link rel="stylesheet" type="text/css" href="../ext3/resources/css/ext-all.css" />
	<script type="text/javascript" src="../ext3/adapter/ext/ext-base.js"></script>	
	<script type="text/javascript" src="../ext3/ext-all.js"></script>
	<script type="text/javascript" src="../js/FilterControl.js"></script>
	<script type="text/javascript" src="../js/operateResp.js"></script>    
	<%=getComboBoxStore() %>
</head>
<body>
	<div id="quota_toolbar"></div>
	 <div id="searchForm"></div>
	 <div id="quota_grid"></div>
</body>
<script>
var quotaCount;
           var quotaArr = new Array();
var modify_quota_id = 'none';
var addmark = 0;
var quotaListStore;
Ext.BLANK_IMAGE_URL = "../ext3/resources/images/default/s.gif";
Ext.onReady(function() {
   var Toolbar = new Ext.Toolbar({
       renderTo: "quota_toolbar",
       items: [{
           id:'distBtn',
           text: "删除",
           icon: '../Theme/1/images/extjs/customer/add16.gif',
           handler: function() {
              delQuotas();
           }
        }]
    });
    
    function delQuotas()
    {
        var sm = quotaGrid.getSelectionModel();
            //获取选择的数据信息
            var selectData = sm.getSelections();
            var ids = "";
            for (var i = 0; i < selectData.length; i++) {
                if (ids.length > 0)
                    ids += ",";
                ids += selectData[i].get("QuotaNo");
            }
            if(ids.length==0)
            {
                Ext.Msg.alert("系统提示","请选择需要添加的指标信息！")
                return;
            }
             //删除前再次提醒是否真的要删除
            Ext.Msg.confirm("提示信息", "是否真的要删除选择的检测信息吗？", function callBack(id) {
                //判断是否删除数据
                if (id == "yes") {
                        Ext.Ajax.request({
                            url: 'frmReportQuota.aspx?method=del',
                            method: 'POST',
                            params: {
                                QuotaNo: ids
                            },
                            success: function(resp, opts) {
                                if (checkExtMessage(resp)) {
                                    quotaListStore.reload();
                                }

                            }
                     , failure: function(resp, opts) {
                         Ext.MessageBox.hide();
                         Ext.Msg.alert("提示", "保存失败");

                     }
                    });
            }});
    }
    
   quotaListStore = new Ext.data.Store
	({
	    url: 'frmReportQuota.aspx?method=getlist',
	    reader: new Ext.data.JsonReader({
	        totalProperty: 'totalProperty',
	        root: 'root'
	    }, [
	    { name: 'QuotaNo' },
        { name: 'QuotaName' },
        { name: 'QuotaAlias' },
	    { name: 'QuotaUnit' },
        { name: 'QuotaType' },
        { name: 'ItemType' },
        //{ name: 'QuotaTypeName'},
        {name: 'ControlType' },
        { name: 'DicsName' },
        //{ name: 'ControlTypeName'},
	    { name: 'SortId'},
        { name: 'CreateDate'},
	    { name: 'OperName' },
	     { name: 'EmpName' }
	    ]),
	    listeners:
	      {
	          scope: this,
	          load: function() {
	              //数据加载预处理,可以做一些合并、格式处理等操作
	          }
	      }
	});
	
	 var defaultPageSize = 10;
        var toolBar = new Ext.PagingToolbar({
            pageSize: 10,
            store: quotaListStore,
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
        
    var sm = new Ext.grid.CheckboxSelectionModel(
    {        singleSelect: false    } );
   var quotaGrid = new Ext.grid.GridPanel({
       el: 'quota_grid',
       width: '100%',
       height: '100%',
       autoWidth: true,
       autoHeight: true,
       autoScroll: true,
       layout: 'fit',
       id: 'customerdatagrid',
       store: quotaListStore,
       loadMask: { msg: '正在加载数据，请稍侯……' },
       sm: sm,
       /*  如果中间没有查询条件form那么可以直接用tbar来实现增删改
       tbar:[{
       text:"添加",
       handler:this.showAdd,
       scope:this
       },"-",
       {
       text:"修改"
       },"-",{
       text:"删除",
       handler:this.deleteBranch,
       scope:this
       }],
       */
       cm: new Ext.grid.ColumnModel([
        sm,
        new Ext.grid.RowNumberer(), //自动行号
        { header: '指标号', hidden: true, dataIndex: 'QuotaNo' },
        { header: '指标名称', dataIndex: 'QuotaName' },
        { header: '指标别名', hidden: true, dataIndex: 'QuotaAlias' },
        { header: '单位', dataIndex: 'QuotaUnit' },
		{ header: '指标代码', dataIndex: 'QuotaType', hidden: true },
		{ header: '指标项类型', dataIndex: 'ItemType', hidden: true },
		//{ header: '指标类型', dataIndex: 'QuotaTypeName' },
		{ header: '控件代码', dataIndex: 'ControlType' ,hidden: true },
		{ header: '控件类型', dataIndex: 'DicsName' },
		{ header: '排序号', dataIndex: 'SortId' },
		{ header: '操作日期', dataIndex: 'CreateDate' },
		{ header: '操作人', dataIndex: 'EmpName' }
	]), 
	listeners:
	{
	      rowselect: function(sm, rowIndex, record) {
	          //行选中
	          //Ext.MessageBox.alert("提示","您选择的出版号是：" + r.data.ASIN);
	      },
	      rowclick: function(grid, rowIndex, e) {
	          //双击事件
	      },
	      rowdbclick: function(grid, rowIndex, e) {
	          //双击事件
	      },
	      cellclick: function(grid, rowIndex, columnIndex, e) {
	          //单元格单击事件			           
	      },
	      celldbclick: function(grid, rowIndex, columnIndex, e) {
	          //单元格双击事件
	          /*
	          var record = grid.getStore().getAt(rowIndex); //Get the Record
	          var fieldName = grid.getColumnModel().getDataIndex(columnIndex); //Get field name
	          var data = record.get(fieldName);
	          Ext.MessageBox.alert('show','当前选中的数据是'+data); 
	          */
	      }
	  },
       bbar:toolBar,
       viewConfig: {
           columnsText: '显示的列',
           scrollOffset: 20,
           sortAscText: '升序',
           sortDescText: '降序',
           forceFit: true
       },
       //width: 750, 
       height: 265,
       closeAction: 'hide',

       stripeRows: true,
       loadMask: true,
       autoExpandColumn: 2
   });
   createSearch(quotaGrid, quotaListStore, "searchForm");
    searchForm.el = "searchForm";
    searchForm.render();
   quotaGrid.render();
   
   loadData();
}); 
function loadData() {
        quotaListStore.baseParams.QtReportQuotaNo = pkId;
        
        quotaListStore.load({ params: { limit: defaultPageSize, start: 0} });
    }
    function getCmbStore(columnName) {

}
		
	</script>
</html>
