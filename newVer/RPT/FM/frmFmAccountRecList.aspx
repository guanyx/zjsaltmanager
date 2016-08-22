<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmFmAccountRecList.aspx.cs" Inherits="SCM_FmAccountRecList" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html>
<head>
    <title>应收账款明细表</title>
    <meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
    <link rel="stylesheet" type="text/css" href="../../ext3/resources/css/ext-all.css" />
    <script type="text/javascript" src="../../ext3/adapter/ext/ext-base.js"></script>
    <script type="text/javascript" src="../../ext3/ext-all.js"></script>
    <script type="text/javascript" src="../../js/operateResp.js"></script>
    <script type="text/javascript" src="../../js/getExcelXml.js"></script>
    <script type="text/javascript" src="../../ext3/src/locale/ext-lang-zh_CN.js"></script>
</head>
<body>
<div id='toolbar'></div>
<div id='searchForm'></div>
<div id='sendGrid'></div>
<%=getComboBoxStore() %>
</body>
<script type="text/javascript">
Ext.BLANK_IMAGE_URL = "../../ext3/resources/images/default/s.gif";
var uploadTransWindow;
Ext.onReady(function(){
var opType;
/*------实现toolbar的函数 start---------------*/
var Toolbar = new Ext.Toolbar({
	renderTo:"toolbar",
	items:[{
		text:"导出",
		icon:"../../Theme/1/images/extjs/customer/edit16.gif",
		handler:function(){
		    if(typeComboPanel.getValue()==4||typeComboPanel.getValue()==3){
		        ExportServer();
		    }else{
		        ExportAll(true);   
		    }
		}
	}]
});

/*------结束toolbar的函数 end---------------*/


/*------开始ToolBar事件函数 start---------------*//*-----新增Mst实体类窗体函数----*/
function ExportServer(){
    if(dsReceiveGrid.getCount()==0){
        Ext.Msg.alert("提示", "没有可以导出记录信息！");
        return;
    }
    
    if (!Ext.fly('exportAllData'))   
    {   
        var frm = document.createElement('form');   
        frm.id = 'exportAllData';   
        frm.name = id ;   
        //frm.style.display = 'none';   
        frm.className = 'x-hidden'; 
        document.body.appendChild(frm);   
    }  
    var starttime=distributeStartPanel.getValue();
    var endtime = distributeEndPanel.getValue().add(Date.DAY, 1);
    Ext.Ajax.request({   
        timeout: 300000,
        url: 'frmFmAccountRecList.aspx?method=exportData', 
        form: Ext.fly('exportAllData'),   
        method: 'POST',     
        isUpload: true,          
        params: {
            StartDate: Ext.util.Format.date(starttime, 'Y/m/d'),
            EndDate:Ext.util.Format.date(endtime, 'Y/m/d'),
            queryType:typeComboPanel.getValue(),
            ignoreDept:ignoredept
        },
        success: function(resp, opts) {
            //Ext.Msg.hide();
        },
        failure: function(resp, opts) {
             //Ext.Msg.hide();
        }
    });
}
/*-----调运分配Mst实体类窗体函数----*/
function ExportAll(isAll) {
    if(!isAll){
	    var sm = distributeGrid.getSelectionModel();
	    //获取选择的数据信息
	    //var selectData =  sm.getSelected();
	    var records=sm.getSelections();    
        if (records == null || records.length != 1) 
        {
            Ext.Msg.alert("提示", "请选一条记录信息！");
            return;
        }
        else 
        {     
            var selectData =  sm.getSelected();         
            
	    }
	} else {

	//Ext.Msg.wait('正在生成Excel文档, 请稍候……', "系统提示");
	var vExportContent = receiveGrid.getExcelXml();	
	    var tmpExportContent = receiveGrid.getExcelXml(); //此方法用到了一中的扩展  
	    if (!Ext.fly('frmDummy')) {
	        var frm = document.createElement('form');
	        frm.id = 'frmDummy';
	        frm.name = id;
	        frm.style.display = 'none';
	        document.body.appendChild(frm);
	    }
	    Ext.Ajax.request({
	        url: 'ExportService.aspx', //将生成的xml发送到服务器端  
	        method: 'POST',
	        form: Ext.fly('frmDummy'),
	        isUpload: true, 
	        params: {
	            ExportContent: tmpExportContent,
	            ExportFile:  '应收账款明细.xls',
                ignoreDept:ignoredept
	        }
	    });  
	    
	    
	}
	    
}

/*------开始获取数据的函数 start---------------*/
var dsReceiveGrid = new Ext.data.Store
({
proxy: new Ext.data.HttpProxy({
   url: "frmFmAccountRecList.aspx?method=getReceiveList",
   timeout: 300000
}),
//url: 'frmFmAccountRecList.aspx?method=getReceiveList',
reader:new Ext.data.JsonReader({
	totalProperty:'totalProperty',
	root:'root'
},[
	{ name: '日期' },
	{ name: '客户编号' },
	{ name: '客户名称' },
	{ name: '摘要' },
	{ name: '借方' },
	{ name: '贷方' },
	])
});

/*------获取数据的函数 结束 End---------------*/
/*------开始查询form end---------------*/

    //开始日期
    var distributeStartPanel = new Ext.form.DateField({
        xtype:'datefield',
        fieldLabel:'开始日期',
        anchor:'95%',
        name:'StartDate',
        id:'StartDate',
        format: 'Y年m月d日',  //添加中文样式
        value:new Date().clearTime() 
    });

    //结束日期
    var distributeEndPanel = new Ext.form.DateField({
        xtype:'datefield',
        fieldLabel:'结束日期',
        anchor:'95%',
        name:'EndDate',
        id:'EndDate',
        format: 'Y年m月d日',  //添加中文样式
        value:new Date().clearTime()
    });
    var typeComboPanel = new Ext.form.ComboBox({
        fieldLabel: '查询类型',
        id: 'typeMoveTo',
        name: 'typeMoveTo',
        store: [[0,'全部收款记录'],[1,'借贷不平收款记录'],[3,'按客户汇总收款记录'],[4,'区段应收账款']],//[2,'按客户小计查询收款记录']
        mode: 'local',
        editable: false,
        //loadText:'loading ...',
        typeAhead: true, //自动将第一个搜索到的选项补全输入
        triggerAction: 'all',
        selectOnFocus: true,
        forceSelection: true,
        width: 150,
        value:3,
        listeners:{
            select: function(combo, record, index) {
                if(combo.getValue()==4){
                    receiveGrid.getColumnModel().setColumnHeader( 6, '上期余额');
                    receiveGrid.getColumnModel().setColumnHeader( 7, '本期余额');
                    receiveGrid.getColumnModel().setHidden(5, true);
                    receiveGrid.getColumnModel().setHidden(2, true);
                }else{
                    receiveGrid.getColumnModel().setColumnHeader( 6, '借方');
                    receiveGrid.getColumnModel().setColumnHeader( 7, '贷方');
                    receiveGrid.getColumnModel().setHidden(5, false);
                    receiveGrid.getColumnModel().setHidden(2, false);
                }
            }
        }
    });
    
    var serchform = new Ext.FormPanel({
        renderTo: 'searchForm',
        labelAlign: 'left',
        layout:'fit',
        buttonAlign: 'right',
        bodyStyle: 'padding:5px',
        frame: true,        
        items: [{
            layout: 'column',   //定义该元素为布局为列布局方式
            border: false,
            items: [{
                columnWidth: .3,  //该列占用的宽度，标识为20％
                layout: 'form',
                border: false,
                labelWidth: 60,
                items: [
                    typeComboPanel
                ]
            },{
                columnWidth: .28,  //该列占用的宽度，标识为20％
                layout: 'form',
                labelWidth: 80,
                border: false,
                items: [
                    distributeStartPanel
                ]
            }, {
                columnWidth: .28,
                layout: 'form',
                labelWidth: 80,
                border: false,
                items: [
                    distributeEndPanel
                    ]
            }, {
                columnWidth: .08,
                layout: 'form',
                border: false,
                items: [{ cls: 'key',
                    xtype: 'button',
                    text: '查询',
                    anchor: '50%',
                    handler :function(){
                    
                    var starttime=distributeStartPanel.getValue();
                    var endtime = distributeEndPanel.getValue().add(Date.DAY, 1);
                    var stype = typeComboPanel.getValue();

                    dsReceiveGrid.baseParams.StartDate = Ext.util.Format.date(starttime, 'Y/m/d');
                    dsReceiveGrid.baseParams.EndDate = Ext.util.Format.date(endtime, 'Y/m/d');
                    dsReceiveGrid.baseParams.queryType = stype;
                    dsReceiveGrid.baseParams.ignoreDept = ignoredept;
                    
                    dsReceiveGrid.removeAll();
                    dsReceiveGrid.load({
                                params : {
                                start : 0,
                                limit : 32767
                                } });
                    }
                }]
            }]
        }]
    });
/*------开始查询form end---------------*/
/*------开始DataGrid的函数 start---------------*/

var sm= new Ext.grid.CheckboxSelectionModel({
	singleSelect:false
});
var receiveGrid = new Ext.grid.GridPanel({
	el: 'sendGrid',
	width:'100%',
	//height:'100%',
	height: 400,
	autoWidth:true,
	//autoHeight:true,
	autoScroll:true,
	layout: 'fit',
	title: '应收账款明细',
	store: dsReceiveGrid,
	loadMask: {msg:'正在加载数据，请稍侯……'},
	sm:sm,
	cm: new Ext.grid.ColumnModel([
		sm,
		new Ext.grid.RowNumberer(),//自动行号
		{
			header:'日期',
			dataIndex: '日期',
			id: 'CreateDate',
			width:50
		},
		{
		    header: '客户编号',
		    dataIndex: '客户编号',
		    id: 'CustomerNo',
		    width:40
		},
		{
		    header: '客户名称',
		    dataIndex: '客户名称',
		    id: 'CustomerName',
		    width: 150
		},
		{
		    header: '摘要',
		    dataIndex: '摘要',
		    id: 'Desc',
		    width: 35
		},
		{
		    header: '借方',
		    dataIndex: '借方',
			id:'A'
		},
		{
		    header: '贷方',
		    dataIndex: '贷方',
			id:'B'
		}		]),
		viewConfig: {
			columnsText: '显示的列',
			scrollOffset: 20,
			sortAscText: '升序',
			sortDescText: '降序',
			forceFit: true
		},
		enableHdMenu: false,  //不显示排序字段和显示的列下拉框
		enableColumnMove: false,//列不能移动
		closeAction: 'hide',
		stripeRows: true,
		loadMask: true,
		autoExpandColumn: 2
	});
	receiveGrid.render();

/*------明细DataGrid的函数结束 End---------------*/

})
</script>
</html>
