<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmQtSCNotify.aspx.cs" Inherits="QT_frmQtSCNotify" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=GB2312">
    <link rel="stylesheet" type="text/css" href="../ext3/resources/css/ext-all.css" />
	<script type="text/javascript" src="../ext3/adapter/ext/ext-base.js"></script>	
	<script type="text/javascript" src="../ext3/ext-all.js"></script>
	<script type="text/javascript" src="../js/datetime.js"></script>
</head>
<body>
	 <div id="notify_toolbar"></div>
	 <div id="notify_form"></div>
	 <div id="notify_grid"></div>
</body>
<script type="text/javascript">
           Ext.BLANK_IMAGE_URL = "../ext3/resources/images/default/s.gif";
           var modify_quota_id = 'none';
           var allstr = "";
           var modify_pname = "";
           var modify_prno_id = "none";
           var addmark = 0;
           var detaillength = 0;
           var idsstr = "";
           var therecord;
           var printstr = "";
           
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
                    ['Q1505', '�ʼ����'],
                    ['Q1504', '�����ʼ�'],
                    ['0', '��ʼ״̬']
                         ];

           Ext.onReady(function() {
               var Toolbar = new Ext.Toolbar({
                   renderTo: "notify_toolbar",
                   items: [{
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
                           if (record.Status != 0 && record.Status != '0') {
                               Ext.Msg.alert("��ʾ", "�ü�¼�Ѿ����й��ʼ죡");
                               return;

                           }
                           modify_quota_id = record.CheckId;
                           modify_pname = record.ProductName;
                           top.createDiv(record.ProductName+"�ʼ�","/ZJ/frmQtCheckInput.aspx?FromBillType=Q1402&FromBillId="+modify_quota_id);
//                           formulaWindow.show();
//                           setformvalue(record);
//                           decodeArr(record.CheckId, record.ProductNo, record.CheckType);

                       }
//                   }, '-', {
//                       text: "��֤",
//                       icon: '../Theme/1/images/extjs/customer/edit16.gif',
//                       handler: function() {
//                           var record = quotaGrid.getSelectionModel().getSelections()[0].data;
//                           modify_quota_id = record.CheckId;
//                           checkpass(record.CheckId,record.ProductNo);

//                       }
//                   }, '-', {
//                       text: "���ɳ��鱨��",
//                       icon: '../Theme/1/images/extjs/customer/add16.gif',
//                       handler: function() {
//                           var record = quotaGrid.getSelectionModel().getSelections()[0].data;
//                           if (record.CheckStatus == 0 || record.CheckStatus == '0') {
//                               Ext.Msg.alert("��ʾ", "�ü�¼��δ�����ʼ죬�����ʼ죡");
//                               return;

//                           }
//                           if (record.CheckStatus == 2 || record.CheckStatus == '2') {
//                               Ext.Msg.alert("��ʾ", "�ü�¼�ѳ��ʼ챨�棬�����ٽ����ʼ죡");
//                               return;

//                           }
//                           modify_quota_id = record.CheckId;
//                           recheck(record.ProductNo);

//                       }
//                   }, '-', {
//                       text: "���鱨��",
//                       icon: '../../Theme/1/images/extjs/customer/view16.gif',
//                       handler: function() {
//                           var record = quotaGrid.getSelectionModel().getSelections()[0].data;
//                           if (record.CheckStatus != 2 && record.CheckStatus != '2') {
//                               Ext.Msg.alert("��ʾ", "�ü�¼��û���ʼ챨�棡");
//                               return;

//                           }
//                           modify_quota_id = record.CheckId;
//                           showresult(record.ProductNo);
//                       }
                    }, '-', {
                       text: "���鱨�浥",
                       icon: '../../Theme/1/images/extjs/customer/view16.gif',
                       handler: function() {
                           var record = quotaGrid.getSelectionModel().getSelections()[0].data;
                           if (record.Status != 1 && record.Status != '1') {
                               Ext.Msg.alert("��ʾ", "�ü�¼��û���ʼ챨�棡");
                               return;

                           }
                           var check_id = record.CheckResultId;
                           top.createDiv(record.ProductName+"�ʼ�","/ZJ/frmQtCheckInput.aspx?CheckId="+check_id);
                           //printQtById();
                       }
}]
                   });

function getUrl(imageUrl)
            {
                var index = window.location.href.toLowerCase().indexOf('/qt/');
                var tempUrl = window.location.href.substring(0,index);
                return tempUrl+"/"+imageUrl;
            }
            
var printStyleXml = 'zjbg.xml';
function printQtById()
{
                var sm = quotaGrid.getSelectionModel();
                //��ѡ
                var selectData = sm.getSelections();                
                var array = new Array(selectData.length);
                var checkIds = "";
                for(var i=0;i<selectData.length;i++)
                {
                    if(checkIds.length>0)
                        checkIds+=",";
                    checkIds += selectData[i].get('CheckId');
                }
                //ҳ���ύ
                Ext.Ajax.request({
                    url: 'frmQtQualityCheckNotify.aspx?method=getPrintData',
                    method: 'POST',
                    params: {
                        CheckId: checkIds
                    },
                   success: function(resp,opts){ 
                       var printData =  resp.responseText;
                       var printControl =  parent.parent.parent.document.getElementById("topFrame").contentWindow.getPrintControl();
                       printControl.Url =getUrl('xml');
                       printControl.MapUrl = printControl.Url+'/'+printStyleXml;//'/salePrint1.xml';
                       printControl.PrintXml = printData;
                       alert(checkIds);
                       printControl.ColumnName="CheckId";
                       printControl.OnlyData=false;
//                       printControl.PageWidth=printPageWidth;
//                       printControl.PageHeight =printPageHeight ;
                       printControl.Print();
//                    var billControl = document.getElementById('billControl');
//                    billControl.PrintXml = printData;
//                    billControl.setFormValue(0);
                       
                   },
		           failure: function(resp,opts){  /* Ext.Msg.alert("��ʾ","����ʧ��"); */    }
                });
}

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
                       function showresult(prno) {

                           resultWindow.show();
                           Ext.Ajax.request({
                               url: "frmQtQualityCheckNotify.aspx?method=showrsult"
                                       , params: {
                                           checkid: modify_quota_id
                                            , prno: prno

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
                                   Ext.Msg.alert("��ʾ", "��ȡָ�����������,�����´򿪸�ҳ��");
                               }
                           });



                       }
                       function checkpass(checkid,productid){
                        Ext.Ajax.request({
                               url: "frmQtQualityCheckNotify.aspx?method=checkpass"
                                       , params: {
                                           checkid: checkid
                                            , productid: productid

                                       },
                               success: function(response, options) {
                                   Ext.Msg.alert("��ʾ", "��֤�ɹ���");
                                   queryFormula();
                               }
                       ,
                               failure: function() {
                                   Ext.Msg.alert("��ʾ", "��֤ʧ�ܣ�");
                               }
                           });
                       }
                       function recheck(prno) {
                           checkWindow.show();
                           Ext.Ajax.request({
                               url: "frmQtQualityCheckNotify.aspx?method=recheck"
                                       , params: {
                                           checkid: modify_quota_id
                                            , prno: prno

                                       },
                               success: function(response, options) {
                                   var data = response.responseText;

                                   var divobj = document.createElement("div");
                                   divobj.innerHTML = data;
                                   var oldnodes = check.getEl().dom.lastChild.lastChild;
                                   var sindex=oldnodes.childNodes.length-1; 
                                   if(sindex>-1)
                                        oldnodes.removeChild(oldnodes.childNodes[sindex]);
                                   oldnodes.appendChild(divobj);
                                   queryFormula();
                               }
                       ,
                               failure: function() {
                                   Ext.Msg.alert("��ʾ", "��ȡָ�����������,�����´򿪸�ҳ��");
                               }
                           });
                       }
                       this.recheckbyRange = function(checkid,range) {                    
                           Ext.Ajax.request({
                               url: "frmQtQualityCheckNotify.aspx?method=recheck"
                                       , params: {
                                           checkid: checkid
                                            , quotarank: range
                                       },
                               success: function(response, options) {
                                   var data = response.responseText;

                                   var divobj = document.getElementById("checkdetailinfo");
                                   divobj.innerHTML = data;
                                   queryFormula();
                               },
                               failure: function() {
                                   Ext.Msg.alert("��ʾ", "��ȡ�ʼ����ݳ���,�����´򿪸�ҳ��");
                               }
                           });
                       }
                       function secondcheck() {
                           var resulttext = document.getElementById("resulttext").value;
                           if (resulttext == null || resulttext == "") {
                               Ext.Msg.alert("��ʾ", "�����������ۣ�");
                               return;
                           }

                           Ext.Ajax.request({
                               url: "frmQtQualityCheckNotify.aspx?method=secondcheck"
                                       , params: {
                                           checkid: modify_quota_id
                                          , resulttext: document.getElementById("resulttext").value
                                          , checkrange: document.getElementById('quotarank').value
                                       },
                               success: function(response, options) {
                                   Ext.Msg.alert("��ʾ", "����ɹ���");
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
                                   Ext.Msg.alert("�ò�Ʒ�ʼ컹δ�����ʼ�ģ�壡");
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
                               Ext.Msg.alert("��ʾ", "��ȡ�ʼ�ģ�����,�����´򿪸�ҳ��");
                               formulaWindow.hide();
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
                               customerListStore.remove(recorddel[0]);

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
                                   Ext.Msg.alert("��ʾ", "��ȡ�ʼ�ģ�����,�����´򿪸�ҳ��");
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
           items: [{
		        columnWidth: .32,
		        layout: 'form',
		        labelWidth: 95,
		        border: false,
		        items: [{
		            cls: 'key',
		            xtype: 'datefield',
		            fieldLabel: '���ֿ�ʼʱ��',
		            name: 'dstart',
		            id: 'dstart',
		            anchor: '90%',
		            format:'Y��m��d��',
		            value:getThisMonthFirstDay('/').clearTime()
                }]
		    },{
		        columnWidth: .32,
		        layout: 'form',
		        labelWidth: 95,
		        border: false,
		        items: [{
		            cls: 'key',
		            xtype: 'datefield',
		            fieldLabel: '���ֽ���ʱ��',
		            name: 'dend',
		            id: 'dend',
		            anchor: '90%',
		            format:'Y��m��d��',
		            value: new Date().clearTime()
                }]
		    }]
        },
        {
            layout: 'column',   //�����Ԫ��Ϊ����Ϊ�в��ַ�ʽ
           border: false,
           labelSeparator: '��',
           items: [{
		        columnWidth: .32,
		        layout: 'form',
		        labelWidth: 95,
		        border: false,
		        items: [{
		            cls: 'key',
		            xtype: 'textfield',
		            fieldLabel: '��Ʒ��Ż����� ',
		            name: 'productno',
		            id: 'productno',
		            anchor: '90%'
		        }]
		    }
		   ,{
		        columnWidth: .32,
		        layout: 'form',
		        labelWidth: 55,
		        border: false,
		        items: [ckcombo]
		    },
		    {
		        columnWidth: .08,
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
                                   //var deno = Ext.getCmp("deno").getValue();
                                   //var shno = Ext.getCmp("shno").getValue();
                                   //var prno = Ext.getCmp("prno").getValue();
                                   var productno = Ext.getCmp("productno").getValue();
                                   var dstart = Ext.util.Format.date(Ext.getCmp('dstart').getValue(),'Y/m/d');
                                   var dend = Ext.util.Format.date(Ext.getCmp('dend').getValue(),'Y/m/d');
                                   var sup = ckcombo.getValue();
                                   //customerListStore.baseParams.deno=deno;
                                   //customerListStore.baseParams.shno=shno;
                                   //customerListStore.baseParams.prno=prno;
                                   customerListStore.baseParams.sup=sup;
                                   customerListStore.baseParams.productno=productno;
                                   customerListStore.baseParams.dstart=dstart;
                                   customerListStore.baseParams.dend=dend;
                                   customerListStore.baseParams.start=0;
                                   customerListStore.baseParams.limit=10;
                                   customerListStore.load();
                               }

                               var customerListStore = new Ext.data.Store
			({
			    url: 'frmQtQualityCheckNotify.aspx?method=getCNList&zjtype=Q092',
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
	            { name: 'Status' },
	            { name: 'ProductDate' },
	            { name: 'Note' },
	            { name: 'ProviderName' },
	            { name: 'SupplierName' },
	            { name: 'Supplier' },
	            { name: 'CheckResultId' },
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
                   //width: '100%',
                   width:document.body.offsetWidth,
                   height: '100%',
                   //autoWidth: true,
                   //autoHeight: true,
                   autoScroll: true,
                   layout: 'fit',
                   monitorResize: true, 
                   columnLines:true,
                   id: 'customerdatagrid',
                   store: customerListStore,
                   loadMask: { msg: '���ڼ������ݣ����Ժ��' },
                   sm: sm,
                   cm: new Ext.grid.ColumnModel([
                        sm,

                        new Ext.grid.RowNumberer(), //�Զ��к�
                        {header: '������˾', dataIndex: 'OrgName' ,hidden:true,hideable:false },
                        {header: '���ID', dataIndex: 'CheckResultId' ,hidden:true,hideable:false },
                        { header: '�ʼ�����', dataIndex: 'DicsName',width:60 },
						{ header: '�ֿ�', dataIndex: 'WhName' },
						{ header: '���õص�', dataIndex: 'WhpName' },
				        { header: '�������', dataIndex: 'DeliveryNo' ,hidden:true,hideable:false},
						{ header: '��Ʒ���', dataIndex: 'ProductNo',width:60 },
						{ header: '��Ʒ����', dataIndex: 'ProductName' ,width:150},
						{ header: '������', dataIndex: 'RepresentAmount',width:50 },
						{ header: 'δ�����', dataIndex: 'NocheckNo',width:60 },
						{ header: '��������', dataIndex: 'ProductDate',width:120 },
						{ header: '�Ƿ��ʼ����', dataIndex: 'Status', renderer: cktp }

		              ]), 
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
                           forceFit: false
                       },
                       //width: 750, 
                       height: 320,
                       closeAction: 'hide',
                       stripeRows: true,
                       loadMask: true//,
                       //autoExpandColumn: 2
                   });
                   quotaGrid.render();

               }); 
		
	</script></html>