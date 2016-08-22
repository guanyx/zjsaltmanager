<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmAllotInOrderList.aspx.cs" Inherits="WMS_frmAllotInOrderList" %>

<html>
<head>
<title>������ֵ��б�ҳ��</title><meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<link rel="stylesheet" type="text/css" href="../ext3/resources/css/ext-all.css" />
<script type="text/javascript" src="../ext3/adapter/ext/ext-base.js"></script>
<script type="text/javascript" src="../ext3/ext-all.js"></script>
<script type="text/javascript" src="../ext3/src/locale/ext-lang-zh_CN.js"></script>
<style type="text/css">
.x-date-menu {
   width: 175px;
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
    Ext.BLANK_IMAGE_URL = "../ext3/resources/images/default/s.gif";
    Ext.onReady(function() {
        /*------ʵ��toolbar�ĺ��� start---------------*/
        var windowTitle = "";
        var Toolbar = new Ext.Toolbar({
            renderTo: "toolbar",
            items: [{
                text: "�鿴�ƿⵥ",
                icon: "../theme/1/images/extjs/customer/add16.gif",
                handler: function() { lookOrderWin(); }
            }, '-', {
                text: "������ֵ�",
                icon: "../theme/1/images/extjs/customer/edit16.gif",
                handler: function() { generateOutStockOrderWin(); }
}, '-', {
                text: "��ⵥ��ӡ",
                icon: "../Theme/1/images/extjs/customer/edit16.gif",
                handler: function() {
                    printOutStock();                    
                }
            }]
            });

            /*------����toolbar�ĺ��� end---------------*/
function getUrl(imageUrl) {
                var index = window.location.href.toLowerCase().indexOf('/wms/');
                var tempUrl = window.location.href.substring(0, index);
                return tempUrl + "/" + imageUrl;
            }
        function printOutStock() {
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
                    url: 'frmAllotInOrderList.aspx?method=outprintdate',
                    method: 'POST',
                    params: {
                        OrderId: orderIds
                    },
                    success: function(resp, opts) {
                        
                        var printData = resp.responseText;
                        var printControl = parent.parent.parent.document.getElementById("topFrame").contentWindow.getPrintControl();
                        printControl.Url = getUrl('xml');
                        printControl.MapUrl = printControl.Url + '/' + printOutStyleXml; //'/salePrint1.xml';
                        printControl.PrintXml = printData;
                        printControl.ColumnName = "OrderId";
                        printControl.OnlyData = printOutOnlyData;
                        printControl.PageWidth = printOutPageWidth;
                        printControl.PageHeight = printOutPageHeight;
                        printControl.Print();

                    },
                    failure: function(resp, opts) {  /* Ext.Msg.alert("��ʾ","����ʧ��"); */ }
                });
            }

            /*------��ʼToolBar�¼����� start---------------*//*-----����Orderʵ���ര�庯��----*/
            function updateDataGrid() {

                var OutWhId = OutWhNamePanel.getValue();
                var InWhId = InWhNamePanel.getValue();
                var StartDate = Ext.util.Format.date(StartDatePanel.getValue(),'Y/m/d');
                var EndDate = Ext.util.Format.date(EndDatePanel.getValue(),'Y/m/d');
                var InStatus = InStatusPanel.getValue();

                userGridData.baseParams.OutWhId = OutWhId;
                userGridData.baseParams.InWhId = InWhId;
                userGridData.baseParams.StartDate = StartDate;
                userGridData.baseParams.EndDate = EndDate;
                userGridData.baseParams.InStatus = InStatus;
                userGridData.baseParams.OutStatus = 1;
                
                userGridData.load({
                    params: {
                        start: 0,
                        limit: 10
                    }
                });

            }

            function lookOrderWin() {
                var sm = userGrid.getSelectionModel();
                //��ȡѡ���������Ϣ
                var selectData = sm.getSelected();
                if (selectData == null) {
                    Ext.Msg.alert("��ʾ", "��ѡ���ƿⵥ��¼��");
                    return;
                }
                uploadAllotOrderWindow.show();
                uploadAllotOrderWindow.setTitle("�鿴�ƿⵥ");
                document.getElementById("editAllotOrderIFrame").src = "frmAllotOrderEdit.aspx?type=look&id=" + selectData.data.OrderId;
            }

            //���ɳ��ⵥ
            function generateOutStockOrderWin() {
                var sm = userGrid.getSelectionModel();
                //��ȡѡ���������Ϣ
                var selectData = sm.getSelected();
                if (selectData == null) {
                    Ext.Msg.alert("��ʾ", "��ѡ���ƿⵥ��");
                    return;
                }
                if (selectData.data.InStatus == 1)//�ѳ���״̬
                {
                    Ext.Msg.alert("��ʾ", "���ƿⵥ�Ѿ���֣�");
                    return;
                }
                if (selectData.data.InWhId <= 0)//
                {
                    Ext.Msg.alert("��ʾ", "���ڿ���ֱ���������������ֿ⣡");
                    return;
                }
                uploadOrderWindow.show();
                document.getElementById("editIFrame").src = "frmInStockBill.aspx?type=W0206&id=" + selectData.data.OrderId;
            }

            /*------��ʼ�������ݵĴ��� Start---------------*/
            if (typeof (uploadOrderWindow) == "undefined") {//�������2��windows����
                uploadOrderWindow = new Ext.Window({
                    id: 'Orderformwindow'
		            , iconCls: 'upload-win'
		            , width: 800
		            , height: 515
		            , layout: 'fit'
		            , plain: true
		            , modal: true
		            , constrain: true
		            , resizable: false
		            , closeAction: 'hide'
		            , autoDestroy: true
		            , html: '<iframe id="editIFrame" width="100%" height="100%" border=0 src="frmInStockBill.aspx"></iframe>'

                });
            }
            uploadOrderWindow.addListener("hide", function() {
                updateDataGrid();
            });

            if (typeof (uploadAllotOrderWindow) == "undefined") {//�������2��windows����
                uploadAllotOrderWindow = new Ext.Window({
                    id: 'AllotOrderWindow'
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
		            , html: '<iframe id="editAllotOrderIFrame" width="100%" height="100%" border=0 src="frmAllotOrderEdit.aspx"></iframe>'

                });
            }
            uploadAllotOrderWindow.addListener("hide", function() {
                updateDataGrid();
            });


            /*------��ʼ��ѯform�ĺ��� start---------------*/

            var OutWhNamePanel = new Ext.form.ComboBox({
                name: 'outWarehouseCombo',
                store: dsWarehouseList,
                displayField: 'WhName',
                valueField: 'WhId',
                typeAhead: true, //�Զ�����һ����������ѡ�ȫ����
                triggerAction: 'all',
                emptyText: '��ѡ��ֿ�',
                selectOnFocus: true,
                forceSelection: true,
                mode: 'local',
                fieldLabel: '�����ֿ�',
                anchor: '90%',
                id: 'OutWhName',
                listeners: { specialkey: function(f, e) { if (e.getKey() == e.ENTER) { Ext.getCmp('InWhName').focus(); } } }

            });


            var InWhNamePanel = new Ext.form.ComboBox({
                name: 'inWarehouseCombo',
                store: dsWarehouseAdminList,
                displayField: 'WhName',
                valueField: 'WhId',
                typeAhead: true, //�Զ�����һ����������ѡ�ȫ����
                triggerAction: 'all',
                emptyText: '��ѡ��ֿ�',
                selectOnFocus: true,
                forceSelection: true,
                mode: 'local',
                fieldLabel: '����ֿ�',
                anchor: '90%',
                id: 'InWhName',
                listeners: { specialkey: function(f, e) { if (e.getKey() == e.ENTER) { Ext.getCmp('BillStatus').focus(); } } }
            });

            var InStatusPanel = new Ext.form.ComboBox({
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
                anchor: '90%',
                id: 'BillStatus',
                listeners: { specialkey: function(f, e) { if (e.getKey() == e.ENTER) { Ext.getCmp('StartDate').focus(); } } }
            });
            var StartDatePanel = new Ext.form.DateField({
                style: 'margin-left:0px',
                cls: 'key',
                xtype: 'datefield',
                fieldLabel: '��ʼʱ��',
                format: 'Y��m��d��',
                anchor: '90%',
                value: new Date().getFirstDateOfMonth().clearTime(),
                id: 'StartDate',
                listeners: { specialkey: function(f, e) { if (e.getKey() == e.ENTER) { Ext.getCmp('EndDate').focus(); } } }
            });
            var EndDatePanel = new Ext.form.DateField({
                style: 'margin-left:0px',
                cls: 'key',
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
                        columnWidth: .3,  //����ռ�õĿ�ȣ���ʶΪ20��
                        layout: 'form',
                        border: false,
                        items: [
                        OutWhNamePanel
                    ]
                    }, {
                        columnWidth: .3,
                        layout: 'form',
                        border: false,
                        items: [
                        InWhNamePanel
                        ]
                    }, {
                        columnWidth: .3,
                        layout: 'form',
                        border: false,
                        items: [
                        InStatusPanel
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
    url: 'frmAllotInOrderList.aspx?method=getAllotInOrderList',
    reader: new Ext.data.JsonReader({
        totalProperty: 'totalProperty',
        root: 'root'
    }, [
	{
	    name: 'OrderId'
	},
	{
	    name: 'OutOrg'
	},
	{
	    name: 'InOrg'
	},
	{
	    name: 'OutWhId'
	},
	{
	    name: 'InWhId'
	},
	{
	    name: 'OutWhName'
	},
	{
	    name: 'InWhName'
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
	    name: 'InStatus'
	},
	{
	    name: 'DriverId'
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
		header: '�ƿⵥ��',
		dataIndex: 'OrderId',
		id: 'OrderId'
        }, {
            header: '������λ',
            dataIndex: 'OutOrg',
            id: 'OutOrg',
            renderer: function(val, params, record) {
                if (dsOrgList.getCount() == 0) {
                    dsOrgList.load();
                }
                dsOrgList.each(function(r) {
                    if (val == r.data['OrgId']) {
                        val = r.data['OrgName'];
                        return;
                    }
                });
                return val;
            }
        },
		{
		    header: '�����ֿ�id',
		    dataIndex: 'OutWhId',
		    id: 'OutWhId',
		    hidden: true
		    //		    renderer: function(val, params, record) {
		    //		        if (dsWarehouseList.getCount() == 0) {
		    //		            dsWarehouseList.load();
		    //		        }
		    //		        dsWarehouseList.each(function(r) {
		    //		            if (val == r.data['WhId']) {
		    //		                val = r.data['WhName'];
		    //		                return;
		    //		            }
		    //		        });
		    //		        return val;
		    //		    }
		},
		{
		    header: '�����ֿ�',
		    dataIndex: 'OutWhName',
		    id: 'OutWhName'
		},
		{
		    header: '���뵥λ',
		    dataIndex: 'InOrg',
		    id: 'InOrg',
		    renderer: function(val, params, record) {
		        if (dsOrgList.getCount() == 0) {
		            dsOrgList.load();
		        }
		        dsOrgList.each(function(r) {
		            if (val == r.data['OrgId']) {
		                val = r.data['OrgName'];
		                return;
		            }
		        });
		        return val;
		    }
		},
		{
		    header: '����ֿ�id',
		    dataIndex: 'InWhId',
		    id: 'InWhId',
		    hidden: true
		    //		    renderer: function(val, params, record) {
		    //		        if (dsWarehouseList.getCount() == 0) {
		    //		            dsWarehouseList.load();
		    //		        }
		    //		        dsWarehouseList.each(function(r) {
		    //		            if (val == r.data['WhId']) {
		    //		                val = r.data['WhName'];
		    //		                return;
		    //		            }
		    //		        });
		    //		        return val;
		    //		    }
		},
		{
		    header: '����ֿ�',
		    dataIndex: 'InWhName',
		    id: 'InWhName'
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
		    header: '����״̬',
		    dataIndex: 'InStatus',
		    id: 'InStatus',
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
		    header: '��ʻԱ',
		    dataIndex: 'DriverId',
		    id: 'DriverId',
		    hidden:true
//		    renderer: function(val, params, record) {
//		        if (dsDriverList.getCount() == 0) {
//		            dsDriverList.load();
//		        }
//		        dsDriverList.each(function(r) {
//		            if (val == r.data['DriverId']) {
//		                val = r.data['DriverName'];
//		                return;
//		            }
//		        });
//		        return val;
//		    }
		},
		{
		    header: '��ʻԱ',
		    dataIndex: 'DriverName',
		    id: 'DriverName'
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
                                            url: 'frmAllotOutOrderList.aspx?method=getdetailinfo',
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
