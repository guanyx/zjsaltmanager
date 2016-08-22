<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmQtZJtzd.aspx.cs" Inherits="QT_frmQtZJtzd" %>
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
               var strPrint = "<h4 style=’font-size:18px; text-align:center;’>打印预览区</h4>\n";

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
               strPrint = strPrint + "<div style='text-align:center'><button onclick='printWin()' style='padding-left:4px;padding-right:4px;'>打  印</button><button onclick='window.opener=null;window.close();'  style='padding-left:4px;padding-right:4px;'>关  闭</button></div>\n";

               oWin.document.write(strPrint);
               oWin.focus();
               oWin.document.close();
           }

           var states = [
                    ['1', '质检完成'],
                    ['0', '质检未完成']
                         ];

           Ext.onReady(function() {
               var Toolbar = new Ext.Toolbar({
                   renderTo: "notify_toolbar",
                   items: [{
                       text: "新增检测",
                       icon: '../Theme/1/images/extjs/customer/spellcheck.png',
                       handler: function() {
                           top.createDiv("新产品抽检信息录入","/ZJ/frmQtCheckInput.aspx");
//                           formulaWindow.show();
//                           setformvalue(record);
//                           decodeArr(record.CheckId, record.ProductNo, record.CheckType);

                       }
                   }, '-', {
                       text: "删除记录",
                       icon: '../Theme/1/images/extjs/customer/delete16.gif',
                       handler: function() {
                           var optionData = quotaGrid.getSelectionModel().getCount();
                           if (optionData == 0) {
                               Ext.Msg.alert("提示", "请选中要查看的记录！");
                               return;
                           }
                           if (optionData > 1) {
                               Ext.Msg.alert("提示", "一次只能选择一条记录！");
                               return;
                           }
                           var record = quotaGrid.getSelectionModel().getSelections()[0].data;
                           //页面提交
                            Ext.Ajax.request({
                                url: 'frmQtQualityCheckNotify.aspx?method=delzj',
                                method: 'POST',
                                params: {
                                    CheckId: record.CheckId
                                },
                               success: function(resp,opts){ 
                                   var resu = Ext.decode(resp.responseText);
                                   if(resu.success)
                                   {
                                     Ext.Msg.alert("提示","删除成功！");
                                   }
                                   else
                                   {
                                        Ext.Msg.alert("删除失败",resu.errorinfo);
                                   }
                               },
		                       failure: function(resp,opts){  /* Ext.Msg.alert("提示","保存失败"); */    }
                            });

                       }
//                   }, '-', {
//                       text: "生成初验报告",
//                       icon: '../Theme/1/images/extjs/customer/add16.gif',
//                       handler: function() {
//                           var record = quotaGrid.getSelectionModel().getSelections()[0].data;
//                           if (record.CheckStatus == 0 || record.CheckStatus == '0') {
//                               Ext.Msg.alert("提示", "该记录还未进行质检，请先质检！");
//                               return;

//                           }
//                           if (record.CheckStatus == 2 || record.CheckStatus == '2') {
//                               Ext.Msg.alert("提示", "该记录已出质检报告，不能再进行质检！");
//                               return;

//                           }
//                           modify_quota_id = record.CheckId;
//                           recheck(record.ProductNo);

//                       }
//                   }, '-', {
//                       text: "检验报告",
//                       icon: '../../Theme/1/images/extjs/customer/view16.gif',
//                       handler: function() {
//                           var record = quotaGrid.getSelectionModel().getSelections()[0].data;
//                           if (record.CheckStatus != 2 && record.CheckStatus != '2') {
//                               Ext.Msg.alert("提示", "该记录还没有质检报告！");
//                               return;

//                           }
//                           modify_quota_id = record.CheckId;
//                           showresult(record.ProductNo);
//                       }
                    }, '-', {
                       text: "检验报告单",
                       icon: '../../Theme/1/images/extjs/customer/view16.gif',
                       handler: function() {
                           var optionData = quotaGrid.getSelectionModel().getCount();
                           if (optionData == 0) {
                               Ext.Msg.alert("提示", "请选中要查看的记录！");
                               return;
                           }
                           if (optionData > 1) {
                               Ext.Msg.alert("提示", "一次只能选择一条记录！");
                               return;
                           }
                           var record = quotaGrid.getSelectionModel().getSelections()[0].data;
                           if (record.Status != 1 && record.Status != '1') {
                               Ext.Msg.alert("提示", "该记录还没有质检报告！");
                               return;

                           }
                           var check_id = record.CheckResultId;
                           top.createDiv(record.ProductName+"质检","/ZJ/frmQtCheckInput.aspx?CheckId="+check_id);
                           //printQtById();
                       }
}, '-', {
                       text: "帮助",
                       icon: '../../Theme/1/images/extjs/customer/view16.gif',
                       handler: function() {
                           if(helper==null)
                           {
                                //页面提交
                                Ext.Ajax.request({
                                    url: 'frmQtCheckInput.aspx?method=gethelp',
                                    method: 'POST',
                                   success: function(resp,opts){ 
                                       helper =  resp.responseText;
                                       descriptionHtmlEditor.setValue(helper);
                                       helpWindow.show();
                                       
                                   },
		                           failure: function(resp,opts){  /* Ext.Msg.alert("提示","保存失败"); */    }
                                });
                           }
                           else
                           {
                            helpWindow.show();
                           }
                       }
}]
                   });

if (typeof (helpWindow) == "undefined") {//解决创建2个windows问题
                   var helpWindow = new Ext.Window({
                       title: '帮助',
                       modal: 'true',
                       width: 600,
                       y: 50,
                       autoHeigth: true,
                       collapsible: true, //是否可以折叠 
                       closable: true, //是否可以关闭 
                       //maximizable : true,//是否可以最大化 
                       closeAction: 'hide',
                       constrain: true,
                       resizable: false,
                       plain: true,
                       // ,items: addQuotaForm
                       buttons: [{
                           text: '关闭',
                           handler: function() {
                               helpWindow.hide();
                           }
}]
                       });
                   }
                   var helper;
                   var descriptionHtmlEditor = new Ext.form.HtmlEditor({                   
                    name: 'description',
                    allowBlank:true,
                    width:500,
                    height:300
                });
                   var helpFmForm = new Ext.form.FormPanel({
                           labelWidth: 10,
                           autoWidth: true,
                           frame: true,
                           autoHeight: true,

                           items: [descriptionHtmlEditor]
                       });
                       helpWindow.add(helpFmForm);
                   
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
                //多选
                var selectData = sm.getSelections();                
                var array = new Array(selectData.length);
                var checkIds = "";
                for(var i=0;i<selectData.length;i++)
                {
                    if(checkIds.length>0)
                        checkIds+=",";
                    checkIds += selectData[i].get('CheckId');
                }
                //页面提交
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
		           failure: function(resp,opts){  /* Ext.Msg.alert("提示","保存失败"); */    }
                });
}

                   function checkresult(mark) {
                       if (mark == 1 || mark == '1') {
                           Ext.Msg.alert("提示", "保存成功！");

                       } else {
                           Ext.Msg.alert("提示", "保存失败！");

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
                       emptyText: '选择质检状况',
                       selectOnFocus: true,
                       fieldLabel: '完成情况',
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


                   if (typeof (formulaWindow) == "undefined") {//解决创建2个windows问题
                       var formulaWindow = new Ext.Window({
                           title: '质检',
                           modal: 'true',
                           width: 600,
                           y: 50,
                           autoHeigth: true,
                           collapsible: true, //是否可以折叠 
                           closable: true, //是否可以关闭 
                           //maximizable : true,//是否可以最大化 
                           closeAction: 'hide',
                           constrain: true,
                           resizable: false,
                           plain: true,
                           // ,items: addQuotaForm
                           buttons: [{
                               text: '保存',
                               handler: function() {
                                   savecheck();

                               }
                           }, {
                               text: '关闭',
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
               if (typeof (checkWindow) == "undefined") {//解决创建2个windows问题
                   var checkWindow = new Ext.Window({
                       title: '审核',
                       modal: 'true',
                       width: 600,
                       y: 50,
                       autoHeigth: true,
                       collapsible: true, //是否可以折叠 
                       closable: true, //是否可以关闭 
                       //maximizable : true,//是否可以最大化 
                       closeAction: 'hide',
                       constrain: true,
                       resizable: false,
                       plain: true,
                       // ,items: addQuotaForm
                       buttons: [{
                           text: '保存',
                           handler: function() {
                               secondcheck();
                           }
                       }, {
                           text: '关闭',
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


                   if (typeof (resultWindow) == "undefined") {//解决创建2个windows问题
                       var resultWindow = new Ext.Window({
                           title: '质检报告',
                           modal: 'true',
                           width: 600,
                           y: 50,
                           autoHeigth: true,
                           collapsible: true, //是否可以折叠 
                           closable: true, //是否可以关闭 
                           //maximizable : true,//是否可以最大化 
                           closeAction: 'hide',
                           constrain: true,
                           resizable: false,
                           plain: true,
                           // ,items: addQuotaForm
                           buttons: [{
                               text: '打印',
                               handler: function() {
                                   startPrint(printstr);
                               }
                           }, {
                               text: '关闭',
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
                           fieldLabel: '指标名称',
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
                           html: '<div style="width:100%;text-align:center"> <font size="4"><H1>浙江省盐业集团质检单</H1></font></div>'
                       });
                       var cjbgpanel = new Ext.Panel({
                           heigth: 50,
                           html: '<div style="width:100%;text-align:center"> <font size="4"><H1>浙江省盐业集团初检报告单</H1></font></div>'
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
                                   Ext.Msg.alert("提示", "获取指标配置项出错,请重新打开该页！");
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
                                   Ext.Msg.alert("提示", "验证成功！");
                                   queryFormula();
                               }
                       ,
                               failure: function() {
                                   Ext.Msg.alert("提示", "验证失败！");
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
                                   Ext.Msg.alert("提示", "获取指标配置项出错,请重新打开该页！");
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
                                   Ext.Msg.alert("提示", "获取质检数据出错,请重新打开该页！");
                               }
                           });
                       }
                       function secondcheck() {
                           var resulttext = document.getElementById("resulttext").value;
                           if (resulttext == null || resulttext == "") {
                               Ext.Msg.alert("提示", "请输入检验结论！");
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
                                   Ext.Msg.alert("提示", "保存成功！");
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
                                   Ext.Msg.alert("提示", "保存失败！");
                               }
                           });

                       }
                       var panel1 = new Ext.Panel({
                           heigth: 50,
                           html: '质检产品指标填写'
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
                                       fieldLabel: '质检类型',
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
	                                           fieldLabel: '车船号',
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
	                                               fieldLabel: '单据编号',
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
	                                           fieldLabel: '取样开始日期',
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
	                                               fieldLabel: '取样结束日期',
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
	                                           fieldLabel: '进仓日期',
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
	                                               fieldLabel: '存放位置',
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
	                                           fieldLabel: '生产开始日期',
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
	                                               fieldLabel: '生产结束日期',
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
	                                           fieldLabel: '检验开始日期',
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
	                                               fieldLabel: '检验结束日期',
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
	                                           fieldLabel: '主检人',
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
	                                               fieldLabel: '审核人',
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
	                                           fieldLabel: '批准人',
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
	                                               fieldLabel: '报告日期',
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
	                                           fieldLabel: '备注',
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
	                                           fieldLabel: '产品名称',
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
	                                               fieldLabel: '样品编号',
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
	                                                   fieldLabel: '质检别名',
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
	                                           fieldLabel: '代表量',
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
	                                               fieldLabel: '取样称重',
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
	                                                   fieldLabel: '环境温度',
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
	                                           fieldLabel: '抽样方法',
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
	                                               fieldLabel: '检验标准',
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
	                                                   fieldLabel: '判定标准',
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
                                   Ext.Msg.alert("该产品质检还未配置质检模板！");
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
                               Ext.Msg.alert("提示", "获取质检模板出错,请重新打开该页！");
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
                           Ext.Msg.alert("提示", "请输入取样重量！");
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
                               Ext.Msg.alert("提示", "请填写完各指标项值！");
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
                           //成功时回调 
                           success: function(response, options) {
                               //获取响应的json字符串

                               Ext.Msg.alert("提示", "保存成功！");
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
                               Ext.Msg.alert("提示", "保存失败！");
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
                               //成功时回调 
                               success: function(response, options) {
                                   //获取响应的json字符串

                                   if (response != null && response.responseText != 'undefined' && response.responseText != null && response.responseText != '') {
                                       if (response.responseText.length < 5) {
                                           Ext.Msg.alert("提示", "未找到匹配的质检模板！");
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
                                                       str += "<tr><td width='30%'>" + data[x].QuotaName + "(" + data[x].QuotaUnit + ")</td><td width='20%'><select id='quota" + data[x].QuotaNo + "' name='quota" + data[x].QuotaNo + "'><option selected='selected' value='1'>符合</option><option value='0'>不符合</option></select></td>";
                                                   }
                                                   else {
                                                       str += "<tr><td width='30%'>" + data[x].QuotaName + "(" + data[x].QuotaUnit + ")</td><td width='20%'><input type='text' id='quota" + data[x].QuotaNo + "' name='quota" + data[x].QuotaNo + "'></td>";
                                                   }
                                               } else {
                                                   if (data[x].ControlType == 'Q012') {
                                                       str += "<td width='30%'> " + data[x].QuotaName + "(" + data[x].QuotaUnit + ")</td><td width='20%'><select id='quota" + data[x].QuotaNo + "' name='quota" + data[x].QuotaNo + "'><option selected='selected' value='1'>符合</option><option value='0'>不符合</option></select></td></tr>";
                                                   }
                                                   else {
                                                       str += "<td width='30%'>" + data[x].QuotaName + "(" + data[x].QuotaUnit + ")</td><td width='20%'><input type='text' id='quota" + data[x].QuotaNo + "' name='quota" + data[x].QuotaNo + "'></td></tr>";
                                                   }
                                               }

                                           }
                                           if (data[detaillength - 1].ControlType == 'Q012') {
                                               str += "<tr><td width='30%'> " + data[detaillength - 1].QuotaName + "(" + data[detaillength - 1].QuotaUnit + ")</td><td width='20%'><select id='quota" + data[detaillength - 1].QuotaNo + "' name='quota" + data[detaillength - 1].QuotaNo + "'><option value='1' selected='selected'>符合</option><option value='0'>不符合</option></select></td><td></td><td></td></tr>"
                                           } else {
                                               str += "<tr><td width='30%'>" + data[detaillength - 1].QuotaName + "(" + data[detaillength - 1].QuotaUnit + ")</td><td width='20%'><input type='text' id='quota" + data[detaillength - 1].QuotaNo + "' name='quota" + data[detaillength - 1].QuotaNo + "'></td><td></td><td></td></tr>"
                                           }
                                       } else {

                                           for (var x = 0; x < detaillength; x++) {
                                               if (x % 2 == 0) {
                                                   if (data[x].ControlType == 'Q012') {
                                                       str += "<tr><td width='30%'>" + data[x].QuotaName + "(" + data[x].QuotaUnit + ")</td><td width='20%'><select id='quota" + data[x].QuotaNo + "' name='quota" + data[x].QuotaNo + "'><option selected='selected' value='1'>符合</option><option value='0'>不符合</option></select></td>";
                                                   }
                                                   else {
                                                       str += "<tr><td width='30%'>" + data[x].QuotaName + "(" + data[x].QuotaUnit + ")</td><td width='20%'><input type='text' id='quota" + data[x].QuotaNo + "' name='quota" + data[x].QuotaNo + "'></td>";
                                                   }
                                               } else {
                                                   if (data[x].ControlType == 'Q012') {
                                                       str += "<td width='30%'>" + data[x].QuotaName + "(" + data[x].QuotaUnit + ")</td><td width='20%'><select id='quota" + data[x].QuotaNo + "' name='quota" + data[x].QuotaNo + "'><option selected='selected' value='1'>符合</option><option value='0'>不符合</option></select></td></tr>";
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
                                   Ext.Msg.alert("提示", "获取质检模板出错,请重新打开该页！");
                               }
                           });
                       }
                   }
                   function setStandardValue() {




                   }
    var quotaTemplate_form = new Ext.form.FormPanel({
       renderTo: "notify_form",
       frame: true,
       monitorValid: true, // 把有formBind:true的按钮和验证绑定
       layout: "form",
       items: [{
           layout: 'column',   //定义该元素为布局为列布局方式
           border: false,
           labelSeparator: '：',
           items: [{
                   columnWidth: .28,
                   layout: 'form',
                   border: false,
                   labelWidth: 55,
                   items: [{
                    cls: 'key',
		            xtype: 'textfield',
		            fieldLabel: '供应商 ',
		            name: 'prno',
		            id: 'prno',
		            anchor: '90%'
                }]
            }
		    ,{
		        columnWidth: .32,
		        layout: 'form',
		        labelWidth: 95,
		        border: false,
		        items: [{
		            cls: 'key',
		            xtype: 'textfield',
		            fieldLabel: '产品编号或名称 ',
		            name: 'productno',
		            id: 'productno',
		            anchor: '90%'
		        }]
		    }]
        },
        {
            layout: 'column',   //定义该元素为布局为列布局方式
           border: false,
           labelSeparator: '：',
           items: [
		   {
		        columnWidth: .3,
		        layout: 'form',
		        labelWidth: 85,
		        border: false,
		        items: [{
		            cls: 'key',
		            xtype: 'datefield',
		            fieldLabel: '生产开始时间',
		            name: 'dstart',
		            id: 'dstart',
		            anchor: '90%',
		            format:'Y年m月d日',
		            value:getThisMonthFirstDay('/').clearTime()
                }]
		    },{
		        columnWidth: .3,
		        layout: 'form',
		        labelWidth: 85,
		        border: false,
		        items: [{
		            cls: 'key',
		            xtype: 'datefield',
		            fieldLabel: '生产结束时间',
		            name: 'dend',
		            id: 'dend',
		            anchor: '90%',
		            format:'Y年m月d日',
		            value: new Date().clearTime()
                }]
		    },{
		        columnWidth: .3,
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
		            text: '查询',
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
                                   var prno = Ext.getCmp("prno").getValue();
                                   var productno = Ext.getCmp("productno").getValue();
                                   var dstart = Ext.util.Format.date(Ext.getCmp('dstart').getValue(),'Y/m/d');
                                   var dend = Ext.util.Format.date(Ext.getCmp('dend').getValue(),'Y/m/d');
                                   var sup = ckcombo.getValue();
                                   //customerListStore.baseParams.deno=deno;
                                   //customerListStore.baseParams.shno=shno;
                                   customerListStore.baseParams.prno=prno;
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
			    url: 'frmQtQualityCheckNotify.aspx?method=getCNList&zjtype=Q093',
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
			              //数据加载预处理,可以做一些合并、格式处理等操作
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
                   loadMask: { msg: '正在加载数据，请稍侯……' },
                   sm: sm,
                   cm: new Ext.grid.ColumnModel([
                        sm,

                        new Ext.grid.RowNumberer(), //自动行号
                        {header: '所属公司', dataIndex: 'OrgName' ,hidden:true,hideable:false },
                        {header: '结果ID', dataIndex: 'CheckResultId' ,hidden:true,hideable:false },
                        { header: '质检类型', dataIndex: 'DicsName',width:60 },
				        { header: '货单编号', dataIndex: 'DeliveryNo' ,hidden:true,hideable:false},
				        { header: '车船号', dataIndex: 'ShipNo' ,width:70},
						{ header: '供应商名称', dataIndex: 'SupplierName' ,width:150},
						{ header: '产品编号', dataIndex: 'ProductNo',width:60 },
						{ header: '产品名称', dataIndex: 'ProductName' ,width:150},
						{ header: '代表量', dataIndex: 'RepresentAmount',width:50 },
						{ header: '未检测量', dataIndex: 'NocheckNo',width:60 },
						{ header: '进仓日期', dataIndex: 'ProductDate',width:120 },
						{ header: '仓库', dataIndex: 'WhName' },
						{ header: '放置地点', dataIndex: 'WhpName' },
						{ header: '是否质检完成', dataIndex: 'Status', renderer: cktp }

		              ]), 
                       bbar: new Ext.PagingToolbar({
                           pageSize: 10,
                           store: customerListStore,
                           displayMsg: '显示第{0}条到{1}条记录,共{2}条',
                           emptyMsy: '没有记录',
                           displayInfo: true
                       }),
                       viewConfig: {
                           columnsText: '显示的列',
                           scrollOffset: 20,
                           sortAscText: '升序',
                           sortDescText: '降序',
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