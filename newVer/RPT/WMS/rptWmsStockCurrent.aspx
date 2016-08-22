<%@ Page Language="C#" AutoEventWireup="true" CodeFile="rptWmsStockCurrent.aspx.cs" Inherits="WMS_frmWmsStockCurrent" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html runat="server">
<head>
<title>ʵʱ��汨��</title><meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<link rel="stylesheet" type="text/css" href="../../ext3/resources/css/ext-all.css" />
<script type="text/javascript" src="../../ext3/adapter/ext/ext-base.js"></script>
<script type="text/javascript" src="../../ext3/ext-all.js"></script>
<script type="text/javascript" src="../../FusionCharts/FusionCharts.js"></script>
<script type="text/javascript" src="../../FusionCharts/FusionChartsUtil.js"></script>
</head>
<body runat="server">
<div id='toolbar'></div>
<div id='divForm'></div>
<div id='seachFormDiv'></div>
<div id='stockGridDiv'></div>
<div id="chartDiv1" align="center">ͼ�μ�����...</div>
</body>
<%=getComboBoxStore()%>

<script type="text/javascript">
    Ext.onReady(function() {
        var dsWarehousePositionList; //��λ������
        if (dsWarehousePositionList == null) { //��ֹ�ظ�����
            dsWarehousePositionList = new Ext.data.JsonStore({
                totalProperty: "result",
                root: "root",
                url: 'rptWmsStockCurrent.aspx?method=getWarehousePositionList',
                fields: ['WhpId', 'WhpName']
            });
            //dsWarehousePositionList.load();

        }
        function updateDataGrid() {

            var WhId = WhNamePanel.getValue();
            var WhpId = WhpNamePanel.getValue();
            var ProductId = ProductNamePanel.getValue();

            var chartType = "../../FusionCharts/FCF_Bar2D.swf";
            var cashTypeChart = new FusionCharts(chartType,"StockCurrent","700","600");
                      
            Ext.Ajax.request({
		    url:'rptWmsStockCurrent.aspx?method=getCurrentStockList',
		    params:{
			            WhId: WhId,
                        WhpId: WhpId,
                        ProductId: ProductId
		    },
	        success: function(resp,opts){//alert(resp.responseText);
	            createChartSection(chartType,"chartDiv1",resp.responseText,"StockCurrent",false,true);
		        //cashTypeChart.setDataXML(resp.responseText);
		        //cashTypeChart.render("chartDiv1");
	        },
	        failure: function(resp,opts){
		        Ext.Msg.alert("��ʾ","��ȡ�û���Ϣʧ��");
	        }
	        });
	
              
        //    

        }
     

        
        /*------����------Start-----------------------*/
        var WhNamePanel = new Ext.form.ComboBox({
            fieldLabel: '�ֿ�����',
            name: 'warehouseCombo',
            store: dsWarehouseList,
            displayField: 'WhName',
            valueField: 'WhId',
            typeAhead: true, //�Զ�����һ����������ѡ�ȫ����
            triggerAction: 'all',
            emptyText: '��ѡ��ֿ�',
            //valueNotFoundText: 0,
            selectOnFocus: true,
            forceSelection: true,
            anchor: '90%',
            mode: 'local',
            listeners: {
                specialkey: function(f, e) {
                    if (e.getKey() == e.ENTER) {
                        Ext.getCmp('WhpId').focus();
                    }
                }
              ,
                select: function(combo, record, index) {
                    var curWhId = WhNamePanel.getValue();                    
                    dsWarehousePositionList.load({
                        params: {
                            WhId: curWhId
                        }
                    });
                }
            }
        });


        var WhpNamePanel = new Ext.form.ComboBox({
            fieldLabel: '��λ����',
            name: 'warehousePosCombo',
            store: dsWarehousePositionList,
            displayField: 'WhpName',
            valueField: 'WhpId',
            typeAhead: true, //�Զ�����һ����������ѡ�ȫ����
            triggerAction: 'all',
            emptyText: '��ѡ���λ',
            //valueNotFoundText: 0,
            selectOnFocus: true,
            forceSelection: true,
            mode:'local',
            id: 'WhpId',
            anchor: '90%',
            listeners: { specialkey: function(f, e) { if (e.getKey() == e.ENTER) { Ext.getCmp('ProductId').focus(); } },
                blur: function(field) { if (field.getRawValue() == '') { field.clearValue(); } }
            }

        });
        var ProductNamePanel = new Ext.form.ComboBox({
            fieldLabel: '��Ʒ����',
            name: 'productCombo',
            store: dsProductList,
            displayField: 'ProductName',
            valueField: 'ProductId',
            typeAhead: true, //�Զ�����һ����������ѡ�ȫ����
            triggerAction: 'all',
            emptyText: '��ѡ����Ʒ',
            //valueNotFoundText: 0,
            selectOnFocus: true,
            forceSelection: true,
            id: 'ProductId',
            anchor: '90%',
            mode:'local',
            listeners: { specialkey: function(f, e) { if (e.getKey() == e.ENTER) { Ext.getCmp('searchebtnId').focus(); } } }

        });


        var serchform = new Ext.FormPanel({
            renderTo: 'seachFormDiv',
            labelAlign: 'left',
            layout: 'fit',
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
                        WhNamePanel
                    ]
                }, {
                    columnWidth: .3,
                    layout: 'form',
                    border: false,
                    items: [
                        WhpNamePanel
                        ]
                }, {
                    columnWidth: .3,
                    layout: 'form',
                    border: false,
                    items: [
                        ProductNamePanel
                        ]
                }, {
                    columnWidth: .1,
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
                    /*------����------END-------------------------*/

                    /*------��ȡ���ݵĺ��� ���� End---------------*/

                    /*------DataGrid�ĺ������� End---------------*/

                    updateDataGrid();

                })
</script>

</html>

