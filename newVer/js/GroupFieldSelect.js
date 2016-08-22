var otherParams='';
var groupStore = new Ext.data.SimpleStore({
    fields: ['FieldName', 'AsName', 'GroupType'],
    data: [
   ['3', '大于', '=']
   ]
});

var dateFieldStore = new Ext.data.SimpleStore({
    fields: ['FieldName', 'AsName', 'GroupType'],
    data: [
   ['3', '大于', '=']
   ]
});

var yearGroupStore = new Ext.data.SimpleStore({
    fields: ['id', 'name'],
    data: [
   ['1', '一月']
   ]
});
var yearRowGroupPatter = Ext.data.Record.create([
           { name: 'id', type: 'string' },
           { name: 'name', type: 'string' }
          ]);
           yearGroupStore.removeAll();
var currentYear = (new Date()).getFullYear();
currentYear = parseInt(currentYear) + 1;
for (var i = 2009; i < currentYear; i++) {
    var year = new yearRowGroupPatter({ id: i, name: i });
    yearGroupStore.add(year);
}

var dateTypeGroupStore = new Ext.data.SimpleStore({
    fields: ['id', 'name'],
    data: [
   ['2', '按年'],
   ['3', '按季度'],
   ['4', '按月度']
   ]
});

var monthGroupStore = new Ext.data.SimpleStore({
    fields: ['id', 'name'],
    data: [
   ['1', '一月'],
   ['2', '二月'],
   ['3', '三月'],
   ['4', '四月'],
   ['5', '五月'],
   ['6', '六月'],
   ['7', '七月'],
   ['8', '八月'],
   ['9', '九月'],
   ['10', '十月'],
   ['11', '十一月'],
   ['12', '十二月']
   ]
});

var quarterlyGroupStore = new Ext.data.SimpleStore({
    fields: ['id', 'name'],
    data: [
   ['1', '第一季度'],
   ['2', '第二季度'],
   ['3', '第三季度'],
   ['4', '第四季度']
   ]
});

var sumStore = new Ext.data.SimpleStore({
    fields: ['FieldName', 'AsName', 'GroupType'],
    data: [
   ['3', '大于', '=']
   ]
});
var compareTypeStore = new Ext.data.SimpleStore({
    fields: ['id', 'name'],
    data: [
    ['0','无'],
   ['SamePeriod', '同期'],
   ['LastPeriod', '上期'],
   ['MonthPeriod', '月度'],
   ['QuarterlyPeriod', '季度']
   ]
});

var groupTypeStore = new Ext.data.SimpleStore({
    fields: ['id', 'name','GroupType'],
    data: [
   ['0', '无',""],
   ['1', '合计',"Sum"],
   ['2', '最大',"Max"],
   ['3', '最小',"Min"],
   ['4', '平均',"Avg"]
   ]
});

//时间方式
var cmbGroupDateType = new Ext.form.ComboBox({
    id: 'cmbGroupDateType',
    store: dateTypeGroupStore, // 下拉数据           
    displayField: 'name', //显示上面的fields中的state列的内容,相当于option的text值        
    valueField: 'id', // 选项的值, 相当于option的value值        
    name: 'cmbGroupDateType',
    mode: 'local', // 必须要,如果为 remote, 则会用ajax获取数据        
    triggerAction: 'all', // 点击下拉的时候, all 为展出所有Store中data的数据        
    readOnly: true, // 如果设为true,则好像一般的下拉框一样，默认是false,可输入并自动匹配        
    emptyText: '请选择比较类型',
    width: 100,
    editable: false,
    selectOnFocus: true
});
cmbGroupDateType.on("select", dataTypeGroupChange);

function dataTypeGroupChange() {
    switch (cmbGroupDateType.getValue()) {
        //按年度 
        case "2":
            //cmbDateType.setVisible(true);
            cmbGroupMonth.setVisible(false);
            cmbGroupQuarterly.setVisible(false);
            cmbGroupYear.setVisible(true);
            break;
        //按季度 
        case "3":
            cmbGroupMonth.setVisible(false);
            cmbGroupQuarterly.setVisible(true);
            cmbGroupYear.setVisible(true);
            break;
        //按月度 
        case "4":
            cmbGroupMonth.setVisible(true);
            cmbGroupQuarterly.setVisible(false);
            cmbGroupYear.setVisible(true);
            break;
    }
}

