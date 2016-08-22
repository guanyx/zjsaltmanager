<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmSampleAuthorizeList.aspx.cs" Inherits="ZJ_frmSampleAuthorizeList" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>ί�м�����</title>
        <meta http-equiv="Content-Type" content="text/html; charset=GB2312">
    <link rel="stylesheet" type="text/css" href="../ext3/resources/css/ext-all.css" />
    <link rel="Stylesheet" type="text/css" href="../css/columnLock.css" />
    <style type="text/css">
.label-class{
                color: red;                
            }
.label-bord-class
{
	background-color:Lime;
}
</style>
	<script type="text/javascript" src="../ext3/adapter/ext/ext-base.js"></script>	
	<script type="text/javascript" src="../ext3/ext-all.js"></script>
	<script type="text/javascript" src="../js/columnLock.js"></script>
	<script type="text/javascript" src="../js/operateResp.js"></script>
	<script type="text/javascript" src="../js/FilterControl.js"></script>
	<%=getComboBoxStore() %>
</head>
<body>
<div id='toolbar'></div>
<div id='searchForm12'></div>
<div id='authorizeGridDiv'></div>
</body>

<script type="text/javascript">

           Ext.BLANK_IMAGE_URL = "../ext3/resources/images/default/s.gif"; 
           Ext.onReady(function() {
               var Toolbar = new Ext.Toolbar({
	renderTo:"toolbar",
	items:[{
		text:"����",
		icon:"../Theme/1/images/extjs/customer/add16.gif",
		handler:function(){
		        openAddAuthorizeWin();
		    }
		},'-',{
		text:"�޸�",
		icon:"../Theme/1/images/extjs/customer/edit16.gif",
		handler:function(){
		        modifyAuthorizeWin();
		    }
		},'-',{
		text:"ɾ��",
		icon:"../Theme/1/images/extjs/customer/delete16.gif",
		handler:function(){
		        deleteAuthorize();
		    }
	},'-',{
		text:"�ͼ�",
		icon:"../Theme/1/images/extjs/customer/submit.gif",
		handler:function(){
		        sendToCheck();
		    }
	},'-',{
		text:"ȡ���ͼ�",
		icon:"../Theme/1/images/extjs/customer/s_delete.gif",
		handler:function(){
		        cancleSend();
		    }
	},'-',{
		text:"�鿴",
		icon:"../Theme/1/images/extjs/customer/view16.gif",
		handler:function(){
		        modifyAuthorizeWin();
		    }
	},{
                       text: "���",
                       icon: '../Theme/1/images/extjs/customer/spellcheck.png',
                       handler: function() {
                           var optionData = authorizeGrid.getSelectionModel().getCount();
                           if (optionData == 0) {
                               Ext.Msg.alert("��ʾ", "��ѡ��Ҫ�ʼ�ļ�¼��");
                               return;
                           }
                           if (optionData > 1) {
                               Ext.Msg.alert("��ʾ", "һ��ֻ���ʼ�һ����¼��");
                               return;
                           }
                           var record = authorizeGrid.getSelectionModel().getSelections()[0].data;
//                           if (record.Status != 0 && record.Status != '0') {
//                               Ext.Msg.alert("��ʾ", "�ü�¼�Ѿ����й��ʼ죡");
//                               return;

//                           }
                           modify_quota_id = record.AuthorizeId;
                           modify_pname = record.ProductName;
                           top.createDiv(record.ProductName+"�ʼ�","/ZJ/frmQtCheckInput.aspx?FromBillType=Q1404&FromBillId="+modify_quota_id);
//                           formulaWindow.show();
//                           setformvalue(record);
//                           decodeArr(record.CheckId, record.ProductNo, record.CheckType);

                       }},'-']
});

setToolBarVisible(Toolbar);

/*------��ʼ��ȡ���ݵĺ��� start---------------*/
var authorizeData = new Ext.data.Store
({
url: 'frmSampleAuthorizeList.aspx?method=getlist&status='+status,
reader:new Ext.data.JsonReader({
	totalProperty:'totalProperty',
	root:'root'
},[
	{name:'AuthorizeId'},
	{name:'ProductId'},
	{name:'ProductName'},
	{name:'CheckOrgName'},
	{name:'ProductSpec'},
	{name:'ProductLevel'},
	{name:'ProductSupplierName'},
	{name:'ProductSupplierId'},
	{name:'ProductBrand'},
	{name:'ProductProduceDate'},
	{name:'ProductProduceEnddate'},
	{name:'SaltName'},
	{name:'LevelName'},
	{name:'SampleNo'},
	{name:'SampleOpper'},
	{name:'SampleMethod'},
	{name:'SampleAddr'},
	{name:'SampleQty'},
	{name:'SampleRepresentQty'},
	{name:'SampleType'},
	{name:'CheckOrgId'},
	{name:'AuthorizeStatus'},
	{name:'AuthorizeStatusName'},
	{name:'OrgId'},
	{name:'OrgName'},
	{name:'OperId'},
	{name:'CreateDate'},
	{name:'UpdateOper'},
	{name:'UpdateDate'}]),
	listeners:
	{
		scope:this,
		load:function(){
		}
	}
});

/*------��ȡ���ݵĺ��� ���� End---------------*/

/*------��ʼDataGrid�ĺ��� start---------------*/

var defaultPageSize = 10;
        var toolBar = new Ext.PagingToolbar({
            pageSize: 10,
            store: authorizeData,
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
        
var sm= new Ext.grid.CheckboxSelectionModel({
	singleSelect:true,width:20
});
var authorizeGrid =new Ext.ux.grid.LockingEditorGridPanel({
            el: 'authorizeGridDiv',
            width: '100%',
            height: '100%',
            //autoWidth:true,
            //autoHeight:true,
            autoScroll: true,
            layout: 'fit',
            id: 'authorizeGrid',
            store: authorizeData,
            loadMask: { msg: '���ڼ������ݣ����Ժ��' },
            sm: sm,
            columns: [
		sm,
		new Ext.grid.RowNumberer({locked:true,width:20}),
		{header:'ί��ID',width:10,dataIndex:'AuthorizeId',id:'AuthorizeId',hidden:true},
		{header:'��ƷID',width:10,dataIndex:'ProductId',	id:'ProductId',hidden:true},
		{header:'��Ʒ����',width:150,dataIndex:'ProductName',id:'ProductName',locked:true},
		{header:'���',width:80,dataIndex:'ProductSpec',id:'ProductSpec',locked:true},
		{header:'�ͺ�',width:60,dataIndex:'SaltName',id:'SaltName'},
		{header:'��װ�ȼ�',width:60,dataIndex:'LevelName',id:'LevelName'},
		{header:'��������',width:100,dataIndex:'ProductSupplierName',id:'ProductSupplierName'},
		{header:'Ʒ��',width:80,	dataIndex:'ProductBrand',id:'ProductBrand'},
		{header:'��������',	width:80,dataIndex:'ProductProduceDate',	id:'ProductProduceDate', renderer: Ext.util.Format.dateRenderer('Y��m��d��')},
//		{header:'��������1',width:80,dataIndex:'ProductProduceEnddate',id:'ProductProduceEnddate'},
		{header:'��Ʒ���',width:60,dataIndex:'SampleNo',id:'SampleNo'},
		{header:'������',width:80,dataIndex:'SampleOpper',id:'SampleOpper'},
		{header:'��������',	width:80,dataIndex:'SampleMethod',id:'SampleMethod'},
		{header:'������ַ',	width:80,dataIndex:'SampleAddr',	id:'SampleAddr'	},
		{header:'��Ʒ����',	width:80,dataIndex:'SampleQty',id:'SampleQty'},
		{header:'������(t)',width:80,dataIndex:'SampleRepresentQty',	id:'SampleRepresentQty'	},
		{header:'��Ʒ���',width:80,	dataIndex:'SampleType',	id:'SampleType'	},
		{header:'������',	width:80,dataIndex:'CheckOrgName',	id:'CheckOrgName'	},
		{header:'ί��״̬',width:60,	dataIndex:'AuthorizeStatusName',id:'AuthorizeStatusName'}],
		bbar: toolBar,
            viewConfig: {
                columnsText: '��ʾ����',
                scrollOffset: 20,
                sortAscText: '����',
                sortDescText: '����',
                forceFit: false
            },
            height: 300,
            closeAction: 'hide',
            stripeRows: true,
            loadMask: true//,
            //autoExpandColumn: 2
        });
authorizeGrid.render();

createSearch(authorizeGrid, authorizeData, "searchForm12");
searchForm.el = "searchForm12";
searchForm.render();

        this.getSelectedValue = function() {
            return "";
        }
/*------DataGrid�ĺ������� End---------------*/
if (typeof (qtAuthorizeWindow) == "undefined") {//�������2��windows����
                       var qtAuthorizeWindow = new Ext.Window({
                           title: '����ָ��ģ��',
                           modal: 'true',
                           autoWidth: true,
                           y:50,
                           autoHeight: true,
                           collapsible: true, //�Ƿ�����۵� 
                           closable: true, //�Ƿ���Թر� 
                           //maximizable : true,//�Ƿ������� 
                           closeAction: 'hide',
                           constrain: true,
                           resizable: false,
                           plain: true,
                           // ,items: addQuotaForm
                           buttons: [{
                               text: '����',
                               handler: function() {
                                qtAuthorizeWindow.hide();
                               }
                           }, {
                               text: '�ر�',
                               handler: function() {
                                   qtAuthorizeWindow.hide();
                               }
}]
                           });
                       }
/*Form *******************************************************************/
 /*------��ʼ�������ݵĴ��� Start---------------*/
if (typeof (uploadAuthorizeWindow) == "undefined") {//�������2��windows����
    uploadAuthorizeWindow = new Ext.Window({
        id: 'Authorizeformwindow',
        iconCls: 'upload-win'
        , width: 668
        , height: 380
        , plain: true
        , modal: true
        , constrain: true
        , resizable: false
        , closeAction: 'hide'
        , autoDestroy: true
        , html: '<iframe id="editIFrame" width="100%" height="100%" border=0 src=""></iframe>' 
        
    });
}
uploadAuthorizeWindow.addListener("hide", function() {
   //document.getElementById("editIFrame").src = "frmOrderDtl.aspx?OpenType=oper&id=0";//��������ݣ���������ҳ���ṩһ������������
});

function openAddAuthorizeWin() {

    uploadAuthorizeWindow.show();
    if(document.getElementById("editIFrame").src.indexOf("frmSampleAuthorizeInput")==-1)
    {                
        document.getElementById("editIFrame").src = "frmSampleAuthorizeInput.aspx?OpenType=oper&id=0" ;
    }
    else{
        document.getElementById("editIFrame").contentWindow.AuthorizeId=0;
        document.getElementById("editIFrame").contentWindow.fromBillType="";
        document.getElementById("editIFrame").contentWindow.setAuthorizeFormValue();
        document.getElementById("editIFrame").contentWindow.OpenType='oper';
    }
}

/*-----�༭Orderʵ���ര�庯��----*/
            function modifyAuthorizeWin() {
                var sm = authorizeGrid.getSelectionModel();
                //��ѡ
                var selectData = sm.getSelections();                
                var array = new Array(selectData.length);
                var status = 1;
                for(var i=0;i<selectData.length;i++)
                {
                    array[i] = selectData[i].get('AuthorizefId');
//                    status = selectData[i].get('Status');
                }

                //���û��ѡ�񣬾���ʾ��Ҫѡ��������Ϣ
                if (selectData == null || selectData == "") {
                    Ext.Msg.alert("��ʾ", "��ѡ����Ҫ�����ļ�¼��");
                    return;
                }
                
                if (array.length != 1) {
                    Ext.Msg.alert("��ʾ", "��ѡ��һ����¼��");
                    return;
                }
                //��ui-check
//                if (status != 1)
//                {
//                    Ext.Msg.alert("��ʾ", "������������ѳ��⣬�������޸ģ�");
//                    return;
//                }
                
                
                uploadAuthorizeWindow.show();
                if(document.getElementById("editIFrame").src.indexOf("frmSampleAuthorizeInput")==-1)
                {                
                    document.getElementById("editIFrame").src = "frmSampleAuthorizeInput.aspx?OpenType=oper&id=" + selectData[0].data.AuthorizeId;
                }
                else{
                    document.getElementById("editIFrame").contentWindow.AuthorizeId=selectData[0].data.AuthorizeId;
                    document.getElementById("editIFrame").contentWindow.setAuthorizeFormValue();
                    document.getElementById("editIFrame").contentWindow.OpenType='oper';
                }
            }
            
            function deleteAuthorize()
            {
                var sm = authorizeGrid.getSelectionModel();
                //��ѡ
                var selectData = sm.getSelections();                
                var array = new Array(selectData.length);
                var status = 1;
                for(var i=0;i<selectData.length;i++)
                {
                    array[i] = selectData[i].get('AuthorizefId');
//                    status = selectData[i].get('Status');
                }

                //���û��ѡ�񣬾���ʾ��Ҫѡ��������Ϣ
                if (selectData == null || selectData == "") {
                    Ext.Msg.alert("��ʾ", "��ѡ����Ҫ�����ļ�¼��");
                    return;
                }
                
                if (array.length != 1) {
                    Ext.Msg.alert("��ʾ", "��ѡ��һ����¼��");
                    return;
                }
                //ɾ��ǰ�ٴ������Ƿ����Ҫɾ��
	            Ext.Msg.confirm("��ʾ��Ϣ","�Ƿ����Ҫɾ��ѡ���ί����Ϣ��",function callBack(id){
		            //�ж��Ƿ�ɾ������
		            if(id=="yes")
		            {
                            Ext.Ajax.request({
                                url: 'frmSampleAuthorizeInput.aspx?method=del',
                                params: {
                                    AuthorizeId:selectData[0].data.AuthorizeId},
                                success: function(resp, opts) {  
                                    var resu = Ext.decode(resp.responseText);
                                        Ext.Msg.alert('ϵͳ��ʾ',resu.errorinfo);
                                        authorizeData.reload();
                                },
                                failure: function(resp, opts) {
                                    Ext.Msg.alert("��ʾ", "ί����Ϣɾ��ʧ�ܣ�");
                                }});
                   }});
            }
   
   function cancleSend()
   {
        var sm = authorizeGrid.getSelectionModel();
        //��ѡ
        var selectData = sm.getSelections();                
        
        //���û��ѡ�񣬾���ʾ��Ҫѡ��������Ϣ
        if (selectData == null || selectData == "") {
            Ext.Msg.alert("��ʾ", "��ѡ����Ҫ�����ļ�¼��");
            return;
        }
        
        if (selectData.length != 1) {
            Ext.Msg.alert("��ʾ", "��ѡ��һ����¼��");
            return;
        }
        Ext.Msg.confirm("��ʾ��Ϣ","�Ƿ����Ҫ��ѡ���ί����Ϣȡ���ͼ죿",function callBack(id){
		    //�ж��Ƿ�ɾ������
		    if(id=="yes")
		    {
                    Ext.Ajax.request({
                        url: 'frmSampleAuthorizeList.aspx?method=cancleSend',
                        params: {
                            AuthorizeId:selectData[0].data.AuthorizeId},
                        success: function(resp, opts) {  
                            var resu = Ext.decode(resp.responseText);
                                Ext.Msg.alert('ϵͳ��ʾ',resu.errorinfo);
                                authorizeData.reload();
                        },
                        failure: function(resp, opts) {
                            Ext.Msg.alert("��ʾ", "ί����Ϣ�ͼ�ȡ��ʧ�ܣ�");
                        }});
            }});
   }
   function sendToCheck()
   {
        var sm = authorizeGrid.getSelectionModel();
        //��ѡ
        var selectData = sm.getSelections();                
        
        //���û��ѡ�񣬾���ʾ��Ҫѡ��������Ϣ
        if (selectData == null || selectData == "") {
            Ext.Msg.alert("��ʾ", "��ѡ����Ҫ�����ļ�¼��");
            return;
        }
        
        if (selectData.length != 1) {
            Ext.Msg.alert("��ʾ", "��ѡ��һ����¼��");
            return;
        }
        Ext.Msg.confirm("��ʾ��Ϣ","�Ƿ����Ҫ��ѡ���ί����Ϣ�ͼ죿",function callBack(id){
		    //�ж��Ƿ�ɾ������
		    if(id=="yes")
		    {
                    Ext.Ajax.request({
                        url: 'frmSampleAuthorizeList.aspx?method=sendToCheck',
                        params: {
                            AuthorizeId:selectData[0].data.AuthorizeId},
                        success: function(resp, opts) {  
                            var resu = Ext.decode(resp.responseText);
                                Ext.Msg.alert('ϵͳ��ʾ',resu.errorinfo);
                                authorizeData.reload();
                        },
                        failure: function(resp, opts) {
                            Ext.Msg.alert("��ʾ", "ί����Ϣ����ʧ�ܣ�");
                        }});
            }});
       }
/*��ȡ������Ϣ*/
loadData();
        
            function loadData() {
            authorizeData.load({ params: { limit: defaultPageSize, start: 0} });
        }             
                
})
function getCmbStore(columnName) {

}
</script>
</html>
