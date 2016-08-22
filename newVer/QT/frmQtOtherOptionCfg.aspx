<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmQtOtherOptionCfg.aspx.cs" Inherits="QT_frmQtOtherOptionCfg" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=GB2312">
    <link rel="stylesheet" type="text/css" href="../ext3/resources/css/ext-all.css" />
	<script type="text/javascript" src="../ext3/adapter/ext/ext-base.js"></script>	
	<script type="text/javascript" src="../ext3/ext-all.js"></script>
</head>
<body>
	<div id="option_toolbar"></div>
	 <div id="option_form"></div>
	 <div id="option_grid"></div>
</body><script>
           var modify_option_id = 'none';
           var addoptionmark = 0;
           Ext.BLANK_IMAGE_URL = "../ext3/resources/images/default/s.gif";
           Ext.onReady(function() {
               var Toolbar = new Ext.Toolbar({
                   renderTo: "option_toolbar",
                   items: [{
                       text: "新增",
                       icon: '../Theme/1/images/extjs/customer/add16.gif',
                       handler: function() {
                           // saveType = "add";
                           // openAddQuotaWin();//点击后，弹出添加信息窗口
                           addoptionmark = 1;
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
                           title: '新增其他选项',
                           modal: 'true',
                           width: 310,
                           height: 200,
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

                                   addoption();

                               }
                           }, {
                               text: '关闭',
                               handler: function() {
                                   optionWindow.hide();
                                   addoptionForm.getForm().reset();
                               }
}]
                           });
                       }



                       var optionTypeCombo = new Ext.form.ComboBox({
                           xtype: 'combo',
                           store: new Ext.data.Store({
                               autoLoad: true,
                               baseParams: {
                                   trancode: 'Menu'
                               },
                               proxy: new Ext.data.HttpProxy({
                                   url: 'frmQtOtherOptionCfg.aspx?method=getOption&key=Option'
                               }),
                               // create reader that reads the project records
                               reader: new Ext.data.JsonReader({ root: 'root' }, [
                                { name: 'name', type: 'string' },
                                { name: 'id', type: 'string' }

                               ])
                           })
,
                           valueField: 'id',
                           displayField: 'name',
                           mode: 'local',
                           allowBlank: false,
                           blankText: '选项类型不能为空',
                           forceSelection: true,
                           emptyText: '请选择选项类型',
                           editable: false,
                           triggerAction: 'all',
                           fieldLabel: '选项类型',
                           selectOnFocus: true,
                           anchor: '90%'
                       });

                       var serchoptionTypeCombo = new Ext.form.ComboBox({
                           xtype: 'combo',
                           store: new Ext.data.Store({
                               autoLoad: true,
                               baseParams: {
                                   trancode: 'Menu'
                               },
                               proxy: new Ext.data.HttpProxy({
                                   url: 'frmQtOtherOptionCfg.aspx?method=getOption&key=Option'
                               }),
                               // create reader that reads the project records
                               reader: new Ext.data.JsonReader({ root: 'root' }, [
                                { name: 'name', type: 'string' },
                                { name: 'id', type: 'string' }

                               ])
                           })
,
                           valueField: 'id',
                           displayField: 'name',
                           mode: 'local',
                           allowBlank: false,
                           blankText: '选项类型不能为空',
                           forceSelection: true,
                           emptyText: '请选择选项类型',
                           editable: false,
                           triggerAction: 'all',
                           fieldLabel: '选项类型',
                           selectOnFocus: true,
                           anchor: '90%'
                       });

                       //修改指标
                       function modifyoption(rownum) {

                           // alert(quotaGrid.getSelectionModel().getSelections()[selectData - 1].data.QuotaName);

                           optionWindow.show();
                           var record = optionGrid.getSelectionModel().getSelections()[0].data;
                           
                           Ext.getCmp("addOptionName").setValue(record.OptionName);
                           optionTypeCombo.setValue(record.OptionType);
                           Ext.getCmp("OptionNote").setValue(record.OptionNote);
                     

                           modify_option_id = record.OptionNo;
                       }

                       function deloption(rownum) {
                           var ids = "";
                           var recorddel = optionGrid.getSelectionModel().getSelections();
                           if (rownum == 1) {
                               ids = recorddel[0].data.OptionNo;
                           } else {
                               for (var i = 0; i < rownum; i++) {
                                   ids += recorddel[i].data.OptionNo + ',';
                               }
                               ids = ids.substring(0, ids.length - 1);
                           }

                           Ext.Ajax.request({
                               url: 'frmQtOtherOptionCfg.aspx?method=deloption'
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


                       //新增指标
                       function addoption() {
                           var optionType = optionTypeCombo.getValue();
                           if (optionType == null || optionType.trim() == '' || optionType == 'undefined') {
                               Ext.Msg.alert("提醒", "请选择选项类型！");
                               return;
                           }
                           var addOptionName = Ext.getCmp("addOptionName").getValue();
                           if (addOptionName == null || addOptionName.trim() == '') {
                               Ext.Msg.alert("提醒", "选项名称不能为空！");
                               return;
                           } 
                           var Note = Ext.getCmp("OptionNote").getValue();
                         /*(  if (Note == null || Note.trim() == '') {
                               Ext.Msg.alert("提醒", "备注不能为空！");
                               return;
                           }*/

                           var qurl = 'frmQtOtherOptionCfg.aspx?method=addOption';

                           if (modify_option_id != '' && modify_option_id != null && addoptionmark == 0) {

                               qurl = 'frmQtOtherOptionCfg.aspx?method=updateOption&optionno=' + modify_option_id;
                           }

                           Ext.Ajax.request({
                               url: qurl
                               , params: {
                                   // FormulaNo:
                                   OptionName: addOptionName,
                                   optionType: optionType,
                                   OptionNote: Note

                               },
                               //成功时回调 
                               success: function(response, options) {
                                   //获取响应的json字符串

                                   Ext.Msg.alert("提示", "保存成功！");
                                   optionWindow.hide();
                                   addoptionForm.getForm().reset();
                              //     var dept = Ext.getCmp("cpnm").getValue();
                                   var optionName = Ext.getCmp("scOptionName").getValue();
                                   var optionType = serchoptionTypeCombo.getValue();
                                   optionStore.baseParams.start=0;
                                   optionStore.baseParams.limit=10;
                                   optionStore.load({
                                       params: {
                                           key: optionName
                                             //      , dept: dept
                                                   , optionType: optionType
                                       }
                                   });


                               },
                               failure: function() {
                                   Ext.Msg.alert("提示", "保存失败！");
                               }
                           });

                       }



                       var addoptionForm = new Ext.form.FormPanel({
                           frame: true,
                           monitorValid: true, // 把有formBind:true的按钮和验证绑定
                           labelWidth: 65,
                           items: [{
                               layout: 'form',
                               xtype: "fieldset",
                               title: '其他选项配置',
                               layout: 'column',
                               items: [{
                                   layout: 'form',
                                   columnWidth: 1,  //该列占用的宽度，标识为20％
                                   border: false,
                                   items: [optionTypeCombo, {
                                       cls: 'key',
                                       xtype: 'textfield',
                                       fieldLabel: '选项名称',
                                       name: 'addOptionName',
                                       id: 'addOptionName',
                                       anchor: '90%'
                                   }, {
                                       cls: 'key',
                                       xtype: 'textfield',
                                       fieldLabel: '备注',
                                       name: 'OptionNote',
                                       id: 'OptionNote',
                                       anchor: '90%'
}]
}]
}]
                                   });


                                   optionWindow.add(addoptionForm);
                                   var opserch_form = new Ext.form.FormPanel({
                                       renderTo: "option_form",
                                       frame: true,
                                       monitorValid: true, // 把有formBind:true的按钮和验证绑定
                                       layout: "form",
                                       items: [{
                                           layout: 'column',   //定义该元素为布局为列布局方式
                                           border: false,
                                           labelSeparator: '：',
                                           items: [ {
                                                   columnWidth: .3,
                                                   layout: 'form',
                                                   labelWidth: 55,
                                                   border: false,
                                                   items: [{
                                                       cls: 'key',
                                                       xtype: 'textfield',
                                                       fieldLabel: '选项名称',
                                                       name: 'scOptionName',
                                                       id: 'scOptionName',
                                                       anchor: '90%'
}]
                                                   }
		, {
		    columnWidth: .25,
		    layout: 'form',
		    border: false,
		    items: [
                                                    serchoptionTypeCombo
                                                    ]
		},
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
                                                   var optionType = serchoptionTypeCombo.getValue();
                                                   optionStore.baseParams.start=0;
                                                   optionStore.baseParams.limit=10;
                                                   optionStore.load({
                                                       params: {
                                                           key: optionName
                                                   //, dept: dept
                                                   , optionType: optionType
                                                       }
                                                   });

                                               }

                                               var optionStore = new Ext.data.Store
			({
			    url: 'frmQtOtherOptionCfg.aspx?method=queryOption',
			    reader: new Ext.data.JsonReader({
			        totalProperty: 'totalProperty',
			        root: 'root'
			    }, [
			     { name: 'OptionNo' },
			    { name: 'OwnDept' },
			    { name: 'OrgName' },
			    { name: 'OptionType' },
			    { name: 'DicsName' },
	            { name: 'OptionName' },
	            { name: 'OptionNote' }

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

                                                   el: 'option_grid',
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
									        { header: '配制项ID', hidden: true, dataIndex: 'OptionNo' },
									        { header: '选项类型ID', hidden: true, dataIndex: 'OptionType' },
									        { header: '选项类型', dataIndex: 'DicsName' },
									        { header: '选项名称', dataIndex: 'OptionName' },
											{ header: '备注', dataIndex: 'OptionNote' }
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

