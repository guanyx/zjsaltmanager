<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmPOSOrderEdit.aspx.cs" Inherits="SCM_frmPOSOrderEdit" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html>
<head>
<title>POS订单维护</title><meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<link rel="stylesheet" type="text/css" href="../ext3/resources/css/ext-all.css" />
<link rel="stylesheet" type="text/css" href="../Theme/1/css/salt.css" />
<script type="text/javascript" src="../ext3/adapter/ext/ext-base.js"></script>
<script type="text/javascript" src="../ext3/ext-all.js"></script>
<script type="text/javascript" src="../ext3/example/ItemDeleter.js"></script>
<script type="text/javascript" src="../js/operateResp.js"></script>
<script type="text/javascript" src="../js/ExtFix.js"></script>
<script type="text/javascript" src="../ext3/src/locale/ext-lang-zh_CN.js"></script>
<style type="text/css">
.extensive-remove {
background-image: url(../Theme/1/images/extjs/customer/cross.gif) ! important;
}
.x-grid-back-blue { 
background: #B7CBE8; 
}
</style>
</head>
<body>
<div id='divForm'></div>
<div id='divGrid'></div>
<div id='divBotton'></div>
</body>
<%= getComboBoxStore() %>
<script type="text/javascript">
Ext.BLANK_IMAGE_URL = "../ext3/resources/images/default/s.gif";
    function GetUrlParms() {
        var args = new Object();
        var query = location.search.substring(1); //获取查询串   
        var pairs = query.split("&"); //在逗号处断开   
        for (var i = 0; i < pairs.length; i++) {
            var pos = pairs[i].indexOf('='); //查找name=value   
            if (pos == -1) continue; //如果没有找到就跳过   
            var argname = pairs[i].substring(0, pos); //提取name   
            var value = pairs[i].substring(pos + 1); //提取value   
            args[argname] = unescape(value); //存为属性   
        }
        return args;
    }
    var args = new Object();
    args = GetUrlParms();
    //如果要查找参数key:
    var OrderId = args["id"];
    var OperType = args["OpenType"];



    Ext.onReady(function() {  
    
        Ext.form.TextField.prototype.afterRender = Ext.form.TextField.prototype.afterRender.createSequence(function() {
         this.relayEvents(this.el, ['onblur']);
        });
        
    dsWareHouse=null; //下拉框
    if (dsWareHouse == null) { //防止重复加载
        dsWareHouse = new Ext.data.JsonStore({
            totalProperty: "result",
            root: "root",
            url: 'frmPOSOrderEdit.aspx?method=getUserWarehouse',
            fields: ['WhId', 'WhName']
        })
     };  
      //仓位数据源
    var dsWarehousePosList;
    if (dsWarehousePosList == null) { //防止重复加载
        dsWarehousePosList = new Ext.data.Store
        ({
            url: 'frmPOSOrderEdit.aspx?method=getWarehousePosList',
            reader: new Ext.data.JsonReader({
                totalProperty: 'totalProperty',
                root: 'root'
            }, [{name: 'WhpId'},
                {name: 'WhpName'}
            ])
        });
    }  
       
    function initCustomerInfo( record){     
        Ext.getCmp("CustomerId").setValue(record.data.CustomerId);
        Ext.getCmp("cusno").setValue(record.data.CustomerNo);
        Ext.getCmp("cusname").setValue(record.data.ShortName);
        Ext.getCmp("cusadd").setValue(record.data.Address);
        Ext.getCmp("mobile").setValue(record.data.LinkTel);
        Ext.getCmp("person").setValue(record.data.LinkMan); 
        Ext.getCmp("DlvAdd").setValue(record.data.DeliverAdd);
        if(record.data.InvoiceType!=''&&record.data.InvoiceType.indexOf('S')>-1)
            Ext.getCmp("BillMode").setValue(record.data.InvoiceType);
        if(record.data.SettlementWay!='')
            Ext.getCmp("PayType").setValue(record.data.SettlementWay);
        dsProductList.baseParams.CustomerId=record.data.CustomerId;
        dsProductList.load();      
    }
    
    var initOrderForm = new Ext.form.FormPanel({
           renderTo: 'divForm',
           frame: true,
           monitorValid: true, // 把有formBind:true的按钮和验证绑定
           labelWidth: 70,
           items:
           [
            {
                layout:'column',
                border: true,                                 
                items:
                [{
                   layout: 'form',
                   columnWidth: .95,  //该列占用的宽度，标识为20％
                   border: false,
                   items: [{
                            style: 'margin-left:0px',
                            cls: 'key',
                            xtype: 'textfield',
                            fieldLabel: '客户编号',
                            name: 'cusno',
                            id:'cusno',
                            anchor: '100%'
                          }]
                 },
                 {
                   layout: 'form',
                   columnWidth: .05,  //该列占用的宽度，标识为20％
                   border: false,
                   items: [{
                            xtype:'button', 
                            iconCls:"find",
                            autoWidth : true,
                            autoHeight : true,
                            hideLabel:true,
                            listeners:{
                                click:function(v){
                                    getCustomerInfo(initCustomerInfo,Ext.getCmp('OrgId').getValue());                                    
                                }
                            }
                          }]
                 }]
            } ,
            {
                layout:'column',
                border: false,
                items:
                [{
                   layout: 'form',
                   columnWidth: .33,  //该列占用的宽度，标识为20％
                   border: false,
                   items: [{
                       cls: 'key',
                       xtype: 'textfield',
                       disabled:true,
                       fieldLabel: '客户名称',
                       name: 'cusname',
                       id: 'cusname',
                       anchor: '98%'
                           }]
                  },
                  {
                   layout: 'form',
                   columnWidth: .33,  //该列占用的宽度，标识为20％
                   border: false,
                   items: [{
                       cls: 'key',
                       xtype: 'textfield',
                       disabled:true,
                       fieldLabel: '联系电话',
                       name: 'mobile',
                       id: 'mobile',
                       anchor: '98%'
                          }]
                  } ,
                  {
                   layout: 'form',
                   columnWidth: .33,  //该列占用的宽度，标识为20％
                   border: false,
                   items: [{
                       cls: 'key',
                       xtype: 'textfield',
                       disabled:true,
                       fieldLabel: '负责人',
                       name: 'person',
                       id: 'person',
                       anchor: '98%'
                          }]
                 }]
            },
            {
                layout:'column',
                border: false,
                items:
                [{
                   layout: 'form',
                   columnWidth: 1,  //该列占用的宽度，标识为20％
                   border: false,
                   items: [{
                       cls: 'key',
                       xtype: 'textfield',
                       disabled:true,
                       fieldLabel: '客户地址',
                       name: 'cusadd',
                       id: 'cusadd',
                       anchor: '98%'
                          }]
                 }]
             },
            {
                layout:'column',
                border: false,
                items:
                [{
                   layout: 'form',
                   columnWidth: 1,  //该列占用的宽度，标识为20％
                   border: false,
                   items: [{
                       xtype: 'hidden',
                       fieldLabel: '客户ID',
                       name: 'CustomerId',
                       id: 'CustomerId',
                       anchor: '98%',
                       hidden:true,
                       hideLabel:true
                          }]
                 }]
             },
             {
		                layout:'column',
		                border: false,
		                labelSeparator: '：',
		                items: [
		                {
			                layout:'form',
			                border: false,
			                columnWidth: 1,
			                items: [{
		                            xtype:'hidden',
			                        fieldLabel:'订单标识',
			                        columnWidth:1,
			                        anchor:'98%',
			                        name:'OrderId',
			                        id:'OrderId'
		                        }]
		                }
                ]},{
		                layout:'column',
		                border: false,
		                labelSeparator: '：',
		                items: [
		                {
			                layout:'form',
			                border: false,
			                columnWidth:0.33,
			                items: [
				                {
					                xtype:'combo',
                                    fieldLabel:'公司',
                                    anchor:'98%',
                                    name:'OrgName',
                                    id:'OrgId',
                                    store: dsOrg,
                                    displayField: 'OrgName',  //这个字段和业务实体中字段同名
                                    valueField: 'OrgId',      //这个字段和业务实体中字段同名
                                    typeAhead: true, //自动将第一个搜索到的选项补全输入
                                    triggerAction: 'all',
                                    emptyValue: '',
                                    selectOnFocus: true,
                                    forceSelection: true,
                                    mode:'local'   // ,
//                                    listeners: {
//                                       select: function(combo, record, index) {
//                                            var curWhId = Ext.getCmp('OrgId').getValue();
//                                            dsDept.load({
//                                                params: {
//                                                    orgID: curWhId
//                                                }
//                                            });
//                                        }
//                                    }  
				                }
		                            ]
		                }		                
                ,		{
			                layout:'form',
			                border: false,
			                columnWidth:0.33,
			                items: [
				                {
					                xtype:'combo',
                                    fieldLabel:'部门',
                                    anchor:'98%',
                                    name:'SaleDept',
                                    id:'SaleDept',
                                    store: dsDept,
                                    displayField: 'DeptName',  //这个字段和业务实体中字段同名
                                    valueField: 'DeptId',      //这个字段和业务实体中字段同名
                                    typeAhead: true, //自动将第一个搜索到的选项补全输入
                                    triggerAction: 'all',
                                    emptyValue: '',
                                    selectOnFocus: true,
                                    forceSelection: true,
                                    mode:'local'    
				                }
		                    ]
		                }
                ,		{
			                layout:'form',
			                border: false,
			                columnWidth:0.33,
			                items: [
				                {
					                 xtype: 'combo',
                                   store: dsWareHouse,//dsWareHouse,
                                   valueField: 'WhId',
                                   displayField: 'WhName',
                                   mode: 'local',
                                   forceSelection: true,
                                   editable: false,
                                   name:'OutStor',
                                   id:'OutStor',
                                   emptyValue: '',
                                   triggerAction: 'all',
                                   fieldLabel: '仓库',
                                   selectOnFocus: true,
                                   anchor: '98%',
                                   listeners: {
                                        select: function(combo, record, index) {
                                            var curWhId = Ext.getCmp("OutStor").getValue();
                                            if(dsWarehousePosList.baseParams.WhId!=curWhId)
		                                    {
		                                        dsWarehousePosList.baseParams.WhId=curWhId;
		                                        dsWarehousePosList.load();
		                                    }
//                                            dsWarehousePosList.load({
//                                                params: {
//                                                    WhId: curWhId
//                                                }
//                                            });
                                        }
				                    }
		                
		                          }]
		                 }
	                ]},{
		                layout:'column',
		                border: false,
		                labelSeparator: '：',
		                items: [
		                {
			                layout:'form',
			                border: false,
			                columnWidth:0.66,
			                items: [
				                {
					               xtype:'textfield',
		                            fieldLabel:'送货描述',
		                            columnWidth:1,
		                            anchor:'98%',
		                            name:'DlvDesc',
		                            id:'DlvDesc'
				                }
		                            ]
		                },
		                {
			                layout:'form',
			                border: false,
			                columnWidth:0.33,
			                items: [
				                {
					                xtype: 'combo',
                                   store: dsDlvLevel,
                                   valueField: 'DicsCode',
                                   displayField: 'DicsName',
                                   mode: 'local',
                                   forceSelection: true,
                                   editable: false,
                                   emptyValue: '',
                                   triggerAction: 'all',
                                   fieldLabel: '送货等级',
                                    name:'DlvLevel',
                                   id:'DlvLevel',
                                   selectOnFocus: true,
                                   anchor: '98%'
				                }
		                            ]
		                }		 		               
	                ]},{
		                layout:'column',
		                border: false,
		                labelSeparator: '：',
		                items: [
		                {
			                layout:'form',
			                border: false,
			                columnWidth:0.33,
			                items: [
				                {
					                xtype: 'combo',
                                   store:dsBillMode,
                                   valueField: 'DicsCode',
                                   displayField: 'DicsName',
                                   mode: 'local',
                                   forceSelection: true,
                                   editable: false,
                                   emptyValue: '',
                                   triggerAction: 'all',
                                   fieldLabel: '结算方式',
                                   name:'PayType',
                                   id:'PayType',
                                   selectOnFocus: true,
                                   anchor: '98%'
				                }
		                            ]
		                }		                
                ,		{
			                layout:'form',
			                border: false,
			                columnWidth:0.33,
			                items: [
				                {
					               xtype: 'combo',
                                   store: dsPayType,
                                   valueField: 'DicsCode',
                                   displayField: 'DicsName',
                                   mode: 'local',
                                   forceSelection: true,
                                   editable: false,
                                   emptyValue: '',
                                   triggerAction: 'all',
                                   fieldLabel: '开票方式',
                                   name:'BillMode',
                                   id:'BillMode',
                                   selectOnFocus: true,
                                   anchor: '98%'
				                }
		                ]
		                }
                ,		{
			                layout:'form',
			                border: false,
			                columnWidth:0.33,
			                items: [
				                {
					                xtype: 'combo',
                                   store: dsDlvType,
                                   valueField: 'DicsCode',
                                   displayField: 'DicsName',
                                   mode: 'local',
                                   forceSelection: true,
                                   editable: false,
                                   emptyValue: '',
                                   triggerAction: 'all',
                                   fieldLabel: '配送方式',
                                    name:'DlvType',
                                   id:'DlvType',
                                   selectOnFocus: true,
                                   anchor: '98%',
                                   listeners:
	                               {
	                                select: function(combo, record, index) {
                                        if(combo.getValue()=='S042')
                                            Ext.getCmp('DriverId').setValue('');
                                        }
	                               }
				                }
		                ]
		                }
	                ]},{
		                layout:'column',
		                border: false,
		                labelSeparator: '：',
		                items: [
		                {
			                layout:'form',
			                border: false,
			                columnWidth:0.33,
			                items: [
				                {
					                 xtype:'datefield',
			                        fieldLabel:'送货日期',
			                        columnWidth:0.33,
			                        anchor:'98%',
			                        name:'DlvDate',
			                        id:'DlvDate',
			                        format:'Y年m月d日'
				                }
		                            ]
		                }		                
                ,		{
			                layout:'form',
			                border: false,
			                columnWidth:0.33,
			                items: [
				                {
					               xtype:'textfield',
			                        fieldLabel:'送货地点',
			                        anchor:'98%',
			                        name:'DlvAdd',
			                        id:'DlvAdd'
				                }
		                ]
		                },{
		                layout: 'form',
                    border: false,
                    columnWidth: .33,
                    items: [
                    {
                        xtype: 'combo',
                        fieldLabel: '配送人',
                        anchor: '95%',
                        id: 'DriverId',
                        name: 'DriverId',
                        store: dsDriver,
                        triggerAction: 'all',
                        mode: 'local',
                        displayField: 'DriverName',
                        valueField: 'DriverId',
                        editable: false
}]
                    }
                      ]},{
		                layout:'column',
		                border: false,
		                labelSeparator: '：',
		                items: [		                               
                        {
			                layout:'form',
			                border: false,
			                columnWidth:0.33,
			                items: [
				                {
					                xtype:'hidden',
					                fieldLabel:'是否结款',
					                columnWidth:0.33,
					                anchor:'98%',
					                store:[[1,'是'],[0,'否']],
					                name:'IsPayed1',
					                id:'IsPayed1'
				                }
		                ]
		                }
                ,		{
			                layout:'form',
			                border: false,
			                columnWidth:0.34,
			                items: [
				                {
					                xtype:'hidden',
					                fieldLabel:'是否开票',
					                columnWidth:0.33,
					                anchor:'98%',
					                store:[[1,'是'],[0,'否']],
					                name:'IsBill1',
					                id:'IsBill1'
				                }
		                ]
		                }
	                ]},{
		                layout:'column',
		                border: false,
		                labelSeparator: '：',
		                items: [
		                {
			                layout:'form',
			                border: false,
			                columnWidth:1,
			                items: [
				                {
					                xtype:'textarea',
			                        fieldLabel:'备注',
			                        columnWidth:1,
			                        height:38,
			                        anchor:'98%',
			                        name:'Remark',
			                        id:'Remark'
				                }
		                            ]
		                }		                
                    ]}
                    ,{
		                layout:'column',
		                border: false,
		                labelSeparator: '：',
		                items: [
		                {
			                layout:'form',
			                border: false,
			                columnWidth:1,
			                items: [
				                {
					                xtype:'hidden',
			                        fieldLabel:'状态',
			                        columnWidth:1,
			                        anchor:'98%',
			                        name:'Status',
			                        id:'Status'
			                        
				                }
		                            ]
		                }		                
                    ]}
                    ,{
		                layout:'column',
		                border: false,
		                labelSeparator: '：',
		                items: [
		                {
			                layout:'form',
			                border: false,
			                columnWidth:1,
			                items: [
				                {
					                xtype:'hidden',
			                        fieldLabel:'销售发票号',
			                        columnWidth:1,
			                        anchor:'98%',
			                        name:'SaleInvId',
			                        id:'SaleInvId'
			                        
				                }
		                            ]
		                }		                
                    ]}
                    ,{
		                layout:'column',
		                border: false,
		                labelSeparator: '：',
		                items: [
		                {
			                layout:'form',
			                border: false,
			                columnWidth:1,
			                items: [
				                {
					                xtype:'hidden',
			                        fieldLabel:'已出货数量',
			                        columnWidth:1,
			                        anchor:'98%',
			                        name:'OutedQty',
			                        id:'OutedQty'
			                        
				                }
		                            ]
		                }		                
                    ]}
                     ,{
		                layout:'column',
		                border: false,
		                labelSeparator: '：',
		                items: [
		                {
			                layout:'form',
			                border: false,
			                columnWidth:1,
			                items: [
				                {
					                xtype:'hidden',
			                        fieldLabel:'创建日期',
			                        columnWidth:1,
			                        anchor:'98%',
			                        name:'CreateDate',
			                        id:'CreateDate',
			                        hidden:true,
			                        hideLabel:true
			                        
				                }
		                            ]
		                }		                
                    ]}
                    ,{
		                layout:'column',
		                border: false,
		                labelSeparator: '：',
		                items: [
		                {
			                layout:'form',
			                border: false,
			                columnWidth:1,
			                items: [
				                {
					                xtype:'hidden',
			                        fieldLabel:'是否有效',
			                        columnWidth:1,
			                        anchor:'98%',
			                        name:'IsActive',
			                        id:'IsActive'
			                        
				                }
		                            ]
		                }		                
                    ]} 
           ]
         })
        //加载仓库
        if(!parent.uploadOrderWindow.hidden){
            dsWareHouse.load({callback:function(v){
                //if wh isnoney setit
                if(dsWareHouse.getCount()==1){
                    Ext.getCmp('OutStor').setValue(dsWareHouse.getAt(0).get("WhId"));       
                    dsWarehousePosList.baseParams.WhId=Ext.getCmp('OutStor').getValue();
	                dsWarehousePosList.load();
                }
            }});
        }
        
        //定义下拉框异步调用方法
        var dsCustomer = new Ext.data.Store({   
            url: 'frmOrderDtl.aspx?method=getCusByConLike',  
            reader: new Ext.data.JsonReader({  
                root: 'root',  
                totalProperty: 'totalProperty',  
                id: 'cusno'  
            }, [  
                {name: 'CustomerId', mapping: 'CustomerId'}, 
                {name: 'CustomerNo', mapping: 'CustomerNo'},  
                {name: 'ShortName', mapping: 'ShortName'},
                {name: 'ChineseName', mapping: 'ChineseName'},
                {name: 'Address', mapping: 'Address'},
                {name: 'LinkMan', mapping: 'LinkMan'},  
                {name: 'LinkTel', mapping: 'LinkTel'}, 
                {name: 'DeliverAdd', mapping: 'DeliverAdd'},
                {name: 'InvoiceType', mapping: 'InvoiceType'},
                {name: 'SettlementWay', mapping: 'SettlementWay'}
            ]) 
        });  
        // 定义下拉框异步返回显示模板
        var resultTpl = new Ext.XTemplate(  
            '<tpl for="."><div id="searchdivid" class="search-item">',  
                '<h3><span>编号:{CustomerNo}&nbsp;  名称:{ShortName}&nbsp;  联系人:{LinkMan}&nbsp;  电话:{LinkTel}</span></h3>',
            '</div></tpl>'  
        ); 
           var customer = new Ext.form.ComboBox({
                   xtype: 'combo',
                   store: dsCustomer,
                   applyTo: 'cusno',
                   minChars:1,  
                   pageSize:10,  
                   tpl:resultTpl,
                   hideTrigger:true, 
                   itemSelector: 'div.search-item',  
                   anchor: '98%',
                   onSelect: function(record) {
                        initCustomerInfo(record);
                        this.collapse();//隐藏下拉列表
                    }
               });
               
        function setDefaultWhp(record)
        {
            if(record.get('WhpId')=='')
            {
                
                if(dsWarehousePosList.getCount()==1)
                {
                    record.set('WhpId',dsWarehousePosList.getAt(0).get("WhpId"));
                }
            }
        }
        //-------------------Grid Start-----------------------------
        function inserNewBlankRow() {
            var rowCount = userGrid.getStore().getCount();
            var insertPos = parseInt(rowCount);
            var addRow = new RowPattern({
                WhpId:'',
                ProductId:'',
			    SaleQty:'0',
			    SalePrice:'0',
			    SaleAmt:'0',
			    SaleTax:'',
			    Tax:'0'
            });
            userGrid.stopEditing();
            //增加一新行
            if (insertPos > 0) {
                var rowIndex = dsOrderProduct.insert(insertPos, addRow);
                userGrid.startEditing(insertPos, 0);
            }
            else {
                var rowIndex = dsOrderProduct.insert(0, addRow);
                userGrid.startEditing(0, 0);
            }
        }
        function addNewBlankRow(combo, record, index) {
            var rowIndex = userGrid.getStore().indexOf(userGrid.getSelectionModel().getSelected());
            var rowCount = userGrid.getStore().getCount();
            if ((rowIndex == 0 && rowCount == 1) || rowIndex == rowCount - 1) {
                inserNewBlankRow();
            }
        }
        
        
        
        //定义下拉框异步调用方法,当前客户可订商品列表
        var dsProductList = new Ext.data.Store({   
            url: 'frmOrderDtl.aspx?method=getCustomProduct',  
            params: {
                //CustomerId: Ext.getCmp('CustomerId').getValue(),
                limit:1,
                start:0
            },
            reader: new Ext.data.JsonReader({  
                root: 'root',  
                totalProperty: 'totalProperty',  
                id: 'productlist'  
            }, [  
                {name: 'ProductId', mapping: 'ProductId'}, 
                {name: 'ProductName', mapping: 'ProductName'},  
                {name: 'ProductNo', mapping: 'ProductNo'},
                {name: 'Specifications', mapping: 'Specifications'},  
                {name: 'SpecificationsText', mapping: 'SpecificationsText'}, 
                {name: 'Unit', mapping: 'Unit'}, 
                {name: 'UnitText', mapping: 'UnitText'},
                {name: 'SalePrice', mapping: 'SalePrice'},
                {name: 'SalesTax', mapping: 'SalesTax'}
            ]) 
        }); 
        // 定义下拉框异步返回显示模板
        var resultPrdTpl = new Ext.XTemplate(  
            '<tpl for="."><div id="productdivid" class="search-item">',  
                '<h3><span>{ProductName}&nbsp</h3>',
            '</div></tpl>'  
        ); 
        
        //货位
        var warehousePosCombo = new Ext.form.ComboBox({
            store: dsWarehousePosList,
            displayField: 'WhpName',
            valueField: 'WhpId',
            triggerAction: 'all',
            id: 'warehousePosCombo',
            typeAhead: true,
            mode: 'local',
            emptyText: '',
            selectOnFocus: false,
            editable: false,
            listeners: {
                "select": addNewBlankRow
            }
        });

        //定义下拉框异步调用方法,当前客户可订商品列表
        var dsProductUnits = new Ext.data.Store({   
            url: 'frmOrderDtl.aspx?method=getProductUnits',  
            params: {
                ProductId:0
            },
            reader: new Ext.data.JsonReader({  
                root: 'root',  
                totalProperty: 'totalProperty',  
                id: 'ProductUnits'  
            }, [  
                {name: 'UnitId', mapping: 'UnitId'}, 
                {name: 'UnitName', mapping: 'UnitName'},
                {name: 'UnitSpec', mapping: 'UnitSpec'}
            ]) 
        });  
        
        //计量单位下拉框
        var UnitCombo = new Ext.form.ComboBox({
            store: dsProductUnits,
            displayField: 'UnitName',
            valueField: 'UnitId',
            triggerAction: 'all',
            id: 'UnitCombo',
            //pageSize: 5,  
            //minChars: 2,  
            //hideTrigger: true,  
            typeAhead: true,
            mode: 'local',
            emptyText: '',
            selectOnFocus: false,
            editable: false,
            onSelect:setProductSpec
//            listeners: {
//                "select": addNewBlankRow
//            }
        });

function setProductSpec(record)
{
//    alert('ok');
//alert( record.data.UnitSpec);
    var sm = userGrid.getSelectionModel().getSelected();
    sm.set('Specifications', record.data.UnitSpec);
    UnitCombo.setValue(record.data.UnitId);
    this.collapse();
    addNewBlankRow();
}
//        //计量单位下拉框
//        var UnitCombo = new Ext.form.ComboBox({
//            store: dsUnitList,
//            displayField: 'UnitName',
//            valueField: 'UnitId',
//            triggerAction: 'all',
//            id: 'UnitCombo',
//            //pageSize: 5,  
//            //minChars: 2,  
//            //hideTrigger: true,  
//            typeAhead: true,
//            mode: 'local',
//            emptyText: '',
//            selectOnFocus: false,
//            editable: false,
//            listeners: {
//                "select": addNewBlankRow
//            }
//        });
//        //规格下拉框
//        var productSpecCombo = new Ext.form.ComboBox({
//            store: dsProductSpecList,
//            displayField: 'DicsName',
//            valueField: 'DicsCode',
//            triggerAction: 'all',
//            id: 'productSpecCombo',
//            //pageSize: 5,  
//            //minChars: 2,  
//            //hideTrigger: true,  
//            typeAhead: true,
//            mode: 'local',
//            emptyText: '',
//            selectOnFocus: false,
//            editable: false,
//            listeners: {
//                "select": addNewBlankRow
//            }
//        });
        //商品下拉框
        var productCombo = new Ext.form.ComboBox({
            store: dsProductList,
            displayField: 'ProductName',
            valueField: 'ProductId',
            triggerAction: 'all',
            id: 'productCombo',
            //pageSize: 5,
            //minChars: 2,
            tpl:resultPrdTpl,
            hideTrigger:true, 
            itemSelector: 'div.search-item',  
            editable:false,
            typeAhead: true,
            mode: 'local',
            emptyText: '',
            selectOnFocus: false,
            //lastQuery:'',
            onSelect: function(record) {
                var sm = userGrid.getSelectionModel().getSelected();
                sm.set('ProductCode', record.data.ProductNo);
                sm.set('Specifications', record.data.Specifications);
                sm.set('Unit', record.data.Unit);
                sm.set('ProductId', record.data.ProductId);
                sm.set('ProductName',record.data.ProductName);
                sm.set('SalePrice',record.data.SalePrice);
                sm.set('Tax',record.data.SalesTax);
                setDefaultWhp(sm);
                //sm.set('SalePrice',record.data.Price);
                productCombo.setValue(record.data.ProductId);
                addNewBlankRow();
                
                this.collapse();//隐藏下拉列表
            }
        });
        
        //定义产品下拉框异步调用方法
            var dsProducts;
            if (dsProducts == null) {
                dsProducts = new Ext.data.Store({
                    url: 'frmPOSOrderEdit.aspx?method=getProductByNameNo',
                    reader: new Ext.data.JsonReader({
                        root: 'root',
                        totalProperty: 'totalProperty'
                    }, [
                            { name: 'ProductId', mapping: 'ProductId' },
                            { name: 'ProductNo', mapping: 'ProductNo' },
                            { name: 'ProductName', mapping: 'ProductName' },
                            { name: 'Unit', mapping: 'Unit' },
                            { name: 'SalePrice', mapping: 'SalePrice' },
                            { name: 'SalePriceLower', mapping: 'SalePriceLower' },
                            { name: 'SalePriceLimit', mapping: 'SalePriceLimit' },
                            { name: 'UnitText', mapping: 'UnitText' },
                            { name: 'Specifications', mapping: 'Specifications' },
                            { name: 'SpecificationsText', mapping: 'SpecificationsText' },
                            { name: 'UnitId', mapping: 'UnitId' },
                            { name:'WhQty',mapping:'WhQty'}
                        ])
                });
            }   


        var productText = new Ext.form.TextField({
            name:"ProductNameTpl",
            id:"ProductNameTpl"});
        
        productText.on("focus",setProductFilter);
//        productText.on("blur",lostfocus);
//        function lostfocus()
//        {
//            alert("ok");
//        }
        var productFilterCombo=null;
        
        // 定义下拉框异步返回显示模板
//        var resultTpl = new Ext.XTemplate(  
//            '<tpl for="."><div id="searchdivid" class="search-item">',  
//                '<h3><span>编号:{ProductNo}&nbsp;  名称:{ProductName}</span></h3>',
//            '</div></tpl>'  
//        ); 
        var resultTpl = new Ext.XTemplate(  
            '<tpl for="."><div id="searchdivid" class="search-item">',  
                strTemplate,
            '</div></tpl>'  
        ); 
        
        function setProductFilter()
        {
            dsProducts.baseParams.WhId = Ext.getCmp('OutStor').getValue();
            dsProducts.baseParams.CustomerId=Ext.getCmp("CustomerId").getValue();
            if(productFilterCombo==null)
            {
                productFilterCombo = new Ext.form.ComboBox({
                store: dsProducts,
                displayField: 'ProductName',
                displayValue: 'ProductId',
                typeAhead: false,
                minChars: 1,
                width:400,
                loadingText: 'Searching...',
                tpl: resultTpl,  
                itemSelector: 'div.search-item',  
                pageSize: 10,
                hideTrigger: true,
                applyTo: 'ProductNameTpl',
                onSelect: function(record) { // override default onSelect to do redirect  
                           var sm = userGrid.getSelectionModel().getSelected();
                           var spCustomerId = Ext.getCmp('CustomerId').getValue();
                           
                           dsProductUnits.baseParams.ProductId = record.data.ProductId;
                           dsProductUnits.load();
                           sm.set('Unit', record.data.UnitId);
                           sm.set('SaleQty','0');
                           sm.set('SaleTax','0');
                           sm.set('SaleAmt','0');
                          if(spCustomerId == null ||spCustomerId =='')
                          {
                            productText.setValue(record.data.ProductNo);
                                    sm.set('ProductCode', record.data.ProductNo);
                                    sm.set('Specifications', record.data.Specifications);
                                    //sm.set('Unit', record.data.Unit);
                                    sm.set('ProductId', record.data.ProductId);
                                    sm.set('ProductName',record.data.ProductName);
                                    sm.set('SalePrice',record.data.SalePrice);
                                    setDefaultWhp(sm);
                                    addNewBlankRow();
                                    this.collapse();
                            return;
                          }
                          //获取商品价格信息
                          Ext.Ajax.request({
		                        url:'frmPOSOrderEdit.aspx?method=getProductInfo',
		                        params:{
			                        ProductNo:record.data.ProductNo,
			                        CustomerId:spCustomerId
		                        },
	                        success: function(resp,opts){
	                            //alert(resp.responseText);
	                            if(resp.responseText.length>20){
		                            var data=Ext.util.JSON.decode(resp.responseText); 
		                            
                                    sm.set('ProductCode', record.data.ProductNo);
                                    sm.set('Specifications', data.Specifications);
                                    //sm.set('Unit', data.Unit);
                                    sm.set('ProductId', data.ProductId);
                                    sm.set('ProductName',data.ProductName);
                                    sm.set('SalePrice',data.SalePrice);
                                    sm.set('Tax',data.SalesTax);
                                    if(sm.get('SaleQty')>0){                                       
                                        sm.set('SaleAmt', accMul(record.data.SaleQty , data.SalePrice).toFixed(2));
                                        //sm.set('SaleTax', accMul(record.get('SaleAmt') ,data.Tax) ); //Math.Round(3.445, 1);                         
                                        sm.set('SaleTax', accMul(accDiv(record.get('SaleAmt'),accAdd(1,record.data.Tax)) ,record.data.Tax).toFixed(2) );
                                    }
                                    //sm.set('SalePrice',record.data.Price);
                                    //productCombo.setValue(data.ProductId);
                                    setDefaultWhp(sm);
                                    addNewBlankRow();
//                                    try
//                                    {
                                        productFilterCombo.collapse();
//                                    }
//                                    catch(err)
//                                    {
//                                    }
                                }else{
                                    alert(record.data.ProductName+"销售基准价未设置，请联系价格维护人员设置！");
                                }
		                    }
		                  });         
            
                    
                }
            });
            }
        }
        
        var cmbProductUse = new Ext.form.ComboBox({
                store: dsProductUse,
                displayField: 'CodeName',
                valueField: 'CodeId',
                id:'cmbProductUse',
                typeAhead: true, 
                triggerAction: 'all',
                selectOnFocus: true,
                mode:'local',
                emptyText: '',
                selectOnFocus: false,
                editable: false,
                listeners: {
                    "select": addNewBlankRow
                } 
               });
        
        var cm = new Ext.grid.ColumnModel([
        new Ext.grid.RowNumberer(), //自动行号
        {
        id: 'OrderDtlId',
        header: "订单明细ID",
        dataIndex: 'OrderDtlId',
        width: 30,
        hidden: true,
        editor: new Ext.form.TextField({ allowBlank: false })
    },
      {
            id: 'WhpId',
            header: "仓位",
            dataIndex: 'WhpId',
            width: 75,
            editor: warehousePosCombo,
            renderer: function(value, cellmeta, record, rowIndex, columnIndex, store) {
                //解决值显示问题
                var index = dsWarehousePosList.find(warehousePosCombo.valueField, value);
                var record = dsWarehousePosList.getAt(index);
                var displayText = "";
                if (record == null) {
                    displayText = value;
                } else {
                    displayText = record.data.WhpName; 
                }
                return displayText;
            }         
        },
         {
            id: 'ProductCode',
            header: "商品编码",
            dataIndex: 'ProductCode',
            width: 75,
            editor:productText
//            editor: new Ext.form.TextField({ 
//                listeners:{
//                   specialkey : function(field, e) {
//                        if (e.getKey() == Ext.EventObject.ENTER) {
//                          //获取商品
//                          Ext.Ajax.request({
//		                        url:'frmPOSOrderEdit.aspx?method=getProductInfo',
//		                        params:{
//			                        ProductNo:field.getValue()
//		                        },
//	                        success: function(resp,opts){
//	                            //alert(resp.responseText);
//	                            if(resp.responseText.length>20){
//		                            var data=Ext.util.JSON.decode(resp.responseText);
//		                            var sm = userGrid.getSelectionModel().getSelected();
//                                    sm.set('ProductCode', data.ProductNo);
//                                    sm.set('Specifications', data.Specifications);
//                                    sm.set('Unit', data.Unit);
//                                    sm.set('ProductId', data.ProductId);
//                                    sm.set('ProductName',data.ProductName);
//                                    sm.set('SalePrice',data.SalePrice);
//                                    //sm.set('SalePrice',record.data.Price);
//                                    //productCombo.setValue(data.ProductId);
//                                    addNewBlankRow();
//                                }
//		                    }
//		                  });
//                          window.event.keyCode = Ext.EventObject.TAB;
//                        }
//                        window.event.keyCode = Ext.EventObject.TAB;
//                   }
//                } 
//            })
        },
        {
            id: 'ProductName',
            header: "商品名称",
            dataIndex: 'ProductName',
            width: 155,
            editor: productCombo,
            renderer: function(value, cellmeta, record, rowIndex, columnIndex, store) {
                //解决值显示问题
                //获取当前id="combo_process"的comboBox选择的值
                 var index = dsProductList.find(productCombo.valueField, value);
                var record = dsProductList.getAt(index);
                var displayText = "";
                // 如果下拉列表没有被选择，那么record也就不存在，这时候，返回传进来的value，
                // 而这个value就是grid的USER_REALNAME列的value，所以直接返回
                if (record == null) {
                    //返回默认值，
                    displayText = value;
                } else {
                    displayText = record.data.ProductName; //获取record中的数据集中的process_name字段的值
                }

                return displayText;
            }
        },
        {
            id: "Unit",
            header: "单位",
            dataIndex: "Unit",
//            editable:false,
            width: 35,
            editor: UnitCombo,
            renderer: function(value, cellmeta, record, rowIndex, columnIndex, store) {
                var index = dsUnitList.findBy(function(record, id) {  
	                return record.get(UnitCombo.valueField)==value; 
                });
                var record = dsUnitList.getAt(index);
                var displayText = "";
                // 如果下拉列表没有被选择，那么record也就不存在，这时候，返回传进来的value，
                // 而这个value就是grid的USER_REALNAME列的value，所以直接返回
                if (record == null) {
                    //返回默认值，
                    displayText = value;
                } else {
                    displayText = record.data.UnitName; //获取record中的数据集中的process_name字段的值
                }
                return displayText;
            }
        }
        , {
            id: 'Specifications',
            header: "规格",
            editable:false,
            dataIndex: 'Specifications',
            width: 65//,
//            editor: productSpecCombo,
//            renderer: function(value, cellmeta, record, rowIndex, columnIndex, store) {
//                var index = dsProductSpecList.findBy(function(record, id) {  
//	                return record.get(productSpecCombo.valueField)==value; 
//                });
//                var record = dsProductSpecList.getAt(index);
//                var displayText = "";
//                // 如果下拉列表没有被选择，那么record也就不存在，这时候，返回传进来的value，
//                // 而这个value就是grid的USER_REALNAME列的value，所以直接返回
//                if (record == null) {
//                    //返回默认值，
//                    displayText = value;
//                } else {
//                    displayText = record.data.DicsName; //获取record中的数据集中的process_name字段的值
//                }
//                return displayText;
//            }
        }, {
            id: 'SaleQty',
            header: "数量",
            dataIndex: 'SaleQty',
            width: 55,
		    align: 'right',
            editor: new Ext.form.NumberField({ 
                allowBlank: false,
	            align: 'right',
                decimalPrecision:8,
                listeners: {
	                    'focus': function() {
	                        this.selectText();
	                    }
		        }})
        }, 
        {
            id: 'SalePrice',
            header: "单价",
            dataIndex: 'SalePrice',
            width: 55,
		    align: 'right',
            editor: new Ext.form.NumberField({ 
                allowBlank: false,
	            align: 'right',
                decimalPrecision:8,
                listeners: {
		                'focus': function() {
		                    this.selectText();
		            }
		        }})
        },
        {
            id: 'SaleAmt',
            header: "金额",
            dataIndex: 'SaleAmt',
            width: 80,
		    align: 'right',
            editor: new Ext.form.NumberField({ 
                allowBlank: false,
	            align: 'right',                
                listeners: {
		                'focus': function() {
		                    this.selectText();
		                }
		            },
		        decimalPrecision:8 })
        },
        {
            id: 'SaleTax',
            header: "税额",
            editable:false,
		    align: 'right',
            dataIndex: 'SaleTax',
            width: 70
        },{
            id: "ProductUse",
            header: "用途",
            dataIndex: "ProductUse",
            //editable:false,
            width: 50,
            editor: cmbProductUse,
            renderer: function(value, cellmeta, record, rowIndex, columnIndex, store) {
                if(typeof(value)=="undefined")
                {
                    return "";
                }
                var index = dsProductUse.findBy(function(record, id) {  
	                return record.get(cmbProductUse.valueField)==value; 
                });
                if(index==-1)
                    return "";
                var record1 = dsProductUse.getAt(index);
                return record1.data.CodeName
            }
        },
        new Extensive.grid.ItemDeleter()
        ]);
    cm.defaultSortable = true;

    var RowPattern = Ext.data.Record.create([
           { name: 'OrderDtlId', type: 'string' },
           { name: 'WhpId', type: 'string' },
           { name: 'ProductCode', type: 'string' },
           { name: 'ProductId', type: 'string' },
           { name: 'ProductName', type: 'string' },
           { name: 'Unit', type: 'string' },
           { name: 'Specifications', type: 'string' },
           { name: 'SaleQty', type: 'string' },
           { name: 'SalePrice', type: 'string' },
           { name: 'SaleAmt', type: 'float' },
           { name: 'SaleTax', type: 'string'},
           { name: 'Tax', type: 'string'},
           { name: 'ProductUse', type: 'string'}
          ]);

    var dsOrderProduct;
    if (dsOrderProduct == null) {
        dsOrderProduct = new Ext.data.Store
	        ({
	            url: 'frmOrderDtl.aspx?method=getDtlList',
	            reader: new Ext.data.JsonReader({
	                totalProperty: 'totalProperty',
	                root: 'root'
	            }, RowPattern)
	        });
       
    }
        
    var userGrid = new Ext.grid.EditorGridPanel({
        store: dsOrderProduct,
        cm: cm,
        selModel: new Extensive.grid.ItemDeleter(),
        layout: 'fit',
        renderTo: 'divGrid',
        width: document.body.offsetWidth,
        height: 180,
        columnLines:true,
        stripeRows: true,
        frame: true,
        //plugins: USER_ISLOCKEDColumn,
        bbar:['->',
        {
            xtype:'checkbox',
			boxLabel :'开票',
			anchor:'50%',
			name:'IsBill',
			id:'IsBill'
        },'-',{             
            text:'票号:',
            xtype: 'label',
            id:'BillLabel'
        },{
            xtype:'textfield',
			anchor:'50%',
			name:'BillNo',
			id:'BillNo'
        },
        {
            xtype:'checkbox',
			boxLabel :'收款',
			anchor:'50%',
			name:'IsPayed',
			id:'IsPayed'
        },'-',
        {             
            text:'应收金额:',
            xtype: 'label'
        },
        {             
            xtype: 'numberfield',
            format:true,
            width: 80,
	        id:'OrderTotalAmt',
	        name:'OrderTotalAmt',
	        value:0,
	        style: 'color:blue;background:white;text-align: right',
	        readOnly:true
        }],
        clicksToEdit: 1,
        viewConfig: {
            columnsText: '显示的列',
            scrollOffset: 20,
            sortAscText: '升序',
            sortDescText: '降序',
            forceFit: false
        },
        listeners:{
            afteredit: function(e){ 
                    if(e.row<e.grid.getStore().getCount()){
                        e.grid.stopEditing();
                        if(e.column < e.record.fields.getCount()-1)
                        {//最后一行操作不算
                            //alert('e.column+1');
                             e.grid.startEditing(e.row, e.column+1);
                        }
                        else
                        {
                            //alert('e.row+1')
                             e.grid.startEditing(e.row+1, 1);
                        }
                    }
                    //自动计算
                    var record = e.record;//获取被修改的行数据
                    var field = e.field;//获取被修改的列名
                    var row = e.row;//获取行号
                    var column =e.column; //获取列号                        
                    if(field=="SaleAmt")
                    {
                        record.set('SalePrice', accD(record.data.SaleAmt , record.data.SaleQty,8));
                        record.set('SaleTax', accMul(accDiv(record.data.SaleAmt,accAdd(1,record.data.Tax)) ,record.data.Tax).toFixed(2) ); //Math.Round(3.445, 1); 
                        return;
                    }
                    if(field ='SaleQty' || field=='SalePrice'){
                        record.set('SaleAmt', accMul(record.data.SaleQty , record.data.SalePrice).toFixed(2));
                        record.set('SaleTax', accMul(accDiv(record.data.SaleAmt,accAdd(1,record.data.Tax)) ,record.data.Tax).toFixed(2) ); //Math.Round(3.445, 1); 
                    }
                }                
           }
    });
    userGrid.getView().on('rowsinserted',setAllTotalAmt);
    userGrid.getView().on('rowupdated',setAllTotalAmt);
    userGrid.getView().on('rowremoved',setAllTotalAmt);
    function setAllTotalAmt(){
        var tamt = 0;
        dsOrderProduct.each(function(rec) {
            if(rec.data.SaleAmt == null && rec.data.SaleAmt == undefined)
                rec.data.SaleAmt = 0;
            tamt =accAdd(rec.data.SaleAmt,tamt);
        });
        Ext.getCmp('OrderTotalAmt').setValue(tamt);
    }
    function accAdd(arg1,arg2){  
        var r1,r2,m;  
        try{r1=arg1.toString().split(".")[1].length}catch(e){r1=0}  
        try{r2=arg2.toString().split(".")[1].length}catch(e){r2=0}  
        m=Math.pow(10,Math.max(r1,r2))  
        return (arg1*m+arg2*m)/m  
    }  
    function accDiv(arg1,arg2){  
        var t1=0,t2=0,r1,r2;  
        try{t1=arg1.toString().split(".")[1].length}catch(e){}  
        try{t2=arg2.toString().split(".")[1].length}catch(e){}  
        with(Math){  
            r1=Number(arg1.toString().replace(".",""))  
            r2=Number(arg2.toString().replace(".",""))  
            return (r1/r2)*pow(10,t2-t1);  
        }  
    } 
    userGrid.on("beforeedit",beforeEdit,userGrid);
    function beforeEdit(e)
    {
                    var record = e.record;
                    if(record.data.ProductId != dsProductUnits.baseParams.ProductId)
                    {
                        dsProductUnits.baseParams.ProductId = record.data.ProductId;
                        dsProductUnits.load();
                    }
    }
    
    function accD(arg1,arg2,pos)
    {
        //Math.round(src*Math.pow(10, pos))/Math.pow(10, pos);
        //解决浮点问题
        m = 0;
        s1=arg1.toString();
        s2=arg2.toString();
        try{m+=s1.split(".")[1].length}catch(e){}
        try{m-=s2.split(".")[1].length}catch(e){}
        var num = Number(s1.replace(".",""))/Number(s2.replace(".",""))/Math.pow(10,m);
        return Math.round(num * Math.pow(10,pos))/Math.pow(10,pos);
    }
    function accMul(arg1,arg2)
    {//解决浮点问题
        var m=0,s1=arg1.toString(),s2=arg2.toString();
        try{m+=s1.split(".")[1].length}catch(e){}
        try{m+=s2.split(".")[1].length}catch(e){}
        return Number(s1.replace(".",""))*Number(s2.replace(".",""))/Math.pow(10,m)
    }
    /*------开始界面数据的函数 Start---------------*/
    function setFormValue() {
        Ext.Ajax.request({
            url: 'frmOrderMst.aspx?method=getOrder',
            params: {
                orderid: OrderId,
                limit:1,
                start:0
            },
            success: function(resp, opts) {           
                var data = Ext.util.JSON.decode(resp.responseText);
                        Ext.getCmp("OrgId").setValue(data.OrgId);
		                Ext.getCmp("SaleDept").setValue(data.DeptId);
		                Ext.getCmp("OutStor").setValue(data.OutStor);
		                
//		                var curWhId = Ext.getCmp("OutStor").getValue();
                        if(dsWarehousePosList.baseParams.WhId!=data.OutStor)
                        {
                            haveEvent = true;
                            dsWarehousePosList.baseParams.WhId=data.OutStor;
                            dsWarehousePosList.on('load',loadOrderProduct,this,true);
                            dsWarehousePosList.load();
                            //dsWarehousePosList.un('load',loadOrderProduct,this,true);
                        }
                        else
                        {
                            loadOrderProduct();
                        }
//		                if(dsWarehousePosList.baseParams.WhId!=data.OutStore)
//		                {
//		                    dsWarehousePosList.baseParams.WhId=data.OutStore;
//		                    dsWarehousePosList.load();
//		                }
                        //var curWhId = Ext.getCmp("OutStor").getValue();
//                        if(dsWarehousePosList.baseParams.WhId!=curWhId)
//                        {
//                            dsWarehousePosList.baseParams.WhId=curWhId;
//                            dsWarehousePosList.load();
//                        }
//                         Ext.Ajax.request({
//		                    url:"frmPOSOrderEdit.aspx?method=getWarehousePosList",
//		                    method: 'POST',
//                            params: {
//                                WhId: curWhId
//                            },
//		                    success:function(response,option){
//		                        if(response.responseText=="")
//		                        {                    
//			                        return;                 
//		                        }
//		                        dsWarehousePosList.data = eval(response.responseText); 
//		                    }});
		
		                Ext.getCmp("CustomerId").setValue(data.CustomerId);
		                Ext.getCmp("cusno").setValue(data.CustomerNo);
		                Ext.getCmp("cusname").setValue(data.CustomerName);
		                Ext.getCmp("mobile").setValue(data.LinkTel);
		                Ext.getCmp("person").setValue(data.LinkMan);
		                Ext.getCmp("cusadd").setValue(data.Address);
		                if(data.DlvDate!=undefined && data.DlvDate!='')
		                {
		                    Ext.getCmp("DlvDate").setValue(new Date(data.DlvDate.replace(/-/g, "/")));
		                }
		                Ext.getCmp("DlvAdd").setValue(data.DlvAdd);
//		                Ext.getCmp("OrderType").setValue(data.OrderType);
		                Ext.getCmp("PayType").setValue(data.PayType);
		                Ext.getCmp("BillMode").setValue(data.BillMode);
		                Ext.getCmp("DlvType").setValue(data.DlvType);
		                Ext.getCmp("DlvLevel").setValue(data.DlvLevel);
                        Ext.getCmp("OrderTotalAmt").setValue(data.SaleTotalAmt);
		                Ext.getCmp("IsPayed1").setValue(data.IsPayed);
//		                Ext.getCmp("IsBill").setValue(data.IsBill);
		                Ext.getCmp("IsBill1").setValue(data.IsBill);
		                Ext.getCmp("Remark").setValue(data.Remark);		  
		                Ext.getCmp("DlvDesc").setValue(data.DlvDesc);	  
		                Ext.getCmp("CreateDate").setValue((new Date(data.CreateDate.replace(/-/g, "/"))));
		                Ext.getCmp("Status").setValue(data.Status);
		                Ext.getCmp("SaleInvId").setValue(data.SaleInvId);
		                Ext.getCmp("OutedQty").setValue(data.OutedQty);
		                Ext.getCmp("IsActive").setValue(data.IsActive);
		                if(data.Ext1=="0")
		                {
		                    Ext.getCmp("DriverId").setValue("");
		                }
		                else
		                {
		                    Ext.getCmp("DriverId").setValue(data.Ext1);
		                }
		                //商品列表
                        dsProductList.baseParams.CustomerId = data.CustomerId;
                        dsProductList.load();

            },
            failure: function(resp, opts) {
                Ext.Msg.alert("提示", "获取初始化仓库信息失败！");
            }
        });
    }
    /*------开始界面数据的函数 End---------------*/
    //-------------------Grid End-------------------------------
    inserNewBlankRow(); //Grid默认初始行
    /*----------------footerframe----------------*/
    //将grid明细记录组装成json串提交到UI再decode
    var json = '';
    var footerForm = new Ext.FormPanel({
        renderTo: 'divBotton',
        //border: true, // 没有边框
        //labelAlign: 'left',
        buttonAlign: 'center',
        bodyStyle: 'padding:1px',
        //height: 20,
        frame: true,
        //labelWidth: 55,        
        buttons: [{
            text: "保存",
            scope: this,
            id: 'saveButton',
            handler: function() { 
                var whbm = Ext.getCmp('OutStor').getValue();
                if(whbm==undefined||whbm==null||whbm==""||whbm==0)
                {
                    Ext.Msg.alert("提示", "请指定出库仓库！");
                    return;
                }
                  
                json = "";
                for(var i=0;i<dsOrderProduct.getCount();i++)
                {
                    var checkData = dsOrderProduct.getAt(i);
                    if(checkData.data.ProductId!='')
                    {
                        if(checkData.data.WhpId=='')
                        {
                            Ext.Msg.alert("提示","请选择仓位信息");
                            return;
                        }
                    }
                }
                dsOrderProduct.each(function(dsOrderProduct) {                
                    json += Ext.util.JSON.encode(dsOrderProduct.data) + ',';
                });
                json = json.substring(0, json.length - 1);
                
                if (dsOrderProduct.getCount() <= 1)
                {
                     Ext.Msg.alert("提示", "请选择订购的商品！");
                     return;
                }
                if(Ext.getCmp('CustomerId').getValue()=='') 
                {
                     Ext.Msg.alert("提示", "客户信息错误，请选择正确客户！");
                     return;
                }
                var isPayed = 0;
                if(!Ext.getCmp("IsPayed").hidden)
                {
                    if(Ext.getCmp("IsPayed").getValue()==true)
                    {
                        isPayed =1;
                    }
                }
                if(Ext.getCmp("IsPayed1").getValue()=="1")
                {
                    isPayed =1;
                }
                var isBill = 0;
                if(!Ext.getCmp("IsBill").hidden)
                {
                    if(Ext.getCmp("IsBill").getValue()==true)
                    {
                        isBill =1;
                    }
                }
                if(Ext.getCmp("IsBill1").getValue()=="1")
                {
                    isBill =1;
                }
                Ext.MessageBox.wait("数据正在保存，请稍候……");
                //然后传入参数保存
                Ext.Ajax.request({
                    url: 'frmPOSOrderEdit.aspx?method=saveOrder',
                    method: 'POST',
                    params: {
                        //主参数
                        OrderId:Ext.getCmp('OrderId').getValue(),
		                OrgId:Ext.getCmp('OrgId').getValue(),
		                DeptId:Ext.getCmp('SaleDept').getValue(),
		                OutStor:Ext.getCmp('OutStor').getValue(),
		                CustomerId:Ext.getCmp('CustomerId').getValue(),
		                DlvDate:Ext.getCmp('DlvDate').getValue().dateFormat('Y/m/d'),
		                DlvAdd:Ext.getCmp('DlvAdd').getValue(),
		                DlvDesc:Ext.getCmp('DlvDesc').getValue(),
		                OrderType:'S011',
		                PayType:Ext.getCmp('PayType').getValue(),
		                BillMode:Ext.getCmp('BillMode').getValue(),
		                DlvType:Ext.getCmp('DlvType').getValue(),
		                DlvLevel:Ext.getCmp('DlvLevel').getValue(),
		                Status:1,
		                IsPayed:isPayed,//Ext.getCmp('IsPayed').getValue(),
		                IsBill:isBill,//Ext.getCmp('IsBill').getValue(),		
		                Remark:Ext.getCmp('Remark').getValue()	,
		                OutedQty:Ext.getCmp('OutedQty').getValue(),
		                SaleInvId:Ext.getCmp('SaleInvId').getValue(),
		                IsActive:1,
			            Ext1:Ext.getCmp('DriverId').getValue(),
			            BillNo:Ext.getCmp('BillNo').getValue(),
                        //明细参数
                        DetailInfo: json
                    },
                    success: function(resp,opts){ 
                    Ext.MessageBox.hide();
                                    if( checkParentExtMessage(resp,parent) )
                                         {                                           
                                           parent.OrderMstGridData.reload();
                                           parent.uploadOrderWindow.hide(); 
                                         }
                                   },
		            failure: function(resp,opts){  Ext.Msg.alert("提示","保存失败");     }

               
                });
                //
            }
        },
                         {
                             text: "取消",
                             scope: this,
                             handler: function() {
                                 parent.uploadOrderWindow.hide();
                             }
}]
    });
    
    
    
    
    if (OperType == "query")
    {
      Ext.getCmp("saveButton").hide();
    }

this.setFormValues=function(){
        Ext.getCmp("OrderId").setValue(OrderId);
        if (OrderId == 0) {    
            Ext.getCmp("IsPayed").setVisible(true);
            Ext.getCmp("IsBill").setVisible(true);
            Ext.getCmp("BillLabel").setVisible(true);
            Ext.getCmp("BillNo").setVisible(true);
            Ext.getCmp("BillNo").setValue("");
            Ext.getCmp("cusno").setDisabled(false);
            Ext.getCmp("DlvDate").setValue( (new Date()).clearTime() );
            Ext.getCmp("PayType").setValue('S021');
            Ext.getCmp("BillMode").setValue("S031");
            Ext.getCmp("DlvType").setValue("S041");
            Ext.getCmp("DlvLevel").setValue("S051");
            Ext.getCmp("IsPayed").setValue(0);
            Ext.getCmp("IsBill").setValue(0);
            Ext.getCmp("IsPayed1").setValue(0);
            Ext.getCmp("IsBill1").setValue(0);
            Ext.getCmp("Status").setValue(1);
            Ext.getCmp("IsActive").setValue(1);
            Ext.getCmp("CreateDate").setValue((new Date()).clearTime());
            
            Ext.getCmp("DlvAdd").setValue("");
            Ext.getCmp("Remark").setValue("");
            Ext.getCmp("DlvDesc").setValue("");
            
            Ext.getCmp("CustomerId").setValue("");
            Ext.getCmp("cusno").setValue("");;
            Ext.getCmp("cusname").setValue("");
            Ext.getCmp("mobile").setValue("");
            Ext.getCmp("person").setValue("");
            Ext.getCmp("cusadd").setValue("");
            
            if(dsProductList!=null)
            {
                dsOrderProduct.removeAll();
//                var orderProduct = new dsOrderProduct.recordType({SaleQty:0});
//                dsOrderProduct.add(orderProduct);
                inserNewBlankRow();
            }
        }    
        if (OrderId > 0) {
            Ext.getCmp("IsPayed").setVisible(false);
            Ext.getCmp("IsBill").setVisible(false);
            Ext.getCmp("BillLabel").setVisible(false);
            Ext.getCmp("BillNo").setVisible(false);
            setFormValue();
            Ext.getCmp("cusno").setDisabled(true);           
            
        }
    }
    var haveEvent = false;
    function loadOrderProduct()
    {
        if(haveEvent)
        {
            haveEvent = false;
            dsWarehousePosList.un('load',loadOrderProduct,this,true);
        }
        dsOrderProduct.load({
                params: { 
                    start: 0,
                    limit: 100,
                    OrderId: OrderId
                },
                callback: function(r, options, success) {
                    if (success == true) {
                        inserNewBlankRow();
                        }
                    }
                
            });
    }
    setFormValues();
    
    Ext.getCmp('OrgId').setValue(<% =ZJSIG.UIProcess.ADM.UIAdmUser.OrgID(this)%>);
    Ext.getCmp('OrgId').setDisabled(true);
    Ext.getCmp('SaleDept').setValue(<% =ZJSIG.UIProcess.ADM.UIAdmUser.DeptID(this)%>);
    Ext.getCmp('SaleDept').setDisabled(true);
    
})

</script>
</html>
<script type="text/javascript" src="../js/SelectModule.js"></script>

