<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmQtCheckList.aspx.cs" Inherits="ZJ_frmQtCheckList" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>质检报告</title>
    <link rel="stylesheet" type="text/css" href="../ext3/resources/css/ext-all.css" />
    <link rel="Stylesheet" type="text/css" href="../css/columnLock.css" />
    <script type="text/javascript" src="../ext3/adapter/ext/ext-base.js"></script>
    <script type="text/javascript" src="../ext3/ext-all.js"></script>  
    <script type="text/javascript" src="../js/operateResp.js"></script>    
    <script type="text/javascript" src="../js/ExtJsHelper.js"></script>
    <script type="text/javascript" src="../js/columnLock.js"></script>
    <script type="text/javascript" src="../js/FilterControl.js"></script>
    <script type="text/javascript" src="../js/ProductSelect.js"></script>
</head>
<body>
    <div id='toolbar'></div>
    <div id='searchForm'></div>
    <div id='searchForm12'></div>
    <div id='productGrid'></div>
    <object id="printControl" classid="http:WinWebPrintControl.dll#WinWebPrintControl.UserControl1" height=0px width=0px VIEWASTEXT>
</object>
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
                        var sm = qtCheckGrid.getSelectionModel();
                    //获取选择的数据信息
                    var selectData = sm.getSelected();
                    if (selectData == null) {
                        Ext.Msg.alert("提示", "请选中需要删除的信息！");
                        return;
                    }
                    delQtCheck(selectData.data);
                }
            }, '-',{
                text: "修改",
                icon: "../Theme/1/images/extjs/customer/edit16.gif",
                handler: function() {
//                    saveTypePruducts();
                    var sm = qtCheckGrid.getSelectionModel();
                    //获取选择的数据信息
                    var selectData = sm.getSelected();
                    if (selectData == null) {
                        Ext.Msg.alert("提示", "请选中需要编辑的信息！");
                        return;
                    }
                    if(selectData.data.OrgId!=orgId)
                    {
                        Ext.Msg.alert("提示", "只有检测单位才能对质检报告进行修改！");
                        return;
                    }
                    parent.parent.parent.createDiv("质检报告","/ZJ/frmQtCheckInput.aspx?query=0&CheckId="+selectData.data.CheckId);
                }
            }, '-',{
                text: "批准",
                icon: "../Theme/1/images/extjs/customer/checked.gif",
                handler: function() {
                    var sm = qtCheckGrid.getSelectionModel();
                    //多选
                    var selectData = sm.getSelections();                
                    var array = new Array(selectData.length);
                    var checkIds = "";
                    for(var i=0;i<selectData.length;i++)
                    {
                        if(checkIds.length>0)
                            checkIds+=",";
                        checkIds += selectData[i].get('CheckId');
                    }
                    if(checkIds.length==0)
                    {
                        Ext.Msg.alert("提示信息", "请选择需要批准的检测信息？")
                        return;
                    }
                    allowQtCheck(checkIds);
                    
                }
            }, '-',{
                text: "取消批准",
                icon: "../Theme/1/images/extjs/customer/rollback.gif",
                handler: function() {
                    var sm = qtCheckGrid.getSelectionModel();
                    //多选
                    var selectData = sm.getSelections();                
                    var array = new Array(selectData.length);
                    var checkIds = "";
                    for(var i=0;i<selectData.length;i++)
                    {
                        if(checkIds.length>0)
                            checkIds+=",";
                        checkIds += selectData[i].get('CheckId');
                    }
                    if(checkIds.length==0)
                    {
                        Ext.Msg.alert("提示信息", "请选择需要取消批准的检测信息？")
                        return;
                    }
                    setQtCheck(checkIds,"真的要取消检测报告的批准吗？","cancleAllow");
                    
                }
            }, '-',{
                text: "上报",
                icon: "../Theme/1/images/extjs/customer/submit.gif",
                handler: function() {
                    var sm = qtCheckGrid.getSelectionModel();
                    //多选
                    var selectData = sm.getSelections();                
                    var array = new Array(selectData.length);
                    var checkIds = "";
                    for(var i=0;i<selectData.length;i++)
                    {
                        if(checkIds.length>0)
                            checkIds+=",";
                        checkIds += selectData[i].get('CheckId');
                    }
                    if(checkIds.length==0)
                    {
                        Ext.Msg.alert("提示信息", "请选择需要上报的检测信息？")
                        return;
                    }
                    setQtCheck(checkIds,"真的要上报检测报告吗？","report");
                    
                }
            }, '-',{
                text: "取消上报",
                icon: "../Theme/1/images/extjs/customer/s_delete.gif",
                handler: function() {
                    var sm = qtCheckGrid.getSelectionModel();
                    //多选
                    var selectData = sm.getSelections();                
                    var array = new Array(selectData.length);
                    var checkIds = "";
                    for(var i=0;i<selectData.length;i++)
                    {
                        if(checkIds.length>0)
                            checkIds+=",";
                        checkIds += selectData[i].get('CheckId');
                    }
                    if(checkIds.length==0)
                    {
                        Ext.Msg.alert("提示信息", "请选择需要取消检测报告的上报吗？")
                        return;
                    }
                    setQtCheck(checkIds,"真的要取消上报吗？","cancleReport");
                    
                }
            }, '-',{
                text: "查看",
                icon: "../Theme/1/images/extjs/customer/view16.gif",
                handler: function() {
                        var sm = qtCheckGrid.getSelectionModel();
                    //获取选择的数据信息
                    var selectData = sm.getSelected();
                    if (selectData == null) {
                        Ext.Msg.alert("提示", "请选中需要编辑的信息！");
                        return;
                    }
                    parent.parent.parent.createDiv("质检报告","/ZJ/frmQtCheckInput.aspx?query=1&CheckId="+selectData.data.CheckId);
                }
            }, '-',{
                text: "打印",
                icon: "../Theme/1/images/extjs/customer/print2.png",
                handler: function() {
                        var sm = qtCheckGrid.getSelectionModel();
                    //获取选择的数据信息
                    var selectData = sm.getSelected();
                    if (selectData == null) {
                        Ext.Msg.alert("提示", "请选中需要打印的信息！");
                        return;
                    }
                    printOrderById();
                }
            }, '-']
        });
        
        setToolBarVisible(Toolbar);
