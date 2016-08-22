<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmWsProudctStat.aspx.cs" Inherits="RPT_PMS_frmWsProudctStat" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>生产报表</title>
    <meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
    <link rel="stylesheet" type="text/css" href="../../ext3/resources/css/ext-all.css" />
    <script type="text/javascript" src="../../ext3/adapter/ext/ext-base.js"></script>
    <script type="text/javascript" src="../../ext3/ext-all.js"></script>
    <link rel="stylesheet" href="../../css/Ext.ux.grid.GridSummary.css"/>
    <script type="text/javascript" src='../../js/Ext.ux.grid.GridSummary.js'></script>
    <script type="text/javascript" src="../../js/floatUtil.js"></script>
    <script type="text/javascript" src="../../ext3/src/locale/ext-lang-zh_CN.js"></script>
</head>
<%=getComboBoxStore()%>
<body>
<div id='toolbar'></div>
<div id='searchForm'></div>
<div id='gird'></div>
</body>
<script type="text/javascript">
Ext.BLANK_IMAGE_URL = "../../ext3/resources/images/default/s.gif";
Ext.onReady(function(){
/*------实现toolbar的函数 start---------------*/
        var Toolbar = new Ext.Toolbar({
            renderTo: "toolbar",
            items: [{
                text: "查看质检单",
                icon: "../../Theme/1/images/extjs/customer/view16.gif",
                handler: function() { ViewNoticeWin(); }
            }]
            });
            /*-----实体类窗体函数----*/
            function ViewNoticeWin() {
                var sm = viewGrid.getSelectionModel();
                var selectData = sm.getSelected();                         

                //如果没有选择，就提示需要选择数据信息
                if (selectData == null || selectData == "") {
                    Ext.Msg.alert("提示", "请选中需要查看的记录！");
                    return;
                }
                //是否之间
                if(selectData.get('BizStatus') != 'P013'){
                    Ext.Msg.alert("提示", "该记录还未质检！");
                    return;
                }
                var noticeid =selectData.get('QtNoticeId');
                var pn = selectData.get('ProductId');
                showresult(pn,noticeid);
                
            }
            if (typeof (resultWindow) == "undefined") {//解决创建2个windows问题
                       var resultWindow = new Ext.Window({
                           title: '质检报告',
                           modal: 'true',
                           width: 600,
                           y: 50,
                           autoHeigth: true,
                           collapsible: true, //是否可以折叠 
                           closable: true, //是否可以关闭 
                           //maximizable : true,//是否可以最大化 
                           closeAction: 'hide',
                           constrain: true,
                           resizable: false,
                           plain: true,
                           // ,items: addQuotaForm
                           buttons: [ {
                               text: '关闭',
                               handler: function() {
                                   resultWindow.hide();
                                   var s = result.getEl().dom.lastChild.lastChild;
                                   var ss = s.childNodes;
                                   var sss = ss.length;
                                   s.removeChild(ss[sss - 1]);
                               }
}]
                           });
                       }
            function showresult(prno,id) {
               resultWindow.show();
               Ext.Ajax.request({
                   url: "frmQtQualityCheckNotify.aspx?method=showrsult"
                           , params: {
                               checkid: id
                                , prno: prno

                           },
                   success: function(response, options) {
                       var data = response.responseText;
                       printstr = data;
                       var divobj = document.createElement("div");
                       divobj.innerHTML = data;
                       result.getEl().dom.lastChild.lastChild.appendChild(divobj);

                   }
           ,
                   failure: function() {
                       Ext.Msg.alert("提示", "获取指标配置项出错,请重新打开该页！");
                   }
               });
           }
            
/*--------------serach--------------*/
    var ArriveOrgPostPanel = new Ext.form.ComboBox({
        style: 'margin-left:0px',
        cls: 'key',
        xtype: 'combo',
        fieldLabel: '公司',
        name: 'nameOrg',
        anchor: '95%',
        store: dsOrgListInfo,
        mode: 'local',
        displayField: 'OrgName',
        valueField: 'OrgId',
        triggerAction: 'all',
        editable: false,
        value: dsOrgListInfo.getAt(0).data.OrgId
    });
    
    //车间名称
    var WsNamePanel = new Ext.form.ComboBox({
        xtype:'combo',
        fieldLabel:'车间',
        anchor:'95%',
	    store:dsWs,
	    displayField:'WsName',
        valueField:'WsId',
        mode:'local',
        triggerAction:'all',
        editable: false
    });
    
    //产品名称
    var productNamePanel = new Ext.form.TextField({
        xtype:'textfield',
        fieldLabel:'产品名称',
        anchor:'95%'
    });

    //开始日期
    var beginStartDatePanel = new Ext.form.DateField({
        xtype:'datefield',
        fieldLabel:'开始日期',
        anchor:'95%',
        format: 'Y年m月d日',  //添加中文样式
        value:new Date().getFirstDateOfMonth().clearTime() 
    });
    
    //结束日期
    var beginEndDatePanel = new Ext.form.DateField({
        xtype:'datefield',
        fieldLabel:'开始日期',
        anchor:'95%',
        format: 'Y年m月d日',  //添加中文样式
        value:new Date().getLastDateOfMonth().clearTime() 
    });
    
    var serchform = new Ext.FormPanel({
        renderTo: 'searchForm',
        labelAlign: 'left',
        // layout:'fit',
        buttonAlign: 'right',
        bodyStyle: 'padding:5px',
        frame: true,
        labelWidth: 55,
        items: [
        {
            layout: 'column',   //定义该元素为布局为列布局方式
            border: false,
            items: [{
                columnWidth: .3,  //该列占用的宽度，标识为20％
                layout: 'form',
                border: false,
                items: [
                    ArriveOrgPostPanel
                ]
            },{
                columnWidth: .3,  //该列占用的宽度，标识为20％
                layout: 'form',
                border: false,
                items: [
                    WsNamePanel
                ]
            },{
                columnWidth: .3,  //该列占用的宽度，标识为20％
                layout: 'form',
                border: false,
                items: [
                    productNamePanel
                ]
            }
            ]
         }
        ,{
            layout: 'column',   //定义该元素为布局为列布局方式
            border: false,
            items: [{
                columnWidth: .3,  //该列占用的宽度，标识为20％
                layout: 'form',
                border: false,
                items: [
                    beginStartDatePanel
                ]
            },{
                columnWidth: .3,  //该列占用的宽度，标识为20％
                layout: 'form',
                border: false,
                items: [
                    beginEndDatePanel
                ]
            },{
                columnWidth: .2,
                layout: 'form',
                border: false,
                items: [
                { 
                    cls: 'key',
                    xtype: 'button',
                    text: '查询',
                    anchor: '50%',
                    handler: function() {  
                    var orgId = ArriveOrgPostPanel.getValue();
                    var wsId = WsNamePanel.getValue();
                    var productName = productNamePanel.getValue();
                    var beginStartDate = Ext.util.Format.date(beginStartDatePanel.getValue(), 'Y/m/d');
                    var beginEndDate = Ext.util.Format.date(beginEndDatePanel.getValue(), 'Y/m/d');
                    
                   gridStore.baseParams.OrgId = orgId;
                   gridStore.baseParams.WsId = wsId;
                   gridStore.baseParams.ProductName = productName;
                   gridStore.baseParams.StartDate=beginStartDate;
                   gridStore.baseParams.EndDate=beginEndDate;
                   //gridStore.baseParams.limit=10;
                   //gridStore.baseParams.start=0;
                   gridStore.load();
                    
                    }
                }]
            }]
        }]
    });
    var colModel = new Ext.grid.ColumnModel({
	columns: [ 
		new Ext.grid.RowNumberer(),			
		{
			header:'生产日期',
			dataIndex:'ManuDate',
			id:'ManuDate',
			tooltip:'生产日期',
			renderer: Ext.util.Format.dateRenderer('Y年m月d日'),
			width:100
		},
		{
		    header:'车间',
			dataIndex:'WsName',
			id:'WsName',
			tooltip:'车间',
			width:60
		},
		{
			header:'班次',
			dataIndex:'GroupIds',
			id:'GroupIds',
			tooltip:'班次',
			width:60
		},
		{
			header:'产品编号',
			dataIndex:'ProductNo',
			id:'ProductNo',
			tooltip:'产品编号',
			width:80
		},
		{
		    header:'产品名称',
			dataIndex:'ProductName',
			id:'ProductName',
			tooltip:'产品名称',
			width:150
		},
		{
			header:'规格',
			dataIndex:'SpecificationsText',
			id:'SpecificationsText',
			tooltip:'规格',
			width:60
		},
		{
			header:'单位',
			dataIndex:'UnitText',
			id:'UnitText',
			tooltip:'单位',
			width:40
		},
		{
		    header:'生产数量',
			dataIndex:'ManuQty',
			id:'ManuQty',
			summaryType: 'sum',
			tooltip:'',
			width:60
		},
		{
		    header:'生产重量',
			dataIndex:'ManuAmt',
			id:'ManuAmt',
			summaryType: 'sum',
			tooltip:'',
			width:80
			,summaryRenderer:function(v){
			    return v +'吨';
			}
		},
		{
		    header:'状态',
			dataIndex:'DicsName',
			id:'DicsName',
			tooltip:'',
			width:60
		},
		{
		    header:'操作人',
			dataIndex:'OperName',
			id:'OperName',
			tooltip:'',
			width:50
		},
		{
		    header:'审核人',
			dataIndex:'AuditName',
			id:'AuditName',
			tooltip:'',
			width:50
		}
        ]
    });
    var gridStore = new Ext.data.Store({
        url: 'frmWsProudctStat.aspx?method=getlist',
         reader :new Ext.data.JsonReader({
        totalProperty: 'totalProperty',
        root: 'root',
        fields: [
	    {		name:'ProductId'	},
	    {		name:'ProductNo'	},
	    {		name:'ProductName'	},
	    {		name:'SpecificationsText'	},
	    {		name:'UnitText'	},
	    {		name:'ManuQty'	},
	    {		name:'ManuAmt'	},
	    {       name:'BizStatus'},
	    {		name:'DicsName'	},
	    {       name:'QtNoticeId'},
	    {       name:'WsName'},
	    {       name:'GroupIds'},
	    {       name:'ManuDate'},
	    {       name:'OperName'},
	    {       name:'AuditName'}
	    ]
        })
    });
    var sm = new Ext.grid.CheckboxSelectionModel({
            singleSelect: true
    }); 
    //合计项
    var summary = new Ext.ux.grid.GridSummary();

    var viewGrid = new Ext.grid.EditorGridPanel({
        renderTo:"gird",                
        id: 'viewGrid',
        //region:'center',
        split:true,
        store: gridStore ,
        autoscroll:true,
        height:350,
        width:document.clientWidth,
        title:'',
        loadMask: { msg: '正在加载数据，请稍侯……' },
        sm: sm,
        cm:colModel,
        viewConfig: {
            columnsText: '显示的列',
            scrollOffset: 20,
            sortAscText: '升序',
            sortDescText: '降序',
            forceFit: true
        },
        plugins: summary,
        loadMask: true,
        closeAction: 'hide',
        stripeRows: true    
    });

    ArriveOrgPostPanel.setValue(<% =ZJSIG.UIProcess.ADM.UIAdmUser.OrgID(this)%>); 
    if(ArriveOrgPostPanel.getValue() !=1)
        ArriveOrgPostPanel.setDisabled(true);
})
</script>
</html>
