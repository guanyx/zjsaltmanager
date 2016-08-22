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
                       text: "����",
                       icon: '../Theme/1/images/extjs/customer/add16.gif',
                       handler: function() {
                           // saveType = "add";
                           // openAddQuotaWin();//����󣬵��������Ϣ����
                           addmark = 1;
                           formulaWindow.show();
                       }
                   }, '-', {
                       text: "�޸�",
                       icon: '../Theme/1/images/extjs/customer/edit16.gif',
                       handler: function() {
                           ///  deleteCustomer();
 
                           var selectData = quotaGrid.getSelectionModel().getCount();
                           if (selectData == 0) {
                               Ext.Msg.alert("��ʾ", "��ѡ��Ҫ�޸ĵļ�¼��");
                               return;
                           }
                           if (selectData > 1) {
                               Ext.Msg.alert("��ʾ", "һ��ֻ���޸�һ����¼��");
                               return;
                           }
                           addmark = 0;
                           modifyQuota(selectData);

                       }
                   }, '-', {
                       text: "ɾ��",
                       icon: '../Theme/1/images/extjs/customer/delete16.gif',
                       handler: function() {

                           var selectData = quotaGrid.getSelectionModel().getCount();
                           if (selectData == 0) {
                               Ext.Msg.alert("��ʾ", "��ѡ��Ҫɾ�����У�");
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
                           //�ɹ�ʱ�ص� 
                           success: function(response, options) {
                               //��ȡ��Ӧ��json�ַ���

                               Ext.Msg.alert("��ʾ", "ɾ���ɹ���");

                               for (var i = 0; i < recorddel.length; i++) {
                                   customerListStore.remove(recorddel[i]);
                               }


                           },
                           failure: function() {
                               Ext.Msg.alert("��ʾ", "ɾ��ʧ�ܣ�");
                           }
                       });
                   }


                   if (typeof (formulaWindow) == "undefined") {//�������2��windows����
                       var formulaWindow = new Ext.Window({
                           title: '��׼�ϸ�ģ������',
                           modal: 'true',
                           width: 600,
                           autoHeigth: true,
                           collapsible: true, //�Ƿ�����۵� 
                           closable: true, //�Ƿ���Թر� 
                           //maximizable : true,//�Ƿ������� 
                           closeAction: 'hide',
                           constrain: true,
                           resizable: false,
                           plain: true,
                           // ,items: addQuotaForm
                           buttons: [{
                               text: '����',
                               handler: function() {
                                   addFormula();

                               }
                           }, {
                               text: '�ر�',
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
                           // blankText : 'ָ�����Ͳ���Ϊ��', 
                           forceSelection: true,
                           emptyText: '��ѡ��˾',
                           hiddenName: 'pid',
                           editable: false,
                           triggerAction: 'all',
                           fieldLabel: '��˾����',
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
                       // blankText : 'ָ�����Ͳ���Ϊ��', 
                       forceSelection: true,
                       emptyText: '��ѡ��˾',
                       hiddenName: 'pid',
                       editable: false,
                       triggerAction: 'all',
                       fieldLabel: '��˾����',
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
                       // blankText : 'ָ�����Ͳ���Ϊ��', 
                       forceSelection: true,
                       emptyText: '��ѡ��ģ��',
                       hiddenName: 'jyzbCom',
                       editable: false,
                       triggerAction: 'all',
                       fieldLabel: '����ָ��ģ��',
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
                       // blankText : 'ָ�����Ͳ���Ϊ��', 
                       forceSelection: true,
                       emptyText: '��ѡ��ģ��',
                       hiddenName: 'jbpdCom',
                       editable: false,
                       triggerAction: 'all',
                       fieldLabel: '�����ж�ģ��',
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
                       // blankText : 'ָ�����Ͳ���Ϊ��', 
                       forceSelection: true,
                       emptyText: '��ѡ��ģ��',
                       hiddenName: 'jsgsCom',
                       editable: false,
                       triggerAction: 'all',
                       fieldLabel: '���㹫ʽģ��',
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
                       fieldLabel: '��������',
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
                       fieldLabel: '�����׼',
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
                       fieldLabel: '�жϱ�׼',
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
                       fieldLabel: '�����豸',
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
                       fieldLabel: '�ʼ����',
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
                       fieldLabel: '����',
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
                       fieldLabel: '������',
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
                           Ext.Msg.alert("����", "��Ʒ���Ʋ���Ϊ�գ�");
                           return;
                       }
                       var ProductClassid = Ext.getCmp("ProductClassid").getValue();
                       if (ProductClassid == null || ProductClassid.trim() == '') {
                           Ext.Msg.alert("����", "��ѡ���Ʒ��");
                           return;
                       }

                       var pno = Ext.getCmp("pno").getValue();
                       if (pno == null || pno.trim() == '') {
                           Ext.Msg.alert("����", "��Ʒ��Ų���Ϊ�գ�");
                           return;
                       }
                       var qtname = Ext.getCmp("qtname").getValue();
                       if (qtname == null || qtname.trim() == '') {
                           Ext.Msg.alert("����", "��Ʒ�ʼ�������Ϊ�գ�");
                           return;
                       }
                       var standar = Ext.getCmp("standar").getValue();
                       if (standar == null || standar.trim() == '') {
                           Ext.Msg.alert("����", "�����Ϊ�գ�");
                           return;
                       }
                       var note = Ext.getCmp("note").getValue();
                       if (note == null || note.trim() == '') {
                           Ext.Msg.alert("����", "��ע����Ϊ�գ�");
                           return;
                       }

                       var solt = soltComb.getValue();
                       if (solt == null || solt == 'undefined' || solt == '') {

                           Ext.Msg.alert("��ʾ", "��ѡ�������ͣ�");
                           return;
                       }
                       var place = placeComb.getValue();
                       if (place == null || place == 'undefined' || place == '') {

                           Ext.Msg.alert("��ʾ", "��ѡ����أ�");
                           return;
                       }
                       var cy = cyComb.getValue();
                       if (cy == null || cy == 'undefined' || cy == '') {

                           Ext.Msg.alert("��ʾ", "��ѡ�����������");
                           return;
                       }
                       var jy = jyComb.getValue();
                       if (jy == null || jy == 'undefined' || jy == '') {

                           Ext.Msg.alert("��ʾ", "��ѡ������׼��");
                           return;
                       }
                       var pd = pdComb.getValue();
                       if (pd == null || pd == 'undefined' || pd == '') {

                           Ext.Msg.alert("��ʾ", "��ѡ���жϱ�׼��");
                           return;
                       }
                       var yq = yqComb.getValue();
                       if (yq == null || yq == 'undefined' || yq == '') {

                           Ext.Msg.alert("��ʾ", "��ѡ�������豸��");
                           return;
                       }
                       var jbpd = jbpdCom.getValue();
                       if (jbpd == null || jbpd == 'undefined' || jbpd == '') {

                           Ext.Msg.alert("��ʾ", "��ѡ�񼶱��ж�ģ�壡");
                           return;
                       }
                       var jyzb = jyzbCom.getValue();
                       if (jyzb == null || jyzb == 'undefined' || jyzb == '') {

                           Ext.Msg.alert("��ʾ", "��ѡ�����ָ��ģ�壡");
                           return;
                       }
                       var jsgs = jsgsCom.getValue();
                       if (jsgs == null || jsgs == 'undefined' || jsgs == '') {

                           Ext.Msg.alert("��ʾ", "��ѡ����㹫ʽģ�壡");
                           return;
                       }

                       var zjlb = zjlbComb.getValue();
                       if (zjlb == null || zjlb == 'undefined' || zjlb == '') {

                           Ext.Msg.alert("��ʾ", "��ѡ���ʼ����");
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
                           //�ɹ�ʱ�ص� 
                           success: function(response, options) {
                               //��ȡ��Ӧ��json�ַ���

                               Ext.Msg.alert("��ʾ", "����ɹ���");
                               formulaWindow.hide();
                               editFmForm.getForm().reset();
                               queryFormula();
                           },
                           failure: function() {
                               Ext.Msg.alert("��ʾ", "����ʧ�ܣ�");
                           }
                       });


                   }
                   //�޸�ָ��
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
		        fieldLabel: '�ɹ���Ʒ���',
		        anchor: '90%',
		        name: 'ClassType',
		        id: 'ClassType'
		    },
	        {
	            xtype: 'hidden',
	            fieldLabel: '�ɹ���Ʒ���ID',
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
	                                           fieldLabel: '��Ʒ���',
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
	                                           fieldLabel: '��Ʒ�ʼ���',
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
	                                           fieldLabel: '���',
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
	                                             fieldLabel: '��ע',
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
                       monitorValid: true, // ����formBind:true�İ�ť����֤��
                       layout: "form",
                       labelWidth: 120,
                       items: [{
                           layout: 'column',   //�����Ԫ��Ϊ����Ϊ�в��ַ�ʽ
                           border: false,
                           labelSeparator: '��',
                           items: [{
                               columnWidth: .2,
                               layout: 'form',
                               border: false,
                               items: [{
                                   cls: 'key',
                                   xtype: 'textfield',
                                   fieldLabel: '��Ʒ����',
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
                                       fieldLabel: '��Ʒ���',
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
                                           fieldLabel: '�ʼ�����',
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
		        text: '��ѯ',
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
			              //���ݼ���Ԥ����,������һЩ�ϲ�����ʽ����Ȳ���
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
                                       loadMask: { msg: '���ڼ������ݣ����Ժ��' },
                                       sm: sm,
                                       /*  ����м�û�в�ѯ����form��ô����ֱ����tbar��ʵ����ɾ��
                                       tbar:[{
                                       text:"���",
                                       handler:this.showAdd,
                                       scope:this
                                       },"-",
                                       {
                                       text:"�޸�"
                                       },"-",{
                                       text:"ɾ��",
                                       handler:this.deleteBranch,
                                       scope:this
                                       }],
                                       */
                                       cm: new Ext.grid.ColumnModel([
                        sm,
                        new Ext.grid.RowNumberer(), //�Զ��к�


                                            {header: '�ϸ��׼��', hidden: true, dataIndex: 'ConfigNo' },
                                            { header: '������˾', dataIndex: 'OrgId' },
                                            { header: '��Ʒ���', dataIndex: 'ProductNo' },
                                            { header: '�ʼ�����', dataIndex: 'CheckName' },
                                            { header: '��Ʒ����', dataIndex: 'ProductName' },
									        { header: '���', dataIndex: 'Standards' },
									        { header: '����', dataIndex: 'Originplace', renderer: cmbType },
									        { header: '��ע', dataIndex: 'Note' }

			  ]), listeners:
			  {
			      rowselect: function(sm, rowIndex, record) {
			          //alert(1);
			          //Ext.MessageBox.alert("��ʾ", "��ѡ��ĳ�����ǣ�" + record.data.FormulaNo);
			      },
			      rowclick: function(grid, rowIndex, e) {

			      },
			      rowdbclick: function(grid, rowIndex, e) {
			          //˫���¼�
			      },
			      cellclick: function(grid, rowIndex, columnIndex, e) {
			          //��Ԫ�񵥻��¼�			           
			      },
			      celldbclick: function(grid, rowIndex, columnIndex, e) {
			          //��Ԫ��˫���¼�
			          /*
			          var record = grid.getStore().getAt(rowIndex); //Get the Record
			          var fieldName = grid.getColumnModel().getDataIndex(columnIndex); //Get field name
			          var data = record.get(fieldName);
			          Ext.MessageBox.alert('show','��ǰѡ�е�������'+data); 
			          */
			      }
			  },
                                       bbar: new Ext.PagingToolbar({
                                           pageSize: 10,
                                           store: customerListStore,
                                           displayMsg: '��ʾ��{0}����{1}����¼,��{2}��',
                                           emptyMsy: 'û�м�¼',
                                           displayInfo: true
                                       }),
                                       viewConfig: {
                                           columnsText: '��ʾ����',
                                           scrollOffset: 20,
                                           sortAscText: '����',
                                           sortDescText: '����',
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

