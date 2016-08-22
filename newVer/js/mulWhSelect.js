var selectWhTree = null;
var whdiv = null;
var whSelectWin = null;
var callBackHandler = null;
var selectPNode = null;
var selectAllChNodes = null;
var selectWhForm=null;

function showWhForm(parentID, title, url) {
    //创建机构树信息
    if (selectWhTree == null) {
        var root = new Ext.tree.AsyncTreeNode({
            text: '仓库',
            draggable: false,
            id: 'source'
        });

            selectWhTree = new Ext.tree.TreePanel({//就是用来呈现树的"控件"吧
            useArrows: true,
            id:'selectWhTree',
            autoScroll: true,
            animate: true,
            enableDD: true,
            containerScroll: true,
            loader: new Ext.tree.TreeLoader({
                dataUrl: url
            }),

            root: root
        });
    }
    
    if (selectWhForm == null || typeof (selectWhForm) == "undefined") {//解决创建2个windows问题
        selectWhForm = new Ext.Window({
            id: 'selectWhForm'
            // title: formTitle
		, iconCls: 'upload-win'
		, width: 450
		, height: 300
		, layout: 'fit'
		, plain: true
		, modal: true
		, x: 50
		, y: 50
		, constrain: true
		, resizable: false
		, closeAction: 'hide'
		, autoDestroy: true
		, items: selectWhTree
		, buttons: [{
		    text: "确定"
		    , id: 'btnWhOk'
			, handler: function() {
//			    getRouteSelectNodes();
//			    selectRouteForm.hide();
			}
			, scope: this
		},
		{
		    text: "取消"
			, handler: function() {
			    selectedWhID = "";
			    selectWhForm.hide();
			}
			, scope: this
}] });
        selectWhTree.root.reload();
    }
    selectWhForm.show();
   }
    
/*****选择节点事件******/
function routeTreeCheckChange(node, checked) {
    node.expand();
    node.attributes.checked = checked;
    node.eachChild(function(child) {
        child.ui.toggleCheck(checked);
        child.attributes.checked = checked;
        child.fireEvent('checkchange', child, checked);
    });
    routetree.un('checkchange', routeTreeCheckChange, routetree);
    if(selectAllChNodes)
        checkParentNode(node);
    routetree.on('checkchange', routeTreeCheckChange, routetree);
}

/********选择确定事件********/
function selectWhOk() {
    selectedWhIds = "";
    selectWhNames = "";
    var selectNodes = routetree.getChecked();
    for (var i = 0; i < selectNodes.length; i++) {        
        //只选择叶子节点
        if(!selectPNode){
            if(!selectNodes[i].hasChildNodes()){
                if (selectWhNames != "") {
                    selectWhNames += ",";
                    selectedWhIds += ",";
                }
                selectWhNames += selectNodes[i].text;
                selectedWhIds += selectNodes[i].id;
            }
        }else{
            if (selectWhNames != "") {
                selectWhNames += ",";
                selectedWhIds += ",";
            }
            selectWhNames += selectNodes[i].text;
            selectedRouteIds += selectNodes[i].id;
        }
    }    
}
/*********点击父节点选中所有子节点事件********/
function checkParentNode(currentNode) {
        if (currentNode.parentNode != null) {
            var tempNode = currentNode.parentNode;
            //如果是根节点，就不做处理了
            if (tempNode.parentNode == null)
                return;
            //如果是选择了，那么父节点也必须是出于选择状态的
            if (currentNode.attributes.checked) {
                if (!tempNode.attributes.checked) {
                    tempNode.fireEvent('checkchange', tempNode, true);
                    tempNode.ui.toggleCheck(true);
                    tempNode.attributes.checked = true;

                }
            }
            //取消选择
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