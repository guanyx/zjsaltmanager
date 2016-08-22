<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmWmsSaleCompareSearch.aspx.cs" Inherits="RPT_WMS_frmWmsSaleCompareSearch" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html>
<head>
    <title>销售对比查询</title>
    <link rel="stylesheet" type="text/css" href="../../ext3/resources/css/ext-all.css" />
    <script type="text/javascript" src="../../ext3/adapter/ext/ext-base.js"></script>
    <script type="text/javascript" src="../../ext3/ext-all.js"></script>
    <script type="text/javascript" src="../../ext3/example/ItemDeleter.js"></script>
    <!--link rel="stylesheet" type="text/css" href="../../css/GroupHeaderPlugin.css" /-->
    <script type="text/javascript" src="../../js/floatUtil.js"></script>
    <!--script type="text/javascript" src="../../js/GroupHeaderPlugin.js"></script-->
    <link rel="stylesheet" href="../../css/Ext.ux.grid.GridSummary.css" />
    <!--script type="text/javascript" src="../../js/FilterControl.js"></script-->
    <script type="text/javascript" src='../../js/Ext.ux.grid.GridSummary.js'></script>
    <link rel="stylesheet" type="text/css" href="../../ext3/example/GroupSummary.css" />
    <script type="text/javascript" src="../../ext3/example/GroupSummary.js"></script>
    <script type="text/javascript" src="../../js/operateResp.js"></script>
    <script type="text/javascript" src="../../js/GroupHeaderPlugin.js">
    </script><link rel="stylesheet" type="text/css" href="../../css/GroupHeaderPlugin.css" />
    <link rel="stylesheet" type="text/css" href="../../Theme/1/css/salt.css" />
    <script type="text/javascript" src="../../ext3/src/locale/ext-lang-zh_CN.js"></script>
    <script type="text/javascript" src="../../js/OrgsSelect.js"></script>

</head>
<body> 
<div id='searchForm'></div>
<div id='gird'></div>
</body>
<%=getComboBoxStore( )%>
<script type="text/javascript">
    Ext.BLANK_IMAGE_URL = "../../ext3/resources/images/default/s.gif";
    var headerModel = new Ext.ux.plugins.GroupHeaderGrid({
        rows: [
		[

			 {
			    colspan: 1,
			    align: 'center'
			},{
			    colspan: 1,
			    align: 'center'
			},
			{
			    colspan: 1,
			    align: 'center'
			},
			{
			    colspan: 1,
			    align: 'center'
			},
			{
			    colspan: 1,
			    align: 'center'
			},
			{
			    header: '开始段时间',
			    colspan: 3,
			    align: 'center'
			},
			{
			    header: '结束段时间',
			    colspan: 3,
			    align: 'center'
			},
			{
			    colspan: 1,
			    align: 'center'
			}
			
]]
});

var dsWareHouse;
if (dsWareHouse == null) { //防止重复加载
    dsWareHouse = new Ext.data.JsonStore({
        totalProperty: "result",
        root: "root",
        url: '../../scm/frmOrderStatistics.aspx?method=getWhSimple',
        fields: ['WhId', 'WhName']
    });
    dsWareHouse.load();
};

var selectOrgIds = orgId;
var ArriveOrgText = new Ext.form.TextField({
    fieldLabel: '公司',
    id: 'orgSelect',
    value: orgName,
    anchor: '95%',
    style: 'margin-left:0px',
    disabled: true
});