//时间方式
var cmbGroupYear = new Ext.form.ComboBox({
    id: 'cmbGroupYear',
    store: yearGroupStore, // 下拉数据           
    displayField: 'name', //显示上面的fields中的state列的内容,相当于option的text值        
    valueField: 'id', // 选项的值, 相当于option的value值        
    name: 'cmbGroupYear',
    mode: 'local', // 必须要,如果为 remote, 则会用ajax获取数据        
    triggerAction: 'all', // 点击下拉的时候, all 为展出所有Store中data的数据        
    //readOnly: true, // 如果设为true,则好像一般的下拉框一样，默认是false,可输入并自动匹配        
    emptyText: '请选择年度',
    width: 100,
    hidden: true,
    //editable:false,   
    selectOnFocus: true
});

//时间方式
var cmbGroupMonth = new Ext.form.ComboBox({
    id: 'cmbGroupMonth',
    store: monthGroupStore, // 下拉数据           
    displayField: 'name', //显示上面的fields中的state列的内容,相当于option的text值        
    valueField: 'id', // 选项的值, 相当于option的value值        
    name: 'cmbGroupMonth',
    mode: 'local', // 必须要,如果为 remote, 则会用ajax获取数据        
    triggerAction: 'all', // 点击下拉的时候, all 为展出所有Store中data的数据        
    readOnly: true, // 如果设为true,则好像一般的下拉框一样，默认是false,可输入并自动匹配        
    emptyText: '请选择比较类型',
    width: 100,
    hidden: true,
    editable: false,
    selectOnFocus: true
});

//季度方式
var cmbGroupQuarterly = new Ext.form.ComboBox({
    id: 'cmbGroupQuarterly',
    store: quarterlyGroupStore, // 下拉数据           
    displayField: 'name', //显示上面的fields中的state列的内容,相当于option的text值        
    valueField: 'id', // 选项的值, 相当于option的value值        
    name: 'cmbGroupQuarterly',
    mode: 'local', // 必须要,如果为 remote, 则会用ajax获取数据        
    triggerAction: 'all', // 点击下拉的时候, all 为展出所有Store中data的数据        
    readOnly: true, // 如果设为true,则好像一般的下拉框一样，默认是false,可输入并自动匹配        
    emptyText: '请选择比较类型',
    width: 100,
    
    hidden: true,
    editable: false,
    selectOnFocus: true
});
var combogroupType = new Ext.form.ComboBox({
id: 'combogroupType12',
store: groupTypeStore, // 下拉数据           
    displayField: 'name', //显示上面的fields中的state列的内容,相当于option的text值
    valueField: 'GroupType', // 选项的值, 相当于option的value值
    name: 'combogroupType12',
    mode: 'local', // 必须要,如果为 remote, 则会用ajax获取数据        
    triggerAction: 'all', // 点击下拉的时候, all 为展出所有Store中data的数据        
    readOnly: true, // 如果设为true,则好像一般的下拉框一样，默认是false,可输入并自动匹配        
    emptyText: '请选择统计类型',
    width: 100,
    editable: false,
    selectOnFocus: true
});  

var labelCompare = new Ext.form.Label({ text: '对比方式' });
var comboStaticType = new Ext.form.ComboBox({
    id: 'comboCompareType12',
    store: compareTypeStore, // 下拉数据           
    displayField: 'name', //显示上面的fields中的state列的内容,相当于option的text值        
    valueField: 'id', // 选项的值, 相当于option的value值
    name: 'comboCompareType12',
    mode: 'local', // 必须要,如果为 remote, 则会用ajax获取数据        
    triggerAction: 'all', // 点击下拉的时候, all 为展出所有Store中data的数据        
    readOnly: true, // 如果设为true,则好像一般的下拉框一样，默认是false,可输入并自动匹配        
    emptyText: '请选择统计类型',
    width: 100,
    editable: false,
    selectOnFocus: true
});

comboStaticType.on("select", staticTypeGroupChange);
function staticTypeGroupChange() {
    switch (comboStaticType.getValue()) {
        //无
        case "0":
            //cmbDateType.setVisible(true);
            cmbGroupDateType.setVisible(false);
            cmbGroupMonth.setVisible(false);
            cmbGroupQuarterly.setVisible(false);
            cmbGroupYear.setVisible(true);
            break;
        case "SamePeriod":
        case "LastPeriod":
            cmbGroupDateType.setVisible(true);
            cmbGroupMonth.setVisible(false);
            cmbGroupQuarterly.setVisible(false);
            cmbGroupYear.setVisible(false);
            break;
        //按季度
        case "MonthPeriod":
        case "QuarterlyPeriod":
            cmbGroupDateType.setVisible(false);
            cmbGroupMonth.setVisible(false);
            cmbGroupQuarterly.setVisible(false);
            cmbGroupYear.setVisible(true);
            break;
    }
}

