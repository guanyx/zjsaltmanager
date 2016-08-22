<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmDrawInvWaitOut.aspx.cs" Inherits="SCM_frmDrawInvWaitOut" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>������֪ͨȷ��</title>
<link rel="stylesheet" type="text/css" href="../ext3/resources/css/ext-all.css" />
<script type="text/javascript" src="../ext3/adapter/ext/ext-base.js"></script>
<script type="text/javascript" src="../ext3/ext-all.js"></script>
<script type="text/javascript" src="../js/operateResp.js"></script>
<script type="text/javascript" src="../ext3/src/locale/ext-lang-zh_CN.js"></script>
<script type="text/javascript" src="../js/operateResp.js"></script>
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
            text: "ȷ��",
            icon: "../Theme/1/images/extjs/customer/add16.gif",
            handler: function() { saveUpdate(); }
        }, '-', {
            text: "ɾ�������",
            icon: "../Theme/1/images/extjs/customer/delete16.gif",
            handler: function() {
                delDrawInv();

            }
        }, '-', {
            text: "�������ӡ",
            icon: "../Theme/1/images/extjs/customer/print1.png",
            handler: function() { printOrderById();}
        }, '-', {
            text: "���͵���ӡ",
            icon: "../Theme/1/images/extjs/customer/print2.png",
            handler: function() { printSendOrder();}
        }, '-', {
            text: "���ᵥ��ӡ",
            icon: "../Theme/1/images/extjs/customer/print3.png",
            handler: function() { printSelfOrder();}
        }, '-'
                   ]
    });
    
    setToolBarVisible(Toolbar);
    /*------����toolbar�ĺ��� end---------------*/
    function getUrl(imageUrl)
            {
                var index = window.location.href.toLowerCase().indexOf('/scm/');
                var tempUrl = window.location.href.substring(0,index);
                return tempUrl+"/"+imageUrl;
            }
