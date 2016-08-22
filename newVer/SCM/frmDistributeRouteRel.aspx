<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmDistributeRouteRel.aspx.cs" Inherits="SCM_frmDistributeRouteRel" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>��·�ͻ�ά��</title>
    <meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
    <link rel="stylesheet" type="text/css" href="../ext3/resources/css/ext-all.css" />
	<script type="text/javascript" src="../ext3/adapter/ext/ext-base.js"></script>	
	<script type="text/javascript" src="../ext3/ext-all.js"></script>
</head>
<body>
   <div id='tree-div'></div>
   <div id='searchDiv'></div>
   <div id ='sdetailForm'></div>
</body>

<%= getComboBoxStore() %>

<script type="text/javascript">
Ext.BLANK_IMAGE_URL = "../ext3/resources/images/default/s.gif";
Ext.onReady(function(){
    var currentRouteId;
    /*--------��ѯform���� start  -----------*/    
    var searchForm = new Ext.form.FormPanel({
        labelAlign: 'right',
        layout: 'fit',
        buttonAlign: 'left',
        bodyStyle: 'padding:1px',
        height:65,
        title: '��ǰ��·��<font color="blue">������·</font>',
        frame: true,        
        items: [
        {
            layout: 'column',   //�����Ԫ��Ϊ����Ϊ�в��ַ�ʽ
            border: false,
            items: [{
                    columnWidth: .3,  //����ռ�õĿ�ȣ���ʶΪ20��
                    layout: 'form',
                    border: false,
                    labelWidth: 55,
                    items: [{
                        xtype:'textfield',
			            fieldLabel:'�ͻ����',
			            columnWidth:1,
			            anchor:'90%',
			            name:'CustomerNo',
			            id:'CustomerNo'
                    }]
                }, {
                    columnWidth: .3,
                    layout: 'form',
                    labelWidth: 55,
                    border: false,
                    items: [{
                        xtype:'textfield',
			            fieldLabel:'�ͻ�����',
			            columnWidth:1,
			            anchor:'90%',
			            name:'CustomerName',
			            id:'CustomerName'
                    }]
                },
                {
                    columnWidth: .2,
                    layout: 'form',
                    border: false,
                    items: [{ cls: 'key',
                        xtype: 'button',
                        text: '��ѯ',
                        id: 'searchebtnId',
                        anchor: '50%',
                        handler: function() {        
                            dsGridRouteCustomer.baseParams.CustomerNo = Ext.getCmp("CustomerNo").getValue();
                            dsGridRouteCustomer.baseParams.CustomerName = Ext.getCmp("CustomerName").getValue();
                            dsGridRouteCustomer.load({
                                params : {
                                start : 0,
                                limit : 10
                                } 
                             }); 
                        } 
                   }]   
                },
                {
                    columnWidth: .1,
                    layout: 'form',
                    border: false
                }]
        }]
    });
    /*--------��ѯform���� end  -----------*/
    
    /*------ʵ��tree�ĺ��� start---------------*/
    var Tree = Ext.tree;
    var tree = new Tree.TreePanel({
        el:'tree-div',
        useArrows:true,
        autoScroll:true,
        animate:true,
        autoWidth:true,
        autoHeight:true,
        enableDD:true,
        containerScroll: true, 
        loader: new Tree.TreeLoader({
           dataUrl:'frmDistributeRouteRel.aspx?method=getroutetreelist'
        }),
        dropConfig:{
            ddGroup: 'GridDD',// ��Grid��Tree�������Tree�ڲ��ڵ��϶���ʹ��'TreeDD'      
            dropAllowed: true,
            notifyDrop: function(source, e, data) {
                if(this.lastOverNode.node.id == '0' || data.selections.length == 0)
                    return;    
//                if(!this.lastOverNode.node.leaf)   
//                    return;
                if(data.selections[0].data['RouteId']==this.lastOverNode.node.id)
                    return;
                //alert(this.lastOverNode.node.id ); //Ŀ��ڵ�id 
                var srcList = new Array();
                for (i = 0; i < data.selections.length; i++) {
                    srcList [i] = data.selections[i].data['CustomerId'];
                }         
                //alert(srcList.length); //data: ����Grid������         
                //TODO: �˴���������Ҫ�Ĳ���!  
                var confrimstr = "�Ƿ����Ҫ���ͻ�<font color='blue'>["+data.selections[0].data['CustomerNo']+"]"
                                +data.selections[0].data['ChineseName']
                                +"</font>������·��<font color='blue'>["+
                                + data.selections[0].data['RouteNo'] +"]"
                                + data.selections[0].data['RouteName'] 
                                +"</font>������·��<font color='blue'>"+ this.lastOverNode.node.text +"</font>��";
                Ext.Msg.confirm("��ʾ��Ϣ",confrimstr,function callBack(id){
		        if(id=="yes")
		        {
			        //ҳ���ύ
			        Ext.Ajax.request({
				        url:'frmDistributeRouteRel.aspx?method=changeCustomerRoute',
				        method:'POST',
				        params:{
					        OldRouteId:data.selections[0].data['RouteId'],
					        CustomerId:data.selections[0].data['CustomerId'],
					        NewRouteId:this.lastOverNode.node.id
				        },
				        success: function(resp,opts){
				            data.grid.getStore().remove(data.selections[0]);
					        Ext.Msg.alert("��ʾ","�ͻ���·����ɹ�");
				        },
				        failure: function(resp,opts){
					        Ext.Msg.alert("��ʾ","�ͻ���·���ʧ��");
				        }
			        });
		        }
	        });
                this.cancelExpand(); 
                this.removeDropIndicators(this.lastOverNode); 
                return true;
            }, 
            onNodeOver : function(n, dd, e, data){
                var pt = this.getDropPoint(e, n, dd);
                var node = n.node;
                // auto node expand check
                if(!this.expandProcId && pt == "append" && node.hasChildNodes() && !n.node.isExpanded()){
                    this.queueExpand(node);
                }else if(pt != "append"){
                    this.cancelExpand();
                }
                // set the insert point style on the target node
                var returnCls = this.dropNotAllowed;
                if(this.isValidDropPoint(n, pt, dd, e, data)){
                    if(pt){
                        var el = n.ddel;
                        var cls;
                        returnCls = "x-tree-drop-ok-append";
                        cls = "x-tree-drag-append";
                        if(this.lastInsertClass != cls){
                            Ext.fly(el).replaceClass(this.lastInsertClass, cls);
                            this.lastInsertClass = cls;
                        }
                    }
                }
                return returnCls;
            } 
         }
    });
    tree.on('click',function(node){  
        if(node.id ==0)
            return;    
        currentRouteId = node.id;
        searchForm.setTitle("��ǰ��·��<font color='blue'>"+node.text+"</font>");     
        dsGridRouteCustomer.baseParams.RouteId = node.id;
        dsGridRouteCustomer.load({
            params : {
            start : 0,
            limit : 10
            } 
         }); 
    }); 
    
    // set the root node
    var root = new Tree.AsyncTreeNode({
        text: '������·',
        draggable:false,
        id:'0'
    });
    tree.setRootNode(root);

    // render the tree
    tree.render();
    root.expand();
    /*------����tree�ĺ��� end---------------*/
        
    
    /*------��ϸ��Ϣform�ĺ��� start---------------*/    
   /*------��ʼ��ȡ���ݵĺ��� start---------------*/
var dsGridRouteCustomer = new Ext.data.Store
({
url: 'frmDistributeRouteRel.aspx?method=getRouteCustomerList',
reader:new Ext.data.JsonReader({
	totalProperty:'totalProperty',
	root:'root'
},[
	{		name:'RelationId'	},
	{		name:'RouteId'	},
	{		name:'CustomerId'	},
	{		name:'CreateDate'	},
	{		name:'UpdateDate'	},
	{		name:'OperId'	},
	{		name:'OrgId'	},
	{		name:'OwnerId'	},
	{		name:'RouteNo'	},
	{		name:'RouteType'	},
	{		name:'RouteName'	},
	{		name:'CustomerNo'	},
	{		name:'ShortName'	},
	{		name:'ChineseName'	},
	{		name:'Address'	},
	{		name:'RouteTypeText'}	
	])
	,
	listeners:
	{
		scope:this,
		load:function(){
		}
	}
});

/*------��ȡ���ݵĺ��� ���� End---------------*/
/*------��ʼ��ȡ���ݵĺ��� start---------------*/
var dsGridRouteCustomer = new Ext.data.Store
({
url: 'frmDistributeRouteRel.aspx?method=getRouteCustomerList',
reader:new Ext.data.JsonReader({
	totalProperty:'totalProperty',
	root:'root'
},[
	{		name:'RelationId'	},
	{		name:'RouteId'	},
	{		name:'CustomerId'	},
	{		name:'CreateDate'	},
	{		name:'UpdateDate'	},
	{		name:'OperId'	},
	{		name:'OrgId'	},
	{		name:'OwnerId'	},
	{		name:'RouteNo'	},
	{		name:'RouteType'	},
	{		name:'RouteName'	},
	{		name:'CustomerNo'	},
	{		name:'ShortName'	},
	{		name:'ChineseName'	},
	{		name:'Address'	},
	{		name:'RouteTypeText'}	
	])
	,
	listeners:
	{
		scope:this,
		load:function(){
		}
	}
});

/*------��ȡ���ݵĺ��� ���� End---------------*/
/*------��ʼDataGrid�ĺ��� start---------------*/
var smC= new Ext.grid.CheckboxSelectionModel({
	singleSelect:true
});
var routeCustomerGrid = new Ext.grid.GridPanel({
	width:document.body.offsetWidth,
	height:'100%',
	//autoWidth:true,
	autoHeight:true,
	autoScroll:true,
	layout: 'fit',
	enableDrag: true,
	store: dsGridRouteCustomer,
	loadMask: {msg:'���ڼ������ݣ����Ժ��'},
	sm:smC,
	cm: new Ext.grid.ColumnModel([
		smC,
		new Ext.grid.RowNumberer(),//�Զ��к�
		{
			header:'��·�������',
			dataIndex:'RelationId',
			id:'RelationId',
			hidden:true,
			hideable:false
		},
		{
			header:'��·���',
			dataIndex:'RouteId',
			id:'RouteId',
			hidden:true,
			hideable:false
		},
		{
			header:'��·���',
			dataIndex:'RouteNo',
			id:'RouteNo',
			width:70
		},
		{
			header:'��·����',
			dataIndex:'RouteName',
			id:'RouteName',
			width:100
		},
		{
			header:'�ͻ����',
			dataIndex:'CustomerNo',
			id:'CustomerNo',
			width:70
		},
		{
			header:'�ͻ����',
			dataIndex:'ShortName',
			id:'ShortName',
			width:100
		},
		{
			header:'�ͻ�ȫ��',
			dataIndex:'ChineseName',
			id:'ChineseName',
			width:180
		},
		{
			header:'�ͻ���ַ',
			dataIndex:'Address',
			id:'Address',
			width:150
		},
		{
			header:'��������',
			dataIndex:'CreateDate',
			id:'CreateDate',
			width:100,
			renderer: Ext.util.Format.dateRenderer('Y��m��d��')
		}
		]),
		tbar:new Ext.Toolbar({
	        items:[{
		        text:"��ӿͻ�",
		        icon:"../Theme/1/images/extjs/customer/add16.gif",
		        handler:function(){		            
                    uploadCtmGridWindow.show();
		        }
		        },'-',{
		        text:"ɾ���ͻ�",
		        icon:"../Theme/1/images/extjs/customer/delete16.gif",
		        handler:function(){
		            deleteRouteCustomerRelInfo();
		        }
	        }]
        }),
		bbar: new Ext.PagingToolbar({
			pageSize: 10,
			store: dsGridRouteCustomer,
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
		height: 280,
		closeAction: 'hide',
		stripeRows: true,
		loadMask: true
    });
    /*------��ϸ��Ϣform�ĺ��� end---------------*/
    function deleteRouteCustomerRelInfo(){
        var sm = routeCustomerGrid.getSelectionModel();
        //var selectData = sm.getSelected();
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
                array[i] = records[i].get('RelationId');
            }
            Ext.Ajax.request({
            url: 'frmDistributeRouteRel.aspx?method=deleteRouteCustomerInfo',
                params: {
                RelationId: array.join('-')//��������id��
                },
                success: function(resp, opts) {
                    //var data=Ext.util.JSON.decode(resp.responseText);
                    Ext.Msg.alert("��ʾ", "ɾ���ɹ���");
                    routeCustomerGrid.getStore().reload();
                },
                failure: function(resp, opts) {
                    Ext.Msg.alert("��ʾ", "ɾ��ʧ�ܣ�");
                }
            });
        }

    }
    /*------ʵ��searchForm�ĺ��� start---------------*/
var nameRouteCustomerNoPanel = new Ext.form.TextField({
    style: 'margin-left:0px',
    cls: 'key',
    xtype: 'textfield',
    fieldLabel: '�ͻ����',
    name: 'name',
    anchor: '90%'
});
var nameRouteCustomerPanel = new Ext.form.TextField({
    style: 'margin-left:0px',
    cls: 'key',
    xtype: 'textfield',
    fieldLabel: '�ͻ�����',
    name: 'name',
    anchor: '90%'
});
var searchRelForm = new Ext.form.FormPanel({
    labelAlign: 'left',
    region:'north',
    buttonAlign: 'right',
    bodyStyle: 'padding:5px',
    frame: true,
    height:50,
    labelWidth: 80,
    items: [{
        layout: 'column',   //�����Ԫ��Ϊ����Ϊ�в��ַ�ʽ
        border: false,
        items: [{
            columnWidth: .33,
            layout: 'form',
            border: false,
            items: [
                nameRouteCustomerNoPanel
                ]
        }, {
            columnWidth: .33,
            layout: 'form',
            border: false,
            items: [
                nameRouteCustomerPanel
                ]
        }, {
            columnWidth: .10,
            layout: 'form',
            border: false,
            items: [{ cls: 'key',
                xtype: 'button',
                text: '��ѯ',
                anchor: '50%',
                handler :function(){
                    var name = nameRouteCustomerPanel.getValue();
                    var no = nameRouteCustomerNoPanel.getValue();
                    //alert(name +":"+type);
                    dsRCustomerGrid.baseParams.ChineseName = name;
                    dsRCustomerGrid.baseParams.CustomerId = no;
                    dsRCustomerGrid.load({
                                params : {
                                start : 0,
                                limit : 10
                                } 
                              }); 
                    }
                }]
        },{
            columnWidth: .56,  //����ռ�õĿ�ȣ���ʶΪ20��
            layout: 'form',
            border: false
        }]
    }]

});

/*------ʵ��searchForm�ĺ��� start---------------*/

/*------�����ͻ�ѡ���б� start --------------*/
var dsRCustomerGrid;
if(dsRCustomerGrid==null){
    dsRCustomerGrid = new Ext.data.Store({
        url:"frmDistributeRouteRel.aspx?method=getNonCustomers",
        reader:new Ext.data.JsonReader({
            totalProperty:'totalProperty',
	        root:'root'},
	        [
	            { name: "CustomerId" },
			    { name: "CustomerNo" },
			    { name: "ShortName" },
			    { name: "LinkMan" },
			    { name: "LinkTel" },
			    { name: "LinkMobile" },
			    { name: "Fax" },
			    { name: "DistributionTypeText" },
			    { name: "MonthQuantity" },
			    { name: "IsCust" },
			    { name: "IsProvide" },
			    { name: 'CreateDate'}
	        ])	        
    });
}

var smRel= new Ext.grid.CheckboxSelectionModel({
	singleSelect:false
});
var rCustomerGrid = new Ext.grid.GridPanel({
	width:'100%',
	height:'100%',
	autoWidth:true,
	autoHeight:true,
	autoScroll:true,
	region: 'center',
	id: '',
	store: dsRCustomerGrid,
	loadMask: {msg:'���ڼ������ݣ����Ժ��'},
	sm:smRel,
	cm: new Ext.grid.ColumnModel([
		smRel,
		new Ext.grid.RowNumberer(),//�Զ��к�
	    { header: "�ͻ�ID",dataIndex: 'CustomerId' ,hidden:true,hideable:false},
        { header: "�ͻ����", width: 80, sortable: true, dataIndex: 'CustomerNo' },
        { header: "�ͻ�����", width: 150, sortable: true, dataIndex: 'ShortName' },
        { header: "��ϵ��", width: 60, sortable: true, dataIndex: 'LinkMan' },
        { header: "��ϵ�绰", width: 80, sortable: true, dataIndex: 'LinkTel' },
        { header: "����ʱ��", width: 80, sortable: true, dataIndex: 'CreateDate',
                    renderer: Ext.util.Format.dateRenderer('Y��m��d��') }
		]),
		bbar: new Ext.PagingToolbar({
			pageSize: 10,
			store: dsRCustomerGrid,
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
		loadMask: true
	});


/*------�����ͻ�ѡ���б� end --------------*/

/*------��ʼ�ͻ����ý������ݵĴ��� Start---------------*/
if(typeof(uploadCtmGridWindow)=="undefined"){//�������2��windows����
	uploadCtmGridWindow = new Ext.Window({
		id:'Customerformwindow',
		title:'�ͻ���Ϣ'
		, iconCls: 'upload-win'
		, width: 600
		, height: 400
		, layout: 'border'
		, plain: true
		, modal: true
		, constrain:true
		, resizable: false
		, closeAction: 'hide'
		,autoDestroy :true
		,items:[searchRelForm,rCustomerGrid]
		,buttons: [{
			text: "����"
			, handler: function() {
				saveCustoemrData();
			}
			, scope: this
		},
		{
			text: "ȡ��"
			, handler: function() { 
				uploadCtmGridWindow.hide();
			}
			, scope: this
		}]});
	}
	uploadCtmGridWindow.addListener("hide",function(){
	    searchRelForm.getForm().reset();
	    rCustomerGrid.getStore().removeAll();   
});
function saveCustoemrData(){
    if (currentRouteId <= 0) 
    {
        Ext.Msg.alert("��ʾ", "��ѡ����Ҫ��ӿͻ���������·��");
    }
    var sm = rCustomerGrid.getSelectionModel();
    //var selectData = sm.getSelected(); //��������Ƕ�getSelections.itemAt[0]�ķ�װ�����ڶ�ѡ������
    var records=sm.getSelections();
    
    if (records == null || records.length == 0) 
    {
        Ext.Msg.alert("��ʾ", "��ѡ����Ҫ������·�Ŀͻ���");
    }
    else 
    { 
        Ext.Msg.confirm("��ʾ��Ϣ", "ȷ�ϱ��棿", function callBack(id) {
            //�ж��Ƿ�ɾ������
            if (id == "yes") {
                 var array = new Array(records.length);
                for(var i=0;i<records.length;i++)
                {
                    array[i] = records[i].get('CustomerId');
                }
                Ext.Ajax.request({
                url: 'frmDistributeRouteRel.aspx?method=saveCustomerRelInfo',
                    params: {
                        RouteId: currentRouteId ,
                        CustomerId: array.join('-')//��������id��
                    },
                    success: function(resp, opts) {
                        //var data=Ext.util.JSON.decode(resp.responseText);
                        Ext.Msg.alert("��ʾ", "����ɹ���");
                        dsGridRouteCustomer.reload();
                        uploadCtmGridWindow.hide();
                    },
                    failure: function(resp, opts) {
                        Ext.Msg.alert("��ʾ", "����ʧ�ܣ�");
                    }
                });
            }
         });   
    }
}
/*------�����ͻ����ý������ݵĴ��� End---------------*/
/*------viewreport���� start---------------*/
var leftPanel = new Ext.Panel({ 
      region:'west',
      id:'west-panel',
      title:'��·�㼶��ϵ',
      //split:true,
      minSize: 175,
      maxSize: 400,
      //margins:'0 0 0 5',
      layout:'fit',                  
      height:500,
      autoScroll:true,
      width:200,
      layoutConfig:{
        animate:true
      }
      ,items:tree
  });
var rightPanel =	new Ext.Panel({
		region:'center',
        items:[{
	        layout:'column',
	        border: false,
	        items: [
	        {
		        layout:'form',
		        border: false,
		        columnWidth:1,
		        items: [
		            searchForm
		        ]
		     }]
		},{
		    layout:'column',
	        border: false,
	        items: [
	        {
		        layout:'form',
		        border: false,
		        columnWidth:1,
		        items: [
		            routeCustomerGrid
		        ]
		     }]
	    }]
	});

	var bottomPanel = new Ext.Panel(
	{
		region:'south'
	});
    var viewport = new Ext.Viewport({
          layout:'border',
          items:[bottomPanel,leftPanel,rightPanel]
      });
    
    /*------viewreport���� end---------------*/

})
</script>
</html>
