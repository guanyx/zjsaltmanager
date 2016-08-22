<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmPurchPlanList.aspx.cs" Inherits="SCM_frmPurchPlanList" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>采购计划</title>
<meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<link rel="stylesheet" type="text/css" href="../ext3/resources/css/ext-all.css" />
<link rel="stylesheet" href="../css/Ext.ux.grid.GridSummary.css"/>
<link rel="stylesheet" href="../css/orderdetail.css"/>
<script type="text/javascript" src="../ext3/adapter/ext/ext-base.js"></script>
<script type="text/javascript" src="../ext3/ext-all.js"></script>

<script type="text/javascript" src='../js/Ext.ux.grid.GridSummary.js'></script><!-- Ext.ux.grid.GridSummary plugin -->

<script type="text/javascript" src="../js/ProductSelect.js"></script>
<script type="text/javascript" src="../js/ProductClassCommonSelect.js"></script>
<script type="text/javascript" src="../js/operateResp.js"></script>
<script type="text/javascript" src="../js/ExtJsHelper.js"></script>
<script type="text/javascript" src="../js/floatUtil.js"></script>
<script type="text/javascript" src="../js/FilterControl.js"></script>
<script type="text/javascript" src="../ext3/example/ItemDeleter.js"></script>
<style type="text/css">
.extensive-remove {
background-image: url(../Theme/1/images/extjs/customer/cross.gif) ! important;
}
.x-grid-back-blue { 
background: #B7CBE8; 
}
.x-grid3-row-alt {
background-color:#CFE8FF
}
</style>
<%=getComboBoxSource()%>
<script type="text/javascript">
    var saveType = "";
    var imageUrl = "../Theme/1/";
    var formTitle = "";

    function getCmbStore(columnName) {
        switch (columnName) {
            case "PlanType":
                return cmbPlanTypeList;
            case "Status":
                return cmbStatusList;
            case "EmpBz":
                return EmpBzStore;
        }
        return null;
    }

    Ext.onReady(function() {
        Ext.BLANK_IMAGE_URL = "../ext3/resources/images/default/s.gif"
        /*下拉框自动提示信息 */

        /*----------定义供应商组合框 start -------------*/
        //定义产品下拉框异步调用方法
        var dsProducts;
        if (dsProducts == null) {
            dsProducts = new Ext.data.Store({
                url: '../Crm/product/frmCrmCustomerFixPrice.aspx?method=getProducts',
                reader: new Ext.data.JsonReader({
                    root: 'root',
                    totalProperty: 'totalProperty'
                }, [
                            { name: 'ProductId', mapping: 'ProductId' },
                            { name: 'ProductNo', mapping: 'ProductNo' },
                            { name: 'ProductName', mapping: 'ProductName' },
                            { name: 'Unit', mapping: 'Unit' },
                            { name: 'UnitText', mapping: 'UnitText' },
                            { name: 'Specifications', mapping: 'Specifications' },
                            { name: 'SpecificationsText', mapping: 'SpecificationsText' }
                        ])
            });
        }

        var productNameText = new Ext.form.TextField({
            id: "ProductName1",
            name: "ProductName1"
        });

        var label = new Ext.form.Label({
            html: "",
            id: "lableMonth",
            name: "lableMonth",
            width: 50,
            hidden: true

        });


        /*------实现toolbar的函数 start---------------*/
        var Toolbar = new Ext.Toolbar({
            renderTo: "toolbar"
        });

        iniToolBar(Toolbar);
        //添加ToolBar事件
        function addToolBarEvent() {
            for (var i = 0; i < Toolbar.items.length; i++) {
                switch (Toolbar.items.items[i].text) {
                    case "新增":
                        Toolbar.items.items[i].on("click", openAddMstWin);
                        break;
                    case "编辑":
                        Toolbar.items.items[i].on("click", modifyMstWin);
                        break;
                    case "删除":
                        Toolbar.items.items[i].on("click", deleteMst);
                        break;
                    case "查看":
                        Toolbar.items.items[i].on("click", viewMst);
                        break;
                    case "送审核":
                        Toolbar.items.items[i].on("click", sendToDepart);
                        break;
                    case "部门审核":
                    case "审核":
                        Toolbar.items.items[i].on("click", senderToCheck);
                        break;
                    case"省公司审核":
                        Toolbar.items.items[i].on("click",checkCityPurch);
                        break;
                    case "查看要货情况":
                        Toolbar.items.items[i].on("click", viewProvidePlan);
                        break;
                    case"查看计划情况":
                        Toolbar.items.items[i].on("click", openstatic);
                        break;
                    case"":
                        break;

                }
            }
        }
        addToolBarEvent();

function openstatic()
{
    var url = "../../rpt/scm/frmReportHtml.aspx?ReportId=9";
    window.open(url, 'newwindow', 'height=500, width=800, top=100, left=100, toolbar=no, menubar=no, scrollbars=no,resizable=no,location=no, status=no');
}
        /*------结束toolbar的函数 end---------------*/
        function checkReport(){
            //页面提交
//            Ext.Ajax.request({
//                url: 'frmPurchPlanList.aspx?method=getnoreport',
//                method: 'POST',
//                params: {
//                    PlanId: selectData.data.PlanId
//                },
//                success: function(resp, opts) {
//                    if (checkExtMessage(resp)) {
//                        planeGridData.reload();
//                    }
//                },
//                failure: function(resp, opts) {
//                    Ext.Msg.alert("提示", "数据删除失败");
//                }
//            });
        }

        /*------开始ToolBar事件函数 start---------------*//*-----新增Mst实体类窗体函数----*/
        
        /*------开始界面数据的窗体 Start---------------*/
        if (typeof (uploadOrderWindow) == "undefined") {//解决创建2个windows问题
            uploadOrderWindow = new Ext.Window({
                id: 'Orderformwindow',
                iconCls: 'upload-win'
                , width: 650
                , height: 450
                , plain: true
                , modal: true
                , constrain: true
                , resizable: false
                , closeAction: 'hide'
                , autoDestroy: true
                , html: '<iframe id="editIFrame" width="100%" height="100%" border=0 src=""></iframe>' 
                
            });
        }
        uploadOrderWindow.addListener("hide", function() {
           //document.getElementById("editIFrame").src = "frmOrderDtl.aspx?OpenType=oper&id=0";//清楚其内容，建议在子页面提供一个方法来调用
        });

        //省公司审核市公司采购计划情况
            function checkCityPurch() {
                var sm = Ext.getCmp('planeGrid').getSelectionModel();
                //多选
                var selectData = sm.getSelections();    
                //计划类型
                var planType = selectData[0].data.PlanType;
                var planYear = selectData[0].data.StartDate.getYear();
                var planMonth = selectData[0].data.StartDate.getMonthe+1;
                var isAdding  = selectData[0].data.IsAdding;            
//                var array = new Array(selectData.length);
//                var status = 1;
//                for(var i=0;i<selectData.length;i++)
//                {
//                    array[i] = selectData[i].get('OrderId');
//                    status = selectData[i].get('Status');
//                }

//                //如果没有选择，就提示需要选择数据信息
//                if (selectData == null || selectData == "") {
//                    Ext.Msg.alert("提示", "请选中需要操作的记录！");
//                    return;
//                }
//                
//                if (array.length != 1) {
//                    Ext.Msg.alert("提示", "请选中一条记录！");
//                    return;
//                }
                //放ui-check
//                if (status != 1)
//                {
//                    Ext.Msg.alert("提示", "订单已审或者已出库，不允许修改！");
//                    return;
//                }
                
                
                uploadOrderWindow.show();
                if(document.getElementById("editIFrame").src.indexOf("frmPlanUp")==-1)
                {                
                    document.getElementById("editIFrame").src = "frmPlanUp.aspx?planId="+selectData[0].data.PlanId;
                }
                else{
                document.getElementById("editIFrame").src = "frmPlanUp.aspx?planId="+selectData[0].data.PlanId;
//                    document.getElementById("frmPlanUp").contentWindow.SetPlanValue(planType,selectData[0].data.StartDate,isAdding);
                }
            }
        
        var provideWin = null;

        function viewProvidePlan() {
            var sm = Ext.getCmp('planeGrid').getSelectionModel();
            //获取选择的数据信息
            var selectData = sm.getSelected();
            if (selectData == null) {
                Ext.Msg.alert("提示", "请选中需要查看的信息！");
                return;
            }
            if (provideWin == null) {
                provideWin = ExtJsShowWin("供应商要货情况", "frmPurchProvidePlan.aspx?PlanId=" + selectData.data.PlanId + "&" + Math.random(), "provide", 800, 450);
            }
            else {
                document.getElementById("iframeprovide").src = "frmPurchProvidePlan.aspx?PlanId=" + selectData.data.PlanId + "&" + Math.random();
            }
            provideWin.show();
        }

        function viewMst() {
            //
            uploadMstWindow.buttons[0].setVisible(false);
            Ext.getCmp('PlanType').setDisabled(true);
            Ext.getCmp('PlanYear').setDisabled(true);
            Ext.getCmp('PlanMonth').setDisabled(true);
            showSelectedMst();
        }

        //送审核
        function senderToCheck() {
            var sm = Ext.getCmp('planeGrid').getSelectionModel();
            //获取选择的数据信息
            var selectData = sm.getSelected();
            if (selectData == null) {
                Ext.Msg.alert("提示", "请选中需要审核的信息！");
                return;
            }
            uploadSightWindow.show();
        }

        function openAddMstWin() {
            saveType = "add";

            clearData();

            Ext.getCmp('PlanNo').setValue("");
            Ext.getCmp('PlanName').setValue("");
            Ext.getCmp('OrgId').setValue("");
            Ext.getCmp('PlanType').setValue("");
            Ext.getCmp('Status').setValue("1");
            Ext.getCmp('Remark').setValue("");
            Ext.getCmp('PlanType').setDisabled(false);
            Ext.getCmp('PlanYear').setDisabled(false);
            Ext.getCmp('PlanMonth').setDisabled(false);
            Ext.getCmp('IsReport').setValue(true);
            uploadMstWindow.show();
        }
        /*-----编辑Mst实体类窗体函数----*/
        function modifyMstWin() {
            uploadMstWindow.buttons[0].setVisible(true);
            Ext.getCmp('PlanType').setDisabled(true);
            Ext.getCmp('PlanYear').setDisabled(true);
            Ext.getCmp('PlanMonth').setDisabled(true);
            saveType = "editmst";

            showSelectedMst();
        }

        function showSelectedMst() {
            var sm = Ext.getCmp('planeGrid').getSelectionModel();
            //获取选择的数据信息
            var selectData = sm.getSelected();
            if (selectData == null) {
                Ext.Msg.alert("提示", "请选中需要编辑的信息！");
                return;
            }
            setFormValue(selectData);
            uploadMstWindow.show();
        }
        /*-----删除Mst实体函数----*/
        /*删除信息*/
        function deleteMst() {
            var sm = Ext.getCmp('planeGrid').getSelectionModel();
            //获取选择的数据信息
            var selectData = sm.getSelected();
            //如果没有选择，就提示需要选择数据信息
            if (selectData == null) {
                Ext.Msg.alert("提示", "请选中需要删除的信息！");
                return;
            }
            //删除前再次提醒是否真的要删除
            Ext.Msg.confirm("提示信息", "是否真的要删除选择的采购计划信息吗？", function callBack(id) {
                //判断是否删除数据
                if (id == "yes") {
                    //页面提交
                    Ext.Ajax.request({
                        url: 'frmPurchPlanList.aspx?method=deletemst',
                        method: 'POST',
                        params: {
                            PlanId: selectData.data.PlanId
                        },
                        success: function(resp, opts) {
                            if (checkExtMessage(resp)) {
                                planeGridData.reload();
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
        var planeDiv = new Ext.form.FormPanel({
            frame: true,
            title: '',
            region: 'north',
            height: 110,
            labelWidth: 80,
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
				    xtype: 'hidden',
				    fieldLabel: '计划标识',
				    columnWidth: 1,
				    anchor: '95%',
				    name: 'PlanId',
				    id: 'PlanId'
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
		    items: [
				{
				    xtype: 'hidden',
				    fieldLabel: '计划编号',
				    columnWidth: 0.33,
				    anchor: '95%',
				    name: 'PlanNo',
				    id: 'PlanNo'
				}
		]
		}
, {
    layout: 'form',
    border: false,
    columnWidth: 0.655,
    items: [
				{
				    xtype: 'hidden',
				    fieldLabel: '计划名称',
				    columnWidth: 0.655,
				    anchor: '95%',
				    name: 'PlanName',
				    id: 'PlanName'
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
		    items: [
				{
				    xtype: 'hidden',
				    fieldLabel: '公司标识',
				    columnWidth: 1,
				    anchor: '95%',
				    name: 'OrgId',
				    id: 'OrgId'
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
		    items: [
				{
				    xtype: 'combo',
				    fieldLabel: '计划类型',
				    columnWidth: 0.33,
				    anchor: '95%',
				    editable: false,
				    name: 'PlanType',
				    id: 'PlanType',
				    triggerAction: 'all',
				    mode: 'local',
				    store: cmbPlanTypeList,
				    displayField: 'DicsName',
				    valueField: 'DicsCode',
				    listeners: {
				        "select": setColumnVisible//,
				        //"focus":new function(){alert('X');}
				    }
				}
		]
		}
, {
    layout: 'form',
    border: false,
    columnWidth: 0.33,
    items: [
				{
				    xtype: 'combo',
				    fieldLabel: '年度',
				    columnWidth: 0.33,
				    anchor: '95%',
				    name: 'PlanYear',
				    id: 'PlanYear',
				    triggerAction: 'all',
				    editable: false,
				    mode: 'local',
				    store: cmbPlanYearList,
				    displayField: 'DicsName',
				    valueField: 'DicsCode'
				}
		]
}
, {
    layout: 'form',
    border: false,
    columnWidth: 0.04,
    items: [label
		]
}, {
    layout: 'form',
    border: false,
    columnWidth: 0.26,
    items: [{
        xtype: 'combo',
        anchor: '80%',
        name: 'PlanMonth',
        id: 'PlanMonth',
        editable: false,
        triggerAction: 'all',
        mode: 'local',
        displayField: 'DicsName',
        valueField: 'DicsCode',
        hidden: true,
        hideLabel: true
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
		    items: [
				{
				    xtype: 'combo',
				    fieldLabel: '状态',
				    anchor: '95%',
				    editable: false,
				    name: 'Status',
				    id: 'Status',
				    triggerAction: 'all',
				    mode: 'local',
				    store: cmbStatusList,
				    readOnly: true,
				    displayField: 'DicsName',
				    valueField: 'OrderIndex',
				    disabled: true
				}
		]
		},
		{
		    layout: 'form',
		    border: false,
		    columnWidth: 0.33,
		    items: [
				            {
				                xtype: 'checkbox',
				                fieldLabel: '是否追加',
				                columnWidth: 0.33,
				                anchor: '95%',
				                name: 'IsAdding',
				                id: 'IsAdding'
				            }
		            ]
		},
		{
		    layout: 'form',
		    border: false,
		    columnWidth: 0.33,
		    items: [
				            {
				                xtype: 'checkbox',
				                fieldLabel: '是否需要上报',
				                columnWidth: 0.33,
				                anchor: '95%',
				                name: 'IsReport',
				                id: 'IsReport'
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
		    items: [
				{
				    xtype: 'textarea',
				    fieldLabel: '备注',
				    columnWidth: 1,
				    anchor: '95%',
				    name: 'Remark',
				    height: 40,
				    id: 'Remark'
				}
		]
		}
	]
	}
]
        });

        //设置年度以及季度或月度信息
        function setNDValue(startDate) {
            //设置时间格式，把-改为/以便符合JavaScript的date格式
            while (startDate.indexOf("-") != -1) {
                startDate = startDate.replace("-", "/");
            }
            //组建Date格式数据
            startDate = new Date(Date.parse(startDate));
            //获取季度类型
            var selectValue = document.getElementById("PlanType").value;
            //设置年度信息
            Ext.getCmp("PlanYear").setValue(startDate.getFullYear());
            //判断计划类型
            if (selectValue == "月度计划") {
                //获取月度信息
                var month = startDate.getMonth();
                month += 1;
                Ext.getCmp("PlanMonth").setValue(month);
            }
            if (selectValue == "季度计划") {
                //获取月度信息
                var month = startDate.getMonth();
                month += 1;
                //把月度转换为季度信息
                var jd = parseInt(month / 3) + 1;
                //设置季度信息
                Ext.getCmp("PlanMonth").setValue(jd);
            }
        }

        //根据计划类型设置控件显示情况，以及数据源信息
        function setColumnVisible() {
            var selectValue = document.getElementById("PlanType").value;
            var cmbPlanMonth = Ext.getCmp("PlanMonth"); //
            if (selectValue == "年度计划") {
                Ext.getCmp("lableMonth").setVisible(false);
                Ext.getCmp("PlanMonth").setVisible(false);
                Ext.getCmp("IsAdding").setValue(false);
                Ext.getCmp("IsAdding").disable();

                return;
            }
            if (selectValue == "月度计划") {
                Ext.getCmp("lableMonth").setVisible(true);
                Ext.getCmp("PlanMonth").setVisible(false);

                if (cmbPlanMonth.store == null)
                    cmbPlanMonth.store = new Ext.data.SimpleStore();
                cmbPlanMonth.store.removeAll();
                cmbPlanMonth.store.add(cmbPlanMonthList.getRange());

                Ext.getCmp("PlanMonth").show();
                Ext.getCmp("lableMonth").setText("月度");
                cmbPlanMonth.setValue("");

                Ext.getCmp("IsAdding").enable();
                return;
            }
            if (selectValue == "季度计划") {
                Ext.getCmp("lableMonth").setVisible(true);
                Ext.getCmp("PlanMonth").setVisible(false);

                if (cmbPlanMonth.store == null)
                    cmbPlanMonth.store = new Ext.data.SimpleStore();
                cmbPlanMonth.store.removeAll();
                cmbPlanMonth.store.add(cmbPlanQuarteList.getRange());
                cmbPlanMonth.setValue("");
                Ext.getCmp("PlanMonth").show();
                Ext.getCmp("lableMonth").setText("季度");
                Ext.getCmp("IsAdding").setValue(false);
                Ext.getCmp("IsAdding").disable();
                return;
            }
        }
        /*------FormPanle的函数结束 End---------------*/

        /*------开始获取数据的函数 start---------------*/

        var planDtlGridData = new Ext.data.Store
({
    url: 'frmPurchPlanList.aspx?method=getdtllist',
    reader: new Ext.data.JsonReader({
        totalProperty: 'totalProperty',
        groupField: 'PlanId',
        root: 'root'
    }, [
	{ name: 'PlanDtlId' },
	{ name: 'PlanId' },
	{ name: 'ParentProductId' },
	{ name: 'PlanQty' },
	{ name: 'PlanAddress' },
	{ name: 'PlanSendtype' },
	{ name: 'ProductName' },
	{ name: 'UnitName' },
	{ name: 'ProductCode' },
	{ name: 'PlanProductMemo' }
	]),	
    listeners:
	{
	    scope: this,
	    load: function() {
	    }
	}
});

var sortInfor = "";

        //userListStore.load();

        var RowPattern = Ext.data.Record.create([
           { name: 'PlanDtlId', type: 'string' },
           { name: 'PlanId', type: 'string' },
           { name: 'ParentProductId', type: 'string' },
           { name: 'PlanQty', type: 'string' },
           {name:'PlanAddress',type:'string'},
           {name:'PlanSendtype',type:'string'},
           { name: 'ProductName' },
           { name: 'UnitName', type: 'string' },       // automatic date conversions
           {name: 'ProductCode', type: 'string' },
           { name: 'PlanProductMemo', type: 'string' }
          ]);

        //        function addNewBlankRow() {
        //            var rowIndex = planDtlGrid.getStore().indexOf(planDtlGrid.getSelectionModel().getSelected());
        //            var rowCount = planDtlGrid.getStore().getCount();
        //            if ((rowIndex == 0 && rowCount == 1) || rowIndex == rowCount - 1) {
        //                insertNewBlankRow();
        //            }

        //        }

        function clearData() {
            var index = planDtlGridData.getCount();
            for (var i = 0; i < index; i++) {
                planDtlGridData.remove(planDtlGridData.getAt(0));
            }

        }
        function insertNewBlankRow(product) {
//            if (planDtlGrid.getStore().find("ParentProductId", node.id) != -1)
//                return;
            var rowCount = planDtlGrid.getStore().getCount();
            var insertPos = parseInt(rowCount);
            var addRow = new RowPattern({
                PlanDtlId: '0',
                PlanId: '0',
                ParentProductId: product.ParentProductId,
                PlanQty: '0',
                PlanAddress:'',
                PlanSendtype:'',
                ProductName: product.ProductName,
                UnitName:'吨',
                ProductCode: product.ProductCode
            });
            planDtlGrid.stopEditing();
            if (insertPos > 0) {
                var rowIndex = planDtlGridData.insert(insertPos, addRow);
                planDtlGrid.startEditing(insertPos, 0);
            }
            else {
                var rowIndex = planDtlGridData.insert(0, addRow);
                // planDtlGrid.startEditing(0, 0);
            }
        }

        /*------获取数据的函数 结束 End---------------*/

/*------获取数据的函数 结束 End---------------*/

        function cmbSendType(val) {
            var index = SendTypeStore.find('DicsCode', val);
            if (index < 0)
                return "";
            var record = SendTypeStore.getAt(index);
            return record.data.DicsName;
        }
        /*------开始DataGrid的函数 start---------------*/

        var fm = Ext.form;
        var itemDeleter = new Extensive.grid.ItemDeleter();
        var sm1 = new Ext.grid.CheckboxSelectionModel({
            singleSelect: true
        });
        sm1.width=20;
        var numColumn = new Ext.grid.RowNumberer();
        numColumn.width=40;

        //合计项
        var summary = new Ext.ux.grid.GridSummary();

        var planDtlGrid = new Ext.grid.EditorGridPanel({
            width: 530,
            //region: 'center',
//            height: 240,
//            autoWidth: true,
            autoHeight: true,
            //autoScroll: true,
            stripeRows: true,
            layout: 'fit',
            //region: "center",
            border: true,
            id: 'planDtlGrid',
            store: planDtlGridData,
            clicksToEdit: 1,
            loadMask: { msg: '正在加载数据，请稍侯……' },
            sm: sm1,
            cm: new Ext.grid.ColumnModel([
		sm1,
		{
		header: '商品名称',
		dataIndex: 'ProductName',
		id: 'ProductName',
		width: 150,
		sortable: true,
		//editor: productFilterCombo,
		renderer: function(value, cellmeta, record, rowIndex, columnIndex, store) {

		    return "<font color='red'>" + record.data.ProductName + "</font>";
		}
},

		{
		    header: '单位',
		    dataIndex: 'UnitName',
		    id: 'UnitName',
		    sortable: true,
		    width: 40
		},
		{
		    header: '商品编号',
		    dataIndex: 'ProductCode',
		    width: 60,
		    sortable: true,
		    id: 'ProductCode'
		},
        {
            header: '计划数量',
            dataIndex: 'PlanQty',
            id: 'PlanQty',
            width: 60,
            sortable: true,
            summaryType: 'sum',
            editor: new fm.NumberField({
                allowBlank: false,
                listeners: {
                    'focus': function() {
                        this.selectText();
                    }
                }
            })
        }, {
            header: '运送地址',
            dataIndex: 'PlanAddress',
            id: 'PlanAddress',
            sortable: true,
            width: 100,
            editor: new fm.TextField({})
        }, {
            header: '运送方式',
            dataIndex: 'PlanSendtype',
            id: 'PlanSendtype',
            sortable: true,
            width: 100,
            renderer: cmbSendType,
            editor: new Ext.form.ComboBox({
		        name: 'SendType',
		        id: 'SendType',
		        store: SendTypeStore,
		        displayField: 'DicsName',
		        valueField: 'DicsCode',
		        typeAhead: true,
		        editable: false,
		        mode: 'local',
		        emptyText: '请选择发送方式信息',
		        triggerAction: 'all'
		    })
        }, {
            header: '备注',
            dataIndex: 'PlanProductMemo',
            id: 'PlanProductMemo',
            width: 100,
            editor: new fm.TextField({
        })
        }]),
            plugins: summary,
            tbar: [{
                id: 'newTypeWindow',
                text: '<font color="blue">类别选择添加商品</font>',
                iconCls: 'add',
                icon: imageUrl + "images/extjs/customer/add16.gif",
                handler: function() {
                    if (selectProductForm == null) {
                        showProductForm("", "", "", true); //显示表单所在窗体
                        selectProductForm.buttons[0].on("click", function() {
                            var selectNodes = selectProductTree.getChecked();
                            for (var i = 0; i < selectNodes.length; i++) {
                                var product = new Object();
                                product.ParentProductId = selectNodes[i].id;
                                product.ProductCode = selectNodes[i].attributes.CustomerColumn1;
                                product.ProductName = selectNodes[i].attributes.text;
                                insertNewBlankRow(product);
                                selectNodes[i].ui.toggleCheck(false);
                                selectNodes[i].attributes.checked = false;
                            }
                        });
                    }
                    else {
                        showProductForm("", "", "", true);
                    }
                }
            },{
                id: 'newSearchWindow',
                text: '<font color="blue">查询添加采购商品</font>',
                iconCls: 'add',
                icon: imageUrl + "images/extjs/customer/add16.gif",
                handler: function() {
                    showProductClassCommonSelect('采购小类商品信息选择窗口',true);
                    selectProductClassCommonWin.buttons[0].on("click", function() {
                        var sm = selectProductClassCommonGrid.getSelectionModel();
                        var selectData = sm.getSelected();
                        var product = new Object();
                        product.ParentProductId = selectData.data['ProductId'];
                        product.ProductCode = selectData.data['ProductNo'];
                        product.ProductName = selectData.data['ProductName'];
                        insertNewBlankRow(product);
                    });
                }
            },{
                id: 'lastPlanDtl',
                text: '<font color="green">上期采购内容</font>',
                iconCls: 'add',
                icon: imageUrl + "images/extjs/customer/add16.gif",
                handler: function() {
                    planDtlGridData.baseParams.PlanYear=Ext.getCmp('PlanYear').getValue();
                    planDtlGridData.baseParams.PlanMonth=Ext.getCmp('PlanMonth').getValue();
                    planDtlGridData.baseParams.PlanType=Ext.getCmp('PlanType').getValue();
                    planDtlGridData.baseParams.PlanId=0;
                    planDtlGridData.load();
                }
            },{
                id: 'deleterow',
                text: '<font color="red">删除</font>',
                iconCls: 'add',
                icon: imageUrl + "images/extjs/customer/add16.gif",
                handler: function() {
                    var sm = Ext.getCmp('planDtlGrid').getSelectionModel();
                    //获取选择的数据信息
                    var selectData = sm.getSelected();
                    if (selectData == null) {
                        Ext.Msg.alert("提示", "请选中需要删除的信息！");
                        return;
                    }
                    //var record = grid.getStore().getAt(rowIndex);
                    planDtlGrid.getStore().remove(selectData);
                    planDtlGrid.getView().refresh(); 
                }
            }],

                viewConfig: {
                   
                    forceFit: true
                },
                closeAction: 'hide',
                stripeRows: true,
                loadMask: true,
                autoExpandColumn: 2
            });
            var planeGridDiv = new Ext.form.FormPanel({
                region: 'center',
                //deferredRender: false,
                autoScroll :true,
                //autoWidth :true,
//                autoShow: true,
//                autoDestroy: true,
//                activeTab: 0,
                split: true,
                width: 300,
                minSize: 300,
                maxSize: 300,
                //collapsible: true,

                items: [planDtlGrid]
            });
            
            /*--------提示信息界面--------------------------*/
            planDtlGrid.on("beforeedit", afterEdit, planDtlGrid);

            function afterEdit(e) {
                var record = e.record; // 被编辑的记录 
                Ext.Ajax.request({
                    url: 'frmPurchPlanList.aspx?method=getproductplan',
                    method: 'POST',
                    params: {
                        PlanType: Ext.getCmp('PlanType').getValue(),
                        ProductId: record.data.ParentProductId,
                        PlanYear: Ext.getCmp('PlanYear').getValue(),
                        PlanMonth: Ext.getCmp('PlanMonth').getValue()
                    },
                    success: function(resp, opts) {
                        var resu = Ext.decode(resp.responseText);
                        propertyGridHelp.setSource({
                            "1.采购商品": record.data.ProductName,
                            "2.计划年采购量": resu.计划年采购量,
                            "3.已采购量": resu.已采购量,
                            "4.环比采购量": resu.环比采购量,
                            "5.同比采购量": resu.同比采购量,
                            "6.库存量": resu.库存量,
                            "7.上月销售量": 0
                        });
                    },
                    failure: function(resp, opts) {
                        //             Ext.Msg.hide();
                        //            Ext.Msg.alert("提示", "保存失败");
                    }
                });
            }
            var propertyGridHelp = new Ext.grid.PropertyGrid({
                title: '属性表格',
                autoHeight: true,
                width: 300,
                height: 350,
                split: true,
                nameText: 'Style',
                sortable: false,
                //valueText:'值',
                //renderTo: 'grid',   
                //region:'east',
                source: {
                    "1.采购商品": "",
                    "2.计划年采购量": '',
                    "3.已采购量": '',
                    "4.上月采购量": '',
                    "5.同比采购量": 0,
                    "6.库存量": 0,
                    "7.上月销售量": 0
                    
                }
            });
            propertyGridHelp.colModel.config[0].header = "类型";
            propertyGridHelp.colModel.config[0].sortable = false;
            propertyGridHelp.colModel.config[1].header = "值";
            propertyGridHelp.on("beforeedit", function(e) {
                e.cancel = true;
                return false;
            });

            var tabPanel = new Ext.form.FormPanel({
                region: 'east',
                deferredRender: false,
                //autoScroll :true,
                //autoWidth :true,
                autoShow: true,
                autoDestroy: true,
                activeTab: 0,
                split: true,
                width: 230,
                minSize: 300,
                maxSize: 300,
                collapsible: true,

                items: [propertyGridHelp]
            });

            /*------开始界面数据的窗体 Start---------------*/
            if (typeof (uploadMstWindow) == "undefined") {//解决创建2个windows问题
                uploadMstWindow = new Ext.Window({
                    id: 'Mstformwindow',
                    title: formTitle
		, iconCls: 'upload-win'
		, width: 800
		, height: 450
		, layout: 'border'
		, plain: true
		, modal: true
		, x: 50
		, y: 50
		, constrain: true
		, resizable: false
		, closeAction: 'hide'
		, autoScroll: true
		, autoDestroy: true
		, items: [planeDiv, planeGridDiv, tabPanel]
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
			    uploadMstWindow.hide();
			}
			, scope: this
}]
                });
            }
            uploadMstWindow.addListener("hide", function() {
            });

            /*------开始获取界面数据的函数 start---------------*/
            function getFormValue() {
                var json = "";
                planDtlGridData.each(function(planDtlGridData) {
                    if(planDtlGridData.data.PlanQty=='')
                    {
                        Ext.Msg.alert(planDtlGridData.data.ProductName+'没有输入采购数量！');
                        return;
                    }
                    json += Ext.util.JSON.encode(planDtlGridData.data) + ',';
                });
                if(json=="")
                {
                    Ext.Msg.alert("系统提示","没有输入任何的采购信息，请确认！");
                    return;
                }
                json = json.substring(0, json.length - 1);
                Ext.Msg.wait("数据正在保存……");
                Ext.Ajax.request({
                    url: 'frmPurchPlanList.aspx?method=' + saveType + owner,
                    method: 'POST',
                    params: {
                        PlanId: Ext.getCmp('PlanId').getValue(),
                        PlanNo: Ext.getCmp('PlanNo').getValue(),
                        PlanName: Ext.getCmp('PlanName').getValue(),
                        OrgId: Ext.getCmp('OrgId').getValue(),
                        PlanType: Ext.getCmp('PlanType').getValue(),
                        Status: Ext.getCmp('Status').getValue(),
                        Remark: Ext.getCmp('Remark').getValue(),
                        PlanYear: Ext.getCmp('PlanYear').getValue(),
                        PlanMonth: Ext.getCmp('PlanMonth').getValue(),
                        IsAdding: Ext.getCmp('IsAdding').getValue(),
                        IsReport: Ext.getCmp('IsReport').getValue(),
                        Json: json
                    },
                    success: function(resp, opts) {
                        Ext.Msg.hide();
                        if (checkExtMessage(resp)) {
                            uploadMstWindow.hide();
                            planeGridData.load({
                                params: {
                                    start: 0,
                                    limit: 10,
                                    action: action
                                }
                            });
                        }
                    },
                    failure: function(resp, opts) {
                        Ext.Msg.hide();
                        Ext.Msg.alert("提示", "保存失败");
                    }
                });
            }
            /*------结束获取界面数据的函数 End---------------*/

            /*------开始界面数据的函数 Start---------------*/
            function setFormValue(selectData) {
                Ext.Ajax.request({
                    url: 'frmPurchPlanList.aspx?method=getmst',
                    params: {
                        PlanId: selectData.data.PlanId
                    },
                    success: function(resp, opts) {
                        var data = Ext.util.JSON.decode(resp.responseText);
                        Ext.getCmp('PlanId').setValue(data.PlanId);
                        Ext.getCmp("PlanNo").setValue(data.PlanNo);
                        Ext.getCmp("PlanName").setValue(data.PlanName);
                        Ext.getCmp("OrgId").setValue(data.OrgId);
                        Ext.getCmp("PlanType").setValue(data.PlanType);
                        Ext.getCmp("Status").setValue(data.Status);
                        Ext.getCmp("Remark").setValue(data.Remark);
                        Ext.getCmp("IsAdding").setValue(data.IsAdding);
                        Ext.getCmp("IsReport").setValue(data.IsReport);
                        setColumnVisible();
                        if (data.StartDate != '') {
                            setNDValue(data.StartDate);
                        }
                        planDtlGridData.load({
                            params: {
                                PlanId: selectData.data.PlanId
                            }
                        });
                    },
                    failure: function(resp, opts) {
                        Ext.Msg.alert("提示", "获取采购计划信息失败");
                    }
                });
            }
            /*------结束设置界面数据的函数 End---------------*/

            /*------开始获取数据的函数 start---------------*/
            var planeGridData = new Ext.data.Store
({
    url: 'frmPurchPlanList.aspx?method=getmstlist&Action=' + action + owner,
    baseParams: { action: action },
    reader: new Ext.data.JsonReader({
        totalProperty: 'totalProperty',
        root: 'root'
    }, [
	{
	    name: 'PlanId'
	},
	{
	    name: 'PlanNo'
	},
	{
	    name: 'PlanName'
	},
	{
	    name: 'OrgId'
	},
	{
	    name: 'OrgShortName'
	},
	{
	    name: 'PlanType'
	},
	{
	    name: 'StartDate', type: 'date'
	},
	{
	    name: 'EndDate', type: 'date'
	},
	{
	    name: 'Status'
	},
	{
	    name: 'TotalQty'
	},
	{
	    name: 'DtlCount'
	},
//	{
//	    name: 'Remark'
//	},
	{
	    name: 'CreateDate',type:'date'
	},
	{
	    name: 'OperId'
	},
	{
	    name: 'UpdateDate'
	},
	{
	    name: 'IsAdding',type:'bool'
	},
	{
	    name: 'IsActive'
}]),
	sortData: function(f, direction) {
	    var tempSort = Ext.util.JSON.encode(planeGridData.sortInfo);
        if (sortInfor != tempSort) {
            sortInfor = tempSort;
            planeGridData.baseParams.SortInfo = sortInfor;
            planeGridData.load({ params: { limit: defaultPageSize, start: 0} });
        }
    },
    listeners:
	{
	    scope: this,
	    load: function() {
	    }
	}
});

            function getDefaultFilter() {
                var json = "";
                defaultFilter.each(function(defaultFilter) {
                    json += Ext.util.JSON.encode(defaultFilter.data) + ',';
                });
                json = json.substring(0, json.length - 1);
                return json;
            }
            planeGridData.load({
                params: {
                    start: 0,
                    limit: 10,
                    action: action
                }
            });

            function cmbStatus(val) {
                var index = cmbStatusList.find('OrderIndex', val);
                if (index < 0)
                    return "";
                var record = cmbStatusList.getAt(index);
                return record.data.DicsName;
            }
            
            function cmbIsAdding(val) {
                if(val=='1')
                    return "是";
                return "否";
            }

            function cmbType(val) {
                var index = cmbPlanTypeList.find('DicsCode', val);
                if (index < 0)
                    return "";
                var record = cmbPlanTypeList.getAt(index);
                return record.data.DicsName;
            }

            function renderDate(value) {
                var reDate = /\d{4}\/\d{2}\/\d{2}/gi;
                return value.match(reDate);
            }

            /*------获取数据的函数 结束 End---------------*/

var defaultPageSize = 10;
    var toolBar = new Ext.PagingToolbar({
        pageSize: 10,
        store: planeGridData,
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
        toolBar.pageSize = parseInt(record.get("pageSize"));
        defaultPageSize = toolBar.pageSize;
        toolBar.doLoad(0);
    }, toolBar);
    
            /*------开始DataGrid的函数 start---------------*/

            var sm = new Ext.grid.CheckboxSelectionModel({
                singleSelect: true
            });
            var planeGrid = new Ext.grid.GridPanel({
                el: 'planeGrid',
                width: '100%',
                height: '100%',
                autoWidth: true,
                autoHeight: true,
                autoScroll: true,
                layout: 'fit',
                id: 'planeGrid',
                store: planeGridData,
                loadMask: { msg: '正在加载数据，请稍侯……' },
                sm: sm,
                cm: new Ext.grid.ColumnModel([
		sm,
		new Ext.grid.RowNumberer(), //自动行号

		{
		header: '计划编号',
		dataIndex: 'PlanNo',
		sortable: true,
		id: 'PlanNo'
},
		{
		    header: '计划名称',
		    dataIndex: 'PlanName',
		    id: 'PlanName',
		    sortable: true,
		    hidden: true
		},
		{
		    header: '单位名称',
		    dataIndex: 'OrgShortName',
		    sortable: true,
		    id: 'OrgShortName'
		},
		{
		    header: '计划类型',
		    dataIndex: 'PlanType',
		    id: 'PlanType',
		    sortable: true,
		    renderer: cmbType
		},
		{
		    header: '是否追加',
		    dataIndex: 'IsAdding',
		    id: 'IsAdding',
		    sortable: true,
		    renderer: cmbIsAdding
		},
		{
		    header: '计划开始日期',
		    dataIndex: 'StartDate',
		    id: 'StartDate',
		    sortable: true,
		    renderer: Ext.util.Format.dateRenderer('Y年m月d日')
		},
		{
		    header: '计划结束日期',
		    dataIndex: 'EndDate',
		    id: 'EndDate',
		    sortable: true,
		    renderer: Ext.util.Format.dateRenderer('Y年m月d日')
		},
		{
		    header: '状态',
		    dataIndex: 'Status',
		    id: 'Status',
		    sortable: true,
		    renderer: cmbStatus
		},
		{
		    header: '合计数量',
		    dataIndex: 'TotalQty',
		    id: 'TotalQty'
		},
		{
		    header: '明细数',
		    dataIndex: 'DtlCount',
		    sortable: true,
		    id: 'DtlCount'
		},
//		{
//		    header: '备注',
//		    dataIndex: 'Remark',
//		    id: 'Remark'
//		},
		{
		    header: '创建时间',
		    dataIndex: 'CreateDate',
		    sortable: true,
		    id: 'CreateDate',
		    //hidden: true,
		    //hideable: false
		    renderer: Ext.util.Format.dateRenderer('Y-m-d h:m')
		},
		{
		    header: '操作员',
		    dataIndex: 'OperId',
		    id: 'OperId',
		    hidden: true
		},
		{
		    header: '修改时间',
		    dataIndex: 'UpdateDate',
		    id: 'UpdateDate',
		    hidden: true,
		    hideable: false
		},
		{
		    header: '所有者',
		    dataIndex: 'OwnerId',
		    id: 'OwnerId',
		    hidden: true,
		    hideable: false
		},
		{
		    header: '是否可用',
		    dataIndex: 'IsActive',
		    id: 'IsActive',
		    hidden: true,
		    hideable: false
}]),
bbar: toolBar,
                viewConfig: {
                    columnsText: '显示的列',
                    scrollOffset: 20,
                    sortAscText: '升序',
                    sortDescText: '降序',
                    forceFit: true
                },
                height: 280,
                closeAction: 'hide',
                stripeRows: true,
                loadMask: true,
                autoExpandColumn: 2
            });
            
            planeGrid.on('render', function(grid) {
                var store = grid.getStore();  // Capture the Store.  
                var view = grid.getView();    // Capture the GridView.
                planeGrid.tip = new Ext.ToolTip({
                    target: view.mainBody,    // The overall target element.  
                    delegate: '.x-grid3-row', // Each grid row causes its own seperate show and hide.  
                    trackMouse: true,         // Moving within the row should not hide the tip.  
                    renderTo: document.body,  // Render immediately so that tip.body can be referenced prior to the first show.  
                    listeners: {              // Change content dynamically depending on which element triggered the show.  
                        beforeshow: function updateTipBody(tip) {
                            var rowIndex = view.findRowIndex(tip.triggerElement);
                            
                            var element = document.elementFromPoint(tip.x-20, tip.y-20);
                             var v = view.findCellIndex(element);
                             if(v==2)
                             {
                              
                                if(showTipRowIndex == rowIndex)
                                    return;
                                else
                                    showTipRowIndex = rowIndex;
                                    
                                     tip.body.dom.innerHTML="正在加载数据……";
                                        //页面提交
                                        Ext.Ajax.request({
                                            url: 'frmPurchPlanList.aspx?method=getdtlinfo',
                                            method: 'POST',
                                            params: {
                                                PlanId: grid.getStore().getAt(rowIndex).data.PlanId
                                            },
                                            success: function(resp, opts) {
                                                tip.body.dom.innerHTML = resp.responseText;
                                            },
                                            failure: function(resp, opts) {
                                                planeGrid.tip.hide();
                                            }
                                        });
                                }
                                else if(v==4)
                                {
//                                    if(showTipRowIndex == rowIndex)
//                                        return;
//                                    else
//                                        showTipRowIndex = rowIndex;
                                    tip.body.dom.innerHTML="正在加载数据……";
                                        //页面提交
                                        Ext.Ajax.request({
                                            url: 'frmPurchPlanList.aspx?method=getdtlinfo',
                                            method: 'POST',
                                            params: {
                                                PlanId: grid.getStore().getAt(rowIndex).data.PlanId
                                            },
                                            success: function(resp, opts) {
                                                tip.body.dom.innerHTML = resp.responseText;
                                            },
                                            failure: function(resp, opts) {
                                                planeGrid.tip.hide();
                                            }
                                        });
                                    
                                }
                                else
                                {
                                    planeGrid.tip.hide();
                                }
//                            }
//                            else
//                            {
//                                planeGrid.tip.hide();
//                            }
//                            if(header)
//                            {
//                                tip.body.dom.innerHTML = "可以双击此行查看出库明细！ "; //store.getAt(rowIndex).id  
//                            }
//                            else
//                            {
//                                planeGrid.tip.hide();
//                            }
                        }
                    }
                });
    });
    var showTipRowIndex =-1;
    
            planeGrid.render();
            /*------DataGrid的函数结束 End---------------*/
            //var gridForm = new Ext.form.FormPanel({
            //    frame:true,
            //    region
            //});

            createSearch(planeGrid, planeGridData, "searchForm");
            //setControlVisibleByField();
            searchForm.el = "searchForm";
            searchForm.render();
            /*------实现FormPanle的函数 start---------------*/
            var sightDiv = new Ext.form.FormPanel({
                frame: true,
                title: '审核意见',
                region: 'center',
                items: [
	{
	    layout: 'column',
	    border: false,
	    labelSeparator: '：',
	    items: [
		{
		    layout: 'form',
		    border: false,
		    columnWidth: 0.5,
		    items: [
				{
				    xtype: 'hidden',
				    fieldLabel: '审核人',
				    columnWidth: 0.5,
				    anchor: '90%',
				    name: 'SightChecker',
				    id: 'SightChecker'
				}
		]
		}
, {
    layout: 'form',
    border: false,
    columnWidth: 0.5,
    items: [
				{
				    xtype: 'hidden',
				    fieldLabel: '审核时间',
				    columnWidth: 0.5,
				    anchor: '90%',
				    name: 'SightDate',
				    id: 'SightDate'
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
		    items: [
				{
				    xtype: 'textarea',
				    fieldLabel: '审核意见',
				    columnWidth: 1,
				    anchor: '90%',
				    name: 'CheckSight',
				    id: 'CheckSight'
				},{
				    xtype: 'label',
				    fieldLabel: '备注',
				    columnWidth: 1,
				    html:"事故<br>地点",
				    text:"代码"
				}
		]
		}
	]
	}
]
            });
            var uploadSightWindow;
            if (typeof (uploadSightWindow) == "undefined") {//解决创建2个windows问题
                uploadSightWindow = new Ext.Window({
                    id: 'Sightformwindow',
                    title: formTitle
		, iconCls: 'upload-win'
		, width: 400
		, height: 200
		, layout: 'border'
		, plain: true
		, modal: true
		, x: 50
		, y: 50
		, constrain: true
		, resizable: false
		, closeAction: 'hide'
		, autoDestroy: true
		, items: [sightDiv]
		, buttons: [{
		    text: "通过"
			, handler: function() {
			    fPass = true;
			    //getFormValue();
			    getSightFormValue();
			}
			, scope: this
		},
		{
		    text: "退回"
			, handler: function() {
			    if (Ext.getCmp("CheckSight").getValue() == "") {
			        Ext.Msg.alert("提示信息", "请输入退回的审核意见信息！");
			        return;
			    }
			    fPass = false;
			    getSightFormValue();
			    //getFormValue();
			}
			, scope: this
		},
		{
		    text: "取消"
			, handler: function() {
			    uploadSightWindow.hide();
			}
			, scope: this
}]
                });
            }
            uploadSightWindow.addListener("hide", function() {
            });
            /*------FormPanle的函数结束 End---------------*/

            /*------开始获取界面数据的函数 start---------------*/
            var fPass = false;
            function getSightFormValue() {
                var sm = Ext.getCmp('planeGrid').getSelectionModel();
                //获取选择的数据信息
                var selectData = sm.getSelected();
                Ext.Ajax.request({
                    url: 'frmPurchPlanList.aspx?method=sight',
                    method: 'POST',
                    params: {
                        PlanId: selectData.data.PlanId,
                        Status: selectData.data.Status,
                        Pass: fPass,
                        CheckSight: Ext.getCmp('CheckSight').getValue()
                    },
                    success: function(resp, opts) {
                        if (checkExtMessage(resp)) {
                            uploadSightWindow.hide();
                            planeGridData.reload();
                        }
                    },
                    failure: function(resp, opts) {
                        Ext.Msg.alert("提示", "保存失败");
                    }
                });
            }
            /*------结束获取界面数据的函数 End---------------*/
            //送部门审核，无需填写任何意见信息
            function sendToDepart() {
                var sm = Ext.getCmp('planeGrid').getSelectionModel();
                //获取选择的数据信息
                var selectData = sm.getSelected();
                if (selectData == null) {
                    Ext.Msg.alert("提示", "请选中需要送审核的信息！");
                    return;
                }
                Ext.Ajax.request({
                    url: 'frmPurchPlanList.aspx?method=sight',
                    method: 'POST',
                    params: {
                        PlanId: selectData.data.PlanId,
                        Status: selectData.data.Status,
                        Pass: true,
                        CheckSight: ''
                    },
                    success: function(resp, opts) {
                        if (checkExtMessage(resp)) {
                            planeGridData.reload();
                        }
                    },
                    failure: function(resp, opts) {
                        Ext.Msg.alert("提示", "保存失败");
                    }
                });
            }

        })
</script>
</head>
<body>
    <form id="form1" runat="server">
    <div id='toolbar'></div>
    <div id='searchForm'></div>
    <div id='divForm'></div>
    <div id='planeGrid'></div>
    </form>
</body>
</html>
