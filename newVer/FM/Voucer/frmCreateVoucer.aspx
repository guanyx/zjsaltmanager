<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmCreateVoucer.aspx.cs" Inherits="FM_Voucer_frmCreateVoucer" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>凭证产生</title>
    <meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
    <link rel="stylesheet" type="text/css" href="../../ext3/resources/css/ext-all.css" />
    <script type="text/javascript" src="../../ext3/adapter/ext/ext-base.js"></script>
    <script type="text/javascript" src="../../ext3/ext-all.js"></script>
    <script type="text/javascript" src="../../js/operateResp.js"></script>
</head>
<body>
<div id='toolbar'></div>
<div id='divSearchForm'></div>
<div id='divDataGrid'></div>
</body>
<%=getComboBoxStore()%>
<script type="text/javascript">
Ext.BLANK_IMAGE_URL = "../../ext3/resources/images/default/s.gif";
Ext.onReady(function() {
    /*------实现toolbar的函数 start---------------*/
    var Toolbar = new Ext.Toolbar({
        renderTo: "toolbar",
        items: [{
            text: "开始产生凭证",
            icon: "../../Theme/1/images/extjs/customer/add16.gif",
            handler: function() {
                buildPZ();
            }
            //    }, '-', {
            //        text: "查看",
            //        icon: "../Theme/1/images/extjs/customer/edit16.gif",
            //        handler: function() {  }
        }

            ]
    });
    /*------结束toolbar的函数 end---------------*/
    function buildPZ() {
        var type = "";
        if (Ext.getCmp("WarehouseVoucher").checked)
            type = 11;
        else if (Ext.getCmp("SaleVoucher").checked)
            type = 22;
        var StartDate = Ext.util.Format.date(Ext.getCmp('StartDate').getValue(), 'Y/m/d');
        var EndDate = Ext.util.Format.date(Ext.getCmp('EndDate').getValue(), 'Y/m/d');
        var part = -1;
        if (!Ext.getCmp("AllPart").checked)
            part = Ext.getCmp("DetailPart").getValue();
            
        Ext.MessageBox.wait("正在生成凭证数据，请稍后……");
        Ext.Ajax.request({
            url: 'frmCreateVoucer.aspx?method=buildePZ',
            method: 'POST',
            params: {
                VoucherType: type,
                DetailPart: part,
                StartDate: StartDate,
                EndDate: EndDate
            },
            success: function(resp, opts) {
                if (checkExtMessage(resp)) {
                    Ext.MessageBox.hide();
                    Ext.Msg.alert("提示", "生成凭证成功");
                }      
            },
            failure: function(resp, opts) {
                Ext.MessageBox.hide();
                Ext.Msg.alert("提示", "生成凭证失败");
            }
        });
    }
    /*------实现toolbar的函数 start---------------*/
    var serchform = new Ext.FormPanel({
        renderTo: 'divSearchForm',
        labelAlign: 'left',
        buttonAlign: 'center',
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
            xtype: "fieldset",
            title: '凭证类型',
            items: [
            {
                layout: 'column',
                border: false,
                items: [
                {
                    columnWidth: .2,
                    layout: 'form',
                    items: [{
                        cls: 'key',
                        xtype: 'checkbox',
                        boxLabel: '仓库凭证',
                        name: 'WarehouseVoucher',
                        id: 'WarehouseVoucher',
                        anchor: '90%',
                        hideLabel: true
}]
                    },
                {
                    columnWidth: .2,
                    layout: 'form',
                    items: [{
                        cls: 'key',
                        xtype: 'checkbox',
                        boxLabel: '销售凭证',
                        name: 'SaleVoucher',
                        id: 'SaleVoucher',
                        anchor: '90%',
                        hideLabel: true
}]
}]
}]
                }
        , {
            layout: 'form',
            xtype: "fieldset",
            title: '时间选择',
            items: [
            {
                layout: 'column',
                border: false,
                items: [
                {
                    columnWidth: .25,
                    layout: 'form',
                    items: [{
                        xtype: 'datefield',
                        fieldLabel: '开始日期',
                        anchor: '90%',
                        name: 'StartDate',
                        id: 'StartDate',
                        format: 'Y年m月d日',  //添加中文样式
                        value: new Date().getFirstDateOfMonth().clearTime()
}]
                    },
                {
                    columnWidth: .25,
                    layout: 'form',
                    items: [{
                        xtype: 'datefield',
                        fieldLabel: '结束日期',
                        anchor: '90%',
                        name: 'EndDate',
                        id: 'EndDate',
                        format: 'Y年m月d日',  //添加中文样式
                        value: new Date().clearTime()
}]
}]
}]
                }
        , {
            layout: 'form',
            xtype: "fieldset",
            title: '部门',
            items: [
            {
                layout: 'column',
                border: false,
                items: [
                {
                    columnWidth: .2,
                    layout: 'form',
                    items: [{
                        cls: 'key',
                        xtype: 'checkbox',
                        boxLabel: '所有部门',
                        name: 'AllPart',
                        id: 'AllPart',
                        anchor: '90%',
                        hideLabel: true,
                        listeners: {
                            check: function(c) {
                                if (c.checked) { Ext.getCmp('DetailPart').setDisabled(true); }
                                else { Ext.getCmp('DetailPart').setDisabled(false); }
                            }
                        }
}]
                    },
                {
                    columnWidth: .25,
                    layout: 'form',
                    items: [{
                        xtype: 'combo',
                        fieldLabel: '指定部门',
                        anchor: '95%',
                        name: 'DetailPart',
                        id: 'DetailPart',
                        store: dsWareHouse,  //部门列表
                        valueField: 'WhId',
                        displayField: 'WhName',
                        mode: 'local',
                        triggerAction: 'all'
}]
}]
}]//--       
}]
}]
    });

})
</script>
</html>
