<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmAchievementQuery.aspx.cs" Inherits="SCM_frmAchievementQuery" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html>
<head>
<title>ҵ����ѯ</title>
<meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<link rel="stylesheet" type="text/css" href="../ext3/resources/css/ext-all.css" />
<script type="text/javascript" src="../ext3/adapter/ext/ext-base.js"></script>
<script type="text/javascript" src="../ext3/ext-all.js"></script>
<link rel="stylesheet" type="text/css" href="../ext3/example/GroupSummary.css" />
<script type="text/javascript" src="../ext3/example/GroupSummary.js"></script>
<script type="text/javascript" src="../js/floatUtil.js"></script>
<script type="text/javascript" src="../js/ExtFix.js"></script>
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
    if (dsWareHouse == null) { //��ֹ�ظ�����
        dsWareHouse = new Ext.data.JsonStore({
            totalProperty: "result",
            root: "root",
            url: 'frmOrderStatistics.aspx?method=getWhSimple',
            fields: ['WhId', 'WhName']
        });
//        dsWareHouse.load();
     };
     
     function wareHouseLoad() {
        if (dsWareHouse.baseParams.OrgId != selectOrgIds) {
            dsWareHouse.baseParams.OrgId = selectOrgIds;
            dsWareHouse.baseParams.ForBusi = 1;
            dsWareHouse.load();
        }
    }
   var dsManagerStore = new Ext.data.JsonStore({
       url: 'frmAchievementQuery.aspx?method=getManagers',
       root: 'root',
       totalProperty: 'totalProperty',
       fields: ['EmpId','EmpName' ]
    });
    dsManagerStore.load({params:{start:0,limit:100}});
/****************************************************************/

var selectOrgIds = orgId;
        var ArriveOrgText = new Ext.form.TextField({
            fieldLabel: '��˾',
            id: 'orgSelect',
            value: orgName
            //disabled:true
        });
        
         wareHouseLoad();

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

        //����ѡ
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
           monitorValid: true, // ����formBind:true�İ�ť����֤��
           items:[
	       {
                layout:'column',
                border: false,
                items: [
                {
	                layout:'form',
	                border: false,
	                labelWidth: 55,
	                columnWidth:0.34,
	                items: [
		           ArriveOrgText]
		        }
                ,{
                    layout:'form',
                    border: false,
	                labelWidth: 55,
	                columnWidth:0.33,
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
                       fieldLabel: '�ֿ�',
                       selectOnFocus: true,
                       anchor: '98%'
	                }]
		        },
		        {
	                layout:'form',
	                border: false,
	                labelWidth: 55,
	                columnWidth:0.3,
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
                       fieldLabel: '���ͷ�ʽ',
                       name:'DlvType',
                       id:'DlvType',
                       selectOnFocus: true,
                       anchor: '98%'
	                }]
                }]
		    },
		    {
		        layout:'column',
                border: false,
                items: [  		                        
                {
	                layout:'form',
	                border: false,
	                labelWidth: 55,
	                columnWidth:0.6,
	                items: [
		            {
		                xtype: 'combo',
                       store: dsManagerStore,
                       valueField: 'EmpId',
                       displayField: 'EmpName',
                       mode: 'local',
                       forceSelection: true,
                       editable: false,
                       name:'ManagerId',
                       id:'ManagerId',
                       emptyValue: '',
                       triggerAction: 'all',
                       fieldLabel: '�ͻ�����',
                       selectOnFocus: true,
                       anchor: '98%'
//			            xtype:'textfield',
//	                    fieldLabel:'�ͻ�����',
//	                    anchor:'98%',
//	                    name:'ManagerName',
//	                    id:'ManagerName'
//		            },
//		            {
//			            xtype:'hidden',
//	                    fieldLabel:'�ͻ�����',
//	                    anchor:'98%',
//	                    name:'ManagerId',
//	                    id:'ManagerId'
		            }]
                },
                {
	                layout:'form',
	                border: false,
	                labelWidth: 80,
	                columnWidth:0.4,
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
                       fieldLabel: '��������',
                       name:'OrderType',
                       id:'OrderType',
                       selectOnFocus: true,
                       anchor: '90%',
				       editable:false
	                }]
                }]
            },
            {	
                layout:'column',
                border: false,
                items: [  
		        {
	                layout:'form',
	                border: false,
	                labelWidth: 55,
	                columnWidth:0.3,
	                items: [
	                {
		                 xtype:'datefield',
                        fieldLabel:'��ʼ����',
                        anchor:'98%',
                        name:'StartDate',
                        id:'StartDate',
                        format:'Y��m��d��',
                        value:new Date().clearTime()
	                }]
                },
                {
	                layout:'form',
	                border: false,
	                labelWidth: 55,
	                columnWidth:0.3,
	                items: [
	                {
		               xtype:'datefield',
                        fieldLabel:'����ʱ��',
                        anchor:'98%',
                        name:'EndDate',
                        id:'EndDate',
                        format:'Y��m��d��',
                        value:new Date().clearTime()
	                }]
                },
                {
	                layout:'form',
	                border: false,
	                labelWidth: 55,
	                columnWidth:0.1,
	                html:'&nbsp'
                },
                {
	                layout:'form',
	                border: false,
	                labelWidth: 55,
	                columnWidth:0.15,
	                items: [
	                {
		                xtype:'button',
                        text: "��ѯ",
			            handler: function() {
				            selectSearchData();
			            }
	                }]
                },
                {
	                layout:'form',
	                border: false,
	                labelWidth: 55,
	                columnWidth:0.15,
	                items: [
	                {
		                xtype:'button',
                        text: "����",
			            handler: function() {
				            selectSearchData();
			            }
	                }]
                },
                {
	                layout:'form',
	                border: false,
	                labelWidth: 55,
	                columnWidth:0.1,
	                html:'&nbsp'
                }]
		    }]
    });
    searchOrderPanel.render();
 

