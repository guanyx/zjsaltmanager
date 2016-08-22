<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmAccidentInfo.aspx.cs" Inherits="SCM_frmAccidentInfo" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html>
<head>
<title>�����¹ʵǼ�</title><meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<link rel="stylesheet" type="text/css" href="../ext3/resources/css/ext-all.css" />
<script type="text/javascript" src="../ext3/adapter/ext/ext-base.js"></script>
<script type="text/javascript" src="../ext3/ext-all.js"></script>
<link rel="stylesheet" type="text/css" href="../ext3/example/file-upload.css" />
<script type="text/javascript" src="../ext3/example/FileUploadField.js"></script>
</head>
<body>
<div id='toolbar'></div>
<div id='searchForm'></div>
<div id='dataGrid'></div>
</body>

<%=getComboBoxStore() %>

<script type="text/javascript">
Ext.BLANK_IMAGE_URL = "../ext3/resources/images/default/s.gif"; 
var saveType;
Ext.onReady(function(){
/*------ʵ��toolbar�ĺ��� start---------------*/
var Toolbar = new Ext.Toolbar({
	renderTo:"toolbar",
	items:[{
		text:"����",
		icon:"../Theme/1/images/extjs/customer/add16.gif",
		handler:function(){
		    saveType='add';
		    openAddInfoWin();
		}
		},'-',{
		text:"�༭",
		icon:"../Theme/1/images/extjs/customer/edit16.gif",
		handler:function(){
		    saveType='add';
		    modifyInfoWin();
		}
		},'-',{
		text:"ɾ��",
		icon:"../Theme/1/images/extjs/customer/delete16.gif",
		handler:function(){
		    deleteInfo();
		}
	}]
});

/*------����toolbar�ĺ��� end---------------*/


/*------��ʼToolBar�¼����� start---------------*//*-----����Infoʵ���ര�庯��----*/
function openAddInfoWin() {
	uploadInfoWindow.show();
}
/*-----�༭Infoʵ���ര�庯��----*/
function modifyInfoWin() {
	var sm = infoGrid.getSelectionModel();
	//��ȡѡ���������Ϣ
	var selectData =  sm.getSelected();
	if(selectData == null){
		Ext.Msg.alert("��ʾ","��ѡ����Ҫ�༭����Ϣ��");
		return;
	}
	if(selectData.data.BusiStatusText == '�Ѵ���'){
	    Ext.Msg.alert("��ʾ","�Ѵ����¼�������޸ģ�");
	    return;
	}
	uploadInfoWindow.show();
	setFormValue(selectData);
}
/*-----ɾ��Infoʵ�庯��----*/
/*ɾ����Ϣ*/
function deleteInfo()
{
	var sm = infoGrid.getSelectionModel();
	//��ȡѡ���������Ϣ
	var selectData =  sm.getSelected();
	//���û��ѡ�񣬾���ʾ��Ҫѡ��������Ϣ
	if(selectData == null){
		Ext.Msg.alert("��ʾ","��ѡ����Ҫɾ������Ϣ��");
		return;
	}
	if(selectData.data.BusiStatusText == '�Ѵ���'){
	    Ext.Msg.alert("��ʾ","�Ѵ����¼����ɾ����");
	    return;
	}
	//ɾ��ǰ�ٴ������Ƿ����Ҫɾ��
	Ext.Msg.confirm("��ʾ��Ϣ","�Ƿ����Ҫɾ��ѡ�����Ϣ��",function callBack(id){
		//�ж��Ƿ�ɾ������
		if(id=="yes")
		{
		//alert(selectData.data.AccidentId);
			//ҳ���ύ
			Ext.Ajax.request({
				url:'frmAccidentInfo.aspx?method=deleteInfo',
				method:'POST',
				params:{
					AccidentId:selectData.data.AccidentId
				},
				success: function(resp,opts){
					Ext.Msg.alert("��ʾ","����ɾ���ɹ�");
				},
				failure: function(resp,opts){
					Ext.Msg.alert("��ʾ","����ɾ��ʧ��");
				}
			});
		}
	});
}

/*------ʵ��FormPanle�ĺ��� start---------------*/
var accidentForm=new Ext.form.FormPanel({
	url:'',
	frame:true,
	title:'',
	fileUpload:true, 
	items:[
		{
		    layout:'form',
            columnWidth:.5,
            labelWidth:55,
            items:[{
			    xtype:'hidden',
			    fieldLabel:'�ȼ����',
			    name:'AccidentId',
			    id:'AccidentId',
			    hidden:true,
			    hideLabel:true
			}]
		}
,		{
            layout:'form',
            columnWidth:.5,
            labelWidth:55,
            items:[{
			    xtype:'textfield',
			    fieldLabel:'����',
			    columnWidth:1,
			    anchor:'90%',
			    name:'AccidentName',
			    id:'AccidentName'
		    }]
		}
,		{
            layout:'column',
            items:[{
                layout:'form',
                columnWidth:.45,
                labelWidth:55,
                items:[{
			        xtype:'combo',
			        fieldLabel:'����',
			        anchor:'90%',
			        name:'AccidentType',
			        id:'AccidentType',
			        hiddenName:'value',
			        store:dsAccidentType,
			        displayField:'DicsName',
			        valueField:'DicsCode',
			        mode:'local',
			        triggerAction:'all',
			        editable:false
		       }]
		   }
		   ,{
		        layout:'form',
                columnWidth:.5,
                items:[{
			        xtype:'textfield',
			        fieldLabel:'�������ݺ�',
			        columnWidth:1,
			        anchor:'90%',
			        name:'BillNo',
			        id:'BillNo'
		        }]
		    }]
		}
,		{
            layout:'form',
            columnWidth:.5,
            labelWidth:55,
            items:[{
                xtype: 'fileuploadfield',
	            fieldLabel: '����',
	            emptyText:'��ѡ�񸽼�',
	            anchor: '90%',
	            name: 'Accessories',
	            id: 'Accessories',
	            buttonText: 'ѡ��'
	        }]
		}
,		{
            layout:'form',
            columnWidth:.5,
            labelWidth:55,
            items:[{
			    xtype:'textarea',
			    fieldLabel:'��ע',
			    columnWidth:1,
			    anchor:'90%',
			    name:'Remark',
			    id:'Remark'
			}]
		}
]
});
/*------FormPanle�ĺ������� End---------------*/

/*------��ʼ�������ݵĴ��� Start---------------*/
if(typeof(uploadInfoWindow)=="undefined"){//�������2��windows����
	uploadInfoWindow = new Ext.Window({
		id:'Infoformwindow',
		title:'�����¼��Ǽ�'
		, iconCls: 'upload-win'
		, width: 500
		, height: 250
		, layout: 'fit'
		, plain: true
		, modal: true
		, constrain:true
		, resizable: false
		, closeAction: 'hide'
		,autoDestroy :true
		,items:accidentForm
		,buttons: [{
			text: "����"
			, handler: function() {
				saveUserData();
			}
			, scope: this
		},
		{
			text: "ȡ��"
			, handler: function() { 
				uploadInfoWindow.hide();
			}
			, scope: this
		}]});
	}
	uploadInfoWindow.addListener("hide",function(){
	    accidentForm.getForm().reset();
});

/*------��ʼ��ȡ�������ݵĺ��� start---------------*/
function saveUserData()
{
    if(saveType=='add')
        saveType='addInfo';
    else if(saveType == 'save')
        saveType = 'saveInfo';
    //alert(Ext.getCmp('Accessories').getValue());
    accidentForm.getForm().submit({  
            url : 'frmAccidentInfo.aspx?method='+saveType,
            method: 'POST',
            params:{
			    AccidentType:Ext.getCmp('AccidentType').getValue(),
			    Accessories:Ext.getCmp('Accessories').getValue()
            },
            waitMsg: 'Uploading ...',
            success: function(form, action){  
               Ext.Msg.alert("��ʾ", "����ɹ�");;  
               uploadInfoWindow.hide();    
            },      
           failure: function(){      
              Ext.Msg.alert("��ʾ", "����ʧ��");    
           }  
     });   
/*
	Ext.Ajax.request({
		url:'frmAccidentInfo.aspx?method='+saveType,
		method:'POST',
		params:{
			AccidentId:Ext.getCmp('AccidentId').getValue(),
			AccidentName:Ext.getCmp('AccidentName').getValue(),
			AccidentType:Ext.getCmp('AccidentType').getValue(),
			Accessories:Ext.getCmp('Accessories').getValue(),
			Remark:Ext.getCmp('Remark').getValue(),
			BillNo:Ext.getCmp('BillNo').getValue()
			},
		success: function(resp,opts){
			Ext.Msg.alert("��ʾ","����ɹ�");
		},
		failure: function(resp,opts){
			Ext.Msg.alert("��ʾ","����ʧ��");
		}
		});
		*/
}
/*------������ȡ�������ݵĺ��� End---------------*/

/*------��ʼ�������ݵĺ��� Start---------------*/
function setFormValue(selectData)
{
	Ext.Ajax.request({
		url:'frmAccidentInfo.aspx?method=getInfo',
		params:{
			AccidentId:selectData.data.AccidentId
		},
	success: function(resp,opts){
		var data=Ext.util.JSON.decode(resp.responseText);
		Ext.getCmp("AccidentId").setValue(data.AccidentId);
		Ext.getCmp("AccidentName").setValue(data.AccidentName);
		Ext.getCmp("AccidentType").setValue(data.AccidentType);
		Ext.getCmp("Accessories").setValue(data.Accessories);
		Ext.getCmp("Remark").setValue(data.Remark);
		Ext.getCmp("BillNo").setValue(data.BillNo);
	},
	failure: function(resp,opts){
		Ext.Msg.alert("��ʾ","��ȡ�û���Ϣʧ��");
	}
	});
}
/*------�������ý������ݵĺ��� End---------------*/

/*------����ͻ����������� start--------*/
var AccidentTypecombo = new Ext.form.ComboBox({
    fieldLabel: '����',
    name: 'folderaMoveTo',
    store: dsAccidentType,
    displayField: 'DicsName',
    valueField: 'DicsCode',
    mode: 'local',
    editable:false,
    //loadText:'loading ...',
    typeAhead: true, //�Զ�����һ����������ѡ�ȫ����
    triggerAction: 'all',
    selectOnFocus: true,
    forceSelection: true
});

var nameAccidentPanel = new Ext.form.TextField({
    style: 'margin-left:0px',
    cls: 'key',
    xtype: 'textfield',
    fieldLabel: '����',
    name: 'name',
    anchor: '90%'
});

var serchAccform = new Ext.FormPanel({
    renderTo: 'searchForm',
    labelAlign: 'left',
    layout:'fit',
    buttonAlign: 'right',
    bodyStyle: 'padding:5px',
    frame: true,
    labelWidth: 55,
    items: [{
        layout: 'column',   //�����Ԫ��Ϊ����Ϊ�в��ַ�ʽ
        border: false,
        items: [{
            columnWidth: .33,
            layout: 'form',
            border: false,
            items: [
                nameAccidentPanel
                ]
        },{
            columnWidth: .33,
            layout: 'form',
            border: false,
            items: [
                AccidentTypecombo
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
                    var name=nameAccidentPanel.getValue();
                    var type = AccidentTypecombo.getValue();
                    //alert(name +":"+type);
                    infoGridData.baseParams.AccidentName = name;
                    infoGridData.baseParams.AccidentType = type;
                    infoGridData.load({
                        params : {
                        start : 0,
                        limit : 10
                        } 
                      }); 
                    }
                }]
        },{
            columnWidth: .23,  //����ռ�õĿ�ȣ���ʶΪ20��
            layout: 'form',
            border: false
        }]
    }]
});
/*------�����ѯform end ----------------*/

