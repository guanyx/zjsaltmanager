<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmOrgConfig.aspx.cs" Inherits="BA_sysadmin_frmOrgConfig" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>无标题页</title>
    <link rel="stylesheet" type="text/css" href="../../ext3/resources/css/ext-all.css" />
<script type="text/javascript" src="../../ext3/adapter/ext/ext-base.js"></script>
<script type="text/javascript" src="../../ext3/ext-all.js"></script>
<script type="text/javascript" src="../../js/operateResp.js"></script>
</head>
<%=getComboBoxStore() %>
<script>
Ext.onReady(function(){
    /*------实现toolbar的函数 start---------------*/
    var Toolbar = new Ext.Toolbar({
	    renderTo:"toolbar",
	    items:[{
		    text:"保存设置",
		    icon:"images/extjs/customer/add16.gif",
		    handler:function(){
		        Ext.Ajax.request({
                    url: 'frmOrgConfig.aspx?method=saveconfig',
                    method: 'POST',
                    params: {
                        SaleConfig: Ext.getCmp("SaleConfig").getValue(),
                        StoreConfig:Ext.getCmp("StoreConfig").getValue(),
                        SaleStore:Ext.getCmp("SaleStore").getValue(),
                        CustomerServer:Ext.getCmp("CustomerServer").getValue(),
                        AutoSplitPurch:Ext.getCmp("AutoSplitPurch").getValue(),
                        AutoSumqtyForSalerpt:Ext.getCmp("AutoSumqtyForSalerpt").getValue(),
                        CheckDate:Ext.util.Format.date(Ext.getCmp("CheckDate").getValue(),'Y/m/d')
                        
                    },
                   success: function(resp,opts){ 
                       checkExtMessage(resp);                       
                   },
		           failure: function(resp,opts){  /* Ext.Msg.alert("提示","保存失败"); */    }
                });
		    }
		    },'-']
    });
    
    /*------实现FormPanle的函数 start---------------*/
var orgConfigForm=new Ext.form.FormPanel({
	renderTo:'divForm',
	frame:true,
	title:'业务基础设置',
	items:[
		{
			xtype:'checkbox',
			fieldLabel:'人员是否需要过滤仓库信息',
			columnWidth:1,
			anchor:'50%',
			name:'StoreConfig',
			id:'StoreConfig',
			checked:storeConfig
		}
,		{
			xtype:'checkbox',
			fieldLabel:'做订单时，是否对人员所对应的仓库进行过滤',
			columnWidth:1,
			anchor:'50%',
			name:'SaleConfig',
			id:'SaleConfig',
			checked:saleConfig
		}
,		{
			xtype:'checkbox',
			fieldLabel:'做订单时，是否可以实时察看仓库库存信息',
			columnWidth:1,
			anchor:'50%',
			name:'SaleStore',
			id:'SaleStore',
			checked:saleStore			
		},
		{
			xtype:'checkbox',
			fieldLabel:'做订单时，是否实行客户经理制度',
			columnWidth:1,
			anchor:'50%',
			name:'CustomerServer',
			id:'CustomerServer',
			checked:customerServer			
		},
		{
			xtype:'checkbox',
			fieldLabel:'采购分割是否自动分割',
			columnWidth:1,
			anchor:'50%',
			name:'AutoSplitPurch',
			id:'AutoSplitPurch',
			checked:autoSplitPurch			
		},
		{
			xtype:'checkbox',
			fieldLabel:'是否需要合计营业报表的数量',
			columnWidth:1,
			anchor:'50%',
			name:'AutoSumqtyForSalerpt',
			id:'AutoSumqtyForSalerpt',
			checked:autoSumqtyForSalerpt			
		},
		{
			xtype:'datefield',
			fieldLabel:'关帐开始检查时间',
			columnWidth:1,
			anchor:'50%',
			name:'CheckDate',
			id:'CheckDate',
			format: 'Y年m月d日'
		}
]
});
})
</script>
<body>
<div id='toolbar'></div>
    <div id='divForm'>    
    </div>
</body>
</html>
