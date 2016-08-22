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
                       text: "����",
                       icon: '../Theme/1/images/extjs/customer/add16.gif',
                       handler: function() {
                           // saveType = "add";
                           // openAddQuotaWin();//����󣬵��������Ϣ����
                           addoptionmark = 1;
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
                           title: '��������ѡ��',
                           modal: 'true',
                           width: 310,
                           height: 200,
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

                                   addoption();

                               }
                           }, {
                               text: '�ر�',
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
                           blankText: 'ѡ�����Ͳ���Ϊ��',
                           forceSelection: true,
                           emptyText: '��ѡ��ѡ������',
                           editable: false,
                           triggerAction: 'all',
                           fieldLabel: 'ѡ������',
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
                           blankText: 'ѡ�����Ͳ���Ϊ��',
                           forceSelection: true,
                           emptyText: '��ѡ��ѡ������',
                           editable: false,
                           triggerAction: 'all',
                           fieldLabel: 'ѡ������',
                           selectOnFocus: true,
                           anchor: '90%'
                       });

                       //�޸�ָ��
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


                       //����ָ��
                       function addoption() {
                           var optionType = optionTypeCombo.getValue();
                           if (optionType == null || optionType.trim() == '' || optionType == 'undefined') {
                               Ext.Msg.alert("����", "��ѡ��ѡ�����ͣ�");
                               return;
                           }
                           var addOptionName = Ext.getCmp("addOptionName").getValue();
                           if (addOptionName == null || addOptionName.trim() == '') {
                               Ext.Msg.alert("����", "ѡ�����Ʋ���Ϊ�գ�");
                               return;
                           } 
                           var Note = Ext.getCmp("OptionNote").getValue();
                         /*(  if (Note == null || Note.trim() == '') {
                               Ext.Msg.alert("����", "��ע����Ϊ�գ�");
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
                               //�ɹ�ʱ�ص� 
                               success: function(response, options) {
                                   //��ȡ��Ӧ��json�ַ���

                                   Ext.Msg.alert("��ʾ", "����ɹ���");
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
                                   Ext.Msg.alert("��ʾ", "����ʧ�ܣ�");
                               }
                           });

                       }



                       var addoptionForm = new Ext.form.FormPanel({
                           frame: true,
                           monitorValid: true, // ����formBind:true�İ�ť����֤��
                           labelWidth: 65,
                           items: [{
                               layout: 'form',
                               xtype: "fieldset",
                               title: '����ѡ������',
                               layout: 'column',
                               items: [{
                                   layout: 'form',
                                   columnWidth: 1,  //����ռ�õĿ�ȣ���ʶΪ20��
                                   border: false,
                                   items: [optionTypeCombo, {
                                       cls: 'key',
                                       xtype: 'textfield',
                                       fieldLabel: 'ѡ������',
                                       name: 'addOptionName',
                                       id: 'addOptionName',
                                       anchor: '90%'
                                   }, {
                                       cls: 'key',
                                       xtype: 'textfield',
                                       fieldLabel: '��ע',
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
                                       monitorValid: true, // ����formBind:true�İ�ť����֤��
                                       layout: "form",
                                       items: [{
                                           layout: 'column',   //�����Ԫ��Ϊ����Ϊ�в��ַ�ʽ
                                           border: false,
                                           labelSeparator: '��',
                                           items: [ {
                                                   columnWidth: .3,
                                                   layout: 'form',
                                                   labelWidth: 55,
                                                   border: false,
                                                   items: [{
                                                       cls: 'key',
                                                       xtype: 'textfield',
                                                       fieldLabel: 'ѡ������',
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

                                                   el: 'option_grid',
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
									        { header: '������ID', hidden: true, dataIndex: 'OptionNo' },
									        { header: 'ѡ������ID', hidden: true, dataIndex: 'OptionType' },
									        { header: 'ѡ������', dataIndex: 'DicsName' },
									        { header: 'ѡ������', dataIndex: 'OptionName' },
											{ header: '��ע', dataIndex: 'OptionNote' }
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

