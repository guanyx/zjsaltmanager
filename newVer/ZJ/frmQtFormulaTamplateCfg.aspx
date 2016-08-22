<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmQtFormulaTamplateCfg.aspx.cs" Inherits="QT_frmQtFormulaTamplateCfg" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=GB2312">
    <link rel="stylesheet" type="text/css" href="../ext3/resources/css/ext-all.css" />
	<script type="text/javascript" src="../ext3/adapter/ext/ext-base.js"></script>	
	<script type="text/javascript" src="../ext3/ext-all.js"></script>

</head>
<body>	<div id="formulaTemplate_toolbar"></div>
	    <div id="formulaTemplate_form"></div>
	    <div id="formulaTemplate_grid"></div>
	 </body><script>
	            var quotaCount;
	            var quotaArr = new Array();
	            var addmark = 0;
	            var quotaIdArr = null;
	            var quotaIdstr = '';
	            var modify_quota_template_id = "";
	            Ext.BLANK_IMAGE_URL = "../ext3/resources/images/default/s.gif";
	            Ext.onReady(function() {
	                /*     Ext.form.TextField.prototype.afterRender = Ext.form.TextField.prototype.afterRender
	                .createSequence(function() {
	                this.relayEvents(this.el, ['dblclick']);
	                });*/

	                var Toolbar = new Ext.Toolbar({
	                    renderTo: "formulaTemplate_toolbar",
	                    items: [{
	                        text: "����",
	                        icon: '../Theme/1/images/extjs/customer/add16.gif',
	                        handler: function() {
	                            addmark = 1;
	                            formulaTemplateWindow.show();

	                        }
	                    }, '-', {
	                        text: "�޸�",
	                        icon: '../Theme/1/images/extjs/customer/edit16.gif',
	                        handler: function() {
	                            addmark = 0;
	                            var selectData = formulaTemplateGrid.getSelectionModel().getCount();
	                            if (selectData == 0) {
	                                Ext.Msg.alert("��ʾ", "��ѡ��Ҫ�޸ĵļ�¼��");
	                                return;
	                            }
	                            if (selectData > 1) {
	                                Ext.Msg.alert("��ʾ", "һ��ֻ���޸�һ����¼��");
	                                return;
	                            }


	                            modifyFormulaTemplate(selectData);
	                        }
	                    }, '-', {
	                        text: "ɾ��",
	                        icon: '../Theme/1/images/extjs/customer/delete16.gif',
	                        handler: function() {
	                            var selectData = formulaTemplateGrid.getSelectionModel().getCount();
	                            if (selectData == 0) {
	                                Ext.Msg.alert("��ʾ", "��ѡ��Ҫɾ�����У�");
	                                return;
	                            }
	                            delQuotaTemplate(selectData);
	                        }
}]
	                    });

	                    function delQuotaTemplate(rownum) {
	                        var ids = "";
	                        var recorddel = formulaTemplateGrid.getSelectionModel().getSelections();
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
	                            //�ɹ�ʱ�ص� 
	                            success: function(response, options) {
	                                //��ȡ��Ӧ��json�ַ���

	                                Ext.Msg.alert("��ʾ", "ɾ���ɹ���");

	                                for (var i = 0; i < recorddel.length; i++) {
	                                    fromulaTemplateStore.remove(recorddel[i]);
	                                }
	                            },
	                            failure: function() {
	                                Ext.Msg.alert("��ʾ", "ɾ��ʧ�ܣ�");
	                            }
	                        });
	                    }

	                    function delGridSel() {
	                        var dsm = detailGrid.getSelectionModel();
	                        dsm.deselectRange(0, 1000);
	                    }
	                    if (typeof (formulaTemplateWindow) == "undefined") {//�������2��windows����
	                        var formulaTemplateWindow = new Ext.Window({
	                            title: '�������㹫ʽģ��',
	                            modal: 'true',
	                            width: 600,
	                            height: 510,
	                            // autoHeight: true,
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
	                                    addFomula();
	                                    //  formulaTemplateWindow.hide();
	                                }
	                            }, {
	                                text: '�ر�',
	                                handler: function() {
	                                    formulaTemplateWindow.hide();
	                                    addFormulaTamplateForm.getForm().reset();
	                                    delGridSel();
	                                }
}]
	                            });
	                        }
	                        
	                        function modifyFormulaTemplate(rownum) {

	                            // alert(quotaGrid.getSelectionModel().getSelections()[selectData - 1].data.QuotaName);

	                            formulaTemplateWindow.show();



	                            var record = formulaTemplateGrid.getSelectionModel().getSelections()[rownum - 1].data;
	                            Ext.getCmp("Template_Name").setValue(record.TemplateName);
	                            Ext.getCmp("Note").setValue(record.Note);
	                            modify_quota_template_id = record.TemplateNo;
	                            Ext.Ajax.request({
	                                url: 'frmQtQualityTemplateCfg.aspx?method=getTemplateDetail'
                                               , params: {
                                                   templateno: modify_quota_template_id
                                               },
	                                //�ɹ�ʱ�ص�
	                                success: function(response, options) {
	                                    quotaIdArr = null;
	                                    quotaIdArr = '';
	                                    quotaIdstr = response.responseText;
	                                    quotaIdArr = (quotaIdstr.substring(1, quotaIdstr.length - 1)).split(",");

	                                    //  quotaIdArr = (quotaIdstr.substring(1, quotaIdstr.length - 1)).split(",");
	                                    //var record = formulaTemplateGrid.getSelectionModel();
	                                    var dsm = detailGrid.getSelectionModel();
	                                    dsm.clearSelections();
	                                    detailStore.each(function(detailStore, rec) {

	                                        var fno = detailStore.data.FormulaNo;
	                                        if (quotaIdstr.indexOf(',' + fno + ',') >= 0) {

	                                            dsm.selectRow(rec, true);
	                                        }

	                                    });



	                                },
	                                failure: function() {
	                                    Ext.Msg.alert("��ʾ", "��ȡģ����ϸ��Ϣʧ�ܣ�");
	                                }
	                            });



	                        }




	                        function addFomula() {

	                            var tname = Ext.getCmp('Template_Name').getValue();
	                            if (tname == null || tname.trim() == '') {
	                                Ext.Msg.alert("����", "ģ�����Ʋ���Ϊ�գ�");
	                                return;
	                            }
	                            var note = Ext.getCmp('Note').getValue();
	                         /*   if (note == null || note.trim() == '') {
	                                Ext.Msg.alert("����", "��ע����Ϊ�գ�");
	                                return;
	                            }*/
	                            var selectData = detailGrid.getSelectionModel().getCount();
	                            if (selectData == 0) {
	                                Ext.Msg.alert("��ʾ", "��ѡ����㹫ʽ��");
	                                return;
	                            }
	                            var ids = '';
	                            var delstr = '';
	                            var addstr = '';
	                            var record = detailGrid.getSelectionModel().getSelections();
	                         
	                            if (selectData == 1) {
	                                ids = record[0].data.FormulaNo;
	                            } else {
	                                for (var i = 0; i < selectData; i++) {
	                                    ids += record[i].data.FormulaNo + ',';
	                                }
	                                ids = ids.substring(0, ids.length - 1);
	                            }


	                            if (modify_quota_template_id != '' && modify_quota_template_id != null && addmark == 0) {
	                                
	                                var compareArr = ids.split(",");
	                                var compareStr = "," + ids + ',';
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
	                                    url: 'frmQtQualityTemplateCfg.aspx?method=modifyQuotaTemplate&code=Q034'
                                          , params: {
                                              tempName: tname,
                                              templateno: modify_quota_template_id,
                                              note: note,
                                              delstr: delstr,
                                              addstr: addstr
                                          },
	                                    //�ɹ�ʱ�ص� 
	                                    success: function(response, options) {
	                                        //��ȡ��Ӧ��json�ַ���

	                                        Ext.Msg.alert("��ʾ", "�޸ĳɹ���");
	                                        formulaTemplateWindow.hide();
	                                        addFormulaTamplateForm.getForm().reset();
	                                        delGridSel();
	                                        queryFormulaTemplate();
	                                    },
	                                    failure: function() {
	                                        Ext.Msg.alert("��ʾ", "�޸�ʧ�ܣ�");
	                                    }
	                                });



	                            } else {
	                                var qurl = 'frmQtFormulaTamplateCfg.aspx?method=addFmTemplate';
	                                Ext.Ajax.request({
	                                    url: qurl
                               , params: {
                                   tempName: tname,
                                   note: note,
                                   ids: ids
                               },
	                                    //�ɹ�ʱ�ص� 
	                                    success: function(response, options) {
	                                        //��ȡ��Ӧ��json�ַ���

	                                        Ext.Msg.alert("��ʾ", "����ɹ���");
	                                        formulaTemplateWindow.hide();
	                                        addFormulaTamplateForm.getForm().reset();
	                                        queryFormulaTemplate();

	                                    },
	                                    failure: function() {
	                                        Ext.Msg.alert("��ʾ", "����ʧ�ܣ�");
	                                    }
	                                });
	                            }

	                        }


	                        var formulaTemplate_form = new Ext.form.FormPanel({
	                            renderTo: "formulaTemplate_form",
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
	                                        fieldLabel: 'ģ������',
	                                        name: 'serchFormulaTemplateName',
	                                        id: 'serchFormulaTemplateName',

	                                        //  listeners: { click: function() { alert(1); } },
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
		            queryFormulaTemplate();
		        }
}]
}]
}]
	                                });


	                                var detailStore = new Ext.data.Store
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
	            { name: 'QuotaNote' }
			    ])
			   ,
			    listeners:
			      {
			          scope: this,
			          load: function() {

			          }
			      }
			});
	                                var detailsm = new Ext.grid.CheckboxSelectionModel(
            {
                singleSelect: false
            }
        );
	                                var detailGrid = new Ext.grid.GridPanel({
	                                    //width: '100%',
	                                    //height: '100%',
	                                    //autoWidth: true,
	                                    height: 360,
	                                    autoScroll: true,
	                                    layout: 'fit',
	                                    id: 'detailsmgrid',
	                                    store: detailStore,
	                                    loadMask: { msg: '���ڼ������ݣ����Ժ��' },
	                                    sm: detailsm,
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
                        detailsm,

                        new Ext.grid.RowNumberer(), //�Զ��к�
                                            {header: 'ָ���', dataIndex: 'FormulaNo',width:50 },
                                            { header: 'ָ���', hidden: true, dataIndex: 'QuotaNo' },
                                            //{ header: '������˾', dataIndex: 'OrgName' },
									        { header: 'ָ������', dataIndex: 'QuotaName',width:130 },
									        { header: '��ʽ', dataIndex: 'QuotaFormula',width:180 },
									        { header: '��λ', dataIndex: 'QuotaUnit',width:50 }
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

	                                    viewConfig: {
	                                        columnsText: '��ʾ����',
	                                        scrollOffset: 20,
	                                        sortAscText: '����',
	                                        sortDescText: '����',
	                                        forceFit: false
	                                    },


	                                    closeAction: 'hide',

	                                    stripeRows: true,
	                                    loadMask: true,
	                                    autoExpandColumn: 2
	                                });


	                                detailStore.load({
	                                    params: { start: 0, limit: 1000 }
	                                });
	                                var addFormulaTamplateForm = new Ext.form.FormPanel({
	                                    frame: true,
	                                    monitorValid: true, // ����formBind:true�İ�ť����֤��
	                                    labelWidth: 80,
	                                    items: [
                           {
                               items: [{
                                   layout: 'form',
                                   columnWidth: 1,  //����ռ�õĿ�ȣ���ʶΪ20��
                                   border: false,
                                   items: [{
                                       cls: 'key',
                                       xtype: 'textfield',
                                       fieldLabel: 'ģ������',
                                       name: 'Template_Name',
                                       id: 'Template_Name',
                                       anchor: '98%'
                                   }, {
                                       cls: 'key',
                                       xtype: 'textfield',
                                       fieldLabel: '��ע',
                                       name: 'Note',
                                       id: 'Note',
                                       anchor: '98%'
}]
}]
                                   }, {
                                       cls: 'key',
                                       fieldLabel: '��ʽѡ��',
                                       items: [detailGrid],
                                       anchor: '98%'
}]

	                                });
	                                formulaTemplateWindow.add(addFormulaTamplateForm);
	                                function queryFormulaTemplate() {
	                                    var formulaName = Ext.getCmp("serchFormulaTemplateName").getValue();
	                                    fromulaTemplateStore.baseParams.start=0;
	                                    fromulaTemplateStore.baseParams.limit=10;
	                                    fromulaTemplateStore.load({
	                                        params: {
	                                            key: formulaName
	                                        }
	                                    });
	                                }
	                                var fromulaTemplateStore = new Ext.data.Store
			                        ({
			                            url: 'frmQtQualityTemplateCfg.aspx?method=getTemplateList&code=Q034',
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
	                                var formulaTemplateGrid = new Ext.grid.GridPanel({
	                                    el: 'formulaTemplate_grid',
	                                    width: '100%',
	                                    height: '100%',
	                                    autoWidth: true,
	                                    autoHeight: true,
	                                    autoScroll: true,
	                                    layout: 'fit',
	                                    id: 'formulaTemplateGrid',
	                                    store: fromulaTemplateStore,
	                                    loadMask: { msg: '���ڼ������ݣ����Ժ��' },
	                                    sm: sm,

	                                    cm: new Ext.grid.ColumnModel([
                        sm,

                        new Ext.grid.RowNumberer(), //�Զ��к�
                                            {header: 'ģ��id', hidden: true, dataIndex: 'TemplateNo' },
									        { header: '��˾����', dataIndex: 'OrgName' },
									        { header: 'ģ������', dataIndex: 'TemplateName' },
											{ header: '��ע', dataIndex: 'Note' },
											{ header: '������', dataIndex: 'EmpName' },
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
	                                        store: fromulaTemplateStore,
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
	                                formulaTemplateGrid.render();



	                            }); 
		
	</script>
</html>
