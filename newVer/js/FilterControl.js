

var numCompareStore = new Ext.data.SimpleStore({
   fields: ['id', 'name', 'value'],        
   data : [        
   ['6', '小于', '<'],
   ['7', '小于等于', '<='],        
   ['4', '等于', '='],
   ['9', '大于等于', '='],
   ['8', '大于', '='],
   ['5', '不等于', '<>']   
   ]});

var filterStore = new Ext.data.SimpleStore({
   fields: ['ColumnName', 'Compare', 'ColumnValue'],        
   data : [        
   ['1', '小于', '<'],
   ['2', '小于等于', '<='],        
   ['3', '等于', '='],
   ['3', '大于等于', '='],
   ['3', '大于', '=']   
   ]});
var filterRowPattern = Ext.data.Record.create([
           { name: 'ColumnName', type: 'string' },
           { name: 'Compare', type: 'string' },
           { name: 'ColumnValue', type: 'string' }
          ]);

var strCompareStore = new Ext.data.SimpleStore({
   fields: ['id', 'name', 'value'],        
   data : [        
   ['4', '等于', '='],
   ['1', '左包含', '<='],        
   ['2', '包含', '='],
   ['3', '右包含', '='] 
   ]});
   
var dateTypeStore = new Ext.data.SimpleStore({
   fields: ['id', 'name'],        
   data : [        
   ['1', '普通'],
   ['2', '按年'],        
   ['3', '按季度'],
   ['4', '按月度'] 
   ]});
   
var yearStore = new Ext.data.SimpleStore({
   fields: ['id', 'name'],        
   data : [        
   ['1', '一月']
   ]});
var yearRowPatter = Ext.data.Record.create([
           { name: 'id', type: 'string' },
           { name: 'name', type: 'string' }
          ]);
yearStore.removeAll();
var currentYear = (new Date()).getFullYear();
currentYear = parseInt(currentYear)+1;
for(var i=2009;i<currentYear;i++)
{
    var year = new yearRowPatter({id:i,name:i});
    yearStore.add(year);
}

var defaultPageSize = 10;
var monthStore = new Ext.data.SimpleStore({
   fields: ['id', 'name'],        
   data : [        
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
   ]});

var quarterlyStore = new Ext.data.SimpleStore({
   fields: ['id', 'name'],        
   data : [        
   ['1', '第一季度'],
   ['2', '第二季度'],        
   ['3', '第三季度'],
   ['4', '第四季度'] 
   ]});

var fieldStore = new Ext.data.SimpleStore({
   fields: ['id', 'name','dataType'],        
   data : [        
   ['1', '第一季度',''],
   ['2', '第二季度',''],        
   ['3', '第三季度',''],
   ['3', '第四季度',''] 
   ]});
   
var fieldRowPattern = Ext.data.Record.create([
           { name: 'id', type: 'string' },
           { name: 'name', type: 'string' },
           { name: 'dataType', type: 'string' }
          ]);

var comboStatic = new Ext.form.ComboBox({
        id: 'comboStatic',
//        displayField:'name', //显示上面的fields中的state列的内容,相当于option的text值        
//        valueField: 'id', // 选项的值, 相当于option的value值        
        name: 'comboStatic',        
        mode: 'local', // 必须要,如果为 remote, 则会用ajax获取数据        
        triggerAction: 'all', // 点击下拉的时候, all 为展出所有Store中data的数据        
        readOnly: true, // 如果设为true,则好像一般的下拉框一样，默认是false,可输入并自动匹配        
        emptyText:'请选择统计查询类型',
        width:100,   
        hidden:true,
        editable:false,    
        selectOnFocus:true});  
                
//数字比较控件
var comboNumCompare = new Ext.form.ComboBox({
        id: 'comboNumCompare',
        store: numCompareStore, // 下拉数据           
        displayField:'name', //显示上面的fields中的state列的内容,相当于option的text值        
        valueField: 'id', // 选项的值, 相当于option的value值        
        name: 'comboNumCompare',        
        mode: 'local', // 必须要,如果为 remote, 则会用ajax获取数据        
        triggerAction: 'all', // 点击下拉的时候, all 为展出所有Store中data的数据        
        readOnly: true, // 如果设为true,则好像一般的下拉框一样，默认是false,可输入并自动匹配        
        emptyText:'请选择比较类型',
        width:100,   
        hidden:true,
        editable:false,    
        selectOnFocus:true});
        
 //字符串比较控件
var comboStrCompare = new Ext.form.ComboBox({
        id: 'comboStrCompare',
        store: strCompareStore, // 下拉数据           
        displayField:'name', //显示上面的fields中的state列的内容,相当于option的text值        
        valueField: 'id', // 选项的值, 相当于option的value值        
        name: 'comboStrCompare',        
        mode: 'local', // 必须要,如果为 remote, 则会用ajax获取数据        
        triggerAction: 'all', // 点击下拉的时候, all 为展出所有Store中data的数据        
        readOnly: true, // 如果设为true,则好像一般的下拉框一样，默认是false,可输入并自动匹配        
        emptyText:'请选择比较类型', 
        width:100,  
        hidden:true, 
        editable:false,     
        selectOnFocus:true});
        
 //时间方式
var cmbDateType = new Ext.form.ComboBox({
        id: 'cmbDateType',
        store: dateTypeStore, // 下拉数据           
        displayField:'name', //显示上面的fields中的state列的内容,相当于option的text值        
        valueField: 'id', // 选项的值, 相当于option的value值        
        name: 'cmbDateType',        
        mode: 'local', // 必须要,如果为 remote, 则会用ajax获取数据        
        triggerAction: 'all', // 点击下拉的时候, all 为展出所有Store中data的数据        
        readOnly: true, // 如果设为true,则好像一般的下拉框一样，默认是false,可输入并自动匹配        
        emptyText:'请选择比较类型',  
        width:100,   
        hidden:true, 
        editable:false,  
        selectOnFocus:true});

