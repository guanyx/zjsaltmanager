<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmBaProductType.aspx.cs" Inherits="CRM_product_frmBaProductType" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>�������</title>
    <meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
    <link rel="stylesheet" type="text/css" href="../../ext3/resources/css/ext-all.css" />
	<script type="text/javascript" src="../../ext3/adapter/ext/ext-base.js"></script>	
	<script type="text/javascript" src="../../ext3/ext-all.js"></script>
</head>
<body>
   <div id='tree-div'></div>
   <div id='searchDiv'></div>
   <div id ='sdetailForm'></div>
</body>

<%= getComboBoxStore() %>

<script type="text/javascript">
Ext.BLANK_IMAGE_URL = "../../ext3/resources/images/default/s.gif";
Ext.onReady(function(){
    var currentNode;
    /*--------��ѯform���� start  -----------*/
    var isPlanType="0";//�ɹ�����
            
    var orgCombo = new Ext.form.ComboBox({
        fieldLabel: '��֯�ṹ',
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
    
    orgCombo.setValue(<% =ZJSIG.UIProcess.ADM.UIAdmUser.OrgID(this)%>);
    orgCombo.setDisabled(true);
    
    var isCheckBox = new  Ext.form.Checkbox({     //checkbox 
        id:'isCheckBox',
        xtype: 'checkbox',
        checked:false,
        boxLabel:'��ʾ����֯���з���',
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
                    columnWidth: .2,  //����ռ�õĿ�ȣ���ʶΪ20��
                    layout: 'form',
                    border: false,
                    labelWidth: 55,
                    items: [
                        orgCombo
                    ]
                }, {
                    columnWidth: .5,
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
                            treeLoader.baseParams.isPlanType = isPlanType;
                        }, this);
                            tree.root.reload();
                        } 
                   }]   
                },
                {
                    columnWidth: .2,
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
           dataUrl:'frmBaProductType.aspx?method=gettreelist',
           baseParams:{
                orgId:orgCombo.getValue(),
                isAll:isCheckBox.getValue(),
                isPlanType:isPlanType
           }})
    });
    tree.on('click',function(node){  
        if(node.id ==0)
            return;
         setFormValue(node);  
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
          }else{
            rightClick.items.get('deleteItem').enable();
            rightClick.items.get('forbiddenItem').enable();
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
                Ext.getCmp("ClassId").setValue('');
                Ext.getCmp('ParentClassId').setValue(currentNode.id);
		        Ext.getCmp("ParentClassName").setValue(currentNode.text);
		        Ext.getCmp("State").setValue(0);
		        Ext.getCmp("ClassNo").setValue('');
		        Ext.getCmp("ClassName").setValue('');
		        Ext.getCmp("Remark").setValue('');
		        Ext.getCmp("OwenOrg").setValue(<% =ZJSIG.UIProcess.ADM.UIAdmUser.OrgID(this)%>)
            }
        }, {
            id:'deleteItem',
            text : 'ɾ��',
            icon:"../../Theme/1/images/extjs/customer/delete16.gif",
            handler:function (){
                 Ext.Ajax.request({
		            url:'frmBaProductType.aspx?method=deleteProductType',
		            method:'POST',
		            params:{
			            ClassId:currentNode.id
			        },
		            success: function(resp,opts){
			            Ext.Msg.alert("��ʾ","ɾ���ɹ�");
			            //��ǰ�ڵ�ɾ��
			            currentNode.remove();
		            },
		            failure: function(resp,opts){
			            Ext.Msg.alert("��ʾ","ɾ��ʧ��");
		            }
		            });
            }
        }, {
            id:'forbiddenItem',
            text : '��ֹ',
            icon:"../../Theme/1/images/extjs/customer/forbidden16.gif",
            handler:function (){
                 Ext.Ajax.request({
		            url:'frmBaProductType.aspx?method=forbiddenProductType',
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
        }]
     });    

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
function getFormValue()
{
    var state = 0;
    if(Ext.getCmp('State').getValue())
        state =1;
	Ext.Ajax.request({
		url:'frmBaProductType.aspx?method=saveProductType',
		method:'POST',
		params:{
			ClassId:Ext.getCmp('ClassId').getValue(),
			OwenOrg:Ext.getCmp('OwenOrg').getValue(),
			ParentClassId:Ext.getCmp('ParentClassId').getValue(),
			State:state,
			ClassNo:Ext.getCmp('ClassNo').getValue(),
			ClassName:Ext.getCmp('ClassName').getValue(),
			Remark:Ext.getCmp('Remark').getValue() //,
			//CreateDate:Ext.getCmp('CreateDate').getValue(),
			//OperId:Ext.getCmp('OperId').getValue(),
			//OrgId:Ext.getCmp('OrgId').getValue(),
			//ExpireDate:Ext.getCmp('ExpireDate').getValue(),
			//ExpireOperId:Ext.getCmp('ExpireOperId').getValue(),
			//ExpireOrg:Ext.getCmp('ExpireOrg').getValue()		
			},
		success: function(resp,opts){
			Ext.Msg.alert("��ʾ","����ɹ�");
			//ˢ��tree
			tree.root.reload({ 
                baseParams:{
                    orgId:orgCombo.getValue(),
                    isAll:isCheckBox.getValue(),
                    isPlanType:isPlanType
               }
            });
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
		url:'frmBaProductType.aspx?method=getModifyType',
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
		Ext.getCmp("Remark").setValue(data.Remark);
	},
	failure: function(resp,opts){
		Ext.Msg.alert("��ʾ","��ȡ�û���Ϣʧ��");
	}
	});
}
/*------�������ý������ݵĺ��� End---------------*/
    
    /*------��ϸ��Ϣform�ĺ��� start---------------*/    
    var detailForm=new Ext.form.FormPanel({
	title:'������ϸ��Ϣ',
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
			columnWidth:.5
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
					id:'State'//,
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
			columnWidth:1,
			items: [
				{
					xtype:'textfield',
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
			columnWidth:.4
		},
		{
		    layout:'form',
			border: false,
			columnWidth:.2,
			items: [{
			    xtype:'button',
			    text:'����',
			    anchor:'90%',
			    handler:function(){
			        getFormValue();
			    }
			}]			
		},
		{
			layout:'form',
			border: false,
			columnWidth:.4
		}		
    ]}
]
});
    /*------��ϸ��Ϣform�ĺ��� end---------------*/
    

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
    var rightPanel =	new Ext.Panel({
			region:'center',
			layout:'fit',
            items:detailForm
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
    
    /*------viewreport���� end---------------*/

})
</script>
</html>
