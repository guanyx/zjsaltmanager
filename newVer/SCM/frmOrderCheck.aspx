<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmOrderCheck.aspx.cs" Inherits="SCM_frmOrderCheck" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html>
<head>
<title>�������</title><meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<link rel="stylesheet" type="text/css" href="../ext3/resources/css/ext-all.css" />
<script type="text/javascript" src="../ext3/adapter/ext/ext-base.js"></script>
<script type="text/javascript" src="../ext3/ext-all.js"></script>
<script type="text/javascript" src="../ext3/src/locale/ext-lang-zh_CN.js"></script>
<script type="text/javascript" src="js/frmOrderCheck.js"></script>
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
    
        /*------ʵ��toolbar�ĺ��� start---------------*/
        var Toolbar = new Ext.Toolbar({
            renderTo: "toolbar",
            items: [{
                text: "�鿴",
                icon: "../Theme/1/images/extjs/customer/add16.gif",
                handler: function() {  modifyOrderWin(); }
            }, '-',{
                text: "���",
                icon: "../Theme/1/images/extjs/customer/add16.gif",
                handler: function() { checkOrder() ; }
            }, '-',{
                text: "ȡ�����",
                icon: "../Theme/1/images/extjs/customer/add16.gif",
                handler: function() { cancelCheckOrder() ; }
            }]
            });
            /*------����toolbar�ĺ��� end---------------*/
            
            
            /*-----�༭Orderʵ���ര�庯��----*/
            function modifyOrderWin() {
                var sm = OrderMstGrid.getSelectionModel();
                //��ѡ
                var selectData = sm.getSelections();                
                var array = new Array(selectData.length);
                for(var i=0;i<selectData.length;i++)
                {
                    array[i] = selectData[i].get('OrderId');
                }

                //���û��ѡ�񣬾���ʾ��Ҫѡ��������Ϣ
                if (selectData == null || selectData == "") {
                    Ext.Msg.alert("��ʾ", "��ѡ����Ҫ�鿴�ļ�¼��");
                    return;
                }
                
                uploadOrderWindow.show();
                document.getElementById("editIFrame").src = "frmOrderDtl.aspx?Action=check&OpenType=query&id=" + array[0];
                
            }
            
            this.CancelCheck = function onCancelCheckOrder(orderId)
            {                
                //ҳ���ύ
                Ext.Ajax.request({
                    url: 'frmOrderCheck.aspx?method=cancelCheck',
                    method: 'POST',
                    params: {
                        OrderId: orderId//��������id��
                    },
                    success: function(resp, opts) {
                        Ext.Msg.alert("��ʾ", "������˳ɹ���");
                        OrderMstGrid.getStore().reload();
                        
                    },
                    failure: function(resp, opts) {
                        Ext.Msg.alert("��ʾ", "�������ʧ�ܣ�");
                    }
                });
            }
            
            this.ViewCommit=function onViewCheckOrder(orderId)
            {
                //ҳ���ύ
                Ext.Ajax.request({
                    url: 'frmOrderCheck.aspx?method=Check',
                    method: 'POST',
                    params: {
                        OrderId: orderId//��������id��
                    },
                    success: function(resp, opts) {
                        Ext.Msg.alert("��ʾ", "������˳ɹ���");
                        OrderMstGrid.getStore().reload();
                        
                    },
                    failure: function(resp, opts) {
                        Ext.Msg.alert("��ʾ", "�������ʧ�ܣ�");
                    }
                });
            }
            
            /*------��ʼ�������ݵĴ��� Start---------------*/
            if (typeof (uploadOrderWindow) == "undefined") {//�������2��windows����
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


            

            function cancelCheckOrder(){
                var sm = OrderMstGrid.getSelectionModel();
                //��ѡ
                var selectData = sm.getSelections();                
                var array = new Array(selectData.length);
                for(var i=0;i<selectData.length;i++)
                {
                    var status = selectData[i].get('Status');
                    if(status=='1')
                    {
                        Ext.Msg.alert('ϵͳ��ʾ',selectData[i].get('OrderNumber')+'��û����ˣ�����ȡ��');
                        return;
                    }
                    if(status!='2')
                    {
                        Ext.Msg.alert('ϵͳ��ʾ',selectData[i].get('OrderNumber')+'�Ѿ����뵽������̣�����ȡ�������Ҫȡ��������ɾ�������');
                        return;
                    }
                    array[i] = selectData[i].get('OrderId');
                }

                //���û��ѡ�񣬾���ʾ��Ҫѡ��������Ϣ
                if (selectData == null || selectData == "") {
                    Ext.Msg.alert("��ʾ", "��ѡ����Ҫ��˵ļ�¼��");
                    return;
                }
                
                //ҳ���ύ
                Ext.Ajax.request({
                    url: 'frmOrderCheck.aspx?method=cancelCheck',
                    method: 'POST',
                    params: {
                        OrderId: array.join('-')//��������id��
                    },
                    success: function(resp, opts) {
                        Ext.Msg.alert("��ʾ", "����ȡ����˳ɹ���");
                        OrderMstGrid.getStore().reload();
                        
                    },
                    failure: function(resp, opts) {
                        Ext.Msg.alert("��ʾ", "����ȡ�����ʧ�ܣ�");
                    }
                });
            }
            /*-----���Orderʵ�庯��----*/
            function checkOrder() {
                var sm = OrderMstGrid.getSelectionModel();
                //��ѡ
                var selectData = sm.getSelections();                
                var array = new Array(selectData.length);
                for(var i=0;i<selectData.length;i++)
                {
                    array[i] = selectData[i].get('OrderId');
                }

                //���û��ѡ�񣬾���ʾ��Ҫѡ��������Ϣ
                if (selectData == null || selectData == "") {
                    Ext.Msg.alert("��ʾ", "��ѡ����Ҫ��˵ļ�¼��");
                    return;
                }
                
                //ҳ���ύ
                Ext.Ajax.request({
                    url: 'frmOrderCheck.aspx?method=Check',
                    method: 'POST',
                    params: {
                        OrderId: array.join('-')//��������id��
                    },
                    success: function(resp, opts) {
                        Ext.Msg.alert("��ʾ", "������˳ɹ���");
                        OrderMstGrid.getStore().reload();
                        
                    },
                    failure: function(resp, opts) {
                        Ext.Msg.alert("��ʾ", "�������ʧ�ܣ�");
                    }
                });
            }
            function QueryDataGrid() {
                
                OrderMstGridData.baseParams.OrgId = Ext.getCmp('OrgId').getValue();
                OrderMstGridData.baseParams.DeptId = bm.getValue();
                OrderMstGridData.baseParams.OutStor = Ext.getCmp('OutStor').getValue();		                
                OrderMstGridData.baseParams.CustomerId = Ext.getCmp('CustomerId').getValue();
                OrderMstGridData.baseParams.IsPayed = Ext.getCmp('IsPayed').getValue();
                IsBill = Ext.getCmp('IsBill').getValue();		                
                OrderMstGridData.baseParams.OrderType = Ext.getCmp('OrderType').getValue();
                OrderMstGridData.baseParams.PayType = Ext.getCmp('PayType').getValue();
                OrderMstGridData.baseParams.BillMode = Ext.getCmp('BillMode').getValue();	                
                OrderMstGridData.baseParams.DlvType = Ext.getCmp('DlvType').getValue();
                OrderMstGridData.baseParams.DlvLevel = Ext.getCmp('DlvLevel').getValue();
                OrderMstGridData.baseParams.Status = Ext.getCmp('Status').getValue();	
                 OrderMstGridData.baseParams.IsActive = 1;                 
                OrderMstGridData.baseParams.StartDate = Ext.util.Format.date(Ext.getCmp('StartDate').getValue(),'Y/m/d');
                OrderMstGridData.baseParams.EndDate = Ext.util.Format.date(Ext.getCmp('EndDate').getValue(),'Y/m/d');
                OrderMstGridData.baseParams.BizType='ordercheck';
                OrderMstGridData.load({
                    params: {
                        start: 0,
                        limit: 10
                    }
                });
            }
            

              //�ֿ�
               var ck = new Ext.form.ComboBox({
                   xtype: 'combo',
                   store: dsWareHouse,
                   valueField: 'WhId',
                   displayField: 'WhName',
                   mode: 'local',
                   forceSelection: true,
                   editable: false,
                   name:'OutStor',
                   id:'OutStor',
                   emptyValue: '',
                   triggerAction: 'all',
                   fieldLabel: '�ֿ�',
                   selectOnFocus: true,
                   anchor: '90%',
                   editable:false
               });
               //���ͷ�ʽ
               var psfs = new Ext.form.ComboBox({
                   xtype: 'combo',
                   store: dsDlvType,
                   valueField: 'DicsCode',
                   displayField: 'DicsName',
                   mode: 'local',
                   forceSelection: true,
                   editable: false,
                   emptyValue: '',
                   triggerAction: 'all',
                   fieldLabel: '���ͷ�ʽ',
                    name:'DlvType',
                   id:'DlvType',
                   selectOnFocus: true,
                   anchor: '90%',
                   editable:false
               });               
               
               //��ʼ����
               var ksrq = new Ext.form.DateField({
           		    xtype:'datefield',
			        fieldLabel:'��ʼ����',
			        anchor:'90%',
			        name:'StartDate',
			        id:'StartDate',
			        format: 'Y��m��d��',  //���������ʽ
                    value:(new Date()).clearTime() 
               });
               
               //��������
               var jsrq = new Ext.form.DateField({
           		    xtype:'datefield',
			        fieldLabel:'��������',
			        anchor:'90%',
			        name:'EndDate',
			        id:'EndDate',
			        format: 'Y��m��d��',  //���������ʽ
                    value:(new Date()).clearTime()
               });
               
               //�ͻ��ȼ�
               var shdj = new Ext.form.ComboBox({
                   xtype: 'combo',
                   store: dsDlvLevel,
                   valueField: 'DicsCode',
                   displayField: 'DicsName',
                   mode: 'local',
                   forceSelection: true,
                   editable: false,
                   emptyValue: '',
                   triggerAction: 'all',
                   fieldLabel: '�ͻ��ȼ�',
                    name:'DlvLevel',
                   id:'DlvLevel',
                   selectOnFocus: true,
                   anchor: '90%',
                   editable:false
               });
               
               //���㷽ʽ
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
                   fieldLabel: '���㷽ʽ',
                   name:'PayType',
                   id:'PayType',
                   selectOnFocus: true,
                   anchor: '90%',
                   editable:false
               });
               //��Ʊ��ʽ
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
                   fieldLabel: '��Ʊ��ʽ',
                   name:'BillMode',
                   id:'BillMode',
                   selectOnFocus: true,
                   anchor: '90%',
                   editable:false
               });
                //��������
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
                   fieldLabel: '��������',
                   name:'OrderType',
                   id:'OrderType',
                   selectOnFocus: true,
                   anchor: '90%',
                   editable:false
               });
               
               //��˾������
               var gs = new Ext.form.ComboBox({
                    xtype:'combo',
                    fieldLabel:'��˾',
                    anchor:'90%',
                    name:'OrgId',
                    id:'OrgId',
                    store: dsOrg,
                    displayField: 'OrgName',  //����ֶκ�ҵ��ʵ�����ֶ�ͬ��
                    valueField: 'OrgId',      //����ֶκ�ҵ��ʵ�����ֶ�ͬ��
                    typeAhead: true, //�Զ�����һ����������ѡ�ȫ����
                    triggerAction: 'all',
                    emptyValue: '',
                    selectOnFocus: true,
                    forceSelection: true,
                    mode:'local',        //��������趨�ӱ�ҳ��ȡ����Դ�����ܹ���ֵ��λ
                    editable:false
               })
               
               //����������
               var bm = new Ext.form.ComboBox({
                    xtype:'combo',
                    fieldLabel:'����',
                    anchor:'90%',
                    name:'QryDeptID',
                    id:'QryDeptID',
                    store: dsDept,
                    displayField: 'DeptName',  //����ֶκ�ҵ��ʵ�����ֶ�ͬ��
                    valueField: 'DeptId',      //����ֶκ�ҵ��ʵ�����ֶ�ͬ��
                    typeAhead: true, //�Զ�����һ����������ѡ�ȫ����
                    triggerAction: 'all',
                    emptyValue: '',
                    selectOnFocus: true,
                    forceSelection: true,
                    mode:'local',        //��������趨�ӱ�ҳ��ȡ����Դ�����ܹ���ֵ��λ
                    editable:false
               })
               
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
			                items: [gs]
		                }
                ,		{
			                layout:'form',
			                border: false,
			                columnWidth:0.33,
			                items: [bm]
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
			                columnWidth:0.33,
			                items: [
				                {
					                xtype:'combo',
					                fieldLabel:'�Ƿ���',
					                columnWidth:0.33,
					                anchor:'90%',
					                store:[[1,'��'],[0,'��']],
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
					                fieldLabel:'�Ƿ�Ʊ',
					                columnWidth:0.33,
					                anchor:'90%',
					                store:[[1,'��'],[0,'��']],
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
		                labelSeparator: '��',
		                items: [
		                {
			                layout:'form',
			                border: false,
			                columnWidth:0.33,
			                items: [ddlx]
		                }
                ,		{
			                layout:'form',
			                border: false,
			                columnWidth:0.33,
			                items: [jsfs]
		                }
                ,		{
			                layout:'form',
			                border: false,
			                columnWidth:0.34,
			                items: [kpfs]
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
			                items: [psfs]
		                }
                ,		{
			                layout:'form',
			                border: false,
			                columnWidth:0.33,
			                items: [shdj]
		                }
                ,		{
			                layout:'form',
			                border: false,
			                columnWidth:0.34,
			                items: [
				                {
					                xtype:'combo',
					                fieldLabel:'״̬ ',
					                columnWidth:0.34,
					                anchor:'90%',
					                store:[[1,'δҵ�����'],[2,'ҵ�������']],
					                name:'Status',
					                id:'Status',
					                triggerAction:'all',
					                editable:false,
					                value:1
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
			                columnWidth:0.33,
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
		                    columnWidth:0.34,
		                    items: [{
				                    cls: 'key',
                                    xtype: 'button',
                                    text: '��ѯ',
                                    buttonAlign:'right',
                                    id: 'searchebtnId',
                                    anchor: '25%',
                                    handler: function() {QueryDataGrid();}
				                }]
		                }
	                ]}                  
                ]});


                        /*------��ʼ��ȡ���ݵĺ��� start---------------*/
                        var OrderMstGridData = new Ext.data.Store
                        ({
                            url: 'frmOrderCheck.aspx?method=getOrderList',
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
		                            name:'AuditName'
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

                        /*------��ȡ���ݵĺ��� ���� End---------------*/
var defaultPageSize = 10;
    var toolBar = new Ext.PagingToolbar({
        pageSize: 10,
        store: OrderMstGridData,
        displayMsg: '��ʾ��{0}����{1}����¼,��{2}��',
        emptyMsy: 'û�м�¼',
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
        emptyText: '����ÿҳ��¼��',
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
                        /*------��ʼDataGrid�ĺ��� start---------------*/

                        var sm = new Ext.grid.CheckboxSelectionModel({
                            singleSelect: false
                        });
                        var OrderMstGrid = new Ext.grid.GridPanel({
                            el: 'divDataGrid',
                            //width: '100%',
                            //height: '100%',
                            //autoWidth: true,
                            //autoHeight: true,
                            autoScroll: true,
                            layout: 'fit',
                            id: '',
                            store: OrderMstGridData,
                            loadMask: { msg: '���ڼ������ݣ����Ժ��' },
                            sm: sm,
                            cm: new Ext.grid.ColumnModel([
                            
		                    sm,
		                    new Ext.grid.RowNumberer(),//�Զ��к�
		                    {
			                    header:'������ʶ',
			                    dataIndex:'OrderId',
			                    id:'OrderId',
			                    width:100,
			                    hidden:true
		                    },
		                    {
			                    header:'�������',
			                    dataIndex:'OrderNumber',
			                    id:'OrderNumber',
			                    width:100
		                    },
//		                    {
//		                        header:'��˾����',
//			                    dataIndex:'OrgName',
//			                    id:'OrgName'
//		                    },
//		                    {
//		                        header:'���۲���',
//			                    dataIndex:'DeptName',
//			                    id:'DeptName'
//		                    },
		                    {
		                        header:'����ֿ�',
			                    dataIndex:'OutStorName',
			                    id:'OutStorName',
			                    width:80
		                    },
		                    {
		                        header:'�ͻ�����',
			                    dataIndex:'CustomerName',
			                    id:'CustomerName',
			                    width:160
		                    },
		                    {
			                    header:'�ͻ�����',
			                    dataIndex:'DlvDate',
			                    id:'DlvDate',
			                    renderer: Ext.util.Format.dateRenderer('Y��m��d��'),
			                    width:110
		                    },
		                    {
		                        header:'��������',
			                    dataIndex:'OrderTypeName',
			                    id:'OrderTypeName',
			                    width:60
		                    },
		                    {
		                        header:'���㷽ʽ',
			                    dataIndex:'PayTypeName',
			                    id:'PayTypeName',
			                    width:60
		                    },
		                    {
		                        header:'��Ʊ��ʽ',
			                    dataIndex:'BillModeName',
			                    id:'BillModeName',
			                    width:60
		                    },
		                    {
		                        header:'���ͷ�ʽ',
			                    dataIndex:'DlvTypeName',
			                    id:'DlvTypeName',
			                    width:60
		                    },
//		                    {
//		                        header:'�ͻ��ȼ�',
//			                    dataIndex:'DlvLevelName',
//			                    id:'DlvLevelName',
//			                    width:60
//		                    },
		                    {
			                    header:'������',
			                    dataIndex:'SaleTotalQty',
			                    id:'SaleTotalQty',
			                    width:60
		                    },
		                    {
			                    header:'�ܽ��',
			                    dataIndex:'SaleTotalAmt',
			                    id:'SaleTotalAmt',
			                    width:60
		                    },
		                    {
		                        header:'����Ա',
			                    dataIndex:'OperName',
			                    id:'OperName',
			                    width:60
		                    },
		                    {
		                        header:'���Ա',
			                    dataIndex:'AuditName',
			                    id:'AuditName',
			                    width:60
		                    },
		                    {
			                    header:'����ʱ��',
			                    dataIndex:'CreateDate',
			                    id:'CreateDate',
			                    renderer: Ext.util.Format.dateRenderer('Y��m��d��'),
			                    width:90
		                    },{
		                        header:'״̬',
			                    dataIndex:'StatusName',
			                    id:'StatusName',
			                    width:60
		                    },{
		                        header:'��ע',
			                    dataIndex:'Remark',
			                    id:'Remark',
			                    width:260
		                    }		]),
                            bbar: toolBar,
                            viewConfig: {
                                columnsText: '��ʾ����',
                                scrollOffset: 20,
                                sortAscText: '����',
                                sortDescText: '����',
                                forceFit: false
                            },
                            height: 300
//                            closeAction: 'hide',
//                            stripeRows: true,
//                            loadMask: true,
//                            autoExpandColumn: 2
                        });

						OrderMstGrid.on("afterrender", function(component) {
                            component.getBottomToolbar().refresh.hideParent = true;
                            component.getBottomToolbar().refresh.hide(); 
                        });

 //
                        OrderMstGrid.on('render', function(grid) {
                var store = grid.getStore();  // Capture the Store.  
                var view = grid.getView();    // Capture the GridView.
                OrderMstGrid.tip = new Ext.ToolTip({
                    target: view.mainBody,    // The overall target element.  
                    delegate: '.x-grid3-row', // Each grid row causes its own seperate show and hide.  
                    trackMouse: true,         // Moving within the row should not hide the tip.  
                    renderTo: document.body,  // Render immediately so that tip.body can be referenced prior to the first show.  
                    listeners: {              // Change content dynamically depending on which element triggered the show.  
                        beforeshow: function updateTipBody(tip) {
                            var rowIndex = view.findRowIndex(tip.triggerElement);
                            
                            var element = document.elementFromPoint(tip.x-20, tip.y-20);
                             var v = view.findCellIndex(element);
                                if(v==4||v==3||v==2)
                                {
                                    if(showTipRowIndex == rowIndex)
                                        return;
                                    else
                                        showTipRowIndex = rowIndex;
                                         tip.body.dom.innerHTML="���ڼ������ݡ���";
                                            //ҳ���ύ
                                            Ext.Ajax.request({
                                                url: 'frmOrderMst.aspx?method=getdetailinfo',
                                                method: 'POST',
                                                params: {
                                                    OrderId: grid.getStore().getAt(rowIndex).data.OrderId
                                                },
                                                success: function(resp, opts) {
                                                    tip.body.dom.innerHTML = resp.responseText;
                                                },
                                                failure: function(resp, opts) {
                                                    OrderMstGrid.tip.hide();
                                                }
                                            });
                                }                                
                                else
                                {
                                    OrderMstGrid.tip.hide();
                                }
                        }
                    }
                });
    });
    var showTipRowIndex =-1;
                        OrderMstGrid.render();
                        /*------DataGrid�ĺ������� End---------------*/
                        //QueryDataGrid();
        
                       gs.setValue(<% =ZJSIG.UIProcess.ADM.UIAdmUser.OrgID(this)%>);
                       gs.setDisabled(true);
                       bm.setValue(<% =ZJSIG.UIProcess.ADM.UIAdmUser.DeptID(this)%>);
                       bm.setDisabled(true);                       
QueryDataGrid();
                    })
</script>

</html>