var comboDateField = new Ext.form.ComboBox({
    id: 'comboDateField',
    store: dateFieldStore, // 下拉数据           
    displayField: 'AsName', //显示上面的fields中的state列的内容,相当于option的text值
    valueField: 'FieldName', // 选项的值, 相当于option的value值
    name: 'comboDateField',
    mode: 'local', // 必须要,如果为 remote, 则会用ajax获取数据        
    triggerAction: 'all', // 点击下拉的时候, all 为展出所有Store中data的数据        
    readOnly: true, // 如果设为true,则好像一般的下拉框一样，默认是false,可输入并自动匹配        
    emptyText: '请选择时间对比字段',
    width: 100,
    editable: false,
    selectOnFocus: true
}); 

function getGroupStore() {
    groupStore.removeAll();
    //获取分组数据
    var selectNodes = treeGroupBy.getChecked();
    for(var i=0;i<selectNodes.length;i++)
    {
        var groupRow = new groupStore.recordType({
            FieldName: selectNodes[i].id,
            AsName: selectNodes[i].text,
            GroupType: 'Group By'
        });
        groupStore.add(groupRow);
    }

    for (var i = 0; i < sumStore.getCount(); i++) {
        if (sumStore.data.items[i].data.GroupType != '') {
            var groupRow = new groupStore.recordType({
            FieldName: sumStore.data.items[i].data.FieldName,
            AsName: sumStore.data.items[i].data.AsName,
            GroupType: sumStore.data.items[i].data.GroupType
        });
        groupStore.add(groupRow);
        }
    }
    //获取统计数据
//    selectNodes = treeGroupSum.getChecked();
//    if (selectNodes.length > 0) {
//        for (var i = 0; i < selectNodes.length; i++) {
//            var sumRow = new groupStore.recordType({
//                FieldName: selectNodes[i].id,
//                AsName: selectNodes[i].text,
//                GroupType: 'Sum'
//            });
//            groupStore.add(sumRow);
//        }
//    } 
//    else {

//}
if (chbFieldCountValue.getValue()) {
    var countField="";
    for (var i = 0; i < treeGroupBy.root.childNodes.length; i++) {
        if (!treeGroupBy.root.childNodes[i].checked) {
            countField = treeGroupBy.root.childNodes[i].id;
        }
    }
    if (countField == "")
        return;
    var countRow = new groupStore.recordType({
        FieldName: _grid.getStore().fields.items[0].name,
        AsName: '计数',
        GroupType: 'Count'
    });
    groupStore.add(countRow);
}

//设置时间对比信息
var dateFieldValue = comboDateField.getValue();
if (dateFieldValue != '') {
    var compareTypeValue = comboStaticType.getValue();
    var dateValue = getDateRow(compareTypeValue);
    if (dateValue != null) {
        if (compareTypeValue != '0') {
            var countRow = new groupStore.recordType({
                FieldName: dateFieldValue,
                AsName: dateFieldValue,
                GroupType: compareTypeValue
            });
            groupStore.add(countRow);
            groupStore.add(dateValue);
        }
    }
}
    return groupStore;
}

function getDateRow(type) {
    var year = cmbGroupYear.getValue();
    if (year == "")
        return null;
    var month = cmbGroupMonth.getValue();
    var qu = cmbGroupQuarterly.getValue();
    var dateType = '';
    var startDate = ''
    switch (type) {
        case "SamePeriod":
        case "LastPeriod":
            switch (cmbGroupDateType.getValue()) {
                //按年   
                case "2":
                    if (year == '')
                        year = currentYear;
                    startDate = year + '-01-01';
                    dateType = "Year";
                    break;
                //按季度  
                case "3":
                    if (cmbGroupQuarterly.getValue() == '')
                        return null;
                    startDate = year +'-'+ ((parseInt(cmbGroupQuarterly.getValue()) - 1) * 3+1) + '-1';
                    dateType = "Quarterly";
                    break;
                //按月度  
                case "4":
                    if (cmbGroupMonth.getValue() == '')
                        return null;
                    startDate = year +'-'+ cmbGroupMonth.getValue() + '-1';
                    dateType = "Month";
                    break;
            }
            break;
        case "MonthPeriod":
            startDate = year + '-01-01';
            dateType = "Month";
            break;
        case "QuarterlyPeriod":
            startDate = year + '-01-01';
            dateType = "Quarterly";
            break;
    }
    return new groupStore.recordType({
        FieldName: dateType,
        AsName: startDate,
        GroupType: 'Date'
    });
    
}

