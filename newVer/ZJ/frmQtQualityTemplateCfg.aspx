<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmQtQualityTemplateCfg.aspx.cs" Inherits="ZJ_frmQtQualityTemplateCfg" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=GB2312">
    <link rel="stylesheet" type="text/css" href="../ext3/resources/css/ext-all.css" />
	<script type="text/javascript" src="../ext3/adapter/ext/ext-base.js"></script>	
	<script type="text/javascript" src="../ext3/ext-all.js"></script>
	<script type="text/javascript" src="../js/ExtJsHelper.js"></script>

</head>
<body>
	<div id="quotaTemplate_toolbar"></div>
	 <div id="quotaTemplate_form"></div>
	 <div id="quotaTemplate_grid"></div>
</body><script>

           var quotaCount;
           var quotaArr = new Array();
           var addmark = 0;
           var quotaIdArr = null;
           var quotaIdstr = '';
           var modify_quota_template_id = "";
           Ext.BLANK_IMAGE_URL = "../ext3/resources/images/default/s.gif"; 
           Ext.onReady(function() {
               var Toolbar = new Ext.Toolbar({
                   renderTo: "quotaTemplate_toolbar",
                   items: [{
                       text: "����",
                       icon: '../Theme/1/images/extjs/customer/add16.gif',
                       handler: function() {
                           // saveType = "add";
                           // openAddQuotaWin();//����󣬵��������Ϣ����
                           addmark = 1;
                           quotaTemplateWindow.show();
                       }
                   }, '-', {
                       text: "�޸�",
                       icon: '../Theme/1/images/extjs/customer/edit16.gif',
                       handler: function() {

                           var selectData = quotaTemplateGrid.getSelectionModel().getCount();
                           if (selectData == 0) {
                               Ext.Msg.alert("��ʾ", "��ѡ��Ҫ�޸ĵļ�¼��");
                               return;
                           }
                           if (selectData > 1) {
                               Ext.Msg.alert("��ʾ", "һ��ֻ���޸�һ����¼��");
                               return;
                           }
                           addmark = 0;
                           modifyQuotaTemplate(selectData);
                           // modifyQuotaTemplate(selectData);
                       }
                   }, '-', {
                       text: "ɾ��",
                       icon: '../Theme/1/images/extjs/customer/delete16.gif',
                       handler: function() {
                           var selectData = quotaTemplateGrid.getSelectionModel().getCount();
                           if (selectData == 0) {
                               Ext.Msg.alert("��ʾ", "��ѡ��Ҫɾ�����У�");
                               return;
                           }
                           delQuotaTemplate(selectData);
                       }
}, '-', {
                       text: "ָ�����",
                       icon: '../Theme/1/images/extjs/customer/delete16.gif',
                       handler: function() {
                           var selectData = quotaTemplateGrid.getSelectionModel().getCount();
                           if (selectData == 0) {
                               Ext.Msg.alert("��ʾ", "��ѡ��ҪҪ���õ��ͺŹ��");
                               return;
                           }
                           loadQuotaTreeNotes();
                       }
}, '-', {
                       text: "���ָ��",
                       icon: '../Theme/1/images/extjs/customer/delete16.gif',
                       handler: function() {
                           var selectData = quotaTemplateGrid.getSelectionModel().getCount();
                           if (selectData == 0) {
                               Ext.Msg.alert("��ʾ", "��ѡ��ҪҪ���õ��ͺŹ��");
                               return;
                           }
                            var recorddel = quotaTemplateGrid.getSelectionModel().getSelections();
                           addTypeProduct(recorddel[0].data.TemplateNo);
                       }
}, '-', {
                       text: "��Ӧ����",
                       icon: '../Theme/1/images/extjs/customer/delete16.gif',
                       handler: function() {
                           var selectData = quotaTemplateGrid.getSelectionModel().getCount();
                           if (selectData == 0) {
                               Ext.Msg.alert("��ʾ", "��ѡ��ҪҪ��Ӧ���ֵ��ͺŹ��");
                               return;
                           }
                           loadSaltTreeNotes();
                       }
}]
                   });
                   
        addQuotasWin = null;
        function addTypeProduct(templateNo) {
            if (addQuotasWin == null) {
                addQuotasWin = ExtJsShowWin('��ӱ�׼ָ����Ϣ', 'frmQuotaItemSelect.aspx?TemplateNo=1&pkId=' + templateNo, 'add', 800, 500);
                addQuotasWin.show();
            }
            else {
                addQuotasWin.show();
                document.getElementById("iframeadd").contentWindow.pkId = templateNo;
                document.getElementById("iframeadd").contentWindow.loadData();
            }
        }
                   
                   
                   if (typeof (quotaTemplateWindow) == "undefined") {//�������2��windows����
                       var quotaTemplateWindow = new Ext.Window({
                           title: '��������׼',
                           modal: 'true',
                           width: 600,
                           x:50,
                           y:50,
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
                                   addNewTemplate();
                                   //quotaTemplateWindow.hide();
                               }
                           }, {
                               text: '�ر�',
                               handler: function() {
                                   quotaTemplateWindow.hide();
                                   addQuotaTamplateForm.getForm().reset();
                               }
}]
                           });
                       }

                       var addQuotaTamplateForm = new Ext.form.FormPanel({
                           frame: true,
                           monitorValid: true, // ����formBind:true�İ�ť����֤��
                           labelWidth: 80,
                           items: [
                           {

                               layout: 'form',
                               xtype: "fieldset",
                               title: '��ӱ�׼ģ��',

                               items: [{
                                   layout: 'form',
                                   columnWidth: 1,  //����ռ�õĿ�ȣ���ʶΪ20��
                                   border: false,
                                   items: [ {
                                       cls: 'key',
                                       xtype: 'textfield',
                                       fieldLabel: "��׼����<font color='red'>*</font>",
                                       name: 'Template_Name',
                                       id: 'Template_Name',
                                       anchor: '98%'
                                   }, {
                                       cls: 'key',
                                       xtype: 'textfield',
                                       fieldLabel: "ִ�б�׼<font color='red'>*</font>",
                                       name: 'Template_Standard',
                                       id: 'Template_Standard',
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
                                       fieldLabel: '����ָ����',
                                       anchor: '98%'
}]

                                   });

                                   Ext.Ajax.request({
                                       url: 'frmQtQualityTemplateCfg.aspx?method=getQuota'
                                       , params: {},
                                       //�ɹ�ʱ�ص� 
                                       success: function(response, options) {
                                           //��ȡ��Ӧ��json�ַ���

                                           if (response != null && response.responseText != 'undefined' && response.responseText != null && response.responseText != '') {
                                               var data = Ext.util.JSON.decode(response.responseText);
                                               var panelstr = "new Ext.Panel({labelWidth: 30,autoWidth: true,height:200,autoScroll:true,layout: 'column', items: [";


                                               quotaCount = data.length;
                                               for (var i = 0; i < quotaCount; i++) {
                                                   quotaArr[i] = data[i].QuotaNo;

                                                   //    addQuotaForm.items.add(eval("quotaCheckBox" + i + "= new Ext.form.Checkbox({cls:'key',value:'" + data[i].QuotaNo + "',boxLabel:'" + data[i].QuotaName + " " + data[i].QuotaUnit + "',name: '" + data[i].QuotaNo + "', id: 'quotaCheckBox" + i + "',anchor: '90%'});"));
                                                   panelstr += " {style: 'align:left',columnWidth: .5,layout: 'form',border: false,items: [{cls: 'key', value:'" + data[i].QuotaNo + "' ,xtype: 'checkbox',boxLabel: '" + data[i].QuotaName + " " + data[i].QuotaUnit + "',name: '" + data[i].QuotaNo + "',id: '" + data[i].QuotaNo + "',anchor: '95%'}]},";
                                               }
                                               panelstr = panelstr.substring(0, panelstr.length - 1);
                                               panelstr += "]})";

                                               addQuotaTamplateForm.add(eval(panelstr));
                                           }

                                       },
                                       failure: function() {
                                           Ext.Msg.alert("��ʾ", "��ȡָ�����������,�����´򿪸�ҳ��");
                                       }
                                   });

                                   quotaTemplateWindow.add(addQuotaTamplateForm);


                                   function addNewTemplate() {

                                       /*   var company = company.getValue();
                                       if (company == null || company.trim() == '' || company == 'undefined') {
                                       Ext.Msg.alert("����", "��ѡ��˾��");
                                       return;
                                       }*/

                                       var tempName = Ext.getCmp("Template_Name").getValue();
                                       if (tempName == null || tempName.trim() == '') {
                                           Ext.Msg.alert("����", "ģ�����Ʋ���Ϊ�գ�");
                                           return;
                                       }
                                       var Note = Ext.getCmp("Note").getValue();
                                       var Standard=Ext.getCmp("Template_Standard").getValue();
                                       /*if (Note == null || Note.trim() == '') {
                                           Ext.Msg.alert("����", "��ע����Ϊ�գ�");
                                           return;
                                       }*/
                                       var tempIds = "";
                                       var idmark = 0;
                                       var delstr = '';
                                       var addstr = '';
                                       for (var y = 0; y < quotaCount; y++) {
                                           if (Ext.get(quotaArr[y]).dom.checked) {
                                               tempIds += Ext.getCmp(quotaArr[y]).name + ',';
                                               idmark++;
                                           }

                                       }
                                       if (idmark == 0) {
                                           Ext.Msg.alert("��ʾ", "������ѡ��һ��ָ�������");
                                           return;
                                       }
                                       var compareStr = "," + tempIds
                                       tempIds = tempIds.substring(0, tempIds.length - 1);
                                       var compareArr = tempIds.split(",");

                                       if (modify_quota_template_id != '' && modify_quota_template_id != null && addmark == 0) {

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
                                           url: 'frmQtQualityTemplateCfg.aspx?method=modifyQuotaTemplate&code=Q032'
                                          , params: {
                                              tempName: tempName,
                                              templateno: modify_quota_template_id,
                                              note: Note,
                                              Standard:Standard,
                                              delstr: delstr,
                                              addstr: addstr
                                          },
                                               //�ɹ�ʱ�ص� 
                                               success: function(response, options) {
                                                   //��ȡ��Ӧ��json�ַ���

                                                   Ext.Msg.alert("��ʾ", "�޸ĳɹ���");
                                                   quotaTemplateWindow.hide();
                                                   addQuotaTamplateForm.getForm().reset();
                                                   var serchQuotaTemplateName = Ext.getCmp("serchQuotaTemplateName").getValue();
                                                   
                                                   quotaTemplateStore.baseParams.start=0;
                                                   quotaTemplateStore.baseParams.limit=100;
                                                   quotaTemplateStore.load({
                                                       params: {
                                                           key: serchQuotaTemplateName
                                                       }
                                                   })
                                               },
                                               failure: function() {
                                                   Ext.Msg.alert("��ʾ", "��ȡָ�����������,�����´򿪸�ҳ��");
                                               }
                                           });



                                       } else {

                                           Ext.Ajax.request({
                                               url: 'frmQtQualityTemplateCfg.aspx?method=addQuotaTemplate'
                                       , params: {
                                           tempName: tempName,
                                           note: Note,
                                            Standard:Standard,
                                           ids: tempIds
                                       },
                                               //�ɹ�ʱ�ص� 
                                               success: function(response, options) {
                                                   //��ȡ��Ӧ��json�ַ���

                                                   Ext.Msg.alert("��ʾ", "����ɹ���");
                                                   quotaTemplateWindow.hide();
                                                   addQuotaTamplateForm.getForm().reset();
                                                   var serchQuotaTemplateName = Ext.getCmp("serchQuotaTemplateName").getValue();
                                                   
                                                   quotaTemplateStore.baseParams.start=0;
                                                   quotaTemplateStore.baseParams.limit=10;
                                                   quotaTemplateStore.load({
                                                       params: {
                                                           key: serchQuotaTemplateName
                                                       }
                                                   })
                                               },
                                               failure: function() {
                                                   Ext.Msg.alert("��ʾ", "��ȡָ�����������,�����´򿪸�ҳ��");
                                               }
                                           });
                                       }
                                   }

                                   var quotaTemplate_form = new Ext.form.FormPanel({
                                       renderTo: "quotaTemplate_form",
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
                                                   name: 'serchQuotaTemplateName',
                                                   id: 'serchQuotaTemplateName',
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
		            queryTemplate();
		        }
}]
}]
}]
                                           });

                                           function queryTemplate() {
                                               var serchQuotaTemplateName = Ext.getCmp("serchQuotaTemplateName").getValue();
                                               
                                               quotaTemplateStore.baseParams.start=0;
                                               quotaTemplateStore.baseParams.limit=10;
                                               quotaTemplateStore.load({
                                                   params: {
                                                       key: serchQuotaTemplateName
                                                   }
                                               })
                                           }

                                           var quotaTemplateStore = new Ext.data.Store
			({
                                           url: 'frmQtQualityTemplateCfg.aspx?method=getTemplateList&code=Q032',
			    reader: new Ext.data.JsonReader({
			        totalProperty: 'totalProperty',
			        root: 'root'
			    }, [
			    { name: 'TemplateNo' },
			    { name: 'OrgName' },
	            { name: 'TemplateName' },
	            { name: 'TemplateStandard' },
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
                                           var quotaTemplateGrid = new Ext.grid.GridPanel({
                                               el: 'quotaTemplate_grid',
                                               width: '100%',
                                               height: '100%',
                                               autoWidth: true,
                                               autoHeight: true,
                                               autoScroll: true,
                                               layout: 'fit',
                                               id: 'quotaTemplateGrid',
                                               store: quotaTemplateStore,
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
                                            {header: 'ģ��id', hidden: true, dataIndex: 'TemplateNo' },
									        //{ header: '��˾����', dataIndex: 'OrgName' },
									        { header: '��׼����', dataIndex: 'TemplateName' },
											{ header: 'ִ�б�׼', dataIndex: 'TemplateStandard' }, 
											{ header: '��Ӧ����', dataIndex: 'Note' }, 
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
                   store: quotaTemplateStore,
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
           quotaTemplateGrid.render();

queryTemplate();
function delQuotaTemplate(rownum) {
   var ids = "";
   var recorddel = quotaTemplateGrid.getSelectionModel().getSelections();
   if (rownum == 1) {
       ids = recorddel[0].data.TemplateNo;
   } else {
       for (var i = 0; i < rownum; i++) {
           ids += recorddel[i].data.TemplateNo + ',';
       }
       ids = ids.substring(0, ids.length - 1);
   }
//ɾ��ǰ�ٴ������Ƿ����Ҫɾ��
    Ext.Msg.confirm("��ʾ��Ϣ", "�Ƿ����Ҫɾ��ѡ���������Ϣ��", function callBack(id) {
        //�ж��Ƿ�ɾ������
        if (id == "yes") {
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
               quotaTemplateStore.remove(recorddel[i]);
           }


       },
       failure: function() {
           Ext.Msg.alert("��ʾ", "ɾ��ʧ�ܣ�");
       }
   });
   }
   });
}



function modifyQuotaTemplate(rownum) {

   // alert(quotaGrid.getSelectionModel().getSelections()[selectData - 1].data.QuotaName);

   quotaTemplateWindow.show();
   var record = quotaTemplateGrid.getSelectionModel().getSelections()[rownum - 1].data;
   Ext.getCmp("Template_Name").setValue(record.TemplateName);
   Ext.getCmp("Note").setValue(record.Note);
   Ext.getCmp("Template_Standard").setValue(record.TemplateStandard);
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
           for (var z = 0; z < quotaIdArr.length; z++) {

               Ext.get(quotaIdArr[z]).dom.checked = true

           }
       },
       failure: function() {
           Ext.Msg.alert("��ʾ", "��ȡģ����ϸ��Ϣʧ�ܣ�");
       }
   });
}

