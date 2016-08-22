<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmDistributeRouteRel.aspx.cs" Inherits="SCM_frmDistributeRouteRel" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>线路客户维护</title>
    <meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
    <link rel="stylesheet" type="text/css" href="../ext3/resources/css/ext-all.css" />
	<script type="text/javascript" src="../ext3/adapter/ext/ext-base.js"></script>	
	<script type="text/javascript" src="../ext3/ext-all.js"></script>
</head>
<body>
   <div id='tree-div'></div>
   <div id='searchDiv'></div>
   <div id ='sdetailForm'></div>
</body>

<%= getComboBoxStore() %>

<script type="text/javascript">
Ext.BLANK_IMAGE_URL = "../ext3/resources/images/default/s.gif";
Ext.onReady(function(){
    var currentRouteId;
    /*--------查询form定义 start  -----------*/    
    var searchForm = new Ext.form.FormPanel({
        labelAlign: 'right',
        layout: 'fit',
        buttonAlign: 'left',
        bodyStyle: 'padding:1px',
        height:65,
        title: '当前线路：<font color="blue">所有线路</font>',
        frame: true,        
        items: [
        {
            layout: 'column',   //定义该元素为布局为列布局方式
            border: false,
            items: [{
                    columnWidth: .3,  //该列占用的宽度，标识为20％
                    layout: 'form',
                    border: false,
                    labelWidth: 55,
                    items: [{
                        xtype:'textfield',
			            fieldLabel:'客户编号',
			            columnWidth:1,
			            anchor:'90%',
			            name:'CustomerNo',
			            id:'CustomerNo'
                    }]
                }, {
                    columnWidth: .3,
                    layout: 'form',
                    labelWidth: 55,
                    border: false,
                    items: [{
                        xtype:'textfield',
			            fieldLabel:'客户名称',
			            columnWidth:1,
			            anchor:'90%',
			            name:'CustomerName',
			            id:'CustomerName'
                    }]
                },
                {
                    columnWidth: .2,
                    layout: 'form',
                    border: false,
                    items: [{ cls: 'key',
                        xtype: 'button',
                        text: '查询',
                        id: 'searchebtnId',
                        anchor: '50%',
                        handler: function() {        
                            dsGridRouteCustomer.baseParams.CustomerNo = Ext.getCmp("CustomerNo").getValue();
                            dsGridRouteCustomer.baseParams.CustomerName = Ext.getCmp("CustomerName").getValue();
                            dsGridRouteCustomer.load({
                                params : {
                                start : 0,
                                limit : 10
                                } 
                             }); 
                        } 
                   }]   
                },
                {
                    columnWidth: .1,
                    layout: 'form',
                    border: false
                }]
        }]
    });
    /*--------查询form定义 end  -----------*/
    
    /*------实现tree的函数 start---------------*/
    var Tree = Ext.tree;
    var tree = new Tree.TreePanel({
        el:'tree-div',
        useArrows:true,
        autoScroll:true,
        animate:true,
        autoWidth:true,
        autoHeight:true,
        enableDD:true,
        containerScroll: true, 
        loader: new Tree.TreeLoader({
           dataUrl:'frmDistributeRouteRel.aspx?method=getroutetreelist'
        }),
        dropConfig:{
            ddGroup: 'GridDD',// 从Grid到Tree。如果是Tree内部节点拖动，使用'TreeDD'      
            dropAllowed: true,
            notifyDrop: function(source, e, data) {
                if(this.lastOverNode.node.id == '0' || data.selections.length == 0)
                    return;    
//                if(!this.lastOverNode.node.leaf)   
//                    return;
                if(data.selections[0].data['RouteId']==this.lastOverNode.node.id)
                    return;
                //alert(this.lastOverNode.node.id ); //目标节点id 
                var srcList = new Array();
                for (i = 0; i < data.selections.length; i++) {
                    srcList [i] = data.selections[i].data['CustomerId'];
                }         
                //alert(srcList.length); //data: 来自Grid的数据         
                //TODO: 此处增加您想要的操作!  
                var confrimstr = "是否真的要将客户<font color='blue'>["+data.selections[0].data['CustomerNo']+"]"
                                +data.selections[0].data['ChineseName']
                                +"</font>，从线路：<font color='blue'>["+
                                + data.selections[0].data['RouteNo'] +"]"
                                + data.selections[0].data['RouteName'] 
                                +"</font>移至线路：<font color='blue'>"+ this.lastOverNode.node.text +"</font>？";
                Ext.Msg.confirm("提示信息",confrimstr,function callBack(id){
		        if(id=="yes")
		        {
			        //页面提交
			        Ext.Ajax.request({
				        url:'frmDistributeRouteRel.aspx?method=changeCustomerRoute',
				        method:'POST',
				        params:{
					        OldRouteId:data.selections[0].data['RouteId'],
					        CustomerId:data.selections[0].data['CustomerId'],
					        NewRouteId:this.lastOverNode.node.id
				        },
				        success: function(resp,opts){
				            data.grid.getStore().remove(data.selections[0]);
					        Ext.Msg.alert("提示","客户线路变更成功");
				        },
				        failure: function(resp,opts){
					        Ext.Msg.alert("提示","客户线路变更失败");
				        }
			        });
		        }
	        });
                this.cancelExpand(); 
                this.removeDropIndicators(this.lastOverNode); 
                return true;
            }, 
            onNodeOver : function(n, dd, e, data){
                var pt = this.getDropPoint(e, n, dd);
                var node = n.node;
                // auto node expand check
                if(!this.expandProcId && pt == "append" && node.hasChildNodes() && !n.node.isExpanded()){
                    this.queueExpand(node);
                }else if(pt != "append"){
                    this.cancelExpand();
                }
                // set the insert point style on the target node
                var returnCls = this.dropNotAllowed;
                if(this.isValidDropPoint(n, pt, dd, e, data)){
                    if(pt){
                        var el = n.ddel;
                        var cls;
                        returnCls = "x-tree-drop-ok-append";
                        cls = "x-tree-drag-append";
                        if(this.lastInsertClass != cls){
                            Ext.fly(el).replaceClass(this.lastInsertClass, cls);
                            this.lastInsertClass = cls;
                        }
                    }
                }
                return returnCls;
            } 
         }
    });
    tree.on('click',function(node){  
        if(node.id ==0)
            return;    
        currentRouteId = node.id;
        searchForm.setTitle("当前线路：<font color='blue'>"+node.text+"</font>");     
        dsGridRouteCustomer.baseParams.RouteId = node.id;
        dsGridRouteCustomer.load({
            params : {
            start : 0,
            limit : 10
            } 
         }); 
    }); 
    
    // set the root node
    var root = new Tree.AsyncTreeNode({
        text: '所有线路',
        draggable:false,
        id:'0'
    });
    tree.setRootNode(root);

    // render the tree
    tree.render();
    root.expand();
    /*------结束tree的函数 end---------------*/
        
    
    /*------详细信息form的函数 start---------------*/    
   /*------开始获取数据的函数 start---------------*/
var dsGridRouteCustomer = new Ext.data.Store
({
url: 'frmDistributeRouteRel.aspx?method=getRouteCustomerList',
reader:new Ext.data.JsonReader({
	totalProperty:'totalProperty',
	root:'root'
},[
	{		name:'RelationId'	},
	{		name:'RouteId'	},
	{		name:'CustomerId'	},
	{		name:'CreateDate'	},
	{		name:'UpdateDate'	},
	{		name:'OperId'	},
	{		name:'OrgId'	},
	{		name:'OwnerId'	},
	{		name:'RouteNo'	},
	{		name:'RouteType'	},
	{		name:'RouteName'	},
	{		name:'CustomerNo'	},
	{		name:'ShortName'	},
	{		name:'ChineseName'	},
	{		name:'Address'	},
	{		name:'RouteTypeText'}	
	])
	,
	listeners:
	{
		scope:this,
		load:function(){
		}
	}
});

/*------获取数据的函数 结束 End---------------*/
/*------开始获取数据的函数 start---------------*/
var dsGridRouteCustomer = new Ext.data.Store
({
url: 'frmDistributeRouteRel.aspx?method=getRouteCustomerList',
reader:new Ext.data.JsonReader({
	totalProperty:'totalProperty',
	root:'root'
},[
	{		name:'RelationId'	},
	{		name:'RouteId'	},
	{		name:'CustomerId'	},
	{		name:'CreateDate'	},
	{		name:'UpdateDate'	},
	{		name:'OperId'	},
	{		name:'OrgId'	},
	{		name:'OwnerId'	},
	{		name:'RouteNo'	},
	{		name:'RouteType'	},
	{		name:'RouteName'	},
	{		name:'CustomerNo'	},
	{		name:'ShortName'	},
	{		name:'ChineseName'	},
	{		name:'Address'	},
	{		name:'RouteTypeText'}	
	])
	,
	listeners:
	{
		scope:this,
		load:function(){
		}
	}
});

/*------获取数据的函数 结束 End---------------*/
/*------开始DataGrid的函数 start---------------*/
var smC= new Ext.grid.CheckboxSelectionModel({
	singleSelect:true
});
var routeCustomerGrid = new Ext.grid.GridPanel({
	width:document.body.offsetWidth,
	height:'100%',
	//autoWidth:true,
	autoHeight:true,
	autoScroll:true,
	layout: 'fit',
	enableDrag: true,
	store: dsGridRouteCustomer,
	loadMask: {msg:'正在加载数据，请稍侯……'},
	sm:smC,
	cm: new Ext.grid.ColumnModel([
		smC,
		new Ext.grid.RowNumberer(),//自动行号
		{
			header:'线路关联序号',
			dataIndex:'RelationId',
			id:'RelationId',
			hidden:true,
			hideable:false
		},
		{
			header:'线路序号',
			dataIndex:'RouteId',
			id:'RouteId',
			hidden:true,
			hideable:false
		},
		{
			header:'线路编号',
			dataIndex:'RouteNo',
			id:'RouteNo',
			width:70
		},
		{
			header:'线路名称',
			dataIndex:'RouteName',
			id:'RouteName',
			width:100
		},
		{
			header:'客户编号',
			dataIndex:'CustomerNo',
			id:'CustomerNo',
			width:70
		},
		{
			header:'客户简称',
			dataIndex:'ShortName',
			id:'ShortName',
			width:100
		},
		{
			header:'客户全称',
			dataIndex:'ChineseName',
			id:'ChineseName',
			width:180
		},
		{
			header:'客户地址',
			dataIndex:'Address',
			id:'Address',
			width:150
		},
		{
			header:'创建日期',
			dataIndex:'CreateDate',
			id:'CreateDate',
			width:100,
			renderer: Ext.util.Format.dateRenderer('Y年m月d日')
		}
		]),
		tbar:new Ext.Toolbar({
	        items:[{
		        text:"添加客户",
		        icon:"../Theme/1/images/extjs/customer/add16.gif",
		        handler:function(){		            
                    uploadCtmGridWindow.show();
		        }
		        },'-',{
		        text:"删除客户",
		        icon:"../Theme/1/images/extjs/customer/delete16.gif",
		        handler:function(){
		            deleteRouteCustomerRelInfo();
		        }
	        }]
        }),
		bbar: new Ext.PagingToolbar({
			pageSize: 10,
			store: dsGridRouteCustomer,
			displayMsg: '显示第{0}条到{1}条记录,共{2}条',
			emptyMsy: '没有记录',
			displayInfo: true
		}),
		viewConfig: {
			columnsText: '显示的列',
			scrollOffset: 20,
			sortAscText: '升序',
			sortDescText: '降序',
			forceFit: false
		},
		height: 280,
		closeAction: 'hide',
		stripeRows: true,
		loadMask: true
    });
    /*------详细信息form的函数 end---------------*/
    function deleteRouteCustomerRelInfo(){
        var sm = routeCustomerGrid.getSelectionModel();
        //var selectData = sm.getSelected();
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
                array[i] = records[i].get('RelationId');
            }
            Ext.Ajax.request({
            url: 'frmDistributeRouteRel.aspx?method=deleteRouteCustomerInfo',
                params: {
                RelationId: array.join('-')//传入多想的id串
                },
                success: function(resp, opts) {
                    //var data=Ext.util.JSON.decode(resp.responseText);
                    Ext.Msg.alert("提示", "删除成功！");
                    routeCustomerGrid.getStore().reload();
                },
                failure: function(resp, opts) {
                    Ext.Msg.alert("提示", "删除失败！");
                }
            });
        }

    }
    /*------实现searchForm的函数 start---------------*/