//时间方式
var cmbYear = new Ext.form.ComboBox({
        id: 'cmbYear',
        store: yearStore, // 下拉数据           
        displayField:'name', //显示上面的fields中的state列的内容,相当于option的text值        
        valueField: 'id', // 选项的值, 相当于option的value值        
        name: 'cmbYear',        
        mode: 'local', // 必须要,如果为 remote, 则会用ajax获取数据        
        triggerAction: 'all', // 点击下拉的时候, all 为展出所有Store中data的数据        
        //readOnly: true, // 如果设为true,则好像一般的下拉框一样，默认是false,可输入并自动匹配        
        emptyText:'请选择年度',   
        width:100,
        hidden:true,
        //editable:false,   
        selectOnFocus:true});
        
 //时间方式
var cmbMonth = new Ext.form.ComboBox({
        id: 'cmbMonth',
        store: monthStore, // 下拉数据           
        displayField:'name', //显示上面的fields中的state列的内容,相当于option的text值        
        valueField: 'id', // 选项的值, 相当于option的value值        
        name: 'cmbMonth',        
        mode: 'local', // 必须要,如果为 remote, 则会用ajax获取数据        
        triggerAction: 'all', // 点击下拉的时候, all 为展出所有Store中data的数据        
        readOnly: true, // 如果设为true,则好像一般的下拉框一样，默认是false,可输入并自动匹配        
        emptyText:'请选择比较类型',   
        width:100,  
        hidden:true,
        editable:false,    
        selectOnFocus:true});
        
 //季度方式
var cmbQuarterly = new Ext.form.ComboBox({
        id: 'cmbQuarterly',
        store: quarterlyStore, // 下拉数据           
        displayField:'name', //显示上面的fields中的state列的内容,相当于option的text值        
        valueField: 'id', // 选项的值, 相当于option的value值        
        name: 'cmbQuarterly',        
        mode: 'local', // 必须要,如果为 remote, 则会用ajax获取数据        
        triggerAction: 'all', // 点击下拉的时候, all 为展出所有Store中data的数据        
        readOnly: true, // 如果设为true,则好像一般的下拉框一样，默认是false,可输入并自动匹配        
        emptyText:'请选择比较类型',   
        width:100,
        hidden:true,
        editable:false,      
        selectOnFocus:true});
        
var cmbField =  new Ext.form.ComboBox({
        id: 'cmbField',
        store: fieldStore, // 下拉数据           
        displayField:'name', //显示上面的fields中的state列的内容,相当于option的text值        
        valueField: 'id', // 选项的值, 相当于option的value值        
        name: 'cmbField',        
        mode: 'local', // 必须要,如果为 remote, 则会用ajax获取数据        
        triggerAction: 'all', // 点击下拉的时候, all 为展出所有Store中data的数据        
        readOnly: true, // 如果设为true,则好像一般的下拉框一样，默认是false,可输入并自动匹配        
        emptyText:'请选择比较类型',  
        width:150, 
        editable:false,      
        selectOnFocus:true});

var cmbFieldStore = new Ext.data.SimpleStore({
   fields: ['id', 'name'],        
   data : [        
   ['1', '普通'],
   ['2', '按年'],        
   ['3', '按季度'],
   ['4', '按月度'] 
   ]});

var cmbFieldRowPattern = Ext.data.Record.create([
           { name: 'id', type: 'string' },
           { name: 'name', type: 'string' }
          ]);
          
var cmbFieldValue = new Ext.form.ComboBox({
        id: 'cmbFieldValue',
        store: cmbFieldStore, // 下拉数据           
        displayField:'name', //显示上面的fields中的state列的内容,相当于option的text值        
        valueField: 'id', // 选项的值, 相当于option的value值        
        name: 'cmbFieldValue',        
        mode: 'local', // 必须要,如果为 remote, 则会用ajax获取数据        
        triggerAction: 'all', // 点击下拉的时候, all 为展出所有Store中data的数据        
        readOnly: true, // 如果设为true,则好像一般的下拉框一样，默认是false,可输入并自动匹配        
        emptyText:'请选择选择信息',  
        width:150, 
        hidden:true,
        editable:false,      
        selectOnFocus:true});
        

var txtFieldValue = new Ext.form.TextField({hidden:true});
var startDate = new Ext.form.DateField({id:'startDateFilter',name:'startDateFilter',format:'Y-m-d',hidden:true});
var endDate = new Ext.form.DateField({id:'endDateFilter',name:'endDateFilter',format:'Y-m-d',hidden:true});
var chbFieldValue = new Ext.form.Checkbox({width:60,hidden:true});
var btnFliter = new Ext.Button({text:'查询'});
var btnContinueFliter = new Ext.Button({ text: '继续查询' });
var btnClearFilter=new Ext.Button({text:'清空'});
var btnExpert = new Ext.Button({ text: '导出',hidden:true});
var btnAllExpert = new Ext.Button({ text: '导出全部',hidden:true});
var chbAdvanceSearch = new Ext.form.Checkbox({text:'高级查询'});
chbAdvanceSearch.on("check",changeSearch);
btnClearFilter.on("click",clearAdvanceFilter);
function changeSearch()
{
    if(chbAdvanceSearch.getValue())
    {
        if(advanceSearchForm==null)
        {
            createAdvanceSearch(searchForm.el);            
        }
        advanceSearchForm.show();
    }
    else
    {
        advanceSearchForm.hide();
    }
}
var searchForm = null;

