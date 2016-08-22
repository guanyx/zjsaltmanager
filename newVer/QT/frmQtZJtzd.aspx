<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmQtZJtzd.aspx.cs" Inherits="QT_frmQtZJtzd" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=GB2312">
    <link rel="stylesheet" type="text/css" href="../ext3/resources/css/ext-all.css" />
	<script type="text/javascript" src="../ext3/adapter/ext/ext-base.js"></script>	
	<script type="text/javascript" src="../ext3/ext-all.js"></script>
</head>
<body>
	 <div id="zjnotify_toolbar"></div>
	 <div id="zjnotify_form"></div>
	 <div id="zjnotify_grid"></div>
</body>
<%=getComboBoxStore() %>
<script>
           Ext.BLANK_IMAGE_URL = "../ext3/resources/images/default/s.gif"; 
           var modify_quota_id = 'none';
           var addmark = 0;
           var detaillength = 0;
           var idsstr="";
           var therecord;
           var ckid;
           var loc;
           Ext.onReady(function() {

               var dsWarehousePositionList; //仓位下拉框
               if (dsWarehousePositionList == null) { //防止重复加载
                   dsWarehousePositionList = new Ext.data.JsonStore({
                       totalProperty: "result",
                       root: "root",
                       url: 'frmQtZJtzd.aspx?method=getPosition',
                       fields: ['WhpId', 'WhpName']
                   });
               }

               var dsWarehousePositionList_grid; //仓位下拉框
               if (dsWarehousePositionList_grid == null) { //防止重复加载
                   //alert(1);
                   dsWarehousePositionList_grid = new Ext.data.JsonStore({
                       totalProperty: "result",
                       root: "root",
                       url: 'frmQtZJtzd.aspx?method=getPosition',
                       fields: ['WhpId', 'WhpName']
                   });
                   //dsWarehousePositionList_grid.load();

               }
               var WhNamePanel = new Ext.form.ComboBox({
                   fieldLabel: '仓库名称',

                   name: 'warehouseCombo',
                   store: dsWarehouseList,
                   displayField: 'WhName',
                   valueField: 'WhId',
                   typeAhead: true, //自动将第一个搜索到的选项补全输入
                   triggerAction: 'all',
                   emptyText: '请选择仓库',
                   selectOnFocus: true,
                   forceSelection: true,
                   anchor: '90%',
                   mode: 'local',
                   listeners: {
                       select: function(combo, record, index) {
                           var curWhId = WhNamePanel.getValue();
                           dsWarehousePositionList.load({
                               params: {
                                   WhId: curWhId
                               }
                           });
                       }
                   }
               });
               var WhpNamePanel = new Ext.form.ComboBox({
                   fieldLabel: '仓位名称',
                   name: 'warehousePosCombo',
                   store: dsWarehousePositionList,
                   displayField: 'WhpName',
                   valueField: 'WhpId',
                   typeAhead: true, //自动将第一个搜索到的选项补全输入
                   triggerAction: 'all',
                   emptyText: '请选择仓位',
                   //valueNotFoundText: 0,
                   selectOnFocus: true,
                   forceSelection: true,
                   mode: 'local',
                   id: 'WhpId',
                   anchor: '90%',
                   listeners: {
                       blur: function(field) { if (field.getRawValue() == '') { field.clearValue(); } }
                   }

               });
               var Toolbar = new Ext.Toolbar({
                   renderTo: "zjnotify_toolbar",
                   items: [{
                       text: "新增",
                       icon: '../Theme/1/images/extjs/customer/add16.gif',
                       handler: function() {
                           // saveType = "add";
                           // openAddQuotaWin();//点击后，弹出添加信息窗口
                           addmark = 1;
                           formulaWindow.show();
                       }
                   }, '-', {
                       text: "修改",
                       icon: '../Theme/1/images/extjs/customer/edit16.gif',
                       handler: function() {
                           ///  deleteCustomer();

                           var selectData = quotaGrid.getSelectionModel().getCount();
                           if (selectData == 0) {
                               Ext.Msg.alert("提示", "请选中要修改的记录！");
                               return;
                           }
                           if (selectData > 1) {
                               Ext.Msg.alert("提示", "一次只能修改一条记录！");
                               return;
                           }
                           addmark = 0;
                           modifyNodify(selectData);

                       }
                   }, '-', {
                       text: "删除",
                       icon: '../Theme/1/images/extjs/customer/delete16.gif',
                       handler: function() {

                           var selectData = quotaGrid.getSelectionModel().getCount();
                           if (selectData == 0) {
                               Ext.Msg.alert("提示", "请选中要删除的行！");
                               return;
                           }
                           deloption(selectData);

                       }
                 }, '-', {
                       text: "进行质检",
                       icon: '../Theme/1/images/extjs/customer/spellcheck.png',
                       handler: function() {

                          var optionData = quotaGrid.getSelectionModel().getCount();
                           if (optionData == 0) {
                               Ext.Msg.alert("提示", "请选中要质检的记录！");
                               return;
                           }
                           if (optionData > 1) {
                               Ext.Msg.alert("提示", "一次只能质检一条记录！");
                               return;
                           }
                           var record = quotaGrid.getSelectionModel().getSelections()[0].data;
                           if (record.CheckStatus != 0 && record.CheckStatus != '0') {
                               Ext.Msg.alert("提示", "该记录已经进行过质检！");
                               return;

                           }
                           modify_quota_id = record.CheckId;
                           modify_pname = record.ProductName;
                           formulaWindow.show();
                           setformvalue(record);
                           decodeArr(record.CheckId, record.ProductNo, record.CheckType);

                       }
                 }]
              });

                   //修改指标
                   function modifyNodify(rownum) {

                       // alert(quotaGrid.getSelectionModel().getSelections()[selectData - 1].data.QuotaName);

                       formulaWindow.show();
                       var record = quotaGrid.getSelectionModel().getSelections()[0].data;
                       optionTypeCombo.setValue(record.ProductNo);
                       Ext.getCmp('kcl').setValue(record.RepresentAmount);
                       Ext.getCmp('ck').setValue(record.WhName);
                       Ext.getCmp('loc').setValue(record.WhpName);
                       Ext.getCmp('note').setValue(record.Note);
                       Ext.getCmp('realname').setValue(record.ProductName);
                       Ext.getCmp('nocheckno').setValue(record.NocheckNo);
                       ckid = record.Warehose;
                       loc = record.Location;
                       modify_quota_id = record.CheckId;
                   }
                   function deloption(rownum) {
                       var ids = "";
                       var recorddel = quotaGrid.getSelectionModel().getSelections();
                       if (rownum == 1) {
                           ids = recorddel[0].data.CheckId;
                       } else {
                           for (var i = 0; i < rownum; i++) {
                               ids += recorddel[i].data.CheckId + ',';
                           }
                           ids = ids.substring(0, ids.length - 1);
                       }

                       Ext.Ajax.request({
                           url: 'frmQtZJtzd.aspx?method=delzj'
                               , params: {
                                   ids: ids
                               },
                           //成功时回调 
                           success: function(response, options) {
                               //获取响应的json字符串

                               Ext.Msg.alert("提示", "删除成功！");

                               for (var i = 0; i < recorddel.length; i++) {
                                   customerListStore.remove(recorddel[i]);
                               }

                           },
                           failure: function() {
                               Ext.Msg.alert("提示", "删除失败！");
                           }
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
                               url: 'frmQtZJtzd.aspx?method=getckpd'
                           }),
                           // create reader that reads the project records
                           reader: new Ext.data.JsonReader({ root: 'root' }, [
                                { name: 'ProductId', type: 'string' },
                                { name: 'ProductName', type: 'string' },
                                { name: 'RealQty', type: 'string' },
                                { name: 'WhName', type: 'string' },
                                { name: 'WhId', type: 'string' },
                                { name: 'WhpId', type: 'string' },
                                { name: 'WhpName', type: 'string' }
                               ])
                       })
, listeners: {

    select: function(combo, record, index) {
        //Ext.getCmp('realname').setValue(record.data.name);
        // Ext.getCmp('unit').setValue(record.data.unit);
        Ext.getCmp('kcl').setValue(record.data.RealQty);
        Ext.getCmp('ck').setValue(record.data.WhName);
        Ext.getCmp('loc').setValue(record.data.WhpName);
        Ext.getCmp('realname').setValue(record.data.ProductName);
        ckid = record.data.WhId;
        loc = record.data.WhpId;

    }

},
                       valueField: 'ProductId',
                       displayField: 'ProductName',
                       mode: 'local',
                       allowBlank: false,
                       blankText: '选项产品',
                       forceSelection: true,
                       emptyText: '请选项产品',
                       editable: false,
                       triggerAction: 'all',
                       fieldLabel: '产品名称',
                       selectOnFocus: true,
                       anchor: '90%'
                   });



                   if (typeof (formulaWindow) == "undefined") {//解决创建2个windows问题
                       var formulaWindow = new Ext.Window({
                           title: '新增抽样质检',
                           modal: 'true',
                           width: 600,
                           y: 50,
                           autoHeigth: true,
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
                                   savecheck();

                               }
                           }, {
                               text: '关闭',
                               handler: function() {
                                   formulaWindow.hide();
                                   editFmForm.getForm().reset();

                               }
}]
                           });
                       }

                       function savecheck() {

                           var nocheckno = Ext.getCmp("nocheckno").getValue();
                           if (nocheckno == null || nocheckno.trim() == '') {
                               Ext.Msg.alert("提醒", "请输入抽检量！");
                               return;
                           }
                           var note = Ext.getCmp("note").getValue();
                          /* if (nocheckno == null || nocheckno.trim() == '') {
                               Ext.Msg.alert("提醒", "请输入备注！");
                               return;
                           }*/
                           var qurl = 'frmQtZJtzd.aspx?method=saveckpd';

                           if (modify_quota_id != '' && modify_quota_id != null && addmark == 0) {

                               qurl = 'frmQtZJtzd.aspx?method=mofigyzj&checkno=' + modify_quota_id;
                           }

                           Ext.Ajax.request({
                               url: qurl
                               , params: {
                                   pno: optionTypeCombo.getValue(),
                                   pname: Ext.getCmp('realname').getValue(),
                                   note: note,
                                   warehouse: ckid,
                                   loc: loc,
                                   nocheck: nocheckno

                               },
                               //成功时回调 
                               success: function(response, options) {
                                   //获取响应的json字符串

                                   Ext.Msg.alert("提示", "保存成功！");
                                   formulaWindow.hide();
                                   editFmForm.getForm().reset();
                                   queryFormula();
                               },
                               failure: function() {
                                   Ext.Msg.alert("提示", "保存失败！");
                               }
                           });

                       }




                       if (typeof (checkWindow) == "undefined") {//解决创建2个windows问题
                           var checkWindow = new Ext.Window({
                               title: '新增指标',
                               modal: 'true',
                               width: 600,
                               y: 50,
                               autoHeigth: true,
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
                                       secondcheck();
                                   }
                               }, {
                                   text: '关闭',
                                   handler: function() {
                                       checkWindow.hide();
                                       var s = check.getEl().dom.lastChild.lastChild;
                                       var ss = s.childNodes;
                                       var sss = ss.length;
                                       s.removeChild(ss[sss - 1]);
                                   }
}]
                               });
                           }

                           var panel = new Ext.Panel({
                               heigth: 50,
                               html: '<div style="width:100%;text-align:center"> <font size="4"><H1>浙江省盐业集团抽样质检通知单</H1></font><br></div>'
                           });

                           var detail = new Ext.Panel({
                           // html: 'asdada'
                       });

                       var editFmForm = new Ext.form.FormPanel({
                           labelWidth: 80,
                           autoWidth: true,
                           frame: true,
                           autoHeight: true,

                           items: [
                           panel,
	                       {
	                           layout: 'column',
	                           items: [
	                                   {
	                                       columnWidth: .5,
	                                       layout: 'form',
	                                       border: false,
	                                       items: [optionTypeCombo]
	                                   }, {
	                                       columnWidth: .5,
	                                       layout: 'form',
	                                       border: false,
	                                       items: [{
	                                           cls: 'key',
	                                           fieldLabel: '库存量',
	                                           xtype: 'textfield',
	                                           name: 'kcl',
	                                           id: 'kcl',
	                                           anchor: '90%'
}]
	                                       }, {
	                                           cls: 'key',
	                                           fieldLabel: '产品名',
	                                           xtype: 'hidden',
	                                           name: 'realname',
	                                           id: 'realname',
	                                           anchor: '90%'
}]
	                       }
	                                 , {
	                                     layout: 'column',
	                                     items: [
	                                   {
	                                       columnWidth: .5,
	                                       layout: 'form',
	                                       border: false,
	                                       items: [{
	                                           cls: 'key',
	                                           fieldLabel: '仓库',
	                                           xtype: 'textfield',
	                                           name: 'ck',
	                                           id: 'ck',
	                                           anchor: '90%'
}]
	                                       }, {
	                                           columnWidth: .5,
	                                           layout: 'form',
	                                           border: false,
	                                           items: [{
	                                               cls: 'key',
	                                               fieldLabel: '仓位',
	                                               xtype: 'textfield',
	                                               name: 'loc',
	                                               id: 'loc',
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
	                                       items: [{
	                                           cls: 'key',
	                                           fieldLabel: '质检量',
	                                           xtype: 'textfield',
	                                           name: 'nocheckno',
	                                           id: 'nocheckno',
	                                           anchor: '90%'
}]
	                                       }
	                                  ]
	                                 }, {
	                                     layout: 'column',
	                                     items: [
	                                   {
	                                       columnWidth: 1,
	                                       layout: 'form',
	                                       border: false,
	                                       items: [{
	                                           cls: 'key',
	                                           fieldLabel: '备注',
	                                           xtype: 'textarea',
	                                           name: 'note',
	                                           id: 'note',
	                                           anchor: '90%'
}]
	                                       }
	                                  ]
	                                 }
	                                  ]
                       });



                       formulaWindow.add(editFmForm);



                       var quotaTemplate_form = new Ext.form.FormPanel({
                           renderTo: "zjnotify_form",
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
                                       fieldLabel: '产品名称',
                                       name: 'prname',
                                       id: 'prname',
                                       anchor: '90%'
}]
                                   }, {
                                       columnWidth: .25,
                                       labelWidth: 55,
                                       layout: 'form',
                                       border: false,
                                       items: [WhNamePanel]
                                   }
		, {
		    columnWidth: .25,
		    labelWidth: 55,
		    layout: 'form',
		    border: false,
		    items: [WhpNamePanel]
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
		            queryFormula();
		        }
}]
}]
}]
                               });
                               function queryFormula() {
                                   var prname = Ext.getCmp("prname").getValue();
                                   var ck = WhNamePanel.getValue();
                                   var loc = WhpNamePanel.getValue();
                                   
                                   customerListStore.baseParams.start=0;
                                   customerListStore.baseParams.limit=10;
                                   customerListStore.load({
                                       params: {
                                           prname: prname,
                                           ck: ck,
                                           loc: loc
                                       }
                                   })
                               }

                               var customerListStore = new Ext.data.Store
			({
			    url: 'frmQtZJtzd.aspx?method=getcklist',
			    reader: new Ext.data.JsonReader({
			        totalProperty: 'totalProperty',
			        root: 'root'
			    }, [
			    { name: 'CheckId' },
			    { name: 'OrgName' },
	            { name: 'ProductNo' },
	            { name: 'ProductName' },
	            { name: 'RepresentAmount' },
	            { name: 'NocheckNo' },
	            { name: 'WhName' },
	            { name: 'WhpName' },
	            { name: 'Note' },
			    { name: 'CreateDate' }
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
                               var quotaGrid = new Ext.grid.GridPanel({

                                   el: 'zjnotify_grid',
                                   width: '100%',
                                   height: '100%',
                                   autoWidth: true,
                                   autoHeight: true,
                                   autoScroll: true,
                                   layout: 'fit',
                                   id: 'customerdatagrid',
                                   store: customerListStore,
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
                                            {header: '所属公司', dataIndex: 'OrgName' },
									        { header: '产品名称', dataIndex: 'ProductName' },
									        { header: '仓库', dataIndex: 'WhName' },
									        { header: '仓位', dataIndex: 'WhpName' },
									        { header: '库存量', dataIndex: 'RepresentAmount' },
											{ header: '抽检量', dataIndex: 'NocheckNo' },
											{ header: '备注', dataIndex: 'Note' },
											{ header: '创建日期', dataIndex: 'CreateDate' }

			  ]), listeners:
			  {
			      rowselect: function(sm, rowIndex, record) {
			          //alert(1);
			          //Ext.MessageBox.alert("提示", "您选择的出版号是：" + record.data.FormulaNo);
			      },
			      rowclick: function(grid, rowIndex, e) {

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
                                       store: customerListStore,
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
                               quotaGrid.render();

                           }); 
		
	</script>
</html>
