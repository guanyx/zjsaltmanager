<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmSelfDlv.aspx.cs" Inherits="SCM_frmSelfDlv" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html>
<head>
<title>自提管理</title><meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<link rel="stylesheet" type="text/css" href="../ext3/resources/css/ext-all.css" />
<script type="text/javascript" src="../ext3/adapter/ext/ext-base.js"></script>
<script type="text/javascript" src="../ext3/ext-all.js"></script>
<script type="text/javascript" src="../ext3/src/locale/ext-lang-zh_CN.js"></script>
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
                text: "生成领货单",
                icon: "../Theme/1/images/extjs/customer/add16.gif",
                handler: function() { generSelfDraw() ; }
            }]
            });
            /*------结束toolbar的函数 end---------------*/

            
            /*-----审核Order实体函数----*/
            function generSelfDraw() {
                var sm = OrderMstGrid.getSelectionModel();
                //多选
                var selectData = sm.getSelections();                
                var array = new Array(selectData.length);
                for(var i=0;i<selectData.length;i++)
                {
                    array[i] = selectData[i].get('OrderId');
                }

                //如果没有选择，就提示需要选择数据信息
                if (selectData == null|| selectData.length == 0) {
                    Ext.Msg.alert("提示", "请选中需要生成领货单的订单记录！");
                    return;
                }
                
                //页面提交
                Ext.Ajax.request({
                    url: 'frmSelfDlv.aspx?method=gener',
                    method: 'POST',
                    params: {
                        OrderId: array.join('-')//传入多项的id串
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
            function QueryDataGrid() {
                OrderMstGridData.baseParams.OrgId = <% =ZJSIG.UIProcess.ADM.UIAdmUser.OrgID(this)%>;
                OrderMstGridData.baseParams.DeptId = <% =ZJSIG.UIProcess.ADM.UIAdmUser.DeptID(this)%>;
                OrderMstGridData.baseParams.OutStor=Ext.getCmp('OutStor').getValue();
                OrderMstGridData.baseParams.CustomerId=Ext.getCmp('CustomerId').getValue();
                OrderMstGridData.baseParams.IsPayed=Ext.getCmp('IsPayed').getValue();
                OrderMstGridData.baseParams.IsBill=Ext.getCmp('IsBill').getValue();
                OrderMstGridData.baseParams.OrderType=Ext.getCmp('OrderType').getValue();
                OrderMstGridData.baseParams.PayType=Ext.getCmp('PayType').getValue();
                OrderMstGridData.baseParams.BillMode=Ext.getCmp('BillMode').getValue();
                OrderMstGridData.baseParams.StartDate=Ext.util.Format.date(Ext.getCmp('StartDate').getValue(),'Y/m/d');
                OrderMstGridData.baseParams.EndDate=Ext.util.Format.date(Ext.getCmp('EndDate').getValue(),'Y/m/d');
                OrderMstGridData.load({
                    params: {
                        start: 0,
                        limit: 10
                    }
                });
            }
            

              //仓库
               var ck = new Ext.form.ComboBox({
                   xtype: 'combo',
                   store: dsWareHouse,
                   valueField: 'WhId',
                   displayField: 'WhName',
                   mode: 'local',
                   forceSelection: true,
                   name:'OutStor',
                   id:'OutStor',
                   emptyValue: '',
                   triggerAction: 'all',
                   fieldLabel: '仓库',
                   selectOnFocus: true,
                   anchor: '90%',
                   editable:false
               });
               
               
               //开始日期
               var ksrq = new Ext.form.DateField({
           		    xtype:'datefield',
			        fieldLabel:'开始日期',
			        anchor:'90%',
			        name:'StartDate',
			        id:'StartDate',
			        format: 'Y年m月d日',  //添加中文样式
                    value:(new Date()).clearTime() 
               });
               
               //结束日期
               var jsrq = new Ext.form.DateField({
           		    xtype:'datefield',
			        fieldLabel:'结束日期',
			        anchor:'90%',
			        name:'EndDate',
			        id:'EndDate',
			        format: 'Y年m月d日',  //添加中文样式
                    value:(new Date()).clearTime()
               });
               
               
               //结算方式
               var jsfs = new Ext.form.ComboBox({
                   xtype: 'combo',
                   store:dsBillMode,
                   valueField: 'DicsCode',
                   displayField: 'DicsName',
                   mode: 'local',
                   forceSelection: true,
                   editable: false,
                   emptyValue: '',
                   triggerAction: 'all',
                   fieldLabel: '结算方式',
                   name:'PayType',
                   id:'PayType',
                   selectOnFocus: true,
                   anchor: '90%',
                   editable:false
               });
               //开票方式
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
                   fieldLabel: '开票方式',
                   name:'BillMode',
                   id:'BillMode',
                   selectOnFocus: true,
                   anchor: '90%',
                   editable:false
               });
                //订单类型
                var ddlx = new Ext.form.ComboBox({
                   xtype: 'combo',
                   store: dsOrderType,
                   valueField: 'DicsCode',
                   displayField: 'DicsName',
                   mode: 'local',
                   forceSelection: true,
                   editable: false,
                   emptyValue: '',
                   triggerAction: 'all',
                   fieldLabel: '订单类型',
                   name:'OrderType',
                   id:'OrderType',
                   selectOnFocus: true,
                   anchor: '90%',
                   editable:false
               });
               
              
               
               var serchform = new Ext.FormPanel({
                    renderTo: 'divSearchForm',
                    labelAlign: 'left',
//                    layout: 'fit',
                    buttonAlign: 'center',
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
			                items: [{
					                xtype:'textfield',
					                fieldLabel:'客户',
					                columnWidth:0.33,
					                anchor:'90%',
					                name:'CustomerId',
					                id:'CustomerId'
				                }]
		                }
                ,		{
			                layout:'form',
			                border: false,
			                columnWidth:0.33,
			                items: [ddlx]
		                }
                ,		{
			                layout:'form',
			                border: false,
			                columnWidth:0.34,
			                items: [ck]
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
			                items: [jsfs]
		                }		                
                ,		{
			                layout:'form',
			                border: false,
			                columnWidth:0.33,
			                items: [
				                {
					                xtype:'combo',
					                fieldLabel:'是否结款',
					                columnWidth:0.33,
					                anchor:'90%',
					                store:[[1,'是'],[0,'否']],
					                name:'IsPayed',
					                id:'IsPayed',
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
					                xtype:'combo',
					                fieldLabel:'是否开票',
					                columnWidth:0.33,
					                anchor:'90%',
					                store:[[1,'是'],[0,'否']],
					                name:'IsBill',
					                id:'IsBill',
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
			                items: [{
					                xtype:'datefield',
					                fieldLabel:'开始日期',
					                columnWidth:0.5,
					                anchor:'90%',
					                name:'StartDate',
					                id:'StartDate',
					                value:new Date().clearTime(),
					                format:'Y年m月d日'
				                }]
		                }
                ,		{
			                layout:'form',
			                border: false,
			                columnWidth:0.33,
			                items: [{
					                xtype:'datefield',
					                fieldLabel:'结束日期',
					                columnWidth:0.5,
					                anchor:'90%',
					                name:'EndDate',
					                id:'EndDate',
					                value:new Date().clearTime(),
					                format:'Y年m月d日'
				                }]
		                }
                ,		{
			                layout:'form',
			                border: false,
			                columnWidth:0.34,
			                items: [kpfs]
		                }
	                ]}   
                ],
                buttons: [{
                    id: 'searchebtnId',
                    text: '查询',
                    handler: function() {QueryDataGrid();}
                }]
            });


                        /*------开始获取数据的函数 start---------------*/
                        var OrderMstGridData = new Ext.data.Store
                        ({
                            url: 'frmSelfDlv.aspx?method=getOrderList',
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
                            el: 'divDataGrid',
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
		                    {
		                        header:'公司名称',
			                    dataIndex:'OrgName',
			                    id:'OrgName'
		                    },
		                    {
		                        header:'销售部门',
			                    dataIndex:'DeptName',
			                    id:'DeptName'
		                    },
		                    {
		                        header:'出库仓库',
			                    dataIndex:'OutStorName',
			                    id:'OutStorName'
		                    },
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
		                    {
		                        header:'订单类型',
			                    dataIndex:'OrderTypeName',
			                    id:'OrderTypeName'
		                    },
		                    {
		                        header:'结算方式',
			                    dataIndex:'PayTypeName',
			                    id:'PayTypeName'
		                    },
		                    {
		                        header:'开票方式',
			                    dataIndex:'BillModeName',
			                    id:'BillModeName'
		                    },
		                    {
		                        header:'配送方式',
			                    dataIndex:'DlvTypeName',
			                    id:'DlvTypeName'
		                    },
		                    {
		                        header:'送货等级',
			                    dataIndex:'DlvLevelName',
			                    id:'DlvLevelName'
		                    },
		                    {
			                    header:'订货总数量',
			                    dataIndex:'SaleTotalQty',
			                    id:'SaleTotalQty'
		                    },
		                    {
			                    header:'订货总金额',
			                    dataIndex:'SaleTotalAmt',
			                    id:'SaleTotalAmt'
		                    },
		                    {
		                        header:'操作员',
			                    dataIndex:'OperName',
			                    id:'OperName'
		                    },
		                    {
			                    header:'创建时间',
			                    dataIndex:'CreateDate',
			                    id:'CreateDate',
			                    renderer: Ext.util.Format.dateRenderer('Y年m月d日')
//		                    },
		                    }		]),
                            bbar: new Ext.PagingToolbar({
                                pageSize: 10,
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
                        QueryDataGrid();
        
                    })
</script>

</html>

