<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmAccountingQuery.aspx.cs" Inherits="SCM_frmAccountingQuery" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html>
<head>
<title>核算查询</title>
<meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<link rel="stylesheet" type="text/css" href="../ext3/resources/css/ext-all.css" />
<script type="text/javascript" src="../ext3/adapter/ext/ext-base.js"></script>
<script type="text/javascript" src="../ext3/ext-all.js"></script>
<link rel="stylesheet" type="text/css" href="../ext3/example/GroupSummary.css" />
<script type="text/javascript" src="../ext3/example/GroupSummary.js"></script>
<script type="text/javascript" src="../js/floatUtil.js"></script>
<script type="text/javascript" src="../ext3/src/locale/ext-lang-zh_CN.js"></script>
<script type="text/javascript" src="../../js/OrgsSelect.js"></script>

</head>
<body>
<div id='divSearchForm'></div>
<div id='divDataGrid'></div>
</body>
<%=getComboBoxStore()%>
<script type="text/javascript">
Ext.BLANK_IMAGE_URL = "../ext3/resources/images/default/s.gif";  
Ext.onReady(function() {
/****************************************************************/
    var dsWareHouse; 
    if (dsWareHouse == null) { //防止重复加载
        dsWareHouse = new Ext.data.JsonStore({
            totalProperty: "result",
            root: "root",
            url: 'frmOrderStatistics.aspx?method=getWhSimple',
            fields: ['WhId', 'WhName']
        });
        dsWareHouse.load();
    };

    function wareHouseLoad() {
        if (dsWareHouse.baseParams.OrgId != selectOrgIds) {
            dsWareHouse.baseParams.OrgId = selectOrgIds;
            dsWareHouse.baseParams.ForBusi = 1;
            dsWareHouse.load();
        }
    }
    wareHouseLoad();
/****************************************************************/

 var selectOrgIds = orgId;
        var ArriveOrgText = new Ext.form.TextField({
            fieldLabel: '公司',
            id: 'orgSelect',
            value: orgName
            //disabled:true
        });

        ArriveOrgText.on("focus", selectOrgType);
        function selectOrgType() {

            if (selectOrgForm == null) {
                var showType = "getcurrentandchildrentree";
                if (orgId == 1) {
                    showType = "getcurrentAndChildrenTreeByArea";
                }
                showOrgForm("", "", "../ba/sysadmin/frmAdmOrgList.aspx?method=" + showType);
                selectOrgForm.buttons[0].on("click", selectOrgOk);
                if (orgId == 1) {
                    selectOrgTree.on('checkchange', treeCheckChange, selectOrgTree);
                }
            }
            else {
                showOrgForm("", "", "");
            }
        }
        function selectOrgOk() {
            var selectOrgNames = "";
            selectOrgIds = "";
            var selectNodes = selectOrgTree.getChecked();
            for (var i = 0; i < selectNodes.length; i++) {
                if (selectNodes[i].id.indexOf("A") != -1)
                    continue;
                if (selectOrgNames != "") {
                    selectOrgNames += ",";
                    selectOrgIds += ",";
                }
                selectOrgIds += selectNodes[i].id;
                selectOrgNames += selectNodes[i].text;

            }
            if (selectOrgIds == '') {
                selectOrgIds = orgId;
                ArriveOrgText.setValue(orgName);
            }
            else {
                ArriveOrgText.setValue(selectOrgNames);
            }
            wareHouseLoad();

        }

        //允许单选
        function treeCheckChange(node, checked) {
            selectOrgTree.un('checkchange', treeCheckChange, selectOrgTree);
            if (checked) {
                var selectNodes = selectOrgTree.getChecked();
                for (var i = 0; i < selectNodes.length; i++) {
                    if (selectNodes[i].id != node.id) {
                        selectNodes[i].ui.toggleCheck(false);
                        selectNodes[i].attributes.checked = false;
                    }
                }
            }
            selectOrgTree.on('checkchange', treeCheckChange, selectOrgTree);
        }
        
    var searchOrderPanel = new  Ext.Panel({   
           frame: true,
           renderTo:'divSearchForm',
           buttonAlign:'center',
           monitorValid: true, // 把有formBind:true的按钮和验证绑定
           items:[
	       {
                layout:'column',
                border: false,
                items: [
                {
	                layout:'form',
	                border: false,
	                labelWidth: 55,
	                columnWidth:0.25,
	                items: [
		                ArriveOrgText
		            ]
		        }
                ,{
                    layout:'form',
                    border: false,
	                labelWidth: 55,
	                columnWidth:0.25,
                    items: [
	                {
	                   xtype: 'combo',
                       store: dsWareHouse,//dsWareHouse,
                       valueField: 'WhId',
                       displayField: 'WhName',
                       mode: 'local',
                       forceSelection: true,
                       editable: false,
                       name:'OutStor',
                       id:'OutStor',
                       emptyValue: '',
                       triggerAction: 'all',
                       fieldLabel: '仓库',
                       selectOnFocus: true,
                       anchor: '98%'
	                }]
		        },
		        {
	                layout:'form',
	                border: false,
	                labelWidth: 55,
	                columnWidth:0.25,
	                items: [
		            {
		                xtype: 'combo',
                       store: dsDlvType,
                       valueField: 'DicsCode',
                       displayField: 'DicsName',
                       mode: 'local',
                       forceSelection: true,
                       editable: false,
                       emptyValue: '',
                       triggerAction: 'all',
                       fieldLabel: '配送方式',
                       name:'DlvType',
                       id:'DlvType',
                       selectOnFocus: true,
                       anchor: '98%'
	                }]
                },
                {
	                layout:'form',
	                border: false,
	                labelWidth: 55,
	                columnWidth:0.25,
	                items: [
		            {
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
	                }]
                }]
		    },{
                layout:'column',
                border: false,
                items: [
                {
	                layout:'form',
	                border: false,
	                labelWidth: 55,
	                columnWidth:0.25,
	                items: [
		            {
			            xtype:'textfield',
	                    fieldLabel:'客户名称',
	                    anchor:'98%',
	                    name:'CustomerId',
	                    id:'CustomerId'
		            }]
                }		                
                ,{
	                layout:'form',
	                border: false,
	                labelWidth: 55,
	                columnWidth:0.25,
	                items: [
	                {
		                xtype:'textfield',
                        fieldLabel:'商品名称',
                        anchor:'98%',
                        name:'ProductName',
                        id:'ProductName'
	                }]
		        },
                {
	                layout:'form',
	                border: false,
	                labelWidth: 55,
	                columnWidth:0.25,
	                items: [
	                {
		                 xtype:'datefield',
                        fieldLabel:'开始日期',
                        anchor:'98%',
                        name:'StartDate',
                        id:'StartDate',
                        format:'Y年m月d日',
                        value:new Date().clearTime()
	                }]
                },
                {
	                layout:'form',
	                border: false,
	                labelWidth: 55,
	                columnWidth:0.25,
	                items: [
	                {
		               xtype:'datefield',
                        fieldLabel:'结束时间',
                        anchor:'98%',
                        name:'EndDate',
                        id:'EndDate',
                        format:'Y年m月d日',
                        value:new Date().clearTime()
	                }]
                }]
		    }],
		    buttons: [
		    {
			    text: "查询",
			    handler: function() {
				    selectSearchData();
			    }, 
			    scope: this
		    },
		    {
			    text: "重置", 
			    handler: function() { 
				    resetCondtion();
			    }, 
			    scope: this
		    }]
    });
    searchOrderPanel.render();
    function selectSearchData(){
        OrderSerachGridData.baseParams.OrgId =selectOrgIds;// Ext.getCmp('OrgId').getValue();
        OrderSerachGridData.baseParams.OutStor=Ext.getCmp('OutStor').getValue();		                
        OrderSerachGridData.baseParams.CustomerId=Ext.getCmp('CustomerId').getValue();   
        OrderSerachGridData.baseParams.ProductName=Ext.getCmp('ProductName').getValue();              
        OrderSerachGridData.baseParams.OrderType=Ext.getCmp('OrderType').getValue();		                
        OrderSerachGridData.baseParams.DlvType=Ext.getCmp('DlvType').getValue();               
        OrderSerachGridData.baseParams.StartDate=Ext.util.Format.date(Ext.getCmp('StartDate').getValue(),'Y/m/d');
        OrderSerachGridData.baseParams.EndDate=Ext.util.Format.date(Ext.getCmp('EndDate').getValue(),'Y/m/d');
        OrderSerachGridData.load({callback: function(records,o,s) {ToggleFirstGroup();} })//中调用函数把第一个group展开:
        
    }
    function resetCondtion(){
       
    }
    //添加默认项
    dsDlvType.insert(0, new Ext.data.Record({ 'DicsCode': '', 'DicsName': '全部' }, '-1'));
    Ext.getCmp('DlvType').setValue('');
    dsOrderType.insert(0, new Ext.data.Record({ 'DicsCode': '', 'DicsName': '全部' }, '-1'));    
    Ext.getCmp('OrderType').setValue(''); 
/****************************************************************/
    var OrderSerachGridData = new Ext.data.GroupingStore({
        url: 'frmAccountingQuery.aspx?method=getOrderList',
        reader: new Ext.data.JsonReader({
            totalProperty: 'totalProperty',
            root: 'root'
        }, [
            {name:'OrderId'  },
            {name:'OutStor' },
            {name:'OutStorName' },
            {name:'CustomerId'  },
            {name:'CustomerNo'  },
            {name:'CustomerName'},
            {name:'DlvDate' },
            {name:'DlvAdd'  },
            {name:'DlvDesc' },
            {name:'OrderType'   },
            {name:'OrderTypeName'},
            {name:'PayType'     },
            {name:'PayTypeName' },
            {name:'BillMode'    },
            {name:'BillModeName'},
            {name:'DlvType'     },
            {name:'DlvTypeName' },
            {name:'DlvLevel'    },
            {name:'DlvLevelName'},
            {name:'StatusName'  },
            {name:'IsPayed'     },
            {name:'IsPayedName' },
            {name:'IsBill'      },
            {name:'IsBillName'  },
            {name:'SaleInvId'   },
            {name:'SaleTotalQty'},
            {name:'OutedQty'    },
            {name:'SaleTotalAmt'},
            {name:'SaleTotalTax'},
            {name:'DtlCount'    },
            {name:'CreateDate'  },
            {name:'OwnerId'     },
            {name:'OwnerName'   },
            {name:'OperId'     },
            {name:'OperName'   },
            {name:'BizAudit'    },
            {name:'AuditDate'   },
            {name:'IsActive'    },
            {name:'IsActiveName'}	
            ]),
            sortInfo: {field: 'CreateDate', direction: 'ASC'},
            groupField: 'CustomerName'
    });         
    // utilize custom extension for Group Summary
    var summary = new Ext.ux.grid.GroupSummary();
    var OrderSerachGrid = new Ext.grid.EditorGridPanel({
        el: 'divDataGrid',
        width: '100%',
        height: '100%',
        autoWidth: true,
        autoHeight: true,
        autoScroll: true,
        layout: 'fit',
        id: '',
        store: OrderSerachGridData,
        loadMask: { msg: '正在加载数据，请稍侯……' },
        cm: new Ext.grid.ColumnModel([
        new Ext.grid.RowNumberer(),//自动行号
        {
            header:'订单标识',
            dataIndex:'OrderId',
            id:'OrderId'
        },
        {
            header:'客户编号',
            dataIndex:'CustomerNo',
            id:'CustomerNo',
            summaryType: 'count',
            hideable: false,
            summaryRenderer: function(v, params, data){
                return '共(' + v +')条订单';
            }
        },
        {
            header:'客户名称',
            dataIndex:'CustomerName',
            id:'CustomerName'
        },
        {
            header:'配送方式',
            dataIndex:'DlvTypeName',
            id:'DlvTypeName'
        },
        {
            header:'订单数量',
            dataIndex:'SaleTotalQty',
            id:'SaleTotalQty',
            summaryType: 'sum',
            summaryRenderer: function(v, params, data){  
                return Number(v).toFixed(2)+'吨'; //保留2位  
            }  
        },
        {
            header:'订单金额',
            dataIndex:'SaleTotalAmt',
            id:'SaleTotalAmt',
            summaryType: 'sum',
            summaryRenderer: function(v, params, data){  
                return Number(v).toFixed(2)+'元'; //保留2位  
            }  
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
            renderer: Ext.util.Format.dateRenderer('Y年m月d日'),
            summaryType: 'max'

        }		]),
        view: new Ext.grid.GroupingView({
            forceFit: true,
            showGroupName: false,
            enableNoGroups: false,
			enableGroupingMenu: false,
            hideGroupedColumn: true
        }),
        plugins: summary,
        closeAction: 'hide'
    });
       

    OrderSerachGrid.render();
/****************************************************************/
function ToggleFirstGroup()
{
    summary.toggleSummaries();//将所有行折叠
    var gridView = OrderSerachGrid.getView();
    var grNum = gridView.getGroups().length;
    if(grNum > 0)
    {
        var firstGroupID = gridView.getGroups()[grNum-1].id;
        if(firstGroupID && firstGroupID != "")
        {
            gridView.toggleGroup(firstGroupID);
        }
    }  
}

//var gs =Ext.getCmp('OrgId');
//gs.setValue(<% =ZJSIG.UIProcess.ADM.UIAdmUser.OrgID(this)%>);

//var curOrgId = Ext.getCmp('OrgId').getValue();
//dsWareHouse.load({
//    params: {
//        orgID: curOrgId
//    },
//    success: function(resp,opts){
//       
//    }
//});
// gs.setDisabled(true);

});
</script>
</html>
