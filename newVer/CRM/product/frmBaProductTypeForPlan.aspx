<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmBaProductTypeForPlan.aspx.cs" Inherits="CRM_product_frmBaProductType" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>存货计划分类</title>
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
var Type = getParamerValue('type');//分类种类
</script>
<%= getComboBoxStore() %>

<script type="text/javascript">
parentUrl="frmBaProductTypeForPlan.aspx?method=getbaproducttypetree&ShowSale=true";
Ext.BLANK_IMAGE_URL = "../../ext3/resources/images/default/s.gif";
Ext.onReady(function(){
    var currentNode;
    /*--------查询form定义 start  -----------*/
           
    var orgCombo = new Ext.form.ComboBox({
        fieldLabel: '所属组织',
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
        boxLabel:'细化到具体商品',
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
                layout: 'column',   //定义该元素为布局为列布局方式
                border: false,
                items: [{
                    columnWidth: .4,  //该列占用的宽度，标识为20％
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
                        text: '刷新',
                        id: 'searchebtnId',
                        anchor: '90%',
                        handler: function() {//动态改变树刷新（load）参数
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
    /*--------查询form定义 end  -----------*/
    
    /*------实现tree的函数 start---------------*/
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
	      //selModel.select(currentNode);  //右键响应定位当前节点，但不响应点击事件
	      currentNode.select();
          event.preventDefault(); //这行是必须的
          //控制右键菜单子菜单
          if(node.id ==0 ){
            rightClick.items.get('deleteItem').disable();
            rightClick.items.get('forbiddenItem').disable();
            rightClick.items.get('modifyItem').disable();
          }else{
            rightClick.items.get('deleteItem').enable();
            rightClick.items.get('forbiddenItem').enable();
            rightClick.items.get('modifyItem').enable();
          }
          rightClick.showAt(event.getXY());//取得鼠标点击坐标，展示菜单
    });
    
    //定义右键菜单
    var rightClick = new Ext.menu.Menu({
        id :'rightClickCont',
        items : [{
            id:'addItem',
            text : '新增',
            icon:"../../Theme/1/images/extjs/customer/add16.gif",
            //增加菜单点击事件
            handler:function (){
                //显示并赋值
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
            text : '修改',
            icon:"../../Theme/1/images/extjs/customer/edit16.gif",
            handler:function (){
                //显示并赋值
                uploadTypeWindow.show();
                rightClick.hide();
                if(currentNode.id ==0)
                    return;
                setFormValue(currentNode);  
            }
        }, {
            id:'deleteItem',
            text : '删除',
            icon:"../../Theme/1/images/extjs/customer/delete16.gif",
            handler:function (){
                 //删除前再次提醒是否真的要删除
            Ext.Msg.confirm("提示信息", "是否真的要删除选择的存货分类信息吗？", function callBack(id) {
                //判断是否删除数据
                if (id == "yes") {
                    //页面提交
                    Ext.Ajax.request({
		            url:'frmBaProductTypeForPlan.aspx?method=deleteProductType',
		            method:'POST',
		            params:{
			            ClassId:currentNode.id
			        },
		            success: function(resp,opts){
			            if(checkExtMessage(resp))
			            {
			                //当前节点删除
			                currentNode.remove();
			            }
		            },
		            failure: function(resp,opts){
			            Ext.Msg.alert("提示","删除失败");
		            }
		            });
                }
            });
                 
            }
        }, {
            id:'forbiddenItem',
            text : '禁止',
            icon:"../../Theme/1/images/extjs/customer/forbidden16.gif",
            handler:function (){
                 Ext.Ajax.request({
		            url:'frmBaProductTypeForPlan.aspx?method=forbiddenProductType',
		            method:'POST',
		            params:{
			            ClassId:currentNode.id
			        },
		            success: function(resp,opts){
			            Ext.Msg.alert("提示","禁止成功");
			            //当前节点删除
			            currentNode.remove();
		            },
		            failure: function(resp,opts){
			            Ext.Msg.alert("提示","禁止失败");
		            }
		            });
            }
        }, {
            id:'getChildItem',
            text : '同步子项',
            icon:"../../Theme/1/images/extjs/customer/forbidden16.gif",
            handler:function (){
                 Ext.Ajax.request({
		            url:'frmBaProductTypeForPlan.aspx?method=getchildproduct',
		            method:'POST',
		            params:{
			            ClassId:currentNode.id
			        },
		            success: function(resp,opts){		            
			            Ext.Msg.alert("提示","同步成功");
		            },
		            failure: function(resp,opts){
			            Ext.Msg.alert("提示","同步失败");
		            }
		            });
            }
        }, {
            id:'refreshItem',
            text : '检查',
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
			            Ext.Msg.alert("提示","同步失败");
		            }
		            });
            }
        }, {
            id:'refreshItem1',
            text : '对应组织',
            icon:"../../Theme/1/images/extjs/customer/edit16.gif",
            handler:function (){
                 if(Type!=2) return;   
                 if(orgwin==null){              
                     var orgwin = new Ext.Window ({
                      height: 460, 
                      width: 400, 
                      title: '组织选择', 
                      html: "<iframe id='iframeorg' width='100%' height='100%' src='frmBaProductTypeOrgTree.aspx?classid="+currentNode.id+"'</iframe>",
                      buttons: [{
                        text: "关闭",
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
            text : '同步项目',
            icon:"../../Theme/1/images/extjs/customer/edit16.gif",
            handler:function (){
                 if(Type!=2) return;   
                 if(sameWin==null){   
                 
                    //同步项目时，需要弹出的报表类型
                     treeSame = new Tree.TreePanel({
                            useArrows:true,
                            autoScroll:true,
                            animate:true,
                            autoWidth:true,
                            autoHeight:true,
                            enableDD:false,
                            containerScroll: true, 
                             root:new Tree.AsyncTreeNode({
                                text: '存货分类',
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
                      title: '组织选择', 
                      items:treeSame,
                      buttons: [{
                        text: "确定",
                        handler: function() {
                            if(sameItem==null)
                            {
                                Ext.Msg.alert("没有选择需要同步的项目！");
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
			                    Ext.Msg.alert("提示","同步失败");
		                    }
		                    });
                            sameWin.hide();
                        }},{
                        text: "关闭",
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
        text: '存货分类',
        draggable:false,
        id:'0'
    });
    tree.setRootNode(root);

    // render the tree
    tree.render();
    root.expand();
    
 
/*------结束tree的函数 end---------------*/
/*------开始获取界面数据的函数 start---------------*/
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
			//Ext.Msg.alert("提示","保存成功");
			if(checkExtMessage(resp))
			{
			    //刷新tree
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
			Ext.Msg.alert("提示","保存失败");
		}
		});
		}
/*------结束获取界面数据的函数 End---------------*/

/*------开始界面数据的函数 Start---------------*/
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
		
		//根据key定位下拉框中的value
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
		Ext.Msg.alert("提示","获取报表分类信息失败");
	}
	});
}
/*------结束设置界面数据的函数 End---------------*/
    
/*------详细信息form的函数 start---------------*/    
var detailTypeForm=new Ext.form.FormPanel({
	//title:'分类详细信息',
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
					fieldLabel:'存货分类ID',
					hidden:true,
					hideLabel:true,
					name:'ClassId',
					id:'ClassId'
				},
				{
					xtype:'combo',
					fieldLabel:'所属组织',
					anchor:'90%',
					name:'OwenOrg',
					id:'OwenOrg'
					//store:[[1,'公司'],[2,'其他']],
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
					fieldLabel:'项目类型',
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
					fieldLabel:'父分类ID',
					name:'ParentClassId',
					id:'ParentClassId',
					hidden:true,
					hiddenLabel:true
				},
				{
					xtype:'textfield',
					fieldLabel:'父分类名称',
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
					boxLabel:'启用',
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
					fieldLabel:'分类编号',
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
					fieldLabel:'分类名称',
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
					fieldLabel:'统计单位',
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
					fieldLabel:'分类备注',
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
					boxLabel:'是否需要合计行',
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
					fieldLabel:'排序列',
					anchor:'90%',
					name:'OrderColumn',
					id:'OrderColumn'
				}
		]
		}
	]}
]
});
/*------详细信息form的函数 end---------------*/
    
/*------详细信息window的函数 start---------------*/
if (typeof (uploadTypeWindow) == "undefined") {//解决创建2个windows问题
    uploadTypeWindow = new Ext.Window({
        id: 'uploadTypeWindow',
        title: "采购计划类别维护"
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
            , text: "保存"
            , handler: function() {
                Ext.Msg.confirm("提示信息", "是否确认要保存？", function callBack(id) {
                    //判断是否删除数据
                    if (id == "yes") {
                        //页面提交
                        saveUserData();
                        uploadTypeWindow.hide();
                        
                    }
                });
            }
            , scope: this
        },
        {
            text: "取消"
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

/*------详细信息window的函数 end---------------*/

/*------详细小类配置信息  start -------------*/
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
        displayMsg: '显示第{0}条到{1}条记录,共{2}条',
        emptyMsy: '没有记录',
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
        emptyText: '更改每页记录数',
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
	loadMask: {msg:'正在加载数据，请稍侯……'},
	sm:sm,
	cm: new Ext.grid.ColumnModel([
		sm,
		new Ext.grid.RowNumberer(),//自动行号
		{
			header:'流水号',
			dataIndex:'ClassId',
			id:'ClassId',
			hidden: true,
            hideable: false
		},
		{
			header:'商品编号',
			dataIndex:'ClassNo',
			id:'ClassNo'
		},
		{
			header:'商品名称',
			dataIndex:'ClassName',
			id:'ClassName'
		},
		{
			header:'规格',
			dataIndex:'SpecificationsText',
			id:'SpecificationsText'
		},
		{
			header:'单位',
			dataIndex:'UnitText',
			id:'UnitText'
		},
		{
			header:'创建日期',
			dataIndex:'CreateDate',
			id:'CreateDate',
			renderer: Ext.util.Format.dateRenderer('Y年m月d日')
		}
		]),
		tbar: new Ext.Toolbar({
	        items:[{
		        text:"新增",
		        icon:"../../Theme/1/images/extjs/customer/add16.gif",
		        handler:function(){		       
		        if (selectProductForm == null){		                
		                otherUrlParams = 'ClassId='+currentNode.id;
                        showProductForm("", "", "", true); //显示表单所在窗体
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
                                    ClassDtlId: array.join('-')//传入多项的id串
                                },
                                success: function(resp, opts) {
                                    //var data=Ext.util.JSON.decode(resp.responseText);
                                    Ext.Msg.alert("提示", "保存成功！");
                                    detailGrid.getStore().reload();
                                },
                                failure: function(resp, opts) {
                                    Ext.Msg.alert("提示", "保存失败！");
                                }
                            });
                        });
                    }
                    else {
                     if(otherUrlParams!='ClassId='+currentNode.id)
		            {
		                    var root = new Ext.tree.AsyncTreeNode({
                                text: '商品信息',
                                draggable: false,
                                id: 'source'
                            });
                          selectProductTree.setRootNode(root); 

                        
                        otherUrlParams = 'ClassId='+currentNode.id;
		            }
		            
                        showProductForm("", "", "", true);
                    }
//		            if(currentNode ==null ||currentNode.id <= 0){
//		                alert("请选择分类");
//		                return;
//		            }
//                    uploadClsGridWindow.show();
//                    classesGrid.getStore().load({params:{limit:10,start:0}});
		        }
		        },'-',{
		        text:"删除",
		        icon:"../../Theme/1/images/extjs/customer/delete16.gif",
		        handler:function(){
		            deleteSmallClassInfo();
		        }
	        }]
        }),
		bbar: toolBar,
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

//删除小类
function deleteSmallClassInfo()
{
    var sm = detailGrid.getSelectionModel();
    //var selectData = sm.getSelected();
    var records=sm.getSelections();
    
    if (records == null || records.length == 0) 
    {
        Ext.Msg.alert("提示", "请选中一行！");
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
            ClassDtlId: array.join('-')//传入多想的id串
            },
            success: function(resp, opts) {
                //var data=Ext.util.JSON.decode(resp.responseText);
                Ext.Msg.alert("提示", "删除成功！");
                detailGrid.getStore().reload();
            },
            failure: function(resp, opts) {
                Ext.Msg.alert("提示", "删除失败！");
            }
        });
    }
}   
/*------详细小类配置信息  end -------------*/


