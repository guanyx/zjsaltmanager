<%@ Page Language="C#" AutoEventWireup="true" CodeFile="userManageGridEdit.aspx.cs"
    Inherits="sysadmin_userManagerGridEdit" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
    <title>仅供参考使用页面</title>
    <meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
    <link rel="stylesheet" type="text/css" href="../../ext3/resources/css/ext-all.css" />

    <script type="text/javascript" src="../../ext3/adapter/ext/ext-base.js"></script>

    <script type="text/javascript" src="../../ext3/ext-all.js"></script>
    <script type="text/javascript" src="../../ext3/example/ItemDeleter.js"></script>
<style type="text/css">
.extensive-remove {
background-image: url(../../Theme/1/images/extjs/customer/cross.gif) ! important;
}
</style>
</head>
<body>
    <div id='title' style='width: 100%; height: 50px; overflow: hidden; padding-top: 5px; '>
        <table width="100%">
            <tr>
                <td align="right" valign="bottom">
                    No.2000909090009<!--从c#中取出-->
                </td>
                <td style="width: 5px">
                </td>
            </tr>
            <tr>
                <td align="center" valign="middle" style="font-size: larger;" colspan="2">
                    浙江省盐业集团杭州市盐业公司进仓单
                </td>
            </tr>
        </table>
    </div>
    <div id="topform">
    </div>
    <div id="userdatagrid">
    </div>
    <div id="transport">
    </div>
    <div id="footer">
    </div>
    <select id='bindipSelct' style="display: none;">
        <option value="是">是</option>
        <option value="否">否</option>
    </select>
</body>

<script type="text/javascript">
//以下代码不要动 
Ext.grid.CheckColumn = function(config){  
        Ext.apply(this, config);  
        if(!this.id){  
            this.id = Ext.id();  
        }  
        this.renderer = this.renderer.createDelegate(this);  
    };  
  
Ext.grid.CheckColumn.prototype ={  
        init : function(grid){  
            this.grid = grid;  
            this.grid.on('render', function(){  
                var view = this.grid.getView();  
                view.mainBody.on('mousedown', this.onMouseDown, this);  
            }, this);  
        }, 
        onMouseDown : function(e, t){  
            if(t.className && t.className.indexOf('x-grid3-cc-'+this.id) != -1){  
                e.stopEvent();  
                var index = this.grid.getView().findRowIndex(t);  
                var record = this.grid.store.getAt(index);  
                record.set(this.dataIndex, !record.data[this.dataIndex]);  
            }  
        },  
        renderer : function(v, p, record){  
            p.css += ' x-grid3-check-col-td';   
            return '<div class="x-grid3-check-col'+(v?'-on':'')+' x-grid3-cc-'+this.id+'"> </div>';  
        }
 };
