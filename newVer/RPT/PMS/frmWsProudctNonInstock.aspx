<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmWsProudctNonInstock.aspx.cs" Inherits="RPT_PMS_frmWsProudctNoneInstock" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>δ����ѯ</title>
    <meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
    <link rel="stylesheet" type="text/css" href="../../ext3/resources/css/ext-all.css" />
    <script type="text/javascript" src="../../ext3/adapter/ext/ext-base.js"></script>
    <script type="text/javascript" src="../../ext3/ext-all.js"></script>
    <link rel="stylesheet" href="../../css/Ext.ux.grid.GridSummary.css"/>
    <script type="text/javascript" src='../../js/Ext.ux.grid.GridSummary.js'></script>
    <script type="text/javascript" src="../../js/floatUtil.js"></script>
    
</head>
<%=getComboBoxStore()%>
<body>
<div id='searchForm'></div>
<div id='gird'></div>
</body>
<script type="text/javascript">
Ext.BLANK_IMAGE_URL = "../../ext3/resources/images/default/s.gif";
Ext.onReady(function(){
            
/*--------------serach--------------*/
    var ArriveOrgPostPanel = new Ext.form.ComboBox({
        style: 'margin-left:0px',
        cls: 'key',
        xtype: 'combo',
        fieldLabel: '��˾',
        name: 'nameOrg',
        anchor: '95%',
        store: dsOrgListInfo,
        mode: 'local',
        displayField: 'OrgName',
        valueField: 'OrgId',
        triggerAction: 'all',
        editable: false,
        value: dsOrgListInfo.getAt(0).data.OrgId
    });
    
    //��������
    var WsNamePanel = new Ext.form.ComboBox({
        xtype:'combo',
        fieldLabel:'����',
        anchor:'95%',
	    store:dsWs,
	    displayField:'WsName',
        valueField:'WsId',
        mode:'local',
        triggerAction:'all',
        editable: false
    });
    
    //��Ʒ����
    var productNamePanel = new Ext.form.TextField({
        xtype:'textfield',
        fieldLabel:'��Ʒ����',
        anchor:'95%'
    });

    var serchform = new Ext.FormPanel({
        renderTo: 'searchForm',
        labelAlign: 'left',
        // layout:'fit',
        buttonAlign: 'right',
        bodyStyle: 'padding:5px',
        frame: true,
        labelWidth: 55,
        items: [
        {
            layout: 'column',   //�����Ԫ��Ϊ����Ϊ�в��ַ�ʽ
            border: false,
            items: [{
                columnWidth: .3,  //����ռ�õĿ�ȣ���ʶΪ20��
                layout: 'form',
                border: false,
                items: [
                    ArriveOrgPostPanel
                ]
            },{
                columnWidth: .3,  //����ռ�õĿ�ȣ���ʶΪ20��
                layout: 'form',
                border: false,
                items: [
                    WsNamePanel
                ]
            },{
                columnWidth: .3,  //����ռ�õĿ�ȣ���ʶΪ20��
                layout: 'form',
                border: false,
                items: [
                    productNamePanel
                ]
            },{
                columnWidth: .1,
                layout: 'form',
                border: false,
                items: [
                { 
                    cls: 'key',
                    xtype: 'button',
                    text: '��ѯ',
                    anchor: '50%',
                    handler: function() {  
                    var orgId = ArriveOrgPostPanel.getValue();
                    var wsId = WsNamePanel.getValue();
                    var productName = productNamePanel.getValue();
  
                   gridStore.baseParams.OrgId = orgId;
                   gridStore.baseParams.WsId = wsId;
                   gridStore.baseParams.ProductName = productName;
                   gridStore.baseParams.InStock = 'P014';
                   gridStore.load();
                    
                    }
                }]
            }]
        }]
    });
    var colModel = new Ext.grid.ColumnModel({
	columns: [ 
		new Ext.grid.RowNumberer(),			
		{
			header:'��Ʒ���',
			dataIndex:'ProductNo',
			id:'ProductNo',
			tooltip:'��Ʒ���'
		},
		{
		    header:'��Ʒ����',
			dataIndex:'ProductName',
			id:'ProductName',
			tooltip:'��Ʒ����'
		},
		{
			header:'���',
			dataIndex:'SpecificationsText',
			id:'SpecificationsText',
			tooltip:'���'
		},
		{
			header:'��λ',
			dataIndex:'UnitText',
			id:'UnitText',
			tooltip:'��λ'
		},
		{
		    header:'��������',
			dataIndex:'ManuQty',
			id:'ManuQty',
			summaryType: 'sum',
			tooltip:''
		},
		{
		    header:'��������',
			dataIndex:'ManuAmt',
			id:'ManuAmt',
			summaryType: 'sum',
			tooltip:''
//			summaryRenderer:function(v){
//			    return v ;
//			}
		},
		{
		    header:'״̬',
			dataIndex:'DicsName',
			id:'DicsName',
			tooltip:''
		}
        ]
    });
    var gridStore = new Ext.data.Store({
        url: 'frmWsProudctStat.aspx?method=getlist',
         reader :new Ext.data.JsonReader({
        totalProperty: 'totalProperty',
        root: 'root',
        fields: [
	    {		name:'ProductId'	},
	    {		name:'ProductNo'	},
	    {		name:'ProductName'	},
	    {		name:'SpecificationsText'	},
	    {		name:'UnitText'	},
	    {		name:'ManuQty'	},
	    {		name:'ManuAmt'	},
	    {       name:'BizStatus'},
	    {		name:'DicsName'	},
	    {       name:'QtNoticeId'}
	    ]
        })
    });
    var sm = new Ext.grid.CheckboxSelectionModel({
            singleSelect: true
    }); 
    //�ϼ���
    var summary = new Ext.ux.grid.GridSummary();

    var viewGrid = new Ext.grid.EditorGridPanel({
        renderTo:"gird",                
        id: 'viewGrid',
        //region:'center',
        split:true,
        store: gridStore ,
        autoscroll:true,
        height:350,
        width:document.clientWidth,
        title:'',
        loadMask: { msg: '���ڼ������ݣ����Ժ��' },
        sm: sm,
        cm:colModel,
        viewConfig: {
            columnsText: '��ʾ����',
            scrollOffset: 20,
            sortAscText: '����',
            sortDescText: '����',
            forceFit: true
        },
        plugins: summary,
        loadMask: true,
        closeAction: 'hide',
        stripeRows: true    
    });

    ArriveOrgPostPanel.setValue(<% =ZJSIG.UIProcess.ADM.UIAdmUser.OrgID(this)%>); 
    if(ArriveOrgPostPanel.getValue() !=1)
        ArriveOrgPostPanel.setDisabled(true);
})
</script>
</html>
