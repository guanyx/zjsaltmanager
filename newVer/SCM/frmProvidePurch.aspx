<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmProvidePurch.aspx.cs"  ResponseEncoding="gb2312" Inherits="SCM_frmProvidePurch" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>无标题页</title>

<link rel="stylesheet" type="text/css" href="../ext3/resources/css/ext-all.css" />
<script type="text/javascript" src="../ext3/adapter/ext/ext-base.js"></script>
<script type="text/javascript" src="../ext3/ext-all.js"></script>
<script type="text/javascript" src="../ext3/example/ItemDeleter.js"></script>
<link rel="stylesheet" type="text/css" href="../css/GroupHeaderPlugin.css" />
<script type="text/javascript" src="../js/floatUtil.js"></script>
<script type="text/javascript" src="../js/GroupHeaderPlugin.js"></script>
<link rel="stylesheet" href="../css/Ext.ux.grid.GridSummary.css"/>
<script src='../js/Ext.ux.grid.GridSummary.js'></script>
<script type="text/javascript" src="../js/operateResp.js"></script>
<script type="text/javascript" src="../js/ExtJsHelper.js"></script>
<script>
function cmbSendType(val) {
                    var index = SendTypeStore.find('DicsCode', val);
                    if (index < 0)
                        return "";
                    var record = SendTypeStore.getAt(index);
                    return record.data.DicsName;
                }
</script>
<%=getColModel() %>
<script type="text/javascript">
Ext.onReady(function(){



var sm = new Ext.grid.CheckboxSelectionModel({
            singleSelect: true
        });
        
//合计项
var summary = new Ext.ux.grid.GridSummary();
var planeGrid = new Ext.grid.EditorGridPanel({
                //renderTo:"gird",                
                id: 'planeGrid',
                //region:'center',
                split:true,
                store: gridStore ,
                autoscroll:true,
                clicksToEdit:1,
                loadMask: { msg: '正在加载数据，请稍侯……' },
                sm: sm,
                cm:colModel,
                viewConfig: {
                    columnsText: '显示的列',
                    scrollOffset: 20,
                    sortAscText: '升序',
                    sortDescText: '降序'
                    //forceFit: true
                },
                stripeRows: true,
                height:350,
                width:800,
                title:'要盐计划',
                plugins:[headerModel,summary],
                tbar : [{
                    id : 'btnSave',
                    text : '保存要盐情况',
                    iconCls : 'add',
                    icon: "../Theme/1/images/extjs/customer/save.gif",
                    handler : function() {
                        saveData();
                    }
                    },{
                    id : 'btnEditSalt',
                    text : '编辑当前盐种',
                    iconCls : 'add',
                    icon: "../Theme/1/images/extjs/customer/edit16.gif",
                    handler : function() {
                        createEditSaltView();
                    }
                    },{
                    id : 'btnEditSalt',
                    text : '数据导出',
                    iconCls : 'add',
                    icon: "../Theme/1/images/extjs/customer/edit16.gif",
                    handler : function() {
//                        var vExportContent = _dataGrid.getExcelXml(); 

                        var strheaderGroup = encodeURIComponent(GroupToXml(headerModel));
                        var strcolModel = encodeURIComponent(ColMolToXml(colModel));
                        var strData = encodeURIComponent(JsonToXml(gridStore,colModel));
                                               
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
                            params: { ExportContent: strData,ExportGroup:strheaderGroup,ExportModel:strcolModel,ExportFile: 'test.xls' }
                        });
                        Ext.Msg.hide();
                    }
                    }]
            });
   var gridPlan = new Ext.FormPanel({
        frame: true,
        id:"gridPanl",
        region:'center',
        layout:'fit',
        items:planeGrid
        });
        
    var currentSalt = 0;     
             // 单元格编辑后事件处理 
    planeGrid.on("beforeedit", afterEdit, planeGrid); 
    planeGrid.on("afteredit",computeAllFenPei,planeGrid);
    function computeAllFenPei(e){
        var record = e.record;// 被编辑的记录 
        var haveFeiPei = 0;
        for(var index=2;index<record.fields.keys.length;index++)
        {
            if(record.fields.keys[index].indexOf("product$")!=-1)
            {
                haveFeiPei+=getFloat(record.get(record.fields.keys[index]));            
            }
        }
        record.set('PurchQty',haveFeiPei);
    }
    // 事件处理函数 
    function afterEdit(e) { 
        var record = e.record;// 被编辑的记录 
        var array = e.field.split("$");
        var total = 0;
        var index =0;
        currentSalt = array[1];
        var haveFeiPei=0;
        for(;index<record.fields.keys.length;index++)
        {
            
            if(record.fields.keys[index]=="small"+array[1])
            {
                total = record.get(record.fields.keys[index]);
                break;
            }
        }
        
        var startIndex= index;
        //已经分配的量
        haveFeiPei=0;
        //获取相同单位的不同发送方式的数据量
        gridStore.each(function(gridStore) {
            if(gridStore.data.OrgId==record.data.OrgId)
            {
                index = startIndex;
                for(;index<gridStore.fields.keys.length;index++)
                {
                    if(gridStore.fields.keys[index]==e.field && gridStore.data.SendAdd==record.data.SendAdd &&
                        gridStore.data.SendType==record.data.SendType)
                        continue;
                    //同类型商品
                    if(gridStore.fields.keys[index].indexOf(array[0]+"$"+array[1]+"$")!=-1)
                    {
                        haveFeiPei+=getFloat( gridStore.get(gridStore.fields.keys[index]));
                    }
                }
            }
        });
        grid.setSource({
                "1.采购商品":colModel.columns[e.column].header,
                "2.供应商": getProvider(e.column),
                "3.要盐单位": e.record.data.OrgName,
                "4.采购总量": total,
                "5.已分配量": haveFeiPei,
                "6.还可分配量":(getFloat(total)-getFloat(haveFeiPei))
            });
       // grid.source["采购总量"] = '100';
//       "8.运送方式":resu.运送方式,
//                    "9.运送地址":resu.运送地址,
//                    "10.备注":resu.备注
        
//         // 更新界面, 来真正删除数据 
//        Ext.Msg.alert('您成功修改了用户信息', "被修改的用户是:" + e.record.data.OrgName + "\n 修改的字段是:" 
//        + e.field);// 取得用户名 
    } 
