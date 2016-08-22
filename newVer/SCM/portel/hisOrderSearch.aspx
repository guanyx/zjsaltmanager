<%@ Page Language="C#" AutoEventWireup="true" CodeFile="hisOrderSearch.aspx.cs" Inherits="SCM_portel_hisOrderSearch" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html>
<head>
<title>����ʷ����</title><meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<link rel="stylesheet" type="text/css" href="../../ext3/resources/css/ext-all.css" />
<script type="text/javascript" src="../../ext3/adapter/ext/ext-base.js"></script>
<script type="text/javascript" src="../../ext3/ext-all.js"></script>
<script type="text/javascript" src="../../ext3/src/locale/ext-lang-zh_CN.js"></script>
</head>
<body>
<div id='toolbar'></div>
<div id='divSearchForm'></div>
<div id='divDataGrid'></div>
</body>
<%=getComboBoxStore()%>
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
var customerid = getParamerValue('customerid'); 
var orgid = getParamerValue('OrgId');
</script>
<script type="text/javascript">
Ext.BLANK_IMAGE_URL = "../../ext3/resources/images/default/s.gif";  //��Ϊ���������������������ͼƬ��ʾ
Ext.onReady(function() {
    
    var saveType="";
    
    /*------ʵ��toolbar�ĺ��� start---------------*/
    var Toolbar = new Ext.Toolbar({
        renderTo: "toolbar",
        items: [{
            text: "������ϸ",
            icon: "../../Theme/1/images/extjs/customer/view16.gif",
            handler: function() { openViewOrderDtlWin(); }
        }]
    });
    /*------����toolbar�ĺ��� end---------------*/

    function opennewwindow(url,winname,w,h){
        var top=screen.availHeight/2-h;
        var left=screen.availWidth/2-w;
        window.open(url, winname, "top="+top+", left="+left
        +",toolbar=no, menubar=no, scrollbars=yes, location=no, status=no, resizable=no,width="+w+",height="+h);
    }
            
    /*-----�鿴Orderʵ���ര�庯��----*/
    function openViewOrderDtlWin() {
        var sm = OrderMstGrid.getSelectionModel();
        //��ȡѡ���������Ϣ
        var selectData = sm.getSelected();
        if (selectData == null || selectData == "") {
            Ext.Msg.alert("��ʾ", "��ѡ����Ҫ�鿴����Ϣ��");
            return;
        }
        //uploadOrderWindow.show();
        //document.getElementById("editIFrame").src = "../cusmanager/frmCustManagerOrderEdit.aspx?OpenType=query&id=" + selectData.data.OrderId;
        opennewwindow('../cusmanager/frmCustManagerOrderEdit.aspx?OpenType=query&id=' + selectData.data.OrderId,'������ϸ',620,400);
    }
           
    function QueryDataGrid() { 
        OrderMstGridData.baseParams.OrderId=orderPanel.getValue();
        OrderMstGridData.baseParams.PortelCustomerId=customerid;	   	                
        OrderMstGridData.baseParams.StartDate=Ext.util.Format.date(Ext.getCmp('StartDate').getValue(),'Y/m/d');
        OrderMstGridData.baseParams.EndDate=Ext.util.Format.date(Ext.getCmp('EndDate').getValue(),'Y/m/d');
        if(undefined != orgid && orgid != null && orgid != '')
            OrderMstGridData.baseParams.OrgId=orgid;
        OrderMstGridData.load({
            params: {
                start: 0,
                limit: 10
            }
        });
    }
       
   //�������
   var orderPanel = new Ext.form.NumberField({
        style: 'margin-left:0px',
        cls: 'key',
        xtype: 'textfield',
        fieldLabel: '�������',
        name: 'ordercode',
        anchor: '90%'
    });
    
                  
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
            items: [orderPanel]
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
            items: [
                {
	                xtype:'datefield',
	                fieldLabel:'��ʼ����',
	                columnWidth:0.5,
	                anchor:'90%',
	                name:'StartDate',
	                id:'StartDate',
                    format: 'Y��m��d��',  //���������ʽ
                    value:new Date().getFirstDateOfMonth().clearTime()
                }
                    ]
        }
,		{
            layout:'form',
            border: false,
            columnWidth:0.33,
            items: [
                {
	                xtype:'datefield',
	                fieldLabel:'��������',
	                columnWidth:0.5,
	                anchor:'90%',
	                name:'EndDate',
	                id:'EndDate',
                    format: 'Y��m��d��',  //���������ʽ
                    value:new Date().clearTime()
                }
                    ]
        },
        {//������Ԫ��
                layout:'form',
                border: false,
                labelWidth:70,
                columnWidth:0.34,
                items:[
                    {
                       xtype:'button',
                        text:'��ѯ',
                        width:70,
                        //iconCls:'excelIcon',
                        scope:this,
                        handler:function(){
                            QueryDataGrid();
                        }
                    }
                    ]
            }
        ]
    }              
]

});



        /*------��ʼ��ѯform�ĺ��� end---------------*/

        /*------��ʼ�������ݵĴ��� Start---------------*/
        if (typeof (uploadOrderWindow) == "undefined") {//�������2��windows����
            uploadOrderWindow = new Ext.Window({
                id: 'Orderformwindow',
                iconCls: 'upload-win'
                , width: 750
                , height: 530
                , plain: true
                , modal: true
                , constrain: true
                , resizable: false
                , closeAction: 'hide'
                , autoDestroy: true
                , html: '<iframe id="editIFrame" width="100%" height="100%" border=0 src="../cusmanager/frmCustManagerOrderEdit.aspx"></iframe>' 
                
            });
        }
        uploadOrderWindow.addListener("hide", function() {
           document.getElementById("editIFrame").src = "../cusmanager/frmCustManagerOrderEdit.aspx?OpenType=query&id=0";//��������ݣ���������ҳ���ṩһ������������
        });

                        

                       
        /*------��ʼ��ȡ���ݵĺ��� start---------------*/
        var OrderMstGridData = new Ext.data.Store
        ({
            url: 'hisOrderSearch.aspx?method=getOrderList',
            reader: new Ext.data.JsonReader({
                totalProperty: 'totalProperty',
                root: 'root'
            }, [
                {   name:'OrderId'  },
                {   name:'OrgId'    },
                {   name:'OrgName'  },
                {   name:'DeptId'   },
                {   name:'DeptName' },
                {   name:'OutStor'  },
                {   name:'OutStorName'  },
                {   name:'CustomerId'   },
                {   name:'CustomerName' },
                {   name:'DlvDate'  },
                {   name:'DlvAdd'   },
                {   name:'DlvDesc'  },
                {   name:'OrderType'    },
                {   name:'OrderTypeName'    },
                {   name:'PayType'  },
                {   name:'PayTypeName'  },
                {   name:'BillMode' },
                {   name:'BillModeName' },
                {   name:'DlvType'  },
                {   name:'DlvTypeName'  },
                {   name:'DlvLevel' },
                {   name:'DlvLevelName' },
                {   name:'Status'   },
                {   name:'StatusName'   },
                {   name:'IsPayed'  },
                {   name:'IsPayedName'  },
                {   name:'IsBill'   },
                {   name:'IsBillName'   },
                {   name:'SaleInvId'    },
                {   name:'SaleTotalQty' },
                {   name:'OutedQty' },
                {   name:'SaleTotalAmt' },
                {   name:'SaleTotalTax' },
                {   name:'DtlCount' },
                {   name:'OperId'   },
                {   name:'OperName' },
                {   name:'CreateDate'   },
                {   name:'UpdateDate'   },
                {   name:'OwnerId'  },
                {   name:'OwnerName'    },
                {   name:'BizAudit' },
                {   name:'AuditDate'    },
                {   name:'Remark'   },
                {   name:'IsActive' },
                {   name:'IsActiveName'
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
    var OrderMstGrid = new Ext.grid.GridPanel({
        el: 'divDataGrid', 
        //height: '100%',
        //autoHeight: true,
        autoScroll: true,
        layout: 'fit',
        id: '',
        store: OrderMstGridData,
        loadMask: { msg: '���ڼ������ݣ����Ժ��' },
        sm: sm,
        cm: new Ext.grid.ColumnModel([
        
        sm,
        new Ext.grid.RowNumberer(),//�Զ��к�
        {
            header:'������ʶ',
            dataIndex:'OrderId',
            id:'OrderId',
            width:60
        },
//		                    {
//		                        header:'��˾����',
//			                    dataIndex:'OrgName',
//			                    id:'OrgName'
//		                    },
//		                    {
//		                        header:'���۲���',
//			                    dataIndex:'DeptName',
//			                    id:'DeptName'
//		                    },
        {
            header:'����ֿ�',
            dataIndex:'OutStorName',
            id:'OutStorName',
            width:80
        },
        {
            header:'�ͻ�����',
            dataIndex:'CustomerName',
            id:'CustomerName',
            width:160
        },
        {
            header:'�ͻ�����',
            dataIndex:'DlvDate',
            id:'DlvDate',
            width:70
        },
        {
            header:'��������',
            dataIndex:'OrderTypeName',
            id:'OrderTypeName',
            width:60
        },
        {
            header:'���㷽ʽ',
            dataIndex:'PayTypeName',
            id:'PayTypeName',
            width:60
        },
        {
            header:'��Ʊ��ʽ',
            dataIndex:'BillModeName',
            id:'BillModeName',
            width:60
        },
        {
            header:'���ͷ�ʽ',
            dataIndex:'DlvTypeName',
            id:'DlvTypeName',
            width:60
        },
//        {
//            header:'�ͻ��ȼ�',
//            dataIndex:'DlvLevelName',
//            id:'DlvLevelName',
//            width:60
//        },
        {
            header:'������',
            dataIndex:'SaleTotalQty',
            id:'SaleTotalQty',
            width:50
        },
        {
            header:'�ܽ��',
            dataIndex:'SaleTotalAmt',
            id:'SaleTotalAmt',
            width:50
        },
//        {
//            header:'����Ա',
//            dataIndex:'OperName',
//            id:'OperName',
//            width:60
//        },
        {
            header:'����',
            dataIndex:'Status',
            id:'Status',
            width:60,
            renderer:function(v){
                if(v==1) return '����';
                if(v==2) return '���';
                if(v==3) return '����';
            }
        },
        {
            header:'����ʱ��',
            dataIndex:'CreateDate',
            id:'CreateDate',
            width:70
        }		]),
        bbar: new Ext.PagingToolbar({
            pageSize: 20,
            store: OrderMstGridData,
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
        height: 300
//                            closeAction: 'hide',
//                            stripeRows: true,
//                            loadMask: true,
//                            autoExpandColumn: 2
    });
    OrderMstGrid.on("afterrender", function(component) {
        component.getBottomToolbar().refresh.hideParent = true;
        component.getBottomToolbar().refresh.hide(); 
    });
    OrderMstGrid.render();
})
</script>

</html>