<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmWmsProductCostAlg.aspx.cs" Inherits="WMS_frmWmsProductCostAlg" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html>
<head>
<title>��Ʒ�ɱ��㷨ά��</title><meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<link rel="stylesheet" type="text/css" href="../ext3/resources/css/ext-all.css" />
<script type="text/javascript" src="../ext3/adapter/ext/ext-base.js"></script>
<script type="text/javascript" src="../ext3/ext-all.js"></script>
<script type="text/javascript" src="../js/operateResp.js"></script>
</head>
<body>
<div id='toolbar'></div>
<div id='searchForm'></div>
<div id='dataGrid'></div>

</body>

<script type="text/javascript">

    Ext.BLANK_IMAGE_URL = "../ext3/resources/images/default/s.gif";
Ext.onReady(function() {
    /*------ʵ��toolbar�ĺ��� start---------------*/
    var Toolbar = new Ext.Toolbar({
        renderTo: "toolbar",
        items: [{
            text: "����",
            icon: "../Theme/1/images/extjs/customer/add16.gif",
            handler: function() {
                openAddAlgWin();
            }
        }, '-', {
            text: "�༭",
            icon: "../Theme/1/images/extjs/customer/edit16.gif",
            handler: function() {
                modifyAlgWin();
            }
        }, '-', {
            text: "ɾ��",
            icon: "../Theme/1/images/extjs/customer/delete16.gif",
            handler: function() {
                deleteAlg();
            }
}]
        });

        /*------����toolbar�ĺ��� end---------------*/


        /*------��ʼToolBar�¼����� start---------------*//*-----����Algʵ���ര�庯��----*/
        function openAddAlgWin() {
            uploadAlgWindow.show();
        }
        /*-----�༭Algʵ���ര�庯��----*/
        function modifyAlgWin() {
            var sm = dataAlgGrid.getSelectionModel();
            //��ȡѡ���������Ϣ
            var selectData = sm.getSelected();
            if (selectData == null) {
                Ext.Msg.alert("��ʾ", "��ѡ����Ҫ�༭����Ϣ��");
                return;
            }
            uploadAlgWindow.show();
            setFormValue(selectData);
        }
        /*-----ɾ��Algʵ�庯��----*/
        /*ɾ����Ϣ*/
        function deleteAlg() {
            var sm = dataAlgGrid.getSelectionModel();
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
                        url: 'frmWmsProductCostAlg.aspx?method=deleteAlg',
                        method: 'POST',
                        params: {
                            AlgorithmId: selectData.data.AlgorithmId
                        },
                        success: function(resp, opts) {
                            if (checkExtMessage(resp)) {
                                updateDataGrid();
                            }
                        }
                    });
                }
            });
        }

        /*------ʵ��FormPanle�ĺ��� start---------------*/
        var AlgForm = new Ext.form.FormPanel({
            url: '',
            //renderTo:'divForm',
            frame: true,
            title: '',
            labelWidth: 55,
            items: [
		{
		    xtype: 'hidden',
		    fieldLabel: '�ɱ��㷨ID',
		    columnWidth: 1,
		    anchor: '95%',
		    name: 'AlgorithmId',
		    id: 'AlgorithmId',
		    hidden: true,
		    hideLabel: true
		}
, {
    xtype: 'textfield',
    fieldLabel: '�㷨����',
    columnWidth: 1,
    anchor: '95%',
    name: 'AlgorithmName',
    id: 'AlgorithmName'
}
, {
    xtype: 'textarea',
    fieldLabel: '�㷨��ʽ',
    columnWidth: 1,
    anchor: '95%',
    name: 'Formula',
    id: 'Formula'
}
, {
    xtype: 'textarea',
    fieldLabel: '��ע',
    columnWidth: 1,
    anchor: '95%',
    name: 'Remark',
    id: 'Remark'
}
]
        });
        /*------FormPanle�ĺ������� End---------------*/

        /*------��ʼ�������ݵĴ��� Start---------------*/
        if (typeof (uploadAlgWindow) == "undefined") {//�������2��windows����
            uploadAlgWindow = new Ext.Window({
                id: 'Algformwindow',
                title: '��Ʒ�ɱ��㷨ά��'
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
		, items: AlgForm
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
			    uploadAlgWindow.hide();
			}
			, scope: this
}]
            });
        }
        uploadAlgWindow.addListener("hide", function() {
            AlgForm.getForm().reset();
            updateDataGrid();
        });

        /*------��ʼ��ȡ�������ݵĺ��� start---------------*/
        function saveUserData() {
            Ext.Ajax.request({
                url: 'frmWmsProductCostAlg.aspx?method=saveAlg',
                method: 'POST',
                params: {
                    AlgorithmId: Ext.getCmp('AlgorithmId').getValue(),
                    AlgorithmName: Ext.getCmp('AlgorithmName').getValue(),
                    Formula: Ext.getCmp('Formula').getValue(),
                    Remark: Ext.getCmp('Remark').getValue()
                },
                success: function(resp, opts) {                  
                    if (checkExtMessage(resp)) {
                        uploadAlgWindow.hide();
                    }
                }
            });
        }
        /*------������ȡ�������ݵĺ��� End---------------*/

        /*------��ʼ�������ݵĺ��� Start---------------*/
        function setFormValue(selectData) {
            Ext.Ajax.request({
                url: 'frmWmsProductCostAlg.aspx?method=getAlg',
                params: {
                    AlgorithmId: selectData.data.AlgorithmId
                },
                success: function(resp, opts) {
                    var data = Ext.util.JSON.decode(resp.responseText);
                    Ext.getCmp("AlgorithmId").setValue(data.AlgorithmId);
                    Ext.getCmp("AlgorithmName").setValue(data.AlgorithmName);
                    Ext.getCmp("Formula").setValue(data.Formula);
                    Ext.getCmp("Remark").setValue(data.Remark);
                },
                failure: function(resp, opts) {
                    Ext.Msg.alert("��ʾ", "��ȡ�㷨��Ϣʧ�ܣ�");
                }
            });
        }
        /*------�������ý������ݵĺ��� End---------------*/

        /*------��ʼ��ȡ���ݵĺ��� start---------------*/
        var dsAlg = new Ext.data.Store
