<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmProvideProductMessage.aspx.cs" Inherits="SCM_frmProvideProductMessage" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>无标题页</title>
<link rel="stylesheet" type="text/css" href="../ext3/resources/css/ext-all.css" />
<script type="text/javascript" src="../ext3/adapter/ext/ext-base.js"></script>
<script type="text/javascript" src="../ext3/ext-all.js"></script>
<script type="text/javascript" src="../js/ProductSelect.js"></script>
<script type="text/javascript" src="../js/ExtJsHelper.js"></script>
<script type="text/javascript" src="../js/operateResp.js"></script>
<%=getComboBoxSource()%>
    <script>

Ext.onReady(function () {   
Ext.BLANK_IMAGE_URL = "../ext3/resources/images/default/s.gif"
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
    				}]
  
    }); 
    
    /*采购订单选择，这边出现还没有产生要货信息的采购计划*/
  
  /*------开始获取数据的函数 start---------------*/
            var planeGridData = new Ext.data.Store
({
    url: 'frmProvideProductMessage.aspx?method=getpurchplanlist',
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
                var reDate = /\d{4}\-\d{2}\-\d{2}/gi;
                return value.match(reDate);
            }

            /*------获取数据的函数 结束 End---------------*/

/*------开始ToolBar事件函数 start---------------*/
//查看要货情况信息
  var provideWin=null;
        
        function viewProvidePlan()
        {
            var sm = Ext.getCmp('planeGrid').getSelectionModel();
            //获取选择的数据信息
            var selectData = sm.getSelected();
            if (selectData == null) {
                Ext.Msg.alert("提示", "请选中需要查看的信息！");
                return;
            }
            if(provideWin==null)
            {
                provideWin=ExtJsShowWin("供应商要货情况","frmPurchProvidePlan.aspx?PlanId="+selectData.data.PlanId+"&"+Math.random(),"provide",800,450);
            }
            else
            {
                document.getElementById("iframeprovide").src="frmPurchProvidePlan.aspx?PlanId="+selectData.data.PlanId+"&"+Math.random();
            }
            provideWin.show();
        }
        
            /*------开始DataGrid的函数 start---------------*/

            var sm = new Ext.grid.CheckboxSelectionModel({
                singleSelect: false
            });
            var planeGrid = new Ext.grid.GridPanel({
                width: '100%',
                height: '100%',
                autoWidth: true,
                autoHeight: true,
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
		    header: '公司名称',
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
		    renderer: Ext.util.Format.dateRenderer('Y年m月d日')
		},
		{
		    header: '计划结束日期',
		    dataIndex: 'EndDate',
		    id: 'EndDate',
		    renderer: Ext.util.Format.dateRenderer('Y年m月d日')
		},
		{
		    header: '状态',
		    dataIndex: 'Status',
		    id: 'Status',
		    renderer:cmbStatus
		}]),
		tbar : [{
                    id : 'btnSave',
                    text : '查看要货情况',
                    iconCls : 'add',
                    icon: "../Theme/1/images/extjs/customer/view16.gif",
                    handler : function() {
                        viewProvidePlan();
                    }
                    }],
                    
                bbar: new Ext.PagingToolbar({
                    pageSize: 10,
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
            
   var planIds = "";
   planeGrid.getStore().on('load',function(s,records){
        planIds="";
        s.each(function(r){
            if(planIds.length>0)
            {
                planIds+=",";
            }
            planIds+=r.get("PlanId");
        });
        checkPlans();
    });
    
    this.secondPanel = new Ext.Panel({   
        frame: true,   
        title: '采购订单选择',   
        items:[planeGrid]
  
    }); 
    
    /*检查选择的计划是否已经生成全部的要货信息*/
    
    
    
    /*------------Card 控制  ---------------------*/
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
            if (i > 2) {   
                i = 2;   
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
                        ||planeGridData.baseParams.PlanMonth!=Ext.getCmp("PlanMonth").getValue())
                     {
                        planeGridData.baseParams.PlanType =Ext.getCmp("PlanType").getValue();
                        planeGridData.baseParams.PlanYear=Ext.getCmp("PlanYear").getValue();
                        planeGridData.baseParams.PlanMonth=Ext.getCmp("PlanMonth").getValue();
                        planeGridData.load();
                    }
                }
                
                break;
             case 2:
//                var sm = Ext.getCmp('planeGrid').getSelectionModel();
//                if(direction==1)
//                {
//                    if(selectProductTree.loader.baseParams.PlanIds!=getSelectedPlans())
//                    {
//                        selectProductTree.loader.baseParams.PlanIds = getSelectedPlans();
//                        selectProductTree.loader.load(selectProductTree.root,function(){}); 
//                    }                   
//                }
                
                break;
            case 3:
//                if(direction==1)
//                {
//                    var smallIds = getSelectedSmallTreeNode();
//                    if(customerListStore.baseParams.SmallId!=smallIds)
//                    {
//                        customerListStore.baseParams.SmallId=smallIds;
//                        customerListStore.load();
//                    }
//                }
                break;                
        }        
        setButtonShow(i);
        this.cardPanel.getLayout().setActiveItem(i);   
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
    
    var notPassIds = "";
    function checkPlans()
    {
        notPassIds="";
        if(planIds=="")
        {
            Ext.Msg.alert("请选择计划信息");
            return false;
        }
        Ext.Msg.wait("系统提示","正在检查数据");
         Ext.Ajax.request({
                url: 'frmProvideProductMessage.aspx?method=checkplan',
                params: {
                    PlanIds: planIds
                },
                success: function(resp, opts) {
                    var resu = Ext.decode(resp.responseText);
                    //如果是UIMessageBase
                    if(resu)
                    {
                        if(resu.errorinfo!="")
                        {
                            if(notPassIds.length>0)
                                notPassIds+=",";
                            notPassIds+=resu.errorinfo;
                            //Ext.Msg.alert('提示消息',resu.errorinfo);
                        }
                        else
                        {
                            
                        }
                        //返回是否成功
                      
                    }
                    setGridRowColor();
                    Ext.Msg.hide();

                },
                failure: function(resp, opts) {
                    Ext.Msg.alert("提示", "检查数据失败");
                    return false;
                }
             });        
     }
    
    function setGridRowColor()
    {
        var notPassed = notPassIds.split(',');
        for(var i=0;i<notPassed.length;i++)
        {
            if(notPassed[i]!="")
            {
                var index = planeGridData.find('PlanId', notPassed[i]);
                planeGrid.getView().getRow(index).style.backgroundColor='#FFFF00';
            }
        }

        
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
//            case 1:
//           // case 2:
//                btnSave.hide();   
//                btnNext.enable();   
//                btnPrev.enable(); 
//            break;
            case 1:
                btnSave.show();   
                btnNext.disable();   
                btnPrev.enable(); 
                break;
        }
        
    }
    
    //CARD总面板   
    this.cardPanel = new Ext.Panel({   
        frame: true,   
        title: '供应商订单创建向导',   
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
            text: '创建要货通知单',   
            hidden: true,   
            handler: function () {   
                if(planIds=="")
                {
                    Ext.Msg.alert("请选择计划信息");
                    return false;
                }
                Ext.Msg.wait("正在创建要货通知单数据","系统提示");
                 Ext.Ajax.request({
                        url: 'frmProvideProductMessage.aspx?method=createmessage',
                        params: {
                            PlanIds: planIds
                        },
                        success: function(resp, opts) {
                            Ext.Msg.hide();
                            checkExtMessage(resp);
                            

                        },
                        failure: function(resp, opts) {
                            Ext.Msg.hide();
                            Ext.Msg.alert("提示", "检查数据失败");
                            return false;
                        }
                     });    
                }   
        },   
        {   
            id: 'move-next',   
            text: '下一步',   
            handler: cardHandler.createDelegate(this, [1])   
        }],   
        items: [this.firstPanel, this.secondPanel]   
    });  
    cardPanel.show();     
   
})
    </script>
</head>
<body>
    <form id="form1" runat="server">
    <div id="toolbar"></div>
    <div id="cardPanel">    
    </div>
    <div>
    
    </div>
    </form>
</body>
</html>
