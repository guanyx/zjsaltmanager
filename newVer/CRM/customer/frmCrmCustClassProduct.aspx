<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmCrmCustClassProduct.aspx.cs" Inherits="CRM_customer_frmCrmCustClassProduct" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>���������Ʒ��Ӧ��ϵά��</title>
    <meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
    <link rel="stylesheet" type="text/css" href="../../ext3/resources/css/ext-all.css" />
	<script type="text/javascript" src="../../ext3/adapter/ext/ext-base.js"></script>	
	<script type="text/javascript" src="../../ext3/ext-all.js"></script>
</head>
<body>   
   <div id ='toolbar'></div>
   <div id = 'searchForm'></div>
   <div id ='GridPanel'></div>
   <div id ='tree-div'></div>
   <div id='productGrid'></div>
   <div id = 'productSearchForm'></div>
</body>
<script type="text/javascript">
Ext.BLANK_IMAGE_URL = "../../ext3/resources/images/default/s.gif";
Ext.onReady(function(){
var strCustomerId = 0;
var currentNodeId = 0;
/*------����toolbar start---------------*/
var Toolbar = new Ext.Toolbar({
        renderTo : "toolbar",
		items:[{
        text : "�����Ʒ����",
        icon: '../../Theme/1/images/extjs/customer/add16.gif', 
        handler : function(){
            cfgProductWin();//����󵯳�ԭ����Ϣ
		}
    }]
});
/*------����toolbar end ----------------*/
/*------�����ѯform start ----------------*/
var cusidPanel = new Ext.form.TextField({
    style: 'margin-left:0px',
    cls: 'key',
    xtype: 'textfield',
    fieldLabel: '�ͻ����',
    name: 'cusid',
    id:'search',
    anchor: '90%'
});


var namePanel = new Ext.form.TextField({
    style: 'margin-left:0px',
    cls: 'key',
    xtype: 'textfield',
    fieldLabel: '�ͻ�����',
    name: 'name',
    anchor: '90%'
});

var serchform = new Ext.FormPanel({
    renderTo: 'searchForm',
    labelAlign: 'left',
    layout:'fit',
    buttonAlign: 'right',
    bodyStyle: 'padding:5px',
    frame: true,
    labelWidth: 55,
    items: [{
        layout: 'column',   //�����Ԫ��Ϊ����Ϊ�в��ַ�ʽ
        border: false,
        items: [{
            columnWidth: .32,  //����ռ�õĿ�ȣ���ʶΪ20��
            layout: 'form',
            border: false,
            items: [
            cusidPanel
            ]
        }, {
            columnWidth: .33,
            layout: 'form',
            border: false,
            items: [
                namePanel
                ]
        }, {
            columnWidth: .10,
            layout: 'form',
            border: false,
            items: [{ cls: 'key',
                xtype: 'button',
                text: '��ѯ',
                anchor: '50%',
                handler :function(){                
                    var cusid=cusidPanel.getValue();
                    var name=namePanel.getValue();
                    
                    customerListStore.baseParams.CustomerNo = cusid;
                    customerListStore.baseParams.ChineseName = name;
                    customerListStore.load({
                                params : {
                                start : 0,
                                limit : 10
                                } 
                              }); 
                    }
                }]
        }]
    }]
});
/*------�����ѯform end ----------------*/
/*------�����б�Grid start ----------------*/
var customerListStore = new Ext.data.Store
	({
	    url: 'frmCrmCustClassProduct.aspx?method=getCustomers',
	    reader: new Ext.data.JsonReader({
	        totalProperty: 'totalProperty',
	        root: 'root'
	    }, [
	        { name: "CustomerId" },
	        { name: "ShortName" },
	        { name: "LinkMan" },
	        { name: "LinkTel" },
	        { name: "LinkMobile" },
	        { name: "Fax" },
	        { name: "DistributionTypeText" },
	        { name: "MonthQuantity" },
	        { name: "IsCust" },
	        { name: "IsProvide" },
	        { name: 'CreateDate'}
	    ])
	});
var sm= new Ext.grid.CheckboxSelectionModel(
{
    singleSelect : true,
    listeners: {
        rowselect: function(sm, row, rec) {
            strCustomerId = rec.data.CustomerId;
        }
    } 
});
var CustomerGrid = new Ext.grid.GridPanel({
        el: 'GridPanel',
        width:'100%',
        height:'100%',
        autoWidth:true,
        autoHeight:true,
        autoScroll:true,
        layout: 'fit',
        id: 'customerdatagrid',
        store: customerListStore,
        loadMask: {msg:'���ڼ������ݣ����Ժ��'},
        sm:sm,
        cm: new Ext.grid.ColumnModel([
        sm,
        new Ext.grid.RowNumberer(),//�Զ��к�
       { header: "�ͻ����",dataIndex: 'CustomerId' ,hidden:true},
       { header: "�ͻ�����",dataIndex: 'ShortName' },
       { header: "��ϵ��", dataIndex: 'LinkMan' },
       { header: "��ϵ�绰", dataIndex: 'LinkTel' },
       { header: "�ƶ��绰", dataIndex: 'LinkMobile' },
       { header: "����", dataIndex: 'Fax' },
       { header: "��������",dataIndex: 'DistributionTypeText' },
       { header: "������", dataIndex: 'MonthQuantity' },
       { header: "����", dataIndex: 'IsCust' ,renderer:{ fn:function(v){ if(v==1)return '��';return '��'}}},
       { header: "��Ӧ��", dataIndex: 'IsProvide',renderer:{ fn:function(v){ if(v==1)return '��';return '��'}}},
       { header: "����ʱ��", dataIndex: 'CreateDate' }//
       ]),
      bbar: new Ext.PagingToolbar({
        pageSize: 10,
        store: customerListStore,
        displayMsg: '��ʾ��{0}����{1}����¼,��{2}��',
        emptyMsy: 'û�м�¼',
        displayInfo: true
      }),
      viewConfig: {
        columnsText: '��ʾ����',
        scrollOffset: 20,
        sortAscText: '����',
        sortDescText: '����',
        forceFit: true
      },
      height: 280,
      closeAction: 'hide',
      stripeRows: true,
      loadMask: true,
      autoExpandColumn: 2
});
CustomerGrid.render();

/*------�����б�Grid end ----------------*/


/*------ʵ��tree�ĺ��� start---------------*/
Ext.BLANK_IMAGE_URL = "../../ext3/resources/images/default/s.gif";	
var Tree = Ext.tree;
var tree = new Tree.TreePanel({
    el:'tree-div',
    region:'west',
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
       dataUrl:'frmCrmCustClassProduct.aspx?method=gettreelist',
       baseParams:{
            CustomerId:strCustomerId
       }}),
    listeners : {  
        'beforeload' : function(node) { 
            tree.getLoader().baseParams.CustomerId = strCustomerId;
        }
    }
});
tree.on('click',function(node){  
    if(node.id ==0)
        return;
     refreshGrid(node.id);  
}); 
// set the root node
var root = new Tree.AsyncTreeNode({
    text: '�������',
    draggable:false,
    id:'0'
});
tree.setRootNode(root);

