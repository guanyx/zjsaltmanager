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
var quotaCount;
           var quotaArr = new Array();
var modify_quota_id = 'none';
var addmark = 0;
Ext.BLANK_IMAGE_URL = "../ext3/resources/images/default/s.gif";
Ext.onReady(function() {
   var Toolbar = new Ext.Toolbar({
       renderTo: "quota_toolbar",
       items: [{
           id:'addBtn',
           text: "新增",
           icon: '../Theme/1/images/extjs/customer/add16.gif',
           handler: function() {
               // saveType = "add";
               // openAddQuotaWin();//点击后，弹出添加信息窗口
               quotaWindow.title="新增指标";
               addmark = 1;
               quotaWindow.show();
               Ext.getCmp('Quota_Org').hide();
               Ext.getCmp('Quota_Org').getEl().up('.x-form-item').setDisplayed(false);
               addQuotaForm.getForm().reset();
           }
       }, '-', {
           text: "修改",
           icon: '../Theme/1/images/extjs/customer/edit16.gif',
           handler: function() {
               ///  deleteCustomer();
               
               var selectData = quotaGrid.getSelectionModel().getCount();
               if (selectData == 0) {
                   Ext.Msg.alert("提示", "请选中要修改的记录！");
                   return;
               }
               if (selectData > 1) {
                   Ext.Msg.alert("提示", "一次只能修改一条记录！");
                   return;
               }
               quotaWindow.title="修改指标";
               addmark = 0;
               modifyQuota(selectData);
               Ext.getCmp('Quota_Org').hide();
               Ext.getCmp('Quota_Org').getEl().up('.x-form-item').setDisplayed(false);
           }
       }, '-', {
           text: "删除",
           icon: '../Theme/1/images/extjs/customer/delete16.gif',
           handler: function() {
               Ext.Msg.confirm("提示信息", "确定要删除该指标项？", function callBack(id) {
                   //判断是否删除数据
                   if (id == "yes") {
                       var selectData = quotaGrid.getSelectionModel().getCount();
                       if (selectData == 0) {
                           Ext.Msg.alert("提示", "请选中要删除的记录！");
                           return;
                       }
                       delQuota(selectData);
                    }
                });
           }
        },'-', {
           text: "对应标准",
           icon: '../Theme/1/images/extjs/customer/delete16.gif',
           handler: function() {

               var selectData = quotaGrid.getSelectionModel().getCount();
               if (selectData == 0) {
                   Ext.Msg.alert("提示", "请选中要设置的指标！");
                   return;
               }
               setQuotaToTemplage(selectData);
           }
        }, '-'
//        , {
//           id:'distBtn',
//           text: "指标分配",
//           icon: '../Theme/1/images/extjs/customer/add16.gif',
//           handler: function() {

//               var selectData = quotaGrid.getSelectionModel().getCount();
//               if (selectData == 0) {
//                   Ext.Msg.alert("提示", "请选中要分配的指标行！");
//                   return;
//               }
//               addmark = -1;
//               modifyQuota(selectData);
//               var OrgFilterCombo = new Ext.form.ComboBox({
//                    store: dsOrgs,
//                    displayField: 'OrgShortName',
//                    displayValue: 'OrgId',
//                    typeAhead: false,
//                    minChars: 1,
//                    loadingText: 'Searching...',
//                    tpl: resultTpl,
//                    pageSize: 10,
//                    listWidth:300,
//                    hideTrigger: true,
//                    applyTo: 'Quota_Org',
//                    itemSelector: 'div.search-item',
//                    onSelect: function(record) { // override default onSelect to do redirect  
//                        Ext.getCmp('Quota_Org').setValue(record.data.OrgShortName);
//                        Ext.getCmp('Quota_OrgId').setValue(record.data.OrgId);
//                        this.collapse();
//                    }
//                });
//               Ext.getCmp('Quota_Org').show();
//               Ext.getCmp('Quota_Org').getEl().up('.x-form-item').setDisplayed(true);
//           }
//        }
        ]
    });
    if (typeof (quotaWindow) == "undefined") {//解决创建2个windows问题
       var quotaWindow = new Ext.Window({
           title: '新增指标',
           modal: 'true',
           width: 300,
           //height: 273,
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

                   addQuota();

               }
           }, {
               text: '关闭',
               handler: function() {
                   quotaWindow.hide();
                   addQuotaForm.getForm().reset();
               }
            }]
        });
    }

