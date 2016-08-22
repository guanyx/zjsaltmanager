<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmAdmDocReportCreate.aspx.cs" Inherits="BA_sysadmin_frmAdmDocReportCreate" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>无标题页</title>
    
<link rel="stylesheet" type="text/css" href="../../ext3/resources/css/ext-all.css" />
<script type="text/javascript" src="../../ext3/adapter/ext/ext-base.js"></script>
<script type="text/javascript" src="../../ext3/ext-all.js"></script>
<script type="text/javascript" src="../../js/operateResp.js"></script>
<script type="text/javascript" src="../../js/OfficeOperator.js"></script>
<link rel="stylesheet" type="text/css" href="../../ext3/example/file-upload.css" />
<script type="text/javascript" src="../../ext3/example/FileUploadField.js"></script>

<%=GetScript() %>
<script type="text/javascript">


Ext.onReady(function () {
var saveType="";
/*---------------列表信息--------------*/
/*------实现toolbar的函数 start---------------*/
var Toolbar = new Ext.Toolbar({
	renderTo:"toolbar",
	items:[{
		text:"新增",
		icon:"images/extjs/customer/add16.gif",
		handler:function(){
		        reportId=0;
		        addNewDoc();
		    }
		},'-',{
		text:"编辑",
		icon:"images/extjs/customer/edit16.gif",
		handler:function(){
		        saveType = "editDoc";
		        modifyDoc();
		    }
		},'-',{
		text:"删除",
		icon:"images/extjs/customer/delete16.gif",
		handler:function(){
		    deleteDoc();
		}
	}]
});
/*---------新增DocReport---------------*/
function addNewDoc()
{
    Ext.getCmp("RepordName").setValue("");
    Ext.getCmp("RepordMemo").setValue("");
    Ext.getCmp("ContarctAttach").setValue("");
    bookMarkGridData.removeAll();
    mulDetailGridData.removeAll();
    mulColumnGridData.removeAll();
    mulColumnGridSource.removeAll();
    saveType = "addDoc";
    
    cardPanel.show();
    i =0;
    this.cardPanel.getLayout().setActiveItem(0);
}

/*---------修改DocReport---------------*/
function modifyDoc()
{
     var sm = Ext.getCmp('docReportGrid').getSelectionModel();
    //获取选择的数据信息
    var selectData = sm.getSelected();
    //如果没有选择，就提示需要选择数据信息
    if (selectData == null) {
        Ext.Msg.alert("提示", "请选中需要修改的信息！");
        return;
    }
    reportId = selectData.data.RepordId;
    Ext.getCmp("RepordName").setValue(selectData.data.RepordName);
    Ext.getCmp("RepordMemo").setValue(selectData.data.RepordMemo);
    
    if(reportId>0)
    {
        if(bookMarkGridData.baseParams.ReportId!=reportId)
        {
//            if(typeof(mulDetailGridData.url)=='undefined')
//            {
//                mulDetailGridData.url="frmAdmDocReportCreate.aspx?method=getmuldetailcolumn";
//            }
            bookMarkGridData.baseParams.ReportId=reportId;
            bookMarkGridData.load();
            
//            if(typeof(mulDetailGridData.url)=='undefined')
//            {
//                mulDetailGridData.url="frmAdmDocReportCreate.aspx?method=getmuldetailcolumn";
//            }
            mulDetailGridData.baseParams.ReportId=reportId;
            mulDetailGridData.load();
        }
    }
    
    cardPanel.show();
    i =0;
    this.cardPanel.getLayout().setActiveItem(0);    
    
}

/*删除信息*/
        function deleteDoc() {
            var sm = Ext.getCmp('docReportGrid').getSelectionModel();
            //获取选择的数据信息
            var selectData = sm.getSelected();
            //如果没有选择，就提示需要选择数据信息
            if (selectData == null) {
                Ext.Msg.alert("提示", "请选中需要删除的信息！");
                return;
            }
            //删除前再次提醒是否真的要删除
            Ext.Msg.confirm("提示信息", "是否真的要删除选择的信息吗？", function callBack(id) {
                //判断是否删除数据
                if (id == "yes") {
                    //页面提交
                    Ext.Ajax.request({
                        url: 'frmAdmDocReportCreate.aspx?method=deletedoc',
                        method: 'POST',
                        params: {
                            ReportId: selectData.data.RepordId
                        },
                        success: function(resp, opts) {
                           if(checkExtMessage(resp))
                           {
                                docReportData.reload();
                           }
                        },
                        failure: function(resp, opts) {
                            Ext.Msg.alert("提示", "数据删除失败");
                        }
                    });
                }
            });
        }


var docReportData = new Ext.data.Store
({
url: 'frmAdmDocReportCreate.aspx?method=getdocreportlist',
reader:new Ext.data.JsonReader({
	totalProperty:'totalProperty',
	root:'root'
},[
	{
		name:'RepordId'
	},
	{
		name:'RepordName'
	},
	{
		name:'RepordMemo'
	},
	{
		name:'OperId'
	},
	{
		name:'CreateDate'
	},
	{
		name:'ReportPrimaryTable'
	},
	{
		name:'ReportPrimaryColumn'
	}	])
	,
	listeners:
	{
		scope:this,
		load:function(){
		}
	}
});

/*------获取数据的函数 结束 End---------------*/

/*------开始DataGrid的函数 start---------------*/

var sm= new Ext.grid.CheckboxSelectionModel({
	singleSelect:true
});
var docReportGrid = new Ext.grid.GridPanel({
	el: 'docReportGrid',
	width:'100%',
	height:'100%',
	autoWidth:true,
	autoHeight:true,
	autoScroll:true,
	layout: 'fit',
	id: 'docReportGrid',
	store: docReportData,
	loadMask: {msg:'正在加载数据，请稍侯……'},
	sm:sm,
	cm: new Ext.grid.ColumnModel([
		sm,
		new Ext.grid.RowNumberer(),//自动行号
		{
			header:'标识',
			dataIndex:'RepordId',
			id:'RepordId'
		},
		{
			header:'报表名称',
			dataIndex:'RepordName',
			id:'RepordName'
		},
		{
			header:'备注',
			dataIndex:'RepordMemo',
			id:'RepordMemo'
		},
		{
			header:'创建人',
			dataIndex:'OperId',
			id:'OperId'
		},
		{
			header:'创建时间',
			dataIndex:'CreateDate',
			id:'CreateDate'
		}		]),
		bbar: new Ext.PagingToolbar({
			pageSize: 10,
			store: docReportData,
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
		height: 280,
		closeAction: 'hide',
		stripeRows: true,
		loadMask: true,
		autoExpandColumn: 2
	});
docReportGrid.render();
/*---------------第一步，创建报表名称信息--------------*/
    this.zeroPanel = new Ext.Panel({
        frame: true,   
        title: '设置模板',
        layout:"form",
        html:"<object classid='clsid:00460182-9E5E-11d5-B7C8-B8269041DD57' id='oframe' width='100%' height='100%'>"+
         "<param name='BorderStyle' value='1'>"+
         "<param name='TitlebarColor' value='52479'>"+
         "<param name='TitlebarTextColor' value='0'>"+
         "<param name='Toolbars' value='0'> "+
         "<param name='Menubar' value='1'> "+
         "</object>"
    }); 
    
    
    this.firstPanel = new Ext.form.FormPanel({   
        frame: true,   
        title: '报表信息',
        layout:"form",
        fileUpload:true, 
        items:[
        {
				    xtype: 'textfield',
				    fieldLabel: '报表名称',
				    columnWidth: 0.33,
				    anchor: '95%',
				    name: 'RepordName',
				    id: 'RepordName'   
				},{
				    xtype: 'textfield',
				    fieldLabel: '数据主表',
				    columnWidth: 0.33,
				    anchor: '95%',
				    name: 'ReportPrimaryTable',
				    id: 'ReportPrimaryTable'   
				},{
				    xtype: 'textfield',
				    fieldLabel: '数据主键',
				    columnWidth: 0.33,
				    anchor: '95%',
				    name: 'ReportPrimaryColumn',
				    id: 'ReportPrimaryColumn'   
				},{
				    xtype: 'textarea',
				    fieldLabel: '备注',
				    columnWidth: 0.33,
				    anchor: '95%',
				    name: 'RepordMemo',
				    id: 'RepordMemo'    
				},{
				    xtype: 'fileuploadfield',
				    fieldLabel: '文档',
				    emptyText:'请选择附件',
				    anchor: '90%',
				    name: 'ContarctAttach',
				    id: 'ContarctAttach',
				    buttonText: '选择'
				    }
				
				]  
    }); 

function setFormValue() {
            Ext.Ajax.request({
                url: 'frmAdmDocReportCreate.aspx?method=getdocreport',
                params: {
                    reportId: reportId
                },
                success: function(resp, opts) {
                    var data = Ext.util.JSON.decode(resp.responseText);
                    Ext.getCmp("RepordName").setValue(data.RepordName);
                    Ext.getCmp("RepordMemo").setValue(data.RepordMemo);
                },
                failure: function(resp, opts) {
                    Ext.Msg.alert("提示", "获取信息失败");
                }
            });
        }
if(reportId>0)
{
    setFormValue();
}
/*---------------第二步，设置报表书签信息--------------*/

var bookMarkGridData = new Ext.data.Store
({
url: 'frmAdmDocReportCreate.aspx?method=getbookmark',
reader:new Ext.data.JsonReader({
	totalProperty:'totalProperty',
	root:'root'
},[
	{
		name:'ReportDetailId'
	},
	{
		name:'ReportId'
	},
	{
		name:'DetailObjectname'
	},
	{
		name:'DetailBookmark'
	},
	{
		name:'DetailObjectproperty'
	}	])
	,
	listeners:
	{
		scope:this,
		load:function(store){		    
		    if(store.data.length==0)
		    {
		        insertNewBlankRow();
		    }		    
		}
	}
});

var bookMarkPattern = Ext.data.Record.create([
           { name: 'ReportDetailId', type: 'string' },
           { name: 'ReportId', type: 'string' },
           { name: 'DetailObjectname', type: 'string' },
           { name: 'DetailBookmark', type: 'string' },
           { name: 'DetailObjectproperty' }
          ]);

function insertNewBlankRow() {
    var rowCount = bookMarkGrid.getStore().getCount();
    var insertPos = parseInt(rowCount);
    var addRow = new bookMarkPattern({
        ReportDetailId: '0',
        ReportId: '0',
        DetailObjectname: '',
        DetailBookmark: '',
        DetailObjectproperty: ''
    });
    bookMarkGrid.stopEditing();
    if (insertPos > 0) {
        var rowIndex = bookMarkGridData.insert(insertPos, addRow);
        bookMarkGrid.startEditing(insertPos, 0);
    }
    else {
        var rowIndex = bookMarkGridData.insert(0, addRow);
        // planDtlGrid.startEditing(0, 0);
    }
}

function addNewBlankRow() {
    var rowIndex = bookMarkGrid.getStore().indexOf(bookMarkGrid.getSelectionModel().getSelected());
    var rowCount = bookMarkGrid.getStore().getCount();
    if ((rowIndex == 0 && rowCount == 1) || rowIndex == rowCount - 1) {
        insertNewBlankRow();
    }
}
        
var sm= new Ext.grid.CheckboxSelectionModel({
	singleSelect:true
});
var bookMarkGrid = new Ext.grid.EditorGridPanel({
	width:'100%',
	height:'100%',
	autoWidth:true,
	autoHeight:true,
	autoScroll:true,
	layout: 'fit',
	id: 'bookMarkGrid',
	store: bookMarkGridData,
	loadMask: {msg:'正在加载数据，请稍侯……'},
	sm:sm,
	cm: new Ext.grid.ColumnModel([
		sm,
		new Ext.grid.RowNumberer(),//自动行号
		{
			header:'对象名',
			dataIndex:'DetailObjectname',
			id:'DetailObjectname',
			editor:new Ext.form.TextField(
			    {
			        allowBlank:false,
			        listeners:{'change':function(){
                    addNewBlankRow();
                    }}
                })
			

		},
		{
			header:'书签名',
			dataIndex:'DetailBookmark',
			id:'DetailBookmark',
			editor:new Ext.form.TextField({allowBlank:false})
		},
		{
			header:'对象属性名',
			dataIndex:'DetailObjectproperty',
			id:'DetailObjectproperty',
			editor:new Ext.form.TextField({allowBlank:false})
		}		]),
		viewConfig: {
			columnsText: '显示的列',
			scrollOffset: 20,
			sortAscText: '升序',
			sortDescText: '降序',
			forceFit: true
		},
		height: 280,
		closeAction: 'hide',
		stripeRows: true,
		loadMask: true,
		autoExpandColumn: 2
	});
    this.secondPanel = new Ext.Panel({   
        frame: true,   
        title: '报表信息',
        layout:"form",
        items:[bookMarkGrid]  
    });
    
/*---------------第三步，设置报表行数据显示信息--------------*/

var mulDetailPattern = Ext.data.Record.create([
           { name: 'ReportMuldetailId', type: 'string' },
           { name: 'ReportId', type: 'string' },
           { name: 'DetailTableName', type: 'string' },
           { name: 'DetailObjectName', type: 'string' },
           { name: 'DetailMinrows' },
           { name: 'DetailStartindex' },
           { name:'DetailToobject'},
           { name:'DetailTocolumn'}
          ]);

function insertmulDetailNewBlankRow() {
    var rowCount = mulDetailGrid.getStore().getCount();
    var insertPos = parseInt(rowCount);
    var addRow = new mulDetailPattern({
        ReportMuldetailId: -rowCount,
        ReportId: reportId,
        DetailTableName: '',
        DetailObjectName: '',
        DetailMinrows: '',
        DetailStartindex:'',
        DetailToobject:'',
        DetailTocolumn:''
    });
    mulDetailGrid.stopEditing();
    if (insertPos > 0) {
        var rowIndex = mulDetailGridData.insert(insertPos, addRow);
        mulDetailGrid.startEditing(insertPos, 0);
    }
    else {
        var rowIndex = mulDetailGridData.insert(0, addRow);
        // planDtlGrid.startEditing(0, 0);
    }
}

function addMulNewBlankRow() {
    var rowIndex = mulDetailGrid.getStore().indexOf(mulDetailGrid.getSelectionModel().getSelected());
    var rowCount = mulDetailGrid.getStore().getCount();
    if ((rowIndex == 0 && rowCount == 1) || rowIndex == rowCount - 1) {
        insertmulDetailNewBlankRow();
    }
}

var mulDetailGridData = new Ext.data.Store
({
url: 'frmAdmDocReportCreate.aspx?method=getmuldetail',
reader:new Ext.data.JsonReader({
	totalProperty:'totalProperty',
	root:'root'
},[
	{
		name:'ReportMuldetailId'
	},
	{
		name:'ReprotId'
	},
	{
		name:'DetailTableName'
	},
	{
		name:'DetailObjectName'
	},
	{
		name:'DetailMinrows'
	},
	{
		name:'DetailStartindex'
	},
	{
		name:'DetailToobject'
	},
	{
		name:'DetailTocolumn'
	}	])
	,
	listeners:
	{
		scope:this,
		load:function(store){
		    
		    if(store.data.length==0)
		    {
		        addMulNewBlankRow();
		    }
		    else
		    {
		        var ids = "";
		        store.each(function(record){
		            if(ids.length>0)
		                ids+=",";
		            ids+=record.data.ReportMuldetailId;
		        });
		        mulColumnGridData.baseParams.ReportMuldetailId=ids;
                mulColumnGridData.load();
            }
		}
	}
});

/*------获取数据的函数 结束 End---------------*/

/*------开始DataGrid的函数 start---------------*/

var sm= new Ext.grid.CheckboxSelectionModel({
	singleSelect:true
});
var mulDetailGrid = new Ext.grid.EditorGridPanel({
	width:'100%',
	height:'100%',
	autoWidth:true,
	autoHeight:true,
	autoScroll:true,
	layout: 'fit',
	id: 'mulDetailGrid',
	store: mulDetailGridData,
	loadMask: {msg:'正在加载数据，请稍侯……'},
	sm:sm,
	cm: new Ext.grid.ColumnModel([
		sm,
		new Ext.grid.RowNumberer(),//自动行号
		{
			header:'细表对应TableName',
			dataIndex:'DetailTableName',
			id:'DetailTableName',
			editor:new Ext.form.TextField({
			    allowBlank:false,
			        listeners:{'change':function(){
                    addMulNewBlankRow();
                    }}
			})
		},
		{
			header:'对应对象名',
			dataIndex:'DetailObjectName',
			id:'DetailObjectName',
			editor:new Ext.form.TextField({allowBlank:false})
		},
		{
			header:'最小行数',
			dataIndex:'DetailMinrows',
			id:'DetailMinrows',
			editor:new Ext.form.NumberField({allowBlank:false})
		},
		{
			header:'起始行',
			dataIndex:'DetailStartindex',
			id:'DetailStartindex',
			editor:new Ext.form.NumberField({allowBlank:false})
		},
		{
			header:'对应主表',
			dataIndex:'DetailToobject',
			id:'DetailToobject',
			editor:new Ext.form.TextField({allowBlank:false})
		},
		{
			header:'对应键',
			dataIndex:'DetailTocolumn',
			id:'DetailTocolumn',
			editor:new Ext.form.TextField({allowBlank:false})
		}		]),
		viewConfig: {
			columnsText: '显示的列',
			scrollOffset: 20,
			sortAscText: '升序',
			sortDescText: '降序',
			forceFit: true
		},
		height: 280,
		closeAction: 'hide',
		stripeRows: true,
		loadMask: true,
		autoExpandColumn: 2
	});

this.threePanel = new Ext.Panel({   
        frame: true,   
        title: '报表信息',
        layout:"form",
        items:[mulDetailGrid]
    });
    
/*---------------第四步，设置报表行数据列信息--------------*/

var reportMuldetailId=0;
var mulColumnPattern = Ext.data.Record.create([
           { name: 'ReportMuldetailId', type: 'string' },
           { name: 'MuldetailCellindex', type: 'string' },
           { name: 'MuldetailObjectname', type: 'string' }
          ]);

function insertmulColumnNewBlankRow() {
    var rowCount = mulColumnGrid.getStore().getCount();
    var insertPos = parseInt(rowCount);
    var addRow = new mulColumnPattern({
        ReportMuldetailId:reportMuldetailId,
        MuldetailCellindex: '0',
        MuldetailObjectname: ''
    });
    mulColumnGrid.stopEditing();
    if (insertPos > 0) {
        var rowIndex = mulColumnGridSource.insert(insertPos, addRow);
        mulColumnGrid.startEditing(insertPos, 0);
    }
    else {
        var rowIndex = mulColumnGridSource.insert(0, addRow);
        // planDtlGrid.startEditing(0, 0);
    }
}

function addColumnNewBlankRow() {
    var rowIndex = mulColumnGrid.getStore().indexOf(mulColumnGrid.getSelectionModel().getSelected());
    var rowCount = mulColumnGrid.getStore().getCount();
    if ((rowIndex == 0 && rowCount == 1) || rowIndex == rowCount - 1) {
        insertmulColumnNewBlankRow();
    }
}

var mulColumnGridData = new Ext.data.Store
({
url: 'frmAdmDocReportCreate.aspx?method=getmuldetailcolumn',
reader:new Ext.data.JsonReader({
	totalProperty:'totalProperty',
	root:'root'
},[
	{
		name:'ReportMuldetailId'
	},
	{
		name:'MuldetailCellindex'
	},
	{
		name:'MuldetailObjectname'
	}	])
	,
	listeners:
	{
		scope:this,
		load:function(){
		}
	}
});

var mulColumnGridSource = new Ext.data.Store
({
//url: 'frmAdmDocReportCreate.aspx?method=getmulcolumn',
reader:new Ext.data.JsonReader({
	totalProperty:'totalProperty',
	root:'root'
},[
	{
		name:'ReportMuldetailId'
	},
	{
		name:'MuldetailCellindex'
	},
	{
		name:'MuldetailObjectname'
	}	])
});

/*------获取数据的函数 结束 End---------------*/

/*------开始DataGrid的函数 start---------------*/

var sm= new Ext.grid.CheckboxSelectionModel({
	singleSelect:true
});
var mulColumnGrid = new Ext.grid.EditorGridPanel({
	width:'100%',
	height:'100%',
	autoWidth:true,
	autoHeight:true,
	autoScroll:true,
	layout: 'fit',
	id: 'mulColumnGrid',
	store: mulColumnGridSource,
	loadMask: {msg:'正在加载数据，请稍侯……'},
	sm:sm,
	cm: new Ext.grid.ColumnModel([
		sm,
		new Ext.grid.RowNumberer(),//自动行号
		{ header:'mul细项ID',dataIndex:'ReportMuldetailId',id:'ReportMuldetailId'},
		{
			header:'列Index',
			dataIndex:'MuldetailCellindex',
			id:'MuldetailCellindex',
			editor:new Ext.form.TextField({
			    allowBlank:false,
			        listeners:{'change':function(){
                        addColumnNewBlankRow();
                    }}
			})
		},
		{
			header:'对象名',
			dataIndex:'MuldetailObjectname',
			id:'MuldetailObjectname',
			editor:new Ext.form.TextField({allowBlank:false})
		}		]),
		viewConfig: {
			columnsText: '显示的列',
			scrollOffset: 20,
			sortAscText: '升序',
			sortDescText: '降序',
			forceFit: true
		},
		height: 280,
		closeAction: 'hide',
		stripeRows: true,
		loadMask: true,
		autoExpandColumn: 2
	});
	
	this.fourPanel = new Ext.Panel({   
        frame: true,   
        title: '报表信息',
        layout:"form",
        items:[mulColumnGrid]
    });
/*----------------CardPanel设置---------------------*/
    var i = 0;   
    function cardHandler(direction) {
        if (direction == -1) {   
            i--;   
            if (i < 0) {   
                i = 0;   
            }   
        }   
        if (direction == 1) {   
            i++;   
            if (i > 4) {   
                i = 4;   
                return false;   
            }   
        }           
        switch(i)
        {
            case 0:
                
                break;
                
            case 1:
//                try
//                {
//                  
                   
                    if(DosFrame==null)
                    {
                        DosFrame = document.getElementById("oframe");
                    }
                   
//                }
//                catch(ess)
//                {
//                    alert(ess);
//                    addNewBlankRow();
//                }
                break;
                //采购计划,设置过滤条件，获取采购数据
            case 2:
                if(direction==1)
                {
                    if(bookMarkGridData.data.length==0)
                    {
                            try
                            {
                                var count = DosFrame.ActiveDocument.BookMarks.count;
                                for(var j=1;j<=count;j++)
                                {
                                    var name = DosFrame.ActiveDocument.BookMarks(j).name;
                                    var addRow = new bookMarkPattern({
                                        ReportDetailId: '0',
                                        ReportId: '0',
                                        DetailObjectname: '',
                                        DetailBookmark:name ,
                                        DetailObjectproperty: ''
                                    });
                                    bookMarkGridData.insert(j-1, addRow);                                
                                 }
                            if(count==0)
                            {
                                                      
                             }
                         }
                         catch(err)
                         {
                            addNewBlankRow(); 
                         }
                    }
                }                
                break;
             case 3:
                if(direction==1)
                {
                    if(mulDetailGridData.data.length==0)
                    {
                        addMulNewBlankRow();
                    }
                }
                
                break;
            case 4:
                if(direction==1)
                {
                    var sm = Ext.getCmp('mulDetailGrid').getSelectionModel();
                    //获取选择的数据信息
                    var selectData = sm.getSelected();
                    //如果没有选择，就提示需要选择数据信息
                    if (selectData == null) {
                        Ext.Msg.alert("提示", "请选中需要设置的细项信息！");
                        i=2;
                        return;
                    }
                    reportMuldetailId = selectData.data.ReportMuldetailId;
                    var count = mulColumnGridSource.getCount();
                    for(var j=0;j<count;j++)
                    {
                       var record = mulColumnGridSource.getAt(j);
                       if(record.data.MuldetailObjectname=="")
                            continue;
                       mulColumnGridData.add(new mulColumnPattern({
                            ReportMuldetailId:record.data.ReportMuldetailId,
                            MuldetailCellindex: record.data.MuldetailCellindex,
                            MuldetailObjectname: record.data.MuldetailObjectname
                        }));   
                    }
                    mulColumnGridSource.removeAll();
                    for(var j=0;j<mulColumnGridData.getCount();j++)
                    {
                        var record = mulColumnGridData.getAt(j);
                        if(record.data.ReportMuldetailId ==
                            reportMuldetailId)
                        {                            
                            mulColumnGridSource.add(new mulColumnPattern({
                                ReportMuldetailId:record.data.ReportMuldetailId,
                                MuldetailCellindex: record.data.MuldetailCellindex,
                                MuldetailObjectname: record.data.MuldetailObjectname
                            }));  
                            mulColumnGridData.remove(record);
                            j--;
                        }
                    }
                    
                    
//                    mulColumnGridData.clearFilter();
//                   mulColumnGridData.filter('ReportMuldetailId',selectData.data.ReportMuldetailId);
                   addColumnNewBlankRow();  
                }
                break;

                
        }        
        setButtonShow(i);
        this.cardPanel.getLayout().setActiveItem(i);   
    };
    
    //设置Button信息
    function setButtonShow(index)
    {
        var btnNext = Ext.getCmp("move-next");   
        var btnPrev = Ext.getCmp("move-prev");   
        var btnSave = Ext.getCmp("move-save"); 
        var btnBack = Ext.getCmp("move-back"); 
        switch(index)
        {
            case 0:
                btnSave.hide();  
                btnNext.show(); 
                //btnNext.enable();   
                btnPrev.hide(); 
                btnBack.hide();
            break;
            case 1:
                 btnSave.show();  
                btnNext.show();   
                btnPrev.show(); 
                btnBack.show();
                break;
            case 2:
            case 3:
                btnSave.show();  
                btnNext.show();   
                btnPrev.show(); 
                 btnBack.hide();
                
            break;
            case 4:
                btnSave.hide();
                btnNext.hide();
                btnPrev.show(); 
                btnBack.hide();
                break;
        }
        
    }
    
  
    //CARD总面板   
    this.cardPanel = new Ext.Window({   
        frame: true,   
        //title: 'Word报表创建向导',   
       // renderTo: "cardPanel",   
        height: 400,   
        width: 600,   
        layout: 'card',   
        activeItem: 0,   
        closeAction:'hide',
        bbar: ['->', {   
            id: 'move-prev',   
            text: '上一步',   
            handler: cardHandler.createDelegate(this, [-1])   
        },   
        {   
            id: 'move-save',   
            text: '保存',   
            hidden: true,   
            handler: function () {   
                //删除前再次提醒是否真的要删除
                Ext.Msg.confirm("提示信息", "是否已经全部配置完成？", function callBack(id) {
                    //判断是否删除数据
                    if (id == "yes") {
                        saveData(); 
                    }
                });
                               
            }   
        },   
        {   
            id: 'move-next',   
            text: '下一步',   
            handler: cardHandler.createDelegate(this, [1])   
        },{   
            id: 'move-back',   
            text: '查看文档',   
            hidden:true,
            handler: function () {     
                 var fileName = Ext.getCmp("ContarctAttach").getValue();
                    if(fileName=="")
                    {
                        if(reportId>0)
                        {
                            fileName="http://172.18.2.122/zjsigsite/Common/frmReadFile.aspx?filetype=mb&filename="+reportId;
                            DosFrame.open(fileName,true);   
                        }
                    }
                    else
                    {
                        DosFrame.Open(fileName);    
                    } 
            } 
        }],   
        items: [this.firstPanel,zeroPanel,secondPanel,this.threePanel,this.fourPanel]   
    });  
    
    function activeItemBack()
    {
        this.cardPanel.getLayout().setActiveItem(2);
    }
    //cardPanel.hide(); 
//    var win = new Ext.Window({
//          title : 'Word报表向导'
//          ,width: 650
//          ,height: 450
//          ,isTopContainer : true
//          , constrain: true
//	      ,closeAction:'hide'
//	      , resizable: false
//          ,modal : true
//          ,resizable: false
//          ,items:cardPanel
//          
//       });
    
    
    function saveData()
    {
         Ext.MessageBox.wait('正在保存数据中, 请稍候……');
         var bookMark="";
         var mulDetail="";
         var mulColumn="";
         bookMarkGridData.each(function(bookMarkData) {
            if(bookMarkData.data.DetailObjectname!="" && bookMarkData.data.DetailObjectproperty!="")
            {
                bookMark += Ext.util.JSON.encode(bookMarkData.data) + ',';
            }
         });
         bookMark = bookMark.substring(0, bookMark.length - 1);
         
         mulDetailGridData.each(function(mulDetailData){
            if(mulDetailData.data.DetailTableName!="")
            {
                mulDetail+=Ext.util.JSON.encode(mulDetailData.data) + ',';
            }
         });
         mulDetail = mulDetail.substring(0, mulDetail.length - 1);
         
         var count = mulColumnGridSource.getCount();
        for(var j=0;j<count;j++)
        {
           var record = mulColumnGridSource.getAt(j);
           if(record.data.MuldetailObjectname=="")
                continue;
           mulColumnGridData.add(new mulColumnPattern({
                ReportMuldetailId:record.data.ReportMuldetailId,
                MuldetailCellindex: record.data.MuldetailCellindex,
                MuldetailObjectname: record.data.MuldetailObjectname
            }));   
        }
                    
         mulColumnGridData.each(function(mulColumnData){
            if(mulColumnData.data.MuldetailCellindex!="")
            {
                mulColumn+=Ext.util.JSON.encode(mulColumnData.data) + ',';
            }
         });
         mulColumn = mulColumn.substring(0, mulColumn.length - 1);
         
            Ext.Ajax.request({
                url: 'frmAdmDocReportCreate.aspx?method=savedoc',
                method: 'POST',
                params: {
                    ReportId: reportId,
                    RepordName: Ext.getCmp('RepordName').getValue(),
                    RepordMemo: Ext.getCmp('RepordMemo').getValue(),
                    reportDetail:bookMark,
                    mulDetail:mulDetail,
                    mulColumn:mulColumn
                },
                success: function(resp, opts) {
                    Ext.MessageBox.hide();
                    if(checkExtMessage(resp))
                    {
                        var resu = Ext.decode(resp.responseText);
                        postFile(resu.id);
                    }
                },
                failure: function(resp, opts) {
                    Ext.MessageBox.hide();
                    Ext.Msg.alert("提示", "保存失败");
                }
            });
    }
    
    function postFile(docreportId)
    {
        Ext.Msg.wait("正在保存文档信息！");
            firstPanel.getForm().submit({  
                url : '../../common/frmUpLoadFile.aspx?filetype=mb&filename='+docreportId+'.doc',
                method: 'POST',
                params:{
                    ContarctAttach:Ext.getCmp('ContarctAttach').getValue()
                },
                success: function(resp, opts) {
                    Ext.MessageBox.hide();
                    if(checkExtMessage(resp))
                    {
                        
                    }
                },
                failure: function(resp, opts) {
                    Ext.MessageBox.hide();
                    Ext.Msg.alert("提示", "保存失败");
                }
                });
    }

})
</script>
</head>
<body>
    <form id="form1" runat="server">
    <div id="toolbar"></div>
    <div id="docReportGrid"></div>
    <div id="cardPanel">
    
    </div>
    </form>
</body>
</html>
