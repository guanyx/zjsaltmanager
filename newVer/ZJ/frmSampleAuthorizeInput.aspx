<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmSampleAuthorizeInput.aspx.cs" Inherits="ZJ_frmSampleAuthorizeInput" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>无标题页</title>
    <link rel="stylesheet" type="text/css" href="../ext3/resources/css/ext-all.css" />
<script type="text/javascript" src="../ext3/adapter/ext/ext-base.js"></script>
<script type="text/javascript" src="../ext3/ext-all.js"></script>
<script type="text/javascript" src="../ext3/example/ItemDeleter.js"></script>
<script type="text/javascript" src="../js/operateResp.js"></script>
<script type="text/javascript" src="../js/ExtJsForm.js"></script>
<script type="text/javascript" src="../ext3/src/locale/ext-lang-zh_CN.js"></script>
<style type="text/css">
.label-class{
                color: red;
            }
</style>
<%=getComboBoxStore() %>
<script type="text/javascript">
var authorizeForm=null;
var packLevelStore;//包装等级
 var footerForm ;
Ext.onReady(function() {
Ext.QuickTips.init();
Ext.BLANK_IMAGE_URL = "../ext3/resources/images/default/s.gif"; 
//var toolBar = new Ext.Toolbar({
//            renderTo: "toolbar",
//            items: [ {
//                text: "保存",
//                icon: "../Theme/1/images/extjs/customer/save.gif",
//                handler: function() {
//                    saveForm();
//                }
//            }, '-',{
//                text: "打印",
//                icon: "../Theme/1/images/extjs/customer/save.gif",
//                handler: function() {
//                    printCheck();
//                }
//            }, '-',{
//                text: "帮助",
//                icon: "../Theme/1/images/extjs/customer/help.ico",
//                handler: function() {
//                    window.open("../help/zj/helpcheckinput.htm","","","");
//                }
//            }, '-']
//        });
        
//        setToolBarVisible(toolBar);


     if (packLevelStore == null) { //包装等级
        packLevelStore = new Ext.data.JsonStore({
            totalProperty: "result",
            root: "root",
            url: 'frmQtCheckInput.aspx?method=getlevelbytemplate',
            fields: ['LevelId','SaltLevel'],
            listeners:
	        {
	            scope: this,
	            load: function() {
	                if(packLevelCombo.getValue()=='0')
	                {
	                    packLevelCombo.setValue('');
	                }
	                else
	                {
	                    packLevelCombo.setValue(packLevelCombo.getValue());
	                }
	            }
	        }
        })
     };
     
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
                   name:'ProductLevel',
                   id:'ProductLevel',
                   selectOnFocus: true,
                   anchor: '95%',
                   width:140,
				   editable:false
				   
               }); 
       var checkOrgCombo = new Ext.form.ComboBox({
                   xtype: 'combo',
                   store:dsOrg,
                   valueField: 'OrgId',
                   displayField: 'OrgName',
                   mode: 'local',
                   forceSelection: true,
                   editable: false,
                   emptyValue: '',
                   triggerAction: 'all',
                   fieldLabel: "检测单位<font color='red'>*</font>",
                   name:'CheckOrgId',
                   id:'CheckOrgId',
                   selectOnFocus: true,
                   anchor: '95%',
                   width:140,
				   editable:false
				   
               }); 
               
     //定义产品下拉框异步调用方法
            var dsProducts;
            if (dsProducts == null) {
                dsProducts = new Ext.data.Store({
                    url: 'frmQtCheckInput.aspx?type=salt&method=getSaltProduct',
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
                           Ext.getCmp('ProductSupplierName').setValue(resu.CustomerName);
                           Ext.getCmp("ProductSupplierId").setValue(resu.CustomerId);
                            Ext.getCmp('ProductBrand').setValue(resu.ProductBrand);
                           Ext.getCmp('ProductSpec').setValue(resu.SpecName);
                           packLevelStore.baseParams.SaltId = resu.SaltId;
                           packLevelStore.load();
                       }else{
                            Ext.Msg.alert("提示","获取信息失败！原因："+resu.errorinfo);
                       }
                   },
                   failure: function(resp,opts){  /* Ext.Msg.alert("提示","保存失败"); */    }
                });
            }
            
            var cmbCheckType = new Ext.form.ComboBox({
                 id: 'SampleType',
                 store: checkTypeStore, // 下拉数据           
                 displayField: 'DicsName', //显示上面的fields中的state列的内容,相当于option的text值        
                 valueField:'DicsCode' , // 选项的值, 相当于option的value值        
                 name: 'SampleType',
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
     
authorizeForm=new Ext.form.FormPanel({
	renderTo:'divForm',
	frame:true,
	title:'委托信息',
	width:650,
	items:[
	    {
	     layout:'column',
         border: true,                                 
         items:[
         {layout: 'form',
                   columnWidth: .95,  //该列占用的宽度，标识为20％
                   border: false,
                   items:[
		{xtype:'hidden',fieldLabel:'委托ID',anchor:'90%',name:'AuthorizeId',id:'AuthorizeId'},
		{xtype:'hidden',fieldLabel:'产品ID',anchor:'90%',name:'ProductId',id:'ProductId'},
		{xtype:'textfield',fieldLabel:"产品名称<font color='red'>*</font>",anchor:'90%',name:'ProductName',id:'ProductName'}]}]},
		{
	     layout:'column',
         border: true,                                 
         items:[
         {layout: 'form',
                   columnWidth: .5,  //该列占用的宽度，标识为20％
                   border: false,
                   items:[
		{xtype:'textfield',fieldLabel:"规格<font color='red'>*</font>",anchor:'90%',name:'ProductSpec',id:'ProductSpec'}]},
		{layout: 'form',
                   columnWidth: .5,  //该列占用的宽度，标识为20％
                   border: false,
                   items:[packLevelCombo]}]},            
		{xtype:'textfield',fieldLabel:"生产厂商<font color='red'>*</font>",columnWidth:1,anchor:'90%',name:'ProductSupplierName',id:'ProductSupplierName'},
		{xtype:'hidden',fieldLabel:'生产厂商ID',columnWidth:1,anchor:'90%',	name:'ProductSupplierId',id:'ProductSupplierId'},
		{
	     layout:'column',
         border: true,                                 
         items:[
            {
	         layout:'form',
             border: true,                 
             columnWidth:0.5,                
             items:[{xtype:'textfield',fieldLabel:"品牌<font color='red'>*</font>",anchor:'90%',name:'ProductBrand',id:'ProductBrand'}]},
             {layout:'form',border:true,columnWidth:0.5,items:cmbCheckType}]},
             {
	     layout:'column',
         border: true,                                 
         items:[
             {layout:'form',
             border: true,    
             columnWidth:0.5,
             items:[{xtype:'datefield',fieldLabel:"生产日期<font color='red'>*</font>",anchor:'90%',name:'ProductProduceDate',id:'ProductProduceDate',blankText:"不能为空，请输入日期",format:'Y年m月d日'}]},
             {layout:'form',
             border: true,    
             columnWidth:0.5,
             items:[{xtype:'datefield',anchor:'90%',name:'ProductProduceEnddate',id:'ProductProduceEnddate',format:'Y年m月d日'}]}]},
        {
	     layout:'column',
         border: true,                                 
         items:[
            {
	         layout:'form',
             border: true,                        
             columnWidth:0.5,         
             items:[{xtype:'textfield',fieldLabel:"样品编号<font color='red'>*</font>",	anchor:'90%',name:'SampleNo',id:'SampleNo'}]},
            {
	         layout:'form',
             border: true,                        
             columnWidth:0.5, 
             items:[{xtype:'textfield',	fieldLabel:'抽样人',anchor:'90%',	name:'SampleOpper',	id:'SampleOpper'}]}]},
          {
	     layout:'column',
         border: true,                                 
         items:[
            {
	         layout:'form',
             border: true,                        
             columnWidth:0.5,         
             items:[{xtype:'textfield',fieldLabel:'抽样方法',anchor:'90%',name:'SampleMethod',id:'SampleMethod'}]},
             {
	         layout:'form',
             border: true,                        
             columnWidth:0.5,
             items:[{xtype:'textfield',fieldLabel:'抽样地址',columnWidth:0.5,anchor:'90%',name:'SampleAddr',	id:'SampleAddr'	}]}]},
             {
	     layout:'column',
         border: true,                                 
         items:[
            {
	         layout:'form',
             border: true,                        
             columnWidth:0.5,         
             items:[{xtype:'textfield',fieldLabel:"样品数量<font color='red'>*</font>",columnWidth:0.5,anchor:'90%',name:'SampleQty',id:'SampleQty'}]},
             {
	         layout:'form',
             border: true,                        
             columnWidth:0.5,         
             items:[{xtype:'textfield',fieldLabel:"代表量(t)<font color='red'>*</font>",columnWidth:0.5,anchor:'90%',name:'SampleRepresentQty',id:'SampleRepresentQty'}]}]},
		checkOrgCombo]});
		
		
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
                
         footerForm = new Ext.FormPanel({
        renderTo: 'divBotton',
        //border: true, // 没有边框
        //labelAlign: 'left',
        buttonAlign: 'center',
        bodyStyle: 'padding:1px',
        height: 10,
        width:650,
        frame: true,
        //labelWidth: 55,     
        buttons: [{
            text: "保存",
            scope: this,
            id: 'saveButton',
            handler: function() {
                if(cmbCheckType.getValue()==''){
                    Ext.Msg.alert('错误提示','请检查必须输入的字段！');
                    return;
                }
                Ext.getCmp("AuthorizeId").setValue(AuthorizeId);
                var json=getFromValue(authorizeForm);
                saveAuthorize(json);
            }
        },{
                             text: "保存并送检",
                             id:'btnSaveAndSend',
                             scope: this,
                             handler:function(){
                             }
},{
                             text: "取消",
                             scope: this,
                             handler: function() {
                                 parent.uploadAuthorizeWindow.hide();
                             }
}]
    });
    
/*保存数据信息*/
function saveAuthorize(json)
{
    json = json.substring(0,json.length-1)+",FromBillId:"+fromBillId+",FromBillType:'"+fromBillType+"'}";
    Ext.Ajax.request({
        url: 'frmSampleAuthorizeInput.aspx?method=save',
        params: eval("("+json+")"),
        success: function(resp, opts) {  
            var resu = Ext.decode(resp.responseText);
                Ext.Msg.alert('系统提示',resu.errorinfo);
                if(resu.id>0)
                    AuthorizeId = resu.id;
        },
        failure: function(resp, opts) {
            Ext.Msg.alert("提示", "获取初始化仓库信息失败！");
        }});
}


		});
		
		/*设置窗体的初始值信息*/