function getUrl(imageUrl)
            {
                var index = window.location.href.toLowerCase().indexOf('/zj/');
                var tempUrl = window.location.href.substring(0,index);
                return tempUrl+"/"+imageUrl;
            }
            
function printOrderById()
{
var sm = qtCheckGrid.getSelectionModel();
                //多选
                var selectData = sm.getSelections();                
                var array = new Array(selectData.length);
                var checkIds = "";
                for(var i=0;i<selectData.length;i++)
                {
                    if(checkIds.length>0)
                        checkIds+=",";
                    checkIds += selectData[i].get('CheckId');
                }
                //alert(orderIds);
                //页面提交
                Ext.Ajax.request({
                    url: 'frmQtCheckList.aspx?method=printdate',
                    method: 'POST',
                    params: {
                        CheckId: checkIds
                    },
                   success: function(resp,opts){ 
                       var printData =  resp.responseText;
                       var printControl =  document.getElementById("printControl");
                       printControl.Url =getUrl('xml');
                       printControl.MapUrl = printControl.Url+'/'+printStyleXml;//'/salePrint1.xml';
                       printControl.PrintXml = printData;
                       printControl.ColumnName="CheckId";
                       printControl.OnlyData=printOnlyData;
                       printControl.PageWidth=printPageWidth;
                       printControl.PageHeight =printPageHeight ;
                       printControl.Print();                       
                      
                   },
		           failure: function(resp,opts){  /* Ext.Msg.alert("提示","保存失败"); */    }
                });
}

function setQtCheck(checkIds,message,type)
{
    Ext.Msg.confirm("提示信息", message, function callBack(id) {
        //判断是否删除数据
        if (id == "yes") {
            //页面提交
            Ext.Ajax.request({
                url: 'frmQtCheckList.aspx?method='+type,
                method: 'POST',
                params: {
                    CheckId: checkIds
                },
                success: function(resp, opts) {
                    if (checkExtMessage(resp)) {
                        qtCheckGridData.reload();
                    }
//                    qtCheckGrid.reload();
                },
                failure: function(resp, opts) {
                    Ext.Msg.alert("提示", "数据删除失败");
                }
            });
        }
    });
}
        
