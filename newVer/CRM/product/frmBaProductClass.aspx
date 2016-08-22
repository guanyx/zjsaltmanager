<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmBaProductClass.aspx.cs" Inherits="CRM_product_frmBaProductClass" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>���������Ʒ��Ӧ��ϵά��</title>
    <meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
    <link rel="stylesheet" type="text/css" href="../../ext3/resources/css/ext-all.css" />
	<script type="text/javascript" src="../../ext3/adapter/ext/ext-base.js"></script>	
	<script type="text/javascript" src="../../ext3/ext-all.js"></script>
	<script type="text/javascript" src="../../js/operateResp.js"></script>
</head>
<body>
   <div id ='tree-div'></div>
   <div id ='toolbar'></div>
   <div id ='sdetailGridPanel'></div>
</body>
<script type="text/javascript">
Ext.onReady(function(){
var currentNodeId = 0;
var isPlanType=0;//�������
/*------ʵ��tree�ĺ��� start---------------*/
    Ext.BLANK_IMAGE_URL = "../../ext3/resources/images/default/s.gif";	
    var Tree = Ext.tree;
    var mytree = new Tree.TreePanel({
        el:'tree-div',
        useArrows:true,
        autoScroll:true,
        animate:true,
        autoWidth:true,
        autoHeight:true,
        enableDD:false,
        containerScroll: true, 
        loader: new Tree.TreeLoader({
           dataUrl:'frmBaProductClass.aspx?method=gettreelist',
           baseParams:{
                isPlanType:isPlanType,
                isAll:false
           }})
    });
    mytree.on('click',function(node){  
        if(node.id ==0)
            return;
         refreshGrid(node.id);  
    }); 
    // set the root node
    var root = new Tree.AsyncTreeNode({
        text: '�������',
        draggable:false,
        id:'0'
    });
    mytree.setRootNode(root);

    // render the tree
    mytree.render();
    root.expand();
    /*------����tree�ĺ��� end---------------*/

function refreshGrid(nodeId){
    currentNodeId = nodeId;
    productClassGrid.getStore().baseParams.ClassId= currentNodeId;
    productClassGrid.getStore().load({
        params:{
	           ClassId:currentNodeId,
	           start : 0,
               limit : 10
	        }
    });
}

/*------viewreport���� start---------------*/

/*------��ʼDataGrid�ĺ��� start---------------*/
var productClassGridData;
if(productClassGridData==null){
    productClassGridData = new Ext.data.Store({
        url:"frmBaProductClass.aspx?method=getClassProducts",
        reader:new Ext.data.JsonReader({
            totalProperty:'totalProperty',
	        root:'root'},
	        [
	            {
		            name:'ProductDtlId'
	            },
	            {
		            name:'ProductNo'
	            },
	            {
		            name:'ProductName'
	            },
	            {
		            name:'ClassId'
	            }
	        ])      
    });
}

var sm= new Ext.grid.CheckboxSelectionModel({
	singleSelect:false
});
var productClassGrid = new Ext.grid.GridPanel({
	el: 'sdetailGridPanel',
	width:'100%',
	height:'100%',
	autoWidth:true,
	autoHeight:true,
	autoScroll:true,
	layout: 'fit',
	id: '',
	store: productClassGridData,
	loadMask: {msg:'���ڼ������ݣ����Ժ��'},
	sm:sm,
	cm: new Ext.grid.ColumnModel([
		sm,
		new Ext.grid.RowNumberer(),//�Զ��к�
		{
			header:'��ˮ��',
			dataIndex:'ProductDtlId',
			id:'ProductDtlId',
			hidden: true,
            hideable: false
		},
		{
			header:'������',
			dataIndex:'ProductNo',
			id:'ProductNo'
		},
		{
			header:'�������',
			dataIndex:'ProductName',
			id:'ProductName'
		},
		{
			header:'���������',
			dataIndex:'ClassId',
			id:'ClassId',
			hidden: true,
            hideable: false
		}
		]),
		tbar: new Ext.Toolbar({
	        items:[{
		        text:"����",
		        icon:"../../Theme/1/images/extjs/customer/add16.gif",
		        handler:function(){
                    openWindowShow();
		        }
		        },'-',{
		        text:"ɾ��",
		        icon:"../../Theme/1/images/extjs/customer/delete16.gif",
		        handler:function(){
		            deleteProductClassInfo();
		        }
	        }]
        }),
		bbar: new Ext.PagingToolbar({
			pageSize: 10,
			store: productClassGridData,
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
productClassGrid.render();
/*------DataGrid�ĺ������� End---------------*/
/*------ʵ��toolbar�ĺ��� start---------------*/
function openWindowShow(){
    uploadGridWindow.show();
}
function deleteProductClassInfo(){
    var sm = productClassGrid.getSelectionModel();
    //var selectData = sm.getSelected();
    var records=sm.getSelections();
    
    if (records == null || records.length == 0) 
    {
        Ext.Msg.alert("��ʾ", "��ѡ��һ�У�");
    }
    else 
    {   
        //ɾ��ǰ�ٴ������Ƿ����Ҫɾ��
	    Ext.Msg.confirm("��ʾ��Ϣ","�Ƿ����Ҫɾ��ѡ�����Ϣ��",function callBack(id){
		    //�ж��Ƿ�ɾ������
		    if(id=="yes")
		    {
                var array = new Array(records.length);
                for(var i=0;i<records.length;i++)
                {
                    array[i] = records[i].get('ProductDtlId');
                }
                Ext.Ajax.request({
                url: 'frmBaProductClass.aspx?method=deleteProductInfo',
                    params: {
                    ProductDtlId: array.join('-')//��������id��
                    },
                    success: function(resp, opts) {
                        //var data=Ext.util.JSON.decode(resp.responseText);
                        Ext.Msg.alert("��ʾ", "ɾ���ɹ���");
                        productClassGrid.getStore().reload();
                    },
                    failure: function(resp, opts) {
                        Ext.Msg.alert("��ʾ", "ɾ��ʧ�ܣ�");
                    }
                });
            }
        });
    }
    
}
/*------����toolbar�ĺ��� end---------------*/
/*------��ʼ��ѯform�ĺ��� start---------------*/
      var ProductNamePanel = new Ext.form.TextField({
            style: 'margin-left:0px',
            cls: 'key',
            xtype: 'textfield',
            fieldLabel: '�����Ż�����',
            anchor: '90%',
            listeners: { specialkey: function(f, e) { if (e.getKey() == e.ENTER) { Ext.getCmp('searchebtnId').focus(); } } }
        });

        var searchForm = new Ext.FormPanel({
            region:'north',
            labelAlign: 'left',
            layout: 'fit',
            buttonAlign: 'right',
            bodyStyle: 'padding:5px',
            frame: true,
            height:45,
            labelWidth: 100,
            items: [{
                layout: 'column',   //�����Ԫ��Ϊ����Ϊ�в��ַ�ʽ
                border: false,
                items: [ {
                    columnWidth: .45,
                    layout: 'form',
                    border: false,
                    items: [
                        ProductNamePanel
                        ]
                }, {
                    columnWidth: .2,
                    layout: 'form',
                    border: false,
                    items: [{ cls: 'key',
                        xtype: 'button',
                        text: 'ģ����ѯ',
                        id: 'searchebtnId',
                        anchor: '50%',
                        handler: function() {
                            var ProductName = ProductNamePanel.getValue();

                            productGridData.baseParams.ClassName=ProductName;
                            productGridData.load({
                                params: {
                                    start: 0,
                                    limit: 10
                                }
                            });
                        }
                    }]
                },{
                    columnWidth: .5,  //����ռ�õĿ�ȣ���ʶΪ20��
                    layout: 'form',
                    border: false
                }
                ]
            }]
        });


/*------��ʼ��ѯform�ĺ��� end---------------*/

/*------������Ӧ��ϵ�б� start --------------*/
var productGridData;
if(productGridData==null){
    productGridData = new Ext.data.Store({
        url:"frmBaProductClass.aspx?method=getProducts",
        reader:new Ext.data.JsonReader({
            totalProperty:'totalProperty',
	        root:'root'},
	        [
	            {name:'ClassId'},
	            {name:'ClassNo'},
	            {name:'ClassName'},
	            {name:'SpecificationsText'},
	            {name:'UnitText'},
	            {name:'CreateDate'},
	            {name:'Remark'}
	        ])
    });
}

var smRel= new Ext.grid.CheckboxSelectionModel({
	singleSelect:false
});
var productGrid = new Ext.grid.GridPanel({
    region:'center',
	width:'100%',
	height:'100%',
	autoWidth:true,
	autoHeight:true,
	autoScroll:true,
	layout: 'fit',
	id: '',
	store: productGridData,
	loadMask: {msg:'���ڼ������ݣ����Ժ��'},
	sm:smRel,
	cm: new Ext.grid.ColumnModel([
		smRel,
		new Ext.grid.RowNumberer(),//�Զ��к�
		{
			header:'��ˮ��',
			dataIndex:'ClassId',
			id:'ClassId',
			hidden: true,
            hideable: false
		},
		{
			header:'��Ʒ���',
			dataIndex:'ClassNo',
			id:'ClassNo'
		},
		{
			header:'��Ʒ����',
			dataIndex:'ClassName',
			id:'ClassName'
		},
		{
			header:'���',
			dataIndex:'SpecificationsText',
			id:'SpecificationsText'
		},
		{
			header:'��λ',
			dataIndex:'UnitText',
			id:'UnitText'
		},
		{
			header:'��������',
			dataIndex:'CreateDate',
			id:'CreateDate',
			renderer: Ext.util.Format.dateRenderer('Y��m��d��')
		}
		]),
		bbar: new Ext.PagingToolbar({
			pageSize: 10,
			store: productGridData,
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


/*------������Ӧ��ϵ�б� start --------------*/

/*------WindowForm ���ÿ�ʼ------------------*/
if (typeof (uploadGridWindow) == "undefined") {//�������2��windows����
    uploadGridWindow = new Ext.Window({
        id: 'gridwindow',
        title: "������Ʒ��Ӧ"
        , iconCls: 'upload-win'
        , width: 750
        , height: 450
        , layout: 'border'
        , plain: true
        , modal: true
        , constrain: true
        , resizable: false
        , closeAction: 'hide'
        , autoDestroy: true
        , items: [searchForm,productGrid]
        , buttons: [{
             id: 'savebuttonid'
            , text: "����"
            , handler: function() {
                 saveUserData();
            }
            , scope: this
        },
        {
            text: "ȡ��"
            , handler: function() {
                uploadGridWindow.hide();
            }
            , scope: this
        }]
    });
 }

uploadGridWindow.addListener("hide", function() {
    searchForm.getForm().reset();
    productGrid.getStore().removeAll();
});
        
function saveUserData() 
{    
    var sm = productGrid.getSelectionModel();
    //var selectData = sm.getSelected(); //��������Ƕ�getSelections.itemAt[0]�ķ�װ�����ڶ�ѡ������
    var records=sm.getSelections();
    
    if (records == null || records.length == 0) 
    {
        Ext.Msg.alert("��ʾ", "��ѡ��һ�У�");
    }
    else 
    {          
        var array = new Array(records.length);
        for(var i=0;i<records.length;i++)
        {
            array[i] = records[i].get('ClassId');
        }
        Ext.Ajax.request({
        url: 'frmBaProductClass.aspx?method=saveProductRelInfo',
            params: {
                ClassId: currentNodeId ,
                ProductId: array.join('-')//��������id��
            },
            success: function(resp, opts) {
                //var data=Ext.util.JSON.decode(resp.responseText);
                if(checkExtMessage(resp))
                {
                    productClassGrid.getStore().reload();
                    uploadGridWindow.hide();
                }
            },
            failure: function(resp, opts) {
                Ext.Msg.alert("��ʾ", "����ʧ�ܣ�");
            }
        });
    }
}
/*------WindowForm ���ÿ�ʼ------------------*/
var leftPanel = new Ext.Panel({ 
              region:'west',
              id:'west-panel',
              title:'����㼶��ϵ',
              //split:true,
              minSize: 175,
	          maxSize: 400,
	          //margins:'0 0 0 5',
	          layout:'fit',
              height:800,
              autoScroll:true,
              width:200,
              layoutConfig:{
	            animate:true
	          }
              ,items:mytree
          });
var rightPanel =	new Ext.Panel({
		region:'center',
        items:productClassGrid
});

var bottomPanel = new Ext.Panel(
{
	region:'south'
});
var viewport = new Ext.Viewport({
      layout:'border',
      items:[bottomPanel,leftPanel,rightPanel
       ]
  });

});
</script>
</html>
