<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmScmAcctRece.aspx.cs" Inherits="SCM_frmScmAcctRece" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html>
<head>
<title>应收帐款</title><meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
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
    var strCustomerId = args["strCustomerId"];
    var billtype = args["billtype"];//红字蓝字
    if (strCustomerId == null)
        strCustomerId = 0;
    if (billtype == null)
        billtype = 1;

    if(billtype==2){
       dsFundType = new Ext.data.SimpleStore({ fields: ['DicsCode', 'DicsName', 'OrderIndex'], data: [['F052', '退款', '1'],['F051', '应退', '2']],  autoLoad: false });
    }

    Ext.onReady(function() {


        //保存
        function saveAdd() {
            Ext.MessageBox.wait("数据正在保存，请稍候……");
            var inputAmt = Ext.getCmp('Amount').getValue();
            if (OrderIdArray.length > 1) {
                if (sumAmt != inputAmt) {
                    Ext.MessageBox.hide();
                    Ext.Msg.alert("提示", "对多个订单统一收款时，必须总额相等！");
                    return;
                }
            }

            var strMethod = "saveAdd"; //蓝字发票保存          
            if (billtype == 2)//红字
                strMethod = "saveRed";

            Ext.Ajax.request({
                url: 'frmScmAcctRece.aspx?method=' + strMethod,
                method: 'POST',
                params: {
                    strOrderID: strOrderId,
                    strCustomerID: strCustomerId,
                    Amount: Ext.getCmp('Amount').getValue(),
                    BusinessType: Ext.getCmp('BusinessType').getValue(),
                    FundType: Ext.getCmp('FundType').getValue(),
                    PayType: Ext.getCmp('PayType').getValue()
                },
                success: function(resp, opts) {
                    Ext.MessageBox.hide();
                    checkParentExtMessage(resp, parent);
                    parent.OrderMstGridData.reload();
                    parent.openAcctWindow.hide(); 
                },
                failure: function(resp, opts) {
                    Ext.MessageBox.hide(); 
                    Ext.Msg.alert("提示", "保存失败");
                }
            });
        }



        //应收帐款输入内容
        var modDtlFormInput = new Ext.FormPanel({
            renderTo: 'divForm',
            frame: true,

            bodyStyle: 'padding:5px',
            frame: true,
            labelWidth: 55,
            items: [
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
			                                xtype: 'combo',
			                                store: dsBizType,
			                                valueField: 'DicsCode',
			                                displayField: 'DicsName',
			                                mode: 'local',
			                                forceSelection: true,
			                                editable: false,
			                                emptyValue: '',
			                                triggerAction: 'all',
			                                fieldLabel: '业务种类',
			                                name: 'BusinessType',
			                                id: 'BusinessType',
			                                selectOnFocus: true,
			                                anchor: '90%',
			                                editable: false
			                            }
	                                        ]
}]
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
			                                xtype: 'combo',
			                                store: dsFundType,
			                                valueField: 'DicsCode',
			                                displayField: 'DicsName',
			                                mode: 'local',
			                                forceSelection: true,
			                                editable: false,
			                                emptyValue: '',
			                                triggerAction: 'all',
			                                fieldLabel: '资金方向',
			                                name: 'FundType',
			                                id: 'FundType',
			                                selectOnFocus: true,
			                                anchor: '90%',
			                                editable: false
			                            }
	                                        ]
}]
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
			                                xtype: 'combo',
			                                store: dsPayType,
			                                valueField: 'DicsCode',
			                                displayField: 'DicsName',
			                                mode: 'local',
			                                forceSelection: true,
			                                editable: false,
			                                emptyValue: '',
			                                triggerAction: 'all',
			                                fieldLabel: '付款类型',
			                                name: 'PayType',
			                                id: 'PayType',
			                                selectOnFocus: true,
			                                anchor: '90%',
			                                editable: false
			                            }
	                                        ]
}]
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
			                                xtype: 'numberfield',
			                                fieldLabel: '金额',
			                                columnWidth: 0.25,
			                                anchor: '90%',
			                                name: 'Amount',
			                                id: 'Amount',
			                                editable: false
			                            }
	                                        ]
}]
	                         }
	                         ]

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
                handler: function(f) {  f.disable();saveAdd(); f.enable(); }
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
        //应收
        Ext.getCmp("FundType").setDisabled(true);
        Ext.getCmp("BusinessType").setDisabled(true);
        Ext.getCmp("FundType").setValue("F052");
        Ext.getCmp("BusinessType").setValue("F061");
        if (billtype == 2) {
            Ext.getCmp("FundType").setValue("F052");
            Ext.getCmp("FundType").setDisabled(true);
	        Ext.getCmp("BusinessType").setDisabled(true);
            Ext.getCmp("BusinessType").setValue("F062");
        }
        //支付方式
        Ext.getCmp("PayType").setValue(strPayType);
        if(strOrderId>0){
            Ext.getCmp('Amount').getEl().dom.readOnly=true; 
        }

    })
  
  
</script>

</html>
