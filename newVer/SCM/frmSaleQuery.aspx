<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmSaleQuery.aspx.cs" Inherits="SCM_frmSaleQuery" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html>
<head>
<title>���۲�ѯ</title>
<meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<link rel="stylesheet" type="text/css" href="../ext3/resources/css/ext-all.css" />
<script type="text/javascript" src="../ext3/adapter/ext/ext-base.js"></script>
<script type="text/javascript" src="../ext3/ext-all.js"></script>
<link rel="stylesheet" type="text/css" href="../ext3/example/GroupSummary.css" />
<script type="text/javascript" src="../ext3/example/GroupSummary.js"></script>
<script type="text/javascript" src="../js/floatUtil.js"></script>
<script type="text/javascript" src="../ext3/src/locale/ext-lang-zh_CN.js"></script>
<script type="text/javascript" src="../js/ProductSelect.js"></script>
<script type="text/javascript" src="../js/OrgsSelect.js"></script>
<script type="text/javascript" src="../../js/RouteSelect.js"></script>
<script type="text/javascript" src="../js/FilterControl.js"></script>
<script type="text/javascript" src="../js/getExcelXml.js"></script>
</head>
<body>
<div id="searchForm"></div>
<div id='divSearchForm'></div>
<div id='divDataGrid'></div>
</body>
<%=getComboBoxStore()%>
<script type="text/javascript">
function getCmbStore(columnName)
{
    switch(columnName)
    {
        case"OutStor":
            return dsWareHouse;
        case"DlvType":
            return dsDlvType;
        case"OrderType":
            return dsOrderType;
        default:
            return null;
    }
}
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
        dsWareHouse.load();
     };
     
/**************��˾��Ϣѡ�� **************************/
var selectOrgIds = orgId;
    var ArriveOrgText = new Ext.form.TextField({
        fieldLabel: '��˾',
        id: 'orgSelect',
        value: orgName,
        anchor: '95%',
        style: 'margin-left:0px',
        disabled: true
    });

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
        ArriveOrgText.setValue(selectOrgNames);
        dsWareHouse.load({ params: { OrgId: selectOrgIds, ForBusi: 1} });
    }
    dsWareHouse.load({ params: { OrgId: selectOrgIds, ForBusi: 1} });


    function treeCheckChange(node, checked) {
        node.expand();
        node.attributes.checked = checked;
        node.eachChild(function(child) {
            child.ui.toggleCheck(checked);
            child.attributes.checked = checked;
            child.fireEvent('checkchange', child, checked);
        });
        selectOrgTree.un('checkchange', treeCheckChange, selectOrgTree);
        checkParentNode(node);
        selectOrgTree.on('checkchange', treeCheckChange, selectOrgTree);
    }
    function checkParentNode(currentNode) {
        if (currentNode.parentNode != null) {
            var tempNode = currentNode.parentNode;
            //����Ǹ��ڵ㣬�Ͳ���������
            if (tempNode.parentNode == null)
                return;
            //�����ѡ���ˣ���ô���ڵ�Ҳ�����ǳ���ѡ��״̬��
            if (currentNode.attributes.checked) {
                if (!tempNode.attributes.checked) {
                    tempNode.fireEvent('checkchange', tempNode, true);
                    tempNode.ui.toggleCheck(true);
                    tempNode.attributes.checked = true;

                }
            }
            //ȡ��ѡ��
            else {
                var tempCheck = false;
                tempNode.eachChild(function(child) {
                    if (child.attributes.checked) {
                        tempCheck = true;
                        return;
                    }
                });
                if (!tempCheck) {
                    tempNode.fireEvent('checkchange', tempNode, false);
                    tempNode.ui.toggleCheck(false);
                    tempNode.attributes.checked = false;
                }

            }
            checkParentNode(tempNode);
        }
    }
    function parentNodeChecked(node) {
        if (node.parentNode != null) {
            if (node.attributes.checked) {
                node.parentNode.ui.toggleCheck(checked);
                node.parentNode.attributes.checked = true;
            }
            else {
                for (var i = 0; i < node.parentNode.childNodes.length; i++) {
                    if (node.parentNode.childNodes[i].attributes.checked) {
                        return;
                    }
                }
            }
            parentNodeChecked(node.parentNode);
        }
    }
