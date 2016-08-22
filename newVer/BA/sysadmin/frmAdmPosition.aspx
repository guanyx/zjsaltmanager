<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmAdmPosition.aspx.cs" Inherits="BA_sysadmin_frmAdmPosition" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>�ޱ���ҳ</title>
    <meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<link rel="stylesheet" type="text/css" href="../../ext3/resources/css/ext-all.css" />
<script type="text/javascript" src="../../ext3/adapter/ext/ext-base.js"></script>
<script type="text/javascript" src="../../ext3/ext-all.js"></script>
<script type="text/javascript" src="../../js/operateResp.js"></script>
<script type="text/javascript" src="../../js/ExtJsHelper.js"></script>
<script type="text/javascript" src="../../js/RouteSelectChen.js"></script>
</head>
<%=getComboBoxSource() %>
<%=OrgInformation %>
<script type="text/javascript">
var imageUrl = "../../Theme/1/";
Ext.onReady(function() {
    Ext.BLANK_IMAGE_URL = "../../ext3/resources/images/default/s.gif";
    var saveType = "";
    var formTitle = "";
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
                openAddPositionWin();
                Ext.getCmp('DeptId').setDisabled(false);
                Ext.getCmp('PositionParent').setValue("");
                Ext.getCmp('PositionParentName').setValue("");
                AddKeyDownEvent('PositionForm');
            }
        }, '-', {
            text: "�����Ӹ�λ",
            icon: imageUrl + "images/extjs/customer/add16.gif",
            handler: function() {
                var sm = Ext.getCmp('PositionGrid').getSelectionModel();
                //��ȡѡ���������Ϣ
                var selectData = sm.getSelected();
                if (selectData == null) {
                    Ext.Msg.alert("��ʾ", "��ѡ����Ҫ����Ӹ�λ�ĸ�λ��Ϣ��");
                    return;
                }
                Ext.getCmp('DeptId').setDisabled(true);
                saveType = "add";
                openAddPositionWin();
                Ext.getCmp('PositionParent').setValue(selectData.data.PositionId);
                Ext.getCmp('PositionParentName').setValue(selectData.data.PositionName);
                Ext.getCmp('DeptId').setValue(selectData.data.DeptId);
                AddKeyDownEvent('PositionForm');

            }
        }, '-', {
            text: "�༭",
            icon: imageUrl + "images/extjs/customer/edit16.gif",
            handler: function() {
                saveType = "editposition";
                Ext.getCmp('DeptId').setDisabled(true);
                modifyPositionWin();
                AddKeyDownEvent('PositionForm');

            }
        }, '-', {
            text: "ɾ��",
            icon: imageUrl + "images/extjs/customer/delete16.gif",
            handler: function() {

                deletePosition();
            }
        }, '-', {
            text: "���ÿͻ�����",
            icon: imageUrl + "images/extjs/customer/edit16.gif",
            handler: function() {
                //���ÿͻ���������Ͻ�Ŀͻ�����
                setPositionArea();
            }
}]
        });

        /*------����toolbar�ĺ��� end---------------*/

var urlRoute = 'frmAdmPosition.aspx?method=getPositionRoute&positionId=';
function setPositionArea()
{
    var sm = Ext.getCmp('PositionGrid').getSelectionModel();
    //��ȡѡ���������Ϣ
    var selectData = sm.getSelected();
    if (selectData == null) {
        Ext.Msg.alert("��ʾ", "��ѡ����Ҫ���õ���Ϣ��");
        return;
    }
    var positionId = selectData.data.PositionId;
    if(selectRouteForm==null)
    {
        showRouteForm("","��·ѡ��",urlRoute+positionId);
        Ext.getCmp("btnRouteOk").on("click",addRoute);
    }
    else
    {
        tree_refresh(positionId);
        selectRouteForm.show();
    }
}

