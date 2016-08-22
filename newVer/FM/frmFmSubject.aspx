<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmFmSubject.aspx.cs" Inherits="FM_frmFmSubject" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>科目代码维护</title>
    <meta http-equiv="Content-Type" content="text/html; charset=GB2312" />
    <link rel="stylesheet" type="text/css" href="../ext3/resources/css/ext-all.css" />
	<script type="text/javascript" src="../ext3/adapter/ext/ext-base.js"></script>	
	<script type="text/javascript" src="../ext3/ext-all.js"></script>
	<script type="text/javascript" src="../ext3/example/ColumnNodeUI.js"></script>
	<link rel="Stylesheet" type="text/css" href="../ext3/example/ColumnNodeUI.css" />
</head>
<body>
    <div id="tree-div"></div>
</body>

<script type="text/javascript">
Ext.BLANK_IMAGE_URL = "../ext3/resources/images/default/s.gif";  //作为：让下拉框的三角形下拉图片显示
Ext.onReady(function() {
    var currentNode;
    /*------实现tree的函数 start---------------*/
    var subjectTree = new Ext.ux.tree.ColumnTree({
        rootVisible:false,
        autoScroll:true,
        title: '科目关系树',
        el: 'tree-div',
        columns:[{
            header:'科目代码',
            width:330,
            dataIndex:'text'
        },{
            header:'科目名称',
            width:330,
            dataIndex:'CustomerColumn'
        }
        ],
        loader: new Ext.tree.TreeLoader({
            dataUrl:'frmFmSubject.aspx?method=gettreelist',
            uiProviders:{
                'col': Ext.ux.tree.ColumnNodeUI
            }
        }),

        root: new Ext.tree.AsyncTreeNode({
           text: '科目关系树',
            id:'0'
        })
    });
    
    subjectTree.on('click',function(node,event){  
        if(node.id ==0)
            return;
         //setFormValue(node);  
    }); 
   
    subjectTree.on('contextmenu',function(node,event){  
          //alert("node.id="+ node.id);
          currentNode = node;
	      //var selModel = tree.getSelectionModel();
	      //selModel.select(currentNode);  //右键响应定位当前节点，但不响应点击事件
	      currentNode.select();
          event.preventDefault(); //这行是必须的
          //控制右键菜单子菜单
          if(node.id ==0 ){
            rightClick.items.get('deleteItem').disable();
          }else{
            rightClick.items.get('deleteItem').enable();
          }
          rightClick.showAt(event.getXY());//取得鼠标点击坐标，展示菜单
    });
    
    var subjectForm = new Ext.FormPanel({  
        labelAlign: 'right',  
        labelWidth: 80,  
        frame: true,  
        defaultType: 'textfield',  
      
        items : [{  
                fieldLabel: '科目代码',  
                name: 'subjectcode',  
                id: 'subjectcode',  
                allowBlank:false,  
                //vtype:'alphanum',  
                maxLength:20  
                },{  
                fieldLabel: '科目名称',  
                name: 'subjectName',  
                id: 'subjectName',  
                maxLength:30  
        }]  
    });  
    
    
    /*------开始界面数据的窗体 Start---------------*/
    if (typeof (uploadSubjectWindow) == "undefined") {//解决创建2个windows问题
        uploadSubjectWindow = new Ext.Window({
            id: 'subjectformwindow'
		, iconCls: 'upload-win'
		, width: 350
		, height: 200
		, layout: 'fit'
		, plain: true
		, modal: true
		, constrain: true
		, resizable: false
		, closeAction: 'hide'
		, autoDestroy: true
		, items: subjectForm
		, buttons: [{
		    text: "保存"
			, handler: function() {
			    saveSubjectData();
			}
			, scope: this
		},
		{
		    text: "取消"
			, handler: function() {
			    uploadSubjectWindow.hide();
			}
		, scope: this
        }]
        });
    }
    uploadSubjectWindow.addListener("hide", function() {
    });
    
    var saveType="";
    
    //定义右键菜单
    var rightClick = new Ext.menu.Menu({
        id :'rightClickCont',
        items : [{
            id:'addItem',
            text : '新增',
            icon:"../Theme/1/images/extjs/customer/add16.gif",
            //增加菜单点击事件
            handler:function (){
                saveType = 'add';                
                uploadSubjectWindow.show();
                subjectForm.getForm().reset();
                Ext.getCmp("subjectcode").setDisabled(false);
            }
        }, {
            id:'deleteItem',
            text : '修改',
            icon:"../Theme/1/images/extjs/customer/edit16.gif",
            handler:function (){    
                saveType = 'save';    
                Ext.getCmp("subjectcode").setDisabled(true);
                Ext.getCmp("subjectcode").setValue(currentNode.attributes.text);
                Ext.getCmp("subjectName").setValue(currentNode.attributes.CustomerColumn);
                uploadSubjectWindow.show();
            }
        }]
     });    
    // render the tree
    subjectTree.render();
    /*------结束tree的函数 end---------------*/

    function saveSubjectData(){
        if(saveType == 'add'){
            Ext.Ajax.request({
        url:'frmFmSubject.aspx?method=addSubject',
        method:'POST',
        params:{
            SubjectCode:Ext.getCmp('subjectcode').getValue(),
            SubjectName:Ext.getCmp('subjectName').getValue(),
            ParentSubject:currentNode.attributes.id
        },
        success: function(resp,opts){
            Ext.Msg.alert("提示","保存成功");            
            //当前节点            
            var responseData = Ext.decode(resp.responseText);
            var newNode = new Ext.tree.TreeNode({  
                id: responseData.SubjectId,  
                text: Ext.getCmp('subjectcode').getValue(),  
                CustomerColumn:Ext.getCmp('subjectName').getValue(),  
                leaf: true,  
                expanded:false,  
                uiProvider: Ext.tree.ColumnNodeUI  
            });  
            currentNode.leaf= false;  
            currentNode.appendChild(newNode); 
        },
        failure: function(resp,opts){
            Ext.Msg.alert("提示","保存失败");
        }
        });
        }            
        else if(saveType == 'save'){
            Ext.Ajax.request({
            url:'frmFmSubject.aspx?method=saveSubject',
            method:'POST',
            params:{
                SubjectCode:Ext.getCmp('subjectcode').getValue(),
                SubjectName:Ext.getCmp('subjectName').getValue(),
                SubjectId:currentNode.attributes.id
            },
            success: function(resp,opts){
                Ext.Msg.alert("提示","保存成功");            
                //当前节点                
                currentNode.attributes.CustomerColumn = Ext.getCmp('subjectName').getValue();
                var selectedItem = subjectTree.getSelectionModel().getSelectedNode();  
                selectedItem.CustomerColumn = Ext.getCmp('subjectName').getValue();
            },
            failure: function(resp,opts){
                Ext.Msg.alert("提示","保存失败");
            }
            });    
         }
    }
});

</script>

</html>
