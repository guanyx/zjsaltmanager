<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmWMSStockInOutRate.aspx.cs" Inherits="WMS_frmWMSStockInOutRate" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>������������</title>
    <meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
    <link rel="Stylesheet" type="text/css" href="../css/columnLock.css" />
    <link rel="stylesheet" type="text/css" href="../ext3/resources/css/ext-all.css" />
    <script type="text/javascript" src="../ext3/adapter/ext/ext-base.js"></script>
    <script type="text/javascript" src="../ext3/ext-all.js"></script>
    <script type="text/javascript" src="../js/columnLock.js"></script>
    <script type="text/javascript" src="../js/FilterControl.js"></script>
    <script type="text/javascript" src="../js/getExcelXml.js"></script>
    <script type="text/javascript" src="../js/GroupFieldSelect.js"></script>
    <script type="text/javascript" src="../js/ExtJsHelper.js"></script>
    <script type="text/javascript" src="../ext3/src/locale/ext-lang-zh_CN.js"></script>
</head>
<script>
    function getCmbStore(columnName) {
        switch (columnName) {
            case "EmpSex":
                return null;
            case "FromBillTypeName":
            var dsFromBillTypeName = new Ext.data.SimpleStore({ 
                fields:['FromBillTypeName','FromBillTypeNameText'],
                data:[['�ɹ����','�ɹ����'],['�������','�������'],
                      ['�ƿ����','�ƿ����'],['�ƿ����','�ƿ����'],['�Ʋ�','�Ʋ�'],
                      ['����','����'],['���','���'],                        
                        ['�����˻�','�����˻�'],['�ɹ��˻�','�ɹ��˻�'],                        
                        ['ֱ����','ֱ����'],['ֱ����','ֱ����'],
                        ['ת����','ת����'],['ת����','ת����'], 
                        ['�ɹ��������','�ɹ��������'],
                        ['�������','�������'],['��������','��������'],
                        ['�̵�','�̵�'],['�����˻�','�����˻�']],                     
                autoLoad: false});
            return dsFromBillTypeName;
        }
        return null;
    }

    var rateAddShowForm = ExtJsShowWin('����ά��', '#', 'rate', 800, 480);
    
