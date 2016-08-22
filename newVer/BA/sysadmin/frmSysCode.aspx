<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmSysCode.aspx.cs" Inherits="BA_sysadmin_frmSysCode" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>编码设置</title>
    <meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
    <link rel="stylesheet" type="text/css" href="../../ext3/resources/css/ext-all.css" />
	<script type="text/javascript" src="../../ext3/adapter/ext/ext-base.js"></script>	
	<script type="text/javascript" src="../../ext3/ext-all.js"></script>
	<script type="text/javascript" src="../../js/operateResp.js"></script>
	<script type="text/javascript" src="../../js/ProductSelect.js"></script>
	<script type="text/javascript" src="../../js/ExtJsHelper.js"></script>
</head>
<%= getComboBoxStore() %>
<script>
Ext.BLANK_IMAGE_URL = "../../ext3/resources/images/default/s.gif";
Ext.onReady(function(){
    var currentNode;
    /*------实现tree的函数 start---------------*/
    var Tree = Ext.tree;
    var tree = new Tree.TreePanel({
        el:'tree-div',
        useArrows:true,
        autoScroll:true,
        animate:true,
        autoWidth:true,
        autoHeight:true,
        enableDD:false,
        containerScroll: true, 
        loader: new Tree.TreeLoader({
           dataUrl:'frmSysCode.aspx?method=gettreelist',
           baseParams:{
                orgId:orgId
           }})
    });
    
    
    tree.on('contextmenu',function(node,event){  
          //alert("node.id="+ node.id);
          currentNode = node;
	      //var selModel = tree.getSelectionModel();
	      //selModel.select(currentNode);  //右键响应定位当前节点，但不响应点击事件
	      currentNode.select();
          event.preventDefault(); //这行是必须的
          //控制右键菜单子菜单
          if(node.id ==0 ){
            rightClick.items.get('deleteItem').disable();
            rightClick.items.get('modifyItem').disable();
          }else{
            rightClick.items.get('deleteItem').enable();
            rightClick.items.get('modifyItem').enable();
          }
          rightClick.showAt(event.getXY());//取得鼠标点击坐标，展示菜单
    });
    
    //定义右键菜单
    var rightClick = new Ext.menu.Menu({
        id :'rightClickCont',
        items : [{
            id:'addItem',
            text : '新增子节点',
            icon:"../../Theme/1/images/extjs/customer/add16.gif",
            //增加菜单点击事件
            handler:function (){
                //显示并赋值
                uploadSysCodeWindow.show();
                Ext.getCmp('CodeParent').setValue(currentNode.id);
                
            }
        }, {
            id:'modifyItem',
            text : '修改',
            icon:"../../Theme/1/images/extjs/customer/edit16.gif",
            handler:function (){               
                //显示并赋值
                uploadSysCodeWindow.show();
                rightClick.hide();
                if(currentNode.id ==0)
                    return;
                setFormValue();  
            }
        }, {
            id:'deleteItem',
            text : '删除',
            icon:"../../Theme/1/images/extjs/customer/delete16.gif",
            handler:function (){
                 //删除前再次提醒是否真的要删除
            Ext.Msg.confirm("提示信息", "是否真的要删除选择的存货分类信息吗？", function callBack(id) {
                //判断是否删除数据
                if (id == "yes") {
                    //页面提交
                    Ext.Ajax.request({
		            url:'frmSysCode.aspx?method=delete',
		            method:'POST',
		            params:{
			            CodeId:currentNode.id
			        },
		            success: function(resp,opts){
			            if(checkExtMessage(resp))
			            {
			                //当前节点删除
			                currentNode.remove();
			            }
		            },
		            failure: function(resp,opts){
			            Ext.Msg.alert("提示","删除失败");
		            }
		            });
                }
            });
                 
            }
        }]
     });    

    // set the root node
    var root = new Tree.AsyncTreeNode({
        text: '编码信息',
        draggable:false,
        id:'0'
    });
    tree.setRootNode(root);

    // render the tree
    tree.render();
    root.expand();
    
    var detailTypeForm = new Ext.form.FormPanel({
            items: [
		{
		    xtype: 'hidden',
		    fieldLabel: '标识',
		    columnWidth: 1,
		    anchor: '90%',
		    name: 'CodeId',
		    id: 'CodeId'
		}
, {
    xtype: 'textfield',
    fieldLabel: '编码名称',
    columnWidth: 1,
    anchor: '90%',
    name: 'CodeName',
    id: 'CodeName'
}
, {
    xtype: 'textfield',
    fieldLabel: '编码',
    columnWidth: 1,
    anchor: '90%',
    name: 'CodeNo',
    id: 'CodeNo'

}
, {
    xtype: 'textfield',
    fieldLabel: '上级编码',
    columnWidth: 1,
    anchor: '90%',
    name: 'CodeParentName',
    id: 'CodeParentName'
}, {
    xtype: 'textfield',
    fieldLabel: '备注',
    columnWidth: 1,
    anchor: '90%',
    name: 'CodeMemo',
    id: 'CodeMemo'

}, {
    xtype: 'hidden',
    columnWidth: 1,
    anchor: '90%',
    name: 'CodeParent',
    id: 'CodeParent'
}]
        });
    /*------详细信息window的函数 start---------------*/
if (typeof (uploadSysCodeWindow) == "undefined") {//解决创建2个windows问题
    uploadSysCodeWindow = new Ext.Window({
        id: 'uploadTypeWindow',
        title: "编码维护"
        , iconCls: 'upload-win'
        , width: 600
        , height: 300
        , layout: 'fit'
        , plain: true
        , modal: true
        , constrain: true
        , resizable: false
        , closeAction: 'hide'
        , autoDestroy: true
        , items: detailTypeForm
        , buttons: [{
             id: 'savebuttonid'
            , text: "保存"
            , handler: function() {
                Ext.Msg.confirm("提示信息", "是否确认要保存？", function callBack(id) {
                    //判断是否删除数据
                    if (id == "yes") {
                        //页面提交
                        saveUserData();
                        uploadSysCodeWindow.hide();                        
                        
                    }
                });
            }
            , scope: this
        },
        {
            text: "取消"
            , handler: function() {
                uploadSysCodeWindow.hide();
            }
            , scope: this
        }]
    });
}

uploadSysCodeWindow.addListener("hide", function() {
    detailTypeForm.getForm().reset();
});

function saveUserData()
{
    getFormValue();
}
function getFormValue() {
            Ext.MessageBox.wait('正在保存数据中, 请稍候……');
            Ext.Ajax.request({
                url: 'frmSysCode.aspx?method=save',
                method: 'POST',
                params: {
                    CodeId: Ext.getCmp('CodeId').getValue(),
                    CodeName: Ext.getCmp('CodeName').getValue(),
                    CodeNo: Ext.getCmp('CodeNo').getValue(),
                    CodeParent: Ext.getCmp('CodeParent').getValue(),
                    CodeMemo: Ext.getCmp('CodeMemo').getValue()
                },
                success: function(resp, opts) {
                    Ext.MessageBox.hide();
                    if (checkExtMessage(resp)) {
                        uploadSysCodeWindow.hide();
                        tree.getLoader().on("beforeload", function(treeLoader, node) {
                            treeLoader.baseParams.orgId = orgId;
                        }, this);
                            tree.root.reload();
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
                url: 'frmSysCode.aspx?method=getcode',
                params: {
                    CodeId: currentNode.id
                },
                success: function(resp, opts) {
                    var data = Ext.util.JSON.decode(resp.responseText);
                    if(data.OrgId=="1")
                    {
                        Ext.Msg.alert("提示","省公司设置的数据，不能修改！");
                        uploadSysCodeWindow.hide();
                    }
                    Ext.getCmp("CodeId").setValue(data.CodeId);
                    Ext.getCmp("CodeName").setValue(data.CodeName);
                    Ext.getCmp("CodeNo").setValue(data.CodeNo);
                    Ext.getCmp("CodeParent").setValue(data.CodeParent);
                    Ext.getCmp("CodeMemo").setValue(data.CodeMemo);

                },
                failure: function(resp, opts) {
                    Ext.Msg.alert("提示", "获取编码信息失败");
                }
            });
        }
})
</script>
<body>
    <form id="form1" runat="server">
    <div id='tree-div'>
    
    </div>
    </form>
</body>
</html>