/****************************************************************/
//    var searchOrderPanel = new  Ext.Panel({   
//           frame: true,
//           renderTo:'divSearchForm',
//           buttonAlign:'center',
//           monitorValid: true, // ����formBind:true�İ�ť����֤��
//           items:[
//	       {
//                layout:'column',
//                border: false,
//                items: [
//                {
//	                layout:'form',
//	                border: false,
//	                labelWidth: 55,
//	                columnWidth:0.27,
//	                items: [
//		                ArriveOrgText
//		            ]
//		        }, {
//                    layout: 'form',
//                    columnWidth: .03,  //����ռ�õĿ�ȣ���ʶΪ20��
//                    border: false,
//                    items: [
//                   {
//                       xtype: 'button',
//                       iconCls: "find",
//                       autoWidth: true,
//                       autoHeight: true,
//                       hideLabel: true,
//                       listeners: {
//                           click: function(v) {
//                               selectOrgType();
//                           }
//                       }
//}]
//                }
//                ,{
//                    layout:'form',
//                    border: false,
//	                labelWidth: 55,
//	                columnWidth:0.3,
//                    items: [
//	                {
//	                   xtype: 'combo',
//                       store: dsWareHouse,//dsWareHouse,
//                       valueField: 'WhId',
//                       displayField: 'WhName',
//                       mode: 'local',
//                       forceSelection: true,
//                       editable: false,
//                       name:'OutStor',
//                       id:'OutStor',
//                       emptyValue: '',
//                       triggerAction: 'all',
//                       fieldLabel: '�ֿ�',
//                       selectOnFocus: true,
//                       anchor: '98%'
//	                }]
//		        },
//		        {
//	                layout:'form',
//	                border: false,
//	                labelWidth: 55,
//	                columnWidth:0.3,
//	                items: [
//		            {
//		                xtype: 'combo',
//                       store: dsDlvType,
//                       valueField: 'DicsCode',
//                       displayField: 'DicsName',
//                       mode: 'local',
//                       forceSelection: true,
//                       editable: false,
//                       emptyValue: '',
//                       triggerAction: 'all',
//                       fieldLabel: '���ͷ�ʽ',
//                       name:'DlvType',
//                       id:'DlvType',
//                       selectOnFocus: true,
//                       anchor: '98%'
//	                }]
//                }]
//		    },{
//                layout:'column',
//                border: false,
//                items: [
//                {
//	                layout:'form',
//	                border: false,
//	                labelWidth: 55,
//	                columnWidth:0.27,
//	                items: [
//	                {
//		                xtype: 'textfield',
//                        fieldLabel: '�������',
//                        anchor: '98%',
//                        name: 'ProductType',
//                        id: 'ProductType',
//                        listeners: {
//                            blur: function(f) {
//                                if (f.getValue() == '')
//                                    Ext.getCmp("ProductTypeIds").setValue("");
//                            }
//                        }
//	                }, {
//		                xtype: 'hidden',
//		                name: 'ProductTypeIds',
//		                id: 'ProductTypeIds',
//		                anchor: '90%'
//                    }]
//                },
//                {
//                    layout: 'form',
//                    columnWidth: .03,  //����ռ�õĿ�ȣ���ʶΪ20��
//                    border: false,
//                    items: [
//                    {
//                        xtype: 'button',
//                        iconCls: "find",
//                        autoWidth: true,
//                        autoHeight: true,
//                        hideLabel: true,
//                        listeners: {
//                           click: function(v) {
//                               if (selectProductForm == null) {
//                                    parentUrl = "../CRM/product/frmBaProductClass.aspx?select=true&method=getbaproducttree";
//                                    showProductForm("", "", "", true);
//                                    selectProductForm.buttons[0].on("click", selectProductTypeOK);
//                                }
//                                else {
//                                    showProductForm("", "", "", true);
//                                }
//                           }
//                        }
//                    }]
//                },
//                {
//	                layout:'form',
//	                border: false,
//	                labelWidth: 55,
//	                columnWidth:0.3,
//	                items: [
//	                {
//		                 xtype:'datefield',
//                        fieldLabel:'��ʼ����',
//                        anchor:'98%',
//                        name:'StartDate',
//                        id:'StartDate',
//                        format:'Y��m��d��',
//                        value:new Date().clearTime()
//	                }]
//                },
//                {
//	                layout:'form',
//	                border: false,
//	                labelWidth: 55,
//	                columnWidth:0.3,
//	                items: [
//	                {
//		               xtype:'datefield',
//                        fieldLabel:'����ʱ��',
//                        anchor:'98%',
//                        name:'EndDate',
//                        id:'EndDate',
//                        format:'Y��m��d��',
//                        value:new Date().clearTime()
//	                }]
//                }]
//		    },{
//                layout:'column',
//                border: false,
//                items: [
//                {
//	                layout:'form',
//	                border: false,
//	                labelWidth: 55,
//	                columnWidth:0.27,
//	                items: [
//	                {
//		                xtype: 'textfield',
//                        fieldLabel: '��·',
//                        anchor: '98%',
//                        name: 'RouteName',
//                        id: 'RouteName',
//                        listeners: {
//                            blur: function(f) {
//                                if (f.getValue() == '')
//                                    Ext.getCmp("RouteId").setValue("");
//                            }
//                        }
//	                }, {
//		                xtype: 'hidden',
//		                name: 'RouteId',
//		                id: 'RouteId',
//		                anchor: '90%'
//                    }]
//                },
//                {
//                    layout: 'form',
//                    columnWidth: .03,  //����ռ�õĿ�ȣ���ʶΪ20��
//                    border: false,
//                    items: [
//                    {
//                        xtype: 'button',
//                        iconCls: "find",
//                        autoWidth: true,
//                        autoHeight: true,
//                        hideLabel: true,
//                        listeners: {
//                           click: function(v) {
//                               selectRoute(function(ids,names){                                    
//                                    document.getElementById('RouteName').value=names;
//                                    document.getElementById('RouteId').value=ids; 
//                               });
//                           }
//                        }
//                    }]
//                },
//                {
//	                layout:'form',
//	                border: false,
//	                labelWidth: 55,
//	                columnWidth:0.3,
//	                items: [
//		            {
//		                xtype:'textfield',
//                        fieldLabel:'��Ʒ',
//                        anchor:'98%',
//                        name:'ProductName',
//                        id: 'ProductName'
//                    }]
//                },
//                {
//	                layout:'form',
//	                border: false,
//	                labelWidth: 55,
//	                columnWidth:0.3,
//	                items: [
//		            {
//		                xtype: 'textfield',
//		                fieldLabel: '�ͻ�',
//		                anchor: '98%',
//		                name: 'CustomerName',
//		                id: 'CustomerName'
//                    }]
//	            }]
//		    }],
//		    buttons: [
//		    {
//			    text: "��ѯ",
//			    handler: function() {
//				    selectSearchData();
//			    }, 
//			    scope: this
//		    },
//		    {
//			    text: "����", 
//			    handler: function() { 
//				    resetCondtion();
//			    }, 
//			    scope: this
//		    },
//		    {
//			    text: "����(Excel)", 
//			    handler: function() { 
//				    exportExcel();
//			    }, 
//			    scope: this
//		    }]
//    });
//    var routetree = null;
//    var routediv = null;
//    var routeSelectWin = null;
//    function selectRoute() {
//        if (routediv == null) {
//            routediv = document.createElement('div');
//            routediv.setAttribute('id', 'routetreeDiv');
//            Ext.getBody().appendChild(routediv);
//        }
//        var Tree = Ext.tree;
//        if (routetree == null) {
//            routetree = new Tree.TreePanel({
//                el: 'routetreeDiv',
//                style: 'margin-left:0px',
//                useArrows: true, //�Ƿ�ʹ�ü�ͷ
//                autoScroll: true,
//                animate: true,
//                width: '150',
//                height: '100%',
//                minSize: 150,
//                maxSize: 180,
//                enableDD: false,
//                frame: true,
//                border: false,
//                containerScroll: true,
//                loader: new Tree.TreeLoader({
//                    dataUrl: '/crm/DefaultFind.aspx?method=getLineTreeByOrg&OrgId=<% =ZJSIG.UIProcess.ADM.UIAdmUser.OrgID(this)%>'
//                })
//            });
//            routetree.on('click', function(node) {
//                if (node.id == 0)//||!node.isLeaf()
//                    return;
//                Ext.getCmp('RouteId').setValue(node.id);
//                Ext.getCmp('RouteName').setValue(node.text);
//                routeSelectWin.hide();
//            });
//            // set the root node
//            var root = new Tree.AsyncTreeNode({
//                text: '��·���',
//                draggable: false,
//                id: '0'
//            });
//            routetree.setRootNode(root);
//        }
//        if (routeSelectWin == null) {
//            routeSelectWin = new Ext.Window({
//                title: '��·��Ϣ',
//                style: 'margin-left:0px',
//                width: 500,
//                height: 300,
//                constrain: true,
//                layout: 'fit',
//                plain: true,
//                modal: true,
//                closeAction: 'hide',
//                autoDestroy: true,
//                resizable: true,
//                items: [routetree]
//            });
//            routetree.root.reload();
//        }
//        routeSelectWin.show();
//    }
    
    function selectProductTypeOK()
    {        
        var selectProductNames = "";
        selectedProductIds = "";
        var selectNodes = selectProductTree.getChecked();
        for (var i = 0; i < selectNodes.length; i++) {
            if (selectProductNames != "") {
                selectProductNames += ",";
                selectedProductIds += ",";
            }
            selectProductNames += selectNodes[i].text;
            selectedProductIds +=  selectNodes[i].id + '!' + selectNodes[i].text + '!' + selectNodes[i].attributes.CustomerColumn;
        }
        currentSelect.setValue(selectProductNames);
        selectProductForm.hide();
//        Ext.getCmp("txtProductType").setValue(selectProductNames);
//        Ext.getCmp("ProductTypeIds").setValue(selectedProductIds);
    }
    