function printSelfOrder()
{
    var sm = DrawInvGrid.getSelectionModel();
    //��ѡ
    var selectData = sm.getSelections();                
    var array = new Array(selectData.length);
    var orderIds = "";
    var havePrint ="";
    for(var i=0;i<selectData.length;i++)
    {
        if(orderIds.length>0)
            orderIds+=",";
        orderIds += selectData[i].get('DrawInvId');
        if(selectData[i].get('DrawTypeName').indexOf('����')==-1)
        {
            Ext.Msg.alert("ϵͳ��ʾ","��ѡ�����͵����д�ӡ��");
            return;
        }
        if(selectData[i].get('PrintCount')!='0')
        {
            havePrint+="�����"+selectData[i].get('DrawNumber')+";";
        }
    }
    if(orderIds=="")
    {
        Ext.Msg.alert("ϵͳ��ʾ","��ѡ����Ҫ��ӡ�ĵ�����Ϣ��");
        return;
    }
    if(havePrint.length>0)
    {
        Ext.Msg.confirm("��ʾ��Ϣ", havePrint+"�Ѿ���ӡ���ˣ���Ļ���Ҫ��ӡ��", function callBack(id) {
            //�ж��Ƿ�ɾ������
            if (id == "yes") {
                  printDrawOrder(orderIds,'printdate',printPageWidth,printPageHeight,printStyleXml);
          }
        });  
    }
    else
    {
         printDrawOrder(orderIds,'printdate',printPageWidth,printPageHeight,printStyleXml);
    }
}
function printSendOrder()
{
    var sm = DrawInvGrid.getSelectionModel();
    //��ѡ
    var selectData = sm.getSelections();                
    var array = new Array(selectData.length);
    var orderIds = "";
    var havePrint ="";
    for(var i=0;i<selectData.length;i++)
    {
        if(orderIds.length>0)
            orderIds+=",";
        orderIds += selectData[i].get('DrawInvId');
        if(selectData[i].get('DrawTypeName').indexOf('����')==-1)
        {
            Ext.Msg.alert("ϵͳ��ʾ","��ѡ�����͵����д�ӡ��");
            return;
        }
        if(selectData[i].get('PrintCount')!='0')
        {
            havePrint+="�����"+selectData[i].get('DrawNumber')+";";
        }
    }
    if(orderIds=="")
    {
        Ext.Msg.alert("ϵͳ��ʾ","��ѡ����Ҫ��ӡ�ĵ�����Ϣ��");
        return;
    }
    if(havePrint.length>0)
    {
        Ext.Msg.confirm("��ʾ��Ϣ", havePrint+"�Ѿ���ӡ���ˣ���Ļ���Ҫ��ӡ��", function callBack(id) {
            //�ж��Ƿ�ɾ������
            if (id == "yes") {
                  printDrawOrder(orderIds,'printdate',printPageWidth,printPageHeight,printStyleXml);
          }
        });  
    }
    else
    {
         printDrawOrder(orderIds,'printdate',printPageWidth,printPageHeight,printStyleXml);
    }
    
    
    
}
function setPrintState(){
    var sm = DrawInvGrid.getSelectionModel();
    //��ѡ
    var selectData = sm.getSelections(); 
    for(var i=0;i<selectData.length;i++)
    {
        var times = selectData[i].get('PrintCount');
        selectData[i].set('PrintCount',parseInt(times,10) + 1);
    }
}
function printOrderById()
{
var sm = DrawInvGrid.getSelectionModel();
    //��ѡ
    var selectData = sm.getSelections();                
    var array = new Array(selectData.length);
    var orderIds = "";
    var havePrint="";
    for(var i=0;i<selectData.length;i++)
    {
        if(orderIds.length>0)
            orderIds+=",";
        orderIds += selectData[i].get('DrawInvId');
        if(selectData[i].get('PrintCount')!='0')
        {
            havePrint+="�����"+selectData[i].get('DrawNumber')+";";
        }
    }
    if(orderIds=="")
    {
        Ext.Msg.alert("ϵͳ��ʾ","��ѡ����Ҫ��ӡ�ĵ�����Ϣ��");
        return;
    }
    if(havePrint.length>0)
    {
        Ext.Msg.confirm("��ʾ��Ϣ", havePrint+"�Ѿ���ӡ���ˣ���Ļ���Ҫ��ӡ��", function callBack(id) {
            //�ж��Ƿ�ɾ������
            if (id == "yes") {
                  printDrawOrder(orderIds,'printdate',printPageWidth,printPageHeight,printStyleXml);
          }
        });  
    }
    else
    {
         printDrawOrder(orderIds,'printdate',printPageWidth,printPageHeight,printStyleXml);
    }
                //ҳ���ύ
//                Ext.Ajax.request({
//                    url: 'frmDrawInvWaitOut.aspx?method=selfprintdata',
////                    url:'frmOrderMst.aspx?method=billdata',
//                    method: 'POST',
//                    params: {
//                        DrawInvId: orderIds
//                    },
//                   success: function(resp,opts){ 
//                       var printData =  resp.responseText;
//                       var printControl =  parent.parent.parent.document.getElementById("topFrame").contentWindow.getPrintControl();
//                       printControl.Url =getUrl('xml');
//                       printControl.MapUrl = printControl.Url+'/'+printStyleXml;//'/salePrint1.xml';
//                       printControl.PrintXml = printData;
//                       printControl.ColumnName="DrawInvId";
//                       printControl.OnlyData=printOnlyData;
//                       printControl.PageWidth=printPageWidth;
//                       printControl.PageHeight =printPageHeight ;
//                       printControl.Print();
////                    var billControl = document.getElementById('billControl');
////                    billControl.PrintXml = printData;
////                    billControl.setFormValue(0);
//                       
//                   },
//		           failure: function(resp,opts){  /* Ext.Msg.alert("��ʾ","����ʧ��"); */    }
//                });
}

