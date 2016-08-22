<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmCrmCustomerBuyClass.aspx.cs" Inherits="CRM_customer_frmCrmCustomerBuyClass" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html>
<head>
<title>�ͻ��ɶ�������</title><meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<link rel="stylesheet" type="text/css" href="../../ext3/resources/css/ext-all.css" />
<script type="text/javascript" src="../../ext3/adapter/ext/ext-base.js"></script>
<script type="text/javascript" src="../../ext3/ext-all.js"></script>
<script type="text/javascript" src="../../ext3/src/locale/ext-lang-zh_CN.js"></script>
</head>
<body>
<div id='toolbar'></div>
<div id='searchForm'></div>
<div id='classGrid'></div>
</body>
<script type="text/javascript">
Ext.BLANK_IMAGE_URL = "../../ext3/resources/images/default/s.gif";
var BuyClassId =0;
Ext.onReady(function(){
/*------ʵ��toolbar�ĺ��� start---------------*/
var saveType;
var Toolbar = new Ext.Toolbar({
	renderTo:"toolbar",
	items:[{
		text:"����",
		icon:"../../Theme/1/images/extjs/customer/add16.gif",
		handler:function(){
		    saveType = "add";
		    openAddClassWin();
		}
		},'-',{
		text:"�༭",
		icon:"../../Theme/1/images/extjs/customer/edit16.gif",
		handler:function(){
		    saveType = "save";
		    modifyClassWin();
		}
		},'-',{
		text:"ɾ��",
		icon:"../../Theme/1/images/extjs/customer/delete16.gif",
		handler:function(){
		    deleteClass();
		}
		},'-',{
		text:"�������Ʒ����",
		icon:"../../Theme/1/images/extjs/customer/edit16.gif",
		handler:function(){
		    configClassProduct();
		}
	}]
});

/*------����toolbar�ĺ��� end---------------*/

/*------��ʼToolBar�¼����� start---------------*//*-----����Classʵ���ര�庯��----*/
function openAddClassWin() {
	buyClassForm.getForm().reset();
	Ext.getCmp("CreateDate").setValue(new Date().clearTime());
	Ext.getCmp("UpdateDate").setValue(new Date().clearTime());
	uploadClassWindow.show();
}
/*-----�༭Classʵ���ര�庯��----*/
function modifyClassWin() {
	var sm = gridData.getSelectionModel();
	//��ȡѡ���������Ϣ
	//var selectData =  sm.getSelected();
	var selectData =  sm.getSelections();
	if(selectData == null||selectData.length == 0){
		Ext.Msg.alert("��ʾ","��ѡ����Ҫ�༭����Ϣ��");
		return;
	}
	uploadClassWindow.show();
	var selectData =  sm.getSelected();
	
	Ext.Ajax.request({
	    url:'frmCrmCustomerBuyClass.aspx?method=getClasseInfo',
	    params:{
		    BuyClassId:selectData.data.BuyClassId
	    },
	    success: function(resp,opts){
	        //alert(resp.responseText);
		    var data=Ext.util.JSON.decode(resp.responseText);
		    Ext.getCmp('BuyClassId').setValue(data.BuyClassId);
		    Ext.getCmp('BuyClassNo').setValue(data.BuyClassNo);
		    Ext.getCmp('BuyClassName').setValue(data.BuyClassName);
		    
		    Ext.getCmp('Remark').setValue(data.Remark);
		    Ext.getCmp('CreateDate').setValue((new Date(data.CreateDate.replace(/-/g,"/"))).clearTime());
		    Ext.getCmp('UpdateDate').setValue((new Date()).clearTime());
	    },
	    failure: function(resp,opts){
		    Ext.Msg.alert("��ʾ","����ʧ��");
	    }
	});
}
/*-----ɾ��Classʵ�庯��----*/
/*ɾ����Ϣ*/
function deleteClass()
{
	var sm = gridData.getSelectionModel();
	//��ȡѡ���������Ϣ
	//var selectData =  sm.getSelected();
	var selectData =  sm.getSelections();
	//���û��ѡ�񣬾���ʾ��Ҫѡ��������Ϣ
	if(selectData == null||selectData.length==0){
		Ext.Msg.alert("��ʾ","��ѡ����Ҫɾ������Ϣ��");
		return;
	}
	//ɾ��ǰ�ٴ������Ƿ����Ҫɾ��
	Ext.Msg.confirm("��ʾ��Ϣ","�Ƿ����Ҫɾ��ѡ��Ĵ��������Ϣ��",function callBack(id){
		//�ж��Ƿ�ɾ������
		if(id=="yes")
		{
		    var array = new Array(selectData.length);
            for(var i=0;i<selectData.length;i++)
            {
                array[i] = selectData[i].get('BuyClassId');
            }
			//ҳ���ύ
			Ext.Ajax.request({
				url:'frmCrmCustomerBuyClass.aspx?method=deleteClasses',
				method:'POST',
				params:{
					BuyClassId:array.join('-')//��������id��
				},
				success: function(resp,opts){
				    for(var i=0;i<selectData.length;i++)
                    {
                        gridData.getStore().remove(selectData[i]);
                    }
					Ext.Msg.alert("��ʾ","����ɾ���ɹ�");
				},
				failure: function(resp,opts){
					Ext.Msg.alert("��ʾ","����ɾ��ʧ��");
				}
			});
		}
	});
}
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

                    productNoneGridData.baseParams.MnemonicNo=MnemonicNo;
                    productNoneGridData.baseParams.ProductName=ProductName;
                    productNoneGridData.baseParams.BuyClassId=BuyClassId;
                    productNoneGridData.load({
                        params: {
                            start: 0,
                            limit: 10
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
        url:"frmCrmCustomerBuyClass.aspx?method=getNonProducts",
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
var productWin = null;
function configClassProduct(){
var sm = gridData.getSelectionModel();
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
                 items: productGrid ,
                 buttons: [
                    {
                        text: "�ر�"
                        , handler: function() {
                            productWin.hide();
                        }
                        , scope: this
                    }]
            });
        }
        
        productWin.show();
        
        //load      
        productGridData.baseParams.BuyClassId=BuyClassId;
        productGridData.reload({
            params:{
             limit:10,
             start:0
             }
        });
    }
}
//����һ��window����
var productNonWin;
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
                        var array = new Array(record.length);
                        for(var i=0;i<record.length;i++)
                        {
                            array[i] = record[i].get('ProductId');
                        }
                        Ext.Ajax.request({
                        url: 'frmCrmCustomerBuyClass.aspx?method=saveProductInfos',
                            params: {
                                BuyClassId:BuyClassId,
                                ProductId: array.join('-')//��������id��
                            },
                            success: function(resp, opts) {
                                //var data=Ext.util.JSON.decode(resp.responseText);
                                Ext.Msg.alert("��ʾ", "����ɹ���");
                                //����ȡ����
                                productGridData.baseParams.BuyClassId=BuyClassId;
                                productGridData.reload({
                                    params:{
                                     limit:10,
                                     start:0
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
function openNonSelectWindowShow(){
    var sm = gridData.getSelectionModel();
    var selectData =  sm.getSelected();
    if(selectData == null){
        Ext.Msg.alert("��ʾ","��ѡ��һ�У�");
    }
    else
    {
        productNonWin.show();
    }
}
productNonWin.addListener("hide",function(){
   productNoneGridData.removeAll();
});
/*------ʵ��FormPanle�ĺ��� start---------------*/
var buyClassForm=new Ext.form.FormPanel({
	url:'frmCrmCustomerBuyClass.aspx',
	reader: new Ext.data.JsonReader(
	    {root:'list'},
        [
            {name: 'BuyClassId',mapping:'BuyClassId',type:'string'},
            {name: 'BuyClassNo',mapping:'BuyClassNo',type:'string'},
            {name: 'BuyClassName',mapping:'BuyClassName',type:'string'},
            {name: 'Remark',mapping:'Remark',type:'string'},
            {name: 'CreateDate',mapping:'CreateDate',type:'date', dateFormat:'Y��m��d��'},
            {name: 'UpdateDate',mapping:'UpdateDate',type:'date',dateFormat:'Y��m��d��'},
            //{name: 'OperId',mapping:'OperId',type:'int'},
            //{name: 'OrgId',mapping:'OrgId',type:'int'}
        ]),
	//renderTo:'divForm'
    bodyStyle: 'padding:5px',
    frame: true,   
    labelWidth:60, 
    waitMsgTarget : true,
	items:[
		{
			xtype:'textfield',
			fieldLabel:'�ɹ�����ID',
			name:'BuyClassId',
			id:'BuyClassId',
			hidden:true,
			hideLabel:true
		}
,		{
			xtype:'textfield',
			fieldLabel:'�������',
			columnWidth:1,
			anchor:'95%',
			name:'BuyClassNo',
			id:'BuyClassNo'
		}
,		{
			xtype:'textfield',
			fieldLabel:'��������',
			columnWidth:1,
			anchor:'95%',
			name:'BuyClassName',
			id:'BuyClassName'
		}
,		{
			xtype:'textarea',
			fieldLabel:'��ע',
			columnWidth:1,
			anchor:'95%',
			name:'Remark',
			id:'Remark'
		}
,		{
			xtype:'datefield',
			fieldLabel:'��������',
			columnWidth:1,
			anchor:'60%',
			name:'CreateDate',
			id:'CreateDate',
			disabled:true,
			format:'Y��m��d��'
		}
,		{
			xtype:'datefield',
			fieldLabel:'��������',
			columnWidth:1,
			anchor:'60%',
			name:'UpdateDate',
			id:'UpdateDate',
			disabled:true,
			format:'Y��m��d��'
		}
]
});
/*------FormPanle�ĺ������� End---------------*/

/*------��ʼ�������ݵĴ��� Start---------------*/
if(typeof(uploadClassWindow)=="undefined"){//�������2��windows����
	uploadClassWindow = new Ext.Window({
		id:'Classformwindow',
		title:'�ͻ��ɶ�������ά��'
		, iconCls: 'upload-win'
		, width: 450
		, height: 300
		, layout: 'fit'
		, plain: true
		, modal: true
		, constrain:true
		, resizable: false
		, closeAction: 'hide'
		,autoDestroy :true
		,items:buyClassForm
		,buttons: [{
			text: "����"
			, handler: function() {
				if (buyClassForm.getForm().isValid()) {
				    if(saveType=="add")
                            saveType = "addClassInfo";
                        else if(saveType == "save")
                            saveType = "saveClassInfo";
                            
                    buyClassForm.getForm().submit( {
                        url : 'frmCrmCustomerBuyClass.aspx?method='+saveType,
                        success : function(from, action) {
                            Ext.Msg.alert('����ɹ�', '��Ӵ������ɹ���');
                            var BuyClassName = classNamePanel.getValue();
                            gridDataData.load({
                                params: {
                                    start: 0,
                                    limit: 10,
                                    BuyClassName: BuyClassName
                                }
                            });
                        },
                        failure : function(form, action) {
                            Ext.Msg.alert('����ʧ��', '��Ӵ������ʧ�ܣ�');
                        }
                        
                    });
                    uploadClassWindow.hide();
                } else {
                    Ext.Msg.alert('��Ϣ', '����д������ύ!');
                }
			}
			, scope: this
		},
		{
			text: "ȡ��"
			, handler: function() { 
				uploadClassWindow.hide();
			}
			, scope: this
		}]});
	}
	uploadClassWindow.addListener("hide",function(){
});


/*------��ʼ��ѯform�ĺ��� start---------------*/
var classNamePanel = new Ext.form.TextField({
    style: 'margin-left:0px',
    cls: 'key',
    xtype: 'textfield',
    fieldLabel: '��������',
    anchor: '90%',
    listeners: { specialkey: function(f, e) { if (e.getKey() == e.ENTER) { Ext.getCmp('searchebtnId').focus(); } } }
});

var searchForm = new Ext.FormPanel({
    renderTo:'searchForm',
    labelAlign: 'left',
    layout: 'fit',
    buttonAlign: 'right',
    bodyStyle: 'padding:5px',
    frame: true,
    height:45,
    labelWidth: 55,
    items: [{
        layout: 'column',   //�����Ԫ��Ϊ����Ϊ�в��ַ�ʽ
        border: false,
        items: [ {
            columnWidth: .3,
            layout: 'form',
            border: false,
            items: [
                classNamePanel
                ]
        }, {
            columnWidth: .2,
            layout: 'form',
            border: false,
            items: [{ cls: 'key',
                xtype: 'button',
                text: 'ģ����ѯ',
                id: 'searchebtnId',
                anchor: '50%',
                handler: function() {
                    var BuyClassName = classNamePanel.getValue();

                    gridDataData.baseParams.BuyClassName = BuyClassName;
                    gridDataData.load({
                        params: {
                            start: 0,
                            limit: 10
                        }
                    });
                }
            }]
        },{
            columnWidth: .5,  //����ռ�õĿ�ȣ���ʶΪ20��
            layout: 'form',
            border: false
        }
        ]
    }]
});


/*------��ʼ��ѯform�ĺ��� end---------------*/

/*------��ʼ��ȡ���ݵĺ��� start---------------*/
var gridDataData = new Ext.data.Store
({
url: 'frmCrmCustomerBuyClass.aspx?method=getClassInfoList',
reader:new Ext.data.JsonReader({
	totalProperty:'totalProperty',
	root:'root'
},[
	{
		name:'BuyClassId'
	},
	{
		name:'BuyClassNo'
	},
	{
		name:'BuyClassName'
	},
	{
		name:'Remark'
	},
	{
		name:'CreateDate'
	},
	{
		name:'UpdateDate'
	}
		])
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
	singleSelect:false,
    listeners: {
        rowselect: function(sm, row, rec) {
            BuyClassId = rec.data.BuyClassId;
        }
    }
});
var gridData = new Ext.grid.GridPanel({
	el: 'classGrid',
	width:'100%',
	height:'100%',
	autoWidth:true,
	autoHeight:true,
	autoScroll:true,
	layout: 'fit',
	store: gridDataData,
	loadMask: {msg:'���ڼ������ݣ����Ժ��'},
	sm:sm,
	cm: new Ext.grid.ColumnModel([
		sm,
		new Ext.grid.RowNumberer(),//�Զ��к�
		{
			header:'�ɹ�����ID',
			dataIndex:'BuyClassId',
			id:'BuyClassId',
			hidden:true,
			hideable:true
		},
		{
			header:'�������',
			dataIndex:'BuyClassNo',
			id:'BuyClassNo'
		},
		{
			header:'��������',
			dataIndex:'BuyClassName',
			id:'BuyClassName'
		},
		{
			header:'��ע',
			dataIndex:'Remark',
			id:'Remark'
		},
		{
			header:'��������',
			dataIndex:'CreateDate',
			id:'CreateDate',
			renderer: Ext.util.Format.dateRenderer('Y��m��d��')
		},
		{
			header:'��������',
			dataIndex:'UpdateDate',
			id:'UpdateDate'
		}		]),
		bbar: new Ext.PagingToolbar({
			pageSize: 10,
			store: gridDataData,
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
gridData.render();
/*------DataGrid�ĺ������� End---------------*/
/*------��ʼ�����ò�Ʒ�б� start---------------*/
var productGridData;
if(productGridData==null){
    productGridData = new Ext.data.Store({
        url:"frmCrmCustomerBuyClass.aspx?method=getProducts",
        reader:new Ext.data.JsonReader({
            totalProperty:'totalProperty',
	        root:'root'},
	        [
	            {name:'BuyClassProductId'},
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
	            {name:'AliasPrice'},
	            {name:'IsPlan'},
	            {name:'ProductType'},
	            {name:'ProductVer'},
	            { name:'Remark'},
	            {name:'CreateDate'},
	            {name:'UpdateDate'},
	            {name:'OperId'},
	            {name:'OrgId'},
	            {name:'OriginText'}
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
			header:'ID',
			dataIndex:'BuyClassProductId',
			id:'BuyClassProductId',
			hidden: true,
            hideable: false
		},
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
		tbar: new Ext.Toolbar({
	        items:[{
		        text:"����",
		        icon:"../../Theme/1/images/extjs/customer/add16.gif",
		        handler:function(){
                    openNonSelectWindowShow();
		        }
		        },'-',{
		        text:"ɾ��",
		        icon:"../../Theme/1/images/extjs/customer/delete16.gif",
		        handler:function(){
		            deleteProducInfos();
		        }
	        }]
        }),
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
        var array = new Array(record.length);
        for(var i=0;i<record.length;i++)
        {
            array[i] = record[i].get('BuyClassProductId');
        }
        Ext.Ajax.request({
        url: 'frmCrmCustomerBuyClass.aspx?method=deleteProductInfos',
            params: {
                BuyClassId:BuyClassId,
                BuyClassProductId: array.join('-')//��������id��
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
/*-------------�ͻ��������������ϸ��Ϣ start -------*/


})
</script>

</html>