//    searchOrderPanel.render();
    function selectSearchData(){
        OrderSerachGridData.baseParams.OrgId = selectOrgIds;
        OrderSerachGridData.baseParams.OutStor=Ext.getCmp('OutStor').getValue();
        OrderSerachGridData.baseParams.DlvType = Ext.getCmp('DlvType').getValue();
        OrderSerachGridData.baseParams.ProductName = Ext.getCmp('ProductName').getValue();             
        OrderSerachGridData.baseParams.StartDate=Ext.util.Format.date(Ext.getCmp('StartDate').getValue(),'Y/m/d');
        OrderSerachGridData.baseParams.EndDate=Ext.util.Format.date(Ext.getCmp('EndDate').getValue(),'Y/m/d');
        OrderSerachGridData.baseParams.RouteId=Ext.getCmp('RouteId').getValue();
        OrderSerachGridData.baseParams.ProductType=Ext.getCmp('ProductTypeIds').getValue();
        OrderSerachGridData.baseParams.CustomerName=Ext.getCmp('CustomerName').getValue();
        OrderSerachGridData.load();
        
        
        
    }
    function resetCondtion(){
       
    }
    function exportExcel() {             
        //alert(json);      
        var _urls="frmSaleQuery.aspx?method=exportData";
        _urls += '&OrgId='+OrderSerachGridData.baseParams.OrgId;
        _urls += '&OutStor='+OrderSerachGridData.baseParams.OutStor;
        _urls += '&ProductName='+OrderSerachGridData.baseParams.ProductName;
        _urls += '&DlvType='+OrderSerachGridData.baseParams.DlvType;
        _urls += '&RouteId='+OrderSerachGridData.baseParams.RouteId;
        _urls += '&StartDate='+OrderSerachGridData.baseParams.StartDate;
        _urls += '&EndDate='+OrderSerachGridData.baseParams.EndDate;
        _urls += '&ProductType='+OrderSerachGridData.baseParams.ProductType;
        _urls += '&CustomerName='+OrderSerachGridData.baseParams.CustomerName;
         
        //check
        window.open(_urls,"");    
    }
    //���Ĭ����
