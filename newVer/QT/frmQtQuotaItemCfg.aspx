<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmQtQuotaItemCfg.aspx.cs" Inherits="QT_frmQtQuotaItemCfg" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=GB2312">
    <link rel="stylesheet" type="text/css" href="../ext3/resources/css/ext-all.css" />
	<script type="text/javascript" src="../ext3/adapter/ext/ext-base.js"></script>	
	<script type="text/javascript" src="../ext3/ext-all.js"></script>
</head>
<body>
	<div id="quota_toolbar"></div>
	 <div id="quota_form"></div>
	 <div id="quota_grid"></div>
</body>
<script>
var modify_quota_id = 'none';
var addmark = 0;
Ext.BLANK_IMAGE_URL = "../ext3/resources/images/default/s.gif";
Ext.onReady(function() {
   var Toolbar = new Ext.Toolbar({
       renderTo: "quota_toolbar",
       items: [{
           id:'addBtn',
           text: "����",
           icon: '../Theme/1/images/extjs/customer/add16.gif',
           handler: function() {
               // saveType = "add";
               // openAddQuotaWin();//����󣬵��������Ϣ����
               addmark = 1;
               quotaWindow.show();
               Ext.getCmp('Quota_Org').hide();
               Ext.getCmp('Quota_Org').getEl().up('.x-form-item').setDisplayed(false);
               addQuotaForm.getForm().reset();
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
               Ext.getCmp('Quota_Org').hide();
               Ext.getCmp('Quota_Org').getEl().up('.x-form-item').setDisplayed(false);
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
        }, '-', {
           id:'distBtn',
           text: "ָ�����",
           icon: '../Theme/1/images/extjs/customer/add16.gif',
           handler: function() {

               var selectData = quotaGrid.getSelectionModel().getCount();
               if (selectData == 0) {
                   Ext.Msg.alert("��ʾ", "��ѡ��Ҫ�����ָ���У�");
                   return;
               }
               addmark = -1;
               modifyQuota(selectData);
               var OrgFilterCombo = new Ext.form.ComboBox({
                    store: dsOrgs,
                    displayField: 'OrgShortName',
                    displayValue: 'OrgId',
                    typeAhead: false,
                    minChars: 1,
                    loadingText: 'Searching...',
                    tpl: resultTpl,
                    pageSize: 10,
                    listWidth:300,
                    hideTrigger: true,
                    applyTo: 'Quota_Org',
                    itemSelector: 'div.search-item',
                    onSelect: function(record) { // override default onSelect to do redirect  
                        Ext.getCmp('Quota_Org').setValue(record.data.OrgShortName);
                        Ext.getCmp('Quota_OrgId').setValue(record.data.OrgId);
                        this.collapse();
                    }
                });
               Ext.getCmp('Quota_Org').show();
               Ext.getCmp('Quota_Org').getEl().up('.x-form-item').setDisplayed(true);
           }
        }]
    });
    if (typeof (quotaWindow) == "undefined") {//�������2��windows����
       var quotaWindow = new Ext.Window({
           title: '����ָ��',
           modal: 'true',
           width: 300,
           //height: 273,
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

                   addQuota();

               }
           }, {
               text: '�ر�',
               handler: function() {
                   quotaWindow.hide();
                   addQuotaForm.getForm().reset();
               }
            }]
        });
    }


   //ָ������
   var Quota_TypeCombo = new Ext.form.ComboBox({
       xtype: 'combo',
       store: new Ext.data.Store({
           autoLoad: true,
           baseParams: {
               trancode: 'Menu'
           },
           proxy: new Ext.data.HttpProxy({
               url: 'frmQtQuotaItemCfg.aspx?method=getType&key=Quota'
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
       blankText: 'ָ�����Ͳ���Ϊ��',
       forceSelection: true,
       emptyText: '��ѡ��ָ������',
       editable: false,
       triggerAction: 'all',
       fieldLabel: 'ָ������',
       selectOnFocus: true,
       anchor: '90%'
   });

   //ָ������
   var QuotaItem_TypeCombo = new Ext.form.ComboBox({
       xtype: 'combo',
       store: new Ext.data.Store({
           autoLoad: true,
           baseParams: {
               trancode: 'Menu'
           },
           proxy: new Ext.data.HttpProxy({
               url: 'frmQtQuotaItemCfg.aspx?method=getType&key=Item'
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
       blankText: 'ָ�������Ͳ���Ϊ��',
       forceSelection: true,
       emptyText: '��ѡ��ָ��������',
       editable: false,
       triggerAction: 'all',
       fieldLabel: 'ָ��������',
       selectOnFocus: true,
       anchor: '90%'
   });

    //�ؼ�����
   var Control_TypeCombo = new Ext.form.ComboBox({
       xtype: 'combo',
       store: new Ext.data.Store({
           autoLoad: true,
           baseParams: {
               trancode: 'Menu'
           },
           proxy: new Ext.data.HttpProxy({
               url: 'frmQtQuotaItemCfg.aspx?method=getType&key=Control'
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
       blankText: '�ؼ����Ͳ���Ϊ��',
       forceSelection: true,
       emptyText: '��ѡ��ؼ�����',
       editable: false,
       triggerAction: 'all',
       fieldLabel: '�ؼ�����',
       selectOnFocus: true,
       anchor: '90%'
   });
   //����ͻ��������첽���÷���            
    var dsOrgs;
    if (dsOrgs == null) {
        dsOrgs = new Ext.data.Store({
            url: 'frmQtQuotaItemCfg.aspx?method=getOrgs',
            reader: new Ext.data.JsonReader({
                root: 'root',
                totalProperty: 'totalProperty'
            }, [
                    { name: 'OrgId', mapping: 'OrgId' },
                    { name: 'OrgCode', mapping: 'OrgCode' },
                    { name: 'OrgShortName', mapping: 'OrgShortName' }
                ])
        });
    }
   // ������֯�������첽������ʾģ��
    var resultTpl = new Ext.XTemplate(
            '<tpl for="."><div id="searchkhdivid" class="search-item">',
                '<h3><span>��ţ�{OrgCode} ���ƣ� {OrgShortName}</span> ',
    //'<br>����ʱ�䣺{createDate}',  
            '</div></tpl>'
    );
    
   
   //�޸�ָ��
   function modifyQuota(rownum) {
       // alert(quotaGrid.getSelectionModel().getSelections()[selectData - 1].data.QuotaName);
       quotaWindow.show();
       var record = quotaGrid.getSelectionModel().getSelections()[rownum - 1].data;
       Ext.getCmp("Quota_Name").setValue(record.QuotaName);
       Ext.getCmp("Quota_Alias").setValue(record.QuotaAlias);
       Ext.getCmp("Quota_Unit").setValue(record.QuotaUnit);
       Ext.getCmp("Sort_Id").setValue(record.SortId);
       Control_TypeCombo.setValue(record.ControlType);
       Quota_TypeCombo.setValue(record.QuotaType);
       QuotaItem_TypeCombo.setValue(record.ItemType);
       modify_quota_id = record.QuotaNo;
   }

   function delQuota(rownum) {
       var ids = "";
       var recorddel = quotaGrid.getSelectionModel().getSelections();
       if (rownum == 1) {
           ids = recorddel[0].data.QuotaNo;
       } else {
           for (var i = 0; i < rownum; i++) {
               ids += recorddel[i].data.QuotaNo + ',';
           }
           ids = ids.substring(0, ids.length - 1);
       }
       Ext.Ajax.request({
       url: 'frmQtQuotaItemCfg.aspx?method=delQuota'
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

  //����ָ��
   function addQuota() {
       var Quota_Name = Ext.getCmp("Quota_Name").getValue();
       if (Quota_Name == null || Quota_Name.trim() == '') {
           Ext.Msg.alert("����", "ָ�����Ʋ���Ϊ�գ�");
           return;
       }
       var Quota_Alias = Ext.getCmp("Quota_Alias").getValue();
        if (Quota_Alias == null || Quota_Alias.trim() == '') {
       Ext.Msg.alert("����", "ָ��Ӣ�����Ʋ���Ϊ�գ�");
       return;
       }  

       var Quota_Unit = Ext.getCmp("Quota_Unit").getValue();
       /* if (Quota_Unit == null || Quota_Unit.trim() == '') {
       Ext.Msg.alert("����", "��λ����Ϊ�գ�");
       return;
       }
      */
       var Quota_Type = Quota_TypeCombo.getValue();
       if (Quota_Type == null || Quota_Type.trim() == '' || Quota_Type == 'undefined') {
       Ext.Msg.alert("����", "��ѡ��ָ�����ͣ�");
       return;
       }
       var Control_Type = Control_TypeCombo.getValue();
       if (Control_Type == null || Control_Type.trim() == '' || Control_Type == 'undefined') {
       Ext.Msg.alert("����", "��ѡ��ؼ����ͣ�");
       return;
       }
       var QuotaItem_Type = QuotaItem_TypeCombo.getValue();
       if (QuotaItem_Type == null || QuotaItem_Type.trim() == '' || QuotaItem_Type == 'undefined') {
       Ext.Msg.alert("����", "��ѡ��ؼ����ͣ�");
       return;
       }
       
       var Quota_OrgId = Ext.getCmp('Quota_OrgId').getValue();
      
       var Sort_Id = Ext.getCmp("Sort_Id").getValue();
       /* if (Sort_Id == null || Sort_Id.trim() == '') {
       Ext.Msg.alert("����", "������Ų���Ϊ�գ�");
       return;
       }*/
       var qurl = 'frmQtQuotaItemCfg.aspx?method=addQuota';

       if (modify_quota_id != '' && modify_quota_id != null && addmark <= 0) {
           qurl = 'frmQtQuotaItemCfg.aspx?method=updateQuota&quotano=' + modify_quota_id;
       }

       Ext.Ajax.request({
           url: qurl
           , params: {
               QuotaName: Quota_Name
           , QuotaAlias: Quota_Alias
           , QuotaUnit: Quota_Unit
           , QuotaType: Quota_Type
           , ControlType: Control_Type
           , ItemType: QuotaItem_Type
           , SortId: Sort_Id
           , QuotaOrgId: Quota_OrgId
           },
           //�ɹ�ʱ�ص� 
           success: function(response, options) {
               //��ȡ��Ӧ��json�ַ���

               Ext.Msg.alert("��ʾ", "����ɹ���");
               quotaWindow.hide();
               addQuotaForm.getForm().reset();

               var serchQuotaName = Ext.getCmp("serchQuotaName").getValue();
               customerListStore.baseParams.start=0;
               customerListStore.baseParams.limit=10;
               customerListStore.baseParams.key=serchQuotaName;
               customerListStore.load();
           },
           failure: function() {
               Ext.Msg.alert("��ʾ", "����ʧ�ܣ�");
           }
       });

   }

/**********************************************************/
   var addQuotaForm = new Ext.form.FormPanel({
       frame: true,
       monitorValid: true, // ����formBind:true�İ�ť����֤��
       labelWidth: 100,
       items: [{
           layout: 'form',
           layout: 'column',
           items: [{
               layout: 'form',
               columnWidth: 1,  //����ռ�õĿ�ȣ���ʶΪ20��
               border: false,
               items: [{
                   cls: 'key',
                   xtype: 'textfield',
                   fieldLabel: 'ָ������������',
                   name: 'Quota_Name',
                   id: 'Quota_Name',
                   anchor: '90%'
               }, {
                   cls: 'key',
                   xtype: 'textfield',
                   fieldLabel: 'ָ����Ӣ������',
                   name: 'Quota_Alias',
                   id: 'Quota_Alias',
                   anchor: '90%'
               }, {
                   cls: 'key',
                   xtype: 'textfield',
                   fieldLabel: '��λ',
                   name: 'Quota_Unit',
                   id: 'Quota_Unit',
                   anchor: '90%'
               }, Quota_TypeCombo, Control_TypeCombo, QuotaItem_TypeCombo,{
                   cls: 'key',
                   xtype: 'textfield',
                   fieldLabel: '�������',
                   name: 'Sort_Id',
                   id: 'Sort_Id',
                   anchor: '90%'
                },{
                   cls: 'key',
                   xtype: 'textfield',
                   fieldLabel: '��֯',
                   name: 'Quota_Org',
                   id: 'Quota_Org',
                   anchor: '90%'
               },{
                   cls: 'key',
                   xtype: 'hidden',
                   name: 'Quota_OrgId',
                   id: 'Quota_OrgId'
               }]
            }]
        }]
    });
    quotaWindow.add(addQuotaForm);
    var quota_form = new Ext.form.FormPanel({
       renderTo: "quota_form",
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
                   fieldLabel: 'ָ������',
                   name: 'serchQuotaName',
                   id: 'serchQuotaName',
                   anchor: '80%'
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
		                queryzbx();
		            }
                }]
            }]
        }]
    });

   function queryzbx() {
       var serchQuotaName = Ext.getCmp("serchQuotaName").getValue();
       customerListStore.baseParams.start=0;
       customerListStore.baseParams.limit=10;
       customerListStore.baseParams.key=serchQuotaName;
       customerListStore.load({})
   }
   var customerListStore = new Ext.data.Store
	({
	    url: 'frmQtQuotaItemCfg.aspx?method=queryQuota',
	    reader: new Ext.data.JsonReader({
	        totalProperty: 'totalProperty',
	        root: 'root'
	    }, [
	    { name: 'QuotaNo' },
        { name: 'QuotaName' },
        { name: 'QuotaAlias' },
	    { name: 'QuotaUnit' },
        { name: 'QuotaType' },
        { name: 'ItemType' },
        //{ name: 'QuotaTypeName'},
        {name: 'ControlType' },
        { name: 'DicsName' },
        //{ name: 'ControlTypeName'},
	    { name: 'SortId'},
        { name: 'CreateDate'},
	    { name: 'OperName' },
	     { name: 'EmpName' }
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
    {        singleSelect: false    } );
   var quotaGrid = new Ext.grid.GridPanel({
       el: 'quota_grid',
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
        { header: 'ָ���', hidden: true, dataIndex: 'QuotaNo' },
        { header: 'ָ������', dataIndex: 'QuotaName' },
        { header: 'ָ�����', hidden: true, dataIndex: 'QuotaAlias' },
        { header: '��λ', dataIndex: 'QuotaUnit' },
		{ header: 'ָ�����', dataIndex: 'QuotaType', hidden: true },
		{ header: 'ָ��������', dataIndex: 'ItemType', hidden: true },
		//{ header: 'ָ������', dataIndex: 'QuotaTypeName' },
		{ header: '�ؼ�����', dataIndex: 'ControlType' ,hidden: true },
		{ header: '�ؼ�����', dataIndex: 'DicsName' },
		{ header: '�����', dataIndex: 'SortId' },
		{ header: '��������', dataIndex: 'CreateDate' },
		{ header: '������', dataIndex: 'EmpName' }
	]), 
	listeners:
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
   function openAddQuotaWin() {
       quotaWindow.show();
   }
   if(<%=ZJSIG.UIProcess.ADM.UIAdmUser.OrgID(this)%> !=1){
    Ext.getCmp('distBtn').hide();
    Ext.getCmp('addBtn').hide();
   }
}); 
		
	</script>
</html>
