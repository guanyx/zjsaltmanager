<%@ Page Language="C#" AutoEventWireup="true" CodeFile="DeskTop.aspx.cs" Inherits="DeskTop" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title></title>
<style type="text/css">
    /*通用样式*/
html,body,div,p,ul,ol,li,dl,dt,dd,h1,h2,h3,h4,h5,h6,object,iframe,form,blockquote,fieldset,input,textarea,code,address,caption,cite,code,em,i,ins{margin:0;padding:0;font-style:normal;font-size:12px;font-weight:normal;}
</style>
<meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<link rel="stylesheet" type="text/css" href="ext3/resources/css/ext-all.css" />
<script type="text/javascript" src="ext3/adapter/ext/ext-base.js"></script>
<script type="text/javascript" src="ext3/ext-all.js"></script>
</head>

<body style="margin:10px 10px 10px 10px">  
    <div id='alert-system-main' style="margin:0px 5px 0px 5px">
    </div>   
    <div id='alert-wharehouse-main' style="margin:5px 5px 5px 5px">
    </div>  
    <div id='alert-fund-main' style="margin:0px 5px 0px 5px">
    </div> 
    <div id='alert-receive-fund-main' style="margin:0px 5px 0px 5px">
    </div> 
    <div id='alert-send-main' style="margin:0px 5px 0px 5px">
    </div> 
</body>