//    dsDlvType.insert(0, new Ext.data.Record({ 'DicsCode': '', 'DicsName': 'ȫ��' }, '-1'));
//    Ext.getCmp('DlvType').setValue('');
    
/****************************************************************/
    var OrderSerachGridData = new Ext.data.GroupingStore({
        url: 'frmSaleQuery.aspx?method=getOrderList',
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
            {name:'SalePrice' ,mapping:'SalePrice',type:'float'  },
            {name:'SaleAmt'   ,mapping:'SaleAmt',type:'float' },
            {name:'SaleTax'},
            {name:'CustomerId'     },
            {name:'CustomerNo'     },
            {name:'ShortName'     },
            {name:'ChineseName'     },
            {name:'RouteNo'     },
            {name:'RouteName'     },
            {name:'CreateDate',type:'date' },
            {name:'BillDate',type:'date' },
            {name:'DlvDate'    },
            {name:'OrderType'},
            {name:'PayType'  },
            {name:'IsActive' },
            {name:'IsBill'      },
            {name:'OutStor'  },
            {name:'OperId'   },
            {name:'OrderNumber'   },
            {name:'OrgId'     }
            ]),
            sortInfo: {field: 'CreateDate', direction: 'ASC'},
            groupField: 'ClassName'
    });      
    
    OrderSerachGridData.on('load',function(store,records){  
            var totalQty = 0;
            var totalAmt = 0;
            store.each(function(rec)  
            {
                totalQty += rec.data.SaleQty;
                totalAmt += rec.data.SaleAmt;
            });  
            Ext.getCmp('TotalSaleQty').setValue(totalQty.toFixed(2));
            Ext.getCmp('TotalSaleAmt').setValue(totalAmt.toFixed(2) + ' Ԫ');
        });    
    // utilize custom extension for Group Summary
    var summary = new Ext.ux.grid.GroupSummary();
    var smOrder = new Ext.grid.CheckboxSelectionModel({
        singleSelect: true
    });
