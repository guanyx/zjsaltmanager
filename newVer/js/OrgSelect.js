/* 主要处理选择  */
var selectOrgTree = null;
var selectedOrgID = null;
var selectOrgForm = null;
function showForm(parentID, title, url) {
    //创建机构树信息
    if (selectOrgTree == null) {
        selectOrgTree = new Ext.ux.tree.ColumnTree({
            width: 800,
            height: 300,
            rootVisible: false,
            autoScroll: true,
            title: '资源信息',
            
            //renderTo: 'div',
            id: 'treeColumn',

            columns: [{
                header: '机构名称',
                width: 220,
                dataIndex: 'text'
            }, {
                header: '机构代码',
                width: 100,
                dataIndex: 'CustomerColumn'
            }, {
                header: '机构地址',
                width: 200,
                dataIndex: 'CustomerColumn1'
            }, {
                header: '机构邮编',
                width: 200,
                dataIndex: 'CustomerColum2'
}],

                loader: new Ext.tree.TreeLoader({
                    dataUrl: url, // 'frmAdmOrgList.aspx?method=gettreecolumnlist&parent=' + parentID,
                    uiProviders: {
                        'col': Ext.ux.tree.ColumnNodeUI
                    }
                }),

                root: new Ext.tree.AsyncTreeNode({
                    text: 'Tasks'
                })
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