var ds = new Ext.data.ArrayStore({
    data: [[123, 'One Hundred Twenty Three'],
            ['1', 'One'], ['2', 'Two'], ['3', 'Three'], ['4', 'Four'], ['5', 'Five'],
            ['6', 'Six'], ['7', 'Seven'], ['8', 'Eight'], ['9', 'Nine']],
    fields: ['value', 'text'],
    sortInfo: {
        field: 'value',
        direction: 'ASC'
    }
});
var _grid;
var _tempColModel;
var _toolBar;
var _gridDiv;
function iniSelectColumn(tbar,gridDive) {    
    if (treeGroupBy.root.childNodes.length > 0) {
        return;
    }
    _gridDiv=gridDive;
    _toolBar = tbar;
    var tb = new Ext.Toolbar.SplitButton();
    if(typeof(schemeGridData)=='undefined')
    {
        tb = new Ext.Toolbar.Button();        
    }
    else
    {
        tb.menu = createSchemeMenu();
    }
    tb.text="创建统计";
    tbar.addButton(tb);
    tb.on('click', showForm);
    
    tb = new Ext.Toolbar.SplitButton();
    tb.text = "取消统计";
    tb.menu = createMenu();
    tbar.addButton(tb);
    tb.setDisabled(true);
    tb.on('click', hideForm);

    
    tbar.render();   
}
function createSchemeMenu()
{
    var menu = new Ext.menu.Menu({
        id: 'schemeMenu',
        style: {
            overflow: 'visible'
       },
       items: [
       {
           text: '统计方案选择',
           handler: schemeShow
        },{
           text: '统计方案保存',
           handler: schemeSave
        }]});
     return menu;
}
function createMenu()
{
	var menu = new Ext.menu.Menu({
        id: 'mainMenu',
        style: {
            overflow: 'visible'
       },
       items: [
       	{
           text: '打印结果',
           handler: printResult
        },
	{
           text: '导出结果',
           handler: expertResult
        },
	{
           text: '图表结果',
           menu: ['<b >单选</b>', 
                      { 

                          text: '折线图', 
                          checked: false, 
                          group: 'theme', 
                          //handler:onItemCheck 
                          listeners: {
                              checkchange: function(item, state){
                                if(state){
                                   onItemCheck(item);
                                }
                              }
                         }
                      }, { 

                          text: '饼图', 
                          checked: false, 
                          group: 'theme', 
                          //checkHandler:onItemCheck 
                          listeners: {
                              checkchange: function(item, state){
                                if(state){
                                   onItemCheck(item);
                                }
                              }
                         }
                      }, { 

                          text: '柱状图', 
                          checked: true, 
                          group: 'theme', 
                          //checkHandler:onItemCheck 
                          listeners: {
                              checkchange: function(item, state){
                                if(state){
                                   onItemCheck(item);
                                }
                              }
                         }
                      }]
        }]});
	return menu;
}
var graphType = 'Column'
function onItemCheck(o)
{
    switch(o.text)
    {
        case"折线图":
            graphType="Line";
            updateGraph();
            break;
        case"饼图":
            graphType="Pie";
            updateGraph();
            break;
        case"柱状图":
            graphType="Column";
            updateGraph();
            break;
    }
}
var schemeWindow;
var schemeGrid=null;
var sm1 = new Ext.grid.CheckboxSelectionModel({
        singleSelect: true
    });
