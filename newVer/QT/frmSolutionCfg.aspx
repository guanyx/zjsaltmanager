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
                       text: "����",
                       icon: '../Theme/1/images/extjs/customer/add16.gif',
                       handler: function() {
                           // saveType = "add";
                           // openAddQuotaWin();//����󣬵��������Ϣ����
                           addSolutionmark = 1;
                           solutionWindow.show();
                       }
                   }, '-', {
                       text: "�޸�",
                       icon: '../Theme/1/images/extjs/customer/edit16.gif',
                       handler: function() {
                           ///  deleteCustomer();

                           var solutionData = solutionGrid.getSelectionModel().getCount();
                           if (solutionData == 0) {
                               Ext.Msg.alert("��ʾ", "��ѡ��Ҫ�޸ĵļ�¼��");
                               return;
                           }
                           if (solutionData > 1) {
                               Ext.Msg.alert("��ʾ", "һ��ֻ���޸�һ����¼��");
                               return;
                           }
                           addSolutionmark = 0;
                           modifySolution(solutionData);

                       }
                   }, '-', {
                       text: "ɾ��",
                       icon: '../Theme/1/images/extjs/customer/delete16.gif',
                       handler: function() {

                           var solutionData = solutionGrid.getSelectionModel().getCount();
                           if (solutionData == 0) {
                               Ext.Msg.alert("��ʾ", "��ѡ��Ҫɾ�����У�");
                               return;
                           }
                           delSolution(solutionData);

                       }
}]
                   });
                   if (typeof (solutionWindow) == "undefined") {//�������2��windows����
                       var solutionWindow = new Ext.Window({
                           title: '������Һ',
                           modal: 'true',
                           width: 300,
                           height: 280,
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

                                   addSolution();

                               }
                           }, {
                               text: '�ر�',
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
                           blankText: '��Һ���Ʋ���Ϊ��',
                           forceSelection: true,
                           emptyText: '��ѡ����Һ����',
                           editable: false,
                           triggerAction: 'all',
                           fieldLabel: '��Һ����',
                           selectOnFocus: true,
                           anchor: '90%'
                       });

*/
                    

                       //�޸�ָ��
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
                               //�ɹ�ʱ�ص� 
                               success: function(response, options) {
                                   //��ȡ��Ӧ��json�ַ���

                                   Ext.Msg.alert("��ʾ", "ɾ���ɹ���");
                                   for (var i = 0; i < recorddel.length; i++) {
                                       solutionStore.remove(recorddel[i]);
                                   }


                               },
                               failure: function() {
                                   Ext.Msg.alert("��ʾ", "ɾ��ʧ�ܣ�");
                               }
                           });
                       }


                       //����ָ��
                       function addSolution() {
                           var MolecularFormula = Ext.getCmp("MolecularFormula").getValue();
                           if (MolecularFormula == null || MolecularFormula.trim() == '') {
                               Ext.Msg.alert("����", "��Һ����ʽ����Ϊ�գ�");
                               return;
                           }
                           var Titer = Ext.getCmp("Titer").getValue();
                          /* if (Titer == null || Titer.trim() == '') {
                               Ext.Msg.alert("����", "�ζ��Ȳ���Ϊ�գ�");
                               return;
                           }*/
                           var Note = Ext.getCmp("Note").getValue();
                         /*  if (Note == null || Note.trim() == '') {
                               Ext.Msg.alert("����", "��ע����Ϊ�գ�");
                               return;
                           }*/
                           var soluName = Ext.getCmp("addSolutionName").getValue();
                           if (soluName == null || soluName.trim() == '' || soluName == 'undefined') {
                               Ext.Msg.alert("����", "��Һ���Ʋ���Ϊ�գ�");
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
                               //�ɹ�ʱ�ص� 
                               success: function(response, options) {
                                   //��ȡ��Ӧ��json�ַ���

                                   Ext.Msg.alert("��ʾ", "����ɹ���");
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
                                   Ext.Msg.alert("��ʾ", "����ʧ�ܣ�");
                               }
                           });

                       }



                       var addSolutionForm = new Ext.form.FormPanel({
                           frame: true,
                           monitorValid: true, // ����formBind:true�İ�ť����֤��
                           labelWidth: 120,
                           items: [{
                               layout: 'form',
                               xtype: "fieldset",
                               title: '��Һ����',
                               layout: 'column',
                               items: [{
                                   layout: 'form',
                                   columnWidth: 1,  //����ռ�õĿ�ȣ���ʶΪ20��
                                   border: false,
                                   items: [{
                                       cls: 'key',
                                       xtype: 'textfield',
                                       fieldLabel: '��Һ����',
                                       name: 'addSolutionName',
                                       id: 'addSolutionName',
                                       anchor: '90%'
                                   }, {
                                       cls: 'key',
                                       xtype: 'textfield',
                                       fieldLabel: '��Һ����ʽ',
                                       name: 'MolecularFormula',
                                       id: 'MolecularFormula',
                                       anchor: '90%'
                                   }, {
                                       cls: 'key',
                                       xtype: 'textfield',
                                       fieldLabel: '�ζ���',
                                       name: 'Titer',
                                       id: 'Titer',
                                       anchor: '90%'
                                   }, {
                                       cls: 'key',
                                       xtype: 'textfield',
                                       fieldLabel: '��ע',
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
                                                   fieldLabel: '��Һ����',
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
		        text: '��ѯ',
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
			              //���ݼ���Ԥ����,������һЩ�ϲ�����ʽ����Ȳ���
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
									        { header: '��Һ����', dataIndex: 'SolutionName' },
									        { header: '��Һ����ʽ', dataIndex: 'MolecularFormula' },
									        { header: '��ҺID', hidden: true, dataIndex: 'SolutionNo' },
											{ header: '�ζ���', dataIndex: 'Titer'},
											{ header: '¼��ʱ��', dataIndex: 'CreateDate' },
											{ header: '��ע', dataIndex: 'Note' },
											{ header: '������', dataIndex: 'EmpName' }
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
                                                   store: solutionStore,
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
                                           solutionGrid.render();
                                       }); 
		
	</script>
</html>