/*------新增对应关系列表 start --------------*/
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
	loadMask: {msg:'正在加载数据，请稍侯……'},
	sm:smRel,
	cm: new Ext.grid.ColumnModel([
		sm,
		new Ext.grid.RowNumberer(),//自动行号
		{
			header:'流水号',
			dataIndex:'ClassId',
			id:'ClassId',
			hidden: true,
            hideable: false
		},
		{
			header:'商品编号',
			dataIndex:'ClassNo',
			id:'ClassNo'
		},
		{
			header:'商品名称',
			dataIndex:'ClassName',
			id:'ClassName'
		},
		{
			header:'规格',
			dataIndex:'SpecificationsText',
			id:'SpecificationsText'
		},
		{
			header:'单位',
			dataIndex:'UnitText',
			id:'UnitText'
		},
		{
			header:'创建日期',
			dataIndex:'CreateDate',
			id:'CreateDate',
			format:'Y年m月d日'
		}
		]),
		bbar: new Ext.PagingToolbar({
			pageSize: 10,
			store: dsCalssGridData,
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


/*------新增对应关系列表 start --------------*/

/*------WindowForm 配置开始------------------*/
if (typeof (uploadClsGridWindow) == "undefined") {//解决创建2个windows问题
    uploadClsGridWindow = new Ext.Window({
        id: 'gridwindow',
        title: "新增商品对应"
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
            , text: "保存"
            , handler: function() {
                 saveClassesData();
            }
            , scope: this
        },
        {
            text: "取消"
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
    //var selectData = sm.getSelected(); //这个仅仅是对getSelections.itemAt[0]的封装，对于多选不适用
    var records=sm.getSelections();
    
    if (records == null || records.length == 0) 
    {
        Ext.Msg.alert("提示", "请选中一行！");
    }
    else 
    { 
        Ext.Msg.confirm("提示信息", "确认保存？", function callBack(id) {
                //判断是否删除数据
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
                            ClassDtlId: array.join('-')//传入多项的id串
                        },
                        success: function(resp, opts) {
                            //var data=Ext.util.JSON.decode(resp.responseText);
                            Ext.Msg.alert("提示", "保存成功！");
                            detailGrid.getStore().reload({
                                params:{
                                    ClassId:currentNode.id
                                }
                            });
                            uploadClsGridWindow.hide();
                        },
                        failure: function(resp, opts) {
                            Ext.Msg.alert("提示", "保存失败！");
                        }
                    });
                }
             });
        
       
    }
}
/*------WindowForm 配置开始------------------*/

