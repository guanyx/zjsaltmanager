<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmDlvBack.aspx.cs" Inherits="SCM_frmDlvBack" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>领货单管理</title>
    <link rel="stylesheet" type="text/css" href="../ext3/resources/css/ext-all.css" />
    <script type="text/javascript" src="../ext3/adapter/ext/ext-base.js"></script>
    <script type="text/javascript" src="../ext3/ext-all.js"></script>
    <script type="text/javascript" src="../ext3/src/locale/ext-lang-zh_CN.js"></script>
</head>
<body>    
    <div id="searchForm"></div>
    <div id="DrawInvGrid"></div>
</body>

<!-- 所有数据源打印到这里 -->
<%= getComboBoxStore() %>

<script type="text/javascript">
Ext.BLANK_IMAGE_URL = "../ext3/resources/images/default/s.gif";  //作为：让下拉框的三角形下拉图片显示
Ext.onReady(function(){

        function QueryDataGrid() {   
        
                DrawInvGridData.baseParams.OrgId = <% =ZJSIG.UIProcess.ADM.UIAdmUser.OrgID(this)%>;
                DrawInvGridData.baseParams.DeptId = <% =ZJSIG.UIProcess.ADM.UIAdmUser.DeptID(this)%>;
                DrawInvGridData.baseParams.OutStor = Ext.getCmp('OutStor').getValue();		                
                DrawInvGridData.baseParams.CustomerId = Ext.getCmp('CustomerId').getValue();
                DrawInvGridData.baseParams.DrawInvId = Ext.getCmp('DrawInvId').getValue();          
                DrawInvGridData.baseParams.DrawType = Ext.getCmp('DrawType').getValue();                            
                DrawInvGridData.baseParams.StartDate = Ext.util.Format.date(Ext.getCmp('StartDate').getValue(),'Y/m/d');
                DrawInvGridData.baseParams.EndDate = Ext.util.Format.date(Ext.getCmp('EndDate').getValue(),'Y/m/d');
                  
                DrawInvGridData.load({
                    params: {
                        start: 0,
                        limit: 10
                    }
                });
            }
            
            /*----- ----*/
            function delDrawInv() {
                var sm = DrawInvGrid.getSelectionModel();
                //多选
                var selectData = sm.getSelections();                
                var array = new Array(selectData.length);
                var array1 = new Array(selectData.length);
                for(var i=0;i<selectData.length;i++)
                {
                    array[i] = selectData[i].get('DrawInvId');
                    array1[i] = selectData[i].get('OrderId');
                }
         
                //如果没有选择，就提示需要选择数据信息
                if (selectData == null || selectData == "") {
                    Ext.Msg.alert("提示", "请选中需要操作的记录！");
                    return;
                }
                                
                //页面提交
                Ext.Ajax.request({
                    url: 'frmDlvBack.aspx?method=save',
                    method: 'POST',
                    params: {
                        DrawInvId: array.join('-'),//传入多项的id串
                        OrderId: array1.join('-') //传入多项的id串
                    },
                    success: function(resp, opts) {
                        Ext.Msg.alert("提示", "数据生成成功！");
                        DrawInvGrid.getStore().reload();
                        
                    },
                    failure: function(resp, opts) {
                        Ext.Msg.alert("提示", "数据生成失败！");
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
                        labelWidth:70,
                        columnWidth:.33,
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
                        labelWidth:70,
                        columnWidth:.33,
                        items:[{
                            xtype:'textfield',
                            fieldLabel:'领货单编号',
                            anchor:'95%',
                            id:'DrawInvId',
                            name:'DrawInvId'
                        }]
                    },
                    {//第三单元格
                        layout:'form',
                        border: false,
                        labelWidth:70,
                        columnWidth:.34,
                        items:[{
                            xtype:'combo',
                            fieldLabel:'实物仓库',
                            anchor:'95%',
                            id:'OutStor',
                            name:'WhId',
                            store:dsWh,
                            triggerAction: 'all',
                            mode:'local',
                            editable:false,
                            displayField:'WhName',
                            valueField:'WhId'
                        }]
                    }
                ]
            },
            {//第二行
                layout:'column',
                items:[
                    {//第一单元格
                        layout:'form',
                        border: false,
                        labelWidth:70,
                        columnWidth:.33,
                        items:[{
                            xtype:'combo',
                            fieldLabel:'领货单类型',
                            anchor:'95%',
                            id:'DrawType',
                            name:'DrawType',
                            store:dsDrawType,
                            triggerAction: 'all',
                            mode:'local',
                            editable:false,
                            displayField:'DicsName',
                            valueField:'DicsCode'
                        }]
                    },
                    {//第二单元格
                        layout:'form',
                        border: false,
                        labelWidth:70,
                        columnWidth:.33,
                        items:[{
                            xtype:'datefield',
                            fieldLabel:'开始日期',
                            anchor:'95%',
                            id:'StartDate',
                            name:'StartDate',
                            format:'Y年m月d日',
                            value:new Date().clearTime(),
                            editable:false
                        }]
                    },
                    {//第三单元格
                        layout:'form',
                        border: false,
                        labelWidth:70,
                        columnWidth:.34,
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
                    }
                ]
            },
            {//第三行
                layout:'column',
                items:[
                    {//第一单元格
                        layout:'form',
                        border: false,
                        labelWidth:70,
                        columnWidth:.33,
                        items:[{
                             layout:'form',
                            border:false,
                            columnWidth:0.33,
                            html:'&nbsp'
                        }]
                    },
                    {//第二单元格
                        layout:'form',
                        border: false,
                        labelWidth:70,
                        columnWidth:.33,
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
                    },
                    {//第三单元格
                        layout:'form',
                        border: false,
                        labelWidth:70,
                        columnWidth:.34,
                        items:[
                            {
                                xtype:'button',
                                text:'删除',
                                width:70,
                                //iconCls:'excelIcon', 
                                scope:this,
                                handler:function(){
                                    delDrawInv();
                                }
                            }
                            ]
                    }
                ]
            }
        ]
    });
    /*-----------------------查询界面end------------------------*/
    
       
    
    
    /*------开始获取数据的函数 start---------------*/
                        var DrawInvGridData = new Ext.data.Store
                        ({
                            url: 'frmDlvBack.aspx?method=getDrawInvList',
                            reader: new Ext.data.JsonReader({
                                totalProperty: 'totalProperty',
                                root: 'root'
                            }, [
                                {
		                            name:'DrawInvId'
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
                            singleSelect: false
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
			                    id:'DrawInvId'
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
			                    id:'ControlDate',
			                    renderer: Ext.util.Format.dateRenderer('Y年m月d日')
		                    },
		                    {
			                    header:'数量',
			                    dataIndex:'TotalQty',
			                    id:'TotalQty'
		                    },
		                    {
			                    header:'订单ID',
			                    dataIndex:'OrderId',
			                    id:'OrderId'
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
                            height: 280,
                            closeAction: 'hide',
                            stripeRows: true,
                            loadMask: true,
                            autoExpandColumn: 2
                        });
                        DrawInvGrid.render();
                        /*------DataGrid的函数结束 End---------------*/



})

</script>

</html>

