<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmSolutionCfg.aspx.cs" Inherits="QT_frmSolutionCfg" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=GB2312">
    <link rel="stylesheet" type="text/css" href="../ext3/resources/css/ext-all.css" />
	<script type="text/javascript" src="../ext3/adapter/ext/ext-base.js"></script>	
	<script type="text/javascript" src="../ext3/ext-all.js"></script>
</head>
<body>
	<div id="solution_toolbar"></div>
	 <div id="solution_form"></div>
	 <div id="solution_grid"></div>
</body><script>
           var modify_Solution_id = 'none';
           var addSolutionmark = 0;
           Ext.BLANK_IMAGE_URL = "../ext3/resources/images/default/s.gif"; 
           Ext.onReady(function() {
               var Toolbar = new Ext.Toolbar({
                   renderTo: "solution_toolbar",
                   items: [{
                       text: "新增",
                       icon: '../Theme/1/images/extjs/customer/add16.gif',
                       handler: function() {
                           // saveType = "add";
                           // openAddQuotaWin();//点击后，弹出添加信息窗口
                           addSolutionmark = 1;
                           solutionWindow.show();
                       }
                   }, '-', {
                       text: "修改",
                       icon: '../Theme/1/images/extjs/customer/edit16.gif',
                       handler: function() {
                           ///  deleteCustomer();

                           var solutionData = solutionGrid.getSelectionModel().getCount();
                           if (solutionData == 0) {
                               Ext.Msg.alert("提示", "请选中要修改的记录！");
                               return;
                           }
                           if (solutionData > 1) {
                               Ext.Msg.alert("提示", "一次只能修改一条记录！");
                               return;
                           }
                           addSolutionmark = 0;
                           modifySolution(solutionData);

                       }
                   }, '-', {
                       text: "删除",
                       icon: '../Theme/1/images/extjs/customer/delete16.gif',
                       handler: function() {

                           var solutionData = solutionGrid.getSelectionModel().getCount();
                           if (solutionData == 0) {
                               Ext.Msg.alert("提示", "请选中要删除的行！");
                               return;
                           }
                           delSolution(solutionData);

                       }
}]
                   });
                   if (typeof (solutionWindow) == "undefined") {//解决创建2个windows问题
                       var solutionWindow = new Ext.Window({
                           title: '新增溶液',
                           modal: 'true',
                           width: 300,
                           height: 280,
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

                                   addSolution();

                               }
                           }, {
                               text: '关闭',
                               handler: function() {
                                   solutionWindow.hide();
                                   addSolutionForm.getForm().reset();
                               }
}]
                           });
                       }


