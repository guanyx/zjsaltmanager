<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmWmsClosedAccount.aspx.cs" Inherits="WMS_frmWmsClosedAccount" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html>
<head>
<title>�ֿ����ҳ</title>
<meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<link rel="stylesheet" type="text/css" href="../ext3/resources/css/ext-all.css" />
<script type="text/javascript" src="../ext3/adapter/ext/ext-base.js"></script>
<script type="text/javascript" src="../ext3/ext-all.js"></script>
<script type="text/javascript" src="../js/operateResp.js"></script>
<script type="text/javascript" src="../js/ExtFix.js"></script>
    <script type="text/javascript" src="../ext3/src/locale/ext-lang-zh_CN.js"></script>
<style type="text/css">
a.button {
background: transparent url('../Theme/1/images/frame/bg_button_a.gif') no-repeat scroll top right;
color: #444;
display: block;
float: left;
font: normal 12px arial, sans-serif;
height: 24px;
margin-right: 6px;
padding-right: 18px; /* sliding doors padding */
text-decoration: none;
}
a.button span {
background: transparent url('../Theme/1/images/frame/bg_button_div.gif') no-repeat;
display: block;
line-height: 14px;
padding: 5px 0 5px 18px;
}
a.button:active {
background-position: bottom right;
color: #000;
outline: none; /* hide dotted outline in Firefox */
}
a.button:active span {
background-position: bottom left;
padding: 6px 0 4px 18px; /* push text down 1px */
} 
</style> 
</head>
<body>
<div id='searchForm'></div>
<div id='userGrid'></div>
</body>
<%=getComboBoxStore()%>
<script type="text/javascript">
    var userGrid;
    function openAccount() {
        closeAccount();
    }

    function closeAccount() {
        var sm = userGrid.getSelectionModel();
        //��ȡѡ���������Ϣ
        var selectData = sm.getSelected();
        if (selectData == null) {
            alert('��ѡ��');
            return;
        }
        if(selectData.data.Status=='W1001'){
            if(!window.confirm("���ʺ���Ҫ����ɱ����Ƿ������"))
                return;
        }
        Ext.Msg.confirm("��ʾ��Ϣ", "�Ƿ����Ҫ��ѡ��Ĳֿ������", function callBack(id) {
            //�ж��Ƿ�ɾ������
            if (id == "yes") {
                //ҳ���ύ
                Ext.Ajax.request({
                    url: 'frmWmsClosedAccount.aspx?method=updateWarehouseAccount',
                    method: 'POST',
                    params: {
                        CaId: selectData.data.CaId,
                        ClosedTime:selectData.data.ClosedTime.dateFormat('Y/m/d')
                    },
                    success: function(resp, opts) {
                        if (checkExtMessage(resp)) {
                            userGrid.getStore().reload(); //ˢ��ҳ��
                        }
                    },
                    failure: function(resp, opts) {
                        Ext.Msg.alert("��ʾ", "������ʱ��");
                    }
                });
            }
        });
    }
    Ext.BLANK_IMAGE_URL = "../ext3/resources/images/default/s.gif";
    Ext.onReady(function() {
        var dsWarehouseList; //��λ������
        if (dsWarehouseList == null) { //��ֹ�ظ�����
            //alert(1);
            dsWarehouseList = new Ext.data.JsonStore({
                totalProperty: "result",
                root: "root",
                url: 'frmWmsClosedAccount.aspx?method=getWarehouseList',
                fields: ['WhId', 'WhName']
            });
            dsWarehouseList.load();

        }
        function updateDataGrid() {
            var OrgId = OrgPanel.getValue();
            var WhId = WhPanel.getValue();

            userGridData.baseParams.OrgId = OrgId;
            userGridData.baseParams.WhId = WhId;

            userGridData.load({
                params: {
                    start: 0,
                    limit: 10
                }
            });
        }



        String.prototype.trim = function() {
            // ��������ʽ��ǰ��ո�  
            // �ÿ��ַ��������  
            return this.replace(/(^\s*)|(\s*$)/g, "");
        }

        /*------�������ý������ݵĺ��� End---------------*/

        /*------��ʼ��ѯform�ĺ��� start---------------*/

        var OrgPanel = new Ext.form.ComboBox({
            fieldLabel: '�ֹ�˾',
            name: 'orgCombo',
            store: dsOrgList,
            displayField: 'OrgName',
            valueField: 'OrgId',
            typeAhead: true, //�Զ�����һ����������ѡ�ȫ����
            //triggerAction: 'all',
            emptyText: '��ѡ��ֹ�˾',
            selectOnFocus: true,
            forceSelection: true,
            anchor: '90%',
            mode: 'local',
            editable: false,
			disabled:true,
            value:<%=ZJSIG.UIProcess.ADM.UIAdmUser.OrgID(this) %>,
            listeners: { specialkey: function(f, e) { if (e.getKey() == e.ENTER) { Ext.getCmp('SWhName').focus(); } },
                select: function(combo, record, index) {
                    var curOrgId = OrgPanel.getValue();
                    dsWarehouseList.load({
                        params: {
                            OrgId: curOrgId
                        }
                    });
                    Ext.getCmp('SWhName').setValue("��ѡ��ֿ�");
                }
            }

        });


        var WhPanel = new Ext.form.ComboBox({
            fieldLabel: '�ֿ�����',
            name: 'warehouseCombo',
            store: dsWarehouseList,
            displayField: 'WhName',
            valueField: 'WhId',
            typeAhead: true, //�Զ�����һ����������ѡ�ȫ����
            triggerAction: 'all',
            emptyText: '��ѡ��ֿ�',
            selectOnFocus: true,
            forceSelection: true,
            anchor: '90%',
            mode: 'local',
            id: 'SWhName',
            listeners: { specialkey: function(f, e) { if (e.getKey() == e.ENTER) { Ext.getCmp('searchebtnId').focus(); } } }
        });

        var serchform = new Ext.FormPanel({
            renderTo: 'searchForm',
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
                        OrgPanel
                    ]
                }, {
                    columnWidth: .3,
                    layout: 'form',
                    border: false,
                    items: [
                        WhPanel
                        ]
                }, {
                    columnWidth: .2,
                    layout: 'form',
                    border: false,
                    items: [{ cls: 'key',
                        xtype: 'button',
                        text: '��ѯ',
                        id: 'searchebtnId',
                        anchor: '50%',
                        handler: function() {
                            updateDataGrid();
                        }
}]
}, {
                    columnWidth: .2,
                    layout: 'form',
                    border: false,
                    items: [{ cls: 'key',
                        xtype: 'button',
                        text: 'ҵ�����',
                        id: 'searchebtnId',
                        anchor: '50%',
                        handler: function() {
                            window.open("../Common/frmCurrentBusinessInformation.aspx");
                        }
}]
}]
}]
                    });


                    /*------��ʼ��ѯform�ĺ��� end---------------*/

                    /*------��ʼ��ȡ���ݵĺ��� start---------------*/
                    var userGridData = new Ext.data.Store
                        ({
                            url: 'frmWmsClosedAccount.aspx?method=getCloseAccountListInfo',
                            reader: new Ext.data.JsonReader({
                                totalProperty: 'totalProperty',
                                root: 'root'
                            }, [
	                        {
	                            name: 'CaId'
	                        },
	                        {
	                            name: 'WhId'
	                        },
	                        {
	                            name: 'ClosedTime',type:'date'
	                        },
	                        {
	                            name: 'OrgId'
	                        },
	                        {
	                            name: 'UpdateDate'
	                        },
	                        {
	                            name: 'CreateDate'
	                        },
	                        {
	                            name: 'OperId'
	                        },
	                        {
	                            name: 'OwnerId'
	                        },
	                        {
	                            name: 'Status'
	                        },
	                        {
	                            name: 'CloseYear'
	                        },
	                        {
	                            name: 'CloseMonth'

	                        },
	                        {
	                            name: 'WhCode'
	                        },
	                        {
	                            name: 'WhName'
	                        },
	                        {
	                            name: 'OrgName'
	                        },
	                        {
	                            name: 'OperName'
	                        }

                            ])
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
                    userGrid = new Ext.grid.EditorGridPanel({
                        el: 'userGrid',
                        width: document.body.offsetWidth,
                        height: '100%',
                        //autoWidth: true,
                        //autoHeight: true,
                        autoScroll: true,
                        layout: 'fit',
                        id: '',
                        columnLines:true,
                        clicksToEdit: 1,
                        store: userGridData,
                        loadMask: { msg: '���ڼ������ݣ����Ժ��' },
                        sm: sm,
                        cm: new Ext.grid.ColumnModel([
	                            sm,
	                            new Ext.grid.RowNumberer(), //�Զ��к�
	                            {
	                            header: '����ID',
	                            dataIndex: 'CaId',
	                            id: 'CaId',
	                            hidden: true,
	                            hideable: false
	                        },
	                            {
	                                header: '�ֿ���',
	                                dataIndex: 'WhCode',
	                                id: 'WhCode',
	                                width:70
	                            },
	                            {
	                                header: '�ֿ�����',
	                                dataIndex: 'WhName',
	                                id: 'WhName',
	                                width:120
	                            },
//	                            {
//	                                header: '�ֹ�˾',
//	                                dataIndex: 'OrgName',
//	                                id: 'OrgName'
//	                            },
	                            {
	                                header: '�������',
	                                dataIndex: 'CloseYear',
	                                id: 'CloseYear',
	                                width:70
	                            },
	                            {
	                                header: '�����·�',
	                                dataIndex: 'CloseMonth',
	                                id: 'CloseMonth',
	                                width:70
	                            },
	                            {
	                                header: '������',
	                                dataIndex: 'OperName',
	                                id: 'OperName',
	                                width:80
	                            },
	                            {
	                                header: '��������',
	                                dataIndex: 'ClosedTime',
	                                id: 'ClosedTime',
	                                width:150,
	                                editor: new Ext.form.DateField({
	                                            format:'Y��m��d��', 
	                                            altFormats:'Y��m��d��',
	                                            listeners: {
	                                                select : function(o){ 
	                                                    var selectData = userGrid.getSelectionModel().getSelected();
                                                        if(selectData){
                                                            var oldValue = selectData.data.ClosedTime;
                                                            if(oldValue!=o.getValue()){                                                                
                                                                userGrid.stopEditing();
                                                                userGrid.getView().refresh();
                                                                Ext.Ajax.request({
                                                                url: 'frmWmsClosedAccount.aspx?method=updateCloseAccountTime',
                                                                method: 'POST',
                                                                params: {
                                                                    CaId: selectData.data.CaId,
                                                                    ClosedTime:o.getValue().dateFormat('Y/m/d')
                                                                }
                                                                ,success: function(resp,opts){                                     
                                                                    if (!checkExtMessage(resp)) {
                                                                       selectData.set('ClosedTime',oldValue); 
                                                                       userGrid.getStore().commitChanges();
                                                                     }
                                                                }
                                                                ,failure: function(resp, opts) {
                                                                    selectData.set('ClosedTime',oldValue);
                                                                }
                                                            });
                                                            }
                                                        }
	                                                }
	                                            }
	                                        }), 
                                    renderer: function (value) {
                                        if (value instanceof Date) {
                                            return new Date(value).dateFormat('Y��m��d��');
                                        }
                                        // ԭ�ⲻ�ӵĂ���ȥ��ͨ����һ�_ʼָ����ֵ��������������̎��
                                        return value;
                                    }                                
	                            },
	                            {
	                                header: '����״̬',
	                                dataIndex: 'Status',
	                                id: 'Status',
	                                renderer: function(val) {
	                                    if (val == 'W1001') return 'δ����'; if (val == 'W1002') return '�ѹ���';
	                                }
	                            },
	                            {
	                                header: '����',
	                                dataIndex: 'Status',
	                                id: 'operate',
	                                renderer: function(val) {
	                                    //if (val == 'W1001') return '<div><input type=button onclick="closeAccount();" value="����" /></div>'; if (val == 'W1002') return '<div><input type=button onclick="openAccount();" value="ȡ������" /></div>';
	                                    if (val == 'W1001') return '<div><a class="button" href="#" onclick="closeAccount();"><span>����</span></a> </div>';
	                                    if (val == 'W1002') return '<div><a class="button" href="#" onclick="openAccount();"><span>ȡ������</span></a></div>';
	                                }

	                            }
]),
                        bbar: new Ext.PagingToolbar({
                            pageSize: 10,
                            store: userGridData,
                            displayMsg: '��ʾ��{0}����{1}����¼,��{2}��',
                            emptyMsy: 'û�м�¼',
                            displayInfo: true
                        }),
                        viewConfig: {
                            columnsText: '��ʾ����',
                            scrollOffset: 20,
                            sortAscText: '����',
                            sortDescText: '����',
                            forceFit: false 
                        },
                        height: 380,
                        closeAction: 'hide',
                        stripeRows: true,
                        loadMask: true//
                        //autoExpandColumn: 6
                    });
                    userGrid.render();
                    /*------DataGrid�ĺ������� End---------------*/

                    updateDataGrid();

                })
</script>

</html>
