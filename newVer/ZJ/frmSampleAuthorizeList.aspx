<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmSampleAuthorizeList.aspx.cs" Inherits="ZJ_frmSampleAuthorizeList" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>委托检测管理</title>
        <meta http-equiv="Content-Type" content="text/html; charset=GB2312">
    <link rel="stylesheet" type="text/css" href="../ext3/resources/css/ext-all.css" />
    <link rel="Stylesheet" type="text/css" href="../css/columnLock.css" />
    <style type="text/css">
.label-class{
                color: red;                
            }
.label-bord-class
{
	background-color:Lime;
}
</style>
	<script type="text/javascript" src="../ext3/adapter/ext/ext-base.js"></script>	
	<script type="text/javascript" src="../ext3/ext-all.js"></script>
	<script type="text/javascript" src="../js/columnLock.js"></script>
	<script type="text/javascript" src="../js/operateResp.js"></script>
	<script type="text/javascript" src="../js/FilterControl.js"></script>
	<%=getComboBoxStore() %>
</head>
<body>
<div id='toolbar'></div>
<div id='searchForm12'></div>
<div id='authorizeGridDiv'></div>
</body>

<script type="text/javascript">

           Ext.BLANK_IMAGE_URL = "../ext3/resources/images/default/s.gif"; 
           Ext.onReady(function() {
               var Toolbar = new Ext.Toolbar({
	renderTo:"toolbar",
	items:[{
		text:"新增",
		icon:"../Theme/1/images/extjs/customer/add16.gif",
		handler:function(){
		        openAddAuthorizeWin();
		    }
		},'-',{
		text:"修改",
		icon:"../Theme/1/images/extjs/customer/edit16.gif",
		handler:function(){
		        modifyAuthorizeWin();
		    }
		},'-',{
		text:"删除",
		icon:"../Theme/1/images/extjs/customer/delete16.gif",
		handler:function(){
		        deleteAuthorize();
		    }
	},'-',{
		text:"送检",
		icon:"../Theme/1/images/extjs/customer/submit.gif",
		handler:function(){
		        sendToCheck();
		    }
	},'-',{
		text:"取消送检",
		icon:"../Theme/1/images/extjs/customer/s_delete.gif",
		handler:function(){
		        cancleSend();
		    }
	},'-',{
		text:"查看",
		icon:"../Theme/1/images/extjs/customer/view16.gif",
		handler:function(){
		        modifyAuthorizeWin();
		    }
	},{
                       text: "检测",
                       icon: '../Theme/1/images/extjs/customer/spellcheck.png',
                       handler: function() {
                           var optionData = authorizeGrid.getSelectionModel().getCount();
                           if (optionData == 0) {
                               Ext.Msg.alert("提示", "请选中要质检的记录！");
                               return;
                           }
                           if (optionData > 1) {
                               Ext.Msg.alert("提示", "一次只能质检一条记录！");
                               return;
                           }
                           var record = authorizeGrid.getSelectionModel().getSelections()[0].data;
//                           if (record.Status != 0 && record.Status != '0') {
//                               Ext.Msg.alert("提示", "该记录已经进行过质检！");
//                               return;

//                           }
                           modify_quota_id = record.AuthorizeId;
                           modify_pname = record.ProductName;
                           top.createDiv(record.ProductName+"质检","/ZJ/frmQtCheckInput.aspx?FromBillType=Q1404&FromBillId="+modify_quota_id);
//                           formulaWindow.show();
//                           setformvalue(record);
//                           decodeArr(record.CheckId, record.ProductNo, record.CheckType);

                       }},'-']
});

setToolBarVisible(Toolbar);

/*------开始获取数据的函数 start---------------*/
var authorizeData = new Ext.data.Store
({
url: 'frmSampleAuthorizeList.aspx?method=getlist&status='+status,
reader:new Ext.data.JsonReader({
	totalProperty:'totalProperty',
	root:'root'
},[
	{name:'AuthorizeId'},
	{name:'ProductId'},
	{name:'ProductName'},
	{name:'CheckOrgName'},
	{name:'ProductSpec'},
	{name:'ProductLevel'},
	{name:'ProductSupplierName'},
	{name:'ProductSupplierId'},
	{name:'ProductBrand'},
	{name:'ProductProduceDate'},
	{name:'ProductProduceEnddate'},
	{name:'SaltName'},
	{name:'LevelName'},
	{name:'SampleNo'},
	{name:'SampleOpper'},
	{name:'SampleMethod'},
	{name:'SampleAddr'},
	{name:'SampleQty'},
	{name:'SampleRepresentQty'},
	{name:'SampleType'},
	{name:'CheckOrgId'},
	{name:'AuthorizeStatus'},
	{name:'AuthorizeStatusName'},
	{name:'OrgId'},
	{name:'OrgName'},
	{name:'OperId'},
	{name:'CreateDate'},
	{name:'UpdateOper'},
	{name:'UpdateDate'}]),
	listeners:
	{
		scope:this,
		load:function(){
		}
	}
});

/*------获取数据的函数 结束 End---------------*/

/*------开始DataGrid的函数 start---------------*/

var defaultPageSize = 10;
        var toolBar = new Ext.PagingToolbar({
            pageSize: 10,
            store: authorizeData,
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
            toolBar.doLoad(0);
        }, toolBar);
        
var sm= new Ext.grid.CheckboxSelectionModel({
	singleSelect:true,width:20
});
var authorizeGrid =new Ext.ux.grid.LockingEditorGridPanel({
            el: 'authorizeGridDiv',
            width: '100%',
            height: '100%',
            //autoWidth:true,
            //autoHeight:true,
            autoScroll: true,
            layout: 'fit',
            id: 'authorizeGrid',
            store: authorizeData,
            loadMask: { msg: '正在加载数据，请稍侯……' },
            sm: sm,
            columns: [
		sm,
		new Ext.grid.RowNumberer({locked:true,width:20}),
		{header:'委托ID',width:10,dataIndex:'AuthorizeId',id:'AuthorizeId',hidden:true},
		{header:'产品ID',width:10,dataIndex:'ProductId',	id:'ProductId',hidden:true},
		{header:'产品名称',width:150,dataIndex:'ProductName',id:'ProductName',locked:true},
		{header:'规格',width:80,dataIndex:'ProductSpec',id:'ProductSpec',locked:true},
		{header:'型号',width:60,dataIndex:'SaltName',id:'SaltName'},
		{header:'包装等级',width:60,dataIndex:'LevelName',id:'LevelName'},
		{header:'生产厂商',width:100,dataIndex:'ProductSupplierName',id:'ProductSupplierName'},
		{header:'品牌',width:80,	dataIndex:'ProductBrand',id:'ProductBrand'},
		{header:'生产日期',	width:80,dataIndex:'ProductProduceDate',	id:'ProductProduceDate', renderer: Ext.util.Format.dateRenderer('Y年m月d日')},
//		{header:'生产日期1',width:80,dataIndex:'ProductProduceEnddate',id:'ProductProduceEnddate'},
		{header:'样品编号',width:60,dataIndex:'SampleNo',id:'SampleNo'},
		{header:'抽样人',width:80,dataIndex:'SampleOpper',id:'SampleOpper'},
		{header:'抽样方法',	width:80,dataIndex:'SampleMethod',id:'SampleMethod'},
		{header:'抽样地址',	width:80,dataIndex:'SampleAddr',	id:'SampleAddr'	},
		{header:'样品数量',	width:80,dataIndex:'SampleQty',id:'SampleQty'},
		{header:'代表量(t)',width:80,dataIndex:'SampleRepresentQty',	id:'SampleRepresentQty'	},
		{header:'样品类别',width:80,	dataIndex:'SampleType',	id:'SampleType'	},
		{header:'检测机构',	width:80,dataIndex:'CheckOrgName',	id:'CheckOrgName'	},
		{header:'委托状态',width:60,	dataIndex:'AuthorizeStatusName',id:'AuthorizeStatusName'}],
		bbar: toolBar,
            viewConfig: {
                columnsText: '显示的列',
                scrollOffset: 20,
                sortAscText: '升序',
                sortDescText: '降序',
                forceFit: false
            },
            height: 300,
            closeAction: 'hide',
            stripeRows: true,
            loadMask: true//,
            //autoExpandColumn: 2
        });
authorizeGrid.render();

createSearch(authorizeGrid, authorizeData, "searchForm12");
searchForm.el = "searchForm12";
searchForm.render();

        this.getSelectedValue = function() {
            return "";
        }
/*------DataGrid的函数结束 End---------------*/
if (typeof (qtAuthorizeWindow) == "undefined") {//解决创建2个windows问题
                       var qtAuthorizeWindow = new Ext.Window({
                           title: '新增指标模板',
                           modal: 'true',
                           autoWidth: true,
                           y:50,
                           autoHeight: true,
                           collapsible: true, //是否可以折叠 
                           closable: true, //是否可以关闭 
                           //maximizable : true,//是否可以最大化 
                           closeAction: 'hide',
                           constrain: true,
                           resizable: false,
                           plain: true,
                           // ,items: addQuotaForm
                           buttons: [{
                               text: '保存',
                               handler: function() {
                                qtAuthorizeWindow.hide();
                               }
                           }, {
                               text: '关闭',
                               handler: function() {
                                   qtAuthorizeWindow.hide();
                               }
}]
                           });
                       }
/*Form *******************************************************************/
 /*------开始界面数据的窗体 Start---------------*/
if (typeof (uploadAuthorizeWindow) == "undefined") {//解决创建2个windows问题
    uploadAuthorizeWindow = new Ext.Window({
        id: 'Authorizeformwindow',
        iconCls: 'upload-win'
        , width: 668
        , height: 380
        , plain: true
        , modal: true
        , constrain: true
        , resizable: false
        , closeAction: 'hide'
        , autoDestroy: true
        , html: '<iframe id="editIFrame" width="100%" height="100%" border=0 src=""></iframe>' 
        
    });
}
uploadAuthorizeWindow.addListener("hide", function() {
   //document.getElementById("editIFrame").src = "frmOrderDtl.aspx?OpenType=oper&id=0";//清楚其内容，建议在子页面提供一个方法来调用
});

function openAddAuthorizeWin() {

    uploadAuthorizeWindow.show();
    if(document.getElementById("editIFrame").src.indexOf("frmSampleAuthorizeInput")==-1)
    {                
        document.getElementById("editIFrame").src = "frmSampleAuthorizeInput.aspx?OpenType=oper&id=0" ;
    }
    else{
        document.getElementById("editIFrame").contentWindow.AuthorizeId=0;
        document.getElementById("editIFrame").contentWindow.fromBillType="";
        document.getElementById("editIFrame").contentWindow.setAuthorizeFormValue();
        document.getElementById("editIFrame").contentWindow.OpenType='oper';
    }
}

/*-----编辑Order实体类窗体函数----*/
            function modifyAuthorizeWin() {
                var sm = authorizeGrid.getSelectionModel();
                //多选
                var selectData = sm.getSelections();                
                var array = new Array(selectData.length);
                var status = 1;
                for(var i=0;i<selectData.length;i++)
                {
                    array[i] = selectData[i].get('AuthorizefId');
//                    status = selectData[i].get('Status');
                }

                //如果没有选择，就提示需要选择数据信息
                if (selectData == null || selectData == "") {
                    Ext.Msg.alert("提示", "请选中需要操作的记录！");
                    return;
                }
                
                if (array.length != 1) {
                    Ext.Msg.alert("提示", "请选中一条记录！");
                    return;
                }
                //放ui-check
//                if (status != 1)
//                {
//                    Ext.Msg.alert("提示", "订单已审或者已出库，不允许修改！");
//                    return;
//                }
                
                
                uploadAuthorizeWindow.show();
                if(document.getElementById("editIFrame").src.indexOf("frmSampleAuthorizeInput")==-1)
                {                
                    document.getElementById("editIFrame").src = "frmSampleAuthorizeInput.aspx?OpenType=oper&id=" + selectData[0].data.AuthorizeId;
                }
                else{
                    document.getElementById("editIFrame").contentWindow.AuthorizeId=selectData[0].data.AuthorizeId;
                    document.getElementById("editIFrame").contentWindow.setAuthorizeFormValue();
                    document.getElementById("editIFrame").contentWindow.OpenType='oper';
                }
            }
            
            function deleteAuthorize()
            {
                var sm = authorizeGrid.getSelectionModel();
                //多选
                var selectData = sm.getSelections();                
                var array = new Array(selectData.length);
                var status = 1;
                for(var i=0;i<selectData.length;i++)
                {
                    array[i] = selectData[i].get('AuthorizefId');
//                    status = selectData[i].get('Status');
                }

                //如果没有选择，就提示需要选择数据信息
                if (selectData == null || selectData == "") {
                    Ext.Msg.alert("提示", "请选中需要操作的记录！");
                    return;
                }
                
                if (array.length != 1) {
                    Ext.Msg.alert("提示", "请选中一条记录！");
                    return;
                }
                //删除前再次提醒是否真的要删除
	            Ext.Msg.confirm("提示信息","是否真的要删除选择的委托信息吗？",function callBack(id){
		            //判断是否删除数据
		            if(id=="yes")
		            {
                            Ext.Ajax.request({
                                url: 'frmSampleAuthorizeInput.aspx?method=del',
                                params: {
                                    AuthorizeId:selectData[0].data.AuthorizeId},
                                success: function(resp, opts) {  
                                    var resu = Ext.decode(resp.responseText);
                                        Ext.Msg.alert('系统提示',resu.errorinfo);
                                        authorizeData.reload();
                                },
                                failure: function(resp, opts) {
                                    Ext.Msg.alert("提示", "委托信息删除失败！");
                                }});
                   }});
            }
   
   function cancleSend()
   {
        var sm = authorizeGrid.getSelectionModel();
        //多选
        var selectData = sm.getSelections();                
        
        //如果没有选择，就提示需要选择数据信息
        if (selectData == null || selectData == "") {
            Ext.Msg.alert("提示", "请选中需要操作的记录！");
            return;
        }
        
        if (selectData.length != 1) {
            Ext.Msg.alert("提示", "请选中一条记录！");
            return;
        }
        Ext.Msg.confirm("提示信息","是否真的要把选择的委托信息取消送检？",function callBack(id){
		    //判断是否删除数据
		    if(id=="yes")
		    {
                    Ext.Ajax.request({
                        url: 'frmSampleAuthorizeList.aspx?method=cancleSend',
                        params: {
                            AuthorizeId:selectData[0].data.AuthorizeId},
                        success: function(resp, opts) {  
                            var resu = Ext.decode(resp.responseText);
                                Ext.Msg.alert('系统提示',resu.errorinfo);
                                authorizeData.reload();
                        },
                        failure: function(resp, opts) {
                            Ext.Msg.alert("提示", "委托信息送检取消失败！");
                        }});
            }});
   }
   function sendToCheck()
   {
        var sm = authorizeGrid.getSelectionModel();
        //多选
        var selectData = sm.getSelections();                
        
        //如果没有选择，就提示需要选择数据信息
        if (selectData == null || selectData == "") {
            Ext.Msg.alert("提示", "请选中需要操作的记录！");
            return;
        }
        
        if (selectData.length != 1) {
            Ext.Msg.alert("提示", "请选中一条记录！");
            return;
        }
        Ext.Msg.confirm("提示信息","是否真的要把选择的委托信息送检？",function callBack(id){
		    //判断是否删除数据
		    if(id=="yes")
		    {
                    Ext.Ajax.request({
                        url: 'frmSampleAuthorizeList.aspx?method=sendToCheck',
                        params: {
                            AuthorizeId:selectData[0].data.AuthorizeId},
                        success: function(resp, opts) {  
                            var resu = Ext.decode(resp.responseText);
                                Ext.Msg.alert('系统提示',resu.errorinfo);
                                authorizeData.reload();
                        },
                        failure: function(resp, opts) {
                            Ext.Msg.alert("提示", "委托信息发送失败！");
                        }});
            }});
       }
/*获取数据信息*/
loadData();
        
            function loadData() {
            authorizeData.load({ params: { limit: defaultPageSize, start: 0} });
        }             
                
})
function getCmbStore(columnName) {

}
</script>
</html>
