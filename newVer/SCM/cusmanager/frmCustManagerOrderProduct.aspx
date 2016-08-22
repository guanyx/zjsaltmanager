<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmCustManagerOrderProduct.aspx.cs" Inherits="SCM_cusmanager_frmCustManagerOrderProduct" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html>
<head>
    <title>核算单位商品查询</title>
    <link rel="stylesheet" type="text/css" href="../../ext3/resources/css/ext-all.css" />
    <script type="text/javascript" src="../../ext3/adapter/ext/ext-base.js"></script>
    <script type="text/javascript" src="../../ext3/ext-all.js"></script>
    <script type="text/javascript" src="../../ext3/example/ItemDeleter.js"></script>
    <!--link rel="stylesheet" type="text/css" href="../../css/GroupHeaderPlugin.css" /-->
    <script type="text/javascript" src="../../js/floatUtil.js"></script>
    <!--script type="text/javascript" src="../../js/GroupHeaderPlugin.js"></script-->
    <link rel="stylesheet" href="../../css/Ext.ux.grid.GridSummary.css" />
    <!--script type="text/javascript" src="../../js/FilterControl.js"></script-->
    <script type="text/javascript" src='../../js/Ext.ux.grid.GridSummary.js'></script>
    <link rel="stylesheet" type="text/css" href="../../ext3/example/GroupSummary.css" />
    <script type="text/javascript" src="../../ext3/example/GroupSummary.js"></script>
    <script type="text/javascript" src="../../js/operateResp.js"></script>
    <script type="text/javascript" src="../../ext3/src/locale/ext-lang-zh_CN.js"></script>
</head>
<body> 
<div id='searchForm'></div>
<div id='gird'></div>
</body>
<script type="text/javascript">
function getParamerValue( name )
{
  name = name.replace(/[\[]/,"\\\[").replace(/[\]]/,"\\\]");
  var regexS = "[\\?&]"+name+"=([^&#]*)";
  var regex = new RegExp( regexS );
  var results = regex.exec( window.location.href );
  if( results == null )
    return "";
  else
    return results[1];
}
var IsCustManager = getParamerValue('custManager');
</script>
<%=getComboBoxStore( ) %>
<script type="text/javascript">
var dateTypeStore = new Ext.data.SimpleStore({
   fields: ['id', 'name'],        
   data : [        
   ['1', '按天'],
   ['2', '按年'],        
   ['3', '按季度'],
   ['4', '按月度'] 
]});

var yearStore = new Ext.data.SimpleStore({
   fields: ['id', 'name'],        
   data : [        
   ['1', '一月']
   ]});
var yearRowPatter = Ext.data.Record.create([
           { name: 'id', type: 'string' },
           { name: 'name', type: 'string' }
          ]);
yearStore.removeAll();
var currentYear = (new Date()).getFullYear();
currentYear = parseInt(currentYear)+1;
for(var i=2009;i<currentYear;i++)
{
    var year = new yearRowPatter({id:i,name:i});
    yearStore.add(year);
}
   
var monthStore = new Ext.data.SimpleStore({
   fields: ['id', 'name'],        
   data : [        
   ['1', '一月'],
   ['2', '二月'],        
   ['3', '三月'],
   ['4', '四月'],        
   ['5', '五月'],
   ['6', '六月'],        
   ['7', '七月'],
   ['8', '八月'],        
   ['9', '九月'],
   ['10', '十月'],        
   ['11', '十一月'],
   ['12', '十二月'] 
   ]});

var quarterlyStore = new Ext.data.SimpleStore({
   fields: ['id', 'name'],        
   data : [        
   ['1', '第一季度'],
   ['2', '第二季度'],        
   ['3', '第三季度'],
   ['4', '第四季度'] 
   ]});

var fieldStore = new Ext.data.SimpleStore({
   fields: ['id', 'name','dataType'],        
   data : [        
   ['1', '第一季度',''],
   ['2', '第二季度',''],        
   ['3', '第三季度',''],
   ['3', '第四季度',''] 
   ]});
   
var fieldRowPattern = Ext.data.Record.create([
           { name: 'id', type: 'string' },
           { name: 'name', type: 'string' },
           { name: 'dataType', type: 'string' }
          ]);
          
 //时间方式
var cmbDateType = new Ext.form.ComboBox({
        id: 'cmbDateType',
        store: dateTypeStore, // 下拉数据           
        displayField:'name', //显示上面的fields中的state列的内容,相当于option的text值        
        valueField: 'id', // 选项的值, 相当于option的value值        
        name: 'cmbDateType',        
        mode: 'local', // 必须要,如果为 remote, 则会用ajax获取数据        
        triggerAction: 'all', // 点击下拉的时候, all 为展出所有Store中data的数据        
        readOnly: true, // 如果设为true,则好像一般的下拉框一样，默认是false,可输入并自动匹配        
        emptyText:'请选择比较类型',  
        width:100,   
        editable:false,  
        selectOnFocus:true});

