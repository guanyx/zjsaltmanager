<%@ Page Language="C#" AutoEventWireup="true" CodeFile="userManageGridEdit.aspx.cs"
    Inherits="sysadmin_userManagerGridEdit" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
    <title>�����ο�ʹ��ҳ��</title>
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
                    No.2000909090009<!--��c#��ȡ��-->
                </td>
                <td style="width: 5px">
                </td>
            </tr>
            <tr>
                <td align="center" valign="middle" style="font-size: larger;" colspan="2">
                    �㽭ʡ��ҵ���ź�������ҵ��˾���ֵ�
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
        <option value="��">��</option>
        <option value="��">��</option>
    </select>
</body>

<script type="text/javascript">
//���´��벻Ҫ�� 
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
//��grid��ϸ��¼��װ��json���ύ��UI��decode
var json='';
/*----------------topframe----------------*/
var topForm = new Ext.FormPanel({
            el:'topform',
            border : true,// û�б߿�
            labelAlign: 'left',
            buttonAlign: 'right',
            bodyStyle: 'padding:2px',
            height:70,
            frame: true ,
            labelWidth: 55,
            items: [{
                layout: 'column',   //�����Ԫ��Ϊ����Ϊ�в��ַ�ʽ
                border: false,
                items: [{
                    columnWidth: .25,  //����ռ�õĿ�ȣ���ʶΪ20��
                    layout: 'form',
                    border: false,
                    items: [{
                        xtype:'combo',
                        fieldLabel:'��������',
                        anchor:'95%',
                        id:'djlx'}]
                    }, {
                    columnWidth: .3,
                    layout: 'form',
                    border: false,
                    items: [{
                        xtype:'combo',
                        fieldLabel:'��Ӧ��',
                        anchor:'95%',
                        id:'gys'}]
                    },{
                    layout : 'table', 
                    columnWidth: .25,
                    items : [ {  
                         layout:'fit',
                         anchor:'95%',
                         html : '¼������:'
                        }, {  
                         columnWidth : .5,  
                         items : [new Ext.form.Radio( {  
                             id : 'Normal', 
                             name : 'Normal', 
                             anchor:'95%', 
                             boxLabel : '����'  
                         })]  
                        }, {  
                         columnWidth : .5,  
                         items : [new Ext.form.Radio( {  
                             id : 'RedFont',
                             name : 'RedFont',
                             anchor:'95%',  
                             boxLabel : '����'  
                         })]  
                        }] 
                    }, {
                    columnWidth: .2, //xtype:"panel", labelWidth:50
                    layout: 'form',
                    border: false,
                    items: [{
                        xtype:'label',
                        style:'vertical-align: bottom;',
                        text:'״̬'
                        },{
                        xtype:'label',
                        text:'',
                        y:5,
                        id:'zt'
                        }]
                }]
        },{
        layout: 'column',   //�����Ԫ��Ϊ����Ϊ�в��ַ�ʽ
        border: false,
        items: [{
                columnWidth: .25,  //����ռ�õĿ�ȣ���ʶΪ20��
                    layout: 'form',
                    border: false,
                    items: [{
                        xtype:'combo',
                        fieldLabel:'�ֹ�˾',
                        anchor:'95%',
                        id:'fgx'}]
                }, {
                    columnWidth: .3,
                    layout: 'form',
                    border: false,
                    items: [{
                        xtype:'combo',
                        fieldLabel:'�ֿ�����',
                        anchor:'95%',
                        id:'cgmc'}]
                }, {
                    columnWidth: .25,
                    layout: 'form',
                    border: false,
                    items: [{
                        xtype:'combo',
                        fieldLabel:'�ֹ�Ա',
                        anchor:'95%',
                        id:'cgy'}]
                }, {
                    columnWidth: .2,
                    layout: 'form',
                    border: false,
                    items: [{
                        xtype:'checkbox',
                        boxLabel:'�Ƿ��ʼ��',
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
       header: "�Ƿ�����",  
       dataIndex: 'USER_ISLOCKED',  
       width: 25  
    });
    
    var custTypeComBoxStore ;
    if (custTypeComBoxStore == null) { //��ֹ�ظ�����
        custTypeComBoxStore = new Ext.data.JsonStore({ 
        totalProperty : "results", 
        root : "root", 
        url : 'userManageGridEdit.aspx?method=getCustType', 
        fields : ['custId', 'custName'] 
            }); 
        custTypeComBoxStore.load();	
    }
    var comboCusType = new Ext.form.ComboBox({
        fieldLabel: '�û�����', //�����滻�ɲ�Ʒ
        name: 'userType',
        id:'userType',
        store: custTypeComBoxStore,
        displayField: 'custName',
        valueField: 'custId',
        mode: 'local',
        //loadText:'loading ...',
        typeAhead: true, //�Զ�����һ����������ѡ�ȫ����
        triggerAction: 'all',
        selectOnFocus: true,//��������
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
        return value ? value.dateFormat('Y��m��d��') : '';  
    }; 
	// shorthand alias  
    var fm = Ext.form;  
    /*------�������������� start ----------*/
    var bankComBoxStore ;    
    //���������б��store
    if (bankComBoxStore == null) { //��ֹ�ظ�����
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
        new Ext.grid.RowNumberer(),//�Զ��к�
        {  
           id:'USER_ID',  
           header: "�û����",  
           dataIndex: 'USER_ID',  
           width: 20,
           hidden:true,  
           editor: new fm.TextField({  
               allowBlank: true  
           })  
        },{  
           id:'USER_NAME',
           header: "�û�����",  
           dataIndex: 'USER_NAME',  
           width: 65,  
           editor: userNameCombo,
           renderer:function(value, cellmeta, record,rowIndex, columnIndex, store){
                  //���ֵ��ʾ����
                  //��ȡ��ǰid="combo_process"��comboBoxѡ���ֵ
                  var index = bankComBoxStore.findBy(function(record, id){
                        return record.get(getCmp('userIdComboIs').valueField)==value;}
                  );
                  var record = bankComBoxStore.getAt(index);
                  var displayText = "";
                  // ��������б�û�б�ѡ����ôrecordҲ�Ͳ����ڣ���ʱ�򣬷��ش�������value��
                  // �����value����grid��USER_REALNAME�е�value������ֱ�ӷ���
                  if (record == null) {
                  //����Ĭ��ֵ��
                    displayText = value;
                  } else {
                    displayText = record.data.bankName;//��ȡrecord�е����ݼ��е�process_name�ֶε�ֵ
                  }
                  return displayText;
            }
        },
        {  
           id:'USER_REALNAME',
           header: "��ʵ����",  
           dataIndex: 'USER_REALNAME',  
           width: 30,  
           editor: comboCusType,//�ⲿ����data, metadata, record, rowIndex, columnIndex, store
           renderer : function(value, cellmeta, record,rowIndex, columnIndex, store) {                
              //���ֵ��ʾ����
              //��ȡ��ǰid="combo_process"��comboBoxѡ���ֵ
              var index = custTypeComBoxStore.find(Ext.getCmp('userType').valueField, value);
              var record = custTypeComBoxStore.getAt(index);
              var displayText = "";
              // ��������б�û�б�ѡ����ôrecordҲ�Ͳ����ڣ���ʱ�򣬷��ش�������value��
              // �����value����grid��USER_REALNAME�е�value������ֱ�ӷ���
              if (record == null) {
              //����Ĭ��ֵ��
                displayText = value;
              } else {
                displayText = record.data.custName;//��ȡrecord�е����ݼ��е�process_name�ֶε�ֵ
              }              
              return displayText;
             }             
        },
        USER_ISLOCKEDColumn,
        {  
           id:"USER_BINDIP",
           header: "�Ƿ��IP",  
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
           header: "IP��ַ",  
           dataIndex: 'USER_IPADDRESS',  
           width: 30,  
           editor: new fm.TextField({  
               allowBlank: false,
               listeners:{blur:function(e){ alert(1)}} 
            })  
        },{  
           id:'CREATE_DATE',  
           header: "����ʱ��",  
           dataIndex: 'CREATE_DATE',  
           width: 20,  
           renderer: formatDate,  
           editor: new fm.DateField({  
                format: 'Y��m��d��',  
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
           {name: 'CREATE_DATE', mapping: 'CREATE_DATE', type: 'date', dateFormat: 'y��m��d��'}
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
            columnsText: '��ʾ����',
            scrollOffset: 20,
            sortAscText: '����',
            sortDescText: '����',
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
                        {//���һ�в�������
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
                USER_BINDIP: '��'   , 
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
            border : true,// û�б߿�
            labelAlign: 'left',
            buttonAlign: 'right',
            bodyStyle: 'padding:2px',
            height:85,
            frame: true ,
            labelWidth: 55,
            items: [{
                layout: 'column',   //�����Ԫ��Ϊ����Ϊ�в��ַ�ʽ
                border: false,
                items: [{
                    columnWidth: .5,  //����ռ�õĿ�ȣ���ʶΪ20��
                    layout: 'form',
                    border: false,
                    items: [{
                    layout : 'column', 
                    columnWidth: .5,
                    items : [ {  
                         layout:'fit',
                         anchor:'95%',
                         html : '��������:'
                        }, {  
                         columnWidth : .25,  
                         items : [new Ext.form.Radio( {  
                             id : 'None', 
                             name : 'None', 
                             anchor:'90%', 
                             boxLabel : '��'  
                         })]  
                        }, {  
                         columnWidth : .25,  
                         items : [new Ext.form.Radio( {  
                             id : 'Car', 
                             name : 'Car', 
                             anchor:'95%', 
                             boxLabel : '����'  
                         })]  
                        }, {  
                         columnWidth : .25,  
                         items : [new Ext.form.Radio( {  
                             id : 'Trian', 
                             name : 'Trian', 
                             anchor:'95%', 
                             boxLabel : '��'  
                         })]  
                        }, {  
                         columnWidth : .25,  
                         items : [new Ext.form.Radio( {  
                             id : 'Ship',
                             name : 'Ship',
                             anchor:'95%',  
                             boxLabel : '��'  
                         })]  
                        }] 
                    }]
             },{
             columnWidth: .5,  //����ռ�õĿ�ȣ���ʶΪ20��
                    layout: 'form',
                    border: false,
                    items: [{
                    layout : 'column', 
                    columnWidth: .5,
                    items : [ {  
                         layout:'fit',
                         anchor:'95%',
                         html : 'װж����:'
                        }, {  
                         columnWidth : .25,  
                         items : [new Ext.form.Radio( {  
                             id : 'ZxNone', 
                             name : 'ZxNone', 
                             anchor:'90%', 
                             boxLabel : '��'  
                         })]  
                        }, {  
                         columnWidth : .25,  
                         items : [new Ext.form.Radio( {  
                             id : 'ZxCar', 
                             name : 'ZxCar', 
                             anchor:'95%', 
                             boxLabel : '����'  
                         })]  
                        }, {  
                         columnWidth : .25,  
                         items : [new Ext.form.Radio( {  
                             id : 'ZxTrian', 
                             name : 'ZxTrian', 
                             anchor:'95%', 
                             boxLabel : '��'  
                         })]  
                        }, {  
                         columnWidth : .25,  
                         items : [new Ext.form.Radio( {  
                             id : 'ZxShip',
                             name : 'ZxShip',
                             anchor:'95%',  
                             boxLabel : '��'  
                         })]  
                        }]
                  }]
             }
             ]   
        },{//�ڶ���
        layout: 'column',   //�����Ԫ��Ϊ����Ϊ�в��ַ�ʽ
        border: false,
        items: [{//����
                columnWidth: .5, //xtype:"panel", labelWidth:50
                    layout: 'column',
                    border: false,
                    items: [{
                            columnWidth: .5,  //����ռ�õĿ�ȣ���ʶΪ20��
                            layout: 'form',
                            border: false,
                            items: [{
                                xtype:'textfield',
                                fieldLabel:'���䵥��',
                                anchor:'95%',
                                id:'ysdj'
                            }]
                        },{
                            columnWidth: .5,  //����ռ�õĿ�ȣ���ʶΪ20��
                            layout: 'form',
                            border: false,
                            items: [{
                                xtype:'textfield',
                                fieldLabel:'�������',
                                anchor:'95%',
                                id:'ysfy'
                            }]
                        }]
            },{//����
                columnWidth: .5, //xtype:"panel", labelWidth:50
                    layout: 'form',
                    border: false,
                    items: [{
                            columnWidth: .5,  //����ռ�õĿ�ȣ���ʶΪ20��
                            layout: 'form',
                            border: false,
                            items: [{
                                xtype:'combo',
                                fieldLabel:'װж��λ',
                                anchor:'80%',
                                id:'zxdw'
                            }]
                        }]
            }]
        },{//������
        layout: 'column',   //�����Ԫ��Ϊ����Ϊ�в��ַ�ʽ
        border: false,
        items: [{//����
                columnWidth: .5, //xtype:"panel", labelWidth:50
                    layout: 'form',
                    border: false,
                    html:'&nbsp'
            },{//����
                columnWidth: .5, //xtype:"panel", labelWidth:50
                    layout: 'column',
                    border: false,
                    items: [{
                            columnWidth: .5,  //����ռ�õĿ�ȣ���ʶΪ20��
                            layout: 'form',
                            border: false,
                            items: [{
                                xtype:'textfield',
                                fieldLabel:'װж����',
                                anchor:'95%',
                                id:'zxdj'
                            }]
                        },{
                            columnWidth: .5,  //����ռ�õĿ�ȣ���ʶΪ20��
                            layout: 'form',
                            border: false,
                            items: [{
                                xtype:'textfield',
                                fieldLabel:'װж����',
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
            border : true,// û�б߿�
            labelAlign: 'left',
            buttonAlign: 'center',
            bodyStyle: 'padding:2px',
            height:85,
            frame: true ,
            labelWidth: 55,
            items: [{//��һ��
                layout: 'column',   //�����Ԫ��Ϊ����Ϊ�в��ַ�ʽ
                border: false,
                items: [{
                    columnWidth: .3,  //����ռ�õĿ�ȣ���ʶΪ20��
                    layout: 'form',
                    border: false,
                    items: [{
                            xtype:'textfield',
                            fieldLabel:'����Ա',
                            readOnly:true,
                            id:'czy',
                            name:'czy'
                    }]
                },{
                    columnWidth: .4,  //����ռ�õĿ�ȣ���ʶΪ30��
                    layout: 'form',
                    border: false,
                    html:'&nbsp'
                },{
                    columnWidth: .3,  //����ռ�õĿ�ȣ���ʶΪ20��
                    layout: 'form',
                    border: false,
                    items: [{
                        xtype:'datefield',
                        //readOnly:true,
                        disabled:true,
                        fieldLabel:'��������',
                        anchor:'95%',
                        format: 'Y��m��d��',
                        value:(new Date()),
                        id:'jcrq',
                        name:'jcrq'
                    }]
                }]
        }],
        buttons: [{  
             text :"����",  
             scope:this ,
             handler:new function(){
               userListStore.each(function(userListStore){  
                   json += Ext.util.JSON.encode(userListStore.data) + ',';  
               });  
               json = json.substring(0, json.length - 1);  
               //Ȼ�����������
               /*
               Ext.Ajax.request({
                                            url:'customerManage.aspx?method=add',
                                             method:'POST',
                                             params:{
                                             //������
                                             djlx:Ext.getCmp('djlx').getValue(),
                                             bla,bla,bla......
                                             //��ϸ����
                                             DetailInfo:json
                                             },
                                             success: function(resp,opts){
                                               Ext.Msg.alert("��ʾ","����ɹ�");
                                               
                                             }
                                             ,failure: function(resp,opts){ 
                                               Ext.Msg.alert("��ʾ","����ʧ��");
                                             
                                             }
                                            });
                                            */
             } 
         },  
         {  
             text :"��ӡ",  
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
