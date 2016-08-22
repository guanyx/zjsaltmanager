<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmScmRebateOrder.aspx.cs" Inherits="SCM_frmScmRebateOrder" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html>
<head>
<title>测试页面</title><meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<link rel="stylesheet" type="text/css" href="../ext3/resources/css/ext-all.css" />
<script type="text/javascript" src="../ext3/adapter/ext/ext-base.js"></script>
<script type="text/javascript" src="../ext3/ext-all.js"></script>
<script type="text/javascript" src="../js/operateResp.js"></script>
<script type="text/javascript" src="../js/floatUtil.js"></script>
<script type="text/javascript" src="../js/ExtJsHelper.js"></script>
<script type="text/javascript" src="../ext3/src/locale/ext-lang-zh_CN.js"></script>
</head>
<body>
<div id='toolbar'></div>
<div id='divSearchForm'></div>
<div id='userGrid'></div>

</body>
<%=getComboBoxStore() %>
<script type="text/javascript">
Ext.BLANK_IMAGE_URL = "../ext3/resources/images/default/s.gif";
var usergridDataData=null;
Ext.onReady(function(){
var saveType="";
/*------实现toolbar的函数 start---------------*/
var Toolbar = new Ext.Toolbar({
	renderTo:"toolbar",
	items:[{
		text:"新增",
		icon:"../Theme/1/images/extjs/customer/add16.gif",
		handler:function(){
		     saveType="Add";
		     openAddOrderWin(); 
		}
		},'-',{
		text:"编辑",
		icon:"../Theme/1/images/extjs/customer/edit16.gif",
		handler:function(){
		     saveType="Update"; 
		     modifyOrderWin();
		}
		},'-',{
		text:"删除",
		icon:"../Theme/1/images/extjs/customer/delete16.gif",
		handler:function(){
		    deleteOrder();
		}
		},'-',{
		text:"审核",
		icon:"../Theme/1/images/extjs/customer/checked.gif",
		handler:function(){
		    confirmOrder();
		}
		},'-',{
		text:"查看",
		icon:"../Theme/1/images/extjs/customer/view16.gif",
		handler:function(){
		    viewOrder();
		}
	}]
});

/*------结束toolbar的函数 end---------------*/


/*------开始ToolBar事件函数 start---------------*//*-----新增Order实体类窗体函数----*/
function openAddOrderWin() {
	uploadOrderWindow.show();
	document.getElementById("editIFrame").src = "frmScmRebateOrderDtl.aspx?OpenType=oper&id=0";
}
function viewOrder(){
    var sm = gridData.getSelectionModel();
	//获取选择的数据信息
	var selectData =  sm.getSelected();
	if(selectData == null){
		Ext.Msg.alert("提示","请选中需要查看的信息！");
		return;
	}	 
    uploadOrderWindow.show();
	document.getElementById("editIFrame").src = "frmScmRebateOrderDtl.aspx?OpenType=query&id=" + selectData.data.RebateId;
}
/*-----编辑Order实体类窗体函数----*/
function modifyOrderWin() {
	var sm = gridData.getSelectionModel();
	//获取选择的数据信息
	var selectData =  sm.getSelected();
	if(selectData == null){
		Ext.Msg.alert("提示","请选中需要编辑的信息！");
		return;
	}	   
    if (selectData.get('BillStatus') == 1)
    {
        Ext.Msg.alert("提示", "已审记录不允许修改！");
        return;
    }
    uploadOrderWindow.show();
    if(document.getElementById("editIFrame").src.indexOf("frmPOSOrderEdit")==-1)
    {                
        document.getElementById("editIFrame").src = "frmScmRebateOrderDtl.aspx?OpenType=oper&id=" + selectData.data.RebateId;
    }
    else{
        document.getElementById("editIFrame").contentWindow.RebateId=selectData.data.RebateId;
        document.getElementById("editIFrame").contentWindow.setFormValues();
    }
	
}
/*-----删除Order实体函数----*/
/*删除信息*/
function deleteOrder()
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
				url:'frmScmRebateOrder.aspx?method=deleteOrder',
				method:'POST',
				params:{
					RebateId:selectData.data.RebateId
				},
				success: function(resp,opts){
					 if( checkExtMessage(resp,parent) )
                                         { usergridDataData.reload(); }
				},
				failure: function(resp,opts){
					Ext.Msg.alert("提示","数据删除失败");
				}
			});
		}
	});
}

