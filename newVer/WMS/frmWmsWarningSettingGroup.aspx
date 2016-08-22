<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmWmsWarningSettingGroup.aspx.cs" Inherits="WMS_frmWmsWarningSettingGroup" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html>
<head>
<title>仓库预警设置</title><meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<link rel="stylesheet" type="text/css" href="../ext3/resources/css/ext-all.css" />
<script type="text/javascript" src="../ext3/adapter/ext/ext-base.js"></script>
<script type="text/javascript" src="../ext3/ext-all.js"></script>
<script type="text/javascript" src="../js/operateResp.js"></script>
<script type="text/javascript" src="../js/ProductSelect.js"></script><style type="text/css">
.x-grid-tanstype { 
color:red; 
}
</style>
</head>
<body>
<div id='toolbar'></div>
<div id='searchForm'></div>
<div id='dataGrid'></div>

</body>

<%= getComboBoxStore() %>

<script type="text/javascript">
Ext.BLANK_IMAGE_URL = "../ext3/resources/images/default/s.gif";  //作为：让下拉框的三角形下拉图片显示
Ext.onReady(function(){
var saveType;
var dsModeStore = new Ext.data.ArrayStore({
    fields: ['Id', 'Mode'],
    data: [['1','针对子公司设定'],['2','针对地区设定'],['9','针对全省设定']]//['0','针对子公司仓库设定'],暂不支持
});
var dsProductType = new Ext.data.ArrayStore({
    fields: ['Id', 'Type'],
    data: [['0','按照财务商品分类设定'],['1','按照报表商品分类设定']]
});
/*------实现toolbar的函数 start---------------*/
var Toolbar = new Ext.Toolbar({
	renderTo:"toolbar",
	items:[{
		text:"新增",
		icon:"../Theme/1/images/extjs/customer/add16.gif",
		handler:function(){
		    saveType='add';
		    openAddSettingWin();    
		    
		}
		},'-',{
		text:"删除",
		icon:"../Theme/1/images/extjs/customer/delete16.gif",
		handler:function(){
		    deleteSetting();
		}
	}]
});

/*------结束toolbar的函数 end---------------*/


/*------开始ToolBar事件函数 start---------------*//*-----新增Setting实体类窗体函数----*/
function openAddSettingWin() {
    Ext.getCmp("ProductName").setDisabled(false);    
	uploadSettingWindow.show();
	Ext.getCmp("ClassType").setValue(0);  
	Ext.getCmp("WarningMode").setValue(1);
	setProductType(0);
}

/*-----删除Setting实体函数----*/
/*删除信息*/
function deleteSetting()
{
	var sm = gridData.getSelectionModel();
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
				url:'frmWmsWarningSettingGroup.aspx?method=deleteGroupSetting',
				method:'POST',
				params:{
					WarningId:selectData.data.WarningId
				},
				success: function(resp,opts){
					if (checkExtMessage(resp)) {
					    gridData.getStore().remove(selectData);
					}
				},
				failure: function(resp,opts){
					Ext.Msg.alert("提示","数据删除失败");
				}
			});
		}
	});
}
var warnNow ="";
function updateUserGrid(){
    var warningType=warningTypePanel.getValue();
    var ProductName=settingNamePanel.getValue();
    
    dsSetting.baseParams.WarningType = warningType;
    dsSetting.baseParams.ProductName = ProductName;
    dsSetting.baseParams.WarnNow = warnNow;
    
     dsSetting.load({
                params : {
                start : 0,
                limit : defaultPageSize
                } 
        });
}
/*------实现FormPanle的函数 start---------------*/

function showFrom()
{
    if (selectProductForm == null) {
        parentUrl = "../CRM/product/frmBaProductClass.aspx?select=true&method=getbaproducttypetree";
        showProductForm("", "", "", true);
        selectProductForm.buttons[0].on("click", selectProductOk);
    }
    else {
        showProductForm("", "", "", true);
    }
}var selectedProductIds = "";
function selectProductOk() {
    var selectProductNames = "";
    selectedProductIds = "";
    var selectNodes = selectProductTree.getChecked();
    if(selectNodes.length>0){
        if(selectNodes.length>1)
            alert("提醒：您选择了多个品种，系统将只采用第一个品种！");
        Ext.getCmp('ProductId').setValue(selectNodes[0].attributes.id); 
        Ext.getCmp('ProductName').setValue(selectNodes[0].attributes.text);
    }else{
        Ext.getCmp('ProductName').setValue("");
        Ext.getCmp('ProductId').setValue(""); 
    }
}
/*------定义商品下拉框 start ----------*/
var dsProdcutStore ;    
//用于下拉列表的store
if (dsProdcutStore == null) { //防止重复加载
    dsProdcutStore = new Ext.data.JsonStore({ 
    totalProperty : "results", 
    root : "root", 
    url : 'frmWmsWarningSettingGroup.aspx?method=getProductsReport', 
    fields : ['ClassId', 'ClassName'] 
        }); 
    dsProdcutStore.load();	
}
var  dsWarningOrg;
if (dsWarningOrg == null) { //防止重复加载
    dsWarningOrg = new Ext.data.JsonStore({ 
    totalProperty : "results", 
    root : "root", 
    url : 'frmWmsWarningSettingGroup.aspx?method=getSettingOrg', 
    fields : ['OrgId', 'OrgName'] 
        }); 
    dsWarningOrg.load({params:{WarningMode:1}});	
}