var gridDataStore;
var staticStore;
function createSearch(dataGrid,gridSource,renderTo)
{
    if(searchForm == null)
    {
        _dataGrid = dataGrid;
        gridDataStore = gridSource;
        loadGridField(dataGrid,gridSource);
        
         searchForm = new Ext.Panel(   
         { 
           frame:true,
           border:false, 
           //renderTo:renderTo,
           layout:'table',          
           //width:100%,   
           height:35,   
           layoutConfig:{columns:14},//将父容器分成3列   
           items:[
            {items:comboStatic},
            {items:cmbField},   
            {items:[comboNumCompare,comboStrCompare,cmbDateType]},   
            {items:[txtFieldValue,cmbYear,startDate,cmbFieldValue,chbFieldValue]},
            {items:[cmbMonth,cmbQuarterly,endDate]},
            { items: btnFliter }, { items: btnContinueFliter },{ items: btnClearFilter },{ items:new Ext.form.Label({html:'&nbsp;'}) },
            { items: btnExpert }, { items: btnAllExpert}, { items:new Ext.form.Label({html:'&nbsp;&nbsp;'}) },
            { items:chbAdvanceSearch},{items:new Ext.form.Label({text:'高级查询'})}
           ]   
          }   
         );
         //searchForm.render(renderTo);
         //createAdvanceSearch(renderTo);
         chbFieldValue.setVisible(false);
         
     }
}

function loadGridField(dataGrid,gridSource)
{
    fieldStore.removeAll();
    for(var i=0;i<dataGrid.colModel.config.length;i++)
    {
        if(dataGrid.colModel.config[i].hidden)
            continue;
        if (dataGrid.colModel.config[i].header == null)
            continue;
        if(dataGrid.colModel.config[i].header.indexOf("<div")!=-1)
            continue;
        if(dataGrid.colModel.config[i].header!="")
        {
            var addRow = new fieldRowPattern({
                    id: dataGrid.colModel.config[i].dataIndex,
                    name: dataGrid.colModel.config[i].header,
                    dataType: getColumnType(dataGrid.colModel.config[i].dataIndex,gridSource)
                });
                fieldStore.add(addRow);
        }
    }
}

function getColumnType(columnName,gridSource)
{
    for(var i=0;i<gridSource.fields.items.length;i++)
    {
        if(gridSource.fields.items[i].name==columnName)
        {
            return gridSource.fields.items[i].type;
        }
    }
    return "";
}

function cmbDataType(val) {
    var index = fieldStore.find('id', val);
    if (index < 0)
        return "";
    var record = fieldStore.getAt(index);
    return record.data.dataType;
}

cmbField.on("select",setControlVisibleByField);
cmbDateType.on("select",dataTypeChange);
btnFliter.on("click",btnFilterClick);
btnContinueFliter.on("click", btnContinueFliterClick);
btnExpert.on("click", btnExpertClick);
btnAllExpert.on("click",btnAllExpertClick);
//comboStatic.on("select",setStaticGrid);

function btnExpertClick(type) {
    Ext.Msg.wait('正在生成Excel文档, 请稍候……',"系统提示");
    var type ='server';   
    var tempGrid =  _dataGrid;
    if(_dataGrid.hidden)
    {
        tempGrid = grid;
    }
    if('undefined'==type){
    /*****************************1客户器端生成并保存start***************************/
        var vExportContent = _dataGrid.getExcelXml();
        var w = window.open("about:blank", "Excel", "");
    //    w.document.writeln("<head>");
    //    w.document.writeln("<meta http-equiv=\"Content-Type\" content=\"application/xhtml+xml;charset=utf-8\" />");
    //    w.document.writeln("</head>");
        //w.document.location = 'data:application/vnd.ms-excel;base64,' + Base64.encode(vExportContent);
        w.document.write(vExportContent);
    //    //Ext.Msg.hide();
        w.document.execCommand('Saveas', false, 'C:\\log.xls');
    //    w.close();
        Ext.Msg.hide();

    //    } else {
    //        document.location = 'data:application/vnd.ms-excel;base64,' + Base64.encode(vExportContent);
    //    }
    /*****************************1客户器端生成并保存end***************************/
    }else if(type=='server'){
    /*****************************2服务器端生成start***************************/
        var vExportContent = tempGrid.getExcelXml();
        //if (Ext.isIE || Ext.isSafari || Ext.isSafari2 || Ext.isSafari3) {//在这几种浏览器中才需要，IE8测试不能直接下载了
            if (!Ext.fly('frmDummye')) {
                var frm = document.createElement('form');
                frm.id = 'frmDummye';
                frm.name = id;
                frm.className = 'x-hidden';
                document.body.appendChild(frm);
            }
            Ext.Ajax.request({
                url: '/rpt/fm/ExportService.aspx',//将生成的xml发送到服务器端
                method: 'POST',
                form: Ext.fly('frmDummye'),
                callback: function(o, s, r) {
                    Ext.Msg.hide();//alert(r.responseText);
                },
                isUpload: true,
                params: { ExportContent: vExportContent, ExportFile: tempGrid.id + '.xls' }
            });
            Ext.Msg.hide();
    //    } else {
    //        var w = window.open("about:blank", "Excel", "");
    //        w.document.write(vExportContent);
    //        w.document.execCommand('Saveas', false, 'C:\\log.xls');
    //        Ext.Msg.hide();
    //    }
    /*****************************2服务器端生成end***************************/
    }
}

function btnAllExpertClick(){
    var json = "";
    filterStore.each(function(filterStore) {
        json += Ext.util.JSON.encode(filterStore.data) + ',';
    });
    json = json.substring(0, json.length - 1);    
    if (!Ext.fly('exportAllData'))   
    {   
        var frm = document.createElement('form');   
        frm.id = 'exportAllData';   
        frm.name = id ;   
        //frm.style.display = 'none';   
        frm.className = 'x-hidden'; 
        document.body.appendChild(frm);   
    }  
    Ext.Ajax.request({   
        url: '/Common/frmViewList.aspx?method=exportData', 
        form: Ext.fly('exportAllData'),   
        method: 'POST',     
        isUpload: true,          
        params: {
            ReportView:_dataGrid.getStore().baseParams.ReportView,
            StaticId:comboStatic.getValue(),
            reportid:staticReportId,
            limit: defaultPageSize,
            start: 0,
            isAllExport:true,
            filter:json
        },
        success: function(resp, opts) {
            //Ext.Msg.hide();
        },
        failure: function(resp, opts) {
             //Ext.Msg.hide();
        }
    });
    
}