function getFloat(value)
{
    if(value=='')
        return 0;
    return parseFloat(value);
}

function getProvider(column)
{
    var columns=0;
    for(var i=0;i<headerModel.config.rows[0].length;i++)
    {
        columns+=headerModel.config.rows[0][i].colspan;
        if(columns>column)
        {
            return headerModel.config.rows[0][i].header;
        }
    }
    return "";
}

//保存数据信息
function saveData()
{
    var json = "";
    var gridStore = planeGrid.getStore();
    gridStore.each(function(gridStore) {
        json += Ext.util.JSON.encode(gridStore.data) + ',';
    });
    json = json.substring(0, json.length - 1);
    Ext.Msg.wait("数据正在保存……");
    Ext.Ajax.request({
        url: 'frmProvidePurch.aspx?method=saveprovide',
        method: 'POST',
        params: {
            planIds:planIds,
            Json: json
        },
        success: function(resp, opts) {
            Ext.Msg.hide();
            if(checkExtMessage(resp))
            {
                //uploadMstWindow.hide();
            }
        },
        failure: function(resp, opts) {
             Ext.Msg.hide();
            Ext.Msg.alert("提示", "保存失败");
        }
    });
}

var grid = new Ext.grid.PropertyGrid({   
    title: '属性表格',   
    autoHeight: true,   
    width: 300,
    split:true,
    nameText:'Style',
    sortable:false,
    //valueText:'值',
    //renderTo: 'grid',   
    //region:'east',
    source: {   
        "1.采购商品": "",   
        "2.供应商": '',   
        "3.要盐单位": '',   
        "4.采购总量": '',   
        "5.已分配量": 0,
        "6.还可分配量":0  
    }   
});
grid.colModel.config[0].header="类型";
grid.colModel.config[0].sortable=false;
grid.colModel.config[1].header="值";
grid.on("beforeedit", function(e){   
    e.cancel = true;   
    return false;   
});  

var tabPanel =	new Ext.TabPanel({
			region:'east',
			deferredRender:false,
			//autoScroll :true,
			//autoWidth :true,
			autoShow :true,
			autoDestroy :true,
			activeTab:0,
			split:true,
		    width: 200,
		    minSize: 160,
		    maxSize: 200,
		    collapsible: true,
			
			items:[grid]
	});
            //reader.readRecords(gridData);
   new Ext.Viewport({ layout: 'border', items: [
            gridPlan, tabPanel]
        });
        
    function createEditSaltView()
    {
        var smallClass = currentSalt;
        if(currentSalt==0)
        {
            alert('没有选择当前编辑的盐种！');
            return;
        }
        var strCol = "";
        for(var i=0;i<colModel.config.length;i++)
        {
            if(colModel.config[i].dataIndex.indexOf('product$'+smallClass+'$')!=-1)
            {
                strCol+=",{dataIndex:'"+colModel.config[i].dataIndex+"',header:'"+getProvider(i)+"',";
                strCol+="editor:new Ext.form.NumberField({listeners: {'focus': function() {this.selectText();}}})}";
            }
        }
        strCol="{'colModel':[{dataIndex:'OrgName',isColumn:'true',header:'单位名称'},{dataIndex:'small"+smallClass+"',isColumn:'true',header:'计划数量'}"+strCol+"]}";
        var json = Ext.util.JSON.decode(strCol);
        var cm1 = new Ext.grid.ColumnModel(json.colModel);
        
        var grid1 = new Ext.grid.EditorGridPanel({
            width: 600,
            height: 400,
            border: true,
            split:true,
            store: gridStore,
            sm: sm,
            clicksToEdit:1,
            cm: cm1,
            stripeRows: true,
            tbar : [{
                    id : 'btnOK',
                    text : '确定',
                    iconCls : 'add',
                    icon: "../Theme/1/images/extjs/customer/checked.gif",
                    handler : function() {
                        grid1.destroy();
                    }
                    }]
        });
        grid1.render("editgrid");
    }
})
</script>
</head>
<body>
    <form id="form1" runat="server">
    <div id="gird">
    
    </div>
    <div id="editgrid"></div>
    </form>
</body>
</html>