var schemeEntityWindow = null;
function schemeSave()
{
    if(schemeEntityWindow==null)
    {
       var schemeDiv = new Ext.form.FormPanel({
	            region:'center',
	            frame: true,
	            id: "rolediv",
	            //title:'角色信息',
	            items: [
		{
		    xtype: 'textfield',
		    fieldLabel: '方案名称',
		    columnWidth: 1,
		    anchor: '90%',
		    name: 'SchemeName',
		    id: 'SchemeName',
		    hide: true
		}
        , {
            xtype: 'textfield',
            fieldLabel: '方案备注',
            columnWidth: 1,
            anchor: '90%',
            name: 'Memo',
            id: 'Memo'
        }]});
       schemeEntityWindow = new Ext.Window({
            id: 'schemeEntityShow'
                , title: ''
		        , iconCls: 'upload-win'
		        , width: 450
		        , height: 150
		        , layout: 'border'
		        , plain: true
		        , modal: true
		        , x: 50
		        , y: 50
		        , constrain: true
		        , resizable: false
		        , closeAction: 'hide'
		        , autoDestroy: true
		        , items: schemeDiv
		        , buttons: [{
		            text: "保存"
			        , handler: function() {
			                if (testUrl == '') {
			                    testUrl = _grid.getStore().url;
			                }
			                var json = "";
			                groupStore.each(function(groupStore) {
			                    json += Ext.util.JSON.encode(groupStore.data) + ',';
			                });
			                if(json=="")
			                {
			                    Ext.Msg.alert('没有任何的统计项！');
			                    return;
			                }
			                
			                var filter = getFilterStr();
			                var conn = new Ext.data.Connection();
			                var url = testUrl.substring(0, testUrl.indexOf(".aspx")) + ".aspx?method=saveScheme";
                            conn.request({ url: url, params: {DefaultFilter:filter,SchemeName:Ext.getCmp('SchemeName').getValue(),Memo:Ext.getCmp('Memo').getValue(),ViewName:reportViewName, groupBy: json}, callback: function(options, success, response) {
                                        var resu = Ext.decode(response.responseText);
                                        Ext.Msg.alert('提示消息',resu.errorinfo);
                                    }
                                });
                                schemeEntityWindow.hide();
			           
			        }
		        },
		        {
		            text: "取消"
			        , handler: function() {
			            schemeEntityWindow.hide();
			        }
			        , scope: this
        }]
       });
    }
    else
    {
        Ext.getCmp('SchemeName').setValue('');
        Ext.getCmp('Memo').setValue('');
    }
    schemeEntityWindow.show();
}
function schemeShow()
{
    if(schemeGrid==null)
    {
        if(schemeGridData==null)
            return;
        schemeGrid = new Ext.grid.GridPanel({
	    width:'100%',
	    height:'100%',
	    autoWidth:true,
	    autoHeight:true,
	    autoScroll:true,
	    layout: 'fit',
	    id: 'schemeGrid',
	    region: "center",
	    store: schemeGridData,
	    loadMask: {msg:'正在加载数据，请稍侯……'},
	    sm:sm1,
	    cm: new Ext.grid.ColumnModel([
		    sm1,
		    new Ext.grid.RowNumberer(),//自动行号
		    {
			    header:'方案名称',
			    dataIndex:'SchemeName',
			    id:'SchemeName'
		    },
		    {
			    header:'方案备注',
			    dataIndex:'SchemeMemo',
			    id:'SchemeMemo'
		    },
		    {
			    header:'方案类别',
			    dataIndex:'SchemeType',
			    id:'SchemeType'
		    }]),
		    tbar:[{
                id: 'delScheme',
                text: '<font color="red">删除统计方案</font>',
                iconCls: 'add',
                handler: function() {
                    //获取选择的数据信息getSelectionModel().deselectRow(linenum);
                    var sm = Ext.getCmp('schemeGrid').getSelectionModel();
                    var selectData = sm.getSelected();
                    if(selectData!=null)
                    {	                    
	                    //删除前再次提醒是否真的要删除
	                    Ext.Msg.confirm("提示信息","是否真的要删除选择的方案信息吗？",function callBack(id){
		                    //判断是否删除数据
		                    if(id=="yes")
		                    {
		                        if (testUrl == '') {
			                    testUrl = _grid.getStore().url;
			                }
			                    //页面提交
			                    Ext.Ajax.request({
				                    url:testUrl.substring(0,testUrl.indexOf(".aspx")) + ".aspx?method=deletscheme",
				                    method:'POST',
				                    params:{
					                    SchemeId:selectData.data.SchemeId
				                    },
				                    success: function(resp,opts){
					                    Ext.Msg.alert("提示","数据删除成");
					                    schemeGridData.load();
				                    },
				                    failure: function(resp,opts){
					                    Ext.Msg.alert("提示","数据删除失败");
				                    }
			                    });
		                    }
	                    });
	                }
                }
}],
		    bbar: new Ext.PagingToolbar({
			    pageSize: 100,
			    store: schemeGridData,
			    displayMsg: '显示第{0}条到{1}条记录,共{2}条',
			    emptyMsy: '没有记录',
			    displayInfo: true
		    }),
		    viewConfig: {
			    columnsText: '显示的列',
			    scrollOffset: 20,
			    sortAscText: '升序',
			    sortDescText: '降序',
			    forceFit: true
		    },
		    height: 180,
		    closeAction: 'hide',
		    stripeRows: true,
		    loadMask: true,
		    autoExpandColumn: 2
	    });
	    
	    schemeWindow = new Ext.Window({
            id: 'schemeGridShow'
                , title: ''
		        , iconCls: 'upload-win'
		        , width: 450
		        , height: 300
		        , layout: 'border'
		        , plain: true
		        , modal: true
		        , x: 50
		        , y: 50
		        , constrain: true
		        , resizable: false
		        , closeAction: 'hide'
		        , autoDestroy: true
		        , items: schemeGrid
		        , buttons: [{
		            text: "确定"
			        , handler: function() {
			                if (testUrl == '') {
			                    testUrl = _grid.getStore().url;
			                }
			                _grid.getStore().proxy.conn.url = testUrl.substring(0, testUrl.indexOf(".aspx")) + ".aspx?method=getgroupby";
			                var sm = Ext.getCmp('schemeGrid').getSelectionModel();
                            //获取选择的数据信息
                            var selectData = sm.getSelected();
                            if(selectData!=null)
                            {
			                    createDataGrid(testUrl.substring(0, testUrl.indexOf(".aspx")) + ".aspx?method=getgroupby",selectData.data.SchemeId,"");
			                    schemeWindow.hide();
			                    for (var i = 0; i < _toolBar.items.items.length-3; i++) {
                                    _toolBar.items.items[i].setDisabled(true);
                                }
                                _toolBar.items.items[_toolBar.items.items.length - 1].setDisabled(false);
			                }
			           
			        }
		        },
		        {
		            text: "取消"
			        , handler: function() {
			            schemeWindow.hide();
			        }
			        , scope: this
        }]
       });
    }
    schemeGridData.load();
    schemeWindow.show();
}
function showGraph()
{
    updateGraph();
}
function expertResult(type) {
    var vExportContent = grid.getExcelXml();
    type ="server";
    if(undefined==type)
    {
    var w = window.open("about:blank", "Excel", "");
//    w.document.writeln("<head>");
//    w.document.writeln("<meta http-equiv=\"Content-Type\" content=\"application/xhtml+xml;charset=utf-8\" />");
//    w.document.writeln("</head>");
    //w.document.location = 'data:application/vnd.ms-excel;base64,' + Base64.encode(vExportContent);
    w.document.write(vExportContent);
//    //Ext.Msg.hide();
    w.document.execCommand('Saveas', false, 'C:\\log.xls');
//    w.close();

//    } else {
//        document.location = 'data:application/vnd.ms-excel;base64,' + Base64.encode(vExportContent);
//    }
    }else{
        if (!Ext.fly('frmDummyee')) {
                var frm = document.createElement('form');
                frm.id = 'frmDummyee';
                frm.name = id;
                frm.className = 'x-hidden';
                document.body.appendChild(frm);
            }
        Ext.Ajax.request({
            url: '/rpt/fm/ExportService.aspx',//将生成的xml发送到服务器端
            method: 'POST',
            form: Ext.fly('frmDummyee'),
            callback: function(o, s, r) {
                Ext.Msg.hide();//alert(r.responseText);
            },
            isUpload: true,
            params: { ExportContent: vExportContent, ExportFile: grid.id + '.xls' }
        });
        Ext.Msg.hide();
    }

}
function printResult()
{
      var printControl = parent.parent.parent.document.getElementById("topFrame").contentWindow.getPrintControl();
      printControl.OnePageNum = 1;
      printControl.GridData = JsonToXml(grid.store, grid.colModel);
      printControl.GridStyle = ColMolToXml(grid.colModel);
      printControl.GridTitle = '';
      printControl.PrintGrid();
}