({
    url: 'frmWmsProductCostAlg.aspx?method=getAlgList',
    reader: new Ext.data.JsonReader({
        totalProperty: 'totalProperty',
        root: 'root'
    }, [
	{ name: 'AlgorithmId' },
	{ name: 'AlgorithmName' },
	{ name: 'Formula' },
	{ name: 'Remark' }
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
        var dataAlgGrid = new Ext.grid.GridPanel({
            el: 'dataGrid',
            width: '100%',
            height: '100%',
            autoWidth: true,
            autoHeight: true,
            autoScroll: true,
            layout: 'fit',
            id: '',
            store: dsAlg,
            loadMask: { msg: '���ڼ������ݣ����Ժ��' },
            sm: sm,
            cm: new Ext.grid.ColumnModel([
		sm,
		new Ext.grid.RowNumberer(), //�Զ��к�
		{
		header: '�ɱ��㷨ID',
		dataIndex: 'AlgorithmId',
		id: 'AlgorithmId',
		hidden: true,
		hideable: false
},
		{
		    header: '�㷨����',
		    dataIndex: 'AlgorithmName',
		    id: 'AlgorithmName'
		},
		{
		    header: '�㷨��ʽ',
		    dataIndex: 'Formula',
		    id: 'Formula'
		},
		{
		    header: '��ע',
		    dataIndex: 'Remark',
		    id: 'Remark'
}]),
            bbar: new Ext.PagingToolbar({
                pageSize: 10,
                store: dsAlg,
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
        dataAlgGrid.render();

        function updateDataGrid() {
            dsAlg.reload({ params: { limit: 10, start: 0} });
        }
        /*------DataGrid�ĺ������� End---------------*/
        updateDataGrid();


    })
</script>

</html>

