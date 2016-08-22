<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmDrawInvSplit.aspx.cs" Inherits="SCM_frmDrawInvSplit" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>������ָ�</title>
<link rel="stylesheet" type="text/css" href="../ext3/resources/css/ext-all.css" />
<script type="text/javascript" src="../ext3/adapter/ext/ext-base.js"></script>
<script type="text/javascript" src="../ext3/ext-all.js"></script>
<script type="text/javascript" src="../js/operateResp.js"></script>
<script type="text/javascript" src="../ext3/src/locale/ext-lang-zh_CN.js"></script>
<style type="text/css">
.x-grid-back-blue { 
background: #B7CBE8; 
}
.x-date-menu {
   width: 175px;
}
</style>
</head>
<body>    
    <div id='toolbar'></div>
    <div id="searchForm"></div>
    <div id="DrawInvGrid"></div>
</body>

<!-- ��������Դ��ӡ������ -->
<%= getComboBoxStore() %>

<script type="text/javascript">
Ext.BLANK_IMAGE_URL = "../ext3/resources/images/default/s.gif";  //��Ϊ���������������������ͼƬ��ʾ
Ext.onReady(function() {

    /*------ʵ��toolbar�ĺ��� start---------------*/
    var Toolbar = new Ext.Toolbar({
        renderTo: "toolbar",
        items: [{
            text: "�ָ�",
            icon: "../Theme/1/images/extjs/customer/add16.gif",
            handler: function() { popModifyWin(); }
        }, '-', {
            text: "��ӡ",
            icon: "../Theme/1/images/extjs/customer/edit16.gif",
            handler: function() { }
        }
                   ]
    });
    /*------����toolbar�ĺ��� end---------------*/


    //������б�
    function QueryDataGrid() {
        DrawInvGridData.baseParams.CustomerNo = Ext.getCmp('CustomerId').getValue();
        DrawInvGridData.baseParams.StartDate = Ext.util.Format.date(Ext.getCmp('StartDate').getValue(), 'Y/m/d');
        DrawInvGridData.baseParams.EndDate = Ext.util.Format.date(Ext.getCmp('EndDate').getValue(), 'Y/m/d');
        DrawInvGridData.load({
            params: {
                start: 0,
                limit: 10
            }
        });
    }


    //����������ϸ��ѯ
    function QueryDrawDtlDataGrid() {
        var sm = DrawInvGrid.getSelectionModel();
        var selectData = sm.getSelected();
        //���û��ѡ�񣬾���ʾ��Ҫѡ��������Ϣ
        if (selectData == null || selectData == "") {
            Ext.Msg.alert("��ʾ", "��ѡ����Ҫ�ָ�ĵ��ݣ�");
            return;
        }
        ModDtlGridData.load({
            params: {
                start: 0,
                limit: 20,
                DrawInvId: selectData.data.DrawInvId
            }
        });
    }

    //����������ʾ
    function popModifyWin() {
        var sm = DrawInvGrid.getSelectionModel();
        //��ȡѡ���������Ϣ
        var selectData = sm.getSelected();
        if (selectData == null) {
            Ext.Msg.alert("��ʾ", "��ѡ����Ҫ�༭����Ϣ��");
            return;
        }
        openModWin.show();
        Ext.getCmp("CustomerCode").setValue(selectData.data.CustomerCode);
        Ext.getCmp("CustomerName").setValue(selectData.data.CustomerName);
        Ext.getCmp("DrawType").setValue(selectData.data.DrawType);
        Ext.getCmp("TotalQty").setValue(selectData.data.TotalQty);
        Ext.getCmp("TotalAmt").setValue(selectData.data.TotalAmt);
        QueryDrawDtlDataGrid();
    }


    //����
    function saveUpdate() {
        //check
        var isCheck = true;
        ModDtlGridData.each(function(record) {
            var productid = record.get('ProductId');
            if (productid != undefined && productid != null && productid != "" && parseInt(productid) > 0) {
                if (record.get('CheckQty') > record.get('DrawQty')) {
                    Ext.Msg.alert("��ʾ", "Ԥ���������ܴ�����������");
                    isCheck = false;
                    return;
                }
            }
        });

        if (!isCheck)
            return;

        //��ȡ������Ϣ
        var sm = DrawInvGrid.getSelectionModel();
        var selectData = sm.getSelected();
        //��װ��ϸ����Ϣ
        var json = "";
        ModDtlGridData.each(function(ModDtlGridData) {
            json += Ext.util.JSON.encode(ModDtlGridData.data) + ',';
        });

        var sendDate = Ext.getCmp('SendDate').getValue();
        Ext.Ajax.request({
            url: 'frmDrawInvSplit.aspx?method=saveUpdate',
            method: 'POST',
            params: {
                DrawInvId: selectData.data.DrawInvId,
                SendDate: Ext.util.Format.date(sendDate, 'Y/m/d'),
                //��ϸ����
                DetailInfo: json
            },
            success: function(resp, opts) { Ext.Msg.alert("��ʾ", "����ɹ�"); openModWin.hide(); DrawInvGridData.reload(); },
            failure: function(resp, opts) { Ext.Msg.alert("��ʾ", "����ʧ��"); }
        });
    }



    /*-----------------------��ѯ����start------------------------*/
    var searchForm = new Ext.form.FormPanel({
        renderTo: 'searchForm',
        frame: true,
        buttonAlign: 'center',
        items: [
            {//��һ��
                layout: 'column',
                items: [
                    {//��һ��Ԫ��
                        layout: 'form',
                        border: false,
                        labelWidth: 70,
                        columnWidth: .3,
                        items: [{
                            xtype: 'textfield',
                            fieldLabel: '�ͻ����',
                            anchor: '95%',
                            id: 'CustomerId',
                            name: 'CustomerId'
}]
                        },
                    {//�ڶ���Ԫ��
                        layout: 'form',
                        border: false,
                        labelWidth: 70,
                        columnWidth: .3,
                        items: [{
                            xtype: 'datefield',
                            fieldLabel: '��ʼ����',
                            anchor: '95%',
                            id: 'StartDate',
                            name: 'StartDate',
                            format: 'Y��m��d��',
                            value: new Date().getFirstDateOfMonth().clearTime(),
                            editable: false
}]
                        },
                    {//������Ԫ��
                        layout: 'form',
                        border: false,
                        labelWidth: 70,
                        columnWidth: .3,
                        items: [{
                            xtype: 'datefield',
                            fieldLabel: '��������',
                            anchor: '95%',
                            id: 'EndDate',
                            name: 'EndDate',
                            format: 'Y��m��d��',
                            value: new Date().clearTime(),
                            editable: false
}]
                        },
                    {//���ĵ�Ԫ��
                        layout: 'form',
                        border: false,
                        labelWidth: 70,
                        columnWidth: .1,
                        items: [{
                            xtype: 'button',
                            text: '��ѯ',
                            width: 70,
                            //iconCls:'excelIcon',
                            scope: this,
                            handler: function() {
                                QueryDataGrid();
                            }
}]
                        }
                ]
            }
        ]
    });
    /*-----------------------��ѯ����end------------------------*/




    /*------��ʼ��ȡ���ݵĺ��� start---------------*/
    var DrawInvGridData = new Ext.data.Store
                        ({
                            url: 'frmDrawInvSplit.aspx?method=getDrawInvList',
                            reader: new Ext.data.JsonReader({
                                totalProperty: 'totalProperty',
                                root: 'root'
                            }, [
                                {
                                    name: 'DrawInvId'
                                },
	                            {
	                                name: 'DrawNumber'
	                            },
	                            {
	                                name: 'OutStor'
	                            },
	                            {
	                                name: 'OutStorName'
	                            },
	                            {
	                                name: 'CustomerId'
	                            },
	                            {
	                                name: 'CustomerName'
	                            },
	                            {
	                                name: 'CustomerCode'
	                            },
	                            {
	                                name: 'DrawType'
	                            },
	                            {
	                                name: 'DrawTypeName'
	                            },
	                            {
	                                name: 'DriverId'
	                            },
	                            {
	                                name: 'DriverName'
	                            },
	                            {
	                                name: 'VehicleId'
	                            },
	                            {
	                                name: 'VehicleName'
	                            },
	                            {
	                                name: 'ControlDate'
	                            },
	                            {
	                                name: 'TotalQty'
	                            },
	                            {
	                                name: 'TotalAmt'
	                            },
	                            {
	                                name: 'OrderId'
	                            }


	                            	])

	            ,sortData: function(f, direction) {
                    var tempSort = Ext.util.JSON.encode(DrawInvGridData.sortInfo);
                    if (sortInfor != tempSort) {
                        sortInfor = tempSort;
                        DrawInvGridData.baseParams.SortInfo = sortInfor;
                        DrawInvGridData.load({ params: { limit: defaultPageSize, start: 0} });
                    }
                },
                            listeners:
	            {
	                scope: this,
	                load: function() {
	                }
	            }
                        });
                        var sortInfor='';
    /*------��ȡ���ݵĺ��� ���� End---------------*/
var defaultPageSize = 10;
    var toolBar = new Ext.PagingToolbar({
        pageSize: 10,
        store: DrawInvGridData,
        displayMsg: '��ʾ��{0}����{1}����¼,��{2}��',
        emptyMsy: 'û�м�¼',
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
        emptyText: '����ÿҳ��¼��',
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
        QueryDataGrid();
    }, toolBar);
    /*------��ʼDataGrid�ĺ��� start---------------*/

    var sm = new Ext.grid.CheckboxSelectionModel({
        singleSelect: true
    });
    var DrawInvGrid = new Ext.grid.GridPanel({
        el: 'DrawInvGrid',
        width: '100%',
        height: '100%',
        autoWidth: true,
        autoHeight: true,
        autoScroll: true,
        layout: 'fit',
        id: '',
        store: DrawInvGridData,
        loadMask: { msg: '���ڼ������ݣ����Ժ��' },
        sm: sm,
        cm: new Ext.grid.ColumnModel([

		                    sm,
		                    new Ext.grid.RowNumberer(), //�Զ��к�
		                    {
		                    header: '�������',
		                    dataIndex: 'DrawInvId',
		                    id: 'DrawInvId',
		                    hidden: true
		                },
		                    {
		                        header: '�������',
		                        dataIndex: 'DrawNumber',
		                        sortable: true,
		                        id: 'DrawNumber'
		                    },
		                    {
		                        header: '�ֿ�',
		                        dataIndex: 'OutStorName',
		                        sortable: true,
		                        id: 'OutStorName'
		                    },
		                    {
		                        header: '�ͻ�����',
		                        dataIndex: 'CustomerCode',
		                        sortable: true,
		                        id: 'CustomerCode'
		                    },
		                    {
		                        header: '�ͻ�����',
		                        dataIndex: 'CustomerName',
		                        sortable: true,
		                        id: 'CustomerName'
		                    },
		                    {
		                        header: '����',
		                        dataIndex: 'DrawTypeName',
		                        sortable: true,
		                        id: 'DrawTypeName'
		                    },
		                    {
		                        header: '����',
		                        dataIndex: 'TotalQty',
		                        id: 'TotalQty'
		                    },
		                    {
		                        header: '����ID',
		                        dataIndex: 'OrderId',
		                        id: 'OrderId',
		                        hidden: true
		                    }


		                    	]),
        bbar: toolBar,
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
    DrawInvGrid.on("afterrender", function(component) {
        component.getBottomToolbar().refresh.hideParent = true;
        component.getBottomToolbar().refresh.hide();
    });
    
    DrawInvGrid.on('render', function(grid) {  
        var store = grid.getStore();  // Capture the Store.  
  
        var view = grid.getView();    // Capture the GridView.  
  
        DrawInvGrid.tip = new Ext.ToolTip({  
            target: view.mainBody,    // The overall target element.  
      
            delegate: '.x-grid3-row', // Each grid row causes its own seperate show and hide.  
      
            trackMouse: true,         // Moving within the row should not hide the tip.  
      
            renderTo: document.body,  // Render immediately so that tip.body can be referenced prior to the first show.  
      
            listeners: {              // Change content dynamically depending on which element triggered the show.  
      
                beforeshow: function updateTipBody(tip) {  
                    var rowIndex = view.findRowIndex(tip.triggerElement);
                            var element = document.elementFromPoint(tip.x-20, tip.y-20);
                             var v = view.findCellIndex(element);
                             if(v==4||v==5||v==3)
                             {
                              
                                if(showTipRowIndex == rowIndex)
                                    return;
                                else
                                    showTipRowIndex = rowIndex;
                                     tip.body.dom.innerHTML="���ڼ������ݡ���";
                                        //ҳ���ύ
                                        Ext.Ajax.request({
                                            url: 'frmDrawInvSplit.aspx?method=getdrawdetail',
                                            method: 'POST',
                                            params: {
                                                DrawInvId: grid.getStore().getAt(rowIndex).data.DrawInvId
                                            },
                                            success: function(resp, opts) {
                                                tip.body.dom.innerHTML = resp.responseText;
                                            },
                                            failure: function(resp, opts) {
                                                DrawInvGrid.tip.hide();
                                            }
                                        });
                                }//ϸ����Ϣ                                                   
                                else
                                {
                                    DrawInvGrid.tip.hide();
                                }
                        
            }  }});
        });  
    var showTipRowIndex=-1;
    
//    DrawInvGrid.on('render', function(grid) {
//        var store = grid.getStore();  // Capture the Store.  
//        var view = grid.getView();    // Capture the GridView.
//        DrawInvGrid.tip = new Ext.ToolTip({
//            target: view.mainBody,    // The overall target element.  
//            delegate: '.x-grid3-row', // Each grid row causes its own seperate show and hide.  
//            trackMouse: true,         // Moving within the row should not hide the tip.  
//            renderTo: document.body,  // Render immediately so that tip.body can be referenced prior to the first show.  
//            listeners: {              // Change content dynamically depending on which element triggered the show.  
//                beforeshow: function updateTipBody(tip) {
//                    var rowIndex = view.findRowIndex(tip.triggerElement);
//                    tip.body.dom.innerHTML = "����˫�����в鿴������ϸ�� "; //store.getAt(rowIndex).id  
//                }
//            }
//        });
//    });
    DrawInvGrid.render();
    /*------DataGrid�ĺ������� End---------------*/




    ////////////////////////Start �޸Ľ���///////////////////////////////////////////////////////////////////////

    var modDtlForm = new Ext.FormPanel({
        labelAlign: 'left',
        buttonAlign: 'right',
        bodyStyle: 'padding:5px',
        frame: true,
        labelWidth: 80,
        items: [
	                {
	                    layout: 'column',
	                    border: false,
	                    labelSeparator: '��',
	                    items: [
		                {
		                    layout: 'form',
		                    border: false,
		                    columnWidth: 0.33,
		                    items: [
				                {
				                    xtype: 'textfield',
				                    fieldLabel: '�ͻ�����',
				                    columnWidth: 0.33,
				                    anchor: '90%',
				                    name: 'CustomerCode',
				                    id: 'CustomerCode',
				                    editable: false
				                }
		                            ]
		                }
                , {
                    layout: 'form',
                    border: false,
                    columnWidth: 0.33,
                    items: [
				                {
				                    xtype: 'textfield',
				                    fieldLabel: '�ͻ�����',
				                    columnWidth: 0.5,
				                    anchor: '90%',
				                    name: 'CustomerName',
				                    id: 'CustomerName',
				                    editable: false
				                }
		                ]
                }
                , {
                    layout: 'form',
                    border: false,
                    columnWidth: 0.34,
                    items: [
				                {
				                    xtype: 'combo',
				                    store: dsDrawType,
				                    valueField: 'DicsCode',
				                    displayField: 'DicsName',
				                    mode: 'local',
				                    forceSelection: true,
				                    editable: false,
				                    emptyValue: '',
				                    triggerAction: 'all',
				                    fieldLabel: '��������',
				                    name: 'DrawType',
				                    id: 'DrawType',
				                    selectOnFocus: true,
				                    anchor: '90%',
				                    editable: false
				                }
		                          ]
                }
	                ]
	                },
	                {
	                    layout: 'column',
	                    border: false,
	                    labelSeparator: '��',
	                    items: [
		                {
		                    layout: 'form',
		                    border: false,
		                    columnWidth: 0.33,
		                    items: [
				                {
				                    xtype: 'textfield',
				                    fieldLabel: '������',
				                    columnWidth: 0.5,
				                    anchor: '90%',
				                    name: 'TotalQty',
				                    id: 'TotalQty',
				                    editable: false
				                }
		                          ]
		                }
                , {
                    layout: 'form',
                    border: false,
                    columnWidth: 0.33,
                    items: [
				                {
				                    xtype: 'textfield',
				                    fieldLabel: '�ܽ��',
				                    columnWidth: 0.5,
				                    anchor: '90%',
				                    name: 'TotalAmt',
				                    id: 'TotalAmt',
				                    editable: false
				                }
		                          ]
                }
                , {
                    layout: 'form',
                    border: false,
                    columnWidth: 0.34,
                    items: [
		                    {
		                        xtype: 'datefield',
		                        fieldLabel: '�ͻ�����*',
		                        anchor: '90%',
		                        id: 'SendDate',
		                        name: 'SendDate',
		                        format: 'Y��m��d��',
		                        value: new Date().clearTime(),
		                        editable: false
		                    }
		                    ]
                }
	                ]
	                }
                ]
    });

    /*------��ʼ��ȡ���ݵĺ��� start---------------*/
    var ModDtlGridData = new Ext.data.Store
                        ({
                            url: 'frmDrawInvSplit.aspx?method=getDrawDtlList',
                            reader: new Ext.data.JsonReader({
                                totalProperty: 'totalProperty',
                                root: 'root'
                            }, [
                                {
                                    name: 'DrawInvDtlId'
                                },
	                            {
	                                name: 'DrawInvId'
	                            },
	                            {
	                                name: 'ProductId'
	                            },
	                            {
	                                name: 'DrawQty'
	                            },
	                            {
	                                name: 'CheckQty'
	                            },
	                            {
	                                name: 'Price'
	                            },
	                            {
	                                name: 'Amt'
	                            },
	                            {
	                                name: 'Tax'
	                            },
	                            {
	                                name: 'SpecName'
	                            },
	                            {
	                                name: 'ProductCode'
	                            },
	                            {
	                                name: 'UnitId'
	                            },
	                            {
	                                name: 'UnitName'
	                            },
	                            {
	                                name: 'ProductName'
}])

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
        singleSelect: false
    });
    var ModOrderDtlGrid = new Ext.grid.EditorGridPanel({
        autoScroll: true,
        height: 220,
        id: '',
        store: ModDtlGridData,
        loadMask: { msg: '���ڼ������ݣ����Ժ��' },
        sm: sm,
        cm: new Ext.grid.ColumnModel([
		                    sm,
		                    new Ext.grid.RowNumberer(), //�Զ��к�
		                    {
		                    header: '��Ʒ����',
		                    dataIndex: 'ProductCode',
		                    id: 'ProductCode'
		                },
		                    {
		                        header: '����',
		                        dataIndex: 'ProductName',
		                        id: 'ProductName'
		                    },
                            {
                                header: '��λ',
                                dataIndex: 'UnitId',
                                id: 'UnitId',
                                hidden: true,
                                hideable: true
                            },
		                    {
		                        header: '��λ',
		                        dataIndex: 'UnitName',
		                        id: 'UnitName'
		                    },
		                    {
		                        header: '���',
		                        dataIndex: 'SpecName',
		                        id: 'SpecName'
		                    },
		                    {
		                        header: '������',
		                        dataIndex: 'DrawQty',
		                        id: 'DrawQty'
		                    },
		                    {
		                        header: 'Ԥ������',
		                        dataIndex: 'CheckQty',
		                        id: 'CheckQty',
		                        editor: new Ext.form.NumberField({ allowBlank: false }),
		                        renderer: function(v, m) {
		                            m.css = 'x-grid-back-blue';
		                            return v;
		                        }
		                    },
		                    {
		                        header: '����',
		                        dataIndex: 'Price',
		                        id: 'Price'
		                    }

		                    ]),
        bbar: new Ext.PagingToolbar({
            pageSize: 20,
            store: ModDtlGridData,
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
        closeAction: 'hide',
        stripeRows: true,
        loadMask: true,
        autoExpandColumn: 2

    });
    ModOrderDtlGrid.on("afterrender", function(component) {
        component.getBottomToolbar().refresh.hideParent = true;
        component.getBottomToolbar().refresh.hide();
    });

    if (typeof (openModWin) == "undefined") {//�������2��windows����
        openModWin = new Ext.Window({
            id: 'openModWin',
            title: '������ָ�'
		            , iconCls: 'upload-win'
		            , width: 750
		            , height: 400
		            , layout: 'form'
		            , plain: true
		            , modal: true
		            , constrain: true
		            , resizable: false
		            , closeAction: 'hide'
		            , autoDestroy: true
		            , items: [

                         { layout: 'form',
                             border: false,
                             columnWidth: 1,
                             items: [modDtlForm]
                         },
                         { layout: 'form',
                             border: false,
                             columnWidth: 1,
                             items: [ModOrderDtlGrid]
                         }

		            ]
		            , buttons: [{
		                text: "����"
			            , handler: function() {
			                saveUpdate();

			            }
			            , scope: this
		            },
		            {
		                text: "ȡ��"
			            , handler: function() {
			                openModWin.hide();
			                DrawInvGridData.reload();
			            }
			            , scope: this
}]
        });
    }
    openModWin.addListener("hide", function() {
    });



    ////////////////////////End �޸Ľ���///////////////////////////////////////////////////////////////////////


    DrawInvGrid.on('rowdblclick', function(grid, rowIndex, e) {
        //������Ʒ��ϸ
        var _record = DrawInvGrid.getStore().getAt(rowIndex).data.DrawInvId;
        if (!_record) {
            // Ext.example.msg('����', '��ѡ��Ҫ�鿴�ļ�¼��');
        } else {
            OpenDtlWin(_record);
        }

    });
    /****************************************************************/
    function OpenDtlWin(orderId) {
        if (typeof (uploadRouteWindow) == "undefined") {
            newFormWin = new Ext.Window({
                layout: 'fit',
                width: 600,
                height: 400,
                closeAction: 'hide',
                plain: true,
                constrain: true,
                modal: true,
                autoDestroy: true,
                title: '��ϸ��Ϣ',
                items: orderDtInfoGrid
            });
        }
        newFormWin.show();
        //������
        orderDtInfoStore.baseParams.DrawInvId = orderId;
        orderDtInfoStore.load({
            params: {
                limit: 100,
                start: 0
            }
        });
    }

    var orderDtInfoStore = new Ext.data.Store
                            ({
                                url: 'frmDrawInvWaitOut.aspx?method=getDtlInfo',
                                reader: new Ext.data.JsonReader({
                                    totalProperty: 'totalProperty',
                                    root: 'root'
                                }, [
	                            { name: 'DrawInvDtlId' },
	                            { name: 'DrawInvId' },
	                            { name: 'ProductId' },
	                            { name: 'ProductCode' },
	                            { name: 'ProductName' },
	                            { name: 'SpecName' },
	                            { name: 'UnitName' },
	                            { name: 'DrawQty' },
	                            { name: 'Price' },
	                            { name: 'Amt' },
	                            { name: 'Tax' }
	                            ])
                            });

    var smDtl = new Ext.grid.CheckboxSelectionModel({
        singleSelect: true
    });
    var orderDtInfoGrid = new Ext.grid.GridPanel({
        width: '100%',
        height: '100%',
        autoWidth: true,
        autoHeight: true,
        autoScroll: true,
        layout: 'fit',
        id: '',
        store: orderDtInfoStore,
        loadMask: { msg: '���ڼ������ݣ����Ժ��' },
        sm: smDtl,
        cm: new Ext.grid.ColumnModel([
		                            smDtl,
		                            new Ext.grid.RowNumberer(), //�Զ��к�
		                            {
		                            header: '������',
		                            dataIndex: 'ProductCode',
		                            id: 'ProductCode'
		                        },
		                            {
		                                header: '�������',
		                                dataIndex: 'ProductName',
		                                id: 'ProductName',
		                                width: 120
		                            },
		                            {
		                                header: '���',
		                                dataIndex: 'SpecName',
		                                id: 'SpecName'
		                            },
		                            {
		                                header: '������λ',
		                                dataIndex: 'UnitName',
		                                id: 'UnitName'
		                            },
		                            {
		                                header: '����',
		                                dataIndex: 'DrawQty',
		                                id: 'DrawQty'
		                            }
		                        ]),
        bbar: new Ext.PagingToolbar({
            pageSize: 20,
            store: orderDtInfoStore,
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

})

</script>

</html>
