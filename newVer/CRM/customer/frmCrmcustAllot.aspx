<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmCrmcustAllot.aspx.cs" Inherits="CRM_customer_frmCrmcustAllot" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>�ͻ�����ά��</title>
    <meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
    <link rel="stylesheet" type="text/css" href="../../ext3/resources/css/ext-all.css" />
	<script type="text/javascript" src="../../ext3/adapter/ext/ext-base.js"></script>	
	<script type="text/javascript" src="../../ext3/ext-all.js"></script>
	<script type="text/javascript" src="../../js/ExtJsHelper.js"></script>
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
		items:[{
        text : "����",
        icon: '../../Theme/1/images/extjs/customer/add16.gif', 
        handler : function(){
            openAllotAddWin();//����󵯳�ԭ����Ϣ
		    }
		},
		{
        text : "ɾ��",
        icon: '../../Theme/1/images/extjs/customer/add16.gif', 
        handler : function(){
            deleteAllot();//����󵯳�ԭ����Ϣ
		    }
	    }]
});
/*------����toolbar end---------------*/

/*-------------������֯����Ϣѡ�� start -------*/
var addAllotWindow = null;
function openAllotAddWin(){                                
    //����һ��window����
    if (document.getElementById("frameaddAllot") == null) {
        addAllotWindow = ExtJsShowWin('�ͻ�����', 'frmCrmcustAllotAdd.aspx', 'addAllot', 750, 550);
    }
    else {
        document.getElementById("frameaddAllot").src = "frmCrmcustAllotAdd.aspx";
    }
    addAllotWindow.show();
}
/*-------------����������Ϣѡ�� end -------*/
/*-------------ɾ����Ϣѡ�� start -------*/

function deleteAllot(){
    var sm = Ext.getCmp('customerdatagrid').getSelectionModel();
    var selectData =  sm.getSelected();
    if(selectData == null){
        Ext.Msg.alert("��ʾ","��ѡ��һ�У�");
    }
    else
    {
        if (!confirm("ȷ��ɾ����")) {
            return;
        }
        Ext.Ajax.request({
        url: 'frmCrmCustomerSpeakfor.aspx?method=deleteCfgInfo',
            params: {
                AllotId: selectData.data.AllotId
            },
            success: function(resp, opts) {
                //var data=Ext.util.JSON.decode(resp.responseText);
                cfgGrid.getStore().remove(selectData);
                Ext.Msg.alert("��ʾ", "ɾ���ɹ���");
            },
            failure: function(resp, opts) {
                Ext.Msg.alert("��ʾ", "ɾ��ʧ�ܣ�");
            }
        });
    }
}
/*-------------������Ϣѡ�� end -------*/


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
	    url: 'frmCrmcustAllot.aspx?method=getCustomerAllots',
	    reader: new Ext.data.JsonReader({
	        totalProperty: 'totalProperty',
	        root: 'root'
	    }, [
	        { name: "AllotId" },
	        { name: "CustomerId" },
	        { name: "ChineseName" },
	        { name: "OwenOrgId" },
	        { name: "OwenOrgName" },
	        { name: "OwenUserId" },
	        { name: "EmpName" },
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
        { header: "������",dataIndex: 'AllotId' ,hidden:true},
       { header: "�ͻ����",dataIndex: 'CustomerId' ,hidden:true},
       { header: "�ͻ�����",dataIndex: 'ChineseName' },
       { header: "��������֯id", dataIndex: 'OwenOrgId'  ,hidden:true},
       { header: "��֯", dataIndex: 'OwenOrgName' },
       { header: "�������û�i", dataIndex: 'OwenUserId' },
       { header: "�û�", dataIndex: 'EmpName' },
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
