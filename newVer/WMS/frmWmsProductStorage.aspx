<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmWmsProductStorage.aspx.cs" Inherits="WMS_frmWmsProductStorage" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html>
<head>
<title>��Ʒ��Ź���</title><meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<link rel="stylesheet" type="text/css" href="../ext3/resources/css/ext-all.css" />
<script type="text/javascript" src="../ext3/adapter/ext/ext-base.js"></script>
<script type="text/javascript" src="../ext3/ext-all.js"></script>
<script type="text/javascript" src="../ext3/example/ItemDeleter.js"></script>
<script type="text/javascript" src="../js/operateResp.js"></script>
<style type="text/css">
.extensive-remove {
background-image: url(../Theme/1/images/extjs/customer/cross.gif) ! important;
}
</style>
</head>

<body>
<div id='toolbar'></div>
<div id='searchForm'></div>
<div id='dataGrid'></div>

</body>
<%= getComboBoxStore() %>
<script type="text/javascript">
Ext.BLANK_IMAGE_URL = "../ext3/resources/images/default/s.gif";
Ext.onReady(function() {
    var saveType;
    /*------ʵ��toolbar�ĺ��� start---------------*/
    var Toolbar = new Ext.Toolbar({
        renderTo: "toolbar",
        items: [{
            text: "����",
            icon: "../Theme/1/images/extjs/customer/add16.gif",
            handler: function() {
                saveType = 'add';
                openAddStorageWin();
            }
        }, '-', {
            text: "�༭",
            icon: "../Theme/1/images/extjs/customer/edit16.gif",
            handler: function() {
                saveType = 'save';
                modifyStorageWin();
            }
        }, '-', {
            text: "ɾ��",
            icon: "../Theme/1/images/extjs/customer/delete16.gif",
            handler: function() {
                deleteStorage();
            }
        }, '-', {
            text: "��λ�������",
            icon: "../Theme/1/images/extjs/customer/delete16.gif",
            handler: function() {
                configStorageWhp();
            }
}]
        });

        /*------����toolbar�ĺ��� end---------------*/


        /*------��ʼToolBar�¼����� start---------------*//*-----����Storageʵ���ര�庯��----*/
        function openAddStorageWin() {
            uploadStorageWindow.show();
        }
        /*-----�༭Storageʵ���ര�庯��----*/
        function modifyStorageWin() {
            var sm = gridData.getSelectionModel();
            //��ȡѡ���������Ϣ
            var selectData = sm.getSelected();
            if (selectData == null) {
                Ext.Msg.alert("��ʾ", "��ѡ����Ҫ�༭����Ϣ��");
                return;
            }
            uploadStorageWindow.show();
            setFormValue(selectData);
        }
        /*-----ɾ��Storageʵ�庯��----*/
        /*ɾ����Ϣ*/
        function deleteStorage() {
            var sm = gridData.getSelectionModel();
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
                        url: 'frmWmsProductStorage.aspx?method=deleteStorage',
                        method: 'POST',
                        params: {
                            StorId: selectData.data.StorId
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
        /*-----����StorageWhpʵ���ര�庯��----*/
        function configStorageWhp() {
            var sm = gridData.getSelectionModel();
            //��ȡѡ���������Ϣ
            var selectData = sm.getSelected();
            //���û��ѡ�񣬾���ʾ��Ҫѡ��������Ϣ
            if (selectData == null) {
                Ext.Msg.alert("��ʾ", "��ѡ����Ҫ���õ���Ϣ��");
                return;
            }
            dsWarehousePosList.load({
                params: {
                    WhId: selectData.data.WhId
                }
            });
            uploadWhpWindow.show();
            dsStorageWhp.load({
                params: {
                    limit: 10,
                    start: 0,
                    StorId: selectData.data.StorId
                },
                callback: function(records, options, success) {
                    inserNewBlankRow()
                }
            });

        }
        /*------ʵ��FormPanle�ĺ��� start---------------*/
        /*------������Ʒ������ start ----------*/
        var dsProductList;
        //���������б��store
        if (dsProductList == null) { //��ֹ�ظ�����
            dsProductList = new Ext.data.JsonStore({
                totalProperty: "results",
                root: "root",
                url: 'frmWmsProductStorage.aspx?method=getProducts',
                fields: ['ProductId', 'ProductName']
            });
            // dsProductList.load();	
        }
        // �����������첽������ʾģ��
        var resultTpl = new Ext.XTemplate(  
            '<tpl for="."><div id="searchdivid" class="search-item">',  
                '<h3><span>���:{ProductNo}&nbsp;  ����:{ProductName}</span></h3>',
            '</div></tpl>'  
        ); 
        var storageForm = new Ext.form.FormPanel({
            url: '',
            //renderTo:'divForm',
            frame: true,
            title: '',
            items: [
		{
		    xtype: 'hidden',
		    fieldLabel: '���ID',
		    columnWidth: 1,
		    anchor: '90%',
		    name: 'StorId',
		    id: 'StorId',
		    hidden: true,
		    hideLabel: true
		}
, {
    xtype: 'combo',
    fieldLabel: '�ֿ�',
    columnWidth: 1,
    anchor: '90%',
    name: 'WhId',
    id: 'WhId',
    store: dsWh,
    displayField: 'WhName',
    valueField: 'WhId',
    mode: 'local',
    triggerAction: 'all',
    editable: false
}
, {
    xtype: 'textfield',
    fieldLabel: '��ƷID',
    columnWidth: 1,
    anchor: '90%',
    name: 'ProductId',
    id: 'ProductId',
    hidden: true,
    hideLabel: true
}
, {
    xtype: 'combo',
    fieldLabel: '��Ʒ',
    columnWidth: 1,
    anchor: '90%',
    name: 'ProductName',
    id: 'ProductName',
    store: dsProductList,
    pageSize: 10,
    minChars: 1,
    hideTrigger: true,
    typeAhead: false,
    emptyText: '��ѡ����Ʒ',
    selectOnFocus: false,
    editable: true,
    displayField: 'ProductName',
    valueField: 'ProductId',
    tpl: resultTpl,  
    itemSelector: 'div.search-item', 
    listeners: {
        "select": function(combo, record, index) {
            Ext.getCmp("ProductId").setValue(record.data.ProductId);
            this.collapse();
        }
    }
}
, {
    xtype: 'textfield',
    fieldLabel: '��С����',
    columnWidth: 1,
    anchor: '90%',
    name: 'MinWeight',
    id: 'MinWeight',
    value: 0
}
, {
    xtype: 'textfield',
    fieldLabel: '�������',
    columnWidth: 1,
    anchor: '90%',
    name: 'MaxWeight',
    id: 'MaxWeight',
    value: 0
}
, {
    xtype: 'combo',
    fieldLabel: '�Ƿ�Ԥ��',
    columnWidth: 1,
    anchor: '90%',
    name: 'IsWarning',
    id: 'IsWarning',
    store: [[0, '����'], [1, '����']],
    mode: 'local',
    triggerAction: 'all',
    editable: false,
    value: 0
}
]
        });
        /*------FormPanle�ĺ������� End---------------*/

        /*------��ʼ�������ݵĴ��� Start---------------*/
        if (typeof (uploadStorageWindow) == "undefined") {//�������2��windows����
            uploadStorageWindow = new Ext.Window({
                id: 'Storageformwindow',
                title: '��Ʒ��Ź���'
		, iconCls: 'upload-win'
		, width: 350
		, height: 220
		, layout: 'fit'
		, plain: true
		, modal: true
		, constrain: true
		, resizable: false
		, closeAction: 'hide'
		, autoDestroy: true
		, items: storageForm
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
			    uploadStorageWindow.hide();
			}
			, scope: this
}]
            });
        }
        uploadStorageWindow.addListener("hide", function() {
            storageForm.getForm().reset();
            updateDataGrid();
        });

        /*------��ʼ��ȡ�������ݵĺ��� start---------------*/
        function saveUserData() {
            Ext.Ajax.request({
                url: 'frmWmsProductStorage.aspx?method=saveStorage',
                method: 'POST',
                params: {
                    StorId: Ext.getCmp('StorId').getValue(),
                    WhId: Ext.getCmp('WhId').getValue(),
                    ProductId: Ext.getCmp('ProductId').getValue(),
                    MinWeight: Ext.getCmp('MinWeight').getValue(),
                    MaxWeight: Ext.getCmp('MaxWeight').getValue(),
                    IsWarning: Ext.getCmp('IsWarning').getValue()
                },
                success: function(resp, opts) {
                    if (checkExtMessage(resp)) {

                    }
                }
            });
        }
        /*------������ȡ�������ݵĺ��� End---------------*/

        /*------��ʼ�������ݵĺ��� Start---------------*/
        function setFormValue(selectData) {
            Ext.Ajax.request({
                url: 'frmWmsProductStorage.aspx?method=getStorage',
                params: {
                    StorId: selectData.data.StorId
                },
                success: function(resp, opts) {
                    var data = Ext.util.JSON.decode(resp.responseText);
                    Ext.getCmp("StorId").setValue(data.StorId);
                    Ext.getCmp("WhId").setValue(data.WhId);
                    Ext.getCmp("ProductId").setValue(data.ProductId);
                    Ext.getCmp("ProductName").setValue(data.ProductName);
                    Ext.getCmp("MinWeight").setValue(data.MinWeight);
                    Ext.getCmp("MaxWeight").setValue(data.MaxWeight);
                    Ext.getCmp("IsWarning").setValue(data.IsWarning);
                },
                failure: function(resp, opts) {
                    Ext.Msg.alert("��ʾ", "��ȡ��Ʒ�����Ϣʧ�ܣ�");
                }
            });
        }
        function updateDataGrid() {
            var WhId = storageWhNamePanel.getValue();
            var ProductName = storageNamePanel.getValue();

            dsStorage.baseParams.WhId = WhId;
            dsStorage.baseParams.ProductName = ProductName;

            dsStorage.load({
                params: {
                    start: 0,
                    limit: 10
                }
            });
        }
        /*------�������ý������ݵĺ��� End---------------*/

        /*------��ʼ��ѯform�ĺ��� start---------------*/

        var storageWhNamePanel = new Ext.form.ComboBox({
            fieldLabel: '�ֿ�����',
            name: 'settingwarehouseCombo',
            store: dsWh,
            displayField: 'WhName',
            valueField: 'WhId',
            typeAhead: true, //�Զ�����һ����������ѡ�ȫ����
            triggerAction: 'all',
            emptyText: '��ѡ��ֿ�',
            emptyValue: '',
            selectOnFocus: true,
            forceSelection: true,
            anchor: '90%',
            mode: 'local',
            editable: false,
            listeners: { specialkey: function(f, e) {
                if (e.getKey() == e.ENTER) {
                    //Ext.getCmp('searchebtnId').focus(); 
                }
            } //
            }

        });
        var storageNamePanel = new Ext.form.TextField({
            style: 'margin-left:0px',
            cls: 'key',
            xtype: 'textfield',
            fieldLabel: '��Ʒ����',
            name: 'settinNameProduct',
            anchor: '90%'
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
                    columnWidth: .4,  //����ռ�õĿ�ȣ���ʶΪ20��
                    layout: 'form',
                    border: false,
                    items: [
                storageWhNamePanel
            ]
                }, {
                    columnWidth: .4,
                    layout: 'form',
                    border: false,
                    items: [
                storageNamePanel
                ]
                }, {
                    columnWidth: .2,
                    layout: 'form',
                    border: false,
                    items: [{ cls: 'key',
                        xtype: 'button',
                        text: '��ѯ',
                        anchor: '50%',
                        handler: function() {
                            updateDataGrid();
                        }
}]
}]
}]
                    });

                    /*------��ʼ��ѯform�ĺ��� end---------------*/


                    /*------��ʼ��ȡ���ݵĺ��� start---------------*/
                    var dsStorage = new Ext.data.Store
