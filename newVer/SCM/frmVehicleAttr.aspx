<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmVehicleAttr.aspx.cs" Inherits="SCM_frmVehicleAttr" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html>
<head>
<title>��������</title><meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
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
 <!--    �������ܻ�ò���ֵ����ô��򵥾��������������storeΪjson����Դ 
 <div style="display:none">
    <select id='comboStatus' >
    <option value='1'>��Ч</option>
    <option value='0'>��Ч</option>
</select>
</div>
--> 
</body>

<!-- ��������Դ��ӡ������ dsOrgList-->
<%= getComboBoxStore() %>

<script type="text/javascript">
Ext.BLANK_IMAGE_URL = "../ext3/resources/images/default/s.gif";  //��Ϊ���������������������ͼƬ��ʾ
Ext.onReady(function(){

/* ���ַ�ʽ���������òο��ĵ���˵�ģ���responseд��ҳ��, ����������Դ��ӡ
        var dsOrgList; //���������
        if (dsOrgList == null) { //��ֹ�ظ�����
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
        /*------ʵ��toolbar�ĺ��� start---------------*/
        var Toolbar = new Ext.Toolbar({
	        renderTo:"toolbar",
	        items:[{
		        text:"����",
		        icon:"../Theme/1/images/extjs/customer/add16.gif",
		        handler:function(){
		            saveType="add";
		            openAddAttrWin();
		        }
		        },'-',{
		        text:"�༭",
		        icon:"../Theme/1/images/extjs/customer/delete16.gif",
		        handler:function(){
		            saveType="update";
		            modifyAttrWin();
		        }
//		        },'-',{
//		        text:"ɾ��",
//		        icon:"../Theme/1/images/extjs/customer/edit16.gif",
//		        handler:function(){
//		           deleteAttr();
//		        }
	        }]
        });
        /*------����toolbar�ĺ��� end---------------*/
        

        /*------��ʼToolBar�¼����� start---------------*//*-----����Attrʵ���ര�庯��----*/
        function QueryDataGrid() {
            //ҳ���ύ
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
        /*-----�༭Attrʵ���ര�庯��----*/
        function modifyAttrWin() {
	        var sm = Ext.getCmp('gridData').getSelectionModel();
	        //��ȡѡ���������Ϣ
	        var selectData =  sm.getSelected();
	        if(selectData == null){
		        Ext.Msg.alert("��ʾ","��ѡ����Ҫ�༭����Ϣ��");
		        return;
	        }
	        uploadAttrWindow.show();
	        setFormValue(selectData);
        }
        /*-----ɾ��Attrʵ�庯��----*/
        /*ɾ����Ϣ*/
        function deleteAttr()
        {
	        var sm = Ext.getCmp('gridData').getSelectionModel();
	        //��ȡѡ���������Ϣ
	        var selectData =  sm.getSelected();
	        //���û��ѡ�񣬾���ʾ��Ҫѡ��������Ϣ
	        if(selectData == null){
		        Ext.Msg.alert("��ʾ","��ѡ����Ҫɾ������Ϣ��");
		        return;
	        }
	        //ɾ��ǰ�ٴ������Ƿ����Ҫɾ��
	        Ext.Msg.confirm("��ʾ��Ϣ","�Ƿ����Ҫɾ��ѡ��ļ�¼��",function callBack(id){
		        //�ж��Ƿ�ɾ������
		        if(id=="yes")
		        {
			        //ҳ���ύ
			        Ext.Ajax.request({
				        url:'frmVehicleAttr.aspx?method=delete',
				        method:'POST',
				        params:{
					        VehicleId:selectData.data.VehicleId
				        },
				        success: function(resp,opts){
					        Ext.Msg.alert("��ʾ","����ɾ���ɹ�");
					        gridData.getStore().reload();
				        },
				        failure: function(resp,opts){
					        Ext.Msg.alert("��ʾ","����ɾ��ʧ��");
				        }
			        });
			        //��Ҫ����ˢ�½���
			        //QueryDataGrid();
		        }
	        });
        }

        /*------ʵ��FormPanle�ĺ��� start---------------*/
        var VehicleAttr=new Ext.form.FormPanel({
//	        url:'url',
//	        renderTo:'divForm',
	        frame:true,
	        title:'',
	        items:[
	        
	        /*
	        {
		        layout:'column',   //�����ֶ�û�б�Ҫ������һ�У�ֱ�ӷ�������������У������Ȱ�����������ͳһ��
		        border: false,
		        labelSeparator: '��',
		        items: [
		        {
			        layout:'form',
			        border: false,
			        columnWidth:1,
			        items: [
				        {
					        xtype:'hidden',     //���ֶ�Ӧ�������ص�,������Ϊhidden�ֶ�
					        fieldLabel:'������ʶ',
					        //anchor:'90%',          //��Ȼ�����أ���û�б�Ҫ����ռ�������ռ�İٷֱ�
					        name:'VehicleId',
					        id:'VehicleId',
					        hideLabel:true  //���ֶ�Ӧ�������ص�,Ȼ���ǰ���labelͬʱ����
				        }
		        ]
		        }
	        ]},  */
	        {
		        layout:'column',
		        border: false,
		        labelSeparator: '��',
		        items: [
		        {
			        layout:'form',
			        border: false,
			        columnWidth:0.5,
			        items: [
			            {
					        xtype:'hidden',     //���ֶ�Ӧ�������ص�,������Ϊhidden�ֶ�
					        fieldLabel:'������ʶ',
					        //anchor:'90%',          //��Ȼ�����أ���û�б�Ҫ����ռ�������ռ�İٷֱ�
					        name:'VehicleId',
					        id:'VehicleId',
					        hideLabel:true  //���ֶ�Ӧ�������ص�,Ȼ���ǰ���labelͬʱ����
				        },
				        {
					        xtype:'textfield',
					        fieldLabel:'����*',
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
					        fieldLabel:'��˾��ʶ',
					        columnWidth:0.5,
					        anchor:'90%',
					        name:'OrgId',
					        id:'OrgId',
			                        store: dsOrgList,
                                    displayField: 'OrgName',     //����ֶκ�ҵ��ʵ�����ֶ�ͬ��
                                    valueField: 'OrgId',         //����ֶκ�ҵ��ʵ�����ֶ�ͬ��
                                    typeAhead: true, //�Զ�����һ����������ѡ�ȫ����
                                    triggerAction: 'all',
                                    emptyText: '��ѡ��',
                                    emptyValue: '',
                                    selectOnFocus: true,
                                    forceSelection: true,
                                    editable:false,
                                    mode:'local'           //��������趨�ӱ�ҳ��ȡ����Դ�����ܹ���ֵ��λ
				        }
		        ]
		        }
	        ]},
	        {
		        layout:'column',
		        border: false,
		        labelSeparator: '��',
		        items: [
		        {
			        layout:'form',
			        border: false,
			        columnWidth:0.5,
			        items: [
				        {
					        xtype:'textfield',
					        fieldLabel:'���ƺ�*',
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
					        fieldLabel:'����',
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
		        labelSeparator: '��',
		        items: [
		        {
			        layout:'form',
			        border: false,
			        columnWidth:0.5,
			        items: [
				        {
					        xtype:'numberfield',
					        fieldLabel:'��������*',
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
					        fieldLabel:'��������*',
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
		        labelSeparator: '��',
		        items: [
		        {
			        layout:'form',
			        border: false,
			        columnWidth:0.5,
			        items: [
				        {
					        xtype:'numberfield',
					        fieldLabel:'��λ',
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
					        fieldLabel:'Ĭ���ͻ�Ա',
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
					        fieldLabel:'Ĭ�ϼ�ʻԱ��ʶ',
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
					        fieldLabel:'����Ա',
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
					        fieldLabel:'����ʱ��',
					        anchor:'90%',
					        name:'CreateDate',
					        id:'CreateDate',
					        //format: 'Y��m��d��',  //���������ʽ
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
					        xtype:'hidden',       //ֱ������Ϊhidden�ֶ�
					        fieldLabel:'�޸�ʱ��',
					        columnWidth:1,
					        anchor:'90%',
					        name:'UpdateDate',
					        hideLabel:true,
					        id:'UpdateDate',
                            format: 'Y��m��d��'
					        
				        }
		        ]
		        }
	        ]},
	        {
		        layout:'column',
		        border: false,
		        labelSeparator: '��',
		        items: [
		        {
			        layout:'form',
			        border: false,
			        columnWidth:1,
			        hidden:true,
			        items: [
				        {
					        xtype:'combo',
					        fieldLabel:'������',
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
		        labelSeparator: '��',
		        items: [
		        {
			        layout:'form',
			        border: false,
			        columnWidth:1,
			        items: [
				        {
					        xtype:'textarea',   //������ó�textarea����
					        fieldLabel:'��ע',
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
		        labelSeparator: '��',
		        items: [
		        {
			        layout:'form',
			        border: false,
			        columnWidth:1,		
			        hidden:false,	        
			        items: [
				        {
					        xtype:'combo',
					        fieldLabel:'�Ƿ���Ч',
					        anchor:'50%',
					        name:'IsActive',
					        hidden:false,
					        id:'IsActive',					        
					        //transform: 'comboStatus',  //���������ַ�ʽ
					        store:[[1,'��Ч'],[0,'��Ч']], //�򵥾���������������ӣ�������֯�б�dsOrgList������response�����ҳ��
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
        /*------FormPanle�ĺ������� End---------------*/
        
        /*------ʵ�ֲ�ѯdivQryForm�ĺ��� start---------------*/
        var QryVehicleAttr=new Ext.form.FormPanel({
	        url:'url',
	        renderTo:'divQryForm',
	        frame:true,
	        title:'',
	        items:[
	            {
		            layout:'column',
		            border: false,
		            labelSeparator: '��',
		            items: [
		                {
			                layout:'form',
			                border: false,
			                columnWidth:0.4,
			                items: [{
					                xtype:'textfield',
					                fieldLabel:'������ʶ',
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
					                fieldLabel:'����',
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
			                        fieldLabel:'��˾��ʶ',
			                        anchor:'90%',
			                        name:'QryOrgId',
			                        id:'QryOrgId',
			                        store: dsOrgList,
                                    displayField: 'OrgName',  //����ֶκ�ҵ��ʵ�����ֶ�ͬ��
                                    valueField: 'OrgId',      //����ֶκ�ҵ��ʵ�����ֶ�ͬ��
                                    typeAhead: true, //�Զ�����һ����������ѡ�ȫ����
                                    triggerAction: 'all',
                                    emptyText: '��ѡ��',
                                    emptyValue: '',
                                    selectOnFocus: true,
                                    forceSelection: true,
                                    mode:'local'        //��������趨�ӱ�ҳ��ȡ����Դ�����ܹ���ֵ��λ
                
				                }]
				         },
				         {
			                layout:'form',
		                    border: false,
		                    columnWidth:0.4,
		                    items: [{
				                    xtype:'textfield',
			                        fieldLabel:'���ƺ�',
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
                                    text: '��ѯ',
                                    id: 'searchebtnId',
                                    anchor: '30%',
                                    handler: function() {QueryDataGrid();}
				                }]
		                  }
		                ]
		         }
		    ]
		    
        });
        /*------FormPanle�ĺ������� End---------------*/

        /*------��ʼ�������ݵĴ��� Start---------------*/
        if(typeof(uploadAttrWindow)=="undefined"){//�������2��windows����
	        uploadAttrWindow = new Ext.Window({
		        id:'Attrformwindow',
		        title:'���ͳ���ά��'
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
			        text: "����"
			        , handler: function() {
				        getFormValue();
			        }
			        , scope: this
		        },
		        {
			        text: "ȡ��"
			        , handler: function() { 
				        uploadAttrWindow.hide();
				        gridDataData.reload();
			        }
			        , scope: this
		        }]});
	        }
	        uploadAttrWindow.addListener("hide",function(){
        });

        /*------��ʼ��ȡ�������ݵĺ��� start---------------*/
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
			        //CreateDate:Ext.getCmp('CreateDate').getValue(),   //����������Ҫ��ο��ĵ��д���һ�£�������
			        //CreateDate:Ext.getCmp('CreateDate').getValue().toLocaleDateString(),  //����
			        UpdateDate:Ext.getCmp('UpdateDate').getValue(),   
			        OwnerId:Ext.getCmp('OwnerId').getValue(),
			        Remark:Ext.getCmp('Remark').getValue(),
			        IsActive:Ext.getCmp('IsActive').getValue()		},			     

	                success: function(resp,opts){ 
                            if( checkExtMessage(resp) ) 
                                    gridDataData.load();
                                   //uploadAttrWindow.hide();
                           },
                    failure: function(resp,opts){  Ext.Msg.alert("��ʾ","����ʧ��");     }
		        
		        });
		        }
        /*------������ȡ�������ݵĺ��� End---------------*/

        /*------��ʼ�������ݵĺ��� Start---------------*/
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
		        Ext.getCmp("OperId").setValue(data.OperId);     //����ԭ��֮һ��1899-12-30 1:00:00 �Ƿ�ʱ�䣬�����м䡮-���ָ���js���ϣ����ɡ�/��
		        //Ext.getCmp("CreateDate").setValue(data.CreateDate);
		        Ext.getCmp("CreateDate").setValue((new Date(data.CreateDate.replace(/-/g,"/"))));
//		        Ext.getCmp("UpdateDate").setValue(data.UpdateDate.clearTime());   
		        Ext.getCmp("OwnerId").setValue(data.OwnerId);
		        Ext.getCmp("Remark").setValue(data.Remark);
		        Ext.getCmp("IsActive").setValue(data.IsActive);
	        },
	        failure: function(resp,opts){
		        Ext.Msg.alert("��ʾ","��ȡ��Ϣʧ��");
	        }
	        });
        }
        /*------�������ý������ݵĺ��� End---------------*/

        /*------��ʼ��ȡ���ݵĺ��� start---------------*/
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

        /*------��ȡ���ݵĺ��� ���� End---------------*/

        /*------��ʼDataGrid�ĺ��� start---------------*/

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
	        loadMask: {msg:'���ڼ������ݣ����Ժ��'},
	        sm:sm,
	        cm: new Ext.grid.ColumnModel([
		        sm,
		        new Ext.grid.RowNumberer(),//�Զ��к�
		        {
			        header:'������ʶ',
			        dataIndex:'VehicleId',
			        id:'VehicleId'
		        },
		        {
			        header:'����',
			        dataIndex:'VehicleName',
			        id:'VehicleName'
		        },
//		        {
//			        header:'��˾��ʶ',
//			        dataIndex:'OrgId',
//			        id:'OrgId'
//		        },
		        {
			        header:'���ƺ�',
			        dataIndex:'VehicleNo',
			        id:'VehicleNo'
		        },
		        {
			        header:'����',
			        dataIndex:'VehicleType',
			        id:'VehicleType'
		        },
		        {
			        header:'������(��)',
			        dataIndex:'VehicleTon',
			        id:'VehicleTon'
		        },
		        {
			        header:'��������(��)',
			        dataIndex:'MinQty',
			        id:'MinQty'
		        },
		        {
			        header:'��������(��)',
			        dataIndex:'MaxQty',
			        id:'MaxQty'
		        },
//		        {
//			        header:'Ĭ���ͻ�Ա��ʶ',
//			        dataIndex:'DefDlvId',
//			        id:'DefDlvId'
//		        },
//		        {
//			        header:'Ĭ�ϼ�ʻԱ��ʶ',
//			        dataIndex:'DefDriver',
//			        id:'DefDriver'
//		        },
//		        {
//			        header:'����Ա',
//			        dataIndex:'OperId',
//			        id:'OperId'
//		        },
		        {
			        header:'����ʱ��',
			        dataIndex:'CreateDate',
			        id:'CreateDate',
                   //renderer: function(v){return (new Date(Date.parse(v.replace(/-/g,"/")))).toLocaleDateString()}
			       renderer: Ext.util.Format.dateRenderer('Y��m��d��')
			       
                            
//		        },
//		        {
//			        header:'�޸�ʱ��',
//			        dataIndex:'UpdateDate',
//			        id:'UpdateDate'
//		        },
//		        {
//			        header:'������',
//			        dataIndex:'OwnerId',
//			        id:'OwnerId'
//		        },
//		        {
//			        header:'��ע',
//			        dataIndex:'Remark',
//			        id:'Remark'
//		        },
//		        {
//			        header:'�Ƿ���Ч',
//			        dataIndex:'IsActive',
//			        id:'IsActive'
		        }		
		        ]),
		        bbar: new Ext.PagingToolbar({
			        pageSize: 10,
			        store: gridDataData,
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
	        
	        gridData.on("afterrender", function(component) {
                            component.getBottomToolbar().refresh.hideParent = true;
                            component.getBottomToolbar().refresh.hide(); 
                        });
                        
        gridData.render();
        /*------DataGrid�ĺ������� End---------------*/
        
        Ext.getCmp("QryOrgId").setValue(<% =ZJSIG.UIProcess.ADM.UIAdmUser.OrgID(this)%>);
        Ext.getCmp("QryOrgId").setDisabled(true);
        
	QueryDataGrid();

})
</script>

</html>