function showForm() {
    if(typeof(schemeGridData)!='undefined')
    {
        schemeGridData.load();
    }
    groupFieldSelect.show();
    if (treeGroupBy.root.childNodes.length > 0) {
    }
    else {
        var store = _grid.getStore();
        var cm = _grid.getColumnModel();
        _tempColModel = cm;
        sumStore.removeAll();
        dateFieldStore.removeAll();
        for (var i = 0; i < cm.getColumnCount(); i++) {
            if (cm.getDataIndex(i) != "") {
                if (!cm.isHidden(i)) {
                    if (cm.getColumnHeader(i) != "") {
                        var fld = store.recordType.prototype.fields.get(cm.getDataIndex(i));
                        switch (fld.type) {
                            case "float":
                            case "int":
                                if (getCmbStore(cm.getDataIndex(i)) != null) {
                                    treeGroupBy.root.appendChild({ id: cm.getDataIndex(i), text: cm.getColumnHeader(i), leaf: true, checked: false, cls: 'file' });
                                }
                                else {
                                    var sumRow = new sumStore.recordType({
                                    FieldName: cm.getDataIndex(i),
                                    AsName: cm.getColumnHeader(i),
                                        GroupType: ''
                                    });
                                    sumStore.add(sumRow);
                                    //treeGroupSum.root.appendChild({ id: cm.getDataIndex(i), text: cm.getColumnHeader(i), leaf: true, checked: false, cls: 'file' });
                                }
                                break;
                                //日期就不作显示了
                            case "date":
                                var dateRow = new dateFieldStore.recordType({
                                    FieldName: cm.getDataIndex(i),
                                    AsName: cm.getColumnHeader(i),
                                    GroupType: ''
                                });
                                dateFieldStore.add(dateRow);
                                //treeGroupBy.root.appendChild({ id: cm.getDataIndex(i), text: cm.getColumnHeader(i), leaf: true, cls: 'file' });
                                break;
                            default:
                                treeGroupBy.root.appendChild({ id: cm.getDataIndex(i), text: cm.getColumnHeader(i), leaf: true, checked: false, cls: 'file' });
                                break;
                        }
                    }
                }
            }
        }
    }
    for (var i = 0; i < _toolBar.items.items.length-3; i++) {
        _toolBar.items.items[i].setDisabled(true);
    }
    _toolBar.items.items[_toolBar.items.items.length - 1].setDisabled(false);
    if (testUrl != "") {
        _grid.getStore().proxy.conn.url = testUrl;
    }
}