/*审核信息*/
function confirmOrder()
{
	var sm = gridData.getSelectionModel();
	//获取选择的数据信息
	var selectData =  sm.getSelected();
	//如果没有选择，就提示需要选择数据信息
	if(selectData == null){
		Ext.Msg.alert("提示","请选中需要审核的信息！");
		return;
	}
	//删除前再次提醒是否真的要删除
	Ext.Msg.confirm("提示信息","是否真的要审核选择的信息吗？",function callBack(id){
		//判断是否删除数据
		if(id=="yes")
		{
		    Ext.MessageBox.wait("数据正在提交，请稍候……");
			//页面提交
			Ext.Ajax.request({
				url:'frmScmRebateOrder.aspx?method=confirmOrder',
				method:'POST',
				params:{
					RebateId:selectData.data.RebateId
				},
				success: function(resp,opts){
				    Ext.MessageBox.hide();
					if( checkExtMessage(resp,parent) )
                        { usergridDataData.reload(); }
				},
				failure: function(resp,opts){
				    Ext.MessageBox.hide();
					Ext.Msg.alert("提示","数据审核失败！");
				}
			});
		}
	});
}  
/*------FormPanle的函数结束 End---------------*/
//仓库
   var ck = new Ext.form.ComboBox({
       xtype: 'combo',
       store: dsWareHouse,
       valueField: 'WhId',
       displayField: 'WhName',
       mode: 'local',
       forceSelection: true,
       //editable: false,
       name:'OutStor',
       id:'OutStor',
       emptyValue: '',
       triggerAction: 'all',
       fieldLabel: '仓库',
       selectOnFocus: true,
       anchor: '90%'//,
	   //editable:false
   });
   //开始日期
   var ksrq = new Ext.form.DateField({
	    xtype:'datefield',
        fieldLabel:'开始日期',
        anchor:'90%',
        name:'StartDate',
        id:'StartDate',
        format: 'Y年m月d日',  //添加中文样式
        value:new Date().clearTime() 
   });
   
   //结束日期
   var jsrq = new Ext.form.DateField({
	    xtype:'datefield',
        fieldLabel:'结束日期',
        anchor:'90%',
        name:'EndDate',
        id:'EndDate',
        format: 'Y年m月d日',  //添加中文样式
        value:new Date().clearTime()
   });
var serchform = new Ext.FormPanel({
        renderTo: 'divSearchForm',
        labelAlign: 'left',
        //layout: 'fit',
        buttonAlign: 'center',
        bodyStyle: 'padding:5px',
        frame: true,
        labelWidth: 55,
        items:[
        {
            layout:'column',
            border: false,
            labelSeparator: '：',
            items: [
    		{
                layout:'form',
                border: false,
                columnWidth:0.5,
                items:[
                {
                    xtype:'textfield',
                    fieldLabel:'客商',
                    anchor:'99%',
                    name:'CustomerId',
                    id:'CustomerId'
                }]
            },
            {
               layout: 'form',
               columnWidth: .05,  //该列占用的宽度，标识为20％
               border: false,
               items: [
               {
                    xtype:'button', 
                    iconCls:"find",
                    autoWidth : true,
                    autoHeight : true,
                    hideLabel:true,
                    listeners:{
                        click:function(v){
                              getCustomerInfo(function(record){Ext.getCmp('CustomerId').setValue(record.data.ShortName); },<%=ZJSIG.UIProcess.ADM.UIAdmUser.OrgID(this) %>);    
                        }
                    }
               }]
            },
            {
                layout:'form',
                border: false,
                columnWidth:0.01,
                html: '&nbsp;'
            },
            {
                layout:'form',
                border: false,
                columnWidth:0.3,
                items: [ck]
            }]
        },
        {
            layout:'column',
            border: false,
            labelSeparator: '：',
            items: [
            {
                layout:'form',
                border: false,
                columnWidth:0.28,
                items: [
                {
	                xtype:'datefield',
	                fieldLabel:'开始日期',
	                columnWidth:0.5,
	                anchor:'90%',
	                name:'StartDate',
	                id:'StartDate',
                    format: 'Y年m月d日',  //添加中文样式
                    value:new Date().getFirstDateOfMonth().clearTime()
                }]
            },		
            {
                layout:'form',
                border: false,
                columnWidth:0.28,
                items: [
                {
	                xtype:'datefield',
	                fieldLabel:'结束日期',
	                columnWidth:0.5,
	                anchor:'90%',
	                name:'EndDate',
	                id:'EndDate',
                    format: 'Y年m月d日',  //添加中文样式
                    value:new Date().clearTime()
                }]
            },	
            {
                layout:'form',
                border: false,
                columnWidth:0.3,
                items: [
                {
	                xtype:'textfield',
	                fieldLabel:'关联单号',
	                columnWidth:0.3,
	                anchor:'90%',
	                name:'FromBillId',
	                id:'FromBillId'
                }]
            },
            {//第三单元格
                layout:'form',
                border: false,
                labelWidth:70,
                columnWidth:0.12,
                items:[
                {
                   xtype:'button',
                    text:'查询',
                    width:70,
                    //iconCls:'excelIcon',
                    scope:this,
                    handler:function(){
                        QueryDataGrid();
                    }
                }]
            }]
        }]    
    });


function QueryDataGrid() {
        usergridDataData.baseParams.OutStor=Ext.getCmp('OutStor').getValue();		                
        usergridDataData.baseParams.CustomerId=Ext.getCmp('CustomerId').getValue();	      
        usergridDataData.baseParams.StartDate=Ext.util.Format.date(Ext.getCmp('StartDate').getValue(),'Y/m/d');
        usergridDataData.baseParams.EndDate=Ext.util.Format.date(Ext.getCmp('EndDate').getValue(),'Y/m/d');
        usergridDataData.load({
            params: {
                start: 0,
                limit: 10
            }
        });
    }


