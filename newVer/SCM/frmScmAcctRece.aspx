<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmScmAcctRece.aspx.cs" Inherits="SCM_frmScmAcctRece" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html>
<head>
<title>Ӧ���ʿ�</title><meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
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
        var query = location.search.substring(1); //��ȡ��ѯ��   
        var pairs = query.split("&"); //�ڶ��Ŵ��Ͽ�   
        for (var i = 0; i < pairs.length; i++) {
            var pos = pairs[i].indexOf('='); //����name=value   
            if (pos == -1) continue; //���û���ҵ�������   
            var argname = pairs[i].substring(0, pos); //��ȡname   
            var value = pairs[i].substring(pos + 1); //��ȡvalue   
            args[argname] = unescape(value); //��Ϊ����   
        }
        return args;
    }
    var args = new Object();
    args = GetUrlParms();
    //���Ҫ���Ҳ���key:
    var sumAmt = args["sumAmt"];//�ܶ�
    var strOrderId = args["strOrderId"];//�����Ŵ�����,�ָ�
    var OrderIdArray = strOrderId.split(",");//��������
    var strCustomerId = args["strCustomerId"];
    var billtype = args["billtype"];//��������
    if (strCustomerId == null)
        strCustomerId = 0;
    if (billtype == null)
        billtype = 1;

    if(billtype==2){
       dsFundType = new Ext.data.SimpleStore({ fields: ['DicsCode', 'DicsName', 'OrderIndex'], data: [['F052', '�˿�', '1'],['F051', 'Ӧ��', '2']],  autoLoad: false });
    }

    Ext.onReady(function() {


        //����
        function saveAdd() {
            Ext.MessageBox.wait("�������ڱ��棬���Ժ򡭡�");
            var inputAmt = Ext.getCmp('Amount').getValue();
            if (OrderIdArray.length > 1) {
                if (sumAmt != inputAmt) {
                    Ext.MessageBox.hide();
                    Ext.Msg.alert("��ʾ", "�Զ������ͳһ�տ�ʱ�������ܶ���ȣ�");
                    return;
                }
            }

            var strMethod = "saveAdd"; //���ַ�Ʊ����          
            if (billtype == 2)//����
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
                    Ext.Msg.alert("��ʾ", "����ʧ��");
                }
            });
        }



        //Ӧ���ʿ���������
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
                                labelSeparator: '��',
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
			                                fieldLabel: 'ҵ������',
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
	                             labelSeparator: '��',
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
			                                fieldLabel: '�ʽ���',
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
	                             labelSeparator: '��',
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
			                                fieldLabel: '��������',
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
	                             labelSeparator: '��',
	                             items: [
	                            {
	                                layout: 'form',
	                                border: false,
	                                columnWidth: 1,
	                                items: [
			                            {
			                                xtype: 'numberfield',
			                                fieldLabel: '���',
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
            border: true, // û�б߿�
            labelAlign: 'left',
            buttonAlign: 'center',
            bodyStyle: 'padding:1px',
            height: 25,
            frame: true,
            labelWidth: 55,
            buttons: [{
                text: "����",
                scope: this,
                id: 'saveButton',
                handler: function(f) {  f.disable();saveAdd(); f.enable(); }
            },
                 {
                     text: "ȡ��",
                     scope: this,
                     handler: function() {
                         parent.openAcctWindow.hide();
                     }
}]
        });

        //�ܽ��
        Ext.getCmp("Amount").setValue(sumAmt);
        //Ӧ��
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
        //֧����ʽ
        Ext.getCmp("PayType").setValue(strPayType);
        if(strOrderId>0){
            Ext.getCmp('Amount').getEl().dom.readOnly=true; 
        }

    })
  
  
</script>

</html>
