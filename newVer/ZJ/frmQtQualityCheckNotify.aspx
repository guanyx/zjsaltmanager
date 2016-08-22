<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmQtQualityCheckNotify.aspx.cs" Inherits="QT_frmQtQualityCheckNotify" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=GB2312">
    <link rel="stylesheet" type="text/css" href="../ext3/resources/css/ext-all.css" />
	<script type="text/javascript" src="../ext3/adapter/ext/ext-base.js"></script>	
	<script type="text/javascript" src="../ext3/ext-all.js"></script>
    <style type="text/css">
    .x-grid-tanstype1 { 
    color:#6b9aed; 
    }
    .x-grid-tanstype2 { 
    color:blue; 
    }
    </style>
</head>
<body>
	 <div id="notify_toolbar"></div>
	 <div id="notify_form"></div>
	 <div id="notify_grid"></div>
</body><script>
           Ext.BLANK_IMAGE_URL = "../ext3/resources/images/default/s.gif";
           var modify_quota_id = 'none';
           var allstr = "";
           var modify_pname = "";
           var modify_prno_id = "none";
           var addmark = 0;
           var detaillength = 0;
           var idsstr="";
           var therecord;
           var printstr = "";
           var confirmlevel;
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
           
           var states = [
                    ['1', '�ʼ����'],
                    ['0', '�ʼ�δ���'],
                    ['2', '�������']
                         ];
           var checkType =[['Q091','�ɹ��ʼ�'],['Q092','�����ʼ�'],['Q093','�������']
                ];
                
           var statusType =[['0','δȷ��'],['1','һ����ȷ��'],['2','������ȷ��']
                ];

           Ext.onReady(function() {
               var Toolbar = new Ext.Toolbar({
                   renderTo: "notify_toolbar",
                   items: [{
                       text: "���ɳ��鱨��",
                       icon: '../Theme/1/images/extjs/customer/edit16.gif',
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
                   }, '-', {
                       text: "һ��ȷ��",
                       icon: '../Theme/1/images/extjs/customer/edit16.gif',
                       handler: function() {
                           var optionData = quotaGrid.getSelectionModel().getCount();
                           if (optionData == 0) {
                               Ext.Msg.alert("��ʾ", "��ѡ��Ҫȷ�ϵļ�¼��");
                               return;
                           }
                           if (optionData > 1) {
                               Ext.Msg.alert("��ʾ", "һ��ֻ��ȷ��һ����¼��");
                               return;
                           }
                           var record = quotaGrid.getSelectionModel().getSelections()[0].data;
                           if (record.CheckStatus == 0 || record.CheckStatus == '0') {
                               Ext.Msg.alert("��ʾ", "�ü�¼δ�����ʼ죬���Ƚ����ʼ죡");
                               return;
                           }
                           if (record.CheckStatus == 1 || record.CheckStatus == '1') {
                               Ext.Msg.alert("��ʾ", "�ü�¼δ���ʼ챨�棬�������ɳ��鱨�棡");
                               return;
                           }
                           if (record.CkStatus == 1 || record.CkStatus == '1') {
                               Ext.Msg.alert("��ʾ", "�ü�¼�Ѿ�����һ��ȷ�ϣ�");
                               return;
                           }
                           if (record.CkStatus == 2 || record.CkStatus == '2') {
                               Ext.Msg.alert("��ʾ", "�ü�¼�Ѿ����ж���ȷ�ϣ�����Ҫ����һ��ȷ�ϣ�");
                               return;
                           }
                           modify_quota_id = record.CheckId;
                           confirmlevel = 1;
                           recheck(record);

                       }
                   }, '-', {
                       text: "ȡ��һ��ȷ��",
                       icon: '../Theme/1/images/extjs/customer/delete16.gif',
                       handler: function() {
                           var optionData = quotaGrid.getSelectionModel().getCount();
                           if (optionData == 0) {
                               Ext.Msg.alert("��ʾ", "��ѡ��Ҫȡ��ȷ�ϵļ�¼��");
                               return;
                           }
                           if (optionData > 1) {
                               Ext.Msg.alert("��ʾ", "һ��ֻ��ȡ��ȷ��һ����¼��");
                               return;
                           }
                           var record = quotaGrid.getSelectionModel().getSelections()[0].data;
                           if (record.CheckStatus == 0 || record.CheckStatus == '0') {
                               Ext.Msg.alert("��ʾ", "�ü�¼δ�����ʼ죬���Ƚ����ʼ죡");
                               return;
                           }
                           if (record.CheckStatus == 1 || record.CheckStatus == '1') {
                               Ext.Msg.alert("��ʾ", "�ü�¼δ���ʼ챨�棬�������ɳ��鱨�棡");
                               return;
                           }
                           if (record.CkStatus == 2 || record.CkStatus == '2') {
                               Ext.Msg.alert("��ʾ", "�ü�¼�ѽ��ж���ȷ�ϣ�����ȡ������ȷ�ϣ�");
                               return;
                           }
                           if (record.CkStatus != 1 && record.CkStatus != '1') {
                               Ext.Msg.alert("��ʾ", "�ü�¼����һ��ȷ��״̬������Ҫȡ��һ��ȷ�ϣ�");
                               return;
                           }                           
                           modify_quota_id = record.CheckId;
                           confirmlevel = 1;
                           cancelcheck();

                       }
                   }, '-', {
                       text: "����ȷ��",
                       icon: '../Theme/1/images/extjs/customer/edit16.gif',
                       handler: function() {
                           var optionData = quotaGrid.getSelectionModel().getCount();
                           if (optionData == 0) {
                               Ext.Msg.alert("��ʾ", "��ѡ��Ҫȷ�ϵļ�¼��");
                               return;
                           }
                           if (optionData > 1) {
                               Ext.Msg.alert("��ʾ", "һ��ֻ��ȷ��һ����¼��");
                               return;
                           }
                           var record = quotaGrid.getSelectionModel().getSelections()[0].data;
                           if (record.CheckStatus == 0 || record.CheckStatus == '0') {
                               Ext.Msg.alert("��ʾ", "�ü�¼��δ�����ʼ죬�����ʼ죡");
                               return;

                           }
                           if (record.CheckStatus == 1 || record.CheckStatus == '1') {
                               Ext.Msg.alert("��ʾ", "�ü�¼δ���ʼ챨�棬�����������鱨�棡");
                               return;

                           }
                           if (record.CkStatus == 0 || record.CkStatus == '0') {
                               Ext.Msg.alert("��ʾ", "�ü�¼δ����һ��ȷ�ϣ�");
                               return;
                           }
                           if (record.CkStatus == 2 || record.CkStatus == '2') {
                               Ext.Msg.alert("��ʾ", "�ü�¼�Ѿ����ж���ȷ�ϣ�");
                               return;
                           }
                           modify_quota_id = record.CheckId;
                           confirmlevel = 2;
                           recheck(record);

                       }
                   }, '-', {
                       text: "ȡ������ȷ��",
                       icon: '../Theme/1/images/extjs/customer/delete16.gif',
                       handler: function() {
                           var optionData = quotaGrid.getSelectionModel().getCount();
                           if (optionData == 0) {
                               Ext.Msg.alert("��ʾ", "��ѡ��Ҫȡ��ȷ�ϵļ�¼��");
                               return;
                           }
                           if (optionData > 1) {
                               Ext.Msg.alert("��ʾ", "һ��ֻ��ȡ��ȷ��һ����¼��");
                               return;
                           }
                           var record = quotaGrid.getSelectionModel().getSelections()[0].data;
                           if (record.CheckStatus == 0 || record.CheckStatus == '0') {
                               Ext.Msg.alert("��ʾ", "�ü�¼δ�����ʼ죬���Ƚ����ʼ죡");
                               return;
                           }
                           if (record.CheckStatus == 1 || record.CheckStatus == '1') {
                               Ext.Msg.alert("��ʾ", "�ü�¼δ���ʼ챨�棬�������ɳ��鱨�棡");
                               return;
                           }
                           if (record.CkStatus != 2 && record.CkStatus != '2') {
                               Ext.Msg.alert("��ʾ", "�ü�¼���Ƕ���ȷ��״̬������Ҫȡ������ȷ�ϣ�");
                               return;
                           }                           
                           modify_quota_id = record.CheckId;
                           confirmlevel = 2;
                           cancelcheck();

                       }
                   }, '-', {
                       text: "�鿴���鱨��",
                       icon: '../../Theme/1/images/extjs/customer/view16.gif',
                       handler: function() {
                           var record = quotaGrid.getSelectionModel().getSelections()[0].data;
                           if (record.CheckStatus != 2 && record.CheckStatus != '2') {
                               Ext.Msg.alert("��ʾ", "�ü�¼��û���ʼ챨�棡");
                               return;

                           }
                           modify_quota_id = record.CheckId;
                           showresult(record);
                       }
                    }]
                   });


                   function checkresult(mark) {
                       if (mark == 1 || mark == '1') {
                           Ext.Msg.alert("��ʾ", "����ɹ���");

                       } else {
                           Ext.Msg.alert("��ʾ", "����ʧ�ܣ�");

                       }


                   }

                   var ckstore = new Ext.data.ArrayStore({
                       fields: ['id', 'state'],
                       data: states
                   });
                   var ckcombo = new Ext.form.ComboBox({
                       store: ckstore,
                       displayField: 'state',
                       valueField: 'id',
                       typeAhead: true,
                       mode: 'local',
                       triggerAction: 'all',
                       emptyText: 'ѡ���ʼ�״��',
                       selectOnFocus: true,
                       fieldLabel: '������',
                       anchor: '90%'
                   });
                   
                   var cktypestore = new Ext.data.ArrayStore({
                       fields:['id','state'],
                       data:checkType
                   });
                   var cktypecombo = new Ext.form.ComboBox({
                       store: cktypestore,
                       displayField: 'state',
                       valueField: 'id',
                       typeAhead: true,
                       mode: 'local',
                       triggerAction: 'all',
                       emptyText: 'ѡ���ʼ�����',
                       selectOnFocus: true,
                       fieldLabel: '�ʼ�����',
                       anchor: '90%'
                   });
                   var ckstatusstore = new Ext.data.ArrayStore({
                       fields:['id','state'],
                       data:statusType
                   });
                   var ckstatuscombo = new Ext.form.ComboBox({
                       store: ckstatusstore,
                       displayField: 'state',
                       valueField: 'id',
                       typeAhead: true,
                       mode: 'local',
                       triggerAction: 'all',
                       emptyText: 'ѡ��ȷ��״̬',
                       selectOnFocus: true,
                       fieldLabel: 'ȷ��״̬',
                       anchor: '90%'
                   }); 

                   function getDetail() {
                       var str = "[";
                       for (var x = 0; x < detaillength; x++) {

                           str += "{"
                           str += "'" + detailarr[x].QuotaNo + "':'" + Ext.get("quota" + x).getValue() + "'";
                           str += "},"
                       }
                       str = str.substring(str.length - 1);
                       str += "]";
                   }


                   function cktp(val) {
                       var index = ckcombo.getStore().find('id', val);
                       if (index < 0)
                           return "";
                       var record = ckcombo.getStore().getAt(index);
                       return record.data.state;
                   }
                   function ckstatustp(val) {
                       var index = ckstatuscombo.getStore().find('id', val);
                       if (index < 0)
                           return "";
                       var record = ckstatuscombo.getStore().getAt(index);
                       return record.data.state;
                   }

                   if (typeof (formulaWindow) == "undefined") {//�������2��windows����
                       var formulaWindow = new Ext.Window({
                           title: '�ʼ�',
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
                                   //  document.getElementById("resulttext").value = "";

                                   var s = detail.getEl().dom.lastChild.lastChild;
                                   var ss = s.childNodes;
                                   var sss = ss.length;
                                   s.removeChild(ss[sss - 1]);

                               }
}]
                           });
                       }




                       var check = new Ext.Panel({
                       // html: 'asdada'
                   });
                   var result = new Ext.Panel({
                   // html: 'asdada'
               });
               if (typeof (checkWindow) == "undefined") {//�������2��windows����
                   var checkWindow = new Ext.Window({
                       title: '���',
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
                           text: 'ȷ��',
                           handler: function() {
                               confirmcheck();
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


                   if (typeof (resultWindow) == "undefined") {//�������2��windows����
                       var resultWindow = new Ext.Window({
                           title: '�ʼ챨��',
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
                               text: '��ӡ',
                               handler: function() {
                                   startPrint(printstr);
                               }
                           }, {
                               text: '�ر�',
                               handler: function() {
                                   resultWindow.hide();
                                   var s = result.getEl().dom.lastChild.lastChild;
                                   var ss = s.childNodes;
                                   var sss = ss.length;
                                   s.removeChild(ss[sss - 1]);
                               }
}]
                           });
                       }
                       var resultFmForm = new Ext.form.FormPanel({
                           labelWidth: 70,
                           autoWidth: true,
                           frame: true,
                           autoHeight: true,

                           items: [result]
                       });
                       resultWindow.add(resultFmForm);
                       var checkFmForm = new Ext.form.FormPanel({
                           labelWidth: 70,
                           autoWidth: true,
                           frame: true,
                           autoHeight: true,

                           items: [check]
                       });
                       checkWindow.add(checkFmForm);
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

                       var panel = new Ext.Panel({
                           heigth: 50,
                           html: '<div style="width:100%;text-align:center"> <font size="4"><H1>�㽭ʡ��ҵ�����ʼ쵥</H1></font></div>'
                       });
                       var cjbgpanel = new Ext.Panel({
                           heigth: 50,
                           html: '<div style="width:100%;text-align:center"> <font size="4"><H1>�㽭ʡ��ҵ���ų��챨�浥</H1></font></div>'
                       });
                       function showresult(record) {

                           resultWindow.show();
                           var oldnodes = result.getEl().dom.lastChild.lastChild;
                           var sindex=oldnodes.childNodes.length-1; 
                           if(sindex>-1)
                                oldnodes.removeChild(oldnodes.childNodes[sindex]);
                            
                           var prno = record.ProductNo;
                           Ext.Ajax.request({
                               url: "frmQtQualityCheckNotify.aspx?method=showrsult"
                                       , params: {
                                           checkid: modify_quota_id
                                           , prno: prno
                                           , ProductNo:prno
                                           , ProductName:record.ProductName

                                       },
                               success: function(response, options) {
                                   var data = response.responseText;
                                   printstr = data;
                                   var divobj = document.createElement("div");
                                   divobj.innerHTML = data;
                                   result.getEl().dom.lastChild.lastChild.appendChild(divobj);

                               }
                       ,
                               failure: function() {
                                   Ext.Msg.alert("��ʾ", "��ȡ�ʼ챨�����,�����´򿪸�ҳ��");
                               }
                           });



                       }
                       function recheck(record) {
                           checkWindow.show();
                           var prno = record.ProductNo;
                           var dgre =record.Dgre;
                           Ext.Ajax.request({
                               url: "frmQtQualityCheckNotify.aspx?method=recheck"
                                       , params: {
                                           checkid: modify_quota_id
                                           , prno: prno
                                           , ProductNo:prno
                                           , ProductName:record.ProductName
                                       },
                               success: function(response, options) {
                                   var data = response.responseText;

                                   var divobj = document.createElement("div");
                                   divobj.innerHTML = data;
                                   var oldnodes = check.getEl().dom.lastChild.lastChild;
                                   var sindex=oldnodes.childNodes.length-1; 
                                   while(sindex>-1){
                                        oldnodes.removeChild(oldnodes.childNodes[sindex]);
                                        sindex = sindex -1 ;
                                   }
                                   check.getEl().dom.lastChild.lastChild.appendChild(divobj);
                                   //��ʾ���
                                   Ext.fly('quotarank').dom.value=dgre;
                                   //׷�ӽ��
                                   Ext.Ajax.request({
                                       url: "frmQtQualityCheckNotify.aspx?method=recheck"
                                               , params: {
                                                   checkid: modify_quota_id
                                                    , quotarank: dgre                        
                                               },
                                       success: function(response, options) {
                                           var data = response.responseText;

                                           var divobj = document.getElementById("checkdetailinfo");
                                           divobj.innerHTML = data;
                                           check.getEl().dom.lastChild.lastChild.appendChild(divobj);
                                       },
                                       failure: function() {
                                           Ext.Msg.alert("��ʾ", "��ȡ�ʼ����ݳ���,�����´򿪸�ҳ��");
                                       }
                                   });
                               },
                               failure: function() {
                                   Ext.Msg.alert("��ʾ", "��ȡ�ʼ����ݳ���,�����´򿪸�ҳ��");
                               }
                           });

                       }
                       function confirmcheck() {
                           Ext.Ajax.request({
                               url: "frmQtQualityCheckNotify.aspx?method=confirmcheck"
                                       , params: {
                                           checkid: modify_quota_id
                                          , confirmlevel: confirmlevel

                                       },
                               success: function(response, options) {
                                   Ext.Msg.alert("��ʾ", "ȷ�ϳɹ���");
                                   checkWindow.hide();
                                   var s = check.getEl().dom.lastChild.lastChild;
                                   var ss = s.childNodes;
                                   var sss = ss.length;
                                   if(sss>0)
                                    s.removeChild(ss[sss - 1]);
                                   queryFormula();
                               }
                       ,
                               failure: function() {
                                   Ext.Msg.alert("��ʾ", "����ʧ�ܣ�");
                               }
                           });

                       }
                       function cancelcheck() {
                           Ext.Ajax.request({
                               url: "frmQtQualityCheckNotify.aspx?method=cancelcheck"
                                       , params: {
                                           checkid: modify_quota_id
                                          , confirmlevel: confirmlevel

                                       },
                               success: function(response, options) {
                                   Ext.Msg.alert("��ʾ", "ȡ��ȷ�ϳɹ���");
                                   checkWindow.hide();
                                   var s = check.getEl().dom.lastChild.lastChild;
                                   var ss = s.childNodes;
                                   var sss = ss.length;
                                   if(sss>0)
                                    s.removeChild(ss[sss - 1]);
                                   queryFormula();
                               }
                       ,
                               failure: function() {
                                   Ext.Msg.alert("��ʾ", "����ʧ�ܣ�");
                               }
                           });

                       }
                       var panel1 = new Ext.Panel({
                           heigth: 50,
                           html: '�ʼ��Ʒָ����д'
                       });
                       var detail = new Ext.Panel({
                       // html: 'asdada'
                   });

                   var editFmForm = new Ext.form.FormPanel({

                       autoWidth: true,
                       frame: true,
                       autoHeight: true,

                       items: [
                           panel,
                           {
                               layout: 'column',
                               items: [{
                                   columnWidth: .5,
                                   layout: 'form',
                                   border: false,
                                   items: [{
                                       cls: 'key',
                                       fieldLabel: '�ʼ�����',
                                       xtype: 'textfield',
                                       readOnly: true,
                                       name: 'checktype',
                                       id: 'checktype',
                                       anchor: '90%'
}]
                                   }
	                                  ]
                               },
	                      {
	                          layout: 'column',
	                          items: [
	                                   {
	                                       columnWidth: .5,
	                                       layout: 'form',
	                                       border: false,
	                                       items: [{
	                                           cls: 'key',
	                                           fieldLabel: '������',
	                                           xtype: 'textfield',
	                                           name: 'shipno',
	                                           id: 'shipno',
	                                           anchor: '90%'
}]
	                                       }, {
	                                           columnWidth: .5,
	                                           layout: 'form',
	                                           border: false,
	                                           items: [{
	                                               cls: 'key',
	                                               fieldLabel: '���ݱ��',
	                                               xtype: 'textfield',
	                                               name: 'checkno',
	                                               id: 'checkno',
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
	                                           fieldLabel: 'ȡ����ʼ����',
	                                           xtype: 'datefield',
	                                           name: 'startdate',
	                                           id: 'startdate',
	                                           anchor: '90%'
}]
	                                       }, {
	                                           columnWidth: .5,
	                                           layout: 'form',
	                                           border: false,
	                                           items: [{
	                                               cls: 'key',
	                                               fieldLabel: 'ȡ����������',
	                                               xtype: 'datefield',
	                                               name: 'enddate',
	                                               id: 'enddate',
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
	                                           fieldLabel: '��������',
	                                           xtype: 'datefield',
	                                           name: 'indate',
	                                           id: 'indate',
	                                           anchor: '90%'
}]
	                                       }, {
	                                           columnWidth: .5,
	                                           layout: 'form',
	                                           border: false,
	                                           items: [{
	                                               cls: 'key',
	                                               fieldLabel: '���λ��',
	                                               xtype: 'textfield',
	                                               name: 'local',
	                                               id: 'local',
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
	                                           fieldLabel: '������ʼ����',
	                                           xtype: 'datefield',
	                                           name: 'pstartdate',
	                                           id: 'pstartdate',
	                                           anchor: '90%'
}]
	                                       }, {
	                                           columnWidth: .5,
	                                           layout: 'form',
	                                           border: false,
	                                           items: [{
	                                               cls: 'key',
	                                               fieldLabel: '������������',
	                                               xtype: 'datefield',
	                                               name: 'penddate',
	                                               id: 'penddate',
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
	                                           fieldLabel: '���鿪ʼ����',
	                                           xtype: 'datefield',
	                                           name: 'cstartdate',
	                                           id: 'cstartdate',
	                                           anchor: '90%'
}]
	                                       }, {
	                                           columnWidth: .5,
	                                           layout: 'form',
	                                           border: false,
	                                           items: [{
	                                               cls: 'key',
	                                               fieldLabel: '�����������',
	                                               xtype: 'datefield',
	                                               name: 'cenddate',
	                                               id: 'cenddate',
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
	                                           fieldLabel: '������',
	                                           xtype: 'textfield',
	                                           name: 'zjr',
	                                           id: 'zjr',
	                                           anchor: '90%'
}]
	                                       }, {
	                                           columnWidth: .5,
	                                           layout: 'form',
	                                           border: false,
	                                           items: [{
	                                               cls: 'key',
	                                               fieldLabel: '�����',
	                                               xtype: 'textfield',
	                                               name: 'shr',
	                                               id: 'shr',
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
	                                           fieldLabel: '��׼��',
	                                           xtype: 'textfield',
	                                           name: 'okperson',
	                                           id: 'okperson',
	                                           anchor: '90%'
}]
	                                       }, {
	                                           columnWidth: .5,
	                                           layout: 'form',
	                                           border: false,
	                                           items: [{
	                                               cls: 'key',
	                                               fieldLabel: '��������',
	                                               xtype: 'datefield',
	                                               name: 'rdate',
	                                               id: 'rdate',
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
	                                           name: 'snote',
	                                           id: 'snote',
	                                           anchor: '90%'
}]
	                                       }
	                                  ]
	                      }, panel1,
	                                   {
	                                       layout: 'column',
	                                       items: [
	                                   {
	                                       columnWidth: .33,
	                                       layout: 'form',
	                                       border: false,
	                                       labelWidth: 60,
	                                       items: [{
	                                           cls: 'key',
	                                           fieldLabel: '��Ʒ����',
	                                           xtype: 'textfield',
	                                           name: 'pname',
	                                           id: 'pname',
	                                           anchor: '90%'
}]
	                                       }, {
	                                           columnWidth: .33,
	                                           layout: 'form',
	                                           labelWidth: 60,
	                                           border: false,
	                                           items: [{
	                                               cls: 'key',
	                                               fieldLabel: '��Ʒ���',
	                                               xtype: 'textfield',
	                                               name: 'pno',
	                                               id: 'pno',
	                                               anchor: '90%'
}]
	                                           }, {
	                                               columnWidth: .33,
	                                               layout: 'form',
	                                               labelWidth: 60,
	                                               border: false,
	                                               items: [{
	                                                   cls: 'key',
	                                                   fieldLabel: '�ʼ����',
	                                                   xtype: 'textfield',
	                                                   name: 'paname',
	                                                   id: 'paname',
	                                                   anchor: '90%'
}]
	                                               }
	                                  ]
	                                           },
	                                   {
	                                       layout: 'column',
	                                       items: [
	                                   {
	                                       columnWidth: .33,
	                                       layout: 'form', labelWidth: 60,
	                                       border: false,
	                                       items: [{
	                                           cls: 'key',
	                                           fieldLabel: '������',
	                                           xtype: 'textfield',
	                                           name: 'rml',
	                                           id: 'rml',
	                                           anchor: '90%'
}]
	                                       }, {
	                                           columnWidth: .33,
	                                           layout: 'form', labelWidth: 60,
	                                           border: false,
	                                           items: [{
	                                               cls: 'key',
	                                               fieldLabel: 'ȡ������',
	                                               xtype: 'textfield',
	                                               name: 'nnl',
	                                               id: 'nnl',
	                                               anchor: '90%'
}]
	                                           }, {
	                                               columnWidth: .33,
	                                               layout: 'form', labelWidth: 60,
	                                               border: false,
	                                               items: [{
	                                                   cls: 'key',
	                                                   fieldLabel: '�����¶�',
	                                                   xtype: 'textfield',
	                                                   name: 'dgr',
	                                                   id: 'dgr',
	                                                   anchor: '90%'
}]
	                                               }
	                                  ]
	                                           },
	                                   {
	                                       layout: 'column',
	                                       items: [
	                                   {
	                                       columnWidth: .33,
	                                       layout: 'form', labelWidth: 60,
	                                       border: false,
	                                       items: [{
	                                           cls: 'key',
	                                           fieldLabel: '��������',
	                                           xtype: 'textfield',
	                                           name: 'cy',
	                                           id: 'cy',
	                                           anchor: '90%'
}]
	                                       }, {
	                                           columnWidth: .33,
	                                           layout: 'form', labelWidth: 60,
	                                           border: false,
	                                           items: [{
	                                               cls: 'key',
	                                               fieldLabel: '�����׼',
	                                               xtype: 'textfield',
	                                               name: 'jy',
	                                               id: 'jy',
	                                               anchor: '90%'
}]
	                                           }, {
	                                               columnWidth: .33,
	                                               layout: 'form', labelWidth: 60,
	                                               border: false,
	                                               items: [{
	                                                   cls: 'key',
	                                                   fieldLabel: '�ж���׼',
	                                                   xtype: 'textfield',
	                                                   name: 'pd',
	                                                   id: 'pd',
	                                                   anchor: '90%'
}]
	                                               }
	                                  ]
	                                           }, detail


	                                  ]
                   });

                   function setformvalue(data) {
                       Ext.getCmp("checktype").setValue(data.DicsName);
                       Ext.getCmp("shipno").setValue(data.ShipNo);
                       Ext.getCmp("checkno").setValue(data.DeliveryNo);
                       Ext.getCmp("local").setValue(data.WhpName);
                       Ext.getCmp("pname").setValue(data.ProductName);
                       Ext.getCmp("pno").setValue(data.ProductNo);
                       Ext.getCmp("rml").setValue(data.RepresentAmount);
                       Ext.Ajax.request({
                           url: "frmQtQualityCheckNotify.aspx?method=getStardDetail"
                                       , params: {
                                           checkType: data.CheckType,
                                           prno: data.ProductNo

                                       },
                           success: function(response, options) {

                               if (response.responseText.length < 5) {
                                   Ext.Msg.alert("�ò�Ʒ��δ�����ʼ�ģ�壡");
                                   formulaWindow.hide();
                                   return;

                               } else {
                                   var data = Ext.util.JSON.decode(response.responseText);
                                   therecord = data[0];
                                   Ext.getCmp("cy").setValue(data[0].SamplingName);
                                   Ext.getCmp("jy").setValue(data[0].CheckName);
                                   Ext.getCmp("pd").setValue(data[0].StandardName);
                                   Ext.getCmp("paname").setValue(data[0].QualityName);
                               }

                           }
                       ,
                           failure: function() {
                               formulaWindow.hide();
                               Ext.Msg.alert("��ʾ", "��ȡ�ò�Ʒ�ʼ�ģ��ʧ�ܣ�");
                           }
                       });

                   }

                   formulaWindow.add(editFmForm);

                   function savecheck() {

                       document.getElementById("csno").value = therecord.STemplateNo;
                       document.getElementById("cqno").value = therecord.QTemplateNo;
                       document.getElementById("cfno").value = therecord.FTemplateNo;
                       document.getElementById("chno").value = modify_quota_id;
                       if (Ext.getCmp("nnl").getValue() == null || Ext.getCmp("nnl").getValue() == '') {
                           Ext.Msg.alert("��ʾ", "������ȡ��������");
                           return;
                       }
                       document.getElementById("cnnl").value = Ext.getCmp("nnl").getValue();

                       document.getElementById("cdgr").value = Ext.getCmp("dgr").getValue();
                       document.getElementById("cpno").value = Ext.getCmp("pno").getValue();
                       var qyksrq = Ext.getCmp("startdate").getValue();
                       if (qyksrq != null && qyksrq != '') {
                           qyksrq = Ext.util.Format.date(qyksrq, 'Y/m/d');
                       }
                       var qyjsrq = Ext.getCmp("enddate").getValue();
                       if (qyjsrq != null && qyjsrq != '') {
                           qyjsrq = Ext.util.Format.date(qyjsrq, 'Y/m/d');
                       }
                       var scjsrq = Ext.getCmp("pstartdate").getValue();
                       if (scjsrq != null && scjsrq != '') {
                           scjsrq = Ext.util.Format.date(scjsrq, 'Y/m/d');
                       }
                       var scksrq = Ext.getCmp("penddate").getValue();
                       if (scksrq != null && scksrq != '') {
                           scksrq = Ext.util.Format.date(scksrq, 'Y/m/d');
                       }
                       var jyjsrq = Ext.getCmp("cstartdate").getValue();
                       if (jyjsrq != null && jyjsrq != '') {
                           jyjsrq = Ext.util.Format.date(jyjsrq, 'Y/m/d');
                       }
                       var jyksrq = Ext.getCmp("cenddate").getValue();
                       if (jyksrq != null && jyksrq != '') {
                           jyksrq = Ext.util.Format.date(jyksrq, 'Y/m/d');
                       }
                       var jcrq = Ext.getCmp("indate").getValue();
                       if (jcrq != null && jcrq != '') {
                           jcrq = Ext.util.Format.date(jcrq, 'Y/m/d');
                       }
                       var bgrq = Ext.getCmp("rdate").getValue();
                       if (bgrq != null && bgrq != '') {
                           bgrq = Ext.util.Format.date(bgrq, 'Y/m/d');
                       }
                       var url = "frmQtQualityCheckNotify.aspx?method=saveCheck";
                       var sss = idsstr.split(",");
                       for (var iii = 0; iii < sss.length; iii++) {
                           if (document.getElementById("quota" + sss[iii]).value == null || document.getElementById("quota" + sss[iii]).value == "") {
                               Ext.Msg.alert("��ʾ", "����д���ָ����ֵ��");
                               return;
                           }
                       }

                       for (var i = 0; i < sss.length; i++) {
                           url += "&qt" + sss[i] + "=" + document.getElementById("quota" + sss[i]).value;
                       }

                       Ext.Ajax.request({
                           url: url
                               , params: {
                                   csno: document.getElementById("csno").value
                       , csno: document.getElementById("csno").value
                       , cqno: document.getElementById("cqno").value
                       , cfno: document.getElementById("cfno").value
                       , chno: document.getElementById("chno").value
                       , cnnl: document.getElementById("cnnl").value
                       , cdgr: document.getElementById("cdgr").value
                       , cpno: document.getElementById("cpno").value
                        , PName: modify_pname
                       , Bgdate: bgrq
                       , Jcdate: jcrq
                       , Jyksdate: jyksrq
                       , Jyjsdate: jyjsrq
                       , Qyksdate: qyksrq
                       , Qyjsdate: qyjsrq
                       , Scksdate: scksrq
                       , Scjsdate: scjsrq
                       , Shemp: Ext.getCmp("shr").getValue()
                       , Pzemp: Ext.getCmp("okperson").getValue()
                               },
                           //�ɹ�ʱ�ص� 
                           success: function(response, options) {
                               //��ȡ��Ӧ��json�ַ���

                               Ext.Msg.alert("��ʾ", "����ɹ���");
                               formulaWindow.hide();
                               editFmForm.getForm().reset();
                               var s = detail.getEl().dom.lastChild.lastChild;
                               var ss = s.childNodes;
                               var sss = ss.length;
                               s.removeChild(ss[sss - 1]);
                               var recorddel = quotaGrid.getSelectionModel().getSelections();
                               //customerListStore.remove(recorddel[0]);
                               queryFormula(); 
                           },
                           failure: function() {
                               Ext.Msg.alert("��ʾ", "����ʧ�ܣ�");
                           }
                       });
                       // document.getElementById("quotaform").submit();
                   }
                   function decodeArr(checkid, prno, checktype) {
                       if (modify_prno_id == checkid) {
                           var divobj = document.createElement("div");
                           divobj.innerHTML = allstr;
                           detail.getEl().dom.lastChild.lastChild.appendChild(divobj);

                       } else {
                           var url = "frmQtQualityCheckNotify.aspx?method=getTemplateDetail";
                           Ext.Ajax.request({
                               url: url
                                       , params: {
                                           checkType: checktype,
                                           pno: prno

                                       },
                               //�ɹ�ʱ�ص� 
                               success: function(response, options) {
                                   //��ȡ��Ӧ��json�ַ���

                                   if (response != null && response.responseText != 'undefined' && response.responseText != null && response.responseText != '') {
                                       if (response.responseText.length < 5) {
                                           Ext.Msg.alert("��ʾ", "δ�ҵ�ƥ����ʼ�ģ�壡");
                                           formulaWindow.hide();
                                           return;
                                       }
                                       var data = Ext.util.JSON.decode(response.responseText);
                                       detaillength = data.length;
                                       detailarr = data;
                                       idsstr = "";
                                       for (var zz = 0; zz < detaillength; zz++) {
                                           idsstr += data[zz].QuotaNo + ","

                                       }

                                       idsstr = idsstr.substring(0, idsstr.length - 1);

                                       var str = '<form id="quotaform" action="frmQtQualityCheckNotify.aspx">';
                                       str += '<input type="hidden" id="method" name="method" value="saveCheck">';
                                       str += '<input type="hidden" id="csno" name="csno" value="">';
                                       str += '<input type="hidden" id="cqno" name="cqno" value="">';
                                       str += '<input type="hidden" id="cfno" name="cfno" value="">';
                                       str += '<input type="hidden" id="chno" name="chno" value="">';
                                       str += '<input type="hidden" id="cnnl" name="cnnl" value="">';
                                       str += '<input type="hidden" id="cdgr" name="cdgr" value="">';
                                       str += '<input type="hidden" id="cpno"  name="cpno" value="">';
                                       str += "<table border='1' width='100%'>";
                                       if (data.length % 2 == 1) {
                                           for (var x = 0; x < detaillength - 1; x++) {
                                               if (x % 2 == 0) {
                                                   if (data[x].ControlType == 'Q012') {
                                                       str += "<tr><td width='30%'>" + data[x].QuotaName + "(" + data[x].QuotaUnit + ")</td><td width='20%'><select id='quota" + data[x].QuotaNo + "' name='quota" + data[x].QuotaNo + "'><option selected='selected' value='1'>����</option><option value='0'>������</option></select></td>";
                                                   }
                                                   else {
                                                       str += "<tr><td width='30%'>" + data[x].QuotaName + "(" + data[x].QuotaUnit + ")</td><td width='20%'><input type='text' id='quota" + data[x].QuotaNo + "' name='quota" + data[x].QuotaNo + "'></td>";
                                                   }
                                               } else {
                                                   if (data[x].ControlType == 'Q012') {
                                                       str += "<td width='30%'> " + data[x].QuotaName + "(" + data[x].QuotaUnit + ")</td><td width='20%'><select id='quota" + data[x].QuotaNo + "' name='quota" + data[x].QuotaNo + "'><option selected='selected' value='1'>����</option><option value='0'>������</option></select></td></tr>";
                                                   }
                                                   else {
                                                       str += "<td width='30%'>" + data[x].QuotaName + "(" + data[x].QuotaUnit + ")</td><td width='20%'><input type='text' id='quota" + data[x].QuotaNo + "' name='quota" + data[x].QuotaNo + "'></td></tr>";
                                                   }
                                               }

                                           }
                                           if (data[detaillength - 1].ControlType == 'Q012') {
                                               str += "<tr><td width='30%'> " + data[detaillength - 1].QuotaName + "(" + data[detaillength - 1].QuotaUnit + ")</td><td width='20%'><select id='quota" + data[detaillength - 1].QuotaNo + "' name='quota" + data[detaillength - 1].QuotaNo + "'><option value='1' selected='selected'>����</option><option value='0'>������</option></select></td><td></td><td></td></tr>"
                                           } else {
                                               str += "<tr><td width='30%'>" + data[detaillength - 1].QuotaName + "(" + data[detaillength - 1].QuotaUnit + ")</td><td width='20%'><input type='text' id='quota" + data[detaillength - 1].QuotaNo + "' name='quota" + data[detaillength - 1].QuotaNo + "'></td><td></td><td></td></tr>"
                                           }
                                       } else {

                                           for (var x = 0; x < detaillength; x++) {
                                               if (x % 2 == 0) {
                                                   if (data[x].ControlType == 'Q012') {
                                                       str += "<tr><td width='30%'>" + data[x].QuotaName + "(" + data[x].QuotaUnit + ")</td><td width='20%'><select id='quota" + data[x].QuotaNo + "' name='quota" + data[x].QuotaNo + "'><option selected='selected' value='1'>����</option><option value='0'>������</option></select></td>";
                                                   }
                                                   else {
                                                       str += "<tr><td width='30%'>" + data[x].QuotaName + "(" + data[x].QuotaUnit + ")</td><td width='20%'><input type='text' id='quota" + data[x].QuotaNo + "' name='quota" + data[x].QuotaNo + "'></td>";
                                                   }
                                               } else {
                                                   if (data[x].ControlType == 'Q012') {
                                                       str += "<td width='30%'>" + data[x].QuotaName + "(" + data[x].QuotaUnit + ")</td><td width='20%'><select id='quota" + data[x].QuotaNo + "' name='quota" + data[x].QuotaNo + "'><option selected='selected' value='1'>����</option><option value='0'>������</option></select></td></tr>";
                                                   }
                                                   else {
                                                       str += "<td width='30%'>" + data[x].QuotaName + "(" + data[x].QuotaUnit + ")</td><td width='20%'><input type='text' id='quota" + data[x].QuotaNo + "' name='quota" + data[x].QuotaNo + "'></td></tr>";
                                                   }
                                               }

                                           }

                                       }
                                       str += "</table></form>";
                                       allstr = str;
                                       modify_prno_id = checkid;
                                       var divobj = document.createElement("div");
                                       divobj.innerHTML = str;
                                       detail.getEl().dom.lastChild.lastChild.appendChild(divobj);
                                       //  editFmForm.add(detail);

                                   }

                               },
                               failure: function() {
                                   formulaWindow.hide();
                                   Ext.Msg.alert("��ʾ", "��ȡ�ʼ�ģ����Ϣ����,�����´򿪸�ҳ��");
                               }
                           });
                       }
                   }
                   function setStandardValue() {




                   }
    var quotaTemplate_form = new Ext.form.FormPanel({
       renderTo: "notify_form",
       frame: true,
       monitorValid: true, // ����formBind:true�İ�ť����֤��
       layout: "form",
       items: [{
           layout: 'column',   //�����Ԫ��Ϊ����Ϊ�в��ַ�ʽ
           border: false,
           labelSeparator: '��',
           items: 
           [{
               columnWidth: .3,
               layout: 'form',
               border: false,
               labelWidth: 55,
               items: [{
                   cls: 'key',
                   xtype: 'textfield',
                   fieldLabel: '�������',
                   name: 'deno',
                   id: 'deno',
                   anchor: '90%'
                }]
            }, {
                   columnWidth: .3,
                   layout: 'form',
                   border: false,
                   labelWidth: 55,
                   items: [{
                       cls: 'key',
                       xtype: 'textfield',
                       fieldLabel: '������ ',
                       name: 'shno',
                       id: 'shno',
                       anchor: '90%'
                }]
            },{
		        columnWidth: .4,
		        layout: 'form',
		        labelWidth: 55,
		        border: false,
		        items: [{
		            cls: 'key',
		            xtype: 'textfield',
		            fieldLabel: '��Ӧ�� ',
		            name: 'prno',
		            id: 'prno',
		            anchor: '90%'
                }]
            }]
        },{
           layout: 'column',   //�����Ԫ��Ϊ����Ϊ�в��ַ�ʽ
           border: false,
           labelSeparator: '��',
           items: 
           [{
		        columnWidth: .3,
		        layout: 'form',
		        labelWidth: 55,
		        border: false,
		        items: [cktypecombo]
            },
            {
		        columnWidth: .3,
		        layout: 'form',
		        labelWidth: 55,
		        border: false,
		        items: [ckcombo]
		    },
            {
		        columnWidth: .3,
		        layout: 'form',
		        labelWidth: 55,
		        border: false,
		        items: [ckstatuscombo]
		    },
		    {
		        columnWidth: .1,
		        layout: 'form',
		        border: false,
		        items: [{ cls: 'key',
		            xtype: 'button',
		            text: '��ѯ',
		            anchor: '90%',
		            handler: function() {
		                queryFormula();
		            }
                }]
            }]
        }]
    });
           function queryFormula() {
               var deno = Ext.getCmp("deno").getValue();
               var shno = Ext.getCmp("shno").getValue();
               var prno = Ext.getCmp("prno").getValue();
               var sup = ckcombo.getValue();
               var type = cktypecombo.getValue();
               var ckstatus = ckstatuscombo.getValue();
               
               customerListStore.baseParams.start=0;
               customerListStore.baseParams.limit=13;
               customerListStore.baseParams.deno=deno;
               customerListStore.baseParams.shno=shno;
               customerListStore.baseParams.prno=prno;
               customerListStore.baseParams.sup=sup;
               customerListStore.baseParams.zjtype=type;
               customerListStore.baseParams.ckstatus=ckstatus;
               customerListStore.load();
           }

           var customerListStore = new Ext.data.Store
			({
			    url: 'frmQtQualityCheckNotify.aspx?method=getCNList',
			    reader: new Ext.data.JsonReader({
			        totalProperty: 'totalProperty',
			        root: 'root'
			    }, [
                { name: 'OrgName' },
			    { name: 'CheckId' },
			    { name: 'CheckType' },
			    { name: 'DicsName' },
			    { name: 'DeliveryNo' },
	            { name: 'ShipNo' },
	            { name: 'ProductNo' },
	            { name: 'ProductName' },
	            { name: 'NocheckNo' },
	            { name: 'RepresentAmount' },
	            { name: 'NocheckNo' },
			    { name: 'DeliveryDate' },
	            { name: 'WhName' },
	            { name: 'WhpName' },
	            { name: 'CheckStatus' },
	            { name: 'CkStatus' },
	            { name: 'ProductDate' },
	            { name: 'Note' },
	            { name: 'Dgre' },
	            { name: 'ProviderName' },
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

           el: 'notify_grid',
           width:document.body.offsetWidth,
           height: '100%',
           //autoWidth: true,
           //autoHeight: true,
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
            {header: '������˾', dataIndex: 'OrgName',width:100 },
            { header: '�ʼ�����', dataIndex: 'DicsName' ,width:70},
	        { header: '�������', dataIndex: 'DeliveryNo',width:60 },
	        { header: '������', dataIndex: 'ShipNo',width:60 },
			{ header: '��Ӧ������', dataIndex: 'ProviderName',width:120 },
			{ header: '��Ʒ���', dataIndex: 'ProductNo' ,width:60 },
			{ header: '��Ʒ����', dataIndex: 'ProductName' ,width:120 },
			{ header: '������', dataIndex: 'RepresentAmount' ,width:50 },
			{ header: 'δ�����', dataIndex: 'NocheckNo' ,width:60 },
			{ header: '��������', dataIndex: 'ProductDate' ,width:100 },
			{ header: '�ֿ�', dataIndex: 'WhName' ,width:50 },
			{ header: '���õص�', dataIndex: 'WhpName' ,width:60 },
			{ header: '�ʼ�״̬', dataIndex: 'CheckStatus', renderer: cktp ,width:60 },
			{ header: 'ȷ��״̬', dataIndex: 'CkStatus', renderer: ckstatustp ,width:60 },
			{ header: '����', dataIndex: 'Dgre',hidden:true,hideable:true},

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
                   pageSize: 13,
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
                   forceFit: false,
                   getRowClass: function(r, i, p, s) {
                        if (r.data.CkStatus == 1) {
                            return "x-grid-tanstype1";
                        }else if (r.data.CkStatus == 2) {
                            return "x-grid-tanstype2";
                        }
                   }
               },
               //width: 750, 
               height: 389,
               closeAction: 'hide',

               stripeRows: true,
               loadMask: true,
               autoExpandColumn: 2
           });
           quotaGrid.render();

       }); 
		
	</script>
</html>