function printDrawOrder(orderIds,method,width,height,xmlName)
{
     //ҳ���ύ
                Ext.Ajax.request({
                    url: 'frmDrawInvWaitOut.aspx?method='+method,
//                    url:'frmOrderMst.aspx?method=billdata',
                    method: 'POST',
                    params: {
                        DrawInvId: orderIds
                    },
                   success: function(resp,opts){ 
                       var printData =  resp.responseText;
                       var printControl =  parent.parent.parent.document.getElementById("topFrame").contentWindow.getPrintControl();
                       printControl.Url =getUrl('xml');
                       printControl.MapUrl = printControl.Url+'/'+xmlName;//'/salePrint1.xml';
                       printControl.PrintXml = printData;
                       printControl.ColumnName="DrawInvId";
                       printControl.OnlyData=printOnlyData;
                       printControl.PageWidth=width;
                       printControl.PageHeight =height ;
                       printControl.Print();
//                    var billControl = document.getElementById('billControl');
//                    billControl.PrintXml = printData;
//                    billControl.setFormValue(0);

                      //ҳ���ύ
                       Ext.Ajax.request({
                           url: 'frmDrawInvWaitOut.aspx?method=print',
                           method: 'POST',
                           params: {
                               OrderId: orderIds
                           },
                          success: function(resp,opts){ /* checkExtMessage(resp) */ },
		                  failure: function(resp,opts){  /* Ext.Msg.alert("��ʾ","����ʧ��"); */    }
                       });
                       //QueryDataGrid();
                       setPrintState();
                   },
		           failure: function(resp,opts){  /* Ext.Msg.alert("��ʾ","����ʧ��"); */    }
                });
}


    //������б�
    function QueryDataGrid() {
        DrawInvGridData.baseParams.CustomerId = Ext.getCmp('CustomerId').getValue();
        DrawInvGridData.baseParams.StartDate = Ext.util.Format.date(Ext.getCmp('StartDate').getValue(), 'Y/m/d');
        DrawInvGridData.baseParams.EndDate = Ext.util.Format.date(Ext.getCmp('EndDate').getValue(), 'Y/m/d');
        DrawInvGridData.load({
            params: {
                start: 0,
                limit: defaultPageSize
            }
        });
    }

    //����
    function delDrawInv() {
        var sm = DrawInvGrid.getSelectionModel();
        //��ѡ
        var selectData = sm.getSelections();
        var array = new Array(selectData.length);
        for (var i = 0; i < selectData.length; i++) {
            array[i] = selectData[i].get('DrawInvId');
        }

        //���û��ѡ�񣬾���ʾ��Ҫѡ��������Ϣ
        if (selectData == null || selectData == "") {
            Ext.Msg.alert("��ʾ", "��ѡ����Ҫȷ�ϵ��������Ϣ��");
            return;
        }
        Ext.Msg.confirm("��ʾ��Ϣ", "���ɾ�������������ô���������Ӧ�Ķ��������������Ҳ�ᱻɾ�������Ҫɾ����", function callBack(id) {
            //�ж��Ƿ�ɾ������
            if (id == "yes") {
                //ҳ���ύ
                Ext.Ajax.request({
                    url: 'frmDrawInvWaitOut.aspx?method=delDrawInv',
                    method: 'POST',
                    params: {
                        DrawInvId: array[0]
                    },
                    success: function(resp, opts) {
                        if (checkExtMessage(resp)) {
                            DrawInvGrid.getStore().reload();
                        }
                    },
                    failure: function(resp, opts) { Ext.Msg.alert("��ʾ", "��������ʧ�ܣ�"); }
                });
            }
        });


    }

    //����
    function saveUpdate() {
        var sm = DrawInvGrid.getSelectionModel();
        //��ѡ
        var selectData = sm.getSelections();
        var array = new Array(selectData.length);
        for (var i = 0; i < selectData.length; i++) {
            array[i] = selectData[i].get('DrawInvId');
        }

        //���û��ѡ�񣬾���ʾ��Ҫѡ��������Ϣ
        if (selectData == null || selectData == "") {
            Ext.Msg.alert("��ʾ", "��ѡ����Ҫȷ�ϵ��������Ϣ��");
            return;
        }

        //ҳ���ύ
        Ext.Ajax.request({
            url: 'frmDrawInvWaitOut.aspx?method=saveUpdate',
            method: 'POST',
            params: {
                DrawInvId: array.join('-')//��������id��
            },
            success: function(resp, opts) {
                if (checkExtMessage(resp)) {
                    DrawInvGrid.getStore().reload();
                }
            },
            failure: function(resp, opts) { Ext.Msg.alert("��ʾ", "��������ʧ�ܣ�"); }
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
                            url: 'frmDrawInvWaitOut.aspx?method=getDrawInvList',
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
	                            },{
	                                name: 'OrderNumber'
	                            },{name: 'PrintCount'}])

	            ,sortData: function(f, direction) {
                    var tempSort = Ext.util.JSON.encode(DrawInvGridData.sortInfo);
                    if (sortInfor != tempSort) {
                        sortInfor = tempSort;
                        if(tempSort.indexOf("OrderNumber")!=-1)
                        {
                            tempSort = tempSort.replace("OrderNumber","OrderId");
                        }
                        DrawInvGridData.baseParams.SortInfo = tempSort;
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
        toolBar.doLoad(0);
    }, toolBar);
    /*------��ʼDataGrid�ĺ��� start---------------*/

    var sm = new Ext.grid.CheckboxSelectionModel({
        singleSelect: false
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
		                        dataIndex: 'OrderNumber',
		                        sortable: true,
		                        id: 'OrderNumber'
		                    }, {
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
    DrawInvGrid.render();
    /*------DataGrid�ĺ������� End---------------*/


QueryDataGrid();

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
                                pageSize: 10,
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
