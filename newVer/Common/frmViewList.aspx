<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmViewList.aspx.cs" Inherits="Common_frmViewList" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>无标题页</title>
    <link rel="stylesheet" type="text/css" href="../ext3/resources/css/ext-all.css" />
    <script type="text/javascript" src="../ext3/adapter/ext/ext-base.js"></script>
    <script type="text/javascript" src="../ext3/ext-all.js"></script>
    <script type="text/javascript" src="../ext3/example/ItemDeleter.js"></script>
    <link rel="stylesheet" type="text/css" href="../css/GroupHeaderPlugin.css" />
    <script type="text/javascript" src="../js/getExcelXml.js"></script>
    
    <script type="text/javascript" src="../js/floatUtil.js"></script>
	<script type="text/javascript" src="../js/getExcelXml.js"></script>
    <script type="text/javascript" src="../js/GroupHeaderPlugin.js"></script>
    <link rel="stylesheet" href="../css/Ext.ux.grid.GridSummary.css"/>
    <script type="text/javascript" src="../js/FilterControl.js"></script>
    <script type="text/javascript" src='../js/Ext.ux.grid.GridSummary.js'></script>
    <script type="text/javascript" src='../js/JsonToXml.js'></script>
    <script type="text/javascript" src='../js/common.js'></script>
    <script type="text/javascript" src="../js/ExtJsHelper.js"></script>
    <script type="text/javascript" src="../FusionCharts/FusionCharts.js"></script>
    <script type="text/javascript" src="../FusionCharts/FusionChartsUtil.js"></script>
    <script type="text/javascript" src="../js/GroupFieldSelect.js"></script>
    <script type="text/javascript" src="../js/ProductSelect.js"></script>
    <script type="text/javascript" src="../ext3/src/locale/ext-lang-zh_CN.js"></script>
    
</head>
<%=getColModel() %>
<body>
    <form id="form1" runat="server">
    <div id="toolbar"></div>
    <div id='searchForm'></div>
    <div id='gird'></div>
    <div id="staticGrid"></div>
    <div id="searchGrid"></div>
    <div id="chartDiv" style="position:absolute;top:200">
    <input type='button' onclick='hideChartDiv();' value='关闭'/>
    <div id="chartDiv1" align="center"></div>
    </div>
    
    </form>
<script>

