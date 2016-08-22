<%@ Page Language="C#" AutoEventWireup="true" CodeFile="frmWmsClosedAccount.aspx.cs" Inherits="WMS_frmWmsClosedAccount" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html>
<head>
<title>仓库关帐页</title>
<meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<link rel="stylesheet" type="text/css" href="../ext3/resources/css/ext-all.css" />
<script type="text/javascript" src="../ext3/adapter/ext/ext-base.js"></script>
<script type="text/javascript" src="../ext3/ext-all.js"></script>
<script type="text/javascript" src="../js/operateResp.js"></script>
<script type="text/javascript" src="../js/ExtFix.js"></script>
    <script type="text/javascript" src="../ext3/src/locale/ext-lang-zh_CN.js"></script>
<style type="text/css">
a.button {
background: transparent url('../Theme/1/images/frame/bg_button_a.gif') no-repeat scroll top right;
color: #444;
display: block;
float: left;
font: normal 12px arial, sans-serif;
height: 24px;
margin-right: 6px;
padding-right: 18px; /* sliding doors padding */
text-decoration: none;
}
a.button span {
background: transparent url('../Theme/1/images/frame/bg_button_div.gif') no-repeat;
display: block;
line-height: 14px;
padding: 5px 0 5px 18px;
}
a.button:active {
background-position: bottom right;
color: #000;
outline: none; /* hide dotted outline in Firefox */
}
a.button:active span {
background-position: bottom left;
padding: 6px 0 4px 18px; /* push text down 1px */
} 
</style> 
</head>
<body>
<div id='searchForm'></div>
<div id='userGrid'></div>
</body>
<%=getComboBoxStore()%>
<script type="text/javascript">
    var userGrid;
    function openAccount() {
        closeAccount();
    }

    function closeAccount() {
        var sm = userGrid.getSelectionModel();
        //获取选择的数据信息
        var selectData = sm.getSelected();
        if (selectData == null) {
            alert('请选择');
            return;
        }
        if(selectData.data.Status=='W1001'){
            if(!window.confirm("关帐后需要核算成本，是否继续？"))
                return;
        }
        Ext.Msg.confirm("提示信息", "是否真的要对选择的仓库关帐吗？", function callBack(id) {
            //判断是否删除数据
            if (id == "yes") {
                //页面提交
                Ext.Ajax.request({
                    url: 'frmWmsClosedAccount.aspx?method=updateWarehouseAccount',
                    method: 'POST',
                    params: {
                        CaId: selectData.data.CaId,
                        ClosedTime:selectData.data.ClosedTime.dateFormat('Y/m/d')
                    },
                    success: function(resp, opts) {
                        if (checkExtMessage(resp)) {
                            userGrid.getStore().reload(); //刷新页面
                        }
                    },
                    failure: function(resp, opts) {
                        Ext.Msg.alert("提示", "操作超时！");
                    }
                });
            }
        });
    }
    Ext.BLANK_IMAGE_URL = "../ext3/resources/images/default/s.gif";
    Ext.onReady(function() {
        var dsWarehouseList; //仓位下拉框
        if (dsWarehouseList == null) { //防止重复加载
            //alert(1);
            dsWarehouseList = new Ext.data.JsonStore({
                totalProperty: "result",
                root: "root",
                url: 'frmWmsClosedAccount.aspx?method=getWarehouseList',
                fields: ['WhId', 'WhName']
            });
            dsWarehouseList.load();

        }
        function updateDataGrid() {
            var OrgId = OrgPanel.getValue();
            var WhId = WhPanel.getValue();

            userGridData.baseParams.OrgId = OrgId;
            userGridData.baseParams.WhId = WhId;

            userGridData.load({
                params: {
                    start: 0,
                    limit: 10
                }
            });
        }



        String.prototype.trim = function() {
            // 用正则表达式将前后空格  
            // 用空字符串替代。  
            return this.replace(/(^\s*)|(\s*$)/g, "");
        }

        /*------结束设置界面数据的函数 End---------------*/

        /*------开始查询form的函数 start---------------*/

        var OrgPanel = new Ext.form.ComboBox({
            fieldLabel: '分公司',
            name: 'orgCombo',
            store: dsOrgList,
            displayField: 'OrgName',
            valueField: 'OrgId',
            typeAhead: true, //自动将第一个搜索到的选项补全输入
            //triggerAction: 'all',
            emptyText: '请选择分公司',
            selectOnFocus: true,
            forceSelection: true,
            anchor: '90%',
            mode: 'local',
            editable: false,
			disabled:true,
            value:<%=ZJSIG.UIProcess.ADM.UIAdmUser.OrgID(this) %>,
            listeners: { specialkey: function(f, e) { if (e.getKey() == e.ENTER) { Ext.getCmp('SWhName').focus(); } },
                select: function(combo, record, index) {
                    var curOrgId = OrgPanel.getValue();
                    dsWarehouseList.load({
                        params: {
                            OrgId: curOrgId
                        }
                    });
                    Ext.getCmp('SWhName').setValue("请选择仓库");
                }
            }

        });


        var WhPanel = new Ext.form.ComboBox({
            fieldLabel: '仓库名称',
            name: 'warehouseCombo',
            store: dsWarehouseList,
            displayField: 'WhName',
            valueField: 'WhId',
            typeAhead: true, //自动将第一个搜索到的选项补全输入
            triggerAction: 'all',
            emptyText: '请选择仓库',
            selectOnFocus: true,
            forceSelection: true,
            anchor: '90%',
            mode: 'local',
            id: 'SWhName',
            listeners: { specialkey: function(f, e) { if (e.getKey() == e.ENTER) { Ext.getCmp('searchebtnId').focus(); } } }
        });

        var serchform = new Ext.FormPanel({
            renderTo: 'searchForm',
            labelAlign: 'left',
            layout: 'fit',
            buttonAlign: 'right',
            bodyStyle: 'padding:5px',
            frame: true,
            labelWidth: 55,
            items: [{
                layout: 'column',   //定义该元素为布局为列布局方式
                border: false,
                items: [{
                    columnWidth: .3,  //该列占用的宽度，标识为20％
                    layout: 'form',
                    border: false,
                    items: [
                        OrgPanel
                    ]
                }, {
                    columnWidth: .3,
                    layout: 'form',
                    border: false,
                    items: [
                        WhPanel
                        ]
                }, {
                    columnWidth: .2,
                    layout: 'form',
                    border: false,
                    items: [{ cls: 'key',
                        xtype: 'button',
                        text: '查询',
                        id: 'searchebtnId',
                        anchor: '50%',
                        handler: function() {
                            updateDataGrid();
                        }
}]
}, {
                    columnWidth: .2,
                    layout: 'form',
                    border: false,
                    items: [{ cls: 'key',
                        xtype: 'button',
                        text: '业务情况',
                        id: 'searchebtnId',
                        anchor: '50%',
                        handler: function() {
                            window.open("../Common/frmCurrentBusinessInformation.aspx");
                        }
}]
}]
}]
                    });


                    /*------开始查询form的函数 end---------------*/

                    /*------开始获取数据的函数 start---------------*/
                    var userGridData = new Ext.data.Store
                        ({
                            url: 'frmWmsClosedAccount.aspx?method=getCloseAccountListInfo',
                            reader: new Ext.data.JsonReader({
                                totalProperty: 'totalProperty',
                                root: 'root'
                            }, [
	                        {
	                            name: 'CaId'
	                        },
	                        {
	                            name: 'WhId'
	                        },
	                        {
	                            name: 'ClosedTime',type:'date'
	                        },
	                        {
	                            name: 'OrgId'
	                        },
	                        {
	                            name: 'UpdateDate'
	                        },
	                        {
	                            name: 'CreateDate'
	                        },
	                        {
	                            name: 'OperId'
	                        },
	                        {
	                            name: 'OwnerId'
	                        },
	                        {
	                            name: 'Status'
	                        },
	                        {
	                            name: 'CloseYear'
	                        },
	                        {
	                            name: 'CloseMonth'

	                        },
	                        {
	                            name: 'WhCode'
	                        },
	                        {
	                            name: 'WhName'
	                        },
	                        {
	                            name: 'OrgName'
	                        },
	                        {
	                            name: 'OperName'
	                        }

                            ])
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
                    userGrid = new Ext.grid.EditorGridPanel({
                        el: 'userGrid',
                        width: document.body.offsetWidth,
                        height: '100%',
                        //autoWidth: true,
                        //autoHeight: true,
                        autoScroll: true,
                        layout: 'fit',
                        id: '',
                        columnLines:true,
                        clicksToEdit: 1,
                        store: userGridData,
                        loadMask: { msg: '正在加载数据，请稍侯……' },
                        sm: sm,
                        cm: new Ext.grid.ColumnModel([
	                            sm,
	                            new Ext.grid.RowNumberer(), //自动行号
	                            {
	                            header: '关帐ID',
	                            dataIndex: 'CaId',
	                            id: 'CaId',
	                            hidden: true,
	                            hideable: false
	                        },
	                            {
	                                header: '仓库编号',
	                                dataIndex: 'WhCode',
	                                id: 'WhCode',
	                                width:70
	                            },
	                            {
	                                header: '仓库名称',
	                                dataIndex: 'WhName',
	                                id: 'WhName',
	                                width:120
	                            },
//	                            {
//	                                header: '分公司',
//	                                dataIndex: 'OrgName',
//	                                id: 'OrgName'
//	                            },
	                            {
	                                header: '关帐年份',
	                                dataIndex: 'CloseYear',
	                                id: 'CloseYear',
	                                width:70
	                            },
	                            {
	                                header: '关帐月份',
	                                dataIndex: 'CloseMonth',
	                                id: 'CloseMonth',
	                                width:70
	                            },
	                            {
	                                header: '操作人',
	                                dataIndex: 'OperName',
	                                id: 'OperName',
	                                width:80
	                            },
	                            {
	                                header: '关帐日期',
	                                dataIndex: 'ClosedTime',
	                                id: 'ClosedTime',
	                                width:150,
	                                editor: new Ext.form.DateField({
	                                            format:'Y年m月d日', 
	                                            altFormats:'Y年m月d日',
	                                            listeners: {
	                                                select : function(o){ 
	                                                    var selectData = userGrid.getSelectionModel().getSelected();
                                                        if(selectData){
                                                            var oldValue = selectData.data.ClosedTime;
                                                            if(oldValue!=o.getValue()){                                                                
                                                                userGrid.stopEditing();
                                                                userGrid.getView().refresh();
                                                                Ext.Ajax.request({
                                                                url: 'frmWmsClosedAccount.aspx?method=updateCloseAccountTime',
                                                                method: 'POST',
                                                                params: {
                                                                    CaId: selectData.data.CaId,
                                                                    ClosedTime:o.getValue().dateFormat('Y/m/d')
                                                                }
                                                                ,success: function(resp,opts){                                     
                                                                    if (!checkExtMessage(resp)) {
                                                                       selectData.set('ClosedTime',oldValue); 
                                                                       userGrid.getStore().commitChanges();
                                                                     }
                                                                }
                                                                ,failure: function(resp, opts) {
                                                                    selectData.set('ClosedTime',oldValue);
                                                                }
                                                            });
                                                            }
                                                        }
	                                                }
	                                            }
	                                        }), 
                                    renderer: function (value) {
                                        if (value instanceof Date) {
                                            return new Date(value).dateFormat('Y年m月d日');
                                        }
                                        // 原封不動的傳回去，通常是一開始指定的值，或是再做其他處理
                                        return value;
                                    }                                
	                            },
	                            {
	                                header: '关帐状态',
	                                dataIndex: 'Status',
	                                id: 'Status',
	                                renderer: function(val) {
	                                    if (val == 'W1001') return '未关帐'; if (val == 'W1002') return '已关帐';
	                                }
	                            },
	                            {
	                                header: '操作',
	                                dataIndex: 'Status',
	                                id: 'operate',
	                                renderer: function(val) {
	                                    //if (val == 'W1001') return '<div><input type=button onclick="closeAccount();" value="关帐" /></div>'; if (val == 'W1002') return '<div><input type=button onclick="openAccount();" value="取消关帐" /></div>';
	                                    if (val == 'W1001') return '<div><a class="button" href="#" onclick="closeAccount();"><span>关帐</span></a> </div>';
	                                    if (val == 'W1002') return '<div><a class="button" href="#" onclick="openAccount();"><span>取消关帐</span></a></div>';
	                                }

	                            }
]),
                        bbar: new Ext.PagingToolbar({
                            pageSize: 10,
                            store: userGridData,
                            displayMsg: '显示第{0}条到{1}条记录,共{2}条',
                            emptyMsy: '没有记录',
                            displayInfo: true
                        }),
                        viewConfig: {
                            columnsText: '显示的列',
                            scrollOffset: 20,
                            sortAscText: '升序',
                            sortDescText: '降序',
                            forceFit: false 
                        },
                        height: 380,
                        closeAction: 'hide',
                        stripeRows: true,
                        loadMask: true//
                        //autoExpandColumn: 6
                    });
                    userGrid.render();
                    /*------DataGrid的函数结束 End---------------*/

                    updateDataGrid();

                })
</script>

</html>
