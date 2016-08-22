<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmOrgDestinationCfg.aspx.cs" Inherits="SCM_frmOrgDestinationCfg" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>������վ��Ϣ����ά��</title>
    <meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<link rel="stylesheet" type="text/css" href="../ext3/resources/css/ext-all.css" />
<script type="text/javascript" src="../ext3/adapter/ext/ext-base.js"></script>
<script type="text/javascript" src="../ext3/ext-all.js"></script>
<script type="text/javascript" src="../js/FilterControl.js"></script>
</head>
<body>
<div id='toolbar'></div>
<div id='divForm'></div>
<div id='searchForm'></div>
<div id='orgCfgDiv'></div>
<%=getComboBoxStore() %>
</body>
<script>
Ext.onReady(function() {
var saveType = '';
Ext.BLANK_IMAGE_URL = "../ext3/resources/images/default/s.gif";
/*------ʵ��toolbar�ĺ��� start---------------*/
var Toolbar = new Ext.Toolbar({
    renderTo: "toolbar",
    items: [{
        text: "����",
        icon: "../Theme/1/images/extjs/customer/add16.gif",
        handler: function() {
            saveType = "add";
            openAddCfgWin();
        }
    }, '-', {
        text: "�༭",
        icon: "../Theme/1/images/extjs/customer/edit16.gif",
        handler: function() {
            saveType = "edit";
            modifyCfgWin();
        }
    }, '-', {
        text: "ɾ��",
        icon: "../Theme/1/images/extjs/customer/delete16.gif",
        handler: function() {
            deleteCfg();
        }
    }]
});

/*------����toolbar�ĺ��� end---------------*/


/*------��ʼToolBar�¼����� start---------------*//*-----����Cfgʵ���ര�庯��----*/
function openAddCfgWin() {
    Ext.getCmp('OrgShortName').setValue("");
    Ext.getCmp('OrgCode').setValue("");
    Ext.getCmp('OrgName').setValue("");
    Ext.getCmp('SendType').setValue("");
    //Ext.getCmp('SendTypeText').setValue("");
    uploadCfgWindow.show();
}
/*-----�༭Cfgʵ���ര�庯��----*/
function modifyCfgWin() {
    var sm = Ext.getCmp('orgCfg').getSelectionModel();
    //��ȡѡ���������Ϣ
    var selectData = sm.getSelected();
    if (selectData == null) {
        Ext.Msg.alert("��ʾ", "��ѡ����Ҫ�༭����Ϣ��");
        return;
    }
    uploadCfgWindow.show();
    setFormValue(selectData);
}
/*-----ɾ��Cfgʵ�庯��----*/
/*ɾ����Ϣ*/
function deleteCfg() {
    var sm = Ext.getCmp('orgCfg').getSelectionModel();
    //��ȡѡ���������Ϣ
    var selectData = sm.getSelected();
    //���û��ѡ�񣬾���ʾ��Ҫѡ��������Ϣ
    if (selectData == null) {
        Ext.Msg.alert("��ʾ", "��ѡ����Ҫɾ������Ϣ��");
        return;
    }
    //ɾ��ǰ�ٴ������Ƿ����Ҫɾ��
    Ext.Msg.confirm("��ʾ��Ϣ", "�Ƿ����Ҫɾ��ѡ��Ļ�����վ������Ϣ��", function callBack(id) {
        //�ж��Ƿ�ɾ������
        if (id == "yes") {
            //ҳ���ύ
            Ext.Ajax.request({
                url: 'frmOrgDestinationCfg.aspx?method=deleteCfg',
                method: 'POST',
                params: {
                    DestId: selectData.data.DestId
                },
                success: function(resp, opts) {
                    Ext.Msg.alert("��ʾ", "����ɾ���ɹ���");
                },
                failure: function(resp, opts) {
                    Ext.Msg.alert("��ʾ", "����ɾ��ʧ�ܣ�");
                }
            });
        }
    });
}

/*------ʵ��FormPanle�ĺ��� start---------------*/
var destform = new Ext.form.FormPanel({
    url: '',
    frame: true, 
    bodyStyle: 'padding:2px',
    frame: true,
    labelWidth: 70,
    items: [
	{
	    layout: 'column',
	    border: false,
	    labelSeparator: '��',
	    items: [
        {
            layout: 'form',
            border: false,
            columnWidth: 0.5,
            items:
			[{
			    xtype: 'hidden',
			    fieldLabel: '���',
			    columnWidth: 0.5,
			    anchor: '98%',
			    name: 'DestId',
			    id: 'DestId'
            },{
			    xtype: 'textfield',
			    fieldLabel: '��˾����',
			    columnWidth: 0.5,
			    anchor: '98%',
			    name: 'OrgCode',
			    id: 'OrgCode',
			    enableKeyEvents: true,  
                initEvents: function() {  
                     var keyPress = function(e){  
                         if (e.getKey() == e.ENTER) { 
                             Ext.Ajax.request({
                                 url: 'frmOrgDestinationCfg.aspx?method=getOrgInfo',
                                 params: {
                                    OrgCode: this.getValue()
                                 },
                                 success: function(resp, opts) {
                                     var data = Ext.util.JSON.decode(resp.responseText);
                                     Ext.getCmp("OrgId").setValue(data.OrgId);
                                     Ext.getCmp("OrgShortName").setValue(data.OrgShortName);
                                     Ext.getCmp("OrgName").setValue(data.OrgName);
                                     //Ext.getCmp("SendType").setValue(data.SendType);
                                 },
                                 failure: function(resp, opts) {
                                    Ext.Msg.alert("��ʾ", "��ȡ��˾��Ϣʧ��");
                                 }
                             });                             
                         }  
                     };  
                     this.el.on("keypress", keyPress, this);  
                } 
            }]
        },
		{
		    layout: 'form',
		    border: false,
		    columnWidth: 0.5,
		    items:
			[{
			    xtype: 'hidden',
			    fieldLabel: '���',
			    columnWidth: 0.5,
			    anchor: '98%',
			    name: 'OrgId',
			    id: 'OrgId'
            },{
			    xtype: 'textfield',
			    fieldLabel: '���',
			    columnWidth: 0.5,
			    anchor: '98%',
			    readOnly:true,
			    name: 'OrgShortName',
			    id: 'OrgShortName'
            }]
		}
	]
	},
	{
	    layout: 'column',
	    border: false,
	    labelSeparator: '��',
	    items:
		[{
		    layout: 'form',
		    border: false,
		    columnWidth: 1,
		    items:
			[{
			    xtype: 'textfield',
			    fieldLabel: '��������',
			    columnWidth: 1,
			    anchor: '98%',
			    name: 'OrgName',
			    id: 'OrgName'
            }]
        }]
	},
	{
	    layout: 'column',
	    border: false,
	    labelSeparator: '��',
	    items:
		[{
		    layout: 'form',
		    border: false,
		    columnWidth: 0.5,
		    items:
			[{
			    xtype: 'combo',
			    fieldLabel: '���˷�ʽ',
			    columnWidth: 0.5,
			    anchor: '98%',
			    name: 'SendType',
			    id: 'SendType',
			    store: dsTransType,
			    displayField: 'DicsName',
			    valueField:'DicsCode',
			    triggerAction:'all',
			    mode:'local'
            }]
		}
        , {
            layout: 'form',
            border: false,
            columnWidth: 0.5,
            items:
			[{
			    xtype: 'textfield',
			    fieldLabel: 'Ŀ�ĵ�',
			    columnWidth: 0.5,
			    anchor: '98%',
			    name: 'DestInfo',
			    id: 'DestInfo'
            }]
        }]
    }]
});
/*------FormPanle�ĺ������� End---------------*/

/*------��ʼ�������ݵĴ��� Start---------------*/
if (typeof (uploadCfgWindow) == "undefined") {//�������2��windows����
    uploadCfgWindow = new Ext.Window({
        id: 'Cfgformwindow',
        title: '��վ��Ϣά��'
		, iconCls: 'upload-win'
		, width: 400
		, height: 200
		, layout: 'fit'
		, plain: true
		, modal: true
		, constrain: true
		, resizable: false
		, closeAction: 'hide'
		, autoDestroy: true
		, items: destform
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
			    uploadCfgWindow.hide();
			}
			, scope: this
        }]
    });
}
uploadCfgWindow.addListener("hide", function() {
});

