<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmAdmDeptList.aspx.cs" Inherits="BA_sysadmin_frmAdmDeptList" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>���Ź���</title>
    <meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<link rel="stylesheet" type="text/css" href="../../ext3/resources/css/ext-all.css" />
<script type="text/javascript" src="../../ext3/adapter/ext/ext-base.js"></script>
<script type="text/javascript" src="../../ext3/ext-all.js"></script>
<script type="text/javascript" src="../../ext3/example/ColumnNodeUI.js"></script>
<link rel="Stylesheet" type="text/css" href="../../ext3/example/ColumnNodeUI.css" />
<script type="text/javascript" src="../../js/operateResp.js"></script>
<script type="text/javascript" src="../../js/ExtJsHelper.js"></script>
</head>
<%=getComboBoxSource() %>
<%=OrgInformation %>
<script type="text/javascript">
    var imageUrl = "../../Theme/1/";

    Ext.onReady(function() {
    Ext.BLANK_IMAGE_URL = "../../ext3/resources/images/default/s.gif";
    var saveType = "";
    var formTitle = "";
    Ext.QuickTips.init();//��������ʾ
    Ext.form.Field.prototype.msgTarget ='side';//������ʾ��Ϣλ��Ϊ����
    /*------ʵ��toolbar�ĺ��� start---------------*/
    var Toolbar = new Ext.Toolbar({
        //renderTo: "toolbar",
        region: "north",
        height: 25,
        items: [{
            text: "����",
            icon: imageUrl + "images/extjs/customer/add16.gif",
            handler: function() {
                saveType = "add";
                openAddDeptWin();
                AddKeyDownEvent('deptForm');
            }
        }, '-', {
            text: "�����Ӳ���",
            icon: imageUrl + "images/extjs/customer/add16.gif",
            handler: function() {
//                var sm = Ext.getCmp('deptGrid').getSelectionModel();
//                //��ȡѡ���������Ϣ
//                var selectData = sm.getSelected();
//                if (selectData == null) {
//                    Ext.Msg.alert("��ʾ", "��ѡ����Ҫ����Ӳ��ŵĲ�����Ϣ��");
//                    return;
//                }
                if (tree.selModel.selNode == null) {
                        Ext.Msg.alert("��ʾ", "��ѡ����Ҫ����Ӳ��ŵĲ�����Ϣ��");
                        return;
                    }
                saveType = "add";
                openAddDeptWin();
                Ext.getCmp('DeptParent').setValue(tree.selModel.selNode.id);
                Ext.getCmp('DeptParentName').setValue(tree.selModel.selNode.text);
                AddKeyDownEvent('deptForm');
                
            }
        }, '-', {
            text: "�༭",
            icon: imageUrl + "images/extjs/customer/edit16.gif",
            handler: function() {
                saveType = "editdept";
                modifyDeptWin();
                AddKeyDownEvent('deptForm');
                
            }
        }, '-', {
            text: "ɾ��",
            icon: imageUrl + "images/extjs/customer/delete16.gif",
            handler: function() {

                deleteDept();
            }
}]
        });

        /*------����toolbar�ĺ��� end---------------*/


        /*------��ʼToolBar�¼����� start---------------*//*-----����Deptʵ���ര�庯��----*/
        function openAddDeptWin() {
            Ext.getCmp('DeptId').setValue("");
            Ext.getCmp('DeptName').setValue("");
            Ext.getCmp('DeptCode').setValue("");
            Ext.getCmp('DeptParent').setValue("");
            Ext.getCmp('OrgId').setValue(orgId);
            Ext.getCmp('OrgName').setValue(orgName);
            Ext.getCmp("DeptType").setValue("");
            Ext.getCmp("DeptParentName").setValue("");
            //            Ext.getCmp('OperatorId').setValue("");
            //            Ext.getCmp('CreateDate').setValue("");
            //            Ext.getCmp('RecOrgId').setValue("");
            uploadDeptWindow.show();
        }
        /*-----�༭Deptʵ���ര�庯��----*/
        function modifyDeptWin() {
//            var sm = Ext.getCmp('deptGrid').getSelectionModel();
//            //��ȡѡ���������Ϣ
//            var selectData = sm.getSelected();
//            if (selectData == null) {
//                Ext.Msg.alert("��ʾ", "��ѡ����Ҫ�༭����Ϣ��");
//                return;
//            }
            if (tree.selModel.selNode == null) {
                        Ext.Msg.alert("��ʾ", "��ѡ����Ҫ�༭����Ϣ��");
                        return;
                    }
            uploadDeptWindow.show();
                setFormValue(tree.selModel.selNode.id);
            
        }
        /*-----ɾ��Deptʵ�庯��----*/
        /*ɾ����Ϣ*/
        function deleteDept() {
//            var sm = Ext.getCmp('deptGrid').getSelectionModel();
//            //��ȡѡ���������Ϣ
//            var selectData = sm.getSelected();
//            //���û��ѡ�񣬾���ʾ��Ҫѡ��������Ϣ
//            if (selectData == null) {
//                Ext.Msg.alert("��ʾ", "��ѡ����Ҫɾ������Ϣ��");
//                return;
//            }
            if (tree.selModel.selNode == null) {
                        Ext.Msg.alert("��ʾ", "��ѡ����Ҫɾ������Ϣ��");
                        return;
                    }
                    
            //ɾ��ǰ�ٴ������Ƿ����Ҫɾ��
            Ext.Msg.confirm("��ʾ��Ϣ", "�Ƿ����Ҫɾ��ѡ�����Ϣ��", function callBack(id) {
                //�ж��Ƿ�ɾ������
                if (id == "yes") {
                    //ҳ���ύ
                    Ext.Ajax.request({
                        url: 'frmAdmDeptList.aspx?method=deletedept',
                        method: 'POST',
                        params: {
                            DeptId: tree.selModel.selNode.id
                        },
                        success: function(resp, opts) {
                           if(checkExtMessage(resp))
                           {
                                //deptGridData.reload();
                                tree.root.reload();
                           }
                        },
                        failure: function(resp, opts) {
                            Ext.Msg.alert("��ʾ", "����ɾ��ʧ��");
                        }
                    });
                }
            });
        }

        /*------ʵ��FormPanle�ĺ��� start---------------*/
        var deptForm = new Ext.form.FormPanel({
            items: [
		{
		    xtype: 'hidden',
		    fieldLabel: '���ű�ʶ',
		    columnWidth: 1,
		    anchor: '90%',
		    name: 'DeptId',
		    id: 'DeptId'
		}
, {
    xtype: 'textfield',
    fieldLabel: '��������',
    columnWidth: 1,
    anchor: '90%',
    name: 'DeptName',
    id: 'DeptName',
    allowBlank:false,
    blankText: '�������Ʋ���Ϊ��'
}
, {
    xtype: 'textfield',
    fieldLabel: '���ű���',
    columnWidth: 1,
    anchor: '90%',
    name: 'DeptCode',
    id: 'DeptCode',
    allowBlank:false,
    blankText: '���ű��벻��Ϊ��'
}
, {
    xtype: 'hidden',
    fieldLabel: '�ϼ�����',
    columnWidth: 1,
    anchor: '90%',
    name: 'DeptParent',
    id: 'DeptParent',
    hidden:true
},{
    xtype: 'textfield',
    fieldLabel: '�ϼ�����',
    columnWidth: 1,
    anchor: '90%',
    readOnly:true,
    name: 'DeptParentName',
    id: 'DeptParentName'
}
, {
    xtype: 'hidden',
    fieldLabel: '��֯����',
    columnWidth: 1,
    anchor: '90%',
    name: 'OrgId',
    id: 'OrgId'
}
, {
    xtype: 'textfield',
    fieldLabel: '��������',
    columnWidth: 1,
    anchor: '90%',
    name: 'OrgName',
    id: 'OrgName'
}, {
    xtype: 'combo',
    fieldLabel: '�������',
    columnWidth: 1,
    anchor: '90%',
    name: 'DeptType',
    id: 'DeptType',
    editable:false,
    store: DeptTypeStore,
    displayField: 'DicsName',
    valueField: 'DicsCode',
    typeAhead: true,
    mode: 'local',
    emptyText: '��ѡ���������Ϣ',
    triggerAction: 'all'
}
]
        });
        /*------FormPanle�ĺ������� End---------------*/

        /*------��ʼ�������ݵĴ��� Start---------------*/
        if (typeof (uploadDeptWindow) == "undefined") {//�������2��windows����
            uploadDeptWindow = new Ext.Window({
                id: 'Deptformwindow',
                title: formTitle
		, iconCls: 'upload-win'
		, width: 450
		, height: 300
		, layout: 'fit'
		, plain: true
		, modal: true
		, x: 50
		, y: 50
		, constrain: true
		, resizable: false
		, closeAction: 'hide'
		, autoDestroy: true
		, items: deptForm
		, buttons: [{
		    text: "����"
			, handler: function() {
			    getFormValue();
			}
			, scope: this
		},
		{
		    text: "ȡ��"
			, handler: function() {
			    uploadDeptWindow.hide();
			}
			, scope: this
}]
            });
        }
        uploadDeptWindow.addListener("hide", function() {
        });

        /*------��ʼ��ȡ�������ݵĺ��� start---------------*/
        function getFormValue() {
            //���
	    if(!deptForm.form.isValid()) {
                Ext.Msg.alert("��ʾ", "�����Ƿ�������û����д");
                return;
            }

            Ext.MessageBox.wait('���ڱ���������, ���Ժ򡭡�');
            Ext.Ajax.request({
                url: 'frmAdmDeptList.aspx?method=' + saveType,
                method: 'POST',
                params: {
                    DeptId: Ext.getCmp('DeptId').getValue(),
                    DeptName: Ext.getCmp('DeptName').getValue(),
                    DeptCode: Ext.getCmp('DeptCode').getValue(),
                    DeptParent: Ext.getCmp('DeptParent').getValue(),
                    OrgId: Ext.getCmp('OrgId').getValue(),
                    DeptType: Ext.getCmp("DeptType").getValue()
                },
                success: function(resp, opts) {
                    Ext.MessageBox.hide();
                    if(checkExtMessage(resp))
                    {
                        uploadDeptWindow.hide();
                        deptGridData.reload();
                        tree.root.reload();
                    }
                },
                failure: function(resp, opts) {
                    Ext.MessageBox.hide();
                    Ext.Msg.alert("��ʾ", "����ʧ��");
                }
            });
        }
        /*------������ȡ�������ݵĺ��� End---------------*/

        /*------��ʼ�������ݵĺ��� Start---------------*/
        function setFormValue(selectData) {
            Ext.Ajax.request({
                url: 'frmAdmDeptList.aspx?method=getdept',
                params: {
                    DeptId: selectData
                },
                success: function(resp, opts) {
                    var data = Ext.util.JSON.decode(resp.responseText);
                    Ext.getCmp("DeptId").setValue(data.DeptId);
                    Ext.getCmp("DeptName").setValue(data.DeptName);
                    Ext.getCmp("DeptCode").setValue(data.DeptCode);
                    Ext.getCmp("DeptParent").setValue(data.DeptParent);
                    Ext.getCmp("OrgId").setValue(data.OrgId);
                    Ext.getCmp("OrgName").setValue(orgName);
                    //                    Ext.getCmp("OperatorId").setValue(data.OperatorId);
                    //                    Ext.getCmp("CreateDate").setValue(data.CreateDate);
                    //                    Ext.getCmp("RecOrgId").setValue(data.RecOrgId);
                    Ext.getCmp("DeptType").setValue(data.DeptType);
                    //                    if (data.DeptDispatching == 1) {
                    //                        Ext.getCmp("DeptDispatching").dom.checked = true;
                    //                    }
                    //                    else {
                    //                        Ext.getCmp("DeptDispatching").dom.checked = false;
                    //                    }
                    Ext.getCmp("DeptParentName").setValue(getParentDepart(data.DeptParent));
                },
                failure: function(resp, opts) {
                    Ext.Msg.alert("��ʾ", "��ȡ������Ϣʧ��");
                }
            });
        }
        /*------�������ý������ݵĺ��� End---------------*/

        /*------��ʼ��ȡ���ݵĺ��� start---------------*/
        var deptGridData = new Ext.data.Store
        ({
            url: 'frmAdmDeptList.aspx?method=getlist&orgid=' + orgId,
            reader: new Ext.data.JsonReader({
                totalProperty: 'totalProperty',
                root: 'root'
            }, [
        {
            name: 'DeptId'
        },
        	{
        	    name: 'DeptName'
        	},
        	{
        	    name: 'DeptCode'
        	},
        	{
        	    name: 'DeptParent'
        	},
        	{
        	    name: 'OrgId'
        	},
        	{
        	    name: 'OperatorId'
        	},
        	{
        	    name: 'CreateDate'
        	},
        	{
        	    name: 'RecOrgId'
},{name:'DeptType'}])
        	,
            listeners:
        	{
        	    scope: this,
        	    load: function() {
        	    }
        	}
        });

//        function loadData() {
//            deptGridData.load({
//                params: {
//                    start: 0,
//                    limit: 10,
//                    orgId: orgId
//                }
//            });
//        }
//        loadData();

        /*------��ȡ���ݵĺ��� ���� End---------------*/

        /*------��ʼDataGrid�ĺ��� start---------------*/

function getParentDepart(val)
{
    var index = deptGridData.find('DeptId', val);
                    if (index < 0)
                        return "";
                    var record = deptGridData.getAt(index);
                    return record.data.DeptName;
            
}

function cmbDeptType(val) {
                    var index = DeptTypeStore.find('DicsCode', val);
                    if (index < 0)
                        return "";
                    var record = DeptTypeStore.getAt(index);
                    return record.data.DicsName;
                }
        var sm = new Ext.grid.CheckboxSelectionModel({
            singleSelect: true
        });
        var deptGrid = new Ext.grid.GridPanel({
            //el: "deptGrid",
            //width: '100%',
            width:400,
            height: '100%',
            autoWidth: true,
            autoHeight: true,
            autoScroll: true,
            //layout: 'fit',
            region: "center",
            border: true,
            //                id: 'deptGrid',
            id: 'deptGrid',
            store: deptGridData,
            loadMask: { msg: '���ڼ������ݣ����Ժ��' },
            sm: sm,
            cm: new Ext.grid.ColumnModel([
        		sm,
        		new Ext.grid.RowNumberer(), //�Զ��к�
        		{
        		header: '���ű�ʶ',
        		dataIndex: 'DeptId',
        		id: 'DeptId',
        		hidden:true
      },
        		{
        		    header: '��������',
        		    dataIndex: 'DeptName',
        		    width:200,
        		    id: 'DeptName'
        		},
        		{
        		    header: '���ű���',
        		    dataIndex: 'DeptCode',
        		    width:200,
        		    id: 'DeptCode'
        		},
        		{
        		    header: '�ϼ�����',
        		    dataIndex: 'DeptParent',
        		    width:200,
        		    id: 'DeptParent',
        		    renderer:getParentDepart
        		},
        		{
        		    header: '��֯����',
        		    dataIndex: 'OrgId',
        		    width:200,
        		    id: 'OrgId'
        		},
        		{
        		    header: '�������',
        		    dataIndex: 'DeptType',
        		    id: 'DeptType',
        		    width:200,
        		    renderer:cmbDeptType
        		}
        ]),
            bbar: new Ext.PagingToolbar({
                pageSize: 10,
                store: deptGridData,
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

deptGrid.hide();
var tree = new Ext.ux.tree.ColumnTree({
                    width: 800,
                    height: 300,
                    rootVisible: false,
                    autoScroll: true,
                    title: '��Դ��Ϣ',
                    renderTo: 'orgDept',
                    id: 'treeColumn',

                    columns: [{
                        header: '��������',
                        width: 220,
                        dataIndex: 'text'
                    }, {
                        header: '���Ŵ���',
                        width: 100,
                        dataIndex: 'CustomerColumn'
                    }, {
                        header: '�������',
                        width: 200,
                        dataIndex: 'CustomerColumn1',
                         renderer:cmbDeptType
                    }],

                        loader: new Ext.tree.TreeLoader({
                            dataUrl: 'frmAdmDeptList.aspx?method=gettreecolumnlist',
                            uiProviders: {
                                'col': Ext.ux.tree.ColumnNodeUI
                            }
                        }),

                        root: new Ext.tree.AsyncTreeNode({
                            text: 'Tasks'
                        })
                    });
                    tree.render();
        //        var tree = new Ext.ux.tree.ColumnTree({
        //            width: 800,
        //            height: 300,
        //            rootVisible: false,
        //            autoScroll: true,
        //            title: '������Ϣ',
        //            renderTo: 'orgGrid',
        //            id: 'treeColumn',

        //            columns: [{
        //                header: '��������',
        //                width: 220,
        //                dataIndex: 'text'
        //            }, {
        //                header: '���ű��',
        //                width: 100,
        //                dataIndex: 'CustomerColumn'
        //}],

        //                loader: new Ext.tree.TreeLoader({
        //                    dataUrl: 'frmAdmOrgList.aspx?method=gettreecolumnlist',
        //                    uiProviders: {
        //                        'col': Ext.ux.tree.ColumnNodeUI
        //                    }
        //                }),

        //                root: new Ext.tree.AsyncTreeNode({
        //                    text: 'Tasks'
        //                })
        //            });
        //            tree.render();
        //deptGrid.render();
        /*------DataGrid�ĺ������� End---------------*/

        /*---------��������ֲ���Ϣ-----------------*/

        //{ title: "�˵�", region: "west", width: 200, collapsible: true, html: "�˵���" },
        new Ext.Viewport({ layout: 'border', items: [
            Toolbar, deptGrid]
        })

    })
</script>
<body>
    <form id="form1" runat="server">
    <div id='toolbar'></div>
<div id='divForm'></div>
<div id='deptGrid'></div>
<div id='orgDept'></div>
    </form>
</body>
</html>
