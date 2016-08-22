<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmProvideStock.aspx.cs" Inherits="SCM_frmProvideStock" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>无标题页</title>
<link rel="stylesheet" type="text/css" href="../ext3/resources/css/ext-all.css" />
<script type="text/javascript" src="../ext3/adapter/ext/ext-base.js"></script>
<script type="text/javascript" src="../ext3/ext-all.js"></script>
<script type="text/javascript" src="../js/ProductSelect.js"></script>
<%=getComboBoxSource() %>
<script type="text/javascript">
Ext.BLANK_IMAGE_URL = "../ext3/resources/images/default/s.gif";
Ext.onReady(function () {   

var cmbIsAddingList =new Ext.data.SimpleStore({
fields:['DicsCode','DicsName','OrderIndex'],
data:[['','无','1'],['false','原计划','2'],['true','追加计划','3']],
autoLoad: false});
/*第一个向导框，采购信息，年月日 */

//设置年度以及季度或月度信息
        function setNDValue(startDate)
        {
            //设置时间格式，把-改为/以便符合JavaScript的date格式
            while(startDate.indexOf("-")!=-1)
            {
                startDate = startDate.replace("-","/");
            }
            //组建Date格式数据
            startDate = new Date(Date.parse(startDate));
            //获取季度类型
            var selectValue = document.getElementById("PlanType").value;
            //设置年度信息
            Ext.getCmp("PlanYear").setValue(startDate.getFullYear());
            //判断计划类型
            if(selectValue=="月度计划")
            {
                //获取月度信息
                var month = startDate.getMonth();
                month+=1;
                Ext.getCmp("PlanMonth").setValue(month);
            }
            if(selectValue=="季度计划")
            {
                //获取月度信息
                var month = startDate.getMonth();
                month+=1;
                //把月度转换为季度信息
                var jd = parseInt(month/3)+1;
                //设置季度信息
                Ext.getCmp("PlanMonth").setValue(jd);
            }
        }
        
        //根据计划类型设置控件显示情况，以及数据源信息
        function setColumnVisible() {
            var selectValue = document.getElementById("PlanType").value;
            var cmbPlanMonth =Ext.getCmp("PlanMonth");//
            if(selectValue=="年度计划")
            {
                //Ext.getCmp("lableMonth").setVisible(false);
                Ext.getCmp("PlanMonth").setVisible(false);
                Ext.getCmp("PlanMonth").fieldLabel="";
                return;
            }
            if(selectValue=="月度计划")
            {
                Ext.getCmp("PlanMonth").setVisible(false);
                
                if(cmbPlanMonth.store == null)
                    cmbPlanMonth.store =new  Ext.data.SimpleStore();
                cmbPlanMonth.store.removeAll();
                cmbPlanMonth.store.add(cmbPlanMonthList.getRange());
                 
                 Ext.getCmp("PlanMonth").fieldLabel="月度";
                Ext.getCmp("PlanMonth").show();
                 cmbPlanMonth.setValue("");
                return;
            }
            if(selectValue=="季度计划")
            {
                Ext.getCmp("PlanMonth").setVisible(false);
                
                if(cmbPlanMonth.store == null)
                    cmbPlanMonth.store =new  Ext.data.SimpleStore();
                cmbPlanMonth.store.removeAll();
                cmbPlanMonth.store.add(cmbPlanQuarteList.getRange());
                cmbPlanMonth.setValue("");
                Ext.getCmp("PlanMonth").show();
                 Ext.getCmp("PlanMonth").fieldLabel="季度";
                return;
            }
        }
        
        //检查第一个界面的输入情况
        function checkFirstPanel()
        {
            var selectValue = document.getElementById("PlanType").value;
            if(selectValue=="")
           {
                Ext.Msg.alert("系统提示","计划类型必须选择！");
                return false;
           }
           var year = document.getElementById("PlanYear").value;
           if(year=="")
           {
                Ext.Msg.alert("系统提示","计划年度必须选择！");
                return false;
           }
           if(Ext.getCmp("PlanMonth").Visible)
           {
                if(Ext.getCmp("PlanMonth").getValue()=="")
                {
                    Ext.Msg.alert("系统提示","月度或季度必须选择！");
                        return false;
                }
           }
           return true;
            
        }
   this.firstPanel = new Ext.Panel({   
        frame: true,   
        title: '采购信息',
        layout:"form",
        items:[
        {
				    xtype: 'combo',
				    fieldLabel: '计划类型',
				    columnWidth: 0.33,
				    anchor: '95%',
				    name: 'PlanType',
				    id: 'PlanType',
				    triggerAction: 'all',
				    mode: 'local',
				    editable:false,
				    store: cmbPlanTypeList,
				    displayField: 'DicsName',
				    valueField: 'DicsCode',
				    listeners: {
				        "select": setColumnVisible//,
				        //"focus":new function(){alert('X');}
				    }
				},{
				    xtype: 'combo',
				    fieldLabel: '年度',
				    columnWidth: 0.33,
				    anchor: '95%',
				    name: 'PlanYear',
				    id: 'PlanYear',
				    editable:false,
				    triggerAction: 'all',
				    mode: 'local',
				    store: cmbPlanYearList,
				    displayField: 'DicsName',
				    valueField: 'DicsCode'
				},{
    				    xtype: 'combo',
    				    anchor: '80%',
    				    name: 'PlanMonth',
    				    id: 'PlanMonth',
    				    editable:false,
    			        triggerAction: 'all',
    				    mode: 'local',
    				    displayField: 'DicsName',
    				    valueField: 'DicsCode'
    				    //hidden: true,
    				    //hideLabel:true
    				},{
    				    xtype: 'combo',
    				    anchor: '80%',
    				    name: 'IsAdding',
    				    id: 'IsAdding',
    				    fieldLabel: '追补计划',
    				    triggerAction: 'all',
    				    mode: 'local',
    				    displayField: 'DicsName',
    				    valueField: 'DicsCode',
    				    editable:false,
    				    store:cmbIsAddingList
    				}]
  
    }); 
    
  /*采购订单选择*/
  
  /*------开始获取数据的函数 start---------------*/
            var planeGridData = new Ext.data.Store
({
    url: 'frmProvideStock.aspx?method=getpurchplanlist',
    baseParams:{action:action},
    reader: new Ext.data.JsonReader({
        totalProperty: 'totalProperty',
        root: 'root'
    }, [
	{
	    name: 'PlanId'
	},
	{
	    name: 'PlanNo'
	},
	{
	    name: 'PlanName'
	},
	{
	    name: 'OrgId'
	},{
	    name: 'OrgName'
	},
	{
	    name: 'PlanType'
	},
	{
	    name: 'StartDate'
	},
	{
	    name: 'EndDate'
	},
	{
	    name: 'Status'
	},
	{
	    name: 'TotalQty'
	},
	{
	    name: 'DtlCount'
	},
	{
	    name: 'Remark'
	},
	{
	    name: 'CreateDate'
	},
	{
	    name: 'OperId'
	},
	{
	    name: 'UpdateDate'
	},
	{
	    name: 'OwnerId'
	},
	{
	    name: 'IsActive'
}]) 
	,
    listeners: 
	{
	    scope: this,
	    load: function() {
	    }
	}
});

function getDefaultFilter()
{
    var json = "";
                defaultFilter.each(function(defaultFilter) {
                    json += Ext.util.JSON.encode(defaultFilter.data) + ',';
                });
                json = json.substring(0, json.length - 1);
   return json;
}
            
            function cmbStatus(val)
            {
                var index = cmbStatusList.find('OrderIndex', val);
                    if (index < 0)
                        return "";
                    var record = cmbStatusList.getAt(index);
                    return record.data.DicsName;
            }
            
            function cmbType(val)
            {
                var index = cmbPlanTypeList.find('DicsCode', val);
                    if (index < 0)
                        return "";
                    var record = cmbPlanTypeList.getAt(index);
                    return record.data.DicsName;
            }
            
            function renderDate(value)
            {
                var reDate = /\d{4}\/\d{2}\/\d{2}/gi;
                return value.match(reDate);
            }

            /*------获取数据的函数 结束 End---------------*/

            /*------开始DataGrid的函数 start---------------*/

            var sm = new Ext.grid.CheckboxSelectionModel({
                singleSelect: false
            });
            var planeGrid = new Ext.grid.GridPanel({
                width: '100%',
//                height: '100%',
                autoWidth: true,
//                autoHeight: true,
                autoScroll: true,
                layout: 'fit',
                id: 'planeGrid',
                store: planeGridData,
                loadMask: { msg: '正在加载数据，请稍侯……' },
                sm: sm,
                cm: new Ext.grid.ColumnModel([
		sm,
		new Ext.grid.RowNumberer(), //自动行号
		{
		    header: '上报单位',
		    dataIndex: 'OrgName',
		    id: 'OrgName'
		},
		{
		    header: '计划类型',
		    dataIndex: 'PlanType',
		    id: 'PlanType',
		    renderer:cmbType
		},
		{
		    header: '计划开始日期',
		    dataIndex: 'StartDate',
		    id: 'StartDate',
		    renderer: renderDate
		},
		{
		    header: '计划结束日期',
		    dataIndex: 'EndDate',
		    id: 'EndDate',
		    renderer: renderDate
		},
		{
		    header: '状态',
		    dataIndex: 'Status',
		    id: 'Status',
		    renderer:cmbStatus
		}]),
                bbar: new Ext.PagingToolbar({
                    pageSize: 1000,
                    store: planeGridData,
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
            
    this.secondPanel = new Ext.Panel({   
        frame: true,   
        title: '采购订单选择',   
        items:[planeGrid]
  
    }); 
    
    /*盐信息树 */
    var root = new Ext.tree.AsyncTreeNode({
            text: '商品信息',
            draggable: false,
            id: 'source'
        });
        selectProductTree = new Ext.tree.TreePanel({//就是用来呈现树的"控件"吧
            //el: "divTree",//在page中用来渲染的标签(容器)
            rootVisible: false,
            autoScroll: true,
            id: 'selectProductTree',
            loader: new Ext.tree.TreeLoader({
                //dataUrl: url, // 'frmAdmProductList.aspx?method=gettreecolumnlist&parent=' + parentID,
                dataUrl:'frmProvideStock.aspx?method=getsmallclasstreenode'
            }),

            root: root
        });
        
        selectProductTree.on('checkchange', function(node, checked) {
                    //node.expand();
                    node.attributes.checked = checked;
                    node.eachChild(function(child) {
                        child.ui.toggleCheck(checked);
                        child.attributes.checked = checked;
                        child.fireEvent('checkchange', child, checked);
                    });
                }, selectProductTree);
        function getSelectedSmallTreeNode(node)
        {
//            if(node.attributes.NodeType=="small")
//            {
//                if(smallIds.length>0)
//                    smallIds+=",";
//                smallIds+=node.id;
//            }
//            for(var i=0;i<node.childNodes.length;i++)
//            {
//                getSelectedSmallTreeNode(node.childNodes[i]);
//            }
            var selectNodes = selectProductTree.getChecked();
            smallIds = "";
            for (var i = 0; i < selectNodes.length; i++) {
                if(selectNodes[i].attributes.NodeType=="small")
                {
                    if (smallIds.length > 0)
                        smallIds += ",";
                    smallIds += selectNodes[i].id;
                }
            } 
            return smallIds;    
        }
    this.threePanel = new Ext.Panel({   
        frame: true,   
        title: '盐类别选择', 
        autoScroll: true,  
        items:[selectProductTree]
  
    }); 
    
    /*Customer列表信息 */
    
    /* ----------------定义datagrid列表json格式 ----------*/
            var customerListStore = new Ext.data.Store
			({
			    url: 'frmProvideStock.aspx?method=getcus',
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
			   ,
			    listeners:
			      {
			          scope: this,
			          load: function() {
                            //数据加载预处理,可以做一些合并、格式处理等操作
			          }	          
			      }
			});
			
			
    var sm= new Ext.grid.CheckboxSelectionModel(
            {
            singleSelect : false
            }
        );
        var CustomerGrid = new Ext.grid.GridPanel({
                        width:'100%',
//                        height:'100%',
                        autoWidth:true,
                        autoScroll:true,
                        layout: 'fit',
                        id: 'CustomerGrid',
                        store: customerListStore,
                        loadMask: {msg:'正在加载数据，请稍侯……'},
                        sm:sm,
                        /*  如果中间没有查询条件form那么可以直接用tbar来实现增删改
                        tbar:[{
                            text:"添加",
                            handler:this.showAdd,
                            scope:this
                        },"-",
                        {
                            text:"修改"
                        },"-",{
                            text:"删除",
                            handler:this.deleteBranch,
                            scope:this
                        }],
                        */
                        cm: new Ext.grid.ColumnModel([
                        sm,
                        
                        new Ext.grid.RowNumberer(),//自动行号
                        
			      { header: "客户ID",dataIndex: 'CustomerId' ,hidden:true,hideable:false},
			      { header: "客户编号", width: 60, sortable: true, dataIndex: 'CustomerNo' },
			      { header: "客户名称", width: 60, sortable: true, dataIndex: 'ShortName' },
			      { header: "联系人", width: 30, sortable: true, dataIndex: 'LinkMan' },
			      { header: "联系电话", width: 30, sortable: true, dataIndex: 'LinkTel' },
			      { header: "移动电话", width: 30, sortable: true, dataIndex: 'LinkMobile' ,hidden:true,hideable:false},
			      { header: "传真", width: 30, sortable: true, dataIndex: 'Fax' ,hidden:true,hideable:false}		      
			  ]),
                        bbar: new Ext.PagingToolbar({
                            pageSize: 1000,
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
                        height: 250,
                        closeAction: 'hide', 
                        stripeRows: true,
                        loadMask: true,
                        autoExpandColumn: 2
                    });
                    
    this.fourPanel = new Ext.Panel({   
        frame: true,   
        title: '供应商选择',   
        items:[CustomerGrid]
  
    }); 
    var i = 0;   
    function cardHandler(direction) {
        if (direction == -1) {   
            i--;   
            if (i < 0) {   
                i = 0;   
            }   
        }   
        if (direction == 1) {   
            i++;   
            if (i > 3) {   
                i = 3;   
                return false;   
            }   
        }           
        switch(i)
        {
            case 0:
                
                break;
                //采购计划,设置过滤条件，获取采购数据
            case 1:
                if(direction==1)
                {
                    if(!checkFirstPanel())
                    {
                        i=0;
                       return;
                     }
                    if(planeGridData.baseParams.PlanType !=Ext.getCmp("PlanType").getValue()
                        ||planeGridData.baseParams.PlanYear!=Ext.getCmp("PlanYear").getValue()
                        ||planeGridData.baseParams.PlanMonth!=Ext.getCmp("PlanMonth").getValue()
                        ||planeGridData.baseParams.IsAdding!=Ext.getCmp("IsAdding").getValue())
                     {
                        planeGridData.baseParams.PlanType =Ext.getCmp("PlanType").getValue();
                        planeGridData.baseParams.PlanYear=Ext.getCmp("PlanYear").getValue();
                        planeGridData.baseParams.PlanMonth=Ext.getCmp("PlanMonth").getValue();
                        planeGridData.baseParams.IsAdding=Ext.getCmp("IsAdding").getValue();
                        planeGridData.load();
                    }
                }
                
                break;
             case 2:
                var sm = Ext.getCmp('planeGrid').getSelectionModel();
                if(direction==1)
                {
                    if(selectProductTree.loader.baseParams.PlanIds!=getSelectedPlans())
                    {
                        selectProductTree.loader.baseParams.PlanIds = getSelectedPlans();
                        selectProductTree.loader.load(selectProductTree.root,function(){}); 
                    }                   
                }
                
                break;
            case 3:
                if(direction==1)
                {
                    var smallIds = getSelectedSmallTreeNode();
                    if(customerListStore.baseParams.SmallId!=smallIds)
                    {
                        customerListStore.baseParams.SmallId=smallIds;
                        customerListStore.load();
                    }
                }
                break;

                
        }        
        setButtonShow(i);
        this.cardPanel.getLayout().setActiveItem(i);   
    };  
    
    function getSelectedOrgs()
    {
        var sm = Ext.getCmp('planeGrid').getSelectionModel();
                    //获取选择的数据信息
                    var selectData = sm.getSelections();
         var ids="";
          for(var i=0;i<selectData.length;i++)
                {
                    if(ids.length>0)
                        ids+=",";
                    ids+=selectData[i].get("OrgId");
                }
         return ids;
    }
    
    function getSelectedPlans()
    {
        var sm = Ext.getCmp('planeGrid').getSelectionModel();
                    //获取选择的数据信息
                    var selectData = sm.getSelections();
         var ids="";
          for(var i=0;i<selectData.length;i++)
                {
                    if(ids.length>0)
                        ids+=",";
                    ids+=selectData[i].get("PlanId");
                }
         return ids;
    }
    
    function getSelectedCustomers()
    {
         var sm = Ext.getCmp('CustomerGrid').getSelectionModel();
                    //获取选择的数据信息
         var selectData = sm.getSelections();
         var ids="";
          for(var i=0;i<selectData.length;i++)
                {
                    if(ids.length>0)
                        ids+=",";
                    ids+=selectData[i].get("CustomerId");
                }
         return ids;
    }
    
    function setButtonShow(index)
    {
        var btnNext = Ext.getCmp("move-next");   
        var btnPrev = Ext.getCmp("move-prev");   
        var btnSave = Ext.getCmp("move-save"); 
        switch(index)
        {
            case 0:
                btnSave.hide();   
                btnNext.enable();   
                btnPrev.disable(); 
            break;
            case 1:
            case 2:
                btnSave.hide();   
                btnNext.enable();   
                btnPrev.enable(); 
            break;
            case 3:
                btnSave.show();   
                btnNext.disable();   
                btnPrev.enable(); 
                break;
        }
        
    }
    
  
    //CARD总面板   
    this.cardPanel = new Ext.Panel({   
        frame: true,   
        title: '采购订单创建向导',   
        renderTo: "cardPanel",   
        height: 400,   
        width: 600,   
        layout: 'card',   
        activeItem: 0,   
        bbar: ['->', {   
            id: 'move-prev',   
            text: '上一步',   
            handler: cardHandler.createDelegate(this, [-1])   
        },   
        {   
            id: 'move-save',   
            text: '创建',   
            hidden: true,   
            handler: function () {   
                var orgs = getSelectedOrgs();
                var provides=    getSelectedCustomers();
                var smallid = getSelectedSmallTreeNode();
                var planIds = getSelectedPlans();
                var src = 'frmProvidePurch.aspx?orgs='+orgs+'&provides='+provides+'&smallid='+smallid+'&planids='+planIds;
                if(document.getElementById("iframeCreate").src.indexOf(src)==-1)
                {
                    document.getElementById("iframeCreate").src =src+"&"+Math.random();          
                }
                cardPanel.hide();
                //document.getElementById("cardPanel").style.display="none";
                document.getElementById("createPanel").style.display="";
            }   
        },   
        {   
            id: 'move-next',   
            text: '下一步',   
            handler: cardHandler.createDelegate(this, [1])   
        }],   
        items: [this.firstPanel, this.secondPanel,this.threePanel,fourPanel]   
    });  
    cardPanel.show(); 
    
    
         this.createWin = new Ext.Panel({
          //width:// 100
          renderTo: "createPanel"
          ,height:screen.availHeight-300
          ,isTopContainer : true
          , constrain: true
	      ,closeAction:'hide'
	      , resizable: false
          ,modal : true
          ,resizable: false
          ,hide:true
          ,html:"<iframe id='iframeCreate' width='100%' height='100%' src=''></iframe>"
          , buttons: [{
		    text: "返回"
			, handler: function() {
			    cardPanel.show();
                document.getElementById("createPanel").style.display="none";
                //document.getElementById("cardPanel").style.display="";
			}
			, scope: this
		    }]
          
       });
       
       
});  
</script>
</head>
<body>
    <form id="form1" runat="server">
    <div id="cardPanel">    
    </div>
    <div id="createPanel" style="display:none;width:100%;height:100%"></div>
    </form>
</body>
</html>
