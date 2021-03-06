<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmMulCrmSpeakfor.aspx.cs" Inherits="CRM_customer_frmmulCrmSpeakfor" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>客户可订购存货类别设置</title>
    <meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
    <link rel="stylesheet" type="text/css" href="../../ext3/resources/css/ext-all.css" />
	<script type="text/javascript" src="../../ext3/adapter/ext/ext-base.js"></script>	
	<script type="text/javascript" src="../../ext3/ext-all.js"></script>
</head>
<body style="padding: 0px; margin: 0px; width: 100%; height: 100%">
	<div id="toolbar"></div>
    <div id="cfgGrid"></div>
    <div id="cfgNewGrid"></div>
</body>
<script type="text/javascript">
Ext.BLANK_IMAGE_URL = "../../ext3/resources/images/default/s.gif";
var customerId; //当前操作客户的id
var customerName;//客户名称
var cfgListStore = null;

function getParamerValue(name) {
        name = name.replace(/[\[]/, "\\\[").replace(/[\]]/, "\\\]");
        var regexS = "[\\?&]" + name + "=([^&#]*)";
        var regex = new RegExp(regexS);
        var results = regex.exec(window.location.href);
        if (results == null)
            return "";
        else
            return results[1];
    }
    Ext.onReady(function() {
        /*------定义toolbar start---------------*/

        /*------定义新增未配置Grid列表 start ----------*/
        var newCfgListStore = new Ext.data.Store
	({
	    url: 'frmCrmCustomerSpeakfor.aspx?method=getNewNoneCfg',
	    reader: new Ext.data.JsonReader({
	        totalProperty: 'totalProperty',
	        root: 'root'
	    }, [
	        { name: "BuyClassId" },
	        { name: "BuyClassNo" },
	        { name: "BuyClassName" },
	        { name: "Remark" },
	        { name: 'CreateDate' }
	    ])
	});
        var smNewCfg = new Ext.grid.CheckboxSelectionModel(
    {
        singleSelect: false
    }
);

        var cfgNewGrid = new Ext.grid.GridPanel({
            el: 'cfgNewGrid',
            width: '100%',
            height: '100%',
            autoWidth: true,
            //autoHeight:true,
            autoScroll: true,
            layout: 'fit',
            store: newCfgListStore,
            loadMask: { msg: '正在加载数据，请稍侯……' },
            sm: smNewCfg,
            cm: new Ext.grid.ColumnModel([
		smNewCfg,
		new Ext.grid.RowNumberer(), //自动行号
		{
		header: '存货分类编号',
		dataIndex: 'BuyClass',
		id: 'BuyClass',
		hidden: true,
		hideable: false
},
		{
		    header: '存货分类名称',
		    dataIndex: 'BuyClassName',
		    id: 'BuyClassName'
		},
		{
		    header: '备注',
		    dataIndex: 'Remark',
		    id: 'Remark'
		}
		]),
            bbar: new Ext.PagingToolbar({
                pageSize: 10,
                store: newCfgListStore,
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
            stripeRows: true,
            loadMask: true,
            autoExpandColumn: 2
        });
        /*------定义新增未配置Grid列表 end ----------*/

        /*------定义toolbar 函数 start -----------*/
        var cfgNewWin = null;

        function openWindowNewCfg() {
            if (cfgNewWin == null) {
                cfgNewWin = new Ext.Window({
                    title: '客户存货类别增加',
                    id: 'cfgNewWin',
                    width: 550,
                    height: 350,
                    constrain: true,
                    //layout: 'border', 
                    plain: false,
                    modal: true,
                    closeAction: 'hide',
                    autoDestroy: true,
                    resizable: true,
                    items: cfgNewGrid,
                    buttons: [
                    {
                        text: "保存"
                        , handler: function() {
                            saveNewCfg();
                        }
                        , scope: this
                    },
                    {
                        text: "关闭"
                        , handler: function() {
                            cfgNewWin.hide();
                        }
                        , scope: this
}]
                    });
                }

                cfgNewWin.show();

                //将为配置的商品全部取出        

                newCfgListStore.load({
                    params: {
                        limit: 10,
                        start: 0
                    }
                });

            }
            openWindowNewCfg();
            function saveNewCfg() {
                var sm = cfgNewGrid.getSelectionModel();
                var selectData = sm.getSelections();

                if (selectData == null || selectData.length == 0) {
                    Ext.Msg.alert("提示", "请选中一行！");
                }
                else {
                    var array = new Array(selectData.length);
                    for (var i = 0; i < selectData.length; i++) {
                        array[i] = selectData[i].get('BuyClassId');
                    }

                    Ext.Ajax.request({
                        url: 'frmCrmCustomerSpeakfor.aspx?method=saveNewCfgInfo',
                        params: {
                            CustomerId: customerId,
                            BuyClassId: array.join('-')//传入多想的id串
                        },
                        success: function(resp, opts) {
                            //var data=Ext.util.JSON.decode(resp.responseText);
                            Ext.Msg.alert("提示", "保存成功！");
                            cfgGrid.getStore().reload();
                            cfgNewWin.hide();
                        },
                        failure: function(resp, opts) {
                            Ext.Msg.alert("提示", "保存失败！");
                        }
                    });
                }
            }
            customerId = getParamerValue("CustomerId");

        })
</script>
</html>
