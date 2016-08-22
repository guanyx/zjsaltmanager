<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmFmFundAssemble.aspx.cs" Inherits="FM_frmFmFundAssemble" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>无标题页</title>
    <meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
    <link rel="stylesheet" type="text/css" href="../ext3/resources/css/ext-all.css" />
    <script type="text/javascript" src="../ext3/adapter/ext/ext-base.js"></script>
    <script type="text/javascript" src="../ext3/ext-all.js"></script>
    <script type="text/javascript" src="../js/operateResp.js"></script>
<style type="text/css">
    <!--
    #right { width: 350px;  float: right;}
    #left { width: 350px; float: left;}
    #center { float: left;}
    .x-grid-back-blue { 
    background: #C3D9FF; 
    }
    .x-date-menu {
       width: 175px;
    }
    -->
</style>
</head>
<%=getComboBoxStore()%>
<script>
Ext.onReady(function() {
    /*------实现toolbar的函数 start---------------*/
    var Toolbar = new Ext.Toolbar({
        renderTo: "toolbar",
            items: [{
                text: "导出",
                icon: "../Theme/1/images/extjs/customer/edit16.gif",
                handler: function() { exportData()  }
            },{
                text: "打印",
                icon: "../Theme/1/images/extjs/customer/edit16.gif",
                handler: function() {   }
            }]
    });
    function exportData(){  
        if(fpztlist.getValue() =="" | fpztlist.getValue() ==null)
            return;
        
        if (!Ext.fly('exportAllData'))   
        {   
            var frm = document.createElement('form');   
            frm.id = 'exportAllData';   
            frm.name = id ;   
            //frm.style.display = 'none';   
            frm.className = 'x-hidden'; 
            document.body.appendChild(frm);   
        }  
        Ext.Ajax.request({   
            url: 'frmFmFundAssemble.aspx?method=exportData', 
            form: Ext.fly('exportAllData'),   
            method: 'POST',     
            isUpload: true,          
            params: {
                AssembleId: fpztlist.getValue()
            },
            success: function(resp, opts) {
                //Ext.Msg.hide();
            },
            failure: function(resp, opts) {
                 //Ext.Msg.hide();
            }
        });
    }
     var centerform = new Ext.FormPanel({
        renderTo: 'center',
        labelAlign: 'center',
        buttonAlign: 'center',
        bodyStyle: 'padding:1px;margin-left:33%',        
        width: '100%',
        height: 380,
        autoWidth: true,
        //autoHeight: true,
        //autoScroll: true,
        //layout: 'fit',
        frame: true,
        labelWidth: 55,
        items:[                        
        {
            layout:'column',
            border: false,
            height:150,
            labelSeparator: '：',
            html: '&nbsp;'
//          },{
//            layout:'column',
//            border: false,
//            labelSeparator: '：',
//            items: [
//            {
//	                cls: 'key',
//                    xtype: 'button',
//                    tooltip: '右移一条',
//                    text: '&nbsp;>&nbsp;',
//                    buttonAlign:'center',
//                    anchor: '98%',
//                    handler: function() {moveData('>');}
//             }]
          },{
            layout:'column',
            border: false,
            height:10,
            labelSeparator: '：',
            html: '&nbsp;'
          },
          {
            layout:'column',
            border: false,
            labelSeparator: '：',
            items: [
            {
	                cls: 'key',
                    xtype: 'button',
                    tooltip: '全部右移',                    
                    text: '&nbsp;>&nbsp;>&nbsp;',
                    buttonAlign:'right',
                    anchor: '98%',
                    handler: function() {moveData('>>');}
             }]
          },{
            layout:'column',
            border: false,
            height:10,
            labelSeparator: '：',
            html: '&nbsp;'
          },
//          {
//            layout:'column',
//            border: false,
//            labelSeparator: '：',
//            items: [
//            {
//	                cls: 'key',
//                    xtype: 'button',
//                    tooltip: '左移一条',                    
//                    text: '&nbsp;<&nbsp;',
//                    buttonAlign:'right',
//                    anchor: '98%',
//                    handler: function() {moveData('<');}
//             }]
//          },{
//            layout:'column',
//            border: false,
//            height:10,
//            labelSeparator: '：',
//            html: '&nbsp;'
//          },
          {
            layout:'column',
            border: false,
            labelSeparator: '：',
            items: [
            {
	                cls: 'key',
                    xtype: 'button',
                    tooltip: '全部左移',
                    text: '&nbsp;<&nbsp;<&nbsp;',
                    buttonAlign:'right',
                    anchor: '98%',
                    handler: function() {moveData('<<');}
             }]
          }]          
      });
   function moveData(direct){
    if(direct=='>' || direct =='>>')
    {
        if(fpztlist.getValue() =="" | fpztlist.getValue() ==null)
        {
            Ext.Msg.alert("提示", "请先选择明细的记录！");
            return;
        }
        //fmReceiveGridData
        var sm = fmLeftGrid.getSelectionModel();
        //多选
        var selectData = sm.getSelections();    
        //如果没有选择，就提示需要选择数据信息
        if (selectData == null || selectData == "") {
            Ext.Msg.alert("提示", "请选中需要操作的记录！");
            return;
        }
        for(var i=0;i<selectData.length;i++)
        {
            var nrec = selectData[i].copy();
            fmAssembleGridData.insert(fmAssembleGridData.getCount(),nrec);
            fmReceiveGridData.remove(selectData[i]);
        }
    }else{
        //fmAssembleGridData
        var sm = fmRightGrid.getSelectionModel();
        //多选
        var selectData = sm.getSelections();                
        //如果没有选择，就提示需要选择数据信息
        if (selectData == null || selectData == "") {
            Ext.Msg.alert("提示", "请选中需要操作的记录！");
            return;
        }
        for(var i=0;i<selectData.length;i++)
        {
            var nrec = selectData[i].copy();
            fmReceiveGridData.insert(fmReceiveGridData.getCount(),nrec);
            fmAssembleGridData.remove(selectData[i]);
        }
    }
    setAllTotalAmt();    
   }      
   //状态
    var fpzt = new Ext.form.ComboBox({
       xtype: 'combo',
       store: [['F181',"支票"],['F182',"现金"]],
       valueField: 'DicsCode',
       displayField: 'DicsName',
       mode: 'local',
       forceSelection: true,
       editable: false,
       emptyValue: '',
       triggerAction: 'all',
       fieldLabel: '类型',
       name:'AssembleType',
       id:'AssembleType',
       selectOnFocus: true,
       anchor: '98%',
       value:'F181',
       listeners: {
           select: function(combo, record, index) {
                 fpztlist.setValue('');
                dsAssemble.removeAll();
                fmReceiveGridData.removeAll();
                fmAssembleGridData.removeAll();
            }
        }
   });
                  
   var leftserchform = new Ext.FormPanel({
        renderTo: 'leftup',
        labelAlign: 'left',
        buttonAlign: 'right',
        bodyStyle: 'padding:5px',
        frame: true,
        title:'收款记录',
        labelWidth: 55,
        items:[                        
        {
            layout:'column',
            border: false,
            items: [
            {
                layout:'form',
                border: false,
                columnWidth:0.5,
                labelWidth: 30,
                items: [
	                {
		                xtype:'datefield',
		                fieldLabel:'日期',
		                columnWidth:0.5,
		                anchor:'98%',
		                name:'StartDate',
		                id:'StartDate',
		                value:new Date().clearTime(),
		                format:'Y年m月d日'
	                }
                        ]
            }
    ,		{
                layout:'form',
                border: false,
                columnWidth:0.5,
                labelWidth: 30,
                items: [
	                {
		                xtype:'datefield',
		                fieldLabel:'&nbsp;&nbsp;～ ',
		                labelSeparator : '',
		                columnWidth:0.5,
		                anchor:'98%',
		                name:'EndDate',
		                id:'EndDate',
		                value:new Date(),
		                format:'Y年m月d日'
	                }
                        ]
            } 		         
        ]},{
            layout:'column',
            border: false,
            labelSeparator: '：',
            items: [
            {
                layout:'form',
                border: false,
                columnWidth:0.5,
                labelWidth:30,
                items: [fpzt]
            }
      ,		{
                layout:'form',
                border: false,
                columnWidth:0.3,
                 items: [{
	                    cls: 'key',
                        xtype: 'button',
                        text: '查询',
                        buttonAlign:'right',
                        id: 'searchebtnId',
                        anchor: '25%',
                        handler: function() {QueryDataGrid();}
	                }]
                
            }
        ]}                
    ]});

    var fmReceiveGridData = new Ext.data.Store
    ({
        url: 'frmFmFundAssemble.aspx?method=getReceivelist',
        reader: new Ext.data.JsonReader({
            totalProperty: 'totalProperty',
            root: 'root'
        }, [
	    {	        name: 'ReceivableId'	    },
	    {	        name: 'CustomerId'	    },
	    {	        name: 'Amount', type: 'float'	    },
	    {	        name: 'TotalAmount', type: 'float'	    },
	    {	        name: 'CertificateStatus'	    },
	    {	        name: 'OrgId'	    },
	    {	        name: 'OwnerId'	    },
	    {	        name: 'CreateDate', type: 'date'	    },
	    {	        name: 'CustomerNo'	    },
	    {	        name: 'ShortName'	    },
	    {	        name: 'CustomerName'	    },
	    {	        name: 'ChineseName'	    },
	    {	        name: 'BusinessTypeText'	    },
	    {	        name: 'FundTypeText'	    },
	    {	        name: 'PayTypeText'    }])
    });

    /*------获取数据的函数 结束 End---------------*/
    var defaultPageSize = 10;
    var toolBar = new Ext.PagingToolbar({
        pageSize: 10,
        store: fmReceiveGridData,
        displayMsg: '{0}至{1}条,共{2}条',
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
        emptyText: '每页记录数',
        triggerAction: 'all', 
        selectOnFocus: true,
        width: 45
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
    var lsm = new Ext.grid.CheckboxSelectionModel({
        singleSelect: false
    });
    var fmLeftGrid = new Ext.grid.GridPanel({
        el: 'leftdown',
        //width: '100%',
        //height: '100%',
        //autoWidth: true,
        //autoHeight: true,
        autoScroll: true,
        //layout: 'fit',
        id: 'fmLeftGridDiv',
        store: fmReceiveGridData,
        loadMask: { msg: '正在加载数据，请稍侯……' },
        sm: lsm,
        cm: new Ext.grid.ColumnModel([
		lsm,
		new Ext.grid.RowNumberer(), //自动行号
		{
		    header: '编号',
		    dataIndex: 'ReceivableId',
		    id: 'ReceivableId',
		    hidden:true,
		    hideable:false
        },{
		    header: '客户编号',
		    dataIndex: 'CustomerNo',
		    id: 'CustomerNo',
		    width:60
        },
		{
		    header: '客户名称',
		    dataIndex: 'ChineseName',
		    id: 'ChineseName'
		},
		{
		    header: '支付类型',
		    dataIndex: 'PayTypeText',
		    id: 'PayTypeText',
		    width:60
		},
		{
		    header: '金额',
		    dataIndex: 'Amount',
		    id: 'Amount',
		    width:60
		}
        ]),
        bbar: toolBar,
        viewConfig: {
            columnsText: '显示的列',
            scrollOffset: 20,
            sortAscText: '升序',
            sortDescText: '降序',
            forceFit: false
        },
        height: 280,
        closeAction: 'hide',
        stripeRows: true,
        loadMask: true
    });
    fmLeftGrid.render();
    /*------DataGrid的函数结束 End---------------*/
    function QueryDataGrid() {
        fmReceiveGridData.baseParams.StartDate = Ext.util.Format.date(Ext.getCmp('StartDate').getValue(),'Y/m/d');
        fmReceiveGridData.baseParams.EndDate =  Ext.util.Format.date(Ext.getCmp('EndDate').getValue(),'Y/m/d');
        fmReceiveGridData.baseParams.AssembleType = fpzt.getValue();
        fmReceiveGridData.load({
            params: {
                start: 0,
                limit: defaultPageSize
            }
        });
    }
    //状态
    var dsAssemble; //下拉框
    if (dsAssemble == null) { //防止重复加载
        dsAssemble = new Ext.data.JsonStore({
            totalProperty: "result",
            root: "root",
            url: 'frmFmFundAssemble.aspx?method=getRelList',
            fields: ['AssembleId', 'AssembleName', 'FundAmt']
        })
     };  
    var fpztlist = new Ext.form.ComboBox({
       xtype: 'combo',
       store: dsAssemble,
       valueField: 'AssembleId',
       displayField: 'AssembleName',
       mode: 'local',
       forceSelection: true,
       editable: false,
       emptyValue: '',
       triggerAction: 'all',
       fieldLabel: '列表',
       name:'RelList',
       id:'RelList',
       selectOnFocus: true,
       anchor: '98%',
       listeners: {
           select: function(combo, record, index) {
                fmAssembleGridData.load({
                    params: {
                        AssembleId: combo.getValue(),
                        start:0,limit:12345
                    }
                });
                Ext.getCmp('TotalAmt').setValue(record.get('FundAmt'));
            }
        }
   });
                  
   var rightserchform = new Ext.FormPanel({
        renderTo: 'rightup',
        labelAlign: 'left',
        buttonAlign: 'right',
        bodyStyle: 'padding:5px',
        frame: true,        
        title:'汇总信息',
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
                columnWidth:0.5,
                labelWidth:30,
                items: [
	                {
		                xtype:'datefield',
		                fieldLabel:'日期',
		                columnWidth:0.5,
		                anchor:'98%',
		                name:'AssembleDate',
		                id:'AssembleDate',
		                editable:false,
		                value:new Date().clearTime(),
		                format:'Y年m月d日',
		                listeners: {   
                            'select' : function() {   
                                dsAssemble.load({
                                    params: {
                                        AssembleDate: Ext.util.Format.date(Ext.getCmp('AssembleDate').getValue(),'Y/m/d'),
                                        AssembleType: fpzt.getValue()
                                    },
                                    callback: function(r, options, success) {
                                        if (success == true) {
                                            if(dsAssemble.getCount()>0){
                                                fmAssembleGridData.load({
                                                    params: {
                                                        AssembleId: dsAssemble.getAt(0).get('AssembleId'),
                                                        start:0,limit:12345
                                                    }
                                                });
                                                
                                                fpztlist.setValue(dsAssemble.getAt(0).get('AssembleId'));
                                                Ext.getCmp('TotalAmt').setValue(dsAssemble.getAt(0).get('FundAmt'));
                                            }
                                            else
                                            {
                                                fmAssembleGridData.removeAll();
                                                fpztlist.setValue(""); 
                                            }                                           
                                        }
                                    }
                                });
                                Ext.getCmp('StartDate').setValue(Ext.getCmp('AssembleDate').getValue());    
                                QueryDataGrid();                            
	                        }
	                      }
	                    }
                        ]
            }
    ,		{
                layout:'form',
                border: false,
                columnWidth:0.5,
                labelWidth:30,
                items: [fpztlist]
            } 		         
        ]},{
            layout:'column',
            border: false,
            labelSeparator: '：',
            items: [
            {
                layout:'form',
                border: false,
                columnWidth:0.1,
                html:'&nbsp;'
            },
            {
                layout:'form',
                border: false,
                columnWidth:0.3,
                items: [{
	                    cls: 'key',
                        xtype: 'button',
                        text: '新增',
                        buttonAlign:'right',
                        id: 'rightaddbtnId',
                        anchor: '25%',
                        handler: function() {addData();}
	                }]
            },
            {
                layout:'form',
                border: false,
                columnWidth:0.3,
                items: [{
	                    cls: 'key',
                        xtype: 'button',
                        text: '保存',
                        buttonAlign:'right',
                        id: 'rightsavebtnId',
                        anchor: '25%',
                        handler: function() {saveData();}
	                }]
            }
      ,		{
                layout:'form',
                border: false,
                columnWidth:0.3,
                 items: [{
	                    cls: 'key',
                        xtype: 'button',
                        text: '删除',
                        buttonAlign:'right',
                        id: 'rightdeletebtnId',
                        anchor: '25%',
                        handler: function() {deleteData();}
	                }]
                
            }
        ]}                
    ]});
    function accAdd(arg1,arg2){  
        var r1,r2,m;  
        try{r1=arg1.toString().split(".")[1].length}catch(e){r1=0}  
        try{r2=arg2.toString().split(".")[1].length}catch(e){r2=0}  
        m=Math.pow(10,Math.max(r1,r2))  
        return (arg1*m+arg2*m)/m  
    } 
    function addData()
    {
        var index = dsAssemble.getCount(); 
        var isexist = 0;
        dsAssemble.each(function(rec) {
            if(rec.data.AssembleId == -1)
                isexist = 1;
        });
        if(isexist>0){
            Ext.Msg.alert("提示","请先保存新增的记录！");
            return;
        }
        fmAssembleGridData.removeAll();
        var addRow = new Ext.data.Record({AssembleId:-1,AssembleName:'第'+accAdd(index,1)+"条汇总记录",FundAmt:0});
        dsAssemble.insert(index, addRow);
        fpztlist.setValue(-1);
        
    }
    function saveData()
    {
        if(fpztlist.getValue()==null ||fpztlist.getValue()=="")
            return;
        if(fmAssembleGridData.getCount()==0)
            return;
            
        Ext.MessageBox.wait("数据正在处理，请稍候……");
                
        var json = "";
        fmAssembleGridData.each(function(rec) {
            json += rec.data.ReceivableId + ',';
        });        
        json = json.substring(0,json.length-1);
        //alert(json);   
        
        //check
        Ext.Ajax.request({   
            url: 'frmFmFundAssemble.aspx?method=saveData',
            method: 'POST',           
            params: {
                AssembleDate:Ext.util.Format.date(Ext.getCmp('AssembleDate').getValue(),'Y/m/d'),
                AssembleId:fpztlist.getValue(),
                AssembleType:fpzt.getValue(),
                FundAmt:Ext.getCmp('TotalAmt').getValue(),
                ReceivableId: json//传入多项的id串
            },
            success: function(resp, opts) {
                Ext.MessageBox.hide();
                if( checkExtMessage(resp) )
                {                    
                    dsAssemble.load({
                        params: {
                            AssembleDate: Ext.util.Format.date(Ext.getCmp('AssembleDate').getValue(),'Y/m/d'),
                            AssembleType:fpzt.getValue()
                        },
                        callback:function(){                           
                            fpztlist.setValue(dsAssemble.getAt(0).get('AssembleId'));
                        }
                    });
                                        
                }
            }, 
            failure: function(resp, opts) {
                 Ext.MessageBox.hide();
             }
        });  
    }
    function deleteData()
    {
        //删除前再次提醒是否真的要删除
        Ext.Msg.confirm("提示信息", "是否真的要删除"+fpztlist.getRawValue()+"吗？", function callBack(id) {
            //判断是否删除数据
            if (id == "yes") {
                //check
                if(fpztlist.getValue()=="-1"){
                    dsAssemble.remove(dsAssemble.getAt(dsAssemble.find('AssembleId','-1')));
                    fpztlist.setValue('');
                    fmAssembleGridData.removeAll();
                    QueryDataGrid();
                    return;
                }
                
                Ext.Ajax.request({   
                    url: 'frmFmFundAssemble.aspx?method=deteleData',
                    method: 'POST',           
                    params: {
                        AssembleDate:Ext.util.Format.date(Ext.getCmp('AssembleDate').getValue(),'Y/m/d'),
                        AssembleId:fpztlist.getValue()
                    },
                    success: function(resp, opts) {
                        Ext.MessageBox.hide();
                        if( checkExtMessage(resp) )
                        {
                            fpztlist.setValue('');
                            dsAssemble.reload();
                            fmAssembleGridData.removeAll();
                            QueryDataGrid();
                        }
                    }, 
                    failure: function(resp, opts) {
                         Ext.MessageBox.hide();
                     }
                }); 
             }
        });
    }
    /*------开始DataGrid的函数 start---------------*/    
    var fmAssembleGridData = new Ext.data.Store
    ({
        url: 'frmFmFundAssemble.aspx?method=getlist',
        reader: new Ext.data.JsonReader({
            totalProperty: 'totalProperty',
            root: 'root'
        }, [
	    {	        name: 'ReceivableId'	    },
	    {	        name: 'CustomerId'	    },
	    {	        name: 'Amount', type: 'float'	    },
	    {	        name: 'TotalAmount', type: 'float'	    },
	    {	        name: 'CertificateStatus'	    },
	    {	        name: 'OrgId'	    },
	    {	        name: 'OwnerId'	    },
	    {	        name: 'CreateDate', type: 'date'	    },
	    {	        name: 'CustomerNo'	    },
	    {	        name: 'ShortName'	    },
	    {	        name: 'ChineseName'	    },
	    {	        name: 'BusinessTypeText'	    },
	    {	        name: 'FundTypeText'	    },
	    {	        name: 'PayTypeText'    }])
    });
    var rsm = new Ext.grid.CheckboxSelectionModel({
        singleSelect: false
    });
    var fmRightGrid = new Ext.grid.GridPanel({
        el: 'rightdown',
        //width: '100%',
        //height: '100%',
        //autoWidth: true,
        //autoHeight: true,
        autoScroll: true,
        //layout: 'fit',
        id: 'fmRightGridDiv',
        store: fmAssembleGridData,
        loadMask: { msg: '正在加载数据，请稍侯……' },
        sm: rsm,
        cm: new Ext.grid.ColumnModel([
		rsm,
		new Ext.grid.RowNumberer(), //自动行号
		{
		    header: '编号',
		    dataIndex: 'ReceivableId',
		    id: 'ReceivableId',
		    hidden:true,
		    hideable:false
        },{
		    header: '客户编号',
		    dataIndex: 'CustomerNo',
		    id: 'CustomerNo',
		    width:60
        },
		{
		    header: '客户名称',
		    dataIndex: 'ChineseName',
		    id: 'ChineseName',
		    width:150
		},
//		{
//		    header: '支付类型',
//		    dataIndex: 'FundTypeText',
//		    id: 'FundTypeText',
//		    width:60
//		},
		{
		    header: '金额',
		    dataIndex: 'Amount',
		    id: 'Amount',
		    width:55
		},
		{
		    header: '金额',
		    dataIndex: 'TotalAmount',
		    id: 'TotalAmount',
		    hidden:true,
		    hideable:false
		}
        ]),
        bbar:['->',{             
            text:'合计金额:',
            xtype: 'label'
        },
        {             
            xtype: 'numberfield',
            format:true,
            width: 80,
	        id:'TotalAmt',
	        name:'TotalAmt',
	        value:0,
	        style: 'color:blue;background:white;text-align: right',
	        readOnly:true
        }],
        viewConfig: {
            columnsText: '显示的列',
            scrollOffset: 20,
            sortAscText: '升序',
            sortDescText: '降序',
            forceFit: false
        },
        height: 280,
        closeAction: 'hide',
        stripeRows: true,
        loadMask: true
    });
    fmRightGrid.render();
    /*------DataGrid的函数结束 End---------------*/
    function setAllTotalAmt(){
        var tamt =0;
        fmAssembleGridData.each(function(rec) {
            if(rec.data.Amount == null && rec.data.Amount == undefined)
                rec.data.Amount = 0;
            tamt =accAdd(rec.data.Amount,tamt);
        });
        Ext.getCmp('TotalAmt').setValue(tamt);
    }
});
        
</script>
<body>
    <div id='toolbar'></div>  
    <div id="left">
        <div id="leftup"></div>
        <div id="leftdown"></div>
    </div>
    <div id="right">
        <div id="rightup"></div>
        <div id="rightdown"></div>
    </div>  
    <div id='center'></div>        
</body>
</html>
<script>
if(document.body.offsetWidth-700>100)
document.getElementById('center').style.width=document.body.offsetWidth-700;
else
document.getElementById('center').style.width=100;
document.getElementById('center').style.left=350;
document.getElementById('center').style.top=0;
</script>
