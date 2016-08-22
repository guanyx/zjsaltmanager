 <%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmPmsStock.aspx.cs" Inherits="WMS_frmPmsStock" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html>
<head>
    <title>生产出入库</title><meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
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
    var query = location.search.substring(1); //获取查询串   
    var pairs = query.split("&"); //在逗号处断开   
    for (var i = 0; i < pairs.length; i++) {
        var pos = pairs[i].indexOf('='); //查找name=value   
        if (pos == -1) continue; //如果没有找到就跳过   
        var argname = pairs[i].substring(0, pos); //提取name   
        var value = pairs[i].substring(pos + 1); //提取value   
        args[argname] = unescape(value); //存为属性   
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
        titleName = "生产领料退货";
    break;
    case "P042":
        titleName = "生产出仓";
    break;
    case "P043":
        titleName = "生产入仓";
    break;
}
    /*------实现toolbar的函数 start---------------*/
    var Toolbar = new Ext.Toolbar({
        renderTo: "MainToolbar",
        items: [
        {
            text: titleName,
            icon: "../Theme/1/images/extjs/customer/add16.gif",
            handler: function() { OutDraw() ;  }
        }]
        });
    /*------结束toolbar的函数 end---------------*/

    /*-----实体函数----*/
    function OutDraw() {
    //uploadOrderWindow.show();
    
   
        var sm = userGrid.getSelectionModel();
        var selectData = sm.getSelected();
        if (selectData == null) {
            Ext.Msg.alert("提示", "请选中需要编辑的信息！");
            return;
        }
        if(selectData.data.BizStatus==2){
            Ext.Msg.alert("提示", "该记录信息已经入库！");
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
                uploadOrderWindow.setTitle("新增领料退货入仓单");
            break;
            case "P042":
                stockType = "W0213";
                uploadOrderWindow.setTitle("新增生产出仓单");
            break;
            case "P043":
                stockType = "W0212";
                uploadOrderWindow.setTitle("新增生产入仓单");
            break;
        }
        document.getElementById("SaleIFrame").src = "frmInStockBill.aspx?type="+stockType+"&id="+selectData.data.OrderId;

        /*  
        //多选
        var selectData = sm.getSelections();                
        var array = new Array(selectData.length);
        for(var i=0;i<selectData.length;i++)
        {
            array[i] = selectData[i].get('OrderId');
        }

        //如果没有选择，就提示需要选择数据信息
        if (selectData == null|| selectData.length == 0) {
            Ext.Msg.alert("提示", "请选中需要生成领货单的订单记录！");
            return;
        }
               
        uploadOrderWindow.show();
        uploadOrderWindow.setTitle("新增移库单");
        document.getElementById("editShiftPosOrderIFrame").src = "frmShiftPosOrderEdit.aspx?id=0";
                       
        //页面提交
        Ext.Ajax.request({
            url: 'frmSelfDlv.aspx?method=gener',
            method: 'POST',
            params: {
                OrderId: array.join('-')//传入多项的id串
            },
            success: function(resp, opts) {
                Ext.Msg.alert("提示", "数据生成成功！");
                OrderMstGrid.getStore().reload();
                
            },
            failure: function(resp, opts) {
                Ext.Msg.alert("提示", "数据生成失败！");
            }
        });
        */
    }
    
    /*------开始界面数据的窗体 Start---------------*/
    if (typeof (uploadOrderWindow) == "undefined") {//解决创建2个windows问题
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
            

      //仓库
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
           fieldLabel: '仓库',
           selectOnFocus: true,
           anchor: '90%',
           editable:false
       });

       //车间
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
           fieldLabel: '车间',
           selectOnFocus: true,
           anchor: '90%',
           editable: false
       });
               
       //开始日期
       var ksrq = new Ext.form.DateField({
   		    xtype:'datefield',
	        fieldLabel:'开始日期',
	        anchor:'90%',
	        name:'MStartDate',
	        id:'MStartDate',
	        format: 'Y年m月d日',  //添加中文样式
            value:new Date().getFirstDateOfMonth().clearTime()
        });
               
       //结束日期
       var jsrq = new Ext.form.DateField({
   		    xtype:'datefield',
	        fieldLabel:'结束日期',
	        anchor:'90%',
	        name:'MEndDate',
	        id:'MEndDate',
	        format: 'Y年m月d日',  //添加中文样式
            value:(new Date()).clearTime()
       });              
               
               
        //生产类型
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
           fieldLabel: '生产类型',
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
            data:[['0','初始'],['2','已出库']],
            autoLoad: false});
       }else{
        dsBS = new Ext.data.SimpleStore({
            fields:['BSID','BSVALUE'],
            data:[['0','初始'],['1','已质检'],['2','已入库']],
            autoLoad: false});
       }
       //状态
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
           fieldLabel: '业务状态',
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
		                    fieldLabel:'开始日期',
		                    columnWidth:0.5,
		                    anchor:'90%',
		                    name:'MStartDate',
		                    id:'MStartDate',
		                    value:new Date().getFirstDateOfMonth().clearTime(),
		                    format:'Y年m月d日'
	                    }]
                } ,		
                {
                    layout:'form',
                    border: false,
                    columnWidth:0.33,
                    items: [{
		                    xtype:'datefield',
		                    fieldLabel:'结束日期',
		                    columnWidth:0.5,
		                    anchor:'90%',
		                    name:'MEndDate',
		                    id:'MEndDate',
		                    value:new Date().clearTime(),
		                    format:'Y年m月d日'
	                    }]
                } ,		
	
                {
                    layout:'form',
                    border: false,
                    columnWidth:0.2,
                    items:[{
                        xtype:'button',
                        id: 'searchMainbtnId',
                        text: '查询',
                        handler: function() {QueryDataGrid(0);}
                    }]
                }]
            }]
    });


    /*------开始获取数据的函数 start---------------*/
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
    /*------获取数据的函数 结束 End---------------*/
