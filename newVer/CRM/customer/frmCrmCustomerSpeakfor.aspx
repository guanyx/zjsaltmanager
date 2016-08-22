<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmCrmCustomerSpeakfor.aspx.cs" Inherits="CRM_customer_frmCrmCustomreSpeakfor" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>�ͻ��ɶ���������</title>
    <meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
    <link rel="stylesheet" type="text/css" href="../../ext3/resources/css/ext-all.css" />
	<script type="text/javascript" src="../../ext3/adapter/ext/ext-base.js"></script>	
	<script type="text/javascript" src="../../ext3/ext-all.js"></script>
</head>
<body style="padding: 0px; margin: 0px; width: 100%; height: 100%">
	<div id="toolbar"></div>
    <div id="serchform"></div>
    <div id="datagrid"></div>
    <div id="cfgGrid"></div>
    <div id="cfgNewGrid"></div>
</body>
<script type="text/javascript">
Ext.BLANK_IMAGE_URL = "../../ext3/resources/images/default/s.gif";
var customerId; //��ǰ�����ͻ���id
Ext.onReady(function(){
/*------����toolbar start---------------*/
var Toolbar = new Ext.Toolbar({
        renderTo : "toolbar",
		items:[{
        text : "�������",
        icon: '../../Theme/1/images/extjs/customer/add16.gif', 
        handler : function(){
            cfgCusProductClassWin();//����󵯳�ԭ����Ϣ
		}
    }]
});
/*------����toolbar end ----------------*/
/*------��������Grid�б� start ----------*/
var cfgListStore = new Ext.data.Store
	({
	    url: 'frmCrmCustomerSpeakfor.aspx?method=getCfg',
	    reader: new Ext.data.JsonReader({
	        totalProperty: 'totalProperty',
	        root: 'root'
	    }, [
	        { name: "SpeakforId" },
	        { name: "CustomerId" },
	        { name: "BuyClass" },
	        { name: "ActiveState" },
	        { name: "Remark" },
	        { name: "BuyClassName" },
	        { name: 'CreateDate'}
	    ])
	});
var smCfg= new Ext.grid.CheckboxSelectionModel(
    {
    singleSelect : false
    }
);

var cfgGrid = new Ext.grid.GridPanel({
    el: 'cfgGrid',
	width:'100%',
	height:'100%',
	autoWidth:true,
	//autoHeight:true,
	autoScroll:true,
	layout: 'fit',
	store: cfgListStore,
	loadMask: {msg:'���ڼ������ݣ����Ժ��'},
	sm:smCfg,
	cm: new Ext.grid.ColumnModel([
		smCfg,
		new Ext.grid.RowNumberer(),//�Զ��к�
		{
			header:'��ˮ��',//�ͻ��ɹ���ƷID
			id:'SpeakforId',
			hidden: true,
            hideable: false
		},
		{
			header:'���������',
			dataIndex:'BuyClass',
			id:'BuyClass',
			hidden: true,
            hideable: false
		},
		{
			header:'�����������',
			dataIndex:'BuyClassName',
			id:'BuyClassName'
		},
		{
			header:'����״̬',
			dataIndex:'ActiveState',
			id:'ActiveState',
			renderer:{fn: function(v){if(v==1)return '��';else return '��';}}
		}
		]),
		tbar: new Ext.Toolbar({
	        items:[{
		        text:"����",
		        icon:"../../Theme/1/images/extjs/customer/add16.gif",
		        handler:function(){
                    openWindowNewCfg();
		        }
		        },'-',{
		        text:"ɾ��",
		        icon:"../../Theme/1/images/extjs/customer/delete16.gif",
		        handler:function(){
		            var sm = cfgGrid.getSelectionModel();
                    var selectData =  sm.getSelections();
                    if(selectData == null||selectData.lenth==0){
                        Ext.Msg.alert("��ʾ","��ѡ��һ�У�");
                    }
                    else
                    {
                        if (!confirm("ȷ��ɾ����")) {
                            return;
                        }
                        var array = new Array(selectData.length);
                        for(var i=0;i<selectData.length;i++)
                        {
                            array[i] = selectData[i].get('SpeakforId');
                        }
                        Ext.Ajax.request({
                        url: 'frmCrmCustomerSpeakfor.aspx?method=deleteCfgInfo',
                            params: {
                                SpeakforId: array.join('-')//��������id��
                            },
                            success: function(resp, opts) {
                                //var data=Ext.util.JSON.decode(resp.responseText);
                                for(var i=0;i<selectData.length;i++)
                                {
                                    cfgGrid.getStore().remove(selectData[i]);
                                }
                                Ext.Msg.alert("��ʾ", "ɾ���ɹ���");
                                uploadGridWindow.hide();
                            },
                            failure: function(resp, opts) {
                                Ext.Msg.alert("��ʾ", "ɾ��ʧ�ܣ�");
                            }
                        });
                    }
		        }
	        }]
        }),
		bbar: new Ext.PagingToolbar({
			pageSize: 10,
			store: cfgListStore,
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
/*------��������Grid�б� end ----------*/

/*------��������δ����Grid�б� start ----------*/
var newCfgListStore = new Ext.data.Store
	({
	    url: 'frmCrmCustomerSpeakfor.aspx?method=getNewNoneCfg',
	    reader: new Ext.data.JsonReader({
	        totalProperty: 'totalProperty',
	        root: 'root'
	    }, [
	        { name: "BuyClassId" },
	        { name: "BuyClassNo" },
	        { name: "BuyClassName" },
	        { name: "Remark" },
	        { name: 'CreateDate'}
	    ])
	});
var smNewCfg= new Ext.grid.CheckboxSelectionModel(
    {
    singleSelect : false
    }
);

var cfgNewGrid = new Ext.grid.GridPanel({
    el: 'cfgNewGrid',
	width:'100%',
	height:'100%',
	autoWidth:true,
	//autoHeight:true,
	autoScroll:true,
	layout: 'fit',
	store: newCfgListStore,
	loadMask: {msg:'���ڼ������ݣ����Ժ��'},
	sm:smNewCfg,
	cm: new Ext.grid.ColumnModel([
		smNewCfg,
		new Ext.grid.RowNumberer(),//�Զ��к�
		{
			header:'���������',
			dataIndex:'BuyClass',
			id:'BuyClass',
			hidden: true,
            hideable: false
		},
		{
			header:'�����������',
			dataIndex:'BuyClassName',
			id:'BuyClassName'
		},
		{
			header:'��ע',
			dataIndex:'Remark',
			id:'Remark'
		}
		]),
		bbar: new Ext.PagingToolbar({
			pageSize: 10,
			store: newCfgListStore,
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
		stripeRows: true,
		loadMask: true,
		autoExpandColumn: 2
	});
/*------��������δ����Grid�б� end ----------*/

/*------����toolbar ���� start -----------*/
var cfgWin = null;
var cfgNewWin = null;
function cfgCusProductClassWin(){
    var sm = Ext.getCmp('customerdatagrid').getSelectionModel();
    var selectData =  sm.getSelected();
    if(selectData == null){
        Ext.Msg.alert("��ʾ","��ѡ��һ�У�");
    }
    else
    {
        //����һ��window����
        if( cfgWin == null){
            cfgWin = new Ext.Window({
                 title:'�ͻ�����������',
                 id:'cfgWin',
                 width:500 ,
                 height:350, 
                 constrain:true,
                 //layout: 'border', 
                 plain: true, 
                 modal: true,
                 closeAction: 'hide',
                 autoDestroy :true,
                 resizable:true,
                 items: cfgGrid ,
                 buttons: [
                    {
                        text: "�ر�"
                        , handler: function() {
                            cfgWin.hide();
                        }
                        , scope: this
                    }]
            });
        }
     
        cfgWin.show();
        
        //��������
        cfgListStore.baseParams.CustomerId=selectData.data.CustomerId;
        cfgListStore.load({
            params:{                
                limit:10,
                start:0
            }
        });
    }
}
function  openWindowNewCfg(){
    if( cfgNewWin == null){
            cfgNewWin = new Ext.Window({
                 title:'�ͻ�����������',
                 id:'cfgNewWin',
                 width:550 ,
                 height:350, 
                 constrain:true,
                 //layout: 'border', 
                 plain: false, 
                 modal: true,
                 closeAction: 'hide',
                 autoDestroy :true,
                 resizable:true,
                 items: cfgNewGrid ,
                 buttons: [
                    {
                        text: "����"
                        , handler: function() {
                            saveNewCfg();
                        }
                        , scope: this
                    },
                    {
                        text: "�ر�"
                        , handler: function() {
                            cfgNewWin.hide();
                        }
                        , scope: this
                    }]
            });
        }
     
        cfgNewWin.show();
        
        //��Ϊ���õ���Ʒȫ��ȡ��
        var sm = Ext.getCmp('customerdatagrid').getSelectionModel();
        var selectData =  sm.getSelected();
        newCfgListStore.baseParams.CustomerId=selectData.data.CustomerId;
        newCfgListStore.load({
            params:{                
                limit:10,
                start:0
            }
        })
        
}
function  saveNewCfg(){
    var sm = cfgNewGrid.getSelectionModel();
    var selectData =  sm.getSelections();
 
    if(selectData == null||selectData.length == 0){
        Ext.Msg.alert("��ʾ","��ѡ��һ�У�");
    }
    else
    {
        var array = new Array(selectData.length);
        for(var i=0;i<selectData.length;i++)
        {
            array[i] = selectData[i].get('BuyClassId');
        }
        
        var sm = Ext.getCmp('customerdatagrid').getSelectionModel();
        selectData =  sm.getSelected();
        
        Ext.Ajax.request({
        url: 'frmCrmCustomerSpeakfor.aspx?method=saveNewCfgInfo',
            params: {
                CustomerId: selectData.data.CustomerId  ,
                BuyClassId: array.join('-')//��������id��
            },
            success: function(resp, opts) {
                //var data=Ext.util.JSON.decode(resp.responseText);
                Ext.Msg.alert("��ʾ", "����ɹ���");
                cfgGrid.getStore().reload();
                cfgNewWin.hide();
            },
            failure: function(resp, opts) {
                Ext.Msg.alert("��ʾ", "����ʧ�ܣ�");
            }
        });
    }
}
/*------����toolbar ���� end -----------*/
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
    renderTo: 'serchform',
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
                    
                    customerListStore.baseParams.CustomerId = cusid;
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
	    url: 'frmCrmCustomerSpeakfor.aspx?method=getCustomers',
	    reader: new Ext.data.JsonReader({
	        totalProperty: 'totalProperty',
	        root: 'root'
	    }, [
	        { name: "CustomerId" },
		{ name: "CustomerNo" },
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
    singleSelect : true
    }
);
var CustomerGrid = new Ext.grid.GridPanel({
        el: 'datagrid',
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
       { header: "�ͻ�id",dataIndex: 'CustomerId' ,hidden:true},
       { header: "�ͻ����",dataIndex: 'CustomerNo' },
       { header: "�ͻ�����",dataIndex: 'ShortName' },
       { header: "��ϵ��", dataIndex: 'LinkMan' },
       { header: "��ϵ�绰", dataIndex: 'LinkTel' },
       { header: "�ƶ��绰", dataIndex: 'LinkMobile' },
       { header: "����", dataIndex: 'Fax' },
       { header: "��������",dataIndex: 'DistributionTypeText' },
       { header: "������", dataIndex: 'MonthQuantity' },
       { header: "����", dataIndex: 'IsCust' ,renderer:{ fn:function(v){ if(v==1)return '��';return '��'}}},
       { header: "��Ӧ��", dataIndex: 'IsProvide',renderer:{ fn:function(v){ if(v==1)return '��';return '��'}}},
       { header: "����ʱ��", dataIndex: 'CreateDate',renderer: Ext.util.Format.dateRenderer('Y��m��d��') }//
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
CustomerGrid.addListener('rowselect', function(t, r, e) {
    var record = CustomerGrid.getStore().getAt(r);   //Get the Record
    customerId = record.get(CustomerGrid.getColumnModel().getDataIndex(2));
});

/*------�����б�Grid end ----------------*/

})
</script>
</html>