({
    url: 'frmWmsProductStorage.aspx?method=getStorageList',
    reader: new Ext.data.JsonReader({
        totalProperty: 'totalProperty',
        root: 'root'
    }, [
	{ name: 'StorId' },
	{ name: 'WhId' },
	{ name: 'WhName' },
	{ name: 'ProductId' },
	{ name: 'ProductName' },
	{ name: 'MinWeight' },
	{ name: 'MaxWeight' },
	{ name: 'IsWarning' },
	{ name: 'OrgId' },
	{ name: 'OperId' },
	{ name: 'OwnerId' },
	{ name: 'CreateDate' },
	{ name: 'UpdateDate' }
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
                    var gridData = new Ext.grid.GridPanel({
                        el: 'dataGrid',
                        width: '100%',
                        height: '100%',
                        autoWidth: true,
                        autoHeight: true,
                        autoScroll: true,
                        layout: 'fit',
                        id: '',
                        store: dsStorage,
                        loadMask: { msg: '���ڼ������ݣ����Ժ��' },
                        sm: sm,
                        cm: new Ext.grid.ColumnModel([
		sm,
		new Ext.grid.RowNumberer(), //�Զ��к�
		{
		header: '���ID',
		dataIndex: 'StorId',
		id: 'StorId',
		hidden: true,
		hideable: false
},
		{
		    header: '�ֿ�',
		    dataIndex: 'WhName',
		    id: 'WhName'
		},
		{
		    header: '��Ʒ',
		    dataIndex: 'ProductName',
		    id: 'ProductName'
		},
		{
		    header: '��С����',
		    dataIndex: 'MinWeight',
		    id: 'MinWeight'
		},
		{
		    header: '�������',
		    dataIndex: 'MaxWeight',
		    id: 'MaxWeight'
		},
		{
		    header: '�Ƿ�Ԥ��',
		    dataIndex: 'IsWarning',
		    id: 'IsWarning',
		    renderer: { fn: function(v) {
		        if (v > 0) return '����';
		        return '����';
		    }
		    }
		},
		{
		    header: '��������',
		    dataIndex: 'CreateDate',
		    id: 'CreateDate'
		}
		]),
                        bbar: new Ext.PagingToolbar({
                            pageSize: 10,
                            store: dsStorage,
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
                    gridData.render();
                    /*------DataGrid�ĺ������� End---------------*/

                    /*------WhpDataGrid�ĺ������� start---------------*/
                    var dsWarehousePosList;
                    if (dsWarehousePosList == null) { //��ֹ�ظ�����
                        dsWarehousePosList = new Ext.data.Store
                        ({
                            url: 'frmWmsProductStorage.aspx?method=getWarehousePosList',
                            reader: new Ext.data.JsonReader({
                                totalProperty: 'totalProperty',
                                root: 'root'
                            }, [
                                { name: 'WhpId' },
                                { name: 'WhpName' }
                            ])
                        });
                    }
                    /*------��ʼ��ȡ���ݵĺ��� start---------------*/
                    var dsStorageWhp = new Ext.data.Store
                    ({
                        url: 'frmWmsProductStorage.aspx?method=getAllWhp',
                        reader: new Ext.data.JsonReader({
                            totalProperty: 'totalProperty',
                            root: 'root'
                        }, [
	                    { name: 'Id' },
	                    { name: 'StorId' },
	                    { name: 'WhpId' },
	                    { name: 'Priority' }
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
                    var positionCombobox = new Ext.form.ComboBox({
                        name: 'warehouseCombo',
                        store: dsWarehousePosList,
                        displayField: 'WhpName',
                        valueField: 'WhpId',
                        hiddenName: 'WhpId',
                        typeAhead: true, //�Զ�����һ����������ѡ�ȫ����
                        triggerAction: 'all',
                        emptyText: '��ѡ���λ',
                        emptyValue: '',
                        selectOnFocus: true,
                        forceSelection: true,
                        anchor: '90%',
                        mode: 'local',
                        listeners: {
                            select: function(combo, record, index) {
                                addNewBlankRow();
                            }
                        }
                    });
                    var sm = new Ext.grid.CheckboxSelectionModel({
                        singleSelect: true
                    });
                    var gridWhpData = new Ext.grid.EditorGridPanel({
                        height: 250,
                        width: '100%',
                        autoWidth: true,
                        //autoHeight:true,
                        autoScroll: true,
                        layout: 'fit',
                        clicksToEdit: 1,
                        id: '',
                        store: dsStorageWhp,
                        loadMask: { msg: '���ڼ������ݣ����Ժ��' },
                        selModel: new Extensive.grid.ItemDeleter(),
                        cm: new Ext.grid.ColumnModel([
		new Ext.grid.RowNumberer(), //�Զ��к�
		{
		header: '��ˮ��',
		dataIndex: 'Id',
		id: 'Id',
		hidden: true,
		hideable: false
},
		{
		    header: '���ID',
		    dataIndex: 'StorId',
		    id: 'StorId',
		    hidden: true,
		    hideable: false
		},
		{
		    header: '��λ',
		    dataIndex: 'WhpId',
		    id: 'WhpId',
		    editor: positionCombobox,
		    renderer: function(value, cellmeta, record, rowIndex, columnIndex, store) {
		        var index = dsWarehousePosList.findBy(function(record, id) {
		            return record.get(positionCombobox.valueField) == value;
		        });
		        var record = dsWarehousePosList.getAt(index);
		        var displayText = "";
		        if (record == null) {
		            displayText = value;
		        } else {
		            displayText = record.data.WhpName;
		        }
		        //alert(displayText);
		        return displayText;
		    }
		},
		{
		    header: '���ȼ�', //1~99�����ԽС�����ȼ�Խ��
		    dataIndex: 'Priority',
		    id: 'Priority',
		    editor: new Ext.form.TextField({
		        allowBlank: false
		    })
		}, new Extensive.grid.ItemDeleter()
		]),
                        bbar: new Ext.PagingToolbar({
                            pageSize: 10,
                            store: dsStorageWhp,
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

                    /*------��ʼ�������ݵĴ��� Start---------------*/
                    if (typeof (uploadWhpWindow) == "undefined") {//�������2��windows����
                        uploadWhpWindow = new Ext.Window({
                            id: 'Whpformwindow',
                            title: '��Ӳ�λ��Ϣ'
		, iconCls: 'upload-win'
		, width: 400
		, height: 300
		, layout: 'fit'
		, plain: true
		, modal: true
		, constrain: true
		, resizable: false
		, closeAction: 'hide'
		, autoDestroy: true
		, items: gridWhpData
		, buttons: [{
		    text: "����"
			, handler: function() {
			    var json = '';
			    dsStorageWhp.each(function(dsStorageWhp) {
			        json += Ext.util.JSON.encode(dsStorageWhp.data) + ',';
			    });
			    json = json.substring(0, json.length - 1);
			    //alert(json);  
			    Ext.Ajax.request({
			        url: 'frmWmsProductStorage.aspx?method=saveStoreWhp',
			        method: 'POST',
			        params: {
			            WhpData: json
			        },
			        success: function(resp, opts) {
			            if (checkExtMessage(resp)) {

			            }
			        }
			    });
			}
			, scope: this
		},
		{
		    text: "ȡ��"
			, handler: function() {
			    uploadWhpWindow.hide();
			}
			, scope: this
}]
                        });
                    }
                    uploadWhpWindow.addListener("hide", function() {
                        gridWhpData.getStore().removeAll();
                    });
                    var RowPattern = Ext.data.Record.create([
                       { name: 'Id', type: 'string' },
                       { name: 'StorId', type: 'string' },
                       { name: 'WhpId', type: 'string' },
                       { name: 'Priority', type: 'string' }
                    ]);
                    function inserNewBlankRow() {
                        var rowCount = gridWhpData.getStore().getCount();
                        //alert(rowCount);
                        var sm = gridData.getSelectionModel();
                        //��ȡѡ���������Ϣ
                        var selectData = sm.getSelected();
                        var insertPos = parseInt(rowCount);
                        var addRow = new RowPattern({
                            Id: '0',
                            StorId: selectData.data.StorId,
                            WhpId: '',
                            Priority: ''
                        });
                        gridWhpData.stopEditing();
                        //����һ����
                        if (insertPos > 0) {
                            var rowIndex = dsStorageWhp.insert(insertPos, addRow);
                            gridWhpData.startEditing(insertPos, 0);
                        }
                        else {
                            var rowIndex = dsStorageWhp.insert(0, addRow);
                            gridWhpData.startEditing(0, 0);
                        }
                    }
                    function addNewBlankRow() {
                        var rowIndex = gridWhpData.getStore().indexOf(gridWhpData.getSelectionModel().getSelected());
                        var rowCount = gridWhpData.getStore().getCount();
                        //alert(rowIndex+":"+rowCount);    
                        if ((rowIndex == 0 && rowCount == 1) || rowIndex == rowCount - 1) {
                            inserNewBlankRow();
                        }
                    }
                    /*------WhpDataGrid�ĺ������� End---------------*/
                    updateDataGrid();
                })
</script>

</html>
