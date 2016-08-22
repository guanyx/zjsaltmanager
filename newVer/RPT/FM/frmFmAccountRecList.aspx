<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmFmAccountRecList.aspx.cs" Inherits="SCM_FmAccountRecList" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html>
<head>
    <title>Ӧ���˿���ϸ��</title>
    <meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
    <link rel="stylesheet" type="text/css" href="../../ext3/resources/css/ext-all.css" />
    <script type="text/javascript" src="../../ext3/adapter/ext/ext-base.js"></script>
    <script type="text/javascript" src="../../ext3/ext-all.js"></script>
    <script type="text/javascript" src="../../js/operateResp.js"></script>
    <script type="text/javascript" src="../../js/getExcelXml.js"></script>
    <script type="text/javascript" src="../../ext3/src/locale/ext-lang-zh_CN.js"></script>
</head>
<body>
<div id='toolbar'></div>
<div id='searchForm'></div>
<div id='sendGrid'></div>
<%=getComboBoxStore() %>
</body>
<script type="text/javascript">
Ext.BLANK_IMAGE_URL = "../../ext3/resources/images/default/s.gif";
var uploadTransWindow;
Ext.onReady(function(){
var opType;
/*------ʵ��toolbar�ĺ��� start---------------*/
var Toolbar = new Ext.Toolbar({
	renderTo:"toolbar",
	items:[{
		text:"����",
		icon:"../../Theme/1/images/extjs/customer/edit16.gif",
		handler:function(){
		    if(typeComboPanel.getValue()==4||typeComboPanel.getValue()==3){
		        ExportServer();
		    }else{
		        ExportAll(true);   
		    }
		}
	}]
});

/*------����toolbar�ĺ��� end---------------*/


/*------��ʼToolBar�¼����� start---------------*//*-----����Mstʵ���ര�庯��----*/
function ExportServer(){
    if(dsReceiveGrid.getCount()==0){
        Ext.Msg.alert("��ʾ", "û�п��Ե�����¼��Ϣ��");
        return;
    }
    
    if (!Ext.fly('exportAllData'))   
    {   
        var frm = document.createElement('form');   
        frm.id = 'exportAllData';   
        frm.name = id ;   
        //frm.style.display = 'none';   
        frm.className = 'x-hidden'; 
        document.body.appendChild(frm);   
    }  
    var starttime=distributeStartPanel.getValue();
    var endtime = distributeEndPanel.getValue().add(Date.DAY, 1);
    Ext.Ajax.request({   
        timeout: 300000,
        url: 'frmFmAccountRecList.aspx?method=exportData', 
        form: Ext.fly('exportAllData'),   
        method: 'POST',     
        isUpload: true,          
        params: {
            StartDate: Ext.util.Format.date(starttime, 'Y/m/d'),
            EndDate:Ext.util.Format.date(endtime, 'Y/m/d'),
            queryType:typeComboPanel.getValue(),
            ignoreDept:ignoredept
        },
        success: function(resp, opts) {
            //Ext.Msg.hide();
        },
        failure: function(resp, opts) {
             //Ext.Msg.hide();
        }
    });
}
/*-----���˷���Mstʵ���ര�庯��----*/
function ExportAll(isAll) {
    if(!isAll){
	    var sm = distributeGrid.getSelectionModel();
	    //��ȡѡ���������Ϣ
	    //var selectData =  sm.getSelected();
	    var records=sm.getSelections();    
        if (records == null || records.length != 1) 
        {
            Ext.Msg.alert("��ʾ", "��ѡһ����¼��Ϣ��");
            return;
        }
        else 
        {     
            var selectData =  sm.getSelected();         
            
	    }
	} else {

	//Ext.Msg.wait('��������Excel�ĵ�, ���Ժ򡭡�', "ϵͳ��ʾ");
	var vExportContent = receiveGrid.getExcelXml();	
	    var tmpExportContent = receiveGrid.getExcelXml(); //�˷����õ���һ�е���չ  
	    if (!Ext.fly('frmDummy')) {
	        var frm = document.createElement('form');
	        frm.id = 'frmDummy';
	        frm.name = id;
	        frm.style.display = 'none';
	        document.body.appendChild(frm);
	    }
	    Ext.Ajax.request({
	        url: 'ExportService.aspx', //�����ɵ�xml���͵���������  
	        method: 'POST',
	        form: Ext.fly('frmDummy'),
	        isUpload: true, 
	        params: {
	            ExportContent: tmpExportContent,
	            ExportFile:  'Ӧ���˿���ϸ.xls',
                ignoreDept:ignoredept
	        }
	    });  
	    
	    
	}
	    
}

/*------��ʼ��ȡ���ݵĺ��� start---------------*/
var dsReceiveGrid = new Ext.data.Store
({
proxy: new Ext.data.HttpProxy({
   url: "frmFmAccountRecList.aspx?method=getReceiveList",
   timeout: 300000
}),
//url: 'frmFmAccountRecList.aspx?method=getReceiveList',
reader:new Ext.data.JsonReader({
	totalProperty:'totalProperty',
	root:'root'
},[
	{ name: '����' },
	{ name: '�ͻ����' },
	{ name: '�ͻ�����' },
	{ name: 'ժҪ' },
	{ name: '�跽' },
	{ name: '����' },
	])
});

/*------��ȡ���ݵĺ��� ���� End---------------*/
/*------��ʼ��ѯform end---------------*/

    //��ʼ����
    var distributeStartPanel = new Ext.form.DateField({
        xtype:'datefield',
        fieldLabel:'��ʼ����',
        anchor:'95%',
        name:'StartDate',
        id:'StartDate',
        format: 'Y��m��d��',  //���������ʽ
        value:new Date().clearTime() 
    });

    //��������
    var distributeEndPanel = new Ext.form.DateField({
        xtype:'datefield',
        fieldLabel:'��������',
        anchor:'95%',
        name:'EndDate',
        id:'EndDate',
        format: 'Y��m��d��',  //���������ʽ
        value:new Date().clearTime()
    });
    var typeComboPanel = new Ext.form.ComboBox({
        fieldLabel: '��ѯ����',
        id: 'typeMoveTo',
        name: 'typeMoveTo',
        store: [[0,'ȫ���տ��¼'],[1,'�����ƽ�տ��¼'],[3,'���ͻ������տ��¼'],[4,'����Ӧ���˿�']],//[2,'���ͻ�С�Ʋ�ѯ�տ��¼']
        mode: 'local',
        editable: false,
        //loadText:'loading ...',
        typeAhead: true, //�Զ�����һ����������ѡ�ȫ����
        triggerAction: 'all',
        selectOnFocus: true,
        forceSelection: true,
        width: 150,
        value:3,
        listeners:{
            select: function(combo, record, index) {
                if(combo.getValue()==4){
                    receiveGrid.getColumnModel().setColumnHeader( 6, '�������');
                    receiveGrid.getColumnModel().setColumnHeader( 7, '�������');
                    receiveGrid.getColumnModel().setHidden(5, true);
                    receiveGrid.getColumnModel().setHidden(2, true);
                }else{
                    receiveGrid.getColumnModel().setColumnHeader( 6, '�跽');
                    receiveGrid.getColumnModel().setColumnHeader( 7, '����');
                    receiveGrid.getColumnModel().setHidden(5, false);
                    receiveGrid.getColumnModel().setHidden(2, false);
                }
            }
        }
    });
    
    var serchform = new Ext.FormPanel({
        renderTo: 'searchForm',
        labelAlign: 'left',
        layout:'fit',
        buttonAlign: 'right',
        bodyStyle: 'padding:5px',
        frame: true,        
        items: [{
            layout: 'column',   //�����Ԫ��Ϊ����Ϊ�в��ַ�ʽ
            border: false,
            items: [{
                columnWidth: .3,  //����ռ�õĿ�ȣ���ʶΪ20��
                layout: 'form',
                border: false,
                labelWidth: 60,
                items: [
                    typeComboPanel
                ]
            },{
                columnWidth: .28,  //����ռ�õĿ�ȣ���ʶΪ20��
                layout: 'form',
                labelWidth: 80,
                border: false,
                items: [
                    distributeStartPanel
                ]
            }, {
                columnWidth: .28,
                layout: 'form',
                labelWidth: 80,
                border: false,
                items: [
                    distributeEndPanel
                    ]
            }, {
                columnWidth: .08,
                layout: 'form',
                border: false,
                items: [{ cls: 'key',
                    xtype: 'button',
                    text: '��ѯ',
                    anchor: '50%',
                    handler :function(){
                    
                    var starttime=distributeStartPanel.getValue();
                    var endtime = distributeEndPanel.getValue().add(Date.DAY, 1);
                    var stype = typeComboPanel.getValue();

                    dsReceiveGrid.baseParams.StartDate = Ext.util.Format.date(starttime, 'Y/m/d');
                    dsReceiveGrid.baseParams.EndDate = Ext.util.Format.date(endtime, 'Y/m/d');
                    dsReceiveGrid.baseParams.queryType = stype;
                    dsReceiveGrid.baseParams.ignoreDept = ignoredept;
                    
                    dsReceiveGrid.removeAll();
                    dsReceiveGrid.load({
                                params : {
                                start : 0,
                                limit : 32767
                                } });
                    }
                }]
            }]
        }]
    });
/*------��ʼ��ѯform end---------------*/
/*------��ʼDataGrid�ĺ��� start---------------*/

var sm= new Ext.grid.CheckboxSelectionModel({
	singleSelect:false
});
var receiveGrid = new Ext.grid.GridPanel({
	el: 'sendGrid',
	width:'100%',
	//height:'100%',
	height: 400,
	autoWidth:true,
	//autoHeight:true,
	autoScroll:true,
	layout: 'fit',
	title: 'Ӧ���˿���ϸ',
	store: dsReceiveGrid,
	loadMask: {msg:'���ڼ������ݣ����Ժ��'},
	sm:sm,
	cm: new Ext.grid.ColumnModel([
		sm,
		new Ext.grid.RowNumberer(),//�Զ��к�
		{
			header:'����',
			dataIndex: '����',
			id: 'CreateDate',
			width:50
		},
		{
		    header: '�ͻ����',
		    dataIndex: '�ͻ����',
		    id: 'CustomerNo',
		    width:40
		},
		{
		    header: '�ͻ�����',
		    dataIndex: '�ͻ�����',
		    id: 'CustomerName',
		    width: 150
		},
		{
		    header: 'ժҪ',
		    dataIndex: 'ժҪ',
		    id: 'Desc',
		    width: 35
		},
		{
		    header: '�跽',
		    dataIndex: '�跽',
			id:'A'
		},
		{
		    header: '����',
		    dataIndex: '����',
			id:'B'
		}		]),
		viewConfig: {
			columnsText: '��ʾ����',
			scrollOffset: 20,
			sortAscText: '����',
			sortDescText: '����',
			forceFit: true
		},
		enableHdMenu: false,  //����ʾ�����ֶκ���ʾ����������
		enableColumnMove: false,//�в����ƶ�
		closeAction: 'hide',
		stripeRows: true,
		loadMask: true,
		autoExpandColumn: 2
	});
	receiveGrid.render();

/*------��ϸDataGrid�ĺ������� End---------------*/

})
</script>
</html>