//    var searchSmallClass = new Ext.form.ComboBox({
//       store: dsManagerStore,
//       displayField: 'EmpName',
//       displayValue: 'EmpId',
//       typeAhead: false,
//       minChars: 1,
//       loadingText: 'Searching...',
//       //width: 200,  
//       pageSize: 10,
//       hideTrigger: true,
//       id: 'ManagerNameCombo',
//       applyTo: 'ManagerName',
//       onSelect: function(record) { // override default onSelect to do redirect  
//           Ext.getCmp('EmpName').setValue(record.data.EmpName);
//           Ext.getCmp('EmpId').setValue(record.data.EmpId);
//           this.collapse();
//       }
//   });
    
    function selectSearchData(){
        OrderSerachGridData.baseParams.OrgId =selectOrgIds;// Ext.getCmp('OrgId').getValue();
        OrderSerachGridData.baseParams.OutStor=Ext.getCmp('OutStor').getValue();		                
        OrderSerachGridData.baseParams.ManagerId=Ext.getCmp('ManagerId').getValue();                
        OrderSerachGridData.baseParams.OrderType=Ext.getCmp('OrderType').getValue();		                
        OrderSerachGridData.baseParams.DlvType=Ext.getCmp('DlvType').getValue();               
        OrderSerachGridData.baseParams.StartDate=Ext.util.Format.date(Ext.getCmp('StartDate').getValue(),'Y/m/d');
        OrderSerachGridData.baseParams.EndDate=Ext.util.Format.date(Ext.getCmp('EndDate').getValue(),'Y/m/d');
        OrderSerachGridData.load();
        
        OrderSerachGridData.on('load',function(store,records){  
            var totalQty = 0;
            var totalAmt = 0;
            store.each(function(rec)  
            {
                totalQty += rec.data.SaleQty;
                totalAmt += rec.data.SaleAmt;
            });  
            Ext.getCmp('TotalSaleQty').setValue(totalQty.toFixed(2) + ' ��');
            Ext.getCmp('TotalSaleAmt').setValue(totalAmt.toFixed(2) + ' Ԫ');
        }); 
    }
    function resetCondtion(){
       
    }
    //���Ĭ����
    dsDlvType.insert(0, new Ext.data.Record({ 'DicsCode': '', 'DicsName': 'ȫ��' }, '-1'));
    Ext.getCmp('DlvType').setValue('');
    dsOrderType.insert(0, new Ext.data.Record({ 'DicsCode': '', 'DicsName': 'ȫ��' }, '-1'));    
    Ext.getCmp('OrderType').setValue(''); 
