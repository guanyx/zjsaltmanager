<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmWsProudctStat.aspx.cs" Inherits="RPT_PMS_frmWsProudctStat" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>��������</title>
    <meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
    <link rel="stylesheet" type="text/css" href="../../ext3/resources/css/ext-all.css" />
    <script type="text/javascript" src="../../ext3/adapter/ext/ext-base.js"></script>
    <script type="text/javascript" src="../../ext3/ext-all.js"></script>
    <link rel="stylesheet" href="../../css/Ext.ux.grid.GridSummary.css"/>
    <script type="text/javascript" src='../../js/Ext.ux.grid.GridSummary.js'></script>
    <script type="text/javascript" src="../../js/floatUtil.js"></script>
    <script type="text/javascript" src="../../ext3/src/locale/ext-lang-zh_CN.js"></script>
</head>
<%=getComboBoxStore()%>
<body>
<div id='toolbar'></div>
<div id='searchForm'></div>
<div id='gird'></div>
</body>
<script type="text/javascript">
Ext.BLANK_IMAGE_URL = "../../ext3/resources/images/default/s.gif";
Ext.onReady(function(){
/*------ʵ��toolbar�ĺ��� start---------------*/
        var Toolbar = new Ext.Toolbar({
            renderTo: "toolbar",
            items: [{
                text: "�鿴�ʼ쵥",
                icon: "../../Theme/1/images/extjs/customer/view16.gif",
                handler: function() { ViewNoticeWin(); }
            }]
            });
            /*-----ʵ���ര�庯��----*/
            function ViewNoticeWin() {
                var sm = viewGrid.getSelectionModel();
                var selectData = sm.getSelected();                         

                //���û��ѡ�񣬾���ʾ��Ҫѡ��������Ϣ
                if (selectData == null || selectData == "") {
                    Ext.Msg.alert("��ʾ", "��ѡ����Ҫ�鿴�ļ�¼��");
                    return;
                }
                //�Ƿ�֮��
                if(selectData.get('BizStatus') != 'P013'){
                    Ext.Msg.alert("��ʾ", "�ü�¼��δ�ʼ죡");
                    return;
                }
                var noticeid =selectData.get('QtNoticeId');
                var pn = selectData.get('ProductId');
                showresult(pn,noticeid);
                
            }
            if (typeof (resultWindow) == "undefined") {//�������2��windows����
                       var resultWindow = new Ext.Window({
                           title: '�ʼ챨��',
                           modal: 'true',
                           width: 600,
                           y: 50,
                           autoHeigth: true,
                           collapsible: true, //�Ƿ�����۵� 
                           closable: true, //�Ƿ���Թر� 
                           //maximizable : true,//�Ƿ������� 
                           closeAction: 'hide',
                           constrain: true,
                           resizable: false,
                           plain: true,
                           // ,items: addQuotaForm
                           buttons: [ {
                               text: '�ر�',
                               handler: function() {
                                   resultWindow.hide();
                                   var s = result.getEl().dom.lastChild.lastChild;
                                   var ss = s.childNodes;
                                   var sss = ss.length;
                                   s.removeChild(ss[sss - 1]);
                               }
}]
                           });
                       }
            function showresult(prno,id) {
               resultWindow.show();
               Ext.Ajax.request({
                   url: "frmQtQualityCheckNotify.aspx?method=showrsult"
                           , params: {
                               checkid: id
                                , prno: prno

                           },
                   success: function(response, options) {
                       var data = response.responseText;
                       printstr = data;
                       var divobj = document.createElement("div");
                       divobj.innerHTML = data;
                       result.getEl().dom.lastChild.lastChild.appendChild(divobj);

                   }
           ,
                   failure: function() {
                       Ext.Msg.alert("��ʾ", "��ȡָ�����������,�����´򿪸�ҳ��");
                   }
               });
           }
            
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

    //��ʼ����
    var beginStartDatePanel = new Ext.form.DateField({
        xtype:'datefield',
        fieldLabel:'��ʼ����',
        anchor:'95%',
        format: 'Y��m��d��',  //���������ʽ
        value:new Date().getFirstDateOfMonth().clearTime() 
    });
    
    //��������
    var beginEndDatePanel = new Ext.form.DateField({
        xtype:'datefield',
        fieldLabel:'��ʼ����',
        anchor:'95%',
        format: 'Y��m��d��',  //���������ʽ
        value:new Date().getLastDateOfMonth().clearTime() 
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
            }
            ]
         }
        ,{
            layout: 'column',   //�����Ԫ��Ϊ����Ϊ�в��ַ�ʽ
            border: false,
            items: [{
                columnWidth: .3,  //����ռ�õĿ�ȣ���ʶΪ20��
                layout: 'form',
                border: false,
                items: [
                    beginStartDatePanel
                ]
            },{
                columnWidth: .3,  //����ռ�õĿ�ȣ���ʶΪ20��
                layout: 'form',
                border: false,
                items: [
                    beginEndDatePanel
                ]
            },{
                columnWidth: .2,
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
                    var beginStartDate = Ext.util.Format.date(beginStartDatePanel.getValue(), 'Y/m/d');
                    var beginEndDate = Ext.util.Format.date(beginEndDatePanel.getValue(), 'Y/m/d');
                    
                   gridStore.baseParams.OrgId = orgId;
                   gridStore.baseParams.WsId = wsId;
                   gridStore.baseParams.ProductName = productName;
                   gridStore.baseParams.StartDate=beginStartDate;
                   gridStore.baseParams.EndDate=beginEndDate;
                   //gridStore.baseParams.limit=10;
                   //gridStore.baseParams.start=0;
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
			header:'��������',
			dataIndex:'ManuDate',
			id:'ManuDate',
			tooltip:'��������',
			renderer: Ext.util.Format.dateRenderer('Y��m��d��'),
			width:100
		},
		{
		    header:'����',
			dataIndex:'WsName',
			id:'WsName',
			tooltip:'����',
			width:60
		},
		{
			header:'���',
			dataIndex:'GroupIds',
			id:'GroupIds',
			tooltip:'���',
			width:60
		},
		{
			header:'��Ʒ���',
			dataIndex:'ProductNo',
			id:'ProductNo',
			tooltip:'��Ʒ���',
			width:80
		},
		{
		    header:'��Ʒ����',
			dataIndex:'ProductName',
			id:'ProductName',
			tooltip:'��Ʒ����',
			width:150
		},
		{
			header:'���',
			dataIndex:'SpecificationsText',
			id:'SpecificationsText',
			tooltip:'���',
			width:60
		},
		{
			header:'��λ',
			dataIndex:'UnitText',
			id:'UnitText',
			tooltip:'��λ',
			width:40
		},
		{
		    header:'��������',
			dataIndex:'ManuQty',
			id:'ManuQty',
			summaryType: 'sum',
			tooltip:'',
			width:60
		},
		{
		    header:'��������',
			dataIndex:'ManuAmt',
			id:'ManuAmt',
			summaryType: 'sum',
			tooltip:'',
			width:80
			,summaryRenderer:function(v){
			    return v +'��';
			}
		},
		{
		    header:'״̬',
			dataIndex:'DicsName',
			id:'DicsName',
			tooltip:'',
			width:60
		},
		{
		    header:'������',
			dataIndex:'OperName',
			id:'OperName',
			tooltip:'',
			width:50
		},
		{
		    header:'�����',
			dataIndex:'AuditName',
			id:'AuditName',
			tooltip:'',
			width:50
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
	    {       name:'QtNoticeId'},
	    {       name:'WsName'},
	    {       name:'GroupIds'},
	    {       name:'ManuDate'},
	    {       name:'OperName'},
	    {       name:'AuditName'}
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
