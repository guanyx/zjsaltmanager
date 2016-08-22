<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmReportQuota.aspx.cs" Inherits="ZJ_frmReportQuota" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>�ޱ���ҳ</title>
<meta http-equiv="Content-Type" content="text/html; charset=GB2312">
    <link rel="stylesheet" type="text/css" href="../ext3/resources/css/ext-all.css" />
	<script type="text/javascript" src="../ext3/adapter/ext/ext-base.js"></script>	
	<script type="text/javascript" src="../ext3/ext-all.js"></script>
	<script type="text/javascript" src="../js/FilterControl.js"></script>
	<script type="text/javascript" src="../js/operateResp.js"></script>    
	<%=getComboBoxStore() %>
</head>
<body>
	<div id="quota_toolbar"></div>
	 <div id="searchForm"></div>
	 <div id="quota_grid"></div>
</body>
<script>
var quotaCount;
           var quotaArr = new Array();
var modify_quota_id = 'none';
var addmark = 0;
var quotaListStore;
Ext.BLANK_IMAGE_URL = "../ext3/resources/images/default/s.gif";
Ext.onReady(function() {
   var Toolbar = new Ext.Toolbar({
       renderTo: "quota_toolbar",
       items: [{
           id:'distBtn',
           text: "ɾ��",
           icon: '../Theme/1/images/extjs/customer/add16.gif',
           handler: function() {
              delQuotas();
           }
        }]
    });
    
    function delQuotas()
    {
        var sm = quotaGrid.getSelectionModel();
            //��ȡѡ���������Ϣ
            var selectData = sm.getSelections();
            var ids = "";
            for (var i = 0; i < selectData.length; i++) {
                if (ids.length > 0)
                    ids += ",";
                ids += selectData[i].get("QuotaNo");
            }
            if(ids.length==0)
            {
                Ext.Msg.alert("ϵͳ��ʾ","��ѡ����Ҫ��ӵ�ָ����Ϣ��")
                return;
            }
             //ɾ��ǰ�ٴ������Ƿ����Ҫɾ��
            Ext.Msg.confirm("��ʾ��Ϣ", "�Ƿ����Ҫɾ��ѡ��ļ����Ϣ��", function callBack(id) {
                //�ж��Ƿ�ɾ������
                if (id == "yes") {
                        Ext.Ajax.request({
                            url: 'frmReportQuota.aspx?method=del',
                            method: 'POST',
                            params: {
                                QuotaNo: ids
                            },
                            success: function(resp, opts) {
                                if (checkExtMessage(resp)) {
                                    quotaListStore.reload();
                                }

                            }
                     , failure: function(resp, opts) {
                         Ext.MessageBox.hide();
                         Ext.Msg.alert("��ʾ", "����ʧ��");

                     }
                    });
            }});
    }
    
   quotaListStore = new Ext.data.Store
	({
	    url: 'frmReportQuota.aspx?method=getlist',
	    reader: new Ext.data.JsonReader({
	        totalProperty: 'totalProperty',
	        root: 'root'
	    }, [
	    { name: 'QuotaNo' },
        { name: 'QuotaName' },
        { name: 'QuotaAlias' },
	    { name: 'QuotaUnit' },
        { name: 'QuotaType' },
        { name: 'ItemType' },
        //{ name: 'QuotaTypeName'},
        {name: 'ControlType' },
        { name: 'DicsName' },
        //{ name: 'ControlTypeName'},
	    { name: 'SortId'},
        { name: 'CreateDate'},
	    { name: 'OperName' },
	     { name: 'EmpName' }
	    ]),
	    listeners:
	      {
	          scope: this,
	          load: function() {
	              //���ݼ���Ԥ����,������һЩ�ϲ�����ʽ����Ȳ���
	          }
	      }
	});
	
	 var defaultPageSize = 10;
        var toolBar = new Ext.PagingToolbar({
            pageSize: 10,
            store: quotaListStore,
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
        
    var sm = new Ext.grid.CheckboxSelectionModel(
    {        singleSelect: false    } );
   var quotaGrid = new Ext.grid.GridPanel({
       el: 'quota_grid',
       width: '100%',
       height: '100%',
       autoWidth: true,
       autoHeight: true,
       autoScroll: true,
       layout: 'fit',
       id: 'customerdatagrid',
       store: quotaListStore,
       loadMask: { msg: '���ڼ������ݣ����Ժ��' },
       sm: sm,
       /*  ����м�û�в�ѯ����form��ô����ֱ����tbar��ʵ����ɾ��
       tbar:[{
       text:"���",
       handler:this.showAdd,
       scope:this
       },"-",
       {
       text:"�޸�"
       },"-",{
       text:"ɾ��",
       handler:this.deleteBranch,
       scope:this
       }],
       */
       cm: new Ext.grid.ColumnModel([
        sm,
        new Ext.grid.RowNumberer(), //�Զ��к�
        { header: 'ָ���', hidden: true, dataIndex: 'QuotaNo' },
        { header: 'ָ������', dataIndex: 'QuotaName' },
        { header: 'ָ�����', hidden: true, dataIndex: 'QuotaAlias' },
        { header: '��λ', dataIndex: 'QuotaUnit' },
		{ header: 'ָ�����', dataIndex: 'QuotaType', hidden: true },
		{ header: 'ָ��������', dataIndex: 'ItemType', hidden: true },
		//{ header: 'ָ������', dataIndex: 'QuotaTypeName' },
		{ header: '�ؼ�����', dataIndex: 'ControlType' ,hidden: true },
		{ header: '�ؼ�����', dataIndex: 'DicsName' },
		{ header: '�����', dataIndex: 'SortId' },
		{ header: '��������', dataIndex: 'CreateDate' },
		{ header: '������', dataIndex: 'EmpName' }
	]), 
	listeners:
	{
	      rowselect: function(sm, rowIndex, record) {
	          //��ѡ��
	          //Ext.MessageBox.alert("��ʾ","��ѡ��ĳ�����ǣ�" + r.data.ASIN);
	      },
	      rowclick: function(grid, rowIndex, e) {
	          //˫���¼�
	      },
	      rowdbclick: function(grid, rowIndex, e) {
	          //˫���¼�
	      },
	      cellclick: function(grid, rowIndex, columnIndex, e) {
	          //��Ԫ�񵥻��¼�			           
	      },
	      celldbclick: function(grid, rowIndex, columnIndex, e) {
	          //��Ԫ��˫���¼�
	          /*
	          var record = grid.getStore().getAt(rowIndex); //Get the Record
	          var fieldName = grid.getColumnModel().getDataIndex(columnIndex); //Get field name
	          var data = record.get(fieldName);
	          Ext.MessageBox.alert('show','��ǰѡ�е�������'+data); 
	          */
	      }
	  },
       bbar:toolBar,
       viewConfig: {
           columnsText: '��ʾ����',
           scrollOffset: 20,
           sortAscText: '����',
           sortDescText: '����',
           forceFit: true
       },
       //width: 750, 
       height: 265,
       closeAction: 'hide',

       stripeRows: true,
       loadMask: true,
       autoExpandColumn: 2
   });
   createSearch(quotaGrid, quotaListStore, "searchForm");
    searchForm.el = "searchForm";
    searchForm.render();
   quotaGrid.render();
   
   loadData();
}); 
function loadData() {
        quotaListStore.baseParams.QtReportQuotaNo = pkId;
        
        quotaListStore.load({ params: { limit: defaultPageSize, start: 0} });
    }
    function getCmbStore(columnName) {

}
		
	</script>
</html>
