/**** 1.客户过滤框 start ******/
var customerSelectWin = null;
var customerSearchForm= null;
var tree = null;
var customerSListStore = null;
var customerSGrid = null;
var tmppanel = null;
var newdiv = null;
var cWidth = 700;
var cHeight = 400;
/**调用方法之参数***
callbackfn: 回调方法
orgId: 组织编号
showcheck:是否显示选择框
********************/
function getCustomerInfo( callbackfn,orgId,showcheckbox,width,height){
    if(newdiv == null){
        newdiv = document.createElement('div');
        newdiv.setAttribute('id', 'treeDiv');
        Ext.getBody().appendChild(newdiv); 
    }
    if(undefined==showcheckbox) showcheckbox='';
    if(undefined!=width) cWidth=width;
    if(undefined!=height) cHeight=height;
    if(showcheckbox == true)
        showcheckbox = "&ShowCheckBox=true";
    var Tree = Ext.tree;
    if( tree == null){
        tree = new Tree.TreePanel({
            el:'treeDiv',
            region:'west',
            style: 'margin-left:0px',
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
               dataUrl:'/crm/DefaultFind.aspx?method=getLineTreeByOrg&OrgId='+orgId + showcheckbox
               })
        });
        tree.on('click',function(node){  
            if(node.id ==0)//||!node.isLeaf()
                return;
             refreshGrid(node.id);  
        }); 
        // set the root node
        var root = new Tree.AsyncTreeNode({
            text: '线路情况',
            draggable:false,
            id:'0'
        });
        tree.setRootNode(root);
    }
    
    if(customerSearchForm == null){
        var comboPanel = new Ext.form.ComboBox({
            style: 'margin-left:0px',
            cls: 'key',
            xtype: 'combo',
            name: 'comboid',
            id:'comboid',
            anchor: '90%',
            fieldLabel: '定位',
            store:[['CustomerNo','客户编号'],['ShortName','客户简称'],['ChineseName','客户名称'],['Address','客户地址']],
            triggerAction:'all',
            value:'CustomerNo',
            editable:false
        });
        var comValuePanel = new Ext.form.TextField({
            style: 'margin-left:0px',
            cls: 'key',
            xtype: 'textfield',
            name: 'combovalue',
            anchor: '90%',
            hideLabel:true,
            listeners: { specialkey: function(f, e) { if (e.getKey() == e.ENTER) { Ext.getCmp('searchcbtnId').focus(); } } }
        });

        customerSearchForm = new Ext.FormPanel({
            labelAlign: 'left',
            region:'north',
            buttonAlign: 'right',
            bodyStyle: 'padding:0px',
            frame: true,
            labelWidth: 45,
            height:40,
            items: [{
                layout: 'column',   //定义该元素为布局为列布局方式
                border: false,
                items: [{
                    columnWidth: .4,  //该列占用的宽度，标识为20％
                    layout: 'form',
                    border: false,
                    items: [
                    comboPanel
                    ]
                }, {
                    columnWidth: .3,
                    layout: 'form',
                    border: false,
                    items: [
                        comValuePanel
                        ]
                }, {
                    columnWidth: .1,
                    layout: 'form',
                    border: false,
                    items: [
                    { 
                        cls: 'key',
                        id: 'searchcbtnId',
                        xtype: 'button',
                        text: '过滤',
                        anchor: '50%',
                        handler :function(){                        
                            var combid=comboPanel.getValue();
                            var comboname=comValuePanel.getValue();
                            if(combid == null ||comboname =="")
                                return;
                            
                            customerSListStore.filterBy(function(record) {
                                return record.get(combid).indexOf(comboname)> -1;
                            });
                        }
                    }]
                }, {
                    columnWidth: .1,
                    layout: 'form',
                    border: false,
                    items: [
                    { 
                        cls: 'key',
                        xtype: 'button',
                        text: '重置',
                        anchor: '50%',
                        handler :function(){                                                    
                            comValuePanel.setValue('');
                            
                            customerSListStore.filterBy(function(record) {
                                return record.get(0) != -1;
                            });
                        }
                    }]
                }]
            }]
        });    
    }
        
    if(customerSListStore==null){
        customerSListStore = new Ext.data.Store({
            url: '/crm/DefaultFind.aspx?method=getLineCustomer',
			    reader: new Ext.data.JsonReader({
			        totalProperty: 'totalProperty',
			        root: 'root'
			    }, [
		    	{		name:'RelationId'	},
                {		name:'RouteId'	},
                {		name:'CustomerId'	},
                {		name:'CreateDate'	},
                {		name:'UpdateDate'	},
                {		name:'LinkMan'	},
                {		name:'LinkTel'	},
                {		name:'LinkMobile'	},
                {		name:'RouteNo'	},
                {		name:'RouteType'	},
                {		name:'RouteName'	},
                {		name:'CustomerNo'	},
                {		name:'ShortName'	},
                {		name:'ChineseName'	},
                {		name:'Address'	},
                {		name:'RouteTypeText'}	,
                {		name:'InvoiceType'}
	            ])	        
        });
    }
    if(customerSGrid==null){
        var smRel= new Ext.grid.CheckboxSelectionModel({
	        singleSelect:true
        });
        var customerSGrid = new Ext.grid.GridPanel({
        region:'center',
	    width:'100%',
	    height:'100%',
	    autoWidth:true,
	    autoScroll:true,
	    layout: 'fit',
	    id: '',
	    store: customerSListStore,
	    loadMask: {msg:'正在加载数据，请稍侯……'},
	    sm:smRel,
	    cm: new Ext.grid.ColumnModel([
		    smRel,
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
			    header:'客户编号',
			    dataIndex:'CustomerNo',
			    id:'CustomerNo'
		    },
		    {
			    header:'客户简称',
			    dataIndex:'ShortName',
			    id:'ShortName'
		    },
		    {
			    header:'客户全称',
			    dataIndex:'ChineseName',
			    id:'ChineseName'
		    },
		    {
			    header:'客户地址',
			    dataIndex:'Address',
			    id:'Address'
		    },
		    {
			    header:'创建日期',
			    dataIndex:'CreateDate',
			    id:'CreateDate',
			    renderer: Ext.util.Format.dateRenderer('Y年m月d日')
		    }
		    ]),
		    viewConfig: {
			    columnsText: '显示的列',
			    scrollOffset: 20,
			    sortAscText: '升序',
			    sortDescText: '降序',
			    forceFit: true
		    },
		    //height: 280,
		    closeAction: 'hide',
		    stripeRows: true,
		    loadMask: true,
		    autoExpandColumn: 2
	    });
    }    
    if(tmppanel == null){
         tmppanel = new Ext.Panel({
            labelAlign: 'left',
            layout: 'border', 
            region:'center',
            bodyStyle: 'padding:0px',
            frame: true,
            items:[customerSearchForm,customerSGrid]    
        });
    }
    /*------结束tree的函数 end---------------*/
    //弹出一个window窗口
    if( customerSelectWin == null){
        customerSelectWin = new Ext.Window({
             title:'客户置详细信息',
             style: 'margin-left:0px',
             width:cWidth ,
             height:cHeight, 
             constrain:true,
             layout: 'border', 
             plain: true, 
             modal: true,
             closeAction: 'hide',
             autoDestroy :true,
             resizable:true,
             items: [tree,tmppanel] ,
             buttons: [
                {
                    text: "确定"
                    , handler: function() {
                        var sm = customerSGrid.getSelectionModel();
                        //获取选择的数据信息
                        var selectData = sm.getSelected();
                        if (selectData == null || selectData == "") {
                            Ext.Msg.alert("提示", "请选中需要编辑的信息！");
                            return;
                        }
                        callbackfn(selectData);
                        customerSelectWin.hide();
                    }
                    , scope: this
                },
                {
                    text: "关闭"
                    , handler: function() {
                        customerSelectWin.hide();
                    }
                    , scope: this
                }]
        });
        customerSelectWin.addListener("hide",function(){
                //customerSListStore.removeAll();
        });
        tree.root.reload();
    }

    customerSelectWin.show();
}