var schemeGridData = new Ext.data.Store
({
url: 'frmViewList.aspx?method=getSchemeList',
reader:new Ext.data.JsonReader({
	totalProperty:'totalProperty',
	root:'root'
},[{name:'SchemeId'},
	{name:'SchemeName'},
	{name:'SchemeMemo'},
	{name:'SchemeType'},
	{name:'Creater'},
	{name:'OrgId'},
	{name:'CreateDate'},
	{name:'SchemeViewname'}]),
	listeners:
	{
		scope:this,
		load:function(){
		}
	}
});
schemeGridData.baseParams.ViewName = reportViewName;
function getFilterStr()
{
    filterStore.removeAll();
    getFilter();
    var json = "";
                filterStore.each(function(filterStore) {
                    json += Ext.util.JSON.encode(filterStore.data) + ',';
                });
   json = json.substring(0, json.length - 1);
   return json;
}
function getCmbStore(columnName)
{
    switch(columnName)
    {
        case "IsPayed":
        case "IsBill":
            var dsIsPayed = new Ext.data.SimpleStore({ 
                fields:['IsPayed','IsPayedText'],
                data:[['0','否'],['1','是']],
                autoLoad: false});
            return dsIsPayed;
        case "IsPayedName":
            var dsIsPayedName = new Ext.data.SimpleStore({ 
                fields:['IsPayedName','IsPayedNameText'],
                data:[['已结款','已结款'],['未结款','未结款']],
                autoLoad: false});
            return dsIsPayedName;
            break;
        case "IsBillName":
            var dsIsBillName = new Ext.data.SimpleStore({ 
                fields:['IsBillName','IsBillNameText'],
                data:[['已开票','已开票'],['未开票','未开票']],
                autoLoad: false});
            return dsIsBillName;
            break;
        case "IsOutedName":
            var dsIsOutedName = new Ext.data.SimpleStore({ 
                fields:['IsOutedName','IsOutedNameText'],
                data:[['已出库','已出库'],['部分出库','部分出库'],['未出库','未出库']],
                autoLoad: false});
            return dsIsOutedName;
            break;
        case "IsActiveName":
            var dsIsOutedName = new Ext.data.SimpleStore({ 
                fields:['IsActiveName','IsActiveNameText'],
                data:[['有效','有效'],['无效','无效']],
                autoLoad: false});
            return dsIsOutedName;
            break;
        case"Status":
            var dsDrawStatus=new Ext.data.SimpleStore({
                fields:['Status','StatusName'],
                data:[['1','初始化'],['2','配送调度'],['3','等待出库'],
                        ['4','出库'],['5','出库客户确认']],
                autoLoad:false});
                return dsDrawStatus;
        case "FromBillTypeName":
            var dsFromBillTypeName = new Ext.data.SimpleStore({ 
                fields:['FromBillTypeName','FromBillTypeNameText'],
                data:[['','全部'],['采购入仓','采购入仓'],['领货出仓','领货出仓'],
                      ['移库出库','移库出库'],['移库入库','移库入库'],['移仓','移仓'],
                      ['升溢','升溢'],['损耗','损耗'],                        
                        ['销售退货','销售退货'], ['采购退货','采购退货'],                       
                        ['直拨出','直拨出'],['直拨进','直拨进'],
                        ['转换入','转换入'],['转换出','转换出'], 
                        ['采购降级入仓','采购降级入仓'],
                        ['生产入仓','生产入仓'],['生产出仓','生产出仓'],
                        ['盘点','盘点'],['生产退货','生产退货']],                     
                autoLoad: false});
            return dsFromBillTypeName;
            break;
        case"WhName":
        case"OutStorName":
            return dsWareHouse;
        case"DlvTypeName":
            return dsDlvType;
        case"PayTypeName":
            return dsPayType;
        case"BillModeName":
            return dsBillMode;
        case"CorpKindName":
            return dsCorpKind;
        case"TradeTypeName":
            return dsTradeType;
        case"CustomerKindName":
            return dsCustomerKind;
        case"ProductUse":
            return dsProductUse;
        case"RouteName":
            return dsRoute;
        default:
            return null;
    }
}
txtFieldValue.on("focus", showSelectForm);
function showSelectForm()
{
    switch (cmbField.getValue()) {
        case "ProductName":
            selectProductType();
    }
}
//选择产品分类信息
function selectProductType() {

    if (selectProductForm == null) {
        showProductForm("", "", "", true);
        selectProductForm.buttons[0].on("click", selectProductOk);
    }
    else {
        showProductForm("", "", "", true);
    }
}
var selectedProductIds = "";
function selectProductOk() {
    var selectProductNames = "";
    selectedProductIds = "";
    var selectNodes = selectProductTree.getChecked();
    for (var i = 0; i < selectNodes.length; i++) {
        if (selectProductNames != "") {
            selectProductNames += ",";
            selectedProductIds += ",";
        }
        selectProductNames += selectNodes[i].text;
        selectedProductIds += selectNodes[i].id + '!' + selectNodes[i].text + '!' + selectNodes[i].attributes.CustomerColumn;
    }
    txtFieldValue.setValue(selectProductNames);
}

var sortInfor = '';
var defaultPageSize = 14;

