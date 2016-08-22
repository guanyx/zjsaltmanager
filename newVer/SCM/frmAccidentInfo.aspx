<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmAccidentInfo.aspx.cs" Inherits="SCM_frmAccidentInfo" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html>
<head>
<title>质量事故登记</title><meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<link rel="stylesheet" type="text/css" href="../ext3/resources/css/ext-all.css" />
<script type="text/javascript" src="../ext3/adapter/ext/ext-base.js"></script>
<script type="text/javascript" src="../ext3/ext-all.js"></script>
<link rel="stylesheet" type="text/css" href="../ext3/example/file-upload.css" />
<script type="text/javascript" src="../ext3/example/FileUploadField.js"></script>
</head>
<body>
<div id='toolbar'></div>
<div id='searchForm'></div>
<div id='dataGrid'></div>
</body>

<%=getComboBoxStore() %>

<script type="text/javascript">
Ext.BLANK_IMAGE_URL = "../ext3/resources/images/default/s.gif"; 
var saveType;
Ext.onReady(function(){
/*------实现toolbar的函数 start---------------*/
var Toolbar = new Ext.Toolbar({
	renderTo:"toolbar",
	items:[{
		text:"新增",
		icon:"../Theme/1/images/extjs/customer/add16.gif",
		handler:function(){
		    saveType='add';
		    openAddInfoWin();
		}
		},'-',{
		text:"编辑",
		icon:"../Theme/1/images/extjs/customer/edit16.gif",
		handler:function(){
		    saveType='add';
		    modifyInfoWin();
		}
		},'-',{
		text:"删除",
		icon:"../Theme/1/images/extjs/customer/delete16.gif",
		handler:function(){
		    deleteInfo();
		}
	}]
});

/*------结束toolbar的函数 end---------------*/


/*------开始ToolBar事件函数 start---------------*//*-----新增Info实体类窗体函数----*/
function openAddInfoWin() {
	uploadInfoWindow.show();
}
/*-----编辑Info实体类窗体函数----*/
function modifyInfoWin() {
	var sm = infoGrid.getSelectionModel();
	//获取选择的数据信息
	var selectData =  sm.getSelected();
	if(selectData == null){
		Ext.Msg.alert("提示","请选中需要编辑的信息！");
		return;
	}
	if(selectData.data.BusiStatusText == '已处理'){
	    Ext.Msg.alert("提示","已处理记录不能再修改！");
	    return;
	}
	uploadInfoWindow.show();
	setFormValue(selectData);
}
/*-----删除Info实体函数----*/
/*删除信息*/
function deleteInfo()
{
	var sm = infoGrid.getSelectionModel();
	//获取选择的数据信息
	var selectData =  sm.getSelected();
	//如果没有选择，就提示需要选择数据信息
	if(selectData == null){
		Ext.Msg.alert("提示","请选中需要删除的信息！");
		return;
	}
	if(selectData.data.BusiStatusText == '已处理'){
	    Ext.Msg.alert("提示","已处理记录不能删除！");
	    return;
	}
	//删除前再次提醒是否真的要删除
	Ext.Msg.confirm("提示信息","是否真的要删除选择的信息吗？",function callBack(id){
		//判断是否删除数据
		if(id=="yes")
		{
		//alert(selectData.data.AccidentId);
			//页面提交
			Ext.Ajax.request({
				url:'frmAccidentInfo.aspx?method=deleteInfo',
				method:'POST',
				params:{
					AccidentId:selectData.data.AccidentId
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
var accidentForm=new Ext.form.FormPanel({
	url:'',
	frame:true,
	title:'',
	fileUpload:true, 
	items:[
		{
		    layout:'form',
            columnWidth:.5,
            labelWidth:55,
            items:[{
			    xtype:'hidden',
			    fieldLabel:'等级序号',
			    name:'AccidentId',
			    id:'AccidentId',
			    hidden:true,
			    hideLabel:true
			}]
		}
,		{
            layout:'form',
            columnWidth:.5,
            labelWidth:55,
            items:[{
			    xtype:'textfield',
			    fieldLabel:'标题',
			    columnWidth:1,
			    anchor:'90%',
			    name:'AccidentName',
			    id:'AccidentName'
		    }]
		}
,		{
            layout:'column',
            items:[{
                layout:'form',
                columnWidth:.45,
                labelWidth:55,
                items:[{
			        xtype:'combo',
			        fieldLabel:'类型',
			        anchor:'90%',
			        name:'AccidentType',
			        id:'AccidentType',
			        hiddenName:'value',
			        store:dsAccidentType,
			        displayField:'DicsName',
			        valueField:'DicsCode',
			        mode:'local',
			        triggerAction:'all',
			        editable:false
		       }]
		   }
		   ,{
		        layout:'form',
                columnWidth:.5,
                items:[{
			        xtype:'textfield',
			        fieldLabel:'关联单据号',
			        columnWidth:1,
			        anchor:'90%',
			        name:'BillNo',
			        id:'BillNo'
		        }]
		    }]
		}
,		{
            layout:'form',
            columnWidth:.5,
            labelWidth:55,
            items:[{
                xtype: 'fileuploadfield',
	            fieldLabel: '附件',
	            emptyText:'请选择附件',
	            anchor: '90%',
	            name: 'Accessories',
	            id: 'Accessories',
	            buttonText: '选择'
	        }]
		}
,		{
            layout:'form',
            columnWidth:.5,
            labelWidth:55,
            items:[{
			    xtype:'textarea',
			    fieldLabel:'备注',
			    columnWidth:1,
			    anchor:'90%',
			    name:'Remark',
			    id:'Remark'
			}]
		}
]
});
/*------FormPanle的函数结束 End---------------*/

/*------开始界面数据的窗体 Start---------------*/
if(typeof(uploadInfoWindow)=="undefined"){//解决创建2个windows问题
	uploadInfoWindow = new Ext.Window({
		id:'Infoformwindow',
		title:'质量事件登记'
		, iconCls: 'upload-win'
		, width: 500
		, height: 250
		, layout: 'fit'
		, plain: true
		, modal: true
		, constrain:true
		, resizable: false
		, closeAction: 'hide'
		,autoDestroy :true
		,items:accidentForm
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
				uploadInfoWindow.hide();
			}
			, scope: this
		}]});
	}
	uploadInfoWindow.addListener("hide",function(){
	    accidentForm.getForm().reset();
});

/*------开始获取界面数据的函数 start---------------*/
function saveUserData()
{
    if(saveType=='add')
        saveType='addInfo';
    else if(saveType == 'save')
        saveType = 'saveInfo';
    //alert(Ext.getCmp('Accessories').getValue());
    accidentForm.getForm().submit({  
            url : 'frmAccidentInfo.aspx?method='+saveType,
            method: 'POST',
            params:{
			    AccidentType:Ext.getCmp('AccidentType').getValue(),
			    Accessories:Ext.getCmp('Accessories').getValue()
            },
            waitMsg: 'Uploading ...',
            success: function(form, action){  
               Ext.Msg.alert("提示", "保存成功");;  
               uploadInfoWindow.hide();    
            },      
           failure: function(){      
              Ext.Msg.alert("提示", "保存失败");    
           }  
     });   
/*
	Ext.Ajax.request({
		url:'frmAccidentInfo.aspx?method='+saveType,
		method:'POST',
		params:{
			AccidentId:Ext.getCmp('AccidentId').getValue(),
			AccidentName:Ext.getCmp('AccidentName').getValue(),
			AccidentType:Ext.getCmp('AccidentType').getValue(),
			Accessories:Ext.getCmp('Accessories').getValue(),
			Remark:Ext.getCmp('Remark').getValue(),
			BillNo:Ext.getCmp('BillNo').getValue()
			},
		success: function(resp,opts){
			Ext.Msg.alert("提示","保存成功");
		},
		failure: function(resp,opts){
			Ext.Msg.alert("提示","保存失败");
		}
		});
		*/
}
/*------结束获取界面数据的函数 End---------------*/

/*------开始界面数据的函数 Start---------------*/
function setFormValue(selectData)
{
	Ext.Ajax.request({
		url:'frmAccidentInfo.aspx?method=getInfo',
		params:{
			AccidentId:selectData.data.AccidentId
		},
	success: function(resp,opts){
		var data=Ext.util.JSON.decode(resp.responseText);
		Ext.getCmp("AccidentId").setValue(data.AccidentId);
		Ext.getCmp("AccidentName").setValue(data.AccidentName);
		Ext.getCmp("AccidentType").setValue(data.AccidentType);
		Ext.getCmp("Accessories").setValue(data.Accessories);
		Ext.getCmp("Remark").setValue(data.Remark);
		Ext.getCmp("BillNo").setValue(data.BillNo);
	},
	failure: function(resp,opts){
		Ext.Msg.alert("提示","获取用户信息失败");
	}
	});
}
/*------结束设置界面数据的函数 End---------------*/

/*------定义客户类型下拉框 start--------*/
var AccidentTypecombo = new Ext.form.ComboBox({
    fieldLabel: '类型',
    name: 'folderaMoveTo',
    store: dsAccidentType,
    displayField: 'DicsName',
    valueField: 'DicsCode',
    mode: 'local',
    editable:false,
    //loadText:'loading ...',
    typeAhead: true, //自动将第一个搜索到的选项补全输入
    triggerAction: 'all',
    selectOnFocus: true,
    forceSelection: true
});

var nameAccidentPanel = new Ext.form.TextField({
    style: 'margin-left:0px',
    cls: 'key',
    xtype: 'textfield',
    fieldLabel: '标题',
    name: 'name',
    anchor: '90%'
});

var serchAccform = new Ext.FormPanel({
    renderTo: 'searchForm',
    labelAlign: 'left',
    layout:'fit',
    buttonAlign: 'right',
    bodyStyle: 'padding:5px',
    frame: true,
    labelWidth: 55,
    items: [{
        layout: 'column',   //定义该元素为布局为列布局方式
        border: false,
        items: [{
            columnWidth: .33,
            layout: 'form',
            border: false,
            items: [
                nameAccidentPanel
                ]
        },{
            columnWidth: .33,
            layout: 'form',
            border: false,
            items: [
                AccidentTypecombo
                ]
        }, {
            columnWidth: .10,
            layout: 'form',
            border: false,
            items: [{ cls: 'key',
                xtype: 'button',
                text: '查询',
                anchor: '50%',
                handler :function(){                
                    var name=nameAccidentPanel.getValue();
                    var type = AccidentTypecombo.getValue();
                    //alert(name +":"+type);
                    infoGridData.baseParams.AccidentName = name;
                    infoGridData.baseParams.AccidentType = type;
                    infoGridData.load({
                        params : {
                        start : 0,
                        limit : 10
                        } 
                      }); 
                    }
                }]
        },{
            columnWidth: .23,  //该列占用的宽度，标识为20％
            layout: 'form',
            border: false
        }]
    }]
});
/*------定义查询form end ----------------*/

/*------开始获取数据的函数 start---------------*/
var infoGridData = new Ext.data.Store
({
url: 'frmAccidentInfo.aspx?method=getInfoList',
reader:new Ext.data.JsonReader({
	totalProperty:'totalProperty',
	root:'root'
},[
	{		name:'AccidentId'	},
	{		name:'AccidentName'	},
	{		name:'AccidentType'	},
	{		name:'Accessories'	},
	{		name:'Remark'	},
	{		name:'OperId'	},
	{		name:'CreateDate'	},
	{		name:'UpdateDate'	},
	{		name:'Auditor'	},
	{		name:'Result'	},
	{		name:'AuditDate'	},
	{		name:'OrgId'	},
	{		name:'OwnerId'	},
	{		name:'Status'	},
	{		name:'BillNo'	},
	{       name:'AccidentTypeText'},
	{       name:'BusiStatusText'}
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
var infoGrid = new Ext.grid.GridPanel({
	el: 'dataGrid',
	width:'100%',
	height:'100%',
	autoWidth:true,
	autoHeight:true,
	autoScroll:true,
	layout: 'fit',
	id: '',
	store: infoGridData,
	loadMask: {msg:'正在加载数据，请稍侯……'},
	sm:sm,
	cm: new Ext.grid.ColumnModel([
		sm,
		new Ext.grid.RowNumberer(),//自动行号
		{
			header:'登记序号',
			dataIndex:'AccidentId',
			id:'AccidentId',
			hidden:true,
			hideable:false
		},
		{
			header:'标题',
			dataIndex:'AccidentName',
			id:'AccidentName'
		},
		{
			header:'类型',
			dataIndex:'AccidentTypeText',
			id:'AccidentTypeText'
		},
		{
		    header:'管理单据号',
			dataIndex:'BillNo',
			id:'BillNo'
		},
		{
		    header:'附件',
			dataIndex:'Accessories',
			id:'Accessories'
		},
		{
		    header:'处理结果',
			dataIndex:'Result',
			id:'Result'
		},
		{
			header:'业务状态:',
			dataIndex:'BusiStatusText',
			id:'BusiStatusText'
		}		]),
		bbar: new Ext.PagingToolbar({
			pageSize: 10,
			store: infoGridData,
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
infoGrid.render();
/*------DataGrid的函数结束 End---------------*/



})
</script>

</html>