/*------开始界面数据的窗体 Start---------------*/
if(typeof(uploadOrderWindow)=="undefined"){//解决创建2个windows问题
	uploadOrderWindow = new Ext.Window({
		id:'Orderformwindow'
		, iconCls: 'upload-win'
		, width: 700
		, height: 450
		, layout: 'fit'
		, plain: true
		, modal: true
		, x:50
		, y:50
		, constrain:true
		, resizable: false
		, closeAction: 'hide'
		,autoDestroy :true
		, html: '<iframe id="editIFrame" width="100%" height="100%" border=0 src=""></iframe>' 
		});
	}
	uploadOrderWindow.addListener("hide",function(){
});

/*------开始获取数据的函数 start---------------*/
usergridDataData = new Ext.data.Store
({
    url: 'frmScmRebateOrder.aspx?method=getOrderList',
    reader:new Ext.data.JsonReader({
	    totalProperty:'totalProperty',
	    root:'root'
    },[
	    {		name:'RebateId'	},
	    {		name:'CustomerId'	},
	    {		name:'CustomerNo'	},
	    {		name:'CustomerName'	},
	    {		name:'WhId'	},
	    {		name:'CarBoat'	},
	    {		name:'IsCheck'	},
	    {		name:'RebateType'	},
	    {		name:'BusinessType'	},
	    {		name:'FromBillId'	},
	    {		name:'BusinessType'	},
	    {		name:'BillStatus'	},
	    {		name:'IsCertificate'	},
	    {		name:'IsActive'	},
	    {		name:'RebateNumber'	},
	    {		name:'Remark'	},
	    {		name:'OperId'	},
	    {		name:'OperName'	},
	    {		name:'CreateDate'	},
	    {		name:'AuditId'	},
	    {		name:'AuditName'	},
	    {		name:'AuditDate'	},
	    {		name:'WhName'	},
	    {		name:'OrgId'	}	])
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
	el: 'userGrid',
	width:document.body.offsetWidth,
	height:'100%',
	//autoWidth:true,
	//autoHeight:true,
	autoScroll:true,
	layout: 'fit',
	id: '',
	store: usergridDataData,
	loadMask: {msg:'正在加载数据，请稍侯……'},
	sm:sm,
	cm: new Ext.grid.ColumnModel([
		sm,
		new Ext.grid.RowNumberer(),//自动行号
		{
			header:'返利单编号',
			dataIndex:'RebateId',
			id:'RebateId',
			hidden:true,
			hideable:true
		},
		{
			header:'客商id',
			dataIndex:'CustomerId',
			id:'CustomerId',
			hidden:true,
			hideable:true
		},
		{
			header:'客商编号',
			dataIndex:'CustomerNo',
			id:'CustomerNo',
			width:65
		},
		{
			header:'客商名称',
			dataIndex:'CustomerName',
			id:'CustomerName',
			width:150
		},
		{
			header:'仓库名称',
			dataIndex:'WhName',
			id:'WhName',
			width:70
		},
//		{
//			header:'策略类型(现金返利；货物抵扣)',
//			dataIndex:'RebateType',
//			id:'RebateType'
//		},
//		{
//			header:'业务类型(采购返利/销售回扣)',
//			dataIndex:'BusinessType',
//			id:'BusinessType'
//		},
		{
			header:'关联单据号',
			dataIndex:'FromBillId',
			id:'FromBillId',
			width:80
		},
		{
			header:'单据状态',
			dataIndex:'BillStatus',
			id:'BillStatus',
			width:65,
			renderer: function(val, params, record) {
			    if(val ==0) return '初始';
			    else return '审核';
			}
		},
		{
			header:'操作员',
			dataIndex:'OperName',
			id:'OperName',
			width:60
		},
		{
			header:'创建日期',
			dataIndex:'CreateDate',
			id:'CreateDate',
            renderer: Ext.util.Format.dateRenderer('Y年m月d日'),
            width:105
		},
		{
			header:'审核员',
			dataIndex:'AuditName',
			id:'AuditName',
			width:60
		},
		{
			header:'审核日期',
			dataIndex:'AuditDate',
			id:'AuditDate',
            renderer: Ext.util.Format.dateRenderer('Y年m月d日'),
            width:105
		},
		{
			header:'备注',
			dataIndex:'Remark',
			id:'Remark',
			width:100
		}
		]),
		bbar: new Ext.PagingToolbar({
			pageSize: 10,
			store: usergridDataData,
			displayMsg: '显示第{0}条到{1}条记录,共{2}条',
			emptyMsy: '没有记录',
			displayInfo: true
		}),
		viewConfig: {
			columnsText: '显示的列',
			scrollOffset: 20,
			sortAscText: '升序',
			sortDescText: '降序',
			forceFit: false
		},
		height: 280,
		closeAction: 'hide',
		stripeRows: true,
		loadMask: true
	});
gridData.render();
/*------DataGrid的函数结束 End---------------*/
QueryDataGrid();
})
</script>

</html>
<script type="text/javascript" src="../js/SelectModule.js"></script>