/*------��ʼ��ȡ�������ݵĺ��� start---------------*/
function saveUserData() {

    Ext.Ajax.request({
        url: 'frmOrgDestinationCfg.aspx?method=' + saveType,
        method: 'POST',
        params: {
            OrgShortName: Ext.getCmp('OrgShortName').getValue(),
            OrgCode: Ext.getCmp('OrgCode').getValue(),
            OrgName: Ext.getCmp('OrgName').getValue(),
            SendType: Ext.getCmp('SendType').getValue(),
            DestInfo: Ext.getCmp('DestInfo').getValue(),
            OrgId: Ext.getCmp('OrgId').getValue(),
            DestId: Ext.getCmp('DestId').getValue(),
            Ext2: ''
        },
        success: function(resp, opts) {
            Ext.Msg.alert("��ʾ", "����ɹ�");
        },
        failure: function(resp, opts) {
            Ext.Msg.alert("��ʾ", "����ʧ��");
        }
    });
}
/*------������ȡ�������ݵĺ��� End---------------*/

/*------��ʼ�������ݵĺ��� Start---------------*/
function setFormValue(selectData) {
    Ext.Ajax.request({
        url: 'frmOrgDestinationCfg.aspx?method=getcfg',
        params: {
            DestId: selectData.data.DestId
        },
        success: function(resp, opts) {
            var data = Ext.util.JSON.decode(resp.responseText);
            Ext.getCmp("OrgShortName").setValue(data.OrgShortName);
            Ext.getCmp("OrgCode").setValue(data.OrgCode);
            Ext.getCmp("OrgName").setValue(data.OrgName);
            Ext.getCmp("SendType").setValue(data.SendType);
            Ext.getCmp("DestInfo").setValue(data.DestInfo);
            Ext.getCmp("DestId").setValue(data.DestId);
        },
        failure: function(resp, opts) {
            Ext.Msg.alert("��ʾ", "��ȡ��˾��Ϣʧ��");
        }
    });
}
            /*------�������ý������ݵĺ��� End---------------*/

            /*------��ʼ��ȡ���ݵĺ��� start---------------*/
            var orgCfgData = new Ext.data.Store
