<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmCustManagerAchievement.aspx.cs" Inherits="SCM_cusmanager_frmCustManagerAchievement" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html>
<head>
<title>����ͳ��</title><meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<link rel="stylesheet" type="text/css" href="../../ext3/resources/css/ext-all.css" />
<script type="text/javascript" src="../../ext3/adapter/ext/ext-base.js"></script>
<script type="text/javascript" src="../../ext3/ext-all.js"></script>
<script type="text/javascript" src="../../ext3/src/locale/ext-lang-zh_CN.js"></script>
</head>
<body>
<div id='divSearchForm'></div>
<div id='divDataGrid'></div>
</body>
<script type="text/javascript">
function getParamerValue( name )
{
  name = name.replace(/[\[]/,"\\\[").replace(/[\]]/,"\\\]");
  var regexS = "[\\?&]"+name+"=([^&#]*)";
  var regex = new RegExp( regexS );
  var results = regex.exec( window.location.href );
  if( results == null )
    return "";
  else
    return results[1];
}
var IsCustManager = getParamerValue('custManager');
</script>
<%=getComboBoxStore()%>
<script type="text/javascript">
Ext.BLANK_IMAGE_URL = "../../ext3/resources/images/default/s.gif";  
Ext.onReady(function() {  
    var searchOrderPanel = new  Ext.Panel({   
           frame: true,
           renderTo:'divSearchForm',
           buttonAlign:'center',
           monitorValid: true, // ����formBind:true�İ�ť����֤��
           items:[
	       {
                layout:'column',
                border: false,
                items: [
                {
	                layout:'form',
	                border: false,
	                labelWidth: 55,
	                columnWidth:0.25,
	                items: [
		            {
		                xtype:'combo',
                        fieldLabel:'��˾��ʶ',
                        anchor:'98%',
                        name:'OrgName',
                        id:'OrgId',
                        store: dsOrg,
                        displayField: 'OrgName',  //����ֶκ�ҵ��ʵ�����ֶ�ͬ��
                        valueField: 'OrgId',      //����ֶκ�ҵ��ʵ�����ֶ�ͬ��
                        typeAhead: true, //�Զ�����һ����������ѡ�ȫ����
                        triggerAction: 'all',
                        emptyValue: '',
                        selectOnFocus: true,
                        forceSelection: true,
                        mode:'local' ,
                        listeners: {
                           select: function(combo, record, index) {
//                                var curOrgId = Ext.getCmp('OrgId').getValue();
//                                dsWareHouse.load({
//                                    params: {
//                                        orgID: curOrgId
//                                    }
//                                });
                            }
                        }  
		            }]
		        }
                ,
//		        {
//	                layout:'form',
//	                border: false,
//	                labelWidth: 55,
//	                columnWidth:0.25,
//	                items: [
//		            {
//		                xtype: 'combo',
//                       store: dsDlvType,
//                       valueField: 'DicsCode',
//                       displayField: 'DicsName',
//                       mode: 'local',
//                       forceSelection: true,
//                       editable: false,
//                       emptyValue: '',
//                       triggerAction: 'all',
//                       fieldLabel: '���ͷ�ʽ',
//                       name:'DlvType',
//                       id:'DlvType',
//                       selectOnFocus: true,
//                       anchor: '98%'
//	                }]
//                },
                {
	                layout:'form',
	                border: false,
	                labelWidth: 55,
	                columnWidth:0.25,
	                items: [
	                {
		                 xtype:'datefield',
                        fieldLabel:'��ʼ����',
                        anchor:'98%',
                        name:'StartDate',
                        id:'StartDate',
                        format:'Y��m��d��',
                        value:new Date().clearTime()
	                }]
                },
                {
	                layout:'form',
	                border: false,
	                labelWidth: 55,
	                columnWidth:0.25,
	                items: [
	                {
		               xtype:'datefield',
                        fieldLabel:'����ʱ��',
                        anchor:'98%',
                        name:'EndDate',
                        id:'EndDate',
                        format:'Y��m��d��',
                        value:new Date().clearTime()
	                }]
                }]
		    }],
		    buttons: [
		    {
			    text: "��ѯ",
			    handler: function() {
				    selectSearchData();
			    }, 
			    scope: this
		    },
		    {
			    text: "����", 
			    handler: function() { 
				    resetCondtion();
			    }, 
			    scope: this
		    }]
    });
    searchOrderPanel.render();
    function selectSearchData(){
        var start = Ext.util.Format.date(Ext.getCmp('StartDate').getValue(),'Y/m/d');
        var end = Ext.util.Format.date(Ext.getCmp('EndDate').getValue(),'Y/m/d');
       
        if(start.substr(0,4)!=end.substr(0,4)){
             Ext.Msg.alert("��ʾ", "���޸Ŀ�ʼʱ��ͽ���ʱ��Ϊͬһ�꣡");
             return;
        } 
        OrderSerachGridData.baseParams.OrgId = Ext.getCmp('OrgId').getValue();	
        if(IsCustManager=='true')
            OrderSerachGridData.baseParams.IsCustManager='true';               
        OrderSerachGridData.baseParams.StartDate=start;
        OrderSerachGridData.baseParams.EndDate=end;
        OrderSerachGridData.load({
            params: {
                start: 0,
                limit: 10
            }
        });
    }
    function resetCondtion(){
       
    }
    //���Ĭ����
//    dsDlvType.insert(0, new Ext.data.Record({ 'DicsCode': '', 'DicsName': 'ȫ��' }, '-1'));
//    Ext.getCmp('DlvType').setValue('');
/****************************************************************/
    var OrderSerachGridData = new Ext.data.Store({
        url: 'frmCustManagerAchievement.aspx?method=getOrderList',
        reader: new Ext.data.JsonReader({
            totalProperty: 'totalProperty',
            root: 'root'
        }, [
            {name:'Id'  },
            {name:'Name' },
            {name:'Totalorders' },
            {name:'Ownerorders'  },
            {name:'Nonownerorders'},
            {name:'Ordercustomers' },
            {name:'Validorders'  },
            {name:'Orders' },
            {name:'OrderAmount'   },
            {name:'Customers'}	
            ])
    });         

    var smOrder = new Ext.grid.CheckboxSelectionModel({
        singleSelect: true
    });
    var OrderSerachGrid = new Ext.grid.GridPanel({
        el: 'divDataGrid',
        width: '100%',
        height: '100%',
        autoWidth: true,
        autoHeight: true,
        autoScroll: true,
        layout: 'fit',
        id: '',
        store: OrderSerachGridData,
        loadMask: { msg: '���ڼ������ݣ����Ժ��' },
        sm: smOrder,
        cm: new Ext.grid.ColumnModel([
        smOrder,
        new Ext.grid.RowNumberer(),//�Զ��к�
        {
            header:'Manager��ʶ',
            dataIndex:'Id',
            id:'Id',
            hidden:true,
            hideable:false
        },
        {
            header:'�ͻ���������',
            dataIndex:'Name',
            id:'Name'
        },
        {
            header:'�ܶ�����',
            dataIndex:'Totalorders',
            id:'Totalorders'
        },
        {
            header:'�ͻ������µ���',
            dataIndex:'Ownerorders',
            id:'Ownerorders'
        },
        {
            header:'�ǿͻ������µ���',
            dataIndex:'Nonownerorders',
            id:'Nonownerorders'
        },
        {
            header:'�����ͻ���',
            dataIndex:'Ordercustomers',
            id:'Ordercustomers'
        },
        {
            header:'��Ч��������',
            dataIndex:'Validorders',
            id:'Validorders'
        },
        {
            header:'���ָ�궩����',
            dataIndex:'Orders',
            id:'Orders'
        },
        {
            header:'���ָ�����۶�',
            dataIndex:'OrderAmount',
            id:'OrderAmount'
        },
        {
            header:'���ָ��ӵ�пͻ�',
            dataIndex:'Customers',
            id:'Customers'
        }		]),
        bbar: new Ext.PagingToolbar({
            pageSize: 10,
            store: OrderSerachGridData,
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
    OrderSerachGrid.render();


var gs =Ext.getCmp('OrgId');
gs.setValue(<% =ZJSIG.UIProcess.ADM.UIAdmUser.OrgID(this)%>);
gs.setDisabled(true);
});
</script>
</html>