ArriveOrgText.on("focus", selectOrgType);
function selectOrgType() {

    if (selectOrgForm == null) {
        var showType = "getcurrentandchildrentree";
        if (orgId == 1) {
            showType = "getcurrentAndChildrenTreeByArea";
        }
        showOrgForm("", "", "../../ba/sysadmin/frmAdmOrgList.aspx?method=" + showType);
        selectOrgForm.buttons[0].on("click", selectOrgOk);
        if (orgId == 1) {
            selectOrgTree.on('checkchange', treeCheckChange, selectOrgTree);
        }
    }
    else {
        showOrgForm("", "", "");
    }
}
function selectOrgOk() {
    var selectOrgNames = "";
    selectOrgIds = "";
    var selectNodes = selectOrgTree.getChecked();
    for (var i = 0; i < selectNodes.length; i++) {
        if (selectNodes[i].id.indexOf("A") != -1)
            continue;
        if (selectOrgNames != "") {
            selectOrgNames += ",";
            selectOrgIds += ",";
        }
        selectOrgIds += selectNodes[i].id;
        selectOrgNames += selectNodes[i].text;

    }
    ArriveOrgText.setValue(selectOrgNames);
    dsWareHouse.load({ params: { OrgId: selectOrgIds, ForBusi: 1} });
}



function treeCheckChange(node, checked) {
    node.expand();
    node.attributes.checked = checked;
    node.eachChild(function(child) {
        child.ui.toggleCheck(checked);
        child.attributes.checked = checked;
        child.fireEvent('checkchange', child, checked);
    });
    selectOrgTree.un('checkchange', treeCheckChange, selectOrgTree);
    checkParentNode(node);
    selectOrgTree.on('checkchange', treeCheckChange, selectOrgTree);
}
function checkParentNode(currentNode) {
    if (currentNode.parentNode != null) {
        var tempNode = currentNode.parentNode;
        //如果是跟节点，就不做处理了
        if (tempNode.parentNode == null)
            return;
        //如果是选择了，那么父节点也必须是出于选择状态的
        if (currentNode.attributes.checked) {
            if (!tempNode.attributes.checked) {
                tempNode.fireEvent('checkchange', tempNode, true);
                tempNode.ui.toggleCheck(true);
                tempNode.attributes.checked = true;

            }
        }
        //取消选择
        else {
            var tempCheck = false;
            tempNode.eachChild(function(child) {
                if (child.attributes.checked) {
                    tempCheck = true;
                    return;
                }
            });
            if (!tempCheck) {
                tempNode.fireEvent('checkchange', tempNode, false);
                tempNode.ui.toggleCheck(false);
                tempNode.attributes.checked = false;
            }

        }
        checkParentNode(tempNode);
    }
}
function parentNodeChecked(node) {
    if (node.parentNode != null) {
        if (node.attributes.checked) {
            node.parentNode.ui.toggleCheck(checked);
            node.parentNode.attributes.checked = true;
        }
        else {
            for (var i = 0; i < node.parentNode.childNodes.length; i++) {
                if (node.parentNode.childNodes[i].attributes.checked) {
                    return;
                }
            }
        }
        parentNodeChecked(node.parentNode);
    }
}