<script type="text/javascript">
Ext.BLANK_IMAGE_URL = "ext3/resources/images/default/s.gif";
Ext.onReady(function(){
    /*------开始获取数据的函数 start---------------*/
    //如果是供应商就不要开始界面
    <%if(!ZJSIG.UIProcess.ADM.UIAdmUser.IsCustomer(this)) {%>
    var dsMsggridData = new Ext.data.Store
    ({
    url: 'DeskTop.aspx?method=getMessageList',
    reader:new Ext.data.JsonReader({
	    totalProperty:'totalProperty',
	    root:'root'
    },[
	    {		name:'MessageId'	},
	    {		name:'MessageNumber'	},
	    {		name:'Title'	},
	    {		name:'DeleteFlg'	},
	    {		name:'ExpirationDate'	},
	    {		name:'Remark'	
	    }	])
	    ,
	    listeners:
	    {
		    scope:this,
		    load:function(){
		    }
	    }
    });

/*------获取数据的函数 结束 End---------------*/

/*------开始DataGrid的函数 start---------------*/
var msggridData = new Ext.grid.GridPanel({
	width:500,
	height:'100%',
	autoScroll:true,
	layout: 'fit',
	id: '',
	store: dsMsggridData,
	loadMask: {msg:'正在加载数据，请稍侯……'},
	cm: new Ext.grid.ColumnModel([
		{
            header: '消息编号',
            width: 20,
            dataIndex: 'MessageId',
            id: 'MessageId',
            hidden: true,
            hideable:false
        },{
            header: '消息编号',
            width: 20,
            dataIndex: 'MessageNumber',
            id: 'MessageNumber',
            sortable: true,
            hideable:false
        },
        {
            header: '消息标题',
            width: 30,
            dataIndex: 'Title',
            id: 'Title',
            sortable: true,
            hideable:false
        },
        {
            header: '失效日期',
            width: 20,
            dataIndex: 'ExpirationDate',
            id: 'ExpirationDate',
            renderer: Ext.util.Format.dateRenderer('Y年m月d日'),
            sortable: true,
            hideable:false
        },
        {
            header: '是否删除',
            width: 10,
            dataIndex: 'DeleteFlg',
            id: 'DeleteFlg',
            renderer:function(v){if(v==0)return '正常';else return '删除';},
            sortable: true,
            hideable:false
        },
        {
            header: '备注',
            width: 40,
            dataIndex: 'Remark',
            id: 'Remark'	
        }	
		]),
		bbar: new Ext.PagingToolbar({
			pageSize: 10,
			store: dsMsggridData,
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
		height: 120,
		closeAction: 'hide',
		stripeRows: true,
		loadMask: true,
		autoExpandColumn: 2
	});	
    msggridData.addListener('rowdblclick',function rowdblclickFn(grid, rowindex, e){     
        grid.getSelectionModel().each(function(rec){     
            var url = "BA/sysadmin/frmSysMessageShow.aspx?msgid="+rec.data.MessageId;
            var iTop = (window.screen.availHeight-30-380)/2;       //获得窗口的垂直位置;
            var iLeft = (window.screen.availWidth-10-620)/2;           //获得窗口的水平位置;
            window.open(url,"","toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=no,width=620,height=380,top="+iTop+",left="+iLeft);        
        });     
    });  
     
    var alermSystemform = new Ext.form.FormPanel({
        title:'公告信息',
        frame: true,
        renderTo:'alert-system-main',
        width:'100%',
        height:320,
        layout: 'fit',
        labelAlign: 'left',
        buttonAlign: 'center',
        collapsible: true,
        //collapsed:true,
        items: [msggridData]
    });
    alermSystemform.render();
    dsMsggridData.load({params:{start:0,limit:10}});
    <%} %>
    //-------------------------------------------------------------------------
    <% if(is_wh_alerm){ %>
    var dsWhgridData = new Ext.data.Store
    ({
    url: 'DeskTop.aspx?method=getWhAlermList',
    reader:new Ext.data.JsonReader({
	    totalProperty:'totalProperty',
	    root:'root'
    },[
	    {		name:'WhName'	},
	    {		name:'WarningName'	},
	    {		name:'ProductNo'	},
	    {		name:'ProductName'	},
	    {		name:'SpecificationsText'	},
	    {		name:'RealQty'	},
	    {		name:'WarningValue'	},
	    {		name:'UnitText'	}
	    	])
	    ,
	    listeners:
	    {
		    scope:this,
		    load:function(){
		    }
	    }
    });
    var whgridData = new Ext.grid.GridPanel({
	width:500,
	height:'100%',
	autoScroll:true,
	layout: 'fit',
	id: '',
	store: dsWhgridData,
	loadMask: {msg:'正在加载数据，请稍侯……'},
	cm: new Ext.grid.ColumnModel([
		{
            header: '仓库名称',
            width: 70,
            dataIndex: 'WhName',
            id: 'WhName'
        },
        {
            header: '告警类型',
            width: 30,
            dataIndex: 'WarningName',
            id: 'WarningName'
        },
        {
            header: '产品编号',
            width: 30,
            dataIndex: 'ProductNo',
            id: 'ProductNo'
        },
        {
            header: '产品名称',
            width: 30,
            dataIndex: 'ProductName',
            id: 'ProductName'
        },
        {
            header: '规格',
            width: 30,
            dataIndex: 'SpecificationsText',
            id: 'SpecificationsText'
        },
        {
            header: '单位',
            width: 40,
            dataIndex: 'UnitText',
            id: 'UnitText'	
        },
        {
            header: '实际数量',
            width: 30,
            dataIndex: 'RealQty',
            id: 'RealQty'
        }	,
        {
            header: '告警数量',
            width: 30,
            dataIndex: 'WarningValue',
            id: 'WarningValue'
        }	
		]),
		bbar: new Ext.PagingToolbar({
			pageSize: 10,
			store: dsWhgridData,
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
		height: 120,
		closeAction: 'hide',
		stripeRows: true,
		loadMask: true,
		autoExpandColumn: 2
	});	
    var alermWharehouseform = new Ext.form.FormPanel({
        title:'仓库预警',
        frame: true,
        renderTo:'alert-wharehouse-main',
        width:'100%',
        height:320,
        layout: 'fit',
        labelAlign: 'left',
        buttonAlign: 'center',
        collapsible: true,
        collapsed:true,
        items:[whgridData]
    });
    alermWharehouseform.render();
    dsWhgridData.load({params:{start:0,limit:10}});
    <%} %>
    //-------------------------------------------------------------------------
    <% if(is_pay_alerm){ %>
    var dsPaygridData = new Ext.data.Store
    ({
    url: 'DeskTop.aspx?method=getPayableAlermList',
    reader:new Ext.data.JsonReader({
	    totalProperty:'totalProperty',
	    root:'root'
    },[
	    {		name:'CustomerNo'	},
	    {		name:'CustomerName'	},
	    {		name:'TotalAmount',type:'float'	},
	    {		name:'CreateDate'	},
	    {		name:'PayTypeText'	
	    }	])
	    ,
	    listeners:
	    {
		    scope:this,
		    load:function(){
		    }
	    }
    });
    var paygridData = new Ext.grid.GridPanel({
	width:500,
	height:'100%',
	autoScroll:true,
	layout: 'fit',
	id: '',
	store: dsPaygridData,
	loadMask: {msg:'正在加载数据，请稍侯……'},
	cm: new Ext.grid.ColumnModel([
		{
            header: '供应商编号',
            width: 100,
            dataIndex: 'CustomerNo',
            id: 'CustomerNo'
        },
        {
            header: '供应商名称',
            width: 200,
            dataIndex: 'CustomerName',
            id: 'CustomerName'
        },
        {
            header: '日期',
            width: 200,
            dataIndex: 'CreateDate',
            id: 'CreateDate',
            renderer: Ext.util.Format.dateRenderer('Y年m月d日 H时i分s秒')
        },
        {
            header: '金额',
            width: 100,
            dataIndex: 'TotalAmount',
            id: 'TotalAmount',
            renderer:function(v){
                return '￥ '+v.toFixed(2);
            }
        },
        {
            header: '付款类型',
            width: 80,
            dataIndex: 'PayTypeText',
            id: 'PayTypeText'	
        }	
		]),
		bbar: new Ext.PagingToolbar({
			pageSize: 10,
			store: dsPaygridData,
			displayMsg: '显示第{0}条到{1}条记录,共{2}条',
			emptyMsy: '没有记录',
			displayInfo: true
		}),
		viewConfig: {
			columnsText: '显示的列',
			scrollOffset: 20,
			sortAscText: '升序',
			sortDescText: '降序',
			forceFit: false
		},
		height: 120,
		closeAction: 'hide',
		stripeRows: true,
		loadMask: true//,
		//autoExpandColumn: 2
	});	
    var alermFundform = new Ext.form.FormPanel({
        title:'应付款提醒',
        frame: true,
        renderTo:'alert-fund-main',
        width:'100%',
        height:320,
        layout: 'fit',
        labelAlign: 'left',
        buttonAlign: 'center',
        collapsible: true,
        collapsed:true,
        items:[paygridData]
    });
    alermFundform.render();
    dsPaygridData.load({params:{start:0,limit:10}});
    <%} %>
    
    //-------------------------------------------------------------------------
    <% if(is_receive_alerm){ %>
    var dsReceivegridData = new Ext.data.Store
    ({
    url: 'DeskTop.aspx?method=getReceiveAlermList',
    reader:new Ext.data.JsonReader({
	    totalProperty:'totalProperty',
	    root:'root'
    },[
	    {		name:'CustomerNo'	},
	    {		name:'CustomerName'	},
	    {		name:'TotalAmount',type:'float'	},
	    {		name:'CreateDate'	},
	    {		name:'PayTypeText'	
	    }	])
	    ,
	    listeners:
	    {
		    scope:this,
		    load:function(){
		    }
	    }
    });
    var receivegridData = new Ext.grid.GridPanel({
	width:500,
	height:'100%',
	autoScroll:true,
	layout: 'fit',
	id: '',
	store: dsReceivegridData,
	loadMask: {msg:'正在加载数据，请稍侯……'},
	cm: new Ext.grid.ColumnModel([
		{
            header: '客户编号',
            width: 100,
            dataIndex: 'CustomerNo',
            id: 'CustomerNo'
        },
        {
            header: '客户名称',
            width: 200,
            dataIndex: 'CustomerName',
            id: 'CustomerName'
        },
        {
            header: '日期',
            width: 200,
            dataIndex: 'CreateDate',
            id: 'CreateDate',
            renderer: Ext.util.Format.dateRenderer('Y年m月d日 H时i分s秒')
        },
        {
            header: '金额',
            width: 120,
            dataIndex: 'TotalAmount',
            id: 'TotalAmount',
            align:'right',
            renderer:function(v){
                return '￥ '+v.toFixed(2);
            }
        },
        {
            header: '收款类型',
            width: 80,
            dataIndex: 'PayTypeText',
            id: 'PayTypeText'	
        }	
		]),
		bbar: new Ext.PagingToolbar({
			pageSize: 10,
			store: dsReceivegridData,
			displayMsg: '显示第{0}条到{1}条记录,共{2}条',
			emptyMsy: '没有记录',
			displayInfo: true
		}),
		viewConfig: {
			columnsText: '显示的列',
			scrollOffset: 20,
			sortAscText: '升序',
			sortDescText: '降序',
			forceFit: false
		},
		height: 120,
		closeAction: 'hide',
		stripeRows: true,
		loadMask: true//,
		//autoExpandColumn: 2
	});	
    var alermReceiveFundform = new Ext.form.FormPanel({
        title:'应收款提醒',
        frame: true,
        renderTo:'alert-receive-fund-main',
        width:'100%',
        height:320,
        layout: 'fit',
        labelAlign: 'left',
        buttonAlign: 'center',
        collapsible: true,
        collapsed:true,
        items:[receivegridData]
    });
    alermReceiveFundform.render();
    dsReceivegridData.load({params:{start:0,limit:10}});
    <%} %>
    
    //-------------------------------------------------------------------------
    <% if(is_send_alerm){ %>
    var dssendgridData = new Ext.data.Store
    ({
    url: 'DeskTop.aspx?method=getSendAlermList',
    reader:new Ext.data.JsonReader({
	    totalProperty:'totalProperty',
	    root:'root'
    },[
	    {		name:'CustomerNo'	},
	    {		name:'ShortName'	},
	    {		name:'DestInfo'	},
	    {		name:'CarBoatNo'	},
	    {		name:'TransType'	},
	    {		name:'CreateDate'	
	    }	])
	    ,
	    listeners:
	    {
		    scope:this,
		    load:function(){
		    }
	    }
    });
    var sendgridData = new Ext.grid.GridPanel({
	width:500,
	height:'100%',
	autoScroll:true,
	layout: 'fit',
	id: '',
	store: dssendgridData,
	loadMask: {msg:'正在加载数据，请稍侯……'},
	cm: new Ext.grid.ColumnModel([
		{
            header: '供应商编号',
            width: 80,
            dataIndex: 'CustomerNo',
            id: 'CustomerNo'
        },
        {
            header: '供应商名称',
            width: 80,
            dataIndex: 'ShortName',
            id: 'ShortName'
        },
        {
            header:'车船号',
            width:80,
            dataIndex:'CarBoatNo',
            id:'CarBoatNo'
        },
        {
            header: '到站信息',
            width: 80,
            dataIndex: 'DestInfo',
            id: 'DestInfo'
        },
        {
            header: '发运方式',
            width: 80,
            dataIndex: 'TransType',
            id: 'TransType',
            renderer:function(v){
                if(v=='A401') return '铁路';    
                if(v=='A402') return '水路';
                if(v=='A403') return '公路';            
                if(v=='A404') return '集装箱';  
                if(v=='A405') return '自提';    
            }
        },
        {
            header: '日期',
            width: 100,
            dataIndex: 'CreateDate',
            id: 'CreateDate',
            renderer: Ext.util.Format.dateRenderer('Y年m月d日')
        }	
		]),
		bbar: new Ext.PagingToolbar({
			pageSize: 10,
			store: dssendgridData,
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
		height: 120,
		closeAction: 'hide',
		stripeRows: true,
		loadMask: true,
		autoExpandColumn: 2
	});	
    var alermSendform = new Ext.form.FormPanel({
        title:'采购入库提醒',
        frame: true,
        renderTo:'alert-send-main',
        width:'100%',
        height:320,
        layout: 'fit',
        labelAlign: 'left',
        buttonAlign: 'center',
        collapsible: true,
        collapsed:true,
        items:[sendgridData]
    });
    alermSendform.render();
    dssendgridData.load({params:{start:0,limit:10}});
    <%} %>
    
});
</script>
<script type="text/javascript">
 var  sDate = '<%=server_date %>';
 var d=new Date(sDate);
 var sp=Math.floor((new Date()-d)/(24*60*60*1000));
 if(sp<-1){
    alert("您本地电脑日期出现异常，请检查您的电脑日期并设置正确！");
    top.location.href='login.html';
 }
</script>
</html>
<script type="text/javascript">
var msg = '<%=alertMsg %>';
if(msg != '')
{
    //document.getElementById('alert-wharehouse-main').innerHTML = msg;
}
</script>
