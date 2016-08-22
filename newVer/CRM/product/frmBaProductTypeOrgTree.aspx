<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmBaProductTypeOrgTree.aspx.cs" Inherits="CRM_product_frmBaProductTypeOrgTree" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>�������������֯ѡ���</title>
    <meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
    <link rel="stylesheet" type="text/css" href="../../ext3/resources/css/ext-all.css" />
	<script type="text/javascript" src="../../ext3/adapter/ext/ext-base.js"></script>	
	<script type="text/javascript" src="../../ext3/ext-all.js"></script>
	<script type="text/javascript" src="../../js/operateResp.js"></script>
    <script type="text/javascript" src="../../ext3/src/locale/ext-lang-zh_CN.js"></script>
</head>
<body>
    <form id="form1" runat="server">
       <div id="toolbar"></div>
       <div id='tree-div'></div>
    </form>
</body>
<script type="text/javascript">
function getParamerValue( name )
{
  name = name.replace(/[\[]/,"\\\[").replace(/[\]]/,"\\\]");
  var regexS = "[\\?&]"+name+"=([^&#]*)";
  var regex = new RegExp( regexS );
  var results = regex.exec( window.location.href );
  if( results == null )
    return "";
  else
    return results[1];
}
var Classid = getParamerValue('classid');//��������
var orgId = <% =ZJSIG.UIProcess.ADM.UIAdmUser.OrgID(this)%>;
</script>
<script type="text/javascript">
Ext.BLANK_IMAGE_URL = "../../ext3/resources/images/default/s.gif";
Ext.onReady(function(){
/*------ʵ��toolbar�ĺ��� start---------------*/
    var Toolbar = new Ext.Toolbar({
        renderTo: "toolbar",
        items: [{
            text: "ȷ��",
            icon: "../../Theme/1/images/extjs/customer/disk.png",
            handler: function() {
                selectOrgOk();
            }
        }]
    });
    var selectOrgTree = null;
    var selectedOrgID = null;
    var selectOrgForm = null;
    function showOrgForm(parentID, title, url) {
        var root = new Ext.tree.AsyncTreeNode({
            text: '������Ϣ',
            draggable: false,
            id: 'source'
        });
        
        selectOrgTree =  new Ext.tree.TreePanel({//����������������"�ؼ�"��
            el:'tree-div',
            useArrows: true,
            autoScroll: true,
            animate: true,
            enableDD: true,
            containerScroll: true,
                loader: new Ext.tree.TreeLoader({
                    dataUrl: url
                }),            
            root: root
        });
        
        selectOrgTree.render(); 
    }
    if (selectOrgForm == null) {
        var showType = "getcurrentandchildrentree";
        if (orgId == 1) {
            showType = "getcurrentAndChildrenTreeByArea";
        }
        showOrgForm("", "", "frmBaProductTypeOrgTree.aspx?method=" + showType + "&classid="+Classid);
        selectOrgTree.on('checkchange', treeCheckChange, selectOrgTree);
        selectOrgTree.expandAll();
    }
    else {
        showOrgForm("", "", "");
    }
    
    function selectOrgOk() {
        var selectOrgNames = "";
        selectOrgIds = "";
        var selectNodes = selectOrgTree.getChecked();
        for (var i = 0; i < selectNodes.length; i++) {
            if (selectNodes[i].id.indexOf("A") != -1)
                continue;
            if (selectOrgNames != "") {
                selectOrgNames += ",";
                selectOrgIds += ",";
            }
            selectOrgIds += selectNodes[i].id;
            selectOrgNames += selectNodes[i].text;
        }
        //����
        Ext.Ajax.request({
		url:'frmBaProductTypeOrgTree.aspx?method=saveReportType',
		method:'POST',
		params:{
			ClassId:Classid,
			OrgId:selectOrgIds
			},
		success: function(resp,opts){
			//Ext.Msg.alert("��ʾ","����ɹ�");
			if(checkExtMessage(resp))
			{   
            }
		},
		failure: function(resp,opts){
			Ext.Msg.alert("��ʾ","����ʧ��");
		}
		});
    }
    function treeCheckChange(node, checked) {
        node.expand();
        node.attributes.checked = checked;
        node.eachChild(function(child) {
            child.ui.toggleCheck(checked);
            child.attributes.checked = checked;
            child.fireEvent('checkchange', child, checked);
        });
        selectOrgTree.un('checkchange', treeCheckChange, selectOrgTree);
        checkParentNode(node);
        selectOrgTree.on('checkchange', treeCheckChange, selectOrgTree);
    }
    function checkParentNode(currentNode) {
        if (currentNode.parentNode != null) {
            var tempNode = currentNode.parentNode;
            //����Ǹ��ڵ㣬�Ͳ���������
            if (tempNode.parentNode == null)
                return;
            //�����ѡ���ˣ���ô���ڵ�Ҳ�����ǳ���ѡ��״̬��
            if (currentNode.attributes.checked) {
                if (!tempNode.attributes.checked) {
                    tempNode.fireEvent('checkchange', tempNode, true);
                    tempNode.ui.toggleCheck(true);
                    tempNode.attributes.checked = true;

                }
            }
            //ȡ��ѡ��
            else {
                var tempCheck = false;
                tempNode.eachChild(function(child) {
                    if (child.attributes.checked) {
                        tempCheck = true;
                        return;
                    }
                });
                if (!tempCheck) {
                    tempNode.fireEvent('checkchange', tempNode, false);
                    tempNode.ui.toggleCheck(false);
                    tempNode.attributes.checked = false;
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
});
</script>
</html>
