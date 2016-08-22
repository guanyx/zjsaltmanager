<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmWmsRateList.aspx.cs" Inherits="WMS_frmWmsRateList" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>费用维护</title>
    <meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
    <link rel="stylesheet" type="text/css" href="../ext3/resources/css/ext-all.css" />
    <link rel="Stylesheet" type="text/css" href="../css/columnLock.css" />
	<script type="text/javascript" src="../ext3/adapter/ext/ext-base.js"></script>	
	<script type="text/javascript" src="../ext3/ext-all.js"></script>
	<script type="text/javascript" src="../js/ExtJsHelper.js"></script>
	<script type="text/javascript" src="../js/operateResp.js"></script>
	<script type="text/javascript" src="../js/EmpSelect.js"></script>
	<script type="text/javascript" src="../js/FilterControl.js"></script>
	<script type="text/javascript" src="../js/columnLock.js"></script>
	<script type="text/javascript" src="../js/operateResp.js"></script>
	<script type="text/javascript" src="../js/getExcelXml.js"></script>
	<script type="text/javascript" src="../js/floatUtil.js"></script>
	<script type="text/javascript" src="../js/GroupFieldSelect.js"></script>
	<script type="text/javascript" src="../ext3/src/locale/ext-lang-zh_CN.js"></script>

