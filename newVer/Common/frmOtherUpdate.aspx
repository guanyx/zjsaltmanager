<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmOtherUpdate.aspx.cs" Inherits="Common_frmOtherUpdate" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>无标题页</title>
    <link rel="stylesheet" type="text/css" href="../ext3/resources/css/ext-all.css" />
    <script type="text/javascript" src="../ext3/adapter/ext/ext-base.js"></script>
    <script type="text/javascript" src="../ext3/ext-all.js"></script>
    <script type="text/javascript" src="../ext3/example/ItemDeleter.js"></script>
    <link rel="stylesheet" type="text/css" href="../css/GroupHeaderPlugin.css" />
    <script type="text/javascript" src="../js/getExcelXml.js"></script>
    <script type="text/javascript" src="../js/ExtJsHelper.js"></script>
    
    <script type="text/javascript" src="../js/floatUtil.js"></script>
    <script type="text/javascript" src="../js/GroupHeaderPlugin.js"></script>
    <link rel="stylesheet" href="../css/Ext.ux.grid.GridSummary.css"/>
    <script type="text/javascript" src="../js/FilterControl.js"></script>
    <script type="text/javascript" src='../js/Ext.ux.grid.GridSummary.js'></script>
   
    <script type="text/javascript" src="../js/ExtJsHelper.js"></script>
    <script type="text/javascript" src="../js/operateResp.js"></script>

    
    <%=getColModel() %>
    
    <script type="text/javascript">
    
    function loadData(ids)
    {
        gridStore.baseParams.Ids = ids;
        gridStore.load();
    }
    
    var viewGrid = null;
    Ext.BLANK_IMAGE_URL = "../ext3/resources/images/default/s.gif"
Ext.onReady(function() {


    /*------实现toolbar的函数 start---------------*/
    var Toolbar = new Ext.Toolbar({
        renderTo: 'toolbar',
        region: "north",
        height: 25,
        items:[{
                text: "保存",
                icon: "../Theme/1/images/extjs/customer/save.gif",
                handler: function() { saveType="Add"; saveRecord(); }
            }, '-']
    });
    
    function saveRecord()
    {
        Ext.Msg.wait('正在保存数据','系统提示');
        var xml = encodeURIComponent(JsonToXml(gridStore,colModel));
         Ext.Ajax.request({
                    url: 'frmOtherUpdate.aspx?method=save',
                    method: 'POST',
                    params: {
                        formType:formType,
                        xml: xml
                    },
                   success: function(resp,opts){ 
                        Ext.Msg.hide();
                        checkExtMessage(resp);
                   }
                   ,
                   failure: function(resp, opts) {
                    Ext.Msg.hide();
                        Ext.Msg.alert("提示", "保存出错！");
            }});
    }

    var sm = new Ext.grid.CheckboxSelectionModel({
        singleSelect: true
    });
    
//    ,'-',{
//　　　　　　　　　　　text:'查询',
//　　　　　　　　　　　iconCls:'query',
//　　　　　　　　　　　handler:function()
//　　　　　　　　　　　{
//　　　　　　　　　　　  gridStore.baseParams.CreateDate=document.getElementById('itemDateFrom').value;
//　　　　　　　　　　　  gridStore.load();
//　　　　　　　　　　　}}
    //合计项
    viewGrid = new Ext.grid.EditorGridPanel({
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
            tbar:["<font color='red'>单位：吨</font>",'-','日期:　',　{
　　　　　　　　　　　　id　:　'itemDateFrom',
　　　　　　　　　　　　xtype　:　'datefield',
　　　　　　　　　　　　format　:　'Y-m-d',
　　　　　　　　　　　　readOnly　:　true,
　　　　　　　　　　　　listeners:{
　　　　　　　　　　　　change:function(){
　　　　　　　　　　　　    gridStore.baseParams.CreateDate=document.getElementById('itemDateFrom').value;
　　　　　　　　　　　      gridStore.load();
　　　　　　　　　　　　}}
　　　　　　　　},'-',{
　　　　　　　　　　　text:'计算合计',
　　　　　　　　　　　iconCls:'query',
　　　　　　　　　　　handler:function()
　　　　　　　　　　　{
　　　　　　　　　　　  computeSumValue();
　　　　　　　　　　　}},'-',{
　　　　　　　　　　　text:'打印',
　　　　　　　　　　　handler:function()
　　　　　　　　　　　{
　　　　　　　　　　　      PrintList();
　　　　　　　　　　　}}],
            viewConfig: {
                columnsText: '显示的列',
                scrollOffset: 20,
                sortAscText: '升序',
                sortDescText: '降序',
                forceFit: false
            },
            stripeRows: true,
            height: 450,
            width: 800
        });        
        
        if(ids!='')
        {
            loadData(ids);
        }
        
        dofinish();
    })
    </script>
    
    </head>
<body>
    <form id="form1" runat="server">
    <div id="toolbar"></div>
    <div id="gird"></div>
    <div>
    
    </div>
    </form>
</body>
</html>
<script type="text/javascript">
dofinish=function(){
    <%=doFinish( ) %>
} 
</script>
