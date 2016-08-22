<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmCrmContract.aspx.cs" Inherits="CRM_Contract_frmCrmContract" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html>
<head>
<title>����ҳ��</title><meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<link rel="stylesheet" type="text/css" href="../../ext3/resources/css/ext-all.css" />
<script type="text/javascript" src="../../ext3/adapter/ext/ext-base.js"></script>
<script type="text/javascript" src="../../ext3/ext-all.js"></script>
<link rel="stylesheet" type="text/css" href="../../ext3/example/file-upload.css" />
<script type="text/javascript" src="../../ext3/example/FileUploadField.js"></script>
<script type="text/javascript" src="../../ext3/src/locale/ext-lang-zh_CN.js"></script>
</head>
<body>
<div id='toolbar'></div>
<div id='searchForm'></div>
<div id='contractGrid'></div>

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
                    openAddContractWin(); 
                }
            }, '-', {
                text: "�༭",
                icon: "../../Theme/1/images/extjs/customer/edit16.gif",
                handler: function() { 
                    saveType = 'save';
                    modifyContractWin(); 
                }
            }, '-', {
                text: "ɾ��",
                icon: "../../Theme/1/images/extjs/customer/delete16.gif",
                handler: function() { deleteContract(); }
            },  '-',{
                text: "�鿴����",
                icon: "../../Theme/1/images/extjs/customer/delete16.gif",
                handler: function() { viewContractAttach();}
}]
            });

            /*------����toolbar�ĺ��� end---------------*/


            /*------��ʼToolBar�¼����� start---------------*//*-----����Contractʵ���ര�庯��----*/
            function openAddContractWin() {
                Ext.getCmp('ContractId').setValue("");
	            Ext.getCmp('ContractNo').setValue("");
	            Ext.getCmp('ContractName').setValue("");
	            Ext.getCmp('ContractType').setValue("");
	            Ext.getCmp('ContractDate').setValue("");
	            Ext.getCmp('Singer').setValue("");
	            Ext.getCmp('ContractSecond').setValue("");
	            Ext.getCmp('ContractSum').setValue("");
	            Ext.getCmp('ContractContent').setValue("");
	            Ext.getCmp('ContarctAttach').setValue("");
	            Ext.getCmp('State').setValue("");
	            uploadContractWindow.show();
            }
            /*-----�༭Contractʵ���ര�庯��----*/
            function modifyContractWin() {
                var sm = contractGrid.getSelectionModel();
                //��ȡѡ���������Ϣ
                var selectData = sm.getSelected();
                if (selectData == null) {
                    Ext.Msg.alert("��ʾ", "��ѡ����Ҫ�༭����Ϣ��");
                    return;
                }
                uploadContractWindow.show();
                setFormValue(selectData);
            }
            /*-----ɾ��Contractʵ�庯��----*/
            /*ɾ����Ϣ*/
            function deleteContract() {
                var sm = contractGrid.getSelectionModel();
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
                            url: 'frmCrmContract.aspx?method=deleteContract',
                            method: 'POST',
                            params: {
                                ContractId: selectData.data.ContractId
                            },
                            success: function(resp, opts) {
                                Ext.Msg.alert("��ʾ", "����ɾ���ɹ�");
                                contractGrid.getStore().reload();
                            },
                            failure: function(resp, opts) {
                                Ext.Msg.alert("��ʾ", "����ɾ��ʧ��");
                            }
                        });
                    }
                });
            }
            function viewContractAttach(){
                 var sm = contractGrid.getSelectionModel();
                //��ȡѡ���������Ϣ
                var selectData = sm.getSelected();
                //���û��ѡ�񣬾���ʾ��Ҫѡ��������Ϣ
                if (selectData == null) {
                    Ext.Msg.alert("��ʾ", "��ѡ����Ҫ�鿴����Ϣ��");
                    return;
                }
                //�����¿�һ��window.open�鿴�ļ���������������
                var annme = selectData.data.ContarctAttach;
                
                if(annme == "")
                    return;	                        
                //else download file
                window.open("frmCrmContract.aspx?method=getAccessories&fileName="+annme,"");
            }

            /*------ʵ��FormPanle�ĺ��� start---------------*/
            var crmContract = new Ext.form.FormPanel({
            url: '',
                //renderTo: 'divForm',
                frame: true,
                title: '',
                labelAlign: 'left',
                buttonAlign: 'right',
                bodyStyle: 'padding:5px',
                labelWidth: 60,
                fileUpload:true, 
                defaults: {
                   msgTarget: 'side'
                },
                items: [
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
				    xtype: 'hidden',
				    fieldLabel: '��ͬID',
				    columnWidth: 1,
				    anchor: '90%',
				    name: 'ContractId',
				    id: 'ContractId',
				    hidden:true,
				    hiddenLabel:true
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
		    columnWidth: 0.4,
		    items: [
				{
				    xtype: 'textfield',
				    fieldLabel: '��ͬ���',
				    anchor: '90%',
				    name: 'ContractNo',
				    id: 'ContractNo'
				}
		]
		}
, {
    layout: 'form',
    border: false,
    columnWidth: 0.6,
    items: [
				{
				    xtype: 'textfield',
				    fieldLabel: '��ͬ����	',
				    anchor: '90%',
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
				    xtype: 'combo',
				    fieldLabel: '��ͬ����',
				    anchor: '90%',
				    name: 'ContractType',
				    id: 'ContractType',
				    hiddenName:'value',
				    store:dsContractType,
				    displayField:'DicsName',
				    valueField:'DicsCode',
				    mode:'local',
				    triggerAction:'all'
				}
		]
		}
, {
    layout: 'form',
    border: false,
    columnWidth: 0.5,
    items: [
				{
				    xtype: 'datefield',
				    fieldLabel: '��ͬʱ��',
				    anchor: '90%',
				    name: 'ContractDate',
				    id: 'ContractDate',
				    format: 'Y��m��d��'
				}
		]
}
, {
    layout: 'form',
    border: false,
    columnWidth: 0.34,
    items: [
				{
				   
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
				     xtype: 'textfield',
				    fieldLabel: 'ǩ����',
				    anchor: '90%',
				    name: 'Singer',
				    id: 'Singer'
				}
		]
		}
, {
    layout: 'form',
    border: false,
    columnWidth: 0.5,
    items: [
				{
				    xtype: 'numberfield',
				    fieldLabel: '��ͬ���',
				    anchor: '90%',
				    name: 'ContractSum',
				    id: 'ContractSum'
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
		    columnWidth: 0.67,
		    items: [
				{
				    xtype: 'textfield',
				    fieldLabel: '��ͬ�ҷ�',
				    columnWidth: 0.1,
				    anchor: '90%',
				    name: 'ContractSecond',
				    id: 'ContractSecond'
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
		    columnWidth: 1,
		    items: [
				{
				    xtype: 'textarea',
				    fieldLabel: '��ͬ����',
				    columnWidth: 1,
				    anchor: '90%',
				    name: 'ContractContent',
				    id: 'ContractContent'
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
		    columnWidth: 1,
		    items: [
				{
				    xtype: 'fileuploadfield',
				    fieldLabel: '��ͬ����',
				    emptyText:'��ѡ�񸽼�',
				    anchor: '90%',
				    name: 'ContarctAttach',
				    id: 'ContarctAttach',
				    buttonText: 'ѡ��'
                    //disabled:true
                    //readOnly:true,
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
				    xtype: 'combo',
				    fieldLabel: '��ͬ״̬',
				    anchor: '90%',
				    name: 'State',
				    id: 'State',
				    hiddenName:'value',
				    triggerAction:'all',
				    store: dsState ,
				    displayField:'DicsName',
                    valueField:'DicsCode',
                    mode:'local',
                    triggerAction:'all'
				}
		]
		}
, {
    layout: 'form',
    border: false,
    columnWidth: 0.5
}
	]
	}
]
            });
            /*------FormPanle�ĺ������� End---------------*/

            /*------��ʼ�������ݵĴ��� Start---------------*/
            if (typeof (uploadContractWindow) == "undefined") {//�������2��windows����
                uploadContractWindow = new Ext.Window({
                    id: 'Contractformwindow'
		, iconCls: 'upload-win'
		, width: 600
		, height: 350
		, layout: 'fit'
		, plain: true
		, modal: true
		, constrain: true
		, resizable: false
		, closeAction: 'hide'
		, autoDestroy: true
		, items: crmContract
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
			    uploadContractWindow.hide();
			}
			, scope: this
}]
                });
            }
            uploadContractWindow.addListener("hide", function() {
            });

            /*------��ʼ��ȡ�������ݵĺ��� start---------------*/
            function saveUserData() {
                if(saveType == 'add')
                    saveType='addContract';
                if(saveType == 'save')
                    saveType = 'saveContract';
                    
               var contractDate = Ext.getCmp('ContractDate').getValue();
                if(contractDate==null||contractDate=="")
                {
                    Ext.Msg.alert("��ʾ", "�������ͬʱ��");
                    return;
                }
                crmContract.getForm().submit({  
                        url : 'frmCrmContract.aspx?method='+saveType,
                        method: 'POST',
                        params:{
                            ContractType: Ext.getCmp('ContractType').getValue(),
                            State: Ext.getCmp('State').getValue(),
                            ContarctAttach:Ext.getCmp('ContarctAttach').getValue()
                        },
                        //waitMsg: 'Uploading your photo...',
                        success: function(form, action){  
                           Ext.Msg.alert("��ʾ", "����ɹ�");
                           uploadContractWindow.hide();
                           contractGridData.reload();  
                           //win.hide();    
                        },      
                       failure: function(){      
                          Ext.Msg.alert("��ʾ", "����ʧ��");
                          //win.hide();      
                       }  
                 });               
                                    
                /*
                var contractDate = Ext.getCmp('ContractDate').getValue();
                if(contractDate!=""&&contractDate!=null)
                {
                    contractDate=contractDate.toLocaleDateString();                    
                }
                else
                {
                    Ext.Msg.alert("��ʾ", "�������ͬʱ��");
                    return;
                }
                    
                Ext.Ajax.request({
                url: 'frmCrmContract.aspx?method='+saveType,
                    method: 'POST',
                    waitMsg: 'Uploading your photo...',
                    params: {
                        ContractId: Ext.getCmp('ContractId').getValue(),
                        ContractNo: Ext.getCmp('ContractNo').getValue(),
                        ContractName: Ext.getCmp('ContractName').getValue(),
                        ContractType: Ext.getCmp('ContractType').getValue(),
                        ContractDate: contractDate,
                        Singer: Ext.getCmp('Singer').getValue(),
                        ContractSecond: Ext.getCmp('ContractSecond').getValue(),
                        ContractSum: Ext.getCmp('ContractSum').getValue(),
                        ContractContent: Ext.getCmp('ContractContent').getValue(),
                        ContarctAttach: Ext.getCmp('ContarctAttach').getValue(),
                        State: Ext.getCmp('State').getValue()
                    },
                    success: function(resp, opts) {
                        Ext.Msg.alert("��ʾ", "����ɹ�");
                        contractGrid.getStore().reload();
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
                url: 'frmCrmContract.aspx?method=getContract',
                    params: {
                        ContractId: selectData.data.ContractId
                    },
                    success: function(resp, opts) {
                        var data = Ext.util.JSON.decode(resp.responseText);
                        Ext.getCmp("ContractId").setValue(data.ContractId);
                        Ext.getCmp("ContractNo").setValue(data.ContractNo);
                        Ext.getCmp("ContractName").setValue(data.ContractName);
                        Ext.getCmp("ContractType").setValue(data.ContractType);
                        Ext.getCmp("ContractDate").setValue((new Date(data.ContractDate.replace(/-/g,"/"))));
                        Ext.getCmp("Singer").setValue(data.Singer);
                        Ext.getCmp("ContractSecond").setValue(data.ContractSecond);
                        Ext.getCmp("ContractSum").setValue(data.ContractSum);
                        Ext.getCmp("ContractContent").setValue(data.ContractContent);
                        Ext.getCmp("ContarctAttach").setValue(data.ContarctAttach);
                        Ext.getCmp("State").setValue(data.State);
                    },
                    failure: function(resp, opts) {
                        Ext.Msg.alert("��ʾ", "��ȡ��ͬ��Ϣʧ��");
                    }
                });
            }
            /*------�������ý������ݵĺ��� End---------------*/

/*------�����ѯform start ----------------*/
var namePanel = new Ext.form.TextField({
    style: 'margin-left:0px',
    cls: 'key',
    xtype: 'textfield',
    fieldLabel: '��Ʒ����',
    name: 'name',
    anchor: '90%'
});

/*------����ͻ����������� start--------*/
var contractComBoxStore ;
if (contractComBoxStore == null) { //��ֹ�ظ�����
    contractComBoxStore = new Ext.data.JsonStore({ 
    totalProperty : "results", 
    root : "root", 
    url : 'frmCrmContract.aspx?method=getContractType', 
    fields : ['contractId', 'contractName'] 
        }); 
    contractComBoxStore.load();	
}
var Typecombo = new Ext.form.ComboBox({
    fieldLabel: '��ͬ����',
    name: 'folderMoveTo',
    store: dsContractType,
    displayField: 'DicsName',
    valueField: 'DicsCode',
    mode: 'local',
    editable:false,
    //loadText:'loading ...',
    typeAhead: true, //�Զ�����һ����������ѡ�ȫ����
    triggerAction: 'all',
    selectOnFocus: true,
    forceSelection: true,
    width: 100

});

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
            columnWidth: .33,
            layout: 'form',
            border: false,
            items: [
                Typecombo
                ]
        }, {
            columnWidth: .10,
            layout: 'form',
            border: false,
            items: [{ cls: 'key',
                xtype: 'button',
                text: '��ѯ',
                anchor: '50%',
                handler :function(){                
                    var name=namePanel.getValue();
                    var type = Typecombo.getValue();
                    //alert(name +":"+type);
                    contractGridData.baseParams.ContractName = name;
                    contractGridData.baseParams.ContractType = type;
                    
                    contractGridData.load({
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
            var contractGridData = new Ext.data.Store
({
    url: 'frmCrmContract.aspx?method=getContractList',
    reader: new Ext.data.JsonReader({
        totalProperty: 'totalProperty',
        root: 'root'
    }, [
	{
	    name: 'ContractId'
	},
	{
	    name: 'ContractNo'
	},
	{
	    name: 'ContractName'
	},
	{
	    name: 'ContractType'
	},
	{
	    name: 'ContractDate'
	},
	{
	    name: 'Singer'
	},
	{
	    name: 'ContractSecond'
	},
	{
	    name: 'ContractSum'
	},
	{
	    name: 'ContractContent'
	},
	{
	    name: 'ContarctAttach'
	},
	{
	    name: 'State'
	},
	{
	    name: 'CreateDate'
	},
	{
	    name: 'UpdateDate'
	},
	{
	    name: 'OwenId'
	},
	{
	    name: 'OwenOrgId'
	},
	{
	    name: 'OperId'
	},
	{
	    name: 'OrgId'
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
            var contractGrid = new Ext.grid.GridPanel({
                el: 'contractGrid',
                width: '100%',
                height: '100%',
                autoWidth: true,
                autoHeight: true,
                autoScroll: true,
                layout: 'fit',
                id: '',
                store: contractGridData,
                loadMask: { msg: '���ڼ������ݣ����Ժ��' },
                sm: sm,
                cm: new Ext.grid.ColumnModel([
		sm,
		new Ext.grid.RowNumberer(), //�Զ��к�
		{
		    header: '��ͬID',
		    dataIndex: 'ContractId',
		    id: 'ContractId',
			hidden: true,
            hideable: false		
},
		{
		    header: '��ͬ���',
		    dataIndex: 'ContractNo',
		    id: 'ContractNo'
		},
		{
		    header: '��ͬ����	',
		    dataIndex: 'ContractName',
		    id: 'ContractName'
		},
		{
		    header: '��ͬ����',
		    dataIndex: 'ContractType',
		    id: 'ContractType',
		    renderer:{fn:function(v){
		        //����key��λ�������е�value
		        var index = dsContractType.find('DicsCode', v);
                var record = dsContractType.getAt(index);
                return record.data.DicsName;
		     }}
		},
		{
		    header: '��ͬʱ��',
		    dataIndex: 'ContractDate',
		    id: 'ContractDate',
		    renderer: Ext.util.Format.dateRenderer('Y��m��d��')
		},
		{
		    header: 'ǩ����',
		    dataIndex: 'Singer',
		    id: 'Singer'
		},
		{
		    header: '��ͬ�ҷ�',
		    dataIndex: 'ContractSecond',
		    id: 'ContractSecond'
		},
		{
		    header: '��ͬ���',
		    dataIndex: 'ContractSum',
		    id: 'ContractSum'
		},
		{
		    header: '��ͬ״̬',
		    dataIndex: 'State',
		    id: 'State',
		    renderer:{fn:function(v){
		        //����key��λ�������е�value
		        var index = dsState.find('DicsCode', v);
                var record = dsState.getAt(index);
                return record.data.DicsName;
		     }}
		
}]),
                bbar: new Ext.PagingToolbar({
                    pageSize: 10,
                    store: contractGridData,
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
            contractGrid.render();
            /*------DataGrid�ĺ������� End---------------*/



        })
</script>

</html>

