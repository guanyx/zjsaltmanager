<%@ Page Language="C#" AutoEventWireup="true" CodeFile="testfrmCrmContract.aspx.cs" Inherits="CRM_Contract_frmCrmContract" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html>
<head>
<title>测试页面</title><meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<link rel="stylesheet" type="text/css" href="../../ext3/resources/css/ext-all.css" />
<script type="text/javascript" src="../../ext3/adapter/ext/ext-base.js"></script>
<script type="text/javascript" src="../../ext3/ext-all.js"></script>
<link rel="stylesheet" type="text/css" href="../../ext3/example/file-upload.css" />
<script type="text/javascript" src="../../ext3/example/FileUploadField.js"></script>
</head>
<body>
<div id='toolbar'></div>
<div id='searchForm'></div>
<div id='contractGrid'></div>

</body>

<%= getComboBoxStore() %>

<script type="text/javascript">
Ext.BLANK_IMAGE_URL = "../../ext3/resources/images/default/s.gif";
    Ext.onReady(function() {
    var saveType;
        /*------实现toolbar的函数 start---------------*/
        var Toolbar = new Ext.Toolbar({
            renderTo: "toolbar",
            items: [{
                text: "新增",
                icon: "../../Theme/1/images/extjs/customer/add16.gif",
                handler: function() { 
                    var sm = contractGrid.getSelectionModel();
                    //获取选择的数据信息
                    var selectData = sm.getSelected();
                    //如果没有选择，就提示需要选择数据信息
                    if (selectData == null) {
                        Ext.Msg.alert("提示", "请选中需要查看的信息！");
                        return;
                    }
                    selectData.data.RecStatus='add';
                }
            }, '-', {
                text: "编辑",
                icon: "../../Theme/1/images/extjs/customer/edit16.gif",
                handler: function() { 
                    var sm = contractGrid.getSelectionModel();
                    //获取选择的数据信息
                    var selectData = sm.getSelected();
                    //如果没有选择，就提示需要选择数据信息
                    if (selectData == null) {
                        Ext.Msg.alert("提示", "请选中需要查看的信息！");
                        return;
                    }
                    selectData.data.RecStatus='edit2';
                }
            }, '-', {
                text: "删除",
                icon: "../../Theme/1/images/extjs/customer/delete16.gif",
                handler: function() {
                    var sm = contractGrid.getSelectionModel();
                    //获取选择的数据信息
                    var selectData = sm.getSelected();
                    //如果没有选择，就提示需要选择数据信息
                    if (selectData == null) {
                        Ext.Msg.alert("提示", "请选中需要查看的信息！");
                        return;
                    }
                    selectData.data.RecStatus='del';
                
                 }
            },  '-',{
                text: "查看附件",
                icon: "../../Theme/1/images/extjs/customer/delete16.gif",
                handler: function() {
                    json = "";
                        contractGridData.each(function(contractGridData) {
                            json += Ext.util.JSON.encode(contractGridData.data) + ',';
                        });
                    json = json.substring(0, json.length - 1);
                    alert(json);
                    
                    contractGridData.filterBy(function(record) {
                        return record.get('RecStatus') != 'del';
                    });
                    
                    //store.clearFilter();
                }
}]
            });
            

            /*------结束toolbar的函数 end---------------*/

            // 定义一个用户对象,这样便于我们动态的添加记录,虽然也可以设置成匿名内置对象
            var Contract = Ext.data.Record.create([
                   // 下面的 "name" 匹配读到的标签名称, 除了 "birthDay",它被映射到标签 "birth"
                   {name: 'ContractId', type: 'int' },
                   {name: 'ContractNo', type: 'string'},
                   {name: 'ContractType', type: 'int'},
                   {name: 'ContractName', type: 'string'},
                   {name: 'Singer', type: 'string'},
                   {name: 'ContractSecond', type: 'string'},     
                   {name: 'ContractSum', type: 'int'},           
                   {name: 'ContractDate', mapping: 'ContractDate', type: 'date', dateFormat: 'Y/m/d'},
                   {name: 'State', type: 'int'}
              ]); 



            /*------开始ToolBar事件函数 start---------------*//*-----新增Contract实体类窗体函数----*/
            function openAddContractWin() {
                
            }
            /*-----编辑Contract实体类窗体函数----*/
            function modifyContractWin() {
               
            }
            /*-----删除Contract实体函数----*/
            /*删除信息*/
            function deleteContract() {
               
            }
            function viewContractAttach(){
                
            }

         // 13388615939

/*------定义查询form end ----------------*/



            /*------开始获取数据的函数 start---------------*/
            var contractGridData = new Ext.data.Store
({
    url: 'frmCrmContract.aspx?method=getContractList',
    reader: new Ext.data.JsonReader({
        totalProperty: 'totalProperty',
        root: 'root'
    }, [
	{
	    name: 'ContractId'
	},
	{
	    name: 'ContractNo'
	},
	{
	    name: 'ContractName'
	},
	{
	    name: 'ContractType'
	},
	{
	    name: 'ContractDate'
	},
	{
	    name: 'Singer'
	},
	{
	    name: 'ContractSecond'
	},
	{
	    name: 'ContractSum'
	},
	{
	    name: 'ContractContent'
	},
	{
	    name: 'ContarctAttach'
	},
	{
	    name: 'State'
	},
	{
	    name: 'CreateDate'
	},
	{
	    name: 'UpdateDate'
	},
	{
	    name: 'OwenId'
	},
	{
	    name: 'OwenOrgId'
	},
	{
	    name: 'OperId'
	},
	{
	    name: 'RecStatus'
	},
	{
	    name: 'OrgId'
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

            /*------开始DataGrid的函数 start---------------*/
            var fm = Ext.form;
            var sm = new Ext.grid.CheckboxSelectionModel({
                singleSelect: true
            });
            var contractGrid = new Ext.grid.EditorGridPanel({
                el: 'contractGrid',
                width: '100%',
                height: '100%',
                autoWidth: true,
                autoHeight: true,
                autoScroll: true,
                layout: 'fit',
                clicksToEdit:1,
                id: '',
                store: contractGridData,
                loadMask: { msg: '正在加载数据，请稍侯……' },
                sm: sm,
                cm: new Ext.grid.ColumnModel([
		sm,
		new Ext.grid.RowNumberer(), //自动行号
		{
		    header: '合同ID',
		    dataIndex: 'ContractId',
		    id: 'ContractId',
			hidden: true,
            hideable: false		
},
		{
		    header: '合同编号',
		    dataIndex: 'ContractNo',
		    id: 'ContractNo',
            editor: new fm.TextField({
               allowBlank: true
           }) 
		},
		{
		    header: '合同名称	',
		    dataIndex: 'ContractName',
		    id: 'ContractName',
            editor: new fm.TextField({
               allowBlank: true
           }) 
		},
		{
		    header: '合同类型',
		    dataIndex: 'ContractType',
		    id: 'ContractType',
            editor: new fm.TextField({
               allowBlank: true
           }) 
		},
		{
		    header: '合同时间',
		    dataIndex: 'ContractDate',
		    id: 'ContractDate',
            editor: new fm.TextField({
               allowBlank: true
           }) 
		},
		{
		    header: '签订人',
		    dataIndex: 'Singer',
		    id: 'Singer',
            editor: new fm.TextField({
               allowBlank: true
           }) 
		},
		{
		    header: '合同乙方',
		    dataIndex: 'ContractSecond',
		    id: 'ContractSecond',
            editor: new fm.TextField({
               allowBlank: true
           }) 
		},
		{
		    header: '合同金额',
		    dataIndex: 'ContractSum',
		    id: 'ContractSum',
            editor: new fm.TextField({
               allowBlank: true
           }) 
		},
		{
		    header: '记录状态',
		    dataIndex: 'RecStatus',
		    id: 'RecStatus',
            hidden:true,
            hideable:false
		},
		{
		    header: '合同状态',
		    dataIndex: 'State',
		    id: 'State',
            editor: new fm.TextField({
               allowBlank: true
           }) 
		
}]),
                bbar: new Ext.PagingToolbar({
                    pageSize: 10,
                    store: contractGridData,
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
            contractGrid.render();
            /*------DataGrid的函数结束 End---------------*/

            contractGridData.load({
                                params : {
                                start : 0,
                                limit : 10
                                } 
            }); 
            
            
            // 单元格编辑后事件处理
    contractGrid.on("afteredit", afterEdit, contractGrid);
    // 事件处理函数
    function afterEdit(e) {
        var record = e.record;// 被编辑的记录
        e.record.data.RecStatus='edit';
        // 显示等待对话框
        Ext.Msg.wait("请等候", "修改中", "操作进行中...");

          // 更新界面, 来真正删除数据
            Ext.Msg.alert('您成功修改了用户信息', "被修改的用户是:" + e.record.get("ContractName") + "\n 修改的字段是:"
            + e.field);// 取得用户名
    };
    


        })
</script>

</html>

