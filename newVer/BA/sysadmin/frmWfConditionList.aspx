<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmWfConditionList.aspx.cs" Inherits="BA_sysadmin_frmWfConditionList" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <link rel="stylesheet" type="text/css" href="../../ext3/resources/css/ext-all.css" />
    <script type="text/javascript" src="../../ext3/adapter/ext/ext-base.js"></script>
    <script type="text/javascript" src="../../ext3/ext-all.js"></script>
    <script type="text/javascript" src="../../js/operateResp.js"></script>
    <script type="text/javascript" src="../../js/OrgsSelect.js"></script>
    <script type="text/javascript" src="../../ext3/example/ItemDeleter.js"></script>
    <style type="text/css">
.extensive-remove {
background-image: url(../../Theme/1/images/extjs/customer/cross.gif) ! important;
}
.x-grid-back-blue { 
background: #B7CBE8; 
}
</style>
</head>
<%=getComboBoxSource()%>
<script type="text/javascript">
    Ext.BLANK_IMAGE_URL = "../../ext3/resources/images/default/s.gif";
    var conditionGridData = null;
    function loadData() {
        conditionGridData.baseParams.StepId = stepId;
        conditionGridData.load({ params: { limit: 1000, start: 0} });
    }
    
    var numCompareStore = new Ext.data.SimpleStore({
   fields: ['id', 'name', 'value'],        
   data : [        
   ['6', '小于', '<'],
   ['7', '小于等于', '<='],        
   ['4', '等于', '='],
   ['9', '大于等于', '='],
   ['8', '大于', '=']   
   ]});
   
    Ext.onReady(function() {
        var imageUrl = "../../Theme/1/";
        var saveType = '';
        /*------实现toolbar的函数 start---------------*/
        var Toolbar = new Ext.Toolbar({
            renderTo: "toolbar",
            items: [{
                text: "新增",
                icon: imageUrl + "images/extjs/customer/add16.gif",
                handler: function() {
                    saveType = 'addcondition';
                    openAddConditionWin();
                }
            }, '-', {
                text: "编辑",
                icon: imageUrl + "images/extjs/customer/edit16.gif",
                handler: function() {
                    saveType = 'editcondition';
                    modifyConditionWin();
                }
            }, '-', {
                text: "删除",
                icon: imageUrl + "images/extjs/customer/delete16.gif",
                handler: function() {
                    deleteCondition();
                }
}]
            });

            /*------结束toolbar的函数 end---------------*/
            var stepGridData = null;
            function getStepGridData() {
                var setFrame = parent.document.getElementById("iframeset");

                if (setFrame != null) {
                    stepGridData = setFrame.contentWindow.stepGridData
                }
                else {
                    setGridData = stepGridData;
                }

            }
            getStepGridData();

            /*------开始ToolBar事件函数 start---------------*//*-----新增Condition实体类窗体函数----*/
            function openAddConditionWin() {
                Ext.getCmp('ConditionId').setValue("");
                //Ext.getCmp('StepId').setValue(""),
                Ext.getCmp('ConditionColumn').setValue("");
                Ext.getCmp('ConditionValue').setValue("");
                Ext.getCmp('ConditionSelectRoute').setValue("");
                Ext.getCmp('ConditionType').setValue("");
                Ext.getCmp('OrgName').setValue("");
                Ext.getCmp('OrgId').setValue("");
                var index = stepGridData.find('StepId', stepId);
                if (index >= 0) {
                    var record = stepGridData.getAt(index);
                    Ext.getCmp("StepName").setValue(record.data.StepName);
                }
                inserNewBlankRow();
                uploadConditionWindow.show();
            }
            /*-----编辑Condition实体类窗体函数----*/
            function modifyConditionWin() {
                var sm = Ext.getCmp('conditionGrid').getSelectionModel();
                //获取选择的数据信息
                var selectData = sm.getSelected();
                if (selectData == null) {
                    Ext.Msg.alert("提示", "请选中需要编辑的信息！");
                    return;
                }
                uploadConditionWindow.show();
                setFormValue(selectData);
            }
            /*-----删除Condition实体函数----*/
            /*删除信息*/
            function deleteCondition() {
                var sm = Ext.getCmp('conditionGrid').getSelectionModel();
                //获取选择的数据信息
                var selectData = sm.getSelected();
                //如果没有选择，就提示需要选择数据信息
                if (selectData == null) {
                    Ext.Msg.alert("提示", "请选中需要删除的信息！");
                    return;
                }
                //删除前再次提醒是否真的要删除
                Ext.Msg.confirm("提示信息", "是否真的要删除选择的信息吗？", function callBack(id) {
                    //判断是否删除数据
                    if (id == "yes") {
                        //页面提交
                        Ext.Ajax.request({
                            url: 'frmWfConditionList.aspx?method=delcondition',
                            method: 'POST',
                            params: {
                                ConditionId: selectData.data.ConditionId
                            },
                            success: function(resp, opts) {
                                if (checkExtMessage(resp)) {
                                    conditionGridData.reload();
                                    uploadConditionWindow.hide();
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
            var conditionForm = new Ext.form.FormPanel({
                frame: true,
                region:'north',
                height:180,
                items: [
		{
		    xtype: 'hidden',
		    fieldLabel: '条件标识',
		    columnWidth: 1,
		    anchor: '90%',
		    name: 'ConditionId',
		    id: 'ConditionId'
		}
, {
    xtype: 'textfield',
    fieldLabel: '步骤名称',
    columnWidth: 1,
    anchor: '90%',
    name: 'StepName',
    id: 'StepName'
}
, {
    xtype: 'textfield',
    fieldLabel: '判断字段',
    columnWidth: 1,
    anchor: '90%',
    name: 'ConditionColumn',
    id: 'ConditionColumn'
}
, {
    xtype: 'textfield',
    fieldLabel: '条件值',
    columnWidth: 1,
    anchor: '90%',
    name: 'ConditionValue',
    id: 'ConditionValue'
}
, {
    xtype: 'combo',
    fieldLabel: '选择路由',
    columnWidth: 1,
    anchor: '90%',
    store: stepStore,
    displayField: 'RouteComment',
	valueField: 'RouteId',
    name: 'ConditionSelectRoute',
    id: 'ConditionSelectRoute',
    typeAhead: true,
    mode: 'local',
    emptyText: '请选择路由信息',
    triggerAction: 'all'
}
, {
    xtype: 'combo',
    fieldLabel: '条件类型',
    columnWidth: 1,
    anchor: '90%',
    store: numCompareStore,
    displayField: 'name',
	valueField: 'id',
    name: 'ConditionType',
    id: 'ConditionType',
    typeAhead: true,
    mode: 'local',
    emptyText: '请选择条件类型信息',
    triggerAction: 'all'
}
, {
    xtype: 'textfield',
    fieldLabel: '机构信息',
    columnWidth: 1,
    anchor: '90%',
    name: 'OrgName',
    id: 'OrgName'
}, {
    xtype: 'hidden',
    anchor: '90%',
    name: 'OrgId',
    id: 'OrgId'
}
]
            });
            
            /*条件细项信息 */
//            var numCompareStore = new Ext.data.SimpleStore({
//               fields: ['id', 'name', 'value'],        
//               data : [        
//               ['6', '小于', '<'],
//               ['7', '小于等于', '<='],        
//               ['4', '等于', '='],
//               ['9', '大于等于', '='],
//               ['8', '大于', '=']   
//               ]});
            
            //数字比较控件
var comboNumCompare = new Ext.form.ComboBox({
        id: 'comboNumCompare',
        store: numCompareStore, // 下拉数据           
        displayField:'name', //显示上面的fields中的state列的内容,相当于option的text值        
        valueField: 'id', // 选项的值, 相当于option的value值        
        name: 'comboNumCompare',        
        mode: 'local', // 必须要,如果为 remote, 则会用ajax获取数据        
        triggerAction: 'all', // 点击下拉的时候, all 为展出所有Store中data的数据        
        readOnly: true, // 如果设为true,则好像一般的下拉框一样，默认是false,可输入并自动匹配        
        emptyText:'请选择比较类型',
        width:100,   
        hidden:true,
        editable:false,    
        selectOnFocus:true,
        listeners: {
                "select": addNewBlankRow
            }});
        
            function inserNewBlankRow() {
            var rowCount = userGrid.getStore().getCount();
            var insertPos = parseInt(rowCount);
            var addRow = new RowPattern({
                AndId:'0',
                ConditionId:Ext.getCmp("ConditionId").getValue(),
			    ColumnName:'',
			    CompareType:'',
			    ColumnValue:'',
			    ColumnDataType:''
            });
            userGrid.stopEditing();
            //增加一新行
            if (insertPos > 0) {
                var rowIndex = dsConditionAnd.insert(insertPos, addRow);
                userGrid.startEditing(insertPos, 0);
            }
            else {
                var rowIndex = dsConditionAnd.insert(0, addRow);
                userGrid.startEditing(0, 0);
            }
        }
        function addNewBlankRow(combo, record, index) {
            var rowIndex = userGrid.getStore().indexOf(userGrid.getSelectionModel().getSelected());
            var rowCount = userGrid.getStore().getCount();
            if ((rowIndex == 0 && rowCount == 1) || rowIndex == rowCount - 1) {
                inserNewBlankRow();
            }
        }
        
            var RowPattern = Ext.data.Record.create([
           { name: 'AndId', type: 'string' },
           { name: 'ConditionId', type: 'string' },
           { name: 'ColumnName', type: 'string' },
           { name: 'CompareType'},
           { name: 'ColumnValue', type: 'string' },
           { name: 'ColumnDataType', type: 'string' }
          ]);

    var dsConditionAnd;
    if (dsConditionAnd == null) {
        dsConditionAnd = new Ext.data.Store
	        ({
	            url: 'frmWfConditionList.aspx?method=getDtlList',
	            reader: new Ext.data.JsonReader({
	                totalProperty: 'totalProperty',
	                root: 'root'
	            }, RowPattern)
	        });
       
    }
    
    dsConditionAnd.on('load', function(){ 
        inserNewBlankRow();
}); 
            
            var cm = new Ext.grid.ColumnModel([
        new Ext.grid.RowNumberer(), //自动行号
        new Extensive.grid.ItemDeleter(),
         {
            id: 'ColumnName',
            header: "列名",
            dataIndex: 'ColumnName',
            width: 30,
            editor:new Ext.form.TextField({})
        },
        {
            id: 'CompareType',
            header: "比较类型",
            dataIndex: 'CompareType',
            width: 65,
            editor: comboNumCompare,
            renderer: function(value, cellmeta, record, rowIndex, columnIndex, store) {
                //解决值显示问题
                //获取当前id="combo_process"的comboBox选择的值
                 var index = numCompareStore.find(comboNumCompare.valueField, value);
                var record = numCompareStore.getAt(index);
                var displayText = "";
                // 如果下拉列表没有被选择，那么record也就不存在，这时候，返回传进来的value，
                // 而这个value就是grid的USER_REALNAME列的value，所以直接返回
                if (record == null) {
                    //返回默认值，
                    displayText = value;
                } else {
                    displayText = record.data.name; //获取record中的数据集中的process_name字段的值
                }

                return displayText;
            }
        },{
            id: 'ColumnValue',
            header: "值",
            dataIndex: 'ColumnValue',
            width: 30,
            editor:new Ext.form.TextField({})
        },{
            id: 'ColumnDataType',
            header: "数据类型",
            dataIndex: 'ColumnDataType',
            width: 30,
            editor:new Ext.form.TextField({})
        }]);
        
        var userGrid = new Ext.grid.EditorGridPanel({
        store: dsConditionAnd,
        cm: cm,
        selModel: new Extensive.grid.ItemDeleter(),
        region: 'center',
        width: '100%',
        height: 180,
        stripeRows: true,
        frame: true,
        clicksToEdit: 1,
        viewConfig: {
            columnsText: '显示的列',
            scrollOffset: 20,
            sortAscText: '升序',
            sortDescText: '降序',
            forceFit: true
        }

    });
            /*------FormPanle的函数结束 End---------------*/

            Ext.getCmp("OrgName").on("focus", selectOrg);
            function selectOrg(v) {
                if (selectOrgForm == null) {
                    showOrgForm(0, '机构选择', 'frmWfConditionList.aspx?method=getorgtreelist');
                    selectOrgTree.on('checkchange', treeCheckChange, selectOrgTree);
                    Ext.getCmp("btnOrgOk").on("click", selectOK);
                }
                else {
                    showOrgForm(0, '机构选择', '');
                }
            }

            function treeCheckChange(node, checked) {
                selectOrgTree.un('checkchange', treeCheckChange, selectOrgTree);
                if (checked) {
                    var selectNodes = selectOrgTree.getChecked();
                    for (var i = 0; i < selectNodes.length; i++) {
                        if (selectNodes[i].id != node.id) {
                            selectNodes[i].ui.toggleCheck(false);
                            selectNodes[i].attributes.checked = false;
                        }
                    }
                }
                selectOrgTree.on('checkchange', treeCheckChange, selectOrgTree);
            }
            
            function selectOK() {
                var selectNodes = selectOrgTree.getChecked();
                if (selectNodes.length > 0) {
                    Ext.getCmp("OrgName").setValue(selectNodes[0].text);
                    Ext.getCmp("OrgId").setValue(selectNodes[0].id);
                }
            }

            /*------开始界面数据的窗体 Start---------------*/
            if (typeof (uploadConditionWindow) == "undefined") {//解决创建2个windows问题
                uploadConditionWindow = new Ext.Window({
                    id: 'Conditionformwindow',
                    title: '步骤跳转条件信息设置'
		, iconCls: 'upload-win'
		, width: 400
		, height: 380
		, layout: 'border'
		, plain: true
		, modal: true
		, x: 50
		, y: 50
		, constrain: true
		, resizable: false
		, closeAction: 'hide'
		, autoDestroy: true
		, items: [conditionForm,userGrid]
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
			    uploadConditionWindow.hide();
			}
			, scope: this
}]
                });
            }
            uploadConditionWindow.addListener("hide", function() {
            });

            /*------开始获取界面数据的函数 start---------------*/
            function getFormValue() {

                var json = "";
                for(var i=0;i<dsConditionAnd.getCount();i++)
                {
                    var checkData = dsConditionAnd.getAt(i);
                    if(checkData.data.ProductId!='')
                    {
                        if(checkData.data.WhpId=='')
                        {
                            Ext.Msg.alert("提示","请选择仓位信息");
                            return;
                        }
                    }
                }
                dsConditionAnd.each(function(dsConditionAnd) {                
                    json += Ext.util.JSON.encode(dsConditionAnd.data) + ',';
                });
                json = json.substring(0, json.length - 1);
                
                Ext.Ajax.request({
                    url: 'frmWfConditionList.aspx?method=' + saveType,
                    method: 'POST',
                    params: {
                        ConditionId: Ext.getCmp('ConditionId').getValue(),
                        StepId: stepId,
                        ConditionColumn: Ext.getCmp('ConditionColumn').getValue(),
                        ConditionValue: Ext.getCmp('ConditionValue').getValue(),
                        ConditionSelectRoute: Ext.getCmp('ConditionSelectRoute').getValue(),
                        ConditionType: Ext.getCmp('ConditionType').getValue(),
                        DetailInfo:json
                    },
                    success: function(resp, opts) {
                        if (checkExtMessage(resp)) {
                            conditionGridData.reload();
                            uploadConditionWindow.hide();
                        }
                    },
                    failure: function(resp, opts) {
                        Ext.Msg.alert("提示", "保存失败");
                    }
                });
            }
            /*------结束获取界面数据的函数 End---------------*/

            /*------开始界面数据的函数 Start---------------*/
            function setFormValue(selectData) {
                Ext.Ajax.request({
                    url: 'frmWfConditionList.aspx?method=getcondition',
                    params: {
                        ConditionId: selectData.data.ConditionId
                    },
                    success: function(resp, opts) {
                        var data = Ext.util.JSON.decode(resp.responseText);
                        Ext.getCmp("ConditionId").setValue(data.ConditionId);
                        //Ext.getCmp("StepId").setValue(data.StepId);
                        Ext.getCmp("ConditionColumn").setValue(data.ConditionColumn);
                        Ext.getCmp("ConditionValue").setValue(data.ConditionValue);
                        Ext.getCmp("ConditionSelectRoute").setValue(data.ConditionSelectRoute);
                        Ext.getCmp("ConditionType").setValue(data.ConditionType);

                        var index = stepGridData.find('StepId', data.StepId);
                        if (index >= 0) {
                            var record = stepGridData.getAt(index);
                            Ext.getCmp("StepName").setValue(record.data.StepName);
                        }
                        dsConditionAnd.baseParams.ConditionId = data.ConditionId;
                        dsConditionAnd.load();
                    },
                    failure: function(resp, opts) {
                        Ext.Msg.alert("提示", "获取信息失败");
                    }
                });
            }
            /*------结束设置界面数据的函数 End---------------*/

            /*------开始获取数据的函数 start---------------*/
            conditionGridData = new Ext.data.Store
({
    url: 'frmWfConditionList.aspx?method=getconditionlist',
    reader: new Ext.data.JsonReader({
        totalProperty: 'totalProperty',
        root: 'root'
    }, [
	{
	    name: 'ConditionId'
	},
	{
	    name: 'StepId'
	},
	{
	    name: 'ConditionColumn'
	},
	{
	    name: 'ConditionValue'
	},
	{
	    name: 'ConditionSelectRoute'
	},
	{
	    name: 'ConditionType'
}])
	,
    listeners:
	{
	    scope: this,
	    load: function() {
	    }
	}
});

            /*------获取数据的函数 结束 End---------------*/

function getRouteName(val)
{
     //解决值显示问题
                 var index = stepStore.find('RouteId', val);
                var record = stepStore.getAt(index);
                var displayText = "";
                // 如果下拉列表没有被选择，那么record也就不存在，这时候，返回传进来的value，
                // 而这个value就是grid的USER_REALNAME列的value，所以直接返回
                if (record == null) {
                    //返回默认值，
                    displayText = val;
                } else {
                    displayText = record.data.RouteComment; //获取record中的数据集中的process_name字段的值
                }

                return displayText;
}
            /*------开始DataGrid的函数 start---------------*/

            var sm = new Ext.grid.CheckboxSelectionModel({
                singleSelect: true
            });
            var conditionGrid = new Ext.grid.GridPanel({
                el: 'conditionGrid',
                width: '100%',
                height: '100%',
                autoWidth: true,
                autoHeight: true,
                autoScroll: true,
                layout: 'fit',
                id: 'conditionGrid',
                store: conditionGridData,
                loadMask: { msg: '正在加载数据，请稍侯……' },
                sm: sm,
                cm: new Ext.grid.ColumnModel([
		sm,
		new Ext.grid.RowNumberer(), //自动行号
		{
		header: '条件标识',
		dataIndex: 'ConditionId',
		id: 'ConditionId',
		hidden:true
},
		{
		    header: '步骤标识',
		    dataIndex: 'StepId',
		    id: 'StepId'
		},
		{
		    header: '判断字段',
		    dataIndex: 'ConditionColumn',
		    id: 'ConditionColumn'
		},
		{
		    header: '条件值',
		    dataIndex: 'ConditionValue',
		    id: 'ConditionValue'
		},
		{
		    header: '选择路由',
		    dataIndex: 'ConditionSelectRoute',
		    id: 'ConditionSelectRoute',
		    renderer:getRouteName
		},
		{
		    header: '条件类型（0 步骤前或1 步骤后）',
		    dataIndex: 'ConditionType',
		    id: 'ConditionType'
}]),
                bbar: new Ext.PagingToolbar({
                    pageSize: 10,
                    store: conditionGridData,
                    displayMsg: '显示第{0}条到{1}条记录,共{2}条',
                    emptyMsy: '没有记录',
                    displayInfo: true
                }),
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
            conditionGrid.render();
            /*------DataGrid的函数结束 End---------------*/

            loadData();

        })
</script>
<body>
<div id='toolbar'></div>
<div id='divForm'></div>
<div id='conditionGrid'></div>

</body>
</html>
