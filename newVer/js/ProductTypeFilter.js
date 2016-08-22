/******************************************************************
产品选择过滤界面，
1.在统计时，可以选择产品大类，也可以选择产品小类信息；

*******************************************************************/

/* 主要处理选择  */
var selectProductFilterTree = null;
var selectedProductFilterID = null;
var selectProductFilterForm = null;
var defaultUrl = '../CRM/product/frmBaProductClass.aspx?method=getbaproducttypefiltertree';
function showProductFilterForm(parentID, title, url, showForm) {        
    //创建机构树信息
    if (selectProductFilterTree == null) {
        if(url.length>0)
            defaultUrl = url;
            alert(defaultUrl);
        var root = new Ext.tree.AsyncTreeNode({
            text: '商品信息',
            draggable: false,
            id: 'source'
        });
        selectProductFilterTree = new Ext.tree.TreePanel({//就是用来呈现树的"控件"吧
            //el: "divTree",//在page中用来渲染的标签(容器)
            useArrows: true,
            autoScroll: true,
            animate: true,
            enableDD: true,
            containerScroll: true,
            //rootVisible: false,
            loader: new Ext.tree.TreeLoader({
                //dataUrl: url, // 'frmAdmProductList.aspx?method=gettreecolumnlist&parent=' + parentID,
            dataUrl:defaultUrl
            }),

            root: root
        });




        //在beforeload事件中重设dataUrl，以达到动态加载的目的
        selectProductFilterTree.on('beforeload', function(node) {
        selectProductFilterTree.loader.dataUrl = defaultUrl+'&nodeid=' + node.id + '&nodeType=' + node.attributes.NodeType;
        });
    }
    if (showForm) {
        if (selectProductFilterForm == null || typeof (selectProductFilterForm) == "undefined") {//解决创建2个windows问题
            selectProductFilterForm = new Ext.Window({
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
		, items: selectProductFilterTree
		, buttons: [{
		    text: "确定"
			, handler: function() {
			    //getProductSelectNodes();
		        selectProductFilterForm.hide();
			    //alert(selectedProductID);
			}
			, scope: this
		},
		{
		    text: "取消"
			, handler: function() {
		        selectedProductFilterID = "";
			    selectProductFilterForm.hide();
			}
			, scope: this
}]
            });
        }
        selectProductFilterForm.show();
    }
}

function getProductSelectNodes() {
    var selectNodes = selectProductFilterTree.getChecked();
    selectedProductFilterID = "";
    for (var i = 0; i < selectNodes.length; i++) {
        if (selectedProductFilterID.length > 0)
            selectedProductFilterID += ",";
        selectedProductFilterID += selectNodes[i].id;
    }
}