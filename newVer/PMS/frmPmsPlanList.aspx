<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmPmsPlanList.aspx.cs" Inherits="PMS_frmPmsPlan" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html>
<head>
<title>生产计划维护</title><meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<link rel="stylesheet" type="text/css" href="../ext3/resources/css/ext-all.css" />
<script type="text/javascript" src="../ext3/adapter/ext/ext-base.js"></script>
<script type="text/javascript" src="../ext3/ext-all.js"></script>
<script type="text/javascript" src="../js/operateResp.js"></script>
<style type="text/css">
.x-grid-back-blue {  
    background: #C3D9FF;  
}  
</style>
</head>
<body>
<div id='toolbar'></div>
<div id='divForm'></div>
<div id='dataGrid'></div>
<%=getComboBoxStore() %>
</body>
<script type="text/javascript">
Ext.BLANK_IMAGE_URL = "../ext3/resources/images/default/s.gif";
Ext.onReady(function(){
var saveType;
/*------实现toolbar的函数 start---------------*/
var Toolbar = new Ext.Toolbar({
	renderTo:"toolbar",
	items:[{
		text:"新增",
		icon:"../Theme/1/images/extjs/customer/add16.gif",
		handler:function(){
		    saveType = 'addPlan';
		    openAddPlanWin();
		    addNewBlankRow();
		}
		},'-',{
		text:"编辑",
		icon:"../Theme/1/images/extjs/customer/edit16.gif",
		handler:function(){
		    saveType = 'savePlan';
		    modifyPlanWin();
		}
		},'-',{
		text:"删除",
		icon:"../Theme/1/images/extjs/customer/delete16.gif",
		handler:function(){
		    deletePlan();
		}
	}]
});

/*------结束toolbar的函数 end---------------*/


/*------开始ToolBar事件函数 start---------------*//*-----新增Plan实体类窗体函数----*/
function openAddPlanWin() {
	uploadPlanWindow.show();
}
/*-----编辑Plan实体类窗体函数----*/
function modifyPlanWin() {
	var sm = pmsPlanGrid.getSelectionModel();
	//获取选择的数据信息
	var selectData =  sm.getSelected();
	if(selectData == null){
		Ext.Msg.alert("提示","请选中需要编辑的信息！");
		return;
	}
	uploadPlanWindow.show();
	setFormValue(selectData);
	setGridValue(selectData);
}
/*-----删除Plan实体函数----*/
/*删除信息*/
function deletePlan()
{
	var sm = pmsPlanGrid.getSelectionModel();
	//获取选择的数据信息
	var selectData =  sm.getSelected();
	//如果没有选择，就提示需要选择数据信息
	if(selectData == null){
		Ext.Msg.alert("提示","请选中需要删除的信息！");
		return;
	}
	//删除前再次提醒是否真的要删除
	Ext.Msg.confirm("提示信息","是否真的要删除选择的信息吗？",function callBack(id){
		//判断是否删除数据
		if(id=="yes")
		{
			//页面提交
			Ext.Ajax.request({
				url:'frmPmsPlanList.aspx?method=deletePlan',
				method:'POST',
				params:{
					PlanId:selectData.data.PlanId
				},
				success: function(resp,opts){
					Ext.Msg.alert("提示","数据删除成功");
				},
				failure: function(resp,opts){
					Ext.Msg.alert("提示","数据删除失败");
				}
			});
		}
	});
}

/*------实现FormPanle的函数 start---------------*/
var pmsPlanForm=new Ext.form.FormPanel({
	url:'',	
	frame:true,
	title:'',
	labelWidth:55,
	region:'north',
	height:140,
	items:[
		{
			xtype:'hidden',
			fieldLabel:'计划ID',
			name:'PlanId',
			id:'PlanId',
			hidden:true,
			hideLabel:true
		}
,		{
			xtype:'combo',
			fieldLabel:'车间',
			columnWidth:1,
			anchor:'98%',
			name:'WorkshopId',
			id:'WorkshopId',
			store:dsWs,
			displayField:'WsName',
		    valueField:'WsId',
		    mode:'local',
		    triggerAction:'all',
		    editable: false
		}
,		{
            layout:'column',
            items:[
            {
                layout:'form',
                columnWidth:0.495,
                items:[{
			        xtype:'combo',
			        fieldLabel:'生产年份',			    
			        anchor:'98%',
			        name:'Year',
			        id:'Year',
			        store:dsYear,
			        displayField:'DicsName',
		            valueField:'DicsCode',
		            mode:'local',
		            triggerAction:'all'
			    }]
			},
			{
			    layout:'form',
                columnWidth:0.495,
                items:[{
			        xtype:'combo',
			        fieldLabel:'生产月份',
			        anchor:'98%',
			        name:'Month',
			        id:'Month',
			        store:dsMonth,
			        displayField:'DicsName',
		            valueField:'DicsCode',
		            mode:'local',
		            triggerAction:'all'
			    }]
		    }]
		}
,		{
			xtype:'textarea',
			fieldLabel:'备注',
			columnWidth:1,
			anchor:'98%',
			width:50,
			name:'Remark',
			id:'Remark'
		}
]
});
/*------FormPanle的函数结束 End---------------*/
/*------明细grid的函数 start---------------*/
var RowPattern = Ext.data.Record.create([
   { name: 'PlanDetailId', type: 'string' },
   { name: 'PlanId', type: 'string' },
   { name: 'ProductId', type: 'string' },
   { name: 'SpecificationsText', type: 'string' },
   { name: 'UnitText', type: 'string' },
   { name: 'PlanQty', type: 'float' },
   { name: 'PlanWeight', type: 'float' },
   { name: 'Dates', type: 'string' }
 ]);
var dspmsplandtl = new Ext.data.Store
({
url: 'frmPmsPlanList.aspxx?method=getplandtllist',
reader:new Ext.data.JsonReader({
	totalProperty:'totalProperty',
	root:'root'
},RowPattern)
});
function inserNewBlankRow() {
    var rowCount = planDtlInfoGrid.getStore().getCount();
    //alert(rowCount);
    var insertPos = parseInt(rowCount);
    var addRow = new RowPattern({
        PlanDetailId: '-1',
        PlanId: '-1',
        ProductId: '',
        SpecificationsText: '',
        UnitText: '',
        PlanQty: '',
        PlanWeight:'',
        Dates:''
    });
    planDtlInfoGrid.stopEditing();
    //增加一新行
    if (insertPos > 0) {
        var rowIndex = dspmsplandtl.insert(insertPos, addRow);
        planDtlInfoGrid.startEditing(insertPos, 0);
    }
    else {
        var rowIndex = dspmsplandtl.insert(0, addRow);
        planDtlInfoGrid.startEditing(0, 0);
    }
}
function addNewBlankRow(combo, record, index) {
    var rowIndex = planDtlInfoGrid.getStore().indexOf(planDtlInfoGrid.getSelectionModel().getSelected());
    var rowCount = planDtlInfoGrid.getStore().getCount();
    //alert('insertPos:'+rowCount+":"+rowIndex);
    //provideGridDtlData.getSelectionModel().selectRow(rowCount - 1,true);   
    if ((rowIndex == 0 && rowCount == 1) || rowIndex == rowCount - 1) {
        inserNewBlankRow();
    }
}
function setGridValue(selectData){
    dspmsplandtl.baseParams.RecodrId=selectData.data.PlanId;                    
    dspmsplandtl.load({
        callback : function(r, options, success) {
            inserNewBlankRow();
        }
    });
}

var smDtl= new Ext.grid.CheckboxSelectionModel({
	singleSelect:true
});
/*------开始明细DataGrid的函数 start---------------*/
var productCombo = new Ext.form.ComboBox({
    store: dsProductList,
    displayField: 'ProductName',
    valueField: 'ProductId',
    triggerAction: 'all',
    id: 'productCombo',
    typeAhead: true,
    mode: 'local',
    emptyText: '',
    selectOnFocus: false,
    editable: true,
    onSelect: function(record) {
        var sm = planDtlInfoGrid.getSelectionModel().getSelected();
        sm.set('ProductId', record.data.ProductId);
        sm.set('SpecificationsText', record.data.SpecificationsText);
        sm.set('UnitText', record.data.UnitText);
        //隐含字段赋值
        if(sm.get('id') == undefined ||sm.get('id')==null ||sm.get('id') =="")
        {
            sm.set('Id', 0);
            sm.set('RecordId', 0);
        }        
        addNewBlankRow();
        this.collapse();        
        var rowid = planDtlInfoGrid.getStore().indexOf(sm);
        planDtlInfoGrid.startEditing(rowid,6);
    }
});
var planDtlInfoGrid = new Ext.grid.EditorGridPanel({	
	width:'100%',
	//height:'100%',
	autoWidth:true,
	//autoHeight:true,
	autoScroll:true,
	region: 'center',
	clicksToEdit: 1,
	enableHdMenu: false,  //不显示排序字段和显示的列下拉框
	enableColumnMove: false,//列不能移动
	id: '',
	store: dspmsplandtl,
	loadMask: {msg:'正在加载数据，请稍侯……'},
	sm:smDtl,
	cm: new Ext.grid.ColumnModel([
	    smDtl,
		new Ext.grid.RowNumberer(),//自动行号
		{
			header:'流水号',
			dataIndex:'Id',
			id:'Id',
			hidden: true,
            hideable: false
		},
		{
			header:'商品',
			dataIndex:'ProductId',
			id:'ProductId',
			width:150,
			editor: productCombo,
            renderer: function(value, cellmeta, record, rowIndex, columnIndex, store) {
                //解决值显示问题
                //获取当前id="combo_process"的comboBox选择的值
                var index = dsProductList.findBy(function(record, id) {
                    return record.get(productCombo.valueField) == value;
                });
                var record = dsProductList.getAt(index);
                var displayText = "";
                // 如果下拉列表没有被选择，那么record也就不存在，这时候，返回传进来的value，
                // 而这个value就是grid的USER_REALNAME列的value，所以直接返回
                if (record == null) {
                    //返回默认值，
                    displayText = value;
                } else {
                    displayText = record.data.ProductName; //获取record中的数据集中的process_name字段的值
                }
                return displayText;
            }
		},		
		{
			header:'规格',
			width:50,
			dataIndex:'SpecificationsText',
			id:'SpecificationsText',
            renderer:{fn:function(value,cellmeta){
                cellmeta.css='x-grid-back-blue'; 
                return value;
            }}
		},
		{
			header:'单位',
			width:50,
			dataIndex:'UnitText',
			id:'UnitText',
            renderer:{fn:function(value,cellmeta){
                cellmeta.css='x-grid-back-blue'; 
                return value;
            }}
		},
		{
			header:'预期生产数量',
			dataIndex:'PlanQty',
			id:'PlanQty',
			width:50,
			editor: new Ext.form.NumberField({ allowBlank: true })
		},
		{
			header:'预期生产重量',
			dataIndex:'PlanWeight',
			id:'PlanWeight',
			width:50,
			editor: new Ext.form.NumberField({ allowBlank: true })
		},
		{
			header:'日程（指定当月号数）',
			dataIndex:'Dates',
			id:'Dates',
			width:150,
			editor: new Ext.form.TextArea({ allowBlank: false })
		}
		]),
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
/*------明细grid的函数 End---------------*/
/*------开始界面数据的窗体 Start---------------*/
if(typeof(uploadPlanWindow)=="undefined"){//解决创建2个windows问题
	uploadPlanWindow = new Ext.Window({
		id:'Planformwindow',
		title:'生产计划'
		, iconCls: 'upload-win'
		, width: 750
		, height: 450
		, layout: 'border'
		, plain: true
		, modal: true
		, constrain:true
		, resizable: false
		, closeAction: 'hide'
		,autoDestroy :true
		,items:[pmsPlanForm,planDtlInfoGrid]
		,buttons: [{
			text: "保存"
			, handler: function() {
				saveUserData();
			}
			, scope: this
		},
		{
			text: "取消"
			, handler: function() { 
				uploadPlanWindow.hide();
			}
			, scope: this
		}]});
	}
	uploadPlanWindow.addListener("hide",function(){
	    pmsPlanForm.getForm().reset();
});

/*------开始获取界面数据的函数 start---------------*/
function saveUserData()
{
    var json = "";
    dspmsplandtl.each(function(record) {
        json += Ext.util.JSON.encode(record.data) + ',';
    });
    json = json.substring(0, json.length - 1);
    //然后传入参数保存
    //alert(json);
    //alert(saveType);
	Ext.Ajax.request({
		url:'frmPmsPlanList.aspx?method='+saveType,
		method:'POST',
		params:{
			PlanId:Ext.getCmp('PlanId').getValue(),
			WorkshopId:Ext.getCmp('WorkshopId').getValue(),
			Year:Ext.getCmp('Year').getValue(),
			Month:Ext.getCmp('Month').getValue(),
			Remark:Ext.getCmp('Remark').getValue(),
			DetailInfo:json
			},
		success: function(resp,opts){
		    if(checkExtMessage(resp)){
			   dsPmsPlanData.reload({params:{start:0,limit:10}});
			}
		},
		failure: function(resp,opts){
			Ext.Msg.alert("提示","保存失败");
		}
		});
		}
/*------结束获取界面数据的函数 End---------------*/

/*------开始界面数据的函数 Start---------------*/
function setFormValue(selectData)
{
	Ext.Ajax.request({
		url:'frmPmsPlanList.aspx?method=getplan',
		params:{
			PlanId:selectData.data.PlanId
		},
	success: function(resp,opts){
		var data=Ext.util.JSON.decode(resp.responseText);
		Ext.getCmp("PlanId").setValue(data.PlanId);
		Ext.getCmp("WorkshopId").setValue(data.WorkshopId);
		Ext.getCmp("Year").setValue(data.Year);
		Ext.getCmp("Month").setValue(data.Month);
		Ext.getCmp("Remark").setValue(data.Remark);
	},
	failure: function(resp,opts){
		Ext.Msg.alert("提示","获取用户信息失败");
	}
	});
}
/*------结束设置界面数据的函数 End---------------*/
/*------开始查询form end---------------*/

    //车间
    var planWsIdPanel = new Ext.form.ComboBox({
        xtype:'combo',
        fieldLabel:'车间',
        anchor:'95%',
        name:'StartDate',
        id:'StartDate',
		store:dsWs,
		displayField:'WsName',
	    valueField:'WsId',
	    mode:'local',
	    triggerAction:'all',
	    editable: false
    });

    //年份
    var planYearPanel = new Ext.form.ComboBox({
        xtype:'combo',
        fieldLabel:'年份',
        anchor:'95%',
        name:'EndDate',
        id:'EndDate',
        store:dsYear,
        displayField:'DicsName',
        valueField:'DicsCode',
        mode:'local',
        triggerAction:'all'
    });
    //月份
    var planMonthPanel = new Ext.form.ComboBox({
        cls: 'key',
        xtype: 'combo',
        fieldLabel: '月份',
        name: 'nameCust',
        anchor: '95%',
        store:dsMonth,
        displayField:'DicsName',
        valueField:'DicsCode',
        mode:'local',
        triggerAction:'all'
    });

    var serchform = new Ext.FormPanel({
        renderTo: 'divForm',
        labelAlign: 'left',
        layout:'fit',
        buttonAlign: 'right',
        bodyStyle: 'padding:5px',
        frame: true,
        labelWidth: 80,
        items: [{
            layout: 'column',   //定义该元素为布局为列布局方式
            border: false,
            items: [{
                columnWidth: .28,  //该列占用的宽度，标识为20％
                layout: 'form',
                border: false,
                items: [
                    planWsIdPanel
                ]
            }, {
                columnWidth: .28,
                layout: 'form',
                border: false,
                items: [
                    planYearPanel
                    ]
            }, {
                name: 'cusStyle',
                columnWidth: .36,
                layout: 'form',
                border: false,
                labelWidth: 55,
                items: [
                    planMonthPanel
                ]
            }, {
                columnWidth: .08,
                layout: 'form',
                border: false,
                items: [{ cls: 'key',
                    xtype: 'button',
                    text: '查询',
                    anchor: '50%',
                    handler :function(){
                    
                    var strWsId=planWsIdPanel.getValue();
                    var strYear=planYearPanel.getValue();
                    var strMonth=planMonthPanel.getValue();
                    
                    dsPmsPlanData.baseParams.WorkshopId=strWsId;
                    dsPmsPlanData.baseParams.Year=strYear;
                    dsPmsPlanData.baseParams.Month=strMonth;
                    
                    dsPmsPlanData.load({
                                params : {
                                start : 0,
                                limit : 10
                                } });
                    }
                }]
            }]
        }]
    });
/*------开始查询form end---------------*/
/*------开始获取数据的函数 start---------------*/
var dsPmsPlanData = new Ext.data.Store
({
url: 'frmPmsPlanList.aspx?method=getPmsPlanList',
reader:new Ext.data.JsonReader({
	totalProperty:'totalProperty',
	root:'root'
},[
	{		name:'PlanId'	},
	{		name:'OrgId'	},
	{		name:'OperId'	},
	{		name:'OwnerId'	},
	{		name:'WorkshopId'	},
	{		name:'Year'	},
	{		name:'Month'	},
	{		name:'Remark'	},
	{		name:'CreateDate'	},
	{		name:'UpdateDate'
	}	])
	,
	listeners:
	{
		scope:this,
		load:function(){
		}
	}
});

/*------获取数据的函数 结束 End---------------*/

/*------开始DataGrid的函数 start---------------*/

var sm= new Ext.grid.CheckboxSelectionModel({
	singleSelect:true
});
var pmsPlanGrid = new Ext.grid.GridPanel({
	el: 'dataGrid',
	width:'100%',
	height:'100%',
	autoWidth:true,
	autoHeight:true,
	autoScroll:true,
	layout: 'fit',
	id: '',
	store: dsPmsPlanData,
	loadMask: {msg:'正在加载数据，请稍侯……'},
	sm:sm,
	cm: new Ext.grid.ColumnModel([
		sm,
		new Ext.grid.RowNumberer(),//自动行号
		{
			header:'计划ID',
			dataIndex:'PlanId',
			id:'PlanId',
			hidden:true,
			hideable:false
		},
		{
			header:'车间',
			dataIndex:'WorkshopId',
			id:'WorkshopId',
			renderer:function(v){
			   var index = dsWs.findBy(function(record, id) {
                    return record.get('WsId') == v;
               });			    
			   return dsWs.getAt(index).get('WsName');
			}
		},
		{
			header:'生产年份',
			dataIndex:'Year',
			id:'Year',
			renderer:function(v){
			    return v+'年';
			}
		},
		{
			header:'生产月份',
			dataIndex:'Month',
			id:'Month',
			renderer:function(v){
			    return v+'月';
			}
		},
		{
			header:'备注',
			dataIndex:'Remark',
			id:'Remark'
		},
		{
			header:'创建日期',
			dataIndex:'CreateDate',
			id:'CreateDate',
			renderer: Ext.util.Format.dateRenderer('Y年m月d日')
		}
		]),
		bbar: new Ext.PagingToolbar({
			pageSize: 10,
			store: dsPmsPlanData,
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
pmsPlanGrid.render();
/*------DataGrid的函数结束 End---------------*/



})
</script>

</html>
