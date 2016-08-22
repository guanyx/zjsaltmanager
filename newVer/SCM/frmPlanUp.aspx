<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmPlanUp.aspx.cs" Inherits="SCM_frmPlanUp" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>无标题页</title>
<link rel="stylesheet" type="text/css" href="../ext3/resources/css/ext-all.css" />
<script type="text/javascript" src="../ext3/adapter/ext/ext-base.js"></script>
<script type="text/javascript" src="../ext3/ext-all.js"></script>
<script type="text/javascript" src="../js/ProductSelect.js"></script>
<script type="text/javascript" src="../js/operateResp.js"></script>
<%=getComboBoxSource() %>
<script type="text/javascript">
Ext.BLANK_IMAGE_URL = "../ext3/resources/images/default/s.gif";
Ext.onReady(function () {   

    this.SetPlanValue=function(planType,startDate,isAdding) 
    {
        Ext.getCmp("PlanType").setValue(planType);  
        setColumnVisible();
        setNDValue(startDate);
        Ext.getCmp("IsAdding").setValue(isAdding);
    }
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
    				    xtype: 'checkbox',
    				    anchor: '80%',
    				    name: 'IsAdding',
    				    id: 'IsAdding',
    				    fieldLabel: '追补计划'
    				}]
  
    }); 
    
  /*采购订单选择*/
  
  /*------开始获取数据的函数 start---------------*/
            var planeGridData = new Ext.data.Store
