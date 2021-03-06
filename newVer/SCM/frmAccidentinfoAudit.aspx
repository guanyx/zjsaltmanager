<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmAccidentinfoAudit.aspx.cs" Inherits="SCM_frmAccidentinfoAudit" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html>
<head>
<title>质量事故审核</title><meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<link rel="stylesheet" type="text/css" href="../ext3/resources/css/ext-all.css" />
<script type="text/javascript" src="../ext3/adapter/ext/ext-base.js"></script>
<script type="text/javascript" src="../ext3/ext-all.js"></script>
</head>
<body>
<div id='toolbar'></div>
<div id='searchForm'></div>
<div id='dataGrid'></div>

</body>
<%=getComboBoxStore() %>
<script type="text/javascript">
Ext.BLANK_IMAGE_URL = "../ext3/resources/images/default/s.gif"; 
Ext.onReady(function(){
/*------实现toolbar的函数 start---------------*/
var Toolbar = new Ext.Toolbar({
	renderTo:"toolbar",
	items:[{
		text:"查看并审核",
		icon:"../Theme/1/images/extjs/customer/add16.gif",
		handler:function(){
		    ViewInfoWin();
		}
		/*
		},'-',{
		text:"批量审核",
		icon:"../Theme/1/images/extjs/customer/delete16.gif",
		handler:function(){
		    AuditInfo();
		}*/
	}]
});

/*------结束toolbar的函数 end---------------*/


/*------开始ToolBar事件函数 start---------------*//*-----新增Info实体类窗体函数----*/
/*-----编辑Info实体类窗体函数----*/
function ViewInfoWin() {
	var sm = AuditGrid.getSelectionModel();
	//获取选择的数据信息
	var selectData =  sm.getSelected();
	if(selectData == null){
		Ext.Msg.alert("提示","请选中需要编辑的信息！");
		return;
	}
	uploadAuditInfoWindow.show();
	Ext.getCmp('AccidentType').setDisabled(true);
	setFormValue(selectData);
}
/*-----审核Info实体函数----*/
/*审核信息*/
function AuditInfo()
{
	var sm = AuditGrid.getSelectionModel();
	//获取选择的数据信息
	var selectData =  sm.getSelected();
	//如果没有选择，就提示需要选择数据信息
	if(selectData == null){
		Ext.Msg.alert("提示","请选中需要审核的信息！");
		return;
	}

	//页面提交
	Ext.Ajax.request({
		url:'frmAccidentinfoAudit.aspx?method=AuditMoreInfo',
		method:'POST',
		params:{
			AccidentId:selectData.data.AccidentId
		},
		success: function(resp,opts){
			Ext.Msg.alert("提示","数据审核成功");
		},
		failure: function(resp,opts){
			Ext.Msg.alert("提示","数据审核失败");
		}
	});
}

/*------实现FormPanle的函数 start---------------*/
var auditAccForm=new Ext.form.FormPanel({
url:'',
	frame:true,
	title:'',
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
			    id:'AccidentName',
			    readOnly:true
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
			        id:'BillNo',
			        readOnly:true
		        }]
		    }]
		}
,		{
            layout:'column',
            labelWidth:55,
            items:[{
                layout:'form',
                columnWidth:.8,
                labelWidth:55,
                items:[{
                    xtype: 'textfield',
	                fieldLabel: '附件',
	                anchor: '98%',
	                name: 'Accessories',
	                id: 'Accessories',
			        readOnly:true
			     }]
	        },
	        {
	            layout:'form',
                columnWidth:.2,
                labelWidth:55,
                items:[{
                    xtype: 'button',
	                text: '查看附件',
	                handler:function(){
	                    var annme = Ext.getCmp('Accessories').getValue();
	                    if(annme == "")
	                        return;	                        
	                    //else download file
	                    window.open("frmAccidentinfoAudit.aspx?method=getAccessories&fileName="+annme,"");
	                    
	                }	
	            }]            
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
			    id:'Remark',
			    readOnly:true
			}]
		}
