<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmFmFundAssemble.aspx.cs" Inherits="FM_frmFmFundAssemble" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>�ޱ���ҳ</title>
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
    /*------ʵ��toolbar�ĺ��� start---------------*/
    var Toolbar = new Ext.Toolbar({
        renderTo: "toolbar",
            items: [{
                text: "����",
                icon: "../Theme/1/images/extjs/customer/edit16.gif",
                handler: function() { exportData()  }
            },{
                text: "��ӡ",
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
            labelSeparator: '��',
            html: '&nbsp;'
//          },{
//            layout:'column',
//            border: false,
//            labelSeparator: '��',
//            items: [
//            {
//	                cls: 'key',
//                    xtype: 'button',
//                    tooltip: '����һ��',
//                    text: '&nbsp;>&nbsp;',
//                    buttonAlign:'center',
//                    anchor: '98%',
//                    handler: function() {moveData('>');}
//             }]
          },{
            layout:'column',
            border: false,
            height:10,
            labelSeparator: '��',
            html: '&nbsp;'
          },
          {
            layout:'column',
            border: false,
            labelSeparator: '��',
            items: [
            {
	                cls: 'key',
                    xtype: 'button',
                    tooltip: 'ȫ������',                    
                    text: '&nbsp;>&nbsp;>&nbsp;',
                    buttonAlign:'right',
                    anchor: '98%',
                    handler: function() {moveData('>>');}
             }]
          },{
            layout:'column',
            border: false,
            height:10,
            labelSeparator: '��',
            html: '&nbsp;'
          },
//          {
//            layout:'column',
//            border: false,
//            labelSeparator: '��',
//            items: [
//            {
//	                cls: 'key',
//                    xtype: 'button',
//                    tooltip: '����һ��',                    
//                    text: '&nbsp;<&nbsp;',
//                    buttonAlign:'right',
//                    anchor: '98%',
//                    handler: function() {moveData('<');}
//             }]
//          },{
//            layout:'column',
//            border: false,
//            height:10,
//            labelSeparator: '��',
//            html: '&nbsp;'
//          },
          {
            layout:'column',
            border: false,
            labelSeparator: '��',
            items: [
            {
	                cls: 'key',
                    xtype: 'button',
                    tooltip: 'ȫ������',
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
            Ext.Msg.alert("��ʾ", "����ѡ����ϸ�ļ�¼��");
            return;
        }
        //fmReceiveGridData
        var sm = fmLeftGrid.getSelectionModel();
        //��ѡ
        var selectData = sm.getSelections();    
        //���û��ѡ�񣬾���ʾ��Ҫѡ��������Ϣ
        if (selectData == null || selectData == "") {
            Ext.Msg.alert("��ʾ", "��ѡ����Ҫ�����ļ�¼��");
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
        //��ѡ
        var selectData = sm.getSelections();                
        //���û��ѡ�񣬾���ʾ��Ҫѡ��������Ϣ
        if (selectData == null || selectData == "") {
            Ext.Msg.alert("��ʾ", "��ѡ����Ҫ�����ļ�¼��");
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
   //״̬
    var fpzt = new Ext.form.ComboBox({
       xtype: 'combo',
       store: [['F181',"֧Ʊ"],['F182',"�ֽ�"]],
       valueField: 'DicsCode',
       displayField: 'DicsName',
       mode: 'local',
       forceSelection: true,
       editable: false,
       emptyValue: '',
       triggerAction: 'all',
       fieldLabel: '����',
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
        title:'�տ��¼',
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
		                fieldLabel:'����',
		                columnWidth:0.5,
		                anchor:'98%',
		                name:'StartDate',
		                id:'StartDate',
		                value:new Date().clearTime(),
		                format:'Y��m��d��'
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
		                fieldLabel:'&nbsp;&nbsp;�� ',
		                labelSeparator : '',
		                columnWidth:0.5,
		                anchor:'98%',
		                name:'EndDate',
		                id:'EndDate',
		                value:new Date(),
		                format:'Y��m��d��'
	                }
                        ]
            } 		         
        ]},{
            layout:'column',
            border: false,
            labelSeparator: '��',
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
                        text: '��ѯ',
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

    /*------��ȡ���ݵĺ��� ���� End---------------*/
    var defaultPageSize = 10;
    var toolBar = new Ext.PagingToolbar({
        pageSize: 10,
        store: fmReceiveGridData,
        displayMsg: '{0}��{1}��,��{2}��',
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
        emptyText: 'ÿҳ��¼��',
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
    
    /*------��ʼDataGrid�ĺ��� start---------------*/
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
        loadMask: { msg: '���ڼ������ݣ����Ժ��' },
        sm: lsm,
        cm: new Ext.grid.ColumnModel([
		lsm,
		new Ext.grid.RowNumberer(), //�Զ��к�
		{
		    header: '���',
		    dataIndex: 'ReceivableId',
		    id: 'ReceivableId',
		    hidden:true,
		    hideable:false
        },{
		    header: '�ͻ����',
		    dataIndex: 'CustomerNo',
		    id: 'CustomerNo',
		    width:60
        },
		{
		    header: '�ͻ�����',
		    dataIndex: 'ChineseName',
		    id: 'ChineseName'
		},
		{
		    header: '֧������',
		    dataIndex: 'PayTypeText',
		    id: 'PayTypeText',
		    width:60
		},
		{
		    header: '���',
		    dataIndex: 'Amount',
		    id: 'Amount',
		    width:60
		}
        ]),
        bbar: toolBar,
        viewConfig: {
            columnsText: '��ʾ����',
            scrollOffset: 20,
            sortAscText: '����',
            sortDescText: '����',
            forceFit: false
        },
        height: 280,
        closeAction: 'hide',
        stripeRows: true,
        loadMask: true
    });
    fmLeftGrid.render();
    /*------DataGrid�ĺ������� End---------------*/
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
    //״̬
    var dsAssemble; //������
    if (dsAssemble == null) { //��ֹ�ظ�����
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
       fieldLabel: '�б�',
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
        title:'������Ϣ',
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
                columnWidth:0.5,
                labelWidth:30,
                items: [
	                {
		                xtype:'datefield',
		                fieldLabel:'����',
		                columnWidth:0.5,
		                anchor:'98%',
		                name:'AssembleDate',
		                id:'AssembleDate',
		                editable:false,
		                value:new Date().clearTime(),
		                format:'Y��m��d��',
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
            labelSeparator: '��',
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
                        text: '����',
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
                        text: '����',
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
                        text: 'ɾ��',
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
            Ext.Msg.alert("��ʾ","���ȱ��������ļ�¼��");
            return;
        }
        fmAssembleGridData.removeAll();
        var addRow = new Ext.data.Record({AssembleId:-1,AssembleName:'��'+accAdd(index,1)+"�����ܼ�¼",FundAmt:0});
        dsAssemble.insert(index, addRow);
        fpztlist.setValue(-1);
        
    }
    function saveData()
    {
        if(fpztlist.getValue()==null ||fpztlist.getValue()=="")
            return;
        if(fmAssembleGridData.getCount()==0)
            return;
            
        Ext.MessageBox.wait("�������ڴ������Ժ򡭡�");
                
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
                ReceivableId: json//��������id��
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
        //ɾ��ǰ�ٴ������Ƿ����Ҫɾ��
        Ext.Msg.confirm("��ʾ��Ϣ", "�Ƿ����Ҫɾ��"+fpztlist.getRawValue()+"��", function callBack(id) {
            //�ж��Ƿ�ɾ������
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
    /*------��ʼDataGrid�ĺ��� start---------------*/    
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
        loadMask: { msg: '���ڼ������ݣ����Ժ��' },
        sm: rsm,
        cm: new Ext.grid.ColumnModel([
		rsm,
		new Ext.grid.RowNumberer(), //�Զ��к�
		{
		    header: '���',
		    dataIndex: 'ReceivableId',
		    id: 'ReceivableId',
		    hidden:true,
		    hideable:false
        },{
		    header: '�ͻ����',
		    dataIndex: 'CustomerNo',
		    id: 'CustomerNo',
		    width:60
        },
		{
		    header: '�ͻ�����',
		    dataIndex: 'ChineseName',
		    id: 'ChineseName',
		    width:150
		},
//		{
//		    header: '֧������',
//		    dataIndex: 'FundTypeText',
//		    id: 'FundTypeText',
//		    width:60
//		},
		{
		    header: '���',
		    dataIndex: 'Amount',
		    id: 'Amount',
		    width:55
		},
		{
		    header: '���',
		    dataIndex: 'TotalAmount',
		    id: 'TotalAmount',
		    hidden:true,
		    hideable:false
		}
        ]),
        bbar:['->',{             
            text:'�ϼƽ��:',
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
            columnsText: '��ʾ����',
            scrollOffset: 20,
            sortAscText: '����',
            sortDescText: '����',
            forceFit: false
        },
        height: 280,
        closeAction: 'hide',
        stripeRows: true,
        loadMask: true
    });
    fmRightGrid.render();
    /*------DataGrid�ĺ������� End---------------*/
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