/*------��ʼ��ȡ���ݵĺ��� start---------------*/
var infoGridData = new Ext.data.Store
({
url: 'frmAccidentInfo.aspx?method=getInfoList',
reader:new Ext.data.JsonReader({
	totalProperty:'totalProperty',
	root:'root'
},[
	{		name:'AccidentId'	},
	{		name:'AccidentName'	},
	{		name:'AccidentType'	},
	{		name:'Accessories'	},
	{		name:'Remark'	},
	{		name:'OperId'	},
	{		name:'CreateDate'	},
	{		name:'UpdateDate'	},
	{		name:'Auditor'	},
	{		name:'Result'	},
	{		name:'AuditDate'	},
	{		name:'OrgId'	},
	{		name:'OwnerId'	},
	{		name:'Status'	},
	{		name:'BillNo'	},
	{       name:'AccidentTypeText'},
	{       name:'BusiStatusText'}
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

var sm= new Ext.grid.CheckboxSelectionModel({
	singleSelect:true
});
var infoGrid = new Ext.grid.GridPanel({
	el: 'dataGrid',
	width:'100%',
	height:'100%',
	autoWidth:true,
	autoHeight:true,
	autoScroll:true,
	layout: 'fit',
	id: '',
	store: infoGridData,
	loadMask: {msg:'���ڼ������ݣ����Ժ��'},
	sm:sm,
	cm: new Ext.grid.ColumnModel([
		sm,
		new Ext.grid.RowNumberer(),//�Զ��к�
		{
			header:'�Ǽ����',
			dataIndex:'AccidentId',
			id:'AccidentId',
			hidden:true,
			hideable:false
		},
		{
			header:'����',
			dataIndex:'AccidentName',
			id:'AccidentName'
		},
		{
			header:'����',
			dataIndex:'AccidentTypeText',
			id:'AccidentTypeText'
		},
		{
		    header:'�����ݺ�',
			dataIndex:'BillNo',
			id:'BillNo'
		},
		{
		    header:'����',
			dataIndex:'Accessories',
			id:'Accessories'
		},
		{
		    header:'������',
			dataIndex:'Result',
			id:'Result'
		},
		{
			header:'ҵ��״̬:',
			dataIndex:'BusiStatusText',
			id:'BusiStatusText'
		}		]),
		bbar: new Ext.PagingToolbar({
			pageSize: 10,
			store: infoGridData,
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
infoGrid.render();
/*------DataGrid�ĺ������� End---------------*/



})
</script>

</html>