function hideForm() {
    for (var i = 0; i < _toolBar.items.items.length; i++) {
        _toolBar.items.items[i].setDisabled(false);
    }
    _toolBar.items.items[_toolBar.items.items.length - 1].setDisabled(true);
    if (grid != null) {
        grid.setVisible(false);
    }
    _grid.setVisible(true);
}

/*生成角色选择的Tree树信息******/
var Tree = Ext.tree;

var treeGroupBy = new Tree.TreePanel({
//el: 'tree-div',
    title:'显示列',
    useArrows: true,
    region: "north",
    autoScroll: true,
    animate: true,
    enableDD: true,
    containerScroll: true,
    height:200,

    rootVisible: false,
    root:new Tree.AsyncTreeNode({
        text: 'GroupBy列',
        draggable: false,
        id: 'source'})

});

var chbFieldCountValue = new Ext.form.Checkbox({});

var colModel = new Ext.grid.ColumnModel({
    columns: [
		new Ext.grid.RowNumberer(),
		{
		    header: '列',
		    dataIndex: 'FieldName',
		    id: 'FieldName',
		    tooltip: '数据列信息',
		    hidden:true
		},
		{
		    header: '列',
		    dataIndex: 'AsName',
		    id: 'AsName',
		    tooltip: '别名'
		},
		{
		    header: '统计类型',
		    dataIndex: 'GroupType',
		    id: 'GroupType',
		    tooltip: '统计类型',
		    editor: combogroupType,
		    renderer: function(value, cellmeta, record, rowIndex, columnIndex, store) {
		        //解决值显示问题
		        var index = groupTypeStore.find(combogroupType.valueField, value);
		        var record = groupTypeStore.getAt(index);
		        var displayText = "";
		        if (record == null) {
		            displayText = value;
		        } else {
		            displayText = record.data.name;
		        }
		        return displayText;
		   }
}]
});

var sumGroupGrid = new Ext.grid.EditorGridPanel({
    store: sumStore,
    cm: colModel,
    region: "center",
    layout: 'fit',
    height: 180,
    clicksToEdit:1,
    columnLines:true,
    stripeRows: true,
    frame: true,
    viewConfig: {
        columnsText: '显示的列',
        scrollOffset: 20,
        sortAscText: '升序',
        sortDescText: '降序',
        forceFit: true
    },
    tbar: [new Ext.form.Label({ text: '是否需要计数' }), chbFieldCountValue]
});
var treeGroupSum = new Tree.TreePanel({
//el: 'tree-div',
    title:'合计列',
    useArrows: true,
    region: "center",
    autoScroll: true,
    animate: true,
    enableDD: true,
    containerScroll: true,
    height: 125,
    rootVisible: false,
    root: new Tree.AsyncTreeNode({
        text: '角色信息',
        draggable: false,
        id: 'source'
    }),
    tbar: [new Ext.form.Label({ text: '是否需要计数' }), chbFieldCountValue]
});

var compareDataForm = new Ext.Panel(
{
    frame: true,
    border: false,
    region: "south",
    layout: 'table',
    height: 35,
    layoutConfig: { columns: 7 }, //将父容器分成3列
    items: [
            {items:comboDateField},
            { items: labelCompare },
            { items: comboStaticType },
            { items: cmbGroupDateType },
            { items: cmbGroupYear },
            { items: cmbGroupMonth },
            { items: cmbGroupQuarterly }
           ]
}
         );