function btnContinueFliterClick()
{
    getFilter();
    var json = "";
                filterStore.each(function(filterStore) {
                    json += Ext.util.JSON.encode(filterStore.data) + ',';
                });
   json = json.substring(0, json.length - 1);
   gridDataStore.baseParams.filter=json;
   gridDataStore.baseParams.limit=10;
   gridDataStore.baseParams.start=0;
   gridDataStore.load();
}
function btnFilterClick()
{
    filterStore.removeAll();
    getFilter();
    var json = "";
                filterStore.each(function(filterStore) {
                    json += Ext.util.JSON.encode(filterStore.data) + ',';
                });
   json = json.substring(0, json.length - 1);
   var changeLoadData = 0;
   if(!comboStatic.hidden)
   {
        var staticValue = comboStatic.getValue();
        if(staticValue!="0" && staticValue!="")
        {
            changeLoadData=1;
        }
   }
   if(changeLoadData==0) {
       if (!_dataGrid.hidden) {
           gridDataStore.baseParams.SortInfo='{\'field\': \''+_dataGrid.colModel.config[2].dataIndex+'\', \'direction\': \'ASC\'}';
           gridDataStore.baseParams.filter = json;
           gridDataStore.baseParams.limit = defaultPageSize;
           gridDataStore.baseParams.start = 0;
           gridDataStore.removeAll();//先清空
           gridDataStore.load();
           //return json;
       }
   }
   else
   {
        staticStore.baseParams.filter=json;
        staticStore.baseParams.StaticId=comboStatic.getValue();
        staticStore.load();
   }
}
function getFilter()
{    
    if(chbAdvanceSearch.getValue())
    {
        getAdvanceFilter();
        return;
    }
    var filter = new filterRowPattern({
            ColumnName:'',
            Compare:'',
            ColumnValue:''
        });
    filter.data.ColumnName = cmbField.getValue();
    //日期格式
    if(!cmbDateType.hidden)
    {
        if(cmbDateType.getValue()=="1")
        {
            filter.data.Compare = 'date';
        }
        else
        {
            filter.data.Compare = 'Month';
        }
        filter.data.ColumnValue = getDateFilter();
    }
    //数字格式
    if(!comboNumCompare.hidden)
    {
        filter.data.Compare = comboNumCompare.getValue();
        filter.data.ColumnValue =txtFieldValue.getValue();
    }
    
    if (!comboStrCompare.hidden) {
        filter.data.Compare = comboStrCompare.getValue();
        filter.data.ColumnValue = txtFieldValue.getValue();
    }
    else {
        //Select 类型
        if (!txtFieldValue.hidden) {
            filter.data.Compare = 'select';
            filter.data.ColumnValue = getSelectedValue(cmbField.getValue());
        }
    }
    
    if(!cmbFieldValue.hidden)
    {
        filter.data.Compare = '4';
        filter.data.ColumnValue=cmbFieldValue.getValue();
    }
    filterStore.add(filter);
}

function getAdvanceDateFilter(idValue)
{
    var strStartDate = '';
    var strEndDate='';
    if(!Ext.getCmp("cmbYear"+idValue).hidden)
    {
        strStartDate = Ext.getCmp("cmbYear"+idValue).getValue()+"-01-01";
        strEndDate =  (parseInt(Ext.getCmp("cmbYear"+idValue).getValue())+1)+"-01-01";
    }
    //月度可见
    if(!Ext.getCmp("cmbMonth"+idValue).hidden)
    {
       strStartDate = Ext.getCmp("cmbYear"+idValue).getValue()+"-"+Ext.getCmp("cmbMonth"+idValue).getValue()+"-01";
       if(Ext.getCmp("cmbEndMonth"+idValue).getValue()!="12")
       {
            strEndDate = Ext.getCmp("cmbYear"+idValue).getValue()+"-"+(parseInt(Ext.getCmp("cmbEndMonth"+idValue).getValue())+1)+"-01";  
       }
       else
       {
            strEndDate = (parseInt(Ext.getCmp("cmbYear"+idValue).getValue())+1)+"-01-01";  
       }
//       strEndDate =  Ext.getCmp("cmbYear"+idValue).getValue()+"-"+(parseInt(Ext.getCmp("cmbMonth"+idValue).getValue())+1)+"-01";
    }
    //季度可见
    if(!Ext.getCmp("cmbQuarterly"+idValue).hidden)
    {
        var jd = parseInt(Ext.getCmp("cmbQuarterly"+idValue).getValue());
        strStartDate = Ext.getCmp("cmbYear"+idValue).getValue()+"-"+(1+(jd-1)*3)+"-01";
        if(jd==4)
        {
            strEndDate =  (parseInt(Ext.getCmp("cmbYear"+idValue).getValue())+1)+"-01-01";
        }
        else
        {
            strEndDate =  Ext.getCmp("cmbYear"+idValue).getValue()+"-"+(jd*3+1)+"-01";
        }
    }
    //普通模式
    if(!Ext.getCmp("txtstart"+idValue).hidden)
    {
        strStartDate = document.getElementById("txtstart"+idValue).value; //.getText();
        strEndDate = document.getElementById("txtend"+idValue).value;
    }
    return strStartDate +":"+strEndDate;
}

