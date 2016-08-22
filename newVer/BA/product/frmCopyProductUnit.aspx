<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmCopyProductUnit.aspx.cs" Inherits="BA_product_frmCopyProductUnit" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>测试页面</title><meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
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
/*------实现toolbar的函数 start---------------*/
var Toolbar = new Ext.Toolbar({
	renderTo:"toolbar",
	items:[{
		text:"复制",
		icon:"images/extjs/customer/add16.gif",
		handler:function(){
		        copyUnits();
		    }
		}]
});

function getSelectedUnitConverts()
{
    var sm = Ext.getCmp('unitConvertGrid').getSelectionModel();
                    //获取选择的数据信息
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
        Ext.Msg.alert("系统提示","请先选择需要复制的单位转换信息！");
        return;
    }
    if(selectedIds=="")
    {
        Ext.Msg.alert("系统提示","请先选择需要复制的产品信息！");
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
            Ext.Msg.alert("提示", "禁用失败");
        }
    });
}
/*------实现FormPanle的函数 start---------------*/
var sss=new Ext.form.FormPanel({
	url:'',
	renderTo:'divForm',
	frame:true,
	title:'',
	items:[
		{
			xtype:'textfield',
			fieldLabel:'需要复制的存货',
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
        showProductForm("", "", "", true); //显示表单所在窗体
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

/*------FormPanle的函数结束 End---------------*/
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

            /*------获取数据的函数 结束 End---------------*/

            /*------开始DataGrid的函数 start---------------*/

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
                loadMask: { msg: '正在加载数据，请稍侯……' },
                sm: sm,
                cm: new Ext.grid.ColumnModel([
		sm,
		new Ext.grid.RowNumberer(), //自动行号
		{
		header: '单位换算ID',
		dataIndex: 'UnitConversionId',
		id: 'UnitConversionId'
		    , hidden: true
		    , hideable: true
},
		{
		    header: '商品ID',
		    dataIndex: 'ProductId',
		    id: 'ProductId'
		    , hidden: true
		    , hideable: true
		},
		{
		    header: '商品名称',
		    dataIndex: 'ProductName',
		    id: 'ProductName'
		},
		{
		    header: '换算单位',
		    dataIndex: 'SourceUnitId',
		    id: 'SourceUnitId'
		    , hidden: true
		    , hideable: true
		},
		{
		    header: '换算单位',
		    dataIndex: 'SourceUnitText',
		    id: 'SourceUnitText'
		},
		{
		    header: '被换成单位',
		    dataIndex: 'DecUnitId',
		    id: 'DecUnitId'
		    , hidden: true
		    , hideable: true
		},
		{
		    header: '被换成单位',
		    dataIndex: 'DecUnitText',
		    id: 'DecUnitText'
		},
		{
		    header: '规格',
		    dataIndex: 'SpecificationsText',
		    id: 'SpecificationsText'
		},
		{
		    header: '换成单位值',
		    dataIndex: 'ReplacedValue',
		    id: 'ReplacedValue'
		},
		{
		    header: '备注',
		    dataIndex: 'Remark',
		    id: 'Remark'
}]),
                bbar: new Ext.PagingToolbar({
                    pageSize: 10,
                    store: unitConvertGridData,
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
