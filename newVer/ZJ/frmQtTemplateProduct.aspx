<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmQtTemplateProduct.aspx.cs" Inherits="ZJ_frmQtTemplateProduct" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>�ͺŶ�Ӧ��Ʒ��Ϣ</title>
    <meta http-equiv="Content-Type" content="text/html; charset=GB2312">
    <link rel="stylesheet" type="text/css" href="../ext3/resources/css/ext-all.css" />
	<script type="text/javascript" src="../ext3/adapter/ext/ext-base.js"></script>	
	<script type="text/javascript" src="../ext3/ext-all.js"></script>
	
<script type="text/javascript">

Ext.onReady(function(){

/* �����ͺŶ�Ӧ�Ĳ�Ʒ��Ϣ */

//������Ʒ��Ϣ
var productGridData = new Ext.data.Store
({
    url: 'frmQtTemplateProduct.aspx?method=getTemplateProduct',
    reader: new Ext.data.JsonReader({
        totalProperty: 'totalProperty',
        root: 'root'
    }, [
	{
	    name: 'ProductId'
	},
	{
	    name: 'ProductNo'
	},
	{
	    name: 'ProductName'
	},
	{
	    name: 'ProductName'
	},
	{
	    name: 'SpecificationsText'
	},
	{
	    name: 'UnitText'
	},
	{
	    name: 'SupplierText'
	},
	])
	,
    sortData: function(f, direction) {
        var tempSort = Ext.util.JSON.encode(productGridData.sortInfo);
        if (sortInfor != tempSort) {
            sortInfor = tempSort;
            productGridData.baseParams.SortInfo = sortInfor;
            productGridData.load({ params: { limit: defaultPageSize, start: 0} });
        }
    },
    listeners:
	{
	    scope: this,
	    load: function() {
	    }
	}
});

        /*------��ʼDataGrid�ĺ��� start---------------*/

        var sm = new Ext.grid.CheckboxSelectionModel({
            singleSelect: false
        });
        var productGrid = new Ext.grid.GridPanel({
            width: '100%',
            height: '100%',
            el:'divGrid',
            //autoWidth:true,
            //autoHeight:true,
            autoScroll: true,
            layout: 'fit',
            id: 'productGrid',
            store: productGridData,
            loadMask: { msg: '���ڼ������ݣ����Ժ��' },
            sm: sm,
            cm: new Ext.grid.ColumnModel([
		sm,
		new Ext.grid.RowNumberer(), //�Զ��к�
		{
		header: '���ID',
		dataIndex: 'ProductId',
		id: 'ProductId',
		hidden: true,
		hideable: false
},
		{
		    header: '������',
		    dataIndex: 'ProductNo',
		    id: 'ProductNo',
		    sortable: true,
		    width: 100
		},
		{
		    header: '�������',
		    dataIndex: 'ProductName',
		    id: 'ProductName',
		    sortable: true,
		    width: 170
		},
		{
		    header: '����',
		    dataIndex: 'OriginText',
		    id: 'OriginText',
		    sortable: true,
		    width: 80
		},
		{
		    header: '��Ӧ��',
		    dataIndex: 'SupplierText',
		    id: 'SupplierText',
		    sortable: true,
		    width: 150
		},
		{
		    header: '���',
		    dataIndex: 'SpecificationsText',
		    id: 'SpecificationsText',
		    sortable: true,
		    width: 40
		},
		{
		    header: '������λ',
		    dataIndex: 'UnitText',
		    id: 'UnitText',
		    sortable: true,
		    width: 60
		}
		]),tbar: new Ext.Toolbar({
	        items:[{
		        text:"����",
		        icon:"../../Theme/1/images/extjs/customer/add16.gif",
		        handler:function(){		       
		            addTypeProduct();
		        }},'-',{
		        text:"ɾ��",
		        icon:"../../Theme/1/images/extjs/customer/delete16.gif",
		        handler:function(){
		            //deleteSmallClassInfo();
		        }
	        }]
        }),
            bbar: toolBar,
            viewConfig: {
                columnsText: '��ʾ����',
                scrollOffset: 20,
                sortAscText: '����',
                sortDescText: '����',
                forceFit: false
            },
            height: 340,
            closeAction: 'hide',
            stripeRows: true,
            loadMask: true//,
            //autoExpandColumn: 2
        });


});
</script>
</head>
<body>
    <form id="form1" runat="server">
    <div>
    
    </div>
    </form>
</body>
</html>
