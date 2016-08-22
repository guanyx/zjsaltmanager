 <%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmPmsStock.aspx.cs" Inherits="WMS_frmPmsStock" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html>
<head>
    <title>���������</title><meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<link rel="stylesheet" type="text/css" href="../ext3/resources/css/ext-all.css" />
<script type="text/javascript" src="../ext3/adapter/ext/ext-base.js"></script>
<script type="text/javascript" src="../ext3/ext-all.js"></script>
<script type="text/javascript" src="../ext3/example/TabCloseMenu.js" charset="gb2312"></script>
<script type="text/javascript" src="../ext3/example/ItemDeleter.js"></script>
<script type="text/javascript" src="../js/operateResp.js"></script>
<script type="text/javascript" src="../ext3/src/locale/ext-lang-zh_CN.js"></script>
</head>
<body>
<div id='MainToolbar'></div>
<div id='MainSearchForm'></div>
<div id='MainDataGrid'></div>

</body>
<%=getComboBoxStore()%>
<script type="text/javascript">
function GetUrlParms() {
    var args = new Object();
    var query = location.search.substring(1); //��ȡ��ѯ��   
    var pairs = query.split("&"); //�ڶ��Ŵ��Ͽ�   
    for (var i = 0; i < pairs.length; i++) {
        var pos = pairs[i].indexOf('='); //����name=value   
        if (pos == -1) continue; //���û���ҵ�������   
        var argname = pairs[i].substring(0, pos); //��ȡname   
        var value = pairs[i].substring(pos + 1); //��ȡvalue   
        args[argname] = unescape(value); //��Ϊ����   
    }
    return args;
}
var args = new Object();
args = GetUrlParms();

var type = args["type"];
        