function refreshGrid(nodeId){
    currentNodeId = nodeId;
    productGridData.baseParams.CustomerId = strCustomerId;
    productGridData.baseParams.BuyClassId = currentNodeId;
    productGridData.load({
        params:{
               limit:10,
               start:0
	        }
    });
}
/*------����tree�ĺ��� end---------------*/
/*------��ʼ�����ò�Ʒ�б� start---------------*/
var productGridData;
if(productGridData==null){
    productGridData = new Ext.data.Store({
        url:"frmCrmCustClassProduct.aspx?method=getProducts",
        reader:new Ext.data.JsonReader({
            totalProperty:'totalProperty',
	        root:'root'},
	        [
	            {name:'ProductId'},
	            {name:'ProductNo'},
	            {name:'MnemonicNo'},
	            {name:'AliasNo'},
	            {name:'MobileNo'},
	            {name:'SpeechNo'},
	            {name:'NetPurchasesNo'},
	            {name:'LogisticsNo'},
	            {name:'BarCode'},
	            {name:'SecurityCode'},
	            {name:'ProductName'},
	            {name:'AliasName'},
	            {name:'Specifications'},
	            {name:'SpecificationsText'},
	            {name:'Unit'},
	            {name:'UnitText'},
	            {name:'SalePrice'},
	            {name:'SalePriceLower'},
	            {name:'SalePriceLimit'},
	            {name:'TaxWhPrice'},
	            {name:'TaxRate'},
	            {name:'Tax'},
	            {name:'SalesTax'},
	            {name:'UnitConvertRate'},
	            {name:'AutoFreight'},
	            {name:'DriverFreight'},
	            {name:'TrainFreight'},
	            {name:'ShipFreight'},
	            {name:'OtherFeight'},
	            {name:'Supplier'},
	            {name:'Origin'},
	            {name:'OriginText'},
	            {name:'AliasPrice'},
	            {name:'IsPlan'},
	            {name:'ProductType'},
	            {name:'ProductVer'},
	            { name:'Remark'},
	            {name:'CreateDate'},
	            {name:'UpdateDate'},
	            {name:'OperId'},
	            {name:'OrgId'}
	        ])	        
    });
}

