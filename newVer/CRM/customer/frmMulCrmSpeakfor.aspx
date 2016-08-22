<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmMulCrmSpeakfor.aspx.cs" Inherits="CRM_customer_frmmulCrmSpeakfor" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>�ͻ��ɶ�������������</title>
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
var customerId; //��ǰ�����ͻ���id
var customerName;//�ͻ�����
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
        /*------����toolbar start---------------*/

        /*------��������δ����Grid�б� start ----------*/
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
            loadMask: { msg: '���ڼ������ݣ����Ժ��' },
            sm: smNewCfg,
            cm: new Ext.grid.ColumnModel([
		smNewCfg,
		new Ext.grid.RowNumberer(), //�Զ��к�
		{
		header: '���������',
		dataIndex: 'BuyClass',
		id: 'BuyClass',
		hidden: true,
		hideable: false
},
		{
		    header: '�����������',
		    dataIndex: 'BuyClassName',
		    id: 'BuyClassName'
		},
		{
		    header: '��ע',
		    dataIndex: 'Remark',
		    id: 'Remark'
		}
		]),
            bbar: new Ext.PagingToolbar({
                pageSize: 10,
                store: newCfgListStore,
                displayMsg: '��ʾ��{0}����{1}����¼,��{2}��',
                emptyMsy: 'û�м�¼',
                displayInfo: true
            }),
            viewConfig: {
                columnsText: '��ʾ����',
                scrollOffset: 20,
                sortAscText: '����',
                sortDescText: '����',
                forceFit: true
            },
            height: 280,
            stripeRows: true,
            loadMask: true,
            autoExpandColumn: 2
        });
        /*------��������δ����Grid�б� end ----------*/

        /*------����toolbar ���� start -----------*/
        var cfgNewWin = null;

        function openWindowNewCfg() {
            if (cfgNewWin == null) {
                cfgNewWin = new Ext.Window({
                    title: '�ͻ�����������',
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
                        text: "����"
                        , handler: function() {
                            saveNewCfg();
                        }
                        , scope: this
                    },
                    {
                        text: "�ر�"
                        , handler: function() {
                            cfgNewWin.hide();
                        }
                        , scope: this
}]
                    });
                }

                cfgNewWin.show();

                //��Ϊ���õ���Ʒȫ��ȡ��        

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
                    Ext.Msg.alert("��ʾ", "��ѡ��һ�У�");
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
                            BuyClassId: array.join('-')//��������id��
                        },
                        success: function(resp, opts) {
                            //var data=Ext.util.JSON.decode(resp.responseText);
                            Ext.Msg.alert("��ʾ", "����ɹ���");
                            cfgGrid.getStore().reload();
                            cfgNewWin.hide();
                        },
                        failure: function(resp, opts) {
                            Ext.Msg.alert("��ʾ", "����ʧ�ܣ�");
                        }
                    });
                }
            }
            customerId = getParamerValue("CustomerId");

        })
</script>
</html>
