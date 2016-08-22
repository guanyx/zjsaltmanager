<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmCrmcustAllotAdd.aspx.cs" Inherits="CRM_customer_frmCrmcustAllotAdd" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>新增客户分配</title>
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
/*------定义toolbar start---------------*/
var Toolbar = new Ext.Toolbar({
        renderTo : "toolbar",
		items:[
		{
        text : "分配至组织",
        icon: '../../Theme/1/images/extjs/customer/add16.gif', 
        handler : function(){
            distrToOrgWin();//点击后弹出原有信息
		    }
		},
		{
        text : "分配到人员",
        icon: '../../Theme/1/images/extjs/customer/add16.gif', 
        handler : function(){
            distrToOperWin();//点击后弹出原有信息
		    }
	    }]
});
/*------定义toolbar end---------------*/
/*------实现orgtree的函数 start---------------*/
Ext.BLANK_IMAGE_URL = "../../ext3/resources/images/default/s.gif";	
var Tree = Ext.tree;
var orgTree = new Tree.TreePanel({
    el:'orgtree-div',
    region:'west',
    useArrows:true,//是否使用箭头
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
    text: '存货分类',
    draggable:false,
    id:'0'
});
orgTree.setRootNode(root);

/*------结束orgtree的函数 end---------------*/
/*------实现tree的函数 start---------------*/	
var Tree = Ext.tree;
var operTree = new Tree.TreePanel({
    el:'opertree-div',
    useArrows:true,//是否使用箭头
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
    text: '存货分类',
    draggable:false,
    id:'0'
});
operTree.setRootNode(root);

/*------结束opertree的函数 end---------------*/
/*-------------弹出组织树信息选择 start -------*/
var distrToOrgWindow = null;
function distrToOrgWin(){
    var sm = Ext.getCmp('customerdatagrid').getSelectionModel();
    var selectData =  sm.getSelected();
    if(selectData == null){
        Ext.Msg.alert("提示","请选中一行！");
    }
    else
    {
       // alert(selectData.data.CustomerId);
        //刷新树
        orgTree.getLoader().on("beforeload", function(treeLoader, node) {
            treeLoader.baseParams.CustomerId = selectData.data.CustomerId
        }, this);
        orgTree.root.reload();
                            
        //弹出一个window窗口
        if( distrToOrgWindow == null){
            distrToOrgWindow = new Ext.Window({
                 title:'客户存货类别商品配置详细信息',
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
                        text: "保存"
                        , handler: function() {
                            
                            distrToOrgWindow.hide();
                        }
                        , scope: this
                    },
                    {
                        text: "关闭"
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
/*-------------弹出组织树信息选择 end -------*/
/*-------------弹出客户经理信息选择 start -------*/
var distrToOperWindow = null;
function distrToOperWin(){
    var sm = Ext.getCmp('customerdatagrid').getSelectionModel();
    var selectData =  sm.getSelected();
    if(selectData == null){
        Ext.Msg.alert("提示","请选中一行！");
    }
    else
    {
        //刷新树
        operTree.getLoader().on("beforeload", function(treeLoader, node) {
                 treeLoader.baseParams.CustomerId = selectData.data.CustomerId
            }, this);
        operTree.root.reload();
        //弹出一个window窗口
        if( distrToOperWindow == null){
            distrToOperWindow = new Ext.Window({
                 title:'客户存货类别商品配置详细信息',
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
                        text: "保存"
                        , handler: function() {
                            
                            distrToOperWindow.hide();
                        }
                        , scope: this
                    },
                    {
                        text: "关闭"
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
/*-------------弹出客户经理树信息选择 end -------*/


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
        loadMask: {msg:'正在加载数据，请稍侯……'},
        sm:sm,
        cm: new Ext.grid.ColumnModel([
        sm,
        new Ext.grid.RowNumberer(),//自动行号
       { header: "客户编号",dataIndex: 'CustomerId' ,hidden:true},
       { header: "客户名称",dataIndex: 'ShortName' },
       { header: "联系人", dataIndex: 'LinkMan' },
       { header: "联系电话", dataIndex: 'LinkTel' },
       { header: "移动电话", dataIndex: 'LinkMobile' },
       { header: "传真", dataIndex: 'Fax' },
       { header: "配送类型",dataIndex: 'DistributionTypeText' },
       { header: "月用量", dataIndex: 'MonthQuantity' },
       { header: "客商", dataIndex: 'IsCust' ,renderer:{ fn:function(v){ if(v==1)return '是';return '否'}}},
       { header: "供应商", dataIndex: 'IsProvide',renderer:{ fn:function(v){ if(v==1)return '是';return '否'}}},
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
