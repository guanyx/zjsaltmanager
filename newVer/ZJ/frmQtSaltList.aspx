<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmQtSaltList.aspx.cs" Inherits="ZJ_frmQtSaltList" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>质检盐种信息</title>
    <meta http-equiv="Content-Type" content="text/html; charset=GB2312">
    <link rel="stylesheet" type="text/css" href="../ext3/resources/css/ext-all.css" />
    <style type="text/css">
.label-class{
                color: red;                
            }
.label-bord-class
{
	background-color:Lime;
}
</style>
	<script type="text/javascript" src="../ext3/adapter/ext/ext-base.js"></script>	
	<script type="text/javascript" src="../ext3/ext-all.js"></script>
	<script type="text/javascript" src="../js/operateResp.js"></script>
	
	<script type="text/javascript">

           Ext.BLANK_IMAGE_URL = "../ext3/resources/images/default/s.gif"; 
           Ext.onReady(function() {
               var Toolbar = new Ext.Toolbar({
                   renderTo: "qtSalt_toolbar",
                   items: [{
                       text: "新增盐种",
                       icon: '../Theme/1/images/extjs/customer/add16.gif',
                       handler: function() {
                           // saveType = "add";
                           // openAddQuotaWin();//点击后，弹出添加信息窗口
//                           addmark = 1;
                            saltId=0;
                            Ext.getCmp("SaltName").setValue("");
                            Ext.getCmp("SaltMemo").setValue("");
                           qtSatlWindow.show();
                       }
                   }, '-', {
                       text: "修改盐种",
                       icon: '../Theme/1/images/extjs/customer/edit16.gif',
                       handler: function() {

                           var selectData = qtSaltGrid.getSelectionModel().getCount();
                           if (selectData == 0) {
                               Ext.Msg.alert("提示", "请选中要修改的记录！");
                               return;
                           }
                           if (selectData > 1) {
                               Ext.Msg.alert("提示", "一次只能修改一条记录！");
                               return;
                           }
                           var selectedRecord = qtSaltGrid.getSelectionModel().getSelections()[0].data;
                           Ext.getCmp("SaltName").setValue(selectedRecord.SaltName);
                            Ext.getCmp("SaltMemo").setValue(selectedRecord.SaltMemo);
                            saltId=selectedRecord.SaltId;
                            qtSatlWindow.show();
                       }
                   }, '-', {
                       text: "删除盐种",
                       icon: '../Theme/1/images/extjs/customer/delete16.gif',
                       handler: function() {
                           var selectData = qtSaltGrid.getSelectionModel().getCount();
                           if (selectData == 0) {
                               Ext.Msg.alert("提示", "请选中要删除的行！");
                               return;
                           }
                           var record = qtSaltGrid.getSelectionModel().getSelections()[0].data;
                           delQtSalt(record);
                       }
}, '-', {
                       text: "等级设置",
                       icon: '../Theme/1/images/extjs/customer/delete16.gif',
                       handler: function() {
                           setLevel();
                           
                       }
}, '-', {
                       text: "对应盐产品",
                       icon: '../Theme/1/images/extjs/customer/delete16.gif',
                       handler: function() {
                           var selectData = qtSaltGrid.getSelectionModel().getCount();
                           if (selectData == 0) {
                               Ext.Msg.alert("提示", "请选中要要对应盐种的型号规格！");
                               return;
                           }
                           var record = qtSaltGrid.getSelectionModel().getSelections()[0].data;
                          parent.parent.parent.createDiv(record.SaltName+"产品设置","/ZJ/frmSaltProductList.aspx?SaltId="+record.SaltId);
                       }
}]
                   });
                   if (typeof (qtSatlWindow) == "undefined") {//解决创建2个windows问题
                       var qtSatlWindow = new Ext.Window({
                           title: '盐种信息',
                           modal: 'true',
                           width: 600,
                           y:50,
                           autoHeight: true,
                           collapsible: true, //是否可以折叠 
                           closable: true, //是否可以关闭 
                           //maximizable : true,//是否可以最大化 
                           closeAction: 'hide',
                           constrain: true,
                           resizable: false,
                           plain: true,
                           // ,items: addQuotaForm
                           buttons: [{
                               text: '保存',
                               handler: function() {
                                saveSalt();
                                qtSatlWindow.hide();
                               }
                           }, {
                               text: '关闭',
                               handler: function() {
                                   qtSatlWindow.hide();
//                                   qtSatlWindow.getForm().reset();
                               }
}]
                           });
                       }
                       
function delQtSalt(selectedData)
{
    //删除前再次提醒是否真的要删除
    Ext.Msg.confirm("提示信息", "是否真的要删除选择的盐种信息吗？", function callBack(id) {
        //判断是否删除数据
        if (id == "yes") {
            //页面提交
            Ext.Ajax.request({
                url: 'frmQtSaltList.aspx?method=delSalt',
                method: 'POST',
                params: {
                    SaltId: selectedData.SaltId
                },
                success: function(resp, opts) {
                    if (checkExtMessage(resp)) {
                        qtSaltGrid.reload();
                    }
                    qtSaltGrid.reload();
                },
                failure: function(resp, opts) {
                    Ext.Msg.alert("提示", "数据删除失败");
                }
            });
        }
    });
}
var saltId = 0;                       
function saveSalt()
{
    var saltName = Ext.getCmp("SaltName").getValue();
    var saltMemo = Ext.getCmp("SaltMemo").getValue();
    if(saltName=="")
    {
        Ext.Msg.alert("请输入盐种名称信息！");
        return;
    }
    //页面提交
    Ext.Ajax.request({
        url: 'frmQtSaltList.aspx?method=saveSalt',
        method: 'POST',
        params: {
            SaltId:saltId,
            SaltName:saltName,
            SaltMemo:saltMemo
        },
       success: function(resp,opts){ 
           Ext.Msg.alert("系统提示","保存成功！");
           
       },
       failure: function(resp,opts){  /* Ext.Msg.alert("提示","保存失败"); */    }
    });
}
                       
                       var qtSatlForm = new Ext.form.FormPanel({
                           frame: true,
                           monitorValid: true, // 把有formBind:true的按钮和验证绑定
                           labelWidth: 80,
                           items: [
                           {

                               layout: 'form',
                               xtype: "fieldset",
                               title: '添加盐种信息',

                               items: [{
                                   layout: 'form',
                                   columnWidth: 1,  //该列占用的宽度，标识为20％
                                   border: false,
                                   items: [ {
                                       cls: 'key',
                                       xtype: 'textfield',
                                       fieldLabel: "盐种<font color='red'>*</font>",
                                       name: 'SaltName',
                                       id: 'SaltName',
                                       anchor: '98%'
                                   }, {
                                       cls: 'key',
                                       xtype: 'textfield',
                                       fieldLabel: '盐种备注',
                                       name: 'SaltMemo',
                                       id: 'SaltMemo',
                                       anchor: '98%'
                                   }]}]}]});
                                   
                               qtSatlWindow.add(qtSatlForm);
                             
/* 列表信息 */
var qtSaltStore = new Ext.data.Store
			({
                                           url: 'frmQtSaltList.aspx?method=getSaltList',
			    reader: new Ext.data.JsonReader({
			        totalProperty: 'totalProperty',
			        root: 'root'
			    }, [
			    { name: 'SaltId' },
			    { name: 'SaltName' },
	            { name: 'SaltMemo' },
	            { name: 'OperId' },
			    { name: 'CreateDate' },
	            { name: 'UpdateDate' }
			    ])
			   ,
			    listeners:
			      {
			          scope: this,
			          load: function() {
			       
			          }
			      }
			});
                                           var sm = new Ext.grid.CheckboxSelectionModel(
            {
                singleSelect: false
            }
        );
        var defaultPageSize = 15;
        var toolBar = new Ext.PagingToolbar({
            pageSize: 15,
            store: qtSaltStore,
            displayMsg: '显示第{0}条到{1}条记录,共{2}条',
            emptyMsy: '没有记录',
            displayInfo: true
        });
        var pageSizestore = new Ext.data.SimpleStore({
            fields: ['pageSize'],
            data: [[10], [20], [30]]
        });
        var combo1 = new Ext.form.ComboBox({
            regex: /^\d*$/,
            store: pageSizestore,
            displayField: 'pageSize',
            typeAhead: true,
            mode: 'local',
            emptyText: '更改每页记录数',
            triggerAction: 'all',
            selectOnFocus: true,
            width: 135
        });
        toolBar.addField(combo1);
        combo1.on("change", function(c, value) {
            toolBar.pageSize = value;
            defaultPageSize = toolBar.pageSize;
        }, toolBar);
        combo1.on("select", function(c, record) {
            toolBar.pageSize = parseInt(record.get("pageSize"));
            defaultPageSize = toolBar.pageSize;
            toolBar.doLoad(0);
        }, toolBar);
        
       var qtSaltGrid = new Ext.grid.GridPanel({
           el: 'qtSalt_grid',
           width: '100%',
           height: '100%',
           autoWidth: true,
           autoHeight: true,
           autoScroll: true,
           layout: 'fit',
           id: 'qtSaltGrid',
           store: qtSaltStore,
           loadMask: { msg: '正在加载数据，请稍侯……' },
           sm: sm,
           /*  如果中间没有查询条件form那么可以直接用tbar来实现增删改
           tbar:[{
           text:"添加",
           handler:this.showAdd,
           scope:this
           },"-",
           {
           text:"修改"
           },"-",{
           text:"删除",
           handler:this.deleteBranch,
           scope:this
           }],
           */
           cm: new Ext.grid.ColumnModel([
                        sm,

                        new Ext.grid.RowNumberer(), //自动行号
                                            {header: 'SaltId', hidden: true, dataIndex: 'SaltId' },
									        //{ header: '公司名称', dataIndex: 'OrgName' },
									        { header: '盐品', dataIndex: 'SaltName' },
											{ header: '备注', dataIndex: 'SaltMemo' }, 
											{ header: '创建人', dataIndex: 'OperId' }, 
											{ header: '创建时间', dataIndex: 'CreateDate' },
											{ header: '修改时间', dataIndex: 'UpdateDate' }
			  ]), listeners:
			  {
			      rowselect: function(sm, rowIndex, record) {
			          //行选中
			          //Ext.MessageBox.alert("提示","您选择的出版号是：" + r.data.ASIN);
			      },
			      rowclick: function(grid, rowIndex, e) {
			          //双击事件
			      },
			      rowdbclick: function(grid, rowIndex, e) {
			          //双击事件
			      },
			      cellclick: function(grid, rowIndex, columnIndex, e) {
			          //单元格单击事件			           
			      },
			      celldbclick: function(grid, rowIndex, columnIndex, e) {
			          //单元格双击事件
			          /*
			          var record = grid.getStore().getAt(rowIndex); //Get the Record
			          var fieldName = grid.getColumnModel().getDataIndex(columnIndex); //Get field name
			          var data = record.get(fieldName);
			          Ext.MessageBox.alert('show','当前选中的数据是'+data); 
			          */
			      }
			  },
               bbar: toolBar,
//               bbar: new Ext.PagingToolbar({
//                   pageSize: 15,
//                   store: qtSaltStore,
//                   displayMsg: '显示第{0}条到{1}条记录,共{2}条',
//                   emptyMsy: '没有记录',
//                   displayInfo: true
//               }),
               viewConfig: {
                   columnsText: '显示的列',
                   scrollOffset: 20,
                   sortAscText: '升序',
                   sortDescText: '降序',
                   forceFit: true
               },
               //width: 750, 
               height: 265,
               closeAction: 'hide',

               stripeRows: true,
               loadMask: true,
               autoExpandColumn: 2
           });
           qtSaltGrid.render();


/*创建Level信息 
***********************************************
****************************************************/
var leftStore = new Ext.data.SimpleStore({
   fields: ['id', 'name'],        
   data : [        
   ['≥', '≥'], 
   ['>', '>'],
   ['—', '—'] 
   ]});
var rightStore = new Ext.data.SimpleStore({
   fields: ['id', 'name'],        
   data : [        
   ['≤', '≤'],  
   ['<', '<'],
   ['~', '~'],
   ['±', '±'],
   ['—', '—']   
]});

if (typeof (levelWindow) == "undefined") {//解决创建2个windows问题
       levelWindow = new Ext.Window({
           title: '等级',
           modal: 'true',
           width: 750,
           height: '100%',
           autoHeight: true,
           x:15,
           y:15,
           
           collapsible: true, //是否可以折叠 
           closable: true, //是否可以关闭 
           //maximizable : true,//是否可以最大化 
           closeAction: 'hide',
           constrain: true,
           resizable: false,
           plain: true,
           autoScroll:true
           // ,items: addQuotaForm
//           buttons: [{
//               text: '保存',
//               handler: function() {
//                saveLevel(1);
//                   //ddQuota();

//               }
//           }, {
//               text: '关闭',
//               handler: function() {
//                   levelWindow.hide();
//                   //addQuotaForm.getForm().reset();
//               }
//            }, {
//               text: '删除',
//               handler: function() {
//                          var form = levelWindow.items.items[0];
//                          for(var i=0;i<7;i++)
//                          {
//                            form.items.items[i*5+1].remove();
//                          }
//               }
//            }]
        });
    }
function setLevelFormValue(LevelStandards)
{
    for(var i=0;i<levelItems.length;i++)
    {
        Ext.getCmp("txtLeveName"+levelItems[i].LevelId).setValue(levelItems[i].LevelName);
        Ext.getCmp("txtLeve"+levelItems[i].LevelId).setValue(levelItems[i].LevelLevel);
    }
     Ext.Ajax.request({
        url: 'frmQtSaltList.aspx?method=getSaltLevelStandard',
        method: 'POST',
        params: {
            SaltId:selectedSaltId
        },
       success: function(resp,opts){ 
           var resu = Ext.decode(resp.responseText);
           if(resu.success){
               var items = Ext.decode(resu.errorinfo);
               for(var i=0;i<items.length;i++)
               {
                if(items[i].QuotaExt2=="Q102")
                {
                    Ext.getCmp("cmbLeftL"+items[i].LevelId+"Q"+items[i].QuotaNo).setValue(items[i].StandardLowerOperator);
                    Ext.getCmp("leftTxtL"+items[i].LevelId+"Q"+items[i].QuotaNo).setValue(items[i].StandardLower);
                    Ext.getCmp("cmbRightL"+items[i].LevelId+"Q"+items[i].QuotaNo).setValue(items[i].StandardUpperOperator);
                    Ext.getCmp("rightTxtL"+items[i].LevelId+"Q"+items[i].QuotaNo).setValue(items[i].StandardUpper);
                    
                }
                else
                {
                    Ext.getCmp("textValueL"+items[i].LevelId+"Q"+items[i].QuotaNo).setValue(items[i].QuotaStandard);
                }
               }
          }else{
            Ext.Msg.alert("提示",resu.errorinfo); 
          }
       },
       failure: function(resp,opts){  /* Ext.Msg.alert("提示","保存失败"); */    }
    });
    
//    for(var i=0;i<LevelStandards.length;i++)
//    {
//        
//    }
}
function setLevel()
{
    var selectData = qtSaltGrid.getSelectionModel().getCount();
                           if (selectData == 0) {
                               Ext.Msg.alert("提示", "请选中要要设置的型号规格！");
                               return;
                           }                           
                           var record = qtSaltGrid.getSelectionModel().getSelections()[0].data;
                           levelWindow.title=record.SaltName+"等级";
                            selectedSaltId = record.SaltId;
                              Ext.Ajax.request({
                                url: 'frmQtSaltList.aspx?method=getTemplateItems',
                                method: 'POST',
                                params: {
                                    SaltId: record.SaltId
                                },
                                success: function(resp, opts) {                                
                                   var resu = Ext.decode(resp.responseText);
                                   if(resu.success){
                                       var item = Ext.decode(resu.errorinfo);
                                        quotaItems=item.Quotas;
                                        levelItems=item.Levels;
                                        createLevelControl(levelItems,quotaItems);
                                        setLevelFormValue();
                                        if(!levelWindow.visible)
                                            levelWindow.show();
                                    }else{
                                        Ext.Msg.alert("提示", "是否已经设置了检测标准");
                                    }
                                    
                                },
                                failure: function(resp, opts) {
                                    Ext.Msg.alert("提示", "是否已经设置了检测标准");
                                }
                            });
}
function delLevel(btn)
{
    
         //删除前再次提醒是否真的要删除
    Ext.Msg.confirm("提示信息", "是否真的要删除当前等级信息？", function callBack(id) {
        //判断是否删除数据
        if (id == "yes") {
            //页面提交
            var delId = btn.id.substring(6);
            Ext.Ajax.request({
                url: 'frmQtSaltList.aspx?method=delLevel',
                method: 'POST',
                params: {
                    LevelId:delId
                },
               success: function(resp,opts){
                   var resu = Ext.decode(resp.responseText);
                   Ext.Msg.alert("提示信息",resu.errorinfo,function callBack(){
//                      levelWindow.hide();
                      setLevel();
                       });
               },
               failure: function(resp,opts){  /* Ext.Msg.alert("提示","保存失败"); */    }
            });
        }
   
    });
   
    
}
function saveLevel(btn)
{
    var levelId = btn.id.substring(6);
    //获取级别信息 Level_Id,Level_Name,Salt_Id,Level_Level
    //获取级别指标信息[{LevelId,QuotaNo,Lower,LowerOper,Upper,UpperOper,Standard}]
    var level="{LevelName:'"+Ext.getCmp("txtLeveName"+levelId).getValue()+"',LevelLevel:"+Ext.getCmp("txtLeve"+levelId).getValue()+"}";
    var levelStandard="";
    for(var i=0;i<quotaItems.length;i++)
    {
        var standard="{";
        if(quotaItems[i].QuotaExt2=='Q102')
        {
            standard+="QuotaNo:"+quotaItems[i].QuotaNo+",";
            standard+="StandardSort:"+quotaItems[i].QuotaSort+",";
            standard+="StandardLowerOperator:'"+Ext.getCmp( 'cmbLeftL' +levelId+"Q"+ quotaItems[i].QuotaNo).getValue()+"',";
            var leftValue = Ext.getCmp('leftTxtL' +levelId+"Q"+ quotaItems[i].QuotaNo).getValue();
            if(leftValue=='')
                leftValue=0;
            standard+="StandardLower:"+leftValue+",";
            standard+="StandardUpperOperator:'"+Ext.getCmp('cmbRightL' +levelId+"Q"+ quotaItems[i].QuotaNo).getValue()+"',";
            leftValue = Ext.getCmp('rightTxtL' +levelId+"Q"+ quotaItems[i].QuotaNo).getValue();
            if(leftValue=='')
                leftValue=0;
            standard+="StandardUpper:"+leftValue+",";
            standard+="QuotaStandard:''";
            standard+="}";
        }
        else
        {
            standard+="QuotaNo:"+quotaItems[i].QuotaNo+",";
            standard+="StandardSort:"+quotaItems[i].QuotaSort+",";
            standard+="StandardLowerOperator:'—',";
            standard+="StandardLower:0,";
            standard+="StandardUpperOperator:'—',";
            standard+="StandardUpper:0,";
            standard+="QuotaStandard:'"+Ext.getCmp('textValueL'  +levelId+"Q"+ quotaItems[i].QuotaNo).getValue()+"'";
            standard+="}";            
        }
        if(levelStandard.length>2)
        {
            levelStandard +=",";
        }
        levelStandard += standard;
        
    }
    levelStandard += ",";
    Ext.Ajax.request({
        url: 'frmQtSaltList.aspx?method=saveSaltLevel',
        method: 'POST',
        params: {
            LevelId:levelId,
            SaltId:selectedSaltId,
            LevelName:Ext.getCmp("txtLeveName"+levelId).getValue(),
            LevelLevel:Ext.getCmp("txtLeve"+levelId).getValue(),
            LevelStandard:levelStandard
        },
       success: function(resp,opts){ 
           if(checkExtMessage(resp))
           {
//                levelWindow.hide();
                setLevel();
           }
           
       },
       failure: function(resp,opts){  /* Ext.Msg.alert("提示","保存失败"); */    }
    });
    
}
var quotaItems=null;
var levelItems=null;
var levelForm = null;
var selectedSaltId=0;
var levelWindow;
function createLevelControl(LevelItems,QuotaItems)
{
    levelWindow.removeAll();
   levelCount = LevelItems.length;
   var columnCount = levelCount+2;
   levelForm = new Ext.Panel(
   {
	frame:true,
	border:true,
	layout:'table',
	width:730,
	height:'100%',
	autoScroll:true,
	layoutConfig:{columns:2}
   });
   
   var leftForm =new Ext.Panel(
   {
	frame:true,
	border:true,
	layout:'table',
	width:100,	
	layoutConfig:{columns:1}
   });
   var rightForm =new Ext.Panel(
   {
	frame:true,
	border:true,
	layout:'table',
	width:615,
	
	autoScroll:true,
	layoutConfig:{columns:levelCount*2+2}
   });
   
   for(var j=-1;j<QuotaItems.length;j++)
   {
        if(j==-1)
        {
            leftForm.add({ layout: 'table',width:150,height:22, layoutConfig: { columns: 1 },items:{xtype : "label",html:'等级'}});
//            levelForm.add({ layout: 'table',width:80, layoutConfig: { columns: 1 },items:{xtype : "label",html:'等级'}});
            for(var index=1;index<columnCount;index++)
            {
                var id = 0;
                if(index-1<LevelItems.length)
                {
                    id=levelItems[index-1].LevelId;
                }                
               var txtLeveName=new Ext.form.TextField({ id: 'txtLeveName'+id,width:60 });
               var txtLeave=new Ext.form.TextField({ id: 'txtLeve'+id ,width:20 });
               var btnDel=new Ext.Button({id:'btnDel'+id,width:10,icon: '../Theme/1/images/extjs/customer/delete16.gif',listeners:{"click":function(){delLevel(this)}}});
               var btnEdit=new Ext.Button({id:'btnEdt'+id,width:10,icon: '../Theme/1/images/extjs/customer/edit16.gif',listeners:{"click":function(){saveLevel(this)}}});
               if(id==0)
               {
                    btnDel=new Ext.Button({id:'btnDel'+id,width:10,icon: '../Theme/1/images/extjs/customer/add16.gif',listeners:{"click":function(){saveLevel(this)}}});
                    rightForm.add({ layout: 'table', layoutConfig: { columns: 5 },items:[{items:{xtype : "label",id:"lblLevelName"+id,width:50,html:'名称'}},{items:txtLeveName},{items:{xtype : "label",id:"lblLevel"+id,width:50,html:'级别'}},{items:txtLeave},{items:btnDel}]});
               }
               else
               {
                rightForm.add({ layout: 'table', layoutConfig: { columns: 6 },items:[{items:{xtype : "label",id:"lblLevelName"+id,width:50,html:'名称'}},{items:txtLeveName},{items:{xtype : "label",id:"lblLevel"+id,width:50,html:'级别'}},{items:txtLeave},{items:btnDel},{items:btnEdit}]});
               }
               var lblBoard = new Ext.form.Label({width:20,html:'&nbsp;'});
               lblBoard.addClass("label-bord-class");
               rightForm.add({ layout: 'table', layoutConfig: { columns: 1 },items:[{items:lblBoard}]});
//               levelForm.add({ layout: 'table', layoutConfig: { columns: 5 },items:[{items:{xtype : "label",width:50,html:'名称'}},{items:txtLeveName},{items:{xtype : "label",width:50,html:'级别'}},{items:txtLeave},{items:btnDel}]});
            }
            continue;
        }
        var item = QuotaItems[j];
       for(var i=0;i<columnCount;i++)
       {
           //创建Label列
	       if(i==0)
           {
                leftForm.add({ layout: 'table',valign:'bottom',width:150,height:22 ,layoutConfig: { columns: 1 },items:{xtype : "label",id : "lblQuotaName"+item.QuotaNo,html :item.QuotaName}});
//              levelForm.add({ layout: 'table',width:80, layoutConfig: { columns: 1 },items:{xtype : "label",id : "mylabel1",html :item.QuotaName}});
	       }
           else
           {
                var levelId = 0;
                if(i>0 && i<columnCount-1)
                {
                    levelId = LevelItems[i-1].LevelId
                }
		        if(item.QuotaExt2=='Q102')//数值类型
                {
                    //添加Combox  >=(>= —)40 (<=,~,±,—)  <=80  
                    var cmbLeft = new Ext.form.ComboBox({
                         id: 'cmbLeft' +"L"+levelId.toString()+"Q"+ item.QuotaNo,
                         store: leftStore, // 下拉数据           
                         displayField: 'name', //显示上面的fields中的state列的内容,相当于option的text值        
                         valueField:'id' , // 选项的值, 相当于option的value值        
                         name: 'cmbLeft' +"L"+levelId.toString()+"Q"+ item.QuotaNo,
                         mode: 'local', // 必须要,如果为 remote, 则会用ajax获取数据        
                         triggerAction: 'all', // 点击下拉的时候, all 为展出所有Store中data的数据        
                         readOnly: true, // 如果设为true,则好像一般的下拉框一样，默认是false,可输入并自动匹配        
                         emptyText: '请选择选择信息',
                         width: 45,
                         editable: false,
                         selectOnFocus: true,
                         listeners:{
                            "blur":function()
                            {
                                var indexId = this.id.indexOf('Q');
                                clearBlurLabelStyle(this.id.substring(indexId+1));
                            },
                            "focus":function(){
                                    setLabelColor(this.id);                                
                                }
                         }
                     });
                    var cmbRight = new Ext.form.ComboBox({
                         id: 'cmbRight'  +"L"+levelId.toString()+"Q"+ item.QuotaNo,
                         store: rightStore, // 下拉数据           
                         displayField: 'name', //显示上面的fields中的state列的内容,相当于option的text值        
                         valueField:'id' , // 选项的值, 相当于option的value值        
                         name: 'cmbRight'  +"L"+levelId.toString()+"Q"+ item.QuotaNo,
                         mode: 'local', // 必须要,如果为 remote, 则会用ajax获取数据        
                         triggerAction: 'all', // 点击下拉的时候, all 为展出所有Store中data的数据        
                         readOnly: true, // 如果设为true,则好像一般的下拉框一样，默认是false,可输入并自动匹配        
                         emptyText: '请选择选择信息',
                         width: 45,
                         editable: false,
                         selectOnFocus: true,
                         listeners:{
                            "blur":function()
                            {
                                var indexId = this.id.indexOf('Q');
                                clearBlurLabelStyle(this.id.substring(indexId+1));
                            },
                            "focus":function(){setLabelColor(this.id);}
                         }
                     });
                    var txtLeft=new Ext.form.TextField({ id: 'leftTxt'  +"L"+levelId.toString()+"Q"+ item.QuotaNo,width:40,listeners:{
                            "blur":function()
                            {
                                var indexId = this.id.indexOf('Q');
                                clearBlurLabelStyle(this.id.substring(indexId+1));
                            },
                            "focus":function(){setLabelColor(this.id);}
                         } });
                    var txtRight=new Ext.form.TextField({id:'rightTxt'+"L"+levelId.toString()+"Q"+ item.QuotaNo,width:40,listeners:{
                            "blur":function()
                            {
                                var indexId = this.id.indexOf('Q');
                                clearBlurLabelStyle(this.id.substring(indexId+1));
                            },
                            "focus":function(){setLabelColor(this.id);}
                         }});
//                    levelForm.add({ layout: 'table', layoutConfig: { columns: 4 }, items: [{ items: cmbLeft }, { items: txtLeft},{items:cmbRight },{items:txtRight}] });
                    rightForm.add({ layout: 'table', layoutConfig: { columns: 4 }, items: [{ items: cmbLeft }, { items: txtLeft},{items:cmbRight },{items:txtRight}] });
                }
                else
                {
                   var txtTextValue=new Ext.form.TextField({ id: 'textValue'  +"L"+levelId.toString()+"Q"+ item.QuotaNo,width:170,listeners:{
                            "blur":function()
                            {
                                var indexId = this.id.indexOf('Q');
                                clearBlurLabelStyle(this.id.substring(indexId+1));
                            },
                            "focus":function(){setLabelColor(this.id);}
                         } });
//                   levelForm.add({ layout: 'table', layoutConfig: { columns: 1 }, items: [{items:txtTextValue}] });
                   rightForm.add({ layout: 'table', layoutConfig: { columns: 1 }, items: [{items:txtTextValue}] });
                }
                var lblBoard = new Ext.form.Label({width:20,html:'&nbsp;'});
               lblBoard.addClass("label-bord-class");
               rightForm.add({ layout: 'table', layoutConfig: { columns: 1 },items:[{items:lblBoard}]});
             }
             
       }
       
   }  
   //宽度大于总体的宽度，需要添加滚动条，最右边需要添加空白行
   if(178*(columnCount-1)>600)
   {
    leftForm.add({ layout: 'table',width:80,height:16 ,layoutConfig: { columns: 1 },items:{xtype : "label",id : "mylabel1",html :''}});
   }   
    levelForm.add(leftForm);
    levelForm.add(rightForm);
   levelWindow.add(levelForm);
   
   levelWindow.doLayout();


}

function setLabelColor(controlId)
{
    var indexId = controlId.indexOf('Q');
    setCurrentLableStyle(controlId.substring(indexId+1));
    var levelIndex = 0;
    for(var i=indexId-1;i>0;i--)
    {
        if(controlId[i]=="L")
        {
            break;
        }
        levelIndex=i;
    }
    var levelId = controlId.substring(levelIndex,indexId);
    setLevelLableStyle(levelId);
}
var currentLevel = -1;
function setLevelLableStyle(levelId)
{
    if(currentLevel!=levelId)
    {
        Ext.getCmp('lblLevelName'+levelId).addClass('label-class');
        Ext.getCmp('lblLevel'+levelId).addClass('label-class');
        if(Ext.getCmp('lblLevelName'+currentLevel))
        {
            Ext.getCmp('lblLevelName'+currentLevel).removeClass('label-class');
            Ext.getCmp('lblLevel'+currentLevel).removeClass('label-class');
        }
        currentLevel=levelId;
    }
}
var currentIndex =0;
function setCurrentLableStyle(labelId)
{
    if(currentIndex!=labelId)
    {
        Ext.getCmp('lblQuotaName'+labelId).addClass('label-class');
        if(Ext.getCmp('lblQuotaName'+currentIndex))
            Ext.getCmp('lblQuotaName'+currentIndex).removeClass('label-class');
        currentIndex=labelId;
    }
    
}
function clearBlurLabelStyle(labelId)
{
//    Ext.getCmp('lblQuotaName'+labelId).removeClass('label-class');
}
qtSaltStore.load({params: {limit:15,start:0} });
                                   });
</script>
</head>
<body>
    <div id="qtSalt_toolbar"></div>
    <div id="qtSalt_grid"></div>
</body>
</html>
