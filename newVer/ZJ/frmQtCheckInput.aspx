<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmQtCheckInput.aspx.cs" Inherits="ZJ_frmQtCheckInput" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>指标输入</title>
    <link rel="stylesheet" type="text/css" href="../ext3/resources/css/ext-all.css" />
<script type="text/javascript" src="../ext3/adapter/ext/ext-base.js"></script>
<script type="text/javascript" src="../ext3/ext-all.js"></script>
<script type="text/javascript" src="../ext3/example/ItemDeleter.js"></script>
<script type="text/javascript" src="../js/operateResp.js"></script>
<script type="text/javascript" src="../ext3/src/locale/ext-lang-zh_CN.js"></script>

<style type="text/css">
.label-class{
                color: red;
                font-weight:bold;
            }
</style>
<%=getComboBoxStore() %>
<script type="text/javascript">

Ext.onReady(function() {
Ext.QuickTips.init();
Ext.BLANK_IMAGE_URL = "../ext3/resources/images/default/s.gif"; 
var toolBar = new Ext.Toolbar({
            renderTo: "toolbar",
            items: [ {
                text: "保存",
                icon: "../Theme/1/images/extjs/customer/save.gif",
                handler: function() {
                    saveForm();
                }
            }, '-',{
                text: "打印",
                icon: "../Theme/1/images/extjs/customer/print2.png",
                handler: function() {
                    printCheck();
                }
            }, '-',{
                text: "帮助",
                icon: "../Theme/1/images/extjs/customer/help.ico",
                handler: function() {
                    window.open("../help/zj/helpcheckinput.htm","","","");
                }
            }, '-']
        });
        
        setToolBarVisible(toolBar);
        function getUrl(imageUrl)
            {
                var index = window.location.href.toLowerCase().indexOf('/zj/');
                var tempUrl = window.location.href.substring(0,index);
                return tempUrl+"/"+imageUrl;
            }
function printCheck()
{
                Ext.Ajax.request({
                    url: 'frmQtCheckInput.aspx?method=printdata',
                    method: 'POST',
                    params: {
                        CheckId: checkId
                    },
                   success: function(resp,opts){ 
                       var printData =  resp.responseText;
                       var printControl =document.getElementById("printControl1");
//parent.parent.parent.document.getElementById("topFrame").contentWindow.getPrintControl(); 
                       printControl.Url =getUrl('xml');
                       printControl.MapUrl = printControl.Url+'/'+printStyleXml;//'/salePrint1.xml';
                       printControl.PrintXml = printData;
                       printControl.ColumnName="CheckId";
                       printControl.OnlyData=printOnlyData;
                       printControl.PageWidth=printPageWidth;
                       printControl.PageHeight =printPageHeight ;
                       printControl.Print();                 
                       
                   },
		           failure: function(resp,opts){  /* Ext.Msg.alert("提示","保存失败"); */    }
                });
}

    //检测标准
               var checkTemplateCombo = new Ext.form.ComboBox({
                   xtype: 'combo',
                   store:templateStore,
                   valueField: 'TemplateNo',
                   displayField: 'TemplateName',
                   mode: 'local',
                   forceSelection: true,
                   editable: false,
                   emptyValue: '',
                   triggerAction: 'all',
                   fieldLabel: "检测标准<font color='red'>*</font>",
                   name:'TemplateNo',
                   id:'TemplateNo',
                   selectOnFocus: true,
                   anchor: '95%',
                   width:100,
				   editable:false,
				   onSelect: function(record) {
				        Ext.getCmp("TemplateNo").setValue(record.data.TemplateNo);
				        templageComboChange(record.data.TemplateNo,'');
                        this.collapse();//隐藏下拉列表                        
                    }
               });
   function templageComboChange(templateNo,checkLevel)
   {
        createControlByTemplate(templateNo,checkLevel);
        levelStore.baseParams.TemplateNo=templateNo;
        levelStore.load({
            callback:function(){
                if(checkLevel!=''){
                    checkLevelCombo.setValue(checkLevel);
                }
            }
        });
        
   }
   
   var levelStore;//检测等级
     if (levelStore == null) { //防止重复加载
        levelStore = new Ext.data.JsonStore({
            totalProperty: "result",
            root: "root",
            url: 'frmQtCheckInput.aspx?method=getlevelbytemplate',
            fields: ['LevelId','SaltLevel']
        })
     };
     
     var packLevelStore;//包装等级
     if (packLevelStore == null) { //包装等级
        packLevelStore = new Ext.data.JsonStore({
            totalProperty: "result",
            root: "root",
            url: 'frmQtCheckInput.aspx?method=getlevelbytemplate',
            fields: ['LevelId','SaltLevel'],
            listeners:
	        {
	            scope: this,
	            load: function(xstore ,  record , option ) {
                    var u = new xstore.recordType({ 'LevelId':-1,'SaltLevel':'未标识' });
                    xstore.insert(0, u);
	                packLevelCombo.setValue(packLevelCombo.getValue());
	            }
	        }
        })
     };
   
   var saltCombo = new Ext.form.ComboBox({
                   xtype: 'combo',
                   store:saltStore,
                   valueField: 'SaltId',
                   displayField: 'SaltName',
                   mode: 'local',
                   forceSelection: true,
                   editable: false,
                   emptyValue: '',
                   triggerAction: 'all',
                   fieldLabel: "型号<font color='red'>*</font>",
                   name:'SaltId',
                   id:'SaltId',
                   selectOnFocus: true,
                   anchor: '95%',
                   width:140,
				   editable:false,
				   onSelect: function(record) {
			            this.setValue(record.data.SaltId);
			            packLevelStore.baseParams.SaltId = record.data.SaltId;
                        packLevelStore.load();
                      
                        this.collapse();//隐藏下拉列表
                    }
               });
   
   var checkLevelCombo = new Ext.form.ComboBox({
                   xtype: 'combo',
                   store:levelStore,
                   valueField: 'LevelId',
                   displayField: 'SaltLevel',
                   mode: 'local',
                   forceSelection: true,
                   editable: false,
                   emptyValue: '',
                   triggerAction: 'all',
                   fieldLabel: "检测等级<font color='red'>*</font>",
                   name:'LevelId',
                   id:'LevelId',
                   selectOnFocus: true,
                   anchor: '95%',
                   width:140,
				   editable:false,
				   onSelect: function(record) {
				        setStandardByLevel(record.data.LevelId);
				        checkLevelCombo.setValue(record.data.LevelId);
                        this.collapse();//隐藏下拉列表
                        checkAllValue();
                    }
               });
    var packLevelCombo = new Ext.form.ComboBox({
                   xtype: 'combo',
                   store:packLevelStore,
                   valueField: 'LevelId',
                   displayField: 'SaltLevel',
                   mode: 'local',
                   forceSelection: true,
                   editable: false,
                   emptyValue: '',
                   triggerAction: 'all',
                   fieldLabel: "包装等级<font color='red'>*</font>",
                   name:'ProductPackLevel',
                   id:'ProductPackLevel',
                   selectOnFocus: true,
                   anchor: '95%',
                   width:140,
				   editable:false
				   
               });           
    
    function setStandardByLevel(levelId)
    {
        Ext.Ajax.request({
            url: 'frmQtCheckInput.aspx?method=getstandardbylevel',
            method: 'POST',
            params: {
                LevelId:levelId
            },
           success: function(resp,opts){              
               var items = eval(resp.responseText);
               setLevelStandard(items);
           },
           failure: function(resp,opts){  /* Ext.Msg.alert("提示","保存失败"); */    }
        });
    }
    function setLevelByTemplate(templateNo)
    {
        Ext.Ajax.request({
            url: 'frmQtCheckInput.aspx?method=getstandardbytemplate',
            method: 'POST',
            params: {
                TemplateNo:templateNo
            },
           success: function(resp,opts){              
               var items = eval(resp.responseText);
               checkLevelCombo.store = items;
               
           },
           failure: function(resp,opts){  /* Ext.Msg.alert("提示","保存失败"); */    }
        });
    }
    
    //当查看Check时，获取Check指标项目信息
    function setDetailValue()
    {
        Ext.Ajax.request({
            url: 'frmQtCheckInput.aspx?method=getcheckresult',
            method: 'POST',
            params: {
                CheckId:checkId
            },
           success: function(resp,opts){ 
              
               var items = eval(resp.responseText);
               for(var i=0;i<items.length;i++)
               {
                    if(items[i].ResultNumValue>0)
                    {
                        Ext.getCmp('txtResultValue'+items[i].QuotaNo).setValue(items[i].ResultNumValue);
                    }
                    else
                    {
                        if(Ext.getCmp('txtResultValue'+items[i].QuotaNo)==null)
                        {
                            Ext.getCmp('cmbChar'+items[i].QuotaNo).setValue(items[i].ResultResult);
                        }
                        else
                        {
                            Ext.getCmp('txtResultValue'+items[i].QuotaNo).setValue(items[i].ResultNumValue);
                        }
                    }
                    Ext.getCmp('cmbResult'+items[i].QuotaNo).setValue(items[i].ResultResult);
                    if(items[i].ResultLeftOperator!='')
                        Ext.getCmp('cmbLeft'+items[i].QuotaNo).setValue(items[i].ResultLeftOperator);
               }
               checkLevelCombo.setValue(items[0].LevelId);
               setStandardByLevel(items[0].LevelId);
               
               
           },
           failure: function(resp,opts){  /* Ext.Msg.alert("提示","保存失败"); */    }
        });
    }
    function createControlByTemplate(templateNo,checkLevel)
    {       
        document.getElementById('divloading').style.display="block";
        Ext.Ajax.request({
            url: 'frmQtCheckInput.aspx?method=getstandardbytemplate',
            method: 'POST',
            params: {
                TemplateNo:templateNo
            },
           success: function(resp,opts){ 
              
               var items = eval(resp.responseText);
               quotaItems = items;
               createStandardControl(items);
               if(checkId>0)
               {
                setDetailValue();
               }     
               if(checkLevel!=''){
                   setStandardByLevel(checkLevel);
               }          
           },
           failure: function(resp,opts){  /* Ext.Msg.alert("提示","保存失败"); */    },
           callback:function(resp,opts){
                document.getElementById('divloading').style.display="none";
           }
        });
    }
    
    //定义产品下拉框异步调用方法
            var dsProducts;
            if (dsProducts == null) {
                dsProducts = new Ext.data.Store({
                    url: 'frmQtCheckInput.aspx?method=getSaltProduct',
                    reader: new Ext.data.JsonReader({
                        root: 'root',
                        totalProperty: 'totalProperty'
                    }, [
                            { name: 'ProductId', mapping: 'ProductId' },
                            { name: 'ProductNo', mapping: 'ProductNo' },
                            { name: 'ProductName', mapping: 'ProductName' },
                            { name: 'Unit', mapping: 'Unit' },
                            { name: 'Supplier', mapping: 'Supplier' },
                            { name: 'SalePriceLower', mapping: 'SalePriceLower' },
                            { name: 'SalePriceLimit', mapping: 'SalePriceLimit' },
                            { name: 'UnitText', mapping: 'UnitText' },
                            { name: 'Specifications', mapping: 'Specifications' },
                            { name: 'SpecificationsText', mapping: 'SpecificationsText' }
                        ])
                });
            }
            

var resultPTpl = new Ext.XTemplate(
            '<tpl for="."><div id="searchdivid" class="search-item">',
                '<h3><span>商品编号:{ProductNo}&nbsp;  商品名称:{ProductName}&nbsp;  规格:{SpecificationsText}&nbsp;单位:{UnitText}&nbsp;}</span></h3>',
            '</div></tpl>'
             );
           

            function setProducrAttributes(record) {

                Ext.getCmp('ProductName').setValue(record.data.ProductName);
                Ext.Ajax.request({
                    url: 'frmQtCheckInput.aspx?method=getcheckinfo',
                    method: 'POST',
                    params: {
                        ProductId:record.data.ProductId
                    },
                   success: function(resp,opts){             
                       var resu = Ext.decode(resp.responseText);     
                       if(resu.success)
                       {                            
                           resu = Ext.decode(resu.errorinfo);
                           Ext.getCmp('ProductName').setValue(resu.ProductName);
                           Ext.getCmp('ProductId').setValue(resu.ProductId);
                           Ext.getCmp('CustomerName').setValue(resu.CustomerName);
                           Ext.getCmp("CustomerId").setValue(resu.CustomerId);
                           Ext.getCmp('SaltName').setValue(resu.SaltName);
                           Ext.getCmp('SaltId').setValue(resu.SaltId);
                          Ext.getCmp('BrandName').setValue(resu.ProductBrand);
                           //Ext.getCmp('CheckRepresentQty').setValue(resu.CheckRepresentQty);
                           Ext.getCmp('SpecName').setValue(resu.SpecName);
                           packLevelStore.baseParams.SaltId = resu.SaltId;
                           cmbCheckType.setValue(resu.CheckType);
            //               packLevelCombo.setValue('');
                           packLevelStore.load();
                           checkTemplateCombo.setValue(resu.TemplateNo);
                           templageComboChange(resu.TemplateNo);
                       }else{
                            Ext.Msg.alert("提示","获取信息失败！原因："+resu.errorinfo);
                       }
                   },
                   failure: function(resp,opts){  /* Ext.Msg.alert("提示","保存失败"); */    }
                });
//                Ext.getCmp('ProductId').setValue(record.data.ProductId);
//                Ext.getCmp('ProductNo').setValue(record.data.ProductNo);
//                Ext.getCmp('MnemonicNo').setValue(record.data.MnemonicNo);
//                Ext.getCmp('Specifications').setValue(record.data.specificationsText);
//                //Ext.getCmp('UnitName').setValue(record.data.UnitText);
//                Ext.getCmp("UnitId").setValue(record.data.Unit);
//                Ext.getCmp('Ext3').setValue('');
//                Ext.getCmp('Ext6').setValue('');
//                Ext.getCmp('Ext7').setValue('');
//                beforeEdit();

            }
   
   var charStore = new Ext.data.SimpleStore({
   fields: ['id', 'name'],        
   data : [       
   ['1', '符合'], 
   ['0', '不符合']
   
]});

var resultStore = new Ext.data.SimpleStore({
   fields: ['id', 'name'],        
   data : [        
   ['1', '合格'],
   ['0', '不合格']   
]});

    var cmbCheckType = new Ext.form.ComboBox({
                 id: 'CheckType',
                 store: checkTypeStore, // 下拉数据           
                 displayField: 'DicsName', //显示上面的fields中的state列的内容,相当于option的text值        
                 valueField:'DicsCode' , // 选项的值, 相当于option的value值        
                 name: 'CheckType',
                 mode: 'local', // 必须要,如果为 remote, 则会用ajax获取数据        
                 triggerAction: 'all', // 点击下拉的时候, all 为展出所有Store中data的数据        
                 readOnly: true, // 如果设为true,则好像一般的下拉框一样，默认是false,可输入并自动匹配        
                 emptyText: '',
                 width: 140,
                 fieldLabel: "质检类别<font color='red'>*</font>",
                 editable: false,
                 anchor: '95%',
                 selectOnFocus: true
             });
             
   var cmbCheckResult = new Ext.form.ComboBox({
                 id: 'CheckResult',
                 store: resultStore, // 下拉数据           
                 displayField: 'name', //显示上面的fields中的state列的内容,相当于option的text值        
                 valueField:'id' , // 选项的值, 相当于option的value值        
                 name: 'CheckResult',
                 mode: 'local', // 必须要,如果为 remote, 则会用ajax获取数据        
                 triggerAction: 'all', // 点击下拉的时候, all 为展出所有Store中data的数据        
                 readOnly: true, // 如果设为true,则好像一般的下拉框一样，默认是false,可输入并自动匹配        
                 emptyText: '',
                 width: 140,
                 fieldLabel: "质检结果<font color='red'>*</font>",
                 editable: false,
                 anchor: '95%',
                 selectOnFocus: true
             });
     var cmbCheckNetWeight = new Ext.form.ComboBox({
                 id: 'CheckNetWeight',
                 store: resultStore, // 下拉数据           
                 displayField: 'name', //显示上面的fields中的state列的内容,相当于option的text值        
                 valueField:'id' , // 选项的值, 相当于option的value值        
                 name: 'CheckNetWeight',
                 mode: 'local', // 必须要,如果为 remote, 则会用ajax获取数据        
                 triggerAction: 'all', // 点击下拉的时候, all 为展出所有Store中data的数据        
                 readOnly: true, // 如果设为true,则好像一般的下拉框一样，默认是false,可输入并自动匹配        
                 emptyText: '',
                 width: 140,
                 fieldLabel: "净含量<font color='red'>*</font>",
                 editable: false,
                 anchor: '95%',
                 selectOnFocus: true
             });
               
    var initCheckForm = new Ext.form.FormPanel({
           renderTo: 'divForm',
           frame: true,
//           width:620,
           monitorValid: true, // 把有formBind:true的按钮和验证绑定
//           labelWidth: 70,
           items:
           [
            {
                layout:'column',
                border: true,                                 
                items:
                [{
                   layout: 'form',
                   columnWidth: .33,  //该列占用的宽度，标识为20％
                   border: false,
                   items: [{
                            style: 'margin-left:0px',
                            cls: 'key',
                            xtype: 'textfield',
                            fieldLabel: "报告编号<font color='red'>*</font>",
                            name: 'CheckNo',
                            allowBlank:false,
                            blankText:"不能为空，请填写",
                            id:'CheckNo',
                            anchor: '95%'
                          }]
                 },{
                   layout: 'form',
                   columnWidth: .33,  //该列占用的宽度，标识为20％
                   border: false,
                   items: [{
                            style: 'margin-left:0px',
                            cls: 'key',
                            xtype: 'textfield',
                            fieldLabel: '送检单位',
                            name: 'SendCheckOrg',
                            id:'SendCheckOrg',
                            anchor: '95%'
                          }]
                 },{
                   layout: 'form',
                   columnWidth: .33,  //该列占用的宽度，标识为20％
                   border: false,
                   items: [{
                            style: 'margin-left:0px',
                            cls: 'key',
                            xtype: 'textfield',
                            fieldLabel: '送检人',
                            name: 'SendSampleOper',
                            id:'SendSampleOper',
                            anchor: '95%'
                          }]
                 }]
             },{
                layout:'column',
                border: true,                                 
                items:
                [{
                   layout: 'form',
                   columnWidth: .66,  //该列占用的宽度，标识为20％
                   border: false,
                   items: [{
                            style: 'margin-left:0px',
                            cls: 'key',
                            xtype: 'textfield',
                            fieldLabel: "产品名称<font color='red'>*</font>",
                            name: 'ProductName',
                            id:'ProductName',
                            allowBlank:false,
                            blankText:"不能为空，请填写",
                            readOnly:true,
                            anchor: '95%'
                          },{
                            xtype: 'hidden',
                            name: 'ProductId',
                            id:'ProductId',
                            anchor: '95%'
                          }]
                 },{
                   layout: 'form',
                   columnWidth: .33,  //该列占用的宽度，标识为20％
                   border: false,
                   items: [packLevelCombo]
                 }]
             },
             {
                layout:'column',
                border: true,                                 
                items:
                [{
                   layout: 'form',
                   columnWidth: .66,  //该列占用的宽度，标识为20％
                   border: false,
                   items: [{
                            style: 'margin-left:0px',
                            cls: 'key',
                            xtype: 'textfield',
                            fieldLabel: "生产企业<font color='red'>*</font>",
                            name: 'CustomerName',
                            id:'CustomerName',
                            allowBlank:false,
                            blankText:"不能为空，请填写",
                            anchor: '95%'
                          },{
                            style: 'margin-left:0px',
                            cls: 'key',
                            xtype: 'hidden',
                            fieldLabel: '生产企业',
                            name: 'CustomerId',
                            id:'CustomerId',
                            anchor: '95%'
                          }]
                 },{
                   layout: 'form',
                   columnWidth: .33,  //该列占用的宽度，标识为20％
                   border: false,
                   items: [{
                            style: 'margin-left:0px',
                            cls: 'key',
                            xtype: 'textfield',
                            fieldLabel: "品牌<font color='red'>*</font>",
                            name: 'BrandName',
                            id:'BrandName',
                            allowBlank:false,
                            anchor: '95%'
                          }]
                 }]
             },
             {
                layout:'column',
                border: true,                                 
                items:
                [{
                   layout: 'table',
                   columnWidth: 0.33,  //该列占用的宽度，标识为20％
                   border: false,
                   layoutConfig:3,
                   items: [ {items:new Ext.form.Label({ html:"生产日期<font color='red'>*</font>："}),width:105 }, 
                        {items:new Ext.form.DateField({name:'ProductProduceStartDate',id:'ProductProduceStartDate',format:'Y年m月d日',width:120})},
                        {items:new Ext.form.DateField({name:'ProductProduceDate',id:'ProductProduceDate',format:'Y年m月d日',width:120})}
//                        {
//                            style: 'margin-left:0px',
//                            cls: 'key',
//                            xtype: 'datefield',
//                            fieldLabel: '生产日期*',
//                            name: 'ProductProduceDate',
//                            id:'ProductProduceDate',
//                            anchor: '98%',
//                            format:'Y年m月d日'
//                          },{
//                            style: 'margin-left:0px',
//                            cls: 'key',
//                            xtype: 'datefield',
//                            name: 'ProductProduceStartDate',
//                            id:'ProductProduceStartDate',
//                            anchor: '98%',
//                            format:'Y年m月d日'
//                          } 
                          ]
                 },
                 {
                   layout: 'form',
                   columnWidth: 0.33,  //该列占用的宽度，标识为20％
                   border: false,
                   items: [saltCombo,{
                            style: 'margin-left:0px',
                            cls: 'key',
                            xtype: 'hidden',
                            fieldLabel: "型号<font color='red'>*</font>",
                            name: 'SaltName',
                            allowBlank:false,
                            blankText:"不能为空，请填写",
                            id:'SaltName',
                            anchor: '95%'
                          }]
                 },
                 {
                   layout: 'form',
                   columnWidth: 0.33,  //该列占用的宽度，标识为20％
                   border: false,
                   items: [{
                            style: 'margin-left:0px',
                            cls: 'key',
                            xtype: 'textfield',
                            fieldLabel:"规格<font color='red'>*</font>",
                            name: 'SpecName',
                            id:'SpecName',
                            allowBlank:false,
                            blankText:"不能为空，请填写",
                            anchor: '95%'
                          }]
                 }]
             },
             {
                layout:'column',
                border: true,                                 
                items:
                [{
                   layout: 'form',
                   columnWidth: 0.33,  //该列占用的宽度，标识为20％
                   border: false,
                   items: [{
                            style: 'margin-left:0px',
                            cls: 'key',
                            xtype: 'textfield',
                            fieldLabel: "样品编号<font color='red'>*</font>",
                            name: 'CheckSampleNo',
                            id:'CheckSampleNo',
                            allowBlank:false,
                            blankText:"不能为空，请填写",
                            anchor: '95%'
                          }]
                 },
                 {
                   layout: 'form',
                   columnWidth: 0.33,  //该列占用的宽度，标识为20％
                   border: false,
                   items: [{
                            style: 'margin-left:0px',
                            cls: 'key',
                            xtype: 'datefield',
                            fieldLabel: "抽样日期<font color='red'>*</font>",
                            name: 'CheckSampleDate',
                            id:'CheckSampleDate',
                            anchor: '95%',
                            allowBlank:false,
                            blankText:"不能为空，请输入日期",
                            format:'Y年m月d日'
                          }]
                 },
                 {
                   layout: 'form',
                   columnWidth: 0.33,  //该列占用的宽度，标识为20％
                   border: false,
                   items: [{
                            style: 'margin-left:0px',
                            cls: 'key',
                            xtype: 'textfield',
                            fieldLabel: "抽样人<font color='red'>*</font>",
                            name: 'CheckSampleOper',
                            id:'CheckSampleOper',
                            allowBlank:false,
                            anchor: '95%'
                          }]
                 }]
             },
             {
                layout:'column',
                border: true,                                 
                items:
                [{
                   layout: 'form',
                   columnWidth: 0.33,  //该列占用的宽度，标识为20％
                   border: false,
                   items: [{
                            style: 'margin-left:0px',
                            cls: 'key',
                            xtype: 'textfield',
                            fieldLabel: '抽样方法',
                            name: 'CheckSampleMethod',
                            id:'CheckSampleMethod',
                            anchor: '95%'
                          }]
                 },{
                   layout: 'form',
                   columnWidth: 0.33,  //该列占用的宽度，标识为20％
                   border: false,
                   items: [{
                            style: 'margin-left:0px',
                            cls: 'key',
                            xtype: 'textfield',
                            fieldLabel: "抽样数量<font color='red'>*</font>",
                            name: 'CheckSampleQty',
                            id:'CheckSampleQty',
                            allowBlank:false,
                            blankText:"不能为空，请填写",
                            anchor: '95%'
                          }]
                 },
                 {
                   layout: 'form',
                   columnWidth: 0.33,  //该列占用的宽度，标识为20％
                   border: false,
                   items: [{
                            style: 'margin-left:0px',
                            cls: 'key',
                            xtype: 'textfield',
                            fieldLabel: '检测环境',
                            name: 'CheckCircumstance',
                            id:'CheckCircumstance',
                            anchor: '95%'
                          }]
                 }]
             },
             {
                layout:'column',
                border: true,                                 
                items:
                [{
                    layout: 'table',
                   columnWidth: 0.33,  //该列占用的宽度，标识为20％
                   border: false,
                   layoutConfig:3,
                   items: [ {items:new Ext.form.Label({ html:"检测日期<font color='red'>*</font>："}),width:105 }, 
                        {items:new Ext.form.DateField({name:'SendCheckStartDate',id:'SendCheckStartDate',format:'Y年m月d日',width:120})},
                        {items:new Ext.form.DateField({name:'SendCheckDate',id:'SendCheckDate',format:'Y年m月d日',width:120})}
                  ]
                 },{
                   layout: 'form',
                   columnWidth: 0.33,  //该列占用的宽度，标识为20％
                   border: false,
                   items: [{
                            style: 'margin-left:0px',
                            cls: 'key',
                            xtype: 'textfield',
                            fieldLabel: '受检单位',
                            name: 'CheckOrgName',
                            id:'CheckOrgName',
                            anchor: '95%'
                          }]
                 },
                 {
                   layout: 'form',
                   columnWidth: 0.33,  //该列占用的宽度，标识为20％
                   border: false,
                   items: [{
                            style: 'margin-left:0px',
                            cls: 'key',
                            xtype: 'textfield',
                            fieldLabel: '抽检地址',
                            name: 'CheckSampleAddr',
                            id:'CheckSampleAddr',
                            anchor: '95%'
                          }]
                 }]
             },
             {
                layout:'column',
                border: true,                                 
                items:
                [{
                   layout: 'form',
                   columnWidth: 0.33,  //该列占用的宽度，标识为20％
                   border: false,
                   items: [checkTemplateCombo]
                 },
                 {
                   layout: 'form',
                   columnWidth: 0.33,  //该列占用的宽度，标识为20％
                   border: false,
                   items: [checkLevelCombo]
                 },
                 {
                   layout: 'form',
                   columnWidth: 0.33,  //该列占用的宽度，标识为20％
                   border: false,
                   items: [cmbCheckType]
                 }]
             },{
                layout:'column',
                border: true,                                 
                items:
                [{
                   layout: 'form',
                   columnWidth: 0.33,  //该列占用的宽度，标识为20％
                   border: false,
                   items: [{
                            style: 'margin-left:0px',
                            cls: 'key',
                            xtype: 'numberfield',
                            fieldLabel: "代表量(t)<font color='red'>*</font>",
                            name: 'CheckRepresentQty',
                            id:'CheckRepresentQty',
                            allowBlank:false,
                            decimalPrecision: 3,
                            blankText:"不能为空，请填写",
                            anchor: '95%'
                          }]
             },
             {
                   layout: 'form',
                   columnWidth: 0.33,  //该列占用的宽度，标识为20％
                   border: false,
                   items: [cmbCheckNetWeight]
                 },
                 {
                   layout: 'form',
                   columnWidth: 0.33,  //该列占用的宽度，标识为20％
                   border: false,
                   items: [cmbCheckResult]
                 }
                 ]},
                 {
                layout:'column',
                border: true,                                 
                items:
                [{
                   layout: 'form',
                   columnWidth: 1,  //该列占用的宽度，标识为20％
                   border: false,
                   items: [{
                            style: 'margin-left:0px',
                            cls: 'key',
                            xtype: 'textfield',
                            fieldLabel: '备注',
                            name: 'CheckMemo',
                            id:'CheckMemo',
                            anchor: '95%'
                          }]
                 }]
             }
                 ]});
             
              var productFilterCombo = new Ext.form.ComboBox({
                    store: dsProducts,
                    displayField: 'ProductName',
                    displayValue: 'ProductId',
                    typeAhead: false,
                    minChars: 1,
                    id: 'productFilterCombo',
                    loadingText: 'Searching...',
                    tpl: resultPTpl,
                    itemSelector: 'div.search-item',  
                    pageSize: 10,
                    hideTrigger: true,
                    applyTo: 'ProductName',
                    onSelect: function(record) { // override default onSelect to do redirect  
                        setProducrAttributes(record);
                        this.collapse();
                    }
                });
//             initCheckForm.remove(Ext.getCmp('CheckRepresentQty'),true);
//             initCheckForm.removeAll();
//             initCheckForm.doLayout();

var leftStore = new Ext.data.SimpleStore({
   fields: ['id', 'name'],        
   data : [        
   ['≤', '≤'],
   ['<', '<'],
   ['≥', '≥'],
   ['>', '>'],
   ['—', '—']   
]});



function setLevelStandard(items)
{
    for(var i=0;i<items.length;i++)
    {
        Ext.getCmp("lblQuotaStandard"+items[i].QuotaNo).setText(items[i].QuotaStandard);        
    }
}

var leftForm = null;
var quotaItems = null;
function createStandardControl(QuotaItems)
{
   if(leftForm==null)
   {
       leftForm =new Ext.Panel(
       {
	        frame:true,
	        border:true,
	        layout:'table',
	        width:620,	
	        layoutConfig:{columns:5}
        });        
        leftForm.render("divStardand");
   }
   else
   {
        leftForm.removeAll();
   }
   leftForm.add({ layout: 'table',width:120,height:22, layoutConfig: { columns: 1 },items:{xtype : "label",html:'检测项目'}});
   leftForm.add({ layout: 'table',width:80,height:22, layoutConfig: { columns: 1 },items:{xtype : "label",html:'单位'}});
   leftForm.add({ layout: 'table',width:200,height:22, layoutConfig: { columns: 1 },items:{xtype : "label",html:'标准要求'}});
   leftForm.add({ layout: 'table',width:80,height:22, layoutConfig: { columns: 1 },items:{xtype : "label",html:'检测结果'}});
   leftForm.add({ layout: 'table',width:80,height:22, layoutConfig: { columns: 1 },items:{xtype : "label",html:'判定结果'}});
   for(var j=0;j<QuotaItems.length;j++)
   {
        leftForm.add({ layout: 'table',width:150,height:22, layoutConfig: { columns: 1 },items:{xtype : "label",id:'lblQuotaName'+QuotaItems[j].QuotaNo,html:QuotaItems[j].QuotaName}});
        leftForm.add({ layout: 'table',width:80,height:22, layoutConfig: { columns: 1 },items:{xtype : "label",html:QuotaItems[j].QuotaUnit}});
        leftForm.add({ layout: 'table',width:200,height:22, layoutConfig: { columns: 1 },items:{xtype : "label",id:'lblQuotaStandard'+QuotaItems[j].QuotaNo,html:''}});
        
        if(QuotaItems[j].QuotaExt2=='Q102')//数值类型
        {
            //添加Combox  >=(>= —)40 (<=,~,±,—)  <=80  
            var cmbLeft = new Ext.form.ComboBox({
                 id: 'cmbLeft'+QuotaItems[j].QuotaNo,
                 store: leftStore, // 下拉数据           
                 displayField: 'name', //显示上面的fields中的state列的内容,相当于option的text值        
                 valueField:'id' , // 选项的值, 相当于option的value值        
                 name: 'cmbLeft'+QuotaItems[j].QuotaNo,
                 mode: 'local', // 必须要,如果为 remote, 则会用ajax获取数据        
                 triggerAction: 'all', // 点击下拉的时候, all 为展出所有Store中data的数据        
                 readOnly: true, // 如果设为true,则好像一般的下拉框一样，默认是false,可输入并自动匹配        
                 emptyText: '',
                 width: 45,
                 editable: false,
                 selectOnFocus: true
             });
            var txtResultValue=new Ext.form.TextField({ id: 'txtResultValue'+QuotaItems[j].QuotaNo,width:40,//allowNegative:false,alwaysDisplayDecimals:true,allowDecimals :true,
                listeners : {
                            "change" : function() {
                                    var tempId = this.id.substring(14);
                                    var leftOperatorValue = Ext.getCmp('cmbLeft'+tempId).getValue();
                                    checkResultValue(tempId,this.getValue(),leftOperatorValue);
                        },
                        "blur":function()
                        {
                            clearBlurLabelStyle(this.id.substring(14));
                            var tempId = this.id.substring(14);
                            var leftOperatorValue = Ext.getCmp('cmbLeft'+tempId).getValue();
                            checkResultValue(tempId,this.getValue(),leftOperatorValue);
                        },
                        "focus":function(){setCurrentLableStyle(this.id.substring(14));},
                        specialkey:function(f, e){ if(e.getKey() == e.ENTER){
                            var tempId = this.id.substring(14);
                            
                                for(var i=0;i<quotaItems.length;i++)
                                {
                                    if(quotaItems[i].QuotaNo==tempId)
                                    {
                                        if((i+1)==quotaItems.length)
                                        {
                                            if(quotaItems[0].QuotaExt2=='Q102')
                                            {
                                                Ext.getCmp("txtResultValue"+quotaItems[0].QuotaNo).focus();
                                            }
                                        }
                                        else
                                        {
                                            if(quotaItems[i+1].QuotaExt2=='Q102')
                                            {
                                                Ext.getCmp("txtResultValue"+quotaItems[i+1].QuotaNo).focus();
                                            }
                                        }
                                        break;
                                    }
                                }                 
                            
                        }}
                 }
             });
            leftForm.add({ layout: 'table',width:80,height:22, layoutConfig: { columns: 2 },items:[{ items: cmbLeft }, { items: txtResultValue}]});
        }
        else
        {
          var cmbChar = new Ext.form.ComboBox({
                 id: 'cmbChar'+QuotaItems[j].QuotaNo,
                 store: charStore, // 下拉数据           
                 displayField: 'name', //显示上面的fields中的state列的内容,相当于option的text值        
                 valueField:'id' , // 选项的值, 相当于option的value值        
                 name: 'cmbChar'+QuotaItems[j].QuotaNo,
                 mode: 'local', // 必须要,如果为 remote, 则会用ajax获取数据        
                 triggerAction: 'all', // 点击下拉的时候, all 为展出所有Store中data的数据        
                 readOnly: true, // 如果设为true,则好像一般的下拉框一样，默认是false,可输入并自动匹配        
                 emptyText: '请选择信息',
                 width: 45,
                 editable: false,
                 selectOnFocus: true,
                 onSelect: function(record) {
                    this.setValue(record.data.id);
                    Ext.getCmp('cmbResult'+this.id.substring(7)).setValue(record.data.id);
                    setCheckResult();
                    this.collapse();
                 }
                 
             });
             leftForm.add({ layout: 'table',width:80,height:22, layoutConfig: { columns: 1 },items:[{ items: cmbChar }]});
        }
        //添加Combox  >=(>= —)40 (<=,~,±,—)  <=80  
            var cmbResult = new Ext.form.ComboBox({
                 id: 'cmbResult'+QuotaItems[j].QuotaNo,
                 store: resultStore, // 下拉数据           
                 displayField: 'name', //显示上面的fields中的state列的内容,相当于option的text值        
                 valueField:'id' , // 选项的值, 相当于option的value值        
                 name: 'cmbResult'+QuotaItems[j].QuotaNo,
                 mode: 'local', // 必须要,如果为 remote, 则会用ajax获取数据        
                 triggerAction: 'all', // 点击下拉的时候, all 为展出所有Store中data的数据        
                 readOnly: true, // 如果设为true,则好像一般的下拉框一样，默认是false,可输入并自动匹配        
                 emptyText: '',
                 width: 70,
                 editable: false,
                 selectOnFocus: true
             });
             cmbResult.setValue("1");
             leftForm.add({ layout: 'table',width:80,height:22, layoutConfig: { columns: 1 },items:[{ items: cmbResult }]});
   }
   leftForm.doLayout();
   
}

function checkAllValue()
{
    for(var i=0;i<quotaItems.length;i++)
    {
        //数字进行检查
        if(quotaItems[i].QuotaExt2=='Q102')
        {
            var checkValue = Ext.getCmp("txtResultValue"+quotaItems[i].QuotaNo).getValue();
            if(checkValue.length>0)
            {
                var leftOperatorValue = Ext.getCmp('cmbLeft'+quotaItems[i].QuotaNo).getValue();
                checkResultValue(quotaItems[i].QuotaNo,checkValue,leftOperatorValue);
            }
        }
    }
}

function checkResultValue(quotaNo,checkValue,leftCmbValue)
{
    Ext.Ajax.request({
            url: 'frmQtCheckInput.aspx?method=checklevelstandard',
            method: 'POST',
            params: {
                LevelId:checkLevelCombo.getValue(),
                QuotaNo:quotaNo,
                CheckValue:checkValue,
                ResultLeftOperator:leftCmbValue
            },
           success: function(resp,opts){              
               var resu = Ext.decode(resp.responseText);
               if(resu.success)
               {
                 Ext.getCmp('cmbResult'+resu.id).setValue("1");
               }
               else
               {                
                Ext.getCmp('cmbResult'+resu.id).setValue("0");
                
               }
               setCheckResult();
               Ext.getCmp('txtResultValue'+resu.id).setValue(resu.errorinfo);
           },
           failure: function(resp,opts){  /* Ext.Msg.alert("提示","保存失败"); */    }
        });
}
//判定检测结果数据
function setCheckResult()
{
    var noPassCount =0;
    var result = '1';
    for(var i=0;i<quotaItems.length;i++)
    {
        if(Ext.getCmp('cmbResult'+quotaItems[i].QuotaNo).getValue()=='0')
        {
            noPassCount = noPassCount+1;
            if(canPassQuotaNo.indexOf(","+quotaItems[i].QuotaNo+",")==-1)
            {
                result='0';
                break;
            }
            if(noPassCount>1)
            {
                result='0';
                break;
            }
            
        }
        
    }
    cmbCheckResult.setValue(result);
}

function saveForm()
{
    if(!initCheckForm.form.isValid()){
        Ext.Msg.alert('错误提示','请检查必须输入的字段！');
        return;        
     }
    var details = "";
    for(var i=0;i<quotaItems.length;i++)
    {
        var detail="{CheckId:"+checkId+",LevelId:0,QuotaNo:"+quotaItems[i].QuotaNo+",ResultSort:"+i+",";
        
        if(quotaItems[i].QuotaExt2=='Q102')
        {
            detail+="ResultLeftOperator:'"+ Ext.getCmp('cmbLeft'+quotaItems[i].QuotaNo).getValue()+"',";
            var resultValue=Ext.getCmp("txtResultValue"+quotaItems[i].QuotaNo).getValue();
            if(resultValue=="")
                resultValue=-1;
            detail+="ResultNumValue:"+resultValue+",";
            detail+="ResultResult:"+Ext.getCmp("cmbResult"+quotaItems[i].QuotaNo).getValue()+"}"
        }
        else
        {
            detail+="ResultLeftOperator:'',";
            detail+="ResultNumValue:0,";
            detail+="ResultResult:"+Ext.getCmp("cmbResult"+quotaItems[i].QuotaNo).getValue()+"}"
        }
        details+=detail+",";
    }
    var productDate = Ext.getCmp("ProductProduceDate").getValue();
    if(productDate==null||productDate=="")
    {
        Ext.Msg.alert('系统提示','请输入生产日期！');
        return;
    }
    productDate = Ext.getCmp("ProductProduceStartDate").getValue();
    if(productDate==null||productDate=="")
    {
        Ext.Msg.alert('系统提示','请输入生产开始日期！');
        return;
    }
    productDate = Ext.getCmp("SendCheckStartDate").getValue();
    if(productDate==null||productDate=="")
    {
        Ext.Msg.alert('系统提示','请输入检测开始日期！');
        return;
    }
    productDate = Ext.getCmp("SendCheckDate").getValue();
    if(productDate==null||productDate=="")
    {
        Ext.Msg.alert('系统提示','请输入检测日期！');
        return;
    }
    var netWeight = cmbCheckNetWeight.getValue();
    if( netWeight ==null||netWeight=="")
    {
        Ext.Msg.alert('系统提示','请选择净含量！');
        return;
    }
    var checkResrult = cmbCheckResult.getValue();
    if( checkResrult ==null||checkResrult=="")
    {
        Ext.Msg.alert('系统提示','请选择质检结果！');
        return;
    }    

    Ext.Ajax.request({
            url: 'frmQtCheckInput.aspx?method=savecheck',
            method: 'POST',
            params: {
                CheckId:checkId,
                
                ProductId:Ext.getCmp("ProductId").getValue(),
                ProductSpec:Ext.getCmp("SpecName").getValue(),
                ProductType:Ext.getCmp('SaltName').getValue(),
                ProductPackStandard:Ext.getCmp('SaltName').getValue(),
                ProductPackLevel:packLevelCombo.getValue(),
                ProductProduceDate:Ext.getCmp("ProductProduceDate").getValue().dateFormat('Y/m/d'),
                ProductProduceStartDate:Ext.getCmp("ProductProduceStartDate").getValue().dateFormat('Y/m/d'),
                ProductBrand:Ext.getCmp("BrandName").getValue(),
                SaltId:saltCombo.getValue(),
                CustomerId:Ext.getCmp("CustomerId").getValue(),
                CheckRepresentQty:Ext.getCmp("CheckRepresentQty").getValue(),
                SendCheckDate:Ext.getCmp("SendCheckDate").getValue().dateFormat('Y/m/d'),
                SendCheckStartDate:Ext.getCmp("SendCheckStartDate").getValue().dateFormat('Y/m/d'),
                CheckStandard:checkTemplateCombo.getValue(),
                CheckLevel:checkLevelCombo.getValue(),
                CheckType:cmbCheckType.getValue(),
                CheckNetWeight:cmbCheckNetWeight.getValue(),
                CheckResult:cmbCheckResult.getValue(),
                CheckCircumstance:Ext.getCmp("CheckCircumstance").getValue(),
                CheckSampleQty:Ext.getCmp("CheckSampleQty").getValue(),
                ProductSupplierName:Ext.getCmp("CustomerName").getValue(),
//                CheckType:Ext.getCmp("CheckType").getValue(),
                FromBillId:fromBillId,
                FromBillType:fromBillType,
                CheckSampleOper:Ext.getCmp("CheckSampleOper").getValue(),
                CheckSampleDate:Ext.getCmp("CheckSampleDate").getValue().dateFormat('Y/m/d'),
                CheckSampleMethod:Ext.getCmp("CheckSampleMethod").getValue(),
                CheckMemo:Ext.getCmp("CheckMemo").getValue(),
                CheckSampleAddr:Ext.getCmp("CheckSampleAddr").getValue(),
                CheckSampleNo:Ext.getCmp("CheckSampleNo").getValue(),
                CheckOrgName:Ext.getCmp("CheckOrgName").getValue(),
                CheckSampleName:Ext.getCmp("ProductName").getValue(),
                SendCheckOrg:Ext.getCmp("SendCheckOrg").getValue(),
                SendSampleOper:Ext.getCmp("SendSampleOper").getValue(),
                CheckNo:Ext.getCmp("CheckNo").getValue(),
                Details:details
                
            },
           success: function(resp,opts){              
               var resu = Ext.decode(resp.responseText);
                Ext.Msg.alert('系统提示',resu.errorinfo);
                if(resu.id>0)
                    checkId = resu.id;
               
           },
           failure: function(resp,opts){  /* Ext.Msg.alert("提示","保存失败"); */    }
        });
}
function setSampleInformation(resu)
{
    Ext.getCmp('ProductName').setValue(resu.ProductName);
                   Ext.getCmp('ProductId').setValue(resu.ProductId);
                   Ext.getCmp('CustomerName').setValue(resu.CustomerName);
                   Ext.getCmp('SaltName').setValue(resu.ProductType);
                   Ext.getCmp('SaltId').setValue(resu.SaltId);
                   Ext.getCmp('BrandName').setValue(resu.ProductBrand);
                   Ext.getCmp('CheckRepresentQty').setValue(resu.CheckRepresentQty);
                   Ext.getCmp('SpecName').setValue(resu.ProductSpec);
                   Ext.getCmp('ProductProduceDate').setValue(new Date(resu.ProductProduceDate.replace(/-/g, "/")));
                   Ext.getCmp('SendCheckDate').setValue(new Date(resu.SendCheckDate.replace(/-/g, "/")));
                    cmbCheckType.setValue(resu.CheckType);
                    cmbCheckNetWeight.setValue(resu.CheckNetWeight);
                    cmbCheckResult.setValue(resu.CheckResult);
                    Ext.getCmp("CustomerId").setValue(resu.CustomerId);
                    Ext.getCmp("CheckOrgName").setValue(resu.CheckOrgName);
                    Ext.getCmp("CheckSampleNo").setValue(resu.CheckSampleNo);
                    Ext.getCmp("CheckSampleAddr").setValue(resu.CheckSampleAddr);
                    Ext.getCmp("CheckMemo").setValue(resu.CheckMemo);
                    Ext.getCmp("CheckSampleOper").setValue(resu.CheckSampleOper);
                    Ext.getCmp("CheckSampleDate").setValue(new Date(resu.CheckSampleDate.replace(/-/g, "/")));
                    Ext.getCmp("CheckSampleMethod").setValue(resu.CheckSampleMethod);
                    
                    Ext.getCmp("CheckCircumstance").setValue(resu.CheckCircumstance);
                    Ext.getCmp("CheckSampleQty").setValue(resu.CheckSampleQty);
                    Ext.getCmp("CustomerName").setValue(resu.ProductSupplierName);
                    Ext.getCmp("ProductName").setValue(resu.CheckSampleName);
                    Ext.getCmp("SendCheckOrg").setValue(resu.SendCheckOrg);
                    Ext.getCmp("SendSampleOper").setValue(resu.SendSampleOper);
                    Ext.getCmp("CheckNo").setValue(resu.CheckNo);
                    Ext.getCmp("SendCheckStartDate").setValue(new Date(resu.SendCheckStartDate.replace(/-/g, "/")));
                    Ext.getCmp("ProductProduceStartDate").setValue(new Date(resu.ProductProduceStartDate.replace(/-/g, "/")));
    //               packLevelStore.baseParams.SaltId = resu.SaltId;
    //               packLevelCombo.setValue('');
                    
                   packLevelStore.load();
                   checkTemplateCombo.setValue(resu.CheckStandard);
                   templageComboChange(resu.CheckStandard,resu.CheckLevel);
                   //checkLevelCombo.setValue(resu.CheckLevel);
                   packLevelCombo.setValue(resu.ProductPackLevel);
}
function iniForm()
{
    if(checkId>0)
    {
        Ext.Ajax.request({
            url: 'frmQtCheckInput.aspx?method=getcheckinfo',
            method: 'POST',
            params: {
                CheckId:checkId
            },
           success: function(resp,opts){     
                var resu = Ext.decode(resp.responseText);     
                if(resu.success)
                { 
                   resu = Ext.decode(resu.errorinfo);
                   setSampleInformation(resu);
                   
               }else{
                    Ext.Msg.alert("提示","获取信息失败！原因："+resu.errorinfo);
               }
           },
           failure: function(resp,opts){  /* Ext.Msg.alert("提示","保存失败"); */    }
        });
    }
    else if(fromBillId>0)
    {
        Ext.Ajax.request({
            url: 'frmQtCheckInput.aspx?method=getcheckinfo',
            method: 'POST',
            params: {
                FromBillId:fromBillId,
                FromBillType:fromBillType
            },
           success: function(resp,opts){              
               var resu = Ext.decode(resp.responseText);
               if(resu.success)
               { 
                   resu = Ext.decode(resu.errorinfo);
                   //来源为委托单的
                   if(fromBillType=="Q1404")
                   {
                        setSampleInformation(resu);
                        return;
                   }
                   Ext.getCmp('ProductName').setValue(resu.ProductName);
                   Ext.getCmp('ProductId').setValue(resu.ProductId);
                   Ext.getCmp('CustomerName').setValue(resu.CustomerName);
                   Ext.getCmp("CustomerId").setValue(resu.CustomerId);
                   Ext.getCmp('SaltName').setValue(resu.SaltName);
                   Ext.getCmp('CheckRepresentQty').setValue(resu.CheckRepresentQty);
                   Ext.getCmp('SpecName').setValue(resu.SpecName);
                   Ext.getCmp('SaltId').setValue(resu.SaltId);
                   Ext.getCmp('BrandName').setValue(resu.ProductBrand);
                   packLevelStore.baseParams.SaltId = resu.SaltId;
                   cmbCheckType.setValue(resu.CheckType);
                   if(resu.CheckOrgName!=null)
                   {
                    Ext.getCmp("CheckOrgName").setValue(resu.CheckOrgName);
                   }
                   if(resu.CheckOrgAddr!=null)
                   {
                    Ext.getCmp("CheckOrgAddr").setValue(resu.CheckOrgAddr);
                   }
    //               packLevelCombo.setValue('');
                   packLevelStore.load();
                   checkTemplateCombo.setValue(resu.TemplateNo);
                   templageComboChange(resu.TemplateNo,'');
               }else{
                    Ext.Msg.alert("提示","获取信息失败！原因："+resu.errorinfo);
               }
           },
           failure: function(resp,opts){  /* Ext.Msg.alert("提示","保存失败"); */    }
        });
    }else{
        Ext.getCmp("ProductName").getEl().dom.readOnly = false;
        var tip ="请输入编号或名称进行自动匹配查询.....";
        Ext.getCmp("ProductName").getEl().dom.style.color='gray';
        Ext.getCmp("ProductName").setValue(tip);
        Ext.getCmp("ProductName").on({
            'focus':function (f){ 
                f.getEl().dom.style.color='black';
                if(f.getValue()==tip)
                    f.setValue('');
            },
            'blur':function(f){
                if(!f.getValue()){
                    f.setValue(tip);
                    f.getEl().dom.style.color='gray';
                }
            }
        });
        Ext.getCmp("CheckOrgName").setValue(orgName);
    }
}
iniForm();

function setCurrentLableStyle(labelId)
{
    Ext.getCmp('lblQuotaName'+labelId).addClass('label-class');
    leftForm.items.each(function(item,index,length){     
        if(item.initialConfig.items.id=='lblQuotaName'+labelId){
            leftForm.items.get(index+1).addClass('label-class');
            leftForm.items.get(index+2).addClass('label-class');
            return;       
        }
    });
}
function clearBlurLabelStyle(labelId)
{
    Ext.getCmp('lblQuotaName'+labelId).removeClass('label-class');
     leftForm.items.each(function(item,index,length){     
        if(item.initialConfig.items.id=='lblQuotaName'+labelId){
            leftForm.items.get(index+1).removeClass('label-class');
            leftForm.items.get(index+2).removeClass('label-class');
            return;       
        }
    });
}
});
</script>
</head>
<body>
<div id='toolbar'></div>
<div id='divForm'></div>
<div id='divStardand'></div>
<div id='divloading' style="display:none;"><img style="margin-left:300px" src="../Theme/1/images/extjs/customer/loading.gif" alt="" /></div>
<div id='divBotton'></div>
<object id="printControl1" classid="http:WinWebPrintControl.dll#WinWebPrintControl.UserControl1" height=0px width=0px VIEWASTEXT>
</object>
</body>
</html>
