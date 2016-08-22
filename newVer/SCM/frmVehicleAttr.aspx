<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmVehicleAttr.aspx.cs" Inherits="SCM_frmVehicleAttr" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html>
<head>
<title>车辆管理</title><meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<link rel="stylesheet" type="text/css" href="../ext3/resources/css/ext-all.css" />
<script type="text/javascript" src="../ext3/adapter/ext/ext-base.js"></script>
<script type="text/javascript" src="../ext3/ext-all.js"></script>
<script type="text/javascript" src="../js/operateResp.js"></script>
<script type="text/javascript" src="../ext3/src/locale/ext-lang-zh_CN.js"></script>
</head>
<body>
<div id='toolbar'></div>
<div id='divForm'></div>
<div id='divQryForm'></div>
<div id='vehicleGrid'></div>
 <!--    这样可能会得不到值，那么最简单就是设置下拉框的store为json数据源 
 <div style="display:none">
    <select id='comboStatus' >
    <option value='1'>有效</option>
    <option value='0'>无效</option>
</select>
</div>
--> 
</body>

<!-- 所有数据源打印到这里 dsOrgList-->
<%= getComboBoxStore() %>

<script type="text/javascript">
Ext.BLANK_IMAGE_URL = "../ext3/resources/images/default/s.gif";  //作为：让下拉框的三角形下拉图片显示
Ext.onReady(function(){

/* 这种方式摒弃，采用参考文档中说的，用response写到页面, 见上面数据源打印
        var dsOrgList; //下拉框测试
        if (dsOrgList == null) { //防止重复加载
            dsOrgList = new Ext.data.JsonStore({
                totalProperty: "result",
                root: "root",
                url: 'frmVehicleAttr.aspx?method=getOrgList',
                fields: ['discode', 'disname']
            });
            dsOrgList.load();
        }
*/
  
        
var saveType="";
        /*------实现toolbar的函数 start---------------*/
        var Toolbar = new Ext.Toolbar({
	        renderTo:"toolbar",
	        items:[{
		        text:"新增",
		        icon:"../Theme/1/images/extjs/customer/add16.gif",
		        handler:function(){
		            saveType="add";
		            openAddAttrWin();
		        }
		        },'-',{
		        text:"编辑",
		        icon:"../Theme/1/images/extjs/customer/delete16.gif",
		        handler:function(){
		            saveType="update";
		            modifyAttrWin();
		        }
//		        },'-',{
//		        text:"删除",
//		        icon:"../Theme/1/images/extjs/customer/edit16.gif",
//		        handler:function(){
//		           deleteAttr();
//		        }
	        }]
        });
        /*------结束toolbar的函数 end---------------*/
        

        /*------开始ToolBar事件函数 start---------------*//*-----新增Attr实体类窗体函数----*/
        function QueryDataGrid() {
            //页面提交
            gridDataData.baseParams.VehicleId = Ext.getCmp('QryVehicleId').getValue();
            gridDataData.baseParams.VehicleName = Ext.getCmp('QryVehicleName').getValue();
            gridDataData.baseParams.OrgId = Ext.getCmp('QryOrgId').getValue();
            gridDataData.baseParams.VehicleNo = Ext.getCmp('QryVehicleNo').getValue();
            
            gridDataData.load({
                params : {
                start : 0,
                limit : 10	        
                
                } });
        }
        
        
        function openAddAttrWin() {
	        Ext.getCmp('VehicleId').setValue(""),
	        Ext.getCmp('VehicleName').setValue(""),
	        Ext.getCmp('OrgId').setValue(""),
	        Ext.getCmp('VehicleNo').setValue(""),
	        Ext.getCmp('VehicleType').setValue(""),
	        Ext.getCmp('VehicleTon').setValue(""),
	        Ext.getCmp('MinQty').setValue(""),
	        Ext.getCmp('MaxQty').setValue(""),
	        Ext.getCmp('DefDlvId').setValue(""),
	        Ext.getCmp('DefDriver').setValue(""),
	        Ext.getCmp('OperId').setValue(""),
//	        Ext.getCmp('CreateDate').setValue(""),
//	        Ext.getCmp('UpdateDate').setValue(""),
	        Ext.getCmp('OwnerId').setValue(""),
	        Ext.getCmp('Remark').setValue(""),
	        Ext.getCmp('IsActive').setValue("1"),
	        uploadAttrWindow.show(); 
	        Ext.getCmp("OrgId").setValue(<% =ZJSIG.UIProcess.ADM.UIAdmUser.OrgID(this)%>);
            Ext.getCmp("OrgId").setDisabled(true);
        }
        /*-----编辑Attr实体类窗体函数----*/
        function modifyAttrWin() {
	        var sm = Ext.getCmp('gridData').getSelectionModel();
	        //获取选择的数据信息
	        var selectData =  sm.getSelected();
	        if(selectData == null){
		        Ext.Msg.alert("提示","请选中需要编辑的信息！");
		        return;
	        }
	        uploadAttrWindow.show();
	        setFormValue(selectData);
        }
        /*-----删除Attr实体函数----*/
        /*删除信息*/
        function deleteAttr()
        {
	        var sm = Ext.getCmp('gridData').getSelectionModel();
	        //获取选择的数据信息
	        var selectData =  sm.getSelected();
	        //如果没有选择，就提示需要选择数据信息
	        if(selectData == null){
		        Ext.Msg.alert("提示","请选中需要删除的信息！");
		        return;
	        }
	        //删除前再次提醒是否真的要删除
	        Ext.Msg.confirm("提示信息","是否真的要删除选择的记录吗？",function callBack(id){
		        //判断是否删除数据
		        if(id=="yes")
		        {
			        //页面提交
			        Ext.Ajax.request({
				        url:'frmVehicleAttr.aspx?method=delete',
				        method:'POST',
				        params:{
					        VehicleId:selectData.data.VehicleId
				        },
				        success: function(resp,opts){
					        Ext.Msg.alert("提示","数据删除成功");
					        gridData.getStore().reload();
				        },
				        failure: function(resp,opts){
					        Ext.Msg.alert("提示","数据删除失败");
				        }
			        });
			        //需要重新刷新界面
			        //QueryDataGrid();
		        }
	        });
        }

        /*------实现FormPanle的函数 start---------------*/
        var VehicleAttr=new Ext.form.FormPanel({
//	        url:'url',
//	        renderTo:'divForm',
	        frame:true,
	        title:'',
	        items:[
	        
	        /*
	        {
		        layout:'column',   //隐藏字段没有必要单独列一行，直接放在其他随便哪行，我们先把它放在名称统一行
		        border: false,
		        labelSeparator: '：',
		        items: [
		        {
			        layout:'form',
			        border: false,
			        columnWidth:1,
			        items: [
				        {
					        xtype:'hidden',     //该字段应该是隐藏的,先设置为hidden字段
					        fieldLabel:'车辆标识',
					        //anchor:'90%',          //既然是隐藏，就没有必要设置占父容器空间的百分比
					        name:'VehicleId',
					        id:'VehicleId',
					        hideLabel:true  //该字段应该是隐藏的,然后把前面的label同时隐藏
				        }
		        ]
		        }
	        ]},  */
	        {
		        layout:'column',
		        border: false,
		        labelSeparator: '：',
		        items: [
		        {
			        layout:'form',
			        border: false,
			        columnWidth:0.5,
			        items: [
			            {
					        xtype:'hidden',     //该字段应该是隐藏的,先设置为hidden字段
					        fieldLabel:'车辆标识',
					        //anchor:'90%',          //既然是隐藏，就没有必要设置占父容器空间的百分比
					        name:'VehicleId',
					        id:'VehicleId',
					        hideLabel:true  //该字段应该是隐藏的,然后把前面的label同时隐藏
				        },
				        {
					        xtype:'textfield',
					        fieldLabel:'名称*',
					        columnWidth:0.5,
					        anchor:'90%',
					        name:'VehicleName',
					        id:'VehicleName'
				        }
		        ]
		        },
		        {
			        layout:'form',
			        border: false,
			        columnWidth:0.5,
			        items: [
				        {
					        xtype:'combo',
					        fieldLabel:'公司标识',
					        columnWidth:0.5,
					        anchor:'90%',
					        name:'OrgId',
					        id:'OrgId',
			                        store: dsOrgList,
                                    displayField: 'OrgName',     //这个字段和业务实体中字段同名
                                    valueField: 'OrgId',         //这个字段和业务实体中字段同名
                                    typeAhead: true, //自动将第一个搜索到的选项补全输入
                                    triggerAction: 'all',
                                    emptyText: '请选择',
                                    emptyValue: '',
                                    selectOnFocus: true,
                                    forceSelection: true,
                                    editable:false,
                                    mode:'local'           //这个属性设定从本页获取数据源，才能够赋值定位
				        }
		        ]
		        }
	        ]},
	        {
		        layout:'column',
		        border: false,
		        labelSeparator: '：',
		        items: [
		        {
			        layout:'form',
			        border: false,
			        columnWidth:0.5,
			        items: [
				        {
					        xtype:'textfield',
					        fieldLabel:'车牌号*',
					        columnWidth:0.5,
					        anchor:'90%',
					        name:'VehicleNo',
					        id:'VehicleNo'
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
					        fieldLabel:'车型',
					        columnWidth:0.5,
					        anchor:'90%',
					        name:'VehicleType',
					        id:'VehicleType'
				        }
		        ]
		        }
	        ]},
	        {
		        layout:'column',
		        border: false,
		        labelSeparator: '：',
		        items: [
		        {
			        layout:'form',
			        border: false,
			        columnWidth:0.5,
			        items: [
				        {
					        xtype:'numberfield',
					        fieldLabel:'下限容量*',
					        columnWidth:0.5,
					        anchor:'90%',
					        name:'MinQty',
					        id:'MinQty'
				        }
		        ]
		        }
        ,		{
			        layout:'form',
			        border: false,
			        columnWidth:0.5,
			        items: [
				        {
					        xtype:'numberfield',
					        fieldLabel:'上限容量*',
					        columnWidth:0.5,
					        anchor:'90%',
					        name:'MaxQty',
					        id:'MaxQty'
				        }
		        ]
		        }
	        ]},
	        {
		        layout:'column',
		        border: false,
		        labelSeparator: '：',
		        items: [
		        {
			        layout:'form',
			        border: false,
			        columnWidth:0.5,
			        items: [
				        {
					        xtype:'numberfield',
					        fieldLabel:'吨位',
					        columnWidth:0.5,
					        anchor:'90%',
					        name:'VehicleTon',
					        id:'VehicleTon'
				        }
		        ]
		        }
        ,		
		        {		        
			        layout:'form',
			        border: false,
			        columnWidth:0.5,
			        items: [
				        {
					        xtype:'hidden',
					        fieldLabel:'默认送货员',
					        columnWidth:0.5,
					        anchor:'90%',
					        name:'DefDlvId',
					        id:'DefDlvId',
					        hideLabel:true
				        }
		        ]
		        }
        ,		{
			        layout:'form',
			        border: false,
			        columnWidth:0.5,
			        hidden:true,
			        items: [
				        {
					        xtype:'combo',
					        fieldLabel:'默认驾驶员标识',
					        columnWidth:0.5,
					        anchor:'90%',
					        name:'DefDriver',
					        hidden:true,
					        id:'DefDriver'
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
					        xtype:'hidden',
					        fieldLabel:'操作员',
					        anchor:'90%',
					        name:'OperId',
					        id:'OperId',
					        hideLabel:true
				        }
		        ]
		        }
        ,		{
			        layout:'form',
			        border: false,
			        columnWidth:0.5,
			        items: [
				        {
					        xtype:'hidden',
					        fieldLabel:'创建时间',
					        anchor:'90%',
					        name:'CreateDate',
					        id:'CreateDate',
					        //format: 'Y年m月d日',  //添加中文样式
                            //value:(new Date()).clearTime() ,
                            hideLabel:true
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
					        xtype:'hidden',       //直接设置为hidden字段
					        fieldLabel:'修改时间',
					        columnWidth:1,
					        anchor:'90%',
					        name:'UpdateDate',
					        hideLabel:true,
					        id:'UpdateDate',
                            format: 'Y年m月d日'
					        
				        }
		        ]
		        }
	        ]},
	        {
		        layout:'column',
		        border: false,
		        labelSeparator: '：',
		        items: [
		        {
			        layout:'form',
			        border: false,
			        columnWidth:1,
			        hidden:true,
			        items: [
				        {
					        xtype:'combo',
					        fieldLabel:'所有者',
					        columnWidth:1,
					        anchor:'90%',
					        name:'OwnerId',
					        hidden:true,
					        id:'OwnerId'
				        }
		        ]
		        }
	        ]},
	        {
		        layout:'column',
		        border: false,
		        labelSeparator: '：',
		        items: [
		        {
			        layout:'form',
			        border: false,
			        columnWidth:1,
			        items: [
				        {
					        xtype:'textarea',   //这个设置成textarea类型
					        fieldLabel:'备注',
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
		        labelSeparator: '：',
		        items: [
		        {
			        layout:'form',
			        border: false,
			        columnWidth:1,		
			        hidden:false,	        
			        items: [
				        {
					        xtype:'combo',
					        fieldLabel:'是否有效',
					        anchor:'50%',
					        name:'IsActive',
					        hidden:false,
					        id:'IsActive',					        
					        //transform: 'comboStatus',  //不采用这种方式
					        store:[[1,'有效'],[0,'无效']], //简单就这样处理，如果复杂，则像组织列表dsOrgList处理，从response输出到页面
					        typeAhead: false,
                            triggerAction: 'all',
                            lazyRender: true,
                            editable: false	
				        }
		        ]
		        }
	        ]
	        }
        ]
        });
        /*------FormPanle的函数结束 End---------------*/
        
        /*------实现查询divQryForm的函数 start---------------*/
        var QryVehicleAttr=new Ext.form.FormPanel({
	        url:'url',
	        renderTo:'divQryForm',
	        frame:true,
	        title:'',
	        items:[
	            {
		            layout:'column',
		            border: false,
		            labelSeparator: '：',
		            items: [
		                {
			                layout:'form',
			                border: false,
			                columnWidth:0.4,
			                items: [{
					                xtype:'textfield',
					                fieldLabel:'车辆标识',
					                columnWidth:1,
					                anchor:'90%',
					                name:'QryVehicleId',
					                id:'QryVehicleId'
				                }]
				         },
				         {
			                layout:'form',
		                    border: false,
		                    columnWidth:0.4,
		                    items: [{
				                    xtype:'textfield',
					                fieldLabel:'名称',
					                columnWidth:0.5,
					                anchor:'90%',
					                name:'QryVehicleName',
					                id:'QryVehicleName'
				                }]
		                  },
				         {
			                layout:'form',
		                    border: false,
		                    columnWidth:0.2,
		                    html:'&nbsp'
		                  }
		                ]
		         },
		         {
		            layout:'column',
		            border: false,
		            items: [
		                {
			                layout:'form',
			                border: false,
			                columnWidth:0.4,
			                items: [{
					                xtype:'combo',
			                        fieldLabel:'公司标识',
			                        anchor:'90%',
			                        name:'QryOrgId',
			                        id:'QryOrgId',
			                        store: dsOrgList,
                                    displayField: 'OrgName',  //这个字段和业务实体中字段同名
                                    valueField: 'OrgId',      //这个字段和业务实体中字段同名
                                    typeAhead: true, //自动将第一个搜索到的选项补全输入
                                    triggerAction: 'all',
                                    emptyText: '请选择',
                                    emptyValue: '',
                                    selectOnFocus: true,
                                    forceSelection: true,
                                    mode:'local'        //这个属性设定从本页获取数据源，才能够赋值定位
                
				                }]
				         },
				         {
			                layout:'form',
		                    border: false,
		                    columnWidth:0.4,
		                    items: [{
				                    xtype:'textfield',
			                        fieldLabel:'车牌号',
			                        anchor:'90%',
			                        name:'QryVehicleNo',
			                        id:'QryVehicleNo'
				                }]
		                  },
				         {
			                layout:'form',
		                    border: false,
		                    columnWidth:0.2,
		                    items: [{
				                    cls: 'key',
                                    xtype: 'button',
                                    text: '查询',
                                    id: 'searchebtnId',
                                    anchor: '30%',
                                    handler: function() {QueryDataGrid();}
				                }]
		                  }
		                ]
		         }
		    ]
		    
        });
        /*------FormPanle的函数结束 End---------------*/

        /*------开始界面数据的窗体 Start---------------*/
        if(typeof(uploadAttrWindow)=="undefined"){//解决创建2个windows问题
	        uploadAttrWindow = new Ext.Window({
		        id:'Attrformwindow',
		        title:'配送车辆维护'
		        , iconCls: 'upload-win'
		        , width: 600
		        , height: 350
		        , layout: 'fit'
		        , plain: true
		        , modal: true
		        , x:50
		        , y:50
		        , constrain:true
		        , resizable: false
		        , closeAction: 'hide'
		        ,autoDestroy :true
		        ,items:VehicleAttr
		        ,buttons: [{
			        text: "保存"
			        , handler: function() {
				        getFormValue();
			        }
			        , scope: this
		        },
		        {
			        text: "取消"
			        , handler: function() { 
				        uploadAttrWindow.hide();
				        gridDataData.reload();
			        }
			        , scope: this
		        }]});
	        }
	        uploadAttrWindow.addListener("hide",function(){
        });

        /*------开始获取界面数据的函数 start---------------*/
        function getFormValue()
        {
	        Ext.Ajax.request({
		        url:'frmVehicleAttr.aspx?method='+saveType,
		        method:'POST',
		        params:{
			        VehicleId:Ext.getCmp('VehicleId').getValue(),
			        VehicleName:Ext.getCmp('VehicleName').getValue(),
			        OrgId:Ext.getCmp('OrgId').getValue(),
			        VehicleNo:Ext.getCmp('VehicleNo').getValue(),
			        VehicleType:Ext.getCmp('VehicleType').getValue(),
			        VehicleTon:Ext.getCmp('VehicleTon').getValue(),
			        MinQty:Ext.getCmp('MinQty').getValue(),
			        MaxQty:Ext.getCmp('MaxQty').getValue(),
			        DefDlvId:Ext.getCmp('DefDlvId').getValue(),
			        DefDriver:Ext.getCmp('DefDriver').getValue(),
			        OperId:Ext.getCmp('OperId').getValue(),
			        //CreateDate:Ext.getCmp('CreateDate').getValue(),   //这里日期需要像参考文档中处理一下，如下行
			        //CreateDate:Ext.getCmp('CreateDate').getValue().toLocaleDateString(),  //这里
			        UpdateDate:Ext.getCmp('UpdateDate').getValue(),   
			        OwnerId:Ext.getCmp('OwnerId').getValue(),
			        Remark:Ext.getCmp('Remark').getValue(),
			        IsActive:Ext.getCmp('IsActive').getValue()		},			     

	                success: function(resp,opts){ 
                            if( checkExtMessage(resp) ) 
                                    gridDataData.load();
                                   //uploadAttrWindow.hide();
                           },
                    failure: function(resp,opts){  Ext.Msg.alert("提示","保存失败");     }
		        
		        });
		        }
        /*------结束获取界面数据的函数 End---------------*/

        /*------开始界面数据的函数 Start---------------*/
        function setFormValue(selectData)
        {
	        Ext.Ajax.request({
		        url:'frmVehicleAttr.aspx?method=getattr',
		        params:{
			        VehicleId:selectData.data.VehicleId
		        },
	        success: function(resp,opts){
		        var data=Ext.util.JSON.decode(resp.responseText);
		        Ext.getCmp("VehicleId").setValue(data.VehicleId);
		        Ext.getCmp("VehicleName").setValue(data.VehicleName);
		        Ext.getCmp("OrgId").setValue(data.OrgId);
		        Ext.getCmp("VehicleNo").setValue(data.VehicleNo);
		        Ext.getCmp("VehicleType").setValue(data.VehicleType);
		        Ext.getCmp("VehicleTon").setValue(data.VehicleTon);
		        Ext.getCmp("MinQty").setValue(data.MinQty);
		        Ext.getCmp("MaxQty").setValue(data.MaxQty);
		        Ext.getCmp("DefDlvId").setValue(data.DefDlvId);
		        Ext.getCmp("DefDriver").setValue(data.DefDriver);
		        Ext.getCmp("OperId").setValue(data.OperId);     //出错原因之一：1899-12-30 1:00:00 非法时间，另外中间‘-’分隔符js不认，换成‘/’
		        //Ext.getCmp("CreateDate").setValue(data.CreateDate);
		        Ext.getCmp("CreateDate").setValue((new Date(data.CreateDate.replace(/-/g,"/"))));
//		        Ext.getCmp("UpdateDate").setValue(data.UpdateDate.clearTime());   
		        Ext.getCmp("OwnerId").setValue(data.OwnerId);
		        Ext.getCmp("Remark").setValue(data.Remark);
		        Ext.getCmp("IsActive").setValue(data.IsActive);
	        },
	        failure: function(resp,opts){
		        Ext.Msg.alert("提示","获取信息失败");
	        }
	        });
        }
        /*------结束设置界面数据的函数 End---------------*/

        /*------开始获取数据的函数 start---------------*/
        var gridDataData = new Ext.data.Store
        ({
        url: 'frmVehicleAttr.aspx?method=Query',
        reader:new Ext.data.JsonReader({
	        totalProperty:'totalProperty',
	        root:'root'
        },[
	        {
		        name:'VehicleId'
	        },
	        {
		        name:'VehicleName'
	        },
	        {
		        name:'OrgId'
	        },
	        {
		        name:'VehicleNo'
	        },
	        {
		        name:'VehicleType'
	        },
	        {
		        name:'VehicleTon'
	        },
	        {
		        name:'MinQty'
	        },
	        {
		        name:'MaxQty'
	        },
	        {
		        name:'DefDlvId'
	        },
	        {
		        name:'DefDriver'
	        },
	        {
		        name:'OperId'
	        },
	        {
		        name:'CreateDate'
	        },
	        {
		        name:'UpdateDate'
	        },
	        {
		        name:'OwnerId'
	        },
	        {
		        name:'Remark'
	        },
	        {
		        name:'IsActive'
	        }	])
	        ,
	        listeners:
	        {
		        scope:this,
		        load:function(){
		        }
	        }
        });

        /*------获取数据的函数 结束 End---------------*/

        /*------开始DataGrid的函数 start---------------*/

        var sm= new Ext.grid.CheckboxSelectionModel({
	        singleSelect:true
        });
        var gridData = new Ext.grid.GridPanel({
	        el: 'vehicleGrid',
	        width:'100%',
	        height:'100%',
	        autoWidth:true,
	        autoHeight:true,
	        autoScroll:true,
	        layout: 'fit',
	        id: 'gridData',
	        store: gridDataData,
	        loadMask: {msg:'正在加载数据，请稍侯……'},
	        sm:sm,
	        cm: new Ext.grid.ColumnModel([
		        sm,
		        new Ext.grid.RowNumberer(),//自动行号
		        {
			        header:'车辆标识',
			        dataIndex:'VehicleId',
			        id:'VehicleId'
		        },
		        {
			        header:'名称',
			        dataIndex:'VehicleName',
			        id:'VehicleName'
		        },
//		        {
//			        header:'公司标识',
//			        dataIndex:'OrgId',
//			        id:'OrgId'
//		        },
		        {
			        header:'车牌号',
			        dataIndex:'VehicleNo',
			        id:'VehicleNo'
		        },
		        {
			        header:'车型',
			        dataIndex:'VehicleType',
			        id:'VehicleType'
		        },
		        {
			        header:'载重量(吨)',
			        dataIndex:'VehicleTon',
			        id:'VehicleTon'
		        },
		        {
			        header:'下限容量(吨)',
			        dataIndex:'MinQty',
			        id:'MinQty'
		        },
		        {
			        header:'上限容量(吨)',
			        dataIndex:'MaxQty',
			        id:'MaxQty'
		        },
//		        {
//			        header:'默认送货员标识',
//			        dataIndex:'DefDlvId',
//			        id:'DefDlvId'
//		        },
//		        {
//			        header:'默认驾驶员标识',
//			        dataIndex:'DefDriver',
//			        id:'DefDriver'
//		        },
//		        {
//			        header:'操作员',
//			        dataIndex:'OperId',
//			        id:'OperId'
//		        },
		        {
			        header:'创建时间',
			        dataIndex:'CreateDate',
			        id:'CreateDate',
                   //renderer: function(v){return (new Date(Date.parse(v.replace(/-/g,"/")))).toLocaleDateString()}
			       renderer: Ext.util.Format.dateRenderer('Y年m月d日')
			       
                            
//		        },
//		        {
//			        header:'修改时间',
//			        dataIndex:'UpdateDate',
//			        id:'UpdateDate'
//		        },
//		        {
//			        header:'所有者',
//			        dataIndex:'OwnerId',
//			        id:'OwnerId'
//		        },
//		        {
//			        header:'备注',
//			        dataIndex:'Remark',
//			        id:'Remark'
//		        },
//		        {
//			        header:'是否有效',
//			        dataIndex:'IsActive',
//			        id:'IsActive'
		        }		
		        ]),
		        bbar: new Ext.PagingToolbar({
			        pageSize: 10,
			        store: gridDataData,
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
	        
	        gridData.on("afterrender", function(component) {
                            component.getBottomToolbar().refresh.hideParent = true;
                            component.getBottomToolbar().refresh.hide(); 
                        });
                        
        gridData.render();
        /*------DataGrid的函数结束 End---------------*/
        
        Ext.getCmp("QryOrgId").setValue(<% =ZJSIG.UIProcess.ADM.UIAdmUser.OrgID(this)%>);
        Ext.getCmp("QryOrgId").setDisabled(true);
        
	QueryDataGrid();

})
</script>

</html>

