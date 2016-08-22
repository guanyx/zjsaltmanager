/* 主要处理选择  */
var selectStaTree = null;
var selectedStaID = null;
var selectStaForm = null;
function showStaForm() {
    //创建机构树信息
    if (selectStaTree == null) {
         var root = new Ext.tree.TreeNode({
            text: '统计对比类型'
        });
        
        selectStaTree =  new Ext.tree.TreePanel({//就是用来呈现树的"控件"吧
            //el: "divTree",//在page中用来渲染的标签(容器)
            useArrows: true,
            autoScroll: true,
            animate: true,
            enableDD: true,
            //containerScroll: true,

                root: root
            });
            
            addStaTypeNode(root);
        }        
        
        if (selectStaForm==null||typeof(selectStaForm) == "undefined") {//解决创建2个windows问题
            selectStaForm = new Ext.Window({
                id: 'selectStaForm'
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
		, items: selectStaTree
		, buttons: [{
		    text: "确定"
			, handler: function() {
			    selectStaForm.hide();
			}
			, scope: this
		},
		{
		    text: "取消"
			, handler: function() {
			    selectedStaID = "";
			    selectStaForm.hide();
			}
			, scope: this
}]
});
        }
        selectStaForm.show();
    }
    
    function addStaTypeNode(root)
        {
            root.appendChild(addNode('同期','同期'));
            root.appendChild(addNode('上一期','上一期'));
            root.appendChild(addNode('同比','同比'));
            root.appendChild(addNode('环比','环比'));
        }
        
        function addNode(nodeText,nodeId)
        {
                var node = new Ext.tree.TreeNode({
                    text: nodeText,
                    iconCls:'cmp',
                    cls:'cmp',
                    type:'cmp',
                    id: nodeId,
                    checked:false
                });
                return node;
        }