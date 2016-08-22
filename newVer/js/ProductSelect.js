/* 主要处理选择  */
var selectProductTree = null;
var selectedProductID = null;
var selectProductForm = null;
var otherUrlParams = '';
//设置文档目录信息，默认为1层信息
var parentUrl="../CRM/product/frmBaProductClass.aspx?method=getbaproducttypetree";
function showProductForm(parentID, title, url,showForm) {
    //创建机构树信息
    if (selectProductTree == null) {
        var root = new Ext.tree.AsyncTreeNode({
            text: '商品信息',
            draggable: false,
            id: 'source'
        });
        selectProductTree = new Ext.tree.TreePanel({//就是用来呈现树的"控件"吧
            //el: "divTree",//在page中用来渲染的标签(容器)
            useArrows: true,
            autoScroll: true,
            animate: true,
            enableDD: true,
            containerScroll: true,
            //rootVisible: false,
            loader: new Ext.tree.TreeLoader({
                //dataUrl: url, // 'frmAdmProductList.aspx?method=gettreecolumnlist&parent=' + parentID,
                dataUrl:parentUrl
            }),

            root: root
        });




        //在beforeload事件中重设dataUrl，以达到动态加载的目的   
        selectProductTree.on('beforeload', function(node) {
        selectProductTree.loader.dataUrl = parentUrl + '&nodeid=' + node.id + '&nodeType=' + node.attributes.NodeType + '&' + otherUrlParams;
        });
    }
    if(showForm)
    {
    if (selectProductForm == null || typeof (selectProductForm) == "undefined") {//解决创建2个windows问题
        selectProductForm = new Ext.Window({
            id: 'selectProductForm'
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
		, items: selectProductTree
		, buttons: [{
		    text: "确定"
		    ,id:'btnYes'
			, handler: function() {
			    //getProductSelectNodes();
			    selectProductForm.hide();
			    //alert(selectedProductID);
			}
			, scope: this
		},
		{
		    text: "取消"
			, handler: function() {
			    selectedProductID = "";
			    selectProductForm.hide();
			}
			, scope: this
}]
        });
    }
    selectProductForm.show();
    }
}

function getProductSelectNodes() {
    var selectNodes = selectProductTree.getChecked();
    selectedProductID = "";
    for (var i = 0; i < selectNodes.length; i++) {
        if (selectedProductID.length > 0)
            selectedProductID += ",";
        selectedProductID += selectNodes[i].id;
    }
}

//清除所有的选择项
function clearAllSelected(){    
    if(selectProductTree==null)
        return;
    var selectNodes = selectProductTree.getChecked();
    for (var i = 0; i < selectNodes.length; i++) {
        selectNodes[i].ui.toggleCheck(false);
        selectNodes[i].attributes.checked = false;
    }
}