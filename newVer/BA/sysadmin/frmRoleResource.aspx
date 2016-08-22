<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmRoleResource.aspx.cs" Inherits="BA_sysadmin_frmRoleResource" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <link rel="stylesheet" type="text/css" href="../../ext3/resources/css/ext-all.css" />
	<script type="text/javascript" src="../../ext3/adapter/ext/ext-base.js"></script>	
	<script type="text/javascript" src="../../ext3/ext-all.js"></script>
	<script type="text/javascript" src="../../js/operateResp.js"></script>
    <title>无标题页</title>
    <%=RoleIDScript%>
    <script type="text/javascript">
        Ext.onReady(function() {
            Ext.BLANK_IMAGE_URL = "../../ext3/resources/images/default/s.gif";
            var imageUrl = "../../Theme/1/";
            /*------实现toolbar的函数 start---------------*/
            var Toolbar = new Ext.Toolbar({
                renderTo: "toolbar",
                items: [{
                    text: "分配",
                    icon: imageUrl+"images/extjs/customer/add16.gif",
                    handler: function() {
                        var resources = getSelectNodes();
                        Ext.Msg.wait("正在保存角色资源信息，请稍候","系统提示");
                        Ext.Ajax.request({
                            url: 'frmRoleResource.aspx?method=saveresources',
                            method: 'POST',
                            params: {
                                RoleID: roleID,
                                Resoureces: resources
                            },
                            success: function(resp, opts) {
                                Ext.Msg.hide();
                                checkExtMessage(resp);
                            },
                            failure: function(resp, opts) {
                                Ext.Msg.hide();
                                Ext.Msg.alert("提示", "保存失败");
                            }
                        });
                    }
}]
                });

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

                /*------结束toolbar的函数 end---------------*/


                // shorthand
                var Tree = Ext.tree;

                var tree = new Tree.TreePanel({
                    el: 'tree-div',
                    useArrows: true,
                    height:370,
                    autoScroll: true,
                    animate: true,
                    enableDD: true,
                    //containerScroll: true,
                    //rootVisible:false,
                    loader: new Tree.TreeLoader({
                        dataUrl: 'frmRoleResource.aspx?method=gettreelist&roleid=' + roleID
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

                // render the tree
                tree.render();
                // root.expand();
                tree.expandAll();
            });
</script>

</head>
<body>
    <form id="form1" runat="server">
    <div id="toolbar"></div>
    <div id="tree-div" style="overflow:auto; width:100%;border:1px solid #c3daf9;"></div>
    </form>
</body>
</html>
