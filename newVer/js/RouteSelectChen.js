/* 主要处理选择  */
var selectRouteTree = null;
var selectedRouteID = null;
var selectRouteForm = null;
function showRouteForm(parentID, title, url) {
    //创建机构树信息
    if (selectRouteTree == null) {
        var root = new Ext.tree.AsyncTreeNode({
            text: '线路信息',
            draggable: false,
            id: 'source'
        });

        selectRouteTree = new Ext.tree.TreePanel({//就是用来呈现树的"控件"吧
            useArrows: true,
            id:'selectRouteTree',
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
    if (selectRouteForm == null || typeof (selectRouteForm) == "undefined") {//解决创建2个windows问题
        selectRouteForm = new Ext.Window({
            id: 'selectRouteForm'
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
		, items: selectRouteTree
		, buttons: [{
		    text: "确定"
		    , id: 'btnRouteOk'
			, handler: function() {
			    getRouteSelectNodes();
			    selectRouteForm.hide();
			}
			, scope: this
		},
		{
		    text: "取消"
			, handler: function() {
			    selectedRouteID = "";
			    selectRouteForm.hide();
			}
			, scope: this
}]
        });
    }
    selectRouteForm.show();
}

function getRouteSelectNodes() {
    var selectNodes = selectRouteTree.getChecked();
    selectedRouteID = "";
    for (var i = 0; i < selectNodes.length; i++) {
        if (selectedRouteID.length > 0)
            selectedRouteID += ",";
        selectedRouteID += selectNodes[i].id;
    }
}