function getDateFilter()
{   
    var strStartDate = '';
    var strEndDate='';
    if(!cmbYear.hidden)
    {
        strStartDate = cmbYear.getValue()+"-01-01";
        strEndDate =  (parseInt(cmbYear.getValue())+1)+"-01-01";
    }
    //月度可见
    if(!cmbMonth.hidden)
    {
       strStartDate = cmbYear.getValue()+"-"+cmbMonth.getValue()+"-01";
       strEndDate =  cmbYear.getValue()+"-"+(parseInt(cmbMonth.getValue())+1)+"-01";
    }
    //季度可见
    if(!cmbQuarterly.hidden)
    {
        var jd = parseInt(cmbQuarterly.getValue());
        strStartDate = cmbYear.getValue()+"-"+(1+(jd-1)*3)+"-01";
        if(jd==4)
        {
            strEndDate =  (parseInt(cmbYear.getValue())+1)+"-01-01";
        }
        else
        {
            strEndDate =  cmbYear.getValue()+"-"+(jd*3+1)+"-01";
        }
    }
    //普通模式
    if(!startDate.hidden)
    {
        strStartDate = document.getElementById("startDateFilter").value; //.getText();
        strEndDate = document.getElementById("endDateFilter").value;
    }
    return strStartDate +":"+strEndDate;
}
function setControlVisibleByField()
{
    switch(cmbDataType(cmbField.getValue()))
    {
        case 'date':
            //初始化时间类型显示
            cmbDateType.setValue(1);           
            cmbMonth.setVisible(false);
            cmbQuarterly.setVisible(false);
            cmbYear.setVisible(false);
            
            //其他显示为false
            comboNumCompare.setVisible(false);
            comboStrCompare.setVisible(false);
            
            txtFieldValue.setVisible(false);
            cmbFieldValue.setVisible(false);
            chbFieldValue.setVisible(false);
            
            cmbDateType.setVisible(true);
            startDate.setVisible(true);
            endDate.setVisible(true);
            break;
        case 'float':
            //时间方面控件
            cmbDateType.setVisible(false);
            startDate.setVisible(false);
            endDate.setVisible(false);
            cmbMonth.setVisible(false);
            cmbQuarterly.setVisible(false);
             cmbYear.setVisible(false);            
            
            comboStrCompare.setVisible(false);   
            
            cmbFieldValue.setVisible(false);
            chbFieldValue.setVisible(false);
            
            comboNumCompare.setVisible(true);
            txtFieldValue.setVisible(true);
            break;
        case 'int':
            var tempStore =getCmbStore(cmbField.getValue());
            
            //时间方面控件
                cmbDateType.setVisible(false);
                startDate.setVisible(false);
                endDate.setVisible(false);
                cmbMonth.setVisible(false);
                cmbQuarterly.setVisible(false);
                cmbYear.setVisible(false);
                
                
                comboStrCompare.setVisible(false);
                chbFieldValue.setVisible(false);
                
            if(tempStore!=null)
            {
                setCmbFieldValueStore(tempStore);
                
                txtFieldValue.setVisible(false);
                comboNumCompare.setVisible(false);
                cmbFieldValue.setVisible(true);
            }
            else
            {
                
                
                cmbFieldValue.setVisible(false);
                comboNumCompare.setVisible(true);
                txtFieldValue.setVisible(true);
            }
            
                
            break;
        case"bool":
            //时间方面控件
            cmbDateType.setVisible(false);
            startDate.setVisible(false);
            endDate.setVisible(false);
            cmbMonth.setVisible(false);
            cmbQuarterly.setVisible(false);
             cmbYear.setVisible(false);
            
            comboNumCompare.setVisible(false);
            comboStrCompare.setVisible(false);
            
            txtFieldValue.setVisible(false);
            cmbFieldValue.setVisible(false);
            chbFieldValue.setVisible(true);
            break;
        case "select":
            cmbDateType.setVisible(false);
            startDate.setVisible(false);
            endDate.setVisible(false);
            cmbMonth.setVisible(false);
            cmbQuarterly.setVisible(false);
            cmbYear.setVisible(false);

            comboNumCompare.setVisible(false);
            chbFieldValue.setVisible(false);
            cmbFieldValue.setVisible(false);
            comboStrCompare.setVisible(false);
            txtFieldValue.setVisible(true);
            break;
        default:            
            var tempStore =getCmbStore(cmbField.getValue());
            
            //时间方面控件
            cmbDateType.setVisible(false);
            startDate.setVisible(false);
            endDate.setVisible(false);
            cmbMonth.setVisible(false);
            cmbQuarterly.setVisible(false);
            cmbYear.setVisible(false);
            
            comboNumCompare.setVisible(false);
            chbFieldValue.setVisible(false);
            if(tempStore!=null)
            {
                setCmbFieldValueStore(tempStore);
                
                txtFieldValue.setVisible(false);
                comboStrCompare.setVisible(false);
                cmbFieldValue.setVisible(true);
            }
            else
            {           
              
                
                cmbFieldValue.setVisible(false);
                comboStrCompare.setVisible(true);
                 txtFieldValue.setVisible(true);
                 if(comboStrCompare.getValue()=="")
                 {
                    comboStrCompare.setValue("2");
                 }
            }
            
            break;        
    }    
}

function setCmbFieldValueStore(tempStore)
{    
    cmbFieldStore.removeAll();
    var displayName = tempStore.fields.items[0].name;
    if(tempStore.fields.items.length>1)
    {
        displayName = tempStore.fields.items[1].name;
    }
    tempStore.each(function(tempRecord) {
        var temp = new cmbFieldRowPattern({
            id:tempRecord.data[tempStore.fields.items[0].name],
            name:tempRecord.data[displayName]});
        cmbFieldStore.add(temp);
    });
    cmbFieldValue.setValue("");
}

