/* 主要处理选择  */
var selectOrgTree = null;
var selectedOrgID = null;
var selectOrgForm = null;
function showOrgForm(parentID, title, url) {
    //创建机构树信息
    if (selectOrgTree == null) {
         var root = new Ext.tree.AsyncTreeNode({
            text: '机构信息',
            draggable: false,
            id: 'source'
        });
        
        selectOrgTree =  new Ext.tree.TreePanel({//就是用来呈现树的"控件"吧
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
        }

        if (selectOrgForm==null||typeof(selectOrgForm) == "undefined") {//解决创建2个windows问题
            selectOrgForm = new Ext.Window({
                id: 'selectOrgForm'
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
		, items: selectOrgTree
		, buttons: [{
                text: "确定"
		    ,id:'btnOrgOk'
			, handler: function() {
			    getOrgSelectNodes();
			    selectOrgForm.hide();
			}
			, scope: this
		},
		{
		    text: "取消"
			, handler: function() {
			    selectedOrgID = "";
			    selectOrgForm.hide();
			}
			, scope: this
}]
});
        }
        selectOrgForm.show();
    }

    function getOrgSelectNodes() {
        var selectNodes = selectOrgTree.getChecked();
        selectedOrgID = "";
        for (var i = 0; i < selectNodes.length; i++) {
            if (selectedOrgID.length > 0)
                selectedOrgID += ",";
            selectedOrgID += selectNodes[i].id;
        }
    }