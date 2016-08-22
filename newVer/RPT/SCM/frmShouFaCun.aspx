<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmShouFaCun.aspx.cs" Inherits="RPT_WMS_test" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>无标题页</title>
    <link rel="stylesheet" type="text/css" href="../../ext3/resources/css/ext-all.css" />
    <script type="text/javascript" src="../../ext3/adapter/ext/ext-base.js"></script>
    <script type="text/javascript" src="../../ext3/ext-all.js"></script>
    <script type="text/javascript" src="../../ext3/example/ItemDeleter.js"></script>
    <!--link rel="stylesheet" type="text/css" href="../../css/GroupHeaderPlugin.css" /-->
    <script type="text/javascript" src="../../js/floatUtil.js"></script>
    <!--script type="text/javascript" src="../../js/GroupHeaderPlugin.js"></script-->
    <link rel="stylesheet" href="../../css/Ext.ux.grid.GridSummary.css" />
    <!--script type="text/javascript" src="../../js/FilterControl.js"></script-->
    <script type="text/javascript" src='../../js/Ext.ux.grid.GridSummary.js'></script>
    <link rel="stylesheet" type="text/css" href="../../ext3/example/GroupSummary.css" />
    <script type="text/javascript" src="../../ext3/example/GroupSummary.js"></script>
    <script type="text/javascript" src="../../js/operateResp.js"></script>
    <script type="text/javascript" src="../../ext3/src/locale/ext-lang-zh_CN.js"></script>
    <script type="text/javascript" src="../../js/OrgsSelect.js"></script>
</head>
<body>
    <div id='searchForm'></div>
