<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmDrawInvCheck.aspx.cs" Inherits="SCM_frmDrawInvCheck" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>到货确认</title>
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

<!-- 所有数据源打印到这里 -->
<%= getComboBoxStore() %>

<script type="text/javascript">
Ext.BLANK_IMAGE_URL = "../ext3/resources/images/default/s.gif";  //作为：让下拉框的三角形下拉图片显示
Ext.onReady(function(){

        /*------实现toolbar的函数 start---------------*/
        var Toolbar = new Ext.Toolbar({
            renderTo: "toolbar",
            items: [{
                text: "快速确认",
                icon: "../Theme/1/images/extjs/customer/add16.gif",
                handler: function() { checkDrawInv(); }
            }, '-', {
                text: "数量录入",
                icon: "../Theme/1/images/extjs/customer/edit16.gif",
                handler: function() { popModifyWin(); }
            }
                   ]
            });
            /*------结束toolbar的函数 end---------------*/
            

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
            
        /*快速确认*/
        function checkDrawInv()
            {
                 var sm = DrawInvGrid.getSelectionModel();
	             var selectData =  sm.getSelected();
                //如果没有选择，就提示需要选择数据信息
                if(selectData == null || selectData == ""){
	                Ext.Msg.alert("提示","请选中需要确认的单据！");
	                return;
                }
                //页面提交
                Ext.Ajax.request({
	                url:'frmDrawInvCheck.aspx?method=checkDrawInv',
	                method:'POST',
	                params:{
		                DrawInvId:selectData.data.DrawInvId
	                },
	                success: function(resp,opts){
		                Ext.Msg.alert("提示","数据处理成功");
		                DrawInvGridData.reload();
	                },
	                failure: function(resp,opts){
		                Ext.Msg.alert("提示","数据处理失败");
	                }
                });
                
            }
            
            //弹出窗体明细查询
            function QueryDrawDtlDataGrid() {    
                var sm = DrawInvGrid.getSelectionModel();
	             var selectData =  sm.getSelected();
                //如果没有选择，就提示需要选择数据信息
                if(selectData == null || selectData == ""){
	                Ext.Msg.alert("提示","请选中需要确认的单据！");
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
            
            //弹出窗体显示
            function popModifyWin()
            {
                 var sm = DrawInvGrid.getSelectionModel();
	            //获取选择的数据信息
	            var selectData =  sm.getSelected();
	            if(selectData == null){
		            Ext.Msg.alert("提示","请选中需要编辑的信息！");
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
            
            
           //修改保存//数量不一致的保存
            function saveUpdate(){
               Ext.Msg.wait("正在提交，请稍后……");               
               //获取主表信息
               var sm = DrawInvGrid.getSelectionModel();
	           var selectData =  sm.getSelected();
	           //组装明细表信息
	           var json = "";
               ModDtlGridData.each(function(ModDtlGridData) {
                    json += Ext.util.JSON.encode(ModDtlGridData.data) + ',';
                                         });
	           Ext.Ajax.request({
		            url:'frmDrawInvCheck.aspx?method=saveUpdate',
		            method:'POST',
		            params:{
                        DrawInvId:selectData.data.DrawInvId,                        
                        //明细参数
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
		                    Ext.Msg.alert("提示","保存失败");     
		                }	
		            });
		      }
            
                        

/*-----------------------查询界面start------------------------*/
    var searchForm = new Ext.form.FormPanel({
        renderTo:'searchForm',
        frame:true,
        buttonAlign:'center',
        items:[
            {//第一行
                layout:'column',
                items:[
                    {//第一单元格
                        layout:'form',
                        border: false,
                        labelWidth:65,
                        columnWidth:.3,
                        items:[{
                            xtype:'textfield',
                            fieldLabel:'客户编号',
                            anchor:'95%',
                            id:'CustomerId',
                            name:'CustomerId'
                        }]
                    },
                    {//第二单元格
                        layout:'form',
                        border: false,
                        labelWidth:65,
                        columnWidth:.25,
                        items:[{
                             xtype:'datefield',
                            fieldLabel:'开始日期',
                            anchor:'95%',
                            id:'StartDate',
                            name:'StartDate',
                            format:'Y年m月d日',
                            value:new Date().getFirstDateOfMonth().clearTime(),
                            editable:false
                        }]
                    },
                    {//第三单元格
                        layout:'form',
                        border: false,
                        labelWidth:65,
                        columnWidth:.25,
                        items:[{
                            xtype:'datefield',
                            fieldLabel:'结束日期',
                            anchor:'95%',
                            id:'EndDate',
                            name:'EndDate',
                            format:'Y年m月d日',
                            value:new Date().clearTime(),
                            editable:false
                        }]
                    },
                    {//第三单元格
                        layout:'form',
                        border: false,
                        labelWidth:5,
                        columnWidth:.1,
                        items:[{
                            xtype:'checkbox',
                            boxLabel:'含自提',
                            anchor:'95%',
                            id:'IsAll',
                            name:'IsAll'
                        }]
                    },
                    {//第四单元格
                        layout:'form',
                        border: false,
                        labelWidth:65,
                        columnWidth:.1,
                        items:[{
                            xtype:'button',
                                text:'查询',
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
    /*-----------------------查询界面end------------------------*/
    
       
    
    
    /*------开始获取数据的函数 start---------------*/
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
            /*------获取数据的函数 结束 End---------------*/

                        /*------开始DataGrid的函数 start---------------*/

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
                            loadMask: { msg: '正在加载数据，请稍侯……' },
                            sm: sm,
                            cm: new Ext.grid.ColumnModel([
                            
		                    sm,
		                    new Ext.grid.RowNumberer(),//自动行号
		                    {
			                    header:'领货单号',
			                    dataIndex:'DrawInvId',
			                    id:'DrawInvId',
			                    hidden:true
		                    },
		                     {
			                    header:'领货单号',
			                    dataIndex:'DrawNumber',
			                    id:'DrawNumber'
		                    },
		                    {
			                    header:'仓库',
			                    dataIndex:'OutStorName',
			                    id:'OutStorName'
		                    },
		                    {
			                    header:'客户编码',
			                    dataIndex:'CustomerCode',
			                    id:'CustomerCode'
		                    },
		                    {
			                    header:'客户名称',
			                    dataIndex:'CustomerName',
			                    id:'CustomerName'
		                    },
		                    {
			                    header:'类型',
			                    dataIndex:'DrawTypeName',
			                    id:'DrawTypeName'
		                    },
		                    {
			                    header:'驾驶员',
			                    dataIndex:'DriverName',
			                    id:'DriverName'
		                    },
		                    {
			                    header:'送货车辆',
			                    dataIndex:'VehicleName',
			                    id:'VehicleName'
		                    },
		                    {
			                    header:'调度日期',
			                    dataIndex:'ControlDate',
			                    id:'ControlDate'
		                    },
		                    {
			                    header:'数量',
			                    dataIndex:'TotalQty',
			                    id:'TotalQty'
		                    },
		                    {
			                    header:'订单ID',
			                    dataIndex:'OrderId',
			                    id:'OrderId',
			                    hidden:true
		                    }		                    
		                    
		                    
		                    	]),
                            bbar: new Ext.PagingToolbar({
                                pageSize: 10,
                                store: DrawInvGridData,
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
                        /*------DataGrid的函数结束 End---------------*/
                        
                        
                        
                        
  ////////////////////////Start 修改界面///////////////////////////////////////////////////////////////////////
  
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
		                labelSeparator: '：',
		                items: [
		                {
			                layout:'form',
			                border: false,
			                columnWidth:0.33,
			                items: [
				                {
					                 xtype:'textfield',
		                            fieldLabel:'客户编码',
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
		                            fieldLabel:'客户名称',
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
                                   fieldLabel: '单据类型',
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
		                labelSeparator: '：',
		                items: [
		                {
			                layout:'form',
			                border: false,
			                columnWidth:0.33,
			                 items: [
				                {
					               xtype:'combo',
                                    fieldLabel:'驾驶员',
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
                                    fieldLabel:'送货车辆',
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
                                    fieldLabel:'调度日期',
                                    anchor:'95%',
                                    id:'ControlDate',
                                    name:'ControlDate',
                                    format:'Y年m月d日',
                                    editable:false
				                }]
		                }
	                ]}                  
                ]});
                
                        /*------开始获取数据的函数 start---------------*/
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

                        /*------获取数据的函数 结束 End---------------*/

                        /*------开始DataGrid的函数 start---------------*/

                        var sm = new Ext.grid.CheckboxSelectionModel({
                            singleSelect: false
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
			                    header:'商品代码',
			                    dataIndex:'ProductCode',
			                    id:'ProductCode'
		                    },
		                    {
		                        header:'名称',
			                    dataIndex:'ProductName',
			                    id:'ProductName'
		                    },
		                    {
		                        header:'单位id',
			                    dataIndex:'UnitId',
			                    id:'UnitId',
			                    hidden:true
		                    },
		                    {
		                        header:'单位',
			                    dataIndex:'UnitName',
			                    id:'UnitName'
		                    },
		                    {
		                        header:'规格',
			                    dataIndex:'SpecName',
			                    id:'SpecName'
		                    },
		                    {
		                        header:'送货数量',
			                    dataIndex:'DrawQty',
			                    id:'DrawQty'
		                    },
		                    {
		                        header:'实到数量',
			                    dataIndex:'CheckQty',
			                    id:'CheckQty',
			                    editor: new Ext.form.NumberField({ allowBlank: false }),
			                    renderer: function(v, m) {
                                    m.css = 'x-grid-back-blue';
                                    return v;
                                }                                       
		                    },
		                    {
		                        header:'单价',
			                    dataIndex:'Price',
			                    id:'Price'         
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
                            autoExpandColumn: 2,
                            sortInfo:{field:'ProductCode',direction:'ASC'}
                        });        
                         ModOrderDtlGrid.on("afterrender", function(component) {
                            component.getBottomToolbar().refresh.hideParent = true;
                            component.getBottomToolbar().refresh.hide(); 
                        });         
            
            if(typeof(openModWin)=="undefined"){//解决创建2个windows问题
	            openModWin = new Ext.Window({
		            id:'openModWin',
		            title:'到货确认'
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
			            text: "保存"
			            , handler: function() {
			                saveUpdate();
			            }
			            , scope: this
		            },
		            {
			            text: "取消"
			            , handler: function() { 
				            openModWin.hide();
				            DrawInvGridData.reload();
			            }
			            , scope: this
		            }]});
	            }
	            openModWin.addListener("hide",function(){
            });
        
        
        
        ////////////////////////End 修改界面///////////////////////////////////////////////////////////////////////
        
        

})

</script>

</html>