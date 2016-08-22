<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmSysDicsInfo.aspx.cs" Inherits="sysadmin_frmysDicsInfo" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>ϵͳ�ֵ�������Ϣά������</title>
    <meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
    <link rel="stylesheet" type="text/css" href="../../ext3/resources/css/ext-all.css" />
    <script type="text/javascript" src="../../ext3/adapter/ext/ext-base.js"></script>
    <script type="text/javascript" src="../../ext3/ext-all.js"></script>
    <script type="text/javascript" src="../../js/operateResp.js"></script>
</head>
<body>
    <div id='toolbar'>
    </div>
    <div id='divForm'>
    </div>
    <div id='dataGrid'>
    </div>
</body>

<script type="text/javascript">
Ext.onReady(function() {
    var operType = '';
    /*------ʵ��toolbar�ĺ��� start---------------*/
    var Toolbar = new Ext.Toolbar({
        renderTo: "toolbar",
        items: [{
                    text: "����",
                    icon: "../../Theme/1/images/extjs/customer/add16.gif",
                    handler: function() {
                        operType = 'add';
                        uploadUserWindow.show();
                    }
                },
                '-', //�ָ���
                {
                    text: "�༭",
                    icon: "../../Theme/1/images/extjs/customer/edit16.gif",
                    handler: function() {
                        operType = 'edit';
                        editSysDicsInfo(); 
                    }
                }
                , '-', //�ָ���
                {
                    text: "ɾ��",
                    icon: "../../Theme/1/images/extjs/customer/delete16.gif",
                    handler: function() { deleteSysDicsInfo(); }
                }]
        });
        /*  �޸Ĵ���  */
        function editSysDicsInfo() 
        {
          setFormValue();//����������ֵ   
        }
        /*  ɾ������  */
        function deleteSysDicsInfo() {
            var sm = dataGrid.getSelectionModel();
            var selectData = sm.getSelected();
            /*
            var record=sm.getSelections();
            if(record == null || record.length == 0)
            return null;
            var array = new Array(record.length);
            for(var i=0;i<record.length;i++)
            {
            array[i] = record[i].get('uid');
            }
            */
            if (selectData == null || selectData.length == 0 || selectData.length > 1) 
            {
                Ext.Msg.alert("��ʾ", "��ѡ��һ�У�");
            }
            else 
            {
                Ext.Ajax.request({
                url: 'frmSysDicsInfo.aspx?method=deleteDicsInfo',
                    params: {
                    DicsCode: selectData.data['DicsCode']//����frmSysDicsInfo
                    },
                    success: function(resp, opts) {
                        //var data=Ext.util.JSON.decode(resp.responseText);
                        Ext.Msg.alert("��ʾ", "ɾ���ɹ���");
                        dataGrid.getStore().reload();
                    },
                    failure: function(resp, opts) {
                        Ext.Msg.alert("��ʾ", "ɾ��ʧ�ܣ�");
                    }
                });
            }
        }
        /*------����toolbar�ĺ��� end---------------*/


        /*------ʵ��FormPanle�ĺ��� start---------------*/
        var sysdicsinfo = new Ext.form.FormPanel({
            id: 'sysdicsinfo',
            autoDestroy: true,
            frame: true,
            labelAlign: 'left',
            buttonAlign: 'right',
            bodyStyle: 'padding:5px',
            items: [
	        {
	            xtype: 'textfield',
	            fieldLabel: 'ϵͳ����',
	            columnWidth: 1,
	            anchor: '95%',
	            name: 'DicsCode',
	            id: 'DicsCode',
	            maxLength : 5,
	            listeners: { specialkey: function(f, e) { if (e.getKey() == e.ENTER) { Ext.getCmp('DicsName').focus(); } } }
	        }, 
	        {
                xtype: 'textfield',
                fieldLabel: 'ϵͳ����',
                columnWidth: 1,
                anchor: '95%',
                name: 'DicsName',
                id: 'DicsName',
                listeners: { specialkey: function(f, e) { if (e.getKey() == e.ENTER) { Ext.getCmp('DicsAliasname').focus(); } } }
            }, 
            {
                xtype: 'textfield',
                fieldLabel: 'ϵͳ����',
                columnWidth: 1,
                anchor: '95%',
                name: 'DicsAliasname',
                id: 'DicsAliasname',
                //regex: /^[\u4E00-\u9FA5]+$/,  
                //regexText:'ֻ�����뺺��', 
                //regex: /^[a-zA-Z0-9_\u4e00-\u9fa5]+$/,
                //regexText: '��ʽӦ�ɺ��֡����֡���ĸ���»������.',
                listeners: { specialkey: function(f, e) { if (e.getKey() == e.ENTER) { Ext.getCmp('OrderIndex').focus(); } } }
            }, 
            {
                xtype: 'textfield',
                fieldLabel: '�����',
                columnWidth: 1,
                anchor: '95%',
                name: 'OrderIndex',
                id: 'OrderIndex',
                listeners: { specialkey: function(f, e) { if (e.getKey() == e.ENTER) { Ext.getCmp('ParentsCode').focus(); } } }
            }, 
            {
                xtype: 'textfield',
                fieldLabel: '������',
                columnWidth: 1,
                anchor: '95%',
                name: 'ParentsCode',
                id: 'ParentsCode',
                listeners: { specialkey: function(f, e) { if (e.getKey() == e.ENTER) { Ext.getCmp('Isactive').focus(); } } }
            }, 
            {
                xtype: 'checkbox',
                fieldLabel: '�Ƿ����',
                columnWidth: 1,
                anchor: '95%',
                name: 'Isactive',
                id: 'Isactive',
                listeners: { specialkey: function(f, e) { if (e.getKey() == e.ENTER) { Ext.getCmp('Ismodify').focus(); } } }
            }, 
            {
                xtype: 'checkbox',
                fieldLabel: '�Ƿ������޸�',
                columnWidth: 1,
                anchor: '95%',
                name: 'Ismodify',
                id: 'Ismodify',
                listeners: { specialkey: function(f, e) { if (e.getKey() == e.ENTER) { Ext.getCmp('Remark').focus(); } } }
            }, 
            {
                xtype: 'textfield',
                fieldLabel: '��ע',
                columnWidth: 1,
                anchor: '95%',
                name: 'Remark',
                id: 'Remark',
                listeners: { specialkey: function(f, e) { if (e.getKey() == e.ENTER) { Ext.getCmp('savebuttonid').focus(); } } }
            }]
        });
        /*------FormPanle�ĺ������� End---------------*/

        /*------��ʼ��ȡ�������ݵĺ��� start---------------*/
        function saveFormValue() 
        {
            var Isactive=0;
            var Ismodify=0;
            if (Ext.get("Isactive").dom.checked)
                Isactive= 1;
            if (Ext.get("Ismodify").dom.checked)
                Ismodify= 1;
            
            if(operType == 'add')
                suffix = 'saveAddDicsInfo';
            else if (operType == 'edit')
                suffix = 'saveModifyDicsInfo';
                
            Ext.Ajax.request({
                url: 'frmSysDicsInfo.aspx?method='+suffix,
                method: 'POST',
                timeout: 30000,
                params: {
                    DicsCode: Ext.getCmp('DicsCode').getValue(),
                    DicsName: Ext.getCmp('DicsName').getValue(),
                    DicsAliasname: Ext.getCmp('DicsAliasname').getValue(),
                    OrderIndex: Ext.getCmp('OrderIndex').getValue(),
                    ParentsCode: Ext.getCmp('ParentsCode').getValue(),
                    Isactive: Isactive,
                    Ismodify: Ismodify,
                    Remark: Ext.getCmp('Remark').getValue()
                },
                success: function(resp, opts) 
                {
                    if(checkExtMessage(resp))
                    {
                        dataGrid.getStore().reload();
                    }                    
                },
                failure: function(resp, opts) 
                {
                    Ext.Msg.alert("��ʾ", "����ʧ��");
                }
            });
        }
        /*------������ȡ�������ݵĺ��� End---------------*/

        /*------��ʼ�������ݵĺ��� Start---------------*/
        function setFormValue() 
        {
            var sm = dataGrid.getSelectionModel();
            var selectData = sm.getSelected();
            if (selectData == null) 
            {
                Ext.Msg.alert("��ʾ", "��ѡ��һ�У�");
            }
            else 
            { 
                //�ȸ���codeȡ�����ݣ���д��form�У�Ҳ���Խ�grid���record����form
                Ext.Ajax.request({
                    url: 'frmSysDicsInfo.aspx?method=getModifyDicsInfo',
                    params: {
                        DicsCode: selectData.data['DicsCode']
                    },
                    success: function(resp, opts) {
                        uploadUserWindow.show();
                        var data = Ext.util.JSON.decode(resp.responseText);
                        Ext.getCmp("DicsCode").setValue(data.DicsCode);
                        Ext.getCmp("DicsName").setValue(data.DicsName);
                        Ext.getCmp("DicsAliasname").setValue(data.DicsAliasname);
                        Ext.getCmp("OrderIndex").setValue(data.OrderIndex);
                        Ext.getCmp("ParentsCode").setValue(data.ParentsCode);
                        if (data.Isactive == 1) {
                            Ext.get("Isactive").dom.checked = true;
                        }
                        if (data.Ismodify == 1) {
                            Ext.get("Ismodify").dom.checked = true;
                        }
                        Ext.getCmp("Remark").setValue(data.Remark);
                    },
                    failure: function(resp, opts) {
                        Ext.Msg.alert("��ʾ", "��ȡϵͳ������Ϣʧ��");
                    }
                });
            }
        }
        /*------�������ý������ݵĺ��� End---------------*/

        /*------��ʼ��ȡ���ݵĺ��� start---------------*/
        var userdataGridData = new Ext.data.Store
        ({
            url: 'frmSysDicsInfo.aspx?method=getDicsInfoList',
            reader: new Ext.data.JsonReader({
                totalProperty: 'totalProperty',
                root: 'root'}, 
                [{name: 'DicsCode'},
                {name: 'DicsName'},
                {name: 'DicsAliasname'},
                {name: 'OrderIndex'},
                {name: 'ParentsCode'},
                {name: 'Isactive'},
                {name: 'Ismodify'},
                {name: 'Remark'}]),
                listeners:{
	                    scope: this,
	                    load: function() {
	                    //            
	                    }
	            }
        });

        /*------��ȡ���ݵĺ��� ���� End---------------*/

        /*------��ʼ��ѯform�ĺ��� start---------------*/

        var dscsCodePanel = new Ext.form.TextField({
            style: 'margin-left:0px',
            cls: 'key',
            xtype: 'textfield',
            fieldLabel: 'ϵͳ����',
            name: 'dicsCodeField',
            id: 'dicsCodeField',
            anchor: '90%',
            listeners: { specialkey: function(f, e) { if (e.getKey() == e.ENTER) { Ext.getCmp('dicsParentCodeField').focus(); } } }

        });
        
        var dscsParentCodePanel = new Ext.form.TextField({
            style: 'margin-left:0px',
            cls: 'key',
            xtype: 'textfield',
            fieldLabel: '������',
            name: 'dicsParentCodeField',
            id: 'dicsParentCodeField',
            anchor: '90%',
            listeners: { specialkey: function(f, e) { if (e.getKey() == e.ENTER) { Ext.getCmp('dicsNameField').focus(); } } }

        });


        var dicsNameNAMEPanel = new Ext.form.TextField({
            style: 'margin-left:0px',
            cls: 'key',
            xtype: 'textfield',
            fieldLabel: 'ϵͳ����',
            name: 'dicsNameField',
            id: 'dicsNameField',
            anchor: '90%',
            listeners: { specialkey: function(f, e) { if (e.getKey() == e.ENTER) { Ext.getCmp('searchebtnId').focus(); } } }
        });

        var serchform = new Ext.FormPanel({
            renderTo: 'divForm',
            labelAlign: 'left',
            layout: 'fit',
            buttonAlign: 'right',
            bodyStyle: 'padding:5px',
            frame: true,
            labelWidth: 55,
            items: [{
                layout: 'column',   //�����Ԫ��Ϊ����Ϊ�в��ַ�ʽ
                border: false,
                items: [{
                    columnWidth: .3,  //����ռ�õĿ�ȣ���ʶΪ20��
                    layout: 'form',
                    border: false,
                    items: [
                        dscsCodePanel 
                    ]
                }, {
                    columnWidth: .3,
                    layout: 'form',
                    border: false,
                    items: [
                        dscsParentCodePanel
                        ]
                }, {
                    columnWidth: .3,
                    layout: 'form',
                    border: false,
                    items: [
                        dicsNameNAMEPanel
                        ]
                },{
                    columnWidth: .1,
                    layout: 'form',
                    border: false,
                    items: [{ cls: 'key',
                        xtype: 'button',
                        text: '��ѯ',
                        id: 'searchebtnId',
                        anchor: '90%',
                        handler: function() {

                            var dicsCode = dscsCodePanel.getValue();
                            var ParentsCode = dscsParentCodePanel.getValue();
                            var dicsName = dicsNameNAMEPanel.getValue();

                            userdataGridData.baseParams.DicsCode = dicsCode;
                            userdataGridData.baseParams.ParentsCode = ParentsCode;
                            userdataGridData.baseParams.DicsName = dicsName;
                            userdataGridData.load({
                                params: {
                                    start: 0,
                                    limit: 10
                                }
                            });
                        }
                    }]
                }]
            }]
        });


        /*------��ʼ��ѯform�ĺ��� end---------------*/

        /*------��ʼDataGrid�ĺ��� start---------------*/

        var sm = new Ext.grid.CheckboxSelectionModel({
            singleSelect: true
        });
        var dataGrid = new Ext.grid.GridPanel({
            el: 'dataGrid',
            id: 'dicsInfoDatagrid',
            width: '100%',
            height: '100%',
            autoWidth: true,
            autoHeight: true,
            autoScroll: true,
            layout: 'fit',
            id: '',
            store: userdataGridData,
            loadMask: { msg: '���ڼ������ݣ����Ժ��' },
            sm: sm,
            cm: new Ext.grid.ColumnModel([
            sm,
            new Ext.grid.RowNumberer(), //�Զ��к�
            {
                header: 'ϵͳ����',
                width: 20,
                dataIndex: 'DicsCode',
                id: 'DicsCode'
            },
            {
                header: 'ϵͳ����',
                width: 30,
                dataIndex: 'DicsName',
                id: 'DicsName'
            },
            {
                header: 'ϵͳ����',
                width: 30,
                dataIndex: 'DicsAliasname',
                id: 'DicsAliasname'
            },
            {
                header: '�����',
                width: 10,
                dataIndex: 'OrderIndex',
                id: 'OrderIndex'
            },
            {
                header: '������',
                width: 20,
                dataIndex: 'ParentsCode',
                id: 'ParentsCode'
            },
            {
                header: '�Ƿ����',
                width: 10,
                dataIndex: 'Isactive',
                id: 'Isactive',
                renderer:function(v){
                    if(v==0) return '��';
                    if(v==1) return '��';
                }
            },
            {
                header: '�Ƿ������޸�',
                width: 10,
                dataIndex: 'Ismodify',
                id: 'Ismodify',
                renderer:function(v){
                    if(v==0) return '��';
                    if(v==1) return '��';
                }
            },
            {
                header: '��ע',
                width: 40,
                dataIndex: 'Remark',
                id: 'Remark'
            }]),
            bbar: new Ext.PagingToolbar({
                pageSize: 10,
                store: userdataGridData,
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
        //��Ⱦ��ҳ��
        dataGrid.render();
        /*------DataGrid�ĺ������� End---------------*/

        /*------WindowForm ���ÿ�ʼ------------------*/
        if (typeof (uploadUserWindow) == "undefined") {//�������2��windows����
            uploadUserWindow = new Ext.Window({
                id: 'userformwindow',
                title: "�����û�"
                , iconCls: 'upload-win'
                , width: 480
                , height: 320
                , layout: 'fit'
                , plain: true
                , modal: true
                // , x: 50
                // , y: 50
                , constrain: true
                , resizable: false
                , closeAction: 'hide'
                , autoDestroy: true
                , items: sysdicsinfo
                , buttons: [{
                     id: 'savebuttonid'
                    , text: "����"
                    , handler: function() {
                        if (confirm("ȷ�ϱ��棿")) {
                            saveUserData();
                            uploadUserWindow.hide();
                        }
                    }
                    , scope: this
                },
                {
                    text: "ȡ��"
                    , handler: function() {
                        uploadUserWindow.hide();
                    }
                    , scope: this
                }]
            });
         }

        uploadUserWindow.addListener("hide", function() {
            sysdicsinfo.getForm().reset();
        });
        /*------WindowForm ���ÿ�ʼ------------------*/
        function saveUserData() 
        {
            saveFormValue();
        }


})
</script>

</html>
