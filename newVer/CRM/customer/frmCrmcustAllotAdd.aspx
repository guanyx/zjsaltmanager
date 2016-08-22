<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmCrmcustAllotAdd.aspx.cs" Inherits="CRM_customer_frmCrmcustAllotAdd" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>�����ͻ�����</title>
    <meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
    <link rel="stylesheet" type="text/css" href="../../ext3/resources/css/ext-all.css" />
	<script type="text/javascript" src="../../ext3/adapter/ext/ext-base.js"></script>	
	<script type="text/javascript" src="../../ext3/ext-all.js"></script>
</head>
<body>   
   <div id ='toolbar'></div>
   <div id ='serchform'></div>
   <div id ='datagrid'></div>
   <div id ='orgtree-div'></div>      
   <div id ='opertree-div'></div>      
</body>
<script type="text/javascript">
Ext.BLANK_IMAGE_URL = "../../ext3/resources/images/default/s.gif";
Ext.onReady(function(){
var strCustomerId = 0;
var currentNodeId = 0;
/*------����toolbar start---------------*/
var Toolbar = new Ext.Toolbar({
        renderTo : "toolbar",
		items:[
		{
        text : "��������֯",
        icon: '../../Theme/1/images/extjs/customer/add16.gif', 
        handler : function(){
            distrToOrgWin();//����󵯳�ԭ����Ϣ
		    }
		},
		{
        text : "���䵽��Ա",
        icon: '../../Theme/1/images/extjs/customer/add16.gif', 
        handler : function(){
            distrToOperWin();//����󵯳�ԭ����Ϣ
		    }
	    }]
});
/*------����toolbar end---------------*/
/*------ʵ��orgtree�ĺ��� start---------------*/
Ext.BLANK_IMAGE_URL = "../../ext3/resources/images/default/s.gif";	
var Tree = Ext.tree;
var orgTree = new Tree.TreePanel({
    el:'orgtree-div',
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
       dataUrl:'frmCrmcustAllotAdd.aspx?method=getorgtreelist',
       baseParams:{
            CustomerId:strCustomerId
       }})
});
// set the root node
var root = new Tree.AsyncTreeNode({
    text: '�������',
    draggable:false,
    id:'0'
});
orgTree.setRootNode(root);

/*------����orgtree�ĺ��� end---------------*/
/*------ʵ��tree�ĺ��� start---------------*/	
var Tree = Ext.tree;
var operTree = new Tree.TreePanel({
    el:'opertree-div',
    useArrows:true,//�Ƿ�ʹ�ü�ͷ
    autoScroll:true,
    animate:true,
    width:'100%',
    height:'100%',
    minSize: 150,
	maxSize: 180,
    enableDD:false,
    frame:true,
    border: false,
    containerScroll: true, 
    loader: new Tree.TreeLoader({
       dataUrl:'frmCrmcustAllotAdd.aspx?method=getopertreelist',
       baseParams:{
            CustomerId:strCustomerId
       }})
});
// set the root node
var root = new Tree.AsyncTreeNode({
    text: '�������',
    draggable:false,
    id:'0'
});
operTree.setRootNode(root);

/*------����opertree�ĺ��� end---------------*/
/*-------------������֯����Ϣѡ�� start -------*/
var distrToOrgWindow = null;
function distrToOrgWin(){
    var sm = Ext.getCmp('customerdatagrid').getSelectionModel();
    var selectData =  sm.getSelected();
    if(selectData == null){
        Ext.Msg.alert("��ʾ","��ѡ��һ�У�");
    }
    else
    {
       // alert(selectData.data.CustomerId);
        //ˢ����
        orgTree.getLoader().on("beforeload", function(treeLoader, node) {
            treeLoader.baseParams.CustomerId = selectData.data.CustomerId
        }, this);
        orgTree.root.reload();
                            
        //����һ��window����
        if( distrToOrgWindow == null){
            distrToOrgWindow = new Ext.Window({
                 title:'�ͻ���������Ʒ������ϸ��Ϣ',
                 id:'orgWin',
                 width:400 ,
                 height:450, 
                 constrain:true,
                 layout: 'fit', 
                 plain: true, 
                 modal: true,
                 closeAction: 'hide',
                 autoDestroy :true,
                 resizable:true,
                 items: orgTree ,
                 buttons: [
                    {
                        text: "����"
                        , handler: function() {
                            
                            distrToOrgWindow.hide();
                        }
                        , scope: this
                    },
                    {
                        text: "�ر�"
                        , handler: function() {
                            distrToOrgWindow.hide();
                        }
                        , scope: this
                    }]
            });
        }     
        distrToOrgWindow.show();
    }
}
/*-------------������֯����Ϣѡ�� end -------*/
/*-------------�����ͻ�������Ϣѡ�� start -------*/
var distrToOperWindow = null;
function distrToOperWin(){
    var sm = Ext.getCmp('customerdatagrid').getSelectionModel();
    var selectData =  sm.getSelected();
    if(selectData == null){
        Ext.Msg.alert("��ʾ","��ѡ��һ�У�");
    }
    else
    {
        //ˢ����
        operTree.getLoader().on("beforeload", function(treeLoader, node) {
                 treeLoader.baseParams.CustomerId = selectData.data.CustomerId
            }, this);
        operTree.root.reload();
        //����һ��window����
        if( distrToOperWindow == null){
            distrToOperWindow = new Ext.Window({
                 title:'�ͻ���������Ʒ������ϸ��Ϣ',
                 id:'operWin',
                 width:400 ,
                 height:450, 
                 constrain:true,
                 layout: 'fit', 
                 plain: true, 
                 modal: true,
                 closeAction: 'hide',
                 autoDestroy :true,
                 resizable:true,
                 items: operTree ,
                 buttons: [
                    {
                        text: "����"
                        , handler: function() {
                            
                            distrToOperWindow.hide();
                        }
                        , scope: this
                    },
                    {
                        text: "�ر�"
                        , handler: function() {
                            distrToOperWindow.hide();
                        }
                        , scope: this
                    }]
            });
        }     
        distrToOperWindow.show();
    }
}
/*-------------�����ͻ���������Ϣѡ�� end -------*/


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
	    url: 'frmCrmcustAllotAdd.aspx?method=getCustomers',
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


})
</script>
</html>
