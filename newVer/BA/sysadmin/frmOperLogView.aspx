<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmOperLogView.aspx.cs" Inherits="BA_sysadmin_frmOperLogView" %>

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
<%=getComboBoxStore( )%>
</body>
<script type="text/javascript">
Ext.BLANK_IMAGE_URL = "../../ext3/resources/images/default/s.gif";  //��Ϊ���������������������ͼƬ��ʾ
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
            columnWidth:0.3,
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
            columnWidth:0.3,
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
            columnWidth:0.3,
            items: [
                {
	                xtype:'combo',
	                fieldLabel:'����Ա',
	                columnWidth:0.5,
	                anchor:'90%',
	                name:'OperId',
	                id:'OperId',
	                store:dsOper,
	                valueField:'EmpId',
	                displayField:'EmpName',
	                editable:false,
	                triggerAction:'all',
	                mode:'local'
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
                        viewLogData.baseParams.OperId = Ext.getCmp('OperId').getValue();
                        //operID
                        viewLogData.load({params:{start:0,limit:20}});
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
    url: 'frmOperLogView.aspx?method=getLogList',
    reader: new Ext.data.JsonReader({
        totalProperty: 'totalProperty',
        root: 'root'
    }, [
        {
		name:'LogId'
	},
	{
		name:'LogGuid'
	},
	{
		name:'LogLevel'
	},
	{
		name:'ClassName'
	},
	{
		name:'MethodName'
	},
	{
		name:'RecordTime'
	},
	{
		name:'StackTrace'
	},
	{
		name:'OriginalUrl'
	},
	{
		name:'OtherInfo'
	},
	{
		name:'LogContent'
	},
	{
		name:'OrgId'
	},
	{
		name:'OperId'
	},
	{
		name:'OrgName'
	},
	{
		name:'UserName'
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
    cm: new Ext.grid.ColumnModel([
    new Ext.grid.RowNumberer(),//�Զ��к�
    {
		header:'������־ID',
		dataIndex:'LogId',
		id:'LogId',
		hidden:true,
		hideable:false
	},
	{
		header:'��������',
		dataIndex:'OrgName',
		id:'OrgName'
	},
	{
		header:'�û���',
		dataIndex:'UserName',
		id:'UserName'
	},
	{
		header:'��־����',
		dataIndex:'LogLevel',
		id:'LogLevel'
	},
//	{
//		header:'��������',
//		dataIndex:'ClassName',
//		id:'ClassName'
//	},
//	{
//		header:'������',
//		dataIndex:'MethodName',
//		id:'MethodName'
//	},
	{
		header:'��¼ʱ��',
		dataIndex:'RecordTime',
		id:'RecordTime'
	},
//	{
//		header:'������Ϣ',
//		dataIndex:'StackTrace',
//		id:'StackTrace'
//	},
//	{
//		header:'ԭʼ����URL',
//		dataIndex:'OriginalUrl',
//		id:'OriginalUrl'
//	},
//	{
//		header:'������Ϣ',
//		dataIndex:'OtherInfo',
//		id:'OtherInfo'
//	},
	{
		header:'��־����',
		dataIndex:'LogContent',
		id:'LogContent',
		width:200
	}
//	{
//		header:'������֯',
//		dataIndex:'OrgId',
//		id:'OrgId'
//	},
//	{
//		header:'������Ա',
//		dataIndex:'OperId',
//		id:'OperId'
//	}
			]),
    bbar: new Ext.PagingToolbar({
        pageSize: 20,
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