/****************************************************************/
    var OrderSerachGridData = new Ext.data.GroupingStore({
        url: 'frmAchievementQuery.aspx?method=getOrderList',
        reader: new Ext.data.JsonReader({
            totalProperty: 'totalProperty',
            root: 'root'
        }, [
            {name:'OrderId'  },
            {name:'OrderDtlId' },
            {name:'ClassId' },
            {name:'ClassName'  },
            {name:'ProductId'  },
            {name:'ProductNo'},
            {name:'ProductName' },
            {name:'Specifications'  },
            {name:'SpecificationsName' },
            {name:'Unit'   },
            {name:'UnitName'},
            {name:'SaleQty'   ,mapping:'SaleQty',type:'float'  },
            {name:'SalePrice' },
            {name:'SaleAmt'   ,mapping:'SaleAmt',type:'float' },
            {name:'SaleTax'},
            {name:'CustomerId'     },
            {name:'CreateDate' },
            {name:'DlvDate'    },
            {name:'OrderType'},
            {name:'PayType'  },
            {name:'IsActive' },
            {name:'IsBill'      },
            {name:'OutStor'  },
            {name:'OperId'   },
            {name:'OperName'   },
            {name:'OrgId'     }
            ]),
            sortInfo: {field: 'CreateDate', direction: 'ASC'},
            groupField: 'OperName'
    });         
    // utilize custom extension for Group Summary
    var summary = new Ext.ux.grid.GroupSummary();
    var OrderSerachGrid = new Ext.grid.EditorGridPanel({
        region:'center',
        width: '100%',
        height: '100%',
        autoWidth: true,
        autoHeight: true,
        autoScroll: true,
        layout: 'fit',
        id: '',
        store: OrderSerachGridData,
        loadMask: { msg: '���ڼ������ݣ����Ժ��' },
        cm: new Ext.grid.ColumnModel([
        new Ext.grid.RowNumberer(),//�Զ��к�
        {
            header:'������ʶ',
            dataIndex:'OrderId',
            id:'OrderId'
        },
        {
            header:'��Ʒ���',
            dataIndex:'ProductNo',
            id:'ProductNo',
            summaryType: 'count',
            hideable: false,
            summaryRenderer: function(v, params, data){
                return '��(' + v +')������';
            }
        },
        {
            header:'��Ʒ����',
            dataIndex:'ClassName',
            id:'ClassName'
        },
        {
            header:'��λ',
            dataIndex:'UnitName',
            id:'UnitName'
        },
        {
            header:'���',
            dataIndex:'SpecificationsName',
            id:'SpecificationsName'
        },
        {
            header:'��������',
            dataIndex:'SaleQty',
            id:'SaleTotalQty',
            renderer:function(v){
                return v.toFixed(2);
            },
            summaryType: 'sum',
            summaryRenderer: function(v, params, data){  
                return Number(v).toFixed(2)+'��'; //����2λ  
            }  
        },
        {
            header:'�������',
            dataIndex:'SaleAmt',
            id:'SaleTotalAmt',
            renderer:function(v){
                return v.toFixed(2);
            },
            summaryType: 'sum',
            summaryRenderer: function(v, params, data){  
                return Number(v).toFixed(2)+'Ԫ'; //����2λ  
            }  
        },
        {
            header:'����ʱ��',
            dataIndex:'CreateDate',
            id:'CreateDate',
            renderer: Ext.util.Format.dateRenderer('Y��m��d��'),
            summaryType: 'max'
        },
        {
             header:'�ͻ�����',
             dataIndex:'OperName',
             id:'OperName',
             renderer:function(v){
                return '�ͻ�����'+ v;
            }
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
/****************************************************************/
    var saleToalForm = new Ext.form.FormPanel({
           region: 'north',
           frame: true,
           height:50,
           monitorValid: true, // ����formBind:true�İ�ť����֤��
           labelWidth: 70,
           items:[
           {
                layout:'column',
                border: false,
                items:[
                {
                   layout: 'form',
                   columnWidth: .45,  //����ռ�õĿ�ȣ���ʶΪ20��
                   border: false,
                   items: [{
                       cls: 'key',
                       xtype: 'textfield',
                       readOnly:true,
                       fieldLabel: '��������',
                       name: 'TotalSaleQty',
                       id: 'TotalSaleQty',
                       anchor: '98%'
                          }]
                } ,
                {
                   layout: 'form',
                   columnWidth: .45,  //����ռ�õĿ�ȣ���ʶΪ20��
                   border: false,
                   items: [{
                       cls: 'key',
                       xtype: 'textfield',
                       readOnly:true,
                       fieldLabel: '�����۽��',
                       name: 'TotalSaleAmt',
                       id: 'TotalSaleAmt',
                       anchor: '98%'
                   }]
                }]
             }]
           
         });
    var salequerypannel =  new Ext.Panel({
        el: 'divDataGrid',
        frame:true,
        width: '100%',
        height: '100%',
        layout:'form',
        items:[saleToalForm,OrderSerachGrid] 
    });
    salequerypannel.render();
/****************************************************************/

});
</script>

</html>
