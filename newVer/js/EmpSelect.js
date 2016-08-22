/* 主要处理选择  */
var selectEmpTree = null;
var selectedEmpID = null;
var selectEmpForm = null;
function showEmpForm(parentID, title, url) {
    //创建机构树信息
    if (selectEmpTree == null) {
        var root = new Ext.tree.AsyncTreeNode({
            text: '员工信息',
            draggable: false,
            id: 'source'
        });
        selectEmpTree = new Ext.tree.TreePanel({//就是用来呈现树的"控件"吧
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
            selectEmpTree.on('beforeload',function(node){
            selectEmpTree.loader.dataUrl =url+'&nodeid=' + node.id + '&nodeType=' + node.attributes.NodeType;   
            });   
        }

        if (selectEmpForm == null || typeof (selectEmpForm) == "undefined") {//解决创建2个windows问题
            selectEmpForm = new Ext.Window({
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
		, items: selectEmpTree
		, buttons: [{
		    text: "确定",
		    id:'btnOk',
		    name:'btnOk'
			, handler: function() {
			    //getSelectNodes();
			    selectEmpForm.hide();
			}
			, scope: this
		},
		{
		    text: "取消"
			, handler: function() {
			    selectedEmpID = "";
			    selectEmpForm.hide();
			}
			, scope: this
}]
            });
        }
        selectEmpForm.show();
    }

    function getSelectNodes() {
        var selectNodes = selectEmpTree.getChecked();
        selectedEmpID = "";
        for (var i = 0; i < selectNodes.length; i++) {
            if (selectedEmpID.length > 0)
                selectedEmpID += ",";
            selectedEmpID += selectNodes[i].id;
        }
    }