//时间方式
var cmbYear = new Ext.form.ComboBox({
        id: 'cmbYear',
        store: yearStore, // 下拉数据           
        displayField:'name', //显示上面的fields中的state列的内容,相当于option的text值        
        valueField: 'id', // 选项的值, 相当于option的value值        
        name: 'cmbYear',        
        mode: 'local', // 必须要,如果为 remote, 则会用ajax获取数据        
        triggerAction: 'all', // 点击下拉的时候, all 为展出所有Store中data的数据        
        //readOnly: true, // 如果设为true,则好像一般的下拉框一样，默认是false,可输入并自动匹配        
        emptyText:'请选择年度',   
        width:100,
        hidden:true,
        //editable:false,   
        selectOnFocus:true});
        
 //时间方式
var cmbMonth = new Ext.form.ComboBox({
        id: 'cmbMonth',
        store: monthStore, // 下拉数据           
        displayField:'name', //显示上面的fields中的state列的内容,相当于option的text值        
        valueField: 'id', // 选项的值, 相当于option的value值        
        name: 'cmbMonth',        
        mode: 'local', // 必须要,如果为 remote, 则会用ajax获取数据        
        triggerAction: 'all', // 点击下拉的时候, all 为展出所有Store中data的数据        
        readOnly: true, // 如果设为true,则好像一般的下拉框一样，默认是false,可输入并自动匹配        
        emptyText:'请选择比较类型',   
        width:100,  
        hidden:true,
        editable:false,    
        selectOnFocus:true});
        
 //季度方式
var cmbQuarterly = new Ext.form.ComboBox({
        id: 'cmbQuarterly',
        store: quarterlyStore, // 下拉数据           
        displayField:'name', //显示上面的fields中的state列的内容,相当于option的text值        
        valueField: 'id', // 选项的值, 相当于option的value值        
        name: 'cmbQuarterly',        
        mode: 'local', // 必须要,如果为 remote, 则会用ajax获取数据        
        triggerAction: 'all', // 点击下拉的时候, all 为展出所有Store中data的数据        
        readOnly: true, // 如果设为true,则好像一般的下拉框一样，默认是false,可输入并自动匹配        
        emptyText:'请选择比较类型',   
        width:100,
        hidden:true,
        editable:false,      
        selectOnFocus:true});