var testUrl='';
var groupFieldSelect = new Ext.Window({
    id: 'groupFieldSelect'
        , title: ''
		, iconCls: 'upload-win'
		, width: 600
		, height: 450
		, layout: 'border'
		, plain: true
		, modal: true
		, x: 50
		, y: 50
		, constrain: true
		, resizable: false
		, closeAction: 'hide'
		, autoDestroy: true
		, items: [treeGroupBy, sumGroupGrid, compareDataForm]
		, buttons: [{
		    text: "确定"
			, handler: function() {
			    if (testUrl == '') {
			        testUrl = _grid.getStore().url;
			    }
			    getGroupStore();
			    if (groupStore.getCount() > 0) {
			        _grid.getStore().proxy.conn.url = testUrl.substring(0, testUrl.indexOf(".aspx")) + ".aspx?method=getgroupby";
			        var json = "";
			        groupStore.each(function(groupStore) {
			            json += Ext.util.JSON.encode(groupStore.data) + ',';
			        });
			        createDataGrid(testUrl.substring(0, testUrl.indexOf(".aspx")) + ".aspx?method=getgroupby",json,"");
			        groupFieldSelect.hide();
			    }
			    else {
			        _grid.getStore().proxy.conn.url = testUrl;
			        _grid.getStore().reload();
			        groupFieldSelect.hide();
			    }
			}
			, scope: this
		},
		{
		    text: "取消"
			, handler: function() {
			    groupFieldSelect.hide();
			}
			, scope: this
}]
});

var grid = null;
//设置renderer信息
function setRenderer(colModel) {
    
    for (var i = 0; i < colModel.config.length; i++) {
        colModel.config[i].renderer = getRenderer(colModel.config[i].dataIndex);
    }
}

function getRenderer(dataIndex)
{
    var cm = _grid.getColumnModel();
    for (var i = 0; i < cm.getColumnCount(); i++) {
        if (cm.getDataIndex(i) == dataIndex) {
            return cm.config[i].renderer;
        }
    }
    return "";
}
function createDataGrid(_url, groupBy, strfilter) {
    var conn = new Ext.data.Connection();
    conn.request({ url: _url, params: {OtherParams:otherParams, groupBy: groupBy,filter:strfilter }, callback: function(options, success, response) {
        var json = new Ext.util.JSON.decode(response.responseText);
        var cm = new Ext.grid.ColumnModel(json.colModel);
        var ds = new Ext.data.JsonStore({
            data: json.data,
            fields: json.fieldsNames
        });
        if (grid != null) {
            grid.destroy();
        }
        setRenderer(cm);
        grid = new Ext.grid.GridPanel({
            region: 'center',
            split: true,
            width: 600,
            height: 400,
            border: false,
            store: ds,
            cm: cm
        });
        grid.render(_gridDiv);
        _grid.setVisible(false);
    }
    });
}

function searchDataGrid(strfilter) {
    if (grid==null||grid.hidden) {
        return;
       }
       if (strfilter == "") {
       	Ext.Msg.alert("系统提示","统计时必须输入统计过滤信息！");
       	return;
       }
    var json = "";
    groupStore.each(function(groupStore) {
        json += Ext.util.JSON.encode(groupStore.data) + ',';
       });
    
    var _url = testUrl.substring(0, testUrl.indexOf(".aspx")) + ".aspx?method=getgroupby";
    if(schemeGrid!=null)
    {
        var sm = schemeGrid.getSelectionModel();
        //获取选择的数据信息
        var selectData = sm.getSelected();
        if(selectData!=null)
        {
            json = selectData.data.SchemeId;
        }
    }
    
    
    var conn = new Ext.data.Connection();
    conn.request({ url: _url, params: {OtherParams:otherParams, groupBy: json, filter: strfilter }, callback: function(options, success, response) {
        var json = new Ext.util.JSON.decode(response.responseText);
        
        var cm = new Ext.grid.ColumnModel(json.colModel);
        var ds = new Ext.data.JsonStore({
            data: json.data,
            fields: json.fieldsNames
        });
        if (grid != null) {
            grid.destroy();
        }
        setRenderer(cm);
        grid = new Ext.grid.GridPanel({
            region: 'center',
            split: true,
            width: 800,
            height: 400,
            border: false,
            store: ds,
            cm: cm
        });
        grid.render(_gridDiv);
        _grid.setVisible(false);
    }
    });
}