</head>
<%=getComboBoxSource() %>
<script>

    function getCmbStore(columnName) {
        switch (columnName) {
            case "RateStatus":
                return RateStatusStore;
            case "RateType":
                return RateTypeStore;
            case "BillType":
            var dsBillType = new Ext.data.SimpleStore({ 
                fields:['BillType','BillTypeText'],
                data:[['采购入仓','采购入仓'],['领货出仓','领货出仓'],
                      ['移库出库','移库出库'],['移库入库','移库入库'],['移仓','移仓'],
                      ['升溢','升溢'],['损耗','损耗'],                        
                        ['销售退货','销售退货'],['采购退货','采购退货'],                        
                        ['直拨出','直拨出'],['直拨进','直拨进'],
                        ['转换入','转换入'],['转换出','转换出'], 
                        ['采购降级入仓','采购降级入仓'],
                        ['生产入仓','生产入仓'],['生产出仓','生产出仓'],
                        ['盘点','盘点'],['生产退货','生产退货']],                     
                autoLoad: false});
            return dsBillType;
            break;
        }
        return null;
    }

    var wmsRateData;
    function loadRateList() {
        wmsRateData.baseParams.detailId = detailId;
        wmsRateData.load({ params: { limit: 10, start: 0} });
        if(detailId>0)
        {
            Ext.Ajax.request({
                        url: 'frmWmsRateList.aspx?method=gettype',
                        method: 'POST',
                        params: {
                            DetailId:detailId
                        },
                        success: function(resp, opts) {
                            var resu = Ext.decode(resp.responseText);
                            whId = resu.WhId;
                            fromBillType=resu.FromBillType;
                        },
                        failure: function(resp, opts) {
                            Ext.Msg.alert("提示", "数据删除失败");
                        }
                    });
        }
    }
    var sortInfor = '';
    var defaultPageSize = 10;

    Ext.BLANK_IMAGE_URL = "../ext3/resources/images/default/s.gif"
    Ext.onReady(function() {
        var saveType = "";
        /*------实现toolbar的函数 start---------------*/
        var Toolbar = new Ext.Toolbar({
            renderTo: "toolbar",
            items: [{
                text: "新增",
                icon: "../theme/1/images/extjs/customer/add16.gif",
                handler: function() {
                    saveType = "addrate";
                    openAddRateWin();
                }
            }, '-', {
                text: "编辑",
                icon: "../theme/1/images/extjs/customer/edit16.gif",
                handler: function() {
                    saveType = "editrate";
                    modifyRateWin();
                }
            }, '-', {
                text: "删除",
                icon: "../theme/1/images/extjs/customer/delete16.gif",
                handler: function() {
                    deleteRate();
                }
            }, '-', {
                text: "结算",
                //title:'只能结算查询出结果列表中的数据！',
                icon: "../theme/1/images/extjs/customer/pay.png",
                menu:createMenu()
                //handler: function() { }
            },  '-', {
                text: "打印",
                icon: "../Theme/1/images/extjs/customer/edit16.gif",
                handler: function() {
                    printOtherRate();
                }
            },'-']
        });
        
        function createMenu()
        {
	        var menu = new Ext.menu.Menu({
                id: 'mainMenu',
                style: {
                    overflow: 'visible'
               },
               items: [
	            {
                   text: '当前页选中费用项',
                   //title:'对查询出来的费果列表中当前页勾选的费用项进行结算，如果已经结算的费用不会再结算。',
                   icon: '../../Theme/1/images/extjs/customer/coin.png',
                   handler: function(){ settleRate('coin'); }
                },'-',
	            {
                   text: '当前页全部费用项',
                   //title:'对查询出来的费果列表中当前页勾选的费用项进行结算，如果已经结算的费用不会再结算。',
                   icon: '../../Theme/1/images/extjs/customer/cash.png',
                   handler: function(){ settleRate('cash'); }
//                },'-',
//                {
//                   text: '所有页全部费用项',
//                   //title:'对查询出来的结果列表中当前页所有费用项进行结算，如果已经结算的费用不会再结算。',
//                   icon: '../../Theme/1/images/extjs/customer/card.png',
//                   handler: function(){ settleRate('card'); }
                }
                ]});
	        return menu;
        }

        setToolBarVisible(Toolbar);
        /*------结束toolbar的函数 end---------------*/
            function getUrl(imageUrl)
            {
                var index = window.location.href.toLowerCase().indexOf('/wms/');
                var tempUrl = window.location.href.substring(0,index);
                return tempUrl+"/"+imageUrl;
            }
            function settleRate(type){    
                var rateIds = "";
                var others='';                      
                switch(type)
                {
                    case 'coin':
                        //多选
                        var sm = Ext.getCmp('wmsRateGrid').getSelectionModel();      
                        var selectData = sm.getSelections();                
                        var array = new Array(selectData.length);
                        for(var i=0;i<selectData.length;i++)
                        {
                            if(rateIds.length>0)
                                rateIds+=",";
                            rateIds += selectData[i].get('RateId');
                        }
                    break;
                    case 'cash':
                        //单页
                        wmsRateData.each(function(recordLoop) {
                            if(rateIds.length>0)
                                rateIds+=",";
                            rateIds += recordLoop.get('RateId');
                        });                 
                    break;
                    case 'card':
                        //所有页
//                        var o  =_grid.getStore().baseParams;
//                        if(o.filter[0]);
//                        if(o.filter[0].ColumnValue);
//                        alert(o.limit);
//                        alert(o.start);
//                        alert(o.filter);
//                        alert(o.detailId);
//                        alert(o.SortInfo);
                    break;
                }
                if(rateIds!=''){
                     Ext.Ajax.request({
                        url: 'frmWmsRateList.aspx?method=settlerate',
                        method: 'POST',
                        params: {
                            RateIds: rateIds,
                            Params:others
                        },
                       success: function(resp,opts){                    
                          if (checkExtMessage(resp)) {
                                wmsRateData.reload();
                            }
                       },
		               failure: function(resp,opts){  /* Ext.Msg.alert("提示","保存失败"); */    }
                    });
                }
            }
            function printOtherRate()
            {
                var sm = Ext.getCmp('wmsRateGrid').getSelectionModel();
                //多选
                var selectData = sm.getSelections();                
                var array = new Array(selectData.length);
                var rateIds = "";
                for(var i=0;i<selectData.length;i++)
                {
                    if(rateIds.length>0)
                        rateIds+=",";
                    rateIds += selectData[i].get('RateId');
                }
                //alert(orderIds);
                //页面提交
                Ext.Ajax.request({
                    url: 'frmWmsRateList.aspx?method=printdate',
                    method: 'POST',
                    params: {
                        RateId: rateIds
                    },
                   success: function(resp,opts){ 
                       var printData =  resp.responseText;
                       var printControl =  parent.parent.parent.document.getElementById("topFrame").contentWindow.getPrintControl();
                       printControl.Url =getUrl('xml');
                       printControl.MapUrl = printControl.Url+'/'+printStyleXml;//'/salePrint1.xml';
                       //alert(printControl.Url+'/'+printStyleXml);
                       printControl.PrintXml = printData;
                       printControl.ColumnName="RateId";
                       printControl.OnlyData=printOnlyData;
                       printControl.PageWidth=printPageWidth;
                       printControl.PageHeight =printPageHeight ;
                       printControl.Print();                       
                      
                   },
		           failure: function(resp,opts){  /* Ext.Msg.alert("提示","保存失败"); */    }
                });
}

        /*------开始ToolBar事件函数 start---------------*//*-----新增Rate实体类窗体函数----*/
        function openAddRateWin() {
            Ext.getCmp('RateId').setValue("");
            //Ext.getCmp('OrderDetailId').setValue("");
            Ext.getCmp('RatePayee').setValue("");
            Ext.getCmp('RatePayeename').setValue("");
            Ext.getCmp('RateCompany').setValue("");
            Ext.getCmp('RateType').setValue("");
            Ext.getCmp('RatePrice').setValue("0");
            Ext.getCmp('RateAmt').setValue("0");
            Ext.getCmp('RateQty').setValue("0");
            Ext.getCmp('RatePayer').setValue("");
            Ext.getCmp('RatePayorg').setValue("");
            Ext.getCmp('RatePaydate').setValue("");
            Ext.getCmp('PureRate').setValue("0.06");
            Ext.getCmp('PureAmt').setValue("0");
            Ext.getCmp('RateStatus').setValue("W1201");
            Ext.getCmp('RateMemo').setValue("");
            Ext.getCmp('RateAdd').setValue("");
            Ext.getCmp('ShipNo').setValue("");
            Ext.getCmp('BusinessType').setValue(fromBillType);
            Ext.getCmp('WhId').setValue(whId);
            if(detailId>0)
            {
                Ext.getCmp('WhId').disabled=true;;
                
                Ext.getCmp('BusinessType').disabled=true;
            }
            uploadRateWindow.show();
        }
        /*-----编辑Rate实体类窗体函数----*/
        function modifyRateWin() {
            var sm = Ext.getCmp('wmsRateGrid').getSelectionModel();
            //获取选择的数据信息
            var selectData = sm.getSelected();
            if (selectData == null) {
                Ext.Msg.alert("提示", "请选中需要编辑的信息！");
                return;
            }
            uploadRateWindow.show();
            setFormValue(selectData);
        }
        /*-----删除Rate实体函数----*/
        /*删除信息*/
        function deleteRate() {
            var sm = Ext.getCmp('wmsRateGrid').getSelectionModel();
            //获取选择的数据信息
            var selectData = sm.getSelected();
            //如果没有选择，就提示需要选择数据信息
            if (selectData == null) {
                Ext.Msg.alert("提示", "请选中需要删除的信息！");
                return;
            }else{
                if( selectData.data.RateStatus == "W1202"){
                    Ext.Msg.alert("提示", "已付状态下的费用记录不能删除！");
                    return;
                }
            }
            //删除前再次提醒是否真的要删除
            Ext.Msg.confirm("提示信息", "是否真的要删除选择的费用信息吗？", function callBack(id) {
                //判断是否删除数据
                if (id == "yes") {
                    //页面提交
                    Ext.Ajax.request({
                        url: 'frmWmsRateList.aspx?method=deleterate',
                        method: 'POST',
                        params: {
                            RateId: selectData.data.RateId
                        },
                        success: function(resp, opts) {
                            if (checkExtMessage(resp)) {
                                wmsRateData.reload();
                            }
                        },
                        failure: function(resp, opts) {
                            Ext.Msg.alert("提示", "数据删除失败");
                        }
                    });
                }
            });
        }

        /*------实现FormPanle的函数 start---------------*/
        var rateForm = new Ext.form.FormPanel({
            frame: true,
	        //labelWidth:70,
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
		    labelWidth: 70,
		    items: [
				{
				    xtype: 'combo',
				    fieldLabel: '收款单位',
				    columnWidth: 1,
				    anchor: '98%',
				    name: 'RateCompany',
				    id: 'RateCompany',
				    store: RateCompanyStore,
				    displayField: 'Name',
				    valueField: 'Id',
				    typeAhead: true,
				    mode: 'local',
				    editable: false,
				    emptyText: '请选择收款单位信息',
				    triggerAction: 'all'
				}
		]
		}
	]
	},{
	    layout: 'column',
	    border: false,
	    labelSeparator: '：',
	    items: [
  {
    layout: 'form',
    border: false,
    columnWidth:0.33,
    labelWidth: 70,
    items: [
				{
				    xtype: 'textfield',
				    fieldLabel: '收款人',
				    anchor: '98%',
				    name: 'RatePayeename',
				    id: 'RatePayeename'
				},
				{
				    xtype: 'hidden',
				    fieldLabel: '收款人',
				    columnWidth: 0.5,
				    anchor: '98%',
				    name: 'RateId',
				    id: 'RateId'
				}, {
				    xtype: 'hidden',
				    fieldLabel: '收款人',
				    columnWidth: 0.5,
				    anchor: '98%',
				    name: 'RatePayee',
				    id: 'RatePayee'
				}
		]
},{
    layout: 'form',
    border: false,
    columnWidth: 0.33,
    labelWidth: 70,
    items: [
				{
				     xtype: 'combo',
                     fieldLabel: '仓库名称',
                    anchor: '95%',
                    id: 'WhId',
                    displayField: 'WhName',
                    valueField: 'WhId',
                    editable: false,
                    store: dsWarehouseList,
                    mode: 'local',
                    triggerAction: 'all'
				}
		]
},{
    layout: 'form',
    border: false,
    columnWidth: 0.33,
    labelWidth: 70,
    items: [
				{
				    xtype: 'combo',
                     fieldLabel: '业务类型',
                    anchor: '95%',
                    id: 'BusinessType',
                    displayField: 'DicsName',
                    valueField: 'DicsCode',
                    editable: false,
                    store: dsBillTypeList,
                    mode: 'local',
                    triggerAction: 'all'
				}
		]
}
	]
	},
	{
	    layout: 'column',
	    border: false,
	    labelSeparator: '：',
	    items: [
		{
		    layout: 'form',
		    border: false,
		    columnWidth: 0.5,
		    labelWidth: 70,
		    items: [
			{
			    xtype: 'combo',
			    fieldLabel: '费用类型',
			    columnWidth: 0.5,
			    anchor: '98%',
			    name: 'RateType',
			    id: 'RateType',
			    store: RateTypeStore,
			    displayField: 'DicsName',
			    valueField: 'DicsCode',
			    typeAhead: true,
			    mode: 'local',
			    editable: false,
			    emptyText: '请选择费用类型信息',
			    triggerAction: 'all',
			    listeners: {
                    select: function(combo, record, index) {
                        if(combo.getValue()=='W1101'){
                            Ext.getCmp('PureRate').setValue(0.11);
                            var amt =Ext.getCmp('RateAmt').getValue();                            
                            if(amt>0)
                                Ext.getCmp("PureAmt").setValue(accDiv(amt,1.11).toFixed(2));
                        }
                        else{
                            Ext.getCmp('PureRate').setValue(0);
                            var amt =Ext.getCmp('RateAmt').getValue();
                            if(amt>0)                          
                                Ext.getCmp("PureAmt").setValue(amt);
                        }
                    }
                }
			}
		]
		}
, {
    layout: 'form',
    border: false,
    columnWidth: 0.49,
    labelWidth: 60,
    items: [
				{
				    xtype: 'hidden',
				    fieldLabel: '付款人',
				    columnWidth: 0.49,
				    anchor: '98%',
				    name: 'RatePayer',
				    id: 'RatePayer'
				},
				{
				    xtype: 'textfield',
				    fieldLabel: '付款人',
				    columnWidth: 0.49,
				    anchor: '98%',
				    name: 'RatePayerName',
				    id: 'RatePayerName'
				}
		]
}
	]
	},
	{
	    layout: 'column',
	    border: false,
	    labelSeparator: '：',
	    items: [
		{
		    layout: 'form',
		    border: false,
		    columnWidth: 0.5,
		    labelWidth: 70,
		    items: [
				{
				    xtype: 'datefield',
				    fieldLabel: '付款时间',
				    columnWidth: 0.5,
				    anchor: '98%',
				    name: 'RatePaydate',
				    id: 'RatePaydate',
				    format: "Y年m月d日"
				}
		]
		}
, {
    layout: 'form',
    border: false,
    columnWidth: 0.49,
    labelWidth: 60,
    items: [
				{
				    xtype: 'combo',
				    fieldLabel: '单据状态',
				    columnWidth: 0.49,
				    anchor: '98%',
				    name: 'RateStatus',
				    id: 'RateStatus',
				    store: RateStatusStore,
				    displayField: 'DicsName',
				    valueField: 'DicsCode',
				    typeAhead: true,
				    editable: false,
				    mode: 'local',
				    emptyText: '请选择单据状态信息',
				    triggerAction: 'all'
				}
		]
}
	]
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
		    labelWidth: 70,
		    items: [
				{
				    xtype: 'hidden',
				    fieldLabel: '付款单位',
				    columnWidth: 1,
				    anchor: '98%',
				    name: 'RatePayorg',
				    id: 'RatePayorg'
				},
				{
				    xtype: 'hidden',
				    fieldLabel: '付款单位',
				    columnWidth: 1,
				    anchor: '98%',
				    name: 'RatePayorgName',
				    id: 'RatePayorgName'
				}
		]
		}
	]
	},
	{
	    layout: 'column',
	    border: false,
	    labelSeparator: '：',
	    items: [
		{
		    layout: 'form',
		    border: false,
		    columnWidth: 0.33,
		    labelWidth: 70,
		    items: [
				{
				    xtype: 'numberfield',
				    fieldLabel: '含税单价',
				    columnWidth: 0.33,
				    anchor: '98%',
	                style: 'color:blue;background:white;text-align: right',
				    name: 'RatePrice',
				    id: 'RatePrice',
	                value:0
				}
		]
		}
        , {
            layout: 'form',
            border: false,
            columnWidth: 0.33,
            labelWidth: 70,
            items: [
	        {
	            xtype: 'numberfield',
	            fieldLabel: '数量',
	            columnWidth: 0.33,
	            anchor: '98%',
	            style: 'color:blue;background:white;text-align: right',
	            name: 'RateQty',
	            id: 'RateQty',
	            value:0
	        }
		]
        }
        , {
            layout: 'form',
            border: false,
            columnWidth: 0.33,
            labelWidth: 70,
            items: [
	        {
	            
				xtype: 'numberfield',
	            fieldLabel: '税率',
	            columnWidth: 0.33,
	            anchor: '98%',
	            name: 'PureRate',
	            id: 'PureRate',
	            style: 'color:blue;background:white;text-align: right',
		        decimalPrecision:2,
	            value:0.11
	        }
		]
        }
	]
	},
	{
	    layout: 'column',
	    border: false,
	    labelSeparator: '：',
	    items: [
		{
		    layout: 'form',
		    border: false,
		    columnWidth: .33,
		    labelWidth: 70,
		    items: [
				{
				xtype: 'numberfield',
	            fieldLabel: '<b>含税金额*</b>',
	            columnWidth: 0.33,
	            anchor: '98%',
	            style: 'color:blue;background:white;text-align: right',
	            name: 'RateAmt',
	            id: 'RateAmt',
		    decimalPrecision:2,
	            value:0.00
				}
		]
		}
        , {
            layout: 'form',
            border: false,
            columnWidth: 0.33,
            labelWidth: 70,
            items: [
	        {
	            xtype: 'numberfield',
	            fieldLabel: '<b>除税金额*</b>',
	            columnWidth: 0.33,
	            anchor: '98%',
	            style: 'color:blue;background:white;text-align: right',
	            name: 'PureAmt',
	            id: 'PureAmt',
		    decimalPrecision:2,
	            value:0.00
	        }
		]
        }
	]
	},
	{
	    layout: 'column',
	    border: false,
	    labelSeparator: '：',
	    items: [
		{
            layout: 'form',
            border: false,
            columnWidth: 0.49,
            labelWidth: 70,
            items: [
			{
			    xtype: 'textfield',
			    fieldLabel: '车船号',
			    columnWidth: 0.49,
			    anchor: '98%',
			    name: 'ShipNo',
			    id: 'ShipNo'
			}
	        ]
        },
        {
		    layout: 'form',
		    border: false,
		    columnWidth: .49,
		    labelWidth: 70,
		    items: [
				{
				    xtype: 'textfield',
				    fieldLabel: '发生地点',
				    columnWidth: .49,
				    anchor: '98%',
				    name: 'RateAdd',
				    id: 'RateAdd'
				}
		]
		}
	]
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
		    labelWidth: 70,
		    items: [
				{
				    xtype: 'textfield',
				    fieldLabel: '备注',
				    columnWidth: 1,
				    anchor: '98%',
				    name: 'RateMemo',
				    id: 'RateMemo'
				}
		]
		}
	]
	}
]
        });

        Ext.getCmp("RateQty").on("change", setAmtValue);
        Ext.getCmp("RatePrice").on("change", setAmtValue);
        Ext.getCmp("RateAmt").on("change", setPriceOrQty);
        Ext.getCmp("PureRate").on("change", setPriceOrQty);

        function setAmtValue() {
            var qty = Ext.getCmp("RateQty").getValue();
            var price = Ext.getCmp("RatePrice").getValue();
            var amt = accMul(qty, price);
            Ext.getCmp("RateAmt").setValue(amt);
            setPriceOrQty();
        }

        function setPriceOrQty() {
            var amt = Ext.getCmp("RateAmt").getValue();
            var qty = Ext.getCmp("RateQty").getValue();
            var price = Ext.getCmp("RatePrice").getValue();
            if(amt>0){
                var rate=Ext.getCmp("PureRate").getValue();
                if(Ext.getCmp('RateType').getValue()=='W1101')
                    Ext.getCmp("PureAmt").setValue(accDiv(amt,accAdd(1,rate)).toFixed(2));
                else
                {//海宁装卸费可能有增值税发票
                    if(rate>0)
                        Ext.getCmp("PureAmt").setValue(accDiv(amt,accAdd(1,rate)).toFixed(2));
                    else
                        Ext.getCmp("PureAmt").setValue(amt);
                }
            }
            if (qty == "" || qty == null || qty == "0") {
                if (price == "" || price == "0" || price == null) {
                    return;
                }
                else {
                    qty = accDiv(amt, price);
                    Ext.getCmp("RateQty").setValue(qty);
                }
            }
            else {
                price = accDiv(amt, qty);
                Ext.getCmp("RatePrice").setValue(price);
            }
        }
        /*------FormPanle的函数结束 End---------------*/

        Ext.getCmp("RatePayerName").on("focus", selectEmp);
        function selectEmp(v) {
            if (selectEmpForm == null) {
                showEmpForm(0, '员工选择', '../ba/sysadmin/frmAdmAuthorize.aspx?method=gettreecolumnlist');
                selectEmpTree.on('checkchange', treeCheckChange, selectEmpTree);
                Ext.getCmp("btnOk").on("click", selectOK);
            }
            else {
                showEmpForm(0, '员工选择', '../ba/sysadmin/frmAdmAuthorize.aspx?method=gettreecolumnlist');
            }
        }

        function treeCheckChange(node, checked) {
            selectEmpTree.un('checkchange', treeCheckChange, selectEmpTree);
            if (checked) {
                var selectNodes = selectEmpTree.getChecked();
                for (var i = 0; i < selectNodes.length; i++) {
                    if (selectNodes[i].id != node.id) {
                        selectNodes[i].ui.toggleCheck(false);
                        selectNodes[i].attributes.checked = false;
                    }
                }
            }
            selectEmpTree.on('checkchange', treeCheckChange, selectEmpTree);
        }

        function selectOK() {
            var selectNodes = selectEmpTree.getChecked();
            if (selectNodes.length > 0) {
                Ext.getCmp("RatePayerName").setValue(selectNodes[0].text);
                Ext.getCmp("RatePayer").setValue(selectNodes[0].id);
            }
        }
        /*------开始界面数据的窗体 Start---------------*/
        if (typeof (uploadRateWindow) == "undefined") {//解决创建2个windows问题
            uploadRateWindow = new Ext.Window({
                id: 'Rateformwindow',
                title: '费用信息'
		, iconCls: 'upload-win'
		, width: 600
		, height: 320
		, layout: 'fit'
		, plain: true
		, modal: true
		, x: 50
		, y: 50
		, constrain: true
		, resizable: false
		, closeAction: 'hide'
		, autoDestroy: true
		, items: rateForm
		, buttons: [{
		    text: "保存"
			, handler: function() {
			    getFormValue();
			}
			, scope: this
		},
		{
		    text: "取消"
			, handler: function() {
			    uploadRateWindow.hide();
			}
			, scope: this
}]
            });
        }
        uploadRateWindow.addListener("hide", function() {
        });

        /*------开始界面数据的函数 Start---------------*/
        function setFormValue(selectData) {
            Ext.Ajax.request({
                url: 'frmWmsRateList.aspx?method=getrate',
                params: {
                    RateId: selectData.data.RateId
                },
                success: function(resp, opts) {
                    var data = Ext.util.JSON.decode(resp.responseText);
                    Ext.getCmp('RateId').setValue(selectData.data.RateId);
                    Ext.getCmp("RatePayee").setValue(data.RatePayee);
                    Ext.getCmp("RatePayeename").setValue(data.RatePayeename);
                    if (data.RateCompany == 0) {
                        Ext.getCmp("RateCompany").setValue("");
                    }
                    else {
                        Ext.getCmp("RateCompany").setValue(data.RateCompany);
                    }
                    Ext.getCmp("RateType").setValue(data.RateType);
                    Ext.getCmp("RatePayer").setValue(data.RatePayer);
                    if (data.RatePaydate != '')
                        Ext.getCmp("RatePaydate").setValue(new Date(Date.parse(data.RatePaydate)));
                    Ext.getCmp("RateStatus").setValue(data.RateStatus);
                    Ext.getCmp("RatePayorg").setValue(data.RatePayorg);
                    Ext.getCmp("RatePrice").setValue(data.RatePrice);
                    Ext.getCmp("RateQty").setValue(data.RateQty);
                    Ext.getCmp("RateAmt").setValue(data.RateAmt);
                    Ext.getCmp("RateAdd").setValue(data.RateAdd);
                    Ext.getCmp("RateMemo").setValue(data.RateMemo);
                    Ext.getCmp("PureRate").setValue(data.PureRate);
                    Ext.getCmp("PureAmt").setValue(data.PureAmt);
                    Ext.getCmp("ShipNo").setValue(data.ShipNo);
                    Ext.getCmp("WhId").setValue(data.WhId);
                    Ext.getCmp("BusinessType").setValue(data.BusinessType);
                    detailId = data.OrderDetailId;
                },
                failure: function(resp, opts) {
                    Ext.Msg.alert("提示", "获取费用信息失败");
                }
            });
        }
        /*------结束设置界面数据的函数 End---------------*/

        /*------开始获取界面数据的函数 start---------------*/
        function getFormValue() {
            var dateRatePaydate = Ext.get("RatePaydate").getValue();
            var rateAmt=Ext.getCmp('RateAmt').getValue();
            var pureAmt = Ext.get("PureAmt").getValue();
            if (pureAmt <=0 || pureAmt>rateAmt){
                Ext.Msg.alert("提示", "除税金额必须大于0，且小于等于含税金额！");
                return;
            }
            Ext.Msg.wait("数据正在保存，请稍候……", "系统提示");
            Ext.Ajax.request({
                url: 'frmWmsRateList.aspx?method=' + saveType,
                method: 'POST',
                params: {
                    RateId: Ext.getCmp('RateId').getValue(),
                    RatePayee: Ext.getCmp('RatePayee').getValue(),
                    RatePayeename: Ext.getCmp('RatePayeename').getValue(),
                    RateCompany: Ext.getCmp('RateCompany').getValue(),
                    RateType: Ext.getCmp('RateType').getValue(),
                    RatePayer: Ext.getCmp('RatePayer').getValue(),
                    RatePaydate: dateRatePaydate,
                    RateStatus: Ext.getCmp('RateStatus').getValue(),
                    RatePayorg: Ext.getCmp('RatePayorg').getValue(),
                    RatePrice: Ext.getCmp('RatePrice').getValue(),
                    RateQty: Ext.getCmp('RateQty').getValue(),
                    RateAmt: Ext.getCmp('RateAmt').getValue(),
                    RateAdd: Ext.getCmp('RateAdd').getValue(),
                    OrderDetailId: detailId,
                    RateMemo: Ext.getCmp('RateMemo').getValue(),
                    PureRate: Ext.getCmp("PureRate").getValue(),
                    PureAmt:Ext.getCmp('PureAmt').getValue(),
                    ShipNo:Ext.getCmp('ShipNo').getValue(),
                    WhId:Ext.getCmp('WhId').getValue(),
                    BusinessType:Ext.getCmp('BusinessType').getValue()
                },
                success: function(resp, opts) {
                    Ext.Msg.hide();
                    if (checkExtMessage(resp)) {
                        uploadRateWindow.hide();
                        wmsRateData.reload();
                    }
                },
                failure: function(resp, opts) {
                    Ext.Msg.hide();
                    Ext.Msg.alert("提示", "保存失败");
                }
            });
        }
        /*------结束获取界面数据的函数 End---------
        ------*/
        /*------开始获取数据的函数 start---------------*/
        wmsRateData = new Ext.data.Store
