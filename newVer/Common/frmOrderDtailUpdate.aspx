<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmOrderDtailUpdate.aspx.cs" Inherits="Common_frmOrderDtailUpdate" %>

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
    <script type="text/javascript" src="../js/GroupHeaderPlugin.js"></script>
    <link rel="stylesheet" href="../css/Ext.ux.grid.GridSummary.css"/>
    <script type="text/javascript" src="../js/FilterControl.js"></script>
    <script src='../js/Ext.ux.grid.GridSummary.js'></script>
   
    <script src="../js/ExtJsHelper.js"></script>
    <script src="../js/operateResp.js"></script>
    
    
    <%=getColModel() %>
    
    <script>
    
    function loadData(orderIds)
    {
        gridStore.baseParams.OrderIds = orderIds;
        gridStore.load();
    }
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
                    url: 'frmOrderDtailUpdate.aspx?method=save',
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
            viewConfig: {
                columnsText: '显示的列',
                scrollOffset: 20,
                sortAscText: '升序',
                sortDescText: '降序',
                forceFit: false
            },
            stripeRows: true,
            height: 340,
            width: 565
        });
        
        if(orderIds!='')
        {
            loadData(orderIds);
        }
        
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

