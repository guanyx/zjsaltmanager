<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmFmAccPay.aspx.cs" Inherits="FM_frmFmAccRece" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html>
<head>
<title>应付帐款管理</title><meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
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
    
        /*------实现toolbar的函数 start---------------*/
       var Toolbar = new Ext.Toolbar({
            renderTo: "toolbar",
            items: [{
                text: "新增付款记录",
                icon: "../Theme/1/images/extjs/customer/add16.gif",
                handler: function() { popAddWin(); }
                   }]
            });
            /*------结束toolbar的函数 end---------------*/
          
          //客户列表选择
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
           
            //弹出新增窗口
             function popAddWin() {
                var sm = MstGrid.getSelectionModel();
	            var selectData =  sm.getSelected();
	            if(selectData == null || selectData == ""){
		            Ext.Msg.alert("提示","请选中录入付款记录的客户！");
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
                Ext.getCmp("FundType").setValue("F051");
                Ext.getCmp("BusinessType").setValue("F061");
                Ext.getCmp("PayType").setValue("F011");
	            
            }
            
            
            //新增保存
            function saveAdd(){
               //获取主表信息
               var sm = MstGrid.getSelectionModel();
	           var selectData =  sm.getSelected();
	           
	           Ext.Ajax.request({
		            url:'frmFmAccPay.aspx?method=saveAdd',
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
		               failure: function(resp,opts){  Ext.Msg.alert("提示","保存失败");     }	
		            });
		      }
            
            //////////////////////////////Start 列表界面/////////////////////////////////////////////////////////////////
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
		                labelSeparator: '：',
		                items: [
		                {
			                layout:'form',
			                border: false,
			                columnWidth:0.33,
			                items: [
				                {
					                xtype:'textfield',
					                fieldLabel:'客户编号',
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
					                fieldLabel:'客户名称',
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
                                    text: '查询',
                                    buttonAlign:'right',
                                    id: 'searchebtnId',
                                    anchor: '25%',
                                    handler: function() {QueryDataGrid();}
				                }
		                ]
		                }
	                ]}           
                ]});


                        /*------开始获取数据的函数 start---------------*/
                        var MstGridData = new Ext.data.Store
                        ({
                            url: 'frmFmAccPay.aspx?method=getCustomerList',
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

                        /*------获取数据的函数 结束 End---------------*/

                        /*------开始DataGrid的函数 start---------------*/

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
                            loadMask: { msg: '正在加载数据，请稍侯……' },
                            sm: sm,
                            cm: new Ext.grid.ColumnModel([
                            
		                    sm,
		                    new Ext.grid.RowNumberer(),//自动行号
		                      { header: "客户ID",dataIndex: 'CustomerId' ,hidden:true,hideable:false},
			                  { header: "客户编号", width: 60, sortable: true, dataIndex: 'CustomerNo' },
			                  { header: "客户名称", width: 60, sortable: true, dataIndex: 'ShortName' },
			                  { header: "联系人", width: 30, sortable: true, dataIndex: 'LinkMan' },
			                  { header: "联系电话", width: 30, sortable: true, dataIndex: 'LinkTel' },
			                  { header: "移动电话", width: 30, sortable: true, dataIndex: 'LinkMobile' ,hidden:true,hideable:false},
			                  { header: "传真", width: 30, sortable: true, dataIndex: 'Fax' ,hidden:true,hideable:false},
			                  { header: "配送类型", width: 25, sortable: true, dataIndex: 'DistributionTypeText' },
			                  { header: "月用量", width: 20, sortable: true, dataIndex: 'MonthQuantity' },
			                  { header: "客商", width: 60, sortable: true, dataIndex: 'IsCust',renderer:{fn:function(v){if(v==1)return '是';return '否';}} },
			                  { header: "供应商", width: 60, sortable: true, dataIndex: 'IsProvide',renderer:{fn:function(v){if(v==1)return '是';return '否';}} },
			                  { header: "创建时间", width: 60, sortable: true, dataIndex: 'CreateDate',renderer: Ext.util.Format.dateRenderer('Y年m月d日') }//renderer: Ext.util.Format.dateRenderer('m/d/Y'),
		                    
		                    ]),
                            bbar: new Ext.PagingToolbar({
                                pageSize: 10,
                                store: MstGridData,
                                displayMsg: '显示第{0}条到{1}条记录,共{2}条',
                                emptyMsy: '没有记录',
                                displayInfo: true
                            }),
                            viewConfig: {
                                columnsText: '显示的列',
                                scrollOffset: 20,
                                sortAscText: '升序',
                                sortDescText: '降序',
                                forceFit: true
                            },
                            height: 280,
                            closeAction: 'hide',
                            stripeRows: true,
                            loadMask: true,
                            autoExpandColumn: 2
                        });
                        MstGrid.render();
                        /*------DataGrid的函数结束 End---------------*/
        //////////////////////////////////End 列表界面/////////////////////////////////////////////////////////////
        
        
        
        ////////////////////////Start 修改界面///////////////////////////////////////////////////////////////////////        
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
	                            labelSeparator: '：',
	                            items: [
	                            {
		                            layout:'form',
		                            border: false,
		                            columnWidth:0.3,
		                            items: [
			                            {
				                            xtype:'textfield',
				                            fieldLabel:'客户编码',
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
				                            fieldLabel:'客户名称',
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
                        
                        
                        /*------开始获取数据的函数 start---------------*/
                        var ModDtlGridData = new Ext.data.Store
                        ({
                            url: 'frmFmAccPay.aspx?method=getAccountReceDtl',
                            reader: new Ext.data.JsonReader({
                                totalProperty: 'totalProperty',
                                root: 'root'
                            }, [
                                {   name:'Ext3'     },
                                {   name:'Ext4'     },
                                {   name:'PayableId'     },
                                {   name:'CustomerId'     },
                                {   name:'CustomerNo'     },
                                {   name:'CustomerName'     },
                                {   name:'OrderId'      },
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

                        /*------获取数据的函数 结束 End---------------*/

                        /*------开始DataGrid的函数 start---------------*/

                        var sm = new Ext.grid.CheckboxSelectionModel({
                            singleSelect: true
                        });
                        var ModOrderDtlGrid = new Ext.grid.EditorGridPanel({
                            autoScroll: true,
                            height:220, 
                            id: '',
                            store: ModDtlGridData,
                            loadMask: { msg: '正在加载数据，请稍侯……' },
                            sm: sm,
                            cm: new Ext.grid.ColumnModel([                            
		                    sm,
		                    new Ext.grid.RowNumberer(),//自动行号
		                    {
			                    header:'序号',
			                    dataIndex:'PayableId',
			                    id:'PayableId'
		                    },
		                    {
			                    header:'订单编号',
			                    dataIndex:'OrderId',
			                    id:'OrderId'
		                    },
		                    {
		                        header:'业务种类',
			                    dataIndex:'BusinessTypeText',
			                    id:'BusinessTypeText'
		                    },
		                    {
		                        header:'借贷方向',
			                    dataIndex:'FundTypeText',
			                    id:'FundTypeText'
		                    },
		                    {
		                        header:'付款类型',
			                    dataIndex:'PayTypeText',
			                    id:'PayTypeText'
		                    },
		                    {
		                        header:'金额',
			                    dataIndex:'Amount',
			                    id:'Amount',
			                    renderer:function(v){
			                        return Number(v).toFixed(2);
			                    }              
		                    },
		                    {
		                        header:'累计金额',
			                    dataIndex:'TotalAmount',
			                    id:'TotalAmount',
			                    renderer:function(v){
			                        return Number(v).toFixed(2);
			                    }         
		                    },
		                    {
		                        header:'操作员',
			                    dataIndex:'OperName',
			                    id:'OperName'         
		                    },
		                    {
		                        header:'操作日期',
			                    dataIndex:'CreateDate',
			                    id:'CreateDate',
			                    renderer: Ext.util.Format.dateRenderer('Y年m月d日')        
		                    }
		                    
		                    ]),
                            bbar: new Ext.PagingToolbar({
                                pageSize: 10,
                                store: ModDtlGridData,
                                displayMsg: '显示第{0}条到{1}条记录,共{2}条',
                                emptyMsy: '没有记录',
                                displayInfo: true
                            }),
                            viewConfig: {
                                columnsText: '显示的列',
                                scrollOffset: 20,
                                sortAscText: '升序',
                                sortDescText: '降序',
                                forceFit: true
                            }, 
                            closeAction: 'hide',
                            stripeRows: true,
                            loadMask: true,
                            autoExpandColumn: 2
                            
                        });    
                        
             //应付帐款输入内容
             var modDtlFormInput = new Ext.FormPanel({
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
	                            labelSeparator: '：',
	                            items: [
	                            {
		                            layout:'form',
		                            border: false,
		                            columnWidth:0.25,
		                            items: [
			                            {
				                                xtype: 'combo',
                                               store: dsBizType,
                                               valueField: 'DicsCode',
                                               displayField: 'DicsName',
                                               mode: 'local',
                                               forceSelection: true,
                                               editable: false,
                                               emptyValue: '',
                                               triggerAction: 'all',
                                               fieldLabel: '业务种类',
                                               name:'BusinessType',
                                               id:'BusinessType',
                                               selectOnFocus: true,
                                               anchor: '90%',
				                               editable:false
			                            }
	                                        ]
	                            }		                
                        ,		{
		                            layout:'form',
		                            border: false,
		                            columnWidth:0.25,
		                            items: [
			                            {
				                             xtype: 'combo',
                                               store: dsFundType,
                                               valueField: 'DicsCode',
                                               displayField: 'DicsName',
                                               mode: 'local',
                                               forceSelection: true,
                                               editable: false,
                                               emptyValue: '',
                                               triggerAction: 'all',
                                               fieldLabel: '借贷方向',
                                               name:'FundType',
                                               id:'FundType',
                                               selectOnFocus: true,
                                               anchor: '90%',
				                               editable:false
			                            }
	                                        ]
	                            }
                              ,		{
		                            layout:'form',
		                            border: false,
		                            columnWidth:0.25,
		                            items: [
			                            {
				                            xtype: 'combo',
                                           store: dsPayType,
                                           valueField: 'DicsCode',
                                           displayField: 'DicsName',
                                           mode: 'local',
                                           forceSelection: true,
                                           editable: false,
                                           emptyValue: '',
                                           triggerAction: 'all',
                                           fieldLabel: '付款类型',
                                           name:'PayType',
                                           id:'PayType',
                                           selectOnFocus: true,
                                           anchor: '90%',
				                           editable:false
			                            }
	                                        ]
	                            }
	                         ,		{
		                            layout:'form',
		                            border: false,
		                            columnWidth:0.25,
		                            items: [
			                            {
				                           xtype:'numberfield',
				                            fieldLabel:'金额',
				                            columnWidth:0.25,
				                            anchor:'90%',
				                            name:'Amount',
				                            id:'Amount',
				                            editable:false
			                            }
	                                        ]
	                            }           
                       
                            ]}                  
                        ]});
                        
                        
                                     
            
            if(typeof(openAddWin)=="undefined"){//解决创建2个windows问题
	            openAddWin = new Ext.Window({
		            id:'openModWin',
		            title:'应付帐款维护'
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
                         },
                         {       layout:'form',
                                border: false,
                                columnWidth:1,
                                items: [  modDtlFormInput ]
                         }
		            
		            ]
		            ,buttons: [{
			            text: "保存"
			            , handler: function() {
			                saveAdd();
			                ModDtlGridData.reload();
			            }
			            , scope: this
		            },
		            {
			            text: "取消"
			            , handler: function() { 
				            openAddWin.hide();
				            MstGridData.reload();
			            }
			            , scope: this
		            }]});
	            }
	            openAddWin.addListener("hide",function(){
            });
        
        
        
        ////////////////////////End 修改界面///////////////////////////////////////////////////////////////////////
        
        
        
            
          
        
                    })
</script>

</html>
