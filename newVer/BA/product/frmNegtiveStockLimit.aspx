<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmNegtiveStockLimit.aspx.cs" Inherits="BA_product_frmNegtiveStockLimit" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>����������Ʒ����</title>
    <meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
    <link rel="stylesheet" type="text/css" href="../../ext3/resources/css/ext-all.css" />
    <script type="text/javascript" src="../../ext3/adapter/ext/ext-base.js"></script>
    <script type="text/javascript" src="../../ext3/ext-all.js"></script>  
    <script type="text/javascript" src="../../js/operateResp.js"></script>  
</head>
<body>
    <div id='toolbar'></div>
    <div id='divForm'></div>
    <div id='searchForm'></div>
    <div id='productGrid'></div>
<%= getComboBoxStore() %>
</body>
<script type="text/javascript">
Ext.BLANK_IMAGE_URL = "../../ext3/resources/images/default/s.gif";
Ext.onReady(function(){    
    var operType = '';
    /****************************************************************/
    var dsWareHouse; 
    if (dsWareHouse == null) { //��ֹ�ظ�����
        dsWareHouse = new Ext.data.JsonStore({
            totalProperty: "result",
            root: "root",
            url: 'frmNegtiveStockLimit.aspx?method=getWhSimple',
            fields: ['WhId', 'WhName']
        });
        dsWareHouse.baseParams.ForBusi='true';
        dsWareHouse.load();
     };
    /****************************************************************/
    /*------ʵ��toolbar�ĺ��� start---------------*/
    var Toolbar = new Ext.Toolbar({
	    //renderTo:"toolbar",
	    items:[{
		    text:"���",
		    icon:"../../Theme/1/images/extjs/customer/add16.gif",
		    handler:function(){
		        operType = 'add';
                openWindowShow();
		    }
		    },'-',{
		    text:"ɾ��",
		    icon:"../../Theme/1/images/extjs/customer/delete16.gif",
		    handler:function(){
		        deleteProductInfo();
		    }
	    }]
    });
    
    
    /*------��ʼ��ѯform�ĺ��� start---------------*/
    var orgPanel = new Ext.form.ComboBox({
        xtype:'combo',
        fieldLabel:'��˾��ʶ',
        anchor:'98%',
        style: 'margin-left:0px',
        cls: 'key',
        name:'OrgName',
        id:'OrgId',
        store: dsOrg,
        displayField: 'OrgName',  //����ֶκ�ҵ��ʵ�����ֶ�ͬ��
        valueField: 'OrgId',      //����ֶκ�ҵ��ʵ�����ֶ�ͬ��
        typeAhead: false, //�Զ�����һ����������ѡ�ȫ����
        triggerAction: 'all',
        emptyValue: '',
        selectOnFocus: true,
        forceSelection: true,
        mode:'local' ,
        listeners: {
           select: function(combo, record, index) {
                var curOrgId = Ext.getCmp('OrgId').getValue();
                dsWareHouse.load({
                    params: {
                        orgID: curOrgId
                    }
                });
            },
            specialkey: function(f, e) { if (e.getKey() == e.ENTER) { whnamePanel.focus(); } } 
        }             

    });


    function regexValue(qe){
        var combo = qe.combo;  
        //q is the text that user inputed.  
        var q = qe.query;  
        forceAll = qe.forceAll;  
        if(forceAll === true || (q.length >= combo.minChars)){  
         if(combo.lastQuery !== q){  
             combo.lastQuery = q;  
             if(combo.mode == 'local'){  
                 combo.selectedIndex = -1;  
                 if(forceAll){  
                     combo.store.clearFilter();  
                 }else{  
                     combo.store.filterBy(function(record,id){  
                         var text = record.get(combo.displayField);  
                         //������д�Լ��Ĺ��˴���  
                         return (text.indexOf(q)!=-1);  
                     });  
                 }  
                 combo.onLoad();  
             }else{  
                 combo.store.baseParams[combo.queryParam] = q;  
                 combo.store.load({  
                     params: combo.getParams(q)  
                 });  
                 combo.expand();  
             }  
         }else{  
             combo.selectedIndex = -1;  
             combo.onLoad();  
         }  
        }  
        return false;  
    }
    orgPanel.on('beforequery',function(qe){  
        regexValue(qe);
    });  
    var WhNamePanel = new Ext.form.ComboBox({
        fieldLabel: '�ֿ�����',
        name: 'warehouseCombo',
        store: dsWareHouse,
        displayField: 'WhName',
        valueField: 'WhId',
        typeAhead: true, //�Զ�����һ����������ѡ�ȫ����
        triggerAction: 'all',
        emptyText: '��ѡ��ֿ�',
        //valueNotFoundText: 0,
        selectOnFocus: true,
        forceSelection: true,
        anchor: '90%',
        mode: 'local',
        listeners: {
            specialkey: function(f, e) {
                if (e.getKey() == e.ENTER) {
                    Ext.getCmp('searchebtnId').focus();
                }
            }
          ,
            select: function(combo, record, index) {
                
            }
        }
    });
    var serchform = new Ext.FormPanel({
        renderTo: 'searchForm',
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
                    orgPanel
                ]
            }, {
                columnWidth: .4,
                layout: 'form',
                border: false,
                items: [
                    WhNamePanel
                    ]
            }, {
                columnWidth: .2,
                layout: 'form',
                border: false,
                items: [{ cls: 'key',
                    xtype: 'button',
                    text: '��ѯ',
                    id: 'searchebtnId',
                    anchor: '50%',
                    handler: function() {

                        var OrgId = orgPanel.getValue();
                        var WhId = WhNamePanel.getValue();

                        productGridData.baseParams.OrgId =   OrgId; 
                        productGridData.baseParams.WhId =   WhId;
                        productGridData.load({
                            params: {
                                start: 0,
                                limit: 20
                            }
                        });
                    }
                }]
            }]
        }]
    });
    serchform.render();
    /*------��ʼ��ѯform�ĺ��� end---------------*/
    /*------��ʼ��ȡ���ݵĺ��� start---------------*/
    var productGridData = new Ext.data.Store
    ({
        url: 'frmNegtiveStockLimit.aspx?method=getProductInfoList',
        reader:new Ext.data.JsonReader({
	        totalProperty:'totalProperty',
	        root:'root'
        },[
	    {		    name:'ProductId'	    },
	    {		    name:'ProductNo'	    },
	    {		    name:'MnemonicNo'	    },
	    {		    name:'AliasNo'	    },
	    {		    name:'MobileNo'	    },	    
	                {name:'CfgId'},
	    {		    name:'SpeechNo'	    },
	    {		    name:'NetPurchasesNo'	    },
	    {		    name:'LogisticsNo'	    },
	    {		    name:'BarCode'	    },
	    {		    name:'SecurityCode'	    },
	    {		    name:'ProductName'	    },
	    {		    name:'AliasName'	    },
	    {		    name:'Specifications'	    },
	    {		    name:'SpecificationsText'	    },
	    {		    name:'Unit'	    },
	    {	        name:'UnitText'	    },
	    {		    name:'SalePrice'	    },
	    {		    name:'SalePriceLower'	    },
	    {		    name:'SalePriceLimit'	    },
	    {		    name:'TaxWhPrice'	    },
	    {		    name:'TaxRate'	    },
	    {		    name:'Tax'	    },
	    {		    name:'SalesTax'	    },
	    {		    name:'UnitConvertRate'	    },
	    {		    name:'AutoFreight'	    },
	    {		    name:'DriverFreight'	    },
	    {		    name:'TrainFreight'	    },
	    {		    name:'ShipFreight'	    },
	    {		    name:'OtherFeight'	    },
	    {		    name:'Supplier'	    },	
	    {	        name:'SupplierText'	    },
	    {		    name:'Origin'	    },	    
	    {		    name:'OriginText'	    },
	    {		    name:'AliasPrice'	    },
	    {		    name:'IsPlan'	    },
	    {		    name:'ProductType'	    },
	    {		    name:'ProductVer'	    },
	    {		    name:'Remark'	    },
	    {		    name:'CreateDate'	    },
	    {		    name:'UpdateDate'	    },
	    {		    name:'OperId'	    },
	    {		    name:'OrgShortName'	    },
	    {		    name:'WhName'	    },
	    {		    name:'OrgId'
	    }	])
	    ,
	    listeners:
	    {
		    scope:this,
		    load:function(){ 
		    }
	    }
    });

    /*------��ȡ���ݵĺ��� ���� End---------------*/
    /*------��ʼDataGrid�ĺ��� start---------------*/

    var sm= new Ext.grid.CheckboxSelectionModel({
	    singleSelect:true
    });
    var productGrid = new Ext.grid.GridPanel({
	    el: 'productGrid',
	    width:'100%',
	    height:'100%',
	    //autoWidth:true,
	    //autoHeight:true,
	    autoScroll:true,
	    layout: 'fit',
	    id: '',
	    store: productGridData,
	    loadMask: {msg:'���ڼ������ݣ����Ժ��'},
	    sm:sm,
	    cm: new Ext.grid.ColumnModel([
		    sm,
		    new Ext.grid.RowNumberer(),//�Զ��к�
		    {
			    header:'ID',
			    dataIndex:'CfgId',
			    id:'CfgId',
			    hidden: true,
                hideable: false
		    },
		    {
			    header:'��֯����',
			    dataIndex:'OrgShortName',
			    id:'OrgShortName',
			    width:100
		    },
		    {
			    header:'�ֿ�����',
			    dataIndex:'WhName',
			    id:'WhName',
			    width:100
		    },
		    {
			    header:'������',
			    dataIndex:'ProductNo',
			    id:'ProductNo',
			    width:100
		    },
		    {
			    header:'������',
			    dataIndex:'MnemonicNo',
			    id:'MnemonicNo',
			    width:100
		    },
		    {
			    header:'�������',
			    dataIndex:'ProductName',
			    id:'ProductName',
			    width:170
		    },
		    {
			    header:'���',
			    dataIndex:'SpecificationsText',
			    id:'SpecificationsText',
			    width:40
		    },
		    {
			    header:'������λ',
			    dataIndex:'UnitText',
			    id:'UnitText',
			    width:60
		    },
		    {
			    header:'���۵���',
			    dataIndex:'SalePrice',
			    id:'SalePrice',
			    width:60
		    },
		    {
			    header:'��Ӧ��',
			    dataIndex:'SupplierText',
			    id:'SupplierText',
			    width:150
		    },
		    {
			    header:'����',
			    dataIndex:'OriginText',
			    id:'OriginText',
			    width:100
		    }		]),
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
			    forceFit: false
		    },
		    height: 340,
		    closeAction: 'hide',
		    stripeRows: true,
		    loadMask: true,
		    tbar:[
		        {
		        text:"���",
		        icon:"../../Theme/1/images/extjs/customer/add16.gif",
		        handler:function(){
                        openWindowShow();
		            }
		        },'-',{
		        text:"ɾ��",
		        icon:"../../Theme/1/images/extjs/customer/delete16.gif",
		        handler:function(){
		                deleteProductInfo();
		            }
		        }
	        ]
	    });
    productGrid.render();
    function saveProductCfg(){
        var sm = productNonGrid.getSelectionModel();
        var selectData = sm.getSelected();
        var record=sm.getSelections();

        if (selectData == null || selectData.length == 0) 
        {
            Ext.Msg.alert("��ʾ", "��ѡ��һ�У�");
        }
        else 
        {   
            var array = new Array(record.length);
            for(var i=0;i<record.length;i++)
            {
                array[i] = record[i].get('ProductId');
            }
            Ext.Ajax.request({
            url: 'frmNegtiveStockLimit.aspx?method=addCfg',
                params: {
                    WhId:Ext.getCmp('whCombo').getValue(),
                    ProductId: array.join('-')//��������id��
                },
                success: function(resp, opts) {
                    //var data=Ext.util.JSON.decode(resp.responseText);
                    if ( checkExtMessage(resp) ) {
                        //����ȡ����
                        productGridData.baseParams.WhId=WhNamePanel.getValue();
                        productGridData.reload({
                            params:{
                             limit:20,
                             start:0
                             }
                        });
                        productNonWin.hide();
                    }
                },
                failure: function(resp, opts) {
                    Ext.Msg.alert("��ʾ", "����ʧ�ܣ�");
                }
            });
        }
    }
    
    function openWindowShow(){
        productNonWin.show();
        if(WhNamePanel.getValue() != null)
            Ext.getCmp('whCombo').setValue(WhNamePanel.getValue() );
    }
    
    function deleteProductInfo(){
        var sm = productGrid.getSelectionModel();
        var selectData = sm.getSelected();
        if (selectData == null || selectData.length == 0 || selectData.length > 1) 
        {
            Ext.Msg.alert("��ʾ", "��ѡ��һ�У�");
        }
        else 
        {   //alert(selectData.data.CfgId);
            Ext.Ajax.request({
            url: 'frmNegtiveStockLimit.aspx?method=deleteProductInfo',
                params: {
                CfgId: selectData.data.CfgId
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
    /*------DataGrid�ĺ������� End---------------*/
    /*------��ʼ��ѯform�ĺ��� start---------------*/
    var MnemonicNoPanel = new Ext.form.TextField({
        style: 'margin-left:0px',
        cls: 'key',
        xtype: 'textfield',
        fieldLabel: '�������',
        anchor: '90%',
        listeners: { specialkey: function(f, e) { if (e.getKey() == e.ENTER) { ProductNamePanel.focus(); } } }

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
                        
                        if(curOrgId == 1){
                            productNoneGridData.load({
                                params: {
                                    start: 0,
                                    limit: 20,
                                    MnemonicNo:MnemonicNo,
                                    ProductName:ProductName
                                }
                            });
                        }else{
                            productNoneGridData.load({
                                params: {
                                    start: 0,
                                    limit: 20,
                                    MnemonicNo:MnemonicNo,
                                    ProductName:ProductName,
                                    IsPlan:0
                                }
                            });
                        }
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
            url:"frmNegtiveStockLimit.aspx?method=getAllProducts",
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
	                {name:'TaxWhPrice'},
	                {name:'AutoFreight'},
	                {name:'DriverFreight'},
	                {name:'TrainFreight'},
	                {name:'ShipFreight'},
	                {name:'OtherFeight'},
	                {name:'Supplier'},
	                {name:'Origin'},
	                {name:'OriginText'},
	                {name:'AliasPrice'},
	                {name:'ProductType'},
	                {name:'ProductVer'},
	                {name:'CreateDate'}
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
			    dataIndex:'CfgId',
			    id:'CfgId',
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
		    bbar: new Ext.PagingToolbar({
			    pageSize: 20,
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
    var whform = new Ext.FormPanel({
        region:'south',
        labelAlign: 'left',
        buttonAlign: 'right',
        bodyStyle: 'padding:5px',
        frame: true,
        labelWidth: 100,
        items: [{
            layout: 'column',   //�����Ԫ��Ϊ����Ϊ�в��ַ�ʽ
            border: false,
            items: [{
                columnWidth: .6,  //����ռ�õĿ�ȣ���ʶΪ20��
                layout: 'form',
                border: false,
                items: [{
                    fieldLabel: '��ѡ��ָ���ֿ�',
                    xtype:'combo',
                    name: 'whCombo',
                    id:'whCombo',
                    store: dsWareHouse,
                    displayField: 'WhName',
                    valueField: 'WhId',
                    typeAhead: true, //�Զ�����һ����������ѡ�ȫ����
                    triggerAction: 'all',
                    emptyText: '��ѡ��ֿ�',
                    selectOnFocus: true,
                    forceSelection: true,
                    anchor: '90%',
                    mode: 'local'
                }]
            }, {
                columnWidth: .4,
                layout: 'form',
                border: false
            }]
        }]
    });
    /*------���������ò�Ʒ�б� end---------------*/
    //����һ��window����
    var productNonWin;
    if( productNonWin == null){
        productNonWin = new Ext.Window({
             title:'�ͻ���������Ʒ����',
             id:'cfgNonWin',
             width:600 ,
             height:450, 
             constrain:true,
             plain: true, 
             modal: true,
             closeAction: 'hide',
             autoDestroy :true,
             resizable:true,
             items: [productSerchform,productNonGrid,whform],
             buttons: [
                {
                    text: "����"
                    , handler: function() {
                        saveProductCfg();
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
        productNonWin.addListener("hide", function() {
            productSerchform.getForm().reset();
            productNonGrid.getStore().removeAll();
        });
    }
    

    orgPanel.setValue(<% =ZJSIG.UIProcess.ADM.UIAdmUser.OrgID(this)%>);
    var curOrgId = orgPanel.getValue();
    dsWareHouse.load({
        params: {
            orgID: curOrgId
        }
    });
    if(curOrgId != 1)
     orgPanel.setDisabled(true);
 
})
</script>
</html>
