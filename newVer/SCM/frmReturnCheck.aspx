<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmReturnCheck.aspx.cs" Inherits="SCM_frmReturnCheck" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">


<html>
<head>
<title>�˻������</title><meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<link rel="stylesheet" type="text/css" href="../ext3/resources/css/ext-all.css" />
<script type="text/javascript" src="../ext3/adapter/ext/ext-base.js"></script>
<script type="text/javascript" src="../ext3/ext-all.js"></script>
<script type="text/javascript" src="../js/operateResp.js"></script>
<script type="text/javascript" src="../ext3/src/locale/ext-lang-zh_CN.js"></script>
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

<script type="text/javascript">
Ext.BLANK_IMAGE_URL = "../ext3/resources/images/default/s.gif"; 
    Ext.onReady(function() {
     
    
        /*------ʵ��toolbar�ĺ��� start---------------*/
       var Toolbar = new Ext.Toolbar({
            renderTo: "toolbar",
            items: [{
                text: "���",
                icon: "../Theme/1/images/extjs/customer/add16.gif",
                handler: function() { checkReturn(); }
                }]
            });
            /*------����toolbar�ĺ��� end---------------*/
          
          //�˻����б�ѡ��
            function QueryDataGrid() {   
                MstGridData.baseParams.CustomerId = Ext.getCmp('CustomerId').getValue();
                MstGridData.baseParams.StartDate = Ext.util.Format.date(Ext.getCmp('StartDate').getValue(),'Y/m/d');
                MstGridData.baseParams.EndDate = Ext.util.Format.date(Ext.getCmp('EndDate').getValue(),'Y/m/d');  
                   
                MstGridData.load({
                    params: {
                        start: 0,
                        limit: 10
//                        OrgId:Ext.getCmp('OrgId').getValue(),
                    }
                });
            }
           
           ////�˻������
            function checkReturn()
            {
                 var sm = MstGrid.getSelectionModel();
	             var selectData =  sm.getSelected();
                //���û��ѡ�񣬾���ʾ��Ҫѡ��������Ϣ
                if(selectData == null || selectData == ""){
	                Ext.Msg.alert("��ʾ","��ѡ����Ҫ��˵ļ�¼��");
	                return;
                }
                if (selectData.data.Status != 1)
	            {
	                Ext.Msg.alert("��ʾ","�ֿ��Ѵ��������������");
		            return;
	            }
                //ҳ���ύ
                Ext.Ajax.request({
	                url:'frmReturnCheck.aspx?method=checkReturn',
	                method:'POST',
	                params:{
		                ReturnId:selectData.data.ReturnId,
		                Status:0
	                },
	                success: function(resp,opts){
		                checkExtMessage(resp); 
		                MstGridData.reload();
	                },
	                failure: function(resp,opts){
		                Ext.Msg.alert("��ʾ","���ݲ���ʧ��");
	                }
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
			                columnWidth:0.25,
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
			                columnWidth:0.25,
			                items: [
				                {
					                xtype:'datefield',
					                fieldLabel:'��������',
					                columnWidth:0.5,
					                anchor:'90%',
					                name:'EndDate',
					                id:'EndDate',
					                value:new Date().clearTime(),
					                format:'Y��m��d��'
				                }
		                ]
		                }
                ,		{
			                layout:'form',
		                    border: false,
		                    columnWidth:0.1,
		                    items: [{
				                    cls: 'key',
                                    xtype: 'button',
                                    text: '��ѯ',
                                    buttonAlign:'right',
                                    id: 'searchebtnId',
                                    anchor: '90%',
                                    handler: function() {QueryDataGrid();}
				                }]
		                }
	                ]}                 
                ]});


                        /*------��ʼ��ȡ���ݵĺ��� start---------------*/
                        var MstGridData = new Ext.data.Store
                        ({
                            url: 'frmReturnCheck.aspx?method=getReturnList',
                            reader: new Ext.data.JsonReader({
                                totalProperty: 'totalProperty',
                                root: 'root'
                            }, [
                                {
		                            name:'ReturnId'
	                            },
	                            {
		                            name:'ReturnNumber'
	                            },
	                            {
		                            name:'OrgId'
	                            },
	                            {
		                            name:'OrgName'
	                            },
	                            {
		                            name:'InStor'
	                            },
	                            {
		                            name:'CustomerId'
	                            },
	                            {
		                            name:'ReturnReason'
	                            },
	                            {
		                            name:'TotalQty'
	                            },
	                            {
		                            name:'TotalAmt'
	                            },
	                            {
		                            name:'DtlCount'
	                            },
	                            {
		                            name:'Status'
	                            },
	                            {
		                            name:'InStorId'
	                            },
	                            {
		                            name:'OldOrderId'
	                            },
	                            {
		                            name:'OperId'
	                            },
	                            {
		                            name:'CreateDate'
	                            },
	                            {
		                            name:'UpdateDate'
	                            },
	                            {
		                            name:'OwnerId'
	                            },
	                            {
		                            name:'BizAudit'
	                            },
	                            {
		                            name:'AuditDate'
	                            },
	                            {
		                            name:'Remark'
	                            },
	                            {
		                            name:'IsActive'
	                            },
	                            {
		                            name:'StorName'
	                            },
	                            {
		                            name:'CustomerName'
	                            },
	                            {
		                            name:'CustomerCode'
	                            },
	                            {
		                            name:'Address'
	                            },
	                            {
		                            name:'StatusName'
	                            },
	                            {
		                            name:'OperName'
	                            },
	                            {
		                            name:'OwnerName'
	                            },
	                            {
		                            name:'IsActiveName'
	                            }	])
	                         
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
		                    {
			                    header:'��ʶ',
			                    dataIndex:'ReturnId',
			                    id:'ReturnId',
			                    hidden:true
		                    },
		                    {
			                    header:'���',
			                    dataIndex:'ReturnNumber',
			                    id:'ReturnNumber',
			                    width:80
		                    },
		                    {
		                        header:'��˾����',
			                    dataIndex:'OrgName',
			                    id:'OrgName',
			                    hidden:true
		                    },
		                    {
		                        header:'�ֿ�',
			                    dataIndex:'StorName',
			                    id:'StorName' ,
			                    width:60
		                    },
		                    {
		                        header:'�ͻ�����',
			                    dataIndex:'CustomerCode',
			                    id:'CustomerCode',
			                    width:60
		                    },
		                    {
		                        header:'�ͻ�����',
			                    dataIndex:'CustomerName',
			                    id:'CustomerName',
			                    width:160
		                    },
		                    {
		                        header:'�˻�����',
			                    dataIndex:'TotalQty',
			                    id:'TotalQty',
			                    width:80
		                    },
		                    {
			                    header:'�˻�ԭ��',
			                    dataIndex:'ReturnReason',
			                    id:'ReturnReason',
			                    width:120
		                    },
		                    {
		                        header:'����Ա',
			                    dataIndex:'OperName',
			                    id:'OperName',
			                    width:60
		                    },
		                    {
			                    header:'����ʱ��',
			                    dataIndex:'CreateDate',
			                    id:'CreateDate',
			                    renderer: Ext.util.Format.dateRenderer('Y��m��d��'),
			                    width:60
		                    }	,
		                    {
			                    header:'״̬',
			                    dataIndex:'StatusName',
			                    id:'StatusName',
			                    width:60
		                    }		
		                    
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
                         MstGrid.on("afterrender", function(component) {
                            component.getBottomToolbar().refresh.hideParent = true;
                            component.getBottomToolbar().refresh.hide(); 
                        });
                        
                        MstGrid.on('render', function(grid) {  
        var store = grid.getStore();  // Capture the Store.  
  
        var view = grid.getView();    // Capture the GridView. 
         MstGrid.tip = new Ext.ToolTip({  
            target: view.mainBody,    // The overall target element.  
      
            delegate: '.x-grid3-row', // Each grid row causes its own seperate show and hide.  
      
            trackMouse: true,         // Moving within the row should not hide the tip.  
      
            renderTo: document.body,  // Render immediately so that tip.body can be referenced prior to the first show.  
      
            listeners: {              // Change content dynamically depending on which element triggered the show.  
      
                beforeshow: function updateTipBody(tip) {  
                    var rowIndex = view.findRowIndex(tip.triggerElement);
                            var element = document.elementFromPoint(tip.x-20, tip.y-20);
                             var v = view.findCellIndex(element);
                             if(v==3||v==5)
                             {
                              
                                if(showTipRowIndex == rowIndex)
                                    return;
                                else
                                    showTipRowIndex = rowIndex;
                                     tip.body.dom.innerHTML="���ڼ������ݡ���";
                                        //ҳ���ύ
                                        Ext.Ajax.request({
                                            url: 'frmReturn.aspx?method=getreturndetailinfo',
                                            method: 'POST',
                                            params: {
                                                ReturnId: grid.getStore().getAt(rowIndex).data.ReturnId
                                            },
                                            success: function(resp, opts) {
                                                tip.body.dom.innerHTML = resp.responseText;
                                            },
                                            failure: function(resp, opts) {
                                                MstGrid.tip.hide();
                                            }
                                        });
                                }//ϸ����Ϣ                                                   
                                else
                                {
                                    MstGrid.tip.hide();
                                }
                        
            }  }});
        });  
    var showTipRowIndex=-1;
    
                        MstGrid.render();
                        /*------DataGrid�ĺ������� End---------------*/
        //////////////////////////////////End �б����/////////////////////////////////////////////////////////////
            
        
        
                    })
</script>

</html>