var settingForm=new Ext.form.FormPanel({
	url:'',
	//renderTo:'divForm',
	frame:true,
	title:'',
	items:[
		{
			xtype:'textfield',
			fieldLabel:'预警流水',
			columnWidth:1,
			anchor:'90%',
			name:'WarningId',
			id:'WarningId',
			hidden:true,
			hideLabel:true
		}
,		{
			xtype:'combo',
			fieldLabel:'预警方式*',
			columnWidth:1,
			anchor:'90%',
			name:'WarningMode',
			id:'WarningMode',
			store:dsModeStore,
            displayField:'Mode',
            valueField:'Id',
			mode:'local',
			triggerAction:'all',
			editable:false ,
            listeners:{ 
            "select":function(combo, record, index){ 
                dsWarningOrg.load({params:{WarningMode:combo.getValue()}});
                this.collapse();
             }
            }   
		}
,		{
			xtype:'combo',
			fieldLabel:'预警组织*',
			columnWidth:1,
			anchor:'90%',
			name:'WarningOrg',
			id:'WarningOrg',
			store:dsWarningOrg,
			displayField:'OrgName',
			valueField:'OrgId',
			mode:'local',
			triggerAction:'all',
			editable:false
		}
,		{
			xtype:'combo',
			fieldLabel:'预警品种类别*',
			columnWidth:1,
			anchor:'90%',
			name:'ClassType',
			id:'ClassType',
			store:dsProductType,
            displayField:'Type',
            valueField:'Id',
			mode:'local',
			triggerAction:'all',
			editable:false,
            listeners:{ 
            "select":function(combo, record, index){ 
                setProductType(combo.getValue());
                this.collapse();
             }
            }   
		}
,		{
			xtype:'textfield',
			fieldLabel:'类别id',
			columnWidth:1,
			anchor:'90%',
			name:'ProductId',
			id:'ProductId',
			hidden:true,
			hideLabel:true
		}
,		{
			xtype:'textfield',
			fieldLabel:'品种名称*',
			columnWidth:1,
			anchor:'90%',
			name:'ProductName',
			id:'ProductName',
            listeners:{ 
            'render': function(combo) { combo.getEl().on('click', showFrom); }
            }              
		}
,		{
			xtype:'combo',
			fieldLabel:'品种名称*',
			columnWidth:1,
			anchor:'90%',
			name:'ClassName',
			id:'ClassName',
			store:dsProdcutStore,
            typeAhead: true,  
            mode: 'local',      
            emptyText: '请选择商品信息……',   
            selectOnFocus: false,
            editable: true,
            displayField:'ClassName',
            valueField:'ClassId',
            listeners:{ 
            "select":function(combo, record, index){ 
                Ext.getCmp("ProductId").setValue(record.data.ClassId);
                this.collapse();
             }
            }              
		}
,		{
			xtype:'combo',
			fieldLabel:'预警类型*',
			columnWidth:1,
			anchor:'90%',
			name:'WarningType',
			id:'WarningType',
			store:dsWarningType,
			displayField:'DicsName',
			valueField:'DicsCode',
			mode:'local',
			triggerAction:'all',
			editable:false
		}
,		{
			xtype:'numberfield',
			fieldLabel:'预警值*',
			columnWidth:1,
			anchor:'90%',
			name:'WarningValue',
			id:'WarningValue'
		},
        {
            xtype: 'combo',
            store: dsProductUnits, //dsWareHouse,
            valueField: 'UnitId',
            displayField: 'UnitName',
            mode: 'local',
            forceSelection: true,
            editable: false,
            name: 'UnitId',
            id: 'UnitId',
            emptyValue: '',
            triggerAction: 'all',
            fieldLabel: '单位*',
            selectOnFocus: true,
            anchor: '90%'
        }
,		{
			xtype:'textarea',
			fieldLabel:'备注',
			columnWidth:1,
			anchor:'90%',
			name:'Remark',
			id:'Remark'
		}
]
});
function setProductType( type)
{
 if(type==0){
    Ext.getCmp('ClassName').setVisible(false);   
    Ext.getCmp('ClassName').getEl().up('.x-form-item').setDisplayed(false);  
    Ext.getCmp('ProductName').setVisible(true);   
    Ext.getCmp('ProductName').getEl().up('.x-form-item').setDisplayed(true); 
 }
 else{
    Ext.getCmp('ProductName').setVisible(false);   
    Ext.getCmp('ProductName').getEl().up('.x-form-item').setDisplayed(false);  
    Ext.getCmp('ClassName').setVisible(true);   
    Ext.getCmp('ClassName').getEl().up('.x-form-item').setDisplayed(true); 
 }
}
/*------FormPanle的函数结束 End---------------*/
/*------开始界面数据的窗体 Start---------------*/
if(typeof(uploadSettingWindow)=="undefined"){//解决创建2个windows问题
	uploadSettingWindow = new Ext.Window({
		id:'Settingformwindow',
		title:'仓库商品预警设置'
		, iconCls: 'upload-win'
		, width: 600
		, height: 350
		, layout: 'fit'
		, plain: true
		, modal: true
		, constrain:true
		, resizable: false
		, closeAction: 'hide'
		,autoDestroy :true
		,items:settingForm
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
				uploadSettingWindow.hide();
			}
			, scope: this
		}]});
	}
	uploadSettingWindow.addListener("hide",function(){
	settingForm.getForm().reset();
});

