<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmReturnCheck.aspx.cs" Inherits="SCM_frmReturnCheck" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">


<html>
<head>
<title>退货单审核</title><meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
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
     
    
        /*------实现toolbar的函数 start---------------*/
       var Toolbar = new Ext.Toolbar({
            renderTo: "toolbar",
            items: [{
                text: "审核",
                icon: "../Theme/1/images/extjs/customer/add16.gif",
                handler: function() { checkReturn(); }
                }]
            });
            /*------结束toolbar的函数 end---------------*/
          
          //退货单列表选择
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
           
           ////退货单审核
            function checkReturn()
            {
                 var sm = MstGrid.getSelectionModel();
	             var selectData =  sm.getSelected();
                //如果没有选择，就提示需要选择数据信息
                if(selectData == null || selectData == ""){
	                Ext.Msg.alert("提示","请选中需要审核的记录！");
	                return;
                }
                if (selectData.data.Status != 1)
	            {
	                Ext.Msg.alert("提示","仓库已处理，不允许操作！");
		            return;
	            }
                //页面提交
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
		                Ext.Msg.alert("提示","数据操作失败");
	                }
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
					                fieldLabel:'客户',
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
					                fieldLabel:'开始日期',
					                columnWidth:0.5,
					                anchor:'90%',
					                name:'StartDate',
					                id:'StartDate',
					                value:new Date().getFirstDateOfMonth().clearTime(),
					                format:'Y年m月d日'
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
					                fieldLabel:'结束日期',
					                columnWidth:0.5,
					                anchor:'90%',
					                name:'EndDate',
					                id:'EndDate',
					                value:new Date().clearTime(),
					                format:'Y年m月d日'
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
                                    text: '查询',
                                    buttonAlign:'right',
                                    id: 'searchebtnId',
                                    anchor: '90%',
                                    handler: function() {QueryDataGrid();}
				                }]
		                }
	                ]}                 
                ]});


                        /*------开始获取数据的函数 start---------------*/
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
		                    {
			                    header:'标识',
			                    dataIndex:'ReturnId',
			                    id:'ReturnId',
			                    hidden:true
		                    },
		                    {
			                    header:'编号',
			                    dataIndex:'ReturnNumber',
			                    id:'ReturnNumber',
			                    width:80
		                    },
		                    {
		                        header:'公司名称',
			                    dataIndex:'OrgName',
			                    id:'OrgName',
			                    hidden:true
		                    },
		                    {
		                        header:'仓库',
			                    dataIndex:'StorName',
			                    id:'StorName' ,
			                    width:60
		                    },
		                    {
		                        header:'客户编码',
			                    dataIndex:'CustomerCode',
			                    id:'CustomerCode',
			                    width:60
		                    },
		                    {
		                        header:'客户名称',
			                    dataIndex:'CustomerName',
			                    id:'CustomerName',
			                    width:160
		                    },
		                    {
		                        header:'退货总量',
			                    dataIndex:'TotalQty',
			                    id:'TotalQty',
			                    width:80
		                    },
		                    {
			                    header:'退货原因',
			                    dataIndex:'ReturnReason',
			                    id:'ReturnReason',
			                    width:120
		                    },
		                    {
		                        header:'操作员',
			                    dataIndex:'OperName',
			                    id:'OperName',
			                    width:60
		                    },
		                    {
			                    header:'创建时间',
			                    dataIndex:'CreateDate',
			                    id:'CreateDate',
			                    renderer: Ext.util.Format.dateRenderer('Y年m月d日'),
			                    width:60
		                    }	,
		                    {
			                    header:'状态',
			                    dataIndex:'StatusName',
			                    id:'StatusName',
			                    width:60
		                    }		
		                    
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
                                     tip.body.dom.innerHTML="正在加载数据……";
                                        //页面提交
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
                                }//细项信息                                                   
                                else
                                {
                                    MstGrid.tip.hide();
                                }
                        
            }  }});
        });  
    var showTipRowIndex=-1;
    
                        MstGrid.render();
                        /*------DataGrid的函数结束 End---------------*/
        //////////////////////////////////End 列表界面/////////////////////////////////////////////////////////////
            
        
        
                    })
</script>

</html>

