<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmCheckReport.aspx.cs" Inherits="SCM_frmCheckReport" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>核销报表</title>
    <link rel="stylesheet" type="text/css" href="../ext3/resources/css/ext-all.css" />
    <script type="text/javascript" src="../ext3/adapter/ext/ext-base.js"></script>
    <script type="text/javascript" src="../ext3/ext-all.js"></script>
    <script type="text/javascript" src="../ext3/example/ItemDeleter.js"></script>
    <script type="text/javascript" src="../js/floatUtil.js"></script>
    <script type="text/javascript" src="../js/FilterControl.js"></script>
</head>
<%=getColModel() %>
<script>

 function getCmbStore(columnName)
{
    return null;
}

Ext.BLANK_IMAGE_URL = "../../ext3/resources/images/default/s.gif"
Ext.onReady(function() {
    var sm = new Ext.grid.CheckboxSelectionModel({
        singleSelect: true
    });

    var deptGrid = new Ext.grid.GridPanel({
        el: "grid",
        width: '100%',
        height: '100%',
        autoWidth: true,
        autoHeight: true,
        autoScroll: true,
        region: "center",
        border: true,
        id: 'deptGrid',
        store: gridStore,
        loadMask: { msg: '正在加载数据，请稍侯……' },
        sm: sm,
        cm: colModel,
        bbar: new Ext.PagingToolbar({
            pageSize: 10,
            store: gridStore,
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
        height: 450,
        closeAction: 'hide',
        stripeRows: true,
        loadMask: true,
        autoExpandColumn: 2
    });
    deptGrid.render();
    createSearch(deptGrid, gridStore, "searchForm");
    searchForm.el = "searchForm";
    searchForm.render();
})
</script>
<body>
    <form id="form1" runat="server">
    <div id="searchForm"></div>
    <div id="grid">    
    </div>
    
    </form>
</body>
</html>