var smRel= new Ext.grid.CheckboxSelectionModel({
	singleSelect:false
});
var productGrid = new Ext.grid.GridPanel({
    region:'center',
	width:'100%',
	height:'100%',
	autoWidth:true,
	autoScroll:true,
	layout: 'fit',
	id: '',
	store: productGridData,
	loadMask: {msg:'���ڼ������ݣ����Ժ��'},
	sm:smRel,
	cm: new Ext.grid.ColumnModel([
		smRel,
		new Ext.grid.RowNumberer(),//�Զ��к�
		{
			header:'���ID',
			dataIndex:'ProductId',
			id:'ProductId',
			hidden: true,
            hideable: false
		},
		{
			header:'������',
			dataIndex:'ProductNo',
			id:'ProductNo'
		},
		{
			header:'������',
			dataIndex:'MnemonicNo',
			id:'MnemonicNo'
		},
		{
			header:'�������',
			dataIndex:'ProductName',
			id:'ProductName'
		},
		{
			header:'���',
			dataIndex:'SpecificationsText',
			id:'SpecificationsText'
		},
		{
			header:'������λ',
			dataIndex:'UnitText',
			id:'UnitText'
		},
		{
			header:'���۵���',
			dataIndex:'SalePrice',
			id:'SalePrice'
		},
		{
			header:'����',
			dataIndex:'OriginText',
			id:'OriginText'
		}		]),
//		tbar: new Ext.Toolbar({
//	        items:[{
//		        text:"����",
//		        icon:"../../Theme/1/images/extjs/customer/add16.gif",
//		        handler:function(){
//                    openNonSelectWindowShow();
//		        }
//		        },'-',{
//		        text:"ɾ��",
//		        icon:"../../Theme/1/images/extjs/customer/delete16.gif",
//		        handler:function(){
//		            deleteProducInfos();
//		        }
//	        }]
//        }),
		bbar: new Ext.PagingToolbar({
			pageSize: 10,
			store: productGridData,
			displayMsg: '��ʾ��{0}����{1}����¼,��{2}��',
			emptyMsy: 'û�м�¼',
			displayInfo: true
		}),
		viewConfig: {
			columnsText: '��ʾ����',
			scrollOffset: 20,
			sortAscText: '����',
			sortDescText: '����',
			forceFit: true
		},
		height: 280,
		closeAction: 'hide',
		stripeRows: true,
		loadMask: true,
		autoExpandColumn: 2
	});
	
	var defaultPageSize = 10;
	var toolBar = productGrid.getBottomToolbar();
	var pageSizestore = new Ext.data.SimpleStore({
	    fields: ['pageSize'],
	    data: [[10], [20], [30]]
	});
	var combo1 = new Ext.form.ComboBox({
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
	toolBar.addField(combo1);
	combo1.on("change", function(c, value) {
	    toolBar.pageSize = value;
	    defaultPageSize = toolBar.pageSize;
	}, toolBar);
	combo1.on("select", function(c, record) {
	    toolBar.pageSize = parseInt(record.get("pageSize"));
	    defaultPageSize = toolBar.pageSize;
	    toolBar.doLoad(0);
	}, toolBar);


function deleteProducInfos(){
    var sm = productGrid.getSelectionModel();
    var selectData = sm.getSelected();
    var record=sm.getSelections();
    
    if (selectData == null || selectData.length == 0) 
    {
        Ext.Msg.alert("��ʾ", "��ѡ��һ�У�");
    }
    else 
    {   
        var array = new Array(selectData.length);
        for(var i=0;i<selectData.length;i++)
        {
            array[i] = selectData[i].get('ProductId');
        }
        Ext.Ajax.request({
        url: 'frmSysDicsInfo.aspx?method=deleteProductInfos',
            params: {
            ProductId: array.join('-')//��������id��
            },
            success: function(resp, opts) {
                //var data=Ext.util.JSON.decode(resp.responseText);
                Ext.Msg.alert("��ʾ", "ɾ���ɹ���");
                productGrid.getStore().reload();
            },
            failure: function(resp, opts) {
                Ext.Msg.alert("��ʾ", "ɾ��ʧ�ܣ�");
            }
        });
    }
}

/*------���������ò�Ʒ�б� end---------------*/
/*-------------�ͻ��������������ϸ��Ϣ start -------*/
var productWin = null;
function cfgProductWin(){
    var sm = CustomerGrid.getSelectionModel();
    var selectData =  sm.getSelected();

    if(selectData == null){
        Ext.Msg.alert("��ʾ","��ѡ��һ�У�");
    }
    else
    {
        //����һ��window����
        if( productWin == null){
            productWin = new Ext.Window({
                 title:'�ͻ���������Ʒ������ϸ��Ϣ',
                 id:'cfgWin',
                 width:750 ,
                 height:500, 
                 constrain:true,
                 layout: 'border', 
                 plain: true, 
                 modal: true,
                 closeAction: 'hide',
                 autoDestroy :true,
                 resizable:true,
                 items: [tree,productGrid] ,
                 buttons: [
                    {
                        text: "�ر�"
                        , handler: function() {
                            productWin.hide();
                        }
                        , scope: this
                    }]
            });
            productWin.addListener("hide",function(){
	                productGrid.getStore().removeAll();
            });
        }
        
        productWin.show();
        tree.getLoader().baseParams.CustomerId = strCustomerId;
        tree.root.reload();
    }
}

/*-------------�ͻ��������������ϸ��Ϣ end -------*/
/*------��ʼ��ѯform�ĺ��� start---------------*/
var MnemonicNoPanel = new Ext.form.TextField({
    style: 'margin-left:0px',
    cls: 'key',
    xtype: 'textfield',
    fieldLabel: '������',
    anchor: '90%',
    listeners: { specialkey: function(f, e) { if (e.getKey() == e.ENTER) { Ext.getCmp('ProductName').focus(); } } }

});


var ProductNamePanel = new Ext.form.TextField({
    style: 'margin-left:0px',
    cls: 'key',
    xtype: 'textfield',
    fieldLabel: '�������',
    anchor: '90%',
    listeners: { specialkey: function(f, e) { if (e.getKey() == e.ENTER) { Ext.getCmp('searchebtnId').focus(); } } }
});

var productSerchform = new Ext.FormPanel({
    region:'north',
    labelAlign: 'left',
    layout: 'fit',
    buttonAlign: 'right',
    bodyStyle: 'padding:5px',
    frame: true,
    labelWidth: 55,
    items: [{
        layout: 'column',   //�����Ԫ��Ϊ����Ϊ�в��ַ�ʽ
        border: false,
        items: [{
            columnWidth: .4,  //����ռ�õĿ�ȣ���ʶΪ20��
            layout: 'form',
            border: false,
            items: [
                MnemonicNoPanel
            ]
        }, {
            columnWidth: .4,
            layout: 'form',
            border: false,
            items: [
                ProductNamePanel
                ]
        }, {
            columnWidth: .2,
            layout: 'form',
            border: false,
            items: [{ cls: 'key',
                xtype: 'button',
                text: '��ѯ',
                id: 'nonSearchebtnId',
                anchor: '50%',
                handler: function() {

                    var MnemonicNo = MnemonicNoPanel.getValue();
                    var ProductName = ProductNamePanel.getValue();

                    productNoneGridData.baseParams.MnemonicNo = MnemonicNo;
                    productNoneGridData.baseParams.ProductName = ProductName;
                    productNoneGridData.baseParams.CustomerId = strCustomerId;
                    productNoneGridData.baseParams.BuyClassId = currentNodeId;
                    productNoneGridData.load({
                        params: {
                            start: 0
                        }
                    });
                }
            }]
        }]
    }]
});

/*------��ʼ��ѯform�ĺ��� end---------------*/
/*------��ʼ�����ò�Ʒ�б� start---------------*/
var productNoneGridData;
if(productNoneGridData==null){
    productNoneGridData = new Ext.data.Store({
        url:"frmCrmCustClassProduct.aspx?method=getNonProducts",
        reader:new Ext.data.JsonReader({
            totalProperty:'totalProperty',
	        root:'root'},
	        [
	            {name:'ProductId'},
	            {name:'ProductNo'},
	            {name:'MnemonicNo'},
	            {name:'AliasNo'},
	            {name:'MobileNo'},
	            {name:'SpeechNo'},
	            {name:'NetPurchasesNo'},
	            {name:'LogisticsNo'},
	            {name:'BarCode'},
	            {name:'SecurityCode'},
	            {name:'ProductName'},
	            {name:'AliasName'},
	            {name:'Specifications'},
	            {name:'Unit'},
	            {name:'SalePrice'},
	            {name:'SalePriceLower'},
	            {name:'SalePriceLimit'},
	            {name:'TaxWhPrice'},
	            {name:'TaxRate'},
	            {name:'Tax'},
	            {name:'SalesTax'},
	            {name:'UnitConvertRate'},
	            {name:'AutoFreight'},
	            {name:'DriverFreight'},
	            {name:'TrainFreight'},
	            {name:'ShipFreight'},
	            {name:'OtherFeight'},
	            {name:'Supplier'},
	            {name:'Origin'},
	            {name:'AliasPrice'},
	            {name:'IsPlan'},
	            {name:'ProductType'},
	            {name:'ProductVer'},
	            { name:'Remark'},
	            {name:'CreateDate'},
	            {name:'UpdateDate'},
	            {name:'OperId'},
	            {name:'OrgId'}
	        ])	        
    });
}

var smNonRel= new Ext.grid.CheckboxSelectionModel({
	singleSelect:false
});
var productNonGrid = new Ext.grid.GridPanel({
    region:'center',
	width:'100%',
	height:'100%',
	autoWidth:true,
	autoScroll:true,
	layout: 'fit',
	id: '',
	store: productNoneGridData,
	loadMask: {msg:'���ڼ������ݣ����Ժ��'},
	sm:smNonRel,
	cm: new Ext.grid.ColumnModel([
		smNonRel,
		new Ext.grid.RowNumberer(),//�Զ��к�
		{
			header:'���ID',
			dataIndex:'ProductId',
			id:'ProductId',
			hidden: true,
            hideable: false
		},
		{
			header:'������',
			dataIndex:'ProductNo',
			id:'ProductNo'
		},
		{
			header:'������',
			dataIndex:'MnemonicNo',
			id:'MnemonicNo'
		},
		{
			header:'�������',
			dataIndex:'ProductName',
			id:'ProductName'
		},
		{
			header:'���',
			dataIndex:'Specifications',
			id:'Specifications'
		},
		{
			header:'������λ',
			dataIndex:'Unit',
			id:'Unit'
		},
		{
			header:'���۵���',
			dataIndex:'SalePrice',
			id:'SalePrice'
		},
		{
			header:'����',
			dataIndex:'Origin',
			id:'Origin'
		}		]),
		bbar: new Ext.PagingToolbar({
			pageSize: 10,
			store: productNoneGridData,
			displayMsg: '��ʾ��{0}����{1}����¼,��{2}��',
			emptyMsy: 'û�м�¼',
			displayInfo: true
		}),
		viewConfig: {
			columnsText: '��ʾ����',
			scrollOffset: 20,
			sortAscText: '����',
			sortDescText: '����',
			forceFit: true
		},
		height: 280,
		closeAction: 'hide',
		stripeRows: true,
		loadMask: true,
		autoExpandColumn: 2
	});

/*------���������ò�Ʒ�б� end---------------*/
/*-------------�ͻ���������������� start -------*/
var productNonWin = null;
function openNonSelectWindowShow(){
    var sm = productNonGrid.getSelectionModel();
    var selectData =  sm.getSelected();
    if(selectData != null){
        Ext.Msg.alert("��ʾ","��ѡ��һ�У�");
    }
    else
    {
        //����һ��window����
        if( productNonWin == null){
            productNonWin = new Ext.Window({
                 title:'�ͻ���������Ʒ����',
                 id:'cfgNonWin',
                 width:600 ,
                 height:400, 
                 constrain:true,
                 plain: true, 
                 modal: true,
                 closeAction: 'hide',
                 autoDestroy :true,
                 resizable:true,
                 items: [productSerchform,productNonGrid],
                 buttons: [
                    {
                        text: "����"
                        , handler: function() {
                            var sm = productNonGrid.getSelectionModel();
                            var selectData = sm.getSelected();
                            var record=sm.getSelections();

                            if (selectData == null || selectData.length == 0) 
                            {
                                Ext.Msg.alert("��ʾ", "��ѡ��һ�У�");
                            }
                            else 
                            {   
                                var array = new Array(selectData.length);
                                for(var i=0;i<selectData.length;i++)
                                {
                                    array[i] = selectData[i].get('ProductId');
                                }
                                Ext.Ajax.request({
                                url: 'frmCrmCustClassProduct.aspx?method=saveProductInfos',
                                    params: {
                                    ProductId: array.join('-')//��������id��
                                    },
                                    success: function(resp, opts) {
                                        //var data=Ext.util.JSON.decode(resp.responseText);
                                        Ext.Msg.alert("��ʾ", "����ɹ���");
                                        //����ȡ����
                                        productGridData.reload({
                                            params:{
                                             CustomerId:strCustomerId,
                                             BuyClassId:currentNodeId
                                             }
                                        });
                                        productNonWin.hide();
                                    },
                                    failure: function(resp, opts) {
                                        Ext.Msg.alert("��ʾ", "����ʧ�ܣ�");
                                    }
                                });
                            }
                        }
                        , scope: this
                    },
                    {
                        text: "�ر�"
                        , handler: function() {
                            productNonWin.hide();
                        }
                        , scope: this
                    }]
            });
        }
     
        productNonWin.show();
    }
}

/*-------------�ͻ���������������� end -------*/


})
</script>
</html>