var productFilterCombo = null;

/*------开始获取界面数据的函数 start---------------*/
function saveUserData()
{
    if(saveType =='add')
        saveType = 'addSettingGroup';
        
	Ext.Ajax.request({
		url:'frmWmsWarningSettingGroup.aspx?method='+saveType,
		method:'POST',
		params:{
			WarningId:Ext.getCmp('WarningId').getValue(),
			//WhId:Ext.getCmp('WhId').getValue(), 暂不实现仓库
			WarningMode:Ext.getCmp('WarningMode').getValue(),
			WarningOrg:Ext.getCmp('WarningOrg').getValue(),
			ClassType:Ext.getCmp('ClassType').getValue(),
			ProductId:Ext.getCmp('ProductId').getValue(),
			WarningType:Ext.getCmp('WarningType').getValue(),
			WarningValue:Ext.getCmp('WarningValue').getValue(),
			Remark: Ext.getCmp('Remark').getValue(),
			OrgId:<% =ZJSIG.UIProcess.ADM.UIAdmUser.OrgID(this)%>,
			OperId:<% =ZJSIG.UIProcess.ADM.UIAdmUser.EmployeeID(this)%>,
			OwnerId:<% =ZJSIG.UIProcess.ADM.UIAdmUser.EmployeeID(this)%>,
			UnitId:Ext.getCmp('UnitId').getValue()
				},
		success: function(resp,opts){
			if (checkExtMessage(resp)) {
			    dsSetting.reload();
			    uploadSettingWindow.hide();
			}
		},
		failure: function(resp,opts){
			Ext.Msg.alert("提示","保存失败！");
		}
	});
}
/*------结束获取界面数据的函数 End---------------*/

/*------开始查询form的函数 start---------------*/

var warningTypePanel = new Ext.form.ComboBox({
    fieldLabel: '预警类型',
    name: 'settingTypeCombo',
    store: dsWarningType,
    displayField: 'DicsName',
    valueField: 'DicsCode',
    typeAhead: true, //自动将第一个搜索到的选项补全输入
    triggerAction: 'all',
    emptyText: '请选择',
    emptyValue: '',
    selectOnFocus: true,
    forceSelection: true,
    anchor: '98%',
    mode:'local',
    editable:false,
    listeners: { specialkey: function(f, e) { if (e.getKey() == e.ENTER) { 
      //Ext.getCmp('searchebtnId').focus(); 
    } } //
    }

});
var settingNamePanel = new Ext.form.TextField({
        style: 'margin-left:0px',
        cls: 'key',
        xtype: 'textfield',
        fieldLabel: '组织名称',
        name: 'settingNameOrg',
        anchor: '98%'
    });
                    