var scope;
Ext.onReady(function(){
    scope=this; 
//将grid明细记录组装成json串提交到UI再decode
var json='';
/*----------------topframe----------------*/
var topForm = new Ext.FormPanel({
            el:'topform',
            border : true,// 没有边框
            labelAlign: 'left',
            buttonAlign: 'right',
            bodyStyle: 'padding:2px',
            height:70,
            frame: true ,
            labelWidth: 55,
            items: [{
                layout: 'column',   //定义该元素为布局为列布局方式
                border: false,
                items: [{
                    columnWidth: .25,  //该列占用的宽度，标识为20％
                    layout: 'form',
                    border: false,
                    items: [{
                        xtype:'combo',
                        fieldLabel:'单据类型',
                        anchor:'95%',
                        id:'djlx'}]
                    }, {
                    columnWidth: .3,
                    layout: 'form',
                    border: false,
                    items: [{
                        xtype:'combo',
                        fieldLabel:'供应商',
                        anchor:'95%',
                        id:'gys'}]
                    },{
                    layout : 'table', 
                    columnWidth: .25,
                    items : [ {  
                         layout:'fit',
                         anchor:'95%',
                         html : '录入类型:'
                        }, {  
                         columnWidth : .5,  
                         items : [new Ext.form.Radio( {  
                             id : 'Normal', 
                             name : 'Normal', 
                             anchor:'95%', 
                             boxLabel : '正常'  
                         })]  
                        }, {  
                         columnWidth : .5,  
                         items : [new Ext.form.Radio( {  
                             id : 'RedFont',
                             name : 'RedFont',
                             anchor:'95%',  
                             boxLabel : '红字'  
                         })]  
                        }] 
                    }, {
                    columnWidth: .2, //xtype:"panel", labelWidth:50
                    layout: 'form',
                    border: false,
                    items: [{
                        xtype:'label',
                        style:'vertical-align: bottom;',
                        text:'状态'
                        },{
                        xtype:'label',
                        text:'',
                        y:5,
                        id:'zt'
                        }]
                }]
        },{
        layout: 'column',   //定义该元素为布局为列布局方式
        border: false,
        items: [{
                columnWidth: .25,  //该列占用的宽度，标识为20％
                    layout: 'form',
                    border: false,
                    items: [{
                        xtype:'combo',
                        fieldLabel:'分公司',
                        anchor:'95%',
                        id:'fgx'}]
                }, {
                    columnWidth: .3,
                    layout: 'form',
                    border: false,
                    items: [{
                        xtype:'combo',
                        fieldLabel:'仓库名称',
                        anchor:'95%',
                        id:'cgmc'}]
                }, {
                    columnWidth: .25,
                    layout: 'form',
                    border: false,
                    items: [{
                        xtype:'combo',
                        fieldLabel:'仓管员',
                        anchor:'95%',
                        id:'cgy'}]
                }, {
                    columnWidth: .2,
                    layout: 'form',
                    border: false,
                    items: [{
                        xtype:'checkbox',
                        boxLabel:'是否初始单',
                        hideLabel:true,
                        anchor:'95%',
                        id:'sfcsd'}]
                }]
        }]      
});
topForm.render();
/*----------------topframe----------------*/
    
    
    // custom column plugin example  
    var USER_ISLOCKEDColumn = new Ext.grid.CheckColumn({  
       header: "是否锁定",  
       dataIndex: 'USER_ISLOCKED',  
       width: 25  
    });
    
    var custTypeComBoxStore ;
    if (custTypeComBoxStore == null) { //防止重复加载
        custTypeComBoxStore = new Ext.data.JsonStore({ 
        totalProperty : "results", 
        root : "root", 
        url : 'userManageGridEdit.aspx?method=getCustType', 
        fields : ['custId', 'custName'] 
            }); 
        custTypeComBoxStore.load();	
    }
    var comboCusType = new Ext.form.ComboBox({
        fieldLabel: '用户类型', //可以替换成产品
        name: 'userType',
        id:'userType',
        store: custTypeComBoxStore,
        displayField: 'custName',
        valueField: 'custId',
        mode: 'local',
        //loadText:'loading ...',
        typeAhead: true, //自动将第一个搜索到的选项补全输入
        triggerAction: 'all',
        selectOnFocus: true,//不能输入
        forceSelection: true,
        listeners:{ "select":function(combo, record, index){ 
            var rowIndex = userGrid.getStore().indexOf(userGrid.getSelectionModel().getSelected()); 
            var rowCount = userGrid.getStore().getCount(); 
            if((rowIndex==0&&rowCount==1)||rowIndex==rowCount-1){
                inserNewBlankRow();
            }
         
                //var t = userGrid.getSelectionModel().getSelected().data['USER_NAME'];
                //var tText = userGrid.getStore().getAt(rowIndex + 1).get("USER_NAME");
                
                
           
            
         
          //alert(userGrid.getView().getCell(0,3)/.innerHTML);
            //alert(userGrid.getStore().getAt(rowIndex).get("USER_NAME"));
            //var rowCount = userGrid.getStore().getCount();
            //alert(rowCount+":"+rowIndex);
            //if(rowIndex+1<rowCount)
                
        }}
    });
    
    function formatDate(value){  
        return value ? value.dateFormat('Y年m月d日') : '';  
    }; 
	// shorthand alias  
    var fm = Ext.form;  
    /*------定义银行下拉框 start ----------*/
    var bankComBoxStore ;    
    //用于下拉列表的store
    if (bankComBoxStore == null) { //防止重复加载
        bankComBoxStore = new Ext.data.JsonStore({ 
        totalProperty : "results", 
        root : "root", 
        url : '../../CRM/customer/customerManage.aspx?method=getAllBank', 
        fields : ['bankId', 'bankName'] 
            }); 
        bankComBoxStore.load();	
    }
    var userNameCombo = new fm.ComboBox({  
            store: bankComBoxStore,
            displayField: 'bankName',
            valueField: 'bankId',
            triggerAction: 'all',
            id:'userIdComboIs',
            pageSize: 5,  
            minChars: 2,  
            hideTrigger: true,  
            typeAhead: true,  
            mode: 'remote',      
            emptyText: 'Select a Part...',   
            selectOnFocus: false,
            editable: true,
            listeners:{ 
            "select":function(combo, record, index){ 
                var rowIndex = userGrid.getStore().indexOf(userGrid.getSelectionModel().getSelected()); 
                var rowCount = userGrid.getStore().getCount(); 
                if((rowIndex==0&&rowCount==1)||rowIndex==rowCount-1){
                    inserNewBlankRow();
                }  
             }              
        }});
    var itemDeleter = new Extensive.grid.ItemDeleter();
    var sm= new Ext.grid.CheckboxSelectionModel({singleSelect : true});
    var cm = new Ext.grid.ColumnModel([
        new Ext.grid.RowNumberer(),//自动行号
        {  
           id:'USER_ID',  
           header: "用户编号",  
           dataIndex: 'USER_ID',  
           width: 20,
           hidden:true,  
           editor: new fm.TextField({  
               allowBlank: true  
           })  
        },{  
           id:'USER_NAME',
           header: "用户名称",  
           dataIndex: 'USER_NAME',  
           width: 65,  
           editor: userNameCombo,
           renderer:function(value, cellmeta, record,rowIndex, columnIndex, store){
                  //解决值显示问题
                  //获取当前id="combo_process"的comboBox选择的值
                  var index = bankComBoxStore.findBy(function(record, id){
                        return record.get(getCmp('userIdComboIs').valueField)==value;}
                  );
                  var record = bankComBoxStore.getAt(index);
                  var displayText = "";
                  // 如果下拉列表没有被选择，那么record也就不存在，这时候，返回传进来的value，
                  // 而这个value就是grid的USER_REALNAME列的value，所以直接返回
                  if (record == null) {
                  //返回默认值，
                    displayText = value;
                  } else {
                    displayText = record.data.bankName;//获取record中的数据集中的process_name字段的值
                  }
                  return displayText;
            }
        },
        {  
           id:'USER_REALNAME',
           header: "真实姓名",  
           dataIndex: 'USER_REALNAME',  
           width: 30,  
           editor: comboCusType,//外部定义data, metadata, record, rowIndex, columnIndex, store
           renderer : function(value, cellmeta, record,rowIndex, columnIndex, store) {                
              //解决值显示问题
              //获取当前id="combo_process"的comboBox选择的值
              var index = custTypeComBoxStore.find(Ext.getCmp('userType').valueField, value);
              var record = custTypeComBoxStore.getAt(index);
              var displayText = "";
              // 如果下拉列表没有被选择，那么record也就不存在，这时候，返回传进来的value，
              // 而这个value就是grid的USER_REALNAME列的value，所以直接返回
              if (record == null) {
              //返回默认值，
                displayText = value;
              } else {
                displayText = record.data.custName;//获取record中的数据集中的process_name字段的值
              }              
              return displayText;
             }             
        },
        USER_ISLOCKEDColumn,
        {  
           id:"USER_BINDIP",
           header: "是否绑定IP",  
           dataIndex: "USER_BINDIP",
           width: 20,  
           editor: new fm.ComboBox({  
               typeAhead: true,  
               triggerAction: 'all',  
               transform:'bindipSelct',  
               lazyRender:true,  
               listClass: 'x-combo-list-small'  
            })  
        }
        ,{  
           id:'USER_IPADDRESS',  
           header: "IP地址",  
           dataIndex: 'USER_IPADDRESS',  
           width: 30,  
           editor: new fm.TextField({  
               allowBlank: false,
               listeners:{blur:function(e){ alert(1)}} 
            })  
        },{  
           id:'CREATE_DATE',  
           header: "创建时间",  
           dataIndex: 'CREATE_DATE',  
           width: 20,  
           renderer: formatDate,  
           editor: new fm.DateField({  
                format: 'Y年m月d日',  
                minValue: '01/01/06',  
                disabledDays: [0, 6],  
                disabledDaysText: 'Day are not available'  
            })  
        },itemDeleter
    ]);  
    cm.defaultSortable = true;  
   
    
    var RowPattern = Ext.data.Record.create([  
           {name: 'USER_ID', type: 'string'},  
           {name: 'USER_NAME', type: 'string'},  
           {name: 'USER_REALNAME', type: 'string'},  
           {name: 'USER_ISLOCKED',type: 'bool'},  
           {name: 'USER_BINDIP'},    
           {name: 'USER_IPADDRESS', type: 'string'},       // automatic date conversions  
           {name: 'CREATE_DATE', mapping: 'CREATE_DATE', type: 'date', dateFormat: 'y年m月d日'}
          ]);   
    var userListStore = new Ext.data.Store
	({
	    url: 'userManager.aspx?method=getUser',
	    reader: new Ext.data.JsonReader({
	        totalProperty: 'totalProperty',
	        root: 'root'
	    },RowPattern),
	    sortInfo:{field:'USER_ID', direction:'ASC'}
	});
//grid
    var userGrid = new Ext.grid.EditorGridPanel({
        store: userListStore,
        cm: cm,  
        selModel: itemDeleter,
        layout: 'fit',
        renderTo: 'userdatagrid',  
        width:'100%',  
        height:200,  
        stripeRows: true,
        frame:true,  
        plugins:USER_ISLOCKEDColumn,  
        clicksToEdit:1,
        viewConfig: {
            columnsText: '显示的列',
            scrollOffset: 20,
            sortAscText: '升序',
            sortDescText: '降序',
            forceFit: true
        },
        listeners:{
            afteredit: function(e){ 
                /*
                grid - This grid
                record - The record being edited
                field - The field name being edited
                value - The value being set
                originalValue - The original value for the field, before the edit.
                row - The grid row index
                column - The grid column index
                */
                    alert(e.record.data.USER_NAME);
                    alert(e.row+":"+e.column);
                    if(e.row<e.grid.getStore().getCount()){
                        e.grid.stopEditing();
                        if(e.column < e.record.fields.getCount()-1)
                        {//最后一行操作不算
                            alert('e.column+1');
                             e.grid.startEditing(e.row, e.column+1);
                        }
                        else
                        {
                            alert('e.row+1')
                             e.grid.startEditing(e.row+1, 1);
                        }
                    }
                    
                }
           }
    });

    //userGrid.getColumnModel().getColumnById(userGrid.getColumnModel().getColumnId(1)).css='x-grid-back-red';

//    function renderForProfile(data, cell, record, rowIndex, columnIndex, store){
//        cell.css = "graycell";
//        return data;
//    };

//  userGrid.getColumnModel().setRenderer(1,renderForProfile);
//  userGrid.getView().refresh( );


    //userListStore.load(); 
    inserNewBlankRow();

    function inserNewBlankRow(){
        var rowCount = userGrid.getStore().getCount();
        //alert(rowCount);
        var insertPos = parseInt( rowCount );
        var addRow = new RowPattern({
                USER_ID: '',  
                USER_NAME: '',  
                USER_REALNAME: '',  
                USER_ISLOCKED: false, 
                USER_BINDIP: '否'   , 
                USER_IPADDRESS:'',
                CREATE_DATE: (new Date()).clearTime() 
                });
        userGrid.stopEditing();       
        if ( insertPos > 0 ) { 
            var rowIndex = userListStore.insert( insertPos, addRow);
            userGrid.startEditing(insertPos, 0);
        } 
        else {
            var rowIndex = userListStore.insert( 0,addRow);
            userGrid.startEditing(0, 0);
        }    
    }
    
/*----------------tansportframe----------------*/
var transportForm = new Ext.FormPanel({
            el:'transport',
            border : true,// 没有边框
            labelAlign: 'left',
            buttonAlign: 'right',
            bodyStyle: 'padding:2px',
            height:85,
            frame: true ,
            labelWidth: 55,
            items: [{
                layout: 'column',   //定义该元素为布局为列布局方式
                border: false,
                items: [{
                    columnWidth: .5,  //该列占用的宽度，标识为20％
                    layout: 'form',
                    border: false,
                    items: [{
                    layout : 'column', 
                    columnWidth: .5,
                    items : [ {  
                         layout:'fit',
                         anchor:'95%',
                         html : '运输类型:'
                        }, {  
                         columnWidth : .25,  
                         items : [new Ext.form.Radio( {  
                             id : 'None', 
                             name : 'None', 
                             anchor:'90%', 
                             boxLabel : '无'  
                         })]  
                        }, {  
                         columnWidth : .25,  
                         items : [new Ext.form.Radio( {  
                             id : 'Car', 
                             name : 'Car', 
                             anchor:'95%', 
                             boxLabel : '汽车'  
                         })]  
                        }, {  
                         columnWidth : .25,  
                         items : [new Ext.form.Radio( {  
                             id : 'Trian', 
                             name : 'Trian', 
                             anchor:'95%', 
                             boxLabel : '火车'  
                         })]  
                        }, {  
                         columnWidth : .25,  
                         items : [new Ext.form.Radio( {  
                             id : 'Ship',
                             name : 'Ship',
                             anchor:'95%',  
                             boxLabel : '船'  
                         })]  
                        }] 
                    }]
             },{
             columnWidth: .5,  //该列占用的宽度，标识为20％
                    layout: 'form',
                    border: false,
                    items: [{
                    layout : 'column', 
                    columnWidth: .5,
                    items : [ {  
                         layout:'fit',
                         anchor:'95%',
                         html : '装卸类型:'
                        }, {  
                         columnWidth : .25,  
                         items : [new Ext.form.Radio( {  
                             id : 'ZxNone', 
                             name : 'ZxNone', 
                             anchor:'90%', 
                             boxLabel : '无'  
                         })]  
                        }, {  
                         columnWidth : .25,  
                         items : [new Ext.form.Radio( {  
                             id : 'ZxCar', 
                             name : 'ZxCar', 
                             anchor:'95%', 
                             boxLabel : '汽车'  
                         })]  
                        }, {  
                         columnWidth : .25,  
                         items : [new Ext.form.Radio( {  
                             id : 'ZxTrian', 
                             name : 'ZxTrian', 
                             anchor:'95%', 
                             boxLabel : '火车'  
                         })]  
                        }, {  
                         columnWidth : .25,  
                         items : [new Ext.form.Radio( {  
                             id : 'ZxShip',
                             name : 'ZxShip',
                             anchor:'95%',  
                             boxLabel : '船'  
                         })]  
                        }]
                  }]
             }
             ]   
        },{//第二行
        layout: 'column',   //定义该元素为布局为列布局方式
        border: false,
        items: [{//左列
                columnWidth: .5, //xtype:"panel", labelWidth:50
                    layout: 'column',
                    border: false,
                    items: [{
                            columnWidth: .5,  //该列占用的宽度，标识为20％
                            layout: 'form',
                            border: false,
                            items: [{
                                xtype:'textfield',
                                fieldLabel:'运输单价',
                                anchor:'95%',
                                id:'ysdj'
                            }]
                        },{
                            columnWidth: .5,  //该列占用的宽度，标识为20％
                            layout: 'form',
                            border: false,
                            items: [{
                                xtype:'textfield',
                                fieldLabel:'运输费用',
                                anchor:'95%',
                                id:'ysfy'
                            }]
                        }]
            },{//右列
                columnWidth: .5, //xtype:"panel", labelWidth:50
                    layout: 'form',
                    border: false,
                    items: [{
                            columnWidth: .5,  //该列占用的宽度，标识为20％
                            layout: 'form',
                            border: false,
                            items: [{
                                xtype:'combo',
                                fieldLabel:'装卸单位',
                                anchor:'80%',
                                id:'zxdw'
                            }]
                        }]
            }]
        },{//第三行
        layout: 'column',   //定义该元素为布局为列布局方式
        border: false,
        items: [{//左列
                columnWidth: .5, //xtype:"panel", labelWidth:50
                    layout: 'form',
                    border: false,
                    html:'&nbsp'
            },{//右列
                columnWidth: .5, //xtype:"panel", labelWidth:50
                    layout: 'column',
                    border: false,
                    items: [{
                            columnWidth: .5,  //该列占用的宽度，标识为20％
                            layout: 'form',
                            border: false,
                            items: [{
                                xtype:'textfield',
                                fieldLabel:'装卸单价',
                                anchor:'95%',
                                id:'zxdj'
                            }]
                        },{
                            columnWidth: .5,  //该列占用的宽度，标识为20％
                            layout: 'form',
                            border: false,
                            items: [{
                                xtype:'textfield',
                                fieldLabel:'装卸费用',
                                anchor:'95%',
                                id:'zxjf'
                            }]
                        }]
            }]
        }]      
});
transportForm.render();
/*----------------tansportframe----------------*/
/*----------------footerframe----------------*/
var footerForm = new Ext.FormPanel({
            el:'footer',
            border : true,// 没有边框
            labelAlign: 'left',
            buttonAlign: 'center',
            bodyStyle: 'padding:2px',
            height:85,
            frame: true ,
            labelWidth: 55,
            items: [{//第一行
                layout: 'column',   //定义该元素为布局为列布局方式
                border: false,
                items: [{
                    columnWidth: .3,  //该列占用的宽度，标识为20％
                    layout: 'form',
                    border: false,
                    items: [{
                            xtype:'textfield',
                            fieldLabel:'操作员',
                            readOnly:true,
                            id:'czy',
                            name:'czy'
                    }]
                },{
                    columnWidth: .4,  //该列占用的宽度，标识为30％
                    layout: 'form',
                    border: false,
                    html:'&nbsp'
                },{
                    columnWidth: .3,  //该列占用的宽度，标识为20％
                    layout: 'form',
                    border: false,
                    items: [{
                        xtype:'datefield',
                        //readOnly:true,
                        disabled:true,
                        fieldLabel:'进仓日期',
                        anchor:'95%',
                        format: 'Y年m月d日',
                        value:(new Date()),
                        id:'jcrq',
                        name:'jcrq'
                    }]
                }]
        }],
        buttons: [{  
             text :"保存",  
             scope:this ,
             handler:new function(){
               userListStore.each(function(userListStore){  
                   json += Ext.util.JSON.encode(userListStore.data) + ',';  
               });  
               json = json.substring(0, json.length - 1);  
               //然后传入参数保存
               /*
               Ext.Ajax.request({
                                            url:'customerManage.aspx?method=add',
                                             method:'POST',
                                             params:{
                                             //主参数
                                             djlx:Ext.getCmp('djlx').getValue(),
                                             bla,bla,bla......
                                             //明细参数
                                             DetailInfo:json
                                             },
                                             success: function(resp,opts){
                                               Ext.Msg.alert("提示","保存成功");
                                               
                                             }
                                             ,failure: function(resp,opts){ 
                                               Ext.Msg.alert("提示","保存失败");
                                             
                                             }
                                            });
                                            */
             } 
         },  
         {  
             text :"打印",  
             scope:this,  
             handler  : new function(){
             }  
         }]  
}); 
footerForm.render();


/*----------------footerframe----------------*/    
});

</script>

</html>
