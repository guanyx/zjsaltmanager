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
               var strPrint = "<h4 style=��font-size:18px; text-align:center;��>��ӡԤ����</h4>\n";

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
               strPrint = strPrint + "<div style='text-align:center'><button onclick='printWin()' style='padding-left:4px;padding-right:4px;'>��  ӡ</button><button onclick='window.opener=null;window.close();'  style='padding-left:4px;padding-right:4px;'>��  ��</button></div>\n";

               oWin.document.write(strPrint);
               oWin.focus();
               oWin.document.close();
           }
           
           Ext.BLANK_IMAGE_URL = "../ext3/resources/images/default/s.gif";
           Ext.onReady(function() {

               var ctstore = new Ext.data.ArrayStore({
                   fields: ['id', 'state'],
                   data: [['0', '��'], ['1', '��']]
               });
               var ctcombo = new Ext.form.ComboBox({
                   store: ctstore,
                   displayField: 'state',
                   valueField: 'id',
                   typeAhead: true,
                   mode: 'local',
                   triggerAction: 'all',
                   emptyText: 'ѡ���Ƿ�ͳ��',
                   selectOnFocus: true,
                   listeners: {
                       "select": addNewBlankRow
                   },
                   anchor: '50%'
               });
               var tpstore = new Ext.data.ArrayStore({
                   fields: ['id', 'state'],
                   data: [['0', '��'], ['1', '��']]
               });
               var tpcombo = new Ext.form.ComboBox({
                   store: tpstore,
                   displayField: 'state',
                   valueField: 'id',
                   typeAhead: true,
                   mode: 'local',
                   triggerAction: 'all',
                   emptyText: 'ѡ���Ƿ����',
                   selectOnFocus: true,
                   listeners: {
                       "select": addNewBlankRow
                   },
                   anchor: '50%'
               });

               var ststore = new Ext.data.ArrayStore({
                   fields: ['id', 'state'],
                   data: [['0', '��'], ['1', '��']]
               });
               var stcombo = new Ext.form.ComboBox({
                   store: tpstore,
                   displayField: 'state',
                   valueField: 'id',
                   typeAhead: true,
                   mode: 'local',
                   triggerAction: 'all',
                   emptyText: 'ѡ���Ƿ����',
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
                   fieldLabel: '�ʼ����',
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
                       text: "����",
                       icon: '../Theme/1/images/extjs/customer/add16.gif',
                       handler: function() {
                           // saveType = "add";
                           // openAddQuotaWin();//����󣬵��������Ϣ����
                           addoptionmark = 1;
                           inserNewBlankRow();
                           optionWindow.show();
                       }
                   }, '-', {
                       text: "�޸�",
                       icon: '../Theme/1/images/extjs/customer/edit16.gif',
                       handler: function() {
                           ///  deleteCustomer();

                           var optionData = optionGrid.getSelectionModel().getCount();

                           if (optionData == 0) {
                               Ext.Msg.alert("��ʾ", "��ѡ��Ҫ�޸ĵļ�¼��");
                               return;
                           }
                           if (optionData > 1) {
                               Ext.Msg.alert("��ʾ", "һ��ֻ���޸�һ����¼��");
                               return;
                           }
                           addoptionmark = 0;
                           modifyoption(optionData);

                       }
                   }, '-', {
                       text: "ɾ��",
                       icon: '../Theme/1/images/extjs/customer/delete16.gif',
                       handler: function() {
                           var optionData = optionGrid.getSelectionModel().getCount();

                           if (optionData == 0) {
                               Ext.Msg.alert("��ʾ", "��ѡ��Ҫɾ�����У�");
                               return;
                           }
                           deloption(optionData);

                       }
}]
                   });
                   if (typeof (optionWindow) == "undefined") {//�������2��windows����
                       var optionWindow = new Ext.Window({
                           title: '�����ʼ�ģ��',
                           modal: 'true',
                           width: 700,
                           y: 50,
                           autoHeight: true,
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
                                   var tpname = Ext.getCmp('tpname').getValue();
                                   if (tpname == undefined || tpname == null || tpname == "") {
                                       Ext.Msg.alert("��ʾ", "������ģ�����ƣ�");
                                       return;
                                   }
                                   // var counttype = Ext.getCmp('counttype').getValue();
                                   /*  if (counttype == undefined || counttype == null || counttype == "") {
                                   Ext.Msg.alert("��ʾ", "������ϼƷ�ʽ��");
                                   return;
                                   }*/
                                   var checktype = zjlbComb.getValue();
                                   if (checktype == undefined || checktype == null || checktype == "") {
                                       Ext.Msg.alert("��ʾ", "�����뱨�����ͣ�");
                                       return;
                                   }
                                   // var outcolumn = Ext.getCmp('outcolumn').getValue();
                                   /*if (outcolumn == undefined || outcolumn == null || outcolumn == "") {
                                   Ext.Msg.alert("��ʾ", "�����뿪ʼ�����У�");
                                   return;
                                   }*/
                                   var countstart = Ext.getCmp('countstart').getValue();
                                   /*   if (countstart == undefined || countstart == null || countstart == "") {
                                   Ext.Msg.alert("��ʾ", "������ϼƿ�ʼ�����У�");
                                   return;
                                   }*/
                                   var detailcolumn = Ext.getCmp('detailcolumn').getValue();
                                   /*  if (detailcolumn == undefined || detailcolumn == null || detailcolumn == "") {
                                   Ext.Msg.alert("��ʾ", "��������ϸ������ʼ�У�");
                                   return;
                                   }*/
                                   var outname = Ext.getCmp('outname').getValue();
                                   /* if (outname == undefined || outname == null || outname == "") {
                                   Ext.Msg.alert("��ʾ", "�����뵼��ģ�����ƣ�");
                                   return;
                                   }*/
                                   var note = Ext.getCmp('note').getValue();
                                   /* if (note == undefined || note == null || note == "") {
                                   Ext.Msg.alert("��ʾ", "�����뱸ע��");
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
                                           Ext.Msg.alert("��ʾ", "����ɹ���");
                                           optionWindow.hide();
                                           dsOrderProduct.removeAll();
                                           queryoption();
                                       }
                , failure: function(resp, opts) {
                    // Ext.MessageBox.hide();
                    Ext.Msg.alert("��ʾ", "����ʧ�ܣ�");

                }
                                   });


                               }


                           }, {
                               text: '�ر�',
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
                       // html: '<div style="width:100%;text-align:center"> <font size="4"><H1>�㽭ʡ��ҵ�����ʼ챨�浥</H1></font></div>'
                   });

                   if (typeof (resultWindow) == "undefined") {//�������2��windows����
                       var resultWindow = new Ext.Window({
                           title: '��������ѡ��',
                           modal: 'true',
                           width: 700,
                           autoHeight: true,
                           collapsible: true, //�Ƿ�����۵� 
                           closable: true, //�Ƿ���Թر� 
                           //maximizable : true,//�Ƿ������� 
                           closeAction: 'hide',
                           constrain: true,
                           resizable: false,
                           plain: true,
                           items: [panel],
                           // ,items: addQuotaForm
                           buttons: [{
                               text: '��ӡ',
                               handler: function() {
                                   startPrint(printstr);
                               }
                           }, {
                               text: '����',
                               handler: function() {
                                   outExcel();
                               }
                           }, {
                               text: '�ر�',
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
                       monitorValid: true, // ����formBind:true�İ�ť����֤��
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
                       blankText: 'ѡ�����Ͳ���Ϊ��',
                       forceSelection: true,
                       selectOnFocus: true,
                       emptyText: '��ѡ��ѡ������',
                       editable: false,
                       triggerAction: 'all',
                       listeners: {
                           select: function(combo, record, index) {
                               var sm = userGrid.getSelectionModel().getSelected();
                               sm.set('ShowId', record.data.id);
                               inserNewBlankRow();
                           }
                       },
                       fieldLabel: 'ѡ������',
                       selectOnFocus: true,
                       anchor: '90%'
                   });


                   //�޸�ָ��
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
                                   Ext.Msg.alert("��ʾ",   "��Ϣ����ʧ�ܣ�"); 
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
                           //�ɹ�ʱ�ص� 
                           success: function(response, options) {
                               //��ȡ��Ӧ��json�ַ���

                               Ext.Msg.alert("��ʾ", "ɾ���ɹ���");

                               for (var i = 0; i < recorddel.length; i++) {
                                   optionStore.remove(recorddel[i]);
                               }




                           },
                           failure: function() {
                               Ext.Msg.alert("��ʾ", "ɾ��ʧ�ܣ�");
                           }
                       });
                   }


                   var detailcm = new Ext.grid.ColumnModel([
        new Ext.grid.RowNumberer(), //�Զ��к�
        {
        id: 'DetailNo',
        header: "�ʼ�ģ����ϸID",
        dataIndex: 'DetailNo',
        hidden: true,
        editor: new Ext.form.TextField({ allowBlank: false })
    },
         {
             id: 'DetailName',
             header: "����",
             dataIndex: 'DetailName',
             width: 70,
             editor: new Ext.form.TextField({ allowBlank: true })

         },
          {
              id: 'OrderColumn',
              header: "��ʾ�к�",
              dataIndex: 'OrderColumn',
              width: 40,
              editor: new Ext.form.TextField({ allowBlank: true })
          },
        {
            id: 'IfCount',
            header: "�Ƿ�ͳ���ֶ�",
            dataIndex: 'IfCount',
            width: 65,
            editor: ctcombo,
            renderer: function(value, cellmeta, record, rowIndex, columnIndex, store) {
                //���ֵ��ʾ����
                //��ȡ��ǰid="combo_process"��comboBoxѡ���ֵ
                var index = ctstore.find(ctcombo.valueField, value);
                var record = ctstore.getAt(index);
                var displayText = "";
                // ��������б�û�б�ѡ����ôrecordҲ�Ͳ����ڣ���ʱ�򣬷��ش�������value��
                // �����value����grid��USER_REALNAME�е�value������ֱ�ӷ���
                if (record == null) {
                    //����Ĭ��ֵ��
                    displayText = value;
                } else {
                    displayText = record.data.state; //��ȡrecord�е����ݼ��е�process_name�ֶε�ֵ
                }

                return displayText;
            }

        },
         {
             id: 'Round',
             header: "����С��λ",
             dataIndex: 'Round',
             width: 45,
             editor: new Ext.form.TextField({ allowBlank: true })
         }, {
             id: 'IfType',
             header: "�Ƿ�ϼƷ���",
             dataIndex: 'IfType',
             width: 65,
             editor: tpcombo,
             renderer: function(value, cellmeta, record, rowIndex, columnIndex, store) {
                 //���ֵ��ʾ����
                 //��ȡ��ǰid="combo_process"��comboBoxѡ���ֵ
                 var index = tpstore.find(tpcombo.valueField, value);
                 var record = tpstore.getAt(index);
                 var displayText = "";
                 // ��������б�û�б�ѡ����ôrecordҲ�Ͳ����ڣ���ʱ�򣬷��ش�������value��
                 // �����value����grid��USER_REALNAME�е�value������ֱ�ӷ���
                 if (record == null) {
                     //����Ĭ��ֵ��
                     displayText = value;
                 } else {
                     displayText = record.data.state; //��ȡrecord�е����ݼ��е�process_name�ֶε�ֵ
                 }

                 return displayText;
             }

         }, {
             id: 'ShowId',
             header: "ָ��ID",
             dataIndex: 'ShowId',
             hidden: true,
             editor: new Ext.form.TextField({ allowBlank: false })
         }, {
             id: 'ShowName',
             header: "��ʾ����",
             dataIndex: 'ShowName',
             width: 70,
             editor: shownmCombo,
             renderer: function(value, cellmeta, record, rowIndex, columnIndex, store) {
                 //���ֵ��ʾ����
                 //��ȡ��ǰid="combo_process"��comboBoxѡ���ֵ
             var index = shownmCombo.getStore().find(shownmCombo.valueField, value);
             var record = shownmCombo.getStore().getAt(index);
                 var displayText = "";
                 // ��������б�û�б�ѡ����ôrecordҲ�Ͳ����ڣ���ʱ�򣬷��ش�������value��
                 // �����value����grid��USER_REALNAME�е�value������ֱ�ӷ���
                 if (record == null) {
                     //����Ĭ��ֵ��
                     displayText = value;
                 } else {
                     displayText = record.data.name; //��ȡrecord�е����ݼ��е�process_name�ֶε�ֵ
                 }

                 return displayText;
             }
         },
        {
            id: 'IfSort',
            header: "�Ƿ������ֶ�",
            dataIndex: 'IfSort',
            width: 65,
            editor: stcombo,
            renderer: function(value, cellmeta, record, rowIndex, columnIndex, store) {
                //���ֵ��ʾ����
                //��ȡ��ǰid="combo_process"��comboBoxѡ���ֵ
                var index = ststore.find(stcombo.valueField, value);
                var record = ststore.getAt(index);
                var displayText = "";
                // ��������б�û�б�ѡ����ôrecordҲ�Ͳ����ڣ���ʱ�򣬷��ش�������value��
                // �����value����grid��USER_REALNAME�е�value������ֱ�ӷ���
                if (record == null) {
                    //����Ĭ��ֵ��
                    displayText = value;
                } else {
                    displayText = record.data.state; //��ȡrecord�е����ݼ��е�process_name�ֶε�ֵ
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
                           columnsText: '��ʾ����',
                           scrollOffset: 20,
                           sortAscText: '����',
                           sortDescText: '����',
                           forceFit: true
                       },
                       listeners: {
                           afteredit: function(e) {
                               if (e.row < e.grid.getStore().getCount()) {
                                   e.grid.stopEditing();
                                   if (e.column < e.record.fields.getCount() - 1) {//���һ�в�������
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
                       //����һ����
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
                       monitorValid: true, // ����formBind:true�İ�ť����֤��

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
	                                           fieldLabel: 'ģ������',
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
	                                           fieldLabel: '������ʼ��',
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
	                                               fieldLabel: '�ϼƷ�ʽ',
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
	                                           fieldLabel: '������ϸ��ʼ��',
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
	                                               fieldLabel: '����ģ������',
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
	                                           fieldLabel: '�ϼƵ�����ʼ��',
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
	                                           fieldLabel: '��ע',
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
                       monitorValid: true, // ����formBind:true�İ�ť����֤��
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
	                                           fieldLabel: 'ȡ����ʼ����',
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
	                                               fieldLabel: 'ȡ����������',
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
	                                                   fieldLabel: '���鿪ʼ����',
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
	                                                       fieldLabel: '�����������',
	                                                       xtype: 'datefield',
	                                                       name: 'jenddate',
	                                                       id: 'jenddate',
	                                                       anchor: '90%'
}]
	                                                   }
	                                  ]
                       }, {
                           layout: 'column',   //�����Ԫ��Ϊ����Ϊ�в��ַ�ʽ
                           border: false,
                           labelSeparator: '��',
                           items: [{
                               columnWidth: .3,
                               layout: 'form',
                               labelWidth: 55,
                               border: false,
                               items: [{
                                   cls: 'key',
                                   xtype: 'textfield',
                                   fieldLabel: '�ʼ�����',
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
                                       fieldLabel: '��Ʒ����',
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
		        text: '��ѯ',
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
                                       Ext.Msg.alert("��ʾ", "��ѡ��һ��ģ�壡");
                                       return;
                                   }
                                   if (optionData > 1) {
                                       Ext.Msg.alert("��ʾ", "ֻ��ѡ��һ��ģ�壡");
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
                                       //�ɹ�ʱ�ص�
                                       success: function(response, options) {
                                           if (response == null || response.responseText == '' || response.responseText.length < 5) {
                                               Ext.Msg.alert("��ʾ", "û�з��������ļ�������");
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
                                           Ext.Msg.alert("��ʾ", "��ȡ����ʧ�ܣ�");
                                       }
                                   });



                               }
                               var opserch_form = new Ext.form.FormPanel({
                                   renderTo: "zjtemp_form",
                                   frame: true,
                                   monitorValid: true, // ����formBind:true�İ�ť����֤��
                                   layout: "form",
                                   items: [{
                                       layout: 'column',   //�����Ԫ��Ϊ����Ϊ�в��ַ�ʽ
                                       border: false,
                                       labelSeparator: '��',
                                       items: [{
                                           columnWidth: .3,
                                           layout: 'form',
                                           labelWidth: 55,
                                           border: false,
                                           items: [{
                                               cls: 'key',
                                               xtype: 'textfield',
                                               fieldLabel: 'ģ������',
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
		        text: '��ѯ',
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
			              //���ݼ���Ԥ����,������һЩ�ϲ�����ʽ����Ȳ���
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
                                            {header: '�ֹ�˾����', dataIndex: 'OrgName' },
									        { header: '�ʼ�����', dataIndex: 'CheckType', renderer: cktp },
									        { header: 'ģ������', dataIndex: 'FormulaName' },
											{ header: '��ע', dataIndex: 'Note' },
											{ header: '����ʱ��', dataIndex: 'CreateDate' }
			  ]), listeners:
			  {
			      rowselect: function(sm, rowIndex, record) {
			          //��ѡ��
			          //Ext.MessageBox.alert("��ʾ","��ѡ��ĳ�����ǣ�" + r.data.ASIN);
			      },
			      rowclick: function(grid, rowIndex, e) {
			          //˫���¼�
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
                                               store: optionStore,
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
                                       optionGrid.render();
                                   }); 
		
	</script>
</html>
