<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmCustomerBillEdit.aspx.cs" Inherits="SCM_frmCustomerBillEdit" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html>
<head>
<title>发票维护</title><meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<link rel="stylesheet" type="text/css" href="../ext3/resources/css/ext-all.css" />
<link rel="stylesheet" type="text/css" href="../Theme/1/css/salt.css" />
<script type="text/javascript" src="../ext3/adapter/ext/ext-base.js"></script>
<script type="text/javascript" src="../ext3/ext-all.js"></script>
<script type="text/javascript" src="../ext3/example/ItemDeleter.js"></script>
<script type="text/javascript" src="../js/operateResp.js"></script>
<script type="text/javascript" src="../js/EmpSelect.js"></script>
<script type="text/javascript" src="../ext3/src/locale/ext-lang-zh_CN.js"></script>
<script type="text/javascript" src="../js/floatUtil.js"></script>
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
<div id='divEnd'></div>
<div id='divBotton'></div>
</body>
<%=getComboBoxStore() %>
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
    var strCustomerid = args["strCustomerid"];//客户ID
//    var strCustomername = unescape(args["strCustomername"]); 
//    var kpfs = args["kpfs"];//开票方式
//    var strOrderId = args["strOrderId"];//订单号串，用,分隔
//    var OrderIdArray = strOrderId.split(",");//订单数组
//    var billtype = args["billtype"];//蓝字发票=1 红字发票=2
//    if (billtype == null)
      var billtype = 1;//默认为蓝字
    


    Ext.onReady(function() {  
    
        Ext.form.TextField.prototype.afterRender = Ext.form.TextField.prototype.afterRender.createSequence(function() {
         this.relayEvents(this.el, ['onblur']);
        });
        
        

        //发票主项
        var addWinSerchform = new Ext.FormPanel({
                     renderTo: 'divForm',
                    labelAlign: 'left',
                    buttonAlign: 'right',
                    bodyStyle: 'padding:5px',
                    frame: true,
                    labelWidth: 55,
	                items:[
	                {
		                layout:'column',
		                border: false,
		                labelSeparator: '：',
		                items: [
		                     {
			                        layout:'form',
			                        border: false,
			                        columnWidth:0.3,
			                        items: [
				                        {
					                        cls: 'key',
                                           xtype: 'textfield',
                                           fieldLabel: '发票代码',
                                           name: 'billcode',
                                           id: 'billcode',
                                           anchor: '98%'
				                        }
		                                    ]
		                        },
		                        {
			                        layout:'form',
			                        border: false,
			                        columnWidth:0.3,
			                        items: [
				                        {
					                        cls: 'key',
                                           xtype: 'textfield',
                                           fieldLabel: '发票号码',
                                           name: 'billno',
                                           id: 'billno',
                                           anchor: '98%'
				                        }
		                                    ]
		                        }
                             , {
		                            layout:'form',
		                            border: false,
		                            columnWidth:0.4,
		                            items: [
			                            {
				                            xtype:'datefield',
				                            fieldLabel:'日期',
				                            columnWidth:0.3,
				                            anchor:'90%',
				                            name:'createdate',
				                            id:'createdate',
				                            value:new Date().clearTime(),
				                            format:'Y年m月d日'
			                            }
	                                       ]
	                            }
	                        ] },		                
		            {
		                layout:'column',
		                border: false,
		                labelSeparator: '：',
		                items: [
		                {
			                layout:'form',
			                border: false,
			                columnWidth:.6,
			                items: [
				                {
					                cls: 'key',
                                   xtype: 'textfield',
                                   fieldLabel: '客户',
                                   name: 'customername',
                                   id: 'customername',
                                   anchor: '98%'
				                },
				                {
					                cls: 'key',
                                   xtype: 'hidden',
                                   fieldLabel: '客户',
                                   name: 'customerid',
                                   id: 'customerid',
                                   hideLabel:true,
                                   anchor: '98%'
				                }
		                            ]
		                },{
			                layout:'form',
			                border: false,
			                columnWidth:.34,
			                items: [
				                {
					                cls: 'key',
                                   xtype: 'textfield',
                                   fieldLabel: '金额',
                                   name: 'totalAmt',
                                   id: 'totalAmt',
                                   anchor: '98%'
				                }
		                            ]
		                }
		                    ]
		               }                 
                
	                            
                ]});
            
          //开票商品项
          var BillProductGridData = new Ext.data.Store
            ({
                url: 'frmCustomerBillEdit.aspx?method=getSumOrderList',
                reader: new Ext.data.JsonReader({
                    totalProperty: 'totalProperty',
                    root: 'root'
                }, [
                    { name:'OrderNumber'},
                    {  name:'ProductId' },
                    {  name:'ProductNo' },
                    {  name:'ProductName' },
                    {  name:'Unit' },
                    {  name:'UnitName' },
                    {  name:'Specifications' },
                    {  name:'SpecificationsName' },
                    {  name:'SaleQty' },
                    {  name:'SalePrice' },
                    {  name:'SaleAmt'},
                    {  name:'SaleTax' },
                    {  name:'TaxRate' },
                    {  name:'DiscountAmt' },
                    { name:'NoBillQty'}
              	])
              	 ,
                listeners:
	            {
	                scope: this,
	                load: function() {
	                }
	            }
            });
            

             var sm = new Ext.grid.CheckboxSelectionModel({
                singleSelect: false
            });
            var BillProductGrid = new Ext.grid.EditorGridPanel({
                 renderTo: 'divGrid',
                autoScroll: true, 
                height:200,
                id: '',
                store: BillProductGridData,
                loadMask: { msg: '正在加载数据，请稍侯……' },
                sm: sm,
                cm: new Ext.grid.ColumnModel([                            
                sm,
                new Ext.grid.RowNumberer(),//自动行号
                {
                    header:'订单号',
                    dataIndex:'OrderNumber',
                    width:120,
                    id:'OrderNumber'
                },
                {
                    header:'代码',
                    dataIndex:'ProductNo',
                    width:80,
                    id:'ProductNo'
                },
                {
                    header:'名称',
                    dataIndex:'ProductName',
                    width:200,
                    id:'ProductName'
                },
                {
                    header:'单位',
                    dataIndex:'UnitName',
                    width:60,
                    id:'UnitName'
                },                
                {
                    header:'数量',
                    dataIndex:'SaleQty',
                    width:80,
                    id:'SaleQty'         
                },
                {
                    header:'开票数量',
                    dataIndex:'NoBillQty',
                    width:80,
                    editor:new Ext.form.NumberField({ 
	                        allowBlank: false,
	                        align: 'right',
	                        decimalPrecision:6,
	                        listeners: {  
    	                        'focus':function(){  
        		                    this.selectText();
        		                    selectRecord = BillProductGrid.getSelectionModel().getSelected(); 
    	                        },
        	                     'change': function(oppt){
        	                        var record = selectRecord;
        	                         record.set("SaleAmt",accMul(record.data.NoBillQty,record.data.SalePrice));
//        	                        record.set('SaleAmt', accMul(oppt.value , accAdd(record.data.SalePrice,record.data.TransFee)).toFixed(2));
                                    record.set('SaleTax', accMul(accDiv(record.data.SaleAmt,accAdd(1,record.data.TaxRate)) ,record.data.TaxRate).toFixed(2) ); //Math.Round(3.445, 1); 
//                                    selectRecord = null;
        	                    }   
		                    }
		                }),
                    id:'BillQty'         
                },
                
                {
                    header:'单价',
                    dataIndex:'SalePrice',
                    width:80,
                    id:'SalePrice'         
                },
                {
                    header:'金额',
                    dataIndex:'SaleAmt',
                    width:80,
                    id:'SaleAmt'         
                },
                {
                    header:'折扣',
                    dataIndex:'DiscountAmt',
                    width:80,
                    id:'DiscountAmt'         
                },
                {
                    header:'税率',
                    dataIndex:'TaxRate',
                    width:80,
                    id: 'TaxRate'
                }, {
                    header:'税额',
                    dataIndex:'SaleTax',
                    width:80,
                    id:'SaleTax'         
                }
                		]),
                
                viewConfig: {
                    columnsText: '显示的列',
                    scrollOffset: 20,
                    sortAscText: '升序',
                    sortDescText: '降序',
                    forceFit: true
                }
            });
            
//双击开所有的数量
BillProductGrid.on('rowdblclick', function(grid, rowIndex, e) {
                            //弹出商品明细
                            var record = BillProductGrid.getStore().getAt(rowIndex);//.data.OrderId;
                            if(record.data.NoBillQty == record.data.SaleQty)
                            {
                                record.set("NoBillQty",0);
                                record.set("SaleAmt",0);
                            }
                            else
                            {
                                record.set("NoBillQty",record.data.SaleQty);
                                record.set("SaleAmt",accMul(record.data.NoBillQty,record.data.SalePrice));
                            }
                           

                        });

            /*------DataGrid的函数结束 End---------------*/
         
                        
        var dtlForm = new Ext.FormPanel({
            renderTo: 'divEnd',
            labelAlign: 'left',
            buttonAlign: 'right',
            bodyStyle: 'padding:5px',
            frame: true,
            labelWidth: 55,
            items:[
            {
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
	                       xtype:'textfield',
					        fieldLabel:'开票人',
					        anchor:'98%',
					        name:'createname',
					        id:'createname'
	                    },
	                    {
	                       xtype:'hidden',
					        fieldLabel:'开票人',
					        anchor:'98%',
					        hideLabel:true,
					        name:'createid',
					        id:'createid'
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
                            fieldLabel:'收款人',
                            anchor:'98%',
                            name:'payname',
                            id:'payname'
	                    },
	                    {
		                   xtype:'hidden',
                            fieldLabel:'收款人',
                            anchor:'98%',
                            hideLabel:true,
                            name:'payid',
                            id:'payid'
	                    }
                            ]
                }
                ,{
                    layout:'form',
                    border: false,
                    columnWidth:0.33,
                    items: [
	                    {
		                   xtype:'textfield',
                            fieldLabel:'复核人',
                            anchor:'98%',
                            name:'checkname',
                            id:'checkname'
	                    },
	                    {
		                   xtype:'hidden',
                            fieldLabel:'复核人',
                            anchor:'98%',
                            hideLabel:true,
                            name:'checkid',
                            id:'checkid'
	                    }
                           ]
                } ]
               }]
              });
              
              
      var footerForm = new Ext.FormPanel({
        renderTo: 'divBotton',
        border: true, // 没有边框
        labelAlign: 'left',
        buttonAlign: 'center',
        bodyStyle: 'padding:1px',
        height: 25,
        frame: true,
        labelWidth: 55,        
        buttons: [{
            text: "保存",
            scope: this,
            id: 'saveButton',
            handler: function() { 
            
              Ext.MessageBox.wait("数据正在保存，请稍候……");
              
              var strMethod="saveAdd";   //蓝字发票保存          
              if (billtype == 2)//红字
                  strMethod="saveRed";              
              
              Ext.Ajax.request({
	            url:'frmBillEdit.aspx?method='+strMethod,
	            method:'POST',
	            params:{
                    strOrderID:strOrderId,
                    strBillcode:Ext.getCmp('billcode').getValue(),
                    strBillno:Ext.getCmp('billno').getValue(),
                    strBizdate:Ext.util.Format.date(Ext.getCmp('createdate').getValue(),'Y/m/d'),
                    strCreateid:Ext.getCmp('createid').getValue(),
                    strPayid:Ext.getCmp('payid').getValue(),
                    strCheckid:Ext.getCmp('checkid').getValue(),
                    strCustomerid:Ext.getCmp('customerid').getValue(),
                    strCustomername:Ext.getCmp('customername').getValue(),
                    kpfs:kpfs,
                    billtype:billtype//红字蓝字
                   },
                   success: function(resp,opts){ 
                        Ext.MessageBox.hide();
                        if ( checkExtMessage(resp) ) 
                            parent.openBillWindow.hide();                        
                    },
	               failure: function(resp,opts){  
	                    Ext.MessageBox.hide();
	                    Ext.Msg.alert("提示","保存失败");     
	               }	
	            }); 
	            
	         }
        },
         {
             text: "取消",
             scope: this,
             handler: function() { parent.openBillWindow.hide(); }
         }]
      });
      

     
        //开票人
        Ext.getCmp("createname").on("focus",selectEmp);      
        //收款人
        Ext.getCmp("payname").on("focus",selectEmp);        
        //复核人
        Ext.getCmp("checkname").on("focus",selectEmp);
        
        var current="";
        function selectEmp(v)
        {
            current = v.id;
            if(selectEmpForm==null)
            {
                showEmpForm(0,'员工选择','../ba/sysadmin/frmAdmAuthorize.aspx?method=gettreecolumnlist');
                selectEmpTree.on('checkchange', treeCheckChange, selectEmpTree);
                Ext.getCmp("btnOk").on("click",selectOK);        
            }
            else
            {
                showEmpForm(0,'员工选择','../ba/sysadmin/frmAdmAuthorize.aspx?method=gettreecolumnlist');
            }
        }

        function treeCheckChange(node,checked)
            {
                selectEmpTree.un('checkchange', treeCheckChange, selectEmpTree);
                if(checked)
                {
                    var selectNodes = selectEmpTree.getChecked();
                    for (var i = 0; i < selectNodes.length; i++) {
                        if(selectNodes[i].id !=node.id)
                        {
                            selectNodes[i].ui.toggleCheck(false);
                            selectNodes[i].attributes.checked = false;
                        }
                    }
                }
                selectEmpTree.on('checkchange', treeCheckChange, selectEmpTree);
            }

        function selectOK()
        {
            var selectNodes = selectEmpTree.getChecked();
            if(selectNodes.length>0)
            {
                switch(current)
                {
                    case"createname":
                        Ext.getCmp("createname").setValue(selectNodes[0].text);
                        Ext.getCmp("createid").setValue(selectNodes[0].id);
                        break;
                    case"payname":
                        Ext.getCmp("payname").setValue(selectNodes[0].text);
                        Ext.getCmp("payid").setValue(selectNodes[0].id);
                        break;
                    case"checkname":
                        Ext.getCmp("checkname").setValue(selectNodes[0].text);
                        Ext.getCmp("checkid").setValue(selectNodes[0].id);
                        break;
                }
                
            }
        }
        
                 
            
                 
      BillProductGridData.load({
            params: { 
                CustomerId:strCustomerid
            }
       });
       
       
    Ext.getCmp('billcode').setValue("");
    Ext.getCmp('billno').setValue("");
    Ext.getCmp('customername').setValue(strCustomerName);
    Ext.getCmp('customerid').setValue(strCustomerid);

    Ext.getCmp('createid').setValue(curUserId);
    Ext.getCmp('payid').setValue(curUserId);
    Ext.getCmp('checkid').setValue(curUserId);
    Ext.getCmp('createname').setValue(curUserName);
    Ext.getCmp('payname').setValue(curUserName);
    Ext.getCmp('checkname').setValue(curUserName);

    
})

</script>
</html>

<script type="text/javascript" src="../js/SelectModule.js"></script>