,		{
            layout:'form',
            columnWidth:.5,
            labelWidth:55,
            items:[{
			    xtype:'textarea',
			    fieldLabel:'处理结果',
			    columnWidth:1,
			    anchor:'90%',
			    name:'Result',
			    id:'Result'
			}]
		}
]
});

/*------FormPanle的函数结束 End---------------*/

/*------开始界面数据的窗体 Start---------------*/
if(typeof(uploadAuditInfoWindow)=="undefined"){//解决创建2个windows问题
	uploadAuditInfoWindow = new Ext.Window({
		id:'Infoformwindow',
		title:'质量事件审核'
		, iconCls: 'upload-win'
		, width: 500
		, height: 300
		, layout: 'fit'
		, plain: true
		, modal: true
		, constrain:true
		, resizable: false
		, closeAction: 'hide'
		,autoDestroy :true
		,items:auditAccForm
		,buttons: [{
			text: "确定"
			, handler: function() {
				saveAuditData();
			}
			, scope: this
		},
		{
			text: "取消"
			, handler: function() { 
				uploadAuditInfoWindow.hide();
			}
			, scope: this
		}]});
	}
	uploadAuditInfoWindow.addListener("hide",function(){
	    auditAccForm.getForm().reset();
});

/*------开始获取界面数据的函数 start---------------*/
function saveAuditData()
{
	Ext.Ajax.request({
		url:'frmAccidentinfoAudit.aspx?method=AuditInfo',
		method:'POST',
		params:{
			AccidentId:Ext.getCmp('AccidentId').getValue(),
			Result:Ext.getCmp('Result').getValue()
			},
		success: function(resp,opts){
			Ext.Msg.alert("提示","审核成功");
		},
		failure: function(resp,opts){
			Ext.Msg.alert("提示","审核失败");
		}
		});
		}
/*------结束获取界面数据的函数 End---------------*/

/*------开始界面数据的函数 Start---------------*/
function setFormValue(selectData)
{
	Ext.Ajax.request({
		url:'frmAccidentinfoAudit.aspx?method=getInfo',
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
		Ext.getCmp("Result").setValue(data.Result);
		Ext.getCmp("BillNo").setValue(data.BillNo);
	},
	failure: function(resp,opts){
		Ext.Msg.alert("提示","获取用户信息失败");
	}
	});
}
/*------结束设置界面数据的函数 End---------------*/
/*------定义客户类型下拉框 start--------*/
var AccidentTypeAuditcombo = new Ext.form.ComboBox({
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

var nameAccidentAuditPanel = new Ext.form.TextField({
    style: 'margin-left:0px',
    cls: 'key',
    xtype: 'textfield',
    fieldLabel: '标题',
    name: 'name',
    anchor: '90%'
});
var serchAccAduitform = new Ext.FormPanel({
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
                nameAccidentAuditPanel
                ]
        },{
            columnWidth: .33,
            layout: 'form',
            border: false,
            items: [
                AccidentTypeAuditcombo
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
                    var name=nameAccidentAuditPanel.getValue();
                    var type = AccidentTypeAuditcombo.getValue();
                    //alert(name +":"+type);
                    AuditGridData.baseParams.AccidentName = name;
                    AuditGridData.baseParams.AccidentType = type;
                    AuditGridData.load({
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
var AuditGridData = new Ext.data.Store
({
url: 'frmAccidentinfoAudit.aspx?method=getInfoList',
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
	{		name:'BillNo'	},
	{		name:'BusiStatus'	},
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
var AuditGrid = new Ext.grid.GridPanel({
	el: 'dataGrid',
	width:'100%',
	height:'100%',
	autoWidth:true,
	autoHeight:true,
	autoScroll:true,
	layout: 'fit',
	id: '',
	store: AuditGridData,
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
			store: AuditGridData,
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
AuditGrid.render();
/*------DataGrid的函数结束 End---------------*/



})
</script>

</html>