//    var tmpFunction = Ext.grid.GroupingView.prototype.initTemplates;
//    
//    Ext.grid.GroupingView.prototype.initTemplates = function(){
//            tmpFunction.call(this);
//            if(this.startGroup&&this.tplFunction){
//                    Ext.apply(this.startGroup,this.tplFunction);
//            }
//    };
    var OrderSerachGrid = new Ext.grid.EditorGridPanel({
        region:'center',
        //width: '100%',
        height: '100%',
        //autoWidth: true,
        //autoHeight: true,
        autoScroll: true,
        layout: 'fit',
        id: '',
        height: 300,
        store: OrderSerachGridData,
        loadMask: { msg: '���ڼ������ݣ����Ժ��' },
        sm: smOrder,
        cm: new Ext.grid.ColumnModel([
        //smOrder,
        //new Ext.grid.RowNumberer(),//�Զ��к�
        {
            header:'������ʶ',
            dataIndex:'OrderId',
            id:'OrderId',
            hidden:true
        },
        {
            header:'�������',
            dataIndex:'OrderNumber',
            id:'OrderNumber'
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
            id:'UnitName',
            width:60
        },
        {
            header:'���',
            dataIndex:'SpecificationsName',
            id:'SpecificationsName',
            width:60
        },
        {
            header:'��������',
            dataIndex:'SaleQty',
            id:'SaleTotalQty',
            width:100,
            renderer:function(v){
                return v.toFixed(2);
            },
            summaryType: 'sum',
            summaryRenderer: function(v, params, data){  
                return 'С�ƣ� '+Number(v).toFixed(2); //����2λ  
            }  
        },
        {
            header:'���۵���',
            dataIndex:'SalePrice',
            id:'SalePrice',
            width:100,
            renderer:function(v){
                return v.toFixed(6);
            }
        },
        {
            header:'�������',
            dataIndex:'SaleAmt',
            id:'SaleTotalAmt',
            width:120,
            renderer:function(v){
                return v.toFixed(2);
            },
            summaryType: 'sum',
            summaryRenderer: function(v, params, data){  
                return 'С�ƣ� '+Number(v).toFixed(2)+'Ԫ'; //����2λ  
            }  
        },
        {
            header:'����ʱ��',
            dataIndex:'CreateDate',
            id:'CreateDate',
            width:120,
            renderer: Ext.util.Format.dateRenderer('Y��m��d��'),
            summaryType: 'max'

        },
        {
            header:'��Ʊʱ��',
            dataIndex:'BillDate',
            id:'BillDate',
            width:120,
            renderer: Ext.util.Format.dateRenderer('Y��m��d��'),
            summaryType: 'max'

        },
        {
            header:'�ͻ����',
            dataIndex:'CustomerNo',
            id:'CustomerNo',
            width:60
        },
        {
            header:'�ͻ�����',
            dataIndex:'ChineseName',
            id:'ChineseName',
            width:200
        },
        {
            header:'��·����',
            dataIndex:'RouteName',
            id:'RouteName',
            width:120
        }
        ]),
        view: new Ext.grid.GroupingView({
            forceFit: false,
            showGroupName: false,
            enableNoGroups: false,
			enableGroupingMenu: false,
            hideGroupedColumn: true,
            sortAscText :'����',
            sortDescText :'����',
            columnsText:'����ʾ/����',
            groupByText:'�����з���',
            showGroupsText:'������ʾ'
//            groupTextTpl: '{text} ({["total��"]} '  +'{text:total}',
//            tplFunction :{
//              total : function(text,values){
//                var sum = 0;
//                if(values&&values.rs&&values.rs.length&&values.rs.length>0){
//                  for(var i=0;i<values.rs.length;i++){
//                    var record = values.rs[ i ];
//                    sum += record.get("SaleAmt");
//                  }
//                }
//                return sum;
//              }
//            }
        }),
        plugins: summary,
        closeAction: 'hide'
    });      
    
    createSearch(OrderSerachGrid, OrderSerachGridData, "searchForm");
    //setControlVisibleByField();
                    
    searchForm.el = "searchForm";
    searchForm.render();
    
    var addRow = new fieldRowPattern({
        id: 'RouteId',
        name: '��·��Ϣ',
        dataType: 'select'});
        fieldStore.add(addRow);
        
        addRow = new fieldRowPattern({
        id: 'OutStor',
        name: '�ֿ�',
        dataType: ''});
        fieldStore.add(addRow);
        
        addRow = new fieldRowPattern({
        id: 'OrderType',
        name: '��������',
        dataType: ''});
        fieldStore.add(addRow);
        
        addRow = new fieldRowPattern({
        id: 'DlvType',
        name: '��������',
        dataType: ''});
        fieldStore.add(addRow);
        
        addRow = new fieldRowPattern({
        id: 'ProductType',
        name: '��Ʒ���',
        dataType: 'select'});
        fieldStore.add(addRow);
        
