<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmCrmContract.aspx.cs" Inherits="CRM_Contract_frmCrmContract" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html>
<head>
<title>测试页面</title><meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<link rel="stylesheet" type="text/css" href="../../ext3/resources/css/ext-all.css" />
<script type="text/javascript" src="../../ext3/adapter/ext/ext-base.js"></script>
<script type="text/javascript" src="../../ext3/ext-all.js"></script>
<link rel="stylesheet" type="text/css" href="../../ext3/example/file-upload.css" />
<script type="text/javascript" src="../../ext3/example/FileUploadField.js"></script>
<script type="text/javascript" src="../../ext3/src/locale/ext-lang-zh_CN.js"></script>
</head>
<body>
<div id='toolbar'></div>
<div id='searchForm'></div>
<div id='contractGrid'></div>

</body>

<%= getComboBoxStore() %>

<script type="text/javascript">
Ext.BLANK_IMAGE_URL = "../../ext3/resources/images/default/s.gif";
    Ext.onReady(function() {
    var saveType;
        /*------实现toolbar的函数 start---------------*/
        var Toolbar = new Ext.Toolbar({
            renderTo: "toolbar",
            items: [{
                text: "新增",
                icon: "../../Theme/1/images/extjs/customer/add16.gif",
                handler: function() { 
                    saveType = 'add';
                    openAddContractWin(); 
                }
            }, '-', {
                text: "编辑",
                icon: "../../Theme/1/images/extjs/customer/edit16.gif",
                handler: function() { 
                    saveType = 'save';
                    modifyContractWin(); 
                }
            }, '-', {
                text: "删除",
                icon: "../../Theme/1/images/extjs/customer/delete16.gif",
                handler: function() { deleteContract(); }
            },  '-',{
                text: "查看附件",
                icon: "../../Theme/1/images/extjs/customer/delete16.gif",
                handler: function() { viewContractAttach();}
}]
            });

            /*------结束toolbar的函数 end---------------*/


            /*------开始ToolBar事件函数 start---------------*//*-----新增Contract实体类窗体函数----*/
            function openAddContractWin() {
                Ext.getCmp('ContractId').setValue("");
	            Ext.getCmp('ContractNo').setValue("");
	            Ext.getCmp('ContractName').setValue("");
	            Ext.getCmp('ContractType').setValue("");
	            Ext.getCmp('ContractDate').setValue("");
	            Ext.getCmp('Singer').setValue("");
	            Ext.getCmp('ContractSecond').setValue("");
	            Ext.getCmp('ContractSum').setValue("");
	            Ext.getCmp('ContractContent').setValue("");
	            Ext.getCmp('ContarctAttach').setValue("");
	            Ext.getCmp('State').setValue("");
	            uploadContractWindow.show();
            }
            /*-----编辑Contract实体类窗体函数----*/
            function modifyContractWin() {
                var sm = contractGrid.getSelectionModel();
                //获取选择的数据信息
                var selectData = sm.getSelected();
                if (selectData == null) {
                    Ext.Msg.alert("提示", "请选中需要编辑的信息！");
                    return;
                }
                uploadContractWindow.show();
                setFormValue(selectData);
            }
            /*-----删除Contract实体函数----*/
            /*删除信息*/
            function deleteContract() {
                var sm = contractGrid.getSelectionModel();
                //获取选择的数据信息
                var selectData = sm.getSelected();
                //如果没有选择，就提示需要选择数据信息
                if (selectData == null) {
                    Ext.Msg.alert("提示", "请选中需要删除的信息！");
                    return;
                }
                //删除前再次提醒是否真的要删除
                Ext.Msg.confirm("提示信息", "是否真的要删除选择的信息吗？", function callBack(id) {
                    //判断是否删除数据
                    if (id == "yes") {
                        //页面提交
                        Ext.Ajax.request({
                            url: 'frmCrmContract.aspx?method=deleteContract',
                            method: 'POST',
                            params: {
                                ContractId: selectData.data.ContractId
                            },
                            success: function(resp, opts) {
                                Ext.Msg.alert("提示", "数据删除成功");
                                contractGrid.getStore().reload();
                            },
                            failure: function(resp, opts) {
                                Ext.Msg.alert("提示", "数据删除失败");
                            }
                        });
                    }
                });
            }
            function viewContractAttach(){
                 var sm = contractGrid.getSelectionModel();
                //获取选择的数据信息
                var selectData = sm.getSelected();
                //如果没有选择，就提示需要选择数据信息
                if (selectData == null) {
                    Ext.Msg.alert("提示", "请选中需要查看的信息！");
                    return;
                }
                //下面新开一个window.open查看文件，或者下载下来
                var annme = selectData.data.ContarctAttach;
                
                if(annme == "")
                    return;	                        
                //else download file
                window.open("frmCrmContract.aspx?method=getAccessories&fileName="+annme,"");
            }

            /*------实现FormPanle的函数 start---------------*/
            var crmContract = new Ext.form.FormPanel({
            url: '',
                //renderTo: 'divForm',
                frame: true,
                title: '',
                labelAlign: 'left',
                buttonAlign: 'right',
                bodyStyle: 'padding:5px',
                labelWidth: 60,
                fileUpload:true, 
                defaults: {
                   msgTarget: 'side'
                },
                items: [
	{
	    layout: 'column',
	    border: false,
	    labelSeparator: '：',
	    items: [
		{
		    layout: 'form',
		    border: false,
		    columnWidth: 1,
		    items: [
				{
				    xtype: 'hidden',
				    fieldLabel: '合同ID',
				    columnWidth: 1,
				    anchor: '90%',
				    name: 'ContractId',
				    id: 'ContractId',
				    hidden:true,
				    hiddenLabel:true
				}
		]
		}
	]
	},
	{
	    layout: 'column',
	    border: false,
	    labelSeparator: '：',
	    items: [
		{
		    layout: 'form',
		    border: false,
		    columnWidth: 0.4,
		    items: [
				{
				    xtype: 'textfield',
				    fieldLabel: '合同编号',
				    anchor: '90%',
				    name: 'ContractNo',
				    id: 'ContractNo'
				}
		]
		}
, {
    layout: 'form',
    border: false,
    columnWidth: 0.6,
    items: [
				{
				    xtype: 'textfield',
				    fieldLabel: '合同名称	',
				    anchor: '90%',
				    name: 'ContractName',
				    id: 'ContractName'
				}
		]
}
	]
	},
	{
	    layout: 'column',
	    border: false,
	    labelSeparator: '：',
	    items: [
		{
		    layout: 'form',
		    border: false,
		    columnWidth: 0.5,
		    items: [
				{
				    xtype: 'combo',
				    fieldLabel: '合同类型',
				    anchor: '90%',
				    name: 'ContractType',
				    id: 'ContractType',
				    hiddenName:'value',
				    store:dsContractType,
				    displayField:'DicsName',
				    valueField:'DicsCode',
				    mode:'local',
				    triggerAction:'all'
				}
		]
		}
, {
    layout: 'form',
    border: false,
    columnWidth: 0.5,
    items: [
				{
				    xtype: 'datefield',
				    fieldLabel: '合同时间',
				    anchor: '90%',
				    name: 'ContractDate',
				    id: 'ContractDate',
				    format: 'Y年m月d日'
				}
		]
}
, {
    layout: 'form',
    border: false,
    columnWidth: 0.34,
    items: [
				{
				   
				}
		]
}
	]
	},
	{
	    layout: 'column',
	    border: false,
	    labelSeparator: '：',
	    items: [
		{
		    layout: 'form',
		    border: false,
		    columnWidth: 0.5,
		    items: [
				{
				     xtype: 'textfield',
				    fieldLabel: '签订人',
				    anchor: '90%',
				    name: 'Singer',
				    id: 'Singer'
				}
		]
		}
, {
    layout: 'form',
    border: false,
    columnWidth: 0.5,
    items: [
				{
				    xtype: 'numberfield',
				    fieldLabel: '合同金额',
				    anchor: '90%',
				    name: 'ContractSum',
				    id: 'ContractSum'
				}
		]
}
	]
	},
	{
	    layout: 'column',
	    border: false,
	    labelSeparator: '：',
	    items: [
		{
		    layout: 'form',
		    border: false,
		    columnWidth: 0.67,
		    items: [
				{
				    xtype: 'textfield',
				    fieldLabel: '合同乙方',
				    columnWidth: 0.1,
				    anchor: '90%',
				    name: 'ContractSecond',
				    id: 'ContractSecond'
				}
		]
		}
	]
	},
	{
	    layout: 'column',
	    border: false,
	    labelSeparator: '：',
	    items: [
		{
		    layout: 'form',
		    border: false,
		    columnWidth: 1,
		    items: [
				{
				    xtype: 'textarea',
				    fieldLabel: '合同内容',
				    columnWidth: 1,
				    anchor: '90%',
				    name: 'ContractContent',
				    id: 'ContractContent'
				}
		]
		}
	]
	},
	{
	    layout: 'column',
	    border: false,
	    labelSeparator: '：',
	    items: [
		{
		    layout: 'form',
		    border: false,
		    columnWidth: 1,
		    items: [
				{
				    xtype: 'fileuploadfield',
				    fieldLabel: '合同附件',
				    emptyText:'请选择附件',
				    anchor: '90%',
				    name: 'ContarctAttach',
				    id: 'ContarctAttach',
				    buttonText: '选择'
                    //disabled:true
                    //readOnly:true,
				}
		]
		}
	]
	},
	{
	    layout: 'column',
	    border: false,
	    labelSeparator: '：',
	    items: [
		{
		    layout: 'form',
		    border: false,
		    columnWidth: 0.5,
		    items: [
				{
				    xtype: 'combo',
				    fieldLabel: '合同状态',
				    anchor: '90%',
				    name: 'State',
				    id: 'State',
				    hiddenName:'value',
				    triggerAction:'all',
				    store: dsState ,
				    displayField:'DicsName',
                    valueField:'DicsCode',
                    mode:'local',
                    triggerAction:'all'
				}
		]
		}
, {
    layout: 'form',
    border: false,
    columnWidth: 0.5
}
	]
	}
]
            });
            /*------FormPanle的函数结束 End---------------*/

            /*------开始界面数据的窗体 Start---------------*/
            if (typeof (uploadContractWindow) == "undefined") {//解决创建2个windows问题
                uploadContractWindow = new Ext.Window({
                    id: 'Contractformwindow'
		, iconCls: 'upload-win'
		, width: 600
		, height: 350
		, layout: 'fit'
		, plain: true
		, modal: true
		, constrain: true
		, resizable: false
		, closeAction: 'hide'
		, autoDestroy: true
		, items: crmContract
		, buttons: [{
		    text: "保存"
			, handler: function() {
			    saveUserData();
			}
			, scope: this
		},
		{
		    text: "取消"
			, handler: function() {
			    uploadContractWindow.hide();
			}
			, scope: this
}]
                });
            }
            uploadContractWindow.addListener("hide", function() {
            });

            /*------开始获取界面数据的函数 start---------------*/
            function saveUserData() {
                if(saveType == 'add')
                    saveType='addContract';
                if(saveType == 'save')
                    saveType = 'saveContract';
                    
               var contractDate = Ext.getCmp('ContractDate').getValue();
                if(contractDate==null||contractDate=="")
                {
                    Ext.Msg.alert("提示", "请输入合同时间");
                    return;
                }
                crmContract.getForm().submit({  
                        url : 'frmCrmContract.aspx?method='+saveType,
                        method: 'POST',
                        params:{
                            ContractType: Ext.getCmp('ContractType').getValue(),
                            State: Ext.getCmp('State').getValue(),
                            ContarctAttach:Ext.getCmp('ContarctAttach').getValue()
                        },
                        //waitMsg: 'Uploading your photo...',
                        success: function(form, action){  
                           Ext.Msg.alert("提示", "保存成功");
                           uploadContractWindow.hide();
                           contractGridData.reload();  
                           //win.hide();    
                        },      
                       failure: function(){      
                          Ext.Msg.alert("提示", "保存失败");
                          //win.hide();      
                       }  
                 });               
                                    
                /*
                var contractDate = Ext.getCmp('ContractDate').getValue();
                if(contractDate!=""&&contractDate!=null)
                {
                    contractDate=contractDate.toLocaleDateString();                    
                }
                else
                {
                    Ext.Msg.alert("提示", "请输入合同时间");
                    return;
                }
                    
                Ext.Ajax.request({
                url: 'frmCrmContract.aspx?method='+saveType,
                    method: 'POST',
                    waitMsg: 'Uploading your photo...',
                    params: {
                        ContractId: Ext.getCmp('ContractId').getValue(),
                        ContractNo: Ext.getCmp('ContractNo').getValue(),
                        ContractName: Ext.getCmp('ContractName').getValue(),
                        ContractType: Ext.getCmp('ContractType').getValue(),
                        ContractDate: contractDate,
                        Singer: Ext.getCmp('Singer').getValue(),
                        ContractSecond: Ext.getCmp('ContractSecond').getValue(),
                        ContractSum: Ext.getCmp('ContractSum').getValue(),
                        ContractContent: Ext.getCmp('ContractContent').getValue(),
                        ContarctAttach: Ext.getCmp('ContarctAttach').getValue(),
                        State: Ext.getCmp('State').getValue()
                    },
                    success: function(resp, opts) {
                        Ext.Msg.alert("提示", "保存成功");
                        contractGrid.getStore().reload();
                    },
                    failure: function(resp, opts) {
                        Ext.Msg.alert("提示", "保存失败");
                    }
                });
                */
            }
            /*------结束获取界面数据的函数 End---------------*/

            /*------开始界面数据的函数 Start---------------*/
            function setFormValue(selectData) {
                Ext.Ajax.request({
                url: 'frmCrmContract.aspx?method=getContract',
                    params: {
                        ContractId: selectData.data.ContractId
                    },
                    success: function(resp, opts) {
                        var data = Ext.util.JSON.decode(resp.responseText);
                        Ext.getCmp("ContractId").setValue(data.ContractId);
                        Ext.getCmp("ContractNo").setValue(data.ContractNo);
                        Ext.getCmp("ContractName").setValue(data.ContractName);
                        Ext.getCmp("ContractType").setValue(data.ContractType);
                        Ext.getCmp("ContractDate").setValue((new Date(data.ContractDate.replace(/-/g,"/"))));
                        Ext.getCmp("Singer").setValue(data.Singer);
                        Ext.getCmp("ContractSecond").setValue(data.ContractSecond);
                        Ext.getCmp("ContractSum").setValue(data.ContractSum);
                        Ext.getCmp("ContractContent").setValue(data.ContractContent);
                        Ext.getCmp("ContarctAttach").setValue(data.ContarctAttach);
                        Ext.getCmp("State").setValue(data.State);
                    },
                    failure: function(resp, opts) {
                        Ext.Msg.alert("提示", "获取合同信息失败");
                    }
                });
            }
            /*------结束设置界面数据的函数 End---------------*/

/*------定义查询form start ----------------*/
var namePanel = new Ext.form.TextField({
    style: 'margin-left:0px',
    cls: 'key',
    xtype: 'textfield',
    fieldLabel: '商品名称',
    name: 'name',
    anchor: '90%'
});

/*------定义客户类型下拉框 start--------*/
var contractComBoxStore ;
if (contractComBoxStore == null) { //防止重复加载
    contractComBoxStore = new Ext.data.JsonStore({ 
    totalProperty : "results", 
    root : "root", 
    url : 'frmCrmContract.aspx?method=getContractType', 
    fields : ['contractId', 'contractName'] 
        }); 
    contractComBoxStore.load();	
}
var Typecombo = new Ext.form.ComboBox({
    fieldLabel: '合同类型',
    name: 'folderMoveTo',
    store: dsContractType,
    displayField: 'DicsName',
    valueField: 'DicsCode',
    mode: 'local',
    editable:false,
    //loadText:'loading ...',
    typeAhead: true, //自动将第一个搜索到的选项补全输入
    triggerAction: 'all',
    selectOnFocus: true,
    forceSelection: true,
    width: 100

});

var namePanel = new Ext.form.TextField({
    style: 'margin-left:0px',
    cls: 'key',
    xtype: 'textfield',
    fieldLabel: '合同名称',
    name: 'name',
    anchor: '90%'
});

var serchform = new Ext.FormPanel({
    renderTo: 'searchForm',
    labelAlign: 'left',
    layout:'fit',
    buttonAlign: 'right',
    bodyStyle: 'padding:5px',
    frame: true,
    labelWidth: 55,
    items: [{
        layout: 'column',   //定义该元素为布局为列布局方式
        border: false,
        items: [{
            columnWidth: .33,
            layout: 'form',
            border: false,
            items: [
                namePanel
                ]
        },{
            columnWidth: .33,
            layout: 'form',
            border: false,
            items: [
                Typecombo
                ]
        }, {
            columnWidth: .10,
            layout: 'form',
            border: false,
            items: [{ cls: 'key',
                xtype: 'button',
                text: '查询',
                anchor: '50%',
                handler :function(){                
                    var name=namePanel.getValue();
                    var type = Typecombo.getValue();
                    //alert(name +":"+type);
                    contractGridData.baseParams.ContractName = name;
                    contractGridData.baseParams.ContractType = type;
                    
                    contractGridData.load({
                                params : {
                                start : 0,
                                limit : 10
                                } 
                              }); 
                    }
                }]
        },{
            columnWidth: .23,  //该列占用的宽度，标识为20％
            layout: 'form',
            border: false
        }]
    }]
});
/*------定义查询form end ----------------*/

            /*------开始获取数据的函数 start---------------*/
            var contractGridData = new Ext.data.Store
({
    url: 'frmCrmContract.aspx?method=getContractList',
    reader: new Ext.data.JsonReader({
        totalProperty: 'totalProperty',
        root: 'root'
    }, [
	{
	    name: 'ContractId'
	},
	{
	    name: 'ContractNo'
	},
	{
	    name: 'ContractName'
	},
	{
	    name: 'ContractType'
	},
	{
	    name: 'ContractDate'
	},
	{
	    name: 'Singer'
	},
	{
	    name: 'ContractSecond'
	},
	{
	    name: 'ContractSum'
	},
	{
	    name: 'ContractContent'
	},
	{
	    name: 'ContarctAttach'
	},
	{
	    name: 'State'
	},
	{
	    name: 'CreateDate'
	},
	{
	    name: 'UpdateDate'
	},
	{
	    name: 'OwenId'
	},
	{
	    name: 'OwenOrgId'
	},
	{
	    name: 'OperId'
	},
	{
	    name: 'OrgId'
}])
	,
    listeners:
	{
	    scope: this,
	    load: function() {
	    }
	}
});

            /*------获取数据的函数 结束 End---------------*/

            /*------开始DataGrid的函数 start---------------*/

            var sm = new Ext.grid.CheckboxSelectionModel({
                singleSelect: true
            });
            var contractGrid = new Ext.grid.GridPanel({
                el: 'contractGrid',
                width: '100%',
                height: '100%',
                autoWidth: true,
                autoHeight: true,
                autoScroll: true,
                layout: 'fit',
                id: '',
                store: contractGridData,
                loadMask: { msg: '正在加载数据，请稍侯……' },
                sm: sm,
                cm: new Ext.grid.ColumnModel([
		sm,
		new Ext.grid.RowNumberer(), //自动行号
		{
		    header: '合同ID',
		    dataIndex: 'ContractId',
		    id: 'ContractId',
			hidden: true,
            hideable: false		
},
		{
		    header: '合同编号',
		    dataIndex: 'ContractNo',
		    id: 'ContractNo'
		},
		{
		    header: '合同名称	',
		    dataIndex: 'ContractName',
		    id: 'ContractName'
		},
		{
		    header: '合同类型',
		    dataIndex: 'ContractType',
		    id: 'ContractType',
		    renderer:{fn:function(v){
		        //根据key定位下拉框中的value
		        var index = dsContractType.find('DicsCode', v);
                var record = dsContractType.getAt(index);
                return record.data.DicsName;
		     }}
		},
		{
		    header: '合同时间',
		    dataIndex: 'ContractDate',
		    id: 'ContractDate',
		    renderer: Ext.util.Format.dateRenderer('Y年m月d日')
		},
		{
		    header: '签订人',
		    dataIndex: 'Singer',
		    id: 'Singer'
		},
		{
		    header: '合同乙方',
		    dataIndex: 'ContractSecond',
		    id: 'ContractSecond'
		},
		{
		    header: '合同金额',
		    dataIndex: 'ContractSum',
		    id: 'ContractSum'
		},
		{
		    header: '合同状态',
		    dataIndex: 'State',
		    id: 'State',
		    renderer:{fn:function(v){
		        //根据key定位下拉框中的value
		        var index = dsState.find('DicsCode', v);
                var record = dsState.getAt(index);
                return record.data.DicsName;
		     }}
		
}]),
                bbar: new Ext.PagingToolbar({
                    pageSize: 10,
                    store: contractGridData,
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
            contractGrid.render();
            /*------DataGrid的函数结束 End---------------*/



        })
</script>

</html>