var colModel = new Ext.grid.ColumnModel({
	columns: [
		new Ext.grid.RowNumberer(),			
		{
			header:'产品编号',
			dataIndex:'ProductCode',
			id: 'ProductCode',
			tooltip:'产品编号'
		},
		{
		    header:'产品名称',
			dataIndex:'ProductName',
			id: 'ProductName',
			tooltip:'产品名称'
		},
		{
			header:'规格',
			dataIndex: 'SpecificationsText',
			id: 'SpecificationsText',
			tooltip:'规格'
		},
		{
			header:'单位',
			dataIndex:'UnitText',
			id: 'UnitText',
			tooltip:'单位'
		},
	    {
			header:'开始时间',
			dataIndex:'BeginStartDate',
			id:'beginStartDate',
			renderer: Ext.util.Format.dateRenderer('Y年m月d日'),
			tooltip:'起始时间段'
		},
		{
			header:'结束时间',
			dataIndex:'BeginEndDate',
			id:'beginEndDate',
			renderer: Ext.util.Format.dateRenderer('Y年m月d日'),
			tooltip:'起始时间段'
        },
		{
		    header: '销售量',
		    dataIndex: 'FRealQty',
		    id: 'FRealQty',
		    tooltip: '销售量',
		    align: 'right'
		},
		{
			header:'开始时间',
			dataIndex:'EndStartDate',
			id:'endStartDate',
			renderer: Ext.util.Format.dateRenderer('Y年m月d日'),
			tooltip:'结束时间段'
		},
		{
			header:'结束时间',
			dataIndex:'EndEndDate',
			id:'endEndDate',
			renderer: Ext.util.Format.dateRenderer('Y年m月d日'),
			tooltip:'结束时间段'
		},
		
		{
			header:'销售量',
			dataIndex:'HRealQty',
			id: 'HRealQty',
			tooltip: '结束时间段',
			align: 'right'
		},
		{
			header:'增加数量',
			dataIndex:'DifferQty',
			id: 'DifferQty',
			tooltip: '增加数量',
			align: 'right'
		},
		{
		    header:'ID',
			dataIndex:'ProductId',
			id:'ProductId',
			tooltip:'',
			hidden:true,
			hideable:false
		}
        ]
});
/*--------------serach--------------*/
//var ArriveOrgPostPanel = new Ext.form.ComboBox({
//    style: 'margin-left:0px',
//    cls: 'key',
//    xtype: 'combo',
//    fieldLabel: '公司',
//    name: 'nameOrg',
//    anchor: '95%',
//    store: dsOrgListInfo,
//    mode: 'local',
//    displayField: 'OrgName',
//    valueField: 'OrgId',
//    triggerAction: 'all',
//    editable: false,
//    value: dsOrgListInfo.getAt(0).data.OrgId
//});
//var ArriveCustomerPostPanel = new Ext.form.ComboBox({
//    style: 'margin-left:0px',
//    cls: 'key',
//    xtype: 'combo',
//    fieldLabel: '客户',
//    name: 'nameCustomer',
//    anchor: '95%',
//    store: dsCustomerListInfo,
//    mode: 'local',
//    displayField: 'ChineseName',
//    valueField: 'CustomerId',
//    triggerAction: 'all',
//    editable: true,
//    selectOnFocus: false,
//    value: dsCustomerListInfo.getAt(0).data.CustomerId
//});
var ArriveCustomerPostPanel = new Ext.form.Hidden({});
var ArriveCustomerNamePostPanel = new Ext.form.TextField({
fieldLabel: '客户',
anchor: '95%',
style: 'margin-left:0px',
    disabled: true
});
function regexValue(qe){
    var combo = qe.combo;  
    //q is the text that user inputed.  
    var q = qe.query;  
    forceAll = qe.forceAll;  
    if(forceAll === true || (q.length >= combo.minChars)){  
     if(combo.lastQuery !== q){  
         combo.lastQuery = q;  
         if(combo.mode == 'local'){  
             combo.selectedIndex = -1;  
             if(forceAll){  
                 combo.store.clearFilter();  
             }else{  
                 combo.store.filterBy(function(record,id){  
                     var text = record.get(combo.displayField);  
                     //在这里写自己的过滤代码  
                     return (text.indexOf(q)!=-1);  
                 });  
             }  
             combo.onLoad();  
         }else{  
             combo.store.baseParams[combo.queryParam] = q;  
             combo.store.load({  
                 params: combo.getParams(q)  
             });  
             combo.expand();  
         }  
     }else{  
         combo.selectedIndex = -1;  
         combo.onLoad();  
     }  
    }  
    return false;  
}
//ArriveCustomerPostPanel.on('beforequery',function(qe){  
//    regexValue(qe);
//});
var startLabel = new Ext.form.Label({  fieldLabel: '时间段',anchor: '30%' });
var compareLabel = new Ext.form.Label({  fieldLabel: '对比时间段',anchor: '30%'});
var ArriveWhPostPanel = new Ext.form.ComboBox({
        style: 'margin-left:0px',
        cls: 'key',
        xtype: 'combo',
        fieldLabel: '仓库',
        name: 'nameCust',
        anchor: '95%',
        store: dsWareHouse,//edsWarehouseList,
        mode:'local',
        displayField:'WhName',
        valueField:'WhId',
        triggerAction:'all',
        editable:false
//        value:dsWarehouseList.getAt(0).data.WhId
    });
    //开始日期
    var beginStartDatePanel = new Ext.form.DateField({
        xtype:'datefield',
        fieldLabel:'开始日期',
        anchor:'80%',
        format: 'Y年m月d日',  //添加中文样式
        value:new Date().getFirstDateOfMonth().clearTime() 
    });

    //结束日期
    var beginEndDatePanel = new Ext.form.DateField({
        xtype:'datefield',
        fieldLabel:'结束日期',
        anchor:'95%',
        format: 'Y年m月d日',  //添加中文样式
        value:new Date().clearTime()
    });
    //开始日期
    var endStartDatePanel = new Ext.form.DateField({
        xtype: 'datefield',
        fieldLabel: '开始日期',
        anchor: '80%',
        format: 'Y年m月d日',  //添加中文样式
        value: new Date().getFirstDateOfMonth().clearTime()
    });

    //结束日期
    var endEndDatePanel = new Ext.form.DateField({
        xtype: 'datefield',
        fieldLabel: '结束日期',
        anchor: '95%',
        format: 'Y年m月d日',  //添加中文样式
        value: new Date().clearTime()
    });
    var customerButton = new Ext.Button({
        xtype: 'button',
        iconCls: "find",
        hideLabel: true,
        listeners: {
            click: function(v) {
                //                if (lineUrl == '')
                //                    lineUrl = "../..";
                getCustomerInfo(function(record) { ArriveCustomerPostPanel.setValue(record.data.CustomerId); ArriveCustomerNamePostPanel.setValue(record.data.ChineseName); }, selectOrgIds);
            }
        }
    });
    var orgButton = new Ext.Button({
        xtype: 'button',
        iconCls: "find",
        hideLabel: true,
        listeners: {
            click: function(v) {
                selectOrgType();
            }
        }
    });
    
    var serchform = new Ext.FormPanel({
        renderTo: 'searchForm',
        labelAlign: 'left',
        // layout:'fit',
        buttonAlign: 'right',
        bodyStyle: 'padding:5px',
        frame: true,
        labelWidth: 55,
        items: [
    {
        layout: 'column',   //定义该元素为布局为列布局方式
        border: false,
        items: [{
            columnWidth: .3,  //该列占用的宽度，标识为20％
            layout: 'form',
            border: false,
            items: [
                    ArriveOrgText
                ]
        }, {
            name: 'cusStyle',
            columnWidth: .05,
            layout: 'form',
            border: false,
            items: [
                    orgButton
                ]
        }, {
            columnWidth: .3,
            layout: 'form',
            border: false,
            items: [
                    ArriveWhPostPanel
                    ]
        }, {
            name: 'cusStyle',
            columnWidth: .3,
            layout: 'form',
            border: false,
            items: [
                    ArriveCustomerNamePostPanel
                ]

        }, {
            name: 'cusStyle',
            columnWidth: .05,
            layout: 'form',
            border: false,
            items: [
                    customerButton
                ]
}]
        },
    {
        layout: 'column',   //定义该元素为布局为列布局方式
        border: false,
        items: [
        {
            columnWidth: .08,  //该列占用的宽度，标识为20％
            layout: 'form',
            border: false,
            items: [
                    startLabel
                ]
        },
        {
            columnWidth: .3,  //该列占用的宽度，标识为20％
            layout: 'form',
            border: false,
            items: [
                    beginStartDatePanel
                ]
        }, {
            columnWidth: .3,
            layout: 'form',
            border: false,
            items: [
                    beginEndDatePanel 
                    ]

}]
        },
    {
        layout: 'column',   //定义该元素为布局为列布局方式
        border: false,
        items: [
        {
            columnWidth: .08,  //该列占用的宽度，标识为20％
            layout: 'form',
            border: false,
            items: [
                    compareLabel
                ]
        },
        {
            columnWidth: .3,  //该列占用的宽度，标识为20％
            layout: 'form',
            border: false,
            items: [
                    endStartDatePanel
                ]
        }, {
            columnWidth: .3,
            layout: 'form',
            border: false,
            items: [
                    endEndDatePanel
                    ]
        }, {
            columnWidth: .2,
            layout: 'form',
            border: false,
            items: [{ cls: 'key',
                xtype: 'button',
                text: '查询',
                anchor: '50%',
                handler: function() {
                    var orgId = selectOrgIds;
                    var whId = ArriveWhPostPanel.getValue();
                    var customerId = ArriveCustomerPostPanel.getValue();
                    var beginStartDate = beginStartDatePanel.getValue();
                    var beginEndDate = beginEndDatePanel.getValue();

                    var endStartDate = endStartDatePanel.getValue();
                    var endEndDate = endEndDatePanel.getValue();

                    gridStore.baseParams.beginStartDate = Ext.util.Format.date(beginStartDate, 'Y/m/d');
                    gridStore.baseParams.beginEndDate = Ext.util.Format.date(beginEndDate, 'Y/m/d');

                    gridStore.baseParams.endStartDate = Ext.util.Format.date(endStartDate, 'Y/m/d');
                    gridStore.baseParams.endEndDate = Ext.util.Format.date(endEndDate, 'Y/m/d');

                    gridStore.baseParams.whId = whId;
                    gridStore.baseParams.orgId = orgId;
                    gridStore.baseParams.customerId = customerId;


                    gridStore.load();
                }
}]
}]
}]
    });