Ext.BLANK_IMAGE_URL = "../ext3/resources/images/default/s.gif"
Ext.onReady(function() {


    /*------实现toolbar的函数 start---------------*/
    var Toolbar = new Ext.Toolbar({
        renderTo: 'toolbar',
        region: "north",
        height: 25
    });

    var sm = new Ext.grid.CheckboxSelectionModel({
        singleSelect: true
    });

    var toolBar = new Ext.PagingToolbar({
        pageSize: defaultPageSize,
        store: gridStore,
        displayMsg: '显示第{0}条到{1}条记录,共{2}条',
        emptyMsy: '没有记录',
        displayInfo: true,
        listeners : {  
            "beforechange" : function(bbar, params){  
                var grid = bbar.ownerCt;  
                var store = grid.getStore(); 
                store.removeAll();
            }
        }  
    });
    var pageSizestore = new Ext.data.SimpleStore({
        fields: ['pageSize'],
        data: [[10], [20], [30], [100], [150]]
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

    //合计项
    var viewGrid = new Ext.grid.EditorGridPanel({
        renderTo: "gird",
        id: 'viewGrid',
        //region:'center',
        split: true,
        store: gridStore,
        autoscroll: true,
        clicksToEdit: 1,
        loadMask: { msg: '正在加载数据，请稍侯……' },
        sm: sm,
        cm: colModel,
        bbar: toolBar,
        viewConfig: {
            columnsText: '显示的列',
            scrollOffset: 20,
            sortAscText: '升序',
            sortDescText: '降序',
            forceFit: false
        },
        stripeRows: true,
        height: 420,
        width: document.body.offsetWidth-5,
        title: '<%=System.Uri.UnescapeDataString(this.Request.QueryString[ "viewName" ]+"")%>',
        plugins: [headerModel]

    });
    gridStore.baseParams.ReportView = reportView;

    otherParams = staticReportId;
    _grid = viewGrid;
    iniSelectColumn(Toolbar, "searchGrid");
    btnFliter.on("click", staticSeach);
    btnContinueFliter.on("click", staticSeach);

    function staticSeach() {
        var json = "";
        filterStore.each(function(filterStore) {
            if (filterStore.data.ColumnName != '') {
                json += Ext.util.JSON.encode(filterStore.data) + ',';
            }
        });

        searchDataGrid(json);
    }

    createSearch(viewGrid, gridStore, "searchForm");
    //setControlVisibleByField();
                    
    searchForm.el = "searchForm";
    searchForm.render();
    //alert(getParamerValue('IsAllExport'));
    if(getParamerValue('IsAllExport')=="show")
        btnAllExpert.setVisible(true);
    comboStatic.store = schemeStore;
    comboStatic.displayField = "SchemeName";
    comboStatic.valueField = "SchemeId";
    comboStatic.setVisible(true);
    comboStatic.on("select", event_select_static);
    /* 统计信息设置   */
    btnExpert.setVisible(true);

    var data;
    var grid = null;
    function event_select_static() {

        //如果统计不可见，就不用做设置了
        if (comboStatic.hidden) {
            return;
        }

        var staticId = comboStatic.getValue();
        if (staticId == "0") {
            viewGrid.setVisible(true);
            if (grid != null && grid.gridPanel) {
                grid.gridPanel.setVisible(false);
            }
            return;
        }
        else {
            //gridPanel.setVisible(true);
            viewGrid.setVisible(false);
        }
        if (grid != null && grid.gridPanel) {
            grid.gridPanel.destroy();
            data.fields = '';
            data.columns = '';
        }
        if (data == null) {
            data = new DataColumn();
        }
        data.fields = '';
        data.columns = '';

        Ext.Ajax.request({
            url: "frmViewList.aspx?method=getstaticcolumn",
            method: 'POST',
            params: {
                staticId: staticId
            },
            success: function(response, option) {
                if (response.responseText == "") {
                    return;
                }
                var res = Ext.util.JSON.decode(response.responseText);
                for (var i = 0; i < res.length; i++) {
                    data.addColumns(res[i].name, res[i].name);
                }
                grid = new DataGrid("frmViewList.aspx?method=getstaticvalue");
                
            },
            failure: function() {
                Ext.Msg.alert("消息", "查询出错---->请打开数据库查看数据表名字是否正确");
            }
        });
    }

    function DataColumn() {
        this.fields = '';
        this.columns = '';
        this.addColumns = function(name, caption) {
            if (this.fields.length > 0) {
                this.fields += ',';
            }
            if (this.columns.length > 0) {
                this.columns += ',';
            }
            else {
                this.columns = 'new Ext.grid.RowNumberer({width:50}),';
            }
            this.fields += '{name:"' + name + '"}';
            this.columns += '{header:"' + caption + '",dataIndex:"' + name + '",width:100,sortable:true}';
        };
    }
    function DataGrid(URL) {
        var cm = new Ext.grid.ColumnModel(eval('([' + data.columns + '])'));
        cm.defaultSortable = true;
        var fields = eval('([' + data.fields + '])');
        var newStore = new Ext.data.Store({
            proxy: new Ext.data.HttpProxy({ url: URL }),
            reader: new Ext.data.JsonReader({ totalProperty: "totalPorperty", root: "root", fields: fields })
        });
        staticStore = newStore;
        newStore.load({ params: { StaticId: comboStatic.getValue()} });
        this.gridPanel = new Ext.grid.GridPanel({
            cm: cm,
            id: "grid_panel",
            renderTo: "staticGrid",
            //store:newStore,
            frame: false,
            border: true,
            layout: "fit",
            width: 800,
            height: 400,
            viewConfig: { forceFit: true }
        });
    }


if(needProductType)
{
    var addRow = new fieldRowPattern({
                id: 'ProductType',
                name: '存货类别',
                dataType: 'select'
            });
            fieldStore.add(addRow);

            txtFieldValue.on("focus", selectProductType);
}
        function selectProductType() {
            if (cmbField.getValue() != "ProductType")
                return;
            currentSelect = txtFieldValue;
            selectShow("ProductType");

        }

        this.selectShow = function(columnName) {
            switch (columnName) {
                case "ProductType":
                    if (selectProductForm == null) {
                        parentUrl = "../CRM/product/frmBaProductClass.aspx?select=true&method=getbaproducttree";
                        showProductForm("", "", "", true);
                        selectProductForm.buttons[0].on("click", selectProductOk);
                    }
                    else {
                        showProductForm("", "", "", true);
                    }
                    break;
            }
        }

        var selectedProductIds = "";
        function selectProductOk() {
            var selectProductNames = "";
            selectedProductIds = "";
            var selectNodes = selectProductTree.getChecked();
            for (var i = 0; i < selectNodes.length; i++) {
                if (selectProductNames != "") {
                    selectProductNames += ",";
                    selectedProductIds += ",";
                }
                selectProductNames += selectNodes[i].text;
                selectedProductIds += selectNodes[i].id + '!' + selectNodes[i].text + '!' + selectNodes[i].attributes.CustomerColumn;
            }
            currentSelect.setValue(selectProductNames);
        }

        this.getSelectedValue = function() {
            return selectedProductIds;
        }
    
})
function updateGraph() {
        var filter = "";
        var xml = "";
        var tempStore = grid.getStore();
        if (typeof (tempStore) != "undefined") {
            xml = encodeURI(JsonToXml2(tempStore));
        }
        if (xml == "")
            return;
        Ext.Ajax.request({
            url: 'frmViewList.aspx?method=getgraphvalue',
            params: {
                staticId: comboStatic.getValue(),
                filter: filter,
                xml: xml,
                GraphType:graphType

            },
            success: function(resp, opts) {
                showChartDiv();
                var graphUrl = '';
                switch(graphType)
                {
                    case"Line":
                        graphUrl='../FusionCharts/FCF_Line.swf';
                        break;
                    case"Pie":
                        graphUrl='../FusionCharts/FCF_Pie3D.swf';
                        break;
                    case"Area":
                        graphUrl='../FusionCharts/FCF_Area2D.swf';
                        break;
                    case"Column":
                        graphUrl='../FusionCharts/FCF_Column2D.swf';
                        break;
                    default:
                        graphUrl='../FusionCharts/FCF_Column2D.swf';
                        break;
                    
                }
                if(grid.colModel.config.length>2)
                {
                    createChartSection("../FusionCharts/FCF_MSColumn2D.swf", "chartDiv1", resp.responseText, "StockCurrent", false, true);
                }
                else
                {
                    createChartSection(graphUrl, "chartDiv1", resp.responseText, "StockCurrent", false, true);
                }
            },
            failure: function(resp, opts) {
                Ext.Msg.alert("提示", "获取用户信息失败");
            }
        });        //    
    }
    document.getElementById("chartDiv").style.display="none";
    function hideChartDiv()
    {
        document.getElementById("chartDiv").style.display="none";
        grid.setVisible(true);
    }
    function showChartDiv()
    {
        document.getElementById("chartDiv").style.display="";
        grid.setVisible(false);
    }
</script>

</body>
</html>
