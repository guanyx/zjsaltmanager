<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmAdmAuthorize.aspx.cs" Inherits="BA_sysadmin_frmAdmAuthorize" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>无标题页</title>
    <link rel="stylesheet" type="text/css" href="../../ext3/resources/css/ext-all.css" />
<script type="text/javascript" src="../../ext3/adapter/ext/ext-base.js"></script>
<script type="text/javascript" src="../../ext3/ext-all.js"></script>
<script type="text/javascript" src="../../js/operateResp.js"></script>
<script type="text/javascript" src="../../js/EmpSelect.js"></script>
</head>
<script>
Ext.onReady(function(){
var imageUrl = "../../Theme/1/";
Ext.BLANK_IMAGE_URL = "../../ext3/resources/images/default/s.gif" ;
/*------实现toolbar的函数 start---------------*/
    var Toolbar = new Ext.Toolbar({
        renderTo: "toolbar",
        region: "north",
        height: 25,
        items: [{
            text: "新增",
            icon: imageUrl + "images/extjs/customer/add16.gif",
            handler: function() {
                saveType = "add";
                addAuthor();
                uploadAutohrizeWindow.show();
                root.reload();
                    tree.expandAll();
                
            }
        }, '-', {
            text: "编辑",
            icon: imageUrl + "images/extjs/customer/edit16.gif",
            handler: function() {
                saveType = "editauthor";
                modifyAuthorWin();
                
            }
        }, '-', {
            text: "删除",
            icon: imageUrl + "images/extjs/customer/delete16.gif",
            handler: function() {

                deleteAuthor();
            }
}, '-', {
            text: "禁用",
            icon: imageUrl + "images/extjs/customer/delete16.gif",
            handler: function() {

                stopAuthor();
            }
}]
        });

        /*------结束toolbar的函数 end---------------*/
        
/*-----编辑Dept实体类窗体函数----*/

function addAuthor()
{
     Ext.getCmp("AuthorizeId").setValue("");
     Ext.getCmp("AuthorizeDate").setValue("")
     Ext.getCmp("AutohrizeStartdate").setValue("")
     Ext.getCmp("AutohrizeEnddate").setValue("")
    Ext.getCmp("AccepterId").setValue("");
  
    Ext.getCmp("Status").setValue("");
    Ext.getCmp("AccepterName").setValue("");
    
    tree.loader.baseParams.AuthorizeId = 0;
}
        function modifyAuthorWin() {
            var sm = Ext.getCmp('gridAuthor').getSelectionModel();
            //获取选择的数据信息
            var selectData = sm.getSelected();
            if (selectData == null) {
                Ext.Msg.alert("提示", "请选中需要编辑的信息！");
                return;
            }
            uploadAutohrizeWindow.show();
            setFormValue(selectData);
        }
        
function stopAuthor()
{
    var sm = Ext.getCmp('gridAuthor').getSelectionModel();
            //获取选择的数据信息
            var selectData = sm.getSelected();
            //如果没有选择，就提示需要选择数据信息
            if (selectData == null) {
                Ext.Msg.alert("提示", "请选中需要禁用的授权信息！");
                return;
            }
            //删除前再次提醒是否真的要删除
            Ext.Msg.confirm("提示信息", "是否真的要禁用选择的授权信息吗？", function callBack(id) {
                //判断是否删除数据
                if (id == "yes") {
                    //页面提交
                    Ext.Ajax.request({
                        url: 'frmAdmAuthorize.aspx?method=stopauthor',
                        method: 'POST',
                        params: {
                            AuthorizeId: selectData.data.AuthorizeId
                        },
                        success: function(resp, opts) {
                           if(checkExtMessage(resp))
                           {
                                gridAuthorData.reload();
                           }
                        },
                        failure: function(resp, opts) {
                            Ext.Msg.alert("提示", "禁用失败");
                        }
                    });
                }
            });
}
 /*删除信息*/
        function deleteAuthor() {
            var sm = Ext.getCmp('gridAuthor').getSelectionModel();
            //获取选择的数据信息
            var selectData = sm.getSelected();
            //如果没有选择，就提示需要选择数据信息
            if (selectData == null) {
                Ext.Msg.alert("提示", "请选中需要删除的信息！");
                return;
            }
            //删除前再次提醒是否真的要删除
            Ext.Msg.confirm("提示信息", "是否真的要删除选择的信息吗？", function callBack(id) {
                //判断是否删除数据
                if (id == "yes") {
                    //页面提交
                    Ext.Ajax.request({
                        url: 'frmAdmAuthorize.aspx?method=deleteauthor',
                        method: 'POST',
                        params: {
                            AuthorizeId: selectData.data.AuthorizeId
                        },
                        success: function(resp, opts) {
                           if(checkExtMessage(resp))
                           {
                                gridAuthorData.reload();
                           }
                        },
                        failure: function(resp, opts) {
                            Ext.Msg.alert("提示", "数据删除失败");
                        }
                    });
                }
            });
        }
/*------实现FormPanle的函数 start---------------*/
var divAuthor=new Ext.form.FormPanel({
    region:'north',
    height:70,
	items:[
	{
		layout:'column',
		border: false,
		labelSeparator: '：',
		items: [
		{
			layout:'form',
			border: false,
			columnWidth:1,
			items: [
				{
					xtype:'hidden',
					fieldLabel:'授权ID',
					columnWidth:1,
					anchor:'90%',
					name:'AuthorizeId',
					id:'AuthorizeId'
				},{
					xtype:'hidden',
					fieldLabel:'授权ID',
					columnWidth:1,
					anchor:'90%',
					name:'AccepterId',
					id:'AccepterId'
				}
		]
		}
	]},
	{
		layout:'column',
		border: false,
		labelSeparator: '：',
		items: [
		{
			layout:'form',
			border: false,
			columnWidth:0.5,
			items: [
				{
					xtype:'textfield',
					fieldLabel:'被授权人',
					columnWidth:0.5,
					anchor:'90%',
					name:'AccepterName',
					id:'AccepterName'
				}
		]
		}
,		{
			layout:'form',
			border: false,
			columnWidth:0.5,
			items: [
				{
					xtype:'hidden',
					fieldLabel:'状态',
					columnWidth:0.5,
					anchor:'90%',
					name:'Status',
					id:'Status'
				}
		]
		}
	]},
	{
		layout:'column',
		border: false,
		labelSeparator: '：',
		items: [
		{
			layout:'form',
			border: false,
			columnWidth:0.33,
			items: [
				{
					xtype:'datefield',
					fieldLabel:'授权时间',
					columnWidth:0.33,
					anchor:'90%',
					name:'AuthorizeDate',
					id:'AuthorizeDate',
					format: "Y-m-d"
				}
		]
		}
,		{
			layout:'form',
			border: false,
			columnWidth:0.33,
			items: [
				{
					xtype:'datefield',
					fieldLabel:'授权开始时间',
					columnWidth:0.33,
					anchor:'90%',
					name:'AutohrizeStartdate',
					id:'AutohrizeStartdate',
					format: "Y-m-d"
				}
		]
		}
,		{
			layout:'form',
			border: false,
			columnWidth:0.33,
			items: [
				{
					xtype:'datefield',
					fieldLabel:'授权结束时间',
					columnWidth:0.33,
					anchor:'90%',
					name:'AutohrizeEnddate',
					id:'AutohrizeEnddate',
					format: "Y-m-d"
				}
		]
		}
	]
	}
]
});

Ext.getCmp("AccepterName").on("focus",selectEmp);
function selectEmp(v)
{
    if(selectEmpForm==null)
    {
        showEmpForm(0,'员工选择','frmAdmAuthorize.aspx?method=gettreecolumnlist');
        Ext.getCmp("btnOk").on("click",selectOK);
    }
    else
    {
        showEmpForm(0,'员工选择','frmAdmAuthorize.aspx?method=gettreecolumnlist');
    }
}

function selectOK()
{
    var selectNodes = selectEmpTree.getChecked();
    if(selectNodes.length>0)
    {
        Ext.getCmp("AccepterName").setValue(selectNodes[0].text);
        Ext.getCmp("AccepterId").setValue(selectNodes[0].id);
    }
}
/*------FormPanle的函数结束 End---------------*/

/*---------------Tree-------------------------*/
// shorthand

//获取选择的授权信息
function getSelectNodes() {
    var selectNodes = tree.getChecked();
    var ids = "";
    for (var i = 0; i < selectNodes.length; i++) {
        if (ids.length > 0)
            ids += ",";
        ids += selectNodes[i].id;
    }
    return ids;
}
                var Tree = Ext.tree;

                var tree = new Tree.TreePanel({
                    //el: 'tree-div',
                    region:'center',
                    useArrows: true,
                    autoScroll: true,
                    animate: true,
                    enableDD: true,
                    //containerScroll: true,
                    //rootVisible:false,
                    loader: new Tree.TreeLoader({
                        dataUrl: 'frmAdmAuthorize.aspx?method=getresource&roleid=1' 
                    })
                });
                tree.on('checkchange', treeCheckChange, tree);

                function treeCheckChange(node,checked)
                {
                    node.expand();
                    node.attributes.checked = checked;                    
                    node.eachChild(function(child) {
                        child.ui.toggleCheck(checked);
                        child.attributes.checked = checked;
                        child.fireEvent('checkchange', child, checked);
                    });
                    tree.un('checkchange', treeCheckChange, tree);
                    checkParentNode(node);
                    tree.on('checkchange', treeCheckChange, tree);
                }
                function checkParentNode(currentNode)
                {
                    if(currentNode.parentNode!=null)
                    {
                        var tempNode = currentNode.parentNode;                        
                        //如果是跟节点，就不做处理了
                        if(tempNode.parentNode==null)
                            return;
                        //如果是选择了，那么父节点也必须是出于选择状态的
                        if(currentNode.attributes.checked)
                        {
                            if(!tempNode.attributes.checked)
                            {
                                tempNode.fireEvent('checkchange', tempNode, true);
                                tempNode.ui.toggleCheck(true);
                                tempNode.attributes.checked=true;
                                
                            }
                        }
                        //取消选择
                        else
                        {
                            var tempCheck=false;
                            tempNode.eachChild(function(child)
                            {
                                if(child.attributes.checked)
                                {
                                    tempCheck = true;
                                    return;
                                 }
                            });
                            if(!tempCheck)
                            {
                                tempNode.fireEvent('checkchange', tempNode, false);
                                tempNode.ui.toggleCheck(false);
                                tempNode.attributes.checked=false;
                            }
                            
                        }
                        checkParentNode(tempNode);
                    }
                }
                function parentNodeChecked(node) {
                    if (node.parentNode != null) {
                        if (node.attributes.checked) {
                            node.parentNode.ui.toggleCheck(checked);
                            node.parentNode.attributes.checked = true;
                        }
                        else {
                            for (var i = 0; i < node.parentNode.childNodes.length; i++) {
                                if (node.parentNode.childNodes[i].attributes.checked) {
                                    return;
                                }
                            }
                        }
                        parentNodeChecked(node.parentNode);
                    }
                }

                // set the root node
                var root = new Tree.AsyncTreeNode({
                    text: '资源信息',
                    draggable: false,
                    id: 'source'
                });
                tree.setRootNode(root);
 /*------开始界面数据的窗体 Start---------------*/
        if (typeof (uploadAutohrizeWindow) == "undefined") {//解决创建2个windows问题
            uploadAutohrizeWindow = new Ext.Window({
                id: 'Deptformwindow',
                title: 'h'
		, iconCls: 'upload-win'
		, width: 700
		, height: 450
		, layout: 'border'
		, plain: true
		, modal: true
		, x: 50
		, y: 50
		, constrain: true
		, resizable: false
		, closeAction: 'hide'
		, autoDestroy: true
		, items: [divAuthor,tree]
		, buttons: [{
		    text: "保存"
			, handler: function() {
			    getFormValue();
			}
			, scope: this
		},
		{
		    text: "取消"
			, handler: function() {
			    uploadAutohrizeWindow.hide();
			}
			, scope: this
}]
            });
        }
        uploadAutohrizeWindow.addListener("hide", function() {
        });
        
/*------开始获取数据的函数 start---------------*/
var gridAuthorData = new Ext.data.Store
({
url: 'frmAdmAuthorize.aspx?method=getauthorlist',
reader:new Ext.data.JsonReader({
	totalProperty:'totalProperty',
	root:'root'
},[
	{name:'AuthorizeId'},
	{name:'AuthorizerId'},
	{name:'AuthorizerName'},
	{name:'AuthorizeDate'},
	{name:'AccepterId'},
	{name:'AccepterName'},
	{name:'AutohrizeStartdate'},
	{name:'AutohrizeEnddate'},
	{name:'OperId'},
	{name:'CreateDate'},
	{name:'Status'}])
	,listeners:
	{
		scope:this,
		load:function(){
		}
	}
});

/*------获取数据的函数 结束 End---------------*/

function getStatus(val)
{
    if(val)
        return "启用";
    return "禁用";
}
/*------开始DataGrid的函数 start---------------*/

var sm= new Ext.grid.CheckboxSelectionModel({
	singleSelect:true
});
var gridAuthor = new Ext.grid.GridPanel({
	el: 'gridAuthor',
	width:'100%',
	height:'100%',
	autoWidth:true,
	autoHeight:true,
	autoScroll:true,
	layout: 'fit',
	id: 'gridAuthor',
	store: gridAuthorData,
	loadMask: {msg:'正在加载数据，请稍侯……'},
	sm:sm,
	cm: new Ext.grid.ColumnModel([
		sm,
		new Ext.grid.RowNumberer(),//自动行号
		{
			header:'授权人',
			dataIndex:'AuthorizerName',
			id:'AuthorizerName'
		},
		{
			header:'授权时间',
			dataIndex:'AuthorizeDate',
			id:'AuthorizeDate',
			renderer: Ext.util.Format.dateRenderer('Y年m月d日')
		},
		{
			header:'被授权人',
			dataIndex:'AccepterName',
			id:'AccepterName'
		},
		{
			header:'授权开始时间',
			dataIndex:'AutohrizeStartdate',
			id:'AutohrizeStartdate',
			renderer: Ext.util.Format.dateRenderer('Y年m月d日')
		},
		{
			header:'授权结束时间',
			dataIndex:'AutohrizeEnddate',
			id:'AutohrizeEnddate',
			renderer: Ext.util.Format.dateRenderer('Y年m月d日')
		},
		{
			header:'状态',
			dataIndex:'Status',
			id:'Status',
			renderer:getStatus
		}		]),
		bbar: new Ext.PagingToolbar({
			pageSize: 10,
			store: gridAuthorData,
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
    gridAuthor.render();
    
    /*------开始获取界面数据的函数 start---------------*/
        function getFormValue() {
        var resources = getSelectNodes();
        if(resources=="")
        {
            Ext.Msg.alert("请选择需要授权的资源信息！");
            return;
        }
            Ext.MessageBox.wait('正在保存数据中, 请稍候……');
            
            Ext.Ajax.request({
                url: 'frmAdmAuthorize.aspx?method=' + saveType,
                method: 'POST',
                params: {
                    AuthorizeId: Ext.getCmp('AuthorizeId').getValue(),
                    AuthorizeDate: Ext.util.Format.date(Ext.getCmp('AuthorizeDate').getValue(),'Y/m/d'),
                    AccepterId: Ext.getCmp('AccepterId').getValue(),
                    AutohrizeStartdate: Ext.util.Format.date(Ext.getCmp('AutohrizeStartdate').getValue(),'Y/m/d'),
                    AutohrizeEnddate: Ext.util.Format.date(Ext.getCmp('AutohrizeEnddate').getValue(),'Y/m/d'),
                    Status: Ext.getCmp("Status").getValue(),
                    Resources:resources
                },
                success: function(resp, opts) {
                    Ext.MessageBox.hide();
                    if(checkExtMessage(resp))
                    {
                        uploadAutohrizeWindow.hide();
                        gridAuthor.reload();
                    }
                },
                failure: function(resp, opts) {
                    Ext.MessageBox.hide();
                    Ext.Msg.alert("提示", "保存失败");
                }
            });
        }
        /*------结束获取界面数据的函数 End---------------*/

        /*------开始界面数据的函数 Start---------------*/
        function setFormValue(selectData) {
            Ext.Ajax.request({
                url: 'frmAdmAuthorize.aspx?method=getauthor',
                params: {
                    AuthorizeId: selectData.data.AuthorizeId
                },
                success: function(resp, opts) {
                    var data = Ext.util.JSON.decode(resp.responseText);
                    Ext.getCmp("AuthorizeId").setValue(data.AuthorizeId);
                    if(data.AuthorizeDate!="")
                    {
                        Ext.getCmp("AuthorizeDate").setValue(new Date(data.AuthorizeDate));//setValue(data.AuthorizeDate);
                    }
                    Ext.getCmp("AccepterId").setValue(data.AccepterId);
                    if(data.AutohrizeStartdate!="")
                    {
                        Ext.getCmp("AutohrizeStartdate").setValue(new Date(data.AutohrizeStartdate));//setValue(data.AuthorizeDate);
                    }
                    
                     if(data.AutohrizeEnddate!="")
                    {
                        Ext.getCmp("AutohrizeEnddate").setValue(new Date(data.AutohrizeEnddate));//setValue(data.AuthorizeDate);
                    }
                  
                    Ext.getCmp("Status").setValue(data.Status);
                    Ext.getCmp("AccepterName").setValue(data.EmpName);
                    
                    tree.loader.baseParams.AuthorizeId = data.AuthorizeId;
                    root.reload();
                    tree.expandAll();
                },
                failure: function(resp, opts) {
                    Ext.Msg.alert("提示", "获取部门信息失败");
                }
            });
        }
        /*------结束设置界面数据的函数 End---------------*/
})
</script>
<body>
    <form id="form1" runat="server">
    <div id="toolbar"></div>
    <div id="gridAuthor">
    
    </div>
    </form>
</body>
</html>