var serchform = new Ext.FormPanel({
    renderTo: 'searchForm',
    labelAlign: 'left',
    layout: 'fit',
    buttonAlign: 'right',
    bodyStyle: 'padding:5px',
    frame: true,
    labelWidth: 55,
    items: [{
        layout: 'column',   //定义该元素为布局为列布局方式
        border: false,
        items: [{
            columnWidth: .3,  //该列占用的宽度，标识为20％
            layout: 'form',
            border: false,
            items: [
                warningTypePanel
            ]
        }, {
            columnWidth: .3,
            layout: 'form',
            border: false,
            items: [
                settingNamePanel
                ]
        }, {
            columnWidth: .3,
            layout: 'form',
            border: false,
            labelWidth: 70,
            items: [{
                xtype: 'checkbox',
			    anchor: '98%',
			    name: 'ShowActionValue',
			    id: 'ShowActionValue',
			    fieldLabel: '显示实际值',                
			    listeners: {
                    check: function(checkbox, checked) {
                        if (checked) 
                            warnNow="true";
                        else
                            warnNow="";
                        alert(warnNow);alert(checked);
                    }
                }
            }]
        }, {
            columnWidth: .1,
            layout: 'form',
            border: false,
            items: [{ cls: 'key',
                xtype: 'button',
                text: '查询',
                anchor: '50%',
                handler :function(){
                updateUserGrid();
                
                }
            }]
        }]
    }]
});


/*------开始查询form的函数 end---------------*/


/*------开始获取数据的函数 start---------------*/
var dsSetting = new Ext.data.Store
({
url: 'frmWmsWarningSettingGroup.aspx?method=getSettingGroupList',
reader:new Ext.data.JsonReader({
	totalProperty:'totalProperty',
	root:'root'
},[
	{
		name:'WarningId'
	},
	{
		name:'WarningOrg'
	},
	{
		name:'WhId'
	},
	{
		name:'OrgName'
	},
	{
		name:'WhName'
	},
	{
		name:'ProductId'
	},
	{
		name:'ProductName'
	},
	{
		name:'WarningTypetext'
	},
	{
		name:'WarningValue'
	},
	{
		name:'ActualValue'
	},
	{
		name:'UnitId'
	},
	{
		name:'ClassType'
	},
	{
		name:'ClassId'
	},
	{
		name:'Remark'
	}
	])
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
 defaultPageSize = 10;
    var toolBar = new Ext.PagingToolbar({
        pageSize: defaultPageSize,
        store: dsSetting,
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
        updateUserGrid();
    }, toolBar);
var sm= new Ext.grid.CheckboxSelectionModel({
	singleSelect:true
});
var gridData = new Ext.grid.GridPanel({
	el: 'dataGrid',
	width:'100%',
	height:'100%',
	autoWidth:true,
	autoHeight:true,
	autoScroll:true,
	layout: 'fit',
	id: '',
	store: dsSetting,
	loadMask: {msg:'正在加载数据，请稍侯……'},
	sm:sm,
	cm: new Ext.grid.ColumnModel([
		sm,
		new Ext.grid.RowNumberer(),//自动行号
		{
			header:'预警流水',
			dataIndex:'WarningId',
			id:'WarningId',
			hidden:true,
			hideable:false
		},
		{
			header:'组织名称',
			dataIndex:'OrgName',
			id:'OrgName'
		},
		{
			header:'品种名称',
			dataIndex:'ProductName',
			id:'ProductName'
		},
		{
			header:'预警类型',
			dataIndex:'WarningTypetext',
			id:'WarningTypetext'
		},
		{
			header:'预警值',
			dataIndex:'WarningValue',
			id:'WarningValue'
		},
		{
			header:'实际值',
			dataIndex:'ActualValue',
			id:'ActualValue'
		},
		{
			header:'单位',
			dataIndex:'UnitId',
			id:'UnitId',
			renderer: function(value, cellmeta, record, rowIndex, columnIndex, store) {
                var index = dsProductUnits.findBy(function(record, id) {  
	                return record.get("UnitId")==value; 
                });
                var record = dsProductUnits.getAt(index);
                var displayText = "";
                if (record == null) {
                    displayText = value;
                } else {
                    displayText = record.data.UnitName; 
                }
                return displayText;
            }
		},
		{
			header:'备注',
			dataIndex:'Remark',
			id:'Remark'
		}
		]),
		bbar: toolBar,
		viewConfig: {
			columnsText: '显示的列',
			scrollOffset: 20,
			sortAscText: '升序',
			sortDescText: '降序',
			forceFit: true,
			getRowClass: function(r, i, p, s) {
                if (r.data.WarningTypetext.indexOf('缺货') > -1) {
                    if(r.data.WarningValue>=r.data.ActualValue)
                        return "x-grid-tanstype";
                }else if(r.data.WarningTypetext.indexOf('超储') > -1) {
                    if(r.data.WarningValue<r.data.ActualValue)
                        return "x-grid-tanstype";
                }
            }
		},
		height: 280,
		closeAction: 'hide',
		stripeRows: true,
		loadMask: true,
		autoExpandColumn: 2
	});
gridData.render();
/*------DataGrid的函数结束 End---------------*/

//updateUserGrid();

})
</script>

</html>