function refreshGrid(nodeId){
        customerSListStore.baseParams.RouteId = nodeId;
        customerSListStore.reload();
}
/**** 客户过滤框end ******/


/**** 2.产品过滤框 start ******/
var productSelectWin = null;
var productSearchForm= null;
var ptree = null;
var productSListStore = null;
var productSGrid = null;
var ptmppanel = null;
var newdiv = null;
function getProductInfo(callbackfn){
    if(newdiv == null){
        newdiv = document.createElement('div');
        newdiv.setAttribute('id', 'ptreeDiv');
        Ext.getBody().appendChild(newdiv);
    } 
    var Tree = Ext.tree;
    if(ptree == null){
        ptree = new Tree.TreePanel({
            el:'ptreeDiv',
            region:'west',
            useArrows:true,//是否使用箭头
            autoScroll:true,
            animate:true,
            width:'180',
            height:'100%',
            minSize: 130,
	        maxSize: 200,
            enableDD:false,
            frame:true,
            border: false,
            containerScroll: true, 
            loader: new Tree.TreeLoader({
               dataUrl:'/crm/DefaultFind.aspx?method=getptreelist'
            })
        });
        ptree.on('click',function(node){  
            if(node.id ==0)
                return;
             refreshpGrid(node.id);  
        }); 
        // set the root node
        var root = new Tree.AsyncTreeNode({
            text: '存货分类',
            draggable:false,
            id:'0'
        });
        ptree.setRootNode(root);
    }
    
    if(productSListStore==null){
        productSListStore = new Ext.data.Store({
            url:"/crm/DefaultFind.aspx?method=getClassProducts",
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
	            ])	        
        });
    }
    if(productSGrid == null){
        var smRel= new Ext.grid.CheckboxSelectionModel({
	        singleSelect:true
        });
        productSGrid = new Ext.grid.GridPanel({
            region:'center',
	        width:'100%',
	        height:'100%',
	        autoWidth:true,
	        autoScroll:true,
	        layout: 'fit',
	        id: '',
	        store: productSListStore,
	        loadMask: {msg:'正在加载数据，请稍侯……'},
	        sm:smRel,
	        cm: new Ext.grid.ColumnModel([
		        smRel,
		        new Ext.grid.RowNumberer(),//自动行号
		        {
			        header:'存货ID',
			        dataIndex:'ProductId',
			        id:'ProductId',
			        hidden: true,
                    hideable: false
		        },
		        {
			        header:'存货编号',
			        dataIndex:'ProductNo',
			        id:'ProductNo'
		        },
		        {
			        header:'助记码',
			        dataIndex:'MnemonicNo',
			        id:'MnemonicNo'
		        },
		        {
			        header:'存货名称',
			        dataIndex:'ProductName',
			        id:'ProductName'
		        },
		        {
			        header:'规格',
			        dataIndex:'SpecificationsText',
			        id:'SpecificationsText'
		        },
		        {
			        header:'计量单位',
			        dataIndex:'UnitText',
			        id:'UnitText'
		        }
		        ]),
		        bbar: new Ext.PagingToolbar({
			        pageSize: 20,
			        store: productSListStore,
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
    }	
    if(productSearchForm == null){
        var comboPanel = new Ext.form.ComboBox({
            style: 'margin-left:0px',
            cls: 'key',
            xtype: 'combo',
            name: 'comboid',
            id:'comboid',
            anchor: '90%',
            fieldLabel: '定位',
            store:[['ProductNo','存货编号'],['ProductName','存货名称'],['MnemonicNo','助记码']],
            triggerAction:'all',
            value:'ProductNo',
            editable:false
        });
        var comValuePanel = new Ext.form.TextField({
            style: 'margin-left:0px',
            cls: 'key',
            xtype: 'textfield',
            name: 'combovalue',
            anchor: '90%',
            hideLabel:true,
            listeners: { specialkey: function(f, e) { if (e.getKey() == e.ENTER) { Ext.getCmp('searchcptnId').focus(); } } }
        });

        productSearchForm = new Ext.FormPanel({
            labelAlign: 'left',
            region:'north',
            buttonAlign: 'right',
            bodyStyle: 'padding:0px',
            frame: true,
            labelWidth: 30,
            height:40,
            items: [{
                layout: 'column',   //定义该元素为布局为列布局方式
                border: false,
                items: [{
                    columnWidth: .4,  //该列占用的宽度，标识为20％
                    layout: 'form',
                    border: false,
                    items: [
                    comboPanel
                    ]
                }, {
                    columnWidth: .3,
                    layout: 'form',
                    border: false,
                    items: [
                        comValuePanel
                        ]
                }, {
                    columnWidth: .1,
                    layout: 'form',
                    border: false,
                    items: [
                    { 
                        cls: 'key',
                        id: 'searchcptnId',
                        xtype: 'button',
                        text: '过滤',
                        anchor: '50%',
                        handler :function(){                        
                            var combid=comboPanel.getValue();
                            var comboname=comValuePanel.getValue();
                            if(combid == null ||comboname =="")
                                return;
                            
                            productSListStore.filterBy(function(record) {
                                return record.get(combid).indexOf(comboname)> -1;
                            });
                        }
                    }]
                }, {
                    columnWidth: .1,
                    layout: 'form',
                    border: false,
                    items: [
                    { 
                        cls: 'key',
                        xtype: 'button',
                        text: '重置',
                        anchor: '50%',
                        handler :function(){                                                    
                            comValuePanel.setValue('');
                            
                            productSListStore.filterBy(function(record) {
                                return record.get(0) != -1;
                            });
                        }
                    }]
                }]
            }]
        });    
    }
    if(ptmppanel == null){
	    ptmppanel = new Ext.Panel({
            labelAlign: 'left',
            layout: 'border', 
            region:'center',
            bodyStyle: 'padding:0px',
            frame: true,
            items:[productSearchForm,productSGrid]    
        });
    }
	//弹出一个window窗口
    if( productSelectWin == null){
        productSelectWin = new Ext.Window({
             title:'存货类别商品配置详细信息',
             id:'pcfgWin',
             width:700 ,
             height:400, 
             constrain:true,
             layout: 'border', 
             plain: true, 
             modal: true,
             closeAction: 'hide',
             autoDestroy :true,
             resizable:true,
             items: [ptree,ptmppanel] ,
             buttons: [
                {
                    text: "确定"
                    , handler: function() {
                        var sm = productSGrid.getSelectionModel();
                        //获取选择的数据信息
                        var selectData = sm.getSelected();
                        if (selectData == null || selectData == "") {
                            Ext.Msg.alert("提示", "请选中需要编辑的信息！");
                            return;
                        }
                        callbackfn(selectData);
                        productSelectWin.hide();
                    }
                    , scope: this
                },{
                    text: "关闭"
                    , handler: function() {
                        productSelectWin.hide();
                    }
                    , scope: this
                }]
        });
        productSelectWin.addListener("hide",function(){
                //productSGrid.getStore().removeAll();
        });
        ptree.root.reload();
    }
    
    productSelectWin.show();    

}
function refreshpGrid(nodeId){
    productSListStore.baseParams.ClassId = nodeId;
    productSListStore.load({
        params:{
               limit:20,
               start:0
	        }
    });
}


/**** 产品过滤框end ******/