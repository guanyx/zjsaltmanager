<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmCrmContractPay.aspx.cs"
    Inherits="CRM_Contract_frmCrmContractPay" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
    <title>��ͬ�������</title>
    <meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
    <link rel="stylesheet" type="text/css" href="../../ext3/resources/css/ext-all.css" />

    <script type="text/javascript" src="../../ext3/adapter/ext/ext-base.js"></script>

    <script type="text/javascript" src="../../ext3/ext-all.js"></script>
    <script type="text/javascript" src="../../ext3/src/locale/ext-lang-zh_CN.js"></script>
</head>
<body>
    <div id='toolbar'>
    </div>
    <div id='searchForm'>
    </div>
    <div id='contractPayGrid'>
    </div>
</body>

<%= getComboBoxStore() %>

<script type="text/javascript">
Ext.BLANK_IMAGE_URL = "../../ext3/resources/images/default/s.gif";
    Ext.onReady(function() {
    
    var saveType;
        /*------ʵ��toolbar�ĺ��� start---------------*/
        var Toolbar = new Ext.Toolbar({
            renderTo: "toolbar",
            items: [{
                text: "����",
                icon: "../../Theme/1/images/extjs/customer/add16.gif",
                handler: function() { 
                    saveType = 'add';
                    openAddPayWin(); 
                }
            }, '-', {
                text: "�༭",
                icon: "../../Theme/1/images/extjs/customer/edit16.gif",
                handler: function() { 
                    saveType = 'save';
                    modifyPayWin(); 
                }
//            }, '-', {
//                text: "ɾ��",
//                icon: "../../Theme/1/images/extjs/customer/delete16.gif",
//                handler: function() { deletePay(); }
}]
            });

            /*------����toolbar�ĺ��� end---------------*/

            
            /*------��ʼToolBar�¼����� start---------------*//*-----����Payʵ���ര�庯��----*/
            function openAddPayWin() {
                contractPayForm.getForm().reset();
	            uploadPayWindow.show();
	            
	            Ext.getCmp('ContractName').setDisabled(false);
	            
	            /*--------��Ͽ�------------------------------*/        
                //�����ͬ���첽���÷���
                var dsContracts;
                if(dsContracts == null){
                    dsContracts = new Ext.data.Store({
                        url: 'frmCrmContractPay.aspx?method=getContracts',  
                        reader: new Ext.data.JsonReader({  
                            root: 'root',  
                            totalProperty: 'totalProperty'
                        }, [  
                            {name: 'ContractId', mapping: 'ContractId'}, 
                            {name: 'ContractNo', mapping: 'ContractNo'},  
                            {name: 'ContractName', mapping: 'ContractName'}
                        ]),
                        params:{
                            limit:10,
                            start:0
                        }
                    });
                }
               var contractsFilterCombo = new Ext.form.ComboBox({  
                            store: dsContracts,  
                            displayField:'ContractName',
                            displayValue:'ContractId',
                            typeAhead: false,  
                            minChars:1,
                            loadingText: 'Searching...',  
                            //tpl: resultTpl,  
                            pageSize:10,  
                            hideTrigger:true,  
                            applyTo: 'ContractName',
                            onSelect: function(record){ // override default onSelect to do redirect  
                                //alert(record.data.cusid); 
                                //alert(Ext.getCmp('search').getValue());                        
                                Ext.getCmp('ContractName').setValue(record.data.ContractName);
                                Ext.getCmp('ContactId').setValue(record.data.ContractId);
                                this.collapse();
                            }  
                        }); 
                /*--------��Ͽ�------------------------------*/
	            
            }
            /*-----�༭Payʵ���ര�庯��----*/
            function modifyPayWin() {
                var sm = contractPayGrid.getSelectionModel();
                //��ȡѡ���������Ϣ
                var selectData = sm.getSelected();
                if (selectData == null) {
                    Ext.Msg.alert("��ʾ", "��ѡ����Ҫ�༭����Ϣ��");
                    return;
                }
                uploadPayWindow.show();
                Ext.getCmp('ContractName').setDisabled(true);
                setFormValue(selectData);
            }
            /*-----ɾ��Payʵ�庯��----*/
            /*ɾ����Ϣ*/
            function deletePay() {
                var sm = contractPayGrid.getSelectionModel();
                //��ȡѡ���������Ϣ
                var selectData = sm.getSelected();
                //���û��ѡ�񣬾���ʾ��Ҫѡ��������Ϣ
                if (selectData == null) {
                    Ext.Msg.alert("��ʾ", "��ѡ����Ҫɾ������Ϣ��");
                    return;
                }
                //ɾ��ǰ�ٴ������Ƿ����Ҫɾ��
                Ext.Msg.confirm("��ʾ��Ϣ", "�Ƿ����Ҫɾ��ѡ�����Ϣ��", function callBack(id) {
                    //�ж��Ƿ�ɾ������
                    if (id == "yes") {
                        //ҳ���ύ
                        Ext.Ajax.request({
                            url: 'frmCrmContractPay.aspx?method=deletePay',
                            method: 'POST',
                            params: {
                                PayId: selectData.data.PayId
                            },
                            success: function(resp, opts) {
                                Ext.Msg.alert("��ʾ", "����ɾ���ɹ�");
                            },
                            failure: function(resp, opts) {
                                Ext.Msg.alert("��ʾ", "����ɾ��ʧ��");
                            }
                        });
                    }
                });
            }            

            /*------ʵ��FormPanle�ĺ��� start---------------*/
            var contractPayForm = new Ext.form.FormPanel({
                url: '',
                //renderTo: 'divForm',
                frame: true,
                title: '',
                items: [{
	    layout: 'column',
	    border: false,
	    labelSeparator: '��',
	    items: [
		{
		    layout: 'form',
		    border: false,
		    columnWidth: 1,
		    items: [
		    {
		        xtype: 'hidden',
		        fieldLabel: '����ID',
		        columnWidth: 1,
		        anchor: '90%',
		        name: 'PayId',
		        id: 'PayId',
		        hidden:true,
		        hiddenLabel:true
		    }
            , {
                xtype: 'hidden',
                fieldLabel: '��ͬID',
                columnWidth: 1,
                anchor: '95%',
                name: 'ContactId',
                id: 'ContactId',
                hidden:true,
		        hiddenLabel:true
            }
            , {
                xtype: 'textfield',
                fieldLabel: '��ͬ����',
                columnWidth: 1,
                anchor: '95%',
                name: 'ContractName',
                id: 'ContractName'
            }
		]
		}
	]
	},
	{
	    layout: 'column',
	    border: false,
	    labelSeparator: '��',
	    items: [
		{
		    layout: 'form',
		    border: false,
		    columnWidth: 0.5,
		    items: [
		    {
                xtype: 'hidden',
                fieldLabel: '������',
                name: 'PayMan',
                id: 'PayMan',
                value:<%=EmployeeID %>
            },
		    {
                xtype: 'textfield',
                fieldLabel: '������',
                columnWidth: 1,
                anchor: '90%',
                name: 'PayManName',
                id: 'PayManName',
                value:'<%=EmpName %>',
                readOnly:true
            }]
         }, 
         {
            layout: 'form',
		    border: false,
		    columnWidth: 0.5,
		    items: [
		    {
                xtype: 'datefield',
                fieldLabel: '��������',
                columnWidth: 1,
                anchor: '90%',
                name: 'PayDate',
                id: 'PayDate',
                format:'Y��m��d��',
                allowBlank: false,//����Ϊ��
                blankText:'��ͬ���ڲ���Ϊ�գ�',
                value:new Date().clearTime()
            }]
         }]
    }, 
    {
        layout: 'column',
	    border: false,
	    labelSeparator: '��',
	    items: [
		{
		    layout: 'form',
		    border: false,
		    columnWidth: 0.5,
		    items: [
		    {
                xtype: 'numberfield',
                fieldLabel: '������',
                columnWidth: 1,
                anchor: '90%',
                name: 'PaySum',
                id: 'PaySum'
            }]
        },
        {
            layout: 'form',
		    border: false,
		    columnWidth: 0.5,
		    items: [
		    {
                xtype: 'combo',
                fieldLabel: '��������',
                columnWidth: 1,
                anchor: '90%',
                name: 'PayType',
                hiddenName:'value',
                id: 'PayType',
                store:dsPayType,
                valueField:'DicsCode',
                displayField:'DicsName',
                mode:'local',
                triggerAction:'all',
                editable:false
             }]
        }]
    },
    {
        layout: 'column',
	    border: false,
	    labelSeparator: '��',
	    items: [
		{
		    layout: 'form',
		    border: false,
		    columnWidth: 1,
		    items: [
            {
                xtype: 'textarea',
                fieldLabel: '��ע',
                columnWidth: 1,
                anchor: '95%',
                name: 'Remark',
                id: 'Remark'
            }]
          }]
     }
            ]
            });
            /*------FormPanle�ĺ������� End---------------*/

            /*------��ʼ�������ݵĴ��� Start---------------*/
            if (typeof (uploadPayWindow) == "undefined") {//�������2��windows����
                uploadPayWindow = new Ext.Window({
                    id: 'Payformwindow'
		, iconCls: 'upload-win'
		, width: 500
		, height: 250
		, layout: 'fit'
		, plain: true
		, modal: true
		, constrain: true
		, resizable: false
		, closeAction: 'hide'
		, autoDestroy: true
		, items: contractPayForm
		, buttons: [{
		    text: "����"
			, handler: function() {
			    saveUserData();
			}
			, scope: this
		},
		{
		    text: "ȡ��"
			, handler: function() {
			    uploadPayWindow.hide();
			}
			, scope: this
}]
                });
            }
            uploadPayWindow.addListener("hide", function() {
                contractPayForm.getForm().reset();
            });

            /*------��ʼ��ȡ�������ݵĺ��� start---------------*/
            function saveUserData() {
                if(saveType=='add')
                    saveType = 'addContractPay';
                else if(saveType = 'save')
                    saveType = 'saveContractPay';
                    
                
                contractPayForm.getForm().submit({  
                        url : 'frmCrmContractPay.aspx?method='+saveType,
                        method: 'POST',
                        params:{
                            PayType: Ext.getCmp('PayType').getValue()
                        },
                        waitMsg: 'Uploading ...',
                        success: function(form, action){  
                            Ext.Msg.alert("��ʾ", "����ɹ�");  
                           win.hide();    
                        },      
                       failure: function(){      
                          Ext.Msg.alert("��ʾ", "����ʧ��");
                          win.hide();      
                       }  
                 });  
                
                /*    
                Ext.Ajax.request({
                    url: 'frmCrmContractPay.aspx?method='+saveType,
                    method: 'POST',
                    params: {
                        PayId: Ext.getCmp('PayId').getValue(),
                        ContactId: Ext.getCmp('ContactId').getValue(),
                        PayMan: Ext.getCmp('PayMan').getValue(),
                        PayDate: Ext.getCmp('PayDate').getValue().to,
                        PaySum: Ext.getCmp('PaySum').getValue(),
                        PayType: Ext.getCmp('PayType').getValue(),
                        Remark: Ext.getCmp('Remark').getValue()
                    },
                    success: function(resp, opts) {
                        Ext.Msg.alert("��ʾ", "����ɹ�");
                    },
                    failure: function(resp, opts) {
                        Ext.Msg.alert("��ʾ", "����ʧ��");
                    }
                });
                */
            }
            /*------������ȡ�������ݵĺ��� End---------------*/

            /*------��ʼ�������ݵĺ��� Start---------------*/
            function setFormValue(selectData) { 
                Ext.Ajax.request({
                    url: 'frmCrmContractPay.aspx?method=getPay',
                    params: {
                        PayId: selectData.data.PayId
                    },
                    success: function(resp, opts) {
                        var data = Ext.util.JSON.decode(resp.responseText);
                        Ext.getCmp("PayId").setValue(data.PayId);
                        Ext.getCmp("ContactId").setValue(data.ContactId);
                        Ext.getCmp("PayMan").setValue(data.PayMan);
                        Ext.getCmp("PayManName").setValue(data.PayManName);
                        Ext.getCmp("PayDate").setValue(Ext.util.Format.date(data.PayDate,'Y-m-d'));
                        Ext.getCmp("PaySum").setValue(data.PaySum);
                        Ext.getCmp("PayType").setValue(data.PayType);
                        Ext.getCmp("Remark").setValue(data.Remark);
                        
                         Ext.Ajax.request({
                            url: 'frmCrmContractPay.aspx?method=getContract',
                            params: {
                                contractid: data.ContactId
                            },
                            success: function(r, o) {
                                var cdata = Ext.util.JSON.decode(r.responseText);
                                Ext.getCmp("ContractName").setValue(cdata.ContractName); //ContractName
                            }
                        });
                    },
                    failure: function(resp, opts) {
                        Ext.Msg.alert("��ʾ", "��ȡ�û���Ϣʧ��");
                    }
                });
            }
            /*------�������ý������ݵĺ��� End---------------*/
            /*------�����ͬ������ start--------*/
            var namePanel = new Ext.form.TextField({
                style: 'margin-left:0px',
                cls: 'key',
                xtype: 'textfield',
                fieldLabel: '��ͬ����',
                name: 'name',
                anchor: '90%'
            });

var serchform = new Ext.FormPanel({
    renderTo: 'searchForm',
    labelAlign: 'left',
    layout:'fit',
    buttonAlign: 'right',
    bodyStyle: 'padding:5px',
    frame: true,
    labelWidth: 55,
    items: [{
        layout: 'column',   //�����Ԫ��Ϊ����Ϊ�в��ַ�ʽ
        border: false,
        items: [{
            columnWidth: .33,
            layout: 'form',
            border: false,
            items: [
                namePanel
                ]
        },{
            columnWidth: .10,
            layout: 'form',
            border: false,
            items: [{ cls: 'key',
                xtype: 'button',
                text: '��ѯ',
                anchor: '50%',
                handler :function(){                
                    var name=namePanel.getValue();
                    //alert(name +":"+type);
                    contractPayGridData.baseParams.ContractName = name;
                    contractPayGridData.load({
                                params : {
                                start : 0,
                                limit : 10
                                } 
                              }); 
                    }
                }]
        },{
            columnWidth: .23,  //����ռ�õĿ�ȣ���ʶΪ20��
            layout: 'form',
            border: false
        }]
    }]
});
/*------�����ѯform end ----------------*/
            /*------��ʼ��ȡ���ݵĺ��� start---------------*/
            var contractPayGridData = new Ext.data.Store
({
    url: 'frmCrmContractPay.aspx?method=getContractPayList',
    reader: new Ext.data.JsonReader({
        totalProperty: 'totalProperty',
        root: 'root'
    }, [
	{
	    name: 'PayId'
	},
	{
	    name: 'ContactId'
	},
	{
	    name: 'ContractName'
	},
	{
	    name: 'PayMan'
	},
	{
	    name: 'PayManName'
	},
	{
	    name: 'PayDate'
	},
	{
	    name: 'PaySum'
	},
	{
	    name: 'PayType'
	},
	{
	    name: 'Remark'
	},
	{
	    name: 'CreateDate'
}])
	,
    listeners:
	{
	    scope: this,
	    load: function() {
	    }
	}
});

            /*------��ȡ���ݵĺ��� ���� End---------------*/

            /*------��ʼDataGrid�ĺ��� start---------------*/

            var sm = new Ext.grid.CheckboxSelectionModel({
                singleSelect: true
            });
            var contractPayGrid = new Ext.grid.GridPanel({
                el: 'contractPayGrid',
                width: '100%',
                height: '100%',
                autoWidth: true,
                autoHeight: true,
                autoScroll: true,
                layout: 'fit',
                id: '',
                store: contractPayGridData,
                loadMask: { msg: '���ڼ������ݣ����Ժ��' },
                sm: sm,
                cm: new Ext.grid.ColumnModel([
		sm,
		new Ext.grid.RowNumberer(), //�Զ��к�
		{
		    header: '����ID',
		    dataIndex: 'PayId',
		    id: 'PayId',
			hidden: true,
            hideable: false
},
		{
		    header: '��ͬ����',
		    dataIndex: 'ContactId',
		    id: 'ContactId',
			hidden: true,
            hideable: false
		},
		{
		    header: '��ͬ����',
		    dataIndex: 'ContractName',
		    id: 'ContractName'
		},
		{
		    header: '������',
		    dataIndex: 'PayManName',
		    id: 'PayManName'
		},
		{
		    header: '��������',
		    dataIndex: 'PayDate',
		    id: 'PayDate',
		    renderer: Ext.util.Format.dateRenderer('Y��m��d��')
		},
		{
		    header: '������',
		    dataIndex: 'PaySum',
		    id: 'PaySum'
		},
		{
		    header: '��������',
		    dataIndex: 'PayType',
		    id: 'PayType',
		    renderer:{fn:function(v){
		        var index = dsPayType.find('DicsCode', v);
                var record = dsPayType.getAt(index);
                return record.data.DicsName;
		    }}
		},
		{
		    header: '��ע',
		    dataIndex: 'Remark',
		    id: 'Remark'
		},
		{
		    header: '����ʱ��',
		    dataIndex: 'CreateDate',
		    id: 'CreateDate',
		    renderer: Ext.util.Format.dateRenderer('Y��m��d��')
}]),
                bbar: new Ext.PagingToolbar({
                    pageSize: 10,
                    store: contractPayGridData,
                    displayMsg: '��ʾ��{0}����{1}����¼,��{2}��',
                    emptyMsy: 'û�м�¼',
                    displayInfo: true
                }),
                viewConfig: {
                    columnsText: '��ʾ����',
                    scrollOffset: 20,
                    sortAscText: '����',
                    sortDescText: '����',
                    forceFit: true
                },
                height: 280,
                closeAction: 'hide',
                stripeRows: true,
                loadMask: true,
                autoExpandColumn: 2
            });
            contractPayGrid.render();
            /*------DataGrid�ĺ������� End---------------*/



        })
</script>


</html>