function addRoute()
{
    var sm = Ext.getCmp('PositionGrid').getSelectionModel();
    //��ȡѡ���������Ϣ
    var selectData = sm.getSelected();
    if (selectData == null) {
        Ext.Msg.alert("��ʾ", "��ѡ����Ҫ���õ���Ϣ��");
        return;
    }
    getRouteSelectNodes();
    //ҳ���ύ
    Ext.Ajax.request({
        url: 'frmAdmPosition.aspx?method=savePositionRoute',
        method: 'POST',
        params: {
            PositionId: selectData.data.PositionId,
            RouteIds:selectedRouteID
        },
        success: function(resp, opts) {
            if (checkExtMessage(resp)) {
               
            }
        },
        failure: function(resp, opts) {
            Ext.Msg.alert("��ʾ", "��·����ʧ��");
        }
    });
                    
}
function tree_refresh(positionId){
   var tree = Ext.getCmp('selectRouteTree');
   var loader = new Ext.tree.TreeLoader({dataUrl:urlRoute+positionId});
   loader.load(tree.root);
}
        /*------��ʼToolBar�¼����� start---------------*//*-----����Positionʵ���ര�庯��----*/
        function openAddPositionWin() {
            Ext.getCmp('PositionId').setValue("");
            Ext.getCmp('PositionName').setValue("");
            Ext.getCmp('PositionSort').setValue("");
            Ext.getCmp('PositionMemo').setValue("");
            Ext.getCmp('PositionParent').setValue("");
            Ext.getCmp('PositionType').setValue("");
            Ext.getCmp('PositionRole').setValue("");
            Ext.getCmp('OrgId').setValue(orgId);
            Ext.getCmp("DeptId").setValue("");
            Ext.getCmp('OrgName').setValue(orgName);
            //Ext.getCmp("DeptName").setValue("");
            if (currentNode != null) {
                Ext.getCmp("DeptId").setValue(currentNode.id.substring(4));
                //Ext.getCmp("DeptName").setValue(currentNode.text);
            }
            //            Ext.getCmp('OperatorId').setValue("");
            //            Ext.getCmp('CreateDate').setValue("");
            //            Ext.getCmp('RecOrgId').setValue("");
            uploadPositionWindow.show();
        }
        /*-----�༭Positionʵ���ര�庯��----*/
        function modifyPositionWin() {
            var sm = Ext.getCmp('PositionGrid').getSelectionModel();
            //��ȡѡ���������Ϣ
            var selectData = sm.getSelected();
            if (selectData == null) {
                Ext.Msg.alert("��ʾ", "��ѡ����Ҫ�༭����Ϣ��");
                return;
            }
            uploadPositionWindow.show();
            setFormValue(selectData);
        }
        /*-----ɾ��Positionʵ�庯��----*/
        /*ɾ����Ϣ*/
        function deletePosition() {
            var sm = Ext.getCmp('PositionGrid').getSelectionModel();
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
                        url: 'frmAdmPosition.aspx?method=deleteposition',
                        method: 'POST',
                        params: {
                            PositionId: selectData.data.PositionId
                        },
                        success: function(resp, opts) {
                            if (checkExtMessage(resp)) {
                                PositionGridData.reload();
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
        var PositionForm = new Ext.form.FormPanel({
            items: [
		{
		    xtype: 'hidden',
		    fieldLabel: '��λ��ʶ',
		    columnWidth: 1,
		    anchor: '90%',
		    name: 'PositionId',
		    id: 'PositionId'
		}
, {
    xtype: 'textfield',
    fieldLabel: '��λ����',
    columnWidth: 1,
    anchor: '90%',
    name: 'PositionName',
    id: 'PositionName'
}, {
    xtype: 'combo',
    fieldLabel: '��λ���',
    columnWidth: 1,
    anchor: '90%',
    name: 'PositionType',
    id: 'PositionType',
    editable: false,
    store: typeStore,
    displayField: 'DicsName',
    valueField: 'DicsCode',
    typeAhead: true,
    mode: 'local',
    emptyText: '��ѡ���λ�����Ϣ',
    triggerAction: 'all'

}
, {
    xtype: 'textfield',
    fieldLabel: '��Ӧ��ɫ',
    columnWidth: 1,
    anchor: '90%',
    name: 'PositionRole',
    id: 'PositionRole'

}
, {
    xtype: 'textfield',
    fieldLabel: '���',
    columnWidth: 1,
    anchor: '90%',
    name: 'PositionSort',
    id: 'PositionSort'
}
, {
    xtype: 'hidden',
    fieldLabel: '�ϼ���λ',
    columnWidth: 1,
    anchor: '90%',
    name: 'PositionParent',
    id: 'PositionParent',
    hidden: true
}, {
    xtype: 'textfield',
    fieldLabel: '�ϼ���λ',
    columnWidth: 1,
    anchor: '90%',
    readOnly: true,
    name: 'PositionParentName',
    id: 'PositionParentName'
}, {
    xtype: 'combo',
    fieldLabel: '����',
    columnWidth: 1,
    anchor: '90%',
    name: 'DeptId',
    id: 'DeptId',
    editable: false,
    store: DeptStore,
    displayField: 'DeptName',
    valueField: 'DeptId',
    typeAhead: true,
    mode: 'local',
    emptyText: '��ѡ������Ϣ',
    triggerAction: 'all'

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
    xtype: 'textarea',
    fieldLabel: '��λ˵��',
    columnWidth: 1,
    anchor: '90%',
    name: 'PositionMemo',
    id: 'PositionMemo'
}
]
        });
        /*------FormPanle�ĺ������� End---------------*/

        /*------��ʼ�������ݵĴ��� Start---------------*/
        if (typeof (uploadPositionWindow) == "undefined") {//�������2��windows����
            uploadPositionWindow = new Ext.Window({
                id: 'Positionformwindow',
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
		, items: PositionForm
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
			    uploadPositionWindow.hide();
			}
			, scope: this
}]
            });
        }
        uploadPositionWindow.addListener("hide", function() {
        });

        /*------��ʼ��ȡ�������ݵĺ��� start---------------*/
        function getFormValue() {
            if (Ext.getCmp("DeptId").getValue() == "") {
                Ext.Msg.alert("�����ĸ�λ��Ϣû��ѡ������Ϣ��");
                return;
            }
            Ext.MessageBox.wait('���ڱ���������, ���Ժ򡭡�');
            Ext.Ajax.request({
                url: 'frmAdmPosition.aspx?method=' + saveType,
                method: 'POST',
                params: {
                    PositionId: Ext.getCmp('PositionId').getValue(),
                    PositionName: Ext.getCmp('PositionName').getValue(),
                    PositionSort: Ext.getCmp('PositionSort').getValue(),
                    PositionParent: Ext.getCmp('PositionParent').getValue(),
                    OrgId: Ext.getCmp('OrgId').getValue(),
                    DeptId: Ext.getCmp("DeptId").getValue(),
                    PositionMemo: Ext.getCmp("PositionMemo").getValue(),
                    PositionType: Ext.getCmp("PositionType").getValue(),
                    PositionRole: ''
                },
                success: function(resp, opts) {
                    Ext.MessageBox.hide();
                    if (checkExtMessage(resp)) {
                        uploadPositionWindow.hide();
                        PositionGridData.reload();
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
                url: 'frmAdmPosition.aspx?method=getposition',
                params: {
                    PositionId: selectData.data.PositionId
                },
                success: function(resp, opts) {
                    var data = Ext.util.JSON.decode(resp.responseText);
                    Ext.getCmp("PositionId").setValue(data.PositionId);
                    Ext.getCmp("PositionName").setValue(data.PositionName);
                    Ext.getCmp("PositionSort").setValue(data.PositionSort);
                    Ext.getCmp("PositionParent").setValue(data.PositionParent);
                    Ext.getCmp("OrgId").setValue(data.OrgId);
                    Ext.getCmp("OrgName").setValue(orgName);
                    Ext.getCmp("DeptId").setValue(data.DeptId);
                    Ext.getCmp("PositionMemo").setValue(data.PositionMemo);
                    Ext.getCmp("PositionType").setValue(data.PositionType);

                },
                failure: function(resp, opts) {
                    Ext.Msg.alert("��ʾ", "��ȡ��λ��Ϣʧ��");
                }
            });
        }
        /*------�������ý������ݵĺ��� End---------------*/

        /*------��ʼ��ȡ���ݵĺ��� start---------------*/
        var PositionGridData = new Ext.data.Store
        ({
            url: 'frmAdmPosition.aspx?method=getlist&orgid=' + orgId,
            reader: new Ext.data.JsonReader({
                totalProperty: 'totalProperty',
                root: 'root'
            }, [
        {
            name: 'PositionId'
        },
        	{
        	    name: 'PositionName'
        	},
        	{
        	    name: 'PositionSort'
        	},
        	{
        	    name: 'PositionParent'
        	},
        	{
        	    name: 'PositionParentName'
        	},
        	{
        	    name: 'OrgId'
        	},
        	{
        	    name: 'OrgName'
        	},
        	{
        	    name: 'DeptName'
        	},
        	{
        	    name: 'DeptId'
}])
        	,
            listeners:
        	{
        	    scope: this,
        	    load: function() {
        	    }
        	}
        });

        function loadData() {
            PositionGridData.load({
                params: {
                    start: 0,
                    limit: 10,
                    orgId: orgId
                }
            });
        }
        loadData();

        /*------��ȡ���ݵĺ��� ���� End---------------*/

        /*------��ʼDataGrid�ĺ��� start---------------*/

        function getParentDepart(val) {
            var index = PositionGridData.find('PositionId', val);
            if (index < 0)
                return "";
            var record = PositionGridData.getAt(index);
            return record.data.PositionName;

        }


        var sm = new Ext.grid.CheckboxSelectionModel({
            singleSelect: true
        });
        var PositionGrid = new Ext.grid.GridPanel({
            //el: "PositionGrid",
            //width: '100%',
            width: 400,
            height: '100%',
            autoWidth: true,
            autoHeight: true,
            autoScroll: true,
            //layout: 'fit',
            region: "center",
            border: true,
            //                id: 'PositionGrid',
            id: 'PositionGrid',
            store: PositionGridData,
            loadMask: { msg: '���ڼ������ݣ����Ժ��' },
            sm: sm,
            cm: new Ext.grid.ColumnModel([
        		sm,
        		new Ext.grid.RowNumberer(), //�Զ��к�
        		{
        		header: '��λ��ʶ',
        		dataIndex: 'PositionId',
        		id: 'PositionId',
        		hidden: true
      },
        		{
        		    header: '��λ����',
        		    dataIndex: 'PositionName',
        		    width: 200,
        		    id: 'PositionName'
        		},
        		{
        		    header: '����',
        		    dataIndex: 'PositionSort',
        		    width: 200,
        		    id: 'PositionSort'
        		},
        		{
        		    header: '�ϼ���λ',
        		    dataIndex: 'PositionParentName',
        		    width: 200,
        		    id: 'PositionParentName'
        		},
        		{
        		    header: '��֯����',
        		    dataIndex: 'OrgName',
        		    width: 200,
        		    id: 'OrgName'
        		},
        		{
        		    header: '����',
        		    dataIndex: 'DeptName',
        		    id: 'DeptName',
        		    width: 200
        		}
        ]),
            bbar: new Ext.PagingToolbar({
                pageSize: 10,
                store: PositionGridData,
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
        //PositionGrid.render();
        /*------DataGrid�ĺ������� End---------------*/

        /*---------��������ֲ���Ϣ-----------------*/

        //{ title: "�˵�", region: "west", width: 200, collapsible: true, html: "�˵���" },

        var root = new Ext.tree.AsyncTreeNode({
            text: '������Ϣ',
            draggable: false,
            id: 'source'
        });

        var url = 'frmAdmPosition.aspx?method=getorgdepttree&orgid=' + orgId;
        var selectDeptTree = new Ext.tree.TreePanel({//����������������"�ؼ�"��
            //el: "divTree",//��page��������Ⱦ�ı�ǩ(����)
            useArrows: true,
            autoScroll: true,
            animate: true,
            enableDD: true,
            containerScroll: true,
            region: 'west',
            width: 150,
            //rootVisible: false,
            loader: new Ext.tree.TreeLoader({
                //dataUrl: url, // 'frmAdmEmpList.aspx?method=gettreecolumnlist&parent=' + parentID,
                dataUrl: url
            }),

            root: root
        });

        var currentNode = null;
        //��beforeload�¼�������dataUrl���Դﵽ��̬���ص�Ŀ��
        selectDeptTree.on('beforeload', function(node) {
            selectDeptTree.loader.dataUrl = url + '&nodeid=' + node.id + '&nodeType=' + node.attributes.NodeType;
        });

        var filterStore = new Ext.data.SimpleStore({
            fields: ['ColumnName', 'Compare', 'ColumnValue'],
            data: [
   ['OrgId', '4', orgId],
   ['DeptId', '4', '0']
   ]
        });

        selectDeptTree.on('click', function(node) {
            if (node.attributes.NodeType == 'dept') {
                currentNode = node;
                filterStore.data.items[1].data.ColumnValue = node.id.substring(4);
                //alert(filterStore.data.items[1].data.ColumnValue);
                var json = "";
                filterStore.each(function(filterStore) {
                    json += Ext.util.JSON.encode(filterStore.data) + ',';
                });
                json = json.substring(0, json.length - 1);
                PositionGridData.baseParams.filter = json;
                PositionGridData.baseParams.limit = 10;
                PositionGridData.baseParams.start = 0;
                PositionGridData.load();
            }
        });


        new Ext.Viewport({ layout: 'border', items: [selectDeptTree,
            Toolbar, PositionGrid]
        })

    })
</script>
<body>
    <form id="form1" runat="server">
    <div id='toolbar'></div>
<div id='divForm'></div>
<div id='PositionGrid'></div>
    </form>
</body>
</html>