var nameRouteCustomerNoPanel = new Ext.form.TextField({
    style: 'margin-left:0px',
    cls: 'key',
    xtype: 'textfield',
    fieldLabel: '客户编号',
    name: 'name',
    anchor: '90%'
});
var nameRouteCustomerPanel = new Ext.form.TextField({
    style: 'margin-left:0px',
    cls: 'key',
    xtype: 'textfield',
    fieldLabel: '客户名称',
    name: 'name',
    anchor: '90%'
});
var searchRelForm = new Ext.form.FormPanel({
    labelAlign: 'left',
    region:'north',
    buttonAlign: 'right',
    bodyStyle: 'padding:5px',
    frame: true,
    height:50,
    labelWidth: 80,
    items: [{
        layout: 'column',   //定义该元素为布局为列布局方式
        border: false,
        items: [{
            columnWidth: .33,
            layout: 'form',
            border: false,
            items: [
                nameRouteCustomerNoPanel
                ]
        }, {
            columnWidth: .33,
            layout: 'form',
            border: false,
            items: [
                nameRouteCustomerPanel
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
                    var name = nameRouteCustomerPanel.getValue();
                    var no = nameRouteCustomerNoPanel.getValue();
                    //alert(name +":"+type);
                    dsRCustomerGrid.baseParams.ChineseName = name;
                    dsRCustomerGrid.baseParams.CustomerId = no;
                    dsRCustomerGrid.load({
                                params : {
                                start : 0,
                                limit : 10
                                } 
                              }); 
                    }
                }]
        },{
            columnWidth: .56,  //该列占用的宽度，标识为20％
            layout: 'form',
            border: false
        }]
    }]

});

