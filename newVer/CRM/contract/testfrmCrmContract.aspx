<%@ Page Language="C#" AutoEventWireup="true" CodeFile="testfrmCrmContract.aspx.cs" Inherits="CRM_Contract_frmCrmContract" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html>
<head>
<title>����ҳ��</title><meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<link rel="stylesheet" type="text/css" href="../../ext3/resources/css/ext-all.css" />
<script type="text/javascript" src="../../ext3/adapter/ext/ext-base.js"></script>
<script type="text/javascript" src="../../ext3/ext-all.js"></script>
<link rel="stylesheet" type="text/css" href="../../ext3/example/file-upload.css" />
<script type="text/javascript" src="../../ext3/example/FileUploadField.js"></script>
</head>
<body>
<div id='toolbar'></div>
<div id='searchForm'></div>
<div id='contractGrid'></div>

</body>

<%= getComboBoxStore() %>

<script type="text/javascript">
Ext.BLANK_IMAGE_URL = "../../ext3/resources/images/default/s.gif";
    Ext.onReady(function() {
    var saveType;
        /*------ʵ��toolbar�ĺ��� start---------------*/
        var Toolbar = new Ext.Toolbar({
            renderTo: "toolbar",
            items: [{
                text: "����",
                icon: "../../Theme/1/images/extjs/customer/add16.gif",
                handler: function() { 
                    var sm = contractGrid.getSelectionModel();
                    //��ȡѡ���������Ϣ
                    var selectData = sm.getSelected();
                    //���û��ѡ�񣬾���ʾ��Ҫѡ��������Ϣ
                    if (selectData == null) {
                        Ext.Msg.alert("��ʾ", "��ѡ����Ҫ�鿴����Ϣ��");
                        return;
                    }
                    selectData.data.RecStatus='add';
                }
            }, '-', {
                text: "�༭",
                icon: "../../Theme/1/images/extjs/customer/edit16.gif",
                handler: function() { 
                    var sm = contractGrid.getSelectionModel();
                    //��ȡѡ���������Ϣ
                    var selectData = sm.getSelected();
                    //���û��ѡ�񣬾���ʾ��Ҫѡ��������Ϣ
                    if (selectData == null) {
                        Ext.Msg.alert("��ʾ", "��ѡ����Ҫ�鿴����Ϣ��");
                        return;
                    }
                    selectData.data.RecStatus='edit2';
                }
            }, '-', {
                text: "ɾ��",
                icon: "../../Theme/1/images/extjs/customer/delete16.gif",
                handler: function() {
                    var sm = contractGrid.getSelectionModel();
                    //��ȡѡ���������Ϣ
                    var selectData = sm.getSelected();
                    //���û��ѡ�񣬾���ʾ��Ҫѡ��������Ϣ
                    if (selectData == null) {
                        Ext.Msg.alert("��ʾ", "��ѡ����Ҫ�鿴����Ϣ��");
                        return;
                    }
                    selectData.data.RecStatus='del';
                
                 }
            },  '-',{
                text: "�鿴����",
                icon: "../../Theme/1/images/extjs/customer/delete16.gif",
                handler: function() {
                    json = "";
                        contractGridData.each(function(contractGridData) {
                            json += Ext.util.JSON.encode(contractGridData.data) + ',';
                        });
                    json = json.substring(0, json.length - 1);
                    alert(json);
                    
                    contractGridData.filterBy(function(record) {
                        return record.get('RecStatus') != 'del';
                    });
                    
                    //store.clearFilter();
                }
}]
            });
            

            /*------����toolbar�ĺ��� end---------------*/

            // ����һ���û�����,�����������Ƕ�̬����Ӽ�¼,��ȻҲ�������ó��������ö���
            var Contract = Ext.data.Record.create([
                   // ����� "name" ƥ������ı�ǩ����, ���� "birthDay",����ӳ�䵽��ǩ "birth"
                   {name: 'ContractId', type: 'int' },
                   {name: 'ContractNo', type: 'string'},
                   {name: 'ContractType', type: 'int'},
                   {name: 'ContractName', type: 'string'},
                   {name: 'Singer', type: 'string'},
                   {name: 'ContractSecond', type: 'string'},     
                   {name: 'ContractSum', type: 'int'},           
                   {name: 'ContractDate', mapping: 'ContractDate', type: 'date', dateFormat: 'Y/m/d'},
                   {name: 'State', type: 'int'}
              ]); 



            /*------��ʼToolBar�¼����� start---------------*//*-----����Contractʵ���ര�庯��----*/
            function openAddContractWin() {
                
            }
            /*-----�༭Contractʵ���ര�庯��----*/
            function modifyContractWin() {
               
            }
            /*-----ɾ��Contractʵ�庯��----*/
            /*ɾ����Ϣ*/
            function deleteContract() {
               
            }
            function viewContractAttach(){
                
            }

         // 13388615939

/*------�����ѯform end ----------------*/



            /*------��ʼ��ȡ���ݵĺ��� start---------------*/
            var contractGridData = new Ext.data.Store
({
    url: 'frmCrmContract.aspx?method=getContractList',
    reader: new Ext.data.JsonReader({
        totalProperty: 'totalProperty',
        root: 'root'
    }, [
	{
	    name: 'ContractId'
	},
	{
	    name: 'ContractNo'
	},
	{
	    name: 'ContractName'
	},
	{
	    name: 'ContractType'
	},
	{
	    name: 'ContractDate'
	},
	{
	    name: 'Singer'
	},
	{
	    name: 'ContractSecond'
	},
	{
	    name: 'ContractSum'
	},
	{
	    name: 'ContractContent'
	},
	{
	    name: 'ContarctAttach'
	},
	{
	    name: 'State'
	},
	{
	    name: 'CreateDate'
	},
	{
	    name: 'UpdateDate'
	},
	{
	    name: 'OwenId'
	},
	{
	    name: 'OwenOrgId'
	},
	{
	    name: 'OperId'
	},
	{
	    name: 'RecStatus'
	},
	{
	    name: 'OrgId'
}])
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
            var fm = Ext.form;
            var sm = new Ext.grid.CheckboxSelectionModel({
                singleSelect: true
            });
            var contractGrid = new Ext.grid.EditorGridPanel({
                el: 'contractGrid',
                width: '100%',
                height: '100%',
                autoWidth: true,
                autoHeight: true,
                autoScroll: true,
                layout: 'fit',
                clicksToEdit:1,
                id: '',
                store: contractGridData,
                loadMask: { msg: '���ڼ������ݣ����Ժ��' },
                sm: sm,
                cm: new Ext.grid.ColumnModel([
		sm,
		new Ext.grid.RowNumberer(), //�Զ��к�
		{
		    header: '��ͬID',
		    dataIndex: 'ContractId',
		    id: 'ContractId',
			hidden: true,
            hideable: false		
},
		{
		    header: '��ͬ���',
		    dataIndex: 'ContractNo',
		    id: 'ContractNo',
            editor: new fm.TextField({
               allowBlank: true
           }) 
		},
		{
		    header: '��ͬ����	',
		    dataIndex: 'ContractName',
		    id: 'ContractName',
            editor: new fm.TextField({
               allowBlank: true
           }) 
		},
		{
		    header: '��ͬ����',
		    dataIndex: 'ContractType',
		    id: 'ContractType',
            editor: new fm.TextField({
               allowBlank: true
           }) 
		},
		{
		    header: '��ͬʱ��',
		    dataIndex: 'ContractDate',
		    id: 'ContractDate',
            editor: new fm.TextField({
               allowBlank: true
           }) 
		},
		{
		    header: 'ǩ����',
		    dataIndex: 'Singer',
		    id: 'Singer',
            editor: new fm.TextField({
               allowBlank: true
           }) 
		},
		{
		    header: '��ͬ�ҷ�',
		    dataIndex: 'ContractSecond',
		    id: 'ContractSecond',
            editor: new fm.TextField({
               allowBlank: true
           }) 
		},
		{
		    header: '��ͬ���',
		    dataIndex: 'ContractSum',
		    id: 'ContractSum',
            editor: new fm.TextField({
               allowBlank: true
           }) 
		},
		{
		    header: '��¼״̬',
		    dataIndex: 'RecStatus',
		    id: 'RecStatus',
            hidden:true,
            hideable:false
		},
		{
		    header: '��ͬ״̬',
		    dataIndex: 'State',
		    id: 'State',
            editor: new fm.TextField({
               allowBlank: true
           }) 
		
}]),
                bbar: new Ext.PagingToolbar({
                    pageSize: 10,
                    store: contractGridData,
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
            contractGrid.render();
            /*------DataGrid�ĺ������� End---------------*/

            contractGridData.load({
                                params : {
                                start : 0,
                                limit : 10
                                } 
            }); 
            
            
            // ��Ԫ��༭���¼�����
    contractGrid.on("afteredit", afterEdit, contractGrid);
    // �¼�������
    function afterEdit(e) {
        var record = e.record;// ���༭�ļ�¼
        e.record.data.RecStatus='edit';
        // ��ʾ�ȴ��Ի���
        Ext.Msg.wait("��Ⱥ�", "�޸���", "����������...");

          // ���½���, ������ɾ������
            Ext.Msg.alert('���ɹ��޸����û���Ϣ', "���޸ĵ��û���:" + e.record.get("ContractName") + "\n �޸ĵ��ֶ���:"
            + e.field);// ȡ���û���
    };
    


        })
</script>

</html>