var startDate = new Ext.form.DateField({id:'startDate',name:'startDate',format:'Y-m-d',value:new Date().clearTime(),hidden:true});
var endDate = new Ext.form.DateField({id:'endDate',name:'endDate',format:'Y-m-d',value:new Date().clearTime(),hidden:true});
var btnFliter = new Ext.Button({text:'查询'});
cmbDateType.on("select",dataTypeChange);
function dataTypeChange()
{
    switch(cmbDateType.getValue())
    {
        //普通
        case "1":
            //cmbDateType.setVisible(true);
            startDate.setVisible(true);
            endDate.setVisible(true);
            cmbMonth.setVisible(false);
            cmbQuarterly.setVisible(false);
            cmbYear.setVisible(false);
            break;
        //按年度
        case "2":
            //cmbDateType.setVisible(true);
            startDate.setVisible(false);
            endDate.setVisible(false);
            cmbMonth.setVisible(false);
            cmbQuarterly.setVisible(false);
             cmbYear.setVisible(true);
            break;
         //按季度
        case "3":
            startDate.setVisible(false);
            endDate.setVisible(false);
            cmbMonth.setVisible(false);
            cmbQuarterly.setVisible(true);
             cmbYear.setVisible(true);
            break;
            //按月度
         case "4":
            startDate.setVisible(false);
            endDate.setVisible(false);
            cmbMonth.setVisible(true);
            cmbQuarterly.setVisible(false);
             cmbYear.setVisible(true);
            break;
    }
}
btnFliter.on("click",btnFilterClick);
function btnFilterClick()
{
    var strStartDate = '';
    var strEndDate='';
    if(!cmbYear.hidden)
    {
        strStartDate = cmbYear.getValue()+"-01-01";
        strEndDate =  (parseInt(cmbYear.getValue())+1)+"-01-01";
    }
    //月度可见
    if(!cmbMonth.hidden)
    {
       strStartDate = cmbYear.getValue()+"-"+cmbMonth.getValue()+"-01";
       strEndDate =  cmbYear.getValue()+"-"+(parseInt(cmbMonth.getValue())+1)+"-01";
    }
    //季度可见
    if(!cmbQuarterly.hidden)
    {
        var jd = parseInt(cmbQuarterly.getValue());
        strStartDate = cmbYear.getValue()+"-"+(1+(jd-1)*3)+"-01";
        if(jd==4)
        {
            strEndDate =  (parseInt(cmbYear.getValue())+1)+"-01-01";
        }
        else
        {
            strEndDate =  cmbYear.getValue()+"-"+(jd*3+1)+"-01";
        }
    }
    //普通模式
    if(!startDate.hidden)
    {
        strStartDate = document.getElementById("startDate").value;//.getText();
        strEndDate = document.getElementById("endDate").value;
    }
    //alert( strStartDate +":"+strEndDate);
    if(IsCustManager=='true')
            gridStore.baseParams.IsCustManager='true'; 
   gridStore.baseParams.OrgId = ArriveOrgPostPanel.getValue();
   gridStore.baseParams.StartDate=strStartDate;
   gridStore.baseParams.EndDate=strEndDate;
   gridStore.baseParams.limit=10;
   gridStore.baseParams.start=0;
   gridStore.load();
}
</script>
<script type="text/javascript">
Ext.BLANK_IMAGE_URL = "../../ext3/resources/images/default/s.gif";
var colModel = new Ext.grid.ColumnModel({
	columns: [ 
		new Ext.grid.RowNumberer(),			
		{
			header:'客户经理',
			dataIndex:'OwnerName',
			id:'OwnerName',
			tooltip:'客户经理'
		},
		{
		    header:'产品编号',
			dataIndex:'ProductNo',
			id:'ProductNo',
			tooltip:'产品编号'
		},
		{
		    header:'产品名称',
			dataIndex:'ProductName',
			id:'ProductName',
			tooltip:'产品名称'
		},
		{
			header:'规格',
			dataIndex:'SpecificationsName',
			id:'SpecificationsName',
			tooltip:'规格'
		},
		{
			header:'单位',
			dataIndex:'UnitName',
			id:'UnitName',
			tooltip:'单位'
		},
		{
		    header:'订货数量',
			dataIndex:'SaleQty',
			id:'SaleQty',
			tooltip:'订货数量'
		},
		{
		    header:'总销售额',
			dataIndex:'SaleAmt',
			id:'SaleAmt',
			tooltip:'总销售额'
		},
		{
		    header:'总税额',
			dataIndex:'SaleTax',
			id:'SaleTax',
			tooltip:'总税额'
		}
        ]
});/*--------------serach--------------*/
var ArriveOrgPostPanel = new Ext.form.ComboBox({
        style: 'margin-left:0px',
        cls: 'key',
        xtype: 'combo',
        fieldLabel: '组织',
        name: 'nameCust',
        anchor: '95%',
        store:dsOrgList,
        mode:'local',
        displayField:'OrgName',
        valueField:'OrgId',
        triggerAction:'all',
        editable:false,
        value:dsOrgList.getAt(0).data.OrgId
    });
    
var serchform = new Ext.FormPanel({
    renderTo: 'searchForm',
    //labelAlign: 'left',
   // layout:'fit',
    buttonAlign: 'right',
    bodyStyle: 'padding:5px',
    frame: true,
    layout:'table',     
    height:70,   
    layoutConfig:{columns:9},//将父容器分成3列   
    items:[   
    {items:ArriveOrgPostPanel},
    {items:cmbDateType},   
    {items:cmbYear},   
    {items:cmbQuarterly},
    {items:cmbMonth},
    {items:startDate},    
    {items:endDate},
    {items:btnFliter}
   ]   
});

/*----------------------------*/

var gridStore = new Ext.data.Store({
    url: 'frmCustManagerOrderProduct.aspx?method=getlist',
     reader :new Ext.data.JsonReader({
    totalProperty: 'totalProperty',
    root: 'root',
    fields: [
	{		name:'OwnerId'	},
	{		name:'OwnerName'	},
	{		name:'ProductId'	},
	{		name:'ProductNo'	},
	{		name:'ProductName'	},
	{		name:'SpecificationsName'	},
	{		name:'UnitName'	},
	{		name:'SaleQty'	},
	{		name:'SaleAmt'	},
	{		name:'SaleTax'	}
	]
    })
});

</script>
<script type="text/javascript">

 function getCmbStore(columnName)
{
    return null;
}
    
Ext.onReady(function(){



var sm = new Ext.grid.CheckboxSelectionModel({
            singleSelect: true
});
//合计项
var viewGrid = new Ext.grid.EditorGridPanel({
    renderTo:"gird",                
    id: 'viewGrid',
    //region:'center',
    split:true,
    store: gridStore ,
    autoscroll:true,
    height:550,
    width:'100%',
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
    loadMask: true,
    closeAction: 'hide',
    stripeRows: true    
});
ArriveOrgPostPanel.setValue(<% =ZJSIG.UIProcess.ADM.UIAdmUser.OrgID(this)%>);
ArriveOrgPostPanel.setDisabled(true);

})
</script>

</html>