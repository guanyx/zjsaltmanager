<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmDrawInv.aspx.cs" Inherits="WMS_frmDrawInv" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html>
<head>
    <title>���۳���</title><meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<link rel="stylesheet" type="text/css" href="../ext3/resources/css/ext-all.css" />
<script type="text/javascript" src="../ext3/adapter/ext/ext-base.js"></script>
<script type="text/javascript" src="../ext3/ext-all.js"></script>
<script type="text/javascript" src="../ext3/example/TabCloseMenu.js" charset="gb2312"></script>
<script type="text/javascript" src="../ext3/example/ItemDeleter.js"></script>
<script type="text/javascript" src="../js/operateResp.js"></script>
<script type="text/javascript" src="../ext3/src/locale/ext-lang-zh_CN.js"></script>
<style type="text/css">
.x-grid-back-blue { 
background: #C3D9FF; 
}
.x-date-menu {
   width: 175px;
}
</style>
</head>
<body>
<div id='MainToolbar'></div>
<div id='MainSearchForm'></div>
<div id='MainDataGrid'></div>

</body>
<%=getComboBoxStore()%>
<script type="text/javascript">
var orgId;
var orgName;
var operId;
var whId;
var customerId;
var customerName;
Ext.BLANK_IMAGE_URL = "../ext3/resources/images/default/s.gif"; 
Ext.onReady(function() {
    /*------ʵ��toolbar�ĺ��� start---------------*/
    var Toolbar = new Ext.Toolbar({
        renderTo: "MainToolbar",
        items: [
//        {
//            text: "�鿴�����",
//            icon: "../Theme/1/images/extjs/customer/view16.gif",
//            handler: function() {  }
//        },
        {
            text: "���۳���",
            icon: "../Theme/1/images/extjs/customer/add16.gif",
            handler: function() { OutDraw() ;  }
        },'-',
        {
            text: "ȡ������֪ͨ",
            icon: "../Theme/1/images/extjs/customer/delete16.gif",
            handler: function() { 
                CancelDrawInv();  
            
            }
        },'-',{
        xtype: 'splitbutton',
        text:'���ݴ�ӡ',
        icon: '../../Theme/1/images/extjs/customer/print3.png',
        menu:createMenu()
    }]
        });
        
        function createMenu()
{
	var menu = new Ext.menu.Menu({
        id: 'mainMenu',
        style: {
            overflow: 'visible'
       },
       items: [
	{
           text: '���ⵥ��ӡ',
           icon: '../../Theme/1/images/extjs/customer/print1.png',
           handler: printOrderById
        },
	{
           text: '����װж����ӡ',
           icon: '../../Theme/1/images/extjs/customer/print2.png',
           handler: printLoadrById
        },{
           text: '����������ⵥ��ӡ',
           icon: '../../Theme/1/images/extjs/customer/print3.png',
           handler: printTransById
        }]});
	return menu;
}

function printLoadrById()
{
var sm = OutDrawGrid.getSelectionModel();
                //��ѡ
                var selectData = sm.getSelections();                
                var array = new Array(selectData.length);
                var orderIds = "";
                for(var i=0;i<selectData.length;i++)
                {
                    if(orderIds.length>0)
                        orderIds+=",";
                    orderIds += selectData[i].get('DrawInvId');
                }
                //ҳ���ύ
                Ext.Ajax.request({
                    url: 'frmDrawInv.aspx?method=getrateprintdata',
//                    url:'frmOrderMst.aspx?method=billdata',
                    method: 'POST',
                    params: {
                        DrawInvId: orderIds,
                        TypeName:'����װж����'
                    },
                   success: function(resp,opts){ 
                       var printData =  resp.responseText;
                       var printControl =  parent.parent.parent.document.getElementById("topFrame").contentWindow.getPrintControl();
                       printControl.Url =getUrl('xml');
                       printControl.MapUrl = printControl.Url+'/'+printRateStyleXml;//'/salePrint1.xml';
                       printControl.PrintXml = printData;
                       printControl.ColumnName="OrderId";
                       printControl.OnlyData=printOnlyData;
                       printControl.PageWidth=printRatePageWidth;
                       printControl.PageHeight =printRatePageHeight ;
                       printControl.Print();
                       
                   },
		           failure: function(resp,opts){  
//		                Ext.Msg.alert("��ʾ",resp);   
		            }
                });
}

function printTransById()
{
var sm = OutDrawGrid.getSelectionModel();
                //��ѡ
                var selectData = sm.getSelections();                
                var array = new Array(selectData.length);
                var orderIds = "";
                for(var i=0;i<selectData.length;i++)
                {
                    if(orderIds.length>0)
                        orderIds+=",";
                    orderIds += selectData[i].get('DrawInvId');
                }
                //ҳ���ύ
                Ext.Ajax.request({
                    url: 'frmDrawInv.aspx?method=getrateprintdata',
//                    url:'frmOrderMst.aspx?method=billdata',
                    method: 'POST',
                    params: {
                        DrawInvId: orderIds,
                        TypeName:'�����������'
                    },
                   success: function(resp,opts){ 
                       var printData =  resp.responseText;
                       var printControl =  parent.parent.parent.document.getElementById("topFrame").contentWindow.getPrintControl();
                       printControl.Url =getUrl('xml');
                       printControl.MapUrl = printControl.Url+'/'+printRateStyleXml;//'/salePrint1.xml';
                       printControl.PrintXml = printData;
                       printControl.ColumnName="OrderId";
                       printControl.OnlyData=printOnlyData;
                       printControl.PageWidth=printRatePageWidth;
                       printControl.PageHeight =printRatePageHeight ;
                       printControl.Print();
                       
                   },
		           failure: function(resp,opts){  
//		                Ext.Msg.alert("��ʾ",resp);   
		             }
                });
}
    /*------����toolbar�ĺ��� end---------------*/
function getUrl(imageUrl)
            {
                var index = window.location.href.toLowerCase().indexOf('/wms/');
                var tempUrl = window.location.href.substring(0,index);
                return tempUrl+"/"+imageUrl;
            }
function printOrderById()
{
var sm = OutDrawGrid.getSelectionModel();
                //��ѡ
                var selectData = sm.getSelections();                
                var array = new Array(selectData.length);
                var orderIds = "";
                for(var i=0;i<selectData.length;i++)
                {
                    if(orderIds.length>0)
                        orderIds+=",";
                    orderIds += selectData[i].get('DrawInvId');
                }
                //ҳ���ύ
                Ext.Ajax.request({
                    url: 'frmDrawInv.aspx?method=getprintdata',
//                    url:'frmOrderMst.aspx?method=billdata',
                    method: 'POST',
                    params: {
                        DrawInvId: orderIds
                    },
                   success: function(resp,opts){ 
                       var printData =  resp.responseText;
                       var printControl =  parent.parent.parent.document.getElementById("topFrame").contentWindow.getPrintControl();
                       printControl.Url =getUrl('xml');
                       printControl.MapUrl = printControl.Url+'/'+printStyleXml;//'/salePrint1.xml';
                       printControl.PrintXml = printData;
                       printControl.ColumnName="OrderId";
                       printControl.OnlyData=printOnlyData;
                       printControl.PageWidth=printPageWidth;
                       printControl.PageHeight =printPageHeight ;
                       printControl.Print();
                       
                   },
		           failure: function(resp,opts){  Ext.Msg.alert("��ʾ",resp);   }
                });
}
//����
    function CancelDrawInv() {
        var sm = OutDrawGrid.getSelectionModel();
        //��ѡ
        var selectData = sm.getSelections();
        var array = new Array(selectData.length);
        for (var i = 0; i < selectData.length; i++) {
            array[i] = selectData[i].get('DrawInvId');
            if(selectData[i].data.Status>3)
            {
                Ext.Msg.alert("��ʾ","�ñʵ����Ѿ����⣬������ȡ���ˣ�");
                return;
            }
        }

        //���û��ѡ�񣬾���ʾ��Ҫѡ��������Ϣ
        if (selectData == null || selectData == "") {
            Ext.Msg.alert("��ʾ", "��ѡ����Ҫȡ�����������Ϣ��");
            return;
        }

        //ҳ���ύ
        Ext.Ajax.request({
            url: 'frmDrawInv.aspx?method=canceldrawinvwaitout',
            method: 'POST',
            params: {
                DrawInvId: array.join('-')//��������id��
            },
            success: function(resp, opts) {
                if (checkExtMessage(resp)) {
                    OutDrawGrid.getStore().reload();
                }
            },
            failure: function(resp, opts) { Ext.Msg.alert("��ʾ", "����ȡ��ʧ�ܣ�"); }
        });


    }
    /*-----ʵ�庯��----*/
    function OutDraw() {
    //uploadOrderWindow.show();
    
   
        var sm = OutDrawGrid.getSelectionModel();
        var selectData = sm.getSelected();
        if (selectData == null) {
            Ext.Msg.alert("��ʾ", "��ѡ����Ҫ�༭����Ϣ��");
            return;
        }
        if(selectData.data.Status>3)
        {
            Ext.Msg.alert("��ʾ","�ñʵ����Ѿ����⣬�����ٳ����ˣ�");
            return;
        }
        orgId = selectData.data.OrgId;
        operId = selectData.data.OperId;
        whId = selectData.data.OutStor;
        customerName = selectData.data.CustomerName;
        customerId = selectData.data.CustomerId
        orgName = selectData.data.OrgName;
        uploadOrderWindow.show();
        uploadOrderWindow.setTitle("�������۳��ⵥ");//alert(selectData.data.DrawInvId);
        document.getElementById("SaleIFrame").src = "frmInStockBill.aspx?type=W0202&id="+selectData.data.DrawInvId;
//        if(document.getElementById("SaleIFrame").src.indexOf("frmInStockBill")==-1)
//        {                
//            document.getElementById("SaleIFrame").src ="frmInStockBill.aspx?type=W0202&id="+selectData.data.DrawInvId;
//        }
//        else{
//            document.getElementById("SaleIFrame").contentWindow.OrderId=selectData.data.DrawInvId;                    
//            document.getElementById("SaleIFrame").contentWindow.FromBillType='W0202';
//            document.getElementById("SaleIFrame").contentWindow.setAllKindValue();
//        }
        /*  
        //��ѡ
        var selectData = sm.getSelections();                
        var array = new Array(selectData.length);
        for(var i=0;i<selectData.length;i++)
        {
            array[i] = selectData[i].get('OrderId');
        }

        //���û��ѡ�񣬾���ʾ��Ҫѡ��������Ϣ
        if (selectData == null|| selectData.length == 0) {
            Ext.Msg.alert("��ʾ", "��ѡ����Ҫ����������Ķ�����¼��");
            return;
        }
               
        uploadOrderWindow.show();
        uploadOrderWindow.setTitle("�����ƿⵥ");
        document.getElementById("editShiftPosOrderIFrame").src = "frmShiftPosOrderEdit.aspx?id=0";
                       
        //ҳ���ύ
        Ext.Ajax.request({
            url: 'frmSelfDlv.aspx?method=gener',
            method: 'POST',
            params: {
                OrderId: array.join('-')//��������id��
            },
            success: function(resp, opts) {
                Ext.Msg.alert("��ʾ", "�������ɳɹ���");
                OrderMstGrid.getStore().reload();
                
            },
            failure: function(resp, opts) {
                Ext.Msg.alert("��ʾ", "��������ʧ�ܣ�");
            }
        });
        */
    }
    
    /*------��ʼ�������ݵĴ��� Start---------------*/
    if (typeof (uploadOrderWindow) == "undefined") {//�������2��windows����
        uploadOrderWindow = new Ext.Window({
            id: 'DvlSaleOrderWindow'
            , iconCls: 'upload-win'
            , height:465
            , width:700
            , x:window.screen.width/2 -500
            , y:window.screen.height/2 -300
            //, autoWidth: true
            //, autoHeight: true
            , layout: 'fit'
            , plain: true
            , modal: true
            //, border:false
            , constrain: true
            , resizable: false
            , closeAction: 'hide'
            , autoDestroy: true
            , html: '<iframe id="SaleIFrame" width="100%" height="100%" border=0 src="#"></iframe>'
           //,autoScroll:true
        });
    }
    uploadOrderWindow.addListener("hide", function() {
        OutDrawGridData.reload();
    });
    
    function QueryDataGrid() {
        OutDrawGridData.baseParams.OrgId = <% =ZJSIG.UIProcess.ADM.UIAdmUser.OrgID(this)%>;
        OutDrawGridData.baseParams.DeptId = <% =ZJSIG.UIProcess.ADM.UIAdmUser.DeptID(this)%>;
        OutDrawGridData.baseParams.OutStor = Ext.getCmp('MOutStor').getValue();
        OutDrawGridData.baseParams.CustomerId = Ext.getCmp('MCustomerId').getValue();
        OutDrawGridData.baseParams.DlvType = Ext.getCmp('MDlvType').getValue();
        OutDrawGridData.baseParams.StartDate = Ext.util.Format.date(Ext.getCmp('MStartDate').getValue(),'Y/m/d');
        OutDrawGridData.baseParams.EndDate = Ext.util.Format.date(Ext.getCmp('MEndDate').getValue(),'Y/m/d');
        OutDrawGridData.baseParams.Status = Ext.getCmp('chbOut').getValue();
        OutDrawGridData.baseParams.BillNo = Ext.getCmp('MBillNo').getValue();
        OutDrawGridData.load({
            params: {
                start: 0,
                limit: defaultPageSize
            }
        });
    }
            

      //�ֿ�
       var ck = new Ext.form.ComboBox({
           xtype: 'combo',
           store: dsWareHouse,
           valueField: 'WhId',
           displayField: 'WhName',
           mode: 'local',
           forceSelection: true,
           name:'MOutStor',
           id:'MOutStor',
           emptyValue: '',
           triggerAction: 'all',
           fieldLabel: '�ֿ�',
           selectOnFocus: true,
           anchor: '98%',
           editable:false
       });
               
               
       //��ʼ����
       var ksrq = new Ext.form.DateField({
   		    xtype:'datefield',
	        fieldLabel:'��ʼ����',
	        anchor:'98%',
	        name:'MStartDate',
	        id:'MStartDate',
	        format: 'Y��m��d��',  //���������ʽ
            value:new Date().getFirstDateOfMonth().clearTime()
        });
               
       //��������
       var jsrq = new Ext.form.DateField({
   		    xtype:'datefield',
	        fieldLabel:'��������',
	        anchor:'98%',
	        name:'MEndDate',
	        id:'MEndDate',
	        format: 'Y��m��d��',  //���������ʽ
            value:(new Date()).clearTime()
       });              
               
               
        //��������
        var ddlx = new Ext.form.ComboBox({
           xtype: 'combo',
           store: dsDrawType,
           valueField: 'DicsCode',
           displayField: 'DicsName',
           mode: 'local',
           forceSelection: true,
           editable: false,
           emptyValue: '',
           triggerAction: 'all',
           fieldLabel: '���ͷ�ʽ',
           name:'MDlvType',
           id:'MDlvType',
           selectOnFocus: true,
           anchor: '98%',
           editable:false
       });  
               
       var serchDrawInvform = new Ext.FormPanel({
            renderTo: 'MainSearchForm',
            labelAlign: 'left',
            buttonAlign: 'center',
            bodyStyle: 'padding:5px',
            frame: true,
            labelWidth: 55,
            items:[
            {
                layout:'column',
                border: false,
                items: [
                {
	                layout:'form',
	                border: false,
	                columnWidth:0.3,
	                items: [{
			                xtype:'textfield',
			                fieldLabel:'�ͻ�',
			                columnWidth:0.33,
			                anchor:'98%',
			                name:'MCustomerId',
			                id:'MCustomerId'
		                }]
                } ,		
                {
	                layout:'form',
	                border: false,
	                columnWidth:0.3,
	                items: [ddlx]
                },		
                {
	                layout:'form',
	                border: false,
	                columnWidth:0.25,
	                items: [ck]
                },		
                {
                    layout:'form',
                    border: false,
                    style: 'align:left',
                    columnWidth:0.15,
                    labelWidth: 15,
                    items:[{
                        xtype:'checkbox',
                        id: 'chbOut',
                        boxLabel:'����',
                        name:'chbOut',
                        cls: 'key'
                    }]
                }
            ]},
            {
                layout:'column',
                border: false,
                items: [
                {
                    layout:'form',
                    border: false,
                    columnWidth:0.3,
                    items: [{
		                    xtype:'datefield',
		                    fieldLabel:'��ʼ����',
		                    columnWidth:0.5,
		                    anchor:'98%',
		                    name:'MStartDate',
		                    id:'MStartDate',
		                    value:new Date().getFirstDateOfMonth().clearTime(),
		                    format:'Y��m��d��'
	                    }]
                } ,		
                {
                    layout:'form',
                    border: false,
                    columnWidth:0.3,
                    items: [{
		                    xtype:'datefield',
		                    fieldLabel:'��������',
		                    columnWidth:0.5,
		                    anchor:'98%',
		                    name:'MEndDate',
		                    id:'MEndDate',
		                    value:new Date().clearTime(),
		                    format:'Y��m��d��'
	                    }]
                } ,		
                {
                    layout:'form',
                    border: false,
                    style: 'align:left',
                    columnWidth:0.24,
                    items:[{
                        xtype:'textfield',
		                fieldLabel:'��Ʊ����',
		                columnWidth:0.25,
		                anchor:'98%',
		                name:'MBillNo',
		                id:'MBillNo'
                    }]
                },			
                {
                    layout:'form',
                    border: false,
                    style: 'align:left',
                    columnWidth:0.03,
                    html:'&nbsp;'
                },	
                {
                    layout:'form',
                    border: false,
                    columnWidth:0.12,
                    style: 'align:center',
                    items:[{
                        xtype:'button',
                        id: 'searchMainbtnId',
                        text: '��ѯ',
                        handler: function() {QueryDataGrid();}
                    }]
                }]
            }]
    });


    /*------��ʼ��ȡ���ݵĺ��� start---------------*/
    var OutDrawGridData = new Ext.data.Store
    ({
        url: 'frmDrawInv.aspx?method=getDrawInvList',
        reader: new Ext.data.JsonReader({
            totalProperty: 'totalProperty',
            root: 'root'
        }, [
            {name:'OrderId'},
            {name:'OrgId'},
            {name:'OrgName'},
            {name:'DeptId'},
            {name:'DeptName'},
            {name:'OutStor'},
            {name:'OutStorName'},
            {name:'CustomerId'},
            {name:'CustomerName'},
            {name:'SendDate'},
            {name:'DlvAdd'},
            {name:'DlvDesc'},
            {name:'OrderType'},
            {name:'OrderTypeName'},
            {name:'PayType'},
            {name:'PayTypeName'},
            {name:'BillMode'},
            {name:'BillModeName'},
            {name:'DrawType'},
            {name:'DlvTypeName'},
            {name:'DlvLevel'},
            {name:'DlvLevelName'},
            {name:'Status'},
            {name:'StatusName'},
            {name:'IsPayed'},
            {name:'IsPayedName'},
            {name:'IsBill'},
            {name:'IsBillName'},
            {name:'SaleInvId'},
            {name:'TotalQty'},
            {name:'OutedQty'},
            {name:'TotalAmt'},
            {name:'TotalTax'},
            {name:'DtlCount'},
            {name:'OperId'},
            {name:'OperName'},
            {name:'OperDate'},
            {name:'UpdateDate'},
            {name:'OwnerId'},
            {name:'OwnerName'},
            {name:'BizAudit'},
            {name:'AuditDate'},
            {name:'Remark'},
            {name:'DrawInvId'},
            {name:'DrawNumber'},
            {name:'IsActiveName'},
            {name:'OrderNumber'},
            {name:'BillNo'}	])
            ,
        sortData: function(f, direction) {
            var tempSort = Ext.util.JSON.encode(OutDrawGridData.sortInfo);
            if (sortInfor != tempSort) {
                sortInfor = tempSort;
                if(tempSort.indexOf("OrderNumber")!=-1)
                {
                    tempSort = tempSort.replace("OrderNumber","OrderId");
                }
                OutDrawGridData.baseParams.SortInfo = tempSort;
                OutDrawGridData.load({ params: { limit: defaultPageSize, start: 0} });
            }
        },
        listeners:
        {
            scope: this,
            load: function() {
            }
        }
    });

    var sortInfor="";
    /*------��ȡ���ݵĺ��� ���� End---------------*/

var defaultPageSize = 10;
    var toolBar = new Ext.PagingToolbar({
        pageSize: 10,
        store: OutDrawGridData,
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

    var Mainsm = new Ext.grid.CheckboxSelectionModel({
        singleSelect: true
    });
    var OutDrawGrid = new Ext.grid.GridPanel({
        el: 'MainDataGrid',
        //width: '100%',
        width:document.body.offsetWidth,
        //height: '100%',
        //autoWidth: true,
        //autoHeight: true,
        autoScroll: true,
        layout: 'fit',
        id: '',
        store: OutDrawGridData,
        loadMask: { msg: '���ڼ������ݣ����Ժ��' },
        sm: Mainsm,
        cm: new Ext.grid.ColumnModel([
        
        Mainsm,
        new Ext.grid.RowNumberer(),//�Զ��к�
        {//DrawInvId
            header:'�����ID',
            dataIndex:'DrawInvId',
            id:'DrawInvId',
            hidden:true,
            hideable:false
        },
        {
            header:'������ʶ',
            dataIndex:'OrderId',
            id:'OrderId',
            hidden:true,
            hideable:false
        },
        {
            header:'�������',
            dataIndex:'OrderNumber',
           sortable: true,
            id:'OrderNumber',
            width:95
        },
        {
            header:'������',
            dataIndex:'DrawNumber',
            sortable: true,
            id:'DrawNumber',
            width:95
        },
        {
            header:'����ֿ�',
            dataIndex:'OutStorName',
            id:'OutStorName',
            width:85
        },
        {
            header:'�ͻ�����',
            dataIndex:'CustomerName',
            id:'CustomerName',
            width:180
        },
        {
            header:'�ͻ�����',
            dataIndex:'SendDate',
            sortable: true,
            id:'SendDate',
            renderer: Ext.util.Format.dateRenderer('Y��m��d��'),
            width:95
        },
        {
            header:'���ͷ�ʽ',
            dataIndex:'DrawType',
            id:'DrawType',
            sortable: true,
            renderer:{fn:function(v){
		        //����key��λ�������е�value
		        var index = dsDrawType.find('DicsCode', v);
                var record = dsDrawType.getAt(index);
                return record.data.DicsName;
		     }},
            width:60
        },
        {
            header:'����������',
            dataIndex:'TotalQty',
            id:'TotalQty',
            width:70
        },
        {
            header:'��Ʊ����',
            dataIndex:'BillNo',
            id:'BillNo',
            width:80
        },
        {
            header:'����ʱ��',
            dataIndex:'OperDate',
            id:'OperDate',
            renderer: Ext.util.Format.dateRenderer('Y��m��d�� Hʱi��s��'),
            width:180
        }			]),
        bbar: toolBar,
        viewConfig: {
            columnsText: '��ʾ����',
            scrollOffset: 20,
            sortAscText: '����',
            sortDescText: '����'//,
            //forceFit: true
        },
        height: 280,
        closeAction: 'hide',
        stripeRows: true,
        loadMask: true//,
        //autoExpandColumn: 2
    });
    
    /*------DataGrid�ĺ������� End---------------*/
    QueryDataGrid();
    OutDrawGrid.on('render', function(grid) {  
        var store = grid.getStore();  // Capture the Store.  
  
        var view = grid.getView();    // Capture the GridView.  
  
        OutDrawGrid.tip = new Ext.ToolTip({  
            target: view.mainBody,    // The overall target element.  
      
            delegate: '.x-grid3-row', // Each grid row causes its own seperate show and hide.  
      
            trackMouse: true,         // Moving within the row should not hide the tip.  
      
            renderTo: document.body,  // Render immediately so that tip.body can be referenced prior to the first show.  
      
            listeners: {              // Change content dynamically depending on which element triggered the show.  
      
                beforeshow: function updateTipBody(tip) {  
                    var rowIndex = view.findRowIndex(tip.triggerElement);
                            var element = document.elementFromPoint(tip.x-20, tip.y-20);
                             var v = view.findCellIndex(element);
                             if(v==4||v==5)
                             {
                              
                                if(showTipRowIndex == rowIndex)
                                    return;
                                else
                                    showTipRowIndex = rowIndex;
                                     tip.body.dom.innerHTML="���ڼ������ݡ���";
                                        //ҳ���ύ
                                        Ext.Ajax.request({
                                            url: 'frmDrawInv.aspx?method=getdrawdetail',
                                            method: 'POST',
                                            params: {
                                                DrawInvId: grid.getStore().getAt(rowIndex).data.DrawInvId
                                            },
                                            success: function(resp, opts) {
                                                tip.body.dom.innerHTML = resp.responseText;
                                            },
                                            failure: function(resp, opts) {
                                                OutDrawGrid.tip.hide();
                                            }
                                        });
                                }//ϸ����Ϣ                                                   
                                else
                                {
                                    OutDrawGrid.tip.hide();
                                }
                        
            }  }});
        });  
    var showTipRowIndex=-1;
     OutDrawGrid.render();
    OutDrawGrid.on('rowdblclick', function(grid, rowIndex, e) {
                //������Ʒ��ϸ
                var _record = OutDrawGrid.getStore().getAt(rowIndex).data.DrawInvId;
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
                        width: 500,
                        height: 250,
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
                                url: '../scm/frmDrawInvWaitOut.aspx?method=getDtlInfo',
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
    
});

</script>

</html>
