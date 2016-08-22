<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmDrawInvCheck.aspx.cs" Inherits="SCM_frmDrawInvCheck" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>����ȷ��</title>
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
Ext.onReady(function(){

        /*------ʵ��toolbar�ĺ��� start---------------*/
        var Toolbar = new Ext.Toolbar({
            renderTo: "toolbar",
            items: [{
                text: "����ȷ��",
                icon: "../Theme/1/images/extjs/customer/add16.gif",
                handler: function() { checkDrawInv(); }
            }, '-', {
                text: "����¼��",
                icon: "../Theme/1/images/extjs/customer/edit16.gif",
                handler: function() { popModifyWin(); }
            }
                   ]
            });
            /*------����toolbar�ĺ��� end---------------*/
            

        function QueryDataGrid() {  
                DrawInvGridData.baseParams.CustomerId = Ext.getCmp('CustomerId').getValue(); 
                DrawInvGridData.baseParams.StartDate = Ext.util.Format.date(Ext.getCmp('StartDate').getValue(),'Y/m/d');   
                DrawInvGridData.baseParams.EndDate = Ext.util.Format.date(Ext.getCmp('EndDate').getValue(),'Y/m/d');         
                DrawInvGridData.baseParams.IsAll = Ext.getCmp('IsAll').getValue(); 
                DrawInvGridData.load({
                    params: {
                        start: 0,
                        limit: 10
                    }
                });
            }
            
        /*����ȷ��*/
        function checkDrawInv()
            {
                 var sm = DrawInvGrid.getSelectionModel();
	             var selectData =  sm.getSelected();
                //���û��ѡ�񣬾���ʾ��Ҫѡ��������Ϣ
                if(selectData == null || selectData == ""){
	                Ext.Msg.alert("��ʾ","��ѡ����Ҫȷ�ϵĵ��ݣ�");
	                return;
                }
                //ҳ���ύ
                Ext.Ajax.request({
	                url:'frmDrawInvCheck.aspx?method=checkDrawInv',
	                method:'POST',
	                params:{
		                DrawInvId:selectData.data.DrawInvId
	                },
	                success: function(resp,opts){
		                Ext.Msg.alert("��ʾ","���ݴ���ɹ�");
		                DrawInvGridData.reload();
	                },
	                failure: function(resp,opts){
		                Ext.Msg.alert("��ʾ","���ݴ���ʧ��");
	                }
                });
                
            }
            
            //����������ϸ��ѯ
            function QueryDrawDtlDataGrid() {    
                var sm = DrawInvGrid.getSelectionModel();
	             var selectData =  sm.getSelected();
                //���û��ѡ�񣬾���ʾ��Ҫѡ��������Ϣ
                if(selectData == null || selectData == ""){
	                Ext.Msg.alert("��ʾ","��ѡ����Ҫȷ�ϵĵ��ݣ�");
	                return;
                }            
                ModDtlGridData.load({
                    params: {
                        start: 0,
                        limit: 10,                            
		                DrawInvId:selectData.data.DrawInvId
                    }
                });
            }
            
            //����������ʾ
            function popModifyWin()
            {
                 var sm = DrawInvGrid.getSelectionModel();
	            //��ȡѡ���������Ϣ
	            var selectData =  sm.getSelected();
	            if(selectData == null){
		            Ext.Msg.alert("��ʾ","��ѡ����Ҫ�༭����Ϣ��");
		            return;
	            }
	            openModWin.show();
                Ext.getCmp("CustomerCode").setValue(selectData.data.CustomerCode);
		        Ext.getCmp("CustomerName").setValue(selectData.data.CustomerName);
		        Ext.getCmp("DrawType").setValue(selectData.data.DrawType);
		        Ext.getCmp("DriverId").setValue(selectData.data.DriverId);
		        Ext.getCmp("ControlDate").setValue(selectData.data.ControlDate);
		        Ext.getCmp("VehicleId").setValue(selectData.data.VehicleId);
		        QueryDrawDtlDataGrid() ;
            }
            
            
           //�޸ı���//������һ�µı���
            function saveUpdate(){
               Ext.Msg.wait("�����ύ�����Ժ󡭡�");               
               //��ȡ������Ϣ
               var sm = DrawInvGrid.getSelectionModel();
	           var selectData =  sm.getSelected();
	           //��װ��ϸ����Ϣ
	           var json = "";
               ModDtlGridData.each(function(ModDtlGridData) {
                    json += Ext.util.JSON.encode(ModDtlGridData.data) + ',';
                                         });
	           Ext.Ajax.request({
		            url:'frmDrawInvCheck.aspx?method=saveUpdate',
		            method:'POST',
		            params:{
                        DrawInvId:selectData.data.DrawInvId,                        
                        //��ϸ����
                        DetailInfo: json
                       },
	                   success: function(resp,opts){ 
	                        Ext.Msg.hide();
	                        if( checkExtMessage(resp) )
                            {
	                            ModDtlGridData.reload();  
	                        }
	                    },
		               failure: function(resp,opts){  
		                    Ext.Msg.hide();
		                    Ext.Msg.alert("��ʾ","����ʧ��");     
		                }	
		            });
		      }
            
                        

/*-----------------------��ѯ����start------------------------*/
    var searchForm = new Ext.form.FormPanel({
        renderTo:'searchForm',
        frame:true,
        buttonAlign:'center',
        items:[
            {//��һ��
                layout:'column',
                items:[
                    {//��һ��Ԫ��
                        layout:'form',
                        border: false,
                        labelWidth:65,
                        columnWidth:.3,
                        items:[{
                            xtype:'textfield',
                            fieldLabel:'�ͻ����',
                            anchor:'95%',
                            id:'CustomerId',
                            name:'CustomerId'
                        }]
                    },
                    {//�ڶ���Ԫ��
                        layout:'form',
                        border: false,
                        labelWidth:65,
                        columnWidth:.25,
                        items:[{
                             xtype:'datefield',
                            fieldLabel:'��ʼ����',
                            anchor:'95%',
                            id:'StartDate',
                            name:'StartDate',
                            format:'Y��m��d��',
                            value:new Date().getFirstDateOfMonth().clearTime(),
                            editable:false
                        }]
                    },
                    {//������Ԫ��
                        layout:'form',
                        border: false,
                        labelWidth:65,
                        columnWidth:.25,
                        items:[{
                            xtype:'datefield',
                            fieldLabel:'��������',
                            anchor:'95%',
                            id:'EndDate',
                            name:'EndDate',
                            format:'Y��m��d��',
                            value:new Date().clearTime(),
                            editable:false
                        }]
                    },
                    {//������Ԫ��
                        layout:'form',
                        border: false,
                        labelWidth:5,
                        columnWidth:.1,
                        items:[{
                            xtype:'checkbox',
                            boxLabel:'������',
                            anchor:'95%',
                            id:'IsAll',
                            name:'IsAll'
                        }]
                    },
                    {//���ĵ�Ԫ��
                        layout:'form',
                        border: false,
                        labelWidth:65,
                        columnWidth:.1,
                        items:[{
                            xtype:'button',
                                text:'��ѯ',
                                width:70,
                                //iconCls:'excelIcon',
                                scope:this,
                                handler:function(){
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
                            url: 'frmDrawInvCheck.aspx?method=getDrawInvList',
                            reader: new Ext.data.JsonReader({
                                totalProperty: 'totalProperty',
                                root: 'root'
                            }, [
                                {
		                            name:'DrawInvId'
	                            },
	                            {
		                            name:'DrawNumber'
	                            },
	                            {
		                            name:'OutStor'
	                            },
	                            {
		                            name:'OutStorName'
	                            },
	                            {
		                            name:'CustomerId'
	                            },
	                            {
		                            name:'CustomerName'
	                            },
	                            {
		                            name:'CustomerCode'
	                            },
	                            {
		                            name:'DrawType'
	                            },
	                            {
		                            name:'DrawTypeName'
	                            },
	                            {
		                            name:'DriverId'
	                            },
	                            {
		                            name:'DriverName'
	                            },
	                            {
		                            name:'VehicleId'
	                            },
	                            {
		                            name:'VehicleName'
	                            },
	                            {
		                            name:'ControlDate'
	                            },
	                            {
		                            name:'TotalQty'
	                            },
	                            {
		                            name:'OrderId'
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
		                    new Ext.grid.RowNumberer(),//�Զ��к�
		                    {
			                    header:'�������',
			                    dataIndex:'DrawInvId',
			                    id:'DrawInvId',
			                    hidden:true
		                    },
		                     {
			                    header:'�������',
			                    dataIndex:'DrawNumber',
			                    id:'DrawNumber'
		                    },
		                    {
			                    header:'�ֿ�',
			                    dataIndex:'OutStorName',
			                    id:'OutStorName'
		                    },
		                    {
			                    header:'�ͻ�����',
			                    dataIndex:'CustomerCode',
			                    id:'CustomerCode'
		                    },
		                    {
			                    header:'�ͻ�����',
			                    dataIndex:'CustomerName',
			                    id:'CustomerName'
		                    },
		                    {
			                    header:'����',
			                    dataIndex:'DrawTypeName',
			                    id:'DrawTypeName'
		                    },
		                    {
			                    header:'��ʻԱ',
			                    dataIndex:'DriverName',
			                    id:'DriverName'
		                    },
		                    {
			                    header:'�ͻ�����',
			                    dataIndex:'VehicleName',
			                    id:'VehicleName'
		                    },
		                    {
			                    header:'��������',
			                    dataIndex:'ControlDate',
			                    id:'ControlDate'
		                    },
		                    {
			                    header:'����',
			                    dataIndex:'TotalQty',
			                    id:'TotalQty'
		                    },
		                    {
			                    header:'����ID',
			                    dataIndex:'OrderId',
			                    id:'OrderId',
			                    hidden:true
		                    }		                    
		                    
		                    
		                    	]),
                            bbar: new Ext.PagingToolbar({
                                pageSize: 10,
                                store: DrawInvGridData,
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
                            sortInfo:{field: 'DrawNumber', direction: 'ASC'}, 
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
                        DrawInvGrid.render();
                        /*------DataGrid�ĺ������� End---------------*/
                        
                        
                        
                        
  ////////////////////////Start �޸Ľ���///////////////////////////////////////////////////////////////////////
  
                var modDtlForm = new Ext.FormPanel({
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
			                columnWidth:0.33,
			                items: [
				                {
					                 xtype:'textfield',
		                            fieldLabel:'�ͻ�����',
		                            columnWidth:0.33,
		                            anchor:'90%',
		                            name:'CustomerCode',
		                            id:'CustomerCode',
		                            editable:false
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
		                            columnWidth:0.5,
		                            anchor:'90%',
		                            name:'CustomerName',
		                            id:'CustomerName',
		                            editable:false
				                }
		                ]
		                }
                ,		{
			                layout:'form',
			                border: false,
			                columnWidth:0.34,
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
                                   name:'DrawType',
                                   id:'DrawType',
                                   selectOnFocus: true,
                                   anchor: '90%',
                                   editable:false
				                }
		                          ]
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
			                columnWidth:0.33,
			                 items: [
				                {
					               xtype:'combo',
                                    fieldLabel:'��ʻԱ',
                                    anchor:'95%',
                                    id:'DriverId',
                                    name:'DriverId',
                                    store:dsDriver,
                                    triggerAction: 'all',
                                    mode:'local',
                                    displayField:'DriverName',
                                    valueField:'DriverId',
                                    editable: false
				                }
		                          ]
		                }
                ,		{
			                layout:'form',
			                border: false,
			                columnWidth:0.33,
			                 items: [
				                {
					               xtype:'combo',
                                    fieldLabel:'�ͻ�����',
                                    anchor:'95%',
                                    id:'VehicleId',
                                    name:'VehicleId',
                                    store:dsVehicle,
                                    triggerAction: 'all',
                                    mode:'local',
                                    displayField:'VehicleName',
                                    valueField:'VehicleId',
                                    editable:false
				                }
		                          ]
		                }
                ,		{
			                layout:'form',
		                    border: false,
		                    columnWidth:0.34,
		                    items: [{
				                     xtype:'datefield',
                                    fieldLabel:'��������',
                                    anchor:'95%',
                                    id:'ControlDate',
                                    name:'ControlDate',
                                    format:'Y��m��d��',
                                    editable:false
				                }]
		                }
	                ]}                  
                ]});
                
                        /*------��ʼ��ȡ���ݵĺ��� start---------------*/
                        var ModDtlGridData = new Ext.data.Store
                        ({
                            url: 'frmDrawInvCheck.aspx?method=getDrawDtlListByDrawInvId',
                            reader: new Ext.data.JsonReader({
                                totalProperty: 'totalProperty',
                                root: 'root'
                            }, [
                                {
		                            name:'DrawInvDtlId'
	                            },
	                            {
		                            name:'DrawInvId'
	                            },
	                            {
		                            name:'ProductId'
	                            },
	                            {
		                            name:'DrawQty'
	                            },
	                            {
		                            name:'CheckQty'
	                            },
	                            {
		                            name:'Price'
	                            },
	                            {
		                            name:'Amt'
	                            },
	                            {
		                            name:'Tax'
	                            },
	                            {
		                            name:'SpecName'
	                            },
	                            {
		                            name:'ProductCode'
	                            },
	                            {
		                            name:'UnitName'
	                            },
	                            {
		                            name:'UnitId'
	                            },
	                            {
		                            name:'ProductName'
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
                            height:220, 
                            id: '',
                            store: ModDtlGridData,
                            loadMask: { msg: '���ڼ������ݣ����Ժ��' },
                            sm: sm,
                            cm: new Ext.grid.ColumnModel([                            
		                    sm,
		                    new Ext.grid.RowNumberer(),//�Զ��к�
		                    {
			                    header:'��Ʒ����',
			                    dataIndex:'ProductCode',
			                    id:'ProductCode'
		                    },
		                    {
		                        header:'����',
			                    dataIndex:'ProductName',
			                    id:'ProductName'
		                    },
		                    {
		                        header:'��λid',
			                    dataIndex:'UnitId',
			                    id:'UnitId',
			                    hidden:true
		                    },
		                    {
		                        header:'��λ',
			                    dataIndex:'UnitName',
			                    id:'UnitName'
		                    },
		                    {
		                        header:'���',
			                    dataIndex:'SpecName',
			                    id:'SpecName'
		                    },
		                    {
		                        header:'�ͻ�����',
			                    dataIndex:'DrawQty',
			                    id:'DrawQty'
		                    },
		                    {
		                        header:'ʵ������',
			                    dataIndex:'CheckQty',
			                    id:'CheckQty',
			                    editor: new Ext.form.NumberField({ allowBlank: false }),
			                    renderer: function(v, m) {
                                    m.css = 'x-grid-back-blue';
                                    return v;
                                }                                       
		                    },
		                    {
		                        header:'����',
			                    dataIndex:'Price',
			                    id:'Price'         
		                    }
		                    
		                    ]),
                            bbar: new Ext.PagingToolbar({
                                pageSize: 10,
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
                            autoExpandColumn: 2,
                            sortInfo:{field:'ProductCode',direction:'ASC'}
                        });        
                         ModOrderDtlGrid.on("afterrender", function(component) {
                            component.getBottomToolbar().refresh.hideParent = true;
                            component.getBottomToolbar().refresh.hide(); 
                        });         
            
            if(typeof(openModWin)=="undefined"){//�������2��windows����
	            openModWin = new Ext.Window({
		            id:'openModWin',
		            title:'����ȷ��'
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
		            ,buttons: [{
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
		            }]});
	            }
	            openModWin.addListener("hide",function(){
            });
        
        
        
        ////////////////////////End �޸Ľ���///////////////////////////////////////////////////////////////////////
        
        

})

</script>

</html>