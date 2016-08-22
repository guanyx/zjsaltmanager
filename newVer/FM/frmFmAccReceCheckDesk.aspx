<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmFmAccReceCheckDesk.aspx.cs" Inherits="FM_frmFmAccReceCheckDesk" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html>
<head>
<title>����ά��</title><meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<link rel="stylesheet" type="text/css" href="../ext3/resources/css/ext-all.css" />
<link rel="stylesheet" type="text/css" href="../Theme/1/css/salt.css" />
<script type="text/javascript" src="../ext3/adapter/ext/ext-base.js"></script>
<script type="text/javascript" src="../ext3/ext-all.js"></script>
<script type="text/javascript" src="../ext3/example/ItemDeleter.js"></script>
<script type="text/javascript" src="../js/operateResp.js"></script>
<script type="text/javascript" src="../ext3/src/locale/ext-lang-zh_CN.js"></script>
<style type="text/css">
.extensive-remove {
background-image: url(../Theme/1/images/extjs/customer/cross.gif) ! important;
}
.x-grid-back-blue { 
background: #B7CBE8; 
}
.x-grid3-row-alt {
background-color:#CFE8FF
}
</style>
</head>
<body>
<div id='divDataGrid'></div>
<div id='divDoGrid'></div>
<div id='divBotton'></div>
</body>
<%= getComboBoxStore() %>
<script type="text/javascript">
Ext.BLANK_IMAGE_URL = "../ext3/resources/images/default/s.gif";
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
//���Ҫ���Ҳ���key:
var ReceivableIds = args["id"];