/*
                       var soluNameCombo = new Ext.form.ComboBox({
                           xtype: 'combo',
                           store: new Ext.data.Store({
                               autoLoad: true,
                               baseParams: {
                                   trancode: 'Menu'
                               },
                               proxy: new Ext.data.HttpProxy({
                                   url: 'frmSolutionCfg.aspx?method=getSolutionItems'
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
                           blankText: '溶液名称不能为空',
                           forceSelection: true,
                           emptyText: '请选择溶液名称',
                           editable: false,
                           triggerAction: 'all',
                           fieldLabel: '溶液名称',
                           selectOnFocus: true,
                           anchor: '90%'
                       });

*/
                    

                       //修改指标
                       function modifySolution(rownum) {

                           // alert(quotaGrid.getSelectionModel().getSelections()[selectData - 1].data.QuotaName);

                           solutionWindow.show();
                           var record = solutionGrid.getSelectionModel().getSelections()[rownum - 1].data;
                             Ext.getCmp("addSolutionName").setValue(record.SolutionName);
                             Ext.getCmp("MolecularFormula").setValue(record.MolecularFormula);
                             Ext.getCmp("Note").setValue(record.Note);
                             Ext.getCmp("Titer").setValue(record.Titer);
                             modify_Solution_id = record.SolutionNo; 
                       }

                       function delSolution(rownum) {
                           var ids = "";
                           var recorddel = solutionGrid.getSelectionModel().getSelections();
                           if (rownum == 1) {
                               ids = recorddel[0].data.SolutionNo;
                           } else {
                               for (var i = 0; i < rownum; i++) {
                                   ids += recorddel[i].data.SolutionNo + ',';
                               }
                               ids = ids.substring(0, ids.length - 1);
                           }

                           Ext.Ajax.request({
                           url: 'frmSolutionCfg.aspx?method=delSolution'
                               , params: {
                                   ids: ids
                               },
                               //成功时回调 
                               success: function(response, options) {
                                   //获取响应的json字符串

                                   Ext.Msg.alert("提示", "删除成功！");
                                   for (var i = 0; i < recorddel.length; i++) {
                                       solutionStore.remove(recorddel[i]);
                                   }


                               },
                               failure: function() {
                                   Ext.Msg.alert("提示", "删除失败！");
                               }
                           });
                       }


                       //新增指标
                       function addSolution() {
                           var MolecularFormula = Ext.getCmp("MolecularFormula").getValue();
                           if (MolecularFormula == null || MolecularFormula.trim() == '') {
                               Ext.Msg.alert("提醒", "溶液分子式不能为空！");
                               return;
                           }
                           var Titer = Ext.getCmp("Titer").getValue();
                          /* if (Titer == null || Titer.trim() == '') {
                               Ext.Msg.alert("提醒", "滴定度不能为空！");
                               return;
                           }*/
                           var Note = Ext.getCmp("Note").getValue();
                         /*  if (Note == null || Note.trim() == '') {
                               Ext.Msg.alert("提醒", "备注不能为空！");
                               return;
                           }*/
                           var soluName = Ext.getCmp("addSolutionName").getValue();
                           if (soluName == null || soluName.trim() == '' || soluName == 'undefined') {
                               Ext.Msg.alert("提醒", "溶液名称不能为空！");
                               return;
                           }
 
 
                           var qurl = 'frmSolutionCfg.aspx?method=addSolution';

                           if (modify_Solution_id != '' && modify_Solution_id != null && addSolutionmark == 0) {

                               qurl = 'frmSolutionCfg.aspx?method=updateSolution&SolutionNo=' + modify_Solution_id;
                           }

                           Ext.Ajax.request({
                               url: qurl
                               , params: {
                                   MolecularFormula: MolecularFormula
                                   , Titer: Titer
                                   , Note: Note
                                   , SolutionName: soluName
                               },
                               //成功时回调 
                               success: function(response, options) {
                                   //获取响应的json字符串

                                   Ext.Msg.alert("提示", "保存成功！");
                                   solutionWindow.hide();
                                   addSolutionForm.getForm().reset();
                              //     var dept = soluCompanyCombosc.getValue();
                                   var solutionName = Ext.getCmp("SolutionName").getValue();
                                   
                                   solutionStore.baseParams.start=0;
                                   solutionStore.baseParams.limit=10;
                                   solutionStore.load({
                                       params: {
                                           key: solutionName
                                        //  , dept: dept
                                       }
                                   });


                               },
                               failure: function() {
                                   Ext.Msg.alert("提示", "保存失败！");
                               }
                           });

                       }



                       var addSolutionForm = new Ext.form.FormPanel({
                           frame: true,
                           monitorValid: true, // 把有formBind:true的按钮和验证绑定
                           labelWidth: 120,
                           items: [{
                               layout: 'form',
                               xtype: "fieldset",
                               title: '溶液配置',
                               layout: 'column',
                               items: [{
                                   layout: 'form',
                                   columnWidth: 1,  //该列占用的宽度，标识为20％
                                   border: false,
                                   items: [{
                                       cls: 'key',
                                       xtype: 'textfield',
                                       fieldLabel: '溶液名称',
                                       name: 'addSolutionName',
                                       id: 'addSolutionName',
                                       anchor: '90%'
                                   }, {
                                       cls: 'key',
                                       xtype: 'textfield',
                                       fieldLabel: '溶液分子式',
                                       name: 'MolecularFormula',
                                       id: 'MolecularFormula',
                                       anchor: '90%'
                                   }, {
                                       cls: 'key',
                                       xtype: 'textfield',
                                       fieldLabel: '滴定度',
                                       name: 'Titer',
                                       id: 'Titer',
                                       anchor: '90%'
                                   }, {
                                       cls: 'key',
                                       xtype: 'textfield',
                                       fieldLabel: '备注',
                                       name: 'Note',
                                       id: 'Note',
                                       anchor: '90%'
}]
}]
}]
                                   });


                                   solutionWindow.add(addSolutionForm);
                                   var soluserch_form = new Ext.form.FormPanel({
                                       renderTo: "solution_form",
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
                                               border: false,
                                               labelWidth: 55,
                                               items: [{
                                                   cls: 'key',
                                                   xtype: 'textfield',
                                                   fieldLabel: '溶液名称',
                                                   name: 'SolutionName',
                                                   id: 'SolutionName',
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
		            querySolution();
		        }
}]
}]
}]
                                           });


                                           function querySolution() {

                                            //   var dept = soluCompanyCombosc.getValue();
                                               var solutionName = Ext.getCmp("SolutionName").getValue();
                                               
                                               solutionStore.baseParams.start=0;
                                               solutionStore.baseParams.limit=10;
                                               solutionStore.load({
                                                   params: {
                                                     key: solutionName
                                                   //, dept: dept
                                                   }
                                               });

                                           }

                                           var solutionStore = new Ext.data.Store
			({
			    url: 'frmSolutionCfg.aspx?method=getSolution',
			    reader: new Ext.data.JsonReader({
			        totalProperty: 'totalProperty',
			        root: 'root'
			    }, [
			    { name: 'OrgName' },
	            { name: 'SolutionName' },
	            { name: 'MolecularFormula' },
			    { name: 'SolutionNo' },
	            { name: 'Titer' },
	            { name: 'CreateDate' },
	            { name: 'EmpName' },
	             { name: 'Note' }
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
                                           var solutionGrid = new Ext.grid.GridPanel({

                                               el: 'solution_grid',
                                               width: '100%',
                                               height: '100%',
                                               autoWidth: true,
                                               autoHeight: true,
                                               autoScroll: true,
                                               layout: 'fit',
                                               id: 'customerdatagrid',
                                               store: solutionStore,
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
									        { header: '溶液名称', dataIndex: 'SolutionName' },
									        { header: '溶液分子式', dataIndex: 'MolecularFormula' },
									        { header: '溶液ID', hidden: true, dataIndex: 'SolutionNo' },
											{ header: '滴定度', dataIndex: 'Titer'},
											{ header: '录入时间', dataIndex: 'CreateDate' },
											{ header: '备注', dataIndex: 'Note' },
											{ header: '操作人', dataIndex: 'EmpName' }
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
                                                   store: solutionStore,
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
                                           solutionGrid.render();
                                       }); 
		
	</script>
</html>
