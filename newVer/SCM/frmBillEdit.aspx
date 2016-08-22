<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmBillEdit.aspx.cs" Inherits="SCM_frmBillEdit" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html>
<head>
<title>��Ʊά��</title><meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<link rel="stylesheet" type="text/css" href="../ext3/resources/css/ext-all.css" />
<link rel="stylesheet" type="text/css" href="../Theme/1/css/salt.css" />
<script type="text/javascript" src="../ext3/adapter/ext/ext-base.js"></script>
<script type="text/javascript" src="../ext3/ext-all.js"></script>
<script type="text/javascript" src="../ext3/example/ItemDeleter.js"></script>
<script type="text/javascript" src="../js/operateResp.js"></script>
<script type="text/javascript" src="../js/EmpSelect.js"></script>
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
<div id='divEnd'></div>
<div id='divBotton'></div>
</body>
<%=getComboBoxStore() %>
<script type="text/javascript">
    
Ext.BLANK_IMAGE_URL = "../ext3/resources/images/default/s.gif";
    function GetUrlParms() {
        var args = new Object();
        var query = location.search.substring(1); //��ȡ��ѯ��   
        var pairs = query.split("&"); //�ڶ��Ŵ��Ͽ�   
        for (var i = 0; i < pairs.length; i++) {
            var pos = pairs[i].indexOf('='); //����name=value   
            if (pos == -1) continue; //���û���ҵ�������   
            var argname = pairs[i].substring(0, pos); //��ȡname   
            var value = pairs[i].substring(pos + 1); //��ȡvalue   
            args[argname] = unescape(value); //��Ϊ����   
        }
        return args;
    }
    
    var args = new Object();
    args = GetUrlParms();
    var strCustomerid = args["strCustomerid"];//�ͻ�ID
    var strCustomername = unescape(args["strCustomername"]); 
    var kpfs = args["kpfs"];//��Ʊ��ʽ
    var strOrderId = args["strOrderId"];//�����Ŵ�����,�ָ�
    var OrderIdArray = strOrderId.split(",");//��������
    var billtype = args["billtype"];//���ַ�Ʊ=1 ���ַ�Ʊ=2
    if (billtype == null)
       billtype = 1;//Ĭ��Ϊ����
        
    Ext.onReady(function() {  
    
        Ext.form.TextField.prototype.afterRender = Ext.form.TextField.prototype.afterRender.createSequence(function() {
         this.relayEvents(this.el, ['onblur']);
        });
        
        
        var  serverDate = '<%=server_date %>';
        var serverD=new Date(Date.parse(serverDate.replace(/-/g, "/")));

        //��Ʊ����
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
		                labelSeparator: '��',
		                items: [
		                     {
			                        layout:'form',
			                        border: false,
			                        columnWidth:0.3,
			                        items: [
				                        {
					                        cls: 'key',
                                           xtype: 'textfield',
                                           fieldLabel: '��Ʊ����',
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
                                           fieldLabel: '��Ʊ����',
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
				                            fieldLabel:'����',
				                            columnWidth:0.3,
				                            anchor:'90%',
				                            name:'createdate',
				                            id:'createdate',
				                            value:serverD.clearTime(),
				                            format:'Y��m��d��'			                            
			                            }
	                                       ]
	                            }
	                        ] },		                
		            {
		                layout:'column',
		                border: false,
		                labelSeparator: '��',
		                items: [
		                {
			                layout:'form',
			                border: false,
			                columnWidth:1,
			                items: [
			                {
				                cls: 'key',
                               xtype: 'textfield',
                               fieldLabel: '�ͻ�',
                               name: 'customername',
                               id: 'customername',
                               anchor: '98%'
			                },
			                {
				                cls: 'key',
                               xtype: 'hidden',
                               fieldLabel: '�ͻ�',
                               name: 'customerid',
                               id: 'customerid',
                               hideLabel:true,
                               anchor: '98%'
			                }]
			            }]
			        },{
		                layout:'column',
		                border: false,
		                labelSeparator: '��',
		                items: [
		                {
			                layout:'form',
			                border: false,
			                columnWidth:1,
			                items: [
			                {
				                cls: 'key',
                               xtype: 'textfield',
                               fieldLabel: '��ע',
                               name: 'remark',
                               id: 'remark',
                               anchor: '98%'
			                }]
			            }]
			        }
	                            
                ]});
            
          //��Ʊ��Ʒ��
          var BillProductGridData = new Ext.data.Store
            ({
                url: 'frmBillEdit.aspx?method=getSumOrderList',
                reader: new Ext.data.JsonReader({
                    totalProperty: 'totalProperty',
                    root: 'root'
                }, [
                    {  name:'ProductId' },
                    {  name:'ProductCode' },
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
                    {  name:'DiscountAmt' }
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
            var BillProductGrid = new Ext.grid.GridPanel({
                 renderTo: 'divGrid',
                autoScroll: true, 
                height:200,
                id: '',
                store: BillProductGridData,
                loadMask: { msg: '���ڼ������ݣ����Ժ��' },
                sm: sm,
                cm: new Ext.grid.ColumnModel([                            
                sm,
                new Ext.grid.RowNumberer(),//�Զ��к�
                {
                    header:'��Ʒ����',
                    dataIndex:'ProductCode',
                    id:'ProductCode'
                },
                {
                    header:'����',
                    dataIndex:'ProductName',
                    id:'ProductName'
                },
                {
                    header:'��λ',
                    dataIndex:'UnitName',
                    id:'UnitName'
                },
                {
                    header:'���',
                    dataIndex:'SpecificationsName',
                    id:'SpecificationsName'
                },
                {
                    header:'����',
                    dataIndex:'SaleQty',
                    id:'SaleQty'         
                },
                {
                    header:'����',
                    dataIndex:'SalePrice',
                    id:'SalePrice'         
                },
                {
                    header:'���',
                    dataIndex:'SaleAmt',
                    id:'SaleAmt'         
                },
                {
                    header:'�ۿ�',
                    dataIndex:'DiscountAmt',
                    id:'DiscountAmt'         
                },
                {
                    header:'˰��',
                    dataIndex:'TaxRate',
                    id: 'TaxRate'
                }, {
                    header:'˰��',
                    dataIndex:'SaleTax',
                    id:'SaleTax'         
                }
                		]),
                
                viewConfig: {
                    columnsText: '��ʾ����',
                    scrollOffset: 20,
                    sortAscText: '����',
                    sortDescText: '����',
                    forceFit: true
                }
            });
            
        

            /*------DataGrid�ĺ������� End---------------*/
                
                        
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
                labelSeparator: '��',
                items: [
                {
                    layout:'form',
                    border: false,
                    columnWidth:0.33,
                    items: [
	                    {
	                       xtype:'textfield',
					        fieldLabel:'��Ʊ��',
					        anchor:'98%',
					        name:'createname',
					        id:'createname'
	                    },
	                    {
	                       xtype:'hidden',
					        fieldLabel:'��Ʊ��',
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
                            fieldLabel:'�տ���',
                            anchor:'98%',
                            name:'payname',
                            id:'payname'
	                    },
	                    {
		                   xtype:'hidden',
                            fieldLabel:'�տ���',
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
                            fieldLabel:'������',
                            anchor:'98%',
                            name:'checkname',
                            id:'checkname'
	                    },
	                    {
		                   xtype:'hidden',
                            fieldLabel:'������',
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
        border: true, // û�б߿�
        labelAlign: 'left',
        buttonAlign: 'center',
        bodyStyle: 'padding:1px',
        height: 25,
        frame: true,
        labelWidth: 55,        
        buttons: [{
            text: "����",
            scope: this,
            id: 'saveButton',
            handler: function() { 
            
              Ext.MessageBox.wait("�������ڱ��棬���Ժ򡭡�");
              
              var strMethod="saveAdd";   //���ַ�Ʊ����          
              if (billtype == 2)//����
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
                    remark: Ext.getCmp('remark').getValue(),
                    billtype:billtype//��������
                   },
                   success: function(resp,opts){ 
                        Ext.MessageBox.hide();
                        if ( checkParentExtMessage(resp,parent) ) 
                            parent.openBillWindow.hide();                        
                    },
	               failure: function(resp,opts){  
	                    Ext.MessageBox.hide();
	                    Ext.Msg.alert("��ʾ","����ʧ��");     
	               }	
	            }); 
	            
	         }
        },
         {
             text: "ȡ��",
             scope: this,
             handler: function() { parent.openBillWindow.hide(); }
         }]
      });
      

     
        //��Ʊ��
        Ext.getCmp("createname").on("focus",selectEmp);      
        //�տ���
        Ext.getCmp("payname").on("focus",selectEmp);        
        //������
        Ext.getCmp("checkname").on("focus",selectEmp);
        
        var current="";
        function selectEmp(v)
        {
            current = v.id;
            if(selectEmpForm==null)
            {
                showEmpForm(0,'Ա��ѡ��','../ba/sysadmin/frmAdmAuthorize.aspx?method=gettreecolumnlist');
                selectEmpTree.on('checkchange', treeCheckChange, selectEmpTree);
                Ext.getCmp("btnOk").on("click",selectOK);        
            }
            else
            {
                showEmpForm(0,'Ա��ѡ��','../ba/sysadmin/frmAdmAuthorize.aspx?method=gettreecolumnlist');
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
                OrderId: strOrderId,
                billtype:billtype//��������
            }
       });
       
       
    Ext.getCmp('billcode').setValue("");
    Ext.getCmp('billno').setValue("");
    Ext.getCmp('customername').setValue(strCustomername);
    Ext.getCmp('customerid').setValue(strCustomerid);

    Ext.getCmp('createid').setValue(curUserId);
    Ext.getCmp('payid').setValue(curUserId);
    Ext.getCmp('checkid').setValue(curUserId);
    Ext.getCmp('createname').setValue(curUserName);
    Ext.getCmp('payname').setValue(curUserName);
    Ext.getCmp('checkname').setValue(curUserName);

    if(billtype==2){
        Ext.getCmp('remark').setValue('���ߺ�����ֵ˰ר�÷�Ʊ֪ͨ����xxxxxxxxxxxxxxxx');
    }else{
        Ext.getCmp('remark').getEl().up('.x-form-item').setDisplayed(false); 
    }
})

</script>
</html>

<script type="text/javascript" src="../js/SelectModule.js"></script>