Ext.BLANK_IMAGE_URL = "../ext3/resources/images/default/s.gif" ;
Ext.onReady(function() {
    var imageUrl = "../Theme/1/";
    /*------ʵ��toolbar�ĺ��� start---------------*/
    var Toolbar = new Ext.Toolbar({
        renderTo: "toolbar",
        //region: "north",
        height: 25,
        items: [{
            text: "���÷���",
            icon: imageUrl + "images/extjs/customer/add16.gif",
            handler: function() {
                addPay();
                //radioGroup.setValue('2');
            }
}]
        });

        function addPay() {
            //alert(status);
            var sm = stockInOutGrid.getSelectionModel();
            var selectData = sm.getSelected();
            if (selectData == null) {
                Ext.Msg.alert("��ʾ", "��ѡ����Ҫ�鿴����Ϣ��");
                return;
            }
            rateAddShowForm.show();
            if (document.getElementById("iframerate").src.indexOf("frmWmsRateList") == -1) {
                document.getElementById("iframerate").src = "frmWmsRateList.aspx?action=add&detailId=" + selectData.data.OrderDetailId;
            }
            else {
                document.getElementById("iframerate").contentWindow.detailId = selectData.data.OrderDetailId;
                document.getElementById("iframerate").contentWindow.loadRateList();
            }
        }
        /*------��ʼ��ȡ���ݵĺ��� start---------------*/
        var stockInOutData = new Ext.data.Store
({
    url: 'frmWMSStockInOutRate.aspx?method=getlistinout',
    reader: new Ext.data.JsonReader({
        totalProperty: 'totalProperty',
        root: 'root'
    }, [
	{ name: 'OrderId', type: 'int' },
	{ name: 'WhId', type: 'int' },
	{ name: 'CreateDate', type: 'date' },
	{ name: 'OrgId', type: 'int' },
	{ name: 'TransAmount', type: 'float' },
	{ name: 'OrderDetailId', type: 'int' },
	{ name: 'WhpId', type: 'int' },
	{ name: 'ProductId', type: 'int' },
	{ name: 'ProductPrice', type: 'float' },
	{ name: 'BookQty', type: 'float' },
	{ name: 'RealQty', type: 'float' },
	{ name: 'CustomerId', type: 'int' },
	{ name: 'FromBillType' },
	{ name: 'FromBillId', type: 'int' },
	{ name: 'LoadComId', type: 'int' },
	{ name: 'CarBoatNo'},
	{ name: 'OrgName' },
	{ name: 'CustomerName' },
	{ name: 'TrainTypeName' },
	{ name: 'FromBillTypeName' },
	{ name: 'WhName' },
	{ name: 'ProductName' }
	]),
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
            singleSelect: true,
            width: 20
        });
        //sm.locked = true;

        var rowNum = new Ext.grid.RowNumberer();
        rowNum.locked = true;
        rowNum.width = 40;


        var stockInOutGrid = new Ext.ux.grid.LockingGridPanel({
            el: 'gird',
            width: document.body.clientWidth - 5,
            stripeRows: true,
            autoScroll: true,
            layout: 'fit',
            id: 'stockInOutGrid',
            store: stockInOutData,
            loadMask: { msg: '���ڼ������ݣ����Ժ��' },
            sm: sm,
            columns: [
		sm,
		rowNum, //�Զ��к�
		{
		dataIndex: 'WhId',
		id: 'WhId',
		hidden: true
}, {
    header: '�ֿ�����',
    dataIndex: 'WhName',
    id: 'WhName',
    locked: true,
    width: 120
}, {
    header: '��Ʒ����',
    dataIndex: 'ProductName',
    width: 150,
    locked: true,
    id: 'ProductName'
},
		{
		    header: '��������',
		    dataIndex: 'CreateDate',
		    width: 80,
		    renderer: Ext.util.Format.dateRenderer('Y-m-d'),
		    id: 'CreateDate'
		},
		{
		    header: '��������',
		    dataIndex: 'BookQty',
		    width: 80,
		    id: 'BookQty'
		},
		{
		    header: 'ȷ������',
		    dataIndex: 'RealQty',
		    width: 80,
		    id: 'RealQty'
		},
		{
		    header: '��������',
		    dataIndex: 'OrgName',
		    width: 200,
		    id: 'OrgName',
		    hidden:true
		},
		{
		    header: '�ͻ�����',
		    dataIndex: 'CustomerName',
		    width: 200,
		    id: 'CustomerName'
		},
		{
		    header: '������',
		    dataIndex: 'CarBoatNo',
		    width: 80,
		    id: 'CarBoatNo'
		},
		{
		    header: '��������',
		    dataIndex: 'TrainTypeName',
		    width: 80,
		    id: 'TrainTypeName'
		},
		{
		    header: '��ҵ����',
		    dataIndex: 'FromBillTypeName',
		    width: 80,
		    id: 'FromBillTypeName'
		}
		],
            bbar: new Ext.PagingToolbar({
                pageSize: 10,
                store: stockInOutData,
                displayMsg: '��ʾ��{0}����{1}����¼,��{2}��',
                emptyMsy: 'û�м�¼',
                displayInfo: true
            }),
            viewConfig: {
                columnsText: '��ʾ����',
                scrollOffset: 20,
                sortAscText: '����',
                sortDescText: '����'

            },
            height: 320
        });
        stockInOutGrid.render();
        /*------DataGrid�ĺ������� End---------------*/

        _grid = stockInOutGrid;
        iniSelectColumn(Toolbar, "searchGrid");
        createSearch(stockInOutGrid, stockInOutData, "searchForm");
        searchForm.el = "searchForm";
        searchForm.render();

        btnFliter.on("click", staticSeach);

        function staticSeach() {
            var json = "";
            filterStore.each(function(filterStore) {
                json += Ext.util.JSON.encode(filterStore.data) + ',';
            });
            searchDataGrid(json);
        }

    })
</script>
<body>
    <form id="form1" runat="server">
    <div id="toolbar"></div>
    <div id="searchForm"></div>
    <div id="gird"></div>
    <div id="searchGrid"></div>
    </form>
</body>
</html>
