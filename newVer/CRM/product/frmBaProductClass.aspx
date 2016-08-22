<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmBaProductClass.aspx.cs" Inherits="CRM_product_frmBaProductClass" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>存货分类商品对应关系维护</title>
    <meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
    <link rel="stylesheet" type="text/css" href="../../ext3/resources/css/ext-all.css" />
	<script type="text/javascript" src="../../ext3/adapter/ext/ext-base.js"></script>	
	<script type="text/javascript" src="../../ext3/ext-all.js"></script>
	<script type="text/javascript" src="../../js/operateResp.js"></script>
</head>
<body>
   <div id ='tree-div'></div>
   <div id ='toolbar'></div>
   <div id ='sdetailGridPanel'></div>
</body>
<script type="text/javascript">
Ext.onReady(function(){
var currentNodeId = 0;
var isPlanType=0;//存货分类
/*------实现tree的函数 start---------------*/
    Ext.BLANK_IMAGE_URL = "../../ext3/resources/images/default/s.gif";	
    var Tree = Ext.tree;
    var mytree = new Tree.TreePanel({
        el:'tree-div',
        useArrows:true,
        autoScroll:true,
        animate:true,
        autoWidth:true,
        autoHeight:true,
        enableDD:false,
        containerScroll: true, 
        loader: new Tree.TreeLoader({
           dataUrl:'frmBaProductClass.aspx?method=gettreelist',
           baseParams:{
                isPlanType:isPlanType,
                isAll:false
           }})
    });
    mytree.on('click',function(node){  
        if(node.id ==0)
            return;
         refreshGrid(node.id);  
    }); 
    // set the root node
    var root = new Tree.AsyncTreeNode({
        text: '存货分类',
        draggable:false,
        id:'0'
    });
    mytree.setRootNode(root);

    // render the tree
    mytree.render();
    root.expand();
    /*------结束tree的函数 end---------------*/

function refreshGrid(nodeId){
    currentNodeId = nodeId;
    productClassGrid.getStore().baseParams.ClassId= currentNodeId;
    productClassGrid.getStore().load({
        params:{
	           ClassId:currentNodeId,
	           start : 0,
               limit : 10
	        }
    });
}

/*------viewreport布局 start---------------*/

/*------开始DataGrid的函数 start---------------*/
var productClassGridData;
if(productClassGridData==null){
    productClassGridData = new Ext.data.Store({
        url:"frmBaProductClass.aspx?method=getClassProducts",
        reader:new Ext.data.JsonReader({
            totalProperty:'totalProperty',
	        root:'root'},
	        [
	            {
		            name:'ProductDtlId'
	            },
	            {
		            name:'ProductNo'
	            },
	            {
		            name:'ProductName'
	            },
	            {
		            name:'ClassId'
	            }
	        ])      
    });
}

var sm= new Ext.grid.CheckboxSelectionModel({
	singleSelect:false
});
var productClassGrid = new Ext.grid.GridPanel({
	el: 'sdetailGridPanel',
	width:'100%',
	height:'100%',
	autoWidth:true,
	autoHeight:true,
	autoScroll:true,
	layout: 'fit',
	id: '',
	store: productClassGridData,
	loadMask: {msg:'正在加载数据，请稍侯……'},
	sm:sm,
	cm: new Ext.grid.ColumnModel([
		sm,
		new Ext.grid.RowNumberer(),//自动行号
		{
			header:'流水号',
			dataIndex:'ProductDtlId',
			id:'ProductDtlId',
			hidden: true,
            hideable: false
		},
		{
			header:'存货编号',
			dataIndex:'ProductNo',
			id:'ProductNo'
		},
		{
			header:'存货名称',
			dataIndex:'ProductName',
			id:'ProductName'
		},
		{
			header:'存货分类编号',
			dataIndex:'ClassId',
			id:'ClassId',
			hidden: true,
            hideable: false
		}
		]),
		tbar: new Ext.Toolbar({
	        items:[{
		        text:"新增",
		        icon:"../../Theme/1/images/extjs/customer/add16.gif",
		        handler:function(){
                    openWindowShow();
		        }
		        },'-',{
		        text:"删除",
		        icon:"../../Theme/1/images/extjs/customer/delete16.gif",
		        handler:function(){
		            deleteProductClassInfo();
		        }
	        }]
        }),
		bbar: new Ext.PagingToolbar({
			pageSize: 10,
			store: productClassGridData,
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
productClassGrid.render();
/*------DataGrid的函数结束 End---------------*/
/*------实现toolbar的函数 start---------------*/
function openWindowShow(){
    uploadGridWindow.show();
}
function deleteProductClassInfo(){
    var sm = productClassGrid.getSelectionModel();
    //var selectData = sm.getSelected();
    var records=sm.getSelections();
    
    if (records == null || records.length == 0) 
    {
        Ext.Msg.alert("提示", "请选中一行！");
    }
    else 
    {   
        //删除前再次提醒是否真的要删除
	    Ext.Msg.confirm("提示信息","是否真的要删除选择的信息吗？",function callBack(id){
		    //判断是否删除数据
		    if(id=="yes")
		    {
                var array = new Array(records.length);
                for(var i=0;i<records.length;i++)
                {
                    array[i] = records[i].get('ProductDtlId');
                }
                Ext.Ajax.request({
                url: 'frmBaProductClass.aspx?method=deleteProductInfo',
                    params: {
                    ProductDtlId: array.join('-')//传入多想的id串
                    },
                    success: function(resp, opts) {
                        //var data=Ext.util.JSON.decode(resp.responseText);
                        Ext.Msg.alert("提示", "删除成功！");
                        productClassGrid.getStore().reload();
                    },
                    failure: function(resp, opts) {
                        Ext.Msg.alert("提示", "删除失败！");
                    }
                });
            }
        });
    }
    
}
/*------结束toolbar的函数 end---------------*/
/*------开始查询form的函数 start---------------*/
      var ProductNamePanel = new Ext.form.TextField({
            style: 'margin-left:0px',
            cls: 'key',
            xtype: 'textfield',
            fieldLabel: '存货编号或名称',
            anchor: '90%',
            listeners: { specialkey: function(f, e) { if (e.getKey() == e.ENTER) { Ext.getCmp('searchebtnId').focus(); } } }
        });

        var searchForm = new Ext.FormPanel({
            region:'north',
            labelAlign: 'left',
            layout: 'fit',
            buttonAlign: 'right',
            bodyStyle: 'padding:5px',
            frame: true,
            height:45,
            labelWidth: 100,
            items: [{
                layout: 'column',   //定义该元素为布局为列布局方式
                border: false,
                items: [ {
                    columnWidth: .45,
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
                        text: '模糊查询',
                        id: 'searchebtnId',
                        anchor: '50%',
                        handler: function() {
                            var ProductName = ProductNamePanel.getValue();

                            productGridData.baseParams.ClassName=ProductName;
                            productGridData.load({
                                params: {
                                    start: 0,
                                    limit: 10
                                }
                            });
                        }
                    }]
                },{
                    columnWidth: .5,  //该列占用的宽度，标识为20％
                    layout: 'form',
                    border: false
                }
                ]
            }]
        });


/*------开始查询form的函数 end---------------*/

/*------新增对应关系列表 start --------------*/
var productGridData;
if(productGridData==null){
    productGridData = new Ext.data.Store({
        url:"frmBaProductClass.aspx?method=getProducts",
        reader:new Ext.data.JsonReader({
            totalProperty:'totalProperty',
	        root:'root'},
	        [
	            {name:'ClassId'},
	            {name:'ClassNo'},
	            {name:'ClassName'},
	            {name:'SpecificationsText'},
	            {name:'UnitText'},
	            {name:'CreateDate'},
	            {name:'Remark'}
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
	autoHeight:true,
	autoScroll:true,
	layout: 'fit',
	id: '',
	store: productGridData,
	loadMask: {msg:'正在加载数据，请稍侯……'},
	sm:smRel,
	cm: new Ext.grid.ColumnModel([
		smRel,
		new Ext.grid.RowNumberer(),//自动行号
		{
			header:'流水号',
			dataIndex:'ClassId',
			id:'ClassId',
			hidden: true,
            hideable: false
		},
		{
			header:'商品编号',
			dataIndex:'ClassNo',
			id:'ClassNo'
		},
		{
			header:'商品名称',
			dataIndex:'ClassName',
			id:'ClassName'
		},
		{
			header:'规格',
			dataIndex:'SpecificationsText',
			id:'SpecificationsText'
		},
		{
			header:'单位',
			dataIndex:'UnitText',
			id:'UnitText'
		},
		{
			header:'创建日期',
			dataIndex:'CreateDate',
			id:'CreateDate',
			renderer: Ext.util.Format.dateRenderer('Y年m月d日')
		}
		]),
		bbar: new Ext.PagingToolbar({
			pageSize: 10,
			store: productGridData,
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


/*------新增对应关系列表 start --------------*/

/*------WindowForm 配置开始------------------*/
if (typeof (uploadGridWindow) == "undefined") {//解决创建2个windows问题
    uploadGridWindow = new Ext.Window({
        id: 'gridwindow',
        title: "新增商品对应"
        , iconCls: 'upload-win'
        , width: 750
        , height: 450
        , layout: 'border'
        , plain: true
        , modal: true
        , constrain: true
        , resizable: false
        , closeAction: 'hide'
        , autoDestroy: true
        , items: [searchForm,productGrid]
        , buttons: [{
             id: 'savebuttonid'
            , text: "保存"
            , handler: function() {
                 saveUserData();
            }
            , scope: this
        },
        {
            text: "取消"
            , handler: function() {
                uploadGridWindow.hide();
            }
            , scope: this
        }]
    });
 }

uploadGridWindow.addListener("hide", function() {
    searchForm.getForm().reset();
    productGrid.getStore().removeAll();
});
        
function saveUserData() 
{    
    var sm = productGrid.getSelectionModel();
    //var selectData = sm.getSelected(); //这个仅仅是对getSelections.itemAt[0]的封装，对于多选不适用
    var records=sm.getSelections();
    
    if (records == null || records.length == 0) 
    {
        Ext.Msg.alert("提示", "请选中一行！");
    }
    else 
    {          
        var array = new Array(records.length);
        for(var i=0;i<records.length;i++)
        {
            array[i] = records[i].get('ClassId');
        }
        Ext.Ajax.request({
        url: 'frmBaProductClass.aspx?method=saveProductRelInfo',
            params: {
                ClassId: currentNodeId ,
                ProductId: array.join('-')//传入多想的id串
            },
            success: function(resp, opts) {
                //var data=Ext.util.JSON.decode(resp.responseText);
                if(checkExtMessage(resp))
                {
                    productClassGrid.getStore().reload();
                    uploadGridWindow.hide();
                }
            },
            failure: function(resp, opts) {
                Ext.Msg.alert("提示", "保存失败！");
            }
        });
    }
}
/*------WindowForm 配置开始------------------*/
var leftPanel = new Ext.Panel({ 
              region:'west',
              id:'west-panel',
              title:'分类层级关系',
              //split:true,
              minSize: 175,
	          maxSize: 400,
	          //margins:'0 0 0 5',
	          layout:'fit',
              height:800,
              autoScroll:true,
              width:200,
              layoutConfig:{
	            animate:true
	          }
              ,items:mytree
          });
var rightPanel =	new Ext.Panel({
		region:'center',
        items:productClassGrid
});

var bottomPanel = new Ext.Panel(
{
	region:'south'
});
var viewport = new Ext.Viewport({
      layout:'border',
      items:[bottomPanel,leftPanel,rightPanel
       ]
  });

});
</script>
</html>
