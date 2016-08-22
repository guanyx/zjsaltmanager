<%@ Page Language="C#" AutoEventWireup="true" CodeFile="hisOrderSearch.aspx.cs" Inherits="SCM_portel_hisOrderSearch" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html>
<head>
<title>客历史订单</title><meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
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
Ext.BLANK_IMAGE_URL = "../../ext3/resources/images/default/s.gif";  //作为：让下拉框的三角形下拉图片显示
Ext.onReady(function() {
    
    var saveType="";
    
    /*------实现toolbar的函数 start---------------*/
    var Toolbar = new Ext.Toolbar({
        renderTo: "toolbar",
        items: [{
            text: "订单明细",
            icon: "../../Theme/1/images/extjs/customer/view16.gif",
            handler: function() { openViewOrderDtlWin(); }
        }]
    });
    /*------结束toolbar的函数 end---------------*/

    function opennewwindow(url,winname,w,h){
        var top=screen.availHeight/2-h;
        var left=screen.availWidth/2-w;
        window.open(url, winname, "top="+top+", left="+left
        +",toolbar=no, menubar=no, scrollbars=yes, location=no, status=no, resizable=no,width="+w+",height="+h);
    }
            
    /*-----查看Order实体类窗体函数----*/
    function openViewOrderDtlWin() {
        var sm = OrderMstGrid.getSelectionModel();
        //获取选择的数据信息
        var selectData = sm.getSelected();
        if (selectData == null || selectData == "") {
            Ext.Msg.alert("提示", "请选中需要查看的信息！");
            return;
        }
        //uploadOrderWindow.show();
        //document.getElementById("editIFrame").src = "../cusmanager/frmCustManagerOrderEdit.aspx?OpenType=query&id=" + selectData.data.OrderId;
        opennewwindow('../cusmanager/frmCustManagerOrderEdit.aspx?OpenType=query&id=' + selectData.data.OrderId,'订单明细',620,400);
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
       
   //订单编号
   var orderPanel = new Ext.form.NumberField({
        style: 'margin-left:0px',
        cls: 'key',
        xtype: 'textfield',
        fieldLabel: '订单编号',
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
        labelSeparator: '：',
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
	                fieldLabel:'开始日期',
	                columnWidth:0.5,
	                anchor:'90%',
	                name:'StartDate',
	                id:'StartDate',
                    format: 'Y年m月d日',  //添加中文样式
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
	                fieldLabel:'结束日期',
	                columnWidth:0.5,
	                anchor:'90%',
	                name:'EndDate',
	                id:'EndDate',
                    format: 'Y年m月d日',  //添加中文样式
                    value:new Date().clearTime()
                }
                    ]
        },
        {//第三单元格
                layout:'form',
                border: false,
                labelWidth:70,
                columnWidth:0.34,
                items:[
                    {
                       xtype:'button',
                        text:'查询',
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



        /*------开始查询form的函数 end---------------*/

        /*------开始界面数据的窗体 Start---------------*/
        if (typeof (uploadOrderWindow) == "undefined") {//解决创建2个windows问题
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
           document.getElementById("editIFrame").src = "../cusmanager/frmCustManagerOrderEdit.aspx?OpenType=query&id=0";//清楚其内容，建议在子页面提供一个方法来调用
        });

                        

                       
        /*------开始获取数据的函数 start---------------*/
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

    /*------获取数据的函数 结束 End---------------*/

    /*------开始DataGrid的函数 start---------------*/

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
        loadMask: { msg: '正在加载数据，请稍侯……' },
        sm: sm,
        cm: new Ext.grid.ColumnModel([
        
        sm,
        new Ext.grid.RowNumberer(),//自动行号
        {
            header:'订单标识',
            dataIndex:'OrderId',
            id:'OrderId',
            width:60
        },
//		                    {
//		                        header:'公司名称',
//			                    dataIndex:'OrgName',
//			                    id:'OrgName'
//		                    },
//		                    {
//		                        header:'销售部门',
//			                    dataIndex:'DeptName',
//			                    id:'DeptName'
//		                    },
        {
            header:'出库仓库',
            dataIndex:'OutStorName',
            id:'OutStorName',
            width:80
        },
        {
            header:'客户名称',
            dataIndex:'CustomerName',
            id:'CustomerName',
            width:160
        },
        {
            header:'送货日期',
            dataIndex:'DlvDate',
            id:'DlvDate',
            width:70
        },
        {
            header:'订单类型',
            dataIndex:'OrderTypeName',
            id:'OrderTypeName',
            width:60
        },
        {
            header:'结算方式',
            dataIndex:'PayTypeName',
            id:'PayTypeName',
            width:60
        },
        {
            header:'开票方式',
            dataIndex:'BillModeName',
            id:'BillModeName',
            width:60
        },
        {
            header:'配送方式',
            dataIndex:'DlvTypeName',
            id:'DlvTypeName',
            width:60
        },
//        {
//            header:'送货等级',
//            dataIndex:'DlvLevelName',
//            id:'DlvLevelName',
//            width:60
//        },
        {
            header:'总数量',
            dataIndex:'SaleTotalQty',
            id:'SaleTotalQty',
            width:50
        },
        {
            header:'总金额',
            dataIndex:'SaleTotalAmt',
            id:'SaleTotalAmt',
            width:50
        },
//        {
//            header:'操作员',
//            dataIndex:'OperName',
//            id:'OperName',
//            width:60
//        },
        {
            header:'环节',
            dataIndex:'Status',
            id:'Status',
            width:60,
            renderer:function(v){
                if(v==1) return '生成';
                if(v==2) return '审核';
                if(v==3) return '配送';
            }
        },
        {
            header:'创建时间',
            dataIndex:'CreateDate',
            id:'CreateDate',
            width:70
        }		]),
        bbar: new Ext.PagingToolbar({
            pageSize: 20,
            store: OrderMstGridData,
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