({
    url: 'frmWmsRateList.aspx?method=getratelist',
    reader: new Ext.data.JsonReader({
        totalProperty: 'totalProperty',
        root: 'root'
    }, [
	{ name: 'RateId' },
	{ name: 'OrderDetailId' },
	{ name: 'RatePayee' },
	{ name: 'RatePayeename' },
	{ name: 'RateCompany' },
	{ name: 'RateCompanyName' },
	{ name: 'RateType' },
	{ name: 'RatePrice', type: 'float' },
	{ name: 'RateAmt', type: 'float' },
	{ name: 'RateQty', type: 'float' },
	{ name: 'RatePayer' },
	{ name: 'RatePayorg' },
	{ name: 'RatePaydate', type: 'date' },
	{ name: 'CreateDate', type: 'date' },
	{ name: 'Operid' },
	{ name: 'RateStatus' },
	{ name: 'RateMemo' },
	{ name: 'RateAdd' },
	{ name: 'ProductName' },
	{ name: 'WhName' },
	{ name: 'OrgId' },
	{ name: 'ShipNo' },
	{ name: 'BillType' },
	{ name: 'BookQty',type:'float' },
	{ name: 'RealQty', type: 'float' },
	{ name: 'CustomerName' },
	{ name: 'CustomerOrg' },
	{ name: 'SupplierName' },
	{ name: 'OperWh' },
	{ name: 'BusinessType' }
	]),
    listeners:
	{
	    scope: this,
	    load: function() {
	    }
	},sortData: function(f, direction) {
		 var tempSort = Ext.util.JSON.encode(wmsRateData.sortInfo);		
		 if (sortInfor != tempSort) {     
			 	sortInfor = tempSort;     
			 	wmsRateData.baseParams.SortInfo = sortInfor;     
			 	wmsRateData.load({ params: { limit: defaultPageSize, start: 0} });
			}
}	

});

        /*------获取数据的函数 结束 End---------------*/

        var toolBar = new Ext.PagingToolbar({
            pageSize: 10,
            store: wmsRateData,
            displayMsg: '显示第{0}条到{1}条记录,共{2}条',
            emptyMsy: '没有记录',
            displayInfo: true
        });
        var pageSizestore = new Ext.data.SimpleStore({
            fields: ['pageSize'],
            data: [[10], [20], [30]]
        });
        var combo = new Ext.form.ComboBox({
            regex: /^\d*$/,
            store: pageSizestore,
            displayField: 'pageSize',
            typeAhead: true,
            mode: 'local',
            emptyText: '更改每页记录数',
            triggerAction: 'all',
            selectOnFocus: true,
            width: 135
        });
        toolBar.addField(combo);
        combo.on("change", function(c, value) {
            toolBar.pageSize = value;
            defaultPageSize = toolBar.pageSize;
        }, toolBar);
        combo.on("select", function(c, record) {
            toolBar.pageSize = record.get("pageSize");
            defaultPageSize = toolBar.pageSize;
        }, toolBar);
        /*------开始DataGrid的函数 start---------------*/

        var sm = new Ext.grid.CheckboxSelectionModel({
            singleSelect: false
        });
        sm.width = 20;
        var rowNum = new Ext.grid.RowNumberer();
        rowNum.locked = true;
        rowNum.width = 20;
        var wmsRateGrid = new Ext.ux.grid.LockingGridPanel({
            el: 'wmsGrid',
            width: document.body.clientWidth - 3,
            //height: '100%',
            //autoHeight: true,
            autoScroll: true,
            layout: 'fit',
            id: 'wmsRateGrid',
            store: wmsRateData,
            loadMask: { msg: '正在加载数据，请稍侯……' },
            sm: sm,
            columns: [
		sm,
		rowNum, //自动行号
		{
		header: '产品名称',
		dataIndex: 'ProductName',
		width: 150,
		locked: true,
		id: 'ProductName'
}
//, {
//    header: '业务类型',
//    dataIndex: 'BillType',
//    width: 100,
//    locked: true,
//    id: 'BillType'
//}
//, {
//    header: '仓库',
//    dataIndex: 'WhName',
//    width: 100,
//    locked: true,
//    id: 'WhName'
//}
, 
{
    header: '仓库',
    dataIndex: 'OperWh',
    width: 100,
    locked: true,
    id: 'OperWh'
}, {
    header: '仓库作业',
    dataIndex: 'BusinessType',
    width: 100,
    locked: true,
    id: 'BusinessType'
}, {
    header: '出库数量',
    dataIndex: 'BookQty',
    width: 80,
    id: 'BookQty'
}, {
    header: '收款人姓名',
    dataIndex: 'RatePayeename',
    width: 100,
    id: 'RatePayeename'
},
		{
		    header: '收款单位',
		    dataIndex: 'RateCompanyName',
		    width: 150,
		    id: 'RateCompanyName'
		},
		{
		    header: '费用类型',
		    dataIndex: 'RateType',
		    id: 'RateType',
		    width: 80,
		    locked: true,
		    renderer: cmbRateType
		},
		{
		    header: '数量',
		    dataIndex: 'RateQty',
		    width: 80,
		    id: 'RateQty'
		},
		{
		    header: '费用单价',
		    dataIndex: 'RatePrice',
		    width: 80,
		    id: 'RatePrice'
		},
		{
		    header: '费用金额',
		    dataIndex: 'RateAmt',
		    width: 80,
		    id: 'RateAmt'
		},
		{
		    header: '付款人',
		    dataIndex: 'RatePayer',
		    width: 80,
		    id: 'RatePayer'
		},
		{
		    header: '付款单位',
		    dataIndex: 'RatePayorg',
		    width: 80,
		    id: 'RatePayorg',
		    hidden: true
		},
		{
		    header: '付款时间',
		    dataIndex: 'RatePaydate',
		    width: 100,
		    renderer: Ext.util.Format.dateRenderer('Y-m-d'),
		    id: 'RatePaydate'
		},
		{
		    header: '客户名称',
		    dataIndex: 'CustomerName',
		    width: 80,
		    id: 'CustomerName'
		},
		{
		    header: '客户归属单位',
		    dataIndex: 'CustomerOrg',
		    width: 80,
		    id: 'CustomerOrg'
		},
		{
		    header: '供应商名称',
		    dataIndex: 'SupplierName',
		    width: 80,
		    id: 'SupplierName'
		},
		{
		    header: '创建时间',
		    dataIndex: 'CreateDate',
		    width: 100,
		    renderer: Ext.util.Format.dateRenderer('Y-m-d'),
		    id: 'CreateDate'
		},
		{
		    header: '单据状态',
		    dataIndex: 'RateStatus',
		    id: 'RateStatus',
		    width: 100,
		    renderer: cmbRateStatus
		},
		{
		    header: '车船号',
		    dataIndex: 'ShipNo',
		    width: 100,
		    id: 'ShipNo'
		},
		{
		    header: '发生地点',
		    dataIndex: 'RateAdd',
		    width: 100,
		    id: 'RateAdd'
		},
		{
		    header: '备注',
		    dataIndex: 'RateMemo',
		    width: 150,
		    id: 'RateMemo'
}],
            bbar: toolBar,
            viewConfig: {
                columnsText: '显示的列',
                scrollOffset: 20,
                sortAscText: '升序',
                sortDescText: '降序',
                forceFit: false
            },
            height: 320

        });
        wmsRateGrid.render();

        //wmsRateGrid.bbar.addPageSizer();
        _grid = wmsRateGrid;
    iniSelectColumn(Toolbar, "searchGrid");
    btnFliter.on("click", staticSeach);
    btnContinueFliter.on("click", staticSeach);
    btnExpert.show();
    function staticSeach() {
        var json = "";
        filterStore.each(function(filterStore) {
            if (filterStore.data.ColumnName != '') {
                json += Ext.util.JSON.encode(filterStore.data) + ',';
            }
        });
        
        searchDataGrid(json);
    }

        createSearch(wmsRateGrid, wmsRateData, "searchForm");
        searchForm.el = "searchForm";
        searchForm.render();

btnExpert.setVisible(true);
        function cmbRateStatus(val) {
            var index = RateStatusStore.find('DicsCode', val);
            if (index < 0)
                return "";
            var record = RateStatusStore.getAt(index);
            return record.data.DicsName;
        }
        function cmbRateType(val) {
            var index = RateTypeStore.find('DicsCode', val);
            if (index < 0)
                return "";
            var record = RateTypeStore.getAt(index);
            return record.data.DicsName;
        }

        loadRateList();
    })
</script>
<body>
    <form id="form1" runat="server">
    <div id='toolbar'></div>
    <div id='searchForm'></div>
    <div id='wmsGrid'></div>    
    <div id='searchGrid'></div>
    </form>
</body>
</html>