({
    url: 'frmPlanUp.aspx?method=getpurchplanlist',
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
                autoWidth: true,
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
		tbar: [{
                id: 'newWindow',
                text: '<font color="red">察看商品信息</font>',
                iconCls: 'add',
                icon: "../images/extjs/customer/add16.gif",
                handler: function() {
                    
                }},{
                id: 'newWindow',
                text: '<font color="red">退回</font>',
                iconCls: 'add',
                icon: "../images/extjs/customer/add16.gif",
                handler: function() {
                    senderToCheck();
                }}],
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
                height: 250,
                closeAction: 'hide',
                stripeRows: true,
                loadMask: true,
                autoExpandColumn: 2
            });
            
            planeGrid.on('render', function(grid) {
                var store = grid.getStore();  // Capture the Store.  
                var view = grid.getView();    // Capture the GridView.
                planeGrid.tip = new Ext.ToolTip({
                    target: view.mainBody,    // The overall target element.  
                    delegate: '.x-grid3-row', // Each grid row causes its own seperate show and hide.  
                    trackMouse: true,         // Moving within the row should not hide the tip.  
                    renderTo: document.body,  // Render immediately so that tip.body can be referenced prior to the first show.  
                    listeners: {              // Change content dynamically depending on which element triggered the show.  
                        beforeshow: function updateTipBody(tip) {
                            var rowIndex = view.findRowIndex(tip.triggerElement);
                            
                            var element = document.elementFromPoint(tip.x-20, tip.y-20);
                             var v = view.findCellIndex(element);
                             if(v==2)
                             {
                              
                                if(showTipRowIndex == rowIndex)
                                    return;
                                else
                                    showTipRowIndex = rowIndex;
                                    
                                     tip.body.dom.innerHTML="正在加载数据……";
                                        //页面提交
                                        Ext.Ajax.request({
                                            url: 'frmPurchPlanList.aspx?method=getdtlinfo',
                                            method: 'POST',
                                            params: {
                                                PlanId: grid.getStore().getAt(rowIndex).data.PlanId
                                            },
                                            success: function(resp, opts) {
                                                tip.body.dom.innerHTML = resp.responseText;
                                            },
                                            failure: function(resp, opts) {
                                                planeGrid.tip.hide();
                                            }
                                        });
                                }
                                else if(v==4)
                                {
//                                    if(showTipRowIndex == rowIndex)
//                                        return;
//                                    else
//                                        showTipRowIndex = rowIndex;
                                    tip.body.dom.innerHTML="正在加载数据……";
                                        //页面提交
                                        Ext.Ajax.request({
                                            url: 'frmPurchPlanList.aspx?method=getdtlinfo',
                                            method: 'POST',
                                            params: {
                                                PlanId: grid.getStore().getAt(rowIndex).data.PlanId
                                            },
                                            success: function(resp, opts) {
                                                tip.body.dom.innerHTML = resp.responseText;
                                            },
                                            failure: function(resp, opts) {
                                                planeGrid.tip.hide();
                                            }
                                        });
                                    
                                }
                                else
                                {
                                    planeGrid.tip.hide();
                                }
                        }
                    }
                });
    });
    var showTipRowIndex =-1;
    var label = new Ext.form.Label
        ({
              id:"labelID",
              
              text:"",              
              height:100,//默认auto              
              width:100,//默认auto              
              autoShow:true,//默认false              
              autoWidth:true,//默认false              
              autoHeight:true,//默认false              
              hidden:false,//默认false              
              hideMode:"offsets",//默认display,可以取值：display，offsets，visibility              
              cls:"cssLabel",//样式定义,默认""                          
              disabledClass:"",//默认x-item-disabled              
              html:"Ext"//默认"" 
              
        });

    this.secondPanel = new Ext.Panel({   
        frame: true,   
        title: '采购订单选择',   
        items:[planeGrid,label]
  
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
            if (i > 1) {   
                i = 1;   
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
                        
                            //页面提交
                        Ext.Ajax.request({
                            url: 'frmPlanUp.aspx?method=reportorg',
                            method: 'POST',
                            params: {
                                PlanYear:Ext.getCmp("PlanYear").getValue(),
                                PlanMonth:Ext.getCmp("PlanMonth").getValue(),
                                PlanType:Ext.getCmp("PlanType").getValue(),
                                IsAdding:Ext.getCmp("IsAdding").getValue()},
                           success: function(resp,opts){ 
                              label.setText(resp.responseText);                           
                           },
		                   failure: function(resp,opts){  /* Ext.Msg.alert("提示","保存失败"); */    }
                        });    
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
                btnSave.show();   
                btnNext.disable();   
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
        title: '采购订单审核上报向导',   
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
            text: '上报',   
            hidden: true,   
            handler: function () {   
                AllCityUp();
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
       
    //送审核
    function senderToCheck() {
        createUpLoadSight();
        var sm = Ext.getCmp('planeGrid').getSelectionModel();
        //获取选择的数据信息
        var selectData = sm.getSelected();
        if (selectData == null) {
            Ext.Msg.alert("提示", "请选中需要审核的信息！");
            return;
        }
        uploadSightWindow.show();
    }
    
    var uploadSightWindow;
    
    var sightDiv = new Ext.form.FormPanel({
                frame: true,
                title: '审核意见',
                region: 'center',
                items: [
	{
	    layout: 'column',
	    border: false,
	    labelSeparator: '：',
	    items: [
		{
		    layout: 'form',
		    border: false,
		    columnWidth: 0.5,
		    items: [
				{
				    xtype: 'hidden',
				    fieldLabel: '审核人',
				    columnWidth: 0.5,
				    anchor: '90%',
				    name: 'SightChecker',
				    id: 'SightChecker'
				}
		]
		}
, {
    layout: 'form',
    border: false,
    columnWidth: 0.5,
    items: [
				{
				    xtype: 'hidden',
				    fieldLabel: '审核时间',
				    columnWidth: 0.5,
				    anchor: '90%',
				    name: 'SightDate',
				    id: 'SightDate'
				}
		]
}
	]
	},
	{
	    layout: 'column',
	    border: false,
	    labelSeparator: '：',
	    items: [
		{
		    layout: 'form',
		    border: false,
		    columnWidth: 1,
		    items: [
				{
				    xtype: 'textarea',
				    fieldLabel: '审核意见',
				    columnWidth: 1,
				    anchor: '90%',
				    name: 'CheckSight',
				    id: 'CheckSight'
				},{
				    xtype: 'label',
				    fieldLabel: '备注',
				    columnWidth: 1,
				    html:"事故<br>地点",
				    text:"代码"
				}
		]
		}
	]
	}
]
            });
            
    function createUpLoadSight()
    {
            if (typeof (uploadSightWindow) == "undefined") {//解决创建2个windows问题
                uploadSightWindow = new Ext.Window({
                    id: 'Sightformwindow',
                    title: '退回意见'
		, iconCls: 'upload-win'
		, width: 400
		, height: 200
		, layout: 'border'
		, plain: true
		, modal: true
		, x: 50
		, y: 50
		, constrain: true
		, resizable: false
		, closeAction: 'hide'
		, autoDestroy: true
		, items: [sightDiv]
		, buttons: [{
		    text: "通过"
			, handler: function() {
			    fPass = true;
			    //getFormValue();
			    getSightFormValue();
			}
			, scope: this
		},
		{
		    text: "退回"
			, handler: function() {
			    if (Ext.getCmp("CheckSight").getValue() == "") {
			        Ext.Msg.alert("提示信息", "请输入退回的审核意见信息！");
			        return;
			    }
			    fPass = false;
			    getSightFormValue();
			    //getFormValue();
			}
			, scope: this
		},
		{
		    text: "取消"
			, handler: function() {
			    uploadSightWindow.hide();
			}
			, scope: this
}]
                });
                uploadSightWindow.addListener("hide", function() {
            });
            }
            }
            /*------FormPanle的函数结束 End---------------*/

            /*------开始获取界面数据的函数 start---------------*/
            var fPass = false;
            function getSightFormValue() {
                var sm = Ext.getCmp('planeGrid').getSelectionModel();
                //获取选择的数据信息
                var selectData = sm.getSelected();
                Ext.Ajax.request({
                    url: 'frmPurchPlanList.aspx?method=sight',
                    method: 'POST',
                    params: {
                        PlanId: selectData.data.PlanId,
                        Status: selectData.data.Status,
                        Pass: fPass,
                        CheckSight: Ext.getCmp('CheckSight').getValue()
                    },
                    success: function(resp, opts) {
                        if (checkExtMessage(resp)) {
                            uploadSightWindow.hide();
                            planeGridData.reload();
                        }
                    },
                    failure: function(resp, opts) {
                        Ext.Msg.alert("提示", "保存失败");
                    }
                });
            }
            
            function AllCityUp(){
                if(label.text.length>0)
                {
                    Ext.Msg.confirm('系统提示','还有单位没有上报，确定要上报了吗？', function(btn)
                        { if(btn=='yes')
                            { 
                                upAllCity();
                            }
                            else
                            {
                                return false; 
                            } 
                         },this);
                }
                else
                {
                    upAllCity();
                }
            }
            //上报
            function upAllCity(){
//                alert(!IsAllCity());
//               if(!IsAllCity())
//                return;
               var json = "";
                planeGridData.each(function(planeGridData) {
                    json += planeGridData.data.PlanId + ',';
                });
                
               Ext.Ajax.request({
                    url: 'frmPlanUp.aspx?method=upcity',
                    method: 'POST',
                    params: {
                        Pass: true,
                        PlanIds:json,
                        CheckSight: ''
                    },
                    success: function(resp, opts) {
                        if (checkExtMessage(resp)) {
                            planeGridData.load();                        
                            //页面提交
                            Ext.Ajax.request({
                                url: 'frmPlanUp.aspx?method=reportorg',
                                method: 'POST',
                                params: {
                                    PlanYear:Ext.getCmp("PlanYear").getValue(),
                                    PlanMonth:Ext.getCmp("PlanMonth").getValue(),
                                    PlanType:Ext.getCmp("PlanType").getValue(),
                                    IsAdding:Ext.getCmp("IsAdding").getValue()},
                               success: function(resp,opts){ 
                                  label.setText(resp.responseText);                           
                               },
		                       failure: function(resp,opts){  /* Ext.Msg.alert("提示","保存失败"); */    }
                            });    
                        }
                    },
                    failure: function(resp, opts) {
                        Ext.Msg.alert("提示", "保存失败");
                    }
                });
                }
                
                SetPlanValue(planType,startDate,isAdding);
               
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