function advanceMonthChange(monthType)
{
    var id = monthType.id;
    var idValue="";
    //截止月度更改，如果截止月度小于起始月度，那么起始月度=截止月度
    if(id.indexOf("cmbEndMonth")!=-1)
    {
        idValue = id.replace("cmbEndMonth","");
        if(Ext.getCmp("cmbMonth"+idValue).getValue()=="")
        {
            Ext.getCmp("cmbMonth"+idValue).setValue(monthType.getValue());
        }
        else
        {
            if(parseInt(monthType.getValue())<parseInt(Ext.getCmp("cmbMonth"+idValue).getValue()))
            {
                Ext.getCmp("cmbMonth"+idValue).setValue(monthType.getValue());
            }
        }
    }
    else
    {
        idValue = id.replace("cmbMonth","");
        if(Ext.getCmp("cmbEndMonth"+idValue).getValue()==""||parseInt(monthType.getValue())>parseInt(Ext.getCmp("cmbEndMonth"+idValue).getValue()))
        {
            Ext.getCmp("cmbEndMonth"+idValue).setValue(monthType.getValue());
        }
    }
}
function advanceDateTypeChange(dateType)
{
    var idValue = dateType.id.replace("cmbDateType","");
    switch(dateType.getValue())
    {
        case"1":
            Ext.getCmp("txtstart"+idValue).setVisible(true);
            Ext.getCmp("txtend"+idValue).setVisible(true);
            Ext.getCmp("cmbMonth"+idValue).setVisible(false);
            Ext.getCmp("cmbQuarterly"+idValue).setVisible(false);
            Ext.getCmp("cmbYear"+idValue).setVisible(false);
            Ext.getCmp("cmbEndMonth"+idValue).setVisible(false);
            break;
        case"2"://年度
            Ext.getCmp("txtstart"+idValue).setVisible(false);
            Ext.getCmp("txtend"+idValue).setVisible(false);
            Ext.getCmp("cmbMonth"+idValue).setVisible(false);
            Ext.getCmp("cmbQuarterly"+idValue).setVisible(false);
            Ext.getCmp("cmbEndMonth"+idValue).setVisible(false);
            Ext.getCmp("cmbYear"+idValue).setVisible(true);
            break;
        case"3"://季度
            Ext.getCmp("txtstart"+idValue).setVisible(false);
            Ext.getCmp("txtend"+idValue).setVisible(false);
            Ext.getCmp("cmbMonth"+idValue).setVisible(false);
            Ext.getCmp("cmbQuarterly"+idValue).setVisible(true);
            Ext.getCmp("cmbYear"+idValue).setVisible(true);
            Ext.getCmp("cmbEndMonth"+idValue).setVisible(false);
            break;
        case"4"://月度
            Ext.getCmp("txtstart"+idValue).setVisible(false);
            Ext.getCmp("txtend"+idValue).setVisible(false);
            Ext.getCmp("cmbMonth"+idValue).setVisible(true);
            Ext.getCmp("cmbQuarterly"+idValue).setVisible(false);
            Ext.getCmp("cmbYear"+idValue).setVisible(true);
            Ext.getCmp("cmbEndMonth"+idValue).setVisible(true);
            break;
    }
}

function dataTypeChange()
{
    switch(cmbDateType.getValue())
    {
        //普通
        case "1":
            //cmbDateType.setVisible(true);
            startDate.setVisible(true);
            endDate.setVisible(true);
            cmbMonth.setVisible(false);
            cmbQuarterly.setVisible(false);
             cmbYear.setVisible(false);
            break;
        //按年度
        case "2":
            //cmbDateType.setVisible(true);
            startDate.setVisible(false);
            endDate.setVisible(false);
            cmbMonth.setVisible(false);
            cmbQuarterly.setVisible(false);
             cmbYear.setVisible(true);
            break;
         //按季度
        case "3":
            startDate.setVisible(false);
            endDate.setVisible(false);
            cmbMonth.setVisible(false);
            cmbQuarterly.setVisible(true);
             cmbYear.setVisible(true);
            break;
            //按月度
         case "4":
            startDate.setVisible(false);
            endDate.setVisible(false);
            cmbMonth.setVisible(true);
            cmbQuarterly.setVisible(false);
             cmbYear.setVisible(true);
            break;
    }
}

