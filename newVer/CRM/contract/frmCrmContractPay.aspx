<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmCrmContractPay.aspx.cs"
    Inherits="CRM_Contract_frmCrmContractPay" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
    <title>合同付款情况</title>
    <meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
    <link rel="stylesheet" type="text/css" href="../../ext3/resources/css/ext-all.css" />

    <script type="text/javascript" src="../../ext3/adapter/ext/ext-base.js"></script>

    <script type="text/javascript" src="../../ext3/ext-all.js"></script>
    <script type="text/javascript" src="../../ext3/src/locale/ext-lang-zh_CN.js"></script>
</head>
<body>
    <div id='toolbar'>
    </div>
    <div id='searchForm'>
    </div>
    <div id='contractPayGrid'>
    </div>
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
                    openAddPayWin(); 
                }
            }, '-', {
                text: "编辑",
                icon: "../../Theme/1/images/extjs/customer/edit16.gif",
                handler: function() { 
                    saveType = 'save';
                    modifyPayWin(); 
                }
//            }, '-', {
//                text: "删除",
//                icon: "../../Theme/1/images/extjs/customer/delete16.gif",
//                handler: function() { deletePay(); }
}]
            });

            /*------结束toolbar的函数 end---------------*/

            
            /*------开始ToolBar事件函数 start---------------*//*-----新增Pay实体类窗体函数----*/
            function openAddPayWin() {
                contractPayForm.getForm().reset();
	            uploadPayWindow.show();
	            
	            Ext.getCmp('ContractName').setDisabled(false);
	            
	            /*--------组合框------------------------------*/        
                //定义合同框异步调用方法
                var dsContracts;
                if(dsContracts == null){
                    dsContracts = new Ext.data.Store({
                        url: 'frmCrmContractPay.aspx?method=getContracts',  
                        reader: new Ext.data.JsonReader({  
                            root: 'root',  
                            totalProperty: 'totalProperty'
                        }, [  
                            {name: 'ContractId', mapping: 'ContractId'}, 
                            {name: 'ContractNo', mapping: 'ContractNo'},  
                            {name: 'ContractName', mapping: 'ContractName'}
                        ]),
                        params:{
                            limit:10,
                            start:0
                        }
                    });
                }
               var contractsFilterCombo = new Ext.form.ComboBox({  
                            store: dsContracts,  
                            displayField:'ContractName',
                            displayValue:'ContractId',
                            typeAhead: false,  
                            minChars:1,
                            loadingText: 'Searching...',  
                            //tpl: resultTpl,  
                            pageSize:10,  
                            hideTrigger:true,  
                            applyTo: 'ContractName',
                            onSelect: function(record){ // override default onSelect to do redirect  
                                //alert(record.data.cusid); 
                                //alert(Ext.getCmp('search').getValue());                        
                                Ext.getCmp('ContractName').setValue(record.data.ContractName);
                                Ext.getCmp('ContactId').setValue(record.data.ContractId);
                                this.collapse();
                            }  
                        }); 
                /*--------组合框------------------------------*/
	            
            }
            /*-----编辑Pay实体类窗体函数----*/
            function modifyPayWin() {
                var sm = contractPayGrid.getSelectionModel();
                //获取选择的数据信息
                var selectData = sm.getSelected();
                if (selectData == null) {
                    Ext.Msg.alert("提示", "请选中需要编辑的信息！");
                    return;
                }
                uploadPayWindow.show();
                Ext.getCmp('ContractName').setDisabled(true);
                setFormValue(selectData);
            }
            /*-----删除Pay实体函数----*/
            /*删除信息*/
            function deletePay() {
                var sm = contractPayGrid.getSelectionModel();
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
                            url: 'frmCrmContractPay.aspx?method=deletePay',
                            method: 'POST',
                            params: {
                                PayId: selectData.data.PayId
                            },
                            success: function(resp, opts) {
                                Ext.Msg.alert("提示", "数据删除成功");
                            },
                            failure: function(resp, opts) {
                                Ext.Msg.alert("提示", "数据删除失败");
                            }
                        });
                    }
                });
            }            

            /*------实现FormPanle的函数 start---------------*/
            var contractPayForm = new Ext.form.FormPanel({
                url: '',
                //renderTo: 'divForm',
                frame: true,
                title: '',
                items: [{
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
		        fieldLabel: '付款ID',
		        columnWidth: 1,
		        anchor: '90%',
		        name: 'PayId',
		        id: 'PayId',
		        hidden:true,
		        hiddenLabel:true
		    }
            , {
                xtype: 'hidden',
                fieldLabel: '合同ID',
                columnWidth: 1,
                anchor: '95%',
                name: 'ContactId',
                id: 'ContactId',
                hidden:true,
		        hiddenLabel:true
            }
            , {
                xtype: 'textfield',
                fieldLabel: '合同名称',
                columnWidth: 1,
                anchor: '95%',
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
                xtype: 'hidden',
                fieldLabel: '付款人',
                name: 'PayMan',
                id: 'PayMan',
                value:<%=EmployeeID %>
            },
		    {
                xtype: 'textfield',
                fieldLabel: '付款人',
                columnWidth: 1,
                anchor: '90%',
                name: 'PayManName',
                id: 'PayManName',
                value:'<%=EmpName %>',
                readOnly:true
            }]
         }, 
         {
            layout: 'form',
		    border: false,
		    columnWidth: 0.5,
		    items: [
		    {
                xtype: 'datefield',
                fieldLabel: '付款日期',
                columnWidth: 1,
                anchor: '90%',
                name: 'PayDate',
                id: 'PayDate',
                format:'Y年m月d日',
                allowBlank: false,//不能为空
                blankText:'合同日期不能为空！',
                value:new Date().clearTime()
            }]
         }]
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
                xtype: 'numberfield',
                fieldLabel: '付款金额',
                columnWidth: 1,
                anchor: '90%',
                name: 'PaySum',
                id: 'PaySum'
            }]
        },
        {
            layout: 'form',
		    border: false,
		    columnWidth: 0.5,
		    items: [
		    {
                xtype: 'combo',
                fieldLabel: '付款类型',
                columnWidth: 1,
                anchor: '90%',
                name: 'PayType',
                hiddenName:'value',
                id: 'PayType',
                store:dsPayType,
                valueField:'DicsCode',
                displayField:'DicsName',
                mode:'local',
                triggerAction:'all',
                editable:false
             }]
        }]
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
                fieldLabel: '备注',
                columnWidth: 1,
                anchor: '95%',
                name: 'Remark',
                id: 'Remark'
            }]
          }]
     }
            ]
            });
            /*------FormPanle的函数结束 End---------------*/

            /*------开始界面数据的窗体 Start---------------*/
            if (typeof (uploadPayWindow) == "undefined") {//解决创建2个windows问题
                uploadPayWindow = new Ext.Window({
                    id: 'Payformwindow'
		, iconCls: 'upload-win'
		, width: 500
		, height: 250
		, layout: 'fit'
		, plain: true
		, modal: true
		, constrain: true
		, resizable: false
		, closeAction: 'hide'
		, autoDestroy: true
		, items: contractPayForm
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
			    uploadPayWindow.hide();
			}
			, scope: this
}]
                });
            }
            uploadPayWindow.addListener("hide", function() {
                contractPayForm.getForm().reset();
            });

            /*------开始获取界面数据的函数 start---------------*/
            function saveUserData() {
                if(saveType=='add')
                    saveType = 'addContractPay';
                else if(saveType = 'save')
                    saveType = 'saveContractPay';
                    
                
                contractPayForm.getForm().submit({  
                        url : 'frmCrmContractPay.aspx?method='+saveType,
                        method: 'POST',
                        params:{
                            PayType: Ext.getCmp('PayType').getValue()
                        },
                        waitMsg: 'Uploading ...',
                        success: function(form, action){  
                            Ext.Msg.alert("提示", "保存成功");  
                           win.hide();    
                        },      
                       failure: function(){      
                          Ext.Msg.alert("提示", "保存失败");
                          win.hide();      
                       }  
                 });  
                
                /*    
                Ext.Ajax.request({
                    url: 'frmCrmContractPay.aspx?method='+saveType,
                    method: 'POST',
                    params: {
                        PayId: Ext.getCmp('PayId').getValue(),
                        ContactId: Ext.getCmp('ContactId').getValue(),
                        PayMan: Ext.getCmp('PayMan').getValue(),
                        PayDate: Ext.getCmp('PayDate').getValue().to,
                        PaySum: Ext.getCmp('PaySum').getValue(),
                        PayType: Ext.getCmp('PayType').getValue(),
                        Remark: Ext.getCmp('Remark').getValue()
                    },
                    success: function(resp, opts) {
                        Ext.Msg.alert("提示", "保存成功");
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
                    url: 'frmCrmContractPay.aspx?method=getPay',
                    params: {
                        PayId: selectData.data.PayId
                    },
                    success: function(resp, opts) {
                        var data = Ext.util.JSON.decode(resp.responseText);
                        Ext.getCmp("PayId").setValue(data.PayId);
                        Ext.getCmp("ContactId").setValue(data.ContactId);
                        Ext.getCmp("PayMan").setValue(data.PayMan);
                        Ext.getCmp("PayManName").setValue(data.PayManName);
                        Ext.getCmp("PayDate").setValue(Ext.util.Format.date(data.PayDate,'Y-m-d'));
                        Ext.getCmp("PaySum").setValue(data.PaySum);
                        Ext.getCmp("PayType").setValue(data.PayType);
                        Ext.getCmp("Remark").setValue(data.Remark);
                        
                         Ext.Ajax.request({
                            url: 'frmCrmContractPay.aspx?method=getContract',
                            params: {
                                contractid: data.ContactId
                            },
                            success: function(r, o) {
                                var cdata = Ext.util.JSON.decode(r.responseText);
                                Ext.getCmp("ContractName").setValue(cdata.ContractName); //ContractName
                            }
                        });
                    },
                    failure: function(resp, opts) {
                        Ext.Msg.alert("提示", "获取用户信息失败");
                    }
                });
            }
            /*------结束设置界面数据的函数 End---------------*/
            /*------定义合同下拉框 start--------*/
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
            columnWidth: .10,
            layout: 'form',
            border: false,
            items: [{ cls: 'key',
                xtype: 'button',
                text: '查询',
                anchor: '50%',
                handler :function(){                
                    var name=namePanel.getValue();
                    //alert(name +":"+type);
                    contractPayGridData.baseParams.ContractName = name;
                    contractPayGridData.load({
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
            var contractPayGridData = new Ext.data.Store
({
    url: 'frmCrmContractPay.aspx?method=getContractPayList',
    reader: new Ext.data.JsonReader({
        totalProperty: 'totalProperty',
        root: 'root'
    }, [
	{
	    name: 'PayId'
	},
	{
	    name: 'ContactId'
	},
	{
	    name: 'ContractName'
	},
	{
	    name: 'PayMan'
	},
	{
	    name: 'PayManName'
	},
	{
	    name: 'PayDate'
	},
	{
	    name: 'PaySum'
	},
	{
	    name: 'PayType'
	},
	{
	    name: 'Remark'
	},
	{
	    name: 'CreateDate'
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
            var contractPayGrid = new Ext.grid.GridPanel({
                el: 'contractPayGrid',
                width: '100%',
                height: '100%',
                autoWidth: true,
                autoHeight: true,
                autoScroll: true,
                layout: 'fit',
                id: '',
                store: contractPayGridData,
                loadMask: { msg: '正在加载数据，请稍侯……' },
                sm: sm,
                cm: new Ext.grid.ColumnModel([
		sm,
		new Ext.grid.RowNumberer(), //自动行号
		{
		    header: '付款ID',
		    dataIndex: 'PayId',
		    id: 'PayId',
			hidden: true,
            hideable: false
},
		{
		    header: '合同名称',
		    dataIndex: 'ContactId',
		    id: 'ContactId',
			hidden: true,
            hideable: false
		},
		{
		    header: '合同名称',
		    dataIndex: 'ContractName',
		    id: 'ContractName'
		},
		{
		    header: '付款人',
		    dataIndex: 'PayManName',
		    id: 'PayManName'
		},
		{
		    header: '付款日期',
		    dataIndex: 'PayDate',
		    id: 'PayDate',
		    renderer: Ext.util.Format.dateRenderer('Y年m月d日')
		},
		{
		    header: '付款金额',
		    dataIndex: 'PaySum',
		    id: 'PaySum'
		},
		{
		    header: '付款类型',
		    dataIndex: 'PayType',
		    id: 'PayType',
		    renderer:{fn:function(v){
		        var index = dsPayType.find('DicsCode', v);
                var record = dsPayType.getAt(index);
                return record.data.DicsName;
		    }}
		},
		{
		    header: '备注',
		    dataIndex: 'Remark',
		    id: 'Remark'
		},
		{
		    header: '创建时间',
		    dataIndex: 'CreateDate',
		    id: 'CreateDate',
		    renderer: Ext.util.Format.dateRenderer('Y年m月d日')
}]),
                bbar: new Ext.PagingToolbar({
                    pageSize: 10,
                    store: contractPayGridData,
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
            contractPayGrid.render();
            /*------DataGrid的函数结束 End---------------*/



        })
</script>


</html>
