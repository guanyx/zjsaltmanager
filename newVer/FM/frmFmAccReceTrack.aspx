<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmFmAccReceTrack.aspx.cs" Inherits="FM_frmFmAccRece" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html>
<head>
<title>Ӧ���ʿ����</title><meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<link rel="stylesheet" type="text/css" href="../ext3/resources/css/ext-all.css" />
<script type="text/javascript" src="../ext3/adapter/ext/ext-base.js"></script>
<script type="text/javascript" src="../ext3/ext-all.js"></script>
<script type="text/javascript" src="../js/operateResp.js"></script>
<style type="text/css">
.x-grid-back-blue { 
background: #B7CBE8; 
}
</style>

</head>
<body>
<div id='toolbar'></div>
<div id='divSearchForm'></div>
<div id='divDataGrid'></div>
</body>
<%=getComboBoxStore()%>
<script type="text/javascript">
Ext.BLANK_IMAGE_URL = "../ext3/resources/images/default/s.gif"; 
    Ext.onReady(function() {
    
        /*------ʵ��toolbar�ĺ��� start---------------*/
       var Toolbar = new Ext.Toolbar({
            renderTo: "toolbar",
            items: [{
                text: "�տ���ϸ��¼",
                icon: "../Theme/1/images/extjs/customer/view16.gif",
                handler: function() { popAddWin(); }
            },
            {
                text: "�����ͻ�������¼",
                icon: "../Theme/1/images/extjs/customer/add16.gif",
                handler: function() { popAddEchoWin(); }
            }]
        });
            /*------����toolbar�ĺ��� end---------------*/
          
          //�ͻ��б�ѡ��
            function QueryDataGrid() {      
                MstGridData.baseParams.CustomerId = Ext.getCmp('CustomerNo').getValue();                
                MstGridData.baseParams.ShortName = Ext.getCmp('CustomerName').getValue(); 
                MstGridData.baseParams.ChineseName = Ext.getCmp('CustomerName').getValue(); 
                MstGridData.baseParams.DistributionType = "";
                
                MstGridData.load({
                    params: {
                        start: 0,
                        limit: 10        
                    }
                });
            }
           
            //������������
             function popAddWin() {
                var sm = MstGrid.getSelectionModel();
	            var selectData =  sm.getSelected();
	            if(selectData == null || selectData == ""){
		            Ext.Msg.alert("��ʾ","��ѡ��¼���տ��¼�Ŀͻ���");
		            return;
	            }
	            openAddWin.show();
	            ModDtlGridData.baseParams.CustomerId=selectData.data.CustomerId;
	            ModDtlGridData.load({
                    params: {
                        start: 0,
                        limit: 10
                    }
                });
                
                Ext.getCmp("ModCustomerNo").setValue(selectData.data.CustomerNo);
                Ext.getCmp("ModCustomerName").setValue(selectData.data.ShortName);                
                //Ext.getCmp("FundType").setValue("F051");
                //Ext.getCmp("BusinessType").setValue("F061");
                //Ext.getCmp("PayType").setValue("F011");
	            
            }
            
            //
            function popAddEchoWin(){
                var sm = MstGrid.getSelectionModel();
	            var selectData =  sm.getSelected();
	            if(selectData == null || selectData == ""){
		            Ext.Msg.alert("��ʾ","��ѡ����Ӧ�ͻ���");
		            return;
	            }
	            uploadReminderWindow.show();
                document.getElementById("editIFrame").src = "frmFmCustomerReminder.aspx?CustomerId=" + selectData.data.CustomerId;
            }
            /*------��ʼ�������ݵĴ��� Start---------------*/
            if (typeof (uploadReminderWindow) == "undefined") {//�������2��windows����
                uploadReminderWindow = new Ext.Window({
                    id: 'Reminderformwindow',
                    iconCls: 'upload-win'
                    , width: 600
                    , height: 400
                    , layout: 'fit'
                    , plain: true
                    , modal: true
                    , constrain: true
                    , resizable: false
                    , closeAction: 'hide'
                    , autoDestroy: true
                    , html: '<iframe id="editIFrame" width="100%" height="100%" border=0 src=""></iframe>'

                });
            }
            
            //��������
            function saveAdd(){
               //��ȡ������Ϣ
               var sm = MstGrid.getSelectionModel();
	           var selectData =  sm.getSelected();
	           
	           Ext.Ajax.request({
		            url:'frmFmAccRece.aspx?method=saveAdd',
		            method:'POST',
		            params:{
                        BusinessType:Ext.getCmp('BusinessType').getValue(),
                        FundType:Ext.getCmp('FundType').getValue(),
                        PayType:Ext.getCmp('PayType').getValue(),
                        Amount:Ext.getCmp('Amount').getValue(),
                        CustomerId:selectData.data.CustomerId,
                        CustomerNo:selectData.data.CustomerNo,
                        CustomerName:selectData.data.ShortName                        
                       },
	                   success: function(resp,opts){ checkExtMessage(resp);   },
		               failure: function(resp,opts){  Ext.Msg.alert("��ʾ","����ʧ��");     }	
		            });
		      }
            
            //////////////////////////////Start �б����/////////////////////////////////////////////////////////////////
               var serchform = new Ext.FormPanel({
                    renderTo: 'divSearchForm',
                    labelAlign: 'left',
//                    layout: 'fit',
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
			                columnWidth:0.33,
			                items: [
				                {
					                xtype:'textfield',
					                fieldLabel:'�ͻ����',
					                columnWidth:0.33,
					                anchor:'90%',
					                name:'CustomerNo',
					                id:'CustomerNo'
				                }
		                            ]
		                }		                
                ,		{
			                layout:'form',
			                border: false,
			                columnWidth:0.33,
			                items: [
				                {
					                xtype:'textfield',
					                fieldLabel:'�ͻ�����',
					                columnWidth:0.33,
					                anchor:'90%',
					                name:'CustomerName',
					                id:'CustomerName'
				                }
		                ]
		                }
                ,		{
			                layout:'form',
			                border: false,
			                columnWidth:0.34,
			                items: [
				                {
					                cls: 'key',
                                    xtype: 'button',
                                    text: '��ѯ',
                                    buttonAlign:'right',
                                    id: 'searchebtnId',
                                    anchor: '25%',
                                    handler: function() {QueryDataGrid();}
				                }
		                ]
		                }
	                ]}           
                ]});


                        /*------��ʼ��ȡ���ݵĺ��� start---------------*/
                        var MstGridData = new Ext.data.Store
                        ({
                            url: 'frmFmAccRece.aspx?method=getCustomerList',
                            reader: new Ext.data.JsonReader({
                                totalProperty: 'totalProperty',
                                root: 'root'
                            }, [
                                { name: "CustomerId" },
			                    { name: "CustomerNo" },
			                    { name: "ShortName" },
			                    { name: "LinkMan" },
			                    { name: "LinkTel" },
			                    { name: "LinkMobile" },
			                    { name: "Fax" },
			                    { name: "DistributionTypeText" },
			                    { name: "MonthQuantity" },
			                    { name: "IsCust" },
			                    { name: "IsProvide" },
			                    { name: 'CreateDate'}
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
                        var MstGrid = new Ext.grid.GridPanel({
                            el: 'divDataGrid',
                            width: '100%',
                            height: '100%',
                            autoWidth: true,
                            autoHeight: true,
                            autoScroll: true,
                            layout: 'fit',
                            id: '',
                            store: MstGridData,
                            loadMask: { msg: '���ڼ������ݣ����Ժ��' },
                            sm: sm,
                            cm: new Ext.grid.ColumnModel([
                            
		                    sm,
		                    new Ext.grid.RowNumberer(),//�Զ��к�
		                      { header: "�ͻ�ID",dataIndex: 'CustomerId' ,hidden:true,hideable:false},
			                  { header: "�ͻ����", width: 60, sortable: true, dataIndex: 'CustomerNo' },
			                  { header: "�ͻ�����", width: 60, sortable: true, dataIndex: 'ShortName' },
			                  { header: "��ϵ��", width: 30, sortable: true, dataIndex: 'LinkMan' },
			                  { header: "��ϵ�绰", width: 30, sortable: true, dataIndex: 'LinkTel' },
			                  { header: "�ƶ��绰", width: 30, sortable: true, dataIndex: 'LinkMobile' ,hidden:true,hideable:false},
			                  { header: "����", width: 30, sortable: true, dataIndex: 'Fax' ,hidden:true,hideable:false},
			                  { header: "��������", width: 25, sortable: true, dataIndex: 'DistributionTypeText' },
			                  { header: "������", width: 20, sortable: true, dataIndex: 'MonthQuantity' },
			                  { header: "����", width: 60, sortable: true, dataIndex: 'IsCust',renderer:{fn:function(v){if(v==1)return '��';return '��';}} },
			                  { header: "��Ӧ��", width: 60, sortable: true, dataIndex: 'IsProvide',renderer:{fn:function(v){if(v==1)return '��';return '��';}} },
			                  { header: "����ʱ��", width: 60, sortable: true, dataIndex: 'CreateDate',renderer: Ext.util.Format.dateRenderer('Y��m��d��') }//renderer: Ext.util.Format.dateRenderer('m/d/Y'),
		                    
		                    ]),
                            bbar: new Ext.PagingToolbar({
                                pageSize: 10,
                                store: MstGridData,
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
                        MstGrid.render();
                        /*------DataGrid�ĺ������� End---------------*/
        //////////////////////////////////End �б����/////////////////////////////////////////////////////////////
        
        
        
        ////////////////////////Start �޸Ľ���///////////////////////////////////////////////////////////////////////        
                 var modDtlForm = new Ext.FormPanel({
                            labelAlign: 'left',
                            buttonAlign: 'right',
                            bodyStyle: 'padding:5px',
                            frame: true,
                            labelWidth: 55, 
                            height:40,
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
		                            items: [
			                            {
				                            xtype:'textfield',
				                            fieldLabel:'�ͻ�����',
				                            columnWidth:0.3,
				                            anchor:'90%',
				                            name:'ModCustomerNo',
				                            id:'ModCustomerNo',
				                            readOnly:true
			                            }
	                                        ]
	                            }		                
                        ,		{
		                            layout:'form',
		                            border: false,
		                            columnWidth:0.7,
		                            items: [
			                            {
				                            xtype:'textfield',
				                            fieldLabel:'�ͻ�����',
				                            columnWidth:0.7,
				                            anchor:'90%',
				                            name:'ModCustomerName',
				                            id:'ModCustomerName',
				                            readOnly:true
			                            }
	                            ]
	                            }
                                        
                       
                            ]}                  
                        ]});
                        
                        
                        /*------��ʼ��ȡ���ݵĺ��� start---------------*/
                        var ModDtlGridData = new Ext.data.Store
                        ({
                            url: 'frmFmAccRece.aspx?method=getAccountReceDtl',
                            reader: new Ext.data.JsonReader({
                                totalProperty: 'totalProperty',
                                root: 'root'
                            }, [
                                {   name:'Ext3'     },
                                {   name:'Ext4'     },
                                {   name:'ReceivableId'     },
                                {   name:'CustomerId'     },
                                {   name:'CustomerNo'     },
                                {   name:'CustomerName'     },
                                {   name:'BusinessType'     },
                                {   name:'FundType'     },
                                {   name:'PayType'     },
                                {   name:'Amount'     },
                                {   name:'TotalAmount'     },
                                {   name:'CertificateStatus'     },
                                {   name:'OperId'     },
                                {   name:'OrgId'     },
                                {   name:'OwnerId'     },
                                {   name:'CreateDate'     },
                                {   name:'Ext1'     },
                                {   name:'Ext2'     },
                                {   name:'BusinessTypeText'     },
                                {   name:'FundTypeText'     },
                                {   name:'OperName'     },
                                {   name:'PayTypeText'     }
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
                        var ModOrderDtlGrid = new Ext.grid.EditorGridPanel({
                            autoScroll: true,
                            height:280, 
                            id: '',
                            store: ModDtlGridData,
                            loadMask: { msg: '���ڼ������ݣ����Ժ��' },
                            sm: sm,
                            cm: new Ext.grid.ColumnModel([                            
		                    sm,
		                    new Ext.grid.RowNumberer(),//�Զ��к�
		                    {
			                    header:'���',
			                    dataIndex:'ReceivableId',
			                    id:'ReceivableId'
		                    },
		                    {
		                        header:'ҵ������',
			                    dataIndex:'BusinessTypeText',
			                    id:'BusinessTypeText'
		                    },
		                    {
		                        header:'�������',
			                    dataIndex:'FundTypeText',
			                    id:'FundTypeText'
		                    },
		                    {
		                        header:'��������',
			                    dataIndex:'PayTypeText',
			                    id:'PayTypeText'
		                    },
		                    {
		                        header:'���',
			                    dataIndex:'Amount',
			                    id:'Amount',
			                    renderer:function(v){
			                        return Number(v).toFixed(2);
			                    }              
		                    },
		                    {
		                        header:'�ۼƽ��',
			                    dataIndex:'TotalAmount',
			                    id:'TotalAmount',
			                    renderer:function(v){
			                        return Number(v).toFixed(2);
			                    }         
		                    },
		                    {
		                        header:'����Ա',
			                    dataIndex:'OperName',
			                    id:'OperName'         
		                    },
		                    {
		                        header:'��������',
			                    dataIndex:'CreateDate',
			                    id:'CreateDate',
			                    renderer: Ext.util.Format.dateRenderer('Y��m��d��')    
		                    }
		                    
		                    ]),
                            bbar: new Ext.PagingToolbar({
                                pageSize: 15,
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
                        
             
            if(typeof(openAddWin)=="undefined"){//�������2��windows����
	            openAddWin = new Ext.Window({
		            id:'openModWin',
		            title:'Ӧ���ʿ�ά��'
		            , iconCls: 'upload-win'
		            , width: 750
		            , height: 400
		            , layout: 'form'
		            , plain: true
		            , modal: true
		            , constrain:true
		            , resizable: false
		            , closeAction: 'hide'
		            ,autoDestroy :true
		            ,items:[
		                
                         {       layout:'form',
                                border: false,
                                columnWidth:1,
                                items: [  modDtlForm ]
                         },
                         {       layout:'form',
                                border: false,
                                columnWidth:1,
                                items: [  ModOrderDtlGrid ]
                         }
		            
		            ]
		            ,buttons: [
		            {
			            text: "ȡ��"
			            , handler: function() { 
				            openAddWin.hide();
				            MstGridData.reload();
			            }
			            , scope: this
		            }]});
	            }
	            openAddWin.addListener("hide",function(){
            });
        
        
        
////////////////////////End �޸Ľ���///////////////////////////////////////////////////////////////////////



          
 })
</script>

</html>
