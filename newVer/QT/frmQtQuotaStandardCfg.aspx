<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmQtQuotaStandardCfg.aspx.cs" Inherits="QT_frmQtQuotaStandardCfg" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=GB2312">
    <link rel="stylesheet" type="text/css" href="../ext3/resources/css/ext-all.css" />
	<script type="text/javascript" src="../ext3/adapter/ext/ext-base.js"></script>	
	<script type="text/javascript" src="../ext3/ext-all.js"></script>
</head>
<body>
	 <div id="standar_toolbar"></div>
	 <div id="standar_form"></div>
	 <div id="standar_grid"></div>
</body><script>
var modify_quota_id = 'none';
var addmark = 0;
Ext.BLANK_IMAGE_URL = "../ext3/resources/images/default/s.gif"; 
Ext.onReady(function() {
   var Toolbar = new Ext.Toolbar({
   renderTo: "standar_toolbar",
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


   //���޷���
   var UpperCombo = new Ext.form.ComboBox({
       xtype: 'combo',
       store: new Ext.data.Store({
           autoLoad: true,
           baseParams: {
               trancode: 'Menu'
           },
           proxy: new Ext.data.HttpProxy({
           url: 'frmQtQuotaItemCfg.aspx?method=getType&key=Upper'
           }),
           // create reader that reads the project records
           reader: new Ext.data.JsonReader({ root: 'root' }, [
                { name: 'name', type: 'string' },
                { name: 'id', type: 'string' }

               ])
       }),
       valueField: 'id',
       displayField: 'name',
       mode: 'local',
       allowBlank: false,
       blankText: '���������',
       forceSelection: true,
       emptyText: '���������',
       editable: false,
       triggerAction: 'all',
       fieldLabel: '���������',
       selectOnFocus: true,
       anchor: '60%'
   });
   //���޷���
   var LowerCombo = new Ext.form.ComboBox({
       xtype: 'combo',
       store: new Ext.data.Store({
           autoLoad: true,
           baseParams: {
               trancode: 'Menu'
           },
           proxy: new Ext.data.HttpProxy({
               url: 'frmQtQuotaItemCfg.aspx?method=getType&key=Lower'
           }),
           // create reader that reads the project records
           reader: new Ext.data.JsonReader({ root: 'root' }, [
                { name: 'name', type: 'string' },
                { name: 'id', type: 'string' }

               ])
       }),
       valueField: 'id',
       displayField: 'name',
       mode: 'local',
       allowBlank: false,
       blankText: '���������',
       forceSelection: true,
       emptyText: '���������',
       editable: false,
       triggerAction: 'all',
       fieldLabel: '���������',
       selectOnFocus: true,
       anchor: '60%'
   });

   //�ȼ�
   var StandarCom = new Ext.form.ComboBox({
       xtype: 'combo',
       store: new Ext.data.Store({
           autoLoad: true,
           baseParams: {
               trancode: 'Menu'
           },
           proxy: new Ext.data.HttpProxy({
               url: 'frmQtQuotaItemCfg.aspx?method=getType&key=Standar'
           }),
           // create reader that reads the project records
           reader: new Ext.data.JsonReader({ root: 'root' }, [
                { name: 'name', type: 'string' },
                { name: 'id', type: 'string' }

               ])
       }),
       valueField: 'id',
       displayField: 'name',
       mode: 'local',
       allowBlank: false,
       blankText: '�ȼ�',
       forceSelection: true,
       emptyText: '�ȼ�',
       editable: false,
       triggerAction: 'all',
       fieldLabel: '�ȼ�',
       selectOnFocus: true,
       anchor: '90%'
   });
   if (typeof (formulaWindow) == "undefined") {//�������2��windows����
       var formulaWindow = new Ext.Window({
           title: '�ϸ��׼����',
           modal: 'true',
           width: 480,
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
               text: '�����ر�',
               handler: function() {
                   addFormula(true);
               }
           },{
               text: '������������',
               handler: function() {
                   addFormula(false);
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
           url: 'frmQtQuotaItemCfg.aspx?method=getAllCfgList'
           }),
           // create reader that reads the project records
           reader: new Ext.data.JsonReader({ root: 'root' }, [
                { name: 'QuotaName', type: 'string' },
                { name: 'QuotaNo', type: 'string' },
                { name: 'QuotaUnit', type: 'string' }
            ])
        }),
       listeners: {
           select: function(combo, record, index) {
           Ext.getCmp('realname').setValue(record.data.QuotaName);
           Ext.getCmp('unit').setValue(record.data.QuotaUnit);
           }
       }	                               ,
       displayField: 'QuotaName',
       valueField: 'QuotaNo',
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
       anchor: '90%'
   });


   function addFormula(closeflag) {
       var quotaid = quotaItemComb.getValue();
       if (quotaid == null || quotaid == 'undefined' || quotaid == '') {

           Ext.Msg.alert("��ʾ", "��ѡ��ָ�����ƣ�");
           return;
       }
       var unit = Ext.getCmp("unit").getValue();
     /*  if (unit == null || unit.trim() == '') {
           Ext.Msg.alert("����", "ָ�굥λ����Ϊ�գ�");
           return;
       }*/
       var note = Ext.getCmp("note").getValue();
      /* if (note == null || note.trim() == '') {
           Ext.Msg.alert("����", "��ע����Ϊ�գ�");
           return;
       }*/
       var fum = Ext.getCmp("standar").getValue();
       /*if (fum == null || fum.trim() == '') {
           Ext.Msg.alert("����", "�ϸ��׼����Ϊ�գ�");
           return;
       }*/ 
       var Lowernum = Ext.getCmp("Lowernum").getValue();
     /* if (Lowernum == null || Lowernum.trim() == '') {
           Ext.Msg.alert("����", "����ֵ����Ϊ�գ�");
           return;
       }*/
       var Uppernum = Ext.getCmp("Uppernum").getValue();
      /* if (Uppernum == null || Uppernum.trim() == '') {
           Ext.Msg.alert("����", "����ֵ����Ϊ�գ�");
           return;
       }*/ 
       var grade = StandarCom.getValue();
       if (grade == null || grade == 'undefined' || grade == '') {

           Ext.Msg.alert("��ʾ", "��ѡ��ȼ���");
           return;
       }
       var Lower = LowerCombo.getValue();
      /* if (Lower == null || Lower == 'undefined' || Lower == '') {

           Ext.Msg.alert("��ʾ", "��ѡ�����޷��ţ�");
           return;
       }*/
       var Upper =UpperCombo.getValue();
      /* if (Upper == null || Upper == 'undefined' || Upper == '') {

           Ext.Msg.alert("��ʾ", "��ѡ�����޷��ţ�");
           return;
       }*/
       var qurl = 'frmQtQuotaStandardCfg.aspx?method=addStandard';
       if (modify_quota_id != '' && modify_quota_id != null && addmark == 0) {
           qurl = 'frmQtQuotaStandardCfg.aspx?method=updateStandard&standardno=' + modify_quota_id;
       }
       Ext.Ajax.request({
           url: qurl
           , params: {
             QuotaNo: quotaid
           , QuotaName: Ext.getCmp('realname').getValue()
           , QuotaUnit: unit
           , QuotaStandard: fum
           , QuotaNotes: note
           , QuotaRank:grade
           , QuotaUpper:Uppernum
           , QuotaLower:Lowernum
           , LowerOperator:Lower
           , UpperOperator:Upper           
           },
           //�ɹ�ʱ�ص� 
           success: function(response, options) {
               //��ȡ��Ӧ��json�ַ���
               Ext.Msg.alert("��ʾ", "����ɹ���");
               if(closeflag)
               {
                    formulaWindow.hide();
                    editFmForm.getForm().reset();
               }
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
       Ext.getCmp("standar").setValue(record.QuotaStandard);
       Ext.getCmp("note").setValue(record.QuotaNotes);
       Ext.getCmp("Lowernum").setValue(record.QuotaLower);
       Ext.getCmp("Uppernum").setValue(record.QuotaUpper);
       quotaItemComb.setValue(record.QuotaNo);
       StandarCom.setValue(record.QuotaRank);
       LowerCombo.setValue(record.LowerOperator);
       UpperCombo.setValue(record.UpperOperator);
       modify_quota_id = record.StandardNo;
   } 
    var editFmForm = new Ext.form.FormPanel({
        labelWidth: 80,
        autoWidth: true,
        frame: true,
        autoHeight: true,
        items: [
        {
            layout: 'column',
            items: [{
                columnWidth: .8,
                layout: 'form',
                border: false,
                items: [
                    quotaItemComb
                ]
            }]
        },
        {
            layout: 'column',
            items: [{
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
	        }]
        }, {
              layout: 'column',
              items: [{
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
	        }]
        }, {
              layout: 'column',
              items: [{
                   columnWidth: .8,
                   layout: 'form',
                   border: false,
                   items: [{
                       cls: 'key',
                       xtype: 'textarea',
                       height:40,
                       fieldLabel: '��ע',
                       name: 'note',
                       id: 'note',
                       anchor: '90%'
                    }]
	            }]
        }, {
              layout: 'column',
              items: [{
                   columnWidth: .5,
                   layout: 'form',
                   border: false,
                   items: [{
                       cls: 'key',
                       xtype: 'textfield',
                       fieldLabel: '�ϸ��׼',
                       name: 'standar',
                       id: 'standar',
                       anchor: '90%'
                    }]
	            }]
	    }, {
              layout: 'column',
              items: [{
                   columnWidth: .5,
                   layout: 'form',
                   border: false,
                   items: [
                        StandarCom
                   ]
                }]
        }, {
              layout: 'column',
              items: [{
                   columnWidth: .5,
                   layout: 'form',
                   border: false,
                   items: [
	                    LowerCombo
	               ]
	           }]
	    }, {
                layout: 'column',
                items: [{
                    columnWidth: .5,
                    layout: 'form',
                    border: false,
                    items: [{
                        cls: 'key',
                        xtype: 'textfield',
                        fieldLabel: '����ֵ',
                        name: 'Lowernum',
                        id: 'Lowernum',
                        anchor: '90%'
                    }]
	            }]
	    }, {
                layout: 'column',
                items: [{
                    columnWidth: .5,
                    layout: 'form',
                    border: false,
                    items: [
                        UpperCombo
                    ]
                }]
        }, {
                layout: 'column',
                items: [{
                    columnWidth: .5,
                    layout: 'form',
                    border: false,
                    items: [{
                        cls: 'key',
                        xtype: 'textfield',
                        fieldLabel: '����ֵ',
                        name: 'Uppernum',
                        id: 'Uppernum',
                        anchor: '90%'
                    }]
	            }]
        }]
    });

    function addToFum(str) {
       var fum = Ext.getCmp('fum').getValue();
       fum += str;
       Ext.getCmp('fum').setValue(fum);
    }
    formulaWindow.add(editFmForm);





    var quotaTemplate_form = new Ext.form.FormPanel({
       renderTo: "standar_form",
       frame: true,
       monitorValid: true, // ����formBind:true�İ�ť����֤��
       layout: "form",     
       items: [{
           layout: 'column',   //�����Ԫ��Ϊ����Ϊ�в��ַ�ʽ
           border: false,
           labelSeparator: '��',
           items: [{
               columnWidth: .30,
               layout: 'form',
               border: false,
               labelWidth: 70,
               items: [{
                   cls: 'key',
                   xtype: 'textfield',
                   fieldLabel: 'ָ��������',
                   name: 'serchFormulaName',
                   id: 'serchFormulaName',
                   anchor: '90%'
                }]
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
       customerListStore.baseParams.key=formulaName;
       customerListStore.load()
   }

    var customerListStore = new Ext.data.Store
	({
	    url: 'frmQtQuotaStandardCfg.aspx?method=queryStandard',
	    reader: new Ext.data.JsonReader({
	        totalProperty: 'totalProperty',
	        root: 'root'
	    }, [
	    { name: 'StandardNo' },
	    { name: 'QuotaNo' },
	   // { name: 'OrgName' },
        { name: 'QuotaName' },
	    { name: 'QuotaUnit' },
        { name: 'LowerOperator' },
        { name: 'LowerShow' },
        { name: 'QuotaLower' },
        { name: 'UpperShow' },
        { name: 'UpperOperator' },
        { name: 'QuotaUpper' },
        { name: 'QuotaRank' },
        { name: 'QuotaRankShow' },
	    { name: 'QuotaStandard' },
	    { name: 'QuotaNotes' }
	    ]),
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
       el: 'standar_grid',
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
            { header: '�ϸ��׼��', hidden: true, dataIndex: 'StandardNo' },
         //   { header: '������˾',  dataIndex: 'OrgName' },
            { header: 'ָ���', hidden: true, dataIndex: 'QuotaNo' },
            { header: 'ָ������', dataIndex: 'QuotaName' },
            { header: 'ָ�굥λ', dataIndex: 'QuotaUnit' },
	        { header: '���޷�',hidden: true, dataIndex: 'LowerOperator' },
	        { header: '���������', dataIndex: 'LowerShow' },
	        { header: '����ֵ', dataIndex: 'QuotaLower' },
	        { header: '���޷�',hidden: true, dataIndex: 'UpperOperator' },
	        { header: '���޲�����', dataIndex: 'UpperShow' },
	        { header: '����ֵ', dataIndex: 'QuotaUpper' },
			{ header: '�ȼ�', hidden: true, dataIndex: 'QuotaRank' },
			{ header: '�ȼ�', dataIndex: 'QuotaRankShow' },
			{ header: '��׼Ҫ��', dataIndex: 'QuotaStandard' },
			{ header: '��ע', dataIndex: 'QuotaNotes' }
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

