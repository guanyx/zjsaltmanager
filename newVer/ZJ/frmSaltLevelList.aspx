<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmSaltLevelList.aspx.cs" Inherits="ZJ_frmSaltLevelList" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>盐种等级情况</title>
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
    Ext.BLANK_IMAGE_URL = "../ext3/resources/images/default/s.gif";
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
                icon: "../Theme/1/images/extjs/customer/delete16.gif",
                handler: function() {
//                    saveTypePruducts();
                }
            }, '-',{
                text: "查看标准要求",
                icon: "../Theme/1/images/extjs/customer/view16.gif",
                handler: function() {
                    var selectData = saltLevelGrid.getSelectionModel().getCount();
                   if (selectData == 0) {
                       Ext.Msg.alert("提示", "请选中要要对应盐种的等级！");
                       return;
                   }
                   var record = saltLevelGrid.getSelectionModel().getSelections()[0].data;
                   dsLevelStardand.baseParams.LevelId=record.LevelId;
                   dsLevelStardand.reload({params: {limit:100,start:0}});
                    levelWindow.show();
                }
            }, '-']
        });
        

        /*-------------------------------------------*/

        saltLevelGridData = new Ext.data.Store
({
    url: 'frmSaltLevelList.aspx?method=getlevel',
    reader: new Ext.data.JsonReader({
        totalProperty: 'totalProperty',
        root: 'root'
    }, [
	{
	    name: 'LevelId'
	},
	{
	    name: 'SaltId'
	},
	{
	    name: 'TemplateNo'
	},
	{
	    name: 'SaltName'
	},
	{
	    name: 'TemplateName'
	},
	{
	    name: 'LevelName'
	},
	{
	    name: 'LevelLevel'
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
            store: saltLevelGridData,
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
        var saltLevelGrid = new Ext.grid.GridPanel({
            el: 'productGrid',
            width: '100%',
            height: '100%',
            //autoWidth:true,
            //autoHeight:true,
            autoScroll: true,
            layout: 'fit',
            id: '',
            store: saltLevelGridData,
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
		header: 'SaltId',
		dataIndex: 'SaltId',
		id: 'SaltId',
		hidden: true,
		hideable: false
},{
		header: 'TemplateNo',
		dataIndex: 'TemplateNo',
		id: 'TemplateNo',
		hidden: true,
		hideable: false
},		{
		    header: '盐种',
		    dataIndex: 'SaltName',
		    id: 'SaltName',
		    sortable: true,
		    width: 100
		},{
		    header: '检测标准',
		    dataIndex: 'TemplateName',
		    id: 'TemplateName',
		    sortable: true,
		    width: 170
		},
		{
		    header: '等级',
		    dataIndex: 'LevelName',
		    id: 'LevelName',
		    sortable: true,
		    width: 75
		},
		{
		    header: '等级级别',
		    dataIndex: 'LevelLevel',
		    id: 'LevelLevel',
		    sortable: true,
		    width: 80
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
        
        saltLevelGrid.render();

        createSearch(saltLevelGrid, saltLevelGridData, "searchForm12");
        searchForm.el = "searchForm12";
        searchForm.render();

        this.getSelectedValue = function() {
            return "";
        }


        loadData();
        
            function loadData() {
//            saltLevelGridData.baseParams.SaltId = saltId;
            saltLevelGridData.load({ params: { limit: defaultPageSize, start: 0} });
        }
        
        
/*查看标准等级信息*/

var txtStandardMemo = new Ext.form.TextField({
            name:"txtStandardMemo",
            id:"txtStandardMemo"});
var cm = new Ext.grid.ColumnModel([
        new Ext.grid.RowNumberer(), //自动行号
        {
        id: 'LevelId',
        header: "订单明细ID",
        dataIndex: 'OrderDtlId',
        width: 30,
        hidden: true
    },{
        id: 'LevelId',
        header: "QuotaNo",
        dataIndex: 'QuotaNo',
        width: 30,
        hidden: true
    },{
            id: 'QuotaName',
            header: "指标名称",
            dataIndex: 'QuotaName',
            width: 120
        },{
            id: 'StandardMemo',
            header: "描述",
            dataIndex: 'StandardMemo',
            width: 120,
            editor:txtStandardMemo
        },{
            id: 'QuotaStandard',
            header: "指标名称",
            dataIndex: 'QuotaStandard',
            width: 200
        }]);
var dsLevelStardand;
if (dsLevelStardand == null) {
        dsLevelStardand = new Ext.data.Store
	        ({
	            url: 'frmSaltLevelList.aspx?method=getlevelstandard',
	            reader: new Ext.data.JsonReader({
	                totalProperty: 'totalProperty',
	                root: 'root'}, [ {name: 'LevelId', type: 'string' },
           { name: 'QuotaNo', type: 'string' },
           { name: 'QuotaName', type: 'string' },
           { name: 'QuotaStandard', type: 'string' },
           { name: 'StandardMemo', type: 'string' }]) });
       
    }
    
var saltLevel = new Ext.grid.EditorGridPanel({
        store: dsLevelStardand,
        cm: cm,
        layout: 'fit',
        width:500,
        autoScroll: true,
        height: 190,
        columnLines:true,
        stripeRows: true,
        frame: true,
        //plugins: USER_ISLOCKEDColumn,
        clicksToEdit: 1
        });

var levelWindow;
if (typeof (levelWindow) == "undefined") {//解决创建2个windows问题
       levelWindow = new Ext.Window({
           title: '等级指标信息',
           modal: 'true',
           width: 520,
           height: '100%',
           autoHeight: true,
           
           collapsible: true, //是否可以折叠 
           closable: true, //是否可以关闭 
           //maximizable : true,//是否可以最大化 
           closeAction: 'hide',
           constrain: true,
           resizable: false,
           plain: true,
           autoScroll:true
           ,items: saltLevel
           ,buttons: [{
               text: '保存',
               handler: function() {
                    json = "";
                    dsLevelStardand.each(function(dsLevelStardand) {
                        json +=dsLevelStardand.data.LevelId+":"+dsLevelStardand.data.QuotaNo+":"+dsLevelStardand.data.StandardMemo+",";
                    });
                    //然后传入参数保存
                    Ext.Ajax.request({
                        url: 'frmSaltLevelList.aspx?method=savelevelstandardmemo',
                        method: 'POST',
                        params: {
                            details:json},
                        success: function(resp,opts){ 
                                    Ext.Msg.alert("提示","保存成功");     
                                    levelWindow.hide();
                                   },
		            failure: function(resp,opts){ 
		                Ext.Msg.alert("提示","保存失败");     
		            }});
               }
           }, {
               text: '关闭',
               handler: function() {
                   levelWindow.hide();
               }
            }]
//            {
//               text: '删除',
//               handler: function() {
//                          var form = levelWindow.items.items[0];
//                          for(var i=0;i<7;i++)
//                          {
//                            form.items.items[i*5+1].remove();
//                          }
//               }
//            }]
        });
    }        
        
    })

    
function getCmbStore(columnName) {

}
</script>
</html>