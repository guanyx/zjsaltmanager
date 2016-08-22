<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmInnerCustomerFixPrice.aspx.cs"
    Inherits="CRM_product_frmCrmCustomerFixPrice" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
    <title>内部客户特殊定价</title>
    <meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
    <link rel="stylesheet" type="text/css" href="../../ext3/resources/css/ext-all.css" />
    <script type="text/javascript" src="../../ext3/adapter/ext/ext-base.js"></script>
    <script type="text/javascript" src="../../ext3/ext-all.js"></script>
    <script type="text/javascript" src="../../js/operateResp.js"></script>
    <script type="text/javascript" src="../../ext3/src/locale/ext-lang-zh_CN.js"></script>
</head>
<body>
    <div id='toolbar'>
    </div>
    <div id='searchForm'>
    </div>
    <div id='crmCustomreFixPriceGrid'>
    </div>
</body>

<%= getComboBoxStore() %>

<script type="text/javascript">
Ext.BLANK_IMAGE_URL = "../../ext3/resources/images/default/s.gif";
Ext.onReady(function() {
        var saveType;   
        Ext.QuickTips.init();
        Ext.form.Field.prototype.msgTarget = 'side';     
        //定义客户下拉框异步调用方法            
        var dsCustomers;
        if(dsCustomers == null){
            dsCustomers = new Ext.data.Store({
                url: 'frmInnerCustomerFixPrice.aspx?method=getCustomers',  
                reader: new Ext.data.JsonReader({  
                    root: 'root',  
                    totalProperty: 'totalProperty'   
                }, [  
                    {name: 'CustomerId', mapping: 'CustomerId'}, 
                    {name: 'CustomerNo', mapping: 'CustomerNo'},  
                    {name: 'ChineseName', mapping: 'ChineseName'},  
                    {name: 'Address', mapping: 'Address'}
                ]) 
            });
        }
        // 定义客户下拉框异步返回显示模板
        var resultTpl = new Ext.XTemplate(  
            '<tpl for="."><div id="searchkhdivid" class="search-item">',  
                '<h3><span>客户编号：{CustomerNo}  客户全称： {ChineseName}</span>  客户地址：{Address}</h3>',  
                //'<br>创建时间：{createDate}',  
            '</div></tpl>'  
        );          
        /*------实现toolbar的函数 start---------------*/
        var Toolbar = new Ext.Toolbar({
            renderTo: "toolbar",
            items: [{
                text: "新增",
                icon: "../../Theme/1/images/extjs/customer/add16.gif",
                handler: function() { 
                    saveType ='add';
                    openAddFixpiceWin(); 
                }
            }, '-', {
                text: "编辑",
                icon: "../../Theme/1/images/extjs/customer/edit16.gif",
                handler: function() { 
                    saveType ='save';
                    modifyFixpiceWin(); 
                }
//            }, '-', {
//                text: "删除",
//                icon: "../../Theme/1/images/extjs/customer/delete16.gif",
//                handler: function() { deleteFixpice(); }
//            }, '-', {
//                text: "调整商品所有客户定价",
//                icon: "../../Theme/1/images/extjs/customer/1edit16.gif",
//                handler: function() { AdjustFixpiceByProduct(); }
            }]
            });

            /*------结束toolbar的函数 end---------------*/


            /*------开始ToolBar事件函数 start---------------*//*-----新增Fixpice实体类窗体函数----*/
            function openAddFixpiceWin() {
                crmCustomreFixPrice.getForm().reset();
	            Ext.getCmp('ProductName').setDisabled(false);
	            Ext.getCmp('ChineseName').setDisabled(false);
	            uploadFixpiceWindow.show();
	            /*----------定义供应商组合框 start -------------*/ 
                //定义产品下拉框异步调用方法
                var dsProducts;
                if(dsProducts == null){
                    dsProducts = new Ext.data.Store({
                        url: 'frmInnerCustomerFixPrice.aspx?method=getProducts',  
                        reader: new Ext.data.JsonReader({  
                            root: 'root',  
                            totalProperty: 'totalProperty'
                        }, [  
                            {name: 'ProductId', mapping: 'ProductId'}, 
                            {name: 'ProductNo', mapping: 'ProductNo'},  
                            {name: 'ProductName', mapping: 'ProductName'},
                            {name: 'Unit', mapping: 'Unit'},
                            {name: 'SalePriceLower', mapping: 'SalePriceLower'},
                            {name: 'SalePriceLimit', mapping: 'SalePriceLimit'},
                            {name: 'UnitText', mapping: 'UnitText'},
                            {name: 'Specifications', mapping: 'Specifications'},  
                            {name: 'SpecificationsText', mapping: 'SpecificationsText'} 
                        ])
                    });
                }
               var productFilterCombo = new Ext.form.ComboBox({  
                            store: dsProducts,  
                            displayField:'ProductName',
                            displayValue:'ProductId',
                            typeAhead: false,  
                            minChars:1,
                            loadingText: 'Searching...',  
                            //tpl: resultTpl,  
                            pageSize:10,  
                            hideTrigger:true,  
                            applyTo: 'ProductName',
                            onSelect: function(record){ // override default onSelect to do redirect  
                                //alert(record.data.cusid); 
                                //alert(Ext.getCmp('search').getValue());                        
                                Ext.getCmp('ProductName').setValue(record.data.ProductName);
                                Ext.getCmp('ProductId').setValue(record.data.ProductId);
                                Ext.getCmp('ProductIdUnit').setValue(record.data.Unit);
                                Ext.getCmp('ProductIdUnitName').setValue(record.data.UnitText);
                                Ext.getCmp('SalePriceLower').setValue(record.data.SalePriceLower);
                                Ext.getCmp('SalePriceLimit').setValue(record.data.SalePriceLimit);
                                //up,down,
                                Ext.getCmp("TaxWhPrice").setValue(0);
                                this.collapse();
                            }  
                        }); 
                
                 var customerFilterCombo = new Ext.form.ComboBox({  
                            store: dsCustomers,  
                            displayField:'ChineseName',
                            displayValue:'CustomerId',
                            typeAhead: false,  
                            minChars:1,
                            loadingText: 'Searching...',  
                            tpl: resultTpl,  
                            pageSize:10,  
                            hideTrigger:true,  
                            applyTo: 'ChineseName',
                            itemSelector: 'div.search-item', 
                            onSelect: function(record){ // override default onSelect to do redirect  
                                //alert(record.data.cusid); 
                                //alert(Ext.getCmp('search').getValue());                            
                                Ext.getCmp('ChineseName').setValue(record.data.ChineseName);
                                Ext.getCmp('CustomerId').setValue(record.data.CustomerId);
                                //Ext.getCmp('searchdivid').style.overflow='hidden';
                                this.collapse();
                            }  
                 }); 
                /*----------定义供应商组合框 end -------------*/
            }
            /*-----编辑Fixpice实体类窗体函数----*/
            function modifyFixpiceWin() {
                var sm = crmCustomreFixPricegrid.getSelectionModel();
                //获取选择的数据信息
                var selectData = sm.getSelected();
                if (selectData == null) {
                    Ext.Msg.alert("提示", "请选中需要编辑的信息！");
                    return;
                }
                uploadFixpiceWindow.show();
                Ext.getCmp('ProductName').setDisabled(true);
	            Ext.getCmp('ChineseName').setDisabled(true);
                setFormValue(selectData);
            }
            /*-----删除Fixpice实体函数----*/
            /*删除信息*/
            function deleteFixpice() {
                var sm = crmCustomreFixPricegrid.getSelectionModel();
                //获取选择的数据信息
                var selectData = sm.getSelected();
                //如果没有选择，就提示需要选择数据信息
                if (selectData == null) {
                    Ext.Msg.alert("提示", "请选中需要删除的信息！");
                    return;
                }
                //删除前再次提醒是否真的要删除
                Ext.Msg.confirm("提示信息", "是否真的要删除选择的信息吗？", function callBack(id) {
                    //判断是否删除数据
                    if (id == "yes") {
                        //页面提交
                        Ext.Ajax.request({
                            url: 'frmInnerCustomerFixPrice.aspx?method=deleteFixpice',
                            method: 'POST',
                            params: {
                                SpecialPricingId: selectData.data.SpecialPricingId
                            },
                            success: function(resp, opts) {
                                Ext.Msg.alert("提示", "数据删除成功");
                            },
                            failure: function(resp, opts) {
                                Ext.Msg.alert("提示", "数据删除失败");
                            }
                        });
                    }
                });
            }
            /*调整商品下所有记录*/
            function AdjustFixpiceByProduct(){
                
            }
            
            /*------实现FormPanle的函数 start---------------*/
            var crmCustomreFixPrice = new Ext.form.FormPanel({
                //renderTo: 'divForm',
                frame: true,
                items: [
                {
                    layout:'column',
		            border: false,
		            items: [
		            {
			            layout:'form',
			            border: false,
			            columnWidth:1,
			            items: [
		                    {
		                        xtype: 'hidden',
		                        fieldLabel: '客户商品特殊定价ID',
		                        name: 'SpecialPricingId',
		                        id: 'SpecialPricingId',
		                        hidden: true,
                                hideLabel: false
		                    },
		                    {
		                        xtype: 'hidden',
		                        fieldLabel: '客户ID',
		                        name: 'CustomerId',
		                        id: 'CustomerId',
		                        hidden: true,
                                hideLabel: false
		                    },
		                    {
		                        xtype: 'hidden',
		                        fieldLabel: 'type',
		                        name: 'PriceType',
		                        id: 'PriceType',
		                        hidden: true,
                                hideLabel: false,
                                value:99
		                    },{
                                xtype: 'textfield',
                                fieldLabel: '公司名称',
                                anchor: '90%',
                                name: 'ChineseName',
                                id: 'ChineseName'
	                            ,allowBlank:false               //不允许为空
                                ,blankText:'该项不能为空!'  //显示为空的错
                         }]
		             }]
		        },
                {
                    layout:'column',
		            border: false,
		            items: [
		            {
			            layout:'form',
			            border: false,
			            columnWidth:.5,
			            items: [
			            {
                            xtype: 'hidden',
                            fieldLabel: '商品ID',
                            anchor: '90%',
                            name: 'ProductId',
                            id: 'ProductId',
                            hidden:true,
                            hideLabel:true
                        },
                        {
                            xtype: 'textfield',
                            fieldLabel: '商品名称',
                            anchor: '90%',
                            name: 'ProductName',
                            id: 'ProductName'
	                        ,allowBlank:false               //不允许为空
                            ,blankText:'该项不能为空!'  //显示为空的错
                        }]
                    }, 
                    {
                        layout:'form',
			            border: false,
			            columnWidth:.5,
			            items: [
			            {
                            xtype: 'textfield',
                            fieldLabel: '规格',
                            anchor: '90%',
                            name: 'ProductIdUnit',
                            id: 'ProductIdUnit',
                            hidden:true,
                            hideLabel:true
                        },
                        {
                            xtype: 'textfield',
                            fieldLabel: '规格',
                            anchor: '90%',
                            name: 'ProductIdUnitName',
                            id: 'ProductIdUnitName'
                        }
                        ]
                    }]
                },
                {
                    layout:'column',
		            border: false,
		            items: [
		            {
			            layout:'form',
			            border: false,
			            columnWidth:.5,
			            items: [
			            {
                            xtype: 'numberfield',
                            fieldLabel: '销售价上限',
                            anchor: '90%',
                            name: 'SalePriceLimit',
                            id: 'SalePriceLimit'
                        }]
                    },
                    {
                        layout:'form',
			            border: false,
			            columnWidth:.5,
			            items: [
                        {
                            xtype: 'numberfield',
                            fieldLabel: '销售价下限',
                            anchor: '90%',
                            name: 'SalePriceLower',
                            id: 'SalePriceLower'
                        }]
                     }]
                },
                {
                    layout:'column',
		            border: false,
		            items: [
		            {
			            layout:'form',
			            border: false,
			            columnWidth:.5,
			            items: [
			            {
                            xtype: 'numberfield',
                            fieldLabel: '销售单价',
                            anchor: '90%',
                            name: 'SalePrice',
                            id: 'SalePrice'
	                        ,allowBlank:false               //不允许为空
                            ,blankText:'该项不能为空!'  //显示为空的错
                        }]
                     },
                     {
                        layout:'form',
			            border: false,
			            columnWidth:.5,
			            items: [
			            {
                            xtype: 'numberfield',
                            fieldLabel: '含税入库价',
                            anchor: '90%',
                            name: 'TaxWhPrice',
                            id: 'TaxWhPrice'
                        }]
                     }]
                },
                {
                    layout:'column',
		            border: false,
		            items: [
		            {
			            layout:'form',
			            border: false,
			            columnWidth:.5,
			            items: [
			            {
                            xtype: 'numberfield',
                            fieldLabel: '税率',
                            anchor: '90%',
                            name: 'TaxRate',
                            id: 'TaxRate'
                        }]
                     },
                     {
                        layout:'form',
			            border: false,
			            columnWidth:.5,
			            items: [
                        {
                            xtype: 'numberfield',
                            fieldLabel: '税金',
                            anchor: '90%',
                            name: 'Tax',
                            id: 'Tax'
                        }]
                    }]
                },
                {
                    layout:'column',
		            border: false,
		            items: [
		            {
			            layout:'form',
			            border: false,
			            columnWidth:.5,
			            items: [
			            {
                            xtype: 'numberfield',
                            fieldLabel: '销售税率',
                            anchor: '90%',
                            name: 'SalesTax',
                            id: 'SalesTax'
                        }]
                    },
                    {
                        layout:'form',
			            border: false,
			            columnWidth:.5,
			            items: [
                        {
                            xtype: 'numberfield',
                            fieldLabel: '汽车运费',
                            anchor: '90%',
                            name: 'AutoFreight',
                            id: 'AutoFreight'
                        }]
                    }]
                }, 
                {
                    layout:'column',
		            border: false,
		            items: [
		            {
			            layout:'form',
			            border: false,
			            columnWidth:.5,
			            items: [
			            {
                            xtype: 'numberfield',
                            fieldLabel: '驾驶员运费',
                            anchor: '90%',
                            name: 'DriverFreight',
                            id: 'DriverFreight'
                        }]
                    },
                    {
                        layout:'form',
			            border: false,
			            columnWidth:.5,
			            items: [
			            {
                            xtype: 'numberfield',
                            fieldLabel: '火车运费',
                            anchor: '90%',
                            name: 'TrainFreight',
                            id: 'TrainFreight'
                        }]
                    }]
                }, 
                {
                    layout:'column',
		            border: false,
		            items: [
		            {
			            layout:'form',
			            border: false,
			            columnWidth:.5,
			            items: [
			            {
                            xtype: 'numberfield',
                            fieldLabel: '船运费',
                            anchor: '90%',
                            name: 'ShipFreight',
                            id: 'ShipFreight'
                        }]
                     },
                     {
                        layout:'form',
			            border: false,
			            columnWidth:.5,
			            items: [
                        {
                            xtype: 'numberfield',
                            fieldLabel: '客户运费',
                            anchor: '90%',
                            name: 'OtherFeight',
                            id: 'OtherFeight'
                        }]
                     }]
                }, 
                {
                    layout:'column',
		            border: false,
		            items: [
		            {
			            layout:'form',
			            border: false,
			            columnWidth:.5,
			            items: [
			            {
                            xtype: 'datefield',
                            fieldLabel: '生效日期',
                            anchor: '90%',
                            name: 'ValidDate',
                            id: 'ValidDate',
                            format:'Y年m月d日',
                            value:new Date().clearTime()
                        }]
                     },
                     {
                        layout:'form',
			            border: false,
			            columnWidth:.5,
			            items: [
                        {
                            xtype: 'datefield',
                            fieldLabel: '失效日期',
                            anchor: '90%',
                            name: 'ExpireDate',
                            id: 'ExpireDate',
                            format:'Y年m月d日',
                            value:new Date("2099/12/31").clearTime()
                        }]
                     }]
                }, 
                {
                    ayout:'column',
		            border: false,
		            items: [
		            {
			            layout:'form',
			            border: false,
			            columnWidth:.1,
			            items: [
			            {
                            xtype: 'textarea',
                            fieldLabel: '备注',
                            anchor: '95%',
                            name: 'Remark',
                            id: 'Remark'
                        }]
                    }]
                }]
            });
            /*------FormPanle的函数结束 End---------------*/

            /*------开始界面数据的窗体 Start---------------*/
            if (typeof (uploadFixpiceWindow) == "undefined") {//解决创建2个windows问题
                uploadFixpiceWindow = new Ext.Window({
                    id: 'Fixpiceformwindow'
		, iconCls: 'upload-win'
		, width: 550
		, height: 400
		, layout: 'fit'
		, plain: true
		, modal: true
		, constrain: true
		, resizable: false
		, closeAction: 'hide'
		, autoDestroy: true
		, items: crmCustomreFixPrice
		, buttons: [{
		    text: "保存"
			, handler: function() {
			    saveUserData();
			}
			, scope: this
		},
		{
		    text: "取消"
			, handler: function() {
			    uploadFixpiceWindow.hide();
			}
			, scope: this
}]
                });
            }
            uploadFixpiceWindow.addListener("hide", function() {
                crmCustomreFixPrice.getForm().reset();
            });
            uploadFixpiceWindow.addListener("show", function() {
                             
            });

            /*------开始获取界面数据的函数 start---------------*/
            function saveUserData() {
                //check
                if(!crmCustomreFixPrice.form.isValid()){
                    Ext.Msg.alert("提示", "保存失败,请检查录入数据是否有效！");
                    return;
                }
            
                if(saveType == 'add')
                    saveType = 'addFixpice';
                else if(saveType == 'save')
                    saveType = 'saveFixpice';
                    //alert(saveType);
                Ext.MessageBox.wait("数据正在保存，请稍后……");
                Ext.Ajax.request({
                    url: 'frmInnerCustomerFixPrice.aspx?method='+saveType,
                    method: 'POST',
                    params: {
                        SpecialPricingId: Ext.getCmp('SpecialPricingId').getValue(),
                        CustomerId: Ext.getCmp('CustomerId').getValue(),
                        ProductId: Ext.getCmp('ProductId').getValue(),
                        SalePriceLimit: Ext.getCmp('SalePriceLimit').getValue(),
                        SalePriceLower: Ext.getCmp('SalePriceLower').getValue(),
                        SalePrice: Ext.getCmp('SalePrice').getValue(),
                        TaxWhPrice: Ext.getCmp('TaxWhPrice').getValue(),
                        TaxRate: Ext.getCmp('TaxRate').getValue(),
                        Tax: Ext.getCmp('Tax').getValue(),
                        SalesTax: Ext.getCmp('SalesTax').getValue(),
                        AutoFreight: Ext.getCmp('AutoFreight').getValue(),
                        DriverFreight: Ext.getCmp('DriverFreight').getValue(),
                        TrainFreight: Ext.getCmp('TrainFreight').getValue(),
                        ShipFreight: Ext.getCmp('ShipFreight').getValue(),
                        OtherFeight: Ext.getCmp('OtherFeight').getValue(),
                        PriceType: Ext.getCmp('PriceType').getValue(),
                        ValidDate: Ext.util.Format.date(Ext.getCmp('ValidDate').getValue(),'Y/m/d'),
                        ExpireDate:Ext.util.Format.date(Ext.getCmp('ExpireDate').getValue(),'Y/m/d'),
                        Remark: Ext.getCmp('Remark').getValue()
                    },
                    success: function(resp, opts) {
                         Ext.MessageBox.hide();
                         if ( checkExtMessage(resp) ) {
                            crmCustomreFixPricegridData.reload();
                            uploadFixpiceWindow.hide();
                         }
                    },
                    failure: function(resp, opts) {
                        Ext.MessageBox.hide();
                        Ext.Msg.alert("提示", "保存失败");
                    }
                });
            }
            /*------结束获取界面数据的函数 End---------------*/

            /*------开始界面数据的函数 Start---------------*/
            function setFormValue(selectData) {
                Ext.Ajax.request({
                    url: 'frmInnerCustomerFixPrice.aspx?method=getfixpice',
                    params: {
                        SpecialPricingId: selectData.data.SpecialPricingId
                    },
                    success: function(resp, opts) {
                        var data = Ext.util.JSON.decode(resp.responseText);
                        Ext.getCmp("SpecialPricingId").setValue(data.SpecialPricingId);
                        Ext.getCmp("CustomerId").setValue(data.CustomerId);
                        Ext.getCmp("ChineseName").setValue(data.CustomerName);
                        Ext.getCmp("ProductId").setValue(data.ProductId);
                        Ext.getCmp("ProductName").setValue(data.ProductName);
                        Ext.getCmp("ProductIdUnitName").setValue(data.SpecificationsText);
                        Ext.getCmp("SalePriceLimit").setValue(data.SalePriceLimit);
                        Ext.getCmp("SalePriceLower").setValue(data.SalePriceLower);
                        Ext.getCmp("SalePrice").setValue(data.SalePrice);
                        Ext.getCmp("TaxWhPrice").setValue(data.TaxWhPrice);
                        Ext.getCmp("TaxRate").setValue(data.TaxRate);
                        Ext.getCmp("Tax").setValue(data.Tax);
                        Ext.getCmp("SalesTax").setValue(data.SalesTax);
                        Ext.getCmp("AutoFreight").setValue(data.AutoFreight);
                        Ext.getCmp("DriverFreight").setValue(data.DriverFreight);
                        Ext.getCmp("TrainFreight").setValue(data.TrainFreight);
                        Ext.getCmp("ShipFreight").setValue(data.ShipFreight);
                        Ext.getCmp("OtherFeight").setValue(data.OtherFeight);
                        Ext.getCmp("PriceType").setValue(data.PriceType);
                        Ext.getCmp("Remark").setValue(data.Remark);
                        if (data.ValidDate != '') {
                            Ext.getCmp('ValidDate').setValue(new Date(Date.parse(data.ValidDate)));
                        }
                        if (data.ExpireDate != '') {
                            Ext.getCmp('ExpireDate').setValue(new Date(Date.parse(data.ExpireDate)));
                        }
//                        Ext.getCmp('ValidDate').setValue((new Date(data.ValidDate.replace(/-/g,"/"))));
//                        Ext.getCmp('ExpireDate').setValue((new Date(data.ExpireDate.replace(/-/g,"/"))));
                    },
                    failure: function(resp, opts) {
                        Ext.Msg.alert("提示", "获取用户信息失败");
                    }
                });
            }
            /*------结束设置界面数据的函数 End---------------*/
/*------开始获取数据的函数 start---------------*/
var crmCustomreFixPricegridData = new Ext.data.Store
({
    url: 'frmInnerCustomerFixPrice.aspx?method=getFixpiceList',
    reader: new Ext.data.JsonReader({
        totalProperty: 'totalProperty',
        root: 'root'
    }, [
	{	    name: 'SpecialPricingId'	},
	{	    name: 'CustomerId'	},
	{       name: "CustomerName" },
	{	    name: 'ProductId'	},
	{	    name: 'ProductName'	},
	{	    name: 'SpecificationsText'	},
	{	    name: 'SalePriceLimit'	},
	{	    name: 'SalePriceLower'	},
	{	    name: 'SalePrice'	},
	{	    name: 'TaxWhPrice'	},
	{	    name: 'TaxRate'	},
	{	    name: 'Tax'	},
	{	    name: 'SalesTax'	},
	{	    name: 'AutoFreight'	},
	{	    name: 'DriverFreight'	},
	{	    name: 'TrainFreight'	},
	{	    name: 'ShipFreight'	},
	{	    name: 'OtherFeight'	},
	{	    name: 'ValidDate'	},
	{	    name: 'ExpireDate'	},
	{	    name: 'Remark'	},
	{	    name: 'CreateDate'	},
	{	    name: 'UpdateDate'	},
	{	    name: 'OperId'	},
	{	    name: 'OrgId'}])
	,
    listeners:
	{
	    scope: this,
	    load: function() {
	    }
	}
});
 /*------获取数据的函数 结束 End---------------*/
/*------开始查询form的函数 start---------------*/
        var customerNamePanel = new Ext.form.TextField({
            style: 'margin-left:0px',
            cls: 'key',
            xtype: 'textfield',
            fieldLabel: '客户名称',
            id:'sCustoemrSearch',
            name:'sCustoemrSearch',
            anchor: '90%',
            listeners: { specialkey: function(f, e) { if (e.getKey() == e.ENTER) { Ext.getCmp('sProductSearch').focus(); } } }
        });
        
        var productNamePanel = new Ext.form.TextField({
            style: 'margin-left:0px',
            cls: 'key',
            xtype: 'textfield',
            fieldLabel: '产品名称',
            id:'sProductSearch',
            name:'sProductSearch',
            anchor: '90%',
            listeners: { specialkey: function(f, e) { if (e.getKey() == e.ENTER) { Ext.getCmp('searchebtnId').focus(); } } }
        });

        var searchform = new Ext.FormPanel({
            renderTo: 'searchForm',
            labelAlign: 'left',
            layout: 'fit',
            buttonAlign: 'right',
            bodyStyle: 'padding:3px',
            height:50,
            frame: true,
            labelWidth: 55,
            items: [{
                layout: 'column',   //定义该元素为布局为列布局方式
                border: false,
                items: [{
                    columnWidth: .4,
                    layout: 'form',
                    border: false,
                    items: [
                        customerNamePanel
                        ]
                },{
                    columnWidth: .4,
                    layout: 'form',
                    border: false,
                    items: [
                        productNamePanel
                        ]
                }, {
                    columnWidth: .2,
                    layout: 'form',
                    border: false,
                    items: [{ cls: 'key',
                        xtype: 'button',
                        text: '查询',
                        id: 'searchebtnId',
                        anchor: '50%',
                        handler: function() {
                            var customerName = customerNamePanel.getValue();
                            var productName = productNamePanel.getValue();

                            crmCustomreFixPricegridData.baseParams.PriceType = 99;
                            crmCustomreFixPricegridData.baseParams.CustomerName =customerName;
                            crmCustomreFixPricegridData.baseParams.ProductName =productName;
                            crmCustomreFixPricegrid.getStore().load({
                                params: {
                                    start: 0,
                                    limit: 10
                                }
                            });
                        }
                    },{
                    columnWidth: .4,  //该列占用的宽度，标识为20％
                    layout: 'form',
                    border: false,
                    html:'&nbsp'
                }]
                }]
            }]
        });


        /*------开始查询form的函数 end---------------*/

            /*------开始DataGrid的函数 start---------------*/

            var sm = new Ext.grid.CheckboxSelectionModel({
                singleSelect: true
            });
            var crmCustomreFixPricegrid = new Ext.grid.GridPanel({
            el: 'crmCustomreFixPriceGrid',
                width: '100%',
                height: '100%',
                autoWidth: true,
                autoHeight: true,
                autoScroll: true,
                layout: 'fit',
                id: '',
                store: crmCustomreFixPricegridData,
                loadMask: { msg: '正在加载数据，请稍侯……' },
                sm: sm,
                cm: new Ext.grid.ColumnModel([
		sm,
		new Ext.grid.RowNumberer(), //自动行号
		{
		header: '客户商品特殊定价ID',
		dataIndex: 'SpecialPricingId',
		id: 'SpecialPricingId',
		hidden: true,
        hideable: false
},
		{
		    header: '客户Id',
		    dataIndex: 'CustomerId',
		    id: 'CustomerId',
		    hidden: true,
            hideable: false
		},
		{
		    header: '商品ID',
		    dataIndex: 'ProductId',
		    id: 'ProductId',
		    hidden: true,
            hideable: false
		},
		{
		    header: '客户名称',
		    dataIndex: 'CustomerName',
		    id: 'CustomerName'
		},
		{
		    header: '商品名称',
		    dataIndex: 'ProductName',
		    id: 'ProductIdText'
		},
		{
		    header: '规格',
		    dataIndex: 'SpecificationsText',
		    id: 'ProductIdUnit'
		},
		{
		    header: '销售价上限',
		    dataIndex: 'SalePriceLimit',
		    id: 'SalePriceLimit'
		},
		{
		    header: '销售价下限',
		    dataIndex: 'SalePriceLower',
		    id: 'SalePriceLower'
		},
		{
		    header: '销售单价',
		    dataIndex: 'SalePrice',
		    id: 'SalePrice'
		},
		{
		    header: '含税入库价',
		    dataIndex: 'TaxWhPrice',
		    id: 'TaxWhPrice'
		},
		{
		    header: '税率',
		    dataIndex: 'TaxRate',
		    id: 'TaxRate'
		},
		{
		    header: '税金',
		    dataIndex: 'Tax',
		    id: 'Tax'
		},
		{
		    header: '销售税率',
		    dataIndex: 'SalesTax',
		    id: 'SalesTax'
		},
		{
		    header: '生效时间',
		    dataIndex: 'ValidDate',
		    id: 'ValidDate',
		    renderer: Ext.util.Format.dateRenderer('Y年m月d日')
		},
		{
		    header: '失效时间',
		    dataIndex: 'ExpireDate',
		    id: 'ExpireDate',
		    renderer: Ext.util.Format.dateRenderer('Y年m月d日')
		},
		{
		    header: '备注',
		    dataIndex: 'Remark',
		    id: 'Remark'
		}]),
                bbar: new Ext.PagingToolbar({
                    pageSize: 10,
                    store: crmCustomreFixPricegridData,
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
                height: 280,
                closeAction: 'hide',
                stripeRows: true,
                loadMask: true//,
                //autoExpandColumn: 2
            });
            crmCustomreFixPricegrid.render();
            /*------DataGrid的函数结束 End---------------*/
/*
            var customerFilterCombo = new Ext.form.ComboBox({  
                store: dsCustomers,  
                displayField:'ChineseName',
                displayValue:'CustomerId',
                typeAhead: false,                  
                minChars:1,
                loadingText: 'Searching...',  
                tpl: resultTpl,  
                pageSize:10,  
                hideTrigger:true,  
                applyTo: 'sCustoemrSearch',
                itemSelector: 'div.search-item'
            });*/

        })
</script>
</html>