function allowQtCheck(checkIds)
{
    //删除前再次提醒是否真的要删除
    Ext.Msg.confirm("提示信息", "是否真的要批准选择的检测信息吗？", function callBack(id) {
        //判断是否删除数据
        if (id == "yes") {
            //页面提交
            Ext.Ajax.request({
                url: 'frmQtCheckList.aspx?method=allow',
                method: 'POST',
                params: {
                    CheckId: checkIds
                },
                success: function(resp, opts) {
                    if (checkExtMessage(resp)) {
                        qtCheckGridData.reload();
                    }
//                    qtCheckGrid.reload();
                },
                failure: function(resp, opts) {
                    Ext.Msg.alert("提示", "数据操作失败");
                }
            });
        }
    });
}        
function delQtCheck(selectedData)
{
    //删除前再次提醒是否真的要删除
    Ext.Msg.confirm("提示信息", "是否真的要删除选择的检测信息吗？", function callBack(id) {
        //判断是否删除数据
        if (id == "yes") {
            //页面提交
            Ext.Ajax.request({
                url: 'frmQtCheckList.aspx?method=delcheck',
                method: 'POST',
                params: {
                    CheckId: selectedData.CheckId
                },
                success: function(resp, opts) {
                    if (checkExtMessage(resp)) {
                        qtCheckGridData.reload();
                    }
//                    qtCheckGridData.reload();
                },
                failure: function(resp, opts) {
                    Ext.Msg.alert("提示", "数据删除失败");
                }
            });
        }
    });
}

        /*-------------------------------------------*/

        qtCheckGridData = new Ext.data.Store
