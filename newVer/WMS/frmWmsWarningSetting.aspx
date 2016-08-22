<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmWmsWarningSetting.aspx.cs" Inherits="WMS_frmWmsWarningSetting" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html>
<head>
<title>仓库预警设置</title><meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<link rel="stylesheet" type="text/css" href="../ext3/resources/css/ext-all.css" />
<script type="text/javascript" src="../ext3/adapter/ext/ext-base.js"></script>
<script type="text/javascript" src="../ext3/ext-all.js"></script>
<script type="text/javascript" src="../js/operateResp.js"></script>
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
/*------实现toolbar的函数 start---------------*/
var Toolbar = new Ext.Toolbar({
	renderTo:"toolbar",
	items:[{
		text:"新增",
		icon:"../Theme/1/images/extjs/customer/add16.gif",
		handler:function(){
		    saveType='add';
		    openAddSettingWin();
		    if(productFilterCombo==null)
		        {
		            productFilterCombo = new Ext.form.ComboBox({
                    store: dsProducts,
                    displayField: 'ProductName',
                    displayValue: 'ProductId',
                    typeAhead: false,
                    minChars: 1,
                    id: 'productFilterCombo',
                    loadingText: 'Searching...',
                    //tpl: resultTpl,  
                    pageSize: 10,
                    hideTrigger: true,
                    applyTo: 'ProductName',
                    onSelect: function(record) { // override default onSelect to do redirect                 
                        Ext.getCmp('ProductName').setValue(record.data.ProductName);
                        Ext.getCmp('ProductId').setValue(record.data.ProductId);
                        beforeEdit();                        
                        this.collapse();
                    }
            });
            productFilterCombo.on("blur",changeProduct);
		        }
		    
		}
		},'-',{
		text:"编辑",
		icon:"../Theme/1/images/extjs/customer/edit16.gif",
		handler:function(){
		    saveType = 'save';
		    modifySettingWin();
		    if(productFilterCombo==null)
		        {
		            productFilterCombo = new Ext.form.ComboBox({
                    store: dsProducts,
                    displayField: 'ProductName',
                    displayValue: 'ProductId',
                    typeAhead: false,
                    minChars: 1,
                    id: 'productFilterCombo',
                    loadingText: 'Searching...',
                    //tpl: resultTpl,  
                    pageSize: 10,
                    hideTrigger: true,
                    applyTo: 'ProductName',
                    onSelect: function(record) { // override default onSelect to do redirect                 
                        Ext.getCmp('ProductName').setValue(record.data.ProductName);
                        Ext.getCmp('ProductId').setValue(record.data.ProductId);
                           
                        this.collapse();
                    }
            });
            productFilterCombo.on("blur",changeProduct);
		        }
		    
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
    Ext.getCmp("WhId").setDisabled(false);
	uploadSettingWindow.show();
}
/*-----编辑Setting实体类窗体函数----*/
function modifySettingWin() {
	var sm = gridData.getSelectionModel();
	//获取选择的数据信息
	var selectData =  sm.getSelected();
	if(selectData == null){
		Ext.Msg.alert("提示","请选中需要编辑的信息！");
		return;
	}
	Ext.getCmp("ProductName").setDisabled(true);
	Ext.getCmp("WhId").setDisabled(true);
	uploadSettingWindow.show();
	setFormValue(selectData);
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
				url:'frmWmsWarningSetting.aspx?method=deleteSetting',
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
function updateUserGrid(){
    var WhId=settingWhNamePanel.getValue();
    var ProductName=settinNamePanel.getValue();
    
    dsSetting.baseParams.WhId = WhId;
    dsSetting.baseParams.ProductName = ProductName;
    
     dsSetting.load({
                params : {
                start : 0,
                limit : 10
                } 
        });
}
/*------实现FormPanle的函数 start---------------*/

//定义产品下拉框异步调用方法
            var dsProducts;
            if (dsProducts == null) {
                dsProducts = new Ext.data.Store({
                    url: 'frmWmsWarningSetting.aspx?method=getProducts',
                    reader: new Ext.data.JsonReader({
                        root: 'root',
                        totalProperty: 'totalProperty'
                    }, [
                            { name: 'ProductId', mapping: 'ProductId' },
                            { name: 'ProductNo', mapping: 'ProductNo' },
                            { name: 'ProductName', mapping: 'ProductName' },
                            { name: 'Unit', mapping: 'Unit' },
                            { name: 'Supplier', mapping: 'Supplier' },
                            { name: 'SalePriceLower', mapping: 'SalePriceLower' },
                            { name: 'SalePriceLimit', mapping: 'SalePriceLimit' },
                            { name: 'UnitText', mapping: 'UnitText' },
                            { name: 'Specifications', mapping: 'Specifications' },
                            { name: 'SpecificationsText', mapping: 'SpecificationsText' }
                        ])
                });
            }
            

        //定义下拉框异步调用方法,当前客户可订商品列表
        var dsProductUnits = new Ext.data.Store({
            url: 'frmWmsWarningSetting.aspx?method=getProductUnits',
            params: {
                ProductId: 0
            },
            reader: new Ext.data.JsonReader({
                root: 'root',
                totalProperty: 'totalProperty',
                id: 'ProductUnits'
            }, [
                { name: 'UnitId', mapping: 'UnitId' },
                { name: 'UnitName', mapping: 'UnitName' }
            ]),
            listeners: {
                load: function() {
                    var combo = Ext.getCmp('UnitId');
                    combo.setValue(combo.getValue());
                }
            }
        });
        dsProductUnits.load();
        function beforeEdit() {
            var productId = Ext.getCmp('ProductId').getValue();
            if (productId != dsProductUnits.baseParams.ProductId) {
                dsProductUnits.baseParams.ProductId = productId;
                dsProductUnits.load();
            }
        }
        
/*------定义商品下拉框 start ----------*/
//var dsProdcutStore ;    
//    //用于下拉列表的store
//    if (dsProdcutStore == null) { //防止重复加载
//        dsProdcutStore = new Ext.data.JsonStore({ 
//        totalProperty : "results", 
//        root : "root", 
//        url : 'frmWmsWarningSetting.aspx?method=getProducts', 
//        fields : ['ProductId', 'ProductName'] 
//            }); 
//       // dsProdcutStore.load();	
//    }
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
			fieldLabel:'仓库',
			columnWidth:1,
			anchor:'90%',
			name:'WhId',
			id:'WhId',
			store:dsWh,
			displayField:'WhName',
			valueField:'WhId',
			mode:'local',
			triggerAction:'all',
			editable:false
		}
,		{
			xtype:'textfield',
			fieldLabel:'商品id',
			columnWidth:1,
			anchor:'90%',
			name:'ProductId',
			id:'ProductId',
			hidden:true,
			hideLabel:true
		}
,		{
			xtype:'textfield',
			fieldLabel:'商品',
			columnWidth:1,
			anchor:'90%',
			name:'ProductName',
			id:'ProductName'
//			store:dsProdcutStore,
//			pageSize: 5,  
//            minChars: 0,  
//            hideTrigger: true,  
//            typeAhead: true,  
//            mode: 'remote',      
//            emptyText: '请选择商品信息……',   
//            selectOnFocus: false,
//            editable: true,
//            displayField:'ProductName',
//            valueField:'ProductId'
//            listeners:{ 
//            "select":function(combo, record, index){ 
//                Ext.getCmp("ProductId").setValue(record.data.ProductId);
//                this.collapse();
//             }
//            }              
		}
,		{
			xtype:'combo',
			fieldLabel:'预警类别',
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
			fieldLabel:'预警值',
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
            fieldLabel: '单位',
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
/*------FormPanle的函数结束 End---------------*/

function changeProduct()
{
    var productId = Ext.getCmp("ProductId").getValue();
    var index = dsProducts.find('ProductId', productId);
    if (index < 0)
     {
        Ext.getCmp("ProductName").setValue("");
        Ext.getCmp("ProductId").setValue("");                      
        
     }     
                   
}
/*------开始界面数据的窗体 Start---------------*/
if(typeof(uploadSettingWindow)=="undefined"){//解决创建2个windows问题
	uploadSettingWindow = new Ext.Window({
		id:'Settingformwindow',
		title:'仓库商品预警设置'
		, iconCls: 'upload-win'
		, width: 600
		, height: 300
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
        saveType = 'addSetting';
    else if(saveType =='save')
        saveType = 'saveSetting';
        
	Ext.Ajax.request({
		url:'frmWmsWarningSetting.aspx?method='+saveType,
		method:'POST',
		params:{
			WarningId:Ext.getCmp('WarningId').getValue(),
			WhId:Ext.getCmp('WhId').getValue(),
			ProductId:Ext.getCmp('ProductId').getValue(),
			WarningType:Ext.getCmp('WarningType').getValue(),
			WarningValue:Ext.getCmp('WarningValue').getValue(),
			Remark: Ext.getCmp('Remark').getValue(),
			OrgId:<% =ZJSIG.UIProcess.ADM.UIAdmUser.OrgID(this)%>,
			OperId:<% =ZJSIG.UIProcess.ADM.UIAdmUser.EmployeeID(this)%>,
			OwnerId:<% =ZJSIG.UIProcess.ADM.UIAdmUser.EmployeeID(this)%>,
			UnitId:Ext.getCmp('UnitId').getValue(),
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

/*------开始界面数据的函数 Start---------------*/
function setFormValue(selectData)
{    
	Ext.Ajax.request({
		url:'frmWmsWarningSetting.aspx?method=getSetting',
		params:{
			WarningId:selectData.data.WarningId
		},
	success: function(resp,opts){
		var data=Ext.util.JSON.decode(resp.responseText);
		Ext.getCmp("WarningId").setValue(data.WarningId);
		Ext.getCmp("WhId").setValue(data.WhId);
		Ext.getCmp("ProductId").setValue(data.ProductId);
		Ext.getCmp("ProductName").setValue(data.ProductName);
		Ext.getCmp("WarningType").setValue(data.WarningType);
		Ext.getCmp("WarningValue").setValue(data.WarningValue);
		Ext.getCmp("Remark").setValue(data.Remark);
		beforeEdit();  
		Ext.getCmp("UnitId").setValue(data.UnitId);
	},
	failure: function(resp,opts){
		Ext.Msg.alert("提示","获取仓库预警信息失败！");
	}
	});
}
/*------结束设置界面数据的函数 End---------------*/


/*------开始查询form的函数 start---------------*/

var settingWhNamePanel = new Ext.form.ComboBox({
    fieldLabel: '仓库名称',
    name: 'settingwarehouseCombo',
    store: dsWh,
    displayField: 'WhName',
    valueField: 'WhId',
    typeAhead: true, //自动将第一个搜索到的选项补全输入
    triggerAction: 'all',
    emptyText: '请选择仓库',
    emptyValue: '',
    selectOnFocus: true,
    forceSelection: true,
    anchor: '90%',
    mode:'local',
    editable:false,
    listeners: { specialkey: function(f, e) { if (e.getKey() == e.ENTER) { 
      //Ext.getCmp('searchebtnId').focus(); 
    } } //
    }

});
var settinNamePanel = new Ext.form.TextField({
        style: 'margin-left:0px',
        cls: 'key',
        xtype: 'textfield',
        fieldLabel: '产品名称',
        name: 'settinNameProduct',
        anchor: '90%'
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
            columnWidth: .4,  //该列占用的宽度，标识为20％
            layout: 'form',
            border: false,
            items: [
                settingWhNamePanel
            ]
        }, {
            columnWidth: .4,
            layout: 'form',
            border: false,
            items: [
                settinNamePanel
                ]
        }, {
            columnWidth: .2,
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
url: 'frmWmsWarningSetting.aspx?method=getSettingList',
reader:new Ext.data.JsonReader({
	totalProperty:'totalProperty',
	root:'root'
},[
	{
		name:'WarningId'
	},
	{
		name:'WhId'
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
			header:'仓库',
			dataIndex:'WhName',
			id:'WhId'
		},
		{
			header:'商品',
			dataIndex:'ProductName',
			id:'ProductName'
		},
		{
			header:'预警类别',
			dataIndex:'WarningTypetext',
			id:'WarningTypetext'
		},
		{
			header:'预警值',
			dataIndex:'WarningValue',
			id:'WarningValue'
		},
		{
			header:'备注',
			dataIndex:'Remark',
			id:'Remark'
		}
		]),
		bbar: new Ext.PagingToolbar({
			pageSize: 10,
			store: dsSetting,
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
gridData.render();
/*------DataGrid的函数结束 End---------------*/

updateUserGrid();

})
</script>

</html>
