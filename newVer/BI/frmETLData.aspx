<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmETLData.aspx.cs" Inherits="BI_frmETLData" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>无标题页</title>
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
<%=getComboBoxStore() %>
<script>
Ext.onReady(function() {
    var orgIndex = 0;
    function ETLData()
    {
        document.getElementById("message").innerHTML="正在更新机构信息……";
                        Ext.Ajax.request({
                            timeout: 180000,
                            url: 'frmETLData.aspx?method=Org',
                            method: 'POST',
                            params: {
                            },
                            success: function(resp,opts){  
                                ETLProductData();
                            },
		                    failure: function(resp,opts){  Ext.Msg.alert("提示","操作失败");     }
                        });
    }
    
    function ETLProductData()
    {
        document.getElementById("message").innerHTML="正在更新产品信息……";
        Ext.Ajax.request({
                            timeout: 180000,
                            url: 'frmETLData.aspx?method=Product',
                            method: 'POST',
                            params: {
                            },
                            success: function(resp,opts){  
                                ETLOrgCustomData();
                            },
		                    failure: function(resp,opts){  Ext.Msg.alert("提示","操作失败");     }
                        });
    }
    
    function ETLOrgCustomData()
    {
        
        if(orgIndex<dsOrg.data.items.length)
        {
            document.getElementById("message").innerHTML="正在更新 "+orgIndex+"/"+dsOrg.data.length+" "+dsOrg.data.items[orgIndex].data.OrgName+" 客户信息……";
            Ext.Ajax.request({
            timeout: 180000,
            url: 'frmETLData.aspx?method=OrgCustomer',
            method: 'POST',
            params: {
                OrgId:dsOrg.data.items[orgIndex].data.OrgId,
                StartDate:startDate+'-'+month+'-1'
            },
            success: function(resp,opts){                
                ETLOrgStoreData();
            },
            failure: function(resp,opts){  Ext.Msg.alert("提示","操作失败");     }
        });
            
        }
    }
    
    function MiningData()
    {
        document.getElementById("message").innerHTML="正在更新 "+orgIndex+"/"+dsOrg.data.length+" "+dsOrg.data.items[orgIndex].data.OrgName+" "+startDate+"年"+month+"月业务数据……";
            Ext.Ajax.request({
            timeout: 180000,
            url: 'frmETLData.aspx?method=Mining',
            method: 'POST',
            success:function(resp,opts){  alert(resp.responseText);    },
            failure: function(resp,opts){  Ext.Msg.alert("提示","操作失败");     }
        });
    }
    
//    var startDate = 2012;
//    var month = 1;
var endYear =2012;
var endMonth=4;
    
    function ETLOrgStoreData()
    {
        
        document.getElementById("message").innerHTML="正在更新 "+orgIndex+"/"+dsOrg.data.length+" "+dsOrg.data.items[orgIndex].data.OrgName+" "+startDate+"年"+month+"月业务数据……";
            Ext.Ajax.request({
            timeout: 180000,
            url: 'frmETLData.aspx?method=OrgStore',
            method: 'POST',
            params: {
                OrgId:dsOrg.data.items[orgIndex].data.OrgId,
                StartDate:startDate+'-'+month+'-1'
            },
            success: function(resp,opts){
                   month=month+1;
                   if(month<=12)
                   {
                     if(startDate==endYear && month>endMonth)
                     {
                        orgIndex =orgIndex+1;
                                startDate=2010;
                                month=1;
                                ETLOrgCustomData();
                     }
                     else
                     {
                        ETLOrgStoreData();
                     }
                   }
                   else
                   {
                       startDate+=1;
                       month = 1;
                       if(startDate<=endYear)
                       {  
                            if(startDate==endYear && month>endMonth)
                             {
                                orgIndex =orgIndex+1;
                                startDate=2010;
                                ETLOrgCustomData();
                             } 
                             else
                             {               
                                ETLOrgStoreData();
                              }
                        }
                        else
                        {
                            orgIndex =orgIndex+1;
                            startDate=2010;
                            ETLOrgCustomData();
                        }
                    }
            },
            failure: function(resp,opts){  Ext.Msg.alert("提示","操作失败");     }
        });
    }
    
    function ClearEtlData()
    {        
        
        document.getElementById("message").innerHTML="正在删除 "+orgIndex+"/"+dsOrg.data.length+" "+dsOrg.data.items[orgIndex].data.OrgName+" "+startDate+"年"+month+"月业务数据……";
            Ext.Ajax.request({
            timeout: 180000,
            url: 'frmETLData.aspx?method=Clear',
            method: 'POST',
            params: {
                OrgId:dsOrg.data.items[orgIndex].data.OrgId,
                StartDate:startDate+'-'+month+'-1'
            },
            success: function(resp,opts){
                   Ext.Msg.alert("提示","数据清除成功");
            },
            failure: function(resp,opts){  Ext.Msg.alert("提示","操作失败");     }
        });
    }
    
    var Toolbar = new Ext.Toolbar({
	    renderTo:"toolbar",
	    items:[{
		    text:"导入数据",
		    icon:"images/extjs/customer/add16.gif",
		    handler:function(){
		        ETLData();
		    }
		    },'-',{
		    text:"测试速度",
		    icon:"images/extjs/customer/add16.gif",
		    handler:function(){
		        MiningData();
		    }
		    }]
    });
    
    if(orgId>1)
    {
        Toolbar.setVisible(false);
    }
    
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
	title:'分析数据导入',
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
			text:'导入',
			columnWidth:.1,
			anchor:'50%',
			name:'SaleConfig',
			id:'SaleConfig',
			handler: function() {
			    startDate = Ext.getCmp("cmbYear").getValue();
			    month =Ext.getCmp("cmbMonth").getValue();
			    endYear =startDate;
                endMonth=month;
                ETLOrgCustomData();
			}
		},		{
			xtype:'button',
			text:'清除',
			columnWidth:.1,
			anchor:'50%',
			name:'btnClear',
			id:'btnClear',
			handler: function() {
			    startDate = Ext.getCmp("cmbYear").getValue();
			    month =Ext.getCmp("cmbMonth").getValue();
			    ClearEtlData();
			}
		}]}]
		});
		
		Ext.getCmp("cmbYear").setValue(startDate);
		Ext.getCmp("cmbMonth").setValue(month);
		document.getElementById("memo").innerHTML=memo;
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