var advanceSearchForm = null;
var currentSelect = null;
function createAdvanceSearch(formDiv)
{
    var columnCount = 6;
    if(document.body.clientWidth<650)
    {
        columnCount=4;
    }
    advanceSearchForm = new Ext.Panel(   
         { 
           frame:true,
           border:true, 
           width:'100%',
           layout:'table',            
           layoutConfig:{columns:columnCount}//将父容器分成3列   
          }   
         );
     var str='';
     fieldStore.each(function(fieldStore) {
         advanceSearchForm.add({ items: new Ext.form.Label({ text: fieldStore.data.name }) });
         idControl = fieldStore.data.id;
         switch (fieldStore.data.dataType) {
             case 'float':
             case 'int':
                 var tempStore1 = getCmbStore(fieldStore.data.id);

                 if (tempStore1 != null) {
                     var cmbFilterFieldValue = new Ext.form.ComboBox({
                         id: 'filter' + idControl,
                         store: tempStore1, // 下拉数据           
                         displayField: tempStore1.fields.items[1].name, //显示上面的fields中的state列的内容,相当于option的text值        
                         valueField: tempStore1.fields.items[0].name, // 选项的值, 相当于option的value值        
                         name: 'filter' + idControl,
                         mode: 'local', // 必须要,如果为 remote, 则会用ajax获取数据        
                         triggerAction: 'all', // 点击下拉的时候, all 为展出所有Store中data的数据        
                         readOnly: true, // 如果设为true,则好像一般的下拉框一样，默认是false,可输入并自动匹配        
                         emptyText: '请选择选择信息',
                         width: 150,
                         editable: false,
                         selectOnFocus: true
                     });
                     advanceSearchForm.add({ items: cmbFilterFieldValue });
                 }
                 else {
                     //数字比较控件
                     var cmbNumCompare = new Ext.form.ComboBox({
                         id: 'cmbNum' + idControl,
                         store: numCompareStore, // 下拉数据           
                         displayField: 'name', //显示上面的fields中的state列的内容,相当于option的text值        
                         valueField: 'id', // 选项的值, 相当于option的value值        
                         name: 'cmbNum' + idControl,
                         mode: 'local', // 必须要,如果为 remote, 则会用ajax获取数据        
                         triggerAction: 'all', // 点击下拉的时候, all 为展出所有Store中data的数据        
                         readOnly: true, // 如果设为true,则好像一般的下拉框一样，默认是false,可输入并自动匹配        
                         emptyText: '请选择比较类型',
                         width: 60,
                         editable: false,
                         selectOnFocus: true
                     });
                     advanceSearchForm.add({ layout: 'table', layoutConfig: { columns: 2 }, items: [{ items: cmbNumCompare }, { items: new Ext.form.NumberField({ id: 'filter' + idControl })}] });
                 }
                 break;
             case 'date':
                 var cmbDateType1 =new Ext.form.ComboBox({
                         id: 'cmbDateType' + idControl,
                         store: dateTypeStore, // 下拉数据           
                        displayField:'name', //显示上面的fields中的state列的内容,相当于option的text值        
                        valueField: 'id', // 选项的值, 相当于option的value值        
                        name:'cmbDateType' + idControl,  
                        mode: 'local', // 必须要,如果为 remote, 则会用ajax获取数据        
                        triggerAction: 'all', // 点击下拉的时候, all 为展出所有Store中data的数据        
                        readOnly: true, // 如果设为true,则好像一般的下拉框一样，默认是false,可输入并自动匹配        
                        emptyText:'请选择比较类型',  
                        width:40,   
                        hidden:false, 
                        editable:false,  
                        selectOnFocus:true});
                  cmbDateType1.on("select",advanceDateTypeChange);
                  cmbDateType1.setValue("1");
                  //时间方式
                var cmbYear1 = new Ext.form.ComboBox({
                        id: 'cmbYear'+ idControl,
                        store: yearStore, // 下拉数据           
                        displayField:'name', //显示上面的fields中的state列的内容,相当于option的text值        
                        valueField: 'id', // 选项的值, 相当于option的value值        
                        name: 'cmbYear'+ idControl,        
                        mode: 'local', // 必须要,如果为 remote, 则会用ajax获取数据        
                        triggerAction: 'all', // 点击下拉的时候, all 为展出所有Store中data的数据        
                        //readOnly: true, // 如果设为true,则好像一般的下拉框一样，默认是false,可输入并自动匹配        
                        emptyText:'请选择年度',   
                        width:60,
                        hidden:true,
                        //editable:false,   
                        selectOnFocus:true});
                        
                 //时间方式
                var cmbMonth1 = new Ext.form.ComboBox({
                        id: 'cmbMonth'+ idControl,
                        store: monthStore, // 下拉数据           
                        displayField:'name', //显示上面的fields中的state列的内容,相当于option的text值        
                        valueField: 'id', // 选项的值, 相当于option的value值        
                        name: 'cmbMonth'+ idControl,        
                        mode: 'local', // 必须要,如果为 remote, 则会用ajax获取数据        
                        triggerAction: 'all', // 点击下拉的时候, all 为展出所有Store中data的数据        
                        readOnly: true, // 如果设为true,则好像一般的下拉框一样，默认是false,可输入并自动匹配        
                        emptyText:'请选择比较类型',   
                        width:50,  
                        hidden:true,
                        editable:false,    
                        selectOnFocus:true});
                cmbMonth1.on("select",advanceMonthChange);
                  //时间方式
                var cmbMonth2 = new Ext.form.ComboBox({
                        id: 'cmbEndMonth'+ idControl,
                        store: monthStore, // 下拉数据           
                        displayField:'name', //显示上面的fields中的state列的内容,相当于option的text值        
                        valueField: 'id', // 选项的值, 相当于option的value值        
                        name: 'cmbEndMonth'+ idControl,        
                        mode: 'local', // 必须要,如果为 remote, 则会用ajax获取数据        
                        triggerAction: 'all', // 点击下拉的时候, all 为展出所有Store中data的数据        
                        readOnly: true, // 如果设为true,则好像一般的下拉框一样，默认是false,可输入并自动匹配        
                        emptyText:'请选择比较类型',   
                        width:50,  
                        hidden:true,
                        editable:false,    
                        selectOnFocus:true});
                cmbMonth2.on("select",advanceMonthChange);
                 //季度方式
                var cmbQuarterly1 = new Ext.form.ComboBox({
                        id: 'cmbQuarterly'+ idControl,
                        store: quarterlyStore, // 下拉数据           
                        displayField:'name', //显示上面的fields中的state列的内容,相当于option的text值        
                        valueField: 'id', // 选项的值, 相当于option的value值        
                        name: 'cmbQuarterly'+ idControl,        
                        mode: 'local', // 必须要,如果为 remote, 则会用ajax获取数据        
                        triggerAction: 'all', // 点击下拉的时候, all 为展出所有Store中data的数据        
                        readOnly: true, // 如果设为true,则好像一般的下拉框一样，默认是false,可输入并自动匹配        
                        emptyText:'请选择比较类型',   
                        width:90,
                        hidden:true,
                        editable:false,      
                        selectOnFocus:true});
                 advanceSearchForm.add({ layout: 'table', layoutConfig: { columns: 7 }, items: [{items:cmbDateType1},{ items: new Ext.form.DateField({ id: 'txtstart' + idControl, format: "Y-m-d", width: 90 }) }, { items: new Ext.form.DateField({ id: 'txtend' + idControl, format: "Y-m-d", width: 90 })},
                    {items:cmbYear1},{items:cmbMonth1},{items:cmbMonth2},{items:cmbQuarterly1}] });
                    break;
             case 'bool':
                 advanceSearchForm.add({ layout: 'table', layoutConfig: { columns: 1 }, items: [{ items: new Ext.form.Checkbox({ id: idControl })}] });
                 break;
             case "select":
                 var textField = new Ext.form.TextField({ id: 'filter' + idControl });
                 textField.on("focus", focusShow);
                 advanceSearchForm.add({ layout: 'table', layoutConfig: { columns: 1 }, items: [{ items: textField}] });

                 break;
             default:
                 var tempStore = getCmbStore(fieldStore.data.id);                 
                 if (tempStore != null) {
                    var displayName = tempStore.fields.items[0].name;
                     if(tempStore.fields.items.length>1)
                     {
                        displayName=tempStore.fields.items[1].name;
                     }
                     var cmbFilterFieldValue = new Ext.form.ComboBox({
                         id: 'filter' + idControl,
                         store: tempStore, // 下拉数据           
                         displayField: displayName, //显示上面的fields中的state列的内容,相当于option的text值        
                         valueField: tempStore.fields.items[0].name, // 选项的值, 相当于option的value值        
                         name: 'filter' + idControl,
                         mode: 'local', // 必须要,如果为 remote, 则会用ajax获取数据        
                         triggerAction: 'all', // 点击下拉的时候, all 为展出所有Store中data的数据        
                         readOnly: true, // 如果设为true,则好像一般的下拉框一样，默认是false,可输入并自动匹配        
                         emptyText: '请选择选择信息',
                         width: 150,
                         editable: false,
                         selectOnFocus: true
                     });
                     advanceSearchForm.add({ items: cmbFilterFieldValue });
                 }
                 else {
                     //字符串比较控件
                     var cmbTempStrCompare = new Ext.form.ComboBox({
                         id: 'cmbStr' + idControl,
                         store: strCompareStore, // 下拉数据           
                         displayField: 'name', //显示上面的fields中的state列的内容,相当于option的text值        
                         valueField: 'id', // 选项的值, 相当于option的value值        
                         name: 'cmbStr' + idControl,
                         mode: 'local', // 必须要,如果为 remote, 则会用ajax获取数据        
                         triggerAction: 'all', // 点击下拉的时候, all 为展出所有Store中data的数据        
                         readOnly: true, // 如果设为true,则好像一般的下拉框一样，默认是false,可输入并自动匹配        
                         emptyText: '请选择比较类型',
                         width: 60,
                         editable: false,
                         selectOnFocus: true
                     });
                     cmbTempStrCompare.setValue('2');
                     advanceSearchForm.add({ layout: 'table', layoutConfig: { columns: 2 }, items: [{ items: cmbTempStrCompare }, { items: new Ext.form.TextField({ id: 'filter' + idControl })}] });
                 }
                 break;
         }
     });
     advanceSearchForm.render(formDiv);   
     //advanceSearchForm.hide(); 
}

