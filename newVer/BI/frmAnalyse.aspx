<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmAnalyse.aspx.cs" Inherits="BI_frmAnalyse" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<title >分析情况</title>
        <meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<link rel="stylesheet" type="text/css" href="../ext3/resources/css/ext-all.css" />
<link rel="stylesheet" href="../css/orderdetail.css"/>
<link rel="stylesheet" type="text/css" href="../Theme/1/css/salt.css" />
<script type="text/javascript" src="../ext3/adapter/ext/ext-base.js"></script>
<script type="text/javascript" src="../ext3/ext-all.js"></script>
<script type="text/javascript" src="../js/operateResp.js"></script>
<script type="text/javascript" src="../js/floatUtil.js"></script>
<script type="text/javascript" src="../js/ExtJsHelper.js"></script>
<script type="text/javascript" src="../ext3/src/locale/ext-lang-zh_CN.js"></script>
<script type="text/javascript">
Ext.onReady(function() {

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

var defaultPageSize = 10;
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
   
    var orgConfigForm=new Ext.form.FormPanel({
	renderTo:'divForm',
	frame:true,
	width:240,
	title:'分析数据',
	items:[
		{
		    layout:'column',
		    items:[{
			 xtype: 'combo',
                    columnWidth: 0.3,
                    name: 'cmbYear',
                    id: 'cmbYear',
                    store: yearStore,
                    displayField: 'name',
                    valueField: 'id',
                    typeAhead: true, //自动将第一个搜索到的选项补全输入
                    triggerAction: 'all',
                    emptyText: '',
                    selectOnFocus: true,
                    forceSelection: true,
                    mode: 'local',
                    fieldLabel: '年度',
                    //value: dsWarehouseList.getRange()[0].data.WhId,
                    anchor: '100%'
		},
		{
			 xtype: 'combo',
                    columnWidth: .3,
                    name: 'cmbMonth',
                    id: 'cmbMonth',
                    store: monthStore,
                    displayField: 'name',
                    valueField: 'id',
                    typeAhead: true, //自动将第一个搜索到的选项补全输入
                    triggerAction: 'all',
                    emptyText: '',
                    selectOnFocus: true,
                    forceSelection: true,
                    mode: 'local',
                    fieldLabel: '月度',
                    //value: dsWarehouseList.getRange()[0].data.WhId,
                    anchor: '100%'
		}
,		{
			xtype:'button',
			text:'分析',
			columnWidth:.1,
			anchor:'50%',
			name:'btnAnalyse',
			id:'btnAnalyse',
			handler: function() {
			    AnalyseData();
			    
			}
		}]}]
		});
		
		function AnalyseData()
    {
            document.getElementById("message").innerHTML="正在获取分析数据！……";
            Ext.Ajax.request({
            url: 'frmAnalyse.aspx?method=Analyse',
            method: 'POST',
            params: {
                OrgId:25,
                StartDate:Ext.getCmp("cmbYear").getValue()+'-'+Ext.getCmp("cmbMonth").getValue()+'-1'
            },
            success: function(resp,opts){                
                document.getElementById("memo").innerHTML=resp.responseText;
            },
            failure: function(resp,opts){  Ext.Msg.alert("提示","操作失败");     }
        });
            
        }
    
})
</script>
</head>
<body>
<div id='toolbar'></div>

<div id='divForm'></div>
<div id='message'></div>
<div id='memo'></div>
</body>
</html>
