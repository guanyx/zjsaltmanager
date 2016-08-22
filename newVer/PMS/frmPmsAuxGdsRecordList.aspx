<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmPmsAuxGdsRecordList.aspx.cs" Inherits="PMS_frmPmsAuxGdsRecord" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html>
<head>
<title>车间剩料管理</title><meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<link rel="stylesheet" type="text/css" href="../ext3/resources/css/ext-all.css" />
<script type="text/javascript" src="../ext3/adapter/ext/ext-base.js"></script>
<script type="text/javascript" src="../ext3/ext-all.js"></script>
<script type="text/javascript" src="../ext3/src/locale/ext-lang-zh_CN.js"></script>
</head>

<body>
<div id='toolbar'></div>
<div id='divForm'></div>
<div id='dataGrid'></div>
<%=getComboBoxStore() %>
</body>
<script type="text/javascript">
Ext.onReady(function(){
var saveType;
Ext.BLANK_IMAGE_URL = "../ext3/resources/images/default/s.gif";
/*------实现toolbar的函数 start---------------*/
var Toolbar = new Ext.Toolbar({
	renderTo:"toolbar",
	items:[{
		text:"新增",
		icon:"../Theme/1/images/extjs/customer/add16.gif",
		handler:function(){
		    saveType="addRecord";
		    openAddRecordWin();
		}
		},'-',{
		text:"编辑",
		icon:"../Theme/1/images/extjs/customer/edit16.gif",
		handler:function(){
		    saveType = "saveRecord";
		    modifyRecordWin();
		}
		},'-',{
		text:"删除",
		icon:"../Theme/1/images/extjs/customer/delete16.gif",
		handler:function(){
		    deleteRecord();
		}
	}]
});

/*------结束toolbar的函数 end---------------*/


/*------开始ToolBar事件函数 start---------------*//*-----新增Record实体类窗体函数----*/
function openAddRecordWin() {
	uploadRecordWindow.show();
}
/*-----编辑Record实体类窗体函数----*/
function modifyRecordWin() {
	var sm = pmsauxgdsrecordGrid.getSelectionModel();
	//获取选择的数据信息
	var selectData =  sm.getSelected();
	if(selectData == null){
		Ext.Msg.alert("提示","请选中需要编辑的信息！");
		return;
	}
	uploadRecordWindow.show();
	setFormValue(selectData);
}
/*-----删除Record实体函数----*/
/*删除信息*/
function deleteRecord()
{
	var sm = pmsauxgdsrecordGrid.getSelectionModel();
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
				url:'frmPmsAuxGdsRecordList.aspx?method=deleteRecord',
				method:'POST',
				params:{
					Id:selectData.data.Id
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
var pmsAuxGdsForm=new Ext.form.FormPanel({
	url:'',
	frame:true,
	title:'',
	labelWidth:55,
	items:[
		{
			xtype:'hidden',
			name:'Id',
			id:'Id',
			hidden:true,
			hideLabel:false
		}
,		{
			xtype:'combo',
			fieldLabel:'车间',
			columnWidth:1,
			anchor:'95%',
			name:'WsId',
			id:'WsId',
		    store:dsWs,
		    displayField:'WsName',
		    valueField:'WsId',
		    mode:'local',
		    triggerAction:'all',
		    editable: true
		}
,		{
			xtype:'combo',
			fieldLabel:'生产原料',
			columnWidth:1,
			anchor:'95%',
			name:'AuxProductId',
			id:'AuxProductId',
            store: dsProductList,
            displayField: 'ProductName',
            valueField: 'ProductId',
            triggerAction: 'all',
            typeAhead: true,
            mode: 'local',
            emptyText: '',
            selectOnFocus: false,
            editable: true
		}
,		{
            layout:'column',
            items:[
            {
                layout:'form',
                columnWidth:.475,
                items:[
                {
                    xtype:'combo',
			        fieldLabel:'登记类型',			
			        anchor:'95%',
			        name:'Type',
			        id:'Type',
			        store:[[0,'剩料登记'],[1,'剩料领用']],
			        mode:'local',
			        triggerAction:'all',
			        editable:false
                }
                ]
            },
            {
                layout:'form',
                columnWidth:.475,
                items:[
                {
                    xtype:'numberfield',
			        fieldLabel:'数量',
			        columnWidth:.5,
			        anchor:'95%',
			        name:'Qty',
			        id:'Qty'
                }
                ]
            }
            ]			
		}
,		{
			xtype:'datefield',
			fieldLabel:'操作时间',
			columnWidth:1,
			anchor:'95%',
			name:'InTime',
			id:'InTime',
			format:'Y年m月d日 H:i:s',
			value:new Date()
		}
,		{
			xtype:'textfield',
			fieldLabel:'原始单号',
			columnWidth:1,
			anchor:'95%',
			name:'OrigNo',
			id:'OrigNo'
		}
,		{
			xtype:'textarea',
			fieldLabel:'备注',
			columnWidth:1,
			anchor:'95%',
			name:'Remark',
			id:'Remark'
		}
]
});
/*------FormPanle的函数结束 End---------------*/

/*------开始界面数据的窗体 Start---------------*/
if(typeof(uploadRecordWindow)=="undefined"){//解决创建2个windows问题
	uploadRecordWindow = new Ext.Window({
		id:'Recordformwindow',
		title:''
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
		,items:pmsAuxGdsForm
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
				uploadRecordWindow.hide();
			}
			, scope: this
		}]});
	}
	uploadRecordWindow.addListener("hide",function(){
	    pmsAuxGdsForm.getForm().reset();
	    pmsauxgdsrecordGrid.getStore().reload();
});

/*------开始获取界面数据的函数 start---------------*/
function saveUserData()
{

	Ext.Ajax.request({
		url:'frmPmsAuxGdsRecordList.aspx?method='+saveType,
		method:'POST',
		params:{
			Id:Ext.getCmp('Id').getValue(),
			WsId:Ext.getCmp('WsId').getValue(),
			AuxProductId:Ext.getCmp('AuxProductId').getValue(),
			Type:Ext.getCmp('Type').getValue(),
			Qty:Ext.getCmp('Qty').getValue(),
			InTime:Ext.util.Format.date(Ext.getCmp('InTime').getValue(),'Y/m/d H:i:s'),
			OrigNo:Ext.getCmp('OrigNo').getValue(),
			Remark:Ext.getCmp('Remark').getValue()
			},
		success: function(resp,opts){
			Ext.Msg.alert("提示","保存成功");
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
		url:'frmPmsAuxGdsRecordList.aspx?method=getrecord',
		params:{
			Id:selectData.data.Id
		},
	success: function(resp,opts){
		var data=Ext.util.JSON.decode(resp.responseText);
		Ext.getCmp("Id").setValue(data.Id);
		Ext.getCmp("WsId").setValue(data.WsId);
		Ext.getCmp("AuxProductId").setValue(data.AuxProductId);
		Ext.getCmp("Type").setValue(data.Type);
		Ext.getCmp("Qty").setValue(data.Qty);
		Ext.getCmp("InTime").setValue((new Date(data.InTime.replace(/-/g,"/"))));
		Ext.getCmp("OrigNo").setValue(data.OrigNo);
		Ext.getCmp("Remark").setValue(data.Remark);
	},
	failure: function(resp,opts){
		Ext.Msg.alert("提示","获取用户信息失败");
	}
	});
}
/*------结束设置界面数据的函数 End---------------*/
/*------开始查询form end---------------*/
//车间名称
var auxWsNamePanel = new Ext.form.ComboBox({
    xtype:'combo',
    fieldLabel:'车间',
    anchor:'95%',
	store:dsWs,
	displayField:'WsName',
    valueField:'WsId',
    mode:'local',
    triggerAction:'all',
    editable: false
});

//原始单据编号
var auxiniOrderIdPanel = new Ext.form.TextField({
    xtype:'textfield',
    fieldLabel:'原始单据编号',
    anchor:'95%'
});
//开始时间
var auxksrq = new Ext.form.DateField({
    xtype:'datefield',
    fieldLabel:'开始时间',
    anchor:'95%',
    format: 'Y年m月d日 H:i:s',  //添加中文样式
    value:new Date() 
});

//结束时间
var auxjsrq = new Ext.form.DateField({
    xtype:'datefield',
    fieldLabel:'结束时间',
    anchor:'95%',
    format: 'Y年m月d日 H:i:s',  //添加中文样式
    value:new Date()
});

var serchform = new Ext.FormPanel({
    el:'divForm',
    id:'serchform',
    labelAlign: 'left',
    buttonAlign: 'right',
    bodyStyle: 'padding:5px',
    frame: true,    
    items: [{
        layout: 'column',   //定义该元素为布局为列布局方式
        border: false,
        items: [{
            columnWidth: .4,  //该列占用的宽度，标识为20％
            layout: 'form',
            border: false,
            labelWidth: 55,
            items: [
                auxWsNamePanel
            ]
        }, {
            columnWidth: .4,
            layout: 'form',
            border: false,
            labelWidth: 80,
            items: [
                auxiniOrderIdPanel
                ]
        }]
    },
    {
        layout: 'column',   //定义该元素为布局为列布局方式
        border: false,
        items: [{
            name: 'cusStyle',
            columnWidth: .4,
            layout: 'form',
            border: false,
            labelWidth: 55,
            items: [
                auxksrq
            ]
        },{
            name: 'cusStyle',
            columnWidth: .4,
            layout: 'form',
            border: false,
            labelWidth: 80,
            items: [
                auxjsrq
            ]
        }, {            
            layout: 'form',
            columnWidth: .2,
            border: false,
            items: [{ cls: 'key',
                xtype: 'button',
                text: '查询',
                anchor: '50%',
                handler :function(){
                
                var strWsId=auxWsNamePanel.getValue();
                var striniOrderId=auxiniOrderIdPanel.getValue();
                var strStartTime=auxksrq.getValue();
                var strEndTime=auxjsrq.getValue();
                
                dspmsauxgdsrecord.baseParams.WorkshopId=strWsId;
                dspmsauxgdsrecord.baseParams.IniOrderId=striniOrderId;
                dspmsauxgdsrecord.baseParams.StartTime=Ext.util.Format.date(strStartTime,'Y/m/d');
                dspmsauxgdsrecord.baseParams.EndTime=Ext.util.Format.date(strEndTime,'Y/m/d H:i:s');
                
                dspmsauxgdsrecord.load({
                            params : {
                            start : 0,
                            limit : 10
                            } });
                }
            }]
        }]
    }]
});
serchform.render();
/*------开始查询form end---------------*/
/*------开始获取数据的函数 start---------------*/
var dspmsauxgdsrecord = new Ext.data.Store
({
url: 'frmPmsAuxGdsRecordList.aspx?method=getrecordList',
reader:new Ext.data.JsonReader({
	totalProperty:'totalProperty',
	root:'root'
},[
	{		name:'Id'	},
	{		name:'WsId'	},
	{		name:'AuxProductId'	},
	{		name:'Type'	},
	{		name:'Qty'	},
	{		name:'InTime'	},
	{		name:'OrigNo'	},
	{		name:'Remark'	},
	{		name:'OrgId'	},
	{		name:'OperId'	},
	{		name:'OwnerId'	},
	{		name:'CreateDate'
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
var pmsauxgdsrecordGrid = new Ext.grid.GridPanel({
	el: 'dataGrid',
	width:'100%',
	height:'100%',
	autoWidth:true,
	autoHeight:true,
	autoScroll:true,
	layout: 'fit',
	id: '',
	store: dspmsauxgdsrecord,
	loadMask: {msg:'正在加载数据，请稍侯……'},
	sm:sm,
	cm: new Ext.grid.ColumnModel([
		sm,
		new Ext.grid.RowNumberer(),//自动行号
		{
			header:'ID',
			dataIndex:'Id',
			id:'Id',
			hidden:true,
			hideable:false
		},
		{
			header:'车间',
			dataIndex:'WsId',
			id:'WsId',
			renderer:function(val){
			    dsWs.each(function(r) {
		            if (val == r.data['WsId']) {
		                val = r.data['WsName'];
		                return;
		            }
		        });
		        return val;
			}
		},
		{
			header:'生产原料',
			dataIndex:'AuxProductId',
			id:'AuxProductId'
		},
		{
			header:'入库类型',
			dataIndex:'Type',
			id:'Type',
			renderer:function(v){
			    if(v==1)
			        return '剩料登记';
			    else
			        return '剩料领用';
			}
		},
		{
			header:'数量',
			dataIndex:'Qty',
			id:'Qty'
		},
		{
			header:'原始单号',
			dataIndex:'OrigNo',
			id:'OrigNo'
		},
		{
			header:'登记日期',
			dataIndex:'InTime',
			id:'InTime',
			renderer: Ext.util.Format.dateRenderer('Y年m月d日')
		}
		]),
		bbar: new Ext.PagingToolbar({
			pageSize: 10,
			store: dspmsauxgdsrecord,
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
pmsauxgdsrecordGrid.render();
/*------DataGrid的函数结束 End---------------*/



})
</script>
</html>