function focusShow(txt) {
    currentSelect = txt;
    var columnName = txt.id.replace('filter', '');
    selectShow(columnName);
}
var TempRecord = Ext.data.Record.create([

　　{name: 'id'},

　　{name: 'name'}

　　]);
　　
function copyStore(mainStore)
{
    var tempStore = new Ext.data.SimpleStore({
           fields: ['id', 'name'],        
           data : [        
           ['6', '小于']]
           });
           tempStore.removeAll();
     mainStore.each(function(mainStore){
        var person = new TempRecord({
            id:mainStore.data[mainStore.fields.items[0].name],name:mainStore.data[mainStore.fields.items[1].name]});
        tempStore.add(person);
        
     });
     return tempStore;
}



function clearAdvanceFilter(){
    fieldStore.each(function(fieldStore) {
        switch (fieldStore.data.dataType) {
            case "date":
                Ext.getCmp("cmbDateType"+fieldStore.data.id).setValue("1");
                Ext.getCmp("txtstart"+fieldStore.data.id).setValue('');
                Ext.getCmp("txtend"+fieldStore.data.id).setValue('');
                advanceDateTypeChange(Ext.getCmp("cmbDateType"+fieldStore.data.id));
                break;
            case "int":
            case "float":
                var columnValue = Ext.getCmp('filter' + fieldStore.data.id).setValue('');                
                break;
            case "bool":
                break;
            case "select":
                break;
            default:
                Ext.getCmp('filter' + fieldStore.data.id).setValue('');                
                break;
        }
    });
}

function getAdvanceFilter()
{
    fieldStore.each(function(fieldStore) {
        switch (fieldStore.data.dataType) {
            case "date":
                var dateValue = getAdvanceDateFilter(fieldStore.data.id);
                if(Ext.getCmp("cmbDateType"+fieldStore.data.id).getValue()==1)
                {
                    addNewFilter(fieldStore.data.id, 'date', dateValue);
                }
                else
                {
                    addNewFilter(fieldStore.data.id, 'Month', dateValue);
                }
                break;
            case "int":
            case "float":
                var columnValue = Ext.getCmp('filter' + fieldStore.data.id).getValue();
                if (columnValue + '' != '') {
                    if (getCmbStore(fieldStore.data.id) != null) {
                        addNewFilter(fieldStore.data.id, 4, columnValue);
                    }
                    else {
                        addNewFilter(fieldStore.data.id, Ext.getCmp('cmbNum' + fieldStore.data.id).getValue(), columnValue);
                    }
                }
                break;
            case "bool":
                break;
            case "select":
                var compareValue = getSelectedValue(fieldStore.data.id);
                if (compareValue != '') {
                    addNewFilter(fieldStore.data.id, 'select', compareValue);
                }
                break;
            default:
                var columnValue = Ext.getCmp('filter' + fieldStore.data.id).getValue();
                if (columnValue != '') {
                    if (getCmbStore(fieldStore.data.id) != null) {
                        addNewFilter(fieldStore.data.id, 4, columnValue);
                    }
                    else {
                        addNewFilter(fieldStore.data.id, Ext.getCmp('cmbStr' + fieldStore.data.id).getValue(), columnValue);
                    }
                }
                break;
        }
    });
}

function addNewFilter(fieldName,compare,columnValue)
{
    var filter = new filterRowPattern({
            ColumnName:fieldName,
            Compare:compare,
            ColumnValue:columnValue
        });    
    filterStore.add(filter);
}
/*fix datefield width bug*/
Ext.override(Ext.menu.DateMenu,{
 render : function(){
  Ext.menu.DateMenu.superclass.render.call(this);
  if(Ext.isChrome||Ext.isGecko|| Ext.isSafari){
   this.picker.el.dom.childNodes[0].style.width = '178px';
   this.picker.el.dom.style.width = '178px';
  }
 }
});