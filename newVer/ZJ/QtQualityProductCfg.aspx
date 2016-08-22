<%@ Page Language="C#" AutoEventWireup="true" CodeFile="QtQualityProductCfg.aspx.cs" Inherits="QT_QtQualityProductCfg" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=GB2312">
    <link rel="stylesheet" type="text/css" href="../ext3/resources/css/ext-all.css" />
	<script type="text/javascript" src="../ext3/adapter/ext/ext-base.js"></script>	
	<script type="text/javascript" src="../ext3/ext-all.js"></script>
</head>
<body>
	 <div id="formula_toolbar"></div>
	 <div id="formula_form"></div>
	 <div id="formula_grid"></div>
</body><script>
           var modify_quota_id = 'none';
           var addmark = 0;
           BLANK_IMAGE_URL = "../ext3/resources/images/default/s.gif"; 
           Ext.onReady(function() {
               var Toolbar = new Ext.Toolbar({
                   renderTo: "formula_toolbar",
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
                           modifyQuota(selectData);

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
                           delQuota(selectData);

                       }
}]
                   });



                   function delQuota(rownum) {
                       var ids = "";
                       var recorddel = quotaGrid.getSelectionModel().getSelections();
                       if (rownum == 1) {
                           ids = recorddel[0].data.StandardNo;
                       } else {
                           for (var i = 0; i < rownum; i++) {
                               ids += recorddel[i].data.StandardNo + ',';
                           }
                           ids = ids.substring(0, ids.length - 1);
                       }

                       Ext.Ajax.request({
                           url: 'frmQtQuotaStandardCfg.aspx?method=delStandard'
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


                   if (typeof (formulaWindow) == "undefined") {//解决创建2个windows问题
                       var formulaWindow = new Ext.Window({
                           title: '标准合格模板配置',
                           modal: 'true',
                           width: 600,
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
                                   addFormula();

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


                       var addCompanyCombo = new Ext.form.ComboBox({
                           xtype: 'combo',
                           store: new Ext.data.Store({
                               autoLoad: true,
                               baseParams: {
                                   trancode: 'Menu'
                               },
                               proxy: new Ext.data.HttpProxy({
                                   //  url: 'frmQtQuotaItemCfg.aspx?method=getType&key=Quota'
                                   url: ''
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
                           // blankText : '指标类型不能为空', 
                           forceSelection: true,
                           emptyText: '请选择公司',
                           hiddenName: 'pid',
                           editable: false,
                           triggerAction: 'all',
                           fieldLabel: '公司名称',
                           selectOnFocus: true,
                           //value:record.get("pid"),
                           anchor: '50%'

                       });
                       var serchCompanyCombo = new Ext.form.ComboBox({
                           xtype: 'combo',
                           store: new Ext.data.Store({
                               autoLoad: true,
                               baseParams: {
                                   trancode: 'Menu'
                               },
                               proxy: new Ext.data.HttpProxy({
                               //  url: 'frmQtQuotaItemCfg.aspx?method=getType&key=Quota'

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
                       // blankText : '指标类型不能为空', 
                       forceSelection: true,
                       emptyText: '请选择公司',
                       hiddenName: 'pid',
                       editable: false,
                       triggerAction: 'all',
                       fieldLabel: '公司名称',
                       selectOnFocus: true,
                       //value:record.get("pid"),
                       anchor: '90%'

                   });


                   var jyzbCom = new Ext.form.ComboBox({
                       xtype: 'combo',
                       store: new Ext.data.Store({
                           autoLoad: true,
                           baseParams: {
                               trancode: 'Menu'
                           },
                           proxy: new Ext.data.HttpProxy({
                               url: 'frmQtQualityTemplateCfg.aspx?method=getTemplateList&forcom=yes&code=Q032'

                           }),
                           // create reader that reads the project records
                           reader: new Ext.data.JsonReader({ root: 'root' }, [
                                { name: 'TemplateName', type: 'string' },
                                { name: 'TemplateNo', type: 'string' }

                               ])
                       })
,
                       valueField: 'TemplateNo',
                       displayField: 'TemplateName',
                       mode: 'local',
                       allowBlank: false,
                       // blankText : '指标类型不能为空', 
                       forceSelection: true,
                       emptyText: '请选择模板',
                       hiddenName: 'jyzbCom',
                       editable: false,
                       triggerAction: 'all',
                       fieldLabel: '检验指标模板',
                       selectOnFocus: true,
                       //value:record.get("pid"),
                       anchor: '90%'

                   });
                   var jbpdCom = new Ext.form.ComboBox({
                       xtype: 'combo',
                       store: new Ext.data.Store({
                           autoLoad: true,
                           baseParams: {
                               trancode: 'Menu'
                           },
                           proxy: new Ext.data.HttpProxy({
                               url: 'frmQtQualityTemplateCfg.aspx?method=getTemplateList&forcom=yes&code=Q035'

                           }),
                           // create reader that reads the project records
                           reader: new Ext.data.JsonReader({ root: 'root' }, [
                              { name: 'TemplateName', type: 'string' },
                                { name: 'TemplateNo', type: 'string' }

                               ])
                       })
,
                       valueField: 'TemplateNo',
                       displayField: 'TemplateName',
                       mode: 'local',
                       allowBlank: false,
                       // blankText : '指标类型不能为空', 
                       forceSelection: true,
                       emptyText: '请选择模板',
                       hiddenName: 'jbpdCom',
                       editable: false,
                       triggerAction: 'all',
                       fieldLabel: '级别判定模板',
                       selectOnFocus: true,
                       //value:record.get("pid"),
                       anchor: '90%'

                   });

                   var jsgsCom = new Ext.form.ComboBox({
                       xtype: 'combo',
                       store: new Ext.data.Store({
                           autoLoad: true,
                           baseParams: {
                               trancode: 'Menu'
                           },
                           proxy: new Ext.data.HttpProxy({
                               //  url: 'frmQtQuotaItemCfg.aspx?method=getType&key=Quota'
                               url: 'frmQtQualityTemplateCfg.aspx?method=getTemplateList&forcom=yes&code=Q034'
                           }),
                           // create reader that reads the project records
                           reader: new Ext.data.JsonReader({ root: 'root' }, [
                                { name: 'TemplateName', type: 'string' },
                                { name: 'TemplateNo', type: 'string' }

                               ])
                       })
,
                       valueField: 'TemplateNo',
                       displayField: 'TemplateName',
                       mode: 'local',
                       allowBlank: false,
                       // blankText : '指标类型不能为空', 
                       forceSelection: true,
                       emptyText: '请选择模板',
                       hiddenName: 'jsgsCom',
                       editable: false,
                       triggerAction: 'all',
                       fieldLabel: '计算公式模板',
                       selectOnFocus: true,
                       //value:record.get("pid"),
                       anchor: '90%'

                   });


                   var cyComb = new Ext.form.ComboBox({
                       xtype: 'combo',
                       store: new Ext.data.Store({
                           autoLoad: true,
                           baseParams: {
                               trancode: 'Menu'
                           },
                           proxy: new Ext.data.HttpProxy({
                               url: 'frmQtOtherOptionCfg.aspx?method=queryByCode&code=Q041'
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
                       id: 'cyCombo',
                       //pageSize: 5,
                       //minChars: 2,
                       //hideTrigger: true,
                       fieldLabel: '抽样方法',
                       typeAhead: true,
                       mode: 'local',
                       emptyText: '',
                       selectOnFocus: false,
                       editable: true,
                       anchor: '50%'
                   });
                   var jyComb = new Ext.form.ComboBox({
                       xtype: 'combo',
                       store: new Ext.data.Store({
                           autoLoad: true,
                           baseParams: {
                               trancode: 'Menu'
                           },
                           proxy: new Ext.data.HttpProxy({
                               url: 'frmQtOtherOptionCfg.aspx?method=queryByCode&code=Q042'
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
                       id: 'jyCombo',
                       //pageSize: 5,
                       //minChars: 2,
                       //hideTrigger: true,
                       fieldLabel: '检验标准',
                       typeAhead: true,
                       mode: 'local',
                       emptyText: '',
                       selectOnFocus: false,
                       editable: true,
                       anchor: '50%'
                   });
                   var pdComb = new Ext.form.ComboBox({
                       xtype: 'combo',
                       store: new Ext.data.Store({
                           autoLoad: true,
                           baseParams: {
                               trancode: 'Menu'
                           },
                           proxy: new Ext.data.HttpProxy({
                               url: 'frmQtOtherOptionCfg.aspx?method=queryByCode&code=Q043'
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
                       id: 'pdComb',
                       //pageSize: 5,
                       //minChars: 2,
                       //hideTrigger: true,
                       fieldLabel: '判断标准',
                       typeAhead: true,
                       mode: 'local',
                       emptyText: '',
                       selectOnFocus: false,
                       editable: true,
                       anchor: '50%'
                   });

                   var yqComb = new Ext.form.ComboBox({
                       xtype: 'combo',
                       store: new Ext.data.Store({
                           autoLoad: true,
                           baseParams: {
                               trancode: 'Menu'
                           },
                           proxy: new Ext.data.HttpProxy({
                               url: 'frmQtOtherOptionCfg.aspx?method=getOption&key=Machine'
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
                       id: 'yqCombo',
                       //pageSize: 5,
                       //minChars: 2,
                       //hideTrigger: true,
                       fieldLabel: '仪器设备',
                       typeAhead: true,
                       mode: 'local',
                       emptyText: '',
                       selectOnFocus: false,
                       editable: true,
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


                   var placeComb = new Ext.form.ComboBox({
                       xtype: 'combo',
                       store: new Ext.data.Store({
                           autoLoad: true,
                           baseParams: {
                               trancode: 'Menu'
                           },
                           proxy: new Ext.data.HttpProxy({
                               url: 'frmQtOtherOptionCfg.aspx?method=getOption&key=Place'
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
                       id: 'placeComb',
                       //pageSize: 5,
                       //minChars: 2,
                       //hideTrigger: true,
                       fieldLabel: '产地',
                       typeAhead: true,
                       mode: 'local',
                       emptyText: '',
                       selectOnFocus: false,
                       editable: true,
                       anchor: '90%'
                   });



                   function cmbType(val) {
                       var index = placeComb.getStore().find('id', val);
                       if (index < 0)
                           return "";
                       var record = placeComb.getStore().getAt(index);
                       return record.data.DicsName;
                   }

                   var soltComb = new Ext.form.ComboBox({
                       xtype: 'combo',
                       store: new Ext.data.Store({
                           autoLoad: true,
                           baseParams: {
                               trancode: 'Menu'
                           },
                           proxy: new Ext.data.HttpProxy({
                               url: 'QtQualityProductCfg.aspx?method=getallSolt'
                           }),
                           // create reader that reads the project records
                           reader: new Ext.data.JsonReader({ root: 'root' }, [
                                { name: 'ClassName', type: 'string' },
                                { name: 'ClassId', type: 'string' }
                        ])
                       }),
                       displayField: 'ClassName',
                       valueField: 'ClassId',
                       triggerAction: 'all',
                       id: 'soltComb',
                       //pageSize: 5,
                       //minChars: 2,
                       //hideTrigger: true,
                       fieldLabel: '盐类型',
                       typeAhead: true,
                       mode: 'local',
                       emptyText: '',
                       selectOnFocus: false,
                       editable: true,
                       anchor: '50%'
                   });

                   function addFormula() {
                       var pname = Ext.getCmp("ProductName").getValue();
                       if (pname == null || pname.trim() == '') {
                           Ext.Msg.alert("提醒", "产品名称不能为空！");
                           return;
                       }
                       var ProductClassid = Ext.getCmp("ProductClassid").getValue();
                       if (ProductClassid == null || ProductClassid.trim() == '') {
                           Ext.Msg.alert("提醒", "请选择产品！");
                           return;
                       }

                       var pno = Ext.getCmp("pno").getValue();
                       if (pno == null || pno.trim() == '') {
                           Ext.Msg.alert("提醒", "样品编号不能为空！");
                           return;
                       }
                       var qtname = Ext.getCmp("qtname").getValue();
                       if (qtname == null || qtname.trim() == '') {
                           Ext.Msg.alert("提醒", "产品质检名不能为空！");
                           return;
                       }
                       var standar = Ext.getCmp("standar").getValue();
                       if (standar == null || standar.trim() == '') {
                           Ext.Msg.alert("提醒", "规格不能为空！");
                           return;
                       }
                       var note = Ext.getCmp("note").getValue();
                       if (note == null || note.trim() == '') {
                           Ext.Msg.alert("提醒", "备注不能为空！");
                           return;
                       }

                       var solt = soltComb.getValue();
                       if (solt == null || solt == 'undefined' || solt == '') {

                           Ext.Msg.alert("提示", "请选择盐类型！");
                           return;
                       }
                       var place = placeComb.getValue();
                       if (place == null || place == 'undefined' || place == '') {

                           Ext.Msg.alert("提示", "请选择产地！");
                           return;
                       }
                       var cy = cyComb.getValue();
                       if (cy == null || cy == 'undefined' || cy == '') {

                           Ext.Msg.alert("提示", "请选择抽样方法！");
                           return;
                       }
                       var jy = jyComb.getValue();
                       if (jy == null || jy == 'undefined' || jy == '') {

                           Ext.Msg.alert("提示", "请选择检验标准！");
                           return;
                       }
                       var pd = pdComb.getValue();
                       if (pd == null || pd == 'undefined' || pd == '') {

                           Ext.Msg.alert("提示", "请选择判断标准！");
                           return;
                       }
                       var yq = yqComb.getValue();
                       if (yq == null || yq == 'undefined' || yq == '') {

                           Ext.Msg.alert("提示", "请选择仪器设备！");
                           return;
                       }
                       var jbpd = jbpdCom.getValue();
                       if (jbpd == null || jbpd == 'undefined' || jbpd == '') {

                           Ext.Msg.alert("提示", "请选择级别判定模板！");
                           return;
                       }
                       var jyzb = jyzbCom.getValue();
                       if (jyzb == null || jyzb == 'undefined' || jyzb == '') {

                           Ext.Msg.alert("提示", "请选择检验指标模板！");
                           return;
                       }
                       var jsgs = jsgsCom.getValue();
                       if (jsgs == null || jsgs == 'undefined' || jsgs == '') {

                           Ext.Msg.alert("提示", "请选择计算公式模板！");
                           return;
                       }

                       var zjlb = zjlbComb.getValue();
                       if (zjlb == null || zjlb == 'undefined' || zjlb == '') {

                           Ext.Msg.alert("提示", "请选择质检类别！");
                           return;
                       }

                       var qurl = 'QtQualityProductCfg.aspx?method=addProd';
                       if (modify_quota_id != '' && modify_quota_id != null && addmark == 0) {
                           qurl = 'frmQtQuotaStandardCfg.aspx?method=updateStandard&configno=' + modify_quota_id;
                       }
                       Ext.Ajax.request({
                           url: qurl
                               , params: {
                                   CheckType: zjlb
                               , ProductNo: pno
                               , ProductName: pname
                               , ProductClassid: ProductClassid
                               , Standards: standar
                               , Originplace: place
                               , ClassId: solt
                               , CheckName: qtname
                               , SamplingNo: cy
                               , CheckNo: jy
                               , StandardNo: pd
                               , DeviceNo: yq
                               , STemplateNo: jbpd
                               , QTemplateNo: jyzb
                               , FTemplateNo: jsgs
                               , Note: note

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
                   //修改指标
                   function modifyQuota(rownum) {
                       // alert(quotaGrid.getSelectionModel().getSelections()[selectData - 1].data.QuotaName);
                       formulaWindow.show();
                       var record = quotaGrid.getSelectionModel().getSelections()[rownum - 1].data;
                       Ext.getCmp("ProductName").setValue(record.ProductName);
                       Ext.getCmp("pno").setValue(record.ProductNo);
                       Ext.getCmp("qtname").setValue(record.CheckName);
                       Ext.getCmp("standar").setValue(record.Standards);
                       Ext.getCmp("note").setValue(record.Note);
                       soltComb.setValue(record.ClassId);
                       placeComb.setValue(record.Originplace);
                       cyComb.setValue(record.SamplingNo);
                       jyComb.setValue(record.CheckNo);
                       pdComb.setValue(record.StandardNo);
                       yqComb.setValue(record.DeviceNo);
                       jbpdCom.setValue(record.STemplateNo);
                       jyzbCom.setValue(record.QTemplateNo);
                       jsgsCom.setValue(record.FTemplateNo);
                       zjlbComb.setValue(record.CheckType);
                       modify_quota_id = record.ConfigNo;

                   }
                   var editFmForm = new Ext.form.FormPanel({
                       labelWidth: 100,
                       autoWidth: true,
                       frame: true,
                       autoHeight: true,

                       items: [
                           addCompanyCombo, zjlbComb,
  {
      layout: 'column',
      columnWidth: .1,
      layout: 'form',
      border: false,
      items: [
	                                   {
	                                       layout: 'form',
	                                       border: false,
	                                       columnWidth: .34,
	                                       items: [
		    {
		        xtype: 'textfield',
		        fieldLabel: '采购商品类别',
		        anchor: '90%',
		        name: 'ClassType',
		        id: 'ClassType'
		    },
	        {
	            xtype: 'hidden',
	            fieldLabel: '采购商品类别ID',
	            name: 'haddenClassType',
	            id: 'haddenClassType'

}]
}]
  }, {
      layout: 'column',
      items: [
	                                   {
	                                       columnWidth: .5,
	                                       layout: 'form',
	                                       border: false,
	                                       items: [{
	                                           cls: 'key',
	                                           xtype: 'textfield',
	                                           fieldLabel: '样品编号',
	                                           name: 'pno',
	                                           id: 'pno',
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
	                                           xtype: 'textfield',
	                                           fieldLabel: '产品质检名',
	                                           name: 'qtname',
	                                           id: 'qtname',
	                                           anchor: '90%'
}]
	                                       }
	                                  ]
  },


    soltComb,

  {
      layout: 'column',
      items: [
	                                   {
	                                       columnWidth: .5,
	                                       layout: 'form',
	                                       border: false,
	                                       items: [{
	                                           cls: 'key',
	                                           xtype: 'textfield',
	                                           fieldLabel: '规格',
	                                           name: 'standar',
	                                           id: 'standar',
	                                           anchor: '90%'
}]
	                                       }
	                                  ]
  },
                           placeComb,
	                                 cyComb, jyComb, pdComb, yqComb, jbpdCom, jyzbCom, jsgsCom,

	                                 {
	                                     layout: 'column',
	                                     items: [{
	                                         columnWidth: 1,
	                                         layout: 'form',
	                                         border: false,
	                                         items: [{
	                                             cls: 'key',
	                                             xtype: 'textarea',
	                                             fieldLabel: '备注',
	                                             name: 'note',
	                                             id: 'note',
	                                             anchor: '90%'
}]
	                                         }
	                                  ]
	                                     }
	                                ]
                   });

                   function addToFum(str) {
                       var fum = Ext.getCmp('fum').getValue();
                       fum += str;
                       Ext.getCmp('fum').setValue(fum);
                   }
                   formulaWindow.add(editFmForm);





                   var quotaTemplate_form = new Ext.form.FormPanel({
                       renderTo: "formula_form",
                       frame: true,
                       monitorValid: true, // 把有formBind:true的按钮和验证绑定
                       layout: "form",
                       labelWidth: 120,
                       items: [{
                           layout: 'column',   //定义该元素为布局为列布局方式
                           border: false,
                           labelSeparator: '：',
                           items: [{
                               columnWidth: .2,
                               layout: 'form',
                               border: false,
                               items: [{
                                   cls: 'key',
                                   xtype: 'textfield',
                                   fieldLabel: '产品名称',
                                   name: 'spname',
                                   id: 'spname',
                                   anchor: '90%'
}]
                               }, {
                                   columnWidth: .2,
                                   layout: 'form',
                                   border: false,
                                   items: [{
                                       cls: 'key',
                                       xtype: 'textfield',
                                       fieldLabel: '样品编号',
                                       name: 'spno',
                                       id: 'spno',
                                       anchor: '90%'
}]
                                   }, {
                                       columnWidth: .2,
                                       layout: 'form',
                                       border: false,
                                       items: [{
                                           cls: 'key',
                                           xtype: 'textfield',
                                           fieldLabel: '质检名称',
                                           name: 'scname',
                                           id: 'scname',
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
		            queryFormula();
		        }
}]
}]
}]
                                   });
                                   function queryFormula() {
                                       var pname = Ext.getCmp("spname").getValue();
                                       var pno = Ext.getCmp("spno").getValue();
                                       var cname = Ext.getCmp("scname").getValue();
                                       
                                       customerListStore.baseParams.start=0;
                                       customerListStore.baseParams.limit=10;
                                       customerListStore.load({
                                           params: {
                                               pname: pname
                                               , pno: pno
                                               , cname: cname
                                           }
                                       })
                                   }

                                   var customerListStore = new Ext.data.Store
			({
			    url: 'QtQualityProductCfg.aspx?method=queryProduct',
			    reader: new Ext.data.JsonReader({
			        totalProperty: 'totalProperty',
			        root: 'root'
			    }, [
			    { name: 'ConfigNo' },
			    { name: 'OrgId' },
			    { name: 'CheckType' },
			    { name: 'ProductNo' },
			    { name: 'ProductClassid' },
			    { name: 'ProductName' },
	            { name: 'Standards' },
			    { name: 'Originplace' },
	            { name: 'ClassId' },
	            { name: 'CheckName' },
	            { name: 'SamplingNo' },
	            { name: 'CheckNo' },
	            { name: 'StandardNo' },
	            { name: 'DeviceNo' },
	            { name: 'STemplateNo' },
	            { name: 'QTemplateNo' },
			    { name: 'FTemplateNo' },
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
                                   var quotaGrid = new Ext.grid.GridPanel({

                                       el: 'formula_grid',
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


                                            {header: '合格标准号', hidden: true, dataIndex: 'ConfigNo' },
                                            { header: '所属公司', dataIndex: 'OrgId' },
                                            { header: '样品编号', dataIndex: 'ProductNo' },
                                            { header: '质检名称', dataIndex: 'CheckName' },
                                            { header: '产品名称', dataIndex: 'ProductName' },
									        { header: '规格', dataIndex: 'Standards' },
									        { header: '产地', dataIndex: 'Originplace', renderer: cmbType },
									        { header: '备注', dataIndex: 'Note' }

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


                                   dsSmallProduct = new Ext.data.Store({
                                       url: 'frmBaProduct.aspx?method=getSmallClasses',
                                       reader: new Ext.data.JsonReader({
                                           root: 'root',
                                           totalProperty: 'totalProperty',
                                           id: 'searchSamllProductId'
                                       }, [
                        { name: 'ClassId', mapping: 'ClassId' },
                        { name: 'ClassName', mapping: 'ClassName' }
                    ])
                                   });
                                   var searchSmallClass = new Ext.form.ComboBox({
                                       store: dsSmallProduct,
                                       displayField: 'ClassName',
                                       displayValue: 'ClassId',
                                       typeAhead: false,
                                       minChars: 1,
                                       loadingText: 'Searching...',
                                       //width: 200,  
                                       pageSize: 10,
                                       hideTrigger: true,
                                       id: 'SSmallClassCombo',
                                       applyTo: 'ClassType',
                                       onSelect: function(record) { // override default onSelect to do redirect  
                                           //alert(record.data.cusid); 
                                           //alert(Ext.getCmp('search').getValue());
                                           Ext.getCmp('ClassType').setValue(record.data.ClassName);
                                           Ext.getCmp('haddenClassType').setValue(record.data.ClassId);
                                           //Ext.getCmp('searchdivid').style.overflow='hidden';
                                           this.collapse();
                                       }
                                   });


                               }); 
		
	</script>
</html>