var defaultPageSize = 10;
    var toolBar = new Ext.PagingToolbar({
        pageSize: 10,
        store: userGridData,
        displayMsg: '显示第{0}条到{1}条记录,共{2}条',
        emptyMsy: '没有记录',
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
        emptyText: '更改每页记录数',
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
    /*------开始DataGrid的函数 start---------------*/

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
        loadMask: { msg: '正在加载数据，请稍侯……' },
        sm: Mainsm,
        cm: new Ext.grid.ColumnModel([
        
        Mainsm,
        new Ext.grid.RowNumberer(),//自动行号
        {
            header:'订单标识',
            dataIndex:'OrderId',
            id:'OrderId',
            hidden:true,
            hideable:false
        },
        {
            header:'车间',
            dataIndex:'WsId',
            id:'WsId',
            width:150,
            sortable: true,
            renderer: { fn: function(v) {
                //根据key定位下拉框中的value
                var index = dsWorkShopList.find('WsId', v);
                var record = dsWorkShopList.getAt(index);
                if(record==null)
                    return "";
                return record.data.WsName;
            } 
            }
        },
        {
            header:'仓库',
            dataIndex:'AuxWhId',
            id: 'AuxWhId',
            width:80,
            sortable: true,
            renderer: { fn: function(v) {
                //根据key定位下拉框中的value
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
            header:'商品编码',
            dataIndex: 'ProductCode',
            width:80,
            sortable: true,
            id: 'ProductCode'
        },
        {
            header:'商品名称',
            dataIndex: 'ProductName',
            width:180,
            sortable: true,
            id: 'ProductName'
        },
        {
            header:'规格',
            dataIndex: 'ProductSpec',
            width:50,
            id: 'ProductSpec'
        },
        {
            header:'单位',
            dataIndex: 'ProductUnit',
            width:50,
            id: 'ProductUnit'
        },
        {
            header:'数量',
            dataIndex:'Qty',
            width:60,
            id:'Qty'
        },
        {
            header:'生产类型',
            dataIndex:'IsOutOrder',
            id:'IsOutOrder',
            width:40,
            sortable: true,
            hidden:true,
            hideable:false,
            renderer:{fn:function(v){
		        //根据key定位下拉框中的value
		        var index = dsProduceType.find('DicsCode', v);
                var record = dsProduceType.getAt(index);
                return record.data.DicsName;
		     }}
        },
        {
            header:'质检状态',
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
            header:'业务状态',
            dataIndex:'BizStatus',
            id:'BizStatus',
            width:80,
            sortable: true,
            renderer:function(val){
                if(val==0)return'初始';
                if(val==1)return'已质检';
		        if(val==2){
		            if(type=='P042') return'已出库';
		            if(type=='P043') return'已入库';
		        }
		     }
        },
        {
            header:'生产时间',
            dataIndex:'ManuDate',
            width:120,
            sortable: true,
            id:'ManuDate',
            renderer:Ext.util.Format.dateRenderer('Y年m月d日')
        },{
		    header: '领料时间',
		    dataIndex: 'CreateDate',
		    sortable: true,
		    id: 'CreateDate'
		},{
		    header: '备注',
		    dataIndex: 'Remark',
		    sortable: true,
		    id: 'Remark'
		}	]),
        bbar:toolBar,
        viewConfig: {
            columnsText: '显示的列',
            scrollOffset: 20,
            sortAscText: '升序',
            sortDescText: '降序',
            forceFit: false
        },
        height: 320,
        closeAction: 'hide',
        stripeRows: true,
        loadMask: true//,
        //autoExpandColumn: 2
    });
    userGrid.render();
    /*------DataGrid的函数结束 End---------------*/
    QueryDataGrid();
    
});

</script>

</html>
