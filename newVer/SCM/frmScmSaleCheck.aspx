<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmScmSaleCheck.aspx.cs"
    Inherits="SCM_frmScmSaleCheck" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>无标题页</title>
        <link rel="stylesheet" type="text/css" href="../ext3/resources/css/ext-all.css" />
<script type="text/javascript" src="../ext3/adapter/ext/ext-base.js"></script>
<script type="text/javascript" src="../ext3/ext-all.js"></script>
<script type="text/javascript" src="../js/operateResp.js"></script>
<script type="text/javascript" src="../js/FilterControl.js"></script>
<script type="text/javascript" src="../js/floatUtil.js"></script>
<script type="text/javascript" src="../js/EmpSelect.js"></script>
<script type="text/javascript" src="../ext3/src/locale/ext-lang-zh_CN.js"></script>

<style type="text/css">  
.line{ BORDER-LEFT-STYLE: none; BORDER-RIGHT-STYLE: none; BORDER-TOP-STYLE: none}
.x-grid-back-blue { 
background: #08F5FE; 
}
</style> 

</head>
<%=getComboBoxSource()%>
<script>

function getCmbStore(columnName)
    {
//        switch(columnName)
//        {
//            case "EmpSex":
//                return EmpSexStore;
//            case "EmpState":
//                return EmpStateStore;
//            case "EmpBz":
//                return EmpBzStore;
//        }
        return null;
    }
