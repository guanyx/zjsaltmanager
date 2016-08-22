<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmDynamicStatistics.aspx.cs" Inherits="Common_frmDynamicStatistics" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>核算单位商品查询</title>
    <link rel="stylesheet" type="text/css" href="../ext3/resources/css/ext-all.css" />
    <script type="text/javascript" src="../ext3/adapter/ext/ext-base.js"></script>
    <script type="text/javascript" src="../ext3/ext-all.js"></script>
    <script type="text/javascript" src="../ext3/example/ItemDeleter.js"></script>
    <!--link rel="stylesheet" type="text/css" href="../../css/GroupHeaderPlugin.css" /-->
    <script type="text/javascript" src="../js/floatUtil.js"></script>
    <!--script type="text/javascript" src="../../js/GroupHeaderPlugin.js"></script-->
    <link rel="stylesheet" href="../css/Ext.ux.grid.GridSummary.css" />
    <!--script type="text/javascript" src="../../js/FilterControl.js"></script-->
    <script type="text/javascript" src='../js/Ext.ux.grid.GridSummary.js'></script>
    <link rel="stylesheet" type="text/css" href="../ext3/example/GroupSummary.css" />
    <script type="text/javascript" src="../ext3/example/GroupSummary.js"></script>
    <script type="text/javascript" src="../js/operateResp.js"></script>
    <script type="text/javascript" src="../ext3/src/locale/ext-lang-zh_CN.js"></script>
    <script type="text/javascript" src="../js/ProductSelect.js"></script>
    <script type="text/javascript" src="../js/OrgsSelect.js"></script>
    <script type="text/javascript" src="../js/StatisticsTypeSelect.js"></script>
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
parentUrl="../CRM/product/frmBaProductClass.aspx?select=true&method=getbaproducttree";
var IsCustManager = getParamerValue('custManager');
</script>
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
//btnFliter.on("click",btnFilterClick);
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
}
</script>
<script type="text/javascript">
Ext.BLANK_IMAGE_URL = "../ext3/resources/images/default/s.gif";
/*--------------serach--------------*/
    
var statOrg=new Ext.form.TextField({});
var statProduct = new Ext.form.TextField({});
var statType = new Ext.form.TextField({});

statType.on("focus",selectStaType);

function selectStaType()
{
    
    if(selectStaForm==null)
    {
        showStaForm();
        selectStaForm.buttons[0].on("click",selectStaOk);
    }
    else
    {
        showStaForm();
    }
}
function selectStaOk()
{
    var selectStaNames = "";
   var selectNodes = selectStaTree.getChecked();
        for (var i = 0; i < selectNodes.length; i++) {
            if(selectStaNames!="")
                selectStaNames+=",";
            selectStaNames+=selectNodes[i].text;
        }  
        statType.setValue(selectStaNames);                        
}

statOrg.on("focus",selectOrgType);
function selectOrgType()
{
    
    if(selectOrgForm==null)
    {
        showOrgForm("", "","../ba/sysadmin/frmAdmOrgList.aspx?method=getcurrentandchildrentree");
        selectOrgForm.buttons[0].on("click",selectOrgOk);
    }
    else
    {
        showOrgForm("", "", "");
    }
}
function selectOrgOk()
{
    var selectOrgNames = "";
   var selectNodes = selectOrgTree.getChecked();
        for (var i = 0; i < selectNodes.length; i++) {
            if(selectOrgNames!="")
                selectOrgNames+=",";
            selectOrgNames+=selectNodes[i].text;
        }  
        statOrg.setValue(selectOrgNames);                        
}
statProduct.on("focus",selectProductType);

function selectProductType()
{
    
    if(selectProductForm==null)
    {
        showProductForm("", "", "", true);
        selectProductForm.buttons[0].on("click",selectProductOk);
    }
    else
    {
        showProductForm("", "", "", true);
    }
}
var selectedProductIds="";
function selectProductOk()
{
   var selectProductNames = "";
   selectedProductIds="";
   var selectNodes = selectProductTree.getChecked();
        for (var i = 0; i < selectNodes.length; i++) {
            if(selectProductNames!="")
            {
                selectProductNames+=",";
                selectedProductIds+=",";
            }
            selectProductNames+=selectNodes[i].text;
            selectedProductIds+=selectNodes[i].id+'!'+selectNodes[i].text+'!'+selectNodes[i].attributes.CustomerColumn;
        }
        statProduct.setValue(selectProductNames);                        
}
                        
var serchform = new Ext.FormPanel({
    renderTo: 'searchForm',
    //labelAlign: 'left',
   // layout:'fit',
    buttonAlign: 'right',
    bodyStyle: 'padding:5px',
    frame: true,
    layout:'table',     
    height:70,   
    layoutConfig:{columns:13},//将父容器分成3列   
    items:[   
    {items:new Ext.form.Label({text:'单位信息'})},
    {colspan:12,items:statOrg},
    {items:new Ext.form.Label({text:'统计产品'})},
    {items:statProduct},
    {items:new Ext.form.Label({text:'统计类型',id:'lblStaType'})},
    {items:statType},
    {items:new Ext.form.Label({text:'统计期间'})},
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

btnFliter.on("click",dynamicStatistics);

var data;
function dynamicStatistics()
{
    btnFilterClick();
    Ext.Ajax.request({
		url:"frmDynamicStatistics.aspx?method=purchplan",
		method: 'POST',
        params: {
            ProductIds: selectedProductIds,
            startDate:startDate,
            endDate:endDate
        },
		success:function(response,option){
		if(response.responseText=="")
		{                    
			return;                 
		}         
		data =new DataColumn();                       
		var res = Ext.util.JSON.decode(response.responseText);
		var array = res.fields.split(',');
		for(var i=0;i<array.length;i++)
		{
		    data.addColumns(array[i],array[i]);                
		}                                   
		grid = new DataGrid(res.data); 
		//updateGraph();
	},             
	failure:function()             
	{               
		Ext.Msg.alert("消息","查询出错---->请打开数据库查看数据表名字是否正确");             }        
	});    
}
function DataColumn()    
{        
    this.fields = '';        
    this.columns = '';               
    this.addColumns=function(name,caption)
    {            
        if(this.fields.length > 0)
        {                
            this.fields += ',';            
        }            
        if(this.columns.length > 0)
        {
            this.columns += ',';            
        }
        else
        {
            this.columns='new Ext.grid.RowNumberer(),';
        }
        this.fields += '{name:"' + name + '"}';
        this.columns += '{header:"' + caption + '",dataIndex:"' + name + '",width:100,sortable:true}';
    };
}
var gridPanel;
function DataGrid(stroeData)   
{   
    
    var cm = new Ext.grid.ColumnModel(eval('([' + data.columns + '])'));
    cm.defaultSortable = true;         
    var fields = eval('([' + data.fields + '])');        
//    var newStore = new Ext.data.Store({
//        proxy:new Ext.data.HttpProxy({url:URL}),
//        reader:new Ext.data.JsonReader({totalProperty:"totalPorperty",root:"root",fields:fields})
//    });  
    var ds = new Ext.data.JsonStore({
            data: stroeData,
            fields: fields
        });
        if (gridPanel != null) {
            gridPanel.destroy();
        }
        gridPanel = new Ext.grid.GridPanel({
            region: 'center',
            split: true,
            width: 600,
            height: 350,
            border: false,
            store: ds,
            cm: cm,
             viewConfig: {
                    forceFit: false
                }
        });
        gridPanel.render("gird");
        
    
}


})
</script>

</html>