function setAuthorizeFormValue() {
    //新增状态
//    if(AuthorizeId==0)
//    {
//        
//    }
//    else
//    {
         Ext.Ajax.request({
            url: 'frmSampleAuthorizeInput.aspx?method=getauthorize',
            params: {
                AuthorizeId: AuthorizeId,
                FromBillType:fromBillType,
                FromBillId:fromBillId
            },
            success: function(resp, opts) {  
                var resu = Ext.decode(resp.responseText);
                setFormValue(authorizeForm,resu);
                AuthorizeId=resu.AuthorizeId;
                fromBillId = resu.FromBillId;
                fromBillType = resu.FromBillType;
                packLevelStore.baseParams.SaltId = -1;
                packLevelStore.baseParams.ProductId=resu.ProductId;
                packLevelStore.load();
                if(resu.AuthorizeStatus=="" || resu.AuthorizeStatus=="Q1301")
                {
                    footerForm.buttons[0].show();
                    footerForm.buttons[1].hide();
                }
                else
                {
                    footerForm.buttons[0].hide();
                    footerForm.buttons[1].hide();
                }
            },
            failure: function(resp, opts) {
                Ext.Msg.alert("提示", "获取初始化信息失败！");
            }});
//    }
}
setAuthorizeFormValue();
</script>
</head>
<body>
<div id='toolbar'></div>
<div id='divForm'></div>
<div id='divBotton'></div>
</body>
</html>