if (typeof (quotaTemplateWindow) == "undefined") {//解决创建2个windows问题
       var quotaTemplateWindow = new Ext.Window({
           title: '设置指标对应检测标准',
           modal: 'true',
           width: 670,
           //height: 273,
           collapsible: true, //是否可以折叠 
           closable: true, //是否可以关闭 
           //maximizable : true,//是否可以最大化 
           closeAction: 'hide',
           constrain: true,
           resizable: false,
           autoScroll:true,
           plain: true,
           // ,items: addQuotaForm
           buttons: [{
               text: '全选',
               handler: function() {
                   for (var y = 0; y < quotaCount; y++) {
                    Ext.get(quotaArr[y]).dom.checked=true;                  

                   }
               }
           },{
               text: '清除',
               handler: function() {
                   for (var y = 0; y < quotaCount; y++) {
                    Ext.get(quotaArr[y]).dom.checked=false;                  

                   }
               }
           },{
               text: '保存',
               handler: function() {
                   saveQuotaTemplate();
               }
           }, {
               text: '关闭',
               handler: function() {
                   quotaTemplateWindow.hide();
               }
            }]
        });
    }


   //指标类型
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
       blankText: '指标类型不能为空',
       forceSelection: true,
       emptyText: '请选择指标类型',
       editable: false,
       triggerAction: 'all',
       fieldLabel: '指标类型',
       selectOnFocus: true,
       anchor: '90%'
   });

   //指标类型
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
       blankText: '指标项类型不能为空',
       forceSelection: true,
       emptyText: '请选择指标项类型',
       editable: false,
       triggerAction: 'all',
       fieldLabel: "指标项类型<font color='red'>*</font>",
       selectOnFocus: true,
       anchor: '90%'
   });

    //控件类型
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
       blankText: '控件类型不能为空',
       forceSelection: true,
       emptyText: '请选择控件类型',
       editable: false,
       triggerAction: 'all',
       fieldLabel: "控件类型<font color='red'>*</font>",
       selectOnFocus: true,
       anchor: '90%'
   });
   
    //控件类型
   var Value_TypeCombo = new Ext.form.ComboBox({
       xtype: 'combo',
       store: new Ext.data.Store({
           autoLoad: true,
           baseParams: {
               trancode: 'Menu'
           },
           proxy: new Ext.data.HttpProxy({
               url: 'frmQtQuotaItemCfg.aspx?method=getType&key=Value'
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
       blankText: '输入值类型',
       forceSelection: true,
       emptyText: '请选择输入值类型',
       editable: false,
       triggerAction: 'all',
       fieldLabel: "输入值类型<font color='red'>*</font>",
       selectOnFocus: true,
       anchor: '90%'
   });
   //定义客户下拉框异步调用方法            
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
   // 定义组织下拉框异步返回显示模板
    var resultTpl = new Ext.XTemplate(
            '<tpl for="."><div id="searchkhdivid" class="search-item">',
                '<h3><span>编号：{OrgCode} 名称： {OrgShortName}</span> ',
    //'<br>创建时间：{createDate}',  
            '</div></tpl>'
    );
    
    function saveQuotaTemplate()
    {
        //添加规格型号信息，使得在配置指标项时，可以直接下达到规格型号中
        var recorddel = quotaGrid.getSelectionModel().getSelections();
        var templateNo='';
        for(var i=0;i<quotaCount;i++)
        {
            if(Ext.get(quotaArr[i]).dom.checked)
            {
                if(templateNo.length>0)
                    templateNo+=",";
                templateNo+=quotaArr[i];
            }
        }
        Ext.Ajax.request({
           url: 'frmQtQuotaItemCfg.aspx?method=saveQuotaTemplate'
           , params: {
            QuotaNo:recorddel[0].data.QuotaNo,
            TemplateNo:templateNo
           },
           //成功时回调 
           success: function(response, options) {
               //获取响应的json字符串
               Ext.Msg.alert("提示", response.responseText);               
           },
           failure: function() {
               Ext.Msg.alert("提示", "获取指标配置项出错,请重新打开该页！");
           }
       });
        quotaTemplateWindow.hide();
    }
    function setQuotaToTemplage(selectData)
    {
        //添加规格型号信息，使得在配置指标项时，可以直接下达到规格型号中
        var recorddel = quotaGrid.getSelectionModel().getSelections();
    Ext.Ajax.request({
       url: 'frmQtQuotaItemCfg.aspx?method=getQuotaTemplate'
       , params: {
        QuotaNo:recorddel[0].data.QuotaNo
       },
       //成功时回调 
       success: function(response, options) {
           //获取响应的json字符串

           if (response != null && response.responseText != 'undefined' && response.responseText != null) {
               var result=","+response.responseText+",";
               for(var i=0;i<quotaCount;i++)
               {
                    if(result.indexOf(","+quotaArr[i]+",")!=-1)
                    {
                        Ext.get(quotaArr[i]).dom.checked=true;
                    }
                    else
                         Ext.get(quotaArr[i]).dom.checked=false;
               }
           }

       },
       failure: function() {
           Ext.Msg.alert("提示", "获取指标配置项出错,请重新打开该页！");
       }
   });
        quotaTemplateWindow.show();
    }
    
   
   //修改指标
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
       Ext.getCmp("QuotaExt3").setValue(record.QuotaExt3);
       Value_TypeCombo.setValue(record.QuotaExt2);
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
           //成功时回调 
           success: function(response, options) {
               //获取响应的json字符串
                Ext.Msg.alert("提示", "删除成功！");
               for (var i = 0; i < recorddel.length; i++) {
                    customerListStore.remove(recorddel[i]);
               }
           },
           failure: function() {
               Ext.Msg.alert("提示", "删除失败！");
           }
       });
   }

  //新增指标
   function addQuota() {
       var Quota_Name = Ext.getCmp("Quota_Name").getValue();
       if (Quota_Name == null || Quota_Name.trim() == '') {
           Ext.Msg.alert("提醒", "指标名称不能为空！");
           return;
       }
       var Quota_Alias = Ext.getCmp("Quota_Alias").getValue();
        if (Quota_Alias == null || Quota_Alias.trim() == '') {
       Ext.Msg.alert("提醒", "指标英文名称不能为空！");
       return;
       }  

       var Quota_Unit = Ext.getCmp("Quota_Unit").getValue();
       /* if (Quota_Unit == null || Quota_Unit.trim() == '') {
       Ext.Msg.alert("提醒", "单位不能为空！");
       return;
       }
      */
       var Quota_Type = Quota_TypeCombo.getValue();
       if (Quota_Type == null || Quota_Type.trim() == '' || Quota_Type == 'undefined') {
       Ext.Msg.alert("提醒", "请选择指标类型！");
       return;
       }
       var Control_Type = Control_TypeCombo.getValue();
       if (Control_Type == null || Control_Type.trim() == '' || Control_Type == 'undefined') {
       Ext.Msg.alert("提醒", "请选择控件类型！");
       return;
       }
       var QuotaItem_Type = QuotaItem_TypeCombo.getValue();
       if (QuotaItem_Type == null || QuotaItem_Type.trim() == '' || QuotaItem_Type == 'undefined') {
       Ext.Msg.alert("提醒", "请选择控件类型！");
       return;
       }
       var valueType = Value_TypeCombo.getValue();
       if (valueType == null || valueType.trim() == '' || valueType == 'undefined') {
            Ext.Msg.alert("提醒", "请选择指标输入类型！");
           return;
       }
       var Quota_OrgId = Ext.getCmp('Quota_OrgId').getValue();
      
       var Sort_Id = Ext.getCmp("Sort_Id").getValue();
       /* if (Sort_Id == null || Sort_Id.trim() == '') {
       Ext.Msg.alert("提醒", "排序序号不能为空！");
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
           , QuotaOrgId: Quota_OrgId,
             QuotaExt2:valueType,
             QuotaExt3:Ext.getCmp("QuotaExt3").getValue()
           },
           //成功时回调 
           success: function(response, options) {
               //获取响应的json字符串

               Ext.Msg.alert("提示", "保存成功！");
               quotaWindow.hide();
               addQuotaForm.getForm().reset();

               var serchQuotaName = Ext.getCmp("serchQuotaName").getValue();
               customerListStore.baseParams.start=0;
               customerListStore.baseParams.limit=10;
               customerListStore.baseParams.key=serchQuotaName;
               customerListStore.load();
           },
           failure: function() {
               Ext.Msg.alert("提示", "保存失败！");
           }
       });

   }

/**********************************************************/

   var quotaTemplateForm = new Ext.form.FormPanel({
        frame: true,
        //autoHeight:true,
        width:650,
        bodyStyle : 'overflow-x:hidden; overflow-y:scroll' ,
        height:350,
        title:'商品型号规格信息'
   });

   var addQuotaForm = new Ext.form.FormPanel({
       frame: true,
       monitorValid: true, // 把有formBind:true的按钮和验证绑定
       labelWidth: 100,
       items: [{
           layout: 'form',
           layout: 'column',
           items: [{
               layout: 'form',
               columnWidth: 1,  //该列占用的宽度，标识为20％
               border: false,
               items: [{
                   cls: 'key',
                   xtype: 'textfield',
                   fieldLabel: "指标项中文名称<font color='red'>*</font>",
                   name: 'Quota_Name',
                   id: 'Quota_Name',
                   anchor: '90%'
               }, {
                   cls: 'key',
                   xtype: 'textfield',
                   fieldLabel: "指标项英文名称<font color='red'>*</font>",
                   name: 'Quota_Alias',
                   id: 'Quota_Alias',
                   anchor: '90%'
               }, {
                   cls: 'key',
                   xtype: 'textfield',
                   fieldLabel: "单位<font color='red'>*</font>",
                   name: 'Quota_Unit',
                   id: 'Quota_Unit',
                   anchor: '90%'
               },Value_TypeCombo, Quota_TypeCombo, Control_TypeCombo, QuotaItem_TypeCombo,{
                   cls: 'key',
                   xtype: 'numberfield',
                   fieldLabel: '排序序号',
                   name: 'Sort_Id',
                   id: 'Sort_Id',
                   maxValue: 99999,  
                   minValue: 0, 
                   anchor: '90%'
                },{
                   cls: 'key',
                   xtype: 'textfield',
                   fieldLabel: '名称打印格式',
                   name: 'QuotaExt3',
                   id: 'QuotaExt3',
                   anchor: '90%'
               },{
                   cls: 'key',
                   xtype: 'textfield',
                   fieldLabel: '组织',
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
    
    //添加规格型号信息，使得在配置指标项时，可以直接下达到规格型号中
    Ext.Ajax.request({
       url: 'frmQtQuotaItemCfg.aspx?method=getTemplate'
       , params: {},
       //成功时回调 
       success: function(response, options) {
           //获取响应的json字符串

           if (response != null && response.responseText != 'undefined' && response.responseText != null && response.responseText != '') {
               var data = Ext.util.JSON.decode(response.responseText);
               var panelstr = "new Ext.Panel({labelWidth: 30,autoWidth: true,autoHeight: true,layout: 'column', items: [";


               quotaCount = data.length;
               for (var i = 0; i < quotaCount; i++) {
                   quotaArr[i] = data[i].TemplateNo;

                   //    addQuotaForm.items.add(eval("quotaCheckBox" + i + "= new Ext.form.Checkbox({cls:'key',value:'" + data[i].QuotaNo + "',boxLabel:'" + data[i].QuotaName + " " + data[i].QuotaUnit + "',name: '" + data[i].QuotaNo + "', id: 'quotaCheckBox" + i + "',anchor: '90%'});"));
                   panelstr += " {style: 'align:left',columnWidth: 0.5,layout: 'form',border: false,items: [{cls: 'key', value:'" + data[i].TemplateNo + "' ,xtype: 'checkbox',boxLabel: '" + data[i].TemplateName  + "',name: '" + data[i].TemplateNo + "',id: '" + data[i].TemplateNo + "',anchor: '99%'}]},";
               }
               panelstr = panelstr.substring(0, panelstr.length - 1);
               panelstr += "]})";

               quotaTemplateForm.add(eval(panelstr));
           }

       },
       failure: function() {
           Ext.Msg.alert("提示", "获取指标配置项出错,请重新打开该页！");
       }
   });
    quotaTemplateWindow.add(quotaTemplateForm);//添加商品规格信息
    quotaWindow.add(addQuotaForm);
    
    var quota_form = new Ext.form.FormPanel({
       renderTo: "quota_form",
       frame: true,
       monitorValid: true, // 把有formBind:true的按钮和验证绑定
       layout: "form",
       items: [{
           layout: 'column',   //定义该元素为布局为列布局方式
           border: false,
           labelSeparator: '：',
           items: [{
               columnWidth: .3,
               layout: 'form',
               border: false,
               labelWidth: 55,
               items: [{
                   cls: 'key',
                   xtype: 'textfield',
                   fieldLabel: '指标名称',
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
		            text: '查询',
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
	    { name: 'QuotaExt2' },
	    { name: 'QuotaExt3' },
	    { name: 'OperName' },
	     { name: 'EmpName' }
	    ]),
	    listeners:
	      {
	          scope: this,
	          load: function() {
	              //数据加载预处理,可以做一些合并、格式处理等操作
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
       loadMask: { msg: '正在加载数据，请稍侯……' },
       sm: sm,
       /*  如果中间没有查询条件form那么可以直接用tbar来实现增删改
       tbar:[{
       text:"添加",
       handler:this.showAdd,
       scope:this
       },"-",
       {
       text:"修改"
       },"-",{
       text:"删除",
       handler:this.deleteBranch,
       scope:this
       }],
       */
       cm: new Ext.grid.ColumnModel([
        sm,
        new Ext.grid.RowNumberer(), //自动行号
        { header: '指标号', hidden: true, dataIndex: 'QuotaNo' },
        { header: '指标名称', dataIndex: 'QuotaName' },
        { header: '指标别名', hidden: true, dataIndex: 'QuotaAlias' },
        { header: '单位', dataIndex: 'QuotaUnit' },
		{ header: '指标代码', dataIndex: 'QuotaType', hidden: true },
		{ header: '指标项类型', dataIndex: 'ItemType', hidden: true },
		//{ header: '指标类型', dataIndex: 'QuotaTypeName' },
		{ header: '控件代码', dataIndex: 'ControlType' ,hidden: true },
		{ header: '控件类型', dataIndex: 'DicsName' },
		{ header: '排序号', dataIndex: 'SortId' },
		{ header: '操作日期', dataIndex: 'CreateDate' },
		{ header: '操作人', dataIndex: 'EmpName' }
	]), 
	listeners:
	{
	      rowselect: function(sm, rowIndex, record) {
	          //行选中
	          //Ext.MessageBox.alert("提示","您选择的出版号是：" + r.data.ASIN);
	      },
	      rowclick: function(grid, rowIndex, e) {
	          //双击事件
	      },
	      rowdbclick: function(grid, rowIndex, e) {
	          //双击事件
	      },
	      cellclick: function(grid, rowIndex, columnIndex, e) {
	          //单元格单击事件			           
	      },
	      celldbclick: function(grid, rowIndex, columnIndex, e) {
	          //单元格双击事件
	          /*
	          var record = grid.getStore().getAt(rowIndex); //Get the Record
	          var fieldName = grid.getColumnModel().getDataIndex(columnIndex); //Get field name
	          var data = record.get(fieldName);
	          Ext.MessageBox.alert('show','当前选中的数据是'+data); 
	          */
	      }
	  },
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
   
   customerListStore.reload({params:{limit:10,start:0}});
}); 
		
	</script>
</html>