var orgId;
var operId;
var whId;
var customerId;
Ext.BLANK_IMAGE_URL = "../ext3/resources/images/default/s.gif"; 
Ext.onReady(function() {
var titleName = "";
switch(type){
    case "P041":
        titleName = "���������˻�";
    break;
    case "P042":
        titleName = "��������";
    break;
    case "P043":
        titleName = "�������";
    break;
}
    /*------ʵ��toolbar�ĺ��� start---------------*/
    var Toolbar = new Ext.Toolbar({
        renderTo: "MainToolbar",
        items: [
        {
            text: titleName,
            icon: "../Theme/1/images/extjs/customer/add16.gif",
            handler: function() { OutDraw() ;  }
        }]
        });
    /*------����toolbar�ĺ��� end---------------*/

    /*-----ʵ�庯��----*/
    function OutDraw() {
    //uploadOrderWindow.show();
    
   
        var sm = userGrid.getSelectionModel();
        var selectData = sm.getSelected();
        if (selectData == null) {
            Ext.Msg.alert("��ʾ", "��ѡ����Ҫ�༭����Ϣ��");
            return;
        }
        if(selectData.data.BizStatus==2){
            Ext.Msg.alert("��ʾ", "�ü�¼��Ϣ�Ѿ���⣡");
            return;
        }
        orgId = selectData.data.OrgId;
        operId = selectData.data.OperId;
        whId = selectData.data.AuxWhId;
        
        //customerId = selectData.data.CustomerId
        uploadOrderWindow.show();
        //alert(selectData.data.DrawInvId);
        var stockType = "";
        switch(selectData.data.IsOutOrder){
            case "P041":
                stockType = "W0210";
                uploadOrderWindow.setTitle("���������˻���ֵ�");
            break;
            case "P042":
                stockType = "W0213";
                uploadOrderWindow.setTitle("�����������ֵ�");
            break;
            case "P043":
                stockType = "W0212";
                uploadOrderWindow.setTitle("����������ֵ�");
            break;
        }
        document.getElementById("SaleIFrame").src = "frmInStockBill.aspx?type="+stockType+"&id="+selectData.data.OrderId;

        /*  
        //��ѡ
        var selectData = sm.getSelections();                
        var array = new Array(selectData.length);
        for(var i=0;i<selectData.length;i++)
        {
            array[i] = selectData[i].get('OrderId');
        }

        //���û��ѡ�񣬾���ʾ��Ҫѡ��������Ϣ
        if (selectData == null|| selectData.length == 0) {
            Ext.Msg.alert("��ʾ", "��ѡ����Ҫ����������Ķ�����¼��");
            return;
        }
               
        uploadOrderWindow.show();
        uploadOrderWindow.setTitle("�����ƿⵥ");
        document.getElementById("editShiftPosOrderIFrame").src = "frmShiftPosOrderEdit.aspx?id=0";
                       
        //ҳ���ύ
        Ext.Ajax.request({
            url: 'frmSelfDlv.aspx?method=gener',
            method: 'POST',
            params: {
                OrderId: array.join('-')//��������id��
            },
            success: function(resp, opts) {
                Ext.Msg.alert("��ʾ", "�������ɳɹ���");
                OrderMstGrid.getStore().reload();
                
            },
            failure: function(resp, opts) {
                Ext.Msg.alert("��ʾ", "��������ʧ�ܣ�");
            }
        });
        */
    }
    
    /*------��ʼ�������ݵĴ��� Start---------------*/
    if (typeof (uploadOrderWindow) == "undefined") {//�������2��windows����
        uploadOrderWindow = new Ext.Window({
            id: 'DvlSaleOrderWindow'
            , iconCls: 'upload-win'
            , height:515
            , width:750
            //, autoWidth: true
            //, autoHeight: true
            , layout: 'fit'
            , plain: true
            , modal: true
            //, border:false
            , constrain: true
            , resizable: false
            , closeAction: 'hide'
            , autoDestroy: true
            , html: '<iframe id="SaleIFrame" width="100%" height="100%" border=0 src="#"></iframe>'
           //,autoScroll:true
        });
    }
    uploadOrderWindow.addListener("hide", function() {
        //var start = userGrid.getBottomToolbar().cursor/10; //alert(userGrid.getBottomToolbar().cursor);
        QueryDataGrid();
    });
    
    function QueryDataGrid(start) { 
        userGridData.baseParams.OrgId = <% =ZJSIG.UIProcess.ADM.UIAdmUser.OrgID(this)%>;
        userGridData.baseParams.WsId = Ext.getCmp('WsId').getValue();
        userGridData.baseParams.AuxWhId = Ext.getCmp('AuxWhId').getValue();
        userGridData.baseParams.IsOutOrder = type;//Ext.getCmp('IsOutOrder').getValue();
        userGridData.baseParams.StartDate = Ext.util.Format.date(Ext.getCmp('MStartDate').getValue(),'Y/m/d');
        userGridData.baseParams.EndDate = Ext.util.Format.date(Ext.getCmp('MEndDate').getValue(),'Y/m/d');
        userGridData.baseParams.BizStatus = sfck.getValue();
        userGridData.load({
            params: {
                start: 0,
                limit: defaultPageSize
            }
        });
    }
            

      //�ֿ�
       var ck = new Ext.form.ComboBox({
           xtype: 'combo',
           store: dsWareHouse,
           valueField: 'WhId',
           displayField: 'WhName',
           mode: 'local',
           forceSelection: true,
           name:'AuxWhId',
           id:'AuxWhId',
           emptyValue: '',
           triggerAction: 'all',
           fieldLabel: '�ֿ�',
           selectOnFocus: true,
           anchor: '90%',
           editable:false
       });

       //����
       var ws = new Ext.form.ComboBox({
           xtype: 'combo',
           store: dsWorkShopList,
           valueField: 'WsId',
           displayField: 'WsName',
           mode: 'local',
           forceSelection: true,
           name: 'WsId',
           id: 'WsId',
           emptyValue: '',
           triggerAction: 'all',
           fieldLabel: '����',
           selectOnFocus: true,
           anchor: '90%',
           editable: false
       });
               
       //��ʼ����
       var ksrq = new Ext.form.DateField({
   		    xtype:'datefield',
	        fieldLabel:'��ʼ����',
	        anchor:'90%',
	        name:'MStartDate',
	        id:'MStartDate',
	        format: 'Y��m��d��',  //���������ʽ
            value:new Date().getFirstDateOfMonth().clearTime()
        });
               
       //��������
       var jsrq = new Ext.form.DateField({
   		    xtype:'datefield',
	        fieldLabel:'��������',
	        anchor:'90%',
	        name:'MEndDate',
	        id:'MEndDate',
	        format: 'Y��m��d��',  //���������ʽ
            value:(new Date()).clearTime()
       });              
               
               
        //��������
        var ddlx = new Ext.form.ComboBox({
           xtype: 'combo',
           store: dsProduceType,
           valueField: 'DicsCode',
           displayField: 'DicsName',
           mode: 'local',
           forceSelection: true,
           editable: false,
           emptyValue: '',
           triggerAction: 'all',
           fieldLabel: '��������',
           name:'IsOutOrder',
           id:'IsOutOrder',
           selectOnFocus: true,
           anchor: '90%',
           editable:false
       });  
       var dsBS = null;
       if(type=='P042')
       {
        dsBS = new Ext.data.SimpleStore({
            fields:['BSID','BSVALUE'],
            data:[['0','��ʼ'],['2','�ѳ���']],
            autoLoad: false});
       }else{
        dsBS = new Ext.data.SimpleStore({
            fields:['BSID','BSVALUE'],
            data:[['0','��ʼ'],['1','���ʼ�'],['2','�����']],
            autoLoad: false});
       }
       //״̬
        var sfck = new Ext.form.ComboBox({
           xtype: 'combo',
           store: dsBS,
           valueField: 'BSID',
           displayField: 'BSVALUE',
           mode: 'local',
           forceSelection: true,
           editable: false,
           emptyValue: '',
           triggerAction: 'all',
           fieldLabel: 'ҵ��״̬',
           name:'BizStatus',
           id:'BizStatus',
           selectOnFocus: true,
           anchor: '90%'
       });  
               
       var serchDrawInvform = new Ext.FormPanel({
            renderTo: 'MainSearchForm',
            labelAlign: 'left',
            buttonAlign: 'center',
            bodyStyle: 'padding:5px',
            frame: true,
            labelWidth: 55,
            items:[
            {
                layout:'column',
                border: false,
                items: [
                {
	                layout:'form',
	                border: false,
	                columnWidth:0.33,
	                items: [ws]
                } ,		
                {
	                layout:'form',
	                border: false,
	                columnWidth:0.33,
	                items: [ck]
                },		
                {
	                layout:'form',
	                border: false,
	                columnWidth:0.33,
	                items: [sfck]
                }
            ]},
            {
                layout:'column',
                border: false,
                items: [
                {
                    layout:'form',
                    border: false,
                    columnWidth:0.33,
                    items: [{
		                    xtype:'datefield',
		                    fieldLabel:'��ʼ����',
		                    columnWidth:0.5,
		                    anchor:'90%',
		                    name:'MStartDate',
		                    id:'MStartDate',
		                    value:new Date().getFirstDateOfMonth().clearTime(),
		                    format:'Y��m��d��'
	                    }]
                } ,		
                {
                    layout:'form',
                    border: false,
                    columnWidth:0.33,
                    items: [{
		                    xtype:'datefield',
		                    fieldLabel:'��������',
		                    columnWidth:0.5,
		                    anchor:'90%',
		                    name:'MEndDate',
		                    id:'MEndDate',
		                    value:new Date().clearTime(),
		                    format:'Y��m��d��'
	                    }]
                } ,		
	
                {
                    layout:'form',
                    border: false,
                    columnWidth:0.2,
                    items:[{
                        xtype:'button',
                        id: 'searchMainbtnId',
                        text: '��ѯ',
                        handler: function() {QueryDataGrid(0);}
                    }]
                }]
            }]
    });


    /*------��ʼ��ȡ���ݵĺ��� start---------------*/
    var userGridData = new Ext.data.Store
    ({
        url: 'frmPmsStock.aspx?method=getPmsStockList',
        reader: new Ext.data.JsonReader({
            totalProperty: 'totalProperty',
            root: 'root'
        }, [
            {name:'OrderId'},
            {name:'OrgId'},
            {name:'WsId'},
            {name:'AuxWhId'},
            {name:'AuxProductId'},
            {name:'Qty'},
            {name:'InitOrderId'},
            {name:'IsOutOrder'},
            {name:'CreateDate'},
            {name:'UpdateDate'},
            {name:'OperId'},
            {name:'OwnerId'},
            {name:'Remark'},
            {name:'Status'},
            {name:'IsCheck'},
            {name:'BizStatus'},
            {name:'ManuDate'},
            {name:'ProductName'},
            {name:'ProductSpec'},
            {name:'ProductUnit'},
            {name:'ProductCode'}		
         ])
            ,sortData: function(f, direction) {
        var tempSort = Ext.util.JSON.encode(userGridData.sortInfo);
        if (sortInfor != tempSort) {
            sortInfor = tempSort;
            userGridData.baseParams.SortInfo = sortInfor;
            userGridData.load({ params: { limit: defaultPageSize, start: 0} });
        }
    },
        listeners:
        {
            scope: this,
            load: function() {
            }
        }
    });
var sortInfor = '';
    /*------��ȡ���ݵĺ��� ���� End---------------*/
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
    var combo = new Ext.form.ComboBox({
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
    toolBar.addField(combo);

    combo.on("change", function(c, value) {
        toolBar.pageSize = value;
        defaultPageSize = toolBar.pageSize;
    }, toolBar);
    combo.on("select", function(c, record) {
        toolBar.pageSize = parseInt(record.get("pageSize"));
        defaultPageSize = toolBar.pageSize;
        toolBar.doLoad(0);
    }, toolBar);
    /*------��ʼDataGrid�ĺ��� start---------------*/

    var Mainsm = new Ext.grid.CheckboxSelectionModel({
        singleSelect: false
    });
    var userGrid = new Ext.grid.GridPanel({
        el: 'MainDataGrid',
        //width: '100%',
        //height: '100%',
        //autoWidth: true,
        //autoHeight: true,
        autoScroll: true,
        layout: 'fit',
        id: '',
        store: userGridData,
        loadMask: { msg: '���ڼ������ݣ����Ժ��' },
        sm: Mainsm,
        cm: new Ext.grid.ColumnModel([
        
        Mainsm,
        new Ext.grid.RowNumberer(),//�Զ��к�
        {
            header:'������ʶ',
            dataIndex:'OrderId',
            id:'OrderId',
            hidden:true,
            hideable:false
        },
        {
            header:'����',
            dataIndex:'WsId',
            id:'WsId',
            width:150,
            sortable: true,
            renderer: { fn: function(v) {
                //����key��λ�������е�value
                var index = dsWorkShopList.find('WsId', v);
                var record = dsWorkShopList.getAt(index);
                if(record==null)
                    return "";
                return record.data.WsName;
            } 
            }
        },
        {
            header:'�ֿ�',
            dataIndex:'AuxWhId',
            id: 'AuxWhId',
            width:80,
            sortable: true,
            renderer: { fn: function(v) {
                //����key��λ�������е�value
                var index = dsWareHouse.find('WhId', v);
                if(index==-1)
                    return"";
                var record = dsWareHouse.getAt(index);
                if(record==null)
                    return "";
                return record.data.WhName;
            }
            }
        },
        {
            header:'��Ʒ����',
            dataIndex: 'ProductCode',
            width:80,
            sortable: true,
            id: 'ProductCode'
        },
        {
            header:'��Ʒ����',
            dataIndex: 'ProductName',
            width:180,
            sortable: true,
            id: 'ProductName'
        },
        {
            header:'���',
            dataIndex: 'ProductSpec',
            width:50,
            id: 'ProductSpec'
        },
        {
            header:'��λ',
            dataIndex: 'ProductUnit',
            width:50,
            id: 'ProductUnit'
        },
        {
            header:'����',
            dataIndex:'Qty',
            width:60,
            id:'Qty'
        },
        {
            header:'��������',
            dataIndex:'IsOutOrder',
            id:'IsOutOrder',
            width:40,
            sortable: true,
            hidden:true,
            hideable:false,
            renderer:{fn:function(v){
		        //����key��λ�������е�value
		        var index = dsProduceType.find('DicsCode', v);
                var record = dsProduceType.getAt(index);
                return record.data.DicsName;
		     }}
        },
        {
            header:'�ʼ�״̬',
            dataIndex:'IsCheck',
            id:'IsCheck',
            width:80,
            sortable: true,
            renderer:function(val){//alert(val);
                dsCheckStatus.each(function(r) {
		            if (val == r.data['CheckId']) {
		                val = r.data['CheckName'];
		                return;
		            }
		        });
		        return val;
		        
		     }
        },
        {
            header:'ҵ��״̬',
            dataIndex:'BizStatus',
            id:'BizStatus',
            width:80,
            sortable: true,
            renderer:function(val){
                if(val==0)return'��ʼ';
                if(val==1)return'���ʼ�';
		        if(val==2){
		            if(type=='P042') return'�ѳ���';
		            if(type=='P043') return'�����';
		        }
		     }
        },
        {
            header:'����ʱ��',
            dataIndex:'ManuDate',
            width:120,
            sortable: true,
            id:'ManuDate',
            renderer:Ext.util.Format.dateRenderer('Y��m��d��')
        },{
		    header: '����ʱ��',
		    dataIndex: 'CreateDate',
		    sortable: true,
		    id: 'CreateDate'
		},{
		    header: '��ע',
		    dataIndex: 'Remark',
		    sortable: true,
		    id: 'Remark'
		}	]),
        bbar:toolBar,
        viewConfig: {
            columnsText: '��ʾ����',
            scrollOffset: 20,
            sortAscText: '����',
            sortDescText: '����',
            forceFit: false
        },
        height: 320,
        closeAction: 'hide',
        stripeRows: true,
        loadMask: true//,
        //autoExpandColumn: 2
    });
    userGrid.render();
    /*------DataGrid�ĺ������� End---------------*/
    QueryDataGrid();
    
});

</script>

</html>