/*��ָ����Ŀ�����������Ա���õ���ʾ*/
var Tree = Ext.tree;
    var tree = new Tree.TreePanel({
        useArrows:true,
        autoScroll:true,
        animate:true,
        width:150,
        autoHeight:true,
        enableDD:true,
        containerScroll: true, 
        loader: new Tree.TreeLoader({
           dataUrl:'frmQtQualityTemplateCfg.aspx?method=getQuotaTreeByTemplate'
           }),
        root:new Tree.AsyncTreeNode({
                text: 'ָ����Ϣ',
                draggable:true
            })
    });
 
 var selectedNode
 tree.on('click',function(node){  
       selectedNode = node;
 });
function loadQuotaTreeNotes()
{
    var record = quotaTemplateGrid.getSelectionModel().getSelections()[0].data;
    tree.getLoader().on("beforeload", function(treeLoader, node) {
                            treeLoader.baseParams.TemplateNo = record.TemplateNo;
                        }, this);
                            tree.root.reload();
    quotaTemplateQuotasWindow.show();
}

var templateQuotaForm = new Ext.Panel(   
 { 
   frame:true,
   border:true, 
   width:'100%',
   layout:'table',            
   layoutConfig:{columns:5},//���������ֳ�3��
   items:[
    { layout: 'table', layoutConfig: { columns: 5 }, items: tree}
   ]
  }   
 );
 
 if (typeof (quotaTemplateQuotasWindow) == "undefined") {//�������2��windows����
       var quotaTemplateQuotasWindow = new Ext.Window({
           title: '����ͺŶ�Ӧָ�����',
           modal: 'true',
           width: 300,
           x:50,
           y:50,
           //height: 273,
           collapsible: true, //�Ƿ�����۵� 
           closable: true, //�Ƿ���Թر� 
           //maximizable : true,//�Ƿ������� 
           closeAction: 'hide',
           constrain: true,
           resizable: false,
           plain: true,
           items: templateQuotaForm,
           buttons: [{
               text: '����',
               handler: function() {
                   saveTemplateQuotas();
                   quotaTemplateQuotasWindow.hide();
               }
           }, {
               text: '�ر�',
               handler: function() {
                   quotaTemplateQuotasWindow.hide();
               }
            }]
        });
    }
    
