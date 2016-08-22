<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmQtQualityTemplateCfg.aspx.cs" Inherits="QT_frmQtQualityTemplateCfg" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=GB2312">
    <link rel="stylesheet" type="text/css" href="../ext3/resources/css/ext-all.css" />
	<script type="text/javascript" src="../ext3/adapter/ext/ext-base.js"></script>	
	<script type="text/javascript" src="../ext3/ext-all.js"></script>

</head>
<body>
	<div id="quotaTemplate_toolbar"></div>
	 <div id="quotaTemplate_form"></div>
	 <div id="quotaTemplate_grid"></div>
</body><script>

           var quotaCount;
           var quotaArr = new Array();
           var addmark = 0;
           var quotaIdArr = null;
           var quotaIdstr = '';
           var modify_quota_template_id = "";
           Ext.BLANK_IMAGE_URL = "../ext3/resources/images/default/s.gif"; 
           Ext.onReady(function() {
               var Toolbar = new Ext.Toolbar({
                   renderTo: "quotaTemplate_toolbar",
                   items: [{
                       text: "新增",
                       icon: '../Theme/1/images/extjs/customer/add16.gif',
                       handler: function() {
                           // saveType = "add";
                           // openAddQuotaWin();//点击后，弹出添加信息窗口
                           addmark = 1;
                           quotaTemplateWindow.show();
                       }
                   }, '-', {
                       text: "修改",
                       icon: '../Theme/1/images/extjs/customer/edit16.gif',
                       handler: function() {

                           var selectData = quotaTemplateGrid.getSelectionModel().getCount();
                           if (selectData == 0) {
                               Ext.Msg.alert("提示", "请选中要修改的记录！");
                               return;
                           }
                           if (selectData > 1) {
                               Ext.Msg.alert("提示", "一次只能修改一条记录！");
                               return;
                           }
                           addmark = 0;
                           modifyQuotaTemplate(selectData);
                           // modifyQuotaTemplate(selectData);
                       }
                   }, '-', {
                       text: "删除",
                       icon: '../Theme/1/images/extjs/customer/delete16.gif',
                       handler: function() {
                           var selectData = quotaTemplateGrid.getSelectionModel().getCount();
                           if (selectData == 0) {
                               Ext.Msg.alert("提示", "请选中要删除的行！");
                               return;
                           }
                           delQuotaTemplate(selectData);
                       }
}]
                   });
                   if (typeof (quotaTemplateWindow) == "undefined") {//解决创建2个windows问题
                       var quotaTemplateWindow = new Ext.Window({
                           title: '新增指标模板',
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
                                   addNewTemplate();
                                   //quotaTemplateWindow.hide();
                               }
                           }, {
                               text: '关闭',
                               handler: function() {
                                   quotaTemplateWindow.hide();
                                   addQuotaTamplateForm.getForm().reset();
                               }
}]
                           });
                       }

                       var addQuotaTamplateForm = new Ext.form.FormPanel({
                           frame: true,
                           monitorValid: true, // 把有formBind:true的按钮和验证绑定
                           labelWidth: 80,
                           items: [
                           {

                               layout: 'form',
                               xtype: "fieldset",
                               title: '添加指标模板',

                               items: [{
                                   layout: 'form',
                                   columnWidth: 1,  //该列占用的宽度，标识为20％
                                   border: false,
                                   items: [ {
                                       cls: 'key',
                                       xtype: 'textfield',
                                       fieldLabel: '模板名称',
                                       name: 'Template_Name',
                                       id: 'Template_Name',
                                       anchor: '98%'
                                   }, {
                                       cls: 'key',
                                       xtype: 'textfield',
                                       fieldLabel: '备注',
                                       name: 'Note',
                                       id: 'Note',
                                       anchor: '98%'
}]
}]
                                   }, {
                                       cls: 'key',
                                       fieldLabel: '检验指标项',
                                       anchor: '98%'
}]

                                   });

                                   Ext.Ajax.request({
                                       url: 'frmQtQualityTemplateCfg.aspx?method=getQuota'
                                       , params: {},
                                       //成功时回调 
                                       success: function(response, options) {
                                           //获取响应的json字符串

                                           if (response != null && response.responseText != 'undefined' && response.responseText != null && response.responseText != '') {
                                               var data = Ext.util.JSON.decode(response.responseText);
                                               var panelstr = "new Ext.Panel({labelWidth: 30,autoWidth: true,autoHeight: true,layout: 'column', items: [";


                                               quotaCount = data.length;
                                               for (var i = 0; i < quotaCount; i++) {
                                                   quotaArr[i] = data[i].QuotaNo;

                                                   //    addQuotaForm.items.add(eval("quotaCheckBox" + i + "= new Ext.form.Checkbox({cls:'key',value:'" + data[i].QuotaNo + "',boxLabel:'" + data[i].QuotaName + " " + data[i].QuotaUnit + "',name: '" + data[i].QuotaNo + "', id: 'quotaCheckBox" + i + "',anchor: '90%'});"));
                                                   panelstr += " {style: 'align:left',columnWidth: .33,layout: 'form',border: false,items: [{cls: 'key', value:'" + data[i].QuotaNo + "' ,xtype: 'checkbox',boxLabel: '" + data[i].QuotaName + " " + data[i].QuotaUnit + "',name: '" + data[i].QuotaNo + "',id: '" + data[i].QuotaNo + "',anchor: '90%'}]},";
                                               }
                                               panelstr = panelstr.substring(0, panelstr.length - 1);
                                               panelstr += "]})";

                                               addQuotaTamplateForm.add(eval(panelstr));
                                           }

                                       },
                                       failure: function() {
                                           Ext.Msg.alert("提示", "获取指标配置项出错,请重新打开该页！");
                                       }
                                   });

                                   quotaTemplateWindow.add(addQuotaTamplateForm);


                                   function addNewTemplate() {

                                       /*   var company = company.getValue();
                                       if (company == null || company.trim() == '' || company == 'undefined') {
                                       Ext.Msg.alert("提醒", "请选择公司！");
                                       return;
                                       }*/

                                       var tempName = Ext.getCmp("Template_Name").getValue();
                                       if (tempName == null || tempName.trim() == '') {
                                           Ext.Msg.alert("提醒", "模板名称不能为空！");
                                           return;
                                       }
                                       var Note = Ext.getCmp("Note").getValue();
                                       /*if (Note == null || Note.trim() == '') {
                                           Ext.Msg.alert("提醒", "备注不能为空！");
                                           return;
                                       }*/
                                       var tempIds = "";
                                       var idmark = 0;
                                       var delstr = '';
                                       var addstr = '';
                                       for (var y = 0; y < quotaCount; y++) {
                                           if (Ext.get(quotaArr[y]).dom.checked) {
                                               tempIds += Ext.getCmp(quotaArr[y]).name + ',';
                                               idmark++;
                                           }

                                       }
                                       if (idmark == 0) {
                                           Ext.Msg.alert("提示", "请至少选择一个指标配置项！");
                                           return;
                                       }
                                       var compareStr = "," + tempIds
                                       tempIds = tempIds.substring(0, tempIds.length - 1);
                                       var compareArr = tempIds.split(",");

                                       if (modify_quota_template_id != '' && modify_quota_template_id != null && addmark == 0) {

                                           for (var t = 0; t < quotaIdArr.length; t++) {
                                               var indexof = compareStr.indexOf(',' + quotaIdArr[t] + ',');
                                               if (indexof < 0) {
                                                   delstr += quotaIdArr[t] + ',';
                                               }
                                           }
                                           if (delstr.length > 1) {
                                               delstr = delstr.substring(0, delstr.length - 1);
                                           }

                                           for (var r = 0; r < compareArr.length; r++) {
                                               var indexof = quotaIdstr.indexOf(',' + compareArr[r] + ',');

                                               if (indexof < 0) {
                                                   addstr += compareArr[r] + ',';
                                               }
                                           }
                                           if (addstr.length > 1) {
                                               addstr = addstr.substring(0, addstr.length - 1);
                                           }

                                           Ext.Ajax.request({
                                           url: 'frmQtQualityTemplateCfg.aspx?method=modifyQuotaTemplate&code=Q032'
                                          , params: {
                                              tempName: tempName,
                                              templateno: modify_quota_template_id,
                                              note: Note,
                                              delstr: delstr,
                                              addstr: addstr
                                          },
                                               //成功时回调 
                                               success: function(response, options) {
                                                   //获取响应的json字符串

                                                   Ext.Msg.alert("提示", "修改成功！");
                                                   quotaTemplateWindow.hide();
                                                   addQuotaTamplateForm.getForm().reset();
                                                   var serchQuotaTemplateName = Ext.getCmp("serchQuotaTemplateName").getValue();
                                                   
                                                   quotaTemplateStore.baseParams.start=0;
                                                   quotaTemplateStore.baseParams.limit=10;
                                                   quotaTemplateStore.load({
                                                       params: {
                                                           key: serchQuotaTemplateName
                                                       }
                                                   })
                                               },
                                               failure: function() {
                                                   Ext.Msg.alert("提示", "获取指标配置项出错,请重新打开该页！");
                                               }
                                           });



                                       } else {

                                           Ext.Ajax.request({
                                               url: 'frmQtQualityTemplateCfg.aspx?method=addQuotaTemplate'
                                       , params: {
                                           tempName: tempName,
                                           note: Note,
                                           ids: tempIds
                                       },
                                               //成功时回调 
                                               success: function(response, options) {
                                                   //获取响应的json字符串

                                                   Ext.Msg.alert("提示", "保存成功！");
                                                   quotaTemplateWindow.hide();
                                                   addQuotaTamplateForm.getForm().reset();
                                                   var serchQuotaTemplateName = Ext.getCmp("serchQuotaTemplateName").getValue();
                                                   
                                                   quotaTemplateStore.baseParams.start=0;
                                                   quotaTemplateStore.baseParams.limit=10;
                                                   quotaTemplateStore.load({
                                                       params: {
                                                           key: serchQuotaTemplateName
                                                       }
                                                   })
                                               },
                                               failure: function() {
                                                   Ext.Msg.alert("提示", "获取指标配置项出错,请重新打开该页！");
                                               }
                                           });
                                       }
                                   }

                                   var quotaTemplate_form = new Ext.form.FormPanel({
                                       renderTo: "quotaTemplate_form",
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
                                                   fieldLabel: '模板名称',
                                                   name: 'serchQuotaTemplateName',
                                                   id: 'serchQuotaTemplateName',
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
		            queryTemplate();
		        }
}]
}]
}]
                                           });

                                           function queryTemplate() {
                                               var serchQuotaTemplateName = Ext.getCmp("serchQuotaTemplateName").getValue();
                                               
                                               quotaTemplateStore.baseParams.start=0;
                                               quotaTemplateStore.baseParams.limit=10;
                                               quotaTemplateStore.load({
                                                   params: {
                                                       key: serchQuotaTemplateName
                                                   }
                                               })
                                           }

                                           var quotaTemplateStore = new Ext.data.Store
			({
                                           url: 'frmQtQualityTemplateCfg.aspx?method=getTemplateList&code=Q032',
			    reader: new Ext.data.JsonReader({
			        totalProperty: 'totalProperty',
			        root: 'root'
			    }, [
			    { name: 'TemplateNo' },
			    { name: 'OrgName' },
	            { name: 'TemplateName' },
			    { name: 'Note' },
	            { name: 'EmpName' },
	            { name: 'CreateDate' }
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
                                           var quotaTemplateGrid = new Ext.grid.GridPanel({
                                               el: 'quotaTemplate_grid',
                                               width: '100%',
                                               height: '100%',
                                               autoWidth: true,
                                               autoHeight: true,
                                               autoScroll: true,
                                               layout: 'fit',
                                               id: 'quotaTemplateGrid',
                                               store: quotaTemplateStore,
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
                                            {header: '模板id', hidden: true, dataIndex: 'TemplateNo' },
									        { header: '公司名称', dataIndex: 'OrgName' },
									        { header: '模板名称', dataIndex: 'TemplateName' },
											{ header: '备注', dataIndex: 'Note' }, 
											{ header: '操作人', dataIndex: 'EmpName' },
											{ header: '操作时间', dataIndex: 'CreateDate' }
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
                                                   store: quotaTemplateStore,
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
                                           quotaTemplateGrid.render();




                                           function delQuotaTemplate(rownum) {
                                               var ids = "";
                                               var recorddel = quotaTemplateGrid.getSelectionModel().getSelections();
                                               if (rownum == 1) {
                                                   ids = recorddel[0].data.TemplateNo;
                                               } else {
                                                   for (var i = 0; i < rownum; i++) {
                                                       ids += recorddel[i].data.TemplateNo + ',';
                                                   }
                                                   ids = ids.substring(0, ids.length - 1);
                                               }

                                               Ext.Ajax.request({
                                                   url: 'frmQtQualityTemplateCfg.aspx?method=delQuotaTemplate'
                                               , params: {
                                                   ids: ids
                                               },
                                                   //成功时回调 
                                                   success: function(response, options) {
                                                       //获取响应的json字符串

                                                       Ext.Msg.alert("提示", "删除成功！");

                                                       for (var i = 0; i < recorddel.length; i++) {
                                                           quotaTemplateStore.remove(recorddel[i]);
                                                       }


                                                   },
                                                   failure: function() {
                                                       Ext.Msg.alert("提示", "删除失败！");
                                                   }
                                               });
                                           }



                                           function modifyQuotaTemplate(rownum) {

                                               // alert(quotaGrid.getSelectionModel().getSelections()[selectData - 1].data.QuotaName);

                                               quotaTemplateWindow.show();
                                               var record = quotaTemplateGrid.getSelectionModel().getSelections()[rownum - 1].data;
                                               Ext.getCmp("Template_Name").setValue(record.TemplateName);
                                               Ext.getCmp("Note").setValue(record.Note);
                                               modify_quota_template_id = record.TemplateNo;
                                               Ext.Ajax.request({
                                                   url: 'frmQtQualityTemplateCfg.aspx?method=getTemplateDetail'
                                               , params: {
                                                   templateno: modify_quota_template_id
                                               },
                                                   //成功时回调
                                                   success: function(response, options) {
                                                       quotaIdArr = null;
                                                       quotaIdArr = '';
                                                       quotaIdstr = response.responseText;
                                                       quotaIdArr = (quotaIdstr.substring(1, quotaIdstr.length - 1)).split(",");
                                                       for (var z = 0; z < quotaIdArr.length; z++) {

                                                           Ext.get(quotaIdArr[z]).dom.checked = true

                                                       }
                                                   },
                                                   failure: function() {
                                                       Ext.Msg.alert("提示", "获取模板详细信息失败！");
                                                   }
                                               });
                                           }

                                       }); 
		
	</script>
</html>
