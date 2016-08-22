/* 主要处理选择  */
var selectReportTypeTree = null;
var selectedReportTypeID = null;
var selectReportTypeForm = null;
var otherReportUrlParams = '';
//设置文档目录信息，默认为1层信息
var parentReportUrl="../../../crm/product/frmBaProductTypeForPlan.aspx?method=gettreelist";
function showReportTypeForm(parentID, title, url,showForm) {
    //创建机构树信息
    if (selectReportTypeTree == null) {
        var root1 = new Ext.tree.AsyncTreeNode({
            text: '报表分类信息',
            draggable: false,
            id: 'source'
        });
        selectReportTypeTree = new Ext.tree.TreePanel({//就是用来呈现树的"控件"吧
            //el: "divTree",//在page中用来渲染的标签(容器)
            useArrows: true,
            autoScroll: true,
            animate: true,
            enableDD: true,
            containerScroll: true,
            //rootVisible: false,
//            loader: new Ext.tree.TreeLoader({
//                //dataUrl: url, // 'frmAdmProductList.aspx?method=gettreecolumnlist&parent=' + parentID,
//                dataUrl:parentUrl
//            }),

            loader: new Ext.tree.TreeLoader({
               dataUrl:parentReportUrl,
               baseParams:{
                    orgId:1,
                    isAll:true,
                    isPlanType:false
               }}),
            root: root1
        });




        //在beforeload事件中重设dataUrl，以达到动态加载的目的   
//        selectReportTypeTree.on('beforeload', function(node) {
//        selectReportTypeTree.loader.dataUrl = parentReportUrl + '&nodeid=' + node.id + '&nodeType=' + node.attributes.NodeType + '&' + otherUrlParams;
//        });
    }
    if(showForm)
    {
    if (selectReportTypeForm == null || typeof (selectReportTypeForm) == "undefined") {//解决创建2个windows问题
        selectReportTypeForm = new Ext.Window({
            id: 'selectReportTypeForm'
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
		, items: selectReportTypeTree
		, buttons: [{
		    text: "确定"
		    ,id:'btnYes'
			, handler: function() {
			    //getProductSelectNodes();
			    selectReportTypeForm.hide();
			    //alert(selectedProductID);
			}
			, scope: this
		},
		{
		    text: "取消"
			, handler: function() {
			    selectedReportTypeID = "";
			    selectReportTypeForm.hide();
			}
			, scope: this
}]
        });
    }
    selectReportTypeForm.show();
    }
}

function getReportTypeSelectNodes() {
    var selectNodes = selectReportTypeTree.getChecked();
    selectedReportTypeID = "";
    for (var i = 0; i < selectNodes.length; i++) {
        if (selectedReportTypeID.length > 0)
            selectedReportTypeID += ",";
        selectedReportTypeID += selectNodes[i].id;
    }
}

//清除所有的选择项
function clearAllSelected(){    
    if(selectReportTypeTree==null)
        return;
    var selectNodes = selectReportTypeTree.getChecked();
    for (var i = 0; i < selectNodes.length; i++) {
        selectNodes[i].ui.toggleCheck(false);
        selectNodes[i].attributes.checked = false;
    }
}