<div id='mygird'></div>
<%=getComboBoxStore( )%>
</body>
<script type="text/javascript">
Ext.BLANK_IMAGE_URL = "../../ext3/resources/images/default/s.gif";
Ext.onReady(function(){
/*--------------serach--------------*/
//var ArriveOrgPostPanel = new Ext.form.ComboBox({
//    style: 'margin-left:0px',
//    cls: 'key',
//    xtype: 'combo',
//    fieldLabel: '公司',
//    name: 'nameOrg',
//    anchor: '95%',
//    store: dsOrgListInfo,
//    mode: 'local',
//    displayField: 'OrgName',
//    valueField: 'OrgId',
//    triggerAction: 'all',
//    editable: false,
//    value: dsOrgListInfo.getAt(0).data.OrgId
//});

var selectOrgIds = "";
    var ArriveOrgText = new Ext.form.TextField({
        fieldLabel: '公司',
        id: 'orgSelect',
        value: ''
    });

    ArriveOrgText.on("focus", selectOrgType);
    function selectOrgType() {

        if (selectOrgForm == null) {
            var showType = "getcurrentandchildrentree";
            if (orgId == 1) {
                showType = "getcurrentAndChildrenTreeByArea";
            }
            showOrgForm("", "", "../../ba/sysadmin/frmAdmOrgList.aspx?method=" + showType);
            selectOrgForm.buttons[0].on("click", selectOrgOk);
            if (orgId == 1) {
                selectOrgTree.on('checkchange', treeCheckChange, selectOrgTree);
            }
        }
        else {
            showOrgForm("", "", "");
        }
    }
    function selectOrgOk() {
        var selectOrgNames = "";
        selectOrgIds = "";
        var selectNodes = selectOrgTree.getChecked();
        for (var i = 0; i < selectNodes.length; i++) {
            if (selectNodes[i].id.indexOf("A") != -1)
                continue;
            if (selectOrgNames != "") {
                selectOrgNames += ",";
                selectOrgIds += ",";
            }
            selectOrgIds += selectNodes[i].id;
            selectOrgNames += selectNodes[i].text;

        }
        ArriveOrgText.setValue(selectOrgNames);
    }



    function treeCheckChange(node, checked) {
        node.expand();
        node.attributes.checked = checked;
        node.eachChild(function(child) {
            child.ui.toggleCheck(checked);
            child.attributes.checked = checked;
            child.fireEvent('checkchange', child, checked);
        });
        selectOrgTree.un('checkchange', treeCheckChange, selectOrgTree);
        checkParentNode(node);
        selectOrgTree.on('checkchange', treeCheckChange, selectOrgTree);
    }
    function checkParentNode(currentNode) {
        if (currentNode.parentNode != null) {
            var tempNode = currentNode.parentNode;
            //如果是跟节点，就不做处理了
            if (tempNode.parentNode == null)
                return;
            //如果是选择了，那么父节点也必须是出于选择状态的
            if (currentNode.attributes.checked) {
                if (!tempNode.attributes.checked) {
                    tempNode.fireEvent('checkchange', tempNode, true);
                    tempNode.ui.toggleCheck(true);
                    tempNode.attributes.checked = true;

                }
            }
            //取消选择
            else {
                var tempCheck = false;
                tempNode.eachChild(function(child) {
                    if (child.attributes.checked) {
                        tempCheck = true;
                        return;
                    }
                });
                if (!tempCheck) {
                    tempNode.fireEvent('checkchange', tempNode, false);
                    tempNode.ui.toggleCheck(false);
                    tempNode.attributes.checked = false;
                }

            }
            checkParentNode(tempNode);
        }
    }
    function parentNodeChecked(node) {
        if (node.parentNode != null) {
            if (node.attributes.checked) {
                node.parentNode.ui.toggleCheck(checked);
                node.parentNode.attributes.checked = true;
            }
            else {
                for (var i = 0; i < node.parentNode.childNodes.length; i++) {
                    if (node.parentNode.childNodes[i].attributes.checked) {
                        return;
                    }
                }
            }
            parentNodeChecked(node.parentNode);
        }
    }


    //开始日期
    var beginStartDatePanel = new Ext.form.DateField({
        xtype:'datefield',
        fieldLabel:'查询月份',
        anchor:'95%',
        format: 'Y年m月',  //添加中文样式
        value:new Date().getFirstDateOfMonth().clearTime() 
    });
var grid;
    var serchform = new Ext.FormPanel({
        renderTo: 'searchForm',
        labelAlign: 'left',
        // layout:'fit',
        buttonAlign: 'right',
        bodyStyle: 'padding:5px',
        frame: true,
        labelWidth: 55,
        items: [
        {
            layout: 'column',   //定义该元素为布局为列布局方式
            border: false,
            items: [{
                columnWidth: .3,  //该列占用的宽度，标识为20％
                layout: 'form',
                border: false,
                items: [
                    ArriveOrgText
                ]
            },{
                columnWidth: .3,  //该列占用的宽度，标识为20％
                layout: 'form',
                border: false,
                items: [
                    beginStartDatePanel
                ]
            },{
                columnWidth: .2,
                layout: 'form',
                border: false,
                items: [
                { 
                    cls: 'key',
                    xtype: 'button',
                    text: '查询',
                    anchor: '50%',
                    handler: function() {  
//                    var orgId = ArriveOrgText.getValue();
                    var beginStartDate = beginStartDatePanel.getValue();

                    var  startMonth= Ext.util.Format.date(beginStartDate, 'Y-m');

                    var _url = "frmShouFaCun.aspx?method=getlist";
                    var conn = new Ext.data.Connection();
                    conn.request({ 
                        url: _url, params: { startMonth: startMonth,OrgId:selectOrgIds }, 
                        callback: function(options, success, response) {
                        var json = new Ext.util.JSON.decode(response.responseText);
                        var cm = new Ext.grid.ColumnModel(json.colModel);
                        var ds = new Ext.data.JsonStore({
                            data: json.data,
                            fields: json.fieldsNames
                        });
                        if (grid != null) {
                            grid.destroy();
                        }
                        
                        grid = new Ext.grid.GridPanel({
                            //el: 'mygird',
                            split: true,
                            width: document.body.clientWidth-10,
                            height: 400,
                            border: false,
                            store: ds,
                            cm: cm
                        });
                        grid.render('mygird');
                        }
                    });
                   }
                }]
            }]
        }]
    });
//    ArriveOrgPostPanel.setValue(<% =ZJSIG.UIProcess.ADM.UIAdmUser.OrgID(this)%>); 
//    if(ArriveOrgPostPanel.getValue() !=1)
//        ArriveOrgPostPanel.setDisabled(true);
})
</script>
</html>