function saveTemplateQuotas()
{
    var childs="";
    for(var i=0;i<tree.root.childNodes.length;i++)
    {
        if(childs.length>0)
            childs+=",";
        childs+=tree.root.childNodes[i].id;
    }
    var record = quotaTemplateGrid.getSelectionModel().getSelections()[0].data;
    Ext.Ajax.request({
       url: 'frmQtQualityTemplateCfg.aspx?method=saveTemplateQuotas'
   , params: {
       TemplateNo: record.TemplateNo,
       QuotaNo:childs
   },
       //�ɹ�ʱ�ص�
       success: function(response, options) {
           Ext.Msg.alert("��ʾ","���ݵ����ɹ���");
       },
       failure: function() {
           Ext.Msg.alert("��ʾ", "��ȡģ����ϸ��Ϣʧ�ܣ�");
       }
   });
}

/* �����ͺŶ�Ӧ����Ʒ��Ϣ */
var treeSalt = new Tree.TreePanel({
        useArrows:true,
        autoScroll:true,
        animate:true,
        width:250,
        autoHeight:true,
        enableDD:false,
        containerScroll: true, 
        loader: new Tree.TreeLoader({
           dataUrl:'frmQtQualityTemplateCfg.aspx?method=getSaltTree'
           }),
        root:new Tree.AsyncTreeNode({
                text: 'ָ����Ϣ',
                draggable:true
            })
    });

