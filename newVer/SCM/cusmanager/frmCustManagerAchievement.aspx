<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmCustManagerAchievement.aspx.cs" Inherits="SCM_cusmanager_frmCustManagerAchievement" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html>
<head>
<title>订单统计</title><meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
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
           monitorValid: true, // 把有formBind:true的按钮和验证绑定
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
                        fieldLabel:'公司标识',
                        anchor:'98%',
                        name:'OrgName',
                        id:'OrgId',
                        store: dsOrg,
                        displayField: 'OrgName',  //这个字段和业务实体中字段同名
                        valueField: 'OrgId',      //这个字段和业务实体中字段同名
                        typeAhead: true, //自动将第一个搜索到的选项补全输入
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
//                       fieldLabel: '配送方式',
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
                        fieldLabel:'开始日期',
                        anchor:'98%',
                        name:'StartDate',
                        id:'StartDate',
                        format:'Y年m月d日',
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
                        fieldLabel:'结束时间',
                        anchor:'98%',
                        name:'EndDate',
                        id:'EndDate',
                        format:'Y年m月d日',
                        value:new Date().clearTime()
	                }]
                }]
		    }],
		    buttons: [
		    {
			    text: "查询",
			    handler: function() {
				    selectSearchData();
			    }, 
			    scope: this
		    },
		    {
			    text: "重置", 
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
             Ext.Msg.alert("提示", "请修改开始时间和结束时间为同一年！");
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
    //添加默认项
//    dsDlvType.insert(0, new Ext.data.Record({ 'DicsCode': '', 'DicsName': '全部' }, '-1'));
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
        loadMask: { msg: '正在加载数据，请稍侯……' },
        sm: smOrder,
        cm: new Ext.grid.ColumnModel([
        smOrder,
        new Ext.grid.RowNumberer(),//自动行号
        {
            header:'Manager标识',
            dataIndex:'Id',
            id:'Id',
            hidden:true,
            hideable:false
        },
        {
            header:'客户经理名称',
            dataIndex:'Name',
            id:'Name'
        },
        {
            header:'总订单数',
            dataIndex:'Totalorders',
            id:'Totalorders'
        },
        {
            header:'客户经理下单数',
            dataIndex:'Ownerorders',
            id:'Ownerorders'
        },
        {
            header:'非客户经理下单数',
            dataIndex:'Nonownerorders',
            id:'Nonownerorders'
        },
        {
            header:'订单客户数',
            dataIndex:'Ordercustomers',
            id:'Ordercustomers'
        },
        {
            header:'有效订单户数',
            dataIndex:'Validorders',
            id:'Validorders'
        },
        {
            header:'年度指标订单数',
            dataIndex:'Orders',
            id:'Orders'
        },
        {
            header:'年度指标销售额',
            dataIndex:'OrderAmount',
            id:'OrderAmount'
        },
        {
            header:'年度指标拥有客户',
            dataIndex:'Customers',
            id:'Customers'
        }		]),
        bbar: new Ext.PagingToolbar({
            pageSize: 10,
            store: OrderSerachGridData,
            displayMsg: '显示第{0}条到{1}条记录,共{2}条',
            emptyMsy: '没有记录',
            displayInfo: true
        }),
        viewConfig: {
            columnsText: '显示的列',
            scrollOffset: 20,
            sortAscText: '升序',
            sortDescText: '降序',
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
