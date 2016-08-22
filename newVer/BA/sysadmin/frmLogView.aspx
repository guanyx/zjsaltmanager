<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmLogView.aspx.cs" Inherits="BA_sysadmin_frmLogView" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html>
<head>
<title>��־��ѯ����</title><meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<link rel="stylesheet" type="text/css" href="../../ext3/resources/css/ext-all.css" />
<script type="text/javascript" src="../../ext3/adapter/ext/ext-base.js"></script>
<script type="text/javascript" src="../../ext3/ext-all.js"></script>
</head>
<body>
<div id='toolbar'></div>
<div id='divSearchForm'></div>
<div id='divDataGrid'></div>
</body>
<script type="text/javascript">
Ext.BLANK_IMAGE_URL = "../ext3/resources/images/default/s.gif";  //��Ϊ���������������������ͼƬ��ʾ
Ext.onReady(function() {
    
/*------ʵ��toolbar�ĺ��� start---------------*/
var Toolbar = new Ext.Toolbar({
    renderTo: "toolbar",
    items: [{
        text: "��ϸ��Ϣ",
        icon: "../../Theme/1/images/extjs/customer/view16.gif",
        handler: function() { ViewDetailWin(); }
    }]
});
/*------����toolbar�ĺ��� end---------------*/

/*-----�༭Orderʵ���ര�庯��----*/
function ViewDetailWin() {
    var sm = OrderMstGrid.getSelectionModel();
    //��ȡѡ���������Ϣ
    var selectData = sm.getSelected();
    if (selectData == null) {
        Ext.Msg.alert("��ʾ", "��ѡ����Ҫ�༭����Ϣ��");
        return;
    }
}
          
var serchform = new Ext.FormPanel({
    renderTo: 'divSearchForm',
    labelAlign: 'left',
//                    layout: 'fit',
    buttonAlign: 'center',
    bodyStyle: 'padding:5px',
    frame: true,
    labelWidth: 55,
    items:[
    {
        layout:'column',
        border: false,
        labelSeparator: '��',
        items: [
        {
            layout:'form',
            border: false,
            columnWidth:0.33,
            items: [
                {
	                xtype:'datefield',
	                fieldLabel:'��ʼ����',
	                columnWidth:0.5,
	                anchor:'90%',
	                name:'StartDate',
	                id:'StartDate',
                    format: 'Y��m��d�� H:i:s',  //���������ʽ
                    value:new Date().getFirstDateOfMonth().clearTime()
                }
                    ]
        }
,		{
            layout:'form',
            border: false,
            columnWidth:0.34,
            items: [
                {
	                xtype:'datefield',
	                fieldLabel:'��������',
	                columnWidth:0.5,
	                anchor:'90%',
	                name:'EndDate',
	                id:'EndDate',
                    format: 'Y��m��d��  H:i:s',  //���������ʽ
                    value:new Date()
                }
                    ]
        }
,		{
            layout:'form',
            border: false,
            columnWidth:0.1,
            items: [
                {
	                xtype:'button',
	                text:'��ѯ',
	                columnWidth:0.5,
	                anchor:'90%',
	                handler:function() {
                        viewLogData.baseParams.StartTime = Ext.util.Format.date(Ext.getCmp('StartDate').getValue(),'Y/m/d H:i:s');
                        viewLogData.baseParams.EndTime = Ext.util.Format.date(Ext.getCmp('EndDate').getValue(),'Y/m/d H:i:s');
                        //operID
                        viewLogData.load({params:{start:0,limit:10}});
                    }
                }
                    ]
        }
    ]}             
    ]

});


/*------��ʼ��ѯform�ĺ��� end---------------*/

/*------��ʼ��ȡ���ݵĺ��� start---------------*/
var viewLogData = new Ext.data.Store
({
    url: 'frmLogView.aspx?method=getLogList',
    reader: new Ext.data.JsonReader({
        totalProperty: 'totalProperty',
        root: 'root'
    }, [
        {
            name:'Datetime'
        },
        {
            name:'Thread'
        },
        {
            name:'LogLevel'
        },
        {
            name:'Logger'
        },
        {
            name:'Message'
        }	])     
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
var LogGrid = new Ext.grid.GridPanel({
    el: 'divDataGrid', 
    height: '100%',
    autoHeight: true,
    autoScroll: true,
    layout: 'fit',
    id: '',
    store: viewLogData,
    loadMask: { msg: '���ڼ������ݣ����Ժ��' },
    sm: sm,
    cm: new Ext.grid.ColumnModel([
    sm,
    new Ext.grid.RowNumberer(),//�Զ��к�
    {
        header:'��־ʱ��',
        dataIndex:'Datetime',
        id:'datetime',
        width:100
    },
    {
        header:'�߳�',
        dataIndex:'Thread',
        id:'thread',
        width:80
    },
    {
        header:'��־����',
        dataIndex:'LogLevel',
        id:'log_level',
        width:160
    },
    {
        header:'',
        dataIndex:'Logger',
        id:'logger',
        width:70,
        hidden:true,
        hideable:false
    },
    {
        header:'����',
        dataIndex:'Message',
        id:'message',
        width:360
    }		]),
    bbar: new Ext.PagingToolbar({
        pageSize: 10,
        store: viewLogData,
        displayMsg: '��ʾ��{0}����{1}����¼,��{2}��',
        emptyMsy: 'û�м�¼',
        displayInfo: true
    }),
    viewConfig: {
        columnsText: '��ʾ����',
        scrollOffset: 20,
        sortAscText: '����',
        sortDescText: '����'
    },
    height: 280
});
LogGrid.render();
/*------DataGrid�ĺ������� End---------------*/
})
</script>

</html>
