<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmProductCostList.aspx.cs" Inherits="WMS_frmProductCostList" %>

<html>
<head>
<title>�ֿ�ɱ�����ά��ҳ��</title><meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<link rel="stylesheet" type="text/css" href="../ext3/resources/css/ext-all.css" />
<script type="text/javascript" src="../ext3/adapter/ext/ext-base.js"></script>
<script type="text/javascript" src="../ext3/ext-all.js"></script>
<script type="text/javascript" src="../js/operateResp.js"></script>
<script type="text/javascript" src="../ext3/src/locale/ext-lang-zh_CN.js"></script>
<script type="text/javascript" src="../js/ExtJsHelper.js"></script>
<style type="text/css">
.x-date-menu {
   width: 175;
}
</style>
</head>
<body>
<div id='toolbar'></div>
<div id='divSearchForm'></div>
<div id='divForm'></div>
<div id='divOrderGrid'></div>
<div style="display:none">
<select id='comboYear' >
<option value='2009'>2009</option>
<option value='2010'>2010</option>
<option value='2011'>2011</option>
<option value='2012'>2012</option>
<option value='2013'>2013</option>
<option value='2014'>2014</option>
<option value='2015'>2015</option>
<option value='2016'>2016</option>
</select></div>
<div style="display:none">
<select id='comboMonth' >
<option value='1'>1</option>
<option value='2'>2</option>
<option value='3'>3</option>
<option value='4'>4</option>
<option value='5'>5</option>
<option value='6'>6</option>
<option value='7'>7</option>
<option value='8'>8</option>
<option value='9'>9</option>
<option value='10'>10</option>
<option value='11'>11</option>
<option value='12'>12</option>
</select></div>
</body>
<%=getComboBoxStore()%>
<script type="text/javascript">
    Ext.BLANK_IMAGE_URL = "../ext3/resources/images/default/s.gif";
    Ext.onReady(function() {
        /*------ʵ��toolbar�ĺ��� start---------------*/
        var windowTitle = "";
        var Toolbar = new Ext.Toolbar({
            renderTo: "toolbar",
            items: [{
                text: "����ɱ���",
                icon: "../theme/1/images/extjs/customer/add16.gif",
                handler: function() { calcPriceCostWin(); }
},{
                text: "�ɱ�����",
                icon: "../theme/1/images/extjs/customer/add16.gif",
                handler: function() { productCostUpdate(); }
}]
            });

            /*------����toolbar�ĺ��� end---------------*/
var productCostUpdateWin = null;
function productCostUpdate()
{
var record=userGrid.getSelectionModel().getSelections();
                if(record == null || record.length == 0)
                {
                 Ext.Msg.alert('��ʾ��Ϣ', '��ѡ����Ҫ�޸ĵĳɱ���Ϣ�����Զ������ɱ�ͬʱ����');
                    return null;
                }

    var ids = '';
    for(var i=0;i<record.length;i++)
    {
        if(ids.length>0)
            ids+=",";
        ids += record[i].get('Id');
    }
    if(productCostUpdateWin==null)
    {
        productCostUpdateWin = ExtJsShowWin('����ɱ��޸�','../Common/frmOtherUpdate.aspx?formType=productcost&ids='+ids,'productsalt',600,450);
        productCostUpdateWin.show();
    }
    else
    {
        productCostUpdateWin.show();
        document.getElementById("iframeproductsalt").contentWindow.loadData(ids);
    }
}

            /*------��ʼToolBar�¼����� start---------------*//*-----����Orderʵ���ര�庯��----*/
            function updateDataGrid() {

                var WhId = WhNamePanel.getValue();
                var StartDate = Ext.util.Format.date(StartDatePanel.getValue(),'Y/m/d');
                var EndDate = Ext.util.Format.date(EndDatePanel.getValue(),'Y/m/d');

                userGridData.baseParams.WhId = WhId;
                userGridData.baseParams.StartDate = StartDate;
                userGridData.baseParams.EndDate = EndDate;
                userGridData.baseParams.ProductNo=Ext.getCmp('ProductNo').getValue();
                userGridData.baseParams.ProductName=Ext.getCmp('ProductName').getValue();

                userGridData.load({
                    params: {
                        start: 0,
                        limit: 10
                    }
                });

            }

            function calcPriceCostWin() {
                uploadOrderWindow.show();
            }
            /*------ʵ��FormPanle�ĺ��� start---------------*/
            var formData = new Ext.form.FormPanel({
                //url: '',
                frame: true,
                title: '',
                items: [
                {
                    xtype: 'combo',
                    columnWidth: 1,
                    name: 'TargetWhId',
                    id: 'TargetWhId',
                    store: dsWarehouseList,
                    displayField: 'WhName',
                    valueField: 'WhId',
                    typeAhead: true, //�Զ�����һ����������ѡ�ȫ����
                    triggerAction: 'all',
                    emptyText: 'ȫ���ֿ�',
                    selectOnFocus: true,
                    forceSelection: true,
                    mode: 'local',
                    fieldLabel: '�ֿ�',
                    //value: dsWarehouseList.getRange()[0].data.WhId,
                    anchor: '100%'
                }, {
                    xtype: 'combo',
                    fieldLabel: '���',
                    columnWidth: 1,
                    anchor: '100%',
                    name: 'Year',
                    id: 'Year',
                    transform: 'comboYear',
                    typeAhead: false,
                    triggerAction: 'all',
                    lazyRender: true,
                    editable: false,
                    value: new Date().getFullYear()
                }, {
                    xtype: 'combo',
                    fieldLabel: '�·�',
                    columnWidth: 1,
                    anchor: '100%',
                    name: 'Month',
                    id: 'Month',
                    transform: 'comboMonth',
                    typeAhead: false,
                    triggerAction: 'all',
                    lazyRender: true,
                    editable: false,
                    value: new Date().getMonth() + 1
                }, {
                    xtype:'label',
                    html: "<div align='center'><br><br><font style='font-weight:bold;color:red'>�����һ������ҵ����</font></div>",
                    columnWidth: 1,
                    anchor:'100%'
                }
                ]
            });
            /*------��ʼ�������ݵĴ��� Start---------------*/

    var checkPanel = new Ext.Panel({  
        frame: true,  
        title: '�ɱ�����ǰ����ҵ����',   
        html:'�����һ����ť���е�һ�����',
        autoScroll:true
  
    });  
    var checkStep = "";
    var rawstring = "";
    var i = 0;  
    function cardHandler(direction) {  
        if (direction == -1) {  
            i--;  
            if (i < 0) {  
                i = 0;  
            }  
        }  
        if (direction == 1) {  
            i++;  
            if (i > 1) {  
                i = 1;  
            }  
        }  
        var btnNext = Ext.getCmp("move-next");  
        var btnPrev = Ext.getCmp("move-prev");  
        var btnSave = Ext.getCmp("move-save");  
        if (i == 0) {  
            btnSave.hide();  
            btnNext.enable();  
            btnPrev.disable();   
            rawstring =''; //������� 
            checkPanel.body.update('');//�������        
            cardPanel.getLayout().setActiveItem(i);  
        }  
        var currendIdx = cardPanel.items.indexOf(cardPanel.layout.activeItem);        
        if (i == 1) { 
            if( currendIdx == 1)
            {
                 Ext.Ajax.request({
                    url: 'frmProductCostList.aspx?method=checkProductCost&checkStep='+checkStep,
                    method: 'POST',
                    params: {
                        WhId: Ext.getCmp('TargetWhId').getValue(),
                        Year: Ext.getCmp('Year').getValue(),
                        Month: Ext.getCmp('Month').getValue()
                    },
                    success: function(resp, opts) {
                        var resu = Ext.decode(resp.responseText);//ҪUIMessageBase��ʽ                
                        var isfinish = false;  
                        if(resu.success)
                        {                 
                            //��ȡ��һ��
                            checkStep = resu.id;                              
                            //��ʾ���ɹ�
                            if(checkStep==0)                        
                            {//�����ɹ�
                                rawstring = '�����ϣ�';
                                btnNext.disable();
                                btnSave.show(); 
                            }
                            //��ʾ�����Ϣ  
                            rawstring = rawstring+resu.errorinfo+'<br>';
                            checkPanel.body.update(rawstring); 
                        }
                        else
                        {
                            //��ʾ�����Ϣ  
                            //��ȡ��һ��
                            if(resu.id != -1)
                                checkStep = resu.id; 
                            rawstring = rawstring+'<font color="red">'+resu.errorinfo+'</font>'+'<br>';
                            checkPanel.body.update(rawstring); 
                        }           
                                          
                    }
                });     
                         
            }else{                                
                //btnSave.show();  
                //btnNext.disable();  
                btnPrev.enable();  
                
                cardPanel.getLayout().setActiveItem(i);
            }
        }
                
    }; 
    //CARD�����  
    var cardPanel = new Ext.Panel({  
        frame: true,  
        height: 400,  
        width: 300,  
        layout: 'card',  
        activeItem: 0,  
        bbar: ['->', {  
            id: 'move-prev',  
            text: '��һ��', 
            disabled:true, 
            handler: cardHandler.createDelegate(this, [-1])  
        },  
        {  
            id: 'move-save',  
            text: '����',  
            hidden: true,  
            handler: function () {  
                calcProductCost();
            }  
        },  
        {  
            id: 'move-next',  
            text: '��һ��',  
            handler: cardHandler.createDelegate(this, [1])  
        },  
        {  
            id: 'hide-win',  
            text: 'ȡ��',  
            handler: function() {
                uploadOrderWindow.hide();                
            } 
        }],  
        items: [formData,checkPanel]  
    });  
    
   
            if (typeof (uploadOrderWindow) == "undefined") {//�������2��windows����
                uploadOrderWindow = new Ext.Window({
                    id: 'Orderformwindow'
		            , iconCls: 'upload-win'
		            , title: '��ѡ��ֿ�����¼���ɱ���'
		            , width: 400
		            , height: 300
		            , layout: 'fit'
		            , plain: true
		            , modal: true
		            , constrain: true
		            , resizable: false
		            , closeAction: 'hide'
		            , autoDestroy: true
		            , items: cardPanel

                });
            }
            uploadOrderWindow.addListener("hide", function() {
                checkPanel.body.update('');//�������
                cardHandler(-1);//��ԭ����
                updateDataGrid();
            });

            /*------��ʼ��ȡ�������ݵĺ��� start---------------*/
            function calcProductCost() {
            
                Ext.MessageBox.wait("�������ڴ������Ժ򡭡�");
                Ext.Ajax.request({
                    timeout: 180000,
                    url: 'frmProductCostList.aspx?method=calcProductCost',
                    method: 'POST',
                    params: {
                        WhId: Ext.getCmp('TargetWhId').getValue(),
                        Year: Ext.getCmp('Year').getValue(),
                        Month: Ext.getCmp('Month').getValue()
                    },
                    success: function(resp, opts) {
                        Ext.MessageBox.hide();
                        if (checkExtMessage(resp)) {                            
                            uploadOrderWindow.hide();
                        }
                    }, 
                    failure: function(resp, opts) {
                         Ext.MessageBox.hide();
                     }
                });
            }
            /*------������ȡ�������ݵĺ��� End---------------*/

            /*------��ʼ��ѯform�ĺ��� start---------------*/
            var WhNamePanel = new Ext.form.ComboBox({
                name: 'warehouseCombo',
                store: dsWarehouseList,
                displayField: 'WhName',
                valueField: 'WhId',
                typeAhead: true, //�Զ�����һ����������ѡ�ȫ����
                triggerAction: 'all',
                emptyText: '��ѡ��ֿ�',
                selectOnFocus: true,
                forceSelection: true,
                mode: 'local',
                fieldLabel: '�ֿ�����',
                anchor: '90%',
                id: 'SWhName',
                listeners: { specialkey: function(f, e) { if (e.getKey() == e.ENTER) { Ext.getCmp('StartDate').focus(); } } }
            });


            var StartDatePanel = new Ext.form.DateField({
                style: 'margin-left:0px',
                cls: 'key',
                xtype: 'datefield',
                fieldLabel: '��ʼʱ��',
                format: 'Y��m��d��',
                anchor: '90%',
                value: new Date().getFirstDateOfMonth().clearTime(),
                id: 'StartDate',
                listeners: { specialkey: function(f, e) { if (e.getKey() == e.ENTER) { Ext.getCmp('EndDate').focus(); } } }
            });
            var EndDatePanel = new Ext.form.DateField({
                style: 'margin-left:0px',
                cls: 'key',
                xtype: 'datefield',
                fieldLabel: '����ʱ��',
                anchor: '90%',
                format: 'Y��m��d��',
                id: 'EndDate',
                value: new Date().getLastDateOfMonth().clearTime(),
                listeners: { specialkey: function(f, e) { if (e.getKey() == e.ENTER) { Ext.getCmp('searchebtnId').focus(); } } }
            });
            var serchform = new Ext.FormPanel({
                renderTo: 'divSearchForm',
                labelAlign: 'left',
                buttonAlign: 'right',
                bodyStyle: 'padding:5px',
                frame: true,
                labelWidth: 55,
                items: [{
                    layout: 'column',   //�����Ԫ��Ϊ����Ϊ�в��ַ�ʽ
                    border: false,
                    items: [{
                        columnWidth: .3,
                        layout: 'form',
                        border: false,
                        items: [
                            WhNamePanel
                        ]
                    },{
                        columnWidth: .3,
                        layout: 'form',
                        border: false,
                        items: [{
                            xtype: 'textfield',
			                fieldLabel: '��Ʒ���',
			                columnWidth: 1,
			                anchor: '90%',
			                name: 'ProductNo',
			                id: 'ProductNo'
                        }]
                    },{
                        columnWidth: .3,
                        layout: 'form',
                        border: false,
                        items: [{
                            xtype: 'textfield',
			                fieldLabel: '��Ʒ����',
			                columnWidth: 1,
			                anchor: '90%',
			                name: 'ProductName',
			                id: 'ProductName'
                        }]
                    }
                    ]
                }, {
                    layout: 'column',   //�����Ԫ��Ϊ����Ϊ�в��ַ�ʽ
                    border: false,
                    items: [{
                        columnWidth: .3,  //����ռ�õĿ�ȣ���ʶΪ20��
                        layout: 'form',
                        border: false,
                        items: [
                                StartDatePanel
                            ]
                    }, {
                        columnWidth: .3,
                        layout: 'form',
                        border: false,
                        items: [
                                EndDatePanel
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
}]
}]
                        });


                        /*------��ʼ��ѯform�ĺ��� end---------------*/

                        /*------��ʼ��ȡ���ݵĺ��� start---------------*/
                        var userGridData = new Ext.data.Store
            ({
                url: 'frmProductCostList.aspx?method=getProductCostList',
                reader: new Ext.data.JsonReader({
                    totalProperty: 'totalProperty',
                    root: 'root'
                }, [{ name: 'Id' },
	            {
	                name: 'YearMonth'
	            },
	            {
	                name: 'WhId'
	            },
	            {
	                name: 'OrgId'
	            },
	            {
	                name: 'OwnerId'
	            },
	            {
	                name: 'OperId'
	            },
	            {
	                name: 'CreateDate'
	            },
	            {
	                name: 'UpdateDate'
	            },
	            {
	                name: 'ProductId'
	            },
	            {
	                name: 'CostPrice'
	            },
	            {
	                name: 'PureCostPrice'
	            },
	            {
	                name: 'SpecCostPrice'
	            },
	            {
	                name: 'ProductCode'
	            },
	            {
	                name: 'ProductName'
	            },
	            {
	                name: 'ProductUnit'
	            },
	            {
	                name: 'SpecUnitName'
	            },
	            {
	                name: 'ProductSpec'
	            },
	            {
	                name: 'TotalQty'
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
    var defaultPageSize = 10;
    var toolBar = new Ext.PagingToolbar({
        pageSize: 10,
        store: userGridData,
        displayMsg: '��ʾ��{0}����{1}����¼,��{2}��',
        emptyMsy: 'û�м�¼',
        displayInfo: true
    });
    var pageSizestore = new Ext.data.SimpleStore({
        fields: ['pageSize'],
        data: [[10], [20], [30]]
    });
    var combo1 = new Ext.form.ComboBox({
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
    toolBar.addField(combo1);
    combo1.on("change", function(c, value) {
        toolBar.pageSize = value;
        defaultPageSize = toolBar.pageSize;
    }, toolBar);
    combo1.on("select", function(c, record) {
        toolBar.pageSize = parseInt(record.get("pageSize"));
        defaultPageSize = toolBar.pageSize;
        toolBar.doLoad(0);
    }, toolBar);
    var sm = new Ext.grid.CheckboxSelectionModel({
        singleSelect: true
    });
    var userGrid = new Ext.grid.GridPanel({
        el: 'divOrderGrid',
        //width: '100%',
        height: '100%',
        //autoWidth: true,
        //autoHeight: true,
        autoScroll: true,
        layout: 'fit',
        id: '',
        store: userGridData,
        loadMask: { msg: '���ڼ������ݣ����Ժ��' },
        sm: sm,
        cm: new Ext.grid.ColumnModel([
		//sm,
		new Ext.grid.RowNumberer(), //�Զ��к�
		{
	        header: '��ˮ��',
	        dataIndex: 'OrderId',
	        id: 'OrderId',
	        hidden: true
        },
		{
		    header: '����',
		    dataIndex: 'YearMonth',
		    id: 'YearMonth',
		    renderer: Ext.util.Format.dateRenderer('Y��m��')
		},
		{
		    header: '�ֿ�',
		    dataIndex: 'WhId',
		    id: 'WhId',
		    renderer: function(val, params, record) {
		        if (dsWarehouseList.getCount() == 0) {
		            dsWarehouseList.load();
		        }
		        dsWarehouseList.each(function(r) {
		            if (val == r.data['WhId']) {
		                val = r.data['WhName'];
		                return;
		            }
		        });
		        return val;
		    }
		},
		{
		    header: '��Ʒ����',
		    dataIndex: 'ProductCode',
		    id: 'ProductCode',
		    width:80
		},
		{
		    header: '��ƷID',
		    dataIndex: 'ProductId',
		    id: 'ProductId',
		    hidden: true
		},
		{
		    header: '��Ʒ',
		    dataIndex: 'ProductName',
		    id: 'ProductName',
		    width:150
		},
		{
		    header: '��λ',
		    dataIndex: 'ProductUnit',
		    id: 'ProductUnit',
		    hidden:true,
		    hidable:true
		},
		{
		    header: '��λ',
		    dataIndex: 'SpecUnitName',
		    id: 'SpecUnitName',
		    width:40
		},
		{
		    header: '���',
		    dataIndex: 'ProductSpec',
		    id: 'ProductSpec',
		    width:60
		},
        {
            header: '�Զ��嵥λ�ɱ��ۣ�ȥ˰��',
            dataIndex: 'SpecCostPrice',
            id: 'SpecCostPrice',
		    hidden:true,
		    hidable:true
        },
        {
            header: '�ɱ���',
            dataIndex: 'CostPrice',
            id: 'CostPrice',
		    width:80
        },
        {
            header: 'ȥ˰�ɱ���',
            dataIndex: 'PureCostPrice',
            id: 'PureCostPrice',
		    width:80
        },
		{
		    header: '����ʱ��',
		    dataIndex: 'CreateDate',
		    id: 'CreateDate',
		    format: 'Y��m��d��'
		}

		]),
        bbar: toolBar,
        viewConfig: {
            columnsText: '��ʾ����',
            scrollOffset: 20,
            sortAscText: '����',
            sortDescText: '����',
            forceFit: false
        },
        height: 280,
        closeAction: 'hide',
        stripeRows: true,
        loadMask: true//,
        //autoExpandColumn: 2
    });
    userGrid.render();
    /*------DataGrid�ĺ������� End---------------*/
    updateDataGrid();
})
                   
</script>

</html>