//分类商品信息
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
//            displayMsg: '显示第{0}条到{1}条记录,共{2}条',
//            emptyMsy: '没有记录',
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
//            emptyText: '更改每页记录数',
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
        /*------开始DataGrid的函数 start---------------*/

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
            loadMask: { msg: '正在加载数据，请稍侯……' },
            sm: sm,
            cm: new Ext.grid.ColumnModel([
		sm,
		new Ext.grid.RowNumberer(), //自动行号
		{
		header: '存货ID',
		dataIndex: 'ProductId',
		id: 'ProductId',
		hidden: true,
		hideable: false
},
		{
		    header: '存货编号',
		    dataIndex: 'ProductNo',
		    id: 'ProductNo',
		    sortable: true,
		    width: 100
		},
		{
		    header: '存货名称',
		    dataIndex: 'ProductName',
		    id: 'ProductName',
		    sortable: true,
		    width: 170
		},
		{
		    header: '助记码',
		    dataIndex: 'MnemonicNo',
		    id: 'MnemonicNo',
		    sortable: true,
		    width: 75
		},
		{
		    header: '产地',
		    dataIndex: 'OriginText',
		    id: 'OriginText',
		    sortable: true,
		    width: 80
		},
		{
		    header: '供应商',
		    dataIndex: 'SupplierText',
		    id: 'SupplierText',
		    sortable: true,
		    width: 150
		},
		{
		    header: '规格',
		    dataIndex: 'SpecificationsText',
		    id: 'SpecificationsText',
		    sortable: true,
		    width: 40
		},
		{
		    header: '换算率',
		    dataIndex: 'UnitConvertRate',
		    id: 'UnitConvertRate',
		    sortable: true,
		    width: 50
		},
		{
		    header: '计量单位',
		    dataIndex: 'UnitText',
		    id: 'UnitText',
		    sortable: true,
		    width: 60
		},
		{
		    header: '销售单价',
		    dataIndex: 'SalePrice',
		    id: 'SalePrice',
		    sortable: true,
		    width: 60
		}
		]),tbar: new Ext.Toolbar({
	        items:[{
		        text:"新增",
		        icon:"../../Theme/1/images/extjs/customer/add16.gif",
		        handler:function(){		       
		            addTypeProduct();
		        }},'-',{
		        text:"删除",
		        icon:"../../Theme/1/images/extjs/customer/delete16.gif",
		        handler:function(){
		            //deleteSmallClassInfo();
		        }
	        }]
        }),
            bbar: toolBar,
            viewConfig: {
                columnsText: '显示的列',
                scrollOffset: 20,
                sortAscText: '升序',
                sortDescText: '降序',
                forceFit: false
            },
            height: 340,
            closeAction: 'hide',
            stripeRows: true,
            loadMask: true//,
            //autoExpandColumn: 2
        });

/*------viewreport布局 start---------------*/
var topPanel = new Ext.Panel({ // raw
              region:'north',
              height:50,
              frame:true,
              item:searchForm
          });
var leftPanel = new Ext.Panel({ 
              region:'west',
              id:'west-panel',
              title:'分类层级关系',
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
/*------viewreport布局 end---------------*/

var result = '';
//遍历根节点
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
        //遍历下一级别的所有节点
        function tradeList(prant)
       {            
           //很奇怪，只有展开的时候prant.childNodes.length才有值。
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
       
       /*新增分类下的产品信息*/
       
       tree.on('click',function(node){  
        if(node.id ==0){
            detailGrid.getStore().removeAll();
            return;
        }
        //刷新grid
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
		    Ext.Msg.alert("提示","获取报表分类信息失败");
	    }
	    });
        
        
    }); 

})
</script>
</html>