function loadSaltTreeNotes()
{
    var record = quotaTemplateGrid.getSelectionModel().getSelections()[0].data;
    treeSalt.getLoader().on("beforeload", function(treeLoader, node) {
        treeLoader.baseParams.TemplateNo = record.TemplateNo;
    }, this);
    treeSalt.root.reload();
    quotaTemplateSaltWindow.show();
}

var templateSaltForm = new Ext.Panel(   
 { 
   frame:true,
   border:true, 
   width:'100%',
   layout:'table',            
   layoutConfig:{columns:5},//���������ֳ�3��
   items:[
    { layout: 'table', layoutConfig: { columns: 5 }, items: treeSalt}
   ]
  }   
 );
 
 if (typeof (quotaTemplateSaltWindow ) == "undefined") {//�������2��windows����
       var quotaTemplateSaltWindow  = new Ext.Window({
           title: '����ͺŶ�Ӧָ�����',
           modal: 'true',
           width: 300,
           x:50,
           y:50,
           //height: 273,
           collapsible: true, //�Ƿ�����۵� 
           closable: true, //�Ƿ���Թر� 
           //maximizable : true,//�Ƿ������� 
           closeAction: 'hide',
           constrain: true,
           resizable: false,
           plain: true,
           items: templateSaltForm,
           buttons: [{
               text: '����',
               handler: function() {
                   saveTemplateSalt();
                   quotaTemplateSaltWindow.hide();
               }
           }, {
               text: '�ر�',
               handler: function() {
                   quotaTemplateSaltWindow.hide();
               }
            }]
        });
    }

function getSaltSelectNodes() {
    var selectNodes = treeSalt.getChecked();
    var saltIds = "";
    for (var i = 0; i < selectNodes.length; i++) {
        if (saltIds.length > 0)
            saltIds += ",";
        saltIds += selectNodes[i].id;
    }
    return saltIds;
}

function saveTemplateSalt()
{
    var childs=getSaltSelectNodes();
    var record = quotaTemplateGrid.getSelectionModel().getSelections()[0].data;
    Ext.Ajax.request({
       url: 'frmQtQualityTemplateCfg.aspx?method=saveSalt'
   , params: {
       TemplateNo: record.TemplateNo,
       SaltId:childs
   },
       //�ɹ�ʱ�ص�
       success: function(response, options) {
           Ext.Msg.alert("��ʾ","���ݵ����ɹ���");
       },
       failure: function() {
           Ext.Msg.alert("��ʾ", "��ȡģ����ϸ��Ϣʧ�ܣ�");
       }
   });
}
}); 

	</script>
</html>
