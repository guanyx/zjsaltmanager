<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmScmCustomerManager.aspx.cs" Inherits="SCM_frmScmCustomerManager" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>业务员设置</title>
    <meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
    <link rel="stylesheet" type="text/css" href="../ext3/resources/css/ext-all.css" />
    <script type="text/javascript" src="../ext3/adapter/ext/ext-base.js"></script>
    <script type="text/javascript" src="../ext3/ext-all.js"></script>
    <script type="text/javascript" src="../js/operateResp.js"></script>
    <style type="text/css">
    .x-grid-back-blue { 
    background: #B7CBE8; 
    }
    </style>

</head>
<body>
<div id='divForm'></div>
<div id='divBotton'></div>
</body>
<%=getComboBoxStore()%>
<script type="text/javascript">
Ext.BLANK_IMAGE_URL = "../ext3/resources/images/default/s.gif"; 

function GetUrlParms() {
        var args = new Object();
        var query = location.search.substring(1); //获取查询串   
        var pairs = query.split("&"); //在逗号处断开   
        for (var i = 0; i < pairs.length; i++) {
            var pos = pairs[i].indexOf('='); //查找name=value   
            if (pos == -1) continue; //如果没有找到就跳过   
            var argname = pairs[i].substring(0, pos); //提取name   
            var value = pairs[i].substring(pos + 1); //提取value   
            args[argname] = unescape(value); //存为属性   
        }
        return args;
    }
    var args = new Object();
    args = GetUrlParms();
    //如果要查找参数key:
    var sumAmt = args["sumAmt"];//总额
    var strOrderId = args["strOrderId"];//订单号串，用,分隔
    var OrderIdArray = strOrderId.split(",");//订单数组

    Ext.onReady(function() {

        //保存
        function saveAdd() {
            Ext.MessageBox.wait("数据正在保存，请稍候……");
            var inputAmt = Ext.getCmp('Amount').getValue();
            
            Ext.Ajax.request({
                url: 'frmScmCustomerManager.aspx?method=saveAdd',
                method: 'POST',
                params: {
                    strOrderID: strOrderId,
                    Amount: Ext.getCmp('Amount').getValue(),
                    CustomerManager:Ext.getCmp('CustomerManager').getValue()
                },
                success: function(resp, opts) {
                    Ext.MessageBox.hide();
                    checkParentExtMessage(resp, parent); 
                },
                failure: function(resp, opts) {
                    Ext.MessageBox.hide(); 
                    Ext.Msg.alert("提示", "保存失败");
                }
            });
        }
        //输入内容
        var modDtlFormInput = new Ext.FormPanel({
            renderTo: 'divForm',
            frame: true,
            bodyStyle: 'padding:5px',
            frame: true,
            labelWidth: 55,
            items: 
            [{
                layout: 'column',
                border: false,
                labelSeparator: '：',
                items: 
                [{
                    layout: 'form',
                    border: false,
                    columnWidth: 1,
                    items: 
                    [{
                        xtype: 'numberfield',
                        fieldLabel: '金额',
                        columnWidth: 0.25,
                        anchor: '90%',
                        name: 'Amount',
                        id: 'Amount',
                        editable: false,
                        readOnly:true
                    }]
                },{
                    layout: 'form',
                    border: false,
                    columnWidth: 1,
                    items: [
                    {
                        xtype: 'combo',
                        store: dsEmpList,
                        valueField: 'EmpId',
                        displayField: 'EmpName',
                        mode: 'local',
                        forceSelection: true,
                        emptyValue: '',
                        triggerAction: 'all',
                        fieldLabel: '业务员',
                        name: 'CustomerManager',
                        id: 'CustomerManager',
                        selectOnFocus: true,
                        anchor: '90%',
                        editable: true
                    }]
                }]
            }]
        });



        var footerForm = new Ext.FormPanel({
            renderTo: 'divBotton',
            border: true, // 没有边框
            labelAlign: 'left',
            buttonAlign: 'center',
            bodyStyle: 'padding:1px',
            height: 25,
            frame: true,
            labelWidth: 55,
            buttons: [{
                text: "保存",
                scope: this,
                id: 'saveButton',
                handler: function() { saveAdd(); }
            },
                 {
                     text: "取消",
                     scope: this,
                     handler: function() {
                         parent.openAcctWindow.hide();
                     }
            }]
        });

        //总金额
        Ext.getCmp("Amount").setValue(sumAmt);

    })
  
  
</script>

</html>
