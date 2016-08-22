<%@ Page Language="C#" AutoEventWireup="true" CodeFile="changeDept.aspx.cs" Inherits="changeDept" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>部门切换</title>
    <link rel="stylesheet" type="text/css" href="ext3/resources/css/ext-all.css" />

    <script type="text/javascript" src="ext3/adapter/ext/ext-base.js"></script>

    <script type="text/javascript" src="ext3/ext-all.js"></script>

    <script type="text/javascript" src="js/operateResp.js"></script>

</head>
<body>
    <div style="width: 300px; margin: 15px 0px 0px 15px;">
        <font size='1'><span>切换至：</span><span id='currentDept' style="display: inline-block;
            width: 100px;">请选择</span><span><input type="button" onclick="javascript:submitChange();"
                style="display: inline; vertical-align: middle;" value="确定" /></span></font>
    </div>
    <div id="treeExpend" style="width: 250px; margin: 5px 0px 0px 5px;" mce_style="margin:5px 0px 0px 5px;">
    </div>
</body>

<script>
Ext.BLANK_IMAGE_URL = "ext3/resources/images/default/s.gif";
Ext.onReady(function(){  
    var selectId ="";
    //动态加载节点  
    var treeLoader = new Ext.tree.TreeLoader({dataUrl: ""});  
      
    var treeexpend = new Ext.tree.TreePanel({  
        renderTo: "treeExpend",  
        useArrows: true,  
        autoScroll: true,  
        animate: true,  
        enableDD: false,//不允许拖动  
        containerScroll: true,  
        border: false,  
        loader: treeLoader,  
        root: {  
            nodeType: 'async',  
            text: '部门列表',  
            draggable: false,  
            expended: true,  
            id: '-1'  
        },  
        listeners: {  
            click: function(n){  
                //Ext.Msg.alert("Click Message","You clicked: "+n.attributes.text+"  NO. "+n.attributes.id);  
                if(node.attributes.id ==-1) return;
                var div = Ext.get("currentDept");  
                div.dom.innerHTML=n.attributes.text;
                div.highlight();  
                 selectId = n.attributes.id;
            }  
        }  
    });  
    treeexpend.on('beforeload',   
        function(node){   
           treeexpend.loader.dataUrl="changeDept.aspx?method=gettree&parId="+node.id;    //定义子节点的Loader     
        });
    treeexpend.on('checkchange', function(node, checked) {               
        node.attributes.checked = checked;   
        var chs  = treeexpend.getChecked();  
        for(var i = 0; i < chs.length; i++) {  
            if (chs[i].attributes['id'] != node.attributes['id']){  
                chs[i].ui.toggleCheck(!checked);   
            }      
        };
        var div = Ext.get("currentDept");  
        div.dom.innerHTML=node.attributes.text;
        div.highlight();  
         selectId = node.attributes.id;
    });    
    //tree.getRootNode().expand();   
    this.submitChange=function(){   
        Ext.MessageBox.wait("数据正在保存，请稍候……");
        //然后传入参数保存
        Ext.Ajax.request({
            url: 'changeDept.aspx?method=applyChange',
            method: 'POST',
            params: {
            //明细参数
                DestDept: selectId
            },
            success: function(resp,opts){ 
                Ext.MessageBox.hide();
                if( checkExtMessage(resp,parent) )
                 {       
                    top.refreshDepartment(Ext.get("currentDept").dom.innerHTML);              
                 }
               },
            failure: function(resp,opts){  
                Ext.MessageBox.hide();
                Ext.Msg.alert("提示","保存失败");     
            }

       
        });
    }
}); 
</script>

</html>
