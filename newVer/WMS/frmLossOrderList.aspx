<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmLossOrderList.aspx.cs" Inherits="WMS_frmLossOrderList" %>

<html>
<head>
<title>���絥�б�ҳ��</title><meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<link rel="stylesheet" type="text/css" href="../ext3/resources/css/ext-all.css" />
<script type="text/javascript" src="../ext3/adapter/ext/ext-base.js"></script>
<script type="text/javascript" src="../ext3/ext-all.js"></script>
<script type="text/javascript" src="../ext3/src/locale/ext-lang-zh_CN.js"></script>
<script type="text/javascript" src="../js/operateResp.js"></script>
<style  type="text/css">
.x-date-menu {
   width: 175;
}
</style>
</head>
<body>
<div id='toolbar'></div>
<div id='divSearchForm'></div>
<div id='divForm'></div>
<div id='divOrderGrid'></div>

</body>
<%=getComboBoxStore()%>
<script type="text/javascript">
	function getParamerValue( name )
	{
  	name = name.replace(/[\[]/,"\\\[").replace(/[\]]/,"\\\]");
  	var regexS = "[\\?&]"+name+"=([^&#]*)";
  	var regex = new RegExp( regexS );
  	var results = regex.exec( window.location.href );
  	if( results == null )
   	 return "";
  	else
   	 return results[1];
}
var toolbarStatus = getParamerValue("role");
    var bType = getParamerValue("billtype"); //0 - ����  1 - ���
    //alert(parseInt(bType));
    var bName = "����";
    if (parseInt(bType) == 1) {
        bName = "���";
    }
    var BillType = (parseInt(bType) == 1) ? "W0214" : "W0208";
    //alert(BillType+'--'+parent.BillType);
    
    
    window.document.title = bName +"���б�ҳ";
    Ext.BLANK_IMAGE_URL = "../ext3/resources/images/default/s.gif";
    Ext.onReady(function() {
        /*------ʵ��toolbar�ĺ��� start---------------*/
        var windowTitle = "";
        var Toolbar = new Ext.Toolbar({
            renderTo: "toolbar",
            items: [{
                text: "����",
                icon: "../theme/1/images/extjs/customer/add16.gif",
                handler: function() { AddOrderWin(); }
            }, '-', {
                text: "�༭",
                icon: "../theme/1/images/extjs/customer/edit16.gif",
                handler: function() { EditOrderWin(); }
            }, '-', {
                text: "ɾ��",
                icon: "../theme/1/images/extjs/customer/delete16.gif",
                handler: function() { deleteOrderWin(); }
            }, '-', {
                text: "�鿴",
                icon: "../theme/1/images/extjs/customer/view16.gif",
                handler: function() { LookOrderWin(); }
            }, '-', {
                text: "����������",
                icon: "../theme/1/images/extjs/customer/edit16.gif",
                handler: function() { sendCenter(); }
            }, '-', {
                text: "���쵼",
                icon: "../theme/1/images/extjs/customer/edit16.gif",
                handler: function() { sendLeader(); }
            }, '-', {
                text: "�쵼ȷ��",
                icon: "../theme/1/images/extjs/customer/edit16.gif",
                handler: function() { commitLossOrderWin(); }
            }, '-', {
                text: "�˻�",
                icon: "../theme/1/images/extjs/customer/rollback.gif",
                handler: function() { rollbackLossOrderWin(); }
            }, '-', {
                xtype: 'splitbutton',
                text: "��ӡ",
                icon: "../Theme/1/images/extjs/customer/edit16.gif",
                menu:createPrintMenu()
}]
            });
            
            function createPrintMenu()
        {
	        var menu = new Ext.menu.Menu({
                id: 'exportMenu',
                style: {
                    overflow: 'visible'
               },
               items: [
	        {
                   text: '��˰����ӡ',
                   handler: function(){
                     printOrderById(printStyleXml);
                   }
                },
	        {
                   text: '��˰����ӡ',
                   handler: function(){
                    printOrderById(printNoTaxStyleXml);
                   }
                }]});
	        return menu;
        }

            //����Toolbar������
            function setToolbarHidden(index) {
                Toolbar.items.items[index].setVisible(false);
                Toolbar.items.removeAt(index);
                index--;
                if (index > 0) {
                    Toolbar.items.items[index].setVisible(false);
                    Toolbar.items.removeAt(index);
                }
            }

            function defaultToolbarFun() {
                setToolbarHidden(14); //���ػ���
                setToolbarHidden(12); //����ȷ���ύ
                setToolbarHidden(10); //�������쵼                
            }

            function centerToolbarFun() {
                setToolbarHidden(12); //����ȷ���ύ
                setToolbarHidden(8); //��������������
                setToolbarHidden(4);
                setToolbarHidden(2);
                setToolbarHidden(0);
            }
            function leaderToolbarFun() {
                setToolbarHidden(10); //�������쵼
                setToolbarHidden(8); //��������������
                setToolbarHidden(4);
                setToolbarHidden(2);
                setToolbarHidden(0);
            }
            switch (toolbarStatus) {
                case "center":
                    centerToolbarFun();
                    break;
                case "leader":
                    leaderToolbarFun();
                    break;
                default:
                    defaultToolbarFun();
                    break;
            }

            /*------����toolbar�ĺ��� end---------------*/
            function getUrl(imageUrl) {
                var index = window.location.href.toLowerCase().indexOf('/wms/');
                var tempUrl = window.location.href.substring(0, index);
                return tempUrl + "/" + imageUrl;
            }
            function printOrderById(xmlUrl) {
                var sm = userGrid.getSelectionModel();
                //��ѡ
                var selectData = sm.getSelections();
                var array = new Array(selectData.length);
                var orderIds = "";
                for (var i = 0; i < selectData.length; i++) {
                    if (orderIds.length > 0)
                        orderIds += ",";
                    orderIds += selectData[i].get('OrderId');
                }
                //ҳ���ύ
                Ext.Ajax.request({
                    url: 'frmLossOrderList.aspx?method=printdate',
                    method: 'POST',
                    params: {
                        OrderId: orderIds
                    },
                    success: function(resp, opts) {
                        var printData = resp.responseText;
                        var printControl = parent.parent.parent.document.getElementById("topFrame").contentWindow.getPrintControl();
                        printControl.Url = getUrl('xml');
                        printControl.MapUrl = printControl.Url + '/' + xmlUrl; //'/salePrint1.xml';
                        printControl.PrintXml = printData;
                        printControl.ColumnName = "OrderId";
                        printControl.OnlyData = printOnlyData;
                        printControl.PageWidth = printPageWidth;
                        printControl.PageHeight = printPageHeight;
                        printControl.Print();

                    },
                    failure: function(resp, opts) {  /* Ext.Msg.alert("��ʾ","����ʧ��"); */ }
                });
            }
            /*------��ʼToolBar�¼����� start---------------*//*-----����Orderʵ���ര�庯��----*/
            function updateDataGrid() {
                var WhId = WhNamePanel.getValue();
                var StartDate = Ext.util.Format.date(StartDatePanel.getValue(),'Y/m/d');
                var EndDate = Ext.util.Format.date(EndDatePanel.getValue(),'Y/m/d');
                var Status = StatusPanel.getValue();


                userGridData.baseParams.WhId = WhId;
                userGridData.baseParams.StartDate = StartDate;
                userGridData.baseParams.EndDate = EndDate;
                userGridData.baseParams.Status = Status;
                userGridData.baseParams.BillType = BillType;
                userGridData.load({
                    params: {
                        start: 0,
                        limit: 10
                    }
                });

            }

            function AddOrderWin() {
                uploadLossOrderWindow.show();
                uploadLossOrderWindow.setTitle("����" + bName + "��");
                document.getElementById("editLossOrderIFrame").src = "frmLossOrderEdit.aspx?id=0";
                //                if (document.getElementById("editLossOrderIFrame").src.indexOf("frmLossOrderEdit") == -1) {
                //                    document.getElementById("editLossOrderIFrame").src = "frmLossOrderEdit.aspx?id=0";
                //                }
                //                else {
                //                    document.getElementById("editLossOrderIFrame").contentWindow.OrderId = 0;
                //                    document.getElementById("editLossOrderIFrame").contentWindow.UIStatus = "add";
                //                    document.getElementById("editLossOrderIFrame").contentWindow.setAllValue();
                //                }
            }

            function EditOrderWin() {
                var sm = userGrid.getSelectionModel();
                //��ȡѡ���������Ϣ
                var selectData = sm.getSelected();
                if (selectData == null) {
                    Ext.Msg.alert("��ʾ", "��ѡ��" + bName + "����¼��");
                    return;
                }
                if (selectData.data.Status != 0)//����δ���״̬
                {
                    Ext.Msg.alert("��ʾ", "��" + bName + "�����ύ�������ٱ༭��");
                    return;
                }
                uploadLossOrderWindow.show();
                uploadLossOrderWindow.setTitle("�༭" + bName + "��");
                document.getElementById("editLossOrderIFrame").src = "frmLossOrderEdit.aspx?id=" + selectData.data.OrderId;
                //                if (document.getElementById("editLossOrderIFrame").src.indexOf("frmLossOrderEdit") == -1) {
                //                    document.getElementById("editLossOrderIFrame").src = "frmLossOrderEdit.aspx?id=" + selectData.data.OrderId;
                //                }
                //                else {
                //                    document.getElementById("editLossOrderIFrame").contentWindow.OrderId = selectData.data.OrderId;
                //                    document.getElementById("editLossOrderIFrame").contentWindow.UIStatus = "edit";
                //                    document.getElementById("editLossOrderIFrame").contentWindow.setAllValue();
                //                }
            }

            function LookOrderWin() {
                var sm = userGrid.getSelectionModel();
                //��ȡѡ���������Ϣ
                var selectData = sm.getSelected();
                if (selectData == null) {
                    Ext.Msg.alert("��ʾ", "��ѡ��" + bName + "����¼��");
                    return;
                }

                uploadLossOrderWindow.show();
                uploadLossOrderWindow.setTitle("�鿴" + bName + "��");
                document.getElementById("editLossOrderIFrame").src = "frmLossOrderEdit.aspx?id=" + selectData.data.OrderId + "&status=look";
                //                if (document.getElementById("editLossOrderIFrame").src.indexOf("frmLossOrderEdit") == -1) {
                //                    document.getElementById("editLossOrderIFrame").src = "frmLossOrderEdit.aspx?id=" + selectData.data.OrderId + "&status=look";
                //                }
                //                else {
                //                    document.getElementById("editLossOrderIFrame").contentWindow.OrderId = selectData.data.OrderId;
                //                    document.getElementById("editLossOrderIFrame").contentWindow.UIStatus = "look";
                //                    document.getElementById("editLossOrderIFrame").contentWindow.setAllValue();
                //                }
            }

            function deleteOrderWin() {
                var sm = userGrid.getSelectionModel();
                //��ȡѡ���������Ϣ
                var selectData = sm.getSelected();
                //���û��ѡ�񣬾���ʾ��Ҫѡ��������Ϣ
                if (selectData == null) {
                    Ext.Msg.alert("��ʾ", "��ѡ����Ҫɾ������Ϣ��");
                    return;
                }
                if (selectData.data.Status != 0)//����δ���״̬
                {
                    Ext.Msg.alert("��ʾ", "���ύ��" + bName + "������ɾ����");
                    return;
                }
                //ɾ��ǰ�ٴ������Ƿ����Ҫɾ��
                Ext.Msg.confirm("��ʾ��Ϣ", "�Ƿ����Ҫɾ��ѡ���" + bName + "����", function callBack(id) {
                    //�ж��Ƿ�ɾ������
                    if (id == "yes") {
                        //ҳ���ύ
                        Ext.Ajax.request({
                            url: 'frmLossOrderList.aspx?method=deleteLossOrder',
                            method: 'POST',
                            params: {
                                OrderId: selectData.data.OrderId
                            },
                            success: function(resp, opts) {
                                Ext.Msg.alert("��ʾ", "����ɾ���ɹ���");
                                updateDataGrid(); //ˢ��ҳ��
                            },
                            failure: function(resp, opts) {
                                Ext.Msg.alert("��ʾ", "����ɾ��ʧ�ܣ�");
                            }
                        });
                    }
                });
            }
            //����������
            function sendCenter() {
                var sm = userGrid.getSelectionModel();
                //��ȡѡ���������Ϣ
                var selectData = sm.getSelected();
                if (selectData == null) {
                    Ext.Msg.alert("��ʾ", "��ѡ��" + bName + "����");
                    return;
                }
                if (selectData.data.Status != 0)//ֻ�вݸ�ʱ����������������
                {
                    Ext.Msg.alert("��ʾ", "���ύ�������ٴ��ύ��");
                    return;
                }

                Ext.Msg.confirm("��ʾ��Ϣ", "�Ƿ����Ҫ�ύѡ���" + bName + "����", function callBack(id) {
                    if (id == "yes") {
                        //ҳ���ύ
                        Ext.Ajax.request({
                            url: 'frmLossOrderList.aspx?method=sendCenter',
                            method: 'POST',
                            params: {
                                OrderId: selectData.data.OrderId
                            },
                            success: function(resp, opts) {
                                Ext.Msg.alert("��ʾ", "" + bName + "�������ύ�ɹ���");
                                updateDataGrid(); //ˢ��ҳ��
                            },
                            failure: function(resp, opts) {
                                Ext.Msg.alert("��ʾ", "" + bName + "�������ύʧ�ܣ�");
                            }
                        });
                    }
                });
            }
            //���쵼
            function sendLeader() {
                var sm = userGrid.getSelectionModel();
                //��ȡѡ���������Ϣ
                var selectData = sm.getSelected();
                if (selectData == null) {
                    Ext.Msg.alert("��ʾ", "��ѡ��" + bName + "����");
                    return;
                }
                if (selectData.data.Status != 1)//ֻ���ϼ�ȷ��ʱ���������쵼ȷ��
                {
                    Ext.Msg.alert("��ʾ", "�ϼ�ȷ��ʱ,�����ύ��");
                    return;
                }

                Ext.Msg.confirm("��ʾ��Ϣ", "�Ƿ����Ҫ�ύѡ���" + bName + "����", function callBack(id) {
                    if (id == "yes") {
                        //ҳ���ύ
                        Ext.Ajax.request({
                            url: 'frmLossOrderList.aspx?method=sendLeader',
                            method: 'POST',
                            params: {
                                OrderId: selectData.data.OrderId
                            },
                            success: function(resp, opts) {
                                if( checkExtMessage(resp) ){
                                    //Ext.Msg.alert("��ʾ", "" + bName + "�������ύ�ɹ���");
                                    updateDataGrid(); //ˢ��ҳ��
                                }
                            },
                            failure: function(resp, opts) {
                                Ext.Msg.alert("��ʾ", "" + bName + "�������ύʧ�ܣ�");
                            }
                        });
                    }
                });
            }
            //�ύ"+bName+"��
            function commitLossOrderWin() {
                var sm = userGrid.getSelectionModel();
                //��ȡѡ���������Ϣ
                var selectData = sm.getSelected();
                if (selectData == null) {
                    Ext.Msg.alert("��ʾ", "��ѡ��" + bName + "����");
                    return;
                }
                if (selectData.data.Status != 2)//���ύ
                {
                    Ext.Msg.alert("��ʾ", "�쵼ȷ��ʱ,�����ύ��");
                    return;
                }

                Ext.Msg.confirm("��ʾ��Ϣ", "�Ƿ����Ҫ�ύѡ���" + bName + "����", function callBack(id) {
                    if (id == "yes") {
                        //ҳ���ύ
                        Ext.Ajax.request({
                            url: 'frmLossOrderList.aspx?method=commitLossOrder',
                            method: 'POST',
                            params: {
                                OrderId: selectData.data.OrderId
                            },
                            success: function(resp, opts) {
                                if(checkExtMessage(resp))
                                {
                                    //Ext.Msg.alert("��ʾ", "" + bName + "�������ύ�ɹ���");
                                    updateDataGrid(); //ˢ��ҳ��
                                }                                
                            },
                            failure: function(resp, opts) {
                                Ext.Msg.alert("��ʾ", "" + bName + "�������ύʧ�ܣ�");
                            }
                        });
                    }
                });
            }
            //����"+bName+"��
            function rollbackLossOrderWin() {
                var sm = userGrid.getSelectionModel();
                //��ȡѡ���������Ϣ
                var selectData = sm.getSelected();
                if (selectData == null) {
                    Ext.Msg.alert("��ʾ", "��ѡ��" + bName + "����");
                    return;
                }
                if (selectData.data.Status == 3)//���ύ
                {
                    Ext.Msg.alert("��ʾ", "�Ѿ�ȷ�ϼ�¼,�����˻أ�");
                    return;
                }
                Ext.Msg.confirm("��ʾ��Ϣ", "�Ƿ����Ҫ�˻�ѡ���" + bName + "����", function callBack(id) {
                    if (id == "yes") {
                        //ҳ���ύ
                        Ext.Ajax.request({
                            url: 'frmLossOrderList.aspx?method=rollbackLossOrder',
                            method: 'POST',
                            params: {
                                OrderId: selectData.data.OrderId
                            },
                            success: function(resp, opts) {
                                if(checkExtMessage(resp))
                                {
                                    Ext.Msg.alert("��ʾ", "" + bName + "�������˻سɹ���");
                                    updateDataGrid(); //ˢ��ҳ��
                                }
                            },
                            failure: function(resp, opts) {
                                Ext.Msg.alert("��ʾ", "" + bName + "�������˻�ʧ�ܣ�");
                            }
                        });
                    }
                });
            }

            /*------��ʼ�������ݵĴ��� Start---------------*/
            if (typeof (uploadLossOrderWindow) == "undefined") {//�������2��windows����
                uploadLossOrderWindow = new Ext.Window({
                    id: 'LossOrderWindow'
		            , iconCls: 'upload-win'
		            , width: 750
		            , height: 490
		            , layout: 'fit'
		            , plain: true
		            , modal: true
		            , constrain: true
		            , resizable: false
		            , closeAction: 'hide'
		            , autoDestroy: true
		            , html: '<iframe id="editLossOrderIFrame" width="100%" height="100%" border=0 src="#"></iframe>'

                });
            }
            uploadLossOrderWindow.addListener("hide", function() {
                updateDataGrid();
            });


            /*------��ʼ��ѯform�ĺ��� start---------------*/

            var WhNamePanel = new Ext.form.ComboBox({
                name: 'WarehouseCombo',
                store: dsWarehouseList,
                displayField: 'WhName',
                valueField: 'WhId',
                typeAhead: true, //�Զ�����һ����������ѡ�ȫ����
                triggerAction: 'all',
                emptyText: '��ѡ��ֿ�',
                selectOnFocus: true,
                forceSelection: true,
                mode: 'local',
                fieldLabel: '�ֿ�',
                anchor: '90%',
                id: 'WhName',
                listeners: { specialkey: function(f, e) { if (e.getKey() == e.ENTER) { Ext.getCmp('Type').focus(); } } }

            });
            var TypePanel = new Ext.form.ComboBox({
                name: 'LossTypeCombo',
                store: dsLossTypeList,
                displayField: 'DicsName',
                valueField: 'DicsCode',
                typeAhead: true, //�Զ�����һ����������ѡ�ȫ����
                triggerAction: 'all',
                emptyText: '��ѡ��' + bName + '����',
                selectOnFocus: true,
                forceSelection: true,
                mode: 'local',
                fieldLabel: bName + '����',
                anchor: '90%',
                id: 'Type',
                listeners: { specialkey: function(f, e) { if (e.getKey() == e.ENTER) { Ext.getCmp('BillStatus').focus(); } } }

            });
            var StatusPanel = new Ext.form.ComboBox({
                name: 'billStatusCombo',
                store: dsBillStatus,
                displayField: 'BillStatusName',
                valueField: 'BillStatusId',
                typeAhead: true, //�Զ�����һ����������ѡ�ȫ����
                triggerAction: 'all',
                value: 0, //δ���
                selectOnFocus: true,
                forceSelection: true,
                editable: false,
                mode: 'local',
                fieldLabel: '����״̬',
                value: (toolbarStatus == 'center') ? 1 : ((toolbarStatus == 'leader') ? 2 : 0),
                anchor: '90%',
                id: 'BillStatus',
                listeners: { specialkey: function(f, e) { if (e.getKey() == e.ENTER) { Ext.getCmp('StartDate').focus(); } } }
            });
            var StartDatePanel = new Ext.form.DateField({
                //style: 'margin-left:0px',
                //cls: 'key',
                xtype: 'datefield',
                fieldLabel: '��ʼʱ��',
                format: 'Y��m��d��',
                anchor: '90%',
                value: new Date().getFirstDateOfMonth().clearTime(),
                id: 'StartDate',
                listeners: { specialkey: function(f, e) { if (e.getKey() == e.ENTER) { Ext.getCmp('EndDate').focus(); } } }
            });
            var EndDatePanel = new Ext.form.DateField({
                //style: 'margin-left:0px',
                //cls: 'key',
                xtype: 'datefield',
                fieldLabel: '����ʱ��',
                anchor: '90%',
                format: 'Y��m��d��',
                id: 'EndDate',
                value: new Date().clearTime(),
                listeners: { specialkey: function(f, e) { if (e.getKey() == e.ENTER) { Ext.getCmp('searchebtnId').focus(); } } }
            });
            var serchform = new Ext.FormPanel({
                renderTo: 'divSearchForm',
                labelAlign: 'left',
                //layout: 'fit',
                buttonAlign: 'right',
                bodyStyle: 'padding:5px',
                frame: true,
                labelWidth: 55,
                items: [{
                    layout: 'column',   //�����Ԫ��Ϊ����Ϊ�в��ַ�ʽ
                    border: false,
                    items: [{
                        columnWidth: .3,
                        layout: 'form',
                        border: false,
                        items: [
                        WhNamePanel
                        ]
                    }, {
                        columnWidth: .3,
                        layout: 'form',
                        border: false,
                        items: [
                        StatusPanel
                        ]
                    }, {
                        columnWidth: .3,
                        layout: 'form',
                        border: false,
                        items: [
                        TypePanel
                        ]
                    }
                    ]
                }
                    ,
                    {

                        layout: 'column',   //�����Ԫ��Ϊ����Ϊ�в��ַ�ʽ
                        border: false,
                        items: [{
                            columnWidth: .3,  //����ռ�õĿ�ȣ���ʶΪ20��
                            layout: 'form',
                            border: false,
                            items: [
                        StartDatePanel
                    ]
                        }, {
                            columnWidth: .3,
                            layout: 'form',
                            border: false,
                            items: [
                        EndDatePanel
                        ]
                        }, {
                            columnWidth: .2,
                            layout: 'form',
                            border: false,
                            items: [{ cls: 'key',
                                xtype: 'button',
                                text: '��ѯ',
                                id: 'searchebtnId',
                                anchor: '50%',
                                handler: function() {
                                    updateDataGrid();
                                }
}]
}]
}]
            });


            /*------��ʼ��ѯform�ĺ��� end---------------*/

            /*------��ʼ��ȡ���ݵĺ��� start---------------*/
            var userGridData = new Ext.data.Store
({
    url: 'frmLossOrderList.aspx?method=getLossOrderList',
    reader: new Ext.data.JsonReader({
        totalProperty: 'totalProperty',
        root: 'root'
    }, [
	{
	    name: 'OrderId'
	},
	{
	    name: 'WhId'
	},
	{
	    name: 'OrgId'
	},
	{
	    name: 'OwnerId'
	},
	{
	    name: 'OperId'
	},
	{
	    name: 'CreateDate'
	},
	{
	    name: 'UpdateDate'
	},
	{
	    name: 'Status'
	},
	{
	    name: 'Type'
	},
	{
	    name: 'OriginBillId'
	},
	{
	    name: 'Remark'
	}
])
	,
    listeners:
	{
	    scope: this,
	    load: function() {
	    }
	}
});

            /*------��ȡ���ݵĺ��� ���� End---------------*/

            /*------��ʼDataGrid�ĺ��� start---------------*/

            var sm = new Ext.grid.CheckboxSelectionModel({
                singleSelect: true
            });
            var userGrid = new Ext.grid.GridPanel({
                el: 'divOrderGrid',
                width: '100%',
                height: '100%',
                autoWidth: true,
                autoHeight: true,
                autoScroll: true,
                layout: 'fit',
                id: '',
                store: userGridData,
                loadMask: { msg: '���ڼ������ݣ����Ժ��' },
                sm: sm,
                cm: new Ext.grid.ColumnModel([
		sm,
		new Ext.grid.RowNumberer(), //�Զ��к�
		{
		header: bName+'����',
		dataIndex: 'OrderId',
		id: 'OrderId'
},
		{
		    header: '�ֿ�',
		    dataIndex: 'WhId',
		    id: 'WhId',
		    renderer: function(val, params, record) {
		        if (dsWarehouseList.getCount() == 0) {
		            dsWarehouseList.load();
		        }
		        dsWarehouseList.each(function(r) {
		            if (val == r.data['WhId']) {
		                val = r.data['WhName'];
		                return;
		            }
		        });
		        return val;
		    }
		},

		{
		    header: '������',
		    dataIndex: 'OperId',
		    id: 'OperId',
		    renderer: function(val, params, record) {
		        if (dsOperationList.getCount() == 0) {
		            dsOperationList.load();
		        }
		        dsOperationList.each(function(r) {
		            if (val == r.data['EmpId']) {
		                val = r.data['EmpName'];
		                return;
		            }
		        });
		        return val;
		    }
		},
		{
		    header: '����ʱ��',
		    dataIndex: 'CreateDate',
		    id: 'CreateDate',
		    format: 'Y��m��d��'
		},
        {
            header: bName + '����',
            dataIndex: 'Type',
            id: 'Type',
            renderer: function(val, params, record) {
                if (dsLossTypeList.getCount() == 0) {
                    dsLossTypeList.load();
                }
                dsLossTypeList.each(function(r) {
                    if (val == r.data['DicsCode']) {
                        val = r.data['DicsName'];
                        return;
                    }
                });
                return val;
            }
        },
        {
            header: 'ԭʼ���ݺ�',
            dataIndex: 'OriginBillId',
            id: 'OriginBillId'
        },
		{
		    header: '����״̬',
		    dataIndex: 'Status',
		    id: 'Status',
		    renderer: function(val, params, record) {
		        if (dsBillStatus.getCount() == 0) {
		            dsBillStatus.load();
		        }
		        dsBillStatus.each(function(r) {
		            if (val == r.data['BillStatusId']) {
		                val = r.data['BillStatusName'];
		                return;
		            }
		        });
		        return val;
		    }
		},

		{
		    header: '��ע',
		    dataIndex: 'Remark',
		    id: 'Remark'
}]),
                bbar: new Ext.PagingToolbar({
                    pageSize: 10,
                    store: userGridData,
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
                closeAction: 'hide',
                stripeRows: true,
                loadMask: true,
                autoExpandColumn: 2
            });
            
            userGrid.on('render', function(grid) {
                var store = grid.getStore();  // Capture the Store.  
                var view = grid.getView();    // Capture the GridView.
            userGrid.tip = new Ext.ToolTip({
                    target: view.mainBody,    // The overall target element.  
                    delegate: '.x-grid3-row', // Each grid row causes its own seperate show and hide.  
                    trackMouse: true,         // Moving within the row should not hide the tip.  
                    renderTo: document.body,  // Render immediately so that tip.body can be referenced prior to the first show.  
                    listeners: {              // Change content dynamically depending on which element triggered the show.  
                        beforeshow: function updateTipBody(tip) {
                            var rowIndex = view.findRowIndex(tip.triggerElement);
                            
                            var element = document.elementFromPoint(tip.x-20, tip.y-20);
                             var v = view.findCellIndex(element);
                             //ϸ����Ϣ
                              if(v==4||v==2||v==3)
                                {
                                    if(showTipRowIndex == rowIndex)
                                        return;
                                    else
                                        showTipRowIndex = rowIndex;
                                        
                                     tip.body.dom.innerHTML="���ڼ������ݡ���";
                                        //ҳ���ύ
                                        Ext.Ajax.request({
                                            url: 'frmLossOrderList.aspx?method=getdetailinfo',
                                            method: 'POST',
                                            params: {
                                                OrderId: grid.getStore().getAt(rowIndex).data.OrderId
                                            },
                                            success: function(resp, opts) {
                                                tip.body.dom.innerHTML = resp.responseText;
                                            },
                                            failure: function(resp, opts) {
                                                userGrid.tip.hide();
                                            }
                                        });
                                }                                
                                else
                                {
                                    userGrid.tip.hide();
                                }
                        }
                    }
                });
    });
    var showTipRowIndex =-1;
            userGrid.render();
            /*------DataGrid�ĺ������� End---------------*/
            updateDataGrid();


        })
</script>

</html>