/*----------------------------*/

var gridStore = new Ext.data.Store({
url: 'frmWmsSaleCompareSearch.aspx?method=getlist',
     reader :new Ext.data.JsonReader({
    totalProperty: 'totalProperty',
    root: 'root',
    fields: [
	{ name: 'ProductId' },
	{		name:'ProductName'	},
	{ name: 'ProductCode' },
	{ name: 'SpecificationsText' },
	{ name: 'UnitText' },
	{ name: 'OrgName' },
	{ name: 'WhName'},
	{ name: 'BeginStartDate' },
	{ name: 'BeginEndDate' },
	{ name: 'EndStartDate' },
	{ name: 'EndEndDate' },
	{ name: 'FRealQty' },
	{ name: 'HRealQty' },
	{ name: 'DifferQty' }
	]
    })
});

</script>
<script type="text/javascript">

 function getCmbStore(columnName)
{
    return null;
}
    
Ext.onReady(function(){



var sm = new Ext.grid.CheckboxSelectionModel({
            singleSelect: true
});
//合计项
var viewGrid = new Ext.grid.EditorGridPanel({
    renderTo:"gird",                
    id: 'viewGrid',
    //region:'center',
    split:true,
    store: gridStore,
    plugins:[headerModel],
    autoscroll:true,
    height:550,
    width:'100%',
    title:'',
    loadMask: { msg: '正在加载数据，请稍侯……' },
    sm: sm,
    cm:colModel,
    viewConfig: {
        columnsText: '显示的列',
        scrollOffset: 20,
        sortAscText: '升序',
        sortDescText: '降序',
        forceFit: true
    },
    loadMask: true,
    closeAction: 'hide',
    stripeRows: true    
});
//ArriveOrgPostPanel.setValue(<% =ZJSIG.UIProcess.ADM.UIAdmUser.OrgID(this)%>);
//ArriveOrgPostPanel.setDisabled(true);
dsWareHouse.load({ params: { OrgId: <% =ZJSIG.UIProcess.ADM.UIAdmUser.OrgID(this)%>, ForBusi: 1} });
})
</script>
<script type="text/javascript" src="../../js/SelectModule.js"></script>
</html>