/*------实现searchForm的函数 start---------------*/

/*------新增客户选择列表 start --------------*/
var dsRCustomerGrid;
if(dsRCustomerGrid==null){
    dsRCustomerGrid = new Ext.data.Store({
        url:"frmDistributeRouteRel.aspx?method=getNonCustomers",
        reader:new Ext.data.JsonReader({
            totalProperty:'totalProperty',
	        root:'root'},
	        [
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
}

var smRel= new Ext.grid.CheckboxSelectionModel({
	singleSelect:false
});
var rCustomerGrid = new Ext.grid.GridPanel({
	width:'100%',
	height:'100%',
	autoWidth:true,
	autoHeight:true,
	autoScroll:true,
	region: 'center',
	id: '',
	store: dsRCustomerGrid,
	loadMask: {msg:'正在加载数据，请稍侯……'},
	sm:smRel,
	cm: new Ext.grid.ColumnModel([
		smRel,
		new Ext.grid.RowNumberer(),//自动行号
	    { header: "客户ID",dataIndex: 'CustomerId' ,hidden:true,hideable:false},
        { header: "客户编号", width: 80, sortable: true, dataIndex: 'CustomerNo' },
        { header: "客户名称", width: 150, sortable: true, dataIndex: 'ShortName' },
        { header: "联系人", width: 60, sortable: true, dataIndex: 'LinkMan' },
        { header: "联系电话", width: 80, sortable: true, dataIndex: 'LinkTel' },
        { header: "创建时间", width: 80, sortable: true, dataIndex: 'CreateDate',
                    renderer: Ext.util.Format.dateRenderer('Y年m月d日') }
		]),
		bbar: new Ext.PagingToolbar({
			pageSize: 10,
			store: dsRCustomerGrid,
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
		loadMask: true
	});


/*------新增客户选择列表 end --------------*/

/*------开始客户配置界面数据的窗体 Start---------------*/
if(typeof(uploadCtmGridWindow)=="undefined"){//解决创建2个windows问题
	uploadCtmGridWindow = new Ext.Window({
		id:'Customerformwindow',
		title:'客户信息'
		, iconCls: 'upload-win'
		, width: 600
		, height: 400
		, layout: 'border'
		, plain: true
		, modal: true
		, constrain:true
		, resizable: false
		, closeAction: 'hide'
		,autoDestroy :true
		,items:[searchRelForm,rCustomerGrid]
		,buttons: [{
			text: "保存"
			, handler: function() {
				saveCustoemrData();
			}
			, scope: this
		},
		{
			text: "取消"
			, handler: function() { 
				uploadCtmGridWindow.hide();
			}
			, scope: this
		}]});
	}
	uploadCtmGridWindow.addListener("hide",function(){
	    searchRelForm.getForm().reset();
	    rCustomerGrid.getStore().removeAll();   
});
function saveCustoemrData(){
    if (currentRouteId <= 0) 
    {
        Ext.Msg.alert("提示", "请选择您要添加客户归属的线路！");
    }
    var sm = rCustomerGrid.getSelectionModel();
    //var selectData = sm.getSelected(); //这个仅仅是对getSelections.itemAt[0]的封装，对于多选不适用
    var records=sm.getSelections();
    
    if (records == null || records.length == 0) 
    {
        Ext.Msg.alert("提示", "请选中需要配置线路的客户！");
    }
    else 
    { 
        Ext.Msg.confirm("提示信息", "确认保存？", function callBack(id) {
            //判断是否删除数据
            if (id == "yes") {
                 var array = new Array(records.length);
                for(var i=0;i<records.length;i++)
                {
                    array[i] = records[i].get('CustomerId');
                }
                Ext.Ajax.request({
                url: 'frmDistributeRouteRel.aspx?method=saveCustomerRelInfo',
                    params: {
                        RouteId: currentRouteId ,
                        CustomerId: array.join('-')//传入多项的id串
                    },
                    success: function(resp, opts) {
                        //var data=Ext.util.JSON.decode(resp.responseText);
                        Ext.Msg.alert("提示", "保存成功！");
                        dsGridRouteCustomer.reload();
                        uploadCtmGridWindow.hide();
                    },
                    failure: function(resp, opts) {
                        Ext.Msg.alert("提示", "保存失败！");
                    }
                });
            }
         });   
    }
}
/*------结束客户配置界面数据的窗体 End---------------*/
/*------viewreport布局 start---------------*/
var leftPanel = new Ext.Panel({ 
      region:'west',
      id:'west-panel',
      title:'线路层级关系',
      //split:true,
      minSize: 175,
      maxSize: 400,
      //margins:'0 0 0 5',
      layout:'fit',                  
      height:500,
      autoScroll:true,
      width:200,
      layoutConfig:{
        animate:true
      }
      ,items:tree
  });
var rightPanel =	new Ext.Panel({
		region:'center',
        items:[{
	        layout:'column',
	        border: false,
	        items: [
	        {
		        layout:'form',
		        border: false,
		        columnWidth:1,
		        items: [
		            searchForm
		        ]
		     }]
		},{
		    layout:'column',
	        border: false,
	        items: [
	        {
		        layout:'form',
		        border: false,
		        columnWidth:1,
		        items: [
		            routeCustomerGrid
		        ]
		     }]
	    }]
	});

	var bottomPanel = new Ext.Panel(
	{
		region:'south'
	});
    var viewport = new Ext.Viewport({
          layout:'border',
          items:[bottomPanel,leftPanel,rightPanel]
      });
    
    /*------viewreport布局 end---------------*/

})
</script>
</html>