Ext.BLANK_IMAGE_URL = "../ext3/resources/images/default/s.gif" ;
Ext.onReady(function() {
var imageUrl = "../Theme/1/";
/*------实现toolbar的函数 start---------------*/
    var Toolbar = new Ext.Toolbar({
        renderTo: "toolbar",
        region: "north",
        height: 25,
        items: [{
            text: "核销",
            icon: imageUrl + "images/extjs/customer/add16.gif",
            handler: function() {
                checkOrders();
                addSelectedRows();
                checkForm.show();
                //radioGroup.setValue('2');
            }
        }]
        });
       

function checkOrders()
{
    Ext.getCmp("CheckOrg").setValue(orgName);
    Ext.getCmp("CustomerName").setValue("");
    Ext.getCmp("CustomerPhone").setValue("");
    Ext.getCmp("BillNo").setValue("");
    Ext.getCmp("BillDate").setValue("");
    Ext.getCmp("BillOper").setValue("");
    Ext.getCmp("ReceiverId").setValue("");
    Ext.getCmp("CheckOper").setValue("");
    Ext.getCmp("CheckMemo").setValue("");
    checkDtlGridData.removeAll();
}
//允许多选
var sm= new Ext.grid.CheckboxSelectionModel({
	singleSelect:false
});

var colModel = new Ext.grid.ColumnModel({
	columns: [
		new Ext.grid.RowNumberer(),sm,
		    {header:'客户名称',
            dataIndex:'ChineseName',
            id:'ChineseName',
            tooltip:'客户名称',width:180},
		            {header:'产品名称',
            dataIndex:'ProductName',
            id:'ProductName',
            tooltip:'产品名称',width:160},
		            {header:'产品编号',
            dataIndex:'ProductNo',
            id:'ProductNo',
            tooltip:'产品编号',width:60},
		            {header:'单位',
            dataIndex:'UnitName',
            id:'UnitName',
            tooltip:'单位',width:40},
		            {header:'销售数量',
            dataIndex:'SaleQty',
            id:'SaleQty',
            tooltip:'销售数量',width:60},
		            {header:'已核数量',
            dataIndex:'CheckNum',
            id:'CheckNum',
            tooltip:'已核数量',width:60},
		            {header:'销售价格',
            dataIndex:'SalePrice',
            id:'SalePrice',
            tooltip:'销售价格',width:60},
		            {header:'订单日期',
            dataIndex:'CreateDate',
            id:'CreateDate',
            renderer: Ext.util.Format.dateRenderer('Y年m月d日'),
            tooltip:'订单日期',width:110},
		            {header:'销售总额',
            dataIndex:'SaleAmt',
            id:'SaleAmt',
            tooltip:'销售总额',width:60},
		            {header:'销售税金',
            dataIndex:'SaleTax',
            id:'SaleTax',
            tooltip:'销售税金',width:60},
		            {header:'是否核销',
            dataIndex:'SaleIscheck',
            id:'SaleIscheck',
            tooltip:'是否核销',width:40,
            renderer:function(v){
                if(v==0) return '否';
                if(v==1) return '是';
            }},
		            {header:'订单状态',
            dataIndex:'Status',
            id:'Status',
            tooltip:'订单状态',
            renderer:function(v){
                if(v==1) return '初始';
                if(v==2) return '已审核';
                if(v==3) return '已生成领货单';
            },width:80}	]});
defaultPageSize = 18;
var gridStore = new Ext.data.Store({
url: 'frmScmSaleCheck.aspx?method=getnochecklist',
 reader :new Ext.data.JsonReader({
totalProperty: 'totalProperty',
root: 'root',
fields: [
    {name:'OrderDtlId'},
	{name:'ChineseName',type:'string'},
	{name:'ProductName',type:'string'},
	{name:'ProductNo',type:'string'},
	{name:'UnitName',type:'string'},
	{name:'SaleQty',type:'float'},
	{name:'CheckNum',type:'float'},
	{name:'SalePrice',type:'float'},
	{name:'CreateDate',type:'date'},
	{name:'SaleAmt',type:'float'},
	{name:'SaleTax',type:'float'},
	{name:'SaleIscheck',type:'string'},
	{name:'Status',type:'string'}	]})
});


//合计项
var viewGrid = new Ext.grid.GridPanel({
                renderTo:"gird",                
                id: 'viewGrid',
                split:true,
                store: gridStore ,
                autoscroll:true,
                clicksToEdit:1,
                loadMask: { msg: '正在加载数据，请稍侯……' },
                sm: sm,
                cm:colModel,
                bbar: new Ext.PagingToolbar({
                pageSize: 18,
                store: gridStore,
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
                stripeRows: true,
                height:450,
                width:document.body.offsetWidth,
                title:'需要核销的订单'                
            });
    viewGrid.render();
    
createSearch(viewGrid,viewGrid.getStore(),"searchForm");
//setControlVisibleByField();
searchForm.el="searchForm";
searchForm.render();
/******************DtlGrid*****************************/

var checkDtlGridData = new Ext.data.Store
({
reader:new Ext.data.JsonReader({
	totalProperty:'totalProperty',
	root:'root'
},[
	{
		name:'SaleCheckId'
	},
	{
		name:'ObjectId'
	},
	{
		name:'CheckNum'
	},
	{
		name:'CheckPrice'
	},
	{
		name:'CheckAmt'
	},
	{
		name:'CheckOther'
	},
	{
		name:'CheckTax'
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

function getSaleQty(value, cellmeta, record, rowIndex, columnIndex, store)
{
    var index = gridStore.find('OrderDtlId', record.data.ObjectId);
    if (index < 0)
        return "";
    var record = gridStore.getAt(index);
    return record.data.SaleQty;
            
}

function getUnitName(value, cellmeta, record, rowIndex, columnIndex, store)
{
    var index = gridStore.find('OrderDtlId', record.data.ObjectId);
    if (index < 0)
        return "";
    var record = gridStore.getAt(index);
    return record.data.UnitName;
            
}

function getProductName(value, cellmeta, record, rowIndex, columnIndex, store)
{
    var index = gridStore.find('OrderDtlId', record.data.ObjectId);
    if (index < 0)
        return "";
    var record = gridStore.getAt(index);
    return record.data.ProductName;
            
}

function getCheckAmt(value, cellmeta, record, rowIndex, columnIndex, store)
{
    //record.data.CheckAmt=accMul(record.data.CheckNum,record.data.CheckPrice);
}

function addSelectedRows()
{
    var sm1 = Ext.getCmp('viewGrid').getSelectionModel();
                //获取选择的数据信息
    var selectData = sm1.getSelections();
    var ids="";
    Ext.getCmp('CustomerName').setValue(selectData[0].data.ChineseName);
    for(var i=0;i<selectData.length;i++)
    {
        var rowCount = checkDtlGrid.getStore().getCount();
        var insertPos = parseInt(rowCount);
        var addRow = new headPattern({
            SaleCheckId:-(1+rowCount),
            ObjectId: selectData[i].data.OrderDtlId,
            CheckNum: selectData[i].data.SaleQty,
            CheckPrice: selectData[i].data.SalePrice,
            CheckAmt: accMul(selectData[i].data.SaleQty,selectData[i].data.SalePrice),
            CheckOther:'0',
            CheckTax:selectData[i].data.SaleTax
        });
        checkDtlGrid.stopEditing();
        if (insertPos > 0) {
            var rowIndex = checkDtlGrid.getStore().insert(insertPos, addRow);
            checkDtlGrid.startEditing(insertPos, 0);
        }
        else {
            var rowIndex = checkDtlGrid.getStore().insert(0, addRow);
            // planDtlGrid.startEditing(0, 0);
        }
    }
    var height = 100;
    if(selectData.length>5)
    {
        
        height=selectData.length * 25;
    }
    if(height>200)
        height=200;
    checkDtlGrid.setHeight(height);
}
var headPattern = Ext.data.Record.create([
   {name:'SaleCheckId'},
   {name:'ObjectId'},
   {name:'CheckNum'},
	{name:'CheckPrice'},
	{name:'CheckAmt'},
	{name:'CheckOther'},
	{name:'CheckTax'}
          ]);


/*------开始DataGrid的函数 start---------------*/

var sm= new Ext.grid.CheckboxSelectionModel({
	singleSelect:true
});
var checkDtlGrid = new Ext.grid.EditorGridPanel({
	width:'100%',
	height:150,
	autoWidth:true,
	//autoHeight:true,
	autoScroll:true,
	layout: 'fit',
	id: 'checkDtlGrid',
	store: checkDtlGridData,
	loadMask: {msg:'正在加载数据，请稍侯……'},
	sm:sm,
	cm: new Ext.grid.ColumnModel([
		sm,
		new Ext.grid.RowNumberer(),//自动行号
		{
			header:'商品名称',
			dataIndex:'ProductName',
			width:150,
			id:'ProductName',
			renderer:getProductName
		},
		{
			header:'单位',
			dataIndex:'UnitName',
			width:60,
			id:'UnitName',
			renderer:getUnitName
		},
		{
			header:'订单数量',
			dataIndex:'OrderQty',
			width:80,
			id:'OrderQty',
			renderer:getSaleQty
		},
		{
			header:'核销数量',
			dataIndex:'CheckNum',
			width:80,
			id:'CheckNum',
			editor: new Ext.form.TextField({ listeners: { 'focus': function() { this.selectText(); } } }),
			renderer: function(v, m) {
                m.css = 'x-grid-back-blue';
                return v;
            }
		},
		{
			header:'含税单价',
			dataIndex:'CheckPrice',
			width:80,
			id:'CheckPrice'
		},
		{
			header:'商品金额',
			dataIndex:'CheckAmt',
			width:80,
			id:'CheckAmt',
			render:getCheckAmt
		},
		{
			header:'客户运费',
			dataIndex:'CheckOther',
			width:80,
			id:'CheckOther'
		},
		{
			header:'税额',
			dataIndex:'CheckTax',
			width:80,
			id:'CheckTax'
		}		]),
		
		viewConfig: {
			columnsText: '显示的列',
			scrollOffset: 20,
			sortAscText: '升序',
			sortDescText: '降序',
			forceFit: true
		},
		closeAction: 'hide',
		stripeRows: true,
		loadMask: true,
		autoExpandColumn: 2,
		listeners:{
		    afteredit: function(e){ 
 
                            //自动计算
                            var record = e.record;//获取被修改的行数据
                                record.set('CheckAmt', accMul(record.data.CheckNum , record.data.CheckPrice));
                                //record.set('SaleTax', accMul(record.get('SaleAmt') ,0.17) ); //Math.Round(3.445, 1); 
                        }
                   }
	});
	

	var radioGroup=new Ext.form.RadioGroup({   
        fieldLabel : "类型", 
        width:125,  
        items : [   
                new Ext.form.Radio({   
                            name : "lType",   
                            inputValue : "1",   
                            boxLabel :'<span style="color:blue">蓝字 </span>',
                            checked:true,
                            listeners : {   
                                //check : radiochange   
                            }   
                        }),   
                new Ext.form.Radio({   
                            name : "lType",   
                            inputValue : "2",   
                            boxLabel : '<span style="color:#FF0000">红字 </span>',   
                            listeners : {   
                                //check : radiochange   
                            }   
                        })]});
                        
    var stateGroup=new Ext.form.RadioGroup({   
        fieldLabel : "状态",   
        width:125,  
        items : [   
                new Ext.form.Radio({   
                            name : "StateType",   
                            inputValue : "1",   
                            boxLabel :'<span style="color:green">正常 </span>',
                            checked:true,
                            listeners : {   
                                //check : radiochange   
                            }   
                        }),   
                new Ext.form.Radio({   
                            name : "StateType",   
                            inputValue : "2",   
                            boxLabel : '<span style="color:#FF0000">暂估 </span>',   
                            listeners : {   
                                //check : radiochange   
                            }   
                        })]});
    var checkForm1 = new Ext.Panel(   
         { 
           frame:true,
           border:false, 
           //renderTo:renderTo,
           layout:'table',          
           width:500,   
           height:250,   
           layoutConfig:{columns:8},//将父容器分成3列   
           items:[
                {items:{html:"采购单位",width:50}},
                {items:
                    {xtype:'textfield',
			        fieldLabel:'采购单位',
			        anchor:'95%',
			        cls:"line",
			        name:'CustomerName',
			        id:'CustomerName'}
			    },
			    {items:{html:"联系电话",width:50}},
			    {items:
			        {
			            xtype:'textfield',
			            fieldLabel:'单位电话',
			            anchor:'95%',
			            cls:"line",
			            name:'CustomerPhone',
			            id:'CustomerPhone'
			         }
			    }
			    ,//{items:{html:"核销单位",width:50}},
			    {colspan:2,items:
			        {
			            xtype:'hidden',
			            fieldLabel:'核销单位',
			            anchor:'95%',
			            cls:"line",
			            name:'CheckOrg',
			            id:'CheckOrg',
			            hideLabel:true
			         }
			    },//{items:{html:"电话",width:50}},
			    {colspan:2,items:
			        {
			            xtype:'hidden',
			            fieldLabel:'单位电话',
			            cls:"line",
			            anchor:'95%',
			            name:'OrgPhone',
			            id:'OrgPhone',
			            hideLabel:true
			         }
			    } 
			    ,{colspan:8,items:{html:'',height:10}},
			    {items:{html:"发票编号",width:50}},
			    {items:
			        {
			            xtype:'textfield',
			            name:'BillNo',
			            cls:"line",
			            id:'BillNo'
			         }
			    }
			    ,{items:{html:"开票日期",width:50}},
			    {items:
			        {
			            xtype:'datefield',
			            name:'BillDate',
			            id:'BillDate',
			            format: "Y-m-d"
			            
			         }
			    },{colspan:2,items:radioGroup},
			    {colspan:2,items:stateGroup},
			    
			    {colspan:8,items:{html:'',height:10}},
			    {colspan:8,items:checkDtlGrid},
			    {colspan:8,items:{html:'',height:10}}
			    ,{items:{html:"开票人",width:50}},
			    {items:[
			        {
			            xtype:'textfield',
			            name:'BillOper',
			            cls:"line",
			            id:'BillOper',
			            hidden:true
			         },
			         {
			            xtype:'textfield',
			            name:'BillOperName',
			            cls:"line",
			            id:'BillOperName'
			            
			         }]
			    }  
			    ,{items:{html:"收款人",width:50}},
			    {colspan:2,items:[
			        {
			            xtype:'textfield',
			            name:'ReceiverId',
			            cls:"line",
			            id:'ReceiverId',
			            hidden:true
			            
			         },{
			            xtype:'textfield',
			            name:'ReceiverName',
			            cls:"line",
			            id:'ReceiverName'
			            
			         }]
			    }  
			    ,{items:{html:"复核人",width:50}},
			    {colspan:2,items:[
			        {
			            xtype:'textfield',
			            name:'CheckOper',
			            cls:"line",
			            id:'CheckOper',
			            hidden:true			            
			         },{
			            xtype:'textfield',
			            name:'CheckOperName',
			            cls:"line",
			            id:'CheckOperName'		            
			         }]
			    }
			    ,{colspan:8,items:{html:'',height:10}},
			    {items:{html:"备注",width:50}},
			    {colspan:7,items:
			        {
			            xtype:'textarea',
			            name:'CheckMemo',
			            id:'CheckMemo',
			            width:'100%',
			            height:40
			            
			         }
			    }                   
           ]   
          }   
         );
         
         var checkForm = new Ext.Window(   
         { 
           iconCls: 'upload-win'
		    , layout: 'fit'
		    , plain: true
		    , modal: true
		    , x: 50
		    , y: 50
		    , constrain: true
		    , resizable: false
		    , closeAction: 'hide'
		    , autoDestroy: true,         
           width:650,   
           height:350,
           items:checkForm1,
           buttons: [{
		    text: "保存"
			, handler: function() {
			   saveCheck();
			}
			, scope: this
		},
		{
		    text: "取消"
			, handler: function() {
			    checkForm.hide();
			}
			, scope: this
}]
           });

Ext.getCmp("BillOperName").on("focus",selectEmp);
Ext.getCmp("ReceiverName").on("focus",selectEmp);
Ext.getCmp("CheckOperName").on("focus",selectEmp);
var current="";
function selectEmp(v)
{
    current = v.id;
    if(selectEmpForm==null)
    {
        showEmpForm(0,'员工选择','../ba/sysadmin/frmAdmAuthorize.aspx?method=gettreecolumnlist');
        selectEmpTree.on('checkchange', treeCheckChange, selectEmpTree);
        Ext.getCmp("btnOk").on("click",selectOK);        
    }
    else
    {
        showEmpForm(0,'员工选择','../ba/sysadmin/frmAdmAuthorize.aspx?method=gettreecolumnlist');
    }
}

function treeCheckChange(node,checked)
    {
        selectEmpTree.un('checkchange', treeCheckChange, selectEmpTree);
        if(checked)
        {
            var selectNodes = selectEmpTree.getChecked();
            for (var i = 0; i < selectNodes.length; i++) {
                if(selectNodes[i].id !=node.id)
                {
                    selectNodes[i].ui.toggleCheck(false);
                    selectNodes[i].attributes.checked = false;
                }
            }
        }
        selectEmpTree.on('checkchange', treeCheckChange, selectEmpTree);
    }

function selectOK()
{
    var selectNodes = selectEmpTree.getChecked();
    if(selectNodes.length>0)
    {
        switch(current)
        {
            case"ReceiverName":
                Ext.getCmp("ReceiverName").setValue(selectNodes[0].text);
                Ext.getCmp("ReceiverId").setValue(selectNodes[0].id);
                break;
            case"CheckOperName":
                Ext.getCmp("CheckOperName").setValue(selectNodes[0].text);
                Ext.getCmp("CheckOper").setValue(selectNodes[0].id);
                break;
            case"BillOperName":
                Ext.getCmp("BillOperName").setValue(selectNodes[0].text);
                Ext.getCmp("BillOper").setValue(selectNodes[0].id);
                break;
        }
        
    }
}

	
function saveCheck()
{    
     /*------开始获取界面数据的函数 start---------------*/
    Ext.MessageBox.wait('正在保存数据中, 请稍候……');
    var json='';
    checkDtlGridData.each(function(checkDtlGridData) {
                    json += Ext.util.JSON.encode(checkDtlGridData.data) + ',';
                });
                
    var checkType = radioGroup.getValue();
    if(checkType!=null)
    {
        checkType = checkType.inputValue;
    }        
    Ext.Ajax.request({
        url: 'frmScmSaleCheck.aspx?method=save',
        method: 'POST',
        params: {
            CheckOrg: Ext.getCmp('CheckOrg').getValue(),
            CustomerName: Ext.getCmp('CustomerName').getValue(),
            CustomerPhone: Ext.getCmp('CustomerPhone').getValue(),
            BillNo: Ext.getCmp('BillNo').getValue(),
            BillDate: Ext.getCmp('BillDate').getValue(),
            Receiver: Ext.getCmp('ReceiverId').getValue(),
            CheckOper: Ext.getCmp('CheckOper').getValue(),
            CheckMemo: Ext.getCmp('CheckMemo').getValue(),
            BillOper: Ext.getCmp("BillOper").getValue(),
            CheckType:checkType,
            detail:json
        },
        success: function(resp, opts) {
            Ext.MessageBox.hide();
            if(checkExtMessage(resp))
            {
                checkForm.hide();
                gridStore.reload();
            }
        },
        failure: function(resp, opts) {
            Ext.MessageBox.hide();
            Ext.Msg.alert("提示", "保存失败");
        }
    });
}
})
</script>

<body>
    <form id="form1" runat="server">
    <div id="toolbar"></div>
    <div id="searchForm"></div>
    <div id="gird"></div>
    </form>
</body>
</html>
