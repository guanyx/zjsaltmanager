<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmBillManage.aspx.cs" Inherits="SCM_frmBillManage" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html>
<head>
<title>��Ʊ����</title><meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<link rel="stylesheet" type="text/css" href="../ext3/resources/css/ext-all.css" />
<script type="text/javascript" src="../ext3/adapter/ext/ext-base.js"></script>
<script type="text/javascript" src="../ext3/ext-all.js"></script>
<link rel="stylesheet" type="text/css" href="../ext3/example/file-upload.css" />
<script type="text/javascript" src="../ext3/example/FileUploadField.js"></script>
<script type="text/javascript" src="../ext3/src/locale/ext-lang-zh_CN.js"></script>
<script type="text/javascript" src="../js/operateResp.js"></script>
<script type="text/javascript" src="../js/common.js"></script>
</head>
<body>
<div id='toolbar'></div>
<div id='divSearchForm'></div>
<div id='divDataGrid'></div>
<div id='divDataDtlGrid'></div>
</body>
<%=getComboBoxStore()%>
<script type="text/javascript">
Ext.BLANK_IMAGE_URL = "../ext3/resources/images/default/s.gif"; 
    Ext.onReady(function() {
    
        /*------ʵ��toolbar�ĺ��� start---------------*/
        var Toolbar = new Ext.Toolbar({
            renderTo: "toolbar",
            items: [{
                text: "����",
                icon: "../Theme/1/images/extjs/customer/edit16.gif",
                handler: function() { exportData()  }
            }, '-',{
                text: "����",
                icon: "../Theme/1/images/extjs/customer/add16.gif",
                handler: function() { importData()    }
            }, '-',{
                text: "����",
                icon: "../Theme/1/images/extjs/customer/edit16.gif",
                handler: function() { editData()    }
            }, '-',{
                text: "����",
                icon: "../Theme/1/images/extjs/customer/cross.gif",
                handler: function() { discardData()    }
            }, '-',{
                text: "���",
                icon: "../Theme/1/images/extjs/customer/s_delete.gif",
                handler: function() { rollData()    }
            }, '-',{
                text: "��ϸ��ӡ",
                icon: "../Theme/1/images/extjs/customer/edit16.gif",
                handler: function() { printOrderById()    }
            }]
            });
            /*------����toolbar�ĺ��� end---------------*/
            
            function getUrl(imageUrl)
            {
                var index = window.location.href.toLowerCase().indexOf('/scm/');
                var tempUrl = window.location.href.substring(0,index);
                return tempUrl+"/"+imageUrl;
            }
            
            function printOrderById()
            {
                var sm = OrderMstGrid.getSelectionModel();
                //��ѡ
                var selectData = sm.getSelections();                
                var array = new Array(selectData.length);
                var orderIds = "";
                for(var i=0;i<selectData.length;i++)
                {
                    if(orderIds.length>0)
                        orderIds+=",";
                    orderIds += selectData[i].get('BillId');
                }
                Ext.Ajax.request({
                    url: 'frmBillManage.aspx?method=printdata',
                    method: 'POST',
                    params: {
                        BillId: orderIds
                    },
                   success: function(resp,opts){ 
                       var printData =  resp.responseText;
                       var printControl =  parent.parent.parent.document.getElementById("topFrame").contentWindow.getPrintControl();
                       printControl.Url =getUrl('xml');
                       printControl.MapUrl = printControl.Url+'/'+'billprint.xml';//'/salePrint1.xml';
                       printControl.PrintXml = printData;
                       printControl.ColumnName="BillId";
                       printControl.OnlyData=false;
                       printControl.PageWidth=819;
                       printControl.PageHeight =1158;
                       printControl.Print();
                       
                   },
                   failure: function(resp,opts){  /* Ext.Msg.alert("��ʾ","����ʧ��"); */    }
                });
            }

            function QueryDataGrid() {
                OrderMstGridData.baseParams.OrgId = Ext.getCmp('OrgId').getValue();            
                OrderMstGridData.baseParams.CustomerId = Ext.getCmp('CustomerId').getValue();
                OrderMstGridData.baseParams.BillMode = Ext.getCmp('BillMode').getValue();	
                OrderMstGridData.baseParams.StartDate = Ext.util.Format.date(Ext.getCmp('StartDate').getValue(),'Y/m/d');
                OrderMstGridData.baseParams.EndDate =  Ext.util.Format.date(Ext.getCmp('EndDate').getValue(),'Y/m/d');
                OrderMstGridData.baseParams.IsActive = Ext.getCmp('BillStatus').getValue();
                OrderMstGridData.baseParams.BillNo = Ext.getCmp('SBillNo').getValue();
                
                OrderMstGridData.load({
                    params: {
                        start: 0,
                        limit: defaultPageSize
                    }
                });
            }
            
               //��Ʊ��ʽ
                var kpfs = new Ext.form.ComboBox({
                   xtype: 'combo',
                   store: dsPayType,
                   valueField: 'DicsCode',
                   displayField: 'DicsName',
                   mode: 'local',
                   forceSelection: true,
                   editable: false,
                   emptyValue: '',
                   triggerAction: 'all',
                   fieldLabel: '��Ʊ��ʽ',
                   name:'BillMode',
                   id:'BillMode',
                   selectOnFocus: true,
                   anchor: '90%',
                   editable:true
               });
               //״̬
                var fpzt = new Ext.form.ComboBox({
                   xtype: 'combo',
                   store: [[1,"����"],[0,"����"]],
                   valueField: 'DicsCode',
                   displayField: 'DicsName',
                   mode: 'local',
                   forceSelection: true,
                   editable: false,
                   emptyValue: '',
                   triggerAction: 'all',
                   fieldLabel: '��Ʊ״̬',
                   name:'BillStatus',
                   id:'BillStatus',
                   selectOnFocus: true,
                   anchor: '90%',
                   editable:true
               });
                              
               //��˾������
               var gs = new Ext.form.ComboBox({
                    xtype:'combo',
                    fieldLabel:'��˾��ʶ',
                    anchor:'90%',
                    name:'OrgId',
                    id:'OrgId',
                    store: dsOrg,
                    displayField: 'OrgName',  //����ֶκ�ҵ��ʵ�����ֶ�ͬ��
                    valueField: 'OrgId',      //����ֶκ�ҵ��ʵ�����ֶ�ͬ��
                    typeAhead: true, //�Զ�����һ����������ѡ�ȫ����
                    triggerAction: 'all',
                    emptyValue: '',
                    selectOnFocus: true,
                    forceSelection: true,
                    mode:'local',        //��������趨�ӱ�ҳ��ȡ����Դ�����ܹ���ֵ��λ
                    editable:false
               })
                              
               var serchform = new Ext.FormPanel({
                    renderTo: 'divSearchForm',
                    labelAlign: 'left',
                    buttonAlign: 'right',
                    bodyStyle: 'padding:5px',
                    frame: true,
                    labelWidth: 55,
	                items:[
	                {
		                layout:'column',
		                border: false,
		                labelSeparator: '��',
		                items: [
		                {
			                layout:'form',
			                border: false,
			                columnWidth:0.3,
			                items: [gs]
		                }
                ,		{
			                layout:'form',
			                border: false,
			                columnWidth:0.3,
			                items: [
				                {
					                xtype:'textfield',
					                fieldLabel:'�ͻ�',
					                columnWidth:0.33,
					                anchor:'90%',
					                name:'CustomerId',
					                id:'CustomerId'
				                }
		                            ]
		                }
                ,		{
			                layout:'form',
			                border: false,
			                columnWidth:0.2,
			                items: [kpfs]
		                }
                ,		{
			                layout:'form',
			                border: false,
			                columnWidth:0.2,
			                items: [fpzt]
		                }
	                ]},	                
	                {
		                layout:'column',
		                border: false,
		                labelSeparator: '��',
		                items: [
		                {
			                layout:'form',
			                border: false,
			                columnWidth:0.3,
			                items: [
				                {
					                xtype:'datefield',
					                fieldLabel:'��ʼ����',
					                columnWidth:0.5,
					                anchor:'90%',
					                name:'StartDate',
					                id:'StartDate',
					                value:new Date().getFirstDateOfMonth().clearTime(),
					                format:'Y��m��d��'
				                }
		                            ]
		                }
                ,		{
			                layout:'form',
			                border: false,
			                columnWidth:0.3,
			                items: [
				                {
					                xtype:'datefield',
					                fieldLabel:'��������',
					                columnWidth:0.5,
					                anchor:'90%',
					                name:'EndDate',
					                id:'EndDate',
					                value:new Date(),
					                format:'Y��m��d��'
				                }
		                            ]
		                } 
                ,		{
			                layout:'form',
			                border: false,
			                columnWidth:0.2,
			                items: [
				                {
					                xtype:'textfield',
					                fieldLabel:'��Ʊ����',
					                columnWidth:0.33,
					                anchor:'90%',
					                name:'SBillNo',
					                id:'SBillNo'
				                }
		                            ]
		                }
		          ,		{
			                layout:'form',
			                border: false,
			                columnWidth:0.15,
			                 items: [{
				                    cls: 'key',
                                    xtype: 'button',
                                    text: '��ѯ',
                                    buttonAlign:'right',
                                    id: 'searchebtnId',
                                    anchor: '25%',
                                    handler: function() {QueryDataGrid();}
				                }]
			                
		                }
		         
	                ]}                  
                ]});


                        /*------��ʼ��ȡ���ݵĺ��� start---------------*/
                        var OrderMstGridData = new Ext.data.Store
                        ({
                            url: 'frmBillManage.aspx?method=getBillList',
                            reader: new Ext.data.JsonReader({
                                totalProperty: 'totalProperty',
                                root: 'root'
                            }, [
                                {  name:'BillId' },
                                {  name:'OrgId' },
                                { name:'CustomerId' },
                                { name:'CustomerNo' },
                                { name:'CustomerName' },
                                { name:'BillMode' },
                                { name:'AccountType' },
                                { name:'BillCode' },
                                { name:'BillNo' },
                                { name:'CreateId' },
                                { name:'PayId' },
                                { name:'CheckId' },
                                { name:'TransStatus' },
                                { name:'OperId' },
                                { name:'CreateDate' },
                                { name:'UpdateDate' },
                                { name:'OwnerId' },
                                { name:'Remark' },
                                { name:'IsActive' },
                                { name:'BillAmt' },
                                { name:'BillTax' }
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
                        var defaultPageSize = 10;
                            var toolBar = new Ext.PagingToolbar({
                                pageSize: 10,
                                store: OrderMstGridData,
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
                            singleSelect: false
                        });
                        var OrderMstGrid = new Ext.grid.GridPanel({
                            el: 'divDataGrid',
                            //width: '100%',
                            //height: '100%',
                            //autoWidth: true,
                            //autoHeight: true,
                            autoScroll: true,
                            layout: 'fit',
                            title: '��Ʊ��Ϣ',
                            store: OrderMstGridData,
                            loadMask: { msg: '���ڼ������ݣ����Ժ��' },
                            sm: sm,
                            cm: new Ext.grid.ColumnModel([
                            
		                    sm,
		                    new Ext.grid.RowNumberer(),//�Զ��к�
		                    {
			                    header:'��ʶ',
			                    dataIndex:'BillId',
			                    id:'BillId',
			                    width:80
		                    },
		                    {
			                    header:'��Ʊ����',
			                    dataIndex:'BillNo',
			                    id:'BillNo',
			                    width:100
		                    },
		                    {
		                        header:'�ͻ���ʶ',
			                    dataIndex:'CustomerId',
			                    id:'CustomerId',
			                    hidden:true,
			                    hideable:true
		                    },
		                    {
		                        header:'�ͻ����',
			                    dataIndex:'CustomerNo',
			                    id:'CustomerNo',
			                    width:80
		                    },
		                    {
		                        header:'�ͻ�����',
			                    dataIndex:'CustomerName',
			                    id:'CustomerName',
			                    width:160
		                    },
		                    {
			                    header:'��Ʊ����',
			                    dataIndex:'BillMode',
			                    id:'BillMode',
			                    width:70,
		                        renderer:{
		                            fn:function(val, params, record) {
	                                if (dsPayType.getCount() == 0) {
	                                    dsPayType.load();
	                                }
	                                dsPayType.each(function(r) {
	                                    if (val == r.data['DicsCode']) {
	                                        val = r.data['DicsName'];
	                                        return;
	                                    }
	                                });
	                                return val;
	                              }
		                        }
		                    },
		                    {
		                        header:'�տʽ',
			                    dataIndex:'AccountType',
			                    id:'AccountType',
			                    width:60,
		                        renderer:{
		                            fn:function(val, params, record) {
	                                if (dsAcctType.getCount() == 0) {
	                                    dsAcctType.load();
	                                }
	                                dsAcctType.each(function(r) {
	                                    if (val == r.data['DicsCode']) {
	                                        val = r.data['DicsName'];
	                                        return;
	                                    }
	                                });
	                                return val;
	                              }
		                        }
		                    },
		                    {
		                        header:'����״̬',
			                    dataIndex:'TransStatus',
			                    id:'TransStatus',
			                    width:60,
			                    renderer:{
			                        fn:function(v){
			                            if(v=='1') return '����';
			                            if(v=='2') return '�����ѷ�';
			                            if(v=='3') return '��������';
			                        }
			                    }
		                    },
		                    {
		                        header:'״̬',
			                    dataIndex:'IsActive',
			                    id:'IsActive',
			                    width:60,
			                    renderer:{
			                        fn:function(v){
			                            if(v=='1') return '��Ч';
			                            if(v=='0') return '����';
			                        }
			                    }
		                    },
		                    {
		                        header:'����Ա',
			                    dataIndex:'OperId',
			                    id:'OperId',
			                    width:60,
		                        renderer:{
		                            fn:function(val, params, record) {
	                                if (dsUser.getCount() == 0) {
	                                    dsUser.load();
	                                }
	                                dsUser.each(function(r) {
	                                    if (val == r.data['EmpId']) {
	                                        val = r.data['EmpName'];
	                                        return;
	                                    }
	                                });
	                                return val;
	                              }
		                        }
		                    },
		                    {
			                    header:'����ʱ��',
			                    dataIndex:'CreateDate',
			                    id:'CreateDate',
			                    renderer: Ext.util.Format.dateRenderer('Y��m��d��'),
			                    width:90
		                    },
		                    {
		                        header:'���',
			                    dataIndex:'BillAmt',
			                    id:'BillAmt',
			                    width:80
		                    },
		                    {
		                        header:'˰��',
			                    dataIndex:'BillTax',
			                    id:'BillTax',
			                    width:80
		                    },
		                    {
		                        header:'��ע',
			                    dataIndex:'Remark',
			                    id:'Remark',
			                    width:150
		                    }		]),
                            bbar: toolBar,
                            viewConfig: {
                                columnsText: '��ʾ����',
                                scrollOffset: 20,
                                sortAscText: '����',
                                sortDescText: '����',
                                forceFit: false
                            },
                            height: 280
//                            closeAction: 'hide',
//                            stripeRows: true,
//                            loadMask: true,
//                            autoExpandColumn: 2
                        });
                        
                        OrderMstGrid.on("afterrender", function(component) {
                            component.getBottomToolbar().refresh.hideParent = true;
                            component.getBottomToolbar().refresh.hide(); 
                        });
                        
                        OrderMstGrid.render();
                        OrderMstGridData.on('beforeload', function(store){
                            billDtInfoStore.removeAll();
                        });
                        OrderMstGrid.on('rowdblclick', function(grid, rowIndex, e) {
                            //������Ʒ��ϸ
                            var _record = OrderMstGrid.getStore().getAt(rowIndex).data.BillId;
                            if (!_record) {
                                Ext.example.msg('����', '��ѡ��Ҫ�鿴�ļ�¼��');
                            } else {
                                billDtInfoStore.baseParams.BillId = _record;
                                billDtInfoStore.load({
                                    params: {
                                        limit: 100,
                                        start: 0
                                    }
                                });
                            }

                        });
                        /*------DataGrid�ĺ������� End---------------*/
                        /****************************************************************/                        
                        var billDtInfoStore = new Ext.data.Store
                            ({
                                url: 'frmBillManage.aspx?method=getBillDtlInfo',
                                reader: new Ext.data.JsonReader({
                                    totalProperty: 'totalProperty',
                                    root: 'root'
                                }, [
	                            { name: 'BillDtlId' },
	                            { name: 'BillId' },
	                            { name: 'ProductId' },
	                            { name: 'ProductNo' },
	                            { name: 'ProductName' },
	                            { name: 'Specifications' },
	                            { name: 'SpecName'},
	                            { name: 'Unit' },
	                            { name: 'UnitName' },
	                            { name: 'Qty' },
	                            { name: 'Price' },
	                            { name: 'Rate' },
	                            { name: 'Amt' },
	                            { name: 'Tax' },
	                            { name: 'Discount' }
	                            ])
                            });

                        var smDtl = new Ext.grid.CheckboxSelectionModel({
                            singleSelect: true
                        });
                        var billDtInfoGrid = new Ext.grid.GridPanel({
                            width: '100%',
                            height: '100%',
                            //autoWidth: true,
                            autoHeight: true,
                            autoScroll: true,
                            layout: 'fit',
                            el: 'divDataDtlGrid',
                            title: '��Ʊ��ϸ��Ϣ',
                            store: billDtInfoStore,
                            loadMask: { msg: '���ڼ������ݣ����Ժ��' },
                            sm: smDtl,
                            cm: new Ext.grid.ColumnModel([
		                            smDtl,
		                            new Ext.grid.RowNumberer(), //�Զ��к�
		                            {
		                            header: '������',
		                            dataIndex: 'ProductNo',
		                            id: 'ProductNo'
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
		                                header: '��������',
		                                dataIndex: 'Qty',
		                                id: 'Qty'
		                            },
		                            {
		                                header: '���۵���',
		                                dataIndex: 'Price',
		                                id: 'Price'
		                            },
		                            {
		                                header: '���۽��',
		                                dataIndex: 'Amt',
		                                id: 'Amt'
		                            },
		                            {
		                                header: '�ۿ�',
		                                dataIndex: 'Discount',
		                                id: 'Discount'
		                            },
		                            {
		                                header: '˰��',
		                                dataIndex: 'Rate',
		                                id: 'Rate'
		                            },
		                            {
		                                header: '˰��',
		                                dataIndex: 'Tax',
		                                id: 'Tax'
		                            }
		                        ]),
                            bbar: new Ext.PagingToolbar({
                                pageSize: 10,
                                store: billDtInfoStore,
                                displayMsg: '��ʾ��{0}����{1}����¼,��{2}��',
                                emptyMsy: 'û�м�¼',
                                displayInfo: true
                            }),
                            viewConfig: {
                                columnsText: '��ʾ����',
                                scrollOffset: 20,
                                sortAscText: '����',
                                sortDescText: '����',
                                forceFit: false
                            },
                            height: 150,
                            closeAction: 'hide',
                            stripeRows: true,
                            loadMask: true//,
                            //autoExpandColumn: 2
                        });
                        billDtInfoGrid.render();
                        /****************************************************************/
                         
        
                       gs.setValue(<% =ZJSIG.UIProcess.ADM.UIAdmUser.OrgID(this)%>);
                       gs.setDisabled(true);
//------------------------------------------
function exportData(){
    
    Ext.MessageBox.wait("�������ڴ������Ժ򡭡�");
    var sm = OrderMstGrid.getSelectionModel();
	//��ȡѡ���������Ϣ
	var selectData =  sm.getSelections();
	//���û��ѡ�񣬾���ʾ��Ҫѡ��������Ϣ
	if(selectData == null || selectData == "") {
	    Ext.MessageBox.hide();
		Ext.Msg.alert("��ʾ","��ѡ����Ҫ�����ļ�¼��");
		return;
    }
    
    var json = "";
    for(var i=0;i<selectData.length;i++)
    {
        json += selectData[i].data.BillId + ',';
    }    
    json = json.substring(0,json.length-1);
    //alert(json);   
    
    //check
    Ext.Ajax.request({   
        url: 'frmBillManage.aspx?method=checkBillData',
        method: 'POST',           
        params: {
            BillId: json//��������id��
        },
        success: function(resp, opts) {
            Ext.MessageBox.hide();
            var resu = Ext.decode(resp.responseText); 
            if (resu.success==true) {
                //Ext.Msg.wait("������....","��ʾ");
                if (!Ext.fly('test'))   
                {   
                    var frm = document.createElement('form');   
                    frm.id = 'test';   
                    frm.name = 'test';   
                    //frm.style.display = 'none';   
                    frm.className = 'x-hidden'; 
                    document.body.appendChild(frm);   
                }  
                 
                Ext.Ajax.request({   
                    url: 'frmBillManage.aspx?method=exportData', 
                    form: Ext.fly('test'),   
                    method: 'POST',     
                    isUpload: true,          
                    params: {
                        BillId: json//��������id��
                    },
                    success: function(resp, opts) {
                        //Ext.Msg.hide();
                    },
                    failure: function(resp, opts) {
                         //Ext.Msg.hide();
                    }
                });                  
            }else{
                Ext.Msg.alert('��ʾ��Ϣ',resu.errorinfo);
            }

        }, 
        failure: function(resp, opts) {
             Ext.MessageBox.hide();
         }
    });  
}

    if (typeof (fileWindow) == "undefined"){
        fileWindow = new Ext.Window({
            id: 'upl',
            title: "�ļ�ѡ���"
	        , iconCls: 'upload-win'
	        , width: 400
	        , height: 200
	        , plain: true
	        , modal: true
	        , constrain: true
	        , resizable: false
	        , closeAction: 'hide'
	        , autoScroll:true
	        , autoDestroy: true
	        , html: '<iframe id="uploadIFrame" width="100%" height="80%" border=0 src=""></iframe>' 	        	        
        });
        fileWindow.addListener("hide", function() {
        });
    }
   
function importData(){  
    fileWindow.show();
    if(document.getElementById("uploadIFrame").src.indexOf("frmUpLoadFile")==-1)
    {               
        document.getElementById("uploadIFrame").src = "/Common/frmUpLoadFile.aspx?docType=bill" ;
    } 
}
function discardData()
{
    Ext.MessageBox.wait("�������ڴ������Ժ򡭡�");
    var sm = OrderMstGrid.getSelectionModel();
	//��ȡѡ���������Ϣ
	var selectData =  sm.getSelections();
	//���û��ѡ�񣬾���ʾ��Ҫѡ��������Ϣ
	if(selectData == null || selectData == "") {
	    Ext.MessageBox.hide();
		Ext.Msg.alert("��ʾ","��ѡ����Ҫ���ϵļ�¼��");
		return;
    }
    
    var json = "";
    for(var i=0;i<selectData.length;i++)
    {
        json = selectData[i].data.BillId + ',';
    }    
    json = json.substring(0,json.length-1);
    //alert(json);   
    
    //check
    Ext.Ajax.request({   
        url: 'frmBillManage.aspx?method=discardBillData',
        method: 'POST',           
        params: {
            BillId: json//��������id��
        },
        success: function(resp, opts) {
            Ext.MessageBox.hide();
            if( checkExtMessage(resp) )
            {
                QueryDataGrid();
            }
        }, 
        failure: function(resp, opts) {
             Ext.MessageBox.hide();
         }
    });  
}
function rollData(){
    var sm = OrderMstGrid.getSelectionModel();
    //��ȡѡ���������Ϣ
    var selectData =  sm.getSelections();
    //���û��ѡ�񣬾���ʾ��Ҫѡ��������Ϣ
    if(selectData == null || selectData == "") {
        Ext.MessageBox.hide();
        Ext.Msg.alert("��ʾ","��ѡ����Ҫ���ķ�Ʊ��¼��");
        return;
    }
    if (selectData.length != 1) {
        Ext.Msg.alert("��ʾ", "��ѡ��һ����Ҫ���ķ�Ʊ��¼��");
        return;
    }
    Ext.Msg.confirm("��ʾ��Ϣ", "�Ƿ����Ҫ��ѡ��ķ�Ʊ��¼ȫ����죿", function callBack(id) {
        //�ж��Ƿ�ɾ������
        if (id == "yes") {                                  
            ExtJsCustom(selectData[0].data.BillId,selectData[0].data.BillMode);                  
        }
    });    
}
function ExtJsCustom(billId,billMode){  
var config ={  
    title:"��Ʊ���",  
    msg:"�����뷢Ʊ֪ͨ����",  
    width:400,  
    multiline:true,  
    closable:true,  
    buttons:Ext.MessageBox.OKCANCEL,  
    icon:Ext.MessageBox.QUESTION,  
    fn:  function(btn,text){  
        if(btn=='yes'){
            //check
            if(billMode=='S032'){
                if(strLen(text)!=16){
                    Ext.Msg.alert("��ʾ", "������ֵ˰ר�÷�Ʊ֪ͨ�����������飡");
                    return;  
                }
            }
            Ext.MessageBox.wait("�������ڴ������Ժ򡭡�");
            Ext.Ajax.request({   
                url: 'frmBillManage.aspx?method=rollBillData',
                method: 'POST',           
                params: {
                    BillId: billId,//��������id��
                    NoticeNo:text
                },
                success: function(resp, opts) {
                    Ext.MessageBox.hide();
                    if( checkExtMessage(resp) )
                    {
                        QueryDataGrid();
                    }
                }, 
                failure: function(resp, opts) {
                     Ext.MessageBox.hide();
                 }
            });
        }
        //Ext.MessageBox.alert("Result","������'"+btn+"'��ť<br>,�����ֵ�ǣ�"+txt); 
    }
    };  
 Ext.MessageBox.show(config);  
}
//------------------------------------------
var winbillEdit = null;
var adjustInfoFrom  = new Ext.FormPanel({
    labelAlign: 'left',
    buttonAlign: 'right',
    bodyStyle: 'padding:5px',
    //width:700,
    //height:450,
    frame: true,
    labelWidth: 70,
    autoDestroy: true,
    items:
    [{
        layout: 'column',   //�����Ԫ��Ϊ����Ϊ�в��ַ�ʽ
        border: false,
        items:
        [{//��һ�п�ʼ
            columnWidth: 1,  //����ռ�õĿ�ȣ���ʶΪ50��
            layout: 'form',
            border: false,
            items: 
            [{
                cls: 'key',
                xtype: 'textfield',
                fieldLabel: 'billid',
                name: 'billid',
                id: 'billid',
                anchor: '90%',
                vtype: 'alphanum', //ֻ��������ĸ�����֣��޷���������
                vtypeText: 'ֻ��������ĸ������',
                hidden: true,
                hideLabel: true
            },
            {
                cls: 'key',
                xtype: 'textfield',
                fieldLabel: '<b>�ͻ�����*</b>',
                name: 'CustomerName',
                id: 'CustomerName',
                anchor: '98%'
            }]
        }]
    },
    {
        layout: 'column',   //�����Ԫ��Ϊ����Ϊ�в��ַ�ʽ
        border: false,
        items:
        [{
            columnWidth: .5,  //����ռ�õĿ�ȣ���ʶΪ50��
            layout: 'form',
            border: false,
            items: [{
                cls: 'key',
                xtype: 'combo',
                store: dsPayType,
                valueField: 'DicsCode',
                displayField: 'DicsName',
                mode: 'local',
                emptyValue: '',
                triggerAction: 'all',
                fieldLabel: '<b>��Ʊ����*</b>',
                name: 'BillType',
                id: 'BillType',
                selectOnFocus: true,
                anchor: '98%',
                editable: false
            }]
        },{
            columnWidth: .5,  //����ռ�õĿ�ȣ���ʶΪ50��
            layout: 'form',
            border: false,
            items: [{//�ڶ��е�һ��
                cls: 'key',
                xtype: 'combo',
                store: dsAcctType,
                valueField: 'DicsCode',
                displayField: 'DicsName',
                mode: 'local',
                emptyValue: '',
                triggerAction: 'all',
                fieldLabel: '<b>�տʽ*</b>',
                name: 'AcctType',
                id: 'AcctType',
                selectOnFocus: true,
                anchor: '98%',
                editable: false
			                            
            }]
        }]
    },
    {//�����п�ʼ
        layout: 'column',   //�����Ԫ��Ϊ����Ϊ�в��ַ�ʽ
        border: false,
        items: [{//�����е�һ��
            columnWidth: .5,  //����ռ�õĿ�ȣ���ʶΪ50��
            layout: 'form',
            border: false,
            items: [{

                cls: 'key',
                xtype: 'textfield',
                fieldLabel: '<b>��Ʊ����*</b>',
                name: 'BillCode',
                id: 'BillCode',
                anchor: '98%'

            }]
        },
        {//�����еڶ���
            columnWidth: .5,  //����ռ�õĿ�ȣ���ʶΪ50��
            layout: 'form',
            border: false,
            items: [{

                cls: 'key',
                xtype: 'textfield',
                fieldLabel: '<b>��Ʊ����*</b>',
                name: 'BillNo',
                id: 'BillNo',
                anchor: '98%'

            }]
        }]
    },
    {//�ڶ��п�ʼ
        layout: 'column',   //�����Ԫ��Ϊ����Ϊ�в��ַ�ʽ
        border: false,
        items: [
        {//�ڶ��еڶ���
            columnWidth: 1,  //����ռ�õĿ�ȣ���ʶΪ50��
            layout: 'form',
            border: false,
            items: [{
                cls: 'key',
                xtype: 'textfield',
                fieldLabel: '<b>��ע</b>',
                name: 'remark',
                id: 'remark',
                anchor: '98%'
            }]
        }]
    }]
});
function editData()
{
    var sm = OrderMstGrid.getSelectionModel();
	//��ȡѡ���������Ϣ
	var selectData =  sm.getSelections();
	//���û��ѡ�񣬾���ʾ��Ҫѡ��������Ϣ
	if(selectData == null || selectData == "") {
		Ext.Msg.alert("��ʾ","��ѡ����Ҫ�����ļ�¼��");
		return;
    }else if(selectData.length !=1){
        Ext.Msg.alert("��ʾ","��ѡ��һ����Ҫ�����ļ�¼��");
		return;
    }
    //��
    if(winbillEdit == null){
        winbillEdit = new Ext.Window({
            title: "��Ϣ����"
            , iconCls: 'upload-win'
            , width: 450
            , height: 220
            , layout: 'fit'
            , plain: true
            , modal: true
            , constrain: true
            , resizable: false
            , closeAction: 'hide'
            , autoDestroy: true
            , items: [
                adjustInfoFrom
             ]
             , buttons: [{
                 text: "����"
                , handler: function() {
                    Ext.MessageBox.wait("�������ڴ������Ժ򡭡�");
                    Ext.Ajax.request({
                    url: 'frmBillManage.aspx?method=updateInfo',
                    method: 'POST',
                    params: {
                        BillId: Ext.getCmp('billid').getValue(),
                        CustomerName: Ext.getCmp('CustomerName').getValue(),
                        BillMode: Ext.getCmp('BillType').getValue(),
                        AccountType: Ext.getCmp('AcctType').getValue(),
                        BillCode: Ext.getCmp('BillCode').getValue(),
                        BillNo: Ext.getCmp('BillNo').getValue(),
                        Remark: Ext.getCmp('remark').getValue()
                    },
                    success: function(resp, opts) {
                        Ext.MessageBox.hide();
                        if( checkExtMessage(resp) )
                        {               
                            OrderMstGridData.reload();
                            winbillEdit.hide();
                        } 
                    },
                    failure: function(resp, opts) {
                        Ext.MessageBox.hide(); 
                        Ext.Msg.alert("��ʾ", "����ʧ��");
                    }
                });

                }
                    , scope: this
             },
            {
                text: "ȡ��"
                , handler: function() {
                    winbillEdit.hide();
                    adjustInfoFrom.getForm().reset();
                    OrderMstGridData.reload();
                }
                , scope: this
            }]
        });
    }
    //��ȡ����
    winbillEdit.show();// = selectData[0].data.BillId
    Ext.getCmp('billid').setValue(selectData[0].data.BillId);
    Ext.getCmp('CustomerName').setValue(selectData[0].data.CustomerName);
    Ext.getCmp('BillType').setValue(selectData[0].data.BillMode);
    Ext.getCmp('AcctType').setValue(selectData[0].data.AccountType);
    Ext.getCmp('BillCode').setValue(selectData[0].data.BillCode);
    Ext.getCmp('BillNo').setValue(selectData[0].data.BillNo);
    Ext.getCmp('remark').setValue(selectData[0].data.Remark);
}
//------------------------------------------
})
</script>

</html>
