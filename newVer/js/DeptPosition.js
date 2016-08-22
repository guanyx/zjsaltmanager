/* 主要处理选择  */
var selectPositionTree = null;
var selectPositionForm = null;
function showPositionForm(parentID, title, url) {
    //创建机构树信息
    if (selectPositionTree == null) {
        var root = new Ext.tree.AsyncTreeNode({
            text: '部门岗位信息',
            draggable: false,
            id: 'source'
        });
        selectPositionTree = new Ext.tree.TreePanel({//就是用来呈现树的"控件"吧
            //el: "divTree",//在page中用来渲染的标签(容器)
            useArrows: true,
            autoScroll: true,
            animate: true,
            enableDD: true,
            containerScroll: true,
            //rootVisible: false,
            loader: new Ext.tree.TreeLoader({
                //dataUrl: url, // 'frmAdmEmpList.aspx?method=gettreecolumnlist&parent=' + parentID,
                dataUrl: url
            }),

            root: root
        });




        //在beforeload事件中重设dataUrl，以达到动态加载的目的
        selectPositionTree.on('beforeload', function(node) {
        selectPositionTree.loader.dataUrl = url + '&nodeid=' + node.id + '&nodeType=' + node.attributes.NodeType;
        });
    }

    if (selectPositionForm == null || typeof (selectPositionForm) == "undefined") {//解决创建2个windows问题
        selectPositionForm = new Ext.Window({
            id: 'selectEmpForm'
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
		, items: selectPositionTree
		, buttons: [{
		    text: "确定",
		    id: 'btnOk',
		    name: 'btnOk'
			, handler: function() {
			    //getSelectNodes();
		    selectPositionForm.hide();
			}
			, scope: this
		},
		{
		    text: "取消"
			, handler: function() {
		        selectPositionForm.hide();
			}
			, scope: this
}]
        });
    }
    selectPositionForm.show();
}

function getSelectNodes() {
    var selectNodes = selectPositionForm.getChecked();
        if(selectNodes.length>0)
            return selectNodes[0];
    }