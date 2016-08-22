<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmBaProductTypeForPlan.aspx.cs" Inherits="CRM_product_frmBaProductType" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>����ƻ�����</title>
    <meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
    <link rel="stylesheet" type="text/css" href="../../ext3/resources/css/ext-all.css" />
	<script type="text/javascript" src="../../ext3/adapter/ext/ext-base.js"></script>	
	<script type="text/javascript" src="../../ext3/ext-all.js"></script>
	<script type="text/javascript" src="../../js/operateResp.js"></script>
	<script type="text/javascript" src="../../js/ProductSelect.js"></script>
	<script type="text/javascript" src="../../js/ExtJsHelper.js"></script>
</head>
<body>
   <div id='tree-div'></div>
   <div id='searchDiv'></div>
   <div id ='sdetailForm'></div>
</body>
<script type="text/javascript">
function getParamerValue( name )
{
  name = name.replace(/[\[]/,"\\\[").replace(/[\]]/,"\\\]");
  var regexS = "[\\?&]"+name+"=([^&#]*)";
  var regex = new RegExp( regexS );
  var results = regex.exec( window.location.href );
  if( results == null )
    return "";
  else
    return results[1];
}
var Type = getParamerValue('type');//��������
</script>
<%= getComboBoxStore() %>

<script type="text/javascript">
parentUrl="frmBaProductTypeForPlan.aspx?method=getbaproducttypetree&ShowSale=true";
Ext.BLANK_IMAGE_URL = "../../ext3/resources/images/default/s.gif";
Ext.onReady(function(){
    var currentNode;
    /*--------��ѯform���� start  -----------*/
           
    var orgCombo = new Ext.form.ComboBox({
        fieldLabel: '������֯',
        xtype: 'combo',
        anchor: '95%',
        editable:false,
        store:dsOrgInfoList, //output
        displayField:'OrgName',
        valueField:'OrgId',
        typeAhead:true,
        triggerAction:'all',
        id:'orgCombox',
        mode:'local',
        editable:false,
        listeners: { specialkey: function(f, e) { if (e.getKey() == e.ENTER) { Ext.getCmp('isCheckBox').focus(); } } }
    });
    
    
    var isCheckBox = new  Ext.form.Checkbox({     //checkbox 
        id:'isCheckBox',
        xtype: 'checkbox',
        checked:false,
        boxLabel:'ϸ����������Ʒ',
        anchor: '95%'
    });
    
    

    var searchForm = new Ext.form.FormPanel({
        renderTo:'searchDiv',
        labelAlign: 'right',
        layout: 'fit',
        buttonAlign: 'left',
        bodyStyle: 'padding:5px',
        frame: true,        
        items: [
        {
                layout: 'column',   //�����Ԫ��Ϊ����Ϊ�в��ַ�ʽ
                border: false,
                items: [{
                    columnWidth: .4,  //����ռ�õĿ�ȣ���ʶΪ20��
                    layout: 'form',
                    border: false,
                    labelWidth: 55,
                    items: [
                        orgCombo
                    ]
                }, {
                    columnWidth: .4,
                    layout: 'form',
                    labelWidth: 125,
                    border: false,
                    items: [
                        isCheckBox
                        ]
                },
                {
                    columnWidth: .1,
                    layout: 'form',
                    border: false,
                    items: [{ cls: 'key',
                        xtype: 'button',
                        text: 'ˢ��',
                        id: 'searchebtnId',
                        anchor: '90%',
                        handler: function() {//��̬�ı���ˢ�£�load������
                        tree.getLoader().on("beforeload", function(treeLoader, node) {
                            treeLoader.baseParams.orgId = orgCombo.getValue();
                            treeLoader.baseParams.isAll = isCheckBox.getValue();
                            treeLoader.baseParams.isPlanType = Type;
                        }, this);
                            tree.root.reload();
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
        enableDD:false,
        containerScroll: true, 
        loader: new Tree.TreeLoader({
           dataUrl:'frmBaProductTypeForPlan.aspx?method=gettreelist',
           baseParams:{
                orgId:orgCombo.getValue(),
                isAll:isCheckBox.getValue(),
                isPlanType:Type
           }})
    });
    
    
    tree.on('contextmenu',function(node,event){  
          //alert("node.id="+ node.id);
          currentNode = node;
	      //var selModel = tree.getSelectionModel();
	      //selModel.select(currentNode);  //�Ҽ���Ӧ��λ��ǰ�ڵ㣬������Ӧ����¼�
	      currentNode.select();
          event.preventDefault(); //�����Ǳ����
          //�����Ҽ��˵��Ӳ˵�
          if(node.id ==0 ){
            rightClick.items.get('deleteItem').disable();
            rightClick.items.get('forbiddenItem').disable();
            rightClick.items.get('modifyItem').disable();
          }else{
            rightClick.items.get('deleteItem').enable();
            rightClick.items.get('forbiddenItem').enable();
            rightClick.items.get('modifyItem').enable();
          }
          rightClick.showAt(event.getXY());//ȡ����������꣬չʾ�˵�
    });
    
    //�����Ҽ��˵�
    var rightClick = new Ext.menu.Menu({
        id :'rightClickCont',
        items : [{
            id:'addItem',
            text : '����',
            icon:"../../Theme/1/images/extjs/customer/add16.gif",
            //���Ӳ˵�����¼�
            handler:function (){
                //��ʾ����ֵ
                uploadTypeWindow.show();
                Ext.getCmp("ClassId").setValue('');
                Ext.getCmp('ParentClassId').setValue(currentNode.id);
		        Ext.getCmp("ParentClassName").setValue(currentNode.text);
		        Ext.getCmp("State").setValue(1);
		        Ext.getCmp("ClassNo").setValue('');
		        Ext.getCmp("ClassName").setValue('');
		        Ext.getCmp("Remark").setValue('');
		        Ext.getCmp("AccountUnit").setValue('');
		        Ext.getCmp("OwenOrg").setValue(<%=OrgID %>)
            }
        }, {
            id:'modifyItem',
            text : '�޸�',
            icon:"../../Theme/1/images/extjs/customer/edit16.gif",
            handler:function (){
                //��ʾ����ֵ
                uploadTypeWindow.show();
                rightClick.hide();
                if(currentNode.id ==0)
                    return;
                setFormValue(currentNode);  
            }
        }, {
            id:'deleteItem',
            text : 'ɾ��',
            icon:"../../Theme/1/images/extjs/customer/delete16.gif",
            handler:function (){
                 //ɾ��ǰ�ٴ������Ƿ����Ҫɾ��
            Ext.Msg.confirm("��ʾ��Ϣ", "�Ƿ����Ҫɾ��ѡ��Ĵ��������Ϣ��", function callBack(id) {
                //�ж��Ƿ�ɾ������
                if (id == "yes") {
                    //ҳ���ύ
                    Ext.Ajax.request({
		            url:'frmBaProductTypeForPlan.aspx?method=deleteProductType',
		            method:'POST',
		            params:{
			            ClassId:currentNode.id
			        },
		            success: function(resp,opts){
			            if(checkExtMessage(resp))
			            {
			                //��ǰ�ڵ�ɾ��
			                currentNode.remove();
			            }
		            },
		            failure: function(resp,opts){
			            Ext.Msg.alert("��ʾ","ɾ��ʧ��");
		            }
		            });
                }
            });
                 
            }
        }, {
            id:'forbiddenItem',
            text : '��ֹ',
            icon:"../../Theme/1/images/extjs/customer/forbidden16.gif",
            handler:function (){
                 Ext.Ajax.request({
		            url:'frmBaProductTypeForPlan.aspx?method=forbiddenProductType',
		            method:'POST',
		            params:{
			            ClassId:currentNode.id
			        },
		            success: function(resp,opts){
			            Ext.Msg.alert("��ʾ","��ֹ�ɹ�");
			            //��ǰ�ڵ�ɾ��
			            currentNode.remove();
		            },
		            failure: function(resp,opts){
			            Ext.Msg.alert("��ʾ","��ֹʧ��");
		            }
		            });
            }
        }, {
            id:'getChildItem',
            text : 'ͬ������',
            icon:"../../Theme/1/images/extjs/customer/forbidden16.gif",
            handler:function (){
                 Ext.Ajax.request({
		            url:'frmBaProductTypeForPlan.aspx?method=getchildproduct',
		            method:'POST',
		            params:{
			            ClassId:currentNode.id
			        },
		            success: function(resp,opts){		            
			            Ext.Msg.alert("��ʾ","ͬ���ɹ�");
		            },
		            failure: function(resp,opts){
			            Ext.Msg.alert("��ʾ","ͬ��ʧ��");
		            }
		            });
            }
        }, {
            id:'refreshItem',
            text : '���',
            icon:"../../Theme/1/images/extjs/customer/forbidden16.gif",
            handler:function (){
                 Ext.Ajax.request({
		            url:'frmBaProductTypeForPlan.aspx?method=check',
		            method:'POST',
		            params:{
			            ClassId:currentNode.id
			        },
		            success: function(resp,opts){		            
			            checkExtMessage(resp);
		            },
		            failure: function(resp,opts){
			            Ext.Msg.alert("��ʾ","ͬ��ʧ��");
		            }
		            });
            }
        }, {
            id:'refreshItem1',
            text : '��Ӧ��֯',
            icon:"../../Theme/1/images/extjs/customer/edit16.gif",
            handler:function (){
                 if(Type!=2) return;   
                 if(orgwin==null){              
                     var orgwin = new Ext.Window ({
                      height: 460, 
                      width: 400, 
                      title: '��֯ѡ��', 
                      html: "<iframe id='iframeorg' width='100%' height='100%' src='frmBaProductTypeOrgTree.aspx?classid="+currentNode.id+"'</iframe>",
                      buttons: [{
                        text: "�ر�",
                        handler: function() {
                            orgwin.hide();
                        }, 
                        scope: this
                      }]
                    });
                    orgwin.show();
                }else{
                    document.getElementById("iframeorg").contentWindow.classId = currentNode.id;
                    orgwin.show();
                }
            }
        }, {
            id:'refreshItem2',
            text : 'ͬ����Ŀ',
            icon:"../../Theme/1/images/extjs/customer/edit16.gif",
            handler:function (){
                 if(Type!=2) return;   
                 if(sameWin==null){   
                 
                    //ͬ����Ŀʱ����Ҫ�����ı�������
                     treeSame = new Tree.TreePanel({
                            useArrows:true,
                            autoScroll:true,
                            animate:true,
                            autoWidth:true,
                            autoHeight:true,
                            enableDD:false,
                            containerScroll: true, 
                             root:new Tree.AsyncTreeNode({
                                text: '�������',
                                draggable:false
                            }),
                            loader: new Tree.TreeLoader({
                               dataUrl:'frmBaProductTypeForPlan.aspx?method=gettreelist',
                               baseParams:{
                                    orgId:orgCombo.getValue(),
                                    isAll:isCheckBox.getValue(),
                                    isPlanType:Type
                               }})
                        });
                     treeSame.on("click",selectSameItem);
                     sameWin = new Ext.Window ({
                      height: 460, 
                      width: 400, 
                      title: '��֯ѡ��', 
                      items:treeSame,
                      buttons: [{
                        text: "ȷ��",
                        handler: function() {
                            if(sameItem==null)
                            {
                                Ext.Msg.alert("û��ѡ����Ҫͬ������Ŀ��");
                                return;
                            }
                            Ext.Ajax.request({
		                    url:'frmBaProductTypeForPlan.aspx?method=sameitem',
		                    method:'POST',
		                    params:{
			                    ClassId:currentNode.id,
			                    SameClass:sameItem.id
			                },
		                    success: function(resp,opts){		            
			                    checkExtMessage(resp);
		                    },
		                    failure: function(resp,opts){
			                    Ext.Msg.alert("��ʾ","ͬ��ʧ��");
		                    }
		                    });
                            sameWin.hide();
                        }},{
                        text: "�ر�",
                        handler: function() {
                            sameWin.hide();
                        }, 
                        scope: this
                      }]
                    });
                    sameWin.show();
                }else{
                    sameItem=null;
                    sameWin.show();
                }
            }
        }]
     });

var sameItem = null;
function selectSameItem(node){  
        sameItem = node;
}
var treeSame = null;
var sameWin = null;
    // set the root node
    var root = new Tree.AsyncTreeNode({
        text: '�������',
        draggable:false,
        id:'0'
    });
    tree.setRootNode(root);

    // render the tree
    tree.render();
    root.expand();
    
 
/*------����tree�ĺ��� end---------------*/
/*------��ʼ��ȡ�������ݵĺ��� start---------------*/
function saveUserData()
{
    var state = 0;
    if(Ext.getCmp('State').getValue())
        state =1;
//    var needSum = 0;
//    if(Ext.getCmp('NeedSum').getValue())
//        needSum = 1;
	Ext.Ajax.request({
		url:'frmBaProductTypeForPlan.aspx?method=saveProductType',
		method:'POST',
		params:{
			ClassId:Ext.getCmp('ClassId').getValue(),
			OwenOrg:Ext.getCmp('OwenOrg').getValue(),
			ParentClassId:Ext.getCmp('ParentClassId').getValue(),
			State:state,			
			Category:Type,
			ClassNo:Ext.getCmp('ClassNo').getValue(),
			ClassName:Ext.getCmp('ClassName').getValue(),
			AccountUnit:Ext.getCmp('AccountUnit').getValue(),
			Remark:Ext.getCmp('Remark').getValue() ,
			ClassType:Ext.getCmp('ClassType').getValue(),
			NeedSum:Ext.getCmp('NeedSum').getValue(),
			OrderColumn:Ext.getCmp('OrderColumn').getValue()
			//CreateDate:Ext.getCmp('CreateDate').getValue(),
			//OperId:Ext.getCmp('OperId').getValue(),
			//OrgId:Ext.getCmp('OrgId').getValue(),
			//ExpireDate:Ext.getCmp('ExpireDate').getValue(),
			//ExpireOperId:Ext.getCmp('ExpireOperId').getValue(),
			//ExpireOrg:Ext.getCmp('ExpireOrg').getValue()		
			},
		success: function(resp,opts){
			//Ext.Msg.alert("��ʾ","����ɹ�");
			if(checkExtMessage(resp))
			{
			    //ˢ��tree
			    tree.root.reload({ 
                    baseParams:{
                        orgId:orgCombo.getValue(),
                        isAll:isCheckBox.getValue(),
                        isPlanType:Type
                   }
                });
            }
		},
		failure: function(resp,opts){
			Ext.Msg.alert("��ʾ","����ʧ��");
		}
		});
		}
/*------������ȡ�������ݵĺ��� End---------------*/

/*------��ʼ�������ݵĺ��� Start---------------*/
function setFormValue(currentNode)
{    
	Ext.Ajax.request({
		url:'frmBaProductTypeForPlan.aspx?method=getModifyType',
		params:{
			ClassId:currentNode.id
		},
	success: function(resp,opts){
	    
		var data=Ext.util.JSON.decode(resp.responseText);
		Ext.getCmp("ClassId").setValue(data.ClassId);
		Ext.getCmp("OwenOrg").setValue(data.OwenOrg);
		
		//����key��λ�������е�value
		//var index = dsOrgInfoList.find('OrgId', data.OwenOrg);
        //var record = dsOrgInfoList.getAt(index);
        //Ext.getCmp('OwenOrg').setRawValue(record.data.OrgName);
		Ext.getCmp("ParentClassId").setValue(data.ParentClassId);
		Ext.getCmp("ParentClassName").setValue(currentNode.parentNode.text);
		Ext.getCmp("State").setValue(data.State);
		Ext.getCmp("ClassNo").setValue(data.ClassNo);
		Ext.getCmp("ClassName").setValue(data.ClassName);
		Ext.getCmp("AccountUnit").setValue(data.AccountUnit);
		Ext.getCmp("Remark").setValue(data.Remark);
		Ext.getCmp("ClassType").setValue(data.ClassType);
		Ext.getCmp("NeedSum").setValue(data.NeedSum);
		Ext.getCmp("OrderColumn").setValue(data.OrderColumn);
		Ext.getCmp("AccountUnit").setValue(data.AccountUnit);
	},
	failure: function(resp,opts){
		Ext.Msg.alert("��ʾ","��ȡ���������Ϣʧ��");
	}
	});
}
/*------�������ý������ݵĺ��� End---------------*/
    
/*------��ϸ��Ϣform�ĺ��� start---------------*/    
var detailTypeForm=new Ext.form.FormPanel({
	//title:'������ϸ��Ϣ',
	//renderTo:'detailForm',
	frame:true,	
    labelAlign: 'left',
    buttonAlign: 'right',
    bodyStyle: 'padding:5px',
	items:[	
	{
		layout:'column',
		border: false,
		items: [
		{
			layout:'form',
			border: false,
			columnWidth:.5,
			items: [
			    {
					xtype:'hidden',
					fieldLabel:'�������ID',
					hidden:true,
					hideLabel:true,
					name:'ClassId',
					id:'ClassId'
				},
				{
					xtype:'combo',
					fieldLabel:'������֯',
					anchor:'90%',
					name:'OwenOrg',
					id:'OwenOrg'
					//store:[[1,'��˾'],[2,'����']],
					,displayField:'OrgName'
                    ,valueField:'OrgId'
					,editable:false
					,disabled:true
                    ,store: dsOrgInfoList
                    ,triggerAction:'all'
                    ,mode:'local'
				}
		]
		},
		{
		    layout:'form',
			border: false,
			columnWidth:.5,
			items:[
			{
			        xtype:'combo',
					fieldLabel:'��Ŀ����',
					anchor:'90%',
					name:'ClassType',
					id:'ClassType'
					,displayField:'DicsName'
                    ,valueField:'DicsCode'
                    ,store: dsReportTypeList
                    ,triggerAction:'all'
                    ,mode:'local'
		}]}
	]},
	{
		layout:'column',
		border: false,
		items: [
		{
			layout:'form',
			border: false,
			columnWidth:0.5,
			items: [
				{
					xtype:'hidden',
					fieldLabel:'������ID',
					name:'ParentClassId',
					id:'ParentClassId',
					hidden:true,
					hiddenLabel:true
				},
				{
					xtype:'textfield',
					fieldLabel:'����������',
					anchor:'90%',
					name:'ParentClassName',
					id:'ParentClassName',
                    editable:false,
                    disabled:true
				}
		]
		}
,		{
			layout:'form',
			border: false,
			columnWidth:0.5,
			items: [
				{
					xtype:'checkbox',
					boxLabel:'����',
					anchor:'90%',
					name:'State',
					id:'State'
					//hideLabel:true
				}
		]
		}
	]},
	{
		layout:'column',
		border: false,
		items: [
		{
			layout:'form',
			border: false,
			columnWidth:0.5,
			items: [
				{
					xtype:'textfield',
					fieldLabel:'������',
					anchor:'90%',
					name:'ClassNo',
					id:'ClassNo'
				}
		]
		}
,		{
			layout:'form',
			border: false,
			columnWidth:0.5,
			items: [
				{
					xtype:'textfield',
					fieldLabel:'��������',
					anchor:'90%',
					name:'ClassName',
					id:'ClassName'
				}
		]
		}
	]},
	{
		layout:'column',
		border: false,
		items: [
		{
			layout:'form',
			border: false,
			columnWidth:0.5,
			items: [
				{
					xtype:'textfield',
					fieldLabel:'ͳ�Ƶ�λ',
					anchor:'90%',
					name:'AccountUnit',
					id:'AccountUnit'
				}
		    ]
		},
		{
			layout:'form',
			border: false,
			columnWidth:0.5,
			html: '&nbsp;'
		}
	]},
	{
		layout:'column',
		border: false,
		items: [
		{
			layout:'form',
			border: false,
			columnWidth:1,
			items: [
				{
					xtype:'textarea',
					fieldLabel:'���౸ע',
					anchor:'90%',
					name:'Remark',
					id:'Remark'
				}
		]
		}
	]},
	{
		layout:'column',
		border: false,
		items: [
		{
			layout:'form',
			border: false,
			columnWidth:0.5,
			items: [
				{
					xtype:'checkbox',
					boxLabel:'�Ƿ���Ҫ�ϼ���',
					anchor:'90%',
					name:'NeedSum',
					id:'NeedSum'
				}
		]
		},
		{
			layout:'form',
			border: false,
			columnWidth:0.5,
			items: [
				{
					xtype:'textfield',
					fieldLabel:'������',
					anchor:'90%',
					name:'OrderColumn',
					id:'OrderColumn'
				}
		]
		}
	]}
]
});
/*------��ϸ��Ϣform�ĺ��� end---------------*/
    
/*------��ϸ��Ϣwindow�ĺ��� start---------------*/
if (typeof (uploadTypeWindow) == "undefined") {//�������2��windows����
    uploadTypeWindow = new Ext.Window({
        id: 'uploadTypeWindow',
        title: "�ɹ��ƻ����ά��"
        , iconCls: 'upload-win'
        , width: 600
        , height: 300
        , layout: 'fit'
        , plain: true
        , modal: true
        , constrain: true
        , resizable: false
        , closeAction: 'hide'
        , autoDestroy: true
        , items: detailTypeForm
        , buttons: [{
             id: 'savebuttonid'
            , text: "����"
            , handler: function() {
                Ext.Msg.confirm("��ʾ��Ϣ", "�Ƿ�ȷ��Ҫ���棿", function callBack(id) {
                    //�ж��Ƿ�ɾ������
                    if (id == "yes") {
                        //ҳ���ύ
                        saveUserData();
                        uploadTypeWindow.hide();
                        
                    }
                });
            }
            , scope: this
        },
        {
            text: "ȡ��"
            , handler: function() {
                uploadTypeWindow.hide();
            }
            , scope: this
        }]
    });
}

uploadTypeWindow.addListener("hide", function() {
    detailTypeForm.getForm().reset();
});

/*------��ϸ��Ϣwindow�ĺ��� end---------------*/

/*------��ϸС��������Ϣ  start -------------*/
var smallClassGridData;
if(smallClassGridData==null){
    smallClassGridData = new Ext.data.Store({
        url:"frmBaProductTypeforPlan.aspx?method=getSmallClass",
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

var sm= new Ext.grid.CheckboxSelectionModel({
	singleSelect:false
});

var defaultPageSize = 10;
    var toolBar = new Ext.PagingToolbar({
        pageSize: 10,
        store: smallClassGridData,
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
    
var detailGrid = new Ext.grid.GridPanel({	
	width:'100%',
	autoScroll:true,
	layout: 'fit',
	id: '',
	store: smallClassGridData,
	loadMask: {msg:'���ڼ������ݣ����Ժ��'},
	sm:sm,
	cm: new Ext.grid.ColumnModel([
		sm,
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
		tbar: new Ext.Toolbar({
	        items:[{
		        text:"����",
		        icon:"../../Theme/1/images/extjs/customer/add16.gif",
		        handler:function(){		       
		        if (selectProductForm == null){		                
		                otherUrlParams = 'ClassId='+currentNode.id;
                        showProductForm("", "", "", true); //��ʾ�����ڴ���
                        selectProductForm.buttons[0].on("click", function() {
                            var selectNodes = selectProductTree.getChecked();
                            var array = new Array(selectNodes.length);
                            for (var i = 0; i < selectNodes.length; i++) {
                                array[i] =  selectNodes[i].id;
                            }
                            tradeNode(selectProductTree.root);
                            Ext.Ajax.request({
                            url: 'frmBaProductTypeForPlan.aspx?method=saveClassesRelInfo',
                                params: {
                                    ProductIds:result,
                                    ClassId: currentNode.id ,
                                    ClassDtlId: array.join('-')//��������id��
                                },
                                success: function(resp, opts) {
                                    //var data=Ext.util.JSON.decode(resp.responseText);
                                    Ext.Msg.alert("��ʾ", "����ɹ���");
                                    detailGrid.getStore().reload();
                                },
                                failure: function(resp, opts) {
                                    Ext.Msg.alert("��ʾ", "����ʧ�ܣ�");
                                }
                            });
                        });
                    }
                    else {
                     if(otherUrlParams!='ClassId='+currentNode.id)
		            {
		                    var root = new Ext.tree.AsyncTreeNode({
                                text: '��Ʒ��Ϣ',
                                draggable: false,
                                id: 'source'
                            });
                          selectProductTree.setRootNode(root); 

                        
                        otherUrlParams = 'ClassId='+currentNode.id;
		            }
		            
                        showProductForm("", "", "", true);
                    }
//		            if(currentNode ==null ||currentNode.id <= 0){
//		                alert("��ѡ�����");
//		                return;
//		            }
//                    uploadClsGridWindow.show();
//                    classesGrid.getStore().load({params:{limit:10,start:0}});
		        }
		        },'-',{
		        text:"ɾ��",
		        icon:"../../Theme/1/images/extjs/customer/delete16.gif",
		        handler:function(){
		            deleteSmallClassInfo();
		        }
	        }]
        }),
		bbar: toolBar,
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

//ɾ��С��
function deleteSmallClassInfo()
{
    var sm = detailGrid.getSelectionModel();
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
            array[i] = records[i].get('ClassId');
        }
        Ext.Ajax.request({
        url: 'frmBaProductTypeForPlan.aspx?method=deleteClassesInfo',
            params: {
            ClassId:currentNode.id,
            ClassDtlId: array.join('-')//��������id��
            },
            success: function(resp, opts) {
                //var data=Ext.util.JSON.decode(resp.responseText);
                Ext.Msg.alert("��ʾ", "ɾ���ɹ���");
                detailGrid.getStore().reload();
            },
            failure: function(resp, opts) {
                Ext.Msg.alert("��ʾ", "ɾ��ʧ�ܣ�");
            }
        });
    }
}   
/*------��ϸС��������Ϣ  end -------------*/


/*------������Ӧ��ϵ�б� start --------------*/
var dsCalssGridData;
if(dsCalssGridData==null){
    dsCalssGridData = new Ext.data.Store({
        url:"frmBaProductTypeForPlan.aspx?method=getNonCalsses",
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
var classesGrid = new Ext.grid.GridPanel({
	width:'100%',
	height:'100%',
	autoWidth:true,
	autoHeight:true,
	autoScroll:true,
	layout: 'fit',
	id: '',
	store: dsCalssGridData,
	loadMask: {msg:'���ڼ������ݣ����Ժ��'},
	sm:smRel,
	cm: new Ext.grid.ColumnModel([
		sm,
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
			format:'Y��m��d��'
		}
		]),
		bbar: new Ext.PagingToolbar({
			pageSize: 10,
			store: dsCalssGridData,
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
if (typeof (uploadClsGridWindow) == "undefined") {//�������2��windows����
    uploadClsGridWindow = new Ext.Window({
        id: 'gridwindow',
        title: "������Ʒ��Ӧ"
        , iconCls: 'upload-win'
        , width: 550
        , height: 350
        , layout: 'fit'
        , plain: true
        , modal: true
        , constrain: true
        , resizable: false
        , closeAction: 'hide'
        , autoDestroy: true
        , items: classesGrid
        , buttons: [{
             id: 'savebuttonid'
            , text: "����"
            , handler: function() {
                 saveClassesData();
            }
            , scope: this
        },
        {
            text: "ȡ��"
            , handler: function() {
                uploadClsGridWindow.hide();
            }
            , scope: this
        }]
    });
 }

uploadClsGridWindow.addListener("hide", function() {
    classesGrid.getStore().removeAll();
});
        
function saveClassesData() 
{    
    var sm = classesGrid.getSelectionModel();
    //var selectData = sm.getSelected(); //��������Ƕ�getSelections.itemAt[0]�ķ�װ�����ڶ�ѡ������
    var records=sm.getSelections();
    
    if (records == null || records.length == 0) 
    {
        Ext.Msg.alert("��ʾ", "��ѡ��һ�У�");
    }
    else 
    { 
        Ext.Msg.confirm("��ʾ��Ϣ", "ȷ�ϱ��棿", function callBack(id) {
                //�ж��Ƿ�ɾ������
                if (id == "yes") {
                     var array = new Array(records.length);
                    for(var i=0;i<records.length;i++)
                    {
                        array[i] = records[i].get('ClassId');
                    }
                    Ext.Ajax.request({
                    url: 'frmBaProductTypeForPlan.aspx?method=saveClassesRelInfo',
                        params: {
                            ClassId: currentNode.id ,
                            ClassDtlId: array.join('-')//��������id��
                        },
                        success: function(resp, opts) {
                            //var data=Ext.util.JSON.decode(resp.responseText);
                            Ext.Msg.alert("��ʾ", "����ɹ���");
                            detailGrid.getStore().reload({
                                params:{
                                    ClassId:currentNode.id
                                }
                            });
                            uploadClsGridWindow.hide();
                        },
                        failure: function(resp, opts) {
                            Ext.Msg.alert("��ʾ", "����ʧ�ܣ�");
                        }
                    });
                }
             });
        
       
    }
}
/*------WindowForm ���ÿ�ʼ------------------*/

//������Ʒ��Ϣ
productGridData = new Ext.data.Store
({
    url: 'frmBaProductTypeForPlan.aspx?method=getClassProductList',
    reader: new Ext.data.JsonReader({
        totalProperty: 'totalProperty',
        root: 'root'
    }, [
	{
	    name: 'ProductId'
	},
	{
	    name: 'ProductNo'
	},
	{
	    name: 'MnemonicNo'
	},
	{
	    name: 'AliasNo'
	},
	{
	    name: 'MobileNo'
	},
	{
	    name: 'SpeechNo'
	},
	{
	    name: 'NetPurchasesNo'
	},
	{
	    name: 'LogisticsNo'
	},
	{
	    name: 'BarCode'
	},
	{
	    name: 'SecurityCode'
	},
	{
	    name: 'ProductName'
	},
	{
	    name: 'AliasName'
	},
	{
	    name: 'Specifications'
	},
	{
	    name: 'SpecificationsText'
	},
	{
	    name: 'Unit'
	},
	{
	    name: 'UnitText'
	},
	{
	    name: 'SalePrice', type: 'float'
	},
	{
	    name: 'SalePriceLower'
	},
	{
	    name: 'SalePriceLimit'
	},
	{
	    name: 'TaxWhPrice'
	},
	{
	    name: 'TaxRate'
	},
	{
	    name: 'Tax'
	},
	{
	    name: 'SalesTax'
	},
	{
	    name: 'UnitConvertRate'
	},
	{
	    name: 'AutoFreight'
	},
	{
	    name: 'DriverFreight'
	},
	{
	    name: 'TrainFreight'
	},
	{
	    name: 'ShipFreight'
	},
	{
	    name: 'OtherFeight'
	},
	{
	    name: 'Supplier'
	},
	{
	    name: 'SupplierText'
	},
	{
	    name: 'Origin'
	},
	{
	    name: 'OriginText'
	},
	{
	    name: 'AliasPrice'
	},
	{
	    name: 'IsPlan'
	},
	{
	    name: 'ProductType'
	},
	{
	    name: 'ProductVer'
	},
	{
	    name: 'Remark'
	},
	{
	    name: 'CreateDate'
	},
	{
	    name: 'UpdateDate'
	},
	{
	    name: 'OperId'
	},
	{
	    name: 'OrgId'
}])
	,
    sortData: function(f, direction) {
        var tempSort = Ext.util.JSON.encode(productGridData.sortInfo);
        if (sortInfor != tempSort) {
            sortInfor = tempSort;
            productGridData.baseParams.SortInfo = sortInfor;
            alert(defaultPageSize);
            productGridData.load({ params: { limit: defaultPageSize, start: 0} });
        }
    },
    listeners:
	{
	    scope: this,
	    load: function() {
	    }
	}
});



//        var defaultPageSize = 10;
//        var toolBar = new Ext.PagingToolbar({
//            pageSize: 10,
//            store: productGridData,
//            displayMsg: '��ʾ��{0}����{1}����¼,��{2}��',
//            emptyMsy: 'û�м�¼',
//            displayInfo: true
//        });
//        var pageSizestore = new Ext.data.SimpleStore({
//            fields: ['pageSize'],
//            data: [[10], [20], [30]]
//        });
//        var combo = new Ext.form.ComboBox({
//            regex: /^\d*$/,
//            store: pageSizestore,
//            displayField: 'pageSize',
//            typeAhead: true,
//            mode: 'local',
//            emptyText: '����ÿҳ��¼��',
//            triggerAction: 'all',
//            selectOnFocus: true,
//            width: 135
//        });
//        toolBar.addField(combo);
//        combo.on("change", function(c, value) {
//            toolBar.pageSize = value;
//            defaultPageSize = toolBar.pageSize;
//        }, toolBar);
//        combo.on("select", function(c, record) {
//            toolBar.pageSize = parseInt(record.get("pageSize"));
//            defaultPageSize = toolBar.pageSize;
//            toolBar.doLoad(0);
//        }, toolBar);
        /*------��ʼDataGrid�ĺ��� start---------------*/

        var sm = new Ext.grid.CheckboxSelectionModel({
            singleSelect: false
        });
        var productGrid = new Ext.grid.GridPanel({
            width: '100%',
            height: '100%',
            //autoWidth:true,
            //autoHeight:true,
            autoScroll: true,
            layout: 'fit',
            id: '',
            store: productGridData,
            loadMask: { msg: '���ڼ������ݣ����Ժ��' },
            sm: sm,
            cm: new Ext.grid.ColumnModel([
		sm,
		new Ext.grid.RowNumberer(), //�Զ��к�
		{
		header: '���ID',
		dataIndex: 'ProductId',
		id: 'ProductId',
		hidden: true,
		hideable: false
},
		{
		    header: '������',
		    dataIndex: 'ProductNo',
		    id: 'ProductNo',
		    sortable: true,
		    width: 100
		},
		{
		    header: '�������',
		    dataIndex: 'ProductName',
		    id: 'ProductName',
		    sortable: true,
		    width: 170
		},
		{
		    header: '������',
		    dataIndex: 'MnemonicNo',
		    id: 'MnemonicNo',
		    sortable: true,
		    width: 75
		},
		{
		    header: '����',
		    dataIndex: 'OriginText',
		    id: 'OriginText',
		    sortable: true,
		    width: 80
		},
		{
		    header: '��Ӧ��',
		    dataIndex: 'SupplierText',
		    id: 'SupplierText',
		    sortable: true,
		    width: 150
		},
		{
		    header: '���',
		    dataIndex: 'SpecificationsText',
		    id: 'SpecificationsText',
		    sortable: true,
		    width: 40
		},
		{
		    header: '������',
		    dataIndex: 'UnitConvertRate',
		    id: 'UnitConvertRate',
		    sortable: true,
		    width: 50
		},
		{
		    header: '������λ',
		    dataIndex: 'UnitText',
		    id: 'UnitText',
		    sortable: true,
		    width: 60
		},
		{
		    header: '���۵���',
		    dataIndex: 'SalePrice',
		    id: 'SalePrice',
		    sortable: true,
		    width: 60
		}
		]),tbar: new Ext.Toolbar({
	        items:[{
		        text:"����",
		        icon:"../../Theme/1/images/extjs/customer/add16.gif",
		        handler:function(){		       
		            addTypeProduct();
		        }},'-',{
		        text:"ɾ��",
		        icon:"../../Theme/1/images/extjs/customer/delete16.gif",
		        handler:function(){
		            //deleteSmallClassInfo();
		        }
	        }]
        }),
            bbar: toolBar,
            viewConfig: {
                columnsText: '��ʾ����',
                scrollOffset: 20,
                sortAscText: '����',
                sortDescText: '����',
                forceFit: false
            },
            height: 340,
            closeAction: 'hide',
            stripeRows: true,
            loadMask: true//,
            //autoExpandColumn: 2
        });

/*------viewreport���� start---------------*/
var topPanel = new Ext.Panel({ // raw
              region:'north',
              height:50,
              frame:true,
              item:searchForm
          });
var leftPanel = new Ext.Panel({ 
              region:'west',
              id:'west-panel',
              title:'����㼶��ϵ',
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

var productPanel = new Ext.Panel({
    html:"<iframe id='iframeproduct' width='100%' height='100%' src='frmTypeProductList.aspx?ClassId=0'></iframe>"
});

var rightPanel =	new Ext.Panel({
		region:'center',
		layout:'form',
        items:[detailGrid,productPanel]
});

var bottomPanel = new Ext.Panel(
{
	region:'south'
});
var viewport = new Ext.Viewport({
      layout:'border',
      items:[topPanel,bottomPanel,leftPanel,rightPanel
       ]
  });
//detailGrid.setVisible(false);
/*------viewreport���� end---------------*/

var result = '';
//�������ڵ�
   function tradeNode(node)
       {   
            result='';
           if (node.childNodes && node.childNodes.length>0)
           {
               var child;
               for (var i=0;i<node.childNodes.length;i++)
               {                 
                   child = node.childNodes[i];
                   if (child!=null && child.text.length>0 )
                   {
                       tradeList(child);                     
                   }                    
               }
           }         
       }
        //������һ��������нڵ�
        function tradeList(prant)
       {            
           //����֣�ֻ��չ����ʱ��prant.childNodes.length����ֵ��
           //Ext.Msg.alert('prant.childNodes.length',prant.childNodes.length);
           if(prant.childNodes && prant.childNodes.length>0)
           {
               var list;
               for (var i=0;i<prant.childNodes.length;i++){
                   list = prant.childNodes[i];
                   if(list.leaf)
                   {
                        if(!list.Checked)
                        {
                            if(result.length>0)
                                result+=",";
                            result+=list.id;
                        }
                   }
                   else
                   {
                    tradeList(list);
                   }
               }
           }
       }
       
       /*���������µĲ�Ʒ��Ϣ*/
       
       tree.on('click',function(node){  
        if(node.id ==0){
            detailGrid.getStore().removeAll();
            return;
        }
        //ˢ��grid
        currentNode = node;
        Ext.Ajax.request({
		    url:'frmBaProductTypeForPlan.aspx?method=getModifyType',
		    params:{
			    ClassId:currentNode.id
		    },
	    success: function(resp,opts){
    	    
		    var data=Ext.util.JSON.decode(resp.responseText);
		    if(data.ClassType=='R0102')
		    {
		        detailGrid.setVisible(false);
                productPanel.show();
                document.getElementById("iframeproduct").contentWindow.classId = currentNode.id;
                document.getElementById("iframeproduct").contentWindow.loadData();
		    }
		    else
		    {
		        detailGrid.setVisible(true);
                productPanel.hide();
                dsCalssGridData.baseParams.ClassId = currentNode.id;
                detailGrid.getStore().baseParams.ClassId = currentNode.id;
                detailGrid.getStore().load({
                    params:{
	                       ClassId:currentNode.id,
	                       start : 0,
                           limit : defaultPageSize
	                    }
                });
            }		    
	    },
	    failure: function(resp,opts){
		    Ext.Msg.alert("��ʾ","��ȡ���������Ϣʧ��");
	    }
	    });
        
        
    }); 

})
</script>
</html>