({
    url: 'frmQtCheckList.aspx?method=getcheck&status='+checkStatus,
    reader: new Ext.data.JsonReader({
        totalProperty: 'totalProperty',
        root: 'root'
    }, [
	{
	    name: 'CheckId'
	},
	{
	    name: 'CheckNo'
	},
	{
	    name: 'CheckSampleNo'
	},
	{
	    name: 'CheckSampleName'
	},
	{
	    name: 'ProductSpec'
	},
	{
	    name: 'ProductType'
	},
	{
	    name: 'ProductPackLevelName'
	},
	{
	    name: 'ProductProduceDate'
	},
	{
	    name: 'ProductBrand'
	},
	{
	    name: 'ProductSupplierName'
	},
	{
	    name: 'CheckRepresentQty'
	},
	{
	    name: 'SendCheckDate'
	},
	{
	    name: 'TemplateName'
	},
	{
	    name: 'CheckLevelName'
	},
	{
	    name: 'CheckTypeName'
	},{
	    name: 'OrgId'
	},
	{ name: 'CheckStatusName'},
	{ name: 'QuotaNo1'},
	{ name: 'QuotaNo2'},
	{ name: 'QuotaNo3'},
	{ name: 'QuotaNo4'},
	{ name: 'QuotaNo5'},
	{ name: 'QuotaNo6'},
	{ name: 'QuotaNo7'},
	{ name: 'QuotaNo8'},
	{ name: 'QuotaNo9'},
	{ name: 'QuotaNo10'},
	{ name: 'QuotaNo11'},
	{ name: 'QuotaNo12'},
	{ name: 'QuotaNo13'},
	{ name: 'QuotaNo14'},
	{ name: 'QuotaNo15'},
	{ name: 'QuotaNo16'},
	{ name: 'QuotaNo17'},
	{ name: 'QuotaNo18'},
	{ name: 'QuotaNo19'},
	{ name: 'QuotaNo20'},
	{ name: 'OrgName'}
	])
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
            store: qtCheckGridData,
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
        var qtCheckGrid = new Ext.ux.grid.LockingEditorGridPanel({
            el: 'productGrid',
            width: '100%',
            height: '100%',
            //autoWidth:true,
            //autoHeight:true,
            autoScroll: true,
            layout: 'fit',
            id: '',
            store: qtCheckGridData,
            loadMask: { msg: '正在加载数据，请稍侯……' },
            sm: sm,
            columns: [
		sm,
		new Ext.grid.RowNumberer({locked:true}), //自动行号
		{
		header: '存货ID',
		dataIndex: 'CheckId',
		id: 'CheckId',
		hidden: true,
		hideable: false
},{
		header: 'ProductId',
		dataIndex: 'ProductId',
		id: 'ProductId',
		hidden: true,
		hideable: false
},{
		    header: '样品名称',
		    dataIndex: 'CheckSampleName',
		    id: 'CheckSampleName',
		    sortable: true,
		    locked:true,
		    width: 100
		},{
		    header: '报告编号',
		    dataIndex: 'CheckNo',
		    id: 'CheckNo',
		    sortable: true,
		    locked:true,
		    width: 100
		},{
		    header: '样品编号',
		    dataIndex: 'CheckSampleNo',
		    id: 'CheckSampleNo',
		    sortable: true,
		    locked:true,
		    width: 100
		},{
		header: '规格',
		dataIndex: 'ProductSpec',
		id: 'ProductSpec',
		locked:true,
		width:80
},		{
		    header: '报告状态',
		    dataIndex: 'CheckStatusName',
		    id: 'CheckStatusName',
		    sortable: true,
		    width: 60
		},{
		    header: '检测标准',
		    dataIndex: 'TemplateName',
		    id: 'TemplateName',
		    sortable: true,
		    width: 170
		},
		{
		    header: '包装等级',
		    dataIndex: 'ProductPackLevelName',
		    id: 'ProductPackLevelName',
		    sortable: true,
		    width: 75
		},
		{
		    header: '生产日期',
		    dataIndex: 'ProductProduceDate',
		    id: 'ProductProduceDate',
		    sortable: true,
		    width: 80
		},
		{
		    header: '品牌',
		    dataIndex: 'ProductBrand',
		    id: 'ProductBrand',
		    sortable: true,
		    width: 80
		},
		{
		    header: '生成商',
		    dataIndex: 'ProductSupplierName',
		    id: 'ProductSupplierName',
		    sortable: true,
		    width: 80
		},
		{
		    header: '代表量',
		    dataIndex: 'CheckRepresentQty',
		    id: 'CheckRepresentQty',
		    sortable: true,
		    width: 80
		},
		{
		    header: '送检日期',
		    dataIndex: 'SendCheckDate',
		    id: 'SendCheckDate',
		    sortable: true,
		    width: 80
		},
		{
		    header: '检测类型',
		    dataIndex: 'CheckTypeName',
		    id: 'CheckTypeName',
		    sortable: true,
		    width: 80
		},
		{
		    header: '检测等级',
		    dataIndex: 'CheckLevelName',
		    id: 'CheckLevelName',
		    sortable: true,
		    width: 80
		},
		{header: '白度',dataIndex: 'QuotaNo1',id: 'QuotaNo1',width: 60},
		{header: '粒度',dataIndex: 'QuotaNo2',id: 'QuotaNo2',width: 60},
		{header: '氯化钠',dataIndex: 'QuotaNo3',id: 'QuotaNo3',width: 60},
		{header: '水分',dataIndex: 'QuotaNo4',id: 'QuotaNo4',width: 60},
		{header: '不溶物',dataIndex: 'QuotaNo5',id: 'QuotaNo5',width: 60},
		{header: '水溶性杂质',dataIndex: 'QuotaNo6',id: 'QuotaNo6',width: 60},
		{header: '平均值',dataIndex: 'QuotaNo7',id: 'QuotaNo7',width: 60},
		{header: '变异系数',dataIndex: 'QuotaNo8',id: 'QuotaNo8',width: 60},
		{header: '标准偏差',dataIndex: 'QuotaNo9',id: 'QuotaNo9',width: 60},
		{header: 'Qu',dataIndex: 'QuotaNo10',id: 'QuotaNo10',width: 60},
		{header: 'Ql',dataIndex: 'QuotaNo11',id: 'QuotaNo11',width: 60},
		{header: '亚铁氰化钾',dataIndex: 'QuotaNo12',id: 'QuotaNo12',width: 60},
		{header: '钙',dataIndex: 'QuotaNo13',id: 'QuotaNo13',width: 60},
		{header: '镁',dataIndex: 'QuotaNo14',id: 'QuotaNo14',width: 60},
		{header: '钾',dataIndex: 'QuotaNo15',id: 'QuotaNo15',width: 60},
		{header: '锌',dataIndex: 'QuotaNo16',id: 'QuotaNo16',width: 60},
		{header: '硒',dataIndex: 'QuotaNo17',id: 'QuotaNo17',width: 60},
		{header: '氯化钾',dataIndex: 'QuotaNo18',id: 'QuotaNo18',width: 60},
		{header: '主含量加和',dataIndex: 'QuotaNo19',id: 'QuotaNo19',width: 60},
		{header: '上报机构',dataIndex: 'OrgName',id: 'OrgName',width: 60}
		],
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
        
        qtCheckGrid.render();

        createSearch(qtCheckGrid, qtCheckGridData, "searchForm12");
        searchForm.el = "searchForm12";
        searchForm.render();

        this.getSelectedValue = function() {
            return "";
        }


        loadData();
        
            function loadData() {
//            saltLevelGridData.baseParams.SaltId = saltId;
            qtCheckGridData.load({ params: { limit: defaultPageSize, start: 0} });
        }
    })

    
function getCmbStore(columnName) {

}
</script>
</html>