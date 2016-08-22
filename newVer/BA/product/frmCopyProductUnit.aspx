<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmCopyProductUnit.aspx.cs" Inherits="BA_product_frmCopyProductUnit" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>����ҳ��</title><meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<link rel="stylesheet" type="text/css" href="../../ext3/resources/css/ext-all.css" />
<script type="text/javascript" src="../../ext3/adapter/ext/ext-base.js"></script>
<script type="text/javascript" src="../../ext3/ext-all.js"></script>
<script type="text/javascript" src="../../js/ProductSelect.js"></script>
<script type="text/javascript" src="../../js/operateResp.js"></script>
</head>
<%=getComboBoxStore()%>
<script type="text/javascript">


parentUrl="../../CRM/product/frmBaProductClass.aspx?method=getbaproducttree";
var unitConvertGridData=null;
var selectedIds = "";
function loadData(){

    unitConvertGridData.baseParams.ProductId=productId;
    unitConvertGridData.load({params:{limit:10,start:0}});
    selectedIds="";
    clearAllSelected();
    Ext.getCmp("ProductNames").setValue("");
    
}

Ext.onReady(function(){
Ext.BLANK_IMAGE_URL = "../../ext3/resources/images/default/s.gif";
/*------ʵ��toolbar�ĺ��� start---------------*/
var Toolbar = new Ext.Toolbar({
	renderTo:"toolbar",
	items:[{
		text:"����",
		icon:"images/extjs/customer/add16.gif",
		handler:function(){
		        copyUnits();
		    }
		}]
});

function getSelectedUnitConverts()
{
    var sm = Ext.getCmp('unitConvertGrid').getSelectionModel();
                    //��ȡѡ���������Ϣ
    var selectData = sm.getSelections();
    var ids="";
    for(var i=0;i<selectData.length;i++)
    {
        if(ids.length>0)
            ids+=",";
        ids+=selectData[i].get("UnitConversionId");
    }
    return ids;
}
function copyUnits(){
    var ids = getSelectedUnitConverts();
    if(ids=="")
    {
        Ext.Msg.alert("ϵͳ��ʾ","����ѡ����Ҫ���Ƶĵ�λת����Ϣ��");
        return;
    }
    if(selectedIds=="")
    {
        Ext.Msg.alert("ϵͳ��ʾ","����ѡ����Ҫ���ƵĲ�Ʒ��Ϣ��");
        return;
    }
    Ext.Ajax.request({
        url: 'frmCopyProductUnit.aspx?method=copyunit',
        method: 'POST',
        params: {
            productIds:selectedIds,
            unitConvertIds:ids
        },
        success: function(resp, opts) {
           if(checkParentExtMessage(resp,parent))
           {
                parent.copyProductUnitWin.hide();
           }
        },
        failure: function(resp, opts) {
            Ext.Msg.alert("��ʾ", "����ʧ��");
        }
    });
}
/*------ʵ��FormPanle�ĺ��� start---------------*/
var sss=new Ext.form.FormPanel({
	url:'',
	renderTo:'divForm',
	frame:true,
	title:'',
	items:[
		{
			xtype:'textfield',
			fieldLabel:'��Ҫ���ƵĴ��',
			columnWidth:1,
			anchor:'90%',
			name:'ProductNames',
			id:'ProductNames'
		}
]
});

Ext.getCmp("ProductNames").on("focus",selectProducts);
function selectProducts(v)
{
    if(selectProductForm==null)
    {
        showProductForm("", "", "", true); //��ʾ�����ڴ���
        Ext.getCmp("btnYes").on("click",selectOK);
    }
    else
    {
        showProductForm("", "", "", true);
    }
}


function selectOK()
{
    var selectNodes = selectProductTree.getChecked();
    if(selectNodes.length>0)
    {
        var text="";
        selectedIds="";
        for(var i=0;i<selectNodes.length;i++){
            if(text.length>0){
                text+=",";
                selectedIds+=",";
            }
            text+=selectNodes[i].text;
            selectedIds+=selectNodes[i].id;
        }
        Ext.getCmp("ProductNames").setValue(text);
    }
}

/*------FormPanle�ĺ������� End---------------*/
unitConvertGridData = new Ext.data.Store
({
    url: 'frmBaProductUnitConvert.aspx?method=getUnitCovertList',
    reader: new Ext.data.JsonReader({
        totalProperty: 'totalProperty',
        root: 'root'
    }, [
	{
	    name: 'UnitConversionId'
	},
	{
	    name: 'ProductId'
	},
	{
	    name: 'ProductName'
	},
	{
	    name: 'SourceUnitId'
	},
	{
	    name: 'SourceUnitText'
	},
	{
	    name: 'SpecificationsText'
	},
	{
	    name: 'DecUnitId'
	},
	{
	    name: 'DecUnitText'
	},
	{
	    name: 'ReplacedValue'
	},
	{
	    name: 'Remark'
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

            var sm = new Ext.grid.CheckboxSelectionModel({
                singleSelect: false
            });
            var unitConvertGrid = new Ext.grid.GridPanel({
                el: 'unitConvertGrid',
                width: '100%',
                height: '100%',
                autoWidth: true,
                autoHeight: true,
                autoScroll: true,
                layout: 'fit',
                id: 'unitConvertGrid',
                store: unitConvertGridData,
                loadMask: { msg: '���ڼ������ݣ����Ժ��' },
                sm: sm,
                cm: new Ext.grid.ColumnModel([
		sm,
		new Ext.grid.RowNumberer(), //�Զ��к�
		{
		header: '��λ����ID',
		dataIndex: 'UnitConversionId',
		id: 'UnitConversionId'
		    , hidden: true
		    , hideable: true
},
		{
		    header: '��ƷID',
		    dataIndex: 'ProductId',
		    id: 'ProductId'
		    , hidden: true
		    , hideable: true
		},
		{
		    header: '��Ʒ����',
		    dataIndex: 'ProductName',
		    id: 'ProductName'
		},
		{
		    header: '���㵥λ',
		    dataIndex: 'SourceUnitId',
		    id: 'SourceUnitId'
		    , hidden: true
		    , hideable: true
		},
		{
		    header: '���㵥λ',
		    dataIndex: 'SourceUnitText',
		    id: 'SourceUnitText'
		},
		{
		    header: '�����ɵ�λ',
		    dataIndex: 'DecUnitId',
		    id: 'DecUnitId'
		    , hidden: true
		    , hideable: true
		},
		{
		    header: '�����ɵ�λ',
		    dataIndex: 'DecUnitText',
		    id: 'DecUnitText'
		},
		{
		    header: '���',
		    dataIndex: 'SpecificationsText',
		    id: 'SpecificationsText'
		},
		{
		    header: '���ɵ�λֵ',
		    dataIndex: 'ReplacedValue',
		    id: 'ReplacedValue'
		},
		{
		    header: '��ע',
		    dataIndex: 'Remark',
		    id: 'Remark'
}]),
                bbar: new Ext.PagingToolbar({
                    pageSize: 10,
                    store: unitConvertGridData,
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
            unitConvertGrid.render();
            
            loadData();
})
</script>
<body>
<div id='toolbar'></div>
<div id='divForm'></div>
<div id='unitConvertGrid'></div>

</body>
</html>
