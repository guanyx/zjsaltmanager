<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmBaProductUnitConvert.aspx.cs"
    Inherits="BA_product_frmBaProductUnitConvert" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
    <title>������λת��</title>
    <meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
    <link rel="stylesheet" type="text/css" href="../../ext3/resources/css/ext-all.css" />

    <script type="text/javascript" src="../../ext3/adapter/ext/ext-base.js"></script>

    <script type="text/javascript" src="../../ext3/ext-all.js"></script>
    <script type="text/javascript" src="../../js/FilterControl.js"></script>

</head>
<body>
    <div id='toolbar'>
    </div>
    <div id='searchForm'>
    </div>
    <div id='unitConvertGrid'>
    </div>
</body>

<%= getComboBoxStore() %>

<script type="text/javascript">
Ext.BLANK_IMAGE_URL = "../../ext3/resources/images/default/s.gif";
function getCmbStore(columnName)
    {
        
        return null;
    }
    var unitConvertGridData = null;

    function loadData() {
        unitConvertGridData.baseParams.ProductId = productId;
        unitConvertGridData.load({params:{limit:10,start:0}});
    }
    Ext.onReady(function() {
        var saveType;
        /*--------�������� start ---------------*/
        var dsProduct; //��Ӧ������Դ

        /*----------�������� end --------------*/
        /*------ʵ��toolbar�ĺ��� start---------------*/
        var Toolbar = new Ext.Toolbar({
            renderTo: "toolbar",
            items: [{
                text: "����",
                icon: "../../Theme/1/images/extjs/customer/add16.gif",
                handler: function() {
                    saveType = 'add';
                    openAddConvertWin();
                    var sm = unitConvertGrid.getSelectionModel();
                    //��ȡѡ���������Ϣ
                    var selectData = sm.getSelected();
                    if (selectData != null) {
                        Ext.getCmp("ProductName").setValue(selectData.data.ProductName);
                        Ext.getCmp("ProductId").setValue(selectData.data.ProductId);
                    }
                    else {
                        if (productId != 0) {
                            Ext.getCmp("ProductName").setValue(productName);
                            Ext.getCmp("ProductId").setValue(productId);
                        }
                    }
                }
            }, '-', {
                text: "�༭",
                icon: "../../Theme/1/images/extjs/customer/edit16.gif",
                handler: function() {
                    saveType = 'save';
                    modifyConvertWin();
                }
            }, '-', {
                text: "ɾ��",
                icon: "../../Theme/1/images/extjs/customer/delete16.gif",
                handler: function() { deleteConvert(); }
}]
            });

            /*------����toolbar�ĺ��� end---------------*/


            /*------��ʼToolBar�¼����� start---------------*//*-----����Convertʵ���ര�庯��----*/
            function openAddConvertWin() {
                uploadConvertWindow.show();
                /*----------���幩Ӧ����Ͽ� start -------------*/
                //�����������첽���÷���
                dsProduct = new Ext.data.Store({
                    url: 'frmBaProductUnitConvert.aspx?method=getProducts',
                    reader: new Ext.data.JsonReader({
                        root: 'root',
                        totalProperty: 'totalProperty',
                        id: 'searchProductId'
                    }, [
                        { name: 'ProductId', mapping: 'ProductId' },
                        { name: 'ProductName', mapping: 'ProductName' },
                        { name: 'Unit', mapping: 'Unit' }
                    ]),
                    params: {
                        ProductName: Ext.getCmp('ProductName').getValue()
                    }
                });
                var search = new Ext.form.ComboBox({
                    store: dsProduct,
                    displayField: 'ProductName',
                    displayValue: 'ProductId',
                    typeAhead: false,
                    minChars: 1,
                    loadingText: 'Searching...',
                    //width: 200,  
                    pageSize: 10,
                    hideTrigger: true,
                    id: 'ProductCombo',
                    applyTo: 'ProductName',
                    onSelect: function(record) { // override default onSelect to do redirect  
                        //alert(record.data.cusid); 
                        //alert(Ext.getCmp('search').getValue());                            
                        Ext.getCmp('ProductName').setValue(record.data.ProductName);
                        Ext.getCmp('ProductId').setValue(record.data.ProductId);
                        Ext.getCmp('SourceUnitId').setValue(record.data.Unit);
                        this.collapse();
                    }
                });

                /*----------���幩Ӧ����Ͽ� end -------------*/
            }
            /*-----�༭Convertʵ���ര�庯��----*/
            function modifyConvertWin() {
                var sm = unitConvertGrid.getSelectionModel();
                //��ȡѡ���������Ϣ
                var selectData = sm.getSelected();
                if (selectData == null) {
                    Ext.Msg.alert("��ʾ", "��ѡ����Ҫ�༭����Ϣ��");
                    return;
                }
                uploadConvertWindow.show();
                setFormValue(selectData);
            }
            /*-----ɾ��Convertʵ�庯��----*/
            /*ɾ����Ϣ*/
            function deleteConvert() {
                var sm = unitConvertGrid.getSelectionModel();
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
                            url: 'frmBaProductUnitConvert.aspx?method=deleteUnitConvertInfo',
                            method: 'POST',
                            params: {
                                UnitConversionId: selectData.data.UnitConversionId
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
            var unitConvertForm = new Ext.form.FormPanel({
                url: '',
                frame: true,
                title: '',
                items: [
		{
		    xtype: 'hidden',
		    fieldLabel: '��λ����ID',
		    name: 'UnitConversionId',
		    id: 'UnitConversionId',
		    hidden: true,
		    hideLabel: true
		}
        , {
            xtype: 'textfield',
            fieldLabel: '��Ʒ����',
            columnWidth: 1,
            anchor: '90%',
            name: 'ProductName',
            id: 'ProductName'
        }
        , {
            xtype: 'hidden',
            fieldLabel: '��ƷID',
            name: 'ProductId',
            id: 'ProductId',
            hidden: true,
            hideLabel: true
        }
        , {
            xtype: 'combo',
            fieldLabel: '�����㵥λ',
            columnWidth: 1,
            anchor: '90%',
            name: 'SourceUnitId',
            id: 'SourceUnitId'
            , displayField: 'UnitName'
            , valueField: 'UnitId'
            , editable: false
            , store: dsUnit
            , triggerAction: 'all'
            , mode: 'local'
            , listeners: {
                change: {
                    fn: function(combo) {
                        Ext.getCmp('DecUnitId').getStore().clearFilter();
                        Ext.getCmp('DecUnitId').getStore().filterBy(function(record) {
                            return record.get('UnitId') != combo.getValue();
                        });
                    }
                }
            }
        }
        , {
            xtype: 'combo',
            fieldLabel: '���ɵ�λ',
            columnWidth: 1,
            anchor: '90%',
            name: 'DecUnitId',
            id: 'DecUnitId'
            , displayField: 'UnitName'
            , valueField: 'UnitId'
            , editable: false
            , store: dsNewUnit
            , triggerAction: 'all'
            , mode: 'local'
            , lastQuery: ''
        }
        , {
            xtype: 'numberfield',
            fieldLabel: '���ɵ�λֵ',
            columnWidth: 1,
            anchor: '90%',
            name: 'ReplacedValue',
            id: 'ReplacedValue',
            decimalPrecision: 8
        }
        , {
            xtype: 'textarea',
            fieldLabel: '��ע',
            columnWidth: 1,
            anchor: '90%',
            name: 'Remark',
            id: 'Remark'
        }
        ]
            });
            /*------FormPanle�ĺ������� End---------------*/

            /*------��ʼ�������ݵĴ��� Start---------------*/
            if (typeof (uploadConvertWindow) == "undefined") {//�������2��windows����
                uploadConvertWindow = new Ext.Window({
                    id: 'Convertformwindow'
		, iconCls: 'upload-win'
		, width: 400
		, height: 280
		, layout: 'fit'
		, plain: true
		, modal: true
		, constrain: true
		, resizable: false
		, closeAction: 'hide'
		, autoDestroy: true
		, items: unitConvertForm
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
			    uploadConvertWindow.hide();
			}
			, scope: this
}]
                });
            }
            uploadConvertWindow.addListener("hide", function() {
                unitConvertForm.getForm().reset();
            });

            /*------��ʼ��ȡ�������ݵĺ��� start---------------*/
            function saveUserData() {

                if (saveType == 'add')
                    saveType = 'addUnitConvertInfo';
                else if (saveType == 'save')
                    saveType = 'saveUnitConvertInfo';

                Ext.Ajax.request({
                    url: 'frmBaProductUnitConvert.aspx?method=' + saveType,
                    method: 'POST',
                    params: {
                        UnitConversionId: Ext.getCmp('UnitConversionId').getValue(),
                        ProductId: Ext.getCmp('ProductId').getValue(),
                        SourceUnitId: Ext.getCmp('SourceUnitId').getValue(),
                        DecUnitId: Ext.getCmp('DecUnitId').getValue(),
                        ReplacedValue: Ext.getCmp('ReplacedValue').getValue(),
                        Remark: Ext.getCmp('Remark').getValue()
                    },
                    success: function(resp, opts) {
                        Ext.Msg.alert("��ʾ", "����ɹ�");
                        var name = namePanel.getValue();
                        unitConvertGridData.baseParams.UnitNam = name;
                        unitConvertGridData.load({
                            params: {
                                start: 0,
                                limit: 10
                            }
                        });
                        uploadConvertWindow.hide();

                    },
                    failure: function(resp, opts) {
                        Ext.Msg.alert("��ʾ", "����ʧ��");
                    }
                });
            }
            /*------������ȡ�������ݵĺ��� End---------------*/

            /*------��ʼ�������ݵĺ��� Start---------------*/
            function setFormValue(selectData) {
                Ext.getCmp("UnitConversionId").setValue(selectData.data['UnitConversionId']);
                Ext.getCmp("ProductId").setValue(selectData.data['ProductId']);
                Ext.getCmp("ProductName").setValue(selectData.data['ProductName']);
                Ext.getCmp("SourceUnitId").setValue(selectData.data['SourceUnitId']);
                Ext.getCmp("DecUnitId").setValue(selectData.data['DecUnitId']);
                Ext.getCmp("ReplacedValue").setValue(selectData.data['ReplacedValue']);
                Ext.getCmp("Remark").setValue(selectData.data['Remark']);
            }
            /*------�������ý������ݵĺ��� End---------------*/
            /*------�����ѯform start ----------------*/
            var namePanel = new Ext.form.TextField({
                style: 'margin-left:0px',
                cls: 'key',
                xtype: 'textfield',
                fieldLabel: '������λ����',
                name: 'name',
                anchor: '90%'
            });
            //var serchform = new Ext.FormPanel({
            //    renderTo: 'searchForm',
            //    labelAlign: 'left',
            //    layout:'fit',
            //    buttonAlign: 'right',
            //    bodyStyle: 'padding:5px',
            //    frame: true,
            //    labelWidth: 95,
            //    items: [{
            //        layout: 'column',   //�����Ԫ��Ϊ����Ϊ�в��ַ�ʽ
            //        border: false,
            //        items: [{
            //            columnWidth: .33,
            //            layout: 'form',
            //            border: false,
            //            items: [
            //                namePanel
            //                ]
            //        }, {
            //            columnWidth: .10,
            //            layout: 'form',
            //            border: false,
            //            items: [{ cls: 'key',
            //                xtype: 'button',
            //                text: '��ѯ',
            //                anchor: '50%',
            //                handler :function(){                
            //                    var name=namePanel.getValue();
            //                    unitConvertGridData.baseParams.UnitName = name;
            //                    unitConvertGridData.load({
            //                                params : {
            //                                start : 0,
            //                                limit : 10
            //                                } 
            //                              }); 
            //                    }
            //                }]
            //        },{
            //            columnWidth: .57,  //����ռ�õĿ�ȣ���ʶΪ20��
            //            layout: 'form',
            //            border: false
            //        }]
            //    }]
            //});
            /*------�����ѯform end ----------------*/

            /*------��ʼ��ȡ���ݵĺ��� start---------------*/
            unitConvertGridData = new Ext.data.Store
({
    url: 'frmBaProductUnitConvert.aspx?method=getUnitCovertList',
    reader: new Ext.data.JsonReader({
        totalProperty: 'totalProperty',
        root: 'root'
    }, [
	{
	    name: 'UnitConversionId'
	},
	{
	    name: 'ProductId'
	},
	{
	    name: 'ProductName'
	},
	{
	    name: 'SourceUnitId'
	},
	{
	    name: 'SourceUnitText'
	},
	{
	    name: 'SpecificationsText'
	},
	{
	    name: 'DecUnitId'
	},
	{
	    name: 'DecUnitText'
	},
	{
	    name: 'ReplacedValue'
	},
	{
	    name: 'Remark'
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
            var unitConvertGrid = new Ext.grid.GridPanel({
                el: 'unitConvertGrid',
                width: '100%',
                height: '100%',
                autoWidth: true,
                autoHeight: true,
                autoScroll: true,
                layout: 'fit',
                id: '',
                store: unitConvertGridData,
                loadMask: { msg: '���ڼ������ݣ����Ժ��' },
                sm: sm,
                cm: new Ext.grid.ColumnModel([
		sm,
		new Ext.grid.RowNumberer(), //�Զ��к�
		{
		header: '��λ����ID',
		dataIndex: 'UnitConversionId',
		id: 'UnitConversionId'
		    , hidden: true
		    , hideable: true
},
		{
		    header: '��ƷID',
		    dataIndex: 'ProductId',
		    id: 'ProductId'
		    , hidden: true
		    , hideable: true
		},
		{
		    header: '��Ʒ����',
		    dataIndex: 'ProductName',
		    id: 'ProductName'
		},
		{
		    header: '���㵥λ',
		    dataIndex: 'SourceUnitId',
		    id: 'SourceUnitId'
		    , hidden: true
		    , hideable: true
		},
		{
		    header: '���㵥λ',
		    dataIndex: 'SourceUnitText',
		    id: 'SourceUnitText'
		},
		{
		    header: '�����ɵ�λ',
		    dataIndex: 'DecUnitId',
		    id: 'DecUnitId'
		    , hidden: true
		    , hideable: true
		},
		{
		    header: '�����ɵ�λ',
		    dataIndex: 'DecUnitText',
		    id: 'DecUnitText'
		},
		{
		    header: '���',
		    dataIndex: 'SpecificationsText',
		    id: 'SpecificationsText'
		},
		{
		    header: '���ɵ�λֵ',
		    dataIndex: 'ReplacedValue',
		    id: 'ReplacedValue'
		},
		{
		    header: '��ע',
		    dataIndex: 'Remark',
		    id: 'Remark'
}]),
                bbar: new Ext.PagingToolbar({
                    pageSize: 10,
                    store: unitConvertGridData,
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
            unitConvertGrid.render();
            /*------DataGrid�ĺ������� End---------------*/

            createSearch(unitConvertGrid, unitConvertGridData, "searchForm");
            //setControlVisibleByField();
            searchForm.el = "searchForm";
            searchForm.render();
            loadData();

        })
</script>

</html>