Ext.onReady(function() {  

    Ext.form.TextField.prototype.afterRender = Ext.form.TextField.prototype.afterRender.createSequence(function() {
     this.relayEvents(this.el, ['onblur']);
    });
    
    /*------��ʼ��ȡ���ݵĺ��� start---------------*/
    var MstGridData = new Ext.data.Store
    ({
        url: 'frmFmAccReceCheckDesk.aspx?method=getCustomerAccReceList',
        reader: new Ext.data.JsonReader({
            totalProperty: 'totalProperty',
            root: 'root'
        }, [
            { name: "ReceivableId" },
            { name: "BusinessType" },
            { name: "FundType" },
            { name: "CustomerId" },
            { name: "CustomerNo" },
            { name: "CustomerName" },
            { name: "PayType" },
            { name: "Amount" },
            { name: "TotalAmount" },
            { name: "OperId" },
            { name: "Ext1" },
            { name: "Ext2" },
            { name: "Notes" },
            { name: "PayTypeText" },
            { name: "OperName" },
            { name: 'CreateDate' }
          ]),
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
    var MstGrid = new Ext.grid.GridPanel({
        el: 'divDataGrid',
        width:document.body.offsetWidth,
        height: 200,
        columnLines:true,
        autoScroll: true,
        title: 'Ԥ������Ϣ',
        id: '',
        store: MstGridData,
        loadMask: { msg: '���ڼ������ݣ����Ժ��' },
        sm: sm,
        cm: new Ext.grid.ColumnModel([
        sm,
        new Ext.grid.RowNumberer(), //�Զ��к�
          {header: "�ͻ�ID", dataIndex: 'CustomerId', hidden: true, hideable: false },
          { header: "�տ���", width: 70, sortable: true, dataIndex: 'ReceivableId' },
          { header: "�ͻ����", width: 80, sortable: true, dataIndex: 'CustomerNo' },
          { header: "�ͻ�����", width: 170, sortable: true, dataIndex: 'CustomerName' },
          { header: "Ԥ�����", width: 75, sortable: true, dataIndex: 'Amount' },
          { header: "δ�˽��", width: 75, sortable: true, dataIndex: 'Ext1' },
          { header: "�Ƿ���ȫ��", width: 50, sortable: true, dataIndex: 'Ext1', renderer:function(v){if(v==0) return '��';else return '��';} },
          { header: "��������", width: 70, sortable: true, dataIndex: 'PayTypeText' },
          { header: "����Ա", width: 60, sortable: true, dataIndex: 'OperName' },
          { header: "����ʱ��", width: 110, sortable: true, dataIndex: 'CreateDate', renderer: Ext.util.Format.dateRenderer('Y��m��d��') },
          { header: '��ע',width: 100, sortable: true, dataIndex: 'Notes'}

        ]),
        bbar: new Ext.PagingToolbar({
            pageSize: 10,
            store: MstGridData,
            displayMsg: '��ʾ��{0}����{1}����¼,��{2}��',
            emptyMsy: 'û�м�¼',
            displayInfo: true
        }),
        viewConfig: {
            columnsText: '��ʾ����',
            scrollOffset: 20,
            sortAscText: '����',
            sortDescText: '����',
            forceFit: false
        },
        closeAction: 'hide',
        stripeRows: true,
        loadMask: true//,
        //autoExpandColumn: 2
    });
    MstGrid.on("afterrender", function(component) {
        component.getBottomToolbar().refresh.hideParent = true;
        component.getBottomToolbar().refresh.hide();
    });
    MstGrid.on("rowdblclick",function(grid, rowIndex, e){
        ModDtlGridData.load({params:{
                ReceivableId:grid.getStore().getAt(rowIndex).data.ReceivableId,
                CustomerId:grid.getStore().getAt(rowIndex).data.CustomerId
            }});
    });
    
    MstGrid.render();
    /*------DataGrid�ĺ������� End---------------*/
    /*------��ʼ��ȡ���ݵĺ��� start---------------*/
        var ModDtlGridData = new Ext.data.Store
        ({
            url: 'frmFmAccReceCheckDesk.aspx?method=getAccountNoneReceDtl',
            timeout:300000,
            reader: new Ext.data.JsonReader({
                totalProperty: 'totalProperty',
                root: 'root'
            }, [
                { name: 'OrderDtlId' },
                { name: 'OrderId' },
                { name: 'ProductId' },
                { name: 'ProductNo' },
                { name: 'ProductName' },
                { name: 'SpecificationsName' },
                { name: 'UnitName' },
                { name: 'SaleQty' },
                { name: 'SalePrice' },
                { name: 'SaleAmt' },
                { name: 'SaleTax' },
                { name: 'OutStorname' },
                { name: 'WhpId' },
                { name: 'Ext1' },
                { name: 'Ext2' },
                { name: 'TaxRate' },
                { name: 'SaleInvId' },
                { name: 'DiscountRate' },
                { name: 'DiscountAmt' },
                { name: 'TransFee' },
                { name: 'OrgId' },
                { name: 'CheckNum' },
                { name: 'CheckOldAmt' },
                { name: 'CheckAmt' },
                { name: 'SaleCheckId' },
                { name: 'SaleCheckDtlId' },
                { name: 'ObjectId' },
                { name: 'OrderNumber' },
                { name: 'CheckPrice' },
                { name: 'OperName' }
                ]),
                listeners:
	            {
	                scope: this,
	                load: function() {
	                }
	            }
        });

        /*------��ȡ���ݵĺ��� ���� End---------------*/
        function accD(arg1,arg2,pos)
        {
            //Math.round(src*Math.pow(10, pos))/Math.pow(10, pos);
            //�����������
            m = 0;
            s1=arg1.toString();
            s2=arg2.toString();
            try{m+=s1.split(".")[1].length}catch(e){}
            try{m-=s2.split(".")[1].length}catch(e){}
            var num = Number(s1.replace(".",""))/Number(s2.replace(".",""))/Math.pow(10,m);
            return Math.round(num * Math.pow(10,pos))/Math.pow(10,pos);
        }
        function accAdd(arg1,arg2){  
            var r1,r2,m;  
            try{r1=arg1.toString().split(".")[1].length}catch(e){r1=0}  
            try{r2=arg2.toString().split(".")[1].length}catch(e){r2=0}  
            m=Math.pow(10,Math.max(r1,r2))  
            return (arg1*m+arg2*m)/m  
        }  
        function accMul(arg1,arg2)
        {
            try
            {
            //�����������
            var m=0,s1=arg1.toString(),s2=arg2.toString();
            try{m+=s1.split(".")[1].length}catch(e){}
            try{m+=s2.split(".")[1].length}catch(e){}
            return Number(s1.replace(".",""))*Number(s2.replace(".",""))/Math.pow(10,m);
            }
            catch(err)
            {
                return 0;
            }
        }
        function accDiv(arg1,arg2){  
            var t1=0,t2=0,r1,r2;  
            try{t1=arg1.toString().split(".")[1].length}catch(e){}  
            try{t2=arg2.toString().split(".")[1].length}catch(e){}  
            with(Math){  
                r1=Number(arg1.toString().replace(".",""))  
                r2=Number(arg2.toString().replace(".",""))  
                return (r1/r2)*pow(10,t2-t1);  
            }  
        } 
        /*------��ʼDataGrid�ĺ��� start---------------*/
        var selectRecord = null;
        var sm = new Ext.grid.CheckboxSelectionModel({
            singleSelect: true
        });
        var ModOrderDtlGrid = new Ext.grid.EditorGridPanel({
            autoScroll: true,
            height:200,
            //autoHeight: true,
            clicksToEdit: 1,
            columnLines:true,
            width: document.body.offsetWidth,
            el:'divDoGrid',
            store: ModDtlGridData,
            //title:'������ϸ��Ϣ',
            loadMask: { msg: '���ڼ������ݣ����Ժ��' },
            sm: sm,
            cm: new Ext.grid.ColumnModel([
                sm,
                new Ext.grid.RowNumberer(), //�Զ��к�
                {
                    header: '�������',
                    dataIndex: 'OrderNumber',
                    id: 'OrderNumber',
                    width:85
                },
                {
                    header: '��Ʒ���',
                    dataIndex: 'ProductNo',
                    id: 'ProductNo',
                    width:55
                },
                {
                    header: '��Ʒ����',
                    dataIndex: 'ProductName',
                    id: 'ProductName',
                    width:120
                },
                {
                    header: '���',
                    dataIndex: 'SpecificationsName',
                    id: 'SpecificationsName',
                    width:40
                },
                {
                    header: '����',
                    dataIndex: 'SaleQty',
                    id: 'SaleQty',
                    align: 'right',
                    width:55
                },
                {
                    header: '��λ',
                    dataIndex: 'UnitName',
                    id: 'UnitName',
                    width:40
                },
                {
                    header: '����',
                    dataIndex: 'SalePrice',
                    id: 'SalePrice',
                    align: 'right',
                    width:50
                },
                {
                    header: '���',
                    dataIndex: 'SaleAmt',
                    id: 'SaleAmt',
                    align: 'right',
                    width:60
                },
//                {
//                    header: '�˷�',
//                    dataIndex: 'TransFee',
//                    id: 'TransFee',
//                    align: 'right',
//                    width:40
//                },
//                {
//                    header: '�ۿ�',
//                    dataIndex: 'DiscountAmt',
//                    id: 'DiscountAmt',
//                    align: 'right',
//                    width:40
//                },
                {
                    header: '�Ѻ˽��',
                    dataIndex: 'CheckOldAmt',
                    id: 'CheckOldAmt',
                    align: 'right',
                    width:60
                },
                {
                    header: '�������',
                    dataIndex: 'CheckAmt',
                    id: 'CheckAmt',
                    width:60,
                    align: 'right',
                    editor: new Ext.form.NumberField({ 
	                    allowBlank: false,
	                    align: 'right',
	                    decimalPrecision:6,
	                    enableKeyEvents: true,
	                    listeners: {  
    	                    'focus':function(){  
        		                this.selectText();
        		                selectRecord = ModOrderDtlGrid.getSelectionModel().getSelected(); 
    	                    },
        	                 'change': function(oppt,newv,oldv){
        	                    var record = selectRecord;
        	                    //record.set('SaleAmt', accMul(oppt.value , accAdd(record.data.SalePrice,record.data.TransFee)).toFixed(2));
                                //record.set('SaleTax', accMul(accDiv(record.data.SaleAmt,accAdd(1,record.data.Tax)) ,record.data.Tax).toFixed(2) ); //Math.Round(3.445, 1); 
                                var needcheckamt=accAdd(record.data.SaleAmt, - record.data.CheckOldAmt); 
                                var newval = newv;
                                if(newv > needcheckamt){
                                    newval = needcheckamt;
                                }
                                
                                var amt=0;var totalamt=0;
                                for(var i=0;i<MstGridData.getCount();i++){
                                    amt =  MstGridData.getAt(i).data.Ext1;  
                                    totalamt = accAdd(amt,oldv); 
                                    if(newval >totalamt){
                                        oppt.setValue(totalamt);
                                        record.set('CheckAmt',totalamt);
                                        MstGrid.getStore().getAt(i).set('Ext1',0);
                                        break;
                                    }else{
                                        amt = accAdd(totalamt,-newval);
                                        oppt.setValue(newval);
                                        record.set('CheckAmt',newval);
                                        MstGrid.getStore().getAt(i).set('Ext1',amt);
                                        break;
                                    }        
                                }
                                selectRecord = null;    
		                        ModOrderDtlGrid.getSelectionModel().selectNext(false);                           
        	                }
		                }
		            }),
	                renderer: function(v, m) {
                        m.css = 'x-grid-back-blue';
                        return v;
                    }
                },
                {
                    header: '����Ա',
                    dataIndex: 'OperName',
                    id: 'OperName',
                    width:60
                },
                {
                    header: '�ֿ�����',
                    dataIndex: 'OutStorname',
                    id: 'OutStorname',
                    width:100
                },
                {
                    header: 'savedtlid',
                    dataIndex: 'SaleCheckDtlId',
                    id: 'SaleCheckDtlId',
                    hidden:true,
                    hideable:true
                },
                {
                    header: 'saveid',
                    dataIndex: 'SaleCheckId',
                    id: 'SaleCheckId',
                    hidden:true,
                    hideable:true
                }

                ]),
            viewConfig: {
                columnsText: '��ʾ����',
                scrollOffset: 20,
                sortAscText: '����',
                sortDescText: '����',
                forceFit: false
            },
            tbar: [{
                id: 'btnALC',
                text: '�Զ�����',
                iconCls: 'add',
                icon:'../Theme/1/images/extjs/customer/edit16.gif',
                handler: function() {     
                    
                    for(var j=0;j<ModDtlGridData.getCount();j++){  
                        if( ModDtlGridData.getAt(j).data.CheckAmt>0)
                            ModOrderDtlGrid.getStore().getAt(j).set('CheckAmt',0);
                    }      
                    MstGridData.reload({
                        callback: function(r, options, success) {
                            if (Ext.getCmp('btnALC').text=='�Զ�����') 
                            {                        
                                var amt=0;var tempamt=0;
                                for(var i=0;i<MstGridData.getCount();i++){
                                    amt =  MstGridData.getAt(i).data.Ext1;
                                    for(var j=0;j<ModDtlGridData.getCount();j++){                                
                                        tempamt = ModDtlGridData.getAt(j).data.SaleAmt
                                                - ModDtlGridData.getAt(j).data.CheckOldAmt;
                                        if(tempamt>amt)
                                        {
                                            ModOrderDtlGrid.getStore().getAt(j).set('CheckAmt',amt);
                                            MstGrid.getStore().getAt(i).set('Ext1',0);
                                            amt=0;
                                            break;
                                        }
                                        else
                                        {
                                            ModOrderDtlGrid.getStore().getAt(j).set('CheckAmt',tempamt);
                                            amt = amt - tempamt;
                                            MstGrid.getStore().getAt(i).set('Ext1',amt);
                                        }
                                    }
                                }
                                Ext.getCmp('btnALC').setText('ȡ������');
                            }else{                        
                                Ext.getCmp('btnALC').setText('�Զ�����');
                            } 
                        }
                    });                           
                }
            }],
            closeAction: 'hide',
            stripeRows: true,
            loadMask: true//,
            //autoExpandColumn: 2

        });
        ModOrderDtlGrid.render();
        ModOrderDtlGrid.on('rowclick', function(grid, rowIndex, e) {
            ModOrderDtlGrid.getSelectionModel().selectRow(rowIndex,false);
        });
    /*----------------footerframe----------------*/
    //��grid��ϸ��¼��װ��json���ύ��UI��decode
    var json = '';
    var footerForm = new Ext.FormPanel({
        renderTo: 'divBotton',
        border: true, // û�б߿�
        labelAlign: 'left',
        buttonAlign: 'center',
        bodyStyle: 'padding:1px',
        height: 25,
        frame: true,
        labelWidth: 55,        
        buttons: [{
            text: "����",
            scope: this,
            id: 'saveButton',
            handler: function() {
                var json = "";
                ModDtlGridData.each(function(vc) {
                    if(vc.data.CheckAmt>0||(vc.data.CheckAmt==0&&vc.data.SaleAmt==0)){//ȫ����
                        json += Ext.util.JSON.encode(vc.data) + ',';
                    }
                });
               
                Ext.MessageBox.wait("�������ڱ��棬���Ժ򡭡�");
                //Ȼ�����������
                Ext.Ajax.request({
                    url: 'frmFmAccReceCheckDesk.aspx?method=saveCheckData',
                    method: 'POST',
                    params: {
                        //������
                        ReceivableId:ReceivableIds,
			            CustomerId:MstGridData.getAt(0).data.CustomerId,
                        //��ϸ����
                        DetailInfo: json
                    },
                    success: function(resp,opts){ 
                        Ext.MessageBox.hide();
                        if( checkParentExtMessage(resp,parent) )
                             {
                               parent.MstGridData.reload();
                               parent.ModDtlGridData.reload();
                               parent.uploadOrderWindow.hide();  
                             }
                       },
		            failure: function(resp,opts){  
		                Ext.MessageBox.hide();
		                Ext.Msg.alert("��ʾ","����ʧ��");     
		            }
                });
            }
        },{
             text: "ȡ��",
             scope: this,
             handler: function() {
                 parent.uploadOrderWindow.hide();
             }
        }]
    });    
    
    if(ReceivableIds!=""){
        //����
        MstGridData.load({params:{ReceivableIds:ReceivableIds}});
    }
});
</script>
</html>
