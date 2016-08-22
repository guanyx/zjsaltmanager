var routetree = null;
var routediv = null;
var routeSelectWin = null;
var callBackHandler = null;
var selectPNode = null;
var selectAllChNodes = null;
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
//缺省构造
function selectRoute(callBackFunction){
    selectRouteTree(false,true,callBackFunction); 
}
/************/
/* selectParent         true:返回付节点值和名称，否则只返回叶子节点值和名称
/* selectAllChildrend   true:选择父节点时将所有子节点全部选中
/* callBackFunction     回调函数 带2个参数： 第一个是values；第二个是texts
/************/
function selectRouteTree(selectParent,selectAllChildrend,callBackFunction) {
    if (routediv == null) {
        routediv = document.createElement('div');
        routediv.setAttribute('id', 'routetreeDiv');
        Ext.getBody().appendChild(routediv);
    }
    var Tree = Ext.tree;
    var parentUrl = '/crm/DefaultFind.aspx?method=getLineTreeByOrg&ShowCheckBox=true';
    if (routetree == null) {
        /***接受界面参数***/
        callBackHandler = callBackFunction;
        selectPNode = selectParent;
        selectAllChNodes = selectAllChildrend;
        /***   end  ***/
        // set the root node
        var root = new Tree.AsyncTreeNode({
            text: '线路情况',
            draggable: false,
            id: '0'
        });
        routetree = new Tree.TreePanel({
            useArrows: true, //是否使用箭头
            autoScroll: true,
            animate: true,
            enableDD: false,
            containerScroll: true,
            loader: new Tree.TreeLoader({
                dataUrl: parentUrl,
                baseAttrs:{ uiProvider: Ext.tree.TreeCheckNodeUI } 
            }),
            root:root
        });
        routetree.on('beforeload', function(node) {
            routetree.loader.dataUrl = parentUrl + '&routeid=' + node.id ;
        });
        routetree.on('checkchange', routeTreeCheckChange, routetree);
    }
    if (routeSelectWin == null) {
        routeSelectWin = new Ext.Window({
            title: '线路信息',
            style: 'margin-left:0px',
            width: 500,
            height: 300,
            constrain: true,
            layout: 'fit',
            plain: true,
            modal: true,
            closeAction: 'hide',
            autoDestroy: true,
            resizable: true,
            items: [routetree]
            , buttons: [{
	            text: "确定"
	            ,id:'btnYes'
		        , handler: function() {
		            selectRouteOk();
		            routeSelectWin.hide();
		        }
		        , scope: this
	        },
	        {
	            text: "取消"
		        , handler: function() {
		            selectedProductID = "";
		            selectRouteNames = "";
		            routeSelectWin.hide();
		        }
		    , scope: this
         }]
        });
        routetree.root.reload();
    }
    routeSelectWin.show();
    
}
var selectedRouteIds = "";
var selectRouteNames = "";
/********选择确定事件********/
function selectRouteOk() {
    selectedRouteIds = "";
    selectRouteNames = "";
    var selectNodes = routetree.getChecked();
    for (var i = 0; i < selectNodes.length; i++) {        
        //只选择叶子节点
        if(!selectPNode){
            if(!selectNodes[i].hasChildNodes()){
                if (selectRouteNames != "") {
                    selectRouteNames += ",";
                    selectedRouteIds += ",";
                }
                selectRouteNames += selectNodes[i].text;
                selectedRouteIds += selectNodes[i].id;
            }
        }else{
            if (selectRouteNames != "") {
                selectRouteNames += ",";
                selectedRouteIds += ",";
            }
            selectRouteNames += selectNodes[i].text;
            selectedRouteIds += selectNodes[i].id;
        }
    }    
    callBackHandler(selectedRouteIds,selectRouteNames);     
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