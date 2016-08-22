<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmReportResult.aspx.cs" Inherits="RPT_frmReportResult" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>业务综合分析</title>
<meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<link rel="stylesheet" type="text/css" href="../ext3/resources/css/ext-all.css" />
<script type="text/javascript" src="../ext3/adapter/ext/ext-base.js"></script>
<script type="text/javascript" src="../ext3/ext-all.js"></script>
<script type="text/javascript" src="../ext3/example/ItemDeleter.js"></script>
<script type="text/javascript" src="../js/operateResp.js"></script>
<script type="text/javascript" src="../ext3/src/locale/ext-lang-zh_CN.js"></script>
</head>
<script>
Ext.onReady(function() {  

               
      var initOrderForm = new Ext.form.FormPanel({
           renderTo: 'divForm',
           frame: true,
           monitorValid: true, // 把有formBind:true的按钮和验证绑定
           labelWidth: 70,
           items:
           [
            {
                layout:'column',
                border: true,                                 
                items:
                [{
                   layout: 'form',
                   columnWidth: .95,  //该列占用的宽度，标识为20％
                   border: false,
                   items: [{
                            style: 'margin-left:0px',
                            cls: 'key',
                            xtype: 'textfield',
                            fieldLabel: '客户编号',
                            name: 'cusno',
                            id:'cusno',
                            anchor: '100%'
                          }]
                 },
                 {
                   layout: 'form',
                   columnWidth: .05,  //该列占用的宽度，标识为20％
                   border: false,
                   items: [{
                            xtype:'button', 
                            iconCls:"find",
                            autoWidth : true,
                            autoHeight : true,
                            id:'customFind',
                            hideLabel:true,
                            listeners:{
                                click:function(v){
                                }
                            }
                          }]
                 }]
            }]});
            
            //定义下拉框异步调用方法
        var dsCustomer = new Ext.data.Store({   
            url: 'frmReportResult.aspx?method=getCusByConLike',  
            reader: new Ext.data.JsonReader({  
                root: 'root',  
                totalProperty: 'totalProperty',  
                id: 'cusno'  
            }, [  
                {name: 'CustomerId', mapping: 'CustomerId'}, 
                {name: 'CustomerNo', mapping: 'CustomerNo'},  
                {name: 'ShortName', mapping: 'ShortName'},
                {name: 'ChineseName', mapping: 'ChineseName'},
                {name: 'Address', mapping: 'Address'},
                {name: 'LinkMan', mapping: 'LinkMan'},  
                {name: 'LinkTel', mapping: 'LinkTel'}, 
                {name: 'DeliverAdd', mapping: 'DeliverAdd'},
                {name: 'Remark', mapping: 'Remark'},
                {name: 'IsOrthercust', mapping: 'IsOrthercust'},
                {name: 'InvoiceType', mapping: 'InvoiceType'},
                {name: 'SettlementWay', mapping: 'SettlementWay'}
                
            ]) 
        });  
        // 定义下拉框异步返回显示模板
        var resultTpl = new Ext.XTemplate(  
            '<tpl for="."><div id="searchdivid" class="search-item">',  
                '<h3><span>编号:{CustomerNo}&nbsp;  名称:{ShortName}&nbsp;  联系人:{LinkMan}&nbsp;  线路:{Remark}</span></h3>',
            '</div></tpl>'  
        ); 
           var customer = new Ext.form.ComboBox({
                   xtype: 'combo',
                   store: dsCustomer,
                   applyTo: 'cusno',
                   minChars:1,  
                   pageSize:10,  
                   tpl:resultTpl,
                   hideTrigger:true, 
                   itemSelector: 'div.search-item',  
                   anchor: '98%',
                   onSelect: function(record) {
                        initCustomerInfo(record);
                        this.collapse();//隐藏下拉列表
                        if(record.data.IsOrthercust == 1)
                            Ext.Msg.alert("提示", "该客户为无碘盐客户！");
                    }
               });
               var customerId = 0;
           function initCustomerInfo( record){ 
                customerId =record.data.CustomerId;
                Ext.getCmp("cusno").setValue(record.data.CustomerNo+record.data.ShortName);
            
            }
            
            var initButtonForm = new Ext.form.FormPanel({
           renderTo: 'divGrid',
           frame: true,
           monitorValid: true, // 把有formBind:true的按钮和验证绑定
           labelWidth: 70,
           items:
           [
            {
                layout:'column',
                border: true,                                 
                items:
                [{
                       layout: 'form',
                       columnWidth: 0.2,  //该列占用的宽度，标识为20％
                       border: false,
                       items: [{
                                xtype:'button', 
                                iconCls:"find",
                                autoWidth : true,
                                autoHeight : true,
                                text:'客户订单情况',
                                id:'customFind',
                                hideLabel:true,
                                listeners:{
                                    click:function(v){
                                        if(customerId==0)
                                        {
                                            Ext.Msg.alert('系统提示','请选择客户信息');
                                            return;
                                        }
                                        var url='scm/frmReportHtml.aspx?ReportId=6&FilterName=CustomerId&FilterValue='+customerId;
                                        window.open(url, 'newwindow', 'height=500, width=800, top=100, left=100, toolbar=no, menubar=no, scrollbars=no,resizable=no,location=no, status=no');
                                    }
                                }
                              }]
                     },{
                       layout: 'form',
                       columnWidth: .2,  //该列占用的宽度，标识为20％
                       border: false,
                       items: [{
                                xtype:'button', 
                                iconCls:"find",
                                autoWidth : true,
                                autoHeight : true,
                                text:'客户产品销售情况',
                                id:'customer2',
                                hideLabel:true,
                                listeners:{
                                    click:function(v){
                                        if(customerId==0)
                                        {
                                            Ext.Msg.alert('系统提示','请选择客户信息');
                                            return;
                                        }
                                        var url='scm/frmReportHtml.aspx?ReportId=2&FilterName=CustomerId&FilterValue='+customerId;
                                        window.open(url, 'newwindow', 'height=500, width=800, top=100, left=100, toolbar=no, menubar=no, scrollbars=no,resizable=no,location=no, status=no');
                                    }
                                }
                              }]
                     }
//                     ,{
//                       layout: 'form',
//                       columnWidth: .2,  //该列占用的宽度，标识为20％
//                       border: false,
//                       items: [{
//                                xtype:'button', 
//                                iconCls:"find",
//                                autoWidth : true,
//                                autoHeight : true,
//                                text:'客户订单明细',
//                                id:'customer2',
//                                hideLabel:true,
//                                listeners:{
//                                    click:function(v){
//                                        if(customerId==0)
//                                        {
//                                            Ext.Msg.alert('系统提示','请选择客户信息');
//                                            return;
//                                        }
//                                        var url='scm/frmReportHtml.aspx?ReportId=2&FilterName=CustomerId&FilterValue='+customerId;
//                                        window.open(url, 'newwindow', 'height=500, width=800, top=100, left=100, toolbar=no, menubar=no, scrollbars=no,resizable=no,location=no, status=no');
//                                    }
//                                }
//                              }]
//                     }
                     ]
            },{
                layout:'column',
                border: true,                                 
                items:
                [{
                       layout: 'form',
                       columnWidth: 0.2,  //该列占用的宽度，标识为20％
                       border: false,
                       items: [{
                                xtype:'button', 
                                iconCls:"find",
                                autoWidth : true,
                                autoHeight : true,
                                text:'客户新增情况',
                                id:'customFind',
                                hideLabel:true,
                                listeners:{
                                    click:function(v){
                                        
                                        var url='scm/frmReportHtml.aspx?ReportId=3';
                                        window.open(url, 'newwindow', 'height=500, width=800, top=100, left=100, toolbar=no, menubar=no, scrollbars=no,resizable=no,location=no, status=no');
                                    }
                                }
                              }]
                     },{
                       layout: 'form',
                       columnWidth: .2,  //该列占用的宽度，标识为20％
                       border: false,
                       items: [{
                                xtype:'button', 
                                iconCls:"find",
                                autoWidth : true,
                                autoHeight : true,
                                text:'客户流失情况',
                                id:'customer20',
                                hideLabel:true,
                                listeners:{
                                    click:function(v){
                                        
                                        var url='scm/frmReportHtml.aspx?ReportId=4';
                                        window.open(url, 'newwindow', 'height=500, width=800, top=100, left=100, toolbar=no, menubar=no, scrollbars=no,resizable=no,location=no, status=no');
                                    }
                                }
                              }]
                     },{
                       layout: 'form',
                       columnWidth: .2,  //该列占用的宽度，标识为20％
                       border: false,
                       items: [{
                                xtype:'button', 
                                iconCls:"find",
                                autoWidth : true,
                                autoHeight : true,
                                text:'线路客户订单情况',
                                id:'customer21',
                                hideLabel:true,
                                listeners:{
                                    click:function(v){
                                        var url='scm/frmReportHtml.aspx?ReportId=7';
                                        window.open(url, 'newwindow', 'height=500, width=800, top=100, left=100, toolbar=no, menubar=no, scrollbars=no,resizable=no,location=no, status=no');
                                    }
                                }
                              }]
                     }]
            }]});

})
</script>
<body>
    <div id='divForm'></div>
<div id='divGrid'></div>
<div id='divBotton'></div>
</body>
</html>
