<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmCrmcustAllot.aspx.cs" Inherits="CRM_customer_frmCrmcustAllot" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>客户分配维护</title>
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
/*------定义toolbar start---------------*/
var Toolbar = new Ext.Toolbar({
        renderTo : "toolbar",
		items:[{
        text : "新增",
        icon: '../../Theme/1/images/extjs/customer/add16.gif', 
        handler : function(){
            openAllotAddWin();//点击后弹出原有信息
		    }
		},
		{
        text : "删除",
        icon: '../../Theme/1/images/extjs/customer/add16.gif', 
        handler : function(){
            deleteAllot();//点击后弹出原有信息
		    }
	    }]
});
/*------定义toolbar end---------------*/

/*-------------弹出组织树信息选择 start -------*/
var addAllotWindow = null;
function openAllotAddWin(){                                
    //弹出一个window窗口
    if (document.getElementById("frameaddAllot") == null) {
        addAllotWindow = ExtJsShowWin('客户分配', 'frmCrmcustAllotAdd.aspx', 'addAllot', 750, 550);
    }
    else {
        document.getElementById("frameaddAllot").src = "frmCrmcustAllotAdd.aspx";
    }
    addAllotWindow.show();
}
/*-------------弹出增加信息选择 end -------*/
/*-------------删除信息选择 start -------*/

function deleteAllot(){
    var sm = Ext.getCmp('customerdatagrid').getSelectionModel();
    var selectData =  sm.getSelected();
    if(selectData == null){
        Ext.Msg.alert("提示","请选中一行！");
    }
    else
    {
        if (!confirm("确认删除？")) {
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
                Ext.Msg.alert("提示", "删除成功！");
            },
            failure: function(resp, opts) {
                Ext.Msg.alert("提示", "删除失败！");
            }
        });
    }
}
/*-------------弹出信息选择 end -------*/


/*------定义查询form start ----------------*/
var cusidPanel = new Ext.form.TextField({
    style: 'margin-left:0px',
    cls: 'key',
    xtype: 'textfield',
    fieldLabel: '客户编号',
    name: 'cusid',
    id:'search',
    anchor: '90%'
});


var namePanel = new Ext.form.TextField({
    style: 'margin-left:0px',
    cls: 'key',
    xtype: 'textfield',
    fieldLabel: '客户名称',
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
        layout: 'column',   //定义该元素为布局为列布局方式
        border: false,
        items: [{
            columnWidth: .32,  //该列占用的宽度，标识为20％
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
                text: '查询',
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
/*------定义查询form end ----------------*/
/*------定义列表Grid start ----------------*/
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
        loadMask: {msg:'正在加载数据，请稍侯……'},
        sm:sm,
        cm: new Ext.grid.ColumnModel([
        sm,
        new Ext.grid.RowNumberer(),//自动行号
        { header: "分配编号",dataIndex: 'AllotId' ,hidden:true},
       { header: "客户编号",dataIndex: 'CustomerId' ,hidden:true},
       { header: "客户名称",dataIndex: 'ChineseName' },
       { header: "分配至组织id", dataIndex: 'OwenOrgId'  ,hidden:true},
       { header: "组织", dataIndex: 'OwenOrgName' },
       { header: "分配至用户i", dataIndex: 'OwenUserId' },
       { header: "用户", dataIndex: 'EmpName' },
       { header: "创建时间", dataIndex: 'CreateDate' }//
       ]),
      bbar: new Ext.PagingToolbar({
        pageSize: 10,
        store: customerListStore,
        displayMsg: '显示第{0}条到{1}条记录,共{2}条',
        emptyMsy: '没有记录',
        displayInfo: true
      }),
      viewConfig: {
        columnsText: '显示的列',
        scrollOffset: 20,
        sortAscText: '升序',
        sortDescText: '降序',
        forceFit: true
      },
      height: 280,
      closeAction: 'hide',
      stripeRows: true,
      loadMask: true,
      autoExpandColumn: 2
});
CustomerGrid.render();

/*------定义列表Grid end ----------------*/


})
</script>
</html>
