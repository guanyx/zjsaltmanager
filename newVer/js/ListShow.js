

var detailShowPanel = null;
function createShowPanel() {
var viewGrid = new Ext.grid.EditorGridPanel({
	id: 'viewGrid',
	//region:'center',
	split: true,
	store: gridStore,
	autoscroll: true,
	clicksToEdit: 1,
	loadMask: { msg: '正在加载数据，请稍侯……' },
	sm: sm,
	cm: colModel,
	bbar: new Ext.PagingToolbar({
		pageSize: 10,
		store: gridStore,
		displayMsg: '显示第{0}条到{1}条记录,共{2}条',
		emptyMsy: '没有记录',
		displayInfo: true
	}),
	viewConfig: {
		columnsText: '显示的列',
		scrollOffset: 20,
		sortAscText: '升序',
		sortDescText: '降序',
		forceFit: false
	},
	stripeRows: true,
	height: 350,
	width: 800,
	title: '',
	plugins: [headerModel]

});
	detailShowPanel  = new Ext.Window({
	id: 'detailShowPanel'
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
                text: "关闭"
		    ,id:'btnOrgOk'
			, handler: function() {
			    
			  detailShowPanel.hide();
			}
			, scope: this
		}
			, scope: this
}]
});
}
//显示的Grid信息

gridStore.baseParams.ReportView = reportView;