({
    url: 'frmOrgDestinationCfg.aspx?method=getlist',
    reader: new Ext.data.JsonReader({
        totalProperty: 'totalProperty',
        root: 'root'
    }, [
	{
	    name: 'DestId'
	},
	{
	    name: 'OrgId'
	},
	{
	    name: 'OrgShortName'
	},
	{
	    name: 'OrgCode'
	},
	{
	    name: 'OrgName'
	},
	{
	    name: 'SendType'
	},
	{
	    name: 'SendTypeText'
	},
	{
	    name: 'DestInfo'
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
var defaultPageSize = 10;
var toolBar = new Ext.PagingToolbar({
    pageSize: 10,
    store: orgCfgData,
    displayMsg: '��ʾ��{0}����{1}����¼,��{2}��',
    emptyMsy: 'û�м�¼',
    displayInfo: true
});
var pageSizestore = new Ext.data.SimpleStore({
    fields: ['pageSize'],
    data: [[10], [20], [30]]
});
var combo = new Ext.form.ComboBox({
    regex: /^\d*$/,
    store: pageSizestore,
    displayField: 'pageSize',
    typeAhead: true,
    mode: 'local',
    emptyText: '����ÿҳ��¼��',
    triggerAction: 'all',
    selectOnFocus: true,
    width: 135
});
toolBar.addField(combo);

combo.on("change", function(c, value) {
    toolBar.pageSize = value;
    defaultPageSize = toolBar.pageSize;
}, toolBar);
combo.on("select", function(c, record) {
    toolBar.pageSize = parseInt(record.get("pageSize"));
    defaultPageSize = toolBar.pageSize;
    toolBar.doLoad(0);
}, toolBar);
/*------��ʼDataGrid�ĺ��� start---------------*/

var sm = new Ext.grid.CheckboxSelectionModel({
    singleSelect: true
});
var orgCfg = new Ext.grid.GridPanel({
    el: 'orgCfgDiv',
    width: '100%',
    height: '100%',
    autoWidth: true,
    autoHeight: true,
    autoScroll: true,
    layout: 'fit',
    id: 'orgCfg',
    store: orgCfgData,
    loadMask: { msg: '���ڼ������ݣ����Ժ��' },
    sm: sm,
    cm: new Ext.grid.ColumnModel([
		sm,
		new Ext.grid.RowNumberer(), //�Զ��к�
		{
		    header: '��˾����',
		    dataIndex: 'OrgCode',
		    id: 'OrgCode'
        }, {
		    header: '���',
		    dataIndex: 'OrgShortName',
		    id: 'OrgShortName'
        },
		{
		    header: '��������',
		    dataIndex: 'OrgName',
		    id: 'OrgName'
		},
		{
		    header: 'Ŀ�ĵ�',
		    dataIndex: 'DestInfo',
		    id: 'DestInfo'
		},
		{
		    header: '���˷�ʽ',
		    dataIndex: 'SendTypeText',
		    id: 'SendTypeText'
		}
		]),
		bbar: toolBar,
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
    orgCfg.render();
    /*------DataGrid�ĺ������� End---------------*/

    createSearch(orgCfg, orgCfgData, "searchForm");
    searchForm.el = "searchForm";
    searchForm.render();

})
function getCmbStore(columnName) {

}
</script>

</html>
