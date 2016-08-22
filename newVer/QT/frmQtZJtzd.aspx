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

               var dsWarehousePositionList; //��λ������
               if (dsWarehousePositionList == null) { //��ֹ�ظ�����
                   dsWarehousePositionList = new Ext.data.JsonStore({
                       totalProperty: "result",
                       root: "root",
                       url: 'frmQtZJtzd.aspx?method=getPosition',
                       fields: ['WhpId', 'WhpName']
                   });
               }

               var dsWarehousePositionList_grid; //��λ������
               if (dsWarehousePositionList_grid == null) { //��ֹ�ظ�����
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
                   fieldLabel: '�ֿ�����',

                   name: 'warehouseCombo',
                   store: dsWarehouseList,
                   displayField: 'WhName',
                   valueField: 'WhId',
                   typeAhead: true, //�Զ�����һ����������ѡ�ȫ����
                   triggerAction: 'all',
                   emptyText: '��ѡ��ֿ�',
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
                   fieldLabel: '��λ����',
                   name: 'warehousePosCombo',
                   store: dsWarehousePositionList,
                   displayField: 'WhpName',
                   valueField: 'WhpId',
                   typeAhead: true, //�Զ�����һ����������ѡ�ȫ����
                   triggerAction: 'all',
                   emptyText: '��ѡ���λ',
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
                           modifyNodify(selectData);

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
                           deloption(selectData);

                       }
                 }, '-', {
                       text: "�����ʼ�",
                       icon: '../Theme/1/images/extjs/customer/spellcheck.png',
                       handler: function() {

                          var optionData = quotaGrid.getSelectionModel().getCount();
                           if (optionData == 0) {
                               Ext.Msg.alert("��ʾ", "��ѡ��Ҫ�ʼ�ļ�¼��");
                               return;
                           }
                           if (optionData > 1) {
                               Ext.Msg.alert("��ʾ", "һ��ֻ���ʼ�һ����¼��");
                               return;
                           }
                           var record = quotaGrid.getSelectionModel().getSelections()[0].data;
                           if (record.CheckStatus != 0 && record.CheckStatus != '0') {
                               Ext.Msg.alert("��ʾ", "�ü�¼�Ѿ����й��ʼ죡");
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

                   //�޸�ָ��
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
                       blankText: 'ѡ���Ʒ',
                       forceSelection: true,
                       emptyText: '��ѡ���Ʒ',
                       editable: false,
                       triggerAction: 'all',
                       fieldLabel: '��Ʒ����',
                       selectOnFocus: true,
                       anchor: '90%'
                   });



                   if (typeof (formulaWindow) == "undefined") {//�������2��windows����
                       var formulaWindow = new Ext.Window({
                           title: '���������ʼ�',
                           modal: 'true',
                           width: 600,
                           y: 50,
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
                                   savecheck();

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

                       function savecheck() {

                           var nocheckno = Ext.getCmp("nocheckno").getValue();
                           if (nocheckno == null || nocheckno.trim() == '') {
                               Ext.Msg.alert("����", "������������");
                               return;
                           }
                           var note = Ext.getCmp("note").getValue();
                          /* if (nocheckno == null || nocheckno.trim() == '') {
                               Ext.Msg.alert("����", "�����뱸ע��");
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




                       if (typeof (checkWindow) == "undefined") {//�������2��windows����
                           var checkWindow = new Ext.Window({
                               title: '����ָ��',
                               modal: 'true',
                               width: 600,
                               y: 50,
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
                                       secondcheck();
                                   }
                               }, {
                                   text: '�ر�',
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
                               html: '<div style="width:100%;text-align:center"> <font size="4"><H1>�㽭ʡ��ҵ���ų����ʼ�֪ͨ��</H1></font><br></div>'
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
	                                           fieldLabel: '�����',
	                                           xtype: 'textfield',
	                                           name: 'kcl',
	                                           id: 'kcl',
	                                           anchor: '90%'
}]
	                                       }, {
	                                           cls: 'key',
	                                           fieldLabel: '��Ʒ��',
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
	                                           fieldLabel: '�ֿ�',
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
	                                               fieldLabel: '��λ',
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
	                                           fieldLabel: '�ʼ���',
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
	                                           fieldLabel: '��ע',
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
                           monitorValid: true, // ����formBind:true�İ�ť����֤��
                           layout: "form",
                           items: [{
                               layout: 'column',   //�����Ԫ��Ϊ����Ϊ�в��ַ�ʽ
                               border: false,
                               labelSeparator: '��',
                               items: [{
                                   columnWidth: .3,
                                   layout: 'form',
                                   border: false,
                                   labelWidth: 55,
                                   items: [{
                                       cls: 'key',
                                       xtype: 'textfield',
                                       fieldLabel: '��Ʒ����',
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

                                   el: 'zjnotify_grid',
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
                                            {header: '������˾', dataIndex: 'OrgName' },
									        { header: '��Ʒ����', dataIndex: 'ProductName' },
									        { header: '�ֿ�', dataIndex: 'WhName' },
									        { header: '��λ', dataIndex: 'WhpName' },
									        { header: '�����', dataIndex: 'RepresentAmount' },
											{ header: '�����', dataIndex: 'NocheckNo' },
											{ header: '��ע', dataIndex: 'Note' },
											{ header: '��������', dataIndex: 'CreateDate' }

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
