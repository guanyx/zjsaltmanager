<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmDeliveryManager.aspx.cs" Inherits="SCM_frmDeliveryManager" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>配送管理</title>
    <link rel="stylesheet" type="text/css" href="../ext3/resources/css/ext-all.css" />
    <script type="text/javascript" src="../ext3/adapter/ext/ext-base.js"></script>
    <script type="text/javascript" src="../ext3/ext-all.js"></script>
    <script type="text/javascript" src="../ext3/src/locale/ext-lang-zh_CN.js"></script>
</head>
<body>    
    <div id="searchForm"></div>
    <div id="deliveryForm"></div>
    <div id="orderGrid"></div>
</body>

<!-- 所有数据源打印到这里 -->
<%= getComboBoxStore() %>

<script type="text/javascript">
Ext.BLANK_IMAGE_URL = "../ext3/resources/images/default/s.gif";  //作为：让下拉框的三角形下拉图片显示
Ext.onReady(function(){

        function QueryDataGrid() {                
                OrderMstGridData.load({
                    params: {
                        start: 0,
                        limit: 10,
                        OrgId:<% =ZJSIG.UIProcess.ADM.UIAdmUser.OrgID(this)%>,
		                DeptId:<% =ZJSIG.UIProcess.ADM.UIAdmUser.DeptID(this)%>,
		                OutStor:Ext.getCmp('OutStor').getValue(),		                
		                CustomerId:Ext.getCmp('CustomerId').getValue(),
		                OrderNo:Ext.getCmp('OrderNo').getValue(),
//		                IsPayed:Ext.getCmp('IsPayed').getValue(),
//		                IsBill:Ext.getCmp('IsBill').getValue(),		                
		                OrderType:Ext.getCmp('OrderType').getValue(),
		                PayType:Ext.getCmp('PayType').getValue(),
//		                BillMode:Ext.getCmp('BillMode').getValue(),	
		                DlvLevel:Ext.getCmp('DlvLevel').getValue(),		                             
		                StartDate:Ext.util.Format.date(Ext.getCmp('StartDate').getValue(),'Y/m/d'),
		                EndDate:Ext.util.Format.date(Ext.getCmp('EndDate').getValue(),'Y/m/d')
                    }
                });
            }
            
            /*-----save----*/
            function saveDrawInv() {
                var sm = OrderMstGrid.getSelectionModel();
                //多选
                var selectData = sm.getSelections();                
                var array = new Array(selectData.length);
                for(var i=0;i<selectData.length;i++)
                {
                    array[i] = selectData[i].get('OrderId');
                }

                //如果没有选择，就提示需要选择数据信息
                if (selectData == null || selectData == "") {
                    Ext.Msg.alert("提示", "请选中需要生成领货单的订单记录！");
                    return;
                }
                //输入参数前台判断
                var carcode = Ext.getCmp('VehicleId').getValue()
                if (carcode == null || carcode == "" ) {
                    Ext.Msg.alert("提示", "请选择送货车辆!");
                    return;
                }
                var DriverId = Ext.getCmp('DriverId').getValue()
                if (DriverId == null || DriverId == "" ) {
                    Ext.Msg.alert("提示", "请选择驾驶员！");
                    return;
                }
                
                //页面提交
                Ext.Ajax.request({
                    url: 'frmDeliveryManager.aspx?method=save',
                    method: 'POST',
                    params: {
                        OrderId: array.join('-'),//传入多项的id串
                        VehicleId:Ext.getCmp('VehicleId').getValue(),
                        DriverId:Ext.getCmp('DriverId').getValue(),
                        DlverId:Ext.getCmp('deliveryer').getValue(),
                        DlvDate:Ext.util.Format.date(Ext.getCmp('deliverydate').getValue(),'Y/m/d')
                    },
                    success: function(resp, opts) {
                        Ext.Msg.alert("提示", "数据生成成功！");
                        OrderMstGrid.getStore().reload();
                        
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
                        labelWidth:55,
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
                        labelWidth:55,
                        columnWidth:.33,
                        items:[{
                            xtype:'textfield',
                            fieldLabel:'订单编码',
                            anchor:'95%',
                            id:'OrderNo',
                            name:'OrderNo'
                        }]
                    },
                    {//第三单元格
                        layout:'form',
                        border: false,
                        labelWidth:55,
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
                        labelWidth:55,
                        columnWidth:.33,
                        items:[{
                            xtype:'combo',
                            fieldLabel:'订单类型',
                            anchor:'95%',
                            id:'OrderType',
                            name:'OrderType',
                            store:dsOrderType,
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
                        labelWidth:55,
                        columnWidth:.33,
                        items:[{
                            xtype:'combo',
                            fieldLabel:'结算方式',
                            anchor:'95%',
                            id:'PayType',
                            name:'PayType',
                            store:dsPayType,
                            triggerAction: 'all',
                            mode:'local',
                            editable:false,
                            displayField:'DicsName',
                            valueField:'DicsCode'
                        }]
                    },
                    {//第三单元格
                        layout:'form',
                        border: false,
                        labelWidth:55,
                        columnWidth:.34,
                        items:[{
                            xtype:'combo',
                            fieldLabel:'送货级别',
                            anchor:'95%',
                            id:'DlvLevel',
                            name:'DlvLevel',
                            store:dsDlvLevel,
                            triggerAction: 'all',
                            mode:'local',
                            editable:false,
                            displayField:'DicsName',
                            valueField:'DicsCode'
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
                        labelWidth:55,
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
                    {//第二单元格
                        layout:'form',
                        border: false,
                        labelWidth:55,
                        columnWidth:.33,
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
                        layout:'column',
                        border: false,
                        labelWidth:55,
                        columnWidth:.33,
                        buttonAlign:"center",
                        items:[
                       {
                            layout:'form',
                            border:false,
                            columnWidth:0.33,
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
                         {
                            layout:'form',
                            border:false,
                            columnWidth:0.33,
                            html:'&nbsp'
                        },
                        {
                            layout:'form',
                            border:false,
                            columnWidth:0.34,
                            html:'&nbsp'
                        }]
                    }
                ]
            }
        ]
    });
    /*-----------------------查询界面end------------------------*/
    
       
    /*-----------------------配送信息界面start------------------------*/
    var deliveryForm = new Ext.form.FormPanel({
        renderTo:'deliveryForm',
        frame:true,
        title:'调度信息录入',
        items:[
        {
            layout:'column',
            items:[
            {
                layout:'form',
                border:false,
                labelWidth:80,
                columnWidth:.3,
                items:[
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
                }]
            },
            {
                layout:'form',
                border:false,
                labelWidth:55,
                columnWidth:.3,
                items:[
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
                }]
            },
            {
                layout:'form',
                border:false,
                labelWidth:55,
                columnWidth:.3,
                items:[
                {
                    xtype:'datefield',
                    fieldLabel:'送货日期',
                    anchor:'95%',
                    id:'deliverydate',
                    name:'deliverydate',
                    format:'Y年m月d日',
                    value: new Date().clearTime(),
                    editable:false
                }]
            },
            {                
                layout:'form',
                border:false,
                columnWidth:0.1,
                items:[
                {
                    xtype:'button',
                    text:'保存',
                    width:70,
                    //iconCls:'excelIcon', 
                    scope:this,
                    handler:function(){
                        saveDrawInv()
                    }
                }]
            }]
        },
        {
            layout:'column',
            items:[
            {
                layout:'form',
                border:false,
                labelWidth:80,
                columnWidth:.33,
                items:[
                {
                    xtype:'hidden',
                    fieldLabel:'送货员',
                    anchor:'95%',
                    id:'deliveryer',
                    name:'deliveryer'
                }]
            },
            {
                layout:'form',
                border:false,
                labelWidth:55,
                columnWidth:.33,
                items:[
                {
                    xtype:'hidden',
                    fieldLabel:'调度人',
                    anchor:'95%',
                    id:'driverman',
                    name:'driverman'
                }]
            },
            {
                layout:'form',
                border:false,
                labelWidth:55,
                columnWidth:.34,
                items:[
                {
                    xtype:'hidden',
                    fieldLabel:'调度日期',
                    anchor:'95%',
                    id:'deliveryerdate',
                    name:'deliveryerdate',
                    format:'Y年m月d日',
                    value: new Date().clearTime(),
                    editable:false
                }]
            }]
        }]
    });

    /*-----------------------配送信息界面end------------------------*/
    
    /*------开始获取数据的函数 start---------------*/
                        var OrderMstGridData = new Ext.data.Store
                        ({
                            url: 'frmDeliveryManager.aspx?method=getOrderList',
                            reader: new Ext.data.JsonReader({
                                totalProperty: 'totalProperty',
                                root: 'root'
                            }, [
                                {
		                            name:'OrderId'
	                            },
	                            {
		                            name:'OrgId'
	                            },
	                            {
		                            name:'OrgName'
	                            },
	                            {
		                            name:'DeptId'
	                            },
	                            {
		                            name:'DeptName'
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
		                            name:'DlvDate'
	                            },
	                            {
		                            name:'DlvAdd'
	                            },
	                            {
		                            name:'DlvDesc'
	                            },
	                            {
		                            name:'OrderType'
	                            },
	                            {
		                            name:'OrderTypeName'
	                            },
	                            {
		                            name:'PayType'
	                            },
	                            {
		                            name:'PayTypeName'
	                            },
	                            {
		                            name:'BillMode'
	                            },
	                            {
		                            name:'BillModeName'
	                            },
	                            {
		                            name:'DlvType'
	                            },
	                            {
		                            name:'DlvTypeName'
	                            },
	                            {
		                            name:'DlvLevel'
	                            },
	                            {
		                            name:'DlvLevelName'
	                            },
	                            {
		                            name:'Status'
	                            },
	                            {
		                            name:'StatusName'
	                            },
	                            {
		                            name:'IsPayed'
	                            },
	                            {
		                            name:'IsPayedName'
	                            },
	                            {
		                            name:'IsBill'
	                            },
	                            {
		                            name:'IsBillName'
	                            },
	                            {
		                            name:'SaleInvId'
	                            },
	                            {
		                            name:'SaleTotalQty'
	                            },
	                            {
		                            name:'OutedQty'
	                            },
	                            {
		                            name:'SaleTotalAmt'
	                            },
	                            {
		                            name:'SaleTotalTax'
	                            },
	                            {
		                            name:'DtlCount'
	                            },
	                            {
		                            name:'OperId'
	                            },
	                            {
		                            name:'OperName'
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
		                            name:'OwnerName'
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
                            singleSelect: false
                        });
                        var OrderMstGrid = new Ext.grid.GridPanel({
                            el: 'orderGrid',
                            width: '100%',
                            height: '100%',
                            autoWidth: true,
                            autoHeight: true,
                            autoScroll: true,
                            layout: 'fit',
                            id: '',
                            store: OrderMstGridData,
                            loadMask: { msg: '正在加载数据，请稍侯……' },
                            sm: sm,
                            cm: new Ext.grid.ColumnModel([
                            
		                    sm,
		                    new Ext.grid.RowNumberer(),//自动行号
		                    {
			                    header:'订单标识',
			                    dataIndex:'OrderId',
			                    id:'OrderId'
		                    },
//		                    {
//			                    header:'公司标识',
//			                    dataIndex:'OrgId',
//			                    id:'OrgId'
//		                    },
		                    {
		                        header:'公司名称',
			                    dataIndex:'OrgName',
			                    id:'OrgName'
		                    },
//		                    {
//			                    header:'销售部门',
//			                    dataIndex:'DeptId',
//			                    id:'DeptId'
//		                    },
//		                    {
//		                        header:'销售部门',
//			                    dataIndex:'DeptName',
//			                    id:'DeptName'
//		                    },
//		                    {
//			                    header:'出库仓库',
//			                    dataIndex:'OutStor',
//			                    id:'OutStor'
//		                    },
		                    {
		                        header:'出库仓库',
			                    dataIndex:'OutStorName',
			                    id:'OutStorName'
		                    },
//		                    {
//			                    header:'客户标识',
//			                    dataIndex:'CustomerId',
//			                    id:'CustomerId'
//		                    },
		                    {
		                        header:'客户名称',
			                    dataIndex:'CustomerName',
			                    id:'CustomerName'
		                    },
		                    {
			                    header:'送货日期',
			                    dataIndex:'DlvDate',
			                    id:'DlvDate'
		                    },
//		                    {
//			                    header:'送货地点',
//			                    dataIndex:'DlvAdd',
//			                    id:'DlvAdd'
//		                    },
//		                    {
//			                    header:'送货描述',
//			                    dataIndex:'DlvDesc',
//			                    id:'DlvDesc'
//		                    },
//		                    {
//			                    header:'订单类型S011:电话订货、S012:短信订货、S013，网站订货 S014,普通订货',
//			                    dataIndex:'OrderType',
//			                    id:'OrderType'
//		                    },
		                    {
		                        header:'订单类型',
			                    dataIndex:'OrderTypeName',
			                    id:'OrderTypeName'
		                    },
//		                    {
//			                    header:'结算方式S021,现金结算 S022,网络结算',
//			                    dataIndex:'PayType',
//			                    id:'PayType'
//		                    },
		                    {
		                        header:'结算方式',
			                    dataIndex:'PayTypeName',
			                    id:'PayTypeName'
		                    },
//		                    {
//			                    header:'开票方式S031普通发票，S032增值税发票，S033收据小票',
//			                    dataIndex:'BillMode',
//			                    id:'BillMode'
//		                    },
		                    {
		                        header:'开票方式',
			                    dataIndex:'BillModeName',
			                    id:'BillModeName'
		                    },
//		                    {
//			                    header:'配送方式S041配送，S042自提',
//			                    dataIndex:'DlvType',
//			                    id:'DlvType'
//		                    },
		                    {
		                        header:'配送方式',
			                    dataIndex:'DlvTypeName',
			                    id:'DlvTypeName'
		                    },
//		                    {
//			                    header:'送货等级S051 普通  S052 紧急',
//			                    dataIndex:'DlvLevel',
//			                    id:'DlvLevel'
//		                    },
		                    {
		                        header:'送货等级',
			                    dataIndex:'DlvLevelName',
			                    id:'DlvLevelName'
		                    },
//		                    {
//			                    header:'状态 01 生成领货单 02 仓库出货',
//			                    dataIndex:'Status',
//			                    id:'Status'
//		                    },
//		                    {
//			                    dataIndex:'StatusName',
//			                    id:'StatusName'
//		                    },
//		                    {
//			                    header:'是否已结款',
//			                    dataIndex:'IsPayed',
//			                    id:'IsPayed'
//		                    },
//		                    {
//			                    dataIndex:'IsPayedName',
//			                    id:'IsPayedName'
//		                    },
//		                    {
//			                    header:'是否已开票',
//			                    dataIndex:'IsBill',
//			                    id:'IsBill'
//		                    },
//		                    {
//			                    dataIndex:'IsBillName',
//			                    id:'IsBillName'
//		                    },
//		                    {
//			                    header:'销售发票号',
//			                    dataIndex:'SaleInvId',
//			                    id:'SaleInvId'
//		                    },
		                    {
			                    header:'订货总数量',
			                    dataIndex:'SaleTotalQty',
			                    id:'SaleTotalQty'
		                    },
//		                    {
//			                    header:'已出货数量',
//			                    dataIndex:'OutedQty',
//			                    id:'OutedQty'
//		                    },
		                    {
			                    header:'订货总金额',
			                    dataIndex:'SaleTotalAmt',
			                    id:'SaleTotalAmt'
		                    },
//		                    {
//			                    header:'总税额',
//			                    dataIndex:'SaleTotalTax',
//			                    id:'SaleTotalTax'
//		                    },
//		                    {
//			                    header:'明细数',
//			                    dataIndex:'DtlCount',
//			                    id:'DtlCount'
//		                    },
//		                    {
//			                    header:'操作员',
//			                    dataIndex:'OperId',
//			                    id:'OperId'
//		                    },
		                    {
		                        header:'操作员',
			                    dataIndex:'OperName',
			                    id:'OperName'
		                    },
		                    {
			                    header:'创建时间',
			                    dataIndex:'CreateDate',
			                    id:'CreateDate',
			                    renderer: Ext.util.Format.dateRenderer('Y年m月d日'),
//		                    },
//		                    {
//			                    header:'修改时间',
//			                    dataIndex:'UpdateDate',
//			                    id:'UpdateDate'
//		                    },
//		                    {
//			                    header:'所有者',
//			                    dataIndex:'OwnerId',
//			                    id:'OwnerId'
//		                    },
//		                    {
//			                    dataIndex:'OwnerName',
//			                    id:'OwnerName'
//		                    },
//		                    {
//			                    header:'审核人',
//			                    dataIndex:'BizAudit',
//			                    id:'BizAudit'
//		                    },
//		                    {
//			                    header:'审核时间',
//			                    dataIndex:'AuditDate',
//			                    id:'AuditDate'
//		                    },
//		                    {
//			                    header:'备注',
//			                    dataIndex:'Remark',
//			                    id:'Remark'
//		                    },
//		                    {
//			                    header:'是否有效',
//			                    dataIndex:'IsActive',
//			                    id:'IsActive'
//		                    },
//		                    {
//			                    dataIndex:'IsActiveName',
//			                    id:'IsActiveName'
		                    }		]),
                            bbar: new Ext.PagingToolbar({
                                pageSize: 0,
                                store: OrderMstGridData,
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
                        OrderMstGrid.render();
                        /*------DataGrid的函数结束 End---------------*/



})

</script>

</html>
