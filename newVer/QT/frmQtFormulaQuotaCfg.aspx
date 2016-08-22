<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmQtFormulaQuotaCfg.aspx.cs" Inherits="QT_frmQtFormulaQuotaCfg" %>

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
           Ext.BLANK_IMAGE_URL = "../ext3/resources/images/default/s.gif";
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
                           ids = recorddel[0].data.FormulaNo;
                       } else {
                           for (var i = 0; i < rownum; i++) {
                               ids += recorddel[i].data.FormulaNo + ',';
                           }
                           ids = ids.substring(0, ids.length - 1);
                       }

                       Ext.Ajax.request({
                           url: 'frmQtFormulaQuotaCfg.aspx?method=delFormula'
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
                           title: '�������㹫ʽָ��',
                           modal: 'true',
                           width: 700,
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
                   

                       var quotaItemComb = new Ext.form.ComboBox({
                           xtype: 'combo',

                           store: new Ext.data.Store({
                               autoLoad: true,
                               baseParams: {
                                   trancode: 'Menu'
                               },
                               proxy: new Ext.data.HttpProxy({
                                   url: 'frmQtFormulaTamplateCfg.aspx?method=queryQuotaByType&find=fuml&typecode=Q022'
                               }),
                               // create reader that reads the project records
                               reader: new Ext.data.JsonReader({ root: 'root' }, [
                { name: 'name', type: 'string' },
                { name: 'id', type: 'string' },
                { name: 'unit', type: 'string' }
        ])
                           }),
                           listeners: {
                               select: function(combo, record, index) {
                                   Ext.getCmp('realname').setValue(record.data.name);
                                   Ext.getCmp('unit').setValue(record.data.unit);
                               }
                           }
	                               ,
                           displayField: 'name',
                           valueField: 'id',
                           triggerAction: 'all',
                           id: 'quotaitemCombo',
                           //pageSize: 5,
                           //minChars: 2,
                           //hideTrigger: true,
                           fieldLabel: 'ָ������',
                           typeAhead: true,
                           mode: 'local',
                           //            tpl: resultTpl,
                           emptyText: '',
                           selectOnFocus: false,
                           editable: true,
                           anchor: '50%'
                       });


                       function addFormula() {
                           var quotaid = quotaItemComb.getValue();
                           if (quotaid == null || quotaid == 'undefined' || quotaid == '') {

                               Ext.Msg.alert("��ʾ", "��ѡ��ָ�����ƣ�");
                               return;
                           }
                           var unit = Ext.getCmp("unit").getValue();
                           /*if (unit == null || unit.trim() == '') {
                               Ext.Msg.alert("����", "ָ�굥λ����Ϊ�գ�");
                               return;
                           }*/
                           var note = Ext.getCmp("note").getValue();
                          /* if (note == null || note.trim() == '') {
                               Ext.Msg.alert("����", "��ע����Ϊ�գ�");
                               return; 
                           }*/
                           var fum = Ext.getCmp("fum").getValue();
                           if (fum == null || fum.trim() == '') {
                               Ext.Msg.alert("����", "ָ�깫ʽ����Ϊ�գ�");
                               return;
                           }
                           var qurl = 'frmQtFormulaQuotaCfg.aspx?method=addFormula';
                           if (modify_quota_id != '' && modify_quota_id != null && addmark == 0) {
                               qurl = 'frmQtFormulaQuotaCfg.aspx?method=updateFormula&formulano=' + modify_quota_id;
                           }
                           Ext.Ajax.request({
                               url: qurl
                               , params: {
                                   QuotaNo: quotaid
                               , QuotaName: Ext.getCmp('realname').getValue()
                               , QuotaUnit: unit
                               , QuotaFormula: fum
                               , QuotaNote: note
                               },
                               //�ɹ�ʱ�ص� 
                               success: function(response, options) {
                                   //��ȡ��Ӧ��json�ַ���

                                   Ext.Msg.alert("��ʾ", "����ɹ���");
                                   formulaWindow.hide();
                                   editFmForm.getForm().reset();
                                   var formulaName = Ext.getCmp("serchFormulaName").getValue();
                                   customerListStore.baseParams.start=0;
                                   customerListStore.baseParams.limit=10;
                                   customerListStore.load({
                                       params: {
                                           key: formulaName
                                       }
                                   });


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
                           Ext.getCmp("unit").setValue(record.QuotaUnit);
                           Ext.getCmp("realname").setValue(record.QuotaName);
                           Ext.getCmp("fum").setValue(record.QuotaFormula);
                           Ext.getCmp("note").setValue(record.QuotaNote);
                           quotaItemComb.setValue(record.QuotaNo);
                           modify_quota_id = record.FormulaNo;
                       }
                       var editFmForm = new Ext.form.FormPanel({
                           labelWidth: 100,
                           autoWidth: true,
                           frame: true,
                           autoHeight: true,

                           items: [quotaItemComb,
  {
      layout: 'column',
      items: [
	                                   {
	                                       columnWidth: 1,
	                                       layout: 'form',
	                                       border: false,
	                                       items: [{
	                                           cls: 'key',
	                                           xtype: 'hidden',
	                                           name: 'realname',
	                                           id: 'realname',
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
	                                           xtype: 'textfield',
	                                           fieldLabel: '��λ',
	                                           name: 'unit',
	                                           id: 'unit',
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
	                                           fieldLabel: '��ע',
	                                           name: 'note',
	                                           id: 'note',
	                                           anchor: '90%'
}]
	                                       }
	                                  ]
  },
	                               {
	                                   layout: 'column',
	                                   items: [
	                                   {
	                                       columnWidth: 1,
	                                       layout: 'form',
	                                       border: false,
	                                       items: [{
	                                           cls: 'key',
	                                           xtype: 'textfield',
	                                           fieldLabel: '��ʽ',
	                                           name: 'fum',
	                                           id: 'fum',
	                                           anchor: '90%'
}]
	                                       }
	                                  ]
	                                   }, {
	                                       layout: 'column',
	                                       items: [
	                                    { style: 'align:left',
	                                        columnWidth: .20,
	                                        layout: 'form',
	                                        border: false,
	                                        items: [
	                                     { cls: 'key',
	                                         xtype: 'button',
	                                         text: '+',
	                                         anchor: '50%',
	                                         handler: function() {
	                                             addToFum('+');
	                                         }
	                                     }
	                                ]
	                                    }, { style: 'align:left',
	                                        columnWidth: .20,
	                                        layout: 'form',
	                                        border: false,
	                                        items: [
	                                     { cls: 'key',
	                                         xtype: 'button',
	                                         text: '-',
	                                         anchor: '50%',
	                                         handler: function() {
	                                             addToFum('-');
	                                         }
	                                     }
	                                ]
	                                    }, { style: 'align:left',
	                                        columnWidth: .20,
	                                        layout: 'form',
	                                        border: false,
	                                        items: [
	                                     { cls: 'key',
	                                         xtype: 'button',
	                                         text: '*',
	                                         anchor: '50%',
	                                         handler: function() {
	                                             addToFum('*');
	                                         }
	                                     }
	                                ]
	                                    }, { style: 'align:left',
	                                        columnWidth: .20,
	                                        layout: 'form',
	                                        border: false,
	                                        items: [
	                                     { cls: 'key',
	                                         xtype: 'button',
	                                         text: '/',
	                                         anchor: '50%',
	                                         handler: function() {
	                                             addToFum('/');
	                                         }
	                                     }
	                                ]
	                                    }, { style: 'align:left',
	                                        columnWidth: .20,
	                                        layout: 'form',
	                                        border: false,
	                                        items: [
	                                     { cls: 'key',
	                                         xtype: 'button',
	                                         text: '%',
	                                         anchor: '50%',
	                                         handler: function() {
	                                             addToFum('%');
	                                         }
	                                     }
	                                ]
	                                    }

	                                  ]
}]
                       });


                       Ext.Ajax.request({
                           url: 'frmQtFormulaQuotaCfg.aspx?method=queryQuotaByType&typecode=Q021'
                                       , params: {},
                           //�ɹ�ʱ�ص� 
                           success: function(response, options) {
                               //��ȡ��Ӧ��json�ַ���

                               if (response != null && response.responseText != 'undefined' && response.responseText != null && response.responseText != '') {
                                   var data = Ext.util.JSON.decode(response.responseText);
                                   var panelstr = "new Ext.Panel({autoWidth: true,autoHeight: true,layout: 'column', items: [";


                                   var quotaCount = data.length;
                                   for (var i = 0; i < quotaCount; i++) {
                                       panelstr += " {columnWidth: .20,layout: 'form',border: false,items:[{cls: 'key',xtype: 'button', text:'" + data[i].name + "', handler: function() { addToFum('" + data[i].alias + "');},anchor: '50%'}]},";
                                   }
                                   panelstr = panelstr.substring(0, panelstr.length - 1);
                                   panelstr += "]})";

                                   editFmForm.add(eval(panelstr));
                               }

                           },
                           failure: function() {
                               Ext.Msg.alert("��ʾ", "��ȡָ�����������,�����´򿪸�ҳ��");
                           }
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
                           items: [{
                               layout: 'column',   //�����Ԫ��Ϊ����Ϊ�в��ַ�ʽ
                               border: false,
                               labelSeparator: '��',
                               items: [{
                               columnWidth: .3,
                               labelWidth: 70,
                                   layout: 'form',
                                   border: false,
                                   items: [{
                                       cls: 'key',
                                       xtype: 'textfield',
                                       fieldLabel: 'ָ��������',
                                       name: 'serchFormulaName',
                                       id: 'serchFormulaName',
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
                                   var formulaName = Ext.getCmp("serchFormulaName").getValue();
                                   customerListStore.baseParams.start=0;
                                   customerListStore.baseParams.limit=10;
                                   customerListStore.load({
                                       params: {
                                           key: formulaName
                                       }
                                   })
                               }

                               var customerListStore = new Ext.data.Store
			({
			    url: 'frmQtFormulaQuotaCfg.aspx?method=queryFormula',
			    reader: new Ext.data.JsonReader({
			        totalProperty: 'totalProperty',
			        root: 'root'
			    }, [
			    { name: 'FormulaNo' },
			    { name: 'QuotaNo' },
			    { name: 'OrgName' },
	            { name: 'QuotaName' },
			    { name: 'QuotaUnit' },
	            { name: 'QuotaFormula' },
	            { name: 'QuotaNote' },
	            { name: 'CreateDate' },
			    { name: 'EmpName' }
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
                                            {header: 'ָ���', hidden: true, dataIndex: 'FormulaNo' },
                                            { header: 'ָ���', hidden: true, dataIndex: 'QuotaNo' },
                                            { header: '������˾', dataIndex: 'OrgName' },
									        { header: 'ָ������', dataIndex: 'QuotaName' },
									        { header: '��ʽ', dataIndex: 'QuotaFormula' },
									        { header: '��λ', dataIndex: 'QuotaUnit' },
											{ header: '��������', dataIndex: 'CreateDate' },
											{ header: '������', dataIndex: 'EmpName' }
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

                           }); 
		
	</script>
</html>