txtFieldValue.on("focus", selectProductType);

function showProductType() {
   if (selectProductForm == null) {
        parentUrl = "../CRM/product/frmBaProductClass.aspx?select=true&method=getbaproducttree";
        showProductForm("", "", "", true);
        selectProductForm.buttons[0].on("click", selectProductTypeOK);
    }
    else {
        showProductForm("", "", "", true);
    }
    }

        function selectProductType() {
            switch (cmbField.getValue()) {
                case"RouteId":
                    currentSelect = txtFieldValue;
                    selectShow("RouteId");
                    break;
                case"ProductType":
                    currentSelect = txtFieldValue;
                    showProductType();
                    break;
            }
        }
        
  var selectedProductIds="";
        this.getSelectedValue = function(columnName) {
            switch (columnName) {
                case "ProductType":
                    return selectedProductIds;
                case "OrgId":
                    if (selectOrgIds == '1')
                        return "";
                    return selectOrgIds;
                case"RouteId":
                    return selectedRouteId;
            }
        }
        
        this.selectShow = function(columnName) {
            switch (columnName) {
                case"RouteId":
                    selectRoute();
                    break;
                case"ProductType":
                    showProductType();
                    break;
            }
        }
        
var routetree = null;
var routediv = null;
var routeSelectWin = null;
var selectedRouteId = '';
var fieldId = '';
function selectRoute()
{    
    selectedRouteId = '';
    fieldId = this.id;
    if(routediv == null){
        routediv = document.createElement('div');
        routediv.setAttribute('id', 'routetreeDiv');
        Ext.getBody().appendChild(routediv); 
    }
    var Tree = Ext.tree;    
    if( routetree == null){
        routetree = new Tree.TreePanel({
            el:'routetreeDiv',
            style: 'margin-left:0px',
            useArrows:true,//�Ƿ�ʹ�ü�ͷ
            autoScroll:true,
            animate:true,
            width:'150',
            height:'100%',
            minSize: 150,
	        maxSize: 180,
            enableDD:false,
            frame:true,
            border: false,
            containerScroll: true, 
            loader: new Tree.TreeLoader({
               dataUrl:'../crm/DefaultFind.aspx?method=getLineTreeByOrg&OrgId=<% =ZJSIG.UIProcess.ADM.UIAdmUser.OrgID(this)%>'
               })
        });
        routetree.on('click',function(node){  
            if(node.id ==0)//||!node.isLeaf()
                return;
            if(fieldId=='RouteName'){
                Ext.getCmp('RouteId').setValue(node.id);
                Ext.getCmp('RouteName').setValue(node.text);
            }else{
                selectedRouteId = node.id;
                currentSelect.setValue(node.text);
            }
            routeSelectWin.hide();
        }); 
        // set the root node
        var root = new Tree.AsyncTreeNode({
            text: '��·���',
            draggable:false,
            id:'0'
        });
        routetree.setRootNode(root);
    }    
    if( routeSelectWin == null){
        routeSelectWin = new Ext.Window({
             title:'��·��Ϣ',
             style: 'margin-left:0px',
             width:500 ,
             height:300, 
             constrain:true,
             layout: 'fit', 
             plain: true, 
             modal: true,
             closeAction: 'hide',
             autoDestroy :true,
             resizable:true,
             items: [routetree] 
        });
        routetree.root.reload();
    }
    routeSelectWin.show();    
}
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
    
    chbAdvanceSearch.setValue(true);
    cmbField.hide();
    Ext.getCmp('txtstartCreateDate').setValue(new Date().clearTime());
    Ext.getCmp('txtstartBillDate').setValue(new Date().clearTime());
    btnExpert.show();
/****************************************************************/
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
