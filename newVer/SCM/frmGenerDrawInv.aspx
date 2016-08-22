<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmGenerDrawInv.aspx.cs" Inherits="SCM_frmGenerDrawInv" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html>
<head>
<title>生成领货单</title><meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<link rel="stylesheet" type="text/css" href="../ext3/resources/css/ext-all.css" />
<script type="text/javascript" src="../ext3/adapter/ext/ext-base.js"></script>
<script type="text/javascript" src="../ext3/ext-all.js"></script>
<script type="text/javascript" src="../ext3/src/locale/ext-lang-zh_CN.js"></script>
<script type="text/javascript" src="../js/operateResp.js"></script>
<style type="text/css">
.x-date-menu {
   width: 175px;
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
        var DrawToolbar = new Ext.Toolbar({
            renderTo: "toolbar",
            items: [{
                text: "查看",
                icon: "../Theme/1/images/extjs/customer/add16.gif",
                handler: function() {  modifyOrderWin(); }
            }, '-',{
                text: "生成领货单",
                icon: "../Theme/1/images/extjs/customer/add16.gif",
                handler: function() { generDrawInv() ; }
            }
            , '-',{
		        text:"打印",
		        icon:"../Theme/1/images/extjs/customer/edit16.gif",
		        handler:function(){}
		    }]
            });
            /*------结束toolbar的函数 end---------------*/
            
            /*-----编辑Order实体类窗体函数----*/
            function modifyOrderWin() {
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
                    Ext.Msg.alert("提示", "请选中需要查看的记录！");
                    return;
                }
                
                uploadOrderWindow.show();
                document.getElementById("editIFrame").src = "frmOrderDtl.aspx?Action=create&OpenType=query&id=" + array[0];
            }
            
            this.ViewCommit=function onViewCheckOrder(orderId)
            {
                Ext.MessageBox.wait("数据正在提交，请稍候……");
                //页面提交
                Ext.Ajax.request({
                    url: 'frmGenerDrawInv.aspx?method=gener',
                    method: 'POST',
                    params: {
                        OrderId: orderId//传入多项的id串
                    },
                    success: function(resp, opts) {
                        Ext.MessageBox.hide();
                        if(checkExtMessage(resp))
                        {
                            OrderMstGrid.getStore().reload();
                        }                        
                    },
                    failure: function(resp, opts) {
                        Ext.MessageBox.hide();
                        Ext.Msg.alert("提示", "数据生成失败！");
                    }
                });
            }
            
            /*------开始界面数据的窗体 Start---------------*/
            if (typeof (uploadOrderWindow) == "undefined") {//解决创建2个windows问题
                uploadOrderWindow = new Ext.Window({
                    id: 'Orderformwindow',
                    iconCls: 'upload-win'
                    , width: 750
                    , height: 530
                    , plain: true
                    , modal: true
                    , constrain: true
                    , resizable: false
                    , closeAction: 'hide'
                    , autoDestroy: true
                    , html: '<iframe id="editIFrame" width="100%" height="100%" border=0 src="frmOrderDtl.aspx"></iframe>' 
                    
                });
            }
            

            
            /*-----审核Order实体函数----*/
            function generDrawInv() {
                Ext.MessageBox.wait("数据正在提交，请稍候……");
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
                    Ext.MessageBox.hide();
                    Ext.Msg.alert("提示", "请选中需要生成领货单的订单记录！");
                    return;
                }
                
                //页面提交
                Ext.Ajax.request({
                    url: 'frmGenerDrawInv.aspx?method=gener',
                    method: 'POST',
                    params: {
                        OrderId: array.join('-')//传入多项的id串
                    },
                    success: function(resp, opts) {
                        Ext.MessageBox.hide();
                        if(checkExtMessage(resp))
                        {
                            OrderMstGrid.getStore().reload();
                        }
                        
                    },
                    failure: function(resp, opts) {
                        Ext.MessageBox.hide();
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
                   editable:true
               });
               
               
               //开始日期
               var ksrq = new Ext.form.DateField({
           		    xtype:'datefield',
			        fieldLabel:'开始日期',
			        anchor:'90%',
			        name:'StartDate',
			        id:'StartDate',
			        format: 'Y年m月d日',  //添加中文样式
                    value:new Date().getFirstDateOfMonth().clearTime()
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
					                triggerAction:'all',
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
					                triggerAction:'all',
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
					                value:new Date().getFirstDateOfMonth().clearTime(),
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
                            url: 'frmGenerDrawInv.aspx?method=getOrderList',
                            reader: new Ext.data.JsonReader({
                                totalProperty: 'totalProperty',
                                root: 'root'
                            }, [
                                {
		                            name:'OrderId'
	                            },
	                            {
		                            name:'OrderNumber'
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
	                            },{
		                            name:'OrderNumber'
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
var defaultPageSize = 10;
    var toolBar = new Ext.PagingToolbar({
        pageSize: 10,
        store: OrderMstGridData,
        displayMsg: '显示第{0}条到{1}条记录,共{2}条',
        emptyMsy: '没有记录',
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
        emptyText: '更改每页记录数',
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
        toolBar.doLoad(0);
    }, toolBar);
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
			                    id:'OrderId',
			                    hidden:true
		                    },
		                    {
			                    header:'订单编号',
			                    dataIndex:'OrderNumber',
			                    id:'OrderNumber',
			                    width:80
		                    },
		                    {
		                        header:'公司名称',
			                    dataIndex:'OrgName',
			                    id:'OrgName',
			                    hidden:true
		                    },
		                    {
		                        header:'销售部门',
			                    dataIndex:'DeptName',
			                    id:'DeptName',
			                    hidden:true
		                    },
		                    {
		                        header:'出库仓库',
			                    dataIndex:'OutStorName',
			                    id:'OutStorName',
			                    width:60
		                    },
		                    {
		                        header:'客户名称',
			                    dataIndex:'CustomerName',
			                    id:'CustomerName',
			                    width:120
		                    },
		                    {
			                    header:'送货日期',
			                    dataIndex:'DlvDate',
			                    id:'DlvDate',
			                    width:60
		                    },
		                    {
		                        header:'订单类型',
			                    dataIndex:'OrderTypeName',
			                    id:'OrderTypeName',
			                    width:60
		                    },
		                    {
		                        header:'结算方式',
			                    dataIndex:'PayTypeName',
			                    id:'PayTypeName',
			                    hidden:true
		                    },
		                    {
		                        header:'开票方式',
			                    dataIndex:'BillModeName',
			                    id:'BillModeName',
			                    hidden:true
		                    },
		                    {
		                        header:'配送方式',
			                    dataIndex:'DlvTypeName',
			                    id:'DlvTypeName',
			                    width:60
		                    },
		                    {
		                        header:'送货等级',
			                    dataIndex:'DlvLevelName',
			                    id:'DlvLevelName',
			                    width:60			                 
		                    },
		                    {
			                    header:'订货总重量',
			                    dataIndex:'SaleTotalQty',
			                    id:'SaleTotalQty',
			                    width:60
		                    },
		                    {
			                    header:'订货总金额',
			                    dataIndex:'SaleTotalAmt',
			                    id:'SaleTotalAmt',
			                    width:60
		                    },
		                    {
		                        header:'操作员',
			                    dataIndex:'OperName',
			                    id:'OperName',
			                    width:80
		                    },
		                    {
			                    header:'创建时间',
			                    dataIndex:'CreateDate',
			                    id:'CreateDate',
			                    renderer: Ext.util.Format.dateRenderer('Y年m月d日'),
			                    width:60
//		                    },
		                    }		]),
                            bbar: toolBar,
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
                        OrderMstGrid.on("afterrender", function(component) {
                            component.getBottomToolbar().refresh.hideParent = true;
                            component.getBottomToolbar().refresh.hide(); 
                        });
                        OrderMstGrid.render();
                        /*------DataGrid的函数结束 End---------------*/
                        //QueryDataGrid();
        
                    })
</script>

</html>
