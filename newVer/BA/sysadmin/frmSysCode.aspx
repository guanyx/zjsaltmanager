<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmSysCode.aspx.cs" Inherits="BA_sysadmin_frmSysCode" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>��������</title>
    <meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
    <link rel="stylesheet" type="text/css" href="../../ext3/resources/css/ext-all.css" />
	<script type="text/javascript" src="../../ext3/adapter/ext/ext-base.js"></script>	
	<script type="text/javascript" src="../../ext3/ext-all.js"></script>
	<script type="text/javascript" src="../../js/operateResp.js"></script>
	<script type="text/javascript" src="../../js/ProductSelect.js"></script>
	<script type="text/javascript" src="../../js/ExtJsHelper.js"></script>
</head>
<%= getComboBoxStore() %>
<script>
Ext.BLANK_IMAGE_URL = "../../ext3/resources/images/default/s.gif";
Ext.onReady(function(){
    var currentNode;
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
           dataUrl:'frmSysCode.aspx?method=gettreelist',
           baseParams:{
                orgId:orgId
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
            rightClick.items.get('modifyItem').disable();
          }else{
            rightClick.items.get('deleteItem').enable();
            rightClick.items.get('modifyItem').enable();
          }
          rightClick.showAt(event.getXY());//ȡ����������꣬չʾ�˵�
    });
    
    //�����Ҽ��˵�
    var rightClick = new Ext.menu.Menu({
        id :'rightClickCont',
        items : [{
            id:'addItem',
            text : '�����ӽڵ�',
            icon:"../../Theme/1/images/extjs/customer/add16.gif",
            //���Ӳ˵�����¼�
            handler:function (){
                //��ʾ����ֵ
                uploadSysCodeWindow.show();
                Ext.getCmp('CodeParent').setValue(currentNode.id);
                
            }
        }, {
            id:'modifyItem',
            text : '�޸�',
            icon:"../../Theme/1/images/extjs/customer/edit16.gif",
            handler:function (){               
                //��ʾ����ֵ
                uploadSysCodeWindow.show();
                rightClick.hide();
                if(currentNode.id ==0)
                    return;
                setFormValue();  
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
		            url:'frmSysCode.aspx?method=delete',
		            method:'POST',
		            params:{
			            CodeId:currentNode.id
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
        }]
     });    

    // set the root node
    var root = new Tree.AsyncTreeNode({
        text: '������Ϣ',
        draggable:false,
        id:'0'
    });
    tree.setRootNode(root);

    // render the tree
    tree.render();
    root.expand();
    
    var detailTypeForm = new Ext.form.FormPanel({
            items: [
		{
		    xtype: 'hidden',
		    fieldLabel: '��ʶ',
		    columnWidth: 1,
		    anchor: '90%',
		    name: 'CodeId',
		    id: 'CodeId'
		}
, {
    xtype: 'textfield',
    fieldLabel: '��������',
    columnWidth: 1,
    anchor: '90%',
    name: 'CodeName',
    id: 'CodeName'
}
, {
    xtype: 'textfield',
    fieldLabel: '����',
    columnWidth: 1,
    anchor: '90%',
    name: 'CodeNo',
    id: 'CodeNo'

}
, {
    xtype: 'textfield',
    fieldLabel: '�ϼ�����',
    columnWidth: 1,
    anchor: '90%',
    name: 'CodeParentName',
    id: 'CodeParentName'
}, {
    xtype: 'textfield',
    fieldLabel: '��ע',
    columnWidth: 1,
    anchor: '90%',
    name: 'CodeMemo',
    id: 'CodeMemo'

}, {
    xtype: 'hidden',
    columnWidth: 1,
    anchor: '90%',
    name: 'CodeParent',
    id: 'CodeParent'
}]
        });
    /*------��ϸ��Ϣwindow�ĺ��� start---------------*/
if (typeof (uploadSysCodeWindow) == "undefined") {//�������2��windows����
    uploadSysCodeWindow = new Ext.Window({
        id: 'uploadTypeWindow',
        title: "����ά��"
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
                        uploadSysCodeWindow.hide();                        
                        
                    }
                });
            }
            , scope: this
        },
        {
            text: "ȡ��"
            , handler: function() {
                uploadSysCodeWindow.hide();
            }
            , scope: this
        }]
    });
}

uploadSysCodeWindow.addListener("hide", function() {
    detailTypeForm.getForm().reset();
});

function saveUserData()
{
    getFormValue();
}
function getFormValue() {
            Ext.MessageBox.wait('���ڱ���������, ���Ժ򡭡�');
            Ext.Ajax.request({
                url: 'frmSysCode.aspx?method=save',
                method: 'POST',
                params: {
                    CodeId: Ext.getCmp('CodeId').getValue(),
                    CodeName: Ext.getCmp('CodeName').getValue(),
                    CodeNo: Ext.getCmp('CodeNo').getValue(),
                    CodeParent: Ext.getCmp('CodeParent').getValue(),
                    CodeMemo: Ext.getCmp('CodeMemo').getValue()
                },
                success: function(resp, opts) {
                    Ext.MessageBox.hide();
                    if (checkExtMessage(resp)) {
                        uploadSysCodeWindow.hide();
                        tree.getLoader().on("beforeload", function(treeLoader, node) {
                            treeLoader.baseParams.orgId = orgId;
                        }, this);
                            tree.root.reload();
                    }
                },
                failure: function(resp, opts) {
                    Ext.MessageBox.hide();
                    Ext.Msg.alert("��ʾ", "����ʧ��");
                }
            });
        }
        /*------������ȡ�������ݵĺ��� End---------------*/

        /*------��ʼ�������ݵĺ��� Start---------------*/
        function setFormValue(selectData) {
            Ext.Ajax.request({
                url: 'frmSysCode.aspx?method=getcode',
                params: {
                    CodeId: currentNode.id
                },
                success: function(resp, opts) {
                    var data = Ext.util.JSON.decode(resp.responseText);
                    if(data.OrgId=="1")
                    {
                        Ext.Msg.alert("��ʾ","ʡ��˾���õ����ݣ������޸ģ�");
                        uploadSysCodeWindow.hide();
                    }
                    Ext.getCmp("CodeId").setValue(data.CodeId);
                    Ext.getCmp("CodeName").setValue(data.CodeName);
                    Ext.getCmp("CodeNo").setValue(data.CodeNo);
                    Ext.getCmp("CodeParent").setValue(data.CodeParent);
                    Ext.getCmp("CodeMemo").setValue(data.CodeMemo);

                },
                failure: function(resp, opts) {
                    Ext.Msg.alert("��ʾ", "��ȡ������Ϣʧ��");
                }
            });
        }
})
</script>
<body>
    <form id="form1" runat="server">
    <div id='tree-div'>
    
    </div>
    </form>
</body>
</html>
