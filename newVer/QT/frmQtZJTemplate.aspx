<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmQtZJTemplate.aspx.cs" Inherits="QT_frmQtZJTemplate" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=GB2312">
    <link rel="stylesheet" type="text/css" href="../ext3/resources/css/ext-all.css" />
	<script type="text/javascript" src="../ext3/adapter/ext/ext-base.js"></script>	
	<script type="text/javascript" src="../ext3/ext-all.js"></script>
	<script type="text/javascript" src="../ext3/example/ItemDeleter.js"></script>
<style type="text/css">
.extensive-remove {
background-image: url(../Theme/1/images/extjs/customer/cross.gif) ! important;
}
.x-grid-back-blue { 
background: #B7CBE8; 
}
</style>
</head>
<body>
	<div id="zjtemp_toolbar"></div>
	 <div id="zjtemp_form"></div>
	 <div id="zjtemp_grid"></div>
	 <div id="serchform_form"></div>
	 <%=getComboBoxStore()%>
</body><script>
          
           var excelstr = "";                                     
           var modify_option_id = 'none';
           var addoptionmark = 0;
           var printstr = "";
           var outFormulaname = "";
           function startPrint(str) {
               var oWin = window.open("", "_blank");
               var strPrint = "<h4 style=’font-size:18px; text-align:center;’>打印预览区</h4>\n";

               strPrint = strPrint + "<script type=\"text/javascript\">\n";
               strPrint = strPrint + "function printWin()\n";
               strPrint = strPrint + "{";
               strPrint = strPrint + "var oWin=window.open(\"\",\"_blank\");\n";
               strPrint = strPrint + "oWin.document.write(document.getElementById(\"content\").innerHTML);\n";
               strPrint = strPrint + "oWin.focus();\n";
               strPrint = strPrint + "oWin.document.close();\n";
               strPrint = strPrint + "oWin.print()\n";
               strPrint = strPrint + "oWin.close()\n";
               strPrint = strPrint + "}\n";
               strPrint = strPrint + "<\/script>\n";
               strPrint = strPrint + "<div id=\"content\">\n";
               strPrint = strPrint + str + "\n";
               strPrint = strPrint + "</div>\n";
               strPrint = strPrint + "<div style='text-align:center'><button onclick='printWin()' style='padding-left:4px;padding-right:4px;'>打  印</button><button onclick='window.opener=null;window.close();'  style='padding-left:4px;padding-right:4px;'>关  闭</button></div>\n";

               oWin.document.write(strPrint);
               oWin.focus();
               oWin.document.close();
           }
           
           Ext.BLANK_IMAGE_URL = "../ext3/resources/images/default/s.gif";
           Ext.onReady(function() {

               var ctstore = new Ext.data.ArrayStore({
                   fields: ['id', 'state'],
                   data: [['0', '否'], ['1', '是']]
               });
               var ctcombo = new Ext.form.ComboBox({
                   store: ctstore,
                   displayField: 'state',
                   valueField: 'id',
                   typeAhead: true,
                   mode: 'local',
                   triggerAction: 'all',
                   emptyText: '选择是否统计',
                   selectOnFocus: true,
                   listeners: {
                       "select": addNewBlankRow
                   },
                   anchor: '50%'
               });
               var tpstore = new Ext.data.ArrayStore({
                   fields: ['id', 'state'],
                   data: [['0', '否'], ['1', '是']]
               });
               var tpcombo = new Ext.form.ComboBox({
                   store: tpstore,
                   displayField: 'state',
                   valueField: 'id',
                   typeAhead: true,
                   mode: 'local',
                   triggerAction: 'all',
                   emptyText: '选择是否分类',
                   selectOnFocus: true,
                   listeners: {
                       "select": addNewBlankRow
                   },
                   anchor: '50%'
               });

               var ststore = new Ext.data.ArrayStore({
                   fields: ['id', 'state'],
                   data: [['0', '否'], ['1', '是']]
               });
               var stcombo = new Ext.form.ComboBox({
                   store: tpstore,
                   displayField: 'state',
                   valueField: 'id',
                   typeAhead: true,
                   mode: 'local',
                   triggerAction: 'all',
                   emptyText: '选择是否分类',
                   selectOnFocus: true,
                   listeners: {
                       "select": addNewBlankRow
                   },
                   anchor: '50%'
               });

               var zjlbComb = new Ext.form.ComboBox({
                   xtype: 'combo',
                   store: new Ext.data.Store({
                       autoLoad: true,
                       baseParams: {
                           trancode: 'Menu'
                       },
                       proxy: new Ext.data.HttpProxy({
                           url: 'frmQtOtherOptionCfg.aspx?method=getOption&key=StdType'
                       }),
                       // create reader that reads the project records
                       reader: new Ext.data.JsonReader({ root: 'root' }, [
                                { name: 'name', type: 'string' },
                                { name: 'id', type: 'string' }
                        ])
                   }),
                   displayField: 'name',
                   valueField: 'id',
                   triggerAction: 'all',
                   id: 'zjlbComb',
                   //pageSize: 5,
                   //minChars: 2,
                   //hideTrigger: true,
                   fieldLabel: '质检类别',
                   typeAhead: true,
                   mode: 'local',
                   emptyText: '',
                   selectOnFocus: false,
                   editable: true,
                   anchor: '50%'
               });
               function cktp(val) {
                   var index = zjlbComb.getStore().find('id', val);
                   if (index < 0)
                       return "";
                   var record = zjlbComb.getStore().getAt(index);
                   return record.data.name;
               }
               var Toolbar = new Ext.Toolbar({
                   renderTo: "zjtemp_toolbar",
                   items: [{
                       text: "新增",
                       icon: '../Theme/1/images/extjs/customer/add16.gif',
                       handler: function() {
                           // saveType = "add";
                           // openAddQuotaWin();//点击后，弹出添加信息窗口
                           addoptionmark = 1;
                           inserNewBlankRow();
                           optionWindow.show();
                       }
                   }, '-', {
                       text: "修改",
                       icon: '../Theme/1/images/extjs/customer/edit16.gif',
                       handler: function() {
                           ///  deleteCustomer();

                           var optionData = optionGrid.getSelectionModel().getCount();

                           if (optionData == 0) {
                               Ext.Msg.alert("提示", "请选中要修改的记录！");
                               return;
                           }
                           if (optionData > 1) {
                               Ext.Msg.alert("提示", "一次只能修改一条记录！");
                               return;
                           }
                           addoptionmark = 0;
                           modifyoption(optionData);

                       }
                   }, '-', {
                       text: "删除",
                       icon: '../Theme/1/images/extjs/customer/delete16.gif',
                       handler: function() {
                           var optionData = optionGrid.getSelectionModel().getCount();

                           if (optionData == 0) {
                               Ext.Msg.alert("提示", "请选中要删除的行！");
                               return;
                           }
                           deloption(optionData);

                       }
}]
                   });
                   if (typeof (optionWindow) == "undefined") {//解决创建2个windows问题
                       var optionWindow = new Ext.Window({
                           title: '新增质检模板',
                           modal: 'true',
                           width: 700,
                           y: 50,
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
                                   var tpname = Ext.getCmp('tpname').getValue();
                                   if (tpname == undefined || tpname == null || tpname == "") {
                                       Ext.Msg.alert("提示", "请输入模板名称！");
                                       return;
                                   }
                                   // var counttype = Ext.getCmp('counttype').getValue();
                                   /*  if (counttype == undefined || counttype == null || counttype == "") {
                                   Ext.Msg.alert("提示", "请输入合计方式！");
                                   return;
                                   }*/
                                   var checktype = zjlbComb.getValue();
                                   if (checktype == undefined || checktype == null || checktype == "") {
                                       Ext.Msg.alert("提示", "请输入报告类型！");
                                       return;
                                   }
                                   // var outcolumn = Ext.getCmp('outcolumn').getValue();
                                   /*if (outcolumn == undefined || outcolumn == null || outcolumn == "") {
                                   Ext.Msg.alert("提示", "请输入开始导出行！");
                                   return;
                                   }*/
                                   var countstart = Ext.getCmp('countstart').getValue();
                                   /*   if (countstart == undefined || countstart == null || countstart == "") {
                                   Ext.Msg.alert("提示", "请输入合计开始导出行！");
                                   return;
                                   }*/
                                   var detailcolumn = Ext.getCmp('detailcolumn').getValue();
                                   /*  if (detailcolumn == undefined || detailcolumn == null || detailcolumn == "") {
                                   Ext.Msg.alert("提示", "请输入明细导出开始列！");
                                   return;
                                   }*/
                                   var outname = Ext.getCmp('outname').getValue();
                                   /* if (outname == undefined || outname == null || outname == "") {
                                   Ext.Msg.alert("提示", "请输入导出模板名称！");
                                   return;
                                   }*/
                                   var note = Ext.getCmp('note').getValue();
                                   /* if (note == undefined || note == null || note == "") {
                                   Ext.Msg.alert("提示", "请输入备注！");
                                   return;
                                   }*/
                                   var json = "";
                                   dsOrderProduct.each(function(dsOrderProduct) {
                                       json += Ext.util.JSON.encode(dsOrderProduct.data) + ',';
                                   });
                                   url = 'frmQtZJTemplate.aspx?method=saveOrder';
                                   json = json.substring(0, json.length - 1);
                                   if (modify_option_id != '' && modify_option_id != null && addoptionmark == 0) {
                                       url = 'frmQtZJTemplate.aspx?method=updateOrder&formulano=' + modify_option_id;
                                   }
                                   Ext.Ajax.request({
                                       url: url,
                                       method: 'POST',
                                       params: {
                                           FormulaName: tpname,
                                           OutFormulaName: outname,
                                           CheckType: checktype,
                                           // OutColumnStart: outcolumn,
                                           OutCountStart: countstart,
                                           OutDetailStart: detailcolumn,
                                           //  CountType: counttype,
                                           Note: note,
                                           DetailInfo: json
                                       },
                                       success: function(resp, opts) {
                                           /// Ext.MessageBox.hide();
                                           Ext.Msg.alert("提示", "保存成功！");
                                           optionWindow.hide();
                                           dsOrderProduct.removeAll();
                                           queryoption();
                                       }
                , failure: function(resp, opts) {
                    // Ext.MessageBox.hide();
                    Ext.Msg.alert("提示", "保存失败！");

                }
                                   });


                               }


                           }, {
                               text: '关闭',
                               handler: function() {
                                   optionWindow.hide();
                                   addoptionForm.getForm().reset();
                                   dsOrderProduct.removeAll();
                               }
}]
                           });
                       }

                       var panel = new Ext.Panel({
                       height:30
                       // html: '<div style="width:100%;text-align:center"> <font size="4"><H1>浙江省盐业集团质检报告单</H1></font></div>'
                   });

                   if (typeof (resultWindow) == "undefined") {//解决创建2个windows问题
                       var resultWindow = new Ext.Window({
                           title: '新增其他选项',
                           modal: 'true',
                           width: 700,
                           autoHeight: true,
                           collapsible: true, //是否可以折叠 
                           closable: true, //是否可以关闭 
                           //maximizable : true,//是否可以最大化 
                           closeAction: 'hide',
                           constrain: true,
                           resizable: false,
                           plain: true,
                           items: [panel],
                           // ,items: addQuotaForm
                           buttons: [{
                               text: '打印',
                               handler: function() {
                                   startPrint(printstr);
                               }
                           }, {
                               text: '导出',
                               handler: function() {
                                   outExcel();
                               }
                           }, {
                               text: '关闭',
                               handler: function() {
                                   resultWindow.hide();
                                   var s = detail.getEl().dom.lastChild.lastChild;
                                   var ss = s.childNodes;
                                   var sss = ss.length;
                                   s.removeChild(ss[sss - 1]);
                                   var s1 = panel.getEl().dom.lastChild.lastChild;
                                   var ss1 = s1.childNodes;
                                   var sss1 = ss1.length;
                                   s1.removeChild(ss1[sss1 - 1]);
                               }
}]
                           });
                       }
                       var detail = new Ext.Panel({
                       // html: 'asdada'
                   });
                   var dt_form = new Ext.form.FormPanel({
                       frame: true,
                       monitorValid: true, // 把有formBind:true的按钮和验证绑定
                       layout: "form",
                       items: [detail]
                   });
                   resultWindow.add(dt_form);
                   var shownmCombo = new Ext.form.ComboBox({
                       xtype: 'combo',
                       store: allQuotaStore,
                       valueField: 'id',
                       displayField: 'name',
                       mode: 'local',
                       allowBlank: false,
                       blankText: '选项类型不能为空',
                       forceSelection: true,
                       selectOnFocus: true,
                       emptyText: '请选择选项类型',
                       editable: false,
                       triggerAction: 'all',
                       listeners: {
                           select: function(combo, record, index) {
                               var sm = userGrid.getSelectionModel().getSelected();
                               sm.set('ShowId', record.data.id);
                               inserNewBlankRow();
                           }
                       },
                       fieldLabel: '选项类型',
                       selectOnFocus: true,
                       anchor: '90%'
                   });


                   //修改指标
                   function modifyoption(rownum) {
                       optionWindow.show();
                       var record = optionGrid.getSelectionModel().getSelections()[0].data;
                       Ext.getCmp('tpname').setValue(record.FormulaName);
                       Ext.getCmp('counttype').setValue(record.CountType);
                       zjlbComb.setValue(record.CheckType);
                       Ext.getCmp('outcolumn').setValue(record.OutColumnStart);
                       Ext.getCmp('countstart').setValue(record.OutCountStart);
                       Ext.getCmp('detailcolumn').setValue(record.OutDetailStart);
                       Ext.getCmp('outname').setValue(record.OutFormulaName);
                       Ext.getCmp('note').setValue(record.Note);
                       dsOrderProduct.load({
                           params: {
                               formulano: record.FormulaNo
                           },
                            callback : function(r, options, success) {  
                              if (success == false) {  
                                   Ext.Msg.alert("提示",   "信息加载失败！"); 
                              } 
                              else{
                                  inserNewBlankRow(); 
                              }  
                          }       

                       });

                       modify_option_id = record.FormulaNo;

                   }

                   function deloption(rownum) {
                       var ids = "";
                       var recorddel = optionGrid.getSelectionModel().getSelections();
                       if (rownum == 1) {
                           ids = recorddel[0].data.FormulaNo;
                       } else {
                           for (var i = 0; i < rownum; i++) {
                               ids += recorddel[i].data.FormulaNo + ',';
                           }
                           ids = ids.substring(0, ids.length - 1);
                       }

                       Ext.Ajax.request({
                           url: 'frmQtZJTemplate.aspx?method=delnt'
                               , params: {
                                   ids: ids
                               },
                           //成功时回调 
                           success: function(response, options) {
                               //获取响应的json字符串

                               Ext.Msg.alert("提示", "删除成功！");

                               for (var i = 0; i < recorddel.length; i++) {
                                   optionStore.remove(recorddel[i]);
                               }




                           },
                           failure: function() {
                               Ext.Msg.alert("提示", "删除失败！");
                           }
                       });
                   }


                   var detailcm = new Ext.grid.ColumnModel([
        new Ext.grid.RowNumberer(), //自动行号
        {
        id: 'DetailNo',
        header: "质检模板明细ID",
        dataIndex: 'DetailNo',
        hidden: true,
        editor: new Ext.form.TextField({ allowBlank: false })
    },
         {
             id: 'DetailName',
             header: "名称",
             dataIndex: 'DetailName',
             width: 70,
             editor: new Ext.form.TextField({ allowBlank: true })

         },
          {
              id: 'OrderColumn',
              header: "显示列号",
              dataIndex: 'OrderColumn',
              width: 40,
              editor: new Ext.form.TextField({ allowBlank: true })
          },
        {
            id: 'IfCount',
            header: "是否统计字段",
            dataIndex: 'IfCount',
            width: 65,
            editor: ctcombo,
            renderer: function(value, cellmeta, record, rowIndex, columnIndex, store) {
                //解决值显示问题
                //获取当前id="combo_process"的comboBox选择的值
                var index = ctstore.find(ctcombo.valueField, value);
                var record = ctstore.getAt(index);
                var displayText = "";
                // 如果下拉列表没有被选择，那么record也就不存在，这时候，返回传进来的value，
                // 而这个value就是grid的USER_REALNAME列的value，所以直接返回
                if (record == null) {
                    //返回默认值，
                    displayText = value;
                } else {
                    displayText = record.data.state; //获取record中的数据集中的process_name字段的值
                }

                return displayText;
            }

        },
         {
             id: 'Round',
             header: "保留小数位",
             dataIndex: 'Round',
             width: 45,
             editor: new Ext.form.TextField({ allowBlank: true })
         }, {
             id: 'IfType',
             header: "是否合计分类",
             dataIndex: 'IfType',
             width: 65,
             editor: tpcombo,
             renderer: function(value, cellmeta, record, rowIndex, columnIndex, store) {
                 //解决值显示问题
                 //获取当前id="combo_process"的comboBox选择的值
                 var index = tpstore.find(tpcombo.valueField, value);
                 var record = tpstore.getAt(index);
                 var displayText = "";
                 // 如果下拉列表没有被选择，那么record也就不存在，这时候，返回传进来的value，
                 // 而这个value就是grid的USER_REALNAME列的value，所以直接返回
                 if (record == null) {
                     //返回默认值，
                     displayText = value;
                 } else {
                     displayText = record.data.state; //获取record中的数据集中的process_name字段的值
                 }

                 return displayText;
             }

         }, {
             id: 'ShowId',
             header: "指标ID",
             dataIndex: 'ShowId',
             hidden: true,
             editor: new Ext.form.TextField({ allowBlank: false })
         }, {
             id: 'ShowName',
             header: "显示名称",
             dataIndex: 'ShowName',
             width: 70,
             editor: shownmCombo,
             renderer: function(value, cellmeta, record, rowIndex, columnIndex, store) {
                 //解决值显示问题
                 //获取当前id="combo_process"的comboBox选择的值
             var index = shownmCombo.getStore().find(shownmCombo.valueField, value);
             var record = shownmCombo.getStore().getAt(index);
                 var displayText = "";
                 // 如果下拉列表没有被选择，那么record也就不存在，这时候，返回传进来的value，
                 // 而这个value就是grid的USER_REALNAME列的value，所以直接返回
                 if (record == null) {
                     //返回默认值，
                     displayText = value;
                 } else {
                     displayText = record.data.name; //获取record中的数据集中的process_name字段的值
                 }

                 return displayText;
             }
         },
        {
            id: 'IfSort',
            header: "是否排序字段",
            dataIndex: 'IfSort',
            width: 65,
            editor: stcombo,
            renderer: function(value, cellmeta, record, rowIndex, columnIndex, store) {
                //解决值显示问题
                //获取当前id="combo_process"的comboBox选择的值
                var index = ststore.find(stcombo.valueField, value);
                var record = ststore.getAt(index);
                var displayText = "";
                // 如果下拉列表没有被选择，那么record也就不存在，这时候，返回传进来的value，
                // 而这个value就是grid的USER_REALNAME列的value，所以直接返回
                if (record == null) {
                    //返回默认值，
                    displayText = value;
                } else {
                    displayText = record.data.state; //获取record中的数据集中的process_name字段的值
                }

                return displayText;
            }
        },
        new Extensive.grid.ItemDeleter()
        ]);
                   detailcm.defaultSortable = true;

                   var RowPattern = Ext.data.Record.create([
           { name: 'DetailNo', type: 'string' },
           { name: 'DetailName', type: 'string' },
           { name: 'IfCount', type: 'string' },
           { name: 'OrderColumn', type: 'string' },
           { name: 'Round', type: 'string' },
           { name: 'IfType', type: 'string' },
           { name: 'ShowId', type: 'string' },
           { name: 'ShowName', type: 'string' },
            { name: 'IfSort', type: 'string' }
          ]);

                   var dsOrderProduct;
                   if (dsOrderProduct == null) {
                       dsOrderProduct = new Ext.data.Store
	        ({
	            url: 'frmQtZJTemplate.aspx?method=getNTdetail',
	            reader: new Ext.data.JsonReader({
	                totalProperty: 'totalProperty',
	                root: 'root'
	            }, RowPattern)
	        });

                   }
                   var userGrid = new Ext.grid.EditorGridPanel({
                       store: dsOrderProduct,
                       cm: detailcm,
                       selModel: new Extensive.grid.ItemDeleter(),
                       layout: 'fit',
                       width: '100%',
                       height: 180,
                       stripeRows: true,
                       frame: true,
                       //plugins: USER_ISLOCKEDColumn,
                       clicksToEdit: 1,
                       viewConfig: {
                           columnsText: '显示的列',
                           scrollOffset: 20,
                           sortAscText: '升序',
                           sortDescText: '降序',
                           forceFit: true
                       },
                       listeners: {
                           afteredit: function(e) {
                               if (e.row < e.grid.getStore().getCount()) {
                                   e.grid.stopEditing();
                                   if (e.column < e.record.fields.getCount() - 1) {//最后一行操作不算
                                       //alert('e.column+1');
                                       e.grid.startEditing(e.row, e.column + 1);
                                   }
                                   else {
                                       //alert('e.row+1')
                                       e.grid.startEditing(e.row + 1, 1);
                                   }
                               }

                           }
                       }

                   });
                   function inserNewBlankRow() {
                      
                       var rowCount = userGrid.getStore().getCount();
                   
                       var insertPos = parseInt(rowCount);
                       var addRow = new RowPattern({
                           DetailName: '',
                           OrderColumn: '',
                           Round: ''
                       });
                       userGrid.stopEditing();
                       //增加一新行
                       if (insertPos > 0) {
                           var rowIndex = dsOrderProduct.insert(insertPos, addRow);
                           userGrid.startEditing(insertPos, 0);
                       }
                       else {
                           var rowIndex = dsOrderProduct.insert(0, addRow);
                           userGrid.startEditing(0, 0);
                       }
                   }
                   function addNewBlankRow(combo, record, index) {
                       var rowIndex = userGrid.getStore().indexOf(userGrid.getSelectionModel().getSelected());
                       var rowCount = userGrid.getStore().getCount();
                       if ((rowIndex == 0 && rowCount == 1) || rowIndex == rowCount - 1) {
                           inserNewBlankRow();
                       }
                   }
                   //inserNewBlankRow();
                   var addoptionForm = new Ext.form.FormPanel({
                       frame: true,
                       monitorValid: true, // 把有formBind:true的按钮和验证绑定

                       items: [
                               {
                                   layout: 'column',
                                   items: [
	                                   {
	                                       columnWidth: .5,
	                                       layout: 'form',
	                                       border: false,
	                                       labelWidth: 55,
	                                       items: [{
	                                           cls: 'key',
	                                           fieldLabel: '模板名称',
	                                           xtype: 'textfield',
	                                           name: 'tpname',
	                                           id: 'tpname',
	                                           anchor: '90%'
}]
	                                       }, {
	                                           columnWidth: .5,
	                                           layout: 'form',
	                                           border: false,
	                                           labelWidth: 55,
	                                           items: [zjlbComb]
	                                       }
	                                  ]
                               }, {
                                   layout: 'column',
                                   items: [
	                                   {
	                                       columnWidth: .5,
	                                       layout: 'form',
	                                       border: false,
	                                       labelWidth: 65,
	                                       items: [{
	                                           cls: 'key',
	                                           fieldLabel: '导出开始行',
	                                           xtype: 'hidden',
	                                           name: 'outcolumn',
	                                           id: 'outcolumn',
	                                           anchor: '90%'
}]
	                                       }, {
	                                           columnWidth: .5,
	                                           layout: 'form',
	                                           border: false,
	                                           labelWidth: 55,
	                                           items: [{
	                                               cls: 'key',
	                                               fieldLabel: '合计方式',
	                                               xtype: 'hidden',
	                                               name: 'counttype',
	                                               id: 'counttype',
	                                               anchor: '90%'
}]
	                                           }
	                                  ]
                               }, {
                                   layout: 'column',
                                   items: [
	                                   {
	                                       columnWidth: .5,
	                                       layout: 'form',
	                                       border: false,
	                                       labelWidth: 95,
	                                       items: [{
	                                           cls: 'key',
	                                           fieldLabel: '导出明细开始行',
	                                           xtype: 'textfield',
	                                           name: 'detailcolumn',
	                                           id: 'detailcolumn',
	                                           anchor: '90%'
}]
	                                       }, {
	                                           columnWidth: .5,
	                                           layout: 'form',
	                                           border: false,
	                                           labelWidth: 95,
	                                           items: [{
	                                               cls: 'key',
	                                               fieldLabel: '导出模板名称',
	                                               xtype: 'textfield',
	                                               name: 'outname',
	                                               id: 'outname',
	                                               anchor: '90%'
}]
	                                           }
	                                  ]
                               }, {
                                   layout: 'column',
                                   items: [
	                                   {
	                                       columnWidth: .5,
	                                       layout: 'form',
	                                       border: false,
	                                       labelWidth: 95,
	                                       items: [{
	                                           cls: 'key',
	                                           fieldLabel: '合计导出开始列',
	                                           xtype: 'textfield',
	                                           name: 'countstart',
	                                           id: 'countstart',
	                                           anchor: '90%'
}]
}]
                               }, {
                                   layout: 'column',
                                   items: [
	                                   {
	                                       columnWidth: 1,
	                                       layout: 'form',
	                                       border: false,
	                                       labelWidth: 30,
	                                       items: [{
	                                           cls: 'key',
	                                           fieldLabel: '备注',
	                                           xtype: 'textfield',
	                                           name: 'note',
	                                           id: 'note',
	                                           anchor: '90%'
}]
}]
                               }, userGrid]

                   });


                   optionWindow.add(addoptionForm);
                   var serchform_form = new Ext.form.FormPanel({
                       renderTo: "serchform_form",
                       frame: true,
                       monitorValid: true, // 把有formBind:true的按钮和验证绑定
                       layout: "form",
                       items: [{
                           layout: 'column',
                           items: [
	                                   {
	                                       columnWidth: .25,
	                                       layout: 'form',
	                                       border: false,
	                                       items: [{
	                                           cls: 'key',
	                                           fieldLabel: '取样开始日期',
	                                           xtype: 'datefield',
	                                           name: 'qstartdate',
	                                           id: 'qstartdate',
	                                           anchor: '90%'
}]
	                                       }, {
	                                           columnWidth: .25,
	                                           layout: 'form',
	                                           border: false,
	                                           items: [{
	                                               cls: 'key',
	                                               fieldLabel: '取样结束日期',
	                                               xtype: 'datefield',
	                                               name: 'qenddate',
	                                               id: 'qenddate',
	                                               anchor: '90%'
}]
	                                           }, {
	                                               columnWidth: .25,
	                                               layout: 'form',
	                                               border: false,
	                                               items: [{
	                                                   cls: 'key',
	                                                   fieldLabel: '检验开始日期',
	                                                   xtype: 'datefield',
	                                                   name: 'jstartdate',
	                                                   id: 'jstartdate',
	                                                   anchor: '90%'
}]
	                                               }, {
	                                                   columnWidth: .25,
	                                                   layout: 'form',
	                                                   border: false,
	                                                   items: [{
	                                                       cls: 'key',
	                                                       fieldLabel: '检验结束日期',
	                                                       xtype: 'datefield',
	                                                       name: 'jenddate',
	                                                       id: 'jenddate',
	                                                       anchor: '90%'
}]
	                                                   }
	                                  ]
                       }, {
                           layout: 'column',   //定义该元素为布局为列布局方式
                           border: false,
                           labelSeparator: '：',
                           items: [{
                               columnWidth: .3,
                               layout: 'form',
                               labelWidth: 55,
                               border: false,
                               items: [{
                                   cls: 'key',
                                   xtype: 'textfield',
                                   fieldLabel: '质检名称',
                                   name: 'qtName',
                                   id: 'qtName',
                                   anchor: '90%'
}]
                               }, {
                                   columnWidth: .3,
                                   layout: 'form',
                                   labelWidth: 55,
                                   border: false,
                                   items: [{
                                       cls: 'key',
                                       xtype: 'textfield',
                                       fieldLabel: '产品名称',
                                       name: 'pName',
                                       id: 'pName',
                                       anchor: '90%'
}]
                                   }
		,
		{
		    columnWidth: .10,
		    layout: 'form',
		    border: false,
		    items: [{ cls: 'key',
		        xtype: 'button',
		        text: '查询',
		        anchor: '50%',
		        handler: function() {
		            queryreport();
		        }
}]
}]
}]
                               });
                               function outExcel() {
                                   var title = escape(outFormulaname);
                                   window.open('frmQtZJTemplate.aspx?method=outExcel&title=' + title + '&outstring=' + escape(excelstr));


                               }
                               function aaa(resstr) {
                                   excelstr = "";


                                   var strarr = resstr.split("@");

                                   var tablestr = "<table width='100%' border ='1'>"
                                   for (var x = 0; x < strarr.length; x++) {
                                       tablestr += "<tr>";
                                       var tdarr = strarr[x].split(",");
                                       for (var y = 0; y < tdarr.length; y++) {
                                           excelstr += tdarr[y] + "\t";
                                           tablestr += "<td>" + tdarr[y] + "</td>";
                                       }
                                       excelstr = excelstr.substring(0, excelstr.length - 1);
                                       excelstr += "\n";
                                       tablestr += "</tr>";
                                   }
                                   tablestr += "</table>";
                                   printstr = "<div style='text-align:center'>" + outFormulaname + "</div>" + tablestr;
                                   return tablestr;
                               }
                               function queryreport() {
                                   var optionData = optionGrid.getSelectionModel().getCount();

                                   if (optionData == 0) {
                                       Ext.Msg.alert("提示", "请选择一条模板！");
                                       return;
                                   }
                                   if (optionData > 1) {
                                       Ext.Msg.alert("提示", "只能选择一条模板！");
                                       return;
                                   }
                                   var record = optionGrid.getSelectionModel().getSelections()[0].data;
                                   var notifytno = record.FormulaNo;
                                   var checktp = record.CheckType;
                                   outFormulaname = record.OutFormulaName;
                                   var qsdate = Ext.getCmp("qstartdate").getValue();
                                   if (qsdate != null && qsdate != '') {

                                       qsdate = Ext.util.Format.date(qsdate, 'Y/m/d');
                                   }
                                   var qedate = Ext.getCmp("qenddate").getValue();
                                   if (qedate != null && qedate != '') {

                                       qedate = Ext.util.Format.date(qedate, 'Y/m/d');
                                   }
                                   var jsdate = Ext.getCmp("jstartdate").getValue();
                                   if (jsdate != null && jsdate != '') {

                                       jsdate = Ext.util.Format.date(jsdate, 'Y/m/d');
                                   }
                                   var jedate = Ext.getCmp("jenddate").getValue();
                                   if (jedate != null && jedate != '') {

                                       jedate = Ext.util.Format.date(jedate, 'Y/m/d');
                                   }
                                   var pname = Ext.getCmp("pName").getValue();
                                   Ext.Ajax.request({
                                       url: 'frmQtZJTemplate.aspx?method=getReport'
                                               , params: {
                                                   ntno: notifytno,
                                                   pname: pname,
                                                   cktype: checktp,
                                                   qsdate: qsdate,
                                                   qedate: qedate,
                                                   jsdate: jsdate,
                                                   jedate: jedate
                                               },
                                       //成功时回调
                                       success: function(response, options) {
                                           if (response == null || response.responseText == '' || response.responseText.length < 5) {
                                               Ext.Msg.alert("提示", "没有符合条件的检验结果！");
                                               return;
                                           } else {
                                               resultWindow.show();
                                               resultWindow.add(detail);
                                               panel.html = ''
                                               var str = aaa(response.responseText);
                                               var divobj = document.createElement("div");
                                               divobj.innerHTML = str;

                                               var thtml = '<div style="width:100%;text-align:center"> <font size="4"><H1>' + outFormulaname + '</H1></font></div>'
                                               var divobj1 = document.createElement("div");
                                               divobj1.innerHTML = thtml;
                                               panel.getEl().dom.lastChild.lastChild.appendChild(divobj1);
                                               detail.getEl().dom.lastChild.lastChild.appendChild(divobj);

                                           }

                                       },
                                       failure: function() {
                                           Ext.Msg.alert("提示", "获取报表失败！");
                                       }
                                   });



                               }
                               var opserch_form = new Ext.form.FormPanel({
                                   renderTo: "zjtemp_form",
                                   frame: true,
                                   monitorValid: true, // 把有formBind:true的按钮和验证绑定
                                   layout: "form",
                                   items: [{
                                       layout: 'column',   //定义该元素为布局为列布局方式
                                       border: false,
                                       labelSeparator: '：',
                                       items: [{
                                           columnWidth: .3,
                                           layout: 'form',
                                           labelWidth: 55,
                                           border: false,
                                           items: [{
                                               cls: 'key',
                                               xtype: 'textfield',
                                               fieldLabel: '模板名称',
                                               name: 'scOptionName',
                                               id: 'scOptionName',
                                               anchor: '90%'
}]
                                           }
		,
		{
		    columnWidth: .10,
		    layout: 'form',
		    border: false,
		    items: [{ cls: 'key',
		        xtype: 'button',
		        text: '查询',
		        anchor: '50%',
		        handler: function() {
		            queryoption();
		        }
}]
}]
}]
                                       });
                                       function queryoption() {

                                           // var dept = Ext.getCmp("cpnm").getValue();
                                           var optionName = Ext.getCmp("scOptionName").getValue();
                                           optionStore.baseParams.start=0;
                                           optionStore.baseParams.limit=10;
                                           optionStore.load({
                                               params: {
                                                   key: optionName
                                               }
                                           });

                                       }

                                       var optionStore = new Ext.data.Store
			({
			    url: 'frmQtZJTemplate.aspx?method=queryNT',
			    reader: new Ext.data.JsonReader({
			        totalProperty: 'totalProperty',
			        root: 'root'
			    }, [
			    { name: 'FormulaNo' },
			    { name: 'OrgName' },
			    { name: 'FormulaName' },
			    { name: 'CheckType' },
	            { name: 'Note' },
	            { name: 'CreateDate' },
	            { name: 'OutFormulaName' },
			    { name: 'OutColumnStart' },
	            { name: 'OutCountStart' },
	            { name: 'OutDetailStart' },
			    { name: 'CountType' }

			    ])
			   ,
			    listeners:
			      {
			          scope: this,
			          load: function() {
			              //数据加载预处理,可以做一些合并、格式处理等操作
			          }
			      }
			});
                                       var sm = new Ext.grid.CheckboxSelectionModel(
            {
                singleSelect: false
            }
        );
                                       var optionGrid = new Ext.grid.GridPanel({

                                           el: 'zjtemp_grid',
                                           width: '100%',
                                           height: '100%',
                                           autoWidth: true,
                                           autoHeight: true,
                                           autoScroll: true,
                                           layout: 'fit',
                                           id: 'customerdatagrid',
                                           store: optionStore,
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
                                            {header: '分公司名称', dataIndex: 'OrgName' },
									        { header: '质检类型', dataIndex: 'CheckType', renderer: cktp },
									        { header: '模板名称', dataIndex: 'FormulaName' },
											{ header: '备注', dataIndex: 'Note' },
											{ header: '创建时间', dataIndex: 'CreateDate' }
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
                                           bbar: new Ext.PagingToolbar({
                                               pageSize: 10,
                                               store: optionStore,
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
                                           //width: 750, 
                                           height: 265,
                                           closeAction: 'hide',

                                           stripeRows: true,
                                           loadMask: true,
                                           autoExpandColumn: 2
                                       });
                                       optionGrid.render();
                                   }); 
		
	</script>
</html>
